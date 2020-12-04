#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "syscall.h"
#include "traps.h"

int backup = 0;

int main() {

    asm("_start:"
        "movl %ebx, backup;"
        "movl $22, %eax;" 
        "movl $17551756, %ebx;"
        "int $64;"
        "movl backup, %ebx;");
    exit();
}