
_compareWalkers:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
		return;
	}
	close(fd);
}

int main(int argc, char **argv) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
	printf(1,"\n= = = Calling inode walker = = =\n");
   9:	c7 44 24 04 d0 0b 00 	movl   $0xbd0,0x4(%esp)
  10:	00 
  11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  18:	e8 23 07 00 00       	call   740 <printf>
	inodeTBWalker();
  1d:	e8 68 06 00 00       	call   68a <inodeTBWalker>
	printf(1,"\n\n");
  22:	c7 44 24 04 3d 0c 00 	movl   $0xc3d,0x4(%esp)
  29:	00 
  2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  31:	e8 0a 07 00 00       	call   740 <printf>
	printf(1,"\n= = = Calling directory walker = = =\n");
  36:	c7 44 24 04 f4 0b 00 	movl   $0xbf4,0x4(%esp)
  3d:	00 
  3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  45:	e8 f6 06 00 00       	call   740 <printf>
	directw(".");
  4a:	c7 04 24 3b 0c 00 00 	movl   $0xc3b,(%esp)
  51:	e8 aa 00 00 00       	call   100 <directw>

	exit();
  56:	e8 87 05 00 00       	call   5e2 <exit>
  5b:	66 90                	xchg   %ax,%ax
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <fmtname>:
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

char* fmtname(char *path) {
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	83 ec 10             	sub    $0x10,%esp
  68:	8b 5d 08             	mov    0x8(%ebp),%ebx
	static char buf[DIRSIZ+1];
	char *p;

	// Find first character after last slash.
	for(p=path+strlen(path); p >= path && *p != '/'; p--)
  6b:	89 1c 24             	mov    %ebx,(%esp)
  6e:	e8 cd 03 00 00       	call   440 <strlen>
  73:	01 d8                	add    %ebx,%eax
  75:	73 10                	jae    87 <fmtname+0x27>
  77:	eb 13                	jmp    8c <fmtname+0x2c>
  79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80:	83 e8 01             	sub    $0x1,%eax
  83:	39 c3                	cmp    %eax,%ebx
  85:	77 05                	ja     8c <fmtname+0x2c>
  87:	80 38 2f             	cmpb   $0x2f,(%eax)
  8a:	75 f4                	jne    80 <fmtname+0x20>
		;
	p++;
  8c:	8d 58 01             	lea    0x1(%eax),%ebx

	// Return blank-padded name.
	if(strlen(p) >= DIRSIZ)
  8f:	89 1c 24             	mov    %ebx,(%esp)
  92:	e8 a9 03 00 00       	call   440 <strlen>
  97:	83 f8 0d             	cmp    $0xd,%eax
  9a:	77 53                	ja     ef <fmtname+0x8f>
		return p;
	memmove(buf, p, strlen(p));
  9c:	89 1c 24             	mov    %ebx,(%esp)
  9f:	e8 9c 03 00 00       	call   440 <strlen>
  a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  a8:	c7 04 24 24 0f 00 00 	movl   $0xf24,(%esp)
  af:	89 44 24 08          	mov    %eax,0x8(%esp)
  b3:	e8 f8 04 00 00       	call   5b0 <memmove>
	memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  b8:	89 1c 24             	mov    %ebx,(%esp)
  bb:	e8 80 03 00 00       	call   440 <strlen>
  c0:	89 1c 24             	mov    %ebx,(%esp)
	return buf;
  c3:	bb 24 0f 00 00       	mov    $0xf24,%ebx

	// Return blank-padded name.
	if(strlen(p) >= DIRSIZ)
		return p;
	memmove(buf, p, strlen(p));
	memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  c8:	89 c6                	mov    %eax,%esi
  ca:	e8 71 03 00 00       	call   440 <strlen>
  cf:	ba 0e 00 00 00       	mov    $0xe,%edx
  d4:	29 f2                	sub    %esi,%edx
  d6:	89 54 24 08          	mov    %edx,0x8(%esp)
  da:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  e1:	00 
  e2:	05 24 0f 00 00       	add    $0xf24,%eax
  e7:	89 04 24             	mov    %eax,(%esp)
  ea:	e8 81 03 00 00       	call   470 <memset>
	return buf;
}
  ef:	83 c4 10             	add    $0x10,%esp
  f2:	89 d8                	mov    %ebx,%eax
  f4:	5b                   	pop    %ebx
  f5:	5e                   	pop    %esi
  f6:	5d                   	pop    %ebp
  f7:	c3                   	ret    
  f8:	90                   	nop
  f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000100 <directw>:

void directw(char *path) {
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
	char buf[512], *p;
	int fd;
	struct dirent de;
	struct stat st;
	fd = open(path, 0);
 10f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 116:	00 
 117:	89 3c 24             	mov    %edi,(%esp)
 11a:	e8 03 05 00 00       	call   622 <open>
	if(fd < 0){
 11f:	85 c0                	test   %eax,%eax
void directw(char *path) {
	char buf[512], *p;
	int fd;
	struct dirent de;
	struct stat st;
	fd = open(path, 0);
 121:	89 c3                	mov    %eax,%ebx
	if(fd < 0){
 123:	0f 88 9f 01 00 00    	js     2c8 <directw+0x1c8>
		printf(2, "directorywalker: cannot open %s\n", path);
		return;
	}

	if(fstat(fd, &st) < 0){
 129:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 12f:	89 74 24 04          	mov    %esi,0x4(%esp)
 133:	89 04 24             	mov    %eax,(%esp)
 136:	e8 ff 04 00 00       	call   63a <fstat>
 13b:	85 c0                	test   %eax,%eax
 13d:	0f 88 cd 01 00 00    	js     310 <directw+0x210>
		printf(2, "directorywalker: cannot stat %s\n", path);
		close(fd);
		return;
	}

	switch(st.type){
 143:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 14a:	66 83 f8 01          	cmp    $0x1,%ax
 14e:	74 18                	je     168 <directw+0x68>
	case T_FILE:
		//printf(1,"---> File Located, Ending This Branch <--- \n");
		close(fd);
		return;
	}
	close(fd);
 150:	89 1c 24             	mov    %ebx,(%esp)
 153:	e8 b2 04 00 00       	call   60a <close>
}
 158:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 15e:	5b                   	pop    %ebx
 15f:	5e                   	pop    %esi
 160:	5f                   	pop    %edi
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	90                   	nop
 164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return;
	}

	switch(st.type){
	case T_DIR:
		printf(1,"---> Directory Located <--- \n");
 168:	c7 44 24 04 1c 0c 00 	movl   $0xc1c,0x4(%esp)
 16f:	00 
 170:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 177:	e8 c4 05 00 00       	call   740 <printf>
		if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 17c:	89 3c 24             	mov    %edi,(%esp)
 17f:	e8 bc 02 00 00       	call   440 <strlen>
 184:	83 c0 10             	add    $0x10,%eax
 187:	3d 00 02 00 00       	cmp    $0x200,%eax
 18c:	0f 87 5e 01 00 00    	ja     2f0 <directw+0x1f0>
			printf(1, "Directorywalker Error: path too long\n");
			break;
		}
		strcpy(buf, path);
 192:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 198:	89 7c 24 04          	mov    %edi,0x4(%esp)
 19c:	8d bd c4 fd ff ff    	lea    -0x23c(%ebp),%edi
 1a2:	89 04 24             	mov    %eax,(%esp)
 1a5:	e8 16 02 00 00       	call   3c0 <strcpy>
		p = buf+strlen(buf);
 1aa:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1b0:	89 04 24             	mov    %eax,(%esp)
 1b3:	e8 88 02 00 00       	call   440 <strlen>
 1b8:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 1be:	01 c8                	add    %ecx,%eax
		*p++ = '/';
 1c0:	8d 48 01             	lea    0x1(%eax),%ecx
		if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
			printf(1, "Directorywalker Error: path too long\n");
			break;
		}
		strcpy(buf, path);
		p = buf+strlen(buf);
 1c3:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
		*p++ = '/';
 1c9:	89 8d b0 fd ff ff    	mov    %ecx,-0x250(%ebp)
 1cf:	c6 00 2f             	movb   $0x2f,(%eax)
 1d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1d8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 1df:	00 
 1e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1e4:	89 1c 24             	mov    %ebx,(%esp)
 1e7:	e8 0e 04 00 00       	call   5fa <read>
 1ec:	83 f8 10             	cmp    $0x10,%eax
 1ef:	0f 85 5b ff ff ff    	jne    150 <directw+0x50>
			if(de.inum == 0){
 1f5:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 1fc:	00 
 1fd:	74 d9                	je     1d8 <directw+0xd8>
				continue;
			}

			memmove(p, de.name, DIRSIZ);
 1ff:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 205:	89 44 24 04          	mov    %eax,0x4(%esp)
 209:	8b 85 b0 fd ff ff    	mov    -0x250(%ebp),%eax
 20f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 216:	00 
 217:	89 04 24             	mov    %eax,(%esp)
 21a:	e8 91 03 00 00       	call   5b0 <memmove>
			//printf(1,"\t Directory Entry is called: %s\n", de.name);
			p[DIRSIZ] = 0;
 21f:	8b 85 b4 fd ff ff    	mov    -0x24c(%ebp),%eax
 225:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
			if(stat(buf, &st) < 0){
 229:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 22f:	89 74 24 04          	mov    %esi,0x4(%esp)
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 f5 02 00 00       	call   530 <stat>
 23b:	85 c0                	test   %eax,%eax
 23d:	0f 88 f5 00 00 00    	js     338 <directw+0x238>
				printf(1, "Directorywalker Error: cannot stat %s\n", buf);
				continue;
			}
			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
 243:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 249:	c7 44 24 04 3b 0c 00 	movl   $0xc3b,0x4(%esp)
 250:	00 
 251:	89 04 24             	mov    %eax,(%esp)
 254:	e8 97 01 00 00       	call   3f0 <strcmp>
 259:	85 c0                	test   %eax,%eax
 25b:	74 1e                	je     27b <directw+0x17b>
 25d:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 263:	c7 44 24 04 3a 0c 00 	movl   $0xc3a,0x4(%esp)
 26a:	00 
 26b:	89 04 24             	mov    %eax,(%esp)
 26e:	e8 7d 01 00 00       	call   3f0 <strcmp>
 273:	85 c0                	test   %eax,%eax
 275:	0f 85 e5 00 00 00    	jne    360 <directw+0x260>
				printf(1,"Directory Entry (./..): iNode # = %d \t Name = %s \t nlink: %d\n", st.ino, fmtname(buf), st.nlink);
 27b:	0f bf 95 e0 fd ff ff 	movswl -0x220(%ebp),%edx
 282:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 288:	89 04 24             	mov    %eax,(%esp)
 28b:	89 95 ac fd ff ff    	mov    %edx,-0x254(%ebp)
 291:	e8 ca fd ff ff       	call   60 <fmtname>
 296:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 29c:	c7 44 24 04 40 0b 00 	movl   $0xb40,0x4(%esp)
 2a3:	00 
 2a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2ab:	89 54 24 10          	mov    %edx,0x10(%esp)
 2af:	89 44 24 0c          	mov    %eax,0xc(%esp)
 2b3:	8b 85 dc fd ff ff    	mov    -0x224(%ebp),%eax
 2b9:	89 44 24 08          	mov    %eax,0x8(%esp)
 2bd:	e8 7e 04 00 00       	call   740 <printf>
				continue;
 2c2:	e9 11 ff ff ff       	jmp    1d8 <directw+0xd8>
 2c7:	90                   	nop
	int fd;
	struct dirent de;
	struct stat st;
	fd = open(path, 0);
	if(fd < 0){
		printf(2, "directorywalker: cannot open %s\n", path);
 2c8:	89 7c 24 08          	mov    %edi,0x8(%esp)
 2cc:	c7 44 24 04 a8 0a 00 	movl   $0xaa8,0x4(%esp)
 2d3:	00 
 2d4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2db:	e8 60 04 00 00       	call   740 <printf>
		//printf(1,"---> File Located, Ending This Branch <--- \n");
		close(fd);
		return;
	}
	close(fd);
}
 2e0:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2e6:	5b                   	pop    %ebx
 2e7:	5e                   	pop    %esi
 2e8:	5f                   	pop    %edi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    
 2eb:	90                   	nop
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

	switch(st.type){
	case T_DIR:
		printf(1,"---> Directory Located <--- \n");
		if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
			printf(1, "Directorywalker Error: path too long\n");
 2f0:	c7 44 24 04 f0 0a 00 	movl   $0xaf0,0x4(%esp)
 2f7:	00 
 2f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2ff:	e8 3c 04 00 00       	call   740 <printf>
			break;
 304:	e9 47 fe ff ff       	jmp    150 <directw+0x50>
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		printf(2, "directorywalker: cannot open %s\n", path);
		return;
	}

	if(fstat(fd, &st) < 0){
		printf(2, "directorywalker: cannot stat %s\n", path);
 310:	89 7c 24 08          	mov    %edi,0x8(%esp)
 314:	c7 44 24 04 cc 0a 00 	movl   $0xacc,0x4(%esp)
 31b:	00 
 31c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 323:	e8 18 04 00 00       	call   740 <printf>
		close(fd);
 328:	89 1c 24             	mov    %ebx,(%esp)
 32b:	e8 da 02 00 00       	call   60a <close>
		return;
 330:	e9 23 fe ff ff       	jmp    158 <directw+0x58>
 335:	8d 76 00             	lea    0x0(%esi),%esi

			memmove(p, de.name, DIRSIZ);
			//printf(1,"\t Directory Entry is called: %s\n", de.name);
			p[DIRSIZ] = 0;
			if(stat(buf, &st) < 0){
				printf(1, "Directorywalker Error: cannot stat %s\n", buf);
 338:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 33e:	89 44 24 08          	mov    %eax,0x8(%esp)
 342:	c7 44 24 04 18 0b 00 	movl   $0xb18,0x4(%esp)
 349:	00 
 34a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 351:	e8 ea 03 00 00       	call   740 <printf>
				continue;
 356:	e9 7d fe ff ff       	jmp    1d8 <directw+0xd8>
 35b:	90                   	nop
 35c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
				printf(1,"Directory Entry (./..): iNode # = %d \t Name = %s \t nlink: %d\n", st.ino, fmtname(buf), st.nlink);
				continue;
			}
			else{
				printf(1,"Directory Entry (File or Subdirectory): iNode # = %d \t Name = %s \t nlink: %d\n", st.ino, fmtname(buf), st.nlink);
 360:	0f bf 95 e0 fd ff ff 	movswl -0x220(%ebp),%edx
 367:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 36d:	89 04 24             	mov    %eax,(%esp)
 370:	89 95 ac fd ff ff    	mov    %edx,-0x254(%ebp)
 376:	e8 e5 fc ff ff       	call   60 <fmtname>
 37b:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 381:	c7 44 24 04 80 0b 00 	movl   $0xb80,0x4(%esp)
 388:	00 
 389:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 390:	89 54 24 10          	mov    %edx,0x10(%esp)
 394:	89 44 24 0c          	mov    %eax,0xc(%esp)
 398:	8b 85 dc fd ff ff    	mov    -0x224(%ebp),%eax
 39e:	89 44 24 08          	mov    %eax,0x8(%esp)
 3a2:	e8 99 03 00 00       	call   740 <printf>
				directw(buf);
 3a7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 3ad:	89 04 24             	mov    %eax,(%esp)
 3b0:	e8 4b fd ff ff       	call   100 <directw>
 3b5:	e9 1e fe ff ff       	jmp    1d8 <directw+0xd8>
 3ba:	66 90                	xchg   %ax,%ax
 3bc:	66 90                	xchg   %ax,%ax
 3be:	66 90                	xchg   %ax,%ax

000003c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 3c9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3ca:	89 c2                	mov    %eax,%edx
 3cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3d0:	83 c1 01             	add    $0x1,%ecx
 3d3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 3d7:	83 c2 01             	add    $0x1,%edx
 3da:	84 db                	test   %bl,%bl
 3dc:	88 5a ff             	mov    %bl,-0x1(%edx)
 3df:	75 ef                	jne    3d0 <strcpy+0x10>
    ;
  return os;
}
 3e1:	5b                   	pop    %ebx
 3e2:	5d                   	pop    %ebp
 3e3:	c3                   	ret    
 3e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	8b 55 08             	mov    0x8(%ebp),%edx
 3f6:	53                   	push   %ebx
 3f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3fa:	0f b6 02             	movzbl (%edx),%eax
 3fd:	84 c0                	test   %al,%al
 3ff:	74 2d                	je     42e <strcmp+0x3e>
 401:	0f b6 19             	movzbl (%ecx),%ebx
 404:	38 d8                	cmp    %bl,%al
 406:	74 0e                	je     416 <strcmp+0x26>
 408:	eb 2b                	jmp    435 <strcmp+0x45>
 40a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 410:	38 c8                	cmp    %cl,%al
 412:	75 15                	jne    429 <strcmp+0x39>
    p++, q++;
 414:	89 d9                	mov    %ebx,%ecx
 416:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 419:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 41c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 41f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 423:	84 c0                	test   %al,%al
 425:	75 e9                	jne    410 <strcmp+0x20>
 427:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 429:	29 c8                	sub    %ecx,%eax
}
 42b:	5b                   	pop    %ebx
 42c:	5d                   	pop    %ebp
 42d:	c3                   	ret    
 42e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 431:	31 c0                	xor    %eax,%eax
 433:	eb f4                	jmp    429 <strcmp+0x39>
 435:	0f b6 cb             	movzbl %bl,%ecx
 438:	eb ef                	jmp    429 <strcmp+0x39>
 43a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000440 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 446:	80 39 00             	cmpb   $0x0,(%ecx)
 449:	74 12                	je     45d <strlen+0x1d>
 44b:	31 d2                	xor    %edx,%edx
 44d:	8d 76 00             	lea    0x0(%esi),%esi
 450:	83 c2 01             	add    $0x1,%edx
 453:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 457:	89 d0                	mov    %edx,%eax
 459:	75 f5                	jne    450 <strlen+0x10>
    ;
  return n;
}
 45b:	5d                   	pop    %ebp
 45c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 45d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret    
 461:	eb 0d                	jmp    470 <memset>
 463:	90                   	nop
 464:	90                   	nop
 465:	90                   	nop
 466:	90                   	nop
 467:	90                   	nop
 468:	90                   	nop
 469:	90                   	nop
 46a:	90                   	nop
 46b:	90                   	nop
 46c:	90                   	nop
 46d:	90                   	nop
 46e:	90                   	nop
 46f:	90                   	nop

00000470 <memset>:

void*
memset(void *dst, int c, uint n)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	8b 55 08             	mov    0x8(%ebp),%edx
 476:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 477:	8b 4d 10             	mov    0x10(%ebp),%ecx
 47a:	8b 45 0c             	mov    0xc(%ebp),%eax
 47d:	89 d7                	mov    %edx,%edi
 47f:	fc                   	cld    
 480:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 482:	89 d0                	mov    %edx,%eax
 484:	5f                   	pop    %edi
 485:	5d                   	pop    %ebp
 486:	c3                   	ret    
 487:	89 f6                	mov    %esi,%esi
 489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000490 <strchr>:

char*
strchr(const char *s, char c)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	53                   	push   %ebx
 497:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 49a:	0f b6 18             	movzbl (%eax),%ebx
 49d:	84 db                	test   %bl,%bl
 49f:	74 1d                	je     4be <strchr+0x2e>
    if(*s == c)
 4a1:	38 d3                	cmp    %dl,%bl
 4a3:	89 d1                	mov    %edx,%ecx
 4a5:	75 0d                	jne    4b4 <strchr+0x24>
 4a7:	eb 17                	jmp    4c0 <strchr+0x30>
 4a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4b0:	38 ca                	cmp    %cl,%dl
 4b2:	74 0c                	je     4c0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 4b4:	83 c0 01             	add    $0x1,%eax
 4b7:	0f b6 10             	movzbl (%eax),%edx
 4ba:	84 d2                	test   %dl,%dl
 4bc:	75 f2                	jne    4b0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 4be:	31 c0                	xor    %eax,%eax
}
 4c0:	5b                   	pop    %ebx
 4c1:	5d                   	pop    %ebp
 4c2:	c3                   	ret    
 4c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004d0 <gets>:

char*
gets(char *buf, int max)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 4d7:	53                   	push   %ebx
 4d8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 4db:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4de:	eb 31                	jmp    511 <gets+0x41>
    cc = read(0, &c, 1);
 4e0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e7:	00 
 4e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 4ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4f3:	e8 02 01 00 00       	call   5fa <read>
    if(cc < 1)
 4f8:	85 c0                	test   %eax,%eax
 4fa:	7e 1d                	jle    519 <gets+0x49>
      break;
    buf[i++] = c;
 4fc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 500:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 502:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 505:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 507:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 50b:	74 0c                	je     519 <gets+0x49>
 50d:	3c 0a                	cmp    $0xa,%al
 50f:	74 08                	je     519 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 511:	8d 5e 01             	lea    0x1(%esi),%ebx
 514:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 517:	7c c7                	jl     4e0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 519:	8b 45 08             	mov    0x8(%ebp),%eax
 51c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 520:	83 c4 2c             	add    $0x2c,%esp
 523:	5b                   	pop    %ebx
 524:	5e                   	pop    %esi
 525:	5f                   	pop    %edi
 526:	5d                   	pop    %ebp
 527:	c3                   	ret    
 528:	90                   	nop
 529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000530 <stat>:

int
stat(char *n, struct stat *st)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	56                   	push   %esi
 534:	53                   	push   %ebx
 535:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 538:	8b 45 08             	mov    0x8(%ebp),%eax
 53b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 542:	00 
 543:	89 04 24             	mov    %eax,(%esp)
 546:	e8 d7 00 00 00       	call   622 <open>
  if(fd < 0)
 54b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 54d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 54f:	78 27                	js     578 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 551:	8b 45 0c             	mov    0xc(%ebp),%eax
 554:	89 1c 24             	mov    %ebx,(%esp)
 557:	89 44 24 04          	mov    %eax,0x4(%esp)
 55b:	e8 da 00 00 00       	call   63a <fstat>
  close(fd);
 560:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 563:	89 c6                	mov    %eax,%esi
  close(fd);
 565:	e8 a0 00 00 00       	call   60a <close>
  return r;
 56a:	89 f0                	mov    %esi,%eax
}
 56c:	83 c4 10             	add    $0x10,%esp
 56f:	5b                   	pop    %ebx
 570:	5e                   	pop    %esi
 571:	5d                   	pop    %ebp
 572:	c3                   	ret    
 573:	90                   	nop
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 57d:	eb ed                	jmp    56c <stat+0x3c>
 57f:	90                   	nop

00000580 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	8b 4d 08             	mov    0x8(%ebp),%ecx
 586:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 587:	0f be 11             	movsbl (%ecx),%edx
 58a:	8d 42 d0             	lea    -0x30(%edx),%eax
 58d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 58f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 594:	77 17                	ja     5ad <atoi+0x2d>
 596:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 598:	83 c1 01             	add    $0x1,%ecx
 59b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 59e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5a2:	0f be 11             	movsbl (%ecx),%edx
 5a5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 5a8:	80 fb 09             	cmp    $0x9,%bl
 5ab:	76 eb                	jbe    598 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 5ad:	5b                   	pop    %ebx
 5ae:	5d                   	pop    %ebp
 5af:	c3                   	ret    

000005b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5b0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5b1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 5b3:	89 e5                	mov    %esp,%ebp
 5b5:	56                   	push   %esi
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
 5b9:	53                   	push   %ebx
 5ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5bd:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5c0:	85 db                	test   %ebx,%ebx
 5c2:	7e 12                	jle    5d6 <memmove+0x26>
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 5c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 5cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 5cf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5d2:	39 da                	cmp    %ebx,%edx
 5d4:	75 f2                	jne    5c8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 5d6:	5b                   	pop    %ebx
 5d7:	5e                   	pop    %esi
 5d8:	5d                   	pop    %ebp
 5d9:	c3                   	ret    

000005da <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5da:	b8 01 00 00 00       	mov    $0x1,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <exit>:
SYSCALL(exit)
 5e2:	b8 02 00 00 00       	mov    $0x2,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <wait>:
SYSCALL(wait)
 5ea:	b8 03 00 00 00       	mov    $0x3,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <pipe>:
SYSCALL(pipe)
 5f2:	b8 04 00 00 00       	mov    $0x4,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <read>:
SYSCALL(read)
 5fa:	b8 05 00 00 00       	mov    $0x5,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <write>:
SYSCALL(write)
 602:	b8 10 00 00 00       	mov    $0x10,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <close>:
SYSCALL(close)
 60a:	b8 15 00 00 00       	mov    $0x15,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <kill>:
SYSCALL(kill)
 612:	b8 06 00 00 00       	mov    $0x6,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <exec>:
SYSCALL(exec)
 61a:	b8 07 00 00 00       	mov    $0x7,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <open>:
SYSCALL(open)
 622:	b8 0f 00 00 00       	mov    $0xf,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <mknod>:
SYSCALL(mknod)
 62a:	b8 11 00 00 00       	mov    $0x11,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <unlink>:
SYSCALL(unlink)
 632:	b8 12 00 00 00       	mov    $0x12,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <fstat>:
SYSCALL(fstat)
 63a:	b8 08 00 00 00       	mov    $0x8,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <link>:
SYSCALL(link)
 642:	b8 13 00 00 00       	mov    $0x13,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <mkdir>:
SYSCALL(mkdir)
 64a:	b8 14 00 00 00       	mov    $0x14,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <chdir>:
SYSCALL(chdir)
 652:	b8 09 00 00 00       	mov    $0x9,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <dup>:
SYSCALL(dup)
 65a:	b8 0a 00 00 00       	mov    $0xa,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <getpid>:
SYSCALL(getpid)
 662:	b8 0b 00 00 00       	mov    $0xb,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <sbrk>:
SYSCALL(sbrk)
 66a:	b8 0c 00 00 00       	mov    $0xc,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <sleep>:
SYSCALL(sleep)
 672:	b8 0d 00 00 00       	mov    $0xd,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <uptime>:
SYSCALL(uptime)
 67a:	b8 0e 00 00 00       	mov    $0xe,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <myMemory>:
SYSCALL(myMemory)
 682:	b8 16 00 00 00       	mov    $0x16,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <inodeTBWalker>:
SYSCALL(inodeTBWalker)
 68a:	b8 17 00 00 00       	mov    $0x17,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <deleteIData>:
SYSCALL(deleteIData)
 692:	b8 18 00 00 00       	mov    $0x18,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    
 69a:	66 90                	xchg   %ax,%ax
 69c:	66 90                	xchg   %ax,%ax
 69e:	66 90                	xchg   %ax,%ax

000006a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	89 c6                	mov    %eax,%esi
 6a7:	53                   	push   %ebx
 6a8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6ae:	85 db                	test   %ebx,%ebx
 6b0:	74 09                	je     6bb <printint+0x1b>
 6b2:	89 d0                	mov    %edx,%eax
 6b4:	c1 e8 1f             	shr    $0x1f,%eax
 6b7:	84 c0                	test   %al,%al
 6b9:	75 75                	jne    730 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6bb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6bd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6c4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 6c7:	31 ff                	xor    %edi,%edi
 6c9:	89 ce                	mov    %ecx,%esi
 6cb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 6ce:	eb 02                	jmp    6d2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 6d0:	89 cf                	mov    %ecx,%edi
 6d2:	31 d2                	xor    %edx,%edx
 6d4:	f7 f6                	div    %esi
 6d6:	8d 4f 01             	lea    0x1(%edi),%ecx
 6d9:	0f b6 92 47 0c 00 00 	movzbl 0xc47(%edx),%edx
  }while((x /= base) != 0);
 6e0:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 6e2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 6e5:	75 e9                	jne    6d0 <printint+0x30>
  if(neg)
 6e7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 6ea:	89 c8                	mov    %ecx,%eax
 6ec:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 6ef:	85 d2                	test   %edx,%edx
 6f1:	74 08                	je     6fb <printint+0x5b>
    buf[i++] = '-';
 6f3:	8d 4f 02             	lea    0x2(%edi),%ecx
 6f6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 6fb:	8d 79 ff             	lea    -0x1(%ecx),%edi
 6fe:	66 90                	xchg   %ax,%ax
 700:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 705:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 708:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 70f:	00 
 710:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 714:	89 34 24             	mov    %esi,(%esp)
 717:	88 45 d7             	mov    %al,-0x29(%ebp)
 71a:	e8 e3 fe ff ff       	call   602 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 71f:	83 ff ff             	cmp    $0xffffffff,%edi
 722:	75 dc                	jne    700 <printint+0x60>
    putc(fd, buf[i]);
}
 724:	83 c4 4c             	add    $0x4c,%esp
 727:	5b                   	pop    %ebx
 728:	5e                   	pop    %esi
 729:	5f                   	pop    %edi
 72a:	5d                   	pop    %ebp
 72b:	c3                   	ret    
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 730:	89 d0                	mov    %edx,%eax
 732:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 734:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 73b:	eb 87                	jmp    6c4 <printint+0x24>
 73d:	8d 76 00             	lea    0x0(%esi),%esi

00000740 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 744:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 746:	56                   	push   %esi
 747:	53                   	push   %ebx
 748:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 74b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 74e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 751:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 754:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 757:	0f b6 13             	movzbl (%ebx),%edx
 75a:	83 c3 01             	add    $0x1,%ebx
 75d:	84 d2                	test   %dl,%dl
 75f:	75 39                	jne    79a <printf+0x5a>
 761:	e9 c2 00 00 00       	jmp    828 <printf+0xe8>
 766:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 768:	83 fa 25             	cmp    $0x25,%edx
 76b:	0f 84 bf 00 00 00    	je     830 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 771:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 774:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 77b:	00 
 77c:	89 44 24 04          	mov    %eax,0x4(%esp)
 780:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 783:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 786:	e8 77 fe ff ff       	call   602 <write>
 78b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 78e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 792:	84 d2                	test   %dl,%dl
 794:	0f 84 8e 00 00 00    	je     828 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 79a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 79c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 79f:	74 c7                	je     768 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7a1:	83 ff 25             	cmp    $0x25,%edi
 7a4:	75 e5                	jne    78b <printf+0x4b>
      if(c == 'd'){
 7a6:	83 fa 64             	cmp    $0x64,%edx
 7a9:	0f 84 31 01 00 00    	je     8e0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7af:	25 f7 00 00 00       	and    $0xf7,%eax
 7b4:	83 f8 70             	cmp    $0x70,%eax
 7b7:	0f 84 83 00 00 00    	je     840 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7bd:	83 fa 73             	cmp    $0x73,%edx
 7c0:	0f 84 a2 00 00 00    	je     868 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7c6:	83 fa 63             	cmp    $0x63,%edx
 7c9:	0f 84 35 01 00 00    	je     904 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7cf:	83 fa 25             	cmp    $0x25,%edx
 7d2:	0f 84 e0 00 00 00    	je     8b8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7d8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7db:	83 c3 01             	add    $0x1,%ebx
 7de:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7e5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7e6:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ec:	89 34 24             	mov    %esi,(%esp)
 7ef:	89 55 d0             	mov    %edx,-0x30(%ebp)
 7f2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 7f6:	e8 07 fe ff ff       	call   602 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7fe:	8d 45 e7             	lea    -0x19(%ebp),%eax
 801:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 808:	00 
 809:	89 44 24 04          	mov    %eax,0x4(%esp)
 80d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 810:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 813:	e8 ea fd ff ff       	call   602 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 818:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 81c:	84 d2                	test   %dl,%dl
 81e:	0f 85 76 ff ff ff    	jne    79a <printf+0x5a>
 824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 828:	83 c4 3c             	add    $0x3c,%esp
 82b:	5b                   	pop    %ebx
 82c:	5e                   	pop    %esi
 82d:	5f                   	pop    %edi
 82e:	5d                   	pop    %ebp
 82f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 830:	bf 25 00 00 00       	mov    $0x25,%edi
 835:	e9 51 ff ff ff       	jmp    78b <printf+0x4b>
 83a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 840:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 843:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 848:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 84a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 851:	8b 10                	mov    (%eax),%edx
 853:	89 f0                	mov    %esi,%eax
 855:	e8 46 fe ff ff       	call   6a0 <printint>
        ap++;
 85a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 85e:	e9 28 ff ff ff       	jmp    78b <printf+0x4b>
 863:	90                   	nop
 864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 868:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 86b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 86f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 871:	b8 40 0c 00 00       	mov    $0xc40,%eax
 876:	85 ff                	test   %edi,%edi
 878:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 87b:	0f b6 07             	movzbl (%edi),%eax
 87e:	84 c0                	test   %al,%al
 880:	74 2a                	je     8ac <printf+0x16c>
 882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 888:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 88b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 88e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 891:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 898:	00 
 899:	89 44 24 04          	mov    %eax,0x4(%esp)
 89d:	89 34 24             	mov    %esi,(%esp)
 8a0:	e8 5d fd ff ff       	call   602 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8a5:	0f b6 07             	movzbl (%edi),%eax
 8a8:	84 c0                	test   %al,%al
 8aa:	75 dc                	jne    888 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8ac:	31 ff                	xor    %edi,%edi
 8ae:	e9 d8 fe ff ff       	jmp    78b <printf+0x4b>
 8b3:	90                   	nop
 8b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8b8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8bb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8bd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8c4:	00 
 8c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c9:	89 34 24             	mov    %esi,(%esp)
 8cc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 8d0:	e8 2d fd ff ff       	call   602 <write>
 8d5:	e9 b1 fe ff ff       	jmp    78b <printf+0x4b>
 8da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 8e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 8e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8e8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 8eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8f2:	8b 10                	mov    (%eax),%edx
 8f4:	89 f0                	mov    %esi,%eax
 8f6:	e8 a5 fd ff ff       	call   6a0 <printint>
        ap++;
 8fb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 8ff:	e9 87 fe ff ff       	jmp    78b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 904:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 907:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 909:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 90b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 912:	00 
 913:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 916:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 919:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 91c:	89 44 24 04          	mov    %eax,0x4(%esp)
 920:	e8 dd fc ff ff       	call   602 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 925:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 929:	e9 5d fe ff ff       	jmp    78b <printf+0x4b>
 92e:	66 90                	xchg   %ax,%ax

00000930 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 930:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 931:	a1 34 0f 00 00       	mov    0xf34,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 936:	89 e5                	mov    %esp,%ebp
 938:	57                   	push   %edi
 939:	56                   	push   %esi
 93a:	53                   	push   %ebx
 93b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 940:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 943:	39 d0                	cmp    %edx,%eax
 945:	72 11                	jb     958 <free+0x28>
 947:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 948:	39 c8                	cmp    %ecx,%eax
 94a:	72 04                	jb     950 <free+0x20>
 94c:	39 ca                	cmp    %ecx,%edx
 94e:	72 10                	jb     960 <free+0x30>
 950:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 952:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 954:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 956:	73 f0                	jae    948 <free+0x18>
 958:	39 ca                	cmp    %ecx,%edx
 95a:	72 04                	jb     960 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95c:	39 c8                	cmp    %ecx,%eax
 95e:	72 f0                	jb     950 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 960:	8b 73 fc             	mov    -0x4(%ebx),%esi
 963:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 966:	39 cf                	cmp    %ecx,%edi
 968:	74 1e                	je     988 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 96a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 96d:	8b 48 04             	mov    0x4(%eax),%ecx
 970:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 973:	39 f2                	cmp    %esi,%edx
 975:	74 28                	je     99f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 977:	89 10                	mov    %edx,(%eax)
  freep = p;
 979:	a3 34 0f 00 00       	mov    %eax,0xf34
}
 97e:	5b                   	pop    %ebx
 97f:	5e                   	pop    %esi
 980:	5f                   	pop    %edi
 981:	5d                   	pop    %ebp
 982:	c3                   	ret    
 983:	90                   	nop
 984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 988:	03 71 04             	add    0x4(%ecx),%esi
 98b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 98e:	8b 08                	mov    (%eax),%ecx
 990:	8b 09                	mov    (%ecx),%ecx
 992:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 995:	8b 48 04             	mov    0x4(%eax),%ecx
 998:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 99b:	39 f2                	cmp    %esi,%edx
 99d:	75 d8                	jne    977 <free+0x47>
    p->s.size += bp->s.size;
 99f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 9a2:	a3 34 0f 00 00       	mov    %eax,0xf34
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9a7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9aa:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9ad:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 9af:	5b                   	pop    %ebx
 9b0:	5e                   	pop    %esi
 9b1:	5f                   	pop    %edi
 9b2:	5d                   	pop    %ebp
 9b3:	c3                   	ret    
 9b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 9ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000009c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	57                   	push   %edi
 9c4:	56                   	push   %esi
 9c5:	53                   	push   %ebx
 9c6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9cc:	8b 1d 34 0f 00 00    	mov    0xf34,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d2:	8d 48 07             	lea    0x7(%eax),%ecx
 9d5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 9d8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9da:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 9dd:	0f 84 9b 00 00 00    	je     a7e <malloc+0xbe>
 9e3:	8b 13                	mov    (%ebx),%edx
 9e5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 9e8:	39 fe                	cmp    %edi,%esi
 9ea:	76 64                	jbe    a50 <malloc+0x90>
 9ec:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 9f3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 9f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 9fb:	eb 0e                	jmp    a0b <malloc+0x4b>
 9fd:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a00:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a02:	8b 78 04             	mov    0x4(%eax),%edi
 a05:	39 fe                	cmp    %edi,%esi
 a07:	76 4f                	jbe    a58 <malloc+0x98>
 a09:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a0b:	3b 15 34 0f 00 00    	cmp    0xf34,%edx
 a11:	75 ed                	jne    a00 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a16:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 a1c:	bf 00 10 00 00       	mov    $0x1000,%edi
 a21:	0f 43 fe             	cmovae %esi,%edi
 a24:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 a27:	89 04 24             	mov    %eax,(%esp)
 a2a:	e8 3b fc ff ff       	call   66a <sbrk>
  if(p == (char*)-1)
 a2f:	83 f8 ff             	cmp    $0xffffffff,%eax
 a32:	74 18                	je     a4c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 a34:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 a37:	83 c0 08             	add    $0x8,%eax
 a3a:	89 04 24             	mov    %eax,(%esp)
 a3d:	e8 ee fe ff ff       	call   930 <free>
  return freep;
 a42:	8b 15 34 0f 00 00    	mov    0xf34,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 a48:	85 d2                	test   %edx,%edx
 a4a:	75 b4                	jne    a00 <malloc+0x40>
        return 0;
 a4c:	31 c0                	xor    %eax,%eax
 a4e:	eb 20                	jmp    a70 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 a50:	89 d0                	mov    %edx,%eax
 a52:	89 da                	mov    %ebx,%edx
 a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 a58:	39 fe                	cmp    %edi,%esi
 a5a:	74 1c                	je     a78 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 a5c:	29 f7                	sub    %esi,%edi
 a5e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 a61:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 a64:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 a67:	89 15 34 0f 00 00    	mov    %edx,0xf34
      return (void*)(p + 1);
 a6d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a70:	83 c4 1c             	add    $0x1c,%esp
 a73:	5b                   	pop    %ebx
 a74:	5e                   	pop    %esi
 a75:	5f                   	pop    %edi
 a76:	5d                   	pop    %ebp
 a77:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 a78:	8b 08                	mov    (%eax),%ecx
 a7a:	89 0a                	mov    %ecx,(%edx)
 a7c:	eb e9                	jmp    a67 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a7e:	c7 05 34 0f 00 00 38 	movl   $0xf38,0xf34
 a85:	0f 00 00 
    base.s.size = 0;
 a88:	ba 38 0f 00 00       	mov    $0xf38,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a8d:	c7 05 38 0f 00 00 38 	movl   $0xf38,0xf38
 a94:	0f 00 00 
    base.s.size = 0;
 a97:	c7 05 3c 0f 00 00 00 	movl   $0x0,0xf3c
 a9e:	00 00 00 
 aa1:	e9 46 ff ff ff       	jmp    9ec <malloc+0x2c>