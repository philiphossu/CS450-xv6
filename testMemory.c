#include "types.h"
#include "user.h"
#include "syscall.h"
#include "stat.h"
#include "fcntl.h"

int main(int argc, char **argv){

	printf(1,"Begin Test\n");
	myMemory();
	printf(1,"Adding 4096 bytes to memory.\n");
	sbrk(4096);
	myMemory();
	printf(1,"Adding 4097 bytes to memory.\n");
	sbrk(4097);
	myMemory();

	exit();
}


