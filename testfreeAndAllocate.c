#include "types.h"
#include "user.h"
#include "syscall.h"
#include "stat.h"
#include "fcntl.h"

int main(int argc, char **argv){
	// Part 1
	printf(1,"Begin Test\n");
	myMemory();
	printf(1,"sbrk'ing 8192 (2 pages)\n");
	sbrk(8192);
	myMemory();
	printf(1,"sbrk'ing -8192 (2 pages)\n");
	sbrk(-8192);
	myMemory();

	// Part 2
	printf(1,"Malloc'ing Integer Array of size 49152\n");
	char *arrayPointer = (char *)malloc(49152);
    // 10 pages worth of integers plus one page for the pointer
    myMemory();
    printf(1,"Freeing Integer Array (Won't Change # of Pages)\n");
    free(arrayPointer);
    myMemory();
    printf(1,"Force sbrk to reduce # of pages\n");
    sbrk(-49152);
    myMemory();
    printf(1,"One lingering page for the array pointer (stack variable)\n");

    // Part 3
    sbrk(230000000);
    myMemory();
    sbrk(5000000);
    myMemory();
    sbrk(-5000000);
    myMemory();
    sbrk(5000000);
    myMemory();


	exit();
}


