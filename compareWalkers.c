#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

int main(int argc, char **argv) {
	printf(1,"\n= = = Calling inode walker = = =\n");
	inodeTBWalker();
	printf(1,"\n\n");
	printf(1,"\n= = = Calling directory walker = = =\n");
	directoryWalker(".");

	exit();
	return 0;
}

