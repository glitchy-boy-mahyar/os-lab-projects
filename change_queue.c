#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int backup = 0;

int main(int argc, char* argv[]) {
    if(argc != 3){
        printf(1, "change_queue: wrong input\n");
        exit();
    }

    int pid = atoi(argv[1]);
    int new_queue = atoi(argv[2]);
    
    change_queue(pid, new_queue);
    exit();
}