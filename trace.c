#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

const int SLP_TICKS = 500;

int main() {
    int time = uptime();
    for(;;) {
        int now = uptime(), diff = now - time;
        diff = (diff > 0) ? diff : -diff;
        if (diff > 500) {
            trace_syscalls(-1);
            time = now;
        }
    }
    
    exit();
}