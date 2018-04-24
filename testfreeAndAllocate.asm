
_testfreeAndAllocate:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "syscall.h"
#include "stat.h"
#include "fcntl.h"

int main(int argc, char **argv){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 10             	sub    $0x10,%esp
	// Part 1
	printf(1,"Begin Test\n");
   a:	c7 44 24 04 48 08 00 	movl   $0x848,0x4(%esp)
  11:	00 
  12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  19:	e8 c2 04 00 00       	call   4e0 <printf>
	myMemory();
  1e:	e8 df 03 00 00       	call   402 <myMemory>
	printf(1,"sbrk'ing 8192 (2 pages)\n");
  23:	c7 44 24 04 54 08 00 	movl   $0x854,0x4(%esp)
  2a:	00 
  2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  32:	e8 a9 04 00 00       	call   4e0 <printf>
	sbrk(8192);
  37:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
  3e:	e8 a7 03 00 00       	call   3ea <sbrk>
	myMemory();
  43:	e8 ba 03 00 00       	call   402 <myMemory>
	printf(1,"sbrk'ing -8192 (2 pages)\n");
  48:	c7 44 24 04 6d 08 00 	movl   $0x86d,0x4(%esp)
  4f:	00 
  50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  57:	e8 84 04 00 00       	call   4e0 <printf>
	sbrk(-8192);
  5c:	c7 04 24 00 e0 ff ff 	movl   $0xffffe000,(%esp)
  63:	e8 82 03 00 00       	call   3ea <sbrk>
	myMemory();
  68:	e8 95 03 00 00       	call   402 <myMemory>

	// Part 2
	printf(1,"Malloc'ing Integer Array of size 49152\n");
  6d:	c7 44 24 04 88 08 00 	movl   $0x888,0x4(%esp)
  74:	00 
  75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7c:	e8 5f 04 00 00       	call   4e0 <printf>
	char *arrayPointer = (char *)malloc(49152);
  81:	c7 04 24 00 c0 00 00 	movl   $0xc000,(%esp)
  88:	e8 d3 06 00 00       	call   760 <malloc>
  8d:	89 c3                	mov    %eax,%ebx
    // 10 pages worth of integers plus one page for the pointer
    myMemory();
  8f:	e8 6e 03 00 00       	call   402 <myMemory>
    printf(1,"Freeing Integer Array (Won't Change # of Pages)\n");
  94:	c7 44 24 04 b0 08 00 	movl   $0x8b0,0x4(%esp)
  9b:	00 
  9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a3:	e8 38 04 00 00       	call   4e0 <printf>
    free(arrayPointer);
  a8:	89 1c 24             	mov    %ebx,(%esp)
  ab:	e8 20 06 00 00       	call   6d0 <free>
    myMemory();
  b0:	e8 4d 03 00 00       	call   402 <myMemory>
    printf(1,"Force sbrk to reduce # of pages\n");
  b5:	c7 44 24 04 e4 08 00 	movl   $0x8e4,0x4(%esp)
  bc:	00 
  bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c4:	e8 17 04 00 00       	call   4e0 <printf>
    sbrk(-49152);
  c9:	c7 04 24 00 40 ff ff 	movl   $0xffff4000,(%esp)
  d0:	e8 15 03 00 00       	call   3ea <sbrk>
    myMemory();
  d5:	e8 28 03 00 00       	call   402 <myMemory>
    printf(1,"One lingering page for the array pointer (stack variable)\n");
  da:	c7 44 24 04 08 09 00 	movl   $0x908,0x4(%esp)
  e1:	00 
  e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e9:	e8 f2 03 00 00       	call   4e0 <printf>

    // Part 3
    sbrk(230000000);
  ee:	c7 04 24 80 85 b5 0d 	movl   $0xdb58580,(%esp)
  f5:	e8 f0 02 00 00       	call   3ea <sbrk>
    myMemory();
  fa:	e8 03 03 00 00       	call   402 <myMemory>
    sbrk(5000000);
  ff:	c7 04 24 40 4b 4c 00 	movl   $0x4c4b40,(%esp)
 106:	e8 df 02 00 00       	call   3ea <sbrk>
    myMemory();
 10b:	e8 f2 02 00 00       	call   402 <myMemory>
    sbrk(-5000000);
 110:	c7 04 24 c0 b4 b3 ff 	movl   $0xffb3b4c0,(%esp)
 117:	e8 ce 02 00 00       	call   3ea <sbrk>
    myMemory();
 11c:	e8 e1 02 00 00       	call   402 <myMemory>
    sbrk(5000000);
 121:	c7 04 24 40 4b 4c 00 	movl   $0x4c4b40,(%esp)
 128:	e8 bd 02 00 00       	call   3ea <sbrk>
    myMemory();
 12d:	e8 d0 02 00 00       	call   402 <myMemory>


	exit();
 132:	e8 2b 02 00 00       	call   362 <exit>
 137:	66 90                	xchg   %ax,%ax
 139:	66 90                	xchg   %ax,%ax
 13b:	66 90                	xchg   %ax,%ax
 13d:	66 90                	xchg   %ax,%ax
 13f:	90                   	nop

00000140 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 149:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 14a:	89 c2                	mov    %eax,%edx
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 150:	83 c1 01             	add    $0x1,%ecx
 153:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 157:	83 c2 01             	add    $0x1,%edx
 15a:	84 db                	test   %bl,%bl
 15c:	88 5a ff             	mov    %bl,-0x1(%edx)
 15f:	75 ef                	jne    150 <strcpy+0x10>
    ;
  return os;
}
 161:	5b                   	pop    %ebx
 162:	5d                   	pop    %ebp
 163:	c3                   	ret    
 164:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 16a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000170 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 55 08             	mov    0x8(%ebp),%edx
 176:	53                   	push   %ebx
 177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 17a:	0f b6 02             	movzbl (%edx),%eax
 17d:	84 c0                	test   %al,%al
 17f:	74 2d                	je     1ae <strcmp+0x3e>
 181:	0f b6 19             	movzbl (%ecx),%ebx
 184:	38 d8                	cmp    %bl,%al
 186:	74 0e                	je     196 <strcmp+0x26>
 188:	eb 2b                	jmp    1b5 <strcmp+0x45>
 18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 190:	38 c8                	cmp    %cl,%al
 192:	75 15                	jne    1a9 <strcmp+0x39>
    p++, q++;
 194:	89 d9                	mov    %ebx,%ecx
 196:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 199:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 19c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 19f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 1a3:	84 c0                	test   %al,%al
 1a5:	75 e9                	jne    190 <strcmp+0x20>
 1a7:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1a9:	29 c8                	sub    %ecx,%eax
}
 1ab:	5b                   	pop    %ebx
 1ac:	5d                   	pop    %ebp
 1ad:	c3                   	ret    
 1ae:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1b1:	31 c0                	xor    %eax,%eax
 1b3:	eb f4                	jmp    1a9 <strcmp+0x39>
 1b5:	0f b6 cb             	movzbl %bl,%ecx
 1b8:	eb ef                	jmp    1a9 <strcmp+0x39>
 1ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001c0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1c6:	80 39 00             	cmpb   $0x0,(%ecx)
 1c9:	74 12                	je     1dd <strlen+0x1d>
 1cb:	31 d2                	xor    %edx,%edx
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
 1d0:	83 c2 01             	add    $0x1,%edx
 1d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1d7:	89 d0                	mov    %edx,%eax
 1d9:	75 f5                	jne    1d0 <strlen+0x10>
    ;
  return n;
}
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 1dd:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    
 1e1:	eb 0d                	jmp    1f0 <memset>
 1e3:	90                   	nop
 1e4:	90                   	nop
 1e5:	90                   	nop
 1e6:	90                   	nop
 1e7:	90                   	nop
 1e8:	90                   	nop
 1e9:	90                   	nop
 1ea:	90                   	nop
 1eb:	90                   	nop
 1ec:	90                   	nop
 1ed:	90                   	nop
 1ee:	90                   	nop
 1ef:	90                   	nop

000001f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 55 08             	mov    0x8(%ebp),%edx
 1f6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fd:	89 d7                	mov    %edx,%edi
 1ff:	fc                   	cld    
 200:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 202:	89 d0                	mov    %edx,%eax
 204:	5f                   	pop    %edi
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    
 207:	89 f6                	mov    %esi,%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000210 <strchr>:

char*
strchr(const char *s, char c)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	53                   	push   %ebx
 217:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 21a:	0f b6 18             	movzbl (%eax),%ebx
 21d:	84 db                	test   %bl,%bl
 21f:	74 1d                	je     23e <strchr+0x2e>
    if(*s == c)
 221:	38 d3                	cmp    %dl,%bl
 223:	89 d1                	mov    %edx,%ecx
 225:	75 0d                	jne    234 <strchr+0x24>
 227:	eb 17                	jmp    240 <strchr+0x30>
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 230:	38 ca                	cmp    %cl,%dl
 232:	74 0c                	je     240 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 234:	83 c0 01             	add    $0x1,%eax
 237:	0f b6 10             	movzbl (%eax),%edx
 23a:	84 d2                	test   %dl,%dl
 23c:	75 f2                	jne    230 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 23e:	31 c0                	xor    %eax,%eax
}
 240:	5b                   	pop    %ebx
 241:	5d                   	pop    %ebp
 242:	c3                   	ret    
 243:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000250 <gets>:

char*
gets(char *buf, int max)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 255:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 257:	53                   	push   %ebx
 258:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 25b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25e:	eb 31                	jmp    291 <gets+0x41>
    cc = read(0, &c, 1);
 260:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 267:	00 
 268:	89 7c 24 04          	mov    %edi,0x4(%esp)
 26c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 273:	e8 02 01 00 00       	call   37a <read>
    if(cc < 1)
 278:	85 c0                	test   %eax,%eax
 27a:	7e 1d                	jle    299 <gets+0x49>
      break;
    buf[i++] = c;
 27c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 280:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 282:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 285:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 287:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 28b:	74 0c                	je     299 <gets+0x49>
 28d:	3c 0a                	cmp    $0xa,%al
 28f:	74 08                	je     299 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 291:	8d 5e 01             	lea    0x1(%esi),%ebx
 294:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 297:	7c c7                	jl     260 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2a0:	83 c4 2c             	add    $0x2c,%esp
 2a3:	5b                   	pop    %ebx
 2a4:	5e                   	pop    %esi
 2a5:	5f                   	pop    %edi
 2a6:	5d                   	pop    %ebp
 2a7:	c3                   	ret    
 2a8:	90                   	nop
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002b0 <stat>:

int
stat(char *n, struct stat *st)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	56                   	push   %esi
 2b4:	53                   	push   %ebx
 2b5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2c2:	00 
 2c3:	89 04 24             	mov    %eax,(%esp)
 2c6:	e8 d7 00 00 00       	call   3a2 <open>
  if(fd < 0)
 2cb:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2cd:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2cf:	78 27                	js     2f8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d4:	89 1c 24             	mov    %ebx,(%esp)
 2d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2db:	e8 da 00 00 00       	call   3ba <fstat>
  close(fd);
 2e0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2e3:	89 c6                	mov    %eax,%esi
  close(fd);
 2e5:	e8 a0 00 00 00       	call   38a <close>
  return r;
 2ea:	89 f0                	mov    %esi,%eax
}
 2ec:	83 c4 10             	add    $0x10,%esp
 2ef:	5b                   	pop    %ebx
 2f0:	5e                   	pop    %esi
 2f1:	5d                   	pop    %ebp
 2f2:	c3                   	ret    
 2f3:	90                   	nop
 2f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 2f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2fd:	eb ed                	jmp    2ec <stat+0x3c>
 2ff:	90                   	nop

00000300 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	8b 4d 08             	mov    0x8(%ebp),%ecx
 306:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 307:	0f be 11             	movsbl (%ecx),%edx
 30a:	8d 42 d0             	lea    -0x30(%edx),%eax
 30d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 30f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 314:	77 17                	ja     32d <atoi+0x2d>
 316:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 318:	83 c1 01             	add    $0x1,%ecx
 31b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 31e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 322:	0f be 11             	movsbl (%ecx),%edx
 325:	8d 5a d0             	lea    -0x30(%edx),%ebx
 328:	80 fb 09             	cmp    $0x9,%bl
 32b:	76 eb                	jbe    318 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 32d:	5b                   	pop    %ebx
 32e:	5d                   	pop    %ebp
 32f:	c3                   	ret    

00000330 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 330:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 331:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 333:	89 e5                	mov    %esp,%ebp
 335:	56                   	push   %esi
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	53                   	push   %ebx
 33a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 33d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 340:	85 db                	test   %ebx,%ebx
 342:	7e 12                	jle    356 <memmove+0x26>
 344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 348:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 34c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 34f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 352:	39 da                	cmp    %ebx,%edx
 354:	75 f2                	jne    348 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 356:	5b                   	pop    %ebx
 357:	5e                   	pop    %esi
 358:	5d                   	pop    %ebp
 359:	c3                   	ret    

0000035a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35a:	b8 01 00 00 00       	mov    $0x1,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <exit>:
SYSCALL(exit)
 362:	b8 02 00 00 00       	mov    $0x2,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <wait>:
SYSCALL(wait)
 36a:	b8 03 00 00 00       	mov    $0x3,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <pipe>:
SYSCALL(pipe)
 372:	b8 04 00 00 00       	mov    $0x4,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <read>:
SYSCALL(read)
 37a:	b8 05 00 00 00       	mov    $0x5,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <write>:
SYSCALL(write)
 382:	b8 10 00 00 00       	mov    $0x10,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <close>:
SYSCALL(close)
 38a:	b8 15 00 00 00       	mov    $0x15,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <kill>:
SYSCALL(kill)
 392:	b8 06 00 00 00       	mov    $0x6,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <exec>:
SYSCALL(exec)
 39a:	b8 07 00 00 00       	mov    $0x7,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <open>:
SYSCALL(open)
 3a2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <mknod>:
SYSCALL(mknod)
 3aa:	b8 11 00 00 00       	mov    $0x11,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <unlink>:
SYSCALL(unlink)
 3b2:	b8 12 00 00 00       	mov    $0x12,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <fstat>:
SYSCALL(fstat)
 3ba:	b8 08 00 00 00       	mov    $0x8,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <link>:
SYSCALL(link)
 3c2:	b8 13 00 00 00       	mov    $0x13,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <mkdir>:
SYSCALL(mkdir)
 3ca:	b8 14 00 00 00       	mov    $0x14,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <chdir>:
SYSCALL(chdir)
 3d2:	b8 09 00 00 00       	mov    $0x9,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <dup>:
SYSCALL(dup)
 3da:	b8 0a 00 00 00       	mov    $0xa,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <getpid>:
SYSCALL(getpid)
 3e2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <sbrk>:
SYSCALL(sbrk)
 3ea:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <sleep>:
SYSCALL(sleep)
 3f2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <uptime>:
SYSCALL(uptime)
 3fa:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <myMemory>:
SYSCALL(myMemory)
 402:	b8 16 00 00 00       	mov    $0x16,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <inodeTBWalker>:
SYSCALL(inodeTBWalker)
 40a:	b8 17 00 00 00       	mov    $0x17,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <deleteIData>:
SYSCALL(deleteIData)
 412:	b8 18 00 00 00       	mov    $0x18,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <directoryWalker>:
SYSCALL(directoryWalker)
 41a:	b8 19 00 00 00       	mov    $0x19,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <compareWalkers>:
SYSCALL(compareWalkers)
 422:	b8 1a 00 00 00       	mov    $0x1a,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <recoverFS>:
SYSCALL(recoverFS)
 42a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    
 432:	66 90                	xchg   %ax,%ax
 434:	66 90                	xchg   %ax,%ax
 436:	66 90                	xchg   %ax,%ax
 438:	66 90                	xchg   %ax,%ax
 43a:	66 90                	xchg   %ax,%ax
 43c:	66 90                	xchg   %ax,%ax
 43e:	66 90                	xchg   %ax,%ax

00000440 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	89 c6                	mov    %eax,%esi
 447:	53                   	push   %ebx
 448:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 44e:	85 db                	test   %ebx,%ebx
 450:	74 09                	je     45b <printint+0x1b>
 452:	89 d0                	mov    %edx,%eax
 454:	c1 e8 1f             	shr    $0x1f,%eax
 457:	84 c0                	test   %al,%al
 459:	75 75                	jne    4d0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 45b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 45d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 464:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 467:	31 ff                	xor    %edi,%edi
 469:	89 ce                	mov    %ecx,%esi
 46b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 46e:	eb 02                	jmp    472 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 470:	89 cf                	mov    %ecx,%edi
 472:	31 d2                	xor    %edx,%edx
 474:	f7 f6                	div    %esi
 476:	8d 4f 01             	lea    0x1(%edi),%ecx
 479:	0f b6 92 4b 09 00 00 	movzbl 0x94b(%edx),%edx
  }while((x /= base) != 0);
 480:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 482:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 485:	75 e9                	jne    470 <printint+0x30>
  if(neg)
 487:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 48a:	89 c8                	mov    %ecx,%eax
 48c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 48f:	85 d2                	test   %edx,%edx
 491:	74 08                	je     49b <printint+0x5b>
    buf[i++] = '-';
 493:	8d 4f 02             	lea    0x2(%edi),%ecx
 496:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 49b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 49e:	66 90                	xchg   %ax,%ax
 4a0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 4a5:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4af:	00 
 4b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 4b4:	89 34 24             	mov    %esi,(%esp)
 4b7:	88 45 d7             	mov    %al,-0x29(%ebp)
 4ba:	e8 c3 fe ff ff       	call   382 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4bf:	83 ff ff             	cmp    $0xffffffff,%edi
 4c2:	75 dc                	jne    4a0 <printint+0x60>
    putc(fd, buf[i]);
}
 4c4:	83 c4 4c             	add    $0x4c,%esp
 4c7:	5b                   	pop    %ebx
 4c8:	5e                   	pop    %esi
 4c9:	5f                   	pop    %edi
 4ca:	5d                   	pop    %ebp
 4cb:	c3                   	ret    
 4cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4d0:	89 d0                	mov    %edx,%eax
 4d2:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 4d4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 4db:	eb 87                	jmp    464 <printint+0x24>
 4dd:	8d 76 00             	lea    0x0(%esi),%esi

000004e0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e4:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e6:	56                   	push   %esi
 4e7:	53                   	push   %ebx
 4e8:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4ee:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f1:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4f7:	0f b6 13             	movzbl (%ebx),%edx
 4fa:	83 c3 01             	add    $0x1,%ebx
 4fd:	84 d2                	test   %dl,%dl
 4ff:	75 39                	jne    53a <printf+0x5a>
 501:	e9 c2 00 00 00       	jmp    5c8 <printf+0xe8>
 506:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 508:	83 fa 25             	cmp    $0x25,%edx
 50b:	0f 84 bf 00 00 00    	je     5d0 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 511:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 514:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 51b:	00 
 51c:	89 44 24 04          	mov    %eax,0x4(%esp)
 520:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 523:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 526:	e8 57 fe ff ff       	call   382 <write>
 52b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 52e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 532:	84 d2                	test   %dl,%dl
 534:	0f 84 8e 00 00 00    	je     5c8 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 53a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 53c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 53f:	74 c7                	je     508 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 541:	83 ff 25             	cmp    $0x25,%edi
 544:	75 e5                	jne    52b <printf+0x4b>
      if(c == 'd'){
 546:	83 fa 64             	cmp    $0x64,%edx
 549:	0f 84 31 01 00 00    	je     680 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 54f:	25 f7 00 00 00       	and    $0xf7,%eax
 554:	83 f8 70             	cmp    $0x70,%eax
 557:	0f 84 83 00 00 00    	je     5e0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 55d:	83 fa 73             	cmp    $0x73,%edx
 560:	0f 84 a2 00 00 00    	je     608 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 566:	83 fa 63             	cmp    $0x63,%edx
 569:	0f 84 35 01 00 00    	je     6a4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 56f:	83 fa 25             	cmp    $0x25,%edx
 572:	0f 84 e0 00 00 00    	je     658 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 578:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 57b:	83 c3 01             	add    $0x1,%ebx
 57e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 585:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 586:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 588:	89 44 24 04          	mov    %eax,0x4(%esp)
 58c:	89 34 24             	mov    %esi,(%esp)
 58f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 592:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 596:	e8 e7 fd ff ff       	call   382 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 59b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 59e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5a8:	00 
 5a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ad:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5b0:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b3:	e8 ca fd ff ff       	call   382 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 5bc:	84 d2                	test   %dl,%dl
 5be:	0f 85 76 ff ff ff    	jne    53a <printf+0x5a>
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5c8:	83 c4 3c             	add    $0x3c,%esp
 5cb:	5b                   	pop    %ebx
 5cc:	5e                   	pop    %esi
 5cd:	5f                   	pop    %edi
 5ce:	5d                   	pop    %ebp
 5cf:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5d0:	bf 25 00 00 00       	mov    $0x25,%edi
 5d5:	e9 51 ff ff ff       	jmp    52b <printf+0x4b>
 5da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5e3:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5e8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5f1:	8b 10                	mov    (%eax),%edx
 5f3:	89 f0                	mov    %esi,%eax
 5f5:	e8 46 fe ff ff       	call   440 <printint>
        ap++;
 5fa:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5fe:	e9 28 ff ff ff       	jmp    52b <printf+0x4b>
 603:	90                   	nop
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 608:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 60b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 60f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 611:	b8 44 09 00 00       	mov    $0x944,%eax
 616:	85 ff                	test   %edi,%edi
 618:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 61b:	0f b6 07             	movzbl (%edi),%eax
 61e:	84 c0                	test   %al,%al
 620:	74 2a                	je     64c <printf+0x16c>
 622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 628:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 62b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 62e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 631:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 638:	00 
 639:	89 44 24 04          	mov    %eax,0x4(%esp)
 63d:	89 34 24             	mov    %esi,(%esp)
 640:	e8 3d fd ff ff       	call   382 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 645:	0f b6 07             	movzbl (%edi),%eax
 648:	84 c0                	test   %al,%al
 64a:	75 dc                	jne    628 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 64c:	31 ff                	xor    %edi,%edi
 64e:	e9 d8 fe ff ff       	jmp    52b <printf+0x4b>
 653:	90                   	nop
 654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 658:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 65b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 65d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 664:	00 
 665:	89 44 24 04          	mov    %eax,0x4(%esp)
 669:	89 34 24             	mov    %esi,(%esp)
 66c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 670:	e8 0d fd ff ff       	call   382 <write>
 675:	e9 b1 fe ff ff       	jmp    52b <printf+0x4b>
 67a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 680:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 683:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 688:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 68b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 692:	8b 10                	mov    (%eax),%edx
 694:	89 f0                	mov    %esi,%eax
 696:	e8 a5 fd ff ff       	call   440 <printint>
        ap++;
 69b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 69f:	e9 87 fe ff ff       	jmp    52b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6a7:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6a9:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6b2:	00 
 6b3:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6b6:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c0:	e8 bd fc ff ff       	call   382 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 6c5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6c9:	e9 5d fe ff ff       	jmp    52b <printf+0x4b>
 6ce:	66 90                	xchg   %ax,%ax

000006d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d1:	a1 c0 0b 00 00       	mov    0xbc0,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	57                   	push   %edi
 6d9:	56                   	push   %esi
 6da:	53                   	push   %ebx
 6db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6de:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e3:	39 d0                	cmp    %edx,%eax
 6e5:	72 11                	jb     6f8 <free+0x28>
 6e7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e8:	39 c8                	cmp    %ecx,%eax
 6ea:	72 04                	jb     6f0 <free+0x20>
 6ec:	39 ca                	cmp    %ecx,%edx
 6ee:	72 10                	jb     700 <free+0x30>
 6f0:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f4:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f6:	73 f0                	jae    6e8 <free+0x18>
 6f8:	39 ca                	cmp    %ecx,%edx
 6fa:	72 04                	jb     700 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fc:	39 c8                	cmp    %ecx,%eax
 6fe:	72 f0                	jb     6f0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 700:	8b 73 fc             	mov    -0x4(%ebx),%esi
 703:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 706:	39 cf                	cmp    %ecx,%edi
 708:	74 1e                	je     728 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 70a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 70d:	8b 48 04             	mov    0x4(%eax),%ecx
 710:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 713:	39 f2                	cmp    %esi,%edx
 715:	74 28                	je     73f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 717:	89 10                	mov    %edx,(%eax)
  freep = p;
 719:	a3 c0 0b 00 00       	mov    %eax,0xbc0
}
 71e:	5b                   	pop    %ebx
 71f:	5e                   	pop    %esi
 720:	5f                   	pop    %edi
 721:	5d                   	pop    %ebp
 722:	c3                   	ret    
 723:	90                   	nop
 724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 728:	03 71 04             	add    0x4(%ecx),%esi
 72b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 72e:	8b 08                	mov    (%eax),%ecx
 730:	8b 09                	mov    (%ecx),%ecx
 732:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 735:	8b 48 04             	mov    0x4(%eax),%ecx
 738:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 73b:	39 f2                	cmp    %esi,%edx
 73d:	75 d8                	jne    717 <free+0x47>
    p->s.size += bp->s.size;
 73f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 742:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 747:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 74a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 74d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 74f:	5b                   	pop    %ebx
 750:	5e                   	pop    %esi
 751:	5f                   	pop    %edi
 752:	5d                   	pop    %ebp
 753:	c3                   	ret    
 754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 75a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000760 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	57                   	push   %edi
 764:	56                   	push   %esi
 765:	53                   	push   %ebx
 766:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 769:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 76c:	8b 1d c0 0b 00 00    	mov    0xbc0,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 772:	8d 48 07             	lea    0x7(%eax),%ecx
 775:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 778:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 77d:	0f 84 9b 00 00 00    	je     81e <malloc+0xbe>
 783:	8b 13                	mov    (%ebx),%edx
 785:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 788:	39 fe                	cmp    %edi,%esi
 78a:	76 64                	jbe    7f0 <malloc+0x90>
 78c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 793:	bb 00 80 00 00       	mov    $0x8000,%ebx
 798:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 79b:	eb 0e                	jmp    7ab <malloc+0x4b>
 79d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7a2:	8b 78 04             	mov    0x4(%eax),%edi
 7a5:	39 fe                	cmp    %edi,%esi
 7a7:	76 4f                	jbe    7f8 <malloc+0x98>
 7a9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ab:	3b 15 c0 0b 00 00    	cmp    0xbc0,%edx
 7b1:	75 ed                	jne    7a0 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 7b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7bc:	bf 00 10 00 00       	mov    $0x1000,%edi
 7c1:	0f 43 fe             	cmovae %esi,%edi
 7c4:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 7c7:	89 04 24             	mov    %eax,(%esp)
 7ca:	e8 1b fc ff ff       	call   3ea <sbrk>
  if(p == (char*)-1)
 7cf:	83 f8 ff             	cmp    $0xffffffff,%eax
 7d2:	74 18                	je     7ec <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7d4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 7d7:	83 c0 08             	add    $0x8,%eax
 7da:	89 04 24             	mov    %eax,(%esp)
 7dd:	e8 ee fe ff ff       	call   6d0 <free>
  return freep;
 7e2:	8b 15 c0 0b 00 00    	mov    0xbc0,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 7e8:	85 d2                	test   %edx,%edx
 7ea:	75 b4                	jne    7a0 <malloc+0x40>
        return 0;
 7ec:	31 c0                	xor    %eax,%eax
 7ee:	eb 20                	jmp    810 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7f0:	89 d0                	mov    %edx,%eax
 7f2:	89 da                	mov    %ebx,%edx
 7f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 7f8:	39 fe                	cmp    %edi,%esi
 7fa:	74 1c                	je     818 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7fc:	29 f7                	sub    %esi,%edi
 7fe:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 801:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 804:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 807:	89 15 c0 0b 00 00    	mov    %edx,0xbc0
      return (void*)(p + 1);
 80d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 810:	83 c4 1c             	add    $0x1c,%esp
 813:	5b                   	pop    %ebx
 814:	5e                   	pop    %esi
 815:	5f                   	pop    %edi
 816:	5d                   	pop    %ebp
 817:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 818:	8b 08                	mov    (%eax),%ecx
 81a:	89 0a                	mov    %ecx,(%edx)
 81c:	eb e9                	jmp    807 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 81e:	c7 05 c0 0b 00 00 c4 	movl   $0xbc4,0xbc0
 825:	0b 00 00 
    base.s.size = 0;
 828:	ba c4 0b 00 00       	mov    $0xbc4,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 82d:	c7 05 c4 0b 00 00 c4 	movl   $0xbc4,0xbc4
 834:	0b 00 00 
    base.s.size = 0;
 837:	c7 05 c8 0b 00 00 00 	movl   $0x0,0xbc8
 83e:	00 00 00 
 841:	e9 46 ff ff ff       	jmp    78c <malloc+0x2c>
