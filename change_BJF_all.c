#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int backup = 0;

int main(int argc, char* argv[]) {
    if(argc != 4){
        printf(1, "change_queue: wrong input\n");
        exit();
    }

    char priority_ratio[64] = {0};
    char arrival_ratio[64] = {0};
    char executed_cycle_ratio[64] = {0};

    strcpy(priority_ratio, argv[1]);
    strcpy(arrival_ratio, argv[2]);
    strcpy(executed_cycle_ratio, argv[3]);

    change_BJF_parameters_all(priority_ratio, arrival_ratio, executed_cycle_ratio);
    exit();
}