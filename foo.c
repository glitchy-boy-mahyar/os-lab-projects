#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

const int SZ = 10;
const int MAX_CHILDREN = 3;

int
rand_r (unsigned int *seed)
{
  unsigned int next = *seed;
  int result;

  next *= 1103515245;
  next += 12345;
  result = (unsigned int) (next / 65536) % 2048;

  next *= 1103515245;
  next += 12345;
  result <<= 10;
  result ^= (unsigned int) (next / 65536) % 1024;

  next *= 1103515245;
  next += 12345;
  result <<= 10;
  result ^= (unsigned int) (next / 65536) % 1024;

  *seed = next;

  return result;
}

void
swap(int array[SZ], int a, int b)
{
    int temp = array[a];
    array[a] = array[b];
    array[b] = temp;
}

void
bubble_sort(int array[SZ])
{
    for(int i = 0; i < SZ - 1; i++){
        for(int j = 0; j < SZ - i - 1; j++){
            if (array[j + 1] < array[j])
                swap(array, j, j + 1);
        }
    }
}

void
init_array(int array[SZ])
{
    unsigned int status = 0;
    for (int i = 0; i < SZ; i++) {
        array[i] = rand_r(&status);
        status++;
    }
}

void
cpu_intensive(void)
{
    for(int i = 0; i < MAX_CHILDREN; i++) {
        int array[SZ];
        init_array(array);
        
        // int pid = fork();
        // if (pid == 0)
        //     bubble_sort(array);
        // if (pid > 0)
        //     continue;
        bubble_sort(array);
    }

    // while(wait() != -1) {}
}

void
cpu_intensive_2() {
    int pid = fork();
    if (pid == 0) {
        for(;;) {}
    }
    if (pid > 0)
        wait();
}

int
main(void)
{
    cpu_intensive();
    exit();
}