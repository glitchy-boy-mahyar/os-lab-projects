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
        sleep(5);
        printf(1, "i'm stuck at this sem\n");
        semaphore_acquire(1);
        printf(1, "finally got over that sem\n");
        semaphore_release(1);
        printf(1, "time to go\n");
    }
    else if(pid > 0){
        printf(1, "you seriously want this sem, yo?\n");
        sleep(50);
        semaphore_release(1);
        sleep(50);
        printf(1, "now what? should i wait?\n");
        wait();
        printf(1, "boom goes the dynamite\n");
    }
    printf(1, "sounds good so far for me (%d)\n", getpid());
    exit();
}