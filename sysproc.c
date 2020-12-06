#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

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
sys_print_procs_info(void){
  print_procs_info();
  return 0;
}

int
sys_change_queue(void){
  int pid, new_queue;
  argptr(0 , (void*)&pid , sizeof(pid));
  argptr(1 , (void*)&new_queue , sizeof(new_queue));

  change_queue(pid , new_queue);
  return 0;
}

int
sys_change_ticket(void){
  int pid, new_ticket;
  argptr(0 , (void*)&pid , sizeof(pid));
  argptr(1 , (void*)&new_ticket , sizeof(new_ticket));

  change_ticket(pid, new_ticket);
  return 0;
}

int
sys_change_BJF_parameters_individual(void){
  int pid;

  char* ratio[3];

  argptr(0 , (void*)&pid , sizeof(pid));
  argstr(1 , (void*)&ratio[0]);
  argstr(2 , (void*)&ratio[1]);
  argstr(3 , (void*)&ratio[2]);

  change_BJF_parameters_individual(pid, ratio[0], ratio[1], ratio[2]);
  return 0; 
}

int
sys_change_BJF_parameters_all(void){
  char* ratio[3];

  argstr(0 , (void*)&ratio[0]);
  argstr(1 , (void*)&ratio[1]);
  argstr(2 , (void*)&ratio[2]); 

  change_BJF_parameters_all(ratio[0], ratio[1], ratio[2]);
  return 0;
}