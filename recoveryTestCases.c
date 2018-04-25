#include "types.h"
#include "user.h"
#include "syscall.h"
#include "stat.h"
#include "fcntl.h"

int main(int argc, char **argv) {
	// Run compareWalkers before changing any FS data
	if(compareWalkers()){
		// If compareWalkers finds no differences, notify user
		printf(1,"No Differences Detected\n");
	}
	// Modify the contents of the FS
	mkdir("foo");
	printf(1, "----> Created directory foo inside of root\n");
	int fd;
	fd = open("/foo/fooFile", O_CREATE | O_RDWR);
	if(fd >= 0){
		printf(1, "----> Created file fooFile inside /foo\n");
	}
	write(fd, "I am fooFile", 13);
	close(fd);
	// Call directoryWalker to show that it can work with a provided filepath
	directoryWalker("foo");
	// Corrupt inode 24 corresponding to the foo directory
	printf(1, "\n!! Corrupting inode 24 (foo directory) !! \n");
	deleteIData(24);
	// Compare the walkers again, we expect differences
	if(compareWalkers()){
		// If compareWalkers finds no differences, notify user
		printf(1,"No Differences Detected\n");
	}

	// Recover the FS
	printf(1, "\n!! Recovering FS !! \n");
	recoverFS();

	// Now, run shell level commands to prove that the recovery was successful

	exit();
	return 0;
}

