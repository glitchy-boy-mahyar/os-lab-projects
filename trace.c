#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

const int SLP_TICKS = 500;

int main() {
    for(;;) {
        sleep(SLP_TICKS);
        trace_syscalls(-1);
    }
    
    exit();
}