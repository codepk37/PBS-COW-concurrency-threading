#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define NFORK 10
#define IO 5

 //ORIGINAL
// int main()
// {
//   int n, pid;
//   int wtime, rtime;
//   int twtime = 0, trtime = 0;
//   for (n = 0; n < NFORK; n++)
//   {
//     pid = fork();
//     if (pid < 0)
//       break;
//     if (pid == 0)
//     {
//       if (n < IO)
//       { 
        
      
        
        
//         // printf("Process with PID %d: Old Priority = %d\n", getpid(), set_priority(getpid(), 3));
//         //         sleep(100);
//         // printf("Process with PID %d: Old Priority = %d\n", getpid(), set_priority(getpid(), 33));
//         //   sleep(100);
//         // printf("Process with PID %d: Old Priority = %d\n", getpid(), set_priority(getpid(), 66));


//         sleep(200); // IO bound processes
//       }
//       else
//       {
//         for (volatile int i = 0; i < 1000000000; i++)
//         {
//         } // CPU bound process
//       }
//       // printf("Process %d finished\n", n);
//       exit(0);
//     }
//   }
       
//   for (; n > 0; n--)
//   {
//     if (waitx(0, &wtime, &rtime) >= 0)
//     {
//       trtime += rtime;
//       twtime += wtime;
//     }
//   }
//   printf("Average rtime %d,  wtime %d\n", trtime / NFORK, twtime / NFORK);
//   exit(0);
// }



int main(){
   
    int n, pid;
    int wtime, rtime;
    int twtime=0, trtime=0;

    set_priority( getpid(),5);

    for(n=0; n < NFORK;n++) {
      pid = fork();

      if (pid < 0)
          break;
      if (pid == 0) {
          if (n < IO) {
            sleep(100); // IO bound processes
          } else {
            for (volatile int i = 0; i < 1000000000; i++) {} // CPU bound process
          }

          // for correct order = decreasing order
          printf("Proc %d finished (%d)\n", n, 100 - n * 5); // print the process index and priority

          // for correct order = increasing order
          // printf("Proc %d finished (%d)\n", n, 5 + n * 10); // print the process index and priority

          exit(0);
      } else {  

        // set_priority(80, pid); // Will only matter for PBS, set lower priority for IO bound processes
        
        // for correct order = decreasing order
        set_priority(pid,100 - n * 5); // TODO. This 100 - n * 10 is a good test for PBS

        // for correct order = increasing order 
        // set_priority(5 + n * 10, pid);

        fprintf(2, "process number: %d    pid: %d\n", n, pid);
      }
  }
  for(;n > 0; n--) {
      if(waitx(0,&wtime,&rtime) >= 0) {
          trtime += rtime;
          twtime += wtime;
      }
  }
  printf("\nAverage rtime %d,  wtime %d\n", trtime / NFORK, twtime / NFORK);
  exit(0);

}