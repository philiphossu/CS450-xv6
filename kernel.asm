
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
8010002d:	b8 50 2e 10 80       	mov    $0x80102e50,%eax
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
8010004c:	c7 44 24 04 40 71 10 	movl   $0x80107140,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 50 40 00 00       	call   801040b0 <initlock>

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
80100094:	c7 44 24 04 47 71 10 	movl   $0x80107147,0x4(%esp)
8010009b:	80 
8010009c:	e8 ff 3e 00 00       	call   80103fa0 <initsleeplock>
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
801000e6:	e8 b5 40 00 00       	call   801041a0 <acquire>

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
80100161:	e8 2a 41 00 00       	call   80104290 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 6f 3e 00 00       	call   80103fe0 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 02 20 00 00       	call   80102180 <iderw>
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
80100188:	c7 04 24 4e 71 10 80 	movl   $0x8010714e,(%esp)
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
801001b0:	e8 cb 3e 00 00       	call   80104080 <holdingsleep>
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
801001c4:	e9 b7 1f 00 00       	jmp    80102180 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 5f 71 10 80 	movl   $0x8010715f,(%esp)
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
801001f1:	e8 8a 3e 00 00       	call   80104080 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 3e 3e 00 00       	call   80104040 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 92 3f 00 00       	call   801041a0 <acquire>
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
80100250:	e9 3b 40 00 00       	jmp    80104290 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 66 71 10 80 	movl   $0x80107166,(%esp)
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
80100282:	e8 19 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 0d 3f 00 00       	call   801041a0 <acquire>
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
801002a8:	e8 53 34 00 00       	call   80103700 <myproc>
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
801002c3:	e8 98 39 00 00       	call   80103c60 <sleep>

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
80100311:	e8 7a 3f 00 00       	call   80104290 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 a2 13 00 00       	call   801016c0 <ilock>
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
8010032f:	e8 5c 3f 00 00       	call   80104290 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 84 13 00 00       	call   801016c0 <ilock>
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
80100376:	e8 45 24 00 00       	call   801027c0 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 6d 71 10 80 	movl   $0x8010716d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 4f 7b 10 80 	movl   $0x80107b4f,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 1c 3d 00 00       	call   801040d0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 81 71 10 80 	movl   $0x80107181,(%esp)
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
80100409:	e8 92 58 00 00       	call   80105ca0 <uartputc>
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
801004b9:	e8 e2 57 00 00       	call   80105ca0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 d6 57 00 00       	call   80105ca0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 ca 57 00 00       	call   80105ca0 <uartputc>
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
801004fc:	e8 7f 3e 00 00       	call   80104380 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 c2 3d 00 00       	call   801042e0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 85 71 10 80 	movl   $0x80107185,(%esp)
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
80100599:	0f b6 92 b0 71 10 80 	movzbl -0x7fef8e50(%edx),%edx
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
80100602:	e8 99 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 8d 3b 00 00       	call   801041a0 <acquire>
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
80100636:	e8 55 3c 00 00       	call   80104290 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 7a 10 00 00       	call   801016c0 <ilock>

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
801006f3:	e8 98 3b 00 00       	call   80104290 <release>
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
80100760:	b8 98 71 10 80       	mov    $0x80107198,%eax
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
80100797:	e8 04 3a 00 00       	call   801041a0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 9f 71 10 80 	movl   $0x8010719f,(%esp)
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
801007c5:	e8 d6 39 00 00       	call   801041a0 <acquire>
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
80100827:	e8 64 3a 00 00       	call   80104290 <release>
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
801008b2:	e8 39 35 00 00       	call   80103df0 <wakeup>
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
80100927:	e9 a4 35 00 00       	jmp    80103ed0 <procdump>
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
80100956:	c7 44 24 04 a8 71 10 	movl   $0x801071a8,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 46 37 00 00       	call   801040b0 <initlock>

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
80100997:	e8 74 19 00 00       	call   80102310 <ioapicenable>
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
801009ac:	e8 4f 2d 00 00       	call   80103700 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 b4 21 00 00       	call   80102b70 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 99 15 00 00       	call   80101f60 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 e7 0c 00 00       	call   801016c0 <ilock>
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
801009f6:	e8 c5 0f 00 00       	call   801019c0 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 68 0f 00 00       	call   80101970 <iunlockput>
    end_op();
80100a08:	e8 d3 21 00 00       	call   80102be0 <end_op>
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
80100a2c:	e8 5f 64 00 00       	call   80106e90 <setupkvm>
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
80100a8e:	e8 2d 0f 00 00       	call   801019c0 <readi>
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
80100ad2:	e8 29 62 00 00       	call   80106d00 <allocuvm>
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
80100b13:	e8 28 61 00 00       	call   80106c40 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 e2 62 00 00       	call   80106e10 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 35 0e 00 00       	call   80101970 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 9b 20 00 00       	call   80102be0 <end_op>
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
80100b6c:	e8 8f 61 00 00       	call   80106d00 <allocuvm>
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
80100b84:	e8 87 62 00 00       	call   80106e10 <freevm>
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
80100b93:	e8 48 20 00 00       	call   80102be0 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 c1 71 10 80 	movl   $0x801071c1,(%esp)
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
80100bc8:	e8 73 63 00 00       	call   80106f40 <clearpteu>
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
80100c01:	e8 fa 38 00 00       	call   80104500 <strlen>
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
80100c12:	e8 e9 38 00 00       	call   80104500 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 6a 64 00 00       	call   801070a0 <copyout>
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
80100ca4:	e8 f7 63 00 00       	call   801070a0 <copyout>
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
80100cf1:	e8 ca 37 00 00       	call   801044c0 <safestrcpy>

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
80100d1f:	e8 8c 5d 00 00       	call   80106ab0 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 e4 60 00 00       	call   80106e10 <freevm>
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
80100d56:	c7 44 24 04 cd 71 10 	movl   $0x801071cd,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 46 33 00 00       	call   801040b0 <initlock>
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
80100d83:	e8 18 34 00 00       	call   801041a0 <acquire>
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
80100db0:	e8 db 34 00 00       	call   80104290 <release>
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
80100dc7:	e8 c4 34 00 00       	call   80104290 <release>
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
80100df1:	e8 aa 33 00 00       	call   801041a0 <acquire>
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
80100e0a:	e8 81 34 00 00       	call   80104290 <release>
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
80100e17:	c7 04 24 d4 71 10 80 	movl   $0x801071d4,(%esp)
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
80100e43:	e8 58 33 00 00       	call   801041a0 <acquire>
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
80100e6b:	e9 20 34 00 00       	jmp    80104290 <release>
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
80100e8f:	e8 fc 33 00 00       	call   80104290 <release>

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
80100eb3:	e8 08 24 00 00       	call   801032c0 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ec0:	e8 ab 1c 00 00       	call   80102b70 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 60 09 00 00       	call   80101830 <iput>
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
80100ed7:	e9 04 1d 00 00       	jmp    80102be0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100edc:	c7 04 24 dc 71 10 80 	movl   $0x801071dc,(%esp)
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
80100f05:	e8 b6 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 74 0a 00 00       	call   80101990 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 79 08 00 00       	call   801017a0 <iunlock>
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
80100f6a:	e8 51 07 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 37 0a 00 00       	call   801019c0 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 03 08 00 00       	call   801017a0 <iunlock>
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
80100fb5:	e9 86 24 00 00       	jmp    80103440 <piperead>
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
80100fc7:	c7 04 24 e6 71 10 80 	movl   $0x801071e6,(%esp)
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
80101034:	e8 67 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101039:	e8 a2 1b 00 00       	call   80102be0 <end_op>
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
80101063:	e8 08 1b 00 00       	call   80102b70 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 4d 06 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 2e 0a 00 00       	call   80101ac0 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 fc 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010a4:	e8 37 1b 00 00       	call   80102be0 <end_op>

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
801010dc:	e9 6f 22 00 00       	jmp    80103350 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	c7 04 24 ef 71 10 80 	movl   $0x801071ef,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ed:	c7 04 24 f5 71 10 80 	movl   $0x801071f5,(%esp)
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
801011a5:	c7 04 24 ff 71 10 80 	movl   $0x801071ff,(%esp)
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
801011c4:	e8 47 1b 00 00       	call   80102d10 <log_write>
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
801011f8:	e8 e3 30 00 00       	call   801042e0 <memset>
  log_write(bp);
801011fd:	89 1c 24             	mov    %ebx,(%esp)
80101200:	e8 0b 1b 00 00       	call   80102d10 <log_write>
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
8010123c:	e8 5f 2f 00 00       	call   801041a0 <acquire>

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
80101279:	e8 12 30 00 00       	call   80104290 <release>
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
801012be:	e8 cd 2f 00 00       	call   80104290 <release>

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
801012cd:	c7 04 24 15 72 10 80 	movl   $0x80107215,(%esp)
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
80101348:	e8 c3 19 00 00       	call   80102d10 <log_write>
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
80101387:	c7 04 24 25 72 10 80 	movl   $0x80107225,(%esp)
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
801013d2:	e8 a9 2f 00 00       	call   80104380 <memmove>
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
80101454:	e8 b7 18 00 00       	call   80102d10 <log_write>
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
80101469:	c7 04 24 38 72 10 80 	movl   $0x80107238,(%esp)
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
8010148c:	c7 44 24 04 4b 72 10 	movl   $0x8010724b,0x4(%esp)
80101493:	80 
80101494:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010149b:	e8 10 2c 00 00       	call   801040b0 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	89 1c 24             	mov    %ebx,(%esp)
801014a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a9:	c7 44 24 04 52 72 10 	movl   $0x80107252,0x4(%esp)
801014b0:	80 
801014b1:	e8 ea 2a 00 00       	call   80103fa0 <initsleeplock>
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
801014d6:	c7 04 24 b8 72 10 80 	movl   $0x801072b8,(%esp)
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
801015b9:	e8 22 2d 00 00       	call   801042e0 <memset>
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
801015d1:	e8 3a 17 00 00       	call   80102d10 <log_write>
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
801015f1:	c7 04 24 58 72 10 80 	movl   $0x80107258,(%esp)
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
80101670:	e8 0b 2d 00 00       	call   80104380 <memmove>
  log_write(bp);
80101675:	89 34 24             	mov    %esi,(%esp)
80101678:	e8 93 16 00 00       	call   80102d10 <log_write>
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

80101690 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 14             	sub    $0x14,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 fa 2a 00 00       	call   801041a0 <acquire>
  ip->ref++;
801016a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 da 2b 00 00       	call   80104290 <release>
  return ip;
}
801016b6:	83 c4 14             	add    $0x14,%esp
801016b9:	89 d8                	mov    %ebx,%eax
801016bb:	5b                   	pop    %ebx
801016bc:	5d                   	pop    %ebp
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax

801016c0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 10             	sub    $0x10,%esp
801016c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016cb:	85 db                	test   %ebx,%ebx
801016cd:	0f 84 b3 00 00 00    	je     80101786 <ilock+0xc6>
801016d3:	8b 53 08             	mov    0x8(%ebx),%edx
801016d6:	85 d2                	test   %edx,%edx
801016d8:	0f 8e a8 00 00 00    	jle    80101786 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016de:	8d 43 0c             	lea    0xc(%ebx),%eax
801016e1:	89 04 24             	mov    %eax,(%esp)
801016e4:	e8 f7 28 00 00       	call   80103fe0 <acquiresleep>

  if(ip->valid == 0){
801016e9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ec:	85 c0                	test   %eax,%eax
801016ee:	74 08                	je     801016f8 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016f0:	83 c4 10             	add    $0x10,%esp
801016f3:	5b                   	pop    %ebx
801016f4:	5e                   	pop    %esi
801016f5:	5d                   	pop    %ebp
801016f6:	c3                   	ret    
801016f7:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
801016fb:	c1 e8 03             	shr    $0x3,%eax
801016fe:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101704:	89 44 24 04          	mov    %eax,0x4(%esp)
80101708:	8b 03                	mov    (%ebx),%eax
8010170a:	89 04 24             	mov    %eax,(%esp)
8010170d:	e8 be e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101712:	8b 53 04             	mov    0x4(%ebx),%edx
80101715:	83 e2 07             	and    $0x7,%edx
80101718:	c1 e2 06             	shl    $0x6,%edx
8010171b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101721:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101724:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101727:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010172b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010172f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101733:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101737:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010173b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010173f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101743:	8b 42 fc             	mov    -0x4(%edx),%eax
80101746:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101749:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010174c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101750:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101757:	00 
80101758:	89 04 24             	mov    %eax,(%esp)
8010175b:	e8 20 2c 00 00       	call   80104380 <memmove>
    brelse(bp);
80101760:	89 34 24             	mov    %esi,(%esp)
80101763:	e8 78 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 76 ff ff ff    	jne    801016f0 <ilock+0x30>
      panic("ilock: no type");
8010177a:	c7 04 24 70 72 10 80 	movl   $0x80107270,(%esp)
80101781:	e8 da eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101786:	c7 04 24 6a 72 10 80 	movl   $0x8010726a,(%esp)
8010178d:	e8 ce eb ff ff       	call   80100360 <panic>
80101792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017a0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	83 ec 10             	sub    $0x10,%esp
801017a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017ab:	85 db                	test   %ebx,%ebx
801017ad:	74 24                	je     801017d3 <iunlock+0x33>
801017af:	8d 73 0c             	lea    0xc(%ebx),%esi
801017b2:	89 34 24             	mov    %esi,(%esp)
801017b5:	e8 c6 28 00 00       	call   80104080 <holdingsleep>
801017ba:	85 c0                	test   %eax,%eax
801017bc:	74 15                	je     801017d3 <iunlock+0x33>
801017be:	8b 43 08             	mov    0x8(%ebx),%eax
801017c1:	85 c0                	test   %eax,%eax
801017c3:	7e 0e                	jle    801017d3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017c5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	5b                   	pop    %ebx
801017cc:	5e                   	pop    %esi
801017cd:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ce:	e9 6d 28 00 00       	jmp    80104040 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017d3:	c7 04 24 7f 72 10 80 	movl   $0x8010727f,(%esp)
801017da:	e8 81 eb ff ff       	call   80100360 <panic>
801017df:	90                   	nop

801017e0 <calliget>:
  log_write(bp);
  brelse(bp);
}

void
calliget(uint inum){
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	53                   	push   %ebx
801017e4:	83 ec 14             	sub    $0x14,%esp
801017e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	begin_op();
801017ea:	e8 81 13 00 00       	call   80102b70 <begin_op>
	struct inode *inodeToDel;
	inodeToDel = iget(1,inum);
801017ef:	b8 01 00 00 00       	mov    $0x1,%eax
801017f4:	89 da                	mov    %ebx,%edx
801017f6:	e8 25 fa ff ff       	call   80101220 <iget>
801017fb:	89 c3                	mov    %eax,%ebx
	ilock(inodeToDel);
801017fd:	89 04 24             	mov    %eax,(%esp)
80101800:	e8 bb fe ff ff       	call   801016c0 <ilock>
	//cprintf("\n\n---> inode#: %d \t type: %d\n\n",inodeToDel->inum,inodeToDel->type);

	inodeToDel->addrs[0] = 0;
80101805:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)

	iupdate(inodeToDel);
8010180c:	89 1c 24             	mov    %ebx,(%esp)
8010180f:	e8 ec fd ff ff       	call   80101600 <iupdate>

	//cprintf("\n\n---> inode#: %d \t type: %d\n\n",inodeToDel->inum,inodeToDel->type);
	iunlock(inodeToDel);
80101814:	89 1c 24             	mov    %ebx,(%esp)
80101817:	e8 84 ff ff ff       	call   801017a0 <iunlock>

	end_op();
	return;
}
8010181c:	83 c4 14             	add    $0x14,%esp
8010181f:	5b                   	pop    %ebx
80101820:	5d                   	pop    %ebp
	iupdate(inodeToDel);

	//cprintf("\n\n---> inode#: %d \t type: %d\n\n",inodeToDel->inum,inodeToDel->type);
	iunlock(inodeToDel);

	end_op();
80101821:	e9 ba 13 00 00       	jmp    80102be0 <end_op>
80101826:	8d 76 00             	lea    0x0(%esi),%esi
80101829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101830 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	57                   	push   %edi
80101834:	56                   	push   %esi
80101835:	53                   	push   %ebx
80101836:	83 ec 1c             	sub    $0x1c,%esp
80101839:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010183c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010183f:	89 3c 24             	mov    %edi,(%esp)
80101842:	e8 99 27 00 00       	call   80103fe0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101847:	8b 56 4c             	mov    0x4c(%esi),%edx
8010184a:	85 d2                	test   %edx,%edx
8010184c:	74 07                	je     80101855 <iput+0x25>
8010184e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101853:	74 2b                	je     80101880 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101855:	89 3c 24             	mov    %edi,(%esp)
80101858:	e8 e3 27 00 00       	call   80104040 <releasesleep>

  acquire(&icache.lock);
8010185d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101864:	e8 37 29 00 00       	call   801041a0 <acquire>
  ip->ref--;
80101869:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010186d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101874:	83 c4 1c             	add    $0x1c,%esp
80101877:	5b                   	pop    %ebx
80101878:	5e                   	pop    %esi
80101879:	5f                   	pop    %edi
8010187a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010187b:	e9 10 2a 00 00       	jmp    80104290 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101880:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101887:	e8 14 29 00 00       	call   801041a0 <acquire>
    int r = ip->ref;
8010188c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010188f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101896:	e8 f5 29 00 00       	call   80104290 <release>
    if(r == 1){
8010189b:	83 fb 01             	cmp    $0x1,%ebx
8010189e:	75 b5                	jne    80101855 <iput+0x25>
801018a0:	8d 4e 30             	lea    0x30(%esi),%ecx
801018a3:	89 f3                	mov    %esi,%ebx
801018a5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018a8:	89 cf                	mov    %ecx,%edi
801018aa:	eb 0b                	jmp    801018b7 <iput+0x87>
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018b0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018b3:	39 fb                	cmp    %edi,%ebx
801018b5:	74 19                	je     801018d0 <iput+0xa0>
    if(ip->addrs[i]){
801018b7:	8b 53 5c             	mov    0x5c(%ebx),%edx
801018ba:	85 d2                	test   %edx,%edx
801018bc:	74 f2                	je     801018b0 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
801018be:	8b 06                	mov    (%esi),%eax
801018c0:	e8 2b fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
801018c5:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
801018cc:	eb e2                	jmp    801018b0 <iput+0x80>
801018ce:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
801018d0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018d9:	85 c0                	test   %eax,%eax
801018db:	75 2b                	jne    80101908 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018dd:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018e4:	89 34 24             	mov    %esi,(%esp)
801018e7:	e8 14 fd ff ff       	call   80101600 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
801018ec:	31 c0                	xor    %eax,%eax
801018ee:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018f2:	89 34 24             	mov    %esi,(%esp)
801018f5:	e8 06 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018fa:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101901:	e9 4f ff ff ff       	jmp    80101855 <iput+0x25>
80101906:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101908:	89 44 24 04          	mov    %eax,0x4(%esp)
8010190c:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010190e:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101910:	89 04 24             	mov    %eax,(%esp)
80101913:	e8 b8 e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101918:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
8010191b:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010191e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101921:	89 cf                	mov    %ecx,%edi
80101923:	31 c0                	xor    %eax,%eax
80101925:	eb 0e                	jmp    80101935 <iput+0x105>
80101927:	90                   	nop
80101928:	83 c3 01             	add    $0x1,%ebx
8010192b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101931:	89 d8                	mov    %ebx,%eax
80101933:	74 10                	je     80101945 <iput+0x115>
      if(a[j])
80101935:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101938:	85 d2                	test   %edx,%edx
8010193a:	74 ec                	je     80101928 <iput+0xf8>
        bfree(ip->dev, a[j]);
8010193c:	8b 06                	mov    (%esi),%eax
8010193e:	e8 ad fa ff ff       	call   801013f0 <bfree>
80101943:	eb e3                	jmp    80101928 <iput+0xf8>
    }
    brelse(bp);
80101945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101948:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010194b:	89 04 24             	mov    %eax,(%esp)
8010194e:	e8 8d e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101953:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101959:	8b 06                	mov    (%esi),%eax
8010195b:	e8 90 fa ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101960:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101967:	00 00 00 
8010196a:	e9 6e ff ff ff       	jmp    801018dd <iput+0xad>
8010196f:	90                   	nop

80101970 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	53                   	push   %ebx
80101974:	83 ec 14             	sub    $0x14,%esp
80101977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010197a:	89 1c 24             	mov    %ebx,(%esp)
8010197d:	e8 1e fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101982:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101985:	83 c4 14             	add    $0x14,%esp
80101988:	5b                   	pop    %ebx
80101989:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010198a:	e9 a1 fe ff ff       	jmp    80101830 <iput>
8010198f:	90                   	nop

80101990 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	8b 55 08             	mov    0x8(%ebp),%edx
80101996:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101999:	8b 0a                	mov    (%edx),%ecx
8010199b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010199e:	8b 4a 04             	mov    0x4(%edx),%ecx
801019a1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019a4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019a8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019ab:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019af:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019b3:	8b 52 58             	mov    0x58(%edx),%edx
801019b6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019b9:	5d                   	pop    %ebp
801019ba:	c3                   	ret    
801019bb:	90                   	nop
801019bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019c0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	57                   	push   %edi
801019c4:	56                   	push   %esi
801019c5:	53                   	push   %ebx
801019c6:	83 ec 2c             	sub    $0x2c,%esp
801019c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801019cc:	8b 7d 08             	mov    0x8(%ebp),%edi
801019cf:	8b 75 10             	mov    0x10(%ebp),%esi
801019d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019d5:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019d8:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019e0:	0f 84 aa 00 00 00    	je     80101a90 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019e6:	8b 47 58             	mov    0x58(%edi),%eax
801019e9:	39 f0                	cmp    %esi,%eax
801019eb:	0f 82 c7 00 00 00    	jb     80101ab8 <readi+0xf8>
801019f1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019f4:	89 da                	mov    %ebx,%edx
801019f6:	01 f2                	add    %esi,%edx
801019f8:	0f 82 ba 00 00 00    	jb     80101ab8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019fe:	89 c1                	mov    %eax,%ecx
80101a00:	29 f1                	sub    %esi,%ecx
80101a02:	39 d0                	cmp    %edx,%eax
80101a04:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a07:	31 c0                	xor    %eax,%eax
80101a09:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a0b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a0e:	74 70                	je     80101a80 <readi+0xc0>
80101a10:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101a13:	89 c7                	mov    %eax,%edi
80101a15:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a18:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a1b:	89 f2                	mov    %esi,%edx
80101a1d:	c1 ea 09             	shr    $0x9,%edx
80101a20:	89 d8                	mov    %ebx,%eax
80101a22:	e8 b9 f8 ff ff       	call   801012e0 <bmap>
80101a27:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a2b:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a2d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a32:	89 04 24             	mov    %eax,(%esp)
80101a35:	e8 96 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a3a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a3d:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a3f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a41:	89 f0                	mov    %esi,%eax
80101a43:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a48:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a4a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a4e:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a50:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a57:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a5a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a5e:	01 df                	add    %ebx,%edi
80101a60:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a62:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a65:	89 04 24             	mov    %eax,(%esp)
80101a68:	e8 13 29 00 00       	call   80104380 <memmove>
    brelse(bp);
80101a6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a70:	89 14 24             	mov    %edx,(%esp)
80101a73:	e8 68 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a78:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a7b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a7e:	77 98                	ja     80101a18 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a83:	83 c4 2c             	add    $0x2c,%esp
80101a86:	5b                   	pop    %ebx
80101a87:	5e                   	pop    %esi
80101a88:	5f                   	pop    %edi
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	90                   	nop
80101a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a90:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a94:	66 83 f8 09          	cmp    $0x9,%ax
80101a98:	77 1e                	ja     80101ab8 <readi+0xf8>
80101a9a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101aa1:	85 c0                	test   %eax,%eax
80101aa3:	74 13                	je     80101ab8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101aa5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101aa8:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101aab:	83 c4 2c             	add    $0x2c,%esp
80101aae:	5b                   	pop    %ebx
80101aaf:	5e                   	pop    %esi
80101ab0:	5f                   	pop    %edi
80101ab1:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101ab2:	ff e0                	jmp    *%eax
80101ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101abd:	eb c4                	jmp    80101a83 <readi+0xc3>
80101abf:	90                   	nop

80101ac0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	57                   	push   %edi
80101ac4:	56                   	push   %esi
80101ac5:	53                   	push   %ebx
80101ac6:	83 ec 2c             	sub    $0x2c,%esp
80101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80101acc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101acf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ad2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ad7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101ada:	8b 75 10             	mov    0x10(%ebp),%esi
80101add:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ae0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ae3:	0f 84 b7 00 00 00    	je     80101ba0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ae9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aec:	39 70 58             	cmp    %esi,0x58(%eax)
80101aef:	0f 82 e3 00 00 00    	jb     80101bd8 <writei+0x118>
80101af5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101af8:	89 c8                	mov    %ecx,%eax
80101afa:	01 f0                	add    %esi,%eax
80101afc:	0f 82 d6 00 00 00    	jb     80101bd8 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b02:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b07:	0f 87 cb 00 00 00    	ja     80101bd8 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b0d:	85 c9                	test   %ecx,%ecx
80101b0f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b16:	74 77                	je     80101b8f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b18:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b1b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b22:	c1 ea 09             	shr    $0x9,%edx
80101b25:	89 f8                	mov    %edi,%eax
80101b27:	e8 b4 f7 ff ff       	call   801012e0 <bmap>
80101b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b30:	8b 07                	mov    (%edi),%eax
80101b32:	89 04 24             	mov    %eax,(%esp)
80101b35:	e8 96 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b3a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b3d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b40:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b43:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b45:	89 f0                	mov    %esi,%eax
80101b47:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b4c:	29 c3                	sub    %eax,%ebx
80101b4e:	39 cb                	cmp    %ecx,%ebx
80101b50:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b53:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b57:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b59:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b5d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b61:	89 04 24             	mov    %eax,(%esp)
80101b64:	e8 17 28 00 00       	call   80104380 <memmove>
    log_write(bp);
80101b69:	89 3c 24             	mov    %edi,(%esp)
80101b6c:	e8 9f 11 00 00       	call   80102d10 <log_write>
    brelse(bp);
80101b71:	89 3c 24             	mov    %edi,(%esp)
80101b74:	e8 67 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b79:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b7f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b82:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b85:	77 91                	ja     80101b18 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b87:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b8a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b8d:	72 39                	jb     80101bc8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b92:	83 c4 2c             	add    $0x2c,%esp
80101b95:	5b                   	pop    %ebx
80101b96:	5e                   	pop    %esi
80101b97:	5f                   	pop    %edi
80101b98:	5d                   	pop    %ebp
80101b99:	c3                   	ret    
80101b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ba0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ba4:	66 83 f8 09          	cmp    $0x9,%ax
80101ba8:	77 2e                	ja     80101bd8 <writei+0x118>
80101baa:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101bb1:	85 c0                	test   %eax,%eax
80101bb3:	74 23                	je     80101bd8 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bb5:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101bb8:	83 c4 2c             	add    $0x2c,%esp
80101bbb:	5b                   	pop    %ebx
80101bbc:	5e                   	pop    %esi
80101bbd:	5f                   	pop    %edi
80101bbe:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bbf:	ff e0                	jmp    *%eax
80101bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101bc8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcb:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bce:	89 04 24             	mov    %eax,(%esp)
80101bd1:	e8 2a fa ff ff       	call   80101600 <iupdate>
80101bd6:	eb b7                	jmp    80101b8f <writei+0xcf>
  }
  return n;
}
80101bd8:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101bdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101be0:	5b                   	pop    %ebx
80101be1:	5e                   	pop    %esi
80101be2:	5f                   	pop    %edi
80101be3:	5d                   	pop    %ebp
80101be4:	c3                   	ret    
80101be5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bf9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c00:	00 
80101c01:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c05:	8b 45 08             	mov    0x8(%ebp),%eax
80101c08:	89 04 24             	mov    %eax,(%esp)
80101c0b:	e8 f0 27 00 00       	call   80104400 <strncmp>
}
80101c10:	c9                   	leave  
80101c11:	c3                   	ret    
80101c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	83 ec 2c             	sub    $0x2c,%esp
80101c29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c2c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c31:	0f 85 97 00 00 00    	jne    80101cce <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c37:	8b 53 58             	mov    0x58(%ebx),%edx
80101c3a:	31 ff                	xor    %edi,%edi
80101c3c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c3f:	85 d2                	test   %edx,%edx
80101c41:	75 0d                	jne    80101c50 <dirlookup+0x30>
80101c43:	eb 73                	jmp    80101cb8 <dirlookup+0x98>
80101c45:	8d 76 00             	lea    0x0(%esi),%esi
80101c48:	83 c7 10             	add    $0x10,%edi
80101c4b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c4e:	76 68                	jbe    80101cb8 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c50:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c57:	00 
80101c58:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c5c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c60:	89 1c 24             	mov    %ebx,(%esp)
80101c63:	e8 58 fd ff ff       	call   801019c0 <readi>
80101c68:	83 f8 10             	cmp    $0x10,%eax
80101c6b:	75 55                	jne    80101cc2 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c6d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c72:	74 d4                	je     80101c48 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c74:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c77:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c7e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c85:	00 
80101c86:	89 04 24             	mov    %eax,(%esp)
80101c89:	e8 72 27 00 00       	call   80104400 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c8e:	85 c0                	test   %eax,%eax
80101c90:	75 b6                	jne    80101c48 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c92:	8b 45 10             	mov    0x10(%ebp),%eax
80101c95:	85 c0                	test   %eax,%eax
80101c97:	74 05                	je     80101c9e <dirlookup+0x7e>
        *poff = off;
80101c99:	8b 45 10             	mov    0x10(%ebp),%eax
80101c9c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c9e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ca2:	8b 03                	mov    (%ebx),%eax
80101ca4:	e8 77 f5 ff ff       	call   80101220 <iget>
    }
  }

  return 0;
}
80101ca9:	83 c4 2c             	add    $0x2c,%esp
80101cac:	5b                   	pop    %ebx
80101cad:	5e                   	pop    %esi
80101cae:	5f                   	pop    %edi
80101caf:	5d                   	pop    %ebp
80101cb0:	c3                   	ret    
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cb8:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101cbb:	31 c0                	xor    %eax,%eax
}
80101cbd:	5b                   	pop    %ebx
80101cbe:	5e                   	pop    %esi
80101cbf:	5f                   	pop    %edi
80101cc0:	5d                   	pop    %ebp
80101cc1:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101cc2:	c7 04 24 99 72 10 80 	movl   $0x80107299,(%esp)
80101cc9:	e8 92 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101cce:	c7 04 24 87 72 10 80 	movl   $0x80107287,(%esp)
80101cd5:	e8 86 e6 ff ff       	call   80100360 <panic>
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ce0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	89 cf                	mov    %ecx,%edi
80101ce6:	56                   	push   %esi
80101ce7:	53                   	push   %ebx
80101ce8:	89 c3                	mov    %eax,%ebx
80101cea:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ced:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cf0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101cf3:	0f 84 51 01 00 00    	je     80101e4a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cf9:	e8 02 1a 00 00       	call   80103700 <myproc>
80101cfe:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101d01:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d08:	e8 93 24 00 00       	call   801041a0 <acquire>
  ip->ref++;
80101d0d:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d11:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d18:	e8 73 25 00 00       	call   80104290 <release>
80101d1d:	eb 04                	jmp    80101d23 <namex+0x43>
80101d1f:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d23:	0f b6 03             	movzbl (%ebx),%eax
80101d26:	3c 2f                	cmp    $0x2f,%al
80101d28:	74 f6                	je     80101d20 <namex+0x40>
    path++;
  if(*path == 0)
80101d2a:	84 c0                	test   %al,%al
80101d2c:	0f 84 ed 00 00 00    	je     80101e1f <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d32:	0f b6 03             	movzbl (%ebx),%eax
80101d35:	89 da                	mov    %ebx,%edx
80101d37:	84 c0                	test   %al,%al
80101d39:	0f 84 b1 00 00 00    	je     80101df0 <namex+0x110>
80101d3f:	3c 2f                	cmp    $0x2f,%al
80101d41:	75 0f                	jne    80101d52 <namex+0x72>
80101d43:	e9 a8 00 00 00       	jmp    80101df0 <namex+0x110>
80101d48:	3c 2f                	cmp    $0x2f,%al
80101d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d50:	74 0a                	je     80101d5c <namex+0x7c>
    path++;
80101d52:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d55:	0f b6 02             	movzbl (%edx),%eax
80101d58:	84 c0                	test   %al,%al
80101d5a:	75 ec                	jne    80101d48 <namex+0x68>
80101d5c:	89 d1                	mov    %edx,%ecx
80101d5e:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d60:	83 f9 0d             	cmp    $0xd,%ecx
80101d63:	0f 8e 8f 00 00 00    	jle    80101df8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d69:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d6d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d74:	00 
80101d75:	89 3c 24             	mov    %edi,(%esp)
80101d78:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d7b:	e8 00 26 00 00       	call   80104380 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d83:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d85:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d88:	75 0e                	jne    80101d98 <namex+0xb8>
80101d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d90:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d93:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d96:	74 f8                	je     80101d90 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d98:	89 34 24             	mov    %esi,(%esp)
80101d9b:	e8 20 f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101da0:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101da5:	0f 85 85 00 00 00    	jne    80101e30 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dab:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dae:	85 d2                	test   %edx,%edx
80101db0:	74 09                	je     80101dbb <namex+0xdb>
80101db2:	80 3b 00             	cmpb   $0x0,(%ebx)
80101db5:	0f 84 a5 00 00 00    	je     80101e60 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dbb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101dc2:	00 
80101dc3:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101dc7:	89 34 24             	mov    %esi,(%esp)
80101dca:	e8 51 fe ff ff       	call   80101c20 <dirlookup>
80101dcf:	85 c0                	test   %eax,%eax
80101dd1:	74 5d                	je     80101e30 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dd3:	89 34 24             	mov    %esi,(%esp)
80101dd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101dd9:	e8 c2 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101dde:	89 34 24             	mov    %esi,(%esp)
80101de1:	e8 4a fa ff ff       	call   80101830 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101de9:	89 c6                	mov    %eax,%esi
80101deb:	e9 33 ff ff ff       	jmp    80101d23 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101df0:	31 c9                	xor    %ecx,%ecx
80101df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101df8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dfc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101e00:	89 3c 24             	mov    %edi,(%esp)
80101e03:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e06:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e09:	e8 72 25 00 00       	call   80104380 <memmove>
    name[len] = 0;
80101e0e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e11:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e14:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e18:	89 d3                	mov    %edx,%ebx
80101e1a:	e9 66 ff ff ff       	jmp    80101d85 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e22:	85 c0                	test   %eax,%eax
80101e24:	75 4c                	jne    80101e72 <namex+0x192>
80101e26:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e28:	83 c4 2c             	add    $0x2c,%esp
80101e2b:	5b                   	pop    %ebx
80101e2c:	5e                   	pop    %esi
80101e2d:	5f                   	pop    %edi
80101e2e:	5d                   	pop    %ebp
80101e2f:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e30:	89 34 24             	mov    %esi,(%esp)
80101e33:	e8 68 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101e38:	89 34 24             	mov    %esi,(%esp)
80101e3b:	e8 f0 f9 ff ff       	call   80101830 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e40:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e43:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e45:	5b                   	pop    %ebx
80101e46:	5e                   	pop    %esi
80101e47:	5f                   	pop    %edi
80101e48:	5d                   	pop    %ebp
80101e49:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e4a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e4f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e54:	e8 c7 f3 ff ff       	call   80101220 <iget>
80101e59:	89 c6                	mov    %eax,%esi
80101e5b:	e9 c3 fe ff ff       	jmp    80101d23 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e60:	89 34 24             	mov    %esi,(%esp)
80101e63:	e8 38 f9 ff ff       	call   801017a0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e68:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e6b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e6d:	5b                   	pop    %ebx
80101e6e:	5e                   	pop    %esi
80101e6f:	5f                   	pop    %edi
80101e70:	5d                   	pop    %ebp
80101e71:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e72:	89 34 24             	mov    %esi,(%esp)
80101e75:	e8 b6 f9 ff ff       	call   80101830 <iput>
    return 0;
80101e7a:	31 c0                	xor    %eax,%eax
80101e7c:	eb aa                	jmp    80101e28 <namex+0x148>
80101e7e:	66 90                	xchg   %ax,%ax

80101e80 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	57                   	push   %edi
80101e84:	56                   	push   %esi
80101e85:	53                   	push   %ebx
80101e86:	83 ec 2c             	sub    $0x2c,%esp
80101e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e8f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e96:	00 
80101e97:	89 1c 24             	mov    %ebx,(%esp)
80101e9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e9e:	e8 7d fd ff ff       	call   80101c20 <dirlookup>
80101ea3:	85 c0                	test   %eax,%eax
80101ea5:	0f 85 8b 00 00 00    	jne    80101f36 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101eab:	8b 43 58             	mov    0x58(%ebx),%eax
80101eae:	31 ff                	xor    %edi,%edi
80101eb0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101eb3:	85 c0                	test   %eax,%eax
80101eb5:	75 13                	jne    80101eca <dirlink+0x4a>
80101eb7:	eb 35                	jmp    80101eee <dirlink+0x6e>
80101eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ec0:	8d 57 10             	lea    0x10(%edi),%edx
80101ec3:	39 53 58             	cmp    %edx,0x58(%ebx)
80101ec6:	89 d7                	mov    %edx,%edi
80101ec8:	76 24                	jbe    80101eee <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eca:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ed1:	00 
80101ed2:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ed6:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eda:	89 1c 24             	mov    %ebx,(%esp)
80101edd:	e8 de fa ff ff       	call   801019c0 <readi>
80101ee2:	83 f8 10             	cmp    $0x10,%eax
80101ee5:	75 5e                	jne    80101f45 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101ee7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eec:	75 d2                	jne    80101ec0 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101eee:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ef1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ef8:	00 
80101ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101efd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f00:	89 04 24             	mov    %eax,(%esp)
80101f03:	e8 68 25 00 00       	call   80104470 <strncpy>
  de.inum = inum;
80101f08:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f0b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101f12:	00 
80101f13:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101f17:	89 74 24 04          	mov    %esi,0x4(%esp)
80101f1b:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101f1e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f22:	e8 99 fb ff ff       	call   80101ac0 <writei>
80101f27:	83 f8 10             	cmp    $0x10,%eax
80101f2a:	75 25                	jne    80101f51 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101f2c:	31 c0                	xor    %eax,%eax
}
80101f2e:	83 c4 2c             	add    $0x2c,%esp
80101f31:	5b                   	pop    %ebx
80101f32:	5e                   	pop    %esi
80101f33:	5f                   	pop    %edi
80101f34:	5d                   	pop    %ebp
80101f35:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f36:	89 04 24             	mov    %eax,(%esp)
80101f39:	e8 f2 f8 ff ff       	call   80101830 <iput>
    return -1;
80101f3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f43:	eb e9                	jmp    80101f2e <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f45:	c7 04 24 a8 72 10 80 	movl   $0x801072a8,(%esp)
80101f4c:	e8 0f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f51:	c7 04 24 ae 78 10 80 	movl   $0x801078ae,(%esp)
80101f58:	e8 03 e4 ff ff       	call   80100360 <panic>
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi

80101f60 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f60:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f61:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f63:	89 e5                	mov    %esp,%ebp
80101f65:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f68:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f6e:	e8 6d fd ff ff       	call   80101ce0 <namex>
}
80101f73:	c9                   	leave  
80101f74:	c3                   	ret    
80101f75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f80 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f80:	55                   	push   %ebp
  return namex(path, 1, name);
80101f81:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f86:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f8e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f8f:	e9 4c fd ff ff       	jmp    80101ce0 <namex>
80101f94:	66 90                	xchg   %ax,%ax
80101f96:	66 90                	xchg   %ax,%ax
80101f98:	66 90                	xchg   %ax,%ax
80101f9a:	66 90                	xchg   %ax,%ax
80101f9c:	66 90                	xchg   %ax,%ax
80101f9e:	66 90                	xchg   %ax,%ax

80101fa0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	56                   	push   %esi
80101fa4:	89 c6                	mov    %eax,%esi
80101fa6:	53                   	push   %ebx
80101fa7:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101faa:	85 c0                	test   %eax,%eax
80101fac:	0f 84 99 00 00 00    	je     8010204b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fb2:	8b 48 08             	mov    0x8(%eax),%ecx
80101fb5:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101fbb:	0f 87 7e 00 00 00    	ja     8010203f <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fc1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fc6:	66 90                	xchg   %ax,%ax
80101fc8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fc9:	83 e0 c0             	and    $0xffffffc0,%eax
80101fcc:	3c 40                	cmp    $0x40,%al
80101fce:	75 f8                	jne    80101fc8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fd0:	31 db                	xor    %ebx,%ebx
80101fd2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fd7:	89 d8                	mov    %ebx,%eax
80101fd9:	ee                   	out    %al,(%dx)
80101fda:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fdf:	b8 01 00 00 00       	mov    $0x1,%eax
80101fe4:	ee                   	out    %al,(%dx)
80101fe5:	0f b6 c1             	movzbl %cl,%eax
80101fe8:	b2 f3                	mov    $0xf3,%dl
80101fea:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101feb:	89 c8                	mov    %ecx,%eax
80101fed:	b2 f4                	mov    $0xf4,%dl
80101fef:	c1 f8 08             	sar    $0x8,%eax
80101ff2:	ee                   	out    %al,(%dx)
80101ff3:	b2 f5                	mov    $0xf5,%dl
80101ff5:	89 d8                	mov    %ebx,%eax
80101ff7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101ff8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101ffc:	b2 f6                	mov    $0xf6,%dl
80101ffe:	83 e0 01             	and    $0x1,%eax
80102001:	c1 e0 04             	shl    $0x4,%eax
80102004:	83 c8 e0             	or     $0xffffffe0,%eax
80102007:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102008:	f6 06 04             	testb  $0x4,(%esi)
8010200b:	75 13                	jne    80102020 <idestart+0x80>
8010200d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102012:	b8 20 00 00 00       	mov    $0x20,%eax
80102017:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102018:	83 c4 10             	add    $0x10,%esp
8010201b:	5b                   	pop    %ebx
8010201c:	5e                   	pop    %esi
8010201d:	5d                   	pop    %ebp
8010201e:	c3                   	ret    
8010201f:	90                   	nop
80102020:	b2 f7                	mov    $0xf7,%dl
80102022:	b8 30 00 00 00       	mov    $0x30,%eax
80102027:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102028:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010202d:	83 c6 5c             	add    $0x5c,%esi
80102030:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102035:	fc                   	cld    
80102036:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102038:	83 c4 10             	add    $0x10,%esp
8010203b:	5b                   	pop    %ebx
8010203c:	5e                   	pop    %esi
8010203d:	5d                   	pop    %ebp
8010203e:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010203f:	c7 04 24 14 73 10 80 	movl   $0x80107314,(%esp)
80102046:	e8 15 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010204b:	c7 04 24 0b 73 10 80 	movl   $0x8010730b,(%esp)
80102052:	e8 09 e3 ff ff       	call   80100360 <panic>
80102057:	89 f6                	mov    %esi,%esi
80102059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102060 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102066:	c7 44 24 04 26 73 10 	movl   $0x80107326,0x4(%esp)
8010206d:	80 
8010206e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102075:	e8 36 20 00 00       	call   801040b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010207a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010207f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102086:	83 e8 01             	sub    $0x1,%eax
80102089:	89 44 24 04          	mov    %eax,0x4(%esp)
8010208d:	e8 7e 02 00 00       	call   80102310 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102097:	90                   	nop
80102098:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102099:	83 e0 c0             	and    $0xffffffc0,%eax
8010209c:	3c 40                	cmp    $0x40,%al
8010209e:	75 f8                	jne    80102098 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020a0:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020a5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801020aa:	ee                   	out    %al,(%dx)
801020ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b0:	b2 f7                	mov    $0xf7,%dl
801020b2:	eb 09                	jmp    801020bd <ideinit+0x5d>
801020b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801020b8:	83 e9 01             	sub    $0x1,%ecx
801020bb:	74 0f                	je     801020cc <ideinit+0x6c>
801020bd:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020be:	84 c0                	test   %al,%al
801020c0:	74 f6                	je     801020b8 <ideinit+0x58>
      havedisk1 = 1;
801020c2:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801020c9:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020cc:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020d1:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020d6:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801020d7:	c9                   	leave  
801020d8:	c3                   	ret    
801020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020e0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020e9:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020f0:	e8 ab 20 00 00       	call   801041a0 <acquire>

  if((b = idequeue) == 0){
801020f5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020fb:	85 db                	test   %ebx,%ebx
801020fd:	74 30                	je     8010212f <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020ff:	8b 43 58             	mov    0x58(%ebx),%eax
80102102:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102107:	8b 33                	mov    (%ebx),%esi
80102109:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010210f:	74 37                	je     80102148 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102111:	83 e6 fb             	and    $0xfffffffb,%esi
80102114:	83 ce 02             	or     $0x2,%esi
80102117:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102119:	89 1c 24             	mov    %ebx,(%esp)
8010211c:	e8 cf 1c 00 00       	call   80103df0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102121:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102126:	85 c0                	test   %eax,%eax
80102128:	74 05                	je     8010212f <ideintr+0x4f>
    idestart(idequeue);
8010212a:	e8 71 fe ff ff       	call   80101fa0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
8010212f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102136:	e8 55 21 00 00       	call   80104290 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
8010213b:	83 c4 1c             	add    $0x1c,%esp
8010213e:	5b                   	pop    %ebx
8010213f:	5e                   	pop    %esi
80102140:	5f                   	pop    %edi
80102141:	5d                   	pop    %ebp
80102142:	c3                   	ret    
80102143:	90                   	nop
80102144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102148:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010214d:	8d 76 00             	lea    0x0(%esi),%esi
80102150:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102151:	89 c1                	mov    %eax,%ecx
80102153:	83 e1 c0             	and    $0xffffffc0,%ecx
80102156:	80 f9 40             	cmp    $0x40,%cl
80102159:	75 f5                	jne    80102150 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010215b:	a8 21                	test   $0x21,%al
8010215d:	75 b2                	jne    80102111 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010215f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102162:	b9 80 00 00 00       	mov    $0x80,%ecx
80102167:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010216c:	fc                   	cld    
8010216d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010216f:	8b 33                	mov    (%ebx),%esi
80102171:	eb 9e                	jmp    80102111 <ideintr+0x31>
80102173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102180 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102180:	55                   	push   %ebp
80102181:	89 e5                	mov    %esp,%ebp
80102183:	53                   	push   %ebx
80102184:	83 ec 14             	sub    $0x14,%esp
80102187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010218a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010218d:	89 04 24             	mov    %eax,(%esp)
80102190:	e8 eb 1e 00 00       	call   80104080 <holdingsleep>
80102195:	85 c0                	test   %eax,%eax
80102197:	0f 84 9e 00 00 00    	je     8010223b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010219d:	8b 03                	mov    (%ebx),%eax
8010219f:	83 e0 06             	and    $0x6,%eax
801021a2:	83 f8 02             	cmp    $0x2,%eax
801021a5:	0f 84 a8 00 00 00    	je     80102253 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021ab:	8b 53 04             	mov    0x4(%ebx),%edx
801021ae:	85 d2                	test   %edx,%edx
801021b0:	74 0d                	je     801021bf <iderw+0x3f>
801021b2:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801021b7:	85 c0                	test   %eax,%eax
801021b9:	0f 84 88 00 00 00    	je     80102247 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021bf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801021c6:	e8 d5 1f 00 00       	call   801041a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021cb:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801021d0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021d7:	85 c0                	test   %eax,%eax
801021d9:	75 07                	jne    801021e2 <iderw+0x62>
801021db:	eb 4e                	jmp    8010222b <iderw+0xab>
801021dd:	8d 76 00             	lea    0x0(%esi),%esi
801021e0:	89 d0                	mov    %edx,%eax
801021e2:	8b 50 58             	mov    0x58(%eax),%edx
801021e5:	85 d2                	test   %edx,%edx
801021e7:	75 f7                	jne    801021e0 <iderw+0x60>
801021e9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021ec:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021ee:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021f4:	74 3c                	je     80102232 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021f6:	8b 03                	mov    (%ebx),%eax
801021f8:	83 e0 06             	and    $0x6,%eax
801021fb:	83 f8 02             	cmp    $0x2,%eax
801021fe:	74 1a                	je     8010221a <iderw+0x9a>
    sleep(b, &idelock);
80102200:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102207:	80 
80102208:	89 1c 24             	mov    %ebx,(%esp)
8010220b:	e8 50 1a 00 00       	call   80103c60 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102210:	8b 13                	mov    (%ebx),%edx
80102212:	83 e2 06             	and    $0x6,%edx
80102215:	83 fa 02             	cmp    $0x2,%edx
80102218:	75 e6                	jne    80102200 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
8010221a:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102221:	83 c4 14             	add    $0x14,%esp
80102224:	5b                   	pop    %ebx
80102225:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102226:	e9 65 20 00 00       	jmp    80104290 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010222b:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
80102230:	eb ba                	jmp    801021ec <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102232:	89 d8                	mov    %ebx,%eax
80102234:	e8 67 fd ff ff       	call   80101fa0 <idestart>
80102239:	eb bb                	jmp    801021f6 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010223b:	c7 04 24 2a 73 10 80 	movl   $0x8010732a,(%esp)
80102242:	e8 19 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102247:	c7 04 24 55 73 10 80 	movl   $0x80107355,(%esp)
8010224e:	e8 0d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102253:	c7 04 24 40 73 10 80 	movl   $0x80107340,(%esp)
8010225a:	e8 01 e1 ff ff       	call   80100360 <panic>
8010225f:	90                   	nop

80102260 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	56                   	push   %esi
80102264:	53                   	push   %ebx
80102265:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102268:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010226f:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102272:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102279:	00 00 00 
  return ioapic->data;
8010227c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102282:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102285:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010228b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102291:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102298:	c1 e8 10             	shr    $0x10,%eax
8010229b:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010229e:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
801022a1:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022a4:	39 c2                	cmp    %eax,%edx
801022a6:	74 12                	je     801022ba <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022a8:	c7 04 24 74 73 10 80 	movl   $0x80107374,(%esp)
801022af:	e8 9c e3 ff ff       	call   80100650 <cprintf>
801022b4:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801022ba:	ba 10 00 00 00       	mov    $0x10,%edx
801022bf:	31 c0                	xor    %eax,%eax
801022c1:	eb 07                	jmp    801022ca <ioapicinit+0x6a>
801022c3:	90                   	nop
801022c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022c8:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ca:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
801022cc:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801022d2:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022d5:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022db:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022de:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022e1:	8d 4a 01             	lea    0x1(%edx),%ecx
801022e4:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022e7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022e9:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022ef:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022f1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022f8:	7d ce                	jge    801022c8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022fa:	83 c4 10             	add    $0x10,%esp
801022fd:	5b                   	pop    %ebx
801022fe:	5e                   	pop    %esi
801022ff:	5d                   	pop    %ebp
80102300:	c3                   	ret    
80102301:	eb 0d                	jmp    80102310 <ioapicenable>
80102303:	90                   	nop
80102304:	90                   	nop
80102305:	90                   	nop
80102306:	90                   	nop
80102307:	90                   	nop
80102308:	90                   	nop
80102309:	90                   	nop
8010230a:	90                   	nop
8010230b:	90                   	nop
8010230c:	90                   	nop
8010230d:	90                   	nop
8010230e:	90                   	nop
8010230f:	90                   	nop

80102310 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	8b 55 08             	mov    0x8(%ebp),%edx
80102316:	53                   	push   %ebx
80102317:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010231a:	8d 5a 20             	lea    0x20(%edx),%ebx
8010231d:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102321:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102327:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010232a:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010232c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102332:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102335:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102338:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010233a:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102340:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102343:	5b                   	pop    %ebx
80102344:	5d                   	pop    %ebp
80102345:	c3                   	ret    
80102346:	66 90                	xchg   %ax,%ax
80102348:	66 90                	xchg   %ax,%ax
8010234a:	66 90                	xchg   %ax,%ax
8010234c:	66 90                	xchg   %ax,%ax
8010234e:	66 90                	xchg   %ax,%ax

80102350 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 14             	sub    $0x14,%esp
80102357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010235a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102360:	75 7c                	jne    801023de <kfree+0x8e>
80102362:	81 fb c8 57 11 80    	cmp    $0x801157c8,%ebx
80102368:	72 74                	jb     801023de <kfree+0x8e>
8010236a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102370:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102375:	77 67                	ja     801023de <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102377:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010237e:	00 
8010237f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102386:	00 
80102387:	89 1c 24             	mov    %ebx,(%esp)
8010238a:	e8 51 1f 00 00       	call   801042e0 <memset>

  if(kmem.use_lock)
8010238f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102395:	85 d2                	test   %edx,%edx
80102397:	75 37                	jne    801023d0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102399:	a1 78 26 11 80       	mov    0x80112678,%eax
8010239e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023a0:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801023a5:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801023ab:	85 c0                	test   %eax,%eax
801023ad:	75 09                	jne    801023b8 <kfree+0x68>
    release(&kmem.lock);
}
801023af:	83 c4 14             	add    $0x14,%esp
801023b2:	5b                   	pop    %ebx
801023b3:	5d                   	pop    %ebp
801023b4:	c3                   	ret    
801023b5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023b8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801023bf:	83 c4 14             	add    $0x14,%esp
801023c2:	5b                   	pop    %ebx
801023c3:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023c4:	e9 c7 1e 00 00       	jmp    80104290 <release>
801023c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023d0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023d7:	e8 c4 1d 00 00       	call   801041a0 <acquire>
801023dc:	eb bb                	jmp    80102399 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801023de:	c7 04 24 a6 73 10 80 	movl   $0x801073a6,(%esp)
801023e5:	e8 76 df ff ff       	call   80100360 <panic>
801023ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023f0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fe:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102404:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102410:	39 de                	cmp    %ebx,%esi
80102412:	73 08                	jae    8010241c <freerange+0x2c>
80102414:	eb 18                	jmp    8010242e <freerange+0x3e>
80102416:	66 90                	xchg   %ax,%ax
80102418:	89 da                	mov    %ebx,%edx
8010241a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010241c:	89 14 24             	mov    %edx,(%esp)
8010241f:	e8 2c ff ff ff       	call   80102350 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102424:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010242a:	39 f0                	cmp    %esi,%eax
8010242c:	76 ea                	jbe    80102418 <freerange+0x28>
    kfree(p);
}
8010242e:	83 c4 10             	add    $0x10,%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret    
80102435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	83 ec 10             	sub    $0x10,%esp
80102448:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010244b:	c7 44 24 04 ac 73 10 	movl   $0x801073ac,0x4(%esp)
80102452:	80 
80102453:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010245a:	e8 51 1c 00 00       	call   801040b0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010245f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102462:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102469:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010246c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102472:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102478:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010247e:	39 de                	cmp    %ebx,%esi
80102480:	73 0a                	jae    8010248c <kinit1+0x4c>
80102482:	eb 1a                	jmp    8010249e <kinit1+0x5e>
80102484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102488:	89 da                	mov    %ebx,%edx
8010248a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010248c:	89 14 24             	mov    %edx,(%esp)
8010248f:	e8 bc fe ff ff       	call   80102350 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102494:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010249a:	39 c6                	cmp    %eax,%esi
8010249c:	73 ea                	jae    80102488 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010249e:	83 c4 10             	add    $0x10,%esp
801024a1:	5b                   	pop    %ebx
801024a2:	5e                   	pop    %esi
801024a3:	5d                   	pop    %ebp
801024a4:	c3                   	ret    
801024a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024b0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	56                   	push   %esi
801024b4:	53                   	push   %ebx
801024b5:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801024bb:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024be:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801024c4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ca:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024d0:	39 de                	cmp    %ebx,%esi
801024d2:	73 08                	jae    801024dc <kinit2+0x2c>
801024d4:	eb 18                	jmp    801024ee <kinit2+0x3e>
801024d6:	66 90                	xchg   %ax,%ax
801024d8:	89 da                	mov    %ebx,%edx
801024da:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024dc:	89 14 24             	mov    %edx,(%esp)
801024df:	e8 6c fe ff ff       	call   80102350 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024e4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024ea:	39 c6                	cmp    %eax,%esi
801024ec:	73 ea                	jae    801024d8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801024ee:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024f5:	00 00 00 
}
801024f8:	83 c4 10             	add    $0x10,%esp
801024fb:	5b                   	pop    %ebx
801024fc:	5e                   	pop    %esi
801024fd:	5d                   	pop    %ebp
801024fe:	c3                   	ret    
801024ff:	90                   	nop

80102500 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	53                   	push   %ebx
80102504:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102507:	a1 74 26 11 80       	mov    0x80112674,%eax
8010250c:	85 c0                	test   %eax,%eax
8010250e:	75 30                	jne    80102540 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102510:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102516:	85 db                	test   %ebx,%ebx
80102518:	74 08                	je     80102522 <kalloc+0x22>
    kmem.freelist = r->next;
8010251a:	8b 13                	mov    (%ebx),%edx
8010251c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102522:	85 c0                	test   %eax,%eax
80102524:	74 0c                	je     80102532 <kalloc+0x32>
    release(&kmem.lock);
80102526:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010252d:	e8 5e 1d 00 00       	call   80104290 <release>
  return (char*)r;
}
80102532:	83 c4 14             	add    $0x14,%esp
80102535:	89 d8                	mov    %ebx,%eax
80102537:	5b                   	pop    %ebx
80102538:	5d                   	pop    %ebp
80102539:	c3                   	ret    
8010253a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102540:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102547:	e8 54 1c 00 00       	call   801041a0 <acquire>
8010254c:	a1 74 26 11 80       	mov    0x80112674,%eax
80102551:	eb bd                	jmp    80102510 <kalloc+0x10>
80102553:	66 90                	xchg   %ax,%ax
80102555:	66 90                	xchg   %ax,%ax
80102557:	66 90                	xchg   %ax,%ax
80102559:	66 90                	xchg   %ax,%ax
8010255b:	66 90                	xchg   %ax,%ax
8010255d:	66 90                	xchg   %ax,%ax
8010255f:	90                   	nop

80102560 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102560:	ba 64 00 00 00       	mov    $0x64,%edx
80102565:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102566:	a8 01                	test   $0x1,%al
80102568:	0f 84 ba 00 00 00    	je     80102628 <kbdgetc+0xc8>
8010256e:	b2 60                	mov    $0x60,%dl
80102570:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102571:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102574:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010257a:	0f 84 88 00 00 00    	je     80102608 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102580:	84 c0                	test   %al,%al
80102582:	79 2c                	jns    801025b0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102584:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010258a:	f6 c2 40             	test   $0x40,%dl
8010258d:	75 05                	jne    80102594 <kbdgetc+0x34>
8010258f:	89 c1                	mov    %eax,%ecx
80102591:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102594:	0f b6 81 e0 74 10 80 	movzbl -0x7fef8b20(%ecx),%eax
8010259b:	83 c8 40             	or     $0x40,%eax
8010259e:	0f b6 c0             	movzbl %al,%eax
801025a1:	f7 d0                	not    %eax
801025a3:	21 d0                	and    %edx,%eax
801025a5:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
801025aa:	31 c0                	xor    %eax,%eax
801025ac:	c3                   	ret    
801025ad:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	53                   	push   %ebx
801025b4:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025ba:	f6 c3 40             	test   $0x40,%bl
801025bd:	74 09                	je     801025c8 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025bf:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025c2:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025c5:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025c8:	0f b6 91 e0 74 10 80 	movzbl -0x7fef8b20(%ecx),%edx
  shift ^= togglecode[data];
801025cf:	0f b6 81 e0 73 10 80 	movzbl -0x7fef8c20(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025d6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025d8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025da:	89 d0                	mov    %edx,%eax
801025dc:	83 e0 03             	and    $0x3,%eax
801025df:	8b 04 85 c0 73 10 80 	mov    -0x7fef8c40(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025e6:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
801025ec:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801025ef:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025f3:	74 0b                	je     80102600 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025f5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025f8:	83 fa 19             	cmp    $0x19,%edx
801025fb:	77 1b                	ja     80102618 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025fd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102600:	5b                   	pop    %ebx
80102601:	5d                   	pop    %ebp
80102602:	c3                   	ret    
80102603:	90                   	nop
80102604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102608:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010260f:	31 c0                	xor    %eax,%eax
80102611:	c3                   	ret    
80102612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102618:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010261b:	8d 50 20             	lea    0x20(%eax),%edx
8010261e:	83 f9 19             	cmp    $0x19,%ecx
80102621:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
80102624:	eb da                	jmp    80102600 <kbdgetc+0xa0>
80102626:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010262d:	c3                   	ret    
8010262e:	66 90                	xchg   %ax,%ax

80102630 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102636:	c7 04 24 60 25 10 80 	movl   $0x80102560,(%esp)
8010263d:	e8 6e e1 ff ff       	call   801007b0 <consoleintr>
}
80102642:	c9                   	leave  
80102643:	c3                   	ret    
80102644:	66 90                	xchg   %ax,%ax
80102646:	66 90                	xchg   %ax,%ax
80102648:	66 90                	xchg   %ax,%ax
8010264a:	66 90                	xchg   %ax,%ax
8010264c:	66 90                	xchg   %ax,%ax
8010264e:	66 90                	xchg   %ax,%ax

80102650 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102650:	55                   	push   %ebp
80102651:	89 c1                	mov    %eax,%ecx
80102653:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102655:	ba 70 00 00 00       	mov    $0x70,%edx
8010265a:	53                   	push   %ebx
8010265b:	31 c0                	xor    %eax,%eax
8010265d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010265e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102663:	89 da                	mov    %ebx,%edx
80102665:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102666:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102669:	b2 70                	mov    $0x70,%dl
8010266b:	89 01                	mov    %eax,(%ecx)
8010266d:	b8 02 00 00 00       	mov    $0x2,%eax
80102672:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102673:	89 da                	mov    %ebx,%edx
80102675:	ec                   	in     (%dx),%al
80102676:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102679:	b2 70                	mov    $0x70,%dl
8010267b:	89 41 04             	mov    %eax,0x4(%ecx)
8010267e:	b8 04 00 00 00       	mov    $0x4,%eax
80102683:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102684:	89 da                	mov    %ebx,%edx
80102686:	ec                   	in     (%dx),%al
80102687:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010268a:	b2 70                	mov    $0x70,%dl
8010268c:	89 41 08             	mov    %eax,0x8(%ecx)
8010268f:	b8 07 00 00 00       	mov    $0x7,%eax
80102694:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102695:	89 da                	mov    %ebx,%edx
80102697:	ec                   	in     (%dx),%al
80102698:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010269b:	b2 70                	mov    $0x70,%dl
8010269d:	89 41 0c             	mov    %eax,0xc(%ecx)
801026a0:	b8 08 00 00 00       	mov    $0x8,%eax
801026a5:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a6:	89 da                	mov    %ebx,%edx
801026a8:	ec                   	in     (%dx),%al
801026a9:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026ac:	b2 70                	mov    $0x70,%dl
801026ae:	89 41 10             	mov    %eax,0x10(%ecx)
801026b1:	b8 09 00 00 00       	mov    $0x9,%eax
801026b6:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b7:	89 da                	mov    %ebx,%edx
801026b9:	ec                   	in     (%dx),%al
801026ba:	0f b6 d8             	movzbl %al,%ebx
801026bd:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
801026c0:	5b                   	pop    %ebx
801026c1:	5d                   	pop    %ebp
801026c2:	c3                   	ret    
801026c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801026d5:	55                   	push   %ebp
801026d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026d8:	85 c0                	test   %eax,%eax
801026da:	0f 84 c0 00 00 00    	je     801027a0 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102701:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102704:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102707:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010270e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102711:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102714:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010271b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102721:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102728:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010272e:	8b 50 30             	mov    0x30(%eax),%edx
80102731:	c1 ea 10             	shr    $0x10,%edx
80102734:	80 fa 03             	cmp    $0x3,%dl
80102737:	77 6f                	ja     801027a8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102739:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102740:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102743:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102746:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010274d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102750:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102753:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010275a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010275d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102760:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102767:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010276a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010276d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102774:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102777:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102781:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102784:	8b 50 20             	mov    0x20(%eax),%edx
80102787:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102788:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010278e:	80 e6 10             	and    $0x10,%dh
80102791:	75 f5                	jne    80102788 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102793:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010279a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010279d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027a0:	5d                   	pop    %ebp
801027a1:	c3                   	ret    
801027a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027af:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027b2:	8b 50 20             	mov    0x20(%eax),%edx
801027b5:	eb 82                	jmp    80102739 <lapicinit+0x69>
801027b7:	89 f6                	mov    %esi,%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801027c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801027c5:	55                   	push   %ebp
801027c6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027c8:	85 c0                	test   %eax,%eax
801027ca:	74 0c                	je     801027d8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801027cc:	8b 40 20             	mov    0x20(%eax),%eax
}
801027cf:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801027d0:	c1 e8 18             	shr    $0x18,%eax
}
801027d3:	c3                   	ret    
801027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801027d8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801027da:	5d                   	pop    %ebp
801027db:	c3                   	ret    
801027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027e0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801027e5:	55                   	push   %ebp
801027e6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027e8:	85 c0                	test   %eax,%eax
801027ea:	74 0d                	je     801027f9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ec:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027f3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801027f9:	5d                   	pop    %ebp
801027fa:	c3                   	ret    
801027fb:	90                   	nop
801027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102800 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
}
80102803:	5d                   	pop    %ebp
80102804:	c3                   	ret    
80102805:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102810 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102810:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102811:	ba 70 00 00 00       	mov    $0x70,%edx
80102816:	89 e5                	mov    %esp,%ebp
80102818:	b8 0f 00 00 00       	mov    $0xf,%eax
8010281d:	53                   	push   %ebx
8010281e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102821:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102824:	ee                   	out    %al,(%dx)
80102825:	b8 0a 00 00 00       	mov    $0xa,%eax
8010282a:	b2 71                	mov    $0x71,%dl
8010282c:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010282d:	31 c0                	xor    %eax,%eax
8010282f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102835:	89 d8                	mov    %ebx,%eax
80102837:	c1 e8 04             	shr    $0x4,%eax
8010283a:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102840:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102845:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102848:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010284b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102851:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102854:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010285b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102861:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102868:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286b:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010286e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102877:	89 da                	mov    %ebx,%edx
80102879:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010287c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102882:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102885:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010288b:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010288e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102894:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102897:	5b                   	pop    %ebx
80102898:	5d                   	pop    %ebp
80102899:	c3                   	ret    
8010289a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028a0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028a0:	55                   	push   %ebp
801028a1:	ba 70 00 00 00       	mov    $0x70,%edx
801028a6:	89 e5                	mov    %esp,%ebp
801028a8:	b8 0b 00 00 00       	mov    $0xb,%eax
801028ad:	57                   	push   %edi
801028ae:	56                   	push   %esi
801028af:	53                   	push   %ebx
801028b0:	83 ec 4c             	sub    $0x4c,%esp
801028b3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b4:	b2 71                	mov    $0x71,%dl
801028b6:	ec                   	in     (%dx),%al
801028b7:	88 45 b7             	mov    %al,-0x49(%ebp)
801028ba:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801028bd:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801028c1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801028cd:	89 d8                	mov    %ebx,%eax
801028cf:	e8 7c fd ff ff       	call   80102650 <fill_rtcdate>
801028d4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028d9:	89 f2                	mov    %esi,%edx
801028db:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dc:	ba 71 00 00 00       	mov    $0x71,%edx
801028e1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028e2:	84 c0                	test   %al,%al
801028e4:	78 e7                	js     801028cd <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028e6:	89 f8                	mov    %edi,%eax
801028e8:	e8 63 fd ff ff       	call   80102650 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028ed:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028f4:	00 
801028f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028f9:	89 1c 24             	mov    %ebx,(%esp)
801028fc:	e8 2f 1a 00 00       	call   80104330 <memcmp>
80102901:	85 c0                	test   %eax,%eax
80102903:	75 c3                	jne    801028c8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102905:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102909:	75 78                	jne    80102983 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010290b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010290e:	89 c2                	mov    %eax,%edx
80102910:	83 e0 0f             	and    $0xf,%eax
80102913:	c1 ea 04             	shr    $0x4,%edx
80102916:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102919:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010291f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102922:	89 c2                	mov    %eax,%edx
80102924:	83 e0 0f             	and    $0xf,%eax
80102927:	c1 ea 04             	shr    $0x4,%edx
8010292a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010292d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102930:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102933:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102936:	89 c2                	mov    %eax,%edx
80102938:	83 e0 0f             	and    $0xf,%eax
8010293b:	c1 ea 04             	shr    $0x4,%edx
8010293e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102941:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102944:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102947:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010294a:	89 c2                	mov    %eax,%edx
8010294c:	83 e0 0f             	and    $0xf,%eax
8010294f:	c1 ea 04             	shr    $0x4,%edx
80102952:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102955:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102958:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010295b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010295e:	89 c2                	mov    %eax,%edx
80102960:	83 e0 0f             	and    $0xf,%eax
80102963:	c1 ea 04             	shr    $0x4,%edx
80102966:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102969:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010296f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102972:	89 c2                	mov    %eax,%edx
80102974:	83 e0 0f             	and    $0xf,%eax
80102977:	c1 ea 04             	shr    $0x4,%edx
8010297a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102980:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102983:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102986:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102989:	89 01                	mov    %eax,(%ecx)
8010298b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010298e:	89 41 04             	mov    %eax,0x4(%ecx)
80102991:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102994:	89 41 08             	mov    %eax,0x8(%ecx)
80102997:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010299a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 41 10             	mov    %eax,0x10(%ecx)
801029a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029a6:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
801029a9:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801029b0:	83 c4 4c             	add    $0x4c,%esp
801029b3:	5b                   	pop    %ebx
801029b4:	5e                   	pop    %esi
801029b5:	5f                   	pop    %edi
801029b6:	5d                   	pop    %ebp
801029b7:	c3                   	ret    
801029b8:	66 90                	xchg   %ax,%ax
801029ba:	66 90                	xchg   %ax,%ax
801029bc:	66 90                	xchg   %ax,%ax
801029be:	66 90                	xchg   %ax,%ax

801029c0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
801029c3:	57                   	push   %edi
801029c4:	56                   	push   %esi
801029c5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029c6:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029c8:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029cb:	a1 c8 26 11 80       	mov    0x801126c8,%eax
801029d0:	85 c0                	test   %eax,%eax
801029d2:	7e 78                	jle    80102a4c <install_trans+0x8c>
801029d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029d8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029dd:	01 d8                	add    %ebx,%eax
801029df:	83 c0 01             	add    $0x1,%eax
801029e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e6:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029eb:	89 04 24             	mov    %eax,(%esp)
801029ee:	e8 dd d6 ff ff       	call   801000d0 <bread>
801029f3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029f5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029fc:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a03:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a08:	89 04 24             	mov    %eax,(%esp)
80102a0b:	e8 c0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a10:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a17:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a18:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a1a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a21:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a24:	89 04 24             	mov    %eax,(%esp)
80102a27:	e8 54 19 00 00       	call   80104380 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a2c:	89 34 24             	mov    %esi,(%esp)
80102a2f:	e8 6c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a34:	89 3c 24             	mov    %edi,(%esp)
80102a37:	e8 a4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a3c:	89 34 24             	mov    %esi,(%esp)
80102a3f:	e8 9c d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a44:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a4a:	7f 8c                	jg     801029d8 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a4c:	83 c4 1c             	add    $0x1c,%esp
80102a4f:	5b                   	pop    %ebx
80102a50:	5e                   	pop    %esi
80102a51:	5f                   	pop    %edi
80102a52:	5d                   	pop    %ebp
80102a53:	c3                   	ret    
80102a54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	57                   	push   %edi
80102a64:	56                   	push   %esi
80102a65:	53                   	push   %ebx
80102a66:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a69:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a72:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a77:	89 04 24             	mov    %eax,(%esp)
80102a7a:	e8 51 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a7f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a85:	31 d2                	xor    %edx,%edx
80102a87:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a89:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a8b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a8e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a91:	7e 17                	jle    80102aaa <write_head+0x4a>
80102a93:	90                   	nop
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a98:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a9f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102aa3:	83 c2 01             	add    $0x1,%edx
80102aa6:	39 da                	cmp    %ebx,%edx
80102aa8:	75 ee                	jne    80102a98 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102aaa:	89 3c 24             	mov    %edi,(%esp)
80102aad:	e8 ee d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ab2:	89 3c 24             	mov    %edi,(%esp)
80102ab5:	e8 26 d7 ff ff       	call   801001e0 <brelse>
}
80102aba:	83 c4 1c             	add    $0x1c,%esp
80102abd:	5b                   	pop    %ebx
80102abe:	5e                   	pop    %esi
80102abf:	5f                   	pop    %edi
80102ac0:	5d                   	pop    %ebp
80102ac1:	c3                   	ret    
80102ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ad0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	56                   	push   %esi
80102ad4:	53                   	push   %ebx
80102ad5:	83 ec 30             	sub    $0x30,%esp
80102ad8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102adb:	c7 44 24 04 e0 75 10 	movl   $0x801075e0,0x4(%esp)
80102ae2:	80 
80102ae3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102aea:	e8 c1 15 00 00       	call   801040b0 <initlock>
  readsb(dev, &sb);
80102aef:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102af2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102af6:	89 1c 24             	mov    %ebx,(%esp)
80102af9:	e8 a2 e8 ff ff       	call   801013a0 <readsb>
  log.start = sb.logstart;
80102afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b01:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b04:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b07:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b0d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b11:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b17:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b1c:	e8 af d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b21:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b23:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b26:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b29:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b2b:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b31:	7e 17                	jle    80102b4a <initlog+0x7a>
80102b33:	90                   	nop
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b38:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b3c:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b43:	83 c2 01             	add    $0x1,%edx
80102b46:	39 da                	cmp    %ebx,%edx
80102b48:	75 ee                	jne    80102b38 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b4a:	89 04 24             	mov    %eax,(%esp)
80102b4d:	e8 8e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b52:	e8 69 fe ff ff       	call   801029c0 <install_trans>
  log.lh.n = 0;
80102b57:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b5e:	00 00 00 
  write_head(); // clear the log
80102b61:	e8 fa fe ff ff       	call   80102a60 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b66:	83 c4 30             	add    $0x30,%esp
80102b69:	5b                   	pop    %ebx
80102b6a:	5e                   	pop    %esi
80102b6b:	5d                   	pop    %ebp
80102b6c:	c3                   	ret    
80102b6d:	8d 76 00             	lea    0x0(%esi),%esi

80102b70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b76:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b7d:	e8 1e 16 00 00       	call   801041a0 <acquire>
80102b82:	eb 18                	jmp    80102b9c <begin_op+0x2c>
80102b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b88:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b8f:	80 
80102b90:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b97:	e8 c4 10 00 00       	call   80103c60 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b9c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102ba1:	85 c0                	test   %eax,%eax
80102ba3:	75 e3                	jne    80102b88 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ba5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102baa:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102bb0:	83 c0 01             	add    $0x1,%eax
80102bb3:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bb6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bb9:	83 fa 1e             	cmp    $0x1e,%edx
80102bbc:	7f ca                	jg     80102b88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bbe:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102bc5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102bca:	e8 c1 16 00 00       	call   80104290 <release>
      break;
    }
  }
}
80102bcf:	c9                   	leave  
80102bd0:	c3                   	ret    
80102bd1:	eb 0d                	jmp    80102be0 <end_op>
80102bd3:	90                   	nop
80102bd4:	90                   	nop
80102bd5:	90                   	nop
80102bd6:	90                   	nop
80102bd7:	90                   	nop
80102bd8:	90                   	nop
80102bd9:	90                   	nop
80102bda:	90                   	nop
80102bdb:	90                   	nop
80102bdc:	90                   	nop
80102bdd:	90                   	nop
80102bde:	90                   	nop
80102bdf:	90                   	nop

80102be0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	57                   	push   %edi
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102be9:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bf0:	e8 ab 15 00 00       	call   801041a0 <acquire>
  log.outstanding -= 1;
80102bf5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bfa:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c00:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c03:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c05:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102c0a:	0f 85 f3 00 00 00    	jne    80102d03 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c10:	85 c0                	test   %eax,%eax
80102c12:	0f 85 cb 00 00 00    	jne    80102ce3 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c18:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c1f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c21:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c28:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c2b:	e8 60 16 00 00       	call   80104290 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c30:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c35:	85 c0                	test   %eax,%eax
80102c37:	0f 8e 90 00 00 00    	jle    80102ccd <end_op+0xed>
80102c3d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c40:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c45:	01 d8                	add    %ebx,%eax
80102c47:	83 c0 01             	add    $0x1,%eax
80102c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c4e:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c53:	89 04 24             	mov    %eax,(%esp)
80102c56:	e8 75 d4 ff ff       	call   801000d0 <bread>
80102c5b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c5d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c64:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c67:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c6b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c70:	89 04 24             	mov    %eax,(%esp)
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c78:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c7f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c80:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c82:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c85:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c89:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c8c:	89 04 24             	mov    %eax,(%esp)
80102c8f:	e8 ec 16 00 00       	call   80104380 <memmove>
    bwrite(to);  // write the log
80102c94:	89 34 24             	mov    %esi,(%esp)
80102c97:	e8 04 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c9c:	89 3c 24             	mov    %edi,(%esp)
80102c9f:	e8 3c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ca4:	89 34 24             	mov    %esi,(%esp)
80102ca7:	e8 34 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cac:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102cb2:	7c 8c                	jl     80102c40 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cb4:	e8 a7 fd ff ff       	call   80102a60 <write_head>
    install_trans(); // Now install writes to home locations
80102cb9:	e8 02 fd ff ff       	call   801029c0 <install_trans>
    log.lh.n = 0;
80102cbe:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cc5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cc8:	e8 93 fd ff ff       	call   80102a60 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102ccd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cd4:	e8 c7 14 00 00       	call   801041a0 <acquire>
    log.committing = 0;
80102cd9:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102ce0:	00 00 00 
    wakeup(&log);
80102ce3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cea:	e8 01 11 00 00       	call   80103df0 <wakeup>
    release(&log.lock);
80102cef:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cf6:	e8 95 15 00 00       	call   80104290 <release>
  }
}
80102cfb:	83 c4 1c             	add    $0x1c,%esp
80102cfe:	5b                   	pop    %ebx
80102cff:	5e                   	pop    %esi
80102d00:	5f                   	pop    %edi
80102d01:	5d                   	pop    %ebp
80102d02:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d03:	c7 04 24 e4 75 10 80 	movl   $0x801075e4,(%esp)
80102d0a:	e8 51 d6 ff ff       	call   80100360 <panic>
80102d0f:	90                   	nop

80102d10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	53                   	push   %ebx
80102d14:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d17:	a1 c8 26 11 80       	mov    0x801126c8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d1f:	83 f8 1d             	cmp    $0x1d,%eax
80102d22:	0f 8f 98 00 00 00    	jg     80102dc0 <log_write+0xb0>
80102d28:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102d2e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d31:	39 d0                	cmp    %edx,%eax
80102d33:	0f 8d 87 00 00 00    	jge    80102dc0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d39:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d3e:	85 c0                	test   %eax,%eax
80102d40:	0f 8e 86 00 00 00    	jle    80102dcc <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d46:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d4d:	e8 4e 14 00 00       	call   801041a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d52:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d58:	83 fa 00             	cmp    $0x0,%edx
80102d5b:	7e 54                	jle    80102db1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d5d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d60:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d62:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d68:	75 0f                	jne    80102d79 <log_write+0x69>
80102d6a:	eb 3c                	jmp    80102da8 <log_write+0x98>
80102d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d70:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d77:	74 2f                	je     80102da8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d79:	83 c0 01             	add    $0x1,%eax
80102d7c:	39 d0                	cmp    %edx,%eax
80102d7e:	75 f0                	jne    80102d70 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d80:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d87:	83 c2 01             	add    $0x1,%edx
80102d8a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d90:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d93:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d9a:	83 c4 14             	add    $0x14,%esp
80102d9d:	5b                   	pop    %ebx
80102d9e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d9f:	e9 ec 14 00 00       	jmp    80104290 <release>
80102da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102da8:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102daf:	eb df                	jmp    80102d90 <log_write+0x80>
80102db1:	8b 43 08             	mov    0x8(%ebx),%eax
80102db4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102db9:	75 d5                	jne    80102d90 <log_write+0x80>
80102dbb:	eb ca                	jmp    80102d87 <log_write+0x77>
80102dbd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102dc0:	c7 04 24 f3 75 10 80 	movl   $0x801075f3,(%esp)
80102dc7:	e8 94 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102dcc:	c7 04 24 09 76 10 80 	movl   $0x80107609,(%esp)
80102dd3:	e8 88 d5 ff ff       	call   80100360 <panic>
80102dd8:	66 90                	xchg   %ax,%ax
80102dda:	66 90                	xchg   %ax,%ax
80102ddc:	66 90                	xchg   %ax,%ax
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
80102de4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102de7:	e8 f4 08 00 00       	call   801036e0 <cpuid>
80102dec:	89 c3                	mov    %eax,%ebx
80102dee:	e8 ed 08 00 00       	call   801036e0 <cpuid>
80102df3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102df7:	c7 04 24 24 76 10 80 	movl   $0x80107624,(%esp)
80102dfe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e02:	e8 49 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e07:	e8 c4 2b 00 00       	call   801059d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e0c:	e8 4f 08 00 00       	call   80103660 <mycpu>
80102e11:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e13:	b8 01 00 00 00       	mov    $0x1,%eax
80102e18:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e1f:	e8 9c 0b 00 00       	call   801039c0 <scheduler>
80102e24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e30 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e36:	e8 55 3c 00 00       	call   80106a90 <switchkvm>
  seginit();
80102e3b:	e8 90 3b 00 00       	call   801069d0 <seginit>
  lapicinit();
80102e40:	e8 8b f8 ff ff       	call   801026d0 <lapicinit>
  mpmain();
80102e45:	e8 96 ff ff ff       	call   80102de0 <mpmain>
80102e4a:	66 90                	xchg   %ax,%ax
80102e4c:	66 90                	xchg   %ax,%ax
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e54:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e59:	83 e4 f0             	and    $0xfffffff0,%esp
80102e5c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e5f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e66:	80 
80102e67:	c7 04 24 c8 57 11 80 	movl   $0x801157c8,(%esp)
80102e6e:	e8 cd f5 ff ff       	call   80102440 <kinit1>
  kvmalloc();      // kernel page table
80102e73:	e8 a8 40 00 00       	call   80106f20 <kvmalloc>
  mpinit();        // detect other processors
80102e78:	e8 73 01 00 00       	call   80102ff0 <mpinit>
80102e7d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e80:	e8 4b f8 ff ff       	call   801026d0 <lapicinit>
  seginit();       // segment descriptors
80102e85:	e8 46 3b 00 00       	call   801069d0 <seginit>
  picinit();       // disable pic
80102e8a:	e8 21 03 00 00       	call   801031b0 <picinit>
80102e8f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e90:	e8 cb f3 ff ff       	call   80102260 <ioapicinit>
  consoleinit();   // console hardware
80102e95:	e8 b6 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e9a:	e8 51 2e 00 00       	call   80105cf0 <uartinit>
80102e9f:	90                   	nop
  pinit();         // process table
80102ea0:	e8 9b 07 00 00       	call   80103640 <pinit>
  tvinit();        // trap vectors
80102ea5:	e8 86 2a 00 00       	call   80105930 <tvinit>
  binit();         // buffer cache
80102eaa:	e8 91 d1 ff ff       	call   80100040 <binit>
80102eaf:	90                   	nop
  fileinit();      // file table
80102eb0:	e8 9b de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102eb5:	e8 a6 f1 ff ff       	call   80102060 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102eba:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102ec1:	00 
80102ec2:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102ec9:	80 
80102eca:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102ed1:	e8 aa 14 00 00       	call   80104380 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ed6:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102edd:	00 00 00 
80102ee0:	05 80 27 11 80       	add    $0x80112780,%eax
80102ee5:	39 d8                	cmp    %ebx,%eax
80102ee7:	76 6a                	jbe    80102f53 <main+0x103>
80102ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ef0:	e8 6b 07 00 00       	call   80103660 <mycpu>
80102ef5:	39 d8                	cmp    %ebx,%eax
80102ef7:	74 41                	je     80102f3a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ef9:	e8 02 f6 ff ff       	call   80102500 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102efe:	c7 05 f8 6f 00 80 30 	movl   $0x80102e30,0x80006ff8
80102f05:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f08:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f0f:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f12:	05 00 10 00 00       	add    $0x1000,%eax
80102f17:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f1c:	0f b6 03             	movzbl (%ebx),%eax
80102f1f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f26:	00 
80102f27:	89 04 24             	mov    %eax,(%esp)
80102f2a:	e8 e1 f8 ff ff       	call   80102810 <lapicstartap>
80102f2f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f30:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f36:	85 c0                	test   %eax,%eax
80102f38:	74 f6                	je     80102f30 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f3a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f41:	00 00 00 
80102f44:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f4a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f4f:	39 c3                	cmp    %eax,%ebx
80102f51:	72 9d                	jb     80102ef0 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f53:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f5a:	8e 
80102f5b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f62:	e8 49 f5 ff ff       	call   801024b0 <kinit2>
  userinit();      // first user process
80102f67:	e8 c4 07 00 00       	call   80103730 <userinit>
  mpmain();        // finish this processor's setup
80102f6c:	e8 6f fe ff ff       	call   80102de0 <mpmain>
80102f71:	66 90                	xchg   %ax,%ax
80102f73:	66 90                	xchg   %ax,%ax
80102f75:	66 90                	xchg   %ax,%ax
80102f77:	66 90                	xchg   %ax,%ax
80102f79:	66 90                	xchg   %ax,%ax
80102f7b:	66 90                	xchg   %ax,%ax
80102f7d:	66 90                	xchg   %ax,%ax
80102f7f:	90                   	nop

80102f80 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f84:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f8a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f8b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f8e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f91:	39 de                	cmp    %ebx,%esi
80102f93:	73 3c                	jae    80102fd1 <mpsearch1+0x51>
80102f95:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f98:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f9f:	00 
80102fa0:	c7 44 24 04 38 76 10 	movl   $0x80107638,0x4(%esp)
80102fa7:	80 
80102fa8:	89 34 24             	mov    %esi,(%esp)
80102fab:	e8 80 13 00 00       	call   80104330 <memcmp>
80102fb0:	85 c0                	test   %eax,%eax
80102fb2:	75 16                	jne    80102fca <mpsearch1+0x4a>
80102fb4:	31 c9                	xor    %ecx,%ecx
80102fb6:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fb8:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fbc:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102fbf:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fc1:	83 fa 10             	cmp    $0x10,%edx
80102fc4:	75 f2                	jne    80102fb8 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fc6:	84 c9                	test   %cl,%cl
80102fc8:	74 10                	je     80102fda <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fca:	83 c6 10             	add    $0x10,%esi
80102fcd:	39 f3                	cmp    %esi,%ebx
80102fcf:	77 c7                	ja     80102f98 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fd1:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fd4:	31 c0                	xor    %eax,%eax
}
80102fd6:	5b                   	pop    %ebx
80102fd7:	5e                   	pop    %esi
80102fd8:	5d                   	pop    %ebp
80102fd9:	c3                   	ret    
80102fda:	83 c4 10             	add    $0x10,%esp
80102fdd:	89 f0                	mov    %esi,%eax
80102fdf:	5b                   	pop    %ebx
80102fe0:	5e                   	pop    %esi
80102fe1:	5d                   	pop    %ebp
80102fe2:	c3                   	ret    
80102fe3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ff0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	57                   	push   %edi
80102ff4:	56                   	push   %esi
80102ff5:	53                   	push   %ebx
80102ff6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102ff9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103000:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103007:	c1 e0 08             	shl    $0x8,%eax
8010300a:	09 d0                	or     %edx,%eax
8010300c:	c1 e0 04             	shl    $0x4,%eax
8010300f:	85 c0                	test   %eax,%eax
80103011:	75 1b                	jne    8010302e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103013:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010301a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103021:	c1 e0 08             	shl    $0x8,%eax
80103024:	09 d0                	or     %edx,%eax
80103026:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103029:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010302e:	ba 00 04 00 00       	mov    $0x400,%edx
80103033:	e8 48 ff ff ff       	call   80102f80 <mpsearch1>
80103038:	85 c0                	test   %eax,%eax
8010303a:	89 c7                	mov    %eax,%edi
8010303c:	0f 84 22 01 00 00    	je     80103164 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103042:	8b 77 04             	mov    0x4(%edi),%esi
80103045:	85 f6                	test   %esi,%esi
80103047:	0f 84 30 01 00 00    	je     8010317d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010304d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103053:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010305a:	00 
8010305b:	c7 44 24 04 3d 76 10 	movl   $0x8010763d,0x4(%esp)
80103062:	80 
80103063:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103066:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103069:	e8 c2 12 00 00       	call   80104330 <memcmp>
8010306e:	85 c0                	test   %eax,%eax
80103070:	0f 85 07 01 00 00    	jne    8010317d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103076:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010307d:	3c 04                	cmp    $0x4,%al
8010307f:	0f 85 0b 01 00 00    	jne    80103190 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103085:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010308c:	85 c0                	test   %eax,%eax
8010308e:	74 21                	je     801030b1 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103090:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103092:	31 d2                	xor    %edx,%edx
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103098:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010309f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a0:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801030a3:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a5:	39 d0                	cmp    %edx,%eax
801030a7:	7f ef                	jg     80103098 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030a9:	84 c9                	test   %cl,%cl
801030ab:	0f 85 cc 00 00 00    	jne    8010317d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030b4:	85 c0                	test   %eax,%eax
801030b6:	0f 84 c1 00 00 00    	je     8010317d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030bc:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030c2:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
801030c7:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030cc:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801030d3:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801030d9:	03 55 e4             	add    -0x1c(%ebp),%edx
801030dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030e0:	39 c2                	cmp    %eax,%edx
801030e2:	76 1b                	jbe    801030ff <mpinit+0x10f>
801030e4:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
801030e7:	80 f9 04             	cmp    $0x4,%cl
801030ea:	77 74                	ja     80103160 <mpinit+0x170>
801030ec:	ff 24 8d 7c 76 10 80 	jmp    *-0x7fef8984(,%ecx,4)
801030f3:	90                   	nop
801030f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030f8:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030fb:	39 c2                	cmp    %eax,%edx
801030fd:	77 e5                	ja     801030e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030ff:	85 db                	test   %ebx,%ebx
80103101:	0f 84 93 00 00 00    	je     8010319a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103107:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010310b:	74 12                	je     8010311f <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010310d:	ba 22 00 00 00       	mov    $0x22,%edx
80103112:	b8 70 00 00 00       	mov    $0x70,%eax
80103117:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103118:	b2 23                	mov    $0x23,%dl
8010311a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010311b:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010311e:	ee                   	out    %al,(%dx)
  }
}
8010311f:	83 c4 1c             	add    $0x1c,%esp
80103122:	5b                   	pop    %ebx
80103123:	5e                   	pop    %esi
80103124:	5f                   	pop    %edi
80103125:	5d                   	pop    %ebp
80103126:	c3                   	ret    
80103127:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103128:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010312e:	83 fe 07             	cmp    $0x7,%esi
80103131:	7f 17                	jg     8010314a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103133:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103137:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
8010313d:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103144:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010314a:	83 c0 14             	add    $0x14,%eax
      continue;
8010314d:	eb 91                	jmp    801030e0 <mpinit+0xf0>
8010314f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103150:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103154:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103157:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
8010315d:	eb 81                	jmp    801030e0 <mpinit+0xf0>
8010315f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103160:	31 db                	xor    %ebx,%ebx
80103162:	eb 83                	jmp    801030e7 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103164:	ba 00 00 01 00       	mov    $0x10000,%edx
80103169:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010316e:	e8 0d fe ff ff       	call   80102f80 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103173:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103175:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103177:	0f 85 c5 fe ff ff    	jne    80103042 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010317d:	c7 04 24 42 76 10 80 	movl   $0x80107642,(%esp)
80103184:	e8 d7 d1 ff ff       	call   80100360 <panic>
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103190:	3c 01                	cmp    $0x1,%al
80103192:	0f 84 ed fe ff ff    	je     80103085 <mpinit+0x95>
80103198:	eb e3                	jmp    8010317d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
8010319a:	c7 04 24 5c 76 10 80 	movl   $0x8010765c,(%esp)
801031a1:	e8 ba d1 ff ff       	call   80100360 <panic>
801031a6:	66 90                	xchg   %ax,%ax
801031a8:	66 90                	xchg   %ax,%ax
801031aa:	66 90                	xchg   %ax,%ax
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031b0:	55                   	push   %ebp
801031b1:	ba 21 00 00 00       	mov    $0x21,%edx
801031b6:	89 e5                	mov    %esp,%ebp
801031b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031bd:	ee                   	out    %al,(%dx)
801031be:	b2 a1                	mov    $0xa1,%dl
801031c0:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031c1:	5d                   	pop    %ebp
801031c2:	c3                   	ret    
801031c3:	66 90                	xchg   %ax,%ax
801031c5:	66 90                	xchg   %ax,%ax
801031c7:	66 90                	xchg   %ax,%ax
801031c9:	66 90                	xchg   %ax,%ax
801031cb:	66 90                	xchg   %ax,%ax
801031cd:	66 90                	xchg   %ax,%ax
801031cf:	90                   	nop

801031d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
801031d5:	53                   	push   %ebx
801031d6:	83 ec 1c             	sub    $0x1c,%esp
801031d9:	8b 75 08             	mov    0x8(%ebp),%esi
801031dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031eb:	e8 80 db ff ff       	call   80100d70 <filealloc>
801031f0:	85 c0                	test   %eax,%eax
801031f2:	89 06                	mov    %eax,(%esi)
801031f4:	0f 84 a4 00 00 00    	je     8010329e <pipealloc+0xce>
801031fa:	e8 71 db ff ff       	call   80100d70 <filealloc>
801031ff:	85 c0                	test   %eax,%eax
80103201:	89 03                	mov    %eax,(%ebx)
80103203:	0f 84 87 00 00 00    	je     80103290 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103209:	e8 f2 f2 ff ff       	call   80102500 <kalloc>
8010320e:	85 c0                	test   %eax,%eax
80103210:	89 c7                	mov    %eax,%edi
80103212:	74 7c                	je     80103290 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103214:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010321b:	00 00 00 
  p->writeopen = 1;
8010321e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103225:	00 00 00 
  p->nwrite = 0;
80103228:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010322f:	00 00 00 
  p->nread = 0;
80103232:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103239:	00 00 00 
  initlock(&p->lock, "pipe");
8010323c:	89 04 24             	mov    %eax,(%esp)
8010323f:	c7 44 24 04 90 76 10 	movl   $0x80107690,0x4(%esp)
80103246:	80 
80103247:	e8 64 0e 00 00       	call   801040b0 <initlock>
  (*f0)->type = FD_PIPE;
8010324c:	8b 06                	mov    (%esi),%eax
8010324e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103254:	8b 06                	mov    (%esi),%eax
80103256:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010325a:	8b 06                	mov    (%esi),%eax
8010325c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103260:	8b 06                	mov    (%esi),%eax
80103262:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103265:	8b 03                	mov    (%ebx),%eax
80103267:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010326d:	8b 03                	mov    (%ebx),%eax
8010326f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103273:	8b 03                	mov    (%ebx),%eax
80103275:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103279:	8b 03                	mov    (%ebx),%eax
  return 0;
8010327b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010327d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103280:	83 c4 1c             	add    $0x1c,%esp
80103283:	89 d8                	mov    %ebx,%eax
80103285:	5b                   	pop    %ebx
80103286:	5e                   	pop    %esi
80103287:	5f                   	pop    %edi
80103288:	5d                   	pop    %ebp
80103289:	c3                   	ret    
8010328a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103290:	8b 06                	mov    (%esi),%eax
80103292:	85 c0                	test   %eax,%eax
80103294:	74 08                	je     8010329e <pipealloc+0xce>
    fileclose(*f0);
80103296:	89 04 24             	mov    %eax,(%esp)
80103299:	e8 92 db ff ff       	call   80100e30 <fileclose>
  if(*f1)
8010329e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
801032a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
801032a5:	85 c0                	test   %eax,%eax
801032a7:	74 d7                	je     80103280 <pipealloc+0xb0>
    fileclose(*f1);
801032a9:	89 04 24             	mov    %eax,(%esp)
801032ac:	e8 7f db ff ff       	call   80100e30 <fileclose>
  return -1;
}
801032b1:	83 c4 1c             	add    $0x1c,%esp
801032b4:	89 d8                	mov    %ebx,%eax
801032b6:	5b                   	pop    %ebx
801032b7:	5e                   	pop    %esi
801032b8:	5f                   	pop    %edi
801032b9:	5d                   	pop    %ebp
801032ba:	c3                   	ret    
801032bb:	90                   	nop
801032bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	56                   	push   %esi
801032c4:	53                   	push   %ebx
801032c5:	83 ec 10             	sub    $0x10,%esp
801032c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032ce:	89 1c 24             	mov    %ebx,(%esp)
801032d1:	e8 ca 0e 00 00       	call   801041a0 <acquire>
  if(writable){
801032d6:	85 f6                	test   %esi,%esi
801032d8:	74 3e                	je     80103318 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801032da:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801032e0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032e7:	00 00 00 
    wakeup(&p->nread);
801032ea:	89 04 24             	mov    %eax,(%esp)
801032ed:	e8 fe 0a 00 00       	call   80103df0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032f2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032f8:	85 d2                	test   %edx,%edx
801032fa:	75 0a                	jne    80103306 <pipeclose+0x46>
801032fc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103302:	85 c0                	test   %eax,%eax
80103304:	74 32                	je     80103338 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103306:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103309:	83 c4 10             	add    $0x10,%esp
8010330c:	5b                   	pop    %ebx
8010330d:	5e                   	pop    %esi
8010330e:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010330f:	e9 7c 0f 00 00       	jmp    80104290 <release>
80103314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103318:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
8010331e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103325:	00 00 00 
    wakeup(&p->nwrite);
80103328:	89 04 24             	mov    %eax,(%esp)
8010332b:	e8 c0 0a 00 00       	call   80103df0 <wakeup>
80103330:	eb c0                	jmp    801032f2 <pipeclose+0x32>
80103332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103338:	89 1c 24             	mov    %ebx,(%esp)
8010333b:	e8 50 0f 00 00       	call   80104290 <release>
    kfree((char*)p);
80103340:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103343:	83 c4 10             	add    $0x10,%esp
80103346:	5b                   	pop    %ebx
80103347:	5e                   	pop    %esi
80103348:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103349:	e9 02 f0 ff ff       	jmp    80102350 <kfree>
8010334e:	66 90                	xchg   %ax,%ax

80103350 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	57                   	push   %edi
80103354:	56                   	push   %esi
80103355:	53                   	push   %ebx
80103356:	83 ec 1c             	sub    $0x1c,%esp
80103359:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010335c:	89 1c 24             	mov    %ebx,(%esp)
8010335f:	e8 3c 0e 00 00       	call   801041a0 <acquire>
  for(i = 0; i < n; i++){
80103364:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103367:	85 c9                	test   %ecx,%ecx
80103369:	0f 8e b2 00 00 00    	jle    80103421 <pipewrite+0xd1>
8010336f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103372:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103378:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010337e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103384:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103387:	03 4d 10             	add    0x10(%ebp),%ecx
8010338a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010338d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103393:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103399:	39 c8                	cmp    %ecx,%eax
8010339b:	74 38                	je     801033d5 <pipewrite+0x85>
8010339d:	eb 55                	jmp    801033f4 <pipewrite+0xa4>
8010339f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
801033a0:	e8 5b 03 00 00       	call   80103700 <myproc>
801033a5:	8b 40 24             	mov    0x24(%eax),%eax
801033a8:	85 c0                	test   %eax,%eax
801033aa:	75 33                	jne    801033df <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033ac:	89 3c 24             	mov    %edi,(%esp)
801033af:	e8 3c 0a 00 00       	call   80103df0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801033b8:	89 34 24             	mov    %esi,(%esp)
801033bb:	e8 a0 08 00 00       	call   80103c60 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033c0:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033c6:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033cc:	05 00 02 00 00       	add    $0x200,%eax
801033d1:	39 c2                	cmp    %eax,%edx
801033d3:	75 23                	jne    801033f8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
801033d5:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033db:	85 d2                	test   %edx,%edx
801033dd:	75 c1                	jne    801033a0 <pipewrite+0x50>
        release(&p->lock);
801033df:	89 1c 24             	mov    %ebx,(%esp)
801033e2:	e8 a9 0e 00 00       	call   80104290 <release>
        return -1;
801033e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033ec:	83 c4 1c             	add    $0x1c,%esp
801033ef:	5b                   	pop    %ebx
801033f0:	5e                   	pop    %esi
801033f1:	5f                   	pop    %edi
801033f2:	5d                   	pop    %ebp
801033f3:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033f4:	89 c2                	mov    %eax,%edx
801033f6:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033f8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033fb:	8d 42 01             	lea    0x1(%edx),%eax
801033fe:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103404:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010340a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010340e:	0f b6 09             	movzbl (%ecx),%ecx
80103411:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103415:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103418:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
8010341b:	0f 85 6c ff ff ff    	jne    8010338d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103421:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103427:	89 04 24             	mov    %eax,(%esp)
8010342a:	e8 c1 09 00 00       	call   80103df0 <wakeup>
  release(&p->lock);
8010342f:	89 1c 24             	mov    %ebx,(%esp)
80103432:	e8 59 0e 00 00       	call   80104290 <release>
  return n;
80103437:	8b 45 10             	mov    0x10(%ebp),%eax
8010343a:	eb b0                	jmp    801033ec <pipewrite+0x9c>
8010343c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103440 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 1c             	sub    $0x1c,%esp
80103449:	8b 75 08             	mov    0x8(%ebp),%esi
8010344c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010344f:	89 34 24             	mov    %esi,(%esp)
80103452:	e8 49 0d 00 00       	call   801041a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103457:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010345d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103463:	75 5b                	jne    801034c0 <piperead+0x80>
80103465:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010346b:	85 db                	test   %ebx,%ebx
8010346d:	74 51                	je     801034c0 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010346f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103475:	eb 25                	jmp    8010349c <piperead+0x5c>
80103477:	90                   	nop
80103478:	89 74 24 04          	mov    %esi,0x4(%esp)
8010347c:	89 1c 24             	mov    %ebx,(%esp)
8010347f:	e8 dc 07 00 00       	call   80103c60 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103484:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010348a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103490:	75 2e                	jne    801034c0 <piperead+0x80>
80103492:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103498:	85 d2                	test   %edx,%edx
8010349a:	74 24                	je     801034c0 <piperead+0x80>
    if(myproc()->killed){
8010349c:	e8 5f 02 00 00       	call   80103700 <myproc>
801034a1:	8b 48 24             	mov    0x24(%eax),%ecx
801034a4:	85 c9                	test   %ecx,%ecx
801034a6:	74 d0                	je     80103478 <piperead+0x38>
      release(&p->lock);
801034a8:	89 34 24             	mov    %esi,(%esp)
801034ab:	e8 e0 0d 00 00       	call   80104290 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034b0:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801034b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034b8:	5b                   	pop    %ebx
801034b9:	5e                   	pop    %esi
801034ba:	5f                   	pop    %edi
801034bb:	5d                   	pop    %ebp
801034bc:	c3                   	ret    
801034bd:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034c0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801034c3:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034c5:	85 d2                	test   %edx,%edx
801034c7:	7f 2b                	jg     801034f4 <piperead+0xb4>
801034c9:	eb 31                	jmp    801034fc <piperead+0xbc>
801034cb:	90                   	nop
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801034d0:	8d 48 01             	lea    0x1(%eax),%ecx
801034d3:	25 ff 01 00 00       	and    $0x1ff,%eax
801034d8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801034de:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801034e3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034e6:	83 c3 01             	add    $0x1,%ebx
801034e9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801034ec:	74 0e                	je     801034fc <piperead+0xbc>
    if(p->nread == p->nwrite)
801034ee:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034f4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034fa:	75 d4                	jne    801034d0 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034fc:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103502:	89 04 24             	mov    %eax,(%esp)
80103505:	e8 e6 08 00 00       	call   80103df0 <wakeup>
  release(&p->lock);
8010350a:	89 34 24             	mov    %esi,(%esp)
8010350d:	e8 7e 0d 00 00       	call   80104290 <release>
  return i;
}
80103512:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103515:	89 d8                	mov    %ebx,%eax
}
80103517:	5b                   	pop    %ebx
80103518:	5e                   	pop    %esi
80103519:	5f                   	pop    %edi
8010351a:	5d                   	pop    %ebp
8010351b:	c3                   	ret    
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103524:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103529:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010352c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103533:	e8 68 0c 00 00       	call   801041a0 <acquire>
80103538:	eb 11                	jmp    8010354b <allocproc+0x2b>
8010353a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103540:	83 c3 7c             	add    $0x7c,%ebx
80103543:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103549:	74 7d                	je     801035c8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010354b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010354e:	85 c0                	test   %eax,%eax
80103550:	75 ee                	jne    80103540 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103552:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103557:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010355e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103565:	8d 50 01             	lea    0x1(%eax),%edx
80103568:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010356e:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103571:	e8 1a 0d 00 00       	call   80104290 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103576:	e8 85 ef ff ff       	call   80102500 <kalloc>
8010357b:	85 c0                	test   %eax,%eax
8010357d:	89 43 08             	mov    %eax,0x8(%ebx)
80103580:	74 5a                	je     801035dc <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103582:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103588:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010358d:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103590:	c7 40 14 25 59 10 80 	movl   $0x80105925,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103597:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010359e:	00 
8010359f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801035a6:	00 
801035a7:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801035aa:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801035ad:	e8 2e 0d 00 00       	call   801042e0 <memset>
  p->context->eip = (uint)forkret;
801035b2:	8b 43 1c             	mov    0x1c(%ebx),%eax
801035b5:	c7 40 10 f0 35 10 80 	movl   $0x801035f0,0x10(%eax)

  return p;
801035bc:	89 d8                	mov    %ebx,%eax
}
801035be:	83 c4 14             	add    $0x14,%esp
801035c1:	5b                   	pop    %ebx
801035c2:	5d                   	pop    %ebp
801035c3:	c3                   	ret    
801035c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801035c8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035cf:	e8 bc 0c 00 00       	call   80104290 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801035d4:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
801035d7:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801035d9:	5b                   	pop    %ebx
801035da:	5d                   	pop    %ebp
801035db:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801035dc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035e3:	eb d9                	jmp    801035be <allocproc+0x9e>
801035e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035f6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035fd:	e8 8e 0c 00 00       	call   80104290 <release>

  if (first) {
80103602:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103607:	85 c0                	test   %eax,%eax
80103609:	75 05                	jne    80103610 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010360b:	c9                   	leave  
8010360c:	c3                   	ret    
8010360d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103610:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103617:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010361e:	00 00 00 
    iinit(ROOTDEV);
80103621:	e8 5a de ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103626:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010362d:	e8 9e f4 ff ff       	call   80102ad0 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103632:	c9                   	leave  
80103633:	c3                   	ret    
80103634:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010363a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103640 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103646:	c7 44 24 04 95 76 10 	movl   $0x80107695,0x4(%esp)
8010364d:	80 
8010364e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103655:	e8 56 0a 00 00       	call   801040b0 <initlock>
}
8010365a:	c9                   	leave  
8010365b:	c3                   	ret    
8010365c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103660 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	56                   	push   %esi
80103664:	53                   	push   %ebx
80103665:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103668:	9c                   	pushf  
80103669:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010366a:	f6 c4 02             	test   $0x2,%ah
8010366d:	75 57                	jne    801036c6 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010366f:	e8 4c f1 ff ff       	call   801027c0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103674:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010367a:	85 f6                	test   %esi,%esi
8010367c:	7e 3c                	jle    801036ba <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010367e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103685:	39 c2                	cmp    %eax,%edx
80103687:	74 2d                	je     801036b6 <mycpu+0x56>
80103689:	b9 30 28 11 80       	mov    $0x80112830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010368e:	31 d2                	xor    %edx,%edx
80103690:	83 c2 01             	add    $0x1,%edx
80103693:	39 f2                	cmp    %esi,%edx
80103695:	74 23                	je     801036ba <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103697:	0f b6 19             	movzbl (%ecx),%ebx
8010369a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801036a0:	39 c3                	cmp    %eax,%ebx
801036a2:	75 ec                	jne    80103690 <mycpu+0x30>
      return &cpus[i];
801036a4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	5b                   	pop    %ebx
801036ae:	5e                   	pop    %esi
801036af:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
801036b0:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
801036b5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036b6:	31 d2                	xor    %edx,%edx
801036b8:	eb ea                	jmp    801036a4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801036ba:	c7 04 24 9c 76 10 80 	movl   $0x8010769c,(%esp)
801036c1:	e8 9a cc ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801036c6:	c7 04 24 78 77 10 80 	movl   $0x80107778,(%esp)
801036cd:	e8 8e cc ff ff       	call   80100360 <panic>
801036d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036e0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036e6:	e8 75 ff ff ff       	call   80103660 <mycpu>
}
801036eb:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801036ec:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036f1:	c1 f8 04             	sar    $0x4,%eax
801036f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036fa:	c3                   	ret    
801036fb:	90                   	nop
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103700 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	53                   	push   %ebx
80103704:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103707:	e8 54 0a 00 00       	call   80104160 <pushcli>
  c = mycpu();
8010370c:	e8 4f ff ff ff       	call   80103660 <mycpu>
  p = c->proc;
80103711:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103717:	e8 04 0b 00 00       	call   80104220 <popcli>
  return p;
}
8010371c:	83 c4 04             	add    $0x4,%esp
8010371f:	89 d8                	mov    %ebx,%eax
80103721:	5b                   	pop    %ebx
80103722:	5d                   	pop    %ebp
80103723:	c3                   	ret    
80103724:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010372a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103730 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	53                   	push   %ebx
80103734:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103737:	e8 e4 fd ff ff       	call   80103520 <allocproc>
8010373c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010373e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103743:	e8 48 37 00 00       	call   80106e90 <setupkvm>
80103748:	85 c0                	test   %eax,%eax
8010374a:	89 43 04             	mov    %eax,0x4(%ebx)
8010374d:	0f 84 d4 00 00 00    	je     80103827 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103753:	89 04 24             	mov    %eax,(%esp)
80103756:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010375d:	00 
8010375e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103765:	80 
80103766:	e8 55 34 00 00       	call   80106bc0 <inituvm>
  p->sz = PGSIZE;
8010376b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103771:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103778:	00 
80103779:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103780:	00 
80103781:	8b 43 18             	mov    0x18(%ebx),%eax
80103784:	89 04 24             	mov    %eax,(%esp)
80103787:	e8 54 0b 00 00       	call   801042e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010378c:	8b 43 18             	mov    0x18(%ebx),%eax
8010378f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103794:	b9 23 00 00 00       	mov    $0x23,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103799:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010379d:	8b 43 18             	mov    0x18(%ebx),%eax
801037a0:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801037a4:	8b 43 18             	mov    0x18(%ebx),%eax
801037a7:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037ab:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801037af:	8b 43 18             	mov    0x18(%ebx),%eax
801037b2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037b6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801037ba:	8b 43 18             	mov    0x18(%ebx),%eax
801037bd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037c4:	8b 43 18             	mov    0x18(%ebx),%eax
801037c7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037ce:	8b 43 18             	mov    0x18(%ebx),%eax
801037d1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801037d8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801037db:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037e2:	00 
801037e3:	c7 44 24 04 c5 76 10 	movl   $0x801076c5,0x4(%esp)
801037ea:	80 
801037eb:	89 04 24             	mov    %eax,(%esp)
801037ee:	e8 cd 0c 00 00       	call   801044c0 <safestrcpy>
  p->cwd = namei("/");
801037f3:	c7 04 24 ce 76 10 80 	movl   $0x801076ce,(%esp)
801037fa:	e8 61 e7 ff ff       	call   80101f60 <namei>
801037ff:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103802:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103809:	e8 92 09 00 00       	call   801041a0 <acquire>

  p->state = RUNNABLE;
8010380e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103815:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010381c:	e8 6f 0a 00 00       	call   80104290 <release>
}
80103821:	83 c4 14             	add    $0x14,%esp
80103824:	5b                   	pop    %ebx
80103825:	5d                   	pop    %ebp
80103826:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103827:	c7 04 24 ac 76 10 80 	movl   $0x801076ac,(%esp)
8010382e:	e8 2d cb ff ff       	call   80100360 <panic>
80103833:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103840 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	56                   	push   %esi
80103844:	53                   	push   %ebx
80103845:	83 ec 10             	sub    $0x10,%esp
80103848:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
8010384b:	e8 b0 fe ff ff       	call   80103700 <myproc>

  sz = curproc->sz;
  if(n > 0){
80103850:	83 fe 00             	cmp    $0x0,%esi
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
80103853:	89 c3                	mov    %eax,%ebx

  sz = curproc->sz;
80103855:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103857:	7e 2f                	jle    80103888 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103859:	01 c6                	add    %eax,%esi
8010385b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010385f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103863:	8b 43 04             	mov    0x4(%ebx),%eax
80103866:	89 04 24             	mov    %eax,(%esp)
80103869:	e8 92 34 00 00       	call   80106d00 <allocuvm>
8010386e:	85 c0                	test   %eax,%eax
80103870:	74 36                	je     801038a8 <growproc+0x68>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103872:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103874:	89 1c 24             	mov    %ebx,(%esp)
80103877:	e8 34 32 00 00       	call   80106ab0 <switchuvm>
  return 0;
8010387c:	31 c0                	xor    %eax,%eax
}
8010387e:	83 c4 10             	add    $0x10,%esp
80103881:	5b                   	pop    %ebx
80103882:	5e                   	pop    %esi
80103883:	5d                   	pop    %ebp
80103884:	c3                   	ret    
80103885:	8d 76 00             	lea    0x0(%esi),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103888:	74 e8                	je     80103872 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010388a:	01 c6                	add    %eax,%esi
8010388c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103890:	89 44 24 04          	mov    %eax,0x4(%esp)
80103894:	8b 43 04             	mov    0x4(%ebx),%eax
80103897:	89 04 24             	mov    %eax,(%esp)
8010389a:	e8 51 35 00 00       	call   80106df0 <deallocuvm>
8010389f:	85 c0                	test   %eax,%eax
801038a1:	75 cf                	jne    80103872 <growproc+0x32>
801038a3:	90                   	nop
801038a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
801038a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038ad:	eb cf                	jmp    8010387e <growproc+0x3e>
801038af:	90                   	nop

801038b0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	57                   	push   %edi
801038b4:	56                   	push   %esi
801038b5:	53                   	push   %ebx
801038b6:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
801038b9:	e8 42 fe ff ff       	call   80103700 <myproc>
801038be:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
801038c0:	e8 5b fc ff ff       	call   80103520 <allocproc>
801038c5:	85 c0                	test   %eax,%eax
801038c7:	89 c7                	mov    %eax,%edi
801038c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038cc:	0f 84 bc 00 00 00    	je     8010398e <fork+0xde>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038d2:	8b 03                	mov    (%ebx),%eax
801038d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801038d8:	8b 43 04             	mov    0x4(%ebx),%eax
801038db:	89 04 24             	mov    %eax,(%esp)
801038de:	e8 8d 36 00 00       	call   80106f70 <copyuvm>
801038e3:	85 c0                	test   %eax,%eax
801038e5:	89 47 04             	mov    %eax,0x4(%edi)
801038e8:	0f 84 a7 00 00 00    	je     80103995 <fork+0xe5>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801038ee:	8b 03                	mov    (%ebx),%eax
801038f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038f3:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
801038f5:	8b 79 18             	mov    0x18(%ecx),%edi
801038f8:	89 c8                	mov    %ecx,%eax
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
801038fa:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801038fd:	8b 73 18             	mov    0x18(%ebx),%esi
80103900:	b9 13 00 00 00       	mov    $0x13,%ecx
80103905:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103907:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103909:	8b 40 18             	mov    0x18(%eax),%eax
8010390c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103913:	90                   	nop
80103914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103918:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010391c:	85 c0                	test   %eax,%eax
8010391e:	74 0f                	je     8010392f <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103920:	89 04 24             	mov    %eax,(%esp)
80103923:	e8 b8 d4 ff ff       	call   80100de0 <filedup>
80103928:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010392b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010392f:	83 c6 01             	add    $0x1,%esi
80103932:	83 fe 10             	cmp    $0x10,%esi
80103935:	75 e1                	jne    80103918 <fork+0x68>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103937:	8b 43 68             	mov    0x68(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010393a:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010393d:	89 04 24             	mov    %eax,(%esp)
80103940:	e8 4b dd ff ff       	call   80101690 <idup>
80103945:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103948:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010394b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010394e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103952:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103959:	00 
8010395a:	89 04 24             	mov    %eax,(%esp)
8010395d:	e8 5e 0b 00 00       	call   801044c0 <safestrcpy>

  pid = np->pid;
80103962:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103965:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010396c:	e8 2f 08 00 00       	call   801041a0 <acquire>

  np->state = RUNNABLE;
80103971:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103978:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010397f:	e8 0c 09 00 00       	call   80104290 <release>

  return pid;
80103984:	89 d8                	mov    %ebx,%eax
}
80103986:	83 c4 1c             	add    $0x1c,%esp
80103989:	5b                   	pop    %ebx
8010398a:	5e                   	pop    %esi
8010398b:	5f                   	pop    %edi
8010398c:	5d                   	pop    %ebp
8010398d:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
8010398e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103993:	eb f1                	jmp    80103986 <fork+0xd6>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103995:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103998:	8b 47 08             	mov    0x8(%edi),%eax
8010399b:	89 04 24             	mov    %eax,(%esp)
8010399e:	e8 ad e9 ff ff       	call   80102350 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
801039a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
801039a8:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
801039af:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
801039b6:	eb ce                	jmp    80103986 <fork+0xd6>
801039b8:	90                   	nop
801039b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039c0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	57                   	push   %edi
801039c4:	56                   	push   %esi
801039c5:	53                   	push   %ebx
801039c6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801039c9:	e8 92 fc ff ff       	call   80103660 <mycpu>
801039ce:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801039d0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039d7:	00 00 00 
801039da:	8d 78 04             	lea    0x4(%eax),%edi
801039dd:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
801039e0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801039e1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039e8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801039ed:	e8 ae 07 00 00       	call   801041a0 <acquire>
801039f2:	eb 0f                	jmp    80103a03 <scheduler+0x43>
801039f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039f8:	83 c3 7c             	add    $0x7c,%ebx
801039fb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103a01:	74 45                	je     80103a48 <scheduler+0x88>
      if(p->state != RUNNABLE)
80103a03:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a07:	75 ef                	jne    801039f8 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103a09:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a0f:	89 1c 24             	mov    %ebx,(%esp)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a12:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a15:	e8 96 30 00 00       	call   80106ab0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a1a:	8b 43 a0             	mov    -0x60(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a1d:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
80103a24:	89 3c 24             	mov    %edi,(%esp)
80103a27:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a2b:	e8 eb 0a 00 00       	call   8010451b <swtch>
      switchkvm();
80103a30:	e8 5b 30 00 00       	call   80106a90 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a35:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a3b:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a42:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a45:	75 bc                	jne    80103a03 <scheduler+0x43>
80103a47:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103a48:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a4f:	e8 3c 08 00 00       	call   80104290 <release>

  }
80103a54:	eb 8a                	jmp    801039e0 <scheduler+0x20>
80103a56:	8d 76 00             	lea    0x0(%esi),%esi
80103a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a60 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	56                   	push   %esi
80103a64:	53                   	push   %ebx
80103a65:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103a68:	e8 93 fc ff ff       	call   80103700 <myproc>

  if(!holding(&ptable.lock))
80103a6d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103a74:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103a76:	e8 b5 06 00 00       	call   80104130 <holding>
80103a7b:	85 c0                	test   %eax,%eax
80103a7d:	74 4f                	je     80103ace <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103a7f:	e8 dc fb ff ff       	call   80103660 <mycpu>
80103a84:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a8b:	75 65                	jne    80103af2 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103a8d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a91:	74 53                	je     80103ae6 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a93:	9c                   	pushf  
80103a94:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103a95:	f6 c4 02             	test   $0x2,%ah
80103a98:	75 40                	jne    80103ada <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103a9a:	e8 c1 fb ff ff       	call   80103660 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a9f:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103aa2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103aa8:	e8 b3 fb ff ff       	call   80103660 <mycpu>
80103aad:	8b 40 04             	mov    0x4(%eax),%eax
80103ab0:	89 1c 24             	mov    %ebx,(%esp)
80103ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ab7:	e8 5f 0a 00 00       	call   8010451b <swtch>
  mycpu()->intena = intena;
80103abc:	e8 9f fb ff ff       	call   80103660 <mycpu>
80103ac1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ac7:	83 c4 10             	add    $0x10,%esp
80103aca:	5b                   	pop    %ebx
80103acb:	5e                   	pop    %esi
80103acc:	5d                   	pop    %ebp
80103acd:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103ace:	c7 04 24 d0 76 10 80 	movl   $0x801076d0,(%esp)
80103ad5:	e8 86 c8 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103ada:	c7 04 24 fc 76 10 80 	movl   $0x801076fc,(%esp)
80103ae1:	e8 7a c8 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103ae6:	c7 04 24 ee 76 10 80 	movl   $0x801076ee,(%esp)
80103aed:	e8 6e c8 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103af2:	c7 04 24 e2 76 10 80 	movl   $0x801076e2,(%esp)
80103af9:	e8 62 c8 ff ff       	call   80100360 <panic>
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b04:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b06:	53                   	push   %ebx
80103b07:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b0a:	e8 f1 fb ff ff       	call   80103700 <myproc>
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b0f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103b15:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b17:	0f 84 ea 00 00 00    	je     80103c07 <exit+0x107>
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103b20:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b24:	85 c0                	test   %eax,%eax
80103b26:	74 10                	je     80103b38 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b28:	89 04 24             	mov    %eax,(%esp)
80103b2b:	e8 00 d3 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103b30:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b37:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103b38:	83 c6 01             	add    $0x1,%esi
80103b3b:	83 fe 10             	cmp    $0x10,%esi
80103b3e:	75 e0                	jne    80103b20 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103b40:	e8 2b f0 ff ff       	call   80102b70 <begin_op>
  iput(curproc->cwd);
80103b45:	8b 43 68             	mov    0x68(%ebx),%eax
80103b48:	89 04 24             	mov    %eax,(%esp)
80103b4b:	e8 e0 dc ff ff       	call   80101830 <iput>
  end_op();
80103b50:	e8 8b f0 ff ff       	call   80102be0 <end_op>
  curproc->cwd = 0;
80103b55:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103b5c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b63:	e8 38 06 00 00       	call   801041a0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103b68:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b6b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b70:	eb 11                	jmp    80103b83 <exit+0x83>
80103b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b78:	83 c2 7c             	add    $0x7c,%edx
80103b7b:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103b81:	74 1d                	je     80103ba0 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103b83:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b87:	75 ef                	jne    80103b78 <exit+0x78>
80103b89:	3b 42 20             	cmp    0x20(%edx),%eax
80103b8c:	75 ea                	jne    80103b78 <exit+0x78>
      p->state = RUNNABLE;
80103b8e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b95:	83 c2 7c             	add    $0x7c,%edx
80103b98:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103b9e:	75 e3                	jne    80103b83 <exit+0x83>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103ba0:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103ba5:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103baa:	eb 0f                	jmp    80103bbb <exit+0xbb>
80103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bb0:	83 c1 7c             	add    $0x7c,%ecx
80103bb3:	81 f9 54 4c 11 80    	cmp    $0x80114c54,%ecx
80103bb9:	74 34                	je     80103bef <exit+0xef>
    if(p->parent == curproc){
80103bbb:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103bbe:	75 f0                	jne    80103bb0 <exit+0xb0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103bc0:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103bc4:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103bc7:	75 e7                	jne    80103bb0 <exit+0xb0>
80103bc9:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103bce:	eb 0b                	jmp    80103bdb <exit+0xdb>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bd0:	83 c2 7c             	add    $0x7c,%edx
80103bd3:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103bd9:	74 d5                	je     80103bb0 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103bdb:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103bdf:	75 ef                	jne    80103bd0 <exit+0xd0>
80103be1:	3b 42 20             	cmp    0x20(%edx),%eax
80103be4:	75 ea                	jne    80103bd0 <exit+0xd0>
      p->state = RUNNABLE;
80103be6:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103bed:	eb e1                	jmp    80103bd0 <exit+0xd0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103bef:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103bf6:	e8 65 fe ff ff       	call   80103a60 <sched>
  panic("zombie exit");
80103bfb:	c7 04 24 1d 77 10 80 	movl   $0x8010771d,(%esp)
80103c02:	e8 59 c7 ff ff       	call   80100360 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103c07:	c7 04 24 10 77 10 80 	movl   $0x80107710,(%esp)
80103c0e:	e8 4d c7 ff ff       	call   80100360 <panic>
80103c13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c20 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c26:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c2d:	e8 6e 05 00 00       	call   801041a0 <acquire>
  myproc()->state = RUNNABLE;
80103c32:	e8 c9 fa ff ff       	call   80103700 <myproc>
80103c37:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103c3e:	e8 1d fe ff ff       	call   80103a60 <sched>
  release(&ptable.lock);
80103c43:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c4a:	e8 41 06 00 00       	call   80104290 <release>
}
80103c4f:	c9                   	leave  
80103c50:	c3                   	ret    
80103c51:	eb 0d                	jmp    80103c60 <sleep>
80103c53:	90                   	nop
80103c54:	90                   	nop
80103c55:	90                   	nop
80103c56:	90                   	nop
80103c57:	90                   	nop
80103c58:	90                   	nop
80103c59:	90                   	nop
80103c5a:	90                   	nop
80103c5b:	90                   	nop
80103c5c:	90                   	nop
80103c5d:	90                   	nop
80103c5e:	90                   	nop
80103c5f:	90                   	nop

80103c60 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 1c             	sub    $0x1c,%esp
80103c69:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c6f:	e8 8c fa ff ff       	call   80103700 <myproc>
  
  if(p == 0)
80103c74:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103c76:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103c78:	0f 84 7c 00 00 00    	je     80103cfa <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103c7e:	85 f6                	test   %esi,%esi
80103c80:	74 6c                	je     80103cee <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c82:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c88:	74 46                	je     80103cd0 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c8a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c91:	e8 0a 05 00 00       	call   801041a0 <acquire>
    release(lk);
80103c96:	89 34 24             	mov    %esi,(%esp)
80103c99:	e8 f2 05 00 00       	call   80104290 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103c9e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ca1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103ca8:	e8 b3 fd ff ff       	call   80103a60 <sched>

  // Tidy up.
  p->chan = 0;
80103cad:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103cb4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cbb:	e8 d0 05 00 00       	call   80104290 <release>
    acquire(lk);
80103cc0:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103cc3:	83 c4 1c             	add    $0x1c,%esp
80103cc6:	5b                   	pop    %ebx
80103cc7:	5e                   	pop    %esi
80103cc8:	5f                   	pop    %edi
80103cc9:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103cca:	e9 d1 04 00 00       	jmp    801041a0 <acquire>
80103ccf:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103cd0:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103cd3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103cda:	e8 81 fd ff ff       	call   80103a60 <sched>

  // Tidy up.
  p->chan = 0;
80103cdf:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103ce6:	83 c4 1c             	add    $0x1c,%esp
80103ce9:	5b                   	pop    %ebx
80103cea:	5e                   	pop    %esi
80103ceb:	5f                   	pop    %edi
80103cec:	5d                   	pop    %ebp
80103ced:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103cee:	c7 04 24 2f 77 10 80 	movl   $0x8010772f,(%esp)
80103cf5:	e8 66 c6 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103cfa:	c7 04 24 29 77 10 80 	movl   $0x80107729,(%esp)
80103d01:	e8 5a c6 ff ff       	call   80100360 <panic>
80103d06:	8d 76 00             	lea    0x0(%esi),%esi
80103d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d10 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	56                   	push   %esi
80103d14:	53                   	push   %ebx
80103d15:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103d18:	e8 e3 f9 ff ff       	call   80103700 <myproc>
  
  acquire(&ptable.lock);
80103d1d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103d24:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103d26:	e8 75 04 00 00       	call   801041a0 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103d2b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d2d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103d32:	eb 0f                	jmp    80103d43 <wait+0x33>
80103d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d38:	83 c3 7c             	add    $0x7c,%ebx
80103d3b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103d41:	74 1d                	je     80103d60 <wait+0x50>
      if(p->parent != curproc)
80103d43:	39 73 14             	cmp    %esi,0x14(%ebx)
80103d46:	75 f0                	jne    80103d38 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103d48:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d4c:	74 2f                	je     80103d7d <wait+0x6d>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d4e:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103d51:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d56:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103d5c:	75 e5                	jne    80103d43 <wait+0x33>
80103d5e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103d60:	85 c0                	test   %eax,%eax
80103d62:	74 6e                	je     80103dd2 <wait+0xc2>
80103d64:	8b 46 24             	mov    0x24(%esi),%eax
80103d67:	85 c0                	test   %eax,%eax
80103d69:	75 67                	jne    80103dd2 <wait+0xc2>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d6b:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d72:	80 
80103d73:	89 34 24             	mov    %esi,(%esp)
80103d76:	e8 e5 fe ff ff       	call   80103c60 <sleep>
  }
80103d7b:	eb ae                	jmp    80103d2b <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103d7d:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103d80:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d83:	89 04 24             	mov    %eax,(%esp)
80103d86:	e8 c5 e5 ff ff       	call   80102350 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103d8b:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103d8e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d95:	89 04 24             	mov    %eax,(%esp)
80103d98:	e8 73 30 00 00       	call   80106e10 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103d9d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103da4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103dab:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103db2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103db6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103dbd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103dc4:	e8 c7 04 00 00       	call   80104290 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103dc9:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103dcc:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103dce:	5b                   	pop    %ebx
80103dcf:	5e                   	pop    %esi
80103dd0:	5d                   	pop    %ebp
80103dd1:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103dd2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dd9:	e8 b2 04 00 00       	call   80104290 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103dde:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103de6:	5b                   	pop    %ebx
80103de7:	5e                   	pop    %esi
80103de8:	5d                   	pop    %ebp
80103de9:	c3                   	ret    
80103dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103df0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 14             	sub    $0x14,%esp
80103df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103dfa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e01:	e8 9a 03 00 00       	call   801041a0 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e06:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e0b:	eb 0d                	jmp    80103e1a <wakeup+0x2a>
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi
80103e10:	83 c0 7c             	add    $0x7c,%eax
80103e13:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e18:	74 1e                	je     80103e38 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103e1a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e1e:	75 f0                	jne    80103e10 <wakeup+0x20>
80103e20:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e23:	75 eb                	jne    80103e10 <wakeup+0x20>
      p->state = RUNNABLE;
80103e25:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e2c:	83 c0 7c             	add    $0x7c,%eax
80103e2f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e34:	75 e4                	jne    80103e1a <wakeup+0x2a>
80103e36:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103e38:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103e3f:	83 c4 14             	add    $0x14,%esp
80103e42:	5b                   	pop    %ebx
80103e43:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103e44:	e9 47 04 00 00       	jmp    80104290 <release>
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e50 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
80103e54:	83 ec 14             	sub    $0x14,%esp
80103e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e5a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e61:	e8 3a 03 00 00       	call   801041a0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e66:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e6b:	eb 0d                	jmp    80103e7a <kill+0x2a>
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
80103e70:	83 c0 7c             	add    $0x7c,%eax
80103e73:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e78:	74 36                	je     80103eb0 <kill+0x60>
    if(p->pid == pid){
80103e7a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e7d:	75 f1                	jne    80103e70 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e7f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103e83:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e8a:	74 14                	je     80103ea0 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e8c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e93:	e8 f8 03 00 00       	call   80104290 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e98:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103e9b:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e9d:	5b                   	pop    %ebx
80103e9e:	5d                   	pop    %ebp
80103e9f:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103ea0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ea7:	eb e3                	jmp    80103e8c <kill+0x3c>
80103ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103eb0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eb7:	e8 d4 03 00 00       	call   80104290 <release>
  return -1;
}
80103ebc:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103ebf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ec4:	5b                   	pop    %ebx
80103ec5:	5d                   	pop    %ebp
80103ec6:	c3                   	ret    
80103ec7:	89 f6                	mov    %esi,%esi
80103ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ed0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	57                   	push   %edi
80103ed4:	56                   	push   %esi
80103ed5:	53                   	push   %ebx
80103ed6:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103edb:	83 ec 4c             	sub    $0x4c,%esp
80103ede:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ee1:	eb 20                	jmp    80103f03 <procdump+0x33>
80103ee3:	90                   	nop
80103ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ee8:	c7 04 24 4f 7b 10 80 	movl   $0x80107b4f,(%esp)
80103eef:	e8 5c c7 ff ff       	call   80100650 <cprintf>
80103ef4:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef7:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80103efd:	0f 84 8d 00 00 00    	je     80103f90 <procdump+0xc0>
    if(p->state == UNUSED)
80103f03:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103f06:	85 c0                	test   %eax,%eax
80103f08:	74 ea                	je     80103ef4 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f0a:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103f0d:	ba 40 77 10 80       	mov    $0x80107740,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f12:	77 11                	ja     80103f25 <procdump+0x55>
80103f14:	8b 14 85 a0 77 10 80 	mov    -0x7fef8860(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103f1b:	b8 40 77 10 80       	mov    $0x80107740,%eax
80103f20:	85 d2                	test   %edx,%edx
80103f22:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f25:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103f28:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103f2c:	89 54 24 08          	mov    %edx,0x8(%esp)
80103f30:	c7 04 24 44 77 10 80 	movl   $0x80107744,(%esp)
80103f37:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f3b:	e8 10 c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103f40:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f44:	75 a2                	jne    80103ee8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f46:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f49:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f4d:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f50:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f53:	8b 40 0c             	mov    0xc(%eax),%eax
80103f56:	83 c0 08             	add    $0x8,%eax
80103f59:	89 04 24             	mov    %eax,(%esp)
80103f5c:	e8 6f 01 00 00       	call   801040d0 <getcallerpcs>
80103f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f68:	8b 17                	mov    (%edi),%edx
80103f6a:	85 d2                	test   %edx,%edx
80103f6c:	0f 84 76 ff ff ff    	je     80103ee8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f72:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f76:	83 c7 04             	add    $0x4,%edi
80103f79:	c7 04 24 81 71 10 80 	movl   $0x80107181,(%esp)
80103f80:	e8 cb c6 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80103f85:	39 f7                	cmp    %esi,%edi
80103f87:	75 df                	jne    80103f68 <procdump+0x98>
80103f89:	e9 5a ff ff ff       	jmp    80103ee8 <procdump+0x18>
80103f8e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80103f90:	83 c4 4c             	add    $0x4c,%esp
80103f93:	5b                   	pop    %ebx
80103f94:	5e                   	pop    %esi
80103f95:	5f                   	pop    %edi
80103f96:	5d                   	pop    %ebp
80103f97:	c3                   	ret    
80103f98:	66 90                	xchg   %ax,%ax
80103f9a:	66 90                	xchg   %ax,%ax
80103f9c:	66 90                	xchg   %ax,%ax
80103f9e:	66 90                	xchg   %ax,%ax

80103fa0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	83 ec 14             	sub    $0x14,%esp
80103fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103faa:	c7 44 24 04 b8 77 10 	movl   $0x801077b8,0x4(%esp)
80103fb1:	80 
80103fb2:	8d 43 04             	lea    0x4(%ebx),%eax
80103fb5:	89 04 24             	mov    %eax,(%esp)
80103fb8:	e8 f3 00 00 00       	call   801040b0 <initlock>
  lk->name = name;
80103fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103fc0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fc6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80103fcd:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80103fd0:	83 c4 14             	add    $0x14,%esp
80103fd3:	5b                   	pop    %ebx
80103fd4:	5d                   	pop    %ebp
80103fd5:	c3                   	ret    
80103fd6:	8d 76 00             	lea    0x0(%esi),%esi
80103fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fe0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
80103fe5:	83 ec 10             	sub    $0x10,%esp
80103fe8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103feb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fee:	89 34 24             	mov    %esi,(%esp)
80103ff1:	e8 aa 01 00 00       	call   801041a0 <acquire>
  while (lk->locked) {
80103ff6:	8b 13                	mov    (%ebx),%edx
80103ff8:	85 d2                	test   %edx,%edx
80103ffa:	74 16                	je     80104012 <acquiresleep+0x32>
80103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104000:	89 74 24 04          	mov    %esi,0x4(%esp)
80104004:	89 1c 24             	mov    %ebx,(%esp)
80104007:	e8 54 fc ff ff       	call   80103c60 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010400c:	8b 03                	mov    (%ebx),%eax
8010400e:	85 c0                	test   %eax,%eax
80104010:	75 ee                	jne    80104000 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104012:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104018:	e8 e3 f6 ff ff       	call   80103700 <myproc>
8010401d:	8b 40 10             	mov    0x10(%eax),%eax
80104020:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104023:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104026:	83 c4 10             	add    $0x10,%esp
80104029:	5b                   	pop    %ebx
8010402a:	5e                   	pop    %esi
8010402b:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010402c:	e9 5f 02 00 00       	jmp    80104290 <release>
80104031:	eb 0d                	jmp    80104040 <releasesleep>
80104033:	90                   	nop
80104034:	90                   	nop
80104035:	90                   	nop
80104036:	90                   	nop
80104037:	90                   	nop
80104038:	90                   	nop
80104039:	90                   	nop
8010403a:	90                   	nop
8010403b:	90                   	nop
8010403c:	90                   	nop
8010403d:	90                   	nop
8010403e:	90                   	nop
8010403f:	90                   	nop

80104040 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
80104045:	83 ec 10             	sub    $0x10,%esp
80104048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010404b:	8d 73 04             	lea    0x4(%ebx),%esi
8010404e:	89 34 24             	mov    %esi,(%esp)
80104051:	e8 4a 01 00 00       	call   801041a0 <acquire>
  lk->locked = 0;
80104056:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010405c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104063:	89 1c 24             	mov    %ebx,(%esp)
80104066:	e8 85 fd ff ff       	call   80103df0 <wakeup>
  release(&lk->lk);
8010406b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010406e:	83 c4 10             	add    $0x10,%esp
80104071:	5b                   	pop    %ebx
80104072:	5e                   	pop    %esi
80104073:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104074:	e9 17 02 00 00       	jmp    80104290 <release>
80104079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104080 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	56                   	push   %esi
80104084:	53                   	push   %ebx
80104085:	83 ec 10             	sub    $0x10,%esp
80104088:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010408b:	8d 73 04             	lea    0x4(%ebx),%esi
8010408e:	89 34 24             	mov    %esi,(%esp)
80104091:	e8 0a 01 00 00       	call   801041a0 <acquire>
  r = lk->locked;
80104096:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104098:	89 34 24             	mov    %esi,(%esp)
8010409b:	e8 f0 01 00 00       	call   80104290 <release>
  return r;
}
801040a0:	83 c4 10             	add    $0x10,%esp
801040a3:	89 d8                	mov    %ebx,%eax
801040a5:	5b                   	pop    %ebx
801040a6:	5e                   	pop    %esi
801040a7:	5d                   	pop    %ebp
801040a8:	c3                   	ret    
801040a9:	66 90                	xchg   %ax,%ax
801040ab:	66 90                	xchg   %ax,%ax
801040ad:	66 90                	xchg   %ax,%ax
801040af:	90                   	nop

801040b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801040b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801040b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801040bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801040c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801040c9:	5d                   	pop    %ebp
801040ca:	c3                   	ret    
801040cb:	90                   	nop
801040cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040d3:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801040d9:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040da:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801040dd:	31 c0                	xor    %eax,%eax
801040df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040e0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801040e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040ec:	77 1a                	ja     80104108 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040ee:	8b 5a 04             	mov    0x4(%edx),%ebx
801040f1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801040f4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801040f7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801040f9:	83 f8 0a             	cmp    $0xa,%eax
801040fc:	75 e2                	jne    801040e0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040fe:	5b                   	pop    %ebx
801040ff:	5d                   	pop    %ebp
80104100:	c3                   	ret    
80104101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104108:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010410f:	83 c0 01             	add    $0x1,%eax
80104112:	83 f8 0a             	cmp    $0xa,%eax
80104115:	74 e7                	je     801040fe <getcallerpcs+0x2e>
    pcs[i] = 0;
80104117:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010411e:	83 c0 01             	add    $0x1,%eax
80104121:	83 f8 0a             	cmp    $0xa,%eax
80104124:	75 e2                	jne    80104108 <getcallerpcs+0x38>
80104126:	eb d6                	jmp    801040fe <getcallerpcs+0x2e>
80104128:	90                   	nop
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104130 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104130:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
80104131:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104133:	89 e5                	mov    %esp,%ebp
80104135:	53                   	push   %ebx
80104136:	83 ec 04             	sub    $0x4,%esp
80104139:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010413c:	8b 0a                	mov    (%edx),%ecx
8010413e:	85 c9                	test   %ecx,%ecx
80104140:	74 10                	je     80104152 <holding+0x22>
80104142:	8b 5a 08             	mov    0x8(%edx),%ebx
80104145:	e8 16 f5 ff ff       	call   80103660 <mycpu>
8010414a:	39 c3                	cmp    %eax,%ebx
8010414c:	0f 94 c0             	sete   %al
8010414f:	0f b6 c0             	movzbl %al,%eax
}
80104152:	83 c4 04             	add    $0x4,%esp
80104155:	5b                   	pop    %ebx
80104156:	5d                   	pop    %ebp
80104157:	c3                   	ret    
80104158:	90                   	nop
80104159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104160 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 04             	sub    $0x4,%esp
80104167:	9c                   	pushf  
80104168:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104169:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010416a:	e8 f1 f4 ff ff       	call   80103660 <mycpu>
8010416f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104175:	85 c0                	test   %eax,%eax
80104177:	75 11                	jne    8010418a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104179:	e8 e2 f4 ff ff       	call   80103660 <mycpu>
8010417e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104184:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010418a:	e8 d1 f4 ff ff       	call   80103660 <mycpu>
8010418f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104196:	83 c4 04             	add    $0x4,%esp
80104199:	5b                   	pop    %ebx
8010419a:	5d                   	pop    %ebp
8010419b:	c3                   	ret    
8010419c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041a0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	53                   	push   %ebx
801041a4:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801041a7:	e8 b4 ff ff ff       	call   80104160 <pushcli>
  if(holding(lk))
801041ac:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801041af:	8b 02                	mov    (%edx),%eax
801041b1:	85 c0                	test   %eax,%eax
801041b3:	75 43                	jne    801041f8 <acquire+0x58>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801041b5:	b9 01 00 00 00       	mov    $0x1,%ecx
801041ba:	eb 07                	jmp    801041c3 <acquire+0x23>
801041bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041c0:	8b 55 08             	mov    0x8(%ebp),%edx
801041c3:	89 c8                	mov    %ecx,%eax
801041c5:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801041c8:	85 c0                	test   %eax,%eax
801041ca:	75 f4                	jne    801041c0 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801041cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801041d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801041d4:	e8 87 f4 ff ff       	call   80103660 <mycpu>
801041d9:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801041dc:	8b 45 08             	mov    0x8(%ebp),%eax
801041df:	83 c0 0c             	add    $0xc,%eax
801041e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801041e6:	8d 45 08             	lea    0x8(%ebp),%eax
801041e9:	89 04 24             	mov    %eax,(%esp)
801041ec:	e8 df fe ff ff       	call   801040d0 <getcallerpcs>
}
801041f1:	83 c4 14             	add    $0x14,%esp
801041f4:	5b                   	pop    %ebx
801041f5:	5d                   	pop    %ebp
801041f6:	c3                   	ret    
801041f7:	90                   	nop

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801041f8:	8b 5a 08             	mov    0x8(%edx),%ebx
801041fb:	e8 60 f4 ff ff       	call   80103660 <mycpu>
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
80104200:	39 c3                	cmp    %eax,%ebx
80104202:	74 05                	je     80104209 <acquire+0x69>
80104204:	8b 55 08             	mov    0x8(%ebp),%edx
80104207:	eb ac                	jmp    801041b5 <acquire+0x15>
    panic("acquire");
80104209:	c7 04 24 c3 77 10 80 	movl   $0x801077c3,(%esp)
80104210:	e8 4b c1 ff ff       	call   80100360 <panic>
80104215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104226:	9c                   	pushf  
80104227:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104228:	f6 c4 02             	test   $0x2,%ah
8010422b:	75 49                	jne    80104276 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010422d:	e8 2e f4 ff ff       	call   80103660 <mycpu>
80104232:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104238:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010423b:	85 d2                	test   %edx,%edx
8010423d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104243:	78 25                	js     8010426a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104245:	e8 16 f4 ff ff       	call   80103660 <mycpu>
8010424a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104250:	85 d2                	test   %edx,%edx
80104252:	74 04                	je     80104258 <popcli+0x38>
    sti();
}
80104254:	c9                   	leave  
80104255:	c3                   	ret    
80104256:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104258:	e8 03 f4 ff ff       	call   80103660 <mycpu>
8010425d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104263:	85 c0                	test   %eax,%eax
80104265:	74 ed                	je     80104254 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104267:	fb                   	sti    
    sti();
}
80104268:	c9                   	leave  
80104269:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
8010426a:	c7 04 24 e2 77 10 80 	movl   $0x801077e2,(%esp)
80104271:	e8 ea c0 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104276:	c7 04 24 cb 77 10 80 	movl   $0x801077cb,(%esp)
8010427d:	e8 de c0 ff ff       	call   80100360 <panic>
80104282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104290 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	56                   	push   %esi
80104294:	53                   	push   %ebx
80104295:	83 ec 10             	sub    $0x10,%esp
80104298:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010429b:	8b 03                	mov    (%ebx),%eax
8010429d:	85 c0                	test   %eax,%eax
8010429f:	75 0f                	jne    801042b0 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801042a1:	c7 04 24 e9 77 10 80 	movl   $0x801077e9,(%esp)
801042a8:	e8 b3 c0 ff ff       	call   80100360 <panic>
801042ad:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801042b0:	8b 73 08             	mov    0x8(%ebx),%esi
801042b3:	e8 a8 f3 ff ff       	call   80103660 <mycpu>

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
801042b8:	39 c6                	cmp    %eax,%esi
801042ba:	75 e5                	jne    801042a1 <release+0x11>
    panic("release");

  lk->pcs[0] = 0;
801042bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801042c3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801042ca:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801042cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801042d5:	83 c4 10             	add    $0x10,%esp
801042d8:	5b                   	pop    %ebx
801042d9:	5e                   	pop    %esi
801042da:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801042db:	e9 40 ff ff ff       	jmp    80104220 <popcli>

801042e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	8b 55 08             	mov    0x8(%ebp),%edx
801042e6:	57                   	push   %edi
801042e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801042ea:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801042eb:	f6 c2 03             	test   $0x3,%dl
801042ee:	75 05                	jne    801042f5 <memset+0x15>
801042f0:	f6 c1 03             	test   $0x3,%cl
801042f3:	74 13                	je     80104308 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801042f5:	89 d7                	mov    %edx,%edi
801042f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801042fa:	fc                   	cld    
801042fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801042fd:	5b                   	pop    %ebx
801042fe:	89 d0                	mov    %edx,%eax
80104300:	5f                   	pop    %edi
80104301:	5d                   	pop    %ebp
80104302:	c3                   	ret    
80104303:	90                   	nop
80104304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104308:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010430c:	c1 e9 02             	shr    $0x2,%ecx
8010430f:	89 f8                	mov    %edi,%eax
80104311:	89 fb                	mov    %edi,%ebx
80104313:	c1 e0 18             	shl    $0x18,%eax
80104316:	c1 e3 10             	shl    $0x10,%ebx
80104319:	09 d8                	or     %ebx,%eax
8010431b:	09 f8                	or     %edi,%eax
8010431d:	c1 e7 08             	shl    $0x8,%edi
80104320:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104322:	89 d7                	mov    %edx,%edi
80104324:	fc                   	cld    
80104325:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104327:	5b                   	pop    %ebx
80104328:	89 d0                	mov    %edx,%eax
8010432a:	5f                   	pop    %edi
8010432b:	5d                   	pop    %ebp
8010432c:	c3                   	ret    
8010432d:	8d 76 00             	lea    0x0(%esi),%esi

80104330 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	8b 45 10             	mov    0x10(%ebp),%eax
80104336:	57                   	push   %edi
80104337:	56                   	push   %esi
80104338:	8b 75 0c             	mov    0xc(%ebp),%esi
8010433b:	53                   	push   %ebx
8010433c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010433f:	85 c0                	test   %eax,%eax
80104341:	8d 78 ff             	lea    -0x1(%eax),%edi
80104344:	74 26                	je     8010436c <memcmp+0x3c>
    if(*s1 != *s2)
80104346:	0f b6 03             	movzbl (%ebx),%eax
80104349:	31 d2                	xor    %edx,%edx
8010434b:	0f b6 0e             	movzbl (%esi),%ecx
8010434e:	38 c8                	cmp    %cl,%al
80104350:	74 16                	je     80104368 <memcmp+0x38>
80104352:	eb 24                	jmp    80104378 <memcmp+0x48>
80104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104358:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010435d:	83 c2 01             	add    $0x1,%edx
80104360:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104364:	38 c8                	cmp    %cl,%al
80104366:	75 10                	jne    80104378 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104368:	39 fa                	cmp    %edi,%edx
8010436a:	75 ec                	jne    80104358 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010436c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010436d:	31 c0                	xor    %eax,%eax
}
8010436f:	5e                   	pop    %esi
80104370:	5f                   	pop    %edi
80104371:	5d                   	pop    %ebp
80104372:	c3                   	ret    
80104373:	90                   	nop
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104378:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104379:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010437b:	5e                   	pop    %esi
8010437c:	5f                   	pop    %edi
8010437d:	5d                   	pop    %ebp
8010437e:	c3                   	ret    
8010437f:	90                   	nop

80104380 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	57                   	push   %edi
80104384:	8b 45 08             	mov    0x8(%ebp),%eax
80104387:	56                   	push   %esi
80104388:	8b 75 0c             	mov    0xc(%ebp),%esi
8010438b:	53                   	push   %ebx
8010438c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010438f:	39 c6                	cmp    %eax,%esi
80104391:	73 35                	jae    801043c8 <memmove+0x48>
80104393:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104396:	39 c8                	cmp    %ecx,%eax
80104398:	73 2e                	jae    801043c8 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010439a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010439c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010439f:	8d 53 ff             	lea    -0x1(%ebx),%edx
801043a2:	74 1b                	je     801043bf <memmove+0x3f>
801043a4:	f7 db                	neg    %ebx
801043a6:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
801043a9:	01 fb                	add    %edi,%ebx
801043ab:	90                   	nop
801043ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801043b0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043b4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801043b7:	83 ea 01             	sub    $0x1,%edx
801043ba:	83 fa ff             	cmp    $0xffffffff,%edx
801043bd:	75 f1                	jne    801043b0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801043bf:	5b                   	pop    %ebx
801043c0:	5e                   	pop    %esi
801043c1:	5f                   	pop    %edi
801043c2:	5d                   	pop    %ebp
801043c3:	c3                   	ret    
801043c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801043c8:	31 d2                	xor    %edx,%edx
801043ca:	85 db                	test   %ebx,%ebx
801043cc:	74 f1                	je     801043bf <memmove+0x3f>
801043ce:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801043d0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801043d7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801043da:	39 da                	cmp    %ebx,%edx
801043dc:	75 f2                	jne    801043d0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801043de:	5b                   	pop    %ebx
801043df:	5e                   	pop    %esi
801043e0:	5f                   	pop    %edi
801043e1:	5d                   	pop    %ebp
801043e2:	c3                   	ret    
801043e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801043f3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801043f4:	e9 87 ff ff ff       	jmp    80104380 <memmove>
801043f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104400 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	56                   	push   %esi
80104404:	8b 75 10             	mov    0x10(%ebp),%esi
80104407:	53                   	push   %ebx
80104408:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010440b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010440e:	85 f6                	test   %esi,%esi
80104410:	74 30                	je     80104442 <strncmp+0x42>
80104412:	0f b6 01             	movzbl (%ecx),%eax
80104415:	84 c0                	test   %al,%al
80104417:	74 2f                	je     80104448 <strncmp+0x48>
80104419:	0f b6 13             	movzbl (%ebx),%edx
8010441c:	38 d0                	cmp    %dl,%al
8010441e:	75 46                	jne    80104466 <strncmp+0x66>
80104420:	8d 51 01             	lea    0x1(%ecx),%edx
80104423:	01 ce                	add    %ecx,%esi
80104425:	eb 14                	jmp    8010443b <strncmp+0x3b>
80104427:	90                   	nop
80104428:	0f b6 02             	movzbl (%edx),%eax
8010442b:	84 c0                	test   %al,%al
8010442d:	74 31                	je     80104460 <strncmp+0x60>
8010442f:	0f b6 19             	movzbl (%ecx),%ebx
80104432:	83 c2 01             	add    $0x1,%edx
80104435:	38 d8                	cmp    %bl,%al
80104437:	75 17                	jne    80104450 <strncmp+0x50>
    n--, p++, q++;
80104439:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010443b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010443d:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104440:	75 e6                	jne    80104428 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104442:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104443:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104445:	5e                   	pop    %esi
80104446:	5d                   	pop    %ebp
80104447:	c3                   	ret    
80104448:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010444b:	31 c0                	xor    %eax,%eax
8010444d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104450:	0f b6 d3             	movzbl %bl,%edx
80104453:	29 d0                	sub    %edx,%eax
}
80104455:	5b                   	pop    %ebx
80104456:	5e                   	pop    %esi
80104457:	5d                   	pop    %ebp
80104458:	c3                   	ret    
80104459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104460:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104464:	eb ea                	jmp    80104450 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104466:	89 d3                	mov    %edx,%ebx
80104468:	eb e6                	jmp    80104450 <strncmp+0x50>
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104470 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	8b 45 08             	mov    0x8(%ebp),%eax
80104476:	56                   	push   %esi
80104477:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010447a:	53                   	push   %ebx
8010447b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010447e:	89 c2                	mov    %eax,%edx
80104480:	eb 19                	jmp    8010449b <strncpy+0x2b>
80104482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104488:	83 c3 01             	add    $0x1,%ebx
8010448b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010448f:	83 c2 01             	add    $0x1,%edx
80104492:	84 c9                	test   %cl,%cl
80104494:	88 4a ff             	mov    %cl,-0x1(%edx)
80104497:	74 09                	je     801044a2 <strncpy+0x32>
80104499:	89 f1                	mov    %esi,%ecx
8010449b:	85 c9                	test   %ecx,%ecx
8010449d:	8d 71 ff             	lea    -0x1(%ecx),%esi
801044a0:	7f e6                	jg     80104488 <strncpy+0x18>
    ;
  while(n-- > 0)
801044a2:	31 c9                	xor    %ecx,%ecx
801044a4:	85 f6                	test   %esi,%esi
801044a6:	7e 0f                	jle    801044b7 <strncpy+0x47>
    *s++ = 0;
801044a8:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801044ac:	89 f3                	mov    %esi,%ebx
801044ae:	83 c1 01             	add    $0x1,%ecx
801044b1:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801044b3:	85 db                	test   %ebx,%ebx
801044b5:	7f f1                	jg     801044a8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
801044b7:	5b                   	pop    %ebx
801044b8:	5e                   	pop    %esi
801044b9:	5d                   	pop    %ebp
801044ba:	c3                   	ret    
801044bb:	90                   	nop
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044c6:	56                   	push   %esi
801044c7:	8b 45 08             	mov    0x8(%ebp),%eax
801044ca:	53                   	push   %ebx
801044cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801044ce:	85 c9                	test   %ecx,%ecx
801044d0:	7e 26                	jle    801044f8 <safestrcpy+0x38>
801044d2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801044d6:	89 c1                	mov    %eax,%ecx
801044d8:	eb 17                	jmp    801044f1 <safestrcpy+0x31>
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801044e0:	83 c2 01             	add    $0x1,%edx
801044e3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801044e7:	83 c1 01             	add    $0x1,%ecx
801044ea:	84 db                	test   %bl,%bl
801044ec:	88 59 ff             	mov    %bl,-0x1(%ecx)
801044ef:	74 04                	je     801044f5 <safestrcpy+0x35>
801044f1:	39 f2                	cmp    %esi,%edx
801044f3:	75 eb                	jne    801044e0 <safestrcpy+0x20>
    ;
  *s = 0;
801044f5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801044f8:	5b                   	pop    %ebx
801044f9:	5e                   	pop    %esi
801044fa:	5d                   	pop    %ebp
801044fb:	c3                   	ret    
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104500 <strlen>:

int
strlen(const char *s)
{
80104500:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104501:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104503:	89 e5                	mov    %esp,%ebp
80104505:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104508:	80 3a 00             	cmpb   $0x0,(%edx)
8010450b:	74 0c                	je     80104519 <strlen+0x19>
8010450d:	8d 76 00             	lea    0x0(%esi),%esi
80104510:	83 c0 01             	add    $0x1,%eax
80104513:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104517:	75 f7                	jne    80104510 <strlen+0x10>
    ;
  return n;
}
80104519:	5d                   	pop    %ebp
8010451a:	c3                   	ret    

8010451b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010451b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010451f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104523:	55                   	push   %ebp
  pushl %ebx
80104524:	53                   	push   %ebx
  pushl %esi
80104525:	56                   	push   %esi
  pushl %edi
80104526:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104527:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104529:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010452b:	5f                   	pop    %edi
  popl %esi
8010452c:	5e                   	pop    %esi
  popl %ebx
8010452d:	5b                   	pop    %ebx
  popl %ebp
8010452e:	5d                   	pop    %ebp
  ret
8010452f:	c3                   	ret    

80104530 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 04             	sub    $0x4,%esp
80104537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010453a:	e8 c1 f1 ff ff       	call   80103700 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010453f:	8b 00                	mov    (%eax),%eax
80104541:	39 d8                	cmp    %ebx,%eax
80104543:	76 1b                	jbe    80104560 <fetchint+0x30>
80104545:	8d 53 04             	lea    0x4(%ebx),%edx
80104548:	39 d0                	cmp    %edx,%eax
8010454a:	72 14                	jb     80104560 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010454c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010454f:	8b 13                	mov    (%ebx),%edx
80104551:	89 10                	mov    %edx,(%eax)
  return 0;
80104553:	31 c0                	xor    %eax,%eax
}
80104555:	83 c4 04             	add    $0x4,%esp
80104558:	5b                   	pop    %ebx
80104559:	5d                   	pop    %ebp
8010455a:	c3                   	ret    
8010455b:	90                   	nop
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104565:	eb ee                	jmp    80104555 <fetchint+0x25>
80104567:	89 f6                	mov    %esi,%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	53                   	push   %ebx
80104574:	83 ec 04             	sub    $0x4,%esp
80104577:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010457a:	e8 81 f1 ff ff       	call   80103700 <myproc>

  if(addr >= curproc->sz)
8010457f:	39 18                	cmp    %ebx,(%eax)
80104581:	76 26                	jbe    801045a9 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80104583:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104586:	89 da                	mov    %ebx,%edx
80104588:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010458a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010458c:	39 c3                	cmp    %eax,%ebx
8010458e:	73 19                	jae    801045a9 <fetchstr+0x39>
    if(*s == 0)
80104590:	80 3b 00             	cmpb   $0x0,(%ebx)
80104593:	75 0d                	jne    801045a2 <fetchstr+0x32>
80104595:	eb 21                	jmp    801045b8 <fetchstr+0x48>
80104597:	90                   	nop
80104598:	80 3a 00             	cmpb   $0x0,(%edx)
8010459b:	90                   	nop
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045a0:	74 16                	je     801045b8 <fetchstr+0x48>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801045a2:	83 c2 01             	add    $0x1,%edx
801045a5:	39 d0                	cmp    %edx,%eax
801045a7:	77 ef                	ja     80104598 <fetchstr+0x28>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801045a9:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
801045ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801045b1:	5b                   	pop    %ebx
801045b2:	5d                   	pop    %ebp
801045b3:	c3                   	ret    
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045b8:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801045bb:	89 d0                	mov    %edx,%eax
801045bd:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801045bf:	5b                   	pop    %ebx
801045c0:	5d                   	pop    %ebp
801045c1:	c3                   	ret    
801045c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	8b 75 0c             	mov    0xc(%ebp),%esi
801045d7:	53                   	push   %ebx
801045d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045db:	e8 20 f1 ff ff       	call   80103700 <myproc>
801045e0:	89 75 0c             	mov    %esi,0xc(%ebp)
801045e3:	8b 40 18             	mov    0x18(%eax),%eax
801045e6:	8b 40 44             	mov    0x44(%eax),%eax
801045e9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801045ed:	89 45 08             	mov    %eax,0x8(%ebp)
}
801045f0:	5b                   	pop    %ebx
801045f1:	5e                   	pop    %esi
801045f2:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045f3:	e9 38 ff ff ff       	jmp    80104530 <fetchint>
801045f8:	90                   	nop
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104600 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	83 ec 20             	sub    $0x20,%esp
80104608:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010460b:	e8 f0 f0 ff ff       	call   80103700 <myproc>
80104610:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104612:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104615:	89 44 24 04          	mov    %eax,0x4(%esp)
80104619:	8b 45 08             	mov    0x8(%ebp),%eax
8010461c:	89 04 24             	mov    %eax,(%esp)
8010461f:	e8 ac ff ff ff       	call   801045d0 <argint>
80104624:	85 c0                	test   %eax,%eax
80104626:	78 28                	js     80104650 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104628:	85 db                	test   %ebx,%ebx
8010462a:	78 24                	js     80104650 <argptr+0x50>
8010462c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010462f:	8b 06                	mov    (%esi),%eax
80104631:	39 c2                	cmp    %eax,%edx
80104633:	73 1b                	jae    80104650 <argptr+0x50>
80104635:	01 d3                	add    %edx,%ebx
80104637:	39 d8                	cmp    %ebx,%eax
80104639:	72 15                	jb     80104650 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010463b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010463e:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104640:	83 c4 20             	add    $0x20,%esp
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
80104643:	31 c0                	xor    %eax,%eax
}
80104645:	5b                   	pop    %ebx
80104646:	5e                   	pop    %esi
80104647:	5d                   	pop    %ebp
80104648:	c3                   	ret    
80104649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104650:	83 c4 20             	add    $0x20,%esp
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
80104653:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}
80104658:	5b                   	pop    %ebx
80104659:	5e                   	pop    %esi
8010465a:	5d                   	pop    %ebp
8010465b:	c3                   	ret    
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104660 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104666:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104669:	89 44 24 04          	mov    %eax,0x4(%esp)
8010466d:	8b 45 08             	mov    0x8(%ebp),%eax
80104670:	89 04 24             	mov    %eax,(%esp)
80104673:	e8 58 ff ff ff       	call   801045d0 <argint>
80104678:	85 c0                	test   %eax,%eax
8010467a:	78 14                	js     80104690 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010467c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010467f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104683:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104686:	89 04 24             	mov    %eax,(%esp)
80104689:	e8 e2 fe ff ff       	call   80104570 <fetchstr>
}
8010468e:	c9                   	leave  
8010468f:	c3                   	ret    
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104695:	c9                   	leave  
80104696:	c3                   	ret    
80104697:	89 f6                	mov    %esi,%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046a0 <syscall>:
[SYS_directoryWalker] sys_directoryWalker,
};

void
syscall(void)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
801046a8:	e8 53 f0 ff ff       	call   80103700 <myproc>

  num = curproc->tf->eax;
801046ad:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801046b0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801046b2:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801046b5:	8d 50 ff             	lea    -0x1(%eax),%edx
801046b8:	83 fa 18             	cmp    $0x18,%edx
801046bb:	77 1b                	ja     801046d8 <syscall+0x38>
801046bd:	8b 14 85 20 78 10 80 	mov    -0x7fef87e0(,%eax,4),%edx
801046c4:	85 d2                	test   %edx,%edx
801046c6:	74 10                	je     801046d8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801046c8:	ff d2                	call   *%edx
801046ca:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801046cd:	83 c4 10             	add    $0x10,%esp
801046d0:	5b                   	pop    %ebx
801046d1:	5e                   	pop    %esi
801046d2:	5d                   	pop    %ebp
801046d3:	c3                   	ret    
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801046d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
801046dc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801046df:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801046e3:	8b 43 10             	mov    0x10(%ebx),%eax
801046e6:	c7 04 24 f1 77 10 80 	movl   $0x801077f1,(%esp)
801046ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801046f1:	e8 5a bf ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801046f6:	8b 43 18             	mov    0x18(%ebx),%eax
801046f9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104700:	83 c4 10             	add    $0x10,%esp
80104703:	5b                   	pop    %ebx
80104704:	5e                   	pop    %esi
80104705:	5d                   	pop    %ebp
80104706:	c3                   	ret    
80104707:	66 90                	xchg   %ax,%ax
80104709:	66 90                	xchg   %ax,%ax
8010470b:	66 90                	xchg   %ax,%ax
8010470d:	66 90                	xchg   %ax,%ax
8010470f:	90                   	nop

80104710 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	89 c3                	mov    %eax,%ebx
80104716:	83 ec 04             	sub    $0x4,%esp
	int fd;
	struct proc *curproc = myproc();
80104719:	e8 e2 ef ff ff       	call   80103700 <myproc>

	for(fd = 0; fd < NOFILE; fd++){
8010471e:	31 d2                	xor    %edx,%edx
		if(curproc->ofile[fd] == 0){
80104720:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104724:	85 c9                	test   %ecx,%ecx
80104726:	74 18                	je     80104740 <fdalloc+0x30>
fdalloc(struct file *f)
{
	int fd;
	struct proc *curproc = myproc();

	for(fd = 0; fd < NOFILE; fd++){
80104728:	83 c2 01             	add    $0x1,%edx
8010472b:	83 fa 10             	cmp    $0x10,%edx
8010472e:	75 f0                	jne    80104720 <fdalloc+0x10>
			curproc->ofile[fd] = f;
			return fd;
		}
	}
	return -1;
}
80104730:	83 c4 04             	add    $0x4,%esp
		if(curproc->ofile[fd] == 0){
			curproc->ofile[fd] = f;
			return fd;
		}
	}
	return -1;
80104733:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104738:	5b                   	pop    %ebx
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    
8010473b:	90                   	nop
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	int fd;
	struct proc *curproc = myproc();

	for(fd = 0; fd < NOFILE; fd++){
		if(curproc->ofile[fd] == 0){
			curproc->ofile[fd] = f;
80104740:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
			return fd;
		}
	}
	return -1;
}
80104744:	83 c4 04             	add    $0x4,%esp
	struct proc *curproc = myproc();

	for(fd = 0; fd < NOFILE; fd++){
		if(curproc->ofile[fd] == 0){
			curproc->ofile[fd] = f;
			return fd;
80104747:	89 d0                	mov    %edx,%eax
		}
	}
	return -1;
}
80104749:	5b                   	pop    %ebx
8010474a:	5d                   	pop    %ebp
8010474b:	c3                   	ret    
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104750 <create>:
	return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	56                   	push   %esi
80104755:	53                   	push   %ebx
80104756:	83 ec 4c             	sub    $0x4c,%esp
80104759:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010475c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	uint off;
	struct inode *ip, *dp;
	char name[DIRSIZ];

	if((dp = nameiparent(path, name)) == 0)
8010475f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104762:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104766:	89 04 24             	mov    %eax,(%esp)
	return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104769:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010476c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
	uint off;
	struct inode *ip, *dp;
	char name[DIRSIZ];

	if((dp = nameiparent(path, name)) == 0)
8010476f:	e8 0c d8 ff ff       	call   80101f80 <nameiparent>
80104774:	85 c0                	test   %eax,%eax
80104776:	89 c7                	mov    %eax,%edi
80104778:	0f 84 da 00 00 00    	je     80104858 <create+0x108>
		return 0;
	ilock(dp);
8010477e:	89 04 24             	mov    %eax,(%esp)
80104781:	e8 3a cf ff ff       	call   801016c0 <ilock>

	if((ip = dirlookup(dp, name, &off)) != 0){
80104786:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104789:	89 44 24 08          	mov    %eax,0x8(%esp)
8010478d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104791:	89 3c 24             	mov    %edi,(%esp)
80104794:	e8 87 d4 ff ff       	call   80101c20 <dirlookup>
80104799:	85 c0                	test   %eax,%eax
8010479b:	89 c6                	mov    %eax,%esi
8010479d:	74 41                	je     801047e0 <create+0x90>
		iunlockput(dp);
8010479f:	89 3c 24             	mov    %edi,(%esp)
801047a2:	e8 c9 d1 ff ff       	call   80101970 <iunlockput>
		ilock(ip);
801047a7:	89 34 24             	mov    %esi,(%esp)
801047aa:	e8 11 cf ff ff       	call   801016c0 <ilock>
		if(type == T_FILE && ip->type == T_FILE)
801047af:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801047b4:	75 12                	jne    801047c8 <create+0x78>
801047b6:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801047bb:	89 f0                	mov    %esi,%eax
801047bd:	75 09                	jne    801047c8 <create+0x78>
		panic("create: dirlink");

	iunlockput(dp);

	return ip;
}
801047bf:	83 c4 4c             	add    $0x4c,%esp
801047c2:	5b                   	pop    %ebx
801047c3:	5e                   	pop    %esi
801047c4:	5f                   	pop    %edi
801047c5:	5d                   	pop    %ebp
801047c6:	c3                   	ret    
801047c7:	90                   	nop
	if((ip = dirlookup(dp, name, &off)) != 0){
		iunlockput(dp);
		ilock(ip);
		if(type == T_FILE && ip->type == T_FILE)
			return ip;
		iunlockput(ip);
801047c8:	89 34 24             	mov    %esi,(%esp)
801047cb:	e8 a0 d1 ff ff       	call   80101970 <iunlockput>
		panic("create: dirlink");

	iunlockput(dp);

	return ip;
}
801047d0:	83 c4 4c             	add    $0x4c,%esp
		iunlockput(dp);
		ilock(ip);
		if(type == T_FILE && ip->type == T_FILE)
			return ip;
		iunlockput(ip);
		return 0;
801047d3:	31 c0                	xor    %eax,%eax
		panic("create: dirlink");

	iunlockput(dp);

	return ip;
}
801047d5:	5b                   	pop    %ebx
801047d6:	5e                   	pop    %esi
801047d7:	5f                   	pop    %edi
801047d8:	5d                   	pop    %ebp
801047d9:	c3                   	ret    
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			return ip;
		iunlockput(ip);
		return 0;
	}

	if((ip = ialloc(dp->dev, type)) == 0)
801047e0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801047e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801047e8:	8b 07                	mov    (%edi),%eax
801047ea:	89 04 24             	mov    %eax,(%esp)
801047ed:	e8 3e cd ff ff       	call   80101530 <ialloc>
801047f2:	85 c0                	test   %eax,%eax
801047f4:	89 c6                	mov    %eax,%esi
801047f6:	0f 84 bf 00 00 00    	je     801048bb <create+0x16b>
		panic("create: ialloc");

	ilock(ip);
801047fc:	89 04 24             	mov    %eax,(%esp)
801047ff:	e8 bc ce ff ff       	call   801016c0 <ilock>
	ip->major = major;
80104804:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104808:	66 89 46 52          	mov    %ax,0x52(%esi)
	ip->minor = minor;
8010480c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104810:	66 89 46 54          	mov    %ax,0x54(%esi)
	ip->nlink = 1;
80104814:	b8 01 00 00 00       	mov    $0x1,%eax
80104819:	66 89 46 56          	mov    %ax,0x56(%esi)
	iupdate(ip);
8010481d:	89 34 24             	mov    %esi,(%esp)
80104820:	e8 db cd ff ff       	call   80101600 <iupdate>

	if(type == T_DIR){  // Create . and .. entries.
80104825:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010482a:	74 34                	je     80104860 <create+0x110>
		// No ip->nlink++ for ".": avoid cyclic ref count.
		if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
			panic("create dots");
	}

	if(dirlink(dp, name, ip->inum) < 0)
8010482c:	8b 46 04             	mov    0x4(%esi),%eax
8010482f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104833:	89 3c 24             	mov    %edi,(%esp)
80104836:	89 44 24 08          	mov    %eax,0x8(%esp)
8010483a:	e8 41 d6 ff ff       	call   80101e80 <dirlink>
8010483f:	85 c0                	test   %eax,%eax
80104841:	78 6c                	js     801048af <create+0x15f>
		panic("create: dirlink");

	iunlockput(dp);
80104843:	89 3c 24             	mov    %edi,(%esp)
80104846:	e8 25 d1 ff ff       	call   80101970 <iunlockput>

	return ip;
}
8010484b:	83 c4 4c             	add    $0x4c,%esp
	if(dirlink(dp, name, ip->inum) < 0)
		panic("create: dirlink");

	iunlockput(dp);

	return ip;
8010484e:	89 f0                	mov    %esi,%eax
}
80104850:	5b                   	pop    %ebx
80104851:	5e                   	pop    %esi
80104852:	5f                   	pop    %edi
80104853:	5d                   	pop    %ebp
80104854:	c3                   	ret    
80104855:	8d 76 00             	lea    0x0(%esi),%esi
	uint off;
	struct inode *ip, *dp;
	char name[DIRSIZ];

	if((dp = nameiparent(path, name)) == 0)
		return 0;
80104858:	31 c0                	xor    %eax,%eax
8010485a:	e9 60 ff ff ff       	jmp    801047bf <create+0x6f>
8010485f:	90                   	nop
	ip->minor = minor;
	ip->nlink = 1;
	iupdate(ip);

	if(type == T_DIR){  // Create . and .. entries.
		dp->nlink++;  // for ".."
80104860:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
		iupdate(dp);
80104865:	89 3c 24             	mov    %edi,(%esp)
80104868:	e8 93 cd ff ff       	call   80101600 <iupdate>
		// No ip->nlink++ for ".": avoid cyclic ref count.
		if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010486d:	8b 46 04             	mov    0x4(%esi),%eax
80104870:	c7 44 24 04 a4 78 10 	movl   $0x801078a4,0x4(%esp)
80104877:	80 
80104878:	89 34 24             	mov    %esi,(%esp)
8010487b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010487f:	e8 fc d5 ff ff       	call   80101e80 <dirlink>
80104884:	85 c0                	test   %eax,%eax
80104886:	78 1b                	js     801048a3 <create+0x153>
80104888:	8b 47 04             	mov    0x4(%edi),%eax
8010488b:	c7 44 24 04 a3 78 10 	movl   $0x801078a3,0x4(%esp)
80104892:	80 
80104893:	89 34 24             	mov    %esi,(%esp)
80104896:	89 44 24 08          	mov    %eax,0x8(%esp)
8010489a:	e8 e1 d5 ff ff       	call   80101e80 <dirlink>
8010489f:	85 c0                	test   %eax,%eax
801048a1:	79 89                	jns    8010482c <create+0xdc>
			panic("create dots");
801048a3:	c7 04 24 97 78 10 80 	movl   $0x80107897,(%esp)
801048aa:	e8 b1 ba ff ff       	call   80100360 <panic>
	}

	if(dirlink(dp, name, ip->inum) < 0)
		panic("create: dirlink");
801048af:	c7 04 24 a6 78 10 80 	movl   $0x801078a6,(%esp)
801048b6:	e8 a5 ba ff ff       	call   80100360 <panic>
		iunlockput(ip);
		return 0;
	}

	if((ip = ialloc(dp->dev, type)) == 0)
		panic("create: ialloc");
801048bb:	c7 04 24 88 78 10 80 	movl   $0x80107888,(%esp)
801048c2:	e8 99 ba ff ff       	call   80100360 <panic>
801048c7:	89 f6                	mov    %esi,%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048d0 <argfd.constprop.0>:
}

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	89 c6                	mov    %eax,%esi
801048d6:	53                   	push   %ebx
801048d7:	89 d3                	mov    %edx,%ebx
801048d9:	83 ec 20             	sub    $0x20,%esp
{
	int fd;
	struct file *f;

	if(argint(n, &fd) < 0)
801048dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048df:	89 44 24 04          	mov    %eax,0x4(%esp)
801048e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048ea:	e8 e1 fc ff ff       	call   801045d0 <argint>
801048ef:	85 c0                	test   %eax,%eax
801048f1:	78 2d                	js     80104920 <argfd.constprop.0+0x50>
		return -1;
	if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801048f3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048f7:	77 27                	ja     80104920 <argfd.constprop.0+0x50>
801048f9:	e8 02 ee ff ff       	call   80103700 <myproc>
801048fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104901:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104905:	85 c0                	test   %eax,%eax
80104907:	74 17                	je     80104920 <argfd.constprop.0+0x50>
		return -1;
	if(pfd)
80104909:	85 f6                	test   %esi,%esi
8010490b:	74 02                	je     8010490f <argfd.constprop.0+0x3f>
		*pfd = fd;
8010490d:	89 16                	mov    %edx,(%esi)
	if(pf)
8010490f:	85 db                	test   %ebx,%ebx
80104911:	74 1d                	je     80104930 <argfd.constprop.0+0x60>
		*pf = f;
80104913:	89 03                	mov    %eax,(%ebx)
	return 0;
80104915:	31 c0                	xor    %eax,%eax
}
80104917:	83 c4 20             	add    $0x20,%esp
8010491a:	5b                   	pop    %ebx
8010491b:	5e                   	pop    %esi
8010491c:	5d                   	pop    %ebp
8010491d:	c3                   	ret    
8010491e:	66 90                	xchg   %ax,%ax
80104920:	83 c4 20             	add    $0x20,%esp
{
	int fd;
	struct file *f;

	if(argint(n, &fd) < 0)
		return -1;
80104923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(pfd)
		*pfd = fd;
	if(pf)
		*pf = f;
	return 0;
}
80104928:	5b                   	pop    %ebx
80104929:	5e                   	pop    %esi
8010492a:	5d                   	pop    %ebp
8010492b:	c3                   	ret    
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return -1;
	if(pfd)
		*pfd = fd;
	if(pf)
		*pf = f;
	return 0;
80104930:	31 c0                	xor    %eax,%eax
80104932:	eb e3                	jmp    80104917 <argfd.constprop.0+0x47>
80104934:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010493a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104940 <strcat>:
int checkMyAddrs(int inum);

struct superblock sb;
int inodeLinkLog[200];

char* strcat(char* s1, const char* s2){
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	8b 45 08             	mov    0x8(%ebp),%eax
80104946:	53                   	push   %ebx
80104947:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char* b = s1;

  while (*s1) ++s1;
8010494a:	80 38 00             	cmpb   $0x0,(%eax)
8010494d:	89 c2                	mov    %eax,%edx
8010494f:	74 20                	je     80104971 <strcat+0x31>
80104951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104958:	83 c2 01             	add    $0x1,%edx
8010495b:	80 3a 00             	cmpb   $0x0,(%edx)
8010495e:	75 f8                	jne    80104958 <strcat+0x18>
  while (*s2) *s1++ = *s2++;
80104960:	0f b6 0b             	movzbl (%ebx),%ecx
80104963:	84 c9                	test   %cl,%cl
80104965:	74 11                	je     80104978 <strcat+0x38>
80104967:	90                   	nop
80104968:	83 c2 01             	add    $0x1,%edx
8010496b:	83 c3 01             	add    $0x1,%ebx
8010496e:	88 4a ff             	mov    %cl,-0x1(%edx)
80104971:	0f b6 0b             	movzbl (%ebx),%ecx
80104974:	84 c9                	test   %cl,%cl
80104976:	75 f0                	jne    80104968 <strcat+0x28>
  *s1 = 0;
80104978:	c6 02 00             	movb   $0x0,(%edx)

  return b;
}
8010497b:	5b                   	pop    %ebx
8010497c:	5d                   	pop    %ebp
8010497d:	c3                   	ret    
8010497e:	66 90                	xchg   %ax,%ax

80104980 <strcmp>:

int strcmp(const char* s1, char* s2)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104986:	53                   	push   %ebx
80104987:	8b 55 0c             	mov    0xc(%ebp),%edx
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
8010498a:	0f b6 01             	movzbl (%ecx),%eax
8010498d:	84 c0                	test   %al,%al
8010498f:	75 18                	jne    801049a9 <strcmp+0x29>
80104991:	eb 25                	jmp    801049b8 <strcmp+0x38>
80104993:	90                   	nop
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104998:	38 d8                	cmp    %bl,%al
8010499a:	75 14                	jne    801049b0 <strcmp+0x30>
8010499c:	83 c1 01             	add    $0x1,%ecx
8010499f:	0f b6 01             	movzbl (%ecx),%eax
801049a2:	83 c2 01             	add    $0x1,%edx
801049a5:	84 c0                	test   %al,%al
801049a7:	74 0f                	je     801049b8 <strcmp+0x38>
801049a9:	0f b6 1a             	movzbl (%edx),%ebx
801049ac:	84 db                	test   %bl,%bl
801049ae:	75 e8                	jne    80104998 <strcmp+0x18>
  return *(unsigned char*)s1-*(unsigned char*)s2;
801049b0:	0f b6 12             	movzbl (%edx),%edx
}
801049b3:	5b                   	pop    %ebx
801049b4:	5d                   	pop    %ebp
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
  return *(unsigned char*)s1-*(unsigned char*)s2;
801049b5:	29 d0                	sub    %edx,%eax
}
801049b7:	c3                   	ret    
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
  return *(unsigned char*)s1-*(unsigned char*)s2;
801049b8:	0f b6 12             	movzbl (%edx),%edx
801049bb:	31 c0                	xor    %eax,%eax
}
801049bd:	5b                   	pop    %ebx
801049be:	5d                   	pop    %ebp
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
  return *(unsigned char*)s1-*(unsigned char*)s2;
801049bf:	29 d0                	sub    %edx,%eax
}
801049c1:	c3                   	ret    
801049c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049d0 <strcpy>:

char* strcpy(char* s1, const char* s2)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	8b 45 08             	mov    0x8(%ebp),%eax
801049d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801049d9:	53                   	push   %ebx
  char* b = s1;
  while ((*s1++=*s2++));
801049da:	89 c2                	mov    %eax,%edx
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e0:	83 c1 01             	add    $0x1,%ecx
801049e3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
801049e7:	83 c2 01             	add    $0x1,%edx
801049ea:	84 db                	test   %bl,%bl
801049ec:	88 5a ff             	mov    %bl,-0x1(%edx)
801049ef:	75 ef                	jne    801049e0 <strcpy+0x10>
  return b;
}
801049f1:	5b                   	pop    %ebx
801049f2:	5d                   	pop    %ebp
801049f3:	c3                   	ret    
801049f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a00 <pathCat>:
		}
	}
	//iunlock(ip);
}

char * pathCat(char * path, char * subname){
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	8b 45 08             	mov    0x8(%ebp),%eax
80104a06:	53                   	push   %ebx
80104a07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
int inodeLinkLog[200];

char* strcat(char* s1, const char* s2){
  char* b = s1;

  while (*s1) ++s1;
80104a0a:	80 38 00             	cmpb   $0x0,(%eax)
80104a0d:	89 c2                	mov    %eax,%edx
80104a0f:	74 0f                	je     80104a20 <pathCat+0x20>
80104a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a18:	83 c2 01             	add    $0x1,%edx
80104a1b:	80 3a 00             	cmpb   $0x0,(%edx)
80104a1e:	75 f8                	jne    80104a18 <pathCat+0x18>
  while (*s2) *s1++ = *s2++;
80104a20:	c6 02 2f             	movb   $0x2f,(%edx)
  *s1 = 0;
80104a23:	c6 42 01 00          	movb   $0x0,0x1(%edx)
int inodeLinkLog[200];

char* strcat(char* s1, const char* s2){
  char* b = s1;

  while (*s1) ++s1;
80104a27:	89 c2                	mov    %eax,%edx
80104a29:	80 38 00             	cmpb   $0x0,(%eax)
80104a2c:	74 0a                	je     80104a38 <pathCat+0x38>
80104a2e:	66 90                	xchg   %ax,%ax
80104a30:	83 c2 01             	add    $0x1,%edx
80104a33:	80 3a 00             	cmpb   $0x0,(%edx)
80104a36:	75 f8                	jne    80104a30 <pathCat+0x30>
  while (*s2) *s1++ = *s2++;
80104a38:	0f b6 19             	movzbl (%ecx),%ebx
80104a3b:	84 db                	test   %bl,%bl
80104a3d:	74 11                	je     80104a50 <pathCat+0x50>
80104a3f:	90                   	nop
80104a40:	83 c2 01             	add    $0x1,%edx
80104a43:	83 c1 01             	add    $0x1,%ecx
80104a46:	88 5a ff             	mov    %bl,-0x1(%edx)
80104a49:	0f b6 19             	movzbl (%ecx),%ebx
80104a4c:	84 db                	test   %bl,%bl
80104a4e:	75 f0                	jne    80104a40 <pathCat+0x40>
  *s1 = 0;
80104a50:	c6 02 00             	movb   $0x0,(%edx)
	char * res;
	char * test = path;
	res = strcat(test,"/");
	res = strcat(res,subname);
	return res;
}
80104a53:	5b                   	pop    %ebx
80104a54:	5d                   	pop    %ebp
80104a55:	c3                   	ret    
80104a56:	8d 76 00             	lea    0x0(%esi),%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a60 <checkMyAddrs>:

int checkMyAddrs(int inum){
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 14             	sub    $0x14,%esp
80104a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	readsb(1,&sb); // Read superblock
80104a6a:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80104a71:	80 
80104a72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a79:	e8 22 c9 ff ff       	call   801013a0 <readsb>
	struct buf *bp;
	struct dinode *dip;

	bp = bread(1, IBLOCK(inum, sb));
80104a7e:	89 d8                	mov    %ebx,%eax
	dip = (struct dinode*)bp->data + inum%IPB;
80104a80:	83 e3 07             	and    $0x7,%ebx
int checkMyAddrs(int inum){
	readsb(1,&sb); // Read superblock
	struct buf *bp;
	struct dinode *dip;

	bp = bread(1, IBLOCK(inum, sb));
80104a83:	c1 e8 03             	shr    $0x3,%eax
80104a86:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80104a8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a93:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a97:	e8 34 b6 ff ff       	call   801000d0 <bread>
	dip = (struct dinode*)bp->data + inum%IPB;
80104a9c:	89 da                	mov    %ebx,%edx
80104a9e:	c1 e2 06             	shl    $0x6,%edx
80104aa1:	8d 4c 10 5c          	lea    0x5c(%eax,%edx,1),%ecx

	int addrsIndex;
	for(addrsIndex=0; addrsIndex<NDIRECT; addrsIndex++){
80104aa5:	31 d2                	xor    %edx,%edx
80104aa7:	90                   	nop
		if( dip->addrs[addrsIndex] ==-1){
80104aa8:	83 7c 91 0c ff       	cmpl   $0xffffffff,0xc(%ecx,%edx,4)
80104aad:	74 21                	je     80104ad0 <checkMyAddrs+0x70>

	bp = bread(1, IBLOCK(inum, sb));
	dip = (struct dinode*)bp->data + inum%IPB;

	int addrsIndex;
	for(addrsIndex=0; addrsIndex<NDIRECT; addrsIndex++){
80104aaf:	83 c2 01             	add    $0x1,%edx
80104ab2:	83 fa 0c             	cmp    $0xc,%edx
80104ab5:	75 f1                	jne    80104aa8 <checkMyAddrs+0x48>
		if( dip->addrs[addrsIndex] ==-1){
			return 0;
		}
	}
	brelse(bp);
80104ab7:	89 04 24             	mov    %eax,(%esp)
80104aba:	e8 21 b7 ff ff       	call   801001e0 <brelse>
	//check recusively for the indirect links block pointers
	return 1;
}
80104abf:	83 c4 14             	add    $0x14,%esp
			return 0;
		}
	}
	brelse(bp);
	//check recusively for the indirect links block pointers
	return 1;
80104ac2:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104ac7:	5b                   	pop    %ebx
80104ac8:	5d                   	pop    %ebp
80104ac9:	c3                   	ret    
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ad0:	83 c4 14             	add    $0x14,%esp
	dip = (struct dinode*)bp->data + inum%IPB;

	int addrsIndex;
	for(addrsIndex=0; addrsIndex<NDIRECT; addrsIndex++){
		if( dip->addrs[addrsIndex] ==-1){
			return 0;
80104ad3:	31 c0                	xor    %eax,%eax
		}
	}
	brelse(bp);
	//check recusively for the indirect links block pointers
	return 1;
}
80104ad5:	5b                   	pop    %ebx
80104ad6:	5d                   	pop    %ebp
80104ad7:	c3                   	ret    
80104ad8:	90                   	nop
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <subRoutine>:
	for(inodeNum = 0; inodeNum<25;inodeNum++){
		cprintf("%d",inodeLinkLog[inodeNum]);
	}
	return 0;
}
void subRoutine(char* path){
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	56                   	push   %esi
80104ae5:	53                   	push   %ebx
80104ae6:	83 ec 2c             	sub    $0x2c,%esp
	uint off, inum;
	struct dirent de;
	struct inode * ip = namei(path);
80104ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80104aec:	89 04 24             	mov    %eax,(%esp)
80104aef:	e8 6c d4 ff ff       	call   80101f60 <namei>
80104af4:	89 c7                	mov    %eax,%edi
	//maybe have check for namei results
	//ilock(ip);
	inum = ip->inum;
80104af6:	8b 40 04             	mov    0x4(%eax),%eax
	inodeLinkLog[inum]++;
80104af9:	83 04 85 60 4c 11 80 	addl   $0x1,-0x7feeb3a0(,%eax,4)
80104b00:	01 
	if(ip->type == T_DIR){
80104b01:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80104b06:	74 08                	je     80104b10 <subRoutine+0x30>
				//ilock(ip);
			}
		}
	}
	//iunlock(ip);
}
80104b08:	83 c4 2c             	add    $0x2c,%esp
80104b0b:	5b                   	pop    %ebx
80104b0c:	5e                   	pop    %esi
80104b0d:	5f                   	pop    %edi
80104b0e:	5d                   	pop    %ebp
80104b0f:	c3                   	ret    
	//ilock(ip);
	inum = ip->inum;
	inodeLinkLog[inum]++;
	if(ip->type == T_DIR){
		// The specified path is a directory, go through its directory entries
		for(off = 0; off < ip->size; off += sizeof(de)){
80104b10:	8b 47 58             	mov    0x58(%edi),%eax
80104b13:	85 c0                	test   %eax,%eax
80104b15:	74 f1                	je     80104b08 <subRoutine+0x28>
80104b17:	31 f6                	xor    %esi,%esi
80104b19:	eb 0d                	jmp    80104b28 <subRoutine+0x48>
80104b1b:	90                   	nop
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b20:	83 c6 10             	add    $0x10,%esi
80104b23:	39 77 58             	cmp    %esi,0x58(%edi)
80104b26:	76 e0                	jbe    80104b08 <subRoutine+0x28>
			if(readi(ip, (char*)&de, off, sizeof(de)) != sizeof(de)){
80104b28:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104b2b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104b32:	00 
80104b33:	89 74 24 08          	mov    %esi,0x8(%esp)
80104b37:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b3b:	89 3c 24             	mov    %edi,(%esp)
80104b3e:	e8 7d ce ff ff       	call   801019c0 <readi>
80104b43:	83 f8 10             	cmp    $0x10,%eax
80104b46:	0f 85 08 01 00 00    	jne    80104c54 <subRoutine+0x174>
				// Reading was not successful
				panic("dirlookup read");
			}
			if(de.inum == 0){
80104b4c:	0f b7 45 d8          	movzwl -0x28(%ebp),%eax
80104b50:	66 85 c0             	test   %ax,%ax
80104b53:	74 cb                	je     80104b20 <subRoutine+0x40>
				// Inode is not allocated
				continue;
			}
			cprintf("DE.name is %s inode# %d\n",de.name,de.inum);
80104b55:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b59:	8d 45 da             	lea    -0x26(%ebp),%eax
80104b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b60:	c7 04 24 b6 78 10 80 	movl   $0x801078b6,(%esp)
80104b67:	e8 e4 ba ff ff       	call   80100650 <cprintf>
  return b;
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
80104b6c:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
80104b70:	84 c0                	test   %al,%al
80104b72:	0f 84 c4 00 00 00    	je     80104c3c <subRoutine+0x15c>
80104b78:	3c 2e                	cmp    $0x2e,%al
80104b7a:	0f 85 c8 00 00 00    	jne    80104c48 <subRoutine+0x168>
80104b80:	80 7d db 00          	cmpb   $0x0,-0x25(%ebp)
			if(de.inum == 0){
				// Inode is not allocated
				continue;
			}
			cprintf("DE.name is %s inode# %d\n",de.name,de.inum);
			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
80104b84:	b8 a3 78 10 80       	mov    $0x801078a3,%eax
80104b89:	8d 55 da             	lea    -0x26(%ebp),%edx
  return b;
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
80104b8c:	75 0d                	jne    80104b9b <subRoutine+0xbb>
80104b8e:	eb 90                	jmp    80104b20 <subRoutine+0x40>
80104b90:	0f b6 18             	movzbl (%eax),%ebx
80104b93:	84 db                	test   %bl,%bl
80104b95:	74 13                	je     80104baa <subRoutine+0xca>
80104b97:	38 d9                	cmp    %bl,%cl
80104b99:	75 0f                	jne    80104baa <subRoutine+0xca>
80104b9b:	83 c2 01             	add    $0x1,%edx
80104b9e:	0f b6 0a             	movzbl (%edx),%ecx
80104ba1:	83 c0 01             	add    $0x1,%eax
80104ba4:	84 c9                	test   %cl,%cl
80104ba6:	75 e8                	jne    80104b90 <subRoutine+0xb0>
80104ba8:	31 c9                	xor    %ecx,%ecx
			if(de.inum == 0){
				// Inode is not allocated
				continue;
			}
			cprintf("DE.name is %s inode# %d\n",de.name,de.inum);
			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
80104baa:	38 08                	cmp    %cl,(%eax)
80104bac:	0f 84 6e ff ff ff    	je     80104b20 <subRoutine+0x40>
				continue;
			}
			if(checkMyAddrs(de.inum)){
80104bb2:	0f b7 45 d8          	movzwl -0x28(%ebp),%eax
80104bb6:	89 04 24             	mov    %eax,(%esp)
80104bb9:	e8 a2 fe ff ff       	call   80104a60 <checkMyAddrs>
80104bbe:	85 c0                	test   %eax,%eax
80104bc0:	0f 84 5a ff ff ff    	je     80104b20 <subRoutine+0x40>
				cprintf("path before %s\n", path);
80104bc6:	8b 45 08             	mov    0x8(%ebp),%eax
80104bc9:	c7 04 24 cf 78 10 80 	movl   $0x801078cf,(%esp)
80104bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bd4:	e8 77 ba ff ff       	call   80100650 <cprintf>
80104bd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bdc:	b8 a4 78 10 80       	mov    $0x801078a4,%eax
80104be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

char* strcpy(char* s1, const char* s2)
{
  char* b = s1;
  while ((*s1++=*s2++));
80104be8:	83 c1 01             	add    $0x1,%ecx
80104beb:	0f b6 51 ff          	movzbl -0x1(%ecx),%edx
80104bef:	83 c0 01             	add    $0x1,%eax
80104bf2:	84 d2                	test   %dl,%dl
80104bf4:	88 50 ff             	mov    %dl,-0x1(%eax)
80104bf7:	75 ef                	jne    80104be8 <subRoutine+0x108>

char* strcat(char* s1, const char* s2){
  char* b = s1;

  while (*s1) ++s1;
  while (*s2) *s1++ = *s2++;
80104bf9:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
80104bfd:	84 c0                	test   %al,%al
80104bff:	74 34                	je     80104c35 <subRoutine+0x155>
80104c01:	8d 4d da             	lea    -0x26(%ebp),%ecx
80104c04:	ba cf 76 10 80       	mov    $0x801076cf,%edx
80104c09:	83 c2 01             	add    $0x1,%edx
80104c0c:	83 c1 01             	add    $0x1,%ecx
80104c0f:	88 42 ff             	mov    %al,-0x1(%edx)
80104c12:	0f b6 01             	movzbl (%ecx),%eax
80104c15:	84 c0                	test   %al,%al
80104c17:	75 f0                	jne    80104c09 <subRoutine+0x129>
  *s1 = 0;
80104c19:	c6 02 00             	movb   $0x0,(%edx)
				strcpy(new_path,path);
				char *slash = "/";
				slash = strcat(slash,de.name);
				//new_path = strcat(new_path,slash);
				//iunlock(ip);
				cprintf("path after %s\n", new_path);
80104c1c:	c7 44 24 04 a4 78 10 	movl   $0x801078a4,0x4(%esp)
80104c23:	80 
80104c24:	c7 04 24 df 78 10 80 	movl   $0x801078df,(%esp)
80104c2b:	e8 20 ba ff ff       	call   80100650 <cprintf>
80104c30:	e9 eb fe ff ff       	jmp    80104b20 <subRoutine+0x40>

char* strcat(char* s1, const char* s2){
  char* b = s1;

  while (*s1) ++s1;
  while (*s2) *s1++ = *s2++;
80104c35:	ba cf 76 10 80       	mov    $0x801076cf,%edx
80104c3a:	eb dd                	jmp    80104c19 <subRoutine+0x139>
  return b;
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
80104c3c:	31 c9                	xor    %ecx,%ecx
80104c3e:	b8 a3 78 10 80       	mov    $0x801078a3,%eax
80104c43:	e9 62 ff ff ff       	jmp    80104baa <subRoutine+0xca>
80104c48:	89 c1                	mov    %eax,%ecx
			if(de.inum == 0){
				// Inode is not allocated
				continue;
			}
			cprintf("DE.name is %s inode# %d\n",de.name,de.inum);
			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
80104c4a:	b8 a3 78 10 80       	mov    $0x801078a3,%eax
80104c4f:	e9 56 ff ff ff       	jmp    80104baa <subRoutine+0xca>
	if(ip->type == T_DIR){
		// The specified path is a directory, go through its directory entries
		for(off = 0; off < ip->size; off += sizeof(de)){
			if(readi(ip, (char*)&de, off, sizeof(de)) != sizeof(de)){
				// Reading was not successful
				panic("dirlookup read");
80104c54:	c7 04 24 99 72 10 80 	movl   $0x80107299,(%esp)
80104c5b:	e8 00 b7 ff ff       	call   80100360 <panic>

80104c60 <sys_directoryWalker>:
  char* b = s1;
  while ((*s1++=*s2++));
  return b;
}

int sys_directoryWalker(void){
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	53                   	push   %ebx
80104c64:	83 ec 24             	sub    $0x24,%esp
	char *path;
	argstr(0,&path);
80104c67:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c75:	e8 e6 f9 ff ff       	call   80104660 <argstr>
	//initialize link log
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80104c7a:	31 c0                	xor    %eax,%eax
80104c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		inodeLinkLog[inodeNum]=0;
80104c80:	c7 04 85 60 4c 11 80 	movl   $0x0,-0x7feeb3a0(,%eax,4)
80104c87:	00 00 00 00 
int sys_directoryWalker(void){
	char *path;
	argstr(0,&path);
	//initialize link log
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80104c8b:	83 c0 01             	add    $0x1,%eax
80104c8e:	3d c8 00 00 00       	cmp    $0xc8,%eax
80104c93:	75 eb                	jne    80104c80 <sys_directoryWalker+0x20>
		inodeLinkLog[inodeNum]=0;
	}
	subRoutine(path);
80104c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
	for(inodeNum = 0; inodeNum<25;inodeNum++){
80104c98:	31 db                	xor    %ebx,%ebx
	//initialize link log
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeLinkLog[inodeNum]=0;
	}
	subRoutine(path);
80104c9a:	89 04 24             	mov    %eax,(%esp)
80104c9d:	e8 3e fe ff ff       	call   80104ae0 <subRoutine>
80104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for(inodeNum = 0; inodeNum<25;inodeNum++){
		cprintf("%d",inodeLinkLog[inodeNum]);
80104ca8:	8b 04 9d 60 4c 11 80 	mov    -0x7feeb3a0(,%ebx,4),%eax
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeLinkLog[inodeNum]=0;
	}
	subRoutine(path);
	for(inodeNum = 0; inodeNum<25;inodeNum++){
80104caf:	83 c3 01             	add    $0x1,%ebx
		cprintf("%d",inodeLinkLog[inodeNum]);
80104cb2:	c7 04 24 ee 78 10 80 	movl   $0x801078ee,(%esp)
80104cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cbd:	e8 8e b9 ff ff       	call   80100650 <cprintf>
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeLinkLog[inodeNum]=0;
	}
	subRoutine(path);
	for(inodeNum = 0; inodeNum<25;inodeNum++){
80104cc2:	83 fb 19             	cmp    $0x19,%ebx
80104cc5:	75 e1                	jne    80104ca8 <sys_directoryWalker+0x48>
		cprintf("%d",inodeLinkLog[inodeNum]);
	}
	return 0;
}
80104cc7:	83 c4 24             	add    $0x24,%esp
80104cca:	31 c0                	xor    %eax,%eax
80104ccc:	5b                   	pop    %ebx
80104ccd:	5d                   	pop    %ebp
80104cce:	c3                   	ret    
80104ccf:	90                   	nop

80104cd0 <sys_inodeTBWalker>:
	brelse(bp);
	//check recusively for the indirect links block pointers
	return 1;
}

int sys_inodeTBWalker(void){
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
	for(inum = 1; inum < sb.ninodes; inum++){
80104cd4:	be 01 00 00 00       	mov    $0x1,%esi
	brelse(bp);
	//check recusively for the indirect links block pointers
	return 1;
}

int sys_inodeTBWalker(void){
80104cd9:	53                   	push   %ebx
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
	for(inum = 1; inum < sb.ninodes; inum++){
80104cda:	bb 01 00 00 00       	mov    $0x1,%ebx
	brelse(bp);
	//check recusively for the indirect links block pointers
	return 1;
}

int sys_inodeTBWalker(void){
80104cdf:	83 ec 20             	sub    $0x20,%esp
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
80104ce2:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80104ce9:	80 
80104cea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104cf1:	e8 aa c6 ff ff       	call   801013a0 <readsb>
	for(inum = 1; inum < sb.ninodes; inum++){
80104cf6:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
80104cfd:	77 1e                	ja     80104d1d <sys_inodeTBWalker+0x4d>
80104cff:	eb 6f                	jmp    80104d70 <sys_inodeTBWalker+0xa0>
80104d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		dip = (struct dinode*)bp->data + inum%IPB;
		if(dip->type != 0){  // not a free inode
			// Found allocated inode
			cprintf("inode#: %d \t type: %d \t links: %d\n",inum,dip->type,dip->nlink);
		}
		brelse(bp);
80104d08:	89 04 24             	mov    %eax,(%esp)
int sys_inodeTBWalker(void){
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
	for(inum = 1; inum < sb.ninodes; inum++){
80104d0b:	83 c3 01             	add    $0x1,%ebx
		dip = (struct dinode*)bp->data + inum%IPB;
		if(dip->type != 0){  // not a free inode
			// Found allocated inode
			cprintf("inode#: %d \t type: %d \t links: %d\n",inum,dip->type,dip->nlink);
		}
		brelse(bp);
80104d0e:	e8 cd b4 ff ff       	call   801001e0 <brelse>
int sys_inodeTBWalker(void){
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
	for(inum = 1; inum < sb.ninodes; inum++){
80104d13:	89 de                	mov    %ebx,%esi
80104d15:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80104d1b:	73 53                	jae    80104d70 <sys_inodeTBWalker+0xa0>
		bp = bread(1, IBLOCK(inum, sb));
80104d1d:	89 f0                	mov    %esi,%eax
		dip = (struct dinode*)bp->data + inum%IPB;
80104d1f:	83 e6 07             	and    $0x7,%esi
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
	for(inum = 1; inum < sb.ninodes; inum++){
		bp = bread(1, IBLOCK(inum, sb));
80104d22:	c1 e8 03             	shr    $0x3,%eax
80104d25:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80104d2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d32:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d36:	e8 95 b3 ff ff       	call   801000d0 <bread>
		dip = (struct dinode*)bp->data + inum%IPB;
80104d3b:	89 f2                	mov    %esi,%edx
80104d3d:	c1 e2 06             	shl    $0x6,%edx
80104d40:	8d 4c 10 5c          	lea    0x5c(%eax,%edx,1),%ecx
		if(dip->type != 0){  // not a free inode
80104d44:	0f bf 11             	movswl (%ecx),%edx
80104d47:	66 85 d2             	test   %dx,%dx
80104d4a:	74 bc                	je     80104d08 <sys_inodeTBWalker+0x38>
			// Found allocated inode
			cprintf("inode#: %d \t type: %d \t links: %d\n",inum,dip->type,dip->nlink);
80104d4c:	0f bf 49 06          	movswl 0x6(%ecx),%ecx
80104d50:	89 54 24 08          	mov    %edx,0x8(%esp)
80104d54:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d58:	c7 04 24 24 79 10 80 	movl   $0x80107924,(%esp)
80104d5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80104d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104d66:	e8 e5 b8 ff ff       	call   80100650 <cprintf>
80104d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6e:	eb 98                	jmp    80104d08 <sys_inodeTBWalker+0x38>
		}
		brelse(bp);
	}
	return 0;
}
80104d70:	83 c4 20             	add    $0x20,%esp
80104d73:	31 c0                	xor    %eax,%eax
80104d75:	5b                   	pop    %ebx
80104d76:	5e                   	pop    %esi
80104d77:	5d                   	pop    %ebp
80104d78:	c3                   	ret    
80104d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d80 <sys_deleteIData>:

int sys_deleteIData(void){
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	83 ec 28             	sub    $0x28,%esp

	inodeToDel = calliget(inum);
	cprintf("\n\n---> inode#: %d \t type: %d\n\n",inodeToDel->inum,inodeToDel->type);
	 */
	int inum;
	argint(0,&inum);
80104d86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d89:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d94:	e8 37 f8 ff ff       	call   801045d0 <argint>
	calliget(inum);
80104d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9c:	89 04 24             	mov    %eax,(%esp)
80104d9f:	e8 3c ca ff ff       	call   801017e0 <calliget>
	return 0;
}
80104da4:	31 c0                	xor    %eax,%eax
80104da6:	c9                   	leave  
80104da7:	c3                   	ret    
80104da8:	90                   	nop
80104da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104db0 <sys_dup>:
	return -1;
}

int
sys_dup(void)
{
80104db0:	55                   	push   %ebp
	struct file *f;
	int fd;

	if(argfd(0, 0, &f) < 0)
80104db1:	31 c0                	xor    %eax,%eax
	return -1;
}

int
sys_dup(void)
{
80104db3:	89 e5                	mov    %esp,%ebp
80104db5:	53                   	push   %ebx
80104db6:	83 ec 24             	sub    $0x24,%esp
	struct file *f;
	int fd;

	if(argfd(0, 0, &f) < 0)
80104db9:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104dbc:	e8 0f fb ff ff       	call   801048d0 <argfd.constprop.0>
80104dc1:	85 c0                	test   %eax,%eax
80104dc3:	78 23                	js     80104de8 <sys_dup+0x38>
		return -1;
	if((fd=fdalloc(f)) < 0)
80104dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc8:	e8 43 f9 ff ff       	call   80104710 <fdalloc>
80104dcd:	85 c0                	test   %eax,%eax
80104dcf:	89 c3                	mov    %eax,%ebx
80104dd1:	78 15                	js     80104de8 <sys_dup+0x38>
		return -1;
	filedup(f);
80104dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd6:	89 04 24             	mov    %eax,(%esp)
80104dd9:	e8 02 c0 ff ff       	call   80100de0 <filedup>
	return fd;
80104dde:	89 d8                	mov    %ebx,%eax
}
80104de0:	83 c4 24             	add    $0x24,%esp
80104de3:	5b                   	pop    %ebx
80104de4:	5d                   	pop    %ebp
80104de5:	c3                   	ret    
80104de6:	66 90                	xchg   %ax,%ax
{
	struct file *f;
	int fd;

	if(argfd(0, 0, &f) < 0)
		return -1;
80104de8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ded:	eb f1                	jmp    80104de0 <sys_dup+0x30>
80104def:	90                   	nop

80104df0 <sys_read>:
	return fd;
}

int
sys_read(void)
{
80104df0:	55                   	push   %ebp
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104df1:	31 c0                	xor    %eax,%eax
	return fd;
}

int
sys_read(void)
{
80104df3:	89 e5                	mov    %esp,%ebp
80104df5:	83 ec 28             	sub    $0x28,%esp
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104df8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104dfb:	e8 d0 fa ff ff       	call   801048d0 <argfd.constprop.0>
80104e00:	85 c0                	test   %eax,%eax
80104e02:	78 54                	js     80104e58 <sys_read+0x68>
80104e04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e0b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104e12:	e8 b9 f7 ff ff       	call   801045d0 <argint>
80104e17:	85 c0                	test   %eax,%eax
80104e19:	78 3d                	js     80104e58 <sys_read+0x68>
80104e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e25:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e29:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e30:	e8 cb f7 ff ff       	call   80104600 <argptr>
80104e35:	85 c0                	test   %eax,%eax
80104e37:	78 1f                	js     80104e58 <sys_read+0x68>
		return -1;
	return fileread(f, p, n);
80104e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e3c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e43:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e4a:	89 04 24             	mov    %eax,(%esp)
80104e4d:	e8 ee c0 ff ff       	call   80100f40 <fileread>
}
80104e52:	c9                   	leave  
80104e53:	c3                   	ret    
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
		return -1;
80104e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return fileread(f, p, n);
}
80104e5d:	c9                   	leave  
80104e5e:	c3                   	ret    
80104e5f:	90                   	nop

80104e60 <sys_write>:

int
sys_write(void)
{
80104e60:	55                   	push   %ebp
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e61:	31 c0                	xor    %eax,%eax
	return fileread(f, p, n);
}

int
sys_write(void)
{
80104e63:	89 e5                	mov    %esp,%ebp
80104e65:	83 ec 28             	sub    $0x28,%esp
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e6b:	e8 60 fa ff ff       	call   801048d0 <argfd.constprop.0>
80104e70:	85 c0                	test   %eax,%eax
80104e72:	78 54                	js     80104ec8 <sys_write+0x68>
80104e74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e7b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104e82:	e8 49 f7 ff ff       	call   801045d0 <argint>
80104e87:	85 c0                	test   %eax,%eax
80104e89:	78 3d                	js     80104ec8 <sys_write+0x68>
80104e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e95:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ea0:	e8 5b f7 ff ff       	call   80104600 <argptr>
80104ea5:	85 c0                	test   %eax,%eax
80104ea7:	78 1f                	js     80104ec8 <sys_write+0x68>
		return -1;
	return filewrite(f, p, n);
80104ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eac:	89 44 24 08          	mov    %eax,0x8(%esp)
80104eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104eba:	89 04 24             	mov    %eax,(%esp)
80104ebd:	e8 1e c1 ff ff       	call   80100fe0 <filewrite>
}
80104ec2:	c9                   	leave  
80104ec3:	c3                   	ret    
80104ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
		return -1;
80104ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return filewrite(f, p, n);
}
80104ecd:	c9                   	leave  
80104ece:	c3                   	ret    
80104ecf:	90                   	nop

80104ed0 <sys_close>:

int
sys_close(void)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	83 ec 28             	sub    $0x28,%esp
	int fd;
	struct file *f;

	if(argfd(0, &fd, &f) < 0)
80104ed6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ed9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104edc:	e8 ef f9 ff ff       	call   801048d0 <argfd.constprop.0>
80104ee1:	85 c0                	test   %eax,%eax
80104ee3:	78 23                	js     80104f08 <sys_close+0x38>
		return -1;
	myproc()->ofile[fd] = 0;
80104ee5:	e8 16 e8 ff ff       	call   80103700 <myproc>
80104eea:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104eed:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ef4:	00 
	fileclose(f);
80104ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef8:	89 04 24             	mov    %eax,(%esp)
80104efb:	e8 30 bf ff ff       	call   80100e30 <fileclose>
	return 0;
80104f00:	31 c0                	xor    %eax,%eax
}
80104f02:	c9                   	leave  
80104f03:	c3                   	ret    
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
	int fd;
	struct file *f;

	if(argfd(0, &fd, &f) < 0)
		return -1;
80104f08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	myproc()->ofile[fd] = 0;
	fileclose(f);
	return 0;
}
80104f0d:	c9                   	leave  
80104f0e:	c3                   	ret    
80104f0f:	90                   	nop

80104f10 <sys_fstat>:

int
sys_fstat(void)
{
80104f10:	55                   	push   %ebp
	struct file *f;
	struct stat *st;

	if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f11:	31 c0                	xor    %eax,%eax
	return 0;
}

int
sys_fstat(void)
{
80104f13:	89 e5                	mov    %esp,%ebp
80104f15:	83 ec 28             	sub    $0x28,%esp
	struct file *f;
	struct stat *st;

	if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f18:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f1b:	e8 b0 f9 ff ff       	call   801048d0 <argfd.constprop.0>
80104f20:	85 c0                	test   %eax,%eax
80104f22:	78 34                	js     80104f58 <sys_fstat+0x48>
80104f24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f27:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104f2e:	00 
80104f2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f3a:	e8 c1 f6 ff ff       	call   80104600 <argptr>
80104f3f:	85 c0                	test   %eax,%eax
80104f41:	78 15                	js     80104f58 <sys_fstat+0x48>
		return -1;
	return filestat(f, st);
80104f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f46:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f4d:	89 04 24             	mov    %eax,(%esp)
80104f50:	e8 9b bf ff ff       	call   80100ef0 <filestat>
}
80104f55:	c9                   	leave  
80104f56:	c3                   	ret    
80104f57:	90                   	nop
{
	struct file *f;
	struct stat *st;

	if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
		return -1;
80104f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return filestat(f, st);
}
80104f5d:	c9                   	leave  
80104f5e:	c3                   	ret    
80104f5f:	90                   	nop

80104f60 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	57                   	push   %edi
80104f64:	56                   	push   %esi
80104f65:	53                   	push   %ebx
80104f66:	83 ec 3c             	sub    $0x3c,%esp
	char name[DIRSIZ], *new, *old;
	struct inode *dp, *ip;

	if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f69:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f77:	e8 e4 f6 ff ff       	call   80104660 <argstr>
80104f7c:	85 c0                	test   %eax,%eax
80104f7e:	0f 88 e6 00 00 00    	js     8010506a <sys_link+0x10a>
80104f84:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f92:	e8 c9 f6 ff ff       	call   80104660 <argstr>
80104f97:	85 c0                	test   %eax,%eax
80104f99:	0f 88 cb 00 00 00    	js     8010506a <sys_link+0x10a>
		return -1;

	begin_op();
80104f9f:	e8 cc db ff ff       	call   80102b70 <begin_op>
	if((ip = namei(old)) == 0){
80104fa4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104fa7:	89 04 24             	mov    %eax,(%esp)
80104faa:	e8 b1 cf ff ff       	call   80101f60 <namei>
80104faf:	85 c0                	test   %eax,%eax
80104fb1:	89 c3                	mov    %eax,%ebx
80104fb3:	0f 84 ac 00 00 00    	je     80105065 <sys_link+0x105>
		end_op();
		return -1;
	}

	ilock(ip);
80104fb9:	89 04 24             	mov    %eax,(%esp)
80104fbc:	e8 ff c6 ff ff       	call   801016c0 <ilock>
	if(ip->type == T_DIR){
80104fc1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fc6:	0f 84 91 00 00 00    	je     8010505d <sys_link+0xfd>
		iunlockput(ip);
		end_op();
		return -1;
	}

	ip->nlink++;
80104fcc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
	iupdate(ip);
	iunlock(ip);

	if((dp = nameiparent(new, name)) == 0)
80104fd1:	8d 7d da             	lea    -0x26(%ebp),%edi
		end_op();
		return -1;
	}

	ip->nlink++;
	iupdate(ip);
80104fd4:	89 1c 24             	mov    %ebx,(%esp)
80104fd7:	e8 24 c6 ff ff       	call   80101600 <iupdate>
	iunlock(ip);
80104fdc:	89 1c 24             	mov    %ebx,(%esp)
80104fdf:	e8 bc c7 ff ff       	call   801017a0 <iunlock>

	if((dp = nameiparent(new, name)) == 0)
80104fe4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104fe7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104feb:	89 04 24             	mov    %eax,(%esp)
80104fee:	e8 8d cf ff ff       	call   80101f80 <nameiparent>
80104ff3:	85 c0                	test   %eax,%eax
80104ff5:	89 c6                	mov    %eax,%esi
80104ff7:	74 4f                	je     80105048 <sys_link+0xe8>
		goto bad;
	ilock(dp);
80104ff9:	89 04 24             	mov    %eax,(%esp)
80104ffc:	e8 bf c6 ff ff       	call   801016c0 <ilock>
	if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105001:	8b 03                	mov    (%ebx),%eax
80105003:	39 06                	cmp    %eax,(%esi)
80105005:	75 39                	jne    80105040 <sys_link+0xe0>
80105007:	8b 43 04             	mov    0x4(%ebx),%eax
8010500a:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010500e:	89 34 24             	mov    %esi,(%esp)
80105011:	89 44 24 08          	mov    %eax,0x8(%esp)
80105015:	e8 66 ce ff ff       	call   80101e80 <dirlink>
8010501a:	85 c0                	test   %eax,%eax
8010501c:	78 22                	js     80105040 <sys_link+0xe0>
		iunlockput(dp);
		goto bad;
	}
	iunlockput(dp);
8010501e:	89 34 24             	mov    %esi,(%esp)
80105021:	e8 4a c9 ff ff       	call   80101970 <iunlockput>
	iput(ip);
80105026:	89 1c 24             	mov    %ebx,(%esp)
80105029:	e8 02 c8 ff ff       	call   80101830 <iput>

	end_op();
8010502e:	e8 ad db ff ff       	call   80102be0 <end_op>
	ip->nlink--;
	iupdate(ip);
	iunlockput(ip);
	end_op();
	return -1;
}
80105033:	83 c4 3c             	add    $0x3c,%esp
	iunlockput(dp);
	iput(ip);

	end_op();

	return 0;
80105036:	31 c0                	xor    %eax,%eax
	ip->nlink--;
	iupdate(ip);
	iunlockput(ip);
	end_op();
	return -1;
}
80105038:	5b                   	pop    %ebx
80105039:	5e                   	pop    %esi
8010503a:	5f                   	pop    %edi
8010503b:	5d                   	pop    %ebp
8010503c:	c3                   	ret    
8010503d:	8d 76 00             	lea    0x0(%esi),%esi

	if((dp = nameiparent(new, name)) == 0)
		goto bad;
	ilock(dp);
	if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
		iunlockput(dp);
80105040:	89 34 24             	mov    %esi,(%esp)
80105043:	e8 28 c9 ff ff       	call   80101970 <iunlockput>
	end_op();

	return 0;

	bad:
	ilock(ip);
80105048:	89 1c 24             	mov    %ebx,(%esp)
8010504b:	e8 70 c6 ff ff       	call   801016c0 <ilock>
	ip->nlink--;
80105050:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
80105055:	89 1c 24             	mov    %ebx,(%esp)
80105058:	e8 a3 c5 ff ff       	call   80101600 <iupdate>
	iunlockput(ip);
8010505d:	89 1c 24             	mov    %ebx,(%esp)
80105060:	e8 0b c9 ff ff       	call   80101970 <iunlockput>
	end_op();
80105065:	e8 76 db ff ff       	call   80102be0 <end_op>
	return -1;
}
8010506a:	83 c4 3c             	add    $0x3c,%esp
	ilock(ip);
	ip->nlink--;
	iupdate(ip);
	iunlockput(ip);
	end_op();
	return -1;
8010506d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105072:	5b                   	pop    %ebx
80105073:	5e                   	pop    %esi
80105074:	5f                   	pop    %edi
80105075:	5d                   	pop    %ebp
80105076:	c3                   	ret    
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	56                   	push   %esi
80105085:	53                   	push   %ebx
80105086:	83 ec 5c             	sub    $0x5c,%esp
	struct inode *ip, *dp;
	struct dirent de;
	char name[DIRSIZ], *path;
	uint off;

	if(argstr(0, &path) < 0)
80105089:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010508c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105090:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105097:	e8 c4 f5 ff ff       	call   80104660 <argstr>
8010509c:	85 c0                	test   %eax,%eax
8010509e:	0f 88 76 01 00 00    	js     8010521a <sys_unlink+0x19a>
		return -1;

	begin_op();
801050a4:	e8 c7 da ff ff       	call   80102b70 <begin_op>
	if((dp = nameiparent(path, name)) == 0){
801050a9:	8b 45 c0             	mov    -0x40(%ebp),%eax
801050ac:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801050af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801050b3:	89 04 24             	mov    %eax,(%esp)
801050b6:	e8 c5 ce ff ff       	call   80101f80 <nameiparent>
801050bb:	85 c0                	test   %eax,%eax
801050bd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801050c0:	0f 84 4f 01 00 00    	je     80105215 <sys_unlink+0x195>
		end_op();
		return -1;
	}

	ilock(dp);
801050c6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
801050c9:	89 34 24             	mov    %esi,(%esp)
801050cc:	e8 ef c5 ff ff       	call   801016c0 <ilock>

	// Cannot unlink "." or "..".
	if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050d1:	c7 44 24 04 a4 78 10 	movl   $0x801078a4,0x4(%esp)
801050d8:	80 
801050d9:	89 1c 24             	mov    %ebx,(%esp)
801050dc:	e8 0f cb ff ff       	call   80101bf0 <namecmp>
801050e1:	85 c0                	test   %eax,%eax
801050e3:	0f 84 21 01 00 00    	je     8010520a <sys_unlink+0x18a>
801050e9:	c7 44 24 04 a3 78 10 	movl   $0x801078a3,0x4(%esp)
801050f0:	80 
801050f1:	89 1c 24             	mov    %ebx,(%esp)
801050f4:	e8 f7 ca ff ff       	call   80101bf0 <namecmp>
801050f9:	85 c0                	test   %eax,%eax
801050fb:	0f 84 09 01 00 00    	je     8010520a <sys_unlink+0x18a>
		goto bad;

	if((ip = dirlookup(dp, name, &off)) == 0)
80105101:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105104:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105108:	89 44 24 08          	mov    %eax,0x8(%esp)
8010510c:	89 34 24             	mov    %esi,(%esp)
8010510f:	e8 0c cb ff ff       	call   80101c20 <dirlookup>
80105114:	85 c0                	test   %eax,%eax
80105116:	89 c3                	mov    %eax,%ebx
80105118:	0f 84 ec 00 00 00    	je     8010520a <sys_unlink+0x18a>
		goto bad;
	ilock(ip);
8010511e:	89 04 24             	mov    %eax,(%esp)
80105121:	e8 9a c5 ff ff       	call   801016c0 <ilock>

	if(ip->nlink < 1)
80105126:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010512b:	0f 8e 24 01 00 00    	jle    80105255 <sys_unlink+0x1d5>
		panic("unlink: nlink < 1");
	if(ip->type == T_DIR && !isdirempty(ip)){
80105131:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105136:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105139:	74 7d                	je     801051b8 <sys_unlink+0x138>
		iunlockput(ip);
		goto bad;
	}

	memset(&de, 0, sizeof(de));
8010513b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105142:	00 
80105143:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010514a:	00 
8010514b:	89 34 24             	mov    %esi,(%esp)
8010514e:	e8 8d f1 ff ff       	call   801042e0 <memset>
	if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105153:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105156:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010515d:	00 
8010515e:	89 74 24 04          	mov    %esi,0x4(%esp)
80105162:	89 44 24 08          	mov    %eax,0x8(%esp)
80105166:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105169:	89 04 24             	mov    %eax,(%esp)
8010516c:	e8 4f c9 ff ff       	call   80101ac0 <writei>
80105171:	83 f8 10             	cmp    $0x10,%eax
80105174:	0f 85 cf 00 00 00    	jne    80105249 <sys_unlink+0x1c9>
		panic("unlink: writei");
	if(ip->type == T_DIR){
8010517a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010517f:	0f 84 a3 00 00 00    	je     80105228 <sys_unlink+0x1a8>
		dp->nlink--;
		iupdate(dp);
	}
	iunlockput(dp);
80105185:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105188:	89 04 24             	mov    %eax,(%esp)
8010518b:	e8 e0 c7 ff ff       	call   80101970 <iunlockput>

	ip->nlink--;
80105190:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
80105195:	89 1c 24             	mov    %ebx,(%esp)
80105198:	e8 63 c4 ff ff       	call   80101600 <iupdate>
	iunlockput(ip);
8010519d:	89 1c 24             	mov    %ebx,(%esp)
801051a0:	e8 cb c7 ff ff       	call   80101970 <iunlockput>

	end_op();
801051a5:	e8 36 da ff ff       	call   80102be0 <end_op>

	bad:
	iunlockput(dp);
	end_op();
	return -1;
}
801051aa:	83 c4 5c             	add    $0x5c,%esp
	iupdate(ip);
	iunlockput(ip);

	end_op();

	return 0;
801051ad:	31 c0                	xor    %eax,%eax

	bad:
	iunlockput(dp);
	end_op();
	return -1;
}
801051af:	5b                   	pop    %ebx
801051b0:	5e                   	pop    %esi
801051b1:	5f                   	pop    %edi
801051b2:	5d                   	pop    %ebp
801051b3:	c3                   	ret    
801051b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
	int off;
	struct dirent de;

	for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051b8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051bc:	0f 86 79 ff ff ff    	jbe    8010513b <sys_unlink+0xbb>
801051c2:	bf 20 00 00 00       	mov    $0x20,%edi
801051c7:	eb 15                	jmp    801051de <sys_unlink+0x15e>
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051d0:	8d 57 10             	lea    0x10(%edi),%edx
801051d3:	3b 53 58             	cmp    0x58(%ebx),%edx
801051d6:	0f 83 5f ff ff ff    	jae    8010513b <sys_unlink+0xbb>
801051dc:	89 d7                	mov    %edx,%edi
		if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051de:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801051e5:	00 
801051e6:	89 7c 24 08          	mov    %edi,0x8(%esp)
801051ea:	89 74 24 04          	mov    %esi,0x4(%esp)
801051ee:	89 1c 24             	mov    %ebx,(%esp)
801051f1:	e8 ca c7 ff ff       	call   801019c0 <readi>
801051f6:	83 f8 10             	cmp    $0x10,%eax
801051f9:	75 42                	jne    8010523d <sys_unlink+0x1bd>
			panic("isdirempty: readi");
		if(de.inum != 0)
801051fb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105200:	74 ce                	je     801051d0 <sys_unlink+0x150>
	ilock(ip);

	if(ip->nlink < 1)
		panic("unlink: nlink < 1");
	if(ip->type == T_DIR && !isdirempty(ip)){
		iunlockput(ip);
80105202:	89 1c 24             	mov    %ebx,(%esp)
80105205:	e8 66 c7 ff ff       	call   80101970 <iunlockput>
	end_op();

	return 0;

	bad:
	iunlockput(dp);
8010520a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010520d:	89 04 24             	mov    %eax,(%esp)
80105210:	e8 5b c7 ff ff       	call   80101970 <iunlockput>
	end_op();
80105215:	e8 c6 d9 ff ff       	call   80102be0 <end_op>
	return -1;
}
8010521a:	83 c4 5c             	add    $0x5c,%esp
	return 0;

	bad:
	iunlockput(dp);
	end_op();
	return -1;
8010521d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105222:	5b                   	pop    %ebx
80105223:	5e                   	pop    %esi
80105224:	5f                   	pop    %edi
80105225:	5d                   	pop    %ebp
80105226:	c3                   	ret    
80105227:	90                   	nop

	memset(&de, 0, sizeof(de));
	if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
		panic("unlink: writei");
	if(ip->type == T_DIR){
		dp->nlink--;
80105228:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010522b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
		iupdate(dp);
80105230:	89 04 24             	mov    %eax,(%esp)
80105233:	e8 c8 c3 ff ff       	call   80101600 <iupdate>
80105238:	e9 48 ff ff ff       	jmp    80105185 <sys_unlink+0x105>
	int off;
	struct dirent de;

	for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
		if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
			panic("isdirempty: readi");
8010523d:	c7 04 24 03 79 10 80 	movl   $0x80107903,(%esp)
80105244:	e8 17 b1 ff ff       	call   80100360 <panic>
		goto bad;
	}

	memset(&de, 0, sizeof(de));
	if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
		panic("unlink: writei");
80105249:	c7 04 24 15 79 10 80 	movl   $0x80107915,(%esp)
80105250:	e8 0b b1 ff ff       	call   80100360 <panic>
	if((ip = dirlookup(dp, name, &off)) == 0)
		goto bad;
	ilock(ip);

	if(ip->nlink < 1)
		panic("unlink: nlink < 1");
80105255:	c7 04 24 f1 78 10 80 	movl   $0x801078f1,(%esp)
8010525c:	e8 ff b0 ff ff       	call   80100360 <panic>
80105261:	eb 0d                	jmp    80105270 <sys_open>
80105263:	90                   	nop
80105264:	90                   	nop
80105265:	90                   	nop
80105266:	90                   	nop
80105267:	90                   	nop
80105268:	90                   	nop
80105269:	90                   	nop
8010526a:	90                   	nop
8010526b:	90                   	nop
8010526c:	90                   	nop
8010526d:	90                   	nop
8010526e:	90                   	nop
8010526f:	90                   	nop

80105270 <sys_open>:
	return ip;
}

int
sys_open(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	57                   	push   %edi
80105274:	56                   	push   %esi
80105275:	53                   	push   %ebx
80105276:	83 ec 2c             	sub    $0x2c,%esp
	char *path;
	int fd, omode;
	struct file *f;
	struct inode *ip;

	if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105279:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010527c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105280:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105287:	e8 d4 f3 ff ff       	call   80104660 <argstr>
8010528c:	85 c0                	test   %eax,%eax
8010528e:	0f 88 d1 00 00 00    	js     80105365 <sys_open+0xf5>
80105294:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105297:	89 44 24 04          	mov    %eax,0x4(%esp)
8010529b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801052a2:	e8 29 f3 ff ff       	call   801045d0 <argint>
801052a7:	85 c0                	test   %eax,%eax
801052a9:	0f 88 b6 00 00 00    	js     80105365 <sys_open+0xf5>
		return -1;

	begin_op();
801052af:	e8 bc d8 ff ff       	call   80102b70 <begin_op>

	if(omode & O_CREATE){
801052b4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801052b8:	0f 85 82 00 00 00    	jne    80105340 <sys_open+0xd0>
		if(ip == 0){
			end_op();
			return -1;
		}
	} else {
		if((ip = namei(path)) == 0){
801052be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052c1:	89 04 24             	mov    %eax,(%esp)
801052c4:	e8 97 cc ff ff       	call   80101f60 <namei>
801052c9:	85 c0                	test   %eax,%eax
801052cb:	89 c6                	mov    %eax,%esi
801052cd:	0f 84 8d 00 00 00    	je     80105360 <sys_open+0xf0>
			end_op();
			return -1;
		}
		ilock(ip);
801052d3:	89 04 24             	mov    %eax,(%esp)
801052d6:	e8 e5 c3 ff ff       	call   801016c0 <ilock>
		if(ip->type == T_DIR && omode != O_RDONLY){
801052db:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052e0:	0f 84 92 00 00 00    	je     80105378 <sys_open+0x108>
			end_op();
			return -1;
		}
	}

	if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052e6:	e8 85 ba ff ff       	call   80100d70 <filealloc>
801052eb:	85 c0                	test   %eax,%eax
801052ed:	89 c3                	mov    %eax,%ebx
801052ef:	0f 84 93 00 00 00    	je     80105388 <sys_open+0x118>
801052f5:	e8 16 f4 ff ff       	call   80104710 <fdalloc>
801052fa:	85 c0                	test   %eax,%eax
801052fc:	89 c7                	mov    %eax,%edi
801052fe:	0f 88 94 00 00 00    	js     80105398 <sys_open+0x128>
			fileclose(f);
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
80105304:	89 34 24             	mov    %esi,(%esp)
80105307:	e8 94 c4 ff ff       	call   801017a0 <iunlock>
	end_op();
8010530c:	e8 cf d8 ff ff       	call   80102be0 <end_op>

	f->type = FD_INODE;
80105311:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
	f->ip = ip;
	f->off = 0;
	f->readable = !(omode & O_WRONLY);
80105317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	}
	iunlock(ip);
	end_op();

	f->type = FD_INODE;
	f->ip = ip;
8010531a:	89 73 10             	mov    %esi,0x10(%ebx)
	f->off = 0;
8010531d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	f->readable = !(omode & O_WRONLY);
80105324:	89 c2                	mov    %eax,%edx
80105326:	83 e2 01             	and    $0x1,%edx
80105329:	83 f2 01             	xor    $0x1,%edx
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010532c:	a8 03                	test   $0x3,%al
	end_op();

	f->type = FD_INODE;
	f->ip = ip;
	f->off = 0;
	f->readable = !(omode & O_WRONLY);
8010532e:	88 53 08             	mov    %dl,0x8(%ebx)
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
	return fd;
80105331:	89 f8                	mov    %edi,%eax

	f->type = FD_INODE;
	f->ip = ip;
	f->off = 0;
	f->readable = !(omode & O_WRONLY);
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105333:	0f 95 43 09          	setne  0x9(%ebx)
	return fd;
}
80105337:	83 c4 2c             	add    $0x2c,%esp
8010533a:	5b                   	pop    %ebx
8010533b:	5e                   	pop    %esi
8010533c:	5f                   	pop    %edi
8010533d:	5d                   	pop    %ebp
8010533e:	c3                   	ret    
8010533f:	90                   	nop
		return -1;

	begin_op();

	if(omode & O_CREATE){
		ip = create(path, T_FILE, 0, 0);
80105340:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105343:	31 c9                	xor    %ecx,%ecx
80105345:	ba 02 00 00 00       	mov    $0x2,%edx
8010534a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105351:	e8 fa f3 ff ff       	call   80104750 <create>
		if(ip == 0){
80105356:	85 c0                	test   %eax,%eax
		return -1;

	begin_op();

	if(omode & O_CREATE){
		ip = create(path, T_FILE, 0, 0);
80105358:	89 c6                	mov    %eax,%esi
		if(ip == 0){
8010535a:	75 8a                	jne    801052e6 <sys_open+0x76>
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

	if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
		if(f)
			fileclose(f);
		iunlockput(ip);
		end_op();
80105360:	e8 7b d8 ff ff       	call   80102be0 <end_op>
	f->ip = ip;
	f->off = 0;
	f->readable = !(omode & O_WRONLY);
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
	return fd;
}
80105365:	83 c4 2c             	add    $0x2c,%esp
	if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
		if(f)
			fileclose(f);
		iunlockput(ip);
		end_op();
		return -1;
80105368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	f->ip = ip;
	f->off = 0;
	f->readable = !(omode & O_WRONLY);
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
	return fd;
}
8010536d:	5b                   	pop    %ebx
8010536e:	5e                   	pop    %esi
8010536f:	5f                   	pop    %edi
80105370:	5d                   	pop    %ebp
80105371:	c3                   	ret    
80105372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if((ip = namei(path)) == 0){
			end_op();
			return -1;
		}
		ilock(ip);
		if(ip->type == T_DIR && omode != O_RDONLY){
80105378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010537b:	85 c0                	test   %eax,%eax
8010537d:	0f 84 63 ff ff ff    	je     801052e6 <sys_open+0x76>
80105383:	90                   	nop
80105384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	}

	if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
		if(f)
			fileclose(f);
		iunlockput(ip);
80105388:	89 34 24             	mov    %esi,(%esp)
8010538b:	e8 e0 c5 ff ff       	call   80101970 <iunlockput>
80105390:	eb ce                	jmp    80105360 <sys_open+0xf0>
80105392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		}
	}

	if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
		if(f)
			fileclose(f);
80105398:	89 1c 24             	mov    %ebx,(%esp)
8010539b:	e8 90 ba ff ff       	call   80100e30 <fileclose>
801053a0:	eb e6                	jmp    80105388 <sys_open+0x118>
801053a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053b0 <sys_mkdir>:
	return fd;
}

int
sys_mkdir(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	83 ec 28             	sub    $0x28,%esp
	char *path;
	struct inode *ip;

	begin_op();
801053b6:	e8 b5 d7 ff ff       	call   80102b70 <begin_op>
	if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053be:	89 44 24 04          	mov    %eax,0x4(%esp)
801053c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053c9:	e8 92 f2 ff ff       	call   80104660 <argstr>
801053ce:	85 c0                	test   %eax,%eax
801053d0:	78 2e                	js     80105400 <sys_mkdir+0x50>
801053d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d5:	31 c9                	xor    %ecx,%ecx
801053d7:	ba 01 00 00 00       	mov    $0x1,%edx
801053dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053e3:	e8 68 f3 ff ff       	call   80104750 <create>
801053e8:	85 c0                	test   %eax,%eax
801053ea:	74 14                	je     80105400 <sys_mkdir+0x50>
		end_op();
		return -1;
	}
	iunlockput(ip);
801053ec:	89 04 24             	mov    %eax,(%esp)
801053ef:	e8 7c c5 ff ff       	call   80101970 <iunlockput>
	end_op();
801053f4:	e8 e7 d7 ff ff       	call   80102be0 <end_op>
	return 0;
801053f9:	31 c0                	xor    %eax,%eax
}
801053fb:	c9                   	leave  
801053fc:	c3                   	ret    
801053fd:	8d 76 00             	lea    0x0(%esi),%esi
	char *path;
	struct inode *ip;

	begin_op();
	if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
		end_op();
80105400:	e8 db d7 ff ff       	call   80102be0 <end_op>
		return -1;
80105405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	iunlockput(ip);
	end_op();
	return 0;
}
8010540a:	c9                   	leave  
8010540b:	c3                   	ret    
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_mknod>:

int
sys_mknod(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 28             	sub    $0x28,%esp
	struct inode *ip;
	char *path;
	int major, minor;

	begin_op();
80105416:	e8 55 d7 ff ff       	call   80102b70 <begin_op>
	if((argstr(0, &path)) < 0 ||
8010541b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010541e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105429:	e8 32 f2 ff ff       	call   80104660 <argstr>
8010542e:	85 c0                	test   %eax,%eax
80105430:	78 5e                	js     80105490 <sys_mknod+0x80>
			argint(1, &major) < 0 ||
80105432:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105435:	89 44 24 04          	mov    %eax,0x4(%esp)
80105439:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105440:	e8 8b f1 ff ff       	call   801045d0 <argint>
	struct inode *ip;
	char *path;
	int major, minor;

	begin_op();
	if((argstr(0, &path)) < 0 ||
80105445:	85 c0                	test   %eax,%eax
80105447:	78 47                	js     80105490 <sys_mknod+0x80>
			argint(1, &major) < 0 ||
			argint(2, &minor) < 0 ||
80105449:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105450:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105457:	e8 74 f1 ff ff       	call   801045d0 <argint>
	char *path;
	int major, minor;

	begin_op();
	if((argstr(0, &path)) < 0 ||
			argint(1, &major) < 0 ||
8010545c:	85 c0                	test   %eax,%eax
8010545e:	78 30                	js     80105490 <sys_mknod+0x80>
			argint(2, &minor) < 0 ||
			(ip = create(path, T_DEV, major, minor)) == 0){
80105460:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
	int major, minor;

	begin_op();
	if((argstr(0, &path)) < 0 ||
			argint(1, &major) < 0 ||
			argint(2, &minor) < 0 ||
80105464:	ba 03 00 00 00       	mov    $0x3,%edx
			(ip = create(path, T_DEV, major, minor)) == 0){
80105469:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010546d:	89 04 24             	mov    %eax,(%esp)
	int major, minor;

	begin_op();
	if((argstr(0, &path)) < 0 ||
			argint(1, &major) < 0 ||
			argint(2, &minor) < 0 ||
80105470:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105473:	e8 d8 f2 ff ff       	call   80104750 <create>
80105478:	85 c0                	test   %eax,%eax
8010547a:	74 14                	je     80105490 <sys_mknod+0x80>
			(ip = create(path, T_DEV, major, minor)) == 0){
		end_op();
		return -1;
	}
	iunlockput(ip);
8010547c:	89 04 24             	mov    %eax,(%esp)
8010547f:	e8 ec c4 ff ff       	call   80101970 <iunlockput>
	end_op();
80105484:	e8 57 d7 ff ff       	call   80102be0 <end_op>
	return 0;
80105489:	31 c0                	xor    %eax,%eax
}
8010548b:	c9                   	leave  
8010548c:	c3                   	ret    
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
	begin_op();
	if((argstr(0, &path)) < 0 ||
			argint(1, &major) < 0 ||
			argint(2, &minor) < 0 ||
			(ip = create(path, T_DEV, major, minor)) == 0){
		end_op();
80105490:	e8 4b d7 ff ff       	call   80102be0 <end_op>
		return -1;
80105495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	iunlockput(ip);
	end_op();
	return 0;
}
8010549a:	c9                   	leave  
8010549b:	c3                   	ret    
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_chdir>:

int
sys_chdir(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	56                   	push   %esi
801054a4:	53                   	push   %ebx
801054a5:	83 ec 20             	sub    $0x20,%esp
	char *path;
	struct inode *ip;
	struct proc *curproc = myproc();
801054a8:	e8 53 e2 ff ff       	call   80103700 <myproc>
801054ad:	89 c6                	mov    %eax,%esi

	begin_op();
801054af:	e8 bc d6 ff ff       	call   80102b70 <begin_op>
	if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801054bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054c2:	e8 99 f1 ff ff       	call   80104660 <argstr>
801054c7:	85 c0                	test   %eax,%eax
801054c9:	78 4a                	js     80105515 <sys_chdir+0x75>
801054cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ce:	89 04 24             	mov    %eax,(%esp)
801054d1:	e8 8a ca ff ff       	call   80101f60 <namei>
801054d6:	85 c0                	test   %eax,%eax
801054d8:	89 c3                	mov    %eax,%ebx
801054da:	74 39                	je     80105515 <sys_chdir+0x75>
		end_op();
		return -1;
	}
	ilock(ip);
801054dc:	89 04 24             	mov    %eax,(%esp)
801054df:	e8 dc c1 ff ff       	call   801016c0 <ilock>
	if(ip->type != T_DIR){
801054e4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
		iunlockput(ip);
801054e9:	89 1c 24             	mov    %ebx,(%esp)
	if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
		end_op();
		return -1;
	}
	ilock(ip);
	if(ip->type != T_DIR){
801054ec:	75 22                	jne    80105510 <sys_chdir+0x70>
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
801054ee:	e8 ad c2 ff ff       	call   801017a0 <iunlock>
	iput(curproc->cwd);
801054f3:	8b 46 68             	mov    0x68(%esi),%eax
801054f6:	89 04 24             	mov    %eax,(%esp)
801054f9:	e8 32 c3 ff ff       	call   80101830 <iput>
	end_op();
801054fe:	e8 dd d6 ff ff       	call   80102be0 <end_op>
	curproc->cwd = ip;
	return 0;
80105503:	31 c0                	xor    %eax,%eax
		return -1;
	}
	iunlock(ip);
	iput(curproc->cwd);
	end_op();
	curproc->cwd = ip;
80105505:	89 5e 68             	mov    %ebx,0x68(%esi)
	return 0;
}
80105508:	83 c4 20             	add    $0x20,%esp
8010550b:	5b                   	pop    %ebx
8010550c:	5e                   	pop    %esi
8010550d:	5d                   	pop    %ebp
8010550e:	c3                   	ret    
8010550f:	90                   	nop
		end_op();
		return -1;
	}
	ilock(ip);
	if(ip->type != T_DIR){
		iunlockput(ip);
80105510:	e8 5b c4 ff ff       	call   80101970 <iunlockput>
		end_op();
80105515:	e8 c6 d6 ff ff       	call   80102be0 <end_op>
	iunlock(ip);
	iput(curproc->cwd);
	end_op();
	curproc->cwd = ip;
	return 0;
}
8010551a:	83 c4 20             	add    $0x20,%esp
	}
	ilock(ip);
	if(ip->type != T_DIR){
		iunlockput(ip);
		end_op();
		return -1;
8010551d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	iunlock(ip);
	iput(curproc->cwd);
	end_op();
	curproc->cwd = ip;
	return 0;
}
80105522:	5b                   	pop    %ebx
80105523:	5e                   	pop    %esi
80105524:	5d                   	pop    %ebp
80105525:	c3                   	ret    
80105526:	8d 76 00             	lea    0x0(%esi),%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <sys_exec>:

int
sys_exec(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
80105535:	53                   	push   %ebx
80105536:	81 ec ac 00 00 00    	sub    $0xac,%esp
	char *path, *argv[MAXARG];
	int i;
	uint uargv, uarg;

	if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010553c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105542:	89 44 24 04          	mov    %eax,0x4(%esp)
80105546:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010554d:	e8 0e f1 ff ff       	call   80104660 <argstr>
80105552:	85 c0                	test   %eax,%eax
80105554:	0f 88 84 00 00 00    	js     801055de <sys_exec+0xae>
8010555a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105560:	89 44 24 04          	mov    %eax,0x4(%esp)
80105564:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010556b:	e8 60 f0 ff ff       	call   801045d0 <argint>
80105570:	85 c0                	test   %eax,%eax
80105572:	78 6a                	js     801055de <sys_exec+0xae>
		return -1;
	}
	memset(argv, 0, sizeof(argv));
80105574:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
	for(i=0;; i++){
8010557a:	31 db                	xor    %ebx,%ebx
	uint uargv, uarg;

	if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
		return -1;
	}
	memset(argv, 0, sizeof(argv));
8010557c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105583:	00 
80105584:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010558a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105591:	00 
80105592:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105598:	89 04 24             	mov    %eax,(%esp)
8010559b:	e8 40 ed ff ff       	call   801042e0 <memset>
	for(i=0;; i++){
		if(i >= NELEM(argv))
			return -1;
		if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801055a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801055aa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801055ad:	89 04 24             	mov    %eax,(%esp)
801055b0:	e8 7b ef ff ff       	call   80104530 <fetchint>
801055b5:	85 c0                	test   %eax,%eax
801055b7:	78 25                	js     801055de <sys_exec+0xae>
			return -1;
		if(uarg == 0){
801055b9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055bf:	85 c0                	test   %eax,%eax
801055c1:	74 2d                	je     801055f0 <sys_exec+0xc0>
			argv[i] = 0;
			break;
		}
		if(fetchstr(uarg, &argv[i]) < 0)
801055c3:	89 74 24 04          	mov    %esi,0x4(%esp)
801055c7:	89 04 24             	mov    %eax,(%esp)
801055ca:	e8 a1 ef ff ff       	call   80104570 <fetchstr>
801055cf:	85 c0                	test   %eax,%eax
801055d1:	78 0b                	js     801055de <sys_exec+0xae>

	if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
		return -1;
	}
	memset(argv, 0, sizeof(argv));
	for(i=0;; i++){
801055d3:	83 c3 01             	add    $0x1,%ebx
801055d6:	83 c6 04             	add    $0x4,%esi
		if(i >= NELEM(argv))
801055d9:	83 fb 20             	cmp    $0x20,%ebx
801055dc:	75 c2                	jne    801055a0 <sys_exec+0x70>
		}
		if(fetchstr(uarg, &argv[i]) < 0)
			return -1;
	}
	return exec(path, argv);
}
801055de:	81 c4 ac 00 00 00    	add    $0xac,%esp
	char *path, *argv[MAXARG];
	int i;
	uint uargv, uarg;

	if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
		return -1;
801055e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		}
		if(fetchstr(uarg, &argv[i]) < 0)
			return -1;
	}
	return exec(path, argv);
}
801055e9:	5b                   	pop    %ebx
801055ea:	5e                   	pop    %esi
801055eb:	5f                   	pop    %edi
801055ec:	5d                   	pop    %ebp
801055ed:	c3                   	ret    
801055ee:	66 90                	xchg   %ax,%ax
			break;
		}
		if(fetchstr(uarg, &argv[i]) < 0)
			return -1;
	}
	return exec(path, argv);
801055f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801055f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801055fa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
		if(i >= NELEM(argv))
			return -1;
		if(fetchint(uargv+4*i, (int*)&uarg) < 0)
			return -1;
		if(uarg == 0){
			argv[i] = 0;
80105600:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105607:	00 00 00 00 
			break;
		}
		if(fetchstr(uarg, &argv[i]) < 0)
			return -1;
	}
	return exec(path, argv);
8010560b:	89 04 24             	mov    %eax,(%esp)
8010560e:	e8 8d b3 ff ff       	call   801009a0 <exec>
}
80105613:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105619:	5b                   	pop    %ebx
8010561a:	5e                   	pop    %esi
8010561b:	5f                   	pop    %edi
8010561c:	5d                   	pop    %ebp
8010561d:	c3                   	ret    
8010561e:	66 90                	xchg   %ax,%ax

80105620 <sys_pipe>:

int
sys_pipe(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	53                   	push   %ebx
80105624:	83 ec 24             	sub    $0x24,%esp
	int *fd;
	struct file *rf, *wf;
	int fd0, fd1;

	if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105627:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010562a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105631:	00 
80105632:	89 44 24 04          	mov    %eax,0x4(%esp)
80105636:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010563d:	e8 be ef ff ff       	call   80104600 <argptr>
80105642:	85 c0                	test   %eax,%eax
80105644:	78 6d                	js     801056b3 <sys_pipe+0x93>
		return -1;
	if(pipealloc(&rf, &wf) < 0)
80105646:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105649:	89 44 24 04          	mov    %eax,0x4(%esp)
8010564d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105650:	89 04 24             	mov    %eax,(%esp)
80105653:	e8 78 db ff ff       	call   801031d0 <pipealloc>
80105658:	85 c0                	test   %eax,%eax
8010565a:	78 57                	js     801056b3 <sys_pipe+0x93>
		return -1;
	fd0 = -1;
	if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010565c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010565f:	e8 ac f0 ff ff       	call   80104710 <fdalloc>
80105664:	85 c0                	test   %eax,%eax
80105666:	89 c3                	mov    %eax,%ebx
80105668:	78 33                	js     8010569d <sys_pipe+0x7d>
8010566a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010566d:	e8 9e f0 ff ff       	call   80104710 <fdalloc>
80105672:	85 c0                	test   %eax,%eax
80105674:	78 1a                	js     80105690 <sys_pipe+0x70>
			myproc()->ofile[fd0] = 0;
		fileclose(rf);
		fileclose(wf);
		return -1;
	}
	fd[0] = fd0;
80105676:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105679:	89 1a                	mov    %ebx,(%edx)
	fd[1] = fd1;
8010567b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010567e:	89 42 04             	mov    %eax,0x4(%edx)
	return 0;
}
80105681:	83 c4 24             	add    $0x24,%esp
		fileclose(wf);
		return -1;
	}
	fd[0] = fd0;
	fd[1] = fd1;
	return 0;
80105684:	31 c0                	xor    %eax,%eax
}
80105686:	5b                   	pop    %ebx
80105687:	5d                   	pop    %ebp
80105688:	c3                   	ret    
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if(pipealloc(&rf, &wf) < 0)
		return -1;
	fd0 = -1;
	if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
		if(fd0 >= 0)
			myproc()->ofile[fd0] = 0;
80105690:	e8 6b e0 ff ff       	call   80103700 <myproc>
80105695:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010569c:	00 
		fileclose(rf);
8010569d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056a0:	89 04 24             	mov    %eax,(%esp)
801056a3:	e8 88 b7 ff ff       	call   80100e30 <fileclose>
		fileclose(wf);
801056a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ab:	89 04 24             	mov    %eax,(%esp)
801056ae:	e8 7d b7 ff ff       	call   80100e30 <fileclose>
		return -1;
	}
	fd[0] = fd0;
	fd[1] = fd1;
	return 0;
}
801056b3:	83 c4 24             	add    $0x24,%esp
	if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
		if(fd0 >= 0)
			myproc()->ofile[fd0] = 0;
		fileclose(rf);
		fileclose(wf);
		return -1;
801056b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	fd[0] = fd0;
	fd[1] = fd1;
	return 0;
}
801056bb:	5b                   	pop    %ebx
801056bc:	5d                   	pop    %ebp
801056bd:	c3                   	ret    
801056be:	66 90                	xchg   %ax,%ax

801056c0 <sys_myMemory>:
#include "mmu.h"
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
	pde_t * pageDirectory = myproc()->pgdir;
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
801056c4:	31 ff                	xor    %edi,%edi
#include "mmu.h"
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
801056c6:	56                   	push   %esi
	pde_t * pageDirectory = myproc()->pgdir;
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
801056c7:	31 f6                	xor    %esi,%esi
#include "mmu.h"
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
801056c9:	53                   	push   %ebx
801056ca:	83 ec 1c             	sub    $0x1c,%esp
	pde_t * pageDirectory = myproc()->pgdir;
801056cd:	e8 2e e0 ff ff       	call   80103700 <myproc>
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
801056d2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
	pde_t * pageDirectory = myproc()->pgdir;
801056d9:	8b 40 04             	mov    0x4(%eax),%eax
801056dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801056df:	90                   	nop
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
		if ((((pageDirectory[pageDirectoryIndex]) & (uint)PTE_P))){
801056e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056e3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801056e6:	8b 04 98             	mov    (%eax,%ebx,4),%eax
801056e9:	a8 01                	test   $0x1,%al
801056eb:	74 3b                	je     80105728 <sys_myMemory+0x68>
			pageTable = (pde_t *)P2V(PTE_ADDR(pageDirectory[pageDirectoryIndex]));
801056ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801056f2:	8d 98 00 10 00 80    	lea    -0x7ffff000(%eax),%ebx
801056f8:	05 00 00 00 80       	add    $0x80000000,%eax
801056fd:	eb 08                	jmp    80105707 <sys_myMemory+0x47>
801056ff:	90                   	nop
80105700:	83 c0 04             	add    $0x4,%eax
			for(pageTableIndex=0; pageTableIndex<1024; pageTableIndex++){
80105703:	39 d8                	cmp    %ebx,%eax
80105705:	74 21                	je     80105728 <sys_myMemory+0x68>
				if((pageTable[pageTableIndex] & (uint)PTE_U) && (pageTable[pageTableIndex] & (uint)PTE_P)){
80105707:	8b 10                	mov    (%eax),%edx
80105709:	89 d1                	mov    %edx,%ecx
8010570b:	83 e1 05             	and    $0x5,%ecx
8010570e:	83 f9 05             	cmp    $0x5,%ecx
80105711:	75 ed                	jne    80105700 <sys_myMemory+0x40>
					// Page is present
					presentPagesCounter++;
					if ((pageTable[pageTableIndex] & (uint)PTE_W)){
80105713:	83 e2 02             	and    $0x2,%edx
		if ((((pageDirectory[pageDirectoryIndex]) & (uint)PTE_P))){
			pageTable = (pde_t *)P2V(PTE_ADDR(pageDirectory[pageDirectoryIndex]));
			for(pageTableIndex=0; pageTableIndex<1024; pageTableIndex++){
				if((pageTable[pageTableIndex] & (uint)PTE_U) && (pageTable[pageTableIndex] & (uint)PTE_P)){
					// Page is present
					presentPagesCounter++;
80105716:	83 c6 01             	add    $0x1,%esi
					if ((pageTable[pageTableIndex] & (uint)PTE_W)){
						//Page is accessible and writable
						userWritePagesCounter++;
80105719:	83 fa 01             	cmp    $0x1,%edx
8010571c:	83 df ff             	sbb    $0xffffffff,%edi
8010571f:	83 c0 04             	add    $0x4,%eax
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
		if ((((pageDirectory[pageDirectoryIndex]) & (uint)PTE_P))){
			pageTable = (pde_t *)P2V(PTE_ADDR(pageDirectory[pageDirectoryIndex]));
			for(pageTableIndex=0; pageTableIndex<1024; pageTableIndex++){
80105722:	39 d8                	cmp    %ebx,%eax
80105724:	75 e1                	jne    80105707 <sys_myMemory+0x47>
80105726:	66 90                	xchg   %ax,%ax
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
80105728:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010572c:	81 7d e4 00 04 00 00 	cmpl   $0x400,-0x1c(%ebp)
80105733:	75 ab                	jne    801056e0 <sys_myMemory+0x20>
				}
			}
		}
	}
	//Present = Accessible
	cprintf("Present Pages: %d\n",presentPagesCounter);
80105735:	89 74 24 04          	mov    %esi,0x4(%esp)
80105739:	c7 04 24 47 79 10 80 	movl   $0x80107947,(%esp)
80105740:	e8 0b af ff ff       	call   80100650 <cprintf>
	cprintf("Write/User Pages: %d\n",userWritePagesCounter);
80105745:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105749:	c7 04 24 5a 79 10 80 	movl   $0x8010795a,(%esp)
80105750:	e8 fb ae ff ff       	call   80100650 <cprintf>
	return presentPagesCounter;
}
80105755:	83 c4 1c             	add    $0x1c,%esp
80105758:	89 f0                	mov    %esi,%eax
8010575a:	5b                   	pop    %ebx
8010575b:	5e                   	pop    %esi
8010575c:	5f                   	pop    %edi
8010575d:	5d                   	pop    %ebp
8010575e:	c3                   	ret    
8010575f:	90                   	nop

80105760 <sys_fork>:

int
sys_fork(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105763:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105764:	e9 47 e1 ff ff       	jmp    801038b0 <fork>
80105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105770 <sys_exit>:
}

int
sys_exit(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 08             	sub    $0x8,%esp
  exit();
80105776:	e8 85 e3 ff ff       	call   80103b00 <exit>
  return 0;  // not reached
}
8010577b:	31 c0                	xor    %eax,%eax
8010577d:	c9                   	leave  
8010577e:	c3                   	ret    
8010577f:	90                   	nop

80105780 <sys_wait>:

int
sys_wait(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105783:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105784:	e9 87 e5 ff ff       	jmp    80103d10 <wait>
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_kill>:
}

int
sys_kill(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105796:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105799:	89 44 24 04          	mov    %eax,0x4(%esp)
8010579d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057a4:	e8 27 ee ff ff       	call   801045d0 <argint>
801057a9:	85 c0                	test   %eax,%eax
801057ab:	78 13                	js     801057c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801057ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b0:	89 04 24             	mov    %eax,(%esp)
801057b3:	e8 98 e6 ff ff       	call   80103e50 <kill>
}
801057b8:	c9                   	leave  
801057b9:	c3                   	ret    
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801057c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801057c5:	c9                   	leave  
801057c6:	c3                   	ret    
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057d0 <sys_getpid>:

int
sys_getpid(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057d6:	e8 25 df ff ff       	call   80103700 <myproc>
801057db:	8b 40 10             	mov    0x10(%eax),%eax
}
801057de:	c9                   	leave  
801057df:	c3                   	ret    

801057e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	53                   	push   %ebx
801057e4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057f5:	e8 d6 ed ff ff       	call   801045d0 <argint>
801057fa:	85 c0                	test   %eax,%eax
801057fc:	78 22                	js     80105820 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057fe:	e8 fd de ff ff       	call   80103700 <myproc>
  if(growproc(n) < 0)
80105803:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105806:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105808:	89 14 24             	mov    %edx,(%esp)
8010580b:	e8 30 e0 ff ff       	call   80103840 <growproc>
80105810:	85 c0                	test   %eax,%eax
80105812:	78 0c                	js     80105820 <sys_sbrk+0x40>
    return -1;
  return addr;
80105814:	89 d8                	mov    %ebx,%eax
}
80105816:	83 c4 24             	add    $0x24,%esp
80105819:	5b                   	pop    %ebx
8010581a:	5d                   	pop    %ebp
8010581b:	c3                   	ret    
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105825:	eb ef                	jmp    80105816 <sys_sbrk+0x36>
80105827:	89 f6                	mov    %esi,%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105830 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	53                   	push   %ebx
80105834:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105837:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010583a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010583e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105845:	e8 86 ed ff ff       	call   801045d0 <argint>
8010584a:	85 c0                	test   %eax,%eax
8010584c:	78 7e                	js     801058cc <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010584e:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105855:	e8 46 e9 ff ff       	call   801041a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010585a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010585d:	8b 1d c0 57 11 80    	mov    0x801157c0,%ebx
  while(ticks - ticks0 < n){
80105863:	85 d2                	test   %edx,%edx
80105865:	75 29                	jne    80105890 <sys_sleep+0x60>
80105867:	eb 4f                	jmp    801058b8 <sys_sleep+0x88>
80105869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105870:	c7 44 24 04 80 4f 11 	movl   $0x80114f80,0x4(%esp)
80105877:	80 
80105878:	c7 04 24 c0 57 11 80 	movl   $0x801157c0,(%esp)
8010587f:	e8 dc e3 ff ff       	call   80103c60 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105884:	a1 c0 57 11 80       	mov    0x801157c0,%eax
80105889:	29 d8                	sub    %ebx,%eax
8010588b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010588e:	73 28                	jae    801058b8 <sys_sleep+0x88>
    if(myproc()->killed){
80105890:	e8 6b de ff ff       	call   80103700 <myproc>
80105895:	8b 40 24             	mov    0x24(%eax),%eax
80105898:	85 c0                	test   %eax,%eax
8010589a:	74 d4                	je     80105870 <sys_sleep+0x40>
      release(&tickslock);
8010589c:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
801058a3:	e8 e8 e9 ff ff       	call   80104290 <release>
      return -1;
801058a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801058ad:	83 c4 24             	add    $0x24,%esp
801058b0:	5b                   	pop    %ebx
801058b1:	5d                   	pop    %ebp
801058b2:	c3                   	ret    
801058b3:	90                   	nop
801058b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801058b8:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
801058bf:	e8 cc e9 ff ff       	call   80104290 <release>
  return 0;
}
801058c4:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
801058c7:	31 c0                	xor    %eax,%eax
}
801058c9:	5b                   	pop    %ebx
801058ca:	5d                   	pop    %ebp
801058cb:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801058cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d1:	eb da                	jmp    801058ad <sys_sleep+0x7d>
801058d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	53                   	push   %ebx
801058e4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801058e7:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
801058ee:	e8 ad e8 ff ff       	call   801041a0 <acquire>
  xticks = ticks;
801058f3:	8b 1d c0 57 11 80    	mov    0x801157c0,%ebx
  release(&tickslock);
801058f9:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105900:	e8 8b e9 ff ff       	call   80104290 <release>
  return xticks;
}
80105905:	83 c4 14             	add    $0x14,%esp
80105908:	89 d8                	mov    %ebx,%eax
8010590a:	5b                   	pop    %ebx
8010590b:	5d                   	pop    %ebp
8010590c:	c3                   	ret    

8010590d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010590d:	1e                   	push   %ds
  pushl %es
8010590e:	06                   	push   %es
  pushl %fs
8010590f:	0f a0                	push   %fs
  pushl %gs
80105911:	0f a8                	push   %gs
  pushal
80105913:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105914:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105918:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010591a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010591c:	54                   	push   %esp
  call trap
8010591d:	e8 de 00 00 00       	call   80105a00 <trap>
  addl $4, %esp
80105922:	83 c4 04             	add    $0x4,%esp

80105925 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105925:	61                   	popa   
  popl %gs
80105926:	0f a9                	pop    %gs
  popl %fs
80105928:	0f a1                	pop    %fs
  popl %es
8010592a:	07                   	pop    %es
  popl %ds
8010592b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010592c:	83 c4 08             	add    $0x8,%esp
  iret
8010592f:	cf                   	iret   

80105930 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105930:	31 c0                	xor    %eax,%eax
80105932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105938:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010593f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105944:	66 89 0c c5 c2 4f 11 	mov    %cx,-0x7feeb03e(,%eax,8)
8010594b:	80 
8010594c:	c6 04 c5 c4 4f 11 80 	movb   $0x0,-0x7feeb03c(,%eax,8)
80105953:	00 
80105954:	c6 04 c5 c5 4f 11 80 	movb   $0x8e,-0x7feeb03b(,%eax,8)
8010595b:	8e 
8010595c:	66 89 14 c5 c0 4f 11 	mov    %dx,-0x7feeb040(,%eax,8)
80105963:	80 
80105964:	c1 ea 10             	shr    $0x10,%edx
80105967:	66 89 14 c5 c6 4f 11 	mov    %dx,-0x7feeb03a(,%eax,8)
8010596e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010596f:	83 c0 01             	add    $0x1,%eax
80105972:	3d 00 01 00 00       	cmp    $0x100,%eax
80105977:	75 bf                	jne    80105938 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105979:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010597a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010597f:	89 e5                	mov    %esp,%ebp
80105981:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105984:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105989:	c7 44 24 04 70 79 10 	movl   $0x80107970,0x4(%esp)
80105990:	80 
80105991:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105998:	66 89 15 c2 51 11 80 	mov    %dx,0x801151c2
8010599f:	66 a3 c0 51 11 80    	mov    %ax,0x801151c0
801059a5:	c1 e8 10             	shr    $0x10,%eax
801059a8:	c6 05 c4 51 11 80 00 	movb   $0x0,0x801151c4
801059af:	c6 05 c5 51 11 80 ef 	movb   $0xef,0x801151c5
801059b6:	66 a3 c6 51 11 80    	mov    %ax,0x801151c6

  initlock(&tickslock, "time");
801059bc:	e8 ef e6 ff ff       	call   801040b0 <initlock>
}
801059c1:	c9                   	leave  
801059c2:	c3                   	ret    
801059c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <idtinit>:

void
idtinit(void)
{
801059d0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801059d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059d6:	89 e5                	mov    %esp,%ebp
801059d8:	83 ec 10             	sub    $0x10,%esp
801059db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801059df:	b8 c0 4f 11 80       	mov    $0x80114fc0,%eax
801059e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059e8:	c1 e8 10             	shr    $0x10,%eax
801059eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801059ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059f5:	c9                   	leave  
801059f6:	c3                   	ret    
801059f7:	89 f6                	mov    %esi,%esi
801059f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	57                   	push   %edi
80105a04:	56                   	push   %esi
80105a05:	53                   	push   %ebx
80105a06:	83 ec 3c             	sub    $0x3c,%esp
80105a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105a0c:	8b 43 30             	mov    0x30(%ebx),%eax
80105a0f:	83 f8 40             	cmp    $0x40,%eax
80105a12:	0f 84 a0 01 00 00    	je     80105bb8 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a18:	83 e8 20             	sub    $0x20,%eax
80105a1b:	83 f8 1f             	cmp    $0x1f,%eax
80105a1e:	77 08                	ja     80105a28 <trap+0x28>
80105a20:	ff 24 85 18 7a 10 80 	jmp    *-0x7fef85e8(,%eax,4)
80105a27:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a28:	e8 d3 dc ff ff       	call   80103700 <myproc>
80105a2d:	85 c0                	test   %eax,%eax
80105a2f:	90                   	nop
80105a30:	0f 84 fa 01 00 00    	je     80105c30 <trap+0x230>
80105a36:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a3a:	0f 84 f0 01 00 00    	je     80105c30 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a40:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a43:	8b 53 38             	mov    0x38(%ebx),%edx
80105a46:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105a49:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105a4c:	e8 8f dc ff ff       	call   801036e0 <cpuid>
80105a51:	8b 73 30             	mov    0x30(%ebx),%esi
80105a54:	89 c7                	mov    %eax,%edi
80105a56:	8b 43 34             	mov    0x34(%ebx),%eax
80105a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a5c:	e8 9f dc ff ff       	call   80103700 <myproc>
80105a61:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a64:	e8 97 dc ff ff       	call   80103700 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a69:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a6c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a70:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a73:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a76:	89 7c 24 14          	mov    %edi,0x14(%esp)
80105a7a:	89 54 24 18          	mov    %edx,0x18(%esp)
80105a7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a81:	83 c6 6c             	add    $0x6c,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a84:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a88:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a8c:	89 54 24 10          	mov    %edx,0x10(%esp)
80105a90:	8b 40 10             	mov    0x10(%eax),%eax
80105a93:	c7 04 24 d4 79 10 80 	movl   $0x801079d4,(%esp)
80105a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a9e:	e8 ad ab ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105aa3:	e8 58 dc ff ff       	call   80103700 <myproc>
80105aa8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105aaf:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ab0:	e8 4b dc ff ff       	call   80103700 <myproc>
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	74 0c                	je     80105ac5 <trap+0xc5>
80105ab9:	e8 42 dc ff ff       	call   80103700 <myproc>
80105abe:	8b 50 24             	mov    0x24(%eax),%edx
80105ac1:	85 d2                	test   %edx,%edx
80105ac3:	75 4b                	jne    80105b10 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ac5:	e8 36 dc ff ff       	call   80103700 <myproc>
80105aca:	85 c0                	test   %eax,%eax
80105acc:	74 0d                	je     80105adb <trap+0xdb>
80105ace:	66 90                	xchg   %ax,%ax
80105ad0:	e8 2b dc ff ff       	call   80103700 <myproc>
80105ad5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ad9:	74 4d                	je     80105b28 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105adb:	e8 20 dc ff ff       	call   80103700 <myproc>
80105ae0:	85 c0                	test   %eax,%eax
80105ae2:	74 1d                	je     80105b01 <trap+0x101>
80105ae4:	e8 17 dc ff ff       	call   80103700 <myproc>
80105ae9:	8b 40 24             	mov    0x24(%eax),%eax
80105aec:	85 c0                	test   %eax,%eax
80105aee:	74 11                	je     80105b01 <trap+0x101>
80105af0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105af4:	83 e0 03             	and    $0x3,%eax
80105af7:	66 83 f8 03          	cmp    $0x3,%ax
80105afb:	0f 84 e8 00 00 00    	je     80105be9 <trap+0x1e9>
    exit();
}
80105b01:	83 c4 3c             	add    $0x3c,%esp
80105b04:	5b                   	pop    %ebx
80105b05:	5e                   	pop    %esi
80105b06:	5f                   	pop    %edi
80105b07:	5d                   	pop    %ebp
80105b08:	c3                   	ret    
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b10:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b14:	83 e0 03             	and    $0x3,%eax
80105b17:	66 83 f8 03          	cmp    $0x3,%ax
80105b1b:	75 a8                	jne    80105ac5 <trap+0xc5>
    exit();
80105b1d:	e8 de df ff ff       	call   80103b00 <exit>
80105b22:	eb a1                	jmp    80105ac5 <trap+0xc5>
80105b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b28:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b30:	75 a9                	jne    80105adb <trap+0xdb>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105b32:	e8 e9 e0 ff ff       	call   80103c20 <yield>
80105b37:	eb a2                	jmp    80105adb <trap+0xdb>
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105b40:	e8 9b db ff ff       	call   801036e0 <cpuid>
80105b45:	85 c0                	test   %eax,%eax
80105b47:	0f 84 b3 00 00 00    	je     80105c00 <trap+0x200>
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105b50:	e8 8b cc ff ff       	call   801027e0 <lapiceoi>
    break;
80105b55:	e9 56 ff ff ff       	jmp    80105ab0 <trap+0xb0>
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105b60:	e8 cb ca ff ff       	call   80102630 <kbdintr>
    lapiceoi();
80105b65:	e8 76 cc ff ff       	call   801027e0 <lapiceoi>
    break;
80105b6a:	e9 41 ff ff ff       	jmp    80105ab0 <trap+0xb0>
80105b6f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105b70:	e8 1b 02 00 00       	call   80105d90 <uartintr>
    lapiceoi();
80105b75:	e8 66 cc ff ff       	call   801027e0 <lapiceoi>
    break;
80105b7a:	e9 31 ff ff ff       	jmp    80105ab0 <trap+0xb0>
80105b7f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b80:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b83:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b87:	e8 54 db ff ff       	call   801036e0 <cpuid>
80105b8c:	c7 04 24 7c 79 10 80 	movl   $0x8010797c,(%esp)
80105b93:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105b97:	89 74 24 08          	mov    %esi,0x8(%esp)
80105b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b9f:	e8 ac aa ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105ba4:	e8 37 cc ff ff       	call   801027e0 <lapiceoi>
    break;
80105ba9:	e9 02 ff ff ff       	jmp    80105ab0 <trap+0xb0>
80105bae:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105bb0:	e8 2b c5 ff ff       	call   801020e0 <ideintr>
80105bb5:	eb 96                	jmp    80105b4d <trap+0x14d>
80105bb7:	90                   	nop
80105bb8:	90                   	nop
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105bc0:	e8 3b db ff ff       	call   80103700 <myproc>
80105bc5:	8b 70 24             	mov    0x24(%eax),%esi
80105bc8:	85 f6                	test   %esi,%esi
80105bca:	75 2c                	jne    80105bf8 <trap+0x1f8>
      exit();
    myproc()->tf = tf;
80105bcc:	e8 2f db ff ff       	call   80103700 <myproc>
80105bd1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105bd4:	e8 c7 ea ff ff       	call   801046a0 <syscall>
    if(myproc()->killed)
80105bd9:	e8 22 db ff ff       	call   80103700 <myproc>
80105bde:	8b 48 24             	mov    0x24(%eax),%ecx
80105be1:	85 c9                	test   %ecx,%ecx
80105be3:	0f 84 18 ff ff ff    	je     80105b01 <trap+0x101>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105be9:	83 c4 3c             	add    $0x3c,%esp
80105bec:	5b                   	pop    %ebx
80105bed:	5e                   	pop    %esi
80105bee:	5f                   	pop    %edi
80105bef:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105bf0:	e9 0b df ff ff       	jmp    80103b00 <exit>
80105bf5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105bf8:	e8 03 df ff ff       	call   80103b00 <exit>
80105bfd:	eb cd                	jmp    80105bcc <trap+0x1cc>
80105bff:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105c00:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105c07:	e8 94 e5 ff ff       	call   801041a0 <acquire>
      ticks++;
      wakeup(&ticks);
80105c0c:	c7 04 24 c0 57 11 80 	movl   $0x801157c0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105c13:	83 05 c0 57 11 80 01 	addl   $0x1,0x801157c0
      wakeup(&ticks);
80105c1a:	e8 d1 e1 ff ff       	call   80103df0 <wakeup>
      release(&tickslock);
80105c1f:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105c26:	e8 65 e6 ff ff       	call   80104290 <release>
80105c2b:	e9 1d ff ff ff       	jmp    80105b4d <trap+0x14d>
80105c30:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c33:	8b 73 38             	mov    0x38(%ebx),%esi
80105c36:	e8 a5 da ff ff       	call   801036e0 <cpuid>
80105c3b:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105c3f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105c43:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c47:	8b 43 30             	mov    0x30(%ebx),%eax
80105c4a:	c7 04 24 a0 79 10 80 	movl   $0x801079a0,(%esp)
80105c51:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c55:	e8 f6 a9 ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105c5a:	c7 04 24 75 79 10 80 	movl   $0x80107975,(%esp)
80105c61:	e8 fa a6 ff ff       	call   80100360 <panic>
80105c66:	66 90                	xchg   %ax,%ax
80105c68:	66 90                	xchg   %ax,%ax
80105c6a:	66 90                	xchg   %ax,%ax
80105c6c:	66 90                	xchg   %ax,%ax
80105c6e:	66 90                	xchg   %ax,%ax

80105c70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c70:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105c75:	55                   	push   %ebp
80105c76:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105c78:	85 c0                	test   %eax,%eax
80105c7a:	74 14                	je     80105c90 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c7c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c81:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c82:	a8 01                	test   $0x1,%al
80105c84:	74 0a                	je     80105c90 <uartgetc+0x20>
80105c86:	b2 f8                	mov    $0xf8,%dl
80105c88:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c89:	0f b6 c0             	movzbl %al,%eax
}
80105c8c:	5d                   	pop    %ebp
80105c8d:	c3                   	ret    
80105c8e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105c95:	5d                   	pop    %ebp
80105c96:	c3                   	ret    
80105c97:	89 f6                	mov    %esi,%esi
80105c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ca0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105ca0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	74 3f                	je     80105ce8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105ca9:	55                   	push   %ebp
80105caa:	89 e5                	mov    %esp,%ebp
80105cac:	56                   	push   %esi
80105cad:	be fd 03 00 00       	mov    $0x3fd,%esi
80105cb2:	53                   	push   %ebx
  int i;

  if(!uart)
80105cb3:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105cb8:	83 ec 10             	sub    $0x10,%esp
80105cbb:	eb 14                	jmp    80105cd1 <uartputc+0x31>
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105cc0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105cc7:	e8 34 cb ff ff       	call   80102800 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ccc:	83 eb 01             	sub    $0x1,%ebx
80105ccf:	74 07                	je     80105cd8 <uartputc+0x38>
80105cd1:	89 f2                	mov    %esi,%edx
80105cd3:	ec                   	in     (%dx),%al
80105cd4:	a8 20                	test   $0x20,%al
80105cd6:	74 e8                	je     80105cc0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105cd8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cdc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ce1:	ee                   	out    %al,(%dx)
}
80105ce2:	83 c4 10             	add    $0x10,%esp
80105ce5:	5b                   	pop    %ebx
80105ce6:	5e                   	pop    %esi
80105ce7:	5d                   	pop    %ebp
80105ce8:	f3 c3                	repz ret 
80105cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cf0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	31 c9                	xor    %ecx,%ecx
80105cf3:	89 e5                	mov    %esp,%ebp
80105cf5:	89 c8                	mov    %ecx,%eax
80105cf7:	57                   	push   %edi
80105cf8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105cfd:	56                   	push   %esi
80105cfe:	89 fa                	mov    %edi,%edx
80105d00:	53                   	push   %ebx
80105d01:	83 ec 1c             	sub    $0x1c,%esp
80105d04:	ee                   	out    %al,(%dx)
80105d05:	be fb 03 00 00       	mov    $0x3fb,%esi
80105d0a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d0f:	89 f2                	mov    %esi,%edx
80105d11:	ee                   	out    %al,(%dx)
80105d12:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d17:	b2 f8                	mov    $0xf8,%dl
80105d19:	ee                   	out    %al,(%dx)
80105d1a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105d1f:	89 c8                	mov    %ecx,%eax
80105d21:	89 da                	mov    %ebx,%edx
80105d23:	ee                   	out    %al,(%dx)
80105d24:	b8 03 00 00 00       	mov    $0x3,%eax
80105d29:	89 f2                	mov    %esi,%edx
80105d2b:	ee                   	out    %al,(%dx)
80105d2c:	b2 fc                	mov    $0xfc,%dl
80105d2e:	89 c8                	mov    %ecx,%eax
80105d30:	ee                   	out    %al,(%dx)
80105d31:	b8 01 00 00 00       	mov    $0x1,%eax
80105d36:	89 da                	mov    %ebx,%edx
80105d38:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d39:	b2 fd                	mov    $0xfd,%dl
80105d3b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105d3c:	3c ff                	cmp    $0xff,%al
80105d3e:	74 42                	je     80105d82 <uartinit+0x92>
    return;
  uart = 1;
80105d40:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105d47:	00 00 00 
80105d4a:	89 fa                	mov    %edi,%edx
80105d4c:	ec                   	in     (%dx),%al
80105d4d:	b2 f8                	mov    $0xf8,%dl
80105d4f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105d50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d57:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d58:	bb 98 7a 10 80       	mov    $0x80107a98,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105d5d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105d64:	e8 a7 c5 ff ff       	call   80102310 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d69:	b8 78 00 00 00       	mov    $0x78,%eax
80105d6e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105d70:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d73:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105d76:	e8 25 ff ff ff       	call   80105ca0 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d7b:	0f be 03             	movsbl (%ebx),%eax
80105d7e:	84 c0                	test   %al,%al
80105d80:	75 ee                	jne    80105d70 <uartinit+0x80>
    uartputc(*p);
}
80105d82:	83 c4 1c             	add    $0x1c,%esp
80105d85:	5b                   	pop    %ebx
80105d86:	5e                   	pop    %esi
80105d87:	5f                   	pop    %edi
80105d88:	5d                   	pop    %ebp
80105d89:	c3                   	ret    
80105d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d90 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105d96:	c7 04 24 70 5c 10 80 	movl   $0x80105c70,(%esp)
80105d9d:	e8 0e aa ff ff       	call   801007b0 <consoleintr>
}
80105da2:	c9                   	leave  
80105da3:	c3                   	ret    

80105da4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $0
80105da6:	6a 00                	push   $0x0
  jmp alltraps
80105da8:	e9 60 fb ff ff       	jmp    8010590d <alltraps>

80105dad <vector1>:
.globl vector1
vector1:
  pushl $0
80105dad:	6a 00                	push   $0x0
  pushl $1
80105daf:	6a 01                	push   $0x1
  jmp alltraps
80105db1:	e9 57 fb ff ff       	jmp    8010590d <alltraps>

80105db6 <vector2>:
.globl vector2
vector2:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $2
80105db8:	6a 02                	push   $0x2
  jmp alltraps
80105dba:	e9 4e fb ff ff       	jmp    8010590d <alltraps>

80105dbf <vector3>:
.globl vector3
vector3:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $3
80105dc1:	6a 03                	push   $0x3
  jmp alltraps
80105dc3:	e9 45 fb ff ff       	jmp    8010590d <alltraps>

80105dc8 <vector4>:
.globl vector4
vector4:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $4
80105dca:	6a 04                	push   $0x4
  jmp alltraps
80105dcc:	e9 3c fb ff ff       	jmp    8010590d <alltraps>

80105dd1 <vector5>:
.globl vector5
vector5:
  pushl $0
80105dd1:	6a 00                	push   $0x0
  pushl $5
80105dd3:	6a 05                	push   $0x5
  jmp alltraps
80105dd5:	e9 33 fb ff ff       	jmp    8010590d <alltraps>

80105dda <vector6>:
.globl vector6
vector6:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $6
80105ddc:	6a 06                	push   $0x6
  jmp alltraps
80105dde:	e9 2a fb ff ff       	jmp    8010590d <alltraps>

80105de3 <vector7>:
.globl vector7
vector7:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $7
80105de5:	6a 07                	push   $0x7
  jmp alltraps
80105de7:	e9 21 fb ff ff       	jmp    8010590d <alltraps>

80105dec <vector8>:
.globl vector8
vector8:
  pushl $8
80105dec:	6a 08                	push   $0x8
  jmp alltraps
80105dee:	e9 1a fb ff ff       	jmp    8010590d <alltraps>

80105df3 <vector9>:
.globl vector9
vector9:
  pushl $0
80105df3:	6a 00                	push   $0x0
  pushl $9
80105df5:	6a 09                	push   $0x9
  jmp alltraps
80105df7:	e9 11 fb ff ff       	jmp    8010590d <alltraps>

80105dfc <vector10>:
.globl vector10
vector10:
  pushl $10
80105dfc:	6a 0a                	push   $0xa
  jmp alltraps
80105dfe:	e9 0a fb ff ff       	jmp    8010590d <alltraps>

80105e03 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e03:	6a 0b                	push   $0xb
  jmp alltraps
80105e05:	e9 03 fb ff ff       	jmp    8010590d <alltraps>

80105e0a <vector12>:
.globl vector12
vector12:
  pushl $12
80105e0a:	6a 0c                	push   $0xc
  jmp alltraps
80105e0c:	e9 fc fa ff ff       	jmp    8010590d <alltraps>

80105e11 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e11:	6a 0d                	push   $0xd
  jmp alltraps
80105e13:	e9 f5 fa ff ff       	jmp    8010590d <alltraps>

80105e18 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e18:	6a 0e                	push   $0xe
  jmp alltraps
80105e1a:	e9 ee fa ff ff       	jmp    8010590d <alltraps>

80105e1f <vector15>:
.globl vector15
vector15:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $15
80105e21:	6a 0f                	push   $0xf
  jmp alltraps
80105e23:	e9 e5 fa ff ff       	jmp    8010590d <alltraps>

80105e28 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e28:	6a 00                	push   $0x0
  pushl $16
80105e2a:	6a 10                	push   $0x10
  jmp alltraps
80105e2c:	e9 dc fa ff ff       	jmp    8010590d <alltraps>

80105e31 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e31:	6a 11                	push   $0x11
  jmp alltraps
80105e33:	e9 d5 fa ff ff       	jmp    8010590d <alltraps>

80105e38 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e38:	6a 00                	push   $0x0
  pushl $18
80105e3a:	6a 12                	push   $0x12
  jmp alltraps
80105e3c:	e9 cc fa ff ff       	jmp    8010590d <alltraps>

80105e41 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e41:	6a 00                	push   $0x0
  pushl $19
80105e43:	6a 13                	push   $0x13
  jmp alltraps
80105e45:	e9 c3 fa ff ff       	jmp    8010590d <alltraps>

80105e4a <vector20>:
.globl vector20
vector20:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $20
80105e4c:	6a 14                	push   $0x14
  jmp alltraps
80105e4e:	e9 ba fa ff ff       	jmp    8010590d <alltraps>

80105e53 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e53:	6a 00                	push   $0x0
  pushl $21
80105e55:	6a 15                	push   $0x15
  jmp alltraps
80105e57:	e9 b1 fa ff ff       	jmp    8010590d <alltraps>

80105e5c <vector22>:
.globl vector22
vector22:
  pushl $0
80105e5c:	6a 00                	push   $0x0
  pushl $22
80105e5e:	6a 16                	push   $0x16
  jmp alltraps
80105e60:	e9 a8 fa ff ff       	jmp    8010590d <alltraps>

80105e65 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e65:	6a 00                	push   $0x0
  pushl $23
80105e67:	6a 17                	push   $0x17
  jmp alltraps
80105e69:	e9 9f fa ff ff       	jmp    8010590d <alltraps>

80105e6e <vector24>:
.globl vector24
vector24:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $24
80105e70:	6a 18                	push   $0x18
  jmp alltraps
80105e72:	e9 96 fa ff ff       	jmp    8010590d <alltraps>

80105e77 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e77:	6a 00                	push   $0x0
  pushl $25
80105e79:	6a 19                	push   $0x19
  jmp alltraps
80105e7b:	e9 8d fa ff ff       	jmp    8010590d <alltraps>

80105e80 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e80:	6a 00                	push   $0x0
  pushl $26
80105e82:	6a 1a                	push   $0x1a
  jmp alltraps
80105e84:	e9 84 fa ff ff       	jmp    8010590d <alltraps>

80105e89 <vector27>:
.globl vector27
vector27:
  pushl $0
80105e89:	6a 00                	push   $0x0
  pushl $27
80105e8b:	6a 1b                	push   $0x1b
  jmp alltraps
80105e8d:	e9 7b fa ff ff       	jmp    8010590d <alltraps>

80105e92 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $28
80105e94:	6a 1c                	push   $0x1c
  jmp alltraps
80105e96:	e9 72 fa ff ff       	jmp    8010590d <alltraps>

80105e9b <vector29>:
.globl vector29
vector29:
  pushl $0
80105e9b:	6a 00                	push   $0x0
  pushl $29
80105e9d:	6a 1d                	push   $0x1d
  jmp alltraps
80105e9f:	e9 69 fa ff ff       	jmp    8010590d <alltraps>

80105ea4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ea4:	6a 00                	push   $0x0
  pushl $30
80105ea6:	6a 1e                	push   $0x1e
  jmp alltraps
80105ea8:	e9 60 fa ff ff       	jmp    8010590d <alltraps>

80105ead <vector31>:
.globl vector31
vector31:
  pushl $0
80105ead:	6a 00                	push   $0x0
  pushl $31
80105eaf:	6a 1f                	push   $0x1f
  jmp alltraps
80105eb1:	e9 57 fa ff ff       	jmp    8010590d <alltraps>

80105eb6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $32
80105eb8:	6a 20                	push   $0x20
  jmp alltraps
80105eba:	e9 4e fa ff ff       	jmp    8010590d <alltraps>

80105ebf <vector33>:
.globl vector33
vector33:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $33
80105ec1:	6a 21                	push   $0x21
  jmp alltraps
80105ec3:	e9 45 fa ff ff       	jmp    8010590d <alltraps>

80105ec8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ec8:	6a 00                	push   $0x0
  pushl $34
80105eca:	6a 22                	push   $0x22
  jmp alltraps
80105ecc:	e9 3c fa ff ff       	jmp    8010590d <alltraps>

80105ed1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ed1:	6a 00                	push   $0x0
  pushl $35
80105ed3:	6a 23                	push   $0x23
  jmp alltraps
80105ed5:	e9 33 fa ff ff       	jmp    8010590d <alltraps>

80105eda <vector36>:
.globl vector36
vector36:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $36
80105edc:	6a 24                	push   $0x24
  jmp alltraps
80105ede:	e9 2a fa ff ff       	jmp    8010590d <alltraps>

80105ee3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $37
80105ee5:	6a 25                	push   $0x25
  jmp alltraps
80105ee7:	e9 21 fa ff ff       	jmp    8010590d <alltraps>

80105eec <vector38>:
.globl vector38
vector38:
  pushl $0
80105eec:	6a 00                	push   $0x0
  pushl $38
80105eee:	6a 26                	push   $0x26
  jmp alltraps
80105ef0:	e9 18 fa ff ff       	jmp    8010590d <alltraps>

80105ef5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ef5:	6a 00                	push   $0x0
  pushl $39
80105ef7:	6a 27                	push   $0x27
  jmp alltraps
80105ef9:	e9 0f fa ff ff       	jmp    8010590d <alltraps>

80105efe <vector40>:
.globl vector40
vector40:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $40
80105f00:	6a 28                	push   $0x28
  jmp alltraps
80105f02:	e9 06 fa ff ff       	jmp    8010590d <alltraps>

80105f07 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $41
80105f09:	6a 29                	push   $0x29
  jmp alltraps
80105f0b:	e9 fd f9 ff ff       	jmp    8010590d <alltraps>

80105f10 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f10:	6a 00                	push   $0x0
  pushl $42
80105f12:	6a 2a                	push   $0x2a
  jmp alltraps
80105f14:	e9 f4 f9 ff ff       	jmp    8010590d <alltraps>

80105f19 <vector43>:
.globl vector43
vector43:
  pushl $0
80105f19:	6a 00                	push   $0x0
  pushl $43
80105f1b:	6a 2b                	push   $0x2b
  jmp alltraps
80105f1d:	e9 eb f9 ff ff       	jmp    8010590d <alltraps>

80105f22 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $44
80105f24:	6a 2c                	push   $0x2c
  jmp alltraps
80105f26:	e9 e2 f9 ff ff       	jmp    8010590d <alltraps>

80105f2b <vector45>:
.globl vector45
vector45:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $45
80105f2d:	6a 2d                	push   $0x2d
  jmp alltraps
80105f2f:	e9 d9 f9 ff ff       	jmp    8010590d <alltraps>

80105f34 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f34:	6a 00                	push   $0x0
  pushl $46
80105f36:	6a 2e                	push   $0x2e
  jmp alltraps
80105f38:	e9 d0 f9 ff ff       	jmp    8010590d <alltraps>

80105f3d <vector47>:
.globl vector47
vector47:
  pushl $0
80105f3d:	6a 00                	push   $0x0
  pushl $47
80105f3f:	6a 2f                	push   $0x2f
  jmp alltraps
80105f41:	e9 c7 f9 ff ff       	jmp    8010590d <alltraps>

80105f46 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $48
80105f48:	6a 30                	push   $0x30
  jmp alltraps
80105f4a:	e9 be f9 ff ff       	jmp    8010590d <alltraps>

80105f4f <vector49>:
.globl vector49
vector49:
  pushl $0
80105f4f:	6a 00                	push   $0x0
  pushl $49
80105f51:	6a 31                	push   $0x31
  jmp alltraps
80105f53:	e9 b5 f9 ff ff       	jmp    8010590d <alltraps>

80105f58 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f58:	6a 00                	push   $0x0
  pushl $50
80105f5a:	6a 32                	push   $0x32
  jmp alltraps
80105f5c:	e9 ac f9 ff ff       	jmp    8010590d <alltraps>

80105f61 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f61:	6a 00                	push   $0x0
  pushl $51
80105f63:	6a 33                	push   $0x33
  jmp alltraps
80105f65:	e9 a3 f9 ff ff       	jmp    8010590d <alltraps>

80105f6a <vector52>:
.globl vector52
vector52:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $52
80105f6c:	6a 34                	push   $0x34
  jmp alltraps
80105f6e:	e9 9a f9 ff ff       	jmp    8010590d <alltraps>

80105f73 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f73:	6a 00                	push   $0x0
  pushl $53
80105f75:	6a 35                	push   $0x35
  jmp alltraps
80105f77:	e9 91 f9 ff ff       	jmp    8010590d <alltraps>

80105f7c <vector54>:
.globl vector54
vector54:
  pushl $0
80105f7c:	6a 00                	push   $0x0
  pushl $54
80105f7e:	6a 36                	push   $0x36
  jmp alltraps
80105f80:	e9 88 f9 ff ff       	jmp    8010590d <alltraps>

80105f85 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f85:	6a 00                	push   $0x0
  pushl $55
80105f87:	6a 37                	push   $0x37
  jmp alltraps
80105f89:	e9 7f f9 ff ff       	jmp    8010590d <alltraps>

80105f8e <vector56>:
.globl vector56
vector56:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $56
80105f90:	6a 38                	push   $0x38
  jmp alltraps
80105f92:	e9 76 f9 ff ff       	jmp    8010590d <alltraps>

80105f97 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $57
80105f99:	6a 39                	push   $0x39
  jmp alltraps
80105f9b:	e9 6d f9 ff ff       	jmp    8010590d <alltraps>

80105fa0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $58
80105fa2:	6a 3a                	push   $0x3a
  jmp alltraps
80105fa4:	e9 64 f9 ff ff       	jmp    8010590d <alltraps>

80105fa9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $59
80105fab:	6a 3b                	push   $0x3b
  jmp alltraps
80105fad:	e9 5b f9 ff ff       	jmp    8010590d <alltraps>

80105fb2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $60
80105fb4:	6a 3c                	push   $0x3c
  jmp alltraps
80105fb6:	e9 52 f9 ff ff       	jmp    8010590d <alltraps>

80105fbb <vector61>:
.globl vector61
vector61:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $61
80105fbd:	6a 3d                	push   $0x3d
  jmp alltraps
80105fbf:	e9 49 f9 ff ff       	jmp    8010590d <alltraps>

80105fc4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $62
80105fc6:	6a 3e                	push   $0x3e
  jmp alltraps
80105fc8:	e9 40 f9 ff ff       	jmp    8010590d <alltraps>

80105fcd <vector63>:
.globl vector63
vector63:
  pushl $0
80105fcd:	6a 00                	push   $0x0
  pushl $63
80105fcf:	6a 3f                	push   $0x3f
  jmp alltraps
80105fd1:	e9 37 f9 ff ff       	jmp    8010590d <alltraps>

80105fd6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $64
80105fd8:	6a 40                	push   $0x40
  jmp alltraps
80105fda:	e9 2e f9 ff ff       	jmp    8010590d <alltraps>

80105fdf <vector65>:
.globl vector65
vector65:
  pushl $0
80105fdf:	6a 00                	push   $0x0
  pushl $65
80105fe1:	6a 41                	push   $0x41
  jmp alltraps
80105fe3:	e9 25 f9 ff ff       	jmp    8010590d <alltraps>

80105fe8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105fe8:	6a 00                	push   $0x0
  pushl $66
80105fea:	6a 42                	push   $0x42
  jmp alltraps
80105fec:	e9 1c f9 ff ff       	jmp    8010590d <alltraps>

80105ff1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105ff1:	6a 00                	push   $0x0
  pushl $67
80105ff3:	6a 43                	push   $0x43
  jmp alltraps
80105ff5:	e9 13 f9 ff ff       	jmp    8010590d <alltraps>

80105ffa <vector68>:
.globl vector68
vector68:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $68
80105ffc:	6a 44                	push   $0x44
  jmp alltraps
80105ffe:	e9 0a f9 ff ff       	jmp    8010590d <alltraps>

80106003 <vector69>:
.globl vector69
vector69:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $69
80106005:	6a 45                	push   $0x45
  jmp alltraps
80106007:	e9 01 f9 ff ff       	jmp    8010590d <alltraps>

8010600c <vector70>:
.globl vector70
vector70:
  pushl $0
8010600c:	6a 00                	push   $0x0
  pushl $70
8010600e:	6a 46                	push   $0x46
  jmp alltraps
80106010:	e9 f8 f8 ff ff       	jmp    8010590d <alltraps>

80106015 <vector71>:
.globl vector71
vector71:
  pushl $0
80106015:	6a 00                	push   $0x0
  pushl $71
80106017:	6a 47                	push   $0x47
  jmp alltraps
80106019:	e9 ef f8 ff ff       	jmp    8010590d <alltraps>

8010601e <vector72>:
.globl vector72
vector72:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $72
80106020:	6a 48                	push   $0x48
  jmp alltraps
80106022:	e9 e6 f8 ff ff       	jmp    8010590d <alltraps>

80106027 <vector73>:
.globl vector73
vector73:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $73
80106029:	6a 49                	push   $0x49
  jmp alltraps
8010602b:	e9 dd f8 ff ff       	jmp    8010590d <alltraps>

80106030 <vector74>:
.globl vector74
vector74:
  pushl $0
80106030:	6a 00                	push   $0x0
  pushl $74
80106032:	6a 4a                	push   $0x4a
  jmp alltraps
80106034:	e9 d4 f8 ff ff       	jmp    8010590d <alltraps>

80106039 <vector75>:
.globl vector75
vector75:
  pushl $0
80106039:	6a 00                	push   $0x0
  pushl $75
8010603b:	6a 4b                	push   $0x4b
  jmp alltraps
8010603d:	e9 cb f8 ff ff       	jmp    8010590d <alltraps>

80106042 <vector76>:
.globl vector76
vector76:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $76
80106044:	6a 4c                	push   $0x4c
  jmp alltraps
80106046:	e9 c2 f8 ff ff       	jmp    8010590d <alltraps>

8010604b <vector77>:
.globl vector77
vector77:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $77
8010604d:	6a 4d                	push   $0x4d
  jmp alltraps
8010604f:	e9 b9 f8 ff ff       	jmp    8010590d <alltraps>

80106054 <vector78>:
.globl vector78
vector78:
  pushl $0
80106054:	6a 00                	push   $0x0
  pushl $78
80106056:	6a 4e                	push   $0x4e
  jmp alltraps
80106058:	e9 b0 f8 ff ff       	jmp    8010590d <alltraps>

8010605d <vector79>:
.globl vector79
vector79:
  pushl $0
8010605d:	6a 00                	push   $0x0
  pushl $79
8010605f:	6a 4f                	push   $0x4f
  jmp alltraps
80106061:	e9 a7 f8 ff ff       	jmp    8010590d <alltraps>

80106066 <vector80>:
.globl vector80
vector80:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $80
80106068:	6a 50                	push   $0x50
  jmp alltraps
8010606a:	e9 9e f8 ff ff       	jmp    8010590d <alltraps>

8010606f <vector81>:
.globl vector81
vector81:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $81
80106071:	6a 51                	push   $0x51
  jmp alltraps
80106073:	e9 95 f8 ff ff       	jmp    8010590d <alltraps>

80106078 <vector82>:
.globl vector82
vector82:
  pushl $0
80106078:	6a 00                	push   $0x0
  pushl $82
8010607a:	6a 52                	push   $0x52
  jmp alltraps
8010607c:	e9 8c f8 ff ff       	jmp    8010590d <alltraps>

80106081 <vector83>:
.globl vector83
vector83:
  pushl $0
80106081:	6a 00                	push   $0x0
  pushl $83
80106083:	6a 53                	push   $0x53
  jmp alltraps
80106085:	e9 83 f8 ff ff       	jmp    8010590d <alltraps>

8010608a <vector84>:
.globl vector84
vector84:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $84
8010608c:	6a 54                	push   $0x54
  jmp alltraps
8010608e:	e9 7a f8 ff ff       	jmp    8010590d <alltraps>

80106093 <vector85>:
.globl vector85
vector85:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $85
80106095:	6a 55                	push   $0x55
  jmp alltraps
80106097:	e9 71 f8 ff ff       	jmp    8010590d <alltraps>

8010609c <vector86>:
.globl vector86
vector86:
  pushl $0
8010609c:	6a 00                	push   $0x0
  pushl $86
8010609e:	6a 56                	push   $0x56
  jmp alltraps
801060a0:	e9 68 f8 ff ff       	jmp    8010590d <alltraps>

801060a5 <vector87>:
.globl vector87
vector87:
  pushl $0
801060a5:	6a 00                	push   $0x0
  pushl $87
801060a7:	6a 57                	push   $0x57
  jmp alltraps
801060a9:	e9 5f f8 ff ff       	jmp    8010590d <alltraps>

801060ae <vector88>:
.globl vector88
vector88:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $88
801060b0:	6a 58                	push   $0x58
  jmp alltraps
801060b2:	e9 56 f8 ff ff       	jmp    8010590d <alltraps>

801060b7 <vector89>:
.globl vector89
vector89:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $89
801060b9:	6a 59                	push   $0x59
  jmp alltraps
801060bb:	e9 4d f8 ff ff       	jmp    8010590d <alltraps>

801060c0 <vector90>:
.globl vector90
vector90:
  pushl $0
801060c0:	6a 00                	push   $0x0
  pushl $90
801060c2:	6a 5a                	push   $0x5a
  jmp alltraps
801060c4:	e9 44 f8 ff ff       	jmp    8010590d <alltraps>

801060c9 <vector91>:
.globl vector91
vector91:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $91
801060cb:	6a 5b                	push   $0x5b
  jmp alltraps
801060cd:	e9 3b f8 ff ff       	jmp    8010590d <alltraps>

801060d2 <vector92>:
.globl vector92
vector92:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $92
801060d4:	6a 5c                	push   $0x5c
  jmp alltraps
801060d6:	e9 32 f8 ff ff       	jmp    8010590d <alltraps>

801060db <vector93>:
.globl vector93
vector93:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $93
801060dd:	6a 5d                	push   $0x5d
  jmp alltraps
801060df:	e9 29 f8 ff ff       	jmp    8010590d <alltraps>

801060e4 <vector94>:
.globl vector94
vector94:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $94
801060e6:	6a 5e                	push   $0x5e
  jmp alltraps
801060e8:	e9 20 f8 ff ff       	jmp    8010590d <alltraps>

801060ed <vector95>:
.globl vector95
vector95:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $95
801060ef:	6a 5f                	push   $0x5f
  jmp alltraps
801060f1:	e9 17 f8 ff ff       	jmp    8010590d <alltraps>

801060f6 <vector96>:
.globl vector96
vector96:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $96
801060f8:	6a 60                	push   $0x60
  jmp alltraps
801060fa:	e9 0e f8 ff ff       	jmp    8010590d <alltraps>

801060ff <vector97>:
.globl vector97
vector97:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $97
80106101:	6a 61                	push   $0x61
  jmp alltraps
80106103:	e9 05 f8 ff ff       	jmp    8010590d <alltraps>

80106108 <vector98>:
.globl vector98
vector98:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $98
8010610a:	6a 62                	push   $0x62
  jmp alltraps
8010610c:	e9 fc f7 ff ff       	jmp    8010590d <alltraps>

80106111 <vector99>:
.globl vector99
vector99:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $99
80106113:	6a 63                	push   $0x63
  jmp alltraps
80106115:	e9 f3 f7 ff ff       	jmp    8010590d <alltraps>

8010611a <vector100>:
.globl vector100
vector100:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $100
8010611c:	6a 64                	push   $0x64
  jmp alltraps
8010611e:	e9 ea f7 ff ff       	jmp    8010590d <alltraps>

80106123 <vector101>:
.globl vector101
vector101:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $101
80106125:	6a 65                	push   $0x65
  jmp alltraps
80106127:	e9 e1 f7 ff ff       	jmp    8010590d <alltraps>

8010612c <vector102>:
.globl vector102
vector102:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $102
8010612e:	6a 66                	push   $0x66
  jmp alltraps
80106130:	e9 d8 f7 ff ff       	jmp    8010590d <alltraps>

80106135 <vector103>:
.globl vector103
vector103:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $103
80106137:	6a 67                	push   $0x67
  jmp alltraps
80106139:	e9 cf f7 ff ff       	jmp    8010590d <alltraps>

8010613e <vector104>:
.globl vector104
vector104:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $104
80106140:	6a 68                	push   $0x68
  jmp alltraps
80106142:	e9 c6 f7 ff ff       	jmp    8010590d <alltraps>

80106147 <vector105>:
.globl vector105
vector105:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $105
80106149:	6a 69                	push   $0x69
  jmp alltraps
8010614b:	e9 bd f7 ff ff       	jmp    8010590d <alltraps>

80106150 <vector106>:
.globl vector106
vector106:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $106
80106152:	6a 6a                	push   $0x6a
  jmp alltraps
80106154:	e9 b4 f7 ff ff       	jmp    8010590d <alltraps>

80106159 <vector107>:
.globl vector107
vector107:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $107
8010615b:	6a 6b                	push   $0x6b
  jmp alltraps
8010615d:	e9 ab f7 ff ff       	jmp    8010590d <alltraps>

80106162 <vector108>:
.globl vector108
vector108:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $108
80106164:	6a 6c                	push   $0x6c
  jmp alltraps
80106166:	e9 a2 f7 ff ff       	jmp    8010590d <alltraps>

8010616b <vector109>:
.globl vector109
vector109:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $109
8010616d:	6a 6d                	push   $0x6d
  jmp alltraps
8010616f:	e9 99 f7 ff ff       	jmp    8010590d <alltraps>

80106174 <vector110>:
.globl vector110
vector110:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $110
80106176:	6a 6e                	push   $0x6e
  jmp alltraps
80106178:	e9 90 f7 ff ff       	jmp    8010590d <alltraps>

8010617d <vector111>:
.globl vector111
vector111:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $111
8010617f:	6a 6f                	push   $0x6f
  jmp alltraps
80106181:	e9 87 f7 ff ff       	jmp    8010590d <alltraps>

80106186 <vector112>:
.globl vector112
vector112:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $112
80106188:	6a 70                	push   $0x70
  jmp alltraps
8010618a:	e9 7e f7 ff ff       	jmp    8010590d <alltraps>

8010618f <vector113>:
.globl vector113
vector113:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $113
80106191:	6a 71                	push   $0x71
  jmp alltraps
80106193:	e9 75 f7 ff ff       	jmp    8010590d <alltraps>

80106198 <vector114>:
.globl vector114
vector114:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $114
8010619a:	6a 72                	push   $0x72
  jmp alltraps
8010619c:	e9 6c f7 ff ff       	jmp    8010590d <alltraps>

801061a1 <vector115>:
.globl vector115
vector115:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $115
801061a3:	6a 73                	push   $0x73
  jmp alltraps
801061a5:	e9 63 f7 ff ff       	jmp    8010590d <alltraps>

801061aa <vector116>:
.globl vector116
vector116:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $116
801061ac:	6a 74                	push   $0x74
  jmp alltraps
801061ae:	e9 5a f7 ff ff       	jmp    8010590d <alltraps>

801061b3 <vector117>:
.globl vector117
vector117:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $117
801061b5:	6a 75                	push   $0x75
  jmp alltraps
801061b7:	e9 51 f7 ff ff       	jmp    8010590d <alltraps>

801061bc <vector118>:
.globl vector118
vector118:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $118
801061be:	6a 76                	push   $0x76
  jmp alltraps
801061c0:	e9 48 f7 ff ff       	jmp    8010590d <alltraps>

801061c5 <vector119>:
.globl vector119
vector119:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $119
801061c7:	6a 77                	push   $0x77
  jmp alltraps
801061c9:	e9 3f f7 ff ff       	jmp    8010590d <alltraps>

801061ce <vector120>:
.globl vector120
vector120:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $120
801061d0:	6a 78                	push   $0x78
  jmp alltraps
801061d2:	e9 36 f7 ff ff       	jmp    8010590d <alltraps>

801061d7 <vector121>:
.globl vector121
vector121:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $121
801061d9:	6a 79                	push   $0x79
  jmp alltraps
801061db:	e9 2d f7 ff ff       	jmp    8010590d <alltraps>

801061e0 <vector122>:
.globl vector122
vector122:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $122
801061e2:	6a 7a                	push   $0x7a
  jmp alltraps
801061e4:	e9 24 f7 ff ff       	jmp    8010590d <alltraps>

801061e9 <vector123>:
.globl vector123
vector123:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $123
801061eb:	6a 7b                	push   $0x7b
  jmp alltraps
801061ed:	e9 1b f7 ff ff       	jmp    8010590d <alltraps>

801061f2 <vector124>:
.globl vector124
vector124:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $124
801061f4:	6a 7c                	push   $0x7c
  jmp alltraps
801061f6:	e9 12 f7 ff ff       	jmp    8010590d <alltraps>

801061fb <vector125>:
.globl vector125
vector125:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $125
801061fd:	6a 7d                	push   $0x7d
  jmp alltraps
801061ff:	e9 09 f7 ff ff       	jmp    8010590d <alltraps>

80106204 <vector126>:
.globl vector126
vector126:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $126
80106206:	6a 7e                	push   $0x7e
  jmp alltraps
80106208:	e9 00 f7 ff ff       	jmp    8010590d <alltraps>

8010620d <vector127>:
.globl vector127
vector127:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $127
8010620f:	6a 7f                	push   $0x7f
  jmp alltraps
80106211:	e9 f7 f6 ff ff       	jmp    8010590d <alltraps>

80106216 <vector128>:
.globl vector128
vector128:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $128
80106218:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010621d:	e9 eb f6 ff ff       	jmp    8010590d <alltraps>

80106222 <vector129>:
.globl vector129
vector129:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $129
80106224:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106229:	e9 df f6 ff ff       	jmp    8010590d <alltraps>

8010622e <vector130>:
.globl vector130
vector130:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $130
80106230:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106235:	e9 d3 f6 ff ff       	jmp    8010590d <alltraps>

8010623a <vector131>:
.globl vector131
vector131:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $131
8010623c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106241:	e9 c7 f6 ff ff       	jmp    8010590d <alltraps>

80106246 <vector132>:
.globl vector132
vector132:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $132
80106248:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010624d:	e9 bb f6 ff ff       	jmp    8010590d <alltraps>

80106252 <vector133>:
.globl vector133
vector133:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $133
80106254:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106259:	e9 af f6 ff ff       	jmp    8010590d <alltraps>

8010625e <vector134>:
.globl vector134
vector134:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $134
80106260:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106265:	e9 a3 f6 ff ff       	jmp    8010590d <alltraps>

8010626a <vector135>:
.globl vector135
vector135:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $135
8010626c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106271:	e9 97 f6 ff ff       	jmp    8010590d <alltraps>

80106276 <vector136>:
.globl vector136
vector136:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $136
80106278:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010627d:	e9 8b f6 ff ff       	jmp    8010590d <alltraps>

80106282 <vector137>:
.globl vector137
vector137:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $137
80106284:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106289:	e9 7f f6 ff ff       	jmp    8010590d <alltraps>

8010628e <vector138>:
.globl vector138
vector138:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $138
80106290:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106295:	e9 73 f6 ff ff       	jmp    8010590d <alltraps>

8010629a <vector139>:
.globl vector139
vector139:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $139
8010629c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062a1:	e9 67 f6 ff ff       	jmp    8010590d <alltraps>

801062a6 <vector140>:
.globl vector140
vector140:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $140
801062a8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062ad:	e9 5b f6 ff ff       	jmp    8010590d <alltraps>

801062b2 <vector141>:
.globl vector141
vector141:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $141
801062b4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801062b9:	e9 4f f6 ff ff       	jmp    8010590d <alltraps>

801062be <vector142>:
.globl vector142
vector142:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $142
801062c0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062c5:	e9 43 f6 ff ff       	jmp    8010590d <alltraps>

801062ca <vector143>:
.globl vector143
vector143:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $143
801062cc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062d1:	e9 37 f6 ff ff       	jmp    8010590d <alltraps>

801062d6 <vector144>:
.globl vector144
vector144:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $144
801062d8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062dd:	e9 2b f6 ff ff       	jmp    8010590d <alltraps>

801062e2 <vector145>:
.globl vector145
vector145:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $145
801062e4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062e9:	e9 1f f6 ff ff       	jmp    8010590d <alltraps>

801062ee <vector146>:
.globl vector146
vector146:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $146
801062f0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801062f5:	e9 13 f6 ff ff       	jmp    8010590d <alltraps>

801062fa <vector147>:
.globl vector147
vector147:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $147
801062fc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106301:	e9 07 f6 ff ff       	jmp    8010590d <alltraps>

80106306 <vector148>:
.globl vector148
vector148:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $148
80106308:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010630d:	e9 fb f5 ff ff       	jmp    8010590d <alltraps>

80106312 <vector149>:
.globl vector149
vector149:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $149
80106314:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106319:	e9 ef f5 ff ff       	jmp    8010590d <alltraps>

8010631e <vector150>:
.globl vector150
vector150:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $150
80106320:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106325:	e9 e3 f5 ff ff       	jmp    8010590d <alltraps>

8010632a <vector151>:
.globl vector151
vector151:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $151
8010632c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106331:	e9 d7 f5 ff ff       	jmp    8010590d <alltraps>

80106336 <vector152>:
.globl vector152
vector152:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $152
80106338:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010633d:	e9 cb f5 ff ff       	jmp    8010590d <alltraps>

80106342 <vector153>:
.globl vector153
vector153:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $153
80106344:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106349:	e9 bf f5 ff ff       	jmp    8010590d <alltraps>

8010634e <vector154>:
.globl vector154
vector154:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $154
80106350:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106355:	e9 b3 f5 ff ff       	jmp    8010590d <alltraps>

8010635a <vector155>:
.globl vector155
vector155:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $155
8010635c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106361:	e9 a7 f5 ff ff       	jmp    8010590d <alltraps>

80106366 <vector156>:
.globl vector156
vector156:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $156
80106368:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010636d:	e9 9b f5 ff ff       	jmp    8010590d <alltraps>

80106372 <vector157>:
.globl vector157
vector157:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $157
80106374:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106379:	e9 8f f5 ff ff       	jmp    8010590d <alltraps>

8010637e <vector158>:
.globl vector158
vector158:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $158
80106380:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106385:	e9 83 f5 ff ff       	jmp    8010590d <alltraps>

8010638a <vector159>:
.globl vector159
vector159:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $159
8010638c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106391:	e9 77 f5 ff ff       	jmp    8010590d <alltraps>

80106396 <vector160>:
.globl vector160
vector160:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $160
80106398:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010639d:	e9 6b f5 ff ff       	jmp    8010590d <alltraps>

801063a2 <vector161>:
.globl vector161
vector161:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $161
801063a4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063a9:	e9 5f f5 ff ff       	jmp    8010590d <alltraps>

801063ae <vector162>:
.globl vector162
vector162:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $162
801063b0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801063b5:	e9 53 f5 ff ff       	jmp    8010590d <alltraps>

801063ba <vector163>:
.globl vector163
vector163:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $163
801063bc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063c1:	e9 47 f5 ff ff       	jmp    8010590d <alltraps>

801063c6 <vector164>:
.globl vector164
vector164:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $164
801063c8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063cd:	e9 3b f5 ff ff       	jmp    8010590d <alltraps>

801063d2 <vector165>:
.globl vector165
vector165:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $165
801063d4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063d9:	e9 2f f5 ff ff       	jmp    8010590d <alltraps>

801063de <vector166>:
.globl vector166
vector166:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $166
801063e0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063e5:	e9 23 f5 ff ff       	jmp    8010590d <alltraps>

801063ea <vector167>:
.globl vector167
vector167:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $167
801063ec:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801063f1:	e9 17 f5 ff ff       	jmp    8010590d <alltraps>

801063f6 <vector168>:
.globl vector168
vector168:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $168
801063f8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801063fd:	e9 0b f5 ff ff       	jmp    8010590d <alltraps>

80106402 <vector169>:
.globl vector169
vector169:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $169
80106404:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106409:	e9 ff f4 ff ff       	jmp    8010590d <alltraps>

8010640e <vector170>:
.globl vector170
vector170:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $170
80106410:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106415:	e9 f3 f4 ff ff       	jmp    8010590d <alltraps>

8010641a <vector171>:
.globl vector171
vector171:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $171
8010641c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106421:	e9 e7 f4 ff ff       	jmp    8010590d <alltraps>

80106426 <vector172>:
.globl vector172
vector172:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $172
80106428:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010642d:	e9 db f4 ff ff       	jmp    8010590d <alltraps>

80106432 <vector173>:
.globl vector173
vector173:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $173
80106434:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106439:	e9 cf f4 ff ff       	jmp    8010590d <alltraps>

8010643e <vector174>:
.globl vector174
vector174:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $174
80106440:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106445:	e9 c3 f4 ff ff       	jmp    8010590d <alltraps>

8010644a <vector175>:
.globl vector175
vector175:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $175
8010644c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106451:	e9 b7 f4 ff ff       	jmp    8010590d <alltraps>

80106456 <vector176>:
.globl vector176
vector176:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $176
80106458:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010645d:	e9 ab f4 ff ff       	jmp    8010590d <alltraps>

80106462 <vector177>:
.globl vector177
vector177:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $177
80106464:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106469:	e9 9f f4 ff ff       	jmp    8010590d <alltraps>

8010646e <vector178>:
.globl vector178
vector178:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $178
80106470:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106475:	e9 93 f4 ff ff       	jmp    8010590d <alltraps>

8010647a <vector179>:
.globl vector179
vector179:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $179
8010647c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106481:	e9 87 f4 ff ff       	jmp    8010590d <alltraps>

80106486 <vector180>:
.globl vector180
vector180:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $180
80106488:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010648d:	e9 7b f4 ff ff       	jmp    8010590d <alltraps>

80106492 <vector181>:
.globl vector181
vector181:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $181
80106494:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106499:	e9 6f f4 ff ff       	jmp    8010590d <alltraps>

8010649e <vector182>:
.globl vector182
vector182:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $182
801064a0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064a5:	e9 63 f4 ff ff       	jmp    8010590d <alltraps>

801064aa <vector183>:
.globl vector183
vector183:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $183
801064ac:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801064b1:	e9 57 f4 ff ff       	jmp    8010590d <alltraps>

801064b6 <vector184>:
.globl vector184
vector184:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $184
801064b8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064bd:	e9 4b f4 ff ff       	jmp    8010590d <alltraps>

801064c2 <vector185>:
.globl vector185
vector185:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $185
801064c4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064c9:	e9 3f f4 ff ff       	jmp    8010590d <alltraps>

801064ce <vector186>:
.globl vector186
vector186:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $186
801064d0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064d5:	e9 33 f4 ff ff       	jmp    8010590d <alltraps>

801064da <vector187>:
.globl vector187
vector187:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $187
801064dc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064e1:	e9 27 f4 ff ff       	jmp    8010590d <alltraps>

801064e6 <vector188>:
.globl vector188
vector188:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $188
801064e8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064ed:	e9 1b f4 ff ff       	jmp    8010590d <alltraps>

801064f2 <vector189>:
.globl vector189
vector189:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $189
801064f4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801064f9:	e9 0f f4 ff ff       	jmp    8010590d <alltraps>

801064fe <vector190>:
.globl vector190
vector190:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $190
80106500:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106505:	e9 03 f4 ff ff       	jmp    8010590d <alltraps>

8010650a <vector191>:
.globl vector191
vector191:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $191
8010650c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106511:	e9 f7 f3 ff ff       	jmp    8010590d <alltraps>

80106516 <vector192>:
.globl vector192
vector192:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $192
80106518:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010651d:	e9 eb f3 ff ff       	jmp    8010590d <alltraps>

80106522 <vector193>:
.globl vector193
vector193:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $193
80106524:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106529:	e9 df f3 ff ff       	jmp    8010590d <alltraps>

8010652e <vector194>:
.globl vector194
vector194:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $194
80106530:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106535:	e9 d3 f3 ff ff       	jmp    8010590d <alltraps>

8010653a <vector195>:
.globl vector195
vector195:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $195
8010653c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106541:	e9 c7 f3 ff ff       	jmp    8010590d <alltraps>

80106546 <vector196>:
.globl vector196
vector196:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $196
80106548:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010654d:	e9 bb f3 ff ff       	jmp    8010590d <alltraps>

80106552 <vector197>:
.globl vector197
vector197:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $197
80106554:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106559:	e9 af f3 ff ff       	jmp    8010590d <alltraps>

8010655e <vector198>:
.globl vector198
vector198:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $198
80106560:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106565:	e9 a3 f3 ff ff       	jmp    8010590d <alltraps>

8010656a <vector199>:
.globl vector199
vector199:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $199
8010656c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106571:	e9 97 f3 ff ff       	jmp    8010590d <alltraps>

80106576 <vector200>:
.globl vector200
vector200:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $200
80106578:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010657d:	e9 8b f3 ff ff       	jmp    8010590d <alltraps>

80106582 <vector201>:
.globl vector201
vector201:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $201
80106584:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106589:	e9 7f f3 ff ff       	jmp    8010590d <alltraps>

8010658e <vector202>:
.globl vector202
vector202:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $202
80106590:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106595:	e9 73 f3 ff ff       	jmp    8010590d <alltraps>

8010659a <vector203>:
.globl vector203
vector203:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $203
8010659c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065a1:	e9 67 f3 ff ff       	jmp    8010590d <alltraps>

801065a6 <vector204>:
.globl vector204
vector204:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $204
801065a8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065ad:	e9 5b f3 ff ff       	jmp    8010590d <alltraps>

801065b2 <vector205>:
.globl vector205
vector205:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $205
801065b4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801065b9:	e9 4f f3 ff ff       	jmp    8010590d <alltraps>

801065be <vector206>:
.globl vector206
vector206:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $206
801065c0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065c5:	e9 43 f3 ff ff       	jmp    8010590d <alltraps>

801065ca <vector207>:
.globl vector207
vector207:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $207
801065cc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065d1:	e9 37 f3 ff ff       	jmp    8010590d <alltraps>

801065d6 <vector208>:
.globl vector208
vector208:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $208
801065d8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065dd:	e9 2b f3 ff ff       	jmp    8010590d <alltraps>

801065e2 <vector209>:
.globl vector209
vector209:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $209
801065e4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065e9:	e9 1f f3 ff ff       	jmp    8010590d <alltraps>

801065ee <vector210>:
.globl vector210
vector210:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $210
801065f0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801065f5:	e9 13 f3 ff ff       	jmp    8010590d <alltraps>

801065fa <vector211>:
.globl vector211
vector211:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $211
801065fc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106601:	e9 07 f3 ff ff       	jmp    8010590d <alltraps>

80106606 <vector212>:
.globl vector212
vector212:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $212
80106608:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010660d:	e9 fb f2 ff ff       	jmp    8010590d <alltraps>

80106612 <vector213>:
.globl vector213
vector213:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $213
80106614:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106619:	e9 ef f2 ff ff       	jmp    8010590d <alltraps>

8010661e <vector214>:
.globl vector214
vector214:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $214
80106620:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106625:	e9 e3 f2 ff ff       	jmp    8010590d <alltraps>

8010662a <vector215>:
.globl vector215
vector215:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $215
8010662c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106631:	e9 d7 f2 ff ff       	jmp    8010590d <alltraps>

80106636 <vector216>:
.globl vector216
vector216:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $216
80106638:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010663d:	e9 cb f2 ff ff       	jmp    8010590d <alltraps>

80106642 <vector217>:
.globl vector217
vector217:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $217
80106644:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106649:	e9 bf f2 ff ff       	jmp    8010590d <alltraps>

8010664e <vector218>:
.globl vector218
vector218:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $218
80106650:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106655:	e9 b3 f2 ff ff       	jmp    8010590d <alltraps>

8010665a <vector219>:
.globl vector219
vector219:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $219
8010665c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106661:	e9 a7 f2 ff ff       	jmp    8010590d <alltraps>

80106666 <vector220>:
.globl vector220
vector220:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $220
80106668:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010666d:	e9 9b f2 ff ff       	jmp    8010590d <alltraps>

80106672 <vector221>:
.globl vector221
vector221:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $221
80106674:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106679:	e9 8f f2 ff ff       	jmp    8010590d <alltraps>

8010667e <vector222>:
.globl vector222
vector222:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $222
80106680:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106685:	e9 83 f2 ff ff       	jmp    8010590d <alltraps>

8010668a <vector223>:
.globl vector223
vector223:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $223
8010668c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106691:	e9 77 f2 ff ff       	jmp    8010590d <alltraps>

80106696 <vector224>:
.globl vector224
vector224:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $224
80106698:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010669d:	e9 6b f2 ff ff       	jmp    8010590d <alltraps>

801066a2 <vector225>:
.globl vector225
vector225:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $225
801066a4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066a9:	e9 5f f2 ff ff       	jmp    8010590d <alltraps>

801066ae <vector226>:
.globl vector226
vector226:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $226
801066b0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801066b5:	e9 53 f2 ff ff       	jmp    8010590d <alltraps>

801066ba <vector227>:
.globl vector227
vector227:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $227
801066bc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066c1:	e9 47 f2 ff ff       	jmp    8010590d <alltraps>

801066c6 <vector228>:
.globl vector228
vector228:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $228
801066c8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066cd:	e9 3b f2 ff ff       	jmp    8010590d <alltraps>

801066d2 <vector229>:
.globl vector229
vector229:
  pushl $0
801066d2:	6a 00                	push   $0x0
  pushl $229
801066d4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066d9:	e9 2f f2 ff ff       	jmp    8010590d <alltraps>

801066de <vector230>:
.globl vector230
vector230:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $230
801066e0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066e5:	e9 23 f2 ff ff       	jmp    8010590d <alltraps>

801066ea <vector231>:
.globl vector231
vector231:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $231
801066ec:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801066f1:	e9 17 f2 ff ff       	jmp    8010590d <alltraps>

801066f6 <vector232>:
.globl vector232
vector232:
  pushl $0
801066f6:	6a 00                	push   $0x0
  pushl $232
801066f8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801066fd:	e9 0b f2 ff ff       	jmp    8010590d <alltraps>

80106702 <vector233>:
.globl vector233
vector233:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $233
80106704:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106709:	e9 ff f1 ff ff       	jmp    8010590d <alltraps>

8010670e <vector234>:
.globl vector234
vector234:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $234
80106710:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106715:	e9 f3 f1 ff ff       	jmp    8010590d <alltraps>

8010671a <vector235>:
.globl vector235
vector235:
  pushl $0
8010671a:	6a 00                	push   $0x0
  pushl $235
8010671c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106721:	e9 e7 f1 ff ff       	jmp    8010590d <alltraps>

80106726 <vector236>:
.globl vector236
vector236:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $236
80106728:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010672d:	e9 db f1 ff ff       	jmp    8010590d <alltraps>

80106732 <vector237>:
.globl vector237
vector237:
  pushl $0
80106732:	6a 00                	push   $0x0
  pushl $237
80106734:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106739:	e9 cf f1 ff ff       	jmp    8010590d <alltraps>

8010673e <vector238>:
.globl vector238
vector238:
  pushl $0
8010673e:	6a 00                	push   $0x0
  pushl $238
80106740:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106745:	e9 c3 f1 ff ff       	jmp    8010590d <alltraps>

8010674a <vector239>:
.globl vector239
vector239:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $239
8010674c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106751:	e9 b7 f1 ff ff       	jmp    8010590d <alltraps>

80106756 <vector240>:
.globl vector240
vector240:
  pushl $0
80106756:	6a 00                	push   $0x0
  pushl $240
80106758:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010675d:	e9 ab f1 ff ff       	jmp    8010590d <alltraps>

80106762 <vector241>:
.globl vector241
vector241:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $241
80106764:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106769:	e9 9f f1 ff ff       	jmp    8010590d <alltraps>

8010676e <vector242>:
.globl vector242
vector242:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $242
80106770:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106775:	e9 93 f1 ff ff       	jmp    8010590d <alltraps>

8010677a <vector243>:
.globl vector243
vector243:
  pushl $0
8010677a:	6a 00                	push   $0x0
  pushl $243
8010677c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106781:	e9 87 f1 ff ff       	jmp    8010590d <alltraps>

80106786 <vector244>:
.globl vector244
vector244:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $244
80106788:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010678d:	e9 7b f1 ff ff       	jmp    8010590d <alltraps>

80106792 <vector245>:
.globl vector245
vector245:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $245
80106794:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106799:	e9 6f f1 ff ff       	jmp    8010590d <alltraps>

8010679e <vector246>:
.globl vector246
vector246:
  pushl $0
8010679e:	6a 00                	push   $0x0
  pushl $246
801067a0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067a5:	e9 63 f1 ff ff       	jmp    8010590d <alltraps>

801067aa <vector247>:
.globl vector247
vector247:
  pushl $0
801067aa:	6a 00                	push   $0x0
  pushl $247
801067ac:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801067b1:	e9 57 f1 ff ff       	jmp    8010590d <alltraps>

801067b6 <vector248>:
.globl vector248
vector248:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $248
801067b8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067bd:	e9 4b f1 ff ff       	jmp    8010590d <alltraps>

801067c2 <vector249>:
.globl vector249
vector249:
  pushl $0
801067c2:	6a 00                	push   $0x0
  pushl $249
801067c4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067c9:	e9 3f f1 ff ff       	jmp    8010590d <alltraps>

801067ce <vector250>:
.globl vector250
vector250:
  pushl $0
801067ce:	6a 00                	push   $0x0
  pushl $250
801067d0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067d5:	e9 33 f1 ff ff       	jmp    8010590d <alltraps>

801067da <vector251>:
.globl vector251
vector251:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $251
801067dc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067e1:	e9 27 f1 ff ff       	jmp    8010590d <alltraps>

801067e6 <vector252>:
.globl vector252
vector252:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $252
801067e8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067ed:	e9 1b f1 ff ff       	jmp    8010590d <alltraps>

801067f2 <vector253>:
.globl vector253
vector253:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $253
801067f4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801067f9:	e9 0f f1 ff ff       	jmp    8010590d <alltraps>

801067fe <vector254>:
.globl vector254
vector254:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $254
80106800:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106805:	e9 03 f1 ff ff       	jmp    8010590d <alltraps>

8010680a <vector255>:
.globl vector255
vector255:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $255
8010680c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106811:	e9 f7 f0 ff ff       	jmp    8010590d <alltraps>
80106816:	66 90                	xchg   %ax,%ax
80106818:	66 90                	xchg   %ax,%ax
8010681a:	66 90                	xchg   %ax,%ax
8010681c:	66 90                	xchg   %ax,%ax
8010681e:	66 90                	xchg   %ax,%ax

80106820 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	57                   	push   %edi
80106824:	56                   	push   %esi
80106825:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106827:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010682a:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010682b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010682e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106831:	8b 1f                	mov    (%edi),%ebx
80106833:	f6 c3 01             	test   $0x1,%bl
80106836:	74 28                	je     80106860 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106838:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010683e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106844:	c1 ee 0a             	shr    $0xa,%esi
}
80106847:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010684a:	89 f2                	mov    %esi,%edx
8010684c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106852:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106855:	5b                   	pop    %ebx
80106856:	5e                   	pop    %esi
80106857:	5f                   	pop    %edi
80106858:	5d                   	pop    %ebp
80106859:	c3                   	ret    
8010685a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106860:	85 c9                	test   %ecx,%ecx
80106862:	74 34                	je     80106898 <walkpgdir+0x78>
80106864:	e8 97 bc ff ff       	call   80102500 <kalloc>
80106869:	85 c0                	test   %eax,%eax
8010686b:	89 c3                	mov    %eax,%ebx
8010686d:	74 29                	je     80106898 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010686f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106876:	00 
80106877:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010687e:	00 
8010687f:	89 04 24             	mov    %eax,(%esp)
80106882:	e8 59 da ff ff       	call   801042e0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106887:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010688d:	83 c8 07             	or     $0x7,%eax
80106890:	89 07                	mov    %eax,(%edi)
80106892:	eb b0                	jmp    80106844 <walkpgdir+0x24>
80106894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
80106898:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
8010689b:	31 c0                	xor    %eax,%eax
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
8010689d:	5b                   	pop    %ebx
8010689e:	5e                   	pop    %esi
8010689f:	5f                   	pop    %edi
801068a0:	5d                   	pop    %ebp
801068a1:	c3                   	ret    
801068a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	56                   	push   %esi
801068b5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801068b6:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801068b8:	83 ec 1c             	sub    $0x1c,%esp
801068bb:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801068be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801068c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068c7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801068cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801068ce:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068d2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801068d9:	29 df                	sub    %ebx,%edi
801068db:	eb 18                	jmp    801068f5 <mappages+0x45>
801068dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801068e0:	f6 00 01             	testb  $0x1,(%eax)
801068e3:	75 3d                	jne    80106922 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
801068e5:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
801068e8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801068eb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801068ed:	74 29                	je     80106918 <mappages+0x68>
      break;
    a += PGSIZE;
801068ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801068f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801068fd:	89 da                	mov    %ebx,%edx
801068ff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106902:	e8 19 ff ff ff       	call   80106820 <walkpgdir>
80106907:	85 c0                	test   %eax,%eax
80106909:	75 d5                	jne    801068e0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010690b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010690e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106913:	5b                   	pop    %ebx
80106914:	5e                   	pop    %esi
80106915:	5f                   	pop    %edi
80106916:	5d                   	pop    %ebp
80106917:	c3                   	ret    
80106918:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010691b:	31 c0                	xor    %eax,%eax
}
8010691d:	5b                   	pop    %ebx
8010691e:	5e                   	pop    %esi
8010691f:	5f                   	pop    %edi
80106920:	5d                   	pop    %ebp
80106921:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106922:	c7 04 24 a0 7a 10 80 	movl   $0x80107aa0,(%esp)
80106929:	e8 32 9a ff ff       	call   80100360 <panic>
8010692e:	66 90                	xchg   %ax,%ax

80106930 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	57                   	push   %edi
80106934:	89 c7                	mov    %eax,%edi
80106936:	56                   	push   %esi
80106937:	89 d6                	mov    %edx,%esi
80106939:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010693a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106940:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106943:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106949:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010694b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010694e:	72 3b                	jb     8010698b <deallocuvm.part.0+0x5b>
80106950:	eb 5e                	jmp    801069b0 <deallocuvm.part.0+0x80>
80106952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106958:	8b 10                	mov    (%eax),%edx
8010695a:	f6 c2 01             	test   $0x1,%dl
8010695d:	74 22                	je     80106981 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010695f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106965:	74 54                	je     801069bb <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106967:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010696d:	89 14 24             	mov    %edx,(%esp)
80106970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106973:	e8 d8 b9 ff ff       	call   80102350 <kfree>
      *pte = 0;
80106978:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010697b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106981:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106987:	39 f3                	cmp    %esi,%ebx
80106989:	73 25                	jae    801069b0 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010698b:	31 c9                	xor    %ecx,%ecx
8010698d:	89 da                	mov    %ebx,%edx
8010698f:	89 f8                	mov    %edi,%eax
80106991:	e8 8a fe ff ff       	call   80106820 <walkpgdir>
    if(!pte)
80106996:	85 c0                	test   %eax,%eax
80106998:	75 be                	jne    80106958 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010699a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801069a0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801069a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069ac:	39 f3                	cmp    %esi,%ebx
801069ae:	72 db                	jb     8010698b <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801069b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801069b3:	83 c4 1c             	add    $0x1c,%esp
801069b6:	5b                   	pop    %ebx
801069b7:	5e                   	pop    %esi
801069b8:	5f                   	pop    %edi
801069b9:	5d                   	pop    %ebp
801069ba:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801069bb:	c7 04 24 a6 73 10 80 	movl   $0x801073a6,(%esp)
801069c2:	e8 99 99 ff ff       	call   80100360 <panic>
801069c7:	89 f6                	mov    %esi,%esi
801069c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069d0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801069d6:	e8 05 cd ff ff       	call   801036e0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069db:	31 c9                	xor    %ecx,%ecx
801069dd:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801069e2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801069e8:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069ed:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069f1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
801069f6:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069f9:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069fd:	31 c9                	xor    %ecx,%ecx
801069ff:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a03:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a08:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a0c:	31 c9                	xor    %ecx,%ecx
80106a0e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a12:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a17:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a1b:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a1d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106a21:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a25:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106a29:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a2d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106a31:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a35:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106a39:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
80106a3d:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106a41:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a46:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
80106a4a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a4e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106a52:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a56:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
80106a5a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a5e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106a62:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106a66:	c6 40 27 00          	movb   $0x0,0x27(%eax)
80106a6a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106a6e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a72:	c1 e8 10             	shr    $0x10,%eax
80106a75:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106a79:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a7c:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
80106a7f:	c9                   	leave  
80106a80:	c3                   	ret    
80106a81:	eb 0d                	jmp    80106a90 <switchkvm>
80106a83:	90                   	nop
80106a84:	90                   	nop
80106a85:	90                   	nop
80106a86:	90                   	nop
80106a87:	90                   	nop
80106a88:	90                   	nop
80106a89:	90                   	nop
80106a8a:	90                   	nop
80106a8b:	90                   	nop
80106a8c:	90                   	nop
80106a8d:	90                   	nop
80106a8e:	90                   	nop
80106a8f:	90                   	nop

80106a90 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a90:	a1 c4 57 11 80       	mov    0x801157c4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106a95:	55                   	push   %ebp
80106a96:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a98:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a9d:	0f 22 d8             	mov    %eax,%cr3
}
80106aa0:	5d                   	pop    %ebp
80106aa1:	c3                   	ret    
80106aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ab0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	57                   	push   %edi
80106ab4:	56                   	push   %esi
80106ab5:	53                   	push   %ebx
80106ab6:	83 ec 1c             	sub    $0x1c,%esp
80106ab9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106abc:	85 f6                	test   %esi,%esi
80106abe:	0f 84 cd 00 00 00    	je     80106b91 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106ac4:	8b 46 08             	mov    0x8(%esi),%eax
80106ac7:	85 c0                	test   %eax,%eax
80106ac9:	0f 84 da 00 00 00    	je     80106ba9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106acf:	8b 7e 04             	mov    0x4(%esi),%edi
80106ad2:	85 ff                	test   %edi,%edi
80106ad4:	0f 84 c3 00 00 00    	je     80106b9d <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
80106ada:	e8 81 d6 ff ff       	call   80104160 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106adf:	e8 7c cb ff ff       	call   80103660 <mycpu>
80106ae4:	89 c3                	mov    %eax,%ebx
80106ae6:	e8 75 cb ff ff       	call   80103660 <mycpu>
80106aeb:	89 c7                	mov    %eax,%edi
80106aed:	e8 6e cb ff ff       	call   80103660 <mycpu>
80106af2:	83 c7 08             	add    $0x8,%edi
80106af5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106af8:	e8 63 cb ff ff       	call   80103660 <mycpu>
80106afd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b00:	ba 67 00 00 00       	mov    $0x67,%edx
80106b05:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106b0c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b13:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106b1a:	83 c1 08             	add    $0x8,%ecx
80106b1d:	c1 e9 10             	shr    $0x10,%ecx
80106b20:	83 c0 08             	add    $0x8,%eax
80106b23:	c1 e8 18             	shr    $0x18,%eax
80106b26:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b2c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106b33:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b39:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106b3e:	e8 1d cb ff ff       	call   80103660 <mycpu>
80106b43:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b4a:	e8 11 cb ff ff       	call   80103660 <mycpu>
80106b4f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106b54:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b58:	e8 03 cb ff ff       	call   80103660 <mycpu>
80106b5d:	8b 56 08             	mov    0x8(%esi),%edx
80106b60:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106b66:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b69:	e8 f2 ca ff ff       	call   80103660 <mycpu>
80106b6e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106b72:	b8 28 00 00 00       	mov    $0x28,%eax
80106b77:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b7a:	8b 46 04             	mov    0x4(%esi),%eax
80106b7d:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b82:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106b85:	83 c4 1c             	add    $0x1c,%esp
80106b88:	5b                   	pop    %ebx
80106b89:	5e                   	pop    %esi
80106b8a:	5f                   	pop    %edi
80106b8b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106b8c:	e9 8f d6 ff ff       	jmp    80104220 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106b91:	c7 04 24 a6 7a 10 80 	movl   $0x80107aa6,(%esp)
80106b98:	e8 c3 97 ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106b9d:	c7 04 24 d1 7a 10 80 	movl   $0x80107ad1,(%esp)
80106ba4:	e8 b7 97 ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106ba9:	c7 04 24 bc 7a 10 80 	movl   $0x80107abc,(%esp)
80106bb0:	e8 ab 97 ff ff       	call   80100360 <panic>
80106bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bc0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	53                   	push   %ebx
80106bc6:	83 ec 1c             	sub    $0x1c,%esp
80106bc9:	8b 75 10             	mov    0x10(%ebp),%esi
80106bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80106bcf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106bd2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106bd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106bdb:	77 54                	ja     80106c31 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
80106bdd:	e8 1e b9 ff ff       	call   80102500 <kalloc>
  memset(mem, 0, PGSIZE);
80106be2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106be9:	00 
80106bea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bf1:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106bf2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106bf4:	89 04 24             	mov    %eax,(%esp)
80106bf7:	e8 e4 d6 ff ff       	call   801042e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106bfc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c02:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c07:	89 04 24             	mov    %eax,(%esp)
80106c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c0d:	31 d2                	xor    %edx,%edx
80106c0f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106c16:	00 
80106c17:	e8 94 fc ff ff       	call   801068b0 <mappages>
  memmove(mem, init, sz);
80106c1c:	89 75 10             	mov    %esi,0x10(%ebp)
80106c1f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c22:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c25:	83 c4 1c             	add    $0x1c,%esp
80106c28:	5b                   	pop    %ebx
80106c29:	5e                   	pop    %esi
80106c2a:	5f                   	pop    %edi
80106c2b:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106c2c:	e9 4f d7 ff ff       	jmp    80104380 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106c31:	c7 04 24 e5 7a 10 80 	movl   $0x80107ae5,(%esp)
80106c38:	e8 23 97 ff ff       	call   80100360 <panic>
80106c3d:	8d 76 00             	lea    0x0(%esi),%esi

80106c40 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
80106c46:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106c49:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106c50:	0f 85 98 00 00 00    	jne    80106cee <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106c56:	8b 75 18             	mov    0x18(%ebp),%esi
80106c59:	31 db                	xor    %ebx,%ebx
80106c5b:	85 f6                	test   %esi,%esi
80106c5d:	75 1a                	jne    80106c79 <loaduvm+0x39>
80106c5f:	eb 77                	jmp    80106cd8 <loaduvm+0x98>
80106c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c6e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106c74:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106c77:	76 5f                	jbe    80106cd8 <loaduvm+0x98>
80106c79:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c7c:	31 c9                	xor    %ecx,%ecx
80106c7e:	8b 45 08             	mov    0x8(%ebp),%eax
80106c81:	01 da                	add    %ebx,%edx
80106c83:	e8 98 fb ff ff       	call   80106820 <walkpgdir>
80106c88:	85 c0                	test   %eax,%eax
80106c8a:	74 56                	je     80106ce2 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106c8c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106c8e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106c93:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106c96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106c9b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106ca1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ca4:	05 00 00 00 80       	add    $0x80000000,%eax
80106ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cad:	8b 45 10             	mov    0x10(%ebp),%eax
80106cb0:	01 d9                	add    %ebx,%ecx
80106cb2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106cb6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106cba:	89 04 24             	mov    %eax,(%esp)
80106cbd:	e8 fe ac ff ff       	call   801019c0 <readi>
80106cc2:	39 f8                	cmp    %edi,%eax
80106cc4:	74 a2                	je     80106c68 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106cc6:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106cce:	5b                   	pop    %ebx
80106ccf:	5e                   	pop    %esi
80106cd0:	5f                   	pop    %edi
80106cd1:	5d                   	pop    %ebp
80106cd2:	c3                   	ret    
80106cd3:	90                   	nop
80106cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cd8:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106cdb:	31 c0                	xor    %eax,%eax
}
80106cdd:	5b                   	pop    %ebx
80106cde:	5e                   	pop    %esi
80106cdf:	5f                   	pop    %edi
80106ce0:	5d                   	pop    %ebp
80106ce1:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106ce2:	c7 04 24 ff 7a 10 80 	movl   $0x80107aff,(%esp)
80106ce9:	e8 72 96 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106cee:	c7 04 24 a0 7b 10 80 	movl   $0x80107ba0,(%esp)
80106cf5:	e8 66 96 ff ff       	call   80100360 <panic>
80106cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d00 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
80106d06:	83 ec 1c             	sub    $0x1c,%esp
80106d09:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106d0c:	85 ff                	test   %edi,%edi
80106d0e:	0f 88 7e 00 00 00    	js     80106d92 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80106d14:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106d1a:	72 78                	jb     80106d94 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106d1c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d22:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106d28:	39 df                	cmp    %ebx,%edi
80106d2a:	77 4a                	ja     80106d76 <allocuvm+0x76>
80106d2c:	eb 72                	jmp    80106da0 <allocuvm+0xa0>
80106d2e:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106d30:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106d37:	00 
80106d38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106d3f:	00 
80106d40:	89 04 24             	mov    %eax,(%esp)
80106d43:	e8 98 d5 ff ff       	call   801042e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d48:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d4e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d53:	89 04 24             	mov    %eax,(%esp)
80106d56:	8b 45 08             	mov    0x8(%ebp),%eax
80106d59:	89 da                	mov    %ebx,%edx
80106d5b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106d62:	00 
80106d63:	e8 48 fb ff ff       	call   801068b0 <mappages>
80106d68:	85 c0                	test   %eax,%eax
80106d6a:	78 44                	js     80106db0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106d6c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d72:	39 df                	cmp    %ebx,%edi
80106d74:	76 2a                	jbe    80106da0 <allocuvm+0xa0>
    mem = kalloc();
80106d76:	e8 85 b7 ff ff       	call   80102500 <kalloc>
    if(mem == 0){
80106d7b:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106d7d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106d7f:	75 af                	jne    80106d30 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106d81:	c7 04 24 1d 7b 10 80 	movl   $0x80107b1d,(%esp)
80106d88:	e8 c3 98 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d8d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d90:	77 48                	ja     80106dda <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106d92:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106d94:	83 c4 1c             	add    $0x1c,%esp
80106d97:	5b                   	pop    %ebx
80106d98:	5e                   	pop    %esi
80106d99:	5f                   	pop    %edi
80106d9a:	5d                   	pop    %ebp
80106d9b:	c3                   	ret    
80106d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106da0:	83 c4 1c             	add    $0x1c,%esp
80106da3:	89 f8                	mov    %edi,%eax
80106da5:	5b                   	pop    %ebx
80106da6:	5e                   	pop    %esi
80106da7:	5f                   	pop    %edi
80106da8:	5d                   	pop    %ebp
80106da9:	c3                   	ret    
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106db0:	c7 04 24 35 7b 10 80 	movl   $0x80107b35,(%esp)
80106db7:	e8 94 98 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106dbc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106dbf:	76 0d                	jbe    80106dce <allocuvm+0xce>
80106dc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dc4:	89 fa                	mov    %edi,%edx
80106dc6:	8b 45 08             	mov    0x8(%ebp),%eax
80106dc9:	e8 62 fb ff ff       	call   80106930 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106dce:	89 34 24             	mov    %esi,(%esp)
80106dd1:	e8 7a b5 ff ff       	call   80102350 <kfree>
      return 0;
80106dd6:	31 c0                	xor    %eax,%eax
80106dd8:	eb ba                	jmp    80106d94 <allocuvm+0x94>
80106dda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ddd:	89 fa                	mov    %edi,%edx
80106ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80106de2:	e8 49 fb ff ff       	call   80106930 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106de7:	31 c0                	xor    %eax,%eax
80106de9:	eb a9                	jmp    80106d94 <allocuvm+0x94>
80106deb:	90                   	nop
80106dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106df0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106df6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106df9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106dfc:	39 d1                	cmp    %edx,%ecx
80106dfe:	73 08                	jae    80106e08 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106e00:	5d                   	pop    %ebp
80106e01:	e9 2a fb ff ff       	jmp    80106930 <deallocuvm.part.0>
80106e06:	66 90                	xchg   %ax,%ax
80106e08:	89 d0                	mov    %edx,%eax
80106e0a:	5d                   	pop    %ebp
80106e0b:	c3                   	ret    
80106e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e10 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	56                   	push   %esi
80106e14:	53                   	push   %ebx
80106e15:	83 ec 10             	sub    $0x10,%esp
80106e18:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e1b:	85 f6                	test   %esi,%esi
80106e1d:	74 59                	je     80106e78 <freevm+0x68>
80106e1f:	31 c9                	xor    %ecx,%ecx
80106e21:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e26:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e28:	31 db                	xor    %ebx,%ebx
80106e2a:	e8 01 fb ff ff       	call   80106930 <deallocuvm.part.0>
80106e2f:	eb 12                	jmp    80106e43 <freevm+0x33>
80106e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e38:	83 c3 01             	add    $0x1,%ebx
80106e3b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106e41:	74 27                	je     80106e6a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e43:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106e46:	f6 c2 01             	test   $0x1,%dl
80106e49:	74 ed                	je     80106e38 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e4b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e51:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e54:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106e5a:	89 14 24             	mov    %edx,(%esp)
80106e5d:	e8 ee b4 ff ff       	call   80102350 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e62:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106e68:	75 d9                	jne    80106e43 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106e6a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e6d:	83 c4 10             	add    $0x10,%esp
80106e70:	5b                   	pop    %ebx
80106e71:	5e                   	pop    %esi
80106e72:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106e73:	e9 d8 b4 ff ff       	jmp    80102350 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106e78:	c7 04 24 51 7b 10 80 	movl   $0x80107b51,(%esp)
80106e7f:	e8 dc 94 ff ff       	call   80100360 <panic>
80106e84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e90 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	56                   	push   %esi
80106e94:	53                   	push   %ebx
80106e95:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106e98:	e8 63 b6 ff ff       	call   80102500 <kalloc>
80106e9d:	85 c0                	test   %eax,%eax
80106e9f:	89 c6                	mov    %eax,%esi
80106ea1:	74 6d                	je     80106f10 <setupkvm+0x80>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106ea3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106eaa:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106eab:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106eb0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106eb7:	00 
80106eb8:	89 04 24             	mov    %eax,(%esp)
80106ebb:	e8 20 d4 ff ff       	call   801042e0 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ec0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106ec3:	8b 43 04             	mov    0x4(%ebx),%eax
80106ec6:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ec9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106ecd:	8b 13                	mov    (%ebx),%edx
80106ecf:	89 04 24             	mov    %eax,(%esp)
80106ed2:	29 c1                	sub    %eax,%ecx
80106ed4:	89 f0                	mov    %esi,%eax
80106ed6:	e8 d5 f9 ff ff       	call   801068b0 <mappages>
80106edb:	85 c0                	test   %eax,%eax
80106edd:	78 19                	js     80106ef8 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106edf:	83 c3 10             	add    $0x10,%ebx
80106ee2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ee8:	72 d6                	jb     80106ec0 <setupkvm+0x30>
80106eea:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106eec:	83 c4 10             	add    $0x10,%esp
80106eef:	5b                   	pop    %ebx
80106ef0:	5e                   	pop    %esi
80106ef1:	5d                   	pop    %ebp
80106ef2:	c3                   	ret    
80106ef3:	90                   	nop
80106ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106ef8:	89 34 24             	mov    %esi,(%esp)
80106efb:	e8 10 ff ff ff       	call   80106e10 <freevm>
      return 0;
    }
  return pgdir;
}
80106f00:	83 c4 10             	add    $0x10,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106f03:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106f05:	5b                   	pop    %ebx
80106f06:	5e                   	pop    %esi
80106f07:	5d                   	pop    %ebp
80106f08:	c3                   	ret    
80106f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106f10:	31 c0                	xor    %eax,%eax
80106f12:	eb d8                	jmp    80106eec <setupkvm+0x5c>
80106f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f20 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f26:	e8 65 ff ff ff       	call   80106e90 <setupkvm>
80106f2b:	a3 c4 57 11 80       	mov    %eax,0x801157c4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f30:	05 00 00 00 80       	add    $0x80000000,%eax
80106f35:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106f38:	c9                   	leave  
80106f39:	c3                   	ret    
80106f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f40 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f40:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f41:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f43:	89 e5                	mov    %esp,%ebp
80106f45:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f4e:	e8 cd f8 ff ff       	call   80106820 <walkpgdir>
  if(pte == 0)
80106f53:	85 c0                	test   %eax,%eax
80106f55:	74 05                	je     80106f5c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106f57:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f5a:	c9                   	leave  
80106f5b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106f5c:	c7 04 24 62 7b 10 80 	movl   $0x80107b62,(%esp)
80106f63:	e8 f8 93 ff ff       	call   80100360 <panic>
80106f68:	90                   	nop
80106f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f70 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
80106f76:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f79:	e8 12 ff ff ff       	call   80106e90 <setupkvm>
80106f7e:	85 c0                	test   %eax,%eax
80106f80:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f83:	0f 84 b2 00 00 00    	je     8010703b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f89:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f8c:	85 c0                	test   %eax,%eax
80106f8e:	0f 84 9c 00 00 00    	je     80107030 <copyuvm+0xc0>
80106f94:	31 db                	xor    %ebx,%ebx
80106f96:	eb 48                	jmp    80106fe0 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f98:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106f9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106fa5:	00 
80106fa6:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106faa:	89 04 24             	mov    %eax,(%esp)
80106fad:	e8 ce d3 ff ff       	call   80104380 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fb5:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106fbb:	89 14 24             	mov    %edx,(%esp)
80106fbe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fc3:	89 da                	mov    %ebx,%edx
80106fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fcc:	e8 df f8 ff ff       	call   801068b0 <mappages>
80106fd1:	85 c0                	test   %eax,%eax
80106fd3:	78 41                	js     80107016 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106fd5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fdb:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106fde:	76 50                	jbe    80107030 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe3:	31 c9                	xor    %ecx,%ecx
80106fe5:	89 da                	mov    %ebx,%edx
80106fe7:	e8 34 f8 ff ff       	call   80106820 <walkpgdir>
80106fec:	85 c0                	test   %eax,%eax
80106fee:	74 5b                	je     8010704b <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106ff0:	8b 30                	mov    (%eax),%esi
80106ff2:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106ff8:	74 45                	je     8010703f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106ffa:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106ffc:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107002:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107005:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
8010700b:	e8 f0 b4 ff ff       	call   80102500 <kalloc>
80107010:	85 c0                	test   %eax,%eax
80107012:	89 c6                	mov    %eax,%esi
80107014:	75 82                	jne    80106f98 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107016:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107019:	89 04 24             	mov    %eax,(%esp)
8010701c:	e8 ef fd ff ff       	call   80106e10 <freevm>
  return 0;
80107021:	31 c0                	xor    %eax,%eax
}
80107023:	83 c4 2c             	add    $0x2c,%esp
80107026:	5b                   	pop    %ebx
80107027:	5e                   	pop    %esi
80107028:	5f                   	pop    %edi
80107029:	5d                   	pop    %ebp
8010702a:	c3                   	ret    
8010702b:	90                   	nop
8010702c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107030:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107033:	83 c4 2c             	add    $0x2c,%esp
80107036:	5b                   	pop    %ebx
80107037:	5e                   	pop    %esi
80107038:	5f                   	pop    %edi
80107039:	5d                   	pop    %ebp
8010703a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010703b:	31 c0                	xor    %eax,%eax
8010703d:	eb e4                	jmp    80107023 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
8010703f:	c7 04 24 86 7b 10 80 	movl   $0x80107b86,(%esp)
80107046:	e8 15 93 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010704b:	c7 04 24 6c 7b 10 80 	movl   $0x80107b6c,(%esp)
80107052:	e8 09 93 ff ff       	call   80100360 <panic>
80107057:	89 f6                	mov    %esi,%esi
80107059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107060 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107060:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107061:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107063:	89 e5                	mov    %esp,%ebp
80107065:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107068:	8b 55 0c             	mov    0xc(%ebp),%edx
8010706b:	8b 45 08             	mov    0x8(%ebp),%eax
8010706e:	e8 ad f7 ff ff       	call   80106820 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107073:	8b 00                	mov    (%eax),%eax
80107075:	89 c2                	mov    %eax,%edx
80107077:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
8010707a:	83 fa 05             	cmp    $0x5,%edx
8010707d:	75 11                	jne    80107090 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010707f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107084:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107089:	c9                   	leave  
8010708a:	c3                   	ret    
8010708b:	90                   	nop
8010708c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107090:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107092:	c9                   	leave  
80107093:	c3                   	ret    
80107094:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010709a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
801070a6:	83 ec 1c             	sub    $0x1c,%esp
801070a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801070ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801070af:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070b2:	85 db                	test   %ebx,%ebx
801070b4:	75 3a                	jne    801070f0 <copyout+0x50>
801070b6:	eb 68                	jmp    80107120 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801070b8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070bb:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801070bd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801070c1:	29 ca                	sub    %ecx,%edx
801070c3:	81 c2 00 10 00 00    	add    $0x1000,%edx
801070c9:	39 da                	cmp    %ebx,%edx
801070cb:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801070ce:	29 f1                	sub    %esi,%ecx
801070d0:	01 c8                	add    %ecx,%eax
801070d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801070d6:	89 04 24             	mov    %eax,(%esp)
801070d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801070dc:	e8 9f d2 ff ff       	call   80104380 <memmove>
    len -= n;
    buf += n;
801070e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
801070e4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
801070ea:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070ec:	29 d3                	sub    %edx,%ebx
801070ee:	74 30                	je     80107120 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
801070f0:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801070f3:	89 ce                	mov    %ecx,%esi
801070f5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801070fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801070ff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107102:	89 04 24             	mov    %eax,(%esp)
80107105:	e8 56 ff ff ff       	call   80107060 <uva2ka>
    if(pa0 == 0)
8010710a:	85 c0                	test   %eax,%eax
8010710c:	75 aa                	jne    801070b8 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010710e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107111:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107116:	5b                   	pop    %ebx
80107117:	5e                   	pop    %esi
80107118:	5f                   	pop    %edi
80107119:	5d                   	pop    %ebp
8010711a:	c3                   	ret    
8010711b:	90                   	nop
8010711c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107120:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107123:	31 c0                	xor    %eax,%eax
}
80107125:	5b                   	pop    %ebx
80107126:	5e                   	pop    %esi
80107127:	5f                   	pop    %edi
80107128:	5d                   	pop    %ebp
80107129:	c3                   	ret    
