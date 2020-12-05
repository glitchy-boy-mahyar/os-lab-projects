#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main() {    
    int n1 = fork(); 

    if(n1 > 0){
        fork();
    }

    fork();

    int answer = get_children(getpid());

    while(wait() != -1) { }

    printf(1 , "%d\n" , answer);

    sleep(1);

    exit();
}
