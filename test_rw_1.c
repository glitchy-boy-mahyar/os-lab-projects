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
    printf(1 , "Writer waits for wrt...\n");
    while(chsv(WC, 0) || chsv(RC, 0))
        p_cv_wait(wrt);
    chsv(WC, 1);
    p_unlock(mutex);

    // Writing here...
    int log_val = chsv(LOG , 1);
    printf(1 , "log_val %d\n" , log_val);
    // Writing done (supposedly)

    p_lock(mutex);
    chsv(WC, -1);
    p_cv_signal(wrt);
    p_unlock(mutex);
}

void rw_read(){
    p_lock(mutex);
    while(chsv(WC, 0))
        p_cv_wait(wrt);
    chsv(RC , 1);
    p_unlock(mutex);

    // Reading here...
    int log = chsv(LOG , 0);
    printf(1 , "LOG = %d / reader = %d" , log , getpid());
    // Reading done (arvah ammash)

    p_lock(mutex);
    chsv(RC , -1);
    p_cv_signal(wrt);
    p_unlock(mutex);
}

int main() {
    //int pid = fork();

    // if(pid == 0){
    //     printf(1 , "first_writer\n");
    //     rw_write();
    // }
    // else{
        printf(1 , "first_reader\n");
        //sleep(5);
        rw_read();
    // }
    exit();
}