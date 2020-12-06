#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int backup = 0;

int main(int argc, char* argv[]) {
    if(argc != 3){
        printf(1, "change_ticket: wrong input\n");
        exit();
    }

    int pid = atoi(argv[1]);
    int new_ticket = atoi(argv[2]);
    
    change_ticket(pid, new_ticket);
    exit();
}