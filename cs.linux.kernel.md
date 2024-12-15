---
documentclass: article
classoption:
  - landscape
geometry:
  - bottom=2cm
  - left=1cm
  - right=1cm
  - top=2cm
papersize: a4
fontsize: 10pt
mainfont: Helvetica 
monofont: Fira Code 
monofontoptions: 'Scale=0.7'
header-includes: |
  \usepackage{fancyhdr}
  \pagestyle{fancy}
  \fancyhead[CO,CE]{Advanced Operating Systems - part B - Kernel API Cheatsheet}
  \fancyfoot[CO,CE]{Advanced Operating Systems - part B - Kernel API Cheatsheet}
  \fancyfoot[LE,RO]{\thepage}
  \linespread{0.8}
---

::: three-columns
# Tasks and concurrency 

## KThreads
```c
// Create and start a kernel thread
struct task_struct *kthread_run(int (*threadfn)(void *data)
  , void *data, const char namefmt[], ...);

// Stop a kernel thread (to be invoked by the main thread
int kthread_stop(struct task_struct *k);
// Check if a thread should stop 
bool kthread_should_stop(void);
```

## Waitqueues 
```c
DECLARE_WAIT_QUEUE_HEAD(<name>);

// Wait for a condition to be true, interruptible
wait_event_interruptible(wait_queue_head_t wq, condition); 

// Wakes all non-exclusive waiters from the wait queue 
// that are in an interruptible sleep state and 
// just one in exclusive state. This must be called
// whenever variables that impact the "condition" are changed.
void wake_up_interruptible(wait_queue_head_t *q);
```

## Spinlocks
```c
DEFINE_SPINLOCK(<name>); 

spin_lock(spinlock_t *lock);
spin_unlock(spinlock_t *lock);
/* IRQ enabble/disable variants */
void spin_lock_irqsave(spinlock_t *lock, 
  unsigned long flags);
void spin_unlock_irqrestore(spinlock_t *lock, 
  unsigned long flags);
/* read write spinlocks */
DEFINE_RWLOCK(<name>); 
void read_lock(rwlock_t *lock);
void read_unlock(rwlock_t *lock);
void write_lock(rwlock_t *lock);
void write_unlock(rwlock_t *lock);
/* *_irqsave, *_irqrestore variants do exist as well. */
```

## RCU
```c
void rcu_read_lock(void);
void rcu_read_unlock(void);
// Wait for all pre-existing RCU read-side critical sections
void synchronize_rcu(void);
// Call a function after all pre-existing RCU 
// read-side critical sections
void call_rcu(struct rcu_head *head, rcu_callback_t func);
// Assign v to p
void rcu_assign_pointer(void *p, void *v);
// Access data protected by RCU
void *rcu_dereference(void *p);
```

## Atomic variables && bitops
```c
void atomic_set(atomic_t *v, int i);
int  atomic_read(atomic_t *v);
void atomic_add(int i, atomic_t *v);
void atomic_sub(int i, atomic_t *v);
void atomic_inc(atomic_t *v);
void atomic_dec(atomic_t *v);
int  atomic_inc_and_test(atomic_t *v);
int  atomic_dec_and_test(atomic_t *v);
int  atomic_cmpxchg(atomic_t *v,  int old, int new);

void set_bit(int nr,  volatile unsigned long *addr);
void clear_bit(int nr,  volatile unsigned long *addr);
```
## Per CPU variables 
```c
// Declare a per-CPU variable
DEFINE_PER_CPU(type, name);

// Access per-CPU variable for the current CPU, 
// enter preempt disabled section. Note that
// this is an L-value, so you can assign to it.
get_cpu_var(name);

// Exit preempt disabled section
void put_cpu_var(name);
```
# IO 
## Port based IO 
```c
struct resource * request_region( unsigned long first,  
       unsigned long n,  const char *name);
void release_region(unsigned long start, unsigned long n);

unsigned inb(int port); /* one byte */
void outb(unsigned char byte, int port) 
unsigned inw(int port)  /* two bytes */
void outw(unsigned short word, int port) 
unsigned inl (int port) /* four bytes */ 
void outl(unsigned long word, int port) 

/* Ports can use ioread and iowrite (below) but 
   you must map those in memory with ioport_map */
void *ioport_map(unsigned long port, unsigned int count);
void ioport_unmap(void *addr);
```
## Memory mapped IO
```c
struct resource *request_mem_region(unsigned long start, 
  unsigned long len, char *name);
void release_mem_region(unsigned long start, unsigned long len);

/* For memory mapped IO you must obtain a virtual address in 
   kernel space before any access */
void *ioremap(unsigned long phys_addr, unsigned long size);
void iounmap(void * addr);

unsigned int ioread8(void *addr);
unsigned int ioread16(void *addr);
unsigned int ioread32(void *addr);
void iowrite8(u8 value, void *addr);
void iowrite16(u16 value, void *addr);
void iowrite32(u32 value, void *addr);
```
## Interrupts

```c
#include <linux/interrupt.h>

typedef irqreturn_t (*irq_handler_t)(int, void *);

int request_irq(unsigned int irq_no, irq_handler_t handler,
  unsigned long flags, const char *dev_name, void *dev_id);

void free_irq(unsigned int irq_no, void *dev_id);
```
## Tasklets
```c 
// the callback type
void (*callback)(struct tasklet_struct *t); 

// declare a tasklet
DECLARE_TASKLET(name, callback);

// schedule a tasklet; essentially puts the tasklet 
// in a softirq queue, if it is not already scheduled.
void tasklet_schedule(struct tasklet_struct *t);
```

## Workqueues //tbd

## Timers

# Misc //tbd
```c
//container_of - derive a pointer to the containing structure 
// given a pointer to a member
container_of(member_ptr, container_type, member_field_name)

```
## Userspace access //tbd

::: 


