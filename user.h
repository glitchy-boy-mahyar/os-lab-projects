#include "spinlock.h"

struct stat;
struct rtcdate;

// system calls
int fork(void);
int exit(void) __attribute__((noreturn));
int wait(void);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
void reverse_number(int);
int get_children(int);
void trace_syscalls(int);
void semaphore_initialize(int, int, int);
void semaphore_acquire(int);
void semaphore_release(int);
int cv_wait(condition_var*);
int cv_signal(condition_var*);
int p_cv_wait(int);
int p_cv_signal(int);
int chsv(int, int);
void p_lock(int);
void p_unlock(int);
void print_log(int);

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void printf(int, const char*, ...);
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);

void init_lock(struct spinlock*);
void lock(struct spinlock*);
void unlock(struct spinlock*);