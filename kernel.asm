
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 2e 10 80       	mov    $0x80102e10,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 00 6e 10 	movl   $0x80106e00,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 10 40 00 00       	call   80104070 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 07 6e 10 	movl   $0x80106e07,0x4(%esp)
8010009b:	80 
8010009c:	e8 bf 3e 00 00       	call   80103f60 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 75 40 00 00       	call   80104160 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 ea 40 00 00       	call   80104250 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 2f 3e 00 00       	call   80103fa0 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 c2 1f 00 00       	call   80102140 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 0e 6e 10 80 	movl   $0x80106e0e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 8b 3e 00 00       	call   80104040 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 77 1f 00 00       	jmp    80102140 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 1f 6e 10 80 	movl   $0x80106e1f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 4a 3e 00 00       	call   80104040 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 fe 3d 00 00       	call   80104000 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 52 3f 00 00       	call   80104160 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 fb 3f 00 00       	jmp    80104250 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 26 6e 10 80 	movl   $0x80106e26,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 29 15 00 00       	call   801017b0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 cd 3e 00 00       	call   80104160 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 13 34 00 00       	call   801036c0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 58 39 00 00       	call   80103c20 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 3a 3f 00 00       	call   80104250 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 b2 13 00 00       	call   801016d0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 1c 3f 00 00       	call   80104250 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 94 13 00 00       	call   801016d0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 05 24 00 00       	call   80102780 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 2d 6e 10 80 	movl   $0x80106e2d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 e3 77 10 80 	movl   $0x801077e3,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 dc 3c 00 00       	call   80104090 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 41 6e 10 80 	movl   $0x80106e41,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 62 55 00 00       	call   80105970 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 b2 54 00 00       	call   80105970 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 a6 54 00 00       	call   80105970 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 9a 54 00 00       	call   80105970 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 3f 3e 00 00       	call   80104340 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 82 3d 00 00       	call   801042a0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 45 6e 10 80 	movl   $0x80106e45,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 70 6e 10 80 	movzbl -0x7fef9190(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 a9 11 00 00       	call   801017b0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 4d 3b 00 00       	call   80104160 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 15 3c 00 00       	call   80104250 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 8a 10 00 00       	call   801016d0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 58 3b 00 00       	call   80104250 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 58 6e 10 80       	mov    $0x80106e58,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 c4 39 00 00       	call   80104160 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 5f 6e 10 80 	movl   $0x80106e5f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 96 39 00 00       	call   80104160 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 24 3a 00 00       	call   80104250 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 f9 34 00 00       	call   80103db0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 64 35 00 00       	jmp    80103e90 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 68 6e 10 	movl   $0x80106e68,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 06 37 00 00       	call   80104070 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100997:	e8 34 19 00 00       	call   801022d0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 0f 2d 00 00       	call   801036c0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 74 21 00 00       	call   80102b30 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 59 15 00 00       	call   80101f20 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 f7 0c 00 00       	call   801016d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 85 0f 00 00       	call   80101980 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 28 0f 00 00       	call   80101930 <iunlockput>
    end_op();
80100a08:	e8 93 21 00 00       	call   80102ba0 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 2f 61 00 00       	call   80106b60 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 ed 0e 00 00       	call   80101980 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 f9 5e 00 00       	call   801069d0 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 f8 5d 00 00       	call   80106910 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 b2 5f 00 00       	call   80106ae0 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 f5 0d 00 00       	call   80101930 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 5b 20 00 00       	call   80102ba0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 5f 5e 00 00       	call   801069d0 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 57 5f 00 00       	call   80106ae0 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100b93:	e8 08 20 00 00       	call   80102ba0 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 81 6e 10 80 	movl   $0x80106e81,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 43 60 00 00       	call   80106c10 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 59 01 00 00    	je     80100d33 <exec+0x393>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 ba 38 00 00       	call   801044c0 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 a9 38 00 00       	call   801044c0 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 3a 61 00 00       	call   80106d70 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 c7 60 00 00       	call   80106d70 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 8a 37 00 00       	call   80104480 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 5c 5a 00 00       	call   80106780 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 b4 5d 00 00       	call   80106ae0 <freevm>
  return 0;
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d33:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d39:	31 d2                	xor    %edx,%edx
80100d3b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d41:	e9 18 ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d46:	66 90                	xchg   %ax,%ax
80100d48:	66 90                	xchg   %ax,%ax
80100d4a:	66 90                	xchg   %ax,%ax
80100d4c:	66 90                	xchg   %ax,%ax
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	c7 44 24 04 8d 6e 10 	movl   $0x80106e8d,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 06 33 00 00       	call   80104070 <initlock>
}
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d83:	e8 d8 33 00 00       	call   80104160 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 9b 34 00 00       	call   80104250 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100db5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100db8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc7:	e8 84 34 00 00       	call   80104250 <release>
  return 0;
}
80100dcc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dcf:	31 c0                	xor    %eax,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df1:	e8 6a 33 00 00       	call   80104160 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e0a:	e8 41 34 00 00       	call   80104250 <release>
  return f;
}
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e17:	c7 04 24 94 6e 10 80 	movl   $0x80106e94,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e43:	e8 18 33 00 00       	call   80104160 <acquire>
  if(f->ref < 1)
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
    release(&ftable.lock);
80100e5d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6b:	e9 e0 33 00 00       	jmp    80104250 <release>
    return;
  }
  ff = *f;
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e8f:	e8 bc 33 00 00       	call   80104250 <release>

  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 c8 23 00 00       	call   80103280 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ec0:	e8 6b 1c 00 00       	call   80102b30 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 20 09 00 00       	call   801017f0 <iput>
    end_op();
  }
}
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ed7:	e9 c4 1c 00 00       	jmp    80102ba0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100edc:	c7 04 24 9c 6e 10 80 	movl   $0x80106e9c,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 c6 07 00 00       	call   801016d0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 34 0a 00 00       	call   80101950 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 89 08 00 00       	call   801017b0 <iunlock>
    return 0;
  }
  return -1;
}
80100f27:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f2a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
    ilock(f->ip);
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 61 07 00 00       	call   801016d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 f7 09 00 00       	call   80101980 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 13 08 00 00       	call   801017b0 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb5:	e9 46 24 00 00       	jmp    80103400 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fc7:	c7 04 24 a6 6e 10 80 	movl   $0x80106ea6,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 77 07 00 00       	call   801017b0 <iunlock>
      end_op();
80101039:	e8 62 1b 00 00       	call   80102ba0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101049:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 06 00 00       	mov    $0x600,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101063:	e8 c8 1a 00 00       	call   80102b30 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 5d 06 00 00       	call   801016d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 ee 09 00 00       	call   80101a80 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 0c 07 00 00       	call   801017b0 <iunlock>
      end_op();
801010a4:	e8 f7 1a 00 00       	call   80102ba0 <end_op>

      if(r < 0)
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 2f 22 00 00       	jmp    80103310 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	c7 04 24 af 6e 10 80 	movl   $0x80106eaf,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ed:	c7 04 24 b5 6e 10 80 	movl   $0x80106eb5,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 2c             	sub    $0x2c,%esp
80101109:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010110c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101111:	85 c0                	test   %eax,%eax
80101113:	0f 84 8c 00 00 00    	je     801011a5 <balloc+0xa5>
80101119:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101120:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101123:	89 f0                	mov    %esi,%eax
80101125:	c1 f8 0c             	sar    $0xc,%eax
80101128:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010112e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101132:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101135:	89 04 24             	mov    %eax,(%esp)
80101138:	e8 93 ef ff ff       	call   801000d0 <bread>
8010113d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101140:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101145:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101148:	31 c0                	xor    %eax,%eax
8010114a:	eb 33                	jmp    8010117f <balloc+0x7f>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101150:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101153:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101155:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	bf 01 00 00 00       	mov    $0x1,%edi
80101162:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101164:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101169:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116b:	0f b6 fb             	movzbl %bl,%edi
8010116e:	85 cf                	test   %ecx,%edi
80101170:	74 46                	je     801011b8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101172:	83 c0 01             	add    $0x1,%eax
80101175:	83 c6 01             	add    $0x1,%esi
80101178:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010117d:	74 05                	je     80101184 <balloc+0x84>
8010117f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101182:	72 cc                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101187:	89 04 24             	mov    %eax,(%esp)
8010118a:	e8 51 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010119f:	0f 82 7b ff ff ff    	jb     80101120 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011a5:	c7 04 24 bf 6e 10 80 	movl   $0x80106ebf,(%esp)
801011ac:	e8 af f1 ff ff       	call   80100360 <panic>
801011b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	09 d9                	or     %ebx,%ecx
801011ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011bd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011c1:	89 1c 24             	mov    %ebx,(%esp)
801011c4:	e8 07 1b 00 00       	call   80102cd0 <log_write>
        brelse(bp);
801011c9:	89 1c 24             	mov    %ebx,(%esp)
801011cc:	e8 0f f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011d4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011d8:	89 04 24             	mov    %eax,(%esp)
801011db:	e8 f0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011e7:	00 
801011e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011ef:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011f5:	89 04 24             	mov    %eax,(%esp)
801011f8:	e8 a3 30 00 00       	call   801042a0 <memset>
  log_write(bp);
801011fd:	89 1c 24             	mov    %ebx,(%esp)
80101200:	e8 cb 1a 00 00       	call   80102cd0 <log_write>
  brelse(bp);
80101205:	89 1c 24             	mov    %ebx,(%esp)
80101208:	e8 d3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010120d:	83 c4 2c             	add    $0x2c,%esp
80101210:	89 f0                	mov    %esi,%eax
80101212:	5b                   	pop    %ebx
80101213:	5e                   	pop    %esi
80101214:	5f                   	pop    %edi
80101215:	5d                   	pop    %ebp
80101216:	c3                   	ret    
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	89 c7                	mov    %eax,%edi
80101226:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101227:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101229:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010122f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101232:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010123c:	e8 1f 2f 00 00       	call   80104160 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101244:	eb 14                	jmp    8010125a <iget+0x3a>
80101246:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101248:	85 f6                	test   %esi,%esi
8010124a:	74 3c                	je     80101288 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101252:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101258:	74 46                	je     801012a0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010125d:	85 c9                	test   %ecx,%ecx
8010125f:	7e e7                	jle    80101248 <iget+0x28>
80101261:	39 3b                	cmp    %edi,(%ebx)
80101263:	75 e3                	jne    80101248 <iget+0x28>
80101265:	39 53 04             	cmp    %edx,0x4(%ebx)
80101268:	75 de                	jne    80101248 <iget+0x28>
      ip->ref++;
8010126a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010126d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101276:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101279:	e8 d2 2f 00 00       	call   80104250 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127e:	83 c4 1c             	add    $0x1c,%esp
80101281:	89 f0                	mov    %esi,%eax
80101283:	5b                   	pop    %ebx
80101284:	5e                   	pop    %esi
80101285:	5f                   	pop    %edi
80101286:	5d                   	pop    %ebp
80101287:	c3                   	ret    
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101299:	75 bf                	jne    8010125a <iget+0x3a>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 29                	je     801012cd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012a9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012b7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012be:	e8 8d 2f 00 00       	call   80104250 <release>

  return ip;
}
801012c3:	83 c4 1c             	add    $0x1c,%esp
801012c6:	89 f0                	mov    %esi,%eax
801012c8:	5b                   	pop    %ebx
801012c9:	5e                   	pop    %esi
801012ca:	5f                   	pop    %edi
801012cb:	5d                   	pop    %ebp
801012cc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012cd:	c7 04 24 d5 6e 10 80 	movl   $0x80106ed5,(%esp)
801012d4:	e8 87 f0 ff ff       	call   80100360 <panic>
801012d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c3                	mov    %eax,%ebx
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 66                	je     80101360 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	83 c4 1c             	add    $0x1c,%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
8010130b:	83 fe 7f             	cmp    $0x7f,%esi
8010130e:	77 77                	ja     80101387 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101310:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101316:	85 c0                	test   %eax,%eax
80101318:	74 5e                	je     80101378 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131e:	8b 03                	mov    (%ebx),%eax
80101320:	89 04 24             	mov    %eax,(%esp)
80101323:	e8 a8 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101328:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010132c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010132e:	8b 32                	mov    (%edx),%esi
80101330:	85 f6                	test   %esi,%esi
80101332:	75 19                	jne    8010134d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101334:	8b 03                	mov    (%ebx),%eax
80101336:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101339:	e8 c2 fd ff ff       	call   80101100 <balloc>
8010133e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101341:	89 02                	mov    %eax,(%edx)
80101343:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101345:	89 3c 24             	mov    %edi,(%esp)
80101348:	e8 83 19 00 00       	call   80102cd0 <log_write>
    }
    brelse(bp);
8010134d:	89 3c 24             	mov    %edi,(%esp)
80101350:	e8 8b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101355:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101358:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	5b                   	pop    %ebx
8010135b:	5e                   	pop    %esi
8010135c:	5f                   	pop    %edi
8010135d:	5d                   	pop    %ebp
8010135e:	c3                   	ret    
8010135f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101360:	8b 03                	mov    (%ebx),%eax
80101362:	e8 99 fd ff ff       	call   80101100 <balloc>
80101367:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010136a:	83 c4 1c             	add    $0x1c,%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101378:	8b 03                	mov    (%ebx),%eax
8010137a:	e8 81 fd ff ff       	call   80101100 <balloc>
8010137f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101385:	eb 93                	jmp    8010131a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101387:	c7 04 24 e5 6e 10 80 	movl   $0x80106ee5,(%esp)
8010138e:	e8 cd ef ff ff       	call   80100360 <panic>
80101393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <readsb>:
struct superblock sb;

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	56                   	push   %esi
801013a4:	53                   	push   %ebx
801013a5:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013a8:	8b 45 08             	mov    0x8(%ebp),%eax
801013ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013b2:	00 
struct superblock sb;

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b6:	89 04 24             	mov    %eax,(%esp)
801013b9:	e8 12 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013be:	89 34 24             	mov    %esi,(%esp)
801013c1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013c8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013c9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013cb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801013d2:	e8 69 2f 00 00       	call   80104340 <memmove>
  brelse(bp);
801013d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013da:	83 c4 10             	add    $0x10,%esp
801013dd:	5b                   	pop    %ebx
801013de:	5e                   	pop    %esi
801013df:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e0:	e9 fb ed ff ff       	jmp    801001e0 <brelse>
801013e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	89 d7                	mov    %edx,%edi
801013f6:	56                   	push   %esi
801013f7:	53                   	push   %ebx
801013f8:	89 c3                	mov    %eax,%ebx
801013fa:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013fd:	89 04 24             	mov    %eax,(%esp)
80101400:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101407:	80 
80101408:	e8 93 ff ff ff       	call   801013a0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010140d:	89 fa                	mov    %edi,%edx
8010140f:	c1 ea 0c             	shr    $0xc,%edx
80101412:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101418:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101420:	89 54 24 04          	mov    %edx,0x4(%esp)
80101424:	e8 a7 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101429:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010142b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101431:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101433:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101436:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101439:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010143b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010143d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101442:	0f b6 c8             	movzbl %al,%ecx
80101445:	85 d9                	test   %ebx,%ecx
80101447:	74 20                	je     80101469 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101449:	f7 d3                	not    %ebx
8010144b:	21 c3                	and    %eax,%ebx
8010144d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 77 18 00 00       	call   80102cd0 <log_write>
  brelse(bp);
80101459:	89 34 24             	mov    %esi,(%esp)
8010145c:	e8 7f ed ff ff       	call   801001e0 <brelse>
}
80101461:	83 c4 1c             	add    $0x1c,%esp
80101464:	5b                   	pop    %ebx
80101465:	5e                   	pop    %esi
80101466:	5f                   	pop    %edi
80101467:	5d                   	pop    %ebp
80101468:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101469:	c7 04 24 f8 6e 10 80 	movl   $0x80106ef8,(%esp)
80101470:	e8 eb ee ff ff       	call   80100360 <panic>
80101475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010148c:	c7 44 24 04 0b 6f 10 	movl   $0x80106f0b,0x4(%esp)
80101493:	80 
80101494:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010149b:	e8 d0 2b 00 00       	call   80104070 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	89 1c 24             	mov    %ebx,(%esp)
801014a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a9:	c7 44 24 04 12 6f 10 	movl   $0x80106f12,0x4(%esp)
801014b0:	80 
801014b1:	e8 aa 2a 00 00       	call   80103f60 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014b6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bc:	75 e2                	jne    801014a0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014be:	8b 45 08             	mov    0x8(%ebp),%eax
801014c1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014c8:	80 
801014c9:	89 04 24             	mov    %eax,(%esp)
801014cc:	e8 cf fe ff ff       	call   801013a0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014d1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014d6:	c7 04 24 78 6f 10 80 	movl   $0x80106f78,(%esp)
801014dd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014e1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014e6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ea:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014ef:	89 44 24 14          	mov    %eax,0x14(%esp)
801014f3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014f8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014fc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101501:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101505:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010150a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010150e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101513:	89 44 24 04          	mov    %eax,0x4(%esp)
80101517:	e8 34 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010151c:	83 c4 24             	add    $0x24,%esp
8010151f:	5b                   	pop    %ebx
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
80101522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 2c             	sub    $0x2c,%esp
80101539:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101543:	8b 7d 08             	mov    0x8(%ebp),%edi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 a2 00 00 00    	jbe    801015f1 <ialloc+0xc1>
8010154f:	be 01 00 00 00       	mov    $0x1,%esi
80101554:	bb 01 00 00 00       	mov    $0x1,%ebx
80101559:	eb 1a                	jmp    80101575 <ialloc+0x45>
8010155b:	90                   	nop
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101560:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101566:	e8 75 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010156b:	89 de                	mov    %ebx,%esi
8010156d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101573:	73 7c                	jae    801015f1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101575:	89 f0                	mov    %esi,%eax
80101577:	c1 e8 03             	shr    $0x3,%eax
8010157a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101580:	89 3c 24             	mov    %edi,(%esp)
80101583:	89 44 24 04          	mov    %eax,0x4(%esp)
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 f0                	mov    %esi,%eax
80101590:	83 e0 07             	and    $0x7,%eax
80101593:	c1 e0 06             	shl    $0x6,%eax
80101596:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010159e:	75 c0                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a0:	89 0c 24             	mov    %ecx,(%esp)
801015a3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015aa:	00 
801015ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015b2:	00 
801015b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	e8 e2 2c 00 00       	call   801042a0 <memset>
      dip->type = type;
801015be:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015cb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ce:	89 14 24             	mov    %edx,(%esp)
801015d1:	e8 fa 16 00 00       	call   80102cd0 <log_write>
      brelse(bp);
801015d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015d9:	89 14 24             	mov    %edx,(%esp)
801015dc:	e8 ff eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015e4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015e7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e9:	5e                   	pop    %esi
801015ea:	5f                   	pop    %edi
801015eb:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ec:	e9 2f fc ff ff       	jmp    80101220 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015f1:	c7 04 24 18 6f 10 80 	movl   $0x80106f18,(%esp)
801015f8:	e8 63 ed ff ff       	call   80100360 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	83 ec 10             	sub    $0x10,%esp
80101608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010161a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010161e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101621:	89 04 24             	mov    %eax,(%esp)
80101624:	e8 a7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101629:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010162c:	83 e2 07             	and    $0x7,%edx
8010162f:	c1 e2 06             	shl    $0x6,%edx
80101632:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101636:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101638:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010163f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101643:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101647:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010164b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010164f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101653:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101657:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010165b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010165e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101661:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101665:	89 14 24             	mov    %edx,(%esp)
80101668:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010166f:	00 
80101670:	e8 cb 2c 00 00       	call   80104340 <memmove>
  log_write(bp);
80101675:	89 34 24             	mov    %esi,(%esp)
80101678:	e8 53 16 00 00       	call   80102cd0 <log_write>
  brelse(bp);
8010167d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101680:	83 c4 10             	add    $0x10,%esp
80101683:	5b                   	pop    %ebx
80101684:	5e                   	pop    %esi
80101685:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101686:	e9 55 eb ff ff       	jmp    801001e0 <brelse>
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <calliget>:
}

struct inode*
calliget(uint inum){
80101690:	55                   	push   %ebp
	return iget(0,inum);
80101691:	31 c0                	xor    %eax,%eax
  log_write(bp);
  brelse(bp);
}

struct inode*
calliget(uint inum){
80101693:	89 e5                	mov    %esp,%ebp
	return iget(0,inum);
80101695:	8b 55 08             	mov    0x8(%ebp),%edx
}
80101698:	5d                   	pop    %ebp
  brelse(bp);
}

struct inode*
calliget(uint inum){
	return iget(0,inum);
80101699:	e9 82 fb ff ff       	jmp    80101220 <iget>
8010169e:	66 90                	xchg   %ax,%ax

801016a0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	53                   	push   %ebx
801016a4:	83 ec 14             	sub    $0x14,%esp
801016a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 aa 2a 00 00       	call   80104160 <acquire>
  ip->ref++;
801016b6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016ba:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016c1:	e8 8a 2b 00 00       	call   80104250 <release>
  return ip;
}
801016c6:	83 c4 14             	add    $0x14,%esp
801016c9:	89 d8                	mov    %ebx,%eax
801016cb:	5b                   	pop    %ebx
801016cc:	5d                   	pop    %ebp
801016cd:	c3                   	ret    
801016ce:	66 90                	xchg   %ax,%ax

801016d0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	83 ec 10             	sub    $0x10,%esp
801016d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016db:	85 db                	test   %ebx,%ebx
801016dd:	0f 84 b3 00 00 00    	je     80101796 <ilock+0xc6>
801016e3:	8b 53 08             	mov    0x8(%ebx),%edx
801016e6:	85 d2                	test   %edx,%edx
801016e8:	0f 8e a8 00 00 00    	jle    80101796 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801016f1:	89 04 24             	mov    %eax,(%esp)
801016f4:	e8 a7 28 00 00       	call   80103fa0 <acquiresleep>

  if(ip->valid == 0){
801016f9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016fc:	85 c0                	test   %eax,%eax
801016fe:	74 08                	je     80101708 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101700:	83 c4 10             	add    $0x10,%esp
80101703:	5b                   	pop    %ebx
80101704:	5e                   	pop    %esi
80101705:	5d                   	pop    %ebp
80101706:	c3                   	ret    
80101707:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101708:	8b 43 04             	mov    0x4(%ebx),%eax
8010170b:	c1 e8 03             	shr    $0x3,%eax
8010170e:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101714:	89 44 24 04          	mov    %eax,0x4(%esp)
80101718:	8b 03                	mov    (%ebx),%eax
8010171a:	89 04 24             	mov    %eax,(%esp)
8010171d:	e8 ae e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101722:	8b 53 04             	mov    0x4(%ebx),%edx
80101725:	83 e2 07             	and    $0x7,%edx
80101728:	c1 e2 06             	shl    $0x6,%edx
8010172b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010172f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101731:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101734:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101737:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010173b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010173f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101743:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101747:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010174b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010174f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101753:	8b 42 fc             	mov    -0x4(%edx),%eax
80101756:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101759:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010175c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101760:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101767:	00 
80101768:	89 04 24             	mov    %eax,(%esp)
8010176b:	e8 d0 2b 00 00       	call   80104340 <memmove>
    brelse(bp);
80101770:	89 34 24             	mov    %esi,(%esp)
80101773:	e8 68 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101778:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010177d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101784:	0f 85 76 ff ff ff    	jne    80101700 <ilock+0x30>
      panic("ilock: no type");
8010178a:	c7 04 24 30 6f 10 80 	movl   $0x80106f30,(%esp)
80101791:	e8 ca eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101796:	c7 04 24 2a 6f 10 80 	movl   $0x80106f2a,(%esp)
8010179d:	e8 be eb ff ff       	call   80100360 <panic>
801017a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017b0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	56                   	push   %esi
801017b4:	53                   	push   %ebx
801017b5:	83 ec 10             	sub    $0x10,%esp
801017b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017bb:	85 db                	test   %ebx,%ebx
801017bd:	74 24                	je     801017e3 <iunlock+0x33>
801017bf:	8d 73 0c             	lea    0xc(%ebx),%esi
801017c2:	89 34 24             	mov    %esi,(%esp)
801017c5:	e8 76 28 00 00       	call   80104040 <holdingsleep>
801017ca:	85 c0                	test   %eax,%eax
801017cc:	74 15                	je     801017e3 <iunlock+0x33>
801017ce:	8b 43 08             	mov    0x8(%ebx),%eax
801017d1:	85 c0                	test   %eax,%eax
801017d3:	7e 0e                	jle    801017e3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017d5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	5b                   	pop    %ebx
801017dc:	5e                   	pop    %esi
801017dd:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017de:	e9 1d 28 00 00       	jmp    80104000 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017e3:	c7 04 24 3f 6f 10 80 	movl   $0x80106f3f,(%esp)
801017ea:	e8 71 eb ff ff       	call   80100360 <panic>
801017ef:	90                   	nop

801017f0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 1c             	sub    $0x1c,%esp
801017f9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017fc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017ff:	89 3c 24             	mov    %edi,(%esp)
80101802:	e8 99 27 00 00       	call   80103fa0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101807:	8b 56 4c             	mov    0x4c(%esi),%edx
8010180a:	85 d2                	test   %edx,%edx
8010180c:	74 07                	je     80101815 <iput+0x25>
8010180e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101813:	74 2b                	je     80101840 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101815:	89 3c 24             	mov    %edi,(%esp)
80101818:	e8 e3 27 00 00       	call   80104000 <releasesleep>

  acquire(&icache.lock);
8010181d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101824:	e8 37 29 00 00       	call   80104160 <acquire>
  ip->ref--;
80101829:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010182d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101834:	83 c4 1c             	add    $0x1c,%esp
80101837:	5b                   	pop    %ebx
80101838:	5e                   	pop    %esi
80101839:	5f                   	pop    %edi
8010183a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010183b:	e9 10 2a 00 00       	jmp    80104250 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101840:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101847:	e8 14 29 00 00       	call   80104160 <acquire>
    int r = ip->ref;
8010184c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010184f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101856:	e8 f5 29 00 00       	call   80104250 <release>
    if(r == 1){
8010185b:	83 fb 01             	cmp    $0x1,%ebx
8010185e:	75 b5                	jne    80101815 <iput+0x25>
80101860:	8d 4e 30             	lea    0x30(%esi),%ecx
80101863:	89 f3                	mov    %esi,%ebx
80101865:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101868:	89 cf                	mov    %ecx,%edi
8010186a:	eb 0b                	jmp    80101877 <iput+0x87>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101870:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101873:	39 fb                	cmp    %edi,%ebx
80101875:	74 19                	je     80101890 <iput+0xa0>
    if(ip->addrs[i]){
80101877:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010187a:	85 d2                	test   %edx,%edx
8010187c:	74 f2                	je     80101870 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010187e:	8b 06                	mov    (%esi),%eax
80101880:	e8 6b fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101885:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010188c:	eb e2                	jmp    80101870 <iput+0x80>
8010188e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101890:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101896:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101899:	85 c0                	test   %eax,%eax
8010189b:	75 2b                	jne    801018c8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010189d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018a4:	89 34 24             	mov    %esi,(%esp)
801018a7:	e8 54 fd ff ff       	call   80101600 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
801018ac:	31 c0                	xor    %eax,%eax
801018ae:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018b2:	89 34 24             	mov    %esi,(%esp)
801018b5:	e8 46 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018ba:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018c1:	e9 4f ff ff ff       	jmp    80101815 <iput+0x25>
801018c6:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018cc:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018ce:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d0:	89 04 24             	mov    %eax,(%esp)
801018d3:	e8 f8 e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018d8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
801018db:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018e1:	89 cf                	mov    %ecx,%edi
801018e3:	31 c0                	xor    %eax,%eax
801018e5:	eb 0e                	jmp    801018f5 <iput+0x105>
801018e7:	90                   	nop
801018e8:	83 c3 01             	add    $0x1,%ebx
801018eb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018f1:	89 d8                	mov    %ebx,%eax
801018f3:	74 10                	je     80101905 <iput+0x115>
      if(a[j])
801018f5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018f8:	85 d2                	test   %edx,%edx
801018fa:	74 ec                	je     801018e8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018fc:	8b 06                	mov    (%esi),%eax
801018fe:	e8 ed fa ff ff       	call   801013f0 <bfree>
80101903:	eb e3                	jmp    801018e8 <iput+0xf8>
    }
    brelse(bp);
80101905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101908:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010190b:	89 04 24             	mov    %eax,(%esp)
8010190e:	e8 cd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101913:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101919:	8b 06                	mov    (%esi),%eax
8010191b:	e8 d0 fa ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101920:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101927:	00 00 00 
8010192a:	e9 6e ff ff ff       	jmp    8010189d <iput+0xad>
8010192f:	90                   	nop

80101930 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	53                   	push   %ebx
80101934:	83 ec 14             	sub    $0x14,%esp
80101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010193a:	89 1c 24             	mov    %ebx,(%esp)
8010193d:	e8 6e fe ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101942:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101945:	83 c4 14             	add    $0x14,%esp
80101948:	5b                   	pop    %ebx
80101949:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010194a:	e9 a1 fe ff ff       	jmp    801017f0 <iput>
8010194f:	90                   	nop

80101950 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	8b 55 08             	mov    0x8(%ebp),%edx
80101956:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101959:	8b 0a                	mov    (%edx),%ecx
8010195b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010195e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101961:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101964:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101968:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010196b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010196f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101973:	8b 52 58             	mov    0x58(%edx),%edx
80101976:	89 50 10             	mov    %edx,0x10(%eax)
}
80101979:	5d                   	pop    %ebp
8010197a:	c3                   	ret    
8010197b:	90                   	nop
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	53                   	push   %ebx
80101986:	83 ec 2c             	sub    $0x2c,%esp
80101989:	8b 45 0c             	mov    0xc(%ebp),%eax
8010198c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010198f:	8b 75 10             	mov    0x10(%ebp),%esi
80101992:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101995:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101998:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010199d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a0:	0f 84 aa 00 00 00    	je     80101a50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019a6:	8b 47 58             	mov    0x58(%edi),%eax
801019a9:	39 f0                	cmp    %esi,%eax
801019ab:	0f 82 c7 00 00 00    	jb     80101a78 <readi+0xf8>
801019b1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019b4:	89 da                	mov    %ebx,%edx
801019b6:	01 f2                	add    %esi,%edx
801019b8:	0f 82 ba 00 00 00    	jb     80101a78 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019be:	89 c1                	mov    %eax,%ecx
801019c0:	29 f1                	sub    %esi,%ecx
801019c2:	39 d0                	cmp    %edx,%eax
801019c4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c7:	31 c0                	xor    %eax,%eax
801019c9:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019cb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ce:	74 70                	je     80101a40 <readi+0xc0>
801019d0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019d3:	89 c7                	mov    %eax,%edi
801019d5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019db:	89 f2                	mov    %esi,%edx
801019dd:	c1 ea 09             	shr    $0x9,%edx
801019e0:	89 d8                	mov    %ebx,%eax
801019e2:	e8 f9 f8 ff ff       	call   801012e0 <bmap>
801019e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019eb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ed:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019f2:	89 04 24             	mov    %eax,(%esp)
801019f5:	e8 d6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019fd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ff:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a01:	89 f0                	mov    %esi,%eax
80101a03:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a08:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0e:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a10:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a17:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a1a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a1e:	01 df                	add    %ebx,%edi
80101a20:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a22:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a25:	89 04 24             	mov    %eax,(%esp)
80101a28:	e8 13 29 00 00       	call   80104340 <memmove>
    brelse(bp);
80101a2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a30:	89 14 24             	mov    %edx,(%esp)
80101a33:	e8 a8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a38:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a3b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a3e:	77 98                	ja     801019d8 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a43:	83 c4 2c             	add    $0x2c,%esp
80101a46:	5b                   	pop    %ebx
80101a47:	5e                   	pop    %esi
80101a48:	5f                   	pop    %edi
80101a49:	5d                   	pop    %ebp
80101a4a:	c3                   	ret    
80101a4b:	90                   	nop
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a50:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a54:	66 83 f8 09          	cmp    $0x9,%ax
80101a58:	77 1e                	ja     80101a78 <readi+0xf8>
80101a5a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a61:	85 c0                	test   %eax,%eax
80101a63:	74 13                	je     80101a78 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a65:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a68:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a6b:	83 c4 2c             	add    $0x2c,%esp
80101a6e:	5b                   	pop    %ebx
80101a6f:	5e                   	pop    %esi
80101a70:	5f                   	pop    %edi
80101a71:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a72:	ff e0                	jmp    *%eax
80101a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a7d:	eb c4                	jmp    80101a43 <readi+0xc3>
80101a7f:	90                   	nop

80101a80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	57                   	push   %edi
80101a84:	56                   	push   %esi
80101a85:	53                   	push   %ebx
80101a86:	83 ec 2c             	sub    $0x2c,%esp
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a8f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a97:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a9a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aa0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa3:	0f 84 b7 00 00 00    	je     80101b60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101aa9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aac:	39 70 58             	cmp    %esi,0x58(%eax)
80101aaf:	0f 82 e3 00 00 00    	jb     80101b98 <writei+0x118>
80101ab5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ab8:	89 c8                	mov    %ecx,%eax
80101aba:	01 f0                	add    %esi,%eax
80101abc:	0f 82 d6 00 00 00    	jb     80101b98 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ac2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ac7:	0f 87 cb 00 00 00    	ja     80101b98 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101acd:	85 c9                	test   %ecx,%ecx
80101acf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ad6:	74 77                	je     80101b4f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101adb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101add:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae2:	c1 ea 09             	shr    $0x9,%edx
80101ae5:	89 f8                	mov    %edi,%eax
80101ae7:	e8 f4 f7 ff ff       	call   801012e0 <bmap>
80101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
80101af0:	8b 07                	mov    (%edi),%eax
80101af2:	89 04 24             	mov    %eax,(%esp)
80101af5:	e8 d6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101afa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101afd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b00:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b03:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b05:	89 f0                	mov    %esi,%eax
80101b07:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b0c:	29 c3                	sub    %eax,%ebx
80101b0e:	39 cb                	cmp    %ecx,%ebx
80101b10:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b17:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b19:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b1d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b21:	89 04 24             	mov    %eax,(%esp)
80101b24:	e8 17 28 00 00       	call   80104340 <memmove>
    log_write(bp);
80101b29:	89 3c 24             	mov    %edi,(%esp)
80101b2c:	e8 9f 11 00 00       	call   80102cd0 <log_write>
    brelse(bp);
80101b31:	89 3c 24             	mov    %edi,(%esp)
80101b34:	e8 a7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b39:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b3f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b42:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b45:	77 91                	ja     80101ad8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b47:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b4d:	72 39                	jb     80101b88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b52:	83 c4 2c             	add    $0x2c,%esp
80101b55:	5b                   	pop    %ebx
80101b56:	5e                   	pop    %esi
80101b57:	5f                   	pop    %edi
80101b58:	5d                   	pop    %ebp
80101b59:	c3                   	ret    
80101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 2e                	ja     80101b98 <writei+0x118>
80101b6a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 23                	je     80101b98 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b75:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b78:	83 c4 2c             	add    $0x2c,%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b7f:	ff e0                	jmp    *%eax
80101b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b88:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b8b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b8e:	89 04 24             	mov    %eax,(%esp)
80101b91:	e8 6a fa ff ff       	call   80101600 <iupdate>
80101b96:	eb b7                	jmp    80101b4f <writei+0xcf>
  }
  return n;
}
80101b98:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101ba0:	5b                   	pop    %ebx
80101ba1:	5e                   	pop    %esi
80101ba2:	5f                   	pop    %edi
80101ba3:	5d                   	pop    %ebp
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bb9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bc0:	00 
80101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc8:	89 04 24             	mov    %eax,(%esp)
80101bcb:	e8 f0 27 00 00       	call   801043c0 <strncmp>
}
80101bd0:	c9                   	leave  
80101bd1:	c3                   	ret    
80101bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 2c             	sub    $0x2c,%esp
80101be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bf1:	0f 85 97 00 00 00    	jne    80101c8e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bfa:	31 ff                	xor    %edi,%edi
80101bfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bff:	85 d2                	test   %edx,%edx
80101c01:	75 0d                	jne    80101c10 <dirlookup+0x30>
80101c03:	eb 73                	jmp    80101c78 <dirlookup+0x98>
80101c05:	8d 76 00             	lea    0x0(%esi),%esi
80101c08:	83 c7 10             	add    $0x10,%edi
80101c0b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c0e:	76 68                	jbe    80101c78 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c10:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c17:	00 
80101c18:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c1c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c20:	89 1c 24             	mov    %ebx,(%esp)
80101c23:	e8 58 fd ff ff       	call   80101980 <readi>
80101c28:	83 f8 10             	cmp    $0x10,%eax
80101c2b:	75 55                	jne    80101c82 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c2d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c32:	74 d4                	je     80101c08 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c3e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c45:	00 
80101c46:	89 04 24             	mov    %eax,(%esp)
80101c49:	e8 72 27 00 00       	call   801043c0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c4e:	85 c0                	test   %eax,%eax
80101c50:	75 b6                	jne    80101c08 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c52:	8b 45 10             	mov    0x10(%ebp),%eax
80101c55:	85 c0                	test   %eax,%eax
80101c57:	74 05                	je     80101c5e <dirlookup+0x7e>
        *poff = off;
80101c59:	8b 45 10             	mov    0x10(%ebp),%eax
80101c5c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c5e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c62:	8b 03                	mov    (%ebx),%eax
80101c64:	e8 b7 f5 ff ff       	call   80101220 <iget>
    }
  }

  return 0;
}
80101c69:	83 c4 2c             	add    $0x2c,%esp
80101c6c:	5b                   	pop    %ebx
80101c6d:	5e                   	pop    %esi
80101c6e:	5f                   	pop    %edi
80101c6f:	5d                   	pop    %ebp
80101c70:	c3                   	ret    
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c78:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c7b:	31 c0                	xor    %eax,%eax
}
80101c7d:	5b                   	pop    %ebx
80101c7e:	5e                   	pop    %esi
80101c7f:	5f                   	pop    %edi
80101c80:	5d                   	pop    %ebp
80101c81:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c82:	c7 04 24 59 6f 10 80 	movl   $0x80106f59,(%esp)
80101c89:	e8 d2 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c8e:	c7 04 24 47 6f 10 80 	movl   $0x80106f47,(%esp)
80101c95:	e8 c6 e6 ff ff       	call   80100360 <panic>
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	89 cf                	mov    %ecx,%edi
80101ca6:	56                   	push   %esi
80101ca7:	53                   	push   %ebx
80101ca8:	89 c3                	mov    %eax,%ebx
80101caa:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cad:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101cb3:	0f 84 51 01 00 00    	je     80101e0a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cb9:	e8 02 1a 00 00       	call   801036c0 <myproc>
80101cbe:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cc8:	e8 93 24 00 00       	call   80104160 <acquire>
  ip->ref++;
80101ccd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cd8:	e8 73 25 00 00       	call   80104250 <release>
80101cdd:	eb 04                	jmp    80101ce3 <namex+0x43>
80101cdf:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101ce0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101ce3:	0f b6 03             	movzbl (%ebx),%eax
80101ce6:	3c 2f                	cmp    $0x2f,%al
80101ce8:	74 f6                	je     80101ce0 <namex+0x40>
    path++;
  if(*path == 0)
80101cea:	84 c0                	test   %al,%al
80101cec:	0f 84 ed 00 00 00    	je     80101ddf <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cf2:	0f b6 03             	movzbl (%ebx),%eax
80101cf5:	89 da                	mov    %ebx,%edx
80101cf7:	84 c0                	test   %al,%al
80101cf9:	0f 84 b1 00 00 00    	je     80101db0 <namex+0x110>
80101cff:	3c 2f                	cmp    $0x2f,%al
80101d01:	75 0f                	jne    80101d12 <namex+0x72>
80101d03:	e9 a8 00 00 00       	jmp    80101db0 <namex+0x110>
80101d08:	3c 2f                	cmp    $0x2f,%al
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d10:	74 0a                	je     80101d1c <namex+0x7c>
    path++;
80101d12:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d15:	0f b6 02             	movzbl (%edx),%eax
80101d18:	84 c0                	test   %al,%al
80101d1a:	75 ec                	jne    80101d08 <namex+0x68>
80101d1c:	89 d1                	mov    %edx,%ecx
80101d1e:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d20:	83 f9 0d             	cmp    $0xd,%ecx
80101d23:	0f 8e 8f 00 00 00    	jle    80101db8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d29:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d2d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d34:	00 
80101d35:	89 3c 24             	mov    %edi,(%esp)
80101d38:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d3b:	e8 00 26 00 00       	call   80104340 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d43:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d45:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d48:	75 0e                	jne    80101d58 <namex+0xb8>
80101d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d50:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d56:	74 f8                	je     80101d50 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d58:	89 34 24             	mov    %esi,(%esp)
80101d5b:	e8 70 f9 ff ff       	call   801016d0 <ilock>
    if(ip->type != T_DIR){
80101d60:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d65:	0f 85 85 00 00 00    	jne    80101df0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d6e:	85 d2                	test   %edx,%edx
80101d70:	74 09                	je     80101d7b <namex+0xdb>
80101d72:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d75:	0f 84 a5 00 00 00    	je     80101e20 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d82:	00 
80101d83:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d87:	89 34 24             	mov    %esi,(%esp)
80101d8a:	e8 51 fe ff ff       	call   80101be0 <dirlookup>
80101d8f:	85 c0                	test   %eax,%eax
80101d91:	74 5d                	je     80101df0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d93:	89 34 24             	mov    %esi,(%esp)
80101d96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d99:	e8 12 fa ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101d9e:	89 34 24             	mov    %esi,(%esp)
80101da1:	e8 4a fa ff ff       	call   801017f0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da9:	89 c6                	mov    %eax,%esi
80101dab:	e9 33 ff ff ff       	jmp    80101ce3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101db0:	31 c9                	xor    %ecx,%ecx
80101db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101db8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dbc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101dc0:	89 3c 24             	mov    %edi,(%esp)
80101dc3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dc9:	e8 72 25 00 00       	call   80104340 <memmove>
    name[len] = 0;
80101dce:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dd4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dd8:	89 d3                	mov    %edx,%ebx
80101dda:	e9 66 ff ff ff       	jmp    80101d45 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ddf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101de2:	85 c0                	test   %eax,%eax
80101de4:	75 4c                	jne    80101e32 <namex+0x192>
80101de6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101de8:	83 c4 2c             	add    $0x2c,%esp
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101df0:	89 34 24             	mov    %esi,(%esp)
80101df3:	e8 b8 f9 ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101df8:	89 34 24             	mov    %esi,(%esp)
80101dfb:	e8 f0 f9 ff ff       	call   801017f0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e00:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e03:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e05:	5b                   	pop    %ebx
80101e06:	5e                   	pop    %esi
80101e07:	5f                   	pop    %edi
80101e08:	5d                   	pop    %ebp
80101e09:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e0a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e0f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e14:	e8 07 f4 ff ff       	call   80101220 <iget>
80101e19:	89 c6                	mov    %eax,%esi
80101e1b:	e9 c3 fe ff ff       	jmp    80101ce3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e20:	89 34 24             	mov    %esi,(%esp)
80101e23:	e8 88 f9 ff ff       	call   801017b0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e28:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e2b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e2d:	5b                   	pop    %ebx
80101e2e:	5e                   	pop    %esi
80101e2f:	5f                   	pop    %edi
80101e30:	5d                   	pop    %ebp
80101e31:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e32:	89 34 24             	mov    %esi,(%esp)
80101e35:	e8 b6 f9 ff ff       	call   801017f0 <iput>
    return 0;
80101e3a:	31 c0                	xor    %eax,%eax
80101e3c:	eb aa                	jmp    80101de8 <namex+0x148>
80101e3e:	66 90                	xchg   %ax,%ax

80101e40 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	57                   	push   %edi
80101e44:	56                   	push   %esi
80101e45:	53                   	push   %ebx
80101e46:	83 ec 2c             	sub    $0x2c,%esp
80101e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e56:	00 
80101e57:	89 1c 24             	mov    %ebx,(%esp)
80101e5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e5e:	e8 7d fd ff ff       	call   80101be0 <dirlookup>
80101e63:	85 c0                	test   %eax,%eax
80101e65:	0f 85 8b 00 00 00    	jne    80101ef6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e6b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e6e:	31 ff                	xor    %edi,%edi
80101e70:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e73:	85 c0                	test   %eax,%eax
80101e75:	75 13                	jne    80101e8a <dirlink+0x4a>
80101e77:	eb 35                	jmp    80101eae <dirlink+0x6e>
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e80:	8d 57 10             	lea    0x10(%edi),%edx
80101e83:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e86:	89 d7                	mov    %edx,%edi
80101e88:	76 24                	jbe    80101eae <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e91:	00 
80101e92:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e96:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e9a:	89 1c 24             	mov    %ebx,(%esp)
80101e9d:	e8 de fa ff ff       	call   80101980 <readi>
80101ea2:	83 f8 10             	cmp    $0x10,%eax
80101ea5:	75 5e                	jne    80101f05 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101ea7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eac:	75 d2                	jne    80101e80 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101eae:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101eb8:	00 
80101eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ebd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ec0:	89 04 24             	mov    %eax,(%esp)
80101ec3:	e8 68 25 00 00       	call   80104430 <strncpy>
  de.inum = inum;
80101ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ecb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ed2:	00 
80101ed3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ed7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101edb:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101ede:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ee2:	e8 99 fb ff ff       	call   80101a80 <writei>
80101ee7:	83 f8 10             	cmp    $0x10,%eax
80101eea:	75 25                	jne    80101f11 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101eec:	31 c0                	xor    %eax,%eax
}
80101eee:	83 c4 2c             	add    $0x2c,%esp
80101ef1:	5b                   	pop    %ebx
80101ef2:	5e                   	pop    %esi
80101ef3:	5f                   	pop    %edi
80101ef4:	5d                   	pop    %ebp
80101ef5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ef6:	89 04 24             	mov    %eax,(%esp)
80101ef9:	e8 f2 f8 ff ff       	call   801017f0 <iput>
    return -1;
80101efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f03:	eb e9                	jmp    80101eee <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f05:	c7 04 24 68 6f 10 80 	movl   $0x80106f68,(%esp)
80101f0c:	e8 4f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f11:	c7 04 24 6a 75 10 80 	movl   $0x8010756a,(%esp)
80101f18:	e8 43 e4 ff ff       	call   80100360 <panic>
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi

80101f20 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f20:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f21:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f23:	89 e5                	mov    %esp,%ebp
80101f25:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f2e:	e8 6d fd ff ff       	call   80101ca0 <namex>
}
80101f33:	c9                   	leave  
80101f34:	c3                   	ret    
80101f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f40:	55                   	push   %ebp
  return namex(path, 1, name);
80101f41:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f46:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f4e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f4f:	e9 4c fd ff ff       	jmp    80101ca0 <namex>
80101f54:	66 90                	xchg   %ax,%ax
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	66 90                	xchg   %ax,%ax
80101f5a:	66 90                	xchg   %ax,%ax
80101f5c:	66 90                	xchg   %ax,%ax
80101f5e:	66 90                	xchg   %ax,%ax

80101f60 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	56                   	push   %esi
80101f64:	89 c6                	mov    %eax,%esi
80101f66:	53                   	push   %ebx
80101f67:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f6a:	85 c0                	test   %eax,%eax
80101f6c:	0f 84 99 00 00 00    	je     8010200b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f72:	8b 48 08             	mov    0x8(%eax),%ecx
80101f75:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f7b:	0f 87 7e 00 00 00    	ja     80101fff <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f81:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f86:	66 90                	xchg   %ax,%ax
80101f88:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f89:	83 e0 c0             	and    $0xffffffc0,%eax
80101f8c:	3c 40                	cmp    $0x40,%al
80101f8e:	75 f8                	jne    80101f88 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f90:	31 db                	xor    %ebx,%ebx
80101f92:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f97:	89 d8                	mov    %ebx,%eax
80101f99:	ee                   	out    %al,(%dx)
80101f9a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f9f:	b8 01 00 00 00       	mov    $0x1,%eax
80101fa4:	ee                   	out    %al,(%dx)
80101fa5:	0f b6 c1             	movzbl %cl,%eax
80101fa8:	b2 f3                	mov    $0xf3,%dl
80101faa:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fab:	89 c8                	mov    %ecx,%eax
80101fad:	b2 f4                	mov    $0xf4,%dl
80101faf:	c1 f8 08             	sar    $0x8,%eax
80101fb2:	ee                   	out    %al,(%dx)
80101fb3:	b2 f5                	mov    $0xf5,%dl
80101fb5:	89 d8                	mov    %ebx,%eax
80101fb7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fb8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fbc:	b2 f6                	mov    $0xf6,%dl
80101fbe:	83 e0 01             	and    $0x1,%eax
80101fc1:	c1 e0 04             	shl    $0x4,%eax
80101fc4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fc7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fc8:	f6 06 04             	testb  $0x4,(%esi)
80101fcb:	75 13                	jne    80101fe0 <idestart+0x80>
80101fcd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fd2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fd7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
80101fdf:	90                   	nop
80101fe0:	b2 f7                	mov    $0xf7,%dl
80101fe2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fe7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fe8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fed:	83 c6 5c             	add    $0x5c,%esi
80101ff0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ff5:	fc                   	cld    
80101ff6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101ff8:	83 c4 10             	add    $0x10,%esp
80101ffb:	5b                   	pop    %ebx
80101ffc:	5e                   	pop    %esi
80101ffd:	5d                   	pop    %ebp
80101ffe:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fff:	c7 04 24 d4 6f 10 80 	movl   $0x80106fd4,(%esp)
80102006:	e8 55 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010200b:	c7 04 24 cb 6f 10 80 	movl   $0x80106fcb,(%esp)
80102012:	e8 49 e3 ff ff       	call   80100360 <panic>
80102017:	89 f6                	mov    %esi,%esi
80102019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102020 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102026:	c7 44 24 04 e6 6f 10 	movl   $0x80106fe6,0x4(%esp)
8010202d:	80 
8010202e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102035:	e8 36 20 00 00       	call   80104070 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010203a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010203f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102046:	83 e8 01             	sub    $0x1,%eax
80102049:	89 44 24 04          	mov    %eax,0x4(%esp)
8010204d:	e8 7e 02 00 00       	call   801022d0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102052:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102057:	90                   	nop
80102058:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102059:	83 e0 c0             	and    $0xffffffc0,%eax
8010205c:	3c 40                	cmp    $0x40,%al
8010205e:	75 f8                	jne    80102058 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102060:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102065:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010206a:	ee                   	out    %al,(%dx)
8010206b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102070:	b2 f7                	mov    $0xf7,%dl
80102072:	eb 09                	jmp    8010207d <ideinit+0x5d>
80102074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102078:	83 e9 01             	sub    $0x1,%ecx
8010207b:	74 0f                	je     8010208c <ideinit+0x6c>
8010207d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010207e:	84 c0                	test   %al,%al
80102080:	74 f6                	je     80102078 <ideinit+0x58>
      havedisk1 = 1;
80102082:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102089:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010208c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102091:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102096:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102097:	c9                   	leave  
80102098:	c3                   	ret    
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020a9:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020b0:	e8 ab 20 00 00       	call   80104160 <acquire>

  if((b = idequeue) == 0){
801020b5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020bb:	85 db                	test   %ebx,%ebx
801020bd:	74 30                	je     801020ef <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020bf:	8b 43 58             	mov    0x58(%ebx),%eax
801020c2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020c7:	8b 33                	mov    (%ebx),%esi
801020c9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020cf:	74 37                	je     80102108 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020d1:	83 e6 fb             	and    $0xfffffffb,%esi
801020d4:	83 ce 02             	or     $0x2,%esi
801020d7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020d9:	89 1c 24             	mov    %ebx,(%esp)
801020dc:	e8 cf 1c 00 00       	call   80103db0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020e1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020e6:	85 c0                	test   %eax,%eax
801020e8:	74 05                	je     801020ef <ideintr+0x4f>
    idestart(idequeue);
801020ea:	e8 71 fe ff ff       	call   80101f60 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020ef:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020f6:	e8 55 21 00 00       	call   80104250 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020fb:	83 c4 1c             	add    $0x1c,%esp
801020fe:	5b                   	pop    %ebx
801020ff:	5e                   	pop    %esi
80102100:	5f                   	pop    %edi
80102101:	5d                   	pop    %ebp
80102102:	c3                   	ret    
80102103:	90                   	nop
80102104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102108:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010210d:	8d 76 00             	lea    0x0(%esi),%esi
80102110:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102111:	89 c1                	mov    %eax,%ecx
80102113:	83 e1 c0             	and    $0xffffffc0,%ecx
80102116:	80 f9 40             	cmp    $0x40,%cl
80102119:	75 f5                	jne    80102110 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010211b:	a8 21                	test   $0x21,%al
8010211d:	75 b2                	jne    801020d1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010211f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102122:	b9 80 00 00 00       	mov    $0x80,%ecx
80102127:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010212c:	fc                   	cld    
8010212d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010212f:	8b 33                	mov    (%ebx),%esi
80102131:	eb 9e                	jmp    801020d1 <ideintr+0x31>
80102133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102140 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	53                   	push   %ebx
80102144:	83 ec 14             	sub    $0x14,%esp
80102147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010214a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010214d:	89 04 24             	mov    %eax,(%esp)
80102150:	e8 eb 1e 00 00       	call   80104040 <holdingsleep>
80102155:	85 c0                	test   %eax,%eax
80102157:	0f 84 9e 00 00 00    	je     801021fb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010215d:	8b 03                	mov    (%ebx),%eax
8010215f:	83 e0 06             	and    $0x6,%eax
80102162:	83 f8 02             	cmp    $0x2,%eax
80102165:	0f 84 a8 00 00 00    	je     80102213 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010216b:	8b 53 04             	mov    0x4(%ebx),%edx
8010216e:	85 d2                	test   %edx,%edx
80102170:	74 0d                	je     8010217f <iderw+0x3f>
80102172:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102177:	85 c0                	test   %eax,%eax
80102179:	0f 84 88 00 00 00    	je     80102207 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010217f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102186:	e8 d5 1f 00 00       	call   80104160 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102190:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102197:	85 c0                	test   %eax,%eax
80102199:	75 07                	jne    801021a2 <iderw+0x62>
8010219b:	eb 4e                	jmp    801021eb <iderw+0xab>
8010219d:	8d 76 00             	lea    0x0(%esi),%esi
801021a0:	89 d0                	mov    %edx,%eax
801021a2:	8b 50 58             	mov    0x58(%eax),%edx
801021a5:	85 d2                	test   %edx,%edx
801021a7:	75 f7                	jne    801021a0 <iderw+0x60>
801021a9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021ac:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021ae:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021b4:	74 3c                	je     801021f2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021b6:	8b 03                	mov    (%ebx),%eax
801021b8:	83 e0 06             	and    $0x6,%eax
801021bb:	83 f8 02             	cmp    $0x2,%eax
801021be:	74 1a                	je     801021da <iderw+0x9a>
    sleep(b, &idelock);
801021c0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021c7:	80 
801021c8:	89 1c 24             	mov    %ebx,(%esp)
801021cb:	e8 50 1a 00 00       	call   80103c20 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021d0:	8b 13                	mov    (%ebx),%edx
801021d2:	83 e2 06             	and    $0x6,%edx
801021d5:	83 fa 02             	cmp    $0x2,%edx
801021d8:	75 e6                	jne    801021c0 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
801021da:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021e1:	83 c4 14             	add    $0x14,%esp
801021e4:	5b                   	pop    %ebx
801021e5:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021e6:	e9 65 20 00 00       	jmp    80104250 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021eb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021f0:	eb ba                	jmp    801021ac <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021f2:	89 d8                	mov    %ebx,%eax
801021f4:	e8 67 fd ff ff       	call   80101f60 <idestart>
801021f9:	eb bb                	jmp    801021b6 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021fb:	c7 04 24 ea 6f 10 80 	movl   $0x80106fea,(%esp)
80102202:	e8 59 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102207:	c7 04 24 15 70 10 80 	movl   $0x80107015,(%esp)
8010220e:	e8 4d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102213:	c7 04 24 00 70 10 80 	movl   $0x80107000,(%esp)
8010221a:	e8 41 e1 ff ff       	call   80100360 <panic>
8010221f:	90                   	nop

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	56                   	push   %esi
80102224:	53                   	push   %ebx
80102225:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102228:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010222f:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102232:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102239:	00 00 00 
  return ioapic->data;
8010223c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102242:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102245:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010224b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102251:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102258:	c1 e8 10             	shr    $0x10,%eax
8010225b:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010225e:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
80102261:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102264:	39 c2                	cmp    %eax,%edx
80102266:	74 12                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102268:	c7 04 24 34 70 10 80 	movl   $0x80107034,(%esp)
8010226f:	e8 dc e3 ff ff       	call   80100650 <cprintf>
80102274:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010227a:	ba 10 00 00 00       	mov    $0x10,%edx
8010227f:	31 c0                	xor    %eax,%eax
80102281:	eb 07                	jmp    8010228a <ioapicinit+0x6a>
80102283:	90                   	nop
80102284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102288:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010228a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010228c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102292:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102295:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010229b:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010229e:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022a1:	8d 4a 01             	lea    0x1(%edx),%ecx
801022a4:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022a9:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022af:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022b1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022b8:	7d ce                	jge    80102288 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ba:	83 c4 10             	add    $0x10,%esp
801022bd:	5b                   	pop    %ebx
801022be:	5e                   	pop    %esi
801022bf:	5d                   	pop    %ebp
801022c0:	c3                   	ret    
801022c1:	eb 0d                	jmp    801022d0 <ioapicenable>
801022c3:	90                   	nop
801022c4:	90                   	nop
801022c5:	90                   	nop
801022c6:	90                   	nop
801022c7:	90                   	nop
801022c8:	90                   	nop
801022c9:	90                   	nop
801022ca:	90                   	nop
801022cb:	90                   	nop
801022cc:	90                   	nop
801022cd:	90                   	nop
801022ce:	90                   	nop
801022cf:	90                   	nop

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	8b 55 08             	mov    0x8(%ebp),%edx
801022d6:	53                   	push   %ebx
801022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022da:	8d 5a 20             	lea    0x20(%edx),%ebx
801022dd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022e1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e7:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ea:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ec:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f2:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022f5:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022f8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022fa:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102300:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102303:	5b                   	pop    %ebx
80102304:	5d                   	pop    %ebp
80102305:	c3                   	ret    
80102306:	66 90                	xchg   %ax,%ax
80102308:	66 90                	xchg   %ax,%ax
8010230a:	66 90                	xchg   %ax,%ax
8010230c:	66 90                	xchg   %ax,%ax
8010230e:	66 90                	xchg   %ax,%ax

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 14             	sub    $0x14,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 7c                	jne    8010239e <kfree+0x8e>
80102322:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102328:	72 74                	jb     8010239e <kfree+0x8e>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 67                	ja     8010239e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010233e:	00 
8010233f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102346:	00 
80102347:	89 1c 24             	mov    %ebx,(%esp)
8010234a:	e8 51 1f 00 00       	call   801042a0 <memset>

  if(kmem.use_lock)
8010234f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102355:	85 d2                	test   %edx,%edx
80102357:	75 37                	jne    80102390 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102359:	a1 78 26 11 80       	mov    0x80112678,%eax
8010235e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102360:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102365:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010236b:	85 c0                	test   %eax,%eax
8010236d:	75 09                	jne    80102378 <kfree+0x68>
    release(&kmem.lock);
}
8010236f:	83 c4 14             	add    $0x14,%esp
80102372:	5b                   	pop    %ebx
80102373:	5d                   	pop    %ebp
80102374:	c3                   	ret    
80102375:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102378:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010237f:	83 c4 14             	add    $0x14,%esp
80102382:	5b                   	pop    %ebx
80102383:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102384:	e9 c7 1e 00 00       	jmp    80104250 <release>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102390:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102397:	e8 c4 1d 00 00       	call   80104160 <acquire>
8010239c:	eb bb                	jmp    80102359 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010239e:	c7 04 24 66 70 10 80 	movl   $0x80107066,(%esp)
801023a5:	e8 b6 df ff ff       	call   80100360 <panic>
801023aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023b0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
801023b5:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023be:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023c4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ca:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023d0:	39 de                	cmp    %ebx,%esi
801023d2:	73 08                	jae    801023dc <freerange+0x2c>
801023d4:	eb 18                	jmp    801023ee <freerange+0x3e>
801023d6:	66 90                	xchg   %ax,%ax
801023d8:	89 da                	mov    %ebx,%edx
801023da:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023dc:	89 14 24             	mov    %edx,(%esp)
801023df:	e8 2c ff ff ff       	call   80102310 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ea:	39 f0                	cmp    %esi,%eax
801023ec:	76 ea                	jbe    801023d8 <freerange+0x28>
    kfree(p);
}
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	5b                   	pop    %ebx
801023f2:	5e                   	pop    %esi
801023f3:	5d                   	pop    %ebp
801023f4:	c3                   	ret    
801023f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102400 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	83 ec 10             	sub    $0x10,%esp
80102408:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010240b:	c7 44 24 04 6c 70 10 	movl   $0x8010706c,0x4(%esp)
80102412:	80 
80102413:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010241a:	e8 51 1c 00 00       	call   80104070 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010241f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102422:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102429:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010242c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102432:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102438:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010243e:	39 de                	cmp    %ebx,%esi
80102440:	73 0a                	jae    8010244c <kinit1+0x4c>
80102442:	eb 1a                	jmp    8010245e <kinit1+0x5e>
80102444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102448:	89 da                	mov    %ebx,%edx
8010244a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010244c:	89 14 24             	mov    %edx,(%esp)
8010244f:	e8 bc fe ff ff       	call   80102310 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102454:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010245a:	39 c6                	cmp    %eax,%esi
8010245c:	73 ea                	jae    80102448 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010245e:	83 c4 10             	add    $0x10,%esp
80102461:	5b                   	pop    %ebx
80102462:	5e                   	pop    %esi
80102463:	5d                   	pop    %ebp
80102464:	c3                   	ret    
80102465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
80102475:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102478:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010247b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010247e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102484:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010248a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102490:	39 de                	cmp    %ebx,%esi
80102492:	73 08                	jae    8010249c <kinit2+0x2c>
80102494:	eb 18                	jmp    801024ae <kinit2+0x3e>
80102496:	66 90                	xchg   %ax,%ax
80102498:	89 da                	mov    %ebx,%edx
8010249a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010249c:	89 14 24             	mov    %edx,(%esp)
8010249f:	e8 6c fe ff ff       	call   80102310 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024aa:	39 c6                	cmp    %eax,%esi
801024ac:	73 ea                	jae    80102498 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801024ae:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024b5:	00 00 00 
}
801024b8:	83 c4 10             	add    $0x10,%esp
801024bb:	5b                   	pop    %ebx
801024bc:	5e                   	pop    %esi
801024bd:	5d                   	pop    %ebp
801024be:	c3                   	ret    
801024bf:	90                   	nop

801024c0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024c7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024cc:	85 c0                	test   %eax,%eax
801024ce:	75 30                	jne    80102500 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024d0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024d6:	85 db                	test   %ebx,%ebx
801024d8:	74 08                	je     801024e2 <kalloc+0x22>
    kmem.freelist = r->next;
801024da:	8b 13                	mov    (%ebx),%edx
801024dc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024e2:	85 c0                	test   %eax,%eax
801024e4:	74 0c                	je     801024f2 <kalloc+0x32>
    release(&kmem.lock);
801024e6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024ed:	e8 5e 1d 00 00       	call   80104250 <release>
  return (char*)r;
}
801024f2:	83 c4 14             	add    $0x14,%esp
801024f5:	89 d8                	mov    %ebx,%eax
801024f7:	5b                   	pop    %ebx
801024f8:	5d                   	pop    %ebp
801024f9:	c3                   	ret    
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102500:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102507:	e8 54 1c 00 00       	call   80104160 <acquire>
8010250c:	a1 74 26 11 80       	mov    0x80112674,%eax
80102511:	eb bd                	jmp    801024d0 <kalloc+0x10>
80102513:	66 90                	xchg   %ax,%ax
80102515:	66 90                	xchg   %ax,%ax
80102517:	66 90                	xchg   %ax,%ax
80102519:	66 90                	xchg   %ax,%ax
8010251b:	66 90                	xchg   %ax,%ax
8010251d:	66 90                	xchg   %ax,%ax
8010251f:	90                   	nop

80102520 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102520:	ba 64 00 00 00       	mov    $0x64,%edx
80102525:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102526:	a8 01                	test   $0x1,%al
80102528:	0f 84 ba 00 00 00    	je     801025e8 <kbdgetc+0xc8>
8010252e:	b2 60                	mov    $0x60,%dl
80102530:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102531:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102534:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010253a:	0f 84 88 00 00 00    	je     801025c8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102540:	84 c0                	test   %al,%al
80102542:	79 2c                	jns    80102570 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102544:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010254a:	f6 c2 40             	test   $0x40,%dl
8010254d:	75 05                	jne    80102554 <kbdgetc+0x34>
8010254f:	89 c1                	mov    %eax,%ecx
80102551:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102554:	0f b6 81 a0 71 10 80 	movzbl -0x7fef8e60(%ecx),%eax
8010255b:	83 c8 40             	or     $0x40,%eax
8010255e:	0f b6 c0             	movzbl %al,%eax
80102561:	f7 d0                	not    %eax
80102563:	21 d0                	and    %edx,%eax
80102565:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010256a:	31 c0                	xor    %eax,%eax
8010256c:	c3                   	ret    
8010256d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	53                   	push   %ebx
80102574:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010257a:	f6 c3 40             	test   $0x40,%bl
8010257d:	74 09                	je     80102588 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010257f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102582:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102585:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102588:	0f b6 91 a0 71 10 80 	movzbl -0x7fef8e60(%ecx),%edx
  shift ^= togglecode[data];
8010258f:	0f b6 81 a0 70 10 80 	movzbl -0x7fef8f60(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102596:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102598:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010259a:	89 d0                	mov    %edx,%eax
8010259c:	83 e0 03             	and    $0x3,%eax
8010259f:	8b 04 85 80 70 10 80 	mov    -0x7fef8f80(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025a6:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
801025ac:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801025af:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025b3:	74 0b                	je     801025c0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025b5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025b8:	83 fa 19             	cmp    $0x19,%edx
801025bb:	77 1b                	ja     801025d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025bd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025c0:	5b                   	pop    %ebx
801025c1:	5d                   	pop    %ebp
801025c2:	c3                   	ret    
801025c3:	90                   	nop
801025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025c8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025cf:	31 c0                	xor    %eax,%eax
801025d1:	c3                   	ret    
801025d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025db:	8d 50 20             	lea    0x20(%eax),%edx
801025de:	83 f9 19             	cmp    $0x19,%ecx
801025e1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025e4:	eb da                	jmp    801025c0 <kbdgetc+0xa0>
801025e6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025ed:	c3                   	ret    
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025f6:	c7 04 24 20 25 10 80 	movl   $0x80102520,(%esp)
801025fd:	e8 ae e1 ff ff       	call   801007b0 <consoleintr>
}
80102602:	c9                   	leave  
80102603:	c3                   	ret    
80102604:	66 90                	xchg   %ax,%ax
80102606:	66 90                	xchg   %ax,%ax
80102608:	66 90                	xchg   %ax,%ax
8010260a:	66 90                	xchg   %ax,%ax
8010260c:	66 90                	xchg   %ax,%ax
8010260e:	66 90                	xchg   %ax,%ax

80102610 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102610:	55                   	push   %ebp
80102611:	89 c1                	mov    %eax,%ecx
80102613:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102615:	ba 70 00 00 00       	mov    $0x70,%edx
8010261a:	53                   	push   %ebx
8010261b:	31 c0                	xor    %eax,%eax
8010261d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010261e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102623:	89 da                	mov    %ebx,%edx
80102625:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102626:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102629:	b2 70                	mov    $0x70,%dl
8010262b:	89 01                	mov    %eax,(%ecx)
8010262d:	b8 02 00 00 00       	mov    $0x2,%eax
80102632:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102633:	89 da                	mov    %ebx,%edx
80102635:	ec                   	in     (%dx),%al
80102636:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102639:	b2 70                	mov    $0x70,%dl
8010263b:	89 41 04             	mov    %eax,0x4(%ecx)
8010263e:	b8 04 00 00 00       	mov    $0x4,%eax
80102643:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102644:	89 da                	mov    %ebx,%edx
80102646:	ec                   	in     (%dx),%al
80102647:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264a:	b2 70                	mov    $0x70,%dl
8010264c:	89 41 08             	mov    %eax,0x8(%ecx)
8010264f:	b8 07 00 00 00       	mov    $0x7,%eax
80102654:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102655:	89 da                	mov    %ebx,%edx
80102657:	ec                   	in     (%dx),%al
80102658:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265b:	b2 70                	mov    $0x70,%dl
8010265d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102660:	b8 08 00 00 00       	mov    $0x8,%eax
80102665:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102666:	89 da                	mov    %ebx,%edx
80102668:	ec                   	in     (%dx),%al
80102669:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010266c:	b2 70                	mov    $0x70,%dl
8010266e:	89 41 10             	mov    %eax,0x10(%ecx)
80102671:	b8 09 00 00 00       	mov    $0x9,%eax
80102676:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102677:	89 da                	mov    %ebx,%edx
80102679:	ec                   	in     (%dx),%al
8010267a:	0f b6 d8             	movzbl %al,%ebx
8010267d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102680:	5b                   	pop    %ebx
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret    
80102683:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102690 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102690:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102695:	55                   	push   %ebp
80102696:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102698:	85 c0                	test   %eax,%eax
8010269a:	0f 84 c0 00 00 00    	je     80102760 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026a7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026aa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ad:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ba:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026c1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026c4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ce:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026d1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026db:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026de:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ee:	8b 50 30             	mov    0x30(%eax),%edx
801026f1:	c1 ea 10             	shr    $0x10,%edx
801026f4:	80 fa 03             	cmp    $0x3,%dl
801026f7:	77 6f                	ja     80102768 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102700:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102703:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102706:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102710:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102713:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010271a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102720:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102727:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010272d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102734:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102737:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010273a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102741:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102744:	8b 50 20             	mov    0x20(%eax),%edx
80102747:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102748:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010274e:	80 e6 10             	and    $0x10,%dh
80102751:	75 f5                	jne    80102748 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102753:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010275a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010275d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102760:	5d                   	pop    %ebp
80102761:	c3                   	ret    
80102762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102768:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010276f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102772:	8b 50 20             	mov    0x20(%eax),%edx
80102775:	eb 82                	jmp    801026f9 <lapicinit+0x69>
80102777:	89 f6                	mov    %esi,%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102780:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0c                	je     80102798 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010278c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010278f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102790:	c1 e8 18             	shr    $0x18,%eax
}
80102793:	c3                   	ret    
80102794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102798:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010279a:	5d                   	pop    %ebp
8010279b:	c3                   	ret    
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027a0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801027a5:	55                   	push   %ebp
801027a6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027a8:	85 c0                	test   %eax,%eax
801027aa:	74 0d                	je     801027b9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027b3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801027b9:	5d                   	pop    %ebp
801027ba:	c3                   	ret    
801027bb:	90                   	nop
801027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027c0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
}
801027c3:	5d                   	pop    %ebp
801027c4:	c3                   	ret    
801027c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027d0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027d1:	ba 70 00 00 00       	mov    $0x70,%edx
801027d6:	89 e5                	mov    %esp,%ebp
801027d8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027dd:	53                   	push   %ebx
801027de:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027e4:	ee                   	out    %al,(%dx)
801027e5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ea:	b2 71                	mov    $0x71,%dl
801027ec:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027ed:	31 c0                	xor    %eax,%eax
801027ef:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027f5:	89 d8                	mov    %ebx,%eax
801027f7:	c1 e8 04             	shr    $0x4,%eax
801027fa:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102800:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102805:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102808:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102811:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102814:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010281b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102821:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102828:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102837:	89 da                	mov    %ebx,%edx
80102839:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010283c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102842:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102845:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010284e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102854:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102857:	5b                   	pop    %ebx
80102858:	5d                   	pop    %ebp
80102859:	c3                   	ret    
8010285a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102860 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102860:	55                   	push   %ebp
80102861:	ba 70 00 00 00       	mov    $0x70,%edx
80102866:	89 e5                	mov    %esp,%ebp
80102868:	b8 0b 00 00 00       	mov    $0xb,%eax
8010286d:	57                   	push   %edi
8010286e:	56                   	push   %esi
8010286f:	53                   	push   %ebx
80102870:	83 ec 4c             	sub    $0x4c,%esp
80102873:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102874:	b2 71                	mov    $0x71,%dl
80102876:	ec                   	in     (%dx),%al
80102877:	88 45 b7             	mov    %al,-0x49(%ebp)
8010287a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010287d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102881:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102888:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010288d:	89 d8                	mov    %ebx,%eax
8010288f:	e8 7c fd ff ff       	call   80102610 <fill_rtcdate>
80102894:	b8 0a 00 00 00       	mov    $0xa,%eax
80102899:	89 f2                	mov    %esi,%edx
8010289b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289c:	ba 71 00 00 00       	mov    $0x71,%edx
801028a1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028a2:	84 c0                	test   %al,%al
801028a4:	78 e7                	js     8010288d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028a6:	89 f8                	mov    %edi,%eax
801028a8:	e8 63 fd ff ff       	call   80102610 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028ad:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028b4:	00 
801028b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028b9:	89 1c 24             	mov    %ebx,(%esp)
801028bc:	e8 2f 1a 00 00       	call   801042f0 <memcmp>
801028c1:	85 c0                	test   %eax,%eax
801028c3:	75 c3                	jne    80102888 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028c5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028c9:	75 78                	jne    80102943 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028cb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ce:	89 c2                	mov    %eax,%edx
801028d0:	83 e0 0f             	and    $0xf,%eax
801028d3:	c1 ea 04             	shr    $0x4,%edx
801028d6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028d9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028dc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028df:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028e2:	89 c2                	mov    %eax,%edx
801028e4:	83 e0 0f             	and    $0xf,%eax
801028e7:	c1 ea 04             	shr    $0x4,%edx
801028ea:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028ed:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028f6:	89 c2                	mov    %eax,%edx
801028f8:	83 e0 0f             	and    $0xf,%eax
801028fb:	c1 ea 04             	shr    $0x4,%edx
801028fe:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102901:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102904:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102907:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010290a:	89 c2                	mov    %eax,%edx
8010290c:	83 e0 0f             	and    $0xf,%eax
8010290f:	c1 ea 04             	shr    $0x4,%edx
80102912:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102915:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102918:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010291b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010291e:	89 c2                	mov    %eax,%edx
80102920:	83 e0 0f             	and    $0xf,%eax
80102923:	c1 ea 04             	shr    $0x4,%edx
80102926:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102929:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010292f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102932:	89 c2                	mov    %eax,%edx
80102934:	83 e0 0f             	and    $0xf,%eax
80102937:	c1 ea 04             	shr    $0x4,%edx
8010293a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010293d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102940:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102943:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102946:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102949:	89 01                	mov    %eax,(%ecx)
8010294b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010294e:	89 41 04             	mov    %eax,0x4(%ecx)
80102951:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102954:	89 41 08             	mov    %eax,0x8(%ecx)
80102957:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010295a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010295d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102960:	89 41 10             	mov    %eax,0x10(%ecx)
80102963:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102966:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102969:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102970:	83 c4 4c             	add    $0x4c,%esp
80102973:	5b                   	pop    %ebx
80102974:	5e                   	pop    %esi
80102975:	5f                   	pop    %edi
80102976:	5d                   	pop    %ebp
80102977:	c3                   	ret    
80102978:	66 90                	xchg   %ax,%ax
8010297a:	66 90                	xchg   %ax,%ax
8010297c:	66 90                	xchg   %ax,%ax
8010297e:	66 90                	xchg   %ax,%ax

80102980 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	57                   	push   %edi
80102984:	56                   	push   %esi
80102985:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102986:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102988:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010298b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102990:	85 c0                	test   %eax,%eax
80102992:	7e 78                	jle    80102a0c <install_trans+0x8c>
80102994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102998:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010299d:	01 d8                	add    %ebx,%eax
8010299f:	83 c0 01             	add    $0x1,%eax
801029a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a6:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029ab:	89 04 24             	mov    %eax,(%esp)
801029ae:	e8 1d d7 ff ff       	call   801000d0 <bread>
801029b3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029b5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029bc:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029c8:	89 04 24             	mov    %eax,(%esp)
801029cb:	e8 00 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029d0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029d7:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029d8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029da:	8d 47 5c             	lea    0x5c(%edi),%eax
801029dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029e4:	89 04 24             	mov    %eax,(%esp)
801029e7:	e8 54 19 00 00       	call   80104340 <memmove>
    bwrite(dbuf);  // write dst to disk
801029ec:	89 34 24             	mov    %esi,(%esp)
801029ef:	e8 ac d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029f4:	89 3c 24             	mov    %edi,(%esp)
801029f7:	e8 e4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029fc:	89 34 24             	mov    %esi,(%esp)
801029ff:	e8 dc d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a04:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a0a:	7f 8c                	jg     80102998 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a0c:	83 c4 1c             	add    $0x1c,%esp
80102a0f:	5b                   	pop    %ebx
80102a10:	5e                   	pop    %esi
80102a11:	5f                   	pop    %edi
80102a12:	5d                   	pop    %ebp
80102a13:	c3                   	ret    
80102a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	57                   	push   %edi
80102a24:	56                   	push   %esi
80102a25:	53                   	push   %ebx
80102a26:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a29:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a32:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a37:	89 04 24             	mov    %eax,(%esp)
80102a3a:	e8 91 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a3f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a45:	31 d2                	xor    %edx,%edx
80102a47:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a49:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a4b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a4e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a51:	7e 17                	jle    80102a6a <write_head+0x4a>
80102a53:	90                   	nop
80102a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a58:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a5f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a63:	83 c2 01             	add    $0x1,%edx
80102a66:	39 da                	cmp    %ebx,%edx
80102a68:	75 ee                	jne    80102a58 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a6a:	89 3c 24             	mov    %edi,(%esp)
80102a6d:	e8 2e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a72:	89 3c 24             	mov    %edi,(%esp)
80102a75:	e8 66 d7 ff ff       	call   801001e0 <brelse>
}
80102a7a:	83 c4 1c             	add    $0x1c,%esp
80102a7d:	5b                   	pop    %ebx
80102a7e:	5e                   	pop    %esi
80102a7f:	5f                   	pop    %edi
80102a80:	5d                   	pop    %ebp
80102a81:	c3                   	ret    
80102a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a90 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	56                   	push   %esi
80102a94:	53                   	push   %ebx
80102a95:	83 ec 30             	sub    $0x30,%esp
80102a98:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102a9b:	c7 44 24 04 a0 72 10 	movl   $0x801072a0,0x4(%esp)
80102aa2:	80 
80102aa3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102aaa:	e8 c1 15 00 00       	call   80104070 <initlock>
  readsb(dev, &sb);
80102aaf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ab6:	89 1c 24             	mov    %ebx,(%esp)
80102ab9:	e8 e2 e8 ff ff       	call   801013a0 <readsb>
  log.start = sb.logstart;
80102abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ac1:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ac4:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102ac7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102acd:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ad1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ad7:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102adc:	e8 ef d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ae1:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ae3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ae6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ae9:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102aeb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102af1:	7e 17                	jle    80102b0a <initlog+0x7a>
80102af3:	90                   	nop
80102af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102af8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102afc:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b03:	83 c2 01             	add    $0x1,%edx
80102b06:	39 da                	cmp    %ebx,%edx
80102b08:	75 ee                	jne    80102af8 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b0a:	89 04 24             	mov    %eax,(%esp)
80102b0d:	e8 ce d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b12:	e8 69 fe ff ff       	call   80102980 <install_trans>
  log.lh.n = 0;
80102b17:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b1e:	00 00 00 
  write_head(); // clear the log
80102b21:	e8 fa fe ff ff       	call   80102a20 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b26:	83 c4 30             	add    $0x30,%esp
80102b29:	5b                   	pop    %ebx
80102b2a:	5e                   	pop    %esi
80102b2b:	5d                   	pop    %ebp
80102b2c:	c3                   	ret    
80102b2d:	8d 76 00             	lea    0x0(%esi),%esi

80102b30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b36:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b3d:	e8 1e 16 00 00       	call   80104160 <acquire>
80102b42:	eb 18                	jmp    80102b5c <begin_op+0x2c>
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b48:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b4f:	80 
80102b50:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b57:	e8 c4 10 00 00       	call   80103c20 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b5c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b61:	85 c0                	test   %eax,%eax
80102b63:	75 e3                	jne    80102b48 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b65:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b6a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b70:	83 c0 01             	add    $0x1,%eax
80102b73:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b76:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b79:	83 fa 1e             	cmp    $0x1e,%edx
80102b7c:	7f ca                	jg     80102b48 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b7e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b85:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b8a:	e8 c1 16 00 00       	call   80104250 <release>
      break;
    }
  }
}
80102b8f:	c9                   	leave  
80102b90:	c3                   	ret    
80102b91:	eb 0d                	jmp    80102ba0 <end_op>
80102b93:	90                   	nop
80102b94:	90                   	nop
80102b95:	90                   	nop
80102b96:	90                   	nop
80102b97:	90                   	nop
80102b98:	90                   	nop
80102b99:	90                   	nop
80102b9a:	90                   	nop
80102b9b:	90                   	nop
80102b9c:	90                   	nop
80102b9d:	90                   	nop
80102b9e:	90                   	nop
80102b9f:	90                   	nop

80102ba0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	57                   	push   %edi
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ba9:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bb0:	e8 ab 15 00 00       	call   80104160 <acquire>
  log.outstanding -= 1;
80102bb5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bba:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bc0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bc3:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bc5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bca:	0f 85 f3 00 00 00    	jne    80102cc3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bd0:	85 c0                	test   %eax,%eax
80102bd2:	0f 85 cb 00 00 00    	jne    80102ca3 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bd8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bdf:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102be1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102be8:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102beb:	e8 60 16 00 00       	call   80104250 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bf0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bf5:	85 c0                	test   %eax,%eax
80102bf7:	0f 8e 90 00 00 00    	jle    80102c8d <end_op+0xed>
80102bfd:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c00:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c05:	01 d8                	add    %ebx,%eax
80102c07:	83 c0 01             	add    $0x1,%eax
80102c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c0e:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c13:	89 04 24             	mov    %eax,(%esp)
80102c16:	e8 b5 d4 ff ff       	call   801000d0 <bread>
80102c1b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c1d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c24:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c27:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c2b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c30:	89 04 24             	mov    %eax,(%esp)
80102c33:	e8 98 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c38:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c3f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c40:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c42:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c45:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c49:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c4c:	89 04 24             	mov    %eax,(%esp)
80102c4f:	e8 ec 16 00 00       	call   80104340 <memmove>
    bwrite(to);  // write the log
80102c54:	89 34 24             	mov    %esi,(%esp)
80102c57:	e8 44 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c5c:	89 3c 24             	mov    %edi,(%esp)
80102c5f:	e8 7c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c64:	89 34 24             	mov    %esi,(%esp)
80102c67:	e8 74 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c6c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c72:	7c 8c                	jl     80102c00 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c74:	e8 a7 fd ff ff       	call   80102a20 <write_head>
    install_trans(); // Now install writes to home locations
80102c79:	e8 02 fd ff ff       	call   80102980 <install_trans>
    log.lh.n = 0;
80102c7e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c85:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c88:	e8 93 fd ff ff       	call   80102a20 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c8d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c94:	e8 c7 14 00 00       	call   80104160 <acquire>
    log.committing = 0;
80102c99:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102ca0:	00 00 00 
    wakeup(&log);
80102ca3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102caa:	e8 01 11 00 00       	call   80103db0 <wakeup>
    release(&log.lock);
80102caf:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cb6:	e8 95 15 00 00       	call   80104250 <release>
  }
}
80102cbb:	83 c4 1c             	add    $0x1c,%esp
80102cbe:	5b                   	pop    %ebx
80102cbf:	5e                   	pop    %esi
80102cc0:	5f                   	pop    %edi
80102cc1:	5d                   	pop    %ebp
80102cc2:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102cc3:	c7 04 24 a4 72 10 80 	movl   $0x801072a4,(%esp)
80102cca:	e8 91 d6 ff ff       	call   80100360 <panic>
80102ccf:	90                   	nop

80102cd0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cd7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cdf:	83 f8 1d             	cmp    $0x1d,%eax
80102ce2:	0f 8f 98 00 00 00    	jg     80102d80 <log_write+0xb0>
80102ce8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cee:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cf1:	39 d0                	cmp    %edx,%eax
80102cf3:	0f 8d 87 00 00 00    	jge    80102d80 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102cf9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cfe:	85 c0                	test   %eax,%eax
80102d00:	0f 8e 86 00 00 00    	jle    80102d8c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d06:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d0d:	e8 4e 14 00 00       	call   80104160 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d12:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d18:	83 fa 00             	cmp    $0x0,%edx
80102d1b:	7e 54                	jle    80102d71 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d1d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d20:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d22:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d28:	75 0f                	jne    80102d39 <log_write+0x69>
80102d2a:	eb 3c                	jmp    80102d68 <log_write+0x98>
80102d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d30:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d37:	74 2f                	je     80102d68 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d39:	83 c0 01             	add    $0x1,%eax
80102d3c:	39 d0                	cmp    %edx,%eax
80102d3e:	75 f0                	jne    80102d30 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d40:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d47:	83 c2 01             	add    $0x1,%edx
80102d4a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d50:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d53:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d5a:	83 c4 14             	add    $0x14,%esp
80102d5d:	5b                   	pop    %ebx
80102d5e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d5f:	e9 ec 14 00 00       	jmp    80104250 <release>
80102d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d68:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d6f:	eb df                	jmp    80102d50 <log_write+0x80>
80102d71:	8b 43 08             	mov    0x8(%ebx),%eax
80102d74:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d79:	75 d5                	jne    80102d50 <log_write+0x80>
80102d7b:	eb ca                	jmp    80102d47 <log_write+0x77>
80102d7d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102d80:	c7 04 24 b3 72 10 80 	movl   $0x801072b3,(%esp)
80102d87:	e8 d4 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102d8c:	c7 04 24 c9 72 10 80 	movl   $0x801072c9,(%esp)
80102d93:	e8 c8 d5 ff ff       	call   80100360 <panic>
80102d98:	66 90                	xchg   %ax,%ax
80102d9a:	66 90                	xchg   %ax,%ax
80102d9c:	66 90                	xchg   %ax,%ax
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102da7:	e8 f4 08 00 00       	call   801036a0 <cpuid>
80102dac:	89 c3                	mov    %eax,%ebx
80102dae:	e8 ed 08 00 00       	call   801036a0 <cpuid>
80102db3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102db7:	c7 04 24 e4 72 10 80 	movl   $0x801072e4,(%esp)
80102dbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102dc2:	e8 89 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102dc7:	e8 d4 28 00 00       	call   801056a0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dcc:	e8 4f 08 00 00       	call   80103620 <mycpu>
80102dd1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102dd3:	b8 01 00 00 00       	mov    $0x1,%eax
80102dd8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102ddf:	e8 9c 0b 00 00       	call   80103980 <scheduler>
80102de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102df0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102df6:	e8 65 39 00 00       	call   80106760 <switchkvm>
  seginit();
80102dfb:	e8 a0 38 00 00       	call   801066a0 <seginit>
  lapicinit();
80102e00:	e8 8b f8 ff ff       	call   80102690 <lapicinit>
  mpmain();
80102e05:	e8 96 ff ff ff       	call   80102da0 <mpmain>
80102e0a:	66 90                	xchg   %ax,%ax
80102e0c:	66 90                	xchg   %ax,%ax
80102e0e:	66 90                	xchg   %ax,%ax

80102e10 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e14:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e19:	83 e4 f0             	and    $0xfffffff0,%esp
80102e1c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e1f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e26:	80 
80102e27:	c7 04 24 a8 54 11 80 	movl   $0x801154a8,(%esp)
80102e2e:	e8 cd f5 ff ff       	call   80102400 <kinit1>
  kvmalloc();      // kernel page table
80102e33:	e8 b8 3d 00 00       	call   80106bf0 <kvmalloc>
  mpinit();        // detect other processors
80102e38:	e8 73 01 00 00       	call   80102fb0 <mpinit>
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e40:	e8 4b f8 ff ff       	call   80102690 <lapicinit>
  seginit();       // segment descriptors
80102e45:	e8 56 38 00 00       	call   801066a0 <seginit>
  picinit();       // disable pic
80102e4a:	e8 21 03 00 00       	call   80103170 <picinit>
80102e4f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e50:	e8 cb f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102e55:	e8 f6 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e5a:	e8 61 2b 00 00       	call   801059c0 <uartinit>
80102e5f:	90                   	nop
  pinit();         // process table
80102e60:	e8 9b 07 00 00       	call   80103600 <pinit>
  tvinit();        // trap vectors
80102e65:	e8 96 27 00 00       	call   80105600 <tvinit>
  binit();         // buffer cache
80102e6a:	e8 d1 d1 ff ff       	call   80100040 <binit>
80102e6f:	90                   	nop
  fileinit();      // file table
80102e70:	e8 db de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102e75:	e8 a6 f1 ff ff       	call   80102020 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e7a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e81:	00 
80102e82:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e89:	80 
80102e8a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e91:	e8 aa 14 00 00       	call   80104340 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102e96:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e9d:	00 00 00 
80102ea0:	05 80 27 11 80       	add    $0x80112780,%eax
80102ea5:	39 d8                	cmp    %ebx,%eax
80102ea7:	76 6a                	jbe    80102f13 <main+0x103>
80102ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102eb0:	e8 6b 07 00 00       	call   80103620 <mycpu>
80102eb5:	39 d8                	cmp    %ebx,%eax
80102eb7:	74 41                	je     80102efa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102eb9:	e8 02 f6 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102ebe:	c7 05 f8 6f 00 80 f0 	movl   $0x80102df0,0x80006ff8
80102ec5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ec8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ecf:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ed2:	05 00 10 00 00       	add    $0x1000,%eax
80102ed7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102edc:	0f b6 03             	movzbl (%ebx),%eax
80102edf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ee6:	00 
80102ee7:	89 04 24             	mov    %eax,(%esp)
80102eea:	e8 e1 f8 ff ff       	call   801027d0 <lapicstartap>
80102eef:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ef0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ef6:	85 c0                	test   %eax,%eax
80102ef8:	74 f6                	je     80102ef0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102efa:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f01:	00 00 00 
80102f04:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f0a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f0f:	39 c3                	cmp    %eax,%ebx
80102f11:	72 9d                	jb     80102eb0 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f13:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f1a:	8e 
80102f1b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f22:	e8 49 f5 ff ff       	call   80102470 <kinit2>
  userinit();      // first user process
80102f27:	e8 c4 07 00 00       	call   801036f0 <userinit>
  mpmain();        // finish this processor's setup
80102f2c:	e8 6f fe ff ff       	call   80102da0 <mpmain>
80102f31:	66 90                	xchg   %ax,%ax
80102f33:	66 90                	xchg   %ax,%ax
80102f35:	66 90                	xchg   %ax,%ax
80102f37:	66 90                	xchg   %ax,%ax
80102f39:	66 90                	xchg   %ax,%ax
80102f3b:	66 90                	xchg   %ax,%ax
80102f3d:	66 90                	xchg   %ax,%ax
80102f3f:	90                   	nop

80102f40 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f44:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f4a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f4b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f4e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f51:	39 de                	cmp    %ebx,%esi
80102f53:	73 3c                	jae    80102f91 <mpsearch1+0x51>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f58:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f5f:	00 
80102f60:	c7 44 24 04 f8 72 10 	movl   $0x801072f8,0x4(%esp)
80102f67:	80 
80102f68:	89 34 24             	mov    %esi,(%esp)
80102f6b:	e8 80 13 00 00       	call   801042f0 <memcmp>
80102f70:	85 c0                	test   %eax,%eax
80102f72:	75 16                	jne    80102f8a <mpsearch1+0x4a>
80102f74:	31 c9                	xor    %ecx,%ecx
80102f76:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102f78:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f7c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f7f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f81:	83 fa 10             	cmp    $0x10,%edx
80102f84:	75 f2                	jne    80102f78 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f86:	84 c9                	test   %cl,%cl
80102f88:	74 10                	je     80102f9a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f8a:	83 c6 10             	add    $0x10,%esi
80102f8d:	39 f3                	cmp    %esi,%ebx
80102f8f:	77 c7                	ja     80102f58 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102f91:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102f94:	31 c0                	xor    %eax,%eax
}
80102f96:	5b                   	pop    %ebx
80102f97:	5e                   	pop    %esi
80102f98:	5d                   	pop    %ebp
80102f99:	c3                   	ret    
80102f9a:	83 c4 10             	add    $0x10,%esp
80102f9d:	89 f0                	mov    %esi,%eax
80102f9f:	5b                   	pop    %ebx
80102fa0:	5e                   	pop    %esi
80102fa1:	5d                   	pop    %ebp
80102fa2:	c3                   	ret    
80102fa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fb0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	57                   	push   %edi
80102fb4:	56                   	push   %esi
80102fb5:	53                   	push   %ebx
80102fb6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fb9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fc0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fc7:	c1 e0 08             	shl    $0x8,%eax
80102fca:	09 d0                	or     %edx,%eax
80102fcc:	c1 e0 04             	shl    $0x4,%eax
80102fcf:	85 c0                	test   %eax,%eax
80102fd1:	75 1b                	jne    80102fee <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fd3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fda:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fe1:	c1 e0 08             	shl    $0x8,%eax
80102fe4:	09 d0                	or     %edx,%eax
80102fe6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fe9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
80102fee:	ba 00 04 00 00       	mov    $0x400,%edx
80102ff3:	e8 48 ff ff ff       	call   80102f40 <mpsearch1>
80102ff8:	85 c0                	test   %eax,%eax
80102ffa:	89 c7                	mov    %eax,%edi
80102ffc:	0f 84 22 01 00 00    	je     80103124 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103002:	8b 77 04             	mov    0x4(%edi),%esi
80103005:	85 f6                	test   %esi,%esi
80103007:	0f 84 30 01 00 00    	je     8010313d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010300d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103013:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010301a:	00 
8010301b:	c7 44 24 04 fd 72 10 	movl   $0x801072fd,0x4(%esp)
80103022:	80 
80103023:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103026:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103029:	e8 c2 12 00 00       	call   801042f0 <memcmp>
8010302e:	85 c0                	test   %eax,%eax
80103030:	0f 85 07 01 00 00    	jne    8010313d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103036:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010303d:	3c 04                	cmp    $0x4,%al
8010303f:	0f 85 0b 01 00 00    	jne    80103150 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103045:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010304c:	85 c0                	test   %eax,%eax
8010304e:	74 21                	je     80103071 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103050:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103052:	31 d2                	xor    %edx,%edx
80103054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103058:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010305f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103060:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103063:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103065:	39 d0                	cmp    %edx,%eax
80103067:	7f ef                	jg     80103058 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103069:	84 c9                	test   %cl,%cl
8010306b:	0f 85 cc 00 00 00    	jne    8010313d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103074:	85 c0                	test   %eax,%eax
80103076:	0f 84 c1 00 00 00    	je     8010313d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010307c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103082:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103087:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010308c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103093:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103099:	03 55 e4             	add    -0x1c(%ebp),%edx
8010309c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030a0:	39 c2                	cmp    %eax,%edx
801030a2:	76 1b                	jbe    801030bf <mpinit+0x10f>
801030a4:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
801030a7:	80 f9 04             	cmp    $0x4,%cl
801030aa:	77 74                	ja     80103120 <mpinit+0x170>
801030ac:	ff 24 8d 3c 73 10 80 	jmp    *-0x7fef8cc4(,%ecx,4)
801030b3:	90                   	nop
801030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030b8:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030bb:	39 c2                	cmp    %eax,%edx
801030bd:	77 e5                	ja     801030a4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030bf:	85 db                	test   %ebx,%ebx
801030c1:	0f 84 93 00 00 00    	je     8010315a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030c7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030cb:	74 12                	je     801030df <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030cd:	ba 22 00 00 00       	mov    $0x22,%edx
801030d2:	b8 70 00 00 00       	mov    $0x70,%eax
801030d7:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030d8:	b2 23                	mov    $0x23,%dl
801030da:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030db:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030de:	ee                   	out    %al,(%dx)
  }
}
801030df:	83 c4 1c             	add    $0x1c,%esp
801030e2:	5b                   	pop    %ebx
801030e3:	5e                   	pop    %esi
801030e4:	5f                   	pop    %edi
801030e5:	5d                   	pop    %ebp
801030e6:	c3                   	ret    
801030e7:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801030e8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030ee:	83 fe 07             	cmp    $0x7,%esi
801030f1:	7f 17                	jg     8010310a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030f3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030f7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030fd:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103104:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010310a:	83 c0 14             	add    $0x14,%eax
      continue;
8010310d:	eb 91                	jmp    801030a0 <mpinit+0xf0>
8010310f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103110:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103114:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103117:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
8010311d:	eb 81                	jmp    801030a0 <mpinit+0xf0>
8010311f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103120:	31 db                	xor    %ebx,%ebx
80103122:	eb 83                	jmp    801030a7 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103124:	ba 00 00 01 00       	mov    $0x10000,%edx
80103129:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010312e:	e8 0d fe ff ff       	call   80102f40 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103133:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103135:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103137:	0f 85 c5 fe ff ff    	jne    80103002 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010313d:	c7 04 24 02 73 10 80 	movl   $0x80107302,(%esp)
80103144:	e8 17 d2 ff ff       	call   80100360 <panic>
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103150:	3c 01                	cmp    $0x1,%al
80103152:	0f 84 ed fe ff ff    	je     80103045 <mpinit+0x95>
80103158:	eb e3                	jmp    8010313d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
8010315a:	c7 04 24 1c 73 10 80 	movl   $0x8010731c,(%esp)
80103161:	e8 fa d1 ff ff       	call   80100360 <panic>
80103166:	66 90                	xchg   %ax,%ax
80103168:	66 90                	xchg   %ax,%ax
8010316a:	66 90                	xchg   %ax,%ax
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103170:	55                   	push   %ebp
80103171:	ba 21 00 00 00       	mov    $0x21,%edx
80103176:	89 e5                	mov    %esp,%ebp
80103178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010317d:	ee                   	out    %al,(%dx)
8010317e:	b2 a1                	mov    $0xa1,%dl
80103180:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103181:	5d                   	pop    %ebp
80103182:	c3                   	ret    
80103183:	66 90                	xchg   %ax,%ax
80103185:	66 90                	xchg   %ax,%ax
80103187:	66 90                	xchg   %ax,%ax
80103189:	66 90                	xchg   %ax,%ax
8010318b:	66 90                	xchg   %ax,%ax
8010318d:	66 90                	xchg   %ax,%ax
8010318f:	90                   	nop

80103190 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
80103195:	53                   	push   %ebx
80103196:	83 ec 1c             	sub    $0x1c,%esp
80103199:	8b 75 08             	mov    0x8(%ebp),%esi
8010319c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010319f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031a5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031ab:	e8 c0 db ff ff       	call   80100d70 <filealloc>
801031b0:	85 c0                	test   %eax,%eax
801031b2:	89 06                	mov    %eax,(%esi)
801031b4:	0f 84 a4 00 00 00    	je     8010325e <pipealloc+0xce>
801031ba:	e8 b1 db ff ff       	call   80100d70 <filealloc>
801031bf:	85 c0                	test   %eax,%eax
801031c1:	89 03                	mov    %eax,(%ebx)
801031c3:	0f 84 87 00 00 00    	je     80103250 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031c9:	e8 f2 f2 ff ff       	call   801024c0 <kalloc>
801031ce:	85 c0                	test   %eax,%eax
801031d0:	89 c7                	mov    %eax,%edi
801031d2:	74 7c                	je     80103250 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031d4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031db:	00 00 00 
  p->writeopen = 1;
801031de:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031e5:	00 00 00 
  p->nwrite = 0;
801031e8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031ef:	00 00 00 
  p->nread = 0;
801031f2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031f9:	00 00 00 
  initlock(&p->lock, "pipe");
801031fc:	89 04 24             	mov    %eax,(%esp)
801031ff:	c7 44 24 04 50 73 10 	movl   $0x80107350,0x4(%esp)
80103206:	80 
80103207:	e8 64 0e 00 00       	call   80104070 <initlock>
  (*f0)->type = FD_PIPE;
8010320c:	8b 06                	mov    (%esi),%eax
8010320e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103214:	8b 06                	mov    (%esi),%eax
80103216:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010321a:	8b 06                	mov    (%esi),%eax
8010321c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103220:	8b 06                	mov    (%esi),%eax
80103222:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103225:	8b 03                	mov    (%ebx),%eax
80103227:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010322d:	8b 03                	mov    (%ebx),%eax
8010322f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103233:	8b 03                	mov    (%ebx),%eax
80103235:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103239:	8b 03                	mov    (%ebx),%eax
  return 0;
8010323b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010323d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103240:	83 c4 1c             	add    $0x1c,%esp
80103243:	89 d8                	mov    %ebx,%eax
80103245:	5b                   	pop    %ebx
80103246:	5e                   	pop    %esi
80103247:	5f                   	pop    %edi
80103248:	5d                   	pop    %ebp
80103249:	c3                   	ret    
8010324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103250:	8b 06                	mov    (%esi),%eax
80103252:	85 c0                	test   %eax,%eax
80103254:	74 08                	je     8010325e <pipealloc+0xce>
    fileclose(*f0);
80103256:	89 04 24             	mov    %eax,(%esp)
80103259:	e8 d2 db ff ff       	call   80100e30 <fileclose>
  if(*f1)
8010325e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103260:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103265:	85 c0                	test   %eax,%eax
80103267:	74 d7                	je     80103240 <pipealloc+0xb0>
    fileclose(*f1);
80103269:	89 04 24             	mov    %eax,(%esp)
8010326c:	e8 bf db ff ff       	call   80100e30 <fileclose>
  return -1;
}
80103271:	83 c4 1c             	add    $0x1c,%esp
80103274:	89 d8                	mov    %ebx,%eax
80103276:	5b                   	pop    %ebx
80103277:	5e                   	pop    %esi
80103278:	5f                   	pop    %edi
80103279:	5d                   	pop    %ebp
8010327a:	c3                   	ret    
8010327b:	90                   	nop
8010327c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103280 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	56                   	push   %esi
80103284:	53                   	push   %ebx
80103285:	83 ec 10             	sub    $0x10,%esp
80103288:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010328b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010328e:	89 1c 24             	mov    %ebx,(%esp)
80103291:	e8 ca 0e 00 00       	call   80104160 <acquire>
  if(writable){
80103296:	85 f6                	test   %esi,%esi
80103298:	74 3e                	je     801032d8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010329a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801032a0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032a7:	00 00 00 
    wakeup(&p->nread);
801032aa:	89 04 24             	mov    %eax,(%esp)
801032ad:	e8 fe 0a 00 00       	call   80103db0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032b2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032b8:	85 d2                	test   %edx,%edx
801032ba:	75 0a                	jne    801032c6 <pipeclose+0x46>
801032bc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 32                	je     801032f8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032c6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032c9:	83 c4 10             	add    $0x10,%esp
801032cc:	5b                   	pop    %ebx
801032cd:	5e                   	pop    %esi
801032ce:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032cf:	e9 7c 0f 00 00       	jmp    80104250 <release>
801032d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801032d8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801032de:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032e5:	00 00 00 
    wakeup(&p->nwrite);
801032e8:	89 04 24             	mov    %eax,(%esp)
801032eb:	e8 c0 0a 00 00       	call   80103db0 <wakeup>
801032f0:	eb c0                	jmp    801032b2 <pipeclose+0x32>
801032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801032f8:	89 1c 24             	mov    %ebx,(%esp)
801032fb:	e8 50 0f 00 00       	call   80104250 <release>
    kfree((char*)p);
80103300:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103303:	83 c4 10             	add    $0x10,%esp
80103306:	5b                   	pop    %ebx
80103307:	5e                   	pop    %esi
80103308:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103309:	e9 02 f0 ff ff       	jmp    80102310 <kfree>
8010330e:	66 90                	xchg   %ax,%ax

80103310 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103310:	55                   	push   %ebp
80103311:	89 e5                	mov    %esp,%ebp
80103313:	57                   	push   %edi
80103314:	56                   	push   %esi
80103315:	53                   	push   %ebx
80103316:	83 ec 1c             	sub    $0x1c,%esp
80103319:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010331c:	89 1c 24             	mov    %ebx,(%esp)
8010331f:	e8 3c 0e 00 00       	call   80104160 <acquire>
  for(i = 0; i < n; i++){
80103324:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103327:	85 c9                	test   %ecx,%ecx
80103329:	0f 8e b2 00 00 00    	jle    801033e1 <pipewrite+0xd1>
8010332f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103332:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103338:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010333e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103344:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103347:	03 4d 10             	add    0x10(%ebp),%ecx
8010334a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010334d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103353:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103359:	39 c8                	cmp    %ecx,%eax
8010335b:	74 38                	je     80103395 <pipewrite+0x85>
8010335d:	eb 55                	jmp    801033b4 <pipewrite+0xa4>
8010335f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103360:	e8 5b 03 00 00       	call   801036c0 <myproc>
80103365:	8b 40 24             	mov    0x24(%eax),%eax
80103368:	85 c0                	test   %eax,%eax
8010336a:	75 33                	jne    8010339f <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010336c:	89 3c 24             	mov    %edi,(%esp)
8010336f:	e8 3c 0a 00 00       	call   80103db0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103374:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103378:	89 34 24             	mov    %esi,(%esp)
8010337b:	e8 a0 08 00 00       	call   80103c20 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103380:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103386:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010338c:	05 00 02 00 00       	add    $0x200,%eax
80103391:	39 c2                	cmp    %eax,%edx
80103393:	75 23                	jne    801033b8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103395:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010339b:	85 d2                	test   %edx,%edx
8010339d:	75 c1                	jne    80103360 <pipewrite+0x50>
        release(&p->lock);
8010339f:	89 1c 24             	mov    %ebx,(%esp)
801033a2:	e8 a9 0e 00 00       	call   80104250 <release>
        return -1;
801033a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033ac:	83 c4 1c             	add    $0x1c,%esp
801033af:	5b                   	pop    %ebx
801033b0:	5e                   	pop    %esi
801033b1:	5f                   	pop    %edi
801033b2:	5d                   	pop    %ebp
801033b3:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033b4:	89 c2                	mov    %eax,%edx
801033b6:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033b8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033bb:	8d 42 01             	lea    0x1(%edx),%eax
801033be:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033c4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033ca:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033ce:	0f b6 09             	movzbl (%ecx),%ecx
801033d1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801033d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033d8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033db:	0f 85 6c ff ff ff    	jne    8010334d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033e1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033e7:	89 04 24             	mov    %eax,(%esp)
801033ea:	e8 c1 09 00 00       	call   80103db0 <wakeup>
  release(&p->lock);
801033ef:	89 1c 24             	mov    %ebx,(%esp)
801033f2:	e8 59 0e 00 00       	call   80104250 <release>
  return n;
801033f7:	8b 45 10             	mov    0x10(%ebp),%eax
801033fa:	eb b0                	jmp    801033ac <pipewrite+0x9c>
801033fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103400 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 1c             	sub    $0x1c,%esp
80103409:	8b 75 08             	mov    0x8(%ebp),%esi
8010340c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010340f:	89 34 24             	mov    %esi,(%esp)
80103412:	e8 49 0d 00 00       	call   80104160 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103417:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010341d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103423:	75 5b                	jne    80103480 <piperead+0x80>
80103425:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010342b:	85 db                	test   %ebx,%ebx
8010342d:	74 51                	je     80103480 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010342f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103435:	eb 25                	jmp    8010345c <piperead+0x5c>
80103437:	90                   	nop
80103438:	89 74 24 04          	mov    %esi,0x4(%esp)
8010343c:	89 1c 24             	mov    %ebx,(%esp)
8010343f:	e8 dc 07 00 00       	call   80103c20 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103444:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010344a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103450:	75 2e                	jne    80103480 <piperead+0x80>
80103452:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103458:	85 d2                	test   %edx,%edx
8010345a:	74 24                	je     80103480 <piperead+0x80>
    if(myproc()->killed){
8010345c:	e8 5f 02 00 00       	call   801036c0 <myproc>
80103461:	8b 48 24             	mov    0x24(%eax),%ecx
80103464:	85 c9                	test   %ecx,%ecx
80103466:	74 d0                	je     80103438 <piperead+0x38>
      release(&p->lock);
80103468:	89 34 24             	mov    %esi,(%esp)
8010346b:	e8 e0 0d 00 00       	call   80104250 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103470:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103478:	5b                   	pop    %ebx
80103479:	5e                   	pop    %esi
8010347a:	5f                   	pop    %edi
8010347b:	5d                   	pop    %ebp
8010347c:	c3                   	ret    
8010347d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103480:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103483:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103485:	85 d2                	test   %edx,%edx
80103487:	7f 2b                	jg     801034b4 <piperead+0xb4>
80103489:	eb 31                	jmp    801034bc <piperead+0xbc>
8010348b:	90                   	nop
8010348c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103490:	8d 48 01             	lea    0x1(%eax),%ecx
80103493:	25 ff 01 00 00       	and    $0x1ff,%eax
80103498:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010349e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801034a3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034a6:	83 c3 01             	add    $0x1,%ebx
801034a9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801034ac:	74 0e                	je     801034bc <piperead+0xbc>
    if(p->nread == p->nwrite)
801034ae:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034b4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034ba:	75 d4                	jne    80103490 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034bc:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034c2:	89 04 24             	mov    %eax,(%esp)
801034c5:	e8 e6 08 00 00       	call   80103db0 <wakeup>
  release(&p->lock);
801034ca:	89 34 24             	mov    %esi,(%esp)
801034cd:	e8 7e 0d 00 00       	call   80104250 <release>
  return i;
}
801034d2:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
801034d5:	89 d8                	mov    %ebx,%eax
}
801034d7:	5b                   	pop    %ebx
801034d8:	5e                   	pop    %esi
801034d9:	5f                   	pop    %edi
801034da:	5d                   	pop    %ebp
801034db:	c3                   	ret    
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034e4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034e9:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801034ec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034f3:	e8 68 0c 00 00       	call   80104160 <acquire>
801034f8:	eb 11                	jmp    8010350b <allocproc+0x2b>
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103500:	83 c3 7c             	add    $0x7c,%ebx
80103503:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103509:	74 7d                	je     80103588 <allocproc+0xa8>
    if(p->state == UNUSED)
8010350b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010350e:	85 c0                	test   %eax,%eax
80103510:	75 ee                	jne    80103500 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103512:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103517:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010351e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103525:	8d 50 01             	lea    0x1(%eax),%edx
80103528:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010352e:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103531:	e8 1a 0d 00 00       	call   80104250 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103536:	e8 85 ef ff ff       	call   801024c0 <kalloc>
8010353b:	85 c0                	test   %eax,%eax
8010353d:	89 43 08             	mov    %eax,0x8(%ebx)
80103540:	74 5a                	je     8010359c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103542:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103548:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010354d:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103550:	c7 40 14 f5 55 10 80 	movl   $0x801055f5,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103557:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010355e:	00 
8010355f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103566:	00 
80103567:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010356a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010356d:	e8 2e 0d 00 00       	call   801042a0 <memset>
  p->context->eip = (uint)forkret;
80103572:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103575:	c7 40 10 b0 35 10 80 	movl   $0x801035b0,0x10(%eax)

  return p;
8010357c:	89 d8                	mov    %ebx,%eax
}
8010357e:	83 c4 14             	add    $0x14,%esp
80103581:	5b                   	pop    %ebx
80103582:	5d                   	pop    %ebp
80103583:	c3                   	ret    
80103584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103588:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010358f:	e8 bc 0c 00 00       	call   80104250 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103594:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
80103597:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103599:	5b                   	pop    %ebx
8010359a:	5d                   	pop    %ebp
8010359b:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010359c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035a3:	eb d9                	jmp    8010357e <allocproc+0x9e>
801035a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035b6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035bd:	e8 8e 0c 00 00       	call   80104250 <release>

  if (first) {
801035c2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035c7:	85 c0                	test   %eax,%eax
801035c9:	75 05                	jne    801035d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035cb:	c9                   	leave  
801035cc:	c3                   	ret    
801035cd:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801035d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801035d7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035de:	00 00 00 
    iinit(ROOTDEV);
801035e1:	e8 9a de ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801035e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035ed:	e8 9e f4 ff ff       	call   80102a90 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035f2:	c9                   	leave  
801035f3:	c3                   	ret    
801035f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103600 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103606:	c7 44 24 04 55 73 10 	movl   $0x80107355,0x4(%esp)
8010360d:	80 
8010360e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103615:	e8 56 0a 00 00       	call   80104070 <initlock>
}
8010361a:	c9                   	leave  
8010361b:	c3                   	ret    
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103620 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	56                   	push   %esi
80103624:	53                   	push   %ebx
80103625:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103628:	9c                   	pushf  
80103629:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010362a:	f6 c4 02             	test   $0x2,%ah
8010362d:	75 57                	jne    80103686 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010362f:	e8 4c f1 ff ff       	call   80102780 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103634:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010363a:	85 f6                	test   %esi,%esi
8010363c:	7e 3c                	jle    8010367a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010363e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103645:	39 c2                	cmp    %eax,%edx
80103647:	74 2d                	je     80103676 <mycpu+0x56>
80103649:	b9 30 28 11 80       	mov    $0x80112830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010364e:	31 d2                	xor    %edx,%edx
80103650:	83 c2 01             	add    $0x1,%edx
80103653:	39 f2                	cmp    %esi,%edx
80103655:	74 23                	je     8010367a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103657:	0f b6 19             	movzbl (%ecx),%ebx
8010365a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103660:	39 c3                	cmp    %eax,%ebx
80103662:	75 ec                	jne    80103650 <mycpu+0x30>
      return &cpus[i];
80103664:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010366a:	83 c4 10             	add    $0x10,%esp
8010366d:	5b                   	pop    %ebx
8010366e:	5e                   	pop    %esi
8010366f:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103670:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103675:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103676:	31 d2                	xor    %edx,%edx
80103678:	eb ea                	jmp    80103664 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010367a:	c7 04 24 5c 73 10 80 	movl   $0x8010735c,(%esp)
80103681:	e8 da cc ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103686:	c7 04 24 38 74 10 80 	movl   $0x80107438,(%esp)
8010368d:	e8 ce cc ff ff       	call   80100360 <panic>
80103692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036a0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036a6:	e8 75 ff ff ff       	call   80103620 <mycpu>
}
801036ab:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801036ac:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036b1:	c1 f8 04             	sar    $0x4,%eax
801036b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ba:	c3                   	ret    
801036bb:	90                   	nop
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036c0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	53                   	push   %ebx
801036c4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801036c7:	e8 54 0a 00 00       	call   80104120 <pushcli>
  c = mycpu();
801036cc:	e8 4f ff ff ff       	call   80103620 <mycpu>
  p = c->proc;
801036d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036d7:	e8 04 0b 00 00       	call   801041e0 <popcli>
  return p;
}
801036dc:	83 c4 04             	add    $0x4,%esp
801036df:	89 d8                	mov    %ebx,%eax
801036e1:	5b                   	pop    %ebx
801036e2:	5d                   	pop    %ebp
801036e3:	c3                   	ret    
801036e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036f0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
801036f4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801036f7:	e8 e4 fd ff ff       	call   801034e0 <allocproc>
801036fc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801036fe:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103703:	e8 58 34 00 00       	call   80106b60 <setupkvm>
80103708:	85 c0                	test   %eax,%eax
8010370a:	89 43 04             	mov    %eax,0x4(%ebx)
8010370d:	0f 84 d4 00 00 00    	je     801037e7 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103713:	89 04 24             	mov    %eax,(%esp)
80103716:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010371d:	00 
8010371e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103725:	80 
80103726:	e8 65 31 00 00       	call   80106890 <inituvm>
  p->sz = PGSIZE;
8010372b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103731:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103738:	00 
80103739:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103740:	00 
80103741:	8b 43 18             	mov    0x18(%ebx),%eax
80103744:	89 04 24             	mov    %eax,(%esp)
80103747:	e8 54 0b 00 00       	call   801042a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010374c:	8b 43 18             	mov    0x18(%ebx),%eax
8010374f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103754:	b9 23 00 00 00       	mov    $0x23,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103759:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010375d:	8b 43 18             	mov    0x18(%ebx),%eax
80103760:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103764:	8b 43 18             	mov    0x18(%ebx),%eax
80103767:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010376b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010376f:	8b 43 18             	mov    0x18(%ebx),%eax
80103772:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103776:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010377a:	8b 43 18             	mov    0x18(%ebx),%eax
8010377d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103784:	8b 43 18             	mov    0x18(%ebx),%eax
80103787:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010378e:	8b 43 18             	mov    0x18(%ebx),%eax
80103791:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103798:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010379b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037a2:	00 
801037a3:	c7 44 24 04 85 73 10 	movl   $0x80107385,0x4(%esp)
801037aa:	80 
801037ab:	89 04 24             	mov    %eax,(%esp)
801037ae:	e8 cd 0c 00 00       	call   80104480 <safestrcpy>
  p->cwd = namei("/");
801037b3:	c7 04 24 8e 73 10 80 	movl   $0x8010738e,(%esp)
801037ba:	e8 61 e7 ff ff       	call   80101f20 <namei>
801037bf:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801037c2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037c9:	e8 92 09 00 00       	call   80104160 <acquire>

  p->state = RUNNABLE;
801037ce:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801037d5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037dc:	e8 6f 0a 00 00       	call   80104250 <release>
}
801037e1:	83 c4 14             	add    $0x14,%esp
801037e4:	5b                   	pop    %ebx
801037e5:	5d                   	pop    %ebp
801037e6:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801037e7:	c7 04 24 6c 73 10 80 	movl   $0x8010736c,(%esp)
801037ee:	e8 6d cb ff ff       	call   80100360 <panic>
801037f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
80103805:	83 ec 10             	sub    $0x10,%esp
80103808:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
8010380b:	e8 b0 fe ff ff       	call   801036c0 <myproc>

  sz = curproc->sz;
  if(n > 0){
80103810:	83 fe 00             	cmp    $0x0,%esi
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
80103813:	89 c3                	mov    %eax,%ebx

  sz = curproc->sz;
80103815:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103817:	7e 2f                	jle    80103848 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103819:	01 c6                	add    %eax,%esi
8010381b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010381f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103823:	8b 43 04             	mov    0x4(%ebx),%eax
80103826:	89 04 24             	mov    %eax,(%esp)
80103829:	e8 a2 31 00 00       	call   801069d0 <allocuvm>
8010382e:	85 c0                	test   %eax,%eax
80103830:	74 36                	je     80103868 <growproc+0x68>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103832:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103834:	89 1c 24             	mov    %ebx,(%esp)
80103837:	e8 44 2f 00 00       	call   80106780 <switchuvm>
  return 0;
8010383c:	31 c0                	xor    %eax,%eax
}
8010383e:	83 c4 10             	add    $0x10,%esp
80103841:	5b                   	pop    %ebx
80103842:	5e                   	pop    %esi
80103843:	5d                   	pop    %ebp
80103844:	c3                   	ret    
80103845:	8d 76 00             	lea    0x0(%esi),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103848:	74 e8                	je     80103832 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010384a:	01 c6                	add    %eax,%esi
8010384c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103850:	89 44 24 04          	mov    %eax,0x4(%esp)
80103854:	8b 43 04             	mov    0x4(%ebx),%eax
80103857:	89 04 24             	mov    %eax,(%esp)
8010385a:	e8 61 32 00 00       	call   80106ac0 <deallocuvm>
8010385f:	85 c0                	test   %eax,%eax
80103861:	75 cf                	jne    80103832 <growproc+0x32>
80103863:	90                   	nop
80103864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010386d:	eb cf                	jmp    8010383e <growproc+0x3e>
8010386f:	90                   	nop

80103870 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	57                   	push   %edi
80103874:	56                   	push   %esi
80103875:	53                   	push   %ebx
80103876:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103879:	e8 42 fe ff ff       	call   801036c0 <myproc>
8010387e:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
80103880:	e8 5b fc ff ff       	call   801034e0 <allocproc>
80103885:	85 c0                	test   %eax,%eax
80103887:	89 c7                	mov    %eax,%edi
80103889:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010388c:	0f 84 bc 00 00 00    	je     8010394e <fork+0xde>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103892:	8b 03                	mov    (%ebx),%eax
80103894:	89 44 24 04          	mov    %eax,0x4(%esp)
80103898:	8b 43 04             	mov    0x4(%ebx),%eax
8010389b:	89 04 24             	mov    %eax,(%esp)
8010389e:	e8 9d 33 00 00       	call   80106c40 <copyuvm>
801038a3:	85 c0                	test   %eax,%eax
801038a5:	89 47 04             	mov    %eax,0x4(%edi)
801038a8:	0f 84 a7 00 00 00    	je     80103955 <fork+0xe5>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801038ae:	8b 03                	mov    (%ebx),%eax
801038b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038b3:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
801038b5:	8b 79 18             	mov    0x18(%ecx),%edi
801038b8:	89 c8                	mov    %ecx,%eax
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
801038ba:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801038bd:	8b 73 18             	mov    0x18(%ebx),%esi
801038c0:	b9 13 00 00 00       	mov    $0x13,%ecx
801038c5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801038c7:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801038c9:	8b 40 18             	mov    0x18(%eax),%eax
801038cc:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038d3:	90                   	nop
801038d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801038d8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038dc:	85 c0                	test   %eax,%eax
801038de:	74 0f                	je     801038ef <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038e0:	89 04 24             	mov    %eax,(%esp)
801038e3:	e8 f8 d4 ff ff       	call   80100de0 <filedup>
801038e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038eb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801038ef:	83 c6 01             	add    $0x1,%esi
801038f2:	83 fe 10             	cmp    $0x10,%esi
801038f5:	75 e1                	jne    801038d8 <fork+0x68>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801038f7:	8b 43 68             	mov    0x68(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038fa:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801038fd:	89 04 24             	mov    %eax,(%esp)
80103900:	e8 9b dd ff ff       	call   801016a0 <idup>
80103905:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103908:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010390b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010390e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103912:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103919:	00 
8010391a:	89 04 24             	mov    %eax,(%esp)
8010391d:	e8 5e 0b 00 00       	call   80104480 <safestrcpy>

  pid = np->pid;
80103922:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103925:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010392c:	e8 2f 08 00 00       	call   80104160 <acquire>

  np->state = RUNNABLE;
80103931:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103938:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010393f:	e8 0c 09 00 00       	call   80104250 <release>

  return pid;
80103944:	89 d8                	mov    %ebx,%eax
}
80103946:	83 c4 1c             	add    $0x1c,%esp
80103949:	5b                   	pop    %ebx
8010394a:	5e                   	pop    %esi
8010394b:	5f                   	pop    %edi
8010394c:	5d                   	pop    %ebp
8010394d:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
8010394e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103953:	eb f1                	jmp    80103946 <fork+0xd6>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103955:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103958:	8b 47 08             	mov    0x8(%edi),%eax
8010395b:	89 04 24             	mov    %eax,(%esp)
8010395e:	e8 ad e9 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103963:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103968:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010396f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103976:	eb ce                	jmp    80103946 <fork+0xd6>
80103978:	90                   	nop
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103980 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	53                   	push   %ebx
80103986:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103989:	e8 92 fc ff ff       	call   80103620 <mycpu>
8010398e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103990:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103997:	00 00 00 
8010399a:	8d 78 04             	lea    0x4(%eax),%edi
8010399d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
801039a0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801039a1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801039ad:	e8 ae 07 00 00       	call   80104160 <acquire>
801039b2:	eb 0f                	jmp    801039c3 <scheduler+0x43>
801039b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b8:	83 c3 7c             	add    $0x7c,%ebx
801039bb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801039c1:	74 45                	je     80103a08 <scheduler+0x88>
      if(p->state != RUNNABLE)
801039c3:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039c7:	75 ef                	jne    801039b8 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801039c9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039cf:	89 1c 24             	mov    %ebx,(%esp)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d2:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
801039d5:	e8 a6 2d 00 00       	call   80106780 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
801039da:	8b 43 a0             	mov    -0x60(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
801039dd:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
801039e4:	89 3c 24             	mov    %edi,(%esp)
801039e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801039eb:	e8 eb 0a 00 00       	call   801044db <swtch>
      switchkvm();
801039f0:	e8 6b 2d 00 00       	call   80106760 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039f5:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
801039fb:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a02:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a05:	75 bc                	jne    801039c3 <scheduler+0x43>
80103a07:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103a08:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a0f:	e8 3c 08 00 00       	call   80104250 <release>

  }
80103a14:	eb 8a                	jmp    801039a0 <scheduler+0x20>
80103a16:	8d 76 00             	lea    0x0(%esi),%esi
80103a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a20 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	56                   	push   %esi
80103a24:	53                   	push   %ebx
80103a25:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103a28:	e8 93 fc ff ff       	call   801036c0 <myproc>

  if(!holding(&ptable.lock))
80103a2d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103a34:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103a36:	e8 b5 06 00 00       	call   801040f0 <holding>
80103a3b:	85 c0                	test   %eax,%eax
80103a3d:	74 4f                	je     80103a8e <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103a3f:	e8 dc fb ff ff       	call   80103620 <mycpu>
80103a44:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a4b:	75 65                	jne    80103ab2 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103a4d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a51:	74 53                	je     80103aa6 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a53:	9c                   	pushf  
80103a54:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103a55:	f6 c4 02             	test   $0x2,%ah
80103a58:	75 40                	jne    80103a9a <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103a5a:	e8 c1 fb ff ff       	call   80103620 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a5f:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103a62:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a68:	e8 b3 fb ff ff       	call   80103620 <mycpu>
80103a6d:	8b 40 04             	mov    0x4(%eax),%eax
80103a70:	89 1c 24             	mov    %ebx,(%esp)
80103a73:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a77:	e8 5f 0a 00 00       	call   801044db <swtch>
  mycpu()->intena = intena;
80103a7c:	e8 9f fb ff ff       	call   80103620 <mycpu>
80103a81:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a87:	83 c4 10             	add    $0x10,%esp
80103a8a:	5b                   	pop    %ebx
80103a8b:	5e                   	pop    %esi
80103a8c:	5d                   	pop    %ebp
80103a8d:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103a8e:	c7 04 24 90 73 10 80 	movl   $0x80107390,(%esp)
80103a95:	e8 c6 c8 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103a9a:	c7 04 24 bc 73 10 80 	movl   $0x801073bc,(%esp)
80103aa1:	e8 ba c8 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103aa6:	c7 04 24 ae 73 10 80 	movl   $0x801073ae,(%esp)
80103aad:	e8 ae c8 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103ab2:	c7 04 24 a2 73 10 80 	movl   $0x801073a2,(%esp)
80103ab9:	e8 a2 c8 ff ff       	call   80100360 <panic>
80103abe:	66 90                	xchg   %ax,%ax

80103ac0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103ac4:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103ac6:	53                   	push   %ebx
80103ac7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103aca:	e8 f1 fb ff ff       	call   801036c0 <myproc>
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103acf:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103ad5:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103ad7:	0f 84 ea 00 00 00    	je     80103bc7 <exit+0x107>
80103add:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103ae0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ae4:	85 c0                	test   %eax,%eax
80103ae6:	74 10                	je     80103af8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103ae8:	89 04 24             	mov    %eax,(%esp)
80103aeb:	e8 40 d3 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103af0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103af7:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103af8:	83 c6 01             	add    $0x1,%esi
80103afb:	83 fe 10             	cmp    $0x10,%esi
80103afe:	75 e0                	jne    80103ae0 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103b00:	e8 2b f0 ff ff       	call   80102b30 <begin_op>
  iput(curproc->cwd);
80103b05:	8b 43 68             	mov    0x68(%ebx),%eax
80103b08:	89 04 24             	mov    %eax,(%esp)
80103b0b:	e8 e0 dc ff ff       	call   801017f0 <iput>
  end_op();
80103b10:	e8 8b f0 ff ff       	call   80102ba0 <end_op>
  curproc->cwd = 0;
80103b15:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103b1c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b23:	e8 38 06 00 00       	call   80104160 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103b28:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b2b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b30:	eb 11                	jmp    80103b43 <exit+0x83>
80103b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b38:	83 c2 7c             	add    $0x7c,%edx
80103b3b:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103b41:	74 1d                	je     80103b60 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103b43:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b47:	75 ef                	jne    80103b38 <exit+0x78>
80103b49:	3b 42 20             	cmp    0x20(%edx),%eax
80103b4c:	75 ea                	jne    80103b38 <exit+0x78>
      p->state = RUNNABLE;
80103b4e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b55:	83 c2 7c             	add    $0x7c,%edx
80103b58:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103b5e:	75 e3                	jne    80103b43 <exit+0x83>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103b60:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b65:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b6a:	eb 0f                	jmp    80103b7b <exit+0xbb>
80103b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b70:	83 c1 7c             	add    $0x7c,%ecx
80103b73:	81 f9 54 4c 11 80    	cmp    $0x80114c54,%ecx
80103b79:	74 34                	je     80103baf <exit+0xef>
    if(p->parent == curproc){
80103b7b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b7e:	75 f0                	jne    80103b70 <exit+0xb0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103b80:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103b84:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103b87:	75 e7                	jne    80103b70 <exit+0xb0>
80103b89:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b8e:	eb 0b                	jmp    80103b9b <exit+0xdb>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b90:	83 c2 7c             	add    $0x7c,%edx
80103b93:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103b99:	74 d5                	je     80103b70 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103b9b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b9f:	75 ef                	jne    80103b90 <exit+0xd0>
80103ba1:	3b 42 20             	cmp    0x20(%edx),%eax
80103ba4:	75 ea                	jne    80103b90 <exit+0xd0>
      p->state = RUNNABLE;
80103ba6:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103bad:	eb e1                	jmp    80103b90 <exit+0xd0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103baf:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103bb6:	e8 65 fe ff ff       	call   80103a20 <sched>
  panic("zombie exit");
80103bbb:	c7 04 24 dd 73 10 80 	movl   $0x801073dd,(%esp)
80103bc2:	e8 99 c7 ff ff       	call   80100360 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103bc7:	c7 04 24 d0 73 10 80 	movl   $0x801073d0,(%esp)
80103bce:	e8 8d c7 ff ff       	call   80100360 <panic>
80103bd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103be0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103be6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bed:	e8 6e 05 00 00       	call   80104160 <acquire>
  myproc()->state = RUNNABLE;
80103bf2:	e8 c9 fa ff ff       	call   801036c0 <myproc>
80103bf7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103bfe:	e8 1d fe ff ff       	call   80103a20 <sched>
  release(&ptable.lock);
80103c03:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c0a:	e8 41 06 00 00       	call   80104250 <release>
}
80103c0f:	c9                   	leave  
80103c10:	c3                   	ret    
80103c11:	eb 0d                	jmp    80103c20 <sleep>
80103c13:	90                   	nop
80103c14:	90                   	nop
80103c15:	90                   	nop
80103c16:	90                   	nop
80103c17:	90                   	nop
80103c18:	90                   	nop
80103c19:	90                   	nop
80103c1a:	90                   	nop
80103c1b:	90                   	nop
80103c1c:	90                   	nop
80103c1d:	90                   	nop
80103c1e:	90                   	nop
80103c1f:	90                   	nop

80103c20 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	57                   	push   %edi
80103c24:	56                   	push   %esi
80103c25:	53                   	push   %ebx
80103c26:	83 ec 1c             	sub    $0x1c,%esp
80103c29:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c2f:	e8 8c fa ff ff       	call   801036c0 <myproc>
  
  if(p == 0)
80103c34:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103c36:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103c38:	0f 84 7c 00 00 00    	je     80103cba <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103c3e:	85 f6                	test   %esi,%esi
80103c40:	74 6c                	je     80103cae <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c42:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c48:	74 46                	je     80103c90 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c4a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c51:	e8 0a 05 00 00       	call   80104160 <acquire>
    release(lk);
80103c56:	89 34 24             	mov    %esi,(%esp)
80103c59:	e8 f2 05 00 00       	call   80104250 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103c5e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c61:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103c68:	e8 b3 fd ff ff       	call   80103a20 <sched>

  // Tidy up.
  p->chan = 0;
80103c6d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103c74:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c7b:	e8 d0 05 00 00       	call   80104250 <release>
    acquire(lk);
80103c80:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103c83:	83 c4 1c             	add    $0x1c,%esp
80103c86:	5b                   	pop    %ebx
80103c87:	5e                   	pop    %esi
80103c88:	5f                   	pop    %edi
80103c89:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103c8a:	e9 d1 04 00 00       	jmp    80104160 <acquire>
80103c8f:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103c90:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103c93:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103c9a:	e8 81 fd ff ff       	call   80103a20 <sched>

  // Tidy up.
  p->chan = 0;
80103c9f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103ca6:	83 c4 1c             	add    $0x1c,%esp
80103ca9:	5b                   	pop    %ebx
80103caa:	5e                   	pop    %esi
80103cab:	5f                   	pop    %edi
80103cac:	5d                   	pop    %ebp
80103cad:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103cae:	c7 04 24 ef 73 10 80 	movl   $0x801073ef,(%esp)
80103cb5:	e8 a6 c6 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103cba:	c7 04 24 e9 73 10 80 	movl   $0x801073e9,(%esp)
80103cc1:	e8 9a c6 ff ff       	call   80100360 <panic>
80103cc6:	8d 76 00             	lea    0x0(%esi),%esi
80103cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cd0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	56                   	push   %esi
80103cd4:	53                   	push   %ebx
80103cd5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103cd8:	e8 e3 f9 ff ff       	call   801036c0 <myproc>
  
  acquire(&ptable.lock);
80103cdd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103ce4:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103ce6:	e8 75 04 00 00       	call   80104160 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103ceb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ced:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103cf2:	eb 0f                	jmp    80103d03 <wait+0x33>
80103cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cf8:	83 c3 7c             	add    $0x7c,%ebx
80103cfb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103d01:	74 1d                	je     80103d20 <wait+0x50>
      if(p->parent != curproc)
80103d03:	39 73 14             	cmp    %esi,0x14(%ebx)
80103d06:	75 f0                	jne    80103cf8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103d08:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d0c:	74 2f                	je     80103d3d <wait+0x6d>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d0e:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103d11:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d16:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103d1c:	75 e5                	jne    80103d03 <wait+0x33>
80103d1e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103d20:	85 c0                	test   %eax,%eax
80103d22:	74 6e                	je     80103d92 <wait+0xc2>
80103d24:	8b 46 24             	mov    0x24(%esi),%eax
80103d27:	85 c0                	test   %eax,%eax
80103d29:	75 67                	jne    80103d92 <wait+0xc2>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d2b:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d32:	80 
80103d33:	89 34 24             	mov    %esi,(%esp)
80103d36:	e8 e5 fe ff ff       	call   80103c20 <sleep>
  }
80103d3b:	eb ae                	jmp    80103ceb <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103d3d:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103d40:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d43:	89 04 24             	mov    %eax,(%esp)
80103d46:	e8 c5 e5 ff ff       	call   80102310 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103d4b:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103d4e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d55:	89 04 24             	mov    %eax,(%esp)
80103d58:	e8 83 2d 00 00       	call   80106ae0 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103d5d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103d64:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d6b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103d72:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103d76:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103d7d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103d84:	e8 c7 04 00 00       	call   80104250 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103d89:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103d8c:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103d8e:	5b                   	pop    %ebx
80103d8f:	5e                   	pop    %esi
80103d90:	5d                   	pop    %ebp
80103d91:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103d92:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d99:	e8 b2 04 00 00       	call   80104250 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103d9e:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103da1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103da6:	5b                   	pop    %ebx
80103da7:	5e                   	pop    %esi
80103da8:	5d                   	pop    %ebp
80103da9:	c3                   	ret    
80103daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103db0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	53                   	push   %ebx
80103db4:	83 ec 14             	sub    $0x14,%esp
80103db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103dba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dc1:	e8 9a 03 00 00       	call   80104160 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dcb:	eb 0d                	jmp    80103dda <wakeup+0x2a>
80103dcd:	8d 76 00             	lea    0x0(%esi),%esi
80103dd0:	83 c0 7c             	add    $0x7c,%eax
80103dd3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103dd8:	74 1e                	je     80103df8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103dda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dde:	75 f0                	jne    80103dd0 <wakeup+0x20>
80103de0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103de3:	75 eb                	jne    80103dd0 <wakeup+0x20>
      p->state = RUNNABLE;
80103de5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dec:	83 c0 7c             	add    $0x7c,%eax
80103def:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103df4:	75 e4                	jne    80103dda <wakeup+0x2a>
80103df6:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103df8:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103dff:	83 c4 14             	add    $0x14,%esp
80103e02:	5b                   	pop    %ebx
80103e03:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103e04:	e9 47 04 00 00       	jmp    80104250 <release>
80103e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e10 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	53                   	push   %ebx
80103e14:	83 ec 14             	sub    $0x14,%esp
80103e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e1a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e21:	e8 3a 03 00 00       	call   80104160 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e26:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e2b:	eb 0d                	jmp    80103e3a <kill+0x2a>
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
80103e30:	83 c0 7c             	add    $0x7c,%eax
80103e33:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e38:	74 36                	je     80103e70 <kill+0x60>
    if(p->pid == pid){
80103e3a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e3d:	75 f1                	jne    80103e30 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e3f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103e43:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e4a:	74 14                	je     80103e60 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e4c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e53:	e8 f8 03 00 00       	call   80104250 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e58:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103e5b:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e5d:	5b                   	pop    %ebx
80103e5e:	5d                   	pop    %ebp
80103e5f:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103e60:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e67:	eb e3                	jmp    80103e4c <kill+0x3c>
80103e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103e70:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e77:	e8 d4 03 00 00       	call   80104250 <release>
  return -1;
}
80103e7c:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103e7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e84:	5b                   	pop    %ebx
80103e85:	5d                   	pop    %ebp
80103e86:	c3                   	ret    
80103e87:	89 f6                	mov    %esi,%esi
80103e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e90 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103e9b:	83 ec 4c             	sub    $0x4c,%esp
80103e9e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ea1:	eb 20                	jmp    80103ec3 <procdump+0x33>
80103ea3:	90                   	nop
80103ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ea8:	c7 04 24 e3 77 10 80 	movl   $0x801077e3,(%esp)
80103eaf:	e8 9c c7 ff ff       	call   80100650 <cprintf>
80103eb4:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb7:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80103ebd:	0f 84 8d 00 00 00    	je     80103f50 <procdump+0xc0>
    if(p->state == UNUSED)
80103ec3:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103ec6:	85 c0                	test   %eax,%eax
80103ec8:	74 ea                	je     80103eb4 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103eca:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103ecd:	ba 00 74 10 80       	mov    $0x80107400,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ed2:	77 11                	ja     80103ee5 <procdump+0x55>
80103ed4:	8b 14 85 60 74 10 80 	mov    -0x7fef8ba0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103edb:	b8 00 74 10 80       	mov    $0x80107400,%eax
80103ee0:	85 d2                	test   %edx,%edx
80103ee2:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103ee5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103ee8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103eec:	89 54 24 08          	mov    %edx,0x8(%esp)
80103ef0:	c7 04 24 04 74 10 80 	movl   $0x80107404,(%esp)
80103ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103efb:	e8 50 c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103f00:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f04:	75 a2                	jne    80103ea8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f06:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f09:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f0d:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f10:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f13:	8b 40 0c             	mov    0xc(%eax),%eax
80103f16:	83 c0 08             	add    $0x8,%eax
80103f19:	89 04 24             	mov    %eax,(%esp)
80103f1c:	e8 6f 01 00 00       	call   80104090 <getcallerpcs>
80103f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f28:	8b 17                	mov    (%edi),%edx
80103f2a:	85 d2                	test   %edx,%edx
80103f2c:	0f 84 76 ff ff ff    	je     80103ea8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f32:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f36:	83 c7 04             	add    $0x4,%edi
80103f39:	c7 04 24 41 6e 10 80 	movl   $0x80106e41,(%esp)
80103f40:	e8 0b c7 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80103f45:	39 f7                	cmp    %esi,%edi
80103f47:	75 df                	jne    80103f28 <procdump+0x98>
80103f49:	e9 5a ff ff ff       	jmp    80103ea8 <procdump+0x18>
80103f4e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80103f50:	83 c4 4c             	add    $0x4c,%esp
80103f53:	5b                   	pop    %ebx
80103f54:	5e                   	pop    %esi
80103f55:	5f                   	pop    %edi
80103f56:	5d                   	pop    %ebp
80103f57:	c3                   	ret    
80103f58:	66 90                	xchg   %ax,%ax
80103f5a:	66 90                	xchg   %ax,%ax
80103f5c:	66 90                	xchg   %ax,%ax
80103f5e:	66 90                	xchg   %ax,%ax

80103f60 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	53                   	push   %ebx
80103f64:	83 ec 14             	sub    $0x14,%esp
80103f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f6a:	c7 44 24 04 78 74 10 	movl   $0x80107478,0x4(%esp)
80103f71:	80 
80103f72:	8d 43 04             	lea    0x4(%ebx),%eax
80103f75:	89 04 24             	mov    %eax,(%esp)
80103f78:	e8 f3 00 00 00       	call   80104070 <initlock>
  lk->name = name;
80103f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103f80:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f86:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80103f8d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80103f90:	83 c4 14             	add    $0x14,%esp
80103f93:	5b                   	pop    %ebx
80103f94:	5d                   	pop    %ebp
80103f95:	c3                   	ret    
80103f96:	8d 76 00             	lea    0x0(%esi),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
80103fa5:	83 ec 10             	sub    $0x10,%esp
80103fa8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fab:	8d 73 04             	lea    0x4(%ebx),%esi
80103fae:	89 34 24             	mov    %esi,(%esp)
80103fb1:	e8 aa 01 00 00       	call   80104160 <acquire>
  while (lk->locked) {
80103fb6:	8b 13                	mov    (%ebx),%edx
80103fb8:	85 d2                	test   %edx,%edx
80103fba:	74 16                	je     80103fd2 <acquiresleep+0x32>
80103fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103fc0:	89 74 24 04          	mov    %esi,0x4(%esp)
80103fc4:	89 1c 24             	mov    %ebx,(%esp)
80103fc7:	e8 54 fc ff ff       	call   80103c20 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80103fcc:	8b 03                	mov    (%ebx),%eax
80103fce:	85 c0                	test   %eax,%eax
80103fd0:	75 ee                	jne    80103fc0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80103fd2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103fd8:	e8 e3 f6 ff ff       	call   801036c0 <myproc>
80103fdd:	8b 40 10             	mov    0x10(%eax),%eax
80103fe0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103fe3:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103fe6:	83 c4 10             	add    $0x10,%esp
80103fe9:	5b                   	pop    %ebx
80103fea:	5e                   	pop    %esi
80103feb:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
80103fec:	e9 5f 02 00 00       	jmp    80104250 <release>
80103ff1:	eb 0d                	jmp    80104000 <releasesleep>
80103ff3:	90                   	nop
80103ff4:	90                   	nop
80103ff5:	90                   	nop
80103ff6:	90                   	nop
80103ff7:	90                   	nop
80103ff8:	90                   	nop
80103ff9:	90                   	nop
80103ffa:	90                   	nop
80103ffb:	90                   	nop
80103ffc:	90                   	nop
80103ffd:	90                   	nop
80103ffe:	90                   	nop
80103fff:	90                   	nop

80104000 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
80104005:	83 ec 10             	sub    $0x10,%esp
80104008:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010400b:	8d 73 04             	lea    0x4(%ebx),%esi
8010400e:	89 34 24             	mov    %esi,(%esp)
80104011:	e8 4a 01 00 00       	call   80104160 <acquire>
  lk->locked = 0;
80104016:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010401c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104023:	89 1c 24             	mov    %ebx,(%esp)
80104026:	e8 85 fd ff ff       	call   80103db0 <wakeup>
  release(&lk->lk);
8010402b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010402e:	83 c4 10             	add    $0x10,%esp
80104031:	5b                   	pop    %ebx
80104032:	5e                   	pop    %esi
80104033:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104034:	e9 17 02 00 00       	jmp    80104250 <release>
80104039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104040 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
80104045:	83 ec 10             	sub    $0x10,%esp
80104048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010404b:	8d 73 04             	lea    0x4(%ebx),%esi
8010404e:	89 34 24             	mov    %esi,(%esp)
80104051:	e8 0a 01 00 00       	call   80104160 <acquire>
  r = lk->locked;
80104056:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104058:	89 34 24             	mov    %esi,(%esp)
8010405b:	e8 f0 01 00 00       	call   80104250 <release>
  return r;
}
80104060:	83 c4 10             	add    $0x10,%esp
80104063:	89 d8                	mov    %ebx,%eax
80104065:	5b                   	pop    %ebx
80104066:	5e                   	pop    %esi
80104067:	5d                   	pop    %ebp
80104068:	c3                   	ret    
80104069:	66 90                	xchg   %ax,%ax
8010406b:	66 90                	xchg   %ax,%ax
8010406d:	66 90                	xchg   %ax,%ax
8010406f:	90                   	nop

80104070 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104076:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104079:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010407f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104082:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104089:	5d                   	pop    %ebp
8010408a:	c3                   	ret    
8010408b:	90                   	nop
8010408c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104090 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104093:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104099:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010409a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010409d:	31 c0                	xor    %eax,%eax
8010409f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801040a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040ac:	77 1a                	ja     801040c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801040b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801040b4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801040b7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801040b9:	83 f8 0a             	cmp    $0xa,%eax
801040bc:	75 e2                	jne    801040a0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040be:	5b                   	pop    %ebx
801040bf:	5d                   	pop    %ebp
801040c0:	c3                   	ret    
801040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801040c8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801040cf:	83 c0 01             	add    $0x1,%eax
801040d2:	83 f8 0a             	cmp    $0xa,%eax
801040d5:	74 e7                	je     801040be <getcallerpcs+0x2e>
    pcs[i] = 0;
801040d7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801040de:	83 c0 01             	add    $0x1,%eax
801040e1:	83 f8 0a             	cmp    $0xa,%eax
801040e4:	75 e2                	jne    801040c8 <getcallerpcs+0x38>
801040e6:	eb d6                	jmp    801040be <getcallerpcs+0x2e>
801040e8:	90                   	nop
801040e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040f0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801040f0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801040f1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801040f3:	89 e5                	mov    %esp,%ebp
801040f5:	53                   	push   %ebx
801040f6:	83 ec 04             	sub    $0x4,%esp
801040f9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801040fc:	8b 0a                	mov    (%edx),%ecx
801040fe:	85 c9                	test   %ecx,%ecx
80104100:	74 10                	je     80104112 <holding+0x22>
80104102:	8b 5a 08             	mov    0x8(%edx),%ebx
80104105:	e8 16 f5 ff ff       	call   80103620 <mycpu>
8010410a:	39 c3                	cmp    %eax,%ebx
8010410c:	0f 94 c0             	sete   %al
8010410f:	0f b6 c0             	movzbl %al,%eax
}
80104112:	83 c4 04             	add    $0x4,%esp
80104115:	5b                   	pop    %ebx
80104116:	5d                   	pop    %ebp
80104117:	c3                   	ret    
80104118:	90                   	nop
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104120 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 04             	sub    $0x4,%esp
80104127:	9c                   	pushf  
80104128:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104129:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010412a:	e8 f1 f4 ff ff       	call   80103620 <mycpu>
8010412f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104135:	85 c0                	test   %eax,%eax
80104137:	75 11                	jne    8010414a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104139:	e8 e2 f4 ff ff       	call   80103620 <mycpu>
8010413e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104144:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010414a:	e8 d1 f4 ff ff       	call   80103620 <mycpu>
8010414f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104156:	83 c4 04             	add    $0x4,%esp
80104159:	5b                   	pop    %ebx
8010415a:	5d                   	pop    %ebp
8010415b:	c3                   	ret    
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104160 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104167:	e8 b4 ff ff ff       	call   80104120 <pushcli>
  if(holding(lk))
8010416c:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010416f:	8b 02                	mov    (%edx),%eax
80104171:	85 c0                	test   %eax,%eax
80104173:	75 43                	jne    801041b8 <acquire+0x58>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104175:	b9 01 00 00 00       	mov    $0x1,%ecx
8010417a:	eb 07                	jmp    80104183 <acquire+0x23>
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104180:	8b 55 08             	mov    0x8(%ebp),%edx
80104183:	89 c8                	mov    %ecx,%eax
80104185:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104188:	85 c0                	test   %eax,%eax
8010418a:	75 f4                	jne    80104180 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010418c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104191:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104194:	e8 87 f4 ff ff       	call   80103620 <mycpu>
80104199:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010419c:	8b 45 08             	mov    0x8(%ebp),%eax
8010419f:	83 c0 0c             	add    $0xc,%eax
801041a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801041a6:	8d 45 08             	lea    0x8(%ebp),%eax
801041a9:	89 04 24             	mov    %eax,(%esp)
801041ac:	e8 df fe ff ff       	call   80104090 <getcallerpcs>
}
801041b1:	83 c4 14             	add    $0x14,%esp
801041b4:	5b                   	pop    %ebx
801041b5:	5d                   	pop    %ebp
801041b6:	c3                   	ret    
801041b7:	90                   	nop

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801041b8:	8b 5a 08             	mov    0x8(%edx),%ebx
801041bb:	e8 60 f4 ff ff       	call   80103620 <mycpu>
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801041c0:	39 c3                	cmp    %eax,%ebx
801041c2:	74 05                	je     801041c9 <acquire+0x69>
801041c4:	8b 55 08             	mov    0x8(%ebp),%edx
801041c7:	eb ac                	jmp    80104175 <acquire+0x15>
    panic("acquire");
801041c9:	c7 04 24 83 74 10 80 	movl   $0x80107483,(%esp)
801041d0:	e8 8b c1 ff ff       	call   80100360 <panic>
801041d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041e6:	9c                   	pushf  
801041e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041e8:	f6 c4 02             	test   $0x2,%ah
801041eb:	75 49                	jne    80104236 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801041ed:	e8 2e f4 ff ff       	call   80103620 <mycpu>
801041f2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801041f8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801041fb:	85 d2                	test   %edx,%edx
801041fd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104203:	78 25                	js     8010422a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104205:	e8 16 f4 ff ff       	call   80103620 <mycpu>
8010420a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104210:	85 d2                	test   %edx,%edx
80104212:	74 04                	je     80104218 <popcli+0x38>
    sti();
}
80104214:	c9                   	leave  
80104215:	c3                   	ret    
80104216:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104218:	e8 03 f4 ff ff       	call   80103620 <mycpu>
8010421d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104223:	85 c0                	test   %eax,%eax
80104225:	74 ed                	je     80104214 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104227:	fb                   	sti    
    sti();
}
80104228:	c9                   	leave  
80104229:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
8010422a:	c7 04 24 a2 74 10 80 	movl   $0x801074a2,(%esp)
80104231:	e8 2a c1 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104236:	c7 04 24 8b 74 10 80 	movl   $0x8010748b,(%esp)
8010423d:	e8 1e c1 ff ff       	call   80100360 <panic>
80104242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
80104255:	83 ec 10             	sub    $0x10,%esp
80104258:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010425b:	8b 03                	mov    (%ebx),%eax
8010425d:	85 c0                	test   %eax,%eax
8010425f:	75 0f                	jne    80104270 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104261:	c7 04 24 a9 74 10 80 	movl   $0x801074a9,(%esp)
80104268:	e8 f3 c0 ff ff       	call   80100360 <panic>
8010426d:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104270:	8b 73 08             	mov    0x8(%ebx),%esi
80104273:	e8 a8 f3 ff ff       	call   80103620 <mycpu>

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
80104278:	39 c6                	cmp    %eax,%esi
8010427a:	75 e5                	jne    80104261 <release+0x11>
    panic("release");

  lk->pcs[0] = 0;
8010427c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104283:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010428a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010428f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104295:	83 c4 10             	add    $0x10,%esp
80104298:	5b                   	pop    %ebx
80104299:	5e                   	pop    %esi
8010429a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
8010429b:	e9 40 ff ff ff       	jmp    801041e0 <popcli>

801042a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	8b 55 08             	mov    0x8(%ebp),%edx
801042a6:	57                   	push   %edi
801042a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801042aa:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801042ab:	f6 c2 03             	test   $0x3,%dl
801042ae:	75 05                	jne    801042b5 <memset+0x15>
801042b0:	f6 c1 03             	test   $0x3,%cl
801042b3:	74 13                	je     801042c8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801042b5:	89 d7                	mov    %edx,%edi
801042b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ba:	fc                   	cld    
801042bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801042bd:	5b                   	pop    %ebx
801042be:	89 d0                	mov    %edx,%eax
801042c0:	5f                   	pop    %edi
801042c1:	5d                   	pop    %ebp
801042c2:	c3                   	ret    
801042c3:	90                   	nop
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801042c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801042cc:	c1 e9 02             	shr    $0x2,%ecx
801042cf:	89 f8                	mov    %edi,%eax
801042d1:	89 fb                	mov    %edi,%ebx
801042d3:	c1 e0 18             	shl    $0x18,%eax
801042d6:	c1 e3 10             	shl    $0x10,%ebx
801042d9:	09 d8                	or     %ebx,%eax
801042db:	09 f8                	or     %edi,%eax
801042dd:	c1 e7 08             	shl    $0x8,%edi
801042e0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801042e2:	89 d7                	mov    %edx,%edi
801042e4:	fc                   	cld    
801042e5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801042e7:	5b                   	pop    %ebx
801042e8:	89 d0                	mov    %edx,%eax
801042ea:	5f                   	pop    %edi
801042eb:	5d                   	pop    %ebp
801042ec:	c3                   	ret    
801042ed:	8d 76 00             	lea    0x0(%esi),%esi

801042f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	8b 45 10             	mov    0x10(%ebp),%eax
801042f6:	57                   	push   %edi
801042f7:	56                   	push   %esi
801042f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801042fb:	53                   	push   %ebx
801042fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801042ff:	85 c0                	test   %eax,%eax
80104301:	8d 78 ff             	lea    -0x1(%eax),%edi
80104304:	74 26                	je     8010432c <memcmp+0x3c>
    if(*s1 != *s2)
80104306:	0f b6 03             	movzbl (%ebx),%eax
80104309:	31 d2                	xor    %edx,%edx
8010430b:	0f b6 0e             	movzbl (%esi),%ecx
8010430e:	38 c8                	cmp    %cl,%al
80104310:	74 16                	je     80104328 <memcmp+0x38>
80104312:	eb 24                	jmp    80104338 <memcmp+0x48>
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104318:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010431d:	83 c2 01             	add    $0x1,%edx
80104320:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104324:	38 c8                	cmp    %cl,%al
80104326:	75 10                	jne    80104338 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104328:	39 fa                	cmp    %edi,%edx
8010432a:	75 ec                	jne    80104318 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010432c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010432d:	31 c0                	xor    %eax,%eax
}
8010432f:	5e                   	pop    %esi
80104330:	5f                   	pop    %edi
80104331:	5d                   	pop    %ebp
80104332:	c3                   	ret    
80104333:	90                   	nop
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104338:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104339:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010433b:	5e                   	pop    %esi
8010433c:	5f                   	pop    %edi
8010433d:	5d                   	pop    %ebp
8010433e:	c3                   	ret    
8010433f:	90                   	nop

80104340 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	8b 45 08             	mov    0x8(%ebp),%eax
80104347:	56                   	push   %esi
80104348:	8b 75 0c             	mov    0xc(%ebp),%esi
8010434b:	53                   	push   %ebx
8010434c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010434f:	39 c6                	cmp    %eax,%esi
80104351:	73 35                	jae    80104388 <memmove+0x48>
80104353:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104356:	39 c8                	cmp    %ecx,%eax
80104358:	73 2e                	jae    80104388 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010435a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010435c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010435f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104362:	74 1b                	je     8010437f <memmove+0x3f>
80104364:	f7 db                	neg    %ebx
80104366:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104369:	01 fb                	add    %edi,%ebx
8010436b:	90                   	nop
8010436c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104370:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104374:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104377:	83 ea 01             	sub    $0x1,%edx
8010437a:	83 fa ff             	cmp    $0xffffffff,%edx
8010437d:	75 f1                	jne    80104370 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010437f:	5b                   	pop    %ebx
80104380:	5e                   	pop    %esi
80104381:	5f                   	pop    %edi
80104382:	5d                   	pop    %ebp
80104383:	c3                   	ret    
80104384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104388:	31 d2                	xor    %edx,%edx
8010438a:	85 db                	test   %ebx,%ebx
8010438c:	74 f1                	je     8010437f <memmove+0x3f>
8010438e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104390:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104394:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104397:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010439a:	39 da                	cmp    %ebx,%edx
8010439c:	75 f2                	jne    80104390 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010439e:	5b                   	pop    %ebx
8010439f:	5e                   	pop    %esi
801043a0:	5f                   	pop    %edi
801043a1:	5d                   	pop    %ebp
801043a2:	c3                   	ret    
801043a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801043b3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801043b4:	e9 87 ff ff ff       	jmp    80104340 <memmove>
801043b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	56                   	push   %esi
801043c4:	8b 75 10             	mov    0x10(%ebp),%esi
801043c7:	53                   	push   %ebx
801043c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801043ce:	85 f6                	test   %esi,%esi
801043d0:	74 30                	je     80104402 <strncmp+0x42>
801043d2:	0f b6 01             	movzbl (%ecx),%eax
801043d5:	84 c0                	test   %al,%al
801043d7:	74 2f                	je     80104408 <strncmp+0x48>
801043d9:	0f b6 13             	movzbl (%ebx),%edx
801043dc:	38 d0                	cmp    %dl,%al
801043de:	75 46                	jne    80104426 <strncmp+0x66>
801043e0:	8d 51 01             	lea    0x1(%ecx),%edx
801043e3:	01 ce                	add    %ecx,%esi
801043e5:	eb 14                	jmp    801043fb <strncmp+0x3b>
801043e7:	90                   	nop
801043e8:	0f b6 02             	movzbl (%edx),%eax
801043eb:	84 c0                	test   %al,%al
801043ed:	74 31                	je     80104420 <strncmp+0x60>
801043ef:	0f b6 19             	movzbl (%ecx),%ebx
801043f2:	83 c2 01             	add    $0x1,%edx
801043f5:	38 d8                	cmp    %bl,%al
801043f7:	75 17                	jne    80104410 <strncmp+0x50>
    n--, p++, q++;
801043f9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801043fb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801043fd:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104400:	75 e6                	jne    801043e8 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104402:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104403:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104405:	5e                   	pop    %esi
80104406:	5d                   	pop    %ebp
80104407:	c3                   	ret    
80104408:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010440b:	31 c0                	xor    %eax,%eax
8010440d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104410:	0f b6 d3             	movzbl %bl,%edx
80104413:	29 d0                	sub    %edx,%eax
}
80104415:	5b                   	pop    %ebx
80104416:	5e                   	pop    %esi
80104417:	5d                   	pop    %ebp
80104418:	c3                   	ret    
80104419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104420:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104424:	eb ea                	jmp    80104410 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104426:	89 d3                	mov    %edx,%ebx
80104428:	eb e6                	jmp    80104410 <strncmp+0x50>
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104430 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	8b 45 08             	mov    0x8(%ebp),%eax
80104436:	56                   	push   %esi
80104437:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010443a:	53                   	push   %ebx
8010443b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010443e:	89 c2                	mov    %eax,%edx
80104440:	eb 19                	jmp    8010445b <strncpy+0x2b>
80104442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104448:	83 c3 01             	add    $0x1,%ebx
8010444b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010444f:	83 c2 01             	add    $0x1,%edx
80104452:	84 c9                	test   %cl,%cl
80104454:	88 4a ff             	mov    %cl,-0x1(%edx)
80104457:	74 09                	je     80104462 <strncpy+0x32>
80104459:	89 f1                	mov    %esi,%ecx
8010445b:	85 c9                	test   %ecx,%ecx
8010445d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104460:	7f e6                	jg     80104448 <strncpy+0x18>
    ;
  while(n-- > 0)
80104462:	31 c9                	xor    %ecx,%ecx
80104464:	85 f6                	test   %esi,%esi
80104466:	7e 0f                	jle    80104477 <strncpy+0x47>
    *s++ = 0;
80104468:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010446c:	89 f3                	mov    %esi,%ebx
8010446e:	83 c1 01             	add    $0x1,%ecx
80104471:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104473:	85 db                	test   %ebx,%ebx
80104475:	7f f1                	jg     80104468 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104477:	5b                   	pop    %ebx
80104478:	5e                   	pop    %esi
80104479:	5d                   	pop    %ebp
8010447a:	c3                   	ret    
8010447b:	90                   	nop
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104486:	56                   	push   %esi
80104487:	8b 45 08             	mov    0x8(%ebp),%eax
8010448a:	53                   	push   %ebx
8010448b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010448e:	85 c9                	test   %ecx,%ecx
80104490:	7e 26                	jle    801044b8 <safestrcpy+0x38>
80104492:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104496:	89 c1                	mov    %eax,%ecx
80104498:	eb 17                	jmp    801044b1 <safestrcpy+0x31>
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801044a0:	83 c2 01             	add    $0x1,%edx
801044a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801044a7:	83 c1 01             	add    $0x1,%ecx
801044aa:	84 db                	test   %bl,%bl
801044ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801044af:	74 04                	je     801044b5 <safestrcpy+0x35>
801044b1:	39 f2                	cmp    %esi,%edx
801044b3:	75 eb                	jne    801044a0 <safestrcpy+0x20>
    ;
  *s = 0;
801044b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801044b8:	5b                   	pop    %ebx
801044b9:	5e                   	pop    %esi
801044ba:	5d                   	pop    %ebp
801044bb:	c3                   	ret    
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044c0 <strlen>:

int
strlen(const char *s)
{
801044c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801044c1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801044c3:	89 e5                	mov    %esp,%ebp
801044c5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801044c8:	80 3a 00             	cmpb   $0x0,(%edx)
801044cb:	74 0c                	je     801044d9 <strlen+0x19>
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
801044d0:	83 c0 01             	add    $0x1,%eax
801044d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044d7:	75 f7                	jne    801044d0 <strlen+0x10>
    ;
  return n;
}
801044d9:	5d                   	pop    %ebp
801044da:	c3                   	ret    

801044db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801044e3:	55                   	push   %ebp
  pushl %ebx
801044e4:	53                   	push   %ebx
  pushl %esi
801044e5:	56                   	push   %esi
  pushl %edi
801044e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044e9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801044eb:	5f                   	pop    %edi
  popl %esi
801044ec:	5e                   	pop    %esi
  popl %ebx
801044ed:	5b                   	pop    %ebx
  popl %ebp
801044ee:	5d                   	pop    %ebp
  ret
801044ef:	c3                   	ret    

801044f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 04             	sub    $0x4,%esp
801044f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801044fa:	e8 c1 f1 ff ff       	call   801036c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801044ff:	8b 00                	mov    (%eax),%eax
80104501:	39 d8                	cmp    %ebx,%eax
80104503:	76 1b                	jbe    80104520 <fetchint+0x30>
80104505:	8d 53 04             	lea    0x4(%ebx),%edx
80104508:	39 d0                	cmp    %edx,%eax
8010450a:	72 14                	jb     80104520 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010450c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010450f:	8b 13                	mov    (%ebx),%edx
80104511:	89 10                	mov    %edx,(%eax)
  return 0;
80104513:	31 c0                	xor    %eax,%eax
}
80104515:	83 c4 04             	add    $0x4,%esp
80104518:	5b                   	pop    %ebx
80104519:	5d                   	pop    %ebp
8010451a:	c3                   	ret    
8010451b:	90                   	nop
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104525:	eb ee                	jmp    80104515 <fetchint+0x25>
80104527:	89 f6                	mov    %esi,%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104530 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 04             	sub    $0x4,%esp
80104537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010453a:	e8 81 f1 ff ff       	call   801036c0 <myproc>

  if(addr >= curproc->sz)
8010453f:	39 18                	cmp    %ebx,(%eax)
80104541:	76 26                	jbe    80104569 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80104543:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104546:	89 da                	mov    %ebx,%edx
80104548:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010454a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010454c:	39 c3                	cmp    %eax,%ebx
8010454e:	73 19                	jae    80104569 <fetchstr+0x39>
    if(*s == 0)
80104550:	80 3b 00             	cmpb   $0x0,(%ebx)
80104553:	75 0d                	jne    80104562 <fetchstr+0x32>
80104555:	eb 21                	jmp    80104578 <fetchstr+0x48>
80104557:	90                   	nop
80104558:	80 3a 00             	cmpb   $0x0,(%edx)
8010455b:	90                   	nop
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104560:	74 16                	je     80104578 <fetchstr+0x48>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104562:	83 c2 01             	add    $0x1,%edx
80104565:	39 d0                	cmp    %edx,%eax
80104567:	77 ef                	ja     80104558 <fetchstr+0x28>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104569:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010456c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104571:	5b                   	pop    %ebx
80104572:	5d                   	pop    %ebp
80104573:	c3                   	ret    
80104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104578:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
8010457b:	89 d0                	mov    %edx,%eax
8010457d:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
8010457f:	5b                   	pop    %ebx
80104580:	5d                   	pop    %ebp
80104581:	c3                   	ret    
80104582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	8b 75 0c             	mov    0xc(%ebp),%esi
80104597:	53                   	push   %ebx
80104598:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010459b:	e8 20 f1 ff ff       	call   801036c0 <myproc>
801045a0:	89 75 0c             	mov    %esi,0xc(%ebp)
801045a3:	8b 40 18             	mov    0x18(%eax),%eax
801045a6:	8b 40 44             	mov    0x44(%eax),%eax
801045a9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801045ad:	89 45 08             	mov    %eax,0x8(%ebp)
}
801045b0:	5b                   	pop    %ebx
801045b1:	5e                   	pop    %esi
801045b2:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045b3:	e9 38 ff ff ff       	jmp    801044f0 <fetchint>
801045b8:	90                   	nop
801045b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	83 ec 20             	sub    $0x20,%esp
801045c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801045cb:	e8 f0 f0 ff ff       	call   801036c0 <myproc>
801045d0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801045d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801045d9:	8b 45 08             	mov    0x8(%ebp),%eax
801045dc:	89 04 24             	mov    %eax,(%esp)
801045df:	e8 ac ff ff ff       	call   80104590 <argint>
801045e4:	85 c0                	test   %eax,%eax
801045e6:	78 28                	js     80104610 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801045e8:	85 db                	test   %ebx,%ebx
801045ea:	78 24                	js     80104610 <argptr+0x50>
801045ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045ef:	8b 06                	mov    (%esi),%eax
801045f1:	39 c2                	cmp    %eax,%edx
801045f3:	73 1b                	jae    80104610 <argptr+0x50>
801045f5:	01 d3                	add    %edx,%ebx
801045f7:	39 d8                	cmp    %ebx,%eax
801045f9:	72 15                	jb     80104610 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801045fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801045fe:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104600:	83 c4 20             	add    $0x20,%esp
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
80104603:	31 c0                	xor    %eax,%eax
}
80104605:	5b                   	pop    %ebx
80104606:	5e                   	pop    %esi
80104607:	5d                   	pop    %ebp
80104608:	c3                   	ret    
80104609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104610:	83 c4 20             	add    $0x20,%esp
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
80104613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}
80104618:	5b                   	pop    %ebx
80104619:	5e                   	pop    %esi
8010461a:	5d                   	pop    %ebp
8010461b:	c3                   	ret    
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104620 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104626:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104629:	89 44 24 04          	mov    %eax,0x4(%esp)
8010462d:	8b 45 08             	mov    0x8(%ebp),%eax
80104630:	89 04 24             	mov    %eax,(%esp)
80104633:	e8 58 ff ff ff       	call   80104590 <argint>
80104638:	85 c0                	test   %eax,%eax
8010463a:	78 14                	js     80104650 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010463c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010463f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104646:	89 04 24             	mov    %eax,(%esp)
80104649:	e8 e2 fe ff ff       	call   80104530 <fetchstr>
}
8010464e:	c9                   	leave  
8010464f:	c3                   	ret    
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104655:	c9                   	leave  
80104656:	c3                   	ret    
80104657:	89 f6                	mov    %esi,%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104660 <syscall>:
[SYS_deleteIData] sys_deleteIData,
};

void
syscall(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104668:	e8 53 f0 ff ff       	call   801036c0 <myproc>

  num = curproc->tf->eax;
8010466d:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104670:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104672:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104675:	8d 50 ff             	lea    -0x1(%eax),%edx
80104678:	83 fa 17             	cmp    $0x17,%edx
8010467b:	77 1b                	ja     80104698 <syscall+0x38>
8010467d:	8b 14 85 e0 74 10 80 	mov    -0x7fef8b20(,%eax,4),%edx
80104684:	85 d2                	test   %edx,%edx
80104686:	74 10                	je     80104698 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104688:	ff d2                	call   *%edx
8010468a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010468d:	83 c4 10             	add    $0x10,%esp
80104690:	5b                   	pop    %ebx
80104691:	5e                   	pop    %esi
80104692:	5d                   	pop    %ebp
80104693:	c3                   	ret    
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104698:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010469c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010469f:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801046a3:	8b 43 10             	mov    0x10(%ebx),%eax
801046a6:	c7 04 24 b1 74 10 80 	movl   $0x801074b1,(%esp)
801046ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801046b1:	e8 9a bf ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801046b6:	8b 43 18             	mov    0x18(%ebx),%eax
801046b9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801046c0:	83 c4 10             	add    $0x10,%esp
801046c3:	5b                   	pop    %ebx
801046c4:	5e                   	pop    %esi
801046c5:	5d                   	pop    %ebp
801046c6:	c3                   	ret    
801046c7:	66 90                	xchg   %ax,%ax
801046c9:	66 90                	xchg   %ax,%ax
801046cb:	66 90                	xchg   %ax,%ax
801046cd:	66 90                	xchg   %ax,%ax
801046cf:	90                   	nop

801046d0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	53                   	push   %ebx
801046d4:	89 c3                	mov    %eax,%ebx
801046d6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801046d9:	e8 e2 ef ff ff       	call   801036c0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801046de:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
801046e0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801046e4:	85 c9                	test   %ecx,%ecx
801046e6:	74 18                	je     80104700 <fdalloc+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801046e8:	83 c2 01             	add    $0x1,%edx
801046eb:	83 fa 10             	cmp    $0x10,%edx
801046ee:	75 f0                	jne    801046e0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801046f0:	83 c4 04             	add    $0x4,%esp
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801046f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046f8:	5b                   	pop    %ebx
801046f9:	5d                   	pop    %ebp
801046fa:	c3                   	ret    
801046fb:	90                   	nop
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104700:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
80104704:	83 c4 04             	add    $0x4,%esp
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
80104707:	89 d0                	mov    %edx,%eax
    }
  }
  return -1;
}
80104709:	5b                   	pop    %ebx
8010470a:	5d                   	pop    %ebp
8010470b:	c3                   	ret    
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104710 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	56                   	push   %esi
80104715:	53                   	push   %ebx
80104716:	83 ec 4c             	sub    $0x4c,%esp
80104719:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010471c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010471f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104722:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104726:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104729:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010472c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010472f:	e8 0c d8 ff ff       	call   80101f40 <nameiparent>
80104734:	85 c0                	test   %eax,%eax
80104736:	89 c7                	mov    %eax,%edi
80104738:	0f 84 da 00 00 00    	je     80104818 <create+0x108>
    return 0;
  ilock(dp);
8010473e:	89 04 24             	mov    %eax,(%esp)
80104741:	e8 8a cf ff ff       	call   801016d0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104746:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104749:	89 44 24 08          	mov    %eax,0x8(%esp)
8010474d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104751:	89 3c 24             	mov    %edi,(%esp)
80104754:	e8 87 d4 ff ff       	call   80101be0 <dirlookup>
80104759:	85 c0                	test   %eax,%eax
8010475b:	89 c6                	mov    %eax,%esi
8010475d:	74 41                	je     801047a0 <create+0x90>
    iunlockput(dp);
8010475f:	89 3c 24             	mov    %edi,(%esp)
80104762:	e8 c9 d1 ff ff       	call   80101930 <iunlockput>
    ilock(ip);
80104767:	89 34 24             	mov    %esi,(%esp)
8010476a:	e8 61 cf ff ff       	call   801016d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010476f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104774:	75 12                	jne    80104788 <create+0x78>
80104776:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010477b:	89 f0                	mov    %esi,%eax
8010477d:	75 09                	jne    80104788 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010477f:	83 c4 4c             	add    $0x4c,%esp
80104782:	5b                   	pop    %ebx
80104783:	5e                   	pop    %esi
80104784:	5f                   	pop    %edi
80104785:	5d                   	pop    %ebp
80104786:	c3                   	ret    
80104787:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104788:	89 34 24             	mov    %esi,(%esp)
8010478b:	e8 a0 d1 ff ff       	call   80101930 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104790:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104793:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104795:	5b                   	pop    %ebx
80104796:	5e                   	pop    %esi
80104797:	5f                   	pop    %edi
80104798:	5d                   	pop    %ebp
80104799:	c3                   	ret    
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801047a0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801047a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801047a8:	8b 07                	mov    (%edi),%eax
801047aa:	89 04 24             	mov    %eax,(%esp)
801047ad:	e8 7e cd ff ff       	call   80101530 <ialloc>
801047b2:	85 c0                	test   %eax,%eax
801047b4:	89 c6                	mov    %eax,%esi
801047b6:	0f 84 bf 00 00 00    	je     8010487b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
801047bc:	89 04 24             	mov    %eax,(%esp)
801047bf:	e8 0c cf ff ff       	call   801016d0 <ilock>
  ip->major = major;
801047c4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801047c8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801047cc:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801047d0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801047d4:	b8 01 00 00 00       	mov    $0x1,%eax
801047d9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801047dd:	89 34 24             	mov    %esi,(%esp)
801047e0:	e8 1b ce ff ff       	call   80101600 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801047e5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801047ea:	74 34                	je     80104820 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801047ec:	8b 46 04             	mov    0x4(%esi),%eax
801047ef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047f3:	89 3c 24             	mov    %edi,(%esp)
801047f6:	89 44 24 08          	mov    %eax,0x8(%esp)
801047fa:	e8 41 d6 ff ff       	call   80101e40 <dirlink>
801047ff:	85 c0                	test   %eax,%eax
80104801:	78 6c                	js     8010486f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104803:	89 3c 24             	mov    %edi,(%esp)
80104806:	e8 25 d1 ff ff       	call   80101930 <iunlockput>

  return ip;
}
8010480b:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
8010480e:	89 f0                	mov    %esi,%eax
}
80104810:	5b                   	pop    %ebx
80104811:	5e                   	pop    %esi
80104812:	5f                   	pop    %edi
80104813:	5d                   	pop    %ebp
80104814:	c3                   	ret    
80104815:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104818:	31 c0                	xor    %eax,%eax
8010481a:	e9 60 ff ff ff       	jmp    8010477f <create+0x6f>
8010481f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104820:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104825:	89 3c 24             	mov    %edi,(%esp)
80104828:	e8 d3 cd ff ff       	call   80101600 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010482d:	8b 46 04             	mov    0x4(%esi),%eax
80104830:	c7 44 24 04 60 75 10 	movl   $0x80107560,0x4(%esp)
80104837:	80 
80104838:	89 34 24             	mov    %esi,(%esp)
8010483b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010483f:	e8 fc d5 ff ff       	call   80101e40 <dirlink>
80104844:	85 c0                	test   %eax,%eax
80104846:	78 1b                	js     80104863 <create+0x153>
80104848:	8b 47 04             	mov    0x4(%edi),%eax
8010484b:	c7 44 24 04 5f 75 10 	movl   $0x8010755f,0x4(%esp)
80104852:	80 
80104853:	89 34 24             	mov    %esi,(%esp)
80104856:	89 44 24 08          	mov    %eax,0x8(%esp)
8010485a:	e8 e1 d5 ff ff       	call   80101e40 <dirlink>
8010485f:	85 c0                	test   %eax,%eax
80104861:	79 89                	jns    801047ec <create+0xdc>
      panic("create dots");
80104863:	c7 04 24 53 75 10 80 	movl   $0x80107553,(%esp)
8010486a:	e8 f1 ba ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010486f:	c7 04 24 62 75 10 80 	movl   $0x80107562,(%esp)
80104876:	e8 e5 ba ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
8010487b:	c7 04 24 44 75 10 80 	movl   $0x80107544,(%esp)
80104882:	e8 d9 ba ff ff       	call   80100360 <panic>
80104887:	89 f6                	mov    %esi,%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <argfd.constprop.0>:
}

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	89 c6                	mov    %eax,%esi
80104896:	53                   	push   %ebx
80104897:	89 d3                	mov    %edx,%ebx
80104899:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010489c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010489f:	89 44 24 04          	mov    %eax,0x4(%esp)
801048a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048aa:	e8 e1 fc ff ff       	call   80104590 <argint>
801048af:	85 c0                	test   %eax,%eax
801048b1:	78 2d                	js     801048e0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801048b3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048b7:	77 27                	ja     801048e0 <argfd.constprop.0+0x50>
801048b9:	e8 02 ee ff ff       	call   801036c0 <myproc>
801048be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048c1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801048c5:	85 c0                	test   %eax,%eax
801048c7:	74 17                	je     801048e0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801048c9:	85 f6                	test   %esi,%esi
801048cb:	74 02                	je     801048cf <argfd.constprop.0+0x3f>
    *pfd = fd;
801048cd:	89 16                	mov    %edx,(%esi)
  if(pf)
801048cf:	85 db                	test   %ebx,%ebx
801048d1:	74 1d                	je     801048f0 <argfd.constprop.0+0x60>
    *pf = f;
801048d3:	89 03                	mov    %eax,(%ebx)
  return 0;
801048d5:	31 c0                	xor    %eax,%eax
}
801048d7:	83 c4 20             	add    $0x20,%esp
801048da:	5b                   	pop    %ebx
801048db:	5e                   	pop    %esi
801048dc:	5d                   	pop    %ebp
801048dd:	c3                   	ret    
801048de:	66 90                	xchg   %ax,%ax
801048e0:	83 c4 20             	add    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801048e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
801048e8:	5b                   	pop    %ebx
801048e9:	5e                   	pop    %esi
801048ea:	5d                   	pop    %ebp
801048eb:	c3                   	ret    
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801048f0:	31 c0                	xor    %eax,%eax
801048f2:	eb e3                	jmp    801048d7 <argfd.constprop.0+0x47>
801048f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104900 <sys_inodeTBWalker>:
#include "fcntl.h"
#include "buf.h"

struct superblock sb;

int sys_inodeTBWalker(void){
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
	int inum;
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb);
	for(inum = 1; inum < sb.ninodes; inum++){
80104904:	be 01 00 00 00       	mov    $0x1,%esi
#include "fcntl.h"
#include "buf.h"

struct superblock sb;

int sys_inodeTBWalker(void){
80104909:	53                   	push   %ebx
	int inum;
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb);
	for(inum = 1; inum < sb.ninodes; inum++){
8010490a:	bb 01 00 00 00       	mov    $0x1,%ebx
#include "fcntl.h"
#include "buf.h"

struct superblock sb;

int sys_inodeTBWalker(void){
8010490f:	83 ec 10             	sub    $0x10,%esp
	int inum;
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb);
80104912:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80104919:	80 
8010491a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104921:	e8 7a ca ff ff       	call   801013a0 <readsb>
	for(inum = 1; inum < sb.ninodes; inum++){
80104926:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
8010492d:	77 1e                	ja     8010494d <sys_inodeTBWalker+0x4d>
8010492f:	eb 67                	jmp    80104998 <sys_inodeTBWalker+0x98>
80104931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		}
		else{
			// Found allocated inode
			cprintf("inode#: %d \t type: %d\n",inum,dip->type);
		}
		brelse(bp);
80104938:	89 04 24             	mov    %eax,(%esp)
int sys_inodeTBWalker(void){
	int inum;
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb);
	for(inum = 1; inum < sb.ninodes; inum++){
8010493b:	83 c3 01             	add    $0x1,%ebx
		}
		else{
			// Found allocated inode
			cprintf("inode#: %d \t type: %d\n",inum,dip->type);
		}
		brelse(bp);
8010493e:	e8 9d b8 ff ff       	call   801001e0 <brelse>
int sys_inodeTBWalker(void){
	int inum;
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb);
	for(inum = 1; inum < sb.ninodes; inum++){
80104943:	89 de                	mov    %ebx,%esi
80104945:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
8010494b:	73 4b                	jae    80104998 <sys_inodeTBWalker+0x98>
		bp = bread(1, IBLOCK(inum, sb));
8010494d:	89 f0                	mov    %esi,%eax
		dip = (struct dinode*)bp->data + inum%IPB;
8010494f:	83 e6 07             	and    $0x7,%esi
	int inum;
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb);
	for(inum = 1; inum < sb.ninodes; inum++){
		bp = bread(1, IBLOCK(inum, sb));
80104952:	c1 e8 03             	shr    $0x3,%eax
80104955:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010495b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104962:	89 44 24 04          	mov    %eax,0x4(%esp)
80104966:	e8 65 b7 ff ff       	call   801000d0 <bread>
		dip = (struct dinode*)bp->data + inum%IPB;
8010496b:	89 f2                	mov    %esi,%edx
		if(dip->type == 0){  // a free inode
8010496d:	c1 e2 06             	shl    $0x6,%edx
80104970:	0f bf 54 10 5c       	movswl 0x5c(%eax,%edx,1),%edx
80104975:	66 85 d2             	test   %dx,%dx
80104978:	74 be                	je     80104938 <sys_inodeTBWalker+0x38>
			//cprintf("Skipping inode #: %d",inum);
		}
		else{
			// Found allocated inode
			cprintf("inode#: %d \t type: %d\n",inum,dip->type);
8010497a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010497e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104982:	c7 04 24 72 75 10 80 	movl   $0x80107572,(%esp)
80104989:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010498c:	e8 bf bc ff ff       	call   80100650 <cprintf>
80104991:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104994:	eb a2                	jmp    80104938 <sys_inodeTBWalker+0x38>
80104996:	66 90                	xchg   %ax,%ax
		}
		brelse(bp);
	}
	return 0;
}
80104998:	83 c4 10             	add    $0x10,%esp
8010499b:	31 c0                	xor    %eax,%eax
8010499d:	5b                   	pop    %ebx
8010499e:	5e                   	pop    %esi
8010499f:	5d                   	pop    %ebp
801049a0:	c3                   	ret    
801049a1:	eb 0d                	jmp    801049b0 <sys_deleteIData>
801049a3:	90                   	nop
801049a4:	90                   	nop
801049a5:	90                   	nop
801049a6:	90                   	nop
801049a7:	90                   	nop
801049a8:	90                   	nop
801049a9:	90                   	nop
801049aa:	90                   	nop
801049ab:	90                   	nop
801049ac:	90                   	nop
801049ad:	90                   	nop
801049ae:	90                   	nop
801049af:	90                   	nop

801049b0 <sys_deleteIData>:

int sys_deleteIData(void){
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	83 ec 20             	sub    $0x20,%esp
	begin_op();
801049b8:	e8 73 e1 ff ff       	call   80102b30 <begin_op>
	int inum;
	argint(0,&inum); // Get inode number of inode to delete from arguments list
801049bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801049c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049cb:	e8 c0 fb ff ff       	call   80104590 <argint>
	struct inode *inodeToDel;
	inodeToDel = calliget(inum); // Obtain inode
801049d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d3:	89 04 24             	mov    %eax,(%esp)
801049d6:	e8 b5 cc ff ff       	call   80101690 <calliget>
801049db:	89 c3                	mov    %eax,%ebx
	cprintf("\n\n---> inode#: %d \t type: %d\n\n",inodeToDel->inum,inodeToDel->type);
801049dd:	0f bf 40 50          	movswl 0x50(%eax),%eax
	ilock(inodeToDel);

	inodeToDel->type=0;
	cprintf("\n\n---> inode#: %d \t type: %d\n\n",inodeToDel->inum,inodeToDel->type);
	iunlockput(inodeToDel);
	acquiresleep(&inodeToDel->lock);
801049e1:	8d 73 0c             	lea    0xc(%ebx),%esi
	begin_op();
	int inum;
	argint(0,&inum); // Get inode number of inode to delete from arguments list
	struct inode *inodeToDel;
	inodeToDel = calliget(inum); // Obtain inode
	cprintf("\n\n---> inode#: %d \t type: %d\n\n",inodeToDel->inum,inodeToDel->type);
801049e4:	89 44 24 08          	mov    %eax,0x8(%esp)
801049e8:	8b 43 04             	mov    0x4(%ebx),%eax
801049eb:	c7 04 24 bc 75 10 80 	movl   $0x801075bc,(%esp)
801049f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801049f6:	e8 55 bc ff ff       	call   80100650 <cprintf>
	ilock(inodeToDel);
801049fb:	89 1c 24             	mov    %ebx,(%esp)
801049fe:	e8 cd cc ff ff       	call   801016d0 <ilock>

	inodeToDel->type=0;
80104a03:	31 c0                	xor    %eax,%eax
80104a05:	66 89 43 50          	mov    %ax,0x50(%ebx)
	cprintf("\n\n---> inode#: %d \t type: %d\n\n",inodeToDel->inum,inodeToDel->type);
80104a09:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80104a10:	00 
80104a11:	8b 43 04             	mov    0x4(%ebx),%eax
80104a14:	c7 04 24 bc 75 10 80 	movl   $0x801075bc,(%esp)
80104a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a1f:	e8 2c bc ff ff       	call   80100650 <cprintf>
	iunlockput(inodeToDel);
80104a24:	89 1c 24             	mov    %ebx,(%esp)
80104a27:	e8 04 cf ff ff       	call   80101930 <iunlockput>
	acquiresleep(&inodeToDel->lock);
80104a2c:	89 34 24             	mov    %esi,(%esp)
80104a2f:	e8 6c f5 ff ff       	call   80103fa0 <acquiresleep>
	iupdate(inodeToDel);
80104a34:	89 1c 24             	mov    %ebx,(%esp)
80104a37:	e8 c4 cb ff ff       	call   80101600 <iupdate>
	releasesleep(&inodeToDel->lock);
80104a3c:	89 34 24             	mov    %esi,(%esp)
80104a3f:	e8 bc f5 ff ff       	call   80104000 <releasesleep>
	end_op();
80104a44:	e8 57 e1 ff ff       	call   80102ba0 <end_op>

	inodeToDel = calliget(inum);
80104a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4c:	89 04 24             	mov    %eax,(%esp)
80104a4f:	e8 3c cc ff ff       	call   80101690 <calliget>
	cprintf("\n\n---> inode#: %d \t type: %d\n\n",inodeToDel->inum,inodeToDel->type);
80104a54:	0f bf 50 50          	movswl 0x50(%eax),%edx
80104a58:	89 54 24 08          	mov    %edx,0x8(%esp)
80104a5c:	8b 40 04             	mov    0x4(%eax),%eax
80104a5f:	c7 04 24 bc 75 10 80 	movl   $0x801075bc,(%esp)
80104a66:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a6a:	e8 e1 bb ff ff       	call   80100650 <cprintf>

	return 0;
}
80104a6f:	83 c4 20             	add    $0x20,%esp
80104a72:	31 c0                	xor    %eax,%eax
80104a74:	5b                   	pop    %ebx
80104a75:	5e                   	pop    %esi
80104a76:	5d                   	pop    %ebp
80104a77:	c3                   	ret    
80104a78:	90                   	nop
80104a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a80 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104a80:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a81:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104a83:	89 e5                	mov    %esp,%ebp
80104a85:	53                   	push   %ebx
80104a86:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a89:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a8c:	e8 ff fd ff ff       	call   80104890 <argfd.constprop.0>
80104a91:	85 c0                	test   %eax,%eax
80104a93:	78 23                	js     80104ab8 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a98:	e8 33 fc ff ff       	call   801046d0 <fdalloc>
80104a9d:	85 c0                	test   %eax,%eax
80104a9f:	89 c3                	mov    %eax,%ebx
80104aa1:	78 15                	js     80104ab8 <sys_dup+0x38>
    return -1;
  filedup(f);
80104aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa6:	89 04 24             	mov    %eax,(%esp)
80104aa9:	e8 32 c3 ff ff       	call   80100de0 <filedup>
  return fd;
80104aae:	89 d8                	mov    %ebx,%eax
}
80104ab0:	83 c4 24             	add    $0x24,%esp
80104ab3:	5b                   	pop    %ebx
80104ab4:	5d                   	pop    %ebp
80104ab5:	c3                   	ret    
80104ab6:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104abd:	eb f1                	jmp    80104ab0 <sys_dup+0x30>
80104abf:	90                   	nop

80104ac0 <sys_read>:
  return fd;
}

int
sys_read(void)
{
80104ac0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ac1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104ac3:	89 e5                	mov    %esp,%ebp
80104ac5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ac8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104acb:	e8 c0 fd ff ff       	call   80104890 <argfd.constprop.0>
80104ad0:	85 c0                	test   %eax,%eax
80104ad2:	78 54                	js     80104b28 <sys_read+0x68>
80104ad4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104adb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ae2:	e8 a9 fa ff ff       	call   80104590 <argint>
80104ae7:	85 c0                	test   %eax,%eax
80104ae9:	78 3d                	js     80104b28 <sys_read+0x68>
80104aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104af5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104af9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104afc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b00:	e8 bb fa ff ff       	call   801045c0 <argptr>
80104b05:	85 c0                	test   %eax,%eax
80104b07:	78 1f                	js     80104b28 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b13:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b1a:	89 04 24             	mov    %eax,(%esp)
80104b1d:	e8 1e c4 ff ff       	call   80100f40 <fileread>
}
80104b22:	c9                   	leave  
80104b23:	c3                   	ret    
80104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104b2d:	c9                   	leave  
80104b2e:	c3                   	ret    
80104b2f:	90                   	nop

80104b30 <sys_write>:

int
sys_write(void)
{
80104b30:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b31:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b3b:	e8 50 fd ff ff       	call   80104890 <argfd.constprop.0>
80104b40:	85 c0                	test   %eax,%eax
80104b42:	78 54                	js     80104b98 <sys_write+0x68>
80104b44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b47:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b4b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104b52:	e8 39 fa ff ff       	call   80104590 <argint>
80104b57:	85 c0                	test   %eax,%eax
80104b59:	78 3d                	js     80104b98 <sys_write+0x68>
80104b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b65:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b70:	e8 4b fa ff ff       	call   801045c0 <argptr>
80104b75:	85 c0                	test   %eax,%eax
80104b77:	78 1f                	js     80104b98 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b7c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b83:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b8a:	89 04 24             	mov    %eax,(%esp)
80104b8d:	e8 4e c4 ff ff       	call   80100fe0 <filewrite>
}
80104b92:	c9                   	leave  
80104b93:	c3                   	ret    
80104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104b9d:	c9                   	leave  
80104b9e:	c3                   	ret    
80104b9f:	90                   	nop

80104ba0 <sys_close>:

int
sys_close(void)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104ba6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ba9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bac:	e8 df fc ff ff       	call   80104890 <argfd.constprop.0>
80104bb1:	85 c0                	test   %eax,%eax
80104bb3:	78 23                	js     80104bd8 <sys_close+0x38>
    return -1;
  myproc()->ofile[fd] = 0;
80104bb5:	e8 06 eb ff ff       	call   801036c0 <myproc>
80104bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bbd:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104bc4:	00 
  fileclose(f);
80104bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc8:	89 04 24             	mov    %eax,(%esp)
80104bcb:	e8 60 c2 ff ff       	call   80100e30 <fileclose>
  return 0;
80104bd0:	31 c0                	xor    %eax,%eax
}
80104bd2:	c9                   	leave  
80104bd3:	c3                   	ret    
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104bdd:	c9                   	leave  
80104bde:	c3                   	ret    
80104bdf:	90                   	nop

80104be0 <sys_fstat>:

int
sys_fstat(void)
{
80104be0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104be1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104be8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104beb:	e8 a0 fc ff ff       	call   80104890 <argfd.constprop.0>
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	78 34                	js     80104c28 <sys_fstat+0x48>
80104bf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bf7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104bfe:	00 
80104bff:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c0a:	e8 b1 f9 ff ff       	call   801045c0 <argptr>
80104c0f:	85 c0                	test   %eax,%eax
80104c11:	78 15                	js     80104c28 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c16:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c1d:	89 04 24             	mov    %eax,(%esp)
80104c20:	e8 cb c2 ff ff       	call   80100ef0 <filestat>
}
80104c25:	c9                   	leave  
80104c26:	c3                   	ret    
80104c27:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104c28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104c2d:	c9                   	leave  
80104c2e:	c3                   	ret    
80104c2f:	90                   	nop

80104c30 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	57                   	push   %edi
80104c34:	56                   	push   %esi
80104c35:	53                   	push   %ebx
80104c36:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104c39:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c47:	e8 d4 f9 ff ff       	call   80104620 <argstr>
80104c4c:	85 c0                	test   %eax,%eax
80104c4e:	0f 88 e6 00 00 00    	js     80104d3a <sys_link+0x10a>
80104c54:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104c57:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c62:	e8 b9 f9 ff ff       	call   80104620 <argstr>
80104c67:	85 c0                	test   %eax,%eax
80104c69:	0f 88 cb 00 00 00    	js     80104d3a <sys_link+0x10a>
    return -1;

  begin_op();
80104c6f:	e8 bc de ff ff       	call   80102b30 <begin_op>
  if((ip = namei(old)) == 0){
80104c74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104c77:	89 04 24             	mov    %eax,(%esp)
80104c7a:	e8 a1 d2 ff ff       	call   80101f20 <namei>
80104c7f:	85 c0                	test   %eax,%eax
80104c81:	89 c3                	mov    %eax,%ebx
80104c83:	0f 84 ac 00 00 00    	je     80104d35 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104c89:	89 04 24             	mov    %eax,(%esp)
80104c8c:	e8 3f ca ff ff       	call   801016d0 <ilock>
  if(ip->type == T_DIR){
80104c91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c96:	0f 84 91 00 00 00    	je     80104d2d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104c9c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104ca1:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104ca4:	89 1c 24             	mov    %ebx,(%esp)
80104ca7:	e8 54 c9 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
80104cac:	89 1c 24             	mov    %ebx,(%esp)
80104caf:	e8 fc ca ff ff       	call   801017b0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104cb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104cb7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104cbb:	89 04 24             	mov    %eax,(%esp)
80104cbe:	e8 7d d2 ff ff       	call   80101f40 <nameiparent>
80104cc3:	85 c0                	test   %eax,%eax
80104cc5:	89 c6                	mov    %eax,%esi
80104cc7:	74 4f                	je     80104d18 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104cc9:	89 04 24             	mov    %eax,(%esp)
80104ccc:	e8 ff c9 ff ff       	call   801016d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104cd1:	8b 03                	mov    (%ebx),%eax
80104cd3:	39 06                	cmp    %eax,(%esi)
80104cd5:	75 39                	jne    80104d10 <sys_link+0xe0>
80104cd7:	8b 43 04             	mov    0x4(%ebx),%eax
80104cda:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104cde:	89 34 24             	mov    %esi,(%esp)
80104ce1:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ce5:	e8 56 d1 ff ff       	call   80101e40 <dirlink>
80104cea:	85 c0                	test   %eax,%eax
80104cec:	78 22                	js     80104d10 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104cee:	89 34 24             	mov    %esi,(%esp)
80104cf1:	e8 3a cc ff ff       	call   80101930 <iunlockput>
  iput(ip);
80104cf6:	89 1c 24             	mov    %ebx,(%esp)
80104cf9:	e8 f2 ca ff ff       	call   801017f0 <iput>

  end_op();
80104cfe:	e8 9d de ff ff       	call   80102ba0 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104d03:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104d06:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104d08:	5b                   	pop    %ebx
80104d09:	5e                   	pop    %esi
80104d0a:	5f                   	pop    %edi
80104d0b:	5d                   	pop    %ebp
80104d0c:	c3                   	ret    
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104d10:	89 34 24             	mov    %esi,(%esp)
80104d13:	e8 18 cc ff ff       	call   80101930 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104d18:	89 1c 24             	mov    %ebx,(%esp)
80104d1b:	e8 b0 c9 ff ff       	call   801016d0 <ilock>
  ip->nlink--;
80104d20:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d25:	89 1c 24             	mov    %ebx,(%esp)
80104d28:	e8 d3 c8 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104d2d:	89 1c 24             	mov    %ebx,(%esp)
80104d30:	e8 fb cb ff ff       	call   80101930 <iunlockput>
  end_op();
80104d35:	e8 66 de ff ff       	call   80102ba0 <end_op>
  return -1;
}
80104d3a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104d3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d42:	5b                   	pop    %ebx
80104d43:	5e                   	pop    %esi
80104d44:	5f                   	pop    %edi
80104d45:	5d                   	pop    %ebp
80104d46:	c3                   	ret    
80104d47:	89 f6                	mov    %esi,%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d50 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
80104d55:	53                   	push   %ebx
80104d56:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104d59:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d67:	e8 b4 f8 ff ff       	call   80104620 <argstr>
80104d6c:	85 c0                	test   %eax,%eax
80104d6e:	0f 88 76 01 00 00    	js     80104eea <sys_unlink+0x19a>
    return -1;

  begin_op();
80104d74:	e8 b7 dd ff ff       	call   80102b30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104d79:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104d7c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104d7f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d83:	89 04 24             	mov    %eax,(%esp)
80104d86:	e8 b5 d1 ff ff       	call   80101f40 <nameiparent>
80104d8b:	85 c0                	test   %eax,%eax
80104d8d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d90:	0f 84 4f 01 00 00    	je     80104ee5 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104d96:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d99:	89 34 24             	mov    %esi,(%esp)
80104d9c:	e8 2f c9 ff ff       	call   801016d0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104da1:	c7 44 24 04 60 75 10 	movl   $0x80107560,0x4(%esp)
80104da8:	80 
80104da9:	89 1c 24             	mov    %ebx,(%esp)
80104dac:	e8 ff cd ff ff       	call   80101bb0 <namecmp>
80104db1:	85 c0                	test   %eax,%eax
80104db3:	0f 84 21 01 00 00    	je     80104eda <sys_unlink+0x18a>
80104db9:	c7 44 24 04 5f 75 10 	movl   $0x8010755f,0x4(%esp)
80104dc0:	80 
80104dc1:	89 1c 24             	mov    %ebx,(%esp)
80104dc4:	e8 e7 cd ff ff       	call   80101bb0 <namecmp>
80104dc9:	85 c0                	test   %eax,%eax
80104dcb:	0f 84 09 01 00 00    	je     80104eda <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104dd1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104dd4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104dd8:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ddc:	89 34 24             	mov    %esi,(%esp)
80104ddf:	e8 fc cd ff ff       	call   80101be0 <dirlookup>
80104de4:	85 c0                	test   %eax,%eax
80104de6:	89 c3                	mov    %eax,%ebx
80104de8:	0f 84 ec 00 00 00    	je     80104eda <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104dee:	89 04 24             	mov    %eax,(%esp)
80104df1:	e8 da c8 ff ff       	call   801016d0 <ilock>

  if(ip->nlink < 1)
80104df6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104dfb:	0f 8e 24 01 00 00    	jle    80104f25 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104e01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e06:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104e09:	74 7d                	je     80104e88 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104e0b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104e12:	00 
80104e13:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104e1a:	00 
80104e1b:	89 34 24             	mov    %esi,(%esp)
80104e1e:	e8 7d f4 ff ff       	call   801042a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e23:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104e26:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e2d:	00 
80104e2e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e32:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e36:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e39:	89 04 24             	mov    %eax,(%esp)
80104e3c:	e8 3f cc ff ff       	call   80101a80 <writei>
80104e41:	83 f8 10             	cmp    $0x10,%eax
80104e44:	0f 85 cf 00 00 00    	jne    80104f19 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104e4a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e4f:	0f 84 a3 00 00 00    	je     80104ef8 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104e55:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e58:	89 04 24             	mov    %eax,(%esp)
80104e5b:	e8 d0 ca ff ff       	call   80101930 <iunlockput>

  ip->nlink--;
80104e60:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e65:	89 1c 24             	mov    %ebx,(%esp)
80104e68:	e8 93 c7 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104e6d:	89 1c 24             	mov    %ebx,(%esp)
80104e70:	e8 bb ca ff ff       	call   80101930 <iunlockput>

  end_op();
80104e75:	e8 26 dd ff ff       	call   80102ba0 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e7a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104e7d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e7f:	5b                   	pop    %ebx
80104e80:	5e                   	pop    %esi
80104e81:	5f                   	pop    %edi
80104e82:	5d                   	pop    %ebp
80104e83:	c3                   	ret    
80104e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e88:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e8c:	0f 86 79 ff ff ff    	jbe    80104e0b <sys_unlink+0xbb>
80104e92:	bf 20 00 00 00       	mov    $0x20,%edi
80104e97:	eb 15                	jmp    80104eae <sys_unlink+0x15e>
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ea0:	8d 57 10             	lea    0x10(%edi),%edx
80104ea3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104ea6:	0f 83 5f ff ff ff    	jae    80104e0b <sys_unlink+0xbb>
80104eac:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104eae:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104eb5:	00 
80104eb6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104eba:	89 74 24 04          	mov    %esi,0x4(%esp)
80104ebe:	89 1c 24             	mov    %ebx,(%esp)
80104ec1:	e8 ba ca ff ff       	call   80101980 <readi>
80104ec6:	83 f8 10             	cmp    $0x10,%eax
80104ec9:	75 42                	jne    80104f0d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104ecb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104ed0:	74 ce                	je     80104ea0 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104ed2:	89 1c 24             	mov    %ebx,(%esp)
80104ed5:	e8 56 ca ff ff       	call   80101930 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104eda:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104edd:	89 04 24             	mov    %eax,(%esp)
80104ee0:	e8 4b ca ff ff       	call   80101930 <iunlockput>
  end_op();
80104ee5:	e8 b6 dc ff ff       	call   80102ba0 <end_op>
  return -1;
}
80104eea:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104eed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ef2:	5b                   	pop    %ebx
80104ef3:	5e                   	pop    %esi
80104ef4:	5f                   	pop    %edi
80104ef5:	5d                   	pop    %ebp
80104ef6:	c3                   	ret    
80104ef7:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104ef8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104efb:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104f00:	89 04 24             	mov    %eax,(%esp)
80104f03:	e8 f8 c6 ff ff       	call   80101600 <iupdate>
80104f08:	e9 48 ff ff ff       	jmp    80104e55 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104f0d:	c7 04 24 9b 75 10 80 	movl   $0x8010759b,(%esp)
80104f14:	e8 47 b4 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104f19:	c7 04 24 ad 75 10 80 	movl   $0x801075ad,(%esp)
80104f20:	e8 3b b4 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104f25:	c7 04 24 89 75 10 80 	movl   $0x80107589,(%esp)
80104f2c:	e8 2f b4 ff ff       	call   80100360 <panic>
80104f31:	eb 0d                	jmp    80104f40 <sys_open>
80104f33:	90                   	nop
80104f34:	90                   	nop
80104f35:	90                   	nop
80104f36:	90                   	nop
80104f37:	90                   	nop
80104f38:	90                   	nop
80104f39:	90                   	nop
80104f3a:	90                   	nop
80104f3b:	90                   	nop
80104f3c:	90                   	nop
80104f3d:	90                   	nop
80104f3e:	90                   	nop
80104f3f:	90                   	nop

80104f40 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	56                   	push   %esi
80104f45:	53                   	push   %ebx
80104f46:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f49:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f57:	e8 c4 f6 ff ff       	call   80104620 <argstr>
80104f5c:	85 c0                	test   %eax,%eax
80104f5e:	0f 88 d1 00 00 00    	js     80105035 <sys_open+0xf5>
80104f64:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f67:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f72:	e8 19 f6 ff ff       	call   80104590 <argint>
80104f77:	85 c0                	test   %eax,%eax
80104f79:	0f 88 b6 00 00 00    	js     80105035 <sys_open+0xf5>
    return -1;

  begin_op();
80104f7f:	e8 ac db ff ff       	call   80102b30 <begin_op>

  if(omode & O_CREATE){
80104f84:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f88:	0f 85 82 00 00 00    	jne    80105010 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f91:	89 04 24             	mov    %eax,(%esp)
80104f94:	e8 87 cf ff ff       	call   80101f20 <namei>
80104f99:	85 c0                	test   %eax,%eax
80104f9b:	89 c6                	mov    %eax,%esi
80104f9d:	0f 84 8d 00 00 00    	je     80105030 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104fa3:	89 04 24             	mov    %eax,(%esp)
80104fa6:	e8 25 c7 ff ff       	call   801016d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104fab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104fb0:	0f 84 92 00 00 00    	je     80105048 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104fb6:	e8 b5 bd ff ff       	call   80100d70 <filealloc>
80104fbb:	85 c0                	test   %eax,%eax
80104fbd:	89 c3                	mov    %eax,%ebx
80104fbf:	0f 84 93 00 00 00    	je     80105058 <sys_open+0x118>
80104fc5:	e8 06 f7 ff ff       	call   801046d0 <fdalloc>
80104fca:	85 c0                	test   %eax,%eax
80104fcc:	89 c7                	mov    %eax,%edi
80104fce:	0f 88 94 00 00 00    	js     80105068 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104fd4:	89 34 24             	mov    %esi,(%esp)
80104fd7:	e8 d4 c7 ff ff       	call   801017b0 <iunlock>
  end_op();
80104fdc:	e8 bf db ff ff       	call   80102ba0 <end_op>

  f->type = FD_INODE;
80104fe1:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104fe7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104fea:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104fed:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104ff4:	89 c2                	mov    %eax,%edx
80104ff6:	83 e2 01             	and    $0x1,%edx
80104ff9:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104ffc:	a8 03                	test   $0x3,%al
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104ffe:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80105001:	89 f8                	mov    %edi,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105003:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80105007:	83 c4 2c             	add    $0x2c,%esp
8010500a:	5b                   	pop    %ebx
8010500b:	5e                   	pop    %esi
8010500c:	5f                   	pop    %edi
8010500d:	5d                   	pop    %ebp
8010500e:	c3                   	ret    
8010500f:	90                   	nop
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105010:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105013:	31 c9                	xor    %ecx,%ecx
80105015:	ba 02 00 00 00       	mov    $0x2,%edx
8010501a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105021:	e8 ea f6 ff ff       	call   80104710 <create>
    if(ip == 0){
80105026:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105028:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010502a:	75 8a                	jne    80104fb6 <sys_open+0x76>
8010502c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
80105030:	e8 6b db ff ff       	call   80102ba0 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105035:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010503d:	5b                   	pop    %ebx
8010503e:	5e                   	pop    %esi
8010503f:	5f                   	pop    %edi
80105040:	5d                   	pop    %ebp
80105041:	c3                   	ret    
80105042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010504b:	85 c0                	test   %eax,%eax
8010504d:	0f 84 63 ff ff ff    	je     80104fb6 <sys_open+0x76>
80105053:	90                   	nop
80105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
80105058:	89 34 24             	mov    %esi,(%esp)
8010505b:	e8 d0 c8 ff ff       	call   80101930 <iunlockput>
80105060:	eb ce                	jmp    80105030 <sys_open+0xf0>
80105062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105068:	89 1c 24             	mov    %ebx,(%esp)
8010506b:	e8 c0 bd ff ff       	call   80100e30 <fileclose>
80105070:	eb e6                	jmp    80105058 <sys_open+0x118>
80105072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105086:	e8 a5 da ff ff       	call   80102b30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010508b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010508e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105092:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105099:	e8 82 f5 ff ff       	call   80104620 <argstr>
8010509e:	85 c0                	test   %eax,%eax
801050a0:	78 2e                	js     801050d0 <sys_mkdir+0x50>
801050a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a5:	31 c9                	xor    %ecx,%ecx
801050a7:	ba 01 00 00 00       	mov    $0x1,%edx
801050ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050b3:	e8 58 f6 ff ff       	call   80104710 <create>
801050b8:	85 c0                	test   %eax,%eax
801050ba:	74 14                	je     801050d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801050bc:	89 04 24             	mov    %eax,(%esp)
801050bf:	e8 6c c8 ff ff       	call   80101930 <iunlockput>
  end_op();
801050c4:	e8 d7 da ff ff       	call   80102ba0 <end_op>
  return 0;
801050c9:	31 c0                	xor    %eax,%eax
}
801050cb:	c9                   	leave  
801050cc:	c3                   	ret    
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801050d0:	e8 cb da ff ff       	call   80102ba0 <end_op>
    return -1;
801050d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801050da:	c9                   	leave  
801050db:	c3                   	ret    
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050e0 <sys_mknod>:

int
sys_mknod(void)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801050e6:	e8 45 da ff ff       	call   80102b30 <begin_op>
  if((argstr(0, &path)) < 0 ||
801050eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801050ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801050f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050f9:	e8 22 f5 ff ff       	call   80104620 <argstr>
801050fe:	85 c0                	test   %eax,%eax
80105100:	78 5e                	js     80105160 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105102:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105105:	89 44 24 04          	mov    %eax,0x4(%esp)
80105109:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105110:	e8 7b f4 ff ff       	call   80104590 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105115:	85 c0                	test   %eax,%eax
80105117:	78 47                	js     80105160 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105119:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010511c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105127:	e8 64 f4 ff ff       	call   80104590 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010512c:	85 c0                	test   %eax,%eax
8010512e:	78 30                	js     80105160 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105130:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105134:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105139:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010513d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105140:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105143:	e8 c8 f5 ff ff       	call   80104710 <create>
80105148:	85 c0                	test   %eax,%eax
8010514a:	74 14                	je     80105160 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010514c:	89 04 24             	mov    %eax,(%esp)
8010514f:	e8 dc c7 ff ff       	call   80101930 <iunlockput>
  end_op();
80105154:	e8 47 da ff ff       	call   80102ba0 <end_op>
  return 0;
80105159:	31 c0                	xor    %eax,%eax
}
8010515b:	c9                   	leave  
8010515c:	c3                   	ret    
8010515d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105160:	e8 3b da ff ff       	call   80102ba0 <end_op>
    return -1;
80105165:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010516a:	c9                   	leave  
8010516b:	c3                   	ret    
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105170 <sys_chdir>:

int
sys_chdir(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	56                   	push   %esi
80105174:	53                   	push   %ebx
80105175:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105178:	e8 43 e5 ff ff       	call   801036c0 <myproc>
8010517d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010517f:	e8 ac d9 ff ff       	call   80102b30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105184:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105187:	89 44 24 04          	mov    %eax,0x4(%esp)
8010518b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105192:	e8 89 f4 ff ff       	call   80104620 <argstr>
80105197:	85 c0                	test   %eax,%eax
80105199:	78 4a                	js     801051e5 <sys_chdir+0x75>
8010519b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010519e:	89 04 24             	mov    %eax,(%esp)
801051a1:	e8 7a cd ff ff       	call   80101f20 <namei>
801051a6:	85 c0                	test   %eax,%eax
801051a8:	89 c3                	mov    %eax,%ebx
801051aa:	74 39                	je     801051e5 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
801051ac:	89 04 24             	mov    %eax,(%esp)
801051af:	e8 1c c5 ff ff       	call   801016d0 <ilock>
  if(ip->type != T_DIR){
801051b4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
801051b9:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
801051bc:	75 22                	jne    801051e0 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801051be:	e8 ed c5 ff ff       	call   801017b0 <iunlock>
  iput(curproc->cwd);
801051c3:	8b 46 68             	mov    0x68(%esi),%eax
801051c6:	89 04 24             	mov    %eax,(%esp)
801051c9:	e8 22 c6 ff ff       	call   801017f0 <iput>
  end_op();
801051ce:	e8 cd d9 ff ff       	call   80102ba0 <end_op>
  curproc->cwd = ip;
  return 0;
801051d3:	31 c0                	xor    %eax,%eax
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
801051d5:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
}
801051d8:	83 c4 20             	add    $0x20,%esp
801051db:	5b                   	pop    %ebx
801051dc:	5e                   	pop    %esi
801051dd:	5d                   	pop    %ebp
801051de:	c3                   	ret    
801051df:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801051e0:	e8 4b c7 ff ff       	call   80101930 <iunlockput>
    end_op();
801051e5:	e8 b6 d9 ff ff       	call   80102ba0 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
801051ea:	83 c4 20             	add    $0x20,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
801051ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
801051f2:	5b                   	pop    %ebx
801051f3:	5e                   	pop    %esi
801051f4:	5d                   	pop    %ebp
801051f5:	c3                   	ret    
801051f6:	8d 76 00             	lea    0x0(%esi),%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_exec>:

int
sys_exec(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
80105205:	53                   	push   %ebx
80105206:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010520c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105212:	89 44 24 04          	mov    %eax,0x4(%esp)
80105216:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010521d:	e8 fe f3 ff ff       	call   80104620 <argstr>
80105222:	85 c0                	test   %eax,%eax
80105224:	0f 88 84 00 00 00    	js     801052ae <sys_exec+0xae>
8010522a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105230:	89 44 24 04          	mov    %eax,0x4(%esp)
80105234:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010523b:	e8 50 f3 ff ff       	call   80104590 <argint>
80105240:	85 c0                	test   %eax,%eax
80105242:	78 6a                	js     801052ae <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105244:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010524a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010524c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105253:	00 
80105254:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010525a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105261:	00 
80105262:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105268:	89 04 24             	mov    %eax,(%esp)
8010526b:	e8 30 f0 ff ff       	call   801042a0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105270:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105276:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010527a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010527d:	89 04 24             	mov    %eax,(%esp)
80105280:	e8 6b f2 ff ff       	call   801044f0 <fetchint>
80105285:	85 c0                	test   %eax,%eax
80105287:	78 25                	js     801052ae <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105289:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010528f:	85 c0                	test   %eax,%eax
80105291:	74 2d                	je     801052c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105293:	89 74 24 04          	mov    %esi,0x4(%esp)
80105297:	89 04 24             	mov    %eax,(%esp)
8010529a:	e8 91 f2 ff ff       	call   80104530 <fetchstr>
8010529f:	85 c0                	test   %eax,%eax
801052a1:	78 0b                	js     801052ae <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801052a3:	83 c3 01             	add    $0x1,%ebx
801052a6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801052a9:	83 fb 20             	cmp    $0x20,%ebx
801052ac:	75 c2                	jne    80105270 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801052ae:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801052b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801052b9:	5b                   	pop    %ebx
801052ba:	5e                   	pop    %esi
801052bb:	5f                   	pop    %edi
801052bc:	5d                   	pop    %ebp
801052bd:	c3                   	ret    
801052be:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801052c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801052c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ca:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801052d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801052d7:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801052db:	89 04 24             	mov    %eax,(%esp)
801052de:	e8 bd b6 ff ff       	call   801009a0 <exec>
}
801052e3:	81 c4 ac 00 00 00    	add    $0xac,%esp
801052e9:	5b                   	pop    %ebx
801052ea:	5e                   	pop    %esi
801052eb:	5f                   	pop    %edi
801052ec:	5d                   	pop    %ebp
801052ed:	c3                   	ret    
801052ee:	66 90                	xchg   %ax,%ax

801052f0 <sys_pipe>:

int
sys_pipe(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	53                   	push   %ebx
801052f4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801052f7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052fa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105301:	00 
80105302:	89 44 24 04          	mov    %eax,0x4(%esp)
80105306:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010530d:	e8 ae f2 ff ff       	call   801045c0 <argptr>
80105312:	85 c0                	test   %eax,%eax
80105314:	78 6d                	js     80105383 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105316:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105319:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105320:	89 04 24             	mov    %eax,(%esp)
80105323:	e8 68 de ff ff       	call   80103190 <pipealloc>
80105328:	85 c0                	test   %eax,%eax
8010532a:	78 57                	js     80105383 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010532c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010532f:	e8 9c f3 ff ff       	call   801046d0 <fdalloc>
80105334:	85 c0                	test   %eax,%eax
80105336:	89 c3                	mov    %eax,%ebx
80105338:	78 33                	js     8010536d <sys_pipe+0x7d>
8010533a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010533d:	e8 8e f3 ff ff       	call   801046d0 <fdalloc>
80105342:	85 c0                	test   %eax,%eax
80105344:	78 1a                	js     80105360 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105346:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105349:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010534b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010534e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105351:	83 c4 24             	add    $0x24,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105354:	31 c0                	xor    %eax,%eax
}
80105356:	5b                   	pop    %ebx
80105357:	5d                   	pop    %ebp
80105358:	c3                   	ret    
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105360:	e8 5b e3 ff ff       	call   801036c0 <myproc>
80105365:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010536c:	00 
    fileclose(rf);
8010536d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105370:	89 04 24             	mov    %eax,(%esp)
80105373:	e8 b8 ba ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
80105378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010537b:	89 04 24             	mov    %eax,(%esp)
8010537e:	e8 ad ba ff ff       	call   80100e30 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105383:	83 c4 24             	add    $0x24,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105386:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010538b:	5b                   	pop    %ebx
8010538c:	5d                   	pop    %ebp
8010538d:	c3                   	ret    
8010538e:	66 90                	xchg   %ax,%ax

80105390 <sys_myMemory>:
#include "mmu.h"
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
	pde_t * pageDirectory = myproc()->pgdir;
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
80105394:	31 ff                	xor    %edi,%edi
#include "mmu.h"
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
80105396:	56                   	push   %esi
	pde_t * pageDirectory = myproc()->pgdir;
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
80105397:	31 f6                	xor    %esi,%esi
#include "mmu.h"
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
80105399:	53                   	push   %ebx
8010539a:	83 ec 1c             	sub    $0x1c,%esp
	pde_t * pageDirectory = myproc()->pgdir;
8010539d:	e8 1e e3 ff ff       	call   801036c0 <myproc>
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
801053a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
	pde_t * pageDirectory = myproc()->pgdir;
801053a9:	8b 40 04             	mov    0x4(%eax),%eax
801053ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
801053af:	90                   	nop
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
		if ((((pageDirectory[pageDirectoryIndex]) & (uint)PTE_P))){
801053b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053b3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801053b6:	8b 04 98             	mov    (%eax,%ebx,4),%eax
801053b9:	a8 01                	test   $0x1,%al
801053bb:	74 3b                	je     801053f8 <sys_myMemory+0x68>
			pageTable = (pde_t *)P2V(PTE_ADDR(pageDirectory[pageDirectoryIndex]));
801053bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801053c2:	8d 98 00 10 00 80    	lea    -0x7ffff000(%eax),%ebx
801053c8:	05 00 00 00 80       	add    $0x80000000,%eax
801053cd:	eb 08                	jmp    801053d7 <sys_myMemory+0x47>
801053cf:	90                   	nop
801053d0:	83 c0 04             	add    $0x4,%eax
			for(pageTableIndex=0; pageTableIndex<1024; pageTableIndex++){
801053d3:	39 d8                	cmp    %ebx,%eax
801053d5:	74 21                	je     801053f8 <sys_myMemory+0x68>
				if((pageTable[pageTableIndex] & (uint)PTE_U) && (pageTable[pageTableIndex] & (uint)PTE_P)){
801053d7:	8b 10                	mov    (%eax),%edx
801053d9:	89 d1                	mov    %edx,%ecx
801053db:	83 e1 05             	and    $0x5,%ecx
801053de:	83 f9 05             	cmp    $0x5,%ecx
801053e1:	75 ed                	jne    801053d0 <sys_myMemory+0x40>
					// Page is present
					presentPagesCounter++;
					if ((pageTable[pageTableIndex] & (uint)PTE_W)){
801053e3:	83 e2 02             	and    $0x2,%edx
		if ((((pageDirectory[pageDirectoryIndex]) & (uint)PTE_P))){
			pageTable = (pde_t *)P2V(PTE_ADDR(pageDirectory[pageDirectoryIndex]));
			for(pageTableIndex=0; pageTableIndex<1024; pageTableIndex++){
				if((pageTable[pageTableIndex] & (uint)PTE_U) && (pageTable[pageTableIndex] & (uint)PTE_P)){
					// Page is present
					presentPagesCounter++;
801053e6:	83 c6 01             	add    $0x1,%esi
					if ((pageTable[pageTableIndex] & (uint)PTE_W)){
						//Page is accessible and writable
						userWritePagesCounter++;
801053e9:	83 fa 01             	cmp    $0x1,%edx
801053ec:	83 df ff             	sbb    $0xffffffff,%edi
801053ef:	83 c0 04             	add    $0x4,%eax
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
		if ((((pageDirectory[pageDirectoryIndex]) & (uint)PTE_P))){
			pageTable = (pde_t *)P2V(PTE_ADDR(pageDirectory[pageDirectoryIndex]));
			for(pageTableIndex=0; pageTableIndex<1024; pageTableIndex++){
801053f2:	39 d8                	cmp    %ebx,%eax
801053f4:	75 e1                	jne    801053d7 <sys_myMemory+0x47>
801053f6:	66 90                	xchg   %ax,%ax
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
801053f8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801053fc:	81 7d e4 00 04 00 00 	cmpl   $0x400,-0x1c(%ebp)
80105403:	75 ab                	jne    801053b0 <sys_myMemory+0x20>
				}
			}
		}
	}
	//Present = Accessible
	cprintf("Present Pages: %d\n",presentPagesCounter);
80105405:	89 74 24 04          	mov    %esi,0x4(%esp)
80105409:	c7 04 24 db 75 10 80 	movl   $0x801075db,(%esp)
80105410:	e8 3b b2 ff ff       	call   80100650 <cprintf>
	cprintf("Write/User Pages: %d\n",userWritePagesCounter);
80105415:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105419:	c7 04 24 ee 75 10 80 	movl   $0x801075ee,(%esp)
80105420:	e8 2b b2 ff ff       	call   80100650 <cprintf>
	return presentPagesCounter;
}
80105425:	83 c4 1c             	add    $0x1c,%esp
80105428:	89 f0                	mov    %esi,%eax
8010542a:	5b                   	pop    %ebx
8010542b:	5e                   	pop    %esi
8010542c:	5f                   	pop    %edi
8010542d:	5d                   	pop    %ebp
8010542e:	c3                   	ret    
8010542f:	90                   	nop

80105430 <sys_fork>:

int
sys_fork(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105433:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105434:	e9 37 e4 ff ff       	jmp    80103870 <fork>
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_exit>:
}

int
sys_exit(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	83 ec 08             	sub    $0x8,%esp
  exit();
80105446:	e8 75 e6 ff ff       	call   80103ac0 <exit>
  return 0;  // not reached
}
8010544b:	31 c0                	xor    %eax,%eax
8010544d:	c9                   	leave  
8010544e:	c3                   	ret    
8010544f:	90                   	nop

80105450 <sys_wait>:

int
sys_wait(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105453:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105454:	e9 77 e8 ff ff       	jmp    80103cd0 <wait>
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_kill>:
}

int
sys_kill(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105466:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105469:	89 44 24 04          	mov    %eax,0x4(%esp)
8010546d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105474:	e8 17 f1 ff ff       	call   80104590 <argint>
80105479:	85 c0                	test   %eax,%eax
8010547b:	78 13                	js     80105490 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010547d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105480:	89 04 24             	mov    %eax,(%esp)
80105483:	e8 88 e9 ff ff       	call   80103e10 <kill>
}
80105488:	c9                   	leave  
80105489:	c3                   	ret    
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105495:	c9                   	leave  
80105496:	c3                   	ret    
80105497:	89 f6                	mov    %esi,%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054a0 <sys_getpid>:

int
sys_getpid(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801054a6:	e8 15 e2 ff ff       	call   801036c0 <myproc>
801054ab:	8b 40 10             	mov    0x10(%eax),%eax
}
801054ae:	c9                   	leave  
801054af:	c3                   	ret    

801054b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	53                   	push   %ebx
801054b4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801054b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801054be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054c5:	e8 c6 f0 ff ff       	call   80104590 <argint>
801054ca:	85 c0                	test   %eax,%eax
801054cc:	78 22                	js     801054f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801054ce:	e8 ed e1 ff ff       	call   801036c0 <myproc>
  if(growproc(n) < 0)
801054d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801054d6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801054d8:	89 14 24             	mov    %edx,(%esp)
801054db:	e8 20 e3 ff ff       	call   80103800 <growproc>
801054e0:	85 c0                	test   %eax,%eax
801054e2:	78 0c                	js     801054f0 <sys_sbrk+0x40>
    return -1;
  return addr;
801054e4:	89 d8                	mov    %ebx,%eax
}
801054e6:	83 c4 24             	add    $0x24,%esp
801054e9:	5b                   	pop    %ebx
801054ea:	5d                   	pop    %ebp
801054eb:	c3                   	ret    
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801054f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f5:	eb ef                	jmp    801054e6 <sys_sbrk+0x36>
801054f7:	89 f6                	mov    %esi,%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105500 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	53                   	push   %ebx
80105504:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105507:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010550a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010550e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105515:	e8 76 f0 ff ff       	call   80104590 <argint>
8010551a:	85 c0                	test   %eax,%eax
8010551c:	78 7e                	js     8010559c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010551e:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105525:	e8 36 ec ff ff       	call   80104160 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010552a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010552d:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105533:	85 d2                	test   %edx,%edx
80105535:	75 29                	jne    80105560 <sys_sleep+0x60>
80105537:	eb 4f                	jmp    80105588 <sys_sleep+0x88>
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105540:	c7 44 24 04 60 4c 11 	movl   $0x80114c60,0x4(%esp)
80105547:	80 
80105548:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
8010554f:	e8 cc e6 ff ff       	call   80103c20 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105554:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105559:	29 d8                	sub    %ebx,%eax
8010555b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010555e:	73 28                	jae    80105588 <sys_sleep+0x88>
    if(myproc()->killed){
80105560:	e8 5b e1 ff ff       	call   801036c0 <myproc>
80105565:	8b 40 24             	mov    0x24(%eax),%eax
80105568:	85 c0                	test   %eax,%eax
8010556a:	74 d4                	je     80105540 <sys_sleep+0x40>
      release(&tickslock);
8010556c:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105573:	e8 d8 ec ff ff       	call   80104250 <release>
      return -1;
80105578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010557d:	83 c4 24             	add    $0x24,%esp
80105580:	5b                   	pop    %ebx
80105581:	5d                   	pop    %ebp
80105582:	c3                   	ret    
80105583:	90                   	nop
80105584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105588:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010558f:	e8 bc ec ff ff       	call   80104250 <release>
  return 0;
}
80105594:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105597:	31 c0                	xor    %eax,%eax
}
80105599:	5b                   	pop    %ebx
8010559a:	5d                   	pop    %ebp
8010559b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010559c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a1:	eb da                	jmp    8010557d <sys_sleep+0x7d>
801055a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	53                   	push   %ebx
801055b4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801055b7:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801055be:	e8 9d eb ff ff       	call   80104160 <acquire>
  xticks = ticks;
801055c3:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
801055c9:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801055d0:	e8 7b ec ff ff       	call   80104250 <release>
  return xticks;
}
801055d5:	83 c4 14             	add    $0x14,%esp
801055d8:	89 d8                	mov    %ebx,%eax
801055da:	5b                   	pop    %ebx
801055db:	5d                   	pop    %ebp
801055dc:	c3                   	ret    

801055dd <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801055dd:	1e                   	push   %ds
  pushl %es
801055de:	06                   	push   %es
  pushl %fs
801055df:	0f a0                	push   %fs
  pushl %gs
801055e1:	0f a8                	push   %gs
  pushal
801055e3:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801055e4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801055e8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801055ea:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801055ec:	54                   	push   %esp
  call trap
801055ed:	e8 de 00 00 00       	call   801056d0 <trap>
  addl $4, %esp
801055f2:	83 c4 04             	add    $0x4,%esp

801055f5 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801055f5:	61                   	popa   
  popl %gs
801055f6:	0f a9                	pop    %gs
  popl %fs
801055f8:	0f a1                	pop    %fs
  popl %es
801055fa:	07                   	pop    %es
  popl %ds
801055fb:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801055fc:	83 c4 08             	add    $0x8,%esp
  iret
801055ff:	cf                   	iret   

80105600 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105600:	31 c0                	xor    %eax,%eax
80105602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105608:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010560f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105614:	66 89 0c c5 a2 4c 11 	mov    %cx,-0x7feeb35e(,%eax,8)
8010561b:	80 
8010561c:	c6 04 c5 a4 4c 11 80 	movb   $0x0,-0x7feeb35c(,%eax,8)
80105623:	00 
80105624:	c6 04 c5 a5 4c 11 80 	movb   $0x8e,-0x7feeb35b(,%eax,8)
8010562b:	8e 
8010562c:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105633:	80 
80105634:	c1 ea 10             	shr    $0x10,%edx
80105637:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
8010563e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010563f:	83 c0 01             	add    $0x1,%eax
80105642:	3d 00 01 00 00       	cmp    $0x100,%eax
80105647:	75 bf                	jne    80105608 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105649:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010564a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010564f:	89 e5                	mov    %esp,%ebp
80105651:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105654:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105659:	c7 44 24 04 04 76 10 	movl   $0x80107604,0x4(%esp)
80105660:	80 
80105661:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105668:	66 89 15 a2 4e 11 80 	mov    %dx,0x80114ea2
8010566f:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
80105675:	c1 e8 10             	shr    $0x10,%eax
80105678:	c6 05 a4 4e 11 80 00 	movb   $0x0,0x80114ea4
8010567f:	c6 05 a5 4e 11 80 ef 	movb   $0xef,0x80114ea5
80105686:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6

  initlock(&tickslock, "time");
8010568c:	e8 df e9 ff ff       	call   80104070 <initlock>
}
80105691:	c9                   	leave  
80105692:	c3                   	ret    
80105693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056a0 <idtinit>:

void
idtinit(void)
{
801056a0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801056a1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801056a6:	89 e5                	mov    %esp,%ebp
801056a8:	83 ec 10             	sub    $0x10,%esp
801056ab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801056af:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
801056b4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801056b8:	c1 e8 10             	shr    $0x10,%eax
801056bb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801056bf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801056c2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801056c5:	c9                   	leave  
801056c6:	c3                   	ret    
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056d0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	57                   	push   %edi
801056d4:	56                   	push   %esi
801056d5:	53                   	push   %ebx
801056d6:	83 ec 3c             	sub    $0x3c,%esp
801056d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801056dc:	8b 43 30             	mov    0x30(%ebx),%eax
801056df:	83 f8 40             	cmp    $0x40,%eax
801056e2:	0f 84 a0 01 00 00    	je     80105888 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801056e8:	83 e8 20             	sub    $0x20,%eax
801056eb:	83 f8 1f             	cmp    $0x1f,%eax
801056ee:	77 08                	ja     801056f8 <trap+0x28>
801056f0:	ff 24 85 ac 76 10 80 	jmp    *-0x7fef8954(,%eax,4)
801056f7:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801056f8:	e8 c3 df ff ff       	call   801036c0 <myproc>
801056fd:	85 c0                	test   %eax,%eax
801056ff:	90                   	nop
80105700:	0f 84 fa 01 00 00    	je     80105900 <trap+0x230>
80105706:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010570a:	0f 84 f0 01 00 00    	je     80105900 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105710:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105713:	8b 53 38             	mov    0x38(%ebx),%edx
80105716:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105719:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010571c:	e8 7f df ff ff       	call   801036a0 <cpuid>
80105721:	8b 73 30             	mov    0x30(%ebx),%esi
80105724:	89 c7                	mov    %eax,%edi
80105726:	8b 43 34             	mov    0x34(%ebx),%eax
80105729:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010572c:	e8 8f df ff ff       	call   801036c0 <myproc>
80105731:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105734:	e8 87 df ff ff       	call   801036c0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105739:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010573c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105740:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105743:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105746:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010574a:	89 54 24 18          	mov    %edx,0x18(%esp)
8010574e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105751:	83 c6 6c             	add    $0x6c,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105754:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105758:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010575c:	89 54 24 10          	mov    %edx,0x10(%esp)
80105760:	8b 40 10             	mov    0x10(%eax),%eax
80105763:	c7 04 24 68 76 10 80 	movl   $0x80107668,(%esp)
8010576a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010576e:	e8 dd ae ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105773:	e8 48 df ff ff       	call   801036c0 <myproc>
80105778:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010577f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105780:	e8 3b df ff ff       	call   801036c0 <myproc>
80105785:	85 c0                	test   %eax,%eax
80105787:	74 0c                	je     80105795 <trap+0xc5>
80105789:	e8 32 df ff ff       	call   801036c0 <myproc>
8010578e:	8b 50 24             	mov    0x24(%eax),%edx
80105791:	85 d2                	test   %edx,%edx
80105793:	75 4b                	jne    801057e0 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105795:	e8 26 df ff ff       	call   801036c0 <myproc>
8010579a:	85 c0                	test   %eax,%eax
8010579c:	74 0d                	je     801057ab <trap+0xdb>
8010579e:	66 90                	xchg   %ax,%ax
801057a0:	e8 1b df ff ff       	call   801036c0 <myproc>
801057a5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801057a9:	74 4d                	je     801057f8 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057ab:	e8 10 df ff ff       	call   801036c0 <myproc>
801057b0:	85 c0                	test   %eax,%eax
801057b2:	74 1d                	je     801057d1 <trap+0x101>
801057b4:	e8 07 df ff ff       	call   801036c0 <myproc>
801057b9:	8b 40 24             	mov    0x24(%eax),%eax
801057bc:	85 c0                	test   %eax,%eax
801057be:	74 11                	je     801057d1 <trap+0x101>
801057c0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801057c4:	83 e0 03             	and    $0x3,%eax
801057c7:	66 83 f8 03          	cmp    $0x3,%ax
801057cb:	0f 84 e8 00 00 00    	je     801058b9 <trap+0x1e9>
    exit();
}
801057d1:	83 c4 3c             	add    $0x3c,%esp
801057d4:	5b                   	pop    %ebx
801057d5:	5e                   	pop    %esi
801057d6:	5f                   	pop    %edi
801057d7:	5d                   	pop    %ebp
801057d8:	c3                   	ret    
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057e0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801057e4:	83 e0 03             	and    $0x3,%eax
801057e7:	66 83 f8 03          	cmp    $0x3,%ax
801057eb:	75 a8                	jne    80105795 <trap+0xc5>
    exit();
801057ed:	e8 ce e2 ff ff       	call   80103ac0 <exit>
801057f2:	eb a1                	jmp    80105795 <trap+0xc5>
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801057f8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105800:	75 a9                	jne    801057ab <trap+0xdb>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105802:	e8 d9 e3 ff ff       	call   80103be0 <yield>
80105807:	eb a2                	jmp    801057ab <trap+0xdb>
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105810:	e8 8b de ff ff       	call   801036a0 <cpuid>
80105815:	85 c0                	test   %eax,%eax
80105817:	0f 84 b3 00 00 00    	je     801058d0 <trap+0x200>
8010581d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105820:	e8 7b cf ff ff       	call   801027a0 <lapiceoi>
    break;
80105825:	e9 56 ff ff ff       	jmp    80105780 <trap+0xb0>
8010582a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105830:	e8 bb cd ff ff       	call   801025f0 <kbdintr>
    lapiceoi();
80105835:	e8 66 cf ff ff       	call   801027a0 <lapiceoi>
    break;
8010583a:	e9 41 ff ff ff       	jmp    80105780 <trap+0xb0>
8010583f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105840:	e8 1b 02 00 00       	call   80105a60 <uartintr>
    lapiceoi();
80105845:	e8 56 cf ff ff       	call   801027a0 <lapiceoi>
    break;
8010584a:	e9 31 ff ff ff       	jmp    80105780 <trap+0xb0>
8010584f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105850:	8b 7b 38             	mov    0x38(%ebx),%edi
80105853:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105857:	e8 44 de ff ff       	call   801036a0 <cpuid>
8010585c:	c7 04 24 10 76 10 80 	movl   $0x80107610,(%esp)
80105863:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105867:	89 74 24 08          	mov    %esi,0x8(%esp)
8010586b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010586f:	e8 dc ad ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105874:	e8 27 cf ff ff       	call   801027a0 <lapiceoi>
    break;
80105879:	e9 02 ff ff ff       	jmp    80105780 <trap+0xb0>
8010587e:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105880:	e8 1b c8 ff ff       	call   801020a0 <ideintr>
80105885:	eb 96                	jmp    8010581d <trap+0x14d>
80105887:	90                   	nop
80105888:	90                   	nop
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105890:	e8 2b de ff ff       	call   801036c0 <myproc>
80105895:	8b 70 24             	mov    0x24(%eax),%esi
80105898:	85 f6                	test   %esi,%esi
8010589a:	75 2c                	jne    801058c8 <trap+0x1f8>
      exit();
    myproc()->tf = tf;
8010589c:	e8 1f de ff ff       	call   801036c0 <myproc>
801058a1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801058a4:	e8 b7 ed ff ff       	call   80104660 <syscall>
    if(myproc()->killed)
801058a9:	e8 12 de ff ff       	call   801036c0 <myproc>
801058ae:	8b 48 24             	mov    0x24(%eax),%ecx
801058b1:	85 c9                	test   %ecx,%ecx
801058b3:	0f 84 18 ff ff ff    	je     801057d1 <trap+0x101>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801058b9:	83 c4 3c             	add    $0x3c,%esp
801058bc:	5b                   	pop    %ebx
801058bd:	5e                   	pop    %esi
801058be:	5f                   	pop    %edi
801058bf:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801058c0:	e9 fb e1 ff ff       	jmp    80103ac0 <exit>
801058c5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801058c8:	e8 f3 e1 ff ff       	call   80103ac0 <exit>
801058cd:	eb cd                	jmp    8010589c <trap+0x1cc>
801058cf:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801058d0:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801058d7:	e8 84 e8 ff ff       	call   80104160 <acquire>
      ticks++;
      wakeup(&ticks);
801058dc:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801058e3:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
801058ea:	e8 c1 e4 ff ff       	call   80103db0 <wakeup>
      release(&tickslock);
801058ef:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801058f6:	e8 55 e9 ff ff       	call   80104250 <release>
801058fb:	e9 1d ff ff ff       	jmp    8010581d <trap+0x14d>
80105900:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105903:	8b 73 38             	mov    0x38(%ebx),%esi
80105906:	e8 95 dd ff ff       	call   801036a0 <cpuid>
8010590b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010590f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105913:	89 44 24 08          	mov    %eax,0x8(%esp)
80105917:	8b 43 30             	mov    0x30(%ebx),%eax
8010591a:	c7 04 24 34 76 10 80 	movl   $0x80107634,(%esp)
80105921:	89 44 24 04          	mov    %eax,0x4(%esp)
80105925:	e8 26 ad ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
8010592a:	c7 04 24 09 76 10 80 	movl   $0x80107609,(%esp)
80105931:	e8 2a aa ff ff       	call   80100360 <panic>
80105936:	66 90                	xchg   %ax,%ax
80105938:	66 90                	xchg   %ax,%ax
8010593a:	66 90                	xchg   %ax,%ax
8010593c:	66 90                	xchg   %ax,%ax
8010593e:	66 90                	xchg   %ax,%ax

80105940 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105940:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105945:	55                   	push   %ebp
80105946:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105948:	85 c0                	test   %eax,%eax
8010594a:	74 14                	je     80105960 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010594c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105951:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105952:	a8 01                	test   $0x1,%al
80105954:	74 0a                	je     80105960 <uartgetc+0x20>
80105956:	b2 f8                	mov    $0xf8,%dl
80105958:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105959:	0f b6 c0             	movzbl %al,%eax
}
8010595c:	5d                   	pop    %ebp
8010595d:	c3                   	ret    
8010595e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105965:	5d                   	pop    %ebp
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105970 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105970:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105975:	85 c0                	test   %eax,%eax
80105977:	74 3f                	je     801059b8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105979:	55                   	push   %ebp
8010597a:	89 e5                	mov    %esp,%ebp
8010597c:	56                   	push   %esi
8010597d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105982:	53                   	push   %ebx
  int i;

  if(!uart)
80105983:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105988:	83 ec 10             	sub    $0x10,%esp
8010598b:	eb 14                	jmp    801059a1 <uartputc+0x31>
8010598d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105990:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105997:	e8 24 ce ff ff       	call   801027c0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010599c:	83 eb 01             	sub    $0x1,%ebx
8010599f:	74 07                	je     801059a8 <uartputc+0x38>
801059a1:	89 f2                	mov    %esi,%edx
801059a3:	ec                   	in     (%dx),%al
801059a4:	a8 20                	test   $0x20,%al
801059a6:	74 e8                	je     80105990 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
801059a8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801059ac:	ba f8 03 00 00       	mov    $0x3f8,%edx
801059b1:	ee                   	out    %al,(%dx)
}
801059b2:	83 c4 10             	add    $0x10,%esp
801059b5:	5b                   	pop    %ebx
801059b6:	5e                   	pop    %esi
801059b7:	5d                   	pop    %ebp
801059b8:	f3 c3                	repz ret 
801059ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059c0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801059c0:	55                   	push   %ebp
801059c1:	31 c9                	xor    %ecx,%ecx
801059c3:	89 e5                	mov    %esp,%ebp
801059c5:	89 c8                	mov    %ecx,%eax
801059c7:	57                   	push   %edi
801059c8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801059cd:	56                   	push   %esi
801059ce:	89 fa                	mov    %edi,%edx
801059d0:	53                   	push   %ebx
801059d1:	83 ec 1c             	sub    $0x1c,%esp
801059d4:	ee                   	out    %al,(%dx)
801059d5:	be fb 03 00 00       	mov    $0x3fb,%esi
801059da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801059df:	89 f2                	mov    %esi,%edx
801059e1:	ee                   	out    %al,(%dx)
801059e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801059e7:	b2 f8                	mov    $0xf8,%dl
801059e9:	ee                   	out    %al,(%dx)
801059ea:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801059ef:	89 c8                	mov    %ecx,%eax
801059f1:	89 da                	mov    %ebx,%edx
801059f3:	ee                   	out    %al,(%dx)
801059f4:	b8 03 00 00 00       	mov    $0x3,%eax
801059f9:	89 f2                	mov    %esi,%edx
801059fb:	ee                   	out    %al,(%dx)
801059fc:	b2 fc                	mov    $0xfc,%dl
801059fe:	89 c8                	mov    %ecx,%eax
80105a00:	ee                   	out    %al,(%dx)
80105a01:	b8 01 00 00 00       	mov    $0x1,%eax
80105a06:	89 da                	mov    %ebx,%edx
80105a08:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a09:	b2 fd                	mov    $0xfd,%dl
80105a0b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105a0c:	3c ff                	cmp    $0xff,%al
80105a0e:	74 42                	je     80105a52 <uartinit+0x92>
    return;
  uart = 1;
80105a10:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105a17:	00 00 00 
80105a1a:	89 fa                	mov    %edi,%edx
80105a1c:	ec                   	in     (%dx),%al
80105a1d:	b2 f8                	mov    $0xf8,%dl
80105a1f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105a20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a27:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105a28:	bb 2c 77 10 80       	mov    $0x8010772c,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105a2d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105a34:	e8 97 c8 ff ff       	call   801022d0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105a39:	b8 78 00 00 00       	mov    $0x78,%eax
80105a3e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105a40:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105a43:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105a46:	e8 25 ff ff ff       	call   80105970 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105a4b:	0f be 03             	movsbl (%ebx),%eax
80105a4e:	84 c0                	test   %al,%al
80105a50:	75 ee                	jne    80105a40 <uartinit+0x80>
    uartputc(*p);
}
80105a52:	83 c4 1c             	add    $0x1c,%esp
80105a55:	5b                   	pop    %ebx
80105a56:	5e                   	pop    %esi
80105a57:	5f                   	pop    %edi
80105a58:	5d                   	pop    %ebp
80105a59:	c3                   	ret    
80105a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a60 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105a66:	c7 04 24 40 59 10 80 	movl   $0x80105940,(%esp)
80105a6d:	e8 3e ad ff ff       	call   801007b0 <consoleintr>
}
80105a72:	c9                   	leave  
80105a73:	c3                   	ret    

80105a74 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105a74:	6a 00                	push   $0x0
  pushl $0
80105a76:	6a 00                	push   $0x0
  jmp alltraps
80105a78:	e9 60 fb ff ff       	jmp    801055dd <alltraps>

80105a7d <vector1>:
.globl vector1
vector1:
  pushl $0
80105a7d:	6a 00                	push   $0x0
  pushl $1
80105a7f:	6a 01                	push   $0x1
  jmp alltraps
80105a81:	e9 57 fb ff ff       	jmp    801055dd <alltraps>

80105a86 <vector2>:
.globl vector2
vector2:
  pushl $0
80105a86:	6a 00                	push   $0x0
  pushl $2
80105a88:	6a 02                	push   $0x2
  jmp alltraps
80105a8a:	e9 4e fb ff ff       	jmp    801055dd <alltraps>

80105a8f <vector3>:
.globl vector3
vector3:
  pushl $0
80105a8f:	6a 00                	push   $0x0
  pushl $3
80105a91:	6a 03                	push   $0x3
  jmp alltraps
80105a93:	e9 45 fb ff ff       	jmp    801055dd <alltraps>

80105a98 <vector4>:
.globl vector4
vector4:
  pushl $0
80105a98:	6a 00                	push   $0x0
  pushl $4
80105a9a:	6a 04                	push   $0x4
  jmp alltraps
80105a9c:	e9 3c fb ff ff       	jmp    801055dd <alltraps>

80105aa1 <vector5>:
.globl vector5
vector5:
  pushl $0
80105aa1:	6a 00                	push   $0x0
  pushl $5
80105aa3:	6a 05                	push   $0x5
  jmp alltraps
80105aa5:	e9 33 fb ff ff       	jmp    801055dd <alltraps>

80105aaa <vector6>:
.globl vector6
vector6:
  pushl $0
80105aaa:	6a 00                	push   $0x0
  pushl $6
80105aac:	6a 06                	push   $0x6
  jmp alltraps
80105aae:	e9 2a fb ff ff       	jmp    801055dd <alltraps>

80105ab3 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ab3:	6a 00                	push   $0x0
  pushl $7
80105ab5:	6a 07                	push   $0x7
  jmp alltraps
80105ab7:	e9 21 fb ff ff       	jmp    801055dd <alltraps>

80105abc <vector8>:
.globl vector8
vector8:
  pushl $8
80105abc:	6a 08                	push   $0x8
  jmp alltraps
80105abe:	e9 1a fb ff ff       	jmp    801055dd <alltraps>

80105ac3 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ac3:	6a 00                	push   $0x0
  pushl $9
80105ac5:	6a 09                	push   $0x9
  jmp alltraps
80105ac7:	e9 11 fb ff ff       	jmp    801055dd <alltraps>

80105acc <vector10>:
.globl vector10
vector10:
  pushl $10
80105acc:	6a 0a                	push   $0xa
  jmp alltraps
80105ace:	e9 0a fb ff ff       	jmp    801055dd <alltraps>

80105ad3 <vector11>:
.globl vector11
vector11:
  pushl $11
80105ad3:	6a 0b                	push   $0xb
  jmp alltraps
80105ad5:	e9 03 fb ff ff       	jmp    801055dd <alltraps>

80105ada <vector12>:
.globl vector12
vector12:
  pushl $12
80105ada:	6a 0c                	push   $0xc
  jmp alltraps
80105adc:	e9 fc fa ff ff       	jmp    801055dd <alltraps>

80105ae1 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ae1:	6a 0d                	push   $0xd
  jmp alltraps
80105ae3:	e9 f5 fa ff ff       	jmp    801055dd <alltraps>

80105ae8 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ae8:	6a 0e                	push   $0xe
  jmp alltraps
80105aea:	e9 ee fa ff ff       	jmp    801055dd <alltraps>

80105aef <vector15>:
.globl vector15
vector15:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $15
80105af1:	6a 0f                	push   $0xf
  jmp alltraps
80105af3:	e9 e5 fa ff ff       	jmp    801055dd <alltraps>

80105af8 <vector16>:
.globl vector16
vector16:
  pushl $0
80105af8:	6a 00                	push   $0x0
  pushl $16
80105afa:	6a 10                	push   $0x10
  jmp alltraps
80105afc:	e9 dc fa ff ff       	jmp    801055dd <alltraps>

80105b01 <vector17>:
.globl vector17
vector17:
  pushl $17
80105b01:	6a 11                	push   $0x11
  jmp alltraps
80105b03:	e9 d5 fa ff ff       	jmp    801055dd <alltraps>

80105b08 <vector18>:
.globl vector18
vector18:
  pushl $0
80105b08:	6a 00                	push   $0x0
  pushl $18
80105b0a:	6a 12                	push   $0x12
  jmp alltraps
80105b0c:	e9 cc fa ff ff       	jmp    801055dd <alltraps>

80105b11 <vector19>:
.globl vector19
vector19:
  pushl $0
80105b11:	6a 00                	push   $0x0
  pushl $19
80105b13:	6a 13                	push   $0x13
  jmp alltraps
80105b15:	e9 c3 fa ff ff       	jmp    801055dd <alltraps>

80105b1a <vector20>:
.globl vector20
vector20:
  pushl $0
80105b1a:	6a 00                	push   $0x0
  pushl $20
80105b1c:	6a 14                	push   $0x14
  jmp alltraps
80105b1e:	e9 ba fa ff ff       	jmp    801055dd <alltraps>

80105b23 <vector21>:
.globl vector21
vector21:
  pushl $0
80105b23:	6a 00                	push   $0x0
  pushl $21
80105b25:	6a 15                	push   $0x15
  jmp alltraps
80105b27:	e9 b1 fa ff ff       	jmp    801055dd <alltraps>

80105b2c <vector22>:
.globl vector22
vector22:
  pushl $0
80105b2c:	6a 00                	push   $0x0
  pushl $22
80105b2e:	6a 16                	push   $0x16
  jmp alltraps
80105b30:	e9 a8 fa ff ff       	jmp    801055dd <alltraps>

80105b35 <vector23>:
.globl vector23
vector23:
  pushl $0
80105b35:	6a 00                	push   $0x0
  pushl $23
80105b37:	6a 17                	push   $0x17
  jmp alltraps
80105b39:	e9 9f fa ff ff       	jmp    801055dd <alltraps>

80105b3e <vector24>:
.globl vector24
vector24:
  pushl $0
80105b3e:	6a 00                	push   $0x0
  pushl $24
80105b40:	6a 18                	push   $0x18
  jmp alltraps
80105b42:	e9 96 fa ff ff       	jmp    801055dd <alltraps>

80105b47 <vector25>:
.globl vector25
vector25:
  pushl $0
80105b47:	6a 00                	push   $0x0
  pushl $25
80105b49:	6a 19                	push   $0x19
  jmp alltraps
80105b4b:	e9 8d fa ff ff       	jmp    801055dd <alltraps>

80105b50 <vector26>:
.globl vector26
vector26:
  pushl $0
80105b50:	6a 00                	push   $0x0
  pushl $26
80105b52:	6a 1a                	push   $0x1a
  jmp alltraps
80105b54:	e9 84 fa ff ff       	jmp    801055dd <alltraps>

80105b59 <vector27>:
.globl vector27
vector27:
  pushl $0
80105b59:	6a 00                	push   $0x0
  pushl $27
80105b5b:	6a 1b                	push   $0x1b
  jmp alltraps
80105b5d:	e9 7b fa ff ff       	jmp    801055dd <alltraps>

80105b62 <vector28>:
.globl vector28
vector28:
  pushl $0
80105b62:	6a 00                	push   $0x0
  pushl $28
80105b64:	6a 1c                	push   $0x1c
  jmp alltraps
80105b66:	e9 72 fa ff ff       	jmp    801055dd <alltraps>

80105b6b <vector29>:
.globl vector29
vector29:
  pushl $0
80105b6b:	6a 00                	push   $0x0
  pushl $29
80105b6d:	6a 1d                	push   $0x1d
  jmp alltraps
80105b6f:	e9 69 fa ff ff       	jmp    801055dd <alltraps>

80105b74 <vector30>:
.globl vector30
vector30:
  pushl $0
80105b74:	6a 00                	push   $0x0
  pushl $30
80105b76:	6a 1e                	push   $0x1e
  jmp alltraps
80105b78:	e9 60 fa ff ff       	jmp    801055dd <alltraps>

80105b7d <vector31>:
.globl vector31
vector31:
  pushl $0
80105b7d:	6a 00                	push   $0x0
  pushl $31
80105b7f:	6a 1f                	push   $0x1f
  jmp alltraps
80105b81:	e9 57 fa ff ff       	jmp    801055dd <alltraps>

80105b86 <vector32>:
.globl vector32
vector32:
  pushl $0
80105b86:	6a 00                	push   $0x0
  pushl $32
80105b88:	6a 20                	push   $0x20
  jmp alltraps
80105b8a:	e9 4e fa ff ff       	jmp    801055dd <alltraps>

80105b8f <vector33>:
.globl vector33
vector33:
  pushl $0
80105b8f:	6a 00                	push   $0x0
  pushl $33
80105b91:	6a 21                	push   $0x21
  jmp alltraps
80105b93:	e9 45 fa ff ff       	jmp    801055dd <alltraps>

80105b98 <vector34>:
.globl vector34
vector34:
  pushl $0
80105b98:	6a 00                	push   $0x0
  pushl $34
80105b9a:	6a 22                	push   $0x22
  jmp alltraps
80105b9c:	e9 3c fa ff ff       	jmp    801055dd <alltraps>

80105ba1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ba1:	6a 00                	push   $0x0
  pushl $35
80105ba3:	6a 23                	push   $0x23
  jmp alltraps
80105ba5:	e9 33 fa ff ff       	jmp    801055dd <alltraps>

80105baa <vector36>:
.globl vector36
vector36:
  pushl $0
80105baa:	6a 00                	push   $0x0
  pushl $36
80105bac:	6a 24                	push   $0x24
  jmp alltraps
80105bae:	e9 2a fa ff ff       	jmp    801055dd <alltraps>

80105bb3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105bb3:	6a 00                	push   $0x0
  pushl $37
80105bb5:	6a 25                	push   $0x25
  jmp alltraps
80105bb7:	e9 21 fa ff ff       	jmp    801055dd <alltraps>

80105bbc <vector38>:
.globl vector38
vector38:
  pushl $0
80105bbc:	6a 00                	push   $0x0
  pushl $38
80105bbe:	6a 26                	push   $0x26
  jmp alltraps
80105bc0:	e9 18 fa ff ff       	jmp    801055dd <alltraps>

80105bc5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105bc5:	6a 00                	push   $0x0
  pushl $39
80105bc7:	6a 27                	push   $0x27
  jmp alltraps
80105bc9:	e9 0f fa ff ff       	jmp    801055dd <alltraps>

80105bce <vector40>:
.globl vector40
vector40:
  pushl $0
80105bce:	6a 00                	push   $0x0
  pushl $40
80105bd0:	6a 28                	push   $0x28
  jmp alltraps
80105bd2:	e9 06 fa ff ff       	jmp    801055dd <alltraps>

80105bd7 <vector41>:
.globl vector41
vector41:
  pushl $0
80105bd7:	6a 00                	push   $0x0
  pushl $41
80105bd9:	6a 29                	push   $0x29
  jmp alltraps
80105bdb:	e9 fd f9 ff ff       	jmp    801055dd <alltraps>

80105be0 <vector42>:
.globl vector42
vector42:
  pushl $0
80105be0:	6a 00                	push   $0x0
  pushl $42
80105be2:	6a 2a                	push   $0x2a
  jmp alltraps
80105be4:	e9 f4 f9 ff ff       	jmp    801055dd <alltraps>

80105be9 <vector43>:
.globl vector43
vector43:
  pushl $0
80105be9:	6a 00                	push   $0x0
  pushl $43
80105beb:	6a 2b                	push   $0x2b
  jmp alltraps
80105bed:	e9 eb f9 ff ff       	jmp    801055dd <alltraps>

80105bf2 <vector44>:
.globl vector44
vector44:
  pushl $0
80105bf2:	6a 00                	push   $0x0
  pushl $44
80105bf4:	6a 2c                	push   $0x2c
  jmp alltraps
80105bf6:	e9 e2 f9 ff ff       	jmp    801055dd <alltraps>

80105bfb <vector45>:
.globl vector45
vector45:
  pushl $0
80105bfb:	6a 00                	push   $0x0
  pushl $45
80105bfd:	6a 2d                	push   $0x2d
  jmp alltraps
80105bff:	e9 d9 f9 ff ff       	jmp    801055dd <alltraps>

80105c04 <vector46>:
.globl vector46
vector46:
  pushl $0
80105c04:	6a 00                	push   $0x0
  pushl $46
80105c06:	6a 2e                	push   $0x2e
  jmp alltraps
80105c08:	e9 d0 f9 ff ff       	jmp    801055dd <alltraps>

80105c0d <vector47>:
.globl vector47
vector47:
  pushl $0
80105c0d:	6a 00                	push   $0x0
  pushl $47
80105c0f:	6a 2f                	push   $0x2f
  jmp alltraps
80105c11:	e9 c7 f9 ff ff       	jmp    801055dd <alltraps>

80105c16 <vector48>:
.globl vector48
vector48:
  pushl $0
80105c16:	6a 00                	push   $0x0
  pushl $48
80105c18:	6a 30                	push   $0x30
  jmp alltraps
80105c1a:	e9 be f9 ff ff       	jmp    801055dd <alltraps>

80105c1f <vector49>:
.globl vector49
vector49:
  pushl $0
80105c1f:	6a 00                	push   $0x0
  pushl $49
80105c21:	6a 31                	push   $0x31
  jmp alltraps
80105c23:	e9 b5 f9 ff ff       	jmp    801055dd <alltraps>

80105c28 <vector50>:
.globl vector50
vector50:
  pushl $0
80105c28:	6a 00                	push   $0x0
  pushl $50
80105c2a:	6a 32                	push   $0x32
  jmp alltraps
80105c2c:	e9 ac f9 ff ff       	jmp    801055dd <alltraps>

80105c31 <vector51>:
.globl vector51
vector51:
  pushl $0
80105c31:	6a 00                	push   $0x0
  pushl $51
80105c33:	6a 33                	push   $0x33
  jmp alltraps
80105c35:	e9 a3 f9 ff ff       	jmp    801055dd <alltraps>

80105c3a <vector52>:
.globl vector52
vector52:
  pushl $0
80105c3a:	6a 00                	push   $0x0
  pushl $52
80105c3c:	6a 34                	push   $0x34
  jmp alltraps
80105c3e:	e9 9a f9 ff ff       	jmp    801055dd <alltraps>

80105c43 <vector53>:
.globl vector53
vector53:
  pushl $0
80105c43:	6a 00                	push   $0x0
  pushl $53
80105c45:	6a 35                	push   $0x35
  jmp alltraps
80105c47:	e9 91 f9 ff ff       	jmp    801055dd <alltraps>

80105c4c <vector54>:
.globl vector54
vector54:
  pushl $0
80105c4c:	6a 00                	push   $0x0
  pushl $54
80105c4e:	6a 36                	push   $0x36
  jmp alltraps
80105c50:	e9 88 f9 ff ff       	jmp    801055dd <alltraps>

80105c55 <vector55>:
.globl vector55
vector55:
  pushl $0
80105c55:	6a 00                	push   $0x0
  pushl $55
80105c57:	6a 37                	push   $0x37
  jmp alltraps
80105c59:	e9 7f f9 ff ff       	jmp    801055dd <alltraps>

80105c5e <vector56>:
.globl vector56
vector56:
  pushl $0
80105c5e:	6a 00                	push   $0x0
  pushl $56
80105c60:	6a 38                	push   $0x38
  jmp alltraps
80105c62:	e9 76 f9 ff ff       	jmp    801055dd <alltraps>

80105c67 <vector57>:
.globl vector57
vector57:
  pushl $0
80105c67:	6a 00                	push   $0x0
  pushl $57
80105c69:	6a 39                	push   $0x39
  jmp alltraps
80105c6b:	e9 6d f9 ff ff       	jmp    801055dd <alltraps>

80105c70 <vector58>:
.globl vector58
vector58:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $58
80105c72:	6a 3a                	push   $0x3a
  jmp alltraps
80105c74:	e9 64 f9 ff ff       	jmp    801055dd <alltraps>

80105c79 <vector59>:
.globl vector59
vector59:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $59
80105c7b:	6a 3b                	push   $0x3b
  jmp alltraps
80105c7d:	e9 5b f9 ff ff       	jmp    801055dd <alltraps>

80105c82 <vector60>:
.globl vector60
vector60:
  pushl $0
80105c82:	6a 00                	push   $0x0
  pushl $60
80105c84:	6a 3c                	push   $0x3c
  jmp alltraps
80105c86:	e9 52 f9 ff ff       	jmp    801055dd <alltraps>

80105c8b <vector61>:
.globl vector61
vector61:
  pushl $0
80105c8b:	6a 00                	push   $0x0
  pushl $61
80105c8d:	6a 3d                	push   $0x3d
  jmp alltraps
80105c8f:	e9 49 f9 ff ff       	jmp    801055dd <alltraps>

80105c94 <vector62>:
.globl vector62
vector62:
  pushl $0
80105c94:	6a 00                	push   $0x0
  pushl $62
80105c96:	6a 3e                	push   $0x3e
  jmp alltraps
80105c98:	e9 40 f9 ff ff       	jmp    801055dd <alltraps>

80105c9d <vector63>:
.globl vector63
vector63:
  pushl $0
80105c9d:	6a 00                	push   $0x0
  pushl $63
80105c9f:	6a 3f                	push   $0x3f
  jmp alltraps
80105ca1:	e9 37 f9 ff ff       	jmp    801055dd <alltraps>

80105ca6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ca6:	6a 00                	push   $0x0
  pushl $64
80105ca8:	6a 40                	push   $0x40
  jmp alltraps
80105caa:	e9 2e f9 ff ff       	jmp    801055dd <alltraps>

80105caf <vector65>:
.globl vector65
vector65:
  pushl $0
80105caf:	6a 00                	push   $0x0
  pushl $65
80105cb1:	6a 41                	push   $0x41
  jmp alltraps
80105cb3:	e9 25 f9 ff ff       	jmp    801055dd <alltraps>

80105cb8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105cb8:	6a 00                	push   $0x0
  pushl $66
80105cba:	6a 42                	push   $0x42
  jmp alltraps
80105cbc:	e9 1c f9 ff ff       	jmp    801055dd <alltraps>

80105cc1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105cc1:	6a 00                	push   $0x0
  pushl $67
80105cc3:	6a 43                	push   $0x43
  jmp alltraps
80105cc5:	e9 13 f9 ff ff       	jmp    801055dd <alltraps>

80105cca <vector68>:
.globl vector68
vector68:
  pushl $0
80105cca:	6a 00                	push   $0x0
  pushl $68
80105ccc:	6a 44                	push   $0x44
  jmp alltraps
80105cce:	e9 0a f9 ff ff       	jmp    801055dd <alltraps>

80105cd3 <vector69>:
.globl vector69
vector69:
  pushl $0
80105cd3:	6a 00                	push   $0x0
  pushl $69
80105cd5:	6a 45                	push   $0x45
  jmp alltraps
80105cd7:	e9 01 f9 ff ff       	jmp    801055dd <alltraps>

80105cdc <vector70>:
.globl vector70
vector70:
  pushl $0
80105cdc:	6a 00                	push   $0x0
  pushl $70
80105cde:	6a 46                	push   $0x46
  jmp alltraps
80105ce0:	e9 f8 f8 ff ff       	jmp    801055dd <alltraps>

80105ce5 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ce5:	6a 00                	push   $0x0
  pushl $71
80105ce7:	6a 47                	push   $0x47
  jmp alltraps
80105ce9:	e9 ef f8 ff ff       	jmp    801055dd <alltraps>

80105cee <vector72>:
.globl vector72
vector72:
  pushl $0
80105cee:	6a 00                	push   $0x0
  pushl $72
80105cf0:	6a 48                	push   $0x48
  jmp alltraps
80105cf2:	e9 e6 f8 ff ff       	jmp    801055dd <alltraps>

80105cf7 <vector73>:
.globl vector73
vector73:
  pushl $0
80105cf7:	6a 00                	push   $0x0
  pushl $73
80105cf9:	6a 49                	push   $0x49
  jmp alltraps
80105cfb:	e9 dd f8 ff ff       	jmp    801055dd <alltraps>

80105d00 <vector74>:
.globl vector74
vector74:
  pushl $0
80105d00:	6a 00                	push   $0x0
  pushl $74
80105d02:	6a 4a                	push   $0x4a
  jmp alltraps
80105d04:	e9 d4 f8 ff ff       	jmp    801055dd <alltraps>

80105d09 <vector75>:
.globl vector75
vector75:
  pushl $0
80105d09:	6a 00                	push   $0x0
  pushl $75
80105d0b:	6a 4b                	push   $0x4b
  jmp alltraps
80105d0d:	e9 cb f8 ff ff       	jmp    801055dd <alltraps>

80105d12 <vector76>:
.globl vector76
vector76:
  pushl $0
80105d12:	6a 00                	push   $0x0
  pushl $76
80105d14:	6a 4c                	push   $0x4c
  jmp alltraps
80105d16:	e9 c2 f8 ff ff       	jmp    801055dd <alltraps>

80105d1b <vector77>:
.globl vector77
vector77:
  pushl $0
80105d1b:	6a 00                	push   $0x0
  pushl $77
80105d1d:	6a 4d                	push   $0x4d
  jmp alltraps
80105d1f:	e9 b9 f8 ff ff       	jmp    801055dd <alltraps>

80105d24 <vector78>:
.globl vector78
vector78:
  pushl $0
80105d24:	6a 00                	push   $0x0
  pushl $78
80105d26:	6a 4e                	push   $0x4e
  jmp alltraps
80105d28:	e9 b0 f8 ff ff       	jmp    801055dd <alltraps>

80105d2d <vector79>:
.globl vector79
vector79:
  pushl $0
80105d2d:	6a 00                	push   $0x0
  pushl $79
80105d2f:	6a 4f                	push   $0x4f
  jmp alltraps
80105d31:	e9 a7 f8 ff ff       	jmp    801055dd <alltraps>

80105d36 <vector80>:
.globl vector80
vector80:
  pushl $0
80105d36:	6a 00                	push   $0x0
  pushl $80
80105d38:	6a 50                	push   $0x50
  jmp alltraps
80105d3a:	e9 9e f8 ff ff       	jmp    801055dd <alltraps>

80105d3f <vector81>:
.globl vector81
vector81:
  pushl $0
80105d3f:	6a 00                	push   $0x0
  pushl $81
80105d41:	6a 51                	push   $0x51
  jmp alltraps
80105d43:	e9 95 f8 ff ff       	jmp    801055dd <alltraps>

80105d48 <vector82>:
.globl vector82
vector82:
  pushl $0
80105d48:	6a 00                	push   $0x0
  pushl $82
80105d4a:	6a 52                	push   $0x52
  jmp alltraps
80105d4c:	e9 8c f8 ff ff       	jmp    801055dd <alltraps>

80105d51 <vector83>:
.globl vector83
vector83:
  pushl $0
80105d51:	6a 00                	push   $0x0
  pushl $83
80105d53:	6a 53                	push   $0x53
  jmp alltraps
80105d55:	e9 83 f8 ff ff       	jmp    801055dd <alltraps>

80105d5a <vector84>:
.globl vector84
vector84:
  pushl $0
80105d5a:	6a 00                	push   $0x0
  pushl $84
80105d5c:	6a 54                	push   $0x54
  jmp alltraps
80105d5e:	e9 7a f8 ff ff       	jmp    801055dd <alltraps>

80105d63 <vector85>:
.globl vector85
vector85:
  pushl $0
80105d63:	6a 00                	push   $0x0
  pushl $85
80105d65:	6a 55                	push   $0x55
  jmp alltraps
80105d67:	e9 71 f8 ff ff       	jmp    801055dd <alltraps>

80105d6c <vector86>:
.globl vector86
vector86:
  pushl $0
80105d6c:	6a 00                	push   $0x0
  pushl $86
80105d6e:	6a 56                	push   $0x56
  jmp alltraps
80105d70:	e9 68 f8 ff ff       	jmp    801055dd <alltraps>

80105d75 <vector87>:
.globl vector87
vector87:
  pushl $0
80105d75:	6a 00                	push   $0x0
  pushl $87
80105d77:	6a 57                	push   $0x57
  jmp alltraps
80105d79:	e9 5f f8 ff ff       	jmp    801055dd <alltraps>

80105d7e <vector88>:
.globl vector88
vector88:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $88
80105d80:	6a 58                	push   $0x58
  jmp alltraps
80105d82:	e9 56 f8 ff ff       	jmp    801055dd <alltraps>

80105d87 <vector89>:
.globl vector89
vector89:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $89
80105d89:	6a 59                	push   $0x59
  jmp alltraps
80105d8b:	e9 4d f8 ff ff       	jmp    801055dd <alltraps>

80105d90 <vector90>:
.globl vector90
vector90:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $90
80105d92:	6a 5a                	push   $0x5a
  jmp alltraps
80105d94:	e9 44 f8 ff ff       	jmp    801055dd <alltraps>

80105d99 <vector91>:
.globl vector91
vector91:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $91
80105d9b:	6a 5b                	push   $0x5b
  jmp alltraps
80105d9d:	e9 3b f8 ff ff       	jmp    801055dd <alltraps>

80105da2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $92
80105da4:	6a 5c                	push   $0x5c
  jmp alltraps
80105da6:	e9 32 f8 ff ff       	jmp    801055dd <alltraps>

80105dab <vector93>:
.globl vector93
vector93:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $93
80105dad:	6a 5d                	push   $0x5d
  jmp alltraps
80105daf:	e9 29 f8 ff ff       	jmp    801055dd <alltraps>

80105db4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105db4:	6a 00                	push   $0x0
  pushl $94
80105db6:	6a 5e                	push   $0x5e
  jmp alltraps
80105db8:	e9 20 f8 ff ff       	jmp    801055dd <alltraps>

80105dbd <vector95>:
.globl vector95
vector95:
  pushl $0
80105dbd:	6a 00                	push   $0x0
  pushl $95
80105dbf:	6a 5f                	push   $0x5f
  jmp alltraps
80105dc1:	e9 17 f8 ff ff       	jmp    801055dd <alltraps>

80105dc6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $96
80105dc8:	6a 60                	push   $0x60
  jmp alltraps
80105dca:	e9 0e f8 ff ff       	jmp    801055dd <alltraps>

80105dcf <vector97>:
.globl vector97
vector97:
  pushl $0
80105dcf:	6a 00                	push   $0x0
  pushl $97
80105dd1:	6a 61                	push   $0x61
  jmp alltraps
80105dd3:	e9 05 f8 ff ff       	jmp    801055dd <alltraps>

80105dd8 <vector98>:
.globl vector98
vector98:
  pushl $0
80105dd8:	6a 00                	push   $0x0
  pushl $98
80105dda:	6a 62                	push   $0x62
  jmp alltraps
80105ddc:	e9 fc f7 ff ff       	jmp    801055dd <alltraps>

80105de1 <vector99>:
.globl vector99
vector99:
  pushl $0
80105de1:	6a 00                	push   $0x0
  pushl $99
80105de3:	6a 63                	push   $0x63
  jmp alltraps
80105de5:	e9 f3 f7 ff ff       	jmp    801055dd <alltraps>

80105dea <vector100>:
.globl vector100
vector100:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $100
80105dec:	6a 64                	push   $0x64
  jmp alltraps
80105dee:	e9 ea f7 ff ff       	jmp    801055dd <alltraps>

80105df3 <vector101>:
.globl vector101
vector101:
  pushl $0
80105df3:	6a 00                	push   $0x0
  pushl $101
80105df5:	6a 65                	push   $0x65
  jmp alltraps
80105df7:	e9 e1 f7 ff ff       	jmp    801055dd <alltraps>

80105dfc <vector102>:
.globl vector102
vector102:
  pushl $0
80105dfc:	6a 00                	push   $0x0
  pushl $102
80105dfe:	6a 66                	push   $0x66
  jmp alltraps
80105e00:	e9 d8 f7 ff ff       	jmp    801055dd <alltraps>

80105e05 <vector103>:
.globl vector103
vector103:
  pushl $0
80105e05:	6a 00                	push   $0x0
  pushl $103
80105e07:	6a 67                	push   $0x67
  jmp alltraps
80105e09:	e9 cf f7 ff ff       	jmp    801055dd <alltraps>

80105e0e <vector104>:
.globl vector104
vector104:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $104
80105e10:	6a 68                	push   $0x68
  jmp alltraps
80105e12:	e9 c6 f7 ff ff       	jmp    801055dd <alltraps>

80105e17 <vector105>:
.globl vector105
vector105:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $105
80105e19:	6a 69                	push   $0x69
  jmp alltraps
80105e1b:	e9 bd f7 ff ff       	jmp    801055dd <alltraps>

80105e20 <vector106>:
.globl vector106
vector106:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $106
80105e22:	6a 6a                	push   $0x6a
  jmp alltraps
80105e24:	e9 b4 f7 ff ff       	jmp    801055dd <alltraps>

80105e29 <vector107>:
.globl vector107
vector107:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $107
80105e2b:	6a 6b                	push   $0x6b
  jmp alltraps
80105e2d:	e9 ab f7 ff ff       	jmp    801055dd <alltraps>

80105e32 <vector108>:
.globl vector108
vector108:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $108
80105e34:	6a 6c                	push   $0x6c
  jmp alltraps
80105e36:	e9 a2 f7 ff ff       	jmp    801055dd <alltraps>

80105e3b <vector109>:
.globl vector109
vector109:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $109
80105e3d:	6a 6d                	push   $0x6d
  jmp alltraps
80105e3f:	e9 99 f7 ff ff       	jmp    801055dd <alltraps>

80105e44 <vector110>:
.globl vector110
vector110:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $110
80105e46:	6a 6e                	push   $0x6e
  jmp alltraps
80105e48:	e9 90 f7 ff ff       	jmp    801055dd <alltraps>

80105e4d <vector111>:
.globl vector111
vector111:
  pushl $0
80105e4d:	6a 00                	push   $0x0
  pushl $111
80105e4f:	6a 6f                	push   $0x6f
  jmp alltraps
80105e51:	e9 87 f7 ff ff       	jmp    801055dd <alltraps>

80105e56 <vector112>:
.globl vector112
vector112:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $112
80105e58:	6a 70                	push   $0x70
  jmp alltraps
80105e5a:	e9 7e f7 ff ff       	jmp    801055dd <alltraps>

80105e5f <vector113>:
.globl vector113
vector113:
  pushl $0
80105e5f:	6a 00                	push   $0x0
  pushl $113
80105e61:	6a 71                	push   $0x71
  jmp alltraps
80105e63:	e9 75 f7 ff ff       	jmp    801055dd <alltraps>

80105e68 <vector114>:
.globl vector114
vector114:
  pushl $0
80105e68:	6a 00                	push   $0x0
  pushl $114
80105e6a:	6a 72                	push   $0x72
  jmp alltraps
80105e6c:	e9 6c f7 ff ff       	jmp    801055dd <alltraps>

80105e71 <vector115>:
.globl vector115
vector115:
  pushl $0
80105e71:	6a 00                	push   $0x0
  pushl $115
80105e73:	6a 73                	push   $0x73
  jmp alltraps
80105e75:	e9 63 f7 ff ff       	jmp    801055dd <alltraps>

80105e7a <vector116>:
.globl vector116
vector116:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $116
80105e7c:	6a 74                	push   $0x74
  jmp alltraps
80105e7e:	e9 5a f7 ff ff       	jmp    801055dd <alltraps>

80105e83 <vector117>:
.globl vector117
vector117:
  pushl $0
80105e83:	6a 00                	push   $0x0
  pushl $117
80105e85:	6a 75                	push   $0x75
  jmp alltraps
80105e87:	e9 51 f7 ff ff       	jmp    801055dd <alltraps>

80105e8c <vector118>:
.globl vector118
vector118:
  pushl $0
80105e8c:	6a 00                	push   $0x0
  pushl $118
80105e8e:	6a 76                	push   $0x76
  jmp alltraps
80105e90:	e9 48 f7 ff ff       	jmp    801055dd <alltraps>

80105e95 <vector119>:
.globl vector119
vector119:
  pushl $0
80105e95:	6a 00                	push   $0x0
  pushl $119
80105e97:	6a 77                	push   $0x77
  jmp alltraps
80105e99:	e9 3f f7 ff ff       	jmp    801055dd <alltraps>

80105e9e <vector120>:
.globl vector120
vector120:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $120
80105ea0:	6a 78                	push   $0x78
  jmp alltraps
80105ea2:	e9 36 f7 ff ff       	jmp    801055dd <alltraps>

80105ea7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105ea7:	6a 00                	push   $0x0
  pushl $121
80105ea9:	6a 79                	push   $0x79
  jmp alltraps
80105eab:	e9 2d f7 ff ff       	jmp    801055dd <alltraps>

80105eb0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105eb0:	6a 00                	push   $0x0
  pushl $122
80105eb2:	6a 7a                	push   $0x7a
  jmp alltraps
80105eb4:	e9 24 f7 ff ff       	jmp    801055dd <alltraps>

80105eb9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105eb9:	6a 00                	push   $0x0
  pushl $123
80105ebb:	6a 7b                	push   $0x7b
  jmp alltraps
80105ebd:	e9 1b f7 ff ff       	jmp    801055dd <alltraps>

80105ec2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $124
80105ec4:	6a 7c                	push   $0x7c
  jmp alltraps
80105ec6:	e9 12 f7 ff ff       	jmp    801055dd <alltraps>

80105ecb <vector125>:
.globl vector125
vector125:
  pushl $0
80105ecb:	6a 00                	push   $0x0
  pushl $125
80105ecd:	6a 7d                	push   $0x7d
  jmp alltraps
80105ecf:	e9 09 f7 ff ff       	jmp    801055dd <alltraps>

80105ed4 <vector126>:
.globl vector126
vector126:
  pushl $0
80105ed4:	6a 00                	push   $0x0
  pushl $126
80105ed6:	6a 7e                	push   $0x7e
  jmp alltraps
80105ed8:	e9 00 f7 ff ff       	jmp    801055dd <alltraps>

80105edd <vector127>:
.globl vector127
vector127:
  pushl $0
80105edd:	6a 00                	push   $0x0
  pushl $127
80105edf:	6a 7f                	push   $0x7f
  jmp alltraps
80105ee1:	e9 f7 f6 ff ff       	jmp    801055dd <alltraps>

80105ee6 <vector128>:
.globl vector128
vector128:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $128
80105ee8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105eed:	e9 eb f6 ff ff       	jmp    801055dd <alltraps>

80105ef2 <vector129>:
.globl vector129
vector129:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $129
80105ef4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105ef9:	e9 df f6 ff ff       	jmp    801055dd <alltraps>

80105efe <vector130>:
.globl vector130
vector130:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $130
80105f00:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105f05:	e9 d3 f6 ff ff       	jmp    801055dd <alltraps>

80105f0a <vector131>:
.globl vector131
vector131:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $131
80105f0c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105f11:	e9 c7 f6 ff ff       	jmp    801055dd <alltraps>

80105f16 <vector132>:
.globl vector132
vector132:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $132
80105f18:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105f1d:	e9 bb f6 ff ff       	jmp    801055dd <alltraps>

80105f22 <vector133>:
.globl vector133
vector133:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $133
80105f24:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105f29:	e9 af f6 ff ff       	jmp    801055dd <alltraps>

80105f2e <vector134>:
.globl vector134
vector134:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $134
80105f30:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105f35:	e9 a3 f6 ff ff       	jmp    801055dd <alltraps>

80105f3a <vector135>:
.globl vector135
vector135:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $135
80105f3c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105f41:	e9 97 f6 ff ff       	jmp    801055dd <alltraps>

80105f46 <vector136>:
.globl vector136
vector136:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $136
80105f48:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105f4d:	e9 8b f6 ff ff       	jmp    801055dd <alltraps>

80105f52 <vector137>:
.globl vector137
vector137:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $137
80105f54:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105f59:	e9 7f f6 ff ff       	jmp    801055dd <alltraps>

80105f5e <vector138>:
.globl vector138
vector138:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $138
80105f60:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105f65:	e9 73 f6 ff ff       	jmp    801055dd <alltraps>

80105f6a <vector139>:
.globl vector139
vector139:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $139
80105f6c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105f71:	e9 67 f6 ff ff       	jmp    801055dd <alltraps>

80105f76 <vector140>:
.globl vector140
vector140:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $140
80105f78:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105f7d:	e9 5b f6 ff ff       	jmp    801055dd <alltraps>

80105f82 <vector141>:
.globl vector141
vector141:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $141
80105f84:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105f89:	e9 4f f6 ff ff       	jmp    801055dd <alltraps>

80105f8e <vector142>:
.globl vector142
vector142:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $142
80105f90:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105f95:	e9 43 f6 ff ff       	jmp    801055dd <alltraps>

80105f9a <vector143>:
.globl vector143
vector143:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $143
80105f9c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105fa1:	e9 37 f6 ff ff       	jmp    801055dd <alltraps>

80105fa6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $144
80105fa8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105fad:	e9 2b f6 ff ff       	jmp    801055dd <alltraps>

80105fb2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $145
80105fb4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105fb9:	e9 1f f6 ff ff       	jmp    801055dd <alltraps>

80105fbe <vector146>:
.globl vector146
vector146:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $146
80105fc0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105fc5:	e9 13 f6 ff ff       	jmp    801055dd <alltraps>

80105fca <vector147>:
.globl vector147
vector147:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $147
80105fcc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105fd1:	e9 07 f6 ff ff       	jmp    801055dd <alltraps>

80105fd6 <vector148>:
.globl vector148
vector148:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $148
80105fd8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105fdd:	e9 fb f5 ff ff       	jmp    801055dd <alltraps>

80105fe2 <vector149>:
.globl vector149
vector149:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $149
80105fe4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105fe9:	e9 ef f5 ff ff       	jmp    801055dd <alltraps>

80105fee <vector150>:
.globl vector150
vector150:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $150
80105ff0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105ff5:	e9 e3 f5 ff ff       	jmp    801055dd <alltraps>

80105ffa <vector151>:
.globl vector151
vector151:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $151
80105ffc:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106001:	e9 d7 f5 ff ff       	jmp    801055dd <alltraps>

80106006 <vector152>:
.globl vector152
vector152:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $152
80106008:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010600d:	e9 cb f5 ff ff       	jmp    801055dd <alltraps>

80106012 <vector153>:
.globl vector153
vector153:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $153
80106014:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106019:	e9 bf f5 ff ff       	jmp    801055dd <alltraps>

8010601e <vector154>:
.globl vector154
vector154:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $154
80106020:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106025:	e9 b3 f5 ff ff       	jmp    801055dd <alltraps>

8010602a <vector155>:
.globl vector155
vector155:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $155
8010602c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106031:	e9 a7 f5 ff ff       	jmp    801055dd <alltraps>

80106036 <vector156>:
.globl vector156
vector156:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $156
80106038:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010603d:	e9 9b f5 ff ff       	jmp    801055dd <alltraps>

80106042 <vector157>:
.globl vector157
vector157:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $157
80106044:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106049:	e9 8f f5 ff ff       	jmp    801055dd <alltraps>

8010604e <vector158>:
.globl vector158
vector158:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $158
80106050:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106055:	e9 83 f5 ff ff       	jmp    801055dd <alltraps>

8010605a <vector159>:
.globl vector159
vector159:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $159
8010605c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106061:	e9 77 f5 ff ff       	jmp    801055dd <alltraps>

80106066 <vector160>:
.globl vector160
vector160:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $160
80106068:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010606d:	e9 6b f5 ff ff       	jmp    801055dd <alltraps>

80106072 <vector161>:
.globl vector161
vector161:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $161
80106074:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106079:	e9 5f f5 ff ff       	jmp    801055dd <alltraps>

8010607e <vector162>:
.globl vector162
vector162:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $162
80106080:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106085:	e9 53 f5 ff ff       	jmp    801055dd <alltraps>

8010608a <vector163>:
.globl vector163
vector163:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $163
8010608c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106091:	e9 47 f5 ff ff       	jmp    801055dd <alltraps>

80106096 <vector164>:
.globl vector164
vector164:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $164
80106098:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010609d:	e9 3b f5 ff ff       	jmp    801055dd <alltraps>

801060a2 <vector165>:
.globl vector165
vector165:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $165
801060a4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801060a9:	e9 2f f5 ff ff       	jmp    801055dd <alltraps>

801060ae <vector166>:
.globl vector166
vector166:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $166
801060b0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801060b5:	e9 23 f5 ff ff       	jmp    801055dd <alltraps>

801060ba <vector167>:
.globl vector167
vector167:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $167
801060bc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801060c1:	e9 17 f5 ff ff       	jmp    801055dd <alltraps>

801060c6 <vector168>:
.globl vector168
vector168:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $168
801060c8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801060cd:	e9 0b f5 ff ff       	jmp    801055dd <alltraps>

801060d2 <vector169>:
.globl vector169
vector169:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $169
801060d4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801060d9:	e9 ff f4 ff ff       	jmp    801055dd <alltraps>

801060de <vector170>:
.globl vector170
vector170:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $170
801060e0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801060e5:	e9 f3 f4 ff ff       	jmp    801055dd <alltraps>

801060ea <vector171>:
.globl vector171
vector171:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $171
801060ec:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801060f1:	e9 e7 f4 ff ff       	jmp    801055dd <alltraps>

801060f6 <vector172>:
.globl vector172
vector172:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $172
801060f8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801060fd:	e9 db f4 ff ff       	jmp    801055dd <alltraps>

80106102 <vector173>:
.globl vector173
vector173:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $173
80106104:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106109:	e9 cf f4 ff ff       	jmp    801055dd <alltraps>

8010610e <vector174>:
.globl vector174
vector174:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $174
80106110:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106115:	e9 c3 f4 ff ff       	jmp    801055dd <alltraps>

8010611a <vector175>:
.globl vector175
vector175:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $175
8010611c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106121:	e9 b7 f4 ff ff       	jmp    801055dd <alltraps>

80106126 <vector176>:
.globl vector176
vector176:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $176
80106128:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010612d:	e9 ab f4 ff ff       	jmp    801055dd <alltraps>

80106132 <vector177>:
.globl vector177
vector177:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $177
80106134:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106139:	e9 9f f4 ff ff       	jmp    801055dd <alltraps>

8010613e <vector178>:
.globl vector178
vector178:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $178
80106140:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106145:	e9 93 f4 ff ff       	jmp    801055dd <alltraps>

8010614a <vector179>:
.globl vector179
vector179:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $179
8010614c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106151:	e9 87 f4 ff ff       	jmp    801055dd <alltraps>

80106156 <vector180>:
.globl vector180
vector180:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $180
80106158:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010615d:	e9 7b f4 ff ff       	jmp    801055dd <alltraps>

80106162 <vector181>:
.globl vector181
vector181:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $181
80106164:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106169:	e9 6f f4 ff ff       	jmp    801055dd <alltraps>

8010616e <vector182>:
.globl vector182
vector182:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $182
80106170:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106175:	e9 63 f4 ff ff       	jmp    801055dd <alltraps>

8010617a <vector183>:
.globl vector183
vector183:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $183
8010617c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106181:	e9 57 f4 ff ff       	jmp    801055dd <alltraps>

80106186 <vector184>:
.globl vector184
vector184:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $184
80106188:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010618d:	e9 4b f4 ff ff       	jmp    801055dd <alltraps>

80106192 <vector185>:
.globl vector185
vector185:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $185
80106194:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106199:	e9 3f f4 ff ff       	jmp    801055dd <alltraps>

8010619e <vector186>:
.globl vector186
vector186:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $186
801061a0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801061a5:	e9 33 f4 ff ff       	jmp    801055dd <alltraps>

801061aa <vector187>:
.globl vector187
vector187:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $187
801061ac:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801061b1:	e9 27 f4 ff ff       	jmp    801055dd <alltraps>

801061b6 <vector188>:
.globl vector188
vector188:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $188
801061b8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801061bd:	e9 1b f4 ff ff       	jmp    801055dd <alltraps>

801061c2 <vector189>:
.globl vector189
vector189:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $189
801061c4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801061c9:	e9 0f f4 ff ff       	jmp    801055dd <alltraps>

801061ce <vector190>:
.globl vector190
vector190:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $190
801061d0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801061d5:	e9 03 f4 ff ff       	jmp    801055dd <alltraps>

801061da <vector191>:
.globl vector191
vector191:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $191
801061dc:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801061e1:	e9 f7 f3 ff ff       	jmp    801055dd <alltraps>

801061e6 <vector192>:
.globl vector192
vector192:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $192
801061e8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801061ed:	e9 eb f3 ff ff       	jmp    801055dd <alltraps>

801061f2 <vector193>:
.globl vector193
vector193:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $193
801061f4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801061f9:	e9 df f3 ff ff       	jmp    801055dd <alltraps>

801061fe <vector194>:
.globl vector194
vector194:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $194
80106200:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106205:	e9 d3 f3 ff ff       	jmp    801055dd <alltraps>

8010620a <vector195>:
.globl vector195
vector195:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $195
8010620c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106211:	e9 c7 f3 ff ff       	jmp    801055dd <alltraps>

80106216 <vector196>:
.globl vector196
vector196:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $196
80106218:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010621d:	e9 bb f3 ff ff       	jmp    801055dd <alltraps>

80106222 <vector197>:
.globl vector197
vector197:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $197
80106224:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106229:	e9 af f3 ff ff       	jmp    801055dd <alltraps>

8010622e <vector198>:
.globl vector198
vector198:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $198
80106230:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106235:	e9 a3 f3 ff ff       	jmp    801055dd <alltraps>

8010623a <vector199>:
.globl vector199
vector199:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $199
8010623c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106241:	e9 97 f3 ff ff       	jmp    801055dd <alltraps>

80106246 <vector200>:
.globl vector200
vector200:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $200
80106248:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010624d:	e9 8b f3 ff ff       	jmp    801055dd <alltraps>

80106252 <vector201>:
.globl vector201
vector201:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $201
80106254:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106259:	e9 7f f3 ff ff       	jmp    801055dd <alltraps>

8010625e <vector202>:
.globl vector202
vector202:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $202
80106260:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106265:	e9 73 f3 ff ff       	jmp    801055dd <alltraps>

8010626a <vector203>:
.globl vector203
vector203:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $203
8010626c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106271:	e9 67 f3 ff ff       	jmp    801055dd <alltraps>

80106276 <vector204>:
.globl vector204
vector204:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $204
80106278:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010627d:	e9 5b f3 ff ff       	jmp    801055dd <alltraps>

80106282 <vector205>:
.globl vector205
vector205:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $205
80106284:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106289:	e9 4f f3 ff ff       	jmp    801055dd <alltraps>

8010628e <vector206>:
.globl vector206
vector206:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $206
80106290:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106295:	e9 43 f3 ff ff       	jmp    801055dd <alltraps>

8010629a <vector207>:
.globl vector207
vector207:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $207
8010629c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801062a1:	e9 37 f3 ff ff       	jmp    801055dd <alltraps>

801062a6 <vector208>:
.globl vector208
vector208:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $208
801062a8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801062ad:	e9 2b f3 ff ff       	jmp    801055dd <alltraps>

801062b2 <vector209>:
.globl vector209
vector209:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $209
801062b4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801062b9:	e9 1f f3 ff ff       	jmp    801055dd <alltraps>

801062be <vector210>:
.globl vector210
vector210:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $210
801062c0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801062c5:	e9 13 f3 ff ff       	jmp    801055dd <alltraps>

801062ca <vector211>:
.globl vector211
vector211:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $211
801062cc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801062d1:	e9 07 f3 ff ff       	jmp    801055dd <alltraps>

801062d6 <vector212>:
.globl vector212
vector212:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $212
801062d8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801062dd:	e9 fb f2 ff ff       	jmp    801055dd <alltraps>

801062e2 <vector213>:
.globl vector213
vector213:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $213
801062e4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801062e9:	e9 ef f2 ff ff       	jmp    801055dd <alltraps>

801062ee <vector214>:
.globl vector214
vector214:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $214
801062f0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801062f5:	e9 e3 f2 ff ff       	jmp    801055dd <alltraps>

801062fa <vector215>:
.globl vector215
vector215:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $215
801062fc:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106301:	e9 d7 f2 ff ff       	jmp    801055dd <alltraps>

80106306 <vector216>:
.globl vector216
vector216:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $216
80106308:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010630d:	e9 cb f2 ff ff       	jmp    801055dd <alltraps>

80106312 <vector217>:
.globl vector217
vector217:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $217
80106314:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106319:	e9 bf f2 ff ff       	jmp    801055dd <alltraps>

8010631e <vector218>:
.globl vector218
vector218:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $218
80106320:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106325:	e9 b3 f2 ff ff       	jmp    801055dd <alltraps>

8010632a <vector219>:
.globl vector219
vector219:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $219
8010632c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106331:	e9 a7 f2 ff ff       	jmp    801055dd <alltraps>

80106336 <vector220>:
.globl vector220
vector220:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $220
80106338:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010633d:	e9 9b f2 ff ff       	jmp    801055dd <alltraps>

80106342 <vector221>:
.globl vector221
vector221:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $221
80106344:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106349:	e9 8f f2 ff ff       	jmp    801055dd <alltraps>

8010634e <vector222>:
.globl vector222
vector222:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $222
80106350:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106355:	e9 83 f2 ff ff       	jmp    801055dd <alltraps>

8010635a <vector223>:
.globl vector223
vector223:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $223
8010635c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106361:	e9 77 f2 ff ff       	jmp    801055dd <alltraps>

80106366 <vector224>:
.globl vector224
vector224:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $224
80106368:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010636d:	e9 6b f2 ff ff       	jmp    801055dd <alltraps>

80106372 <vector225>:
.globl vector225
vector225:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $225
80106374:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106379:	e9 5f f2 ff ff       	jmp    801055dd <alltraps>

8010637e <vector226>:
.globl vector226
vector226:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $226
80106380:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106385:	e9 53 f2 ff ff       	jmp    801055dd <alltraps>

8010638a <vector227>:
.globl vector227
vector227:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $227
8010638c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106391:	e9 47 f2 ff ff       	jmp    801055dd <alltraps>

80106396 <vector228>:
.globl vector228
vector228:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $228
80106398:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010639d:	e9 3b f2 ff ff       	jmp    801055dd <alltraps>

801063a2 <vector229>:
.globl vector229
vector229:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $229
801063a4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801063a9:	e9 2f f2 ff ff       	jmp    801055dd <alltraps>

801063ae <vector230>:
.globl vector230
vector230:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $230
801063b0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801063b5:	e9 23 f2 ff ff       	jmp    801055dd <alltraps>

801063ba <vector231>:
.globl vector231
vector231:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $231
801063bc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801063c1:	e9 17 f2 ff ff       	jmp    801055dd <alltraps>

801063c6 <vector232>:
.globl vector232
vector232:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $232
801063c8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801063cd:	e9 0b f2 ff ff       	jmp    801055dd <alltraps>

801063d2 <vector233>:
.globl vector233
vector233:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $233
801063d4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801063d9:	e9 ff f1 ff ff       	jmp    801055dd <alltraps>

801063de <vector234>:
.globl vector234
vector234:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $234
801063e0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801063e5:	e9 f3 f1 ff ff       	jmp    801055dd <alltraps>

801063ea <vector235>:
.globl vector235
vector235:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $235
801063ec:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801063f1:	e9 e7 f1 ff ff       	jmp    801055dd <alltraps>

801063f6 <vector236>:
.globl vector236
vector236:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $236
801063f8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801063fd:	e9 db f1 ff ff       	jmp    801055dd <alltraps>

80106402 <vector237>:
.globl vector237
vector237:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $237
80106404:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106409:	e9 cf f1 ff ff       	jmp    801055dd <alltraps>

8010640e <vector238>:
.globl vector238
vector238:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $238
80106410:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106415:	e9 c3 f1 ff ff       	jmp    801055dd <alltraps>

8010641a <vector239>:
.globl vector239
vector239:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $239
8010641c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106421:	e9 b7 f1 ff ff       	jmp    801055dd <alltraps>

80106426 <vector240>:
.globl vector240
vector240:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $240
80106428:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010642d:	e9 ab f1 ff ff       	jmp    801055dd <alltraps>

80106432 <vector241>:
.globl vector241
vector241:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $241
80106434:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106439:	e9 9f f1 ff ff       	jmp    801055dd <alltraps>

8010643e <vector242>:
.globl vector242
vector242:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $242
80106440:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106445:	e9 93 f1 ff ff       	jmp    801055dd <alltraps>

8010644a <vector243>:
.globl vector243
vector243:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $243
8010644c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106451:	e9 87 f1 ff ff       	jmp    801055dd <alltraps>

80106456 <vector244>:
.globl vector244
vector244:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $244
80106458:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010645d:	e9 7b f1 ff ff       	jmp    801055dd <alltraps>

80106462 <vector245>:
.globl vector245
vector245:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $245
80106464:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106469:	e9 6f f1 ff ff       	jmp    801055dd <alltraps>

8010646e <vector246>:
.globl vector246
vector246:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $246
80106470:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106475:	e9 63 f1 ff ff       	jmp    801055dd <alltraps>

8010647a <vector247>:
.globl vector247
vector247:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $247
8010647c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106481:	e9 57 f1 ff ff       	jmp    801055dd <alltraps>

80106486 <vector248>:
.globl vector248
vector248:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $248
80106488:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010648d:	e9 4b f1 ff ff       	jmp    801055dd <alltraps>

80106492 <vector249>:
.globl vector249
vector249:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $249
80106494:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106499:	e9 3f f1 ff ff       	jmp    801055dd <alltraps>

8010649e <vector250>:
.globl vector250
vector250:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $250
801064a0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801064a5:	e9 33 f1 ff ff       	jmp    801055dd <alltraps>

801064aa <vector251>:
.globl vector251
vector251:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $251
801064ac:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801064b1:	e9 27 f1 ff ff       	jmp    801055dd <alltraps>

801064b6 <vector252>:
.globl vector252
vector252:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $252
801064b8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801064bd:	e9 1b f1 ff ff       	jmp    801055dd <alltraps>

801064c2 <vector253>:
.globl vector253
vector253:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $253
801064c4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801064c9:	e9 0f f1 ff ff       	jmp    801055dd <alltraps>

801064ce <vector254>:
.globl vector254
vector254:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $254
801064d0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801064d5:	e9 03 f1 ff ff       	jmp    801055dd <alltraps>

801064da <vector255>:
.globl vector255
vector255:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $255
801064dc:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801064e1:	e9 f7 f0 ff ff       	jmp    801055dd <alltraps>
801064e6:	66 90                	xchg   %ax,%ax
801064e8:	66 90                	xchg   %ax,%ax
801064ea:	66 90                	xchg   %ax,%ax
801064ec:	66 90                	xchg   %ax,%ax
801064ee:	66 90                	xchg   %ax,%ax

801064f0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	57                   	push   %edi
801064f4:	56                   	push   %esi
801064f5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801064f7:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801064fa:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801064fb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801064fe:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106501:	8b 1f                	mov    (%edi),%ebx
80106503:	f6 c3 01             	test   $0x1,%bl
80106506:	74 28                	je     80106530 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106508:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010650e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106514:	c1 ee 0a             	shr    $0xa,%esi
}
80106517:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010651a:	89 f2                	mov    %esi,%edx
8010651c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106522:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106525:	5b                   	pop    %ebx
80106526:	5e                   	pop    %esi
80106527:	5f                   	pop    %edi
80106528:	5d                   	pop    %ebp
80106529:	c3                   	ret    
8010652a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106530:	85 c9                	test   %ecx,%ecx
80106532:	74 34                	je     80106568 <walkpgdir+0x78>
80106534:	e8 87 bf ff ff       	call   801024c0 <kalloc>
80106539:	85 c0                	test   %eax,%eax
8010653b:	89 c3                	mov    %eax,%ebx
8010653d:	74 29                	je     80106568 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010653f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106546:	00 
80106547:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010654e:	00 
8010654f:	89 04 24             	mov    %eax,(%esp)
80106552:	e8 49 dd ff ff       	call   801042a0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106557:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010655d:	83 c8 07             	or     $0x7,%eax
80106560:	89 07                	mov    %eax,(%edi)
80106562:	eb b0                	jmp    80106514 <walkpgdir+0x24>
80106564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
80106568:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
8010656b:	31 c0                	xor    %eax,%eax
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
8010656d:	5b                   	pop    %ebx
8010656e:	5e                   	pop    %esi
8010656f:	5f                   	pop    %edi
80106570:	5d                   	pop    %ebp
80106571:	c3                   	ret    
80106572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106580 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	57                   	push   %edi
80106584:	56                   	push   %esi
80106585:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106586:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106588:	83 ec 1c             	sub    $0x1c,%esp
8010658b:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010658e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106594:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106597:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010659b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010659e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801065a2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801065a9:	29 df                	sub    %ebx,%edi
801065ab:	eb 18                	jmp    801065c5 <mappages+0x45>
801065ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801065b0:	f6 00 01             	testb  $0x1,(%eax)
801065b3:	75 3d                	jne    801065f2 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
801065b5:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
801065b8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801065bb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801065bd:	74 29                	je     801065e8 <mappages+0x68>
      break;
    a += PGSIZE;
801065bf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801065c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801065c8:	b9 01 00 00 00       	mov    $0x1,%ecx
801065cd:	89 da                	mov    %ebx,%edx
801065cf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801065d2:	e8 19 ff ff ff       	call   801064f0 <walkpgdir>
801065d7:	85 c0                	test   %eax,%eax
801065d9:	75 d5                	jne    801065b0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801065db:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801065de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801065e3:	5b                   	pop    %ebx
801065e4:	5e                   	pop    %esi
801065e5:	5f                   	pop    %edi
801065e6:	5d                   	pop    %ebp
801065e7:	c3                   	ret    
801065e8:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801065eb:	31 c0                	xor    %eax,%eax
}
801065ed:	5b                   	pop    %ebx
801065ee:	5e                   	pop    %esi
801065ef:	5f                   	pop    %edi
801065f0:	5d                   	pop    %ebp
801065f1:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801065f2:	c7 04 24 34 77 10 80 	movl   $0x80107734,(%esp)
801065f9:	e8 62 9d ff ff       	call   80100360 <panic>
801065fe:	66 90                	xchg   %ax,%ax

80106600 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	57                   	push   %edi
80106604:	89 c7                	mov    %eax,%edi
80106606:	56                   	push   %esi
80106607:	89 d6                	mov    %edx,%esi
80106609:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010660a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106610:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106613:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106619:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010661b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010661e:	72 3b                	jb     8010665b <deallocuvm.part.0+0x5b>
80106620:	eb 5e                	jmp    80106680 <deallocuvm.part.0+0x80>
80106622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106628:	8b 10                	mov    (%eax),%edx
8010662a:	f6 c2 01             	test   $0x1,%dl
8010662d:	74 22                	je     80106651 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010662f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106635:	74 54                	je     8010668b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106637:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010663d:	89 14 24             	mov    %edx,(%esp)
80106640:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106643:	e8 c8 bc ff ff       	call   80102310 <kfree>
      *pte = 0;
80106648:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010664b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106651:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106657:	39 f3                	cmp    %esi,%ebx
80106659:	73 25                	jae    80106680 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010665b:	31 c9                	xor    %ecx,%ecx
8010665d:	89 da                	mov    %ebx,%edx
8010665f:	89 f8                	mov    %edi,%eax
80106661:	e8 8a fe ff ff       	call   801064f0 <walkpgdir>
    if(!pte)
80106666:	85 c0                	test   %eax,%eax
80106668:	75 be                	jne    80106628 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010666a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106670:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106676:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010667c:	39 f3                	cmp    %esi,%ebx
8010667e:	72 db                	jb     8010665b <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106680:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106683:	83 c4 1c             	add    $0x1c,%esp
80106686:	5b                   	pop    %ebx
80106687:	5e                   	pop    %esi
80106688:	5f                   	pop    %edi
80106689:	5d                   	pop    %ebp
8010668a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010668b:	c7 04 24 66 70 10 80 	movl   $0x80107066,(%esp)
80106692:	e8 c9 9c ff ff       	call   80100360 <panic>
80106697:	89 f6                	mov    %esi,%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066a0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801066a6:	e8 f5 cf ff ff       	call   801036a0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801066ab:	31 c9                	xor    %ecx,%ecx
801066ad:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801066b2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801066b8:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801066bd:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066c1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
801066c6:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801066c9:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066cd:	31 c9                	xor    %ecx,%ecx
801066cf:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066d3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066d8:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066dc:	31 c9                	xor    %ecx,%ecx
801066de:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066e2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066e7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066eb:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801066ed:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
801066f1:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066f5:	c6 40 15 92          	movb   $0x92,0x15(%eax)
801066f9:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066fd:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106701:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106705:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106709:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010670d:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106711:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106716:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010671a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010671e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106722:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106726:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010672a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010672e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106732:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106736:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010673a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010673e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106742:	c1 e8 10             	shr    $0x10,%eax
80106745:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106749:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010674c:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
8010674f:	c9                   	leave  
80106750:	c3                   	ret    
80106751:	eb 0d                	jmp    80106760 <switchkvm>
80106753:	90                   	nop
80106754:	90                   	nop
80106755:	90                   	nop
80106756:	90                   	nop
80106757:	90                   	nop
80106758:	90                   	nop
80106759:	90                   	nop
8010675a:	90                   	nop
8010675b:	90                   	nop
8010675c:	90                   	nop
8010675d:	90                   	nop
8010675e:	90                   	nop
8010675f:	90                   	nop

80106760 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106760:	a1 a4 54 11 80       	mov    0x801154a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106765:	55                   	push   %ebp
80106766:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106768:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010676d:	0f 22 d8             	mov    %eax,%cr3
}
80106770:	5d                   	pop    %ebp
80106771:	c3                   	ret    
80106772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106780 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	57                   	push   %edi
80106784:	56                   	push   %esi
80106785:	53                   	push   %ebx
80106786:	83 ec 1c             	sub    $0x1c,%esp
80106789:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010678c:	85 f6                	test   %esi,%esi
8010678e:	0f 84 cd 00 00 00    	je     80106861 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106794:	8b 46 08             	mov    0x8(%esi),%eax
80106797:	85 c0                	test   %eax,%eax
80106799:	0f 84 da 00 00 00    	je     80106879 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010679f:	8b 7e 04             	mov    0x4(%esi),%edi
801067a2:	85 ff                	test   %edi,%edi
801067a4:	0f 84 c3 00 00 00    	je     8010686d <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
801067aa:	e8 71 d9 ff ff       	call   80104120 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801067af:	e8 6c ce ff ff       	call   80103620 <mycpu>
801067b4:	89 c3                	mov    %eax,%ebx
801067b6:	e8 65 ce ff ff       	call   80103620 <mycpu>
801067bb:	89 c7                	mov    %eax,%edi
801067bd:	e8 5e ce ff ff       	call   80103620 <mycpu>
801067c2:	83 c7 08             	add    $0x8,%edi
801067c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067c8:	e8 53 ce ff ff       	call   80103620 <mycpu>
801067cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801067d0:	ba 67 00 00 00       	mov    $0x67,%edx
801067d5:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801067dc:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801067e3:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801067ea:	83 c1 08             	add    $0x8,%ecx
801067ed:	c1 e9 10             	shr    $0x10,%ecx
801067f0:	83 c0 08             	add    $0x8,%eax
801067f3:	c1 e8 18             	shr    $0x18,%eax
801067f6:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801067fc:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106803:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106809:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010680e:	e8 0d ce ff ff       	call   80103620 <mycpu>
80106813:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010681a:	e8 01 ce ff ff       	call   80103620 <mycpu>
8010681f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106824:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106828:	e8 f3 cd ff ff       	call   80103620 <mycpu>
8010682d:	8b 56 08             	mov    0x8(%esi),%edx
80106830:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106836:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106839:	e8 e2 cd ff ff       	call   80103620 <mycpu>
8010683e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106842:	b8 28 00 00 00       	mov    $0x28,%eax
80106847:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010684a:	8b 46 04             	mov    0x4(%esi),%eax
8010684d:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106852:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106855:	83 c4 1c             	add    $0x1c,%esp
80106858:	5b                   	pop    %ebx
80106859:	5e                   	pop    %esi
8010685a:	5f                   	pop    %edi
8010685b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010685c:	e9 7f d9 ff ff       	jmp    801041e0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106861:	c7 04 24 3a 77 10 80 	movl   $0x8010773a,(%esp)
80106868:	e8 f3 9a ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010686d:	c7 04 24 65 77 10 80 	movl   $0x80107765,(%esp)
80106874:	e8 e7 9a ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106879:	c7 04 24 50 77 10 80 	movl   $0x80107750,(%esp)
80106880:	e8 db 9a ff ff       	call   80100360 <panic>
80106885:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106890 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	53                   	push   %ebx
80106896:	83 ec 1c             	sub    $0x1c,%esp
80106899:	8b 75 10             	mov    0x10(%ebp),%esi
8010689c:	8b 45 08             	mov    0x8(%ebp),%eax
8010689f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801068a2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801068a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801068ab:	77 54                	ja     80106901 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
801068ad:	e8 0e bc ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
801068b2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068b9:	00 
801068ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068c1:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801068c2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801068c4:	89 04 24             	mov    %eax,(%esp)
801068c7:	e8 d4 d9 ff ff       	call   801042a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801068cc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068d2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801068d7:	89 04 24             	mov    %eax,(%esp)
801068da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068dd:	31 d2                	xor    %edx,%edx
801068df:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801068e6:	00 
801068e7:	e8 94 fc ff ff       	call   80106580 <mappages>
  memmove(mem, init, sz);
801068ec:	89 75 10             	mov    %esi,0x10(%ebp)
801068ef:	89 7d 0c             	mov    %edi,0xc(%ebp)
801068f2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801068f5:	83 c4 1c             	add    $0x1c,%esp
801068f8:	5b                   	pop    %ebx
801068f9:	5e                   	pop    %esi
801068fa:	5f                   	pop    %edi
801068fb:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801068fc:	e9 3f da ff ff       	jmp    80104340 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106901:	c7 04 24 79 77 10 80 	movl   $0x80107779,(%esp)
80106908:	e8 53 9a ff ff       	call   80100360 <panic>
8010690d:	8d 76 00             	lea    0x0(%esi),%esi

80106910 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106919:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106920:	0f 85 98 00 00 00    	jne    801069be <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106926:	8b 75 18             	mov    0x18(%ebp),%esi
80106929:	31 db                	xor    %ebx,%ebx
8010692b:	85 f6                	test   %esi,%esi
8010692d:	75 1a                	jne    80106949 <loaduvm+0x39>
8010692f:	eb 77                	jmp    801069a8 <loaduvm+0x98>
80106931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106938:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010693e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106944:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106947:	76 5f                	jbe    801069a8 <loaduvm+0x98>
80106949:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010694c:	31 c9                	xor    %ecx,%ecx
8010694e:	8b 45 08             	mov    0x8(%ebp),%eax
80106951:	01 da                	add    %ebx,%edx
80106953:	e8 98 fb ff ff       	call   801064f0 <walkpgdir>
80106958:	85 c0                	test   %eax,%eax
8010695a:	74 56                	je     801069b2 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010695c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010695e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106963:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106966:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010696b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106971:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106974:	05 00 00 00 80       	add    $0x80000000,%eax
80106979:	89 44 24 04          	mov    %eax,0x4(%esp)
8010697d:	8b 45 10             	mov    0x10(%ebp),%eax
80106980:	01 d9                	add    %ebx,%ecx
80106982:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106986:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010698a:	89 04 24             	mov    %eax,(%esp)
8010698d:	e8 ee af ff ff       	call   80101980 <readi>
80106992:	39 f8                	cmp    %edi,%eax
80106994:	74 a2                	je     80106938 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106996:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010699e:	5b                   	pop    %ebx
8010699f:	5e                   	pop    %esi
801069a0:	5f                   	pop    %edi
801069a1:	5d                   	pop    %ebp
801069a2:	c3                   	ret    
801069a3:	90                   	nop
801069a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069a8:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801069ab:	31 c0                	xor    %eax,%eax
}
801069ad:	5b                   	pop    %ebx
801069ae:	5e                   	pop    %esi
801069af:	5f                   	pop    %edi
801069b0:	5d                   	pop    %ebp
801069b1:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801069b2:	c7 04 24 93 77 10 80 	movl   $0x80107793,(%esp)
801069b9:	e8 a2 99 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801069be:	c7 04 24 34 78 10 80 	movl   $0x80107834,(%esp)
801069c5:	e8 96 99 ff ff       	call   80100360 <panic>
801069ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069d0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
801069d6:	83 ec 1c             	sub    $0x1c,%esp
801069d9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801069dc:	85 ff                	test   %edi,%edi
801069de:	0f 88 7e 00 00 00    	js     80106a62 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
801069e4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801069e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
801069ea:	72 78                	jb     80106a64 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
801069ec:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801069f2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801069f8:	39 df                	cmp    %ebx,%edi
801069fa:	77 4a                	ja     80106a46 <allocuvm+0x76>
801069fc:	eb 72                	jmp    80106a70 <allocuvm+0xa0>
801069fe:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106a00:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a07:	00 
80106a08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a0f:	00 
80106a10:	89 04 24             	mov    %eax,(%esp)
80106a13:	e8 88 d8 ff ff       	call   801042a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106a18:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106a1e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a23:	89 04 24             	mov    %eax,(%esp)
80106a26:	8b 45 08             	mov    0x8(%ebp),%eax
80106a29:	89 da                	mov    %ebx,%edx
80106a2b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106a32:	00 
80106a33:	e8 48 fb ff ff       	call   80106580 <mappages>
80106a38:	85 c0                	test   %eax,%eax
80106a3a:	78 44                	js     80106a80 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106a3c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a42:	39 df                	cmp    %ebx,%edi
80106a44:	76 2a                	jbe    80106a70 <allocuvm+0xa0>
    mem = kalloc();
80106a46:	e8 75 ba ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80106a4b:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106a4d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106a4f:	75 af                	jne    80106a00 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106a51:	c7 04 24 b1 77 10 80 	movl   $0x801077b1,(%esp)
80106a58:	e8 f3 9b ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106a5d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a60:	77 48                	ja     80106aaa <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106a62:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106a64:	83 c4 1c             	add    $0x1c,%esp
80106a67:	5b                   	pop    %ebx
80106a68:	5e                   	pop    %esi
80106a69:	5f                   	pop    %edi
80106a6a:	5d                   	pop    %ebp
80106a6b:	c3                   	ret    
80106a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a70:	83 c4 1c             	add    $0x1c,%esp
80106a73:	89 f8                	mov    %edi,%eax
80106a75:	5b                   	pop    %ebx
80106a76:	5e                   	pop    %esi
80106a77:	5f                   	pop    %edi
80106a78:	5d                   	pop    %ebp
80106a79:	c3                   	ret    
80106a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106a80:	c7 04 24 c9 77 10 80 	movl   $0x801077c9,(%esp)
80106a87:	e8 c4 9b ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106a8c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a8f:	76 0d                	jbe    80106a9e <allocuvm+0xce>
80106a91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a94:	89 fa                	mov    %edi,%edx
80106a96:	8b 45 08             	mov    0x8(%ebp),%eax
80106a99:	e8 62 fb ff ff       	call   80106600 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106a9e:	89 34 24             	mov    %esi,(%esp)
80106aa1:	e8 6a b8 ff ff       	call   80102310 <kfree>
      return 0;
80106aa6:	31 c0                	xor    %eax,%eax
80106aa8:	eb ba                	jmp    80106a64 <allocuvm+0x94>
80106aaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106aad:	89 fa                	mov    %edi,%edx
80106aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab2:	e8 49 fb ff ff       	call   80106600 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106ab7:	31 c0                	xor    %eax,%eax
80106ab9:	eb a9                	jmp    80106a64 <allocuvm+0x94>
80106abb:	90                   	nop
80106abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ac0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ac6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106acc:	39 d1                	cmp    %edx,%ecx
80106ace:	73 08                	jae    80106ad8 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ad0:	5d                   	pop    %ebp
80106ad1:	e9 2a fb ff ff       	jmp    80106600 <deallocuvm.part.0>
80106ad6:	66 90                	xchg   %ax,%ax
80106ad8:	89 d0                	mov    %edx,%eax
80106ada:	5d                   	pop    %ebp
80106adb:	c3                   	ret    
80106adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ae0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	56                   	push   %esi
80106ae4:	53                   	push   %ebx
80106ae5:	83 ec 10             	sub    $0x10,%esp
80106ae8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106aeb:	85 f6                	test   %esi,%esi
80106aed:	74 59                	je     80106b48 <freevm+0x68>
80106aef:	31 c9                	xor    %ecx,%ecx
80106af1:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106af6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106af8:	31 db                	xor    %ebx,%ebx
80106afa:	e8 01 fb ff ff       	call   80106600 <deallocuvm.part.0>
80106aff:	eb 12                	jmp    80106b13 <freevm+0x33>
80106b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b08:	83 c3 01             	add    $0x1,%ebx
80106b0b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b11:	74 27                	je     80106b3a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106b13:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106b16:	f6 c2 01             	test   $0x1,%dl
80106b19:	74 ed                	je     80106b08 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b1b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b21:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b24:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106b2a:	89 14 24             	mov    %edx,(%esp)
80106b2d:	e8 de b7 ff ff       	call   80102310 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b32:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b38:	75 d9                	jne    80106b13 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106b3a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106b3d:	83 c4 10             	add    $0x10,%esp
80106b40:	5b                   	pop    %ebx
80106b41:	5e                   	pop    %esi
80106b42:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106b43:	e9 c8 b7 ff ff       	jmp    80102310 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106b48:	c7 04 24 e5 77 10 80 	movl   $0x801077e5,(%esp)
80106b4f:	e8 0c 98 ff ff       	call   80100360 <panic>
80106b54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b60 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	56                   	push   %esi
80106b64:	53                   	push   %ebx
80106b65:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106b68:	e8 53 b9 ff ff       	call   801024c0 <kalloc>
80106b6d:	85 c0                	test   %eax,%eax
80106b6f:	89 c6                	mov    %eax,%esi
80106b71:	74 6d                	je     80106be0 <setupkvm+0x80>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106b73:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b7a:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b7b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106b80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b87:	00 
80106b88:	89 04 24             	mov    %eax,(%esp)
80106b8b:	e8 10 d7 ff ff       	call   801042a0 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106b90:	8b 53 0c             	mov    0xc(%ebx),%edx
80106b93:	8b 43 04             	mov    0x4(%ebx),%eax
80106b96:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106b99:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b9d:	8b 13                	mov    (%ebx),%edx
80106b9f:	89 04 24             	mov    %eax,(%esp)
80106ba2:	29 c1                	sub    %eax,%ecx
80106ba4:	89 f0                	mov    %esi,%eax
80106ba6:	e8 d5 f9 ff ff       	call   80106580 <mappages>
80106bab:	85 c0                	test   %eax,%eax
80106bad:	78 19                	js     80106bc8 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106baf:	83 c3 10             	add    $0x10,%ebx
80106bb2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106bb8:	72 d6                	jb     80106b90 <setupkvm+0x30>
80106bba:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106bbc:	83 c4 10             	add    $0x10,%esp
80106bbf:	5b                   	pop    %ebx
80106bc0:	5e                   	pop    %esi
80106bc1:	5d                   	pop    %ebp
80106bc2:	c3                   	ret    
80106bc3:	90                   	nop
80106bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106bc8:	89 34 24             	mov    %esi,(%esp)
80106bcb:	e8 10 ff ff ff       	call   80106ae0 <freevm>
      return 0;
    }
  return pgdir;
}
80106bd0:	83 c4 10             	add    $0x10,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106bd3:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106bd5:	5b                   	pop    %ebx
80106bd6:	5e                   	pop    %esi
80106bd7:	5d                   	pop    %ebp
80106bd8:	c3                   	ret    
80106bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106be0:	31 c0                	xor    %eax,%eax
80106be2:	eb d8                	jmp    80106bbc <setupkvm+0x5c>
80106be4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106bf0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106bf6:	e8 65 ff ff ff       	call   80106b60 <setupkvm>
80106bfb:	a3 a4 54 11 80       	mov    %eax,0x801154a4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c00:	05 00 00 00 80       	add    $0x80000000,%eax
80106c05:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106c08:	c9                   	leave  
80106c09:	c3                   	ret    
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c10 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c10:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c11:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c13:	89 e5                	mov    %esp,%ebp
80106c15:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c18:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c1b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c1e:	e8 cd f8 ff ff       	call   801064f0 <walkpgdir>
  if(pte == 0)
80106c23:	85 c0                	test   %eax,%eax
80106c25:	74 05                	je     80106c2c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106c27:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106c2a:	c9                   	leave  
80106c2b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106c2c:	c7 04 24 f6 77 10 80 	movl   $0x801077f6,(%esp)
80106c33:	e8 28 97 ff ff       	call   80100360 <panic>
80106c38:	90                   	nop
80106c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c40 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
80106c46:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106c49:	e8 12 ff ff ff       	call   80106b60 <setupkvm>
80106c4e:	85 c0                	test   %eax,%eax
80106c50:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c53:	0f 84 b2 00 00 00    	je     80106d0b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106c59:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c5c:	85 c0                	test   %eax,%eax
80106c5e:	0f 84 9c 00 00 00    	je     80106d00 <copyuvm+0xc0>
80106c64:	31 db                	xor    %ebx,%ebx
80106c66:	eb 48                	jmp    80106cb0 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106c68:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106c6e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c75:	00 
80106c76:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106c7a:	89 04 24             	mov    %eax,(%esp)
80106c7d:	e8 be d6 ff ff       	call   80104340 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c85:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106c8b:	89 14 24             	mov    %edx,(%esp)
80106c8e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c93:	89 da                	mov    %ebx,%edx
80106c95:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c99:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c9c:	e8 df f8 ff ff       	call   80106580 <mappages>
80106ca1:	85 c0                	test   %eax,%eax
80106ca3:	78 41                	js     80106ce6 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ca5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cab:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106cae:	76 50                	jbe    80106d00 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106cb0:	8b 45 08             	mov    0x8(%ebp),%eax
80106cb3:	31 c9                	xor    %ecx,%ecx
80106cb5:	89 da                	mov    %ebx,%edx
80106cb7:	e8 34 f8 ff ff       	call   801064f0 <walkpgdir>
80106cbc:	85 c0                	test   %eax,%eax
80106cbe:	74 5b                	je     80106d1b <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106cc0:	8b 30                	mov    (%eax),%esi
80106cc2:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106cc8:	74 45                	je     80106d0f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106cca:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106ccc:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106cd2:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106cd5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106cdb:	e8 e0 b7 ff ff       	call   801024c0 <kalloc>
80106ce0:	85 c0                	test   %eax,%eax
80106ce2:	89 c6                	mov    %eax,%esi
80106ce4:	75 82                	jne    80106c68 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ce9:	89 04 24             	mov    %eax,(%esp)
80106cec:	e8 ef fd ff ff       	call   80106ae0 <freevm>
  return 0;
80106cf1:	31 c0                	xor    %eax,%eax
}
80106cf3:	83 c4 2c             	add    $0x2c,%esp
80106cf6:	5b                   	pop    %ebx
80106cf7:	5e                   	pop    %esi
80106cf8:	5f                   	pop    %edi
80106cf9:	5d                   	pop    %ebp
80106cfa:	c3                   	ret    
80106cfb:	90                   	nop
80106cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d03:	83 c4 2c             	add    $0x2c,%esp
80106d06:	5b                   	pop    %ebx
80106d07:	5e                   	pop    %esi
80106d08:	5f                   	pop    %edi
80106d09:	5d                   	pop    %ebp
80106d0a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106d0b:	31 c0                	xor    %eax,%eax
80106d0d:	eb e4                	jmp    80106cf3 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106d0f:	c7 04 24 1a 78 10 80 	movl   $0x8010781a,(%esp)
80106d16:	e8 45 96 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106d1b:	c7 04 24 00 78 10 80 	movl   $0x80107800,(%esp)
80106d22:	e8 39 96 ff ff       	call   80100360 <panic>
80106d27:	89 f6                	mov    %esi,%esi
80106d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d30 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d30:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d31:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d33:	89 e5                	mov    %esp,%ebp
80106d35:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d38:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d3e:	e8 ad f7 ff ff       	call   801064f0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106d43:	8b 00                	mov    (%eax),%eax
80106d45:	89 c2                	mov    %eax,%edx
80106d47:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106d4a:	83 fa 05             	cmp    $0x5,%edx
80106d4d:	75 11                	jne    80106d60 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106d4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d54:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106d59:	c9                   	leave  
80106d5a:	c3                   	ret    
80106d5b:	90                   	nop
80106d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106d60:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106d62:	c9                   	leave  
80106d63:	c3                   	ret    
80106d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d70 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 1c             	sub    $0x1c,%esp
80106d79:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106d7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d7f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106d82:	85 db                	test   %ebx,%ebx
80106d84:	75 3a                	jne    80106dc0 <copyout+0x50>
80106d86:	eb 68                	jmp    80106df0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d88:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d8b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d8d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d91:	29 ca                	sub    %ecx,%edx
80106d93:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106d99:	39 da                	cmp    %ebx,%edx
80106d9b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d9e:	29 f1                	sub    %esi,%ecx
80106da0:	01 c8                	add    %ecx,%eax
80106da2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106da6:	89 04 24             	mov    %eax,(%esp)
80106da9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106dac:	e8 8f d5 ff ff       	call   80104340 <memmove>
    len -= n;
    buf += n;
80106db1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106db4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106dba:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106dbc:	29 d3                	sub    %edx,%ebx
80106dbe:	74 30                	je     80106df0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106dc3:	89 ce                	mov    %ecx,%esi
80106dc5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106dcb:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106dcf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106dd2:	89 04 24             	mov    %eax,(%esp)
80106dd5:	e8 56 ff ff ff       	call   80106d30 <uva2ka>
    if(pa0 == 0)
80106dda:	85 c0                	test   %eax,%eax
80106ddc:	75 aa                	jne    80106d88 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106dde:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106de6:	5b                   	pop    %ebx
80106de7:	5e                   	pop    %esi
80106de8:	5f                   	pop    %edi
80106de9:	5d                   	pop    %ebp
80106dea:	c3                   	ret    
80106deb:	90                   	nop
80106dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106df0:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106df3:	31 c0                	xor    %eax,%eax
}
80106df5:	5b                   	pop    %ebx
80106df6:	5e                   	pop    %esi
80106df7:	5f                   	pop    %edi
80106df8:	5d                   	pop    %ebp
80106df9:	c3                   	ret    
