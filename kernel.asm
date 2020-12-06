
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 40 d6 10 80       	mov    $0x8010d640,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 33 10 80       	mov    $0x801033b0,%eax
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
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 74 d6 10 80       	mov    $0x8010d674,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 a0 84 10 80       	push   $0x801084a0
80100055:	68 40 d6 10 80       	push   $0x8010d640
8010005a:	e8 11 55 00 00       	call   80105570 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 3c 1d 11 80       	mov    $0x80111d3c,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 8c 1d 11 80 3c 	movl   $0x80111d3c,0x80111d8c
8010006e:	1d 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 90 1d 11 80 3c 	movl   $0x80111d3c,0x80111d90
80100078:	1d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 3c 1d 11 80 	movl   $0x80111d3c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 84 10 80       	push   $0x801084a7
80100097:	50                   	push   %eax
80100098:	e8 93 53 00 00       	call   80105430 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 90 1d 11 80       	mov    0x80111d90,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 90 1d 11 80    	mov    %ebx,0x80111d90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb e0 1a 11 80    	cmp    $0x80111ae0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 40 d6 10 80       	push   $0x8010d640
801000e8:	e8 03 56 00 00       	call   801056f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 90 1d 11 80    	mov    0x80111d90,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb 3c 1d 11 80    	cmp    $0x80111d3c,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 3c 1d 11 80    	cmp    $0x80111d3c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 8c 1d 11 80    	mov    0x80111d8c,%ebx
80100126:	81 fb 3c 1d 11 80    	cmp    $0x80111d3c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 3c 1d 11 80    	cmp    $0x80111d3c,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 40 d6 10 80       	push   $0x8010d640
80100162:	e8 49 56 00 00       	call   801057b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 52 00 00       	call   80105470 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 24 00 00       	call   801025f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ae 84 10 80       	push   $0x801084ae
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 49 53 00 00       	call   80105510 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 13 24 00 00       	jmp    801025f0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 bf 84 10 80       	push   $0x801084bf
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 08 53 00 00       	call   80105510 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 b8 52 00 00       	call   801054d0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 40 d6 10 80 	movl   $0x8010d640,(%esp)
8010021f:	e8 cc 54 00 00       	call   801056f0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 90 1d 11 80       	mov    0x80111d90,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 3c 1d 11 80 	movl   $0x80111d3c,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 90 1d 11 80       	mov    0x80111d90,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 90 1d 11 80    	mov    %ebx,0x80111d90
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 40 d6 10 80 	movl   $0x8010d640,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 3b 55 00 00       	jmp    801057b0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 84 10 80       	push   $0x801084c6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 06 19 00 00       	call   80101bb0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 a0 c5 10 80 	movl   $0x8010c5a0,(%esp)
801002b1:	e8 3a 54 00 00       	call   801056f0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 c0 20 11 80       	mov    0x801120c0,%eax
801002cb:	3b 05 c4 20 11 80    	cmp    0x801120c4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 a0 c5 10 80       	push   $0x8010c5a0
801002e0:	68 c0 20 11 80       	push   $0x801120c0
801002e5:	e8 a6 4d 00 00       	call   80105090 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 20 11 80       	mov    0x801120c0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 20 11 80    	cmp    0x801120c4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 a1 3a 00 00       	call   80103da0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 a0 c5 10 80       	push   $0x8010c5a0
8010030e:	e8 9d 54 00 00       	call   801057b0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 b4 17 00 00       	call   80101ad0 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 c0 20 11 80    	mov    %edx,0x801120c0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 20 11 80 	movsbl -0x7feedfc0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 a0 c5 10 80       	push   $0x8010c5a0
80100365:	e8 46 54 00 00       	call   801057b0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 5d 17 00 00       	call   80101ad0 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 c0 20 11 80       	mov    %eax,0x801120c0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 d4 c5 10 80 00 	movl   $0x0,0x8010c5d4
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 5e 28 00 00       	call   80102c10 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 84 10 80       	push   $0x801084cd
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 f2 8a 10 80 	movl   $0x80108af2,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 af 51 00 00       	call   80105590 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 84 10 80       	push   $0x801084e1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 d8 c5 10 80 01 	movl   $0x1,0x8010c5d8
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 61 6c 00 00       	call   80107090 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 76 6b 00 00       	call   80107090 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 6a 6b 00 00       	call   80107090 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 5e 6b 00 00       	call   80107090 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 3a 53 00 00       	call   801058a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 85 52 00 00       	call   80105800 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 e5 84 10 80       	push   $0x801084e5
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 74 85 10 80 	movzbl -0x7fef7a8c(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 d8 c5 10 80    	mov    0x8010c5d8,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 58 15 00 00       	call   80101bb0 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 a0 c5 10 80 	movl   $0x8010c5a0,(%esp)
8010065f:	e8 8c 50 00 00       	call   801056f0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 d8 c5 10 80    	mov    0x8010c5d8,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 a0 c5 10 80       	push   $0x8010c5a0
80100697:	e8 14 51 00 00       	call   801057b0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 2b 14 00 00       	call   80101ad0 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 d4 c5 10 80       	mov    0x8010c5d4,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d d8 c5 10 80    	mov    0x8010c5d8,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb f8 84 10 80       	mov    $0x801084f8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 d8 c5 10 80    	mov    0x8010c5d8,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 a0 c5 10 80       	push   $0x8010c5a0
801007bd:	e8 2e 4f 00 00       	call   801056f0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d d8 c5 10 80    	mov    0x8010c5d8,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d d8 c5 10 80    	mov    0x8010c5d8,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 d8 c5 10 80    	mov    0x8010c5d8,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 a0 c5 10 80       	push   $0x8010c5a0
80100828:	e8 83 4f 00 00       	call   801057b0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 ff 84 10 80       	push   $0x801084ff
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <kill_line>:
{
80100860:	f3 0f 1e fb          	endbr32 
  while(input.e != input.w &&
80100864:	a1 c8 20 11 80       	mov    0x801120c8,%eax
80100869:	3b 05 c4 20 11 80    	cmp    0x801120c4,%eax
8010086f:	74 48                	je     801008b9 <kill_line+0x59>
{
80100871:	55                   	push   %ebp
80100872:	89 e5                	mov    %esp,%ebp
80100874:	83 ec 08             	sub    $0x8,%esp
      input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100877:	83 e8 01             	sub    $0x1,%eax
8010087a:	89 c2                	mov    %eax,%edx
8010087c:	83 e2 7f             	and    $0x7f,%edx
  while(input.e != input.w &&
8010087f:	80 ba 40 20 11 80 0a 	cmpb   $0xa,-0x7feedfc0(%edx)
80100886:	74 2f                	je     801008b7 <kill_line+0x57>
    input.e--;
80100888:	a3 c8 20 11 80       	mov    %eax,0x801120c8
  if(panicked){
8010088d:	a1 d8 c5 10 80       	mov    0x8010c5d8,%eax
80100892:	85 c0                	test   %eax,%eax
80100894:	74 0a                	je     801008a0 <kill_line+0x40>
80100896:	fa                   	cli    
    for(;;)
80100897:	eb fe                	jmp    80100897 <kill_line+0x37>
80100899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008a0:	b8 00 01 00 00       	mov    $0x100,%eax
801008a5:	e8 66 fb ff ff       	call   80100410 <consputc.part.0>
  while(input.e != input.w &&
801008aa:	a1 c8 20 11 80       	mov    0x801120c8,%eax
801008af:	3b 05 c4 20 11 80    	cmp    0x801120c4,%eax
801008b5:	75 c0                	jne    80100877 <kill_line+0x17>
}
801008b7:	c9                   	leave  
801008b8:	c3                   	ret    
801008b9:	c3                   	ret    
801008ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801008c0 <count_line_chars>:
{
801008c0:	f3 0f 1e fb          	endbr32 
801008c4:	55                   	push   %ebp
  int start = input.e, temp_e = input.e;
801008c5:	a1 c8 20 11 80       	mov    0x801120c8,%eax
{
801008ca:	89 e5                	mov    %esp,%ebp
801008cc:	57                   	push   %edi
801008cd:	56                   	push   %esi
801008ce:	8b 35 c4 20 11 80    	mov    0x801120c4,%esi
801008d4:	53                   	push   %ebx
  int start = input.e, temp_e = input.e;
801008d5:	89 c3                	mov    %eax,%ebx
  while(temp_e != input.w &&
801008d7:	eb 25                	jmp    801008fe <count_line_chars+0x3e>
801008d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      input.buf[(temp_e-1) % INPUT_BUF] != '\n'){
801008e0:	8d 4b ff             	lea    -0x1(%ebx),%ecx
801008e3:	89 cf                	mov    %ecx,%edi
801008e5:	c1 ff 1f             	sar    $0x1f,%edi
801008e8:	c1 ef 19             	shr    $0x19,%edi
801008eb:	8d 14 39             	lea    (%ecx,%edi,1),%edx
801008ee:	83 e2 7f             	and    $0x7f,%edx
801008f1:	29 fa                	sub    %edi,%edx
  while(temp_e != input.w &&
801008f3:	80 ba 40 20 11 80 0a 	cmpb   $0xa,-0x7feedfc0(%edx)
801008fa:	74 14                	je     80100910 <count_line_chars+0x50>
    temp_e--;
801008fc:	89 cb                	mov    %ecx,%ebx
  while(temp_e != input.w &&
801008fe:	39 f3                	cmp    %esi,%ebx
80100900:	75 de                	jne    801008e0 <count_line_chars+0x20>
}
80100902:	5b                   	pop    %ebx
  return start - temp_e;
80100903:	29 f0                	sub    %esi,%eax
}
80100905:	5e                   	pop    %esi
80100906:	5f                   	pop    %edi
80100907:	5d                   	pop    %ebp
80100908:	c3                   	ret    
80100909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100910:	89 de                	mov    %ebx,%esi
80100912:	5b                   	pop    %ebx
  return start - temp_e;
80100913:	29 f0                	sub    %esi,%eax
}
80100915:	5e                   	pop    %esi
80100916:	5f                   	pop    %edi
80100917:	5d                   	pop    %ebp
80100918:	c3                   	ret    
80100919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100920 <fill_clipboard_buf>:
{
80100920:	f3 0f 1e fb          	endbr32 
  int temp_e = input.e, buf_idx = clipboard.size - 1;
80100924:	a1 c8 20 11 80       	mov    0x801120c8,%eax
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
80100929:	8b 0d 20 20 11 80    	mov    0x80112020,%ecx
{
8010092f:	55                   	push   %ebp
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
80100930:	29 c1                	sub    %eax,%ecx
{
80100932:	89 e5                	mov    %esp,%ebp
80100934:	56                   	push   %esi
80100935:	53                   	push   %ebx
  while(temp_e != input.w &&
80100936:	8b 1d c4 20 11 80    	mov    0x801120c4,%ebx
8010093c:	39 d8                	cmp    %ebx,%eax
8010093e:	75 13                	jne    80100953 <fill_clipboard_buf+0x33>
80100940:	eb 30                	jmp    80100972 <fill_clipboard_buf+0x52>
80100942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
80100948:	88 94 01 a0 1f 11 80 	mov    %dl,-0x7feee060(%ecx,%eax,1)
  while(temp_e != input.w &&
8010094f:	39 d8                	cmp    %ebx,%eax
80100951:	74 1f                	je     80100972 <fill_clipboard_buf+0x52>
      input.buf[(temp_e-1) % INPUT_BUF] != '\n'){
80100953:	83 e8 01             	sub    $0x1,%eax
80100956:	89 c6                	mov    %eax,%esi
80100958:	c1 fe 1f             	sar    $0x1f,%esi
8010095b:	c1 ee 19             	shr    $0x19,%esi
8010095e:	8d 14 30             	lea    (%eax,%esi,1),%edx
80100961:	83 e2 7f             	and    $0x7f,%edx
80100964:	29 f2                	sub    %esi,%edx
80100966:	0f b6 92 40 20 11 80 	movzbl -0x7feedfc0(%edx),%edx
  while(temp_e != input.w &&
8010096d:	80 fa 0a             	cmp    $0xa,%dl
80100970:	75 d6                	jne    80100948 <fill_clipboard_buf+0x28>
}
80100972:	5b                   	pop    %ebx
80100973:	5e                   	pop    %esi
80100974:	5d                   	pop    %ebp
80100975:	c3                   	ret    
80100976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097d:	8d 76 00             	lea    0x0(%esi),%esi

80100980 <copy_line>:
{
80100980:	f3 0f 1e fb          	endbr32 
80100984:	55                   	push   %ebp
80100985:	89 e5                	mov    %esp,%ebp
80100987:	57                   	push   %edi
80100988:	56                   	push   %esi
80100989:	53                   	push   %ebx
8010098a:	83 ec 0c             	sub    $0xc,%esp
  int start = input.e, temp_e = input.e;
8010098d:	8b 35 c8 20 11 80    	mov    0x801120c8,%esi
  while(temp_e != input.w &&
80100993:	8b 1d c4 20 11 80    	mov    0x801120c4,%ebx
  int start = input.e, temp_e = input.e;
80100999:	89 f1                	mov    %esi,%ecx
  while(temp_e != input.w &&
8010099b:	eb 21                	jmp    801009be <copy_line+0x3e>
8010099d:	8d 76 00             	lea    0x0(%esi),%esi
      input.buf[(temp_e-1) % INPUT_BUF] != '\n'){
801009a0:	8d 51 ff             	lea    -0x1(%ecx),%edx
801009a3:	89 d7                	mov    %edx,%edi
801009a5:	c1 ff 1f             	sar    $0x1f,%edi
801009a8:	c1 ef 19             	shr    $0x19,%edi
801009ab:	8d 04 3a             	lea    (%edx,%edi,1),%eax
801009ae:	83 e0 7f             	and    $0x7f,%eax
801009b1:	29 f8                	sub    %edi,%eax
  while(temp_e != input.w &&
801009b3:	80 b8 40 20 11 80 0a 	cmpb   $0xa,-0x7feedfc0(%eax)
801009ba:	74 7c                	je     80100a38 <copy_line+0xb8>
    temp_e--;
801009bc:	89 d1                	mov    %edx,%ecx
  while(temp_e != input.w &&
801009be:	39 cb                	cmp    %ecx,%ebx
801009c0:	75 de                	jne    801009a0 <copy_line+0x20>
  memset(clipboard.buf, 0, INPUT_BUF);
801009c2:	83 ec 04             	sub    $0x4,%esp
  return start - temp_e;
801009c5:	29 de                	sub    %ebx,%esi
  memset(clipboard.buf, 0, INPUT_BUF);
801009c7:	68 80 00 00 00       	push   $0x80
801009cc:	6a 00                	push   $0x0
801009ce:	68 a0 1f 11 80       	push   $0x80111fa0
  return start - temp_e;
801009d3:	89 35 20 20 11 80    	mov    %esi,0x80112020
  memset(clipboard.buf, 0, INPUT_BUF);
801009d9:	e8 22 4e 00 00       	call   80105800 <memset>
  int temp_e = input.e, buf_idx = clipboard.size - 1;
801009de:	a1 c8 20 11 80       	mov    0x801120c8,%eax
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
801009e3:	8b 0d 20 20 11 80    	mov    0x80112020,%ecx
  while(temp_e != input.w &&
801009e9:	83 c4 10             	add    $0x10,%esp
801009ec:	8b 1d c4 20 11 80    	mov    0x801120c4,%ebx
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
801009f2:	29 c1                	sub    %eax,%ecx
  while(temp_e != input.w &&
801009f4:	39 d8                	cmp    %ebx,%eax
801009f6:	75 13                	jne    80100a0b <copy_line+0x8b>
801009f8:	eb 30                	jmp    80100a2a <copy_line+0xaa>
801009fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
80100a00:	88 94 01 a0 1f 11 80 	mov    %dl,-0x7feee060(%ecx,%eax,1)
  while(temp_e != input.w &&
80100a07:	39 d8                	cmp    %ebx,%eax
80100a09:	74 1f                	je     80100a2a <copy_line+0xaa>
      input.buf[(temp_e-1) % INPUT_BUF] != '\n'){
80100a0b:	83 e8 01             	sub    $0x1,%eax
80100a0e:	89 c6                	mov    %eax,%esi
80100a10:	c1 fe 1f             	sar    $0x1f,%esi
80100a13:	c1 ee 19             	shr    $0x19,%esi
80100a16:	8d 14 30             	lea    (%eax,%esi,1),%edx
80100a19:	83 e2 7f             	and    $0x7f,%edx
80100a1c:	29 f2                	sub    %esi,%edx
80100a1e:	0f b6 92 40 20 11 80 	movzbl -0x7feedfc0(%edx),%edx
  while(temp_e != input.w &&
80100a25:	80 fa 0a             	cmp    $0xa,%dl
80100a28:	75 d6                	jne    80100a00 <copy_line+0x80>
}
80100a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a2d:	5b                   	pop    %ebx
80100a2e:	5e                   	pop    %esi
80100a2f:	5f                   	pop    %edi
80100a30:	5d                   	pop    %ebp
80100a31:	c3                   	ret    
80100a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a38:	89 cb                	mov    %ecx,%ebx
80100a3a:	eb 86                	jmp    801009c2 <copy_line+0x42>
80100a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a40 <handle_ordinary_char>:
{
80100a40:	f3 0f 1e fb          	endbr32 
80100a44:	55                   	push   %ebp
80100a45:	89 e5                	mov    %esp,%ebp
80100a47:	53                   	push   %ebx
80100a48:	83 ec 04             	sub    $0x4,%esp
80100a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(c != 0 && input.e-input.r < INPUT_BUF){
80100a4e:	84 db                	test   %bl,%bl
80100a50:	74 55                	je     80100aa7 <handle_ordinary_char+0x67>
80100a52:	a1 c8 20 11 80       	mov    0x801120c8,%eax
80100a57:	89 c2                	mov    %eax,%edx
80100a59:	2b 15 c0 20 11 80    	sub    0x801120c0,%edx
80100a5f:	83 fa 7f             	cmp    $0x7f,%edx
80100a62:	77 43                	ja     80100aa7 <handle_ordinary_char+0x67>
    c = (c == '\r') ? '\n' : c;
80100a64:	8d 48 01             	lea    0x1(%eax),%ecx
80100a67:	8b 15 d8 c5 10 80    	mov    0x8010c5d8,%edx
80100a6d:	83 e0 7f             	and    $0x7f,%eax
    input.buf[input.e++ % INPUT_BUF] = c;
80100a70:	89 0d c8 20 11 80    	mov    %ecx,0x801120c8
    c = (c == '\r') ? '\n' : c;
80100a76:	80 fb 0d             	cmp    $0xd,%bl
80100a79:	74 32                	je     80100aad <handle_ordinary_char+0x6d>
    input.buf[input.e++ % INPUT_BUF] = c;
80100a7b:	88 98 40 20 11 80    	mov    %bl,-0x7feedfc0(%eax)
  if(panicked){
80100a81:	85 d2                	test   %edx,%edx
80100a83:	75 33                	jne    80100ab8 <handle_ordinary_char+0x78>
    consputc(c);
80100a85:	0f be c3             	movsbl %bl,%eax
80100a88:	e8 83 f9 ff ff       	call   80100410 <consputc.part.0>
    if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a8d:	80 fb 0a             	cmp    $0xa,%bl
80100a90:	74 38                	je     80100aca <handle_ordinary_char+0x8a>
80100a92:	80 fb 04             	cmp    $0x4,%bl
80100a95:	74 33                	je     80100aca <handle_ordinary_char+0x8a>
80100a97:	a1 c0 20 11 80       	mov    0x801120c0,%eax
80100a9c:	83 e8 80             	sub    $0xffffff80,%eax
80100a9f:	39 05 c8 20 11 80    	cmp    %eax,0x801120c8
80100aa5:	74 28                	je     80100acf <handle_ordinary_char+0x8f>
}
80100aa7:	83 c4 04             	add    $0x4,%esp
80100aaa:	5b                   	pop    %ebx
80100aab:	5d                   	pop    %ebp
80100aac:	c3                   	ret    
    input.buf[input.e++ % INPUT_BUF] = c;
80100aad:	c6 80 40 20 11 80 0a 	movb   $0xa,-0x7feedfc0(%eax)
  if(panicked){
80100ab4:	85 d2                	test   %edx,%edx
80100ab6:	74 08                	je     80100ac0 <handle_ordinary_char+0x80>
80100ab8:	fa                   	cli    
    for(;;)
80100ab9:	eb fe                	jmp    80100ab9 <handle_ordinary_char+0x79>
80100abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100abf:	90                   	nop
80100ac0:	b8 0a 00 00 00       	mov    $0xa,%eax
80100ac5:	e8 46 f9 ff ff       	call   80100410 <consputc.part.0>
    if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100aca:	a1 c8 20 11 80       	mov    0x801120c8,%eax
      wakeup(&input.r);
80100acf:	c7 45 08 c0 20 11 80 	movl   $0x801120c0,0x8(%ebp)
      input.w = input.e;
80100ad6:	a3 c4 20 11 80       	mov    %eax,0x801120c4
}
80100adb:	83 c4 04             	add    $0x4,%esp
80100ade:	5b                   	pop    %ebx
80100adf:	5d                   	pop    %ebp
      wakeup(&input.r);
80100ae0:	e9 6b 47 00 00       	jmp    80105250 <wakeup>
80100ae5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100af0 <paste_line>:
{
80100af0:	f3 0f 1e fb          	endbr32 
  for(int i=0; i<clipboard.size; i++){
80100af4:	a1 20 20 11 80       	mov    0x80112020,%eax
80100af9:	85 c0                	test   %eax,%eax
80100afb:	7e 3b                	jle    80100b38 <paste_line+0x48>
{
80100afd:	55                   	push   %ebp
80100afe:	89 e5                	mov    %esp,%ebp
80100b00:	53                   	push   %ebx
  for(int i=0; i<clipboard.size; i++){
80100b01:	31 db                	xor    %ebx,%ebx
{
80100b03:	83 ec 04             	sub    $0x4,%esp
80100b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b0d:	8d 76 00             	lea    0x0(%esi),%esi
    handle_ordinary_char(c);
80100b10:	0f be 83 a0 1f 11 80 	movsbl -0x7feee060(%ebx),%eax
80100b17:	83 ec 0c             	sub    $0xc,%esp
  for(int i=0; i<clipboard.size; i++){
80100b1a:	83 c3 01             	add    $0x1,%ebx
    handle_ordinary_char(c);
80100b1d:	50                   	push   %eax
80100b1e:	e8 1d ff ff ff       	call   80100a40 <handle_ordinary_char>
  for(int i=0; i<clipboard.size; i++){
80100b23:	83 c4 10             	add    $0x10,%esp
80100b26:	39 1d 20 20 11 80    	cmp    %ebx,0x80112020
80100b2c:	7f e2                	jg     80100b10 <paste_line+0x20>
}
80100b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100b31:	c9                   	leave  
80100b32:	c3                   	ret    
80100b33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b37:	90                   	nop
80100b38:	c3                   	ret    
80100b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100b40 <consoleintr>:
{
80100b40:	f3 0f 1e fb          	endbr32 
80100b44:	55                   	push   %ebp
80100b45:	89 e5                	mov    %esp,%ebp
80100b47:	57                   	push   %edi
80100b48:	56                   	push   %esi
  int c, doprocdump = 0;
80100b49:	31 f6                	xor    %esi,%esi
{
80100b4b:	53                   	push   %ebx
80100b4c:	83 ec 18             	sub    $0x18,%esp
80100b4f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100b52:	68 a0 c5 10 80       	push   $0x8010c5a0
80100b57:	e8 94 4b 00 00       	call   801056f0 <acquire>
  while((c = getc()) >= 0){
80100b5c:	83 c4 10             	add    $0x10,%esp
80100b5f:	ff d7                	call   *%edi
80100b61:	89 c3                	mov    %eax,%ebx
80100b63:	85 c0                	test   %eax,%eax
80100b65:	78 30                	js     80100b97 <consoleintr+0x57>
    switch(c){
80100b67:	83 fb 18             	cmp    $0x18,%ebx
80100b6a:	0f 8f 51 01 00 00    	jg     80100cc1 <consoleintr+0x181>
80100b70:	83 fb 01             	cmp    $0x1,%ebx
80100b73:	0f 8e ab 01 00 00    	jle    80100d24 <consoleintr+0x1e4>
80100b79:	83 fb 18             	cmp    $0x18,%ebx
80100b7c:	0f 87 a2 01 00 00    	ja     80100d24 <consoleintr+0x1e4>
80100b82:	3e ff 24 9d 10 85 10 	notrack jmp *-0x7fef7af0(,%ebx,4)
80100b89:	80 
  while((c = getc()) >= 0){
80100b8a:	ff d7                	call   *%edi
    switch(c){
80100b8c:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100b91:	89 c3                	mov    %eax,%ebx
80100b93:	85 c0                	test   %eax,%eax
80100b95:	79 d0                	jns    80100b67 <consoleintr+0x27>
  release(&cons.lock);
80100b97:	83 ec 0c             	sub    $0xc,%esp
80100b9a:	68 a0 c5 10 80       	push   $0x8010c5a0
80100b9f:	e8 0c 4c 00 00       	call   801057b0 <release>
  if(doprocdump) {
80100ba4:	83 c4 10             	add    $0x10,%esp
80100ba7:	85 f6                	test   %esi,%esi
80100ba9:	0f 85 90 01 00 00    	jne    80100d3f <consoleintr+0x1ff>
}
80100baf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100bb2:	5b                   	pop    %ebx
80100bb3:	5e                   	pop    %esi
80100bb4:	5f                   	pop    %edi
80100bb5:	5d                   	pop    %ebp
80100bb6:	c3                   	ret    
80100bb7:	b8 00 01 00 00       	mov    $0x100,%eax
80100bbc:	e8 4f f8 ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100bc1:	a1 c8 20 11 80       	mov    0x801120c8,%eax
80100bc6:	3b 05 c4 20 11 80    	cmp    0x801120c4,%eax
80100bcc:	74 91                	je     80100b5f <consoleintr+0x1f>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100bce:	83 e8 01             	sub    $0x1,%eax
80100bd1:	89 c2                	mov    %eax,%edx
80100bd3:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100bd6:	80 ba 40 20 11 80 0a 	cmpb   $0xa,-0x7feedfc0(%edx)
80100bdd:	74 80                	je     80100b5f <consoleintr+0x1f>
  if(panicked){
80100bdf:	8b 0d d8 c5 10 80    	mov    0x8010c5d8,%ecx
        input.e--;
80100be5:	a3 c8 20 11 80       	mov    %eax,0x801120c8
  if(panicked){
80100bea:	85 c9                	test   %ecx,%ecx
80100bec:	74 c9                	je     80100bb7 <consoleintr+0x77>
80100bee:	fa                   	cli    
    for(;;)
80100bef:	eb fe                	jmp    80100bef <consoleintr+0xaf>
      cons.locking = 0;
80100bf1:	c7 05 d4 c5 10 80 00 	movl   $0x0,0x8010c5d4
80100bf8:	00 00 00 
      cprintf("%s",input.buf);
80100bfb:	83 ec 08             	sub    $0x8,%esp
80100bfe:	68 40 20 11 80       	push   $0x80112040
80100c03:	68 6e 8b 10 80       	push   $0x80108b6e
80100c08:	e8 a3 fa ff ff       	call   801006b0 <cprintf>
      break;
80100c0d:	83 c4 10             	add    $0x10,%esp
80100c10:	e9 4a ff ff ff       	jmp    80100b5f <consoleintr+0x1f>
      copy_line();
80100c15:	e8 66 fd ff ff       	call   80100980 <copy_line>
      kill_line();
80100c1a:	e8 41 fc ff ff       	call   80100860 <kill_line>
      break;
80100c1f:	e9 3b ff ff ff       	jmp    80100b5f <consoleintr+0x1f>
  for(int i=0; i<clipboard.size; i++){
80100c24:	a1 20 20 11 80       	mov    0x80112020,%eax
80100c29:	31 db                	xor    %ebx,%ebx
80100c2b:	85 c0                	test   %eax,%eax
80100c2d:	0f 8e 2c ff ff ff    	jle    80100b5f <consoleintr+0x1f>
    handle_ordinary_char(c);
80100c33:	0f be 83 a0 1f 11 80 	movsbl -0x7feee060(%ebx),%eax
80100c3a:	83 ec 0c             	sub    $0xc,%esp
  for(int i=0; i<clipboard.size; i++){
80100c3d:	83 c3 01             	add    $0x1,%ebx
    handle_ordinary_char(c);
80100c40:	50                   	push   %eax
80100c41:	e8 fa fd ff ff       	call   80100a40 <handle_ordinary_char>
  for(int i=0; i<clipboard.size; i++){
80100c46:	83 c4 10             	add    $0x10,%esp
80100c49:	3b 1d 20 20 11 80    	cmp    0x80112020,%ebx
80100c4f:	7c e2                	jl     80100c33 <consoleintr+0xf3>
80100c51:	e9 09 ff ff ff       	jmp    80100b5f <consoleintr+0x1f>
      if(input.e != input.w){
80100c56:	a1 c8 20 11 80       	mov    0x801120c8,%eax
80100c5b:	3b 05 c4 20 11 80    	cmp    0x801120c4,%eax
80100c61:	0f 84 f8 fe ff ff    	je     80100b5f <consoleintr+0x1f>
  if(panicked){
80100c67:	8b 15 d8 c5 10 80    	mov    0x8010c5d8,%edx
        input.e--;
80100c6d:	83 e8 01             	sub    $0x1,%eax
80100c70:	a3 c8 20 11 80       	mov    %eax,0x801120c8
  if(panicked){
80100c75:	85 d2                	test   %edx,%edx
80100c77:	0f 84 b3 00 00 00    	je     80100d30 <consoleintr+0x1f0>
80100c7d:	fa                   	cli    
    for(;;)
80100c7e:	eb fe                	jmp    80100c7e <consoleintr+0x13e>
      copy_line();
80100c80:	e8 fb fc ff ff       	call   80100980 <copy_line>
      break;
80100c85:	e9 d5 fe ff ff       	jmp    80100b5f <consoleintr+0x1f>
      kill_line();
80100c8a:	e8 d1 fb ff ff       	call   80100860 <kill_line>
  for(int i=0; i<clipboard.size; i++){
80100c8f:	a1 20 20 11 80       	mov    0x80112020,%eax
80100c94:	85 c0                	test   %eax,%eax
80100c96:	0f 8e c3 fe ff ff    	jle    80100b5f <consoleintr+0x1f>
80100c9c:	31 db                	xor    %ebx,%ebx
    handle_ordinary_char(c);
80100c9e:	0f be 83 a0 1f 11 80 	movsbl -0x7feee060(%ebx),%eax
80100ca5:	83 ec 0c             	sub    $0xc,%esp
  for(int i=0; i<clipboard.size; i++){
80100ca8:	83 c3 01             	add    $0x1,%ebx
    handle_ordinary_char(c);
80100cab:	50                   	push   %eax
80100cac:	e8 8f fd ff ff       	call   80100a40 <handle_ordinary_char>
  for(int i=0; i<clipboard.size; i++){
80100cb1:	83 c4 10             	add    $0x10,%esp
80100cb4:	3b 1d 20 20 11 80    	cmp    0x80112020,%ebx
80100cba:	7c e2                	jl     80100c9e <consoleintr+0x15e>
80100cbc:	e9 9e fe ff ff       	jmp    80100b5f <consoleintr+0x1f>
    switch(c){
80100cc1:	83 fb 7f             	cmp    $0x7f,%ebx
80100cc4:	74 90                	je     80100c56 <consoleintr+0x116>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100cc6:	a1 c8 20 11 80       	mov    0x801120c8,%eax
80100ccb:	89 c2                	mov    %eax,%edx
80100ccd:	2b 15 c0 20 11 80    	sub    0x801120c0,%edx
80100cd3:	83 fa 7f             	cmp    $0x7f,%edx
80100cd6:	0f 87 83 fe ff ff    	ja     80100b5f <consoleintr+0x1f>
        c = (c == '\r') ? '\n' : c;
80100cdc:	8d 48 01             	lea    0x1(%eax),%ecx
80100cdf:	8b 15 d8 c5 10 80    	mov    0x8010c5d8,%edx
80100ce5:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100ce8:	89 0d c8 20 11 80    	mov    %ecx,0x801120c8
        c = (c == '\r') ? '\n' : c;
80100cee:	83 fb 0d             	cmp    $0xd,%ebx
80100cf1:	74 58                	je     80100d4b <consoleintr+0x20b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100cf3:	88 98 40 20 11 80    	mov    %bl,-0x7feedfc0(%eax)
  if(panicked){
80100cf9:	85 d2                	test   %edx,%edx
80100cfb:	75 59                	jne    80100d56 <consoleintr+0x216>
80100cfd:	89 d8                	mov    %ebx,%eax
80100cff:	e8 0c f7 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100d04:	83 fb 0a             	cmp    $0xa,%ebx
80100d07:	74 61                	je     80100d6a <consoleintr+0x22a>
80100d09:	83 fb 04             	cmp    $0x4,%ebx
80100d0c:	74 5c                	je     80100d6a <consoleintr+0x22a>
80100d0e:	a1 c0 20 11 80       	mov    0x801120c0,%eax
80100d13:	83 e8 80             	sub    $0xffffff80,%eax
80100d16:	39 05 c8 20 11 80    	cmp    %eax,0x801120c8
80100d1c:	0f 85 3d fe ff ff    	jne    80100b5f <consoleintr+0x1f>
80100d22:	eb 4b                	jmp    80100d6f <consoleintr+0x22f>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100d24:	85 db                	test   %ebx,%ebx
80100d26:	0f 84 33 fe ff ff    	je     80100b5f <consoleintr+0x1f>
80100d2c:	eb 98                	jmp    80100cc6 <consoleintr+0x186>
80100d2e:	66 90                	xchg   %ax,%ax
80100d30:	b8 00 01 00 00       	mov    $0x100,%eax
80100d35:	e8 d6 f6 ff ff       	call   80100410 <consputc.part.0>
80100d3a:	e9 20 fe ff ff       	jmp    80100b5f <consoleintr+0x1f>
}
80100d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d42:	5b                   	pop    %ebx
80100d43:	5e                   	pop    %esi
80100d44:	5f                   	pop    %edi
80100d45:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100d46:	e9 05 46 00 00       	jmp    80105350 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d4b:	c6 80 40 20 11 80 0a 	movb   $0xa,-0x7feedfc0(%eax)
  if(panicked){
80100d52:	85 d2                	test   %edx,%edx
80100d54:	74 0a                	je     80100d60 <consoleintr+0x220>
80100d56:	fa                   	cli    
    for(;;)
80100d57:	eb fe                	jmp    80100d57 <consoleintr+0x217>
80100d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d60:	b8 0a 00 00 00       	mov    $0xa,%eax
80100d65:	e8 a6 f6 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100d6a:	a1 c8 20 11 80       	mov    0x801120c8,%eax
          wakeup(&input.r);
80100d6f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100d72:	a3 c4 20 11 80       	mov    %eax,0x801120c4
          wakeup(&input.r);
80100d77:	68 c0 20 11 80       	push   $0x801120c0
80100d7c:	e8 cf 44 00 00       	call   80105250 <wakeup>
80100d81:	83 c4 10             	add    $0x10,%esp
80100d84:	e9 d6 fd ff ff       	jmp    80100b5f <consoleintr+0x1f>
80100d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100d90 <consoleinit>:

void
consoleinit(void)
{
80100d90:	f3 0f 1e fb          	endbr32 
80100d94:	55                   	push   %ebp
80100d95:	89 e5                	mov    %esp,%ebp
80100d97:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100d9a:	68 08 85 10 80       	push   $0x80108508
80100d9f:	68 a0 c5 10 80       	push   $0x8010c5a0
80100da4:	e8 c7 47 00 00       	call   80105570 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100da9:	58                   	pop    %eax
80100daa:	5a                   	pop    %edx
80100dab:	6a 00                	push   $0x0
80100dad:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100daf:	c7 05 8c 2a 11 80 40 	movl   $0x80100640,0x80112a8c
80100db6:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100db9:	c7 05 88 2a 11 80 90 	movl   $0x80100290,0x80112a88
80100dc0:	02 10 80 
  cons.locking = 1;
80100dc3:	c7 05 d4 c5 10 80 01 	movl   $0x1,0x8010c5d4
80100dca:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100dcd:	e8 ce 19 00 00       	call   801027a0 <ioapicenable>
80100dd2:	83 c4 10             	add    $0x10,%esp
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	66 90                	xchg   %ax,%ax
80100dd9:	66 90                	xchg   %ax,%ax
80100ddb:	66 90                	xchg   %ax,%ax
80100ddd:	66 90                	xchg   %ax,%ax
80100ddf:	90                   	nop

80100de0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	57                   	push   %edi
80100de8:	56                   	push   %esi
80100de9:	53                   	push   %ebx
80100dea:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100df0:	e8 ab 2f 00 00       	call   80103da0 <myproc>
  curproc->q_level = 1;
80100df5:	c7 80 f0 00 00 00 01 	movl   $0x1,0xf0(%eax)
80100dfc:	00 00 00 
  struct proc *curproc = myproc();
80100dff:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100e05:	e8 96 22 00 00       	call   801030a0 <begin_op>

  if((ip = namei(path)) == 0){
80100e0a:	83 ec 0c             	sub    $0xc,%esp
80100e0d:	ff 75 08             	pushl  0x8(%ebp)
80100e10:	e8 8b 15 00 00       	call   801023a0 <namei>
80100e15:	83 c4 10             	add    $0x10,%esp
80100e18:	85 c0                	test   %eax,%eax
80100e1a:	0f 84 04 03 00 00    	je     80101124 <exec+0x344>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100e20:	83 ec 0c             	sub    $0xc,%esp
80100e23:	89 c3                	mov    %eax,%ebx
80100e25:	50                   	push   %eax
80100e26:	e8 a5 0c 00 00       	call   80101ad0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100e2b:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100e31:	6a 34                	push   $0x34
80100e33:	6a 00                	push   $0x0
80100e35:	50                   	push   %eax
80100e36:	53                   	push   %ebx
80100e37:	e8 94 0f 00 00       	call   80101dd0 <readi>
80100e3c:	83 c4 20             	add    $0x20,%esp
80100e3f:	83 f8 34             	cmp    $0x34,%eax
80100e42:	74 24                	je     80100e68 <exec+0x88>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100e44:	83 ec 0c             	sub    $0xc,%esp
80100e47:	53                   	push   %ebx
80100e48:	e8 23 0f 00 00       	call   80101d70 <iunlockput>
    end_op();
80100e4d:	e8 be 22 00 00       	call   80103110 <end_op>
80100e52:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100e55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e5d:	5b                   	pop    %ebx
80100e5e:	5e                   	pop    %esi
80100e5f:	5f                   	pop    %edi
80100e60:	5d                   	pop    %ebp
80100e61:	c3                   	ret    
80100e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100e68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100e6f:	45 4c 46 
80100e72:	75 d0                	jne    80100e44 <exec+0x64>
  if((pgdir = setupkvm()) == 0)
80100e74:	e8 87 73 00 00       	call   80108200 <setupkvm>
80100e79:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100e7f:	85 c0                	test   %eax,%eax
80100e81:	74 c1                	je     80100e44 <exec+0x64>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100e8a:	00 
80100e8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100e91:	0f 84 ac 02 00 00    	je     80101143 <exec+0x363>
  sz = 0;
80100e97:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e9e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ea1:	31 ff                	xor    %edi,%edi
80100ea3:	e9 8e 00 00 00       	jmp    80100f36 <exec+0x156>
80100ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eaf:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100eb0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100eb7:	75 6c                	jne    80100f25 <exec+0x145>
    if(ph.memsz < ph.filesz)
80100eb9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ebf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ec5:	0f 82 87 00 00 00    	jb     80100f52 <exec+0x172>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ecb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ed1:	72 7f                	jb     80100f52 <exec+0x172>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ed3:	83 ec 04             	sub    $0x4,%esp
80100ed6:	50                   	push   %eax
80100ed7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100edd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ee3:	e8 38 71 00 00       	call   80108020 <allocuvm>
80100ee8:	83 c4 10             	add    $0x10,%esp
80100eeb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ef1:	85 c0                	test   %eax,%eax
80100ef3:	74 5d                	je     80100f52 <exec+0x172>
    if(ph.vaddr % PGSIZE != 0)
80100ef5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100efb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100f00:	75 50                	jne    80100f52 <exec+0x172>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100f02:	83 ec 0c             	sub    $0xc,%esp
80100f05:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100f0b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100f11:	53                   	push   %ebx
80100f12:	50                   	push   %eax
80100f13:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f19:	e8 32 70 00 00       	call   80107f50 <loaduvm>
80100f1e:	83 c4 20             	add    $0x20,%esp
80100f21:	85 c0                	test   %eax,%eax
80100f23:	78 2d                	js     80100f52 <exec+0x172>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f25:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100f2c:	83 c7 01             	add    $0x1,%edi
80100f2f:	83 c6 20             	add    $0x20,%esi
80100f32:	39 f8                	cmp    %edi,%eax
80100f34:	7e 3a                	jle    80100f70 <exec+0x190>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100f36:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100f3c:	6a 20                	push   $0x20
80100f3e:	56                   	push   %esi
80100f3f:	50                   	push   %eax
80100f40:	53                   	push   %ebx
80100f41:	e8 8a 0e 00 00       	call   80101dd0 <readi>
80100f46:	83 c4 10             	add    $0x10,%esp
80100f49:	83 f8 20             	cmp    $0x20,%eax
80100f4c:	0f 84 5e ff ff ff    	je     80100eb0 <exec+0xd0>
    freevm(pgdir);
80100f52:	83 ec 0c             	sub    $0xc,%esp
80100f55:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f5b:	e8 20 72 00 00       	call   80108180 <freevm>
  if(ip){
80100f60:	83 c4 10             	add    $0x10,%esp
80100f63:	e9 dc fe ff ff       	jmp    80100e44 <exec+0x64>
80100f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6f:	90                   	nop
80100f70:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100f76:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100f7c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100f82:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100f88:	83 ec 0c             	sub    $0xc,%esp
80100f8b:	53                   	push   %ebx
80100f8c:	e8 df 0d 00 00       	call   80101d70 <iunlockput>
  end_op();
80100f91:	e8 7a 21 00 00       	call   80103110 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f96:	83 c4 0c             	add    $0xc,%esp
80100f99:	56                   	push   %esi
80100f9a:	57                   	push   %edi
80100f9b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100fa1:	57                   	push   %edi
80100fa2:	e8 79 70 00 00       	call   80108020 <allocuvm>
80100fa7:	83 c4 10             	add    $0x10,%esp
80100faa:	89 c6                	mov    %eax,%esi
80100fac:	85 c0                	test   %eax,%eax
80100fae:	0f 84 94 00 00 00    	je     80101048 <exec+0x268>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100fbd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fbf:	50                   	push   %eax
80100fc0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100fc1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fc3:	e8 d8 72 00 00       	call   801082a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fcb:	83 c4 10             	add    $0x10,%esp
80100fce:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100fd4:	8b 00                	mov    (%eax),%eax
80100fd6:	85 c0                	test   %eax,%eax
80100fd8:	0f 84 8b 00 00 00    	je     80101069 <exec+0x289>
80100fde:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100fe4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100fea:	eb 23                	jmp    8010100f <exec+0x22f>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ff3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100ffa:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100ffd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101003:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101006:	85 c0                	test   %eax,%eax
80101008:	74 59                	je     80101063 <exec+0x283>
    if(argc >= MAXARG)
8010100a:	83 ff 20             	cmp    $0x20,%edi
8010100d:	74 39                	je     80101048 <exec+0x268>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	50                   	push   %eax
80101013:	e8 e8 49 00 00       	call   80105a00 <strlen>
80101018:	f7 d0                	not    %eax
8010101a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010101c:	58                   	pop    %eax
8010101d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101020:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101023:	ff 34 b8             	pushl  (%eax,%edi,4)
80101026:	e8 d5 49 00 00       	call   80105a00 <strlen>
8010102b:	83 c0 01             	add    $0x1,%eax
8010102e:	50                   	push   %eax
8010102f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101032:	ff 34 b8             	pushl  (%eax,%edi,4)
80101035:	53                   	push   %ebx
80101036:	56                   	push   %esi
80101037:	e8 c4 73 00 00       	call   80108400 <copyout>
8010103c:	83 c4 20             	add    $0x20,%esp
8010103f:	85 c0                	test   %eax,%eax
80101041:	79 ad                	jns    80100ff0 <exec+0x210>
80101043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101047:	90                   	nop
    freevm(pgdir);
80101048:	83 ec 0c             	sub    $0xc,%esp
8010104b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101051:	e8 2a 71 00 00       	call   80108180 <freevm>
80101056:	83 c4 10             	add    $0x10,%esp
  return -1;
80101059:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010105e:	e9 f7 fd ff ff       	jmp    80100e5a <exec+0x7a>
80101063:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101069:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101070:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101072:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101079:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010107d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010107f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101082:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101088:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010108a:	50                   	push   %eax
8010108b:	52                   	push   %edx
8010108c:	53                   	push   %ebx
8010108d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101093:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010109a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010109d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010a3:	e8 58 73 00 00       	call   80108400 <copyout>
801010a8:	83 c4 10             	add    $0x10,%esp
801010ab:	85 c0                	test   %eax,%eax
801010ad:	78 99                	js     80101048 <exec+0x268>
  for(last=s=path; *s; s++)
801010af:	8b 45 08             	mov    0x8(%ebp),%eax
801010b2:	8b 55 08             	mov    0x8(%ebp),%edx
801010b5:	0f b6 00             	movzbl (%eax),%eax
801010b8:	84 c0                	test   %al,%al
801010ba:	74 13                	je     801010cf <exec+0x2ef>
801010bc:	89 d1                	mov    %edx,%ecx
801010be:	66 90                	xchg   %ax,%ax
    if(*s == '/')
801010c0:	83 c1 01             	add    $0x1,%ecx
801010c3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801010c5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
801010c8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801010cb:	84 c0                	test   %al,%al
801010cd:	75 f1                	jne    801010c0 <exec+0x2e0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010cf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801010d5:	83 ec 04             	sub    $0x4,%esp
801010d8:	6a 10                	push   $0x10
801010da:	89 f8                	mov    %edi,%eax
801010dc:	52                   	push   %edx
801010dd:	83 c0 6c             	add    $0x6c,%eax
801010e0:	50                   	push   %eax
801010e1:	e8 da 48 00 00       	call   801059c0 <safestrcpy>
  curproc->pgdir = pgdir;
801010e6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801010ec:	89 f8                	mov    %edi,%eax
801010ee:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
801010f1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
801010f3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801010f6:	89 c1                	mov    %eax,%ecx
801010f8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801010fe:	8b 40 18             	mov    0x18(%eax),%eax
80101101:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101104:	8b 41 18             	mov    0x18(%ecx),%eax
80101107:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010110a:	89 0c 24             	mov    %ecx,(%esp)
8010110d:	e8 ae 6c 00 00       	call   80107dc0 <switchuvm>
  freevm(oldpgdir);
80101112:	89 3c 24             	mov    %edi,(%esp)
80101115:	e8 66 70 00 00       	call   80108180 <freevm>
  return 0;
8010111a:	83 c4 10             	add    $0x10,%esp
8010111d:	31 c0                	xor    %eax,%eax
8010111f:	e9 36 fd ff ff       	jmp    80100e5a <exec+0x7a>
    end_op();
80101124:	e8 e7 1f 00 00       	call   80103110 <end_op>
    cprintf("exec: fail\n");
80101129:	83 ec 0c             	sub    $0xc,%esp
8010112c:	68 85 85 10 80       	push   $0x80108585
80101131:	e8 7a f5 ff ff       	call   801006b0 <cprintf>
    return -1;
80101136:	83 c4 10             	add    $0x10,%esp
80101139:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010113e:	e9 17 fd ff ff       	jmp    80100e5a <exec+0x7a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101143:	31 ff                	xor    %edi,%edi
80101145:	be 00 20 00 00       	mov    $0x2000,%esi
8010114a:	e9 39 fe ff ff       	jmp    80100f88 <exec+0x1a8>
8010114f:	90                   	nop

80101150 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101150:	f3 0f 1e fb          	endbr32 
80101154:	55                   	push   %ebp
80101155:	89 e5                	mov    %esp,%ebp
80101157:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010115a:	68 91 85 10 80       	push   $0x80108591
8010115f:	68 e0 20 11 80       	push   $0x801120e0
80101164:	e8 07 44 00 00       	call   80105570 <initlock>
}
80101169:	83 c4 10             	add    $0x10,%esp
8010116c:	c9                   	leave  
8010116d:	c3                   	ret    
8010116e:	66 90                	xchg   %ax,%ax

80101170 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101170:	f3 0f 1e fb          	endbr32 
80101174:	55                   	push   %ebp
80101175:	89 e5                	mov    %esp,%ebp
80101177:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101178:	bb 14 21 11 80       	mov    $0x80112114,%ebx
{
8010117d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101180:	68 e0 20 11 80       	push   $0x801120e0
80101185:	e8 66 45 00 00       	call   801056f0 <acquire>
8010118a:	83 c4 10             	add    $0x10,%esp
8010118d:	eb 0c                	jmp    8010119b <filealloc+0x2b>
8010118f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101190:	83 c3 18             	add    $0x18,%ebx
80101193:	81 fb 74 2a 11 80    	cmp    $0x80112a74,%ebx
80101199:	74 25                	je     801011c0 <filealloc+0x50>
    if(f->ref == 0){
8010119b:	8b 43 04             	mov    0x4(%ebx),%eax
8010119e:	85 c0                	test   %eax,%eax
801011a0:	75 ee                	jne    80101190 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801011a2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801011a5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801011ac:	68 e0 20 11 80       	push   $0x801120e0
801011b1:	e8 fa 45 00 00       	call   801057b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801011b6:	89 d8                	mov    %ebx,%eax
      return f;
801011b8:	83 c4 10             	add    $0x10,%esp
}
801011bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011be:	c9                   	leave  
801011bf:	c3                   	ret    
  release(&ftable.lock);
801011c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801011c3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801011c5:	68 e0 20 11 80       	push   $0x801120e0
801011ca:	e8 e1 45 00 00       	call   801057b0 <release>
}
801011cf:	89 d8                	mov    %ebx,%eax
  return 0;
801011d1:	83 c4 10             	add    $0x10,%esp
}
801011d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011d7:	c9                   	leave  
801011d8:	c3                   	ret    
801011d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801011e0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801011e0:	f3 0f 1e fb          	endbr32 
801011e4:	55                   	push   %ebp
801011e5:	89 e5                	mov    %esp,%ebp
801011e7:	53                   	push   %ebx
801011e8:	83 ec 10             	sub    $0x10,%esp
801011eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801011ee:	68 e0 20 11 80       	push   $0x801120e0
801011f3:	e8 f8 44 00 00       	call   801056f0 <acquire>
  if(f->ref < 1)
801011f8:	8b 43 04             	mov    0x4(%ebx),%eax
801011fb:	83 c4 10             	add    $0x10,%esp
801011fe:	85 c0                	test   %eax,%eax
80101200:	7e 1a                	jle    8010121c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101202:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101205:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101208:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010120b:	68 e0 20 11 80       	push   $0x801120e0
80101210:	e8 9b 45 00 00       	call   801057b0 <release>
  return f;
}
80101215:	89 d8                	mov    %ebx,%eax
80101217:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010121a:	c9                   	leave  
8010121b:	c3                   	ret    
    panic("filedup");
8010121c:	83 ec 0c             	sub    $0xc,%esp
8010121f:	68 98 85 10 80       	push   $0x80108598
80101224:	e8 67 f1 ff ff       	call   80100390 <panic>
80101229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101230 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101230:	f3 0f 1e fb          	endbr32 
80101234:	55                   	push   %ebp
80101235:	89 e5                	mov    %esp,%ebp
80101237:	57                   	push   %edi
80101238:	56                   	push   %esi
80101239:	53                   	push   %ebx
8010123a:	83 ec 28             	sub    $0x28,%esp
8010123d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101240:	68 e0 20 11 80       	push   $0x801120e0
80101245:	e8 a6 44 00 00       	call   801056f0 <acquire>
  if(f->ref < 1)
8010124a:	8b 53 04             	mov    0x4(%ebx),%edx
8010124d:	83 c4 10             	add    $0x10,%esp
80101250:	85 d2                	test   %edx,%edx
80101252:	0f 8e a1 00 00 00    	jle    801012f9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101258:	83 ea 01             	sub    $0x1,%edx
8010125b:	89 53 04             	mov    %edx,0x4(%ebx)
8010125e:	75 40                	jne    801012a0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101260:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101264:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101267:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101269:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010126f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101272:	88 45 e7             	mov    %al,-0x19(%ebp)
80101275:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101278:	68 e0 20 11 80       	push   $0x801120e0
  ff = *f;
8010127d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101280:	e8 2b 45 00 00       	call   801057b0 <release>

  if(ff.type == FD_PIPE)
80101285:	83 c4 10             	add    $0x10,%esp
80101288:	83 ff 01             	cmp    $0x1,%edi
8010128b:	74 53                	je     801012e0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010128d:	83 ff 02             	cmp    $0x2,%edi
80101290:	74 26                	je     801012b8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101292:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101295:	5b                   	pop    %ebx
80101296:	5e                   	pop    %esi
80101297:	5f                   	pop    %edi
80101298:	5d                   	pop    %ebp
80101299:	c3                   	ret    
8010129a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
801012a0:	c7 45 08 e0 20 11 80 	movl   $0x801120e0,0x8(%ebp)
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	5b                   	pop    %ebx
801012ab:	5e                   	pop    %esi
801012ac:	5f                   	pop    %edi
801012ad:	5d                   	pop    %ebp
    release(&ftable.lock);
801012ae:	e9 fd 44 00 00       	jmp    801057b0 <release>
801012b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012b7:	90                   	nop
    begin_op();
801012b8:	e8 e3 1d 00 00       	call   801030a0 <begin_op>
    iput(ff.ip);
801012bd:	83 ec 0c             	sub    $0xc,%esp
801012c0:	ff 75 e0             	pushl  -0x20(%ebp)
801012c3:	e8 38 09 00 00       	call   80101c00 <iput>
    end_op();
801012c8:	83 c4 10             	add    $0x10,%esp
}
801012cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ce:	5b                   	pop    %ebx
801012cf:	5e                   	pop    %esi
801012d0:	5f                   	pop    %edi
801012d1:	5d                   	pop    %ebp
    end_op();
801012d2:	e9 39 1e 00 00       	jmp    80103110 <end_op>
801012d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012de:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801012e0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801012e4:	83 ec 08             	sub    $0x8,%esp
801012e7:	53                   	push   %ebx
801012e8:	56                   	push   %esi
801012e9:	e8 82 25 00 00       	call   80103870 <pipeclose>
801012ee:	83 c4 10             	add    $0x10,%esp
}
801012f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012f4:	5b                   	pop    %ebx
801012f5:	5e                   	pop    %esi
801012f6:	5f                   	pop    %edi
801012f7:	5d                   	pop    %ebp
801012f8:	c3                   	ret    
    panic("fileclose");
801012f9:	83 ec 0c             	sub    $0xc,%esp
801012fc:	68 a0 85 10 80       	push   $0x801085a0
80101301:	e8 8a f0 ff ff       	call   80100390 <panic>
80101306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010130d:	8d 76 00             	lea    0x0(%esi),%esi

80101310 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101310:	f3 0f 1e fb          	endbr32 
80101314:	55                   	push   %ebp
80101315:	89 e5                	mov    %esp,%ebp
80101317:	53                   	push   %ebx
80101318:	83 ec 04             	sub    $0x4,%esp
8010131b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010131e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101321:	75 2d                	jne    80101350 <filestat+0x40>
    ilock(f->ip);
80101323:	83 ec 0c             	sub    $0xc,%esp
80101326:	ff 73 10             	pushl  0x10(%ebx)
80101329:	e8 a2 07 00 00       	call   80101ad0 <ilock>
    stati(f->ip, st);
8010132e:	58                   	pop    %eax
8010132f:	5a                   	pop    %edx
80101330:	ff 75 0c             	pushl  0xc(%ebp)
80101333:	ff 73 10             	pushl  0x10(%ebx)
80101336:	e8 65 0a 00 00       	call   80101da0 <stati>
    iunlock(f->ip);
8010133b:	59                   	pop    %ecx
8010133c:	ff 73 10             	pushl  0x10(%ebx)
8010133f:	e8 6c 08 00 00       	call   80101bb0 <iunlock>
    return 0;
  }
  return -1;
}
80101344:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101347:	83 c4 10             	add    $0x10,%esp
8010134a:	31 c0                	xor    %eax,%eax
}
8010134c:	c9                   	leave  
8010134d:	c3                   	ret    
8010134e:	66 90                	xchg   %ax,%ax
80101350:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101353:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101358:	c9                   	leave  
80101359:	c3                   	ret    
8010135a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101360 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101360:	f3 0f 1e fb          	endbr32 
80101364:	55                   	push   %ebp
80101365:	89 e5                	mov    %esp,%ebp
80101367:	57                   	push   %edi
80101368:	56                   	push   %esi
80101369:	53                   	push   %ebx
8010136a:	83 ec 0c             	sub    $0xc,%esp
8010136d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101370:	8b 75 0c             	mov    0xc(%ebp),%esi
80101373:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101376:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010137a:	74 64                	je     801013e0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010137c:	8b 03                	mov    (%ebx),%eax
8010137e:	83 f8 01             	cmp    $0x1,%eax
80101381:	74 45                	je     801013c8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101383:	83 f8 02             	cmp    $0x2,%eax
80101386:	75 5f                	jne    801013e7 <fileread+0x87>
    ilock(f->ip);
80101388:	83 ec 0c             	sub    $0xc,%esp
8010138b:	ff 73 10             	pushl  0x10(%ebx)
8010138e:	e8 3d 07 00 00       	call   80101ad0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101393:	57                   	push   %edi
80101394:	ff 73 14             	pushl  0x14(%ebx)
80101397:	56                   	push   %esi
80101398:	ff 73 10             	pushl  0x10(%ebx)
8010139b:	e8 30 0a 00 00       	call   80101dd0 <readi>
801013a0:	83 c4 20             	add    $0x20,%esp
801013a3:	89 c6                	mov    %eax,%esi
801013a5:	85 c0                	test   %eax,%eax
801013a7:	7e 03                	jle    801013ac <fileread+0x4c>
      f->off += r;
801013a9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801013ac:	83 ec 0c             	sub    $0xc,%esp
801013af:	ff 73 10             	pushl  0x10(%ebx)
801013b2:	e8 f9 07 00 00       	call   80101bb0 <iunlock>
    return r;
801013b7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013bd:	89 f0                	mov    %esi,%eax
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5f                   	pop    %edi
801013c2:	5d                   	pop    %ebp
801013c3:	c3                   	ret    
801013c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801013c8:	8b 43 0c             	mov    0xc(%ebx),%eax
801013cb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801013ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d1:	5b                   	pop    %ebx
801013d2:	5e                   	pop    %esi
801013d3:	5f                   	pop    %edi
801013d4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801013d5:	e9 36 26 00 00       	jmp    80103a10 <piperead>
801013da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801013e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801013e5:	eb d3                	jmp    801013ba <fileread+0x5a>
  panic("fileread");
801013e7:	83 ec 0c             	sub    $0xc,%esp
801013ea:	68 aa 85 10 80       	push   $0x801085aa
801013ef:	e8 9c ef ff ff       	call   80100390 <panic>
801013f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013ff:	90                   	nop

80101400 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101400:	f3 0f 1e fb          	endbr32 
80101404:	55                   	push   %ebp
80101405:	89 e5                	mov    %esp,%ebp
80101407:	57                   	push   %edi
80101408:	56                   	push   %esi
80101409:	53                   	push   %ebx
8010140a:	83 ec 1c             	sub    $0x1c,%esp
8010140d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101410:	8b 75 08             	mov    0x8(%ebp),%esi
80101413:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101416:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101419:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010141d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101420:	0f 84 c1 00 00 00    	je     801014e7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101426:	8b 06                	mov    (%esi),%eax
80101428:	83 f8 01             	cmp    $0x1,%eax
8010142b:	0f 84 c3 00 00 00    	je     801014f4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101431:	83 f8 02             	cmp    $0x2,%eax
80101434:	0f 85 cc 00 00 00    	jne    80101506 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010143a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010143d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010143f:	85 c0                	test   %eax,%eax
80101441:	7f 34                	jg     80101477 <filewrite+0x77>
80101443:	e9 98 00 00 00       	jmp    801014e0 <filewrite+0xe0>
80101448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010144f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101450:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101453:	83 ec 0c             	sub    $0xc,%esp
80101456:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101459:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010145c:	e8 4f 07 00 00       	call   80101bb0 <iunlock>
      end_op();
80101461:	e8 aa 1c 00 00       	call   80103110 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101466:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101469:	83 c4 10             	add    $0x10,%esp
8010146c:	39 c3                	cmp    %eax,%ebx
8010146e:	75 60                	jne    801014d0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101470:	01 df                	add    %ebx,%edi
    while(i < n){
80101472:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101475:	7e 69                	jle    801014e0 <filewrite+0xe0>
      int n1 = n - i;
80101477:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010147a:	b8 00 06 00 00       	mov    $0x600,%eax
8010147f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101481:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101487:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010148a:	e8 11 1c 00 00       	call   801030a0 <begin_op>
      ilock(f->ip);
8010148f:	83 ec 0c             	sub    $0xc,%esp
80101492:	ff 76 10             	pushl  0x10(%esi)
80101495:	e8 36 06 00 00       	call   80101ad0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010149a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010149d:	53                   	push   %ebx
8010149e:	ff 76 14             	pushl  0x14(%esi)
801014a1:	01 f8                	add    %edi,%eax
801014a3:	50                   	push   %eax
801014a4:	ff 76 10             	pushl  0x10(%esi)
801014a7:	e8 24 0a 00 00       	call   80101ed0 <writei>
801014ac:	83 c4 20             	add    $0x20,%esp
801014af:	85 c0                	test   %eax,%eax
801014b1:	7f 9d                	jg     80101450 <filewrite+0x50>
      iunlock(f->ip);
801014b3:	83 ec 0c             	sub    $0xc,%esp
801014b6:	ff 76 10             	pushl  0x10(%esi)
801014b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801014bc:	e8 ef 06 00 00       	call   80101bb0 <iunlock>
      end_op();
801014c1:	e8 4a 1c 00 00       	call   80103110 <end_op>
      if(r < 0)
801014c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014c9:	83 c4 10             	add    $0x10,%esp
801014cc:	85 c0                	test   %eax,%eax
801014ce:	75 17                	jne    801014e7 <filewrite+0xe7>
        panic("short filewrite");
801014d0:	83 ec 0c             	sub    $0xc,%esp
801014d3:	68 b3 85 10 80       	push   $0x801085b3
801014d8:	e8 b3 ee ff ff       	call   80100390 <panic>
801014dd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801014e0:	89 f8                	mov    %edi,%eax
801014e2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801014e5:	74 05                	je     801014ec <filewrite+0xec>
801014e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801014ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014ef:	5b                   	pop    %ebx
801014f0:	5e                   	pop    %esi
801014f1:	5f                   	pop    %edi
801014f2:	5d                   	pop    %ebp
801014f3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801014f4:	8b 46 0c             	mov    0xc(%esi),%eax
801014f7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801014fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014fd:	5b                   	pop    %ebx
801014fe:	5e                   	pop    %esi
801014ff:	5f                   	pop    %edi
80101500:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101501:	e9 0a 24 00 00       	jmp    80103910 <pipewrite>
  panic("filewrite");
80101506:	83 ec 0c             	sub    $0xc,%esp
80101509:	68 b9 85 10 80       	push   $0x801085b9
8010150e:	e8 7d ee ff ff       	call   80100390 <panic>
80101513:	66 90                	xchg   %ax,%ax
80101515:	66 90                	xchg   %ax,%ax
80101517:	66 90                	xchg   %ax,%ax
80101519:	66 90                	xchg   %ax,%ax
8010151b:	66 90                	xchg   %ax,%ax
8010151d:	66 90                	xchg   %ax,%ax
8010151f:	90                   	nop

80101520 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101520:	55                   	push   %ebp
80101521:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101523:	89 d0                	mov    %edx,%eax
80101525:	c1 e8 0c             	shr    $0xc,%eax
80101528:	03 05 f8 2a 11 80    	add    0x80112af8,%eax
{
8010152e:	89 e5                	mov    %esp,%ebp
80101530:	56                   	push   %esi
80101531:	53                   	push   %ebx
80101532:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101534:	83 ec 08             	sub    $0x8,%esp
80101537:	50                   	push   %eax
80101538:	51                   	push   %ecx
80101539:	e8 92 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010153e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101540:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101543:	ba 01 00 00 00       	mov    $0x1,%edx
80101548:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010154b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101551:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101554:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101556:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010155b:	85 d1                	test   %edx,%ecx
8010155d:	74 25                	je     80101584 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010155f:	f7 d2                	not    %edx
  log_write(bp);
80101561:	83 ec 0c             	sub    $0xc,%esp
80101564:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101566:	21 ca                	and    %ecx,%edx
80101568:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010156c:	50                   	push   %eax
8010156d:	e8 0e 1d 00 00       	call   80103280 <log_write>
  brelse(bp);
80101572:	89 34 24             	mov    %esi,(%esp)
80101575:	e8 76 ec ff ff       	call   801001f0 <brelse>
}
8010157a:	83 c4 10             	add    $0x10,%esp
8010157d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101580:	5b                   	pop    %ebx
80101581:	5e                   	pop    %esi
80101582:	5d                   	pop    %ebp
80101583:	c3                   	ret    
    panic("freeing free block");
80101584:	83 ec 0c             	sub    $0xc,%esp
80101587:	68 c3 85 10 80       	push   $0x801085c3
8010158c:	e8 ff ed ff ff       	call   80100390 <panic>
80101591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010159f:	90                   	nop

801015a0 <balloc>:
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
801015a4:	56                   	push   %esi
801015a5:	53                   	push   %ebx
801015a6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801015a9:	8b 0d e0 2a 11 80    	mov    0x80112ae0,%ecx
{
801015af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801015b2:	85 c9                	test   %ecx,%ecx
801015b4:	0f 84 87 00 00 00    	je     80101641 <balloc+0xa1>
801015ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801015c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801015c4:	83 ec 08             	sub    $0x8,%esp
801015c7:	89 f0                	mov    %esi,%eax
801015c9:	c1 f8 0c             	sar    $0xc,%eax
801015cc:	03 05 f8 2a 11 80    	add    0x80112af8,%eax
801015d2:	50                   	push   %eax
801015d3:	ff 75 d8             	pushl  -0x28(%ebp)
801015d6:	e8 f5 ea ff ff       	call   801000d0 <bread>
801015db:	83 c4 10             	add    $0x10,%esp
801015de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015e1:	a1 e0 2a 11 80       	mov    0x80112ae0,%eax
801015e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801015e9:	31 c0                	xor    %eax,%eax
801015eb:	eb 2f                	jmp    8010161c <balloc+0x7c>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801015f0:	89 c1                	mov    %eax,%ecx
801015f2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801015fa:	83 e1 07             	and    $0x7,%ecx
801015fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015ff:	89 c1                	mov    %eax,%ecx
80101601:	c1 f9 03             	sar    $0x3,%ecx
80101604:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101609:	89 fa                	mov    %edi,%edx
8010160b:	85 df                	test   %ebx,%edi
8010160d:	74 41                	je     80101650 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010160f:	83 c0 01             	add    $0x1,%eax
80101612:	83 c6 01             	add    $0x1,%esi
80101615:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010161a:	74 05                	je     80101621 <balloc+0x81>
8010161c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010161f:	77 cf                	ja     801015f0 <balloc+0x50>
    brelse(bp);
80101621:	83 ec 0c             	sub    $0xc,%esp
80101624:	ff 75 e4             	pushl  -0x1c(%ebp)
80101627:	e8 c4 eb ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010162c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101633:	83 c4 10             	add    $0x10,%esp
80101636:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101639:	39 05 e0 2a 11 80    	cmp    %eax,0x80112ae0
8010163f:	77 80                	ja     801015c1 <balloc+0x21>
  panic("balloc: out of blocks");
80101641:	83 ec 0c             	sub    $0xc,%esp
80101644:	68 d6 85 10 80       	push   $0x801085d6
80101649:	e8 42 ed ff ff       	call   80100390 <panic>
8010164e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101650:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101653:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101656:	09 da                	or     %ebx,%edx
80101658:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010165c:	57                   	push   %edi
8010165d:	e8 1e 1c 00 00       	call   80103280 <log_write>
        brelse(bp);
80101662:	89 3c 24             	mov    %edi,(%esp)
80101665:	e8 86 eb ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010166a:	58                   	pop    %eax
8010166b:	5a                   	pop    %edx
8010166c:	56                   	push   %esi
8010166d:	ff 75 d8             	pushl  -0x28(%ebp)
80101670:	e8 5b ea ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101675:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101678:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010167a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010167d:	68 00 02 00 00       	push   $0x200
80101682:	6a 00                	push   $0x0
80101684:	50                   	push   %eax
80101685:	e8 76 41 00 00       	call   80105800 <memset>
  log_write(bp);
8010168a:	89 1c 24             	mov    %ebx,(%esp)
8010168d:	e8 ee 1b 00 00       	call   80103280 <log_write>
  brelse(bp);
80101692:	89 1c 24             	mov    %ebx,(%esp)
80101695:	e8 56 eb ff ff       	call   801001f0 <brelse>
}
8010169a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010169d:	89 f0                	mov    %esi,%eax
8010169f:	5b                   	pop    %ebx
801016a0:	5e                   	pop    %esi
801016a1:	5f                   	pop    %edi
801016a2:	5d                   	pop    %ebp
801016a3:	c3                   	ret    
801016a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016af:	90                   	nop

801016b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	57                   	push   %edi
801016b4:	89 c7                	mov    %eax,%edi
801016b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801016b7:	31 f6                	xor    %esi,%esi
{
801016b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016ba:	bb 34 2b 11 80       	mov    $0x80112b34,%ebx
{
801016bf:	83 ec 28             	sub    $0x28,%esp
801016c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801016c5:	68 00 2b 11 80       	push   $0x80112b00
801016ca:	e8 21 40 00 00       	call   801056f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801016d2:	83 c4 10             	add    $0x10,%esp
801016d5:	eb 1b                	jmp    801016f2 <iget+0x42>
801016d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016de:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016e0:	39 3b                	cmp    %edi,(%ebx)
801016e2:	74 6c                	je     80101750 <iget+0xa0>
801016e4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016ea:	81 fb 54 47 11 80    	cmp    $0x80114754,%ebx
801016f0:	73 26                	jae    80101718 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016f2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801016f5:	85 c9                	test   %ecx,%ecx
801016f7:	7f e7                	jg     801016e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801016f9:	85 f6                	test   %esi,%esi
801016fb:	75 e7                	jne    801016e4 <iget+0x34>
801016fd:	89 d8                	mov    %ebx,%eax
801016ff:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101705:	85 c9                	test   %ecx,%ecx
80101707:	75 6e                	jne    80101777 <iget+0xc7>
80101709:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010170b:	81 fb 54 47 11 80    	cmp    $0x80114754,%ebx
80101711:	72 df                	jb     801016f2 <iget+0x42>
80101713:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101717:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101718:	85 f6                	test   %esi,%esi
8010171a:	74 73                	je     8010178f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010171c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010171f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101721:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101724:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010172b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101732:	68 00 2b 11 80       	push   $0x80112b00
80101737:	e8 74 40 00 00       	call   801057b0 <release>

  return ip;
8010173c:	83 c4 10             	add    $0x10,%esp
}
8010173f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101742:	89 f0                	mov    %esi,%eax
80101744:	5b                   	pop    %ebx
80101745:	5e                   	pop    %esi
80101746:	5f                   	pop    %edi
80101747:	5d                   	pop    %ebp
80101748:	c3                   	ret    
80101749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101750:	39 53 04             	cmp    %edx,0x4(%ebx)
80101753:	75 8f                	jne    801016e4 <iget+0x34>
      release(&icache.lock);
80101755:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101758:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010175b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010175d:	68 00 2b 11 80       	push   $0x80112b00
      ip->ref++;
80101762:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101765:	e8 46 40 00 00       	call   801057b0 <release>
      return ip;
8010176a:	83 c4 10             	add    $0x10,%esp
}
8010176d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101770:	89 f0                	mov    %esi,%eax
80101772:	5b                   	pop    %ebx
80101773:	5e                   	pop    %esi
80101774:	5f                   	pop    %edi
80101775:	5d                   	pop    %ebp
80101776:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101777:	81 fb 54 47 11 80    	cmp    $0x80114754,%ebx
8010177d:	73 10                	jae    8010178f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010177f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101782:	85 c9                	test   %ecx,%ecx
80101784:	0f 8f 56 ff ff ff    	jg     801016e0 <iget+0x30>
8010178a:	e9 6e ff ff ff       	jmp    801016fd <iget+0x4d>
    panic("iget: no inodes");
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	68 ec 85 10 80       	push   $0x801085ec
80101797:	e8 f4 eb ff ff       	call   80100390 <panic>
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	89 c6                	mov    %eax,%esi
801017a7:	53                   	push   %ebx
801017a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801017ab:	83 fa 0b             	cmp    $0xb,%edx
801017ae:	0f 86 84 00 00 00    	jbe    80101838 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801017b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801017b7:	83 fb 7f             	cmp    $0x7f,%ebx
801017ba:	0f 87 98 00 00 00    	ja     80101858 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801017c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801017c6:	8b 16                	mov    (%esi),%edx
801017c8:	85 c0                	test   %eax,%eax
801017ca:	74 54                	je     80101820 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801017cc:	83 ec 08             	sub    $0x8,%esp
801017cf:	50                   	push   %eax
801017d0:	52                   	push   %edx
801017d1:	e8 fa e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801017d6:	83 c4 10             	add    $0x10,%esp
801017d9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801017dd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801017df:	8b 1a                	mov    (%edx),%ebx
801017e1:	85 db                	test   %ebx,%ebx
801017e3:	74 1b                	je     80101800 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801017e5:	83 ec 0c             	sub    $0xc,%esp
801017e8:	57                   	push   %edi
801017e9:	e8 02 ea ff ff       	call   801001f0 <brelse>
    return addr;
801017ee:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801017f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017f4:	89 d8                	mov    %ebx,%eax
801017f6:	5b                   	pop    %ebx
801017f7:	5e                   	pop    %esi
801017f8:	5f                   	pop    %edi
801017f9:	5d                   	pop    %ebp
801017fa:	c3                   	ret    
801017fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ff:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101800:	8b 06                	mov    (%esi),%eax
80101802:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101805:	e8 96 fd ff ff       	call   801015a0 <balloc>
8010180a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010180d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101810:	89 c3                	mov    %eax,%ebx
80101812:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101814:	57                   	push   %edi
80101815:	e8 66 1a 00 00       	call   80103280 <log_write>
8010181a:	83 c4 10             	add    $0x10,%esp
8010181d:	eb c6                	jmp    801017e5 <bmap+0x45>
8010181f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101820:	89 d0                	mov    %edx,%eax
80101822:	e8 79 fd ff ff       	call   801015a0 <balloc>
80101827:	8b 16                	mov    (%esi),%edx
80101829:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010182f:	eb 9b                	jmp    801017cc <bmap+0x2c>
80101831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101838:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010183b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010183e:	85 db                	test   %ebx,%ebx
80101840:	75 af                	jne    801017f1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101842:	8b 00                	mov    (%eax),%eax
80101844:	e8 57 fd ff ff       	call   801015a0 <balloc>
80101849:	89 47 5c             	mov    %eax,0x5c(%edi)
8010184c:	89 c3                	mov    %eax,%ebx
}
8010184e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101851:	89 d8                	mov    %ebx,%eax
80101853:	5b                   	pop    %ebx
80101854:	5e                   	pop    %esi
80101855:	5f                   	pop    %edi
80101856:	5d                   	pop    %ebp
80101857:	c3                   	ret    
  panic("bmap: out of range");
80101858:	83 ec 0c             	sub    $0xc,%esp
8010185b:	68 fc 85 10 80       	push   $0x801085fc
80101860:	e8 2b eb ff ff       	call   80100390 <panic>
80101865:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101870 <readsb>:
{
80101870:	f3 0f 1e fb          	endbr32 
80101874:	55                   	push   %ebp
80101875:	89 e5                	mov    %esp,%ebp
80101877:	56                   	push   %esi
80101878:	53                   	push   %ebx
80101879:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010187c:	83 ec 08             	sub    $0x8,%esp
8010187f:	6a 01                	push   $0x1
80101881:	ff 75 08             	pushl  0x8(%ebp)
80101884:	e8 47 e8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101889:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010188c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010188e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101891:	6a 1c                	push   $0x1c
80101893:	50                   	push   %eax
80101894:	56                   	push   %esi
80101895:	e8 06 40 00 00       	call   801058a0 <memmove>
  brelse(bp);
8010189a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010189d:	83 c4 10             	add    $0x10,%esp
}
801018a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018a3:	5b                   	pop    %ebx
801018a4:	5e                   	pop    %esi
801018a5:	5d                   	pop    %ebp
  brelse(bp);
801018a6:	e9 45 e9 ff ff       	jmp    801001f0 <brelse>
801018ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iinit>:
{
801018b0:	f3 0f 1e fb          	endbr32 
801018b4:	55                   	push   %ebp
801018b5:	89 e5                	mov    %esp,%ebp
801018b7:	53                   	push   %ebx
801018b8:	bb 40 2b 11 80       	mov    $0x80112b40,%ebx
801018bd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801018c0:	68 0f 86 10 80       	push   $0x8010860f
801018c5:	68 00 2b 11 80       	push   $0x80112b00
801018ca:	e8 a1 3c 00 00       	call   80105570 <initlock>
  for(i = 0; i < NINODE; i++) {
801018cf:	83 c4 10             	add    $0x10,%esp
801018d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801018d8:	83 ec 08             	sub    $0x8,%esp
801018db:	68 16 86 10 80       	push   $0x80108616
801018e0:	53                   	push   %ebx
801018e1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018e7:	e8 44 3b 00 00       	call   80105430 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801018ec:	83 c4 10             	add    $0x10,%esp
801018ef:	81 fb 60 47 11 80    	cmp    $0x80114760,%ebx
801018f5:	75 e1                	jne    801018d8 <iinit+0x28>
  readsb(dev, &sb);
801018f7:	83 ec 08             	sub    $0x8,%esp
801018fa:	68 e0 2a 11 80       	push   $0x80112ae0
801018ff:	ff 75 08             	pushl  0x8(%ebp)
80101902:	e8 69 ff ff ff       	call   80101870 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101907:	ff 35 f8 2a 11 80    	pushl  0x80112af8
8010190d:	ff 35 f4 2a 11 80    	pushl  0x80112af4
80101913:	ff 35 f0 2a 11 80    	pushl  0x80112af0
80101919:	ff 35 ec 2a 11 80    	pushl  0x80112aec
8010191f:	ff 35 e8 2a 11 80    	pushl  0x80112ae8
80101925:	ff 35 e4 2a 11 80    	pushl  0x80112ae4
8010192b:	ff 35 e0 2a 11 80    	pushl  0x80112ae0
80101931:	68 7c 86 10 80       	push   $0x8010867c
80101936:	e8 75 ed ff ff       	call   801006b0 <cprintf>
}
8010193b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010193e:	83 c4 30             	add    $0x30,%esp
80101941:	c9                   	leave  
80101942:	c3                   	ret    
80101943:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010194a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101950 <ialloc>:
{
80101950:	f3 0f 1e fb          	endbr32 
80101954:	55                   	push   %ebp
80101955:	89 e5                	mov    %esp,%ebp
80101957:	57                   	push   %edi
80101958:	56                   	push   %esi
80101959:	53                   	push   %ebx
8010195a:	83 ec 1c             	sub    $0x1c,%esp
8010195d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101960:	83 3d e8 2a 11 80 01 	cmpl   $0x1,0x80112ae8
{
80101967:	8b 75 08             	mov    0x8(%ebp),%esi
8010196a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010196d:	0f 86 8d 00 00 00    	jbe    80101a00 <ialloc+0xb0>
80101973:	bf 01 00 00 00       	mov    $0x1,%edi
80101978:	eb 1d                	jmp    80101997 <ialloc+0x47>
8010197a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101980:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101983:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101986:	53                   	push   %ebx
80101987:	e8 64 e8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010198c:	83 c4 10             	add    $0x10,%esp
8010198f:	3b 3d e8 2a 11 80    	cmp    0x80112ae8,%edi
80101995:	73 69                	jae    80101a00 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101997:	89 f8                	mov    %edi,%eax
80101999:	83 ec 08             	sub    $0x8,%esp
8010199c:	c1 e8 03             	shr    $0x3,%eax
8010199f:	03 05 f4 2a 11 80    	add    0x80112af4,%eax
801019a5:	50                   	push   %eax
801019a6:	56                   	push   %esi
801019a7:	e8 24 e7 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801019ac:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801019af:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801019b1:	89 f8                	mov    %edi,%eax
801019b3:	83 e0 07             	and    $0x7,%eax
801019b6:	c1 e0 06             	shl    $0x6,%eax
801019b9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801019bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801019c1:	75 bd                	jne    80101980 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801019c3:	83 ec 04             	sub    $0x4,%esp
801019c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801019c9:	6a 40                	push   $0x40
801019cb:	6a 00                	push   $0x0
801019cd:	51                   	push   %ecx
801019ce:	e8 2d 3e 00 00       	call   80105800 <memset>
      dip->type = type;
801019d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801019d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801019da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801019dd:	89 1c 24             	mov    %ebx,(%esp)
801019e0:	e8 9b 18 00 00       	call   80103280 <log_write>
      brelse(bp);
801019e5:	89 1c 24             	mov    %ebx,(%esp)
801019e8:	e8 03 e8 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801019ed:	83 c4 10             	add    $0x10,%esp
}
801019f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801019f3:	89 fa                	mov    %edi,%edx
}
801019f5:	5b                   	pop    %ebx
      return iget(dev, inum);
801019f6:	89 f0                	mov    %esi,%eax
}
801019f8:	5e                   	pop    %esi
801019f9:	5f                   	pop    %edi
801019fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801019fb:	e9 b0 fc ff ff       	jmp    801016b0 <iget>
  panic("ialloc: no inodes");
80101a00:	83 ec 0c             	sub    $0xc,%esp
80101a03:	68 1c 86 10 80       	push   $0x8010861c
80101a08:	e8 83 e9 ff ff       	call   80100390 <panic>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi

80101a10 <iupdate>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	56                   	push   %esi
80101a18:	53                   	push   %ebx
80101a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a1c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a1f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a22:	83 ec 08             	sub    $0x8,%esp
80101a25:	c1 e8 03             	shr    $0x3,%eax
80101a28:	03 05 f4 2a 11 80    	add    0x80112af4,%eax
80101a2e:	50                   	push   %eax
80101a2f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101a32:	e8 99 e6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101a37:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a3b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a3e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a40:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101a43:	83 e0 07             	and    $0x7,%eax
80101a46:	c1 e0 06             	shl    $0x6,%eax
80101a49:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101a4d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101a50:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a54:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101a57:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101a5b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101a5f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101a63:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101a67:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101a6b:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101a6e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a71:	6a 34                	push   $0x34
80101a73:	53                   	push   %ebx
80101a74:	50                   	push   %eax
80101a75:	e8 26 3e 00 00       	call   801058a0 <memmove>
  log_write(bp);
80101a7a:	89 34 24             	mov    %esi,(%esp)
80101a7d:	e8 fe 17 00 00       	call   80103280 <log_write>
  brelse(bp);
80101a82:	89 75 08             	mov    %esi,0x8(%ebp)
80101a85:	83 c4 10             	add    $0x10,%esp
}
80101a88:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a8b:	5b                   	pop    %ebx
80101a8c:	5e                   	pop    %esi
80101a8d:	5d                   	pop    %ebp
  brelse(bp);
80101a8e:	e9 5d e7 ff ff       	jmp    801001f0 <brelse>
80101a93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101aa0 <idup>:
{
80101aa0:	f3 0f 1e fb          	endbr32 
80101aa4:	55                   	push   %ebp
80101aa5:	89 e5                	mov    %esp,%ebp
80101aa7:	53                   	push   %ebx
80101aa8:	83 ec 10             	sub    $0x10,%esp
80101aab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101aae:	68 00 2b 11 80       	push   $0x80112b00
80101ab3:	e8 38 3c 00 00       	call   801056f0 <acquire>
  ip->ref++;
80101ab8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101abc:	c7 04 24 00 2b 11 80 	movl   $0x80112b00,(%esp)
80101ac3:	e8 e8 3c 00 00       	call   801057b0 <release>
}
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101acd:	c9                   	leave  
80101ace:	c3                   	ret    
80101acf:	90                   	nop

80101ad0 <ilock>:
{
80101ad0:	f3 0f 1e fb          	endbr32 
80101ad4:	55                   	push   %ebp
80101ad5:	89 e5                	mov    %esp,%ebp
80101ad7:	56                   	push   %esi
80101ad8:	53                   	push   %ebx
80101ad9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101adc:	85 db                	test   %ebx,%ebx
80101ade:	0f 84 b3 00 00 00    	je     80101b97 <ilock+0xc7>
80101ae4:	8b 53 08             	mov    0x8(%ebx),%edx
80101ae7:	85 d2                	test   %edx,%edx
80101ae9:	0f 8e a8 00 00 00    	jle    80101b97 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101aef:	83 ec 0c             	sub    $0xc,%esp
80101af2:	8d 43 0c             	lea    0xc(%ebx),%eax
80101af5:	50                   	push   %eax
80101af6:	e8 75 39 00 00       	call   80105470 <acquiresleep>
  if(ip->valid == 0){
80101afb:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101afe:	83 c4 10             	add    $0x10,%esp
80101b01:	85 c0                	test   %eax,%eax
80101b03:	74 0b                	je     80101b10 <ilock+0x40>
}
80101b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b08:	5b                   	pop    %ebx
80101b09:	5e                   	pop    %esi
80101b0a:	5d                   	pop    %ebp
80101b0b:	c3                   	ret    
80101b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b10:	8b 43 04             	mov    0x4(%ebx),%eax
80101b13:	83 ec 08             	sub    $0x8,%esp
80101b16:	c1 e8 03             	shr    $0x3,%eax
80101b19:	03 05 f4 2a 11 80    	add    0x80112af4,%eax
80101b1f:	50                   	push   %eax
80101b20:	ff 33                	pushl  (%ebx)
80101b22:	e8 a9 e5 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b27:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b2a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b2c:	8b 43 04             	mov    0x4(%ebx),%eax
80101b2f:	83 e0 07             	and    $0x7,%eax
80101b32:	c1 e0 06             	shl    $0x6,%eax
80101b35:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101b39:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b3c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101b3f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101b43:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101b47:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101b4b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101b4f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101b53:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101b57:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101b5b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101b5e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b61:	6a 34                	push   $0x34
80101b63:	50                   	push   %eax
80101b64:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101b67:	50                   	push   %eax
80101b68:	e8 33 3d 00 00       	call   801058a0 <memmove>
    brelse(bp);
80101b6d:	89 34 24             	mov    %esi,(%esp)
80101b70:	e8 7b e6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101b75:	83 c4 10             	add    $0x10,%esp
80101b78:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101b7d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101b84:	0f 85 7b ff ff ff    	jne    80101b05 <ilock+0x35>
      panic("ilock: no type");
80101b8a:	83 ec 0c             	sub    $0xc,%esp
80101b8d:	68 34 86 10 80       	push   $0x80108634
80101b92:	e8 f9 e7 ff ff       	call   80100390 <panic>
    panic("ilock");
80101b97:	83 ec 0c             	sub    $0xc,%esp
80101b9a:	68 2e 86 10 80       	push   $0x8010862e
80101b9f:	e8 ec e7 ff ff       	call   80100390 <panic>
80101ba4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101baf:	90                   	nop

80101bb0 <iunlock>:
{
80101bb0:	f3 0f 1e fb          	endbr32 
80101bb4:	55                   	push   %ebp
80101bb5:	89 e5                	mov    %esp,%ebp
80101bb7:	56                   	push   %esi
80101bb8:	53                   	push   %ebx
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101bbc:	85 db                	test   %ebx,%ebx
80101bbe:	74 28                	je     80101be8 <iunlock+0x38>
80101bc0:	83 ec 0c             	sub    $0xc,%esp
80101bc3:	8d 73 0c             	lea    0xc(%ebx),%esi
80101bc6:	56                   	push   %esi
80101bc7:	e8 44 39 00 00       	call   80105510 <holdingsleep>
80101bcc:	83 c4 10             	add    $0x10,%esp
80101bcf:	85 c0                	test   %eax,%eax
80101bd1:	74 15                	je     80101be8 <iunlock+0x38>
80101bd3:	8b 43 08             	mov    0x8(%ebx),%eax
80101bd6:	85 c0                	test   %eax,%eax
80101bd8:	7e 0e                	jle    80101be8 <iunlock+0x38>
  releasesleep(&ip->lock);
80101bda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101bdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101be0:	5b                   	pop    %ebx
80101be1:	5e                   	pop    %esi
80101be2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101be3:	e9 e8 38 00 00       	jmp    801054d0 <releasesleep>
    panic("iunlock");
80101be8:	83 ec 0c             	sub    $0xc,%esp
80101beb:	68 43 86 10 80       	push   $0x80108643
80101bf0:	e8 9b e7 ff ff       	call   80100390 <panic>
80101bf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c00 <iput>:
{
80101c00:	f3 0f 1e fb          	endbr32 
80101c04:	55                   	push   %ebp
80101c05:	89 e5                	mov    %esp,%ebp
80101c07:	57                   	push   %edi
80101c08:	56                   	push   %esi
80101c09:	53                   	push   %ebx
80101c0a:	83 ec 28             	sub    $0x28,%esp
80101c0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101c10:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101c13:	57                   	push   %edi
80101c14:	e8 57 38 00 00       	call   80105470 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101c19:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101c1c:	83 c4 10             	add    $0x10,%esp
80101c1f:	85 d2                	test   %edx,%edx
80101c21:	74 07                	je     80101c2a <iput+0x2a>
80101c23:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101c28:	74 36                	je     80101c60 <iput+0x60>
  releasesleep(&ip->lock);
80101c2a:	83 ec 0c             	sub    $0xc,%esp
80101c2d:	57                   	push   %edi
80101c2e:	e8 9d 38 00 00       	call   801054d0 <releasesleep>
  acquire(&icache.lock);
80101c33:	c7 04 24 00 2b 11 80 	movl   $0x80112b00,(%esp)
80101c3a:	e8 b1 3a 00 00       	call   801056f0 <acquire>
  ip->ref--;
80101c3f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c43:	83 c4 10             	add    $0x10,%esp
80101c46:	c7 45 08 00 2b 11 80 	movl   $0x80112b00,0x8(%ebp)
}
80101c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c50:	5b                   	pop    %ebx
80101c51:	5e                   	pop    %esi
80101c52:	5f                   	pop    %edi
80101c53:	5d                   	pop    %ebp
  release(&icache.lock);
80101c54:	e9 57 3b 00 00       	jmp    801057b0 <release>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101c60:	83 ec 0c             	sub    $0xc,%esp
80101c63:	68 00 2b 11 80       	push   $0x80112b00
80101c68:	e8 83 3a 00 00       	call   801056f0 <acquire>
    int r = ip->ref;
80101c6d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101c70:	c7 04 24 00 2b 11 80 	movl   $0x80112b00,(%esp)
80101c77:	e8 34 3b 00 00       	call   801057b0 <release>
    if(r == 1){
80101c7c:	83 c4 10             	add    $0x10,%esp
80101c7f:	83 fe 01             	cmp    $0x1,%esi
80101c82:	75 a6                	jne    80101c2a <iput+0x2a>
80101c84:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101c8a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101c8d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101c90:	89 cf                	mov    %ecx,%edi
80101c92:	eb 0b                	jmp    80101c9f <iput+0x9f>
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c98:	83 c6 04             	add    $0x4,%esi
80101c9b:	39 fe                	cmp    %edi,%esi
80101c9d:	74 19                	je     80101cb8 <iput+0xb8>
    if(ip->addrs[i]){
80101c9f:	8b 16                	mov    (%esi),%edx
80101ca1:	85 d2                	test   %edx,%edx
80101ca3:	74 f3                	je     80101c98 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101ca5:	8b 03                	mov    (%ebx),%eax
80101ca7:	e8 74 f8 ff ff       	call   80101520 <bfree>
      ip->addrs[i] = 0;
80101cac:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101cb2:	eb e4                	jmp    80101c98 <iput+0x98>
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101cb8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101cbe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101cc1:	85 c0                	test   %eax,%eax
80101cc3:	75 33                	jne    80101cf8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101cc5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101cc8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101ccf:	53                   	push   %ebx
80101cd0:	e8 3b fd ff ff       	call   80101a10 <iupdate>
      ip->type = 0;
80101cd5:	31 c0                	xor    %eax,%eax
80101cd7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101cdb:	89 1c 24             	mov    %ebx,(%esp)
80101cde:	e8 2d fd ff ff       	call   80101a10 <iupdate>
      ip->valid = 0;
80101ce3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	e9 38 ff ff ff       	jmp    80101c2a <iput+0x2a>
80101cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cf8:	83 ec 08             	sub    $0x8,%esp
80101cfb:	50                   	push   %eax
80101cfc:	ff 33                	pushl  (%ebx)
80101cfe:	e8 cd e3 ff ff       	call   801000d0 <bread>
80101d03:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d06:	83 c4 10             	add    $0x10,%esp
80101d09:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101d0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d12:	8d 70 5c             	lea    0x5c(%eax),%esi
80101d15:	89 cf                	mov    %ecx,%edi
80101d17:	eb 0e                	jmp    80101d27 <iput+0x127>
80101d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d20:	83 c6 04             	add    $0x4,%esi
80101d23:	39 f7                	cmp    %esi,%edi
80101d25:	74 19                	je     80101d40 <iput+0x140>
      if(a[j])
80101d27:	8b 16                	mov    (%esi),%edx
80101d29:	85 d2                	test   %edx,%edx
80101d2b:	74 f3                	je     80101d20 <iput+0x120>
        bfree(ip->dev, a[j]);
80101d2d:	8b 03                	mov    (%ebx),%eax
80101d2f:	e8 ec f7 ff ff       	call   80101520 <bfree>
80101d34:	eb ea                	jmp    80101d20 <iput+0x120>
80101d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d3d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101d40:	83 ec 0c             	sub    $0xc,%esp
80101d43:	ff 75 e4             	pushl  -0x1c(%ebp)
80101d46:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d49:	e8 a2 e4 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d4e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101d54:	8b 03                	mov    (%ebx),%eax
80101d56:	e8 c5 f7 ff ff       	call   80101520 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101d65:	00 00 00 
80101d68:	e9 58 ff ff ff       	jmp    80101cc5 <iput+0xc5>
80101d6d:	8d 76 00             	lea    0x0(%esi),%esi

80101d70 <iunlockput>:
{
80101d70:	f3 0f 1e fb          	endbr32 
80101d74:	55                   	push   %ebp
80101d75:	89 e5                	mov    %esp,%ebp
80101d77:	53                   	push   %ebx
80101d78:	83 ec 10             	sub    $0x10,%esp
80101d7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101d7e:	53                   	push   %ebx
80101d7f:	e8 2c fe ff ff       	call   80101bb0 <iunlock>
  iput(ip);
80101d84:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d87:	83 c4 10             	add    $0x10,%esp
}
80101d8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d8d:	c9                   	leave  
  iput(ip);
80101d8e:	e9 6d fe ff ff       	jmp    80101c00 <iput>
80101d93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101da0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101da0:	f3 0f 1e fb          	endbr32 
80101da4:	55                   	push   %ebp
80101da5:	89 e5                	mov    %esp,%ebp
80101da7:	8b 55 08             	mov    0x8(%ebp),%edx
80101daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101dad:	8b 0a                	mov    (%edx),%ecx
80101daf:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101db2:	8b 4a 04             	mov    0x4(%edx),%ecx
80101db5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101db8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101dbc:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101dbf:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101dc3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101dc7:	8b 52 58             	mov    0x58(%edx),%edx
80101dca:	89 50 10             	mov    %edx,0x10(%eax)
}
80101dcd:	5d                   	pop    %ebp
80101dce:	c3                   	ret    
80101dcf:	90                   	nop

80101dd0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101dd0:	f3 0f 1e fb          	endbr32 
80101dd4:	55                   	push   %ebp
80101dd5:	89 e5                	mov    %esp,%ebp
80101dd7:	57                   	push   %edi
80101dd8:	56                   	push   %esi
80101dd9:	53                   	push   %ebx
80101dda:	83 ec 1c             	sub    $0x1c,%esp
80101ddd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101de0:	8b 45 08             	mov    0x8(%ebp),%eax
80101de3:	8b 75 10             	mov    0x10(%ebp),%esi
80101de6:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101de9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101dec:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101df1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101df4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101df7:	0f 84 a3 00 00 00    	je     80101ea0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101dfd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e00:	8b 40 58             	mov    0x58(%eax),%eax
80101e03:	39 c6                	cmp    %eax,%esi
80101e05:	0f 87 b6 00 00 00    	ja     80101ec1 <readi+0xf1>
80101e0b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e0e:	31 c9                	xor    %ecx,%ecx
80101e10:	89 da                	mov    %ebx,%edx
80101e12:	01 f2                	add    %esi,%edx
80101e14:	0f 92 c1             	setb   %cl
80101e17:	89 cf                	mov    %ecx,%edi
80101e19:	0f 82 a2 00 00 00    	jb     80101ec1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101e1f:	89 c1                	mov    %eax,%ecx
80101e21:	29 f1                	sub    %esi,%ecx
80101e23:	39 d0                	cmp    %edx,%eax
80101e25:	0f 43 cb             	cmovae %ebx,%ecx
80101e28:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e2b:	85 c9                	test   %ecx,%ecx
80101e2d:	74 63                	je     80101e92 <readi+0xc2>
80101e2f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e30:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101e33:	89 f2                	mov    %esi,%edx
80101e35:	c1 ea 09             	shr    $0x9,%edx
80101e38:	89 d8                	mov    %ebx,%eax
80101e3a:	e8 61 f9 ff ff       	call   801017a0 <bmap>
80101e3f:	83 ec 08             	sub    $0x8,%esp
80101e42:	50                   	push   %eax
80101e43:	ff 33                	pushl  (%ebx)
80101e45:	e8 86 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e4a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e4d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e52:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e55:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101e57:	89 f0                	mov    %esi,%eax
80101e59:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e5e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101e60:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e63:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101e65:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e69:	39 d9                	cmp    %ebx,%ecx
80101e6b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101e6e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e6f:	01 df                	add    %ebx,%edi
80101e71:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101e73:	50                   	push   %eax
80101e74:	ff 75 e0             	pushl  -0x20(%ebp)
80101e77:	e8 24 3a 00 00       	call   801058a0 <memmove>
    brelse(bp);
80101e7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e7f:	89 14 24             	mov    %edx,(%esp)
80101e82:	e8 69 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e87:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101e8a:	83 c4 10             	add    $0x10,%esp
80101e8d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101e90:	77 9e                	ja     80101e30 <readi+0x60>
  }
  return n;
80101e92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e98:	5b                   	pop    %ebx
80101e99:	5e                   	pop    %esi
80101e9a:	5f                   	pop    %edi
80101e9b:	5d                   	pop    %ebp
80101e9c:	c3                   	ret    
80101e9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ea0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ea4:	66 83 f8 09          	cmp    $0x9,%ax
80101ea8:	77 17                	ja     80101ec1 <readi+0xf1>
80101eaa:	8b 04 c5 80 2a 11 80 	mov    -0x7feed580(,%eax,8),%eax
80101eb1:	85 c0                	test   %eax,%eax
80101eb3:	74 0c                	je     80101ec1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101eb5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ebb:	5b                   	pop    %ebx
80101ebc:	5e                   	pop    %esi
80101ebd:	5f                   	pop    %edi
80101ebe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101ebf:	ff e0                	jmp    *%eax
      return -1;
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb cd                	jmp    80101e95 <readi+0xc5>
80101ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecf:	90                   	nop

80101ed0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ed0:	f3 0f 1e fb          	endbr32 
80101ed4:	55                   	push   %ebp
80101ed5:	89 e5                	mov    %esp,%ebp
80101ed7:	57                   	push   %edi
80101ed8:	56                   	push   %esi
80101ed9:	53                   	push   %ebx
80101eda:	83 ec 1c             	sub    $0x1c,%esp
80101edd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee0:	8b 75 0c             	mov    0xc(%ebp),%esi
80101ee3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ee6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101eeb:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101eee:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ef1:	8b 75 10             	mov    0x10(%ebp),%esi
80101ef4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ef7:	0f 84 b3 00 00 00    	je     80101fb0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101efd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f00:	39 70 58             	cmp    %esi,0x58(%eax)
80101f03:	0f 82 e3 00 00 00    	jb     80101fec <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101f09:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101f0c:	89 f8                	mov    %edi,%eax
80101f0e:	01 f0                	add    %esi,%eax
80101f10:	0f 82 d6 00 00 00    	jb     80101fec <writei+0x11c>
80101f16:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f1b:	0f 87 cb 00 00 00    	ja     80101fec <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101f28:	85 ff                	test   %edi,%edi
80101f2a:	74 75                	je     80101fa1 <writei+0xd1>
80101f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f30:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101f33:	89 f2                	mov    %esi,%edx
80101f35:	c1 ea 09             	shr    $0x9,%edx
80101f38:	89 f8                	mov    %edi,%eax
80101f3a:	e8 61 f8 ff ff       	call   801017a0 <bmap>
80101f3f:	83 ec 08             	sub    $0x8,%esp
80101f42:	50                   	push   %eax
80101f43:	ff 37                	pushl  (%edi)
80101f45:	e8 86 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101f4a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101f4f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101f52:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f55:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101f57:	89 f0                	mov    %esi,%eax
80101f59:	83 c4 0c             	add    $0xc,%esp
80101f5c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f61:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101f63:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101f67:	39 d9                	cmp    %ebx,%ecx
80101f69:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101f6c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f6d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101f6f:	ff 75 dc             	pushl  -0x24(%ebp)
80101f72:	50                   	push   %eax
80101f73:	e8 28 39 00 00       	call   801058a0 <memmove>
    log_write(bp);
80101f78:	89 3c 24             	mov    %edi,(%esp)
80101f7b:	e8 00 13 00 00       	call   80103280 <log_write>
    brelse(bp);
80101f80:	89 3c 24             	mov    %edi,(%esp)
80101f83:	e8 68 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f88:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f91:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101f94:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101f97:	77 97                	ja     80101f30 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101f99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f9c:	3b 70 58             	cmp    0x58(%eax),%esi
80101f9f:	77 37                	ja     80101fd8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101fa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101fa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fa7:	5b                   	pop    %ebx
80101fa8:	5e                   	pop    %esi
80101fa9:	5f                   	pop    %edi
80101faa:	5d                   	pop    %ebp
80101fab:	c3                   	ret    
80101fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101fb4:	66 83 f8 09          	cmp    $0x9,%ax
80101fb8:	77 32                	ja     80101fec <writei+0x11c>
80101fba:	8b 04 c5 84 2a 11 80 	mov    -0x7feed57c(,%eax,8),%eax
80101fc1:	85 c0                	test   %eax,%eax
80101fc3:	74 27                	je     80101fec <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101fc5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5f                   	pop    %edi
80101fce:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101fcf:	ff e0                	jmp    *%eax
80101fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101fd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101fdb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101fde:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101fe1:	50                   	push   %eax
80101fe2:	e8 29 fa ff ff       	call   80101a10 <iupdate>
80101fe7:	83 c4 10             	add    $0x10,%esp
80101fea:	eb b5                	jmp    80101fa1 <writei+0xd1>
      return -1;
80101fec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ff1:	eb b1                	jmp    80101fa4 <writei+0xd4>
80101ff3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102000 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102000:	f3 0f 1e fb          	endbr32 
80102004:	55                   	push   %ebp
80102005:	89 e5                	mov    %esp,%ebp
80102007:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010200a:	6a 0e                	push   $0xe
8010200c:	ff 75 0c             	pushl  0xc(%ebp)
8010200f:	ff 75 08             	pushl  0x8(%ebp)
80102012:	e8 f9 38 00 00       	call   80105910 <strncmp>
}
80102017:	c9                   	leave  
80102018:	c3                   	ret    
80102019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102020 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102020:	f3 0f 1e fb          	endbr32 
80102024:	55                   	push   %ebp
80102025:	89 e5                	mov    %esp,%ebp
80102027:	57                   	push   %edi
80102028:	56                   	push   %esi
80102029:	53                   	push   %ebx
8010202a:	83 ec 1c             	sub    $0x1c,%esp
8010202d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102030:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102035:	0f 85 89 00 00 00    	jne    801020c4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010203b:	8b 53 58             	mov    0x58(%ebx),%edx
8010203e:	31 ff                	xor    %edi,%edi
80102040:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102043:	85 d2                	test   %edx,%edx
80102045:	74 42                	je     80102089 <dirlookup+0x69>
80102047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010204e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102050:	6a 10                	push   $0x10
80102052:	57                   	push   %edi
80102053:	56                   	push   %esi
80102054:	53                   	push   %ebx
80102055:	e8 76 fd ff ff       	call   80101dd0 <readi>
8010205a:	83 c4 10             	add    $0x10,%esp
8010205d:	83 f8 10             	cmp    $0x10,%eax
80102060:	75 55                	jne    801020b7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80102062:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102067:	74 18                	je     80102081 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80102069:	83 ec 04             	sub    $0x4,%esp
8010206c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010206f:	6a 0e                	push   $0xe
80102071:	50                   	push   %eax
80102072:	ff 75 0c             	pushl  0xc(%ebp)
80102075:	e8 96 38 00 00       	call   80105910 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
8010207a:	83 c4 10             	add    $0x10,%esp
8010207d:	85 c0                	test   %eax,%eax
8010207f:	74 17                	je     80102098 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102081:	83 c7 10             	add    $0x10,%edi
80102084:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102087:	72 c7                	jb     80102050 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102089:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010208c:	31 c0                	xor    %eax,%eax
}
8010208e:	5b                   	pop    %ebx
8010208f:	5e                   	pop    %esi
80102090:	5f                   	pop    %edi
80102091:	5d                   	pop    %ebp
80102092:	c3                   	ret    
80102093:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102097:	90                   	nop
      if(poff)
80102098:	8b 45 10             	mov    0x10(%ebp),%eax
8010209b:	85 c0                	test   %eax,%eax
8010209d:	74 05                	je     801020a4 <dirlookup+0x84>
        *poff = off;
8010209f:	8b 45 10             	mov    0x10(%ebp),%eax
801020a2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801020a4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801020a8:	8b 03                	mov    (%ebx),%eax
801020aa:	e8 01 f6 ff ff       	call   801016b0 <iget>
}
801020af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b2:	5b                   	pop    %ebx
801020b3:	5e                   	pop    %esi
801020b4:	5f                   	pop    %edi
801020b5:	5d                   	pop    %ebp
801020b6:	c3                   	ret    
      panic("dirlookup read");
801020b7:	83 ec 0c             	sub    $0xc,%esp
801020ba:	68 5d 86 10 80       	push   $0x8010865d
801020bf:	e8 cc e2 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
801020c4:	83 ec 0c             	sub    $0xc,%esp
801020c7:	68 4b 86 10 80       	push   $0x8010864b
801020cc:	e8 bf e2 ff ff       	call   80100390 <panic>
801020d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020df:	90                   	nop

801020e0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	89 c3                	mov    %eax,%ebx
801020e8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801020eb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801020ee:	89 55 e0             	mov    %edx,-0x20(%ebp)
801020f1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801020f4:	0f 84 86 01 00 00    	je     80102280 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801020fa:	e8 a1 1c 00 00       	call   80103da0 <myproc>
  acquire(&icache.lock);
801020ff:	83 ec 0c             	sub    $0xc,%esp
80102102:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102104:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102107:	68 00 2b 11 80       	push   $0x80112b00
8010210c:	e8 df 35 00 00       	call   801056f0 <acquire>
  ip->ref++;
80102111:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102115:	c7 04 24 00 2b 11 80 	movl   $0x80112b00,(%esp)
8010211c:	e8 8f 36 00 00       	call   801057b0 <release>
80102121:	83 c4 10             	add    $0x10,%esp
80102124:	eb 0d                	jmp    80102133 <namex+0x53>
80102126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010212d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102130:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102133:	0f b6 07             	movzbl (%edi),%eax
80102136:	3c 2f                	cmp    $0x2f,%al
80102138:	74 f6                	je     80102130 <namex+0x50>
  if(*path == 0)
8010213a:	84 c0                	test   %al,%al
8010213c:	0f 84 ee 00 00 00    	je     80102230 <namex+0x150>
  while(*path != '/' && *path != 0)
80102142:	0f b6 07             	movzbl (%edi),%eax
80102145:	84 c0                	test   %al,%al
80102147:	0f 84 fb 00 00 00    	je     80102248 <namex+0x168>
8010214d:	89 fb                	mov    %edi,%ebx
8010214f:	3c 2f                	cmp    $0x2f,%al
80102151:	0f 84 f1 00 00 00    	je     80102248 <namex+0x168>
80102157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010215e:	66 90                	xchg   %ax,%ax
80102160:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102164:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102167:	3c 2f                	cmp    $0x2f,%al
80102169:	74 04                	je     8010216f <namex+0x8f>
8010216b:	84 c0                	test   %al,%al
8010216d:	75 f1                	jne    80102160 <namex+0x80>
  len = path - s;
8010216f:	89 d8                	mov    %ebx,%eax
80102171:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102173:	83 f8 0d             	cmp    $0xd,%eax
80102176:	0f 8e 84 00 00 00    	jle    80102200 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010217c:	83 ec 04             	sub    $0x4,%esp
8010217f:	6a 0e                	push   $0xe
80102181:	57                   	push   %edi
    path++;
80102182:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102184:	ff 75 e4             	pushl  -0x1c(%ebp)
80102187:	e8 14 37 00 00       	call   801058a0 <memmove>
8010218c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010218f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102192:	75 0c                	jne    801021a0 <namex+0xc0>
80102194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102198:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010219b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010219e:	74 f8                	je     80102198 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801021a0:	83 ec 0c             	sub    $0xc,%esp
801021a3:	56                   	push   %esi
801021a4:	e8 27 f9 ff ff       	call   80101ad0 <ilock>
    if(ip->type != T_DIR){
801021a9:	83 c4 10             	add    $0x10,%esp
801021ac:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801021b1:	0f 85 a1 00 00 00    	jne    80102258 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801021b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801021ba:	85 d2                	test   %edx,%edx
801021bc:	74 09                	je     801021c7 <namex+0xe7>
801021be:	80 3f 00             	cmpb   $0x0,(%edi)
801021c1:	0f 84 d9 00 00 00    	je     801022a0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801021c7:	83 ec 04             	sub    $0x4,%esp
801021ca:	6a 00                	push   $0x0
801021cc:	ff 75 e4             	pushl  -0x1c(%ebp)
801021cf:	56                   	push   %esi
801021d0:	e8 4b fe ff ff       	call   80102020 <dirlookup>
801021d5:	83 c4 10             	add    $0x10,%esp
801021d8:	89 c3                	mov    %eax,%ebx
801021da:	85 c0                	test   %eax,%eax
801021dc:	74 7a                	je     80102258 <namex+0x178>
  iunlock(ip);
801021de:	83 ec 0c             	sub    $0xc,%esp
801021e1:	56                   	push   %esi
801021e2:	e8 c9 f9 ff ff       	call   80101bb0 <iunlock>
  iput(ip);
801021e7:	89 34 24             	mov    %esi,(%esp)
801021ea:	89 de                	mov    %ebx,%esi
801021ec:	e8 0f fa ff ff       	call   80101c00 <iput>
801021f1:	83 c4 10             	add    $0x10,%esp
801021f4:	e9 3a ff ff ff       	jmp    80102133 <namex+0x53>
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102200:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102203:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102206:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102209:	83 ec 04             	sub    $0x4,%esp
8010220c:	50                   	push   %eax
8010220d:	57                   	push   %edi
    name[len] = 0;
8010220e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102210:	ff 75 e4             	pushl  -0x1c(%ebp)
80102213:	e8 88 36 00 00       	call   801058a0 <memmove>
    name[len] = 0;
80102218:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010221b:	83 c4 10             	add    $0x10,%esp
8010221e:	c6 00 00             	movb   $0x0,(%eax)
80102221:	e9 69 ff ff ff       	jmp    8010218f <namex+0xaf>
80102226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010222d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102230:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102233:	85 c0                	test   %eax,%eax
80102235:	0f 85 85 00 00 00    	jne    801022c0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010223b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010223e:	89 f0                	mov    %esi,%eax
80102240:	5b                   	pop    %ebx
80102241:	5e                   	pop    %esi
80102242:	5f                   	pop    %edi
80102243:	5d                   	pop    %ebp
80102244:	c3                   	ret    
80102245:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010224b:	89 fb                	mov    %edi,%ebx
8010224d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102250:	31 c0                	xor    %eax,%eax
80102252:	eb b5                	jmp    80102209 <namex+0x129>
80102254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102258:	83 ec 0c             	sub    $0xc,%esp
8010225b:	56                   	push   %esi
8010225c:	e8 4f f9 ff ff       	call   80101bb0 <iunlock>
  iput(ip);
80102261:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102264:	31 f6                	xor    %esi,%esi
  iput(ip);
80102266:	e8 95 f9 ff ff       	call   80101c00 <iput>
      return 0;
8010226b:	83 c4 10             	add    $0x10,%esp
}
8010226e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102271:	89 f0                	mov    %esi,%eax
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80102280:	ba 01 00 00 00       	mov    $0x1,%edx
80102285:	b8 01 00 00 00       	mov    $0x1,%eax
8010228a:	89 df                	mov    %ebx,%edi
8010228c:	e8 1f f4 ff ff       	call   801016b0 <iget>
80102291:	89 c6                	mov    %eax,%esi
80102293:	e9 9b fe ff ff       	jmp    80102133 <namex+0x53>
80102298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229f:	90                   	nop
      iunlock(ip);
801022a0:	83 ec 0c             	sub    $0xc,%esp
801022a3:	56                   	push   %esi
801022a4:	e8 07 f9 ff ff       	call   80101bb0 <iunlock>
      return ip;
801022a9:	83 c4 10             	add    $0x10,%esp
}
801022ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022af:	89 f0                	mov    %esi,%eax
801022b1:	5b                   	pop    %ebx
801022b2:	5e                   	pop    %esi
801022b3:	5f                   	pop    %edi
801022b4:	5d                   	pop    %ebp
801022b5:	c3                   	ret    
801022b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022bd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
801022c0:	83 ec 0c             	sub    $0xc,%esp
801022c3:	56                   	push   %esi
    return 0;
801022c4:	31 f6                	xor    %esi,%esi
    iput(ip);
801022c6:	e8 35 f9 ff ff       	call   80101c00 <iput>
    return 0;
801022cb:	83 c4 10             	add    $0x10,%esp
801022ce:	e9 68 ff ff ff       	jmp    8010223b <namex+0x15b>
801022d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022e0 <dirlink>:
{
801022e0:	f3 0f 1e fb          	endbr32 
801022e4:	55                   	push   %ebp
801022e5:	89 e5                	mov    %esp,%ebp
801022e7:	57                   	push   %edi
801022e8:	56                   	push   %esi
801022e9:	53                   	push   %ebx
801022ea:	83 ec 20             	sub    $0x20,%esp
801022ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801022f0:	6a 00                	push   $0x0
801022f2:	ff 75 0c             	pushl  0xc(%ebp)
801022f5:	53                   	push   %ebx
801022f6:	e8 25 fd ff ff       	call   80102020 <dirlookup>
801022fb:	83 c4 10             	add    $0x10,%esp
801022fe:	85 c0                	test   %eax,%eax
80102300:	75 6b                	jne    8010236d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102302:	8b 7b 58             	mov    0x58(%ebx),%edi
80102305:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102308:	85 ff                	test   %edi,%edi
8010230a:	74 2d                	je     80102339 <dirlink+0x59>
8010230c:	31 ff                	xor    %edi,%edi
8010230e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102311:	eb 0d                	jmp    80102320 <dirlink+0x40>
80102313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102317:	90                   	nop
80102318:	83 c7 10             	add    $0x10,%edi
8010231b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010231e:	73 19                	jae    80102339 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102320:	6a 10                	push   $0x10
80102322:	57                   	push   %edi
80102323:	56                   	push   %esi
80102324:	53                   	push   %ebx
80102325:	e8 a6 fa ff ff       	call   80101dd0 <readi>
8010232a:	83 c4 10             	add    $0x10,%esp
8010232d:	83 f8 10             	cmp    $0x10,%eax
80102330:	75 4e                	jne    80102380 <dirlink+0xa0>
    if(de.inum == 0)
80102332:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102337:	75 df                	jne    80102318 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102339:	83 ec 04             	sub    $0x4,%esp
8010233c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010233f:	6a 0e                	push   $0xe
80102341:	ff 75 0c             	pushl  0xc(%ebp)
80102344:	50                   	push   %eax
80102345:	e8 16 36 00 00       	call   80105960 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010234a:	6a 10                	push   $0x10
  de.inum = inum;
8010234c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010234f:	57                   	push   %edi
80102350:	56                   	push   %esi
80102351:	53                   	push   %ebx
  de.inum = inum;
80102352:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102356:	e8 75 fb ff ff       	call   80101ed0 <writei>
8010235b:	83 c4 20             	add    $0x20,%esp
8010235e:	83 f8 10             	cmp    $0x10,%eax
80102361:	75 2a                	jne    8010238d <dirlink+0xad>
  return 0;
80102363:	31 c0                	xor    %eax,%eax
}
80102365:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102368:	5b                   	pop    %ebx
80102369:	5e                   	pop    %esi
8010236a:	5f                   	pop    %edi
8010236b:	5d                   	pop    %ebp
8010236c:	c3                   	ret    
    iput(ip);
8010236d:	83 ec 0c             	sub    $0xc,%esp
80102370:	50                   	push   %eax
80102371:	e8 8a f8 ff ff       	call   80101c00 <iput>
    return -1;
80102376:	83 c4 10             	add    $0x10,%esp
80102379:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010237e:	eb e5                	jmp    80102365 <dirlink+0x85>
      panic("dirlink read");
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 6c 86 10 80       	push   $0x8010866c
80102388:	e8 03 e0 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010238d:	83 ec 0c             	sub    $0xc,%esp
80102390:	68 1e 8e 10 80       	push   $0x80108e1e
80102395:	e8 f6 df ff ff       	call   80100390 <panic>
8010239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023a0 <namei>:

struct inode*
namei(char *path)
{
801023a0:	f3 0f 1e fb          	endbr32 
801023a4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801023a5:	31 d2                	xor    %edx,%edx
{
801023a7:	89 e5                	mov    %esp,%ebp
801023a9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801023ac:	8b 45 08             	mov    0x8(%ebp),%eax
801023af:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801023b2:	e8 29 fd ff ff       	call   801020e0 <namex>
}
801023b7:	c9                   	leave  
801023b8:	c3                   	ret    
801023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801023c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801023c0:	f3 0f 1e fb          	endbr32 
801023c4:	55                   	push   %ebp
  return namex(path, 1, name);
801023c5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801023ca:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801023cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801023cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023d2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801023d3:	e9 08 fd ff ff       	jmp    801020e0 <namex>
801023d8:	66 90                	xchg   %ax,%ax
801023da:	66 90                	xchg   %ax,%ax
801023dc:	66 90                	xchg   %ax,%ax
801023de:	66 90                	xchg   %ax,%ax

801023e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	57                   	push   %edi
801023e4:	56                   	push   %esi
801023e5:	53                   	push   %ebx
801023e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801023e9:	85 c0                	test   %eax,%eax
801023eb:	0f 84 b4 00 00 00    	je     801024a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801023f1:	8b 70 08             	mov    0x8(%eax),%esi
801023f4:	89 c3                	mov    %eax,%ebx
801023f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801023fc:	0f 87 96 00 00 00    	ja     80102498 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102402:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010240e:	66 90                	xchg   %ax,%ax
80102410:	89 ca                	mov    %ecx,%edx
80102412:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102413:	83 e0 c0             	and    $0xffffffc0,%eax
80102416:	3c 40                	cmp    $0x40,%al
80102418:	75 f6                	jne    80102410 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010241a:	31 ff                	xor    %edi,%edi
8010241c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102421:	89 f8                	mov    %edi,%eax
80102423:	ee                   	out    %al,(%dx)
80102424:	b8 01 00 00 00       	mov    $0x1,%eax
80102429:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010242e:	ee                   	out    %al,(%dx)
8010242f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102434:	89 f0                	mov    %esi,%eax
80102436:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102437:	89 f0                	mov    %esi,%eax
80102439:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010243e:	c1 f8 08             	sar    $0x8,%eax
80102441:	ee                   	out    %al,(%dx)
80102442:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102447:	89 f8                	mov    %edi,%eax
80102449:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010244a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010244e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102453:	c1 e0 04             	shl    $0x4,%eax
80102456:	83 e0 10             	and    $0x10,%eax
80102459:	83 c8 e0             	or     $0xffffffe0,%eax
8010245c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010245d:	f6 03 04             	testb  $0x4,(%ebx)
80102460:	75 16                	jne    80102478 <idestart+0x98>
80102462:	b8 20 00 00 00       	mov    $0x20,%eax
80102467:	89 ca                	mov    %ecx,%edx
80102469:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010246a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010246d:	5b                   	pop    %ebx
8010246e:	5e                   	pop    %esi
8010246f:	5f                   	pop    %edi
80102470:	5d                   	pop    %ebp
80102471:	c3                   	ret    
80102472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102478:	b8 30 00 00 00       	mov    $0x30,%eax
8010247d:	89 ca                	mov    %ecx,%edx
8010247f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102480:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102485:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102488:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010248d:	fc                   	cld    
8010248e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102490:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102493:	5b                   	pop    %ebx
80102494:	5e                   	pop    %esi
80102495:	5f                   	pop    %edi
80102496:	5d                   	pop    %ebp
80102497:	c3                   	ret    
    panic("incorrect blockno");
80102498:	83 ec 0c             	sub    $0xc,%esp
8010249b:	68 d8 86 10 80       	push   $0x801086d8
801024a0:	e8 eb de ff ff       	call   80100390 <panic>
    panic("idestart");
801024a5:	83 ec 0c             	sub    $0xc,%esp
801024a8:	68 cf 86 10 80       	push   $0x801086cf
801024ad:	e8 de de ff ff       	call   80100390 <panic>
801024b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801024c0 <ideinit>:
{
801024c0:	f3 0f 1e fb          	endbr32 
801024c4:	55                   	push   %ebp
801024c5:	89 e5                	mov    %esp,%ebp
801024c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801024ca:	68 ea 86 10 80       	push   $0x801086ea
801024cf:	68 00 c6 10 80       	push   $0x8010c600
801024d4:	e8 97 30 00 00       	call   80105570 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801024d9:	58                   	pop    %eax
801024da:	a1 20 4e 11 80       	mov    0x80114e20,%eax
801024df:	5a                   	pop    %edx
801024e0:	83 e8 01             	sub    $0x1,%eax
801024e3:	50                   	push   %eax
801024e4:	6a 0e                	push   $0xe
801024e6:	e8 b5 02 00 00       	call   801027a0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024eb:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024ee:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f7:	90                   	nop
801024f8:	ec                   	in     (%dx),%al
801024f9:	83 e0 c0             	and    $0xffffffc0,%eax
801024fc:	3c 40                	cmp    $0x40,%al
801024fe:	75 f8                	jne    801024f8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102500:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102505:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010250a:	ee                   	out    %al,(%dx)
8010250b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102510:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102515:	eb 0e                	jmp    80102525 <ideinit+0x65>
80102517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010251e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102520:	83 e9 01             	sub    $0x1,%ecx
80102523:	74 0f                	je     80102534 <ideinit+0x74>
80102525:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102526:	84 c0                	test   %al,%al
80102528:	74 f6                	je     80102520 <ideinit+0x60>
      havedisk1 = 1;
8010252a:	c7 05 e0 c5 10 80 01 	movl   $0x1,0x8010c5e0
80102531:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102534:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102539:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010253e:	ee                   	out    %al,(%dx)
}
8010253f:	c9                   	leave  
80102540:	c3                   	ret    
80102541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010254f:	90                   	nop

80102550 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102550:	f3 0f 1e fb          	endbr32 
80102554:	55                   	push   %ebp
80102555:	89 e5                	mov    %esp,%ebp
80102557:	57                   	push   %edi
80102558:	56                   	push   %esi
80102559:	53                   	push   %ebx
8010255a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010255d:	68 00 c6 10 80       	push   $0x8010c600
80102562:	e8 89 31 00 00       	call   801056f0 <acquire>

  if((b = idequeue) == 0){
80102567:	8b 1d e4 c5 10 80    	mov    0x8010c5e4,%ebx
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	85 db                	test   %ebx,%ebx
80102572:	74 5f                	je     801025d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102574:	8b 43 58             	mov    0x58(%ebx),%eax
80102577:	a3 e4 c5 10 80       	mov    %eax,0x8010c5e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010257c:	8b 33                	mov    (%ebx),%esi
8010257e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102584:	75 2b                	jne    801025b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102586:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010258b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010258f:	90                   	nop
80102590:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102591:	89 c1                	mov    %eax,%ecx
80102593:	83 e1 c0             	and    $0xffffffc0,%ecx
80102596:	80 f9 40             	cmp    $0x40,%cl
80102599:	75 f5                	jne    80102590 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010259b:	a8 21                	test   $0x21,%al
8010259d:	75 12                	jne    801025b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010259f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801025a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801025a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025ac:	fc                   	cld    
801025ad:	f3 6d                	rep insl (%dx),%es:(%edi)
801025af:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801025b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801025b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801025b7:	83 ce 02             	or     $0x2,%esi
801025ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801025bc:	53                   	push   %ebx
801025bd:	e8 8e 2c 00 00       	call   80105250 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801025c2:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
801025c7:	83 c4 10             	add    $0x10,%esp
801025ca:	85 c0                	test   %eax,%eax
801025cc:	74 05                	je     801025d3 <ideintr+0x83>
    idestart(idequeue);
801025ce:	e8 0d fe ff ff       	call   801023e0 <idestart>
    release(&idelock);
801025d3:	83 ec 0c             	sub    $0xc,%esp
801025d6:	68 00 c6 10 80       	push   $0x8010c600
801025db:	e8 d0 31 00 00       	call   801057b0 <release>

  release(&idelock);
}
801025e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025e3:	5b                   	pop    %ebx
801025e4:	5e                   	pop    %esi
801025e5:	5f                   	pop    %edi
801025e6:	5d                   	pop    %ebp
801025e7:	c3                   	ret    
801025e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ef:	90                   	nop

801025f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801025f0:	f3 0f 1e fb          	endbr32 
801025f4:	55                   	push   %ebp
801025f5:	89 e5                	mov    %esp,%ebp
801025f7:	53                   	push   %ebx
801025f8:	83 ec 10             	sub    $0x10,%esp
801025fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801025fe:	8d 43 0c             	lea    0xc(%ebx),%eax
80102601:	50                   	push   %eax
80102602:	e8 09 2f 00 00       	call   80105510 <holdingsleep>
80102607:	83 c4 10             	add    $0x10,%esp
8010260a:	85 c0                	test   %eax,%eax
8010260c:	0f 84 cf 00 00 00    	je     801026e1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102612:	8b 03                	mov    (%ebx),%eax
80102614:	83 e0 06             	and    $0x6,%eax
80102617:	83 f8 02             	cmp    $0x2,%eax
8010261a:	0f 84 b4 00 00 00    	je     801026d4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102620:	8b 53 04             	mov    0x4(%ebx),%edx
80102623:	85 d2                	test   %edx,%edx
80102625:	74 0d                	je     80102634 <iderw+0x44>
80102627:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
8010262c:	85 c0                	test   %eax,%eax
8010262e:	0f 84 93 00 00 00    	je     801026c7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102634:	83 ec 0c             	sub    $0xc,%esp
80102637:	68 00 c6 10 80       	push   $0x8010c600
8010263c:	e8 af 30 00 00       	call   801056f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102641:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
  b->qnext = 0;
80102646:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	85 c0                	test   %eax,%eax
80102652:	74 6c                	je     801026c0 <iderw+0xd0>
80102654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102658:	89 c2                	mov    %eax,%edx
8010265a:	8b 40 58             	mov    0x58(%eax),%eax
8010265d:	85 c0                	test   %eax,%eax
8010265f:	75 f7                	jne    80102658 <iderw+0x68>
80102661:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102664:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102666:	39 1d e4 c5 10 80    	cmp    %ebx,0x8010c5e4
8010266c:	74 42                	je     801026b0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010266e:	8b 03                	mov    (%ebx),%eax
80102670:	83 e0 06             	and    $0x6,%eax
80102673:	83 f8 02             	cmp    $0x2,%eax
80102676:	74 23                	je     8010269b <iderw+0xab>
80102678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267f:	90                   	nop
    sleep(b, &idelock);
80102680:	83 ec 08             	sub    $0x8,%esp
80102683:	68 00 c6 10 80       	push   $0x8010c600
80102688:	53                   	push   %ebx
80102689:	e8 02 2a 00 00       	call   80105090 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010268e:	8b 03                	mov    (%ebx),%eax
80102690:	83 c4 10             	add    $0x10,%esp
80102693:	83 e0 06             	and    $0x6,%eax
80102696:	83 f8 02             	cmp    $0x2,%eax
80102699:	75 e5                	jne    80102680 <iderw+0x90>
  }


  release(&idelock);
8010269b:	c7 45 08 00 c6 10 80 	movl   $0x8010c600,0x8(%ebp)
}
801026a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026a5:	c9                   	leave  
  release(&idelock);
801026a6:	e9 05 31 00 00       	jmp    801057b0 <release>
801026ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop
    idestart(b);
801026b0:	89 d8                	mov    %ebx,%eax
801026b2:	e8 29 fd ff ff       	call   801023e0 <idestart>
801026b7:	eb b5                	jmp    8010266e <iderw+0x7e>
801026b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026c0:	ba e4 c5 10 80       	mov    $0x8010c5e4,%edx
801026c5:	eb 9d                	jmp    80102664 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801026c7:	83 ec 0c             	sub    $0xc,%esp
801026ca:	68 19 87 10 80       	push   $0x80108719
801026cf:	e8 bc dc ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801026d4:	83 ec 0c             	sub    $0xc,%esp
801026d7:	68 04 87 10 80       	push   $0x80108704
801026dc:	e8 af dc ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801026e1:	83 ec 0c             	sub    $0xc,%esp
801026e4:	68 ee 86 10 80       	push   $0x801086ee
801026e9:	e8 a2 dc ff ff       	call   80100390 <panic>
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801026f0:	f3 0f 1e fb          	endbr32 
801026f4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801026f5:	c7 05 54 47 11 80 00 	movl   $0xfec00000,0x80114754
801026fc:	00 c0 fe 
{
801026ff:	89 e5                	mov    %esp,%ebp
80102701:	56                   	push   %esi
80102702:	53                   	push   %ebx
  ioapic->reg = reg;
80102703:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010270a:	00 00 00 
  return ioapic->data;
8010270d:	8b 15 54 47 11 80    	mov    0x80114754,%edx
80102713:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102716:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010271c:	8b 0d 54 47 11 80    	mov    0x80114754,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102722:	0f b6 15 80 48 11 80 	movzbl 0x80114880,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102729:	c1 ee 10             	shr    $0x10,%esi
8010272c:	89 f0                	mov    %esi,%eax
8010272e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102731:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102734:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102737:	39 c2                	cmp    %eax,%edx
80102739:	74 16                	je     80102751 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010273b:	83 ec 0c             	sub    $0xc,%esp
8010273e:	68 38 87 10 80       	push   $0x80108738
80102743:	e8 68 df ff ff       	call   801006b0 <cprintf>
80102748:	8b 0d 54 47 11 80    	mov    0x80114754,%ecx
8010274e:	83 c4 10             	add    $0x10,%esp
80102751:	83 c6 21             	add    $0x21,%esi
{
80102754:	ba 10 00 00 00       	mov    $0x10,%edx
80102759:	b8 20 00 00 00       	mov    $0x20,%eax
8010275e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102760:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102762:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102764:	8b 0d 54 47 11 80    	mov    0x80114754,%ecx
8010276a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010276d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102773:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102776:	8d 5a 01             	lea    0x1(%edx),%ebx
80102779:	83 c2 02             	add    $0x2,%edx
8010277c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010277e:	8b 0d 54 47 11 80    	mov    0x80114754,%ecx
80102784:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010278b:	39 f0                	cmp    %esi,%eax
8010278d:	75 d1                	jne    80102760 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010278f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102792:	5b                   	pop    %ebx
80102793:	5e                   	pop    %esi
80102794:	5d                   	pop    %ebp
80102795:	c3                   	ret    
80102796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010279d:	8d 76 00             	lea    0x0(%esi),%esi

801027a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801027a0:	f3 0f 1e fb          	endbr32 
801027a4:	55                   	push   %ebp
  ioapic->reg = reg;
801027a5:	8b 0d 54 47 11 80    	mov    0x80114754,%ecx
{
801027ab:	89 e5                	mov    %esp,%ebp
801027ad:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801027b0:	8d 50 20             	lea    0x20(%eax),%edx
801027b3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801027b7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027b9:	8b 0d 54 47 11 80    	mov    0x80114754,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027bf:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801027c2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801027c8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027ca:	a1 54 47 11 80       	mov    0x80114754,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027cf:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801027d2:	89 50 10             	mov    %edx,0x10(%eax)
}
801027d5:	5d                   	pop    %ebp
801027d6:	c3                   	ret    
801027d7:	66 90                	xchg   %ax,%ax
801027d9:	66 90                	xchg   %ax,%ax
801027db:	66 90                	xchg   %ax,%ax
801027dd:	66 90                	xchg   %ax,%ax
801027df:	90                   	nop

801027e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801027e0:	f3 0f 1e fb          	endbr32 
801027e4:	55                   	push   %ebp
801027e5:	89 e5                	mov    %esp,%ebp
801027e7:	53                   	push   %ebx
801027e8:	83 ec 04             	sub    $0x4,%esp
801027eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801027ee:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801027f4:	75 7a                	jne    80102870 <kfree+0x90>
801027f6:	81 fb c8 9f 11 80    	cmp    $0x80119fc8,%ebx
801027fc:	72 72                	jb     80102870 <kfree+0x90>
801027fe:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102804:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102809:	77 65                	ja     80102870 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010280b:	83 ec 04             	sub    $0x4,%esp
8010280e:	68 00 10 00 00       	push   $0x1000
80102813:	6a 01                	push   $0x1
80102815:	53                   	push   %ebx
80102816:	e8 e5 2f 00 00       	call   80105800 <memset>

  if(kmem.use_lock)
8010281b:	8b 15 94 47 11 80    	mov    0x80114794,%edx
80102821:	83 c4 10             	add    $0x10,%esp
80102824:	85 d2                	test   %edx,%edx
80102826:	75 20                	jne    80102848 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102828:	a1 98 47 11 80       	mov    0x80114798,%eax
8010282d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010282f:	a1 94 47 11 80       	mov    0x80114794,%eax
  kmem.freelist = r;
80102834:	89 1d 98 47 11 80    	mov    %ebx,0x80114798
  if(kmem.use_lock)
8010283a:	85 c0                	test   %eax,%eax
8010283c:	75 22                	jne    80102860 <kfree+0x80>
    release(&kmem.lock);
}
8010283e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102841:	c9                   	leave  
80102842:	c3                   	ret    
80102843:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102847:	90                   	nop
    acquire(&kmem.lock);
80102848:	83 ec 0c             	sub    $0xc,%esp
8010284b:	68 60 47 11 80       	push   $0x80114760
80102850:	e8 9b 2e 00 00       	call   801056f0 <acquire>
80102855:	83 c4 10             	add    $0x10,%esp
80102858:	eb ce                	jmp    80102828 <kfree+0x48>
8010285a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102860:	c7 45 08 60 47 11 80 	movl   $0x80114760,0x8(%ebp)
}
80102867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010286a:	c9                   	leave  
    release(&kmem.lock);
8010286b:	e9 40 2f 00 00       	jmp    801057b0 <release>
    panic("kfree");
80102870:	83 ec 0c             	sub    $0xc,%esp
80102873:	68 6a 87 10 80       	push   $0x8010876a
80102878:	e8 13 db ff ff       	call   80100390 <panic>
8010287d:	8d 76 00             	lea    0x0(%esi),%esi

80102880 <freerange>:
{
80102880:	f3 0f 1e fb          	endbr32 
80102884:	55                   	push   %ebp
80102885:	89 e5                	mov    %esp,%ebp
80102887:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102888:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010288b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010288e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010288f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102895:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010289b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028a1:	39 de                	cmp    %ebx,%esi
801028a3:	72 1f                	jb     801028c4 <freerange+0x44>
801028a5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801028a8:	83 ec 0c             	sub    $0xc,%esp
801028ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028b7:	50                   	push   %eax
801028b8:	e8 23 ff ff ff       	call   801027e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028bd:	83 c4 10             	add    $0x10,%esp
801028c0:	39 f3                	cmp    %esi,%ebx
801028c2:	76 e4                	jbe    801028a8 <freerange+0x28>
}
801028c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028c7:	5b                   	pop    %ebx
801028c8:	5e                   	pop    %esi
801028c9:	5d                   	pop    %ebp
801028ca:	c3                   	ret    
801028cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop

801028d0 <kinit1>:
{
801028d0:	f3 0f 1e fb          	endbr32 
801028d4:	55                   	push   %ebp
801028d5:	89 e5                	mov    %esp,%ebp
801028d7:	56                   	push   %esi
801028d8:	53                   	push   %ebx
801028d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801028dc:	83 ec 08             	sub    $0x8,%esp
801028df:	68 70 87 10 80       	push   $0x80108770
801028e4:	68 60 47 11 80       	push   $0x80114760
801028e9:	e8 82 2c 00 00       	call   80105570 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028f1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801028f4:	c7 05 94 47 11 80 00 	movl   $0x0,0x80114794
801028fb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801028fe:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102904:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010290a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102910:	39 de                	cmp    %ebx,%esi
80102912:	72 20                	jb     80102934 <kinit1+0x64>
80102914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102918:	83 ec 0c             	sub    $0xc,%esp
8010291b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102921:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102927:	50                   	push   %eax
80102928:	e8 b3 fe ff ff       	call   801027e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010292d:	83 c4 10             	add    $0x10,%esp
80102930:	39 de                	cmp    %ebx,%esi
80102932:	73 e4                	jae    80102918 <kinit1+0x48>
}
80102934:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102937:	5b                   	pop    %ebx
80102938:	5e                   	pop    %esi
80102939:	5d                   	pop    %ebp
8010293a:	c3                   	ret    
8010293b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <kinit2>:
{
80102940:	f3 0f 1e fb          	endbr32 
80102944:	55                   	push   %ebp
80102945:	89 e5                	mov    %esp,%ebp
80102947:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102948:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010294b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010294e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010294f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102955:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010295b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102961:	39 de                	cmp    %ebx,%esi
80102963:	72 1f                	jb     80102984 <kinit2+0x44>
80102965:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102968:	83 ec 0c             	sub    $0xc,%esp
8010296b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102971:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102977:	50                   	push   %eax
80102978:	e8 63 fe ff ff       	call   801027e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010297d:	83 c4 10             	add    $0x10,%esp
80102980:	39 de                	cmp    %ebx,%esi
80102982:	73 e4                	jae    80102968 <kinit2+0x28>
  kmem.use_lock = 1;
80102984:	c7 05 94 47 11 80 01 	movl   $0x1,0x80114794
8010298b:	00 00 00 
}
8010298e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102991:	5b                   	pop    %ebx
80102992:	5e                   	pop    %esi
80102993:	5d                   	pop    %ebp
80102994:	c3                   	ret    
80102995:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801029a0:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
801029a4:	a1 94 47 11 80       	mov    0x80114794,%eax
801029a9:	85 c0                	test   %eax,%eax
801029ab:	75 1b                	jne    801029c8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801029ad:	a1 98 47 11 80       	mov    0x80114798,%eax
  if(r)
801029b2:	85 c0                	test   %eax,%eax
801029b4:	74 0a                	je     801029c0 <kalloc+0x20>
    kmem.freelist = r->next;
801029b6:	8b 10                	mov    (%eax),%edx
801029b8:	89 15 98 47 11 80    	mov    %edx,0x80114798
  if(kmem.use_lock)
801029be:	c3                   	ret    
801029bf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801029c0:	c3                   	ret    
801029c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801029c8:	55                   	push   %ebp
801029c9:	89 e5                	mov    %esp,%ebp
801029cb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801029ce:	68 60 47 11 80       	push   $0x80114760
801029d3:	e8 18 2d 00 00       	call   801056f0 <acquire>
  r = kmem.freelist;
801029d8:	a1 98 47 11 80       	mov    0x80114798,%eax
  if(r)
801029dd:	8b 15 94 47 11 80    	mov    0x80114794,%edx
801029e3:	83 c4 10             	add    $0x10,%esp
801029e6:	85 c0                	test   %eax,%eax
801029e8:	74 08                	je     801029f2 <kalloc+0x52>
    kmem.freelist = r->next;
801029ea:	8b 08                	mov    (%eax),%ecx
801029ec:	89 0d 98 47 11 80    	mov    %ecx,0x80114798
  if(kmem.use_lock)
801029f2:	85 d2                	test   %edx,%edx
801029f4:	74 16                	je     80102a0c <kalloc+0x6c>
    release(&kmem.lock);
801029f6:	83 ec 0c             	sub    $0xc,%esp
801029f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029fc:	68 60 47 11 80       	push   $0x80114760
80102a01:	e8 aa 2d 00 00       	call   801057b0 <release>
  return (char*)r;
80102a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102a09:	83 c4 10             	add    $0x10,%esp
}
80102a0c:	c9                   	leave  
80102a0d:	c3                   	ret    
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102a10:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a14:	ba 64 00 00 00       	mov    $0x64,%edx
80102a19:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a1a:	a8 01                	test   $0x1,%al
80102a1c:	0f 84 be 00 00 00    	je     80102ae0 <kbdgetc+0xd0>
{
80102a22:	55                   	push   %ebp
80102a23:	ba 60 00 00 00       	mov    $0x60,%edx
80102a28:	89 e5                	mov    %esp,%ebp
80102a2a:	53                   	push   %ebx
80102a2b:	ec                   	in     (%dx),%al
  return data;
80102a2c:	8b 1d 34 c6 10 80    	mov    0x8010c634,%ebx
    return -1;
  data = inb(KBDATAP);
80102a32:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102a35:	3c e0                	cmp    $0xe0,%al
80102a37:	74 57                	je     80102a90 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102a39:	89 d9                	mov    %ebx,%ecx
80102a3b:	83 e1 40             	and    $0x40,%ecx
80102a3e:	84 c0                	test   %al,%al
80102a40:	78 5e                	js     80102aa0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a42:	85 c9                	test   %ecx,%ecx
80102a44:	74 09                	je     80102a4f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a46:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a49:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102a4c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102a4f:	0f b6 8a a0 88 10 80 	movzbl -0x7fef7760(%edx),%ecx
  shift ^= togglecode[data];
80102a56:	0f b6 82 a0 87 10 80 	movzbl -0x7fef7860(%edx),%eax
  shift |= shiftcode[data];
80102a5d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102a5f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a61:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102a63:	89 0d 34 c6 10 80    	mov    %ecx,0x8010c634
  c = charcode[shift & (CTL | SHIFT)][data];
80102a69:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a6c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a6f:	8b 04 85 80 87 10 80 	mov    -0x7fef7880(,%eax,4),%eax
80102a76:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102a7a:	74 0b                	je     80102a87 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102a7c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a7f:	83 fa 19             	cmp    $0x19,%edx
80102a82:	77 44                	ja     80102ac8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a84:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a87:	5b                   	pop    %ebx
80102a88:	5d                   	pop    %ebp
80102a89:	c3                   	ret    
80102a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102a90:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102a93:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a95:	89 1d 34 c6 10 80    	mov    %ebx,0x8010c634
}
80102a9b:	5b                   	pop    %ebx
80102a9c:	5d                   	pop    %ebp
80102a9d:	c3                   	ret    
80102a9e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102aa0:	83 e0 7f             	and    $0x7f,%eax
80102aa3:	85 c9                	test   %ecx,%ecx
80102aa5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102aa8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102aaa:	0f b6 8a a0 88 10 80 	movzbl -0x7fef7760(%edx),%ecx
80102ab1:	83 c9 40             	or     $0x40,%ecx
80102ab4:	0f b6 c9             	movzbl %cl,%ecx
80102ab7:	f7 d1                	not    %ecx
80102ab9:	21 d9                	and    %ebx,%ecx
}
80102abb:	5b                   	pop    %ebx
80102abc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102abd:	89 0d 34 c6 10 80    	mov    %ecx,0x8010c634
}
80102ac3:	c3                   	ret    
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102ac8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102acb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102ace:	5b                   	pop    %ebx
80102acf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102ad0:	83 f9 1a             	cmp    $0x1a,%ecx
80102ad3:	0f 42 c2             	cmovb  %edx,%eax
}
80102ad6:	c3                   	ret    
80102ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ade:	66 90                	xchg   %ax,%ax
    return -1;
80102ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ae5:	c3                   	ret    
80102ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aed:	8d 76 00             	lea    0x0(%esi),%esi

80102af0 <kbdintr>:

void
kbdintr(void)
{
80102af0:	f3 0f 1e fb          	endbr32 
80102af4:	55                   	push   %ebp
80102af5:	89 e5                	mov    %esp,%ebp
80102af7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102afa:	68 10 2a 10 80       	push   $0x80102a10
80102aff:	e8 3c e0 ff ff       	call   80100b40 <consoleintr>
}
80102b04:	83 c4 10             	add    $0x10,%esp
80102b07:	c9                   	leave  
80102b08:	c3                   	ret    
80102b09:	66 90                	xchg   %ax,%ax
80102b0b:	66 90                	xchg   %ax,%ax
80102b0d:	66 90                	xchg   %ax,%ax
80102b0f:	90                   	nop

80102b10 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102b10:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102b14:	a1 9c 47 11 80       	mov    0x8011479c,%eax
80102b19:	85 c0                	test   %eax,%eax
80102b1b:	0f 84 c7 00 00 00    	je     80102be8 <lapicinit+0xd8>
  lapic[index] = value;
80102b21:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b28:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b2e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b35:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b38:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b3b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b42:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b45:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b48:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b4f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b52:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b55:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b5c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b5f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b62:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b69:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b6c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b6f:	8b 50 30             	mov    0x30(%eax),%edx
80102b72:	c1 ea 10             	shr    $0x10,%edx
80102b75:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102b7b:	75 73                	jne    80102bf0 <lapicinit+0xe0>
  lapic[index] = value;
80102b7d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b84:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b87:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b8a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b91:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b94:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b97:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b9e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102bab:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bb1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102bb8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bbb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bbe:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102bc5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc8:	8b 50 20             	mov    0x20(%eax),%edx
80102bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bcf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102bd0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102bd6:	80 e6 10             	and    $0x10,%dh
80102bd9:	75 f5                	jne    80102bd0 <lapicinit+0xc0>
  lapic[index] = value;
80102bdb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102be2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102be5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102be8:	c3                   	ret    
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102bf0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102bf7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bfa:	8b 50 20             	mov    0x20(%eax),%edx
}
80102bfd:	e9 7b ff ff ff       	jmp    80102b7d <lapicinit+0x6d>
80102c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c10 <lapicid>:

int
lapicid(void)
{
80102c10:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102c14:	a1 9c 47 11 80       	mov    0x8011479c,%eax
80102c19:	85 c0                	test   %eax,%eax
80102c1b:	74 0b                	je     80102c28 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102c1d:	8b 40 20             	mov    0x20(%eax),%eax
80102c20:	c1 e8 18             	shr    $0x18,%eax
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102c28:	31 c0                	xor    %eax,%eax
}
80102c2a:	c3                   	ret    
80102c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c2f:	90                   	nop

80102c30 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102c30:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102c34:	a1 9c 47 11 80       	mov    0x8011479c,%eax
80102c39:	85 c0                	test   %eax,%eax
80102c3b:	74 0d                	je     80102c4a <lapiceoi+0x1a>
  lapic[index] = value;
80102c3d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c47:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c4a:	c3                   	ret    
80102c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c4f:	90                   	nop

80102c50 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102c50:	f3 0f 1e fb          	endbr32 
}
80102c54:	c3                   	ret    
80102c55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c60 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c60:	f3 0f 1e fb          	endbr32 
80102c64:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c65:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c6a:	ba 70 00 00 00       	mov    $0x70,%edx
80102c6f:	89 e5                	mov    %esp,%ebp
80102c71:	53                   	push   %ebx
80102c72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c75:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c78:	ee                   	out    %al,(%dx)
80102c79:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c7e:	ba 71 00 00 00       	mov    $0x71,%edx
80102c83:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c84:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c86:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c89:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c8f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c91:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102c94:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102c96:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c99:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c9c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102ca2:	a1 9c 47 11 80       	mov    0x8011479c,%eax
80102ca7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cad:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cb0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102cb7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cba:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cbd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102cc4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cc7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cca:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cd0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cd3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cd9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cdc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ce2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ce5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102ceb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102cec:	8b 40 20             	mov    0x20(%eax),%eax
}
80102cef:	5d                   	pop    %ebp
80102cf0:	c3                   	ret    
80102cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop

80102d00 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102d00:	f3 0f 1e fb          	endbr32 
80102d04:	55                   	push   %ebp
80102d05:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d0a:	ba 70 00 00 00       	mov    $0x70,%edx
80102d0f:	89 e5                	mov    %esp,%ebp
80102d11:	57                   	push   %edi
80102d12:	56                   	push   %esi
80102d13:	53                   	push   %ebx
80102d14:	83 ec 4c             	sub    $0x4c,%esp
80102d17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d18:	ba 71 00 00 00       	mov    $0x71,%edx
80102d1d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102d1e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d21:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d26:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d30:	31 c0                	xor    %eax,%eax
80102d32:	89 da                	mov    %ebx,%edx
80102d34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d35:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d3a:	89 ca                	mov    %ecx,%edx
80102d3c:	ec                   	in     (%dx),%al
80102d3d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d40:	89 da                	mov    %ebx,%edx
80102d42:	b8 02 00 00 00       	mov    $0x2,%eax
80102d47:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d48:	89 ca                	mov    %ecx,%edx
80102d4a:	ec                   	in     (%dx),%al
80102d4b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d4e:	89 da                	mov    %ebx,%edx
80102d50:	b8 04 00 00 00       	mov    $0x4,%eax
80102d55:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d56:	89 ca                	mov    %ecx,%edx
80102d58:	ec                   	in     (%dx),%al
80102d59:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d5c:	89 da                	mov    %ebx,%edx
80102d5e:	b8 07 00 00 00       	mov    $0x7,%eax
80102d63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d64:	89 ca                	mov    %ecx,%edx
80102d66:	ec                   	in     (%dx),%al
80102d67:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d6a:	89 da                	mov    %ebx,%edx
80102d6c:	b8 08 00 00 00       	mov    $0x8,%eax
80102d71:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d72:	89 ca                	mov    %ecx,%edx
80102d74:	ec                   	in     (%dx),%al
80102d75:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d77:	89 da                	mov    %ebx,%edx
80102d79:	b8 09 00 00 00       	mov    $0x9,%eax
80102d7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d7f:	89 ca                	mov    %ecx,%edx
80102d81:	ec                   	in     (%dx),%al
80102d82:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d84:	89 da                	mov    %ebx,%edx
80102d86:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8c:	89 ca                	mov    %ecx,%edx
80102d8e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d8f:	84 c0                	test   %al,%al
80102d91:	78 9d                	js     80102d30 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102d93:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d97:	89 fa                	mov    %edi,%edx
80102d99:	0f b6 fa             	movzbl %dl,%edi
80102d9c:	89 f2                	mov    %esi,%edx
80102d9e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102da1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102da5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da8:	89 da                	mov    %ebx,%edx
80102daa:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102dad:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102db0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102db4:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102db7:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102dba:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102dbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102dc1:	31 c0                	xor    %eax,%eax
80102dc3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dc4:	89 ca                	mov    %ecx,%edx
80102dc6:	ec                   	in     (%dx),%al
80102dc7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dca:	89 da                	mov    %ebx,%edx
80102dcc:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102dcf:	b8 02 00 00 00       	mov    $0x2,%eax
80102dd4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd5:	89 ca                	mov    %ecx,%edx
80102dd7:	ec                   	in     (%dx),%al
80102dd8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ddb:	89 da                	mov    %ebx,%edx
80102ddd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102de0:	b8 04 00 00 00       	mov    $0x4,%eax
80102de5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de6:	89 ca                	mov    %ecx,%edx
80102de8:	ec                   	in     (%dx),%al
80102de9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dec:	89 da                	mov    %ebx,%edx
80102dee:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102df1:	b8 07 00 00 00       	mov    $0x7,%eax
80102df6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102df7:	89 ca                	mov    %ecx,%edx
80102df9:	ec                   	in     (%dx),%al
80102dfa:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dfd:	89 da                	mov    %ebx,%edx
80102dff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e02:	b8 08 00 00 00       	mov    $0x8,%eax
80102e07:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e08:	89 ca                	mov    %ecx,%edx
80102e0a:	ec                   	in     (%dx),%al
80102e0b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e0e:	89 da                	mov    %ebx,%edx
80102e10:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e13:	b8 09 00 00 00       	mov    $0x9,%eax
80102e18:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e19:	89 ca                	mov    %ecx,%edx
80102e1b:	ec                   	in     (%dx),%al
80102e1c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e1f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e25:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e28:	6a 18                	push   $0x18
80102e2a:	50                   	push   %eax
80102e2b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e2e:	50                   	push   %eax
80102e2f:	e8 1c 2a 00 00       	call   80105850 <memcmp>
80102e34:	83 c4 10             	add    $0x10,%esp
80102e37:	85 c0                	test   %eax,%eax
80102e39:	0f 85 f1 fe ff ff    	jne    80102d30 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102e3f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e43:	75 78                	jne    80102ebd <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e45:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e48:	89 c2                	mov    %eax,%edx
80102e4a:	83 e0 0f             	and    $0xf,%eax
80102e4d:	c1 ea 04             	shr    $0x4,%edx
80102e50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e56:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e59:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e5c:	89 c2                	mov    %eax,%edx
80102e5e:	83 e0 0f             	and    $0xf,%eax
80102e61:	c1 ea 04             	shr    $0x4,%edx
80102e64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e6a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e6d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e70:	89 c2                	mov    %eax,%edx
80102e72:	83 e0 0f             	and    $0xf,%eax
80102e75:	c1 ea 04             	shr    $0x4,%edx
80102e78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e7e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e84:	89 c2                	mov    %eax,%edx
80102e86:	83 e0 0f             	and    $0xf,%eax
80102e89:	c1 ea 04             	shr    $0x4,%edx
80102e8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e92:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e95:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e98:	89 c2                	mov    %eax,%edx
80102e9a:	83 e0 0f             	and    $0xf,%eax
80102e9d:	c1 ea 04             	shr    $0x4,%edx
80102ea0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ea3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ea6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ea9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102eac:	89 c2                	mov    %eax,%edx
80102eae:	83 e0 0f             	and    $0xf,%eax
80102eb1:	c1 ea 04             	shr    $0x4,%edx
80102eb4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102eb7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eba:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ebd:	8b 75 08             	mov    0x8(%ebp),%esi
80102ec0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ec3:	89 06                	mov    %eax,(%esi)
80102ec5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ec8:	89 46 04             	mov    %eax,0x4(%esi)
80102ecb:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ece:	89 46 08             	mov    %eax,0x8(%esi)
80102ed1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ed4:	89 46 0c             	mov    %eax,0xc(%esi)
80102ed7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102eda:	89 46 10             	mov    %eax,0x10(%esi)
80102edd:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ee0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102ee3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eed:	5b                   	pop    %ebx
80102eee:	5e                   	pop    %esi
80102eef:	5f                   	pop    %edi
80102ef0:	5d                   	pop    %ebp
80102ef1:	c3                   	ret    
80102ef2:	66 90                	xchg   %ax,%ax
80102ef4:	66 90                	xchg   %ax,%ax
80102ef6:	66 90                	xchg   %ax,%ax
80102ef8:	66 90                	xchg   %ax,%ax
80102efa:	66 90                	xchg   %ax,%ax
80102efc:	66 90                	xchg   %ax,%ax
80102efe:	66 90                	xchg   %ax,%ax

80102f00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f00:	8b 0d e8 47 11 80    	mov    0x801147e8,%ecx
80102f06:	85 c9                	test   %ecx,%ecx
80102f08:	0f 8e 8a 00 00 00    	jle    80102f98 <install_trans+0x98>
{
80102f0e:	55                   	push   %ebp
80102f0f:	89 e5                	mov    %esp,%ebp
80102f11:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102f12:	31 ff                	xor    %edi,%edi
{
80102f14:	56                   	push   %esi
80102f15:	53                   	push   %ebx
80102f16:	83 ec 0c             	sub    $0xc,%esp
80102f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f20:	a1 d4 47 11 80       	mov    0x801147d4,%eax
80102f25:	83 ec 08             	sub    $0x8,%esp
80102f28:	01 f8                	add    %edi,%eax
80102f2a:	83 c0 01             	add    $0x1,%eax
80102f2d:	50                   	push   %eax
80102f2e:	ff 35 e4 47 11 80    	pushl  0x801147e4
80102f34:	e8 97 d1 ff ff       	call   801000d0 <bread>
80102f39:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f3b:	58                   	pop    %eax
80102f3c:	5a                   	pop    %edx
80102f3d:	ff 34 bd ec 47 11 80 	pushl  -0x7feeb814(,%edi,4)
80102f44:	ff 35 e4 47 11 80    	pushl  0x801147e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f4a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f4d:	e8 7e d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f52:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f55:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f57:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f5a:	68 00 02 00 00       	push   $0x200
80102f5f:	50                   	push   %eax
80102f60:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102f63:	50                   	push   %eax
80102f64:	e8 37 29 00 00       	call   801058a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f69:	89 1c 24             	mov    %ebx,(%esp)
80102f6c:	e8 3f d2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102f71:	89 34 24             	mov    %esi,(%esp)
80102f74:	e8 77 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102f79:	89 1c 24             	mov    %ebx,(%esp)
80102f7c:	e8 6f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	39 3d e8 47 11 80    	cmp    %edi,0x801147e8
80102f8a:	7f 94                	jg     80102f20 <install_trans+0x20>
  }
}
80102f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5f                   	pop    %edi
80102f92:	5d                   	pop    %ebp
80102f93:	c3                   	ret    
80102f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f98:	c3                   	ret    
80102f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	53                   	push   %ebx
80102fa4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fa7:	ff 35 d4 47 11 80    	pushl  0x801147d4
80102fad:	ff 35 e4 47 11 80    	pushl  0x801147e4
80102fb3:	e8 18 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102fb8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fbb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102fbd:	a1 e8 47 11 80       	mov    0x801147e8,%eax
80102fc2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102fc5:	85 c0                	test   %eax,%eax
80102fc7:	7e 19                	jle    80102fe2 <write_head+0x42>
80102fc9:	31 d2                	xor    %edx,%edx
80102fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fcf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102fd0:	8b 0c 95 ec 47 11 80 	mov    -0x7feeb814(,%edx,4),%ecx
80102fd7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102fdb:	83 c2 01             	add    $0x1,%edx
80102fde:	39 d0                	cmp    %edx,%eax
80102fe0:	75 ee                	jne    80102fd0 <write_head+0x30>
  }
  bwrite(buf);
80102fe2:	83 ec 0c             	sub    $0xc,%esp
80102fe5:	53                   	push   %ebx
80102fe6:	e8 c5 d1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102feb:	89 1c 24             	mov    %ebx,(%esp)
80102fee:	e8 fd d1 ff ff       	call   801001f0 <brelse>
}
80102ff3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ff6:	83 c4 10             	add    $0x10,%esp
80102ff9:	c9                   	leave  
80102ffa:	c3                   	ret    
80102ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fff:	90                   	nop

80103000 <initlog>:
{
80103000:	f3 0f 1e fb          	endbr32 
80103004:	55                   	push   %ebp
80103005:	89 e5                	mov    %esp,%ebp
80103007:	53                   	push   %ebx
80103008:	83 ec 2c             	sub    $0x2c,%esp
8010300b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010300e:	68 a0 89 10 80       	push   $0x801089a0
80103013:	68 a0 47 11 80       	push   $0x801147a0
80103018:	e8 53 25 00 00       	call   80105570 <initlock>
  readsb(dev, &sb);
8010301d:	58                   	pop    %eax
8010301e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103021:	5a                   	pop    %edx
80103022:	50                   	push   %eax
80103023:	53                   	push   %ebx
80103024:	e8 47 e8 ff ff       	call   80101870 <readsb>
  log.start = sb.logstart;
80103029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010302c:	59                   	pop    %ecx
  log.dev = dev;
8010302d:	89 1d e4 47 11 80    	mov    %ebx,0x801147e4
  log.size = sb.nlog;
80103033:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103036:	a3 d4 47 11 80       	mov    %eax,0x801147d4
  log.size = sb.nlog;
8010303b:	89 15 d8 47 11 80    	mov    %edx,0x801147d8
  struct buf *buf = bread(log.dev, log.start);
80103041:	5a                   	pop    %edx
80103042:	50                   	push   %eax
80103043:	53                   	push   %ebx
80103044:	e8 87 d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103049:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010304c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010304f:	89 0d e8 47 11 80    	mov    %ecx,0x801147e8
  for (i = 0; i < log.lh.n; i++) {
80103055:	85 c9                	test   %ecx,%ecx
80103057:	7e 19                	jle    80103072 <initlog+0x72>
80103059:	31 d2                	xor    %edx,%edx
8010305b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010305f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103060:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103064:	89 1c 95 ec 47 11 80 	mov    %ebx,-0x7feeb814(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010306b:	83 c2 01             	add    $0x1,%edx
8010306e:	39 d1                	cmp    %edx,%ecx
80103070:	75 ee                	jne    80103060 <initlog+0x60>
  brelse(buf);
80103072:	83 ec 0c             	sub    $0xc,%esp
80103075:	50                   	push   %eax
80103076:	e8 75 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010307b:	e8 80 fe ff ff       	call   80102f00 <install_trans>
  log.lh.n = 0;
80103080:	c7 05 e8 47 11 80 00 	movl   $0x0,0x801147e8
80103087:	00 00 00 
  write_head(); // clear the log
8010308a:	e8 11 ff ff ff       	call   80102fa0 <write_head>
}
8010308f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103092:	83 c4 10             	add    $0x10,%esp
80103095:	c9                   	leave  
80103096:	c3                   	ret    
80103097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010309e:	66 90                	xchg   %ax,%ax

801030a0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801030a0:	f3 0f 1e fb          	endbr32 
801030a4:	55                   	push   %ebp
801030a5:	89 e5                	mov    %esp,%ebp
801030a7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801030aa:	68 a0 47 11 80       	push   $0x801147a0
801030af:	e8 3c 26 00 00       	call   801056f0 <acquire>
801030b4:	83 c4 10             	add    $0x10,%esp
801030b7:	eb 1c                	jmp    801030d5 <begin_op+0x35>
801030b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801030c0:	83 ec 08             	sub    $0x8,%esp
801030c3:	68 a0 47 11 80       	push   $0x801147a0
801030c8:	68 a0 47 11 80       	push   $0x801147a0
801030cd:	e8 be 1f 00 00       	call   80105090 <sleep>
801030d2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801030d5:	a1 e0 47 11 80       	mov    0x801147e0,%eax
801030da:	85 c0                	test   %eax,%eax
801030dc:	75 e2                	jne    801030c0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801030de:	a1 dc 47 11 80       	mov    0x801147dc,%eax
801030e3:	8b 15 e8 47 11 80    	mov    0x801147e8,%edx
801030e9:	83 c0 01             	add    $0x1,%eax
801030ec:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030ef:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801030f2:	83 fa 1e             	cmp    $0x1e,%edx
801030f5:	7f c9                	jg     801030c0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801030f7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801030fa:	a3 dc 47 11 80       	mov    %eax,0x801147dc
      release(&log.lock);
801030ff:	68 a0 47 11 80       	push   $0x801147a0
80103104:	e8 a7 26 00 00       	call   801057b0 <release>
      break;
    }
  }
}
80103109:	83 c4 10             	add    $0x10,%esp
8010310c:	c9                   	leave  
8010310d:	c3                   	ret    
8010310e:	66 90                	xchg   %ax,%ax

80103110 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103110:	f3 0f 1e fb          	endbr32 
80103114:	55                   	push   %ebp
80103115:	89 e5                	mov    %esp,%ebp
80103117:	57                   	push   %edi
80103118:	56                   	push   %esi
80103119:	53                   	push   %ebx
8010311a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010311d:	68 a0 47 11 80       	push   $0x801147a0
80103122:	e8 c9 25 00 00       	call   801056f0 <acquire>
  log.outstanding -= 1;
80103127:	a1 dc 47 11 80       	mov    0x801147dc,%eax
  if(log.committing)
8010312c:	8b 35 e0 47 11 80    	mov    0x801147e0,%esi
80103132:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103135:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103138:	89 1d dc 47 11 80    	mov    %ebx,0x801147dc
  if(log.committing)
8010313e:	85 f6                	test   %esi,%esi
80103140:	0f 85 1e 01 00 00    	jne    80103264 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103146:	85 db                	test   %ebx,%ebx
80103148:	0f 85 f2 00 00 00    	jne    80103240 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010314e:	c7 05 e0 47 11 80 01 	movl   $0x1,0x801147e0
80103155:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103158:	83 ec 0c             	sub    $0xc,%esp
8010315b:	68 a0 47 11 80       	push   $0x801147a0
80103160:	e8 4b 26 00 00       	call   801057b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103165:	8b 0d e8 47 11 80    	mov    0x801147e8,%ecx
8010316b:	83 c4 10             	add    $0x10,%esp
8010316e:	85 c9                	test   %ecx,%ecx
80103170:	7f 3e                	jg     801031b0 <end_op+0xa0>
    acquire(&log.lock);
80103172:	83 ec 0c             	sub    $0xc,%esp
80103175:	68 a0 47 11 80       	push   $0x801147a0
8010317a:	e8 71 25 00 00       	call   801056f0 <acquire>
    wakeup(&log);
8010317f:	c7 04 24 a0 47 11 80 	movl   $0x801147a0,(%esp)
    log.committing = 0;
80103186:	c7 05 e0 47 11 80 00 	movl   $0x0,0x801147e0
8010318d:	00 00 00 
    wakeup(&log);
80103190:	e8 bb 20 00 00       	call   80105250 <wakeup>
    release(&log.lock);
80103195:	c7 04 24 a0 47 11 80 	movl   $0x801147a0,(%esp)
8010319c:	e8 0f 26 00 00       	call   801057b0 <release>
801031a1:	83 c4 10             	add    $0x10,%esp
}
801031a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031a7:	5b                   	pop    %ebx
801031a8:	5e                   	pop    %esi
801031a9:	5f                   	pop    %edi
801031aa:	5d                   	pop    %ebp
801031ab:	c3                   	ret    
801031ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801031b0:	a1 d4 47 11 80       	mov    0x801147d4,%eax
801031b5:	83 ec 08             	sub    $0x8,%esp
801031b8:	01 d8                	add    %ebx,%eax
801031ba:	83 c0 01             	add    $0x1,%eax
801031bd:	50                   	push   %eax
801031be:	ff 35 e4 47 11 80    	pushl  0x801147e4
801031c4:	e8 07 cf ff ff       	call   801000d0 <bread>
801031c9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031cb:	58                   	pop    %eax
801031cc:	5a                   	pop    %edx
801031cd:	ff 34 9d ec 47 11 80 	pushl  -0x7feeb814(,%ebx,4)
801031d4:	ff 35 e4 47 11 80    	pushl  0x801147e4
  for (tail = 0; tail < log.lh.n; tail++) {
801031da:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031dd:	e8 ee ce ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801031e2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031e5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801031e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801031ea:	68 00 02 00 00       	push   $0x200
801031ef:	50                   	push   %eax
801031f0:	8d 46 5c             	lea    0x5c(%esi),%eax
801031f3:	50                   	push   %eax
801031f4:	e8 a7 26 00 00       	call   801058a0 <memmove>
    bwrite(to);  // write the log
801031f9:	89 34 24             	mov    %esi,(%esp)
801031fc:	e8 af cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103201:	89 3c 24             	mov    %edi,(%esp)
80103204:	e8 e7 cf ff ff       	call   801001f0 <brelse>
    brelse(to);
80103209:	89 34 24             	mov    %esi,(%esp)
8010320c:	e8 df cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103211:	83 c4 10             	add    $0x10,%esp
80103214:	3b 1d e8 47 11 80    	cmp    0x801147e8,%ebx
8010321a:	7c 94                	jl     801031b0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010321c:	e8 7f fd ff ff       	call   80102fa0 <write_head>
    install_trans(); // Now install writes to home locations
80103221:	e8 da fc ff ff       	call   80102f00 <install_trans>
    log.lh.n = 0;
80103226:	c7 05 e8 47 11 80 00 	movl   $0x0,0x801147e8
8010322d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103230:	e8 6b fd ff ff       	call   80102fa0 <write_head>
80103235:	e9 38 ff ff ff       	jmp    80103172 <end_op+0x62>
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103240:	83 ec 0c             	sub    $0xc,%esp
80103243:	68 a0 47 11 80       	push   $0x801147a0
80103248:	e8 03 20 00 00       	call   80105250 <wakeup>
  release(&log.lock);
8010324d:	c7 04 24 a0 47 11 80 	movl   $0x801147a0,(%esp)
80103254:	e8 57 25 00 00       	call   801057b0 <release>
80103259:	83 c4 10             	add    $0x10,%esp
}
8010325c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325f:	5b                   	pop    %ebx
80103260:	5e                   	pop    %esi
80103261:	5f                   	pop    %edi
80103262:	5d                   	pop    %ebp
80103263:	c3                   	ret    
    panic("log.committing");
80103264:	83 ec 0c             	sub    $0xc,%esp
80103267:	68 a4 89 10 80       	push   $0x801089a4
8010326c:	e8 1f d1 ff ff       	call   80100390 <panic>
80103271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010327f:	90                   	nop

80103280 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103280:	f3 0f 1e fb          	endbr32 
80103284:	55                   	push   %ebp
80103285:	89 e5                	mov    %esp,%ebp
80103287:	53                   	push   %ebx
80103288:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010328b:	8b 15 e8 47 11 80    	mov    0x801147e8,%edx
{
80103291:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103294:	83 fa 1d             	cmp    $0x1d,%edx
80103297:	0f 8f 91 00 00 00    	jg     8010332e <log_write+0xae>
8010329d:	a1 d8 47 11 80       	mov    0x801147d8,%eax
801032a2:	83 e8 01             	sub    $0x1,%eax
801032a5:	39 c2                	cmp    %eax,%edx
801032a7:	0f 8d 81 00 00 00    	jge    8010332e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801032ad:	a1 dc 47 11 80       	mov    0x801147dc,%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	0f 8e 81 00 00 00    	jle    8010333b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	68 a0 47 11 80       	push   $0x801147a0
801032c2:	e8 29 24 00 00       	call   801056f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801032c7:	8b 15 e8 47 11 80    	mov    0x801147e8,%edx
801032cd:	83 c4 10             	add    $0x10,%esp
801032d0:	85 d2                	test   %edx,%edx
801032d2:	7e 4e                	jle    80103322 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032d4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801032d7:	31 c0                	xor    %eax,%eax
801032d9:	eb 0c                	jmp    801032e7 <log_write+0x67>
801032db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032df:	90                   	nop
801032e0:	83 c0 01             	add    $0x1,%eax
801032e3:	39 c2                	cmp    %eax,%edx
801032e5:	74 29                	je     80103310 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032e7:	39 0c 85 ec 47 11 80 	cmp    %ecx,-0x7feeb814(,%eax,4)
801032ee:	75 f0                	jne    801032e0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801032f0:	89 0c 85 ec 47 11 80 	mov    %ecx,-0x7feeb814(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801032f7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801032fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801032fd:	c7 45 08 a0 47 11 80 	movl   $0x801147a0,0x8(%ebp)
}
80103304:	c9                   	leave  
  release(&log.lock);
80103305:	e9 a6 24 00 00       	jmp    801057b0 <release>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103310:	89 0c 95 ec 47 11 80 	mov    %ecx,-0x7feeb814(,%edx,4)
    log.lh.n++;
80103317:	83 c2 01             	add    $0x1,%edx
8010331a:	89 15 e8 47 11 80    	mov    %edx,0x801147e8
80103320:	eb d5                	jmp    801032f7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103322:	8b 43 08             	mov    0x8(%ebx),%eax
80103325:	a3 ec 47 11 80       	mov    %eax,0x801147ec
  if (i == log.lh.n)
8010332a:	75 cb                	jne    801032f7 <log_write+0x77>
8010332c:	eb e9                	jmp    80103317 <log_write+0x97>
    panic("too big a transaction");
8010332e:	83 ec 0c             	sub    $0xc,%esp
80103331:	68 b3 89 10 80       	push   $0x801089b3
80103336:	e8 55 d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010333b:	83 ec 0c             	sub    $0xc,%esp
8010333e:	68 c9 89 10 80       	push   $0x801089c9
80103343:	e8 48 d0 ff ff       	call   80100390 <panic>
80103348:	66 90                	xchg   %ax,%ax
8010334a:	66 90                	xchg   %ax,%ax
8010334c:	66 90                	xchg   %ax,%ax
8010334e:	66 90                	xchg   %ax,%ax

80103350 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	53                   	push   %ebx
80103354:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103357:	e8 f4 09 00 00       	call   80103d50 <cpuid>
8010335c:	89 c3                	mov    %eax,%ebx
8010335e:	e8 ed 09 00 00       	call   80103d50 <cpuid>
80103363:	83 ec 04             	sub    $0x4,%esp
80103366:	53                   	push   %ebx
80103367:	50                   	push   %eax
80103368:	68 e4 89 10 80       	push   $0x801089e4
8010336d:	e8 3e d3 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103372:	e8 59 39 00 00       	call   80106cd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103377:	e8 64 09 00 00       	call   80103ce0 <mycpu>
8010337c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010337e:	b8 01 00 00 00       	mov    $0x1,%eax
80103383:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010338a:	e8 b1 16 00 00       	call   80104a40 <scheduler>
8010338f:	90                   	nop

80103390 <mpenter>:
{
80103390:	f3 0f 1e fb          	endbr32 
80103394:	55                   	push   %ebp
80103395:	89 e5                	mov    %esp,%ebp
80103397:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010339a:	e8 01 4a 00 00       	call   80107da0 <switchkvm>
  seginit();
8010339f:	e8 6c 49 00 00       	call   80107d10 <seginit>
  lapicinit();
801033a4:	e8 67 f7 ff ff       	call   80102b10 <lapicinit>
  mpmain();
801033a9:	e8 a2 ff ff ff       	call   80103350 <mpmain>
801033ae:	66 90                	xchg   %ax,%ax

801033b0 <main>:
{
801033b0:	f3 0f 1e fb          	endbr32 
801033b4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801033b8:	83 e4 f0             	and    $0xfffffff0,%esp
801033bb:	ff 71 fc             	pushl  -0x4(%ecx)
801033be:	55                   	push   %ebp
801033bf:	89 e5                	mov    %esp,%ebp
801033c1:	53                   	push   %ebx
801033c2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033c3:	83 ec 08             	sub    $0x8,%esp
801033c6:	68 00 00 40 80       	push   $0x80400000
801033cb:	68 c8 9f 11 80       	push   $0x80119fc8
801033d0:	e8 fb f4 ff ff       	call   801028d0 <kinit1>
  kvmalloc();      // kernel page table
801033d5:	e8 a6 4e 00 00       	call   80108280 <kvmalloc>
  mpinit();        // detect other processors
801033da:	e8 81 01 00 00       	call   80103560 <mpinit>
  lapicinit();     // interrupt controller
801033df:	e8 2c f7 ff ff       	call   80102b10 <lapicinit>
  seginit();       // segment descriptors
801033e4:	e8 27 49 00 00       	call   80107d10 <seginit>
  picinit();       // disable pic
801033e9:	e8 52 03 00 00       	call   80103740 <picinit>
  ioapicinit();    // another interrupt controller
801033ee:	e8 fd f2 ff ff       	call   801026f0 <ioapicinit>
  consoleinit();   // console hardware
801033f3:	e8 98 d9 ff ff       	call   80100d90 <consoleinit>
  uartinit();      // serial port
801033f8:	e8 d3 3b 00 00       	call   80106fd0 <uartinit>
  pinit();         // process table
801033fd:	e8 9e 08 00 00       	call   80103ca0 <pinit>
  tvinit();        // trap vectors
80103402:	e8 49 38 00 00       	call   80106c50 <tvinit>
  binit();         // buffer cache
80103407:	e8 34 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010340c:	e8 3f dd ff ff       	call   80101150 <fileinit>
  ideinit();       // disk 
80103411:	e8 aa f0 ff ff       	call   801024c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103416:	83 c4 0c             	add    $0xc,%esp
80103419:	68 8a 00 00 00       	push   $0x8a
8010341e:	68 0c c5 10 80       	push   $0x8010c50c
80103423:	68 00 70 00 80       	push   $0x80007000
80103428:	e8 73 24 00 00       	call   801058a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010342d:	83 c4 10             	add    $0x10,%esp
80103430:	69 05 20 4e 11 80 b0 	imul   $0xb0,0x80114e20,%eax
80103437:	00 00 00 
8010343a:	05 a0 48 11 80       	add    $0x801148a0,%eax
8010343f:	3d a0 48 11 80       	cmp    $0x801148a0,%eax
80103444:	76 7a                	jbe    801034c0 <main+0x110>
80103446:	bb a0 48 11 80       	mov    $0x801148a0,%ebx
8010344b:	eb 1c                	jmp    80103469 <main+0xb9>
8010344d:	8d 76 00             	lea    0x0(%esi),%esi
80103450:	69 05 20 4e 11 80 b0 	imul   $0xb0,0x80114e20,%eax
80103457:	00 00 00 
8010345a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103460:	05 a0 48 11 80       	add    $0x801148a0,%eax
80103465:	39 c3                	cmp    %eax,%ebx
80103467:	73 57                	jae    801034c0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103469:	e8 72 08 00 00       	call   80103ce0 <mycpu>
8010346e:	39 c3                	cmp    %eax,%ebx
80103470:	74 de                	je     80103450 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103472:	e8 29 f5 ff ff       	call   801029a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103477:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010347a:	c7 05 f8 6f 00 80 90 	movl   $0x80103390,0x80006ff8
80103481:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103484:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010348b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010348e:	05 00 10 00 00       	add    $0x1000,%eax
80103493:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103498:	0f b6 03             	movzbl (%ebx),%eax
8010349b:	68 00 70 00 00       	push   $0x7000
801034a0:	50                   	push   %eax
801034a1:	e8 ba f7 ff ff       	call   80102c60 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801034a6:	83 c4 10             	add    $0x10,%esp
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801034b6:	85 c0                	test   %eax,%eax
801034b8:	74 f6                	je     801034b0 <main+0x100>
801034ba:	eb 94                	jmp    80103450 <main+0xa0>
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034c0:	83 ec 08             	sub    $0x8,%esp
801034c3:	68 00 00 00 8e       	push   $0x8e000000
801034c8:	68 00 00 40 80       	push   $0x80400000
801034cd:	e8 6e f4 ff ff       	call   80102940 <kinit2>
  userinit();      // first user process
801034d2:	e8 f9 08 00 00       	call   80103dd0 <userinit>
  mpmain();        // finish this processor's setup
801034d7:	e8 74 fe ff ff       	call   80103350 <mpmain>
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	57                   	push   %edi
801034e4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801034e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801034eb:	53                   	push   %ebx
  e = addr+len;
801034ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801034ef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801034f2:	39 de                	cmp    %ebx,%esi
801034f4:	72 10                	jb     80103506 <mpsearch1+0x26>
801034f6:	eb 50                	jmp    80103548 <mpsearch1+0x68>
801034f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop
80103500:	89 fe                	mov    %edi,%esi
80103502:	39 fb                	cmp    %edi,%ebx
80103504:	76 42                	jbe    80103548 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103506:	83 ec 04             	sub    $0x4,%esp
80103509:	8d 7e 10             	lea    0x10(%esi),%edi
8010350c:	6a 04                	push   $0x4
8010350e:	68 f8 89 10 80       	push   $0x801089f8
80103513:	56                   	push   %esi
80103514:	e8 37 23 00 00       	call   80105850 <memcmp>
80103519:	83 c4 10             	add    $0x10,%esp
8010351c:	85 c0                	test   %eax,%eax
8010351e:	75 e0                	jne    80103500 <mpsearch1+0x20>
80103520:	89 f2                	mov    %esi,%edx
80103522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103528:	0f b6 0a             	movzbl (%edx),%ecx
8010352b:	83 c2 01             	add    $0x1,%edx
8010352e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103530:	39 fa                	cmp    %edi,%edx
80103532:	75 f4                	jne    80103528 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103534:	84 c0                	test   %al,%al
80103536:	75 c8                	jne    80103500 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103538:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010353b:	89 f0                	mov    %esi,%eax
8010353d:	5b                   	pop    %ebx
8010353e:	5e                   	pop    %esi
8010353f:	5f                   	pop    %edi
80103540:	5d                   	pop    %ebp
80103541:	c3                   	ret    
80103542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103548:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010354b:	31 f6                	xor    %esi,%esi
}
8010354d:	5b                   	pop    %ebx
8010354e:	89 f0                	mov    %esi,%eax
80103550:	5e                   	pop    %esi
80103551:	5f                   	pop    %edi
80103552:	5d                   	pop    %ebp
80103553:	c3                   	ret    
80103554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010355f:	90                   	nop

80103560 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103560:	f3 0f 1e fb          	endbr32 
80103564:	55                   	push   %ebp
80103565:	89 e5                	mov    %esp,%ebp
80103567:	57                   	push   %edi
80103568:	56                   	push   %esi
80103569:	53                   	push   %ebx
8010356a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010356d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103574:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010357b:	c1 e0 08             	shl    $0x8,%eax
8010357e:	09 d0                	or     %edx,%eax
80103580:	c1 e0 04             	shl    $0x4,%eax
80103583:	75 1b                	jne    801035a0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103585:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010358c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103593:	c1 e0 08             	shl    $0x8,%eax
80103596:	09 d0                	or     %edx,%eax
80103598:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010359b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801035a0:	ba 00 04 00 00       	mov    $0x400,%edx
801035a5:	e8 36 ff ff ff       	call   801034e0 <mpsearch1>
801035aa:	89 c6                	mov    %eax,%esi
801035ac:	85 c0                	test   %eax,%eax
801035ae:	0f 84 4c 01 00 00    	je     80103700 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035b4:	8b 5e 04             	mov    0x4(%esi),%ebx
801035b7:	85 db                	test   %ebx,%ebx
801035b9:	0f 84 61 01 00 00    	je     80103720 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801035bf:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035c2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801035c8:	6a 04                	push   $0x4
801035ca:	68 fd 89 10 80       	push   $0x801089fd
801035cf:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801035d3:	e8 78 22 00 00       	call   80105850 <memcmp>
801035d8:	83 c4 10             	add    $0x10,%esp
801035db:	85 c0                	test   %eax,%eax
801035dd:	0f 85 3d 01 00 00    	jne    80103720 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801035e3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801035ea:	3c 01                	cmp    $0x1,%al
801035ec:	74 08                	je     801035f6 <mpinit+0x96>
801035ee:	3c 04                	cmp    $0x4,%al
801035f0:	0f 85 2a 01 00 00    	jne    80103720 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801035f6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801035fd:	66 85 d2             	test   %dx,%dx
80103600:	74 26                	je     80103628 <mpinit+0xc8>
80103602:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103605:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103607:	31 d2                	xor    %edx,%edx
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103610:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103617:	83 c0 01             	add    $0x1,%eax
8010361a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010361c:	39 f8                	cmp    %edi,%eax
8010361e:	75 f0                	jne    80103610 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103620:	84 d2                	test   %dl,%dl
80103622:	0f 85 f8 00 00 00    	jne    80103720 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103628:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010362e:	a3 9c 47 11 80       	mov    %eax,0x8011479c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103633:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103639:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103640:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103645:	03 55 e4             	add    -0x1c(%ebp),%edx
80103648:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010364b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010364f:	90                   	nop
80103650:	39 c2                	cmp    %eax,%edx
80103652:	76 15                	jbe    80103669 <mpinit+0x109>
    switch(*p){
80103654:	0f b6 08             	movzbl (%eax),%ecx
80103657:	80 f9 02             	cmp    $0x2,%cl
8010365a:	74 5c                	je     801036b8 <mpinit+0x158>
8010365c:	77 42                	ja     801036a0 <mpinit+0x140>
8010365e:	84 c9                	test   %cl,%cl
80103660:	74 6e                	je     801036d0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103662:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103665:	39 c2                	cmp    %eax,%edx
80103667:	77 eb                	ja     80103654 <mpinit+0xf4>
80103669:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010366c:	85 db                	test   %ebx,%ebx
8010366e:	0f 84 b9 00 00 00    	je     8010372d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103674:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103678:	74 15                	je     8010368f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010367a:	b8 70 00 00 00       	mov    $0x70,%eax
8010367f:	ba 22 00 00 00       	mov    $0x22,%edx
80103684:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103685:	ba 23 00 00 00       	mov    $0x23,%edx
8010368a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010368b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010368e:	ee                   	out    %al,(%dx)
  }
}
8010368f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103692:	5b                   	pop    %ebx
80103693:	5e                   	pop    %esi
80103694:	5f                   	pop    %edi
80103695:	5d                   	pop    %ebp
80103696:	c3                   	ret    
80103697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010369e:	66 90                	xchg   %ax,%ax
    switch(*p){
801036a0:	83 e9 03             	sub    $0x3,%ecx
801036a3:	80 f9 01             	cmp    $0x1,%cl
801036a6:	76 ba                	jbe    80103662 <mpinit+0x102>
801036a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801036af:	eb 9f                	jmp    80103650 <mpinit+0xf0>
801036b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801036b8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801036bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801036bf:	88 0d 80 48 11 80    	mov    %cl,0x80114880
      continue;
801036c5:	eb 89                	jmp    80103650 <mpinit+0xf0>
801036c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ce:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801036d0:	8b 0d 20 4e 11 80    	mov    0x80114e20,%ecx
801036d6:	83 f9 07             	cmp    $0x7,%ecx
801036d9:	7f 19                	jg     801036f4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036db:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801036e1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801036e5:	83 c1 01             	add    $0x1,%ecx
801036e8:	89 0d 20 4e 11 80    	mov    %ecx,0x80114e20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036ee:	88 9f a0 48 11 80    	mov    %bl,-0x7feeb760(%edi)
      p += sizeof(struct mpproc);
801036f4:	83 c0 14             	add    $0x14,%eax
      continue;
801036f7:	e9 54 ff ff ff       	jmp    80103650 <mpinit+0xf0>
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103700:	ba 00 00 01 00       	mov    $0x10000,%edx
80103705:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010370a:	e8 d1 fd ff ff       	call   801034e0 <mpsearch1>
8010370f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103711:	85 c0                	test   %eax,%eax
80103713:	0f 85 9b fe ff ff    	jne    801035b4 <mpinit+0x54>
80103719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	68 02 8a 10 80       	push   $0x80108a02
80103728:	e8 63 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010372d:	83 ec 0c             	sub    $0xc,%esp
80103730:	68 1c 8a 10 80       	push   $0x80108a1c
80103735:	e8 56 cc ff ff       	call   80100390 <panic>
8010373a:	66 90                	xchg   %ax,%ax
8010373c:	66 90                	xchg   %ax,%ax
8010373e:	66 90                	xchg   %ax,%ax

80103740 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103740:	f3 0f 1e fb          	endbr32 
80103744:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103749:	ba 21 00 00 00       	mov    $0x21,%edx
8010374e:	ee                   	out    %al,(%dx)
8010374f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103754:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103755:	c3                   	ret    
80103756:	66 90                	xchg   %ax,%ax
80103758:	66 90                	xchg   %ax,%ax
8010375a:	66 90                	xchg   %ax,%ax
8010375c:	66 90                	xchg   %ax,%ax
8010375e:	66 90                	xchg   %ax,%ax

80103760 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103760:	f3 0f 1e fb          	endbr32 
80103764:	55                   	push   %ebp
80103765:	89 e5                	mov    %esp,%ebp
80103767:	57                   	push   %edi
80103768:	56                   	push   %esi
80103769:	53                   	push   %ebx
8010376a:	83 ec 0c             	sub    $0xc,%esp
8010376d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103770:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103773:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103779:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010377f:	e8 ec d9 ff ff       	call   80101170 <filealloc>
80103784:	89 03                	mov    %eax,(%ebx)
80103786:	85 c0                	test   %eax,%eax
80103788:	0f 84 ac 00 00 00    	je     8010383a <pipealloc+0xda>
8010378e:	e8 dd d9 ff ff       	call   80101170 <filealloc>
80103793:	89 06                	mov    %eax,(%esi)
80103795:	85 c0                	test   %eax,%eax
80103797:	0f 84 8b 00 00 00    	je     80103828 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010379d:	e8 fe f1 ff ff       	call   801029a0 <kalloc>
801037a2:	89 c7                	mov    %eax,%edi
801037a4:	85 c0                	test   %eax,%eax
801037a6:	0f 84 b4 00 00 00    	je     80103860 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
801037ac:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801037b3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801037b6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801037b9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037c0:	00 00 00 
  p->nwrite = 0;
801037c3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037ca:	00 00 00 
  p->nread = 0;
801037cd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037d4:	00 00 00 
  initlock(&p->lock, "pipe");
801037d7:	68 3b 8a 10 80       	push   $0x80108a3b
801037dc:	50                   	push   %eax
801037dd:	e8 8e 1d 00 00       	call   80105570 <initlock>
  (*f0)->type = FD_PIPE;
801037e2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801037e4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037e7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037ed:	8b 03                	mov    (%ebx),%eax
801037ef:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801037f3:	8b 03                	mov    (%ebx),%eax
801037f5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801037f9:	8b 03                	mov    (%ebx),%eax
801037fb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801037fe:	8b 06                	mov    (%esi),%eax
80103800:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103806:	8b 06                	mov    (%esi),%eax
80103808:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010380c:	8b 06                	mov    (%esi),%eax
8010380e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103812:	8b 06                	mov    (%esi),%eax
80103814:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103817:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010381a:	31 c0                	xor    %eax,%eax
}
8010381c:	5b                   	pop    %ebx
8010381d:	5e                   	pop    %esi
8010381e:	5f                   	pop    %edi
8010381f:	5d                   	pop    %ebp
80103820:	c3                   	ret    
80103821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103828:	8b 03                	mov    (%ebx),%eax
8010382a:	85 c0                	test   %eax,%eax
8010382c:	74 1e                	je     8010384c <pipealloc+0xec>
    fileclose(*f0);
8010382e:	83 ec 0c             	sub    $0xc,%esp
80103831:	50                   	push   %eax
80103832:	e8 f9 d9 ff ff       	call   80101230 <fileclose>
80103837:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010383a:	8b 06                	mov    (%esi),%eax
8010383c:	85 c0                	test   %eax,%eax
8010383e:	74 0c                	je     8010384c <pipealloc+0xec>
    fileclose(*f1);
80103840:	83 ec 0c             	sub    $0xc,%esp
80103843:	50                   	push   %eax
80103844:	e8 e7 d9 ff ff       	call   80101230 <fileclose>
80103849:	83 c4 10             	add    $0x10,%esp
}
8010384c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010384f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103854:	5b                   	pop    %ebx
80103855:	5e                   	pop    %esi
80103856:	5f                   	pop    %edi
80103857:	5d                   	pop    %ebp
80103858:	c3                   	ret    
80103859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103860:	8b 03                	mov    (%ebx),%eax
80103862:	85 c0                	test   %eax,%eax
80103864:	75 c8                	jne    8010382e <pipealloc+0xce>
80103866:	eb d2                	jmp    8010383a <pipealloc+0xda>
80103868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010386f:	90                   	nop

80103870 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103870:	f3 0f 1e fb          	endbr32 
80103874:	55                   	push   %ebp
80103875:	89 e5                	mov    %esp,%ebp
80103877:	56                   	push   %esi
80103878:	53                   	push   %ebx
80103879:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010387c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010387f:	83 ec 0c             	sub    $0xc,%esp
80103882:	53                   	push   %ebx
80103883:	e8 68 1e 00 00       	call   801056f0 <acquire>
  if(writable){
80103888:	83 c4 10             	add    $0x10,%esp
8010388b:	85 f6                	test   %esi,%esi
8010388d:	74 41                	je     801038d0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010388f:	83 ec 0c             	sub    $0xc,%esp
80103892:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103898:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010389f:	00 00 00 
    wakeup(&p->nread);
801038a2:	50                   	push   %eax
801038a3:	e8 a8 19 00 00       	call   80105250 <wakeup>
801038a8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801038ab:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801038b1:	85 d2                	test   %edx,%edx
801038b3:	75 0a                	jne    801038bf <pipeclose+0x4f>
801038b5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801038bb:	85 c0                	test   %eax,%eax
801038bd:	74 31                	je     801038f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801038bf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801038c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c5:	5b                   	pop    %ebx
801038c6:	5e                   	pop    %esi
801038c7:	5d                   	pop    %ebp
    release(&p->lock);
801038c8:	e9 e3 1e 00 00       	jmp    801057b0 <release>
801038cd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801038d0:	83 ec 0c             	sub    $0xc,%esp
801038d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801038d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801038e0:	00 00 00 
    wakeup(&p->nwrite);
801038e3:	50                   	push   %eax
801038e4:	e8 67 19 00 00       	call   80105250 <wakeup>
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	eb bd                	jmp    801038ab <pipeclose+0x3b>
801038ee:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801038f0:	83 ec 0c             	sub    $0xc,%esp
801038f3:	53                   	push   %ebx
801038f4:	e8 b7 1e 00 00       	call   801057b0 <release>
    kfree((char*)p);
801038f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801038fc:	83 c4 10             	add    $0x10,%esp
}
801038ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103902:	5b                   	pop    %ebx
80103903:	5e                   	pop    %esi
80103904:	5d                   	pop    %ebp
    kfree((char*)p);
80103905:	e9 d6 ee ff ff       	jmp    801027e0 <kfree>
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103910 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103910:	f3 0f 1e fb          	endbr32 
80103914:	55                   	push   %ebp
80103915:	89 e5                	mov    %esp,%ebp
80103917:	57                   	push   %edi
80103918:	56                   	push   %esi
80103919:	53                   	push   %ebx
8010391a:	83 ec 28             	sub    $0x28,%esp
8010391d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103920:	53                   	push   %ebx
80103921:	e8 ca 1d 00 00       	call   801056f0 <acquire>
  for(i = 0; i < n; i++){
80103926:	8b 45 10             	mov    0x10(%ebp),%eax
80103929:	83 c4 10             	add    $0x10,%esp
8010392c:	85 c0                	test   %eax,%eax
8010392e:	0f 8e bc 00 00 00    	jle    801039f0 <pipewrite+0xe0>
80103934:	8b 45 0c             	mov    0xc(%ebp),%eax
80103937:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010393d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103943:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103946:	03 45 10             	add    0x10(%ebp),%eax
80103949:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010394c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103952:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103958:	89 ca                	mov    %ecx,%edx
8010395a:	05 00 02 00 00       	add    $0x200,%eax
8010395f:	39 c1                	cmp    %eax,%ecx
80103961:	74 3b                	je     8010399e <pipewrite+0x8e>
80103963:	eb 63                	jmp    801039c8 <pipewrite+0xb8>
80103965:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103968:	e8 33 04 00 00       	call   80103da0 <myproc>
8010396d:	8b 48 24             	mov    0x24(%eax),%ecx
80103970:	85 c9                	test   %ecx,%ecx
80103972:	75 34                	jne    801039a8 <pipewrite+0x98>
      wakeup(&p->nread);
80103974:	83 ec 0c             	sub    $0xc,%esp
80103977:	57                   	push   %edi
80103978:	e8 d3 18 00 00       	call   80105250 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010397d:	58                   	pop    %eax
8010397e:	5a                   	pop    %edx
8010397f:	53                   	push   %ebx
80103980:	56                   	push   %esi
80103981:	e8 0a 17 00 00       	call   80105090 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103986:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010398c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103992:	83 c4 10             	add    $0x10,%esp
80103995:	05 00 02 00 00       	add    $0x200,%eax
8010399a:	39 c2                	cmp    %eax,%edx
8010399c:	75 2a                	jne    801039c8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010399e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801039a4:	85 c0                	test   %eax,%eax
801039a6:	75 c0                	jne    80103968 <pipewrite+0x58>
        release(&p->lock);
801039a8:	83 ec 0c             	sub    $0xc,%esp
801039ab:	53                   	push   %ebx
801039ac:	e8 ff 1d 00 00       	call   801057b0 <release>
        return -1;
801039b1:	83 c4 10             	add    $0x10,%esp
801039b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801039b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039bc:	5b                   	pop    %ebx
801039bd:	5e                   	pop    %esi
801039be:	5f                   	pop    %edi
801039bf:	5d                   	pop    %ebp
801039c0:	c3                   	ret    
801039c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039c8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801039cb:	8d 4a 01             	lea    0x1(%edx),%ecx
801039ce:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801039d4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801039da:	0f b6 06             	movzbl (%esi),%eax
801039dd:	83 c6 01             	add    $0x1,%esi
801039e0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801039e3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801039e7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801039ea:	0f 85 5c ff ff ff    	jne    8010394c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801039f0:	83 ec 0c             	sub    $0xc,%esp
801039f3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039f9:	50                   	push   %eax
801039fa:	e8 51 18 00 00       	call   80105250 <wakeup>
  release(&p->lock);
801039ff:	89 1c 24             	mov    %ebx,(%esp)
80103a02:	e8 a9 1d 00 00       	call   801057b0 <release>
  return n;
80103a07:	8b 45 10             	mov    0x10(%ebp),%eax
80103a0a:	83 c4 10             	add    $0x10,%esp
80103a0d:	eb aa                	jmp    801039b9 <pipewrite+0xa9>
80103a0f:	90                   	nop

80103a10 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a10:	f3 0f 1e fb          	endbr32 
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	57                   	push   %edi
80103a18:	56                   	push   %esi
80103a19:	53                   	push   %ebx
80103a1a:	83 ec 18             	sub    $0x18,%esp
80103a1d:	8b 75 08             	mov    0x8(%ebp),%esi
80103a20:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a23:	56                   	push   %esi
80103a24:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a2a:	e8 c1 1c 00 00       	call   801056f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a2f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a35:	83 c4 10             	add    $0x10,%esp
80103a38:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103a3e:	74 33                	je     80103a73 <piperead+0x63>
80103a40:	eb 3b                	jmp    80103a7d <piperead+0x6d>
80103a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103a48:	e8 53 03 00 00       	call   80103da0 <myproc>
80103a4d:	8b 48 24             	mov    0x24(%eax),%ecx
80103a50:	85 c9                	test   %ecx,%ecx
80103a52:	0f 85 88 00 00 00    	jne    80103ae0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a58:	83 ec 08             	sub    $0x8,%esp
80103a5b:	56                   	push   %esi
80103a5c:	53                   	push   %ebx
80103a5d:	e8 2e 16 00 00       	call   80105090 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a62:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103a68:	83 c4 10             	add    $0x10,%esp
80103a6b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103a71:	75 0a                	jne    80103a7d <piperead+0x6d>
80103a73:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103a79:	85 c0                	test   %eax,%eax
80103a7b:	75 cb                	jne    80103a48 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a7d:	8b 55 10             	mov    0x10(%ebp),%edx
80103a80:	31 db                	xor    %ebx,%ebx
80103a82:	85 d2                	test   %edx,%edx
80103a84:	7f 28                	jg     80103aae <piperead+0x9e>
80103a86:	eb 34                	jmp    80103abc <piperead+0xac>
80103a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a90:	8d 48 01             	lea    0x1(%eax),%ecx
80103a93:	25 ff 01 00 00       	and    $0x1ff,%eax
80103a98:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103a9e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103aa3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103aa6:	83 c3 01             	add    $0x1,%ebx
80103aa9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103aac:	74 0e                	je     80103abc <piperead+0xac>
    if(p->nread == p->nwrite)
80103aae:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ab4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103aba:	75 d4                	jne    80103a90 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103abc:	83 ec 0c             	sub    $0xc,%esp
80103abf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103ac5:	50                   	push   %eax
80103ac6:	e8 85 17 00 00       	call   80105250 <wakeup>
  release(&p->lock);
80103acb:	89 34 24             	mov    %esi,(%esp)
80103ace:	e8 dd 1c 00 00       	call   801057b0 <release>
  return i;
80103ad3:	83 c4 10             	add    $0x10,%esp
}
80103ad6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ad9:	89 d8                	mov    %ebx,%eax
80103adb:	5b                   	pop    %ebx
80103adc:	5e                   	pop    %esi
80103add:	5f                   	pop    %edi
80103ade:	5d                   	pop    %ebp
80103adf:	c3                   	ret    
      release(&p->lock);
80103ae0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ae3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103ae8:	56                   	push   %esi
80103ae9:	e8 c2 1c 00 00       	call   801057b0 <release>
      return -1;
80103aee:	83 c4 10             	add    $0x10,%esp
}
80103af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103af4:	89 d8                	mov    %ebx,%eax
80103af6:	5b                   	pop    %ebx
80103af7:	5e                   	pop    %esi
80103af8:	5f                   	pop    %edi
80103af9:	5d                   	pop    %ebp
80103afa:	c3                   	ret    
80103afb:	66 90                	xchg   %ax,%ax
80103afd:	66 90                	xchg   %ax,%ax
80103aff:	90                   	nop

80103b00 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b05:	bb 74 4e 11 80       	mov    $0x80114e74,%ebx
  acquire(&ptable.lock);
80103b0a:	83 ec 0c             	sub    $0xc,%esp
80103b0d:	68 40 4e 11 80       	push   $0x80114e40
80103b12:	e8 d9 1b 00 00       	call   801056f0 <acquire>
80103b17:	83 c4 10             	add    $0x10,%esp
80103b1a:	eb 16                	jmp    80103b32 <allocproc+0x32>
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b20:	81 c3 24 01 00 00    	add    $0x124,%ebx
80103b26:	81 fb 74 97 11 80    	cmp    $0x80119774,%ebx
80103b2c:	0f 84 ee 00 00 00    	je     80103c20 <allocproc+0x120>
    if(p->state == UNUSED)
80103b32:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b35:	85 c0                	test   %eax,%eax
80103b37:	75 e7                	jne    80103b20 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b39:	a1 94 c0 10 80       	mov    0x8010c094,%eax
  acquire(&tickslock);
80103b3e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b41:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->q_level = 2;
80103b48:	c7 83 f0 00 00 00 02 	movl   $0x2,0xf0(%ebx)
80103b4f:	00 00 00 
  p->pid = nextpid++;
80103b52:	89 43 10             	mov    %eax,0x10(%ebx)
80103b55:	8d 50 01             	lea    0x1(%eax),%edx
  p->num_tickets = 10;
80103b58:	c7 83 f4 00 00 00 0a 	movl   $0xa,0xf4(%ebx)
80103b5f:	00 00 00 
  p->age = 0;
80103b62:	c7 83 f8 00 00 00 00 	movl   $0x0,0xf8(%ebx)
80103b69:	00 00 00 
  acquire(&tickslock);
80103b6c:	68 80 97 11 80       	push   $0x80119780
  p->pid = nextpid++;
80103b71:	89 15 94 c0 10 80    	mov    %edx,0x8010c094
  acquire(&tickslock);
80103b77:	e8 74 1b 00 00       	call   801056f0 <acquire>
  release(&tickslock);
80103b7c:	c7 04 24 80 97 11 80 	movl   $0x80119780,(%esp)
  xticks = ticks;
80103b83:	8b 35 c0 9f 11 80    	mov    0x80119fc0,%esi
  release(&tickslock);
80103b89:	e8 22 1c 00 00       	call   801057b0 <release>
  p->executed_cycle_ratio = 0;
  p->arrival_ratio = 0;
  p->priority_ratio = 0;
  p->cycle_count = 0;

  memset(p->syscall_cnt, 0, sizeof p->syscall_cnt);
80103b8e:	83 c4 0c             	add    $0xc,%esp
80103b91:	8d 43 7c             	lea    0x7c(%ebx),%eax
  p->cycle_count = 0;
80103b94:	c7 83 fc 00 00 00 00 	movl   $0x0,0xfc(%ebx)
80103b9b:	00 00 00 
  p->executed_cycle = 0;
80103b9e:	d9 ee                	fldz   
  p->arrival_time = sys_uptime_fake();
80103ba0:	89 b3 00 01 00 00    	mov    %esi,0x100(%ebx)
  p->executed_cycle = 0;
80103ba6:	dd 93 04 01 00 00    	fstl   0x104(%ebx)
  p->executed_cycle_ratio = 0;
80103bac:	dd 93 1c 01 00 00    	fstl   0x11c(%ebx)
  p->arrival_ratio = 0;
80103bb2:	dd 93 14 01 00 00    	fstl   0x114(%ebx)
  p->priority_ratio = 0;
80103bb8:	dd 9b 0c 01 00 00    	fstpl  0x10c(%ebx)
  memset(p->syscall_cnt, 0, sizeof p->syscall_cnt);
80103bbe:	6a 74                	push   $0x74
80103bc0:	6a 00                	push   $0x0
80103bc2:	50                   	push   %eax
80103bc3:	e8 38 1c 00 00       	call   80105800 <memset>
  release(&ptable.lock);
80103bc8:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80103bcf:	e8 dc 1b 00 00       	call   801057b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103bd4:	e8 c7 ed ff ff       	call   801029a0 <kalloc>
80103bd9:	83 c4 10             	add    $0x10,%esp
80103bdc:	89 43 08             	mov    %eax,0x8(%ebx)
80103bdf:	85 c0                	test   %eax,%eax
80103be1:	74 58                	je     80103c3b <allocproc+0x13b>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103be3:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103be9:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103bec:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103bf1:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103bf4:	c7 40 14 3c 6c 10 80 	movl   $0x80106c3c,0x14(%eax)
  p->context = (struct context*)sp;
80103bfb:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103bfe:	6a 14                	push   $0x14
80103c00:	6a 00                	push   $0x0
80103c02:	50                   	push   %eax
80103c03:	e8 f8 1b 00 00       	call   80105800 <memset>
  p->context->eip = (uint)forkret;
80103c08:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103c0b:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103c0e:	c7 40 10 50 3c 10 80 	movl   $0x80103c50,0x10(%eax)
}
80103c15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c18:	89 d8                	mov    %ebx,%eax
80103c1a:	5b                   	pop    %ebx
80103c1b:	5e                   	pop    %esi
80103c1c:	5d                   	pop    %ebp
80103c1d:	c3                   	ret    
80103c1e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103c20:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103c23:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103c25:	68 40 4e 11 80       	push   $0x80114e40
80103c2a:	e8 81 1b 00 00       	call   801057b0 <release>
  return 0;
80103c2f:	83 c4 10             	add    $0x10,%esp
}
80103c32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c35:	89 d8                	mov    %ebx,%eax
80103c37:	5b                   	pop    %ebx
80103c38:	5e                   	pop    %esi
80103c39:	5d                   	pop    %ebp
80103c3a:	c3                   	ret    
    p->state = UNUSED;
80103c3b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
80103c42:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80103c45:	31 db                	xor    %ebx,%ebx
}
80103c47:	89 d8                	mov    %ebx,%eax
80103c49:	5b                   	pop    %ebx
80103c4a:	5e                   	pop    %esi
80103c4b:	5d                   	pop    %ebp
80103c4c:	c3                   	ret    
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi

80103c50 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	55                   	push   %ebp
80103c55:	89 e5                	mov    %esp,%ebp
80103c57:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103c5a:	68 40 4e 11 80       	push   $0x80114e40
80103c5f:	e8 4c 1b 00 00       	call   801057b0 <release>

  if (first) {
80103c64:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103c69:	83 c4 10             	add    $0x10,%esp
80103c6c:	85 c0                	test   %eax,%eax
80103c6e:	75 08                	jne    80103c78 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103c70:	c9                   	leave  
80103c71:	c3                   	ret    
80103c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103c78:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103c7f:	00 00 00 
    iinit(ROOTDEV);
80103c82:	83 ec 0c             	sub    $0xc,%esp
80103c85:	6a 01                	push   $0x1
80103c87:	e8 24 dc ff ff       	call   801018b0 <iinit>
    initlog(ROOTDEV);
80103c8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c93:	e8 68 f3 ff ff       	call   80103000 <initlog>
}
80103c98:	83 c4 10             	add    $0x10,%esp
80103c9b:	c9                   	leave  
80103c9c:	c3                   	ret    
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi

80103ca0 <pinit>:
{
80103ca0:	f3 0f 1e fb          	endbr32 
80103ca4:	55                   	push   %ebp
80103ca5:	89 e5                	mov    %esp,%ebp
80103ca7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103caa:	68 40 8a 10 80       	push   $0x80108a40
80103caf:	68 40 4e 11 80       	push   $0x80114e40
80103cb4:	e8 b7 18 00 00       	call   80105570 <initlock>
}
80103cb9:	83 c4 10             	add    $0x10,%esp
  ptable.trace = 0;
80103cbc:	c7 05 74 97 11 80 00 	movl   $0x0,0x80119774
80103cc3:	00 00 00 
  ptable.trace_pid = -1;
80103cc6:	c7 05 78 97 11 80 ff 	movl   $0xffffffff,0x80119778
80103ccd:	ff ff ff 
}
80103cd0:	c9                   	leave  
80103cd1:	c3                   	ret    
80103cd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ce0 <mycpu>:
{
80103ce0:	f3 0f 1e fb          	endbr32 
80103ce4:	55                   	push   %ebp
80103ce5:	89 e5                	mov    %esp,%ebp
80103ce7:	56                   	push   %esi
80103ce8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ce9:	9c                   	pushf  
80103cea:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ceb:	f6 c4 02             	test   $0x2,%ah
80103cee:	75 4a                	jne    80103d3a <mycpu+0x5a>
  apicid = lapicid();
80103cf0:	e8 1b ef ff ff       	call   80102c10 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103cf5:	8b 35 20 4e 11 80    	mov    0x80114e20,%esi
  apicid = lapicid();
80103cfb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103cfd:	85 f6                	test   %esi,%esi
80103cff:	7e 2c                	jle    80103d2d <mycpu+0x4d>
80103d01:	31 d2                	xor    %edx,%edx
80103d03:	eb 0a                	jmp    80103d0f <mycpu+0x2f>
80103d05:	8d 76 00             	lea    0x0(%esi),%esi
80103d08:	83 c2 01             	add    $0x1,%edx
80103d0b:	39 f2                	cmp    %esi,%edx
80103d0d:	74 1e                	je     80103d2d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103d0f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103d15:	0f b6 81 a0 48 11 80 	movzbl -0x7feeb760(%ecx),%eax
80103d1c:	39 d8                	cmp    %ebx,%eax
80103d1e:	75 e8                	jne    80103d08 <mycpu+0x28>
}
80103d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103d23:	8d 81 a0 48 11 80    	lea    -0x7feeb760(%ecx),%eax
}
80103d29:	5b                   	pop    %ebx
80103d2a:	5e                   	pop    %esi
80103d2b:	5d                   	pop    %ebp
80103d2c:	c3                   	ret    
  panic("unknown apicid\n");
80103d2d:	83 ec 0c             	sub    $0xc,%esp
80103d30:	68 47 8a 10 80       	push   $0x80108a47
80103d35:	e8 56 c6 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 14 8c 10 80       	push   $0x80108c14
80103d42:	e8 49 c6 ff ff       	call   80100390 <panic>
80103d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4e:	66 90                	xchg   %ax,%ax

80103d50 <cpuid>:
cpuid() {
80103d50:	f3 0f 1e fb          	endbr32 
80103d54:	55                   	push   %ebp
80103d55:	89 e5                	mov    %esp,%ebp
80103d57:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103d5a:	e8 81 ff ff ff       	call   80103ce0 <mycpu>
}
80103d5f:	c9                   	leave  
  return mycpu()-cpus;
80103d60:	2d a0 48 11 80       	sub    $0x801148a0,%eax
80103d65:	c1 f8 04             	sar    $0x4,%eax
80103d68:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103d6e:	c3                   	ret    
80103d6f:	90                   	nop

80103d70 <sys_uptime_fake>:
{
80103d70:	f3 0f 1e fb          	endbr32 
80103d74:	55                   	push   %ebp
80103d75:	89 e5                	mov    %esp,%ebp
80103d77:	53                   	push   %ebx
80103d78:	83 ec 10             	sub    $0x10,%esp
  acquire(&tickslock);
80103d7b:	68 80 97 11 80       	push   $0x80119780
80103d80:	e8 6b 19 00 00       	call   801056f0 <acquire>
  xticks = ticks;
80103d85:	8b 1d c0 9f 11 80    	mov    0x80119fc0,%ebx
  release(&tickslock);
80103d8b:	c7 04 24 80 97 11 80 	movl   $0x80119780,(%esp)
80103d92:	e8 19 1a 00 00       	call   801057b0 <release>
}
80103d97:	89 d8                	mov    %ebx,%eax
80103d99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d9c:	c9                   	leave  
80103d9d:	c3                   	ret    
80103d9e:	66 90                	xchg   %ax,%ax

80103da0 <myproc>:
myproc(void) {
80103da0:	f3 0f 1e fb          	endbr32 
80103da4:	55                   	push   %ebp
80103da5:	89 e5                	mov    %esp,%ebp
80103da7:	53                   	push   %ebx
80103da8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103dab:	e8 40 18 00 00       	call   801055f0 <pushcli>
  c = mycpu();
80103db0:	e8 2b ff ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80103db5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dbb:	e8 80 18 00 00       	call   80105640 <popcli>
}
80103dc0:	83 c4 04             	add    $0x4,%esp
80103dc3:	89 d8                	mov    %ebx,%eax
80103dc5:	5b                   	pop    %ebx
80103dc6:	5d                   	pop    %ebp
80103dc7:	c3                   	ret    
80103dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dcf:	90                   	nop

80103dd0 <userinit>:
{
80103dd0:	f3 0f 1e fb          	endbr32 
80103dd4:	55                   	push   %ebp
80103dd5:	89 e5                	mov    %esp,%ebp
80103dd7:	53                   	push   %ebx
80103dd8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ddb:	e8 20 fd ff ff       	call   80103b00 <allocproc>
80103de0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103de2:	a3 38 c6 10 80       	mov    %eax,0x8010c638
  if((p->pgdir = setupkvm()) == 0)
80103de7:	e8 14 44 00 00       	call   80108200 <setupkvm>
80103dec:	89 43 04             	mov    %eax,0x4(%ebx)
80103def:	85 c0                	test   %eax,%eax
80103df1:	0f 84 bd 00 00 00    	je     80103eb4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103df7:	83 ec 04             	sub    $0x4,%esp
80103dfa:	68 2c 00 00 00       	push   $0x2c
80103dff:	68 e0 c4 10 80       	push   $0x8010c4e0
80103e04:	50                   	push   %eax
80103e05:	e8 c6 40 00 00       	call   80107ed0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e0a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e0d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e13:	6a 4c                	push   $0x4c
80103e15:	6a 00                	push   $0x0
80103e17:	ff 73 18             	pushl  0x18(%ebx)
80103e1a:	e8 e1 19 00 00       	call   80105800 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103e22:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e27:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e2a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e2f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e33:	8b 43 18             	mov    0x18(%ebx),%eax
80103e36:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103e3a:	8b 43 18             	mov    0x18(%ebx),%eax
80103e3d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e41:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103e45:	8b 43 18             	mov    0x18(%ebx),%eax
80103e48:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e4c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103e50:	8b 43 18             	mov    0x18(%ebx),%eax
80103e53:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103e5a:	8b 43 18             	mov    0x18(%ebx),%eax
80103e5d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103e64:	8b 43 18             	mov    0x18(%ebx),%eax
80103e67:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e6e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e71:	6a 10                	push   $0x10
80103e73:	68 70 8a 10 80       	push   $0x80108a70
80103e78:	50                   	push   %eax
80103e79:	e8 42 1b 00 00       	call   801059c0 <safestrcpy>
  p->cwd = namei("/");
80103e7e:	c7 04 24 79 8a 10 80 	movl   $0x80108a79,(%esp)
80103e85:	e8 16 e5 ff ff       	call   801023a0 <namei>
80103e8a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103e8d:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80103e94:	e8 57 18 00 00       	call   801056f0 <acquire>
  p->state = RUNNABLE;
80103e99:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103ea0:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80103ea7:	e8 04 19 00 00       	call   801057b0 <release>
}
80103eac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eaf:	83 c4 10             	add    $0x10,%esp
80103eb2:	c9                   	leave  
80103eb3:	c3                   	ret    
    panic("userinit: out of memory?");
80103eb4:	83 ec 0c             	sub    $0xc,%esp
80103eb7:	68 57 8a 10 80       	push   $0x80108a57
80103ebc:	e8 cf c4 ff ff       	call   80100390 <panic>
80103ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ecf:	90                   	nop

80103ed0 <growproc>:
{
80103ed0:	f3 0f 1e fb          	endbr32 
80103ed4:	55                   	push   %ebp
80103ed5:	89 e5                	mov    %esp,%ebp
80103ed7:	56                   	push   %esi
80103ed8:	53                   	push   %ebx
80103ed9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103edc:	e8 0f 17 00 00       	call   801055f0 <pushcli>
  c = mycpu();
80103ee1:	e8 fa fd ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80103ee6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103eec:	e8 4f 17 00 00       	call   80105640 <popcli>
  sz = curproc->sz;
80103ef1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ef3:	85 f6                	test   %esi,%esi
80103ef5:	7f 19                	jg     80103f10 <growproc+0x40>
  } else if(n < 0){
80103ef7:	75 37                	jne    80103f30 <growproc+0x60>
  switchuvm(curproc);
80103ef9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103efc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103efe:	53                   	push   %ebx
80103eff:	e8 bc 3e 00 00       	call   80107dc0 <switchuvm>
  return 0;
80103f04:	83 c4 10             	add    $0x10,%esp
80103f07:	31 c0                	xor    %eax,%eax
}
80103f09:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f0c:	5b                   	pop    %ebx
80103f0d:	5e                   	pop    %esi
80103f0e:	5d                   	pop    %ebp
80103f0f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f10:	83 ec 04             	sub    $0x4,%esp
80103f13:	01 c6                	add    %eax,%esi
80103f15:	56                   	push   %esi
80103f16:	50                   	push   %eax
80103f17:	ff 73 04             	pushl  0x4(%ebx)
80103f1a:	e8 01 41 00 00       	call   80108020 <allocuvm>
80103f1f:	83 c4 10             	add    $0x10,%esp
80103f22:	85 c0                	test   %eax,%eax
80103f24:	75 d3                	jne    80103ef9 <growproc+0x29>
      return -1;
80103f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f2b:	eb dc                	jmp    80103f09 <growproc+0x39>
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f30:	83 ec 04             	sub    $0x4,%esp
80103f33:	01 c6                	add    %eax,%esi
80103f35:	56                   	push   %esi
80103f36:	50                   	push   %eax
80103f37:	ff 73 04             	pushl  0x4(%ebx)
80103f3a:	e8 11 42 00 00       	call   80108150 <deallocuvm>
80103f3f:	83 c4 10             	add    $0x10,%esp
80103f42:	85 c0                	test   %eax,%eax
80103f44:	75 b3                	jne    80103ef9 <growproc+0x29>
80103f46:	eb de                	jmp    80103f26 <growproc+0x56>
80103f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f4f:	90                   	nop

80103f50 <fork>:
{
80103f50:	f3 0f 1e fb          	endbr32 
80103f54:	55                   	push   %ebp
80103f55:	89 e5                	mov    %esp,%ebp
80103f57:	57                   	push   %edi
80103f58:	56                   	push   %esi
80103f59:	53                   	push   %ebx
80103f5a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103f5d:	e8 8e 16 00 00       	call   801055f0 <pushcli>
  c = mycpu();
80103f62:	e8 79 fd ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80103f67:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f6d:	e8 ce 16 00 00       	call   80105640 <popcli>
  if((np = allocproc()) == 0){
80103f72:	e8 89 fb ff ff       	call   80103b00 <allocproc>
80103f77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103f7a:	85 c0                	test   %eax,%eax
80103f7c:	0f 84 d7 00 00 00    	je     80104059 <fork+0x109>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103f82:	83 ec 08             	sub    $0x8,%esp
80103f85:	ff 33                	pushl  (%ebx)
80103f87:	89 c7                	mov    %eax,%edi
80103f89:	ff 73 04             	pushl  0x4(%ebx)
80103f8c:	e8 3f 43 00 00       	call   801082d0 <copyuvm>
80103f91:	83 c4 10             	add    $0x10,%esp
80103f94:	89 47 04             	mov    %eax,0x4(%edi)
80103f97:	85 c0                	test   %eax,%eax
80103f99:	0f 84 c1 00 00 00    	je     80104060 <fork+0x110>
  np->sz = curproc->sz;
80103f9f:	8b 03                	mov    (%ebx),%eax
80103fa1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103fa4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103fa6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103fa9:	89 c8                	mov    %ecx,%eax
80103fab:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103fae:	b9 13 00 00 00       	mov    $0x13,%ecx
80103fb3:	8b 73 18             	mov    0x18(%ebx),%esi
80103fb6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103fb8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103fba:	8b 40 18             	mov    0x18(%eax),%eax
80103fbd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103fc8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103fcc:	85 c0                	test   %eax,%eax
80103fce:	74 13                	je     80103fe3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103fd0:	83 ec 0c             	sub    $0xc,%esp
80103fd3:	50                   	push   %eax
80103fd4:	e8 07 d2 ff ff       	call   801011e0 <filedup>
80103fd9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103fdc:	83 c4 10             	add    $0x10,%esp
80103fdf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103fe3:	83 c6 01             	add    $0x1,%esi
80103fe6:	83 fe 10             	cmp    $0x10,%esi
80103fe9:	75 dd                	jne    80103fc8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103feb:	83 ec 0c             	sub    $0xc,%esp
80103fee:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ff1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103ff4:	e8 a7 da ff ff       	call   80101aa0 <idup>
80103ff9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ffc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103fff:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104002:	8d 47 6c             	lea    0x6c(%edi),%eax
80104005:	6a 10                	push   $0x10
80104007:	53                   	push   %ebx
80104008:	50                   	push   %eax
80104009:	e8 b2 19 00 00       	call   801059c0 <safestrcpy>
  if (pid == initproc->pid + 1)
8010400e:	a1 38 c6 10 80       	mov    0x8010c638,%eax
  pid = np->pid;
80104013:	8b 5f 10             	mov    0x10(%edi),%ebx
  if (pid == initproc->pid + 1)
80104016:	83 c4 10             	add    $0x10,%esp
80104019:	8b 40 10             	mov    0x10(%eax),%eax
8010401c:	83 c0 01             	add    $0x1,%eax
8010401f:	39 d8                	cmp    %ebx,%eax
80104021:	75 06                	jne    80104029 <fork+0xd9>
    ptable.trace_pid = pid;
80104023:	89 1d 78 97 11 80    	mov    %ebx,0x80119778
  acquire(&ptable.lock);
80104029:	83 ec 0c             	sub    $0xc,%esp
8010402c:	68 40 4e 11 80       	push   $0x80114e40
80104031:	e8 ba 16 00 00       	call   801056f0 <acquire>
  np->state = RUNNABLE;
80104036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104039:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104040:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104047:	e8 64 17 00 00       	call   801057b0 <release>
  return pid;
8010404c:	83 c4 10             	add    $0x10,%esp
}
8010404f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104052:	89 d8                	mov    %ebx,%eax
80104054:	5b                   	pop    %ebx
80104055:	5e                   	pop    %esi
80104056:	5f                   	pop    %edi
80104057:	5d                   	pop    %ebp
80104058:	c3                   	ret    
    return -1;
80104059:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010405e:	eb ef                	jmp    8010404f <fork+0xff>
    kfree(np->kstack);
80104060:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104063:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80104066:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
8010406b:	ff 77 08             	pushl  0x8(%edi)
8010406e:	e8 6d e7 ff ff       	call   801027e0 <kfree>
    np->kstack = 0;
80104073:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -1;
8010407a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010407d:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80104084:	eb c9                	jmp    8010404f <fork+0xff>
80104086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408d:	8d 76 00             	lea    0x0(%esi),%esi

80104090 <get_children_pid_number>:
int get_children_pid_number(int parent_id){
80104090:	f3 0f 1e fb          	endbr32 
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	57                   	push   %edi
80104098:	56                   	push   %esi
80104099:	53                   	push   %ebx
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010409a:	bb 74 4e 11 80       	mov    $0x80114e74,%ebx
int get_children_pid_number(int parent_id){
8010409f:	83 ec 1c             	sub    $0x1c,%esp
801040a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  int result = parent_id;
801040a5:	89 fe                	mov    %edi,%esi
801040a7:	eb 15                	jmp    801040be <get_children_pid_number+0x2e>
801040a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b0:	81 c3 24 01 00 00    	add    $0x124,%ebx
801040b6:	81 fb 74 97 11 80    	cmp    $0x80119774,%ebx
801040bc:	74 55                	je     80104113 <get_children_pid_number+0x83>
    if(p->parent->pid == parent_id){
801040be:	8b 43 14             	mov    0x14(%ebx),%eax
801040c1:	39 78 10             	cmp    %edi,0x10(%eax)
801040c4:	75 ea                	jne    801040b0 <get_children_pid_number+0x20>
      int cur = get_children_pid_number(p->pid);
801040c6:	83 ec 0c             	sub    $0xc,%esp
801040c9:	ff 73 10             	pushl  0x10(%ebx)
801040cc:	e8 bf ff ff ff       	call   80104090 <get_children_pid_number>
801040d1:	83 c4 10             	add    $0x10,%esp
801040d4:	89 c1                	mov    %eax,%ecx
      while(cur > 0){
801040d6:	85 c0                	test   %eax,%eax
801040d8:	7e d6                	jle    801040b0 <get_children_pid_number+0x20>
801040da:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801040dd:	8d 76 00             	lea    0x0(%esi),%esi
        result = 10 * result + (cur % 10);
801040e0:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
801040e5:	89 cb                	mov    %ecx,%ebx
801040e7:	8d 34 b6             	lea    (%esi,%esi,4),%esi
801040ea:	f7 e1                	mul    %ecx
801040ec:	c1 ea 03             	shr    $0x3,%edx
801040ef:	8d 04 92             	lea    (%edx,%edx,4),%eax
801040f2:	01 c0                	add    %eax,%eax
801040f4:	29 c3                	sub    %eax,%ebx
801040f6:	89 c8                	mov    %ecx,%eax
        cur /= 10;
801040f8:	89 d1                	mov    %edx,%ecx
        result = 10 * result + (cur % 10);
801040fa:	8d 34 73             	lea    (%ebx,%esi,2),%esi
      while(cur > 0){
801040fd:	83 f8 09             	cmp    $0x9,%eax
80104100:	7f de                	jg     801040e0 <get_children_pid_number+0x50>
80104102:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104105:	81 c3 24 01 00 00    	add    $0x124,%ebx
8010410b:	81 fb 74 97 11 80    	cmp    $0x80119774,%ebx
80104111:	75 ab                	jne    801040be <get_children_pid_number+0x2e>
}
80104113:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104116:	89 f0                	mov    %esi,%eax
80104118:	5b                   	pop    %ebx
80104119:	5e                   	pop    %esi
8010411a:	5f                   	pop    %edi
8010411b:	5d                   	pop    %ebp
8010411c:	c3                   	ret    
8010411d:	8d 76 00             	lea    0x0(%esi),%esi

80104120 <get_children>:
int get_children(int parent_id){
80104120:	f3 0f 1e fb          	endbr32 
  int answer = get_children_pid_number(parent_id);
80104124:	e9 67 ff ff ff       	jmp    80104090 <get_children_pid_number>
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104130 <swtch_ptbl_tr>:
{
80104130:	f3 0f 1e fb          	endbr32 
80104134:	55                   	push   %ebp
80104135:	89 e5                	mov    %esp,%ebp
  ptable.trace = tr;
80104137:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010413a:	5d                   	pop    %ebp
  ptable.trace = tr;
8010413b:	a3 74 97 11 80       	mov    %eax,0x80119774
}
80104140:	c3                   	ret    
80104141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010414f:	90                   	nop

80104150 <print_proc_syscalls>:
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	56                   	push   %esi
80104158:	53                   	push   %ebx
80104159:	8b 75 08             	mov    0x8(%ebp),%esi
  for(int i = 0; i < N_SYSCALL; i++){
8010415c:	31 db                	xor    %ebx,%ebx
  cprintf("%s:\n", curproc->name);
8010415e:	8d 46 6c             	lea    0x6c(%esi),%eax
80104161:	83 ec 08             	sub    $0x8,%esp
80104164:	50                   	push   %eax
80104165:	68 7b 8a 10 80       	push   $0x80108a7b
8010416a:	e8 41 c5 ff ff       	call   801006b0 <cprintf>
8010416f:	83 c4 10             	add    $0x10,%esp
80104172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->syscall_cnt[i] > 0){
80104178:	8b 44 9e 7c          	mov    0x7c(%esi,%ebx,4),%eax
8010417c:	85 c0                	test   %eax,%eax
8010417e:	7e 18                	jle    80104198 <print_proc_syscalls+0x48>
      cprintf("    %s: %d\n", syscall_names[i], curproc->syscall_cnt[i]);
80104180:	83 ec 04             	sub    $0x4,%esp
80104183:	50                   	push   %eax
80104184:	ff 34 9d 20 c0 10 80 	pushl  -0x7fef3fe0(,%ebx,4)
8010418b:	68 80 8a 10 80       	push   $0x80108a80
80104190:	e8 1b c5 ff ff       	call   801006b0 <cprintf>
80104195:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < N_SYSCALL; i++){
80104198:	83 c3 01             	add    $0x1,%ebx
8010419b:	83 fb 1d             	cmp    $0x1d,%ebx
8010419e:	75 d8                	jne    80104178 <print_proc_syscalls+0x28>
}
801041a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041a3:	5b                   	pop    %ebx
801041a4:	5e                   	pop    %esi
801041a5:	5d                   	pop    %ebp
801041a6:	c3                   	ret    
801041a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ae:	66 90                	xchg   %ax,%ax

801041b0 <trace_syscalls>:
{
801041b0:	f3 0f 1e fb          	endbr32 
801041b4:	55                   	push   %ebp
801041b5:	89 e5                	mov    %esp,%ebp
801041b7:	56                   	push   %esi
801041b8:	53                   	push   %ebx
801041b9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801041bc:	e8 2f 14 00 00       	call   801055f0 <pushcli>
  c = mycpu();
801041c1:	e8 1a fb ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
801041c6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041cc:	e8 6f 14 00 00       	call   80105640 <popcli>
  if(curproc->pid != ptable.trace_pid) {
801041d1:	a1 78 97 11 80       	mov    0x80119778,%eax
801041d6:	39 43 10             	cmp    %eax,0x10(%ebx)
801041d9:	74 15                	je     801041f0 <trace_syscalls+0x40>
  ptable.trace = tr;
801041db:	89 35 74 97 11 80    	mov    %esi,0x80119774
}
801041e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e4:	5b                   	pop    %ebx
801041e5:	5e                   	pop    %esi
801041e6:	5d                   	pop    %ebp
801041e7:	c3                   	ret    
801041e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ef:	90                   	nop
  if(ptable.trace == 0)
801041f0:	a1 74 97 11 80       	mov    0x80119774,%eax
801041f5:	85 c0                	test   %eax,%eax
801041f7:	74 e8                	je     801041e1 <trace_syscalls+0x31>
  cprintf("\n");
801041f9:	83 ec 0c             	sub    $0xc,%esp
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041fc:	bb 74 4e 11 80       	mov    $0x80114e74,%ebx
  cprintf("\n");
80104201:	68 f2 8a 10 80       	push   $0x80108af2
80104206:	e8 a5 c4 ff ff       	call   801006b0 <cprintf>
8010420b:	83 c4 10             	add    $0x10,%esp
8010420e:	eb 0e                	jmp    8010421e <trace_syscalls+0x6e>
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104210:	81 c3 24 01 00 00    	add    $0x124,%ebx
80104216:	81 fb 74 97 11 80    	cmp    $0x80119774,%ebx
8010421c:	74 25                	je     80104243 <trace_syscalls+0x93>
    if(EMBRYO < p->state && p->state < ZOMBIE)
8010421e:	8b 43 0c             	mov    0xc(%ebx),%eax
80104221:	83 e8 02             	sub    $0x2,%eax
80104224:	83 f8 02             	cmp    $0x2,%eax
80104227:	77 e7                	ja     80104210 <trace_syscalls+0x60>
      print_proc_syscalls(p);
80104229:	83 ec 0c             	sub    $0xc,%esp
8010422c:	53                   	push   %ebx
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010422d:	81 c3 24 01 00 00    	add    $0x124,%ebx
      print_proc_syscalls(p);
80104233:	e8 18 ff ff ff       	call   80104150 <print_proc_syscalls>
80104238:	83 c4 10             	add    $0x10,%esp
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010423b:	81 fb 74 97 11 80    	cmp    $0x80119774,%ebx
80104241:	75 db                	jne    8010421e <trace_syscalls+0x6e>
  cprintf("\n");
80104243:	c7 45 08 f2 8a 10 80 	movl   $0x80108af2,0x8(%ebp)
}
8010424a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010424d:	5b                   	pop    %ebx
8010424e:	5e                   	pop    %esi
8010424f:	5d                   	pop    %ebp
  cprintf("\n");
80104250:	e9 5b c4 ff ff       	jmp    801006b0 <cprintf>
80104255:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104260 <n_tu>:
{
80104260:	f3 0f 1e fb          	endbr32 
80104264:	55                   	push   %ebp
80104265:	89 e5                	mov    %esp,%ebp
80104267:	8b 55 0c             	mov    0xc(%ebp),%edx
8010426a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    while(count-- > 0)
8010426d:	85 d2                	test   %edx,%edx
8010426f:	7e 1f                	jle    80104290 <n_tu+0x30>
80104271:	8d 42 ff             	lea    -0x1(%edx),%eax
    int result = 1;
80104274:	ba 01 00 00 00       	mov    $0x1,%edx
80104279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while(count-- > 0)
80104280:	83 e8 01             	sub    $0x1,%eax
        result *= number;
80104283:	0f af d1             	imul   %ecx,%edx
    while(count-- > 0)
80104286:	83 f8 ff             	cmp    $0xffffffff,%eax
80104289:	75 f5                	jne    80104280 <n_tu+0x20>
}
8010428b:	89 d0                	mov    %edx,%eax
8010428d:	5d                   	pop    %ebp
8010428e:	c3                   	ret    
8010428f:	90                   	nop
    int result = 1;
80104290:	ba 01 00 00 00       	mov    $0x1,%edx
}
80104295:	5d                   	pop    %ebp
80104296:	89 d0                	mov    %edx,%eax
80104298:	c3                   	ret    
80104299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042a0 <print_str_lenght>:
{
801042a0:	f3 0f 1e fb          	endbr32 
801042a4:	55                   	push   %ebp
801042a5:	89 e5                	mov    %esp,%ebp
801042a7:	56                   	push   %esi
801042a8:	8b 55 08             	mov    0x8(%ebp),%edx
801042ab:	8b 75 0c             	mov    0xc(%ebp),%esi
801042ae:	53                   	push   %ebx
  while(s[size] != '\0')
801042af:	80 3a 00             	cmpb   $0x0,(%edx)
801042b2:	74 17                	je     801042cb <print_str_lenght+0x2b>
  int size = 0;
801042b4:	31 c0                	xor    %eax,%eax
801042b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042bd:	8d 76 00             	lea    0x0(%esi),%esi
    size++;
801042c0:	83 c0 01             	add    $0x1,%eax
  while(s[size] != '\0')
801042c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801042c7:	75 f7                	jne    801042c0 <print_str_lenght+0x20>
801042c9:	29 c6                	sub    %eax,%esi
  cprintf("%s", s);
801042cb:	83 ec 08             	sub    $0x8,%esp
  for(i = 0 ; i < n - size ; i++)
801042ce:	31 db                	xor    %ebx,%ebx
  cprintf("%s", s);
801042d0:	52                   	push   %edx
801042d1:	68 6e 8b 10 80       	push   $0x80108b6e
801042d6:	e8 d5 c3 ff ff       	call   801006b0 <cprintf>
  for(i = 0 ; i < n - size ; i++)
801042db:	83 c4 10             	add    $0x10,%esp
801042de:	85 f6                	test   %esi,%esi
801042e0:	7e 1d                	jle    801042ff <print_str_lenght+0x5f>
801042e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
801042e8:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0 ; i < n - size ; i++)
801042eb:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
801042ee:	68 ce 8a 10 80       	push   $0x80108ace
801042f3:	e8 b8 c3 ff ff       	call   801006b0 <cprintf>
  for(i = 0 ; i < n - size ; i++)
801042f8:	83 c4 10             	add    $0x10,%esp
801042fb:	39 f3                	cmp    %esi,%ebx
801042fd:	75 e9                	jne    801042e8 <print_str_lenght+0x48>
}
801042ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104302:	5b                   	pop    %ebx
80104303:	5e                   	pop    %esi
80104304:	5d                   	pop    %ebp
80104305:	c3                   	ret    
80104306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430d:	8d 76 00             	lea    0x0(%esi),%esi

80104310 <float_to_string>:
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
    char answer[100] = {0};
80104315:	31 c0                	xor    %eax,%eax
80104317:	b9 18 00 00 00       	mov    $0x18,%ecx
    dec = (int)(fVal * 100) % 100;
8010431c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
{
80104321:	89 e5                	mov    %esp,%ebp
80104323:	57                   	push   %edi
80104324:	56                   	push   %esi
    char answer[100] = {0};
80104325:	8d 7d 88             	lea    -0x78(%ebp),%edi
    memset(result, 0, 100);
80104328:	8d b5 20 ff ff ff    	lea    -0xe0(%ebp),%esi
{
8010432e:	53                   	push   %ebx
8010432f:	81 ec f0 00 00 00    	sub    $0xf0,%esp
    fVal += 0.005;   // added after a comment from Matt McNabb, see below.
80104335:	dd 05 f0 8c 10 80    	fldl   0x80108cf0
8010433b:	d8 45 08             	fadds  0x8(%ebp)
    char answer[100] = {0};
8010433e:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
80104345:	f3 ab                	rep stos %eax,%es:(%edi)
    memset(result, 0, 100);
80104347:	6a 64                	push   $0x64
    dVal = fVal;
80104349:	d9 bd 16 ff ff ff    	fnstcw -0xea(%ebp)
    memset(result, 0, 100);
8010434f:	6a 00                	push   $0x0
80104351:	56                   	push   %esi
    dVal = fVal;
80104352:	0f b7 85 16 ff ff ff 	movzwl -0xea(%ebp),%eax
    fVal += 0.005;   // added after a comment from Matt McNabb, see below.
80104359:	d9 9d 10 ff ff ff    	fstps  -0xf0(%ebp)
8010435f:	d9 85 10 ff ff ff    	flds   -0xf0(%ebp)
    dVal = fVal;
80104365:	80 cc 0c             	or     $0xc,%ah
80104368:	66 89 85 14 ff ff ff 	mov    %ax,-0xec(%ebp)
8010436f:	d9 ad 14 ff ff ff    	fldcw  -0xec(%ebp)
80104375:	db 95 10 ff ff ff    	fistl  -0xf0(%ebp)
8010437b:	d9 ad 16 ff ff ff    	fldcw  -0xea(%ebp)
    dec = (int)(fVal * 100) % 100;
80104381:	d8 0d 00 8d 10 80    	fmuls  0x80108d00
    dVal = fVal;
80104387:	8b 9d 10 ff ff ff    	mov    -0xf0(%ebp),%ebx
    dec = (int)(fVal * 100) % 100;
8010438d:	d9 ad 14 ff ff ff    	fldcw  -0xec(%ebp)
80104393:	db 9d 10 ff ff ff    	fistpl -0xf0(%ebp)
80104399:	d9 ad 16 ff ff ff    	fldcw  -0xea(%ebp)
8010439f:	8b 8d 10 ff ff ff    	mov    -0xf0(%ebp),%ecx
801043a5:	89 c8                	mov    %ecx,%eax
801043a7:	f7 ea                	imul   %edx
801043a9:	89 c8                	mov    %ecx,%eax
801043ab:	c1 f8 1f             	sar    $0x1f,%eax
801043ae:	c1 fa 05             	sar    $0x5,%edx
801043b1:	89 d7                	mov    %edx,%edi
801043b3:	29 c7                	sub    %eax,%edi
801043b5:	6b ff 64             	imul   $0x64,%edi,%edi
801043b8:	29 f9                	sub    %edi,%ecx
801043ba:	89 cf                	mov    %ecx,%edi
    memset(result, 0, 100);
801043bc:	e8 3f 14 00 00       	call   80105800 <memset>
    result[0] = (dec % 10) + '0';
801043c1:	89 f8                	mov    %edi,%eax
801043c3:	ba 67 66 66 66       	mov    $0x66666667,%edx
    while (dVal > 0)
801043c8:	83 c4 10             	add    $0x10,%esp
    result[0] = (dec % 10) + '0';
801043cb:	f7 ea                	imul   %edx
801043cd:	89 f8                	mov    %edi,%eax
    result[2] = '.';
801043cf:	c6 85 22 ff ff ff 2e 	movb   $0x2e,-0xde(%ebp)
    result[0] = (dec % 10) + '0';
801043d6:	c1 f8 1f             	sar    $0x1f,%eax
801043d9:	c1 fa 02             	sar    $0x2,%edx
801043dc:	29 c2                	sub    %eax,%edx
801043de:	8d 04 92             	lea    (%edx,%edx,4),%eax
    result[1] = (dec / 10) + '0';
801043e1:	83 c2 30             	add    $0x30,%edx
    result[0] = (dec % 10) + '0';
801043e4:	01 c0                	add    %eax,%eax
    result[1] = (dec / 10) + '0';
801043e6:	88 95 21 ff ff ff    	mov    %dl,-0xdf(%ebp)
    result[0] = (dec % 10) + '0';
801043ec:	29 c7                	sub    %eax,%edi
801043ee:	8d 47 30             	lea    0x30(%edi),%eax
801043f1:	88 85 20 ff ff ff    	mov    %al,-0xe0(%ebp)
    while (dVal > 0)
801043f7:	85 db                	test   %ebx,%ebx
801043f9:	7e 36                	jle    80104431 <float_to_string+0x121>
801043fb:	8d 8d 23 ff ff ff    	lea    -0xdd(%ebp),%ecx
80104401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        result[i] = (dVal % 10) + '0';
80104408:	89 d8                	mov    %ebx,%eax
8010440a:	bf cd cc cc cc       	mov    $0xcccccccd,%edi
8010440f:	83 c1 01             	add    $0x1,%ecx
80104412:	f7 e7                	mul    %edi
80104414:	89 df                	mov    %ebx,%edi
80104416:	c1 ea 03             	shr    $0x3,%edx
80104419:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010441c:	01 c0                	add    %eax,%eax
8010441e:	29 c7                	sub    %eax,%edi
80104420:	89 f8                	mov    %edi,%eax
80104422:	83 c0 30             	add    $0x30,%eax
80104425:	88 41 ff             	mov    %al,-0x1(%ecx)
        dVal /= 10;
80104428:	89 d8                	mov    %ebx,%eax
8010442a:	89 d3                	mov    %edx,%ebx
    while (dVal > 0)
8010442c:	83 f8 09             	cmp    $0x9,%eax
8010442f:	7f d7                	jg     80104408 <float_to_string+0xf8>
    for (i=strlen(result)-1; i>=0; i--){
80104431:	83 ec 0c             	sub    $0xc,%esp
80104434:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
80104437:	56                   	push   %esi
80104438:	e8 c3 15 00 00       	call   80105a00 <strlen>
8010443d:	83 c4 10             	add    $0x10,%esp
80104440:	85 c0                	test   %eax,%eax
80104442:	7e 1e                	jle    80104462 <float_to_string+0x152>
80104444:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
80104447:	8d 44 06 ff          	lea    -0x1(%esi,%eax,1),%eax
8010444b:	89 da                	mov    %ebx,%edx
8010444d:	8d 76 00             	lea    0x0(%esi),%esi
        answer[tmp] = result[i];
80104450:	0f b6 08             	movzbl (%eax),%ecx
80104453:	83 c2 01             	add    $0x1,%edx
80104456:	88 4a ff             	mov    %cl,-0x1(%edx)
    for (i=strlen(result)-1; i>=0; i--){
80104459:	89 c1                	mov    %eax,%ecx
8010445b:	83 e8 01             	sub    $0x1,%eax
8010445e:	39 ce                	cmp    %ecx,%esi
80104460:	75 ee                	jne    80104450 <float_to_string+0x140>
    print_str_lenght(answer, 8);
80104462:	83 ec 08             	sub    $0x8,%esp
80104465:	6a 08                	push   $0x8
80104467:	53                   	push   %ebx
80104468:	e8 33 fe ff ff       	call   801042a0 <print_str_lenght>
}
8010446d:	83 c4 10             	add    $0x10,%esp
80104470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104473:	5b                   	pop    %ebx
80104474:	5e                   	pop    %esi
80104475:	5f                   	pop    %edi
80104476:	5d                   	pop    %ebp
80104477:	c3                   	ret    
80104478:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010447f:	90                   	nop

80104480 <print_procs_info>:
print_procs_info(void){
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	53                   	push   %ebx
80104488:	bb e0 4e 11 80       	mov    $0x80114ee0,%ebx
8010448d:	83 ec 40             	sub    $0x40,%esp
  char* states[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };
80104490:	c7 45 e0 8c 8a 10 80 	movl   $0x80108a8c,-0x20(%ebp)
  cprintf("\n");
80104497:	68 f2 8a 10 80       	push   $0x80108af2
  char* states[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };
8010449c:	c7 45 e4 93 8a 10 80 	movl   $0x80108a93,-0x1c(%ebp)
801044a3:	c7 45 e8 9a 8a 10 80 	movl   $0x80108a9a,-0x18(%ebp)
801044aa:	c7 45 ec a3 8a 10 80 	movl   $0x80108aa3,-0x14(%ebp)
801044b1:	c7 45 f0 ac 8a 10 80 	movl   $0x80108aac,-0x10(%ebp)
801044b8:	c7 45 f4 b4 8a 10 80 	movl   $0x80108ab4,-0xc(%ebp)
  cprintf("\n");
801044bf:	e8 ec c1 ff ff       	call   801006b0 <cprintf>
  cprintf("name       pid state      Qlv ticket   PR      AR      ER      RANK   CN\n");
801044c4:	c7 04 24 3c 8c 10 80 	movl   $0x80108c3c,(%esp)
801044cb:	e8 e0 c1 ff ff       	call   801006b0 <cprintf>
  cprintf("------------------------------------------------------------------------\n");
801044d0:	c7 04 24 88 8c 10 80 	movl   $0x80108c88,(%esp)
801044d7:	e8 d4 c1 ff ff       	call   801006b0 <cprintf>
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044dc:	83 c4 10             	add    $0x10,%esp
801044df:	e9 11 01 00 00       	jmp    801045f5 <print_procs_info+0x175>
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("%d   ", p->pid);
801044e8:	83 ec 08             	sub    $0x8,%esp
801044eb:	50                   	push   %eax
801044ec:	68 bb 8a 10 80       	push   $0x80108abb
801044f1:	e8 ba c1 ff ff       	call   801006b0 <cprintf>
801044f6:	83 c4 10             	add    $0x10,%esp
    print_str_lenght(states[p->state], 11);
801044f9:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044fc:	83 ec 08             	sub    $0x8,%esp
801044ff:	6a 0b                	push   $0xb
80104501:	ff 74 85 e0          	pushl  -0x20(%ebp,%eax,4)
80104505:	e8 96 fd ff ff       	call   801042a0 <print_str_lenght>
    cprintf("%d   ", p->q_level);
8010450a:	59                   	pop    %ecx
8010450b:	58                   	pop    %eax
8010450c:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
80104512:	68 bb 8a 10 80       	push   $0x80108abb
80104517:	e8 94 c1 ff ff       	call   801006b0 <cprintf>
  if(p->num_tickets < 10)
8010451c:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80104522:	83 c4 10             	add    $0x10,%esp
80104525:	83 f8 09             	cmp    $0x9,%eax
80104528:	0f 8e 32 01 00 00    	jle    80104660 <print_procs_info+0x1e0>
    else if(p->num_tickets < 100)
8010452e:	83 f8 63             	cmp    $0x63,%eax
80104531:	0f 8e 49 01 00 00    	jle    80104680 <print_procs_info+0x200>
    else if(p->num_tickets < 1000)
80104537:	3d e7 03 00 00       	cmp    $0x3e7,%eax
8010453c:	0f 8e 5e 01 00 00    	jle    801046a0 <print_procs_info+0x220>
    else if(p->num_tickets < 10000)
80104542:	3d 0f 27 00 00       	cmp    $0x270f,%eax
80104547:	0f 8e 73 01 00 00    	jle    801046c0 <print_procs_info+0x240>
    else if(p->num_tickets < 100000)
8010454d:	3d 9f 86 01 00       	cmp    $0x1869f,%eax
80104552:	0f 8e 88 01 00 00    	jle    801046e0 <print_procs_info+0x260>
    else if(p->num_tickets < 1000000)
80104558:	3d 3f 42 0f 00       	cmp    $0xf423f,%eax
8010455d:	0f 8e bd 01 00 00    	jle    80104720 <print_procs_info+0x2a0>
    else if(p->num_tickets < 10000000)
80104563:	3d 7f 96 98 00       	cmp    $0x98967f,%eax
80104568:	0f 8f 92 01 00 00    	jg     80104700 <print_procs_info+0x280>
      cprintf("%d ", p->num_tickets);
8010456e:	83 ec 08             	sub    $0x8,%esp
80104571:	50                   	push   %eax
80104572:	68 e8 8a 10 80       	push   $0x80108ae8
80104577:	e8 34 c1 ff ff       	call   801006b0 <cprintf>
8010457c:	83 c4 10             	add    $0x10,%esp
8010457f:	90                   	nop
    float_to_string(p->priority_ratio);
80104580:	dd 83 a0 00 00 00    	fldl   0xa0(%ebx)
80104586:	83 ec 0c             	sub    $0xc,%esp
80104589:	d9 5d cc             	fstps  -0x34(%ebp)
8010458c:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010458f:	50                   	push   %eax
80104590:	e8 7b fd ff ff       	call   80104310 <float_to_string>
    float_to_string(p->arrival_ratio);
80104595:	dd 83 a8 00 00 00    	fldl   0xa8(%ebx)
8010459b:	d9 5d cc             	fstps  -0x34(%ebp)
8010459e:	8b 45 cc             	mov    -0x34(%ebp),%eax
801045a1:	89 04 24             	mov    %eax,(%esp)
801045a4:	e8 67 fd ff ff       	call   80104310 <float_to_string>
    float_to_string(p->executed_cycle_ratio);
801045a9:	dd 83 b0 00 00 00    	fldl   0xb0(%ebx)
801045af:	d9 5d cc             	fstps  -0x34(%ebp)
801045b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801045b5:	89 04 24             	mov    %eax,(%esp)
801045b8:	e8 53 fd ff ff       	call   80104310 <float_to_string>
    float_to_string(rank);
801045bd:	dd 45 d0             	fldl   -0x30(%ebp)
801045c0:	d9 5d d0             	fstps  -0x30(%ebp)
801045c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
801045c6:	89 04 24             	mov    %eax,(%esp)
801045c9:	e8 42 fd ff ff       	call   80104310 <float_to_string>
    cprintf("%d \n", p->cycle_count);
801045ce:	58                   	pop    %eax
801045cf:	5a                   	pop    %edx
801045d0:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
801045d6:	68 ef 8a 10 80       	push   $0x80108aef
801045db:	e8 d0 c0 ff ff       	call   801006b0 <cprintf>
801045e0:	83 c4 10             	add    $0x10,%esp
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045e3:	81 c3 24 01 00 00    	add    $0x124,%ebx
801045e9:	81 fb e0 97 11 80    	cmp    $0x801197e0,%ebx
801045ef:	0f 84 4b 01 00 00    	je     80104740 <print_procs_info+0x2c0>
    if(p->state == UNUSED)
801045f5:	8b 43 a0             	mov    -0x60(%ebx),%eax
801045f8:	85 c0                	test   %eax,%eax
801045fa:	74 e7                	je     801045e3 <print_procs_info+0x163>
    double priority = 1 / (double) p->num_tickets;
801045fc:	db 83 88 00 00 00    	fildl  0x88(%ebx)
80104602:	d8 3d 04 8d 10 80    	fdivrs 0x80108d04
    print_str_lenght(p->name, 11);
80104608:	83 ec 08             	sub    $0x8,%esp
8010460b:	6a 0b                	push   $0xb
8010460d:	53                   	push   %ebx
    double rank = (priority * p->priority_ratio) + (p->arrival_time * p->arrival_ratio) \
8010460e:	dc 8b a0 00 00 00    	fmull  0xa0(%ebx)
80104614:	db 83 94 00 00 00    	fildl  0x94(%ebx)
8010461a:	dc 8b a8 00 00 00    	fmull  0xa8(%ebx)
80104620:	de c1                	faddp  %st,%st(1)
                  + (p->executed_cycle * p->executed_cycle_ratio);
80104622:	dd 83 98 00 00 00    	fldl   0x98(%ebx)
80104628:	dc 8b b0 00 00 00    	fmull  0xb0(%ebx)
    double rank = (priority * p->priority_ratio) + (p->arrival_time * p->arrival_ratio) \
8010462e:	de c1                	faddp  %st,%st(1)
80104630:	dd 5d d0             	fstpl  -0x30(%ebp)
    print_str_lenght(p->name, 11);
80104633:	e8 68 fc ff ff       	call   801042a0 <print_str_lenght>
    if(p->pid < 10)
80104638:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010463b:	83 c4 10             	add    $0x10,%esp
8010463e:	83 f8 09             	cmp    $0x9,%eax
80104641:	0f 8e a1 fe ff ff    	jle    801044e8 <print_procs_info+0x68>
      cprintf("%d  ", p->pid);
80104647:	83 ec 08             	sub    $0x8,%esp
8010464a:	50                   	push   %eax
8010464b:	68 c1 8a 10 80       	push   $0x80108ac1
80104650:	e8 5b c0 ff ff       	call   801006b0 <cprintf>
80104655:	83 c4 10             	add    $0x10,%esp
80104658:	e9 9c fe ff ff       	jmp    801044f9 <print_procs_info+0x79>
8010465d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("%d       ", p->num_tickets);
80104660:	83 ec 08             	sub    $0x8,%esp
80104663:	50                   	push   %eax
80104664:	68 c6 8a 10 80       	push   $0x80108ac6
80104669:	e8 42 c0 ff ff       	call   801006b0 <cprintf>
8010466e:	83 c4 10             	add    $0x10,%esp
80104671:	e9 0a ff ff ff       	jmp    80104580 <print_procs_info+0x100>
80104676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("%d      ", p->num_tickets);
80104680:	83 ec 08             	sub    $0x8,%esp
80104683:	50                   	push   %eax
80104684:	68 d0 8a 10 80       	push   $0x80108ad0
80104689:	e8 22 c0 ff ff       	call   801006b0 <cprintf>
8010468e:	83 c4 10             	add    $0x10,%esp
80104691:	e9 ea fe ff ff       	jmp    80104580 <print_procs_info+0x100>
80104696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("%d     ", p->num_tickets);
801046a0:	83 ec 08             	sub    $0x8,%esp
801046a3:	50                   	push   %eax
801046a4:	68 d9 8a 10 80       	push   $0x80108ad9
801046a9:	e8 02 c0 ff ff       	call   801006b0 <cprintf>
801046ae:	83 c4 10             	add    $0x10,%esp
801046b1:	e9 ca fe ff ff       	jmp    80104580 <print_procs_info+0x100>
801046b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("%d    ", p->num_tickets);
801046c0:	83 ec 08             	sub    $0x8,%esp
801046c3:	50                   	push   %eax
801046c4:	68 e1 8a 10 80       	push   $0x80108ae1
801046c9:	e8 e2 bf ff ff       	call   801006b0 <cprintf>
801046ce:	83 c4 10             	add    $0x10,%esp
801046d1:	e9 aa fe ff ff       	jmp    80104580 <print_procs_info+0x100>
801046d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("%d   ", p->num_tickets);
801046e0:	83 ec 08             	sub    $0x8,%esp
801046e3:	50                   	push   %eax
801046e4:	68 bb 8a 10 80       	push   $0x80108abb
801046e9:	e8 c2 bf ff ff       	call   801006b0 <cprintf>
801046ee:	83 c4 10             	add    $0x10,%esp
801046f1:	e9 8a fe ff ff       	jmp    80104580 <print_procs_info+0x100>
801046f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("%d", p->num_tickets);
80104700:	83 ec 08             	sub    $0x8,%esp
80104703:	50                   	push   %eax
80104704:	68 ec 8a 10 80       	push   $0x80108aec
80104709:	e8 a2 bf ff ff       	call   801006b0 <cprintf>
8010470e:	83 c4 10             	add    $0x10,%esp
80104711:	e9 6a fe ff ff       	jmp    80104580 <print_procs_info+0x100>
80104716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("%d  ", p->num_tickets);
80104720:	83 ec 08             	sub    $0x8,%esp
80104723:	50                   	push   %eax
80104724:	68 c1 8a 10 80       	push   $0x80108ac1
80104729:	e8 82 bf ff ff       	call   801006b0 <cprintf>
8010472e:	83 c4 10             	add    $0x10,%esp
80104731:	e9 4a fe ff ff       	jmp    80104580 <print_procs_info+0x100>
80104736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473d:	8d 76 00             	lea    0x0(%esi),%esi
  cprintf("\n");
80104740:	83 ec 0c             	sub    $0xc,%esp
80104743:	68 f2 8a 10 80       	push   $0x80108af2
80104748:	e8 63 bf ff ff       	call   801006b0 <cprintf>
}
8010474d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104750:	83 c4 10             	add    $0x10,%esp
80104753:	c9                   	leave  
80104754:	c3                   	ret    
80104755:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104760 <change_queue>:
change_queue(int pid , int new_queue){
80104760:	f3 0f 1e fb          	endbr32 
80104764:	55                   	push   %ebp
80104765:	89 e5                	mov    %esp,%ebp
80104767:	56                   	push   %esi
80104768:	53                   	push   %ebx
80104769:	8b 75 0c             	mov    0xc(%ebp),%esi
8010476c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010476f:	83 ec 0c             	sub    $0xc,%esp
80104772:	68 40 4e 11 80       	push   $0x80114e40
80104777:	e8 74 0f 00 00       	call   801056f0 <acquire>
8010477c:	83 c4 10             	add    $0x10,%esp
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010477f:	b8 74 4e 11 80       	mov    $0x80114e74,%eax
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == UNUSED || p->pid != pid)
80104788:	8b 50 0c             	mov    0xc(%eax),%edx
8010478b:	85 d2                	test   %edx,%edx
8010478d:	74 0b                	je     8010479a <change_queue+0x3a>
8010478f:	39 58 10             	cmp    %ebx,0x10(%eax)
80104792:	75 06                	jne    8010479a <change_queue+0x3a>
    p->q_level = new_queue;
80104794:	89 b0 f0 00 00 00    	mov    %esi,0xf0(%eax)
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010479a:	05 24 01 00 00       	add    $0x124,%eax
8010479f:	3d 74 97 11 80       	cmp    $0x80119774,%eax
801047a4:	75 e2                	jne    80104788 <change_queue+0x28>
  release(&ptable.lock);
801047a6:	c7 45 08 40 4e 11 80 	movl   $0x80114e40,0x8(%ebp)
}
801047ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047b0:	5b                   	pop    %ebx
801047b1:	5e                   	pop    %esi
801047b2:	5d                   	pop    %ebp
  release(&ptable.lock);
801047b3:	e9 f8 0f 00 00       	jmp    801057b0 <release>
801047b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047bf:	90                   	nop

801047c0 <change_ticket>:
change_ticket(int pid, int new_ticket){
801047c0:	f3 0f 1e fb          	endbr32 
801047c4:	55                   	push   %ebp
801047c5:	89 e5                	mov    %esp,%ebp
801047c7:	56                   	push   %esi
801047c8:	53                   	push   %ebx
801047c9:	8b 75 0c             	mov    0xc(%ebp),%esi
801047cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801047cf:	83 ec 0c             	sub    $0xc,%esp
801047d2:	68 40 4e 11 80       	push   $0x80114e40
801047d7:	e8 14 0f 00 00       	call   801056f0 <acquire>
801047dc:	83 c4 10             	add    $0x10,%esp
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047df:	b8 74 4e 11 80       	mov    $0x80114e74,%eax
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == UNUSED || p->pid != pid)
801047e8:	8b 50 0c             	mov    0xc(%eax),%edx
801047eb:	85 d2                	test   %edx,%edx
801047ed:	74 0b                	je     801047fa <change_ticket+0x3a>
801047ef:	39 58 10             	cmp    %ebx,0x10(%eax)
801047f2:	75 06                	jne    801047fa <change_ticket+0x3a>
    p->num_tickets = new_ticket;
801047f4:	89 b0 f4 00 00 00    	mov    %esi,0xf4(%eax)
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047fa:	05 24 01 00 00       	add    $0x124,%eax
801047ff:	3d 74 97 11 80       	cmp    $0x80119774,%eax
80104804:	75 e2                	jne    801047e8 <change_ticket+0x28>
  release(&ptable.lock);
80104806:	c7 45 08 40 4e 11 80 	movl   $0x80114e40,0x8(%ebp)
}
8010480d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104810:	5b                   	pop    %ebx
80104811:	5e                   	pop    %esi
80104812:	5d                   	pop    %ebp
  release(&ptable.lock);
80104813:	e9 98 0f 00 00       	jmp    801057b0 <release>
80104818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop

80104820 <stod>:
double stod(const char* s){    //definition
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	83 ec 08             	sub    $0x8,%esp
8010482a:	8b 55 08             	mov    0x8(%ebp),%edx
    if (*s == '-'){
8010482d:	0f be 02             	movsbl (%edx),%eax
80104830:	3c 2d                	cmp    $0x2d,%al
80104832:	74 5c                	je     80104890 <stod+0x70>
    double rez = 0, fact = 1;
80104834:	d9 e8                	fld1   
    for (int point_seen = 0; *s; s++){
80104836:	84 c0                	test   %al,%al
80104838:	74 65                	je     8010489f <stod+0x7f>
8010483a:	31 c9                	xor    %ecx,%ecx
8010483c:	d9 ee                	fldz   
8010483e:	eb 2f                	jmp    8010486f <stod+0x4f>
        int d = *s - '0';
80104840:	83 e8 30             	sub    $0x30,%eax
        if (d >= 0 && d <= 9){
80104843:	83 f8 09             	cmp    $0x9,%eax
80104846:	77 1c                	ja     80104864 <stod+0x44>
            if (point_seen) fact /= 10.0f;
80104848:	85 c9                	test   %ecx,%ecx
8010484a:	74 0a                	je     80104856 <stod+0x36>
8010484c:	d9 c9                	fxch   %st(1)
8010484e:	d8 35 08 8d 10 80    	fdivs  0x80108d08
80104854:	d9 c9                	fxch   %st(1)
            rez = rez * 10.0f + (float)d;
80104856:	d8 0d 08 8d 10 80    	fmuls  0x80108d08
8010485c:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010485f:	db 45 fc             	fildl  -0x4(%ebp)
80104862:	de c1                	faddp  %st,%st(1)
    for (int point_seen = 0; *s; s++){
80104864:	0f be 42 01          	movsbl 0x1(%edx),%eax
80104868:	83 c2 01             	add    $0x1,%edx
8010486b:	84 c0                	test   %al,%al
8010486d:	74 14                	je     80104883 <stod+0x63>
        if (*s == '.'){
8010486f:	3c 2e                	cmp    $0x2e,%al
80104871:	75 cd                	jne    80104840 <stod+0x20>
    for (int point_seen = 0; *s; s++){
80104873:	0f be 42 01          	movsbl 0x1(%edx),%eax
80104877:	83 c2 01             	add    $0x1,%edx
            point_seen = 1;
8010487a:	b9 01 00 00 00       	mov    $0x1,%ecx
    for (int point_seen = 0; *s; s++){
8010487f:	84 c0                	test   %al,%al
80104881:	75 ec                	jne    8010486f <stod+0x4f>
}
80104883:	c9                   	leave  
    return rez * fact;
80104884:	de c9                	fmulp  %st,%st(1)
}
80104886:	c3                   	ret    
80104887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488e:	66 90                	xchg   %ax,%ax
        fact = -1;
80104890:	0f be 42 01          	movsbl 0x1(%edx),%eax
80104894:	d9 e8                	fld1   
        s++;
80104896:	83 c2 01             	add    $0x1,%edx
        fact = -1;
80104899:	d9 e0                	fchs   
    for (int point_seen = 0; *s; s++){
8010489b:	84 c0                	test   %al,%al
8010489d:	75 9b                	jne    8010483a <stod+0x1a>
}
8010489f:	c9                   	leave  
    for (int point_seen = 0; *s; s++){
801048a0:	d9 ee                	fldz   
    return rez * fact;
801048a2:	de c9                	fmulp  %st,%st(1)
}
801048a4:	c3                   	ret    
801048a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048b0 <change_BJF_parameters_individual>:
change_BJF_parameters_individual(int pid, char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
801048b0:	f3 0f 1e fb          	endbr32 
801048b4:	55                   	push   %ebp
801048b5:	89 e5                	mov    %esp,%ebp
801048b7:	57                   	push   %edi
801048b8:	56                   	push   %esi
801048b9:	53                   	push   %ebx
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048ba:	bb 74 4e 11 80       	mov    $0x80114e74,%ebx
change_BJF_parameters_individual(int pid, char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
801048bf:	83 ec 28             	sub    $0x28,%esp
801048c2:	8b 45 10             	mov    0x10(%ebp),%eax
801048c5:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&ptable.lock);
801048c8:	68 40 4e 11 80       	push   $0x80114e40
change_BJF_parameters_individual(int pid, char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
801048cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
801048d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801048d3:	8b 45 14             	mov    0x14(%ebp),%eax
801048d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  acquire(&ptable.lock);
801048d9:	e8 12 0e 00 00       	call   801056f0 <acquire>
801048de:	83 c4 10             	add    $0x10,%esp
801048e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == UNUSED || p->pid != pid)
801048e8:	8b 4b 0c             	mov    0xc(%ebx),%ecx
801048eb:	85 c9                	test   %ecx,%ecx
801048ed:	74 35                	je     80104924 <change_BJF_parameters_individual+0x74>
801048ef:	39 73 10             	cmp    %esi,0x10(%ebx)
801048f2:	75 30                	jne    80104924 <change_BJF_parameters_individual+0x74>
    p->priority_ratio = stod(priority_ratio);
801048f4:	83 ec 0c             	sub    $0xc,%esp
801048f7:	57                   	push   %edi
801048f8:	e8 23 ff ff ff       	call   80104820 <stod>
801048fd:	58                   	pop    %eax
    p->arrival_ratio = stod(arrival_ratio);
801048fe:	ff 75 e4             	pushl  -0x1c(%ebp)
    p->priority_ratio = stod(priority_ratio);
80104901:	dd 9b 0c 01 00 00    	fstpl  0x10c(%ebx)
    p->arrival_ratio = stod(arrival_ratio);
80104907:	e8 14 ff ff ff       	call   80104820 <stod>
8010490c:	5a                   	pop    %edx
    p->executed_cycle_ratio = stod(executed_cycle_ratio);
8010490d:	ff 75 e0             	pushl  -0x20(%ebp)
    p->arrival_ratio = stod(arrival_ratio);
80104910:	dd 9b 14 01 00 00    	fstpl  0x114(%ebx)
    p->executed_cycle_ratio = stod(executed_cycle_ratio);
80104916:	e8 05 ff ff ff       	call   80104820 <stod>
8010491b:	83 c4 10             	add    $0x10,%esp
8010491e:	dd 9b 1c 01 00 00    	fstpl  0x11c(%ebx)
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104924:	81 c3 24 01 00 00    	add    $0x124,%ebx
8010492a:	81 fb 74 97 11 80    	cmp    $0x80119774,%ebx
80104930:	75 b6                	jne    801048e8 <change_BJF_parameters_individual+0x38>
  release(&ptable.lock);
80104932:	c7 45 08 40 4e 11 80 	movl   $0x80114e40,0x8(%ebp)
}
80104939:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010493c:	5b                   	pop    %ebx
8010493d:	5e                   	pop    %esi
8010493e:	5f                   	pop    %edi
8010493f:	5d                   	pop    %ebp
  release(&ptable.lock);
80104940:	e9 6b 0e 00 00       	jmp    801057b0 <release>
80104945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104950 <change_BJF_parameters_all>:
change_BJF_parameters_all(char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	57                   	push   %edi
80104958:	56                   	push   %esi
80104959:	53                   	push   %ebx
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010495a:	bb 74 4e 11 80       	mov    $0x80114e74,%ebx
change_BJF_parameters_all(char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
8010495f:	83 ec 28             	sub    $0x28,%esp
80104962:	8b 45 10             	mov    0x10(%ebp),%eax
80104965:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&ptable.lock);
80104968:	68 40 4e 11 80       	push   $0x80114e40
change_BJF_parameters_all(char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
8010496d:	8b 75 0c             	mov    0xc(%ebp),%esi
80104970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&ptable.lock);
80104973:	e8 78 0d 00 00       	call   801056f0 <acquire>
80104978:	83 c4 10             	add    $0x10,%esp
8010497b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010497f:	90                   	nop
    if(p->state == UNUSED)
80104980:	8b 53 0c             	mov    0xc(%ebx),%edx
80104983:	85 d2                	test   %edx,%edx
80104985:	74 2f                	je     801049b6 <change_BJF_parameters_all+0x66>
    p->priority_ratio = stod(priority_ratio);
80104987:	83 ec 0c             	sub    $0xc,%esp
8010498a:	57                   	push   %edi
8010498b:	e8 90 fe ff ff       	call   80104820 <stod>
    p->arrival_ratio = stod(arrival_ratio);
80104990:	89 34 24             	mov    %esi,(%esp)
    p->priority_ratio = stod(priority_ratio);
80104993:	dd 9b 0c 01 00 00    	fstpl  0x10c(%ebx)
    p->arrival_ratio = stod(arrival_ratio);
80104999:	e8 82 fe ff ff       	call   80104820 <stod>
8010499e:	58                   	pop    %eax
    p->executed_cycle_ratio = stod(executed_cycle_ratio);
8010499f:	ff 75 e4             	pushl  -0x1c(%ebp)
    p->arrival_ratio = stod(arrival_ratio);
801049a2:	dd 9b 14 01 00 00    	fstpl  0x114(%ebx)
    p->executed_cycle_ratio = stod(executed_cycle_ratio);
801049a8:	e8 73 fe ff ff       	call   80104820 <stod>
801049ad:	83 c4 10             	add    $0x10,%esp
801049b0:	dd 9b 1c 01 00 00    	fstpl  0x11c(%ebx)
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b6:	81 c3 24 01 00 00    	add    $0x124,%ebx
801049bc:	81 fb 74 97 11 80    	cmp    $0x80119774,%ebx
801049c2:	75 bc                	jne    80104980 <change_BJF_parameters_all+0x30>
  release(&ptable.lock);
801049c4:	c7 45 08 40 4e 11 80 	movl   $0x80114e40,0x8(%ebp)
}
801049cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049ce:	5b                   	pop    %ebx
801049cf:	5e                   	pop    %esi
801049d0:	5f                   	pop    %edi
801049d1:	5d                   	pop    %ebp
  release(&ptable.lock);
801049d2:	e9 d9 0d 00 00       	jmp    801057b0 <release>
801049d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049de:	66 90                	xchg   %ax,%ax

801049e0 <rand_r>:
{
801049e0:	f3 0f 1e fb          	endbr32 
801049e4:	55                   	push   %ebp
801049e5:	89 e5                	mov    %esp,%ebp
801049e7:	53                   	push   %ebx
801049e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  next *= 1103515245;
801049eb:	69 01 6d 4e c6 41    	imul   $0x41c64e6d,(%ecx),%eax
  next += 12345;
801049f1:	05 39 30 00 00       	add    $0x3039,%eax
  next *= 1103515245;
801049f6:	69 d0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%edx
  result <<= 10;
801049fc:	c1 e8 06             	shr    $0x6,%eax
801049ff:	25 00 fc 1f 00       	and    $0x1ffc00,%eax
  next += 12345;
80104a04:	81 c2 39 30 00 00    	add    $0x3039,%edx
  result ^= (unsigned int) (next / 65536) % 1024;
80104a0a:	89 d3                	mov    %edx,%ebx
  next *= 1103515245;
80104a0c:	69 d2 6d 4e c6 41    	imul   $0x41c64e6d,%edx,%edx
  result ^= (unsigned int) (next / 65536) % 1024;
80104a12:	c1 eb 10             	shr    $0x10,%ebx
80104a15:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  next += 12345;
80104a1b:	81 c2 39 30 00 00    	add    $0x3039,%edx
  result ^= (unsigned int) (next / 65536) % 1024;
80104a21:	09 d8                	or     %ebx,%eax
  result ^= (unsigned int) (next / 65536) % 1024;
80104a23:	89 d3                	mov    %edx,%ebx
  result <<= 10;
80104a25:	c1 e0 0a             	shl    $0xa,%eax
  *seed = next;
80104a28:	89 11                	mov    %edx,(%ecx)
  result ^= (unsigned int) (next / 65536) % 1024;
80104a2a:	c1 eb 10             	shr    $0x10,%ebx
80104a2d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80104a33:	31 d8                	xor    %ebx,%eax
}
80104a35:	5b                   	pop    %ebx
80104a36:	5d                   	pop    %ebp
80104a37:	c3                   	ret    
80104a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3f:	90                   	nop

80104a40 <scheduler>:
{
80104a40:	f3 0f 1e fb          	endbr32 
80104a44:	55                   	push   %ebp
80104a45:	89 e5                	mov    %esp,%ebp
80104a47:	57                   	push   %edi
80104a48:	56                   	push   %esi
80104a49:	53                   	push   %ebx
  unsigned int seed = 1;
80104a4a:	bb 01 00 00 00       	mov    $0x1,%ebx
{
80104a4f:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c = mycpu();
80104a52:	e8 89 f2 ff ff       	call   80103ce0 <mycpu>
  c->proc = 0;
80104a57:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104a5e:	00 00 00 
  struct cpu *c = mycpu();
80104a61:	89 c7                	mov    %eax,%edi
  unsigned int seed = 1;
80104a63:	8d 40 04             	lea    0x4(%eax),%eax
80104a66:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  asm volatile("sti");
80104a69:	fb                   	sti    
    acquire(&ptable.lock);
80104a6a:	83 ec 0c             	sub    $0xc,%esp
    proc_count[0] = 0;
80104a6d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    acquire(&ptable.lock);
80104a74:	68 40 4e 11 80       	push   $0x80114e40
    proc_count[1] = 0;
80104a79:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    proc_count[2] = 0;
80104a80:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    proc_count[3] = 0;
80104a87:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    acquire(&ptable.lock);
80104a8e:	e8 5d 0c 00 00       	call   801056f0 <acquire>
80104a93:	83 c4 10             	add    $0x10,%esp
    int total_tickets = 0;
80104a96:	31 d2                	xor    %edx,%edx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a98:	b8 74 4e 11 80       	mov    $0x80114e74,%eax
80104a9d:	eb 0d                	jmp    80104aac <scheduler+0x6c>
80104a9f:	90                   	nop
80104aa0:	05 24 01 00 00       	add    $0x124,%eax
80104aa5:	3d 74 97 11 80       	cmp    $0x80119774,%eax
80104aaa:	74 4c                	je     80104af8 <scheduler+0xb8>
      if(p->state == RUNNABLE)
80104aac:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104ab0:	75 ee                	jne    80104aa0 <scheduler+0x60>
        if (p->age > AGE_THRESH && p->q_level > 1)
80104ab2:	81 b8 f8 00 00 00 10 	cmpl   $0x2710,0xf8(%eax)
80104ab9:	27 00 00 
80104abc:	8b 88 f0 00 00 00    	mov    0xf0(%eax),%ecx
80104ac2:	7e 18                	jle    80104adc <scheduler+0x9c>
80104ac4:	83 f9 01             	cmp    $0x1,%ecx
80104ac7:	76 1e                	jbe    80104ae7 <scheduler+0xa7>
          p->age = 0;
80104ac9:	c7 80 f8 00 00 00 00 	movl   $0x0,0xf8(%eax)
80104ad0:	00 00 00 
          p->q_level = p->q_level - 1;
80104ad3:	83 e9 01             	sub    $0x1,%ecx
80104ad6:	89 88 f0 00 00 00    	mov    %ecx,0xf0(%eax)
        if(p->q_level == 2)
80104adc:	83 f9 02             	cmp    $0x2,%ecx
80104adf:	75 06                	jne    80104ae7 <scheduler+0xa7>
          total_tickets += p->num_tickets;
80104ae1:	03 90 f4 00 00 00    	add    0xf4(%eax),%edx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ae7:	05 24 01 00 00       	add    $0x124,%eax
        proc_count[p->q_level]++;
80104aec:	83 44 8d d8 01       	addl   $0x1,-0x28(%ebp,%ecx,4)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104af1:	3d 74 97 11 80       	cmp    $0x80119774,%eax
80104af6:	75 b4                	jne    80104aac <scheduler+0x6c>
    if(proc_count[1] > 0)
80104af8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80104afb:	89 55 d0             	mov    %edx,-0x30(%ebp)
80104afe:	85 c9                	test   %ecx,%ecx
80104b00:	0f 8e e1 00 00 00    	jle    80104be7 <scheduler+0x1a7>
      for(p = ptable.proc; p < &ptable.proc[NPROC] ; p++){
80104b06:	be 74 4e 11 80       	mov    $0x80114e74,%esi
80104b0b:	eb 15                	jmp    80104b22 <scheduler+0xe2>
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi
80104b10:	81 c6 24 01 00 00    	add    $0x124,%esi
80104b16:	81 fe 74 97 11 80    	cmp    $0x80119774,%esi
80104b1c:	0f 84 b0 00 00 00    	je     80104bd2 <scheduler+0x192>
        if(p->state != RUNNABLE || p->q_level != 1)
80104b22:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80104b26:	75 e8                	jne    80104b10 <scheduler+0xd0>
80104b28:	83 be f0 00 00 00 01 	cmpl   $0x1,0xf0(%esi)
80104b2f:	75 df                	jne    80104b10 <scheduler+0xd0>
        for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
80104b31:	b8 74 4e 11 80       	mov    $0x80114e74,%eax
80104b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
          if(temp_proc->state == RUNNABLE && temp_proc != p)
80104b40:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104b44:	75 0b                	jne    80104b51 <scheduler+0x111>
80104b46:	39 c6                	cmp    %eax,%esi
80104b48:	74 07                	je     80104b51 <scheduler+0x111>
            temp_proc->age = temp_proc->age + 1;
80104b4a:	83 80 f8 00 00 00 01 	addl   $0x1,0xf8(%eax)
        for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
80104b51:	05 24 01 00 00       	add    $0x124,%eax
80104b56:	3d 74 97 11 80       	cmp    $0x80119774,%eax
80104b5b:	75 e3                	jne    80104b40 <scheduler+0x100>
        seed = (seed + 1) % 10000;
80104b5d:	8d 4b 01             	lea    0x1(%ebx),%ecx
80104b60:	b8 59 17 b7 d1       	mov    $0xd1b71759,%eax
        switchuvm(p);
80104b65:	83 ec 0c             	sub    $0xc,%esp
        p->cycle_count++;
80104b68:	83 86 fc 00 00 00 01 	addl   $0x1,0xfc(%esi)
        p->age = 0;
80104b6f:	c7 86 f8 00 00 00 00 	movl   $0x0,0xf8(%esi)
80104b76:	00 00 00 
        seed = (seed + 1) % 10000;
80104b79:	f7 e1                	mul    %ecx
80104b7b:	89 cb                	mov    %ecx,%ebx
        c->proc = p;
80104b7d:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
        switchuvm(p);
80104b83:	56                   	push   %esi
      for(p = ptable.proc; p < &ptable.proc[NPROC] ; p++){
80104b84:	81 c6 24 01 00 00    	add    $0x124,%esi
        seed = (seed + 1) % 10000;
80104b8a:	c1 ea 0d             	shr    $0xd,%edx
80104b8d:	69 d2 10 27 00 00    	imul   $0x2710,%edx,%edx
80104b93:	29 d3                	sub    %edx,%ebx
        switchuvm(p);
80104b95:	e8 26 32 00 00       	call   80107dc0 <switchuvm>
        p->state = RUNNING;
80104b9a:	c7 86 e8 fe ff ff 04 	movl   $0x4,-0x118(%esi)
80104ba1:	00 00 00 
        swtch(&(c->scheduler), p->context);
80104ba4:	59                   	pop    %ecx
80104ba5:	58                   	pop    %eax
80104ba6:	ff b6 f8 fe ff ff    	pushl  -0x108(%esi)
80104bac:	ff 75 d4             	pushl  -0x2c(%ebp)
80104baf:	e8 6f 0e 00 00       	call   80105a23 <swtch>
        switchkvm();
80104bb4:	e8 e7 31 00 00       	call   80107da0 <switchkvm>
        c->proc = 0;
80104bb9:	83 c4 10             	add    $0x10,%esp
80104bbc:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80104bc3:	00 00 00 
      for(p = ptable.proc; p < &ptable.proc[NPROC] ; p++){
80104bc6:	81 fe 74 97 11 80    	cmp    $0x80119774,%esi
80104bcc:	0f 85 50 ff ff ff    	jne    80104b22 <scheduler+0xe2>
    release(&ptable.lock);
80104bd2:	83 ec 0c             	sub    $0xc,%esp
80104bd5:	68 40 4e 11 80       	push   $0x80114e40
80104bda:	e8 d1 0b 00 00       	call   801057b0 <release>
80104bdf:	83 c4 10             	add    $0x10,%esp
80104be2:	e9 82 fe ff ff       	jmp    80104a69 <scheduler+0x29>
     if(proc_count[2] > 0 && proc_count[1] == 0)
80104be7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bea:	85 c0                	test   %eax,%eax
80104bec:	0f 8e 20 01 00 00    	jle    80104d12 <scheduler+0x2d2>
80104bf2:	85 c9                	test   %ecx,%ecx
80104bf4:	75 dc                	jne    80104bd2 <scheduler+0x192>
  next *= 1103515245;
80104bf6:	69 c3 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%eax
  next += 12345;
80104bfc:	05 39 30 00 00       	add    $0x3039,%eax
  next *= 1103515245;
80104c01:	69 d8 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%ebx
  result <<= 10;
80104c07:	c1 e8 06             	shr    $0x6,%eax
80104c0a:	25 00 fc 1f 00       	and    $0x1ffc00,%eax
  next += 12345;
80104c0f:	8d b3 39 30 00 00    	lea    0x3039(%ebx),%esi
  result ^= (unsigned int) (next / 65536) % 1024;
80104c15:	89 f3                	mov    %esi,%ebx
80104c17:	c1 eb 10             	shr    $0x10,%ebx
80104c1a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80104c20:	09 d8                	or     %ebx,%eax
80104c22:	89 c2                	mov    %eax,%edx
  next *= 1103515245;
80104c24:	69 c6 6d 4e c6 41    	imul   $0x41c64e6d,%esi,%eax
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c2a:	be 74 4e 11 80       	mov    $0x80114e74,%esi
  result <<= 10;
80104c2f:	c1 e2 0a             	shl    $0xa,%edx
  next += 12345;
80104c32:	8d 98 39 30 00 00    	lea    0x3039(%eax),%ebx
  next *= 1103515245;
80104c38:	89 45 cc             	mov    %eax,-0x34(%ebp)
  result ^= (unsigned int) (next / 65536) % 1024;
80104c3b:	89 d8                	mov    %ebx,%eax
80104c3d:	c1 e8 10             	shr    $0x10,%eax
80104c40:	25 ff 03 00 00       	and    $0x3ff,%eax
80104c45:	31 d0                	xor    %edx,%eax
      int golden_ticket = rand_r(&seed) % total_tickets;
80104c47:	99                   	cltd   
80104c48:	f7 7d d0             	idivl  -0x30(%ebp)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c4b:	eb 12                	jmp    80104c5f <scheduler+0x21f>
80104c4d:	81 c6 24 01 00 00    	add    $0x124,%esi
80104c53:	81 fe 74 97 11 80    	cmp    $0x80119774,%esi
80104c59:	0f 84 73 ff ff ff    	je     80104bd2 <scheduler+0x192>
        if(p->state != RUNNABLE || p->q_level != 2)
80104c5f:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80104c63:	75 e8                	jne    80104c4d <scheduler+0x20d>
80104c65:	83 be f0 00 00 00 02 	cmpl   $0x2,0xf0(%esi)
80104c6c:	75 df                	jne    80104c4d <scheduler+0x20d>
        if ((count + p->num_tickets) < golden_ticket)
80104c6e:	03 8e f4 00 00 00    	add    0xf4(%esi),%ecx
80104c74:	39 d1                	cmp    %edx,%ecx
80104c76:	7c d5                	jl     80104c4d <scheduler+0x20d>
        for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
80104c78:	b8 74 4e 11 80       	mov    $0x80114e74,%eax
          if(temp_proc->state == RUNNABLE && temp_proc != p)
80104c7d:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104c81:	75 0b                	jne    80104c8e <scheduler+0x24e>
80104c83:	39 c6                	cmp    %eax,%esi
80104c85:	74 07                	je     80104c8e <scheduler+0x24e>
            temp_proc->age = temp_proc->age + 1;
80104c87:	83 80 f8 00 00 00 01 	addl   $0x1,0xf8(%eax)
        for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
80104c8e:	05 24 01 00 00       	add    $0x124,%eax
80104c93:	3d 74 97 11 80       	cmp    $0x80119774,%eax
80104c98:	75 e3                	jne    80104c7d <scheduler+0x23d>
        seed = (seed + 1) % 10000;
80104c9a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
80104c9d:	b8 59 17 b7 d1       	mov    $0xd1b71759,%eax
        switchuvm(p);
80104ca2:	83 ec 0c             	sub    $0xc,%esp
        p->cycle_count++;
80104ca5:	83 86 fc 00 00 00 01 	addl   $0x1,0xfc(%esi)
        p->age = 0;
80104cac:	c7 86 f8 00 00 00 00 	movl   $0x0,0xf8(%esi)
80104cb3:	00 00 00 
        seed = (seed + 1) % 10000;
80104cb6:	81 c1 3a 30 00 00    	add    $0x303a,%ecx
        c->proc = p;
80104cbc:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
        seed = (seed + 1) % 10000;
80104cc2:	f7 e1                	mul    %ecx
        switchuvm(p);
80104cc4:	56                   	push   %esi
        seed = (seed + 1) % 10000;
80104cc5:	c1 ea 0d             	shr    $0xd,%edx
80104cc8:	69 da 10 27 00 00    	imul   $0x2710,%edx,%ebx
80104cce:	29 d9                	sub    %ebx,%ecx
80104cd0:	89 cb                	mov    %ecx,%ebx
        switchuvm(p);
80104cd2:	e8 e9 30 00 00       	call   80107dc0 <switchuvm>
        p->state = RUNNING;
80104cd7:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
        swtch(&(c->scheduler), p->context);
80104cde:	58                   	pop    %eax
80104cdf:	5a                   	pop    %edx
80104ce0:	ff 76 1c             	pushl  0x1c(%esi)
80104ce3:	ff 75 d4             	pushl  -0x2c(%ebp)
80104ce6:	e8 38 0d 00 00       	call   80105a23 <swtch>
        switchkvm();
80104ceb:	e8 b0 30 00 00       	call   80107da0 <switchkvm>
        break;
80104cf0:	83 c4 10             	add    $0x10,%esp
        c->proc = 0;
80104cf3:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80104cfa:	00 00 00 
    release(&ptable.lock);
80104cfd:	83 ec 0c             	sub    $0xc,%esp
80104d00:	68 40 4e 11 80       	push   $0x80114e40
80104d05:	e8 a6 0a 00 00       	call   801057b0 <release>
80104d0a:	83 c4 10             	add    $0x10,%esp
80104d0d:	e9 57 fd ff ff       	jmp    80104a69 <scheduler+0x29>
    if(proc_count[3] > 0 && proc_count[2] == 0 && proc_count[1] == 0)
80104d12:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104d15:	85 f6                	test   %esi,%esi
80104d17:	0f 8e b5 fe ff ff    	jle    80104bd2 <scheduler+0x192>
80104d1d:	09 c1                	or     %eax,%ecx
80104d1f:	0f 85 ad fe ff ff    	jne    80104bd2 <scheduler+0x192>
      double min_rank = 100000;
80104d25:	d9 05 0c 8d 10 80    	flds   0x80108d0c
      struct proc* run_proc = 0;
80104d2b:	31 f6                	xor    %esi,%esi
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d2d:	b8 74 4e 11 80       	mov    $0x80114e74,%eax
        if(p->state != RUNNABLE || p->q_level != 3)
80104d32:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104d36:	75 45                	jne    80104d7d <scheduler+0x33d>
80104d38:	83 b8 f0 00 00 00 03 	cmpl   $0x3,0xf0(%eax)
80104d3f:	75 3c                	jne    80104d7d <scheduler+0x33d>
        double priority = 1 / (double) p->num_tickets;
80104d41:	db 80 f4 00 00 00    	fildl  0xf4(%eax)
80104d47:	d8 3d 04 8d 10 80    	fdivrs 0x80108d04
        double rank = (priority * p->priority_ratio) + (p->arrival_time * p->arrival_ratio) \
80104d4d:	dc 88 0c 01 00 00    	fmull  0x10c(%eax)
80104d53:	db 80 00 01 00 00    	fildl  0x100(%eax)
80104d59:	dc 88 14 01 00 00    	fmull  0x114(%eax)
80104d5f:	de c1                	faddp  %st,%st(1)
                      + (p->executed_cycle * p->executed_cycle_ratio);
80104d61:	dd 80 04 01 00 00    	fldl   0x104(%eax)
80104d67:	dc 88 1c 01 00 00    	fmull  0x11c(%eax)
        double rank = (priority * p->priority_ratio) + (p->arrival_time * p->arrival_ratio) \
80104d6d:	de c1                	faddp  %st,%st(1)
80104d6f:	d9 c9                	fxch   %st(1)
        if(min_rank > rank)
80104d71:	db f1                	fcomi  %st(1),%st
80104d73:	76 06                	jbe    80104d7b <scheduler+0x33b>
80104d75:	dd d8                	fstp   %st(0)
80104d77:	89 c6                	mov    %eax,%esi
80104d79:	eb 02                	jmp    80104d7d <scheduler+0x33d>
80104d7b:	dd d9                	fstp   %st(1)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d7d:	05 24 01 00 00       	add    $0x124,%eax
80104d82:	3d 74 97 11 80       	cmp    $0x80119774,%eax
80104d87:	75 a9                	jne    80104d32 <scheduler+0x2f2>
80104d89:	dd d8                	fstp   %st(0)
      for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
80104d8b:	b8 74 4e 11 80       	mov    $0x80114e74,%eax
      if(!run_proc){
80104d90:	85 f6                	test   %esi,%esi
80104d92:	0f 84 3a fe ff ff    	je     80104bd2 <scheduler+0x192>
        if(temp_proc->state == RUNNABLE && temp_proc != run_proc)
80104d98:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104d9c:	75 0b                	jne    80104da9 <scheduler+0x369>
80104d9e:	39 c6                	cmp    %eax,%esi
80104da0:	74 07                	je     80104da9 <scheduler+0x369>
          temp_proc->age = temp_proc->age + 1;
80104da2:	83 80 f8 00 00 00 01 	addl   $0x1,0xf8(%eax)
      for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
80104da9:	05 24 01 00 00       	add    $0x124,%eax
80104dae:	3d 74 97 11 80       	cmp    $0x80119774,%eax
80104db3:	75 e3                	jne    80104d98 <scheduler+0x358>
      seed = (seed + 1) % 10000;
80104db5:	8d 4b 01             	lea    0x1(%ebx),%ecx
80104db8:	b8 59 17 b7 d1       	mov    $0xd1b71759,%eax
      switchuvm(run_proc);
80104dbd:	83 ec 0c             	sub    $0xc,%esp
      p->age = 0;
80104dc0:	c7 05 6c 98 11 80 00 	movl   $0x0,0x8011986c
80104dc7:	00 00 00 
      seed = (seed + 1) % 10000;
80104dca:	f7 e1                	mul    %ecx
      run_proc->cycle_count++;
80104dcc:	83 86 fc 00 00 00 01 	addl   $0x1,0xfc(%esi)
      c->proc = run_proc;
80104dd3:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
      switchuvm(run_proc);
80104dd9:	56                   	push   %esi
      seed = (seed + 1) % 10000;
80104dda:	c1 ea 0d             	shr    $0xd,%edx
80104ddd:	69 da 10 27 00 00    	imul   $0x2710,%edx,%ebx
80104de3:	29 d9                	sub    %ebx,%ecx
80104de5:	89 cb                	mov    %ecx,%ebx
      switchuvm(run_proc);
80104de7:	e8 d4 2f 00 00       	call   80107dc0 <switchuvm>
      run_proc->state = RUNNING;
80104dec:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
      swtch(&(c->scheduler), run_proc->context);
80104df3:	58                   	pop    %eax
80104df4:	5a                   	pop    %edx
80104df5:	ff 76 1c             	pushl  0x1c(%esi)
80104df8:	ff 75 d4             	pushl  -0x2c(%ebp)
80104dfb:	e8 23 0c 00 00       	call   80105a23 <swtch>
      switchkvm();
80104e00:	e8 9b 2f 00 00       	call   80107da0 <switchkvm>
      run_proc->executed_cycle += 0.1;
80104e05:	dd 05 f8 8c 10 80    	fldl   0x80108cf8
      c->proc = 0;
80104e0b:	83 c4 10             	add    $0x10,%esp
      run_proc->executed_cycle += 0.1;
80104e0e:	dc 86 04 01 00 00    	faddl  0x104(%esi)
    release(&ptable.lock);
80104e14:	83 ec 0c             	sub    $0xc,%esp
      run_proc->executed_cycle += 0.1;
80104e17:	dd 9e 04 01 00 00    	fstpl  0x104(%esi)
      c->proc = 0;
80104e1d:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80104e24:	00 00 00 
    release(&ptable.lock);
80104e27:	68 40 4e 11 80       	push   $0x80114e40
80104e2c:	e8 7f 09 00 00       	call   801057b0 <release>
80104e31:	83 c4 10             	add    $0x10,%esp
80104e34:	e9 30 fc ff ff       	jmp    80104a69 <scheduler+0x29>
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e40 <sched>:
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	56                   	push   %esi
80104e48:	53                   	push   %ebx
  pushcli();
80104e49:	e8 a2 07 00 00       	call   801055f0 <pushcli>
  c = mycpu();
80104e4e:	e8 8d ee ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80104e53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104e59:	e8 e2 07 00 00       	call   80105640 <popcli>
  if(!holding(&ptable.lock))
80104e5e:	83 ec 0c             	sub    $0xc,%esp
80104e61:	68 40 4e 11 80       	push   $0x80114e40
80104e66:	e8 35 08 00 00       	call   801056a0 <holding>
80104e6b:	83 c4 10             	add    $0x10,%esp
80104e6e:	85 c0                	test   %eax,%eax
80104e70:	74 4f                	je     80104ec1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104e72:	e8 69 ee ff ff       	call   80103ce0 <mycpu>
80104e77:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80104e7e:	75 68                	jne    80104ee8 <sched+0xa8>
  if(p->state == RUNNING)
80104e80:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104e84:	74 55                	je     80104edb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e86:	9c                   	pushf  
80104e87:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e88:	f6 c4 02             	test   $0x2,%ah
80104e8b:	75 41                	jne    80104ece <sched+0x8e>
  intena = mycpu()->intena;
80104e8d:	e8 4e ee ff ff       	call   80103ce0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104e92:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104e95:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104e9b:	e8 40 ee ff ff       	call   80103ce0 <mycpu>
80104ea0:	83 ec 08             	sub    $0x8,%esp
80104ea3:	ff 70 04             	pushl  0x4(%eax)
80104ea6:	53                   	push   %ebx
80104ea7:	e8 77 0b 00 00       	call   80105a23 <swtch>
  mycpu()->intena = intena;
80104eac:	e8 2f ee ff ff       	call   80103ce0 <mycpu>
}
80104eb1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104eb4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104eba:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ebd:	5b                   	pop    %ebx
80104ebe:	5e                   	pop    %esi
80104ebf:	5d                   	pop    %ebp
80104ec0:	c3                   	ret    
    panic("sched ptable.lock");
80104ec1:	83 ec 0c             	sub    $0xc,%esp
80104ec4:	68 f4 8a 10 80       	push   $0x80108af4
80104ec9:	e8 c2 b4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80104ece:	83 ec 0c             	sub    $0xc,%esp
80104ed1:	68 20 8b 10 80       	push   $0x80108b20
80104ed6:	e8 b5 b4 ff ff       	call   80100390 <panic>
    panic("sched running");
80104edb:	83 ec 0c             	sub    $0xc,%esp
80104ede:	68 12 8b 10 80       	push   $0x80108b12
80104ee3:	e8 a8 b4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104ee8:	83 ec 0c             	sub    $0xc,%esp
80104eeb:	68 06 8b 10 80       	push   $0x80108b06
80104ef0:	e8 9b b4 ff ff       	call   80100390 <panic>
80104ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f00 <exit>:
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	57                   	push   %edi
80104f08:	56                   	push   %esi
80104f09:	53                   	push   %ebx
80104f0a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104f0d:	e8 de 06 00 00       	call   801055f0 <pushcli>
  c = mycpu();
80104f12:	e8 c9 ed ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80104f17:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104f1d:	e8 1e 07 00 00       	call   80105640 <popcli>
  if(curproc == initproc)
80104f22:	8d 5e 28             	lea    0x28(%esi),%ebx
80104f25:	8d 7e 68             	lea    0x68(%esi),%edi
80104f28:	39 35 38 c6 10 80    	cmp    %esi,0x8010c638
80104f2e:	0f 84 fd 00 00 00    	je     80105031 <exit+0x131>
80104f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104f38:	8b 03                	mov    (%ebx),%eax
80104f3a:	85 c0                	test   %eax,%eax
80104f3c:	74 12                	je     80104f50 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80104f3e:	83 ec 0c             	sub    $0xc,%esp
80104f41:	50                   	push   %eax
80104f42:	e8 e9 c2 ff ff       	call   80101230 <fileclose>
      curproc->ofile[fd] = 0;
80104f47:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104f4d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104f50:	83 c3 04             	add    $0x4,%ebx
80104f53:	39 df                	cmp    %ebx,%edi
80104f55:	75 e1                	jne    80104f38 <exit+0x38>
  begin_op();
80104f57:	e8 44 e1 ff ff       	call   801030a0 <begin_op>
  iput(curproc->cwd);
80104f5c:	83 ec 0c             	sub    $0xc,%esp
80104f5f:	ff 76 68             	pushl  0x68(%esi)
80104f62:	e8 99 cc ff ff       	call   80101c00 <iput>
  end_op();
80104f67:	e8 a4 e1 ff ff       	call   80103110 <end_op>
  curproc->cwd = 0;
80104f6c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104f73:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104f7a:	e8 71 07 00 00       	call   801056f0 <acquire>
  wakeup1(curproc->parent);
80104f7f:	8b 56 14             	mov    0x14(%esi),%edx
80104f82:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f85:	b8 74 4e 11 80       	mov    $0x80114e74,%eax
80104f8a:	eb 10                	jmp    80104f9c <exit+0x9c>
80104f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f90:	05 24 01 00 00       	add    $0x124,%eax
80104f95:	3d 74 97 11 80       	cmp    $0x80119774,%eax
80104f9a:	74 1e                	je     80104fba <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80104f9c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104fa0:	75 ee                	jne    80104f90 <exit+0x90>
80104fa2:	3b 50 20             	cmp    0x20(%eax),%edx
80104fa5:	75 e9                	jne    80104f90 <exit+0x90>
      p->state = RUNNABLE;
80104fa7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fae:	05 24 01 00 00       	add    $0x124,%eax
80104fb3:	3d 74 97 11 80       	cmp    $0x80119774,%eax
80104fb8:	75 e2                	jne    80104f9c <exit+0x9c>
      p->parent = initproc;
80104fba:	8b 0d 38 c6 10 80    	mov    0x8010c638,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fc0:	ba 74 4e 11 80       	mov    $0x80114e74,%edx
80104fc5:	eb 17                	jmp    80104fde <exit+0xde>
80104fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fce:	66 90                	xchg   %ax,%ax
80104fd0:	81 c2 24 01 00 00    	add    $0x124,%edx
80104fd6:	81 fa 74 97 11 80    	cmp    $0x80119774,%edx
80104fdc:	74 3a                	je     80105018 <exit+0x118>
    if(p->parent == curproc){
80104fde:	39 72 14             	cmp    %esi,0x14(%edx)
80104fe1:	75 ed                	jne    80104fd0 <exit+0xd0>
      if(p->state == ZOMBIE)
80104fe3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104fe7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104fea:	75 e4                	jne    80104fd0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fec:	b8 74 4e 11 80       	mov    $0x80114e74,%eax
80104ff1:	eb 11                	jmp    80105004 <exit+0x104>
80104ff3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ff7:	90                   	nop
80104ff8:	05 24 01 00 00       	add    $0x124,%eax
80104ffd:	3d 74 97 11 80       	cmp    $0x80119774,%eax
80105002:	74 cc                	je     80104fd0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80105004:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105008:	75 ee                	jne    80104ff8 <exit+0xf8>
8010500a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010500d:	75 e9                	jne    80104ff8 <exit+0xf8>
      p->state = RUNNABLE;
8010500f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80105016:	eb e0                	jmp    80104ff8 <exit+0xf8>
  curproc->state = ZOMBIE;
80105018:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010501f:	e8 1c fe ff ff       	call   80104e40 <sched>
  panic("zombie exit");
80105024:	83 ec 0c             	sub    $0xc,%esp
80105027:	68 41 8b 10 80       	push   $0x80108b41
8010502c:	e8 5f b3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80105031:	83 ec 0c             	sub    $0xc,%esp
80105034:	68 34 8b 10 80       	push   $0x80108b34
80105039:	e8 52 b3 ff ff       	call   80100390 <panic>
8010503e:	66 90                	xchg   %ax,%ax

80105040 <yield>:
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	53                   	push   %ebx
80105048:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010504b:	68 40 4e 11 80       	push   $0x80114e40
80105050:	e8 9b 06 00 00       	call   801056f0 <acquire>
  pushcli();
80105055:	e8 96 05 00 00       	call   801055f0 <pushcli>
  c = mycpu();
8010505a:	e8 81 ec ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
8010505f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105065:	e8 d6 05 00 00       	call   80105640 <popcli>
  myproc()->state = RUNNABLE;
8010506a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80105071:	e8 ca fd ff ff       	call   80104e40 <sched>
  release(&ptable.lock);
80105076:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
8010507d:	e8 2e 07 00 00       	call   801057b0 <release>
}
80105082:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105085:	83 c4 10             	add    $0x10,%esp
80105088:	c9                   	leave  
80105089:	c3                   	ret    
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105090 <sleep>:
{
80105090:	f3 0f 1e fb          	endbr32 
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	57                   	push   %edi
80105098:	56                   	push   %esi
80105099:	53                   	push   %ebx
8010509a:	83 ec 0c             	sub    $0xc,%esp
8010509d:	8b 7d 08             	mov    0x8(%ebp),%edi
801050a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801050a3:	e8 48 05 00 00       	call   801055f0 <pushcli>
  c = mycpu();
801050a8:	e8 33 ec ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
801050ad:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801050b3:	e8 88 05 00 00       	call   80105640 <popcli>
  if(p == 0)
801050b8:	85 db                	test   %ebx,%ebx
801050ba:	0f 84 83 00 00 00    	je     80105143 <sleep+0xb3>
  if(lk == 0)
801050c0:	85 f6                	test   %esi,%esi
801050c2:	74 72                	je     80105136 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801050c4:	81 fe 40 4e 11 80    	cmp    $0x80114e40,%esi
801050ca:	74 4c                	je     80105118 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801050cc:	83 ec 0c             	sub    $0xc,%esp
801050cf:	68 40 4e 11 80       	push   $0x80114e40
801050d4:	e8 17 06 00 00       	call   801056f0 <acquire>
    release(lk);
801050d9:	89 34 24             	mov    %esi,(%esp)
801050dc:	e8 cf 06 00 00       	call   801057b0 <release>
  p->chan = chan;
801050e1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801050e4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801050eb:	e8 50 fd ff ff       	call   80104e40 <sched>
  p->chan = 0;
801050f0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801050f7:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801050fe:	e8 ad 06 00 00       	call   801057b0 <release>
    acquire(lk);
80105103:	89 75 08             	mov    %esi,0x8(%ebp)
80105106:	83 c4 10             	add    $0x10,%esp
}
80105109:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010510c:	5b                   	pop    %ebx
8010510d:	5e                   	pop    %esi
8010510e:	5f                   	pop    %edi
8010510f:	5d                   	pop    %ebp
    acquire(lk);
80105110:	e9 db 05 00 00       	jmp    801056f0 <acquire>
80105115:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80105118:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010511b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105122:	e8 19 fd ff ff       	call   80104e40 <sched>
  p->chan = 0;
80105127:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010512e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105131:	5b                   	pop    %ebx
80105132:	5e                   	pop    %esi
80105133:	5f                   	pop    %edi
80105134:	5d                   	pop    %ebp
80105135:	c3                   	ret    
    panic("sleep without lk");
80105136:	83 ec 0c             	sub    $0xc,%esp
80105139:	68 53 8b 10 80       	push   $0x80108b53
8010513e:	e8 4d b2 ff ff       	call   80100390 <panic>
    panic("sleep");
80105143:	83 ec 0c             	sub    $0xc,%esp
80105146:	68 4d 8b 10 80       	push   $0x80108b4d
8010514b:	e8 40 b2 ff ff       	call   80100390 <panic>

80105150 <wait>:
{
80105150:	f3 0f 1e fb          	endbr32 
80105154:	55                   	push   %ebp
80105155:	89 e5                	mov    %esp,%ebp
80105157:	56                   	push   %esi
80105158:	53                   	push   %ebx
  pushcli();
80105159:	e8 92 04 00 00       	call   801055f0 <pushcli>
  c = mycpu();
8010515e:	e8 7d eb ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80105163:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105169:	e8 d2 04 00 00       	call   80105640 <popcli>
  acquire(&ptable.lock);
8010516e:	83 ec 0c             	sub    $0xc,%esp
80105171:	68 40 4e 11 80       	push   $0x80114e40
80105176:	e8 75 05 00 00       	call   801056f0 <acquire>
8010517b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010517e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105180:	bb 74 4e 11 80       	mov    $0x80114e74,%ebx
80105185:	eb 17                	jmp    8010519e <wait+0x4e>
80105187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518e:	66 90                	xchg   %ax,%ax
80105190:	81 c3 24 01 00 00    	add    $0x124,%ebx
80105196:	81 fb 74 97 11 80    	cmp    $0x80119774,%ebx
8010519c:	74 1e                	je     801051bc <wait+0x6c>
      if(p->parent != curproc)
8010519e:	39 73 14             	cmp    %esi,0x14(%ebx)
801051a1:	75 ed                	jne    80105190 <wait+0x40>
      if(p->state == ZOMBIE){
801051a3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801051a7:	74 37                	je     801051e0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051a9:	81 c3 24 01 00 00    	add    $0x124,%ebx
      havekids = 1;
801051af:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051b4:	81 fb 74 97 11 80    	cmp    $0x80119774,%ebx
801051ba:	75 e2                	jne    8010519e <wait+0x4e>
    if(!havekids || curproc->killed){
801051bc:	85 c0                	test   %eax,%eax
801051be:	74 76                	je     80105236 <wait+0xe6>
801051c0:	8b 46 24             	mov    0x24(%esi),%eax
801051c3:	85 c0                	test   %eax,%eax
801051c5:	75 6f                	jne    80105236 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801051c7:	83 ec 08             	sub    $0x8,%esp
801051ca:	68 40 4e 11 80       	push   $0x80114e40
801051cf:	56                   	push   %esi
801051d0:	e8 bb fe ff ff       	call   80105090 <sleep>
    havekids = 0;
801051d5:	83 c4 10             	add    $0x10,%esp
801051d8:	eb a4                	jmp    8010517e <wait+0x2e>
801051da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801051e0:	83 ec 0c             	sub    $0xc,%esp
801051e3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801051e6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801051e9:	e8 f2 d5 ff ff       	call   801027e0 <kfree>
        freevm(p->pgdir);
801051ee:	5a                   	pop    %edx
801051ef:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801051f2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801051f9:	e8 82 2f 00 00       	call   80108180 <freevm>
        release(&ptable.lock);
801051fe:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
        p->pid = 0;
80105205:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010520c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80105213:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80105217:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010521e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80105225:	e8 86 05 00 00       	call   801057b0 <release>
        return pid;
8010522a:	83 c4 10             	add    $0x10,%esp
}
8010522d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105230:	89 f0                	mov    %esi,%eax
80105232:	5b                   	pop    %ebx
80105233:	5e                   	pop    %esi
80105234:	5d                   	pop    %ebp
80105235:	c3                   	ret    
      release(&ptable.lock);
80105236:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80105239:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010523e:	68 40 4e 11 80       	push   $0x80114e40
80105243:	e8 68 05 00 00       	call   801057b0 <release>
      return -1;
80105248:	83 c4 10             	add    $0x10,%esp
8010524b:	eb e0                	jmp    8010522d <wait+0xdd>
8010524d:	8d 76 00             	lea    0x0(%esi),%esi

80105250 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
80105255:	89 e5                	mov    %esp,%ebp
80105257:	53                   	push   %ebx
80105258:	83 ec 10             	sub    $0x10,%esp
8010525b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010525e:	68 40 4e 11 80       	push   $0x80114e40
80105263:	e8 88 04 00 00       	call   801056f0 <acquire>
80105268:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010526b:	b8 74 4e 11 80       	mov    $0x80114e74,%eax
80105270:	eb 12                	jmp    80105284 <wakeup+0x34>
80105272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105278:	05 24 01 00 00       	add    $0x124,%eax
8010527d:	3d 74 97 11 80       	cmp    $0x80119774,%eax
80105282:	74 1e                	je     801052a2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80105284:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105288:	75 ee                	jne    80105278 <wakeup+0x28>
8010528a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010528d:	75 e9                	jne    80105278 <wakeup+0x28>
      p->state = RUNNABLE;
8010528f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105296:	05 24 01 00 00       	add    $0x124,%eax
8010529b:	3d 74 97 11 80       	cmp    $0x80119774,%eax
801052a0:	75 e2                	jne    80105284 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
801052a2:	c7 45 08 40 4e 11 80 	movl   $0x80114e40,0x8(%ebp)
}
801052a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052ac:	c9                   	leave  
  release(&ptable.lock);
801052ad:	e9 fe 04 00 00       	jmp    801057b0 <release>
801052b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801052c0:	f3 0f 1e fb          	endbr32 
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	53                   	push   %ebx
801052c8:	83 ec 10             	sub    $0x10,%esp
801052cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801052ce:	68 40 4e 11 80       	push   $0x80114e40
801052d3:	e8 18 04 00 00       	call   801056f0 <acquire>
801052d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801052db:	b8 74 4e 11 80       	mov    $0x80114e74,%eax
801052e0:	eb 12                	jmp    801052f4 <kill+0x34>
801052e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052e8:	05 24 01 00 00       	add    $0x124,%eax
801052ed:	3d 74 97 11 80       	cmp    $0x80119774,%eax
801052f2:	74 34                	je     80105328 <kill+0x68>
    if(p->pid == pid){
801052f4:	39 58 10             	cmp    %ebx,0x10(%eax)
801052f7:	75 ef                	jne    801052e8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801052f9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801052fd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80105304:	75 07                	jne    8010530d <kill+0x4d>
        p->state = RUNNABLE;
80105306:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010530d:	83 ec 0c             	sub    $0xc,%esp
80105310:	68 40 4e 11 80       	push   $0x80114e40
80105315:	e8 96 04 00 00       	call   801057b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010531a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010531d:	83 c4 10             	add    $0x10,%esp
80105320:	31 c0                	xor    %eax,%eax
}
80105322:	c9                   	leave  
80105323:	c3                   	ret    
80105324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105328:	83 ec 0c             	sub    $0xc,%esp
8010532b:	68 40 4e 11 80       	push   $0x80114e40
80105330:	e8 7b 04 00 00       	call   801057b0 <release>
}
80105335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80105338:	83 c4 10             	add    $0x10,%esp
8010533b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105340:	c9                   	leave  
80105341:	c3                   	ret    
80105342:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105350 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105350:	f3 0f 1e fb          	endbr32 
80105354:	55                   	push   %ebp
80105355:	89 e5                	mov    %esp,%ebp
80105357:	57                   	push   %edi
80105358:	56                   	push   %esi
80105359:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010535c:	53                   	push   %ebx
8010535d:	bb e0 4e 11 80       	mov    $0x80114ee0,%ebx
80105362:	83 ec 3c             	sub    $0x3c,%esp
80105365:	eb 2b                	jmp    80105392 <procdump+0x42>
80105367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	68 f2 8a 10 80       	push   $0x80108af2
80105378:	e8 33 b3 ff ff       	call   801006b0 <cprintf>
8010537d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105380:	81 c3 24 01 00 00    	add    $0x124,%ebx
80105386:	81 fb e0 97 11 80    	cmp    $0x801197e0,%ebx
8010538c:	0f 84 8e 00 00 00    	je     80105420 <procdump+0xd0>
    if(p->state == UNUSED)
80105392:	8b 43 a0             	mov    -0x60(%ebx),%eax
80105395:	85 c0                	test   %eax,%eax
80105397:	74 e7                	je     80105380 <procdump+0x30>
      state = "???";
80105399:	ba 64 8b 10 80       	mov    $0x80108b64,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010539e:	83 f8 05             	cmp    $0x5,%eax
801053a1:	77 11                	ja     801053b4 <procdump+0x64>
801053a3:	8b 14 85 d4 8c 10 80 	mov    -0x7fef732c(,%eax,4),%edx
      state = "???";
801053aa:	b8 64 8b 10 80       	mov    $0x80108b64,%eax
801053af:	85 d2                	test   %edx,%edx
801053b1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801053b4:	53                   	push   %ebx
801053b5:	52                   	push   %edx
801053b6:	ff 73 a4             	pushl  -0x5c(%ebx)
801053b9:	68 68 8b 10 80       	push   $0x80108b68
801053be:	e8 ed b2 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801053ca:	75 a4                	jne    80105370 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801053cc:	83 ec 08             	sub    $0x8,%esp
801053cf:	8d 45 c0             	lea    -0x40(%ebp),%eax
801053d2:	8d 7d c0             	lea    -0x40(%ebp),%edi
801053d5:	50                   	push   %eax
801053d6:	8b 43 b0             	mov    -0x50(%ebx),%eax
801053d9:	8b 40 0c             	mov    0xc(%eax),%eax
801053dc:	83 c0 08             	add    $0x8,%eax
801053df:	50                   	push   %eax
801053e0:	e8 ab 01 00 00       	call   80105590 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801053e5:	83 c4 10             	add    $0x10,%esp
801053e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop
801053f0:	8b 17                	mov    (%edi),%edx
801053f2:	85 d2                	test   %edx,%edx
801053f4:	0f 84 76 ff ff ff    	je     80105370 <procdump+0x20>
        cprintf(" %p", pc[i]);
801053fa:	83 ec 08             	sub    $0x8,%esp
801053fd:	83 c7 04             	add    $0x4,%edi
80105400:	52                   	push   %edx
80105401:	68 e1 84 10 80       	push   $0x801084e1
80105406:	e8 a5 b2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010540b:	83 c4 10             	add    $0x10,%esp
8010540e:	39 fe                	cmp    %edi,%esi
80105410:	75 de                	jne    801053f0 <procdump+0xa0>
80105412:	e9 59 ff ff ff       	jmp    80105370 <procdump+0x20>
80105417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541e:	66 90                	xchg   %ax,%ax
  }
}
80105420:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105423:	5b                   	pop    %ebx
80105424:	5e                   	pop    %esi
80105425:	5f                   	pop    %edi
80105426:	5d                   	pop    %ebp
80105427:	c3                   	ret    
80105428:	66 90                	xchg   %ax,%ax
8010542a:	66 90                	xchg   %ax,%ax
8010542c:	66 90                	xchg   %ax,%ax
8010542e:	66 90                	xchg   %ax,%ax

80105430 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105430:	f3 0f 1e fb          	endbr32 
80105434:	55                   	push   %ebp
80105435:	89 e5                	mov    %esp,%ebp
80105437:	53                   	push   %ebx
80105438:	83 ec 0c             	sub    $0xc,%esp
8010543b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010543e:	68 10 8d 10 80       	push   $0x80108d10
80105443:	8d 43 04             	lea    0x4(%ebx),%eax
80105446:	50                   	push   %eax
80105447:	e8 24 01 00 00       	call   80105570 <initlock>
  lk->name = name;
8010544c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010544f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105455:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105458:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010545f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80105462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105465:	c9                   	leave  
80105466:	c3                   	ret    
80105467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546e:	66 90                	xchg   %ax,%ax

80105470 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105470:	f3 0f 1e fb          	endbr32 
80105474:	55                   	push   %ebp
80105475:	89 e5                	mov    %esp,%ebp
80105477:	56                   	push   %esi
80105478:	53                   	push   %ebx
80105479:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010547c:	8d 73 04             	lea    0x4(%ebx),%esi
8010547f:	83 ec 0c             	sub    $0xc,%esp
80105482:	56                   	push   %esi
80105483:	e8 68 02 00 00       	call   801056f0 <acquire>
  while (lk->locked) {
80105488:	8b 13                	mov    (%ebx),%edx
8010548a:	83 c4 10             	add    $0x10,%esp
8010548d:	85 d2                	test   %edx,%edx
8010548f:	74 1a                	je     801054ab <acquiresleep+0x3b>
80105491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80105498:	83 ec 08             	sub    $0x8,%esp
8010549b:	56                   	push   %esi
8010549c:	53                   	push   %ebx
8010549d:	e8 ee fb ff ff       	call   80105090 <sleep>
  while (lk->locked) {
801054a2:	8b 03                	mov    (%ebx),%eax
801054a4:	83 c4 10             	add    $0x10,%esp
801054a7:	85 c0                	test   %eax,%eax
801054a9:	75 ed                	jne    80105498 <acquiresleep+0x28>
  }
  lk->locked = 1;
801054ab:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801054b1:	e8 ea e8 ff ff       	call   80103da0 <myproc>
801054b6:	8b 40 10             	mov    0x10(%eax),%eax
801054b9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801054bc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801054bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054c2:	5b                   	pop    %ebx
801054c3:	5e                   	pop    %esi
801054c4:	5d                   	pop    %ebp
  release(&lk->lk);
801054c5:	e9 e6 02 00 00       	jmp    801057b0 <release>
801054ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054d0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801054d0:	f3 0f 1e fb          	endbr32 
801054d4:	55                   	push   %ebp
801054d5:	89 e5                	mov    %esp,%ebp
801054d7:	56                   	push   %esi
801054d8:	53                   	push   %ebx
801054d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801054dc:	8d 73 04             	lea    0x4(%ebx),%esi
801054df:	83 ec 0c             	sub    $0xc,%esp
801054e2:	56                   	push   %esi
801054e3:	e8 08 02 00 00       	call   801056f0 <acquire>
  lk->locked = 0;
801054e8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801054ee:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801054f5:	89 1c 24             	mov    %ebx,(%esp)
801054f8:	e8 53 fd ff ff       	call   80105250 <wakeup>
  release(&lk->lk);
801054fd:	89 75 08             	mov    %esi,0x8(%ebp)
80105500:	83 c4 10             	add    $0x10,%esp
}
80105503:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105506:	5b                   	pop    %ebx
80105507:	5e                   	pop    %esi
80105508:	5d                   	pop    %ebp
  release(&lk->lk);
80105509:	e9 a2 02 00 00       	jmp    801057b0 <release>
8010550e:	66 90                	xchg   %ax,%ax

80105510 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105510:	f3 0f 1e fb          	endbr32 
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	57                   	push   %edi
80105518:	31 ff                	xor    %edi,%edi
8010551a:	56                   	push   %esi
8010551b:	53                   	push   %ebx
8010551c:	83 ec 18             	sub    $0x18,%esp
8010551f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80105522:	8d 73 04             	lea    0x4(%ebx),%esi
80105525:	56                   	push   %esi
80105526:	e8 c5 01 00 00       	call   801056f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010552b:	8b 03                	mov    (%ebx),%eax
8010552d:	83 c4 10             	add    $0x10,%esp
80105530:	85 c0                	test   %eax,%eax
80105532:	75 1c                	jne    80105550 <holdingsleep+0x40>
  release(&lk->lk);
80105534:	83 ec 0c             	sub    $0xc,%esp
80105537:	56                   	push   %esi
80105538:	e8 73 02 00 00       	call   801057b0 <release>
  return r;
}
8010553d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105540:	89 f8                	mov    %edi,%eax
80105542:	5b                   	pop    %ebx
80105543:	5e                   	pop    %esi
80105544:	5f                   	pop    %edi
80105545:	5d                   	pop    %ebp
80105546:	c3                   	ret    
80105547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80105550:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105553:	e8 48 e8 ff ff       	call   80103da0 <myproc>
80105558:	39 58 10             	cmp    %ebx,0x10(%eax)
8010555b:	0f 94 c0             	sete   %al
8010555e:	0f b6 c0             	movzbl %al,%eax
80105561:	89 c7                	mov    %eax,%edi
80105563:	eb cf                	jmp    80105534 <holdingsleep+0x24>
80105565:	66 90                	xchg   %ax,%ax
80105567:	66 90                	xchg   %ax,%ax
80105569:	66 90                	xchg   %ax,%ax
8010556b:	66 90                	xchg   %ax,%ax
8010556d:	66 90                	xchg   %ax,%ax
8010556f:	90                   	nop

80105570 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105570:	f3 0f 1e fb          	endbr32 
80105574:	55                   	push   %ebp
80105575:	89 e5                	mov    %esp,%ebp
80105577:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010557a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010557d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80105583:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105586:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010558d:	5d                   	pop    %ebp
8010558e:	c3                   	ret    
8010558f:	90                   	nop

80105590 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105590:	f3 0f 1e fb          	endbr32 
80105594:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105595:	31 d2                	xor    %edx,%edx
{
80105597:	89 e5                	mov    %esp,%ebp
80105599:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010559a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010559d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801055a0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801055a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055a7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801055a8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801055ae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801055b4:	77 1a                	ja     801055d0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801055b6:	8b 58 04             	mov    0x4(%eax),%ebx
801055b9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801055bc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801055bf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801055c1:	83 fa 0a             	cmp    $0xa,%edx
801055c4:	75 e2                	jne    801055a8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801055c6:	5b                   	pop    %ebx
801055c7:	5d                   	pop    %ebp
801055c8:	c3                   	ret    
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801055d0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801055d3:	8d 51 28             	lea    0x28(%ecx),%edx
801055d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801055e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801055e6:	83 c0 04             	add    $0x4,%eax
801055e9:	39 d0                	cmp    %edx,%eax
801055eb:	75 f3                	jne    801055e0 <getcallerpcs+0x50>
}
801055ed:	5b                   	pop    %ebx
801055ee:	5d                   	pop    %ebp
801055ef:	c3                   	ret    

801055f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801055f0:	f3 0f 1e fb          	endbr32 
801055f4:	55                   	push   %ebp
801055f5:	89 e5                	mov    %esp,%ebp
801055f7:	53                   	push   %ebx
801055f8:	83 ec 04             	sub    $0x4,%esp
801055fb:	9c                   	pushf  
801055fc:	5b                   	pop    %ebx
  asm volatile("cli");
801055fd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801055fe:	e8 dd e6 ff ff       	call   80103ce0 <mycpu>
80105603:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105609:	85 c0                	test   %eax,%eax
8010560b:	74 13                	je     80105620 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010560d:	e8 ce e6 ff ff       	call   80103ce0 <mycpu>
80105612:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105619:	83 c4 04             	add    $0x4,%esp
8010561c:	5b                   	pop    %ebx
8010561d:	5d                   	pop    %ebp
8010561e:	c3                   	ret    
8010561f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80105620:	e8 bb e6 ff ff       	call   80103ce0 <mycpu>
80105625:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010562b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105631:	eb da                	jmp    8010560d <pushcli+0x1d>
80105633:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105640 <popcli>:

void
popcli(void)
{
80105640:	f3 0f 1e fb          	endbr32 
80105644:	55                   	push   %ebp
80105645:	89 e5                	mov    %esp,%ebp
80105647:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010564a:	9c                   	pushf  
8010564b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010564c:	f6 c4 02             	test   $0x2,%ah
8010564f:	75 31                	jne    80105682 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105651:	e8 8a e6 ff ff       	call   80103ce0 <mycpu>
80105656:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010565d:	78 30                	js     8010568f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010565f:	e8 7c e6 ff ff       	call   80103ce0 <mycpu>
80105664:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010566a:	85 d2                	test   %edx,%edx
8010566c:	74 02                	je     80105670 <popcli+0x30>
    sti();
}
8010566e:	c9                   	leave  
8010566f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105670:	e8 6b e6 ff ff       	call   80103ce0 <mycpu>
80105675:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010567b:	85 c0                	test   %eax,%eax
8010567d:	74 ef                	je     8010566e <popcli+0x2e>
  asm volatile("sti");
8010567f:	fb                   	sti    
}
80105680:	c9                   	leave  
80105681:	c3                   	ret    
    panic("popcli - interruptible");
80105682:	83 ec 0c             	sub    $0xc,%esp
80105685:	68 1b 8d 10 80       	push   $0x80108d1b
8010568a:	e8 01 ad ff ff       	call   80100390 <panic>
    panic("popcli");
8010568f:	83 ec 0c             	sub    $0xc,%esp
80105692:	68 32 8d 10 80       	push   $0x80108d32
80105697:	e8 f4 ac ff ff       	call   80100390 <panic>
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <holding>:
{
801056a0:	f3 0f 1e fb          	endbr32 
801056a4:	55                   	push   %ebp
801056a5:	89 e5                	mov    %esp,%ebp
801056a7:	56                   	push   %esi
801056a8:	53                   	push   %ebx
801056a9:	8b 75 08             	mov    0x8(%ebp),%esi
801056ac:	31 db                	xor    %ebx,%ebx
  pushcli();
801056ae:	e8 3d ff ff ff       	call   801055f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801056b3:	8b 06                	mov    (%esi),%eax
801056b5:	85 c0                	test   %eax,%eax
801056b7:	75 0f                	jne    801056c8 <holding+0x28>
  popcli();
801056b9:	e8 82 ff ff ff       	call   80105640 <popcli>
}
801056be:	89 d8                	mov    %ebx,%eax
801056c0:	5b                   	pop    %ebx
801056c1:	5e                   	pop    %esi
801056c2:	5d                   	pop    %ebp
801056c3:	c3                   	ret    
801056c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
801056c8:	8b 5e 08             	mov    0x8(%esi),%ebx
801056cb:	e8 10 e6 ff ff       	call   80103ce0 <mycpu>
801056d0:	39 c3                	cmp    %eax,%ebx
801056d2:	0f 94 c3             	sete   %bl
  popcli();
801056d5:	e8 66 ff ff ff       	call   80105640 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801056da:	0f b6 db             	movzbl %bl,%ebx
}
801056dd:	89 d8                	mov    %ebx,%eax
801056df:	5b                   	pop    %ebx
801056e0:	5e                   	pop    %esi
801056e1:	5d                   	pop    %ebp
801056e2:	c3                   	ret    
801056e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056f0 <acquire>:
{
801056f0:	f3 0f 1e fb          	endbr32 
801056f4:	55                   	push   %ebp
801056f5:	89 e5                	mov    %esp,%ebp
801056f7:	56                   	push   %esi
801056f8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801056f9:	e8 f2 fe ff ff       	call   801055f0 <pushcli>
  if(holding(lk))
801056fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105701:	83 ec 0c             	sub    $0xc,%esp
80105704:	53                   	push   %ebx
80105705:	e8 96 ff ff ff       	call   801056a0 <holding>
8010570a:	83 c4 10             	add    $0x10,%esp
8010570d:	85 c0                	test   %eax,%eax
8010570f:	0f 85 7f 00 00 00    	jne    80105794 <acquire+0xa4>
80105715:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105717:	ba 01 00 00 00       	mov    $0x1,%edx
8010571c:	eb 05                	jmp    80105723 <acquire+0x33>
8010571e:	66 90                	xchg   %ax,%ax
80105720:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105723:	89 d0                	mov    %edx,%eax
80105725:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105728:	85 c0                	test   %eax,%eax
8010572a:	75 f4                	jne    80105720 <acquire+0x30>
  __sync_synchronize();
8010572c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105731:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105734:	e8 a7 e5 ff ff       	call   80103ce0 <mycpu>
80105739:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010573c:	89 e8                	mov    %ebp,%eax
8010573e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105740:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80105746:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010574c:	77 22                	ja     80105770 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010574e:	8b 50 04             	mov    0x4(%eax),%edx
80105751:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105755:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105758:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010575a:	83 fe 0a             	cmp    $0xa,%esi
8010575d:	75 e1                	jne    80105740 <acquire+0x50>
}
8010575f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105762:	5b                   	pop    %ebx
80105763:	5e                   	pop    %esi
80105764:	5d                   	pop    %ebp
80105765:	c3                   	ret    
80105766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105770:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105774:	83 c3 34             	add    $0x34,%ebx
80105777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105780:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105786:	83 c0 04             	add    $0x4,%eax
80105789:	39 d8                	cmp    %ebx,%eax
8010578b:	75 f3                	jne    80105780 <acquire+0x90>
}
8010578d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105790:	5b                   	pop    %ebx
80105791:	5e                   	pop    %esi
80105792:	5d                   	pop    %ebp
80105793:	c3                   	ret    
    panic("acquire");
80105794:	83 ec 0c             	sub    $0xc,%esp
80105797:	68 39 8d 10 80       	push   $0x80108d39
8010579c:	e8 ef ab ff ff       	call   80100390 <panic>
801057a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057af:	90                   	nop

801057b0 <release>:
{
801057b0:	f3 0f 1e fb          	endbr32 
801057b4:	55                   	push   %ebp
801057b5:	89 e5                	mov    %esp,%ebp
801057b7:	53                   	push   %ebx
801057b8:	83 ec 10             	sub    $0x10,%esp
801057bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801057be:	53                   	push   %ebx
801057bf:	e8 dc fe ff ff       	call   801056a0 <holding>
801057c4:	83 c4 10             	add    $0x10,%esp
801057c7:	85 c0                	test   %eax,%eax
801057c9:	74 22                	je     801057ed <release+0x3d>
  lk->pcs[0] = 0;
801057cb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801057d2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801057d9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801057de:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801057e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057e7:	c9                   	leave  
  popcli();
801057e8:	e9 53 fe ff ff       	jmp    80105640 <popcli>
    panic("release");
801057ed:	83 ec 0c             	sub    $0xc,%esp
801057f0:	68 41 8d 10 80       	push   $0x80108d41
801057f5:	e8 96 ab ff ff       	call   80100390 <panic>
801057fa:	66 90                	xchg   %ax,%ax
801057fc:	66 90                	xchg   %ax,%ax
801057fe:	66 90                	xchg   %ax,%ax

80105800 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105800:	f3 0f 1e fb          	endbr32 
80105804:	55                   	push   %ebp
80105805:	89 e5                	mov    %esp,%ebp
80105807:	57                   	push   %edi
80105808:	8b 55 08             	mov    0x8(%ebp),%edx
8010580b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010580e:	53                   	push   %ebx
8010580f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105812:	89 d7                	mov    %edx,%edi
80105814:	09 cf                	or     %ecx,%edi
80105816:	83 e7 03             	and    $0x3,%edi
80105819:	75 25                	jne    80105840 <memset+0x40>
    c &= 0xFF;
8010581b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010581e:	c1 e0 18             	shl    $0x18,%eax
80105821:	89 fb                	mov    %edi,%ebx
80105823:	c1 e9 02             	shr    $0x2,%ecx
80105826:	c1 e3 10             	shl    $0x10,%ebx
80105829:	09 d8                	or     %ebx,%eax
8010582b:	09 f8                	or     %edi,%eax
8010582d:	c1 e7 08             	shl    $0x8,%edi
80105830:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105832:	89 d7                	mov    %edx,%edi
80105834:	fc                   	cld    
80105835:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105837:	5b                   	pop    %ebx
80105838:	89 d0                	mov    %edx,%eax
8010583a:	5f                   	pop    %edi
8010583b:	5d                   	pop    %ebp
8010583c:	c3                   	ret    
8010583d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105840:	89 d7                	mov    %edx,%edi
80105842:	fc                   	cld    
80105843:	f3 aa                	rep stos %al,%es:(%edi)
80105845:	5b                   	pop    %ebx
80105846:	89 d0                	mov    %edx,%eax
80105848:	5f                   	pop    %edi
80105849:	5d                   	pop    %ebp
8010584a:	c3                   	ret    
8010584b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010584f:	90                   	nop

80105850 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105850:	f3 0f 1e fb          	endbr32 
80105854:	55                   	push   %ebp
80105855:	89 e5                	mov    %esp,%ebp
80105857:	56                   	push   %esi
80105858:	8b 75 10             	mov    0x10(%ebp),%esi
8010585b:	8b 55 08             	mov    0x8(%ebp),%edx
8010585e:	53                   	push   %ebx
8010585f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105862:	85 f6                	test   %esi,%esi
80105864:	74 2a                	je     80105890 <memcmp+0x40>
80105866:	01 c6                	add    %eax,%esi
80105868:	eb 10                	jmp    8010587a <memcmp+0x2a>
8010586a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105870:	83 c0 01             	add    $0x1,%eax
80105873:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105876:	39 f0                	cmp    %esi,%eax
80105878:	74 16                	je     80105890 <memcmp+0x40>
    if(*s1 != *s2)
8010587a:	0f b6 0a             	movzbl (%edx),%ecx
8010587d:	0f b6 18             	movzbl (%eax),%ebx
80105880:	38 d9                	cmp    %bl,%cl
80105882:	74 ec                	je     80105870 <memcmp+0x20>
      return *s1 - *s2;
80105884:	0f b6 c1             	movzbl %cl,%eax
80105887:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105889:	5b                   	pop    %ebx
8010588a:	5e                   	pop    %esi
8010588b:	5d                   	pop    %ebp
8010588c:	c3                   	ret    
8010588d:	8d 76 00             	lea    0x0(%esi),%esi
80105890:	5b                   	pop    %ebx
  return 0;
80105891:	31 c0                	xor    %eax,%eax
}
80105893:	5e                   	pop    %esi
80105894:	5d                   	pop    %ebp
80105895:	c3                   	ret    
80105896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589d:	8d 76 00             	lea    0x0(%esi),%esi

801058a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	57                   	push   %edi
801058a8:	8b 55 08             	mov    0x8(%ebp),%edx
801058ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
801058ae:	56                   	push   %esi
801058af:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801058b2:	39 d6                	cmp    %edx,%esi
801058b4:	73 2a                	jae    801058e0 <memmove+0x40>
801058b6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801058b9:	39 fa                	cmp    %edi,%edx
801058bb:	73 23                	jae    801058e0 <memmove+0x40>
801058bd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801058c0:	85 c9                	test   %ecx,%ecx
801058c2:	74 13                	je     801058d7 <memmove+0x37>
801058c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801058c8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801058cc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801058cf:	83 e8 01             	sub    $0x1,%eax
801058d2:	83 f8 ff             	cmp    $0xffffffff,%eax
801058d5:	75 f1                	jne    801058c8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801058d7:	5e                   	pop    %esi
801058d8:	89 d0                	mov    %edx,%eax
801058da:	5f                   	pop    %edi
801058db:	5d                   	pop    %ebp
801058dc:	c3                   	ret    
801058dd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801058e0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801058e3:	89 d7                	mov    %edx,%edi
801058e5:	85 c9                	test   %ecx,%ecx
801058e7:	74 ee                	je     801058d7 <memmove+0x37>
801058e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801058f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801058f1:	39 f0                	cmp    %esi,%eax
801058f3:	75 fb                	jne    801058f0 <memmove+0x50>
}
801058f5:	5e                   	pop    %esi
801058f6:	89 d0                	mov    %edx,%eax
801058f8:	5f                   	pop    %edi
801058f9:	5d                   	pop    %ebp
801058fa:	c3                   	ret    
801058fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop

80105900 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105900:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105904:	eb 9a                	jmp    801058a0 <memmove>
80105906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590d:	8d 76 00             	lea    0x0(%esi),%esi

80105910 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	56                   	push   %esi
80105918:	8b 75 10             	mov    0x10(%ebp),%esi
8010591b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010591e:	53                   	push   %ebx
8010591f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105922:	85 f6                	test   %esi,%esi
80105924:	74 32                	je     80105958 <strncmp+0x48>
80105926:	01 c6                	add    %eax,%esi
80105928:	eb 14                	jmp    8010593e <strncmp+0x2e>
8010592a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105930:	38 da                	cmp    %bl,%dl
80105932:	75 14                	jne    80105948 <strncmp+0x38>
    n--, p++, q++;
80105934:	83 c0 01             	add    $0x1,%eax
80105937:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010593a:	39 f0                	cmp    %esi,%eax
8010593c:	74 1a                	je     80105958 <strncmp+0x48>
8010593e:	0f b6 11             	movzbl (%ecx),%edx
80105941:	0f b6 18             	movzbl (%eax),%ebx
80105944:	84 d2                	test   %dl,%dl
80105946:	75 e8                	jne    80105930 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105948:	0f b6 c2             	movzbl %dl,%eax
8010594b:	29 d8                	sub    %ebx,%eax
}
8010594d:	5b                   	pop    %ebx
8010594e:	5e                   	pop    %esi
8010594f:	5d                   	pop    %ebp
80105950:	c3                   	ret    
80105951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105958:	5b                   	pop    %ebx
    return 0;
80105959:	31 c0                	xor    %eax,%eax
}
8010595b:	5e                   	pop    %esi
8010595c:	5d                   	pop    %ebp
8010595d:	c3                   	ret    
8010595e:	66 90                	xchg   %ax,%ax

80105960 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105960:	f3 0f 1e fb          	endbr32 
80105964:	55                   	push   %ebp
80105965:	89 e5                	mov    %esp,%ebp
80105967:	57                   	push   %edi
80105968:	56                   	push   %esi
80105969:	8b 75 08             	mov    0x8(%ebp),%esi
8010596c:	53                   	push   %ebx
8010596d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105970:	89 f2                	mov    %esi,%edx
80105972:	eb 1b                	jmp    8010598f <strncpy+0x2f>
80105974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105978:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010597c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010597f:	83 c2 01             	add    $0x1,%edx
80105982:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105986:	89 f9                	mov    %edi,%ecx
80105988:	88 4a ff             	mov    %cl,-0x1(%edx)
8010598b:	84 c9                	test   %cl,%cl
8010598d:	74 09                	je     80105998 <strncpy+0x38>
8010598f:	89 c3                	mov    %eax,%ebx
80105991:	83 e8 01             	sub    $0x1,%eax
80105994:	85 db                	test   %ebx,%ebx
80105996:	7f e0                	jg     80105978 <strncpy+0x18>
    ;
  while(n-- > 0)
80105998:	89 d1                	mov    %edx,%ecx
8010599a:	85 c0                	test   %eax,%eax
8010599c:	7e 15                	jle    801059b3 <strncpy+0x53>
8010599e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801059a0:	83 c1 01             	add    $0x1,%ecx
801059a3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801059a7:	89 c8                	mov    %ecx,%eax
801059a9:	f7 d0                	not    %eax
801059ab:	01 d0                	add    %edx,%eax
801059ad:	01 d8                	add    %ebx,%eax
801059af:	85 c0                	test   %eax,%eax
801059b1:	7f ed                	jg     801059a0 <strncpy+0x40>
  return os;
}
801059b3:	5b                   	pop    %ebx
801059b4:	89 f0                	mov    %esi,%eax
801059b6:	5e                   	pop    %esi
801059b7:	5f                   	pop    %edi
801059b8:	5d                   	pop    %ebp
801059b9:	c3                   	ret    
801059ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801059c0:	f3 0f 1e fb          	endbr32 
801059c4:	55                   	push   %ebp
801059c5:	89 e5                	mov    %esp,%ebp
801059c7:	56                   	push   %esi
801059c8:	8b 55 10             	mov    0x10(%ebp),%edx
801059cb:	8b 75 08             	mov    0x8(%ebp),%esi
801059ce:	53                   	push   %ebx
801059cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801059d2:	85 d2                	test   %edx,%edx
801059d4:	7e 21                	jle    801059f7 <safestrcpy+0x37>
801059d6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801059da:	89 f2                	mov    %esi,%edx
801059dc:	eb 12                	jmp    801059f0 <safestrcpy+0x30>
801059de:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801059e0:	0f b6 08             	movzbl (%eax),%ecx
801059e3:	83 c0 01             	add    $0x1,%eax
801059e6:	83 c2 01             	add    $0x1,%edx
801059e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801059ec:	84 c9                	test   %cl,%cl
801059ee:	74 04                	je     801059f4 <safestrcpy+0x34>
801059f0:	39 d8                	cmp    %ebx,%eax
801059f2:	75 ec                	jne    801059e0 <safestrcpy+0x20>
    ;
  *s = 0;
801059f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801059f7:	89 f0                	mov    %esi,%eax
801059f9:	5b                   	pop    %ebx
801059fa:	5e                   	pop    %esi
801059fb:	5d                   	pop    %ebp
801059fc:	c3                   	ret    
801059fd:	8d 76 00             	lea    0x0(%esi),%esi

80105a00 <strlen>:

int
strlen(const char *s)
{
80105a00:	f3 0f 1e fb          	endbr32 
80105a04:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105a05:	31 c0                	xor    %eax,%eax
{
80105a07:	89 e5                	mov    %esp,%ebp
80105a09:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105a0c:	80 3a 00             	cmpb   $0x0,(%edx)
80105a0f:	74 10                	je     80105a21 <strlen+0x21>
80105a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a18:	83 c0 01             	add    $0x1,%eax
80105a1b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105a1f:	75 f7                	jne    80105a18 <strlen+0x18>
    ;
  return n;
}
80105a21:	5d                   	pop    %ebp
80105a22:	c3                   	ret    

80105a23 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105a23:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105a27:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105a2b:	55                   	push   %ebp
  pushl %ebx
80105a2c:	53                   	push   %ebx
  pushl %esi
80105a2d:	56                   	push   %esi
  pushl %edi
80105a2e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105a2f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105a31:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105a33:	5f                   	pop    %edi
  popl %esi
80105a34:	5e                   	pop    %esi
  popl %ebx
80105a35:	5b                   	pop    %ebx
  popl %ebp
80105a36:	5d                   	pop    %ebp
  ret
80105a37:	c3                   	ret    
80105a38:	66 90                	xchg   %ax,%ax
80105a3a:	66 90                	xchg   %ax,%ax
80105a3c:	66 90                	xchg   %ax,%ax
80105a3e:	66 90                	xchg   %ax,%ax

80105a40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	53                   	push   %ebx
80105a48:	83 ec 04             	sub    $0x4,%esp
80105a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105a4e:	e8 4d e3 ff ff       	call   80103da0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105a53:	8b 00                	mov    (%eax),%eax
80105a55:	39 d8                	cmp    %ebx,%eax
80105a57:	76 17                	jbe    80105a70 <fetchint+0x30>
80105a59:	8d 53 04             	lea    0x4(%ebx),%edx
80105a5c:	39 d0                	cmp    %edx,%eax
80105a5e:	72 10                	jb     80105a70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105a60:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a63:	8b 13                	mov    (%ebx),%edx
80105a65:	89 10                	mov    %edx,(%eax)
  return 0;
80105a67:	31 c0                	xor    %eax,%eax
}
80105a69:	83 c4 04             	add    $0x4,%esp
80105a6c:	5b                   	pop    %ebx
80105a6d:	5d                   	pop    %ebp
80105a6e:	c3                   	ret    
80105a6f:	90                   	nop
    return -1;
80105a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a75:	eb f2                	jmp    80105a69 <fetchint+0x29>
80105a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7e:	66 90                	xchg   %ax,%ax

80105a80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105a80:	f3 0f 1e fb          	endbr32 
80105a84:	55                   	push   %ebp
80105a85:	89 e5                	mov    %esp,%ebp
80105a87:	53                   	push   %ebx
80105a88:	83 ec 04             	sub    $0x4,%esp
80105a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105a8e:	e8 0d e3 ff ff       	call   80103da0 <myproc>

  if(addr >= curproc->sz)
80105a93:	39 18                	cmp    %ebx,(%eax)
80105a95:	76 31                	jbe    80105ac8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105a97:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a9a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105a9c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105a9e:	39 d3                	cmp    %edx,%ebx
80105aa0:	73 26                	jae    80105ac8 <fetchstr+0x48>
80105aa2:	89 d8                	mov    %ebx,%eax
80105aa4:	eb 11                	jmp    80105ab7 <fetchstr+0x37>
80105aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aad:	8d 76 00             	lea    0x0(%esi),%esi
80105ab0:	83 c0 01             	add    $0x1,%eax
80105ab3:	39 c2                	cmp    %eax,%edx
80105ab5:	76 11                	jbe    80105ac8 <fetchstr+0x48>
    if(*s == 0)
80105ab7:	80 38 00             	cmpb   $0x0,(%eax)
80105aba:	75 f4                	jne    80105ab0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80105abc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80105abf:	29 d8                	sub    %ebx,%eax
}
80105ac1:	5b                   	pop    %ebx
80105ac2:	5d                   	pop    %ebp
80105ac3:	c3                   	ret    
80105ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ac8:	83 c4 04             	add    $0x4,%esp
    return -1;
80105acb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ad0:	5b                   	pop    %ebx
80105ad1:	5d                   	pop    %ebp
80105ad2:	c3                   	ret    
80105ad3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ae0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105ae0:	f3 0f 1e fb          	endbr32 
80105ae4:	55                   	push   %ebp
80105ae5:	89 e5                	mov    %esp,%ebp
80105ae7:	56                   	push   %esi
80105ae8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ae9:	e8 b2 e2 ff ff       	call   80103da0 <myproc>
80105aee:	8b 55 08             	mov    0x8(%ebp),%edx
80105af1:	8b 40 18             	mov    0x18(%eax),%eax
80105af4:	8b 40 44             	mov    0x44(%eax),%eax
80105af7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105afa:	e8 a1 e2 ff ff       	call   80103da0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105aff:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105b02:	8b 00                	mov    (%eax),%eax
80105b04:	39 c6                	cmp    %eax,%esi
80105b06:	73 18                	jae    80105b20 <argint+0x40>
80105b08:	8d 53 08             	lea    0x8(%ebx),%edx
80105b0b:	39 d0                	cmp    %edx,%eax
80105b0d:	72 11                	jb     80105b20 <argint+0x40>
  *ip = *(int*)(addr);
80105b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b12:	8b 53 04             	mov    0x4(%ebx),%edx
80105b15:	89 10                	mov    %edx,(%eax)
  return 0;
80105b17:	31 c0                	xor    %eax,%eax
}
80105b19:	5b                   	pop    %ebx
80105b1a:	5e                   	pop    %esi
80105b1b:	5d                   	pop    %ebp
80105b1c:	c3                   	ret    
80105b1d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105b25:	eb f2                	jmp    80105b19 <argint+0x39>
80105b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2e:	66 90                	xchg   %ax,%ax

80105b30 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105b30:	f3 0f 1e fb          	endbr32 
80105b34:	55                   	push   %ebp
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	56                   	push   %esi
80105b38:	53                   	push   %ebx
80105b39:	83 ec 10             	sub    $0x10,%esp
80105b3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80105b3f:	e8 5c e2 ff ff       	call   80103da0 <myproc>
 
  if(argint(n, &i) < 0)
80105b44:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105b47:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105b49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b4c:	50                   	push   %eax
80105b4d:	ff 75 08             	pushl  0x8(%ebp)
80105b50:	e8 8b ff ff ff       	call   80105ae0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105b55:	83 c4 10             	add    $0x10,%esp
80105b58:	85 c0                	test   %eax,%eax
80105b5a:	78 24                	js     80105b80 <argptr+0x50>
80105b5c:	85 db                	test   %ebx,%ebx
80105b5e:	78 20                	js     80105b80 <argptr+0x50>
80105b60:	8b 16                	mov    (%esi),%edx
80105b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b65:	39 c2                	cmp    %eax,%edx
80105b67:	76 17                	jbe    80105b80 <argptr+0x50>
80105b69:	01 c3                	add    %eax,%ebx
80105b6b:	39 da                	cmp    %ebx,%edx
80105b6d:	72 11                	jb     80105b80 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80105b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b72:	89 02                	mov    %eax,(%edx)
  return 0;
80105b74:	31 c0                	xor    %eax,%eax
}
80105b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b79:	5b                   	pop    %ebx
80105b7a:	5e                   	pop    %esi
80105b7b:	5d                   	pop    %ebp
80105b7c:	c3                   	ret    
80105b7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b85:	eb ef                	jmp    80105b76 <argptr+0x46>
80105b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105b90:	f3 0f 1e fb          	endbr32 
80105b94:	55                   	push   %ebp
80105b95:	89 e5                	mov    %esp,%ebp
80105b97:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105b9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b9d:	50                   	push   %eax
80105b9e:	ff 75 08             	pushl  0x8(%ebp)
80105ba1:	e8 3a ff ff ff       	call   80105ae0 <argint>
80105ba6:	83 c4 10             	add    $0x10,%esp
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	78 13                	js     80105bc0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105bad:	83 ec 08             	sub    $0x8,%esp
80105bb0:	ff 75 0c             	pushl  0xc(%ebp)
80105bb3:	ff 75 f4             	pushl  -0xc(%ebp)
80105bb6:	e8 c5 fe ff ff       	call   80105a80 <fetchstr>
80105bbb:	83 c4 10             	add    $0x10,%esp
}
80105bbe:	c9                   	leave  
80105bbf:	c3                   	ret    
80105bc0:	c9                   	leave  
    return -1;
80105bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bc6:	c3                   	ret    
80105bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bce:	66 90                	xchg   %ax,%ax

80105bd0 <syscall>:
[SYS_change_BJF_parameters_all] sys_change_BJF_parameters_all,
};

void
syscall(void)
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
80105bd5:	89 e5                	mov    %esp,%ebp
80105bd7:	56                   	push   %esi
80105bd8:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105bd9:	e8 c2 e1 ff ff       	call   80103da0 <myproc>
80105bde:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105be0:	8b 40 18             	mov    0x18(%eax),%eax
80105be3:	8b 70 1c             	mov    0x1c(%eax),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105be6:	8d 46 ff             	lea    -0x1(%esi),%eax
80105be9:	83 f8 1c             	cmp    $0x1c,%eax
80105bec:	77 22                	ja     80105c10 <syscall+0x40>
80105bee:	8b 04 b5 80 8d 10 80 	mov    -0x7fef7280(,%esi,4),%eax
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	74 17                	je     80105c10 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105bf9:	ff d0                	call   *%eax
80105bfb:	8b 53 18             	mov    0x18(%ebx),%edx
80105bfe:	89 42 1c             	mov    %eax,0x1c(%edx)
    curproc->syscall_cnt[num - 1] += 1;
80105c01:	83 44 b3 78 01       	addl   $0x1,0x78(%ebx,%esi,4)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105c06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c09:	5b                   	pop    %ebx
80105c0a:	5e                   	pop    %esi
80105c0b:	5d                   	pop    %ebp
80105c0c:	c3                   	ret    
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi
            curproc->pid, curproc->name, num);
80105c10:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105c13:	56                   	push   %esi
80105c14:	50                   	push   %eax
80105c15:	ff 73 10             	pushl  0x10(%ebx)
80105c18:	68 49 8d 10 80       	push   $0x80108d49
80105c1d:	e8 8e aa ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105c22:	8b 43 18             	mov    0x18(%ebx),%eax
80105c25:	83 c4 10             	add    $0x10,%esp
80105c28:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105c2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c32:	5b                   	pop    %ebx
80105c33:	5e                   	pop    %esi
80105c34:	5d                   	pop    %ebp
80105c35:	c3                   	ret    
80105c36:	66 90                	xchg   %ax,%ax
80105c38:	66 90                	xchg   %ax,%ax
80105c3a:	66 90                	xchg   %ax,%ax
80105c3c:	66 90                	xchg   %ax,%ax
80105c3e:	66 90                	xchg   %ax,%ax

80105c40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	57                   	push   %edi
80105c44:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105c45:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105c48:	53                   	push   %ebx
80105c49:	83 ec 34             	sub    $0x34,%esp
80105c4c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105c4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105c52:	57                   	push   %edi
80105c53:	50                   	push   %eax
{
80105c54:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105c57:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105c5a:	e8 61 c7 ff ff       	call   801023c0 <nameiparent>
80105c5f:	83 c4 10             	add    $0x10,%esp
80105c62:	85 c0                	test   %eax,%eax
80105c64:	0f 84 46 01 00 00    	je     80105db0 <create+0x170>
    return 0;
  ilock(dp);
80105c6a:	83 ec 0c             	sub    $0xc,%esp
80105c6d:	89 c3                	mov    %eax,%ebx
80105c6f:	50                   	push   %eax
80105c70:	e8 5b be ff ff       	call   80101ad0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105c75:	83 c4 0c             	add    $0xc,%esp
80105c78:	6a 00                	push   $0x0
80105c7a:	57                   	push   %edi
80105c7b:	53                   	push   %ebx
80105c7c:	e8 9f c3 ff ff       	call   80102020 <dirlookup>
80105c81:	83 c4 10             	add    $0x10,%esp
80105c84:	89 c6                	mov    %eax,%esi
80105c86:	85 c0                	test   %eax,%eax
80105c88:	74 56                	je     80105ce0 <create+0xa0>
    iunlockput(dp);
80105c8a:	83 ec 0c             	sub    $0xc,%esp
80105c8d:	53                   	push   %ebx
80105c8e:	e8 dd c0 ff ff       	call   80101d70 <iunlockput>
    ilock(ip);
80105c93:	89 34 24             	mov    %esi,(%esp)
80105c96:	e8 35 be ff ff       	call   80101ad0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105c9b:	83 c4 10             	add    $0x10,%esp
80105c9e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105ca3:	75 1b                	jne    80105cc0 <create+0x80>
80105ca5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105caa:	75 14                	jne    80105cc0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105caf:	89 f0                	mov    %esi,%eax
80105cb1:	5b                   	pop    %ebx
80105cb2:	5e                   	pop    %esi
80105cb3:	5f                   	pop    %edi
80105cb4:	5d                   	pop    %ebp
80105cb5:	c3                   	ret    
80105cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	56                   	push   %esi
    return 0;
80105cc4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105cc6:	e8 a5 c0 ff ff       	call   80101d70 <iunlockput>
    return 0;
80105ccb:	83 c4 10             	add    $0x10,%esp
}
80105cce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cd1:	89 f0                	mov    %esi,%eax
80105cd3:	5b                   	pop    %ebx
80105cd4:	5e                   	pop    %esi
80105cd5:	5f                   	pop    %edi
80105cd6:	5d                   	pop    %ebp
80105cd7:	c3                   	ret    
80105cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105ce0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105ce4:	83 ec 08             	sub    $0x8,%esp
80105ce7:	50                   	push   %eax
80105ce8:	ff 33                	pushl  (%ebx)
80105cea:	e8 61 bc ff ff       	call   80101950 <ialloc>
80105cef:	83 c4 10             	add    $0x10,%esp
80105cf2:	89 c6                	mov    %eax,%esi
80105cf4:	85 c0                	test   %eax,%eax
80105cf6:	0f 84 cd 00 00 00    	je     80105dc9 <create+0x189>
  ilock(ip);
80105cfc:	83 ec 0c             	sub    $0xc,%esp
80105cff:	50                   	push   %eax
80105d00:	e8 cb bd ff ff       	call   80101ad0 <ilock>
  ip->major = major;
80105d05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105d09:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105d0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105d11:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105d15:	b8 01 00 00 00       	mov    $0x1,%eax
80105d1a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105d1e:	89 34 24             	mov    %esi,(%esp)
80105d21:	e8 ea bc ff ff       	call   80101a10 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105d26:	83 c4 10             	add    $0x10,%esp
80105d29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105d2e:	74 30                	je     80105d60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105d30:	83 ec 04             	sub    $0x4,%esp
80105d33:	ff 76 04             	pushl  0x4(%esi)
80105d36:	57                   	push   %edi
80105d37:	53                   	push   %ebx
80105d38:	e8 a3 c5 ff ff       	call   801022e0 <dirlink>
80105d3d:	83 c4 10             	add    $0x10,%esp
80105d40:	85 c0                	test   %eax,%eax
80105d42:	78 78                	js     80105dbc <create+0x17c>
  iunlockput(dp);
80105d44:	83 ec 0c             	sub    $0xc,%esp
80105d47:	53                   	push   %ebx
80105d48:	e8 23 c0 ff ff       	call   80101d70 <iunlockput>
  return ip;
80105d4d:	83 c4 10             	add    $0x10,%esp
}
80105d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d53:	89 f0                	mov    %esi,%eax
80105d55:	5b                   	pop    %ebx
80105d56:	5e                   	pop    %esi
80105d57:	5f                   	pop    %edi
80105d58:	5d                   	pop    %ebp
80105d59:	c3                   	ret    
80105d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105d60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105d63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105d68:	53                   	push   %ebx
80105d69:	e8 a2 bc ff ff       	call   80101a10 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105d6e:	83 c4 0c             	add    $0xc,%esp
80105d71:	ff 76 04             	pushl  0x4(%esi)
80105d74:	68 14 8e 10 80       	push   $0x80108e14
80105d79:	56                   	push   %esi
80105d7a:	e8 61 c5 ff ff       	call   801022e0 <dirlink>
80105d7f:	83 c4 10             	add    $0x10,%esp
80105d82:	85 c0                	test   %eax,%eax
80105d84:	78 18                	js     80105d9e <create+0x15e>
80105d86:	83 ec 04             	sub    $0x4,%esp
80105d89:	ff 73 04             	pushl  0x4(%ebx)
80105d8c:	68 13 8e 10 80       	push   $0x80108e13
80105d91:	56                   	push   %esi
80105d92:	e8 49 c5 ff ff       	call   801022e0 <dirlink>
80105d97:	83 c4 10             	add    $0x10,%esp
80105d9a:	85 c0                	test   %eax,%eax
80105d9c:	79 92                	jns    80105d30 <create+0xf0>
      panic("create dots");
80105d9e:	83 ec 0c             	sub    $0xc,%esp
80105da1:	68 07 8e 10 80       	push   $0x80108e07
80105da6:	e8 e5 a5 ff ff       	call   80100390 <panic>
80105dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105daf:	90                   	nop
}
80105db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105db3:	31 f6                	xor    %esi,%esi
}
80105db5:	5b                   	pop    %ebx
80105db6:	89 f0                	mov    %esi,%eax
80105db8:	5e                   	pop    %esi
80105db9:	5f                   	pop    %edi
80105dba:	5d                   	pop    %ebp
80105dbb:	c3                   	ret    
    panic("create: dirlink");
80105dbc:	83 ec 0c             	sub    $0xc,%esp
80105dbf:	68 16 8e 10 80       	push   $0x80108e16
80105dc4:	e8 c7 a5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105dc9:	83 ec 0c             	sub    $0xc,%esp
80105dcc:	68 f8 8d 10 80       	push   $0x80108df8
80105dd1:	e8 ba a5 ff ff       	call   80100390 <panic>
80105dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ddd:	8d 76 00             	lea    0x0(%esi),%esi

80105de0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	56                   	push   %esi
80105de4:	89 d6                	mov    %edx,%esi
80105de6:	53                   	push   %ebx
80105de7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105de9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105dec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105def:	50                   	push   %eax
80105df0:	6a 00                	push   $0x0
80105df2:	e8 e9 fc ff ff       	call   80105ae0 <argint>
80105df7:	83 c4 10             	add    $0x10,%esp
80105dfa:	85 c0                	test   %eax,%eax
80105dfc:	78 2a                	js     80105e28 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105dfe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105e02:	77 24                	ja     80105e28 <argfd.constprop.0+0x48>
80105e04:	e8 97 df ff ff       	call   80103da0 <myproc>
80105e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e0c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105e10:	85 c0                	test   %eax,%eax
80105e12:	74 14                	je     80105e28 <argfd.constprop.0+0x48>
  if(pfd)
80105e14:	85 db                	test   %ebx,%ebx
80105e16:	74 02                	je     80105e1a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105e18:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105e1a:	89 06                	mov    %eax,(%esi)
  return 0;
80105e1c:	31 c0                	xor    %eax,%eax
}
80105e1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e21:	5b                   	pop    %ebx
80105e22:	5e                   	pop    %esi
80105e23:	5d                   	pop    %ebp
80105e24:	c3                   	ret    
80105e25:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2d:	eb ef                	jmp    80105e1e <argfd.constprop.0+0x3e>
80105e2f:	90                   	nop

80105e30 <sys_dup>:
{
80105e30:	f3 0f 1e fb          	endbr32 
80105e34:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105e35:	31 c0                	xor    %eax,%eax
{
80105e37:	89 e5                	mov    %esp,%ebp
80105e39:	56                   	push   %esi
80105e3a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105e3b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105e3e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105e41:	e8 9a ff ff ff       	call   80105de0 <argfd.constprop.0>
80105e46:	85 c0                	test   %eax,%eax
80105e48:	78 1e                	js     80105e68 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80105e4a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105e4d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e4f:	e8 4c df ff ff       	call   80103da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e58:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105e5c:	85 d2                	test   %edx,%edx
80105e5e:	74 20                	je     80105e80 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105e60:	83 c3 01             	add    $0x1,%ebx
80105e63:	83 fb 10             	cmp    $0x10,%ebx
80105e66:	75 f0                	jne    80105e58 <sys_dup+0x28>
}
80105e68:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105e6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105e70:	89 d8                	mov    %ebx,%eax
80105e72:	5b                   	pop    %ebx
80105e73:	5e                   	pop    %esi
80105e74:	5d                   	pop    %ebp
80105e75:	c3                   	ret    
80105e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105e80:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105e84:	83 ec 0c             	sub    $0xc,%esp
80105e87:	ff 75 f4             	pushl  -0xc(%ebp)
80105e8a:	e8 51 b3 ff ff       	call   801011e0 <filedup>
  return fd;
80105e8f:	83 c4 10             	add    $0x10,%esp
}
80105e92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e95:	89 d8                	mov    %ebx,%eax
80105e97:	5b                   	pop    %ebx
80105e98:	5e                   	pop    %esi
80105e99:	5d                   	pop    %ebp
80105e9a:	c3                   	ret    
80105e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e9f:	90                   	nop

80105ea0 <sys_read>:
{
80105ea0:	f3 0f 1e fb          	endbr32 
80105ea4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ea5:	31 c0                	xor    %eax,%eax
{
80105ea7:	89 e5                	mov    %esp,%ebp
80105ea9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105eac:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105eaf:	e8 2c ff ff ff       	call   80105de0 <argfd.constprop.0>
80105eb4:	85 c0                	test   %eax,%eax
80105eb6:	78 48                	js     80105f00 <sys_read+0x60>
80105eb8:	83 ec 08             	sub    $0x8,%esp
80105ebb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ebe:	50                   	push   %eax
80105ebf:	6a 02                	push   $0x2
80105ec1:	e8 1a fc ff ff       	call   80105ae0 <argint>
80105ec6:	83 c4 10             	add    $0x10,%esp
80105ec9:	85 c0                	test   %eax,%eax
80105ecb:	78 33                	js     80105f00 <sys_read+0x60>
80105ecd:	83 ec 04             	sub    $0x4,%esp
80105ed0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ed3:	ff 75 f0             	pushl  -0x10(%ebp)
80105ed6:	50                   	push   %eax
80105ed7:	6a 01                	push   $0x1
80105ed9:	e8 52 fc ff ff       	call   80105b30 <argptr>
80105ede:	83 c4 10             	add    $0x10,%esp
80105ee1:	85 c0                	test   %eax,%eax
80105ee3:	78 1b                	js     80105f00 <sys_read+0x60>
  return fileread(f, p, n);
80105ee5:	83 ec 04             	sub    $0x4,%esp
80105ee8:	ff 75 f0             	pushl  -0x10(%ebp)
80105eeb:	ff 75 f4             	pushl  -0xc(%ebp)
80105eee:	ff 75 ec             	pushl  -0x14(%ebp)
80105ef1:	e8 6a b4 ff ff       	call   80101360 <fileread>
80105ef6:	83 c4 10             	add    $0x10,%esp
}
80105ef9:	c9                   	leave  
80105efa:	c3                   	ret    
80105efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105eff:	90                   	nop
80105f00:	c9                   	leave  
    return -1;
80105f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f06:	c3                   	ret    
80105f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0e:	66 90                	xchg   %ax,%ax

80105f10 <sys_write>:
{
80105f10:	f3 0f 1e fb          	endbr32 
80105f14:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105f15:	31 c0                	xor    %eax,%eax
{
80105f17:	89 e5                	mov    %esp,%ebp
80105f19:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105f1c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105f1f:	e8 bc fe ff ff       	call   80105de0 <argfd.constprop.0>
80105f24:	85 c0                	test   %eax,%eax
80105f26:	78 48                	js     80105f70 <sys_write+0x60>
80105f28:	83 ec 08             	sub    $0x8,%esp
80105f2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f2e:	50                   	push   %eax
80105f2f:	6a 02                	push   $0x2
80105f31:	e8 aa fb ff ff       	call   80105ae0 <argint>
80105f36:	83 c4 10             	add    $0x10,%esp
80105f39:	85 c0                	test   %eax,%eax
80105f3b:	78 33                	js     80105f70 <sys_write+0x60>
80105f3d:	83 ec 04             	sub    $0x4,%esp
80105f40:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f43:	ff 75 f0             	pushl  -0x10(%ebp)
80105f46:	50                   	push   %eax
80105f47:	6a 01                	push   $0x1
80105f49:	e8 e2 fb ff ff       	call   80105b30 <argptr>
80105f4e:	83 c4 10             	add    $0x10,%esp
80105f51:	85 c0                	test   %eax,%eax
80105f53:	78 1b                	js     80105f70 <sys_write+0x60>
  return filewrite(f, p, n);
80105f55:	83 ec 04             	sub    $0x4,%esp
80105f58:	ff 75 f0             	pushl  -0x10(%ebp)
80105f5b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f5e:	ff 75 ec             	pushl  -0x14(%ebp)
80105f61:	e8 9a b4 ff ff       	call   80101400 <filewrite>
80105f66:	83 c4 10             	add    $0x10,%esp
}
80105f69:	c9                   	leave  
80105f6a:	c3                   	ret    
80105f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f6f:	90                   	nop
80105f70:	c9                   	leave  
    return -1;
80105f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f76:	c3                   	ret    
80105f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7e:	66 90                	xchg   %ax,%ax

80105f80 <sys_close>:
{
80105f80:	f3 0f 1e fb          	endbr32 
80105f84:	55                   	push   %ebp
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105f8a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105f8d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f90:	e8 4b fe ff ff       	call   80105de0 <argfd.constprop.0>
80105f95:	85 c0                	test   %eax,%eax
80105f97:	78 27                	js     80105fc0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105f99:	e8 02 de ff ff       	call   80103da0 <myproc>
80105f9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105fa1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105fa4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105fab:	00 
  fileclose(f);
80105fac:	ff 75 f4             	pushl  -0xc(%ebp)
80105faf:	e8 7c b2 ff ff       	call   80101230 <fileclose>
  return 0;
80105fb4:	83 c4 10             	add    $0x10,%esp
80105fb7:	31 c0                	xor    %eax,%eax
}
80105fb9:	c9                   	leave  
80105fba:	c3                   	ret    
80105fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop
80105fc0:	c9                   	leave  
    return -1;
80105fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fc6:	c3                   	ret    
80105fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <sys_fstat>:
{
80105fd0:	f3 0f 1e fb          	endbr32 
80105fd4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105fd5:	31 c0                	xor    %eax,%eax
{
80105fd7:	89 e5                	mov    %esp,%ebp
80105fd9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105fdc:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105fdf:	e8 fc fd ff ff       	call   80105de0 <argfd.constprop.0>
80105fe4:	85 c0                	test   %eax,%eax
80105fe6:	78 30                	js     80106018 <sys_fstat+0x48>
80105fe8:	83 ec 04             	sub    $0x4,%esp
80105feb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fee:	6a 14                	push   $0x14
80105ff0:	50                   	push   %eax
80105ff1:	6a 01                	push   $0x1
80105ff3:	e8 38 fb ff ff       	call   80105b30 <argptr>
80105ff8:	83 c4 10             	add    $0x10,%esp
80105ffb:	85 c0                	test   %eax,%eax
80105ffd:	78 19                	js     80106018 <sys_fstat+0x48>
  return filestat(f, st);
80105fff:	83 ec 08             	sub    $0x8,%esp
80106002:	ff 75 f4             	pushl  -0xc(%ebp)
80106005:	ff 75 f0             	pushl  -0x10(%ebp)
80106008:	e8 03 b3 ff ff       	call   80101310 <filestat>
8010600d:	83 c4 10             	add    $0x10,%esp
}
80106010:	c9                   	leave  
80106011:	c3                   	ret    
80106012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106018:	c9                   	leave  
    return -1;
80106019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010601e:	c3                   	ret    
8010601f:	90                   	nop

80106020 <sys_link>:
{
80106020:	f3 0f 1e fb          	endbr32 
80106024:	55                   	push   %ebp
80106025:	89 e5                	mov    %esp,%ebp
80106027:	57                   	push   %edi
80106028:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106029:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010602c:	53                   	push   %ebx
8010602d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106030:	50                   	push   %eax
80106031:	6a 00                	push   $0x0
80106033:	e8 58 fb ff ff       	call   80105b90 <argstr>
80106038:	83 c4 10             	add    $0x10,%esp
8010603b:	85 c0                	test   %eax,%eax
8010603d:	0f 88 ff 00 00 00    	js     80106142 <sys_link+0x122>
80106043:	83 ec 08             	sub    $0x8,%esp
80106046:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106049:	50                   	push   %eax
8010604a:	6a 01                	push   $0x1
8010604c:	e8 3f fb ff ff       	call   80105b90 <argstr>
80106051:	83 c4 10             	add    $0x10,%esp
80106054:	85 c0                	test   %eax,%eax
80106056:	0f 88 e6 00 00 00    	js     80106142 <sys_link+0x122>
  begin_op();
8010605c:	e8 3f d0 ff ff       	call   801030a0 <begin_op>
  if((ip = namei(old)) == 0){
80106061:	83 ec 0c             	sub    $0xc,%esp
80106064:	ff 75 d4             	pushl  -0x2c(%ebp)
80106067:	e8 34 c3 ff ff       	call   801023a0 <namei>
8010606c:	83 c4 10             	add    $0x10,%esp
8010606f:	89 c3                	mov    %eax,%ebx
80106071:	85 c0                	test   %eax,%eax
80106073:	0f 84 e8 00 00 00    	je     80106161 <sys_link+0x141>
  ilock(ip);
80106079:	83 ec 0c             	sub    $0xc,%esp
8010607c:	50                   	push   %eax
8010607d:	e8 4e ba ff ff       	call   80101ad0 <ilock>
  if(ip->type == T_DIR){
80106082:	83 c4 10             	add    $0x10,%esp
80106085:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010608a:	0f 84 b9 00 00 00    	je     80106149 <sys_link+0x129>
  iupdate(ip);
80106090:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80106093:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106098:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010609b:	53                   	push   %ebx
8010609c:	e8 6f b9 ff ff       	call   80101a10 <iupdate>
  iunlock(ip);
801060a1:	89 1c 24             	mov    %ebx,(%esp)
801060a4:	e8 07 bb ff ff       	call   80101bb0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801060a9:	58                   	pop    %eax
801060aa:	5a                   	pop    %edx
801060ab:	57                   	push   %edi
801060ac:	ff 75 d0             	pushl  -0x30(%ebp)
801060af:	e8 0c c3 ff ff       	call   801023c0 <nameiparent>
801060b4:	83 c4 10             	add    $0x10,%esp
801060b7:	89 c6                	mov    %eax,%esi
801060b9:	85 c0                	test   %eax,%eax
801060bb:	74 5f                	je     8010611c <sys_link+0xfc>
  ilock(dp);
801060bd:	83 ec 0c             	sub    $0xc,%esp
801060c0:	50                   	push   %eax
801060c1:	e8 0a ba ff ff       	call   80101ad0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801060c6:	8b 03                	mov    (%ebx),%eax
801060c8:	83 c4 10             	add    $0x10,%esp
801060cb:	39 06                	cmp    %eax,(%esi)
801060cd:	75 41                	jne    80106110 <sys_link+0xf0>
801060cf:	83 ec 04             	sub    $0x4,%esp
801060d2:	ff 73 04             	pushl  0x4(%ebx)
801060d5:	57                   	push   %edi
801060d6:	56                   	push   %esi
801060d7:	e8 04 c2 ff ff       	call   801022e0 <dirlink>
801060dc:	83 c4 10             	add    $0x10,%esp
801060df:	85 c0                	test   %eax,%eax
801060e1:	78 2d                	js     80106110 <sys_link+0xf0>
  iunlockput(dp);
801060e3:	83 ec 0c             	sub    $0xc,%esp
801060e6:	56                   	push   %esi
801060e7:	e8 84 bc ff ff       	call   80101d70 <iunlockput>
  iput(ip);
801060ec:	89 1c 24             	mov    %ebx,(%esp)
801060ef:	e8 0c bb ff ff       	call   80101c00 <iput>
  end_op();
801060f4:	e8 17 d0 ff ff       	call   80103110 <end_op>
  return 0;
801060f9:	83 c4 10             	add    $0x10,%esp
801060fc:	31 c0                	xor    %eax,%eax
}
801060fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106101:	5b                   	pop    %ebx
80106102:	5e                   	pop    %esi
80106103:	5f                   	pop    %edi
80106104:	5d                   	pop    %ebp
80106105:	c3                   	ret    
80106106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80106110:	83 ec 0c             	sub    $0xc,%esp
80106113:	56                   	push   %esi
80106114:	e8 57 bc ff ff       	call   80101d70 <iunlockput>
    goto bad;
80106119:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010611c:	83 ec 0c             	sub    $0xc,%esp
8010611f:	53                   	push   %ebx
80106120:	e8 ab b9 ff ff       	call   80101ad0 <ilock>
  ip->nlink--;
80106125:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010612a:	89 1c 24             	mov    %ebx,(%esp)
8010612d:	e8 de b8 ff ff       	call   80101a10 <iupdate>
  iunlockput(ip);
80106132:	89 1c 24             	mov    %ebx,(%esp)
80106135:	e8 36 bc ff ff       	call   80101d70 <iunlockput>
  end_op();
8010613a:	e8 d1 cf ff ff       	call   80103110 <end_op>
  return -1;
8010613f:	83 c4 10             	add    $0x10,%esp
80106142:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106147:	eb b5                	jmp    801060fe <sys_link+0xde>
    iunlockput(ip);
80106149:	83 ec 0c             	sub    $0xc,%esp
8010614c:	53                   	push   %ebx
8010614d:	e8 1e bc ff ff       	call   80101d70 <iunlockput>
    end_op();
80106152:	e8 b9 cf ff ff       	call   80103110 <end_op>
    return -1;
80106157:	83 c4 10             	add    $0x10,%esp
8010615a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010615f:	eb 9d                	jmp    801060fe <sys_link+0xde>
    end_op();
80106161:	e8 aa cf ff ff       	call   80103110 <end_op>
    return -1;
80106166:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616b:	eb 91                	jmp    801060fe <sys_link+0xde>
8010616d:	8d 76 00             	lea    0x0(%esi),%esi

80106170 <sys_unlink>:
{
80106170:	f3 0f 1e fb          	endbr32 
80106174:	55                   	push   %ebp
80106175:	89 e5                	mov    %esp,%ebp
80106177:	57                   	push   %edi
80106178:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106179:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010617c:	53                   	push   %ebx
8010617d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80106180:	50                   	push   %eax
80106181:	6a 00                	push   $0x0
80106183:	e8 08 fa ff ff       	call   80105b90 <argstr>
80106188:	83 c4 10             	add    $0x10,%esp
8010618b:	85 c0                	test   %eax,%eax
8010618d:	0f 88 7d 01 00 00    	js     80106310 <sys_unlink+0x1a0>
  begin_op();
80106193:	e8 08 cf ff ff       	call   801030a0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106198:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010619b:	83 ec 08             	sub    $0x8,%esp
8010619e:	53                   	push   %ebx
8010619f:	ff 75 c0             	pushl  -0x40(%ebp)
801061a2:	e8 19 c2 ff ff       	call   801023c0 <nameiparent>
801061a7:	83 c4 10             	add    $0x10,%esp
801061aa:	89 c6                	mov    %eax,%esi
801061ac:	85 c0                	test   %eax,%eax
801061ae:	0f 84 66 01 00 00    	je     8010631a <sys_unlink+0x1aa>
  ilock(dp);
801061b4:	83 ec 0c             	sub    $0xc,%esp
801061b7:	50                   	push   %eax
801061b8:	e8 13 b9 ff ff       	call   80101ad0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801061bd:	58                   	pop    %eax
801061be:	5a                   	pop    %edx
801061bf:	68 14 8e 10 80       	push   $0x80108e14
801061c4:	53                   	push   %ebx
801061c5:	e8 36 be ff ff       	call   80102000 <namecmp>
801061ca:	83 c4 10             	add    $0x10,%esp
801061cd:	85 c0                	test   %eax,%eax
801061cf:	0f 84 03 01 00 00    	je     801062d8 <sys_unlink+0x168>
801061d5:	83 ec 08             	sub    $0x8,%esp
801061d8:	68 13 8e 10 80       	push   $0x80108e13
801061dd:	53                   	push   %ebx
801061de:	e8 1d be ff ff       	call   80102000 <namecmp>
801061e3:	83 c4 10             	add    $0x10,%esp
801061e6:	85 c0                	test   %eax,%eax
801061e8:	0f 84 ea 00 00 00    	je     801062d8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801061ee:	83 ec 04             	sub    $0x4,%esp
801061f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801061f4:	50                   	push   %eax
801061f5:	53                   	push   %ebx
801061f6:	56                   	push   %esi
801061f7:	e8 24 be ff ff       	call   80102020 <dirlookup>
801061fc:	83 c4 10             	add    $0x10,%esp
801061ff:	89 c3                	mov    %eax,%ebx
80106201:	85 c0                	test   %eax,%eax
80106203:	0f 84 cf 00 00 00    	je     801062d8 <sys_unlink+0x168>
  ilock(ip);
80106209:	83 ec 0c             	sub    $0xc,%esp
8010620c:	50                   	push   %eax
8010620d:	e8 be b8 ff ff       	call   80101ad0 <ilock>
  if(ip->nlink < 1)
80106212:	83 c4 10             	add    $0x10,%esp
80106215:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010621a:	0f 8e 23 01 00 00    	jle    80106343 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106220:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106225:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106228:	74 66                	je     80106290 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010622a:	83 ec 04             	sub    $0x4,%esp
8010622d:	6a 10                	push   $0x10
8010622f:	6a 00                	push   $0x0
80106231:	57                   	push   %edi
80106232:	e8 c9 f5 ff ff       	call   80105800 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106237:	6a 10                	push   $0x10
80106239:	ff 75 c4             	pushl  -0x3c(%ebp)
8010623c:	57                   	push   %edi
8010623d:	56                   	push   %esi
8010623e:	e8 8d bc ff ff       	call   80101ed0 <writei>
80106243:	83 c4 20             	add    $0x20,%esp
80106246:	83 f8 10             	cmp    $0x10,%eax
80106249:	0f 85 e7 00 00 00    	jne    80106336 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010624f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106254:	0f 84 96 00 00 00    	je     801062f0 <sys_unlink+0x180>
  iunlockput(dp);
8010625a:	83 ec 0c             	sub    $0xc,%esp
8010625d:	56                   	push   %esi
8010625e:	e8 0d bb ff ff       	call   80101d70 <iunlockput>
  ip->nlink--;
80106263:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106268:	89 1c 24             	mov    %ebx,(%esp)
8010626b:	e8 a0 b7 ff ff       	call   80101a10 <iupdate>
  iunlockput(ip);
80106270:	89 1c 24             	mov    %ebx,(%esp)
80106273:	e8 f8 ba ff ff       	call   80101d70 <iunlockput>
  end_op();
80106278:	e8 93 ce ff ff       	call   80103110 <end_op>
  return 0;
8010627d:	83 c4 10             	add    $0x10,%esp
80106280:	31 c0                	xor    %eax,%eax
}
80106282:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106285:	5b                   	pop    %ebx
80106286:	5e                   	pop    %esi
80106287:	5f                   	pop    %edi
80106288:	5d                   	pop    %ebp
80106289:	c3                   	ret    
8010628a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106290:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106294:	76 94                	jbe    8010622a <sys_unlink+0xba>
80106296:	ba 20 00 00 00       	mov    $0x20,%edx
8010629b:	eb 0b                	jmp    801062a8 <sys_unlink+0x138>
8010629d:	8d 76 00             	lea    0x0(%esi),%esi
801062a0:	83 c2 10             	add    $0x10,%edx
801062a3:	39 53 58             	cmp    %edx,0x58(%ebx)
801062a6:	76 82                	jbe    8010622a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801062a8:	6a 10                	push   $0x10
801062aa:	52                   	push   %edx
801062ab:	57                   	push   %edi
801062ac:	53                   	push   %ebx
801062ad:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801062b0:	e8 1b bb ff ff       	call   80101dd0 <readi>
801062b5:	83 c4 10             	add    $0x10,%esp
801062b8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801062bb:	83 f8 10             	cmp    $0x10,%eax
801062be:	75 69                	jne    80106329 <sys_unlink+0x1b9>
    if(de.inum != 0)
801062c0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801062c5:	74 d9                	je     801062a0 <sys_unlink+0x130>
    iunlockput(ip);
801062c7:	83 ec 0c             	sub    $0xc,%esp
801062ca:	53                   	push   %ebx
801062cb:	e8 a0 ba ff ff       	call   80101d70 <iunlockput>
    goto bad;
801062d0:	83 c4 10             	add    $0x10,%esp
801062d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062d7:	90                   	nop
  iunlockput(dp);
801062d8:	83 ec 0c             	sub    $0xc,%esp
801062db:	56                   	push   %esi
801062dc:	e8 8f ba ff ff       	call   80101d70 <iunlockput>
  end_op();
801062e1:	e8 2a ce ff ff       	call   80103110 <end_op>
  return -1;
801062e6:	83 c4 10             	add    $0x10,%esp
801062e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ee:	eb 92                	jmp    80106282 <sys_unlink+0x112>
    iupdate(dp);
801062f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801062f3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801062f8:	56                   	push   %esi
801062f9:	e8 12 b7 ff ff       	call   80101a10 <iupdate>
801062fe:	83 c4 10             	add    $0x10,%esp
80106301:	e9 54 ff ff ff       	jmp    8010625a <sys_unlink+0xea>
80106306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010630d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106315:	e9 68 ff ff ff       	jmp    80106282 <sys_unlink+0x112>
    end_op();
8010631a:	e8 f1 cd ff ff       	call   80103110 <end_op>
    return -1;
8010631f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106324:	e9 59 ff ff ff       	jmp    80106282 <sys_unlink+0x112>
      panic("isdirempty: readi");
80106329:	83 ec 0c             	sub    $0xc,%esp
8010632c:	68 38 8e 10 80       	push   $0x80108e38
80106331:	e8 5a a0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80106336:	83 ec 0c             	sub    $0xc,%esp
80106339:	68 4a 8e 10 80       	push   $0x80108e4a
8010633e:	e8 4d a0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80106343:	83 ec 0c             	sub    $0xc,%esp
80106346:	68 26 8e 10 80       	push   $0x80108e26
8010634b:	e8 40 a0 ff ff       	call   80100390 <panic>

80106350 <sys_open>:

int
sys_open(void)
{
80106350:	f3 0f 1e fb          	endbr32 
80106354:	55                   	push   %ebp
80106355:	89 e5                	mov    %esp,%ebp
80106357:	57                   	push   %edi
80106358:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106359:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010635c:	53                   	push   %ebx
8010635d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106360:	50                   	push   %eax
80106361:	6a 00                	push   $0x0
80106363:	e8 28 f8 ff ff       	call   80105b90 <argstr>
80106368:	83 c4 10             	add    $0x10,%esp
8010636b:	85 c0                	test   %eax,%eax
8010636d:	0f 88 8a 00 00 00    	js     801063fd <sys_open+0xad>
80106373:	83 ec 08             	sub    $0x8,%esp
80106376:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106379:	50                   	push   %eax
8010637a:	6a 01                	push   $0x1
8010637c:	e8 5f f7 ff ff       	call   80105ae0 <argint>
80106381:	83 c4 10             	add    $0x10,%esp
80106384:	85 c0                	test   %eax,%eax
80106386:	78 75                	js     801063fd <sys_open+0xad>
    return -1;

  begin_op();
80106388:	e8 13 cd ff ff       	call   801030a0 <begin_op>

  if(omode & O_CREATE){
8010638d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106391:	75 75                	jne    80106408 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106393:	83 ec 0c             	sub    $0xc,%esp
80106396:	ff 75 e0             	pushl  -0x20(%ebp)
80106399:	e8 02 c0 ff ff       	call   801023a0 <namei>
8010639e:	83 c4 10             	add    $0x10,%esp
801063a1:	89 c6                	mov    %eax,%esi
801063a3:	85 c0                	test   %eax,%eax
801063a5:	74 7e                	je     80106425 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801063a7:	83 ec 0c             	sub    $0xc,%esp
801063aa:	50                   	push   %eax
801063ab:	e8 20 b7 ff ff       	call   80101ad0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801063b0:	83 c4 10             	add    $0x10,%esp
801063b3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801063b8:	0f 84 c2 00 00 00    	je     80106480 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801063be:	e8 ad ad ff ff       	call   80101170 <filealloc>
801063c3:	89 c7                	mov    %eax,%edi
801063c5:	85 c0                	test   %eax,%eax
801063c7:	74 23                	je     801063ec <sys_open+0x9c>
  struct proc *curproc = myproc();
801063c9:	e8 d2 d9 ff ff       	call   80103da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801063ce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801063d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801063d4:	85 d2                	test   %edx,%edx
801063d6:	74 60                	je     80106438 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801063d8:	83 c3 01             	add    $0x1,%ebx
801063db:	83 fb 10             	cmp    $0x10,%ebx
801063de:	75 f0                	jne    801063d0 <sys_open+0x80>
    if(f)
      fileclose(f);
801063e0:	83 ec 0c             	sub    $0xc,%esp
801063e3:	57                   	push   %edi
801063e4:	e8 47 ae ff ff       	call   80101230 <fileclose>
801063e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801063ec:	83 ec 0c             	sub    $0xc,%esp
801063ef:	56                   	push   %esi
801063f0:	e8 7b b9 ff ff       	call   80101d70 <iunlockput>
    end_op();
801063f5:	e8 16 cd ff ff       	call   80103110 <end_op>
    return -1;
801063fa:	83 c4 10             	add    $0x10,%esp
801063fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106402:	eb 6d                	jmp    80106471 <sys_open+0x121>
80106404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106408:	83 ec 0c             	sub    $0xc,%esp
8010640b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010640e:	31 c9                	xor    %ecx,%ecx
80106410:	ba 02 00 00 00       	mov    $0x2,%edx
80106415:	6a 00                	push   $0x0
80106417:	e8 24 f8 ff ff       	call   80105c40 <create>
    if(ip == 0){
8010641c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010641f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106421:	85 c0                	test   %eax,%eax
80106423:	75 99                	jne    801063be <sys_open+0x6e>
      end_op();
80106425:	e8 e6 cc ff ff       	call   80103110 <end_op>
      return -1;
8010642a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010642f:	eb 40                	jmp    80106471 <sys_open+0x121>
80106431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106438:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010643b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010643f:	56                   	push   %esi
80106440:	e8 6b b7 ff ff       	call   80101bb0 <iunlock>
  end_op();
80106445:	e8 c6 cc ff ff       	call   80103110 <end_op>

  f->type = FD_INODE;
8010644a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106450:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106453:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106456:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106459:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010645b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106462:	f7 d0                	not    %eax
80106464:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106467:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010646a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010646d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106474:	89 d8                	mov    %ebx,%eax
80106476:	5b                   	pop    %ebx
80106477:	5e                   	pop    %esi
80106478:	5f                   	pop    %edi
80106479:	5d                   	pop    %ebp
8010647a:	c3                   	ret    
8010647b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010647f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106480:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106483:	85 c9                	test   %ecx,%ecx
80106485:	0f 84 33 ff ff ff    	je     801063be <sys_open+0x6e>
8010648b:	e9 5c ff ff ff       	jmp    801063ec <sys_open+0x9c>

80106490 <sys_mkdir>:

int
sys_mkdir(void)
{
80106490:	f3 0f 1e fb          	endbr32 
80106494:	55                   	push   %ebp
80106495:	89 e5                	mov    %esp,%ebp
80106497:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010649a:	e8 01 cc ff ff       	call   801030a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010649f:	83 ec 08             	sub    $0x8,%esp
801064a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064a5:	50                   	push   %eax
801064a6:	6a 00                	push   $0x0
801064a8:	e8 e3 f6 ff ff       	call   80105b90 <argstr>
801064ad:	83 c4 10             	add    $0x10,%esp
801064b0:	85 c0                	test   %eax,%eax
801064b2:	78 34                	js     801064e8 <sys_mkdir+0x58>
801064b4:	83 ec 0c             	sub    $0xc,%esp
801064b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ba:	31 c9                	xor    %ecx,%ecx
801064bc:	ba 01 00 00 00       	mov    $0x1,%edx
801064c1:	6a 00                	push   $0x0
801064c3:	e8 78 f7 ff ff       	call   80105c40 <create>
801064c8:	83 c4 10             	add    $0x10,%esp
801064cb:	85 c0                	test   %eax,%eax
801064cd:	74 19                	je     801064e8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801064cf:	83 ec 0c             	sub    $0xc,%esp
801064d2:	50                   	push   %eax
801064d3:	e8 98 b8 ff ff       	call   80101d70 <iunlockput>
  end_op();
801064d8:	e8 33 cc ff ff       	call   80103110 <end_op>
  return 0;
801064dd:	83 c4 10             	add    $0x10,%esp
801064e0:	31 c0                	xor    %eax,%eax
}
801064e2:	c9                   	leave  
801064e3:	c3                   	ret    
801064e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801064e8:	e8 23 cc ff ff       	call   80103110 <end_op>
    return -1;
801064ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064f2:	c9                   	leave  
801064f3:	c3                   	ret    
801064f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064ff:	90                   	nop

80106500 <sys_mknod>:

int
sys_mknod(void)
{
80106500:	f3 0f 1e fb          	endbr32 
80106504:	55                   	push   %ebp
80106505:	89 e5                	mov    %esp,%ebp
80106507:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010650a:	e8 91 cb ff ff       	call   801030a0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010650f:	83 ec 08             	sub    $0x8,%esp
80106512:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106515:	50                   	push   %eax
80106516:	6a 00                	push   $0x0
80106518:	e8 73 f6 ff ff       	call   80105b90 <argstr>
8010651d:	83 c4 10             	add    $0x10,%esp
80106520:	85 c0                	test   %eax,%eax
80106522:	78 64                	js     80106588 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80106524:	83 ec 08             	sub    $0x8,%esp
80106527:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010652a:	50                   	push   %eax
8010652b:	6a 01                	push   $0x1
8010652d:	e8 ae f5 ff ff       	call   80105ae0 <argint>
  if((argstr(0, &path)) < 0 ||
80106532:	83 c4 10             	add    $0x10,%esp
80106535:	85 c0                	test   %eax,%eax
80106537:	78 4f                	js     80106588 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80106539:	83 ec 08             	sub    $0x8,%esp
8010653c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010653f:	50                   	push   %eax
80106540:	6a 02                	push   $0x2
80106542:	e8 99 f5 ff ff       	call   80105ae0 <argint>
     argint(1, &major) < 0 ||
80106547:	83 c4 10             	add    $0x10,%esp
8010654a:	85 c0                	test   %eax,%eax
8010654c:	78 3a                	js     80106588 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010654e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80106552:	83 ec 0c             	sub    $0xc,%esp
80106555:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106559:	ba 03 00 00 00       	mov    $0x3,%edx
8010655e:	50                   	push   %eax
8010655f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106562:	e8 d9 f6 ff ff       	call   80105c40 <create>
     argint(2, &minor) < 0 ||
80106567:	83 c4 10             	add    $0x10,%esp
8010656a:	85 c0                	test   %eax,%eax
8010656c:	74 1a                	je     80106588 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010656e:	83 ec 0c             	sub    $0xc,%esp
80106571:	50                   	push   %eax
80106572:	e8 f9 b7 ff ff       	call   80101d70 <iunlockput>
  end_op();
80106577:	e8 94 cb ff ff       	call   80103110 <end_op>
  return 0;
8010657c:	83 c4 10             	add    $0x10,%esp
8010657f:	31 c0                	xor    %eax,%eax
}
80106581:	c9                   	leave  
80106582:	c3                   	ret    
80106583:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106587:	90                   	nop
    end_op();
80106588:	e8 83 cb ff ff       	call   80103110 <end_op>
    return -1;
8010658d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106592:	c9                   	leave  
80106593:	c3                   	ret    
80106594:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010659b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010659f:	90                   	nop

801065a0 <sys_chdir>:

int
sys_chdir(void)
{
801065a0:	f3 0f 1e fb          	endbr32 
801065a4:	55                   	push   %ebp
801065a5:	89 e5                	mov    %esp,%ebp
801065a7:	56                   	push   %esi
801065a8:	53                   	push   %ebx
801065a9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801065ac:	e8 ef d7 ff ff       	call   80103da0 <myproc>
801065b1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801065b3:	e8 e8 ca ff ff       	call   801030a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801065b8:	83 ec 08             	sub    $0x8,%esp
801065bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065be:	50                   	push   %eax
801065bf:	6a 00                	push   $0x0
801065c1:	e8 ca f5 ff ff       	call   80105b90 <argstr>
801065c6:	83 c4 10             	add    $0x10,%esp
801065c9:	85 c0                	test   %eax,%eax
801065cb:	78 73                	js     80106640 <sys_chdir+0xa0>
801065cd:	83 ec 0c             	sub    $0xc,%esp
801065d0:	ff 75 f4             	pushl  -0xc(%ebp)
801065d3:	e8 c8 bd ff ff       	call   801023a0 <namei>
801065d8:	83 c4 10             	add    $0x10,%esp
801065db:	89 c3                	mov    %eax,%ebx
801065dd:	85 c0                	test   %eax,%eax
801065df:	74 5f                	je     80106640 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801065e1:	83 ec 0c             	sub    $0xc,%esp
801065e4:	50                   	push   %eax
801065e5:	e8 e6 b4 ff ff       	call   80101ad0 <ilock>
  if(ip->type != T_DIR){
801065ea:	83 c4 10             	add    $0x10,%esp
801065ed:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801065f2:	75 2c                	jne    80106620 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801065f4:	83 ec 0c             	sub    $0xc,%esp
801065f7:	53                   	push   %ebx
801065f8:	e8 b3 b5 ff ff       	call   80101bb0 <iunlock>
  iput(curproc->cwd);
801065fd:	58                   	pop    %eax
801065fe:	ff 76 68             	pushl  0x68(%esi)
80106601:	e8 fa b5 ff ff       	call   80101c00 <iput>
  end_op();
80106606:	e8 05 cb ff ff       	call   80103110 <end_op>
  curproc->cwd = ip;
8010660b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010660e:	83 c4 10             	add    $0x10,%esp
80106611:	31 c0                	xor    %eax,%eax
}
80106613:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106616:	5b                   	pop    %ebx
80106617:	5e                   	pop    %esi
80106618:	5d                   	pop    %ebp
80106619:	c3                   	ret    
8010661a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80106620:	83 ec 0c             	sub    $0xc,%esp
80106623:	53                   	push   %ebx
80106624:	e8 47 b7 ff ff       	call   80101d70 <iunlockput>
    end_op();
80106629:	e8 e2 ca ff ff       	call   80103110 <end_op>
    return -1;
8010662e:	83 c4 10             	add    $0x10,%esp
80106631:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106636:	eb db                	jmp    80106613 <sys_chdir+0x73>
80106638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010663f:	90                   	nop
    end_op();
80106640:	e8 cb ca ff ff       	call   80103110 <end_op>
    return -1;
80106645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010664a:	eb c7                	jmp    80106613 <sys_chdir+0x73>
8010664c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106650 <sys_exec>:

int
sys_exec(void)
{
80106650:	f3 0f 1e fb          	endbr32 
80106654:	55                   	push   %ebp
80106655:	89 e5                	mov    %esp,%ebp
80106657:	57                   	push   %edi
80106658:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106659:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010665f:	53                   	push   %ebx
80106660:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106666:	50                   	push   %eax
80106667:	6a 00                	push   $0x0
80106669:	e8 22 f5 ff ff       	call   80105b90 <argstr>
8010666e:	83 c4 10             	add    $0x10,%esp
80106671:	85 c0                	test   %eax,%eax
80106673:	0f 88 8b 00 00 00    	js     80106704 <sys_exec+0xb4>
80106679:	83 ec 08             	sub    $0x8,%esp
8010667c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106682:	50                   	push   %eax
80106683:	6a 01                	push   $0x1
80106685:	e8 56 f4 ff ff       	call   80105ae0 <argint>
8010668a:	83 c4 10             	add    $0x10,%esp
8010668d:	85 c0                	test   %eax,%eax
8010668f:	78 73                	js     80106704 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106691:	83 ec 04             	sub    $0x4,%esp
80106694:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010669a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010669c:	68 80 00 00 00       	push   $0x80
801066a1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801066a7:	6a 00                	push   $0x0
801066a9:	50                   	push   %eax
801066aa:	e8 51 f1 ff ff       	call   80105800 <memset>
801066af:	83 c4 10             	add    $0x10,%esp
801066b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801066b8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801066be:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801066c5:	83 ec 08             	sub    $0x8,%esp
801066c8:	57                   	push   %edi
801066c9:	01 f0                	add    %esi,%eax
801066cb:	50                   	push   %eax
801066cc:	e8 6f f3 ff ff       	call   80105a40 <fetchint>
801066d1:	83 c4 10             	add    $0x10,%esp
801066d4:	85 c0                	test   %eax,%eax
801066d6:	78 2c                	js     80106704 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
801066d8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801066de:	85 c0                	test   %eax,%eax
801066e0:	74 36                	je     80106718 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801066e2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801066e8:	83 ec 08             	sub    $0x8,%esp
801066eb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801066ee:	52                   	push   %edx
801066ef:	50                   	push   %eax
801066f0:	e8 8b f3 ff ff       	call   80105a80 <fetchstr>
801066f5:	83 c4 10             	add    $0x10,%esp
801066f8:	85 c0                	test   %eax,%eax
801066fa:	78 08                	js     80106704 <sys_exec+0xb4>
  for(i=0;; i++){
801066fc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801066ff:	83 fb 20             	cmp    $0x20,%ebx
80106702:	75 b4                	jne    801066b8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106704:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106707:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010670c:	5b                   	pop    %ebx
8010670d:	5e                   	pop    %esi
8010670e:	5f                   	pop    %edi
8010670f:	5d                   	pop    %ebp
80106710:	c3                   	ret    
80106711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106718:	83 ec 08             	sub    $0x8,%esp
8010671b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80106721:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106728:	00 00 00 00 
  return exec(path, argv);
8010672c:	50                   	push   %eax
8010672d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106733:	e8 a8 a6 ff ff       	call   80100de0 <exec>
80106738:	83 c4 10             	add    $0x10,%esp
}
8010673b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010673e:	5b                   	pop    %ebx
8010673f:	5e                   	pop    %esi
80106740:	5f                   	pop    %edi
80106741:	5d                   	pop    %ebp
80106742:	c3                   	ret    
80106743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010674a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106750 <sys_pipe>:

int
sys_pipe(void)
{
80106750:	f3 0f 1e fb          	endbr32 
80106754:	55                   	push   %ebp
80106755:	89 e5                	mov    %esp,%ebp
80106757:	57                   	push   %edi
80106758:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106759:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010675c:	53                   	push   %ebx
8010675d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106760:	6a 08                	push   $0x8
80106762:	50                   	push   %eax
80106763:	6a 00                	push   $0x0
80106765:	e8 c6 f3 ff ff       	call   80105b30 <argptr>
8010676a:	83 c4 10             	add    $0x10,%esp
8010676d:	85 c0                	test   %eax,%eax
8010676f:	78 4e                	js     801067bf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106771:	83 ec 08             	sub    $0x8,%esp
80106774:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106777:	50                   	push   %eax
80106778:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010677b:	50                   	push   %eax
8010677c:	e8 df cf ff ff       	call   80103760 <pipealloc>
80106781:	83 c4 10             	add    $0x10,%esp
80106784:	85 c0                	test   %eax,%eax
80106786:	78 37                	js     801067bf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106788:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010678b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010678d:	e8 0e d6 ff ff       	call   80103da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106798:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010679c:	85 f6                	test   %esi,%esi
8010679e:	74 30                	je     801067d0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801067a0:	83 c3 01             	add    $0x1,%ebx
801067a3:	83 fb 10             	cmp    $0x10,%ebx
801067a6:	75 f0                	jne    80106798 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801067a8:	83 ec 0c             	sub    $0xc,%esp
801067ab:	ff 75 e0             	pushl  -0x20(%ebp)
801067ae:	e8 7d aa ff ff       	call   80101230 <fileclose>
    fileclose(wf);
801067b3:	58                   	pop    %eax
801067b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801067b7:	e8 74 aa ff ff       	call   80101230 <fileclose>
    return -1;
801067bc:	83 c4 10             	add    $0x10,%esp
801067bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067c4:	eb 5b                	jmp    80106821 <sys_pipe+0xd1>
801067c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067cd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801067d0:	8d 73 08             	lea    0x8(%ebx),%esi
801067d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801067d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801067da:	e8 c1 d5 ff ff       	call   80103da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801067df:	31 d2                	xor    %edx,%edx
801067e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801067e8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801067ec:	85 c9                	test   %ecx,%ecx
801067ee:	74 20                	je     80106810 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801067f0:	83 c2 01             	add    $0x1,%edx
801067f3:	83 fa 10             	cmp    $0x10,%edx
801067f6:	75 f0                	jne    801067e8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801067f8:	e8 a3 d5 ff ff       	call   80103da0 <myproc>
801067fd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106804:	00 
80106805:	eb a1                	jmp    801067a8 <sys_pipe+0x58>
80106807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010680e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106810:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106814:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106817:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106819:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010681c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010681f:	31 c0                	xor    %eax,%eax
}
80106821:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106824:	5b                   	pop    %ebx
80106825:	5e                   	pop    %esi
80106826:	5f                   	pop    %edi
80106827:	5d                   	pop    %ebp
80106828:	c3                   	ret    
80106829:	66 90                	xchg   %ax,%ax
8010682b:	66 90                	xchg   %ax,%ax
8010682d:	66 90                	xchg   %ax,%ax
8010682f:	90                   	nop

80106830 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106830:	f3 0f 1e fb          	endbr32 
  return fork();
80106834:	e9 17 d7 ff ff       	jmp    80103f50 <fork>
80106839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106840 <sys_exit>:
}

int
sys_exit(void)
{
80106840:	f3 0f 1e fb          	endbr32 
80106844:	55                   	push   %ebp
80106845:	89 e5                	mov    %esp,%ebp
80106847:	83 ec 08             	sub    $0x8,%esp
  exit();
8010684a:	e8 b1 e6 ff ff       	call   80104f00 <exit>
  return 0;  // not reached
}
8010684f:	31 c0                	xor    %eax,%eax
80106851:	c9                   	leave  
80106852:	c3                   	ret    
80106853:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010685a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106860 <sys_wait>:

int
sys_wait(void)
{
80106860:	f3 0f 1e fb          	endbr32 
  return wait();
80106864:	e9 e7 e8 ff ff       	jmp    80105150 <wait>
80106869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106870 <sys_kill>:
}

int
sys_kill(void)
{
80106870:	f3 0f 1e fb          	endbr32 
80106874:	55                   	push   %ebp
80106875:	89 e5                	mov    %esp,%ebp
80106877:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010687a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010687d:	50                   	push   %eax
8010687e:	6a 00                	push   $0x0
80106880:	e8 5b f2 ff ff       	call   80105ae0 <argint>
80106885:	83 c4 10             	add    $0x10,%esp
80106888:	85 c0                	test   %eax,%eax
8010688a:	78 14                	js     801068a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010688c:	83 ec 0c             	sub    $0xc,%esp
8010688f:	ff 75 f4             	pushl  -0xc(%ebp)
80106892:	e8 29 ea ff ff       	call   801052c0 <kill>
80106897:	83 c4 10             	add    $0x10,%esp
}
8010689a:	c9                   	leave  
8010689b:	c3                   	ret    
8010689c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068a0:	c9                   	leave  
    return -1;
801068a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068a6:	c3                   	ret    
801068a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068ae:	66 90                	xchg   %ax,%ax

801068b0 <sys_getpid>:

int
sys_getpid(void)
{
801068b0:	f3 0f 1e fb          	endbr32 
801068b4:	55                   	push   %ebp
801068b5:	89 e5                	mov    %esp,%ebp
801068b7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801068ba:	e8 e1 d4 ff ff       	call   80103da0 <myproc>
801068bf:	8b 40 10             	mov    0x10(%eax),%eax
}
801068c2:	c9                   	leave  
801068c3:	c3                   	ret    
801068c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068cf:	90                   	nop

801068d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801068d0:	f3 0f 1e fb          	endbr32 
801068d4:	55                   	push   %ebp
801068d5:	89 e5                	mov    %esp,%ebp
801068d7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801068d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801068db:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801068de:	50                   	push   %eax
801068df:	6a 00                	push   $0x0
801068e1:	e8 fa f1 ff ff       	call   80105ae0 <argint>
801068e6:	83 c4 10             	add    $0x10,%esp
801068e9:	85 c0                	test   %eax,%eax
801068eb:	78 23                	js     80106910 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801068ed:	e8 ae d4 ff ff       	call   80103da0 <myproc>
  if(growproc(n) < 0)
801068f2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801068f5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801068f7:	ff 75 f4             	pushl  -0xc(%ebp)
801068fa:	e8 d1 d5 ff ff       	call   80103ed0 <growproc>
801068ff:	83 c4 10             	add    $0x10,%esp
80106902:	85 c0                	test   %eax,%eax
80106904:	78 0a                	js     80106910 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106906:	89 d8                	mov    %ebx,%eax
80106908:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010690b:	c9                   	leave  
8010690c:	c3                   	ret    
8010690d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106910:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106915:	eb ef                	jmp    80106906 <sys_sbrk+0x36>
80106917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010691e:	66 90                	xchg   %ax,%ax

80106920 <sys_sleep>:

int
sys_sleep(void)
{
80106920:	f3 0f 1e fb          	endbr32 
80106924:	55                   	push   %ebp
80106925:	89 e5                	mov    %esp,%ebp
80106927:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106928:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010692b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010692e:	50                   	push   %eax
8010692f:	6a 00                	push   $0x0
80106931:	e8 aa f1 ff ff       	call   80105ae0 <argint>
80106936:	83 c4 10             	add    $0x10,%esp
80106939:	85 c0                	test   %eax,%eax
8010693b:	0f 88 86 00 00 00    	js     801069c7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106941:	83 ec 0c             	sub    $0xc,%esp
80106944:	68 80 97 11 80       	push   $0x80119780
80106949:	e8 a2 ed ff ff       	call   801056f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010694e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106951:	8b 1d c0 9f 11 80    	mov    0x80119fc0,%ebx
  while(ticks - ticks0 < n){
80106957:	83 c4 10             	add    $0x10,%esp
8010695a:	85 d2                	test   %edx,%edx
8010695c:	75 23                	jne    80106981 <sys_sleep+0x61>
8010695e:	eb 50                	jmp    801069b0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106960:	83 ec 08             	sub    $0x8,%esp
80106963:	68 80 97 11 80       	push   $0x80119780
80106968:	68 c0 9f 11 80       	push   $0x80119fc0
8010696d:	e8 1e e7 ff ff       	call   80105090 <sleep>
  while(ticks - ticks0 < n){
80106972:	a1 c0 9f 11 80       	mov    0x80119fc0,%eax
80106977:	83 c4 10             	add    $0x10,%esp
8010697a:	29 d8                	sub    %ebx,%eax
8010697c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010697f:	73 2f                	jae    801069b0 <sys_sleep+0x90>
    if(myproc()->killed){
80106981:	e8 1a d4 ff ff       	call   80103da0 <myproc>
80106986:	8b 40 24             	mov    0x24(%eax),%eax
80106989:	85 c0                	test   %eax,%eax
8010698b:	74 d3                	je     80106960 <sys_sleep+0x40>
      release(&tickslock);
8010698d:	83 ec 0c             	sub    $0xc,%esp
80106990:	68 80 97 11 80       	push   $0x80119780
80106995:	e8 16 ee ff ff       	call   801057b0 <release>
  }
  release(&tickslock);
  return 0;
}
8010699a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010699d:	83 c4 10             	add    $0x10,%esp
801069a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069a5:	c9                   	leave  
801069a6:	c3                   	ret    
801069a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069ae:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801069b0:	83 ec 0c             	sub    $0xc,%esp
801069b3:	68 80 97 11 80       	push   $0x80119780
801069b8:	e8 f3 ed ff ff       	call   801057b0 <release>
  return 0;
801069bd:	83 c4 10             	add    $0x10,%esp
801069c0:	31 c0                	xor    %eax,%eax
}
801069c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801069c5:	c9                   	leave  
801069c6:	c3                   	ret    
    return -1;
801069c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069cc:	eb f4                	jmp    801069c2 <sys_sleep+0xa2>
801069ce:	66 90                	xchg   %ax,%ax

801069d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801069d0:	f3 0f 1e fb          	endbr32 
801069d4:	55                   	push   %ebp
801069d5:	89 e5                	mov    %esp,%ebp
801069d7:	53                   	push   %ebx
801069d8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801069db:	68 80 97 11 80       	push   $0x80119780
801069e0:	e8 0b ed ff ff       	call   801056f0 <acquire>
  xticks = ticks;
801069e5:	8b 1d c0 9f 11 80    	mov    0x80119fc0,%ebx
  release(&tickslock);
801069eb:	c7 04 24 80 97 11 80 	movl   $0x80119780,(%esp)
801069f2:	e8 b9 ed ff ff       	call   801057b0 <release>
  return xticks;
}
801069f7:	89 d8                	mov    %ebx,%eax
801069f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801069fc:	c9                   	leave  
801069fd:	c3                   	ret    
801069fe:	66 90                	xchg   %ax,%ax

80106a00 <sys_reverse_number>:

int
sys_reverse_number(void){
80106a00:	f3 0f 1e fb          	endbr32 
80106a04:	55                   	push   %ebp
80106a05:	89 e5                	mov    %esp,%ebp
80106a07:	57                   	push   %edi
80106a08:	56                   	push   %esi
80106a09:	8d 7d d8             	lea    -0x28(%ebp),%edi

  char answer[16] = {"\0"};

  int tmp = 0;
  do{
    answer[tmp] = (char) ((num % 10) + '0');
80106a0c:	be 67 66 66 66       	mov    $0x66666667,%esi
sys_reverse_number(void){
80106a11:	53                   	push   %ebx
80106a12:	89 fb                	mov    %edi,%ebx
80106a14:	83 ec 1c             	sub    $0x1c,%esp
  num = myproc()->tf->ebx;
80106a17:	e8 84 d3 ff ff       	call   80103da0 <myproc>
  char answer[16] = {"\0"};
80106a1c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  num = myproc()->tf->ebx;
80106a23:	8b 40 18             	mov    0x18(%eax),%eax
80106a26:	8b 48 10             	mov    0x10(%eax),%ecx
  char answer[16] = {"\0"};
80106a29:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80106a30:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106a37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int tmp = 0;
80106a3e:	66 90                	xchg   %ax,%ax
    answer[tmp] = (char) ((num % 10) + '0');
80106a40:	89 c8                	mov    %ecx,%eax
80106a42:	83 c3 01             	add    $0x1,%ebx
80106a45:	f7 ee                	imul   %esi
80106a47:	89 c8                	mov    %ecx,%eax
80106a49:	c1 f8 1f             	sar    $0x1f,%eax
80106a4c:	c1 fa 02             	sar    $0x2,%edx
80106a4f:	29 c2                	sub    %eax,%edx
80106a51:	8d 04 92             	lea    (%edx,%edx,4),%eax
80106a54:	01 c0                	add    %eax,%eax
80106a56:	29 c1                	sub    %eax,%ecx
80106a58:	83 c1 30             	add    $0x30,%ecx
80106a5b:	88 4b ff             	mov    %cl,-0x1(%ebx)
    num /= 10;
80106a5e:	89 d1                	mov    %edx,%ecx
    tmp++;
  }while(num);
80106a60:	85 d2                	test   %edx,%edx
80106a62:	75 dc                	jne    80106a40 <sys_reverse_number+0x40>

  cprintf("%s\n" , answer);
80106a64:	83 ec 08             	sub    $0x8,%esp
80106a67:	57                   	push   %edi
80106a68:	68 59 8e 10 80       	push   $0x80108e59
80106a6d:	e8 3e 9c ff ff       	call   801006b0 <cprintf>
  return 0;
}
80106a72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a75:	31 c0                	xor    %eax,%eax
80106a77:	5b                   	pop    %ebx
80106a78:	5e                   	pop    %esi
80106a79:	5f                   	pop    %edi
80106a7a:	5d                   	pop    %ebp
80106a7b:	c3                   	ret    
80106a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a80 <sys_get_children>:

int 
sys_get_children(void){
80106a80:	f3 0f 1e fb          	endbr32 
80106a84:	55                   	push   %ebp
80106a85:	89 e5                	mov    %esp,%ebp
80106a87:	83 ec 1c             	sub    $0x1c,%esp
  int pid;
  argptr(0 , (void*)&pid , sizeof(pid));
80106a8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a8d:	6a 04                	push   $0x4
80106a8f:	50                   	push   %eax
80106a90:	6a 00                	push   $0x0
80106a92:	e8 99 f0 ff ff       	call   80105b30 <argptr>

  int result = get_children(pid);
80106a97:	58                   	pop    %eax
80106a98:	ff 75 f4             	pushl  -0xc(%ebp)
80106a9b:	e8 80 d6 ff ff       	call   80104120 <get_children>
  return result;
}
80106aa0:	c9                   	leave  
80106aa1:	c3                   	ret    
80106aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ab0 <sys_trace_syscalls>:

int
sys_trace_syscalls(void){
80106ab0:	f3 0f 1e fb          	endbr32 
80106ab4:	55                   	push   %ebp
80106ab5:	89 e5                	mov    %esp,%ebp
80106ab7:	83 ec 20             	sub    $0x20,%esp
  int state;
  argint(0, &state);
80106aba:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106abd:	50                   	push   %eax
80106abe:	6a 00                	push   $0x0
80106ac0:	e8 1b f0 ff ff       	call   80105ae0 <argint>
  trace_syscalls(state);
80106ac5:	58                   	pop    %eax
80106ac6:	ff 75 f4             	pushl  -0xc(%ebp)
80106ac9:	e8 e2 d6 ff ff       	call   801041b0 <trace_syscalls>
  return 0;
}
80106ace:	31 c0                	xor    %eax,%eax
80106ad0:	c9                   	leave  
80106ad1:	c3                   	ret    
80106ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ae0 <sys_print_procs_info>:

int
sys_print_procs_info(void){
80106ae0:	f3 0f 1e fb          	endbr32 
80106ae4:	55                   	push   %ebp
80106ae5:	89 e5                	mov    %esp,%ebp
80106ae7:	83 ec 08             	sub    $0x8,%esp
  print_procs_info();
80106aea:	e8 91 d9 ff ff       	call   80104480 <print_procs_info>
  return 0;
}
80106aef:	31 c0                	xor    %eax,%eax
80106af1:	c9                   	leave  
80106af2:	c3                   	ret    
80106af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b00 <sys_change_queue>:

int
sys_change_queue(void){
80106b00:	f3 0f 1e fb          	endbr32 
80106b04:	55                   	push   %ebp
80106b05:	89 e5                	mov    %esp,%ebp
80106b07:	83 ec 1c             	sub    $0x1c,%esp
  int pid, new_queue;
  argptr(0 , (void*)&pid , sizeof(pid));
80106b0a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b0d:	6a 04                	push   $0x4
80106b0f:	50                   	push   %eax
80106b10:	6a 00                	push   $0x0
80106b12:	e8 19 f0 ff ff       	call   80105b30 <argptr>
  argptr(1 , (void*)&new_queue , sizeof(new_queue));
80106b17:	83 c4 0c             	add    $0xc,%esp
80106b1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b1d:	6a 04                	push   $0x4
80106b1f:	50                   	push   %eax
80106b20:	6a 01                	push   $0x1
80106b22:	e8 09 f0 ff ff       	call   80105b30 <argptr>

  change_queue(pid , new_queue);
80106b27:	58                   	pop    %eax
80106b28:	5a                   	pop    %edx
80106b29:	ff 75 f4             	pushl  -0xc(%ebp)
80106b2c:	ff 75 f0             	pushl  -0x10(%ebp)
80106b2f:	e8 2c dc ff ff       	call   80104760 <change_queue>
  return 0;
}
80106b34:	31 c0                	xor    %eax,%eax
80106b36:	c9                   	leave  
80106b37:	c3                   	ret    
80106b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b3f:	90                   	nop

80106b40 <sys_change_ticket>:

int
sys_change_ticket(void){
80106b40:	f3 0f 1e fb          	endbr32 
80106b44:	55                   	push   %ebp
80106b45:	89 e5                	mov    %esp,%ebp
80106b47:	83 ec 1c             	sub    $0x1c,%esp
  int pid, new_ticket;
  argptr(0 , (void*)&pid , sizeof(pid));
80106b4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b4d:	6a 04                	push   $0x4
80106b4f:	50                   	push   %eax
80106b50:	6a 00                	push   $0x0
80106b52:	e8 d9 ef ff ff       	call   80105b30 <argptr>
  argptr(1 , (void*)&new_ticket , sizeof(new_ticket));
80106b57:	83 c4 0c             	add    $0xc,%esp
80106b5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b5d:	6a 04                	push   $0x4
80106b5f:	50                   	push   %eax
80106b60:	6a 01                	push   $0x1
80106b62:	e8 c9 ef ff ff       	call   80105b30 <argptr>

  change_ticket(pid, new_ticket);
80106b67:	58                   	pop    %eax
80106b68:	5a                   	pop    %edx
80106b69:	ff 75 f4             	pushl  -0xc(%ebp)
80106b6c:	ff 75 f0             	pushl  -0x10(%ebp)
80106b6f:	e8 4c dc ff ff       	call   801047c0 <change_ticket>
  return 0;
}
80106b74:	31 c0                	xor    %eax,%eax
80106b76:	c9                   	leave  
80106b77:	c3                   	ret    
80106b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b7f:	90                   	nop

80106b80 <sys_change_BJF_parameters_individual>:

int
sys_change_BJF_parameters_individual(void){
80106b80:	f3 0f 1e fb          	endbr32 
80106b84:	55                   	push   %ebp
80106b85:	89 e5                	mov    %esp,%ebp
80106b87:	83 ec 1c             	sub    $0x1c,%esp
  int pid;

  char* ratio[3];

  argptr(0 , (void*)&pid , sizeof(pid));
80106b8a:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106b8d:	6a 04                	push   $0x4
80106b8f:	50                   	push   %eax
80106b90:	6a 00                	push   $0x0
80106b92:	e8 99 ef ff ff       	call   80105b30 <argptr>
  argstr(1 , (void*)&ratio[0]);
80106b97:	58                   	pop    %eax
80106b98:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b9b:	5a                   	pop    %edx
80106b9c:	50                   	push   %eax
80106b9d:	6a 01                	push   $0x1
80106b9f:	e8 ec ef ff ff       	call   80105b90 <argstr>
  argstr(2 , (void*)&ratio[1]);
80106ba4:	59                   	pop    %ecx
80106ba5:	58                   	pop    %eax
80106ba6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ba9:	50                   	push   %eax
80106baa:	6a 02                	push   $0x2
80106bac:	e8 df ef ff ff       	call   80105b90 <argstr>
  argstr(3 , (void*)&ratio[2]);
80106bb1:	58                   	pop    %eax
80106bb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bb5:	5a                   	pop    %edx
80106bb6:	50                   	push   %eax
80106bb7:	6a 03                	push   $0x3
80106bb9:	e8 d2 ef ff ff       	call   80105b90 <argstr>

  change_BJF_parameters_individual(pid, ratio[0], ratio[1], ratio[2]);
80106bbe:	ff 75 f4             	pushl  -0xc(%ebp)
80106bc1:	ff 75 f0             	pushl  -0x10(%ebp)
80106bc4:	ff 75 ec             	pushl  -0x14(%ebp)
80106bc7:	ff 75 e8             	pushl  -0x18(%ebp)
80106bca:	e8 e1 dc ff ff       	call   801048b0 <change_BJF_parameters_individual>
  return 0; 
}
80106bcf:	31 c0                	xor    %eax,%eax
80106bd1:	c9                   	leave  
80106bd2:	c3                   	ret    
80106bd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106be0 <sys_change_BJF_parameters_all>:

int
sys_change_BJF_parameters_all(void){
80106be0:	f3 0f 1e fb          	endbr32 
80106be4:	55                   	push   %ebp
80106be5:	89 e5                	mov    %esp,%ebp
80106be7:	83 ec 20             	sub    $0x20,%esp
  char* ratio[3];

  argstr(0 , (void*)&ratio[0]);
80106bea:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106bed:	50                   	push   %eax
80106bee:	6a 00                	push   $0x0
80106bf0:	e8 9b ef ff ff       	call   80105b90 <argstr>
  argstr(1 , (void*)&ratio[1]);
80106bf5:	58                   	pop    %eax
80106bf6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bf9:	5a                   	pop    %edx
80106bfa:	50                   	push   %eax
80106bfb:	6a 01                	push   $0x1
80106bfd:	e8 8e ef ff ff       	call   80105b90 <argstr>
  argstr(2 , (void*)&ratio[2]); 
80106c02:	59                   	pop    %ecx
80106c03:	58                   	pop    %eax
80106c04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c07:	50                   	push   %eax
80106c08:	6a 02                	push   $0x2
80106c0a:	e8 81 ef ff ff       	call   80105b90 <argstr>

  change_BJF_parameters_all(ratio[0], ratio[1], ratio[2]);
80106c0f:	83 c4 0c             	add    $0xc,%esp
80106c12:	ff 75 f4             	pushl  -0xc(%ebp)
80106c15:	ff 75 f0             	pushl  -0x10(%ebp)
80106c18:	ff 75 ec             	pushl  -0x14(%ebp)
80106c1b:	e8 30 dd ff ff       	call   80104950 <change_BJF_parameters_all>
  return 0;
80106c20:	31 c0                	xor    %eax,%eax
80106c22:	c9                   	leave  
80106c23:	c3                   	ret    

80106c24 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106c24:	1e                   	push   %ds
  pushl %es
80106c25:	06                   	push   %es
  pushl %fs
80106c26:	0f a0                	push   %fs
  pushl %gs
80106c28:	0f a8                	push   %gs
  pushal
80106c2a:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106c2b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106c2f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106c31:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106c33:	54                   	push   %esp
  call trap
80106c34:	e8 c7 00 00 00       	call   80106d00 <trap>
  addl $4, %esp
80106c39:	83 c4 04             	add    $0x4,%esp

80106c3c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106c3c:	61                   	popa   
  popl %gs
80106c3d:	0f a9                	pop    %gs
  popl %fs
80106c3f:	0f a1                	pop    %fs
  popl %es
80106c41:	07                   	pop    %es
  popl %ds
80106c42:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106c43:	83 c4 08             	add    $0x8,%esp
  iret
80106c46:	cf                   	iret   
80106c47:	66 90                	xchg   %ax,%ax
80106c49:	66 90                	xchg   %ax,%ax
80106c4b:	66 90                	xchg   %ax,%ax
80106c4d:	66 90                	xchg   %ax,%ax
80106c4f:	90                   	nop

80106c50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106c50:	f3 0f 1e fb          	endbr32 
80106c54:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106c55:	31 c0                	xor    %eax,%eax
{
80106c57:	89 e5                	mov    %esp,%ebp
80106c59:	83 ec 08             	sub    $0x8,%esp
80106c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106c60:	8b 14 85 98 c0 10 80 	mov    -0x7fef3f68(,%eax,4),%edx
80106c67:	c7 04 c5 c2 97 11 80 	movl   $0x8e000008,-0x7fee683e(,%eax,8)
80106c6e:	08 00 00 8e 
80106c72:	66 89 14 c5 c0 97 11 	mov    %dx,-0x7fee6840(,%eax,8)
80106c79:	80 
80106c7a:	c1 ea 10             	shr    $0x10,%edx
80106c7d:	66 89 14 c5 c6 97 11 	mov    %dx,-0x7fee683a(,%eax,8)
80106c84:	80 
  for(i = 0; i < 256; i++)
80106c85:	83 c0 01             	add    $0x1,%eax
80106c88:	3d 00 01 00 00       	cmp    $0x100,%eax
80106c8d:	75 d1                	jne    80106c60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106c8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106c92:	a1 98 c1 10 80       	mov    0x8010c198,%eax
80106c97:	c7 05 c2 99 11 80 08 	movl   $0xef000008,0x801199c2
80106c9e:	00 00 ef 
  initlock(&tickslock, "time");
80106ca1:	68 c9 8b 10 80       	push   $0x80108bc9
80106ca6:	68 80 97 11 80       	push   $0x80119780
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106cab:	66 a3 c0 99 11 80    	mov    %ax,0x801199c0
80106cb1:	c1 e8 10             	shr    $0x10,%eax
80106cb4:	66 a3 c6 99 11 80    	mov    %ax,0x801199c6
  initlock(&tickslock, "time");
80106cba:	e8 b1 e8 ff ff       	call   80105570 <initlock>
}
80106cbf:	83 c4 10             	add    $0x10,%esp
80106cc2:	c9                   	leave  
80106cc3:	c3                   	ret    
80106cc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ccf:	90                   	nop

80106cd0 <idtinit>:

void
idtinit(void)
{
80106cd0:	f3 0f 1e fb          	endbr32 
80106cd4:	55                   	push   %ebp
  pd[0] = size-1;
80106cd5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106cda:	89 e5                	mov    %esp,%ebp
80106cdc:	83 ec 10             	sub    $0x10,%esp
80106cdf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106ce3:	b8 c0 97 11 80       	mov    $0x801197c0,%eax
80106ce8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106cec:	c1 e8 10             	shr    $0x10,%eax
80106cef:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106cf3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106cf6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106cf9:	c9                   	leave  
80106cfa:	c3                   	ret    
80106cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cff:	90                   	nop

80106d00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106d00:	f3 0f 1e fb          	endbr32 
80106d04:	55                   	push   %ebp
80106d05:	89 e5                	mov    %esp,%ebp
80106d07:	57                   	push   %edi
80106d08:	56                   	push   %esi
80106d09:	53                   	push   %ebx
80106d0a:	83 ec 1c             	sub    $0x1c,%esp
80106d0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106d10:	8b 43 30             	mov    0x30(%ebx),%eax
80106d13:	83 f8 40             	cmp    $0x40,%eax
80106d16:	0f 84 bc 01 00 00    	je     80106ed8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106d1c:	83 e8 20             	sub    $0x20,%eax
80106d1f:	83 f8 1f             	cmp    $0x1f,%eax
80106d22:	77 08                	ja     80106d2c <trap+0x2c>
80106d24:	3e ff 24 85 00 8f 10 	notrack jmp *-0x7fef7100(,%eax,4)
80106d2b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106d2c:	e8 6f d0 ff ff       	call   80103da0 <myproc>
80106d31:	8b 7b 38             	mov    0x38(%ebx),%edi
80106d34:	85 c0                	test   %eax,%eax
80106d36:	0f 84 eb 01 00 00    	je     80106f27 <trap+0x227>
80106d3c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106d40:	0f 84 e1 01 00 00    	je     80106f27 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106d46:	0f 20 d1             	mov    %cr2,%ecx
80106d49:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d4c:	e8 ff cf ff ff       	call   80103d50 <cpuid>
80106d51:	8b 73 30             	mov    0x30(%ebx),%esi
80106d54:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d57:	8b 43 34             	mov    0x34(%ebx),%eax
80106d5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106d5d:	e8 3e d0 ff ff       	call   80103da0 <myproc>
80106d62:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d65:	e8 36 d0 ff ff       	call   80103da0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d6a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106d6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106d70:	51                   	push   %ecx
80106d71:	57                   	push   %edi
80106d72:	52                   	push   %edx
80106d73:	ff 75 e4             	pushl  -0x1c(%ebp)
80106d76:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106d77:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106d7a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d7d:	56                   	push   %esi
80106d7e:	ff 70 10             	pushl  0x10(%eax)
80106d81:	68 bc 8e 10 80       	push   $0x80108ebc
80106d86:	e8 25 99 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106d8b:	83 c4 20             	add    $0x20,%esp
80106d8e:	e8 0d d0 ff ff       	call   80103da0 <myproc>
80106d93:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d9a:	e8 01 d0 ff ff       	call   80103da0 <myproc>
80106d9f:	85 c0                	test   %eax,%eax
80106da1:	74 1d                	je     80106dc0 <trap+0xc0>
80106da3:	e8 f8 cf ff ff       	call   80103da0 <myproc>
80106da8:	8b 50 24             	mov    0x24(%eax),%edx
80106dab:	85 d2                	test   %edx,%edx
80106dad:	74 11                	je     80106dc0 <trap+0xc0>
80106daf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106db3:	83 e0 03             	and    $0x3,%eax
80106db6:	66 83 f8 03          	cmp    $0x3,%ax
80106dba:	0f 84 50 01 00 00    	je     80106f10 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106dc0:	e8 db cf ff ff       	call   80103da0 <myproc>
80106dc5:	85 c0                	test   %eax,%eax
80106dc7:	74 0f                	je     80106dd8 <trap+0xd8>
80106dc9:	e8 d2 cf ff ff       	call   80103da0 <myproc>
80106dce:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106dd2:	0f 84 e8 00 00 00    	je     80106ec0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106dd8:	e8 c3 cf ff ff       	call   80103da0 <myproc>
80106ddd:	85 c0                	test   %eax,%eax
80106ddf:	74 1d                	je     80106dfe <trap+0xfe>
80106de1:	e8 ba cf ff ff       	call   80103da0 <myproc>
80106de6:	8b 40 24             	mov    0x24(%eax),%eax
80106de9:	85 c0                	test   %eax,%eax
80106deb:	74 11                	je     80106dfe <trap+0xfe>
80106ded:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106df1:	83 e0 03             	and    $0x3,%eax
80106df4:	66 83 f8 03          	cmp    $0x3,%ax
80106df8:	0f 84 03 01 00 00    	je     80106f01 <trap+0x201>
    exit();
}
80106dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e01:	5b                   	pop    %ebx
80106e02:	5e                   	pop    %esi
80106e03:	5f                   	pop    %edi
80106e04:	5d                   	pop    %ebp
80106e05:	c3                   	ret    
    ideintr();
80106e06:	e8 45 b7 ff ff       	call   80102550 <ideintr>
    lapiceoi();
80106e0b:	e8 20 be ff ff       	call   80102c30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e10:	e8 8b cf ff ff       	call   80103da0 <myproc>
80106e15:	85 c0                	test   %eax,%eax
80106e17:	75 8a                	jne    80106da3 <trap+0xa3>
80106e19:	eb a5                	jmp    80106dc0 <trap+0xc0>
    if(cpuid() == 0){
80106e1b:	e8 30 cf ff ff       	call   80103d50 <cpuid>
80106e20:	85 c0                	test   %eax,%eax
80106e22:	75 e7                	jne    80106e0b <trap+0x10b>
      acquire(&tickslock);
80106e24:	83 ec 0c             	sub    $0xc,%esp
80106e27:	68 80 97 11 80       	push   $0x80119780
80106e2c:	e8 bf e8 ff ff       	call   801056f0 <acquire>
      wakeup(&ticks);
80106e31:	c7 04 24 c0 9f 11 80 	movl   $0x80119fc0,(%esp)
      ticks++;
80106e38:	83 05 c0 9f 11 80 01 	addl   $0x1,0x80119fc0
      wakeup(&ticks);
80106e3f:	e8 0c e4 ff ff       	call   80105250 <wakeup>
      release(&tickslock);
80106e44:	c7 04 24 80 97 11 80 	movl   $0x80119780,(%esp)
80106e4b:	e8 60 e9 ff ff       	call   801057b0 <release>
80106e50:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106e53:	eb b6                	jmp    80106e0b <trap+0x10b>
    kbdintr();
80106e55:	e8 96 bc ff ff       	call   80102af0 <kbdintr>
    lapiceoi();
80106e5a:	e8 d1 bd ff ff       	call   80102c30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e5f:	e8 3c cf ff ff       	call   80103da0 <myproc>
80106e64:	85 c0                	test   %eax,%eax
80106e66:	0f 85 37 ff ff ff    	jne    80106da3 <trap+0xa3>
80106e6c:	e9 4f ff ff ff       	jmp    80106dc0 <trap+0xc0>
    uartintr();
80106e71:	e8 4a 02 00 00       	call   801070c0 <uartintr>
    lapiceoi();
80106e76:	e8 b5 bd ff ff       	call   80102c30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e7b:	e8 20 cf ff ff       	call   80103da0 <myproc>
80106e80:	85 c0                	test   %eax,%eax
80106e82:	0f 85 1b ff ff ff    	jne    80106da3 <trap+0xa3>
80106e88:	e9 33 ff ff ff       	jmp    80106dc0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106e8d:	8b 7b 38             	mov    0x38(%ebx),%edi
80106e90:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106e94:	e8 b7 ce ff ff       	call   80103d50 <cpuid>
80106e99:	57                   	push   %edi
80106e9a:	56                   	push   %esi
80106e9b:	50                   	push   %eax
80106e9c:	68 64 8e 10 80       	push   $0x80108e64
80106ea1:	e8 0a 98 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106ea6:	e8 85 bd ff ff       	call   80102c30 <lapiceoi>
    break;
80106eab:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106eae:	e8 ed ce ff ff       	call   80103da0 <myproc>
80106eb3:	85 c0                	test   %eax,%eax
80106eb5:	0f 85 e8 fe ff ff    	jne    80106da3 <trap+0xa3>
80106ebb:	e9 00 ff ff ff       	jmp    80106dc0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106ec0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106ec4:	0f 85 0e ff ff ff    	jne    80106dd8 <trap+0xd8>
    yield();
80106eca:	e8 71 e1 ff ff       	call   80105040 <yield>
80106ecf:	e9 04 ff ff ff       	jmp    80106dd8 <trap+0xd8>
80106ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106ed8:	e8 c3 ce ff ff       	call   80103da0 <myproc>
80106edd:	8b 70 24             	mov    0x24(%eax),%esi
80106ee0:	85 f6                	test   %esi,%esi
80106ee2:	75 3c                	jne    80106f20 <trap+0x220>
    myproc()->tf = tf;
80106ee4:	e8 b7 ce ff ff       	call   80103da0 <myproc>
80106ee9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106eec:	e8 df ec ff ff       	call   80105bd0 <syscall>
    if(myproc()->killed)
80106ef1:	e8 aa ce ff ff       	call   80103da0 <myproc>
80106ef6:	8b 48 24             	mov    0x24(%eax),%ecx
80106ef9:	85 c9                	test   %ecx,%ecx
80106efb:	0f 84 fd fe ff ff    	je     80106dfe <trap+0xfe>
}
80106f01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f04:	5b                   	pop    %ebx
80106f05:	5e                   	pop    %esi
80106f06:	5f                   	pop    %edi
80106f07:	5d                   	pop    %ebp
      exit();
80106f08:	e9 f3 df ff ff       	jmp    80104f00 <exit>
80106f0d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106f10:	e8 eb df ff ff       	call   80104f00 <exit>
80106f15:	e9 a6 fe ff ff       	jmp    80106dc0 <trap+0xc0>
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106f20:	e8 db df ff ff       	call   80104f00 <exit>
80106f25:	eb bd                	jmp    80106ee4 <trap+0x1e4>
80106f27:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106f2a:	e8 21 ce ff ff       	call   80103d50 <cpuid>
80106f2f:	83 ec 0c             	sub    $0xc,%esp
80106f32:	56                   	push   %esi
80106f33:	57                   	push   %edi
80106f34:	50                   	push   %eax
80106f35:	ff 73 30             	pushl  0x30(%ebx)
80106f38:	68 88 8e 10 80       	push   $0x80108e88
80106f3d:	e8 6e 97 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106f42:	83 c4 14             	add    $0x14,%esp
80106f45:	68 5d 8e 10 80       	push   $0x80108e5d
80106f4a:	e8 41 94 ff ff       	call   80100390 <panic>
80106f4f:	90                   	nop

80106f50 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106f50:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106f54:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80106f59:	85 c0                	test   %eax,%eax
80106f5b:	74 1b                	je     80106f78 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f5d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106f62:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106f63:	a8 01                	test   $0x1,%al
80106f65:	74 11                	je     80106f78 <uartgetc+0x28>
80106f67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106f6c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106f6d:	0f b6 c0             	movzbl %al,%eax
80106f70:	c3                   	ret    
80106f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f7d:	c3                   	ret    
80106f7e:	66 90                	xchg   %ax,%ax

80106f80 <uartputc.part.0>:
uartputc(int c)
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	89 c7                	mov    %eax,%edi
80106f86:	56                   	push   %esi
80106f87:	be fd 03 00 00       	mov    $0x3fd,%esi
80106f8c:	53                   	push   %ebx
80106f8d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106f92:	83 ec 0c             	sub    $0xc,%esp
80106f95:	eb 1b                	jmp    80106fb2 <uartputc.part.0+0x32>
80106f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f9e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106fa0:	83 ec 0c             	sub    $0xc,%esp
80106fa3:	6a 0a                	push   $0xa
80106fa5:	e8 a6 bc ff ff       	call   80102c50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106faa:	83 c4 10             	add    $0x10,%esp
80106fad:	83 eb 01             	sub    $0x1,%ebx
80106fb0:	74 07                	je     80106fb9 <uartputc.part.0+0x39>
80106fb2:	89 f2                	mov    %esi,%edx
80106fb4:	ec                   	in     (%dx),%al
80106fb5:	a8 20                	test   $0x20,%al
80106fb7:	74 e7                	je     80106fa0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106fb9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106fbe:	89 f8                	mov    %edi,%eax
80106fc0:	ee                   	out    %al,(%dx)
}
80106fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fc4:	5b                   	pop    %ebx
80106fc5:	5e                   	pop    %esi
80106fc6:	5f                   	pop    %edi
80106fc7:	5d                   	pop    %ebp
80106fc8:	c3                   	ret    
80106fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fd0 <uartinit>:
{
80106fd0:	f3 0f 1e fb          	endbr32 
80106fd4:	55                   	push   %ebp
80106fd5:	31 c9                	xor    %ecx,%ecx
80106fd7:	89 c8                	mov    %ecx,%eax
80106fd9:	89 e5                	mov    %esp,%ebp
80106fdb:	57                   	push   %edi
80106fdc:	56                   	push   %esi
80106fdd:	53                   	push   %ebx
80106fde:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106fe3:	89 da                	mov    %ebx,%edx
80106fe5:	83 ec 0c             	sub    $0xc,%esp
80106fe8:	ee                   	out    %al,(%dx)
80106fe9:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106fee:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106ff3:	89 fa                	mov    %edi,%edx
80106ff5:	ee                   	out    %al,(%dx)
80106ff6:	b8 0c 00 00 00       	mov    $0xc,%eax
80106ffb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107000:	ee                   	out    %al,(%dx)
80107001:	be f9 03 00 00       	mov    $0x3f9,%esi
80107006:	89 c8                	mov    %ecx,%eax
80107008:	89 f2                	mov    %esi,%edx
8010700a:	ee                   	out    %al,(%dx)
8010700b:	b8 03 00 00 00       	mov    $0x3,%eax
80107010:	89 fa                	mov    %edi,%edx
80107012:	ee                   	out    %al,(%dx)
80107013:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107018:	89 c8                	mov    %ecx,%eax
8010701a:	ee                   	out    %al,(%dx)
8010701b:	b8 01 00 00 00       	mov    $0x1,%eax
80107020:	89 f2                	mov    %esi,%edx
80107022:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107023:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107028:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107029:	3c ff                	cmp    $0xff,%al
8010702b:	74 52                	je     8010707f <uartinit+0xaf>
  uart = 1;
8010702d:	c7 05 3c c6 10 80 01 	movl   $0x1,0x8010c63c
80107034:	00 00 00 
80107037:	89 da                	mov    %ebx,%edx
80107039:	ec                   	in     (%dx),%al
8010703a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010703f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80107040:	83 ec 08             	sub    $0x8,%esp
80107043:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80107048:	bb 80 8f 10 80       	mov    $0x80108f80,%ebx
  ioapicenable(IRQ_COM1, 0);
8010704d:	6a 00                	push   $0x0
8010704f:	6a 04                	push   $0x4
80107051:	e8 4a b7 ff ff       	call   801027a0 <ioapicenable>
80107056:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107059:	b8 78 00 00 00       	mov    $0x78,%eax
8010705e:	eb 04                	jmp    80107064 <uartinit+0x94>
80107060:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80107064:	8b 15 3c c6 10 80    	mov    0x8010c63c,%edx
8010706a:	85 d2                	test   %edx,%edx
8010706c:	74 08                	je     80107076 <uartinit+0xa6>
    uartputc(*p);
8010706e:	0f be c0             	movsbl %al,%eax
80107071:	e8 0a ff ff ff       	call   80106f80 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80107076:	89 f0                	mov    %esi,%eax
80107078:	83 c3 01             	add    $0x1,%ebx
8010707b:	84 c0                	test   %al,%al
8010707d:	75 e1                	jne    80107060 <uartinit+0x90>
}
8010707f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107082:	5b                   	pop    %ebx
80107083:	5e                   	pop    %esi
80107084:	5f                   	pop    %edi
80107085:	5d                   	pop    %ebp
80107086:	c3                   	ret    
80107087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010708e:	66 90                	xchg   %ax,%ax

80107090 <uartputc>:
{
80107090:	f3 0f 1e fb          	endbr32 
80107094:	55                   	push   %ebp
  if(!uart)
80107095:	8b 15 3c c6 10 80    	mov    0x8010c63c,%edx
{
8010709b:	89 e5                	mov    %esp,%ebp
8010709d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801070a0:	85 d2                	test   %edx,%edx
801070a2:	74 0c                	je     801070b0 <uartputc+0x20>
}
801070a4:	5d                   	pop    %ebp
801070a5:	e9 d6 fe ff ff       	jmp    80106f80 <uartputc.part.0>
801070aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070b0:	5d                   	pop    %ebp
801070b1:	c3                   	ret    
801070b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070c0 <uartintr>:

void
uartintr(void)
{
801070c0:	f3 0f 1e fb          	endbr32 
801070c4:	55                   	push   %ebp
801070c5:	89 e5                	mov    %esp,%ebp
801070c7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801070ca:	68 50 6f 10 80       	push   $0x80106f50
801070cf:	e8 6c 9a ff ff       	call   80100b40 <consoleintr>
}
801070d4:	83 c4 10             	add    $0x10,%esp
801070d7:	c9                   	leave  
801070d8:	c3                   	ret    

801070d9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801070d9:	6a 00                	push   $0x0
  pushl $0
801070db:	6a 00                	push   $0x0
  jmp alltraps
801070dd:	e9 42 fb ff ff       	jmp    80106c24 <alltraps>

801070e2 <vector1>:
.globl vector1
vector1:
  pushl $0
801070e2:	6a 00                	push   $0x0
  pushl $1
801070e4:	6a 01                	push   $0x1
  jmp alltraps
801070e6:	e9 39 fb ff ff       	jmp    80106c24 <alltraps>

801070eb <vector2>:
.globl vector2
vector2:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $2
801070ed:	6a 02                	push   $0x2
  jmp alltraps
801070ef:	e9 30 fb ff ff       	jmp    80106c24 <alltraps>

801070f4 <vector3>:
.globl vector3
vector3:
  pushl $0
801070f4:	6a 00                	push   $0x0
  pushl $3
801070f6:	6a 03                	push   $0x3
  jmp alltraps
801070f8:	e9 27 fb ff ff       	jmp    80106c24 <alltraps>

801070fd <vector4>:
.globl vector4
vector4:
  pushl $0
801070fd:	6a 00                	push   $0x0
  pushl $4
801070ff:	6a 04                	push   $0x4
  jmp alltraps
80107101:	e9 1e fb ff ff       	jmp    80106c24 <alltraps>

80107106 <vector5>:
.globl vector5
vector5:
  pushl $0
80107106:	6a 00                	push   $0x0
  pushl $5
80107108:	6a 05                	push   $0x5
  jmp alltraps
8010710a:	e9 15 fb ff ff       	jmp    80106c24 <alltraps>

8010710f <vector6>:
.globl vector6
vector6:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $6
80107111:	6a 06                	push   $0x6
  jmp alltraps
80107113:	e9 0c fb ff ff       	jmp    80106c24 <alltraps>

80107118 <vector7>:
.globl vector7
vector7:
  pushl $0
80107118:	6a 00                	push   $0x0
  pushl $7
8010711a:	6a 07                	push   $0x7
  jmp alltraps
8010711c:	e9 03 fb ff ff       	jmp    80106c24 <alltraps>

80107121 <vector8>:
.globl vector8
vector8:
  pushl $8
80107121:	6a 08                	push   $0x8
  jmp alltraps
80107123:	e9 fc fa ff ff       	jmp    80106c24 <alltraps>

80107128 <vector9>:
.globl vector9
vector9:
  pushl $0
80107128:	6a 00                	push   $0x0
  pushl $9
8010712a:	6a 09                	push   $0x9
  jmp alltraps
8010712c:	e9 f3 fa ff ff       	jmp    80106c24 <alltraps>

80107131 <vector10>:
.globl vector10
vector10:
  pushl $10
80107131:	6a 0a                	push   $0xa
  jmp alltraps
80107133:	e9 ec fa ff ff       	jmp    80106c24 <alltraps>

80107138 <vector11>:
.globl vector11
vector11:
  pushl $11
80107138:	6a 0b                	push   $0xb
  jmp alltraps
8010713a:	e9 e5 fa ff ff       	jmp    80106c24 <alltraps>

8010713f <vector12>:
.globl vector12
vector12:
  pushl $12
8010713f:	6a 0c                	push   $0xc
  jmp alltraps
80107141:	e9 de fa ff ff       	jmp    80106c24 <alltraps>

80107146 <vector13>:
.globl vector13
vector13:
  pushl $13
80107146:	6a 0d                	push   $0xd
  jmp alltraps
80107148:	e9 d7 fa ff ff       	jmp    80106c24 <alltraps>

8010714d <vector14>:
.globl vector14
vector14:
  pushl $14
8010714d:	6a 0e                	push   $0xe
  jmp alltraps
8010714f:	e9 d0 fa ff ff       	jmp    80106c24 <alltraps>

80107154 <vector15>:
.globl vector15
vector15:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $15
80107156:	6a 0f                	push   $0xf
  jmp alltraps
80107158:	e9 c7 fa ff ff       	jmp    80106c24 <alltraps>

8010715d <vector16>:
.globl vector16
vector16:
  pushl $0
8010715d:	6a 00                	push   $0x0
  pushl $16
8010715f:	6a 10                	push   $0x10
  jmp alltraps
80107161:	e9 be fa ff ff       	jmp    80106c24 <alltraps>

80107166 <vector17>:
.globl vector17
vector17:
  pushl $17
80107166:	6a 11                	push   $0x11
  jmp alltraps
80107168:	e9 b7 fa ff ff       	jmp    80106c24 <alltraps>

8010716d <vector18>:
.globl vector18
vector18:
  pushl $0
8010716d:	6a 00                	push   $0x0
  pushl $18
8010716f:	6a 12                	push   $0x12
  jmp alltraps
80107171:	e9 ae fa ff ff       	jmp    80106c24 <alltraps>

80107176 <vector19>:
.globl vector19
vector19:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $19
80107178:	6a 13                	push   $0x13
  jmp alltraps
8010717a:	e9 a5 fa ff ff       	jmp    80106c24 <alltraps>

8010717f <vector20>:
.globl vector20
vector20:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $20
80107181:	6a 14                	push   $0x14
  jmp alltraps
80107183:	e9 9c fa ff ff       	jmp    80106c24 <alltraps>

80107188 <vector21>:
.globl vector21
vector21:
  pushl $0
80107188:	6a 00                	push   $0x0
  pushl $21
8010718a:	6a 15                	push   $0x15
  jmp alltraps
8010718c:	e9 93 fa ff ff       	jmp    80106c24 <alltraps>

80107191 <vector22>:
.globl vector22
vector22:
  pushl $0
80107191:	6a 00                	push   $0x0
  pushl $22
80107193:	6a 16                	push   $0x16
  jmp alltraps
80107195:	e9 8a fa ff ff       	jmp    80106c24 <alltraps>

8010719a <vector23>:
.globl vector23
vector23:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $23
8010719c:	6a 17                	push   $0x17
  jmp alltraps
8010719e:	e9 81 fa ff ff       	jmp    80106c24 <alltraps>

801071a3 <vector24>:
.globl vector24
vector24:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $24
801071a5:	6a 18                	push   $0x18
  jmp alltraps
801071a7:	e9 78 fa ff ff       	jmp    80106c24 <alltraps>

801071ac <vector25>:
.globl vector25
vector25:
  pushl $0
801071ac:	6a 00                	push   $0x0
  pushl $25
801071ae:	6a 19                	push   $0x19
  jmp alltraps
801071b0:	e9 6f fa ff ff       	jmp    80106c24 <alltraps>

801071b5 <vector26>:
.globl vector26
vector26:
  pushl $0
801071b5:	6a 00                	push   $0x0
  pushl $26
801071b7:	6a 1a                	push   $0x1a
  jmp alltraps
801071b9:	e9 66 fa ff ff       	jmp    80106c24 <alltraps>

801071be <vector27>:
.globl vector27
vector27:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $27
801071c0:	6a 1b                	push   $0x1b
  jmp alltraps
801071c2:	e9 5d fa ff ff       	jmp    80106c24 <alltraps>

801071c7 <vector28>:
.globl vector28
vector28:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $28
801071c9:	6a 1c                	push   $0x1c
  jmp alltraps
801071cb:	e9 54 fa ff ff       	jmp    80106c24 <alltraps>

801071d0 <vector29>:
.globl vector29
vector29:
  pushl $0
801071d0:	6a 00                	push   $0x0
  pushl $29
801071d2:	6a 1d                	push   $0x1d
  jmp alltraps
801071d4:	e9 4b fa ff ff       	jmp    80106c24 <alltraps>

801071d9 <vector30>:
.globl vector30
vector30:
  pushl $0
801071d9:	6a 00                	push   $0x0
  pushl $30
801071db:	6a 1e                	push   $0x1e
  jmp alltraps
801071dd:	e9 42 fa ff ff       	jmp    80106c24 <alltraps>

801071e2 <vector31>:
.globl vector31
vector31:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $31
801071e4:	6a 1f                	push   $0x1f
  jmp alltraps
801071e6:	e9 39 fa ff ff       	jmp    80106c24 <alltraps>

801071eb <vector32>:
.globl vector32
vector32:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $32
801071ed:	6a 20                	push   $0x20
  jmp alltraps
801071ef:	e9 30 fa ff ff       	jmp    80106c24 <alltraps>

801071f4 <vector33>:
.globl vector33
vector33:
  pushl $0
801071f4:	6a 00                	push   $0x0
  pushl $33
801071f6:	6a 21                	push   $0x21
  jmp alltraps
801071f8:	e9 27 fa ff ff       	jmp    80106c24 <alltraps>

801071fd <vector34>:
.globl vector34
vector34:
  pushl $0
801071fd:	6a 00                	push   $0x0
  pushl $34
801071ff:	6a 22                	push   $0x22
  jmp alltraps
80107201:	e9 1e fa ff ff       	jmp    80106c24 <alltraps>

80107206 <vector35>:
.globl vector35
vector35:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $35
80107208:	6a 23                	push   $0x23
  jmp alltraps
8010720a:	e9 15 fa ff ff       	jmp    80106c24 <alltraps>

8010720f <vector36>:
.globl vector36
vector36:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $36
80107211:	6a 24                	push   $0x24
  jmp alltraps
80107213:	e9 0c fa ff ff       	jmp    80106c24 <alltraps>

80107218 <vector37>:
.globl vector37
vector37:
  pushl $0
80107218:	6a 00                	push   $0x0
  pushl $37
8010721a:	6a 25                	push   $0x25
  jmp alltraps
8010721c:	e9 03 fa ff ff       	jmp    80106c24 <alltraps>

80107221 <vector38>:
.globl vector38
vector38:
  pushl $0
80107221:	6a 00                	push   $0x0
  pushl $38
80107223:	6a 26                	push   $0x26
  jmp alltraps
80107225:	e9 fa f9 ff ff       	jmp    80106c24 <alltraps>

8010722a <vector39>:
.globl vector39
vector39:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $39
8010722c:	6a 27                	push   $0x27
  jmp alltraps
8010722e:	e9 f1 f9 ff ff       	jmp    80106c24 <alltraps>

80107233 <vector40>:
.globl vector40
vector40:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $40
80107235:	6a 28                	push   $0x28
  jmp alltraps
80107237:	e9 e8 f9 ff ff       	jmp    80106c24 <alltraps>

8010723c <vector41>:
.globl vector41
vector41:
  pushl $0
8010723c:	6a 00                	push   $0x0
  pushl $41
8010723e:	6a 29                	push   $0x29
  jmp alltraps
80107240:	e9 df f9 ff ff       	jmp    80106c24 <alltraps>

80107245 <vector42>:
.globl vector42
vector42:
  pushl $0
80107245:	6a 00                	push   $0x0
  pushl $42
80107247:	6a 2a                	push   $0x2a
  jmp alltraps
80107249:	e9 d6 f9 ff ff       	jmp    80106c24 <alltraps>

8010724e <vector43>:
.globl vector43
vector43:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $43
80107250:	6a 2b                	push   $0x2b
  jmp alltraps
80107252:	e9 cd f9 ff ff       	jmp    80106c24 <alltraps>

80107257 <vector44>:
.globl vector44
vector44:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $44
80107259:	6a 2c                	push   $0x2c
  jmp alltraps
8010725b:	e9 c4 f9 ff ff       	jmp    80106c24 <alltraps>

80107260 <vector45>:
.globl vector45
vector45:
  pushl $0
80107260:	6a 00                	push   $0x0
  pushl $45
80107262:	6a 2d                	push   $0x2d
  jmp alltraps
80107264:	e9 bb f9 ff ff       	jmp    80106c24 <alltraps>

80107269 <vector46>:
.globl vector46
vector46:
  pushl $0
80107269:	6a 00                	push   $0x0
  pushl $46
8010726b:	6a 2e                	push   $0x2e
  jmp alltraps
8010726d:	e9 b2 f9 ff ff       	jmp    80106c24 <alltraps>

80107272 <vector47>:
.globl vector47
vector47:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $47
80107274:	6a 2f                	push   $0x2f
  jmp alltraps
80107276:	e9 a9 f9 ff ff       	jmp    80106c24 <alltraps>

8010727b <vector48>:
.globl vector48
vector48:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $48
8010727d:	6a 30                	push   $0x30
  jmp alltraps
8010727f:	e9 a0 f9 ff ff       	jmp    80106c24 <alltraps>

80107284 <vector49>:
.globl vector49
vector49:
  pushl $0
80107284:	6a 00                	push   $0x0
  pushl $49
80107286:	6a 31                	push   $0x31
  jmp alltraps
80107288:	e9 97 f9 ff ff       	jmp    80106c24 <alltraps>

8010728d <vector50>:
.globl vector50
vector50:
  pushl $0
8010728d:	6a 00                	push   $0x0
  pushl $50
8010728f:	6a 32                	push   $0x32
  jmp alltraps
80107291:	e9 8e f9 ff ff       	jmp    80106c24 <alltraps>

80107296 <vector51>:
.globl vector51
vector51:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $51
80107298:	6a 33                	push   $0x33
  jmp alltraps
8010729a:	e9 85 f9 ff ff       	jmp    80106c24 <alltraps>

8010729f <vector52>:
.globl vector52
vector52:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $52
801072a1:	6a 34                	push   $0x34
  jmp alltraps
801072a3:	e9 7c f9 ff ff       	jmp    80106c24 <alltraps>

801072a8 <vector53>:
.globl vector53
vector53:
  pushl $0
801072a8:	6a 00                	push   $0x0
  pushl $53
801072aa:	6a 35                	push   $0x35
  jmp alltraps
801072ac:	e9 73 f9 ff ff       	jmp    80106c24 <alltraps>

801072b1 <vector54>:
.globl vector54
vector54:
  pushl $0
801072b1:	6a 00                	push   $0x0
  pushl $54
801072b3:	6a 36                	push   $0x36
  jmp alltraps
801072b5:	e9 6a f9 ff ff       	jmp    80106c24 <alltraps>

801072ba <vector55>:
.globl vector55
vector55:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $55
801072bc:	6a 37                	push   $0x37
  jmp alltraps
801072be:	e9 61 f9 ff ff       	jmp    80106c24 <alltraps>

801072c3 <vector56>:
.globl vector56
vector56:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $56
801072c5:	6a 38                	push   $0x38
  jmp alltraps
801072c7:	e9 58 f9 ff ff       	jmp    80106c24 <alltraps>

801072cc <vector57>:
.globl vector57
vector57:
  pushl $0
801072cc:	6a 00                	push   $0x0
  pushl $57
801072ce:	6a 39                	push   $0x39
  jmp alltraps
801072d0:	e9 4f f9 ff ff       	jmp    80106c24 <alltraps>

801072d5 <vector58>:
.globl vector58
vector58:
  pushl $0
801072d5:	6a 00                	push   $0x0
  pushl $58
801072d7:	6a 3a                	push   $0x3a
  jmp alltraps
801072d9:	e9 46 f9 ff ff       	jmp    80106c24 <alltraps>

801072de <vector59>:
.globl vector59
vector59:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $59
801072e0:	6a 3b                	push   $0x3b
  jmp alltraps
801072e2:	e9 3d f9 ff ff       	jmp    80106c24 <alltraps>

801072e7 <vector60>:
.globl vector60
vector60:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $60
801072e9:	6a 3c                	push   $0x3c
  jmp alltraps
801072eb:	e9 34 f9 ff ff       	jmp    80106c24 <alltraps>

801072f0 <vector61>:
.globl vector61
vector61:
  pushl $0
801072f0:	6a 00                	push   $0x0
  pushl $61
801072f2:	6a 3d                	push   $0x3d
  jmp alltraps
801072f4:	e9 2b f9 ff ff       	jmp    80106c24 <alltraps>

801072f9 <vector62>:
.globl vector62
vector62:
  pushl $0
801072f9:	6a 00                	push   $0x0
  pushl $62
801072fb:	6a 3e                	push   $0x3e
  jmp alltraps
801072fd:	e9 22 f9 ff ff       	jmp    80106c24 <alltraps>

80107302 <vector63>:
.globl vector63
vector63:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $63
80107304:	6a 3f                	push   $0x3f
  jmp alltraps
80107306:	e9 19 f9 ff ff       	jmp    80106c24 <alltraps>

8010730b <vector64>:
.globl vector64
vector64:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $64
8010730d:	6a 40                	push   $0x40
  jmp alltraps
8010730f:	e9 10 f9 ff ff       	jmp    80106c24 <alltraps>

80107314 <vector65>:
.globl vector65
vector65:
  pushl $0
80107314:	6a 00                	push   $0x0
  pushl $65
80107316:	6a 41                	push   $0x41
  jmp alltraps
80107318:	e9 07 f9 ff ff       	jmp    80106c24 <alltraps>

8010731d <vector66>:
.globl vector66
vector66:
  pushl $0
8010731d:	6a 00                	push   $0x0
  pushl $66
8010731f:	6a 42                	push   $0x42
  jmp alltraps
80107321:	e9 fe f8 ff ff       	jmp    80106c24 <alltraps>

80107326 <vector67>:
.globl vector67
vector67:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $67
80107328:	6a 43                	push   $0x43
  jmp alltraps
8010732a:	e9 f5 f8 ff ff       	jmp    80106c24 <alltraps>

8010732f <vector68>:
.globl vector68
vector68:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $68
80107331:	6a 44                	push   $0x44
  jmp alltraps
80107333:	e9 ec f8 ff ff       	jmp    80106c24 <alltraps>

80107338 <vector69>:
.globl vector69
vector69:
  pushl $0
80107338:	6a 00                	push   $0x0
  pushl $69
8010733a:	6a 45                	push   $0x45
  jmp alltraps
8010733c:	e9 e3 f8 ff ff       	jmp    80106c24 <alltraps>

80107341 <vector70>:
.globl vector70
vector70:
  pushl $0
80107341:	6a 00                	push   $0x0
  pushl $70
80107343:	6a 46                	push   $0x46
  jmp alltraps
80107345:	e9 da f8 ff ff       	jmp    80106c24 <alltraps>

8010734a <vector71>:
.globl vector71
vector71:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $71
8010734c:	6a 47                	push   $0x47
  jmp alltraps
8010734e:	e9 d1 f8 ff ff       	jmp    80106c24 <alltraps>

80107353 <vector72>:
.globl vector72
vector72:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $72
80107355:	6a 48                	push   $0x48
  jmp alltraps
80107357:	e9 c8 f8 ff ff       	jmp    80106c24 <alltraps>

8010735c <vector73>:
.globl vector73
vector73:
  pushl $0
8010735c:	6a 00                	push   $0x0
  pushl $73
8010735e:	6a 49                	push   $0x49
  jmp alltraps
80107360:	e9 bf f8 ff ff       	jmp    80106c24 <alltraps>

80107365 <vector74>:
.globl vector74
vector74:
  pushl $0
80107365:	6a 00                	push   $0x0
  pushl $74
80107367:	6a 4a                	push   $0x4a
  jmp alltraps
80107369:	e9 b6 f8 ff ff       	jmp    80106c24 <alltraps>

8010736e <vector75>:
.globl vector75
vector75:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $75
80107370:	6a 4b                	push   $0x4b
  jmp alltraps
80107372:	e9 ad f8 ff ff       	jmp    80106c24 <alltraps>

80107377 <vector76>:
.globl vector76
vector76:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $76
80107379:	6a 4c                	push   $0x4c
  jmp alltraps
8010737b:	e9 a4 f8 ff ff       	jmp    80106c24 <alltraps>

80107380 <vector77>:
.globl vector77
vector77:
  pushl $0
80107380:	6a 00                	push   $0x0
  pushl $77
80107382:	6a 4d                	push   $0x4d
  jmp alltraps
80107384:	e9 9b f8 ff ff       	jmp    80106c24 <alltraps>

80107389 <vector78>:
.globl vector78
vector78:
  pushl $0
80107389:	6a 00                	push   $0x0
  pushl $78
8010738b:	6a 4e                	push   $0x4e
  jmp alltraps
8010738d:	e9 92 f8 ff ff       	jmp    80106c24 <alltraps>

80107392 <vector79>:
.globl vector79
vector79:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $79
80107394:	6a 4f                	push   $0x4f
  jmp alltraps
80107396:	e9 89 f8 ff ff       	jmp    80106c24 <alltraps>

8010739b <vector80>:
.globl vector80
vector80:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $80
8010739d:	6a 50                	push   $0x50
  jmp alltraps
8010739f:	e9 80 f8 ff ff       	jmp    80106c24 <alltraps>

801073a4 <vector81>:
.globl vector81
vector81:
  pushl $0
801073a4:	6a 00                	push   $0x0
  pushl $81
801073a6:	6a 51                	push   $0x51
  jmp alltraps
801073a8:	e9 77 f8 ff ff       	jmp    80106c24 <alltraps>

801073ad <vector82>:
.globl vector82
vector82:
  pushl $0
801073ad:	6a 00                	push   $0x0
  pushl $82
801073af:	6a 52                	push   $0x52
  jmp alltraps
801073b1:	e9 6e f8 ff ff       	jmp    80106c24 <alltraps>

801073b6 <vector83>:
.globl vector83
vector83:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $83
801073b8:	6a 53                	push   $0x53
  jmp alltraps
801073ba:	e9 65 f8 ff ff       	jmp    80106c24 <alltraps>

801073bf <vector84>:
.globl vector84
vector84:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $84
801073c1:	6a 54                	push   $0x54
  jmp alltraps
801073c3:	e9 5c f8 ff ff       	jmp    80106c24 <alltraps>

801073c8 <vector85>:
.globl vector85
vector85:
  pushl $0
801073c8:	6a 00                	push   $0x0
  pushl $85
801073ca:	6a 55                	push   $0x55
  jmp alltraps
801073cc:	e9 53 f8 ff ff       	jmp    80106c24 <alltraps>

801073d1 <vector86>:
.globl vector86
vector86:
  pushl $0
801073d1:	6a 00                	push   $0x0
  pushl $86
801073d3:	6a 56                	push   $0x56
  jmp alltraps
801073d5:	e9 4a f8 ff ff       	jmp    80106c24 <alltraps>

801073da <vector87>:
.globl vector87
vector87:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $87
801073dc:	6a 57                	push   $0x57
  jmp alltraps
801073de:	e9 41 f8 ff ff       	jmp    80106c24 <alltraps>

801073e3 <vector88>:
.globl vector88
vector88:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $88
801073e5:	6a 58                	push   $0x58
  jmp alltraps
801073e7:	e9 38 f8 ff ff       	jmp    80106c24 <alltraps>

801073ec <vector89>:
.globl vector89
vector89:
  pushl $0
801073ec:	6a 00                	push   $0x0
  pushl $89
801073ee:	6a 59                	push   $0x59
  jmp alltraps
801073f0:	e9 2f f8 ff ff       	jmp    80106c24 <alltraps>

801073f5 <vector90>:
.globl vector90
vector90:
  pushl $0
801073f5:	6a 00                	push   $0x0
  pushl $90
801073f7:	6a 5a                	push   $0x5a
  jmp alltraps
801073f9:	e9 26 f8 ff ff       	jmp    80106c24 <alltraps>

801073fe <vector91>:
.globl vector91
vector91:
  pushl $0
801073fe:	6a 00                	push   $0x0
  pushl $91
80107400:	6a 5b                	push   $0x5b
  jmp alltraps
80107402:	e9 1d f8 ff ff       	jmp    80106c24 <alltraps>

80107407 <vector92>:
.globl vector92
vector92:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $92
80107409:	6a 5c                	push   $0x5c
  jmp alltraps
8010740b:	e9 14 f8 ff ff       	jmp    80106c24 <alltraps>

80107410 <vector93>:
.globl vector93
vector93:
  pushl $0
80107410:	6a 00                	push   $0x0
  pushl $93
80107412:	6a 5d                	push   $0x5d
  jmp alltraps
80107414:	e9 0b f8 ff ff       	jmp    80106c24 <alltraps>

80107419 <vector94>:
.globl vector94
vector94:
  pushl $0
80107419:	6a 00                	push   $0x0
  pushl $94
8010741b:	6a 5e                	push   $0x5e
  jmp alltraps
8010741d:	e9 02 f8 ff ff       	jmp    80106c24 <alltraps>

80107422 <vector95>:
.globl vector95
vector95:
  pushl $0
80107422:	6a 00                	push   $0x0
  pushl $95
80107424:	6a 5f                	push   $0x5f
  jmp alltraps
80107426:	e9 f9 f7 ff ff       	jmp    80106c24 <alltraps>

8010742b <vector96>:
.globl vector96
vector96:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $96
8010742d:	6a 60                	push   $0x60
  jmp alltraps
8010742f:	e9 f0 f7 ff ff       	jmp    80106c24 <alltraps>

80107434 <vector97>:
.globl vector97
vector97:
  pushl $0
80107434:	6a 00                	push   $0x0
  pushl $97
80107436:	6a 61                	push   $0x61
  jmp alltraps
80107438:	e9 e7 f7 ff ff       	jmp    80106c24 <alltraps>

8010743d <vector98>:
.globl vector98
vector98:
  pushl $0
8010743d:	6a 00                	push   $0x0
  pushl $98
8010743f:	6a 62                	push   $0x62
  jmp alltraps
80107441:	e9 de f7 ff ff       	jmp    80106c24 <alltraps>

80107446 <vector99>:
.globl vector99
vector99:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $99
80107448:	6a 63                	push   $0x63
  jmp alltraps
8010744a:	e9 d5 f7 ff ff       	jmp    80106c24 <alltraps>

8010744f <vector100>:
.globl vector100
vector100:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $100
80107451:	6a 64                	push   $0x64
  jmp alltraps
80107453:	e9 cc f7 ff ff       	jmp    80106c24 <alltraps>

80107458 <vector101>:
.globl vector101
vector101:
  pushl $0
80107458:	6a 00                	push   $0x0
  pushl $101
8010745a:	6a 65                	push   $0x65
  jmp alltraps
8010745c:	e9 c3 f7 ff ff       	jmp    80106c24 <alltraps>

80107461 <vector102>:
.globl vector102
vector102:
  pushl $0
80107461:	6a 00                	push   $0x0
  pushl $102
80107463:	6a 66                	push   $0x66
  jmp alltraps
80107465:	e9 ba f7 ff ff       	jmp    80106c24 <alltraps>

8010746a <vector103>:
.globl vector103
vector103:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $103
8010746c:	6a 67                	push   $0x67
  jmp alltraps
8010746e:	e9 b1 f7 ff ff       	jmp    80106c24 <alltraps>

80107473 <vector104>:
.globl vector104
vector104:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $104
80107475:	6a 68                	push   $0x68
  jmp alltraps
80107477:	e9 a8 f7 ff ff       	jmp    80106c24 <alltraps>

8010747c <vector105>:
.globl vector105
vector105:
  pushl $0
8010747c:	6a 00                	push   $0x0
  pushl $105
8010747e:	6a 69                	push   $0x69
  jmp alltraps
80107480:	e9 9f f7 ff ff       	jmp    80106c24 <alltraps>

80107485 <vector106>:
.globl vector106
vector106:
  pushl $0
80107485:	6a 00                	push   $0x0
  pushl $106
80107487:	6a 6a                	push   $0x6a
  jmp alltraps
80107489:	e9 96 f7 ff ff       	jmp    80106c24 <alltraps>

8010748e <vector107>:
.globl vector107
vector107:
  pushl $0
8010748e:	6a 00                	push   $0x0
  pushl $107
80107490:	6a 6b                	push   $0x6b
  jmp alltraps
80107492:	e9 8d f7 ff ff       	jmp    80106c24 <alltraps>

80107497 <vector108>:
.globl vector108
vector108:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $108
80107499:	6a 6c                	push   $0x6c
  jmp alltraps
8010749b:	e9 84 f7 ff ff       	jmp    80106c24 <alltraps>

801074a0 <vector109>:
.globl vector109
vector109:
  pushl $0
801074a0:	6a 00                	push   $0x0
  pushl $109
801074a2:	6a 6d                	push   $0x6d
  jmp alltraps
801074a4:	e9 7b f7 ff ff       	jmp    80106c24 <alltraps>

801074a9 <vector110>:
.globl vector110
vector110:
  pushl $0
801074a9:	6a 00                	push   $0x0
  pushl $110
801074ab:	6a 6e                	push   $0x6e
  jmp alltraps
801074ad:	e9 72 f7 ff ff       	jmp    80106c24 <alltraps>

801074b2 <vector111>:
.globl vector111
vector111:
  pushl $0
801074b2:	6a 00                	push   $0x0
  pushl $111
801074b4:	6a 6f                	push   $0x6f
  jmp alltraps
801074b6:	e9 69 f7 ff ff       	jmp    80106c24 <alltraps>

801074bb <vector112>:
.globl vector112
vector112:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $112
801074bd:	6a 70                	push   $0x70
  jmp alltraps
801074bf:	e9 60 f7 ff ff       	jmp    80106c24 <alltraps>

801074c4 <vector113>:
.globl vector113
vector113:
  pushl $0
801074c4:	6a 00                	push   $0x0
  pushl $113
801074c6:	6a 71                	push   $0x71
  jmp alltraps
801074c8:	e9 57 f7 ff ff       	jmp    80106c24 <alltraps>

801074cd <vector114>:
.globl vector114
vector114:
  pushl $0
801074cd:	6a 00                	push   $0x0
  pushl $114
801074cf:	6a 72                	push   $0x72
  jmp alltraps
801074d1:	e9 4e f7 ff ff       	jmp    80106c24 <alltraps>

801074d6 <vector115>:
.globl vector115
vector115:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $115
801074d8:	6a 73                	push   $0x73
  jmp alltraps
801074da:	e9 45 f7 ff ff       	jmp    80106c24 <alltraps>

801074df <vector116>:
.globl vector116
vector116:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $116
801074e1:	6a 74                	push   $0x74
  jmp alltraps
801074e3:	e9 3c f7 ff ff       	jmp    80106c24 <alltraps>

801074e8 <vector117>:
.globl vector117
vector117:
  pushl $0
801074e8:	6a 00                	push   $0x0
  pushl $117
801074ea:	6a 75                	push   $0x75
  jmp alltraps
801074ec:	e9 33 f7 ff ff       	jmp    80106c24 <alltraps>

801074f1 <vector118>:
.globl vector118
vector118:
  pushl $0
801074f1:	6a 00                	push   $0x0
  pushl $118
801074f3:	6a 76                	push   $0x76
  jmp alltraps
801074f5:	e9 2a f7 ff ff       	jmp    80106c24 <alltraps>

801074fa <vector119>:
.globl vector119
vector119:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $119
801074fc:	6a 77                	push   $0x77
  jmp alltraps
801074fe:	e9 21 f7 ff ff       	jmp    80106c24 <alltraps>

80107503 <vector120>:
.globl vector120
vector120:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $120
80107505:	6a 78                	push   $0x78
  jmp alltraps
80107507:	e9 18 f7 ff ff       	jmp    80106c24 <alltraps>

8010750c <vector121>:
.globl vector121
vector121:
  pushl $0
8010750c:	6a 00                	push   $0x0
  pushl $121
8010750e:	6a 79                	push   $0x79
  jmp alltraps
80107510:	e9 0f f7 ff ff       	jmp    80106c24 <alltraps>

80107515 <vector122>:
.globl vector122
vector122:
  pushl $0
80107515:	6a 00                	push   $0x0
  pushl $122
80107517:	6a 7a                	push   $0x7a
  jmp alltraps
80107519:	e9 06 f7 ff ff       	jmp    80106c24 <alltraps>

8010751e <vector123>:
.globl vector123
vector123:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $123
80107520:	6a 7b                	push   $0x7b
  jmp alltraps
80107522:	e9 fd f6 ff ff       	jmp    80106c24 <alltraps>

80107527 <vector124>:
.globl vector124
vector124:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $124
80107529:	6a 7c                	push   $0x7c
  jmp alltraps
8010752b:	e9 f4 f6 ff ff       	jmp    80106c24 <alltraps>

80107530 <vector125>:
.globl vector125
vector125:
  pushl $0
80107530:	6a 00                	push   $0x0
  pushl $125
80107532:	6a 7d                	push   $0x7d
  jmp alltraps
80107534:	e9 eb f6 ff ff       	jmp    80106c24 <alltraps>

80107539 <vector126>:
.globl vector126
vector126:
  pushl $0
80107539:	6a 00                	push   $0x0
  pushl $126
8010753b:	6a 7e                	push   $0x7e
  jmp alltraps
8010753d:	e9 e2 f6 ff ff       	jmp    80106c24 <alltraps>

80107542 <vector127>:
.globl vector127
vector127:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $127
80107544:	6a 7f                	push   $0x7f
  jmp alltraps
80107546:	e9 d9 f6 ff ff       	jmp    80106c24 <alltraps>

8010754b <vector128>:
.globl vector128
vector128:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $128
8010754d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107552:	e9 cd f6 ff ff       	jmp    80106c24 <alltraps>

80107557 <vector129>:
.globl vector129
vector129:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $129
80107559:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010755e:	e9 c1 f6 ff ff       	jmp    80106c24 <alltraps>

80107563 <vector130>:
.globl vector130
vector130:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $130
80107565:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010756a:	e9 b5 f6 ff ff       	jmp    80106c24 <alltraps>

8010756f <vector131>:
.globl vector131
vector131:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $131
80107571:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107576:	e9 a9 f6 ff ff       	jmp    80106c24 <alltraps>

8010757b <vector132>:
.globl vector132
vector132:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $132
8010757d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107582:	e9 9d f6 ff ff       	jmp    80106c24 <alltraps>

80107587 <vector133>:
.globl vector133
vector133:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $133
80107589:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010758e:	e9 91 f6 ff ff       	jmp    80106c24 <alltraps>

80107593 <vector134>:
.globl vector134
vector134:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $134
80107595:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010759a:	e9 85 f6 ff ff       	jmp    80106c24 <alltraps>

8010759f <vector135>:
.globl vector135
vector135:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $135
801075a1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801075a6:	e9 79 f6 ff ff       	jmp    80106c24 <alltraps>

801075ab <vector136>:
.globl vector136
vector136:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $136
801075ad:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801075b2:	e9 6d f6 ff ff       	jmp    80106c24 <alltraps>

801075b7 <vector137>:
.globl vector137
vector137:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $137
801075b9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801075be:	e9 61 f6 ff ff       	jmp    80106c24 <alltraps>

801075c3 <vector138>:
.globl vector138
vector138:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $138
801075c5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801075ca:	e9 55 f6 ff ff       	jmp    80106c24 <alltraps>

801075cf <vector139>:
.globl vector139
vector139:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $139
801075d1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801075d6:	e9 49 f6 ff ff       	jmp    80106c24 <alltraps>

801075db <vector140>:
.globl vector140
vector140:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $140
801075dd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801075e2:	e9 3d f6 ff ff       	jmp    80106c24 <alltraps>

801075e7 <vector141>:
.globl vector141
vector141:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $141
801075e9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801075ee:	e9 31 f6 ff ff       	jmp    80106c24 <alltraps>

801075f3 <vector142>:
.globl vector142
vector142:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $142
801075f5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801075fa:	e9 25 f6 ff ff       	jmp    80106c24 <alltraps>

801075ff <vector143>:
.globl vector143
vector143:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $143
80107601:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107606:	e9 19 f6 ff ff       	jmp    80106c24 <alltraps>

8010760b <vector144>:
.globl vector144
vector144:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $144
8010760d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107612:	e9 0d f6 ff ff       	jmp    80106c24 <alltraps>

80107617 <vector145>:
.globl vector145
vector145:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $145
80107619:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010761e:	e9 01 f6 ff ff       	jmp    80106c24 <alltraps>

80107623 <vector146>:
.globl vector146
vector146:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $146
80107625:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010762a:	e9 f5 f5 ff ff       	jmp    80106c24 <alltraps>

8010762f <vector147>:
.globl vector147
vector147:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $147
80107631:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107636:	e9 e9 f5 ff ff       	jmp    80106c24 <alltraps>

8010763b <vector148>:
.globl vector148
vector148:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $148
8010763d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107642:	e9 dd f5 ff ff       	jmp    80106c24 <alltraps>

80107647 <vector149>:
.globl vector149
vector149:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $149
80107649:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010764e:	e9 d1 f5 ff ff       	jmp    80106c24 <alltraps>

80107653 <vector150>:
.globl vector150
vector150:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $150
80107655:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010765a:	e9 c5 f5 ff ff       	jmp    80106c24 <alltraps>

8010765f <vector151>:
.globl vector151
vector151:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $151
80107661:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107666:	e9 b9 f5 ff ff       	jmp    80106c24 <alltraps>

8010766b <vector152>:
.globl vector152
vector152:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $152
8010766d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107672:	e9 ad f5 ff ff       	jmp    80106c24 <alltraps>

80107677 <vector153>:
.globl vector153
vector153:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $153
80107679:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010767e:	e9 a1 f5 ff ff       	jmp    80106c24 <alltraps>

80107683 <vector154>:
.globl vector154
vector154:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $154
80107685:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010768a:	e9 95 f5 ff ff       	jmp    80106c24 <alltraps>

8010768f <vector155>:
.globl vector155
vector155:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $155
80107691:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107696:	e9 89 f5 ff ff       	jmp    80106c24 <alltraps>

8010769b <vector156>:
.globl vector156
vector156:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $156
8010769d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801076a2:	e9 7d f5 ff ff       	jmp    80106c24 <alltraps>

801076a7 <vector157>:
.globl vector157
vector157:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $157
801076a9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801076ae:	e9 71 f5 ff ff       	jmp    80106c24 <alltraps>

801076b3 <vector158>:
.globl vector158
vector158:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $158
801076b5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801076ba:	e9 65 f5 ff ff       	jmp    80106c24 <alltraps>

801076bf <vector159>:
.globl vector159
vector159:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $159
801076c1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801076c6:	e9 59 f5 ff ff       	jmp    80106c24 <alltraps>

801076cb <vector160>:
.globl vector160
vector160:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $160
801076cd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801076d2:	e9 4d f5 ff ff       	jmp    80106c24 <alltraps>

801076d7 <vector161>:
.globl vector161
vector161:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $161
801076d9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801076de:	e9 41 f5 ff ff       	jmp    80106c24 <alltraps>

801076e3 <vector162>:
.globl vector162
vector162:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $162
801076e5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801076ea:	e9 35 f5 ff ff       	jmp    80106c24 <alltraps>

801076ef <vector163>:
.globl vector163
vector163:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $163
801076f1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801076f6:	e9 29 f5 ff ff       	jmp    80106c24 <alltraps>

801076fb <vector164>:
.globl vector164
vector164:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $164
801076fd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107702:	e9 1d f5 ff ff       	jmp    80106c24 <alltraps>

80107707 <vector165>:
.globl vector165
vector165:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $165
80107709:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010770e:	e9 11 f5 ff ff       	jmp    80106c24 <alltraps>

80107713 <vector166>:
.globl vector166
vector166:
  pushl $0
80107713:	6a 00                	push   $0x0
  pushl $166
80107715:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010771a:	e9 05 f5 ff ff       	jmp    80106c24 <alltraps>

8010771f <vector167>:
.globl vector167
vector167:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $167
80107721:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107726:	e9 f9 f4 ff ff       	jmp    80106c24 <alltraps>

8010772b <vector168>:
.globl vector168
vector168:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $168
8010772d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107732:	e9 ed f4 ff ff       	jmp    80106c24 <alltraps>

80107737 <vector169>:
.globl vector169
vector169:
  pushl $0
80107737:	6a 00                	push   $0x0
  pushl $169
80107739:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010773e:	e9 e1 f4 ff ff       	jmp    80106c24 <alltraps>

80107743 <vector170>:
.globl vector170
vector170:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $170
80107745:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010774a:	e9 d5 f4 ff ff       	jmp    80106c24 <alltraps>

8010774f <vector171>:
.globl vector171
vector171:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $171
80107751:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107756:	e9 c9 f4 ff ff       	jmp    80106c24 <alltraps>

8010775b <vector172>:
.globl vector172
vector172:
  pushl $0
8010775b:	6a 00                	push   $0x0
  pushl $172
8010775d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107762:	e9 bd f4 ff ff       	jmp    80106c24 <alltraps>

80107767 <vector173>:
.globl vector173
vector173:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $173
80107769:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010776e:	e9 b1 f4 ff ff       	jmp    80106c24 <alltraps>

80107773 <vector174>:
.globl vector174
vector174:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $174
80107775:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010777a:	e9 a5 f4 ff ff       	jmp    80106c24 <alltraps>

8010777f <vector175>:
.globl vector175
vector175:
  pushl $0
8010777f:	6a 00                	push   $0x0
  pushl $175
80107781:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107786:	e9 99 f4 ff ff       	jmp    80106c24 <alltraps>

8010778b <vector176>:
.globl vector176
vector176:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $176
8010778d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107792:	e9 8d f4 ff ff       	jmp    80106c24 <alltraps>

80107797 <vector177>:
.globl vector177
vector177:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $177
80107799:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010779e:	e9 81 f4 ff ff       	jmp    80106c24 <alltraps>

801077a3 <vector178>:
.globl vector178
vector178:
  pushl $0
801077a3:	6a 00                	push   $0x0
  pushl $178
801077a5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801077aa:	e9 75 f4 ff ff       	jmp    80106c24 <alltraps>

801077af <vector179>:
.globl vector179
vector179:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $179
801077b1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801077b6:	e9 69 f4 ff ff       	jmp    80106c24 <alltraps>

801077bb <vector180>:
.globl vector180
vector180:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $180
801077bd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801077c2:	e9 5d f4 ff ff       	jmp    80106c24 <alltraps>

801077c7 <vector181>:
.globl vector181
vector181:
  pushl $0
801077c7:	6a 00                	push   $0x0
  pushl $181
801077c9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801077ce:	e9 51 f4 ff ff       	jmp    80106c24 <alltraps>

801077d3 <vector182>:
.globl vector182
vector182:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $182
801077d5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801077da:	e9 45 f4 ff ff       	jmp    80106c24 <alltraps>

801077df <vector183>:
.globl vector183
vector183:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $183
801077e1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801077e6:	e9 39 f4 ff ff       	jmp    80106c24 <alltraps>

801077eb <vector184>:
.globl vector184
vector184:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $184
801077ed:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801077f2:	e9 2d f4 ff ff       	jmp    80106c24 <alltraps>

801077f7 <vector185>:
.globl vector185
vector185:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $185
801077f9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801077fe:	e9 21 f4 ff ff       	jmp    80106c24 <alltraps>

80107803 <vector186>:
.globl vector186
vector186:
  pushl $0
80107803:	6a 00                	push   $0x0
  pushl $186
80107805:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010780a:	e9 15 f4 ff ff       	jmp    80106c24 <alltraps>

8010780f <vector187>:
.globl vector187
vector187:
  pushl $0
8010780f:	6a 00                	push   $0x0
  pushl $187
80107811:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107816:	e9 09 f4 ff ff       	jmp    80106c24 <alltraps>

8010781b <vector188>:
.globl vector188
vector188:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $188
8010781d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107822:	e9 fd f3 ff ff       	jmp    80106c24 <alltraps>

80107827 <vector189>:
.globl vector189
vector189:
  pushl $0
80107827:	6a 00                	push   $0x0
  pushl $189
80107829:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010782e:	e9 f1 f3 ff ff       	jmp    80106c24 <alltraps>

80107833 <vector190>:
.globl vector190
vector190:
  pushl $0
80107833:	6a 00                	push   $0x0
  pushl $190
80107835:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010783a:	e9 e5 f3 ff ff       	jmp    80106c24 <alltraps>

8010783f <vector191>:
.globl vector191
vector191:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $191
80107841:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107846:	e9 d9 f3 ff ff       	jmp    80106c24 <alltraps>

8010784b <vector192>:
.globl vector192
vector192:
  pushl $0
8010784b:	6a 00                	push   $0x0
  pushl $192
8010784d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107852:	e9 cd f3 ff ff       	jmp    80106c24 <alltraps>

80107857 <vector193>:
.globl vector193
vector193:
  pushl $0
80107857:	6a 00                	push   $0x0
  pushl $193
80107859:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010785e:	e9 c1 f3 ff ff       	jmp    80106c24 <alltraps>

80107863 <vector194>:
.globl vector194
vector194:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $194
80107865:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010786a:	e9 b5 f3 ff ff       	jmp    80106c24 <alltraps>

8010786f <vector195>:
.globl vector195
vector195:
  pushl $0
8010786f:	6a 00                	push   $0x0
  pushl $195
80107871:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107876:	e9 a9 f3 ff ff       	jmp    80106c24 <alltraps>

8010787b <vector196>:
.globl vector196
vector196:
  pushl $0
8010787b:	6a 00                	push   $0x0
  pushl $196
8010787d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107882:	e9 9d f3 ff ff       	jmp    80106c24 <alltraps>

80107887 <vector197>:
.globl vector197
vector197:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $197
80107889:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010788e:	e9 91 f3 ff ff       	jmp    80106c24 <alltraps>

80107893 <vector198>:
.globl vector198
vector198:
  pushl $0
80107893:	6a 00                	push   $0x0
  pushl $198
80107895:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010789a:	e9 85 f3 ff ff       	jmp    80106c24 <alltraps>

8010789f <vector199>:
.globl vector199
vector199:
  pushl $0
8010789f:	6a 00                	push   $0x0
  pushl $199
801078a1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801078a6:	e9 79 f3 ff ff       	jmp    80106c24 <alltraps>

801078ab <vector200>:
.globl vector200
vector200:
  pushl $0
801078ab:	6a 00                	push   $0x0
  pushl $200
801078ad:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801078b2:	e9 6d f3 ff ff       	jmp    80106c24 <alltraps>

801078b7 <vector201>:
.globl vector201
vector201:
  pushl $0
801078b7:	6a 00                	push   $0x0
  pushl $201
801078b9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801078be:	e9 61 f3 ff ff       	jmp    80106c24 <alltraps>

801078c3 <vector202>:
.globl vector202
vector202:
  pushl $0
801078c3:	6a 00                	push   $0x0
  pushl $202
801078c5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801078ca:	e9 55 f3 ff ff       	jmp    80106c24 <alltraps>

801078cf <vector203>:
.globl vector203
vector203:
  pushl $0
801078cf:	6a 00                	push   $0x0
  pushl $203
801078d1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801078d6:	e9 49 f3 ff ff       	jmp    80106c24 <alltraps>

801078db <vector204>:
.globl vector204
vector204:
  pushl $0
801078db:	6a 00                	push   $0x0
  pushl $204
801078dd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801078e2:	e9 3d f3 ff ff       	jmp    80106c24 <alltraps>

801078e7 <vector205>:
.globl vector205
vector205:
  pushl $0
801078e7:	6a 00                	push   $0x0
  pushl $205
801078e9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801078ee:	e9 31 f3 ff ff       	jmp    80106c24 <alltraps>

801078f3 <vector206>:
.globl vector206
vector206:
  pushl $0
801078f3:	6a 00                	push   $0x0
  pushl $206
801078f5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801078fa:	e9 25 f3 ff ff       	jmp    80106c24 <alltraps>

801078ff <vector207>:
.globl vector207
vector207:
  pushl $0
801078ff:	6a 00                	push   $0x0
  pushl $207
80107901:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107906:	e9 19 f3 ff ff       	jmp    80106c24 <alltraps>

8010790b <vector208>:
.globl vector208
vector208:
  pushl $0
8010790b:	6a 00                	push   $0x0
  pushl $208
8010790d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107912:	e9 0d f3 ff ff       	jmp    80106c24 <alltraps>

80107917 <vector209>:
.globl vector209
vector209:
  pushl $0
80107917:	6a 00                	push   $0x0
  pushl $209
80107919:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010791e:	e9 01 f3 ff ff       	jmp    80106c24 <alltraps>

80107923 <vector210>:
.globl vector210
vector210:
  pushl $0
80107923:	6a 00                	push   $0x0
  pushl $210
80107925:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010792a:	e9 f5 f2 ff ff       	jmp    80106c24 <alltraps>

8010792f <vector211>:
.globl vector211
vector211:
  pushl $0
8010792f:	6a 00                	push   $0x0
  pushl $211
80107931:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107936:	e9 e9 f2 ff ff       	jmp    80106c24 <alltraps>

8010793b <vector212>:
.globl vector212
vector212:
  pushl $0
8010793b:	6a 00                	push   $0x0
  pushl $212
8010793d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107942:	e9 dd f2 ff ff       	jmp    80106c24 <alltraps>

80107947 <vector213>:
.globl vector213
vector213:
  pushl $0
80107947:	6a 00                	push   $0x0
  pushl $213
80107949:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010794e:	e9 d1 f2 ff ff       	jmp    80106c24 <alltraps>

80107953 <vector214>:
.globl vector214
vector214:
  pushl $0
80107953:	6a 00                	push   $0x0
  pushl $214
80107955:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010795a:	e9 c5 f2 ff ff       	jmp    80106c24 <alltraps>

8010795f <vector215>:
.globl vector215
vector215:
  pushl $0
8010795f:	6a 00                	push   $0x0
  pushl $215
80107961:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107966:	e9 b9 f2 ff ff       	jmp    80106c24 <alltraps>

8010796b <vector216>:
.globl vector216
vector216:
  pushl $0
8010796b:	6a 00                	push   $0x0
  pushl $216
8010796d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107972:	e9 ad f2 ff ff       	jmp    80106c24 <alltraps>

80107977 <vector217>:
.globl vector217
vector217:
  pushl $0
80107977:	6a 00                	push   $0x0
  pushl $217
80107979:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010797e:	e9 a1 f2 ff ff       	jmp    80106c24 <alltraps>

80107983 <vector218>:
.globl vector218
vector218:
  pushl $0
80107983:	6a 00                	push   $0x0
  pushl $218
80107985:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010798a:	e9 95 f2 ff ff       	jmp    80106c24 <alltraps>

8010798f <vector219>:
.globl vector219
vector219:
  pushl $0
8010798f:	6a 00                	push   $0x0
  pushl $219
80107991:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107996:	e9 89 f2 ff ff       	jmp    80106c24 <alltraps>

8010799b <vector220>:
.globl vector220
vector220:
  pushl $0
8010799b:	6a 00                	push   $0x0
  pushl $220
8010799d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801079a2:	e9 7d f2 ff ff       	jmp    80106c24 <alltraps>

801079a7 <vector221>:
.globl vector221
vector221:
  pushl $0
801079a7:	6a 00                	push   $0x0
  pushl $221
801079a9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801079ae:	e9 71 f2 ff ff       	jmp    80106c24 <alltraps>

801079b3 <vector222>:
.globl vector222
vector222:
  pushl $0
801079b3:	6a 00                	push   $0x0
  pushl $222
801079b5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801079ba:	e9 65 f2 ff ff       	jmp    80106c24 <alltraps>

801079bf <vector223>:
.globl vector223
vector223:
  pushl $0
801079bf:	6a 00                	push   $0x0
  pushl $223
801079c1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801079c6:	e9 59 f2 ff ff       	jmp    80106c24 <alltraps>

801079cb <vector224>:
.globl vector224
vector224:
  pushl $0
801079cb:	6a 00                	push   $0x0
  pushl $224
801079cd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801079d2:	e9 4d f2 ff ff       	jmp    80106c24 <alltraps>

801079d7 <vector225>:
.globl vector225
vector225:
  pushl $0
801079d7:	6a 00                	push   $0x0
  pushl $225
801079d9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801079de:	e9 41 f2 ff ff       	jmp    80106c24 <alltraps>

801079e3 <vector226>:
.globl vector226
vector226:
  pushl $0
801079e3:	6a 00                	push   $0x0
  pushl $226
801079e5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801079ea:	e9 35 f2 ff ff       	jmp    80106c24 <alltraps>

801079ef <vector227>:
.globl vector227
vector227:
  pushl $0
801079ef:	6a 00                	push   $0x0
  pushl $227
801079f1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801079f6:	e9 29 f2 ff ff       	jmp    80106c24 <alltraps>

801079fb <vector228>:
.globl vector228
vector228:
  pushl $0
801079fb:	6a 00                	push   $0x0
  pushl $228
801079fd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107a02:	e9 1d f2 ff ff       	jmp    80106c24 <alltraps>

80107a07 <vector229>:
.globl vector229
vector229:
  pushl $0
80107a07:	6a 00                	push   $0x0
  pushl $229
80107a09:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107a0e:	e9 11 f2 ff ff       	jmp    80106c24 <alltraps>

80107a13 <vector230>:
.globl vector230
vector230:
  pushl $0
80107a13:	6a 00                	push   $0x0
  pushl $230
80107a15:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107a1a:	e9 05 f2 ff ff       	jmp    80106c24 <alltraps>

80107a1f <vector231>:
.globl vector231
vector231:
  pushl $0
80107a1f:	6a 00                	push   $0x0
  pushl $231
80107a21:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107a26:	e9 f9 f1 ff ff       	jmp    80106c24 <alltraps>

80107a2b <vector232>:
.globl vector232
vector232:
  pushl $0
80107a2b:	6a 00                	push   $0x0
  pushl $232
80107a2d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107a32:	e9 ed f1 ff ff       	jmp    80106c24 <alltraps>

80107a37 <vector233>:
.globl vector233
vector233:
  pushl $0
80107a37:	6a 00                	push   $0x0
  pushl $233
80107a39:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107a3e:	e9 e1 f1 ff ff       	jmp    80106c24 <alltraps>

80107a43 <vector234>:
.globl vector234
vector234:
  pushl $0
80107a43:	6a 00                	push   $0x0
  pushl $234
80107a45:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107a4a:	e9 d5 f1 ff ff       	jmp    80106c24 <alltraps>

80107a4f <vector235>:
.globl vector235
vector235:
  pushl $0
80107a4f:	6a 00                	push   $0x0
  pushl $235
80107a51:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107a56:	e9 c9 f1 ff ff       	jmp    80106c24 <alltraps>

80107a5b <vector236>:
.globl vector236
vector236:
  pushl $0
80107a5b:	6a 00                	push   $0x0
  pushl $236
80107a5d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107a62:	e9 bd f1 ff ff       	jmp    80106c24 <alltraps>

80107a67 <vector237>:
.globl vector237
vector237:
  pushl $0
80107a67:	6a 00                	push   $0x0
  pushl $237
80107a69:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107a6e:	e9 b1 f1 ff ff       	jmp    80106c24 <alltraps>

80107a73 <vector238>:
.globl vector238
vector238:
  pushl $0
80107a73:	6a 00                	push   $0x0
  pushl $238
80107a75:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107a7a:	e9 a5 f1 ff ff       	jmp    80106c24 <alltraps>

80107a7f <vector239>:
.globl vector239
vector239:
  pushl $0
80107a7f:	6a 00                	push   $0x0
  pushl $239
80107a81:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107a86:	e9 99 f1 ff ff       	jmp    80106c24 <alltraps>

80107a8b <vector240>:
.globl vector240
vector240:
  pushl $0
80107a8b:	6a 00                	push   $0x0
  pushl $240
80107a8d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107a92:	e9 8d f1 ff ff       	jmp    80106c24 <alltraps>

80107a97 <vector241>:
.globl vector241
vector241:
  pushl $0
80107a97:	6a 00                	push   $0x0
  pushl $241
80107a99:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107a9e:	e9 81 f1 ff ff       	jmp    80106c24 <alltraps>

80107aa3 <vector242>:
.globl vector242
vector242:
  pushl $0
80107aa3:	6a 00                	push   $0x0
  pushl $242
80107aa5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107aaa:	e9 75 f1 ff ff       	jmp    80106c24 <alltraps>

80107aaf <vector243>:
.globl vector243
vector243:
  pushl $0
80107aaf:	6a 00                	push   $0x0
  pushl $243
80107ab1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107ab6:	e9 69 f1 ff ff       	jmp    80106c24 <alltraps>

80107abb <vector244>:
.globl vector244
vector244:
  pushl $0
80107abb:	6a 00                	push   $0x0
  pushl $244
80107abd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107ac2:	e9 5d f1 ff ff       	jmp    80106c24 <alltraps>

80107ac7 <vector245>:
.globl vector245
vector245:
  pushl $0
80107ac7:	6a 00                	push   $0x0
  pushl $245
80107ac9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107ace:	e9 51 f1 ff ff       	jmp    80106c24 <alltraps>

80107ad3 <vector246>:
.globl vector246
vector246:
  pushl $0
80107ad3:	6a 00                	push   $0x0
  pushl $246
80107ad5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107ada:	e9 45 f1 ff ff       	jmp    80106c24 <alltraps>

80107adf <vector247>:
.globl vector247
vector247:
  pushl $0
80107adf:	6a 00                	push   $0x0
  pushl $247
80107ae1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107ae6:	e9 39 f1 ff ff       	jmp    80106c24 <alltraps>

80107aeb <vector248>:
.globl vector248
vector248:
  pushl $0
80107aeb:	6a 00                	push   $0x0
  pushl $248
80107aed:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107af2:	e9 2d f1 ff ff       	jmp    80106c24 <alltraps>

80107af7 <vector249>:
.globl vector249
vector249:
  pushl $0
80107af7:	6a 00                	push   $0x0
  pushl $249
80107af9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107afe:	e9 21 f1 ff ff       	jmp    80106c24 <alltraps>

80107b03 <vector250>:
.globl vector250
vector250:
  pushl $0
80107b03:	6a 00                	push   $0x0
  pushl $250
80107b05:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107b0a:	e9 15 f1 ff ff       	jmp    80106c24 <alltraps>

80107b0f <vector251>:
.globl vector251
vector251:
  pushl $0
80107b0f:	6a 00                	push   $0x0
  pushl $251
80107b11:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107b16:	e9 09 f1 ff ff       	jmp    80106c24 <alltraps>

80107b1b <vector252>:
.globl vector252
vector252:
  pushl $0
80107b1b:	6a 00                	push   $0x0
  pushl $252
80107b1d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107b22:	e9 fd f0 ff ff       	jmp    80106c24 <alltraps>

80107b27 <vector253>:
.globl vector253
vector253:
  pushl $0
80107b27:	6a 00                	push   $0x0
  pushl $253
80107b29:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107b2e:	e9 f1 f0 ff ff       	jmp    80106c24 <alltraps>

80107b33 <vector254>:
.globl vector254
vector254:
  pushl $0
80107b33:	6a 00                	push   $0x0
  pushl $254
80107b35:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107b3a:	e9 e5 f0 ff ff       	jmp    80106c24 <alltraps>

80107b3f <vector255>:
.globl vector255
vector255:
  pushl $0
80107b3f:	6a 00                	push   $0x0
  pushl $255
80107b41:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107b46:	e9 d9 f0 ff ff       	jmp    80106c24 <alltraps>
80107b4b:	66 90                	xchg   %ax,%ax
80107b4d:	66 90                	xchg   %ax,%ax
80107b4f:	90                   	nop

80107b50 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107b50:	55                   	push   %ebp
80107b51:	89 e5                	mov    %esp,%ebp
80107b53:	57                   	push   %edi
80107b54:	56                   	push   %esi
80107b55:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107b57:	c1 ea 16             	shr    $0x16,%edx
{
80107b5a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80107b5b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80107b5e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107b61:	8b 1f                	mov    (%edi),%ebx
80107b63:	f6 c3 01             	test   $0x1,%bl
80107b66:	74 28                	je     80107b90 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107b6e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107b74:	89 f0                	mov    %esi,%eax
}
80107b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107b79:	c1 e8 0a             	shr    $0xa,%eax
80107b7c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107b81:	01 d8                	add    %ebx,%eax
}
80107b83:	5b                   	pop    %ebx
80107b84:	5e                   	pop    %esi
80107b85:	5f                   	pop    %edi
80107b86:	5d                   	pop    %ebp
80107b87:	c3                   	ret    
80107b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b8f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b90:	85 c9                	test   %ecx,%ecx
80107b92:	74 2c                	je     80107bc0 <walkpgdir+0x70>
80107b94:	e8 07 ae ff ff       	call   801029a0 <kalloc>
80107b99:	89 c3                	mov    %eax,%ebx
80107b9b:	85 c0                	test   %eax,%eax
80107b9d:	74 21                	je     80107bc0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80107b9f:	83 ec 04             	sub    $0x4,%esp
80107ba2:	68 00 10 00 00       	push   $0x1000
80107ba7:	6a 00                	push   $0x0
80107ba9:	50                   	push   %eax
80107baa:	e8 51 dc ff ff       	call   80105800 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107baf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107bb5:	83 c4 10             	add    $0x10,%esp
80107bb8:	83 c8 07             	or     $0x7,%eax
80107bbb:	89 07                	mov    %eax,(%edi)
80107bbd:	eb b5                	jmp    80107b74 <walkpgdir+0x24>
80107bbf:	90                   	nop
}
80107bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107bc3:	31 c0                	xor    %eax,%eax
}
80107bc5:	5b                   	pop    %ebx
80107bc6:	5e                   	pop    %esi
80107bc7:	5f                   	pop    %edi
80107bc8:	5d                   	pop    %ebp
80107bc9:	c3                   	ret    
80107bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107bd0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107bd0:	55                   	push   %ebp
80107bd1:	89 e5                	mov    %esp,%ebp
80107bd3:	57                   	push   %edi
80107bd4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107bd6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80107bda:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107bdb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107be0:	89 d6                	mov    %edx,%esi
{
80107be2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107be3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107be9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107bec:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107bef:	8b 45 08             	mov    0x8(%ebp),%eax
80107bf2:	29 f0                	sub    %esi,%eax
80107bf4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107bf7:	eb 1f                	jmp    80107c18 <mappages+0x48>
80107bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107c00:	f6 00 01             	testb  $0x1,(%eax)
80107c03:	75 45                	jne    80107c4a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107c05:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107c08:	83 cb 01             	or     $0x1,%ebx
80107c0b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80107c0d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107c10:	74 2e                	je     80107c40 <mappages+0x70>
      break;
    a += PGSIZE;
80107c12:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107c1b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107c20:	89 f2                	mov    %esi,%edx
80107c22:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107c25:	89 f8                	mov    %edi,%eax
80107c27:	e8 24 ff ff ff       	call   80107b50 <walkpgdir>
80107c2c:	85 c0                	test   %eax,%eax
80107c2e:	75 d0                	jne    80107c00 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107c33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c38:	5b                   	pop    %ebx
80107c39:	5e                   	pop    %esi
80107c3a:	5f                   	pop    %edi
80107c3b:	5d                   	pop    %ebp
80107c3c:	c3                   	ret    
80107c3d:	8d 76 00             	lea    0x0(%esi),%esi
80107c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c43:	31 c0                	xor    %eax,%eax
}
80107c45:	5b                   	pop    %ebx
80107c46:	5e                   	pop    %esi
80107c47:	5f                   	pop    %edi
80107c48:	5d                   	pop    %ebp
80107c49:	c3                   	ret    
      panic("remap");
80107c4a:	83 ec 0c             	sub    $0xc,%esp
80107c4d:	68 88 8f 10 80       	push   $0x80108f88
80107c52:	e8 39 87 ff ff       	call   80100390 <panic>
80107c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c5e:	66 90                	xchg   %ax,%ax

80107c60 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	57                   	push   %edi
80107c64:	56                   	push   %esi
80107c65:	89 c6                	mov    %eax,%esi
80107c67:	53                   	push   %ebx
80107c68:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107c6a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107c70:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107c76:	83 ec 1c             	sub    $0x1c,%esp
80107c79:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107c7c:	39 da                	cmp    %ebx,%edx
80107c7e:	73 5b                	jae    80107cdb <deallocuvm.part.0+0x7b>
80107c80:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107c83:	89 d7                	mov    %edx,%edi
80107c85:	eb 14                	jmp    80107c9b <deallocuvm.part.0+0x3b>
80107c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c8e:	66 90                	xchg   %ax,%ax
80107c90:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107c96:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107c99:	76 40                	jbe    80107cdb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107c9b:	31 c9                	xor    %ecx,%ecx
80107c9d:	89 fa                	mov    %edi,%edx
80107c9f:	89 f0                	mov    %esi,%eax
80107ca1:	e8 aa fe ff ff       	call   80107b50 <walkpgdir>
80107ca6:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107ca8:	85 c0                	test   %eax,%eax
80107caa:	74 44                	je     80107cf0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107cac:	8b 00                	mov    (%eax),%eax
80107cae:	a8 01                	test   $0x1,%al
80107cb0:	74 de                	je     80107c90 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107cb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cb7:	74 47                	je     80107d00 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107cb9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107cbc:	05 00 00 00 80       	add    $0x80000000,%eax
80107cc1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107cc7:	50                   	push   %eax
80107cc8:	e8 13 ab ff ff       	call   801027e0 <kfree>
      *pte = 0;
80107ccd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107cd3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107cd6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107cd9:	77 c0                	ja     80107c9b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80107cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107cde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ce1:	5b                   	pop    %ebx
80107ce2:	5e                   	pop    %esi
80107ce3:	5f                   	pop    %edi
80107ce4:	5d                   	pop    %ebp
80107ce5:	c3                   	ret    
80107ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ced:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107cf0:	89 fa                	mov    %edi,%edx
80107cf2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107cf8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80107cfe:	eb 96                	jmp    80107c96 <deallocuvm.part.0+0x36>
        panic("kfree");
80107d00:	83 ec 0c             	sub    $0xc,%esp
80107d03:	68 6a 87 10 80       	push   $0x8010876a
80107d08:	e8 83 86 ff ff       	call   80100390 <panic>
80107d0d:	8d 76 00             	lea    0x0(%esi),%esi

80107d10 <seginit>:
{
80107d10:	f3 0f 1e fb          	endbr32 
80107d14:	55                   	push   %ebp
80107d15:	89 e5                	mov    %esp,%ebp
80107d17:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107d1a:	e8 31 c0 ff ff       	call   80103d50 <cpuid>
  pd[0] = size-1;
80107d1f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107d24:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107d2a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107d2e:	c7 80 18 49 11 80 ff 	movl   $0xffff,-0x7feeb6e8(%eax)
80107d35:	ff 00 00 
80107d38:	c7 80 1c 49 11 80 00 	movl   $0xcf9a00,-0x7feeb6e4(%eax)
80107d3f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107d42:	c7 80 20 49 11 80 ff 	movl   $0xffff,-0x7feeb6e0(%eax)
80107d49:	ff 00 00 
80107d4c:	c7 80 24 49 11 80 00 	movl   $0xcf9200,-0x7feeb6dc(%eax)
80107d53:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107d56:	c7 80 28 49 11 80 ff 	movl   $0xffff,-0x7feeb6d8(%eax)
80107d5d:	ff 00 00 
80107d60:	c7 80 2c 49 11 80 00 	movl   $0xcffa00,-0x7feeb6d4(%eax)
80107d67:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107d6a:	c7 80 30 49 11 80 ff 	movl   $0xffff,-0x7feeb6d0(%eax)
80107d71:	ff 00 00 
80107d74:	c7 80 34 49 11 80 00 	movl   $0xcff200,-0x7feeb6cc(%eax)
80107d7b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107d7e:	05 10 49 11 80       	add    $0x80114910,%eax
  pd[1] = (uint)p;
80107d83:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107d87:	c1 e8 10             	shr    $0x10,%eax
80107d8a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107d8e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107d91:	0f 01 10             	lgdtl  (%eax)
}
80107d94:	c9                   	leave  
80107d95:	c3                   	ret    
80107d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d9d:	8d 76 00             	lea    0x0(%esi),%esi

80107da0 <switchkvm>:
{
80107da0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107da4:	a1 c4 9f 11 80       	mov    0x80119fc4,%eax
80107da9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107dae:	0f 22 d8             	mov    %eax,%cr3
}
80107db1:	c3                   	ret    
80107db2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107dc0 <switchuvm>:
{
80107dc0:	f3 0f 1e fb          	endbr32 
80107dc4:	55                   	push   %ebp
80107dc5:	89 e5                	mov    %esp,%ebp
80107dc7:	57                   	push   %edi
80107dc8:	56                   	push   %esi
80107dc9:	53                   	push   %ebx
80107dca:	83 ec 1c             	sub    $0x1c,%esp
80107dcd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107dd0:	85 f6                	test   %esi,%esi
80107dd2:	0f 84 cb 00 00 00    	je     80107ea3 <switchuvm+0xe3>
  if(p->kstack == 0)
80107dd8:	8b 46 08             	mov    0x8(%esi),%eax
80107ddb:	85 c0                	test   %eax,%eax
80107ddd:	0f 84 da 00 00 00    	je     80107ebd <switchuvm+0xfd>
  if(p->pgdir == 0)
80107de3:	8b 46 04             	mov    0x4(%esi),%eax
80107de6:	85 c0                	test   %eax,%eax
80107de8:	0f 84 c2 00 00 00    	je     80107eb0 <switchuvm+0xf0>
  pushcli();
80107dee:	e8 fd d7 ff ff       	call   801055f0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107df3:	e8 e8 be ff ff       	call   80103ce0 <mycpu>
80107df8:	89 c3                	mov    %eax,%ebx
80107dfa:	e8 e1 be ff ff       	call   80103ce0 <mycpu>
80107dff:	89 c7                	mov    %eax,%edi
80107e01:	e8 da be ff ff       	call   80103ce0 <mycpu>
80107e06:	83 c7 08             	add    $0x8,%edi
80107e09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e0c:	e8 cf be ff ff       	call   80103ce0 <mycpu>
80107e11:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107e14:	ba 67 00 00 00       	mov    $0x67,%edx
80107e19:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107e20:	83 c0 08             	add    $0x8,%eax
80107e23:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107e2a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107e2f:	83 c1 08             	add    $0x8,%ecx
80107e32:	c1 e8 18             	shr    $0x18,%eax
80107e35:	c1 e9 10             	shr    $0x10,%ecx
80107e38:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107e3e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107e44:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107e49:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107e50:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107e55:	e8 86 be ff ff       	call   80103ce0 <mycpu>
80107e5a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107e61:	e8 7a be ff ff       	call   80103ce0 <mycpu>
80107e66:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107e6a:	8b 5e 08             	mov    0x8(%esi),%ebx
80107e6d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107e73:	e8 68 be ff ff       	call   80103ce0 <mycpu>
80107e78:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107e7b:	e8 60 be ff ff       	call   80103ce0 <mycpu>
80107e80:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107e84:	b8 28 00 00 00       	mov    $0x28,%eax
80107e89:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107e8c:	8b 46 04             	mov    0x4(%esi),%eax
80107e8f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107e94:	0f 22 d8             	mov    %eax,%cr3
}
80107e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e9a:	5b                   	pop    %ebx
80107e9b:	5e                   	pop    %esi
80107e9c:	5f                   	pop    %edi
80107e9d:	5d                   	pop    %ebp
  popcli();
80107e9e:	e9 9d d7 ff ff       	jmp    80105640 <popcli>
    panic("switchuvm: no process");
80107ea3:	83 ec 0c             	sub    $0xc,%esp
80107ea6:	68 8e 8f 10 80       	push   $0x80108f8e
80107eab:	e8 e0 84 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107eb0:	83 ec 0c             	sub    $0xc,%esp
80107eb3:	68 b9 8f 10 80       	push   $0x80108fb9
80107eb8:	e8 d3 84 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107ebd:	83 ec 0c             	sub    $0xc,%esp
80107ec0:	68 a4 8f 10 80       	push   $0x80108fa4
80107ec5:	e8 c6 84 ff ff       	call   80100390 <panic>
80107eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ed0 <inituvm>:
{
80107ed0:	f3 0f 1e fb          	endbr32 
80107ed4:	55                   	push   %ebp
80107ed5:	89 e5                	mov    %esp,%ebp
80107ed7:	57                   	push   %edi
80107ed8:	56                   	push   %esi
80107ed9:	53                   	push   %ebx
80107eda:	83 ec 1c             	sub    $0x1c,%esp
80107edd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ee0:	8b 75 10             	mov    0x10(%ebp),%esi
80107ee3:	8b 7d 08             	mov    0x8(%ebp),%edi
80107ee6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107ee9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107eef:	77 4b                	ja     80107f3c <inituvm+0x6c>
  mem = kalloc();
80107ef1:	e8 aa aa ff ff       	call   801029a0 <kalloc>
  memset(mem, 0, PGSIZE);
80107ef6:	83 ec 04             	sub    $0x4,%esp
80107ef9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107efe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107f00:	6a 00                	push   $0x0
80107f02:	50                   	push   %eax
80107f03:	e8 f8 d8 ff ff       	call   80105800 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107f08:	58                   	pop    %eax
80107f09:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107f0f:	5a                   	pop    %edx
80107f10:	6a 06                	push   $0x6
80107f12:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f17:	31 d2                	xor    %edx,%edx
80107f19:	50                   	push   %eax
80107f1a:	89 f8                	mov    %edi,%eax
80107f1c:	e8 af fc ff ff       	call   80107bd0 <mappages>
  memmove(mem, init, sz);
80107f21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f24:	89 75 10             	mov    %esi,0x10(%ebp)
80107f27:	83 c4 10             	add    $0x10,%esp
80107f2a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107f2d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f33:	5b                   	pop    %ebx
80107f34:	5e                   	pop    %esi
80107f35:	5f                   	pop    %edi
80107f36:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107f37:	e9 64 d9 ff ff       	jmp    801058a0 <memmove>
    panic("inituvm: more than a page");
80107f3c:	83 ec 0c             	sub    $0xc,%esp
80107f3f:	68 cd 8f 10 80       	push   $0x80108fcd
80107f44:	e8 47 84 ff ff       	call   80100390 <panic>
80107f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107f50 <loaduvm>:
{
80107f50:	f3 0f 1e fb          	endbr32 
80107f54:	55                   	push   %ebp
80107f55:	89 e5                	mov    %esp,%ebp
80107f57:	57                   	push   %edi
80107f58:	56                   	push   %esi
80107f59:	53                   	push   %ebx
80107f5a:	83 ec 1c             	sub    $0x1c,%esp
80107f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f60:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107f63:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107f68:	0f 85 99 00 00 00    	jne    80108007 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80107f6e:	01 f0                	add    %esi,%eax
80107f70:	89 f3                	mov    %esi,%ebx
80107f72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107f75:	8b 45 14             	mov    0x14(%ebp),%eax
80107f78:	01 f0                	add    %esi,%eax
80107f7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107f7d:	85 f6                	test   %esi,%esi
80107f7f:	75 15                	jne    80107f96 <loaduvm+0x46>
80107f81:	eb 6d                	jmp    80107ff0 <loaduvm+0xa0>
80107f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f87:	90                   	nop
80107f88:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107f8e:	89 f0                	mov    %esi,%eax
80107f90:	29 d8                	sub    %ebx,%eax
80107f92:	39 c6                	cmp    %eax,%esi
80107f94:	76 5a                	jbe    80107ff0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107f99:	8b 45 08             	mov    0x8(%ebp),%eax
80107f9c:	31 c9                	xor    %ecx,%ecx
80107f9e:	29 da                	sub    %ebx,%edx
80107fa0:	e8 ab fb ff ff       	call   80107b50 <walkpgdir>
80107fa5:	85 c0                	test   %eax,%eax
80107fa7:	74 51                	je     80107ffa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107fa9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107fab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107fae:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107fb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107fb8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107fbe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107fc1:	29 d9                	sub    %ebx,%ecx
80107fc3:	05 00 00 00 80       	add    $0x80000000,%eax
80107fc8:	57                   	push   %edi
80107fc9:	51                   	push   %ecx
80107fca:	50                   	push   %eax
80107fcb:	ff 75 10             	pushl  0x10(%ebp)
80107fce:	e8 fd 9d ff ff       	call   80101dd0 <readi>
80107fd3:	83 c4 10             	add    $0x10,%esp
80107fd6:	39 f8                	cmp    %edi,%eax
80107fd8:	74 ae                	je     80107f88 <loaduvm+0x38>
}
80107fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107fdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107fe2:	5b                   	pop    %ebx
80107fe3:	5e                   	pop    %esi
80107fe4:	5f                   	pop    %edi
80107fe5:	5d                   	pop    %ebp
80107fe6:	c3                   	ret    
80107fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fee:	66 90                	xchg   %ax,%ax
80107ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ff3:	31 c0                	xor    %eax,%eax
}
80107ff5:	5b                   	pop    %ebx
80107ff6:	5e                   	pop    %esi
80107ff7:	5f                   	pop    %edi
80107ff8:	5d                   	pop    %ebp
80107ff9:	c3                   	ret    
      panic("loaduvm: address should exist");
80107ffa:	83 ec 0c             	sub    $0xc,%esp
80107ffd:	68 e7 8f 10 80       	push   $0x80108fe7
80108002:	e8 89 83 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80108007:	83 ec 0c             	sub    $0xc,%esp
8010800a:	68 88 90 10 80       	push   $0x80109088
8010800f:	e8 7c 83 ff ff       	call   80100390 <panic>
80108014:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010801b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010801f:	90                   	nop

80108020 <allocuvm>:
{
80108020:	f3 0f 1e fb          	endbr32 
80108024:	55                   	push   %ebp
80108025:	89 e5                	mov    %esp,%ebp
80108027:	57                   	push   %edi
80108028:	56                   	push   %esi
80108029:	53                   	push   %ebx
8010802a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010802d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80108030:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80108033:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108036:	85 c0                	test   %eax,%eax
80108038:	0f 88 b2 00 00 00    	js     801080f0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010803e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80108041:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108044:	0f 82 96 00 00 00    	jb     801080e0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010804a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80108050:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108056:	39 75 10             	cmp    %esi,0x10(%ebp)
80108059:	77 40                	ja     8010809b <allocuvm+0x7b>
8010805b:	e9 83 00 00 00       	jmp    801080e3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80108060:	83 ec 04             	sub    $0x4,%esp
80108063:	68 00 10 00 00       	push   $0x1000
80108068:	6a 00                	push   $0x0
8010806a:	50                   	push   %eax
8010806b:	e8 90 d7 ff ff       	call   80105800 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108070:	58                   	pop    %eax
80108071:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108077:	5a                   	pop    %edx
80108078:	6a 06                	push   $0x6
8010807a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010807f:	89 f2                	mov    %esi,%edx
80108081:	50                   	push   %eax
80108082:	89 f8                	mov    %edi,%eax
80108084:	e8 47 fb ff ff       	call   80107bd0 <mappages>
80108089:	83 c4 10             	add    $0x10,%esp
8010808c:	85 c0                	test   %eax,%eax
8010808e:	78 78                	js     80108108 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80108090:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108096:	39 75 10             	cmp    %esi,0x10(%ebp)
80108099:	76 48                	jbe    801080e3 <allocuvm+0xc3>
    mem = kalloc();
8010809b:	e8 00 a9 ff ff       	call   801029a0 <kalloc>
801080a0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801080a2:	85 c0                	test   %eax,%eax
801080a4:	75 ba                	jne    80108060 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801080a6:	83 ec 0c             	sub    $0xc,%esp
801080a9:	68 05 90 10 80       	push   $0x80109005
801080ae:	e8 fd 85 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801080b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801080b6:	83 c4 10             	add    $0x10,%esp
801080b9:	39 45 10             	cmp    %eax,0x10(%ebp)
801080bc:	74 32                	je     801080f0 <allocuvm+0xd0>
801080be:	8b 55 10             	mov    0x10(%ebp),%edx
801080c1:	89 c1                	mov    %eax,%ecx
801080c3:	89 f8                	mov    %edi,%eax
801080c5:	e8 96 fb ff ff       	call   80107c60 <deallocuvm.part.0>
      return 0;
801080ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801080d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080d7:	5b                   	pop    %ebx
801080d8:	5e                   	pop    %esi
801080d9:	5f                   	pop    %edi
801080da:	5d                   	pop    %ebp
801080db:	c3                   	ret    
801080dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801080e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801080e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080e9:	5b                   	pop    %ebx
801080ea:	5e                   	pop    %esi
801080eb:	5f                   	pop    %edi
801080ec:	5d                   	pop    %ebp
801080ed:	c3                   	ret    
801080ee:	66 90                	xchg   %ax,%ax
    return 0;
801080f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801080f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080fd:	5b                   	pop    %ebx
801080fe:	5e                   	pop    %esi
801080ff:	5f                   	pop    %edi
80108100:	5d                   	pop    %ebp
80108101:	c3                   	ret    
80108102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108108:	83 ec 0c             	sub    $0xc,%esp
8010810b:	68 1d 90 10 80       	push   $0x8010901d
80108110:	e8 9b 85 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80108115:	8b 45 0c             	mov    0xc(%ebp),%eax
80108118:	83 c4 10             	add    $0x10,%esp
8010811b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010811e:	74 0c                	je     8010812c <allocuvm+0x10c>
80108120:	8b 55 10             	mov    0x10(%ebp),%edx
80108123:	89 c1                	mov    %eax,%ecx
80108125:	89 f8                	mov    %edi,%eax
80108127:	e8 34 fb ff ff       	call   80107c60 <deallocuvm.part.0>
      kfree(mem);
8010812c:	83 ec 0c             	sub    $0xc,%esp
8010812f:	53                   	push   %ebx
80108130:	e8 ab a6 ff ff       	call   801027e0 <kfree>
      return 0;
80108135:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010813c:	83 c4 10             	add    $0x10,%esp
}
8010813f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108142:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108145:	5b                   	pop    %ebx
80108146:	5e                   	pop    %esi
80108147:	5f                   	pop    %edi
80108148:	5d                   	pop    %ebp
80108149:	c3                   	ret    
8010814a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108150 <deallocuvm>:
{
80108150:	f3 0f 1e fb          	endbr32 
80108154:	55                   	push   %ebp
80108155:	89 e5                	mov    %esp,%ebp
80108157:	8b 55 0c             	mov    0xc(%ebp),%edx
8010815a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010815d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80108160:	39 d1                	cmp    %edx,%ecx
80108162:	73 0c                	jae    80108170 <deallocuvm+0x20>
}
80108164:	5d                   	pop    %ebp
80108165:	e9 f6 fa ff ff       	jmp    80107c60 <deallocuvm.part.0>
8010816a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108170:	89 d0                	mov    %edx,%eax
80108172:	5d                   	pop    %ebp
80108173:	c3                   	ret    
80108174:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010817b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010817f:	90                   	nop

80108180 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108180:	f3 0f 1e fb          	endbr32 
80108184:	55                   	push   %ebp
80108185:	89 e5                	mov    %esp,%ebp
80108187:	57                   	push   %edi
80108188:	56                   	push   %esi
80108189:	53                   	push   %ebx
8010818a:	83 ec 0c             	sub    $0xc,%esp
8010818d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80108190:	85 f6                	test   %esi,%esi
80108192:	74 55                	je     801081e9 <freevm+0x69>
  if(newsz >= oldsz)
80108194:	31 c9                	xor    %ecx,%ecx
80108196:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010819b:	89 f0                	mov    %esi,%eax
8010819d:	89 f3                	mov    %esi,%ebx
8010819f:	e8 bc fa ff ff       	call   80107c60 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801081a4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801081aa:	eb 0b                	jmp    801081b7 <freevm+0x37>
801081ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801081b0:	83 c3 04             	add    $0x4,%ebx
801081b3:	39 df                	cmp    %ebx,%edi
801081b5:	74 23                	je     801081da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801081b7:	8b 03                	mov    (%ebx),%eax
801081b9:	a8 01                	test   $0x1,%al
801081bb:	74 f3                	je     801081b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801081bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801081c2:	83 ec 0c             	sub    $0xc,%esp
801081c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801081c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801081cd:	50                   	push   %eax
801081ce:	e8 0d a6 ff ff       	call   801027e0 <kfree>
801081d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801081d6:	39 df                	cmp    %ebx,%edi
801081d8:	75 dd                	jne    801081b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801081da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801081dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081e0:	5b                   	pop    %ebx
801081e1:	5e                   	pop    %esi
801081e2:	5f                   	pop    %edi
801081e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801081e4:	e9 f7 a5 ff ff       	jmp    801027e0 <kfree>
    panic("freevm: no pgdir");
801081e9:	83 ec 0c             	sub    $0xc,%esp
801081ec:	68 39 90 10 80       	push   $0x80109039
801081f1:	e8 9a 81 ff ff       	call   80100390 <panic>
801081f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081fd:	8d 76 00             	lea    0x0(%esi),%esi

80108200 <setupkvm>:
{
80108200:	f3 0f 1e fb          	endbr32 
80108204:	55                   	push   %ebp
80108205:	89 e5                	mov    %esp,%ebp
80108207:	56                   	push   %esi
80108208:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108209:	e8 92 a7 ff ff       	call   801029a0 <kalloc>
8010820e:	89 c6                	mov    %eax,%esi
80108210:	85 c0                	test   %eax,%eax
80108212:	74 42                	je     80108256 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80108214:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108217:	bb a0 c4 10 80       	mov    $0x8010c4a0,%ebx
  memset(pgdir, 0, PGSIZE);
8010821c:	68 00 10 00 00       	push   $0x1000
80108221:	6a 00                	push   $0x0
80108223:	50                   	push   %eax
80108224:	e8 d7 d5 ff ff       	call   80105800 <memset>
80108229:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010822c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010822f:	83 ec 08             	sub    $0x8,%esp
80108232:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108235:	ff 73 0c             	pushl  0xc(%ebx)
80108238:	8b 13                	mov    (%ebx),%edx
8010823a:	50                   	push   %eax
8010823b:	29 c1                	sub    %eax,%ecx
8010823d:	89 f0                	mov    %esi,%eax
8010823f:	e8 8c f9 ff ff       	call   80107bd0 <mappages>
80108244:	83 c4 10             	add    $0x10,%esp
80108247:	85 c0                	test   %eax,%eax
80108249:	78 15                	js     80108260 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010824b:	83 c3 10             	add    $0x10,%ebx
8010824e:	81 fb e0 c4 10 80    	cmp    $0x8010c4e0,%ebx
80108254:	75 d6                	jne    8010822c <setupkvm+0x2c>
}
80108256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108259:	89 f0                	mov    %esi,%eax
8010825b:	5b                   	pop    %ebx
8010825c:	5e                   	pop    %esi
8010825d:	5d                   	pop    %ebp
8010825e:	c3                   	ret    
8010825f:	90                   	nop
      freevm(pgdir);
80108260:	83 ec 0c             	sub    $0xc,%esp
80108263:	56                   	push   %esi
      return 0;
80108264:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108266:	e8 15 ff ff ff       	call   80108180 <freevm>
      return 0;
8010826b:	83 c4 10             	add    $0x10,%esp
}
8010826e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108271:	89 f0                	mov    %esi,%eax
80108273:	5b                   	pop    %ebx
80108274:	5e                   	pop    %esi
80108275:	5d                   	pop    %ebp
80108276:	c3                   	ret    
80108277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010827e:	66 90                	xchg   %ax,%ax

80108280 <kvmalloc>:
{
80108280:	f3 0f 1e fb          	endbr32 
80108284:	55                   	push   %ebp
80108285:	89 e5                	mov    %esp,%ebp
80108287:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010828a:	e8 71 ff ff ff       	call   80108200 <setupkvm>
8010828f:	a3 c4 9f 11 80       	mov    %eax,0x80119fc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108294:	05 00 00 00 80       	add    $0x80000000,%eax
80108299:	0f 22 d8             	mov    %eax,%cr3
}
8010829c:	c9                   	leave  
8010829d:	c3                   	ret    
8010829e:	66 90                	xchg   %ax,%ax

801082a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801082a0:	f3 0f 1e fb          	endbr32 
801082a4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801082a5:	31 c9                	xor    %ecx,%ecx
{
801082a7:	89 e5                	mov    %esp,%ebp
801082a9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801082ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801082af:	8b 45 08             	mov    0x8(%ebp),%eax
801082b2:	e8 99 f8 ff ff       	call   80107b50 <walkpgdir>
  if(pte == 0)
801082b7:	85 c0                	test   %eax,%eax
801082b9:	74 05                	je     801082c0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801082bb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801082be:	c9                   	leave  
801082bf:	c3                   	ret    
    panic("clearpteu");
801082c0:	83 ec 0c             	sub    $0xc,%esp
801082c3:	68 4a 90 10 80       	push   $0x8010904a
801082c8:	e8 c3 80 ff ff       	call   80100390 <panic>
801082cd:	8d 76 00             	lea    0x0(%esi),%esi

801082d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801082d0:	f3 0f 1e fb          	endbr32 
801082d4:	55                   	push   %ebp
801082d5:	89 e5                	mov    %esp,%ebp
801082d7:	57                   	push   %edi
801082d8:	56                   	push   %esi
801082d9:	53                   	push   %ebx
801082da:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801082dd:	e8 1e ff ff ff       	call   80108200 <setupkvm>
801082e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801082e5:	85 c0                	test   %eax,%eax
801082e7:	0f 84 9b 00 00 00    	je     80108388 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801082ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801082f0:	85 c9                	test   %ecx,%ecx
801082f2:	0f 84 90 00 00 00    	je     80108388 <copyuvm+0xb8>
801082f8:	31 f6                	xor    %esi,%esi
801082fa:	eb 46                	jmp    80108342 <copyuvm+0x72>
801082fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108300:	83 ec 04             	sub    $0x4,%esp
80108303:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108309:	68 00 10 00 00       	push   $0x1000
8010830e:	57                   	push   %edi
8010830f:	50                   	push   %eax
80108310:	e8 8b d5 ff ff       	call   801058a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108315:	58                   	pop    %eax
80108316:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010831c:	5a                   	pop    %edx
8010831d:	ff 75 e4             	pushl  -0x1c(%ebp)
80108320:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108325:	89 f2                	mov    %esi,%edx
80108327:	50                   	push   %eax
80108328:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010832b:	e8 a0 f8 ff ff       	call   80107bd0 <mappages>
80108330:	83 c4 10             	add    $0x10,%esp
80108333:	85 c0                	test   %eax,%eax
80108335:	78 61                	js     80108398 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108337:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010833d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108340:	76 46                	jbe    80108388 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108342:	8b 45 08             	mov    0x8(%ebp),%eax
80108345:	31 c9                	xor    %ecx,%ecx
80108347:	89 f2                	mov    %esi,%edx
80108349:	e8 02 f8 ff ff       	call   80107b50 <walkpgdir>
8010834e:	85 c0                	test   %eax,%eax
80108350:	74 61                	je     801083b3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80108352:	8b 00                	mov    (%eax),%eax
80108354:	a8 01                	test   $0x1,%al
80108356:	74 4e                	je     801083a6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80108358:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010835a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010835f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80108362:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108368:	e8 33 a6 ff ff       	call   801029a0 <kalloc>
8010836d:	89 c3                	mov    %eax,%ebx
8010836f:	85 c0                	test   %eax,%eax
80108371:	75 8d                	jne    80108300 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80108373:	83 ec 0c             	sub    $0xc,%esp
80108376:	ff 75 e0             	pushl  -0x20(%ebp)
80108379:	e8 02 fe ff ff       	call   80108180 <freevm>
  return 0;
8010837e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108385:	83 c4 10             	add    $0x10,%esp
}
80108388:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010838b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010838e:	5b                   	pop    %ebx
8010838f:	5e                   	pop    %esi
80108390:	5f                   	pop    %edi
80108391:	5d                   	pop    %ebp
80108392:	c3                   	ret    
80108393:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108397:	90                   	nop
      kfree(mem);
80108398:	83 ec 0c             	sub    $0xc,%esp
8010839b:	53                   	push   %ebx
8010839c:	e8 3f a4 ff ff       	call   801027e0 <kfree>
      goto bad;
801083a1:	83 c4 10             	add    $0x10,%esp
801083a4:	eb cd                	jmp    80108373 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801083a6:	83 ec 0c             	sub    $0xc,%esp
801083a9:	68 6e 90 10 80       	push   $0x8010906e
801083ae:	e8 dd 7f ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801083b3:	83 ec 0c             	sub    $0xc,%esp
801083b6:	68 54 90 10 80       	push   $0x80109054
801083bb:	e8 d0 7f ff ff       	call   80100390 <panic>

801083c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801083c0:	f3 0f 1e fb          	endbr32 
801083c4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801083c5:	31 c9                	xor    %ecx,%ecx
{
801083c7:	89 e5                	mov    %esp,%ebp
801083c9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801083cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801083cf:	8b 45 08             	mov    0x8(%ebp),%eax
801083d2:	e8 79 f7 ff ff       	call   80107b50 <walkpgdir>
  if((*pte & PTE_P) == 0)
801083d7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801083d9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801083da:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801083dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801083e1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801083e4:	05 00 00 00 80       	add    $0x80000000,%eax
801083e9:	83 fa 05             	cmp    $0x5,%edx
801083ec:	ba 00 00 00 00       	mov    $0x0,%edx
801083f1:	0f 45 c2             	cmovne %edx,%eax
}
801083f4:	c3                   	ret    
801083f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108400 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108400:	f3 0f 1e fb          	endbr32 
80108404:	55                   	push   %ebp
80108405:	89 e5                	mov    %esp,%ebp
80108407:	57                   	push   %edi
80108408:	56                   	push   %esi
80108409:	53                   	push   %ebx
8010840a:	83 ec 0c             	sub    $0xc,%esp
8010840d:	8b 75 14             	mov    0x14(%ebp),%esi
80108410:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108413:	85 f6                	test   %esi,%esi
80108415:	75 3c                	jne    80108453 <copyout+0x53>
80108417:	eb 67                	jmp    80108480 <copyout+0x80>
80108419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108420:	8b 55 0c             	mov    0xc(%ebp),%edx
80108423:	89 fb                	mov    %edi,%ebx
80108425:	29 d3                	sub    %edx,%ebx
80108427:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010842d:	39 f3                	cmp    %esi,%ebx
8010842f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108432:	29 fa                	sub    %edi,%edx
80108434:	83 ec 04             	sub    $0x4,%esp
80108437:	01 c2                	add    %eax,%edx
80108439:	53                   	push   %ebx
8010843a:	ff 75 10             	pushl  0x10(%ebp)
8010843d:	52                   	push   %edx
8010843e:	e8 5d d4 ff ff       	call   801058a0 <memmove>
    len -= n;
    buf += n;
80108443:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108446:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010844c:	83 c4 10             	add    $0x10,%esp
8010844f:	29 de                	sub    %ebx,%esi
80108451:	74 2d                	je     80108480 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108453:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108455:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108458:	89 55 0c             	mov    %edx,0xc(%ebp)
8010845b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108461:	57                   	push   %edi
80108462:	ff 75 08             	pushl  0x8(%ebp)
80108465:	e8 56 ff ff ff       	call   801083c0 <uva2ka>
    if(pa0 == 0)
8010846a:	83 c4 10             	add    $0x10,%esp
8010846d:	85 c0                	test   %eax,%eax
8010846f:	75 af                	jne    80108420 <copyout+0x20>
  }
  return 0;
}
80108471:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108474:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108479:	5b                   	pop    %ebx
8010847a:	5e                   	pop    %esi
8010847b:	5f                   	pop    %edi
8010847c:	5d                   	pop    %ebp
8010847d:	c3                   	ret    
8010847e:	66 90                	xchg   %ax,%ax
80108480:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108483:	31 c0                	xor    %eax,%eax
}
80108485:	5b                   	pop    %ebx
80108486:	5e                   	pop    %esi
80108487:	5f                   	pop    %edi
80108488:	5d                   	pop    %ebp
80108489:	c3                   	ret    
