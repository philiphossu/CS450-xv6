#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
	// To do & Notes:
	// - display number of pages allocated by calling process
	// - proc struct contain reference to its page table ie. PDE
	// - How to look up things in page directory?
	// - Look through all pages and see which are allocated (count of them)
	// - Also have to look through writable and accessible status via the respective bits

	pde_t * pde = myproc()->pgdir;
	pde_t * ptAdder;
	int index;
	int innerIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(index=0; index < 1024;index++){
		if (((pde[index]) & (uint)PTE_P)){
			ptAdder = (pde_t *)P2V(PTE_ADDR(pde[index]));
			for(innerIndex=0; innerIndex<1024; innerIndex++){
				if(ptAdder[innerIndex] & (uint)PTE_U){
					// Page is present
					presentPagesCounter++;
					if ((ptAdder[innerIndex] & (uint)PTE_U) && (ptAdder[innerIndex] & (uint)PTE_W)){
						//Page is accessible and writable
						userWritePagesCounter++;
					}
				}
				//ptAdder = (uint*)((char *)ptAdder +(uint) 0x20);
			}
			//totalNumPages+=1024;
		}
		//pde = (pde_t*)((char *)pde +(uint) 0x20);
	}
	cprintf("Present Pages: %d\n",presentPagesCounter);
	cprintf("Write/User Pages: %d\n",userWritePagesCounter);
	return presentPagesCounter;
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
