#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"


int main(int argc, char *argv[]) {
	if(argc < 2){
		directoryWalker(".");
		exit();
	}

	directoryWalker(argv[1]);
	exit();
}
