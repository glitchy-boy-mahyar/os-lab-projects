// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char *argv[] = { "sh", 0 };
char *tr_argv[] = {"trace", 0};

int
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr

  printf(1, "init: starting trace\n");

  //tr_pid = fork();
  //if(tr_pid < 0){
  //  printf(1, "init: fork failed\n");
  //  exit();
  //}

  //if(tr_pid == 0){
  //  exec("trace", tr_argv);
  //  printf(1, "init: exec trace failed\n");
  //  exit();
  //}

  for(;;){
    printf(1, "init: starting sh\n");
    printf(1, "Group #6:\n1- Alireza Aghaei\n2- Alireza Salamat\n3- Mahyar Karimi\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}
