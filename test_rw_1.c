#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define WC 0
#define RC 1
#define LOG 2

#define mutex 0
#define wrt 1

void rw_write(){
    p_lock(mutex);
    //printf(1 , "Writer waits for wrt...\n");
    print_log(0);

    while(chsv(WC, 0) || chsv(RC, 0)){
        p_unlock(mutex);
        p_cv_wait(wrt);
        p_lock(mutex);
    }
    chsv(WC, 1);
    p_unlock(mutex);

    // Writing here...
    p_lock(mutex);
    chsv(LOG , 1); 
    //printf(1 , "log_val %d\n" , log_val);
    print_log(1);

    p_unlock(mutex);
    // Writing done (supposedly)

    p_lock(mutex);
    chsv(WC, -1);
    p_cv_signal(wrt);
    p_unlock(mutex);

    p_lock(mutex);
    //printf(1, "Goodbye writer with pid %d\n", getpid());
    print_log(2);
    p_unlock(mutex);
}

void rw_read(){
    p_lock(mutex);
    while(chsv(WC, 0)){
        p_unlock(mutex);
        p_cv_wait(wrt);
        p_lock(mutex);
    }
    chsv(RC , 1);
    p_unlock(mutex);

    // Reading here...

    p_lock(mutex);
    chsv(LOG , 0);
    //printf(1 , "LOG = %d / reader = %d\n" , log , getpid());
    print_log(3);
    p_unlock(mutex);
    // Reading done (arvah ammash)

    p_lock(mutex);
    chsv(RC , -1);
    p_cv_signal(wrt);
    p_unlock(mutex);

    p_lock(mutex);
    //printf(1, "Goodbye reader with pid %d\n", getpid());
    print_log(4);
    p_unlock(mutex);
}

int main() {
    int pid = fork();

    if(pid == 0){
        //printf(1 , "first_writer\n");
        rw_write();       
    }
    else{
        int pid2 = fork();

        if(pid2 == 0){
            rw_read();
            rw_write();
        }
        else{
            rw_write();
            rw_read();
            wait();
        }
        rw_read();
        wait();
    }
    exit();
}