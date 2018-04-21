#include "types.h"
#include "user.h"
#include "syscall.h"
#include "stat.h"
#include "fcntl.h"

int main(int argc, char **argv) {
	inodeTBWalker();
	directoryWalker(".");
	//deleteIData(10);
	//inodeTBWalker();
	exit();
	return 0;
}

