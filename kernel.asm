
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 2e 10 80       	mov    $0x80102e70,%eax
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
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 e0 75 10 	movl   $0x801075e0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010005b:	e8 70 40 00 00       	call   801040d0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006c:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100076:	0c 11 80 
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
8010008a:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 e7 75 10 	movl   $0x801075e7,0x4(%esp)
8010009b:	80 
8010009c:	e8 1f 3f 00 00       	call   80103fc0 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 0d 11 80       	mov    0x80110d10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

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
801000dc:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
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
801000e6:	e8 d5 40 00 00       	call   801041c0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f1:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
8010015a:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100161:	e8 4a 41 00 00       	call   801042b0 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 8f 3e 00 00       	call   80104000 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 22 20 00 00       	call   801021a0 <iderw>
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
80100188:	c7 04 24 ee 75 10 80 	movl   $0x801075ee,(%esp)
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
801001b0:	e8 eb 3e 00 00       	call   801040a0 <holdingsleep>
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
801001c4:	e9 d7 1f 00 00       	jmp    801021a0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 ff 75 10 80 	movl   $0x801075ff,(%esp)
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
801001f1:	e8 aa 3e 00 00       	call   801040a0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 5e 3e 00 00       	call   80104060 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100209:	e8 b2 3f 00 00       	call   801041c0 <acquire>
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
80100226:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
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
80100250:	e9 5b 40 00 00       	jmp    801042b0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 06 76 10 80 	movl   $0x80107606,(%esp)
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
80100282:	e8 39 15 00 00       	call   801017c0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028e:	e8 2d 3f 00 00       	call   801041c0 <acquire>
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
801002a8:	e8 73 34 00 00       	call   80103720 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 b5 10 	movl   $0x8010b520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 0f 11 80 	movl   $0x80110fa0,(%esp)
801002c3:	e8 b8 39 00 00       	call   80103c80 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c8:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cd:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 0f 11 80 	movzbl -0x7feef0e0(%edx),%ecx
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
80100307:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 9a 3f 00 00       	call   801042b0 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 c2 13 00 00       	call   801016e0 <ilock>
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
80100328:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010032f:	e8 7c 3f 00 00       	call   801042b0 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 a4 13 00 00       	call   801016e0 <ilock>
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
8010034e:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
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
80100369:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
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
80100376:	e8 65 24 00 00       	call   801027e0 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 0d 76 10 80 	movl   $0x8010760d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 c2 7d 10 80 	movl   $0x80107dc2,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 3c 3d 00 00       	call   801040f0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 21 76 10 80 	movl   $0x80107621,(%esp)
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
801003d1:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
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
80100409:	e8 32 5d 00 00       	call   80106140 <uartputc>
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
801004b9:	e8 82 5c 00 00       	call   80106140 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 76 5c 00 00       	call   80106140 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 6a 5c 00 00       	call   80106140 <uartputc>
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
801004fc:	e8 9f 3e 00 00       	call   801043a0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 e2 3d 00 00       	call   80104300 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 25 76 10 80 	movl   $0x80107625,(%esp)
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
80100599:	0f b6 92 50 76 10 80 	movzbl -0x7fef89b0(%edx),%edx
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
80100602:	e8 b9 11 00 00       	call   801017c0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010060e:	e8 ad 3b 00 00       	call   801041c0 <acquire>
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
8010062f:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100636:	e8 75 3c 00 00       	call   801042b0 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 9a 10 00 00       	call   801016e0 <ilock>

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
80100659:	a1 54 b5 10 80       	mov    0x8010b554,%eax
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
801006ec:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801006f3:	e8 b8 3b 00 00       	call   801042b0 <release>
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
80100760:	b8 38 76 10 80       	mov    $0x80107638,%eax
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
80100790:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100797:	e8 24 3a 00 00       	call   801041c0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 3f 76 10 80 	movl   $0x8010763f,(%esp)
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
801007be:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801007c5:	e8 f6 39 00 00       	call   801041c0 <acquire>
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
801007f2:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801007f7:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
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
80100820:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100827:	e8 84 3a 00 00       	call   801042b0 <release>
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
80100849:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
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
80100868:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 0f 11 80    	mov    0x80110fa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 a0 0f 11 80 	movl   $0x80110fa0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
801008b2:	e8 59 35 00 00       	call   80103e10 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008c5:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ec:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
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
80100900:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
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
80100927:	e9 c4 35 00 00       	jmp    80103ef0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
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
80100956:	c7 44 24 04 48 76 10 	movl   $0x80107648,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100965:	e8 66 37 00 00       	call   801040d0 <initlock>

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
80100979:	c7 05 6c 19 11 80 f0 	movl   $0x801005f0,0x8011196c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100994:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100997:	e8 94 19 00 00       	call   80102330 <ioapicenable>
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
801009ac:	e8 6f 2d 00 00       	call   80103720 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 d4 21 00 00       	call   80102b90 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 b9 15 00 00       	call   80101f80 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 07 0d 00 00       	call   801016e0 <ilock>
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
801009f6:	e8 e5 0f 00 00       	call   801019e0 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 88 0f 00 00       	call   80101990 <iunlockput>
    end_op();
80100a08:	e8 f3 21 00 00       	call   80102c00 <end_op>
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
80100a2c:	e8 ff 68 00 00       	call   80107330 <setupkvm>
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
80100a8e:	e8 4d 0f 00 00       	call   801019e0 <readi>
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
80100ad2:	e8 c9 66 00 00       	call   801071a0 <allocuvm>
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
80100b13:	e8 c8 65 00 00       	call   801070e0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 82 67 00 00       	call   801072b0 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 55 0e 00 00       	call   80101990 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 bb 20 00 00       	call   80102c00 <end_op>
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
80100b6c:	e8 2f 66 00 00       	call   801071a0 <allocuvm>
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
80100b84:	e8 27 67 00 00       	call   801072b0 <freevm>
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
80100b93:	e8 68 20 00 00       	call   80102c00 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 61 76 10 80 	movl   $0x80107661,(%esp)
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
80100bc8:	e8 13 68 00 00       	call   801073e0 <clearpteu>
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
80100c01:	e8 1a 39 00 00       	call   80104520 <strlen>
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
80100c12:	e8 09 39 00 00       	call   80104520 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 0a 69 00 00       	call   80107540 <copyout>
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
80100ca4:	e8 97 68 00 00       	call   80107540 <copyout>
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
80100cf1:	e8 ea 37 00 00       	call   801044e0 <safestrcpy>

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
80100d1f:	e8 2c 62 00 00       	call   80106f50 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 84 65 00 00       	call   801072b0 <freevm>
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
80100d56:	c7 44 24 04 6d 76 10 	movl   $0x8010766d,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100d65:	e8 66 33 00 00       	call   801040d0 <initlock>
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
80100d74:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100d83:	e8 38 34 00 00       	call   801041c0 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 fb 34 00 00       	call   801042b0 <release>
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
80100dc0:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100dc7:	e8 e4 34 00 00       	call   801042b0 <release>
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
80100dea:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100df1:	e8 ca 33 00 00       	call   801041c0 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100e0a:	e8 a1 34 00 00       	call   801042b0 <release>
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
80100e17:	c7 04 24 74 76 10 80 	movl   $0x80107674,(%esp)
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
80100e3c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100e43:	e8 78 33 00 00       	call   801041c0 <acquire>
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
80100e5d:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
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
80100e6b:	e9 40 34 00 00       	jmp    801042b0 <release>
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
80100e85:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
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
80100e8f:	e8 1c 34 00 00       	call   801042b0 <release>

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
80100eb3:	e8 28 24 00 00       	call   801032e0 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ec0:	e8 cb 1c 00 00       	call   80102b90 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 80 09 00 00       	call   80101850 <iput>
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
80100ed7:	e9 24 1d 00 00       	jmp    80102c00 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100edc:	c7 04 24 7c 76 10 80 	movl   $0x8010767c,(%esp)
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
80100f05:	e8 d6 07 00 00       	call   801016e0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 94 0a 00 00       	call   801019b0 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 99 08 00 00       	call   801017c0 <iunlock>
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
80100f6a:	e8 71 07 00 00       	call   801016e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 57 0a 00 00       	call   801019e0 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 23 08 00 00       	call   801017c0 <iunlock>
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
80100fb5:	e9 a6 24 00 00       	jmp    80103460 <piperead>
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
80100fc7:	c7 04 24 86 76 10 80 	movl   $0x80107686,(%esp)
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
80101034:	e8 87 07 00 00       	call   801017c0 <iunlock>
      end_op();
80101039:	e8 c2 1b 00 00       	call   80102c00 <end_op>
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
80101063:	e8 28 1b 00 00       	call   80102b90 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 6d 06 00 00       	call   801016e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 4e 0a 00 00       	call   80101ae0 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 1c 07 00 00       	call   801017c0 <iunlock>
      end_op();
801010a4:	e8 57 1b 00 00       	call   80102c00 <end_op>

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
801010dc:	e9 8f 22 00 00       	jmp    80103370 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	c7 04 24 8f 76 10 80 	movl   $0x8010768f,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ed:	c7 04 24 95 76 10 80 	movl   $0x80107695,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	89 c7                	mov    %eax,%edi
80101106:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101107:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101109:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010110a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010110f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101112:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101119:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010111c:	e8 9f 30 00 00       	call   801041c0 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101121:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101124:	eb 14                	jmp    8010113a <iget+0x3a>
80101126:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101128:	85 f6                	test   %esi,%esi
8010112a:	74 3c                	je     80101168 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010112c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101132:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101138:	74 46                	je     80101180 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010113a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010113d:	85 c9                	test   %ecx,%ecx
8010113f:	7e e7                	jle    80101128 <iget+0x28>
80101141:	39 3b                	cmp    %edi,(%ebx)
80101143:	75 e3                	jne    80101128 <iget+0x28>
80101145:	39 53 04             	cmp    %edx,0x4(%ebx)
80101148:	75 de                	jne    80101128 <iget+0x28>
      ip->ref++;
8010114a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010114d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010114f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101156:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101159:	e8 52 31 00 00       	call   801042b0 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010115e:	83 c4 1c             	add    $0x1c,%esp
80101161:	89 f0                	mov    %esi,%eax
80101163:	5b                   	pop    %ebx
80101164:	5e                   	pop    %esi
80101165:	5f                   	pop    %edi
80101166:	5d                   	pop    %ebp
80101167:	c3                   	ret    
80101168:	85 c9                	test   %ecx,%ecx
8010116a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010116d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101173:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101179:	75 bf                	jne    8010113a <iget+0x3a>
8010117b:	90                   	nop
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101180:	85 f6                	test   %esi,%esi
80101182:	74 29                	je     801011ad <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101184:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101186:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101189:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101190:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101197:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010119e:	e8 0d 31 00 00       	call   801042b0 <release>

  return ip;
}
801011a3:	83 c4 1c             	add    $0x1c,%esp
801011a6:	89 f0                	mov    %esi,%eax
801011a8:	5b                   	pop    %ebx
801011a9:	5e                   	pop    %esi
801011aa:	5f                   	pop    %edi
801011ab:	5d                   	pop    %ebp
801011ac:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801011ad:	c7 04 24 9f 76 10 80 	movl   $0x8010769f,(%esp)
801011b4:	e8 a7 f1 ff ff       	call   80100360 <panic>
801011b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801011c0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 2c             	sub    $0x2c,%esp
801011c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011cc:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801011d1:	85 c0                	test   %eax,%eax
801011d3:	0f 84 8c 00 00 00    	je     80101265 <balloc+0xa5>
801011d9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011e0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011e3:	89 f0                	mov    %esi,%eax
801011e5:	c1 f8 0c             	sar    $0xc,%eax
801011e8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801011ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801011f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011f5:	89 04 24             	mov    %eax,(%esp)
801011f8:	e8 d3 ee ff ff       	call   801000d0 <bread>
801011fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101200:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101205:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101208:	31 c0                	xor    %eax,%eax
8010120a:	eb 33                	jmp    8010123f <balloc+0x7f>
8010120c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101210:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101213:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101215:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101217:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010121a:	83 e1 07             	and    $0x7,%ecx
8010121d:	bf 01 00 00 00       	mov    $0x1,%edi
80101222:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101224:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101229:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010122b:	0f b6 fb             	movzbl %bl,%edi
8010122e:	85 cf                	test   %ecx,%edi
80101230:	74 46                	je     80101278 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101232:	83 c0 01             	add    $0x1,%eax
80101235:	83 c6 01             	add    $0x1,%esi
80101238:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010123d:	74 05                	je     80101244 <balloc+0x84>
8010123f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101242:	72 cc                	jb     80101210 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101247:	89 04 24             	mov    %eax,(%esp)
8010124a:	e8 91 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010124f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101256:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101259:	3b 05 c0 19 11 80    	cmp    0x801119c0,%eax
8010125f:	0f 82 7b ff ff ff    	jb     801011e0 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101265:	c7 04 24 af 76 10 80 	movl   $0x801076af,(%esp)
8010126c:	e8 ef f0 ff ff       	call   80100360 <panic>
80101271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101278:	09 d9                	or     %ebx,%ecx
8010127a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010127d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101281:	89 1c 24             	mov    %ebx,(%esp)
80101284:	e8 a7 1a 00 00       	call   80102d30 <log_write>
        brelse(bp);
80101289:	89 1c 24             	mov    %ebx,(%esp)
8010128c:	e8 4f ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101291:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101294:	89 74 24 04          	mov    %esi,0x4(%esp)
80101298:	89 04 24             	mov    %eax,(%esp)
8010129b:	e8 30 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012a0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801012a7:	00 
801012a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801012af:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801012b0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012b2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012b5:	89 04 24             	mov    %eax,(%esp)
801012b8:	e8 43 30 00 00       	call   80104300 <memset>
  log_write(bp);
801012bd:	89 1c 24             	mov    %ebx,(%esp)
801012c0:	e8 6b 1a 00 00       	call   80102d30 <log_write>
  brelse(bp);
801012c5:	89 1c 24             	mov    %ebx,(%esp)
801012c8:	e8 13 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801012cd:	83 c4 2c             	add    $0x2c,%esp
801012d0:	89 f0                	mov    %esi,%eax
801012d2:	5b                   	pop    %ebx
801012d3:	5e                   	pop    %esi
801012d4:	5f                   	pop    %edi
801012d5:	5d                   	pop    %ebp
801012d6:	c3                   	ret    
801012d7:	89 f6                	mov    %esi,%esi
801012d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
80101339:	e8 82 fe ff ff       	call   801011c0 <balloc>
8010133e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101341:	89 02                	mov    %eax,(%edx)
80101343:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101345:	89 3c 24             	mov    %edi,(%esp)
80101348:	e8 e3 19 00 00       	call   80102d30 <log_write>
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
80101362:	e8 59 fe ff ff       	call   801011c0 <balloc>
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
8010137a:	e8 41 fe ff ff       	call   801011c0 <balloc>
8010137f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101385:	eb 93                	jmp    8010131a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101387:	c7 04 24 c5 76 10 80 	movl   $0x801076c5,(%esp)
8010138e:	e8 cd ef ff ff       	call   80100360 <panic>
80101393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <igetCaller>:
// there should be one superblock per disk device, but we run with
// only one device
struct superblock sb;

struct inode*
igetCaller(uint inum){
801013a0:	55                   	push   %ebp
	return iget(1,inum);
801013a1:	b8 01 00 00 00       	mov    $0x1,%eax
// there should be one superblock per disk device, but we run with
// only one device
struct superblock sb;

struct inode*
igetCaller(uint inum){
801013a6:	89 e5                	mov    %esp,%ebp
	return iget(1,inum);
801013a8:	8b 55 08             	mov    0x8(%ebp),%edx
}
801013ab:	5d                   	pop    %ebp
// only one device
struct superblock sb;

struct inode*
igetCaller(uint inum){
	return iget(1,inum);
801013ac:	e9 4f fd ff ff       	jmp    80101100 <iget>
801013b1:	eb 0d                	jmp    801013c0 <readsb>
801013b3:	90                   	nop
801013b4:	90                   	nop
801013b5:	90                   	nop
801013b6:	90                   	nop
801013b7:	90                   	nop
801013b8:	90                   	nop
801013b9:	90                   	nop
801013ba:	90                   	nop
801013bb:	90                   	nop
801013bc:	90                   	nop
801013bd:	90                   	nop
801013be:	90                   	nop
801013bf:	90                   	nop

801013c0 <readsb>:
}

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013c8:	8b 45 08             	mov    0x8(%ebp),%eax
801013cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013d2:	00 
}

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013d3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013d6:	89 04 24             	mov    %eax,(%esp)
801013d9:	e8 f2 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013de:	89 34 24             	mov    %esi,(%esp)
801013e1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013e8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013e9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013eb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801013f2:	e8 a9 2f 00 00       	call   801043a0 <memmove>
  brelse(bp);
801013f7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013fa:	83 c4 10             	add    $0x10,%esp
801013fd:	5b                   	pop    %ebx
801013fe:	5e                   	pop    %esi
801013ff:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101400:	e9 db ed ff ff       	jmp    801001e0 <brelse>
80101405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	89 d7                	mov    %edx,%edi
80101416:	56                   	push   %esi
80101417:	53                   	push   %ebx
80101418:	89 c3                	mov    %eax,%ebx
8010141a:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010141d:	89 04 24             	mov    %eax,(%esp)
80101420:	c7 44 24 04 c0 19 11 	movl   $0x801119c0,0x4(%esp)
80101427:	80 
80101428:	e8 93 ff ff ff       	call   801013c0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010142d:	89 fa                	mov    %edi,%edx
8010142f:	c1 ea 0c             	shr    $0xc,%edx
80101432:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101438:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010143b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101440:	89 54 24 04          	mov    %edx,0x4(%esp)
80101444:	e8 87 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101449:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010144b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101451:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101453:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101456:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101459:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010145b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010145d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101462:	0f b6 c8             	movzbl %al,%ecx
80101465:	85 d9                	test   %ebx,%ecx
80101467:	74 20                	je     80101489 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101469:	f7 d3                	not    %ebx
8010146b:	21 c3                	and    %eax,%ebx
8010146d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101471:	89 34 24             	mov    %esi,(%esp)
80101474:	e8 b7 18 00 00       	call   80102d30 <log_write>
  brelse(bp);
80101479:	89 34 24             	mov    %esi,(%esp)
8010147c:	e8 5f ed ff ff       	call   801001e0 <brelse>
}
80101481:	83 c4 1c             	add    $0x1c,%esp
80101484:	5b                   	pop    %ebx
80101485:	5e                   	pop    %esi
80101486:	5f                   	pop    %edi
80101487:	5d                   	pop    %ebp
80101488:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101489:	c7 04 24 d8 76 10 80 	movl   $0x801076d8,(%esp)
80101490:	e8 cb ee ff ff       	call   80100360 <panic>
80101495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014a0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	53                   	push   %ebx
801014a4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801014a9:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801014ac:	c7 44 24 04 eb 76 10 	movl   $0x801076eb,0x4(%esp)
801014b3:	80 
801014b4:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801014bb:	e8 10 2c 00 00       	call   801040d0 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014c0:	89 1c 24             	mov    %ebx,(%esp)
801014c3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014c9:	c7 44 24 04 f2 76 10 	movl   $0x801076f2,0x4(%esp)
801014d0:	80 
801014d1:	e8 ea 2a 00 00       	call   80103fc0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014d6:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014dc:	75 e2                	jne    801014c0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014de:	8b 45 08             	mov    0x8(%ebp),%eax
801014e1:	c7 44 24 04 c0 19 11 	movl   $0x801119c0,0x4(%esp)
801014e8:	80 
801014e9:	89 04 24             	mov    %eax,(%esp)
801014ec:	e8 cf fe ff ff       	call   801013c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014f1:	a1 d8 19 11 80       	mov    0x801119d8,%eax
801014f6:	c7 04 24 58 77 10 80 	movl   $0x80107758,(%esp)
801014fd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101501:	a1 d4 19 11 80       	mov    0x801119d4,%eax
80101506:	89 44 24 18          	mov    %eax,0x18(%esp)
8010150a:	a1 d0 19 11 80       	mov    0x801119d0,%eax
8010150f:	89 44 24 14          	mov    %eax,0x14(%esp)
80101513:	a1 cc 19 11 80       	mov    0x801119cc,%eax
80101518:	89 44 24 10          	mov    %eax,0x10(%esp)
8010151c:	a1 c8 19 11 80       	mov    0x801119c8,%eax
80101521:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101525:	a1 c4 19 11 80       	mov    0x801119c4,%eax
8010152a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010152e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101533:	89 44 24 04          	mov    %eax,0x4(%esp)
80101537:	e8 14 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010153c:	83 c4 24             	add    $0x24,%esp
8010153f:	5b                   	pop    %ebx
80101540:	5d                   	pop    %ebp
80101541:	c3                   	ret    
80101542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101550 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 2c             	sub    $0x2c,%esp
80101559:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101563:	8b 7d 08             	mov    0x8(%ebp),%edi
80101566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101569:	0f 86 a2 00 00 00    	jbe    80101611 <ialloc+0xc1>
8010156f:	be 01 00 00 00       	mov    $0x1,%esi
80101574:	bb 01 00 00 00       	mov    $0x1,%ebx
80101579:	eb 1a                	jmp    80101595 <ialloc+0x45>
8010157b:	90                   	nop
8010157c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101580:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101583:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101586:	e8 55 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010158b:	89 de                	mov    %ebx,%esi
8010158d:	3b 1d c8 19 11 80    	cmp    0x801119c8,%ebx
80101593:	73 7c                	jae    80101611 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101595:	89 f0                	mov    %esi,%eax
80101597:	c1 e8 03             	shr    $0x3,%eax
8010159a:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015a0:	89 3c 24             	mov    %edi,(%esp)
801015a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
801015ac:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
801015ae:	89 f0                	mov    %esi,%eax
801015b0:	83 e0 07             	and    $0x7,%eax
801015b3:	c1 e0 06             	shl    $0x6,%eax
801015b6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ba:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015be:	75 c0                	jne    80101580 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015c0:	89 0c 24             	mov    %ecx,(%esp)
801015c3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015ca:	00 
801015cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015d2:	00 
801015d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015d9:	e8 22 2d 00 00       	call   80104300 <memset>
      dip->type = type;
801015de:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015e8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015eb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ee:	89 14 24             	mov    %edx,(%esp)
801015f1:	e8 3a 17 00 00       	call   80102d30 <log_write>
      brelse(bp);
801015f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015f9:	89 14 24             	mov    %edx,(%esp)
801015fc:	e8 df eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101601:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101604:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101606:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101607:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101609:	5e                   	pop    %esi
8010160a:	5f                   	pop    %edi
8010160b:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010160c:	e9 ef fa ff ff       	jmp    80101100 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101611:	c7 04 24 f8 76 10 80 	movl   $0x801076f8,(%esp)
80101618:	e8 43 ed ff ff       	call   80100360 <panic>
8010161d:	8d 76 00             	lea    0x0(%esi),%esi

80101620 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	83 ec 10             	sub    $0x10,%esp
80101628:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010162b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101631:	c1 e8 03             	shr    $0x3,%eax
80101634:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010163a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010163e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101641:	89 04 24             	mov    %eax,(%esp)
80101644:	e8 87 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101649:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010164c:	83 e2 07             	and    $0x7,%edx
8010164f:	c1 e2 06             	shl    $0x6,%edx
80101652:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101656:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101658:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010165f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101663:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101667:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010166b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010166f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101673:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101677:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010167b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010167e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101681:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101685:	89 14 24             	mov    %edx,(%esp)
80101688:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010168f:	00 
80101690:	e8 0b 2d 00 00       	call   801043a0 <memmove>
  log_write(bp);
80101695:	89 34 24             	mov    %esi,(%esp)
80101698:	e8 93 16 00 00       	call   80102d30 <log_write>
  brelse(bp);
8010169d:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016a0:	83 c4 10             	add    $0x10,%esp
801016a3:	5b                   	pop    %ebx
801016a4:	5e                   	pop    %esi
801016a5:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801016a6:	e9 35 eb ff ff       	jmp    801001e0 <brelse>
801016ab:	90                   	nop
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016b0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	53                   	push   %ebx
801016b4:	83 ec 14             	sub    $0x14,%esp
801016b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ba:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016c1:	e8 fa 2a 00 00       	call   801041c0 <acquire>
  ip->ref++;
801016c6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016ca:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016d1:	e8 da 2b 00 00       	call   801042b0 <release>
  return ip;
}
801016d6:	83 c4 14             	add    $0x14,%esp
801016d9:	89 d8                	mov    %ebx,%eax
801016db:	5b                   	pop    %ebx
801016dc:	5d                   	pop    %ebp
801016dd:	c3                   	ret    
801016de:	66 90                	xchg   %ax,%ax

801016e0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	83 ec 10             	sub    $0x10,%esp
801016e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016eb:	85 db                	test   %ebx,%ebx
801016ed:	0f 84 b3 00 00 00    	je     801017a6 <ilock+0xc6>
801016f3:	8b 53 08             	mov    0x8(%ebx),%edx
801016f6:	85 d2                	test   %edx,%edx
801016f8:	0f 8e a8 00 00 00    	jle    801017a6 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016fe:	8d 43 0c             	lea    0xc(%ebx),%eax
80101701:	89 04 24             	mov    %eax,(%esp)
80101704:	e8 f7 28 00 00       	call   80104000 <acquiresleep>

  if(ip->valid == 0){
80101709:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010170c:	85 c0                	test   %eax,%eax
8010170e:	74 08                	je     80101718 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101710:	83 c4 10             	add    $0x10,%esp
80101713:	5b                   	pop    %ebx
80101714:	5e                   	pop    %esi
80101715:	5d                   	pop    %ebp
80101716:	c3                   	ret    
80101717:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101718:	8b 43 04             	mov    0x4(%ebx),%eax
8010171b:	c1 e8 03             	shr    $0x3,%eax
8010171e:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101724:	89 44 24 04          	mov    %eax,0x4(%esp)
80101728:	8b 03                	mov    (%ebx),%eax
8010172a:	89 04 24             	mov    %eax,(%esp)
8010172d:	e8 9e e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101732:	8b 53 04             	mov    0x4(%ebx),%edx
80101735:	83 e2 07             	and    $0x7,%edx
80101738:	c1 e2 06             	shl    $0x6,%edx
8010173b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010173f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101741:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101744:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101747:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010174b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010174f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101753:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101757:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010175b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010175f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101763:	8b 42 fc             	mov    -0x4(%edx),%eax
80101766:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101769:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010176c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101770:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101777:	00 
80101778:	89 04 24             	mov    %eax,(%esp)
8010177b:	e8 20 2c 00 00       	call   801043a0 <memmove>
    brelse(bp);
80101780:	89 34 24             	mov    %esi,(%esp)
80101783:	e8 58 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101788:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010178d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101794:	0f 85 76 ff ff ff    	jne    80101710 <ilock+0x30>
      panic("ilock: no type");
8010179a:	c7 04 24 10 77 10 80 	movl   $0x80107710,(%esp)
801017a1:	e8 ba eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801017a6:	c7 04 24 0a 77 10 80 	movl   $0x8010770a,(%esp)
801017ad:	e8 ae eb ff ff       	call   80100360 <panic>
801017b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017c0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	83 ec 10             	sub    $0x10,%esp
801017c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017cb:	85 db                	test   %ebx,%ebx
801017cd:	74 24                	je     801017f3 <iunlock+0x33>
801017cf:	8d 73 0c             	lea    0xc(%ebx),%esi
801017d2:	89 34 24             	mov    %esi,(%esp)
801017d5:	e8 c6 28 00 00       	call   801040a0 <holdingsleep>
801017da:	85 c0                	test   %eax,%eax
801017dc:	74 15                	je     801017f3 <iunlock+0x33>
801017de:	8b 43 08             	mov    0x8(%ebx),%eax
801017e1:	85 c0                	test   %eax,%eax
801017e3:	7e 0e                	jle    801017f3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017e5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017e8:	83 c4 10             	add    $0x10,%esp
801017eb:	5b                   	pop    %ebx
801017ec:	5e                   	pop    %esi
801017ed:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ee:	e9 6d 28 00 00       	jmp    80104060 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017f3:	c7 04 24 1f 77 10 80 	movl   $0x8010771f,(%esp)
801017fa:	e8 61 eb ff ff       	call   80100360 <panic>
801017ff:	90                   	nop

80101800 <callDeleteInFS>:
  log_write(bp);
  brelse(bp);
}

void
callDeleteInFS(uint inum){
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	53                   	push   %ebx
80101804:	83 ec 14             	sub    $0x14,%esp
80101807:	8b 5d 08             	mov    0x8(%ebp),%ebx
	begin_op();
8010180a:	e8 81 13 00 00       	call   80102b90 <begin_op>
	struct inode *inodeToDel;
	inodeToDel = iget(1,inum);
8010180f:	b8 01 00 00 00       	mov    $0x1,%eax
80101814:	89 da                	mov    %ebx,%edx
80101816:	e8 e5 f8 ff ff       	call   80101100 <iget>
8010181b:	89 c3                	mov    %eax,%ebx
	ilock(inodeToDel);
8010181d:	89 04 24             	mov    %eax,(%esp)
80101820:	e8 bb fe ff ff       	call   801016e0 <ilock>

	inodeToDel->addrs[0] = 0;
80101825:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)

	iupdate(inodeToDel);
8010182c:	89 1c 24             	mov    %ebx,(%esp)
8010182f:	e8 ec fd ff ff       	call   80101620 <iupdate>
	iunlock(inodeToDel);
80101834:	89 1c 24             	mov    %ebx,(%esp)
80101837:	e8 84 ff ff ff       	call   801017c0 <iunlock>

	end_op();
	return;
}
8010183c:	83 c4 14             	add    $0x14,%esp
8010183f:	5b                   	pop    %ebx
80101840:	5d                   	pop    %ebp
	inodeToDel->addrs[0] = 0;

	iupdate(inodeToDel);
	iunlock(inodeToDel);

	end_op();
80101841:	e9 ba 13 00 00       	jmp    80102c00 <end_op>
80101846:	8d 76 00             	lea    0x0(%esi),%esi
80101849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101850 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	57                   	push   %edi
80101854:	56                   	push   %esi
80101855:	53                   	push   %ebx
80101856:	83 ec 1c             	sub    $0x1c,%esp
80101859:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010185c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010185f:	89 3c 24             	mov    %edi,(%esp)
80101862:	e8 99 27 00 00       	call   80104000 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101867:	8b 56 4c             	mov    0x4c(%esi),%edx
8010186a:	85 d2                	test   %edx,%edx
8010186c:	74 07                	je     80101875 <iput+0x25>
8010186e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101873:	74 2b                	je     801018a0 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101875:	89 3c 24             	mov    %edi,(%esp)
80101878:	e8 e3 27 00 00       	call   80104060 <releasesleep>

  acquire(&icache.lock);
8010187d:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101884:	e8 37 29 00 00       	call   801041c0 <acquire>
  ip->ref--;
80101889:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010188d:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101894:	83 c4 1c             	add    $0x1c,%esp
80101897:	5b                   	pop    %ebx
80101898:	5e                   	pop    %esi
80101899:	5f                   	pop    %edi
8010189a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010189b:	e9 10 2a 00 00       	jmp    801042b0 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801018a0:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018a7:	e8 14 29 00 00       	call   801041c0 <acquire>
    int r = ip->ref;
801018ac:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801018af:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018b6:	e8 f5 29 00 00       	call   801042b0 <release>
    if(r == 1){
801018bb:	83 fb 01             	cmp    $0x1,%ebx
801018be:	75 b5                	jne    80101875 <iput+0x25>
801018c0:	8d 4e 30             	lea    0x30(%esi),%ecx
801018c3:	89 f3                	mov    %esi,%ebx
801018c5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018c8:	89 cf                	mov    %ecx,%edi
801018ca:	eb 0b                	jmp    801018d7 <iput+0x87>
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018d0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018d3:	39 fb                	cmp    %edi,%ebx
801018d5:	74 19                	je     801018f0 <iput+0xa0>
    if(ip->addrs[i]){
801018d7:	8b 53 5c             	mov    0x5c(%ebx),%edx
801018da:	85 d2                	test   %edx,%edx
801018dc:	74 f2                	je     801018d0 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
801018de:	8b 06                	mov    (%esi),%eax
801018e0:	e8 2b fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
801018e5:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
801018ec:	eb e2                	jmp    801018d0 <iput+0x80>
801018ee:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
801018f0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018f9:	85 c0                	test   %eax,%eax
801018fb:	75 2b                	jne    80101928 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018fd:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101904:	89 34 24             	mov    %esi,(%esp)
80101907:	e8 14 fd ff ff       	call   80101620 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010190c:	31 c0                	xor    %eax,%eax
8010190e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101912:	89 34 24             	mov    %esi,(%esp)
80101915:	e8 06 fd ff ff       	call   80101620 <iupdate>
      ip->valid = 0;
8010191a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101921:	e9 4f ff ff ff       	jmp    80101875 <iput+0x25>
80101926:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101928:	89 44 24 04          	mov    %eax,0x4(%esp)
8010192c:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010192e:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101930:	89 04 24             	mov    %eax,(%esp)
80101933:	e8 98 e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101938:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
8010193b:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010193e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101941:	89 cf                	mov    %ecx,%edi
80101943:	31 c0                	xor    %eax,%eax
80101945:	eb 0e                	jmp    80101955 <iput+0x105>
80101947:	90                   	nop
80101948:	83 c3 01             	add    $0x1,%ebx
8010194b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101951:	89 d8                	mov    %ebx,%eax
80101953:	74 10                	je     80101965 <iput+0x115>
      if(a[j])
80101955:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101958:	85 d2                	test   %edx,%edx
8010195a:	74 ec                	je     80101948 <iput+0xf8>
        bfree(ip->dev, a[j]);
8010195c:	8b 06                	mov    (%esi),%eax
8010195e:	e8 ad fa ff ff       	call   80101410 <bfree>
80101963:	eb e3                	jmp    80101948 <iput+0xf8>
    }
    brelse(bp);
80101965:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101968:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010196b:	89 04 24             	mov    %eax,(%esp)
8010196e:	e8 6d e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101973:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101979:	8b 06                	mov    (%esi),%eax
8010197b:	e8 90 fa ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101980:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101987:	00 00 00 
8010198a:	e9 6e ff ff ff       	jmp    801018fd <iput+0xad>
8010198f:	90                   	nop

80101990 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	53                   	push   %ebx
80101994:	83 ec 14             	sub    $0x14,%esp
80101997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010199a:	89 1c 24             	mov    %ebx,(%esp)
8010199d:	e8 1e fe ff ff       	call   801017c0 <iunlock>
  iput(ip);
801019a2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801019a5:	83 c4 14             	add    $0x14,%esp
801019a8:	5b                   	pop    %ebx
801019a9:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801019aa:	e9 a1 fe ff ff       	jmp    80101850 <iput>
801019af:	90                   	nop

801019b0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	8b 55 08             	mov    0x8(%ebp),%edx
801019b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019b9:	8b 0a                	mov    (%edx),%ecx
801019bb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019be:	8b 4a 04             	mov    0x4(%edx),%ecx
801019c1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019c4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019c8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019cb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019cf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019d3:	8b 52 58             	mov    0x58(%edx),%edx
801019d6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019d9:	5d                   	pop    %ebp
801019da:	c3                   	ret    
801019db:	90                   	nop
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019e0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 2c             	sub    $0x2c,%esp
801019e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801019ec:	8b 7d 08             	mov    0x8(%ebp),%edi
801019ef:	8b 75 10             	mov    0x10(%ebp),%esi
801019f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019f5:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019f8:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a00:	0f 84 aa 00 00 00    	je     80101ab0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a06:	8b 47 58             	mov    0x58(%edi),%eax
80101a09:	39 f0                	cmp    %esi,%eax
80101a0b:	0f 82 c7 00 00 00    	jb     80101ad8 <readi+0xf8>
80101a11:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a14:	89 da                	mov    %ebx,%edx
80101a16:	01 f2                	add    %esi,%edx
80101a18:	0f 82 ba 00 00 00    	jb     80101ad8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a1e:	89 c1                	mov    %eax,%ecx
80101a20:	29 f1                	sub    %esi,%ecx
80101a22:	39 d0                	cmp    %edx,%eax
80101a24:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	31 c0                	xor    %eax,%eax
80101a29:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a2b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a2e:	74 70                	je     80101aa0 <readi+0xc0>
80101a30:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101a33:	89 c7                	mov    %eax,%edi
80101a35:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a38:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a3b:	89 f2                	mov    %esi,%edx
80101a3d:	c1 ea 09             	shr    $0x9,%edx
80101a40:	89 d8                	mov    %ebx,%eax
80101a42:	e8 99 f8 ff ff       	call   801012e0 <bmap>
80101a47:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a4b:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a4d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a52:	89 04 24             	mov    %eax,(%esp)
80101a55:	e8 76 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a5a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a5d:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a5f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a61:	89 f0                	mov    %esi,%eax
80101a63:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a68:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a6a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a6e:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a70:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a77:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a7a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a7e:	01 df                	add    %ebx,%edi
80101a80:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a82:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a85:	89 04 24             	mov    %eax,(%esp)
80101a88:	e8 13 29 00 00       	call   801043a0 <memmove>
    brelse(bp);
80101a8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a90:	89 14 24             	mov    %edx,(%esp)
80101a93:	e8 48 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a98:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a9b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a9e:	77 98                	ja     80101a38 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101aa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101aa3:	83 c4 2c             	add    $0x2c,%esp
80101aa6:	5b                   	pop    %ebx
80101aa7:	5e                   	pop    %esi
80101aa8:	5f                   	pop    %edi
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret    
80101aab:	90                   	nop
80101aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ab0:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101ab4:	66 83 f8 09          	cmp    $0x9,%ax
80101ab8:	77 1e                	ja     80101ad8 <readi+0xf8>
80101aba:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101ac1:	85 c0                	test   %eax,%eax
80101ac3:	74 13                	je     80101ad8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101ac5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101ac8:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101acb:	83 c4 2c             	add    $0x2c,%esp
80101ace:	5b                   	pop    %ebx
80101acf:	5e                   	pop    %esi
80101ad0:	5f                   	pop    %edi
80101ad1:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101ad2:	ff e0                	jmp    *%eax
80101ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101add:	eb c4                	jmp    80101aa3 <readi+0xc3>
80101adf:	90                   	nop

80101ae0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 2c             	sub    $0x2c,%esp
80101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aef:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101af7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101afa:	8b 75 10             	mov    0x10(%ebp),%esi
80101afd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b00:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b03:	0f 84 b7 00 00 00    	je     80101bc0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b0f:	0f 82 e3 00 00 00    	jb     80101bf8 <writei+0x118>
80101b15:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b18:	89 c8                	mov    %ecx,%eax
80101b1a:	01 f0                	add    %esi,%eax
80101b1c:	0f 82 d6 00 00 00    	jb     80101bf8 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b22:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b27:	0f 87 cb 00 00 00    	ja     80101bf8 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b2d:	85 c9                	test   %ecx,%ecx
80101b2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b36:	74 77                	je     80101baf <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b38:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b3b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b3d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b42:	c1 ea 09             	shr    $0x9,%edx
80101b45:	89 f8                	mov    %edi,%eax
80101b47:	e8 94 f7 ff ff       	call   801012e0 <bmap>
80101b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b50:	8b 07                	mov    (%edi),%eax
80101b52:	89 04 24             	mov    %eax,(%esp)
80101b55:	e8 76 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b5a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b5d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b60:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b63:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b65:	89 f0                	mov    %esi,%eax
80101b67:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b6c:	29 c3                	sub    %eax,%ebx
80101b6e:	39 cb                	cmp    %ecx,%ebx
80101b70:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b73:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b77:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b79:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b7d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b81:	89 04 24             	mov    %eax,(%esp)
80101b84:	e8 17 28 00 00       	call   801043a0 <memmove>
    log_write(bp);
80101b89:	89 3c 24             	mov    %edi,(%esp)
80101b8c:	e8 9f 11 00 00       	call   80102d30 <log_write>
    brelse(bp);
80101b91:	89 3c 24             	mov    %edi,(%esp)
80101b94:	e8 47 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b99:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b9f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ba2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ba5:	77 91                	ja     80101b38 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101ba7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101baa:	39 70 58             	cmp    %esi,0x58(%eax)
80101bad:	72 39                	jb     80101be8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101baf:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bb2:	83 c4 2c             	add    $0x2c,%esp
80101bb5:	5b                   	pop    %ebx
80101bb6:	5e                   	pop    %esi
80101bb7:	5f                   	pop    %edi
80101bb8:	5d                   	pop    %ebp
80101bb9:	c3                   	ret    
80101bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bc4:	66 83 f8 09          	cmp    $0x9,%ax
80101bc8:	77 2e                	ja     80101bf8 <writei+0x118>
80101bca:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101bd1:	85 c0                	test   %eax,%eax
80101bd3:	74 23                	je     80101bf8 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bd5:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101bd8:	83 c4 2c             	add    $0x2c,%esp
80101bdb:	5b                   	pop    %ebx
80101bdc:	5e                   	pop    %esi
80101bdd:	5f                   	pop    %edi
80101bde:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bdf:	ff e0                	jmp    *%eax
80101be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101be8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101beb:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bee:	89 04 24             	mov    %eax,(%esp)
80101bf1:	e8 2a fa ff ff       	call   80101620 <iupdate>
80101bf6:	eb b7                	jmp    80101baf <writei+0xcf>
  }
  return n;
}
80101bf8:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101bfb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101c00:	5b                   	pop    %ebx
80101c01:	5e                   	pop    %esi
80101c02:	5f                   	pop    %edi
80101c03:	5d                   	pop    %ebp
80101c04:	c3                   	ret    
80101c05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101c16:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c19:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c20:	00 
80101c21:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c25:	8b 45 08             	mov    0x8(%ebp),%eax
80101c28:	89 04 24             	mov    %eax,(%esp)
80101c2b:	e8 f0 27 00 00       	call   80104420 <strncmp>
}
80101c30:	c9                   	leave  
80101c31:	c3                   	ret    
80101c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	83 ec 2c             	sub    $0x2c,%esp
80101c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c51:	0f 85 97 00 00 00    	jne    80101cee <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c57:	8b 53 58             	mov    0x58(%ebx),%edx
80101c5a:	31 ff                	xor    %edi,%edi
80101c5c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c5f:	85 d2                	test   %edx,%edx
80101c61:	75 0d                	jne    80101c70 <dirlookup+0x30>
80101c63:	eb 73                	jmp    80101cd8 <dirlookup+0x98>
80101c65:	8d 76 00             	lea    0x0(%esi),%esi
80101c68:	83 c7 10             	add    $0x10,%edi
80101c6b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c6e:	76 68                	jbe    80101cd8 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c70:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c77:	00 
80101c78:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c7c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c80:	89 1c 24             	mov    %ebx,(%esp)
80101c83:	e8 58 fd ff ff       	call   801019e0 <readi>
80101c88:	83 f8 10             	cmp    $0x10,%eax
80101c8b:	75 55                	jne    80101ce2 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c8d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c92:	74 d4                	je     80101c68 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c97:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c9e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ca5:	00 
80101ca6:	89 04 24             	mov    %eax,(%esp)
80101ca9:	e8 72 27 00 00       	call   80104420 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101cae:	85 c0                	test   %eax,%eax
80101cb0:	75 b6                	jne    80101c68 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101cb2:	8b 45 10             	mov    0x10(%ebp),%eax
80101cb5:	85 c0                	test   %eax,%eax
80101cb7:	74 05                	je     80101cbe <dirlookup+0x7e>
        *poff = off;
80101cb9:	8b 45 10             	mov    0x10(%ebp),%eax
80101cbc:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cbe:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cc2:	8b 03                	mov    (%ebx),%eax
80101cc4:	e8 37 f4 ff ff       	call   80101100 <iget>
    }
  }

  return 0;
}
80101cc9:	83 c4 2c             	add    $0x2c,%esp
80101ccc:	5b                   	pop    %ebx
80101ccd:	5e                   	pop    %esi
80101cce:	5f                   	pop    %edi
80101ccf:	5d                   	pop    %ebp
80101cd0:	c3                   	ret    
80101cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cd8:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101cdb:	31 c0                	xor    %eax,%eax
}
80101cdd:	5b                   	pop    %ebx
80101cde:	5e                   	pop    %esi
80101cdf:	5f                   	pop    %edi
80101ce0:	5d                   	pop    %ebp
80101ce1:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101ce2:	c7 04 24 39 77 10 80 	movl   $0x80107739,(%esp)
80101ce9:	e8 72 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101cee:	c7 04 24 27 77 10 80 	movl   $0x80107727,(%esp)
80101cf5:	e8 66 e6 ff ff       	call   80100360 <panic>
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	89 cf                	mov    %ecx,%edi
80101d06:	56                   	push   %esi
80101d07:	53                   	push   %ebx
80101d08:	89 c3                	mov    %eax,%ebx
80101d0a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d0d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d10:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101d13:	0f 84 51 01 00 00    	je     80101e6a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d19:	e8 02 1a 00 00       	call   80103720 <myproc>
80101d1e:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101d21:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101d28:	e8 93 24 00 00       	call   801041c0 <acquire>
  ip->ref++;
80101d2d:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d31:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101d38:	e8 73 25 00 00       	call   801042b0 <release>
80101d3d:	eb 04                	jmp    80101d43 <namex+0x43>
80101d3f:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d43:	0f b6 03             	movzbl (%ebx),%eax
80101d46:	3c 2f                	cmp    $0x2f,%al
80101d48:	74 f6                	je     80101d40 <namex+0x40>
    path++;
  if(*path == 0)
80101d4a:	84 c0                	test   %al,%al
80101d4c:	0f 84 ed 00 00 00    	je     80101e3f <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d52:	0f b6 03             	movzbl (%ebx),%eax
80101d55:	89 da                	mov    %ebx,%edx
80101d57:	84 c0                	test   %al,%al
80101d59:	0f 84 b1 00 00 00    	je     80101e10 <namex+0x110>
80101d5f:	3c 2f                	cmp    $0x2f,%al
80101d61:	75 0f                	jne    80101d72 <namex+0x72>
80101d63:	e9 a8 00 00 00       	jmp    80101e10 <namex+0x110>
80101d68:	3c 2f                	cmp    $0x2f,%al
80101d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d70:	74 0a                	je     80101d7c <namex+0x7c>
    path++;
80101d72:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d75:	0f b6 02             	movzbl (%edx),%eax
80101d78:	84 c0                	test   %al,%al
80101d7a:	75 ec                	jne    80101d68 <namex+0x68>
80101d7c:	89 d1                	mov    %edx,%ecx
80101d7e:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d80:	83 f9 0d             	cmp    $0xd,%ecx
80101d83:	0f 8e 8f 00 00 00    	jle    80101e18 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d89:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d8d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d94:	00 
80101d95:	89 3c 24             	mov    %edi,(%esp)
80101d98:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d9b:	e8 00 26 00 00       	call   801043a0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101da0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101da3:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101da5:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101da8:	75 0e                	jne    80101db8 <namex+0xb8>
80101daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101db0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101db3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101db6:	74 f8                	je     80101db0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101db8:	89 34 24             	mov    %esi,(%esp)
80101dbb:	e8 20 f9 ff ff       	call   801016e0 <ilock>
    if(ip->type != T_DIR){
80101dc0:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101dc5:	0f 85 85 00 00 00    	jne    80101e50 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dce:	85 d2                	test   %edx,%edx
80101dd0:	74 09                	je     80101ddb <namex+0xdb>
80101dd2:	80 3b 00             	cmpb   $0x0,(%ebx)
80101dd5:	0f 84 a5 00 00 00    	je     80101e80 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ddb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101de2:	00 
80101de3:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101de7:	89 34 24             	mov    %esi,(%esp)
80101dea:	e8 51 fe ff ff       	call   80101c40 <dirlookup>
80101def:	85 c0                	test   %eax,%eax
80101df1:	74 5d                	je     80101e50 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101df3:	89 34 24             	mov    %esi,(%esp)
80101df6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101df9:	e8 c2 f9 ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101dfe:	89 34 24             	mov    %esi,(%esp)
80101e01:	e8 4a fa ff ff       	call   80101850 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101e06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e09:	89 c6                	mov    %eax,%esi
80101e0b:	e9 33 ff ff ff       	jmp    80101d43 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e10:	31 c9                	xor    %ecx,%ecx
80101e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101e18:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101e1c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101e20:	89 3c 24             	mov    %edi,(%esp)
80101e23:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e26:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e29:	e8 72 25 00 00       	call   801043a0 <memmove>
    name[len] = 0;
80101e2e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e31:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e34:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e38:	89 d3                	mov    %edx,%ebx
80101e3a:	e9 66 ff ff ff       	jmp    80101da5 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e42:	85 c0                	test   %eax,%eax
80101e44:	75 4c                	jne    80101e92 <namex+0x192>
80101e46:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e48:	83 c4 2c             	add    $0x2c,%esp
80101e4b:	5b                   	pop    %ebx
80101e4c:	5e                   	pop    %esi
80101e4d:	5f                   	pop    %edi
80101e4e:	5d                   	pop    %ebp
80101e4f:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e50:	89 34 24             	mov    %esi,(%esp)
80101e53:	e8 68 f9 ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101e58:	89 34 24             	mov    %esi,(%esp)
80101e5b:	e8 f0 f9 ff ff       	call   80101850 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e60:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e63:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e65:	5b                   	pop    %ebx
80101e66:	5e                   	pop    %esi
80101e67:	5f                   	pop    %edi
80101e68:	5d                   	pop    %ebp
80101e69:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e6a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e6f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e74:	e8 87 f2 ff ff       	call   80101100 <iget>
80101e79:	89 c6                	mov    %eax,%esi
80101e7b:	e9 c3 fe ff ff       	jmp    80101d43 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e80:	89 34 24             	mov    %esi,(%esp)
80101e83:	e8 38 f9 ff ff       	call   801017c0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e88:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e8b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e8d:	5b                   	pop    %ebx
80101e8e:	5e                   	pop    %esi
80101e8f:	5f                   	pop    %edi
80101e90:	5d                   	pop    %ebp
80101e91:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e92:	89 34 24             	mov    %esi,(%esp)
80101e95:	e8 b6 f9 ff ff       	call   80101850 <iput>
    return 0;
80101e9a:	31 c0                	xor    %eax,%eax
80101e9c:	eb aa                	jmp    80101e48 <namex+0x148>
80101e9e:	66 90                	xchg   %ax,%ax

80101ea0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	83 ec 2c             	sub    $0x2c,%esp
80101ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101eac:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eaf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101eb6:	00 
80101eb7:	89 1c 24             	mov    %ebx,(%esp)
80101eba:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ebe:	e8 7d fd ff ff       	call   80101c40 <dirlookup>
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 8b 00 00 00    	jne    80101f56 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ecb:	8b 43 58             	mov    0x58(%ebx),%eax
80101ece:	31 ff                	xor    %edi,%edi
80101ed0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ed3:	85 c0                	test   %eax,%eax
80101ed5:	75 13                	jne    80101eea <dirlink+0x4a>
80101ed7:	eb 35                	jmp    80101f0e <dirlink+0x6e>
80101ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee0:	8d 57 10             	lea    0x10(%edi),%edx
80101ee3:	39 53 58             	cmp    %edx,0x58(%ebx)
80101ee6:	89 d7                	mov    %edx,%edi
80101ee8:	76 24                	jbe    80101f0e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eea:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ef1:	00 
80101ef2:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ef6:	89 74 24 04          	mov    %esi,0x4(%esp)
80101efa:	89 1c 24             	mov    %ebx,(%esp)
80101efd:	e8 de fa ff ff       	call   801019e0 <readi>
80101f02:	83 f8 10             	cmp    $0x10,%eax
80101f05:	75 5e                	jne    80101f65 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101f07:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f0c:	75 d2                	jne    80101ee0 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f11:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101f18:	00 
80101f19:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f1d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f20:	89 04 24             	mov    %eax,(%esp)
80101f23:	e8 68 25 00 00       	call   80104490 <strncpy>
  de.inum = inum;
80101f28:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f2b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101f32:	00 
80101f33:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101f37:	89 74 24 04          	mov    %esi,0x4(%esp)
80101f3b:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101f3e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f42:	e8 99 fb ff ff       	call   80101ae0 <writei>
80101f47:	83 f8 10             	cmp    $0x10,%eax
80101f4a:	75 25                	jne    80101f71 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101f4c:	31 c0                	xor    %eax,%eax
}
80101f4e:	83 c4 2c             	add    $0x2c,%esp
80101f51:	5b                   	pop    %ebx
80101f52:	5e                   	pop    %esi
80101f53:	5f                   	pop    %edi
80101f54:	5d                   	pop    %ebp
80101f55:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f56:	89 04 24             	mov    %eax,(%esp)
80101f59:	e8 f2 f8 ff ff       	call   80101850 <iput>
    return -1;
80101f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f63:	eb e9                	jmp    80101f4e <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f65:	c7 04 24 48 77 10 80 	movl   $0x80107748,(%esp)
80101f6c:	e8 ef e3 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f71:	c7 04 24 56 7d 10 80 	movl   $0x80107d56,(%esp)
80101f78:	e8 e3 e3 ff ff       	call   80100360 <panic>
80101f7d:	8d 76 00             	lea    0x0(%esi),%esi

80101f80 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f80:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f81:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f83:	89 e5                	mov    %esp,%ebp
80101f85:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f88:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f8e:	e8 6d fd ff ff       	call   80101d00 <namex>
}
80101f93:	c9                   	leave  
80101f94:	c3                   	ret    
80101f95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fa0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fa0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fa1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101fa6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fab:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fae:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101faf:	e9 4c fd ff ff       	jmp    80101d00 <namex>
80101fb4:	66 90                	xchg   %ax,%ax
80101fb6:	66 90                	xchg   %ax,%ax
80101fb8:	66 90                	xchg   %ax,%ax
80101fba:	66 90                	xchg   %ax,%ax
80101fbc:	66 90                	xchg   %ax,%ax
80101fbe:	66 90                	xchg   %ax,%ax

80101fc0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	56                   	push   %esi
80101fc4:	89 c6                	mov    %eax,%esi
80101fc6:	53                   	push   %ebx
80101fc7:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101fca:	85 c0                	test   %eax,%eax
80101fcc:	0f 84 99 00 00 00    	je     8010206b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fd2:	8b 48 08             	mov    0x8(%eax),%ecx
80101fd5:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101fdb:	0f 87 7e 00 00 00    	ja     8010205f <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fe1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fe6:	66 90                	xchg   %ax,%ax
80101fe8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fe9:	83 e0 c0             	and    $0xffffffc0,%eax
80101fec:	3c 40                	cmp    $0x40,%al
80101fee:	75 f8                	jne    80101fe8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ff0:	31 db                	xor    %ebx,%ebx
80101ff2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ff7:	89 d8                	mov    %ebx,%eax
80101ff9:	ee                   	out    %al,(%dx)
80101ffa:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fff:	b8 01 00 00 00       	mov    $0x1,%eax
80102004:	ee                   	out    %al,(%dx)
80102005:	0f b6 c1             	movzbl %cl,%eax
80102008:	b2 f3                	mov    $0xf3,%dl
8010200a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
8010200b:	89 c8                	mov    %ecx,%eax
8010200d:	b2 f4                	mov    $0xf4,%dl
8010200f:	c1 f8 08             	sar    $0x8,%eax
80102012:	ee                   	out    %al,(%dx)
80102013:	b2 f5                	mov    $0xf5,%dl
80102015:	89 d8                	mov    %ebx,%eax
80102017:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102018:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010201c:	b2 f6                	mov    $0xf6,%dl
8010201e:	83 e0 01             	and    $0x1,%eax
80102021:	c1 e0 04             	shl    $0x4,%eax
80102024:	83 c8 e0             	or     $0xffffffe0,%eax
80102027:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102028:	f6 06 04             	testb  $0x4,(%esi)
8010202b:	75 13                	jne    80102040 <idestart+0x80>
8010202d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102032:	b8 20 00 00 00       	mov    $0x20,%eax
80102037:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102038:	83 c4 10             	add    $0x10,%esp
8010203b:	5b                   	pop    %ebx
8010203c:	5e                   	pop    %esi
8010203d:	5d                   	pop    %ebp
8010203e:	c3                   	ret    
8010203f:	90                   	nop
80102040:	b2 f7                	mov    $0xf7,%dl
80102042:	b8 30 00 00 00       	mov    $0x30,%eax
80102047:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102048:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010204d:	83 c6 5c             	add    $0x5c,%esi
80102050:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102055:	fc                   	cld    
80102056:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102058:	83 c4 10             	add    $0x10,%esp
8010205b:	5b                   	pop    %ebx
8010205c:	5e                   	pop    %esi
8010205d:	5d                   	pop    %ebp
8010205e:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010205f:	c7 04 24 b4 77 10 80 	movl   $0x801077b4,(%esp)
80102066:	e8 f5 e2 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010206b:	c7 04 24 ab 77 10 80 	movl   $0x801077ab,(%esp)
80102072:	e8 e9 e2 ff ff       	call   80100360 <panic>
80102077:	89 f6                	mov    %esi,%esi
80102079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102080 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102086:	c7 44 24 04 c6 77 10 	movl   $0x801077c6,0x4(%esp)
8010208d:	80 
8010208e:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102095:	e8 36 20 00 00       	call   801040d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010209a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010209f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801020a6:	83 e8 01             	sub    $0x1,%eax
801020a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801020ad:	e8 7e 02 00 00       	call   80102330 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	90                   	nop
801020b8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b9:	83 e0 c0             	and    $0xffffffc0,%eax
801020bc:	3c 40                	cmp    $0x40,%al
801020be:	75 f8                	jne    801020b8 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020c0:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020c5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801020ca:	ee                   	out    %al,(%dx)
801020cb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d0:	b2 f7                	mov    $0xf7,%dl
801020d2:	eb 09                	jmp    801020dd <ideinit+0x5d>
801020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801020d8:	83 e9 01             	sub    $0x1,%ecx
801020db:	74 0f                	je     801020ec <ideinit+0x6c>
801020dd:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020de:	84 c0                	test   %al,%al
801020e0:	74 f6                	je     801020d8 <ideinit+0x58>
      havedisk1 = 1;
801020e2:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801020e9:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ec:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020f1:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020f6:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801020f7:	c9                   	leave  
801020f8:	c3                   	ret    
801020f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102100 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102109:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102110:	e8 ab 20 00 00       	call   801041c0 <acquire>

  if((b = idequeue) == 0){
80102115:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010211b:	85 db                	test   %ebx,%ebx
8010211d:	74 30                	je     8010214f <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010211f:	8b 43 58             	mov    0x58(%ebx),%eax
80102122:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102127:	8b 33                	mov    (%ebx),%esi
80102129:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010212f:	74 37                	je     80102168 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102131:	83 e6 fb             	and    $0xfffffffb,%esi
80102134:	83 ce 02             	or     $0x2,%esi
80102137:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102139:	89 1c 24             	mov    %ebx,(%esp)
8010213c:	e8 cf 1c 00 00       	call   80103e10 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102141:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102146:	85 c0                	test   %eax,%eax
80102148:	74 05                	je     8010214f <ideintr+0x4f>
    idestart(idequeue);
8010214a:	e8 71 fe ff ff       	call   80101fc0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
8010214f:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102156:	e8 55 21 00 00       	call   801042b0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
8010215b:	83 c4 1c             	add    $0x1c,%esp
8010215e:	5b                   	pop    %ebx
8010215f:	5e                   	pop    %esi
80102160:	5f                   	pop    %edi
80102161:	5d                   	pop    %ebp
80102162:	c3                   	ret    
80102163:	90                   	nop
80102164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102168:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010216d:	8d 76 00             	lea    0x0(%esi),%esi
80102170:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102171:	89 c1                	mov    %eax,%ecx
80102173:	83 e1 c0             	and    $0xffffffc0,%ecx
80102176:	80 f9 40             	cmp    $0x40,%cl
80102179:	75 f5                	jne    80102170 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010217b:	a8 21                	test   $0x21,%al
8010217d:	75 b2                	jne    80102131 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010217f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102182:	b9 80 00 00 00       	mov    $0x80,%ecx
80102187:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218c:	fc                   	cld    
8010218d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010218f:	8b 33                	mov    (%ebx),%esi
80102191:	eb 9e                	jmp    80102131 <ideintr+0x31>
80102193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	53                   	push   %ebx
801021a4:	83 ec 14             	sub    $0x14,%esp
801021a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801021aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801021ad:	89 04 24             	mov    %eax,(%esp)
801021b0:	e8 eb 1e 00 00       	call   801040a0 <holdingsleep>
801021b5:	85 c0                	test   %eax,%eax
801021b7:	0f 84 9e 00 00 00    	je     8010225b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801021bd:	8b 03                	mov    (%ebx),%eax
801021bf:	83 e0 06             	and    $0x6,%eax
801021c2:	83 f8 02             	cmp    $0x2,%eax
801021c5:	0f 84 a8 00 00 00    	je     80102273 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021cb:	8b 53 04             	mov    0x4(%ebx),%edx
801021ce:	85 d2                	test   %edx,%edx
801021d0:	74 0d                	je     801021df <iderw+0x3f>
801021d2:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801021d7:	85 c0                	test   %eax,%eax
801021d9:	0f 84 88 00 00 00    	je     80102267 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021df:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
801021e6:	e8 d5 1f 00 00       	call   801041c0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021eb:	a1 64 b5 10 80       	mov    0x8010b564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801021f0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f7:	85 c0                	test   %eax,%eax
801021f9:	75 07                	jne    80102202 <iderw+0x62>
801021fb:	eb 4e                	jmp    8010224b <iderw+0xab>
801021fd:	8d 76 00             	lea    0x0(%esi),%esi
80102200:	89 d0                	mov    %edx,%eax
80102202:	8b 50 58             	mov    0x58(%eax),%edx
80102205:	85 d2                	test   %edx,%edx
80102207:	75 f7                	jne    80102200 <iderw+0x60>
80102209:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010220c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010220e:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80102214:	74 3c                	je     80102252 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102216:	8b 03                	mov    (%ebx),%eax
80102218:	83 e0 06             	and    $0x6,%eax
8010221b:	83 f8 02             	cmp    $0x2,%eax
8010221e:	74 1a                	je     8010223a <iderw+0x9a>
    sleep(b, &idelock);
80102220:	c7 44 24 04 80 b5 10 	movl   $0x8010b580,0x4(%esp)
80102227:	80 
80102228:	89 1c 24             	mov    %ebx,(%esp)
8010222b:	e8 50 1a 00 00       	call   80103c80 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102230:	8b 13                	mov    (%ebx),%edx
80102232:	83 e2 06             	and    $0x6,%edx
80102235:	83 fa 02             	cmp    $0x2,%edx
80102238:	75 e6                	jne    80102220 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
8010223a:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102241:	83 c4 14             	add    $0x14,%esp
80102244:	5b                   	pop    %ebx
80102245:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102246:	e9 65 20 00 00       	jmp    801042b0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010224b:	b8 64 b5 10 80       	mov    $0x8010b564,%eax
80102250:	eb ba                	jmp    8010220c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102252:	89 d8                	mov    %ebx,%eax
80102254:	e8 67 fd ff ff       	call   80101fc0 <idestart>
80102259:	eb bb                	jmp    80102216 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010225b:	c7 04 24 ca 77 10 80 	movl   $0x801077ca,(%esp)
80102262:	e8 f9 e0 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102267:	c7 04 24 f5 77 10 80 	movl   $0x801077f5,(%esp)
8010226e:	e8 ed e0 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102273:	c7 04 24 e0 77 10 80 	movl   $0x801077e0,(%esp)
8010227a:	e8 e1 e0 ff ff       	call   80100360 <panic>
8010227f:	90                   	nop

80102280 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	56                   	push   %esi
80102284:	53                   	push   %ebx
80102285:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102288:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010228f:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102292:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102299:	00 00 00 
  return ioapic->data;
8010229c:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801022a2:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801022a5:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801022ab:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022b1:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022b8:	c1 e8 10             	shr    $0x10,%eax
801022bb:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801022be:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
801022c1:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022c4:	39 c2                	cmp    %eax,%edx
801022c6:	74 12                	je     801022da <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022c8:	c7 04 24 14 78 10 80 	movl   $0x80107814,(%esp)
801022cf:	e8 7c e3 ff ff       	call   80100650 <cprintf>
801022d4:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
801022da:	ba 10 00 00 00       	mov    $0x10,%edx
801022df:	31 c0                	xor    %eax,%eax
801022e1:	eb 07                	jmp    801022ea <ioapicinit+0x6a>
801022e3:	90                   	nop
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ea:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
801022ec:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
801022f2:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022f5:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022fb:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022fe:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102301:	8d 4a 01             	lea    0x1(%edx),%ecx
80102304:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102307:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102309:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010230f:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102311:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102318:	7d ce                	jge    801022e8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010231a:	83 c4 10             	add    $0x10,%esp
8010231d:	5b                   	pop    %ebx
8010231e:	5e                   	pop    %esi
8010231f:	5d                   	pop    %ebp
80102320:	c3                   	ret    
80102321:	eb 0d                	jmp    80102330 <ioapicenable>
80102323:	90                   	nop
80102324:	90                   	nop
80102325:	90                   	nop
80102326:	90                   	nop
80102327:	90                   	nop
80102328:	90                   	nop
80102329:	90                   	nop
8010232a:	90                   	nop
8010232b:	90                   	nop
8010232c:	90                   	nop
8010232d:	90                   	nop
8010232e:	90                   	nop
8010232f:	90                   	nop

80102330 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	8b 55 08             	mov    0x8(%ebp),%edx
80102336:	53                   	push   %ebx
80102337:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010233a:	8d 5a 20             	lea    0x20(%edx),%ebx
8010233d:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102341:	8b 15 34 36 11 80    	mov    0x80113634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102347:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010234a:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010234c:	8b 15 34 36 11 80    	mov    0x80113634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102352:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102355:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102358:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010235a:	8b 15 34 36 11 80    	mov    0x80113634,%edx
80102360:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102363:	5b                   	pop    %ebx
80102364:	5d                   	pop    %ebp
80102365:	c3                   	ret    
80102366:	66 90                	xchg   %ax,%ax
80102368:	66 90                	xchg   %ax,%ax
8010236a:	66 90                	xchg   %ax,%ax
8010236c:	66 90                	xchg   %ax,%ax
8010236e:	66 90                	xchg   %ax,%ax

80102370 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	53                   	push   %ebx
80102374:	83 ec 14             	sub    $0x14,%esp
80102377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010237a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102380:	75 7c                	jne    801023fe <kfree+0x8e>
80102382:	81 fb 08 6e 11 80    	cmp    $0x80116e08,%ebx
80102388:	72 74                	jb     801023fe <kfree+0x8e>
8010238a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102390:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102395:	77 67                	ja     801023fe <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102397:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010239e:	00 
8010239f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801023a6:	00 
801023a7:	89 1c 24             	mov    %ebx,(%esp)
801023aa:	e8 51 1f 00 00       	call   80104300 <memset>

  if(kmem.use_lock)
801023af:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801023b5:	85 d2                	test   %edx,%edx
801023b7:	75 37                	jne    801023f0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023b9:	a1 78 36 11 80       	mov    0x80113678,%eax
801023be:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023c0:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801023c5:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801023cb:	85 c0                	test   %eax,%eax
801023cd:	75 09                	jne    801023d8 <kfree+0x68>
    release(&kmem.lock);
}
801023cf:	83 c4 14             	add    $0x14,%esp
801023d2:	5b                   	pop    %ebx
801023d3:	5d                   	pop    %ebp
801023d4:	c3                   	ret    
801023d5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023d8:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801023df:	83 c4 14             	add    $0x14,%esp
801023e2:	5b                   	pop    %ebx
801023e3:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023e4:	e9 c7 1e 00 00       	jmp    801042b0 <release>
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023f0:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
801023f7:	e8 c4 1d 00 00       	call   801041c0 <acquire>
801023fc:	eb bb                	jmp    801023b9 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801023fe:	c7 04 24 46 78 10 80 	movl   $0x80107846,(%esp)
80102405:	e8 56 df ff ff       	call   80100360 <panic>
8010240a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102410 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
80102415:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102418:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010241b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010241e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102424:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010242a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102430:	39 de                	cmp    %ebx,%esi
80102432:	73 08                	jae    8010243c <freerange+0x2c>
80102434:	eb 18                	jmp    8010244e <freerange+0x3e>
80102436:	66 90                	xchg   %ax,%ax
80102438:	89 da                	mov    %ebx,%edx
8010243a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010243c:	89 14 24             	mov    %edx,(%esp)
8010243f:	e8 2c ff ff ff       	call   80102370 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102444:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010244a:	39 f0                	cmp    %esi,%eax
8010244c:	76 ea                	jbe    80102438 <freerange+0x28>
    kfree(p);
}
8010244e:	83 c4 10             	add    $0x10,%esp
80102451:	5b                   	pop    %ebx
80102452:	5e                   	pop    %esi
80102453:	5d                   	pop    %ebp
80102454:	c3                   	ret    
80102455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	83 ec 10             	sub    $0x10,%esp
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010246b:	c7 44 24 04 4c 78 10 	movl   $0x8010784c,0x4(%esp)
80102472:	80 
80102473:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
8010247a:	e8 51 1c 00 00       	call   801040d0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010247f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102482:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102489:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010248c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102492:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102498:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010249e:	39 de                	cmp    %ebx,%esi
801024a0:	73 0a                	jae    801024ac <kinit1+0x4c>
801024a2:	eb 1a                	jmp    801024be <kinit1+0x5e>
801024a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024a8:	89 da                	mov    %ebx,%edx
801024aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024ac:	89 14 24             	mov    %edx,(%esp)
801024af:	e8 bc fe ff ff       	call   80102370 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024ba:	39 c6                	cmp    %eax,%esi
801024bc:	73 ea                	jae    801024a8 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801024be:	83 c4 10             	add    $0x10,%esp
801024c1:	5b                   	pop    %ebx
801024c2:	5e                   	pop    %esi
801024c3:	5d                   	pop    %ebp
801024c4:	c3                   	ret    
801024c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	56                   	push   %esi
801024d4:	53                   	push   %ebx
801024d5:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801024db:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024de:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801024e4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ea:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024f0:	39 de                	cmp    %ebx,%esi
801024f2:	73 08                	jae    801024fc <kinit2+0x2c>
801024f4:	eb 18                	jmp    8010250e <kinit2+0x3e>
801024f6:	66 90                	xchg   %ax,%ax
801024f8:	89 da                	mov    %ebx,%edx
801024fa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024fc:	89 14 24             	mov    %edx,(%esp)
801024ff:	e8 6c fe ff ff       	call   80102370 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102504:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010250a:	39 c6                	cmp    %eax,%esi
8010250c:	73 ea                	jae    801024f8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010250e:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
80102515:	00 00 00 
}
80102518:	83 c4 10             	add    $0x10,%esp
8010251b:	5b                   	pop    %ebx
8010251c:	5e                   	pop    %esi
8010251d:	5d                   	pop    %ebp
8010251e:	c3                   	ret    
8010251f:	90                   	nop

80102520 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	53                   	push   %ebx
80102524:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102527:	a1 74 36 11 80       	mov    0x80113674,%eax
8010252c:	85 c0                	test   %eax,%eax
8010252e:	75 30                	jne    80102560 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102530:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102536:	85 db                	test   %ebx,%ebx
80102538:	74 08                	je     80102542 <kalloc+0x22>
    kmem.freelist = r->next;
8010253a:	8b 13                	mov    (%ebx),%edx
8010253c:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
80102542:	85 c0                	test   %eax,%eax
80102544:	74 0c                	je     80102552 <kalloc+0x32>
    release(&kmem.lock);
80102546:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
8010254d:	e8 5e 1d 00 00       	call   801042b0 <release>
  return (char*)r;
}
80102552:	83 c4 14             	add    $0x14,%esp
80102555:	89 d8                	mov    %ebx,%eax
80102557:	5b                   	pop    %ebx
80102558:	5d                   	pop    %ebp
80102559:	c3                   	ret    
8010255a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102560:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
80102567:	e8 54 1c 00 00       	call   801041c0 <acquire>
8010256c:	a1 74 36 11 80       	mov    0x80113674,%eax
80102571:	eb bd                	jmp    80102530 <kalloc+0x10>
80102573:	66 90                	xchg   %ax,%ax
80102575:	66 90                	xchg   %ax,%ax
80102577:	66 90                	xchg   %ax,%ax
80102579:	66 90                	xchg   %ax,%ax
8010257b:	66 90                	xchg   %ax,%ax
8010257d:	66 90                	xchg   %ax,%ax
8010257f:	90                   	nop

80102580 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102580:	ba 64 00 00 00       	mov    $0x64,%edx
80102585:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102586:	a8 01                	test   $0x1,%al
80102588:	0f 84 ba 00 00 00    	je     80102648 <kbdgetc+0xc8>
8010258e:	b2 60                	mov    $0x60,%dl
80102590:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102591:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102594:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010259a:	0f 84 88 00 00 00    	je     80102628 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025a0:	84 c0                	test   %al,%al
801025a2:	79 2c                	jns    801025d0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801025a4:	8b 15 b4 b5 10 80    	mov    0x8010b5b4,%edx
801025aa:	f6 c2 40             	test   $0x40,%dl
801025ad:	75 05                	jne    801025b4 <kbdgetc+0x34>
801025af:	89 c1                	mov    %eax,%ecx
801025b1:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801025b4:	0f b6 81 80 79 10 80 	movzbl -0x7fef8680(%ecx),%eax
801025bb:	83 c8 40             	or     $0x40,%eax
801025be:	0f b6 c0             	movzbl %al,%eax
801025c1:	f7 d0                	not    %eax
801025c3:	21 d0                	and    %edx,%eax
801025c5:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
801025ca:	31 c0                	xor    %eax,%eax
801025cc:	c3                   	ret    
801025cd:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	53                   	push   %ebx
801025d4:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025da:	f6 c3 40             	test   $0x40,%bl
801025dd:	74 09                	je     801025e8 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025df:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025e2:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025e5:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025e8:	0f b6 91 80 79 10 80 	movzbl -0x7fef8680(%ecx),%edx
  shift ^= togglecode[data];
801025ef:	0f b6 81 80 78 10 80 	movzbl -0x7fef8780(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025f6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025f8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025fa:	89 d0                	mov    %edx,%eax
801025fc:	83 e0 03             	and    $0x3,%eax
801025ff:	8b 04 85 60 78 10 80 	mov    -0x7fef87a0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102606:	89 15 b4 b5 10 80    	mov    %edx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010260c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010260f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102613:	74 0b                	je     80102620 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102615:	8d 50 9f             	lea    -0x61(%eax),%edx
80102618:	83 fa 19             	cmp    $0x19,%edx
8010261b:	77 1b                	ja     80102638 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010261d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102620:	5b                   	pop    %ebx
80102621:	5d                   	pop    %ebp
80102622:	c3                   	ret    
80102623:	90                   	nop
80102624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102628:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
    return 0;
8010262f:	31 c0                	xor    %eax,%eax
80102631:	c3                   	ret    
80102632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102638:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010263b:	8d 50 20             	lea    0x20(%eax),%edx
8010263e:	83 f9 19             	cmp    $0x19,%ecx
80102641:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
80102644:	eb da                	jmp    80102620 <kbdgetc+0xa0>
80102646:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102648:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010264d:	c3                   	ret    
8010264e:	66 90                	xchg   %ax,%ax

80102650 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102656:	c7 04 24 80 25 10 80 	movl   $0x80102580,(%esp)
8010265d:	e8 4e e1 ff ff       	call   801007b0 <consoleintr>
}
80102662:	c9                   	leave  
80102663:	c3                   	ret    
80102664:	66 90                	xchg   %ax,%ax
80102666:	66 90                	xchg   %ax,%ax
80102668:	66 90                	xchg   %ax,%ax
8010266a:	66 90                	xchg   %ax,%ax
8010266c:	66 90                	xchg   %ax,%ax
8010266e:	66 90                	xchg   %ax,%ax

80102670 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102670:	55                   	push   %ebp
80102671:	89 c1                	mov    %eax,%ecx
80102673:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102675:	ba 70 00 00 00       	mov    $0x70,%edx
8010267a:	53                   	push   %ebx
8010267b:	31 c0                	xor    %eax,%eax
8010267d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010267e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102683:	89 da                	mov    %ebx,%edx
80102685:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102686:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102689:	b2 70                	mov    $0x70,%dl
8010268b:	89 01                	mov    %eax,(%ecx)
8010268d:	b8 02 00 00 00       	mov    $0x2,%eax
80102692:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102693:	89 da                	mov    %ebx,%edx
80102695:	ec                   	in     (%dx),%al
80102696:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102699:	b2 70                	mov    $0x70,%dl
8010269b:	89 41 04             	mov    %eax,0x4(%ecx)
8010269e:	b8 04 00 00 00       	mov    $0x4,%eax
801026a3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a4:	89 da                	mov    %ebx,%edx
801026a6:	ec                   	in     (%dx),%al
801026a7:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026aa:	b2 70                	mov    $0x70,%dl
801026ac:	89 41 08             	mov    %eax,0x8(%ecx)
801026af:	b8 07 00 00 00       	mov    $0x7,%eax
801026b4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b5:	89 da                	mov    %ebx,%edx
801026b7:	ec                   	in     (%dx),%al
801026b8:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026bb:	b2 70                	mov    $0x70,%dl
801026bd:	89 41 0c             	mov    %eax,0xc(%ecx)
801026c0:	b8 08 00 00 00       	mov    $0x8,%eax
801026c5:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c6:	89 da                	mov    %ebx,%edx
801026c8:	ec                   	in     (%dx),%al
801026c9:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026cc:	b2 70                	mov    $0x70,%dl
801026ce:	89 41 10             	mov    %eax,0x10(%ecx)
801026d1:	b8 09 00 00 00       	mov    $0x9,%eax
801026d6:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026d7:	89 da                	mov    %ebx,%edx
801026d9:	ec                   	in     (%dx),%al
801026da:	0f b6 d8             	movzbl %al,%ebx
801026dd:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
801026e0:	5b                   	pop    %ebx
801026e1:	5d                   	pop    %ebp
801026e2:	c3                   	ret    
801026e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026f0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801026f5:	55                   	push   %ebp
801026f6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026f8:	85 c0                	test   %eax,%eax
801026fa:	0f 84 c0 00 00 00    	je     801027c0 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102700:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102707:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102721:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102727:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010272e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102731:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102734:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010273b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010273e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102741:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102748:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010274b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010274e:	8b 50 30             	mov    0x30(%eax),%edx
80102751:	c1 ea 10             	shr    $0x10,%edx
80102754:	80 fa 03             	cmp    $0x3,%dl
80102757:	77 6f                	ja     801027c8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102759:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102760:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102763:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102766:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010276d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102770:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102773:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010277a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010277d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102780:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102787:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010278a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102794:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102797:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010279a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027a4:	8b 50 20             	mov    0x20(%eax),%edx
801027a7:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027a8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027ae:	80 e6 10             	and    $0x10,%dh
801027b1:	75 f5                	jne    801027a8 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bd:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027c0:	5d                   	pop    %ebp
801027c1:	c3                   	ret    
801027c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027cf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027d2:	8b 50 20             	mov    0x20(%eax),%edx
801027d5:	eb 82                	jmp    80102759 <lapicinit+0x69>
801027d7:	89 f6                	mov    %esi,%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027e0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801027e0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801027e5:	55                   	push   %ebp
801027e6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027e8:	85 c0                	test   %eax,%eax
801027ea:	74 0c                	je     801027f8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801027ec:	8b 40 20             	mov    0x20(%eax),%eax
}
801027ef:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801027f0:	c1 e8 18             	shr    $0x18,%eax
}
801027f3:	c3                   	ret    
801027f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801027f8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801027fa:	5d                   	pop    %ebp
801027fb:	c3                   	ret    
801027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102800 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102800:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102805:	55                   	push   %ebp
80102806:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102808:	85 c0                	test   %eax,%eax
8010280a:	74 0d                	je     80102819 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102813:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102816:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102819:	5d                   	pop    %ebp
8010281a:	c3                   	ret    
8010281b:	90                   	nop
8010281c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102820 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
}
80102823:	5d                   	pop    %ebp
80102824:	c3                   	ret    
80102825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102830 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102830:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102831:	ba 70 00 00 00       	mov    $0x70,%edx
80102836:	89 e5                	mov    %esp,%ebp
80102838:	b8 0f 00 00 00       	mov    $0xf,%eax
8010283d:	53                   	push   %ebx
8010283e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102841:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102844:	ee                   	out    %al,(%dx)
80102845:	b8 0a 00 00 00       	mov    $0xa,%eax
8010284a:	b2 71                	mov    $0x71,%dl
8010284c:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010284d:	31 c0                	xor    %eax,%eax
8010284f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102855:	89 d8                	mov    %ebx,%eax
80102857:	c1 e8 04             	shr    $0x4,%eax
8010285a:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102860:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102865:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102868:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010286b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102871:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102874:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010287b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102881:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102888:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288b:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010288e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102894:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102897:	89 da                	mov    %ebx,%edx
80102899:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010289c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a2:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028a5:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028ab:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ae:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801028b7:	5b                   	pop    %ebx
801028b8:	5d                   	pop    %ebp
801028b9:	c3                   	ret    
801028ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028c0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028c0:	55                   	push   %ebp
801028c1:	ba 70 00 00 00       	mov    $0x70,%edx
801028c6:	89 e5                	mov    %esp,%ebp
801028c8:	b8 0b 00 00 00       	mov    $0xb,%eax
801028cd:	57                   	push   %edi
801028ce:	56                   	push   %esi
801028cf:	53                   	push   %ebx
801028d0:	83 ec 4c             	sub    $0x4c,%esp
801028d3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d4:	b2 71                	mov    $0x71,%dl
801028d6:	ec                   	in     (%dx),%al
801028d7:	88 45 b7             	mov    %al,-0x49(%ebp)
801028da:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801028dd:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801028e1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801028e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801028ed:	89 d8                	mov    %ebx,%eax
801028ef:	e8 7c fd ff ff       	call   80102670 <fill_rtcdate>
801028f4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028f9:	89 f2                	mov    %esi,%edx
801028fb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fc:	ba 71 00 00 00       	mov    $0x71,%edx
80102901:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102902:	84 c0                	test   %al,%al
80102904:	78 e7                	js     801028ed <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102906:	89 f8                	mov    %edi,%eax
80102908:	e8 63 fd ff ff       	call   80102670 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010290d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102914:	00 
80102915:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102919:	89 1c 24             	mov    %ebx,(%esp)
8010291c:	e8 2f 1a 00 00       	call   80104350 <memcmp>
80102921:	85 c0                	test   %eax,%eax
80102923:	75 c3                	jne    801028e8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102925:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102929:	75 78                	jne    801029a3 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010292b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010292e:	89 c2                	mov    %eax,%edx
80102930:	83 e0 0f             	and    $0xf,%eax
80102933:	c1 ea 04             	shr    $0x4,%edx
80102936:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102939:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010293c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010293f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102942:	89 c2                	mov    %eax,%edx
80102944:	83 e0 0f             	and    $0xf,%eax
80102947:	c1 ea 04             	shr    $0x4,%edx
8010294a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010294d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102950:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102953:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102956:	89 c2                	mov    %eax,%edx
80102958:	83 e0 0f             	and    $0xf,%eax
8010295b:	c1 ea 04             	shr    $0x4,%edx
8010295e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102961:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102964:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102967:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010296a:	89 c2                	mov    %eax,%edx
8010296c:	83 e0 0f             	and    $0xf,%eax
8010296f:	c1 ea 04             	shr    $0x4,%edx
80102972:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102975:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102978:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010297b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010297e:	89 c2                	mov    %eax,%edx
80102980:	83 e0 0f             	and    $0xf,%eax
80102983:	c1 ea 04             	shr    $0x4,%edx
80102986:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102989:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010298c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010298f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102992:	89 c2                	mov    %eax,%edx
80102994:	83 e0 0f             	and    $0xf,%eax
80102997:	c1 ea 04             	shr    $0x4,%edx
8010299a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299d:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801029a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029a9:	89 01                	mov    %eax,(%ecx)
801029ab:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029ae:	89 41 04             	mov    %eax,0x4(%ecx)
801029b1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029b4:	89 41 08             	mov    %eax,0x8(%ecx)
801029b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ba:	89 41 0c             	mov    %eax,0xc(%ecx)
801029bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029c0:	89 41 10             	mov    %eax,0x10(%ecx)
801029c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c6:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
801029c9:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801029d0:	83 c4 4c             	add    $0x4c,%esp
801029d3:	5b                   	pop    %ebx
801029d4:	5e                   	pop    %esi
801029d5:	5f                   	pop    %edi
801029d6:	5d                   	pop    %ebp
801029d7:	c3                   	ret    
801029d8:	66 90                	xchg   %ax,%ax
801029da:	66 90                	xchg   %ax,%ax
801029dc:	66 90                	xchg   %ax,%ax
801029de:	66 90                	xchg   %ax,%ax

801029e0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029e0:	55                   	push   %ebp
801029e1:	89 e5                	mov    %esp,%ebp
801029e3:	57                   	push   %edi
801029e4:	56                   	push   %esi
801029e5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029e6:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029e8:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029eb:	a1 c8 36 11 80       	mov    0x801136c8,%eax
801029f0:	85 c0                	test   %eax,%eax
801029f2:	7e 78                	jle    80102a6c <install_trans+0x8c>
801029f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029f8:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801029fd:	01 d8                	add    %ebx,%eax
801029ff:	83 c0 01             	add    $0x1,%eax
80102a02:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a06:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102a0b:	89 04 24             	mov    %eax,(%esp)
80102a0e:	e8 bd d6 ff ff       	call   801000d0 <bread>
80102a13:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a15:	8b 04 9d cc 36 11 80 	mov    -0x7feec934(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a1c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a23:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102a28:	89 04 24             	mov    %eax,(%esp)
80102a2b:	e8 a0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a30:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a37:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a38:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a3a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a41:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a44:	89 04 24             	mov    %eax,(%esp)
80102a47:	e8 54 19 00 00       	call   801043a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a4c:	89 34 24             	mov    %esi,(%esp)
80102a4f:	e8 4c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a54:	89 3c 24             	mov    %edi,(%esp)
80102a57:	e8 84 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a5c:	89 34 24             	mov    %esi,(%esp)
80102a5f:	e8 7c d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a64:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102a6a:	7f 8c                	jg     801029f8 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a6c:	83 c4 1c             	add    $0x1c,%esp
80102a6f:	5b                   	pop    %ebx
80102a70:	5e                   	pop    %esi
80102a71:	5f                   	pop    %edi
80102a72:	5d                   	pop    %ebp
80102a73:	c3                   	ret    
80102a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	57                   	push   %edi
80102a84:	56                   	push   %esi
80102a85:	53                   	push   %ebx
80102a86:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a89:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a92:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102a97:	89 04 24             	mov    %eax,(%esp)
80102a9a:	e8 31 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a9f:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aa5:	31 d2                	xor    %edx,%edx
80102aa7:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aa9:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102aab:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102aae:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ab1:	7e 17                	jle    80102aca <write_head+0x4a>
80102ab3:	90                   	nop
80102ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ab8:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102abf:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ac3:	83 c2 01             	add    $0x1,%edx
80102ac6:	39 da                	cmp    %ebx,%edx
80102ac8:	75 ee                	jne    80102ab8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102aca:	89 3c 24             	mov    %edi,(%esp)
80102acd:	e8 ce d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ad2:	89 3c 24             	mov    %edi,(%esp)
80102ad5:	e8 06 d7 ff ff       	call   801001e0 <brelse>
}
80102ada:	83 c4 1c             	add    $0x1c,%esp
80102add:	5b                   	pop    %ebx
80102ade:	5e                   	pop    %esi
80102adf:	5f                   	pop    %edi
80102ae0:	5d                   	pop    %ebp
80102ae1:	c3                   	ret    
80102ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102af0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
80102af3:	56                   	push   %esi
80102af4:	53                   	push   %ebx
80102af5:	83 ec 30             	sub    $0x30,%esp
80102af8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102afb:	c7 44 24 04 80 7a 10 	movl   $0x80107a80,0x4(%esp)
80102b02:	80 
80102b03:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102b0a:	e8 c1 15 00 00       	call   801040d0 <initlock>
  readsb(dev, &sb);
80102b0f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b12:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b16:	89 1c 24             	mov    %ebx,(%esp)
80102b19:	e8 a2 e8 ff ff       	call   801013c0 <readsb>
  log.start = sb.logstart;
80102b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b21:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b24:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b27:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b2d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b31:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b37:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b3c:	e8 8f d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b41:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b43:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b46:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b49:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b4b:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102b51:	7e 17                	jle    80102b6a <initlog+0x7a>
80102b53:	90                   	nop
80102b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b58:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b5c:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b63:	83 c2 01             	add    $0x1,%edx
80102b66:	39 da                	cmp    %ebx,%edx
80102b68:	75 ee                	jne    80102b58 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b6a:	89 04 24             	mov    %eax,(%esp)
80102b6d:	e8 6e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b72:	e8 69 fe ff ff       	call   801029e0 <install_trans>
  log.lh.n = 0;
80102b77:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102b7e:	00 00 00 
  write_head(); // clear the log
80102b81:	e8 fa fe ff ff       	call   80102a80 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b86:	83 c4 30             	add    $0x30,%esp
80102b89:	5b                   	pop    %ebx
80102b8a:	5e                   	pop    %esi
80102b8b:	5d                   	pop    %ebp
80102b8c:	c3                   	ret    
80102b8d:	8d 76 00             	lea    0x0(%esi),%esi

80102b90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b96:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102b9d:	e8 1e 16 00 00       	call   801041c0 <acquire>
80102ba2:	eb 18                	jmp    80102bbc <begin_op+0x2c>
80102ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ba8:	c7 44 24 04 80 36 11 	movl   $0x80113680,0x4(%esp)
80102baf:	80 
80102bb0:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102bb7:	e8 c4 10 00 00       	call   80103c80 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bbc:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102bc1:	85 c0                	test   %eax,%eax
80102bc3:	75 e3                	jne    80102ba8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bc5:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102bca:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102bd0:	83 c0 01             	add    $0x1,%eax
80102bd3:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bd6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bd9:	83 fa 1e             	cmp    $0x1e,%edx
80102bdc:	7f ca                	jg     80102ba8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bde:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102be5:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102bea:	e8 c1 16 00 00       	call   801042b0 <release>
      break;
    }
  }
}
80102bef:	c9                   	leave  
80102bf0:	c3                   	ret    
80102bf1:	eb 0d                	jmp    80102c00 <end_op>
80102bf3:	90                   	nop
80102bf4:	90                   	nop
80102bf5:	90                   	nop
80102bf6:	90                   	nop
80102bf7:	90                   	nop
80102bf8:	90                   	nop
80102bf9:	90                   	nop
80102bfa:	90                   	nop
80102bfb:	90                   	nop
80102bfc:	90                   	nop
80102bfd:	90                   	nop
80102bfe:	90                   	nop
80102bff:	90                   	nop

80102c00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	57                   	push   %edi
80102c04:	56                   	push   %esi
80102c05:	53                   	push   %ebx
80102c06:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c09:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102c10:	e8 ab 15 00 00       	call   801041c0 <acquire>
  log.outstanding -= 1;
80102c15:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102c1a:	8b 15 c0 36 11 80    	mov    0x801136c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c20:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c23:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c25:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102c2a:	0f 85 f3 00 00 00    	jne    80102d23 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c30:	85 c0                	test   %eax,%eax
80102c32:	0f 85 cb 00 00 00    	jne    80102d03 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c38:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c3f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c41:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102c48:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4b:	e8 60 16 00 00       	call   801042b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c50:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102c55:	85 c0                	test   %eax,%eax
80102c57:	0f 8e 90 00 00 00    	jle    80102ced <end_op+0xed>
80102c5d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c60:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102c65:	01 d8                	add    %ebx,%eax
80102c67:	83 c0 01             	add    $0x1,%eax
80102c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c6e:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102c73:	89 04 24             	mov    %eax,(%esp)
80102c76:	e8 55 d4 ff ff       	call   801000d0 <bread>
80102c7b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c7d:	8b 04 9d cc 36 11 80 	mov    -0x7feec934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c84:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c87:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c8b:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102c90:	89 04 24             	mov    %eax,(%esp)
80102c93:	e8 38 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c98:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c9f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ca0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca2:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ca9:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cac:	89 04 24             	mov    %eax,(%esp)
80102caf:	e8 ec 16 00 00       	call   801043a0 <memmove>
    bwrite(to);  // write the log
80102cb4:	89 34 24             	mov    %esi,(%esp)
80102cb7:	e8 e4 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cbc:	89 3c 24             	mov    %edi,(%esp)
80102cbf:	e8 1c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cc4:	89 34 24             	mov    %esi,(%esp)
80102cc7:	e8 14 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ccc:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102cd2:	7c 8c                	jl     80102c60 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cd4:	e8 a7 fd ff ff       	call   80102a80 <write_head>
    install_trans(); // Now install writes to home locations
80102cd9:	e8 02 fd ff ff       	call   801029e0 <install_trans>
    log.lh.n = 0;
80102cde:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ce5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ce8:	e8 93 fd ff ff       	call   80102a80 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102ced:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102cf4:	e8 c7 14 00 00       	call   801041c0 <acquire>
    log.committing = 0;
80102cf9:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102d00:	00 00 00 
    wakeup(&log);
80102d03:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d0a:	e8 01 11 00 00       	call   80103e10 <wakeup>
    release(&log.lock);
80102d0f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d16:	e8 95 15 00 00       	call   801042b0 <release>
  }
}
80102d1b:	83 c4 1c             	add    $0x1c,%esp
80102d1e:	5b                   	pop    %ebx
80102d1f:	5e                   	pop    %esi
80102d20:	5f                   	pop    %edi
80102d21:	5d                   	pop    %ebp
80102d22:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d23:	c7 04 24 84 7a 10 80 	movl   $0x80107a84,(%esp)
80102d2a:	e8 31 d6 ff ff       	call   80100360 <panic>
80102d2f:	90                   	nop

80102d30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d37:	a1 c8 36 11 80       	mov    0x801136c8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d3f:	83 f8 1d             	cmp    $0x1d,%eax
80102d42:	0f 8f 98 00 00 00    	jg     80102de0 <log_write+0xb0>
80102d48:	8b 0d b8 36 11 80    	mov    0x801136b8,%ecx
80102d4e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d51:	39 d0                	cmp    %edx,%eax
80102d53:	0f 8d 87 00 00 00    	jge    80102de0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d59:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d5e:	85 c0                	test   %eax,%eax
80102d60:	0f 8e 86 00 00 00    	jle    80102dec <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d66:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d6d:	e8 4e 14 00 00       	call   801041c0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d72:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d78:	83 fa 00             	cmp    $0x0,%edx
80102d7b:	7e 54                	jle    80102dd1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d7d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d80:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d82:	39 0d cc 36 11 80    	cmp    %ecx,0x801136cc
80102d88:	75 0f                	jne    80102d99 <log_write+0x69>
80102d8a:	eb 3c                	jmp    80102dc8 <log_write+0x98>
80102d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d90:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102d97:	74 2f                	je     80102dc8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d99:	83 c0 01             	add    $0x1,%eax
80102d9c:	39 d0                	cmp    %edx,%eax
80102d9e:	75 f0                	jne    80102d90 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102da0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102da7:	83 c2 01             	add    $0x1,%edx
80102daa:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102db0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102db3:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102dba:	83 c4 14             	add    $0x14,%esp
80102dbd:	5b                   	pop    %ebx
80102dbe:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dbf:	e9 ec 14 00 00       	jmp    801042b0 <release>
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dc8:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
80102dcf:	eb df                	jmp    80102db0 <log_write+0x80>
80102dd1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dd4:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102dd9:	75 d5                	jne    80102db0 <log_write+0x80>
80102ddb:	eb ca                	jmp    80102da7 <log_write+0x77>
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102de0:	c7 04 24 93 7a 10 80 	movl   $0x80107a93,(%esp)
80102de7:	e8 74 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102dec:	c7 04 24 a9 7a 10 80 	movl   $0x80107aa9,(%esp)
80102df3:	e8 68 d5 ff ff       	call   80100360 <panic>
80102df8:	66 90                	xchg   %ax,%ax
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
80102e04:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e07:	e8 f4 08 00 00       	call   80103700 <cpuid>
80102e0c:	89 c3                	mov    %eax,%ebx
80102e0e:	e8 ed 08 00 00       	call   80103700 <cpuid>
80102e13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102e17:	c7 04 24 c4 7a 10 80 	movl   $0x80107ac4,(%esp)
80102e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e22:	e8 29 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e27:	e8 44 30 00 00       	call   80105e70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e2c:	e8 4f 08 00 00       	call   80103680 <mycpu>
80102e31:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e33:	b8 01 00 00 00       	mov    $0x1,%eax
80102e38:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e3f:	e8 9c 0b 00 00       	call   801039e0 <scheduler>
80102e44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e50 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e56:	e8 d5 40 00 00       	call   80106f30 <switchkvm>
  seginit();
80102e5b:	e8 10 40 00 00       	call   80106e70 <seginit>
  lapicinit();
80102e60:	e8 8b f8 ff ff       	call   801026f0 <lapicinit>
  mpmain();
80102e65:	e8 96 ff ff ff       	call   80102e00 <mpmain>
80102e6a:	66 90                	xchg   %ax,%ax
80102e6c:	66 90                	xchg   %ax,%ax
80102e6e:	66 90                	xchg   %ax,%ax

80102e70 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e74:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e79:	83 e4 f0             	and    $0xfffffff0,%esp
80102e7c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e7f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e86:	80 
80102e87:	c7 04 24 08 6e 11 80 	movl   $0x80116e08,(%esp)
80102e8e:	e8 cd f5 ff ff       	call   80102460 <kinit1>
  kvmalloc();      // kernel page table
80102e93:	e8 28 45 00 00       	call   801073c0 <kvmalloc>
  mpinit();        // detect other processors
80102e98:	e8 73 01 00 00       	call   80103010 <mpinit>
80102e9d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102ea0:	e8 4b f8 ff ff       	call   801026f0 <lapicinit>
  seginit();       // segment descriptors
80102ea5:	e8 c6 3f 00 00       	call   80106e70 <seginit>
  picinit();       // disable pic
80102eaa:	e8 21 03 00 00       	call   801031d0 <picinit>
80102eaf:	90                   	nop
  ioapicinit();    // another interrupt controller
80102eb0:	e8 cb f3 ff ff       	call   80102280 <ioapicinit>
  consoleinit();   // console hardware
80102eb5:	e8 96 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102eba:	e8 d1 32 00 00       	call   80106190 <uartinit>
80102ebf:	90                   	nop
  pinit();         // process table
80102ec0:	e8 9b 07 00 00       	call   80103660 <pinit>
  tvinit();        // trap vectors
80102ec5:	e8 06 2f 00 00       	call   80105dd0 <tvinit>
  binit();         // buffer cache
80102eca:	e8 71 d1 ff ff       	call   80100040 <binit>
80102ecf:	90                   	nop
  fileinit();      // file table
80102ed0:	e8 7b de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102ed5:	e8 a6 f1 ff ff       	call   80102080 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102eda:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102ee1:	00 
80102ee2:	c7 44 24 04 8c b4 10 	movl   $0x8010b48c,0x4(%esp)
80102ee9:	80 
80102eea:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102ef1:	e8 aa 14 00 00       	call   801043a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ef6:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102efd:	00 00 00 
80102f00:	05 80 37 11 80       	add    $0x80113780,%eax
80102f05:	39 d8                	cmp    %ebx,%eax
80102f07:	76 6a                	jbe    80102f73 <main+0x103>
80102f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f10:	e8 6b 07 00 00       	call   80103680 <mycpu>
80102f15:	39 d8                	cmp    %ebx,%eax
80102f17:	74 41                	je     80102f5a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f19:	e8 02 f6 ff ff       	call   80102520 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f1e:	c7 05 f8 6f 00 80 50 	movl   $0x80102e50,0x80006ff8
80102f25:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f28:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f2f:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f32:	05 00 10 00 00       	add    $0x1000,%eax
80102f37:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f3c:	0f b6 03             	movzbl (%ebx),%eax
80102f3f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f46:	00 
80102f47:	89 04 24             	mov    %eax,(%esp)
80102f4a:	e8 e1 f8 ff ff       	call   80102830 <lapicstartap>
80102f4f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f50:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f56:	85 c0                	test   %eax,%eax
80102f58:	74 f6                	je     80102f50 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f5a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102f61:	00 00 00 
80102f64:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f6a:	05 80 37 11 80       	add    $0x80113780,%eax
80102f6f:	39 c3                	cmp    %eax,%ebx
80102f71:	72 9d                	jb     80102f10 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f73:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f7a:	8e 
80102f7b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f82:	e8 49 f5 ff ff       	call   801024d0 <kinit2>
  userinit();      // first user process
80102f87:	e8 c4 07 00 00       	call   80103750 <userinit>
  mpmain();        // finish this processor's setup
80102f8c:	e8 6f fe ff ff       	call   80102e00 <mpmain>
80102f91:	66 90                	xchg   %ax,%ax
80102f93:	66 90                	xchg   %ax,%ax
80102f95:	66 90                	xchg   %ax,%ax
80102f97:	66 90                	xchg   %ax,%ax
80102f99:	66 90                	xchg   %ax,%ax
80102f9b:	66 90                	xchg   %ax,%ax
80102f9d:	66 90                	xchg   %ax,%ax
80102f9f:	90                   	nop

80102fa0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fa4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102faa:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102fab:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fae:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fb1:	39 de                	cmp    %ebx,%esi
80102fb3:	73 3c                	jae    80102ff1 <mpsearch1+0x51>
80102fb5:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fb8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fbf:	00 
80102fc0:	c7 44 24 04 d8 7a 10 	movl   $0x80107ad8,0x4(%esp)
80102fc7:	80 
80102fc8:	89 34 24             	mov    %esi,(%esp)
80102fcb:	e8 80 13 00 00       	call   80104350 <memcmp>
80102fd0:	85 c0                	test   %eax,%eax
80102fd2:	75 16                	jne    80102fea <mpsearch1+0x4a>
80102fd4:	31 c9                	xor    %ecx,%ecx
80102fd6:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fd8:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fdc:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102fdf:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fe1:	83 fa 10             	cmp    $0x10,%edx
80102fe4:	75 f2                	jne    80102fd8 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	84 c9                	test   %cl,%cl
80102fe8:	74 10                	je     80102ffa <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fea:	83 c6 10             	add    $0x10,%esi
80102fed:	39 f3                	cmp    %esi,%ebx
80102fef:	77 c7                	ja     80102fb8 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102ff1:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102ff4:	31 c0                	xor    %eax,%eax
}
80102ff6:	5b                   	pop    %ebx
80102ff7:	5e                   	pop    %esi
80102ff8:	5d                   	pop    %ebp
80102ff9:	c3                   	ret    
80102ffa:	83 c4 10             	add    $0x10,%esp
80102ffd:	89 f0                	mov    %esi,%eax
80102fff:	5b                   	pop    %ebx
80103000:	5e                   	pop    %esi
80103001:	5d                   	pop    %ebp
80103002:	c3                   	ret    
80103003:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103010 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	57                   	push   %edi
80103014:	56                   	push   %esi
80103015:	53                   	push   %ebx
80103016:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103019:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103020:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103027:	c1 e0 08             	shl    $0x8,%eax
8010302a:	09 d0                	or     %edx,%eax
8010302c:	c1 e0 04             	shl    $0x4,%eax
8010302f:	85 c0                	test   %eax,%eax
80103031:	75 1b                	jne    8010304e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103033:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010303a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103041:	c1 e0 08             	shl    $0x8,%eax
80103044:	09 d0                	or     %edx,%eax
80103046:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103049:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010304e:	ba 00 04 00 00       	mov    $0x400,%edx
80103053:	e8 48 ff ff ff       	call   80102fa0 <mpsearch1>
80103058:	85 c0                	test   %eax,%eax
8010305a:	89 c7                	mov    %eax,%edi
8010305c:	0f 84 22 01 00 00    	je     80103184 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103062:	8b 77 04             	mov    0x4(%edi),%esi
80103065:	85 f6                	test   %esi,%esi
80103067:	0f 84 30 01 00 00    	je     8010319d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010306d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103073:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010307a:	00 
8010307b:	c7 44 24 04 dd 7a 10 	movl   $0x80107add,0x4(%esp)
80103082:	80 
80103083:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103086:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103089:	e8 c2 12 00 00       	call   80104350 <memcmp>
8010308e:	85 c0                	test   %eax,%eax
80103090:	0f 85 07 01 00 00    	jne    8010319d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103096:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010309d:	3c 04                	cmp    $0x4,%al
8010309f:	0f 85 0b 01 00 00    	jne    801031b0 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030a5:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030ac:	85 c0                	test   %eax,%eax
801030ae:	74 21                	je     801030d1 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
801030b0:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
801030b2:	31 d2                	xor    %edx,%edx
801030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030b8:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
801030bf:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030c0:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801030c3:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030c5:	39 d0                	cmp    %edx,%eax
801030c7:	7f ef                	jg     801030b8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030c9:	84 c9                	test   %cl,%cl
801030cb:	0f 85 cc 00 00 00    	jne    8010319d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030d4:	85 c0                	test   %eax,%eax
801030d6:	0f 84 c1 00 00 00    	je     8010319d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030dc:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030e2:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
801030e7:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030ec:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801030f3:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801030f9:	03 55 e4             	add    -0x1c(%ebp),%edx
801030fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103100:	39 c2                	cmp    %eax,%edx
80103102:	76 1b                	jbe    8010311f <mpinit+0x10f>
80103104:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103107:	80 f9 04             	cmp    $0x4,%cl
8010310a:	77 74                	ja     80103180 <mpinit+0x170>
8010310c:	ff 24 8d 1c 7b 10 80 	jmp    *-0x7fef84e4(,%ecx,4)
80103113:	90                   	nop
80103114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103118:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311b:	39 c2                	cmp    %eax,%edx
8010311d:	77 e5                	ja     80103104 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010311f:	85 db                	test   %ebx,%ebx
80103121:	0f 84 93 00 00 00    	je     801031ba <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103127:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010312b:	74 12                	je     8010313f <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010312d:	ba 22 00 00 00       	mov    $0x22,%edx
80103132:	b8 70 00 00 00       	mov    $0x70,%eax
80103137:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103138:	b2 23                	mov    $0x23,%dl
8010313a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010313b:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010313e:	ee                   	out    %al,(%dx)
  }
}
8010313f:	83 c4 1c             	add    $0x1c,%esp
80103142:	5b                   	pop    %ebx
80103143:	5e                   	pop    %esi
80103144:	5f                   	pop    %edi
80103145:	5d                   	pop    %ebp
80103146:	c3                   	ret    
80103147:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103148:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
8010314e:	83 fe 07             	cmp    $0x7,%esi
80103151:	7f 17                	jg     8010316a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103153:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103157:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
8010315d:	83 05 00 3d 11 80 01 	addl   $0x1,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103164:	88 8e 80 37 11 80    	mov    %cl,-0x7feec880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010316a:	83 c0 14             	add    $0x14,%eax
      continue;
8010316d:	eb 91                	jmp    80103100 <mpinit+0xf0>
8010316f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103170:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103174:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103177:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
8010317d:	eb 81                	jmp    80103100 <mpinit+0xf0>
8010317f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103180:	31 db                	xor    %ebx,%ebx
80103182:	eb 83                	jmp    80103107 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103184:	ba 00 00 01 00       	mov    $0x10000,%edx
80103189:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010318e:	e8 0d fe ff ff       	call   80102fa0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103193:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103195:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103197:	0f 85 c5 fe ff ff    	jne    80103062 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010319d:	c7 04 24 e2 7a 10 80 	movl   $0x80107ae2,(%esp)
801031a4:	e8 b7 d1 ff ff       	call   80100360 <panic>
801031a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
801031b0:	3c 01                	cmp    $0x1,%al
801031b2:	0f 84 ed fe ff ff    	je     801030a5 <mpinit+0x95>
801031b8:	eb e3                	jmp    8010319d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031ba:	c7 04 24 fc 7a 10 80 	movl   $0x80107afc,(%esp)
801031c1:	e8 9a d1 ff ff       	call   80100360 <panic>
801031c6:	66 90                	xchg   %ax,%ax
801031c8:	66 90                	xchg   %ax,%ax
801031ca:	66 90                	xchg   %ax,%ax
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031d0:	55                   	push   %ebp
801031d1:	ba 21 00 00 00       	mov    $0x21,%edx
801031d6:	89 e5                	mov    %esp,%ebp
801031d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031dd:	ee                   	out    %al,(%dx)
801031de:	b2 a1                	mov    $0xa1,%dl
801031e0:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031e1:	5d                   	pop    %ebp
801031e2:	c3                   	ret    
801031e3:	66 90                	xchg   %ax,%ax
801031e5:	66 90                	xchg   %ax,%ax
801031e7:	66 90                	xchg   %ax,%ax
801031e9:	66 90                	xchg   %ax,%ax
801031eb:	66 90                	xchg   %ax,%ax
801031ed:	66 90                	xchg   %ax,%ax
801031ef:	90                   	nop

801031f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
801031f5:	53                   	push   %ebx
801031f6:	83 ec 1c             	sub    $0x1c,%esp
801031f9:	8b 75 08             	mov    0x8(%ebp),%esi
801031fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103205:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010320b:	e8 60 db ff ff       	call   80100d70 <filealloc>
80103210:	85 c0                	test   %eax,%eax
80103212:	89 06                	mov    %eax,(%esi)
80103214:	0f 84 a4 00 00 00    	je     801032be <pipealloc+0xce>
8010321a:	e8 51 db ff ff       	call   80100d70 <filealloc>
8010321f:	85 c0                	test   %eax,%eax
80103221:	89 03                	mov    %eax,(%ebx)
80103223:	0f 84 87 00 00 00    	je     801032b0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103229:	e8 f2 f2 ff ff       	call   80102520 <kalloc>
8010322e:	85 c0                	test   %eax,%eax
80103230:	89 c7                	mov    %eax,%edi
80103232:	74 7c                	je     801032b0 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103234:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010323b:	00 00 00 
  p->writeopen = 1;
8010323e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103245:	00 00 00 
  p->nwrite = 0;
80103248:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010324f:	00 00 00 
  p->nread = 0;
80103252:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103259:	00 00 00 
  initlock(&p->lock, "pipe");
8010325c:	89 04 24             	mov    %eax,(%esp)
8010325f:	c7 44 24 04 30 7b 10 	movl   $0x80107b30,0x4(%esp)
80103266:	80 
80103267:	e8 64 0e 00 00       	call   801040d0 <initlock>
  (*f0)->type = FD_PIPE;
8010326c:	8b 06                	mov    (%esi),%eax
8010326e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103274:	8b 06                	mov    (%esi),%eax
80103276:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010327a:	8b 06                	mov    (%esi),%eax
8010327c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103280:	8b 06                	mov    (%esi),%eax
80103282:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103285:	8b 03                	mov    (%ebx),%eax
80103287:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010328d:	8b 03                	mov    (%ebx),%eax
8010328f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103293:	8b 03                	mov    (%ebx),%eax
80103295:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103299:	8b 03                	mov    (%ebx),%eax
  return 0;
8010329b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010329d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032a0:	83 c4 1c             	add    $0x1c,%esp
801032a3:	89 d8                	mov    %ebx,%eax
801032a5:	5b                   	pop    %ebx
801032a6:	5e                   	pop    %esi
801032a7:	5f                   	pop    %edi
801032a8:	5d                   	pop    %ebp
801032a9:	c3                   	ret    
801032aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032b0:	8b 06                	mov    (%esi),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 08                	je     801032be <pipealloc+0xce>
    fileclose(*f0);
801032b6:	89 04 24             	mov    %eax,(%esp)
801032b9:	e8 72 db ff ff       	call   80100e30 <fileclose>
  if(*f1)
801032be:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
801032c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
801032c5:	85 c0                	test   %eax,%eax
801032c7:	74 d7                	je     801032a0 <pipealloc+0xb0>
    fileclose(*f1);
801032c9:	89 04 24             	mov    %eax,(%esp)
801032cc:	e8 5f db ff ff       	call   80100e30 <fileclose>
  return -1;
}
801032d1:	83 c4 1c             	add    $0x1c,%esp
801032d4:	89 d8                	mov    %ebx,%eax
801032d6:	5b                   	pop    %ebx
801032d7:	5e                   	pop    %esi
801032d8:	5f                   	pop    %edi
801032d9:	5d                   	pop    %ebp
801032da:	c3                   	ret    
801032db:	90                   	nop
801032dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	56                   	push   %esi
801032e4:	53                   	push   %ebx
801032e5:	83 ec 10             	sub    $0x10,%esp
801032e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032ee:	89 1c 24             	mov    %ebx,(%esp)
801032f1:	e8 ca 0e 00 00       	call   801041c0 <acquire>
  if(writable){
801032f6:	85 f6                	test   %esi,%esi
801032f8:	74 3e                	je     80103338 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801032fa:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103300:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103307:	00 00 00 
    wakeup(&p->nread);
8010330a:	89 04 24             	mov    %eax,(%esp)
8010330d:	e8 fe 0a 00 00       	call   80103e10 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103312:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103318:	85 d2                	test   %edx,%edx
8010331a:	75 0a                	jne    80103326 <pipeclose+0x46>
8010331c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103322:	85 c0                	test   %eax,%eax
80103324:	74 32                	je     80103358 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103326:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103329:	83 c4 10             	add    $0x10,%esp
8010332c:	5b                   	pop    %ebx
8010332d:	5e                   	pop    %esi
8010332e:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010332f:	e9 7c 0f 00 00       	jmp    801042b0 <release>
80103334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103338:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
8010333e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103345:	00 00 00 
    wakeup(&p->nwrite);
80103348:	89 04 24             	mov    %eax,(%esp)
8010334b:	e8 c0 0a 00 00       	call   80103e10 <wakeup>
80103350:	eb c0                	jmp    80103312 <pipeclose+0x32>
80103352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103358:	89 1c 24             	mov    %ebx,(%esp)
8010335b:	e8 50 0f 00 00       	call   801042b0 <release>
    kfree((char*)p);
80103360:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103363:	83 c4 10             	add    $0x10,%esp
80103366:	5b                   	pop    %ebx
80103367:	5e                   	pop    %esi
80103368:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103369:	e9 02 f0 ff ff       	jmp    80102370 <kfree>
8010336e:	66 90                	xchg   %ax,%ax

80103370 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	57                   	push   %edi
80103374:	56                   	push   %esi
80103375:	53                   	push   %ebx
80103376:	83 ec 1c             	sub    $0x1c,%esp
80103379:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010337c:	89 1c 24             	mov    %ebx,(%esp)
8010337f:	e8 3c 0e 00 00       	call   801041c0 <acquire>
  for(i = 0; i < n; i++){
80103384:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103387:	85 c9                	test   %ecx,%ecx
80103389:	0f 8e b2 00 00 00    	jle    80103441 <pipewrite+0xd1>
8010338f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103392:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103398:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010339e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033a4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033a7:	03 4d 10             	add    0x10(%ebp),%ecx
801033aa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ad:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033b3:	81 c1 00 02 00 00    	add    $0x200,%ecx
801033b9:	39 c8                	cmp    %ecx,%eax
801033bb:	74 38                	je     801033f5 <pipewrite+0x85>
801033bd:	eb 55                	jmp    80103414 <pipewrite+0xa4>
801033bf:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
801033c0:	e8 5b 03 00 00       	call   80103720 <myproc>
801033c5:	8b 40 24             	mov    0x24(%eax),%eax
801033c8:	85 c0                	test   %eax,%eax
801033ca:	75 33                	jne    801033ff <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033cc:	89 3c 24             	mov    %edi,(%esp)
801033cf:	e8 3c 0a 00 00       	call   80103e10 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801033d8:	89 34 24             	mov    %esi,(%esp)
801033db:	e8 a0 08 00 00       	call   80103c80 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033e0:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033e6:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033ec:	05 00 02 00 00       	add    $0x200,%eax
801033f1:	39 c2                	cmp    %eax,%edx
801033f3:	75 23                	jne    80103418 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
801033f5:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033fb:	85 d2                	test   %edx,%edx
801033fd:	75 c1                	jne    801033c0 <pipewrite+0x50>
        release(&p->lock);
801033ff:	89 1c 24             	mov    %ebx,(%esp)
80103402:	e8 a9 0e 00 00       	call   801042b0 <release>
        return -1;
80103407:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010340c:	83 c4 1c             	add    $0x1c,%esp
8010340f:	5b                   	pop    %ebx
80103410:	5e                   	pop    %esi
80103411:	5f                   	pop    %edi
80103412:	5d                   	pop    %ebp
80103413:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103414:	89 c2                	mov    %eax,%edx
80103416:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103418:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010341b:	8d 42 01             	lea    0x1(%edx),%eax
8010341e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103424:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010342a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010342e:	0f b6 09             	movzbl (%ecx),%ecx
80103431:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103435:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103438:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
8010343b:	0f 85 6c ff ff ff    	jne    801033ad <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103441:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103447:	89 04 24             	mov    %eax,(%esp)
8010344a:	e8 c1 09 00 00       	call   80103e10 <wakeup>
  release(&p->lock);
8010344f:	89 1c 24             	mov    %ebx,(%esp)
80103452:	e8 59 0e 00 00       	call   801042b0 <release>
  return n;
80103457:	8b 45 10             	mov    0x10(%ebp),%eax
8010345a:	eb b0                	jmp    8010340c <pipewrite+0x9c>
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103460 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 1c             	sub    $0x1c,%esp
80103469:	8b 75 08             	mov    0x8(%ebp),%esi
8010346c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010346f:	89 34 24             	mov    %esi,(%esp)
80103472:	e8 49 0d 00 00       	call   801041c0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103477:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010347d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103483:	75 5b                	jne    801034e0 <piperead+0x80>
80103485:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010348b:	85 db                	test   %ebx,%ebx
8010348d:	74 51                	je     801034e0 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010348f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103495:	eb 25                	jmp    801034bc <piperead+0x5c>
80103497:	90                   	nop
80103498:	89 74 24 04          	mov    %esi,0x4(%esp)
8010349c:	89 1c 24             	mov    %ebx,(%esp)
8010349f:	e8 dc 07 00 00       	call   80103c80 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034a4:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034aa:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034b0:	75 2e                	jne    801034e0 <piperead+0x80>
801034b2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801034b8:	85 d2                	test   %edx,%edx
801034ba:	74 24                	je     801034e0 <piperead+0x80>
    if(myproc()->killed){
801034bc:	e8 5f 02 00 00       	call   80103720 <myproc>
801034c1:	8b 48 24             	mov    0x24(%eax),%ecx
801034c4:	85 c9                	test   %ecx,%ecx
801034c6:	74 d0                	je     80103498 <piperead+0x38>
      release(&p->lock);
801034c8:	89 34 24             	mov    %esi,(%esp)
801034cb:	e8 e0 0d 00 00       	call   801042b0 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034d0:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801034d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034d8:	5b                   	pop    %ebx
801034d9:	5e                   	pop    %esi
801034da:	5f                   	pop    %edi
801034db:	5d                   	pop    %ebp
801034dc:	c3                   	ret    
801034dd:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034e0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801034e3:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034e5:	85 d2                	test   %edx,%edx
801034e7:	7f 2b                	jg     80103514 <piperead+0xb4>
801034e9:	eb 31                	jmp    8010351c <piperead+0xbc>
801034eb:	90                   	nop
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801034f0:	8d 48 01             	lea    0x1(%eax),%ecx
801034f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801034f8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801034fe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103503:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103506:	83 c3 01             	add    $0x1,%ebx
80103509:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010350c:	74 0e                	je     8010351c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010350e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103514:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010351a:	75 d4                	jne    801034f0 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010351c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103522:	89 04 24             	mov    %eax,(%esp)
80103525:	e8 e6 08 00 00       	call   80103e10 <wakeup>
  release(&p->lock);
8010352a:	89 34 24             	mov    %esi,(%esp)
8010352d:	e8 7e 0d 00 00       	call   801042b0 <release>
  return i;
}
80103532:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103535:	89 d8                	mov    %ebx,%eax
}
80103537:	5b                   	pop    %ebx
80103538:	5e                   	pop    %esi
80103539:	5f                   	pop    %edi
8010353a:	5d                   	pop    %ebp
8010353b:	c3                   	ret    
8010353c:	66 90                	xchg   %ax,%ax
8010353e:	66 90                	xchg   %ax,%ax

80103540 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103544:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103549:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010354c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103553:	e8 68 0c 00 00       	call   801041c0 <acquire>
80103558:	eb 11                	jmp    8010356b <allocproc+0x2b>
8010355a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103560:	83 c3 7c             	add    $0x7c,%ebx
80103563:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103569:	74 7d                	je     801035e8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010356b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010356e:	85 c0                	test   %eax,%eax
80103570:	75 ee                	jne    80103560 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103572:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103577:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010357e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103585:	8d 50 01             	lea    0x1(%eax),%edx
80103588:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
8010358e:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103591:	e8 1a 0d 00 00       	call   801042b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103596:	e8 85 ef ff ff       	call   80102520 <kalloc>
8010359b:	85 c0                	test   %eax,%eax
8010359d:	89 43 08             	mov    %eax,0x8(%ebx)
801035a0:	74 5a                	je     801035fc <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801035a2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801035a8:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801035ad:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801035b0:	c7 40 14 c5 5d 10 80 	movl   $0x80105dc5,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801035b7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801035be:	00 
801035bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801035c6:	00 
801035c7:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801035ca:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801035cd:	e8 2e 0d 00 00       	call   80104300 <memset>
  p->context->eip = (uint)forkret;
801035d2:	8b 43 1c             	mov    0x1c(%ebx),%eax
801035d5:	c7 40 10 10 36 10 80 	movl   $0x80103610,0x10(%eax)

  return p;
801035dc:	89 d8                	mov    %ebx,%eax
}
801035de:	83 c4 14             	add    $0x14,%esp
801035e1:	5b                   	pop    %ebx
801035e2:	5d                   	pop    %ebp
801035e3:	c3                   	ret    
801035e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801035e8:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801035ef:	e8 bc 0c 00 00       	call   801042b0 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801035f4:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
801035f7:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801035f9:	5b                   	pop    %ebx
801035fa:	5d                   	pop    %ebp
801035fb:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801035fc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103603:	eb d9                	jmp    801035de <allocproc+0x9e>
80103605:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103610 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103616:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010361d:	e8 8e 0c 00 00       	call   801042b0 <release>

  if (first) {
80103622:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103627:	85 c0                	test   %eax,%eax
80103629:	75 05                	jne    80103630 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010362b:	c9                   	leave  
8010362c:	c3                   	ret    
8010362d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103630:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103637:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010363e:	00 00 00 
    iinit(ROOTDEV);
80103641:	e8 5a de ff ff       	call   801014a0 <iinit>
    initlog(ROOTDEV);
80103646:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010364d:	e8 9e f4 ff ff       	call   80102af0 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103652:	c9                   	leave  
80103653:	c3                   	ret    
80103654:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010365a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103660 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103666:	c7 44 24 04 35 7b 10 	movl   $0x80107b35,0x4(%esp)
8010366d:	80 
8010366e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103675:	e8 56 0a 00 00       	call   801040d0 <initlock>
}
8010367a:	c9                   	leave  
8010367b:	c3                   	ret    
8010367c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103680 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	56                   	push   %esi
80103684:	53                   	push   %ebx
80103685:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103688:	9c                   	pushf  
80103689:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010368a:	f6 c4 02             	test   $0x2,%ah
8010368d:	75 57                	jne    801036e6 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010368f:	e8 4c f1 ff ff       	call   801027e0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103694:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
8010369a:	85 f6                	test   %esi,%esi
8010369c:	7e 3c                	jle    801036da <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010369e:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
801036a5:	39 c2                	cmp    %eax,%edx
801036a7:	74 2d                	je     801036d6 <mycpu+0x56>
801036a9:	b9 30 38 11 80       	mov    $0x80113830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036ae:	31 d2                	xor    %edx,%edx
801036b0:	83 c2 01             	add    $0x1,%edx
801036b3:	39 f2                	cmp    %esi,%edx
801036b5:	74 23                	je     801036da <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036b7:	0f b6 19             	movzbl (%ecx),%ebx
801036ba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801036c0:	39 c3                	cmp    %eax,%ebx
801036c2:	75 ec                	jne    801036b0 <mycpu+0x30>
      return &cpus[i];
801036c4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	5b                   	pop    %ebx
801036ce:	5e                   	pop    %esi
801036cf:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
801036d0:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
801036d5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036d6:	31 d2                	xor    %edx,%edx
801036d8:	eb ea                	jmp    801036c4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801036da:	c7 04 24 3c 7b 10 80 	movl   $0x80107b3c,(%esp)
801036e1:	e8 7a cc ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801036e6:	c7 04 24 18 7c 10 80 	movl   $0x80107c18,(%esp)
801036ed:	e8 6e cc ff ff       	call   80100360 <panic>
801036f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103700 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103706:	e8 75 ff ff ff       	call   80103680 <mycpu>
}
8010370b:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
8010370c:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103711:	c1 f8 04             	sar    $0x4,%eax
80103714:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010371a:	c3                   	ret    
8010371b:	90                   	nop
8010371c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103720 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	53                   	push   %ebx
80103724:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103727:	e8 54 0a 00 00       	call   80104180 <pushcli>
  c = mycpu();
8010372c:	e8 4f ff ff ff       	call   80103680 <mycpu>
  p = c->proc;
80103731:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103737:	e8 04 0b 00 00       	call   80104240 <popcli>
  return p;
}
8010373c:	83 c4 04             	add    $0x4,%esp
8010373f:	89 d8                	mov    %ebx,%eax
80103741:	5b                   	pop    %ebx
80103742:	5d                   	pop    %ebp
80103743:	c3                   	ret    
80103744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010374a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103750 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
80103754:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103757:	e8 e4 fd ff ff       	call   80103540 <allocproc>
8010375c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010375e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103763:	e8 c8 3b 00 00       	call   80107330 <setupkvm>
80103768:	85 c0                	test   %eax,%eax
8010376a:	89 43 04             	mov    %eax,0x4(%ebx)
8010376d:	0f 84 d4 00 00 00    	je     80103847 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103773:	89 04 24             	mov    %eax,(%esp)
80103776:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010377d:	00 
8010377e:	c7 44 24 04 60 b4 10 	movl   $0x8010b460,0x4(%esp)
80103785:	80 
80103786:	e8 d5 38 00 00       	call   80107060 <inituvm>
  p->sz = PGSIZE;
8010378b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103791:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103798:	00 
80103799:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801037a0:	00 
801037a1:	8b 43 18             	mov    0x18(%ebx),%eax
801037a4:	89 04 24             	mov    %eax,(%esp)
801037a7:	e8 54 0b 00 00       	call   80104300 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037ac:	8b 43 18             	mov    0x18(%ebx),%eax
801037af:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037b4:	b9 23 00 00 00       	mov    $0x23,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037b9:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037bd:	8b 43 18             	mov    0x18(%ebx),%eax
801037c0:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801037c4:	8b 43 18             	mov    0x18(%ebx),%eax
801037c7:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037cb:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801037cf:	8b 43 18             	mov    0x18(%ebx),%eax
801037d2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037d6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801037da:	8b 43 18             	mov    0x18(%ebx),%eax
801037dd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037e4:	8b 43 18             	mov    0x18(%ebx),%eax
801037e7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037ee:	8b 43 18             	mov    0x18(%ebx),%eax
801037f1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801037f8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801037fb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103802:	00 
80103803:	c7 44 24 04 65 7b 10 	movl   $0x80107b65,0x4(%esp)
8010380a:	80 
8010380b:	89 04 24             	mov    %eax,(%esp)
8010380e:	e8 cd 0c 00 00       	call   801044e0 <safestrcpy>
  p->cwd = namei("/");
80103813:	c7 04 24 6e 7b 10 80 	movl   $0x80107b6e,(%esp)
8010381a:	e8 61 e7 ff ff       	call   80101f80 <namei>
8010381f:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103822:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103829:	e8 92 09 00 00       	call   801041c0 <acquire>

  p->state = RUNNABLE;
8010382e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103835:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010383c:	e8 6f 0a 00 00       	call   801042b0 <release>
}
80103841:	83 c4 14             	add    $0x14,%esp
80103844:	5b                   	pop    %ebx
80103845:	5d                   	pop    %ebp
80103846:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103847:	c7 04 24 4c 7b 10 80 	movl   $0x80107b4c,(%esp)
8010384e:	e8 0d cb ff ff       	call   80100360 <panic>
80103853:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103860 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	56                   	push   %esi
80103864:	53                   	push   %ebx
80103865:	83 ec 10             	sub    $0x10,%esp
80103868:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
8010386b:	e8 b0 fe ff ff       	call   80103720 <myproc>

  sz = curproc->sz;
  if(n > 0){
80103870:	83 fe 00             	cmp    $0x0,%esi
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
80103873:	89 c3                	mov    %eax,%ebx

  sz = curproc->sz;
80103875:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103877:	7e 2f                	jle    801038a8 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103879:	01 c6                	add    %eax,%esi
8010387b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010387f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103883:	8b 43 04             	mov    0x4(%ebx),%eax
80103886:	89 04 24             	mov    %eax,(%esp)
80103889:	e8 12 39 00 00       	call   801071a0 <allocuvm>
8010388e:	85 c0                	test   %eax,%eax
80103890:	74 36                	je     801038c8 <growproc+0x68>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103892:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103894:	89 1c 24             	mov    %ebx,(%esp)
80103897:	e8 b4 36 00 00       	call   80106f50 <switchuvm>
  return 0;
8010389c:	31 c0                	xor    %eax,%eax
}
8010389e:	83 c4 10             	add    $0x10,%esp
801038a1:	5b                   	pop    %ebx
801038a2:	5e                   	pop    %esi
801038a3:	5d                   	pop    %ebp
801038a4:	c3                   	ret    
801038a5:	8d 76 00             	lea    0x0(%esi),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801038a8:	74 e8                	je     80103892 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038aa:	01 c6                	add    %eax,%esi
801038ac:	89 74 24 08          	mov    %esi,0x8(%esp)
801038b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801038b4:	8b 43 04             	mov    0x4(%ebx),%eax
801038b7:	89 04 24             	mov    %eax,(%esp)
801038ba:	e8 d1 39 00 00       	call   80107290 <deallocuvm>
801038bf:	85 c0                	test   %eax,%eax
801038c1:	75 cf                	jne    80103892 <growproc+0x32>
801038c3:	90                   	nop
801038c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
801038c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038cd:	eb cf                	jmp    8010389e <growproc+0x3e>
801038cf:	90                   	nop

801038d0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	53                   	push   %ebx
801038d6:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
801038d9:	e8 42 fe ff ff       	call   80103720 <myproc>
801038de:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
801038e0:	e8 5b fc ff ff       	call   80103540 <allocproc>
801038e5:	85 c0                	test   %eax,%eax
801038e7:	89 c7                	mov    %eax,%edi
801038e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038ec:	0f 84 bc 00 00 00    	je     801039ae <fork+0xde>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038f2:	8b 03                	mov    (%ebx),%eax
801038f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801038f8:	8b 43 04             	mov    0x4(%ebx),%eax
801038fb:	89 04 24             	mov    %eax,(%esp)
801038fe:	e8 0d 3b 00 00       	call   80107410 <copyuvm>
80103903:	85 c0                	test   %eax,%eax
80103905:	89 47 04             	mov    %eax,0x4(%edi)
80103908:	0f 84 a7 00 00 00    	je     801039b5 <fork+0xe5>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010390e:	8b 03                	mov    (%ebx),%eax
80103910:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103913:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103915:	8b 79 18             	mov    0x18(%ecx),%edi
80103918:	89 c8                	mov    %ecx,%eax
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
8010391a:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010391d:	8b 73 18             	mov    0x18(%ebx),%esi
80103920:	b9 13 00 00 00       	mov    $0x13,%ecx
80103925:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103927:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103929:	8b 40 18             	mov    0x18(%eax),%eax
8010392c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103933:	90                   	nop
80103934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103938:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010393c:	85 c0                	test   %eax,%eax
8010393e:	74 0f                	je     8010394f <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103940:	89 04 24             	mov    %eax,(%esp)
80103943:	e8 98 d4 ff ff       	call   80100de0 <filedup>
80103948:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010394b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010394f:	83 c6 01             	add    $0x1,%esi
80103952:	83 fe 10             	cmp    $0x10,%esi
80103955:	75 e1                	jne    80103938 <fork+0x68>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103957:	8b 43 68             	mov    0x68(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010395a:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010395d:	89 04 24             	mov    %eax,(%esp)
80103960:	e8 4b dd ff ff       	call   801016b0 <idup>
80103965:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103968:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010396b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010396e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103972:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103979:	00 
8010397a:	89 04 24             	mov    %eax,(%esp)
8010397d:	e8 5e 0b 00 00       	call   801044e0 <safestrcpy>

  pid = np->pid;
80103982:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103985:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010398c:	e8 2f 08 00 00       	call   801041c0 <acquire>

  np->state = RUNNABLE;
80103991:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103998:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010399f:	e8 0c 09 00 00       	call   801042b0 <release>

  return pid;
801039a4:	89 d8                	mov    %ebx,%eax
}
801039a6:	83 c4 1c             	add    $0x1c,%esp
801039a9:	5b                   	pop    %ebx
801039aa:	5e                   	pop    %esi
801039ab:	5f                   	pop    %edi
801039ac:	5d                   	pop    %ebp
801039ad:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
801039ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039b3:	eb f1                	jmp    801039a6 <fork+0xd6>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
801039b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801039b8:	8b 47 08             	mov    0x8(%edi),%eax
801039bb:	89 04 24             	mov    %eax,(%esp)
801039be:	e8 ad e9 ff ff       	call   80102370 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
801039c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
801039c8:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
801039cf:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
801039d6:	eb ce                	jmp    801039a6 <fork+0xd6>
801039d8:	90                   	nop
801039d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039e0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	57                   	push   %edi
801039e4:	56                   	push   %esi
801039e5:	53                   	push   %ebx
801039e6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801039e9:	e8 92 fc ff ff       	call   80103680 <mycpu>
801039ee:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801039f0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039f7:	00 00 00 
801039fa:	8d 78 04             	lea    0x4(%eax),%edi
801039fd:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a00:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a01:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a08:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a0d:	e8 ae 07 00 00       	call   801041c0 <acquire>
80103a12:	eb 0f                	jmp    80103a23 <scheduler+0x43>
80103a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a18:	83 c3 7c             	add    $0x7c,%ebx
80103a1b:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103a21:	74 45                	je     80103a68 <scheduler+0x88>
      if(p->state != RUNNABLE)
80103a23:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a27:	75 ef                	jne    80103a18 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103a29:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a2f:	89 1c 24             	mov    %ebx,(%esp)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a32:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a35:	e8 16 35 00 00       	call   80106f50 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a3a:	8b 43 a0             	mov    -0x60(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a3d:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
80103a44:	89 3c 24             	mov    %edi,(%esp)
80103a47:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a4b:	e8 eb 0a 00 00       	call   8010453b <swtch>
      switchkvm();
80103a50:	e8 db 34 00 00       	call   80106f30 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a55:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a5b:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a62:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a65:	75 bc                	jne    80103a23 <scheduler+0x43>
80103a67:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103a68:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a6f:	e8 3c 08 00 00       	call   801042b0 <release>

  }
80103a74:	eb 8a                	jmp    80103a00 <scheduler+0x20>
80103a76:	8d 76 00             	lea    0x0(%esi),%esi
80103a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a80 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	56                   	push   %esi
80103a84:	53                   	push   %ebx
80103a85:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103a88:	e8 93 fc ff ff       	call   80103720 <myproc>

  if(!holding(&ptable.lock))
80103a8d:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103a94:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103a96:	e8 b5 06 00 00       	call   80104150 <holding>
80103a9b:	85 c0                	test   %eax,%eax
80103a9d:	74 4f                	je     80103aee <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103a9f:	e8 dc fb ff ff       	call   80103680 <mycpu>
80103aa4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103aab:	75 65                	jne    80103b12 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103aad:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ab1:	74 53                	je     80103b06 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ab3:	9c                   	pushf  
80103ab4:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103ab5:	f6 c4 02             	test   $0x2,%ah
80103ab8:	75 40                	jne    80103afa <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103aba:	e8 c1 fb ff ff       	call   80103680 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103abf:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103ac2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ac8:	e8 b3 fb ff ff       	call   80103680 <mycpu>
80103acd:	8b 40 04             	mov    0x4(%eax),%eax
80103ad0:	89 1c 24             	mov    %ebx,(%esp)
80103ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ad7:	e8 5f 0a 00 00       	call   8010453b <swtch>
  mycpu()->intena = intena;
80103adc:	e8 9f fb ff ff       	call   80103680 <mycpu>
80103ae1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ae7:	83 c4 10             	add    $0x10,%esp
80103aea:	5b                   	pop    %ebx
80103aeb:	5e                   	pop    %esi
80103aec:	5d                   	pop    %ebp
80103aed:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103aee:	c7 04 24 70 7b 10 80 	movl   $0x80107b70,(%esp)
80103af5:	e8 66 c8 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103afa:	c7 04 24 9c 7b 10 80 	movl   $0x80107b9c,(%esp)
80103b01:	e8 5a c8 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b06:	c7 04 24 8e 7b 10 80 	movl   $0x80107b8e,(%esp)
80103b0d:	e8 4e c8 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103b12:	c7 04 24 82 7b 10 80 	movl   $0x80107b82,(%esp)
80103b19:	e8 42 c8 ff ff       	call   80100360 <panic>
80103b1e:	66 90                	xchg   %ax,%ax

80103b20 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b24:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b26:	53                   	push   %ebx
80103b27:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b2a:	e8 f1 fb ff ff       	call   80103720 <myproc>
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b2f:	3b 05 b8 b5 10 80    	cmp    0x8010b5b8,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103b35:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b37:	0f 84 ea 00 00 00    	je     80103c27 <exit+0x107>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103b40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b44:	85 c0                	test   %eax,%eax
80103b46:	74 10                	je     80103b58 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b48:	89 04 24             	mov    %eax,(%esp)
80103b4b:	e8 e0 d2 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103b50:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b57:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103b58:	83 c6 01             	add    $0x1,%esi
80103b5b:	83 fe 10             	cmp    $0x10,%esi
80103b5e:	75 e0                	jne    80103b40 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103b60:	e8 2b f0 ff ff       	call   80102b90 <begin_op>
  iput(curproc->cwd);
80103b65:	8b 43 68             	mov    0x68(%ebx),%eax
80103b68:	89 04 24             	mov    %eax,(%esp)
80103b6b:	e8 e0 dc ff ff       	call   80101850 <iput>
  end_op();
80103b70:	e8 8b f0 ff ff       	call   80102c00 <end_op>
  curproc->cwd = 0;
80103b75:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103b7c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103b83:	e8 38 06 00 00       	call   801041c0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103b88:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b8b:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103b90:	eb 11                	jmp    80103ba3 <exit+0x83>
80103b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b98:	83 c2 7c             	add    $0x7c,%edx
80103b9b:	81 fa 54 5c 11 80    	cmp    $0x80115c54,%edx
80103ba1:	74 1d                	je     80103bc0 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103ba3:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103ba7:	75 ef                	jne    80103b98 <exit+0x78>
80103ba9:	3b 42 20             	cmp    0x20(%edx),%eax
80103bac:	75 ea                	jne    80103b98 <exit+0x78>
      p->state = RUNNABLE;
80103bae:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bb5:	83 c2 7c             	add    $0x7c,%edx
80103bb8:	81 fa 54 5c 11 80    	cmp    $0x80115c54,%edx
80103bbe:	75 e3                	jne    80103ba3 <exit+0x83>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103bc0:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103bc5:	b9 54 3d 11 80       	mov    $0x80113d54,%ecx
80103bca:	eb 0f                	jmp    80103bdb <exit+0xbb>
80103bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bd0:	83 c1 7c             	add    $0x7c,%ecx
80103bd3:	81 f9 54 5c 11 80    	cmp    $0x80115c54,%ecx
80103bd9:	74 34                	je     80103c0f <exit+0xef>
    if(p->parent == curproc){
80103bdb:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103bde:	75 f0                	jne    80103bd0 <exit+0xb0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103be0:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103be4:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103be7:	75 e7                	jne    80103bd0 <exit+0xb0>
80103be9:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103bee:	eb 0b                	jmp    80103bfb <exit+0xdb>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bf0:	83 c2 7c             	add    $0x7c,%edx
80103bf3:	81 fa 54 5c 11 80    	cmp    $0x80115c54,%edx
80103bf9:	74 d5                	je     80103bd0 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103bfb:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103bff:	75 ef                	jne    80103bf0 <exit+0xd0>
80103c01:	3b 42 20             	cmp    0x20(%edx),%eax
80103c04:	75 ea                	jne    80103bf0 <exit+0xd0>
      p->state = RUNNABLE;
80103c06:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103c0d:	eb e1                	jmp    80103bf0 <exit+0xd0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c0f:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103c16:	e8 65 fe ff ff       	call   80103a80 <sched>
  panic("zombie exit");
80103c1b:	c7 04 24 bd 7b 10 80 	movl   $0x80107bbd,(%esp)
80103c22:	e8 39 c7 ff ff       	call   80100360 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103c27:	c7 04 24 b0 7b 10 80 	movl   $0x80107bb0,(%esp)
80103c2e:	e8 2d c7 ff ff       	call   80100360 <panic>
80103c33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c40 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c46:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c4d:	e8 6e 05 00 00       	call   801041c0 <acquire>
  myproc()->state = RUNNABLE;
80103c52:	e8 c9 fa ff ff       	call   80103720 <myproc>
80103c57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103c5e:	e8 1d fe ff ff       	call   80103a80 <sched>
  release(&ptable.lock);
80103c63:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c6a:	e8 41 06 00 00       	call   801042b0 <release>
}
80103c6f:	c9                   	leave  
80103c70:	c3                   	ret    
80103c71:	eb 0d                	jmp    80103c80 <sleep>
80103c73:	90                   	nop
80103c74:	90                   	nop
80103c75:	90                   	nop
80103c76:	90                   	nop
80103c77:	90                   	nop
80103c78:	90                   	nop
80103c79:	90                   	nop
80103c7a:	90                   	nop
80103c7b:	90                   	nop
80103c7c:	90                   	nop
80103c7d:	90                   	nop
80103c7e:	90                   	nop
80103c7f:	90                   	nop

80103c80 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 1c             	sub    $0x1c,%esp
80103c89:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c8f:	e8 8c fa ff ff       	call   80103720 <myproc>
  
  if(p == 0)
80103c94:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103c96:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103c98:	0f 84 7c 00 00 00    	je     80103d1a <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103c9e:	85 f6                	test   %esi,%esi
80103ca0:	74 6c                	je     80103d0e <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103ca2:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80103ca8:	74 46                	je     80103cf0 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103caa:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cb1:	e8 0a 05 00 00       	call   801041c0 <acquire>
    release(lk);
80103cb6:	89 34 24             	mov    %esi,(%esp)
80103cb9:	e8 f2 05 00 00       	call   801042b0 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103cbe:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103cc1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103cc8:	e8 b3 fd ff ff       	call   80103a80 <sched>

  // Tidy up.
  p->chan = 0;
80103ccd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103cd4:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cdb:	e8 d0 05 00 00       	call   801042b0 <release>
    acquire(lk);
80103ce0:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103ce3:	83 c4 1c             	add    $0x1c,%esp
80103ce6:	5b                   	pop    %ebx
80103ce7:	5e                   	pop    %esi
80103ce8:	5f                   	pop    %edi
80103ce9:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103cea:	e9 d1 04 00 00       	jmp    801041c0 <acquire>
80103cef:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103cf0:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103cf3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103cfa:	e8 81 fd ff ff       	call   80103a80 <sched>

  // Tidy up.
  p->chan = 0;
80103cff:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103d06:	83 c4 1c             	add    $0x1c,%esp
80103d09:	5b                   	pop    %ebx
80103d0a:	5e                   	pop    %esi
80103d0b:	5f                   	pop    %edi
80103d0c:	5d                   	pop    %ebp
80103d0d:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103d0e:	c7 04 24 cf 7b 10 80 	movl   $0x80107bcf,(%esp)
80103d15:	e8 46 c6 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103d1a:	c7 04 24 c9 7b 10 80 	movl   $0x80107bc9,(%esp)
80103d21:	e8 3a c6 ff ff       	call   80100360 <panic>
80103d26:	8d 76 00             	lea    0x0(%esi),%esi
80103d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d30 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	56                   	push   %esi
80103d34:	53                   	push   %ebx
80103d35:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103d38:	e8 e3 f9 ff ff       	call   80103720 <myproc>
  
  acquire(&ptable.lock);
80103d3d:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103d44:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103d46:	e8 75 04 00 00       	call   801041c0 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103d4b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d4d:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103d52:	eb 0f                	jmp    80103d63 <wait+0x33>
80103d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d58:	83 c3 7c             	add    $0x7c,%ebx
80103d5b:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103d61:	74 1d                	je     80103d80 <wait+0x50>
      if(p->parent != curproc)
80103d63:	39 73 14             	cmp    %esi,0x14(%ebx)
80103d66:	75 f0                	jne    80103d58 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103d68:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d6c:	74 2f                	je     80103d9d <wait+0x6d>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d6e:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103d71:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d76:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103d7c:	75 e5                	jne    80103d63 <wait+0x33>
80103d7e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103d80:	85 c0                	test   %eax,%eax
80103d82:	74 6e                	je     80103df2 <wait+0xc2>
80103d84:	8b 46 24             	mov    0x24(%esi),%eax
80103d87:	85 c0                	test   %eax,%eax
80103d89:	75 67                	jne    80103df2 <wait+0xc2>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d8b:	c7 44 24 04 20 3d 11 	movl   $0x80113d20,0x4(%esp)
80103d92:	80 
80103d93:	89 34 24             	mov    %esi,(%esp)
80103d96:	e8 e5 fe ff ff       	call   80103c80 <sleep>
  }
80103d9b:	eb ae                	jmp    80103d4b <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103d9d:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103da0:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103da3:	89 04 24             	mov    %eax,(%esp)
80103da6:	e8 c5 e5 ff ff       	call   80102370 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103dab:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103dae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103db5:	89 04 24             	mov    %eax,(%esp)
80103db8:	e8 f3 34 00 00       	call   801072b0 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103dbd:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103dc4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103dcb:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103dd2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103dd6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ddd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103de4:	e8 c7 04 00 00       	call   801042b0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103de9:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103dec:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103dee:	5b                   	pop    %ebx
80103def:	5e                   	pop    %esi
80103df0:	5d                   	pop    %ebp
80103df1:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103df2:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103df9:	e8 b2 04 00 00       	call   801042b0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103dfe:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e06:	5b                   	pop    %ebx
80103e07:	5e                   	pop    %esi
80103e08:	5d                   	pop    %ebp
80103e09:	c3                   	ret    
80103e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e10 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	53                   	push   %ebx
80103e14:	83 ec 14             	sub    $0x14,%esp
80103e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103e1a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e21:	e8 9a 03 00 00       	call   801041c0 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e26:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103e2b:	eb 0d                	jmp    80103e3a <wakeup+0x2a>
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
80103e30:	83 c0 7c             	add    $0x7c,%eax
80103e33:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103e38:	74 1e                	je     80103e58 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103e3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e3e:	75 f0                	jne    80103e30 <wakeup+0x20>
80103e40:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e43:	75 eb                	jne    80103e30 <wakeup+0x20>
      p->state = RUNNABLE;
80103e45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e4c:	83 c0 7c             	add    $0x7c,%eax
80103e4f:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103e54:	75 e4                	jne    80103e3a <wakeup+0x2a>
80103e56:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103e58:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80103e5f:	83 c4 14             	add    $0x14,%esp
80103e62:	5b                   	pop    %ebx
80103e63:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103e64:	e9 47 04 00 00       	jmp    801042b0 <release>
80103e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e70 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	53                   	push   %ebx
80103e74:	83 ec 14             	sub    $0x14,%esp
80103e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e7a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e81:	e8 3a 03 00 00       	call   801041c0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e86:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103e8b:	eb 0d                	jmp    80103e9a <kill+0x2a>
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
80103e90:	83 c0 7c             	add    $0x7c,%eax
80103e93:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103e98:	74 36                	je     80103ed0 <kill+0x60>
    if(p->pid == pid){
80103e9a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e9d:	75 f1                	jne    80103e90 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e9f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103ea3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103eaa:	74 14                	je     80103ec0 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103eac:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103eb3:	e8 f8 03 00 00       	call   801042b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103eb8:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103ebb:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103ebd:	5b                   	pop    %ebx
80103ebe:	5d                   	pop    %ebp
80103ebf:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103ec0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ec7:	eb e3                	jmp    80103eac <kill+0x3c>
80103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103ed0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ed7:	e8 d4 03 00 00       	call   801042b0 <release>
  return -1;
}
80103edc:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103edf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ee4:	5b                   	pop    %ebx
80103ee5:	5d                   	pop    %ebp
80103ee6:	c3                   	ret    
80103ee7:	89 f6                	mov    %esi,%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
80103efb:	83 ec 4c             	sub    $0x4c,%esp
80103efe:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103f01:	eb 20                	jmp    80103f23 <procdump+0x33>
80103f03:	90                   	nop
80103f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103f08:	c7 04 24 c2 7d 10 80 	movl   $0x80107dc2,(%esp)
80103f0f:	e8 3c c7 ff ff       	call   80100650 <cprintf>
80103f14:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f17:	81 fb c0 5c 11 80    	cmp    $0x80115cc0,%ebx
80103f1d:	0f 84 8d 00 00 00    	je     80103fb0 <procdump+0xc0>
    if(p->state == UNUSED)
80103f23:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103f26:	85 c0                	test   %eax,%eax
80103f28:	74 ea                	je     80103f14 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f2a:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103f2d:	ba e0 7b 10 80       	mov    $0x80107be0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f32:	77 11                	ja     80103f45 <procdump+0x55>
80103f34:	8b 14 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103f3b:	b8 e0 7b 10 80       	mov    $0x80107be0,%eax
80103f40:	85 d2                	test   %edx,%edx
80103f42:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f45:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103f48:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103f4c:	89 54 24 08          	mov    %edx,0x8(%esp)
80103f50:	c7 04 24 e4 7b 10 80 	movl   $0x80107be4,(%esp)
80103f57:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f5b:	e8 f0 c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103f60:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f64:	75 a2                	jne    80103f08 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f66:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f69:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f6d:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f70:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f73:	8b 40 0c             	mov    0xc(%eax),%eax
80103f76:	83 c0 08             	add    $0x8,%eax
80103f79:	89 04 24             	mov    %eax,(%esp)
80103f7c:	e8 6f 01 00 00       	call   801040f0 <getcallerpcs>
80103f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f88:	8b 17                	mov    (%edi),%edx
80103f8a:	85 d2                	test   %edx,%edx
80103f8c:	0f 84 76 ff ff ff    	je     80103f08 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f92:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f96:	83 c7 04             	add    $0x4,%edi
80103f99:	c7 04 24 21 76 10 80 	movl   $0x80107621,(%esp)
80103fa0:	e8 ab c6 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80103fa5:	39 f7                	cmp    %esi,%edi
80103fa7:	75 df                	jne    80103f88 <procdump+0x98>
80103fa9:	e9 5a ff ff ff       	jmp    80103f08 <procdump+0x18>
80103fae:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80103fb0:	83 c4 4c             	add    $0x4c,%esp
80103fb3:	5b                   	pop    %ebx
80103fb4:	5e                   	pop    %esi
80103fb5:	5f                   	pop    %edi
80103fb6:	5d                   	pop    %ebp
80103fb7:	c3                   	ret    
80103fb8:	66 90                	xchg   %ax,%ax
80103fba:	66 90                	xchg   %ax,%ax
80103fbc:	66 90                	xchg   %ax,%ax
80103fbe:	66 90                	xchg   %ax,%ax

80103fc0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	53                   	push   %ebx
80103fc4:	83 ec 14             	sub    $0x14,%esp
80103fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103fca:	c7 44 24 04 58 7c 10 	movl   $0x80107c58,0x4(%esp)
80103fd1:	80 
80103fd2:	8d 43 04             	lea    0x4(%ebx),%eax
80103fd5:	89 04 24             	mov    %eax,(%esp)
80103fd8:	e8 f3 00 00 00       	call   801040d0 <initlock>
  lk->name = name;
80103fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103fe0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fe6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80103fed:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80103ff0:	83 c4 14             	add    $0x14,%esp
80103ff3:	5b                   	pop    %ebx
80103ff4:	5d                   	pop    %ebp
80103ff5:	c3                   	ret    
80103ff6:	8d 76 00             	lea    0x0(%esi),%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
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
80104011:	e8 aa 01 00 00       	call   801041c0 <acquire>
  while (lk->locked) {
80104016:	8b 13                	mov    (%ebx),%edx
80104018:	85 d2                	test   %edx,%edx
8010401a:	74 16                	je     80104032 <acquiresleep+0x32>
8010401c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104020:	89 74 24 04          	mov    %esi,0x4(%esp)
80104024:	89 1c 24             	mov    %ebx,(%esp)
80104027:	e8 54 fc ff ff       	call   80103c80 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010402c:	8b 03                	mov    (%ebx),%eax
8010402e:	85 c0                	test   %eax,%eax
80104030:	75 ee                	jne    80104020 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104032:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104038:	e8 e3 f6 ff ff       	call   80103720 <myproc>
8010403d:	8b 40 10             	mov    0x10(%eax),%eax
80104040:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104043:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104046:	83 c4 10             	add    $0x10,%esp
80104049:	5b                   	pop    %ebx
8010404a:	5e                   	pop    %esi
8010404b:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010404c:	e9 5f 02 00 00       	jmp    801042b0 <release>
80104051:	eb 0d                	jmp    80104060 <releasesleep>
80104053:	90                   	nop
80104054:	90                   	nop
80104055:	90                   	nop
80104056:	90                   	nop
80104057:	90                   	nop
80104058:	90                   	nop
80104059:	90                   	nop
8010405a:	90                   	nop
8010405b:	90                   	nop
8010405c:	90                   	nop
8010405d:	90                   	nop
8010405e:	90                   	nop
8010405f:	90                   	nop

80104060 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	56                   	push   %esi
80104064:	53                   	push   %ebx
80104065:	83 ec 10             	sub    $0x10,%esp
80104068:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010406b:	8d 73 04             	lea    0x4(%ebx),%esi
8010406e:	89 34 24             	mov    %esi,(%esp)
80104071:	e8 4a 01 00 00       	call   801041c0 <acquire>
  lk->locked = 0;
80104076:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010407c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104083:	89 1c 24             	mov    %ebx,(%esp)
80104086:	e8 85 fd ff ff       	call   80103e10 <wakeup>
  release(&lk->lk);
8010408b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010408e:	83 c4 10             	add    $0x10,%esp
80104091:	5b                   	pop    %ebx
80104092:	5e                   	pop    %esi
80104093:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104094:	e9 17 02 00 00       	jmp    801042b0 <release>
80104099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040a0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	56                   	push   %esi
801040a4:	53                   	push   %ebx
801040a5:	83 ec 10             	sub    $0x10,%esp
801040a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801040ab:	8d 73 04             	lea    0x4(%ebx),%esi
801040ae:	89 34 24             	mov    %esi,(%esp)
801040b1:	e8 0a 01 00 00       	call   801041c0 <acquire>
  r = lk->locked;
801040b6:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
801040b8:	89 34 24             	mov    %esi,(%esp)
801040bb:	e8 f0 01 00 00       	call   801042b0 <release>
  return r;
}
801040c0:	83 c4 10             	add    $0x10,%esp
801040c3:	89 d8                	mov    %ebx,%eax
801040c5:	5b                   	pop    %ebx
801040c6:	5e                   	pop    %esi
801040c7:	5d                   	pop    %ebp
801040c8:	c3                   	ret    
801040c9:	66 90                	xchg   %ax,%ax
801040cb:	66 90                	xchg   %ax,%ax
801040cd:	66 90                	xchg   %ax,%ax
801040cf:	90                   	nop

801040d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801040d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801040d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801040df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801040e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801040e9:	5d                   	pop    %ebp
801040ea:	c3                   	ret    
801040eb:	90                   	nop
801040ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040f3:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801040f9:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040fa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801040fd:	31 c0                	xor    %eax,%eax
801040ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104100:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104106:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010410c:	77 1a                	ja     80104128 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010410e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104111:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104114:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104117:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104119:	83 f8 0a             	cmp    $0xa,%eax
8010411c:	75 e2                	jne    80104100 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010411e:	5b                   	pop    %ebx
8010411f:	5d                   	pop    %ebp
80104120:	c3                   	ret    
80104121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104128:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010412f:	83 c0 01             	add    $0x1,%eax
80104132:	83 f8 0a             	cmp    $0xa,%eax
80104135:	74 e7                	je     8010411e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104137:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010413e:	83 c0 01             	add    $0x1,%eax
80104141:	83 f8 0a             	cmp    $0xa,%eax
80104144:	75 e2                	jne    80104128 <getcallerpcs+0x38>
80104146:	eb d6                	jmp    8010411e <getcallerpcs+0x2e>
80104148:	90                   	nop
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104150 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104150:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
80104151:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104153:	89 e5                	mov    %esp,%ebp
80104155:	53                   	push   %ebx
80104156:	83 ec 04             	sub    $0x4,%esp
80104159:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010415c:	8b 0a                	mov    (%edx),%ecx
8010415e:	85 c9                	test   %ecx,%ecx
80104160:	74 10                	je     80104172 <holding+0x22>
80104162:	8b 5a 08             	mov    0x8(%edx),%ebx
80104165:	e8 16 f5 ff ff       	call   80103680 <mycpu>
8010416a:	39 c3                	cmp    %eax,%ebx
8010416c:	0f 94 c0             	sete   %al
8010416f:	0f b6 c0             	movzbl %al,%eax
}
80104172:	83 c4 04             	add    $0x4,%esp
80104175:	5b                   	pop    %ebx
80104176:	5d                   	pop    %ebp
80104177:	c3                   	ret    
80104178:	90                   	nop
80104179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104180 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 04             	sub    $0x4,%esp
80104187:	9c                   	pushf  
80104188:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104189:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010418a:	e8 f1 f4 ff ff       	call   80103680 <mycpu>
8010418f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104195:	85 c0                	test   %eax,%eax
80104197:	75 11                	jne    801041aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104199:	e8 e2 f4 ff ff       	call   80103680 <mycpu>
8010419e:	81 e3 00 02 00 00    	and    $0x200,%ebx
801041a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801041aa:	e8 d1 f4 ff ff       	call   80103680 <mycpu>
801041af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801041b6:	83 c4 04             	add    $0x4,%esp
801041b9:	5b                   	pop    %ebx
801041ba:	5d                   	pop    %ebp
801041bb:	c3                   	ret    
801041bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041c0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801041c7:	e8 b4 ff ff ff       	call   80104180 <pushcli>
  if(holding(lk))
801041cc:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801041cf:	8b 02                	mov    (%edx),%eax
801041d1:	85 c0                	test   %eax,%eax
801041d3:	75 43                	jne    80104218 <acquire+0x58>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801041d5:	b9 01 00 00 00       	mov    $0x1,%ecx
801041da:	eb 07                	jmp    801041e3 <acquire+0x23>
801041dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e0:	8b 55 08             	mov    0x8(%ebp),%edx
801041e3:	89 c8                	mov    %ecx,%eax
801041e5:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801041e8:	85 c0                	test   %eax,%eax
801041ea:	75 f4                	jne    801041e0 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801041ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801041f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801041f4:	e8 87 f4 ff ff       	call   80103680 <mycpu>
801041f9:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801041fc:	8b 45 08             	mov    0x8(%ebp),%eax
801041ff:	83 c0 0c             	add    $0xc,%eax
80104202:	89 44 24 04          	mov    %eax,0x4(%esp)
80104206:	8d 45 08             	lea    0x8(%ebp),%eax
80104209:	89 04 24             	mov    %eax,(%esp)
8010420c:	e8 df fe ff ff       	call   801040f0 <getcallerpcs>
}
80104211:	83 c4 14             	add    $0x14,%esp
80104214:	5b                   	pop    %ebx
80104215:	5d                   	pop    %ebp
80104216:	c3                   	ret    
80104217:	90                   	nop

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104218:	8b 5a 08             	mov    0x8(%edx),%ebx
8010421b:	e8 60 f4 ff ff       	call   80103680 <mycpu>
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
80104220:	39 c3                	cmp    %eax,%ebx
80104222:	74 05                	je     80104229 <acquire+0x69>
80104224:	8b 55 08             	mov    0x8(%ebp),%edx
80104227:	eb ac                	jmp    801041d5 <acquire+0x15>
    panic("acquire");
80104229:	c7 04 24 63 7c 10 80 	movl   $0x80107c63,(%esp)
80104230:	e8 2b c1 ff ff       	call   80100360 <panic>
80104235:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104240 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104246:	9c                   	pushf  
80104247:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104248:	f6 c4 02             	test   $0x2,%ah
8010424b:	75 49                	jne    80104296 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010424d:	e8 2e f4 ff ff       	call   80103680 <mycpu>
80104252:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104258:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010425b:	85 d2                	test   %edx,%edx
8010425d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104263:	78 25                	js     8010428a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104265:	e8 16 f4 ff ff       	call   80103680 <mycpu>
8010426a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104270:	85 d2                	test   %edx,%edx
80104272:	74 04                	je     80104278 <popcli+0x38>
    sti();
}
80104274:	c9                   	leave  
80104275:	c3                   	ret    
80104276:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104278:	e8 03 f4 ff ff       	call   80103680 <mycpu>
8010427d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104283:	85 c0                	test   %eax,%eax
80104285:	74 ed                	je     80104274 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104287:	fb                   	sti    
    sti();
}
80104288:	c9                   	leave  
80104289:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
8010428a:	c7 04 24 82 7c 10 80 	movl   $0x80107c82,(%esp)
80104291:	e8 ca c0 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104296:	c7 04 24 6b 7c 10 80 	movl   $0x80107c6b,(%esp)
8010429d:	e8 be c0 ff ff       	call   80100360 <panic>
801042a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042b0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
801042b5:	83 ec 10             	sub    $0x10,%esp
801042b8:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801042bb:	8b 03                	mov    (%ebx),%eax
801042bd:	85 c0                	test   %eax,%eax
801042bf:	75 0f                	jne    801042d0 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801042c1:	c7 04 24 89 7c 10 80 	movl   $0x80107c89,(%esp)
801042c8:	e8 93 c0 ff ff       	call   80100360 <panic>
801042cd:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801042d0:	8b 73 08             	mov    0x8(%ebx),%esi
801042d3:	e8 a8 f3 ff ff       	call   80103680 <mycpu>

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
801042d8:	39 c6                	cmp    %eax,%esi
801042da:	75 e5                	jne    801042c1 <release+0x11>
    panic("release");

  lk->pcs[0] = 0;
801042dc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801042e3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801042ea:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801042ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801042f5:	83 c4 10             	add    $0x10,%esp
801042f8:	5b                   	pop    %ebx
801042f9:	5e                   	pop    %esi
801042fa:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801042fb:	e9 40 ff ff ff       	jmp    80104240 <popcli>

80104300 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	8b 55 08             	mov    0x8(%ebp),%edx
80104306:	57                   	push   %edi
80104307:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010430a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010430b:	f6 c2 03             	test   $0x3,%dl
8010430e:	75 05                	jne    80104315 <memset+0x15>
80104310:	f6 c1 03             	test   $0x3,%cl
80104313:	74 13                	je     80104328 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104315:	89 d7                	mov    %edx,%edi
80104317:	8b 45 0c             	mov    0xc(%ebp),%eax
8010431a:	fc                   	cld    
8010431b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010431d:	5b                   	pop    %ebx
8010431e:	89 d0                	mov    %edx,%eax
80104320:	5f                   	pop    %edi
80104321:	5d                   	pop    %ebp
80104322:	c3                   	ret    
80104323:	90                   	nop
80104324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104328:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010432c:	c1 e9 02             	shr    $0x2,%ecx
8010432f:	89 f8                	mov    %edi,%eax
80104331:	89 fb                	mov    %edi,%ebx
80104333:	c1 e0 18             	shl    $0x18,%eax
80104336:	c1 e3 10             	shl    $0x10,%ebx
80104339:	09 d8                	or     %ebx,%eax
8010433b:	09 f8                	or     %edi,%eax
8010433d:	c1 e7 08             	shl    $0x8,%edi
80104340:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104342:	89 d7                	mov    %edx,%edi
80104344:	fc                   	cld    
80104345:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104347:	5b                   	pop    %ebx
80104348:	89 d0                	mov    %edx,%eax
8010434a:	5f                   	pop    %edi
8010434b:	5d                   	pop    %ebp
8010434c:	c3                   	ret    
8010434d:	8d 76 00             	lea    0x0(%esi),%esi

80104350 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	8b 45 10             	mov    0x10(%ebp),%eax
80104356:	57                   	push   %edi
80104357:	56                   	push   %esi
80104358:	8b 75 0c             	mov    0xc(%ebp),%esi
8010435b:	53                   	push   %ebx
8010435c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010435f:	85 c0                	test   %eax,%eax
80104361:	8d 78 ff             	lea    -0x1(%eax),%edi
80104364:	74 26                	je     8010438c <memcmp+0x3c>
    if(*s1 != *s2)
80104366:	0f b6 03             	movzbl (%ebx),%eax
80104369:	31 d2                	xor    %edx,%edx
8010436b:	0f b6 0e             	movzbl (%esi),%ecx
8010436e:	38 c8                	cmp    %cl,%al
80104370:	74 16                	je     80104388 <memcmp+0x38>
80104372:	eb 24                	jmp    80104398 <memcmp+0x48>
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104378:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010437d:	83 c2 01             	add    $0x1,%edx
80104380:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104384:	38 c8                	cmp    %cl,%al
80104386:	75 10                	jne    80104398 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104388:	39 fa                	cmp    %edi,%edx
8010438a:	75 ec                	jne    80104378 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010438c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010438d:	31 c0                	xor    %eax,%eax
}
8010438f:	5e                   	pop    %esi
80104390:	5f                   	pop    %edi
80104391:	5d                   	pop    %ebp
80104392:	c3                   	ret    
80104393:	90                   	nop
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104398:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104399:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010439b:	5e                   	pop    %esi
8010439c:	5f                   	pop    %edi
8010439d:	5d                   	pop    %ebp
8010439e:	c3                   	ret    
8010439f:	90                   	nop

801043a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	8b 45 08             	mov    0x8(%ebp),%eax
801043a7:	56                   	push   %esi
801043a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801043ab:	53                   	push   %ebx
801043ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801043af:	39 c6                	cmp    %eax,%esi
801043b1:	73 35                	jae    801043e8 <memmove+0x48>
801043b3:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801043b6:	39 c8                	cmp    %ecx,%eax
801043b8:	73 2e                	jae    801043e8 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
801043ba:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
801043bc:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
801043bf:	8d 53 ff             	lea    -0x1(%ebx),%edx
801043c2:	74 1b                	je     801043df <memmove+0x3f>
801043c4:	f7 db                	neg    %ebx
801043c6:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
801043c9:	01 fb                	add    %edi,%ebx
801043cb:	90                   	nop
801043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801043d0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043d4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801043d7:	83 ea 01             	sub    $0x1,%edx
801043da:	83 fa ff             	cmp    $0xffffffff,%edx
801043dd:	75 f1                	jne    801043d0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801043df:	5b                   	pop    %ebx
801043e0:	5e                   	pop    %esi
801043e1:	5f                   	pop    %edi
801043e2:	5d                   	pop    %ebp
801043e3:	c3                   	ret    
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801043e8:	31 d2                	xor    %edx,%edx
801043ea:	85 db                	test   %ebx,%ebx
801043ec:	74 f1                	je     801043df <memmove+0x3f>
801043ee:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801043f0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801043f7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801043fa:	39 da                	cmp    %ebx,%edx
801043fc:	75 f2                	jne    801043f0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801043fe:	5b                   	pop    %ebx
801043ff:	5e                   	pop    %esi
80104400:	5f                   	pop    %edi
80104401:	5d                   	pop    %ebp
80104402:	c3                   	ret    
80104403:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104410 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104413:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104414:	e9 87 ff ff ff       	jmp    801043a0 <memmove>
80104419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104420 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	8b 75 10             	mov    0x10(%ebp),%esi
80104427:	53                   	push   %ebx
80104428:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010442b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010442e:	85 f6                	test   %esi,%esi
80104430:	74 30                	je     80104462 <strncmp+0x42>
80104432:	0f b6 01             	movzbl (%ecx),%eax
80104435:	84 c0                	test   %al,%al
80104437:	74 2f                	je     80104468 <strncmp+0x48>
80104439:	0f b6 13             	movzbl (%ebx),%edx
8010443c:	38 d0                	cmp    %dl,%al
8010443e:	75 46                	jne    80104486 <strncmp+0x66>
80104440:	8d 51 01             	lea    0x1(%ecx),%edx
80104443:	01 ce                	add    %ecx,%esi
80104445:	eb 14                	jmp    8010445b <strncmp+0x3b>
80104447:	90                   	nop
80104448:	0f b6 02             	movzbl (%edx),%eax
8010444b:	84 c0                	test   %al,%al
8010444d:	74 31                	je     80104480 <strncmp+0x60>
8010444f:	0f b6 19             	movzbl (%ecx),%ebx
80104452:	83 c2 01             	add    $0x1,%edx
80104455:	38 d8                	cmp    %bl,%al
80104457:	75 17                	jne    80104470 <strncmp+0x50>
    n--, p++, q++;
80104459:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010445b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010445d:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104460:	75 e6                	jne    80104448 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104462:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104463:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104465:	5e                   	pop    %esi
80104466:	5d                   	pop    %ebp
80104467:	c3                   	ret    
80104468:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010446b:	31 c0                	xor    %eax,%eax
8010446d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104470:	0f b6 d3             	movzbl %bl,%edx
80104473:	29 d0                	sub    %edx,%eax
}
80104475:	5b                   	pop    %ebx
80104476:	5e                   	pop    %esi
80104477:	5d                   	pop    %ebp
80104478:	c3                   	ret    
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104480:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104484:	eb ea                	jmp    80104470 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104486:	89 d3                	mov    %edx,%ebx
80104488:	eb e6                	jmp    80104470 <strncmp+0x50>
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	8b 45 08             	mov    0x8(%ebp),%eax
80104496:	56                   	push   %esi
80104497:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010449a:	53                   	push   %ebx
8010449b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010449e:	89 c2                	mov    %eax,%edx
801044a0:	eb 19                	jmp    801044bb <strncpy+0x2b>
801044a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044a8:	83 c3 01             	add    $0x1,%ebx
801044ab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801044af:	83 c2 01             	add    $0x1,%edx
801044b2:	84 c9                	test   %cl,%cl
801044b4:	88 4a ff             	mov    %cl,-0x1(%edx)
801044b7:	74 09                	je     801044c2 <strncpy+0x32>
801044b9:	89 f1                	mov    %esi,%ecx
801044bb:	85 c9                	test   %ecx,%ecx
801044bd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801044c0:	7f e6                	jg     801044a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801044c2:	31 c9                	xor    %ecx,%ecx
801044c4:	85 f6                	test   %esi,%esi
801044c6:	7e 0f                	jle    801044d7 <strncpy+0x47>
    *s++ = 0;
801044c8:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801044cc:	89 f3                	mov    %esi,%ebx
801044ce:	83 c1 01             	add    $0x1,%ecx
801044d1:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801044d3:	85 db                	test   %ebx,%ebx
801044d5:	7f f1                	jg     801044c8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
801044d7:	5b                   	pop    %ebx
801044d8:	5e                   	pop    %esi
801044d9:	5d                   	pop    %ebp
801044da:	c3                   	ret    
801044db:	90                   	nop
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044e6:	56                   	push   %esi
801044e7:	8b 45 08             	mov    0x8(%ebp),%eax
801044ea:	53                   	push   %ebx
801044eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801044ee:	85 c9                	test   %ecx,%ecx
801044f0:	7e 26                	jle    80104518 <safestrcpy+0x38>
801044f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801044f6:	89 c1                	mov    %eax,%ecx
801044f8:	eb 17                	jmp    80104511 <safestrcpy+0x31>
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104500:	83 c2 01             	add    $0x1,%edx
80104503:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104507:	83 c1 01             	add    $0x1,%ecx
8010450a:	84 db                	test   %bl,%bl
8010450c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010450f:	74 04                	je     80104515 <safestrcpy+0x35>
80104511:	39 f2                	cmp    %esi,%edx
80104513:	75 eb                	jne    80104500 <safestrcpy+0x20>
    ;
  *s = 0;
80104515:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104518:	5b                   	pop    %ebx
80104519:	5e                   	pop    %esi
8010451a:	5d                   	pop    %ebp
8010451b:	c3                   	ret    
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104520 <strlen>:

int
strlen(const char *s)
{
80104520:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104521:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104523:	89 e5                	mov    %esp,%ebp
80104525:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104528:	80 3a 00             	cmpb   $0x0,(%edx)
8010452b:	74 0c                	je     80104539 <strlen+0x19>
8010452d:	8d 76 00             	lea    0x0(%esi),%esi
80104530:	83 c0 01             	add    $0x1,%eax
80104533:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104537:	75 f7                	jne    80104530 <strlen+0x10>
    ;
  return n;
}
80104539:	5d                   	pop    %ebp
8010453a:	c3                   	ret    

8010453b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010453b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010453f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104543:	55                   	push   %ebp
  pushl %ebx
80104544:	53                   	push   %ebx
  pushl %esi
80104545:	56                   	push   %esi
  pushl %edi
80104546:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104547:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104549:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010454b:	5f                   	pop    %edi
  popl %esi
8010454c:	5e                   	pop    %esi
  popl %ebx
8010454d:	5b                   	pop    %ebx
  popl %ebp
8010454e:	5d                   	pop    %ebp
  ret
8010454f:	c3                   	ret    

80104550 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 04             	sub    $0x4,%esp
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010455a:	e8 c1 f1 ff ff       	call   80103720 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010455f:	8b 00                	mov    (%eax),%eax
80104561:	39 d8                	cmp    %ebx,%eax
80104563:	76 1b                	jbe    80104580 <fetchint+0x30>
80104565:	8d 53 04             	lea    0x4(%ebx),%edx
80104568:	39 d0                	cmp    %edx,%eax
8010456a:	72 14                	jb     80104580 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010456c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010456f:	8b 13                	mov    (%ebx),%edx
80104571:	89 10                	mov    %edx,(%eax)
  return 0;
80104573:	31 c0                	xor    %eax,%eax
}
80104575:	83 c4 04             	add    $0x4,%esp
80104578:	5b                   	pop    %ebx
80104579:	5d                   	pop    %ebp
8010457a:	c3                   	ret    
8010457b:	90                   	nop
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104585:	eb ee                	jmp    80104575 <fetchint+0x25>
80104587:	89 f6                	mov    %esi,%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 04             	sub    $0x4,%esp
80104597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010459a:	e8 81 f1 ff ff       	call   80103720 <myproc>

  if(addr >= curproc->sz)
8010459f:	39 18                	cmp    %ebx,(%eax)
801045a1:	76 26                	jbe    801045c9 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
801045a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801045a6:	89 da                	mov    %ebx,%edx
801045a8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801045aa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801045ac:	39 c3                	cmp    %eax,%ebx
801045ae:	73 19                	jae    801045c9 <fetchstr+0x39>
    if(*s == 0)
801045b0:	80 3b 00             	cmpb   $0x0,(%ebx)
801045b3:	75 0d                	jne    801045c2 <fetchstr+0x32>
801045b5:	eb 21                	jmp    801045d8 <fetchstr+0x48>
801045b7:	90                   	nop
801045b8:	80 3a 00             	cmpb   $0x0,(%edx)
801045bb:	90                   	nop
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045c0:	74 16                	je     801045d8 <fetchstr+0x48>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801045c2:	83 c2 01             	add    $0x1,%edx
801045c5:	39 d0                	cmp    %edx,%eax
801045c7:	77 ef                	ja     801045b8 <fetchstr+0x28>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801045c9:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
801045cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801045d1:	5b                   	pop    %ebx
801045d2:	5d                   	pop    %ebp
801045d3:	c3                   	ret    
801045d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045d8:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801045db:	89 d0                	mov    %edx,%eax
801045dd:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801045df:	5b                   	pop    %ebx
801045e0:	5d                   	pop    %ebp
801045e1:	c3                   	ret    
801045e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	8b 75 0c             	mov    0xc(%ebp),%esi
801045f7:	53                   	push   %ebx
801045f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045fb:	e8 20 f1 ff ff       	call   80103720 <myproc>
80104600:	89 75 0c             	mov    %esi,0xc(%ebp)
80104603:	8b 40 18             	mov    0x18(%eax),%eax
80104606:	8b 40 44             	mov    0x44(%eax),%eax
80104609:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010460d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104610:	5b                   	pop    %ebx
80104611:	5e                   	pop    %esi
80104612:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104613:	e9 38 ff ff ff       	jmp    80104550 <fetchint>
80104618:	90                   	nop
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104620 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	83 ec 20             	sub    $0x20,%esp
80104628:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010462b:	e8 f0 f0 ff ff       	call   80103720 <myproc>
80104630:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104632:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104635:	89 44 24 04          	mov    %eax,0x4(%esp)
80104639:	8b 45 08             	mov    0x8(%ebp),%eax
8010463c:	89 04 24             	mov    %eax,(%esp)
8010463f:	e8 ac ff ff ff       	call   801045f0 <argint>
80104644:	85 c0                	test   %eax,%eax
80104646:	78 28                	js     80104670 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104648:	85 db                	test   %ebx,%ebx
8010464a:	78 24                	js     80104670 <argptr+0x50>
8010464c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010464f:	8b 06                	mov    (%esi),%eax
80104651:	39 c2                	cmp    %eax,%edx
80104653:	73 1b                	jae    80104670 <argptr+0x50>
80104655:	01 d3                	add    %edx,%ebx
80104657:	39 d8                	cmp    %ebx,%eax
80104659:	72 15                	jb     80104670 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010465b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010465e:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104660:	83 c4 20             	add    $0x20,%esp
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
80104663:	31 c0                	xor    %eax,%eax
}
80104665:	5b                   	pop    %ebx
80104666:	5e                   	pop    %esi
80104667:	5d                   	pop    %ebp
80104668:	c3                   	ret    
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104670:	83 c4 20             	add    $0x20,%esp
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
80104673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}
80104678:	5b                   	pop    %ebx
80104679:	5e                   	pop    %esi
8010467a:	5d                   	pop    %ebp
8010467b:	c3                   	ret    
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104680 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104686:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104689:	89 44 24 04          	mov    %eax,0x4(%esp)
8010468d:	8b 45 08             	mov    0x8(%ebp),%eax
80104690:	89 04 24             	mov    %eax,(%esp)
80104693:	e8 58 ff ff ff       	call   801045f0 <argint>
80104698:	85 c0                	test   %eax,%eax
8010469a:	78 14                	js     801046b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010469c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010469f:	89 44 24 04          	mov    %eax,0x4(%esp)
801046a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a6:	89 04 24             	mov    %eax,(%esp)
801046a9:	e8 e2 fe ff ff       	call   80104590 <fetchstr>
}
801046ae:	c9                   	leave  
801046af:	c3                   	ret    
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801046b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801046b5:	c9                   	leave  
801046b6:	c3                   	ret    
801046b7:	89 f6                	mov    %esi,%esi
801046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046c0 <syscall>:
[SYS_recoverFS] sys_recoverFS,
};

void
syscall(void)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
801046c8:	e8 53 f0 ff ff       	call   80103720 <myproc>

  num = curproc->tf->eax;
801046cd:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801046d0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801046d2:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801046d5:	8d 50 ff             	lea    -0x1(%eax),%edx
801046d8:	83 fa 1a             	cmp    $0x1a,%edx
801046db:	77 1b                	ja     801046f8 <syscall+0x38>
801046dd:	8b 14 85 c0 7c 10 80 	mov    -0x7fef8340(,%eax,4),%edx
801046e4:	85 d2                	test   %edx,%edx
801046e6:	74 10                	je     801046f8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801046e8:	ff d2                	call   *%edx
801046ea:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801046ed:	83 c4 10             	add    $0x10,%esp
801046f0:	5b                   	pop    %ebx
801046f1:	5e                   	pop    %esi
801046f2:	5d                   	pop    %ebp
801046f3:	c3                   	ret    
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801046f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
801046fc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801046ff:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104703:	8b 43 10             	mov    0x10(%ebx),%eax
80104706:	c7 04 24 91 7c 10 80 	movl   $0x80107c91,(%esp)
8010470d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104711:	e8 3a bf ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104716:	8b 43 18             	mov    0x18(%ebx),%eax
80104719:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104720:	83 c4 10             	add    $0x10,%esp
80104723:	5b                   	pop    %ebx
80104724:	5e                   	pop    %esi
80104725:	5d                   	pop    %ebp
80104726:	c3                   	ret    
80104727:	66 90                	xchg   %ax,%ax
80104729:	66 90                	xchg   %ax,%ax
8010472b:	66 90                	xchg   %ax,%ax
8010472d:	66 90                	xchg   %ax,%ax
8010472f:	90                   	nop

80104730 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	89 c3                	mov    %eax,%ebx
80104736:	83 ec 04             	sub    $0x4,%esp
	int fd;
	struct proc *curproc = myproc();
80104739:	e8 e2 ef ff ff       	call   80103720 <myproc>

	for(fd = 0; fd < NOFILE; fd++){
8010473e:	31 d2                	xor    %edx,%edx
		if(curproc->ofile[fd] == 0){
80104740:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104744:	85 c9                	test   %ecx,%ecx
80104746:	74 18                	je     80104760 <fdalloc+0x30>
fdalloc(struct file *f)
{
	int fd;
	struct proc *curproc = myproc();

	for(fd = 0; fd < NOFILE; fd++){
80104748:	83 c2 01             	add    $0x1,%edx
8010474b:	83 fa 10             	cmp    $0x10,%edx
8010474e:	75 f0                	jne    80104740 <fdalloc+0x10>
			curproc->ofile[fd] = f;
			return fd;
		}
	}
	return -1;
}
80104750:	83 c4 04             	add    $0x4,%esp
		if(curproc->ofile[fd] == 0){
			curproc->ofile[fd] = f;
			return fd;
		}
	}
	return -1;
80104753:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104758:	5b                   	pop    %ebx
80104759:	5d                   	pop    %ebp
8010475a:	c3                   	ret    
8010475b:	90                   	nop
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	int fd;
	struct proc *curproc = myproc();

	for(fd = 0; fd < NOFILE; fd++){
		if(curproc->ofile[fd] == 0){
			curproc->ofile[fd] = f;
80104760:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
			return fd;
		}
	}
	return -1;
}
80104764:	83 c4 04             	add    $0x4,%esp
	struct proc *curproc = myproc();

	for(fd = 0; fd < NOFILE; fd++){
		if(curproc->ofile[fd] == 0){
			curproc->ofile[fd] = f;
			return fd;
80104767:	89 d0                	mov    %edx,%eax
		}
	}
	return -1;
}
80104769:	5b                   	pop    %ebx
8010476a:	5d                   	pop    %ebp
8010476b:	c3                   	ret    
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104770 <create>:
	return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	57                   	push   %edi
80104774:	56                   	push   %esi
80104775:	53                   	push   %ebx
80104776:	83 ec 4c             	sub    $0x4c,%esp
80104779:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010477c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	uint off;
	struct inode *ip, *dp;
	char name[DIRSIZ];

	if((dp = nameiparent(path, name)) == 0)
8010477f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104782:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104786:	89 04 24             	mov    %eax,(%esp)
	return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104789:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010478c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
	uint off;
	struct inode *ip, *dp;
	char name[DIRSIZ];

	if((dp = nameiparent(path, name)) == 0)
8010478f:	e8 0c d8 ff ff       	call   80101fa0 <nameiparent>
80104794:	85 c0                	test   %eax,%eax
80104796:	89 c7                	mov    %eax,%edi
80104798:	0f 84 da 00 00 00    	je     80104878 <create+0x108>
		return 0;
	ilock(dp);
8010479e:	89 04 24             	mov    %eax,(%esp)
801047a1:	e8 3a cf ff ff       	call   801016e0 <ilock>

	if((ip = dirlookup(dp, name, &off)) != 0){
801047a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801047a9:	89 44 24 08          	mov    %eax,0x8(%esp)
801047ad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047b1:	89 3c 24             	mov    %edi,(%esp)
801047b4:	e8 87 d4 ff ff       	call   80101c40 <dirlookup>
801047b9:	85 c0                	test   %eax,%eax
801047bb:	89 c6                	mov    %eax,%esi
801047bd:	74 41                	je     80104800 <create+0x90>
		iunlockput(dp);
801047bf:	89 3c 24             	mov    %edi,(%esp)
801047c2:	e8 c9 d1 ff ff       	call   80101990 <iunlockput>
		ilock(ip);
801047c7:	89 34 24             	mov    %esi,(%esp)
801047ca:	e8 11 cf ff ff       	call   801016e0 <ilock>
		if(type == T_FILE && ip->type == T_FILE)
801047cf:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801047d4:	75 12                	jne    801047e8 <create+0x78>
801047d6:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801047db:	89 f0                	mov    %esi,%eax
801047dd:	75 09                	jne    801047e8 <create+0x78>
		panic("create: dirlink");

	iunlockput(dp);

	return ip;
}
801047df:	83 c4 4c             	add    $0x4c,%esp
801047e2:	5b                   	pop    %ebx
801047e3:	5e                   	pop    %esi
801047e4:	5f                   	pop    %edi
801047e5:	5d                   	pop    %ebp
801047e6:	c3                   	ret    
801047e7:	90                   	nop
	if((ip = dirlookup(dp, name, &off)) != 0){
		iunlockput(dp);
		ilock(ip);
		if(type == T_FILE && ip->type == T_FILE)
			return ip;
		iunlockput(ip);
801047e8:	89 34 24             	mov    %esi,(%esp)
801047eb:	e8 a0 d1 ff ff       	call   80101990 <iunlockput>
		panic("create: dirlink");

	iunlockput(dp);

	return ip;
}
801047f0:	83 c4 4c             	add    $0x4c,%esp
		iunlockput(dp);
		ilock(ip);
		if(type == T_FILE && ip->type == T_FILE)
			return ip;
		iunlockput(ip);
		return 0;
801047f3:	31 c0                	xor    %eax,%eax
		panic("create: dirlink");

	iunlockput(dp);

	return ip;
}
801047f5:	5b                   	pop    %ebx
801047f6:	5e                   	pop    %esi
801047f7:	5f                   	pop    %edi
801047f8:	5d                   	pop    %ebp
801047f9:	c3                   	ret    
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			return ip;
		iunlockput(ip);
		return 0;
	}

	if((ip = ialloc(dp->dev, type)) == 0)
80104800:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104804:	89 44 24 04          	mov    %eax,0x4(%esp)
80104808:	8b 07                	mov    (%edi),%eax
8010480a:	89 04 24             	mov    %eax,(%esp)
8010480d:	e8 3e cd ff ff       	call   80101550 <ialloc>
80104812:	85 c0                	test   %eax,%eax
80104814:	89 c6                	mov    %eax,%esi
80104816:	0f 84 bf 00 00 00    	je     801048db <create+0x16b>
		panic("create: ialloc");

	ilock(ip);
8010481c:	89 04 24             	mov    %eax,(%esp)
8010481f:	e8 bc ce ff ff       	call   801016e0 <ilock>
	ip->major = major;
80104824:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104828:	66 89 46 52          	mov    %ax,0x52(%esi)
	ip->minor = minor;
8010482c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104830:	66 89 46 54          	mov    %ax,0x54(%esi)
	ip->nlink = 1;
80104834:	b8 01 00 00 00       	mov    $0x1,%eax
80104839:	66 89 46 56          	mov    %ax,0x56(%esi)
	iupdate(ip);
8010483d:	89 34 24             	mov    %esi,(%esp)
80104840:	e8 db cd ff ff       	call   80101620 <iupdate>

	if(type == T_DIR){  // Create . and .. entries.
80104845:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010484a:	74 34                	je     80104880 <create+0x110>
		// No ip->nlink++ for ".": avoid cyclic ref count.
		if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
			panic("create dots");
	}

	if(dirlink(dp, name, ip->inum) < 0)
8010484c:	8b 46 04             	mov    0x4(%esi),%eax
8010484f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104853:	89 3c 24             	mov    %edi,(%esp)
80104856:	89 44 24 08          	mov    %eax,0x8(%esp)
8010485a:	e8 41 d6 ff ff       	call   80101ea0 <dirlink>
8010485f:	85 c0                	test   %eax,%eax
80104861:	78 6c                	js     801048cf <create+0x15f>
		panic("create: dirlink");

	iunlockput(dp);
80104863:	89 3c 24             	mov    %edi,(%esp)
80104866:	e8 25 d1 ff ff       	call   80101990 <iunlockput>

	return ip;
}
8010486b:	83 c4 4c             	add    $0x4c,%esp
	if(dirlink(dp, name, ip->inum) < 0)
		panic("create: dirlink");

	iunlockput(dp);

	return ip;
8010486e:	89 f0                	mov    %esi,%eax
}
80104870:	5b                   	pop    %ebx
80104871:	5e                   	pop    %esi
80104872:	5f                   	pop    %edi
80104873:	5d                   	pop    %ebp
80104874:	c3                   	ret    
80104875:	8d 76 00             	lea    0x0(%esi),%esi
	uint off;
	struct inode *ip, *dp;
	char name[DIRSIZ];

	if((dp = nameiparent(path, name)) == 0)
		return 0;
80104878:	31 c0                	xor    %eax,%eax
8010487a:	e9 60 ff ff ff       	jmp    801047df <create+0x6f>
8010487f:	90                   	nop
	ip->minor = minor;
	ip->nlink = 1;
	iupdate(ip);

	if(type == T_DIR){  // Create . and .. entries.
		dp->nlink++;  // for ".."
80104880:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
		iupdate(dp);
80104885:	89 3c 24             	mov    %edi,(%esp)
80104888:	e8 93 cd ff ff       	call   80101620 <iupdate>
		// No ip->nlink++ for ".": avoid cyclic ref count.
		if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010488d:	8b 46 04             	mov    0x4(%esi),%eax
80104890:	c7 44 24 04 4c 7d 10 	movl   $0x80107d4c,0x4(%esp)
80104897:	80 
80104898:	89 34 24             	mov    %esi,(%esp)
8010489b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010489f:	e8 fc d5 ff ff       	call   80101ea0 <dirlink>
801048a4:	85 c0                	test   %eax,%eax
801048a6:	78 1b                	js     801048c3 <create+0x153>
801048a8:	8b 47 04             	mov    0x4(%edi),%eax
801048ab:	c7 44 24 04 4b 7d 10 	movl   $0x80107d4b,0x4(%esp)
801048b2:	80 
801048b3:	89 34 24             	mov    %esi,(%esp)
801048b6:	89 44 24 08          	mov    %eax,0x8(%esp)
801048ba:	e8 e1 d5 ff ff       	call   80101ea0 <dirlink>
801048bf:	85 c0                	test   %eax,%eax
801048c1:	79 89                	jns    8010484c <create+0xdc>
			panic("create dots");
801048c3:	c7 04 24 3f 7d 10 80 	movl   $0x80107d3f,(%esp)
801048ca:	e8 91 ba ff ff       	call   80100360 <panic>
	}

	if(dirlink(dp, name, ip->inum) < 0)
		panic("create: dirlink");
801048cf:	c7 04 24 4e 7d 10 80 	movl   $0x80107d4e,(%esp)
801048d6:	e8 85 ba ff ff       	call   80100360 <panic>
		iunlockput(ip);
		return 0;
	}

	if((ip = ialloc(dp->dev, type)) == 0)
		panic("create: ialloc");
801048db:	c7 04 24 30 7d 10 80 	movl   $0x80107d30,(%esp)
801048e2:	e8 79 ba ff ff       	call   80100360 <panic>
801048e7:	89 f6                	mov    %esi,%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048f0 <argfd.constprop.0>:
}

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	89 c6                	mov    %eax,%esi
801048f6:	53                   	push   %ebx
801048f7:	89 d3                	mov    %edx,%ebx
801048f9:	83 ec 20             	sub    $0x20,%esp
{
	int fd;
	struct file *f;

	if(argint(n, &fd) < 0)
801048fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80104903:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010490a:	e8 e1 fc ff ff       	call   801045f0 <argint>
8010490f:	85 c0                	test   %eax,%eax
80104911:	78 2d                	js     80104940 <argfd.constprop.0+0x50>
		return -1;
	if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104913:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104917:	77 27                	ja     80104940 <argfd.constprop.0+0x50>
80104919:	e8 02 ee ff ff       	call   80103720 <myproc>
8010491e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104921:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104925:	85 c0                	test   %eax,%eax
80104927:	74 17                	je     80104940 <argfd.constprop.0+0x50>
		return -1;
	if(pfd)
80104929:	85 f6                	test   %esi,%esi
8010492b:	74 02                	je     8010492f <argfd.constprop.0+0x3f>
		*pfd = fd;
8010492d:	89 16                	mov    %edx,(%esi)
	if(pf)
8010492f:	85 db                	test   %ebx,%ebx
80104931:	74 1d                	je     80104950 <argfd.constprop.0+0x60>
		*pf = f;
80104933:	89 03                	mov    %eax,(%ebx)
	return 0;
80104935:	31 c0                	xor    %eax,%eax
}
80104937:	83 c4 20             	add    $0x20,%esp
8010493a:	5b                   	pop    %ebx
8010493b:	5e                   	pop    %esi
8010493c:	5d                   	pop    %ebp
8010493d:	c3                   	ret    
8010493e:	66 90                	xchg   %ax,%ax
80104940:	83 c4 20             	add    $0x20,%esp
{
	int fd;
	struct file *f;

	if(argint(n, &fd) < 0)
		return -1;
80104943:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(pfd)
		*pfd = fd;
	if(pf)
		*pf = f;
	return 0;
}
80104948:	5b                   	pop    %ebx
80104949:	5e                   	pop    %esi
8010494a:	5d                   	pop    %ebp
8010494b:	c3                   	ret    
8010494c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return -1;
	if(pfd)
		*pfd = fd;
	if(pf)
		*pf = f;
	return 0;
80104950:	31 c0                	xor    %eax,%eax
80104952:	eb e3                	jmp    80104937 <argfd.constprop.0+0x47>
80104954:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010495a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104960 <fixDir>:
	}

	return 1;
}

void fixDir(int dirIndex, int parentIndex){
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
80104965:	83 ec 10             	sub    $0x10,%esp
80104968:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010496b:	8b 75 0c             	mov    0xc(%ebp),%esi
	begin_op();
8010496e:	e8 1d e2 ff ff       	call   80102b90 <begin_op>
	struct inode* dirPointer;
	struct inode* dirParentPointer;
	dirPointer = igetCaller(dirIndex);
80104973:	89 1c 24             	mov    %ebx,(%esp)
80104976:	e8 25 ca ff ff       	call   801013a0 <igetCaller>
	dirParentPointer = igetCaller(parentIndex);
8010497b:	89 34 24             	mov    %esi,(%esp)

void fixDir(int dirIndex, int parentIndex){
	begin_op();
	struct inode* dirPointer;
	struct inode* dirParentPointer;
	dirPointer = igetCaller(dirIndex);
8010497e:	89 c3                	mov    %eax,%ebx
	dirParentPointer = igetCaller(parentIndex);
80104980:	e8 1b ca ff ff       	call   801013a0 <igetCaller>
80104985:	89 c6                	mov    %eax,%esi
	dirlink(dirPointer,".",dirPointer->inum);
80104987:	8b 43 04             	mov    0x4(%ebx),%eax
8010498a:	89 1c 24             	mov    %ebx,(%esp)
8010498d:	c7 44 24 04 4c 7d 10 	movl   $0x80107d4c,0x4(%esp)
80104994:	80 
80104995:	89 44 24 08          	mov    %eax,0x8(%esp)
80104999:	e8 02 d5 ff ff       	call   80101ea0 <dirlink>
	dirlink(dirPointer,"..",dirParentPointer->inum);
8010499e:	8b 46 04             	mov    0x4(%esi),%eax
801049a1:	89 1c 24             	mov    %ebx,(%esp)
801049a4:	c7 44 24 04 4b 7d 10 	movl   $0x80107d4b,0x4(%esp)
801049ab:	80 
801049ac:	89 44 24 08          	mov    %eax,0x8(%esp)
801049b0:	e8 eb d4 ff ff       	call   80101ea0 <dirlink>
	end_op();
}
801049b5:	83 c4 10             	add    $0x10,%esp
801049b8:	5b                   	pop    %ebx
801049b9:	5e                   	pop    %esi
801049ba:	5d                   	pop    %ebp
	struct inode* dirParentPointer;
	dirPointer = igetCaller(dirIndex);
	dirParentPointer = igetCaller(parentIndex);
	dirlink(dirPointer,".",dirPointer->inum);
	dirlink(dirPointer,"..",dirParentPointer->inum);
	end_op();
801049bb:	e9 40 e2 ff ff       	jmp    80102c00 <end_op>

801049c0 <reverse>:
	}
	return similarity;
}

void reverse(char s[])
 {
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
801049c5:	83 ec 10             	sub    $0x10,%esp
801049c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
801049cb:	89 1c 24             	mov    %ebx,(%esp)
801049ce:	e8 4d fb ff ff       	call   80104520 <strlen>
801049d3:	31 d2                	xor    %edx,%edx
801049d5:	83 e8 01             	sub    $0x1,%eax
801049d8:	85 c0                	test   %eax,%eax
801049da:	7e 1e                	jle    801049fa <reverse+0x3a>
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
         c = s[i];
801049e0:	0f b6 34 13          	movzbl (%ebx,%edx,1),%esi
         s[i] = s[j];
801049e4:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
801049e8:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
         s[j] = c;
801049eb:	89 f1                	mov    %esi,%ecx
void reverse(char s[])
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
801049ed:	83 c2 01             	add    $0x1,%edx
         c = s[i];
         s[i] = s[j];
         s[j] = c;
801049f0:	88 0c 03             	mov    %cl,(%ebx,%eax,1)
void reverse(char s[])
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
801049f3:	83 e8 01             	sub    $0x1,%eax
801049f6:	39 c2                	cmp    %eax,%edx
801049f8:	7c e6                	jl     801049e0 <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }

 }
801049fa:	83 c4 10             	add    $0x10,%esp
801049fd:	5b                   	pop    %ebx
801049fe:	5e                   	pop    %esi
801049ff:	5d                   	pop    %ebp
80104a00:	c3                   	ret    
80104a01:	eb 0d                	jmp    80104a10 <itoa>
80104a03:	90                   	nop
80104a04:	90                   	nop
80104a05:	90                   	nop
80104a06:	90                   	nop
80104a07:	90                   	nop
80104a08:	90                   	nop
80104a09:	90                   	nop
80104a0a:	90                   	nop
80104a0b:	90                   	nop
80104a0c:	90                   	nop
80104a0d:	90                   	nop
80104a0e:	90                   	nop
80104a0f:	90                   	nop

80104a10 <itoa>:

 void itoa(int n, char s[])
 {
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	57                   	push   %edi
80104a14:	56                   	push   %esi
80104a15:	31 f6                	xor    %esi,%esi
80104a17:	53                   	push   %ebx
80104a18:	83 ec 10             	sub    $0x10,%esp
80104a1b:	8b 45 08             	mov    0x8(%ebp),%eax
80104a1e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a21:	89 c1                	mov    %eax,%ecx
80104a23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104a26:	c1 f8 1f             	sar    $0x1f,%eax
80104a29:	31 c1                	xor    %eax,%ecx
80104a2b:	29 c1                	sub    %eax,%ecx
80104a2d:	eb 03                	jmp    80104a32 <itoa+0x22>
80104a2f:	90                   	nop

     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
80104a30:	89 de                	mov    %ebx,%esi
80104a32:	b8 67 66 66 66       	mov    $0x66666667,%eax
80104a37:	f7 e9                	imul   %ecx
80104a39:	89 c8                	mov    %ecx,%eax
80104a3b:	c1 f8 1f             	sar    $0x1f,%eax
80104a3e:	8d 5e 01             	lea    0x1(%esi),%ebx
80104a41:	c1 fa 02             	sar    $0x2,%edx
80104a44:	29 c2                	sub    %eax,%edx
80104a46:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104a49:	01 c0                	add    %eax,%eax
80104a4b:	29 c1                	sub    %eax,%ecx
80104a4d:	83 c1 30             	add    $0x30,%ecx
     } while ((n /= 10) > 0);     /* delete it */
80104a50:	85 d2                	test   %edx,%edx

     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
80104a52:	88 4c 1f ff          	mov    %cl,-0x1(%edi,%ebx,1)
     } while ((n /= 10) > 0);     /* delete it */
80104a56:	89 d1                	mov    %edx,%ecx
80104a58:	75 d6                	jne    80104a30 <itoa+0x20>
     if (sign < 0)
80104a5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx

     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
80104a5d:	89 d8                	mov    %ebx,%eax
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
80104a5f:	85 d2                	test   %edx,%edx
80104a61:	79 07                	jns    80104a6a <itoa+0x5a>
         s[i++] = '-';
80104a63:	8d 5e 02             	lea    0x2(%esi),%ebx
80104a66:	c6 04 07 2d          	movb   $0x2d,(%edi,%eax,1)
     s[i] = '\0';
80104a6a:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
     reverse(s);
80104a6e:	89 7d 08             	mov    %edi,0x8(%ebp)
 }
80104a71:	83 c4 10             	add    $0x10,%esp
80104a74:	5b                   	pop    %ebx
80104a75:	5e                   	pop    %esi
80104a76:	5f                   	pop    %edi
80104a77:	5d                   	pop    %ebp
         s[i++] = n % 10 + '0';   /* get next digit */
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
80104a78:	e9 43 ff ff ff       	jmp    801049c0 <reverse>
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi

80104a80 <fixFile>:
	dirlink(dirPointer,".",dirPointer->inum);
	dirlink(dirPointer,"..",dirParentPointer->inum);
	end_op();
}

void fixFile(int inum){
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	57                   	push   %edi
80104a84:	56                   	push   %esi
80104a85:	53                   	push   %ebx
80104a86:	83 ec 3c             	sub    $0x3c,%esp
80104a89:	8b 75 08             	mov    0x8(%ebp),%esi
	begin_op();
	struct inode* ip;
	char newName[14] = {0};
80104a8c:	8d 5d da             	lea    -0x26(%ebp),%ebx
	dirlink(dirPointer,"..",dirParentPointer->inum);
	end_op();
}

void fixFile(int inum){
	begin_op();
80104a8f:	e8 fc e0 ff ff       	call   80102b90 <begin_op>
	struct inode* ip;
	char newName[14] = {0};
80104a94:	31 c0                	xor    %eax,%eax
     reverse(s);
 }

void strcat(char* s1, const char* s2){
  while (*s1) ++s1;
  while (*s2) *s1++ = *s2++;
80104a96:	b9 74 00 00 00       	mov    $0x74,%ecx
}

void fixFile(int inum){
	begin_op();
	struct inode* ip;
	char newName[14] = {0};
80104a9b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
80104a9f:	ba 5e 7d 10 80       	mov    $0x80107d5e,%edx
80104aa4:	89 d8                	mov    %ebx,%eax
80104aa6:	c7 45 da 00 00 00 00 	movl   $0x0,-0x26(%ebp)
80104aad:	c7 45 de 00 00 00 00 	movl   $0x0,-0x22(%ebp)
80104ab4:	c7 45 e2 00 00 00 00 	movl   $0x0,-0x1e(%ebp)
80104abb:	90                   	nop
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     reverse(s);
 }

void strcat(char* s1, const char* s2){
  while (*s1) ++s1;
  while (*s2) *s1++ = *s2++;
80104ac0:	83 c0 01             	add    $0x1,%eax
80104ac3:	83 c2 01             	add    $0x1,%edx
80104ac6:	88 48 ff             	mov    %cl,-0x1(%eax)
80104ac9:	0f b6 0a             	movzbl (%edx),%ecx
80104acc:	84 c9                	test   %cl,%cl
80104ace:	75 f0                	jne    80104ac0 <fixFile+0x40>
	begin_op();
	struct inode* ip;
	char newName[14] = {0};
	strcat(newName,"tmp_");
	char tmpNum[4];
	itoa(inum,tmpNum);
80104ad0:	8d 7d d6             	lea    -0x2a(%ebp),%edi
 }

void strcat(char* s1, const char* s2){
  while (*s1) ++s1;
  while (*s2) *s1++ = *s2++;
  *s1 = 0;
80104ad3:	c6 00 00             	movb   $0x0,(%eax)
	begin_op();
	struct inode* ip;
	char newName[14] = {0};
	strcat(newName,"tmp_");
	char tmpNum[4];
	itoa(inum,tmpNum);
80104ad6:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104ada:	89 34 24             	mov    %esi,(%esp)
80104add:	e8 2e ff ff ff       	call   80104a10 <itoa>
     s[i] = '\0';
     reverse(s);
 }

void strcat(char* s1, const char* s2){
  while (*s1) ++s1;
80104ae2:	89 d8                	mov    %ebx,%eax
80104ae4:	80 7d da 00          	cmpb   $0x0,-0x26(%ebp)
80104ae8:	74 0e                	je     80104af8 <fixFile+0x78>
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104af0:	83 c0 01             	add    $0x1,%eax
80104af3:	80 38 00             	cmpb   $0x0,(%eax)
80104af6:	75 f8                	jne    80104af0 <fixFile+0x70>
  while (*s2) *s1++ = *s2++;
80104af8:	0f b6 55 d6          	movzbl -0x2a(%ebp),%edx
80104afc:	84 d2                	test   %dl,%dl
80104afe:	74 18                	je     80104b18 <fixFile+0x98>
80104b00:	89 f9                	mov    %edi,%ecx
80104b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b08:	83 c0 01             	add    $0x1,%eax
80104b0b:	83 c1 01             	add    $0x1,%ecx
80104b0e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104b11:	0f b6 11             	movzbl (%ecx),%edx
80104b14:	84 d2                	test   %dl,%dl
80104b16:	75 f0                	jne    80104b08 <fixFile+0x88>
  *s1 = 0;
80104b18:	c6 00 00             	movb   $0x0,(%eax)
	char newName[14] = {0};
	strcat(newName,"tmp_");
	char tmpNum[4];
	itoa(inum,tmpNum);
	strcat(newName,tmpNum);
	ip = igetCaller(1);
80104b1b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b22:	e8 79 c8 ff ff       	call   801013a0 <igetCaller>
80104b27:	89 c7                	mov    %eax,%edi
	ilock(ip);
80104b29:	89 04 24             	mov    %eax,(%esp)
80104b2c:	e8 af cb ff ff       	call   801016e0 <ilock>
	dirlink(ip,newName,inum);
80104b31:	89 74 24 08          	mov    %esi,0x8(%esp)
80104b35:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104b39:	89 3c 24             	mov    %edi,(%esp)
80104b3c:	e8 5f d3 ff ff       	call   80101ea0 <dirlink>
	iunlock(ip);
80104b41:	89 3c 24             	mov    %edi,(%esp)
80104b44:	e8 77 cc ff ff       	call   801017c0 <iunlock>
	end_op();
80104b49:	e8 b2 e0 ff ff       	call   80102c00 <end_op>
}
80104b4e:	83 c4 3c             	add    $0x3c,%esp
80104b51:	5b                   	pop    %ebx
80104b52:	5e                   	pop    %esi
80104b53:	5f                   	pop    %edi
80104b54:	5d                   	pop    %ebp
80104b55:	c3                   	ret    
80104b56:	8d 76 00             	lea    0x0(%esi),%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <sys_recoverFS>:
struct superblock sb;
int inodeLinkLog[200];
int inodeTBWalkerLinkLog[200];
int corruptDirs[200];

int sys_recoverFS(){
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	53                   	push   %ebx
	int inodeIndex;
	for(inodeIndex=2;inodeIndex<200; inodeIndex++){
80104b64:	bb 02 00 00 00       	mov    $0x2,%ebx
struct superblock sb;
int inodeLinkLog[200];
int inodeTBWalkerLinkLog[200];
int corruptDirs[200];

int sys_recoverFS(){
80104b69:	83 ec 14             	sub    $0x14,%esp
80104b6c:	eb 0d                	jmp    80104b7b <sys_recoverFS+0x1b>
80104b6e:	66 90                	xchg   %ax,%ax
	int inodeIndex;
	for(inodeIndex=2;inodeIndex<200; inodeIndex++){
80104b70:	83 c3 01             	add    $0x1,%ebx
80104b73:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
80104b79:	74 35                	je     80104bb0 <sys_recoverFS+0x50>
		if(corruptDirs[inodeIndex] != 0){
80104b7b:	8b 04 9d 60 5c 11 80 	mov    -0x7feea3a0(,%ebx,4),%eax
80104b82:	85 c0                	test   %eax,%eax
80104b84:	74 ea                	je     80104b70 <sys_recoverFS+0x10>
			cprintf("FIXING A PROBLEM\n");
80104b86:	c7 04 24 63 7d 10 80 	movl   $0x80107d63,(%esp)
80104b8d:	e8 be ba ff ff       	call   80100650 <cprintf>
			fixDir(inodeIndex, corruptDirs[inodeIndex]);
80104b92:	8b 04 9d 60 5c 11 80 	mov    -0x7feea3a0(,%ebx,4),%eax
80104b99:	89 1c 24             	mov    %ebx,(%esp)
int inodeTBWalkerLinkLog[200];
int corruptDirs[200];

int sys_recoverFS(){
	int inodeIndex;
	for(inodeIndex=2;inodeIndex<200; inodeIndex++){
80104b9c:	83 c3 01             	add    $0x1,%ebx
		if(corruptDirs[inodeIndex] != 0){
			cprintf("FIXING A PROBLEM\n");
			fixDir(inodeIndex, corruptDirs[inodeIndex]);
80104b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ba3:	e8 b8 fd ff ff       	call   80104960 <fixDir>
int inodeTBWalkerLinkLog[200];
int corruptDirs[200];

int sys_recoverFS(){
	int inodeIndex;
	for(inodeIndex=2;inodeIndex<200; inodeIndex++){
80104ba8:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
80104bae:	75 cb                	jne    80104b7b <sys_recoverFS+0x1b>
80104bb0:	b3 02                	mov    $0x2,%bl
80104bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			cprintf("FIXING A PROBLEM\n");
			fixDir(inodeIndex, corruptDirs[inodeIndex]);
		}
	}
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
		if(inodeLinkLog[inodeIndex] != inodeTBWalkerLinkLog[inodeIndex]){
80104bb8:	8b 04 9d a0 62 11 80 	mov    -0x7fee9d60(,%ebx,4),%eax
80104bbf:	39 04 9d 80 5f 11 80 	cmp    %eax,-0x7feea080(,%ebx,4)
80104bc6:	74 14                	je     80104bdc <sys_recoverFS+0x7c>
			cprintf("FIXING A PROBLEM\n");
80104bc8:	c7 04 24 63 7d 10 80 	movl   $0x80107d63,(%esp)
80104bcf:	e8 7c ba ff ff       	call   80100650 <cprintf>
			fixFile(inodeIndex);
80104bd4:	89 1c 24             	mov    %ebx,(%esp)
80104bd7:	e8 a4 fe ff ff       	call   80104a80 <fixFile>
		if(corruptDirs[inodeIndex] != 0){
			cprintf("FIXING A PROBLEM\n");
			fixDir(inodeIndex, corruptDirs[inodeIndex]);
		}
	}
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
80104bdc:	83 c3 01             	add    $0x1,%ebx
80104bdf:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
80104be5:	75 d1                	jne    80104bb8 <sys_recoverFS+0x58>
80104be7:	31 c0                	xor    %eax,%eax
80104be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		}
	}
	// Clear arrays, everything should be fixed now
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeLinkLog[inodeNum]=0;
80104bf0:	c7 04 85 80 5f 11 80 	movl   $0x0,-0x7feea080(,%eax,4)
80104bf7:	00 00 00 00 
			fixFile(inodeIndex);
		}
	}
	// Clear arrays, everything should be fixed now
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80104bfb:	83 c0 01             	add    $0x1,%eax
80104bfe:	3d c8 00 00 00       	cmp    $0xc8,%eax
80104c03:	75 eb                	jne    80104bf0 <sys_recoverFS+0x90>
80104c05:	30 c0                	xor    %al,%al
80104c07:	90                   	nop
		inodeLinkLog[inodeNum]=0;
	}
	inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		corruptDirs[inodeNum]=0;
80104c08:	c7 04 85 60 5c 11 80 	movl   $0x0,-0x7feea3a0(,%eax,4)
80104c0f:	00 00 00 00 
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeLinkLog[inodeNum]=0;
	}
	inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80104c13:	83 c0 01             	add    $0x1,%eax
80104c16:	3d c8 00 00 00       	cmp    $0xc8,%eax
80104c1b:	75 eb                	jne    80104c08 <sys_recoverFS+0xa8>
		corruptDirs[inodeNum]=0;
	}

	return 1;
}
80104c1d:	83 c4 14             	add    $0x14,%esp
80104c20:	b0 01                	mov    $0x1,%al
80104c22:	5b                   	pop    %ebx
80104c23:	5d                   	pop    %ebp
80104c24:	c3                   	ret    
80104c25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <strcat>:
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
 }

void strcat(char* s1, const char* s2){
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	8b 45 08             	mov    0x8(%ebp),%eax
80104c36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while (*s1) ++s1;
80104c39:	80 38 00             	cmpb   $0x0,(%eax)
80104c3c:	74 1b                	je     80104c59 <strcat+0x29>
80104c3e:	66 90                	xchg   %ax,%ax
80104c40:	83 c0 01             	add    $0x1,%eax
80104c43:	80 38 00             	cmpb   $0x0,(%eax)
80104c46:	75 f8                	jne    80104c40 <strcat+0x10>
  while (*s2) *s1++ = *s2++;
80104c48:	0f b6 11             	movzbl (%ecx),%edx
80104c4b:	84 d2                	test   %dl,%dl
80104c4d:	74 11                	je     80104c60 <strcat+0x30>
80104c4f:	90                   	nop
80104c50:	83 c0 01             	add    $0x1,%eax
80104c53:	83 c1 01             	add    $0x1,%ecx
80104c56:	88 50 ff             	mov    %dl,-0x1(%eax)
80104c59:	0f b6 11             	movzbl (%ecx),%edx
80104c5c:	84 d2                	test   %dl,%dl
80104c5e:	75 f0                	jne    80104c50 <strcat+0x20>
  *s1 = 0;
80104c60:	c6 00 00             	movb   $0x0,(%eax)
}
80104c63:	5d                   	pop    %ebp
80104c64:	c3                   	ret    
80104c65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <strcmp>:

int strcmp(const char* s1, char* s2)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c76:	53                   	push   %ebx
80104c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
80104c7a:	0f b6 01             	movzbl (%ecx),%eax
80104c7d:	84 c0                	test   %al,%al
80104c7f:	75 18                	jne    80104c99 <strcmp+0x29>
80104c81:	eb 25                	jmp    80104ca8 <strcmp+0x38>
80104c83:	90                   	nop
80104c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c88:	38 d8                	cmp    %bl,%al
80104c8a:	75 14                	jne    80104ca0 <strcmp+0x30>
80104c8c:	83 c1 01             	add    $0x1,%ecx
80104c8f:	0f b6 01             	movzbl (%ecx),%eax
80104c92:	83 c2 01             	add    $0x1,%edx
80104c95:	84 c0                	test   %al,%al
80104c97:	74 0f                	je     80104ca8 <strcmp+0x38>
80104c99:	0f b6 1a             	movzbl (%edx),%ebx
80104c9c:	84 db                	test   %bl,%bl
80104c9e:	75 e8                	jne    80104c88 <strcmp+0x18>
  return *(unsigned char*)s1-*(unsigned char*)s2;
80104ca0:	0f b6 12             	movzbl (%edx),%edx
}
80104ca3:	5b                   	pop    %ebx
80104ca4:	5d                   	pop    %ebp
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
  return *(unsigned char*)s1-*(unsigned char*)s2;
80104ca5:	29 d0                	sub    %edx,%eax
}
80104ca7:	c3                   	ret    
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
  return *(unsigned char*)s1-*(unsigned char*)s2;
80104ca8:	0f b6 12             	movzbl (%edx),%edx
80104cab:	31 c0                	xor    %eax,%eax
}
80104cad:	5b                   	pop    %ebx
80104cae:	5d                   	pop    %ebp
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
  return *(unsigned char*)s1-*(unsigned char*)s2;
80104caf:	29 d0                	sub    %edx,%eax
}
80104cb1:	c3                   	ret    
80104cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <resetArrays>:
void resetArrays(){
80104cc0:	55                   	push   %ebp
	// initialize link log
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80104cc1:	31 c0                	xor    %eax,%eax
int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
  return *(unsigned char*)s1-*(unsigned char*)s2;
}
void resetArrays(){
80104cc3:	89 e5                	mov    %esp,%ebp
80104cc5:	8d 76 00             	lea    0x0(%esi),%esi
	// initialize link log
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeLinkLog[inodeNum]=0;
80104cc8:	c7 04 85 80 5f 11 80 	movl   $0x0,-0x7feea080(,%eax,4)
80104ccf:	00 00 00 00 
  return *(unsigned char*)s1-*(unsigned char*)s2;
}
void resetArrays(){
	// initialize link log
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80104cd3:	83 c0 01             	add    $0x1,%eax
80104cd6:	3d c8 00 00 00       	cmp    $0xc8,%eax
80104cdb:	75 eb                	jne    80104cc8 <resetArrays+0x8>
80104cdd:	30 c0                	xor    %al,%al
80104cdf:	90                   	nop
		inodeLinkLog[inodeNum]=0;
	}
	// initialize corrupt directory log
	inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		corruptDirs[inodeNum]=0;
80104ce0:	c7 04 85 60 5c 11 80 	movl   $0x0,-0x7feea3a0(,%eax,4)
80104ce7:	00 00 00 00 
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeLinkLog[inodeNum]=0;
	}
	// initialize corrupt directory log
	inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80104ceb:	83 c0 01             	add    $0x1,%eax
80104cee:	3d c8 00 00 00       	cmp    $0xc8,%eax
80104cf3:	75 eb                	jne    80104ce0 <resetArrays+0x20>
		corruptDirs[inodeNum]=0;
	}
}
80104cf5:	5d                   	pop    %ebp
80104cf6:	c3                   	ret    
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d00 <directoryWalkerSubRoutine>:
//	for(inodeNum = 0; inodeNum<30;inodeNum++){
//		cprintf("%d",corruptDirs[inodeNum]);
//	}
	return 0;
}
void directoryWalkerSubRoutine(char* path){
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
80104d05:	53                   	push   %ebx
80104d06:	83 ec 4c             	sub    $0x4c,%esp

	uint off;
	struct dirent de;
	struct inode * ip = namei(path);
80104d09:	8b 45 08             	mov    0x8(%ebp),%eax
80104d0c:	89 04 24             	mov    %eax,(%esp)
80104d0f:	e8 6c d2 ff ff       	call   80101f80 <namei>
	if(!ip){
80104d14:	85 c0                	test   %eax,%eax
}
void directoryWalkerSubRoutine(char* path){

	uint off;
	struct dirent de;
	struct inode * ip = namei(path);
80104d16:	89 c7                	mov    %eax,%edi
	if(!ip){
80104d18:	0f 84 61 02 00 00    	je     80104f7f <directoryWalkerSubRoutine+0x27f>
		panic("Invalid File Path");
	}
	begin_op();
80104d1e:	e8 6d de ff ff       	call   80102b90 <begin_op>
	ilock(ip);
80104d23:	89 3c 24             	mov    %edi,(%esp)
80104d26:	e8 b5 c9 ff ff       	call   801016e0 <ilock>
	if(ip->type == T_DIR){
80104d2b:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80104d30:	0f 85 fa 01 00 00    	jne    80104f30 <directoryWalkerSubRoutine+0x230>
		// The specified path is a directory, go through its directory entries
		for(off = 0; off < ip->size; off += sizeof(de)){
80104d36:	8b 4f 58             	mov    0x58(%edi),%ecx
80104d39:	85 c9                	test   %ecx,%ecx
80104d3b:	0f 84 ef 01 00 00    	je     80104f30 <directoryWalkerSubRoutine+0x230>
80104d41:	31 f6                	xor    %esi,%esi
80104d43:	eb 0f                	jmp    80104d54 <directoryWalkerSubRoutine+0x54>
80104d45:	8d 76 00             	lea    0x0(%esi),%esi
80104d48:	83 c6 10             	add    $0x10,%esi
80104d4b:	39 77 58             	cmp    %esi,0x58(%edi)
80104d4e:	0f 86 dc 01 00 00    	jbe    80104f30 <directoryWalkerSubRoutine+0x230>
			if(readi(ip, (char*)&de, off, sizeof(de)) != sizeof(de)){
80104d54:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104d57:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d5e:	00 
80104d5f:	89 74 24 08          	mov    %esi,0x8(%esp)
80104d63:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d67:	89 3c 24             	mov    %edi,(%esp)
80104d6a:	e8 71 cc ff ff       	call   801019e0 <readi>
80104d6f:	83 f8 10             	cmp    $0x10,%eax
80104d72:	0f 85 fb 01 00 00    	jne    80104f73 <directoryWalkerSubRoutine+0x273>
				// Reading was not successful
				panic("dirlookup read");
			}
			if(off==0 && (strcmp(de.name,"."))){
80104d78:	85 f6                	test   %esi,%esi
80104d7a:	75 70                	jne    80104dec <directoryWalkerSubRoutine+0xec>
  *s1 = 0;
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
80104d7c:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
80104d80:	84 c0                	test   %al,%al
80104d82:	0f 84 bd 01 00 00    	je     80104f45 <directoryWalkerSubRoutine+0x245>
80104d88:	0f b6 55 db          	movzbl -0x25(%ebp),%edx
80104d8c:	3c 2e                	cmp    $0x2e,%al
80104d8e:	b9 4d 7d 10 80       	mov    $0x80107d4d,%ecx
80104d93:	0f 45 d0             	cmovne %eax,%edx
80104d96:	b8 4c 7d 10 80       	mov    $0x80107d4c,%eax
80104d9b:	0f 45 c8             	cmovne %eax,%ecx
		for(off = 0; off < ip->size; off += sizeof(de)){
			if(readi(ip, (char*)&de, off, sizeof(de)) != sizeof(de)){
				// Reading was not successful
				panic("dirlookup read");
			}
			if(off==0 && (strcmp(de.name,"."))){
80104d9e:	38 11                	cmp    %dl,(%ecx)
80104da0:	74 4a                	je     80104dec <directoryWalkerSubRoutine+0xec>
				struct inode* brokenDirParent;
				char name[14] = "..";
80104da2:	31 d2                	xor    %edx,%edx
				iunlock(ip);
80104da4:	89 3c 24             	mov    %edi,(%esp)
				// Reading was not successful
				panic("dirlookup read");
			}
			if(off==0 && (strcmp(de.name,"."))){
				struct inode* brokenDirParent;
				char name[14] = "..";
80104da7:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
80104dab:	c7 45 ca 2e 2e 00 00 	movl   $0x2e2e,-0x36(%ebp)
80104db2:	c7 45 ce 00 00 00 00 	movl   $0x0,-0x32(%ebp)
80104db9:	c7 45 d2 00 00 00 00 	movl   $0x0,-0x2e(%ebp)
				iunlock(ip);
80104dc0:	e8 fb c9 ff ff       	call   801017c0 <iunlock>
				// Found a corrupted directory, record its inode number and its parents inode number
				brokenDirParent = nameiparent(path,name);
80104dc5:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104dc8:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80104dcf:	89 04 24             	mov    %eax,(%esp)
80104dd2:	e8 c9 d1 ff ff       	call   80101fa0 <nameiparent>
//				if((brokenDirParent = nameiparent(path,name)) == 0){
//					ilock(ip);
//					continue;
//				}
				corruptDirs[ip->inum] = brokenDirParent->inum;
80104dd7:	8b 57 04             	mov    0x4(%edi),%edx
80104dda:	8b 40 04             	mov    0x4(%eax),%eax
				ilock(ip);
80104ddd:	89 3c 24             	mov    %edi,(%esp)
				brokenDirParent = nameiparent(path,name);
//				if((brokenDirParent = nameiparent(path,name)) == 0){
//					ilock(ip);
//					continue;
//				}
				corruptDirs[ip->inum] = brokenDirParent->inum;
80104de0:	89 04 95 60 5c 11 80 	mov    %eax,-0x7feea3a0(,%edx,4)
				ilock(ip);
80104de7:	e8 f4 c8 ff ff       	call   801016e0 <ilock>
			}

		    if(de.inum == 0){
80104dec:	0f b7 45 d8          	movzwl -0x28(%ebp),%eax
80104df0:	66 85 c0             	test   %ax,%ax
80104df3:	0f 84 4f ff ff ff    	je     80104d48 <directoryWalkerSubRoutine+0x48>
		      continue;
		    }

			cprintf("Name: %s \t inode#: %d\n",de.name,de.inum);
80104df9:	89 44 24 08          	mov    %eax,0x8(%esp)
80104dfd:	8d 45 da             	lea    -0x26(%ebp),%eax
80104e00:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e04:	c7 04 24 87 7d 10 80 	movl   $0x80107d87,(%esp)
80104e0b:	e8 40 b8 ff ff       	call   80100650 <cprintf>
  *s1 = 0;
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
80104e10:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
80104e14:	84 c0                	test   %al,%al
80104e16:	88 45 c7             	mov    %al,-0x39(%ebp)
80104e19:	0f 84 3a 01 00 00    	je     80104f59 <directoryWalkerSubRoutine+0x259>
80104e1f:	3c 2e                	cmp    $0x2e,%al
80104e21:	0f 85 3e 01 00 00    	jne    80104f65 <directoryWalkerSubRoutine+0x265>
80104e27:	80 7d db 00          	cmpb   $0x0,-0x25(%ebp)
		      continue;
		    }

			cprintf("Name: %s \t inode#: %d\n",de.name,de.inum);

			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
80104e2b:	b8 4b 7d 10 80       	mov    $0x80107d4b,%eax
80104e30:	8d 55 da             	lea    -0x26(%ebp),%edx
  *s1 = 0;
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
80104e33:	75 16                	jne    80104e4b <directoryWalkerSubRoutine+0x14b>
80104e35:	e9 0e ff ff ff       	jmp    80104d48 <directoryWalkerSubRoutine+0x48>
80104e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e40:	0f b6 18             	movzbl (%eax),%ebx
80104e43:	84 db                	test   %bl,%bl
80104e45:	74 13                	je     80104e5a <directoryWalkerSubRoutine+0x15a>
80104e47:	38 d9                	cmp    %bl,%cl
80104e49:	75 0f                	jne    80104e5a <directoryWalkerSubRoutine+0x15a>
80104e4b:	83 c2 01             	add    $0x1,%edx
80104e4e:	0f b6 0a             	movzbl (%edx),%ecx
80104e51:	83 c0 01             	add    $0x1,%eax
80104e54:	84 c9                	test   %cl,%cl
80104e56:	75 e8                	jne    80104e40 <directoryWalkerSubRoutine+0x140>
80104e58:	31 c9                	xor    %ecx,%ecx
		      continue;
		    }

			cprintf("Name: %s \t inode#: %d\n",de.name,de.inum);

			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
80104e5a:	38 08                	cmp    %cl,(%eax)
80104e5c:	0f 84 e6 fe ff ff    	je     80104d48 <directoryWalkerSubRoutine+0x48>
				continue;
			}
//			struct inode *dir_ip;
//			dir_ip = dirlookup(ip,de.name,0);
			inodeLinkLog[de.inum]++;
80104e62:	0f b7 45 d8          	movzwl -0x28(%ebp),%eax
			//if(dir_ip->type == T_DIR){
//			if(dir_ip->type){
				// we found a directory, recursively call
				char new_path[14] = {0};
80104e66:	c7 45 ca 00 00 00 00 	movl   $0x0,-0x36(%ebp)
80104e6d:	c7 45 ce 00 00 00 00 	movl   $0x0,-0x32(%ebp)
80104e74:	c7 45 d2 00 00 00 00 	movl   $0x0,-0x2e(%ebp)
			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
				continue;
			}
//			struct inode *dir_ip;
//			dir_ip = dirlookup(ip,de.name,0);
			inodeLinkLog[de.inum]++;
80104e7b:	83 04 85 80 5f 11 80 	addl   $0x1,-0x7feea080(,%eax,4)
80104e82:	01 
			//if(dir_ip->type == T_DIR){
//			if(dir_ip->type){
				// we found a directory, recursively call
				char new_path[14] = {0};
80104e83:	31 c0                	xor    %eax,%eax
80104e85:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
     reverse(s);
 }

void strcat(char* s1, const char* s2){
  while (*s1) ++s1;
  while (*s2) *s1++ = *s2++;
80104e89:	8b 45 08             	mov    0x8(%ebp),%eax
80104e8c:	0f b6 00             	movzbl (%eax),%eax
80104e8f:	84 c0                	test   %al,%al
80104e91:	0f 84 ba 00 00 00    	je     80104f51 <directoryWalkerSubRoutine+0x251>
80104e97:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e9a:	8d 55 ca             	lea    -0x36(%ebp),%edx
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ea0:	83 c2 01             	add    $0x1,%edx
80104ea3:	83 c1 01             	add    $0x1,%ecx
80104ea6:	88 42 ff             	mov    %al,-0x1(%edx)
80104ea9:	0f b6 01             	movzbl (%ecx),%eax
80104eac:	84 c0                	test   %al,%al
80104eae:	75 f0                	jne    80104ea0 <directoryWalkerSubRoutine+0x1a0>
  *s1 = 0;
80104eb0:	c6 02 00             	movb   $0x0,(%edx)
     s[i] = '\0';
     reverse(s);
 }

void strcat(char* s1, const char* s2){
  while (*s1) ++s1;
80104eb3:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104eb6:	80 7d ca 00          	cmpb   $0x0,-0x36(%ebp)
80104eba:	74 0c                	je     80104ec8 <directoryWalkerSubRoutine+0x1c8>
80104ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ec0:	83 c0 01             	add    $0x1,%eax
80104ec3:	80 38 00             	cmpb   $0x0,(%eax)
80104ec6:	75 f8                	jne    80104ec0 <directoryWalkerSubRoutine+0x1c0>
  while (*s2) *s1++ = *s2++;
80104ec8:	c6 00 2f             	movb   $0x2f,(%eax)
  *s1 = 0;
80104ecb:	c6 40 01 00          	movb   $0x0,0x1(%eax)
     s[i] = '\0';
     reverse(s);
 }

void strcat(char* s1, const char* s2){
  while (*s1) ++s1;
80104ecf:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104ed2:	80 7d ca 00          	cmpb   $0x0,-0x36(%ebp)
80104ed6:	74 08                	je     80104ee0 <directoryWalkerSubRoutine+0x1e0>
80104ed8:	83 c0 01             	add    $0x1,%eax
80104edb:	80 38 00             	cmpb   $0x0,(%eax)
80104ede:	75 f8                	jne    80104ed8 <directoryWalkerSubRoutine+0x1d8>
  while (*s2) *s1++ = *s2++;
80104ee0:	0f b6 4d c7          	movzbl -0x39(%ebp),%ecx
80104ee4:	84 c9                	test   %cl,%cl
80104ee6:	74 18                	je     80104f00 <directoryWalkerSubRoutine+0x200>
80104ee8:	8d 55 da             	lea    -0x26(%ebp),%edx
80104eeb:	90                   	nop
80104eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ef0:	83 c0 01             	add    $0x1,%eax
80104ef3:	83 c2 01             	add    $0x1,%edx
80104ef6:	88 48 ff             	mov    %cl,-0x1(%eax)
80104ef9:	0f b6 0a             	movzbl (%edx),%ecx
80104efc:	84 c9                	test   %cl,%cl
80104efe:	75 f0                	jne    80104ef0 <directoryWalkerSubRoutine+0x1f0>
  *s1 = 0;
80104f00:	c6 00 00             	movb   $0x0,(%eax)
	}
	begin_op();
	ilock(ip);
	if(ip->type == T_DIR){
		// The specified path is a directory, go through its directory entries
		for(off = 0; off < ip->size; off += sizeof(de)){
80104f03:	83 c6 10             	add    $0x10,%esi
				// we found a directory, recursively call
				char new_path[14] = {0};
				strcat(new_path,path);
				strcat(new_path,"/");
				strcat(new_path,de.name);
				iunlock(ip);
80104f06:	89 3c 24             	mov    %edi,(%esp)
80104f09:	e8 b2 c8 ff ff       	call   801017c0 <iunlock>
				directoryWalkerSubRoutine(new_path);
80104f0e:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104f11:	89 04 24             	mov    %eax,(%esp)
80104f14:	e8 e7 fd ff ff       	call   80104d00 <directoryWalkerSubRoutine>
				ilock(ip);
80104f19:	89 3c 24             	mov    %edi,(%esp)
80104f1c:	e8 bf c7 ff ff       	call   801016e0 <ilock>
	}
	begin_op();
	ilock(ip);
	if(ip->type == T_DIR){
		// The specified path is a directory, go through its directory entries
		for(off = 0; off < ip->size; off += sizeof(de)){
80104f21:	39 77 58             	cmp    %esi,0x58(%edi)
80104f24:	0f 87 2a fe ff ff    	ja     80104d54 <directoryWalkerSubRoutine+0x54>
80104f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				directoryWalkerSubRoutine(new_path);
				ilock(ip);
//			}
		}
	}
	iunlock(ip);
80104f30:	89 3c 24             	mov    %edi,(%esp)
80104f33:	e8 88 c8 ff ff       	call   801017c0 <iunlock>
	end_op();
80104f38:	e8 c3 dc ff ff       	call   80102c00 <end_op>
}
80104f3d:	83 c4 4c             	add    $0x4c,%esp
80104f40:	5b                   	pop    %ebx
80104f41:	5e                   	pop    %esi
80104f42:	5f                   	pop    %edi
80104f43:	5d                   	pop    %ebp
80104f44:	c3                   	ret    
  *s1 = 0;
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
80104f45:	31 d2                	xor    %edx,%edx
80104f47:	b9 4c 7d 10 80       	mov    $0x80107d4c,%ecx
80104f4c:	e9 4d fe ff ff       	jmp    80104d9e <directoryWalkerSubRoutine+0x9e>
     reverse(s);
 }

void strcat(char* s1, const char* s2){
  while (*s1) ++s1;
  while (*s2) *s1++ = *s2++;
80104f51:	8d 55 ca             	lea    -0x36(%ebp),%edx
80104f54:	e9 57 ff ff ff       	jmp    80104eb0 <directoryWalkerSubRoutine+0x1b0>
  *s1 = 0;
}

int strcmp(const char* s1, char* s2)
{
  for (; *s1 && *s2 && *s1==*s2; s1++, s2++);
80104f59:	31 c9                	xor    %ecx,%ecx
80104f5b:	b8 4b 7d 10 80       	mov    $0x80107d4b,%eax
80104f60:	e9 f5 fe ff ff       	jmp    80104e5a <directoryWalkerSubRoutine+0x15a>
80104f65:	0f b6 4d c7          	movzbl -0x39(%ebp),%ecx
		      continue;
		    }

			cprintf("Name: %s \t inode#: %d\n",de.name,de.inum);

			if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
80104f69:	b8 4b 7d 10 80       	mov    $0x80107d4b,%eax
80104f6e:	e9 e7 fe ff ff       	jmp    80104e5a <directoryWalkerSubRoutine+0x15a>
	if(ip->type == T_DIR){
		// The specified path is a directory, go through its directory entries
		for(off = 0; off < ip->size; off += sizeof(de)){
			if(readi(ip, (char*)&de, off, sizeof(de)) != sizeof(de)){
				// Reading was not successful
				panic("dirlookup read");
80104f73:	c7 04 24 39 77 10 80 	movl   $0x80107739,(%esp)
80104f7a:	e8 e1 b3 ff ff       	call   80100360 <panic>

	uint off;
	struct dirent de;
	struct inode * ip = namei(path);
	if(!ip){
		panic("Invalid File Path");
80104f7f:	c7 04 24 75 7d 10 80 	movl   $0x80107d75,(%esp)
80104f86:	e8 d5 b3 ff ff       	call   80100360 <panic>
80104f8b:	90                   	nop
80104f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f90 <sys_directoryWalker>:
	inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		corruptDirs[inodeNum]=0;
	}
}
int sys_directoryWalker(void){
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	83 ec 28             	sub    $0x28,%esp
	char *path;
	argstr(0,&path);
80104f96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f99:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fa4:	e8 d7 f6 ff ff       	call   80104680 <argstr>
	if(!path){
80104fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fac:	85 c0                	test   %eax,%eax
80104fae:	74 54                	je     80105004 <sys_directoryWalker+0x74>
		path = ".";
	}
	cprintf("path is %s\n",path);
80104fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fb4:	c7 04 24 9e 7d 10 80 	movl   $0x80107d9e,(%esp)
80104fbb:	e8 90 b6 ff ff       	call   80100650 <cprintf>
  return *(unsigned char*)s1-*(unsigned char*)s2;
}
void resetArrays(){
	// initialize link log
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80104fc0:	31 c0                	xor    %eax,%eax
80104fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		inodeLinkLog[inodeNum]=0;
80104fc8:	c7 04 85 80 5f 11 80 	movl   $0x0,-0x7feea080(,%eax,4)
80104fcf:	00 00 00 00 
  return *(unsigned char*)s1-*(unsigned char*)s2;
}
void resetArrays(){
	// initialize link log
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80104fd3:	83 c0 01             	add    $0x1,%eax
80104fd6:	3d c8 00 00 00       	cmp    $0xc8,%eax
80104fdb:	75 eb                	jne    80104fc8 <sys_directoryWalker+0x38>
80104fdd:	30 c0                	xor    %al,%al
80104fdf:	90                   	nop
		inodeLinkLog[inodeNum]=0;
	}
	// initialize corrupt directory log
	inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		corruptDirs[inodeNum]=0;
80104fe0:	c7 04 85 60 5c 11 80 	movl   $0x0,-0x7feea3a0(,%eax,4)
80104fe7:	00 00 00 00 
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeLinkLog[inodeNum]=0;
	}
	// initialize corrupt directory log
	inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80104feb:	83 c0 01             	add    $0x1,%eax
80104fee:	3d c8 00 00 00       	cmp    $0xc8,%eax
80104ff3:	75 eb                	jne    80104fe0 <sys_directoryWalker+0x50>
		path = ".";
	}
	cprintf("path is %s\n",path);
	resetArrays();
	// Call recursive subroutine
	directoryWalkerSubRoutine(path);
80104ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff8:	89 04 24             	mov    %eax,(%esp)
80104ffb:	e8 00 fd ff ff       	call   80104d00 <directoryWalkerSubRoutine>
//	cprintf("Printing broken directory/parent pairs\n");
//	for(inodeNum = 0; inodeNum<30;inodeNum++){
//		cprintf("%d",corruptDirs[inodeNum]);
//	}
	return 0;
}
80105000:	31 c0                	xor    %eax,%eax
80105002:	c9                   	leave  
80105003:	c3                   	ret    
}
int sys_directoryWalker(void){
	char *path;
	argstr(0,&path);
	if(!path){
		path = ".";
80105004:	c7 45 f4 4c 7d 10 80 	movl   $0x80107d4c,-0xc(%ebp)
8010500b:	b8 4c 7d 10 80       	mov    $0x80107d4c,%eax
80105010:	eb 9e                	jmp    80104fb0 <sys_directoryWalker+0x20>
80105012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <sys_inodeTBWalker>:
	end_op();
}

int sys_inodeTBWalker(void){
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80105020:	31 c0                	xor    %eax,%eax
80105022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		inodeTBWalkerLinkLog[inodeNum]=0;
80105028:	c7 04 85 a0 62 11 80 	movl   $0x0,-0x7fee9d60(,%eax,4)
8010502f:	00 00 00 00 
	end_op();
}

int sys_inodeTBWalker(void){
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80105033:	83 c0 01             	add    $0x1,%eax
80105036:	3d c8 00 00 00       	cmp    $0xc8,%eax
8010503b:	75 eb                	jne    80105028 <sys_inodeTBWalker+0x8>
	}
	iunlock(ip);
	end_op();
}

int sys_inodeTBWalker(void){
8010503d:	55                   	push   %ebp
8010503e:	89 e5                	mov    %esp,%ebp
80105040:	56                   	push   %esi
	}
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
	for(inum = 1; inum < sb.ninodes; inum++){
80105041:	be 01 00 00 00       	mov    $0x1,%esi
	}
	iunlock(ip);
	end_op();
}

int sys_inodeTBWalker(void){
80105046:	53                   	push   %ebx
	}
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
	for(inum = 1; inum < sb.ninodes; inum++){
80105047:	bb 01 00 00 00       	mov    $0x1,%ebx
	}
	iunlock(ip);
	end_op();
}

int sys_inodeTBWalker(void){
8010504c:	83 ec 10             	sub    $0x10,%esp
		inodeTBWalkerLinkLog[inodeNum]=0;
	}
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
8010504f:	c7 44 24 04 c0 19 11 	movl   $0x801119c0,0x4(%esp)
80105056:	80 
80105057:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010505e:	e8 5d c3 ff ff       	call   801013c0 <readsb>
	for(inum = 1; inum < sb.ninodes; inum++){
80105063:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
8010506a:	77 19                	ja     80105085 <sys_inodeTBWalker+0x65>
8010506c:	eb 6a                	jmp    801050d8 <sys_inodeTBWalker+0xb8>
8010506e:	66 90                	xchg   %ax,%ax
		if(dip->type != 0){  // not a free inode
			// Found allocated inode
			cprintf("inode#: %d \t type: %d\n",inum,dip->type);
			inodeTBWalkerLinkLog[inum]++;
		}
		brelse(bp);
80105070:	89 04 24             	mov    %eax,(%esp)
	}
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
	for(inum = 1; inum < sb.ninodes; inum++){
80105073:	83 c3 01             	add    $0x1,%ebx
		if(dip->type != 0){  // not a free inode
			// Found allocated inode
			cprintf("inode#: %d \t type: %d\n",inum,dip->type);
			inodeTBWalkerLinkLog[inum]++;
		}
		brelse(bp);
80105076:	e8 65 b1 ff ff       	call   801001e0 <brelse>
	}
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
	for(inum = 1; inum < sb.ninodes; inum++){
8010507b:	89 de                	mov    %ebx,%esi
8010507d:	3b 1d c8 19 11 80    	cmp    0x801119c8,%ebx
80105083:	73 53                	jae    801050d8 <sys_inodeTBWalker+0xb8>
		bp = bread(1, IBLOCK(inum, sb));
80105085:	89 f0                	mov    %esi,%eax
		dip = (struct dinode*)bp->data + inum%IPB;
80105087:	83 e6 07             	and    $0x7,%esi
	int inum; // Loop counter
	struct buf *bp;
	struct dinode *dip;
	readsb(1,&sb); // Read superblock
	for(inum = 1; inum < sb.ninodes; inum++){
		bp = bread(1, IBLOCK(inum, sb));
8010508a:	c1 e8 03             	shr    $0x3,%eax
8010508d:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80105093:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010509a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010509e:	e8 2d b0 ff ff       	call   801000d0 <bread>
		dip = (struct dinode*)bp->data + inum%IPB;
801050a3:	89 f2                	mov    %esi,%edx
		if(dip->type != 0){  // not a free inode
801050a5:	c1 e2 06             	shl    $0x6,%edx
801050a8:	0f bf 54 10 5c       	movswl 0x5c(%eax,%edx,1),%edx
801050ad:	66 85 d2             	test   %dx,%dx
801050b0:	74 be                	je     80105070 <sys_inodeTBWalker+0x50>
			// Found allocated inode
			cprintf("inode#: %d \t type: %d\n",inum,dip->type);
801050b2:	89 54 24 08          	mov    %edx,0x8(%esp)
801050b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801050ba:	c7 04 24 aa 7d 10 80 	movl   $0x80107daa,(%esp)
801050c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801050c4:	e8 87 b5 ff ff       	call   80100650 <cprintf>
			inodeTBWalkerLinkLog[inum]++;
801050c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050cc:	83 04 9d a0 62 11 80 	addl   $0x1,-0x7fee9d60(,%ebx,4)
801050d3:	01 
801050d4:	eb 9a                	jmp    80105070 <sys_inodeTBWalker+0x50>
801050d6:	66 90                	xchg   %ax,%ax
	}
//	for(inodeNum = 0; inodeNum<30;inodeNum++){
//		cprintf("%d",inodeTBWalkerLinkLog[inodeNum]);
//	}
	return 0;
}
801050d8:	83 c4 10             	add    $0x10,%esp
801050db:	31 c0                	xor    %eax,%eax
801050dd:	5b                   	pop    %ebx
801050de:	5e                   	pop    %esi
801050df:	5d                   	pop    %ebp
801050e0:	c3                   	ret    
801050e1:	eb 0d                	jmp    801050f0 <sys_compareWalkers>
801050e3:	90                   	nop
801050e4:	90                   	nop
801050e5:	90                   	nop
801050e6:	90                   	nop
801050e7:	90                   	nop
801050e8:	90                   	nop
801050e9:	90                   	nop
801050ea:	90                   	nop
801050eb:	90                   	nop
801050ec:	90                   	nop
801050ed:	90                   	nop
801050ee:	90                   	nop
801050ef:	90                   	nop

801050f0 <sys_compareWalkers>:
  return *(unsigned char*)s1-*(unsigned char*)s2;
}
void resetArrays(){
	// initialize link log
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
801050f0:	31 c0                	xor    %eax,%eax
801050f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		inodeLinkLog[inodeNum]=0;
801050f8:	c7 04 85 80 5f 11 80 	movl   $0x0,-0x7feea080(,%eax,4)
801050ff:	00 00 00 00 
  return *(unsigned char*)s1-*(unsigned char*)s2;
}
void resetArrays(){
	// initialize link log
	int inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
80105103:	83 c0 01             	add    $0x1,%eax
80105106:	3d c8 00 00 00       	cmp    $0xc8,%eax
8010510b:	75 eb                	jne    801050f8 <sys_compareWalkers+0x8>
8010510d:	30 c0                	xor    %al,%al
8010510f:	90                   	nop
		inodeLinkLog[inodeNum]=0;
	}
	// initialize corrupt directory log
	inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		corruptDirs[inodeNum]=0;
80105110:	c7 04 85 60 5c 11 80 	movl   $0x0,-0x7feea3a0(,%eax,4)
80105117:	00 00 00 00 
	for(inodeNum = 0; inodeNum<200;inodeNum++){
		inodeLinkLog[inodeNum]=0;
	}
	// initialize corrupt directory log
	inodeNum = 0;
	for(inodeNum = 0; inodeNum<200;inodeNum++){
8010511b:	83 c0 01             	add    $0x1,%eax
8010511e:	3d c8 00 00 00       	cmp    $0xc8,%eax
80105123:	75 eb                	jne    80105110 <sys_compareWalkers+0x20>
	dirlink(ip,newName,inum);
	iunlock(ip);
	end_op();
}

int sys_compareWalkers(){
80105125:	55                   	push   %ebp
80105126:	89 e5                	mov    %esp,%ebp
80105128:	56                   	push   %esi
	cprintf("\n= = = Calling directoryWalker = = =\n");
	directoryWalkerSubRoutine(".");
	cprintf("\n\n");
	cprintf("\n= = = Comparing walkers = = =\n");
	int inodeIndex;
	int similarity = 1;
80105129:	be 01 00 00 00       	mov    $0x1,%esi
	dirlink(ip,newName,inum);
	iunlock(ip);
	end_op();
}

int sys_compareWalkers(){
8010512e:	53                   	push   %ebx
	cprintf("\n\n");
	cprintf("\n= = = Comparing walkers = = =\n");
	int inodeIndex;
	int similarity = 1;
	// We begin at 2 because the root will be the same
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
8010512f:	bb 02 00 00 00       	mov    $0x2,%ebx
	dirlink(ip,newName,inum);
	iunlock(ip);
	end_op();
}

int sys_compareWalkers(){
80105134:	83 ec 10             	sub    $0x10,%esp
	resetArrays();
	cprintf("\n= = = Calling inodeTBwalker = = =\n");
80105137:	c7 04 24 f8 7d 10 80 	movl   $0x80107df8,(%esp)
8010513e:	e8 0d b5 ff ff       	call   80100650 <cprintf>
	sys_inodeTBWalker();
80105143:	e8 d8 fe ff ff       	call   80105020 <sys_inodeTBWalker>
	cprintf("\n\n");
80105148:	c7 04 24 c1 7d 10 80 	movl   $0x80107dc1,(%esp)
8010514f:	e8 fc b4 ff ff       	call   80100650 <cprintf>
	cprintf("\n= = = Calling directoryWalker = = =\n");
80105154:	c7 04 24 1c 7e 10 80 	movl   $0x80107e1c,(%esp)
8010515b:	e8 f0 b4 ff ff       	call   80100650 <cprintf>
	directoryWalkerSubRoutine(".");
80105160:	c7 04 24 4c 7d 10 80 	movl   $0x80107d4c,(%esp)
80105167:	e8 94 fb ff ff       	call   80104d00 <directoryWalkerSubRoutine>
	cprintf("\n\n");
8010516c:	c7 04 24 c1 7d 10 80 	movl   $0x80107dc1,(%esp)
80105173:	e8 d8 b4 ff ff       	call   80100650 <cprintf>
	cprintf("\n= = = Comparing walkers = = =\n");
80105178:	c7 04 24 44 7e 10 80 	movl   $0x80107e44,(%esp)
8010517f:	e8 cc b4 ff ff       	call   80100650 <cprintf>
80105184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	int inodeIndex;
	int similarity = 1;
	// We begin at 2 because the root will be the same
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
		if(inodeLinkLog[inodeIndex] != inodeTBWalkerLinkLog[inodeIndex]){
80105188:	8b 04 9d a0 62 11 80 	mov    -0x7fee9d60(,%ebx,4),%eax
8010518f:	39 04 9d 80 5f 11 80 	cmp    %eax,-0x7feea080(,%ebx,4)
80105196:	74 34                	je     801051cc <sys_compareWalkers+0xdc>
			similarity = 0;
			cprintf("Found difference between inodeTBWalker & directoryWalker @ inode#: %d\n",inodeIndex);
80105198:	89 5c 24 04          	mov    %ebx,0x4(%esp)
	int inodeIndex;
	int similarity = 1;
	// We begin at 2 because the root will be the same
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
		if(inodeLinkLog[inodeIndex] != inodeTBWalkerLinkLog[inodeIndex]){
			similarity = 0;
8010519c:	31 f6                	xor    %esi,%esi
			cprintf("Found difference between inodeTBWalker & directoryWalker @ inode#: %d\n",inodeIndex);
8010519e:	c7 04 24 64 7e 10 80 	movl   $0x80107e64,(%esp)
801051a5:	e8 a6 b4 ff ff       	call   80100650 <cprintf>
			cprintf("inodeTBwalker #links: %d \t directoryWalker #links: %d\n\n",inodeTBWalkerLinkLog[inodeIndex],inodeLinkLog[inodeIndex]);
801051aa:	8b 04 9d 80 5f 11 80 	mov    -0x7feea080(,%ebx,4),%eax
801051b1:	c7 04 24 ac 7e 10 80 	movl   $0x80107eac,(%esp)
801051b8:	89 44 24 08          	mov    %eax,0x8(%esp)
801051bc:	8b 04 9d a0 62 11 80 	mov    -0x7fee9d60(,%ebx,4),%eax
801051c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801051c7:	e8 84 b4 ff ff       	call   80100650 <cprintf>
	cprintf("\n\n");
	cprintf("\n= = = Comparing walkers = = =\n");
	int inodeIndex;
	int similarity = 1;
	// We begin at 2 because the root will be the same
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
801051cc:	83 c3 01             	add    $0x1,%ebx
801051cf:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
801051d5:	75 b1                	jne    80105188 <sys_compareWalkers+0x98>
801051d7:	b3 02                	mov    $0x2,%bl
801051d9:	eb 10                	jmp    801051eb <sys_compareWalkers+0xfb>
801051db:	90                   	nop
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			similarity = 0;
			cprintf("Found difference between inodeTBWalker & directoryWalker @ inode#: %d\n",inodeIndex);
			cprintf("inodeTBwalker #links: %d \t directoryWalker #links: %d\n\n",inodeTBWalkerLinkLog[inodeIndex],inodeLinkLog[inodeIndex]);
		}
	}
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
801051e0:	83 c3 01             	add    $0x1,%ebx
801051e3:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
801051e9:	74 26                	je     80105211 <sys_compareWalkers+0x121>
		if(corruptDirs[inodeIndex] != 0){
801051eb:	8b 04 9d 60 5c 11 80 	mov    -0x7feea3a0(,%ebx,4),%eax
801051f2:	85 c0                	test   %eax,%eax
801051f4:	74 ea                	je     801051e0 <sys_compareWalkers+0xf0>
			cprintf("Found a corrupted directory#: %d\n",inodeIndex);
801051f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
			similarity = 0;
			cprintf("Found difference between inodeTBWalker & directoryWalker @ inode#: %d\n",inodeIndex);
			cprintf("inodeTBwalker #links: %d \t directoryWalker #links: %d\n\n",inodeTBWalkerLinkLog[inodeIndex],inodeLinkLog[inodeIndex]);
		}
	}
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
801051fa:	83 c3 01             	add    $0x1,%ebx
		if(corruptDirs[inodeIndex] != 0){
			cprintf("Found a corrupted directory#: %d\n",inodeIndex);
801051fd:	c7 04 24 e4 7e 10 80 	movl   $0x80107ee4,(%esp)
80105204:	e8 47 b4 ff ff       	call   80100650 <cprintf>
			similarity = 0;
			cprintf("Found difference between inodeTBWalker & directoryWalker @ inode#: %d\n",inodeIndex);
			cprintf("inodeTBwalker #links: %d \t directoryWalker #links: %d\n\n",inodeTBWalkerLinkLog[inodeIndex],inodeLinkLog[inodeIndex]);
		}
	}
	for(inodeIndex=2; inodeIndex<200; inodeIndex++){
80105209:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
8010520f:	75 da                	jne    801051eb <sys_compareWalkers+0xfb>
		if(corruptDirs[inodeIndex] != 0){
			cprintf("Found a corrupted directory#: %d\n",inodeIndex);
		}
	}
	return similarity;
}
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	89 f0                	mov    %esi,%eax
80105216:	5b                   	pop    %ebx
80105217:	5e                   	pop    %esi
80105218:	5d                   	pop    %ebp
80105219:	c3                   	ret    
8010521a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105220 <sys_deleteIData>:
//		cprintf("%d",inodeTBWalkerLinkLog[inodeNum]);
//	}
	return 0;
}

int sys_deleteIData(void){
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	83 ec 28             	sub    $0x28,%esp
	int inum;
	argint(0,&inum);
80105226:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105229:	89 44 24 04          	mov    %eax,0x4(%esp)
8010522d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105234:	e8 b7 f3 ff ff       	call   801045f0 <argint>
	callDeleteInFS(inum);
80105239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010523c:	89 04 24             	mov    %eax,(%esp)
8010523f:	e8 bc c5 ff ff       	call   80101800 <callDeleteInFS>
	return 0;
}
80105244:	31 c0                	xor    %eax,%eax
80105246:	c9                   	leave  
80105247:	c3                   	ret    
80105248:	90                   	nop
80105249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105250 <sys_dup>:
	return -1;
}

int
sys_dup(void)
{
80105250:	55                   	push   %ebp
	struct file *f;
	int fd;

	if(argfd(0, 0, &f) < 0)
80105251:	31 c0                	xor    %eax,%eax
	return -1;
}

int
sys_dup(void)
{
80105253:	89 e5                	mov    %esp,%ebp
80105255:	53                   	push   %ebx
80105256:	83 ec 24             	sub    $0x24,%esp
	struct file *f;
	int fd;

	if(argfd(0, 0, &f) < 0)
80105259:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010525c:	e8 8f f6 ff ff       	call   801048f0 <argfd.constprop.0>
80105261:	85 c0                	test   %eax,%eax
80105263:	78 23                	js     80105288 <sys_dup+0x38>
		return -1;
	if((fd=fdalloc(f)) < 0)
80105265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105268:	e8 c3 f4 ff ff       	call   80104730 <fdalloc>
8010526d:	85 c0                	test   %eax,%eax
8010526f:	89 c3                	mov    %eax,%ebx
80105271:	78 15                	js     80105288 <sys_dup+0x38>
		return -1;
	filedup(f);
80105273:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105276:	89 04 24             	mov    %eax,(%esp)
80105279:	e8 62 bb ff ff       	call   80100de0 <filedup>
	return fd;
8010527e:	89 d8                	mov    %ebx,%eax
}
80105280:	83 c4 24             	add    $0x24,%esp
80105283:	5b                   	pop    %ebx
80105284:	5d                   	pop    %ebp
80105285:	c3                   	ret    
80105286:	66 90                	xchg   %ax,%ax
{
	struct file *f;
	int fd;

	if(argfd(0, 0, &f) < 0)
		return -1;
80105288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528d:	eb f1                	jmp    80105280 <sys_dup+0x30>
8010528f:	90                   	nop

80105290 <sys_read>:
	return fd;
}

int
sys_read(void)
{
80105290:	55                   	push   %ebp
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105291:	31 c0                	xor    %eax,%eax
	return fd;
}

int
sys_read(void)
{
80105293:	89 e5                	mov    %esp,%ebp
80105295:	83 ec 28             	sub    $0x28,%esp
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105298:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010529b:	e8 50 f6 ff ff       	call   801048f0 <argfd.constprop.0>
801052a0:	85 c0                	test   %eax,%eax
801052a2:	78 54                	js     801052f8 <sys_read+0x68>
801052a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ab:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801052b2:	e8 39 f3 ff ff       	call   801045f0 <argint>
801052b7:	85 c0                	test   %eax,%eax
801052b9:	78 3d                	js     801052f8 <sys_read+0x68>
801052bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801052c5:	89 44 24 08          	mov    %eax,0x8(%esp)
801052c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801052d0:	e8 4b f3 ff ff       	call   80104620 <argptr>
801052d5:	85 c0                	test   %eax,%eax
801052d7:	78 1f                	js     801052f8 <sys_read+0x68>
		return -1;
	return fileread(f, p, n);
801052d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052dc:	89 44 24 08          	mov    %eax,0x8(%esp)
801052e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801052e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052ea:	89 04 24             	mov    %eax,(%esp)
801052ed:	e8 4e bc ff ff       	call   80100f40 <fileread>
}
801052f2:	c9                   	leave  
801052f3:	c3                   	ret    
801052f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
		return -1;
801052f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return fileread(f, p, n);
}
801052fd:	c9                   	leave  
801052fe:	c3                   	ret    
801052ff:	90                   	nop

80105300 <sys_write>:

int
sys_write(void)
{
80105300:	55                   	push   %ebp
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105301:	31 c0                	xor    %eax,%eax
	return fileread(f, p, n);
}

int
sys_write(void)
{
80105303:	89 e5                	mov    %esp,%ebp
80105305:	83 ec 28             	sub    $0x28,%esp
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105308:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010530b:	e8 e0 f5 ff ff       	call   801048f0 <argfd.constprop.0>
80105310:	85 c0                	test   %eax,%eax
80105312:	78 54                	js     80105368 <sys_write+0x68>
80105314:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105317:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105322:	e8 c9 f2 ff ff       	call   801045f0 <argint>
80105327:	85 c0                	test   %eax,%eax
80105329:	78 3d                	js     80105368 <sys_write+0x68>
8010532b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010532e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105335:	89 44 24 08          	mov    %eax,0x8(%esp)
80105339:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105340:	e8 db f2 ff ff       	call   80104620 <argptr>
80105345:	85 c0                	test   %eax,%eax
80105347:	78 1f                	js     80105368 <sys_write+0x68>
		return -1;
	return filewrite(f, p, n);
80105349:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010534c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105350:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105353:	89 44 24 04          	mov    %eax,0x4(%esp)
80105357:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010535a:	89 04 24             	mov    %eax,(%esp)
8010535d:	e8 7e bc ff ff       	call   80100fe0 <filewrite>
}
80105362:	c9                   	leave  
80105363:	c3                   	ret    
80105364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	struct file *f;
	int n;
	char *p;

	if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
		return -1;
80105368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return filewrite(f, p, n);
}
8010536d:	c9                   	leave  
8010536e:	c3                   	ret    
8010536f:	90                   	nop

80105370 <sys_close>:

int
sys_close(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	83 ec 28             	sub    $0x28,%esp
	int fd;
	struct file *f;

	if(argfd(0, &fd, &f) < 0)
80105376:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105379:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010537c:	e8 6f f5 ff ff       	call   801048f0 <argfd.constprop.0>
80105381:	85 c0                	test   %eax,%eax
80105383:	78 23                	js     801053a8 <sys_close+0x38>
		return -1;
	myproc()->ofile[fd] = 0;
80105385:	e8 96 e3 ff ff       	call   80103720 <myproc>
8010538a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010538d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105394:	00 
	fileclose(f);
80105395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105398:	89 04 24             	mov    %eax,(%esp)
8010539b:	e8 90 ba ff ff       	call   80100e30 <fileclose>
	return 0;
801053a0:	31 c0                	xor    %eax,%eax
}
801053a2:	c9                   	leave  
801053a3:	c3                   	ret    
801053a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
	int fd;
	struct file *f;

	if(argfd(0, &fd, &f) < 0)
		return -1;
801053a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	myproc()->ofile[fd] = 0;
	fileclose(f);
	return 0;
}
801053ad:	c9                   	leave  
801053ae:	c3                   	ret    
801053af:	90                   	nop

801053b0 <sys_fstat>:

int
sys_fstat(void)
{
801053b0:	55                   	push   %ebp
	struct file *f;
	struct stat *st;

	if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053b1:	31 c0                	xor    %eax,%eax
	return 0;
}

int
sys_fstat(void)
{
801053b3:	89 e5                	mov    %esp,%ebp
801053b5:	83 ec 28             	sub    $0x28,%esp
	struct file *f;
	struct stat *st;

	if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053b8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801053bb:	e8 30 f5 ff ff       	call   801048f0 <argfd.constprop.0>
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 34                	js     801053f8 <sys_fstat+0x48>
801053c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801053ce:	00 
801053cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801053d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801053da:	e8 41 f2 ff ff       	call   80104620 <argptr>
801053df:	85 c0                	test   %eax,%eax
801053e1:	78 15                	js     801053f8 <sys_fstat+0x48>
		return -1;
	return filestat(f, st);
801053e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801053ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053ed:	89 04 24             	mov    %eax,(%esp)
801053f0:	e8 fb ba ff ff       	call   80100ef0 <filestat>
}
801053f5:	c9                   	leave  
801053f6:	c3                   	ret    
801053f7:	90                   	nop
{
	struct file *f;
	struct stat *st;

	if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
		return -1;
801053f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return filestat(f, st);
}
801053fd:	c9                   	leave  
801053fe:	c3                   	ret    
801053ff:	90                   	nop

80105400 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	57                   	push   %edi
80105404:	56                   	push   %esi
80105405:	53                   	push   %ebx
80105406:	83 ec 3c             	sub    $0x3c,%esp
	char name[DIRSIZ], *new, *old;
	struct inode *dp, *ip;

	if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105409:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010540c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105410:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105417:	e8 64 f2 ff ff       	call   80104680 <argstr>
8010541c:	85 c0                	test   %eax,%eax
8010541e:	0f 88 e6 00 00 00    	js     8010550a <sys_link+0x10a>
80105424:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105427:	89 44 24 04          	mov    %eax,0x4(%esp)
8010542b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105432:	e8 49 f2 ff ff       	call   80104680 <argstr>
80105437:	85 c0                	test   %eax,%eax
80105439:	0f 88 cb 00 00 00    	js     8010550a <sys_link+0x10a>
		return -1;

	begin_op();
8010543f:	e8 4c d7 ff ff       	call   80102b90 <begin_op>
	if((ip = namei(old)) == 0){
80105444:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105447:	89 04 24             	mov    %eax,(%esp)
8010544a:	e8 31 cb ff ff       	call   80101f80 <namei>
8010544f:	85 c0                	test   %eax,%eax
80105451:	89 c3                	mov    %eax,%ebx
80105453:	0f 84 ac 00 00 00    	je     80105505 <sys_link+0x105>
		end_op();
		return -1;
	}

	ilock(ip);
80105459:	89 04 24             	mov    %eax,(%esp)
8010545c:	e8 7f c2 ff ff       	call   801016e0 <ilock>
	if(ip->type == T_DIR){
80105461:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105466:	0f 84 91 00 00 00    	je     801054fd <sys_link+0xfd>
		iunlockput(ip);
		end_op();
		return -1;
	}

	ip->nlink++;
8010546c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
	iupdate(ip);
	iunlock(ip);

	if((dp = nameiparent(new, name)) == 0)
80105471:	8d 7d da             	lea    -0x26(%ebp),%edi
		end_op();
		return -1;
	}

	ip->nlink++;
	iupdate(ip);
80105474:	89 1c 24             	mov    %ebx,(%esp)
80105477:	e8 a4 c1 ff ff       	call   80101620 <iupdate>
	iunlock(ip);
8010547c:	89 1c 24             	mov    %ebx,(%esp)
8010547f:	e8 3c c3 ff ff       	call   801017c0 <iunlock>

	if((dp = nameiparent(new, name)) == 0)
80105484:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105487:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010548b:	89 04 24             	mov    %eax,(%esp)
8010548e:	e8 0d cb ff ff       	call   80101fa0 <nameiparent>
80105493:	85 c0                	test   %eax,%eax
80105495:	89 c6                	mov    %eax,%esi
80105497:	74 4f                	je     801054e8 <sys_link+0xe8>
		goto bad;
	ilock(dp);
80105499:	89 04 24             	mov    %eax,(%esp)
8010549c:	e8 3f c2 ff ff       	call   801016e0 <ilock>
	if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801054a1:	8b 03                	mov    (%ebx),%eax
801054a3:	39 06                	cmp    %eax,(%esi)
801054a5:	75 39                	jne    801054e0 <sys_link+0xe0>
801054a7:	8b 43 04             	mov    0x4(%ebx),%eax
801054aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
801054ae:	89 34 24             	mov    %esi,(%esp)
801054b1:	89 44 24 08          	mov    %eax,0x8(%esp)
801054b5:	e8 e6 c9 ff ff       	call   80101ea0 <dirlink>
801054ba:	85 c0                	test   %eax,%eax
801054bc:	78 22                	js     801054e0 <sys_link+0xe0>
		iunlockput(dp);
		goto bad;
	}
	iunlockput(dp);
801054be:	89 34 24             	mov    %esi,(%esp)
801054c1:	e8 ca c4 ff ff       	call   80101990 <iunlockput>
	iput(ip);
801054c6:	89 1c 24             	mov    %ebx,(%esp)
801054c9:	e8 82 c3 ff ff       	call   80101850 <iput>

	end_op();
801054ce:	e8 2d d7 ff ff       	call   80102c00 <end_op>
	ip->nlink--;
	iupdate(ip);
	iunlockput(ip);
	end_op();
	return -1;
}
801054d3:	83 c4 3c             	add    $0x3c,%esp
	iunlockput(dp);
	iput(ip);

	end_op();

	return 0;
801054d6:	31 c0                	xor    %eax,%eax
	ip->nlink--;
	iupdate(ip);
	iunlockput(ip);
	end_op();
	return -1;
}
801054d8:	5b                   	pop    %ebx
801054d9:	5e                   	pop    %esi
801054da:	5f                   	pop    %edi
801054db:	5d                   	pop    %ebp
801054dc:	c3                   	ret    
801054dd:	8d 76 00             	lea    0x0(%esi),%esi

	if((dp = nameiparent(new, name)) == 0)
		goto bad;
	ilock(dp);
	if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
		iunlockput(dp);
801054e0:	89 34 24             	mov    %esi,(%esp)
801054e3:	e8 a8 c4 ff ff       	call   80101990 <iunlockput>
	end_op();

	return 0;

	bad:
	ilock(ip);
801054e8:	89 1c 24             	mov    %ebx,(%esp)
801054eb:	e8 f0 c1 ff ff       	call   801016e0 <ilock>
	ip->nlink--;
801054f0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
801054f5:	89 1c 24             	mov    %ebx,(%esp)
801054f8:	e8 23 c1 ff ff       	call   80101620 <iupdate>
	iunlockput(ip);
801054fd:	89 1c 24             	mov    %ebx,(%esp)
80105500:	e8 8b c4 ff ff       	call   80101990 <iunlockput>
	end_op();
80105505:	e8 f6 d6 ff ff       	call   80102c00 <end_op>
	return -1;
}
8010550a:	83 c4 3c             	add    $0x3c,%esp
	ilock(ip);
	ip->nlink--;
	iupdate(ip);
	iunlockput(ip);
	end_op();
	return -1;
8010550d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105512:	5b                   	pop    %ebx
80105513:	5e                   	pop    %esi
80105514:	5f                   	pop    %edi
80105515:	5d                   	pop    %ebp
80105516:	c3                   	ret    
80105517:	89 f6                	mov    %esi,%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105520 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	57                   	push   %edi
80105524:	56                   	push   %esi
80105525:	53                   	push   %ebx
80105526:	83 ec 5c             	sub    $0x5c,%esp
	struct inode *ip, *dp;
	struct dirent de;
	char name[DIRSIZ], *path;
	uint off;

	if(argstr(0, &path) < 0)
80105529:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010552c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105530:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105537:	e8 44 f1 ff ff       	call   80104680 <argstr>
8010553c:	85 c0                	test   %eax,%eax
8010553e:	0f 88 76 01 00 00    	js     801056ba <sys_unlink+0x19a>
		return -1;

	begin_op();
80105544:	e8 47 d6 ff ff       	call   80102b90 <begin_op>
	if((dp = nameiparent(path, name)) == 0){
80105549:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010554c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010554f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105553:	89 04 24             	mov    %eax,(%esp)
80105556:	e8 45 ca ff ff       	call   80101fa0 <nameiparent>
8010555b:	85 c0                	test   %eax,%eax
8010555d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105560:	0f 84 4f 01 00 00    	je     801056b5 <sys_unlink+0x195>
		end_op();
		return -1;
	}

	ilock(dp);
80105566:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105569:	89 34 24             	mov    %esi,(%esp)
8010556c:	e8 6f c1 ff ff       	call   801016e0 <ilock>

	// Cannot unlink "." or "..".
	if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105571:	c7 44 24 04 4c 7d 10 	movl   $0x80107d4c,0x4(%esp)
80105578:	80 
80105579:	89 1c 24             	mov    %ebx,(%esp)
8010557c:	e8 8f c6 ff ff       	call   80101c10 <namecmp>
80105581:	85 c0                	test   %eax,%eax
80105583:	0f 84 21 01 00 00    	je     801056aa <sys_unlink+0x18a>
80105589:	c7 44 24 04 4b 7d 10 	movl   $0x80107d4b,0x4(%esp)
80105590:	80 
80105591:	89 1c 24             	mov    %ebx,(%esp)
80105594:	e8 77 c6 ff ff       	call   80101c10 <namecmp>
80105599:	85 c0                	test   %eax,%eax
8010559b:	0f 84 09 01 00 00    	je     801056aa <sys_unlink+0x18a>
		goto bad;

	if((ip = dirlookup(dp, name, &off)) == 0)
801055a1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801055a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801055a8:	89 44 24 08          	mov    %eax,0x8(%esp)
801055ac:	89 34 24             	mov    %esi,(%esp)
801055af:	e8 8c c6 ff ff       	call   80101c40 <dirlookup>
801055b4:	85 c0                	test   %eax,%eax
801055b6:	89 c3                	mov    %eax,%ebx
801055b8:	0f 84 ec 00 00 00    	je     801056aa <sys_unlink+0x18a>
		goto bad;
	ilock(ip);
801055be:	89 04 24             	mov    %eax,(%esp)
801055c1:	e8 1a c1 ff ff       	call   801016e0 <ilock>

	if(ip->nlink < 1)
801055c6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801055cb:	0f 8e 24 01 00 00    	jle    801056f5 <sys_unlink+0x1d5>
		panic("unlink: nlink < 1");
	if(ip->type == T_DIR && !isdirempty(ip)){
801055d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055d6:	8d 75 d8             	lea    -0x28(%ebp),%esi
801055d9:	74 7d                	je     80105658 <sys_unlink+0x138>
		iunlockput(ip);
		goto bad;
	}

	memset(&de, 0, sizeof(de));
801055db:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801055e2:	00 
801055e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801055ea:	00 
801055eb:	89 34 24             	mov    %esi,(%esp)
801055ee:	e8 0d ed ff ff       	call   80104300 <memset>
	if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801055f6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801055fd:	00 
801055fe:	89 74 24 04          	mov    %esi,0x4(%esp)
80105602:	89 44 24 08          	mov    %eax,0x8(%esp)
80105606:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105609:	89 04 24             	mov    %eax,(%esp)
8010560c:	e8 cf c4 ff ff       	call   80101ae0 <writei>
80105611:	83 f8 10             	cmp    $0x10,%eax
80105614:	0f 85 cf 00 00 00    	jne    801056e9 <sys_unlink+0x1c9>
		panic("unlink: writei");
	if(ip->type == T_DIR){
8010561a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010561f:	0f 84 a3 00 00 00    	je     801056c8 <sys_unlink+0x1a8>
		dp->nlink--;
		iupdate(dp);
	}
	iunlockput(dp);
80105625:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105628:	89 04 24             	mov    %eax,(%esp)
8010562b:	e8 60 c3 ff ff       	call   80101990 <iunlockput>

	ip->nlink--;
80105630:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
80105635:	89 1c 24             	mov    %ebx,(%esp)
80105638:	e8 e3 bf ff ff       	call   80101620 <iupdate>
	iunlockput(ip);
8010563d:	89 1c 24             	mov    %ebx,(%esp)
80105640:	e8 4b c3 ff ff       	call   80101990 <iunlockput>

	end_op();
80105645:	e8 b6 d5 ff ff       	call   80102c00 <end_op>

	bad:
	iunlockput(dp);
	end_op();
	return -1;
}
8010564a:	83 c4 5c             	add    $0x5c,%esp
	iupdate(ip);
	iunlockput(ip);

	end_op();

	return 0;
8010564d:	31 c0                	xor    %eax,%eax

	bad:
	iunlockput(dp);
	end_op();
	return -1;
}
8010564f:	5b                   	pop    %ebx
80105650:	5e                   	pop    %esi
80105651:	5f                   	pop    %edi
80105652:	5d                   	pop    %ebp
80105653:	c3                   	ret    
80105654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
	int off;
	struct dirent de;

	for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105658:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
8010565c:	0f 86 79 ff ff ff    	jbe    801055db <sys_unlink+0xbb>
80105662:	bf 20 00 00 00       	mov    $0x20,%edi
80105667:	eb 15                	jmp    8010567e <sys_unlink+0x15e>
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105670:	8d 57 10             	lea    0x10(%edi),%edx
80105673:	3b 53 58             	cmp    0x58(%ebx),%edx
80105676:	0f 83 5f ff ff ff    	jae    801055db <sys_unlink+0xbb>
8010567c:	89 d7                	mov    %edx,%edi
		if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010567e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105685:	00 
80105686:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010568a:	89 74 24 04          	mov    %esi,0x4(%esp)
8010568e:	89 1c 24             	mov    %ebx,(%esp)
80105691:	e8 4a c3 ff ff       	call   801019e0 <readi>
80105696:	83 f8 10             	cmp    $0x10,%eax
80105699:	75 42                	jne    801056dd <sys_unlink+0x1bd>
			panic("isdirempty: readi");
		if(de.inum != 0)
8010569b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056a0:	74 ce                	je     80105670 <sys_unlink+0x150>
	ilock(ip);

	if(ip->nlink < 1)
		panic("unlink: nlink < 1");
	if(ip->type == T_DIR && !isdirempty(ip)){
		iunlockput(ip);
801056a2:	89 1c 24             	mov    %ebx,(%esp)
801056a5:	e8 e6 c2 ff ff       	call   80101990 <iunlockput>
	end_op();

	return 0;

	bad:
	iunlockput(dp);
801056aa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801056ad:	89 04 24             	mov    %eax,(%esp)
801056b0:	e8 db c2 ff ff       	call   80101990 <iunlockput>
	end_op();
801056b5:	e8 46 d5 ff ff       	call   80102c00 <end_op>
	return -1;
}
801056ba:	83 c4 5c             	add    $0x5c,%esp
	return 0;

	bad:
	iunlockput(dp);
	end_op();
	return -1;
801056bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056c2:	5b                   	pop    %ebx
801056c3:	5e                   	pop    %esi
801056c4:	5f                   	pop    %edi
801056c5:	5d                   	pop    %ebp
801056c6:	c3                   	ret    
801056c7:	90                   	nop

	memset(&de, 0, sizeof(de));
	if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
		panic("unlink: writei");
	if(ip->type == T_DIR){
		dp->nlink--;
801056c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801056cb:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
		iupdate(dp);
801056d0:	89 04 24             	mov    %eax,(%esp)
801056d3:	e8 48 bf ff ff       	call   80101620 <iupdate>
801056d8:	e9 48 ff ff ff       	jmp    80105625 <sys_unlink+0x105>
	int off;
	struct dirent de;

	for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
		if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
			panic("isdirempty: readi");
801056dd:	c7 04 24 d6 7d 10 80 	movl   $0x80107dd6,(%esp)
801056e4:	e8 77 ac ff ff       	call   80100360 <panic>
		goto bad;
	}

	memset(&de, 0, sizeof(de));
	if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
		panic("unlink: writei");
801056e9:	c7 04 24 e8 7d 10 80 	movl   $0x80107de8,(%esp)
801056f0:	e8 6b ac ff ff       	call   80100360 <panic>
	if((ip = dirlookup(dp, name, &off)) == 0)
		goto bad;
	ilock(ip);

	if(ip->nlink < 1)
		panic("unlink: nlink < 1");
801056f5:	c7 04 24 c4 7d 10 80 	movl   $0x80107dc4,(%esp)
801056fc:	e8 5f ac ff ff       	call   80100360 <panic>
80105701:	eb 0d                	jmp    80105710 <sys_open>
80105703:	90                   	nop
80105704:	90                   	nop
80105705:	90                   	nop
80105706:	90                   	nop
80105707:	90                   	nop
80105708:	90                   	nop
80105709:	90                   	nop
8010570a:	90                   	nop
8010570b:	90                   	nop
8010570c:	90                   	nop
8010570d:	90                   	nop
8010570e:	90                   	nop
8010570f:	90                   	nop

80105710 <sys_open>:
	return ip;
}

int
sys_open(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	57                   	push   %edi
80105714:	56                   	push   %esi
80105715:	53                   	push   %ebx
80105716:	83 ec 2c             	sub    $0x2c,%esp
	char *path;
	int fd, omode;
	struct file *f;
	struct inode *ip;

	if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105719:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010571c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105720:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105727:	e8 54 ef ff ff       	call   80104680 <argstr>
8010572c:	85 c0                	test   %eax,%eax
8010572e:	0f 88 d1 00 00 00    	js     80105805 <sys_open+0xf5>
80105734:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105737:	89 44 24 04          	mov    %eax,0x4(%esp)
8010573b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105742:	e8 a9 ee ff ff       	call   801045f0 <argint>
80105747:	85 c0                	test   %eax,%eax
80105749:	0f 88 b6 00 00 00    	js     80105805 <sys_open+0xf5>
		return -1;

	begin_op();
8010574f:	e8 3c d4 ff ff       	call   80102b90 <begin_op>

	if(omode & O_CREATE){
80105754:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105758:	0f 85 82 00 00 00    	jne    801057e0 <sys_open+0xd0>
		if(ip == 0){
			end_op();
			return -1;
		}
	} else {
		if((ip = namei(path)) == 0){
8010575e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105761:	89 04 24             	mov    %eax,(%esp)
80105764:	e8 17 c8 ff ff       	call   80101f80 <namei>
80105769:	85 c0                	test   %eax,%eax
8010576b:	89 c6                	mov    %eax,%esi
8010576d:	0f 84 8d 00 00 00    	je     80105800 <sys_open+0xf0>
			end_op();
			return -1;
		}
		ilock(ip);
80105773:	89 04 24             	mov    %eax,(%esp)
80105776:	e8 65 bf ff ff       	call   801016e0 <ilock>
		if(ip->type == T_DIR && omode != O_RDONLY){
8010577b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105780:	0f 84 92 00 00 00    	je     80105818 <sys_open+0x108>
			end_op();
			return -1;
		}
	}

	if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105786:	e8 e5 b5 ff ff       	call   80100d70 <filealloc>
8010578b:	85 c0                	test   %eax,%eax
8010578d:	89 c3                	mov    %eax,%ebx
8010578f:	0f 84 93 00 00 00    	je     80105828 <sys_open+0x118>
80105795:	e8 96 ef ff ff       	call   80104730 <fdalloc>
8010579a:	85 c0                	test   %eax,%eax
8010579c:	89 c7                	mov    %eax,%edi
8010579e:	0f 88 94 00 00 00    	js     80105838 <sys_open+0x128>
			fileclose(f);
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
801057a4:	89 34 24             	mov    %esi,(%esp)
801057a7:	e8 14 c0 ff ff       	call   801017c0 <iunlock>
	end_op();
801057ac:	e8 4f d4 ff ff       	call   80102c00 <end_op>

	f->type = FD_INODE;
801057b1:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
	f->ip = ip;
	f->off = 0;
	f->readable = !(omode & O_WRONLY);
801057b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	}
	iunlock(ip);
	end_op();

	f->type = FD_INODE;
	f->ip = ip;
801057ba:	89 73 10             	mov    %esi,0x10(%ebx)
	f->off = 0;
801057bd:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	f->readable = !(omode & O_WRONLY);
801057c4:	89 c2                	mov    %eax,%edx
801057c6:	83 e2 01             	and    $0x1,%edx
801057c9:	83 f2 01             	xor    $0x1,%edx
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057cc:	a8 03                	test   $0x3,%al
	end_op();

	f->type = FD_INODE;
	f->ip = ip;
	f->off = 0;
	f->readable = !(omode & O_WRONLY);
801057ce:	88 53 08             	mov    %dl,0x8(%ebx)
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
	return fd;
801057d1:	89 f8                	mov    %edi,%eax

	f->type = FD_INODE;
	f->ip = ip;
	f->off = 0;
	f->readable = !(omode & O_WRONLY);
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057d3:	0f 95 43 09          	setne  0x9(%ebx)
	return fd;
}
801057d7:	83 c4 2c             	add    $0x2c,%esp
801057da:	5b                   	pop    %ebx
801057db:	5e                   	pop    %esi
801057dc:	5f                   	pop    %edi
801057dd:	5d                   	pop    %ebp
801057de:	c3                   	ret    
801057df:	90                   	nop
		return -1;

	begin_op();

	if(omode & O_CREATE){
		ip = create(path, T_FILE, 0, 0);
801057e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057e3:	31 c9                	xor    %ecx,%ecx
801057e5:	ba 02 00 00 00       	mov    $0x2,%edx
801057ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057f1:	e8 7a ef ff ff       	call   80104770 <create>
		if(ip == 0){
801057f6:	85 c0                	test   %eax,%eax
		return -1;

	begin_op();

	if(omode & O_CREATE){
		ip = create(path, T_FILE, 0, 0);
801057f8:	89 c6                	mov    %eax,%esi
		if(ip == 0){
801057fa:	75 8a                	jne    80105786 <sys_open+0x76>
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

	if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
		if(f)
			fileclose(f);
		iunlockput(ip);
		end_op();
80105800:	e8 fb d3 ff ff       	call   80102c00 <end_op>
	f->ip = ip;
	f->off = 0;
	f->readable = !(omode & O_WRONLY);
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
	return fd;
}
80105805:	83 c4 2c             	add    $0x2c,%esp
	if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
		if(f)
			fileclose(f);
		iunlockput(ip);
		end_op();
		return -1;
80105808:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	f->ip = ip;
	f->off = 0;
	f->readable = !(omode & O_WRONLY);
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
	return fd;
}
8010580d:	5b                   	pop    %ebx
8010580e:	5e                   	pop    %esi
8010580f:	5f                   	pop    %edi
80105810:	5d                   	pop    %ebp
80105811:	c3                   	ret    
80105812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if((ip = namei(path)) == 0){
			end_op();
			return -1;
		}
		ilock(ip);
		if(ip->type == T_DIR && omode != O_RDONLY){
80105818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010581b:	85 c0                	test   %eax,%eax
8010581d:	0f 84 63 ff ff ff    	je     80105786 <sys_open+0x76>
80105823:	90                   	nop
80105824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	}

	if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
		if(f)
			fileclose(f);
		iunlockput(ip);
80105828:	89 34 24             	mov    %esi,(%esp)
8010582b:	e8 60 c1 ff ff       	call   80101990 <iunlockput>
80105830:	eb ce                	jmp    80105800 <sys_open+0xf0>
80105832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		}
	}

	if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
		if(f)
			fileclose(f);
80105838:	89 1c 24             	mov    %ebx,(%esp)
8010583b:	e8 f0 b5 ff ff       	call   80100e30 <fileclose>
80105840:	eb e6                	jmp    80105828 <sys_open+0x118>
80105842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105850 <sys_mkdir>:
	return fd;
}

int
sys_mkdir(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 28             	sub    $0x28,%esp
	char *path;
	struct inode *ip;

	begin_op();
80105856:	e8 35 d3 ff ff       	call   80102b90 <begin_op>
	if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010585b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010585e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105862:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105869:	e8 12 ee ff ff       	call   80104680 <argstr>
8010586e:	85 c0                	test   %eax,%eax
80105870:	78 2e                	js     801058a0 <sys_mkdir+0x50>
80105872:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105875:	31 c9                	xor    %ecx,%ecx
80105877:	ba 01 00 00 00       	mov    $0x1,%edx
8010587c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105883:	e8 e8 ee ff ff       	call   80104770 <create>
80105888:	85 c0                	test   %eax,%eax
8010588a:	74 14                	je     801058a0 <sys_mkdir+0x50>
		end_op();
		return -1;
	}
	iunlockput(ip);
8010588c:	89 04 24             	mov    %eax,(%esp)
8010588f:	e8 fc c0 ff ff       	call   80101990 <iunlockput>
	end_op();
80105894:	e8 67 d3 ff ff       	call   80102c00 <end_op>
	return 0;
80105899:	31 c0                	xor    %eax,%eax
}
8010589b:	c9                   	leave  
8010589c:	c3                   	ret    
8010589d:	8d 76 00             	lea    0x0(%esi),%esi
	char *path;
	struct inode *ip;

	begin_op();
	if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
		end_op();
801058a0:	e8 5b d3 ff ff       	call   80102c00 <end_op>
		return -1;
801058a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	iunlockput(ip);
	end_op();
	return 0;
}
801058aa:	c9                   	leave  
801058ab:	c3                   	ret    
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_mknod>:

int
sys_mknod(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 28             	sub    $0x28,%esp
	struct inode *ip;
	char *path;
	int major, minor;

	begin_op();
801058b6:	e8 d5 d2 ff ff       	call   80102b90 <begin_op>
	if((argstr(0, &path)) < 0 ||
801058bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058be:	89 44 24 04          	mov    %eax,0x4(%esp)
801058c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058c9:	e8 b2 ed ff ff       	call   80104680 <argstr>
801058ce:	85 c0                	test   %eax,%eax
801058d0:	78 5e                	js     80105930 <sys_mknod+0x80>
			argint(1, &major) < 0 ||
801058d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801058d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058e0:	e8 0b ed ff ff       	call   801045f0 <argint>
	struct inode *ip;
	char *path;
	int major, minor;

	begin_op();
	if((argstr(0, &path)) < 0 ||
801058e5:	85 c0                	test   %eax,%eax
801058e7:	78 47                	js     80105930 <sys_mknod+0x80>
			argint(1, &major) < 0 ||
			argint(2, &minor) < 0 ||
801058e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801058f0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801058f7:	e8 f4 ec ff ff       	call   801045f0 <argint>
	char *path;
	int major, minor;

	begin_op();
	if((argstr(0, &path)) < 0 ||
			argint(1, &major) < 0 ||
801058fc:	85 c0                	test   %eax,%eax
801058fe:	78 30                	js     80105930 <sys_mknod+0x80>
			argint(2, &minor) < 0 ||
			(ip = create(path, T_DEV, major, minor)) == 0){
80105900:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
	int major, minor;

	begin_op();
	if((argstr(0, &path)) < 0 ||
			argint(1, &major) < 0 ||
			argint(2, &minor) < 0 ||
80105904:	ba 03 00 00 00       	mov    $0x3,%edx
			(ip = create(path, T_DEV, major, minor)) == 0){
80105909:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010590d:	89 04 24             	mov    %eax,(%esp)
	int major, minor;

	begin_op();
	if((argstr(0, &path)) < 0 ||
			argint(1, &major) < 0 ||
			argint(2, &minor) < 0 ||
80105910:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105913:	e8 58 ee ff ff       	call   80104770 <create>
80105918:	85 c0                	test   %eax,%eax
8010591a:	74 14                	je     80105930 <sys_mknod+0x80>
			(ip = create(path, T_DEV, major, minor)) == 0){
		end_op();
		return -1;
	}
	iunlockput(ip);
8010591c:	89 04 24             	mov    %eax,(%esp)
8010591f:	e8 6c c0 ff ff       	call   80101990 <iunlockput>
	end_op();
80105924:	e8 d7 d2 ff ff       	call   80102c00 <end_op>
	return 0;
80105929:	31 c0                	xor    %eax,%eax
}
8010592b:	c9                   	leave  
8010592c:	c3                   	ret    
8010592d:	8d 76 00             	lea    0x0(%esi),%esi
	begin_op();
	if((argstr(0, &path)) < 0 ||
			argint(1, &major) < 0 ||
			argint(2, &minor) < 0 ||
			(ip = create(path, T_DEV, major, minor)) == 0){
		end_op();
80105930:	e8 cb d2 ff ff       	call   80102c00 <end_op>
		return -1;
80105935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	iunlockput(ip);
	end_op();
	return 0;
}
8010593a:	c9                   	leave  
8010593b:	c3                   	ret    
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_chdir>:

int
sys_chdir(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	56                   	push   %esi
80105944:	53                   	push   %ebx
80105945:	83 ec 20             	sub    $0x20,%esp
	char *path;
	struct inode *ip;
	struct proc *curproc = myproc();
80105948:	e8 d3 dd ff ff       	call   80103720 <myproc>
8010594d:	89 c6                	mov    %eax,%esi

	begin_op();
8010594f:	e8 3c d2 ff ff       	call   80102b90 <begin_op>
	if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105954:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105957:	89 44 24 04          	mov    %eax,0x4(%esp)
8010595b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105962:	e8 19 ed ff ff       	call   80104680 <argstr>
80105967:	85 c0                	test   %eax,%eax
80105969:	78 4a                	js     801059b5 <sys_chdir+0x75>
8010596b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596e:	89 04 24             	mov    %eax,(%esp)
80105971:	e8 0a c6 ff ff       	call   80101f80 <namei>
80105976:	85 c0                	test   %eax,%eax
80105978:	89 c3                	mov    %eax,%ebx
8010597a:	74 39                	je     801059b5 <sys_chdir+0x75>
		end_op();
		return -1;
	}
	ilock(ip);
8010597c:	89 04 24             	mov    %eax,(%esp)
8010597f:	e8 5c bd ff ff       	call   801016e0 <ilock>
	if(ip->type != T_DIR){
80105984:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
		iunlockput(ip);
80105989:	89 1c 24             	mov    %ebx,(%esp)
	if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
		end_op();
		return -1;
	}
	ilock(ip);
	if(ip->type != T_DIR){
8010598c:	75 22                	jne    801059b0 <sys_chdir+0x70>
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
8010598e:	e8 2d be ff ff       	call   801017c0 <iunlock>
	iput(curproc->cwd);
80105993:	8b 46 68             	mov    0x68(%esi),%eax
80105996:	89 04 24             	mov    %eax,(%esp)
80105999:	e8 b2 be ff ff       	call   80101850 <iput>
	end_op();
8010599e:	e8 5d d2 ff ff       	call   80102c00 <end_op>
	curproc->cwd = ip;
	return 0;
801059a3:	31 c0                	xor    %eax,%eax
		return -1;
	}
	iunlock(ip);
	iput(curproc->cwd);
	end_op();
	curproc->cwd = ip;
801059a5:	89 5e 68             	mov    %ebx,0x68(%esi)
	return 0;
}
801059a8:	83 c4 20             	add    $0x20,%esp
801059ab:	5b                   	pop    %ebx
801059ac:	5e                   	pop    %esi
801059ad:	5d                   	pop    %ebp
801059ae:	c3                   	ret    
801059af:	90                   	nop
		end_op();
		return -1;
	}
	ilock(ip);
	if(ip->type != T_DIR){
		iunlockput(ip);
801059b0:	e8 db bf ff ff       	call   80101990 <iunlockput>
		end_op();
801059b5:	e8 46 d2 ff ff       	call   80102c00 <end_op>
	iunlock(ip);
	iput(curproc->cwd);
	end_op();
	curproc->cwd = ip;
	return 0;
}
801059ba:	83 c4 20             	add    $0x20,%esp
	}
	ilock(ip);
	if(ip->type != T_DIR){
		iunlockput(ip);
		end_op();
		return -1;
801059bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	iunlock(ip);
	iput(curproc->cwd);
	end_op();
	curproc->cwd = ip;
	return 0;
}
801059c2:	5b                   	pop    %ebx
801059c3:	5e                   	pop    %esi
801059c4:	5d                   	pop    %ebp
801059c5:	c3                   	ret    
801059c6:	8d 76 00             	lea    0x0(%esi),%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <sys_exec>:

int
sys_exec(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	57                   	push   %edi
801059d4:	56                   	push   %esi
801059d5:	53                   	push   %ebx
801059d6:	81 ec ac 00 00 00    	sub    $0xac,%esp
	char *path, *argv[MAXARG];
	int i;
	uint uargv, uarg;

	if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059dc:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801059e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801059e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059ed:	e8 8e ec ff ff       	call   80104680 <argstr>
801059f2:	85 c0                	test   %eax,%eax
801059f4:	0f 88 84 00 00 00    	js     80105a7e <sys_exec+0xae>
801059fa:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a0b:	e8 e0 eb ff ff       	call   801045f0 <argint>
80105a10:	85 c0                	test   %eax,%eax
80105a12:	78 6a                	js     80105a7e <sys_exec+0xae>
		return -1;
	}
	memset(argv, 0, sizeof(argv));
80105a14:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
	for(i=0;; i++){
80105a1a:	31 db                	xor    %ebx,%ebx
	uint uargv, uarg;

	if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
		return -1;
	}
	memset(argv, 0, sizeof(argv));
80105a1c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105a23:	00 
80105a24:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105a2a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a31:	00 
80105a32:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a38:	89 04 24             	mov    %eax,(%esp)
80105a3b:	e8 c0 e8 ff ff       	call   80104300 <memset>
	for(i=0;; i++){
		if(i >= NELEM(argv))
			return -1;
		if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a40:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a46:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105a4a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105a4d:	89 04 24             	mov    %eax,(%esp)
80105a50:	e8 fb ea ff ff       	call   80104550 <fetchint>
80105a55:	85 c0                	test   %eax,%eax
80105a57:	78 25                	js     80105a7e <sys_exec+0xae>
			return -1;
		if(uarg == 0){
80105a59:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a5f:	85 c0                	test   %eax,%eax
80105a61:	74 2d                	je     80105a90 <sys_exec+0xc0>
			argv[i] = 0;
			break;
		}
		if(fetchstr(uarg, &argv[i]) < 0)
80105a63:	89 74 24 04          	mov    %esi,0x4(%esp)
80105a67:	89 04 24             	mov    %eax,(%esp)
80105a6a:	e8 21 eb ff ff       	call   80104590 <fetchstr>
80105a6f:	85 c0                	test   %eax,%eax
80105a71:	78 0b                	js     80105a7e <sys_exec+0xae>

	if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
		return -1;
	}
	memset(argv, 0, sizeof(argv));
	for(i=0;; i++){
80105a73:	83 c3 01             	add    $0x1,%ebx
80105a76:	83 c6 04             	add    $0x4,%esi
		if(i >= NELEM(argv))
80105a79:	83 fb 20             	cmp    $0x20,%ebx
80105a7c:	75 c2                	jne    80105a40 <sys_exec+0x70>
		}
		if(fetchstr(uarg, &argv[i]) < 0)
			return -1;
	}
	return exec(path, argv);
}
80105a7e:	81 c4 ac 00 00 00    	add    $0xac,%esp
	char *path, *argv[MAXARG];
	int i;
	uint uargv, uarg;

	if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
		return -1;
80105a84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		}
		if(fetchstr(uarg, &argv[i]) < 0)
			return -1;
	}
	return exec(path, argv);
}
80105a89:	5b                   	pop    %ebx
80105a8a:	5e                   	pop    %esi
80105a8b:	5f                   	pop    %edi
80105a8c:	5d                   	pop    %ebp
80105a8d:	c3                   	ret    
80105a8e:	66 90                	xchg   %ax,%ax
			break;
		}
		if(fetchstr(uarg, &argv[i]) < 0)
			return -1;
	}
	return exec(path, argv);
80105a90:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a96:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a9a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
		if(i >= NELEM(argv))
			return -1;
		if(fetchint(uargv+4*i, (int*)&uarg) < 0)
			return -1;
		if(uarg == 0){
			argv[i] = 0;
80105aa0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105aa7:	00 00 00 00 
			break;
		}
		if(fetchstr(uarg, &argv[i]) < 0)
			return -1;
	}
	return exec(path, argv);
80105aab:	89 04 24             	mov    %eax,(%esp)
80105aae:	e8 ed ae ff ff       	call   801009a0 <exec>
}
80105ab3:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105ab9:	5b                   	pop    %ebx
80105aba:	5e                   	pop    %esi
80105abb:	5f                   	pop    %edi
80105abc:	5d                   	pop    %ebp
80105abd:	c3                   	ret    
80105abe:	66 90                	xchg   %ax,%ax

80105ac0 <sys_pipe>:

int
sys_pipe(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
80105ac4:	83 ec 24             	sub    $0x24,%esp
	int *fd;
	struct file *rf, *wf;
	int fd0, fd1;

	if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ac7:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105aca:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105ad1:	00 
80105ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ad6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105add:	e8 3e eb ff ff       	call   80104620 <argptr>
80105ae2:	85 c0                	test   %eax,%eax
80105ae4:	78 6d                	js     80105b53 <sys_pipe+0x93>
		return -1;
	if(pipealloc(&rf, &wf) < 0)
80105ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aed:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105af0:	89 04 24             	mov    %eax,(%esp)
80105af3:	e8 f8 d6 ff ff       	call   801031f0 <pipealloc>
80105af8:	85 c0                	test   %eax,%eax
80105afa:	78 57                	js     80105b53 <sys_pipe+0x93>
		return -1;
	fd0 = -1;
	if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aff:	e8 2c ec ff ff       	call   80104730 <fdalloc>
80105b04:	85 c0                	test   %eax,%eax
80105b06:	89 c3                	mov    %eax,%ebx
80105b08:	78 33                	js     80105b3d <sys_pipe+0x7d>
80105b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b0d:	e8 1e ec ff ff       	call   80104730 <fdalloc>
80105b12:	85 c0                	test   %eax,%eax
80105b14:	78 1a                	js     80105b30 <sys_pipe+0x70>
			myproc()->ofile[fd0] = 0;
		fileclose(rf);
		fileclose(wf);
		return -1;
	}
	fd[0] = fd0;
80105b16:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b19:	89 1a                	mov    %ebx,(%edx)
	fd[1] = fd1;
80105b1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b1e:	89 42 04             	mov    %eax,0x4(%edx)
	return 0;
}
80105b21:	83 c4 24             	add    $0x24,%esp
		fileclose(wf);
		return -1;
	}
	fd[0] = fd0;
	fd[1] = fd1;
	return 0;
80105b24:	31 c0                	xor    %eax,%eax
}
80105b26:	5b                   	pop    %ebx
80105b27:	5d                   	pop    %ebp
80105b28:	c3                   	ret    
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if(pipealloc(&rf, &wf) < 0)
		return -1;
	fd0 = -1;
	if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
		if(fd0 >= 0)
			myproc()->ofile[fd0] = 0;
80105b30:	e8 eb db ff ff       	call   80103720 <myproc>
80105b35:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80105b3c:	00 
		fileclose(rf);
80105b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b40:	89 04 24             	mov    %eax,(%esp)
80105b43:	e8 e8 b2 ff ff       	call   80100e30 <fileclose>
		fileclose(wf);
80105b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b4b:	89 04 24             	mov    %eax,(%esp)
80105b4e:	e8 dd b2 ff ff       	call   80100e30 <fileclose>
		return -1;
	}
	fd[0] = fd0;
	fd[1] = fd1;
	return 0;
}
80105b53:	83 c4 24             	add    $0x24,%esp
	if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
		if(fd0 >= 0)
			myproc()->ofile[fd0] = 0;
		fileclose(rf);
		fileclose(wf);
		return -1;
80105b56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	fd[0] = fd0;
	fd[1] = fd1;
	return 0;
}
80105b5b:	5b                   	pop    %ebx
80105b5c:	5d                   	pop    %ebp
80105b5d:	c3                   	ret    
80105b5e:	66 90                	xchg   %ax,%ax

80105b60 <sys_myMemory>:
#include "mmu.h"
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
	pde_t * pageDirectory = myproc()->pgdir;
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
80105b64:	31 ff                	xor    %edi,%edi
#include "mmu.h"
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
80105b66:	56                   	push   %esi
	pde_t * pageDirectory = myproc()->pgdir;
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
80105b67:	31 f6                	xor    %esi,%esi
#include "mmu.h"
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
80105b69:	53                   	push   %ebx
80105b6a:	83 ec 1c             	sub    $0x1c,%esp
	pde_t * pageDirectory = myproc()->pgdir;
80105b6d:	e8 ae db ff ff       	call   80103720 <myproc>
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
80105b72:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
#include "proc.h"
//#include "user.h"

int
sys_myMemory(void){
	pde_t * pageDirectory = myproc()->pgdir;
80105b79:	8b 40 04             	mov    0x4(%eax),%eax
80105b7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b7f:	90                   	nop
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
		if ((((pageDirectory[pageDirectoryIndex]) & (uint)PTE_P))){
80105b80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b83:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80105b86:	8b 04 98             	mov    (%eax,%ebx,4),%eax
80105b89:	a8 01                	test   $0x1,%al
80105b8b:	74 3b                	je     80105bc8 <sys_myMemory+0x68>
			pageTable = (pde_t *)P2V(PTE_ADDR(pageDirectory[pageDirectoryIndex]));
80105b8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105b92:	8d 98 00 10 00 80    	lea    -0x7ffff000(%eax),%ebx
80105b98:	05 00 00 00 80       	add    $0x80000000,%eax
80105b9d:	eb 08                	jmp    80105ba7 <sys_myMemory+0x47>
80105b9f:	90                   	nop
80105ba0:	83 c0 04             	add    $0x4,%eax
			for(pageTableIndex=0; pageTableIndex<1024; pageTableIndex++){
80105ba3:	39 d8                	cmp    %ebx,%eax
80105ba5:	74 21                	je     80105bc8 <sys_myMemory+0x68>
				if((pageTable[pageTableIndex] & (uint)PTE_U) && (pageTable[pageTableIndex] & (uint)PTE_P)){
80105ba7:	8b 10                	mov    (%eax),%edx
80105ba9:	89 d1                	mov    %edx,%ecx
80105bab:	83 e1 05             	and    $0x5,%ecx
80105bae:	83 f9 05             	cmp    $0x5,%ecx
80105bb1:	75 ed                	jne    80105ba0 <sys_myMemory+0x40>
					// Page is present
					presentPagesCounter++;
					if ((pageTable[pageTableIndex] & (uint)PTE_W)){
80105bb3:	83 e2 02             	and    $0x2,%edx
		if ((((pageDirectory[pageDirectoryIndex]) & (uint)PTE_P))){
			pageTable = (pde_t *)P2V(PTE_ADDR(pageDirectory[pageDirectoryIndex]));
			for(pageTableIndex=0; pageTableIndex<1024; pageTableIndex++){
				if((pageTable[pageTableIndex] & (uint)PTE_U) && (pageTable[pageTableIndex] & (uint)PTE_P)){
					// Page is present
					presentPagesCounter++;
80105bb6:	83 c6 01             	add    $0x1,%esi
					if ((pageTable[pageTableIndex] & (uint)PTE_W)){
						//Page is accessible and writable
						userWritePagesCounter++;
80105bb9:	83 fa 01             	cmp    $0x1,%edx
80105bbc:	83 df ff             	sbb    $0xffffffff,%edi
80105bbf:	83 c0 04             	add    $0x4,%eax
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
		if ((((pageDirectory[pageDirectoryIndex]) & (uint)PTE_P))){
			pageTable = (pde_t *)P2V(PTE_ADDR(pageDirectory[pageDirectoryIndex]));
			for(pageTableIndex=0; pageTableIndex<1024; pageTableIndex++){
80105bc2:	39 d8                	cmp    %ebx,%eax
80105bc4:	75 e1                	jne    80105ba7 <sys_myMemory+0x47>
80105bc6:	66 90                	xchg   %ax,%ax
	pte_t * pageTable;
	int pageDirectoryIndex;
	int pageTableIndex;
	int presentPagesCounter = 0;
	int userWritePagesCounter = 0;
	for(pageDirectoryIndex=0; pageDirectoryIndex < 1024;pageDirectoryIndex++){
80105bc8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105bcc:	81 7d e4 00 04 00 00 	cmpl   $0x400,-0x1c(%ebp)
80105bd3:	75 ab                	jne    80105b80 <sys_myMemory+0x20>
				}
			}
		}
	}
	//Present = Accessible
	cprintf("Present Pages: %d\n",presentPagesCounter);
80105bd5:	89 74 24 04          	mov    %esi,0x4(%esp)
80105bd9:	c7 04 24 06 7f 10 80 	movl   $0x80107f06,(%esp)
80105be0:	e8 6b aa ff ff       	call   80100650 <cprintf>
	cprintf("Write/User Pages: %d\n",userWritePagesCounter);
80105be5:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105be9:	c7 04 24 19 7f 10 80 	movl   $0x80107f19,(%esp)
80105bf0:	e8 5b aa ff ff       	call   80100650 <cprintf>
	return presentPagesCounter;
}
80105bf5:	83 c4 1c             	add    $0x1c,%esp
80105bf8:	89 f0                	mov    %esi,%eax
80105bfa:	5b                   	pop    %ebx
80105bfb:	5e                   	pop    %esi
80105bfc:	5f                   	pop    %edi
80105bfd:	5d                   	pop    %ebp
80105bfe:	c3                   	ret    
80105bff:	90                   	nop

80105c00 <sys_fork>:

int
sys_fork(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105c03:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105c04:	e9 c7 dc ff ff       	jmp    801038d0 <fork>
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c10 <sys_exit>:
}

int
sys_exit(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c16:	e8 05 df ff ff       	call   80103b20 <exit>
  return 0;  // not reached
}
80105c1b:	31 c0                	xor    %eax,%eax
80105c1d:	c9                   	leave  
80105c1e:	c3                   	ret    
80105c1f:	90                   	nop

80105c20 <sys_wait>:

int
sys_wait(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105c23:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105c24:	e9 07 e1 ff ff       	jmp    80103d30 <wait>
80105c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c30 <sys_kill>:
}

int
sys_kill(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c39:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c44:	e8 a7 e9 ff ff       	call   801045f0 <argint>
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	78 13                	js     80105c60 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c50:	89 04 24             	mov    %eax,(%esp)
80105c53:	e8 18 e2 ff ff       	call   80103e70 <kill>
}
80105c58:	c9                   	leave  
80105c59:	c3                   	ret    
80105c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105c65:	c9                   	leave  
80105c66:	c3                   	ret    
80105c67:	89 f6                	mov    %esi,%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c70 <sys_getpid>:

int
sys_getpid(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c76:	e8 a5 da ff ff       	call   80103720 <myproc>
80105c7b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c7e:	c9                   	leave  
80105c7f:	c3                   	ret    

80105c80 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	53                   	push   %ebx
80105c84:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c87:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c95:	e8 56 e9 ff ff       	call   801045f0 <argint>
80105c9a:	85 c0                	test   %eax,%eax
80105c9c:	78 22                	js     80105cc0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c9e:	e8 7d da ff ff       	call   80103720 <myproc>
  if(growproc(n) < 0)
80105ca3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105ca6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ca8:	89 14 24             	mov    %edx,(%esp)
80105cab:	e8 b0 db ff ff       	call   80103860 <growproc>
80105cb0:	85 c0                	test   %eax,%eax
80105cb2:	78 0c                	js     80105cc0 <sys_sbrk+0x40>
    return -1;
  return addr;
80105cb4:	89 d8                	mov    %ebx,%eax
}
80105cb6:	83 c4 24             	add    $0x24,%esp
80105cb9:	5b                   	pop    %ebx
80105cba:	5d                   	pop    %ebp
80105cbb:	c3                   	ret    
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc5:	eb ef                	jmp    80105cb6 <sys_sbrk+0x36>
80105cc7:	89 f6                	mov    %esi,%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cd0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	53                   	push   %ebx
80105cd4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105cd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cda:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ce5:	e8 06 e9 ff ff       	call   801045f0 <argint>
80105cea:	85 c0                	test   %eax,%eax
80105cec:	78 7e                	js     80105d6c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
80105cee:	c7 04 24 c0 65 11 80 	movl   $0x801165c0,(%esp)
80105cf5:	e8 c6 e4 ff ff       	call   801041c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105cfd:	8b 1d 00 6e 11 80    	mov    0x80116e00,%ebx
  while(ticks - ticks0 < n){
80105d03:	85 d2                	test   %edx,%edx
80105d05:	75 29                	jne    80105d30 <sys_sleep+0x60>
80105d07:	eb 4f                	jmp    80105d58 <sys_sleep+0x88>
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d10:	c7 44 24 04 c0 65 11 	movl   $0x801165c0,0x4(%esp)
80105d17:	80 
80105d18:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)
80105d1f:	e8 5c df ff ff       	call   80103c80 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d24:	a1 00 6e 11 80       	mov    0x80116e00,%eax
80105d29:	29 d8                	sub    %ebx,%eax
80105d2b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d2e:	73 28                	jae    80105d58 <sys_sleep+0x88>
    if(myproc()->killed){
80105d30:	e8 eb d9 ff ff       	call   80103720 <myproc>
80105d35:	8b 40 24             	mov    0x24(%eax),%eax
80105d38:	85 c0                	test   %eax,%eax
80105d3a:	74 d4                	je     80105d10 <sys_sleep+0x40>
      release(&tickslock);
80105d3c:	c7 04 24 c0 65 11 80 	movl   $0x801165c0,(%esp)
80105d43:	e8 68 e5 ff ff       	call   801042b0 <release>
      return -1;
80105d48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105d4d:	83 c4 24             	add    $0x24,%esp
80105d50:	5b                   	pop    %ebx
80105d51:	5d                   	pop    %ebp
80105d52:	c3                   	ret    
80105d53:	90                   	nop
80105d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105d58:	c7 04 24 c0 65 11 80 	movl   $0x801165c0,(%esp)
80105d5f:	e8 4c e5 ff ff       	call   801042b0 <release>
  return 0;
}
80105d64:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105d67:	31 c0                	xor    %eax,%eax
}
80105d69:	5b                   	pop    %ebx
80105d6a:	5d                   	pop    %ebp
80105d6b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105d6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d71:	eb da                	jmp    80105d4d <sys_sleep+0x7d>
80105d73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	53                   	push   %ebx
80105d84:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105d87:	c7 04 24 c0 65 11 80 	movl   $0x801165c0,(%esp)
80105d8e:	e8 2d e4 ff ff       	call   801041c0 <acquire>
  xticks = ticks;
80105d93:	8b 1d 00 6e 11 80    	mov    0x80116e00,%ebx
  release(&tickslock);
80105d99:	c7 04 24 c0 65 11 80 	movl   $0x801165c0,(%esp)
80105da0:	e8 0b e5 ff ff       	call   801042b0 <release>
  return xticks;
}
80105da5:	83 c4 14             	add    $0x14,%esp
80105da8:	89 d8                	mov    %ebx,%eax
80105daa:	5b                   	pop    %ebx
80105dab:	5d                   	pop    %ebp
80105dac:	c3                   	ret    

80105dad <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105dad:	1e                   	push   %ds
  pushl %es
80105dae:	06                   	push   %es
  pushl %fs
80105daf:	0f a0                	push   %fs
  pushl %gs
80105db1:	0f a8                	push   %gs
  pushal
80105db3:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105db4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105db8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105dba:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105dbc:	54                   	push   %esp
  call trap
80105dbd:	e8 de 00 00 00       	call   80105ea0 <trap>
  addl $4, %esp
80105dc2:	83 c4 04             	add    $0x4,%esp

80105dc5 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105dc5:	61                   	popa   
  popl %gs
80105dc6:	0f a9                	pop    %gs
  popl %fs
80105dc8:	0f a1                	pop    %fs
  popl %es
80105dca:	07                   	pop    %es
  popl %ds
80105dcb:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105dcc:	83 c4 08             	add    $0x8,%esp
  iret
80105dcf:	cf                   	iret   

80105dd0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105dd0:	31 c0                	xor    %eax,%eax
80105dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105dd8:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ddf:	b9 08 00 00 00       	mov    $0x8,%ecx
80105de4:	66 89 0c c5 02 66 11 	mov    %cx,-0x7fee99fe(,%eax,8)
80105deb:	80 
80105dec:	c6 04 c5 04 66 11 80 	movb   $0x0,-0x7fee99fc(,%eax,8)
80105df3:	00 
80105df4:	c6 04 c5 05 66 11 80 	movb   $0x8e,-0x7fee99fb(,%eax,8)
80105dfb:	8e 
80105dfc:	66 89 14 c5 00 66 11 	mov    %dx,-0x7fee9a00(,%eax,8)
80105e03:	80 
80105e04:	c1 ea 10             	shr    $0x10,%edx
80105e07:	66 89 14 c5 06 66 11 	mov    %dx,-0x7fee99fa(,%eax,8)
80105e0e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105e0f:	83 c0 01             	add    $0x1,%eax
80105e12:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e17:	75 bf                	jne    80105dd8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e19:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e1a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e1f:	89 e5                	mov    %esp,%ebp
80105e21:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e24:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105e29:	c7 44 24 04 2f 7f 10 	movl   $0x80107f2f,0x4(%esp)
80105e30:	80 
80105e31:	c7 04 24 c0 65 11 80 	movl   $0x801165c0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e38:	66 89 15 02 68 11 80 	mov    %dx,0x80116802
80105e3f:	66 a3 00 68 11 80    	mov    %ax,0x80116800
80105e45:	c1 e8 10             	shr    $0x10,%eax
80105e48:	c6 05 04 68 11 80 00 	movb   $0x0,0x80116804
80105e4f:	c6 05 05 68 11 80 ef 	movb   $0xef,0x80116805
80105e56:	66 a3 06 68 11 80    	mov    %ax,0x80116806

  initlock(&tickslock, "time");
80105e5c:	e8 6f e2 ff ff       	call   801040d0 <initlock>
}
80105e61:	c9                   	leave  
80105e62:	c3                   	ret    
80105e63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e70 <idtinit>:

void
idtinit(void)
{
80105e70:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105e71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e76:	89 e5                	mov    %esp,%ebp
80105e78:	83 ec 10             	sub    $0x10,%esp
80105e7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e7f:	b8 00 66 11 80       	mov    $0x80116600,%eax
80105e84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e88:	c1 e8 10             	shr    $0x10,%eax
80105e8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105e8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    
80105e97:	89 f6                	mov    %esi,%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ea0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	57                   	push   %edi
80105ea4:	56                   	push   %esi
80105ea5:	53                   	push   %ebx
80105ea6:	83 ec 3c             	sub    $0x3c,%esp
80105ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105eac:	8b 43 30             	mov    0x30(%ebx),%eax
80105eaf:	83 f8 40             	cmp    $0x40,%eax
80105eb2:	0f 84 a0 01 00 00    	je     80106058 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105eb8:	83 e8 20             	sub    $0x20,%eax
80105ebb:	83 f8 1f             	cmp    $0x1f,%eax
80105ebe:	77 08                	ja     80105ec8 <trap+0x28>
80105ec0:	ff 24 85 d8 7f 10 80 	jmp    *-0x7fef8028(,%eax,4)
80105ec7:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ec8:	e8 53 d8 ff ff       	call   80103720 <myproc>
80105ecd:	85 c0                	test   %eax,%eax
80105ecf:	90                   	nop
80105ed0:	0f 84 fa 01 00 00    	je     801060d0 <trap+0x230>
80105ed6:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105eda:	0f 84 f0 01 00 00    	je     801060d0 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ee0:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ee3:	8b 53 38             	mov    0x38(%ebx),%edx
80105ee6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105ee9:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105eec:	e8 0f d8 ff ff       	call   80103700 <cpuid>
80105ef1:	8b 73 30             	mov    0x30(%ebx),%esi
80105ef4:	89 c7                	mov    %eax,%edi
80105ef6:	8b 43 34             	mov    0x34(%ebx),%eax
80105ef9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105efc:	e8 1f d8 ff ff       	call   80103720 <myproc>
80105f01:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f04:	e8 17 d8 ff ff       	call   80103720 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f09:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f0c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f10:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f13:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f16:	89 7c 24 14          	mov    %edi,0x14(%esp)
80105f1a:	89 54 24 18          	mov    %edx,0x18(%esp)
80105f1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f21:	83 c6 6c             	add    $0x6c,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f24:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f28:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f2c:	89 54 24 10          	mov    %edx,0x10(%esp)
80105f30:	8b 40 10             	mov    0x10(%eax),%eax
80105f33:	c7 04 24 94 7f 10 80 	movl   $0x80107f94,(%esp)
80105f3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f3e:	e8 0d a7 ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105f43:	e8 d8 d7 ff ff       	call   80103720 <myproc>
80105f48:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105f4f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f50:	e8 cb d7 ff ff       	call   80103720 <myproc>
80105f55:	85 c0                	test   %eax,%eax
80105f57:	74 0c                	je     80105f65 <trap+0xc5>
80105f59:	e8 c2 d7 ff ff       	call   80103720 <myproc>
80105f5e:	8b 50 24             	mov    0x24(%eax),%edx
80105f61:	85 d2                	test   %edx,%edx
80105f63:	75 4b                	jne    80105fb0 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105f65:	e8 b6 d7 ff ff       	call   80103720 <myproc>
80105f6a:	85 c0                	test   %eax,%eax
80105f6c:	74 0d                	je     80105f7b <trap+0xdb>
80105f6e:	66 90                	xchg   %ax,%ax
80105f70:	e8 ab d7 ff ff       	call   80103720 <myproc>
80105f75:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f79:	74 4d                	je     80105fc8 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f7b:	e8 a0 d7 ff ff       	call   80103720 <myproc>
80105f80:	85 c0                	test   %eax,%eax
80105f82:	74 1d                	je     80105fa1 <trap+0x101>
80105f84:	e8 97 d7 ff ff       	call   80103720 <myproc>
80105f89:	8b 40 24             	mov    0x24(%eax),%eax
80105f8c:	85 c0                	test   %eax,%eax
80105f8e:	74 11                	je     80105fa1 <trap+0x101>
80105f90:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f94:	83 e0 03             	and    $0x3,%eax
80105f97:	66 83 f8 03          	cmp    $0x3,%ax
80105f9b:	0f 84 e8 00 00 00    	je     80106089 <trap+0x1e9>
    exit();
}
80105fa1:	83 c4 3c             	add    $0x3c,%esp
80105fa4:	5b                   	pop    %ebx
80105fa5:	5e                   	pop    %esi
80105fa6:	5f                   	pop    %edi
80105fa7:	5d                   	pop    %ebp
80105fa8:	c3                   	ret    
80105fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fb0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105fb4:	83 e0 03             	and    $0x3,%eax
80105fb7:	66 83 f8 03          	cmp    $0x3,%ax
80105fbb:	75 a8                	jne    80105f65 <trap+0xc5>
    exit();
80105fbd:	e8 5e db ff ff       	call   80103b20 <exit>
80105fc2:	eb a1                	jmp    80105f65 <trap+0xc5>
80105fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105fc8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fd0:	75 a9                	jne    80105f7b <trap+0xdb>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105fd2:	e8 69 dc ff ff       	call   80103c40 <yield>
80105fd7:	eb a2                	jmp    80105f7b <trap+0xdb>
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105fe0:	e8 1b d7 ff ff       	call   80103700 <cpuid>
80105fe5:	85 c0                	test   %eax,%eax
80105fe7:	0f 84 b3 00 00 00    	je     801060a0 <trap+0x200>
80105fed:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105ff0:	e8 0b c8 ff ff       	call   80102800 <lapiceoi>
    break;
80105ff5:	e9 56 ff ff ff       	jmp    80105f50 <trap+0xb0>
80105ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106000:	e8 4b c6 ff ff       	call   80102650 <kbdintr>
    lapiceoi();
80106005:	e8 f6 c7 ff ff       	call   80102800 <lapiceoi>
    break;
8010600a:	e9 41 ff ff ff       	jmp    80105f50 <trap+0xb0>
8010600f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106010:	e8 1b 02 00 00       	call   80106230 <uartintr>
    lapiceoi();
80106015:	e8 e6 c7 ff ff       	call   80102800 <lapiceoi>
    break;
8010601a:	e9 31 ff ff ff       	jmp    80105f50 <trap+0xb0>
8010601f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106020:	8b 7b 38             	mov    0x38(%ebx),%edi
80106023:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106027:	e8 d4 d6 ff ff       	call   80103700 <cpuid>
8010602c:	c7 04 24 3c 7f 10 80 	movl   $0x80107f3c,(%esp)
80106033:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106037:	89 74 24 08          	mov    %esi,0x8(%esp)
8010603b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010603f:	e8 0c a6 ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106044:	e8 b7 c7 ff ff       	call   80102800 <lapiceoi>
    break;
80106049:	e9 02 ff ff ff       	jmp    80105f50 <trap+0xb0>
8010604e:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106050:	e8 ab c0 ff ff       	call   80102100 <ideintr>
80106055:	eb 96                	jmp    80105fed <trap+0x14d>
80106057:	90                   	nop
80106058:	90                   	nop
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106060:	e8 bb d6 ff ff       	call   80103720 <myproc>
80106065:	8b 70 24             	mov    0x24(%eax),%esi
80106068:	85 f6                	test   %esi,%esi
8010606a:	75 2c                	jne    80106098 <trap+0x1f8>
      exit();
    myproc()->tf = tf;
8010606c:	e8 af d6 ff ff       	call   80103720 <myproc>
80106071:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106074:	e8 47 e6 ff ff       	call   801046c0 <syscall>
    if(myproc()->killed)
80106079:	e8 a2 d6 ff ff       	call   80103720 <myproc>
8010607e:	8b 48 24             	mov    0x24(%eax),%ecx
80106081:	85 c9                	test   %ecx,%ecx
80106083:	0f 84 18 ff ff ff    	je     80105fa1 <trap+0x101>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106089:	83 c4 3c             	add    $0x3c,%esp
8010608c:	5b                   	pop    %ebx
8010608d:	5e                   	pop    %esi
8010608e:	5f                   	pop    %edi
8010608f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106090:	e9 8b da ff ff       	jmp    80103b20 <exit>
80106095:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106098:	e8 83 da ff ff       	call   80103b20 <exit>
8010609d:	eb cd                	jmp    8010606c <trap+0x1cc>
8010609f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801060a0:	c7 04 24 c0 65 11 80 	movl   $0x801165c0,(%esp)
801060a7:	e8 14 e1 ff ff       	call   801041c0 <acquire>
      ticks++;
      wakeup(&ticks);
801060ac:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801060b3:	83 05 00 6e 11 80 01 	addl   $0x1,0x80116e00
      wakeup(&ticks);
801060ba:	e8 51 dd ff ff       	call   80103e10 <wakeup>
      release(&tickslock);
801060bf:	c7 04 24 c0 65 11 80 	movl   $0x801165c0,(%esp)
801060c6:	e8 e5 e1 ff ff       	call   801042b0 <release>
801060cb:	e9 1d ff ff ff       	jmp    80105fed <trap+0x14d>
801060d0:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060d3:	8b 73 38             	mov    0x38(%ebx),%esi
801060d6:	e8 25 d6 ff ff       	call   80103700 <cpuid>
801060db:	89 7c 24 10          	mov    %edi,0x10(%esp)
801060df:	89 74 24 0c          	mov    %esi,0xc(%esp)
801060e3:	89 44 24 08          	mov    %eax,0x8(%esp)
801060e7:	8b 43 30             	mov    0x30(%ebx),%eax
801060ea:	c7 04 24 60 7f 10 80 	movl   $0x80107f60,(%esp)
801060f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801060f5:	e8 56 a5 ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801060fa:	c7 04 24 34 7f 10 80 	movl   $0x80107f34,(%esp)
80106101:	e8 5a a2 ff ff       	call   80100360 <panic>
80106106:	66 90                	xchg   %ax,%ax
80106108:	66 90                	xchg   %ax,%ax
8010610a:	66 90                	xchg   %ax,%ax
8010610c:	66 90                	xchg   %ax,%ax
8010610e:	66 90                	xchg   %ax,%ax

80106110 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106110:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106115:	55                   	push   %ebp
80106116:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106118:	85 c0                	test   %eax,%eax
8010611a:	74 14                	je     80106130 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010611c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106121:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106122:	a8 01                	test   $0x1,%al
80106124:	74 0a                	je     80106130 <uartgetc+0x20>
80106126:	b2 f8                	mov    $0xf8,%dl
80106128:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106129:	0f b6 c0             	movzbl %al,%eax
}
8010612c:	5d                   	pop    %ebp
8010612d:	c3                   	ret    
8010612e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80106135:	5d                   	pop    %ebp
80106136:	c3                   	ret    
80106137:	89 f6                	mov    %esi,%esi
80106139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106140 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106140:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106145:	85 c0                	test   %eax,%eax
80106147:	74 3f                	je     80106188 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80106149:	55                   	push   %ebp
8010614a:	89 e5                	mov    %esp,%ebp
8010614c:	56                   	push   %esi
8010614d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106152:	53                   	push   %ebx
  int i;

  if(!uart)
80106153:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80106158:	83 ec 10             	sub    $0x10,%esp
8010615b:	eb 14                	jmp    80106171 <uartputc+0x31>
8010615d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106160:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106167:	e8 b4 c6 ff ff       	call   80102820 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010616c:	83 eb 01             	sub    $0x1,%ebx
8010616f:	74 07                	je     80106178 <uartputc+0x38>
80106171:	89 f2                	mov    %esi,%edx
80106173:	ec                   	in     (%dx),%al
80106174:	a8 20                	test   $0x20,%al
80106176:	74 e8                	je     80106160 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80106178:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010617c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106181:	ee                   	out    %al,(%dx)
}
80106182:	83 c4 10             	add    $0x10,%esp
80106185:	5b                   	pop    %ebx
80106186:	5e                   	pop    %esi
80106187:	5d                   	pop    %ebp
80106188:	f3 c3                	repz ret 
8010618a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106190 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106190:	55                   	push   %ebp
80106191:	31 c9                	xor    %ecx,%ecx
80106193:	89 e5                	mov    %esp,%ebp
80106195:	89 c8                	mov    %ecx,%eax
80106197:	57                   	push   %edi
80106198:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010619d:	56                   	push   %esi
8010619e:	89 fa                	mov    %edi,%edx
801061a0:	53                   	push   %ebx
801061a1:	83 ec 1c             	sub    $0x1c,%esp
801061a4:	ee                   	out    %al,(%dx)
801061a5:	be fb 03 00 00       	mov    $0x3fb,%esi
801061aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801061af:	89 f2                	mov    %esi,%edx
801061b1:	ee                   	out    %al,(%dx)
801061b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801061b7:	b2 f8                	mov    $0xf8,%dl
801061b9:	ee                   	out    %al,(%dx)
801061ba:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801061bf:	89 c8                	mov    %ecx,%eax
801061c1:	89 da                	mov    %ebx,%edx
801061c3:	ee                   	out    %al,(%dx)
801061c4:	b8 03 00 00 00       	mov    $0x3,%eax
801061c9:	89 f2                	mov    %esi,%edx
801061cb:	ee                   	out    %al,(%dx)
801061cc:	b2 fc                	mov    $0xfc,%dl
801061ce:	89 c8                	mov    %ecx,%eax
801061d0:	ee                   	out    %al,(%dx)
801061d1:	b8 01 00 00 00       	mov    $0x1,%eax
801061d6:	89 da                	mov    %ebx,%edx
801061d8:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061d9:	b2 fd                	mov    $0xfd,%dl
801061db:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801061dc:	3c ff                	cmp    $0xff,%al
801061de:	74 42                	je     80106222 <uartinit+0x92>
    return;
  uart = 1;
801061e0:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801061e7:	00 00 00 
801061ea:	89 fa                	mov    %edi,%edx
801061ec:	ec                   	in     (%dx),%al
801061ed:	b2 f8                	mov    $0xf8,%dl
801061ef:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801061f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801061f7:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801061f8:	bb 58 80 10 80       	mov    $0x80108058,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801061fd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106204:	e8 27 c1 ff ff       	call   80102330 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106209:	b8 78 00 00 00       	mov    $0x78,%eax
8010620e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80106210:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106213:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80106216:	e8 25 ff ff ff       	call   80106140 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010621b:	0f be 03             	movsbl (%ebx),%eax
8010621e:	84 c0                	test   %al,%al
80106220:	75 ee                	jne    80106210 <uartinit+0x80>
    uartputc(*p);
}
80106222:	83 c4 1c             	add    $0x1c,%esp
80106225:	5b                   	pop    %ebx
80106226:	5e                   	pop    %esi
80106227:	5f                   	pop    %edi
80106228:	5d                   	pop    %ebp
80106229:	c3                   	ret    
8010622a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106230 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106236:	c7 04 24 10 61 10 80 	movl   $0x80106110,(%esp)
8010623d:	e8 6e a5 ff ff       	call   801007b0 <consoleintr>
}
80106242:	c9                   	leave  
80106243:	c3                   	ret    

80106244 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $0
80106246:	6a 00                	push   $0x0
  jmp alltraps
80106248:	e9 60 fb ff ff       	jmp    80105dad <alltraps>

8010624d <vector1>:
.globl vector1
vector1:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $1
8010624f:	6a 01                	push   $0x1
  jmp alltraps
80106251:	e9 57 fb ff ff       	jmp    80105dad <alltraps>

80106256 <vector2>:
.globl vector2
vector2:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $2
80106258:	6a 02                	push   $0x2
  jmp alltraps
8010625a:	e9 4e fb ff ff       	jmp    80105dad <alltraps>

8010625f <vector3>:
.globl vector3
vector3:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $3
80106261:	6a 03                	push   $0x3
  jmp alltraps
80106263:	e9 45 fb ff ff       	jmp    80105dad <alltraps>

80106268 <vector4>:
.globl vector4
vector4:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $4
8010626a:	6a 04                	push   $0x4
  jmp alltraps
8010626c:	e9 3c fb ff ff       	jmp    80105dad <alltraps>

80106271 <vector5>:
.globl vector5
vector5:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $5
80106273:	6a 05                	push   $0x5
  jmp alltraps
80106275:	e9 33 fb ff ff       	jmp    80105dad <alltraps>

8010627a <vector6>:
.globl vector6
vector6:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $6
8010627c:	6a 06                	push   $0x6
  jmp alltraps
8010627e:	e9 2a fb ff ff       	jmp    80105dad <alltraps>

80106283 <vector7>:
.globl vector7
vector7:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $7
80106285:	6a 07                	push   $0x7
  jmp alltraps
80106287:	e9 21 fb ff ff       	jmp    80105dad <alltraps>

8010628c <vector8>:
.globl vector8
vector8:
  pushl $8
8010628c:	6a 08                	push   $0x8
  jmp alltraps
8010628e:	e9 1a fb ff ff       	jmp    80105dad <alltraps>

80106293 <vector9>:
.globl vector9
vector9:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $9
80106295:	6a 09                	push   $0x9
  jmp alltraps
80106297:	e9 11 fb ff ff       	jmp    80105dad <alltraps>

8010629c <vector10>:
.globl vector10
vector10:
  pushl $10
8010629c:	6a 0a                	push   $0xa
  jmp alltraps
8010629e:	e9 0a fb ff ff       	jmp    80105dad <alltraps>

801062a3 <vector11>:
.globl vector11
vector11:
  pushl $11
801062a3:	6a 0b                	push   $0xb
  jmp alltraps
801062a5:	e9 03 fb ff ff       	jmp    80105dad <alltraps>

801062aa <vector12>:
.globl vector12
vector12:
  pushl $12
801062aa:	6a 0c                	push   $0xc
  jmp alltraps
801062ac:	e9 fc fa ff ff       	jmp    80105dad <alltraps>

801062b1 <vector13>:
.globl vector13
vector13:
  pushl $13
801062b1:	6a 0d                	push   $0xd
  jmp alltraps
801062b3:	e9 f5 fa ff ff       	jmp    80105dad <alltraps>

801062b8 <vector14>:
.globl vector14
vector14:
  pushl $14
801062b8:	6a 0e                	push   $0xe
  jmp alltraps
801062ba:	e9 ee fa ff ff       	jmp    80105dad <alltraps>

801062bf <vector15>:
.globl vector15
vector15:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $15
801062c1:	6a 0f                	push   $0xf
  jmp alltraps
801062c3:	e9 e5 fa ff ff       	jmp    80105dad <alltraps>

801062c8 <vector16>:
.globl vector16
vector16:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $16
801062ca:	6a 10                	push   $0x10
  jmp alltraps
801062cc:	e9 dc fa ff ff       	jmp    80105dad <alltraps>

801062d1 <vector17>:
.globl vector17
vector17:
  pushl $17
801062d1:	6a 11                	push   $0x11
  jmp alltraps
801062d3:	e9 d5 fa ff ff       	jmp    80105dad <alltraps>

801062d8 <vector18>:
.globl vector18
vector18:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $18
801062da:	6a 12                	push   $0x12
  jmp alltraps
801062dc:	e9 cc fa ff ff       	jmp    80105dad <alltraps>

801062e1 <vector19>:
.globl vector19
vector19:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $19
801062e3:	6a 13                	push   $0x13
  jmp alltraps
801062e5:	e9 c3 fa ff ff       	jmp    80105dad <alltraps>

801062ea <vector20>:
.globl vector20
vector20:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $20
801062ec:	6a 14                	push   $0x14
  jmp alltraps
801062ee:	e9 ba fa ff ff       	jmp    80105dad <alltraps>

801062f3 <vector21>:
.globl vector21
vector21:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $21
801062f5:	6a 15                	push   $0x15
  jmp alltraps
801062f7:	e9 b1 fa ff ff       	jmp    80105dad <alltraps>

801062fc <vector22>:
.globl vector22
vector22:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $22
801062fe:	6a 16                	push   $0x16
  jmp alltraps
80106300:	e9 a8 fa ff ff       	jmp    80105dad <alltraps>

80106305 <vector23>:
.globl vector23
vector23:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $23
80106307:	6a 17                	push   $0x17
  jmp alltraps
80106309:	e9 9f fa ff ff       	jmp    80105dad <alltraps>

8010630e <vector24>:
.globl vector24
vector24:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $24
80106310:	6a 18                	push   $0x18
  jmp alltraps
80106312:	e9 96 fa ff ff       	jmp    80105dad <alltraps>

80106317 <vector25>:
.globl vector25
vector25:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $25
80106319:	6a 19                	push   $0x19
  jmp alltraps
8010631b:	e9 8d fa ff ff       	jmp    80105dad <alltraps>

80106320 <vector26>:
.globl vector26
vector26:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $26
80106322:	6a 1a                	push   $0x1a
  jmp alltraps
80106324:	e9 84 fa ff ff       	jmp    80105dad <alltraps>

80106329 <vector27>:
.globl vector27
vector27:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $27
8010632b:	6a 1b                	push   $0x1b
  jmp alltraps
8010632d:	e9 7b fa ff ff       	jmp    80105dad <alltraps>

80106332 <vector28>:
.globl vector28
vector28:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $28
80106334:	6a 1c                	push   $0x1c
  jmp alltraps
80106336:	e9 72 fa ff ff       	jmp    80105dad <alltraps>

8010633b <vector29>:
.globl vector29
vector29:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $29
8010633d:	6a 1d                	push   $0x1d
  jmp alltraps
8010633f:	e9 69 fa ff ff       	jmp    80105dad <alltraps>

80106344 <vector30>:
.globl vector30
vector30:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $30
80106346:	6a 1e                	push   $0x1e
  jmp alltraps
80106348:	e9 60 fa ff ff       	jmp    80105dad <alltraps>

8010634d <vector31>:
.globl vector31
vector31:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $31
8010634f:	6a 1f                	push   $0x1f
  jmp alltraps
80106351:	e9 57 fa ff ff       	jmp    80105dad <alltraps>

80106356 <vector32>:
.globl vector32
vector32:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $32
80106358:	6a 20                	push   $0x20
  jmp alltraps
8010635a:	e9 4e fa ff ff       	jmp    80105dad <alltraps>

8010635f <vector33>:
.globl vector33
vector33:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $33
80106361:	6a 21                	push   $0x21
  jmp alltraps
80106363:	e9 45 fa ff ff       	jmp    80105dad <alltraps>

80106368 <vector34>:
.globl vector34
vector34:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $34
8010636a:	6a 22                	push   $0x22
  jmp alltraps
8010636c:	e9 3c fa ff ff       	jmp    80105dad <alltraps>

80106371 <vector35>:
.globl vector35
vector35:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $35
80106373:	6a 23                	push   $0x23
  jmp alltraps
80106375:	e9 33 fa ff ff       	jmp    80105dad <alltraps>

8010637a <vector36>:
.globl vector36
vector36:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $36
8010637c:	6a 24                	push   $0x24
  jmp alltraps
8010637e:	e9 2a fa ff ff       	jmp    80105dad <alltraps>

80106383 <vector37>:
.globl vector37
vector37:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $37
80106385:	6a 25                	push   $0x25
  jmp alltraps
80106387:	e9 21 fa ff ff       	jmp    80105dad <alltraps>

8010638c <vector38>:
.globl vector38
vector38:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $38
8010638e:	6a 26                	push   $0x26
  jmp alltraps
80106390:	e9 18 fa ff ff       	jmp    80105dad <alltraps>

80106395 <vector39>:
.globl vector39
vector39:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $39
80106397:	6a 27                	push   $0x27
  jmp alltraps
80106399:	e9 0f fa ff ff       	jmp    80105dad <alltraps>

8010639e <vector40>:
.globl vector40
vector40:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $40
801063a0:	6a 28                	push   $0x28
  jmp alltraps
801063a2:	e9 06 fa ff ff       	jmp    80105dad <alltraps>

801063a7 <vector41>:
.globl vector41
vector41:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $41
801063a9:	6a 29                	push   $0x29
  jmp alltraps
801063ab:	e9 fd f9 ff ff       	jmp    80105dad <alltraps>

801063b0 <vector42>:
.globl vector42
vector42:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $42
801063b2:	6a 2a                	push   $0x2a
  jmp alltraps
801063b4:	e9 f4 f9 ff ff       	jmp    80105dad <alltraps>

801063b9 <vector43>:
.globl vector43
vector43:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $43
801063bb:	6a 2b                	push   $0x2b
  jmp alltraps
801063bd:	e9 eb f9 ff ff       	jmp    80105dad <alltraps>

801063c2 <vector44>:
.globl vector44
vector44:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $44
801063c4:	6a 2c                	push   $0x2c
  jmp alltraps
801063c6:	e9 e2 f9 ff ff       	jmp    80105dad <alltraps>

801063cb <vector45>:
.globl vector45
vector45:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $45
801063cd:	6a 2d                	push   $0x2d
  jmp alltraps
801063cf:	e9 d9 f9 ff ff       	jmp    80105dad <alltraps>

801063d4 <vector46>:
.globl vector46
vector46:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $46
801063d6:	6a 2e                	push   $0x2e
  jmp alltraps
801063d8:	e9 d0 f9 ff ff       	jmp    80105dad <alltraps>

801063dd <vector47>:
.globl vector47
vector47:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $47
801063df:	6a 2f                	push   $0x2f
  jmp alltraps
801063e1:	e9 c7 f9 ff ff       	jmp    80105dad <alltraps>

801063e6 <vector48>:
.globl vector48
vector48:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $48
801063e8:	6a 30                	push   $0x30
  jmp alltraps
801063ea:	e9 be f9 ff ff       	jmp    80105dad <alltraps>

801063ef <vector49>:
.globl vector49
vector49:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $49
801063f1:	6a 31                	push   $0x31
  jmp alltraps
801063f3:	e9 b5 f9 ff ff       	jmp    80105dad <alltraps>

801063f8 <vector50>:
.globl vector50
vector50:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $50
801063fa:	6a 32                	push   $0x32
  jmp alltraps
801063fc:	e9 ac f9 ff ff       	jmp    80105dad <alltraps>

80106401 <vector51>:
.globl vector51
vector51:
  pushl $0
80106401:	6a 00                	push   $0x0
  pushl $51
80106403:	6a 33                	push   $0x33
  jmp alltraps
80106405:	e9 a3 f9 ff ff       	jmp    80105dad <alltraps>

8010640a <vector52>:
.globl vector52
vector52:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $52
8010640c:	6a 34                	push   $0x34
  jmp alltraps
8010640e:	e9 9a f9 ff ff       	jmp    80105dad <alltraps>

80106413 <vector53>:
.globl vector53
vector53:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $53
80106415:	6a 35                	push   $0x35
  jmp alltraps
80106417:	e9 91 f9 ff ff       	jmp    80105dad <alltraps>

8010641c <vector54>:
.globl vector54
vector54:
  pushl $0
8010641c:	6a 00                	push   $0x0
  pushl $54
8010641e:	6a 36                	push   $0x36
  jmp alltraps
80106420:	e9 88 f9 ff ff       	jmp    80105dad <alltraps>

80106425 <vector55>:
.globl vector55
vector55:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $55
80106427:	6a 37                	push   $0x37
  jmp alltraps
80106429:	e9 7f f9 ff ff       	jmp    80105dad <alltraps>

8010642e <vector56>:
.globl vector56
vector56:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $56
80106430:	6a 38                	push   $0x38
  jmp alltraps
80106432:	e9 76 f9 ff ff       	jmp    80105dad <alltraps>

80106437 <vector57>:
.globl vector57
vector57:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $57
80106439:	6a 39                	push   $0x39
  jmp alltraps
8010643b:	e9 6d f9 ff ff       	jmp    80105dad <alltraps>

80106440 <vector58>:
.globl vector58
vector58:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $58
80106442:	6a 3a                	push   $0x3a
  jmp alltraps
80106444:	e9 64 f9 ff ff       	jmp    80105dad <alltraps>

80106449 <vector59>:
.globl vector59
vector59:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $59
8010644b:	6a 3b                	push   $0x3b
  jmp alltraps
8010644d:	e9 5b f9 ff ff       	jmp    80105dad <alltraps>

80106452 <vector60>:
.globl vector60
vector60:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $60
80106454:	6a 3c                	push   $0x3c
  jmp alltraps
80106456:	e9 52 f9 ff ff       	jmp    80105dad <alltraps>

8010645b <vector61>:
.globl vector61
vector61:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $61
8010645d:	6a 3d                	push   $0x3d
  jmp alltraps
8010645f:	e9 49 f9 ff ff       	jmp    80105dad <alltraps>

80106464 <vector62>:
.globl vector62
vector62:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $62
80106466:	6a 3e                	push   $0x3e
  jmp alltraps
80106468:	e9 40 f9 ff ff       	jmp    80105dad <alltraps>

8010646d <vector63>:
.globl vector63
vector63:
  pushl $0
8010646d:	6a 00                	push   $0x0
  pushl $63
8010646f:	6a 3f                	push   $0x3f
  jmp alltraps
80106471:	e9 37 f9 ff ff       	jmp    80105dad <alltraps>

80106476 <vector64>:
.globl vector64
vector64:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $64
80106478:	6a 40                	push   $0x40
  jmp alltraps
8010647a:	e9 2e f9 ff ff       	jmp    80105dad <alltraps>

8010647f <vector65>:
.globl vector65
vector65:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $65
80106481:	6a 41                	push   $0x41
  jmp alltraps
80106483:	e9 25 f9 ff ff       	jmp    80105dad <alltraps>

80106488 <vector66>:
.globl vector66
vector66:
  pushl $0
80106488:	6a 00                	push   $0x0
  pushl $66
8010648a:	6a 42                	push   $0x42
  jmp alltraps
8010648c:	e9 1c f9 ff ff       	jmp    80105dad <alltraps>

80106491 <vector67>:
.globl vector67
vector67:
  pushl $0
80106491:	6a 00                	push   $0x0
  pushl $67
80106493:	6a 43                	push   $0x43
  jmp alltraps
80106495:	e9 13 f9 ff ff       	jmp    80105dad <alltraps>

8010649a <vector68>:
.globl vector68
vector68:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $68
8010649c:	6a 44                	push   $0x44
  jmp alltraps
8010649e:	e9 0a f9 ff ff       	jmp    80105dad <alltraps>

801064a3 <vector69>:
.globl vector69
vector69:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $69
801064a5:	6a 45                	push   $0x45
  jmp alltraps
801064a7:	e9 01 f9 ff ff       	jmp    80105dad <alltraps>

801064ac <vector70>:
.globl vector70
vector70:
  pushl $0
801064ac:	6a 00                	push   $0x0
  pushl $70
801064ae:	6a 46                	push   $0x46
  jmp alltraps
801064b0:	e9 f8 f8 ff ff       	jmp    80105dad <alltraps>

801064b5 <vector71>:
.globl vector71
vector71:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $71
801064b7:	6a 47                	push   $0x47
  jmp alltraps
801064b9:	e9 ef f8 ff ff       	jmp    80105dad <alltraps>

801064be <vector72>:
.globl vector72
vector72:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $72
801064c0:	6a 48                	push   $0x48
  jmp alltraps
801064c2:	e9 e6 f8 ff ff       	jmp    80105dad <alltraps>

801064c7 <vector73>:
.globl vector73
vector73:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $73
801064c9:	6a 49                	push   $0x49
  jmp alltraps
801064cb:	e9 dd f8 ff ff       	jmp    80105dad <alltraps>

801064d0 <vector74>:
.globl vector74
vector74:
  pushl $0
801064d0:	6a 00                	push   $0x0
  pushl $74
801064d2:	6a 4a                	push   $0x4a
  jmp alltraps
801064d4:	e9 d4 f8 ff ff       	jmp    80105dad <alltraps>

801064d9 <vector75>:
.globl vector75
vector75:
  pushl $0
801064d9:	6a 00                	push   $0x0
  pushl $75
801064db:	6a 4b                	push   $0x4b
  jmp alltraps
801064dd:	e9 cb f8 ff ff       	jmp    80105dad <alltraps>

801064e2 <vector76>:
.globl vector76
vector76:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $76
801064e4:	6a 4c                	push   $0x4c
  jmp alltraps
801064e6:	e9 c2 f8 ff ff       	jmp    80105dad <alltraps>

801064eb <vector77>:
.globl vector77
vector77:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $77
801064ed:	6a 4d                	push   $0x4d
  jmp alltraps
801064ef:	e9 b9 f8 ff ff       	jmp    80105dad <alltraps>

801064f4 <vector78>:
.globl vector78
vector78:
  pushl $0
801064f4:	6a 00                	push   $0x0
  pushl $78
801064f6:	6a 4e                	push   $0x4e
  jmp alltraps
801064f8:	e9 b0 f8 ff ff       	jmp    80105dad <alltraps>

801064fd <vector79>:
.globl vector79
vector79:
  pushl $0
801064fd:	6a 00                	push   $0x0
  pushl $79
801064ff:	6a 4f                	push   $0x4f
  jmp alltraps
80106501:	e9 a7 f8 ff ff       	jmp    80105dad <alltraps>

80106506 <vector80>:
.globl vector80
vector80:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $80
80106508:	6a 50                	push   $0x50
  jmp alltraps
8010650a:	e9 9e f8 ff ff       	jmp    80105dad <alltraps>

8010650f <vector81>:
.globl vector81
vector81:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $81
80106511:	6a 51                	push   $0x51
  jmp alltraps
80106513:	e9 95 f8 ff ff       	jmp    80105dad <alltraps>

80106518 <vector82>:
.globl vector82
vector82:
  pushl $0
80106518:	6a 00                	push   $0x0
  pushl $82
8010651a:	6a 52                	push   $0x52
  jmp alltraps
8010651c:	e9 8c f8 ff ff       	jmp    80105dad <alltraps>

80106521 <vector83>:
.globl vector83
vector83:
  pushl $0
80106521:	6a 00                	push   $0x0
  pushl $83
80106523:	6a 53                	push   $0x53
  jmp alltraps
80106525:	e9 83 f8 ff ff       	jmp    80105dad <alltraps>

8010652a <vector84>:
.globl vector84
vector84:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $84
8010652c:	6a 54                	push   $0x54
  jmp alltraps
8010652e:	e9 7a f8 ff ff       	jmp    80105dad <alltraps>

80106533 <vector85>:
.globl vector85
vector85:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $85
80106535:	6a 55                	push   $0x55
  jmp alltraps
80106537:	e9 71 f8 ff ff       	jmp    80105dad <alltraps>

8010653c <vector86>:
.globl vector86
vector86:
  pushl $0
8010653c:	6a 00                	push   $0x0
  pushl $86
8010653e:	6a 56                	push   $0x56
  jmp alltraps
80106540:	e9 68 f8 ff ff       	jmp    80105dad <alltraps>

80106545 <vector87>:
.globl vector87
vector87:
  pushl $0
80106545:	6a 00                	push   $0x0
  pushl $87
80106547:	6a 57                	push   $0x57
  jmp alltraps
80106549:	e9 5f f8 ff ff       	jmp    80105dad <alltraps>

8010654e <vector88>:
.globl vector88
vector88:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $88
80106550:	6a 58                	push   $0x58
  jmp alltraps
80106552:	e9 56 f8 ff ff       	jmp    80105dad <alltraps>

80106557 <vector89>:
.globl vector89
vector89:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $89
80106559:	6a 59                	push   $0x59
  jmp alltraps
8010655b:	e9 4d f8 ff ff       	jmp    80105dad <alltraps>

80106560 <vector90>:
.globl vector90
vector90:
  pushl $0
80106560:	6a 00                	push   $0x0
  pushl $90
80106562:	6a 5a                	push   $0x5a
  jmp alltraps
80106564:	e9 44 f8 ff ff       	jmp    80105dad <alltraps>

80106569 <vector91>:
.globl vector91
vector91:
  pushl $0
80106569:	6a 00                	push   $0x0
  pushl $91
8010656b:	6a 5b                	push   $0x5b
  jmp alltraps
8010656d:	e9 3b f8 ff ff       	jmp    80105dad <alltraps>

80106572 <vector92>:
.globl vector92
vector92:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $92
80106574:	6a 5c                	push   $0x5c
  jmp alltraps
80106576:	e9 32 f8 ff ff       	jmp    80105dad <alltraps>

8010657b <vector93>:
.globl vector93
vector93:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $93
8010657d:	6a 5d                	push   $0x5d
  jmp alltraps
8010657f:	e9 29 f8 ff ff       	jmp    80105dad <alltraps>

80106584 <vector94>:
.globl vector94
vector94:
  pushl $0
80106584:	6a 00                	push   $0x0
  pushl $94
80106586:	6a 5e                	push   $0x5e
  jmp alltraps
80106588:	e9 20 f8 ff ff       	jmp    80105dad <alltraps>

8010658d <vector95>:
.globl vector95
vector95:
  pushl $0
8010658d:	6a 00                	push   $0x0
  pushl $95
8010658f:	6a 5f                	push   $0x5f
  jmp alltraps
80106591:	e9 17 f8 ff ff       	jmp    80105dad <alltraps>

80106596 <vector96>:
.globl vector96
vector96:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $96
80106598:	6a 60                	push   $0x60
  jmp alltraps
8010659a:	e9 0e f8 ff ff       	jmp    80105dad <alltraps>

8010659f <vector97>:
.globl vector97
vector97:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $97
801065a1:	6a 61                	push   $0x61
  jmp alltraps
801065a3:	e9 05 f8 ff ff       	jmp    80105dad <alltraps>

801065a8 <vector98>:
.globl vector98
vector98:
  pushl $0
801065a8:	6a 00                	push   $0x0
  pushl $98
801065aa:	6a 62                	push   $0x62
  jmp alltraps
801065ac:	e9 fc f7 ff ff       	jmp    80105dad <alltraps>

801065b1 <vector99>:
.globl vector99
vector99:
  pushl $0
801065b1:	6a 00                	push   $0x0
  pushl $99
801065b3:	6a 63                	push   $0x63
  jmp alltraps
801065b5:	e9 f3 f7 ff ff       	jmp    80105dad <alltraps>

801065ba <vector100>:
.globl vector100
vector100:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $100
801065bc:	6a 64                	push   $0x64
  jmp alltraps
801065be:	e9 ea f7 ff ff       	jmp    80105dad <alltraps>

801065c3 <vector101>:
.globl vector101
vector101:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $101
801065c5:	6a 65                	push   $0x65
  jmp alltraps
801065c7:	e9 e1 f7 ff ff       	jmp    80105dad <alltraps>

801065cc <vector102>:
.globl vector102
vector102:
  pushl $0
801065cc:	6a 00                	push   $0x0
  pushl $102
801065ce:	6a 66                	push   $0x66
  jmp alltraps
801065d0:	e9 d8 f7 ff ff       	jmp    80105dad <alltraps>

801065d5 <vector103>:
.globl vector103
vector103:
  pushl $0
801065d5:	6a 00                	push   $0x0
  pushl $103
801065d7:	6a 67                	push   $0x67
  jmp alltraps
801065d9:	e9 cf f7 ff ff       	jmp    80105dad <alltraps>

801065de <vector104>:
.globl vector104
vector104:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $104
801065e0:	6a 68                	push   $0x68
  jmp alltraps
801065e2:	e9 c6 f7 ff ff       	jmp    80105dad <alltraps>

801065e7 <vector105>:
.globl vector105
vector105:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $105
801065e9:	6a 69                	push   $0x69
  jmp alltraps
801065eb:	e9 bd f7 ff ff       	jmp    80105dad <alltraps>

801065f0 <vector106>:
.globl vector106
vector106:
  pushl $0
801065f0:	6a 00                	push   $0x0
  pushl $106
801065f2:	6a 6a                	push   $0x6a
  jmp alltraps
801065f4:	e9 b4 f7 ff ff       	jmp    80105dad <alltraps>

801065f9 <vector107>:
.globl vector107
vector107:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $107
801065fb:	6a 6b                	push   $0x6b
  jmp alltraps
801065fd:	e9 ab f7 ff ff       	jmp    80105dad <alltraps>

80106602 <vector108>:
.globl vector108
vector108:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $108
80106604:	6a 6c                	push   $0x6c
  jmp alltraps
80106606:	e9 a2 f7 ff ff       	jmp    80105dad <alltraps>

8010660b <vector109>:
.globl vector109
vector109:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $109
8010660d:	6a 6d                	push   $0x6d
  jmp alltraps
8010660f:	e9 99 f7 ff ff       	jmp    80105dad <alltraps>

80106614 <vector110>:
.globl vector110
vector110:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $110
80106616:	6a 6e                	push   $0x6e
  jmp alltraps
80106618:	e9 90 f7 ff ff       	jmp    80105dad <alltraps>

8010661d <vector111>:
.globl vector111
vector111:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $111
8010661f:	6a 6f                	push   $0x6f
  jmp alltraps
80106621:	e9 87 f7 ff ff       	jmp    80105dad <alltraps>

80106626 <vector112>:
.globl vector112
vector112:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $112
80106628:	6a 70                	push   $0x70
  jmp alltraps
8010662a:	e9 7e f7 ff ff       	jmp    80105dad <alltraps>

8010662f <vector113>:
.globl vector113
vector113:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $113
80106631:	6a 71                	push   $0x71
  jmp alltraps
80106633:	e9 75 f7 ff ff       	jmp    80105dad <alltraps>

80106638 <vector114>:
.globl vector114
vector114:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $114
8010663a:	6a 72                	push   $0x72
  jmp alltraps
8010663c:	e9 6c f7 ff ff       	jmp    80105dad <alltraps>

80106641 <vector115>:
.globl vector115
vector115:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $115
80106643:	6a 73                	push   $0x73
  jmp alltraps
80106645:	e9 63 f7 ff ff       	jmp    80105dad <alltraps>

8010664a <vector116>:
.globl vector116
vector116:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $116
8010664c:	6a 74                	push   $0x74
  jmp alltraps
8010664e:	e9 5a f7 ff ff       	jmp    80105dad <alltraps>

80106653 <vector117>:
.globl vector117
vector117:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $117
80106655:	6a 75                	push   $0x75
  jmp alltraps
80106657:	e9 51 f7 ff ff       	jmp    80105dad <alltraps>

8010665c <vector118>:
.globl vector118
vector118:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $118
8010665e:	6a 76                	push   $0x76
  jmp alltraps
80106660:	e9 48 f7 ff ff       	jmp    80105dad <alltraps>

80106665 <vector119>:
.globl vector119
vector119:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $119
80106667:	6a 77                	push   $0x77
  jmp alltraps
80106669:	e9 3f f7 ff ff       	jmp    80105dad <alltraps>

8010666e <vector120>:
.globl vector120
vector120:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $120
80106670:	6a 78                	push   $0x78
  jmp alltraps
80106672:	e9 36 f7 ff ff       	jmp    80105dad <alltraps>

80106677 <vector121>:
.globl vector121
vector121:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $121
80106679:	6a 79                	push   $0x79
  jmp alltraps
8010667b:	e9 2d f7 ff ff       	jmp    80105dad <alltraps>

80106680 <vector122>:
.globl vector122
vector122:
  pushl $0
80106680:	6a 00                	push   $0x0
  pushl $122
80106682:	6a 7a                	push   $0x7a
  jmp alltraps
80106684:	e9 24 f7 ff ff       	jmp    80105dad <alltraps>

80106689 <vector123>:
.globl vector123
vector123:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $123
8010668b:	6a 7b                	push   $0x7b
  jmp alltraps
8010668d:	e9 1b f7 ff ff       	jmp    80105dad <alltraps>

80106692 <vector124>:
.globl vector124
vector124:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $124
80106694:	6a 7c                	push   $0x7c
  jmp alltraps
80106696:	e9 12 f7 ff ff       	jmp    80105dad <alltraps>

8010669b <vector125>:
.globl vector125
vector125:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $125
8010669d:	6a 7d                	push   $0x7d
  jmp alltraps
8010669f:	e9 09 f7 ff ff       	jmp    80105dad <alltraps>

801066a4 <vector126>:
.globl vector126
vector126:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $126
801066a6:	6a 7e                	push   $0x7e
  jmp alltraps
801066a8:	e9 00 f7 ff ff       	jmp    80105dad <alltraps>

801066ad <vector127>:
.globl vector127
vector127:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $127
801066af:	6a 7f                	push   $0x7f
  jmp alltraps
801066b1:	e9 f7 f6 ff ff       	jmp    80105dad <alltraps>

801066b6 <vector128>:
.globl vector128
vector128:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $128
801066b8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066bd:	e9 eb f6 ff ff       	jmp    80105dad <alltraps>

801066c2 <vector129>:
.globl vector129
vector129:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $129
801066c4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066c9:	e9 df f6 ff ff       	jmp    80105dad <alltraps>

801066ce <vector130>:
.globl vector130
vector130:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $130
801066d0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066d5:	e9 d3 f6 ff ff       	jmp    80105dad <alltraps>

801066da <vector131>:
.globl vector131
vector131:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $131
801066dc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066e1:	e9 c7 f6 ff ff       	jmp    80105dad <alltraps>

801066e6 <vector132>:
.globl vector132
vector132:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $132
801066e8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066ed:	e9 bb f6 ff ff       	jmp    80105dad <alltraps>

801066f2 <vector133>:
.globl vector133
vector133:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $133
801066f4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066f9:	e9 af f6 ff ff       	jmp    80105dad <alltraps>

801066fe <vector134>:
.globl vector134
vector134:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $134
80106700:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106705:	e9 a3 f6 ff ff       	jmp    80105dad <alltraps>

8010670a <vector135>:
.globl vector135
vector135:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $135
8010670c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106711:	e9 97 f6 ff ff       	jmp    80105dad <alltraps>

80106716 <vector136>:
.globl vector136
vector136:
  pushl $0
80106716:	6a 00                	push   $0x0
  pushl $136
80106718:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010671d:	e9 8b f6 ff ff       	jmp    80105dad <alltraps>

80106722 <vector137>:
.globl vector137
vector137:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $137
80106724:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106729:	e9 7f f6 ff ff       	jmp    80105dad <alltraps>

8010672e <vector138>:
.globl vector138
vector138:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $138
80106730:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106735:	e9 73 f6 ff ff       	jmp    80105dad <alltraps>

8010673a <vector139>:
.globl vector139
vector139:
  pushl $0
8010673a:	6a 00                	push   $0x0
  pushl $139
8010673c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106741:	e9 67 f6 ff ff       	jmp    80105dad <alltraps>

80106746 <vector140>:
.globl vector140
vector140:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $140
80106748:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010674d:	e9 5b f6 ff ff       	jmp    80105dad <alltraps>

80106752 <vector141>:
.globl vector141
vector141:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $141
80106754:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106759:	e9 4f f6 ff ff       	jmp    80105dad <alltraps>

8010675e <vector142>:
.globl vector142
vector142:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $142
80106760:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106765:	e9 43 f6 ff ff       	jmp    80105dad <alltraps>

8010676a <vector143>:
.globl vector143
vector143:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $143
8010676c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106771:	e9 37 f6 ff ff       	jmp    80105dad <alltraps>

80106776 <vector144>:
.globl vector144
vector144:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $144
80106778:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010677d:	e9 2b f6 ff ff       	jmp    80105dad <alltraps>

80106782 <vector145>:
.globl vector145
vector145:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $145
80106784:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106789:	e9 1f f6 ff ff       	jmp    80105dad <alltraps>

8010678e <vector146>:
.globl vector146
vector146:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $146
80106790:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106795:	e9 13 f6 ff ff       	jmp    80105dad <alltraps>

8010679a <vector147>:
.globl vector147
vector147:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $147
8010679c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067a1:	e9 07 f6 ff ff       	jmp    80105dad <alltraps>

801067a6 <vector148>:
.globl vector148
vector148:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $148
801067a8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067ad:	e9 fb f5 ff ff       	jmp    80105dad <alltraps>

801067b2 <vector149>:
.globl vector149
vector149:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $149
801067b4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067b9:	e9 ef f5 ff ff       	jmp    80105dad <alltraps>

801067be <vector150>:
.globl vector150
vector150:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $150
801067c0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067c5:	e9 e3 f5 ff ff       	jmp    80105dad <alltraps>

801067ca <vector151>:
.globl vector151
vector151:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $151
801067cc:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067d1:	e9 d7 f5 ff ff       	jmp    80105dad <alltraps>

801067d6 <vector152>:
.globl vector152
vector152:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $152
801067d8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067dd:	e9 cb f5 ff ff       	jmp    80105dad <alltraps>

801067e2 <vector153>:
.globl vector153
vector153:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $153
801067e4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067e9:	e9 bf f5 ff ff       	jmp    80105dad <alltraps>

801067ee <vector154>:
.globl vector154
vector154:
  pushl $0
801067ee:	6a 00                	push   $0x0
  pushl $154
801067f0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067f5:	e9 b3 f5 ff ff       	jmp    80105dad <alltraps>

801067fa <vector155>:
.globl vector155
vector155:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $155
801067fc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106801:	e9 a7 f5 ff ff       	jmp    80105dad <alltraps>

80106806 <vector156>:
.globl vector156
vector156:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $156
80106808:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010680d:	e9 9b f5 ff ff       	jmp    80105dad <alltraps>

80106812 <vector157>:
.globl vector157
vector157:
  pushl $0
80106812:	6a 00                	push   $0x0
  pushl $157
80106814:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106819:	e9 8f f5 ff ff       	jmp    80105dad <alltraps>

8010681e <vector158>:
.globl vector158
vector158:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $158
80106820:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106825:	e9 83 f5 ff ff       	jmp    80105dad <alltraps>

8010682a <vector159>:
.globl vector159
vector159:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $159
8010682c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106831:	e9 77 f5 ff ff       	jmp    80105dad <alltraps>

80106836 <vector160>:
.globl vector160
vector160:
  pushl $0
80106836:	6a 00                	push   $0x0
  pushl $160
80106838:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010683d:	e9 6b f5 ff ff       	jmp    80105dad <alltraps>

80106842 <vector161>:
.globl vector161
vector161:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $161
80106844:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106849:	e9 5f f5 ff ff       	jmp    80105dad <alltraps>

8010684e <vector162>:
.globl vector162
vector162:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $162
80106850:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106855:	e9 53 f5 ff ff       	jmp    80105dad <alltraps>

8010685a <vector163>:
.globl vector163
vector163:
  pushl $0
8010685a:	6a 00                	push   $0x0
  pushl $163
8010685c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106861:	e9 47 f5 ff ff       	jmp    80105dad <alltraps>

80106866 <vector164>:
.globl vector164
vector164:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $164
80106868:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010686d:	e9 3b f5 ff ff       	jmp    80105dad <alltraps>

80106872 <vector165>:
.globl vector165
vector165:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $165
80106874:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106879:	e9 2f f5 ff ff       	jmp    80105dad <alltraps>

8010687e <vector166>:
.globl vector166
vector166:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $166
80106880:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106885:	e9 23 f5 ff ff       	jmp    80105dad <alltraps>

8010688a <vector167>:
.globl vector167
vector167:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $167
8010688c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106891:	e9 17 f5 ff ff       	jmp    80105dad <alltraps>

80106896 <vector168>:
.globl vector168
vector168:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $168
80106898:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010689d:	e9 0b f5 ff ff       	jmp    80105dad <alltraps>

801068a2 <vector169>:
.globl vector169
vector169:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $169
801068a4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068a9:	e9 ff f4 ff ff       	jmp    80105dad <alltraps>

801068ae <vector170>:
.globl vector170
vector170:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $170
801068b0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068b5:	e9 f3 f4 ff ff       	jmp    80105dad <alltraps>

801068ba <vector171>:
.globl vector171
vector171:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $171
801068bc:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068c1:	e9 e7 f4 ff ff       	jmp    80105dad <alltraps>

801068c6 <vector172>:
.globl vector172
vector172:
  pushl $0
801068c6:	6a 00                	push   $0x0
  pushl $172
801068c8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068cd:	e9 db f4 ff ff       	jmp    80105dad <alltraps>

801068d2 <vector173>:
.globl vector173
vector173:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $173
801068d4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068d9:	e9 cf f4 ff ff       	jmp    80105dad <alltraps>

801068de <vector174>:
.globl vector174
vector174:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $174
801068e0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068e5:	e9 c3 f4 ff ff       	jmp    80105dad <alltraps>

801068ea <vector175>:
.globl vector175
vector175:
  pushl $0
801068ea:	6a 00                	push   $0x0
  pushl $175
801068ec:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068f1:	e9 b7 f4 ff ff       	jmp    80105dad <alltraps>

801068f6 <vector176>:
.globl vector176
vector176:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $176
801068f8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068fd:	e9 ab f4 ff ff       	jmp    80105dad <alltraps>

80106902 <vector177>:
.globl vector177
vector177:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $177
80106904:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106909:	e9 9f f4 ff ff       	jmp    80105dad <alltraps>

8010690e <vector178>:
.globl vector178
vector178:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $178
80106910:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106915:	e9 93 f4 ff ff       	jmp    80105dad <alltraps>

8010691a <vector179>:
.globl vector179
vector179:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $179
8010691c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106921:	e9 87 f4 ff ff       	jmp    80105dad <alltraps>

80106926 <vector180>:
.globl vector180
vector180:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $180
80106928:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010692d:	e9 7b f4 ff ff       	jmp    80105dad <alltraps>

80106932 <vector181>:
.globl vector181
vector181:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $181
80106934:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106939:	e9 6f f4 ff ff       	jmp    80105dad <alltraps>

8010693e <vector182>:
.globl vector182
vector182:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $182
80106940:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106945:	e9 63 f4 ff ff       	jmp    80105dad <alltraps>

8010694a <vector183>:
.globl vector183
vector183:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $183
8010694c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106951:	e9 57 f4 ff ff       	jmp    80105dad <alltraps>

80106956 <vector184>:
.globl vector184
vector184:
  pushl $0
80106956:	6a 00                	push   $0x0
  pushl $184
80106958:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010695d:	e9 4b f4 ff ff       	jmp    80105dad <alltraps>

80106962 <vector185>:
.globl vector185
vector185:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $185
80106964:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106969:	e9 3f f4 ff ff       	jmp    80105dad <alltraps>

8010696e <vector186>:
.globl vector186
vector186:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $186
80106970:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106975:	e9 33 f4 ff ff       	jmp    80105dad <alltraps>

8010697a <vector187>:
.globl vector187
vector187:
  pushl $0
8010697a:	6a 00                	push   $0x0
  pushl $187
8010697c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106981:	e9 27 f4 ff ff       	jmp    80105dad <alltraps>

80106986 <vector188>:
.globl vector188
vector188:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $188
80106988:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010698d:	e9 1b f4 ff ff       	jmp    80105dad <alltraps>

80106992 <vector189>:
.globl vector189
vector189:
  pushl $0
80106992:	6a 00                	push   $0x0
  pushl $189
80106994:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106999:	e9 0f f4 ff ff       	jmp    80105dad <alltraps>

8010699e <vector190>:
.globl vector190
vector190:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $190
801069a0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069a5:	e9 03 f4 ff ff       	jmp    80105dad <alltraps>

801069aa <vector191>:
.globl vector191
vector191:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $191
801069ac:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069b1:	e9 f7 f3 ff ff       	jmp    80105dad <alltraps>

801069b6 <vector192>:
.globl vector192
vector192:
  pushl $0
801069b6:	6a 00                	push   $0x0
  pushl $192
801069b8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069bd:	e9 eb f3 ff ff       	jmp    80105dad <alltraps>

801069c2 <vector193>:
.globl vector193
vector193:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $193
801069c4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069c9:	e9 df f3 ff ff       	jmp    80105dad <alltraps>

801069ce <vector194>:
.globl vector194
vector194:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $194
801069d0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069d5:	e9 d3 f3 ff ff       	jmp    80105dad <alltraps>

801069da <vector195>:
.globl vector195
vector195:
  pushl $0
801069da:	6a 00                	push   $0x0
  pushl $195
801069dc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069e1:	e9 c7 f3 ff ff       	jmp    80105dad <alltraps>

801069e6 <vector196>:
.globl vector196
vector196:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $196
801069e8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069ed:	e9 bb f3 ff ff       	jmp    80105dad <alltraps>

801069f2 <vector197>:
.globl vector197
vector197:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $197
801069f4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069f9:	e9 af f3 ff ff       	jmp    80105dad <alltraps>

801069fe <vector198>:
.globl vector198
vector198:
  pushl $0
801069fe:	6a 00                	push   $0x0
  pushl $198
80106a00:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a05:	e9 a3 f3 ff ff       	jmp    80105dad <alltraps>

80106a0a <vector199>:
.globl vector199
vector199:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $199
80106a0c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a11:	e9 97 f3 ff ff       	jmp    80105dad <alltraps>

80106a16 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $200
80106a18:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a1d:	e9 8b f3 ff ff       	jmp    80105dad <alltraps>

80106a22 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a22:	6a 00                	push   $0x0
  pushl $201
80106a24:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a29:	e9 7f f3 ff ff       	jmp    80105dad <alltraps>

80106a2e <vector202>:
.globl vector202
vector202:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $202
80106a30:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a35:	e9 73 f3 ff ff       	jmp    80105dad <alltraps>

80106a3a <vector203>:
.globl vector203
vector203:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $203
80106a3c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a41:	e9 67 f3 ff ff       	jmp    80105dad <alltraps>

80106a46 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a46:	6a 00                	push   $0x0
  pushl $204
80106a48:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a4d:	e9 5b f3 ff ff       	jmp    80105dad <alltraps>

80106a52 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $205
80106a54:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a59:	e9 4f f3 ff ff       	jmp    80105dad <alltraps>

80106a5e <vector206>:
.globl vector206
vector206:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $206
80106a60:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a65:	e9 43 f3 ff ff       	jmp    80105dad <alltraps>

80106a6a <vector207>:
.globl vector207
vector207:
  pushl $0
80106a6a:	6a 00                	push   $0x0
  pushl $207
80106a6c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a71:	e9 37 f3 ff ff       	jmp    80105dad <alltraps>

80106a76 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a76:	6a 00                	push   $0x0
  pushl $208
80106a78:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a7d:	e9 2b f3 ff ff       	jmp    80105dad <alltraps>

80106a82 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a82:	6a 00                	push   $0x0
  pushl $209
80106a84:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a89:	e9 1f f3 ff ff       	jmp    80105dad <alltraps>

80106a8e <vector210>:
.globl vector210
vector210:
  pushl $0
80106a8e:	6a 00                	push   $0x0
  pushl $210
80106a90:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a95:	e9 13 f3 ff ff       	jmp    80105dad <alltraps>

80106a9a <vector211>:
.globl vector211
vector211:
  pushl $0
80106a9a:	6a 00                	push   $0x0
  pushl $211
80106a9c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106aa1:	e9 07 f3 ff ff       	jmp    80105dad <alltraps>

80106aa6 <vector212>:
.globl vector212
vector212:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $212
80106aa8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106aad:	e9 fb f2 ff ff       	jmp    80105dad <alltraps>

80106ab2 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ab2:	6a 00                	push   $0x0
  pushl $213
80106ab4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106ab9:	e9 ef f2 ff ff       	jmp    80105dad <alltraps>

80106abe <vector214>:
.globl vector214
vector214:
  pushl $0
80106abe:	6a 00                	push   $0x0
  pushl $214
80106ac0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ac5:	e9 e3 f2 ff ff       	jmp    80105dad <alltraps>

80106aca <vector215>:
.globl vector215
vector215:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $215
80106acc:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ad1:	e9 d7 f2 ff ff       	jmp    80105dad <alltraps>

80106ad6 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ad6:	6a 00                	push   $0x0
  pushl $216
80106ad8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106add:	e9 cb f2 ff ff       	jmp    80105dad <alltraps>

80106ae2 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $217
80106ae4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106ae9:	e9 bf f2 ff ff       	jmp    80105dad <alltraps>

80106aee <vector218>:
.globl vector218
vector218:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $218
80106af0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106af5:	e9 b3 f2 ff ff       	jmp    80105dad <alltraps>

80106afa <vector219>:
.globl vector219
vector219:
  pushl $0
80106afa:	6a 00                	push   $0x0
  pushl $219
80106afc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b01:	e9 a7 f2 ff ff       	jmp    80105dad <alltraps>

80106b06 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $220
80106b08:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b0d:	e9 9b f2 ff ff       	jmp    80105dad <alltraps>

80106b12 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $221
80106b14:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b19:	e9 8f f2 ff ff       	jmp    80105dad <alltraps>

80106b1e <vector222>:
.globl vector222
vector222:
  pushl $0
80106b1e:	6a 00                	push   $0x0
  pushl $222
80106b20:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b25:	e9 83 f2 ff ff       	jmp    80105dad <alltraps>

80106b2a <vector223>:
.globl vector223
vector223:
  pushl $0
80106b2a:	6a 00                	push   $0x0
  pushl $223
80106b2c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b31:	e9 77 f2 ff ff       	jmp    80105dad <alltraps>

80106b36 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b36:	6a 00                	push   $0x0
  pushl $224
80106b38:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b3d:	e9 6b f2 ff ff       	jmp    80105dad <alltraps>

80106b42 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b42:	6a 00                	push   $0x0
  pushl $225
80106b44:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b49:	e9 5f f2 ff ff       	jmp    80105dad <alltraps>

80106b4e <vector226>:
.globl vector226
vector226:
  pushl $0
80106b4e:	6a 00                	push   $0x0
  pushl $226
80106b50:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b55:	e9 53 f2 ff ff       	jmp    80105dad <alltraps>

80106b5a <vector227>:
.globl vector227
vector227:
  pushl $0
80106b5a:	6a 00                	push   $0x0
  pushl $227
80106b5c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b61:	e9 47 f2 ff ff       	jmp    80105dad <alltraps>

80106b66 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b66:	6a 00                	push   $0x0
  pushl $228
80106b68:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b6d:	e9 3b f2 ff ff       	jmp    80105dad <alltraps>

80106b72 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b72:	6a 00                	push   $0x0
  pushl $229
80106b74:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b79:	e9 2f f2 ff ff       	jmp    80105dad <alltraps>

80106b7e <vector230>:
.globl vector230
vector230:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $230
80106b80:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b85:	e9 23 f2 ff ff       	jmp    80105dad <alltraps>

80106b8a <vector231>:
.globl vector231
vector231:
  pushl $0
80106b8a:	6a 00                	push   $0x0
  pushl $231
80106b8c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b91:	e9 17 f2 ff ff       	jmp    80105dad <alltraps>

80106b96 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b96:	6a 00                	push   $0x0
  pushl $232
80106b98:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b9d:	e9 0b f2 ff ff       	jmp    80105dad <alltraps>

80106ba2 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $233
80106ba4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106ba9:	e9 ff f1 ff ff       	jmp    80105dad <alltraps>

80106bae <vector234>:
.globl vector234
vector234:
  pushl $0
80106bae:	6a 00                	push   $0x0
  pushl $234
80106bb0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106bb5:	e9 f3 f1 ff ff       	jmp    80105dad <alltraps>

80106bba <vector235>:
.globl vector235
vector235:
  pushl $0
80106bba:	6a 00                	push   $0x0
  pushl $235
80106bbc:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106bc1:	e9 e7 f1 ff ff       	jmp    80105dad <alltraps>

80106bc6 <vector236>:
.globl vector236
vector236:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $236
80106bc8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bcd:	e9 db f1 ff ff       	jmp    80105dad <alltraps>

80106bd2 <vector237>:
.globl vector237
vector237:
  pushl $0
80106bd2:	6a 00                	push   $0x0
  pushl $237
80106bd4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106bd9:	e9 cf f1 ff ff       	jmp    80105dad <alltraps>

80106bde <vector238>:
.globl vector238
vector238:
  pushl $0
80106bde:	6a 00                	push   $0x0
  pushl $238
80106be0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106be5:	e9 c3 f1 ff ff       	jmp    80105dad <alltraps>

80106bea <vector239>:
.globl vector239
vector239:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $239
80106bec:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bf1:	e9 b7 f1 ff ff       	jmp    80105dad <alltraps>

80106bf6 <vector240>:
.globl vector240
vector240:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $240
80106bf8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bfd:	e9 ab f1 ff ff       	jmp    80105dad <alltraps>

80106c02 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $241
80106c04:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c09:	e9 9f f1 ff ff       	jmp    80105dad <alltraps>

80106c0e <vector242>:
.globl vector242
vector242:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $242
80106c10:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c15:	e9 93 f1 ff ff       	jmp    80105dad <alltraps>

80106c1a <vector243>:
.globl vector243
vector243:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $243
80106c1c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c21:	e9 87 f1 ff ff       	jmp    80105dad <alltraps>

80106c26 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c26:	6a 00                	push   $0x0
  pushl $244
80106c28:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c2d:	e9 7b f1 ff ff       	jmp    80105dad <alltraps>

80106c32 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $245
80106c34:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c39:	e9 6f f1 ff ff       	jmp    80105dad <alltraps>

80106c3e <vector246>:
.globl vector246
vector246:
  pushl $0
80106c3e:	6a 00                	push   $0x0
  pushl $246
80106c40:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c45:	e9 63 f1 ff ff       	jmp    80105dad <alltraps>

80106c4a <vector247>:
.globl vector247
vector247:
  pushl $0
80106c4a:	6a 00                	push   $0x0
  pushl $247
80106c4c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c51:	e9 57 f1 ff ff       	jmp    80105dad <alltraps>

80106c56 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $248
80106c58:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c5d:	e9 4b f1 ff ff       	jmp    80105dad <alltraps>

80106c62 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c62:	6a 00                	push   $0x0
  pushl $249
80106c64:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c69:	e9 3f f1 ff ff       	jmp    80105dad <alltraps>

80106c6e <vector250>:
.globl vector250
vector250:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $250
80106c70:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c75:	e9 33 f1 ff ff       	jmp    80105dad <alltraps>

80106c7a <vector251>:
.globl vector251
vector251:
  pushl $0
80106c7a:	6a 00                	push   $0x0
  pushl $251
80106c7c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c81:	e9 27 f1 ff ff       	jmp    80105dad <alltraps>

80106c86 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c86:	6a 00                	push   $0x0
  pushl $252
80106c88:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c8d:	e9 1b f1 ff ff       	jmp    80105dad <alltraps>

80106c92 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $253
80106c94:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c99:	e9 0f f1 ff ff       	jmp    80105dad <alltraps>

80106c9e <vector254>:
.globl vector254
vector254:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $254
80106ca0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ca5:	e9 03 f1 ff ff       	jmp    80105dad <alltraps>

80106caa <vector255>:
.globl vector255
vector255:
  pushl $0
80106caa:	6a 00                	push   $0x0
  pushl $255
80106cac:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106cb1:	e9 f7 f0 ff ff       	jmp    80105dad <alltraps>
80106cb6:	66 90                	xchg   %ax,%ax
80106cb8:	66 90                	xchg   %ax,%ax
80106cba:	66 90                	xchg   %ax,%ax
80106cbc:	66 90                	xchg   %ax,%ax
80106cbe:	66 90                	xchg   %ax,%ax

80106cc0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106cc7:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106cca:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ccb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106cce:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106cd1:	8b 1f                	mov    (%edi),%ebx
80106cd3:	f6 c3 01             	test   $0x1,%bl
80106cd6:	74 28                	je     80106d00 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cd8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106cde:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ce4:	c1 ee 0a             	shr    $0xa,%esi
}
80106ce7:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106cea:	89 f2                	mov    %esi,%edx
80106cec:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106cf2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106cf5:	5b                   	pop    %ebx
80106cf6:	5e                   	pop    %esi
80106cf7:	5f                   	pop    %edi
80106cf8:	5d                   	pop    %ebp
80106cf9:	c3                   	ret    
80106cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d00:	85 c9                	test   %ecx,%ecx
80106d02:	74 34                	je     80106d38 <walkpgdir+0x78>
80106d04:	e8 17 b8 ff ff       	call   80102520 <kalloc>
80106d09:	85 c0                	test   %eax,%eax
80106d0b:	89 c3                	mov    %eax,%ebx
80106d0d:	74 29                	je     80106d38 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106d0f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106d16:	00 
80106d17:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106d1e:	00 
80106d1f:	89 04 24             	mov    %eax,(%esp)
80106d22:	e8 d9 d5 ff ff       	call   80104300 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d27:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d2d:	83 c8 07             	or     $0x7,%eax
80106d30:	89 07                	mov    %eax,(%edi)
80106d32:	eb b0                	jmp    80106ce4 <walkpgdir+0x24>
80106d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
80106d38:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106d3b:	31 c0                	xor    %eax,%eax
    // be further restricted by tlayhe permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106d3d:	5b                   	pop    %ebx
80106d3e:	5e                   	pop    %esi
80106d3f:	5f                   	pop    %edi
80106d40:	5d                   	pop    %ebp
80106d41:	c3                   	ret    
80106d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d50 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	57                   	push   %edi
80106d54:	56                   	push   %esi
80106d55:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106d56:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d58:	83 ec 1c             	sub    $0x1c,%esp
80106d5b:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106d5e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d64:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d67:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d6e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d72:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106d79:	29 df                	sub    %ebx,%edi
80106d7b:	eb 18                	jmp    80106d95 <mappages+0x45>
80106d7d:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106d80:	f6 00 01             	testb  $0x1,(%eax)
80106d83:	75 3d                	jne    80106dc2 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d85:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106d88:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d8b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d8d:	74 29                	je     80106db8 <mappages+0x68>
      break;
    a += PGSIZE;
80106d8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d98:	b9 01 00 00 00       	mov    $0x1,%ecx
80106d9d:	89 da                	mov    %ebx,%edx
80106d9f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106da2:	e8 19 ff ff ff       	call   80106cc0 <walkpgdir>
80106da7:	85 c0                	test   %eax,%eax
80106da9:	75 d5                	jne    80106d80 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106dab:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106dae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106db3:	5b                   	pop    %ebx
80106db4:	5e                   	pop    %esi
80106db5:	5f                   	pop    %edi
80106db6:	5d                   	pop    %ebp
80106db7:	c3                   	ret    
80106db8:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106dbb:	31 c0                	xor    %eax,%eax
}
80106dbd:	5b                   	pop    %ebx
80106dbe:	5e                   	pop    %esi
80106dbf:	5f                   	pop    %edi
80106dc0:	5d                   	pop    %ebp
80106dc1:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106dc2:	c7 04 24 60 80 10 80 	movl   $0x80108060,(%esp)
80106dc9:	e8 92 95 ff ff       	call   80100360 <panic>
80106dce:	66 90                	xchg   %ax,%ax

80106dd0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	89 c7                	mov    %eax,%edi
80106dd6:	56                   	push   %esi
80106dd7:	89 d6                	mov    %edx,%esi
80106dd9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106dda:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106de0:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106de3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106de9:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106deb:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106dee:	72 3b                	jb     80106e2b <deallocuvm.part.0+0x5b>
80106df0:	eb 5e                	jmp    80106e50 <deallocuvm.part.0+0x80>
80106df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106df8:	8b 10                	mov    (%eax),%edx
80106dfa:	f6 c2 01             	test   $0x1,%dl
80106dfd:	74 22                	je     80106e21 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106dff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106e05:	74 54                	je     80106e5b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106e07:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106e0d:	89 14 24             	mov    %edx,(%esp)
80106e10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e13:	e8 58 b5 ff ff       	call   80102370 <kfree>
      *pte = 0;
80106e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e27:	39 f3                	cmp    %esi,%ebx
80106e29:	73 25                	jae    80106e50 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106e2b:	31 c9                	xor    %ecx,%ecx
80106e2d:	89 da                	mov    %ebx,%edx
80106e2f:	89 f8                	mov    %edi,%eax
80106e31:	e8 8a fe ff ff       	call   80106cc0 <walkpgdir>
    if(!pte)
80106e36:	85 c0                	test   %eax,%eax
80106e38:	75 be                	jne    80106df8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e3a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106e40:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e46:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e4c:	39 f3                	cmp    %esi,%ebx
80106e4e:	72 db                	jb     80106e2b <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106e50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e53:	83 c4 1c             	add    $0x1c,%esp
80106e56:	5b                   	pop    %ebx
80106e57:	5e                   	pop    %esi
80106e58:	5f                   	pop    %edi
80106e59:	5d                   	pop    %ebp
80106e5a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106e5b:	c7 04 24 46 78 10 80 	movl   $0x80107846,(%esp)
80106e62:	e8 f9 94 ff ff       	call   80100360 <panic>
80106e67:	89 f6                	mov    %esi,%esi
80106e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e70 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106e76:	e8 85 c8 ff ff       	call   80103700 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e7b:	31 c9                	xor    %ecx,%ecx
80106e7d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106e82:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e88:	05 80 37 11 80       	add    $0x80113780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e8d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e91:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
80106e96:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e99:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e9d:	31 c9                	xor    %ecx,%ecx
80106e9f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ea3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ea8:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106eac:	31 c9                	xor    %ecx,%ecx
80106eae:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106eb2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106eb7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ebb:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ebd:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106ec1:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ec5:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106ec9:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ecd:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106ed1:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ed5:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106ed9:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
80106edd:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106ee1:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ee6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
80106eea:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106eee:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106ef2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ef6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
80106efa:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106efe:	66 89 48 22          	mov    %cx,0x22(%eax)
80106f02:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106f06:	c6 40 27 00          	movb   $0x0,0x27(%eax)
80106f0a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106f0e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f12:	c1 e8 10             	shr    $0x10,%eax
80106f15:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106f19:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f1c:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
80106f1f:	c9                   	leave  
80106f20:	c3                   	ret    
80106f21:	eb 0d                	jmp    80106f30 <switchkvm>
80106f23:	90                   	nop
80106f24:	90                   	nop
80106f25:	90                   	nop
80106f26:	90                   	nop
80106f27:	90                   	nop
80106f28:	90                   	nop
80106f29:	90                   	nop
80106f2a:	90                   	nop
80106f2b:	90                   	nop
80106f2c:	90                   	nop
80106f2d:	90                   	nop
80106f2e:	90                   	nop
80106f2f:	90                   	nop

80106f30 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f30:	a1 04 6e 11 80       	mov    0x80116e04,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106f35:	55                   	push   %ebp
80106f36:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f38:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f3d:	0f 22 d8             	mov    %eax,%cr3
}
80106f40:	5d                   	pop    %ebp
80106f41:	c3                   	ret    
80106f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f50 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
80106f56:	83 ec 1c             	sub    $0x1c,%esp
80106f59:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f5c:	85 f6                	test   %esi,%esi
80106f5e:	0f 84 cd 00 00 00    	je     80107031 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106f64:	8b 46 08             	mov    0x8(%esi),%eax
80106f67:	85 c0                	test   %eax,%eax
80106f69:	0f 84 da 00 00 00    	je     80107049 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106f6f:	8b 7e 04             	mov    0x4(%esi),%edi
80106f72:	85 ff                	test   %edi,%edi
80106f74:	0f 84 c3 00 00 00    	je     8010703d <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
80106f7a:	e8 01 d2 ff ff       	call   80104180 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f7f:	e8 fc c6 ff ff       	call   80103680 <mycpu>
80106f84:	89 c3                	mov    %eax,%ebx
80106f86:	e8 f5 c6 ff ff       	call   80103680 <mycpu>
80106f8b:	89 c7                	mov    %eax,%edi
80106f8d:	e8 ee c6 ff ff       	call   80103680 <mycpu>
80106f92:	83 c7 08             	add    $0x8,%edi
80106f95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f98:	e8 e3 c6 ff ff       	call   80103680 <mycpu>
80106f9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fa0:	ba 67 00 00 00       	mov    $0x67,%edx
80106fa5:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106fac:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106fb3:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106fba:	83 c1 08             	add    $0x8,%ecx
80106fbd:	c1 e9 10             	shr    $0x10,%ecx
80106fc0:	83 c0 08             	add    $0x8,%eax
80106fc3:	c1 e8 18             	shr    $0x18,%eax
80106fc6:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106fcc:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106fd3:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fd9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106fde:	e8 9d c6 ff ff       	call   80103680 <mycpu>
80106fe3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fea:	e8 91 c6 ff ff       	call   80103680 <mycpu>
80106fef:	b9 10 00 00 00       	mov    $0x10,%ecx
80106ff4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ff8:	e8 83 c6 ff ff       	call   80103680 <mycpu>
80106ffd:	8b 56 08             	mov    0x8(%esi),%edx
80107000:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107006:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107009:	e8 72 c6 ff ff       	call   80103680 <mycpu>
8010700e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107012:	b8 28 00 00 00       	mov    $0x28,%eax
80107017:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010701a:	8b 46 04             	mov    0x4(%esi),%eax
8010701d:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107022:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107025:	83 c4 1c             	add    $0x1c,%esp
80107028:	5b                   	pop    %ebx
80107029:	5e                   	pop    %esi
8010702a:	5f                   	pop    %edi
8010702b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010702c:	e9 0f d2 ff ff       	jmp    80104240 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107031:	c7 04 24 66 80 10 80 	movl   $0x80108066,(%esp)
80107038:	e8 23 93 ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010703d:	c7 04 24 91 80 10 80 	movl   $0x80108091,(%esp)
80107044:	e8 17 93 ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80107049:	c7 04 24 7c 80 10 80 	movl   $0x8010807c,(%esp)
80107050:	e8 0b 93 ff ff       	call   80100360 <panic>
80107055:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107060 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
80107066:	83 ec 1c             	sub    $0x1c,%esp
80107069:	8b 75 10             	mov    0x10(%ebp),%esi
8010706c:	8b 45 08             	mov    0x8(%ebp),%eax
8010706f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107072:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107078:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010707b:	77 54                	ja     801070d1 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
8010707d:	e8 9e b4 ff ff       	call   80102520 <kalloc>
  memset(mem, 0, PGSIZE);
80107082:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107089:	00 
8010708a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107091:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107092:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107094:	89 04 24             	mov    %eax,(%esp)
80107097:	e8 64 d2 ff ff       	call   80104300 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010709c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070a2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070a7:	89 04 24             	mov    %eax,(%esp)
801070aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070ad:	31 d2                	xor    %edx,%edx
801070af:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801070b6:	00 
801070b7:	e8 94 fc ff ff       	call   80106d50 <mappages>
  memmove(mem, init, sz);
801070bc:	89 75 10             	mov    %esi,0x10(%ebp)
801070bf:	89 7d 0c             	mov    %edi,0xc(%ebp)
801070c2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801070c5:	83 c4 1c             	add    $0x1c,%esp
801070c8:	5b                   	pop    %ebx
801070c9:	5e                   	pop    %esi
801070ca:	5f                   	pop    %edi
801070cb:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801070cc:	e9 cf d2 ff ff       	jmp    801043a0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801070d1:	c7 04 24 a5 80 10 80 	movl   $0x801080a5,(%esp)
801070d8:	e8 83 92 ff ff       	call   80100360 <panic>
801070dd:	8d 76 00             	lea    0x0(%esi),%esi

801070e0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801070e9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801070f0:	0f 85 98 00 00 00    	jne    8010718e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801070f6:	8b 75 18             	mov    0x18(%ebp),%esi
801070f9:	31 db                	xor    %ebx,%ebx
801070fb:	85 f6                	test   %esi,%esi
801070fd:	75 1a                	jne    80107119 <loaduvm+0x39>
801070ff:	eb 77                	jmp    80107178 <loaduvm+0x98>
80107101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107108:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010710e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107114:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107117:	76 5f                	jbe    80107178 <loaduvm+0x98>
80107119:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010711c:	31 c9                	xor    %ecx,%ecx
8010711e:	8b 45 08             	mov    0x8(%ebp),%eax
80107121:	01 da                	add    %ebx,%edx
80107123:	e8 98 fb ff ff       	call   80106cc0 <walkpgdir>
80107128:	85 c0                	test   %eax,%eax
8010712a:	74 56                	je     80107182 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010712c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010712e:	bf 00 10 00 00       	mov    $0x1000,%edi
80107133:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010713b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80107141:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107144:	05 00 00 00 80       	add    $0x80000000,%eax
80107149:	89 44 24 04          	mov    %eax,0x4(%esp)
8010714d:	8b 45 10             	mov    0x10(%ebp),%eax
80107150:	01 d9                	add    %ebx,%ecx
80107152:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80107156:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010715a:	89 04 24             	mov    %eax,(%esp)
8010715d:	e8 7e a8 ff ff       	call   801019e0 <readi>
80107162:	39 f8                	cmp    %edi,%eax
80107164:	74 a2                	je     80107108 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107166:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107169:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010716e:	5b                   	pop    %ebx
8010716f:	5e                   	pop    %esi
80107170:	5f                   	pop    %edi
80107171:	5d                   	pop    %ebp
80107172:	c3                   	ret    
80107173:	90                   	nop
80107174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107178:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010717b:	31 c0                	xor    %eax,%eax
}
8010717d:	5b                   	pop    %ebx
8010717e:	5e                   	pop    %esi
8010717f:	5f                   	pop    %edi
80107180:	5d                   	pop    %ebp
80107181:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80107182:	c7 04 24 bf 80 10 80 	movl   $0x801080bf,(%esp)
80107189:	e8 d2 91 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
8010718e:	c7 04 24 60 81 10 80 	movl   $0x80108160,(%esp)
80107195:	e8 c6 91 ff ff       	call   80100360 <panic>
8010719a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071a0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 1c             	sub    $0x1c,%esp
801071a9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801071ac:	85 ff                	test   %edi,%edi
801071ae:	0f 88 7e 00 00 00    	js     80107232 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
801071b4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801071b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
801071ba:	72 78                	jb     80107234 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
801071bc:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801071c2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801071c8:	39 df                	cmp    %ebx,%edi
801071ca:	77 4a                	ja     80107216 <allocuvm+0x76>
801071cc:	eb 72                	jmp    80107240 <allocuvm+0xa0>
801071ce:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
801071d0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801071d7:	00 
801071d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801071df:	00 
801071e0:	89 04 24             	mov    %eax,(%esp)
801071e3:	e8 18 d1 ff ff       	call   80104300 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801071e8:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801071ee:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071f3:	89 04 24             	mov    %eax,(%esp)
801071f6:	8b 45 08             	mov    0x8(%ebp),%eax
801071f9:	89 da                	mov    %ebx,%edx
801071fb:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80107202:	00 
80107203:	e8 48 fb ff ff       	call   80106d50 <mappages>
80107208:	85 c0                	test   %eax,%eax
8010720a:	78 44                	js     80107250 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010720c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107212:	39 df                	cmp    %ebx,%edi
80107214:	76 2a                	jbe    80107240 <allocuvm+0xa0>
    mem = kalloc();
80107216:	e8 05 b3 ff ff       	call   80102520 <kalloc>
    if(mem == 0){
8010721b:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010721d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010721f:	75 af                	jne    801071d0 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80107221:	c7 04 24 dd 80 10 80 	movl   $0x801080dd,(%esp)
80107228:	e8 23 94 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010722d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107230:	77 48                	ja     8010727a <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107232:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107234:	83 c4 1c             	add    $0x1c,%esp
80107237:	5b                   	pop    %ebx
80107238:	5e                   	pop    %esi
80107239:	5f                   	pop    %edi
8010723a:	5d                   	pop    %ebp
8010723b:	c3                   	ret    
8010723c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107240:	83 c4 1c             	add    $0x1c,%esp
80107243:	89 f8                	mov    %edi,%eax
80107245:	5b                   	pop    %ebx
80107246:	5e                   	pop    %esi
80107247:	5f                   	pop    %edi
80107248:	5d                   	pop    %ebp
80107249:	c3                   	ret    
8010724a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107250:	c7 04 24 f5 80 10 80 	movl   $0x801080f5,(%esp)
80107257:	e8 f4 93 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010725c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010725f:	76 0d                	jbe    8010726e <allocuvm+0xce>
80107261:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107264:	89 fa                	mov    %edi,%edx
80107266:	8b 45 08             	mov    0x8(%ebp),%eax
80107269:	e8 62 fb ff ff       	call   80106dd0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
8010726e:	89 34 24             	mov    %esi,(%esp)
80107271:	e8 fa b0 ff ff       	call   80102370 <kfree>
      return 0;
80107276:	31 c0                	xor    %eax,%eax
80107278:	eb ba                	jmp    80107234 <allocuvm+0x94>
8010727a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010727d:	89 fa                	mov    %edi,%edx
8010727f:	8b 45 08             	mov    0x8(%ebp),%eax
80107282:	e8 49 fb ff ff       	call   80106dd0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107287:	31 c0                	xor    %eax,%eax
80107289:	eb a9                	jmp    80107234 <allocuvm+0x94>
8010728b:	90                   	nop
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107290 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	8b 55 0c             	mov    0xc(%ebp),%edx
80107296:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107299:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010729c:	39 d1                	cmp    %edx,%ecx
8010729e:	73 08                	jae    801072a8 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801072a0:	5d                   	pop    %ebp
801072a1:	e9 2a fb ff ff       	jmp    80106dd0 <deallocuvm.part.0>
801072a6:	66 90                	xchg   %ax,%ax
801072a8:	89 d0                	mov    %edx,%eax
801072aa:	5d                   	pop    %ebp
801072ab:	c3                   	ret    
801072ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	56                   	push   %esi
801072b4:	53                   	push   %ebx
801072b5:	83 ec 10             	sub    $0x10,%esp
801072b8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801072bb:	85 f6                	test   %esi,%esi
801072bd:	74 59                	je     80107318 <freevm+0x68>
801072bf:	31 c9                	xor    %ecx,%ecx
801072c1:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072c6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072c8:	31 db                	xor    %ebx,%ebx
801072ca:	e8 01 fb ff ff       	call   80106dd0 <deallocuvm.part.0>
801072cf:	eb 12                	jmp    801072e3 <freevm+0x33>
801072d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072d8:	83 c3 01             	add    $0x1,%ebx
801072db:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801072e1:	74 27                	je     8010730a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072e3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
801072e6:	f6 c2 01             	test   $0x1,%dl
801072e9:	74 ed                	je     801072d8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072eb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072f1:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072f4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801072fa:	89 14 24             	mov    %edx,(%esp)
801072fd:	e8 6e b0 ff ff       	call   80102370 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107302:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80107308:	75 d9                	jne    801072e3 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010730a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010730d:	83 c4 10             	add    $0x10,%esp
80107310:	5b                   	pop    %ebx
80107311:	5e                   	pop    %esi
80107312:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107313:	e9 58 b0 ff ff       	jmp    80102370 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107318:	c7 04 24 11 81 10 80 	movl   $0x80108111,(%esp)
8010731f:	e8 3c 90 ff ff       	call   80100360 <panic>
80107324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010732a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107330 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	56                   	push   %esi
80107334:	53                   	push   %ebx
80107335:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107338:	e8 e3 b1 ff ff       	call   80102520 <kalloc>
8010733d:	85 c0                	test   %eax,%eax
8010733f:	89 c6                	mov    %eax,%esi
80107341:	74 6d                	je     801073b0 <setupkvm+0x80>
    return 0;
  memset(pgdir, 0, PGSIZE);
80107343:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010734a:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010734b:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107350:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107357:	00 
80107358:	89 04 24             	mov    %eax,(%esp)
8010735b:	e8 a0 cf ff ff       	call   80104300 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107360:	8b 53 0c             	mov    0xc(%ebx),%edx
80107363:	8b 43 04             	mov    0x4(%ebx),%eax
80107366:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107369:	89 54 24 04          	mov    %edx,0x4(%esp)
8010736d:	8b 13                	mov    (%ebx),%edx
8010736f:	89 04 24             	mov    %eax,(%esp)
80107372:	29 c1                	sub    %eax,%ecx
80107374:	89 f0                	mov    %esi,%eax
80107376:	e8 d5 f9 ff ff       	call   80106d50 <mappages>
8010737b:	85 c0                	test   %eax,%eax
8010737d:	78 19                	js     80107398 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010737f:	83 c3 10             	add    $0x10,%ebx
80107382:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107388:	72 d6                	jb     80107360 <setupkvm+0x30>
8010738a:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
8010738c:	83 c4 10             	add    $0x10,%esp
8010738f:	5b                   	pop    %ebx
80107390:	5e                   	pop    %esi
80107391:	5d                   	pop    %ebp
80107392:	c3                   	ret    
80107393:	90                   	nop
80107394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107398:	89 34 24             	mov    %esi,(%esp)
8010739b:	e8 10 ff ff ff       	call   801072b0 <freevm>
      return 0;
    }
  return pgdir;
}
801073a0:	83 c4 10             	add    $0x10,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
801073a3:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
801073a5:	5b                   	pop    %ebx
801073a6:	5e                   	pop    %esi
801073a7:	5d                   	pop    %ebp
801073a8:	c3                   	ret    
801073a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801073b0:	31 c0                	xor    %eax,%eax
801073b2:	eb d8                	jmp    8010738c <setupkvm+0x5c>
801073b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801073c0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801073c6:	e8 65 ff ff ff       	call   80107330 <setupkvm>
801073cb:	a3 04 6e 11 80       	mov    %eax,0x80116e04
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073d0:	05 00 00 00 80       	add    $0x80000000,%eax
801073d5:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
801073d8:	c9                   	leave  
801073d9:	c3                   	ret    
801073da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801073e1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073e3:	89 e5                	mov    %esp,%ebp
801073e5:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801073e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801073eb:	8b 45 08             	mov    0x8(%ebp),%eax
801073ee:	e8 cd f8 ff ff       	call   80106cc0 <walkpgdir>
  if(pte == 0)
801073f3:	85 c0                	test   %eax,%eax
801073f5:	74 05                	je     801073fc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801073f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073fa:	c9                   	leave  
801073fb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801073fc:	c7 04 24 22 81 10 80 	movl   $0x80108122,(%esp)
80107403:	e8 58 8f ff ff       	call   80100360 <panic>
80107408:	90                   	nop
80107409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107410 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
80107415:	53                   	push   %ebx
80107416:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107419:	e8 12 ff ff ff       	call   80107330 <setupkvm>
8010741e:	85 c0                	test   %eax,%eax
80107420:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107423:	0f 84 b2 00 00 00    	je     801074db <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107429:	8b 45 0c             	mov    0xc(%ebp),%eax
8010742c:	85 c0                	test   %eax,%eax
8010742e:	0f 84 9c 00 00 00    	je     801074d0 <copyuvm+0xc0>
80107434:	31 db                	xor    %ebx,%ebx
80107436:	eb 48                	jmp    80107480 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107438:	81 c7 00 00 00 80    	add    $0x80000000,%edi
8010743e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107445:	00 
80107446:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010744a:	89 04 24             	mov    %eax,(%esp)
8010744d:	e8 4e cf ff ff       	call   801043a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107455:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
8010745b:	89 14 24             	mov    %edx,(%esp)
8010745e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107463:	89 da                	mov    %ebx,%edx
80107465:	89 44 24 04          	mov    %eax,0x4(%esp)
80107469:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010746c:	e8 df f8 ff ff       	call   80106d50 <mappages>
80107471:	85 c0                	test   %eax,%eax
80107473:	78 41                	js     801074b6 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107475:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010747b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
8010747e:	76 50                	jbe    801074d0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107480:	8b 45 08             	mov    0x8(%ebp),%eax
80107483:	31 c9                	xor    %ecx,%ecx
80107485:	89 da                	mov    %ebx,%edx
80107487:	e8 34 f8 ff ff       	call   80106cc0 <walkpgdir>
8010748c:	85 c0                	test   %eax,%eax
8010748e:	74 5b                	je     801074eb <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107490:	8b 30                	mov    (%eax),%esi
80107492:	f7 c6 01 00 00 00    	test   $0x1,%esi
80107498:	74 45                	je     801074df <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010749a:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
8010749c:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
801074a2:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801074a5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
801074ab:	e8 70 b0 ff ff       	call   80102520 <kalloc>
801074b0:	85 c0                	test   %eax,%eax
801074b2:	89 c6                	mov    %eax,%esi
801074b4:	75 82                	jne    80107438 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801074b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074b9:	89 04 24             	mov    %eax,(%esp)
801074bc:	e8 ef fd ff ff       	call   801072b0 <freevm>
  return 0;
801074c1:	31 c0                	xor    %eax,%eax
}
801074c3:	83 c4 2c             	add    $0x2c,%esp
801074c6:	5b                   	pop    %ebx
801074c7:	5e                   	pop    %esi
801074c8:	5f                   	pop    %edi
801074c9:	5d                   	pop    %ebp
801074ca:	c3                   	ret    
801074cb:	90                   	nop
801074cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074d3:	83 c4 2c             	add    $0x2c,%esp
801074d6:	5b                   	pop    %ebx
801074d7:	5e                   	pop    %esi
801074d8:	5f                   	pop    %edi
801074d9:	5d                   	pop    %ebp
801074da:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801074db:	31 c0                	xor    %eax,%eax
801074dd:	eb e4                	jmp    801074c3 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801074df:	c7 04 24 46 81 10 80 	movl   $0x80108146,(%esp)
801074e6:	e8 75 8e ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801074eb:	c7 04 24 2c 81 10 80 	movl   $0x8010812c,(%esp)
801074f2:	e8 69 8e ff ff       	call   80100360 <panic>
801074f7:	89 f6                	mov    %esi,%esi
801074f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107500 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107500:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107501:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107503:	89 e5                	mov    %esp,%ebp
80107505:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107508:	8b 55 0c             	mov    0xc(%ebp),%edx
8010750b:	8b 45 08             	mov    0x8(%ebp),%eax
8010750e:	e8 ad f7 ff ff       	call   80106cc0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107513:	8b 00                	mov    (%eax),%eax
80107515:	89 c2                	mov    %eax,%edx
80107517:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
8010751a:	83 fa 05             	cmp    $0x5,%edx
8010751d:	75 11                	jne    80107530 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010751f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107524:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107529:	c9                   	leave  
8010752a:	c3                   	ret    
8010752b:	90                   	nop
8010752c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107530:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107532:	c9                   	leave  
80107533:	c3                   	ret    
80107534:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010753a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107540 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	57                   	push   %edi
80107544:	56                   	push   %esi
80107545:	53                   	push   %ebx
80107546:	83 ec 1c             	sub    $0x1c,%esp
80107549:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010754c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010754f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107552:	85 db                	test   %ebx,%ebx
80107554:	75 3a                	jne    80107590 <copyout+0x50>
80107556:	eb 68                	jmp    801075c0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107558:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010755b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010755d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107561:	29 ca                	sub    %ecx,%edx
80107563:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107569:	39 da                	cmp    %ebx,%edx
8010756b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010756e:	29 f1                	sub    %esi,%ecx
80107570:	01 c8                	add    %ecx,%eax
80107572:	89 54 24 08          	mov    %edx,0x8(%esp)
80107576:	89 04 24             	mov    %eax,(%esp)
80107579:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010757c:	e8 1f ce ff ff       	call   801043a0 <memmove>
    len -= n;
    buf += n;
80107581:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107584:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
8010758a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010758c:	29 d3                	sub    %edx,%ebx
8010758e:	74 30                	je     801075c0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80107590:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107593:	89 ce                	mov    %ecx,%esi
80107595:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010759b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010759f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801075a2:	89 04 24             	mov    %eax,(%esp)
801075a5:	e8 56 ff ff ff       	call   80107500 <uva2ka>
    if(pa0 == 0)
801075aa:	85 c0                	test   %eax,%eax
801075ac:	75 aa                	jne    80107558 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801075ae:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801075b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801075b6:	5b                   	pop    %ebx
801075b7:	5e                   	pop    %esi
801075b8:	5f                   	pop    %edi
801075b9:	5d                   	pop    %ebp
801075ba:	c3                   	ret    
801075bb:	90                   	nop
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075c0:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801075c3:	31 c0                	xor    %eax,%eax
}
801075c5:	5b                   	pop    %ebx
801075c6:	5e                   	pop    %esi
801075c7:	5f                   	pop    %edi
801075c8:	5d                   	pop    %ebp
801075c9:	c3                   	ret    
