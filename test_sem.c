#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main() {
    semaphore_initialize(0, 1, 0);
    
    semaphore_acquire(0);
    semaphore_release(0);
    semaphore_acquire(0);
    semaphore_release(0);
    printf(1, "halfway there\n");
    
    semaphore_initialize(1, 1, 0);
    semaphore_acquire(1);

    int pid = fork();
    if(pid == 0){
        semaphore_acquire(1);
        printf(1, "bitch finally got over that shit\n");
        semaphore_release(1);
        printf(1, "time to go\n");
        // exit();
    }
    else if(pid > 0){
        printf(1, "you seriously want this lock, bitch?\n");
        sleep(100);
        semaphore_release(1);
        sleep(100);
        printf(1, "now what? should i wait?\n");
        wait();
        printf(1, "got over that bastard\n");
    }
    // semaphore_acquire(0);
    printf(1, "sounds good so far for me (%d)\n", getpid());
    exit();
    
    // int x = 0;
    // struct spinlock lk;
    // init_lock(&lk);
    // lock(&lk);

    // x = 2;
    // printf(1, "x is now %d\n", x);

    // unlock(&lk);
    // exit();
}