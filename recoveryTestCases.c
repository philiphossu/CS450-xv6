#include "types.h"
#include "user.h"
#include "syscall.h"
#include "stat.h"
#include "fcntl.h"

int main(int argc, char **argv) {
//	inodeTBWalker();
//	directoryWalker(".");
	compareWalkers();

	mkdir("foo");
	int fd;
	fd = open("/foo/smallTestFile", O_CREATE | O_RDWR);
	if(fd >= 0){
		printf(1, "\n----> File creation successful.\n");
	}
	write(fd, "22", 2);
	close(fd);
	deleteIData(24);

	compareWalkers();
//	directoryWalker(".");
//	inodeTBWalker();
	exit();
	return 0;
}

