#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

char* fmtname(char *path) {
	static char buf[DIRSIZ+1];
	char *p;

	// Find first character after last slash.
	for(p=path+strlen(path); p >= path && *p != '/'; p--)
		;
	p++;

	// Return blank-padded name.
	if(strlen(p) >= DIRSIZ)
		return p;
	memmove(buf, p, strlen(p));
	memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
	return buf;
}

void directw(char *path) {
	static int level=0;
	char buf[512], *p;
	int fd;
	struct dirent de;
	struct stat st;
	fd = open(path, 0);
	if(fd < 0){
		printf(2, "directorywalker: cannot open %s\n", path);
		return;
	}

	if(fstat(fd, &st) < 0){
		printf(2, "directorywalker: cannot stat %s\n", path);
		close(fd);
		return;
	}

	switch(st.type){
	case T_DIR:
		printf(1,"---> Directory Located <--- \n");
		++level;
		if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
			printf(1, "Directorywalker Error: path too long\n");
			break;
		}
		strcpy(buf, path);
		p = buf+strlen(buf);
		*p++ = '/';
		while(read(fd, &de, sizeof(de)) == sizeof(de)){
			if(de.inum == 0){
				continue;
			}

			memmove(p, de.name, DIRSIZ);
			//printf(1,"\t Directory Entry is called: %s\n", de.name);
			p[DIRSIZ] = 0;
			if(stat(buf, &st) < 0){
				printf(1, "Directorywalker Error: cannot stat %s\n", buf);
				continue;
			}
			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
				printf(1,"Directory Entry (./..): iNode # = %d \t Name = %s \t Level = %d\n", st.ino, fmtname(buf),level);
				continue;
			}
			else{
				printf(1,"Directory Entry (File or Subdirectory) to be explored: iNode # = %d \t Name = %s \t Level = %d\n", st.ino, fmtname(buf),level);
				directw(buf);
			}
		}
		break;
	case T_FILE:
		printf(1,"---> File Located, Ending This Branch <--- \n");
		close(fd);
		return;
	}
	close(fd);
}

int main(int argc, char *argv[]) {
	mkdir("testdir");
	int fd;
	fd = open("/testdir/smallTestFile", O_CREATE | O_RDWR);
	if(fd >= 0){
		printf(1, "----> File creation successful.\n");
	}
	write(fd, "22", 2);
	close(fd);

	if(argc < 2){
		directw(".");
		exit();
	}

	directw(argv[1]);
	exit();
}