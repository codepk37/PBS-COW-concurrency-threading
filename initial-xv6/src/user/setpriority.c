
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main(int argc, char *argv[]) { //DONE works GOOD

    if (argc != 3) {
        printf("Usage: setpriority pid priority\n");
        return 0;
    }
    
    int pid = atoi(argv[1]);       // Process ID
    int priority = atoi(argv[2]);  // New priority

    if (priority < 0 || priority > 100) {
        printf("Error: Priority should be in the range [0, 100]\n");
        return 0;
    }

    int old_priority = set_priority(pid, priority);
    
    if (old_priority < 0) { //-1
        printf("Error: Process with PID %d does not exist or invalid priority.\n", pid);
    } else {
        printf("Process with PID %d: Old Priority = %d, New Priority = %d\n", pid, old_priority, priority);
    }

    return 0;
    
}
