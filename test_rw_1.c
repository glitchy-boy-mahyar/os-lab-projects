#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define RC 0
#define LOG 1

#define mutex 0
#define wrt 1

void rw_write(){
    printf(1 , "Writer waits for wrt...\n");
    p_cv_wait(wrt);

    int log_val = chsv(LOG , 1);
    printf(1 , "log_val %d\n" , log_val);

    p_cv_signal(wrt);
}

void rw_read(){
    p_cv_wait(mutex);
    int read_count = chsv(RC , 1);
    if(read_count == 1)
        p_cv_wait(wrt);
    p_cv_signal(mutex);

    int log = chsv(LOG , 0);
    printf(1 , "LOG = %d / reader = %d" , log , getpid());

    p_cv_wait(mutex);
    read_count = chsv(RC , -1);
    if(read_count == 0)
        p_cv_signal(wrt);
    p_cv_signal(mutex);
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
}