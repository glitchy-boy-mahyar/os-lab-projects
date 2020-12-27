#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define MTX 0
#define EMP 1
#define FULL 2

#define BUF_SZ 5

#define NP 8
const char msg[NP] = "shazam!";

void
producer()
{
    for(int i = 0; i < NP - 1; ++i){
        semaphore_acquire(EMP);
        semaphore_acquire(MTX);

        // Actually produce sth
        print_log(((int)(msg[i]) + 5) * 2);

        semaphore_release(MTX);
        semaphore_release(FULL);
    }
}

void
consumer()
{
    for(int i = 0; i < NP - 1; ++i){
        semaphore_acquire(FULL);
        semaphore_acquire(MTX);
        
        // Actually consume sth
        print_log(((int)(msg[i]) + 5) * 2 + 1);

        semaphore_release(MTX);
        semaphore_release(EMP);
    }
}

int
main()
{
    semaphore_initialize(MTX, 1, 0);
    semaphore_initialize(EMP, BUF_SZ, 0);
    semaphore_initialize(FULL, 0, 0);
    
    int pid = fork();
    if(pid == 0)
        consumer();

    else if(pid > 0){
        producer();
        wait();
    }

    exit();
}