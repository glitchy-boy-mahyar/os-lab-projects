#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main() {
    trace_syscalls(1);
    sleep(2000);
    trace_syscalls(0);
    exit();
}