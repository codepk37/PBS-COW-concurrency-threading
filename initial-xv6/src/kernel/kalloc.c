/////////////////////// WORKS GOOD
//int decrease_pgreference(void *pa); uses
//void increase_pgreference(void *pa);

//kalloc.c and vm.c copyalloc -> cow


#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

struct
{
  struct spinlock lock;
  int count[PGROUNDUP(PHYSTOP) >> 12];
} page_ref;

void
kinit()
{
  // initlock(&kmem.lock, "kmem");
  // freerange(end, (void*)PHYSTOP);
  initlock(&page_ref.lock, "page_ref");
  acquire(&page_ref.lock);
  for (int i = 0; i < (PGROUNDUP(PHYSTOP) >> 12); ++i)
    page_ref.count[i] = 0;
  release(&page_ref.lock);


  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    increase_pgreference(p);
    kfree(p);
  }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  if (!decrease_pgreference(pa))  //added for cow
    return;


  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    increase_pgreference((void *)r);

  }return (void*)r;
}
/////////////////////added for cow

int decrease_pgreference(void *pa)
{
  acquire(&page_ref.lock);
  if (page_ref.count[(uint64)pa >> 12] <= 0)
  {
    panic("decrease_pgreference");
  }
  page_ref.count[(uint64)pa >> 12]--;
  if (page_ref.count[(uint64)pa >> 12] > 0)
  {
    release(&page_ref.lock);
    return 0;
  }
  release(&page_ref.lock);
  return 1;
}

void increase_pgreference(void *pa)
{
  acquire(&page_ref.lock);
  if (page_ref.count[(uint64)pa >> 12] < 0)
  {
    panic("increase_pgreference");
  }
  page_ref.count[(uint64)pa >> 12]++;
  release(&page_ref.lock);
}
/////////////////////// WORKS GOOD


/*    original

// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

/////added for cow 

// First we define a new structure refcnt to store the count of physical page references. In addition, 
// because xv6 can handle multi-core and multi-process parallel processing, we also need a lock to protect
//  the reading and modification of reference numbers. The addresses below KERNBASE are used by the kernel. 
// The user process will not modify this part, so the size of the array can be calculated starting from KERNBASE.
struct {            //added for cow
  struct spinlock lock;
  int count[(PGROUNDUP(PHYSTOP) - KERNBASE)/PGSIZE];
} refcnt;

#define PA2IDX(pa) (((uint64)(pa)-KERNBASE)/PGSIZE)  //added

// Finally, it is the wrapper function for counter-related operations.

void
krefincr(void *pa)
{
  acquire(&refcnt.lock);
  refcnt.count[PA2IDX(pa)]++;
  release(&refcnt.lock);
}

void
krefdecr(void *pa)
{
  acquire(&refcnt.lock);
  refcnt.count[PA2IDX(pa)]--;
  release(&refcnt.lock);
}

int
krefget(void *pa)
{
  int cnt;
  acquire(&refcnt.lock);
  cnt = refcnt.count[PA2IDX(pa)];
  release(&refcnt.lock);
  return cnt;
}

///added for cow 

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;




void
kinit()
{
  initlock(&kmem.lock, "kmem");

  //added for cow
   initlock(&refcnt.lock, "refcnt");

  // ** Must reset count array before freerange
  for (int i = 0; i < (PGROUNDUP(PHYSTOP)-KERNBASE) / PGSIZE; i++)
    refcnt.count[i] = 1;

  //

  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  ///////////////////added for cow
  
    // ** safety check
  if (krefget(pa) <= 0){
    return ;panic("kfree_decr");
  }

  // ** minus refcnt when kfree is called
  // ** Free memory only when refcnt <= 0
  krefdecr(pa);
  if (krefget(pa) > 0)
    return;

  ///////////////////added for cow  


  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk

    ////added for cow
    // ** Set refcnt as 1 when allocate new page
    acquire(&refcnt.lock);
    refcnt.count[PA2IDX(r)] = 1;
    release(&refcnt.lock);

    ////added for cow


  }
  return (void*)r;
}

*/

