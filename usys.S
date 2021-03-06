#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(reverse_number)
SYSCALL(get_children)
SYSCALL(trace_syscalls)
SYSCALL(semaphore_initialize)
SYSCALL(semaphore_acquire)
SYSCALL(semaphore_release)
SYSCALL(cv_wait)
SYSCALL(cv_signal)
SYSCALL(p_cv_signal)
SYSCALL(p_cv_wait)
SYSCALL(chsv)
SYSCALL(p_lock)
SYSCALL(p_unlock)
SYSCALL(print_log)
SYSCALL(cqenq)
SYSCALL(cqdeq)