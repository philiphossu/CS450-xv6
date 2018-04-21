
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
//		mkdir("/test_directory_1/test_directory_1_1");
//		mkdir("/test_directory_1/test_directory_1_2");
//	}

	if(testingFlag == 2){
		mkdir("foo");
   a:	c7 04 24 75 0c 00 00 	movl   $0xc75,(%esp)
  11:	e8 84 06 00 00       	call   69a <mkdir>
		int fd;
		fd = open("/foo/smallTestFile", O_CREATE | O_RDWR);
  16:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1d:	00 
  1e:	c7 04 24 79 0c 00 00 	movl   $0xc79,(%esp)
  25:	e8 48 06 00 00       	call   672 <open>
		if(fd >= 0){
  2a:	85 c0                	test   %eax,%eax
//	}

	if(testingFlag == 2){
		mkdir("foo");
		int fd;
		fd = open("/foo/smallTestFile", O_CREATE | O_RDWR);
  2c:	89 c3                	mov    %eax,%ebx
		if(fd >= 0){
  2e:	78 14                	js     44 <main+0x44>
			printf(1, "----> File creation successful.\n");
  30:	c7 44 24 04 30 0c 00 	movl   $0xc30,0x4(%esp)
  37:	00 
  38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3f:	e8 5c 07 00 00       	call   7a0 <printf>
		}
		write(fd, "22", 2);
  44:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  4b:	00 
  4c:	c7 44 24 04 8c 0c 00 	movl   $0xc8c,0x4(%esp)
  53:	00 
  54:	89 1c 24             	mov    %ebx,(%esp)
  57:	e8 f6 05 00 00       	call   652 <write>
		close(fd);
  5c:	89 1c 24             	mov    %ebx,(%esp)
  5f:	e8 f6 05 00 00       	call   65a <close>
	}

	if(argc < 2){
  64:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  68:	7e 13                	jle    7d <main+0x7d>
		deleteIData(23);
		directw(".");
		exit();
	}

	directw(argv[1]);
  6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  6d:	8b 40 04             	mov    0x4(%eax),%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 d8 00 00 00       	call   150 <directw>
	if(testingFlag == 1){
		printf(1,"\n\n");
		//rmdir("test_directory_1/test_directory_1_1");
		directw(argv[1]);
	}
	exit();
  78:	e8 b5 05 00 00       	call   632 <exit>
		write(fd, "22", 2);
		close(fd);
	}

	if(argc < 2){
		directw(".");
  7d:	c7 04 24 73 0c 00 00 	movl   $0xc73,(%esp)
  84:	e8 c7 00 00 00       	call   150 <directw>
		if(testingFlag == 1){
			printf(1,"\n\n");
			//rmdir("test_directory_1/test_directory_1_1");
			directw(".");
		}
		deleteIData(23);
  89:	c7 04 24 17 00 00 00 	movl   $0x17,(%esp)
  90:	e8 4d 06 00 00       	call   6e2 <deleteIData>
		directw(".");
  95:	c7 04 24 73 0c 00 00 	movl   $0xc73,(%esp)
  9c:	e8 af 00 00 00       	call   150 <directw>
		exit();
  a1:	e8 8c 05 00 00       	call   632 <exit>
  a6:	66 90                	xchg   %ax,%ax
  a8:	66 90                	xchg   %ax,%ax
  aa:	66 90                	xchg   %ax,%ax
  ac:	66 90                	xchg   %ax,%ax
  ae:	66 90                	xchg   %ax,%ax

000000b0 <fmtname>:
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

char* fmtname(char *path) {
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	56                   	push   %esi
  b4:	53                   	push   %ebx
  b5:	83 ec 10             	sub    $0x10,%esp
  b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	static char buf[DIRSIZ+1];
	char *p;

	// Find first character after last slash.
	for(p=path+strlen(path); p >= path && *p != '/'; p--)
  bb:	89 1c 24             	mov    %ebx,(%esp)
  be:	e8 cd 03 00 00       	call   490 <strlen>
  c3:	01 d8                	add    %ebx,%eax
  c5:	73 10                	jae    d7 <fmtname+0x27>
  c7:	eb 13                	jmp    dc <fmtname+0x2c>
  c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  d0:	83 e8 01             	sub    $0x1,%eax
  d3:	39 c3                	cmp    %eax,%ebx
  d5:	77 05                	ja     dc <fmtname+0x2c>
  d7:	80 38 2f             	cmpb   $0x2f,(%eax)
  da:	75 f4                	jne    d0 <fmtname+0x20>
		;
	p++;
  dc:	8d 58 01             	lea    0x1(%eax),%ebx

	// Return blank-padded name.
	if(strlen(p) >= DIRSIZ)
  df:	89 1c 24             	mov    %ebx,(%esp)
  e2:	e8 a9 03 00 00       	call   490 <strlen>
  e7:	83 f8 0d             	cmp    $0xd,%eax
  ea:	77 53                	ja     13f <fmtname+0x8f>
		return p;
	memmove(buf, p, strlen(p));
  ec:	89 1c 24             	mov    %ebx,(%esp)
  ef:	e8 9c 03 00 00       	call   490 <strlen>
  f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  f8:	c7 04 24 74 0f 00 00 	movl   $0xf74,(%esp)
  ff:	89 44 24 08          	mov    %eax,0x8(%esp)
 103:	e8 f8 04 00 00       	call   600 <memmove>
	memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 108:	89 1c 24             	mov    %ebx,(%esp)
 10b:	e8 80 03 00 00       	call   490 <strlen>
 110:	89 1c 24             	mov    %ebx,(%esp)
	return buf;
 113:	bb 74 0f 00 00       	mov    $0xf74,%ebx

	// Return blank-padded name.
	if(strlen(p) >= DIRSIZ)
		return p;
	memmove(buf, p, strlen(p));
	memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 118:	89 c6                	mov    %eax,%esi
 11a:	e8 71 03 00 00       	call   490 <strlen>
 11f:	ba 0e 00 00 00       	mov    $0xe,%edx
 124:	29 f2                	sub    %esi,%edx
 126:	89 54 24 08          	mov    %edx,0x8(%esp)
 12a:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
 131:	00 
 132:	05 74 0f 00 00       	add    $0xf74,%eax
 137:	89 04 24             	mov    %eax,(%esp)
 13a:	e8 81 03 00 00       	call   4c0 <memset>
	return buf;
}
 13f:	83 c4 10             	add    $0x10,%esp
 142:	89 d8                	mov    %ebx,%eax
 144:	5b                   	pop    %ebx
 145:	5e                   	pop    %esi
 146:	5d                   	pop    %ebp
 147:	c3                   	ret    
 148:	90                   	nop
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000150 <directw>:

void directw(char *path) {
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
 155:	53                   	push   %ebx
 156:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
 15c:	8b 7d 08             	mov    0x8(%ebp),%edi
	char buf[512], *p;
	int fd;
	struct dirent de;
	struct stat st;
	fd = open(path, 0);
 15f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 166:	00 
 167:	89 3c 24             	mov    %edi,(%esp)
 16a:	e8 03 05 00 00       	call   672 <open>
	if(fd < 0){
 16f:	85 c0                	test   %eax,%eax
void directw(char *path) {
	char buf[512], *p;
	int fd;
	struct dirent de;
	struct stat st;
	fd = open(path, 0);
 171:	89 c3                	mov    %eax,%ebx
	if(fd < 0){
 173:	0f 88 9f 01 00 00    	js     318 <directw+0x1c8>
		printf(2, "directorywalker: cannot open %s\n", path);
		return;
	}

	if(fstat(fd, &st) < 0){
 179:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 17f:	89 74 24 04          	mov    %esi,0x4(%esp)
 183:	89 04 24             	mov    %eax,(%esp)
 186:	e8 ff 04 00 00       	call   68a <fstat>
 18b:	85 c0                	test   %eax,%eax
 18d:	0f 88 cd 01 00 00    	js     360 <directw+0x210>
		printf(2, "directorywalker: cannot stat %s\n", path);
		close(fd);
		return;
	}

	switch(st.type){
 193:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 19a:	66 83 f8 01          	cmp    $0x1,%ax
 19e:	74 18                	je     1b8 <directw+0x68>
	case T_FILE:
		//printf(1,"---> File Located, Ending This Branch <--- \n");
		close(fd);
		return;
	}
	close(fd);
 1a0:	89 1c 24             	mov    %ebx,(%esp)
 1a3:	e8 b2 04 00 00       	call   65a <close>
}
 1a8:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 1ae:	5b                   	pop    %ebx
 1af:	5e                   	pop    %esi
 1b0:	5f                   	pop    %edi
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    
 1b3:	90                   	nop
 1b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return;
	}

	switch(st.type){
	case T_DIR:
		printf(1,"---> Directory Located <--- \n");
 1b8:	c7 44 24 04 54 0c 00 	movl   $0xc54,0x4(%esp)
 1bf:	00 
 1c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c7:	e8 d4 05 00 00       	call   7a0 <printf>
		if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1cc:	89 3c 24             	mov    %edi,(%esp)
 1cf:	e8 bc 02 00 00       	call   490 <strlen>
 1d4:	83 c0 10             	add    $0x10,%eax
 1d7:	3d 00 02 00 00       	cmp    $0x200,%eax
 1dc:	0f 87 5e 01 00 00    	ja     340 <directw+0x1f0>
			printf(1, "Directorywalker Error: path too long\n");
			break;
		}
		strcpy(buf, path);
 1e2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1ec:	8d bd c4 fd ff ff    	lea    -0x23c(%ebp),%edi
 1f2:	89 04 24             	mov    %eax,(%esp)
 1f5:	e8 16 02 00 00       	call   410 <strcpy>
		p = buf+strlen(buf);
 1fa:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 200:	89 04 24             	mov    %eax,(%esp)
 203:	e8 88 02 00 00       	call   490 <strlen>
 208:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 20e:	01 c8                	add    %ecx,%eax
		*p++ = '/';
 210:	8d 48 01             	lea    0x1(%eax),%ecx
		if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
			printf(1, "Directorywalker Error: path too long\n");
			break;
		}
		strcpy(buf, path);
		p = buf+strlen(buf);
 213:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
		*p++ = '/';
 219:	89 8d b0 fd ff ff    	mov    %ecx,-0x250(%ebp)
 21f:	c6 00 2f             	movb   $0x2f,(%eax)
 222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		while(read(fd, &de, sizeof(de)) == sizeof(de)){
 228:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 22f:	00 
 230:	89 7c 24 04          	mov    %edi,0x4(%esp)
 234:	89 1c 24             	mov    %ebx,(%esp)
 237:	e8 0e 04 00 00       	call   64a <read>
 23c:	83 f8 10             	cmp    $0x10,%eax
 23f:	0f 85 5b ff ff ff    	jne    1a0 <directw+0x50>
			if(de.inum == 0){
 245:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 24c:	00 
 24d:	74 d9                	je     228 <directw+0xd8>
				continue;
			}

			memmove(p, de.name, DIRSIZ);
 24f:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 255:	89 44 24 04          	mov    %eax,0x4(%esp)
 259:	8b 85 b0 fd ff ff    	mov    -0x250(%ebp),%eax
 25f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 266:	00 
 267:	89 04 24             	mov    %eax,(%esp)
 26a:	e8 91 03 00 00       	call   600 <memmove>
			//printf(1,"\t Directory Entry is called: %s\n", de.name);
			p[DIRSIZ] = 0;
 26f:	8b 85 b4 fd ff ff    	mov    -0x24c(%ebp),%eax
 275:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
			if(stat(buf, &st) < 0){
 279:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 27f:	89 74 24 04          	mov    %esi,0x4(%esp)
 283:	89 04 24             	mov    %eax,(%esp)
 286:	e8 f5 02 00 00       	call   580 <stat>
 28b:	85 c0                	test   %eax,%eax
 28d:	0f 88 f5 00 00 00    	js     388 <directw+0x238>
				printf(1, "Directorywalker Error: cannot stat %s\n", buf);
				continue;
			}
			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
 293:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 299:	c7 44 24 04 73 0c 00 	movl   $0xc73,0x4(%esp)
 2a0:	00 
 2a1:	89 04 24             	mov    %eax,(%esp)
 2a4:	e8 97 01 00 00       	call   440 <strcmp>
 2a9:	85 c0                	test   %eax,%eax
 2ab:	74 1e                	je     2cb <directw+0x17b>
 2ad:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 2b3:	c7 44 24 04 72 0c 00 	movl   $0xc72,0x4(%esp)
 2ba:	00 
 2bb:	89 04 24             	mov    %eax,(%esp)
 2be:	e8 7d 01 00 00       	call   440 <strcmp>
 2c3:	85 c0                	test   %eax,%eax
 2c5:	0f 85 e5 00 00 00    	jne    3b0 <directw+0x260>
				printf(1,"Directory Entry (./..): iNode # = %d \t Name = %s \t nlink: %d\n", st.ino, fmtname(buf), st.nlink);
 2cb:	0f bf 95 e0 fd ff ff 	movswl -0x220(%ebp),%edx
 2d2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 2d8:	89 04 24             	mov    %eax,(%esp)
 2db:	89 95 ac fd ff ff    	mov    %edx,-0x254(%ebp)
 2e1:	e8 ca fd ff ff       	call   b0 <fmtname>
 2e6:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 2ec:	c7 44 24 04 a0 0b 00 	movl   $0xba0,0x4(%esp)
 2f3:	00 
 2f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2fb:	89 54 24 10          	mov    %edx,0x10(%esp)
 2ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
 303:	8b 85 dc fd ff ff    	mov    -0x224(%ebp),%eax
 309:	89 44 24 08          	mov    %eax,0x8(%esp)
 30d:	e8 8e 04 00 00       	call   7a0 <printf>
				continue;
 312:	e9 11 ff ff ff       	jmp    228 <directw+0xd8>
 317:	90                   	nop
	int fd;
	struct dirent de;
	struct stat st;
	fd = open(path, 0);
	if(fd < 0){
		printf(2, "directorywalker: cannot open %s\n", path);
 318:	89 7c 24 08          	mov    %edi,0x8(%esp)
 31c:	c7 44 24 04 08 0b 00 	movl   $0xb08,0x4(%esp)
 323:	00 
 324:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 32b:	e8 70 04 00 00       	call   7a0 <printf>
		//printf(1,"---> File Located, Ending This Branch <--- \n");
		close(fd);
		return;
	}
	close(fd);
}
 330:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 336:	5b                   	pop    %ebx
 337:	5e                   	pop    %esi
 338:	5f                   	pop    %edi
 339:	5d                   	pop    %ebp
 33a:	c3                   	ret    
 33b:	90                   	nop
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

	switch(st.type){
	case T_DIR:
		printf(1,"---> Directory Located <--- \n");
		if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
			printf(1, "Directorywalker Error: path too long\n");
 340:	c7 44 24 04 50 0b 00 	movl   $0xb50,0x4(%esp)
 347:	00 
 348:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 34f:	e8 4c 04 00 00       	call   7a0 <printf>
			break;
 354:	e9 47 fe ff ff       	jmp    1a0 <directw+0x50>
 359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		printf(2, "directorywalker: cannot open %s\n", path);
		return;
	}

	if(fstat(fd, &st) < 0){
		printf(2, "directorywalker: cannot stat %s\n", path);
 360:	89 7c 24 08          	mov    %edi,0x8(%esp)
 364:	c7 44 24 04 2c 0b 00 	movl   $0xb2c,0x4(%esp)
 36b:	00 
 36c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 373:	e8 28 04 00 00       	call   7a0 <printf>
		close(fd);
 378:	89 1c 24             	mov    %ebx,(%esp)
 37b:	e8 da 02 00 00       	call   65a <close>
		return;
 380:	e9 23 fe ff ff       	jmp    1a8 <directw+0x58>
 385:	8d 76 00             	lea    0x0(%esi),%esi

			memmove(p, de.name, DIRSIZ);
			//printf(1,"\t Directory Entry is called: %s\n", de.name);
			p[DIRSIZ] = 0;
			if(stat(buf, &st) < 0){
				printf(1, "Directorywalker Error: cannot stat %s\n", buf);
 388:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 38e:	89 44 24 08          	mov    %eax,0x8(%esp)
 392:	c7 44 24 04 78 0b 00 	movl   $0xb78,0x4(%esp)
 399:	00 
 39a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3a1:	e8 fa 03 00 00       	call   7a0 <printf>
				continue;
 3a6:	e9 7d fe ff ff       	jmp    228 <directw+0xd8>
 3ab:	90                   	nop
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
				printf(1,"Directory Entry (./..): iNode # = %d \t Name = %s \t nlink: %d\n", st.ino, fmtname(buf), st.nlink);
				continue;
			}
			else{
				printf(1,"Directory Entry (File or Subdirectory): iNode # = %d \t Name = %s \t nlink: %d\n", st.ino, fmtname(buf), st.nlink);
 3b0:	0f bf 95 e0 fd ff ff 	movswl -0x220(%ebp),%edx
 3b7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 3bd:	89 04 24             	mov    %eax,(%esp)
 3c0:	89 95 ac fd ff ff    	mov    %edx,-0x254(%ebp)
 3c6:	e8 e5 fc ff ff       	call   b0 <fmtname>
 3cb:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 3d1:	c7 44 24 04 e0 0b 00 	movl   $0xbe0,0x4(%esp)
 3d8:	00 
 3d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3e0:	89 54 24 10          	mov    %edx,0x10(%esp)
 3e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
 3e8:	8b 85 dc fd ff ff    	mov    -0x224(%ebp),%eax
 3ee:	89 44 24 08          	mov    %eax,0x8(%esp)
 3f2:	e8 a9 03 00 00       	call   7a0 <printf>
				directw(buf);
 3f7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 3fd:	89 04 24             	mov    %eax,(%esp)
 400:	e8 4b fd ff ff       	call   150 <directw>
 405:	e9 1e fe ff ff       	jmp    228 <directw+0xd8>
 40a:	66 90                	xchg   %ax,%ax
 40c:	66 90                	xchg   %ax,%ax
 40e:	66 90                	xchg   %ax,%ax

00000410 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 419:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 41a:	89 c2                	mov    %eax,%edx
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 420:	83 c1 01             	add    $0x1,%ecx
 423:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 427:	83 c2 01             	add    $0x1,%edx
 42a:	84 db                	test   %bl,%bl
 42c:	88 5a ff             	mov    %bl,-0x1(%edx)
 42f:	75 ef                	jne    420 <strcpy+0x10>
    ;
  return os;
}
 431:	5b                   	pop    %ebx
 432:	5d                   	pop    %ebp
 433:	c3                   	ret    
 434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 43a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000440 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	8b 55 08             	mov    0x8(%ebp),%edx
 446:	53                   	push   %ebx
 447:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 44a:	0f b6 02             	movzbl (%edx),%eax
 44d:	84 c0                	test   %al,%al
 44f:	74 2d                	je     47e <strcmp+0x3e>
 451:	0f b6 19             	movzbl (%ecx),%ebx
 454:	38 d8                	cmp    %bl,%al
 456:	74 0e                	je     466 <strcmp+0x26>
 458:	eb 2b                	jmp    485 <strcmp+0x45>
 45a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 460:	38 c8                	cmp    %cl,%al
 462:	75 15                	jne    479 <strcmp+0x39>
    p++, q++;
 464:	89 d9                	mov    %ebx,%ecx
 466:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 469:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 46c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 46f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 473:	84 c0                	test   %al,%al
 475:	75 e9                	jne    460 <strcmp+0x20>
 477:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 479:	29 c8                	sub    %ecx,%eax
}
 47b:	5b                   	pop    %ebx
 47c:	5d                   	pop    %ebp
 47d:	c3                   	ret    
 47e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 481:	31 c0                	xor    %eax,%eax
 483:	eb f4                	jmp    479 <strcmp+0x39>
 485:	0f b6 cb             	movzbl %bl,%ecx
 488:	eb ef                	jmp    479 <strcmp+0x39>
 48a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000490 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 496:	80 39 00             	cmpb   $0x0,(%ecx)
 499:	74 12                	je     4ad <strlen+0x1d>
 49b:	31 d2                	xor    %edx,%edx
 49d:	8d 76 00             	lea    0x0(%esi),%esi
 4a0:	83 c2 01             	add    $0x1,%edx
 4a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 4a7:	89 d0                	mov    %edx,%eax
 4a9:	75 f5                	jne    4a0 <strlen+0x10>
    ;
  return n;
}
 4ab:	5d                   	pop    %ebp
 4ac:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 4ad:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 4af:	5d                   	pop    %ebp
 4b0:	c3                   	ret    
 4b1:	eb 0d                	jmp    4c0 <memset>
 4b3:	90                   	nop
 4b4:	90                   	nop
 4b5:	90                   	nop
 4b6:	90                   	nop
 4b7:	90                   	nop
 4b8:	90                   	nop
 4b9:	90                   	nop
 4ba:	90                   	nop
 4bb:	90                   	nop
 4bc:	90                   	nop
 4bd:	90                   	nop
 4be:	90                   	nop
 4bf:	90                   	nop

000004c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	8b 55 08             	mov    0x8(%ebp),%edx
 4c6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 4c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cd:	89 d7                	mov    %edx,%edi
 4cf:	fc                   	cld    
 4d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 4d2:	89 d0                	mov    %edx,%eax
 4d4:	5f                   	pop    %edi
 4d5:	5d                   	pop    %ebp
 4d6:	c3                   	ret    
 4d7:	89 f6                	mov    %esi,%esi
 4d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004e0 <strchr>:

char*
strchr(const char *s, char c)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	53                   	push   %ebx
 4e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 4ea:	0f b6 18             	movzbl (%eax),%ebx
 4ed:	84 db                	test   %bl,%bl
 4ef:	74 1d                	je     50e <strchr+0x2e>
    if(*s == c)
 4f1:	38 d3                	cmp    %dl,%bl
 4f3:	89 d1                	mov    %edx,%ecx
 4f5:	75 0d                	jne    504 <strchr+0x24>
 4f7:	eb 17                	jmp    510 <strchr+0x30>
 4f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 500:	38 ca                	cmp    %cl,%dl
 502:	74 0c                	je     510 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 504:	83 c0 01             	add    $0x1,%eax
 507:	0f b6 10             	movzbl (%eax),%edx
 50a:	84 d2                	test   %dl,%dl
 50c:	75 f2                	jne    500 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 50e:	31 c0                	xor    %eax,%eax
}
 510:	5b                   	pop    %ebx
 511:	5d                   	pop    %ebp
 512:	c3                   	ret    
 513:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000520 <gets>:

char*
gets(char *buf, int max)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 525:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 527:	53                   	push   %ebx
 528:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 52b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 52e:	eb 31                	jmp    561 <gets+0x41>
    cc = read(0, &c, 1);
 530:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 537:	00 
 538:	89 7c 24 04          	mov    %edi,0x4(%esp)
 53c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 543:	e8 02 01 00 00       	call   64a <read>
    if(cc < 1)
 548:	85 c0                	test   %eax,%eax
 54a:	7e 1d                	jle    569 <gets+0x49>
      break;
    buf[i++] = c;
 54c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 550:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 552:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 555:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 557:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 55b:	74 0c                	je     569 <gets+0x49>
 55d:	3c 0a                	cmp    $0xa,%al
 55f:	74 08                	je     569 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 561:	8d 5e 01             	lea    0x1(%esi),%ebx
 564:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 567:	7c c7                	jl     530 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 570:	83 c4 2c             	add    $0x2c,%esp
 573:	5b                   	pop    %ebx
 574:	5e                   	pop    %esi
 575:	5f                   	pop    %edi
 576:	5d                   	pop    %ebp
 577:	c3                   	ret    
 578:	90                   	nop
 579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000580 <stat>:

int
stat(char *n, struct stat *st)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	56                   	push   %esi
 584:	53                   	push   %ebx
 585:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 592:	00 
 593:	89 04 24             	mov    %eax,(%esp)
 596:	e8 d7 00 00 00       	call   672 <open>
  if(fd < 0)
 59b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 59d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 59f:	78 27                	js     5c8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 5a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a4:	89 1c 24             	mov    %ebx,(%esp)
 5a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ab:	e8 da 00 00 00       	call   68a <fstat>
  close(fd);
 5b0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 5b3:	89 c6                	mov    %eax,%esi
  close(fd);
 5b5:	e8 a0 00 00 00       	call   65a <close>
  return r;
 5ba:	89 f0                	mov    %esi,%eax
}
 5bc:	83 c4 10             	add    $0x10,%esp
 5bf:	5b                   	pop    %ebx
 5c0:	5e                   	pop    %esi
 5c1:	5d                   	pop    %ebp
 5c2:	c3                   	ret    
 5c3:	90                   	nop
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 5c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5cd:	eb ed                	jmp    5bc <stat+0x3c>
 5cf:	90                   	nop

000005d0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5d6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5d7:	0f be 11             	movsbl (%ecx),%edx
 5da:	8d 42 d0             	lea    -0x30(%edx),%eax
 5dd:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 5df:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 5e4:	77 17                	ja     5fd <atoi+0x2d>
 5e6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 5e8:	83 c1 01             	add    $0x1,%ecx
 5eb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 5ee:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5f2:	0f be 11             	movsbl (%ecx),%edx
 5f5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 5f8:	80 fb 09             	cmp    $0x9,%bl
 5fb:	76 eb                	jbe    5e8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 5fd:	5b                   	pop    %ebx
 5fe:	5d                   	pop    %ebp
 5ff:	c3                   	ret    

00000600 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 600:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 601:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 603:	89 e5                	mov    %esp,%ebp
 605:	56                   	push   %esi
 606:	8b 45 08             	mov    0x8(%ebp),%eax
 609:	53                   	push   %ebx
 60a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 60d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 610:	85 db                	test   %ebx,%ebx
 612:	7e 12                	jle    626 <memmove+0x26>
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 618:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 61c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 61f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 622:	39 da                	cmp    %ebx,%edx
 624:	75 f2                	jne    618 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 626:	5b                   	pop    %ebx
 627:	5e                   	pop    %esi
 628:	5d                   	pop    %ebp
 629:	c3                   	ret    

0000062a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 62a:	b8 01 00 00 00       	mov    $0x1,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <exit>:
SYSCALL(exit)
 632:	b8 02 00 00 00       	mov    $0x2,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <wait>:
SYSCALL(wait)
 63a:	b8 03 00 00 00       	mov    $0x3,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <pipe>:
SYSCALL(pipe)
 642:	b8 04 00 00 00       	mov    $0x4,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <read>:
SYSCALL(read)
 64a:	b8 05 00 00 00       	mov    $0x5,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <write>:
SYSCALL(write)
 652:	b8 10 00 00 00       	mov    $0x10,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <close>:
SYSCALL(close)
 65a:	b8 15 00 00 00       	mov    $0x15,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <kill>:
SYSCALL(kill)
 662:	b8 06 00 00 00       	mov    $0x6,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <exec>:
SYSCALL(exec)
 66a:	b8 07 00 00 00       	mov    $0x7,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <open>:
SYSCALL(open)
 672:	b8 0f 00 00 00       	mov    $0xf,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <mknod>:
SYSCALL(mknod)
 67a:	b8 11 00 00 00       	mov    $0x11,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <unlink>:
SYSCALL(unlink)
 682:	b8 12 00 00 00       	mov    $0x12,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <fstat>:
SYSCALL(fstat)
 68a:	b8 08 00 00 00       	mov    $0x8,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <link>:
SYSCALL(link)
 692:	b8 13 00 00 00       	mov    $0x13,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <mkdir>:
SYSCALL(mkdir)
 69a:	b8 14 00 00 00       	mov    $0x14,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <chdir>:
SYSCALL(chdir)
 6a2:	b8 09 00 00 00       	mov    $0x9,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <dup>:
SYSCALL(dup)
 6aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <getpid>:
SYSCALL(getpid)
 6b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <sbrk>:
SYSCALL(sbrk)
 6ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <sleep>:
SYSCALL(sleep)
 6c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    

000006ca <uptime>:
SYSCALL(uptime)
 6ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 6cf:	cd 40                	int    $0x40
 6d1:	c3                   	ret    

000006d2 <myMemory>:
SYSCALL(myMemory)
 6d2:	b8 16 00 00 00       	mov    $0x16,%eax
 6d7:	cd 40                	int    $0x40
 6d9:	c3                   	ret    

000006da <inodeTBWalker>:
SYSCALL(inodeTBWalker)
 6da:	b8 17 00 00 00       	mov    $0x17,%eax
 6df:	cd 40                	int    $0x40
 6e1:	c3                   	ret    

000006e2 <deleteIData>:
SYSCALL(deleteIData)
 6e2:	b8 18 00 00 00       	mov    $0x18,%eax
 6e7:	cd 40                	int    $0x40
 6e9:	c3                   	ret    

000006ea <directoryWalker>:
SYSCALL(directoryWalker)
 6ea:	b8 19 00 00 00       	mov    $0x19,%eax
 6ef:	cd 40                	int    $0x40
 6f1:	c3                   	ret    
 6f2:	66 90                	xchg   %ax,%ax
 6f4:	66 90                	xchg   %ax,%ax
 6f6:	66 90                	xchg   %ax,%ax
 6f8:	66 90                	xchg   %ax,%ax
 6fa:	66 90                	xchg   %ax,%ax
 6fc:	66 90                	xchg   %ax,%ax
 6fe:	66 90                	xchg   %ax,%ax

00000700 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	89 c6                	mov    %eax,%esi
 707:	53                   	push   %ebx
 708:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 70b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 70e:	85 db                	test   %ebx,%ebx
 710:	74 09                	je     71b <printint+0x1b>
 712:	89 d0                	mov    %edx,%eax
 714:	c1 e8 1f             	shr    $0x1f,%eax
 717:	84 c0                	test   %al,%al
 719:	75 75                	jne    790 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 71b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 71d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 724:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 727:	31 ff                	xor    %edi,%edi
 729:	89 ce                	mov    %ecx,%esi
 72b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 72e:	eb 02                	jmp    732 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 730:	89 cf                	mov    %ecx,%edi
 732:	31 d2                	xor    %edx,%edx
 734:	f7 f6                	div    %esi
 736:	8d 4f 01             	lea    0x1(%edi),%ecx
 739:	0f b6 92 96 0c 00 00 	movzbl 0xc96(%edx),%edx
  }while((x /= base) != 0);
 740:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 742:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 745:	75 e9                	jne    730 <printint+0x30>
  if(neg)
 747:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 74a:	89 c8                	mov    %ecx,%eax
 74c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 74f:	85 d2                	test   %edx,%edx
 751:	74 08                	je     75b <printint+0x5b>
    buf[i++] = '-';
 753:	8d 4f 02             	lea    0x2(%edi),%ecx
 756:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 75b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 75e:	66 90                	xchg   %ax,%ax
 760:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 765:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 768:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 76f:	00 
 770:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 774:	89 34 24             	mov    %esi,(%esp)
 777:	88 45 d7             	mov    %al,-0x29(%ebp)
 77a:	e8 d3 fe ff ff       	call   652 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 77f:	83 ff ff             	cmp    $0xffffffff,%edi
 782:	75 dc                	jne    760 <printint+0x60>
    putc(fd, buf[i]);
}
 784:	83 c4 4c             	add    $0x4c,%esp
 787:	5b                   	pop    %ebx
 788:	5e                   	pop    %esi
 789:	5f                   	pop    %edi
 78a:	5d                   	pop    %ebp
 78b:	c3                   	ret    
 78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 790:	89 d0                	mov    %edx,%eax
 792:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 794:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 79b:	eb 87                	jmp    724 <printint+0x24>
 79d:	8d 76 00             	lea    0x0(%esi),%esi

000007a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7a4:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7a6:	56                   	push   %esi
 7a7:	53                   	push   %ebx
 7a8:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 7ae:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7b1:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 7b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 7b7:	0f b6 13             	movzbl (%ebx),%edx
 7ba:	83 c3 01             	add    $0x1,%ebx
 7bd:	84 d2                	test   %dl,%dl
 7bf:	75 39                	jne    7fa <printf+0x5a>
 7c1:	e9 c2 00 00 00       	jmp    888 <printf+0xe8>
 7c6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 7c8:	83 fa 25             	cmp    $0x25,%edx
 7cb:	0f 84 bf 00 00 00    	je     890 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7d1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 7d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7db:	00 
 7dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 7e3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7e6:	e8 67 fe ff ff       	call   652 <write>
 7eb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7ee:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 7f2:	84 d2                	test   %dl,%dl
 7f4:	0f 84 8e 00 00 00    	je     888 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 7fa:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 7fc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 7ff:	74 c7                	je     7c8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 801:	83 ff 25             	cmp    $0x25,%edi
 804:	75 e5                	jne    7eb <printf+0x4b>
      if(c == 'd'){
 806:	83 fa 64             	cmp    $0x64,%edx
 809:	0f 84 31 01 00 00    	je     940 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 80f:	25 f7 00 00 00       	and    $0xf7,%eax
 814:	83 f8 70             	cmp    $0x70,%eax
 817:	0f 84 83 00 00 00    	je     8a0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 81d:	83 fa 73             	cmp    $0x73,%edx
 820:	0f 84 a2 00 00 00    	je     8c8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 826:	83 fa 63             	cmp    $0x63,%edx
 829:	0f 84 35 01 00 00    	je     964 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 82f:	83 fa 25             	cmp    $0x25,%edx
 832:	0f 84 e0 00 00 00    	je     918 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 838:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 83b:	83 c3 01             	add    $0x1,%ebx
 83e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 845:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 846:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 848:	89 44 24 04          	mov    %eax,0x4(%esp)
 84c:	89 34 24             	mov    %esi,(%esp)
 84f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 852:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 856:	e8 f7 fd ff ff       	call   652 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 85b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 85e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 861:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 868:	00 
 869:	89 44 24 04          	mov    %eax,0x4(%esp)
 86d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 870:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 873:	e8 da fd ff ff       	call   652 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 878:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 87c:	84 d2                	test   %dl,%dl
 87e:	0f 85 76 ff ff ff    	jne    7fa <printf+0x5a>
 884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 888:	83 c4 3c             	add    $0x3c,%esp
 88b:	5b                   	pop    %ebx
 88c:	5e                   	pop    %esi
 88d:	5f                   	pop    %edi
 88e:	5d                   	pop    %ebp
 88f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 890:	bf 25 00 00 00       	mov    $0x25,%edi
 895:	e9 51 ff ff ff       	jmp    7eb <printf+0x4b>
 89a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 8a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 8a3:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8a8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 8aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8b1:	8b 10                	mov    (%eax),%edx
 8b3:	89 f0                	mov    %esi,%eax
 8b5:	e8 46 fe ff ff       	call   700 <printint>
        ap++;
 8ba:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 8be:	e9 28 ff ff ff       	jmp    7eb <printf+0x4b>
 8c3:	90                   	nop
 8c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 8c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 8cb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 8cf:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 8d1:	b8 8f 0c 00 00       	mov    $0xc8f,%eax
 8d6:	85 ff                	test   %edi,%edi
 8d8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 8db:	0f b6 07             	movzbl (%edi),%eax
 8de:	84 c0                	test   %al,%al
 8e0:	74 2a                	je     90c <printf+0x16c>
 8e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8e8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8eb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 8ee:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8f8:	00 
 8f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 8fd:	89 34 24             	mov    %esi,(%esp)
 900:	e8 4d fd ff ff       	call   652 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 905:	0f b6 07             	movzbl (%edi),%eax
 908:	84 c0                	test   %al,%al
 90a:	75 dc                	jne    8e8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 90c:	31 ff                	xor    %edi,%edi
 90e:	e9 d8 fe ff ff       	jmp    7eb <printf+0x4b>
 913:	90                   	nop
 914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 918:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 91b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 91d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 924:	00 
 925:	89 44 24 04          	mov    %eax,0x4(%esp)
 929:	89 34 24             	mov    %esi,(%esp)
 92c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 930:	e8 1d fd ff ff       	call   652 <write>
 935:	e9 b1 fe ff ff       	jmp    7eb <printf+0x4b>
 93a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 940:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 943:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 948:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 94b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 952:	8b 10                	mov    (%eax),%edx
 954:	89 f0                	mov    %esi,%eax
 956:	e8 a5 fd ff ff       	call   700 <printint>
        ap++;
 95b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 95f:	e9 87 fe ff ff       	jmp    7eb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 964:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 967:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 969:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 96b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 972:	00 
 973:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 976:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 979:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 97c:	89 44 24 04          	mov    %eax,0x4(%esp)
 980:	e8 cd fc ff ff       	call   652 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 985:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 989:	e9 5d fe ff ff       	jmp    7eb <printf+0x4b>
 98e:	66 90                	xchg   %ax,%ax

00000990 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 990:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 991:	a1 84 0f 00 00       	mov    0xf84,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 996:	89 e5                	mov    %esp,%ebp
 998:	57                   	push   %edi
 999:	56                   	push   %esi
 99a:	53                   	push   %ebx
 99b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9a0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a3:	39 d0                	cmp    %edx,%eax
 9a5:	72 11                	jb     9b8 <free+0x28>
 9a7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a8:	39 c8                	cmp    %ecx,%eax
 9aa:	72 04                	jb     9b0 <free+0x20>
 9ac:	39 ca                	cmp    %ecx,%edx
 9ae:	72 10                	jb     9c0 <free+0x30>
 9b0:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b4:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b6:	73 f0                	jae    9a8 <free+0x18>
 9b8:	39 ca                	cmp    %ecx,%edx
 9ba:	72 04                	jb     9c0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9bc:	39 c8                	cmp    %ecx,%eax
 9be:	72 f0                	jb     9b0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9c0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 9c3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 9c6:	39 cf                	cmp    %ecx,%edi
 9c8:	74 1e                	je     9e8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 9ca:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 9cd:	8b 48 04             	mov    0x4(%eax),%ecx
 9d0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 9d3:	39 f2                	cmp    %esi,%edx
 9d5:	74 28                	je     9ff <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 9d7:	89 10                	mov    %edx,(%eax)
  freep = p;
 9d9:	a3 84 0f 00 00       	mov    %eax,0xf84
}
 9de:	5b                   	pop    %ebx
 9df:	5e                   	pop    %esi
 9e0:	5f                   	pop    %edi
 9e1:	5d                   	pop    %ebp
 9e2:	c3                   	ret    
 9e3:	90                   	nop
 9e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9e8:	03 71 04             	add    0x4(%ecx),%esi
 9eb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ee:	8b 08                	mov    (%eax),%ecx
 9f0:	8b 09                	mov    (%ecx),%ecx
 9f2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9f5:	8b 48 04             	mov    0x4(%eax),%ecx
 9f8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 9fb:	39 f2                	cmp    %esi,%edx
 9fd:	75 d8                	jne    9d7 <free+0x47>
    p->s.size += bp->s.size;
 9ff:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 a02:	a3 84 0f 00 00       	mov    %eax,0xf84
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a07:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a0a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 a0d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 a0f:	5b                   	pop    %ebx
 a10:	5e                   	pop    %esi
 a11:	5f                   	pop    %edi
 a12:	5d                   	pop    %ebp
 a13:	c3                   	ret    
 a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000a20 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a20:	55                   	push   %ebp
 a21:	89 e5                	mov    %esp,%ebp
 a23:	57                   	push   %edi
 a24:	56                   	push   %esi
 a25:	53                   	push   %ebx
 a26:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a29:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 a2c:	8b 1d 84 0f 00 00    	mov    0xf84,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a32:	8d 48 07             	lea    0x7(%eax),%ecx
 a35:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 a38:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a3a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 a3d:	0f 84 9b 00 00 00    	je     ade <malloc+0xbe>
 a43:	8b 13                	mov    (%ebx),%edx
 a45:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 a48:	39 fe                	cmp    %edi,%esi
 a4a:	76 64                	jbe    ab0 <malloc+0x90>
 a4c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 a53:	bb 00 80 00 00       	mov    $0x8000,%ebx
 a58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 a5b:	eb 0e                	jmp    a6b <malloc+0x4b>
 a5d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a60:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a62:	8b 78 04             	mov    0x4(%eax),%edi
 a65:	39 fe                	cmp    %edi,%esi
 a67:	76 4f                	jbe    ab8 <malloc+0x98>
 a69:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a6b:	3b 15 84 0f 00 00    	cmp    0xf84,%edx
 a71:	75 ed                	jne    a60 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 a73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a76:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 a7c:	bf 00 10 00 00       	mov    $0x1000,%edi
 a81:	0f 43 fe             	cmovae %esi,%edi
 a84:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 a87:	89 04 24             	mov    %eax,(%esp)
 a8a:	e8 2b fc ff ff       	call   6ba <sbrk>
  if(p == (char*)-1)
 a8f:	83 f8 ff             	cmp    $0xffffffff,%eax
 a92:	74 18                	je     aac <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 a94:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 a97:	83 c0 08             	add    $0x8,%eax
 a9a:	89 04 24             	mov    %eax,(%esp)
 a9d:	e8 ee fe ff ff       	call   990 <free>
  return freep;
 aa2:	8b 15 84 0f 00 00    	mov    0xf84,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 aa8:	85 d2                	test   %edx,%edx
 aaa:	75 b4                	jne    a60 <malloc+0x40>
        return 0;
 aac:	31 c0                	xor    %eax,%eax
 aae:	eb 20                	jmp    ad0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 ab0:	89 d0                	mov    %edx,%eax
 ab2:	89 da                	mov    %ebx,%edx
 ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 ab8:	39 fe                	cmp    %edi,%esi
 aba:	74 1c                	je     ad8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 abc:	29 f7                	sub    %esi,%edi
 abe:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 ac1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 ac4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 ac7:	89 15 84 0f 00 00    	mov    %edx,0xf84
      return (void*)(p + 1);
 acd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ad0:	83 c4 1c             	add    $0x1c,%esp
 ad3:	5b                   	pop    %ebx
 ad4:	5e                   	pop    %esi
 ad5:	5f                   	pop    %edi
 ad6:	5d                   	pop    %ebp
 ad7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 ad8:	8b 08                	mov    (%eax),%ecx
 ada:	89 0a                	mov    %ecx,(%edx)
 adc:	eb e9                	jmp    ac7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 ade:	c7 05 84 0f 00 00 88 	movl   $0xf88,0xf84
 ae5:	0f 00 00 
    base.s.size = 0;
 ae8:	ba 88 0f 00 00       	mov    $0xf88,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 aed:	c7 05 88 0f 00 00 88 	movl   $0xf88,0xf88
 af4:	0f 00 00 
    base.s.size = 0;
 af7:	c7 05 8c 0f 00 00 00 	movl   $0x0,0xf8c
 afe:	00 00 00 
 b01:	e9 46 ff ff ff       	jmp    a4c <malloc+0x2c>
