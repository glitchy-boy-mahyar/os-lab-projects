#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  int trace, trace_pid;
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
  ptable.trace = 0;
  ptable.trace_pid = -1;
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure

int
sys_uptime_fake(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->q_level = 2;
  p->num_tickets = 10;
  p->age = 0;
  p->arrival_time = sys_uptime_fake();
  p->executed_cycle = 0;
  p->executed_cycle_ratio = 0;
  p->arrival_ratio = 0;
  p->priority_ratio = 0;
  p->cycle_count = 0;

  memset(p->syscall_cnt, 0, sizeof p->syscall_cnt);
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  if (pid == initproc->pid + 1)
    ptable.trace_pid = pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

int get_children_pid_number(int parent_id){
  int result = parent_id;
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent->pid == parent_id){
      int cur = get_children_pid_number(p->pid);
      while(cur > 0){
        result = 10 * result + (cur % 10);
        cur /= 10;
      }
    }
  }
  return result;
}

int get_children(int parent_id){
  int answer = get_children_pid_number(parent_id);
  return answer;
}


const char* syscall_names[N_SYSCALL] = {
  "fork", "exit", "wait", "pipe", "read",
  "kill", "exec", "fstat", "chdir", "dup",
  "getpid", "sbrk", "sleep", "uptime", "open",
  "write", "mknod", "unlink", "link", "mkdir",
  "close", "reverse_number", "get_children", "trace_syscalls",
};

void
swtch_ptbl_tr(int tr)
{
  ptable.trace = tr;
}

void
print_proc_syscalls(struct proc* curproc)
{
  cprintf("%s:\n", curproc->name);
  for(int i = 0; i < N_SYSCALL; i++){
    if(curproc->syscall_cnt[i] > 0){
      cprintf("    %s: %d\n", syscall_names[i], curproc->syscall_cnt[i]);
    }
  }
}

void
trace_syscalls(int state)
{
  struct proc* curproc = myproc();
  if(curproc->pid != ptable.trace_pid) {
    swtch_ptbl_tr(state);
    return;
  }

  if(ptable.trace == 0)
    return;

  cprintf("\n");
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(EMBRYO < p->state && p->state < ZOMBIE)
      print_proc_syscalls(p);
  }
  cprintf("\n");
}

int n_tu(int number, int count)
{
    int result = 1;
    while(count-- > 0)
        result *= number;

    return result;
}


void float_to_string(float fVal)
{
    char result[100];
    int dVal, dec, i;

    char answer[100] = {0};

    fVal += 0.005;   // added after a comment from Matt McNabb, see below.

    dVal = fVal;
    dec = (int)(fVal * 100) % 100;

    memset(result, 0, 100);
    result[0] = (dec % 10) + '0';
    result[1] = (dec / 10) + '0';
    result[2] = '.';

    i = 3;
    while (dVal > 0)
    {
        result[i] = (dVal % 10) + '0';
        dVal /= 10;
        i++;
    }

    int tmp = 0;
    for (i=strlen(result)-1; i>=0; i--){
        answer[tmp] = result[i];
        tmp++;
    }

    cprintf("%s ", answer);
}

void
print_procs_info(void){
  char* states[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };

  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;

    double priority = 1 / (double) p->num_tickets;
    double rank = (priority * p->priority_ratio) + (p->arrival_time * p->arrival_ratio) \
                  + (p->executed_cycle * p->executed_cycle_ratio);

    cprintf("%s %d %s %d %d " , p->name, p->pid, states[p->state], p->q_level, p->num_tickets);
    float_to_string(p->priority_ratio);
    float_to_string(p->arrival_ratio);
    float_to_string(p->executed_cycle_ratio);
    float_to_string(rank);
    cprintf("%d \n", p->cycle_count);
  }  
}

void
change_queue(int pid , int new_queue){
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED || p->pid != pid)
      continue;
    p->q_level = new_queue;
  }    
}

void
change_ticket(int pid, int new_ticket){
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED || p->pid != pid)
      continue;
    p->num_tickets = new_ticket;
  }    
}

// double stod(const char* s); //declaration

// double d = stod(row[0]); //call

double stod(const char* s){    //definition
    double rez = 0, fact = 1;
    if (*s == '-'){
        s++;
        fact = -1;
    };
    for (int point_seen = 0; *s; s++){
        if (*s == '.'){
            point_seen = 1;
            continue;
        };
        int d = *s - '0';
        if (d >= 0 && d <= 9){
            if (point_seen) fact /= 10.0f;
            rez = rez * 10.0f + (float)d;
        };
    };
    return rez * fact;
}

void 
change_BJF_parameters_individual(int pid, char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED || p->pid != pid)
      continue;
    p->priority_ratio = stod(priority_ratio);
    p->arrival_ratio = stod(arrival_ratio);
    p->executed_cycle_ratio = stod(executed_cycle_ratio);
  }   
}

void
change_BJF_parameters_all(char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    p->priority_ratio = stod(priority_ratio);
    p->arrival_ratio = stod(arrival_ratio);
    p->executed_cycle_ratio = stod(executed_cycle_ratio);
  }   
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
/* This algorithm is mentioned in the ISO C standard, here extended
   for 32 bits.  */
int
rand_r (unsigned int *seed)
{
  unsigned int next = *seed;
  int result;

  next *= 1103515245;
  next += 12345;
  result = (unsigned int) (next / 65536) % 2048;

  next *= 1103515245;
  next += 12345;
  result <<= 10;
  result ^= (unsigned int) (next / 65536) % 1024;

  next *= 1103515245;
  next += 12345;
  result <<= 10;
  result ^= (unsigned int) (next / 65536) % 1024;

  *seed = next;

  return result;
}

const int AGE_THRESH = 10000;

void
scheduler(void)
{
  struct proc *p;
  struct proc *temp_proc;
  struct cpu *c = mycpu();
  c->proc = 0;

  int total_tickets = 0;
  unsigned int seed = 1;

  for(;;){
    // Enable interrupts on this processor.
    sti();
    int proc_count[4] = {0,0,0,0};
    //counting ptable runnable processes

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if(p->state == RUNNABLE)
      {
        if (p->age > AGE_THRESH && p->q_level != 1)
        {
          p->q_level--;
          p->age = 0;
        }
        
        if(p->q_level == 2)
        {
          total_tickets += p->num_tickets;
        }
        proc_count[p->q_level]++;
      }
    }
    //cprintf("%d %d %d\n", proc_count[1], proc_count[2], proc_count[3]);


    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    // Round Robin algorithm to fekr
    if(proc_count[1])
    {  
      //cprintf("aaaaaaaa\n");
      for(p = ptable.proc; p < &ptable.proc[NPROC] ; p++){
        if(p->state != RUNNABLE || p->q_level != 1)
          continue;

        p->cycle_count++;
        seed++;
        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.
        c->proc = p;
        switchuvm(p);
        p->state = RUNNING;

        swtch(&(c->scheduler), p->context);
        switchkvm();

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
      }
      release(&ptable.lock);
      continue;
    }

    // Lottery algorithm
    else if(proc_count[2])
    {
      int count = 0;
      int golden_ticket = rand_r(&seed) % total_tickets;
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state != RUNNABLE || p->q_level != 2)
          continue;

        if ((count + p->num_tickets) < golden_ticket)
        {
          count += p->num_tickets;
          continue;
        }
        
        for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
        {
          if(temp_proc->state != UNUSED && temp_proc != p)
            temp_proc->age++;
        }

        p->cycle_count++;
        seed++;
        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.
        c->proc = p;
        switchuvm(p);
        p->state = RUNNING;

        swtch(&(c->scheduler), p->context);
        switchkvm();

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
        break;
      }
      release(&ptable.lock);
      continue;
    }

    // Blow job first algorithm
    else if(proc_count[3])
    {
      struct proc* run_proc = 0;
      double min_rank = 100000;
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state != RUNNABLE || p->q_level != 3)
          continue;
        double priority = 1 / (double) p->num_tickets;
        double rank = (priority * p->priority_ratio) + (p->arrival_time * p->arrival_ratio) \
                      + (p->executed_cycle * p->executed_cycle_ratio);

        if(min_rank > rank)
        {
          min_rank = rank;
          run_proc = p;
        }
      }
      
      if(!run_proc){
        release(&ptable.lock);
        continue;
      }

      //running run_proc
      for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
      {
        if(temp_proc->state != UNUSED && temp_proc != run_proc)
          temp_proc->age++;
      }

      run_proc->cycle_count++;
      seed++;
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = run_proc;
      switchuvm(run_proc);
      run_proc->state = RUNNING;

      swtch(&(c->scheduler), run_proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      run_proc->executed_cycle += 0.1;
      c->proc = 0;
      release(&ptable.lock);
    }
    
    else{
      release(&ptable.lock);
    }
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
