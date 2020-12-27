#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

#define WC 0
#define RC 1
#define LOG 2

#define mutex 0
#define wrt 1

#define NSV 5
int sv_array[NSV] = {0, 0, 0, 0, 0};

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_reverse_number(void){
  int num = 0;

  num = myproc()->tf->ebx;

  char answer[16] = {"\0"};

  int tmp = 0;
  do{
    answer[tmp] = (char) ((num % 10) + '0');
    num /= 10;
    tmp++;
  }while(num);

  cprintf("%s\n" , answer);
  return 0;
}

int 
sys_get_children(void){
  int pid;
  argptr(0 , (void*)&pid , sizeof(pid));
  int result = get_children(pid);
  return result;
}

int
sys_trace_syscalls(void){
  int state;
  argint(0, &state);
  trace_syscalls(state);
  return 0;
}

int
sys_semaphore_initialize(void)
{
  int i, v, m;
  argint(0, &i);
  argint(1, &v);
  argint(2, &m);
  semaphore_init(i, v, m);
  return 0;
}

int
sys_semaphore_acquire(void)
{
  int i/*, pid */;
  argint(0, &i);
  // pid = myproc()->pid;
  semaphore_acquire(i, myproc());
  return 0;
}

int
sys_semaphore_release(void)
{
  int i;
  argint(0, &i);
  semaphore_release(i);
  return 0;
}

int
sys_cv_wait(void)
{
  int cv_cast;
  argint(0, &cv_cast);

  condition_var* cv = (condition_var*)(cv_cast);
  
  sleep1(cv, &cv->lock);
  return 0;
}

int
sys_cv_signal(void)
{
  int cv_cast;
  argint(0, &cv_cast);

  condition_var* cv = (condition_var*)(cv_cast);
  
  wakeup(cv);
  return 0;
}

int
sys_p_cv_signal(void)
{
  cli();
  int cv_ind;
  argint(0, &cv_ind);
  
  p_wakeup(cv_ind);
  sti();
  return 0;
}

int
sys_p_cv_wait(void)
{
  cli();
  int cv_ind;
  argint(0, &cv_ind);
  
  p_sleep1(cv_ind);
  sti();
  return 0;
}

int
sys_chsv(void)
{
  cli();
  int sv_index, sv_change_val;
  argint(0, &sv_index);
  argint(1, &sv_change_val);

  sv_array[sv_index] += sv_change_val;
  sti();
  return sv_array[sv_index];
}

int
sys_p_lock(void)
{
  cli();
  int ind;
  argint(0, &ind);
  pp_lock(ind);
  sti();
  return 0;
}

int
sys_p_unlock(void)
{
  cli();
  int ind;
  argint(0, &ind);
  pp_unlock(ind);
  sti();
  return 0;
}

int
sys_print_log(void)
{
  cli();
  int val;
  argint(0, &val);
  if(val == 0)
  {
    cprintf("Writer waits for wrt...\n");
  }
  else if(val == 1)
  {
    cprintf("log_val = %d\n", sv_array[LOG]);
  }
  else if(val == 2)
  {
    cprintf("Goodbye writer with pid %d\n", myproc()->pid);
  }
  else if(val == 3)
  {
    cprintf("LOG = %d / reader = %d\n" , sv_array[LOG] , myproc()->pid);
  }
  else if(val == 4)
  {
    cprintf("Goodbye reader with pid %d\n", myproc()->pid);
  }
  else if(val % 2 == 0)
  {
    int cint = val / 2 - 5;
    char c[2] = {(char)(cint), '\0'};
    cprintf("Producer: wrote char '%s'\n", c);
  }
  else if(val % 2 == 1)
  {
    int cint = (val - 1) / 2 - 5;
    char c[2] = {(char)(cint), '\0'};
    cprintf("Consumer: read char '%s'\n", c);
  }
  sti();
  return 0;
}

int
sys_cqenq(void)
{
  int cint;
  argint(0, &cint);
  char c = (char)(cint);

  charq_enq(c);
  return 0;
}

int
sys_cqdeq(void)
{
  char c = charq_deq();
  return (int)(c);
}