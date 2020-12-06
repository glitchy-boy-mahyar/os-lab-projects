#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int backup = 0;
//
int main(int argc, char* argv[]) {
    if(argc != 5){
        printf(1, "change_queue: wrong input\n");
        exit();
    }

    int pid = atoi(argv[1]);

    char priority_ratio[64] = {0};
    char arrival_ratio[64] = {0};
    char executed_cycle_ratio[64] = {0};

    strcpy(priority_ratio, argv[2]);
    strcpy(arrival_ratio, argv[3]);
    strcpy(executed_cycle_ratio, argv[4]);

    change_BJF_parameters_individual(pid, priority_ratio, arrival_ratio, executed_cycle_ratio);
    exit();
}