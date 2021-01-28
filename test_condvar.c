#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main() {
    condition_var cv;
    init_lock(&cv.lock);

    int pid = fork();
    if(pid < 0)
        printf(1 , "Error Fork!\n");
    
    else if(pid == 0){
        sleep(5);
        printf(1 , "Child1 is executing\n");
        lock(&cv.lock);
        cv_signal(&cv);
        unlock(&cv.lock);
    }
    else{
        int pid = fork();
        if(pid < 0)
            printf(1 , "Error fork!\n");
        else if(pid == 0){
            lock(&cv.lock);
            cv_wait(&cv);
            unlock(&cv.lock);            
            printf(1 , "Child2 is executing\n");
        }
        else{
            printf(1 , "Parent waiting!\n");
            for(int i = 0 ; i < 2 ; i++)
                wait();
            printf(1 , "Completed be eshghe agha\n");
        }
    }
    exit();
}