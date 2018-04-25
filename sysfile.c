//
// File-system system calls.
// Mostly argument checking, since we don't trust
// user code, and calls into file.c and fs.c.
//

#include "types.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"
#include "fcntl.h"
#include "buf.h"

void directoryWalkerSubRoutine(char* path);
void strcat(char* s1, const char* s2);
int strcmp(const char* s1, char* s2);
int sys_directoryWalker(void);
int sys_inodeTBWalker(void);
void fixFile(int inum);
void reverse(char s[]);
void itoa(int n, char s[]);
void fixDir(int dirIndex, int parentIndex);
void resetArrays();

struct superblock sb;
int inodeLinkLog[200];
int inodeTBWalkerLinkLog[200];
int corruptDirs[200];

int sys_recoverFS(){
	int inodeIndex;
	for(inodeIndex=2;inodeIndex<200; inodeIndex++){
		if(corruptDirs[inodeIndex] != 0){
			cprintf("FIXING A PROBLEM\n");
			fixDir(inodeIndex, corruptDirs[inodeIndex]);
		}
	}
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
		if(inodeLinkLog[inodeIndex] != inodeTBWalkerLinkLog[inodeIndex]){
			cprintf("FIXING A PROBLEM\n");
			fixFile(inodeIndex);
		}
	}
	// Clear arrays, everything should be fixed now
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeLinkLog[inodeNum]=0;
	}
	inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		corruptDirs[inodeNum]=0;
	}

	return 1;
}

void fixDir(int dirIndex, int parentIndex){
	begin_op();
	struct inode* dirPointer;
	struct inode* dirParentPointer;
	dirPointer = igetCaller(dirIndex);
	dirParentPointer = igetCaller(parentIndex);
	dirlink(dirPointer,".",dirPointer->inum);
	dirlink(dirPointer,"..",dirParentPointer->inum);
	end_op();
}

void fixFile(int inum){
	begin_op();
	struct inode* ip;
	char newName[14] = {0};
	strcat(newName,"tmp_");
	char tmpNum[4];
	itoa(inum,tmpNum);
	strcat(newName,tmpNum);
	ip = igetCaller(1);
	ilock(ip);
	dirlink(ip,newName,inum);
	iunlock(ip);
	end_op();
}

int sys_compareWalkers(){
	resetArrays();
	cprintf("\n= = = Calling inodeTBwalker = = =\n");
	sys_inodeTBWalker();
	cprintf("\n\n");
	cprintf("\n= = = Calling directoryWalker = = =\n");
	directoryWalkerSubRoutine(".");
	cprintf("\n\n");
	cprintf("\n= = = Comparing walkers = = =\n");
	int inodeIndex;
	int similarity = 1;
	// We begin at 2 because the root will be the same
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
		if(inodeLinkLog[inodeIndex] != inodeTBWalkerLinkLog[inodeIndex]){
			similarity = 0;
			cprintf("Found difference between inodeTBWalker & directoryWalker @ inode#: %d\n",inodeIndex);
			cprintf("inodeTBwalker #links: %d \t directoryWalker #links: %d\n\n",inodeTBWalkerLinkLog[inodeIndex],inodeLinkLog[inodeIndex]);
		}
	}
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
		if(corruptDirs[inodeIndex] != 0){
			cprintf("Found a corrupted directory#: %d\n",inodeIndex);
		}
	}
	return similarity;
}

void reverse(char s[])
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }

 }

 void itoa(int n, char s[])
 {
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
 }

void strcat(char* s1, const char* s2){
  while (*s1) ++s1;
  while (*s2) *s1++ = *s2++;
  *s1 = 0;
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
  return *(unsigned char*)s1-*(unsigned char*)s2;
}
void resetArrays(){
	// initialize link log
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeLinkLog[inodeNum]=0;
	}
	// initialize corrupt directory log
	inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		corruptDirs[inodeNum]=0;
	}
}
int sys_directoryWalker(void){
	char *path;
	argstr(0,&path);
	if(!path){
		path = ".";
	}
	cprintf("path is %s\n",path);
	resetArrays();
	// Call recursive subroutine
	directoryWalkerSubRoutine(path);

//	for(inodeNum = 0; inodeNum<30;inodeNum++){
//		cprintf("%d",inodeLinkLog[inodeNum]);
//	}
//	cprintf("\n");
//	cprintf("Printing broken directory/parent pairs\n");
//	for(inodeNum = 0; inodeNum<30;inodeNum++){
//		cprintf("%d",corruptDirs[inodeNum]);
//	}
	return 0;
}
void directoryWalkerSubRoutine(char* path){

	uint off;
	struct dirent de;
	struct inode * ip = namei(path);
	if(!ip){
		panic("Invalid File Path");
	}
	begin_op();
	ilock(ip);
	if(ip->type == T_DIR){
		// The specified path is a directory, go through its directory entries
		for(off = 0; off < ip->size; off += sizeof(de)){
			if(readi(ip, (char*)&de, off, sizeof(de)) != sizeof(de)){
				// Reading was not successful
				panic("dirlookup read");
			}
			if(off==0 && (strcmp(de.name,"."))){
				struct inode* brokenDirParent;
				char name[14] = "..";
				iunlock(ip);
				// Found a corrupted directory, record its inode number and its parents inode number
				if((brokenDirParent = nameiparent(path,name)) == 0){
					ilock(ip);
					continue;
				}
				corruptDirs[ip->inum] = brokenDirParent->inum;
				ilock(ip);
			}

		    if(de.inum == 0){
		      continue;
		    }

			cprintf("Name: %s \t inode#: %d\n",de.name,de.inum);

			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
				continue;
			}
			struct inode *dir_ip;
			dir_ip = dirlookup(ip,de.name,0);
			inodeLinkLog[de.inum]++;
			if(dir_ip->type == T_DIR){
				// we found a directory, recursively call
				char new_path[14] = {0};
				strcat(new_path,path);
				strcat(new_path,"/");
				strcat(new_path,de.name);
				iunlock(ip);
				directoryWalkerSubRoutine(new_path);
				ilock(ip);
			}
		}
	}
	iunlock(ip);
	end_op();
}

int sys_inodeTBWalker(void){
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeTBWalkerLinkLog[inodeNum]=0;
	}
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
	for(inum = 1; inum < sb.ninodes; inum++){
		bp = bread(1, IBLOCK(inum, sb));
		dip = (struct dinode*)bp->data + inum%IPB;
		if(dip->type != 0){  // not a free inode
			// Found allocated inode
			cprintf("inode#: %d \t type: %d\n",inum,dip->type);
			inodeTBWalkerLinkLog[inum]++;
		}
		brelse(bp);
	}
//	for(inodeNum = 0; inodeNum<30;inodeNum++){
//		cprintf("%d",inodeTBWalkerLinkLog[inodeNum]);
//	}
	return 0;
}

int sys_deleteIData(void){
	int inum;
	argint(0,&inum);
	callDeleteInFS(inum);
	return 0;
}

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
	int fd;
	struct file *f;

	if(argint(n, &fd) < 0)
		return -1;
	if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
		return -1;
	if(pfd)
		*pfd = fd;
	if(pf)
		*pf = f;
	return 0;
}

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
	int fd;
	struct proc *curproc = myproc();

	for(fd = 0; fd < NOFILE; fd++){
		if(curproc->ofile[fd] == 0){
			curproc->ofile[fd] = f;
			return fd;
		}
	}
	return -1;
}

int
sys_dup(void)
{
	struct file *f;
	int fd;

	if(argfd(0, 0, &f) < 0)
		return -1;
	if((fd=fdalloc(f)) < 0)
		return -1;
	filedup(f);
	return fd;
}

int
sys_read(void)
{
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
		return -1;
	return fileread(f, p, n);
}

int
sys_write(void)
{
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
		return -1;
	return filewrite(f, p, n);
}

int
sys_close(void)
{
	int fd;
	struct file *f;

	if(argfd(0, &fd, &f) < 0)
		return -1;
	myproc()->ofile[fd] = 0;
	fileclose(f);
	return 0;
}

int
sys_fstat(void)
{
	struct file *f;
	struct stat *st;

	if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
		return -1;
	return filestat(f, st);
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
	char name[DIRSIZ], *new, *old;
	struct inode *dp, *ip;

	if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
		return -1;

	begin_op();
	if((ip = namei(old)) == 0){
		end_op();
		return -1;
	}

	ilock(ip);
	if(ip->type == T_DIR){
		iunlockput(ip);
		end_op();
		return -1;
	}

	ip->nlink++;
	iupdate(ip);
	iunlock(ip);

	if((dp = nameiparent(new, name)) == 0)
		goto bad;
	ilock(dp);
	if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
		iunlockput(dp);
		goto bad;
	}
	iunlockput(dp);
	iput(ip);

	end_op();

	return 0;

	bad:
	ilock(ip);
	ip->nlink--;
	iupdate(ip);
	iunlockput(ip);
	end_op();
	return -1;
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
	int off;
	struct dirent de;

	for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
		if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
			panic("isdirempty: readi");
		if(de.inum != 0)
			return 0;
	}
	return 1;
}

//PAGEBREAK!
int
sys_unlink(void)
{
	struct inode *ip, *dp;
	struct dirent de;
	char name[DIRSIZ], *path;
	uint off;

	if(argstr(0, &path) < 0)
		return -1;

	begin_op();
	if((dp = nameiparent(path, name)) == 0){
		end_op();
		return -1;
	}

	ilock(dp);

	// Cannot unlink "." or "..".
	if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
		goto bad;

	if((ip = dirlookup(dp, name, &off)) == 0)
		goto bad;
	ilock(ip);

	if(ip->nlink < 1)
		panic("unlink: nlink < 1");
	if(ip->type == T_DIR && !isdirempty(ip)){
		iunlockput(ip);
		goto bad;
	}

	memset(&de, 0, sizeof(de));
	if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
		panic("unlink: writei");
	if(ip->type == T_DIR){
		dp->nlink--;
		iupdate(dp);
	}
	iunlockput(dp);

	ip->nlink--;
	iupdate(ip);
	iunlockput(ip);

	end_op();

	return 0;

	bad:
	iunlockput(dp);
	end_op();
	return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
	uint off;
	struct inode *ip, *dp;
	char name[DIRSIZ];

	if((dp = nameiparent(path, name)) == 0)
		return 0;
	ilock(dp);

	if((ip = dirlookup(dp, name, &off)) != 0){
		iunlockput(dp);
		ilock(ip);
		if(type == T_FILE && ip->type == T_FILE)
			return ip;
		iunlockput(ip);
		return 0;
	}

	if((ip = ialloc(dp->dev, type)) == 0)
		panic("create: ialloc");

	ilock(ip);
	ip->major = major;
	ip->minor = minor;
	ip->nlink = 1;
	iupdate(ip);

	if(type == T_DIR){  // Create . and .. entries.
		dp->nlink++;  // for ".."
		iupdate(dp);
		// No ip->nlink++ for ".": avoid cyclic ref count.
		if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
			panic("create dots");
	}

	if(dirlink(dp, name, ip->inum) < 0)
		panic("create: dirlink");

	iunlockput(dp);

	return ip;
}

int
sys_open(void)
{
	char *path;
	int fd, omode;
	struct file *f;
	struct inode *ip;

	if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
		return -1;

	begin_op();

	if(omode & O_CREATE){
		ip = create(path, T_FILE, 0, 0);
		if(ip == 0){
			end_op();
			return -1;
		}
	} else {
		if((ip = namei(path)) == 0){
			end_op();
			return -1;
		}
		ilock(ip);
		if(ip->type == T_DIR && omode != O_RDONLY){
			iunlockput(ip);
			end_op();
			return -1;
		}
	}

	if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
		if(f)
			fileclose(f);
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
	end_op();

	f->type = FD_INODE;
	f->ip = ip;
	f->off = 0;
	f->readable = !(omode & O_WRONLY);
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
	return fd;
}

int
sys_mkdir(void)
{
	char *path;
	struct inode *ip;

	begin_op();
	if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
		end_op();
		return -1;
	}
	iunlockput(ip);
	end_op();
	return 0;
}

int
sys_mknod(void)
{
	struct inode *ip;
	char *path;
	int major, minor;

	begin_op();
	if((argstr(0, &path)) < 0 ||
			argint(1, &major) < 0 ||
			argint(2, &minor) < 0 ||
			(ip = create(path, T_DEV, major, minor)) == 0){
		end_op();
		return -1;
	}
	iunlockput(ip);
	end_op();
	return 0;
}

int
sys_chdir(void)
{
	char *path;
	struct inode *ip;
	struct proc *curproc = myproc();

	begin_op();
	if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
		end_op();
		return -1;
	}
	ilock(ip);
	if(ip->type != T_DIR){
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
	iput(curproc->cwd);
	end_op();
	curproc->cwd = ip;
	return 0;
}

int
sys_exec(void)
{
	char *path, *argv[MAXARG];
	int i;
	uint uargv, uarg;

	if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
		return -1;
	}
	memset(argv, 0, sizeof(argv));
	for(i=0;; i++){
		if(i >= NELEM(argv))
			return -1;
		if(fetchint(uargv+4*i, (int*)&uarg) < 0)
			return -1;
		if(uarg == 0){
			argv[i] = 0;
			break;
		}
		if(fetchstr(uarg, &argv[i]) < 0)
			return -1;
	}
	return exec(path, argv);
}

int
sys_pipe(void)
{
	int *fd;
	struct file *rf, *wf;
	int fd0, fd1;

	if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
		return -1;
	if(pipealloc(&rf, &wf) < 0)
		return -1;
	fd0 = -1;
	if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
		if(fd0 >= 0)
			myproc()->ofile[fd0] = 0;
		fileclose(rf);
		fileclose(wf);
		return -1;
	}
	fd[0] = fd0;
	fd[1] = fd1;
	return 0;
}
