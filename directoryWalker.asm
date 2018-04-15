
_directoryWalker:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
		return;
	}
	close(fd);
}

int main(int argc, char *argv[]) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 10             	sub    $0x10,%esp
	mkdir("testdir");
   a:	c7 04 24 a5 0c 00 00 	movl   $0xca5,(%esp)
  11:	e8 94 06 00 00       	call   6aa <mkdir>
	int fd;
	fd = open("/testdir/smallTestFile", O_CREATE | O_RDWR);
  16:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1d:	00 
  1e:	c7 04 24 ad 0c 00 00 	movl   $0xcad,(%esp)
  25:	e8 58 06 00 00       	call   682 <open>
	if(fd >= 0){
  2a:	85 c0                	test   %eax,%eax
}

int main(int argc, char *argv[]) {
	mkdir("testdir");
	int fd;
	fd = open("/testdir/smallTestFile", O_CREATE | O_RDWR);
  2c:	89 c3                	mov    %eax,%ebx
	if(fd >= 0){
  2e:	78 14                	js     44 <main+0x44>
		printf(1, "----> File creation successful.\n");
  30:	c7 44 24 04 60 0c 00 	movl   $0xc60,0x4(%esp)
  37:	00 
  38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3f:	e8 4c 07 00 00       	call   790 <printf>
	}
	write(fd, "22", 2);
  44:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  4b:	00 
  4c:	c7 44 24 04 c4 0c 00 	movl   $0xcc4,0x4(%esp)
  53:	00 
  54:	89 1c 24             	mov    %ebx,(%esp)
  57:	e8 06 06 00 00       	call   662 <write>
	close(fd);
  5c:	89 1c 24             	mov    %ebx,(%esp)
  5f:	e8 06 06 00 00       	call   66a <close>

	if(argc < 2){
  64:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  68:	7e 13                	jle    7d <main+0x7d>
		directw(".");
		exit();
	}

	directw(argv[1]);
  6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  6d:	8b 40 04             	mov    0x4(%eax),%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 b8 00 00 00       	call   130 <directw>
	exit();
  78:	e8 c5 05 00 00       	call   642 <exit>
	}
	write(fd, "22", 2);
	close(fd);

	if(argc < 2){
		directw(".");
  7d:	c7 04 24 a3 0c 00 00 	movl   $0xca3,(%esp)
  84:	e8 a7 00 00 00       	call   130 <directw>
		exit();
  89:	e8 b4 05 00 00       	call   642 <exit>
  8e:	66 90                	xchg   %ax,%ax

00000090 <fmtname>:
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

char* fmtname(char *path) {
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	56                   	push   %esi
  94:	53                   	push   %ebx
  95:	83 ec 10             	sub    $0x10,%esp
  98:	8b 5d 08             	mov    0x8(%ebp),%ebx
	static char buf[DIRSIZ+1];
	char *p;

	// Find first character after last slash.
	for(p=path+strlen(path); p >= path && *p != '/'; p--)
  9b:	89 1c 24             	mov    %ebx,(%esp)
  9e:	e8 fd 03 00 00       	call   4a0 <strlen>
  a3:	01 d8                	add    %ebx,%eax
  a5:	73 10                	jae    b7 <fmtname+0x27>
  a7:	eb 13                	jmp    bc <fmtname+0x2c>
  a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  b0:	83 e8 01             	sub    $0x1,%eax
  b3:	39 c3                	cmp    %eax,%ebx
  b5:	77 05                	ja     bc <fmtname+0x2c>
  b7:	80 38 2f             	cmpb   $0x2f,(%eax)
  ba:	75 f4                	jne    b0 <fmtname+0x20>
		;
	p++;
  bc:	8d 58 01             	lea    0x1(%eax),%ebx

	// Return blank-padded name.
	if(strlen(p) >= DIRSIZ)
  bf:	89 1c 24             	mov    %ebx,(%esp)
  c2:	e8 d9 03 00 00       	call   4a0 <strlen>
  c7:	83 f8 0d             	cmp    $0xd,%eax
  ca:	77 53                	ja     11f <fmtname+0x8f>
		return p;
	memmove(buf, p, strlen(p));
  cc:	89 1c 24             	mov    %ebx,(%esp)
  cf:	e8 cc 03 00 00       	call   4a0 <strlen>
  d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  d8:	c7 04 24 c0 0f 00 00 	movl   $0xfc0,(%esp)
  df:	89 44 24 08          	mov    %eax,0x8(%esp)
  e3:	e8 28 05 00 00       	call   610 <memmove>
	memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  e8:	89 1c 24             	mov    %ebx,(%esp)
  eb:	e8 b0 03 00 00       	call   4a0 <strlen>
  f0:	89 1c 24             	mov    %ebx,(%esp)
	return buf;
  f3:	bb c0 0f 00 00       	mov    $0xfc0,%ebx

	// Return blank-padded name.
	if(strlen(p) >= DIRSIZ)
		return p;
	memmove(buf, p, strlen(p));
	memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  f8:	89 c6                	mov    %eax,%esi
  fa:	e8 a1 03 00 00       	call   4a0 <strlen>
  ff:	ba 0e 00 00 00       	mov    $0xe,%edx
 104:	29 f2                	sub    %esi,%edx
 106:	89 54 24 08          	mov    %edx,0x8(%esp)
 10a:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
 111:	00 
 112:	05 c0 0f 00 00       	add    $0xfc0,%eax
 117:	89 04 24             	mov    %eax,(%esp)
 11a:	e8 b1 03 00 00       	call   4d0 <memset>
	return buf;
}
 11f:	83 c4 10             	add    $0x10,%esp
 122:	89 d8                	mov    %ebx,%eax
 124:	5b                   	pop    %ebx
 125:	5e                   	pop    %esi
 126:	5d                   	pop    %ebp
 127:	c3                   	ret    
 128:	90                   	nop
 129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000130 <directw>:

void directw(char *path) {
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	56                   	push   %esi
 135:	53                   	push   %ebx
 136:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
 13c:	8b 7d 08             	mov    0x8(%ebp),%edi
	static int level=0;
	char buf[512], *p;
	int fd;
	struct dirent de;
	struct stat st;
	fd = open(path, 0);
 13f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 146:	00 
 147:	89 3c 24             	mov    %edi,(%esp)
 14a:	e8 33 05 00 00       	call   682 <open>
	if(fd < 0){
 14f:	85 c0                	test   %eax,%eax
	static int level=0;
	char buf[512], *p;
	int fd;
	struct dirent de;
	struct stat st;
	fd = open(path, 0);
 151:	89 c3                	mov    %eax,%ebx
	if(fd < 0){
 153:	0f 88 ef 01 00 00    	js     348 <directw+0x218>
		printf(2, "directorywalker: cannot open %s\n", path);
		return;
	}

	if(fstat(fd, &st) < 0){
 159:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 15f:	89 74 24 04          	mov    %esi,0x4(%esp)
 163:	89 04 24             	mov    %eax,(%esp)
 166:	e8 2f 05 00 00       	call   69a <fstat>
 16b:	85 c0                	test   %eax,%eax
 16d:	0f 88 fd 01 00 00    	js     370 <directw+0x240>
		printf(2, "directorywalker: cannot stat %s\n", path);
		close(fd);
		return;
	}

	switch(st.type){
 173:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 17a:	66 83 f8 01          	cmp    $0x1,%ax
 17e:	74 38                	je     1b8 <directw+0x88>
 180:	66 83 f8 02          	cmp    $0x2,%ax
 184:	0f 85 aa 01 00 00    	jne    334 <directw+0x204>
				directw(buf);
			}
		}
		break;
	case T_FILE:
		printf(1,"---> File Located, Ending This Branch <--- \n");
 18a:	c7 44 24 04 30 0c 00 	movl   $0xc30,0x4(%esp)
 191:	00 
 192:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 199:	e8 f2 05 00 00       	call   790 <printf>
		close(fd);
 19e:	89 1c 24             	mov    %ebx,(%esp)
 1a1:	e8 c4 04 00 00       	call   66a <close>
		return;
	}
	close(fd);
}
 1a6:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 1ac:	5b                   	pop    %ebx
 1ad:	5e                   	pop    %esi
 1ae:	5f                   	pop    %edi
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    
 1b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		return;
	}

	switch(st.type){
	case T_DIR:
		printf(1,"---> Directory Located <--- \n");
 1b8:	c7 44 24 04 84 0c 00 	movl   $0xc84,0x4(%esp)
 1bf:	00 
 1c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c7:	e8 c4 05 00 00       	call   790 <printf>
		++level;
		if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1cc:	89 3c 24             	mov    %edi,(%esp)
	}

	switch(st.type){
	case T_DIR:
		printf(1,"---> Directory Located <--- \n");
		++level;
 1cf:	83 05 bc 0f 00 00 01 	addl   $0x1,0xfbc
		if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1d6:	e8 c5 02 00 00       	call   4a0 <strlen>
 1db:	83 c0 10             	add    $0x10,%eax
 1de:	3d 00 02 00 00       	cmp    $0x200,%eax
 1e3:	0f 87 37 01 00 00    	ja     320 <directw+0x1f0>
			printf(1, "Directorywalker Error: path too long\n");
			break;
		}
		strcpy(buf, path);
 1e9:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1ef:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1f3:	8d bd c4 fd ff ff    	lea    -0x23c(%ebp),%edi
 1f9:	89 04 24             	mov    %eax,(%esp)
 1fc:	e8 1f 02 00 00       	call   420 <strcpy>
		p = buf+strlen(buf);
 201:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 207:	89 04 24             	mov    %eax,(%esp)
 20a:	e8 91 02 00 00       	call   4a0 <strlen>
 20f:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 215:	01 c8                	add    %ecx,%eax
		*p++ = '/';
 217:	8d 48 01             	lea    0x1(%eax),%ecx
		if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
			printf(1, "Directorywalker Error: path too long\n");
			break;
		}
		strcpy(buf, path);
		p = buf+strlen(buf);
 21a:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
		*p++ = '/';
 220:	89 8d b0 fd ff ff    	mov    %ecx,-0x250(%ebp)
 226:	c6 00 2f             	movb   $0x2f,(%eax)
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		while(read(fd, &de, sizeof(de)) == sizeof(de)){
 230:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 237:	00 
 238:	89 7c 24 04          	mov    %edi,0x4(%esp)
 23c:	89 1c 24             	mov    %ebx,(%esp)
 23f:	e8 16 04 00 00       	call   65a <read>
 244:	83 f8 10             	cmp    $0x10,%eax
 247:	0f 85 e7 00 00 00    	jne    334 <directw+0x204>
			if(de.inum == 0){
 24d:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 254:	00 
 255:	74 d9                	je     230 <directw+0x100>
				continue;
			}

			memmove(p, de.name, DIRSIZ);
 257:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 25d:	89 44 24 04          	mov    %eax,0x4(%esp)
 261:	8b 85 b0 fd ff ff    	mov    -0x250(%ebp),%eax
 267:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 26e:	00 
 26f:	89 04 24             	mov    %eax,(%esp)
 272:	e8 99 03 00 00       	call   610 <memmove>
			//printf(1,"\t Directory Entry is called: %s\n", de.name);
			p[DIRSIZ] = 0;
 277:	8b 85 b4 fd ff ff    	mov    -0x24c(%ebp),%eax
 27d:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
			if(stat(buf, &st) < 0){
 281:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 287:	89 74 24 04          	mov    %esi,0x4(%esp)
 28b:	89 04 24             	mov    %eax,(%esp)
 28e:	e8 fd 02 00 00       	call   590 <stat>
 293:	85 c0                	test   %eax,%eax
 295:	0f 88 fd 00 00 00    	js     398 <directw+0x268>
				printf(1, "Directorywalker Error: cannot stat %s\n", buf);
				continue;
			}
			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
 29b:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 2a1:	c7 44 24 04 a3 0c 00 	movl   $0xca3,0x4(%esp)
 2a8:	00 
 2a9:	89 04 24             	mov    %eax,(%esp)
 2ac:	e8 9f 01 00 00       	call   450 <strcmp>
 2b1:	85 c0                	test   %eax,%eax
 2b3:	74 1e                	je     2d3 <directw+0x1a3>
 2b5:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 2bb:	c7 44 24 04 a2 0c 00 	movl   $0xca2,0x4(%esp)
 2c2:	00 
 2c3:	89 04 24             	mov    %eax,(%esp)
 2c6:	e8 85 01 00 00       	call   450 <strcmp>
 2cb:	85 c0                	test   %eax,%eax
 2cd:	0f 85 ed 00 00 00    	jne    3c0 <directw+0x290>
				printf(1,"Directory Entry (./..): iNode # = %d \t Name = %s \t Level = %d\n", st.ino, fmtname(buf),level);
 2d3:	8b 15 bc 0f 00 00    	mov    0xfbc,%edx
 2d9:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 2df:	89 04 24             	mov    %eax,(%esp)
 2e2:	89 95 ac fd ff ff    	mov    %edx,-0x254(%ebp)
 2e8:	e8 a3 fd ff ff       	call   90 <fmtname>
 2ed:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 2f3:	c7 44 24 04 90 0b 00 	movl   $0xb90,0x4(%esp)
 2fa:	00 
 2fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 302:	89 54 24 10          	mov    %edx,0x10(%esp)
 306:	89 44 24 0c          	mov    %eax,0xc(%esp)
 30a:	8b 85 dc fd ff ff    	mov    -0x224(%ebp),%eax
 310:	89 44 24 08          	mov    %eax,0x8(%esp)
 314:	e8 77 04 00 00       	call   790 <printf>
				continue;
 319:	e9 12 ff ff ff       	jmp    230 <directw+0x100>
 31e:	66 90                	xchg   %ax,%ax
	switch(st.type){
	case T_DIR:
		printf(1,"---> Directory Located <--- \n");
		++level;
		if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
			printf(1, "Directorywalker Error: path too long\n");
 320:	c7 44 24 04 40 0b 00 	movl   $0xb40,0x4(%esp)
 327:	00 
 328:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 32f:	e8 5c 04 00 00       	call   790 <printf>
	case T_FILE:
		printf(1,"---> File Located, Ending This Branch <--- \n");
		close(fd);
		return;
	}
	close(fd);
 334:	89 1c 24             	mov    %ebx,(%esp)
 337:	e8 2e 03 00 00       	call   66a <close>
}
 33c:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 342:	5b                   	pop    %ebx
 343:	5e                   	pop    %esi
 344:	5f                   	pop    %edi
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    
 347:	90                   	nop
	int fd;
	struct dirent de;
	struct stat st;
	fd = open(path, 0);
	if(fd < 0){
		printf(2, "directorywalker: cannot open %s\n", path);
 348:	89 7c 24 08          	mov    %edi,0x8(%esp)
 34c:	c7 44 24 04 f8 0a 00 	movl   $0xaf8,0x4(%esp)
 353:	00 
 354:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 35b:	e8 30 04 00 00       	call   790 <printf>
		printf(1,"---> File Located, Ending This Branch <--- \n");
		close(fd);
		return;
	}
	close(fd);
}
 360:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 366:	5b                   	pop    %ebx
 367:	5e                   	pop    %esi
 368:	5f                   	pop    %edi
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret    
 36b:	90                   	nop
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		printf(2, "directorywalker: cannot open %s\n", path);
		return;
	}

	if(fstat(fd, &st) < 0){
		printf(2, "directorywalker: cannot stat %s\n", path);
 370:	89 7c 24 08          	mov    %edi,0x8(%esp)
 374:	c7 44 24 04 1c 0b 00 	movl   $0xb1c,0x4(%esp)
 37b:	00 
 37c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 383:	e8 08 04 00 00       	call   790 <printf>
		close(fd);
 388:	89 1c 24             	mov    %ebx,(%esp)
 38b:	e8 da 02 00 00       	call   66a <close>
		return;
 390:	e9 11 fe ff ff       	jmp    1a6 <directw+0x76>
 395:	8d 76 00             	lea    0x0(%esi),%esi

			memmove(p, de.name, DIRSIZ);
			//printf(1,"\t Directory Entry is called: %s\n", de.name);
			p[DIRSIZ] = 0;
			if(stat(buf, &st) < 0){
				printf(1, "Directorywalker Error: cannot stat %s\n", buf);
 398:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 39e:	89 44 24 08          	mov    %eax,0x8(%esp)
 3a2:	c7 44 24 04 68 0b 00 	movl   $0xb68,0x4(%esp)
 3a9:	00 
 3aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3b1:	e8 da 03 00 00       	call   790 <printf>
				continue;
 3b6:	e9 75 fe ff ff       	jmp    230 <directw+0x100>
 3bb:	90                   	nop
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
				printf(1,"Directory Entry (./..): iNode # = %d \t Name = %s \t Level = %d\n", st.ino, fmtname(buf),level);
				continue;
			}
			else{
				printf(1,"Directory Entry (File or Subdirectory) to be explored: iNode # = %d \t Name = %s \t Level = %d\n", st.ino, fmtname(buf),level);
 3c0:	8b 15 bc 0f 00 00    	mov    0xfbc,%edx
 3c6:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 3cc:	89 04 24             	mov    %eax,(%esp)
 3cf:	89 95 ac fd ff ff    	mov    %edx,-0x254(%ebp)
 3d5:	e8 b6 fc ff ff       	call   90 <fmtname>
 3da:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 3e0:	c7 44 24 04 d0 0b 00 	movl   $0xbd0,0x4(%esp)
 3e7:	00 
 3e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3ef:	89 54 24 10          	mov    %edx,0x10(%esp)
 3f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
 3f7:	8b 85 dc fd ff ff    	mov    -0x224(%ebp),%eax
 3fd:	89 44 24 08          	mov    %eax,0x8(%esp)
 401:	e8 8a 03 00 00       	call   790 <printf>
				directw(buf);
 406:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 40c:	89 04 24             	mov    %eax,(%esp)
 40f:	e8 1c fd ff ff       	call   130 <directw>
 414:	e9 17 fe ff ff       	jmp    230 <directw+0x100>
 419:	66 90                	xchg   %ax,%ax
 41b:	66 90                	xchg   %ax,%ax
 41d:	66 90                	xchg   %ax,%ax
 41f:	90                   	nop

00000420 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 429:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 42a:	89 c2                	mov    %eax,%edx
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 430:	83 c1 01             	add    $0x1,%ecx
 433:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 437:	83 c2 01             	add    $0x1,%edx
 43a:	84 db                	test   %bl,%bl
 43c:	88 5a ff             	mov    %bl,-0x1(%edx)
 43f:	75 ef                	jne    430 <strcpy+0x10>
    ;
  return os;
}
 441:	5b                   	pop    %ebx
 442:	5d                   	pop    %ebp
 443:	c3                   	ret    
 444:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 44a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000450 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	8b 55 08             	mov    0x8(%ebp),%edx
 456:	53                   	push   %ebx
 457:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 45a:	0f b6 02             	movzbl (%edx),%eax
 45d:	84 c0                	test   %al,%al
 45f:	74 2d                	je     48e <strcmp+0x3e>
 461:	0f b6 19             	movzbl (%ecx),%ebx
 464:	38 d8                	cmp    %bl,%al
 466:	74 0e                	je     476 <strcmp+0x26>
 468:	eb 2b                	jmp    495 <strcmp+0x45>
 46a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 470:	38 c8                	cmp    %cl,%al
 472:	75 15                	jne    489 <strcmp+0x39>
    p++, q++;
 474:	89 d9                	mov    %ebx,%ecx
 476:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 479:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 47c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 47f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 483:	84 c0                	test   %al,%al
 485:	75 e9                	jne    470 <strcmp+0x20>
 487:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 489:	29 c8                	sub    %ecx,%eax
}
 48b:	5b                   	pop    %ebx
 48c:	5d                   	pop    %ebp
 48d:	c3                   	ret    
 48e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 491:	31 c0                	xor    %eax,%eax
 493:	eb f4                	jmp    489 <strcmp+0x39>
 495:	0f b6 cb             	movzbl %bl,%ecx
 498:	eb ef                	jmp    489 <strcmp+0x39>
 49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004a0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 4a6:	80 39 00             	cmpb   $0x0,(%ecx)
 4a9:	74 12                	je     4bd <strlen+0x1d>
 4ab:	31 d2                	xor    %edx,%edx
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
 4b0:	83 c2 01             	add    $0x1,%edx
 4b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 4b7:	89 d0                	mov    %edx,%eax
 4b9:	75 f5                	jne    4b0 <strlen+0x10>
    ;
  return n;
}
 4bb:	5d                   	pop    %ebp
 4bc:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 4bd:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 4bf:	5d                   	pop    %ebp
 4c0:	c3                   	ret    
 4c1:	eb 0d                	jmp    4d0 <memset>
 4c3:	90                   	nop
 4c4:	90                   	nop
 4c5:	90                   	nop
 4c6:	90                   	nop
 4c7:	90                   	nop
 4c8:	90                   	nop
 4c9:	90                   	nop
 4ca:	90                   	nop
 4cb:	90                   	nop
 4cc:	90                   	nop
 4cd:	90                   	nop
 4ce:	90                   	nop
 4cf:	90                   	nop

000004d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	8b 55 08             	mov    0x8(%ebp),%edx
 4d6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 4d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4da:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dd:	89 d7                	mov    %edx,%edi
 4df:	fc                   	cld    
 4e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 4e2:	89 d0                	mov    %edx,%eax
 4e4:	5f                   	pop    %edi
 4e5:	5d                   	pop    %ebp
 4e6:	c3                   	ret    
 4e7:	89 f6                	mov    %esi,%esi
 4e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004f0 <strchr>:

char*
strchr(const char *s, char c)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	8b 45 08             	mov    0x8(%ebp),%eax
 4f6:	53                   	push   %ebx
 4f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 4fa:	0f b6 18             	movzbl (%eax),%ebx
 4fd:	84 db                	test   %bl,%bl
 4ff:	74 1d                	je     51e <strchr+0x2e>
    if(*s == c)
 501:	38 d3                	cmp    %dl,%bl
 503:	89 d1                	mov    %edx,%ecx
 505:	75 0d                	jne    514 <strchr+0x24>
 507:	eb 17                	jmp    520 <strchr+0x30>
 509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 510:	38 ca                	cmp    %cl,%dl
 512:	74 0c                	je     520 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 514:	83 c0 01             	add    $0x1,%eax
 517:	0f b6 10             	movzbl (%eax),%edx
 51a:	84 d2                	test   %dl,%dl
 51c:	75 f2                	jne    510 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 51e:	31 c0                	xor    %eax,%eax
}
 520:	5b                   	pop    %ebx
 521:	5d                   	pop    %ebp
 522:	c3                   	ret    
 523:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000530 <gets>:

char*
gets(char *buf, int max)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 535:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 537:	53                   	push   %ebx
 538:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 53b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 53e:	eb 31                	jmp    571 <gets+0x41>
    cc = read(0, &c, 1);
 540:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 547:	00 
 548:	89 7c 24 04          	mov    %edi,0x4(%esp)
 54c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 553:	e8 02 01 00 00       	call   65a <read>
    if(cc < 1)
 558:	85 c0                	test   %eax,%eax
 55a:	7e 1d                	jle    579 <gets+0x49>
      break;
    buf[i++] = c;
 55c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 560:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 562:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 565:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 567:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 56b:	74 0c                	je     579 <gets+0x49>
 56d:	3c 0a                	cmp    $0xa,%al
 56f:	74 08                	je     579 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 571:	8d 5e 01             	lea    0x1(%esi),%ebx
 574:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 577:	7c c7                	jl     540 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 580:	83 c4 2c             	add    $0x2c,%esp
 583:	5b                   	pop    %ebx
 584:	5e                   	pop    %esi
 585:	5f                   	pop    %edi
 586:	5d                   	pop    %ebp
 587:	c3                   	ret    
 588:	90                   	nop
 589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000590 <stat>:

int
stat(char *n, struct stat *st)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	56                   	push   %esi
 594:	53                   	push   %ebx
 595:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5a2:	00 
 5a3:	89 04 24             	mov    %eax,(%esp)
 5a6:	e8 d7 00 00 00       	call   682 <open>
  if(fd < 0)
 5ab:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5ad:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 5af:	78 27                	js     5d8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 5b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b4:	89 1c 24             	mov    %ebx,(%esp)
 5b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bb:	e8 da 00 00 00       	call   69a <fstat>
  close(fd);
 5c0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 5c3:	89 c6                	mov    %eax,%esi
  close(fd);
 5c5:	e8 a0 00 00 00       	call   66a <close>
  return r;
 5ca:	89 f0                	mov    %esi,%eax
}
 5cc:	83 c4 10             	add    $0x10,%esp
 5cf:	5b                   	pop    %ebx
 5d0:	5e                   	pop    %esi
 5d1:	5d                   	pop    %ebp
 5d2:	c3                   	ret    
 5d3:	90                   	nop
 5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 5d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5dd:	eb ed                	jmp    5cc <stat+0x3c>
 5df:	90                   	nop

000005e0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5e6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5e7:	0f be 11             	movsbl (%ecx),%edx
 5ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 5ed:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 5ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 5f4:	77 17                	ja     60d <atoi+0x2d>
 5f6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 5f8:	83 c1 01             	add    $0x1,%ecx
 5fb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 5fe:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 602:	0f be 11             	movsbl (%ecx),%edx
 605:	8d 5a d0             	lea    -0x30(%edx),%ebx
 608:	80 fb 09             	cmp    $0x9,%bl
 60b:	76 eb                	jbe    5f8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 60d:	5b                   	pop    %ebx
 60e:	5d                   	pop    %ebp
 60f:	c3                   	ret    

00000610 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 610:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 611:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 613:	89 e5                	mov    %esp,%ebp
 615:	56                   	push   %esi
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	53                   	push   %ebx
 61a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 61d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 620:	85 db                	test   %ebx,%ebx
 622:	7e 12                	jle    636 <memmove+0x26>
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 628:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 62c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 62f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 632:	39 da                	cmp    %ebx,%edx
 634:	75 f2                	jne    628 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 636:	5b                   	pop    %ebx
 637:	5e                   	pop    %esi
 638:	5d                   	pop    %ebp
 639:	c3                   	ret    

0000063a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 63a:	b8 01 00 00 00       	mov    $0x1,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <exit>:
SYSCALL(exit)
 642:	b8 02 00 00 00       	mov    $0x2,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <wait>:
SYSCALL(wait)
 64a:	b8 03 00 00 00       	mov    $0x3,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <pipe>:
SYSCALL(pipe)
 652:	b8 04 00 00 00       	mov    $0x4,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <read>:
SYSCALL(read)
 65a:	b8 05 00 00 00       	mov    $0x5,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <write>:
SYSCALL(write)
 662:	b8 10 00 00 00       	mov    $0x10,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <close>:
SYSCALL(close)
 66a:	b8 15 00 00 00       	mov    $0x15,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <kill>:
SYSCALL(kill)
 672:	b8 06 00 00 00       	mov    $0x6,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <exec>:
SYSCALL(exec)
 67a:	b8 07 00 00 00       	mov    $0x7,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <open>:
SYSCALL(open)
 682:	b8 0f 00 00 00       	mov    $0xf,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <mknod>:
SYSCALL(mknod)
 68a:	b8 11 00 00 00       	mov    $0x11,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <unlink>:
SYSCALL(unlink)
 692:	b8 12 00 00 00       	mov    $0x12,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <fstat>:
SYSCALL(fstat)
 69a:	b8 08 00 00 00       	mov    $0x8,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <link>:
SYSCALL(link)
 6a2:	b8 13 00 00 00       	mov    $0x13,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <mkdir>:
SYSCALL(mkdir)
 6aa:	b8 14 00 00 00       	mov    $0x14,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <chdir>:
SYSCALL(chdir)
 6b2:	b8 09 00 00 00       	mov    $0x9,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <dup>:
SYSCALL(dup)
 6ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <getpid>:
SYSCALL(getpid)
 6c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    

000006ca <sbrk>:
SYSCALL(sbrk)
 6ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 6cf:	cd 40                	int    $0x40
 6d1:	c3                   	ret    

000006d2 <sleep>:
SYSCALL(sleep)
 6d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 6d7:	cd 40                	int    $0x40
 6d9:	c3                   	ret    

000006da <uptime>:
SYSCALL(uptime)
 6da:	b8 0e 00 00 00       	mov    $0xe,%eax
 6df:	cd 40                	int    $0x40
 6e1:	c3                   	ret    

000006e2 <myMemory>:
SYSCALL(myMemory)
 6e2:	b8 16 00 00 00       	mov    $0x16,%eax
 6e7:	cd 40                	int    $0x40
 6e9:	c3                   	ret    
 6ea:	66 90                	xchg   %ax,%ax
 6ec:	66 90                	xchg   %ax,%ax
 6ee:	66 90                	xchg   %ax,%ax

000006f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	89 c6                	mov    %eax,%esi
 6f7:	53                   	push   %ebx
 6f8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6fe:	85 db                	test   %ebx,%ebx
 700:	74 09                	je     70b <printint+0x1b>
 702:	89 d0                	mov    %edx,%eax
 704:	c1 e8 1f             	shr    $0x1f,%eax
 707:	84 c0                	test   %al,%al
 709:	75 75                	jne    780 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 70b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 70d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 714:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 717:	31 ff                	xor    %edi,%edi
 719:	89 ce                	mov    %ecx,%esi
 71b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 71e:	eb 02                	jmp    722 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 720:	89 cf                	mov    %ecx,%edi
 722:	31 d2                	xor    %edx,%edx
 724:	f7 f6                	div    %esi
 726:	8d 4f 01             	lea    0x1(%edi),%ecx
 729:	0f b6 92 ce 0c 00 00 	movzbl 0xcce(%edx),%edx
  }while((x /= base) != 0);
 730:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 732:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 735:	75 e9                	jne    720 <printint+0x30>
  if(neg)
 737:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 73a:	89 c8                	mov    %ecx,%eax
 73c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 73f:	85 d2                	test   %edx,%edx
 741:	74 08                	je     74b <printint+0x5b>
    buf[i++] = '-';
 743:	8d 4f 02             	lea    0x2(%edi),%ecx
 746:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 74b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 74e:	66 90                	xchg   %ax,%ax
 750:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 755:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 758:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 75f:	00 
 760:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 764:	89 34 24             	mov    %esi,(%esp)
 767:	88 45 d7             	mov    %al,-0x29(%ebp)
 76a:	e8 f3 fe ff ff       	call   662 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 76f:	83 ff ff             	cmp    $0xffffffff,%edi
 772:	75 dc                	jne    750 <printint+0x60>
    putc(fd, buf[i]);
}
 774:	83 c4 4c             	add    $0x4c,%esp
 777:	5b                   	pop    %ebx
 778:	5e                   	pop    %esi
 779:	5f                   	pop    %edi
 77a:	5d                   	pop    %ebp
 77b:	c3                   	ret    
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 780:	89 d0                	mov    %edx,%eax
 782:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 784:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 78b:	eb 87                	jmp    714 <printint+0x24>
 78d:	8d 76 00             	lea    0x0(%esi),%esi

00000790 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 794:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 796:	56                   	push   %esi
 797:	53                   	push   %ebx
 798:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 79b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 79e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7a1:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 7a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 7a7:	0f b6 13             	movzbl (%ebx),%edx
 7aa:	83 c3 01             	add    $0x1,%ebx
 7ad:	84 d2                	test   %dl,%dl
 7af:	75 39                	jne    7ea <printf+0x5a>
 7b1:	e9 c2 00 00 00       	jmp    878 <printf+0xe8>
 7b6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 7b8:	83 fa 25             	cmp    $0x25,%edx
 7bb:	0f 84 bf 00 00 00    	je     880 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7c1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 7c4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7cb:	00 
 7cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 7d3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7d6:	e8 87 fe ff ff       	call   662 <write>
 7db:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7de:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 7e2:	84 d2                	test   %dl,%dl
 7e4:	0f 84 8e 00 00 00    	je     878 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 7ea:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 7ec:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 7ef:	74 c7                	je     7b8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7f1:	83 ff 25             	cmp    $0x25,%edi
 7f4:	75 e5                	jne    7db <printf+0x4b>
      if(c == 'd'){
 7f6:	83 fa 64             	cmp    $0x64,%edx
 7f9:	0f 84 31 01 00 00    	je     930 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7ff:	25 f7 00 00 00       	and    $0xf7,%eax
 804:	83 f8 70             	cmp    $0x70,%eax
 807:	0f 84 83 00 00 00    	je     890 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 80d:	83 fa 73             	cmp    $0x73,%edx
 810:	0f 84 a2 00 00 00    	je     8b8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 816:	83 fa 63             	cmp    $0x63,%edx
 819:	0f 84 35 01 00 00    	je     954 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 81f:	83 fa 25             	cmp    $0x25,%edx
 822:	0f 84 e0 00 00 00    	je     908 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 828:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 82b:	83 c3 01             	add    $0x1,%ebx
 82e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 835:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 836:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 838:	89 44 24 04          	mov    %eax,0x4(%esp)
 83c:	89 34 24             	mov    %esi,(%esp)
 83f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 842:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 846:	e8 17 fe ff ff       	call   662 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 84b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 84e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 851:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 858:	00 
 859:	89 44 24 04          	mov    %eax,0x4(%esp)
 85d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 860:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 863:	e8 fa fd ff ff       	call   662 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 868:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 86c:	84 d2                	test   %dl,%dl
 86e:	0f 85 76 ff ff ff    	jne    7ea <printf+0x5a>
 874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 878:	83 c4 3c             	add    $0x3c,%esp
 87b:	5b                   	pop    %ebx
 87c:	5e                   	pop    %esi
 87d:	5f                   	pop    %edi
 87e:	5d                   	pop    %ebp
 87f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 880:	bf 25 00 00 00       	mov    $0x25,%edi
 885:	e9 51 ff ff ff       	jmp    7db <printf+0x4b>
 88a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 893:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 898:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 89a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8a1:	8b 10                	mov    (%eax),%edx
 8a3:	89 f0                	mov    %esi,%eax
 8a5:	e8 46 fe ff ff       	call   6f0 <printint>
        ap++;
 8aa:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 8ae:	e9 28 ff ff ff       	jmp    7db <printf+0x4b>
 8b3:	90                   	nop
 8b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 8b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 8bb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 8bf:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 8c1:	b8 c7 0c 00 00       	mov    $0xcc7,%eax
 8c6:	85 ff                	test   %edi,%edi
 8c8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 8cb:	0f b6 07             	movzbl (%edi),%eax
 8ce:	84 c0                	test   %al,%al
 8d0:	74 2a                	je     8fc <printf+0x16c>
 8d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8d8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8db:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 8de:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8e8:	00 
 8e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ed:	89 34 24             	mov    %esi,(%esp)
 8f0:	e8 6d fd ff ff       	call   662 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8f5:	0f b6 07             	movzbl (%edi),%eax
 8f8:	84 c0                	test   %al,%al
 8fa:	75 dc                	jne    8d8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8fc:	31 ff                	xor    %edi,%edi
 8fe:	e9 d8 fe ff ff       	jmp    7db <printf+0x4b>
 903:	90                   	nop
 904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 908:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 90b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 90d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 914:	00 
 915:	89 44 24 04          	mov    %eax,0x4(%esp)
 919:	89 34 24             	mov    %esi,(%esp)
 91c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 920:	e8 3d fd ff ff       	call   662 <write>
 925:	e9 b1 fe ff ff       	jmp    7db <printf+0x4b>
 92a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 930:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 933:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 938:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 93b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 942:	8b 10                	mov    (%eax),%edx
 944:	89 f0                	mov    %esi,%eax
 946:	e8 a5 fd ff ff       	call   6f0 <printint>
        ap++;
 94b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 94f:	e9 87 fe ff ff       	jmp    7db <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 954:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 957:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 959:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 95b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 962:	00 
 963:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 966:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 969:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 96c:	89 44 24 04          	mov    %eax,0x4(%esp)
 970:	e8 ed fc ff ff       	call   662 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 975:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 979:	e9 5d fe ff ff       	jmp    7db <printf+0x4b>
 97e:	66 90                	xchg   %ax,%ax

00000980 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 980:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 981:	a1 d0 0f 00 00       	mov    0xfd0,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 986:	89 e5                	mov    %esp,%ebp
 988:	57                   	push   %edi
 989:	56                   	push   %esi
 98a:	53                   	push   %ebx
 98b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 990:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 993:	39 d0                	cmp    %edx,%eax
 995:	72 11                	jb     9a8 <free+0x28>
 997:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 998:	39 c8                	cmp    %ecx,%eax
 99a:	72 04                	jb     9a0 <free+0x20>
 99c:	39 ca                	cmp    %ecx,%edx
 99e:	72 10                	jb     9b0 <free+0x30>
 9a0:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a4:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a6:	73 f0                	jae    998 <free+0x18>
 9a8:	39 ca                	cmp    %ecx,%edx
 9aa:	72 04                	jb     9b0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ac:	39 c8                	cmp    %ecx,%eax
 9ae:	72 f0                	jb     9a0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9b0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 9b3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 9b6:	39 cf                	cmp    %ecx,%edi
 9b8:	74 1e                	je     9d8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 9ba:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 9bd:	8b 48 04             	mov    0x4(%eax),%ecx
 9c0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 9c3:	39 f2                	cmp    %esi,%edx
 9c5:	74 28                	je     9ef <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 9c7:	89 10                	mov    %edx,(%eax)
  freep = p;
 9c9:	a3 d0 0f 00 00       	mov    %eax,0xfd0
}
 9ce:	5b                   	pop    %ebx
 9cf:	5e                   	pop    %esi
 9d0:	5f                   	pop    %edi
 9d1:	5d                   	pop    %ebp
 9d2:	c3                   	ret    
 9d3:	90                   	nop
 9d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9d8:	03 71 04             	add    0x4(%ecx),%esi
 9db:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 9de:	8b 08                	mov    (%eax),%ecx
 9e0:	8b 09                	mov    (%ecx),%ecx
 9e2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9e5:	8b 48 04             	mov    0x4(%eax),%ecx
 9e8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 9eb:	39 f2                	cmp    %esi,%edx
 9ed:	75 d8                	jne    9c7 <free+0x47>
    p->s.size += bp->s.size;
 9ef:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 9f2:	a3 d0 0f 00 00       	mov    %eax,0xfd0
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9f7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9fa:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9fd:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 9ff:	5b                   	pop    %ebx
 a00:	5e                   	pop    %esi
 a01:	5f                   	pop    %edi
 a02:	5d                   	pop    %ebp
 a03:	c3                   	ret    
 a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000a10 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a10:	55                   	push   %ebp
 a11:	89 e5                	mov    %esp,%ebp
 a13:	57                   	push   %edi
 a14:	56                   	push   %esi
 a15:	53                   	push   %ebx
 a16:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a19:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 a1c:	8b 1d d0 0f 00 00    	mov    0xfd0,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a22:	8d 48 07             	lea    0x7(%eax),%ecx
 a25:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 a28:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a2a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 a2d:	0f 84 9b 00 00 00    	je     ace <malloc+0xbe>
 a33:	8b 13                	mov    (%ebx),%edx
 a35:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 a38:	39 fe                	cmp    %edi,%esi
 a3a:	76 64                	jbe    aa0 <malloc+0x90>
 a3c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 a43:	bb 00 80 00 00       	mov    $0x8000,%ebx
 a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 a4b:	eb 0e                	jmp    a5b <malloc+0x4b>
 a4d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a50:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a52:	8b 78 04             	mov    0x4(%eax),%edi
 a55:	39 fe                	cmp    %edi,%esi
 a57:	76 4f                	jbe    aa8 <malloc+0x98>
 a59:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a5b:	3b 15 d0 0f 00 00    	cmp    0xfd0,%edx
 a61:	75 ed                	jne    a50 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 a63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a66:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 a6c:	bf 00 10 00 00       	mov    $0x1000,%edi
 a71:	0f 43 fe             	cmovae %esi,%edi
 a74:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 a77:	89 04 24             	mov    %eax,(%esp)
 a7a:	e8 4b fc ff ff       	call   6ca <sbrk>
  if(p == (char*)-1)
 a7f:	83 f8 ff             	cmp    $0xffffffff,%eax
 a82:	74 18                	je     a9c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 a84:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 a87:	83 c0 08             	add    $0x8,%eax
 a8a:	89 04 24             	mov    %eax,(%esp)
 a8d:	e8 ee fe ff ff       	call   980 <free>
  return freep;
 a92:	8b 15 d0 0f 00 00    	mov    0xfd0,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 a98:	85 d2                	test   %edx,%edx
 a9a:	75 b4                	jne    a50 <malloc+0x40>
        return 0;
 a9c:	31 c0                	xor    %eax,%eax
 a9e:	eb 20                	jmp    ac0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 aa0:	89 d0                	mov    %edx,%eax
 aa2:	89 da                	mov    %ebx,%edx
 aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 aa8:	39 fe                	cmp    %edi,%esi
 aaa:	74 1c                	je     ac8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 aac:	29 f7                	sub    %esi,%edi
 aae:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 ab1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 ab4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 ab7:	89 15 d0 0f 00 00    	mov    %edx,0xfd0
      return (void*)(p + 1);
 abd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ac0:	83 c4 1c             	add    $0x1c,%esp
 ac3:	5b                   	pop    %ebx
 ac4:	5e                   	pop    %esi
 ac5:	5f                   	pop    %edi
 ac6:	5d                   	pop    %ebp
 ac7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 ac8:	8b 08                	mov    (%eax),%ecx
 aca:	89 0a                	mov    %ecx,(%edx)
 acc:	eb e9                	jmp    ab7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 ace:	c7 05 d0 0f 00 00 d4 	movl   $0xfd4,0xfd0
 ad5:	0f 00 00 
    base.s.size = 0;
 ad8:	ba d4 0f 00 00       	mov    $0xfd4,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 add:	c7 05 d4 0f 00 00 d4 	movl   $0xfd4,0xfd4
 ae4:	0f 00 00 
    base.s.size = 0;
 ae7:	c7 05 d8 0f 00 00 00 	movl   $0x0,0xfd8
 aee:	00 00 00 
 af1:	e9 46 ff ff ff       	jmp    a3c <malloc+0x2c>
