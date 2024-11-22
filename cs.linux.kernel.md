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
mainfont: Routed Gothic
monofont: Routed Gothic
header-includes: |
  \usepackage{fancyhdr}
  \pagestyle{fancy}
  \fancyhead[CO,CE]{Advanced Operating Systems - part B - Kernel API Cheatsheet}
  \fancyfoot[CO,CE]{Author: Vittorio Zaccaria (2024)}
  \fancyfoot[LE,RO]{\thepage}
---

::: three-columns
# Concurrency 
##  Spinlocks
```c
#include <linux/spinlock.h>

// declare <name> as spinlock_t
DEFINE_SPINLOCK(<name>);

spin_lock(spinlock_t *lock);
spin_unlock(spinlock_t *lock);
```
### IRQ disabling/enabling variants 

```c
/* Disable interrupts and save interrupt state in flags*/
void spin_lock_irqsave(spinlock_t *lock,  
					   unsigned long flags);
/* Reenable interrupts from state */
void spin_unlock_irqrestore(spinlock_t *lock,  
							unsigned long flags);

/* Just disable all interrupts */
void spin_lock_irq (spinlock_t *lock);
/* Just reenable all interrupts */
void spin_unlock_irq (spinlock_t *lock);
```

## Readwrite locks                                                
```c
DEFINE_RWLOCK(lock);

read_lock(&lock);
/* Reader critical section */
read_unlock(&lock);

write_lock(&lock);
/* Writers critical section */
write_unlock(&lock);
```
## Atomic variables && bitops
```c
#include <asm/atomic.h>

void atomic_set(atomic_t *v, int i);
int atomic_read(atomic_t *v);
void atomic_add(int i, atomic_t *v);
void atomic_sub(int i, atomic_t *v);
void atomic_inc(atomic_t *v);
void atomic_dec(atomic_t *v);
int atomic_inc_and_test(atomic_t *v);
int atomic_dec_and_test(atomic_t *v);
int atomic_cmpxchg(atomic_t *v, int old, int new);

void set_bit(int nr, volatile unsigned long *addr);
void clear_bit(int nr, volatile unsigned long *addr);
```

# IO
## Ports
```c
#include <linux/ioport.h>
struct resource *request_region(unsigned long first,  unsigned long n, const char *name);

void release_region(unsigned long start, unsigned long n);

/* one byte */
unsigned inb(int port); 
void outb(unsigned char byte, int port) 

/* two bytes */
unsigned inw(int port) 
void outw(unsigned short word, int port) 

/* 4 bytes */
unsigned inl (int port) 
void outl(unsigned long word, int port) 

/* You can use also ioread and iowrite (below) but 
   you must map ports in memory with ioport_map */
void *ioport_map(unsigned long port, unsigned int count);
void ioport_unmap(void *addr);

```
## Memory mapped
```c
struct resource *request_mem_region(unsigned long start, 
  unsigned long len, char *name);

void release_mem_region(unsigned long start, unsigned long len);

/* For memory mapped IO you must obtain a virtual address in kernel space  to do any access */
void *ioremap(unsigned long phys_addr, unsigned long size);
void iounmap(void * addr);

unsigned int ioread8(void *addr);
unsigned int ioread16(void *addr);
unsigned int ioread32(void *addr);
void iowrite8(u8 value, void *addr);
void iowrite16(u16 value, void *addr);
void iowrite32(u32 value, void *addr);
```
## Registering an interrupt

```c
#include <linux/interrupt.h>

typedef irqreturn_t (*irq_handler_t)(int, void *);

int request_irq(unsigned int irq_no, irq_handler_t handler,
  unsigned long flags, const char *dev_name, void *dev_id);

void free_irq(unsigned int irq_no, void *dev_id);
```
::: 