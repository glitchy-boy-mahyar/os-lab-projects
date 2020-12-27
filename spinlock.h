#ifndef __SPLOCK_HH__
#define __SPLOCK_HH__

typedef struct Condition condition_var;

// Mutual exclusion lock.
struct spinlock {
  uint locked;       // Is the lock held?

  // For debugging:
  char *name;        // Name of lock.
  struct cpu *cpu;   // The cpu holding the lock.
  uint pcs[10];      // The call stack (an array of program counters)
                     // that locked the lock.
};

struct Condition {
  struct spinlock lock;
};

#endif
