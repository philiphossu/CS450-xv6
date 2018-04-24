
_recoverFS:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fs.h"
#include "fcntl.h"


int main(int argc, char *argv[]) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
	recoverFS();
   6:	e8 ef 02 00 00       	call   2fa <recoverFS>
	exit();
   b:	e8 22 02 00 00       	call   232 <exit>

00000010 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	8b 45 08             	mov    0x8(%ebp),%eax
  16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  19:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  1a:	89 c2                	mov    %eax,%edx
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  20:	83 c1 01             	add    $0x1,%ecx
  23:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  27:	83 c2 01             	add    $0x1,%edx
  2a:	84 db                	test   %bl,%bl
  2c:	88 5a ff             	mov    %bl,-0x1(%edx)
  2f:	75 ef                	jne    20 <strcpy+0x10>
    ;
  return os;
}
  31:	5b                   	pop    %ebx
  32:	5d                   	pop    %ebp
  33:	c3                   	ret    
  34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	8b 55 08             	mov    0x8(%ebp),%edx
  46:	53                   	push   %ebx
  47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  4a:	0f b6 02             	movzbl (%edx),%eax
  4d:	84 c0                	test   %al,%al
  4f:	74 2d                	je     7e <strcmp+0x3e>
  51:	0f b6 19             	movzbl (%ecx),%ebx
  54:	38 d8                	cmp    %bl,%al
  56:	74 0e                	je     66 <strcmp+0x26>
  58:	eb 2b                	jmp    85 <strcmp+0x45>
  5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  60:	38 c8                	cmp    %cl,%al
  62:	75 15                	jne    79 <strcmp+0x39>
    p++, q++;
  64:	89 d9                	mov    %ebx,%ecx
  66:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  69:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  6c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  6f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
  73:	84 c0                	test   %al,%al
  75:	75 e9                	jne    60 <strcmp+0x20>
  77:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
  79:	29 c8                	sub    %ecx,%eax
}
  7b:	5b                   	pop    %ebx
  7c:	5d                   	pop    %ebp
  7d:	c3                   	ret    
  7e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  81:	31 c0                	xor    %eax,%eax
  83:	eb f4                	jmp    79 <strcmp+0x39>
  85:	0f b6 cb             	movzbl %bl,%ecx
  88:	eb ef                	jmp    79 <strcmp+0x39>
  8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000090 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  96:	80 39 00             	cmpb   $0x0,(%ecx)
  99:	74 12                	je     ad <strlen+0x1d>
  9b:	31 d2                	xor    %edx,%edx
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  a0:	83 c2 01             	add    $0x1,%edx
  a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  a7:	89 d0                	mov    %edx,%eax
  a9:	75 f5                	jne    a0 <strlen+0x10>
    ;
  return n;
}
  ab:	5d                   	pop    %ebp
  ac:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
  ad:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
  af:	5d                   	pop    %ebp
  b0:	c3                   	ret    
  b1:	eb 0d                	jmp    c0 <memset>
  b3:	90                   	nop
  b4:	90                   	nop
  b5:	90                   	nop
  b6:	90                   	nop
  b7:	90                   	nop
  b8:	90                   	nop
  b9:	90                   	nop
  ba:	90                   	nop
  bb:	90                   	nop
  bc:	90                   	nop
  bd:	90                   	nop
  be:	90                   	nop
  bf:	90                   	nop

000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
  c6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	89 d7                	mov    %edx,%edi
  cf:	fc                   	cld    
  d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d2:	89 d0                	mov    %edx,%eax
  d4:	5f                   	pop    %edi
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    
  d7:	89 f6                	mov    %esi,%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <strchr>:

char*
strchr(const char *s, char c)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	53                   	push   %ebx
  e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
  ea:	0f b6 18             	movzbl (%eax),%ebx
  ed:	84 db                	test   %bl,%bl
  ef:	74 1d                	je     10e <strchr+0x2e>
    if(*s == c)
  f1:	38 d3                	cmp    %dl,%bl
  f3:	89 d1                	mov    %edx,%ecx
  f5:	75 0d                	jne    104 <strchr+0x24>
  f7:	eb 17                	jmp    110 <strchr+0x30>
  f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 100:	38 ca                	cmp    %cl,%dl
 102:	74 0c                	je     110 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 104:	83 c0 01             	add    $0x1,%eax
 107:	0f b6 10             	movzbl (%eax),%edx
 10a:	84 d2                	test   %dl,%dl
 10c:	75 f2                	jne    100 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 10e:	31 c0                	xor    %eax,%eax
}
 110:	5b                   	pop    %ebx
 111:	5d                   	pop    %ebp
 112:	c3                   	ret    
 113:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000120 <gets>:

char*
gets(char *buf, int max)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 125:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 127:	53                   	push   %ebx
 128:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 12b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12e:	eb 31                	jmp    161 <gets+0x41>
    cc = read(0, &c, 1);
 130:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 137:	00 
 138:	89 7c 24 04          	mov    %edi,0x4(%esp)
 13c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 143:	e8 02 01 00 00       	call   24a <read>
    if(cc < 1)
 148:	85 c0                	test   %eax,%eax
 14a:	7e 1d                	jle    169 <gets+0x49>
      break;
    buf[i++] = c;
 14c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 150:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 152:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 155:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 157:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 15b:	74 0c                	je     169 <gets+0x49>
 15d:	3c 0a                	cmp    $0xa,%al
 15f:	74 08                	je     169 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 161:	8d 5e 01             	lea    0x1(%esi),%ebx
 164:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 167:	7c c7                	jl     130 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 170:	83 c4 2c             	add    $0x2c,%esp
 173:	5b                   	pop    %ebx
 174:	5e                   	pop    %esi
 175:	5f                   	pop    %edi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    
 178:	90                   	nop
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000180 <stat>:

int
stat(char *n, struct stat *st)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	56                   	push   %esi
 184:	53                   	push   %ebx
 185:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 192:	00 
 193:	89 04 24             	mov    %eax,(%esp)
 196:	e8 d7 00 00 00       	call   272 <open>
  if(fd < 0)
 19b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 19f:	78 27                	js     1c8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 1a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a4:	89 1c 24             	mov    %ebx,(%esp)
 1a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ab:	e8 da 00 00 00       	call   28a <fstat>
  close(fd);
 1b0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 1b3:	89 c6                	mov    %eax,%esi
  close(fd);
 1b5:	e8 a0 00 00 00       	call   25a <close>
  return r;
 1ba:	89 f0                	mov    %esi,%eax
}
 1bc:	83 c4 10             	add    $0x10,%esp
 1bf:	5b                   	pop    %ebx
 1c0:	5e                   	pop    %esi
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
 1c3:	90                   	nop
 1c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 1c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1cd:	eb ed                	jmp    1bc <stat+0x3c>
 1cf:	90                   	nop

000001d0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d7:	0f be 11             	movsbl (%ecx),%edx
 1da:	8d 42 d0             	lea    -0x30(%edx),%eax
 1dd:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 1df:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 1e4:	77 17                	ja     1fd <atoi+0x2d>
 1e6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 1e8:	83 c1 01             	add    $0x1,%ecx
 1eb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1ee:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f2:	0f be 11             	movsbl (%ecx),%edx
 1f5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1f8:	80 fb 09             	cmp    $0x9,%bl
 1fb:	76 eb                	jbe    1e8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 1fd:	5b                   	pop    %ebx
 1fe:	5d                   	pop    %ebp
 1ff:	c3                   	ret    

00000200 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 200:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 201:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 203:	89 e5                	mov    %esp,%ebp
 205:	56                   	push   %esi
 206:	8b 45 08             	mov    0x8(%ebp),%eax
 209:	53                   	push   %ebx
 20a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 20d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 210:	85 db                	test   %ebx,%ebx
 212:	7e 12                	jle    226 <memmove+0x26>
 214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 218:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 21c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 21f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 222:	39 da                	cmp    %ebx,%edx
 224:	75 f2                	jne    218 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 226:	5b                   	pop    %ebx
 227:	5e                   	pop    %esi
 228:	5d                   	pop    %ebp
 229:	c3                   	ret    

0000022a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 22a:	b8 01 00 00 00       	mov    $0x1,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <exit>:
SYSCALL(exit)
 232:	b8 02 00 00 00       	mov    $0x2,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <wait>:
SYSCALL(wait)
 23a:	b8 03 00 00 00       	mov    $0x3,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <pipe>:
SYSCALL(pipe)
 242:	b8 04 00 00 00       	mov    $0x4,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <read>:
SYSCALL(read)
 24a:	b8 05 00 00 00       	mov    $0x5,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <write>:
SYSCALL(write)
 252:	b8 10 00 00 00       	mov    $0x10,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <close>:
SYSCALL(close)
 25a:	b8 15 00 00 00       	mov    $0x15,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <kill>:
SYSCALL(kill)
 262:	b8 06 00 00 00       	mov    $0x6,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <exec>:
SYSCALL(exec)
 26a:	b8 07 00 00 00       	mov    $0x7,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <open>:
SYSCALL(open)
 272:	b8 0f 00 00 00       	mov    $0xf,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <mknod>:
SYSCALL(mknod)
 27a:	b8 11 00 00 00       	mov    $0x11,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <unlink>:
SYSCALL(unlink)
 282:	b8 12 00 00 00       	mov    $0x12,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <fstat>:
SYSCALL(fstat)
 28a:	b8 08 00 00 00       	mov    $0x8,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <link>:
SYSCALL(link)
 292:	b8 13 00 00 00       	mov    $0x13,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <mkdir>:
SYSCALL(mkdir)
 29a:	b8 14 00 00 00       	mov    $0x14,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <chdir>:
SYSCALL(chdir)
 2a2:	b8 09 00 00 00       	mov    $0x9,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <dup>:
SYSCALL(dup)
 2aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <getpid>:
SYSCALL(getpid)
 2b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <sbrk>:
SYSCALL(sbrk)
 2ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <sleep>:
SYSCALL(sleep)
 2c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <uptime>:
SYSCALL(uptime)
 2ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <myMemory>:
SYSCALL(myMemory)
 2d2:	b8 16 00 00 00       	mov    $0x16,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <inodeTBWalker>:
SYSCALL(inodeTBWalker)
 2da:	b8 17 00 00 00       	mov    $0x17,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <deleteIData>:
SYSCALL(deleteIData)
 2e2:	b8 18 00 00 00       	mov    $0x18,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <directoryWalker>:
SYSCALL(directoryWalker)
 2ea:	b8 19 00 00 00       	mov    $0x19,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <compareWalkers>:
SYSCALL(compareWalkers)
 2f2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <recoverFS>:
SYSCALL(recoverFS)
 2fa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    
 302:	66 90                	xchg   %ax,%ax
 304:	66 90                	xchg   %ax,%ax
 306:	66 90                	xchg   %ax,%ax
 308:	66 90                	xchg   %ax,%ax
 30a:	66 90                	xchg   %ax,%ax
 30c:	66 90                	xchg   %ax,%ax
 30e:	66 90                	xchg   %ax,%ax

00000310 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
 315:	89 c6                	mov    %eax,%esi
 317:	53                   	push   %ebx
 318:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 31b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 31e:	85 db                	test   %ebx,%ebx
 320:	74 09                	je     32b <printint+0x1b>
 322:	89 d0                	mov    %edx,%eax
 324:	c1 e8 1f             	shr    $0x1f,%eax
 327:	84 c0                	test   %al,%al
 329:	75 75                	jne    3a0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 32b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 32d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 334:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 337:	31 ff                	xor    %edi,%edi
 339:	89 ce                	mov    %ecx,%esi
 33b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 33e:	eb 02                	jmp    342 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 340:	89 cf                	mov    %ecx,%edi
 342:	31 d2                	xor    %edx,%edx
 344:	f7 f6                	div    %esi
 346:	8d 4f 01             	lea    0x1(%edi),%ecx
 349:	0f b6 92 1d 07 00 00 	movzbl 0x71d(%edx),%edx
  }while((x /= base) != 0);
 350:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 352:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 355:	75 e9                	jne    340 <printint+0x30>
  if(neg)
 357:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 35a:	89 c8                	mov    %ecx,%eax
 35c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 35f:	85 d2                	test   %edx,%edx
 361:	74 08                	je     36b <printint+0x5b>
    buf[i++] = '-';
 363:	8d 4f 02             	lea    0x2(%edi),%ecx
 366:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 36b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 36e:	66 90                	xchg   %ax,%ax
 370:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 375:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 378:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 37f:	00 
 380:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 384:	89 34 24             	mov    %esi,(%esp)
 387:	88 45 d7             	mov    %al,-0x29(%ebp)
 38a:	e8 c3 fe ff ff       	call   252 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 38f:	83 ff ff             	cmp    $0xffffffff,%edi
 392:	75 dc                	jne    370 <printint+0x60>
    putc(fd, buf[i]);
}
 394:	83 c4 4c             	add    $0x4c,%esp
 397:	5b                   	pop    %ebx
 398:	5e                   	pop    %esi
 399:	5f                   	pop    %edi
 39a:	5d                   	pop    %ebp
 39b:	c3                   	ret    
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3a0:	89 d0                	mov    %edx,%eax
 3a2:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 3a4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 3ab:	eb 87                	jmp    334 <printint+0x24>
 3ad:	8d 76 00             	lea    0x0(%esi),%esi

000003b0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3b4:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3b6:	56                   	push   %esi
 3b7:	53                   	push   %ebx
 3b8:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3be:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3c1:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 3c7:	0f b6 13             	movzbl (%ebx),%edx
 3ca:	83 c3 01             	add    $0x1,%ebx
 3cd:	84 d2                	test   %dl,%dl
 3cf:	75 39                	jne    40a <printf+0x5a>
 3d1:	e9 c2 00 00 00       	jmp    498 <printf+0xe8>
 3d6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3d8:	83 fa 25             	cmp    $0x25,%edx
 3db:	0f 84 bf 00 00 00    	je     4a0 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3e1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3e4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3eb:	00 
 3ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3f3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3f6:	e8 57 fe ff ff       	call   252 <write>
 3fb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3fe:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 402:	84 d2                	test   %dl,%dl
 404:	0f 84 8e 00 00 00    	je     498 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 40a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 40c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 40f:	74 c7                	je     3d8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 411:	83 ff 25             	cmp    $0x25,%edi
 414:	75 e5                	jne    3fb <printf+0x4b>
      if(c == 'd'){
 416:	83 fa 64             	cmp    $0x64,%edx
 419:	0f 84 31 01 00 00    	je     550 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 41f:	25 f7 00 00 00       	and    $0xf7,%eax
 424:	83 f8 70             	cmp    $0x70,%eax
 427:	0f 84 83 00 00 00    	je     4b0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 42d:	83 fa 73             	cmp    $0x73,%edx
 430:	0f 84 a2 00 00 00    	je     4d8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 436:	83 fa 63             	cmp    $0x63,%edx
 439:	0f 84 35 01 00 00    	je     574 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 43f:	83 fa 25             	cmp    $0x25,%edx
 442:	0f 84 e0 00 00 00    	je     528 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 448:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 44b:	83 c3 01             	add    $0x1,%ebx
 44e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 455:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 456:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 458:	89 44 24 04          	mov    %eax,0x4(%esp)
 45c:	89 34 24             	mov    %esi,(%esp)
 45f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 462:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 466:	e8 e7 fd ff ff       	call   252 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 46b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 46e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 471:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 478:	00 
 479:	89 44 24 04          	mov    %eax,0x4(%esp)
 47d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 480:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 483:	e8 ca fd ff ff       	call   252 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 488:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 48c:	84 d2                	test   %dl,%dl
 48e:	0f 85 76 ff ff ff    	jne    40a <printf+0x5a>
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 498:	83 c4 3c             	add    $0x3c,%esp
 49b:	5b                   	pop    %ebx
 49c:	5e                   	pop    %esi
 49d:	5f                   	pop    %edi
 49e:	5d                   	pop    %ebp
 49f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4a0:	bf 25 00 00 00       	mov    $0x25,%edi
 4a5:	e9 51 ff ff ff       	jmp    3fb <printf+0x4b>
 4aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4b3:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4c1:	8b 10                	mov    (%eax),%edx
 4c3:	89 f0                	mov    %esi,%eax
 4c5:	e8 46 fe ff ff       	call   310 <printint>
        ap++;
 4ca:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4ce:	e9 28 ff ff ff       	jmp    3fb <printf+0x4b>
 4d3:	90                   	nop
 4d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 4d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 4db:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 4df:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 4e1:	b8 16 07 00 00       	mov    $0x716,%eax
 4e6:	85 ff                	test   %edi,%edi
 4e8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 4eb:	0f b6 07             	movzbl (%edi),%eax
 4ee:	84 c0                	test   %al,%al
 4f0:	74 2a                	je     51c <printf+0x16c>
 4f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4f8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4fb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 4fe:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 501:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 508:	00 
 509:	89 44 24 04          	mov    %eax,0x4(%esp)
 50d:	89 34 24             	mov    %esi,(%esp)
 510:	e8 3d fd ff ff       	call   252 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 515:	0f b6 07             	movzbl (%edi),%eax
 518:	84 c0                	test   %al,%al
 51a:	75 dc                	jne    4f8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 51c:	31 ff                	xor    %edi,%edi
 51e:	e9 d8 fe ff ff       	jmp    3fb <printf+0x4b>
 523:	90                   	nop
 524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 528:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 52b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 52d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 534:	00 
 535:	89 44 24 04          	mov    %eax,0x4(%esp)
 539:	89 34 24             	mov    %esi,(%esp)
 53c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 540:	e8 0d fd ff ff       	call   252 <write>
 545:	e9 b1 fe ff ff       	jmp    3fb <printf+0x4b>
 54a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 550:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 553:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 558:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 55b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 562:	8b 10                	mov    (%eax),%edx
 564:	89 f0                	mov    %esi,%eax
 566:	e8 a5 fd ff ff       	call   310 <printint>
        ap++;
 56b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 56f:	e9 87 fe ff ff       	jmp    3fb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 574:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 577:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 579:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 57b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 582:	00 
 583:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 586:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 589:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 58c:	89 44 24 04          	mov    %eax,0x4(%esp)
 590:	e8 bd fc ff ff       	call   252 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 595:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 599:	e9 5d fe ff ff       	jmp    3fb <printf+0x4b>
 59e:	66 90                	xchg   %ax,%ax

000005a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a1:	a1 94 09 00 00       	mov    0x994,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a6:	89 e5                	mov    %esp,%ebp
 5a8:	57                   	push   %edi
 5a9:	56                   	push   %esi
 5aa:	53                   	push   %ebx
 5ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ae:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b3:	39 d0                	cmp    %edx,%eax
 5b5:	72 11                	jb     5c8 <free+0x28>
 5b7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b8:	39 c8                	cmp    %ecx,%eax
 5ba:	72 04                	jb     5c0 <free+0x20>
 5bc:	39 ca                	cmp    %ecx,%edx
 5be:	72 10                	jb     5d0 <free+0x30>
 5c0:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c4:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c6:	73 f0                	jae    5b8 <free+0x18>
 5c8:	39 ca                	cmp    %ecx,%edx
 5ca:	72 04                	jb     5d0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5cc:	39 c8                	cmp    %ecx,%eax
 5ce:	72 f0                	jb     5c0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5d3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 5d6:	39 cf                	cmp    %ecx,%edi
 5d8:	74 1e                	je     5f8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5da:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5dd:	8b 48 04             	mov    0x4(%eax),%ecx
 5e0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5e3:	39 f2                	cmp    %esi,%edx
 5e5:	74 28                	je     60f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5e7:	89 10                	mov    %edx,(%eax)
  freep = p;
 5e9:	a3 94 09 00 00       	mov    %eax,0x994
}
 5ee:	5b                   	pop    %ebx
 5ef:	5e                   	pop    %esi
 5f0:	5f                   	pop    %edi
 5f1:	5d                   	pop    %ebp
 5f2:	c3                   	ret    
 5f3:	90                   	nop
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5f8:	03 71 04             	add    0x4(%ecx),%esi
 5fb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5fe:	8b 08                	mov    (%eax),%ecx
 600:	8b 09                	mov    (%ecx),%ecx
 602:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 605:	8b 48 04             	mov    0x4(%eax),%ecx
 608:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 60b:	39 f2                	cmp    %esi,%edx
 60d:	75 d8                	jne    5e7 <free+0x47>
    p->s.size += bp->s.size;
 60f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 612:	a3 94 09 00 00       	mov    %eax,0x994
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 617:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 61a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 61d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 61f:	5b                   	pop    %ebx
 620:	5e                   	pop    %esi
 621:	5f                   	pop    %edi
 622:	5d                   	pop    %ebp
 623:	c3                   	ret    
 624:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 62a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000630 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
 636:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 639:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 63c:	8b 1d 94 09 00 00    	mov    0x994,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 642:	8d 48 07             	lea    0x7(%eax),%ecx
 645:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 648:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 64a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 64d:	0f 84 9b 00 00 00    	je     6ee <malloc+0xbe>
 653:	8b 13                	mov    (%ebx),%edx
 655:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 658:	39 fe                	cmp    %edi,%esi
 65a:	76 64                	jbe    6c0 <malloc+0x90>
 65c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 663:	bb 00 80 00 00       	mov    $0x8000,%ebx
 668:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 66b:	eb 0e                	jmp    67b <malloc+0x4b>
 66d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 670:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 672:	8b 78 04             	mov    0x4(%eax),%edi
 675:	39 fe                	cmp    %edi,%esi
 677:	76 4f                	jbe    6c8 <malloc+0x98>
 679:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 67b:	3b 15 94 09 00 00    	cmp    0x994,%edx
 681:	75 ed                	jne    670 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 686:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 68c:	bf 00 10 00 00       	mov    $0x1000,%edi
 691:	0f 43 fe             	cmovae %esi,%edi
 694:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 697:	89 04 24             	mov    %eax,(%esp)
 69a:	e8 1b fc ff ff       	call   2ba <sbrk>
  if(p == (char*)-1)
 69f:	83 f8 ff             	cmp    $0xffffffff,%eax
 6a2:	74 18                	je     6bc <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6a4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 6a7:	83 c0 08             	add    $0x8,%eax
 6aa:	89 04 24             	mov    %eax,(%esp)
 6ad:	e8 ee fe ff ff       	call   5a0 <free>
  return freep;
 6b2:	8b 15 94 09 00 00    	mov    0x994,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 6b8:	85 d2                	test   %edx,%edx
 6ba:	75 b4                	jne    670 <malloc+0x40>
        return 0;
 6bc:	31 c0                	xor    %eax,%eax
 6be:	eb 20                	jmp    6e0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6c0:	89 d0                	mov    %edx,%eax
 6c2:	89 da                	mov    %ebx,%edx
 6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 6c8:	39 fe                	cmp    %edi,%esi
 6ca:	74 1c                	je     6e8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6cc:	29 f7                	sub    %esi,%edi
 6ce:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 6d1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 6d4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 6d7:	89 15 94 09 00 00    	mov    %edx,0x994
      return (void*)(p + 1);
 6dd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6e0:	83 c4 1c             	add    $0x1c,%esp
 6e3:	5b                   	pop    %ebx
 6e4:	5e                   	pop    %esi
 6e5:	5f                   	pop    %edi
 6e6:	5d                   	pop    %ebp
 6e7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 6e8:	8b 08                	mov    (%eax),%ecx
 6ea:	89 0a                	mov    %ecx,(%edx)
 6ec:	eb e9                	jmp    6d7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6ee:	c7 05 94 09 00 00 98 	movl   $0x998,0x994
 6f5:	09 00 00 
    base.s.size = 0;
 6f8:	ba 98 09 00 00       	mov    $0x998,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6fd:	c7 05 98 09 00 00 98 	movl   $0x998,0x998
 704:	09 00 00 
    base.s.size = 0;
 707:	c7 05 9c 09 00 00 00 	movl   $0x0,0x99c
 70e:	00 00 00 
 711:	e9 46 ff ff ff       	jmp    65c <malloc+0x2c>
