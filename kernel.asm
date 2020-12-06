
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
80100028:	bc 40 c6 10 80       	mov    $0x8010c640,%esp

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
80100048:	bb 74 c6 10 80       	mov    $0x8010c674,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 c0 81 10 80       	push   $0x801081c0
80100055:	68 40 c6 10 80       	push   $0x8010c640
8010005a:	e8 41 52 00 00       	call   801052a0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 3c 0d 11 80       	mov    $0x80110d3c,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 8c 0d 11 80 3c 	movl   $0x80110d3c,0x80110d8c
8010006e:	0d 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 90 0d 11 80 3c 	movl   $0x80110d3c,0x80110d90
80100078:	0d 11 80 
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
8010008b:	c7 43 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 81 10 80       	push   $0x801081c7
80100097:	50                   	push   %eax
80100098:	e8 c3 50 00 00       	call   80105160 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 90 0d 11 80       	mov    0x80110d90,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 90 0d 11 80    	mov    %ebx,0x80110d90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb e0 0a 11 80    	cmp    $0x80110ae0,%ebx
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
801000e3:	68 40 c6 10 80       	push   $0x8010c640
801000e8:	e8 33 53 00 00       	call   80105420 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 90 0d 11 80    	mov    0x80110d90,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
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
80100120:	8b 1d 8c 0d 11 80    	mov    0x80110d8c,%ebx
80100126:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
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
8010015d:	68 40 c6 10 80       	push   $0x8010c640
80100162:	e8 79 53 00 00       	call   801054e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 50 00 00       	call   801051a0 <acquiresleep>
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
801001a3:	68 ce 81 10 80       	push   $0x801081ce
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
801001c2:	e8 79 50 00 00       	call   80105240 <holdingsleep>
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
801001e0:	68 df 81 10 80       	push   $0x801081df
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
80100203:	e8 38 50 00 00       	call   80105240 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 e8 4f 00 00       	call   80105200 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010021f:	e8 fc 51 00 00       	call   80105420 <acquire>
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
80100246:	a1 90 0d 11 80       	mov    0x80110d90,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 90 0d 11 80       	mov    0x80110d90,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 90 0d 11 80    	mov    %ebx,0x80110d90
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 40 c6 10 80 	movl   $0x8010c640,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 6b 52 00 00       	jmp    801054e0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 81 10 80       	push   $0x801081e6
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
801002aa:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801002b1:	e8 6a 51 00 00       	call   80105420 <acquire>
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
801002c6:	a1 c0 10 11 80       	mov    0x801110c0,%eax
801002cb:	3b 05 c4 10 11 80    	cmp    0x801110c4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 a0 b5 10 80       	push   $0x8010b5a0
801002e0:	68 c0 10 11 80       	push   $0x801110c0
801002e5:	e8 d6 4a 00 00       	call   80104dc0 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 10 11 80       	mov    0x801110c0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 10 11 80    	cmp    0x801110c4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 a1 3a 00 00       	call   80103da0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 a0 b5 10 80       	push   $0x8010b5a0
8010030e:	e8 cd 51 00 00       	call   801054e0 <release>
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
80100333:	89 15 c0 10 11 80    	mov    %edx,0x801110c0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 10 11 80 	movsbl -0x7feeefc0(%edx),%ecx
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
80100360:	68 a0 b5 10 80       	push   $0x8010b5a0
80100365:	e8 76 51 00 00       	call   801054e0 <release>
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
80100386:	a3 c0 10 11 80       	mov    %eax,0x801110c0
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
8010039d:	c7 05 d4 b5 10 80 00 	movl   $0x0,0x8010b5d4
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 5e 28 00 00       	call   80102c10 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ed 81 10 80       	push   $0x801081ed
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 97 8c 10 80 	movl   $0x80108c97,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 df 4e 00 00       	call   801052c0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 01 82 10 80       	push   $0x80108201
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 d8 b5 10 80 01 	movl   $0x1,0x8010b5d8
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
8010042a:	e8 91 69 00 00       	call   80106dc0 <uartputc>
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
80100515:	e8 a6 68 00 00       	call   80106dc0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 9a 68 00 00       	call   80106dc0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 8e 68 00 00       	call   80106dc0 <uartputc>
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
80100561:	e8 6a 50 00 00       	call   801055d0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 b5 4f 00 00       	call   80105530 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 82 10 80       	push   $0x80108205
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
801005c9:	0f b6 92 94 82 10 80 	movzbl -0x7fef7d6c(%edx),%edx
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
80100603:	8b 15 d8 b5 10 80    	mov    0x8010b5d8,%edx
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
80100658:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
8010065f:	e8 bc 4d 00 00       	call   80105420 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 d8 b5 10 80    	mov    0x8010b5d8,%edx
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
80100692:	68 a0 b5 10 80       	push   $0x8010b5a0
80100697:	e8 44 4e 00 00       	call   801054e0 <release>
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
801006bd:	a1 d4 b5 10 80       	mov    0x8010b5d4,%eax
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
801006ec:	8b 0d d8 b5 10 80    	mov    0x8010b5d8,%ecx
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
8010077d:	bb 18 82 10 80       	mov    $0x80108218,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 d8 b5 10 80    	mov    0x8010b5d8,%edx
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
801007b8:	68 a0 b5 10 80       	push   $0x8010b5a0
801007bd:	e8 5e 4c 00 00       	call   80105420 <acquire>
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
801007e0:	8b 3d d8 b5 10 80    	mov    0x8010b5d8,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d d8 b5 10 80    	mov    0x8010b5d8,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 d8 b5 10 80    	mov    0x8010b5d8,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 a0 b5 10 80       	push   $0x8010b5a0
80100828:	e8 b3 4c 00 00       	call   801054e0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 82 10 80       	push   $0x8010821f
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
80100864:	a1 c8 10 11 80       	mov    0x801110c8,%eax
80100869:	3b 05 c4 10 11 80    	cmp    0x801110c4,%eax
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
8010087f:	80 ba 40 10 11 80 0a 	cmpb   $0xa,-0x7feeefc0(%edx)
80100886:	74 2f                	je     801008b7 <kill_line+0x57>
    input.e--;
80100888:	a3 c8 10 11 80       	mov    %eax,0x801110c8
  if(panicked){
8010088d:	a1 d8 b5 10 80       	mov    0x8010b5d8,%eax
80100892:	85 c0                	test   %eax,%eax
80100894:	74 0a                	je     801008a0 <kill_line+0x40>
80100896:	fa                   	cli    
    for(;;)
80100897:	eb fe                	jmp    80100897 <kill_line+0x37>
80100899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008a0:	b8 00 01 00 00       	mov    $0x100,%eax
801008a5:	e8 66 fb ff ff       	call   80100410 <consputc.part.0>
  while(input.e != input.w &&
801008aa:	a1 c8 10 11 80       	mov    0x801110c8,%eax
801008af:	3b 05 c4 10 11 80    	cmp    0x801110c4,%eax
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
801008c5:	a1 c8 10 11 80       	mov    0x801110c8,%eax
{
801008ca:	89 e5                	mov    %esp,%ebp
801008cc:	57                   	push   %edi
801008cd:	56                   	push   %esi
801008ce:	8b 35 c4 10 11 80    	mov    0x801110c4,%esi
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
801008f3:	80 ba 40 10 11 80 0a 	cmpb   $0xa,-0x7feeefc0(%edx)
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
80100924:	a1 c8 10 11 80       	mov    0x801110c8,%eax
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
80100929:	8b 0d 20 10 11 80    	mov    0x80111020,%ecx
{
8010092f:	55                   	push   %ebp
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
80100930:	29 c1                	sub    %eax,%ecx
{
80100932:	89 e5                	mov    %esp,%ebp
80100934:	56                   	push   %esi
80100935:	53                   	push   %ebx
  while(temp_e != input.w &&
80100936:	8b 1d c4 10 11 80    	mov    0x801110c4,%ebx
8010093c:	39 d8                	cmp    %ebx,%eax
8010093e:	75 13                	jne    80100953 <fill_clipboard_buf+0x33>
80100940:	eb 30                	jmp    80100972 <fill_clipboard_buf+0x52>
80100942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
80100948:	88 94 01 a0 0f 11 80 	mov    %dl,-0x7feef060(%ecx,%eax,1)
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
80100966:	0f b6 92 40 10 11 80 	movzbl -0x7feeefc0(%edx),%edx
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
8010098d:	8b 35 c8 10 11 80    	mov    0x801110c8,%esi
  while(temp_e != input.w &&
80100993:	8b 1d c4 10 11 80    	mov    0x801110c4,%ebx
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
801009b3:	80 b8 40 10 11 80 0a 	cmpb   $0xa,-0x7feeefc0(%eax)
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
801009ce:	68 a0 0f 11 80       	push   $0x80110fa0
  return start - temp_e;
801009d3:	89 35 20 10 11 80    	mov    %esi,0x80111020
  memset(clipboard.buf, 0, INPUT_BUF);
801009d9:	e8 52 4b 00 00       	call   80105530 <memset>
  int temp_e = input.e, buf_idx = clipboard.size - 1;
801009de:	a1 c8 10 11 80       	mov    0x801110c8,%eax
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
801009e3:	8b 0d 20 10 11 80    	mov    0x80111020,%ecx
  while(temp_e != input.w &&
801009e9:	83 c4 10             	add    $0x10,%esp
801009ec:	8b 1d c4 10 11 80    	mov    0x801110c4,%ebx
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
801009f2:	29 c1                	sub    %eax,%ecx
  while(temp_e != input.w &&
801009f4:	39 d8                	cmp    %ebx,%eax
801009f6:	75 13                	jne    80100a0b <copy_line+0x8b>
801009f8:	eb 30                	jmp    80100a2a <copy_line+0xaa>
801009fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    clipboard.buf[buf_idx] = input.buf[(temp_e-1) % INPUT_BUF];
80100a00:	88 94 01 a0 0f 11 80 	mov    %dl,-0x7feef060(%ecx,%eax,1)
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
80100a1e:	0f b6 92 40 10 11 80 	movzbl -0x7feeefc0(%edx),%edx
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
80100a52:	a1 c8 10 11 80       	mov    0x801110c8,%eax
80100a57:	89 c2                	mov    %eax,%edx
80100a59:	2b 15 c0 10 11 80    	sub    0x801110c0,%edx
80100a5f:	83 fa 7f             	cmp    $0x7f,%edx
80100a62:	77 43                	ja     80100aa7 <handle_ordinary_char+0x67>
    c = (c == '\r') ? '\n' : c;
80100a64:	8d 48 01             	lea    0x1(%eax),%ecx
80100a67:	8b 15 d8 b5 10 80    	mov    0x8010b5d8,%edx
80100a6d:	83 e0 7f             	and    $0x7f,%eax
    input.buf[input.e++ % INPUT_BUF] = c;
80100a70:	89 0d c8 10 11 80    	mov    %ecx,0x801110c8
    c = (c == '\r') ? '\n' : c;
80100a76:	80 fb 0d             	cmp    $0xd,%bl
80100a79:	74 32                	je     80100aad <handle_ordinary_char+0x6d>
    input.buf[input.e++ % INPUT_BUF] = c;
80100a7b:	88 98 40 10 11 80    	mov    %bl,-0x7feeefc0(%eax)
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
80100a97:	a1 c0 10 11 80       	mov    0x801110c0,%eax
80100a9c:	83 e8 80             	sub    $0xffffff80,%eax
80100a9f:	39 05 c8 10 11 80    	cmp    %eax,0x801110c8
80100aa5:	74 28                	je     80100acf <handle_ordinary_char+0x8f>
}
80100aa7:	83 c4 04             	add    $0x4,%esp
80100aaa:	5b                   	pop    %ebx
80100aab:	5d                   	pop    %ebp
80100aac:	c3                   	ret    
    input.buf[input.e++ % INPUT_BUF] = c;
80100aad:	c6 80 40 10 11 80 0a 	movb   $0xa,-0x7feeefc0(%eax)
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
80100aca:	a1 c8 10 11 80       	mov    0x801110c8,%eax
      wakeup(&input.r);
80100acf:	c7 45 08 c0 10 11 80 	movl   $0x801110c0,0x8(%ebp)
      input.w = input.e;
80100ad6:	a3 c4 10 11 80       	mov    %eax,0x801110c4
}
80100adb:	83 c4 04             	add    $0x4,%esp
80100ade:	5b                   	pop    %ebx
80100adf:	5d                   	pop    %ebp
      wakeup(&input.r);
80100ae0:	e9 9b 44 00 00       	jmp    80104f80 <wakeup>
80100ae5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100af0 <paste_line>:
{
80100af0:	f3 0f 1e fb          	endbr32 
  for(int i=0; i<clipboard.size; i++){
80100af4:	a1 20 10 11 80       	mov    0x80111020,%eax
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
80100b10:	0f be 83 a0 0f 11 80 	movsbl -0x7feef060(%ebx),%eax
80100b17:	83 ec 0c             	sub    $0xc,%esp
  for(int i=0; i<clipboard.size; i++){
80100b1a:	83 c3 01             	add    $0x1,%ebx
    handle_ordinary_char(c);
80100b1d:	50                   	push   %eax
80100b1e:	e8 1d ff ff ff       	call   80100a40 <handle_ordinary_char>
  for(int i=0; i<clipboard.size; i++){
80100b23:	83 c4 10             	add    $0x10,%esp
80100b26:	39 1d 20 10 11 80    	cmp    %ebx,0x80111020
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
80100b52:	68 a0 b5 10 80       	push   $0x8010b5a0
80100b57:	e8 c4 48 00 00       	call   80105420 <acquire>
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
80100b82:	3e ff 24 9d 30 82 10 	notrack jmp *-0x7fef7dd0(,%ebx,4)
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
80100b9a:	68 a0 b5 10 80       	push   $0x8010b5a0
80100b9f:	e8 3c 49 00 00       	call   801054e0 <release>
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
80100bc1:	a1 c8 10 11 80       	mov    0x801110c8,%eax
80100bc6:	3b 05 c4 10 11 80    	cmp    0x801110c4,%eax
80100bcc:	74 91                	je     80100b5f <consoleintr+0x1f>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100bce:	83 e8 01             	sub    $0x1,%eax
80100bd1:	89 c2                	mov    %eax,%edx
80100bd3:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100bd6:	80 ba 40 10 11 80 0a 	cmpb   $0xa,-0x7feeefc0(%edx)
80100bdd:	74 80                	je     80100b5f <consoleintr+0x1f>
  if(panicked){
80100bdf:	8b 0d d8 b5 10 80    	mov    0x8010b5d8,%ecx
        input.e--;
80100be5:	a3 c8 10 11 80       	mov    %eax,0x801110c8
  if(panicked){
80100bea:	85 c9                	test   %ecx,%ecx
80100bec:	74 c9                	je     80100bb7 <consoleintr+0x77>
80100bee:	fa                   	cli    
    for(;;)
80100bef:	eb fe                	jmp    80100bef <consoleintr+0xaf>
      cons.locking = 0;
80100bf1:	c7 05 d4 b5 10 80 00 	movl   $0x0,0x8010b5d4
80100bf8:	00 00 00 
      cprintf("%s",input.buf);
80100bfb:	83 ec 08             	sub    $0x8,%esp
80100bfe:	68 40 10 11 80       	push   $0x80111040
80100c03:	68 70 88 10 80       	push   $0x80108870
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
80100c24:	a1 20 10 11 80       	mov    0x80111020,%eax
80100c29:	31 db                	xor    %ebx,%ebx
80100c2b:	85 c0                	test   %eax,%eax
80100c2d:	0f 8e 2c ff ff ff    	jle    80100b5f <consoleintr+0x1f>
    handle_ordinary_char(c);
80100c33:	0f be 83 a0 0f 11 80 	movsbl -0x7feef060(%ebx),%eax
80100c3a:	83 ec 0c             	sub    $0xc,%esp
  for(int i=0; i<clipboard.size; i++){
80100c3d:	83 c3 01             	add    $0x1,%ebx
    handle_ordinary_char(c);
80100c40:	50                   	push   %eax
80100c41:	e8 fa fd ff ff       	call   80100a40 <handle_ordinary_char>
  for(int i=0; i<clipboard.size; i++){
80100c46:	83 c4 10             	add    $0x10,%esp
80100c49:	3b 1d 20 10 11 80    	cmp    0x80111020,%ebx
80100c4f:	7c e2                	jl     80100c33 <consoleintr+0xf3>
80100c51:	e9 09 ff ff ff       	jmp    80100b5f <consoleintr+0x1f>
      if(input.e != input.w){
80100c56:	a1 c8 10 11 80       	mov    0x801110c8,%eax
80100c5b:	3b 05 c4 10 11 80    	cmp    0x801110c4,%eax
80100c61:	0f 84 f8 fe ff ff    	je     80100b5f <consoleintr+0x1f>
  if(panicked){
80100c67:	8b 15 d8 b5 10 80    	mov    0x8010b5d8,%edx
        input.e--;
80100c6d:	83 e8 01             	sub    $0x1,%eax
80100c70:	a3 c8 10 11 80       	mov    %eax,0x801110c8
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
80100c8f:	a1 20 10 11 80       	mov    0x80111020,%eax
80100c94:	85 c0                	test   %eax,%eax
80100c96:	0f 8e c3 fe ff ff    	jle    80100b5f <consoleintr+0x1f>
80100c9c:	31 db                	xor    %ebx,%ebx
    handle_ordinary_char(c);
80100c9e:	0f be 83 a0 0f 11 80 	movsbl -0x7feef060(%ebx),%eax
80100ca5:	83 ec 0c             	sub    $0xc,%esp
  for(int i=0; i<clipboard.size; i++){
80100ca8:	83 c3 01             	add    $0x1,%ebx
    handle_ordinary_char(c);
80100cab:	50                   	push   %eax
80100cac:	e8 8f fd ff ff       	call   80100a40 <handle_ordinary_char>
  for(int i=0; i<clipboard.size; i++){
80100cb1:	83 c4 10             	add    $0x10,%esp
80100cb4:	3b 1d 20 10 11 80    	cmp    0x80111020,%ebx
80100cba:	7c e2                	jl     80100c9e <consoleintr+0x15e>
80100cbc:	e9 9e fe ff ff       	jmp    80100b5f <consoleintr+0x1f>
    switch(c){
80100cc1:	83 fb 7f             	cmp    $0x7f,%ebx
80100cc4:	74 90                	je     80100c56 <consoleintr+0x116>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100cc6:	a1 c8 10 11 80       	mov    0x801110c8,%eax
80100ccb:	89 c2                	mov    %eax,%edx
80100ccd:	2b 15 c0 10 11 80    	sub    0x801110c0,%edx
80100cd3:	83 fa 7f             	cmp    $0x7f,%edx
80100cd6:	0f 87 83 fe ff ff    	ja     80100b5f <consoleintr+0x1f>
        c = (c == '\r') ? '\n' : c;
80100cdc:	8d 48 01             	lea    0x1(%eax),%ecx
80100cdf:	8b 15 d8 b5 10 80    	mov    0x8010b5d8,%edx
80100ce5:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100ce8:	89 0d c8 10 11 80    	mov    %ecx,0x801110c8
        c = (c == '\r') ? '\n' : c;
80100cee:	83 fb 0d             	cmp    $0xd,%ebx
80100cf1:	74 58                	je     80100d4b <consoleintr+0x20b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100cf3:	88 98 40 10 11 80    	mov    %bl,-0x7feeefc0(%eax)
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
80100d0e:	a1 c0 10 11 80       	mov    0x801110c0,%eax
80100d13:	83 e8 80             	sub    $0xffffff80,%eax
80100d16:	39 05 c8 10 11 80    	cmp    %eax,0x801110c8
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
80100d46:	e9 35 43 00 00       	jmp    80105080 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d4b:	c6 80 40 10 11 80 0a 	movb   $0xa,-0x7feeefc0(%eax)
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
80100d6a:	a1 c8 10 11 80       	mov    0x801110c8,%eax
          wakeup(&input.r);
80100d6f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100d72:	a3 c4 10 11 80       	mov    %eax,0x801110c4
          wakeup(&input.r);
80100d77:	68 c0 10 11 80       	push   $0x801110c0
80100d7c:	e8 ff 41 00 00       	call   80104f80 <wakeup>
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
80100d9a:	68 28 82 10 80       	push   $0x80108228
80100d9f:	68 a0 b5 10 80       	push   $0x8010b5a0
80100da4:	e8 f7 44 00 00       	call   801052a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100da9:	58                   	pop    %eax
80100daa:	5a                   	pop    %edx
80100dab:	6a 00                	push   $0x0
80100dad:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100daf:	c7 05 8c 1a 11 80 40 	movl   $0x80100640,0x80111a8c
80100db6:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100db9:	c7 05 88 1a 11 80 90 	movl   $0x80100290,0x80111a88
80100dc0:	02 10 80 
  cons.locking = 1;
80100dc3:	c7 05 d4 b5 10 80 01 	movl   $0x1,0x8010b5d4
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
80100e74:	e8 b7 70 00 00       	call   80107f30 <setupkvm>
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
80100ee3:	e8 68 6e 00 00       	call   80107d50 <allocuvm>
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
80100f19:	e8 62 6d 00 00       	call   80107c80 <loaduvm>
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
80100f5b:	e8 50 6f 00 00       	call   80107eb0 <freevm>
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
80100fa2:	e8 a9 6d 00 00       	call   80107d50 <allocuvm>
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
80100fc3:	e8 08 70 00 00       	call   80107fd0 <clearpteu>
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
80101013:	e8 18 47 00 00       	call   80105730 <strlen>
80101018:	f7 d0                	not    %eax
8010101a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010101c:	58                   	pop    %eax
8010101d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101020:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101023:	ff 34 b8             	pushl  (%eax,%edi,4)
80101026:	e8 05 47 00 00       	call   80105730 <strlen>
8010102b:	83 c0 01             	add    $0x1,%eax
8010102e:	50                   	push   %eax
8010102f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101032:	ff 34 b8             	pushl  (%eax,%edi,4)
80101035:	53                   	push   %ebx
80101036:	56                   	push   %esi
80101037:	e8 f4 70 00 00       	call   80108130 <copyout>
8010103c:	83 c4 20             	add    $0x20,%esp
8010103f:	85 c0                	test   %eax,%eax
80101041:	79 ad                	jns    80100ff0 <exec+0x210>
80101043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101047:	90                   	nop
    freevm(pgdir);
80101048:	83 ec 0c             	sub    $0xc,%esp
8010104b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101051:	e8 5a 6e 00 00       	call   80107eb0 <freevm>
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
801010a3:	e8 88 70 00 00       	call   80108130 <copyout>
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
801010e1:	e8 0a 46 00 00       	call   801056f0 <safestrcpy>
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
8010110d:	e8 de 69 00 00       	call   80107af0 <switchuvm>
  freevm(oldpgdir);
80101112:	89 3c 24             	mov    %edi,(%esp)
80101115:	e8 96 6d 00 00       	call   80107eb0 <freevm>
  return 0;
8010111a:	83 c4 10             	add    $0x10,%esp
8010111d:	31 c0                	xor    %eax,%eax
8010111f:	e9 36 fd ff ff       	jmp    80100e5a <exec+0x7a>
    end_op();
80101124:	e8 e7 1f 00 00       	call   80103110 <end_op>
    cprintf("exec: fail\n");
80101129:	83 ec 0c             	sub    $0xc,%esp
8010112c:	68 a5 82 10 80       	push   $0x801082a5
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
8010115a:	68 b1 82 10 80       	push   $0x801082b1
8010115f:	68 e0 10 11 80       	push   $0x801110e0
80101164:	e8 37 41 00 00       	call   801052a0 <initlock>
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
80101178:	bb 14 11 11 80       	mov    $0x80111114,%ebx
{
8010117d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101180:	68 e0 10 11 80       	push   $0x801110e0
80101185:	e8 96 42 00 00       	call   80105420 <acquire>
8010118a:	83 c4 10             	add    $0x10,%esp
8010118d:	eb 0c                	jmp    8010119b <filealloc+0x2b>
8010118f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101190:	83 c3 18             	add    $0x18,%ebx
80101193:	81 fb 74 1a 11 80    	cmp    $0x80111a74,%ebx
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
801011ac:	68 e0 10 11 80       	push   $0x801110e0
801011b1:	e8 2a 43 00 00       	call   801054e0 <release>
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
801011c5:	68 e0 10 11 80       	push   $0x801110e0
801011ca:	e8 11 43 00 00       	call   801054e0 <release>
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
801011ee:	68 e0 10 11 80       	push   $0x801110e0
801011f3:	e8 28 42 00 00       	call   80105420 <acquire>
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
8010120b:	68 e0 10 11 80       	push   $0x801110e0
80101210:	e8 cb 42 00 00       	call   801054e0 <release>
  return f;
}
80101215:	89 d8                	mov    %ebx,%eax
80101217:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010121a:	c9                   	leave  
8010121b:	c3                   	ret    
    panic("filedup");
8010121c:	83 ec 0c             	sub    $0xc,%esp
8010121f:	68 b8 82 10 80       	push   $0x801082b8
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
80101240:	68 e0 10 11 80       	push   $0x801110e0
80101245:	e8 d6 41 00 00       	call   80105420 <acquire>
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
80101278:	68 e0 10 11 80       	push   $0x801110e0
  ff = *f;
8010127d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101280:	e8 5b 42 00 00       	call   801054e0 <release>

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
801012a0:	c7 45 08 e0 10 11 80 	movl   $0x801110e0,0x8(%ebp)
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	5b                   	pop    %ebx
801012ab:	5e                   	pop    %esi
801012ac:	5f                   	pop    %edi
801012ad:	5d                   	pop    %ebp
    release(&ftable.lock);
801012ae:	e9 2d 42 00 00       	jmp    801054e0 <release>
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
801012fc:	68 c0 82 10 80       	push   $0x801082c0
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
801013ea:	68 ca 82 10 80       	push   $0x801082ca
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
801014d3:	68 d3 82 10 80       	push   $0x801082d3
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
80101509:	68 d9 82 10 80       	push   $0x801082d9
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
80101528:	03 05 f8 1a 11 80    	add    0x80111af8,%eax
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
80101587:	68 e3 82 10 80       	push   $0x801082e3
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
801015a9:	8b 0d e0 1a 11 80    	mov    0x80111ae0,%ecx
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
801015cc:	03 05 f8 1a 11 80    	add    0x80111af8,%eax
801015d2:	50                   	push   %eax
801015d3:	ff 75 d8             	pushl  -0x28(%ebp)
801015d6:	e8 f5 ea ff ff       	call   801000d0 <bread>
801015db:	83 c4 10             	add    $0x10,%esp
801015de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015e1:	a1 e0 1a 11 80       	mov    0x80111ae0,%eax
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
80101639:	39 05 e0 1a 11 80    	cmp    %eax,0x80111ae0
8010163f:	77 80                	ja     801015c1 <balloc+0x21>
  panic("balloc: out of blocks");
80101641:	83 ec 0c             	sub    $0xc,%esp
80101644:	68 f6 82 10 80       	push   $0x801082f6
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
80101685:	e8 a6 3e 00 00       	call   80105530 <memset>
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
801016ba:	bb 34 1b 11 80       	mov    $0x80111b34,%ebx
{
801016bf:	83 ec 28             	sub    $0x28,%esp
801016c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801016c5:	68 00 1b 11 80       	push   $0x80111b00
801016ca:	e8 51 3d 00 00       	call   80105420 <acquire>
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
801016ea:	81 fb 54 37 11 80    	cmp    $0x80113754,%ebx
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
8010170b:	81 fb 54 37 11 80    	cmp    $0x80113754,%ebx
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
80101732:	68 00 1b 11 80       	push   $0x80111b00
80101737:	e8 a4 3d 00 00       	call   801054e0 <release>

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
8010175d:	68 00 1b 11 80       	push   $0x80111b00
      ip->ref++;
80101762:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101765:	e8 76 3d 00 00       	call   801054e0 <release>
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
80101777:	81 fb 54 37 11 80    	cmp    $0x80113754,%ebx
8010177d:	73 10                	jae    8010178f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010177f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101782:	85 c9                	test   %ecx,%ecx
80101784:	0f 8f 56 ff ff ff    	jg     801016e0 <iget+0x30>
8010178a:	e9 6e ff ff ff       	jmp    801016fd <iget+0x4d>
    panic("iget: no inodes");
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	68 0c 83 10 80       	push   $0x8010830c
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
8010185b:	68 1c 83 10 80       	push   $0x8010831c
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
80101895:	e8 36 3d 00 00       	call   801055d0 <memmove>
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
801018b8:	bb 40 1b 11 80       	mov    $0x80111b40,%ebx
801018bd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801018c0:	68 2f 83 10 80       	push   $0x8010832f
801018c5:	68 00 1b 11 80       	push   $0x80111b00
801018ca:	e8 d1 39 00 00       	call   801052a0 <initlock>
  for(i = 0; i < NINODE; i++) {
801018cf:	83 c4 10             	add    $0x10,%esp
801018d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801018d8:	83 ec 08             	sub    $0x8,%esp
801018db:	68 36 83 10 80       	push   $0x80108336
801018e0:	53                   	push   %ebx
801018e1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018e7:	e8 74 38 00 00       	call   80105160 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801018ec:	83 c4 10             	add    $0x10,%esp
801018ef:	81 fb 60 37 11 80    	cmp    $0x80113760,%ebx
801018f5:	75 e1                	jne    801018d8 <iinit+0x28>
  readsb(dev, &sb);
801018f7:	83 ec 08             	sub    $0x8,%esp
801018fa:	68 e0 1a 11 80       	push   $0x80111ae0
801018ff:	ff 75 08             	pushl  0x8(%ebp)
80101902:	e8 69 ff ff ff       	call   80101870 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101907:	ff 35 f8 1a 11 80    	pushl  0x80111af8
8010190d:	ff 35 f4 1a 11 80    	pushl  0x80111af4
80101913:	ff 35 f0 1a 11 80    	pushl  0x80111af0
80101919:	ff 35 ec 1a 11 80    	pushl  0x80111aec
8010191f:	ff 35 e8 1a 11 80    	pushl  0x80111ae8
80101925:	ff 35 e4 1a 11 80    	pushl  0x80111ae4
8010192b:	ff 35 e0 1a 11 80    	pushl  0x80111ae0
80101931:	68 9c 83 10 80       	push   $0x8010839c
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
80101960:	83 3d e8 1a 11 80 01 	cmpl   $0x1,0x80111ae8
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
8010198f:	3b 3d e8 1a 11 80    	cmp    0x80111ae8,%edi
80101995:	73 69                	jae    80101a00 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101997:	89 f8                	mov    %edi,%eax
80101999:	83 ec 08             	sub    $0x8,%esp
8010199c:	c1 e8 03             	shr    $0x3,%eax
8010199f:	03 05 f4 1a 11 80    	add    0x80111af4,%eax
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
801019ce:	e8 5d 3b 00 00       	call   80105530 <memset>
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
80101a03:	68 3c 83 10 80       	push   $0x8010833c
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
80101a28:	03 05 f4 1a 11 80    	add    0x80111af4,%eax
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
80101a75:	e8 56 3b 00 00       	call   801055d0 <memmove>
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
80101aae:	68 00 1b 11 80       	push   $0x80111b00
80101ab3:	e8 68 39 00 00       	call   80105420 <acquire>
  ip->ref++;
80101ab8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101abc:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
80101ac3:	e8 18 3a 00 00       	call   801054e0 <release>
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
80101af6:	e8 a5 36 00 00       	call   801051a0 <acquiresleep>
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
80101b19:	03 05 f4 1a 11 80    	add    0x80111af4,%eax
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
80101b68:	e8 63 3a 00 00       	call   801055d0 <memmove>
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
80101b8d:	68 54 83 10 80       	push   $0x80108354
80101b92:	e8 f9 e7 ff ff       	call   80100390 <panic>
    panic("ilock");
80101b97:	83 ec 0c             	sub    $0xc,%esp
80101b9a:	68 4e 83 10 80       	push   $0x8010834e
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
80101bc7:	e8 74 36 00 00       	call   80105240 <holdingsleep>
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
80101be3:	e9 18 36 00 00       	jmp    80105200 <releasesleep>
    panic("iunlock");
80101be8:	83 ec 0c             	sub    $0xc,%esp
80101beb:	68 63 83 10 80       	push   $0x80108363
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
80101c14:	e8 87 35 00 00       	call   801051a0 <acquiresleep>
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
80101c2e:	e8 cd 35 00 00       	call   80105200 <releasesleep>
  acquire(&icache.lock);
80101c33:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
80101c3a:	e8 e1 37 00 00       	call   80105420 <acquire>
  ip->ref--;
80101c3f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c43:	83 c4 10             	add    $0x10,%esp
80101c46:	c7 45 08 00 1b 11 80 	movl   $0x80111b00,0x8(%ebp)
}
80101c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c50:	5b                   	pop    %ebx
80101c51:	5e                   	pop    %esi
80101c52:	5f                   	pop    %edi
80101c53:	5d                   	pop    %ebp
  release(&icache.lock);
80101c54:	e9 87 38 00 00       	jmp    801054e0 <release>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101c60:	83 ec 0c             	sub    $0xc,%esp
80101c63:	68 00 1b 11 80       	push   $0x80111b00
80101c68:	e8 b3 37 00 00       	call   80105420 <acquire>
    int r = ip->ref;
80101c6d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101c70:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
80101c77:	e8 64 38 00 00       	call   801054e0 <release>
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
80101e77:	e8 54 37 00 00       	call   801055d0 <memmove>
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
80101eaa:	8b 04 c5 80 1a 11 80 	mov    -0x7feee580(,%eax,8),%eax
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
80101f73:	e8 58 36 00 00       	call   801055d0 <memmove>
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
80101fba:	8b 04 c5 84 1a 11 80 	mov    -0x7feee57c(,%eax,8),%eax
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
80102012:	e8 29 36 00 00       	call   80105640 <strncmp>
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
80102075:	e8 c6 35 00 00       	call   80105640 <strncmp>
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
801020ba:	68 7d 83 10 80       	push   $0x8010837d
801020bf:	e8 cc e2 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
801020c4:	83 ec 0c             	sub    $0xc,%esp
801020c7:	68 6b 83 10 80       	push   $0x8010836b
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
80102107:	68 00 1b 11 80       	push   $0x80111b00
8010210c:	e8 0f 33 00 00       	call   80105420 <acquire>
  ip->ref++;
80102111:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102115:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
8010211c:	e8 bf 33 00 00       	call   801054e0 <release>
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
80102187:	e8 44 34 00 00       	call   801055d0 <memmove>
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
80102213:	e8 b8 33 00 00       	call   801055d0 <memmove>
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
80102345:	e8 46 33 00 00       	call   80105690 <strncpy>
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
80102383:	68 8c 83 10 80       	push   $0x8010838c
80102388:	e8 03 e0 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010238d:	83 ec 0c             	sub    $0xc,%esp
80102390:	68 7e 8a 10 80       	push   $0x80108a7e
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
8010249b:	68 f8 83 10 80       	push   $0x801083f8
801024a0:	e8 eb de ff ff       	call   80100390 <panic>
    panic("idestart");
801024a5:	83 ec 0c             	sub    $0xc,%esp
801024a8:	68 ef 83 10 80       	push   $0x801083ef
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
801024ca:	68 0a 84 10 80       	push   $0x8010840a
801024cf:	68 00 b6 10 80       	push   $0x8010b600
801024d4:	e8 c7 2d 00 00       	call   801052a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801024d9:	58                   	pop    %eax
801024da:	a1 20 3e 11 80       	mov    0x80113e20,%eax
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
8010252a:	c7 05 e0 b5 10 80 01 	movl   $0x1,0x8010b5e0
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
8010255d:	68 00 b6 10 80       	push   $0x8010b600
80102562:	e8 b9 2e 00 00       	call   80105420 <acquire>

  if((b = idequeue) == 0){
80102567:	8b 1d e4 b5 10 80    	mov    0x8010b5e4,%ebx
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	85 db                	test   %ebx,%ebx
80102572:	74 5f                	je     801025d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102574:	8b 43 58             	mov    0x58(%ebx),%eax
80102577:	a3 e4 b5 10 80       	mov    %eax,0x8010b5e4

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
801025bd:	e8 be 29 00 00       	call   80104f80 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801025c2:	a1 e4 b5 10 80       	mov    0x8010b5e4,%eax
801025c7:	83 c4 10             	add    $0x10,%esp
801025ca:	85 c0                	test   %eax,%eax
801025cc:	74 05                	je     801025d3 <ideintr+0x83>
    idestart(idequeue);
801025ce:	e8 0d fe ff ff       	call   801023e0 <idestart>
    release(&idelock);
801025d3:	83 ec 0c             	sub    $0xc,%esp
801025d6:	68 00 b6 10 80       	push   $0x8010b600
801025db:	e8 00 2f 00 00       	call   801054e0 <release>

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
80102602:	e8 39 2c 00 00       	call   80105240 <holdingsleep>
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
80102627:	a1 e0 b5 10 80       	mov    0x8010b5e0,%eax
8010262c:	85 c0                	test   %eax,%eax
8010262e:	0f 84 93 00 00 00    	je     801026c7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102634:	83 ec 0c             	sub    $0xc,%esp
80102637:	68 00 b6 10 80       	push   $0x8010b600
8010263c:	e8 df 2d 00 00       	call   80105420 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102641:	a1 e4 b5 10 80       	mov    0x8010b5e4,%eax
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
80102666:	39 1d e4 b5 10 80    	cmp    %ebx,0x8010b5e4
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
80102683:	68 00 b6 10 80       	push   $0x8010b600
80102688:	53                   	push   %ebx
80102689:	e8 32 27 00 00       	call   80104dc0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010268e:	8b 03                	mov    (%ebx),%eax
80102690:	83 c4 10             	add    $0x10,%esp
80102693:	83 e0 06             	and    $0x6,%eax
80102696:	83 f8 02             	cmp    $0x2,%eax
80102699:	75 e5                	jne    80102680 <iderw+0x90>
  }


  release(&idelock);
8010269b:	c7 45 08 00 b6 10 80 	movl   $0x8010b600,0x8(%ebp)
}
801026a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026a5:	c9                   	leave  
  release(&idelock);
801026a6:	e9 35 2e 00 00       	jmp    801054e0 <release>
801026ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop
    idestart(b);
801026b0:	89 d8                	mov    %ebx,%eax
801026b2:	e8 29 fd ff ff       	call   801023e0 <idestart>
801026b7:	eb b5                	jmp    8010266e <iderw+0x7e>
801026b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026c0:	ba e4 b5 10 80       	mov    $0x8010b5e4,%edx
801026c5:	eb 9d                	jmp    80102664 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801026c7:	83 ec 0c             	sub    $0xc,%esp
801026ca:	68 39 84 10 80       	push   $0x80108439
801026cf:	e8 bc dc ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801026d4:	83 ec 0c             	sub    $0xc,%esp
801026d7:	68 24 84 10 80       	push   $0x80108424
801026dc:	e8 af dc ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801026e1:	83 ec 0c             	sub    $0xc,%esp
801026e4:	68 0e 84 10 80       	push   $0x8010840e
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
801026f5:	c7 05 54 37 11 80 00 	movl   $0xfec00000,0x80113754
801026fc:	00 c0 fe 
{
801026ff:	89 e5                	mov    %esp,%ebp
80102701:	56                   	push   %esi
80102702:	53                   	push   %ebx
  ioapic->reg = reg;
80102703:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010270a:	00 00 00 
  return ioapic->data;
8010270d:	8b 15 54 37 11 80    	mov    0x80113754,%edx
80102713:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102716:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010271c:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102722:	0f b6 15 80 38 11 80 	movzbl 0x80113880,%edx
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
8010273e:	68 58 84 10 80       	push   $0x80108458
80102743:	e8 68 df ff ff       	call   801006b0 <cprintf>
80102748:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx
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
80102764:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx
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
8010277e:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx
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
801027a5:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx
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
801027b9:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027bf:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801027c2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801027c8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027ca:	a1 54 37 11 80       	mov    0x80113754,%eax
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
801027f6:	81 fb c8 8f 11 80    	cmp    $0x80118fc8,%ebx
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
80102816:	e8 15 2d 00 00       	call   80105530 <memset>

  if(kmem.use_lock)
8010281b:	8b 15 94 37 11 80    	mov    0x80113794,%edx
80102821:	83 c4 10             	add    $0x10,%esp
80102824:	85 d2                	test   %edx,%edx
80102826:	75 20                	jne    80102848 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102828:	a1 98 37 11 80       	mov    0x80113798,%eax
8010282d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010282f:	a1 94 37 11 80       	mov    0x80113794,%eax
  kmem.freelist = r;
80102834:	89 1d 98 37 11 80    	mov    %ebx,0x80113798
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
8010284b:	68 60 37 11 80       	push   $0x80113760
80102850:	e8 cb 2b 00 00       	call   80105420 <acquire>
80102855:	83 c4 10             	add    $0x10,%esp
80102858:	eb ce                	jmp    80102828 <kfree+0x48>
8010285a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102860:	c7 45 08 60 37 11 80 	movl   $0x80113760,0x8(%ebp)
}
80102867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010286a:	c9                   	leave  
    release(&kmem.lock);
8010286b:	e9 70 2c 00 00       	jmp    801054e0 <release>
    panic("kfree");
80102870:	83 ec 0c             	sub    $0xc,%esp
80102873:	68 8a 84 10 80       	push   $0x8010848a
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
801028df:	68 90 84 10 80       	push   $0x80108490
801028e4:	68 60 37 11 80       	push   $0x80113760
801028e9:	e8 b2 29 00 00       	call   801052a0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028f1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801028f4:	c7 05 94 37 11 80 00 	movl   $0x0,0x80113794
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
80102984:	c7 05 94 37 11 80 01 	movl   $0x1,0x80113794
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
801029a4:	a1 94 37 11 80       	mov    0x80113794,%eax
801029a9:	85 c0                	test   %eax,%eax
801029ab:	75 1b                	jne    801029c8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801029ad:	a1 98 37 11 80       	mov    0x80113798,%eax
  if(r)
801029b2:	85 c0                	test   %eax,%eax
801029b4:	74 0a                	je     801029c0 <kalloc+0x20>
    kmem.freelist = r->next;
801029b6:	8b 10                	mov    (%eax),%edx
801029b8:	89 15 98 37 11 80    	mov    %edx,0x80113798
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
801029ce:	68 60 37 11 80       	push   $0x80113760
801029d3:	e8 48 2a 00 00       	call   80105420 <acquire>
  r = kmem.freelist;
801029d8:	a1 98 37 11 80       	mov    0x80113798,%eax
  if(r)
801029dd:	8b 15 94 37 11 80    	mov    0x80113794,%edx
801029e3:	83 c4 10             	add    $0x10,%esp
801029e6:	85 c0                	test   %eax,%eax
801029e8:	74 08                	je     801029f2 <kalloc+0x52>
    kmem.freelist = r->next;
801029ea:	8b 08                	mov    (%eax),%ecx
801029ec:	89 0d 98 37 11 80    	mov    %ecx,0x80113798
  if(kmem.use_lock)
801029f2:	85 d2                	test   %edx,%edx
801029f4:	74 16                	je     80102a0c <kalloc+0x6c>
    release(&kmem.lock);
801029f6:	83 ec 0c             	sub    $0xc,%esp
801029f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029fc:	68 60 37 11 80       	push   $0x80113760
80102a01:	e8 da 2a 00 00       	call   801054e0 <release>
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
80102a2c:	8b 1d 34 b6 10 80    	mov    0x8010b634,%ebx
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
80102a4f:	0f b6 8a c0 85 10 80 	movzbl -0x7fef7a40(%edx),%ecx
  shift ^= togglecode[data];
80102a56:	0f b6 82 c0 84 10 80 	movzbl -0x7fef7b40(%edx),%eax
  shift |= shiftcode[data];
80102a5d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102a5f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a61:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102a63:	89 0d 34 b6 10 80    	mov    %ecx,0x8010b634
  c = charcode[shift & (CTL | SHIFT)][data];
80102a69:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a6c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a6f:	8b 04 85 a0 84 10 80 	mov    -0x7fef7b60(,%eax,4),%eax
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
80102a95:	89 1d 34 b6 10 80    	mov    %ebx,0x8010b634
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
80102aaa:	0f b6 8a c0 85 10 80 	movzbl -0x7fef7a40(%edx),%ecx
80102ab1:	83 c9 40             	or     $0x40,%ecx
80102ab4:	0f b6 c9             	movzbl %cl,%ecx
80102ab7:	f7 d1                	not    %ecx
80102ab9:	21 d9                	and    %ebx,%ecx
}
80102abb:	5b                   	pop    %ebx
80102abc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102abd:	89 0d 34 b6 10 80    	mov    %ecx,0x8010b634
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
80102b14:	a1 9c 37 11 80       	mov    0x8011379c,%eax
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
80102c14:	a1 9c 37 11 80       	mov    0x8011379c,%eax
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
80102c34:	a1 9c 37 11 80       	mov    0x8011379c,%eax
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
80102ca2:	a1 9c 37 11 80       	mov    0x8011379c,%eax
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
80102e2f:	e8 4c 27 00 00       	call   80105580 <memcmp>
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
80102f00:	8b 0d e8 37 11 80    	mov    0x801137e8,%ecx
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
80102f20:	a1 d4 37 11 80       	mov    0x801137d4,%eax
80102f25:	83 ec 08             	sub    $0x8,%esp
80102f28:	01 f8                	add    %edi,%eax
80102f2a:	83 c0 01             	add    $0x1,%eax
80102f2d:	50                   	push   %eax
80102f2e:	ff 35 e4 37 11 80    	pushl  0x801137e4
80102f34:	e8 97 d1 ff ff       	call   801000d0 <bread>
80102f39:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f3b:	58                   	pop    %eax
80102f3c:	5a                   	pop    %edx
80102f3d:	ff 34 bd ec 37 11 80 	pushl  -0x7feec814(,%edi,4)
80102f44:	ff 35 e4 37 11 80    	pushl  0x801137e4
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
80102f64:	e8 67 26 00 00       	call   801055d0 <memmove>
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
80102f84:	39 3d e8 37 11 80    	cmp    %edi,0x801137e8
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
80102fa7:	ff 35 d4 37 11 80    	pushl  0x801137d4
80102fad:	ff 35 e4 37 11 80    	pushl  0x801137e4
80102fb3:	e8 18 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102fb8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fbb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102fbd:	a1 e8 37 11 80       	mov    0x801137e8,%eax
80102fc2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102fc5:	85 c0                	test   %eax,%eax
80102fc7:	7e 19                	jle    80102fe2 <write_head+0x42>
80102fc9:	31 d2                	xor    %edx,%edx
80102fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fcf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102fd0:	8b 0c 95 ec 37 11 80 	mov    -0x7feec814(,%edx,4),%ecx
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
8010300e:	68 c0 86 10 80       	push   $0x801086c0
80103013:	68 a0 37 11 80       	push   $0x801137a0
80103018:	e8 83 22 00 00       	call   801052a0 <initlock>
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
8010302d:	89 1d e4 37 11 80    	mov    %ebx,0x801137e4
  log.size = sb.nlog;
80103033:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103036:	a3 d4 37 11 80       	mov    %eax,0x801137d4
  log.size = sb.nlog;
8010303b:	89 15 d8 37 11 80    	mov    %edx,0x801137d8
  struct buf *buf = bread(log.dev, log.start);
80103041:	5a                   	pop    %edx
80103042:	50                   	push   %eax
80103043:	53                   	push   %ebx
80103044:	e8 87 d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103049:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010304c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010304f:	89 0d e8 37 11 80    	mov    %ecx,0x801137e8
  for (i = 0; i < log.lh.n; i++) {
80103055:	85 c9                	test   %ecx,%ecx
80103057:	7e 19                	jle    80103072 <initlog+0x72>
80103059:	31 d2                	xor    %edx,%edx
8010305b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010305f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103060:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103064:	89 1c 95 ec 37 11 80 	mov    %ebx,-0x7feec814(,%edx,4)
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
80103080:	c7 05 e8 37 11 80 00 	movl   $0x0,0x801137e8
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
801030aa:	68 a0 37 11 80       	push   $0x801137a0
801030af:	e8 6c 23 00 00       	call   80105420 <acquire>
801030b4:	83 c4 10             	add    $0x10,%esp
801030b7:	eb 1c                	jmp    801030d5 <begin_op+0x35>
801030b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801030c0:	83 ec 08             	sub    $0x8,%esp
801030c3:	68 a0 37 11 80       	push   $0x801137a0
801030c8:	68 a0 37 11 80       	push   $0x801137a0
801030cd:	e8 ee 1c 00 00       	call   80104dc0 <sleep>
801030d2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801030d5:	a1 e0 37 11 80       	mov    0x801137e0,%eax
801030da:	85 c0                	test   %eax,%eax
801030dc:	75 e2                	jne    801030c0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801030de:	a1 dc 37 11 80       	mov    0x801137dc,%eax
801030e3:	8b 15 e8 37 11 80    	mov    0x801137e8,%edx
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
801030fa:	a3 dc 37 11 80       	mov    %eax,0x801137dc
      release(&log.lock);
801030ff:	68 a0 37 11 80       	push   $0x801137a0
80103104:	e8 d7 23 00 00       	call   801054e0 <release>
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
8010311d:	68 a0 37 11 80       	push   $0x801137a0
80103122:	e8 f9 22 00 00       	call   80105420 <acquire>
  log.outstanding -= 1;
80103127:	a1 dc 37 11 80       	mov    0x801137dc,%eax
  if(log.committing)
8010312c:	8b 35 e0 37 11 80    	mov    0x801137e0,%esi
80103132:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103135:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103138:	89 1d dc 37 11 80    	mov    %ebx,0x801137dc
  if(log.committing)
8010313e:	85 f6                	test   %esi,%esi
80103140:	0f 85 1e 01 00 00    	jne    80103264 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103146:	85 db                	test   %ebx,%ebx
80103148:	0f 85 f2 00 00 00    	jne    80103240 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010314e:	c7 05 e0 37 11 80 01 	movl   $0x1,0x801137e0
80103155:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103158:	83 ec 0c             	sub    $0xc,%esp
8010315b:	68 a0 37 11 80       	push   $0x801137a0
80103160:	e8 7b 23 00 00       	call   801054e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103165:	8b 0d e8 37 11 80    	mov    0x801137e8,%ecx
8010316b:	83 c4 10             	add    $0x10,%esp
8010316e:	85 c9                	test   %ecx,%ecx
80103170:	7f 3e                	jg     801031b0 <end_op+0xa0>
    acquire(&log.lock);
80103172:	83 ec 0c             	sub    $0xc,%esp
80103175:	68 a0 37 11 80       	push   $0x801137a0
8010317a:	e8 a1 22 00 00       	call   80105420 <acquire>
    wakeup(&log);
8010317f:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
    log.committing = 0;
80103186:	c7 05 e0 37 11 80 00 	movl   $0x0,0x801137e0
8010318d:	00 00 00 
    wakeup(&log);
80103190:	e8 eb 1d 00 00       	call   80104f80 <wakeup>
    release(&log.lock);
80103195:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
8010319c:	e8 3f 23 00 00       	call   801054e0 <release>
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
801031b0:	a1 d4 37 11 80       	mov    0x801137d4,%eax
801031b5:	83 ec 08             	sub    $0x8,%esp
801031b8:	01 d8                	add    %ebx,%eax
801031ba:	83 c0 01             	add    $0x1,%eax
801031bd:	50                   	push   %eax
801031be:	ff 35 e4 37 11 80    	pushl  0x801137e4
801031c4:	e8 07 cf ff ff       	call   801000d0 <bread>
801031c9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031cb:	58                   	pop    %eax
801031cc:	5a                   	pop    %edx
801031cd:	ff 34 9d ec 37 11 80 	pushl  -0x7feec814(,%ebx,4)
801031d4:	ff 35 e4 37 11 80    	pushl  0x801137e4
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
801031f4:	e8 d7 23 00 00       	call   801055d0 <memmove>
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
80103214:	3b 1d e8 37 11 80    	cmp    0x801137e8,%ebx
8010321a:	7c 94                	jl     801031b0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010321c:	e8 7f fd ff ff       	call   80102fa0 <write_head>
    install_trans(); // Now install writes to home locations
80103221:	e8 da fc ff ff       	call   80102f00 <install_trans>
    log.lh.n = 0;
80103226:	c7 05 e8 37 11 80 00 	movl   $0x0,0x801137e8
8010322d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103230:	e8 6b fd ff ff       	call   80102fa0 <write_head>
80103235:	e9 38 ff ff ff       	jmp    80103172 <end_op+0x62>
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103240:	83 ec 0c             	sub    $0xc,%esp
80103243:	68 a0 37 11 80       	push   $0x801137a0
80103248:	e8 33 1d 00 00       	call   80104f80 <wakeup>
  release(&log.lock);
8010324d:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
80103254:	e8 87 22 00 00       	call   801054e0 <release>
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
80103267:	68 c4 86 10 80       	push   $0x801086c4
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
8010328b:	8b 15 e8 37 11 80    	mov    0x801137e8,%edx
{
80103291:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103294:	83 fa 1d             	cmp    $0x1d,%edx
80103297:	0f 8f 91 00 00 00    	jg     8010332e <log_write+0xae>
8010329d:	a1 d8 37 11 80       	mov    0x801137d8,%eax
801032a2:	83 e8 01             	sub    $0x1,%eax
801032a5:	39 c2                	cmp    %eax,%edx
801032a7:	0f 8d 81 00 00 00    	jge    8010332e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801032ad:	a1 dc 37 11 80       	mov    0x801137dc,%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	0f 8e 81 00 00 00    	jle    8010333b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	68 a0 37 11 80       	push   $0x801137a0
801032c2:	e8 59 21 00 00       	call   80105420 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801032c7:	8b 15 e8 37 11 80    	mov    0x801137e8,%edx
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
801032e7:	39 0c 85 ec 37 11 80 	cmp    %ecx,-0x7feec814(,%eax,4)
801032ee:	75 f0                	jne    801032e0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801032f0:	89 0c 85 ec 37 11 80 	mov    %ecx,-0x7feec814(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801032f7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801032fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801032fd:	c7 45 08 a0 37 11 80 	movl   $0x801137a0,0x8(%ebp)
}
80103304:	c9                   	leave  
  release(&log.lock);
80103305:	e9 d6 21 00 00       	jmp    801054e0 <release>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103310:	89 0c 95 ec 37 11 80 	mov    %ecx,-0x7feec814(,%edx,4)
    log.lh.n++;
80103317:	83 c2 01             	add    $0x1,%edx
8010331a:	89 15 e8 37 11 80    	mov    %edx,0x801137e8
80103320:	eb d5                	jmp    801032f7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103322:	8b 43 08             	mov    0x8(%ebx),%eax
80103325:	a3 ec 37 11 80       	mov    %eax,0x801137ec
  if (i == log.lh.n)
8010332a:	75 cb                	jne    801032f7 <log_write+0x77>
8010332c:	eb e9                	jmp    80103317 <log_write+0x97>
    panic("too big a transaction");
8010332e:	83 ec 0c             	sub    $0xc,%esp
80103331:	68 d3 86 10 80       	push   $0x801086d3
80103336:	e8 55 d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010333b:	83 ec 0c             	sub    $0xc,%esp
8010333e:	68 e9 86 10 80       	push   $0x801086e9
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
80103368:	68 04 87 10 80       	push   $0x80108704
8010336d:	e8 3e d3 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103372:	e8 89 36 00 00       	call   80106a00 <idtinit>
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
8010338a:	e8 01 14 00 00       	call   80104790 <scheduler>
8010338f:	90                   	nop

80103390 <mpenter>:
{
80103390:	f3 0f 1e fb          	endbr32 
80103394:	55                   	push   %ebp
80103395:	89 e5                	mov    %esp,%ebp
80103397:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010339a:	e8 31 47 00 00       	call   80107ad0 <switchkvm>
  seginit();
8010339f:	e8 9c 46 00 00       	call   80107a40 <seginit>
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
801033cb:	68 c8 8f 11 80       	push   $0x80118fc8
801033d0:	e8 fb f4 ff ff       	call   801028d0 <kinit1>
  kvmalloc();      // kernel page table
801033d5:	e8 d6 4b 00 00       	call   80107fb0 <kvmalloc>
  mpinit();        // detect other processors
801033da:	e8 81 01 00 00       	call   80103560 <mpinit>
  lapicinit();     // interrupt controller
801033df:	e8 2c f7 ff ff       	call   80102b10 <lapicinit>
  seginit();       // segment descriptors
801033e4:	e8 57 46 00 00       	call   80107a40 <seginit>
  picinit();       // disable pic
801033e9:	e8 52 03 00 00       	call   80103740 <picinit>
  ioapicinit();    // another interrupt controller
801033ee:	e8 fd f2 ff ff       	call   801026f0 <ioapicinit>
  consoleinit();   // console hardware
801033f3:	e8 98 d9 ff ff       	call   80100d90 <consoleinit>
  uartinit();      // serial port
801033f8:	e8 03 39 00 00       	call   80106d00 <uartinit>
  pinit();         // process table
801033fd:	e8 9e 08 00 00       	call   80103ca0 <pinit>
  tvinit();        // trap vectors
80103402:	e8 79 35 00 00       	call   80106980 <tvinit>
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
8010341e:	68 0c b5 10 80       	push   $0x8010b50c
80103423:	68 00 70 00 80       	push   $0x80007000
80103428:	e8 a3 21 00 00       	call   801055d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010342d:	83 c4 10             	add    $0x10,%esp
80103430:	69 05 20 3e 11 80 b0 	imul   $0xb0,0x80113e20,%eax
80103437:	00 00 00 
8010343a:	05 a0 38 11 80       	add    $0x801138a0,%eax
8010343f:	3d a0 38 11 80       	cmp    $0x801138a0,%eax
80103444:	76 7a                	jbe    801034c0 <main+0x110>
80103446:	bb a0 38 11 80       	mov    $0x801138a0,%ebx
8010344b:	eb 1c                	jmp    80103469 <main+0xb9>
8010344d:	8d 76 00             	lea    0x0(%esi),%esi
80103450:	69 05 20 3e 11 80 b0 	imul   $0xb0,0x80113e20,%eax
80103457:	00 00 00 
8010345a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103460:	05 a0 38 11 80       	add    $0x801138a0,%eax
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
80103484:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010348b:	a0 10 00 
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
8010350e:	68 18 87 10 80       	push   $0x80108718
80103513:	56                   	push   %esi
80103514:	e8 67 20 00 00       	call   80105580 <memcmp>
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
801035ca:	68 1d 87 10 80       	push   $0x8010871d
801035cf:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801035d3:	e8 a8 1f 00 00       	call   80105580 <memcmp>
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
8010362e:	a3 9c 37 11 80       	mov    %eax,0x8011379c
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
801036bf:	88 0d 80 38 11 80    	mov    %cl,0x80113880
      continue;
801036c5:	eb 89                	jmp    80103650 <mpinit+0xf0>
801036c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ce:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801036d0:	8b 0d 20 3e 11 80    	mov    0x80113e20,%ecx
801036d6:	83 f9 07             	cmp    $0x7,%ecx
801036d9:	7f 19                	jg     801036f4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036db:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801036e1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801036e5:	83 c1 01             	add    $0x1,%ecx
801036e8:	89 0d 20 3e 11 80    	mov    %ecx,0x80113e20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036ee:	88 9f a0 38 11 80    	mov    %bl,-0x7feec760(%edi)
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
80103723:	68 22 87 10 80       	push   $0x80108722
80103728:	e8 63 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010372d:	83 ec 0c             	sub    $0xc,%esp
80103730:	68 3c 87 10 80       	push   $0x8010873c
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
801037d7:	68 5b 87 10 80       	push   $0x8010875b
801037dc:	50                   	push   %eax
801037dd:	e8 be 1a 00 00       	call   801052a0 <initlock>
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
80103883:	e8 98 1b 00 00       	call   80105420 <acquire>
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
801038a3:	e8 d8 16 00 00       	call   80104f80 <wakeup>
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
801038c8:	e9 13 1c 00 00       	jmp    801054e0 <release>
801038cd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801038d0:	83 ec 0c             	sub    $0xc,%esp
801038d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801038d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801038e0:	00 00 00 
    wakeup(&p->nwrite);
801038e3:	50                   	push   %eax
801038e4:	e8 97 16 00 00       	call   80104f80 <wakeup>
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	eb bd                	jmp    801038ab <pipeclose+0x3b>
801038ee:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801038f0:	83 ec 0c             	sub    $0xc,%esp
801038f3:	53                   	push   %ebx
801038f4:	e8 e7 1b 00 00       	call   801054e0 <release>
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
80103921:	e8 fa 1a 00 00       	call   80105420 <acquire>
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
80103978:	e8 03 16 00 00       	call   80104f80 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010397d:	58                   	pop    %eax
8010397e:	5a                   	pop    %edx
8010397f:	53                   	push   %ebx
80103980:	56                   	push   %esi
80103981:	e8 3a 14 00 00       	call   80104dc0 <sleep>
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
801039ac:	e8 2f 1b 00 00       	call   801054e0 <release>
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
801039fa:	e8 81 15 00 00       	call   80104f80 <wakeup>
  release(&p->lock);
801039ff:	89 1c 24             	mov    %ebx,(%esp)
80103a02:	e8 d9 1a 00 00       	call   801054e0 <release>
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
80103a2a:	e8 f1 19 00 00       	call   80105420 <acquire>
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
80103a5d:	e8 5e 13 00 00       	call   80104dc0 <sleep>
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
80103ac6:	e8 b5 14 00 00       	call   80104f80 <wakeup>
  release(&p->lock);
80103acb:	89 34 24             	mov    %esi,(%esp)
80103ace:	e8 0d 1a 00 00       	call   801054e0 <release>
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
80103ae9:	e8 f2 19 00 00       	call   801054e0 <release>
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
80103b05:	bb 74 3e 11 80       	mov    $0x80113e74,%ebx
  acquire(&ptable.lock);
80103b0a:	83 ec 0c             	sub    $0xc,%esp
80103b0d:	68 40 3e 11 80       	push   $0x80113e40
80103b12:	e8 09 19 00 00       	call   80105420 <acquire>
80103b17:	83 c4 10             	add    $0x10,%esp
80103b1a:	eb 16                	jmp    80103b32 <allocproc+0x32>
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b20:	81 c3 24 01 00 00    	add    $0x124,%ebx
80103b26:	81 fb 74 87 11 80    	cmp    $0x80118774,%ebx
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
80103b39:	a1 94 b0 10 80       	mov    0x8010b094,%eax
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
80103b6c:	68 80 87 11 80       	push   $0x80118780
  p->pid = nextpid++;
80103b71:	89 15 94 b0 10 80    	mov    %edx,0x8010b094
  acquire(&tickslock);
80103b77:	e8 a4 18 00 00       	call   80105420 <acquire>
  release(&tickslock);
80103b7c:	c7 04 24 80 87 11 80 	movl   $0x80118780,(%esp)
  xticks = ticks;
80103b83:	8b 35 c0 8f 11 80    	mov    0x80118fc0,%esi
  release(&tickslock);
80103b89:	e8 52 19 00 00       	call   801054e0 <release>
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
80103bc3:	e8 68 19 00 00       	call   80105530 <memset>
  release(&ptable.lock);
80103bc8:	c7 04 24 40 3e 11 80 	movl   $0x80113e40,(%esp)
80103bcf:	e8 0c 19 00 00       	call   801054e0 <release>

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
80103bf4:	c7 40 14 6c 69 10 80 	movl   $0x8010696c,0x14(%eax)
  p->context = (struct context*)sp;
80103bfb:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103bfe:	6a 14                	push   $0x14
80103c00:	6a 00                	push   $0x0
80103c02:	50                   	push   %eax
80103c03:	e8 28 19 00 00       	call   80105530 <memset>
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
80103c25:	68 40 3e 11 80       	push   $0x80113e40
80103c2a:	e8 b1 18 00 00       	call   801054e0 <release>
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
80103c5a:	68 40 3e 11 80       	push   $0x80113e40
80103c5f:	e8 7c 18 00 00       	call   801054e0 <release>

  if (first) {
80103c64:	a1 00 b0 10 80       	mov    0x8010b000,%eax
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
80103c78:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
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
80103caa:	68 60 87 10 80       	push   $0x80108760
80103caf:	68 40 3e 11 80       	push   $0x80113e40
80103cb4:	e8 e7 15 00 00       	call   801052a0 <initlock>
}
80103cb9:	83 c4 10             	add    $0x10,%esp
  ptable.trace = 0;
80103cbc:	c7 05 74 87 11 80 00 	movl   $0x0,0x80118774
80103cc3:	00 00 00 
  ptable.trace_pid = -1;
80103cc6:	c7 05 78 87 11 80 ff 	movl   $0xffffffff,0x80118778
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
80103cf5:	8b 35 20 3e 11 80    	mov    0x80113e20,%esi
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
80103d15:	0f b6 81 a0 38 11 80 	movzbl -0x7feec760(%ecx),%eax
80103d1c:	39 d8                	cmp    %ebx,%eax
80103d1e:	75 e8                	jne    80103d08 <mycpu+0x28>
}
80103d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103d23:	8d 81 a0 38 11 80    	lea    -0x7feec760(%ecx),%eax
}
80103d29:	5b                   	pop    %ebx
80103d2a:	5e                   	pop    %esi
80103d2b:	5d                   	pop    %ebp
80103d2c:	c3                   	ret    
  panic("unknown apicid\n");
80103d2d:	83 ec 0c             	sub    $0xc,%esp
80103d30:	68 67 87 10 80       	push   $0x80108767
80103d35:	e8 56 c6 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 14 89 10 80       	push   $0x80108914
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
80103d60:	2d a0 38 11 80       	sub    $0x801138a0,%eax
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
80103d7b:	68 80 87 11 80       	push   $0x80118780
80103d80:	e8 9b 16 00 00       	call   80105420 <acquire>
  xticks = ticks;
80103d85:	8b 1d c0 8f 11 80    	mov    0x80118fc0,%ebx
  release(&tickslock);
80103d8b:	c7 04 24 80 87 11 80 	movl   $0x80118780,(%esp)
80103d92:	e8 49 17 00 00       	call   801054e0 <release>
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
80103dab:	e8 70 15 00 00       	call   80105320 <pushcli>
  c = mycpu();
80103db0:	e8 2b ff ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80103db5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dbb:	e8 b0 15 00 00       	call   80105370 <popcli>
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
80103de2:	a3 38 b6 10 80       	mov    %eax,0x8010b638
  if((p->pgdir = setupkvm()) == 0)
80103de7:	e8 44 41 00 00       	call   80107f30 <setupkvm>
80103dec:	89 43 04             	mov    %eax,0x4(%ebx)
80103def:	85 c0                	test   %eax,%eax
80103df1:	0f 84 bd 00 00 00    	je     80103eb4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103df7:	83 ec 04             	sub    $0x4,%esp
80103dfa:	68 2c 00 00 00       	push   $0x2c
80103dff:	68 e0 b4 10 80       	push   $0x8010b4e0
80103e04:	50                   	push   %eax
80103e05:	e8 f6 3d 00 00       	call   80107c00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e0a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e0d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e13:	6a 4c                	push   $0x4c
80103e15:	6a 00                	push   $0x0
80103e17:	ff 73 18             	pushl  0x18(%ebx)
80103e1a:	e8 11 17 00 00       	call   80105530 <memset>
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
80103e73:	68 90 87 10 80       	push   $0x80108790
80103e78:	50                   	push   %eax
80103e79:	e8 72 18 00 00       	call   801056f0 <safestrcpy>
  p->cwd = namei("/");
80103e7e:	c7 04 24 99 87 10 80 	movl   $0x80108799,(%esp)
80103e85:	e8 16 e5 ff ff       	call   801023a0 <namei>
80103e8a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103e8d:	c7 04 24 40 3e 11 80 	movl   $0x80113e40,(%esp)
80103e94:	e8 87 15 00 00       	call   80105420 <acquire>
  p->state = RUNNABLE;
80103e99:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103ea0:	c7 04 24 40 3e 11 80 	movl   $0x80113e40,(%esp)
80103ea7:	e8 34 16 00 00       	call   801054e0 <release>
}
80103eac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eaf:	83 c4 10             	add    $0x10,%esp
80103eb2:	c9                   	leave  
80103eb3:	c3                   	ret    
    panic("userinit: out of memory?");
80103eb4:	83 ec 0c             	sub    $0xc,%esp
80103eb7:	68 77 87 10 80       	push   $0x80108777
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
80103edc:	e8 3f 14 00 00       	call   80105320 <pushcli>
  c = mycpu();
80103ee1:	e8 fa fd ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80103ee6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103eec:	e8 7f 14 00 00       	call   80105370 <popcli>
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
80103eff:	e8 ec 3b 00 00       	call   80107af0 <switchuvm>
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
80103f1a:	e8 31 3e 00 00       	call   80107d50 <allocuvm>
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
80103f3a:	e8 41 3f 00 00       	call   80107e80 <deallocuvm>
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
80103f5d:	e8 be 13 00 00       	call   80105320 <pushcli>
  c = mycpu();
80103f62:	e8 79 fd ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80103f67:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f6d:	e8 fe 13 00 00       	call   80105370 <popcli>
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
80103f8c:	e8 6f 40 00 00       	call   80108000 <copyuvm>
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
80104009:	e8 e2 16 00 00       	call   801056f0 <safestrcpy>
  if (pid == initproc->pid + 1)
8010400e:	a1 38 b6 10 80       	mov    0x8010b638,%eax
  pid = np->pid;
80104013:	8b 5f 10             	mov    0x10(%edi),%ebx
  if (pid == initproc->pid + 1)
80104016:	83 c4 10             	add    $0x10,%esp
80104019:	8b 40 10             	mov    0x10(%eax),%eax
8010401c:	83 c0 01             	add    $0x1,%eax
8010401f:	39 d8                	cmp    %ebx,%eax
80104021:	75 06                	jne    80104029 <fork+0xd9>
    ptable.trace_pid = pid;
80104023:	89 1d 78 87 11 80    	mov    %ebx,0x80118778
  acquire(&ptable.lock);
80104029:	83 ec 0c             	sub    $0xc,%esp
8010402c:	68 40 3e 11 80       	push   $0x80113e40
80104031:	e8 ea 13 00 00       	call   80105420 <acquire>
  np->state = RUNNABLE;
80104036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104039:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104040:	c7 04 24 40 3e 11 80 	movl   $0x80113e40,(%esp)
80104047:	e8 94 14 00 00       	call   801054e0 <release>
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
8010409a:	bb 74 3e 11 80       	mov    $0x80113e74,%ebx
int get_children_pid_number(int parent_id){
8010409f:	83 ec 1c             	sub    $0x1c,%esp
801040a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  int result = parent_id;
801040a5:	89 fe                	mov    %edi,%esi
801040a7:	eb 15                	jmp    801040be <get_children_pid_number+0x2e>
801040a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b0:	81 c3 24 01 00 00    	add    $0x124,%ebx
801040b6:	81 fb 74 87 11 80    	cmp    $0x80118774,%ebx
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
8010410b:	81 fb 74 87 11 80    	cmp    $0x80118774,%ebx
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
8010413b:	a3 74 87 11 80       	mov    %eax,0x80118774
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
80104165:	68 9b 87 10 80       	push   $0x8010879b
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
80104184:	ff 34 9d 20 b0 10 80 	pushl  -0x7fef4fe0(,%ebx,4)
8010418b:	68 a0 87 10 80       	push   $0x801087a0
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
801041bc:	e8 5f 11 00 00       	call   80105320 <pushcli>
  c = mycpu();
801041c1:	e8 1a fb ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
801041c6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041cc:	e8 9f 11 00 00       	call   80105370 <popcli>
  if(curproc->pid != ptable.trace_pid) {
801041d1:	a1 78 87 11 80       	mov    0x80118778,%eax
801041d6:	39 43 10             	cmp    %eax,0x10(%ebx)
801041d9:	74 15                	je     801041f0 <trace_syscalls+0x40>
  ptable.trace = tr;
801041db:	89 35 74 87 11 80    	mov    %esi,0x80118774
}
801041e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e4:	5b                   	pop    %ebx
801041e5:	5e                   	pop    %esi
801041e6:	5d                   	pop    %ebp
801041e7:	c3                   	ret    
801041e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ef:	90                   	nop
  if(ptable.trace == 0)
801041f0:	a1 74 87 11 80       	mov    0x80118774,%eax
801041f5:	85 c0                	test   %eax,%eax
801041f7:	74 e8                	je     801041e1 <trace_syscalls+0x31>
  cprintf("\n");
801041f9:	83 ec 0c             	sub    $0xc,%esp
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041fc:	bb 74 3e 11 80       	mov    $0x80113e74,%ebx
  cprintf("\n");
80104201:	68 97 8c 10 80       	push   $0x80108c97
80104206:	e8 a5 c4 ff ff       	call   801006b0 <cprintf>
8010420b:	83 c4 10             	add    $0x10,%esp
8010420e:	eb 0e                	jmp    8010421e <trace_syscalls+0x6e>
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104210:	81 c3 24 01 00 00    	add    $0x124,%ebx
80104216:	81 fb 74 87 11 80    	cmp    $0x80118774,%ebx
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
8010423b:	81 fb 74 87 11 80    	cmp    $0x80118774,%ebx
80104241:	75 db                	jne    8010421e <trace_syscalls+0x6e>
  cprintf("\n");
80104243:	c7 45 08 97 8c 10 80 	movl   $0x80108c97,0x8(%ebp)
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

801042a0 <float_to_string>:
{
801042a0:	f3 0f 1e fb          	endbr32 
801042a4:	55                   	push   %ebp
    char answer[100] = {0};
801042a5:	31 c0                	xor    %eax,%eax
801042a7:	b9 18 00 00 00       	mov    $0x18,%ecx
    dec = (int)(fVal * 100) % 100;
801042ac:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
{
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	57                   	push   %edi
801042b4:	56                   	push   %esi
    char answer[100] = {0};
801042b5:	8d 7d 88             	lea    -0x78(%ebp),%edi
    memset(result, 0, 100);
801042b8:	8d b5 20 ff ff ff    	lea    -0xe0(%ebp),%esi
{
801042be:	53                   	push   %ebx
801042bf:	81 ec f0 00 00 00    	sub    $0xf0,%esp
    fVal += 0.005;   // added after a comment from Matt McNabb, see below.
801042c5:	dd 05 58 89 10 80    	fldl   0x80108958
801042cb:	d8 45 08             	fadds  0x8(%ebp)
    char answer[100] = {0};
801042ce:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
801042d5:	f3 ab                	rep stos %eax,%es:(%edi)
    memset(result, 0, 100);
801042d7:	6a 64                	push   $0x64
    dVal = fVal;
801042d9:	d9 bd 16 ff ff ff    	fnstcw -0xea(%ebp)
    memset(result, 0, 100);
801042df:	6a 00                	push   $0x0
801042e1:	56                   	push   %esi
    dVal = fVal;
801042e2:	0f b7 85 16 ff ff ff 	movzwl -0xea(%ebp),%eax
    fVal += 0.005;   // added after a comment from Matt McNabb, see below.
801042e9:	d9 9d 10 ff ff ff    	fstps  -0xf0(%ebp)
801042ef:	d9 85 10 ff ff ff    	flds   -0xf0(%ebp)
    dVal = fVal;
801042f5:	80 cc 0c             	or     $0xc,%ah
801042f8:	66 89 85 14 ff ff ff 	mov    %ax,-0xec(%ebp)
801042ff:	d9 ad 14 ff ff ff    	fldcw  -0xec(%ebp)
80104305:	db 95 10 ff ff ff    	fistl  -0xf0(%ebp)
8010430b:	d9 ad 16 ff ff ff    	fldcw  -0xea(%ebp)
    dec = (int)(fVal * 100) % 100;
80104311:	d8 0d 68 89 10 80    	fmuls  0x80108968
    dVal = fVal;
80104317:	8b 9d 10 ff ff ff    	mov    -0xf0(%ebp),%ebx
    dec = (int)(fVal * 100) % 100;
8010431d:	d9 ad 14 ff ff ff    	fldcw  -0xec(%ebp)
80104323:	db 9d 10 ff ff ff    	fistpl -0xf0(%ebp)
80104329:	d9 ad 16 ff ff ff    	fldcw  -0xea(%ebp)
8010432f:	8b 8d 10 ff ff ff    	mov    -0xf0(%ebp),%ecx
80104335:	89 c8                	mov    %ecx,%eax
80104337:	f7 ea                	imul   %edx
80104339:	89 c8                	mov    %ecx,%eax
8010433b:	c1 f8 1f             	sar    $0x1f,%eax
8010433e:	c1 fa 05             	sar    $0x5,%edx
80104341:	89 d7                	mov    %edx,%edi
80104343:	29 c7                	sub    %eax,%edi
80104345:	6b ff 64             	imul   $0x64,%edi,%edi
80104348:	29 f9                	sub    %edi,%ecx
8010434a:	89 cf                	mov    %ecx,%edi
    memset(result, 0, 100);
8010434c:	e8 df 11 00 00       	call   80105530 <memset>
    result[0] = (dec % 10) + '0';
80104351:	89 f8                	mov    %edi,%eax
80104353:	ba 67 66 66 66       	mov    $0x66666667,%edx
    while (dVal > 0)
80104358:	83 c4 10             	add    $0x10,%esp
    result[0] = (dec % 10) + '0';
8010435b:	f7 ea                	imul   %edx
8010435d:	89 f8                	mov    %edi,%eax
    result[2] = '.';
8010435f:	c6 85 22 ff ff ff 2e 	movb   $0x2e,-0xde(%ebp)
    result[0] = (dec % 10) + '0';
80104366:	c1 f8 1f             	sar    $0x1f,%eax
80104369:	c1 fa 02             	sar    $0x2,%edx
8010436c:	29 c2                	sub    %eax,%edx
8010436e:	8d 04 92             	lea    (%edx,%edx,4),%eax
    result[1] = (dec / 10) + '0';
80104371:	83 c2 30             	add    $0x30,%edx
    result[0] = (dec % 10) + '0';
80104374:	01 c0                	add    %eax,%eax
    result[1] = (dec / 10) + '0';
80104376:	88 95 21 ff ff ff    	mov    %dl,-0xdf(%ebp)
    result[0] = (dec % 10) + '0';
8010437c:	29 c7                	sub    %eax,%edi
8010437e:	8d 47 30             	lea    0x30(%edi),%eax
80104381:	88 85 20 ff ff ff    	mov    %al,-0xe0(%ebp)
    while (dVal > 0)
80104387:	85 db                	test   %ebx,%ebx
80104389:	7e 36                	jle    801043c1 <float_to_string+0x121>
8010438b:	8d 8d 23 ff ff ff    	lea    -0xdd(%ebp),%ecx
80104391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        result[i] = (dVal % 10) + '0';
80104398:	89 d8                	mov    %ebx,%eax
8010439a:	bf cd cc cc cc       	mov    $0xcccccccd,%edi
8010439f:	83 c1 01             	add    $0x1,%ecx
801043a2:	f7 e7                	mul    %edi
801043a4:	89 df                	mov    %ebx,%edi
801043a6:	c1 ea 03             	shr    $0x3,%edx
801043a9:	8d 04 92             	lea    (%edx,%edx,4),%eax
801043ac:	01 c0                	add    %eax,%eax
801043ae:	29 c7                	sub    %eax,%edi
801043b0:	89 f8                	mov    %edi,%eax
801043b2:	83 c0 30             	add    $0x30,%eax
801043b5:	88 41 ff             	mov    %al,-0x1(%ecx)
        dVal /= 10;
801043b8:	89 d8                	mov    %ebx,%eax
801043ba:	89 d3                	mov    %edx,%ebx
    while (dVal > 0)
801043bc:	83 f8 09             	cmp    $0x9,%eax
801043bf:	7f d7                	jg     80104398 <float_to_string+0xf8>
    for (i=strlen(result)-1; i>=0; i--){
801043c1:	83 ec 0c             	sub    $0xc,%esp
801043c4:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
801043c7:	56                   	push   %esi
801043c8:	e8 63 13 00 00       	call   80105730 <strlen>
801043cd:	83 c4 10             	add    $0x10,%esp
801043d0:	85 c0                	test   %eax,%eax
801043d2:	7e 1e                	jle    801043f2 <float_to_string+0x152>
801043d4:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
801043d7:	8d 44 06 ff          	lea    -0x1(%esi,%eax,1),%eax
801043db:	89 da                	mov    %ebx,%edx
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
        answer[tmp] = result[i];
801043e0:	0f b6 08             	movzbl (%eax),%ecx
801043e3:	83 c2 01             	add    $0x1,%edx
801043e6:	88 4a ff             	mov    %cl,-0x1(%edx)
    for (i=strlen(result)-1; i>=0; i--){
801043e9:	89 c1                	mov    %eax,%ecx
801043eb:	83 e8 01             	sub    $0x1,%eax
801043ee:	39 ce                	cmp    %ecx,%esi
801043f0:	75 ee                	jne    801043e0 <float_to_string+0x140>
    cprintf("%s ", answer);
801043f2:	83 ec 08             	sub    $0x8,%esp
801043f5:	53                   	push   %ebx
801043f6:	68 ac 87 10 80       	push   $0x801087ac
801043fb:	e8 b0 c2 ff ff       	call   801006b0 <cprintf>
}
80104400:	83 c4 10             	add    $0x10,%esp
80104403:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104406:	5b                   	pop    %ebx
80104407:	5e                   	pop    %esi
80104408:	5f                   	pop    %edi
80104409:	5d                   	pop    %ebp
8010440a:	c3                   	ret    
8010440b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010440f:	90                   	nop

80104410 <print_procs_info>:
print_procs_info(void){
80104410:	f3 0f 1e fb          	endbr32 
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	53                   	push   %ebx
80104418:	bb e0 3e 11 80       	mov    $0x80113ee0,%ebx
8010441d:	83 ec 34             	sub    $0x34,%esp
  char* states[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };
80104420:	c7 45 e0 b0 87 10 80 	movl   $0x801087b0,-0x20(%ebp)
80104427:	c7 45 e4 b7 87 10 80 	movl   $0x801087b7,-0x1c(%ebp)
8010442e:	c7 45 e8 be 87 10 80 	movl   $0x801087be,-0x18(%ebp)
80104435:	c7 45 ec c7 87 10 80 	movl   $0x801087c7,-0x14(%ebp)
8010443c:	c7 45 f0 d0 87 10 80 	movl   $0x801087d0,-0x10(%ebp)
80104443:	c7 45 f4 d8 87 10 80 	movl   $0x801087d8,-0xc(%ebp)
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p->state == UNUSED)
80104450:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104453:	85 c0                	test   %eax,%eax
80104455:	0f 84 bc 00 00 00    	je     80104517 <print_procs_info+0x107>
    double priority = 1 / (double) p->num_tickets;
8010445b:	db 83 88 00 00 00    	fildl  0x88(%ebx)
80104461:	d8 3d 6c 89 10 80    	fdivrs 0x8010896c
    cprintf("%s %d %s %d %d " , p->name, p->pid, states[p->state], p->q_level, p->num_tickets);
80104467:	83 ec 08             	sub    $0x8,%esp
8010446a:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80104470:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
80104476:	ff 74 85 e0          	pushl  -0x20(%ebp,%eax,4)
8010447a:	ff 73 a4             	pushl  -0x5c(%ebx)
8010447d:	53                   	push   %ebx
8010447e:	68 df 87 10 80       	push   $0x801087df
    double rank = (priority * p->priority_ratio) + (p->arrival_time * p->arrival_ratio) \
80104483:	dc 8b a0 00 00 00    	fmull  0xa0(%ebx)
80104489:	db 83 94 00 00 00    	fildl  0x94(%ebx)
8010448f:	dc 8b a8 00 00 00    	fmull  0xa8(%ebx)
80104495:	de c1                	faddp  %st,%st(1)
                  + (p->executed_cycle * p->executed_cycle_ratio);
80104497:	dd 83 98 00 00 00    	fldl   0x98(%ebx)
8010449d:	dc 8b b0 00 00 00    	fmull  0xb0(%ebx)
    double rank = (priority * p->priority_ratio) + (p->arrival_time * p->arrival_ratio) \
801044a3:	de c1                	faddp  %st,%st(1)
801044a5:	dd 5d c8             	fstpl  -0x38(%ebp)
    cprintf("%s %d %s %d %d " , p->name, p->pid, states[p->state], p->q_level, p->num_tickets);
801044a8:	e8 03 c2 ff ff       	call   801006b0 <cprintf>
    float_to_string(p->priority_ratio);
801044ad:	dd 83 a0 00 00 00    	fldl   0xa0(%ebx)
801044b3:	83 c4 14             	add    $0x14,%esp
801044b6:	d9 5d d4             	fstps  -0x2c(%ebp)
801044b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801044bc:	50                   	push   %eax
801044bd:	e8 de fd ff ff       	call   801042a0 <float_to_string>
    float_to_string(p->arrival_ratio);
801044c2:	dd 83 a8 00 00 00    	fldl   0xa8(%ebx)
801044c8:	d9 5d d4             	fstps  -0x2c(%ebp)
801044cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801044ce:	89 04 24             	mov    %eax,(%esp)
801044d1:	e8 ca fd ff ff       	call   801042a0 <float_to_string>
    float_to_string(p->executed_cycle_ratio);
801044d6:	dd 83 b0 00 00 00    	fldl   0xb0(%ebx)
801044dc:	d9 5d d4             	fstps  -0x2c(%ebp)
801044df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801044e2:	89 04 24             	mov    %eax,(%esp)
801044e5:	e8 b6 fd ff ff       	call   801042a0 <float_to_string>
    float_to_string(rank);
801044ea:	dd 45 c8             	fldl   -0x38(%ebp)
801044ed:	d9 5d d4             	fstps  -0x2c(%ebp)
801044f0:	d9 45 d4             	flds   -0x2c(%ebp)
801044f3:	d9 1c 24             	fstps  (%esp)
801044f6:	e8 a5 fd ff ff       	call   801042a0 <float_to_string>
    cprintf("%d %d\n", p->cycle_count, p->age);
801044fb:	83 c4 0c             	add    $0xc,%esp
801044fe:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104504:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
8010450a:	68 ef 87 10 80       	push   $0x801087ef
8010450f:	e8 9c c1 ff ff       	call   801006b0 <cprintf>
80104514:	83 c4 10             	add    $0x10,%esp
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104517:	81 c3 24 01 00 00    	add    $0x124,%ebx
8010451d:	81 fb e0 87 11 80    	cmp    $0x801187e0,%ebx
80104523:	0f 85 27 ff ff ff    	jne    80104450 <print_procs_info+0x40>
}
80104529:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010452c:	c9                   	leave  
8010452d:	c3                   	ret    
8010452e:	66 90                	xchg   %ax,%ax

80104530 <change_queue>:
change_queue(int pid , int new_queue){
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104535:	b8 74 3e 11 80       	mov    $0x80113e74,%eax
change_queue(int pid , int new_queue){
8010453a:	89 e5                	mov    %esp,%ebp
8010453c:	8b 55 08             	mov    0x8(%ebp),%edx
8010453f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p->state == UNUSED || p->pid != pid)
80104548:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
8010454c:	74 0b                	je     80104559 <change_queue+0x29>
8010454e:	39 50 10             	cmp    %edx,0x10(%eax)
80104551:	75 06                	jne    80104559 <change_queue+0x29>
    p->q_level = new_queue;
80104553:	89 88 f0 00 00 00    	mov    %ecx,0xf0(%eax)
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104559:	05 24 01 00 00       	add    $0x124,%eax
8010455e:	3d 74 87 11 80       	cmp    $0x80118774,%eax
80104563:	75 e3                	jne    80104548 <change_queue+0x18>
}
80104565:	5d                   	pop    %ebp
80104566:	c3                   	ret    
80104567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456e:	66 90                	xchg   %ax,%ax

80104570 <change_ticket>:
change_ticket(int pid, int new_ticket){
80104570:	f3 0f 1e fb          	endbr32 
80104574:	55                   	push   %ebp
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104575:	b8 74 3e 11 80       	mov    $0x80113e74,%eax
change_ticket(int pid, int new_ticket){
8010457a:	89 e5                	mov    %esp,%ebp
8010457c:	8b 55 08             	mov    0x8(%ebp),%edx
8010457f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p->state == UNUSED || p->pid != pid)
80104588:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
8010458c:	74 0b                	je     80104599 <change_ticket+0x29>
8010458e:	39 50 10             	cmp    %edx,0x10(%eax)
80104591:	75 06                	jne    80104599 <change_ticket+0x29>
    p->num_tickets = new_ticket;
80104593:	89 88 f4 00 00 00    	mov    %ecx,0xf4(%eax)
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104599:	05 24 01 00 00       	add    $0x124,%eax
8010459e:	3d 74 87 11 80       	cmp    $0x80118774,%eax
801045a3:	75 e3                	jne    80104588 <change_ticket+0x18>
}
801045a5:	5d                   	pop    %ebp
801045a6:	c3                   	ret    
801045a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ae:	66 90                	xchg   %ax,%ax

801045b0 <stod>:
double stod(const char* s){    //definition
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	83 ec 08             	sub    $0x8,%esp
801045ba:	8b 55 08             	mov    0x8(%ebp),%edx
    if (*s == '-'){
801045bd:	0f be 02             	movsbl (%edx),%eax
801045c0:	3c 2d                	cmp    $0x2d,%al
801045c2:	74 5c                	je     80104620 <stod+0x70>
    double rez = 0, fact = 1;
801045c4:	d9 e8                	fld1   
    for (int point_seen = 0; *s; s++){
801045c6:	84 c0                	test   %al,%al
801045c8:	74 65                	je     8010462f <stod+0x7f>
801045ca:	31 c9                	xor    %ecx,%ecx
801045cc:	d9 ee                	fldz   
801045ce:	eb 2f                	jmp    801045ff <stod+0x4f>
        int d = *s - '0';
801045d0:	83 e8 30             	sub    $0x30,%eax
        if (d >= 0 && d <= 9){
801045d3:	83 f8 09             	cmp    $0x9,%eax
801045d6:	77 1c                	ja     801045f4 <stod+0x44>
            if (point_seen) fact /= 10.0f;
801045d8:	85 c9                	test   %ecx,%ecx
801045da:	74 0a                	je     801045e6 <stod+0x36>
801045dc:	d9 c9                	fxch   %st(1)
801045de:	d8 35 70 89 10 80    	fdivs  0x80108970
801045e4:	d9 c9                	fxch   %st(1)
            rez = rez * 10.0f + (float)d;
801045e6:	d8 0d 70 89 10 80    	fmuls  0x80108970
801045ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
801045ef:	db 45 fc             	fildl  -0x4(%ebp)
801045f2:	de c1                	faddp  %st,%st(1)
    for (int point_seen = 0; *s; s++){
801045f4:	0f be 42 01          	movsbl 0x1(%edx),%eax
801045f8:	83 c2 01             	add    $0x1,%edx
801045fb:	84 c0                	test   %al,%al
801045fd:	74 14                	je     80104613 <stod+0x63>
        if (*s == '.'){
801045ff:	3c 2e                	cmp    $0x2e,%al
80104601:	75 cd                	jne    801045d0 <stod+0x20>
    for (int point_seen = 0; *s; s++){
80104603:	0f be 42 01          	movsbl 0x1(%edx),%eax
80104607:	83 c2 01             	add    $0x1,%edx
            point_seen = 1;
8010460a:	b9 01 00 00 00       	mov    $0x1,%ecx
    for (int point_seen = 0; *s; s++){
8010460f:	84 c0                	test   %al,%al
80104611:	75 ec                	jne    801045ff <stod+0x4f>
}
80104613:	c9                   	leave  
    return rez * fact;
80104614:	de c9                	fmulp  %st,%st(1)
}
80104616:	c3                   	ret    
80104617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461e:	66 90                	xchg   %ax,%ax
        fact = -1;
80104620:	0f be 42 01          	movsbl 0x1(%edx),%eax
80104624:	d9 e8                	fld1   
        s++;
80104626:	83 c2 01             	add    $0x1,%edx
        fact = -1;
80104629:	d9 e0                	fchs   
    for (int point_seen = 0; *s; s++){
8010462b:	84 c0                	test   %al,%al
8010462d:	75 9b                	jne    801045ca <stod+0x1a>
}
8010462f:	c9                   	leave  
    for (int point_seen = 0; *s; s++){
80104630:	d9 ee                	fldz   
    return rez * fact;
80104632:	de c9                	fmulp  %st,%st(1)
}
80104634:	c3                   	ret    
80104635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <change_BJF_parameters_individual>:
change_BJF_parameters_individual(int pid, char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
80104640:	f3 0f 1e fb          	endbr32 
80104644:	55                   	push   %ebp
80104645:	89 e5                	mov    %esp,%ebp
80104647:	57                   	push   %edi
80104648:	56                   	push   %esi
80104649:	53                   	push   %ebx
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010464a:	bb 74 3e 11 80       	mov    $0x80113e74,%ebx
change_BJF_parameters_individual(int pid, char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
8010464f:	83 ec 04             	sub    $0x4,%esp
80104652:	8b 75 08             	mov    0x8(%ebp),%esi
80104655:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465f:	90                   	nop
    if(p->state == UNUSED || p->pid != pid)
80104660:	8b 43 0c             	mov    0xc(%ebx),%eax
80104663:	85 c0                	test   %eax,%eax
80104665:	74 34                	je     8010469b <change_BJF_parameters_individual+0x5b>
80104667:	39 73 10             	cmp    %esi,0x10(%ebx)
8010466a:	75 2f                	jne    8010469b <change_BJF_parameters_individual+0x5b>
    p->priority_ratio = stod(priority_ratio);
8010466c:	83 ec 04             	sub    $0x4,%esp
8010466f:	57                   	push   %edi
80104670:	e8 3b ff ff ff       	call   801045b0 <stod>
80104675:	58                   	pop    %eax
    p->arrival_ratio = stod(arrival_ratio);
80104676:	ff 75 10             	pushl  0x10(%ebp)
    p->priority_ratio = stod(priority_ratio);
80104679:	dd 9b 0c 01 00 00    	fstpl  0x10c(%ebx)
    p->arrival_ratio = stod(arrival_ratio);
8010467f:	e8 2c ff ff ff       	call   801045b0 <stod>
80104684:	5a                   	pop    %edx
    p->executed_cycle_ratio = stod(executed_cycle_ratio);
80104685:	ff 75 14             	pushl  0x14(%ebp)
    p->arrival_ratio = stod(arrival_ratio);
80104688:	dd 9b 14 01 00 00    	fstpl  0x114(%ebx)
    p->executed_cycle_ratio = stod(executed_cycle_ratio);
8010468e:	e8 1d ff ff ff       	call   801045b0 <stod>
80104693:	59                   	pop    %ecx
80104694:	58                   	pop    %eax
80104695:	dd 9b 1c 01 00 00    	fstpl  0x11c(%ebx)
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010469b:	81 c3 24 01 00 00    	add    $0x124,%ebx
801046a1:	81 fb 74 87 11 80    	cmp    $0x80118774,%ebx
801046a7:	75 b7                	jne    80104660 <change_BJF_parameters_individual+0x20>
}
801046a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046ac:	5b                   	pop    %ebx
801046ad:	5e                   	pop    %esi
801046ae:	5f                   	pop    %edi
801046af:	5d                   	pop    %ebp
801046b0:	c3                   	ret    
801046b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046bf:	90                   	nop

801046c0 <change_BJF_parameters_all>:
change_BJF_parameters_all(char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
801046c0:	f3 0f 1e fb          	endbr32 
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	57                   	push   %edi
801046c8:	56                   	push   %esi
801046c9:	53                   	push   %ebx
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046ca:	bb 74 3e 11 80       	mov    $0x80113e74,%ebx
change_BJF_parameters_all(char* priority_ratio, char* arrival_ratio, char* executed_cycle_ratio){
801046cf:	83 ec 04             	sub    $0x4,%esp
801046d2:	8b 7d 08             	mov    0x8(%ebp),%edi
801046d5:	8b 75 0c             	mov    0xc(%ebp),%esi
801046d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop
    if(p->state == UNUSED)
801046e0:	8b 43 0c             	mov    0xc(%ebx),%eax
801046e3:	85 c0                	test   %eax,%eax
801046e5:	74 2e                	je     80104715 <change_BJF_parameters_all+0x55>
    p->priority_ratio = stod(priority_ratio);
801046e7:	83 ec 04             	sub    $0x4,%esp
801046ea:	57                   	push   %edi
801046eb:	e8 c0 fe ff ff       	call   801045b0 <stod>
    p->arrival_ratio = stod(arrival_ratio);
801046f0:	89 34 24             	mov    %esi,(%esp)
    p->priority_ratio = stod(priority_ratio);
801046f3:	dd 9b 0c 01 00 00    	fstpl  0x10c(%ebx)
    p->arrival_ratio = stod(arrival_ratio);
801046f9:	e8 b2 fe ff ff       	call   801045b0 <stod>
801046fe:	58                   	pop    %eax
    p->executed_cycle_ratio = stod(executed_cycle_ratio);
801046ff:	ff 75 10             	pushl  0x10(%ebp)
    p->arrival_ratio = stod(arrival_ratio);
80104702:	dd 9b 14 01 00 00    	fstpl  0x114(%ebx)
    p->executed_cycle_ratio = stod(executed_cycle_ratio);
80104708:	e8 a3 fe ff ff       	call   801045b0 <stod>
8010470d:	5a                   	pop    %edx
8010470e:	59                   	pop    %ecx
8010470f:	dd 9b 1c 01 00 00    	fstpl  0x11c(%ebx)
  for(struct proc* p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104715:	81 c3 24 01 00 00    	add    $0x124,%ebx
8010471b:	81 fb 74 87 11 80    	cmp    $0x80118774,%ebx
80104721:	75 bd                	jne    801046e0 <change_BJF_parameters_all+0x20>
}
80104723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104726:	5b                   	pop    %ebx
80104727:	5e                   	pop    %esi
80104728:	5f                   	pop    %edi
80104729:	5d                   	pop    %ebp
8010472a:	c3                   	ret    
8010472b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010472f:	90                   	nop

80104730 <rand_r>:
{
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	53                   	push   %ebx
80104738:	8b 4d 08             	mov    0x8(%ebp),%ecx
  next *= 1103515245;
8010473b:	69 01 6d 4e c6 41    	imul   $0x41c64e6d,(%ecx),%eax
  next += 12345;
80104741:	05 39 30 00 00       	add    $0x3039,%eax
  next *= 1103515245;
80104746:	69 d0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%edx
  result <<= 10;
8010474c:	c1 e8 06             	shr    $0x6,%eax
8010474f:	25 00 fc 1f 00       	and    $0x1ffc00,%eax
  next += 12345;
80104754:	81 c2 39 30 00 00    	add    $0x3039,%edx
  result ^= (unsigned int) (next / 65536) % 1024;
8010475a:	89 d3                	mov    %edx,%ebx
  next *= 1103515245;
8010475c:	69 d2 6d 4e c6 41    	imul   $0x41c64e6d,%edx,%edx
  result ^= (unsigned int) (next / 65536) % 1024;
80104762:	c1 eb 10             	shr    $0x10,%ebx
80104765:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  next += 12345;
8010476b:	81 c2 39 30 00 00    	add    $0x3039,%edx
  result ^= (unsigned int) (next / 65536) % 1024;
80104771:	09 d8                	or     %ebx,%eax
  result ^= (unsigned int) (next / 65536) % 1024;
80104773:	89 d3                	mov    %edx,%ebx
  result <<= 10;
80104775:	c1 e0 0a             	shl    $0xa,%eax
  *seed = next;
80104778:	89 11                	mov    %edx,(%ecx)
  result ^= (unsigned int) (next / 65536) % 1024;
8010477a:	c1 eb 10             	shr    $0x10,%ebx
8010477d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80104783:	31 d8                	xor    %ebx,%eax
}
80104785:	5b                   	pop    %ebx
80104786:	5d                   	pop    %ebp
80104787:	c3                   	ret    
80104788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop

80104790 <scheduler>:
{
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	57                   	push   %edi
80104798:	56                   	push   %esi
80104799:	53                   	push   %ebx
  unsigned int seed = 1;
8010479a:	bb 01 00 00 00       	mov    $0x1,%ebx
{
8010479f:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c = mycpu();
801047a2:	e8 39 f5 ff ff       	call   80103ce0 <mycpu>
  c->proc = 0;
801047a7:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801047ae:	00 00 00 
  struct cpu *c = mycpu();
801047b1:	89 c7                	mov    %eax,%edi
  unsigned int seed = 1;
801047b3:	8d 40 04             	lea    0x4(%eax),%eax
801047b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  asm volatile("sti");
801047b9:	fb                   	sti    
    int total_tickets = 0;
801047ba:	31 f6                	xor    %esi,%esi
    proc_count[0] = 0;
801047bc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047c3:	b8 74 3e 11 80       	mov    $0x80113e74,%eax
    proc_count[1] = 0;
801047c8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    proc_count[2] = 0;
801047cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    proc_count[3] = 0;
801047d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047dd:	eb 0d                	jmp    801047ec <scheduler+0x5c>
801047df:	90                   	nop
801047e0:	05 24 01 00 00       	add    $0x124,%eax
801047e5:	3d 74 87 11 80       	cmp    $0x80118774,%eax
801047ea:	74 4c                	je     80104838 <scheduler+0xa8>
      if(p->state == RUNNABLE)
801047ec:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801047f0:	75 ee                	jne    801047e0 <scheduler+0x50>
        if (p->age > AGE_THRESH && p->q_level > 1)
801047f2:	81 b8 f8 00 00 00 10 	cmpl   $0x2710,0xf8(%eax)
801047f9:	27 00 00 
801047fc:	8b 90 f0 00 00 00    	mov    0xf0(%eax),%edx
80104802:	7e 18                	jle    8010481c <scheduler+0x8c>
80104804:	83 fa 01             	cmp    $0x1,%edx
80104807:	76 1e                	jbe    80104827 <scheduler+0x97>
          p->age = 0;
80104809:	c7 80 f8 00 00 00 00 	movl   $0x0,0xf8(%eax)
80104810:	00 00 00 
          p->q_level = p->q_level - 1;
80104813:	83 ea 01             	sub    $0x1,%edx
80104816:	89 90 f0 00 00 00    	mov    %edx,0xf0(%eax)
        if(p->q_level == 2)
8010481c:	83 fa 02             	cmp    $0x2,%edx
8010481f:	75 06                	jne    80104827 <scheduler+0x97>
          total_tickets += p->num_tickets;
80104821:	03 b0 f4 00 00 00    	add    0xf4(%eax),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104827:	05 24 01 00 00       	add    $0x124,%eax
        proc_count[p->q_level]++;
8010482c:	83 44 95 d8 01       	addl   $0x1,-0x28(%ebp,%edx,4)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104831:	3d 74 87 11 80       	cmp    $0x80118774,%eax
80104836:	75 b4                	jne    801047ec <scheduler+0x5c>
    acquire(&ptable.lock);
80104838:	83 ec 0c             	sub    $0xc,%esp
8010483b:	68 40 3e 11 80       	push   $0x80113e40
80104840:	e8 db 0b 00 00       	call   80105420 <acquire>
    if(proc_count[1])
80104845:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80104848:	83 c4 10             	add    $0x10,%esp
8010484b:	85 c9                	test   %ecx,%ecx
8010484d:	0f 84 dc 00 00 00    	je     8010492f <scheduler+0x19f>
      for(p = ptable.proc; p < &ptable.proc[NPROC] ; p++){
80104853:	be 74 3e 11 80       	mov    $0x80113e74,%esi
80104858:	eb 18                	jmp    80104872 <scheduler+0xe2>
8010485a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104860:	81 c6 24 01 00 00    	add    $0x124,%esi
80104866:	81 fe 74 87 11 80    	cmp    $0x80118774,%esi
8010486c:	0f 84 a8 00 00 00    	je     8010491a <scheduler+0x18a>
        if(p->state != RUNNABLE || p->q_level != 1)
80104872:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80104876:	75 e8                	jne    80104860 <scheduler+0xd0>
80104878:	83 be f0 00 00 00 01 	cmpl   $0x1,0xf0(%esi)
8010487f:	75 df                	jne    80104860 <scheduler+0xd0>
        for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
80104881:	b8 74 3e 11 80       	mov    $0x80113e74,%eax
80104886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488d:	8d 76 00             	lea    0x0(%esi),%esi
          if(temp_proc->state == RUNNABLE && temp_proc != p)
80104890:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104894:	75 0b                	jne    801048a1 <scheduler+0x111>
80104896:	39 c6                	cmp    %eax,%esi
80104898:	74 07                	je     801048a1 <scheduler+0x111>
            temp_proc->age = temp_proc->age + 1;
8010489a:	83 80 f8 00 00 00 01 	addl   $0x1,0xf8(%eax)
        for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
801048a1:	05 24 01 00 00       	add    $0x124,%eax
801048a6:	3d 74 87 11 80       	cmp    $0x80118774,%eax
801048ab:	75 e3                	jne    80104890 <scheduler+0x100>
        seed = (seed + 1) % 10000;
801048ad:	8d 4b 01             	lea    0x1(%ebx),%ecx
801048b0:	b8 59 17 b7 d1       	mov    $0xd1b71759,%eax
        switchuvm(p);
801048b5:	83 ec 0c             	sub    $0xc,%esp
        p->cycle_count++;
801048b8:	83 86 fc 00 00 00 01 	addl   $0x1,0xfc(%esi)
        seed = (seed + 1) % 10000;
801048bf:	f7 e1                	mul    %ecx
        c->proc = p;
801048c1:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
        switchuvm(p);
801048c7:	56                   	push   %esi
      for(p = ptable.proc; p < &ptable.proc[NPROC] ; p++){
801048c8:	81 c6 24 01 00 00    	add    $0x124,%esi
        seed = (seed + 1) % 10000;
801048ce:	89 d3                	mov    %edx,%ebx
801048d0:	c1 eb 0d             	shr    $0xd,%ebx
801048d3:	69 d3 10 27 00 00    	imul   $0x2710,%ebx,%edx
801048d9:	29 d1                	sub    %edx,%ecx
801048db:	89 cb                	mov    %ecx,%ebx
        switchuvm(p);
801048dd:	e8 0e 32 00 00       	call   80107af0 <switchuvm>
        p->state = RUNNING;
801048e2:	c7 86 e8 fe ff ff 04 	movl   $0x4,-0x118(%esi)
801048e9:	00 00 00 
        swtch(&(c->scheduler), p->context);
801048ec:	58                   	pop    %eax
801048ed:	5a                   	pop    %edx
801048ee:	ff b6 f8 fe ff ff    	pushl  -0x108(%esi)
801048f4:	ff 75 d4             	pushl  -0x2c(%ebp)
801048f7:	e8 57 0e 00 00       	call   80105753 <swtch>
        switchkvm();
801048fc:	e8 cf 31 00 00       	call   80107ad0 <switchkvm>
        c->proc = 0;
80104901:	83 c4 10             	add    $0x10,%esp
80104904:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
8010490b:	00 00 00 
      for(p = ptable.proc; p < &ptable.proc[NPROC] ; p++){
8010490e:	81 fe 74 87 11 80    	cmp    $0x80118774,%esi
80104914:	0f 85 58 ff ff ff    	jne    80104872 <scheduler+0xe2>
      release(&ptable.lock);
8010491a:	83 ec 0c             	sub    $0xc,%esp
8010491d:	68 40 3e 11 80       	push   $0x80113e40
80104922:	e8 b9 0b 00 00       	call   801054e0 <release>
80104927:	83 c4 10             	add    $0x10,%esp
8010492a:	e9 8a fe ff ff       	jmp    801047b9 <scheduler+0x29>
    else if(proc_count[2])
8010492f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104932:	85 c0                	test   %eax,%eax
80104934:	0f 85 1b 01 00 00    	jne    80104a55 <scheduler+0x2c5>
    else if(proc_count[3])
8010493a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010493d:	85 c9                	test   %ecx,%ecx
8010493f:	74 d9                	je     8010491a <scheduler+0x18a>
      double min_rank = 100000;
80104941:	d9 05 74 89 10 80    	flds   0x80108974
      struct proc* run_proc = 0;
80104947:	31 f6                	xor    %esi,%esi
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104949:	b8 74 3e 11 80       	mov    $0x80113e74,%eax
8010494e:	66 90                	xchg   %ax,%ax
        if(p->state != RUNNABLE || p->q_level != 3)
80104950:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104954:	75 4a                	jne    801049a0 <scheduler+0x210>
80104956:	83 b8 f0 00 00 00 03 	cmpl   $0x3,0xf0(%eax)
8010495d:	75 41                	jne    801049a0 <scheduler+0x210>
        double priority = 1 / (double) p->num_tickets;
8010495f:	db 80 f4 00 00 00    	fildl  0xf4(%eax)
80104965:	d8 3d 6c 89 10 80    	fdivrs 0x8010896c
        double rank = (priority * p->priority_ratio) + (p->arrival_time * p->arrival_ratio) \
8010496b:	dc 88 0c 01 00 00    	fmull  0x10c(%eax)
80104971:	db 80 00 01 00 00    	fildl  0x100(%eax)
80104977:	dc 88 14 01 00 00    	fmull  0x114(%eax)
8010497d:	de c1                	faddp  %st,%st(1)
                      + (p->executed_cycle * p->executed_cycle_ratio);
8010497f:	dd 80 04 01 00 00    	fldl   0x104(%eax)
80104985:	dc 88 1c 01 00 00    	fmull  0x11c(%eax)
        double rank = (priority * p->priority_ratio) + (p->arrival_time * p->arrival_ratio) \
8010498b:	de c1                	faddp  %st,%st(1)
8010498d:	d9 c9                	fxch   %st(1)
        if(min_rank > rank)
8010498f:	db f1                	fcomi  %st(1),%st
80104991:	76 06                	jbe    80104999 <scheduler+0x209>
80104993:	dd d8                	fstp   %st(0)
80104995:	89 c6                	mov    %eax,%esi
80104997:	eb 07                	jmp    801049a0 <scheduler+0x210>
80104999:	dd d9                	fstp   %st(1)
8010499b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010499f:	90                   	nop
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049a0:	05 24 01 00 00       	add    $0x124,%eax
801049a5:	3d 74 87 11 80       	cmp    $0x80118774,%eax
801049aa:	75 a4                	jne    80104950 <scheduler+0x1c0>
801049ac:	dd d8                	fstp   %st(0)
      for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
801049ae:	b8 74 3e 11 80       	mov    $0x80113e74,%eax
      if(!run_proc){
801049b3:	85 f6                	test   %esi,%esi
801049b5:	0f 84 5f ff ff ff    	je     8010491a <scheduler+0x18a>
801049bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049bf:	90                   	nop
        if(temp_proc->state == RUNNABLE && temp_proc != run_proc)
801049c0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801049c4:	75 0b                	jne    801049d1 <scheduler+0x241>
801049c6:	39 c6                	cmp    %eax,%esi
801049c8:	74 07                	je     801049d1 <scheduler+0x241>
          temp_proc->age = temp_proc->age + 1;
801049ca:	83 80 f8 00 00 00 01 	addl   $0x1,0xf8(%eax)
      for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
801049d1:	05 24 01 00 00       	add    $0x124,%eax
801049d6:	3d 74 87 11 80       	cmp    $0x80118774,%eax
801049db:	75 e3                	jne    801049c0 <scheduler+0x230>
      seed = (seed + 1) % 10000;
801049dd:	8d 4b 01             	lea    0x1(%ebx),%ecx
801049e0:	b8 59 17 b7 d1       	mov    $0xd1b71759,%eax
      switchuvm(run_proc);
801049e5:	83 ec 0c             	sub    $0xc,%esp
      run_proc->cycle_count++;
801049e8:	83 86 fc 00 00 00 01 	addl   $0x1,0xfc(%esi)
      seed = (seed + 1) % 10000;
801049ef:	f7 e1                	mul    %ecx
      c->proc = run_proc;
801049f1:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
      switchuvm(run_proc);
801049f7:	56                   	push   %esi
      seed = (seed + 1) % 10000;
801049f8:	89 d3                	mov    %edx,%ebx
801049fa:	c1 eb 0d             	shr    $0xd,%ebx
801049fd:	69 db 10 27 00 00    	imul   $0x2710,%ebx,%ebx
80104a03:	29 d9                	sub    %ebx,%ecx
80104a05:	89 cb                	mov    %ecx,%ebx
      switchuvm(run_proc);
80104a07:	e8 e4 30 00 00       	call   80107af0 <switchuvm>
      run_proc->state = RUNNING;
80104a0c:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
      swtch(&(c->scheduler), run_proc->context);
80104a13:	58                   	pop    %eax
80104a14:	5a                   	pop    %edx
80104a15:	ff 76 1c             	pushl  0x1c(%esi)
80104a18:	ff 75 d4             	pushl  -0x2c(%ebp)
80104a1b:	e8 33 0d 00 00       	call   80105753 <swtch>
      switchkvm();
80104a20:	e8 ab 30 00 00       	call   80107ad0 <switchkvm>
      run_proc->executed_cycle += 0.1;
80104a25:	dd 05 60 89 10 80    	fldl   0x80108960
80104a2b:	dc 86 04 01 00 00    	faddl  0x104(%esi)
80104a31:	dd 9e 04 01 00 00    	fstpl  0x104(%esi)
      c->proc = 0;
80104a37:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80104a3e:	00 00 00 
      release(&ptable.lock);
80104a41:	c7 04 24 40 3e 11 80 	movl   $0x80113e40,(%esp)
80104a48:	e8 93 0a 00 00       	call   801054e0 <release>
80104a4d:	83 c4 10             	add    $0x10,%esp
80104a50:	e9 64 fd ff ff       	jmp    801047b9 <scheduler+0x29>
  next *= 1103515245;
80104a55:	69 c3 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%eax
  next += 12345;
80104a5b:	05 39 30 00 00       	add    $0x3039,%eax
  next *= 1103515245;
80104a60:	69 d0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%edx
  result <<= 10;
80104a66:	c1 e8 06             	shr    $0x6,%eax
80104a69:	25 00 fc 1f 00       	and    $0x1ffc00,%eax
  next += 12345;
80104a6e:	81 c2 39 30 00 00    	add    $0x3039,%edx
  result ^= (unsigned int) (next / 65536) % 1024;
80104a74:	89 d3                	mov    %edx,%ebx
80104a76:	c1 eb 10             	shr    $0x10,%ebx
80104a79:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80104a7f:	09 d8                	or     %ebx,%eax
  next *= 1103515245;
80104a81:	69 da 6d 4e c6 41    	imul   $0x41c64e6d,%edx,%ebx
  result ^= (unsigned int) (next / 65536) % 1024;
80104a87:	89 45 d0             	mov    %eax,-0x30(%ebp)
  result <<= 10;
80104a8a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  next *= 1103515245;
80104a8d:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  next += 12345;
80104a90:	81 c3 39 30 00 00    	add    $0x3039,%ebx
  result <<= 10;
80104a96:	c1 e2 0a             	shl    $0xa,%edx
  result ^= (unsigned int) (next / 65536) % 1024;
80104a99:	89 d8                	mov    %ebx,%eax
80104a9b:	c1 e8 10             	shr    $0x10,%eax
80104a9e:	25 ff 03 00 00       	and    $0x3ff,%eax
80104aa3:	31 d0                	xor    %edx,%eax
      int golden_ticket = rand_r(&seed) % total_tickets;
80104aa5:	99                   	cltd   
80104aa6:	f7 fe                	idiv   %esi
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104aa8:	be 74 3e 11 80       	mov    $0x80113e74,%esi
80104aad:	eb 12                	jmp    80104ac1 <scheduler+0x331>
80104aaf:	81 c6 24 01 00 00    	add    $0x124,%esi
80104ab5:	81 fe 74 87 11 80    	cmp    $0x80118774,%esi
80104abb:	0f 84 59 fe ff ff    	je     8010491a <scheduler+0x18a>
        if(p->state != RUNNABLE || p->q_level != 2)
80104ac1:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80104ac5:	75 e8                	jne    80104aaf <scheduler+0x31f>
80104ac7:	83 be f0 00 00 00 02 	cmpl   $0x2,0xf0(%esi)
80104ace:	75 df                	jne    80104aaf <scheduler+0x31f>
        if ((count + p->num_tickets) < golden_ticket)
80104ad0:	03 8e f4 00 00 00    	add    0xf4(%esi),%ecx
80104ad6:	39 d1                	cmp    %edx,%ecx
80104ad8:	7c d5                	jl     80104aaf <scheduler+0x31f>
        for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
80104ada:	b8 74 3e 11 80       	mov    $0x80113e74,%eax
80104adf:	90                   	nop
          if(temp_proc->state == RUNNABLE && temp_proc != p)
80104ae0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104ae4:	75 0b                	jne    80104af1 <scheduler+0x361>
80104ae6:	39 c6                	cmp    %eax,%esi
80104ae8:	74 07                	je     80104af1 <scheduler+0x361>
            temp_proc->age = temp_proc->age + 1;
80104aea:	83 80 f8 00 00 00 01 	addl   $0x1,0xf8(%eax)
        for(temp_proc = ptable.proc; temp_proc < &ptable.proc[NPROC]; temp_proc++)
80104af1:	05 24 01 00 00       	add    $0x124,%eax
80104af6:	3d 74 87 11 80       	cmp    $0x80118774,%eax
80104afb:	75 e3                	jne    80104ae0 <scheduler+0x350>
        seed = (seed + 1) % 10000;
80104afd:	8b 4d cc             	mov    -0x34(%ebp),%ecx
80104b00:	b8 59 17 b7 d1       	mov    $0xd1b71759,%eax
        switchuvm(p);
80104b05:	83 ec 0c             	sub    $0xc,%esp
        p->cycle_count++;
80104b08:	83 86 fc 00 00 00 01 	addl   $0x1,0xfc(%esi)
        c->proc = p;
80104b0f:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
        seed = (seed + 1) % 10000;
80104b15:	81 c1 3a 30 00 00    	add    $0x303a,%ecx
        switchuvm(p);
80104b1b:	56                   	push   %esi
        seed = (seed + 1) % 10000;
80104b1c:	f7 e1                	mul    %ecx
80104b1e:	89 d3                	mov    %edx,%ebx
80104b20:	c1 eb 0d             	shr    $0xd,%ebx
80104b23:	69 db 10 27 00 00    	imul   $0x2710,%ebx,%ebx
80104b29:	29 d9                	sub    %ebx,%ecx
80104b2b:	89 cb                	mov    %ecx,%ebx
        switchuvm(p);
80104b2d:	e8 be 2f 00 00       	call   80107af0 <switchuvm>
        p->state = RUNNING;
80104b32:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
        swtch(&(c->scheduler), p->context);
80104b39:	58                   	pop    %eax
80104b3a:	5a                   	pop    %edx
80104b3b:	ff 76 1c             	pushl  0x1c(%esi)
80104b3e:	ff 75 d4             	pushl  -0x2c(%ebp)
80104b41:	e8 0d 0c 00 00       	call   80105753 <swtch>
        switchkvm();
80104b46:	e8 85 2f 00 00       	call   80107ad0 <switchkvm>
        break;
80104b4b:	83 c4 10             	add    $0x10,%esp
        c->proc = 0;
80104b4e:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80104b55:	00 00 00 
      release(&ptable.lock);
80104b58:	83 ec 0c             	sub    $0xc,%esp
80104b5b:	68 40 3e 11 80       	push   $0x80113e40
80104b60:	e8 7b 09 00 00       	call   801054e0 <release>
80104b65:	83 c4 10             	add    $0x10,%esp
80104b68:	e9 4c fc ff ff       	jmp    801047b9 <scheduler+0x29>
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi

80104b70 <sched>:
{
80104b70:	f3 0f 1e fb          	endbr32 
80104b74:	55                   	push   %ebp
80104b75:	89 e5                	mov    %esp,%ebp
80104b77:	56                   	push   %esi
80104b78:	53                   	push   %ebx
  pushcli();
80104b79:	e8 a2 07 00 00       	call   80105320 <pushcli>
  c = mycpu();
80104b7e:	e8 5d f1 ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80104b83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b89:	e8 e2 07 00 00       	call   80105370 <popcli>
  if(!holding(&ptable.lock))
80104b8e:	83 ec 0c             	sub    $0xc,%esp
80104b91:	68 40 3e 11 80       	push   $0x80113e40
80104b96:	e8 35 08 00 00       	call   801053d0 <holding>
80104b9b:	83 c4 10             	add    $0x10,%esp
80104b9e:	85 c0                	test   %eax,%eax
80104ba0:	74 4f                	je     80104bf1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104ba2:	e8 39 f1 ff ff       	call   80103ce0 <mycpu>
80104ba7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80104bae:	75 68                	jne    80104c18 <sched+0xa8>
  if(p->state == RUNNING)
80104bb0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104bb4:	74 55                	je     80104c0b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bb6:	9c                   	pushf  
80104bb7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104bb8:	f6 c4 02             	test   $0x2,%ah
80104bbb:	75 41                	jne    80104bfe <sched+0x8e>
  intena = mycpu()->intena;
80104bbd:	e8 1e f1 ff ff       	call   80103ce0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104bc2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104bc5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104bcb:	e8 10 f1 ff ff       	call   80103ce0 <mycpu>
80104bd0:	83 ec 08             	sub    $0x8,%esp
80104bd3:	ff 70 04             	pushl  0x4(%eax)
80104bd6:	53                   	push   %ebx
80104bd7:	e8 77 0b 00 00       	call   80105753 <swtch>
  mycpu()->intena = intena;
80104bdc:	e8 ff f0 ff ff       	call   80103ce0 <mycpu>
}
80104be1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104be4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104bea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bed:	5b                   	pop    %ebx
80104bee:	5e                   	pop    %esi
80104bef:	5d                   	pop    %ebp
80104bf0:	c3                   	ret    
    panic("sched ptable.lock");
80104bf1:	83 ec 0c             	sub    $0xc,%esp
80104bf4:	68 f6 87 10 80       	push   $0x801087f6
80104bf9:	e8 92 b7 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80104bfe:	83 ec 0c             	sub    $0xc,%esp
80104c01:	68 22 88 10 80       	push   $0x80108822
80104c06:	e8 85 b7 ff ff       	call   80100390 <panic>
    panic("sched running");
80104c0b:	83 ec 0c             	sub    $0xc,%esp
80104c0e:	68 14 88 10 80       	push   $0x80108814
80104c13:	e8 78 b7 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104c18:	83 ec 0c             	sub    $0xc,%esp
80104c1b:	68 08 88 10 80       	push   $0x80108808
80104c20:	e8 6b b7 ff ff       	call   80100390 <panic>
80104c25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c30 <exit>:
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	57                   	push   %edi
80104c38:	56                   	push   %esi
80104c39:	53                   	push   %ebx
80104c3a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104c3d:	e8 de 06 00 00       	call   80105320 <pushcli>
  c = mycpu();
80104c42:	e8 99 f0 ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80104c47:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104c4d:	e8 1e 07 00 00       	call   80105370 <popcli>
  if(curproc == initproc)
80104c52:	8d 5e 28             	lea    0x28(%esi),%ebx
80104c55:	8d 7e 68             	lea    0x68(%esi),%edi
80104c58:	39 35 38 b6 10 80    	cmp    %esi,0x8010b638
80104c5e:	0f 84 fd 00 00 00    	je     80104d61 <exit+0x131>
80104c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104c68:	8b 03                	mov    (%ebx),%eax
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	74 12                	je     80104c80 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80104c6e:	83 ec 0c             	sub    $0xc,%esp
80104c71:	50                   	push   %eax
80104c72:	e8 b9 c5 ff ff       	call   80101230 <fileclose>
      curproc->ofile[fd] = 0;
80104c77:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104c7d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104c80:	83 c3 04             	add    $0x4,%ebx
80104c83:	39 df                	cmp    %ebx,%edi
80104c85:	75 e1                	jne    80104c68 <exit+0x38>
  begin_op();
80104c87:	e8 14 e4 ff ff       	call   801030a0 <begin_op>
  iput(curproc->cwd);
80104c8c:	83 ec 0c             	sub    $0xc,%esp
80104c8f:	ff 76 68             	pushl  0x68(%esi)
80104c92:	e8 69 cf ff ff       	call   80101c00 <iput>
  end_op();
80104c97:	e8 74 e4 ff ff       	call   80103110 <end_op>
  curproc->cwd = 0;
80104c9c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104ca3:	c7 04 24 40 3e 11 80 	movl   $0x80113e40,(%esp)
80104caa:	e8 71 07 00 00       	call   80105420 <acquire>
  wakeup1(curproc->parent);
80104caf:	8b 56 14             	mov    0x14(%esi),%edx
80104cb2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cb5:	b8 74 3e 11 80       	mov    $0x80113e74,%eax
80104cba:	eb 10                	jmp    80104ccc <exit+0x9c>
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cc0:	05 24 01 00 00       	add    $0x124,%eax
80104cc5:	3d 74 87 11 80       	cmp    $0x80118774,%eax
80104cca:	74 1e                	je     80104cea <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80104ccc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104cd0:	75 ee                	jne    80104cc0 <exit+0x90>
80104cd2:	3b 50 20             	cmp    0x20(%eax),%edx
80104cd5:	75 e9                	jne    80104cc0 <exit+0x90>
      p->state = RUNNABLE;
80104cd7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cde:	05 24 01 00 00       	add    $0x124,%eax
80104ce3:	3d 74 87 11 80       	cmp    $0x80118774,%eax
80104ce8:	75 e2                	jne    80104ccc <exit+0x9c>
      p->parent = initproc;
80104cea:	8b 0d 38 b6 10 80    	mov    0x8010b638,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cf0:	ba 74 3e 11 80       	mov    $0x80113e74,%edx
80104cf5:	eb 17                	jmp    80104d0e <exit+0xde>
80104cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfe:	66 90                	xchg   %ax,%ax
80104d00:	81 c2 24 01 00 00    	add    $0x124,%edx
80104d06:	81 fa 74 87 11 80    	cmp    $0x80118774,%edx
80104d0c:	74 3a                	je     80104d48 <exit+0x118>
    if(p->parent == curproc){
80104d0e:	39 72 14             	cmp    %esi,0x14(%edx)
80104d11:	75 ed                	jne    80104d00 <exit+0xd0>
      if(p->state == ZOMBIE)
80104d13:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104d17:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104d1a:	75 e4                	jne    80104d00 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d1c:	b8 74 3e 11 80       	mov    $0x80113e74,%eax
80104d21:	eb 11                	jmp    80104d34 <exit+0x104>
80104d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d27:	90                   	nop
80104d28:	05 24 01 00 00       	add    $0x124,%eax
80104d2d:	3d 74 87 11 80       	cmp    $0x80118774,%eax
80104d32:	74 cc                	je     80104d00 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104d34:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104d38:	75 ee                	jne    80104d28 <exit+0xf8>
80104d3a:	3b 48 20             	cmp    0x20(%eax),%ecx
80104d3d:	75 e9                	jne    80104d28 <exit+0xf8>
      p->state = RUNNABLE;
80104d3f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104d46:	eb e0                	jmp    80104d28 <exit+0xf8>
  curproc->state = ZOMBIE;
80104d48:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104d4f:	e8 1c fe ff ff       	call   80104b70 <sched>
  panic("zombie exit");
80104d54:	83 ec 0c             	sub    $0xc,%esp
80104d57:	68 43 88 10 80       	push   $0x80108843
80104d5c:	e8 2f b6 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104d61:	83 ec 0c             	sub    $0xc,%esp
80104d64:	68 36 88 10 80       	push   $0x80108836
80104d69:	e8 22 b6 ff ff       	call   80100390 <panic>
80104d6e:	66 90                	xchg   %ax,%ax

80104d70 <yield>:
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	53                   	push   %ebx
80104d78:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104d7b:	68 40 3e 11 80       	push   $0x80113e40
80104d80:	e8 9b 06 00 00       	call   80105420 <acquire>
  pushcli();
80104d85:	e8 96 05 00 00       	call   80105320 <pushcli>
  c = mycpu();
80104d8a:	e8 51 ef ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80104d8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d95:	e8 d6 05 00 00       	call   80105370 <popcli>
  myproc()->state = RUNNABLE;
80104d9a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104da1:	e8 ca fd ff ff       	call   80104b70 <sched>
  release(&ptable.lock);
80104da6:	c7 04 24 40 3e 11 80 	movl   $0x80113e40,(%esp)
80104dad:	e8 2e 07 00 00       	call   801054e0 <release>
}
80104db2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104db5:	83 c4 10             	add    $0x10,%esp
80104db8:	c9                   	leave  
80104db9:	c3                   	ret    
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dc0 <sleep>:
{
80104dc0:	f3 0f 1e fb          	endbr32 
80104dc4:	55                   	push   %ebp
80104dc5:	89 e5                	mov    %esp,%ebp
80104dc7:	57                   	push   %edi
80104dc8:	56                   	push   %esi
80104dc9:	53                   	push   %ebx
80104dca:	83 ec 0c             	sub    $0xc,%esp
80104dcd:	8b 7d 08             	mov    0x8(%ebp),%edi
80104dd0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104dd3:	e8 48 05 00 00       	call   80105320 <pushcli>
  c = mycpu();
80104dd8:	e8 03 ef ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80104ddd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104de3:	e8 88 05 00 00       	call   80105370 <popcli>
  if(p == 0)
80104de8:	85 db                	test   %ebx,%ebx
80104dea:	0f 84 83 00 00 00    	je     80104e73 <sleep+0xb3>
  if(lk == 0)
80104df0:	85 f6                	test   %esi,%esi
80104df2:	74 72                	je     80104e66 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104df4:	81 fe 40 3e 11 80    	cmp    $0x80113e40,%esi
80104dfa:	74 4c                	je     80104e48 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104dfc:	83 ec 0c             	sub    $0xc,%esp
80104dff:	68 40 3e 11 80       	push   $0x80113e40
80104e04:	e8 17 06 00 00       	call   80105420 <acquire>
    release(lk);
80104e09:	89 34 24             	mov    %esi,(%esp)
80104e0c:	e8 cf 06 00 00       	call   801054e0 <release>
  p->chan = chan;
80104e11:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104e14:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104e1b:	e8 50 fd ff ff       	call   80104b70 <sched>
  p->chan = 0;
80104e20:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104e27:	c7 04 24 40 3e 11 80 	movl   $0x80113e40,(%esp)
80104e2e:	e8 ad 06 00 00       	call   801054e0 <release>
    acquire(lk);
80104e33:	89 75 08             	mov    %esi,0x8(%ebp)
80104e36:	83 c4 10             	add    $0x10,%esp
}
80104e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e3c:	5b                   	pop    %ebx
80104e3d:	5e                   	pop    %esi
80104e3e:	5f                   	pop    %edi
80104e3f:	5d                   	pop    %ebp
    acquire(lk);
80104e40:	e9 db 05 00 00       	jmp    80105420 <acquire>
80104e45:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104e48:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104e4b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104e52:	e8 19 fd ff ff       	call   80104b70 <sched>
  p->chan = 0;
80104e57:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e61:	5b                   	pop    %ebx
80104e62:	5e                   	pop    %esi
80104e63:	5f                   	pop    %edi
80104e64:	5d                   	pop    %ebp
80104e65:	c3                   	ret    
    panic("sleep without lk");
80104e66:	83 ec 0c             	sub    $0xc,%esp
80104e69:	68 55 88 10 80       	push   $0x80108855
80104e6e:	e8 1d b5 ff ff       	call   80100390 <panic>
    panic("sleep");
80104e73:	83 ec 0c             	sub    $0xc,%esp
80104e76:	68 4f 88 10 80       	push   $0x8010884f
80104e7b:	e8 10 b5 ff ff       	call   80100390 <panic>

80104e80 <wait>:
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	56                   	push   %esi
80104e88:	53                   	push   %ebx
  pushcli();
80104e89:	e8 92 04 00 00       	call   80105320 <pushcli>
  c = mycpu();
80104e8e:	e8 4d ee ff ff       	call   80103ce0 <mycpu>
  p = c->proc;
80104e93:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104e99:	e8 d2 04 00 00       	call   80105370 <popcli>
  acquire(&ptable.lock);
80104e9e:	83 ec 0c             	sub    $0xc,%esp
80104ea1:	68 40 3e 11 80       	push   $0x80113e40
80104ea6:	e8 75 05 00 00       	call   80105420 <acquire>
80104eab:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104eae:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eb0:	bb 74 3e 11 80       	mov    $0x80113e74,%ebx
80104eb5:	eb 17                	jmp    80104ece <wait+0x4e>
80104eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebe:	66 90                	xchg   %ax,%ax
80104ec0:	81 c3 24 01 00 00    	add    $0x124,%ebx
80104ec6:	81 fb 74 87 11 80    	cmp    $0x80118774,%ebx
80104ecc:	74 1e                	je     80104eec <wait+0x6c>
      if(p->parent != curproc)
80104ece:	39 73 14             	cmp    %esi,0x14(%ebx)
80104ed1:	75 ed                	jne    80104ec0 <wait+0x40>
      if(p->state == ZOMBIE){
80104ed3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104ed7:	74 37                	je     80104f10 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ed9:	81 c3 24 01 00 00    	add    $0x124,%ebx
      havekids = 1;
80104edf:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ee4:	81 fb 74 87 11 80    	cmp    $0x80118774,%ebx
80104eea:	75 e2                	jne    80104ece <wait+0x4e>
    if(!havekids || curproc->killed){
80104eec:	85 c0                	test   %eax,%eax
80104eee:	74 76                	je     80104f66 <wait+0xe6>
80104ef0:	8b 46 24             	mov    0x24(%esi),%eax
80104ef3:	85 c0                	test   %eax,%eax
80104ef5:	75 6f                	jne    80104f66 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104ef7:	83 ec 08             	sub    $0x8,%esp
80104efa:	68 40 3e 11 80       	push   $0x80113e40
80104eff:	56                   	push   %esi
80104f00:	e8 bb fe ff ff       	call   80104dc0 <sleep>
    havekids = 0;
80104f05:	83 c4 10             	add    $0x10,%esp
80104f08:	eb a4                	jmp    80104eae <wait+0x2e>
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104f10:	83 ec 0c             	sub    $0xc,%esp
80104f13:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104f16:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104f19:	e8 c2 d8 ff ff       	call   801027e0 <kfree>
        freevm(p->pgdir);
80104f1e:	5a                   	pop    %edx
80104f1f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104f22:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104f29:	e8 82 2f 00 00       	call   80107eb0 <freevm>
        release(&ptable.lock);
80104f2e:	c7 04 24 40 3e 11 80 	movl   $0x80113e40,(%esp)
        p->pid = 0;
80104f35:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104f3c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104f43:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104f47:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104f4e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104f55:	e8 86 05 00 00       	call   801054e0 <release>
        return pid;
80104f5a:	83 c4 10             	add    $0x10,%esp
}
80104f5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f60:	89 f0                	mov    %esi,%eax
80104f62:	5b                   	pop    %ebx
80104f63:	5e                   	pop    %esi
80104f64:	5d                   	pop    %ebp
80104f65:	c3                   	ret    
      release(&ptable.lock);
80104f66:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104f69:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104f6e:	68 40 3e 11 80       	push   $0x80113e40
80104f73:	e8 68 05 00 00       	call   801054e0 <release>
      return -1;
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	eb e0                	jmp    80104f5d <wait+0xdd>
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi

80104f80 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
80104f85:	89 e5                	mov    %esp,%ebp
80104f87:	53                   	push   %ebx
80104f88:	83 ec 10             	sub    $0x10,%esp
80104f8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104f8e:	68 40 3e 11 80       	push   $0x80113e40
80104f93:	e8 88 04 00 00       	call   80105420 <acquire>
80104f98:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f9b:	b8 74 3e 11 80       	mov    $0x80113e74,%eax
80104fa0:	eb 12                	jmp    80104fb4 <wakeup+0x34>
80104fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fa8:	05 24 01 00 00       	add    $0x124,%eax
80104fad:	3d 74 87 11 80       	cmp    $0x80118774,%eax
80104fb2:	74 1e                	je     80104fd2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104fb4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104fb8:	75 ee                	jne    80104fa8 <wakeup+0x28>
80104fba:	3b 58 20             	cmp    0x20(%eax),%ebx
80104fbd:	75 e9                	jne    80104fa8 <wakeup+0x28>
      p->state = RUNNABLE;
80104fbf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fc6:	05 24 01 00 00       	add    $0x124,%eax
80104fcb:	3d 74 87 11 80       	cmp    $0x80118774,%eax
80104fd0:	75 e2                	jne    80104fb4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104fd2:	c7 45 08 40 3e 11 80 	movl   $0x80113e40,0x8(%ebp)
}
80104fd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fdc:	c9                   	leave  
  release(&ptable.lock);
80104fdd:	e9 fe 04 00 00       	jmp    801054e0 <release>
80104fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ff0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	53                   	push   %ebx
80104ff8:	83 ec 10             	sub    $0x10,%esp
80104ffb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104ffe:	68 40 3e 11 80       	push   $0x80113e40
80105003:	e8 18 04 00 00       	call   80105420 <acquire>
80105008:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010500b:	b8 74 3e 11 80       	mov    $0x80113e74,%eax
80105010:	eb 12                	jmp    80105024 <kill+0x34>
80105012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105018:	05 24 01 00 00       	add    $0x124,%eax
8010501d:	3d 74 87 11 80       	cmp    $0x80118774,%eax
80105022:	74 34                	je     80105058 <kill+0x68>
    if(p->pid == pid){
80105024:	39 58 10             	cmp    %ebx,0x10(%eax)
80105027:	75 ef                	jne    80105018 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105029:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010502d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80105034:	75 07                	jne    8010503d <kill+0x4d>
        p->state = RUNNABLE;
80105036:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010503d:	83 ec 0c             	sub    $0xc,%esp
80105040:	68 40 3e 11 80       	push   $0x80113e40
80105045:	e8 96 04 00 00       	call   801054e0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010504a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010504d:	83 c4 10             	add    $0x10,%esp
80105050:	31 c0                	xor    %eax,%eax
}
80105052:	c9                   	leave  
80105053:	c3                   	ret    
80105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105058:	83 ec 0c             	sub    $0xc,%esp
8010505b:	68 40 3e 11 80       	push   $0x80113e40
80105060:	e8 7b 04 00 00       	call   801054e0 <release>
}
80105065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80105068:	83 c4 10             	add    $0x10,%esp
8010506b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105070:	c9                   	leave  
80105071:	c3                   	ret    
80105072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105080 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
80105085:	89 e5                	mov    %esp,%ebp
80105087:	57                   	push   %edi
80105088:	56                   	push   %esi
80105089:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010508c:	53                   	push   %ebx
8010508d:	bb e0 3e 11 80       	mov    $0x80113ee0,%ebx
80105092:	83 ec 3c             	sub    $0x3c,%esp
80105095:	eb 2b                	jmp    801050c2 <procdump+0x42>
80105097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801050a0:	83 ec 0c             	sub    $0xc,%esp
801050a3:	68 97 8c 10 80       	push   $0x80108c97
801050a8:	e8 03 b6 ff ff       	call   801006b0 <cprintf>
801050ad:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050b0:	81 c3 24 01 00 00    	add    $0x124,%ebx
801050b6:	81 fb e0 87 11 80    	cmp    $0x801187e0,%ebx
801050bc:	0f 84 8e 00 00 00    	je     80105150 <procdump+0xd0>
    if(p->state == UNUSED)
801050c2:	8b 43 a0             	mov    -0x60(%ebx),%eax
801050c5:	85 c0                	test   %eax,%eax
801050c7:	74 e7                	je     801050b0 <procdump+0x30>
      state = "???";
801050c9:	ba 66 88 10 80       	mov    $0x80108866,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801050ce:	83 f8 05             	cmp    $0x5,%eax
801050d1:	77 11                	ja     801050e4 <procdump+0x64>
801050d3:	8b 14 85 3c 89 10 80 	mov    -0x7fef76c4(,%eax,4),%edx
      state = "???";
801050da:	b8 66 88 10 80       	mov    $0x80108866,%eax
801050df:	85 d2                	test   %edx,%edx
801050e1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801050e4:	53                   	push   %ebx
801050e5:	52                   	push   %edx
801050e6:	ff 73 a4             	pushl  -0x5c(%ebx)
801050e9:	68 6a 88 10 80       	push   $0x8010886a
801050ee:	e8 bd b5 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801050fa:	75 a4                	jne    801050a0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801050fc:	83 ec 08             	sub    $0x8,%esp
801050ff:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105102:	8d 7d c0             	lea    -0x40(%ebp),%edi
80105105:	50                   	push   %eax
80105106:	8b 43 b0             	mov    -0x50(%ebx),%eax
80105109:	8b 40 0c             	mov    0xc(%eax),%eax
8010510c:	83 c0 08             	add    $0x8,%eax
8010510f:	50                   	push   %eax
80105110:	e8 ab 01 00 00       	call   801052c0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80105115:	83 c4 10             	add    $0x10,%esp
80105118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511f:	90                   	nop
80105120:	8b 17                	mov    (%edi),%edx
80105122:	85 d2                	test   %edx,%edx
80105124:	0f 84 76 ff ff ff    	je     801050a0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010512a:	83 ec 08             	sub    $0x8,%esp
8010512d:	83 c7 04             	add    $0x4,%edi
80105130:	52                   	push   %edx
80105131:	68 01 82 10 80       	push   $0x80108201
80105136:	e8 75 b5 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010513b:	83 c4 10             	add    $0x10,%esp
8010513e:	39 fe                	cmp    %edi,%esi
80105140:	75 de                	jne    80105120 <procdump+0xa0>
80105142:	e9 59 ff ff ff       	jmp    801050a0 <procdump+0x20>
80105147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514e:	66 90                	xchg   %ax,%ax
  }
}
80105150:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105153:	5b                   	pop    %ebx
80105154:	5e                   	pop    %esi
80105155:	5f                   	pop    %edi
80105156:	5d                   	pop    %ebp
80105157:	c3                   	ret    
80105158:	66 90                	xchg   %ax,%ax
8010515a:	66 90                	xchg   %ax,%ax
8010515c:	66 90                	xchg   %ax,%ax
8010515e:	66 90                	xchg   %ax,%ax

80105160 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	53                   	push   %ebx
80105168:	83 ec 0c             	sub    $0xc,%esp
8010516b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010516e:	68 78 89 10 80       	push   $0x80108978
80105173:	8d 43 04             	lea    0x4(%ebx),%eax
80105176:	50                   	push   %eax
80105177:	e8 24 01 00 00       	call   801052a0 <initlock>
  lk->name = name;
8010517c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010517f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105185:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105188:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010518f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80105192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105195:	c9                   	leave  
80105196:	c3                   	ret    
80105197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519e:	66 90                	xchg   %ax,%ax

801051a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801051a0:	f3 0f 1e fb          	endbr32 
801051a4:	55                   	push   %ebp
801051a5:	89 e5                	mov    %esp,%ebp
801051a7:	56                   	push   %esi
801051a8:	53                   	push   %ebx
801051a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801051ac:	8d 73 04             	lea    0x4(%ebx),%esi
801051af:	83 ec 0c             	sub    $0xc,%esp
801051b2:	56                   	push   %esi
801051b3:	e8 68 02 00 00       	call   80105420 <acquire>
  while (lk->locked) {
801051b8:	8b 13                	mov    (%ebx),%edx
801051ba:	83 c4 10             	add    $0x10,%esp
801051bd:	85 d2                	test   %edx,%edx
801051bf:	74 1a                	je     801051db <acquiresleep+0x3b>
801051c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801051c8:	83 ec 08             	sub    $0x8,%esp
801051cb:	56                   	push   %esi
801051cc:	53                   	push   %ebx
801051cd:	e8 ee fb ff ff       	call   80104dc0 <sleep>
  while (lk->locked) {
801051d2:	8b 03                	mov    (%ebx),%eax
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	75 ed                	jne    801051c8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801051db:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801051e1:	e8 ba eb ff ff       	call   80103da0 <myproc>
801051e6:	8b 40 10             	mov    0x10(%eax),%eax
801051e9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801051ec:	89 75 08             	mov    %esi,0x8(%ebp)
}
801051ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051f2:	5b                   	pop    %ebx
801051f3:	5e                   	pop    %esi
801051f4:	5d                   	pop    %ebp
  release(&lk->lk);
801051f5:	e9 e6 02 00 00       	jmp    801054e0 <release>
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105200 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	56                   	push   %esi
80105208:	53                   	push   %ebx
80105209:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010520c:	8d 73 04             	lea    0x4(%ebx),%esi
8010520f:	83 ec 0c             	sub    $0xc,%esp
80105212:	56                   	push   %esi
80105213:	e8 08 02 00 00       	call   80105420 <acquire>
  lk->locked = 0;
80105218:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010521e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105225:	89 1c 24             	mov    %ebx,(%esp)
80105228:	e8 53 fd ff ff       	call   80104f80 <wakeup>
  release(&lk->lk);
8010522d:	89 75 08             	mov    %esi,0x8(%ebp)
80105230:	83 c4 10             	add    $0x10,%esp
}
80105233:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105236:	5b                   	pop    %ebx
80105237:	5e                   	pop    %esi
80105238:	5d                   	pop    %ebp
  release(&lk->lk);
80105239:	e9 a2 02 00 00       	jmp    801054e0 <release>
8010523e:	66 90                	xchg   %ax,%ax

80105240 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105240:	f3 0f 1e fb          	endbr32 
80105244:	55                   	push   %ebp
80105245:	89 e5                	mov    %esp,%ebp
80105247:	57                   	push   %edi
80105248:	31 ff                	xor    %edi,%edi
8010524a:	56                   	push   %esi
8010524b:	53                   	push   %ebx
8010524c:	83 ec 18             	sub    $0x18,%esp
8010524f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80105252:	8d 73 04             	lea    0x4(%ebx),%esi
80105255:	56                   	push   %esi
80105256:	e8 c5 01 00 00       	call   80105420 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010525b:	8b 03                	mov    (%ebx),%eax
8010525d:	83 c4 10             	add    $0x10,%esp
80105260:	85 c0                	test   %eax,%eax
80105262:	75 1c                	jne    80105280 <holdingsleep+0x40>
  release(&lk->lk);
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	56                   	push   %esi
80105268:	e8 73 02 00 00       	call   801054e0 <release>
  return r;
}
8010526d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105270:	89 f8                	mov    %edi,%eax
80105272:	5b                   	pop    %ebx
80105273:	5e                   	pop    %esi
80105274:	5f                   	pop    %edi
80105275:	5d                   	pop    %ebp
80105276:	c3                   	ret    
80105277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80105280:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105283:	e8 18 eb ff ff       	call   80103da0 <myproc>
80105288:	39 58 10             	cmp    %ebx,0x10(%eax)
8010528b:	0f 94 c0             	sete   %al
8010528e:	0f b6 c0             	movzbl %al,%eax
80105291:	89 c7                	mov    %eax,%edi
80105293:	eb cf                	jmp    80105264 <holdingsleep+0x24>
80105295:	66 90                	xchg   %ax,%ax
80105297:	66 90                	xchg   %ax,%ax
80105299:	66 90                	xchg   %ax,%ax
8010529b:	66 90                	xchg   %ax,%ax
8010529d:	66 90                	xchg   %ax,%ax
8010529f:	90                   	nop

801052a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801052a0:	f3 0f 1e fb          	endbr32 
801052a4:	55                   	push   %ebp
801052a5:	89 e5                	mov    %esp,%ebp
801052a7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801052aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801052ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801052b3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801052b6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801052bd:	5d                   	pop    %ebp
801052be:	c3                   	ret    
801052bf:	90                   	nop

801052c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801052c0:	f3 0f 1e fb          	endbr32 
801052c4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801052c5:	31 d2                	xor    %edx,%edx
{
801052c7:	89 e5                	mov    %esp,%ebp
801052c9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801052ca:	8b 45 08             	mov    0x8(%ebp),%eax
{
801052cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801052d0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801052d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052d7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801052d8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801052de:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801052e4:	77 1a                	ja     80105300 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801052e6:	8b 58 04             	mov    0x4(%eax),%ebx
801052e9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801052ec:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801052ef:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801052f1:	83 fa 0a             	cmp    $0xa,%edx
801052f4:	75 e2                	jne    801052d8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801052f6:	5b                   	pop    %ebx
801052f7:	5d                   	pop    %ebp
801052f8:	c3                   	ret    
801052f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105300:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105303:	8d 51 28             	lea    0x28(%ecx),%edx
80105306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105316:	83 c0 04             	add    $0x4,%eax
80105319:	39 d0                	cmp    %edx,%eax
8010531b:	75 f3                	jne    80105310 <getcallerpcs+0x50>
}
8010531d:	5b                   	pop    %ebx
8010531e:	5d                   	pop    %ebp
8010531f:	c3                   	ret    

80105320 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
80105325:	89 e5                	mov    %esp,%ebp
80105327:	53                   	push   %ebx
80105328:	83 ec 04             	sub    $0x4,%esp
8010532b:	9c                   	pushf  
8010532c:	5b                   	pop    %ebx
  asm volatile("cli");
8010532d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010532e:	e8 ad e9 ff ff       	call   80103ce0 <mycpu>
80105333:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105339:	85 c0                	test   %eax,%eax
8010533b:	74 13                	je     80105350 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010533d:	e8 9e e9 ff ff       	call   80103ce0 <mycpu>
80105342:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105349:	83 c4 04             	add    $0x4,%esp
8010534c:	5b                   	pop    %ebx
8010534d:	5d                   	pop    %ebp
8010534e:	c3                   	ret    
8010534f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80105350:	e8 8b e9 ff ff       	call   80103ce0 <mycpu>
80105355:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010535b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105361:	eb da                	jmp    8010533d <pushcli+0x1d>
80105363:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105370 <popcli>:

void
popcli(void)
{
80105370:	f3 0f 1e fb          	endbr32 
80105374:	55                   	push   %ebp
80105375:	89 e5                	mov    %esp,%ebp
80105377:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010537a:	9c                   	pushf  
8010537b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010537c:	f6 c4 02             	test   $0x2,%ah
8010537f:	75 31                	jne    801053b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105381:	e8 5a e9 ff ff       	call   80103ce0 <mycpu>
80105386:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010538d:	78 30                	js     801053bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010538f:	e8 4c e9 ff ff       	call   80103ce0 <mycpu>
80105394:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010539a:	85 d2                	test   %edx,%edx
8010539c:	74 02                	je     801053a0 <popcli+0x30>
    sti();
}
8010539e:	c9                   	leave  
8010539f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801053a0:	e8 3b e9 ff ff       	call   80103ce0 <mycpu>
801053a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801053ab:	85 c0                	test   %eax,%eax
801053ad:	74 ef                	je     8010539e <popcli+0x2e>
  asm volatile("sti");
801053af:	fb                   	sti    
}
801053b0:	c9                   	leave  
801053b1:	c3                   	ret    
    panic("popcli - interruptible");
801053b2:	83 ec 0c             	sub    $0xc,%esp
801053b5:	68 83 89 10 80       	push   $0x80108983
801053ba:	e8 d1 af ff ff       	call   80100390 <panic>
    panic("popcli");
801053bf:	83 ec 0c             	sub    $0xc,%esp
801053c2:	68 9a 89 10 80       	push   $0x8010899a
801053c7:	e8 c4 af ff ff       	call   80100390 <panic>
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053d0 <holding>:
{
801053d0:	f3 0f 1e fb          	endbr32 
801053d4:	55                   	push   %ebp
801053d5:	89 e5                	mov    %esp,%ebp
801053d7:	56                   	push   %esi
801053d8:	53                   	push   %ebx
801053d9:	8b 75 08             	mov    0x8(%ebp),%esi
801053dc:	31 db                	xor    %ebx,%ebx
  pushcli();
801053de:	e8 3d ff ff ff       	call   80105320 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801053e3:	8b 06                	mov    (%esi),%eax
801053e5:	85 c0                	test   %eax,%eax
801053e7:	75 0f                	jne    801053f8 <holding+0x28>
  popcli();
801053e9:	e8 82 ff ff ff       	call   80105370 <popcli>
}
801053ee:	89 d8                	mov    %ebx,%eax
801053f0:	5b                   	pop    %ebx
801053f1:	5e                   	pop    %esi
801053f2:	5d                   	pop    %ebp
801053f3:	c3                   	ret    
801053f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
801053f8:	8b 5e 08             	mov    0x8(%esi),%ebx
801053fb:	e8 e0 e8 ff ff       	call   80103ce0 <mycpu>
80105400:	39 c3                	cmp    %eax,%ebx
80105402:	0f 94 c3             	sete   %bl
  popcli();
80105405:	e8 66 ff ff ff       	call   80105370 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010540a:	0f b6 db             	movzbl %bl,%ebx
}
8010540d:	89 d8                	mov    %ebx,%eax
8010540f:	5b                   	pop    %ebx
80105410:	5e                   	pop    %esi
80105411:	5d                   	pop    %ebp
80105412:	c3                   	ret    
80105413:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105420 <acquire>:
{
80105420:	f3 0f 1e fb          	endbr32 
80105424:	55                   	push   %ebp
80105425:	89 e5                	mov    %esp,%ebp
80105427:	56                   	push   %esi
80105428:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105429:	e8 f2 fe ff ff       	call   80105320 <pushcli>
  if(holding(lk))
8010542e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105431:	83 ec 0c             	sub    $0xc,%esp
80105434:	53                   	push   %ebx
80105435:	e8 96 ff ff ff       	call   801053d0 <holding>
8010543a:	83 c4 10             	add    $0x10,%esp
8010543d:	85 c0                	test   %eax,%eax
8010543f:	0f 85 7f 00 00 00    	jne    801054c4 <acquire+0xa4>
80105445:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105447:	ba 01 00 00 00       	mov    $0x1,%edx
8010544c:	eb 05                	jmp    80105453 <acquire+0x33>
8010544e:	66 90                	xchg   %ax,%ax
80105450:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105453:	89 d0                	mov    %edx,%eax
80105455:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105458:	85 c0                	test   %eax,%eax
8010545a:	75 f4                	jne    80105450 <acquire+0x30>
  __sync_synchronize();
8010545c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105461:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105464:	e8 77 e8 ff ff       	call   80103ce0 <mycpu>
80105469:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010546c:	89 e8                	mov    %ebp,%eax
8010546e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105470:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80105476:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010547c:	77 22                	ja     801054a0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010547e:	8b 50 04             	mov    0x4(%eax),%edx
80105481:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105485:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105488:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010548a:	83 fe 0a             	cmp    $0xa,%esi
8010548d:	75 e1                	jne    80105470 <acquire+0x50>
}
8010548f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105492:	5b                   	pop    %ebx
80105493:	5e                   	pop    %esi
80105494:	5d                   	pop    %ebp
80105495:	c3                   	ret    
80105496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010549d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801054a0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801054a4:	83 c3 34             	add    $0x34,%ebx
801054a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801054b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801054b6:	83 c0 04             	add    $0x4,%eax
801054b9:	39 d8                	cmp    %ebx,%eax
801054bb:	75 f3                	jne    801054b0 <acquire+0x90>
}
801054bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054c0:	5b                   	pop    %ebx
801054c1:	5e                   	pop    %esi
801054c2:	5d                   	pop    %ebp
801054c3:	c3                   	ret    
    panic("acquire");
801054c4:	83 ec 0c             	sub    $0xc,%esp
801054c7:	68 a1 89 10 80       	push   $0x801089a1
801054cc:	e8 bf ae ff ff       	call   80100390 <panic>
801054d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054df:	90                   	nop

801054e0 <release>:
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	53                   	push   %ebx
801054e8:	83 ec 10             	sub    $0x10,%esp
801054eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801054ee:	53                   	push   %ebx
801054ef:	e8 dc fe ff ff       	call   801053d0 <holding>
801054f4:	83 c4 10             	add    $0x10,%esp
801054f7:	85 c0                	test   %eax,%eax
801054f9:	74 22                	je     8010551d <release+0x3d>
  lk->pcs[0] = 0;
801054fb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105502:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105509:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010550e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105514:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105517:	c9                   	leave  
  popcli();
80105518:	e9 53 fe ff ff       	jmp    80105370 <popcli>
    panic("release");
8010551d:	83 ec 0c             	sub    $0xc,%esp
80105520:	68 a9 89 10 80       	push   $0x801089a9
80105525:	e8 66 ae ff ff       	call   80100390 <panic>
8010552a:	66 90                	xchg   %ax,%ax
8010552c:	66 90                	xchg   %ax,%ax
8010552e:	66 90                	xchg   %ax,%ax

80105530 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105530:	f3 0f 1e fb          	endbr32 
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	57                   	push   %edi
80105538:	8b 55 08             	mov    0x8(%ebp),%edx
8010553b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010553e:	53                   	push   %ebx
8010553f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105542:	89 d7                	mov    %edx,%edi
80105544:	09 cf                	or     %ecx,%edi
80105546:	83 e7 03             	and    $0x3,%edi
80105549:	75 25                	jne    80105570 <memset+0x40>
    c &= 0xFF;
8010554b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010554e:	c1 e0 18             	shl    $0x18,%eax
80105551:	89 fb                	mov    %edi,%ebx
80105553:	c1 e9 02             	shr    $0x2,%ecx
80105556:	c1 e3 10             	shl    $0x10,%ebx
80105559:	09 d8                	or     %ebx,%eax
8010555b:	09 f8                	or     %edi,%eax
8010555d:	c1 e7 08             	shl    $0x8,%edi
80105560:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105562:	89 d7                	mov    %edx,%edi
80105564:	fc                   	cld    
80105565:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105567:	5b                   	pop    %ebx
80105568:	89 d0                	mov    %edx,%eax
8010556a:	5f                   	pop    %edi
8010556b:	5d                   	pop    %ebp
8010556c:	c3                   	ret    
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105570:	89 d7                	mov    %edx,%edi
80105572:	fc                   	cld    
80105573:	f3 aa                	rep stos %al,%es:(%edi)
80105575:	5b                   	pop    %ebx
80105576:	89 d0                	mov    %edx,%eax
80105578:	5f                   	pop    %edi
80105579:	5d                   	pop    %ebp
8010557a:	c3                   	ret    
8010557b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010557f:	90                   	nop

80105580 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105580:	f3 0f 1e fb          	endbr32 
80105584:	55                   	push   %ebp
80105585:	89 e5                	mov    %esp,%ebp
80105587:	56                   	push   %esi
80105588:	8b 75 10             	mov    0x10(%ebp),%esi
8010558b:	8b 55 08             	mov    0x8(%ebp),%edx
8010558e:	53                   	push   %ebx
8010558f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105592:	85 f6                	test   %esi,%esi
80105594:	74 2a                	je     801055c0 <memcmp+0x40>
80105596:	01 c6                	add    %eax,%esi
80105598:	eb 10                	jmp    801055aa <memcmp+0x2a>
8010559a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801055a0:	83 c0 01             	add    $0x1,%eax
801055a3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801055a6:	39 f0                	cmp    %esi,%eax
801055a8:	74 16                	je     801055c0 <memcmp+0x40>
    if(*s1 != *s2)
801055aa:	0f b6 0a             	movzbl (%edx),%ecx
801055ad:	0f b6 18             	movzbl (%eax),%ebx
801055b0:	38 d9                	cmp    %bl,%cl
801055b2:	74 ec                	je     801055a0 <memcmp+0x20>
      return *s1 - *s2;
801055b4:	0f b6 c1             	movzbl %cl,%eax
801055b7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801055b9:	5b                   	pop    %ebx
801055ba:	5e                   	pop    %esi
801055bb:	5d                   	pop    %ebp
801055bc:	c3                   	ret    
801055bd:	8d 76 00             	lea    0x0(%esi),%esi
801055c0:	5b                   	pop    %ebx
  return 0;
801055c1:	31 c0                	xor    %eax,%eax
}
801055c3:	5e                   	pop    %esi
801055c4:	5d                   	pop    %ebp
801055c5:	c3                   	ret    
801055c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cd:	8d 76 00             	lea    0x0(%esi),%esi

801055d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801055d0:	f3 0f 1e fb          	endbr32 
801055d4:	55                   	push   %ebp
801055d5:	89 e5                	mov    %esp,%ebp
801055d7:	57                   	push   %edi
801055d8:	8b 55 08             	mov    0x8(%ebp),%edx
801055db:	8b 4d 10             	mov    0x10(%ebp),%ecx
801055de:	56                   	push   %esi
801055df:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801055e2:	39 d6                	cmp    %edx,%esi
801055e4:	73 2a                	jae    80105610 <memmove+0x40>
801055e6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801055e9:	39 fa                	cmp    %edi,%edx
801055eb:	73 23                	jae    80105610 <memmove+0x40>
801055ed:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801055f0:	85 c9                	test   %ecx,%ecx
801055f2:	74 13                	je     80105607 <memmove+0x37>
801055f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801055f8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801055fc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801055ff:	83 e8 01             	sub    $0x1,%eax
80105602:	83 f8 ff             	cmp    $0xffffffff,%eax
80105605:	75 f1                	jne    801055f8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105607:	5e                   	pop    %esi
80105608:	89 d0                	mov    %edx,%eax
8010560a:	5f                   	pop    %edi
8010560b:	5d                   	pop    %ebp
8010560c:	c3                   	ret    
8010560d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105610:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105613:	89 d7                	mov    %edx,%edi
80105615:	85 c9                	test   %ecx,%ecx
80105617:	74 ee                	je     80105607 <memmove+0x37>
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105620:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105621:	39 f0                	cmp    %esi,%eax
80105623:	75 fb                	jne    80105620 <memmove+0x50>
}
80105625:	5e                   	pop    %esi
80105626:	89 d0                	mov    %edx,%eax
80105628:	5f                   	pop    %edi
80105629:	5d                   	pop    %ebp
8010562a:	c3                   	ret    
8010562b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010562f:	90                   	nop

80105630 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105630:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105634:	eb 9a                	jmp    801055d0 <memmove>
80105636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563d:	8d 76 00             	lea    0x0(%esi),%esi

80105640 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105640:	f3 0f 1e fb          	endbr32 
80105644:	55                   	push   %ebp
80105645:	89 e5                	mov    %esp,%ebp
80105647:	56                   	push   %esi
80105648:	8b 75 10             	mov    0x10(%ebp),%esi
8010564b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010564e:	53                   	push   %ebx
8010564f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105652:	85 f6                	test   %esi,%esi
80105654:	74 32                	je     80105688 <strncmp+0x48>
80105656:	01 c6                	add    %eax,%esi
80105658:	eb 14                	jmp    8010566e <strncmp+0x2e>
8010565a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105660:	38 da                	cmp    %bl,%dl
80105662:	75 14                	jne    80105678 <strncmp+0x38>
    n--, p++, q++;
80105664:	83 c0 01             	add    $0x1,%eax
80105667:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010566a:	39 f0                	cmp    %esi,%eax
8010566c:	74 1a                	je     80105688 <strncmp+0x48>
8010566e:	0f b6 11             	movzbl (%ecx),%edx
80105671:	0f b6 18             	movzbl (%eax),%ebx
80105674:	84 d2                	test   %dl,%dl
80105676:	75 e8                	jne    80105660 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105678:	0f b6 c2             	movzbl %dl,%eax
8010567b:	29 d8                	sub    %ebx,%eax
}
8010567d:	5b                   	pop    %ebx
8010567e:	5e                   	pop    %esi
8010567f:	5d                   	pop    %ebp
80105680:	c3                   	ret    
80105681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105688:	5b                   	pop    %ebx
    return 0;
80105689:	31 c0                	xor    %eax,%eax
}
8010568b:	5e                   	pop    %esi
8010568c:	5d                   	pop    %ebp
8010568d:	c3                   	ret    
8010568e:	66 90                	xchg   %ax,%ax

80105690 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105690:	f3 0f 1e fb          	endbr32 
80105694:	55                   	push   %ebp
80105695:	89 e5                	mov    %esp,%ebp
80105697:	57                   	push   %edi
80105698:	56                   	push   %esi
80105699:	8b 75 08             	mov    0x8(%ebp),%esi
8010569c:	53                   	push   %ebx
8010569d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801056a0:	89 f2                	mov    %esi,%edx
801056a2:	eb 1b                	jmp    801056bf <strncpy+0x2f>
801056a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056a8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801056ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
801056af:	83 c2 01             	add    $0x1,%edx
801056b2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801056b6:	89 f9                	mov    %edi,%ecx
801056b8:	88 4a ff             	mov    %cl,-0x1(%edx)
801056bb:	84 c9                	test   %cl,%cl
801056bd:	74 09                	je     801056c8 <strncpy+0x38>
801056bf:	89 c3                	mov    %eax,%ebx
801056c1:	83 e8 01             	sub    $0x1,%eax
801056c4:	85 db                	test   %ebx,%ebx
801056c6:	7f e0                	jg     801056a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801056c8:	89 d1                	mov    %edx,%ecx
801056ca:	85 c0                	test   %eax,%eax
801056cc:	7e 15                	jle    801056e3 <strncpy+0x53>
801056ce:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801056d0:	83 c1 01             	add    $0x1,%ecx
801056d3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801056d7:	89 c8                	mov    %ecx,%eax
801056d9:	f7 d0                	not    %eax
801056db:	01 d0                	add    %edx,%eax
801056dd:	01 d8                	add    %ebx,%eax
801056df:	85 c0                	test   %eax,%eax
801056e1:	7f ed                	jg     801056d0 <strncpy+0x40>
  return os;
}
801056e3:	5b                   	pop    %ebx
801056e4:	89 f0                	mov    %esi,%eax
801056e6:	5e                   	pop    %esi
801056e7:	5f                   	pop    %edi
801056e8:	5d                   	pop    %ebp
801056e9:	c3                   	ret    
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801056f0:	f3 0f 1e fb          	endbr32 
801056f4:	55                   	push   %ebp
801056f5:	89 e5                	mov    %esp,%ebp
801056f7:	56                   	push   %esi
801056f8:	8b 55 10             	mov    0x10(%ebp),%edx
801056fb:	8b 75 08             	mov    0x8(%ebp),%esi
801056fe:	53                   	push   %ebx
801056ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105702:	85 d2                	test   %edx,%edx
80105704:	7e 21                	jle    80105727 <safestrcpy+0x37>
80105706:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010570a:	89 f2                	mov    %esi,%edx
8010570c:	eb 12                	jmp    80105720 <safestrcpy+0x30>
8010570e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105710:	0f b6 08             	movzbl (%eax),%ecx
80105713:	83 c0 01             	add    $0x1,%eax
80105716:	83 c2 01             	add    $0x1,%edx
80105719:	88 4a ff             	mov    %cl,-0x1(%edx)
8010571c:	84 c9                	test   %cl,%cl
8010571e:	74 04                	je     80105724 <safestrcpy+0x34>
80105720:	39 d8                	cmp    %ebx,%eax
80105722:	75 ec                	jne    80105710 <safestrcpy+0x20>
    ;
  *s = 0;
80105724:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105727:	89 f0                	mov    %esi,%eax
80105729:	5b                   	pop    %ebx
8010572a:	5e                   	pop    %esi
8010572b:	5d                   	pop    %ebp
8010572c:	c3                   	ret    
8010572d:	8d 76 00             	lea    0x0(%esi),%esi

80105730 <strlen>:

int
strlen(const char *s)
{
80105730:	f3 0f 1e fb          	endbr32 
80105734:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105735:	31 c0                	xor    %eax,%eax
{
80105737:	89 e5                	mov    %esp,%ebp
80105739:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010573c:	80 3a 00             	cmpb   $0x0,(%edx)
8010573f:	74 10                	je     80105751 <strlen+0x21>
80105741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105748:	83 c0 01             	add    $0x1,%eax
8010574b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010574f:	75 f7                	jne    80105748 <strlen+0x18>
    ;
  return n;
}
80105751:	5d                   	pop    %ebp
80105752:	c3                   	ret    

80105753 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105753:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105757:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010575b:	55                   	push   %ebp
  pushl %ebx
8010575c:	53                   	push   %ebx
  pushl %esi
8010575d:	56                   	push   %esi
  pushl %edi
8010575e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010575f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105761:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105763:	5f                   	pop    %edi
  popl %esi
80105764:	5e                   	pop    %esi
  popl %ebx
80105765:	5b                   	pop    %ebx
  popl %ebp
80105766:	5d                   	pop    %ebp
  ret
80105767:	c3                   	ret    
80105768:	66 90                	xchg   %ax,%ax
8010576a:	66 90                	xchg   %ax,%ax
8010576c:	66 90                	xchg   %ax,%ax
8010576e:	66 90                	xchg   %ax,%ax

80105770 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105770:	f3 0f 1e fb          	endbr32 
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	53                   	push   %ebx
80105778:	83 ec 04             	sub    $0x4,%esp
8010577b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010577e:	e8 1d e6 ff ff       	call   80103da0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105783:	8b 00                	mov    (%eax),%eax
80105785:	39 d8                	cmp    %ebx,%eax
80105787:	76 17                	jbe    801057a0 <fetchint+0x30>
80105789:	8d 53 04             	lea    0x4(%ebx),%edx
8010578c:	39 d0                	cmp    %edx,%eax
8010578e:	72 10                	jb     801057a0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105790:	8b 45 0c             	mov    0xc(%ebp),%eax
80105793:	8b 13                	mov    (%ebx),%edx
80105795:	89 10                	mov    %edx,(%eax)
  return 0;
80105797:	31 c0                	xor    %eax,%eax
}
80105799:	83 c4 04             	add    $0x4,%esp
8010579c:	5b                   	pop    %ebx
8010579d:	5d                   	pop    %ebp
8010579e:	c3                   	ret    
8010579f:	90                   	nop
    return -1;
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a5:	eb f2                	jmp    80105799 <fetchint+0x29>
801057a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ae:	66 90                	xchg   %ax,%ax

801057b0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801057b0:	f3 0f 1e fb          	endbr32 
801057b4:	55                   	push   %ebp
801057b5:	89 e5                	mov    %esp,%ebp
801057b7:	53                   	push   %ebx
801057b8:	83 ec 04             	sub    $0x4,%esp
801057bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801057be:	e8 dd e5 ff ff       	call   80103da0 <myproc>

  if(addr >= curproc->sz)
801057c3:	39 18                	cmp    %ebx,(%eax)
801057c5:	76 31                	jbe    801057f8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801057c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801057ca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801057cc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801057ce:	39 d3                	cmp    %edx,%ebx
801057d0:	73 26                	jae    801057f8 <fetchstr+0x48>
801057d2:	89 d8                	mov    %ebx,%eax
801057d4:	eb 11                	jmp    801057e7 <fetchstr+0x37>
801057d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057dd:	8d 76 00             	lea    0x0(%esi),%esi
801057e0:	83 c0 01             	add    $0x1,%eax
801057e3:	39 c2                	cmp    %eax,%edx
801057e5:	76 11                	jbe    801057f8 <fetchstr+0x48>
    if(*s == 0)
801057e7:	80 38 00             	cmpb   $0x0,(%eax)
801057ea:	75 f4                	jne    801057e0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801057ec:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801057ef:	29 d8                	sub    %ebx,%eax
}
801057f1:	5b                   	pop    %ebx
801057f2:	5d                   	pop    %ebp
801057f3:	c3                   	ret    
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057f8:	83 c4 04             	add    $0x4,%esp
    return -1;
801057fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105800:	5b                   	pop    %ebx
80105801:	5d                   	pop    %ebp
80105802:	c3                   	ret    
80105803:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105810 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105810:	f3 0f 1e fb          	endbr32 
80105814:	55                   	push   %ebp
80105815:	89 e5                	mov    %esp,%ebp
80105817:	56                   	push   %esi
80105818:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105819:	e8 82 e5 ff ff       	call   80103da0 <myproc>
8010581e:	8b 55 08             	mov    0x8(%ebp),%edx
80105821:	8b 40 18             	mov    0x18(%eax),%eax
80105824:	8b 40 44             	mov    0x44(%eax),%eax
80105827:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010582a:	e8 71 e5 ff ff       	call   80103da0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010582f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105832:	8b 00                	mov    (%eax),%eax
80105834:	39 c6                	cmp    %eax,%esi
80105836:	73 18                	jae    80105850 <argint+0x40>
80105838:	8d 53 08             	lea    0x8(%ebx),%edx
8010583b:	39 d0                	cmp    %edx,%eax
8010583d:	72 11                	jb     80105850 <argint+0x40>
  *ip = *(int*)(addr);
8010583f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105842:	8b 53 04             	mov    0x4(%ebx),%edx
80105845:	89 10                	mov    %edx,(%eax)
  return 0;
80105847:	31 c0                	xor    %eax,%eax
}
80105849:	5b                   	pop    %ebx
8010584a:	5e                   	pop    %esi
8010584b:	5d                   	pop    %ebp
8010584c:	c3                   	ret    
8010584d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105855:	eb f2                	jmp    80105849 <argint+0x39>
80105857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585e:	66 90                	xchg   %ax,%ax

80105860 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105860:	f3 0f 1e fb          	endbr32 
80105864:	55                   	push   %ebp
80105865:	89 e5                	mov    %esp,%ebp
80105867:	56                   	push   %esi
80105868:	53                   	push   %ebx
80105869:	83 ec 10             	sub    $0x10,%esp
8010586c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010586f:	e8 2c e5 ff ff       	call   80103da0 <myproc>
 
  if(argint(n, &i) < 0)
80105874:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105877:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105879:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010587c:	50                   	push   %eax
8010587d:	ff 75 08             	pushl  0x8(%ebp)
80105880:	e8 8b ff ff ff       	call   80105810 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105885:	83 c4 10             	add    $0x10,%esp
80105888:	85 c0                	test   %eax,%eax
8010588a:	78 24                	js     801058b0 <argptr+0x50>
8010588c:	85 db                	test   %ebx,%ebx
8010588e:	78 20                	js     801058b0 <argptr+0x50>
80105890:	8b 16                	mov    (%esi),%edx
80105892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105895:	39 c2                	cmp    %eax,%edx
80105897:	76 17                	jbe    801058b0 <argptr+0x50>
80105899:	01 c3                	add    %eax,%ebx
8010589b:	39 da                	cmp    %ebx,%edx
8010589d:	72 11                	jb     801058b0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010589f:	8b 55 0c             	mov    0xc(%ebp),%edx
801058a2:	89 02                	mov    %eax,(%edx)
  return 0;
801058a4:	31 c0                	xor    %eax,%eax
}
801058a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058a9:	5b                   	pop    %ebx
801058aa:	5e                   	pop    %esi
801058ab:	5d                   	pop    %ebp
801058ac:	c3                   	ret    
801058ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b5:	eb ef                	jmp    801058a6 <argptr+0x46>
801058b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058be:	66 90                	xchg   %ax,%ax

801058c0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801058c0:	f3 0f 1e fb          	endbr32 
801058c4:	55                   	push   %ebp
801058c5:	89 e5                	mov    %esp,%ebp
801058c7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801058ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058cd:	50                   	push   %eax
801058ce:	ff 75 08             	pushl  0x8(%ebp)
801058d1:	e8 3a ff ff ff       	call   80105810 <argint>
801058d6:	83 c4 10             	add    $0x10,%esp
801058d9:	85 c0                	test   %eax,%eax
801058db:	78 13                	js     801058f0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801058dd:	83 ec 08             	sub    $0x8,%esp
801058e0:	ff 75 0c             	pushl  0xc(%ebp)
801058e3:	ff 75 f4             	pushl  -0xc(%ebp)
801058e6:	e8 c5 fe ff ff       	call   801057b0 <fetchstr>
801058eb:	83 c4 10             	add    $0x10,%esp
}
801058ee:	c9                   	leave  
801058ef:	c3                   	ret    
801058f0:	c9                   	leave  
    return -1;
801058f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f6:	c3                   	ret    
801058f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fe:	66 90                	xchg   %ax,%ax

80105900 <syscall>:
[SYS_change_BJF_parameters_all] sys_change_BJF_parameters_all,
};

void
syscall(void)
{
80105900:	f3 0f 1e fb          	endbr32 
80105904:	55                   	push   %ebp
80105905:	89 e5                	mov    %esp,%ebp
80105907:	56                   	push   %esi
80105908:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105909:	e8 92 e4 ff ff       	call   80103da0 <myproc>
8010590e:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105910:	8b 40 18             	mov    0x18(%eax),%eax
80105913:	8b 70 1c             	mov    0x1c(%eax),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105916:	8d 46 ff             	lea    -0x1(%esi),%eax
80105919:	83 f8 1c             	cmp    $0x1c,%eax
8010591c:	77 22                	ja     80105940 <syscall+0x40>
8010591e:	8b 04 b5 e0 89 10 80 	mov    -0x7fef7620(,%esi,4),%eax
80105925:	85 c0                	test   %eax,%eax
80105927:	74 17                	je     80105940 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105929:	ff d0                	call   *%eax
8010592b:	8b 53 18             	mov    0x18(%ebx),%edx
8010592e:	89 42 1c             	mov    %eax,0x1c(%edx)
    curproc->syscall_cnt[num - 1] += 1;
80105931:	83 44 b3 78 01       	addl   $0x1,0x78(%ebx,%esi,4)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105936:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105939:	5b                   	pop    %ebx
8010593a:	5e                   	pop    %esi
8010593b:	5d                   	pop    %ebp
8010593c:	c3                   	ret    
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
            curproc->pid, curproc->name, num);
80105940:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105943:	56                   	push   %esi
80105944:	50                   	push   %eax
80105945:	ff 73 10             	pushl  0x10(%ebx)
80105948:	68 b1 89 10 80       	push   $0x801089b1
8010594d:	e8 5e ad ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105952:	8b 43 18             	mov    0x18(%ebx),%eax
80105955:	83 c4 10             	add    $0x10,%esp
80105958:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010595f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105962:	5b                   	pop    %ebx
80105963:	5e                   	pop    %esi
80105964:	5d                   	pop    %ebp
80105965:	c3                   	ret    
80105966:	66 90                	xchg   %ax,%ax
80105968:	66 90                	xchg   %ax,%ax
8010596a:	66 90                	xchg   %ax,%ax
8010596c:	66 90                	xchg   %ax,%ax
8010596e:	66 90                	xchg   %ax,%ax

80105970 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	57                   	push   %edi
80105974:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105975:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105978:	53                   	push   %ebx
80105979:	83 ec 34             	sub    $0x34,%esp
8010597c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010597f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105982:	57                   	push   %edi
80105983:	50                   	push   %eax
{
80105984:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105987:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010598a:	e8 31 ca ff ff       	call   801023c0 <nameiparent>
8010598f:	83 c4 10             	add    $0x10,%esp
80105992:	85 c0                	test   %eax,%eax
80105994:	0f 84 46 01 00 00    	je     80105ae0 <create+0x170>
    return 0;
  ilock(dp);
8010599a:	83 ec 0c             	sub    $0xc,%esp
8010599d:	89 c3                	mov    %eax,%ebx
8010599f:	50                   	push   %eax
801059a0:	e8 2b c1 ff ff       	call   80101ad0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801059a5:	83 c4 0c             	add    $0xc,%esp
801059a8:	6a 00                	push   $0x0
801059aa:	57                   	push   %edi
801059ab:	53                   	push   %ebx
801059ac:	e8 6f c6 ff ff       	call   80102020 <dirlookup>
801059b1:	83 c4 10             	add    $0x10,%esp
801059b4:	89 c6                	mov    %eax,%esi
801059b6:	85 c0                	test   %eax,%eax
801059b8:	74 56                	je     80105a10 <create+0xa0>
    iunlockput(dp);
801059ba:	83 ec 0c             	sub    $0xc,%esp
801059bd:	53                   	push   %ebx
801059be:	e8 ad c3 ff ff       	call   80101d70 <iunlockput>
    ilock(ip);
801059c3:	89 34 24             	mov    %esi,(%esp)
801059c6:	e8 05 c1 ff ff       	call   80101ad0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801059cb:	83 c4 10             	add    $0x10,%esp
801059ce:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801059d3:	75 1b                	jne    801059f0 <create+0x80>
801059d5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801059da:	75 14                	jne    801059f0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801059dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059df:	89 f0                	mov    %esi,%eax
801059e1:	5b                   	pop    %ebx
801059e2:	5e                   	pop    %esi
801059e3:	5f                   	pop    %edi
801059e4:	5d                   	pop    %ebp
801059e5:	c3                   	ret    
801059e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	56                   	push   %esi
    return 0;
801059f4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801059f6:	e8 75 c3 ff ff       	call   80101d70 <iunlockput>
    return 0;
801059fb:	83 c4 10             	add    $0x10,%esp
}
801059fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a01:	89 f0                	mov    %esi,%eax
80105a03:	5b                   	pop    %ebx
80105a04:	5e                   	pop    %esi
80105a05:	5f                   	pop    %edi
80105a06:	5d                   	pop    %ebp
80105a07:	c3                   	ret    
80105a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105a10:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105a14:	83 ec 08             	sub    $0x8,%esp
80105a17:	50                   	push   %eax
80105a18:	ff 33                	pushl  (%ebx)
80105a1a:	e8 31 bf ff ff       	call   80101950 <ialloc>
80105a1f:	83 c4 10             	add    $0x10,%esp
80105a22:	89 c6                	mov    %eax,%esi
80105a24:	85 c0                	test   %eax,%eax
80105a26:	0f 84 cd 00 00 00    	je     80105af9 <create+0x189>
  ilock(ip);
80105a2c:	83 ec 0c             	sub    $0xc,%esp
80105a2f:	50                   	push   %eax
80105a30:	e8 9b c0 ff ff       	call   80101ad0 <ilock>
  ip->major = major;
80105a35:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105a39:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105a3d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105a41:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105a45:	b8 01 00 00 00       	mov    $0x1,%eax
80105a4a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105a4e:	89 34 24             	mov    %esi,(%esp)
80105a51:	e8 ba bf ff ff       	call   80101a10 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105a56:	83 c4 10             	add    $0x10,%esp
80105a59:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105a5e:	74 30                	je     80105a90 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105a60:	83 ec 04             	sub    $0x4,%esp
80105a63:	ff 76 04             	pushl  0x4(%esi)
80105a66:	57                   	push   %edi
80105a67:	53                   	push   %ebx
80105a68:	e8 73 c8 ff ff       	call   801022e0 <dirlink>
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	85 c0                	test   %eax,%eax
80105a72:	78 78                	js     80105aec <create+0x17c>
  iunlockput(dp);
80105a74:	83 ec 0c             	sub    $0xc,%esp
80105a77:	53                   	push   %ebx
80105a78:	e8 f3 c2 ff ff       	call   80101d70 <iunlockput>
  return ip;
80105a7d:	83 c4 10             	add    $0x10,%esp
}
80105a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a83:	89 f0                	mov    %esi,%eax
80105a85:	5b                   	pop    %ebx
80105a86:	5e                   	pop    %esi
80105a87:	5f                   	pop    %edi
80105a88:	5d                   	pop    %ebp
80105a89:	c3                   	ret    
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105a90:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105a93:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105a98:	53                   	push   %ebx
80105a99:	e8 72 bf ff ff       	call   80101a10 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105a9e:	83 c4 0c             	add    $0xc,%esp
80105aa1:	ff 76 04             	pushl  0x4(%esi)
80105aa4:	68 74 8a 10 80       	push   $0x80108a74
80105aa9:	56                   	push   %esi
80105aaa:	e8 31 c8 ff ff       	call   801022e0 <dirlink>
80105aaf:	83 c4 10             	add    $0x10,%esp
80105ab2:	85 c0                	test   %eax,%eax
80105ab4:	78 18                	js     80105ace <create+0x15e>
80105ab6:	83 ec 04             	sub    $0x4,%esp
80105ab9:	ff 73 04             	pushl  0x4(%ebx)
80105abc:	68 73 8a 10 80       	push   $0x80108a73
80105ac1:	56                   	push   %esi
80105ac2:	e8 19 c8 ff ff       	call   801022e0 <dirlink>
80105ac7:	83 c4 10             	add    $0x10,%esp
80105aca:	85 c0                	test   %eax,%eax
80105acc:	79 92                	jns    80105a60 <create+0xf0>
      panic("create dots");
80105ace:	83 ec 0c             	sub    $0xc,%esp
80105ad1:	68 67 8a 10 80       	push   $0x80108a67
80105ad6:	e8 b5 a8 ff ff       	call   80100390 <panic>
80105adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105adf:	90                   	nop
}
80105ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105ae3:	31 f6                	xor    %esi,%esi
}
80105ae5:	5b                   	pop    %ebx
80105ae6:	89 f0                	mov    %esi,%eax
80105ae8:	5e                   	pop    %esi
80105ae9:	5f                   	pop    %edi
80105aea:	5d                   	pop    %ebp
80105aeb:	c3                   	ret    
    panic("create: dirlink");
80105aec:	83 ec 0c             	sub    $0xc,%esp
80105aef:	68 76 8a 10 80       	push   $0x80108a76
80105af4:	e8 97 a8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105af9:	83 ec 0c             	sub    $0xc,%esp
80105afc:	68 58 8a 10 80       	push   $0x80108a58
80105b01:	e8 8a a8 ff ff       	call   80100390 <panic>
80105b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi

80105b10 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	56                   	push   %esi
80105b14:	89 d6                	mov    %edx,%esi
80105b16:	53                   	push   %ebx
80105b17:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105b19:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105b1c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105b1f:	50                   	push   %eax
80105b20:	6a 00                	push   $0x0
80105b22:	e8 e9 fc ff ff       	call   80105810 <argint>
80105b27:	83 c4 10             	add    $0x10,%esp
80105b2a:	85 c0                	test   %eax,%eax
80105b2c:	78 2a                	js     80105b58 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105b2e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105b32:	77 24                	ja     80105b58 <argfd.constprop.0+0x48>
80105b34:	e8 67 e2 ff ff       	call   80103da0 <myproc>
80105b39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b3c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105b40:	85 c0                	test   %eax,%eax
80105b42:	74 14                	je     80105b58 <argfd.constprop.0+0x48>
  if(pfd)
80105b44:	85 db                	test   %ebx,%ebx
80105b46:	74 02                	je     80105b4a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105b48:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105b4a:	89 06                	mov    %eax,(%esi)
  return 0;
80105b4c:	31 c0                	xor    %eax,%eax
}
80105b4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b51:	5b                   	pop    %ebx
80105b52:	5e                   	pop    %esi
80105b53:	5d                   	pop    %ebp
80105b54:	c3                   	ret    
80105b55:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5d:	eb ef                	jmp    80105b4e <argfd.constprop.0+0x3e>
80105b5f:	90                   	nop

80105b60 <sys_dup>:
{
80105b60:	f3 0f 1e fb          	endbr32 
80105b64:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105b65:	31 c0                	xor    %eax,%eax
{
80105b67:	89 e5                	mov    %esp,%ebp
80105b69:	56                   	push   %esi
80105b6a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105b6b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105b6e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105b71:	e8 9a ff ff ff       	call   80105b10 <argfd.constprop.0>
80105b76:	85 c0                	test   %eax,%eax
80105b78:	78 1e                	js     80105b98 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80105b7a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b7d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b7f:	e8 1c e2 ff ff       	call   80103da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b88:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b8c:	85 d2                	test   %edx,%edx
80105b8e:	74 20                	je     80105bb0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105b90:	83 c3 01             	add    $0x1,%ebx
80105b93:	83 fb 10             	cmp    $0x10,%ebx
80105b96:	75 f0                	jne    80105b88 <sys_dup+0x28>
}
80105b98:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105b9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105ba0:	89 d8                	mov    %ebx,%eax
80105ba2:	5b                   	pop    %ebx
80105ba3:	5e                   	pop    %esi
80105ba4:	5d                   	pop    %ebp
80105ba5:	c3                   	ret    
80105ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bad:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105bb0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105bb4:	83 ec 0c             	sub    $0xc,%esp
80105bb7:	ff 75 f4             	pushl  -0xc(%ebp)
80105bba:	e8 21 b6 ff ff       	call   801011e0 <filedup>
  return fd;
80105bbf:	83 c4 10             	add    $0x10,%esp
}
80105bc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105bc5:	89 d8                	mov    %ebx,%eax
80105bc7:	5b                   	pop    %ebx
80105bc8:	5e                   	pop    %esi
80105bc9:	5d                   	pop    %ebp
80105bca:	c3                   	ret    
80105bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop

80105bd0 <sys_read>:
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105bd5:	31 c0                	xor    %eax,%eax
{
80105bd7:	89 e5                	mov    %esp,%ebp
80105bd9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105bdc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105bdf:	e8 2c ff ff ff       	call   80105b10 <argfd.constprop.0>
80105be4:	85 c0                	test   %eax,%eax
80105be6:	78 48                	js     80105c30 <sys_read+0x60>
80105be8:	83 ec 08             	sub    $0x8,%esp
80105beb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bee:	50                   	push   %eax
80105bef:	6a 02                	push   $0x2
80105bf1:	e8 1a fc ff ff       	call   80105810 <argint>
80105bf6:	83 c4 10             	add    $0x10,%esp
80105bf9:	85 c0                	test   %eax,%eax
80105bfb:	78 33                	js     80105c30 <sys_read+0x60>
80105bfd:	83 ec 04             	sub    $0x4,%esp
80105c00:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c03:	ff 75 f0             	pushl  -0x10(%ebp)
80105c06:	50                   	push   %eax
80105c07:	6a 01                	push   $0x1
80105c09:	e8 52 fc ff ff       	call   80105860 <argptr>
80105c0e:	83 c4 10             	add    $0x10,%esp
80105c11:	85 c0                	test   %eax,%eax
80105c13:	78 1b                	js     80105c30 <sys_read+0x60>
  return fileread(f, p, n);
80105c15:	83 ec 04             	sub    $0x4,%esp
80105c18:	ff 75 f0             	pushl  -0x10(%ebp)
80105c1b:	ff 75 f4             	pushl  -0xc(%ebp)
80105c1e:	ff 75 ec             	pushl  -0x14(%ebp)
80105c21:	e8 3a b7 ff ff       	call   80101360 <fileread>
80105c26:	83 c4 10             	add    $0x10,%esp
}
80105c29:	c9                   	leave  
80105c2a:	c3                   	ret    
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
80105c30:	c9                   	leave  
    return -1;
80105c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c36:	c3                   	ret    
80105c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3e:	66 90                	xchg   %ax,%ax

80105c40 <sys_write>:
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c45:	31 c0                	xor    %eax,%eax
{
80105c47:	89 e5                	mov    %esp,%ebp
80105c49:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c4c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105c4f:	e8 bc fe ff ff       	call   80105b10 <argfd.constprop.0>
80105c54:	85 c0                	test   %eax,%eax
80105c56:	78 48                	js     80105ca0 <sys_write+0x60>
80105c58:	83 ec 08             	sub    $0x8,%esp
80105c5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c5e:	50                   	push   %eax
80105c5f:	6a 02                	push   $0x2
80105c61:	e8 aa fb ff ff       	call   80105810 <argint>
80105c66:	83 c4 10             	add    $0x10,%esp
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	78 33                	js     80105ca0 <sys_write+0x60>
80105c6d:	83 ec 04             	sub    $0x4,%esp
80105c70:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c73:	ff 75 f0             	pushl  -0x10(%ebp)
80105c76:	50                   	push   %eax
80105c77:	6a 01                	push   $0x1
80105c79:	e8 e2 fb ff ff       	call   80105860 <argptr>
80105c7e:	83 c4 10             	add    $0x10,%esp
80105c81:	85 c0                	test   %eax,%eax
80105c83:	78 1b                	js     80105ca0 <sys_write+0x60>
  return filewrite(f, p, n);
80105c85:	83 ec 04             	sub    $0x4,%esp
80105c88:	ff 75 f0             	pushl  -0x10(%ebp)
80105c8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105c8e:	ff 75 ec             	pushl  -0x14(%ebp)
80105c91:	e8 6a b7 ff ff       	call   80101400 <filewrite>
80105c96:	83 c4 10             	add    $0x10,%esp
}
80105c99:	c9                   	leave  
80105c9a:	c3                   	ret    
80105c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c9f:	90                   	nop
80105ca0:	c9                   	leave  
    return -1;
80105ca1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ca6:	c3                   	ret    
80105ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cae:	66 90                	xchg   %ax,%ax

80105cb0 <sys_close>:
{
80105cb0:	f3 0f 1e fb          	endbr32 
80105cb4:	55                   	push   %ebp
80105cb5:	89 e5                	mov    %esp,%ebp
80105cb7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105cba:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105cbd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cc0:	e8 4b fe ff ff       	call   80105b10 <argfd.constprop.0>
80105cc5:	85 c0                	test   %eax,%eax
80105cc7:	78 27                	js     80105cf0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105cc9:	e8 d2 e0 ff ff       	call   80103da0 <myproc>
80105cce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105cd1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105cd4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105cdb:	00 
  fileclose(f);
80105cdc:	ff 75 f4             	pushl  -0xc(%ebp)
80105cdf:	e8 4c b5 ff ff       	call   80101230 <fileclose>
  return 0;
80105ce4:	83 c4 10             	add    $0x10,%esp
80105ce7:	31 c0                	xor    %eax,%eax
}
80105ce9:	c9                   	leave  
80105cea:	c3                   	ret    
80105ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop
80105cf0:	c9                   	leave  
    return -1;
80105cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cf6:	c3                   	ret    
80105cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfe:	66 90                	xchg   %ax,%ax

80105d00 <sys_fstat>:
{
80105d00:	f3 0f 1e fb          	endbr32 
80105d04:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105d05:	31 c0                	xor    %eax,%eax
{
80105d07:	89 e5                	mov    %esp,%ebp
80105d09:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105d0c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105d0f:	e8 fc fd ff ff       	call   80105b10 <argfd.constprop.0>
80105d14:	85 c0                	test   %eax,%eax
80105d16:	78 30                	js     80105d48 <sys_fstat+0x48>
80105d18:	83 ec 04             	sub    $0x4,%esp
80105d1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d1e:	6a 14                	push   $0x14
80105d20:	50                   	push   %eax
80105d21:	6a 01                	push   $0x1
80105d23:	e8 38 fb ff ff       	call   80105860 <argptr>
80105d28:	83 c4 10             	add    $0x10,%esp
80105d2b:	85 c0                	test   %eax,%eax
80105d2d:	78 19                	js     80105d48 <sys_fstat+0x48>
  return filestat(f, st);
80105d2f:	83 ec 08             	sub    $0x8,%esp
80105d32:	ff 75 f4             	pushl  -0xc(%ebp)
80105d35:	ff 75 f0             	pushl  -0x10(%ebp)
80105d38:	e8 d3 b5 ff ff       	call   80101310 <filestat>
80105d3d:	83 c4 10             	add    $0x10,%esp
}
80105d40:	c9                   	leave  
80105d41:	c3                   	ret    
80105d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d48:	c9                   	leave  
    return -1;
80105d49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d4e:	c3                   	ret    
80105d4f:	90                   	nop

80105d50 <sys_link>:
{
80105d50:	f3 0f 1e fb          	endbr32 
80105d54:	55                   	push   %ebp
80105d55:	89 e5                	mov    %esp,%ebp
80105d57:	57                   	push   %edi
80105d58:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d59:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105d5c:	53                   	push   %ebx
80105d5d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d60:	50                   	push   %eax
80105d61:	6a 00                	push   $0x0
80105d63:	e8 58 fb ff ff       	call   801058c0 <argstr>
80105d68:	83 c4 10             	add    $0x10,%esp
80105d6b:	85 c0                	test   %eax,%eax
80105d6d:	0f 88 ff 00 00 00    	js     80105e72 <sys_link+0x122>
80105d73:	83 ec 08             	sub    $0x8,%esp
80105d76:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105d79:	50                   	push   %eax
80105d7a:	6a 01                	push   $0x1
80105d7c:	e8 3f fb ff ff       	call   801058c0 <argstr>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	85 c0                	test   %eax,%eax
80105d86:	0f 88 e6 00 00 00    	js     80105e72 <sys_link+0x122>
  begin_op();
80105d8c:	e8 0f d3 ff ff       	call   801030a0 <begin_op>
  if((ip = namei(old)) == 0){
80105d91:	83 ec 0c             	sub    $0xc,%esp
80105d94:	ff 75 d4             	pushl  -0x2c(%ebp)
80105d97:	e8 04 c6 ff ff       	call   801023a0 <namei>
80105d9c:	83 c4 10             	add    $0x10,%esp
80105d9f:	89 c3                	mov    %eax,%ebx
80105da1:	85 c0                	test   %eax,%eax
80105da3:	0f 84 e8 00 00 00    	je     80105e91 <sys_link+0x141>
  ilock(ip);
80105da9:	83 ec 0c             	sub    $0xc,%esp
80105dac:	50                   	push   %eax
80105dad:	e8 1e bd ff ff       	call   80101ad0 <ilock>
  if(ip->type == T_DIR){
80105db2:	83 c4 10             	add    $0x10,%esp
80105db5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105dba:	0f 84 b9 00 00 00    	je     80105e79 <sys_link+0x129>
  iupdate(ip);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105dc3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105dc8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105dcb:	53                   	push   %ebx
80105dcc:	e8 3f bc ff ff       	call   80101a10 <iupdate>
  iunlock(ip);
80105dd1:	89 1c 24             	mov    %ebx,(%esp)
80105dd4:	e8 d7 bd ff ff       	call   80101bb0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105dd9:	58                   	pop    %eax
80105dda:	5a                   	pop    %edx
80105ddb:	57                   	push   %edi
80105ddc:	ff 75 d0             	pushl  -0x30(%ebp)
80105ddf:	e8 dc c5 ff ff       	call   801023c0 <nameiparent>
80105de4:	83 c4 10             	add    $0x10,%esp
80105de7:	89 c6                	mov    %eax,%esi
80105de9:	85 c0                	test   %eax,%eax
80105deb:	74 5f                	je     80105e4c <sys_link+0xfc>
  ilock(dp);
80105ded:	83 ec 0c             	sub    $0xc,%esp
80105df0:	50                   	push   %eax
80105df1:	e8 da bc ff ff       	call   80101ad0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105df6:	8b 03                	mov    (%ebx),%eax
80105df8:	83 c4 10             	add    $0x10,%esp
80105dfb:	39 06                	cmp    %eax,(%esi)
80105dfd:	75 41                	jne    80105e40 <sys_link+0xf0>
80105dff:	83 ec 04             	sub    $0x4,%esp
80105e02:	ff 73 04             	pushl  0x4(%ebx)
80105e05:	57                   	push   %edi
80105e06:	56                   	push   %esi
80105e07:	e8 d4 c4 ff ff       	call   801022e0 <dirlink>
80105e0c:	83 c4 10             	add    $0x10,%esp
80105e0f:	85 c0                	test   %eax,%eax
80105e11:	78 2d                	js     80105e40 <sys_link+0xf0>
  iunlockput(dp);
80105e13:	83 ec 0c             	sub    $0xc,%esp
80105e16:	56                   	push   %esi
80105e17:	e8 54 bf ff ff       	call   80101d70 <iunlockput>
  iput(ip);
80105e1c:	89 1c 24             	mov    %ebx,(%esp)
80105e1f:	e8 dc bd ff ff       	call   80101c00 <iput>
  end_op();
80105e24:	e8 e7 d2 ff ff       	call   80103110 <end_op>
  return 0;
80105e29:	83 c4 10             	add    $0x10,%esp
80105e2c:	31 c0                	xor    %eax,%eax
}
80105e2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e31:	5b                   	pop    %ebx
80105e32:	5e                   	pop    %esi
80105e33:	5f                   	pop    %edi
80105e34:	5d                   	pop    %ebp
80105e35:	c3                   	ret    
80105e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105e40:	83 ec 0c             	sub    $0xc,%esp
80105e43:	56                   	push   %esi
80105e44:	e8 27 bf ff ff       	call   80101d70 <iunlockput>
    goto bad;
80105e49:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105e4c:	83 ec 0c             	sub    $0xc,%esp
80105e4f:	53                   	push   %ebx
80105e50:	e8 7b bc ff ff       	call   80101ad0 <ilock>
  ip->nlink--;
80105e55:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105e5a:	89 1c 24             	mov    %ebx,(%esp)
80105e5d:	e8 ae bb ff ff       	call   80101a10 <iupdate>
  iunlockput(ip);
80105e62:	89 1c 24             	mov    %ebx,(%esp)
80105e65:	e8 06 bf ff ff       	call   80101d70 <iunlockput>
  end_op();
80105e6a:	e8 a1 d2 ff ff       	call   80103110 <end_op>
  return -1;
80105e6f:	83 c4 10             	add    $0x10,%esp
80105e72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e77:	eb b5                	jmp    80105e2e <sys_link+0xde>
    iunlockput(ip);
80105e79:	83 ec 0c             	sub    $0xc,%esp
80105e7c:	53                   	push   %ebx
80105e7d:	e8 ee be ff ff       	call   80101d70 <iunlockput>
    end_op();
80105e82:	e8 89 d2 ff ff       	call   80103110 <end_op>
    return -1;
80105e87:	83 c4 10             	add    $0x10,%esp
80105e8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e8f:	eb 9d                	jmp    80105e2e <sys_link+0xde>
    end_op();
80105e91:	e8 7a d2 ff ff       	call   80103110 <end_op>
    return -1;
80105e96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9b:	eb 91                	jmp    80105e2e <sys_link+0xde>
80105e9d:	8d 76 00             	lea    0x0(%esi),%esi

80105ea0 <sys_unlink>:
{
80105ea0:	f3 0f 1e fb          	endbr32 
80105ea4:	55                   	push   %ebp
80105ea5:	89 e5                	mov    %esp,%ebp
80105ea7:	57                   	push   %edi
80105ea8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105ea9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105eac:	53                   	push   %ebx
80105ead:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105eb0:	50                   	push   %eax
80105eb1:	6a 00                	push   $0x0
80105eb3:	e8 08 fa ff ff       	call   801058c0 <argstr>
80105eb8:	83 c4 10             	add    $0x10,%esp
80105ebb:	85 c0                	test   %eax,%eax
80105ebd:	0f 88 7d 01 00 00    	js     80106040 <sys_unlink+0x1a0>
  begin_op();
80105ec3:	e8 d8 d1 ff ff       	call   801030a0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105ec8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105ecb:	83 ec 08             	sub    $0x8,%esp
80105ece:	53                   	push   %ebx
80105ecf:	ff 75 c0             	pushl  -0x40(%ebp)
80105ed2:	e8 e9 c4 ff ff       	call   801023c0 <nameiparent>
80105ed7:	83 c4 10             	add    $0x10,%esp
80105eda:	89 c6                	mov    %eax,%esi
80105edc:	85 c0                	test   %eax,%eax
80105ede:	0f 84 66 01 00 00    	je     8010604a <sys_unlink+0x1aa>
  ilock(dp);
80105ee4:	83 ec 0c             	sub    $0xc,%esp
80105ee7:	50                   	push   %eax
80105ee8:	e8 e3 bb ff ff       	call   80101ad0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105eed:	58                   	pop    %eax
80105eee:	5a                   	pop    %edx
80105eef:	68 74 8a 10 80       	push   $0x80108a74
80105ef4:	53                   	push   %ebx
80105ef5:	e8 06 c1 ff ff       	call   80102000 <namecmp>
80105efa:	83 c4 10             	add    $0x10,%esp
80105efd:	85 c0                	test   %eax,%eax
80105eff:	0f 84 03 01 00 00    	je     80106008 <sys_unlink+0x168>
80105f05:	83 ec 08             	sub    $0x8,%esp
80105f08:	68 73 8a 10 80       	push   $0x80108a73
80105f0d:	53                   	push   %ebx
80105f0e:	e8 ed c0 ff ff       	call   80102000 <namecmp>
80105f13:	83 c4 10             	add    $0x10,%esp
80105f16:	85 c0                	test   %eax,%eax
80105f18:	0f 84 ea 00 00 00    	je     80106008 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105f1e:	83 ec 04             	sub    $0x4,%esp
80105f21:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105f24:	50                   	push   %eax
80105f25:	53                   	push   %ebx
80105f26:	56                   	push   %esi
80105f27:	e8 f4 c0 ff ff       	call   80102020 <dirlookup>
80105f2c:	83 c4 10             	add    $0x10,%esp
80105f2f:	89 c3                	mov    %eax,%ebx
80105f31:	85 c0                	test   %eax,%eax
80105f33:	0f 84 cf 00 00 00    	je     80106008 <sys_unlink+0x168>
  ilock(ip);
80105f39:	83 ec 0c             	sub    $0xc,%esp
80105f3c:	50                   	push   %eax
80105f3d:	e8 8e bb ff ff       	call   80101ad0 <ilock>
  if(ip->nlink < 1)
80105f42:	83 c4 10             	add    $0x10,%esp
80105f45:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105f4a:	0f 8e 23 01 00 00    	jle    80106073 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105f50:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f55:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105f58:	74 66                	je     80105fc0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105f5a:	83 ec 04             	sub    $0x4,%esp
80105f5d:	6a 10                	push   $0x10
80105f5f:	6a 00                	push   $0x0
80105f61:	57                   	push   %edi
80105f62:	e8 c9 f5 ff ff       	call   80105530 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f67:	6a 10                	push   $0x10
80105f69:	ff 75 c4             	pushl  -0x3c(%ebp)
80105f6c:	57                   	push   %edi
80105f6d:	56                   	push   %esi
80105f6e:	e8 5d bf ff ff       	call   80101ed0 <writei>
80105f73:	83 c4 20             	add    $0x20,%esp
80105f76:	83 f8 10             	cmp    $0x10,%eax
80105f79:	0f 85 e7 00 00 00    	jne    80106066 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
80105f7f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f84:	0f 84 96 00 00 00    	je     80106020 <sys_unlink+0x180>
  iunlockput(dp);
80105f8a:	83 ec 0c             	sub    $0xc,%esp
80105f8d:	56                   	push   %esi
80105f8e:	e8 dd bd ff ff       	call   80101d70 <iunlockput>
  ip->nlink--;
80105f93:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105f98:	89 1c 24             	mov    %ebx,(%esp)
80105f9b:	e8 70 ba ff ff       	call   80101a10 <iupdate>
  iunlockput(ip);
80105fa0:	89 1c 24             	mov    %ebx,(%esp)
80105fa3:	e8 c8 bd ff ff       	call   80101d70 <iunlockput>
  end_op();
80105fa8:	e8 63 d1 ff ff       	call   80103110 <end_op>
  return 0;
80105fad:	83 c4 10             	add    $0x10,%esp
80105fb0:	31 c0                	xor    %eax,%eax
}
80105fb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fb5:	5b                   	pop    %ebx
80105fb6:	5e                   	pop    %esi
80105fb7:	5f                   	pop    %edi
80105fb8:	5d                   	pop    %ebp
80105fb9:	c3                   	ret    
80105fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105fc0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105fc4:	76 94                	jbe    80105f5a <sys_unlink+0xba>
80105fc6:	ba 20 00 00 00       	mov    $0x20,%edx
80105fcb:	eb 0b                	jmp    80105fd8 <sys_unlink+0x138>
80105fcd:	8d 76 00             	lea    0x0(%esi),%esi
80105fd0:	83 c2 10             	add    $0x10,%edx
80105fd3:	39 53 58             	cmp    %edx,0x58(%ebx)
80105fd6:	76 82                	jbe    80105f5a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105fd8:	6a 10                	push   $0x10
80105fda:	52                   	push   %edx
80105fdb:	57                   	push   %edi
80105fdc:	53                   	push   %ebx
80105fdd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105fe0:	e8 eb bd ff ff       	call   80101dd0 <readi>
80105fe5:	83 c4 10             	add    $0x10,%esp
80105fe8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105feb:	83 f8 10             	cmp    $0x10,%eax
80105fee:	75 69                	jne    80106059 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105ff0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105ff5:	74 d9                	je     80105fd0 <sys_unlink+0x130>
    iunlockput(ip);
80105ff7:	83 ec 0c             	sub    $0xc,%esp
80105ffa:	53                   	push   %ebx
80105ffb:	e8 70 bd ff ff       	call   80101d70 <iunlockput>
    goto bad;
80106000:	83 c4 10             	add    $0x10,%esp
80106003:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106007:	90                   	nop
  iunlockput(dp);
80106008:	83 ec 0c             	sub    $0xc,%esp
8010600b:	56                   	push   %esi
8010600c:	e8 5f bd ff ff       	call   80101d70 <iunlockput>
  end_op();
80106011:	e8 fa d0 ff ff       	call   80103110 <end_op>
  return -1;
80106016:	83 c4 10             	add    $0x10,%esp
80106019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010601e:	eb 92                	jmp    80105fb2 <sys_unlink+0x112>
    iupdate(dp);
80106020:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106023:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80106028:	56                   	push   %esi
80106029:	e8 e2 b9 ff ff       	call   80101a10 <iupdate>
8010602e:	83 c4 10             	add    $0x10,%esp
80106031:	e9 54 ff ff ff       	jmp    80105f8a <sys_unlink+0xea>
80106036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106045:	e9 68 ff ff ff       	jmp    80105fb2 <sys_unlink+0x112>
    end_op();
8010604a:	e8 c1 d0 ff ff       	call   80103110 <end_op>
    return -1;
8010604f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106054:	e9 59 ff ff ff       	jmp    80105fb2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80106059:	83 ec 0c             	sub    $0xc,%esp
8010605c:	68 98 8a 10 80       	push   $0x80108a98
80106061:	e8 2a a3 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80106066:	83 ec 0c             	sub    $0xc,%esp
80106069:	68 aa 8a 10 80       	push   $0x80108aaa
8010606e:	e8 1d a3 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80106073:	83 ec 0c             	sub    $0xc,%esp
80106076:	68 86 8a 10 80       	push   $0x80108a86
8010607b:	e8 10 a3 ff ff       	call   80100390 <panic>

80106080 <sys_open>:

int
sys_open(void)
{
80106080:	f3 0f 1e fb          	endbr32 
80106084:	55                   	push   %ebp
80106085:	89 e5                	mov    %esp,%ebp
80106087:	57                   	push   %edi
80106088:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106089:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010608c:	53                   	push   %ebx
8010608d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106090:	50                   	push   %eax
80106091:	6a 00                	push   $0x0
80106093:	e8 28 f8 ff ff       	call   801058c0 <argstr>
80106098:	83 c4 10             	add    $0x10,%esp
8010609b:	85 c0                	test   %eax,%eax
8010609d:	0f 88 8a 00 00 00    	js     8010612d <sys_open+0xad>
801060a3:	83 ec 08             	sub    $0x8,%esp
801060a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060a9:	50                   	push   %eax
801060aa:	6a 01                	push   $0x1
801060ac:	e8 5f f7 ff ff       	call   80105810 <argint>
801060b1:	83 c4 10             	add    $0x10,%esp
801060b4:	85 c0                	test   %eax,%eax
801060b6:	78 75                	js     8010612d <sys_open+0xad>
    return -1;

  begin_op();
801060b8:	e8 e3 cf ff ff       	call   801030a0 <begin_op>

  if(omode & O_CREATE){
801060bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801060c1:	75 75                	jne    80106138 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801060c3:	83 ec 0c             	sub    $0xc,%esp
801060c6:	ff 75 e0             	pushl  -0x20(%ebp)
801060c9:	e8 d2 c2 ff ff       	call   801023a0 <namei>
801060ce:	83 c4 10             	add    $0x10,%esp
801060d1:	89 c6                	mov    %eax,%esi
801060d3:	85 c0                	test   %eax,%eax
801060d5:	74 7e                	je     80106155 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801060d7:	83 ec 0c             	sub    $0xc,%esp
801060da:	50                   	push   %eax
801060db:	e8 f0 b9 ff ff       	call   80101ad0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801060e0:	83 c4 10             	add    $0x10,%esp
801060e3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801060e8:	0f 84 c2 00 00 00    	je     801061b0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801060ee:	e8 7d b0 ff ff       	call   80101170 <filealloc>
801060f3:	89 c7                	mov    %eax,%edi
801060f5:	85 c0                	test   %eax,%eax
801060f7:	74 23                	je     8010611c <sys_open+0x9c>
  struct proc *curproc = myproc();
801060f9:	e8 a2 dc ff ff       	call   80103da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060fe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106100:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106104:	85 d2                	test   %edx,%edx
80106106:	74 60                	je     80106168 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106108:	83 c3 01             	add    $0x1,%ebx
8010610b:	83 fb 10             	cmp    $0x10,%ebx
8010610e:	75 f0                	jne    80106100 <sys_open+0x80>
    if(f)
      fileclose(f);
80106110:	83 ec 0c             	sub    $0xc,%esp
80106113:	57                   	push   %edi
80106114:	e8 17 b1 ff ff       	call   80101230 <fileclose>
80106119:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010611c:	83 ec 0c             	sub    $0xc,%esp
8010611f:	56                   	push   %esi
80106120:	e8 4b bc ff ff       	call   80101d70 <iunlockput>
    end_op();
80106125:	e8 e6 cf ff ff       	call   80103110 <end_op>
    return -1;
8010612a:	83 c4 10             	add    $0x10,%esp
8010612d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106132:	eb 6d                	jmp    801061a1 <sys_open+0x121>
80106134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106138:	83 ec 0c             	sub    $0xc,%esp
8010613b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010613e:	31 c9                	xor    %ecx,%ecx
80106140:	ba 02 00 00 00       	mov    $0x2,%edx
80106145:	6a 00                	push   $0x0
80106147:	e8 24 f8 ff ff       	call   80105970 <create>
    if(ip == 0){
8010614c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010614f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106151:	85 c0                	test   %eax,%eax
80106153:	75 99                	jne    801060ee <sys_open+0x6e>
      end_op();
80106155:	e8 b6 cf ff ff       	call   80103110 <end_op>
      return -1;
8010615a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010615f:	eb 40                	jmp    801061a1 <sys_open+0x121>
80106161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106168:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010616b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010616f:	56                   	push   %esi
80106170:	e8 3b ba ff ff       	call   80101bb0 <iunlock>
  end_op();
80106175:	e8 96 cf ff ff       	call   80103110 <end_op>

  f->type = FD_INODE;
8010617a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106183:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106186:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106189:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010618b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106192:	f7 d0                	not    %eax
80106194:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106197:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010619a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010619d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801061a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061a4:	89 d8                	mov    %ebx,%eax
801061a6:	5b                   	pop    %ebx
801061a7:	5e                   	pop    %esi
801061a8:	5f                   	pop    %edi
801061a9:	5d                   	pop    %ebp
801061aa:	c3                   	ret    
801061ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061af:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801061b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801061b3:	85 c9                	test   %ecx,%ecx
801061b5:	0f 84 33 ff ff ff    	je     801060ee <sys_open+0x6e>
801061bb:	e9 5c ff ff ff       	jmp    8010611c <sys_open+0x9c>

801061c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801061c0:	f3 0f 1e fb          	endbr32 
801061c4:	55                   	push   %ebp
801061c5:	89 e5                	mov    %esp,%ebp
801061c7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801061ca:	e8 d1 ce ff ff       	call   801030a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801061cf:	83 ec 08             	sub    $0x8,%esp
801061d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061d5:	50                   	push   %eax
801061d6:	6a 00                	push   $0x0
801061d8:	e8 e3 f6 ff ff       	call   801058c0 <argstr>
801061dd:	83 c4 10             	add    $0x10,%esp
801061e0:	85 c0                	test   %eax,%eax
801061e2:	78 34                	js     80106218 <sys_mkdir+0x58>
801061e4:	83 ec 0c             	sub    $0xc,%esp
801061e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ea:	31 c9                	xor    %ecx,%ecx
801061ec:	ba 01 00 00 00       	mov    $0x1,%edx
801061f1:	6a 00                	push   $0x0
801061f3:	e8 78 f7 ff ff       	call   80105970 <create>
801061f8:	83 c4 10             	add    $0x10,%esp
801061fb:	85 c0                	test   %eax,%eax
801061fd:	74 19                	je     80106218 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801061ff:	83 ec 0c             	sub    $0xc,%esp
80106202:	50                   	push   %eax
80106203:	e8 68 bb ff ff       	call   80101d70 <iunlockput>
  end_op();
80106208:	e8 03 cf ff ff       	call   80103110 <end_op>
  return 0;
8010620d:	83 c4 10             	add    $0x10,%esp
80106210:	31 c0                	xor    %eax,%eax
}
80106212:	c9                   	leave  
80106213:	c3                   	ret    
80106214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106218:	e8 f3 ce ff ff       	call   80103110 <end_op>
    return -1;
8010621d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106222:	c9                   	leave  
80106223:	c3                   	ret    
80106224:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010622b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010622f:	90                   	nop

80106230 <sys_mknod>:

int
sys_mknod(void)
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010623a:	e8 61 ce ff ff       	call   801030a0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010623f:	83 ec 08             	sub    $0x8,%esp
80106242:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106245:	50                   	push   %eax
80106246:	6a 00                	push   $0x0
80106248:	e8 73 f6 ff ff       	call   801058c0 <argstr>
8010624d:	83 c4 10             	add    $0x10,%esp
80106250:	85 c0                	test   %eax,%eax
80106252:	78 64                	js     801062b8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80106254:	83 ec 08             	sub    $0x8,%esp
80106257:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010625a:	50                   	push   %eax
8010625b:	6a 01                	push   $0x1
8010625d:	e8 ae f5 ff ff       	call   80105810 <argint>
  if((argstr(0, &path)) < 0 ||
80106262:	83 c4 10             	add    $0x10,%esp
80106265:	85 c0                	test   %eax,%eax
80106267:	78 4f                	js     801062b8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80106269:	83 ec 08             	sub    $0x8,%esp
8010626c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010626f:	50                   	push   %eax
80106270:	6a 02                	push   $0x2
80106272:	e8 99 f5 ff ff       	call   80105810 <argint>
     argint(1, &major) < 0 ||
80106277:	83 c4 10             	add    $0x10,%esp
8010627a:	85 c0                	test   %eax,%eax
8010627c:	78 3a                	js     801062b8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010627e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80106282:	83 ec 0c             	sub    $0xc,%esp
80106285:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106289:	ba 03 00 00 00       	mov    $0x3,%edx
8010628e:	50                   	push   %eax
8010628f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106292:	e8 d9 f6 ff ff       	call   80105970 <create>
     argint(2, &minor) < 0 ||
80106297:	83 c4 10             	add    $0x10,%esp
8010629a:	85 c0                	test   %eax,%eax
8010629c:	74 1a                	je     801062b8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010629e:	83 ec 0c             	sub    $0xc,%esp
801062a1:	50                   	push   %eax
801062a2:	e8 c9 ba ff ff       	call   80101d70 <iunlockput>
  end_op();
801062a7:	e8 64 ce ff ff       	call   80103110 <end_op>
  return 0;
801062ac:	83 c4 10             	add    $0x10,%esp
801062af:	31 c0                	xor    %eax,%eax
}
801062b1:	c9                   	leave  
801062b2:	c3                   	ret    
801062b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062b7:	90                   	nop
    end_op();
801062b8:	e8 53 ce ff ff       	call   80103110 <end_op>
    return -1;
801062bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062c2:	c9                   	leave  
801062c3:	c3                   	ret    
801062c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062cf:	90                   	nop

801062d0 <sys_chdir>:

int
sys_chdir(void)
{
801062d0:	f3 0f 1e fb          	endbr32 
801062d4:	55                   	push   %ebp
801062d5:	89 e5                	mov    %esp,%ebp
801062d7:	56                   	push   %esi
801062d8:	53                   	push   %ebx
801062d9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801062dc:	e8 bf da ff ff       	call   80103da0 <myproc>
801062e1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801062e3:	e8 b8 cd ff ff       	call   801030a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801062e8:	83 ec 08             	sub    $0x8,%esp
801062eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062ee:	50                   	push   %eax
801062ef:	6a 00                	push   $0x0
801062f1:	e8 ca f5 ff ff       	call   801058c0 <argstr>
801062f6:	83 c4 10             	add    $0x10,%esp
801062f9:	85 c0                	test   %eax,%eax
801062fb:	78 73                	js     80106370 <sys_chdir+0xa0>
801062fd:	83 ec 0c             	sub    $0xc,%esp
80106300:	ff 75 f4             	pushl  -0xc(%ebp)
80106303:	e8 98 c0 ff ff       	call   801023a0 <namei>
80106308:	83 c4 10             	add    $0x10,%esp
8010630b:	89 c3                	mov    %eax,%ebx
8010630d:	85 c0                	test   %eax,%eax
8010630f:	74 5f                	je     80106370 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80106311:	83 ec 0c             	sub    $0xc,%esp
80106314:	50                   	push   %eax
80106315:	e8 b6 b7 ff ff       	call   80101ad0 <ilock>
  if(ip->type != T_DIR){
8010631a:	83 c4 10             	add    $0x10,%esp
8010631d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106322:	75 2c                	jne    80106350 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106324:	83 ec 0c             	sub    $0xc,%esp
80106327:	53                   	push   %ebx
80106328:	e8 83 b8 ff ff       	call   80101bb0 <iunlock>
  iput(curproc->cwd);
8010632d:	58                   	pop    %eax
8010632e:	ff 76 68             	pushl  0x68(%esi)
80106331:	e8 ca b8 ff ff       	call   80101c00 <iput>
  end_op();
80106336:	e8 d5 cd ff ff       	call   80103110 <end_op>
  curproc->cwd = ip;
8010633b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010633e:	83 c4 10             	add    $0x10,%esp
80106341:	31 c0                	xor    %eax,%eax
}
80106343:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106346:	5b                   	pop    %ebx
80106347:	5e                   	pop    %esi
80106348:	5d                   	pop    %ebp
80106349:	c3                   	ret    
8010634a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80106350:	83 ec 0c             	sub    $0xc,%esp
80106353:	53                   	push   %ebx
80106354:	e8 17 ba ff ff       	call   80101d70 <iunlockput>
    end_op();
80106359:	e8 b2 cd ff ff       	call   80103110 <end_op>
    return -1;
8010635e:	83 c4 10             	add    $0x10,%esp
80106361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106366:	eb db                	jmp    80106343 <sys_chdir+0x73>
80106368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010636f:	90                   	nop
    end_op();
80106370:	e8 9b cd ff ff       	call   80103110 <end_op>
    return -1;
80106375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010637a:	eb c7                	jmp    80106343 <sys_chdir+0x73>
8010637c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106380 <sys_exec>:

int
sys_exec(void)
{
80106380:	f3 0f 1e fb          	endbr32 
80106384:	55                   	push   %ebp
80106385:	89 e5                	mov    %esp,%ebp
80106387:	57                   	push   %edi
80106388:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106389:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010638f:	53                   	push   %ebx
80106390:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106396:	50                   	push   %eax
80106397:	6a 00                	push   $0x0
80106399:	e8 22 f5 ff ff       	call   801058c0 <argstr>
8010639e:	83 c4 10             	add    $0x10,%esp
801063a1:	85 c0                	test   %eax,%eax
801063a3:	0f 88 8b 00 00 00    	js     80106434 <sys_exec+0xb4>
801063a9:	83 ec 08             	sub    $0x8,%esp
801063ac:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801063b2:	50                   	push   %eax
801063b3:	6a 01                	push   $0x1
801063b5:	e8 56 f4 ff ff       	call   80105810 <argint>
801063ba:	83 c4 10             	add    $0x10,%esp
801063bd:	85 c0                	test   %eax,%eax
801063bf:	78 73                	js     80106434 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801063c1:	83 ec 04             	sub    $0x4,%esp
801063c4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801063ca:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801063cc:	68 80 00 00 00       	push   $0x80
801063d1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801063d7:	6a 00                	push   $0x0
801063d9:	50                   	push   %eax
801063da:	e8 51 f1 ff ff       	call   80105530 <memset>
801063df:	83 c4 10             	add    $0x10,%esp
801063e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801063e8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801063ee:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801063f5:	83 ec 08             	sub    $0x8,%esp
801063f8:	57                   	push   %edi
801063f9:	01 f0                	add    %esi,%eax
801063fb:	50                   	push   %eax
801063fc:	e8 6f f3 ff ff       	call   80105770 <fetchint>
80106401:	83 c4 10             	add    $0x10,%esp
80106404:	85 c0                	test   %eax,%eax
80106406:	78 2c                	js     80106434 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80106408:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010640e:	85 c0                	test   %eax,%eax
80106410:	74 36                	je     80106448 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106412:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106418:	83 ec 08             	sub    $0x8,%esp
8010641b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010641e:	52                   	push   %edx
8010641f:	50                   	push   %eax
80106420:	e8 8b f3 ff ff       	call   801057b0 <fetchstr>
80106425:	83 c4 10             	add    $0x10,%esp
80106428:	85 c0                	test   %eax,%eax
8010642a:	78 08                	js     80106434 <sys_exec+0xb4>
  for(i=0;; i++){
8010642c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010642f:	83 fb 20             	cmp    $0x20,%ebx
80106432:	75 b4                	jne    801063e8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106434:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106437:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010643c:	5b                   	pop    %ebx
8010643d:	5e                   	pop    %esi
8010643e:	5f                   	pop    %edi
8010643f:	5d                   	pop    %ebp
80106440:	c3                   	ret    
80106441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106448:	83 ec 08             	sub    $0x8,%esp
8010644b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80106451:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106458:	00 00 00 00 
  return exec(path, argv);
8010645c:	50                   	push   %eax
8010645d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106463:	e8 78 a9 ff ff       	call   80100de0 <exec>
80106468:	83 c4 10             	add    $0x10,%esp
}
8010646b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010646e:	5b                   	pop    %ebx
8010646f:	5e                   	pop    %esi
80106470:	5f                   	pop    %edi
80106471:	5d                   	pop    %ebp
80106472:	c3                   	ret    
80106473:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106480 <sys_pipe>:

int
sys_pipe(void)
{
80106480:	f3 0f 1e fb          	endbr32 
80106484:	55                   	push   %ebp
80106485:	89 e5                	mov    %esp,%ebp
80106487:	57                   	push   %edi
80106488:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106489:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010648c:	53                   	push   %ebx
8010648d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106490:	6a 08                	push   $0x8
80106492:	50                   	push   %eax
80106493:	6a 00                	push   $0x0
80106495:	e8 c6 f3 ff ff       	call   80105860 <argptr>
8010649a:	83 c4 10             	add    $0x10,%esp
8010649d:	85 c0                	test   %eax,%eax
8010649f:	78 4e                	js     801064ef <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801064a1:	83 ec 08             	sub    $0x8,%esp
801064a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064a7:	50                   	push   %eax
801064a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801064ab:	50                   	push   %eax
801064ac:	e8 af d2 ff ff       	call   80103760 <pipealloc>
801064b1:	83 c4 10             	add    $0x10,%esp
801064b4:	85 c0                	test   %eax,%eax
801064b6:	78 37                	js     801064ef <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801064b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801064bb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801064bd:	e8 de d8 ff ff       	call   80103da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801064c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801064c8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801064cc:	85 f6                	test   %esi,%esi
801064ce:	74 30                	je     80106500 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801064d0:	83 c3 01             	add    $0x1,%ebx
801064d3:	83 fb 10             	cmp    $0x10,%ebx
801064d6:	75 f0                	jne    801064c8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801064d8:	83 ec 0c             	sub    $0xc,%esp
801064db:	ff 75 e0             	pushl  -0x20(%ebp)
801064de:	e8 4d ad ff ff       	call   80101230 <fileclose>
    fileclose(wf);
801064e3:	58                   	pop    %eax
801064e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801064e7:	e8 44 ad ff ff       	call   80101230 <fileclose>
    return -1;
801064ec:	83 c4 10             	add    $0x10,%esp
801064ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064f4:	eb 5b                	jmp    80106551 <sys_pipe+0xd1>
801064f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064fd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106500:	8d 73 08             	lea    0x8(%ebx),%esi
80106503:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106507:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010650a:	e8 91 d8 ff ff       	call   80103da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010650f:	31 d2                	xor    %edx,%edx
80106511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106518:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010651c:	85 c9                	test   %ecx,%ecx
8010651e:	74 20                	je     80106540 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106520:	83 c2 01             	add    $0x1,%edx
80106523:	83 fa 10             	cmp    $0x10,%edx
80106526:	75 f0                	jne    80106518 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106528:	e8 73 d8 ff ff       	call   80103da0 <myproc>
8010652d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106534:	00 
80106535:	eb a1                	jmp    801064d8 <sys_pipe+0x58>
80106537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010653e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106540:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106544:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106547:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106549:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010654c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010654f:	31 c0                	xor    %eax,%eax
}
80106551:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106554:	5b                   	pop    %ebx
80106555:	5e                   	pop    %esi
80106556:	5f                   	pop    %edi
80106557:	5d                   	pop    %ebp
80106558:	c3                   	ret    
80106559:	66 90                	xchg   %ax,%ax
8010655b:	66 90                	xchg   %ax,%ax
8010655d:	66 90                	xchg   %ax,%ax
8010655f:	90                   	nop

80106560 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106560:	f3 0f 1e fb          	endbr32 
  return fork();
80106564:	e9 e7 d9 ff ff       	jmp    80103f50 <fork>
80106569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106570 <sys_exit>:
}

int
sys_exit(void)
{
80106570:	f3 0f 1e fb          	endbr32 
80106574:	55                   	push   %ebp
80106575:	89 e5                	mov    %esp,%ebp
80106577:	83 ec 08             	sub    $0x8,%esp
  exit();
8010657a:	e8 b1 e6 ff ff       	call   80104c30 <exit>
  return 0;  // not reached
}
8010657f:	31 c0                	xor    %eax,%eax
80106581:	c9                   	leave  
80106582:	c3                   	ret    
80106583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010658a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106590 <sys_wait>:

int
sys_wait(void)
{
80106590:	f3 0f 1e fb          	endbr32 
  return wait();
80106594:	e9 e7 e8 ff ff       	jmp    80104e80 <wait>
80106599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065a0 <sys_kill>:
}

int
sys_kill(void)
{
801065a0:	f3 0f 1e fb          	endbr32 
801065a4:	55                   	push   %ebp
801065a5:	89 e5                	mov    %esp,%ebp
801065a7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801065aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065ad:	50                   	push   %eax
801065ae:	6a 00                	push   $0x0
801065b0:	e8 5b f2 ff ff       	call   80105810 <argint>
801065b5:	83 c4 10             	add    $0x10,%esp
801065b8:	85 c0                	test   %eax,%eax
801065ba:	78 14                	js     801065d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801065bc:	83 ec 0c             	sub    $0xc,%esp
801065bf:	ff 75 f4             	pushl  -0xc(%ebp)
801065c2:	e8 29 ea ff ff       	call   80104ff0 <kill>
801065c7:	83 c4 10             	add    $0x10,%esp
}
801065ca:	c9                   	leave  
801065cb:	c3                   	ret    
801065cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065d0:	c9                   	leave  
    return -1;
801065d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065d6:	c3                   	ret    
801065d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065de:	66 90                	xchg   %ax,%ax

801065e0 <sys_getpid>:

int
sys_getpid(void)
{
801065e0:	f3 0f 1e fb          	endbr32 
801065e4:	55                   	push   %ebp
801065e5:	89 e5                	mov    %esp,%ebp
801065e7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801065ea:	e8 b1 d7 ff ff       	call   80103da0 <myproc>
801065ef:	8b 40 10             	mov    0x10(%eax),%eax
}
801065f2:	c9                   	leave  
801065f3:	c3                   	ret    
801065f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065ff:	90                   	nop

80106600 <sys_sbrk>:

int
sys_sbrk(void)
{
80106600:	f3 0f 1e fb          	endbr32 
80106604:	55                   	push   %ebp
80106605:	89 e5                	mov    %esp,%ebp
80106607:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106608:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010660b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010660e:	50                   	push   %eax
8010660f:	6a 00                	push   $0x0
80106611:	e8 fa f1 ff ff       	call   80105810 <argint>
80106616:	83 c4 10             	add    $0x10,%esp
80106619:	85 c0                	test   %eax,%eax
8010661b:	78 23                	js     80106640 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010661d:	e8 7e d7 ff ff       	call   80103da0 <myproc>
  if(growproc(n) < 0)
80106622:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106625:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106627:	ff 75 f4             	pushl  -0xc(%ebp)
8010662a:	e8 a1 d8 ff ff       	call   80103ed0 <growproc>
8010662f:	83 c4 10             	add    $0x10,%esp
80106632:	85 c0                	test   %eax,%eax
80106634:	78 0a                	js     80106640 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106636:	89 d8                	mov    %ebx,%eax
80106638:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010663b:	c9                   	leave  
8010663c:	c3                   	ret    
8010663d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106640:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106645:	eb ef                	jmp    80106636 <sys_sbrk+0x36>
80106647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010664e:	66 90                	xchg   %ax,%ax

80106650 <sys_sleep>:

int
sys_sleep(void)
{
80106650:	f3 0f 1e fb          	endbr32 
80106654:	55                   	push   %ebp
80106655:	89 e5                	mov    %esp,%ebp
80106657:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106658:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010665b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010665e:	50                   	push   %eax
8010665f:	6a 00                	push   $0x0
80106661:	e8 aa f1 ff ff       	call   80105810 <argint>
80106666:	83 c4 10             	add    $0x10,%esp
80106669:	85 c0                	test   %eax,%eax
8010666b:	0f 88 86 00 00 00    	js     801066f7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106671:	83 ec 0c             	sub    $0xc,%esp
80106674:	68 80 87 11 80       	push   $0x80118780
80106679:	e8 a2 ed ff ff       	call   80105420 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010667e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106681:	8b 1d c0 8f 11 80    	mov    0x80118fc0,%ebx
  while(ticks - ticks0 < n){
80106687:	83 c4 10             	add    $0x10,%esp
8010668a:	85 d2                	test   %edx,%edx
8010668c:	75 23                	jne    801066b1 <sys_sleep+0x61>
8010668e:	eb 50                	jmp    801066e0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106690:	83 ec 08             	sub    $0x8,%esp
80106693:	68 80 87 11 80       	push   $0x80118780
80106698:	68 c0 8f 11 80       	push   $0x80118fc0
8010669d:	e8 1e e7 ff ff       	call   80104dc0 <sleep>
  while(ticks - ticks0 < n){
801066a2:	a1 c0 8f 11 80       	mov    0x80118fc0,%eax
801066a7:	83 c4 10             	add    $0x10,%esp
801066aa:	29 d8                	sub    %ebx,%eax
801066ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801066af:	73 2f                	jae    801066e0 <sys_sleep+0x90>
    if(myproc()->killed){
801066b1:	e8 ea d6 ff ff       	call   80103da0 <myproc>
801066b6:	8b 40 24             	mov    0x24(%eax),%eax
801066b9:	85 c0                	test   %eax,%eax
801066bb:	74 d3                	je     80106690 <sys_sleep+0x40>
      release(&tickslock);
801066bd:	83 ec 0c             	sub    $0xc,%esp
801066c0:	68 80 87 11 80       	push   $0x80118780
801066c5:	e8 16 ee ff ff       	call   801054e0 <release>
  }
  release(&tickslock);
  return 0;
}
801066ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801066cd:	83 c4 10             	add    $0x10,%esp
801066d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066d5:	c9                   	leave  
801066d6:	c3                   	ret    
801066d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066de:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801066e0:	83 ec 0c             	sub    $0xc,%esp
801066e3:	68 80 87 11 80       	push   $0x80118780
801066e8:	e8 f3 ed ff ff       	call   801054e0 <release>
  return 0;
801066ed:	83 c4 10             	add    $0x10,%esp
801066f0:	31 c0                	xor    %eax,%eax
}
801066f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066f5:	c9                   	leave  
801066f6:	c3                   	ret    
    return -1;
801066f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066fc:	eb f4                	jmp    801066f2 <sys_sleep+0xa2>
801066fe:	66 90                	xchg   %ax,%ax

80106700 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106700:	f3 0f 1e fb          	endbr32 
80106704:	55                   	push   %ebp
80106705:	89 e5                	mov    %esp,%ebp
80106707:	53                   	push   %ebx
80106708:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010670b:	68 80 87 11 80       	push   $0x80118780
80106710:	e8 0b ed ff ff       	call   80105420 <acquire>
  xticks = ticks;
80106715:	8b 1d c0 8f 11 80    	mov    0x80118fc0,%ebx
  release(&tickslock);
8010671b:	c7 04 24 80 87 11 80 	movl   $0x80118780,(%esp)
80106722:	e8 b9 ed ff ff       	call   801054e0 <release>
  return xticks;
}
80106727:	89 d8                	mov    %ebx,%eax
80106729:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010672c:	c9                   	leave  
8010672d:	c3                   	ret    
8010672e:	66 90                	xchg   %ax,%ax

80106730 <sys_reverse_number>:

int
sys_reverse_number(void){
80106730:	f3 0f 1e fb          	endbr32 
80106734:	55                   	push   %ebp
80106735:	89 e5                	mov    %esp,%ebp
80106737:	57                   	push   %edi
80106738:	56                   	push   %esi
80106739:	8d 7d d8             	lea    -0x28(%ebp),%edi

  char answer[16] = {"\0"};

  int tmp = 0;
  do{
    answer[tmp] = (char) ((num % 10) + '0');
8010673c:	be 67 66 66 66       	mov    $0x66666667,%esi
sys_reverse_number(void){
80106741:	53                   	push   %ebx
80106742:	89 fb                	mov    %edi,%ebx
80106744:	83 ec 1c             	sub    $0x1c,%esp
  num = myproc()->tf->ebx;
80106747:	e8 54 d6 ff ff       	call   80103da0 <myproc>
  char answer[16] = {"\0"};
8010674c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  num = myproc()->tf->ebx;
80106753:	8b 40 18             	mov    0x18(%eax),%eax
80106756:	8b 48 10             	mov    0x10(%eax),%ecx
  char answer[16] = {"\0"};
80106759:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80106760:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106767:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int tmp = 0;
8010676e:	66 90                	xchg   %ax,%ax
    answer[tmp] = (char) ((num % 10) + '0');
80106770:	89 c8                	mov    %ecx,%eax
80106772:	83 c3 01             	add    $0x1,%ebx
80106775:	f7 ee                	imul   %esi
80106777:	89 c8                	mov    %ecx,%eax
80106779:	c1 f8 1f             	sar    $0x1f,%eax
8010677c:	c1 fa 02             	sar    $0x2,%edx
8010677f:	29 c2                	sub    %eax,%edx
80106781:	8d 04 92             	lea    (%edx,%edx,4),%eax
80106784:	01 c0                	add    %eax,%eax
80106786:	29 c1                	sub    %eax,%ecx
80106788:	83 c1 30             	add    $0x30,%ecx
8010678b:	88 4b ff             	mov    %cl,-0x1(%ebx)
    num /= 10;
8010678e:	89 d1                	mov    %edx,%ecx
    tmp++;
  }while(num);
80106790:	85 d2                	test   %edx,%edx
80106792:	75 dc                	jne    80106770 <sys_reverse_number+0x40>

  cprintf("%s\n" , answer);
80106794:	83 ec 08             	sub    $0x8,%esp
80106797:	57                   	push   %edi
80106798:	68 b9 8a 10 80       	push   $0x80108ab9
8010679d:	e8 0e 9f ff ff       	call   801006b0 <cprintf>
  return 0;
}
801067a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067a5:	31 c0                	xor    %eax,%eax
801067a7:	5b                   	pop    %ebx
801067a8:	5e                   	pop    %esi
801067a9:	5f                   	pop    %edi
801067aa:	5d                   	pop    %ebp
801067ab:	c3                   	ret    
801067ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801067b0 <sys_get_children>:

int 
sys_get_children(void){
801067b0:	f3 0f 1e fb          	endbr32 
801067b4:	55                   	push   %ebp
801067b5:	89 e5                	mov    %esp,%ebp
801067b7:	83 ec 1c             	sub    $0x1c,%esp
  int pid;
  argptr(0 , (void*)&pid , sizeof(pid));
801067ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067bd:	6a 04                	push   $0x4
801067bf:	50                   	push   %eax
801067c0:	6a 00                	push   $0x0
801067c2:	e8 99 f0 ff ff       	call   80105860 <argptr>

  int result = get_children(pid);
801067c7:	58                   	pop    %eax
801067c8:	ff 75 f4             	pushl  -0xc(%ebp)
801067cb:	e8 50 d9 ff ff       	call   80104120 <get_children>
  return result;
}
801067d0:	c9                   	leave  
801067d1:	c3                   	ret    
801067d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067e0 <sys_trace_syscalls>:

int
sys_trace_syscalls(void){
801067e0:	f3 0f 1e fb          	endbr32 
801067e4:	55                   	push   %ebp
801067e5:	89 e5                	mov    %esp,%ebp
801067e7:	83 ec 20             	sub    $0x20,%esp
  int state;
  argint(0, &state);
801067ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067ed:	50                   	push   %eax
801067ee:	6a 00                	push   $0x0
801067f0:	e8 1b f0 ff ff       	call   80105810 <argint>
  trace_syscalls(state);
801067f5:	58                   	pop    %eax
801067f6:	ff 75 f4             	pushl  -0xc(%ebp)
801067f9:	e8 b2 d9 ff ff       	call   801041b0 <trace_syscalls>
  return 0;
}
801067fe:	31 c0                	xor    %eax,%eax
80106800:	c9                   	leave  
80106801:	c3                   	ret    
80106802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106810 <sys_print_procs_info>:

int
sys_print_procs_info(void){
80106810:	f3 0f 1e fb          	endbr32 
80106814:	55                   	push   %ebp
80106815:	89 e5                	mov    %esp,%ebp
80106817:	83 ec 08             	sub    $0x8,%esp
  print_procs_info();
8010681a:	e8 f1 db ff ff       	call   80104410 <print_procs_info>
  return 0;
}
8010681f:	31 c0                	xor    %eax,%eax
80106821:	c9                   	leave  
80106822:	c3                   	ret    
80106823:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010682a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106830 <sys_change_queue>:

int
sys_change_queue(void){
80106830:	f3 0f 1e fb          	endbr32 
80106834:	55                   	push   %ebp
80106835:	89 e5                	mov    %esp,%ebp
80106837:	83 ec 1c             	sub    $0x1c,%esp
  int pid, new_queue;
  argptr(0 , (void*)&pid , sizeof(pid));
8010683a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010683d:	6a 04                	push   $0x4
8010683f:	50                   	push   %eax
80106840:	6a 00                	push   $0x0
80106842:	e8 19 f0 ff ff       	call   80105860 <argptr>
  argptr(1 , (void*)&new_queue , sizeof(new_queue));
80106847:	83 c4 0c             	add    $0xc,%esp
8010684a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010684d:	6a 04                	push   $0x4
8010684f:	50                   	push   %eax
80106850:	6a 01                	push   $0x1
80106852:	e8 09 f0 ff ff       	call   80105860 <argptr>

  change_queue(pid , new_queue);
80106857:	58                   	pop    %eax
80106858:	5a                   	pop    %edx
80106859:	ff 75 f4             	pushl  -0xc(%ebp)
8010685c:	ff 75 f0             	pushl  -0x10(%ebp)
8010685f:	e8 cc dc ff ff       	call   80104530 <change_queue>
  return 0;
}
80106864:	31 c0                	xor    %eax,%eax
80106866:	c9                   	leave  
80106867:	c3                   	ret    
80106868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010686f:	90                   	nop

80106870 <sys_change_ticket>:

int
sys_change_ticket(void){
80106870:	f3 0f 1e fb          	endbr32 
80106874:	55                   	push   %ebp
80106875:	89 e5                	mov    %esp,%ebp
80106877:	83 ec 1c             	sub    $0x1c,%esp
  int pid, new_ticket;
  argptr(0 , (void*)&pid , sizeof(pid));
8010687a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010687d:	6a 04                	push   $0x4
8010687f:	50                   	push   %eax
80106880:	6a 00                	push   $0x0
80106882:	e8 d9 ef ff ff       	call   80105860 <argptr>
  argptr(1 , (void*)&new_ticket , sizeof(new_ticket));
80106887:	83 c4 0c             	add    $0xc,%esp
8010688a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010688d:	6a 04                	push   $0x4
8010688f:	50                   	push   %eax
80106890:	6a 01                	push   $0x1
80106892:	e8 c9 ef ff ff       	call   80105860 <argptr>

  change_ticket(pid, new_ticket);
80106897:	58                   	pop    %eax
80106898:	5a                   	pop    %edx
80106899:	ff 75 f4             	pushl  -0xc(%ebp)
8010689c:	ff 75 f0             	pushl  -0x10(%ebp)
8010689f:	e8 cc dc ff ff       	call   80104570 <change_ticket>
  return 0;
}
801068a4:	31 c0                	xor    %eax,%eax
801068a6:	c9                   	leave  
801068a7:	c3                   	ret    
801068a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068af:	90                   	nop

801068b0 <sys_change_BJF_parameters_individual>:

int
sys_change_BJF_parameters_individual(void){
801068b0:	f3 0f 1e fb          	endbr32 
801068b4:	55                   	push   %ebp
801068b5:	89 e5                	mov    %esp,%ebp
801068b7:	83 ec 1c             	sub    $0x1c,%esp
  int pid;

  char* ratio[3];

  argptr(0 , (void*)&pid , sizeof(pid));
801068ba:	8d 45 e8             	lea    -0x18(%ebp),%eax
801068bd:	6a 04                	push   $0x4
801068bf:	50                   	push   %eax
801068c0:	6a 00                	push   $0x0
801068c2:	e8 99 ef ff ff       	call   80105860 <argptr>
  argstr(1 , (void*)&ratio[0]);
801068c7:	58                   	pop    %eax
801068c8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801068cb:	5a                   	pop    %edx
801068cc:	50                   	push   %eax
801068cd:	6a 01                	push   $0x1
801068cf:	e8 ec ef ff ff       	call   801058c0 <argstr>
  argstr(2 , (void*)&ratio[1]);
801068d4:	59                   	pop    %ecx
801068d5:	58                   	pop    %eax
801068d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068d9:	50                   	push   %eax
801068da:	6a 02                	push   $0x2
801068dc:	e8 df ef ff ff       	call   801058c0 <argstr>
  argstr(3 , (void*)&ratio[2]);
801068e1:	58                   	pop    %eax
801068e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068e5:	5a                   	pop    %edx
801068e6:	50                   	push   %eax
801068e7:	6a 03                	push   $0x3
801068e9:	e8 d2 ef ff ff       	call   801058c0 <argstr>

  change_BJF_parameters_individual(pid, ratio[0], ratio[1], ratio[2]);
801068ee:	ff 75 f4             	pushl  -0xc(%ebp)
801068f1:	ff 75 f0             	pushl  -0x10(%ebp)
801068f4:	ff 75 ec             	pushl  -0x14(%ebp)
801068f7:	ff 75 e8             	pushl  -0x18(%ebp)
801068fa:	e8 41 dd ff ff       	call   80104640 <change_BJF_parameters_individual>
  return 0; 
}
801068ff:	31 c0                	xor    %eax,%eax
80106901:	c9                   	leave  
80106902:	c3                   	ret    
80106903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010690a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106910 <sys_change_BJF_parameters_all>:

int
sys_change_BJF_parameters_all(void){
80106910:	f3 0f 1e fb          	endbr32 
80106914:	55                   	push   %ebp
80106915:	89 e5                	mov    %esp,%ebp
80106917:	83 ec 20             	sub    $0x20,%esp
  char* ratio[3];

  argstr(0 , (void*)&ratio[0]);
8010691a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010691d:	50                   	push   %eax
8010691e:	6a 00                	push   $0x0
80106920:	e8 9b ef ff ff       	call   801058c0 <argstr>
  argstr(1 , (void*)&ratio[1]);
80106925:	58                   	pop    %eax
80106926:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106929:	5a                   	pop    %edx
8010692a:	50                   	push   %eax
8010692b:	6a 01                	push   $0x1
8010692d:	e8 8e ef ff ff       	call   801058c0 <argstr>
  argstr(2 , (void*)&ratio[2]); 
80106932:	59                   	pop    %ecx
80106933:	58                   	pop    %eax
80106934:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106937:	50                   	push   %eax
80106938:	6a 02                	push   $0x2
8010693a:	e8 81 ef ff ff       	call   801058c0 <argstr>

  change_BJF_parameters_all(ratio[0], ratio[1], ratio[2]);
8010693f:	83 c4 0c             	add    $0xc,%esp
80106942:	ff 75 f4             	pushl  -0xc(%ebp)
80106945:	ff 75 f0             	pushl  -0x10(%ebp)
80106948:	ff 75 ec             	pushl  -0x14(%ebp)
8010694b:	e8 70 dd ff ff       	call   801046c0 <change_BJF_parameters_all>
  return 0;
80106950:	31 c0                	xor    %eax,%eax
80106952:	c9                   	leave  
80106953:	c3                   	ret    

80106954 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106954:	1e                   	push   %ds
  pushl %es
80106955:	06                   	push   %es
  pushl %fs
80106956:	0f a0                	push   %fs
  pushl %gs
80106958:	0f a8                	push   %gs
  pushal
8010695a:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010695b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010695f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106961:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106963:	54                   	push   %esp
  call trap
80106964:	e8 c7 00 00 00       	call   80106a30 <trap>
  addl $4, %esp
80106969:	83 c4 04             	add    $0x4,%esp

8010696c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010696c:	61                   	popa   
  popl %gs
8010696d:	0f a9                	pop    %gs
  popl %fs
8010696f:	0f a1                	pop    %fs
  popl %es
80106971:	07                   	pop    %es
  popl %ds
80106972:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106973:	83 c4 08             	add    $0x8,%esp
  iret
80106976:	cf                   	iret   
80106977:	66 90                	xchg   %ax,%ax
80106979:	66 90                	xchg   %ax,%ax
8010697b:	66 90                	xchg   %ax,%ax
8010697d:	66 90                	xchg   %ax,%ax
8010697f:	90                   	nop

80106980 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106980:	f3 0f 1e fb          	endbr32 
80106984:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106985:	31 c0                	xor    %eax,%eax
{
80106987:	89 e5                	mov    %esp,%ebp
80106989:	83 ec 08             	sub    $0x8,%esp
8010698c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106990:	8b 14 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%edx
80106997:	c7 04 c5 c2 87 11 80 	movl   $0x8e000008,-0x7fee783e(,%eax,8)
8010699e:	08 00 00 8e 
801069a2:	66 89 14 c5 c0 87 11 	mov    %dx,-0x7fee7840(,%eax,8)
801069a9:	80 
801069aa:	c1 ea 10             	shr    $0x10,%edx
801069ad:	66 89 14 c5 c6 87 11 	mov    %dx,-0x7fee783a(,%eax,8)
801069b4:	80 
  for(i = 0; i < 256; i++)
801069b5:	83 c0 01             	add    $0x1,%eax
801069b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801069bd:	75 d1                	jne    80106990 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801069bf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801069c2:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801069c7:	c7 05 c2 89 11 80 08 	movl   $0xef000008,0x801189c2
801069ce:	00 00 ef 
  initlock(&tickslock, "time");
801069d1:	68 cb 88 10 80       	push   $0x801088cb
801069d6:	68 80 87 11 80       	push   $0x80118780
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801069db:	66 a3 c0 89 11 80    	mov    %ax,0x801189c0
801069e1:	c1 e8 10             	shr    $0x10,%eax
801069e4:	66 a3 c6 89 11 80    	mov    %ax,0x801189c6
  initlock(&tickslock, "time");
801069ea:	e8 b1 e8 ff ff       	call   801052a0 <initlock>
}
801069ef:	83 c4 10             	add    $0x10,%esp
801069f2:	c9                   	leave  
801069f3:	c3                   	ret    
801069f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069ff:	90                   	nop

80106a00 <idtinit>:

void
idtinit(void)
{
80106a00:	f3 0f 1e fb          	endbr32 
80106a04:	55                   	push   %ebp
  pd[0] = size-1;
80106a05:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106a0a:	89 e5                	mov    %esp,%ebp
80106a0c:	83 ec 10             	sub    $0x10,%esp
80106a0f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a13:	b8 c0 87 11 80       	mov    $0x801187c0,%eax
80106a18:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a1c:	c1 e8 10             	shr    $0x10,%eax
80106a1f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106a23:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a26:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106a29:	c9                   	leave  
80106a2a:	c3                   	ret    
80106a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a2f:	90                   	nop

80106a30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106a30:	f3 0f 1e fb          	endbr32 
80106a34:	55                   	push   %ebp
80106a35:	89 e5                	mov    %esp,%ebp
80106a37:	57                   	push   %edi
80106a38:	56                   	push   %esi
80106a39:	53                   	push   %ebx
80106a3a:	83 ec 1c             	sub    $0x1c,%esp
80106a3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106a40:	8b 43 30             	mov    0x30(%ebx),%eax
80106a43:	83 f8 40             	cmp    $0x40,%eax
80106a46:	0f 84 bc 01 00 00    	je     80106c08 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106a4c:	83 e8 20             	sub    $0x20,%eax
80106a4f:	83 f8 1f             	cmp    $0x1f,%eax
80106a52:	77 08                	ja     80106a5c <trap+0x2c>
80106a54:	3e ff 24 85 60 8b 10 	notrack jmp *-0x7fef74a0(,%eax,4)
80106a5b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106a5c:	e8 3f d3 ff ff       	call   80103da0 <myproc>
80106a61:	8b 7b 38             	mov    0x38(%ebx),%edi
80106a64:	85 c0                	test   %eax,%eax
80106a66:	0f 84 eb 01 00 00    	je     80106c57 <trap+0x227>
80106a6c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106a70:	0f 84 e1 01 00 00    	je     80106c57 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106a76:	0f 20 d1             	mov    %cr2,%ecx
80106a79:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a7c:	e8 cf d2 ff ff       	call   80103d50 <cpuid>
80106a81:	8b 73 30             	mov    0x30(%ebx),%esi
80106a84:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a87:	8b 43 34             	mov    0x34(%ebx),%eax
80106a8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106a8d:	e8 0e d3 ff ff       	call   80103da0 <myproc>
80106a92:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a95:	e8 06 d3 ff ff       	call   80103da0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a9a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106a9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106aa0:	51                   	push   %ecx
80106aa1:	57                   	push   %edi
80106aa2:	52                   	push   %edx
80106aa3:	ff 75 e4             	pushl  -0x1c(%ebp)
80106aa6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106aa7:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106aaa:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106aad:	56                   	push   %esi
80106aae:	ff 70 10             	pushl  0x10(%eax)
80106ab1:	68 1c 8b 10 80       	push   $0x80108b1c
80106ab6:	e8 f5 9b ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106abb:	83 c4 20             	add    $0x20,%esp
80106abe:	e8 dd d2 ff ff       	call   80103da0 <myproc>
80106ac3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106aca:	e8 d1 d2 ff ff       	call   80103da0 <myproc>
80106acf:	85 c0                	test   %eax,%eax
80106ad1:	74 1d                	je     80106af0 <trap+0xc0>
80106ad3:	e8 c8 d2 ff ff       	call   80103da0 <myproc>
80106ad8:	8b 50 24             	mov    0x24(%eax),%edx
80106adb:	85 d2                	test   %edx,%edx
80106add:	74 11                	je     80106af0 <trap+0xc0>
80106adf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106ae3:	83 e0 03             	and    $0x3,%eax
80106ae6:	66 83 f8 03          	cmp    $0x3,%ax
80106aea:	0f 84 50 01 00 00    	je     80106c40 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106af0:	e8 ab d2 ff ff       	call   80103da0 <myproc>
80106af5:	85 c0                	test   %eax,%eax
80106af7:	74 0f                	je     80106b08 <trap+0xd8>
80106af9:	e8 a2 d2 ff ff       	call   80103da0 <myproc>
80106afe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106b02:	0f 84 e8 00 00 00    	je     80106bf0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b08:	e8 93 d2 ff ff       	call   80103da0 <myproc>
80106b0d:	85 c0                	test   %eax,%eax
80106b0f:	74 1d                	je     80106b2e <trap+0xfe>
80106b11:	e8 8a d2 ff ff       	call   80103da0 <myproc>
80106b16:	8b 40 24             	mov    0x24(%eax),%eax
80106b19:	85 c0                	test   %eax,%eax
80106b1b:	74 11                	je     80106b2e <trap+0xfe>
80106b1d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106b21:	83 e0 03             	and    $0x3,%eax
80106b24:	66 83 f8 03          	cmp    $0x3,%ax
80106b28:	0f 84 03 01 00 00    	je     80106c31 <trap+0x201>
    exit();
}
80106b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b31:	5b                   	pop    %ebx
80106b32:	5e                   	pop    %esi
80106b33:	5f                   	pop    %edi
80106b34:	5d                   	pop    %ebp
80106b35:	c3                   	ret    
    ideintr();
80106b36:	e8 15 ba ff ff       	call   80102550 <ideintr>
    lapiceoi();
80106b3b:	e8 f0 c0 ff ff       	call   80102c30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b40:	e8 5b d2 ff ff       	call   80103da0 <myproc>
80106b45:	85 c0                	test   %eax,%eax
80106b47:	75 8a                	jne    80106ad3 <trap+0xa3>
80106b49:	eb a5                	jmp    80106af0 <trap+0xc0>
    if(cpuid() == 0){
80106b4b:	e8 00 d2 ff ff       	call   80103d50 <cpuid>
80106b50:	85 c0                	test   %eax,%eax
80106b52:	75 e7                	jne    80106b3b <trap+0x10b>
      acquire(&tickslock);
80106b54:	83 ec 0c             	sub    $0xc,%esp
80106b57:	68 80 87 11 80       	push   $0x80118780
80106b5c:	e8 bf e8 ff ff       	call   80105420 <acquire>
      wakeup(&ticks);
80106b61:	c7 04 24 c0 8f 11 80 	movl   $0x80118fc0,(%esp)
      ticks++;
80106b68:	83 05 c0 8f 11 80 01 	addl   $0x1,0x80118fc0
      wakeup(&ticks);
80106b6f:	e8 0c e4 ff ff       	call   80104f80 <wakeup>
      release(&tickslock);
80106b74:	c7 04 24 80 87 11 80 	movl   $0x80118780,(%esp)
80106b7b:	e8 60 e9 ff ff       	call   801054e0 <release>
80106b80:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106b83:	eb b6                	jmp    80106b3b <trap+0x10b>
    kbdintr();
80106b85:	e8 66 bf ff ff       	call   80102af0 <kbdintr>
    lapiceoi();
80106b8a:	e8 a1 c0 ff ff       	call   80102c30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b8f:	e8 0c d2 ff ff       	call   80103da0 <myproc>
80106b94:	85 c0                	test   %eax,%eax
80106b96:	0f 85 37 ff ff ff    	jne    80106ad3 <trap+0xa3>
80106b9c:	e9 4f ff ff ff       	jmp    80106af0 <trap+0xc0>
    uartintr();
80106ba1:	e8 4a 02 00 00       	call   80106df0 <uartintr>
    lapiceoi();
80106ba6:	e8 85 c0 ff ff       	call   80102c30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106bab:	e8 f0 d1 ff ff       	call   80103da0 <myproc>
80106bb0:	85 c0                	test   %eax,%eax
80106bb2:	0f 85 1b ff ff ff    	jne    80106ad3 <trap+0xa3>
80106bb8:	e9 33 ff ff ff       	jmp    80106af0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106bbd:	8b 7b 38             	mov    0x38(%ebx),%edi
80106bc0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106bc4:	e8 87 d1 ff ff       	call   80103d50 <cpuid>
80106bc9:	57                   	push   %edi
80106bca:	56                   	push   %esi
80106bcb:	50                   	push   %eax
80106bcc:	68 c4 8a 10 80       	push   $0x80108ac4
80106bd1:	e8 da 9a ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106bd6:	e8 55 c0 ff ff       	call   80102c30 <lapiceoi>
    break;
80106bdb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106bde:	e8 bd d1 ff ff       	call   80103da0 <myproc>
80106be3:	85 c0                	test   %eax,%eax
80106be5:	0f 85 e8 fe ff ff    	jne    80106ad3 <trap+0xa3>
80106beb:	e9 00 ff ff ff       	jmp    80106af0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106bf0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106bf4:	0f 85 0e ff ff ff    	jne    80106b08 <trap+0xd8>
    yield();
80106bfa:	e8 71 e1 ff ff       	call   80104d70 <yield>
80106bff:	e9 04 ff ff ff       	jmp    80106b08 <trap+0xd8>
80106c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106c08:	e8 93 d1 ff ff       	call   80103da0 <myproc>
80106c0d:	8b 70 24             	mov    0x24(%eax),%esi
80106c10:	85 f6                	test   %esi,%esi
80106c12:	75 3c                	jne    80106c50 <trap+0x220>
    myproc()->tf = tf;
80106c14:	e8 87 d1 ff ff       	call   80103da0 <myproc>
80106c19:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106c1c:	e8 df ec ff ff       	call   80105900 <syscall>
    if(myproc()->killed)
80106c21:	e8 7a d1 ff ff       	call   80103da0 <myproc>
80106c26:	8b 48 24             	mov    0x24(%eax),%ecx
80106c29:	85 c9                	test   %ecx,%ecx
80106c2b:	0f 84 fd fe ff ff    	je     80106b2e <trap+0xfe>
}
80106c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c34:	5b                   	pop    %ebx
80106c35:	5e                   	pop    %esi
80106c36:	5f                   	pop    %edi
80106c37:	5d                   	pop    %ebp
      exit();
80106c38:	e9 f3 df ff ff       	jmp    80104c30 <exit>
80106c3d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106c40:	e8 eb df ff ff       	call   80104c30 <exit>
80106c45:	e9 a6 fe ff ff       	jmp    80106af0 <trap+0xc0>
80106c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106c50:	e8 db df ff ff       	call   80104c30 <exit>
80106c55:	eb bd                	jmp    80106c14 <trap+0x1e4>
80106c57:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106c5a:	e8 f1 d0 ff ff       	call   80103d50 <cpuid>
80106c5f:	83 ec 0c             	sub    $0xc,%esp
80106c62:	56                   	push   %esi
80106c63:	57                   	push   %edi
80106c64:	50                   	push   %eax
80106c65:	ff 73 30             	pushl  0x30(%ebx)
80106c68:	68 e8 8a 10 80       	push   $0x80108ae8
80106c6d:	e8 3e 9a ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106c72:	83 c4 14             	add    $0x14,%esp
80106c75:	68 bd 8a 10 80       	push   $0x80108abd
80106c7a:	e8 11 97 ff ff       	call   80100390 <panic>
80106c7f:	90                   	nop

80106c80 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106c80:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106c84:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80106c89:	85 c0                	test   %eax,%eax
80106c8b:	74 1b                	je     80106ca8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106c8d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106c92:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106c93:	a8 01                	test   $0x1,%al
80106c95:	74 11                	je     80106ca8 <uartgetc+0x28>
80106c97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c9c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106c9d:	0f b6 c0             	movzbl %al,%eax
80106ca0:	c3                   	ret    
80106ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106ca8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cad:	c3                   	ret    
80106cae:	66 90                	xchg   %ax,%ax

80106cb0 <uartputc.part.0>:
uartputc(int c)
80106cb0:	55                   	push   %ebp
80106cb1:	89 e5                	mov    %esp,%ebp
80106cb3:	57                   	push   %edi
80106cb4:	89 c7                	mov    %eax,%edi
80106cb6:	56                   	push   %esi
80106cb7:	be fd 03 00 00       	mov    $0x3fd,%esi
80106cbc:	53                   	push   %ebx
80106cbd:	bb 80 00 00 00       	mov    $0x80,%ebx
80106cc2:	83 ec 0c             	sub    $0xc,%esp
80106cc5:	eb 1b                	jmp    80106ce2 <uartputc.part.0+0x32>
80106cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cce:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106cd0:	83 ec 0c             	sub    $0xc,%esp
80106cd3:	6a 0a                	push   $0xa
80106cd5:	e8 76 bf ff ff       	call   80102c50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106cda:	83 c4 10             	add    $0x10,%esp
80106cdd:	83 eb 01             	sub    $0x1,%ebx
80106ce0:	74 07                	je     80106ce9 <uartputc.part.0+0x39>
80106ce2:	89 f2                	mov    %esi,%edx
80106ce4:	ec                   	in     (%dx),%al
80106ce5:	a8 20                	test   $0x20,%al
80106ce7:	74 e7                	je     80106cd0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ce9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106cee:	89 f8                	mov    %edi,%eax
80106cf0:	ee                   	out    %al,(%dx)
}
80106cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cf4:	5b                   	pop    %ebx
80106cf5:	5e                   	pop    %esi
80106cf6:	5f                   	pop    %edi
80106cf7:	5d                   	pop    %ebp
80106cf8:	c3                   	ret    
80106cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d00 <uartinit>:
{
80106d00:	f3 0f 1e fb          	endbr32 
80106d04:	55                   	push   %ebp
80106d05:	31 c9                	xor    %ecx,%ecx
80106d07:	89 c8                	mov    %ecx,%eax
80106d09:	89 e5                	mov    %esp,%ebp
80106d0b:	57                   	push   %edi
80106d0c:	56                   	push   %esi
80106d0d:	53                   	push   %ebx
80106d0e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106d13:	89 da                	mov    %ebx,%edx
80106d15:	83 ec 0c             	sub    $0xc,%esp
80106d18:	ee                   	out    %al,(%dx)
80106d19:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106d1e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106d23:	89 fa                	mov    %edi,%edx
80106d25:	ee                   	out    %al,(%dx)
80106d26:	b8 0c 00 00 00       	mov    $0xc,%eax
80106d2b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d30:	ee                   	out    %al,(%dx)
80106d31:	be f9 03 00 00       	mov    $0x3f9,%esi
80106d36:	89 c8                	mov    %ecx,%eax
80106d38:	89 f2                	mov    %esi,%edx
80106d3a:	ee                   	out    %al,(%dx)
80106d3b:	b8 03 00 00 00       	mov    $0x3,%eax
80106d40:	89 fa                	mov    %edi,%edx
80106d42:	ee                   	out    %al,(%dx)
80106d43:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106d48:	89 c8                	mov    %ecx,%eax
80106d4a:	ee                   	out    %al,(%dx)
80106d4b:	b8 01 00 00 00       	mov    $0x1,%eax
80106d50:	89 f2                	mov    %esi,%edx
80106d52:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d53:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106d58:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106d59:	3c ff                	cmp    $0xff,%al
80106d5b:	74 52                	je     80106daf <uartinit+0xaf>
  uart = 1;
80106d5d:	c7 05 3c b6 10 80 01 	movl   $0x1,0x8010b63c
80106d64:	00 00 00 
80106d67:	89 da                	mov    %ebx,%edx
80106d69:	ec                   	in     (%dx),%al
80106d6a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d6f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106d70:	83 ec 08             	sub    $0x8,%esp
80106d73:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106d78:	bb e0 8b 10 80       	mov    $0x80108be0,%ebx
  ioapicenable(IRQ_COM1, 0);
80106d7d:	6a 00                	push   $0x0
80106d7f:	6a 04                	push   $0x4
80106d81:	e8 1a ba ff ff       	call   801027a0 <ioapicenable>
80106d86:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106d89:	b8 78 00 00 00       	mov    $0x78,%eax
80106d8e:	eb 04                	jmp    80106d94 <uartinit+0x94>
80106d90:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106d94:	8b 15 3c b6 10 80    	mov    0x8010b63c,%edx
80106d9a:	85 d2                	test   %edx,%edx
80106d9c:	74 08                	je     80106da6 <uartinit+0xa6>
    uartputc(*p);
80106d9e:	0f be c0             	movsbl %al,%eax
80106da1:	e8 0a ff ff ff       	call   80106cb0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106da6:	89 f0                	mov    %esi,%eax
80106da8:	83 c3 01             	add    $0x1,%ebx
80106dab:	84 c0                	test   %al,%al
80106dad:	75 e1                	jne    80106d90 <uartinit+0x90>
}
80106daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106db2:	5b                   	pop    %ebx
80106db3:	5e                   	pop    %esi
80106db4:	5f                   	pop    %edi
80106db5:	5d                   	pop    %ebp
80106db6:	c3                   	ret    
80106db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dbe:	66 90                	xchg   %ax,%ax

80106dc0 <uartputc>:
{
80106dc0:	f3 0f 1e fb          	endbr32 
80106dc4:	55                   	push   %ebp
  if(!uart)
80106dc5:	8b 15 3c b6 10 80    	mov    0x8010b63c,%edx
{
80106dcb:	89 e5                	mov    %esp,%ebp
80106dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106dd0:	85 d2                	test   %edx,%edx
80106dd2:	74 0c                	je     80106de0 <uartputc+0x20>
}
80106dd4:	5d                   	pop    %ebp
80106dd5:	e9 d6 fe ff ff       	jmp    80106cb0 <uartputc.part.0>
80106dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106de0:	5d                   	pop    %ebp
80106de1:	c3                   	ret    
80106de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106df0 <uartintr>:

void
uartintr(void)
{
80106df0:	f3 0f 1e fb          	endbr32 
80106df4:	55                   	push   %ebp
80106df5:	89 e5                	mov    %esp,%ebp
80106df7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106dfa:	68 80 6c 10 80       	push   $0x80106c80
80106dff:	e8 3c 9d ff ff       	call   80100b40 <consoleintr>
}
80106e04:	83 c4 10             	add    $0x10,%esp
80106e07:	c9                   	leave  
80106e08:	c3                   	ret    

80106e09 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $0
80106e0b:	6a 00                	push   $0x0
  jmp alltraps
80106e0d:	e9 42 fb ff ff       	jmp    80106954 <alltraps>

80106e12 <vector1>:
.globl vector1
vector1:
  pushl $0
80106e12:	6a 00                	push   $0x0
  pushl $1
80106e14:	6a 01                	push   $0x1
  jmp alltraps
80106e16:	e9 39 fb ff ff       	jmp    80106954 <alltraps>

80106e1b <vector2>:
.globl vector2
vector2:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $2
80106e1d:	6a 02                	push   $0x2
  jmp alltraps
80106e1f:	e9 30 fb ff ff       	jmp    80106954 <alltraps>

80106e24 <vector3>:
.globl vector3
vector3:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $3
80106e26:	6a 03                	push   $0x3
  jmp alltraps
80106e28:	e9 27 fb ff ff       	jmp    80106954 <alltraps>

80106e2d <vector4>:
.globl vector4
vector4:
  pushl $0
80106e2d:	6a 00                	push   $0x0
  pushl $4
80106e2f:	6a 04                	push   $0x4
  jmp alltraps
80106e31:	e9 1e fb ff ff       	jmp    80106954 <alltraps>

80106e36 <vector5>:
.globl vector5
vector5:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $5
80106e38:	6a 05                	push   $0x5
  jmp alltraps
80106e3a:	e9 15 fb ff ff       	jmp    80106954 <alltraps>

80106e3f <vector6>:
.globl vector6
vector6:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $6
80106e41:	6a 06                	push   $0x6
  jmp alltraps
80106e43:	e9 0c fb ff ff       	jmp    80106954 <alltraps>

80106e48 <vector7>:
.globl vector7
vector7:
  pushl $0
80106e48:	6a 00                	push   $0x0
  pushl $7
80106e4a:	6a 07                	push   $0x7
  jmp alltraps
80106e4c:	e9 03 fb ff ff       	jmp    80106954 <alltraps>

80106e51 <vector8>:
.globl vector8
vector8:
  pushl $8
80106e51:	6a 08                	push   $0x8
  jmp alltraps
80106e53:	e9 fc fa ff ff       	jmp    80106954 <alltraps>

80106e58 <vector9>:
.globl vector9
vector9:
  pushl $0
80106e58:	6a 00                	push   $0x0
  pushl $9
80106e5a:	6a 09                	push   $0x9
  jmp alltraps
80106e5c:	e9 f3 fa ff ff       	jmp    80106954 <alltraps>

80106e61 <vector10>:
.globl vector10
vector10:
  pushl $10
80106e61:	6a 0a                	push   $0xa
  jmp alltraps
80106e63:	e9 ec fa ff ff       	jmp    80106954 <alltraps>

80106e68 <vector11>:
.globl vector11
vector11:
  pushl $11
80106e68:	6a 0b                	push   $0xb
  jmp alltraps
80106e6a:	e9 e5 fa ff ff       	jmp    80106954 <alltraps>

80106e6f <vector12>:
.globl vector12
vector12:
  pushl $12
80106e6f:	6a 0c                	push   $0xc
  jmp alltraps
80106e71:	e9 de fa ff ff       	jmp    80106954 <alltraps>

80106e76 <vector13>:
.globl vector13
vector13:
  pushl $13
80106e76:	6a 0d                	push   $0xd
  jmp alltraps
80106e78:	e9 d7 fa ff ff       	jmp    80106954 <alltraps>

80106e7d <vector14>:
.globl vector14
vector14:
  pushl $14
80106e7d:	6a 0e                	push   $0xe
  jmp alltraps
80106e7f:	e9 d0 fa ff ff       	jmp    80106954 <alltraps>

80106e84 <vector15>:
.globl vector15
vector15:
  pushl $0
80106e84:	6a 00                	push   $0x0
  pushl $15
80106e86:	6a 0f                	push   $0xf
  jmp alltraps
80106e88:	e9 c7 fa ff ff       	jmp    80106954 <alltraps>

80106e8d <vector16>:
.globl vector16
vector16:
  pushl $0
80106e8d:	6a 00                	push   $0x0
  pushl $16
80106e8f:	6a 10                	push   $0x10
  jmp alltraps
80106e91:	e9 be fa ff ff       	jmp    80106954 <alltraps>

80106e96 <vector17>:
.globl vector17
vector17:
  pushl $17
80106e96:	6a 11                	push   $0x11
  jmp alltraps
80106e98:	e9 b7 fa ff ff       	jmp    80106954 <alltraps>

80106e9d <vector18>:
.globl vector18
vector18:
  pushl $0
80106e9d:	6a 00                	push   $0x0
  pushl $18
80106e9f:	6a 12                	push   $0x12
  jmp alltraps
80106ea1:	e9 ae fa ff ff       	jmp    80106954 <alltraps>

80106ea6 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $19
80106ea8:	6a 13                	push   $0x13
  jmp alltraps
80106eaa:	e9 a5 fa ff ff       	jmp    80106954 <alltraps>

80106eaf <vector20>:
.globl vector20
vector20:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $20
80106eb1:	6a 14                	push   $0x14
  jmp alltraps
80106eb3:	e9 9c fa ff ff       	jmp    80106954 <alltraps>

80106eb8 <vector21>:
.globl vector21
vector21:
  pushl $0
80106eb8:	6a 00                	push   $0x0
  pushl $21
80106eba:	6a 15                	push   $0x15
  jmp alltraps
80106ebc:	e9 93 fa ff ff       	jmp    80106954 <alltraps>

80106ec1 <vector22>:
.globl vector22
vector22:
  pushl $0
80106ec1:	6a 00                	push   $0x0
  pushl $22
80106ec3:	6a 16                	push   $0x16
  jmp alltraps
80106ec5:	e9 8a fa ff ff       	jmp    80106954 <alltraps>

80106eca <vector23>:
.globl vector23
vector23:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $23
80106ecc:	6a 17                	push   $0x17
  jmp alltraps
80106ece:	e9 81 fa ff ff       	jmp    80106954 <alltraps>

80106ed3 <vector24>:
.globl vector24
vector24:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $24
80106ed5:	6a 18                	push   $0x18
  jmp alltraps
80106ed7:	e9 78 fa ff ff       	jmp    80106954 <alltraps>

80106edc <vector25>:
.globl vector25
vector25:
  pushl $0
80106edc:	6a 00                	push   $0x0
  pushl $25
80106ede:	6a 19                	push   $0x19
  jmp alltraps
80106ee0:	e9 6f fa ff ff       	jmp    80106954 <alltraps>

80106ee5 <vector26>:
.globl vector26
vector26:
  pushl $0
80106ee5:	6a 00                	push   $0x0
  pushl $26
80106ee7:	6a 1a                	push   $0x1a
  jmp alltraps
80106ee9:	e9 66 fa ff ff       	jmp    80106954 <alltraps>

80106eee <vector27>:
.globl vector27
vector27:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $27
80106ef0:	6a 1b                	push   $0x1b
  jmp alltraps
80106ef2:	e9 5d fa ff ff       	jmp    80106954 <alltraps>

80106ef7 <vector28>:
.globl vector28
vector28:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $28
80106ef9:	6a 1c                	push   $0x1c
  jmp alltraps
80106efb:	e9 54 fa ff ff       	jmp    80106954 <alltraps>

80106f00 <vector29>:
.globl vector29
vector29:
  pushl $0
80106f00:	6a 00                	push   $0x0
  pushl $29
80106f02:	6a 1d                	push   $0x1d
  jmp alltraps
80106f04:	e9 4b fa ff ff       	jmp    80106954 <alltraps>

80106f09 <vector30>:
.globl vector30
vector30:
  pushl $0
80106f09:	6a 00                	push   $0x0
  pushl $30
80106f0b:	6a 1e                	push   $0x1e
  jmp alltraps
80106f0d:	e9 42 fa ff ff       	jmp    80106954 <alltraps>

80106f12 <vector31>:
.globl vector31
vector31:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $31
80106f14:	6a 1f                	push   $0x1f
  jmp alltraps
80106f16:	e9 39 fa ff ff       	jmp    80106954 <alltraps>

80106f1b <vector32>:
.globl vector32
vector32:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $32
80106f1d:	6a 20                	push   $0x20
  jmp alltraps
80106f1f:	e9 30 fa ff ff       	jmp    80106954 <alltraps>

80106f24 <vector33>:
.globl vector33
vector33:
  pushl $0
80106f24:	6a 00                	push   $0x0
  pushl $33
80106f26:	6a 21                	push   $0x21
  jmp alltraps
80106f28:	e9 27 fa ff ff       	jmp    80106954 <alltraps>

80106f2d <vector34>:
.globl vector34
vector34:
  pushl $0
80106f2d:	6a 00                	push   $0x0
  pushl $34
80106f2f:	6a 22                	push   $0x22
  jmp alltraps
80106f31:	e9 1e fa ff ff       	jmp    80106954 <alltraps>

80106f36 <vector35>:
.globl vector35
vector35:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $35
80106f38:	6a 23                	push   $0x23
  jmp alltraps
80106f3a:	e9 15 fa ff ff       	jmp    80106954 <alltraps>

80106f3f <vector36>:
.globl vector36
vector36:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $36
80106f41:	6a 24                	push   $0x24
  jmp alltraps
80106f43:	e9 0c fa ff ff       	jmp    80106954 <alltraps>

80106f48 <vector37>:
.globl vector37
vector37:
  pushl $0
80106f48:	6a 00                	push   $0x0
  pushl $37
80106f4a:	6a 25                	push   $0x25
  jmp alltraps
80106f4c:	e9 03 fa ff ff       	jmp    80106954 <alltraps>

80106f51 <vector38>:
.globl vector38
vector38:
  pushl $0
80106f51:	6a 00                	push   $0x0
  pushl $38
80106f53:	6a 26                	push   $0x26
  jmp alltraps
80106f55:	e9 fa f9 ff ff       	jmp    80106954 <alltraps>

80106f5a <vector39>:
.globl vector39
vector39:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $39
80106f5c:	6a 27                	push   $0x27
  jmp alltraps
80106f5e:	e9 f1 f9 ff ff       	jmp    80106954 <alltraps>

80106f63 <vector40>:
.globl vector40
vector40:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $40
80106f65:	6a 28                	push   $0x28
  jmp alltraps
80106f67:	e9 e8 f9 ff ff       	jmp    80106954 <alltraps>

80106f6c <vector41>:
.globl vector41
vector41:
  pushl $0
80106f6c:	6a 00                	push   $0x0
  pushl $41
80106f6e:	6a 29                	push   $0x29
  jmp alltraps
80106f70:	e9 df f9 ff ff       	jmp    80106954 <alltraps>

80106f75 <vector42>:
.globl vector42
vector42:
  pushl $0
80106f75:	6a 00                	push   $0x0
  pushl $42
80106f77:	6a 2a                	push   $0x2a
  jmp alltraps
80106f79:	e9 d6 f9 ff ff       	jmp    80106954 <alltraps>

80106f7e <vector43>:
.globl vector43
vector43:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $43
80106f80:	6a 2b                	push   $0x2b
  jmp alltraps
80106f82:	e9 cd f9 ff ff       	jmp    80106954 <alltraps>

80106f87 <vector44>:
.globl vector44
vector44:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $44
80106f89:	6a 2c                	push   $0x2c
  jmp alltraps
80106f8b:	e9 c4 f9 ff ff       	jmp    80106954 <alltraps>

80106f90 <vector45>:
.globl vector45
vector45:
  pushl $0
80106f90:	6a 00                	push   $0x0
  pushl $45
80106f92:	6a 2d                	push   $0x2d
  jmp alltraps
80106f94:	e9 bb f9 ff ff       	jmp    80106954 <alltraps>

80106f99 <vector46>:
.globl vector46
vector46:
  pushl $0
80106f99:	6a 00                	push   $0x0
  pushl $46
80106f9b:	6a 2e                	push   $0x2e
  jmp alltraps
80106f9d:	e9 b2 f9 ff ff       	jmp    80106954 <alltraps>

80106fa2 <vector47>:
.globl vector47
vector47:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $47
80106fa4:	6a 2f                	push   $0x2f
  jmp alltraps
80106fa6:	e9 a9 f9 ff ff       	jmp    80106954 <alltraps>

80106fab <vector48>:
.globl vector48
vector48:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $48
80106fad:	6a 30                	push   $0x30
  jmp alltraps
80106faf:	e9 a0 f9 ff ff       	jmp    80106954 <alltraps>

80106fb4 <vector49>:
.globl vector49
vector49:
  pushl $0
80106fb4:	6a 00                	push   $0x0
  pushl $49
80106fb6:	6a 31                	push   $0x31
  jmp alltraps
80106fb8:	e9 97 f9 ff ff       	jmp    80106954 <alltraps>

80106fbd <vector50>:
.globl vector50
vector50:
  pushl $0
80106fbd:	6a 00                	push   $0x0
  pushl $50
80106fbf:	6a 32                	push   $0x32
  jmp alltraps
80106fc1:	e9 8e f9 ff ff       	jmp    80106954 <alltraps>

80106fc6 <vector51>:
.globl vector51
vector51:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $51
80106fc8:	6a 33                	push   $0x33
  jmp alltraps
80106fca:	e9 85 f9 ff ff       	jmp    80106954 <alltraps>

80106fcf <vector52>:
.globl vector52
vector52:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $52
80106fd1:	6a 34                	push   $0x34
  jmp alltraps
80106fd3:	e9 7c f9 ff ff       	jmp    80106954 <alltraps>

80106fd8 <vector53>:
.globl vector53
vector53:
  pushl $0
80106fd8:	6a 00                	push   $0x0
  pushl $53
80106fda:	6a 35                	push   $0x35
  jmp alltraps
80106fdc:	e9 73 f9 ff ff       	jmp    80106954 <alltraps>

80106fe1 <vector54>:
.globl vector54
vector54:
  pushl $0
80106fe1:	6a 00                	push   $0x0
  pushl $54
80106fe3:	6a 36                	push   $0x36
  jmp alltraps
80106fe5:	e9 6a f9 ff ff       	jmp    80106954 <alltraps>

80106fea <vector55>:
.globl vector55
vector55:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $55
80106fec:	6a 37                	push   $0x37
  jmp alltraps
80106fee:	e9 61 f9 ff ff       	jmp    80106954 <alltraps>

80106ff3 <vector56>:
.globl vector56
vector56:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $56
80106ff5:	6a 38                	push   $0x38
  jmp alltraps
80106ff7:	e9 58 f9 ff ff       	jmp    80106954 <alltraps>

80106ffc <vector57>:
.globl vector57
vector57:
  pushl $0
80106ffc:	6a 00                	push   $0x0
  pushl $57
80106ffe:	6a 39                	push   $0x39
  jmp alltraps
80107000:	e9 4f f9 ff ff       	jmp    80106954 <alltraps>

80107005 <vector58>:
.globl vector58
vector58:
  pushl $0
80107005:	6a 00                	push   $0x0
  pushl $58
80107007:	6a 3a                	push   $0x3a
  jmp alltraps
80107009:	e9 46 f9 ff ff       	jmp    80106954 <alltraps>

8010700e <vector59>:
.globl vector59
vector59:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $59
80107010:	6a 3b                	push   $0x3b
  jmp alltraps
80107012:	e9 3d f9 ff ff       	jmp    80106954 <alltraps>

80107017 <vector60>:
.globl vector60
vector60:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $60
80107019:	6a 3c                	push   $0x3c
  jmp alltraps
8010701b:	e9 34 f9 ff ff       	jmp    80106954 <alltraps>

80107020 <vector61>:
.globl vector61
vector61:
  pushl $0
80107020:	6a 00                	push   $0x0
  pushl $61
80107022:	6a 3d                	push   $0x3d
  jmp alltraps
80107024:	e9 2b f9 ff ff       	jmp    80106954 <alltraps>

80107029 <vector62>:
.globl vector62
vector62:
  pushl $0
80107029:	6a 00                	push   $0x0
  pushl $62
8010702b:	6a 3e                	push   $0x3e
  jmp alltraps
8010702d:	e9 22 f9 ff ff       	jmp    80106954 <alltraps>

80107032 <vector63>:
.globl vector63
vector63:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $63
80107034:	6a 3f                	push   $0x3f
  jmp alltraps
80107036:	e9 19 f9 ff ff       	jmp    80106954 <alltraps>

8010703b <vector64>:
.globl vector64
vector64:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $64
8010703d:	6a 40                	push   $0x40
  jmp alltraps
8010703f:	e9 10 f9 ff ff       	jmp    80106954 <alltraps>

80107044 <vector65>:
.globl vector65
vector65:
  pushl $0
80107044:	6a 00                	push   $0x0
  pushl $65
80107046:	6a 41                	push   $0x41
  jmp alltraps
80107048:	e9 07 f9 ff ff       	jmp    80106954 <alltraps>

8010704d <vector66>:
.globl vector66
vector66:
  pushl $0
8010704d:	6a 00                	push   $0x0
  pushl $66
8010704f:	6a 42                	push   $0x42
  jmp alltraps
80107051:	e9 fe f8 ff ff       	jmp    80106954 <alltraps>

80107056 <vector67>:
.globl vector67
vector67:
  pushl $0
80107056:	6a 00                	push   $0x0
  pushl $67
80107058:	6a 43                	push   $0x43
  jmp alltraps
8010705a:	e9 f5 f8 ff ff       	jmp    80106954 <alltraps>

8010705f <vector68>:
.globl vector68
vector68:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $68
80107061:	6a 44                	push   $0x44
  jmp alltraps
80107063:	e9 ec f8 ff ff       	jmp    80106954 <alltraps>

80107068 <vector69>:
.globl vector69
vector69:
  pushl $0
80107068:	6a 00                	push   $0x0
  pushl $69
8010706a:	6a 45                	push   $0x45
  jmp alltraps
8010706c:	e9 e3 f8 ff ff       	jmp    80106954 <alltraps>

80107071 <vector70>:
.globl vector70
vector70:
  pushl $0
80107071:	6a 00                	push   $0x0
  pushl $70
80107073:	6a 46                	push   $0x46
  jmp alltraps
80107075:	e9 da f8 ff ff       	jmp    80106954 <alltraps>

8010707a <vector71>:
.globl vector71
vector71:
  pushl $0
8010707a:	6a 00                	push   $0x0
  pushl $71
8010707c:	6a 47                	push   $0x47
  jmp alltraps
8010707e:	e9 d1 f8 ff ff       	jmp    80106954 <alltraps>

80107083 <vector72>:
.globl vector72
vector72:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $72
80107085:	6a 48                	push   $0x48
  jmp alltraps
80107087:	e9 c8 f8 ff ff       	jmp    80106954 <alltraps>

8010708c <vector73>:
.globl vector73
vector73:
  pushl $0
8010708c:	6a 00                	push   $0x0
  pushl $73
8010708e:	6a 49                	push   $0x49
  jmp alltraps
80107090:	e9 bf f8 ff ff       	jmp    80106954 <alltraps>

80107095 <vector74>:
.globl vector74
vector74:
  pushl $0
80107095:	6a 00                	push   $0x0
  pushl $74
80107097:	6a 4a                	push   $0x4a
  jmp alltraps
80107099:	e9 b6 f8 ff ff       	jmp    80106954 <alltraps>

8010709e <vector75>:
.globl vector75
vector75:
  pushl $0
8010709e:	6a 00                	push   $0x0
  pushl $75
801070a0:	6a 4b                	push   $0x4b
  jmp alltraps
801070a2:	e9 ad f8 ff ff       	jmp    80106954 <alltraps>

801070a7 <vector76>:
.globl vector76
vector76:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $76
801070a9:	6a 4c                	push   $0x4c
  jmp alltraps
801070ab:	e9 a4 f8 ff ff       	jmp    80106954 <alltraps>

801070b0 <vector77>:
.globl vector77
vector77:
  pushl $0
801070b0:	6a 00                	push   $0x0
  pushl $77
801070b2:	6a 4d                	push   $0x4d
  jmp alltraps
801070b4:	e9 9b f8 ff ff       	jmp    80106954 <alltraps>

801070b9 <vector78>:
.globl vector78
vector78:
  pushl $0
801070b9:	6a 00                	push   $0x0
  pushl $78
801070bb:	6a 4e                	push   $0x4e
  jmp alltraps
801070bd:	e9 92 f8 ff ff       	jmp    80106954 <alltraps>

801070c2 <vector79>:
.globl vector79
vector79:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $79
801070c4:	6a 4f                	push   $0x4f
  jmp alltraps
801070c6:	e9 89 f8 ff ff       	jmp    80106954 <alltraps>

801070cb <vector80>:
.globl vector80
vector80:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $80
801070cd:	6a 50                	push   $0x50
  jmp alltraps
801070cf:	e9 80 f8 ff ff       	jmp    80106954 <alltraps>

801070d4 <vector81>:
.globl vector81
vector81:
  pushl $0
801070d4:	6a 00                	push   $0x0
  pushl $81
801070d6:	6a 51                	push   $0x51
  jmp alltraps
801070d8:	e9 77 f8 ff ff       	jmp    80106954 <alltraps>

801070dd <vector82>:
.globl vector82
vector82:
  pushl $0
801070dd:	6a 00                	push   $0x0
  pushl $82
801070df:	6a 52                	push   $0x52
  jmp alltraps
801070e1:	e9 6e f8 ff ff       	jmp    80106954 <alltraps>

801070e6 <vector83>:
.globl vector83
vector83:
  pushl $0
801070e6:	6a 00                	push   $0x0
  pushl $83
801070e8:	6a 53                	push   $0x53
  jmp alltraps
801070ea:	e9 65 f8 ff ff       	jmp    80106954 <alltraps>

801070ef <vector84>:
.globl vector84
vector84:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $84
801070f1:	6a 54                	push   $0x54
  jmp alltraps
801070f3:	e9 5c f8 ff ff       	jmp    80106954 <alltraps>

801070f8 <vector85>:
.globl vector85
vector85:
  pushl $0
801070f8:	6a 00                	push   $0x0
  pushl $85
801070fa:	6a 55                	push   $0x55
  jmp alltraps
801070fc:	e9 53 f8 ff ff       	jmp    80106954 <alltraps>

80107101 <vector86>:
.globl vector86
vector86:
  pushl $0
80107101:	6a 00                	push   $0x0
  pushl $86
80107103:	6a 56                	push   $0x56
  jmp alltraps
80107105:	e9 4a f8 ff ff       	jmp    80106954 <alltraps>

8010710a <vector87>:
.globl vector87
vector87:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $87
8010710c:	6a 57                	push   $0x57
  jmp alltraps
8010710e:	e9 41 f8 ff ff       	jmp    80106954 <alltraps>

80107113 <vector88>:
.globl vector88
vector88:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $88
80107115:	6a 58                	push   $0x58
  jmp alltraps
80107117:	e9 38 f8 ff ff       	jmp    80106954 <alltraps>

8010711c <vector89>:
.globl vector89
vector89:
  pushl $0
8010711c:	6a 00                	push   $0x0
  pushl $89
8010711e:	6a 59                	push   $0x59
  jmp alltraps
80107120:	e9 2f f8 ff ff       	jmp    80106954 <alltraps>

80107125 <vector90>:
.globl vector90
vector90:
  pushl $0
80107125:	6a 00                	push   $0x0
  pushl $90
80107127:	6a 5a                	push   $0x5a
  jmp alltraps
80107129:	e9 26 f8 ff ff       	jmp    80106954 <alltraps>

8010712e <vector91>:
.globl vector91
vector91:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $91
80107130:	6a 5b                	push   $0x5b
  jmp alltraps
80107132:	e9 1d f8 ff ff       	jmp    80106954 <alltraps>

80107137 <vector92>:
.globl vector92
vector92:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $92
80107139:	6a 5c                	push   $0x5c
  jmp alltraps
8010713b:	e9 14 f8 ff ff       	jmp    80106954 <alltraps>

80107140 <vector93>:
.globl vector93
vector93:
  pushl $0
80107140:	6a 00                	push   $0x0
  pushl $93
80107142:	6a 5d                	push   $0x5d
  jmp alltraps
80107144:	e9 0b f8 ff ff       	jmp    80106954 <alltraps>

80107149 <vector94>:
.globl vector94
vector94:
  pushl $0
80107149:	6a 00                	push   $0x0
  pushl $94
8010714b:	6a 5e                	push   $0x5e
  jmp alltraps
8010714d:	e9 02 f8 ff ff       	jmp    80106954 <alltraps>

80107152 <vector95>:
.globl vector95
vector95:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $95
80107154:	6a 5f                	push   $0x5f
  jmp alltraps
80107156:	e9 f9 f7 ff ff       	jmp    80106954 <alltraps>

8010715b <vector96>:
.globl vector96
vector96:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $96
8010715d:	6a 60                	push   $0x60
  jmp alltraps
8010715f:	e9 f0 f7 ff ff       	jmp    80106954 <alltraps>

80107164 <vector97>:
.globl vector97
vector97:
  pushl $0
80107164:	6a 00                	push   $0x0
  pushl $97
80107166:	6a 61                	push   $0x61
  jmp alltraps
80107168:	e9 e7 f7 ff ff       	jmp    80106954 <alltraps>

8010716d <vector98>:
.globl vector98
vector98:
  pushl $0
8010716d:	6a 00                	push   $0x0
  pushl $98
8010716f:	6a 62                	push   $0x62
  jmp alltraps
80107171:	e9 de f7 ff ff       	jmp    80106954 <alltraps>

80107176 <vector99>:
.globl vector99
vector99:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $99
80107178:	6a 63                	push   $0x63
  jmp alltraps
8010717a:	e9 d5 f7 ff ff       	jmp    80106954 <alltraps>

8010717f <vector100>:
.globl vector100
vector100:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $100
80107181:	6a 64                	push   $0x64
  jmp alltraps
80107183:	e9 cc f7 ff ff       	jmp    80106954 <alltraps>

80107188 <vector101>:
.globl vector101
vector101:
  pushl $0
80107188:	6a 00                	push   $0x0
  pushl $101
8010718a:	6a 65                	push   $0x65
  jmp alltraps
8010718c:	e9 c3 f7 ff ff       	jmp    80106954 <alltraps>

80107191 <vector102>:
.globl vector102
vector102:
  pushl $0
80107191:	6a 00                	push   $0x0
  pushl $102
80107193:	6a 66                	push   $0x66
  jmp alltraps
80107195:	e9 ba f7 ff ff       	jmp    80106954 <alltraps>

8010719a <vector103>:
.globl vector103
vector103:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $103
8010719c:	6a 67                	push   $0x67
  jmp alltraps
8010719e:	e9 b1 f7 ff ff       	jmp    80106954 <alltraps>

801071a3 <vector104>:
.globl vector104
vector104:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $104
801071a5:	6a 68                	push   $0x68
  jmp alltraps
801071a7:	e9 a8 f7 ff ff       	jmp    80106954 <alltraps>

801071ac <vector105>:
.globl vector105
vector105:
  pushl $0
801071ac:	6a 00                	push   $0x0
  pushl $105
801071ae:	6a 69                	push   $0x69
  jmp alltraps
801071b0:	e9 9f f7 ff ff       	jmp    80106954 <alltraps>

801071b5 <vector106>:
.globl vector106
vector106:
  pushl $0
801071b5:	6a 00                	push   $0x0
  pushl $106
801071b7:	6a 6a                	push   $0x6a
  jmp alltraps
801071b9:	e9 96 f7 ff ff       	jmp    80106954 <alltraps>

801071be <vector107>:
.globl vector107
vector107:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $107
801071c0:	6a 6b                	push   $0x6b
  jmp alltraps
801071c2:	e9 8d f7 ff ff       	jmp    80106954 <alltraps>

801071c7 <vector108>:
.globl vector108
vector108:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $108
801071c9:	6a 6c                	push   $0x6c
  jmp alltraps
801071cb:	e9 84 f7 ff ff       	jmp    80106954 <alltraps>

801071d0 <vector109>:
.globl vector109
vector109:
  pushl $0
801071d0:	6a 00                	push   $0x0
  pushl $109
801071d2:	6a 6d                	push   $0x6d
  jmp alltraps
801071d4:	e9 7b f7 ff ff       	jmp    80106954 <alltraps>

801071d9 <vector110>:
.globl vector110
vector110:
  pushl $0
801071d9:	6a 00                	push   $0x0
  pushl $110
801071db:	6a 6e                	push   $0x6e
  jmp alltraps
801071dd:	e9 72 f7 ff ff       	jmp    80106954 <alltraps>

801071e2 <vector111>:
.globl vector111
vector111:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $111
801071e4:	6a 6f                	push   $0x6f
  jmp alltraps
801071e6:	e9 69 f7 ff ff       	jmp    80106954 <alltraps>

801071eb <vector112>:
.globl vector112
vector112:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $112
801071ed:	6a 70                	push   $0x70
  jmp alltraps
801071ef:	e9 60 f7 ff ff       	jmp    80106954 <alltraps>

801071f4 <vector113>:
.globl vector113
vector113:
  pushl $0
801071f4:	6a 00                	push   $0x0
  pushl $113
801071f6:	6a 71                	push   $0x71
  jmp alltraps
801071f8:	e9 57 f7 ff ff       	jmp    80106954 <alltraps>

801071fd <vector114>:
.globl vector114
vector114:
  pushl $0
801071fd:	6a 00                	push   $0x0
  pushl $114
801071ff:	6a 72                	push   $0x72
  jmp alltraps
80107201:	e9 4e f7 ff ff       	jmp    80106954 <alltraps>

80107206 <vector115>:
.globl vector115
vector115:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $115
80107208:	6a 73                	push   $0x73
  jmp alltraps
8010720a:	e9 45 f7 ff ff       	jmp    80106954 <alltraps>

8010720f <vector116>:
.globl vector116
vector116:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $116
80107211:	6a 74                	push   $0x74
  jmp alltraps
80107213:	e9 3c f7 ff ff       	jmp    80106954 <alltraps>

80107218 <vector117>:
.globl vector117
vector117:
  pushl $0
80107218:	6a 00                	push   $0x0
  pushl $117
8010721a:	6a 75                	push   $0x75
  jmp alltraps
8010721c:	e9 33 f7 ff ff       	jmp    80106954 <alltraps>

80107221 <vector118>:
.globl vector118
vector118:
  pushl $0
80107221:	6a 00                	push   $0x0
  pushl $118
80107223:	6a 76                	push   $0x76
  jmp alltraps
80107225:	e9 2a f7 ff ff       	jmp    80106954 <alltraps>

8010722a <vector119>:
.globl vector119
vector119:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $119
8010722c:	6a 77                	push   $0x77
  jmp alltraps
8010722e:	e9 21 f7 ff ff       	jmp    80106954 <alltraps>

80107233 <vector120>:
.globl vector120
vector120:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $120
80107235:	6a 78                	push   $0x78
  jmp alltraps
80107237:	e9 18 f7 ff ff       	jmp    80106954 <alltraps>

8010723c <vector121>:
.globl vector121
vector121:
  pushl $0
8010723c:	6a 00                	push   $0x0
  pushl $121
8010723e:	6a 79                	push   $0x79
  jmp alltraps
80107240:	e9 0f f7 ff ff       	jmp    80106954 <alltraps>

80107245 <vector122>:
.globl vector122
vector122:
  pushl $0
80107245:	6a 00                	push   $0x0
  pushl $122
80107247:	6a 7a                	push   $0x7a
  jmp alltraps
80107249:	e9 06 f7 ff ff       	jmp    80106954 <alltraps>

8010724e <vector123>:
.globl vector123
vector123:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $123
80107250:	6a 7b                	push   $0x7b
  jmp alltraps
80107252:	e9 fd f6 ff ff       	jmp    80106954 <alltraps>

80107257 <vector124>:
.globl vector124
vector124:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $124
80107259:	6a 7c                	push   $0x7c
  jmp alltraps
8010725b:	e9 f4 f6 ff ff       	jmp    80106954 <alltraps>

80107260 <vector125>:
.globl vector125
vector125:
  pushl $0
80107260:	6a 00                	push   $0x0
  pushl $125
80107262:	6a 7d                	push   $0x7d
  jmp alltraps
80107264:	e9 eb f6 ff ff       	jmp    80106954 <alltraps>

80107269 <vector126>:
.globl vector126
vector126:
  pushl $0
80107269:	6a 00                	push   $0x0
  pushl $126
8010726b:	6a 7e                	push   $0x7e
  jmp alltraps
8010726d:	e9 e2 f6 ff ff       	jmp    80106954 <alltraps>

80107272 <vector127>:
.globl vector127
vector127:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $127
80107274:	6a 7f                	push   $0x7f
  jmp alltraps
80107276:	e9 d9 f6 ff ff       	jmp    80106954 <alltraps>

8010727b <vector128>:
.globl vector128
vector128:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $128
8010727d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107282:	e9 cd f6 ff ff       	jmp    80106954 <alltraps>

80107287 <vector129>:
.globl vector129
vector129:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $129
80107289:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010728e:	e9 c1 f6 ff ff       	jmp    80106954 <alltraps>

80107293 <vector130>:
.globl vector130
vector130:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $130
80107295:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010729a:	e9 b5 f6 ff ff       	jmp    80106954 <alltraps>

8010729f <vector131>:
.globl vector131
vector131:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $131
801072a1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801072a6:	e9 a9 f6 ff ff       	jmp    80106954 <alltraps>

801072ab <vector132>:
.globl vector132
vector132:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $132
801072ad:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801072b2:	e9 9d f6 ff ff       	jmp    80106954 <alltraps>

801072b7 <vector133>:
.globl vector133
vector133:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $133
801072b9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801072be:	e9 91 f6 ff ff       	jmp    80106954 <alltraps>

801072c3 <vector134>:
.globl vector134
vector134:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $134
801072c5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801072ca:	e9 85 f6 ff ff       	jmp    80106954 <alltraps>

801072cf <vector135>:
.globl vector135
vector135:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $135
801072d1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801072d6:	e9 79 f6 ff ff       	jmp    80106954 <alltraps>

801072db <vector136>:
.globl vector136
vector136:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $136
801072dd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801072e2:	e9 6d f6 ff ff       	jmp    80106954 <alltraps>

801072e7 <vector137>:
.globl vector137
vector137:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $137
801072e9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801072ee:	e9 61 f6 ff ff       	jmp    80106954 <alltraps>

801072f3 <vector138>:
.globl vector138
vector138:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $138
801072f5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801072fa:	e9 55 f6 ff ff       	jmp    80106954 <alltraps>

801072ff <vector139>:
.globl vector139
vector139:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $139
80107301:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107306:	e9 49 f6 ff ff       	jmp    80106954 <alltraps>

8010730b <vector140>:
.globl vector140
vector140:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $140
8010730d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107312:	e9 3d f6 ff ff       	jmp    80106954 <alltraps>

80107317 <vector141>:
.globl vector141
vector141:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $141
80107319:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010731e:	e9 31 f6 ff ff       	jmp    80106954 <alltraps>

80107323 <vector142>:
.globl vector142
vector142:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $142
80107325:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010732a:	e9 25 f6 ff ff       	jmp    80106954 <alltraps>

8010732f <vector143>:
.globl vector143
vector143:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $143
80107331:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107336:	e9 19 f6 ff ff       	jmp    80106954 <alltraps>

8010733b <vector144>:
.globl vector144
vector144:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $144
8010733d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107342:	e9 0d f6 ff ff       	jmp    80106954 <alltraps>

80107347 <vector145>:
.globl vector145
vector145:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $145
80107349:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010734e:	e9 01 f6 ff ff       	jmp    80106954 <alltraps>

80107353 <vector146>:
.globl vector146
vector146:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $146
80107355:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010735a:	e9 f5 f5 ff ff       	jmp    80106954 <alltraps>

8010735f <vector147>:
.globl vector147
vector147:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $147
80107361:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107366:	e9 e9 f5 ff ff       	jmp    80106954 <alltraps>

8010736b <vector148>:
.globl vector148
vector148:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $148
8010736d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107372:	e9 dd f5 ff ff       	jmp    80106954 <alltraps>

80107377 <vector149>:
.globl vector149
vector149:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $149
80107379:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010737e:	e9 d1 f5 ff ff       	jmp    80106954 <alltraps>

80107383 <vector150>:
.globl vector150
vector150:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $150
80107385:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010738a:	e9 c5 f5 ff ff       	jmp    80106954 <alltraps>

8010738f <vector151>:
.globl vector151
vector151:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $151
80107391:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107396:	e9 b9 f5 ff ff       	jmp    80106954 <alltraps>

8010739b <vector152>:
.globl vector152
vector152:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $152
8010739d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801073a2:	e9 ad f5 ff ff       	jmp    80106954 <alltraps>

801073a7 <vector153>:
.globl vector153
vector153:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $153
801073a9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801073ae:	e9 a1 f5 ff ff       	jmp    80106954 <alltraps>

801073b3 <vector154>:
.globl vector154
vector154:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $154
801073b5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801073ba:	e9 95 f5 ff ff       	jmp    80106954 <alltraps>

801073bf <vector155>:
.globl vector155
vector155:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $155
801073c1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801073c6:	e9 89 f5 ff ff       	jmp    80106954 <alltraps>

801073cb <vector156>:
.globl vector156
vector156:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $156
801073cd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801073d2:	e9 7d f5 ff ff       	jmp    80106954 <alltraps>

801073d7 <vector157>:
.globl vector157
vector157:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $157
801073d9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801073de:	e9 71 f5 ff ff       	jmp    80106954 <alltraps>

801073e3 <vector158>:
.globl vector158
vector158:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $158
801073e5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801073ea:	e9 65 f5 ff ff       	jmp    80106954 <alltraps>

801073ef <vector159>:
.globl vector159
vector159:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $159
801073f1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801073f6:	e9 59 f5 ff ff       	jmp    80106954 <alltraps>

801073fb <vector160>:
.globl vector160
vector160:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $160
801073fd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107402:	e9 4d f5 ff ff       	jmp    80106954 <alltraps>

80107407 <vector161>:
.globl vector161
vector161:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $161
80107409:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010740e:	e9 41 f5 ff ff       	jmp    80106954 <alltraps>

80107413 <vector162>:
.globl vector162
vector162:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $162
80107415:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010741a:	e9 35 f5 ff ff       	jmp    80106954 <alltraps>

8010741f <vector163>:
.globl vector163
vector163:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $163
80107421:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107426:	e9 29 f5 ff ff       	jmp    80106954 <alltraps>

8010742b <vector164>:
.globl vector164
vector164:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $164
8010742d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107432:	e9 1d f5 ff ff       	jmp    80106954 <alltraps>

80107437 <vector165>:
.globl vector165
vector165:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $165
80107439:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010743e:	e9 11 f5 ff ff       	jmp    80106954 <alltraps>

80107443 <vector166>:
.globl vector166
vector166:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $166
80107445:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010744a:	e9 05 f5 ff ff       	jmp    80106954 <alltraps>

8010744f <vector167>:
.globl vector167
vector167:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $167
80107451:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107456:	e9 f9 f4 ff ff       	jmp    80106954 <alltraps>

8010745b <vector168>:
.globl vector168
vector168:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $168
8010745d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107462:	e9 ed f4 ff ff       	jmp    80106954 <alltraps>

80107467 <vector169>:
.globl vector169
vector169:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $169
80107469:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010746e:	e9 e1 f4 ff ff       	jmp    80106954 <alltraps>

80107473 <vector170>:
.globl vector170
vector170:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $170
80107475:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010747a:	e9 d5 f4 ff ff       	jmp    80106954 <alltraps>

8010747f <vector171>:
.globl vector171
vector171:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $171
80107481:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107486:	e9 c9 f4 ff ff       	jmp    80106954 <alltraps>

8010748b <vector172>:
.globl vector172
vector172:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $172
8010748d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107492:	e9 bd f4 ff ff       	jmp    80106954 <alltraps>

80107497 <vector173>:
.globl vector173
vector173:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $173
80107499:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010749e:	e9 b1 f4 ff ff       	jmp    80106954 <alltraps>

801074a3 <vector174>:
.globl vector174
vector174:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $174
801074a5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801074aa:	e9 a5 f4 ff ff       	jmp    80106954 <alltraps>

801074af <vector175>:
.globl vector175
vector175:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $175
801074b1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801074b6:	e9 99 f4 ff ff       	jmp    80106954 <alltraps>

801074bb <vector176>:
.globl vector176
vector176:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $176
801074bd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801074c2:	e9 8d f4 ff ff       	jmp    80106954 <alltraps>

801074c7 <vector177>:
.globl vector177
vector177:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $177
801074c9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801074ce:	e9 81 f4 ff ff       	jmp    80106954 <alltraps>

801074d3 <vector178>:
.globl vector178
vector178:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $178
801074d5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801074da:	e9 75 f4 ff ff       	jmp    80106954 <alltraps>

801074df <vector179>:
.globl vector179
vector179:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $179
801074e1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801074e6:	e9 69 f4 ff ff       	jmp    80106954 <alltraps>

801074eb <vector180>:
.globl vector180
vector180:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $180
801074ed:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801074f2:	e9 5d f4 ff ff       	jmp    80106954 <alltraps>

801074f7 <vector181>:
.globl vector181
vector181:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $181
801074f9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801074fe:	e9 51 f4 ff ff       	jmp    80106954 <alltraps>

80107503 <vector182>:
.globl vector182
vector182:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $182
80107505:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010750a:	e9 45 f4 ff ff       	jmp    80106954 <alltraps>

8010750f <vector183>:
.globl vector183
vector183:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $183
80107511:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107516:	e9 39 f4 ff ff       	jmp    80106954 <alltraps>

8010751b <vector184>:
.globl vector184
vector184:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $184
8010751d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107522:	e9 2d f4 ff ff       	jmp    80106954 <alltraps>

80107527 <vector185>:
.globl vector185
vector185:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $185
80107529:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010752e:	e9 21 f4 ff ff       	jmp    80106954 <alltraps>

80107533 <vector186>:
.globl vector186
vector186:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $186
80107535:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010753a:	e9 15 f4 ff ff       	jmp    80106954 <alltraps>

8010753f <vector187>:
.globl vector187
vector187:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $187
80107541:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107546:	e9 09 f4 ff ff       	jmp    80106954 <alltraps>

8010754b <vector188>:
.globl vector188
vector188:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $188
8010754d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107552:	e9 fd f3 ff ff       	jmp    80106954 <alltraps>

80107557 <vector189>:
.globl vector189
vector189:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $189
80107559:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010755e:	e9 f1 f3 ff ff       	jmp    80106954 <alltraps>

80107563 <vector190>:
.globl vector190
vector190:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $190
80107565:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010756a:	e9 e5 f3 ff ff       	jmp    80106954 <alltraps>

8010756f <vector191>:
.globl vector191
vector191:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $191
80107571:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107576:	e9 d9 f3 ff ff       	jmp    80106954 <alltraps>

8010757b <vector192>:
.globl vector192
vector192:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $192
8010757d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107582:	e9 cd f3 ff ff       	jmp    80106954 <alltraps>

80107587 <vector193>:
.globl vector193
vector193:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $193
80107589:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010758e:	e9 c1 f3 ff ff       	jmp    80106954 <alltraps>

80107593 <vector194>:
.globl vector194
vector194:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $194
80107595:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010759a:	e9 b5 f3 ff ff       	jmp    80106954 <alltraps>

8010759f <vector195>:
.globl vector195
vector195:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $195
801075a1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801075a6:	e9 a9 f3 ff ff       	jmp    80106954 <alltraps>

801075ab <vector196>:
.globl vector196
vector196:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $196
801075ad:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801075b2:	e9 9d f3 ff ff       	jmp    80106954 <alltraps>

801075b7 <vector197>:
.globl vector197
vector197:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $197
801075b9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801075be:	e9 91 f3 ff ff       	jmp    80106954 <alltraps>

801075c3 <vector198>:
.globl vector198
vector198:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $198
801075c5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801075ca:	e9 85 f3 ff ff       	jmp    80106954 <alltraps>

801075cf <vector199>:
.globl vector199
vector199:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $199
801075d1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801075d6:	e9 79 f3 ff ff       	jmp    80106954 <alltraps>

801075db <vector200>:
.globl vector200
vector200:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $200
801075dd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801075e2:	e9 6d f3 ff ff       	jmp    80106954 <alltraps>

801075e7 <vector201>:
.globl vector201
vector201:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $201
801075e9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801075ee:	e9 61 f3 ff ff       	jmp    80106954 <alltraps>

801075f3 <vector202>:
.globl vector202
vector202:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $202
801075f5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801075fa:	e9 55 f3 ff ff       	jmp    80106954 <alltraps>

801075ff <vector203>:
.globl vector203
vector203:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $203
80107601:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107606:	e9 49 f3 ff ff       	jmp    80106954 <alltraps>

8010760b <vector204>:
.globl vector204
vector204:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $204
8010760d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107612:	e9 3d f3 ff ff       	jmp    80106954 <alltraps>

80107617 <vector205>:
.globl vector205
vector205:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $205
80107619:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010761e:	e9 31 f3 ff ff       	jmp    80106954 <alltraps>

80107623 <vector206>:
.globl vector206
vector206:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $206
80107625:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010762a:	e9 25 f3 ff ff       	jmp    80106954 <alltraps>

8010762f <vector207>:
.globl vector207
vector207:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $207
80107631:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107636:	e9 19 f3 ff ff       	jmp    80106954 <alltraps>

8010763b <vector208>:
.globl vector208
vector208:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $208
8010763d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107642:	e9 0d f3 ff ff       	jmp    80106954 <alltraps>

80107647 <vector209>:
.globl vector209
vector209:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $209
80107649:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010764e:	e9 01 f3 ff ff       	jmp    80106954 <alltraps>

80107653 <vector210>:
.globl vector210
vector210:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $210
80107655:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010765a:	e9 f5 f2 ff ff       	jmp    80106954 <alltraps>

8010765f <vector211>:
.globl vector211
vector211:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $211
80107661:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107666:	e9 e9 f2 ff ff       	jmp    80106954 <alltraps>

8010766b <vector212>:
.globl vector212
vector212:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $212
8010766d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107672:	e9 dd f2 ff ff       	jmp    80106954 <alltraps>

80107677 <vector213>:
.globl vector213
vector213:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $213
80107679:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010767e:	e9 d1 f2 ff ff       	jmp    80106954 <alltraps>

80107683 <vector214>:
.globl vector214
vector214:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $214
80107685:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010768a:	e9 c5 f2 ff ff       	jmp    80106954 <alltraps>

8010768f <vector215>:
.globl vector215
vector215:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $215
80107691:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107696:	e9 b9 f2 ff ff       	jmp    80106954 <alltraps>

8010769b <vector216>:
.globl vector216
vector216:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $216
8010769d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801076a2:	e9 ad f2 ff ff       	jmp    80106954 <alltraps>

801076a7 <vector217>:
.globl vector217
vector217:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $217
801076a9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801076ae:	e9 a1 f2 ff ff       	jmp    80106954 <alltraps>

801076b3 <vector218>:
.globl vector218
vector218:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $218
801076b5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801076ba:	e9 95 f2 ff ff       	jmp    80106954 <alltraps>

801076bf <vector219>:
.globl vector219
vector219:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $219
801076c1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801076c6:	e9 89 f2 ff ff       	jmp    80106954 <alltraps>

801076cb <vector220>:
.globl vector220
vector220:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $220
801076cd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801076d2:	e9 7d f2 ff ff       	jmp    80106954 <alltraps>

801076d7 <vector221>:
.globl vector221
vector221:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $221
801076d9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801076de:	e9 71 f2 ff ff       	jmp    80106954 <alltraps>

801076e3 <vector222>:
.globl vector222
vector222:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $222
801076e5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801076ea:	e9 65 f2 ff ff       	jmp    80106954 <alltraps>

801076ef <vector223>:
.globl vector223
vector223:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $223
801076f1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801076f6:	e9 59 f2 ff ff       	jmp    80106954 <alltraps>

801076fb <vector224>:
.globl vector224
vector224:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $224
801076fd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107702:	e9 4d f2 ff ff       	jmp    80106954 <alltraps>

80107707 <vector225>:
.globl vector225
vector225:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $225
80107709:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010770e:	e9 41 f2 ff ff       	jmp    80106954 <alltraps>

80107713 <vector226>:
.globl vector226
vector226:
  pushl $0
80107713:	6a 00                	push   $0x0
  pushl $226
80107715:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010771a:	e9 35 f2 ff ff       	jmp    80106954 <alltraps>

8010771f <vector227>:
.globl vector227
vector227:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $227
80107721:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107726:	e9 29 f2 ff ff       	jmp    80106954 <alltraps>

8010772b <vector228>:
.globl vector228
vector228:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $228
8010772d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107732:	e9 1d f2 ff ff       	jmp    80106954 <alltraps>

80107737 <vector229>:
.globl vector229
vector229:
  pushl $0
80107737:	6a 00                	push   $0x0
  pushl $229
80107739:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010773e:	e9 11 f2 ff ff       	jmp    80106954 <alltraps>

80107743 <vector230>:
.globl vector230
vector230:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $230
80107745:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010774a:	e9 05 f2 ff ff       	jmp    80106954 <alltraps>

8010774f <vector231>:
.globl vector231
vector231:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $231
80107751:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107756:	e9 f9 f1 ff ff       	jmp    80106954 <alltraps>

8010775b <vector232>:
.globl vector232
vector232:
  pushl $0
8010775b:	6a 00                	push   $0x0
  pushl $232
8010775d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107762:	e9 ed f1 ff ff       	jmp    80106954 <alltraps>

80107767 <vector233>:
.globl vector233
vector233:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $233
80107769:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010776e:	e9 e1 f1 ff ff       	jmp    80106954 <alltraps>

80107773 <vector234>:
.globl vector234
vector234:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $234
80107775:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010777a:	e9 d5 f1 ff ff       	jmp    80106954 <alltraps>

8010777f <vector235>:
.globl vector235
vector235:
  pushl $0
8010777f:	6a 00                	push   $0x0
  pushl $235
80107781:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107786:	e9 c9 f1 ff ff       	jmp    80106954 <alltraps>

8010778b <vector236>:
.globl vector236
vector236:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $236
8010778d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107792:	e9 bd f1 ff ff       	jmp    80106954 <alltraps>

80107797 <vector237>:
.globl vector237
vector237:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $237
80107799:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010779e:	e9 b1 f1 ff ff       	jmp    80106954 <alltraps>

801077a3 <vector238>:
.globl vector238
vector238:
  pushl $0
801077a3:	6a 00                	push   $0x0
  pushl $238
801077a5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801077aa:	e9 a5 f1 ff ff       	jmp    80106954 <alltraps>

801077af <vector239>:
.globl vector239
vector239:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $239
801077b1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801077b6:	e9 99 f1 ff ff       	jmp    80106954 <alltraps>

801077bb <vector240>:
.globl vector240
vector240:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $240
801077bd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801077c2:	e9 8d f1 ff ff       	jmp    80106954 <alltraps>

801077c7 <vector241>:
.globl vector241
vector241:
  pushl $0
801077c7:	6a 00                	push   $0x0
  pushl $241
801077c9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801077ce:	e9 81 f1 ff ff       	jmp    80106954 <alltraps>

801077d3 <vector242>:
.globl vector242
vector242:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $242
801077d5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801077da:	e9 75 f1 ff ff       	jmp    80106954 <alltraps>

801077df <vector243>:
.globl vector243
vector243:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $243
801077e1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801077e6:	e9 69 f1 ff ff       	jmp    80106954 <alltraps>

801077eb <vector244>:
.globl vector244
vector244:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $244
801077ed:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801077f2:	e9 5d f1 ff ff       	jmp    80106954 <alltraps>

801077f7 <vector245>:
.globl vector245
vector245:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $245
801077f9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801077fe:	e9 51 f1 ff ff       	jmp    80106954 <alltraps>

80107803 <vector246>:
.globl vector246
vector246:
  pushl $0
80107803:	6a 00                	push   $0x0
  pushl $246
80107805:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010780a:	e9 45 f1 ff ff       	jmp    80106954 <alltraps>

8010780f <vector247>:
.globl vector247
vector247:
  pushl $0
8010780f:	6a 00                	push   $0x0
  pushl $247
80107811:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107816:	e9 39 f1 ff ff       	jmp    80106954 <alltraps>

8010781b <vector248>:
.globl vector248
vector248:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $248
8010781d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107822:	e9 2d f1 ff ff       	jmp    80106954 <alltraps>

80107827 <vector249>:
.globl vector249
vector249:
  pushl $0
80107827:	6a 00                	push   $0x0
  pushl $249
80107829:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010782e:	e9 21 f1 ff ff       	jmp    80106954 <alltraps>

80107833 <vector250>:
.globl vector250
vector250:
  pushl $0
80107833:	6a 00                	push   $0x0
  pushl $250
80107835:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010783a:	e9 15 f1 ff ff       	jmp    80106954 <alltraps>

8010783f <vector251>:
.globl vector251
vector251:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $251
80107841:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107846:	e9 09 f1 ff ff       	jmp    80106954 <alltraps>

8010784b <vector252>:
.globl vector252
vector252:
  pushl $0
8010784b:	6a 00                	push   $0x0
  pushl $252
8010784d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107852:	e9 fd f0 ff ff       	jmp    80106954 <alltraps>

80107857 <vector253>:
.globl vector253
vector253:
  pushl $0
80107857:	6a 00                	push   $0x0
  pushl $253
80107859:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010785e:	e9 f1 f0 ff ff       	jmp    80106954 <alltraps>

80107863 <vector254>:
.globl vector254
vector254:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $254
80107865:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010786a:	e9 e5 f0 ff ff       	jmp    80106954 <alltraps>

8010786f <vector255>:
.globl vector255
vector255:
  pushl $0
8010786f:	6a 00                	push   $0x0
  pushl $255
80107871:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107876:	e9 d9 f0 ff ff       	jmp    80106954 <alltraps>
8010787b:	66 90                	xchg   %ax,%ax
8010787d:	66 90                	xchg   %ax,%ax
8010787f:	90                   	nop

80107880 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107887:	c1 ea 16             	shr    $0x16,%edx
{
8010788a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010788b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010788e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107891:	8b 1f                	mov    (%edi),%ebx
80107893:	f6 c3 01             	test   $0x1,%bl
80107896:	74 28                	je     801078c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107898:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010789e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801078a4:	89 f0                	mov    %esi,%eax
}
801078a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801078a9:	c1 e8 0a             	shr    $0xa,%eax
801078ac:	25 fc 0f 00 00       	and    $0xffc,%eax
801078b1:	01 d8                	add    %ebx,%eax
}
801078b3:	5b                   	pop    %ebx
801078b4:	5e                   	pop    %esi
801078b5:	5f                   	pop    %edi
801078b6:	5d                   	pop    %ebp
801078b7:	c3                   	ret    
801078b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078bf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801078c0:	85 c9                	test   %ecx,%ecx
801078c2:	74 2c                	je     801078f0 <walkpgdir+0x70>
801078c4:	e8 d7 b0 ff ff       	call   801029a0 <kalloc>
801078c9:	89 c3                	mov    %eax,%ebx
801078cb:	85 c0                	test   %eax,%eax
801078cd:	74 21                	je     801078f0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801078cf:	83 ec 04             	sub    $0x4,%esp
801078d2:	68 00 10 00 00       	push   $0x1000
801078d7:	6a 00                	push   $0x0
801078d9:	50                   	push   %eax
801078da:	e8 51 dc ff ff       	call   80105530 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801078df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078e5:	83 c4 10             	add    $0x10,%esp
801078e8:	83 c8 07             	or     $0x7,%eax
801078eb:	89 07                	mov    %eax,(%edi)
801078ed:	eb b5                	jmp    801078a4 <walkpgdir+0x24>
801078ef:	90                   	nop
}
801078f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801078f3:	31 c0                	xor    %eax,%eax
}
801078f5:	5b                   	pop    %ebx
801078f6:	5e                   	pop    %esi
801078f7:	5f                   	pop    %edi
801078f8:	5d                   	pop    %ebp
801078f9:	c3                   	ret    
801078fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107900 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	57                   	push   %edi
80107904:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107906:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010790a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010790b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107910:	89 d6                	mov    %edx,%esi
{
80107912:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107913:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107919:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010791c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010791f:	8b 45 08             	mov    0x8(%ebp),%eax
80107922:	29 f0                	sub    %esi,%eax
80107924:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107927:	eb 1f                	jmp    80107948 <mappages+0x48>
80107929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107930:	f6 00 01             	testb  $0x1,(%eax)
80107933:	75 45                	jne    8010797a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107935:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107938:	83 cb 01             	or     $0x1,%ebx
8010793b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010793d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107940:	74 2e                	je     80107970 <mappages+0x70>
      break;
    a += PGSIZE;
80107942:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010794b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107950:	89 f2                	mov    %esi,%edx
80107952:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107955:	89 f8                	mov    %edi,%eax
80107957:	e8 24 ff ff ff       	call   80107880 <walkpgdir>
8010795c:	85 c0                	test   %eax,%eax
8010795e:	75 d0                	jne    80107930 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107960:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107963:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107968:	5b                   	pop    %ebx
80107969:	5e                   	pop    %esi
8010796a:	5f                   	pop    %edi
8010796b:	5d                   	pop    %ebp
8010796c:	c3                   	ret    
8010796d:	8d 76 00             	lea    0x0(%esi),%esi
80107970:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107973:	31 c0                	xor    %eax,%eax
}
80107975:	5b                   	pop    %ebx
80107976:	5e                   	pop    %esi
80107977:	5f                   	pop    %edi
80107978:	5d                   	pop    %ebp
80107979:	c3                   	ret    
      panic("remap");
8010797a:	83 ec 0c             	sub    $0xc,%esp
8010797d:	68 e8 8b 10 80       	push   $0x80108be8
80107982:	e8 09 8a ff ff       	call   80100390 <panic>
80107987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010798e:	66 90                	xchg   %ax,%ax

80107990 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	57                   	push   %edi
80107994:	56                   	push   %esi
80107995:	89 c6                	mov    %eax,%esi
80107997:	53                   	push   %ebx
80107998:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010799a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801079a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801079a6:	83 ec 1c             	sub    $0x1c,%esp
801079a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801079ac:	39 da                	cmp    %ebx,%edx
801079ae:	73 5b                	jae    80107a0b <deallocuvm.part.0+0x7b>
801079b0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801079b3:	89 d7                	mov    %edx,%edi
801079b5:	eb 14                	jmp    801079cb <deallocuvm.part.0+0x3b>
801079b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079be:	66 90                	xchg   %ax,%ax
801079c0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801079c6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801079c9:	76 40                	jbe    80107a0b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801079cb:	31 c9                	xor    %ecx,%ecx
801079cd:	89 fa                	mov    %edi,%edx
801079cf:	89 f0                	mov    %esi,%eax
801079d1:	e8 aa fe ff ff       	call   80107880 <walkpgdir>
801079d6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801079d8:	85 c0                	test   %eax,%eax
801079da:	74 44                	je     80107a20 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801079dc:	8b 00                	mov    (%eax),%eax
801079de:	a8 01                	test   $0x1,%al
801079e0:	74 de                	je     801079c0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801079e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079e7:	74 47                	je     80107a30 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801079e9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801079ec:	05 00 00 00 80       	add    $0x80000000,%eax
801079f1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801079f7:	50                   	push   %eax
801079f8:	e8 e3 ad ff ff       	call   801027e0 <kfree>
      *pte = 0;
801079fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107a03:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107a06:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107a09:	77 c0                	ja     801079cb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80107a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a11:	5b                   	pop    %ebx
80107a12:	5e                   	pop    %esi
80107a13:	5f                   	pop    %edi
80107a14:	5d                   	pop    %ebp
80107a15:	c3                   	ret    
80107a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a1d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107a20:	89 fa                	mov    %edi,%edx
80107a22:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107a28:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80107a2e:	eb 96                	jmp    801079c6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107a30:	83 ec 0c             	sub    $0xc,%esp
80107a33:	68 8a 84 10 80       	push   $0x8010848a
80107a38:	e8 53 89 ff ff       	call   80100390 <panic>
80107a3d:	8d 76 00             	lea    0x0(%esi),%esi

80107a40 <seginit>:
{
80107a40:	f3 0f 1e fb          	endbr32 
80107a44:	55                   	push   %ebp
80107a45:	89 e5                	mov    %esp,%ebp
80107a47:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107a4a:	e8 01 c3 ff ff       	call   80103d50 <cpuid>
  pd[0] = size-1;
80107a4f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107a54:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107a5a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107a5e:	c7 80 18 39 11 80 ff 	movl   $0xffff,-0x7feec6e8(%eax)
80107a65:	ff 00 00 
80107a68:	c7 80 1c 39 11 80 00 	movl   $0xcf9a00,-0x7feec6e4(%eax)
80107a6f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107a72:	c7 80 20 39 11 80 ff 	movl   $0xffff,-0x7feec6e0(%eax)
80107a79:	ff 00 00 
80107a7c:	c7 80 24 39 11 80 00 	movl   $0xcf9200,-0x7feec6dc(%eax)
80107a83:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107a86:	c7 80 28 39 11 80 ff 	movl   $0xffff,-0x7feec6d8(%eax)
80107a8d:	ff 00 00 
80107a90:	c7 80 2c 39 11 80 00 	movl   $0xcffa00,-0x7feec6d4(%eax)
80107a97:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107a9a:	c7 80 30 39 11 80 ff 	movl   $0xffff,-0x7feec6d0(%eax)
80107aa1:	ff 00 00 
80107aa4:	c7 80 34 39 11 80 00 	movl   $0xcff200,-0x7feec6cc(%eax)
80107aab:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107aae:	05 10 39 11 80       	add    $0x80113910,%eax
  pd[1] = (uint)p;
80107ab3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107ab7:	c1 e8 10             	shr    $0x10,%eax
80107aba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107abe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107ac1:	0f 01 10             	lgdtl  (%eax)
}
80107ac4:	c9                   	leave  
80107ac5:	c3                   	ret    
80107ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107acd:	8d 76 00             	lea    0x0(%esi),%esi

80107ad0 <switchkvm>:
{
80107ad0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107ad4:	a1 c4 8f 11 80       	mov    0x80118fc4,%eax
80107ad9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ade:	0f 22 d8             	mov    %eax,%cr3
}
80107ae1:	c3                   	ret    
80107ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107af0 <switchuvm>:
{
80107af0:	f3 0f 1e fb          	endbr32 
80107af4:	55                   	push   %ebp
80107af5:	89 e5                	mov    %esp,%ebp
80107af7:	57                   	push   %edi
80107af8:	56                   	push   %esi
80107af9:	53                   	push   %ebx
80107afa:	83 ec 1c             	sub    $0x1c,%esp
80107afd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107b00:	85 f6                	test   %esi,%esi
80107b02:	0f 84 cb 00 00 00    	je     80107bd3 <switchuvm+0xe3>
  if(p->kstack == 0)
80107b08:	8b 46 08             	mov    0x8(%esi),%eax
80107b0b:	85 c0                	test   %eax,%eax
80107b0d:	0f 84 da 00 00 00    	je     80107bed <switchuvm+0xfd>
  if(p->pgdir == 0)
80107b13:	8b 46 04             	mov    0x4(%esi),%eax
80107b16:	85 c0                	test   %eax,%eax
80107b18:	0f 84 c2 00 00 00    	je     80107be0 <switchuvm+0xf0>
  pushcli();
80107b1e:	e8 fd d7 ff ff       	call   80105320 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107b23:	e8 b8 c1 ff ff       	call   80103ce0 <mycpu>
80107b28:	89 c3                	mov    %eax,%ebx
80107b2a:	e8 b1 c1 ff ff       	call   80103ce0 <mycpu>
80107b2f:	89 c7                	mov    %eax,%edi
80107b31:	e8 aa c1 ff ff       	call   80103ce0 <mycpu>
80107b36:	83 c7 08             	add    $0x8,%edi
80107b39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b3c:	e8 9f c1 ff ff       	call   80103ce0 <mycpu>
80107b41:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107b44:	ba 67 00 00 00       	mov    $0x67,%edx
80107b49:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107b50:	83 c0 08             	add    $0x8,%eax
80107b53:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107b5a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107b5f:	83 c1 08             	add    $0x8,%ecx
80107b62:	c1 e8 18             	shr    $0x18,%eax
80107b65:	c1 e9 10             	shr    $0x10,%ecx
80107b68:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107b6e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107b74:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107b79:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107b80:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107b85:	e8 56 c1 ff ff       	call   80103ce0 <mycpu>
80107b8a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107b91:	e8 4a c1 ff ff       	call   80103ce0 <mycpu>
80107b96:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107b9a:	8b 5e 08             	mov    0x8(%esi),%ebx
80107b9d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ba3:	e8 38 c1 ff ff       	call   80103ce0 <mycpu>
80107ba8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107bab:	e8 30 c1 ff ff       	call   80103ce0 <mycpu>
80107bb0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107bb4:	b8 28 00 00 00       	mov    $0x28,%eax
80107bb9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107bbc:	8b 46 04             	mov    0x4(%esi),%eax
80107bbf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107bc4:	0f 22 d8             	mov    %eax,%cr3
}
80107bc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bca:	5b                   	pop    %ebx
80107bcb:	5e                   	pop    %esi
80107bcc:	5f                   	pop    %edi
80107bcd:	5d                   	pop    %ebp
  popcli();
80107bce:	e9 9d d7 ff ff       	jmp    80105370 <popcli>
    panic("switchuvm: no process");
80107bd3:	83 ec 0c             	sub    $0xc,%esp
80107bd6:	68 ee 8b 10 80       	push   $0x80108bee
80107bdb:	e8 b0 87 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107be0:	83 ec 0c             	sub    $0xc,%esp
80107be3:	68 19 8c 10 80       	push   $0x80108c19
80107be8:	e8 a3 87 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107bed:	83 ec 0c             	sub    $0xc,%esp
80107bf0:	68 04 8c 10 80       	push   $0x80108c04
80107bf5:	e8 96 87 ff ff       	call   80100390 <panic>
80107bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107c00 <inituvm>:
{
80107c00:	f3 0f 1e fb          	endbr32 
80107c04:	55                   	push   %ebp
80107c05:	89 e5                	mov    %esp,%ebp
80107c07:	57                   	push   %edi
80107c08:	56                   	push   %esi
80107c09:	53                   	push   %ebx
80107c0a:	83 ec 1c             	sub    $0x1c,%esp
80107c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c10:	8b 75 10             	mov    0x10(%ebp),%esi
80107c13:	8b 7d 08             	mov    0x8(%ebp),%edi
80107c16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107c19:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107c1f:	77 4b                	ja     80107c6c <inituvm+0x6c>
  mem = kalloc();
80107c21:	e8 7a ad ff ff       	call   801029a0 <kalloc>
  memset(mem, 0, PGSIZE);
80107c26:	83 ec 04             	sub    $0x4,%esp
80107c29:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107c2e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107c30:	6a 00                	push   $0x0
80107c32:	50                   	push   %eax
80107c33:	e8 f8 d8 ff ff       	call   80105530 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107c38:	58                   	pop    %eax
80107c39:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c3f:	5a                   	pop    %edx
80107c40:	6a 06                	push   $0x6
80107c42:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c47:	31 d2                	xor    %edx,%edx
80107c49:	50                   	push   %eax
80107c4a:	89 f8                	mov    %edi,%eax
80107c4c:	e8 af fc ff ff       	call   80107900 <mappages>
  memmove(mem, init, sz);
80107c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c54:	89 75 10             	mov    %esi,0x10(%ebp)
80107c57:	83 c4 10             	add    $0x10,%esp
80107c5a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107c5d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c63:	5b                   	pop    %ebx
80107c64:	5e                   	pop    %esi
80107c65:	5f                   	pop    %edi
80107c66:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107c67:	e9 64 d9 ff ff       	jmp    801055d0 <memmove>
    panic("inituvm: more than a page");
80107c6c:	83 ec 0c             	sub    $0xc,%esp
80107c6f:	68 2d 8c 10 80       	push   $0x80108c2d
80107c74:	e8 17 87 ff ff       	call   80100390 <panic>
80107c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c80 <loaduvm>:
{
80107c80:	f3 0f 1e fb          	endbr32 
80107c84:	55                   	push   %ebp
80107c85:	89 e5                	mov    %esp,%ebp
80107c87:	57                   	push   %edi
80107c88:	56                   	push   %esi
80107c89:	53                   	push   %ebx
80107c8a:	83 ec 1c             	sub    $0x1c,%esp
80107c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c90:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107c93:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107c98:	0f 85 99 00 00 00    	jne    80107d37 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80107c9e:	01 f0                	add    %esi,%eax
80107ca0:	89 f3                	mov    %esi,%ebx
80107ca2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107ca5:	8b 45 14             	mov    0x14(%ebp),%eax
80107ca8:	01 f0                	add    %esi,%eax
80107caa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107cad:	85 f6                	test   %esi,%esi
80107caf:	75 15                	jne    80107cc6 <loaduvm+0x46>
80107cb1:	eb 6d                	jmp    80107d20 <loaduvm+0xa0>
80107cb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107cb7:	90                   	nop
80107cb8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107cbe:	89 f0                	mov    %esi,%eax
80107cc0:	29 d8                	sub    %ebx,%eax
80107cc2:	39 c6                	cmp    %eax,%esi
80107cc4:	76 5a                	jbe    80107d20 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107cc6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107cc9:	8b 45 08             	mov    0x8(%ebp),%eax
80107ccc:	31 c9                	xor    %ecx,%ecx
80107cce:	29 da                	sub    %ebx,%edx
80107cd0:	e8 ab fb ff ff       	call   80107880 <walkpgdir>
80107cd5:	85 c0                	test   %eax,%eax
80107cd7:	74 51                	je     80107d2a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107cd9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107cdb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107cde:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107ce3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107ce8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107cee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107cf1:	29 d9                	sub    %ebx,%ecx
80107cf3:	05 00 00 00 80       	add    $0x80000000,%eax
80107cf8:	57                   	push   %edi
80107cf9:	51                   	push   %ecx
80107cfa:	50                   	push   %eax
80107cfb:	ff 75 10             	pushl  0x10(%ebp)
80107cfe:	e8 cd a0 ff ff       	call   80101dd0 <readi>
80107d03:	83 c4 10             	add    $0x10,%esp
80107d06:	39 f8                	cmp    %edi,%eax
80107d08:	74 ae                	je     80107cb8 <loaduvm+0x38>
}
80107d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d12:	5b                   	pop    %ebx
80107d13:	5e                   	pop    %esi
80107d14:	5f                   	pop    %edi
80107d15:	5d                   	pop    %ebp
80107d16:	c3                   	ret    
80107d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d1e:	66 90                	xchg   %ax,%ax
80107d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d23:	31 c0                	xor    %eax,%eax
}
80107d25:	5b                   	pop    %ebx
80107d26:	5e                   	pop    %esi
80107d27:	5f                   	pop    %edi
80107d28:	5d                   	pop    %ebp
80107d29:	c3                   	ret    
      panic("loaduvm: address should exist");
80107d2a:	83 ec 0c             	sub    $0xc,%esp
80107d2d:	68 47 8c 10 80       	push   $0x80108c47
80107d32:	e8 59 86 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107d37:	83 ec 0c             	sub    $0xc,%esp
80107d3a:	68 e8 8c 10 80       	push   $0x80108ce8
80107d3f:	e8 4c 86 ff ff       	call   80100390 <panic>
80107d44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d4f:	90                   	nop

80107d50 <allocuvm>:
{
80107d50:	f3 0f 1e fb          	endbr32 
80107d54:	55                   	push   %ebp
80107d55:	89 e5                	mov    %esp,%ebp
80107d57:	57                   	push   %edi
80107d58:	56                   	push   %esi
80107d59:	53                   	push   %ebx
80107d5a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107d5d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107d60:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107d63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d66:	85 c0                	test   %eax,%eax
80107d68:	0f 88 b2 00 00 00    	js     80107e20 <allocuvm+0xd0>
  if(newsz < oldsz)
80107d6e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107d74:	0f 82 96 00 00 00    	jb     80107e10 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107d7a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107d80:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107d86:	39 75 10             	cmp    %esi,0x10(%ebp)
80107d89:	77 40                	ja     80107dcb <allocuvm+0x7b>
80107d8b:	e9 83 00 00 00       	jmp    80107e13 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107d90:	83 ec 04             	sub    $0x4,%esp
80107d93:	68 00 10 00 00       	push   $0x1000
80107d98:	6a 00                	push   $0x0
80107d9a:	50                   	push   %eax
80107d9b:	e8 90 d7 ff ff       	call   80105530 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107da0:	58                   	pop    %eax
80107da1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107da7:	5a                   	pop    %edx
80107da8:	6a 06                	push   $0x6
80107daa:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107daf:	89 f2                	mov    %esi,%edx
80107db1:	50                   	push   %eax
80107db2:	89 f8                	mov    %edi,%eax
80107db4:	e8 47 fb ff ff       	call   80107900 <mappages>
80107db9:	83 c4 10             	add    $0x10,%esp
80107dbc:	85 c0                	test   %eax,%eax
80107dbe:	78 78                	js     80107e38 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107dc0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107dc6:	39 75 10             	cmp    %esi,0x10(%ebp)
80107dc9:	76 48                	jbe    80107e13 <allocuvm+0xc3>
    mem = kalloc();
80107dcb:	e8 d0 ab ff ff       	call   801029a0 <kalloc>
80107dd0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107dd2:	85 c0                	test   %eax,%eax
80107dd4:	75 ba                	jne    80107d90 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107dd6:	83 ec 0c             	sub    $0xc,%esp
80107dd9:	68 65 8c 10 80       	push   $0x80108c65
80107dde:	e8 cd 88 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107de3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107de6:	83 c4 10             	add    $0x10,%esp
80107de9:	39 45 10             	cmp    %eax,0x10(%ebp)
80107dec:	74 32                	je     80107e20 <allocuvm+0xd0>
80107dee:	8b 55 10             	mov    0x10(%ebp),%edx
80107df1:	89 c1                	mov    %eax,%ecx
80107df3:	89 f8                	mov    %edi,%eax
80107df5:	e8 96 fb ff ff       	call   80107990 <deallocuvm.part.0>
      return 0;
80107dfa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e07:	5b                   	pop    %ebx
80107e08:	5e                   	pop    %esi
80107e09:	5f                   	pop    %edi
80107e0a:	5d                   	pop    %ebp
80107e0b:	c3                   	ret    
80107e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107e10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e19:	5b                   	pop    %ebx
80107e1a:	5e                   	pop    %esi
80107e1b:	5f                   	pop    %edi
80107e1c:	5d                   	pop    %ebp
80107e1d:	c3                   	ret    
80107e1e:	66 90                	xchg   %ax,%ax
    return 0;
80107e20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107e27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e2d:	5b                   	pop    %ebx
80107e2e:	5e                   	pop    %esi
80107e2f:	5f                   	pop    %edi
80107e30:	5d                   	pop    %ebp
80107e31:	c3                   	ret    
80107e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107e38:	83 ec 0c             	sub    $0xc,%esp
80107e3b:	68 7d 8c 10 80       	push   $0x80108c7d
80107e40:	e8 6b 88 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107e45:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e48:	83 c4 10             	add    $0x10,%esp
80107e4b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107e4e:	74 0c                	je     80107e5c <allocuvm+0x10c>
80107e50:	8b 55 10             	mov    0x10(%ebp),%edx
80107e53:	89 c1                	mov    %eax,%ecx
80107e55:	89 f8                	mov    %edi,%eax
80107e57:	e8 34 fb ff ff       	call   80107990 <deallocuvm.part.0>
      kfree(mem);
80107e5c:	83 ec 0c             	sub    $0xc,%esp
80107e5f:	53                   	push   %ebx
80107e60:	e8 7b a9 ff ff       	call   801027e0 <kfree>
      return 0;
80107e65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107e6c:	83 c4 10             	add    $0x10,%esp
}
80107e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e75:	5b                   	pop    %ebx
80107e76:	5e                   	pop    %esi
80107e77:	5f                   	pop    %edi
80107e78:	5d                   	pop    %ebp
80107e79:	c3                   	ret    
80107e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e80 <deallocuvm>:
{
80107e80:	f3 0f 1e fb          	endbr32 
80107e84:	55                   	push   %ebp
80107e85:	89 e5                	mov    %esp,%ebp
80107e87:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107e90:	39 d1                	cmp    %edx,%ecx
80107e92:	73 0c                	jae    80107ea0 <deallocuvm+0x20>
}
80107e94:	5d                   	pop    %ebp
80107e95:	e9 f6 fa ff ff       	jmp    80107990 <deallocuvm.part.0>
80107e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ea0:	89 d0                	mov    %edx,%eax
80107ea2:	5d                   	pop    %ebp
80107ea3:	c3                   	ret    
80107ea4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107eaf:	90                   	nop

80107eb0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107eb0:	f3 0f 1e fb          	endbr32 
80107eb4:	55                   	push   %ebp
80107eb5:	89 e5                	mov    %esp,%ebp
80107eb7:	57                   	push   %edi
80107eb8:	56                   	push   %esi
80107eb9:	53                   	push   %ebx
80107eba:	83 ec 0c             	sub    $0xc,%esp
80107ebd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107ec0:	85 f6                	test   %esi,%esi
80107ec2:	74 55                	je     80107f19 <freevm+0x69>
  if(newsz >= oldsz)
80107ec4:	31 c9                	xor    %ecx,%ecx
80107ec6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107ecb:	89 f0                	mov    %esi,%eax
80107ecd:	89 f3                	mov    %esi,%ebx
80107ecf:	e8 bc fa ff ff       	call   80107990 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107ed4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107eda:	eb 0b                	jmp    80107ee7 <freevm+0x37>
80107edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ee0:	83 c3 04             	add    $0x4,%ebx
80107ee3:	39 df                	cmp    %ebx,%edi
80107ee5:	74 23                	je     80107f0a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107ee7:	8b 03                	mov    (%ebx),%eax
80107ee9:	a8 01                	test   $0x1,%al
80107eeb:	74 f3                	je     80107ee0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107eed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107ef2:	83 ec 0c             	sub    $0xc,%esp
80107ef5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ef8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107efd:	50                   	push   %eax
80107efe:	e8 dd a8 ff ff       	call   801027e0 <kfree>
80107f03:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107f06:	39 df                	cmp    %ebx,%edi
80107f08:	75 dd                	jne    80107ee7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107f0a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107f0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f10:	5b                   	pop    %ebx
80107f11:	5e                   	pop    %esi
80107f12:	5f                   	pop    %edi
80107f13:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107f14:	e9 c7 a8 ff ff       	jmp    801027e0 <kfree>
    panic("freevm: no pgdir");
80107f19:	83 ec 0c             	sub    $0xc,%esp
80107f1c:	68 99 8c 10 80       	push   $0x80108c99
80107f21:	e8 6a 84 ff ff       	call   80100390 <panic>
80107f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f2d:	8d 76 00             	lea    0x0(%esi),%esi

80107f30 <setupkvm>:
{
80107f30:	f3 0f 1e fb          	endbr32 
80107f34:	55                   	push   %ebp
80107f35:	89 e5                	mov    %esp,%ebp
80107f37:	56                   	push   %esi
80107f38:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107f39:	e8 62 aa ff ff       	call   801029a0 <kalloc>
80107f3e:	89 c6                	mov    %eax,%esi
80107f40:	85 c0                	test   %eax,%eax
80107f42:	74 42                	je     80107f86 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107f44:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f47:	bb a0 b4 10 80       	mov    $0x8010b4a0,%ebx
  memset(pgdir, 0, PGSIZE);
80107f4c:	68 00 10 00 00       	push   $0x1000
80107f51:	6a 00                	push   $0x0
80107f53:	50                   	push   %eax
80107f54:	e8 d7 d5 ff ff       	call   80105530 <memset>
80107f59:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107f5c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107f5f:	83 ec 08             	sub    $0x8,%esp
80107f62:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107f65:	ff 73 0c             	pushl  0xc(%ebx)
80107f68:	8b 13                	mov    (%ebx),%edx
80107f6a:	50                   	push   %eax
80107f6b:	29 c1                	sub    %eax,%ecx
80107f6d:	89 f0                	mov    %esi,%eax
80107f6f:	e8 8c f9 ff ff       	call   80107900 <mappages>
80107f74:	83 c4 10             	add    $0x10,%esp
80107f77:	85 c0                	test   %eax,%eax
80107f79:	78 15                	js     80107f90 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f7b:	83 c3 10             	add    $0x10,%ebx
80107f7e:	81 fb e0 b4 10 80    	cmp    $0x8010b4e0,%ebx
80107f84:	75 d6                	jne    80107f5c <setupkvm+0x2c>
}
80107f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107f89:	89 f0                	mov    %esi,%eax
80107f8b:	5b                   	pop    %ebx
80107f8c:	5e                   	pop    %esi
80107f8d:	5d                   	pop    %ebp
80107f8e:	c3                   	ret    
80107f8f:	90                   	nop
      freevm(pgdir);
80107f90:	83 ec 0c             	sub    $0xc,%esp
80107f93:	56                   	push   %esi
      return 0;
80107f94:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107f96:	e8 15 ff ff ff       	call   80107eb0 <freevm>
      return 0;
80107f9b:	83 c4 10             	add    $0x10,%esp
}
80107f9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107fa1:	89 f0                	mov    %esi,%eax
80107fa3:	5b                   	pop    %ebx
80107fa4:	5e                   	pop    %esi
80107fa5:	5d                   	pop    %ebp
80107fa6:	c3                   	ret    
80107fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fae:	66 90                	xchg   %ax,%ax

80107fb0 <kvmalloc>:
{
80107fb0:	f3 0f 1e fb          	endbr32 
80107fb4:	55                   	push   %ebp
80107fb5:	89 e5                	mov    %esp,%ebp
80107fb7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107fba:	e8 71 ff ff ff       	call   80107f30 <setupkvm>
80107fbf:	a3 c4 8f 11 80       	mov    %eax,0x80118fc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107fc4:	05 00 00 00 80       	add    $0x80000000,%eax
80107fc9:	0f 22 d8             	mov    %eax,%cr3
}
80107fcc:	c9                   	leave  
80107fcd:	c3                   	ret    
80107fce:	66 90                	xchg   %ax,%ax

80107fd0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107fd0:	f3 0f 1e fb          	endbr32 
80107fd4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107fd5:	31 c9                	xor    %ecx,%ecx
{
80107fd7:	89 e5                	mov    %esp,%ebp
80107fd9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107fdc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80107fe2:	e8 99 f8 ff ff       	call   80107880 <walkpgdir>
  if(pte == 0)
80107fe7:	85 c0                	test   %eax,%eax
80107fe9:	74 05                	je     80107ff0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107feb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107fee:	c9                   	leave  
80107fef:	c3                   	ret    
    panic("clearpteu");
80107ff0:	83 ec 0c             	sub    $0xc,%esp
80107ff3:	68 aa 8c 10 80       	push   $0x80108caa
80107ff8:	e8 93 83 ff ff       	call   80100390 <panic>
80107ffd:	8d 76 00             	lea    0x0(%esi),%esi

80108000 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108000:	f3 0f 1e fb          	endbr32 
80108004:	55                   	push   %ebp
80108005:	89 e5                	mov    %esp,%ebp
80108007:	57                   	push   %edi
80108008:	56                   	push   %esi
80108009:	53                   	push   %ebx
8010800a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010800d:	e8 1e ff ff ff       	call   80107f30 <setupkvm>
80108012:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108015:	85 c0                	test   %eax,%eax
80108017:	0f 84 9b 00 00 00    	je     801080b8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010801d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108020:	85 c9                	test   %ecx,%ecx
80108022:	0f 84 90 00 00 00    	je     801080b8 <copyuvm+0xb8>
80108028:	31 f6                	xor    %esi,%esi
8010802a:	eb 46                	jmp    80108072 <copyuvm+0x72>
8010802c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108030:	83 ec 04             	sub    $0x4,%esp
80108033:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108039:	68 00 10 00 00       	push   $0x1000
8010803e:	57                   	push   %edi
8010803f:	50                   	push   %eax
80108040:	e8 8b d5 ff ff       	call   801055d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108045:	58                   	pop    %eax
80108046:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010804c:	5a                   	pop    %edx
8010804d:	ff 75 e4             	pushl  -0x1c(%ebp)
80108050:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108055:	89 f2                	mov    %esi,%edx
80108057:	50                   	push   %eax
80108058:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010805b:	e8 a0 f8 ff ff       	call   80107900 <mappages>
80108060:	83 c4 10             	add    $0x10,%esp
80108063:	85 c0                	test   %eax,%eax
80108065:	78 61                	js     801080c8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108067:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010806d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108070:	76 46                	jbe    801080b8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108072:	8b 45 08             	mov    0x8(%ebp),%eax
80108075:	31 c9                	xor    %ecx,%ecx
80108077:	89 f2                	mov    %esi,%edx
80108079:	e8 02 f8 ff ff       	call   80107880 <walkpgdir>
8010807e:	85 c0                	test   %eax,%eax
80108080:	74 61                	je     801080e3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80108082:	8b 00                	mov    (%eax),%eax
80108084:	a8 01                	test   $0x1,%al
80108086:	74 4e                	je     801080d6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80108088:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010808a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010808f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80108092:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108098:	e8 03 a9 ff ff       	call   801029a0 <kalloc>
8010809d:	89 c3                	mov    %eax,%ebx
8010809f:	85 c0                	test   %eax,%eax
801080a1:	75 8d                	jne    80108030 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801080a3:	83 ec 0c             	sub    $0xc,%esp
801080a6:	ff 75 e0             	pushl  -0x20(%ebp)
801080a9:	e8 02 fe ff ff       	call   80107eb0 <freevm>
  return 0;
801080ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801080b5:	83 c4 10             	add    $0x10,%esp
}
801080b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080be:	5b                   	pop    %ebx
801080bf:	5e                   	pop    %esi
801080c0:	5f                   	pop    %edi
801080c1:	5d                   	pop    %ebp
801080c2:	c3                   	ret    
801080c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801080c7:	90                   	nop
      kfree(mem);
801080c8:	83 ec 0c             	sub    $0xc,%esp
801080cb:	53                   	push   %ebx
801080cc:	e8 0f a7 ff ff       	call   801027e0 <kfree>
      goto bad;
801080d1:	83 c4 10             	add    $0x10,%esp
801080d4:	eb cd                	jmp    801080a3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801080d6:	83 ec 0c             	sub    $0xc,%esp
801080d9:	68 ce 8c 10 80       	push   $0x80108cce
801080de:	e8 ad 82 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801080e3:	83 ec 0c             	sub    $0xc,%esp
801080e6:	68 b4 8c 10 80       	push   $0x80108cb4
801080eb:	e8 a0 82 ff ff       	call   80100390 <panic>

801080f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801080f0:	f3 0f 1e fb          	endbr32 
801080f4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801080f5:	31 c9                	xor    %ecx,%ecx
{
801080f7:	89 e5                	mov    %esp,%ebp
801080f9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801080fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801080ff:	8b 45 08             	mov    0x8(%ebp),%eax
80108102:	e8 79 f7 ff ff       	call   80107880 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108107:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108109:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010810a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010810c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108111:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108114:	05 00 00 00 80       	add    $0x80000000,%eax
80108119:	83 fa 05             	cmp    $0x5,%edx
8010811c:	ba 00 00 00 00       	mov    $0x0,%edx
80108121:	0f 45 c2             	cmovne %edx,%eax
}
80108124:	c3                   	ret    
80108125:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010812c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108130 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108130:	f3 0f 1e fb          	endbr32 
80108134:	55                   	push   %ebp
80108135:	89 e5                	mov    %esp,%ebp
80108137:	57                   	push   %edi
80108138:	56                   	push   %esi
80108139:	53                   	push   %ebx
8010813a:	83 ec 0c             	sub    $0xc,%esp
8010813d:	8b 75 14             	mov    0x14(%ebp),%esi
80108140:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108143:	85 f6                	test   %esi,%esi
80108145:	75 3c                	jne    80108183 <copyout+0x53>
80108147:	eb 67                	jmp    801081b0 <copyout+0x80>
80108149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108150:	8b 55 0c             	mov    0xc(%ebp),%edx
80108153:	89 fb                	mov    %edi,%ebx
80108155:	29 d3                	sub    %edx,%ebx
80108157:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010815d:	39 f3                	cmp    %esi,%ebx
8010815f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108162:	29 fa                	sub    %edi,%edx
80108164:	83 ec 04             	sub    $0x4,%esp
80108167:	01 c2                	add    %eax,%edx
80108169:	53                   	push   %ebx
8010816a:	ff 75 10             	pushl  0x10(%ebp)
8010816d:	52                   	push   %edx
8010816e:	e8 5d d4 ff ff       	call   801055d0 <memmove>
    len -= n;
    buf += n;
80108173:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108176:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010817c:	83 c4 10             	add    $0x10,%esp
8010817f:	29 de                	sub    %ebx,%esi
80108181:	74 2d                	je     801081b0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108183:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108185:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108188:	89 55 0c             	mov    %edx,0xc(%ebp)
8010818b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108191:	57                   	push   %edi
80108192:	ff 75 08             	pushl  0x8(%ebp)
80108195:	e8 56 ff ff ff       	call   801080f0 <uva2ka>
    if(pa0 == 0)
8010819a:	83 c4 10             	add    $0x10,%esp
8010819d:	85 c0                	test   %eax,%eax
8010819f:	75 af                	jne    80108150 <copyout+0x20>
  }
  return 0;
}
801081a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801081a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801081a9:	5b                   	pop    %ebx
801081aa:	5e                   	pop    %esi
801081ab:	5f                   	pop    %edi
801081ac:	5d                   	pop    %ebp
801081ad:	c3                   	ret    
801081ae:	66 90                	xchg   %ax,%ax
801081b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801081b3:	31 c0                	xor    %eax,%eax
}
801081b5:	5b                   	pop    %ebx
801081b6:	5e                   	pop    %esi
801081b7:	5f                   	pop    %edi
801081b8:	5d                   	pop    %ebp
801081b9:	c3                   	ret    
