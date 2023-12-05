
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8d013103          	ld	sp,-1840(sp) # 800088d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	8e070713          	addi	a4,a4,-1824 # 80008930 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	2ae78793          	addi	a5,a5,686 # 80006310 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbc047>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	f4078793          	addi	a5,a5,-192 # 80000fec <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	738080e7          	jalr	1848(ra) # 80002862 <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	784080e7          	jalr	1924(ra) # 800008be <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	8e650513          	addi	a0,a0,-1818 # 80010a70 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	bb8080e7          	jalr	-1096(ra) # 80000d4a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	8d648493          	addi	s1,s1,-1834 # 80010a70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	96690913          	addi	s2,s2,-1690 # 80010b08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	a42080e7          	jalr	-1470(ra) # 80001c02 <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	4e4080e7          	jalr	1252(ra) # 800026ac <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	222080e7          	jalr	546(ra) # 800023f8 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	5fa080e7          	jalr	1530(ra) # 8000280c <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	84a50513          	addi	a0,a0,-1974 # 80010a70 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	bd0080e7          	jalr	-1072(ra) # 80000dfe <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	83450513          	addi	a0,a0,-1996 # 80010a70 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	bba080e7          	jalr	-1094(ra) # 80000dfe <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	88f72b23          	sw	a5,-1898(a4) # 80010b08 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	560080e7          	jalr	1376(ra) # 800007ec <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54e080e7          	jalr	1358(ra) # 800007ec <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	542080e7          	jalr	1346(ra) # 800007ec <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	538080e7          	jalr	1336(ra) # 800007ec <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00010517          	auipc	a0,0x10
    800002d0:	7a450513          	addi	a0,a0,1956 # 80010a70 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	a76080e7          	jalr	-1418(ra) # 80000d4a <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	5c6080e7          	jalr	1478(ra) # 800028b8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	77650513          	addi	a0,a0,1910 # 80010a70 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	afc080e7          	jalr	-1284(ra) # 80000dfe <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	75270713          	addi	a4,a4,1874 # 80010a70 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	72878793          	addi	a5,a5,1832 # 80010a70 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00010797          	auipc	a5,0x10
    8000037a:	7927a783          	lw	a5,1938(a5) # 80010b08 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	6e670713          	addi	a4,a4,1766 # 80010a70 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	6d648493          	addi	s1,s1,1750 # 80010a70 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	69a70713          	addi	a4,a4,1690 # 80010a70 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	72f72223          	sw	a5,1828(a4) # 80010b10 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00010797          	auipc	a5,0x10
    80000416:	65e78793          	addi	a5,a5,1630 # 80010a70 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	6cc7ab23          	sw	a2,1750(a5) # 80010b0c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	6ca50513          	addi	a0,a0,1738 # 80010b08 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	016080e7          	jalr	22(ra) # 8000245c <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	61050513          	addi	a0,a0,1552 # 80010a70 <cons>
    80000468:	00001097          	auipc	ra,0x1
    8000046c:	852080e7          	jalr	-1966(ra) # 80000cba <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32c080e7          	jalr	812(ra) # 8000079c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00241797          	auipc	a5,0x241
    8000047c:	1a878793          	addi	a5,a5,424 # 80241620 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7670713          	addi	a4,a4,-906 # 80000100 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054763          	bltz	a0,80000538 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00008617          	auipc	a2,0x8
    800004be:	b8660613          	addi	a2,a2,-1146 # 80008040 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if(sign)
    800004e6:	00088c63          	beqz	a7,800004fe <printint+0x62>
    buf[i++] = '-';
    800004ea:	fe070793          	addi	a5,a4,-32
    800004ee:	00878733          	add	a4,a5,s0
    800004f2:	02d00793          	li	a5,45
    800004f6:	fef70823          	sb	a5,-16(a4)
    800004fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fe:	02e05763          	blez	a4,8000052c <printint+0x90>
    80000502:	fd040793          	addi	a5,s0,-48
    80000506:	00e784b3          	add	s1,a5,a4
    8000050a:	fff78913          	addi	s2,a5,-1
    8000050e:	993a                	add	s2,s2,a4
    80000510:	377d                	addiw	a4,a4,-1
    80000512:	1702                	slli	a4,a4,0x20
    80000514:	9301                	srli	a4,a4,0x20
    80000516:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051a:	fff4c503          	lbu	a0,-1(s1)
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	d5e080e7          	jalr	-674(ra) # 8000027c <consputc>
  while(--i >= 0)
    80000526:	14fd                	addi	s1,s1,-1
    80000528:	ff2499e3          	bne	s1,s2,8000051a <printint+0x7e>
}
    8000052c:	70a2                	ld	ra,40(sp)
    8000052e:	7402                	ld	s0,32(sp)
    80000530:	64e2                	ld	s1,24(sp)
    80000532:	6942                	ld	s2,16(sp)
    80000534:	6145                	addi	sp,sp,48
    80000536:	8082                	ret
    x = -xx;
    80000538:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053c:	4885                	li	a7,1
    x = -xx;
    8000053e:	bf95                	j	800004b2 <printint+0x16>

0000000080000540 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000540:	1101                	addi	sp,sp,-32
    80000542:	ec06                	sd	ra,24(sp)
    80000544:	e822                	sd	s0,16(sp)
    80000546:	e426                	sd	s1,8(sp)
    80000548:	1000                	addi	s0,sp,32
    8000054a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054c:	00010797          	auipc	a5,0x10
    80000550:	5e07a223          	sw	zero,1508(a5) # 80010b30 <pr+0x18>
  printf("panic: ");
    80000554:	00008517          	auipc	a0,0x8
    80000558:	ac450513          	addi	a0,a0,-1340 # 80008018 <etext+0x18>
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	02e080e7          	jalr	46(ra) # 8000058a <printf>
  printf(s);
    80000564:	8526                	mv	a0,s1
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	024080e7          	jalr	36(ra) # 8000058a <printf>
  printf("\n");
    8000056e:	00008517          	auipc	a0,0x8
    80000572:	d3250513          	addi	a0,a0,-718 # 800082a0 <digits+0x260>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	014080e7          	jalr	20(ra) # 8000058a <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057e:	4785                	li	a5,1
    80000580:	00008717          	auipc	a4,0x8
    80000584:	36f72823          	sw	a5,880(a4) # 800088f0 <panicked>
  for(;;)
    80000588:	a001                	j	80000588 <panic+0x48>

000000008000058a <printf>:
{
    8000058a:	7131                	addi	sp,sp,-192
    8000058c:	fc86                	sd	ra,120(sp)
    8000058e:	f8a2                	sd	s0,112(sp)
    80000590:	f4a6                	sd	s1,104(sp)
    80000592:	f0ca                	sd	s2,96(sp)
    80000594:	ecce                	sd	s3,88(sp)
    80000596:	e8d2                	sd	s4,80(sp)
    80000598:	e4d6                	sd	s5,72(sp)
    8000059a:	e0da                	sd	s6,64(sp)
    8000059c:	fc5e                	sd	s7,56(sp)
    8000059e:	f862                	sd	s8,48(sp)
    800005a0:	f466                	sd	s9,40(sp)
    800005a2:	f06a                	sd	s10,32(sp)
    800005a4:	ec6e                	sd	s11,24(sp)
    800005a6:	0100                	addi	s0,sp,128
    800005a8:	8a2a                	mv	s4,a0
    800005aa:	e40c                	sd	a1,8(s0)
    800005ac:	e810                	sd	a2,16(s0)
    800005ae:	ec14                	sd	a3,24(s0)
    800005b0:	f018                	sd	a4,32(s0)
    800005b2:	f41c                	sd	a5,40(s0)
    800005b4:	03043823          	sd	a6,48(s0)
    800005b8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005bc:	00010d97          	auipc	s11,0x10
    800005c0:	574dad83          	lw	s11,1396(s11) # 80010b30 <pr+0x18>
  if(locking)
    800005c4:	020d9b63          	bnez	s11,800005fa <printf+0x70>
  if (fmt == 0)
    800005c8:	040a0263          	beqz	s4,8000060c <printf+0x82>
  va_start(ap, fmt);
    800005cc:	00840793          	addi	a5,s0,8
    800005d0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d4:	000a4503          	lbu	a0,0(s4)
    800005d8:	14050f63          	beqz	a0,80000736 <printf+0x1ac>
    800005dc:	4981                	li	s3,0
    if(c != '%'){
    800005de:	02500a93          	li	s5,37
    switch(c){
    800005e2:	07000b93          	li	s7,112
  consputc('x');
    800005e6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e8:	00008b17          	auipc	s6,0x8
    800005ec:	a58b0b13          	addi	s6,s6,-1448 # 80008040 <digits>
    switch(c){
    800005f0:	07300c93          	li	s9,115
    800005f4:	06400c13          	li	s8,100
    800005f8:	a82d                	j	80000632 <printf+0xa8>
    acquire(&pr.lock);
    800005fa:	00010517          	auipc	a0,0x10
    800005fe:	51e50513          	addi	a0,a0,1310 # 80010b18 <pr>
    80000602:	00000097          	auipc	ra,0x0
    80000606:	748080e7          	jalr	1864(ra) # 80000d4a <acquire>
    8000060a:	bf7d                	j	800005c8 <printf+0x3e>
    panic("null fmt");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a1c50513          	addi	a0,a0,-1508 # 80008028 <etext+0x28>
    80000614:	00000097          	auipc	ra,0x0
    80000618:	f2c080e7          	jalr	-212(ra) # 80000540 <panic>
      consputc(c);
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	c60080e7          	jalr	-928(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000624:	2985                	addiw	s3,s3,1
    80000626:	013a07b3          	add	a5,s4,s3
    8000062a:	0007c503          	lbu	a0,0(a5)
    8000062e:	10050463          	beqz	a0,80000736 <printf+0x1ac>
    if(c != '%'){
    80000632:	ff5515e3          	bne	a0,s5,8000061c <printf+0x92>
    c = fmt[++i] & 0xff;
    80000636:	2985                	addiw	s3,s3,1
    80000638:	013a07b3          	add	a5,s4,s3
    8000063c:	0007c783          	lbu	a5,0(a5)
    80000640:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000644:	cbed                	beqz	a5,80000736 <printf+0x1ac>
    switch(c){
    80000646:	05778a63          	beq	a5,s7,8000069a <printf+0x110>
    8000064a:	02fbf663          	bgeu	s7,a5,80000676 <printf+0xec>
    8000064e:	09978863          	beq	a5,s9,800006de <printf+0x154>
    80000652:	07800713          	li	a4,120
    80000656:	0ce79563          	bne	a5,a4,80000720 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000065a:	f8843783          	ld	a5,-120(s0)
    8000065e:	00878713          	addi	a4,a5,8
    80000662:	f8e43423          	sd	a4,-120(s0)
    80000666:	4605                	li	a2,1
    80000668:	85ea                	mv	a1,s10
    8000066a:	4388                	lw	a0,0(a5)
    8000066c:	00000097          	auipc	ra,0x0
    80000670:	e30080e7          	jalr	-464(ra) # 8000049c <printint>
      break;
    80000674:	bf45                	j	80000624 <printf+0x9a>
    switch(c){
    80000676:	09578f63          	beq	a5,s5,80000714 <printf+0x18a>
    8000067a:	0b879363          	bne	a5,s8,80000720 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	addi	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4605                	li	a2,1
    8000068c:	45a9                	li	a1,10
    8000068e:	4388                	lw	a0,0(a5)
    80000690:	00000097          	auipc	ra,0x0
    80000694:	e0c080e7          	jalr	-500(ra) # 8000049c <printint>
      break;
    80000698:	b771                	j	80000624 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000069a:	f8843783          	ld	a5,-120(s0)
    8000069e:	00878713          	addi	a4,a5,8
    800006a2:	f8e43423          	sd	a4,-120(s0)
    800006a6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006aa:	03000513          	li	a0,48
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	bce080e7          	jalr	-1074(ra) # 8000027c <consputc>
  consputc('x');
    800006b6:	07800513          	li	a0,120
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	bc2080e7          	jalr	-1086(ra) # 8000027c <consputc>
    800006c2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c4:	03c95793          	srli	a5,s2,0x3c
    800006c8:	97da                	add	a5,a5,s6
    800006ca:	0007c503          	lbu	a0,0(a5)
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	bae080e7          	jalr	-1106(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d6:	0912                	slli	s2,s2,0x4
    800006d8:	34fd                	addiw	s1,s1,-1
    800006da:	f4ed                	bnez	s1,800006c4 <printf+0x13a>
    800006dc:	b7a1                	j	80000624 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006de:	f8843783          	ld	a5,-120(s0)
    800006e2:	00878713          	addi	a4,a5,8
    800006e6:	f8e43423          	sd	a4,-120(s0)
    800006ea:	6384                	ld	s1,0(a5)
    800006ec:	cc89                	beqz	s1,80000706 <printf+0x17c>
      for(; *s; s++)
    800006ee:	0004c503          	lbu	a0,0(s1)
    800006f2:	d90d                	beqz	a0,80000624 <printf+0x9a>
        consputc(*s);
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	b88080e7          	jalr	-1144(ra) # 8000027c <consputc>
      for(; *s; s++)
    800006fc:	0485                	addi	s1,s1,1
    800006fe:	0004c503          	lbu	a0,0(s1)
    80000702:	f96d                	bnez	a0,800006f4 <printf+0x16a>
    80000704:	b705                	j	80000624 <printf+0x9a>
        s = "(null)";
    80000706:	00008497          	auipc	s1,0x8
    8000070a:	91a48493          	addi	s1,s1,-1766 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070e:	02800513          	li	a0,40
    80000712:	b7cd                	j	800006f4 <printf+0x16a>
      consputc('%');
    80000714:	8556                	mv	a0,s5
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b66080e7          	jalr	-1178(ra) # 8000027c <consputc>
      break;
    8000071e:	b719                	j	80000624 <printf+0x9a>
      consputc('%');
    80000720:	8556                	mv	a0,s5
    80000722:	00000097          	auipc	ra,0x0
    80000726:	b5a080e7          	jalr	-1190(ra) # 8000027c <consputc>
      consputc(c);
    8000072a:	8526                	mv	a0,s1
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	b50080e7          	jalr	-1200(ra) # 8000027c <consputc>
      break;
    80000734:	bdc5                	j	80000624 <printf+0x9a>
  if(locking)
    80000736:	020d9163          	bnez	s11,80000758 <printf+0x1ce>
}
    8000073a:	70e6                	ld	ra,120(sp)
    8000073c:	7446                	ld	s0,112(sp)
    8000073e:	74a6                	ld	s1,104(sp)
    80000740:	7906                	ld	s2,96(sp)
    80000742:	69e6                	ld	s3,88(sp)
    80000744:	6a46                	ld	s4,80(sp)
    80000746:	6aa6                	ld	s5,72(sp)
    80000748:	6b06                	ld	s6,64(sp)
    8000074a:	7be2                	ld	s7,56(sp)
    8000074c:	7c42                	ld	s8,48(sp)
    8000074e:	7ca2                	ld	s9,40(sp)
    80000750:	7d02                	ld	s10,32(sp)
    80000752:	6de2                	ld	s11,24(sp)
    80000754:	6129                	addi	sp,sp,192
    80000756:	8082                	ret
    release(&pr.lock);
    80000758:	00010517          	auipc	a0,0x10
    8000075c:	3c050513          	addi	a0,a0,960 # 80010b18 <pr>
    80000760:	00000097          	auipc	ra,0x0
    80000764:	69e080e7          	jalr	1694(ra) # 80000dfe <release>
}
    80000768:	bfc9                	j	8000073a <printf+0x1b0>

000000008000076a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000076a:	1101                	addi	sp,sp,-32
    8000076c:	ec06                	sd	ra,24(sp)
    8000076e:	e822                	sd	s0,16(sp)
    80000770:	e426                	sd	s1,8(sp)
    80000772:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000774:	00010497          	auipc	s1,0x10
    80000778:	3a448493          	addi	s1,s1,932 # 80010b18 <pr>
    8000077c:	00008597          	auipc	a1,0x8
    80000780:	8bc58593          	addi	a1,a1,-1860 # 80008038 <etext+0x38>
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	534080e7          	jalr	1332(ra) # 80000cba <initlock>
  pr.locking = 1;
    8000078e:	4785                	li	a5,1
    80000790:	cc9c                	sw	a5,24(s1)
}
    80000792:	60e2                	ld	ra,24(sp)
    80000794:	6442                	ld	s0,16(sp)
    80000796:	64a2                	ld	s1,8(sp)
    80000798:	6105                	addi	sp,sp,32
    8000079a:	8082                	ret

000000008000079c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079c:	1141                	addi	sp,sp,-16
    8000079e:	e406                	sd	ra,8(sp)
    800007a0:	e022                	sd	s0,0(sp)
    800007a2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a4:	100007b7          	lui	a5,0x10000
    800007a8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ac:	f8000713          	li	a4,-128
    800007b0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b4:	470d                	li	a4,3
    800007b6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007ba:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007be:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c2:	469d                	li	a3,7
    800007c4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007cc:	00008597          	auipc	a1,0x8
    800007d0:	88c58593          	addi	a1,a1,-1908 # 80008058 <digits+0x18>
    800007d4:	00010517          	auipc	a0,0x10
    800007d8:	36450513          	addi	a0,a0,868 # 80010b38 <uart_tx_lock>
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	4de080e7          	jalr	1246(ra) # 80000cba <initlock>
}
    800007e4:	60a2                	ld	ra,8(sp)
    800007e6:	6402                	ld	s0,0(sp)
    800007e8:	0141                	addi	sp,sp,16
    800007ea:	8082                	ret

00000000800007ec <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ec:	1101                	addi	sp,sp,-32
    800007ee:	ec06                	sd	ra,24(sp)
    800007f0:	e822                	sd	s0,16(sp)
    800007f2:	e426                	sd	s1,8(sp)
    800007f4:	1000                	addi	s0,sp,32
    800007f6:	84aa                	mv	s1,a0
  push_off();
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	506080e7          	jalr	1286(ra) # 80000cfe <push_off>

  if(panicked){
    80000800:	00008797          	auipc	a5,0x8
    80000804:	0f07a783          	lw	a5,240(a5) # 800088f0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000808:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080c:	c391                	beqz	a5,80000810 <uartputc_sync+0x24>
    for(;;)
    8000080e:	a001                	j	8000080e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000810:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000814:	0207f793          	andi	a5,a5,32
    80000818:	dfe5                	beqz	a5,80000810 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000081a:	0ff4f513          	zext.b	a0,s1
    8000081e:	100007b7          	lui	a5,0x10000
    80000822:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	578080e7          	jalr	1400(ra) # 80000d9e <pop_off>
}
    8000082e:	60e2                	ld	ra,24(sp)
    80000830:	6442                	ld	s0,16(sp)
    80000832:	64a2                	ld	s1,8(sp)
    80000834:	6105                	addi	sp,sp,32
    80000836:	8082                	ret

0000000080000838 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000838:	00008797          	auipc	a5,0x8
    8000083c:	0c07b783          	ld	a5,192(a5) # 800088f8 <uart_tx_r>
    80000840:	00008717          	auipc	a4,0x8
    80000844:	0c073703          	ld	a4,192(a4) # 80008900 <uart_tx_w>
    80000848:	06f70a63          	beq	a4,a5,800008bc <uartstart+0x84>
{
    8000084c:	7139                	addi	sp,sp,-64
    8000084e:	fc06                	sd	ra,56(sp)
    80000850:	f822                	sd	s0,48(sp)
    80000852:	f426                	sd	s1,40(sp)
    80000854:	f04a                	sd	s2,32(sp)
    80000856:	ec4e                	sd	s3,24(sp)
    80000858:	e852                	sd	s4,16(sp)
    8000085a:	e456                	sd	s5,8(sp)
    8000085c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000862:	00010a17          	auipc	s4,0x10
    80000866:	2d6a0a13          	addi	s4,s4,726 # 80010b38 <uart_tx_lock>
    uart_tx_r += 1;
    8000086a:	00008497          	auipc	s1,0x8
    8000086e:	08e48493          	addi	s1,s1,142 # 800088f8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000872:	00008997          	auipc	s3,0x8
    80000876:	08e98993          	addi	s3,s3,142 # 80008900 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000087a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087e:	02077713          	andi	a4,a4,32
    80000882:	c705                	beqz	a4,800008aa <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000884:	01f7f713          	andi	a4,a5,31
    80000888:	9752                	add	a4,a4,s4
    8000088a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088e:	0785                	addi	a5,a5,1
    80000890:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000892:	8526                	mv	a0,s1
    80000894:	00002097          	auipc	ra,0x2
    80000898:	bc8080e7          	jalr	-1080(ra) # 8000245c <wakeup>
    
    WriteReg(THR, c);
    8000089c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008a0:	609c                	ld	a5,0(s1)
    800008a2:	0009b703          	ld	a4,0(s3)
    800008a6:	fcf71ae3          	bne	a4,a5,8000087a <uartstart+0x42>
  }
}
    800008aa:	70e2                	ld	ra,56(sp)
    800008ac:	7442                	ld	s0,48(sp)
    800008ae:	74a2                	ld	s1,40(sp)
    800008b0:	7902                	ld	s2,32(sp)
    800008b2:	69e2                	ld	s3,24(sp)
    800008b4:	6a42                	ld	s4,16(sp)
    800008b6:	6aa2                	ld	s5,8(sp)
    800008b8:	6121                	addi	sp,sp,64
    800008ba:	8082                	ret
    800008bc:	8082                	ret

00000000800008be <uartputc>:
{
    800008be:	7179                	addi	sp,sp,-48
    800008c0:	f406                	sd	ra,40(sp)
    800008c2:	f022                	sd	s0,32(sp)
    800008c4:	ec26                	sd	s1,24(sp)
    800008c6:	e84a                	sd	s2,16(sp)
    800008c8:	e44e                	sd	s3,8(sp)
    800008ca:	e052                	sd	s4,0(sp)
    800008cc:	1800                	addi	s0,sp,48
    800008ce:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008d0:	00010517          	auipc	a0,0x10
    800008d4:	26850513          	addi	a0,a0,616 # 80010b38 <uart_tx_lock>
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	472080e7          	jalr	1138(ra) # 80000d4a <acquire>
  if(panicked){
    800008e0:	00008797          	auipc	a5,0x8
    800008e4:	0107a783          	lw	a5,16(a5) # 800088f0 <panicked>
    800008e8:	e7c9                	bnez	a5,80000972 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008ea:	00008717          	auipc	a4,0x8
    800008ee:	01673703          	ld	a4,22(a4) # 80008900 <uart_tx_w>
    800008f2:	00008797          	auipc	a5,0x8
    800008f6:	0067b783          	ld	a5,6(a5) # 800088f8 <uart_tx_r>
    800008fa:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fe:	00010997          	auipc	s3,0x10
    80000902:	23a98993          	addi	s3,s3,570 # 80010b38 <uart_tx_lock>
    80000906:	00008497          	auipc	s1,0x8
    8000090a:	ff248493          	addi	s1,s1,-14 # 800088f8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090e:	00008917          	auipc	s2,0x8
    80000912:	ff290913          	addi	s2,s2,-14 # 80008900 <uart_tx_w>
    80000916:	00e79f63          	bne	a5,a4,80000934 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000091a:	85ce                	mv	a1,s3
    8000091c:	8526                	mv	a0,s1
    8000091e:	00002097          	auipc	ra,0x2
    80000922:	ada080e7          	jalr	-1318(ra) # 800023f8 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000926:	00093703          	ld	a4,0(s2)
    8000092a:	609c                	ld	a5,0(s1)
    8000092c:	02078793          	addi	a5,a5,32
    80000930:	fee785e3          	beq	a5,a4,8000091a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000934:	00010497          	auipc	s1,0x10
    80000938:	20448493          	addi	s1,s1,516 # 80010b38 <uart_tx_lock>
    8000093c:	01f77793          	andi	a5,a4,31
    80000940:	97a6                	add	a5,a5,s1
    80000942:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000946:	0705                	addi	a4,a4,1
    80000948:	00008797          	auipc	a5,0x8
    8000094c:	fae7bc23          	sd	a4,-72(a5) # 80008900 <uart_tx_w>
  uartstart();
    80000950:	00000097          	auipc	ra,0x0
    80000954:	ee8080e7          	jalr	-280(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    80000958:	8526                	mv	a0,s1
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	4a4080e7          	jalr	1188(ra) # 80000dfe <release>
}
    80000962:	70a2                	ld	ra,40(sp)
    80000964:	7402                	ld	s0,32(sp)
    80000966:	64e2                	ld	s1,24(sp)
    80000968:	6942                	ld	s2,16(sp)
    8000096a:	69a2                	ld	s3,8(sp)
    8000096c:	6a02                	ld	s4,0(sp)
    8000096e:	6145                	addi	sp,sp,48
    80000970:	8082                	ret
    for(;;)
    80000972:	a001                	j	80000972 <uartputc+0xb4>

0000000080000974 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000974:	1141                	addi	sp,sp,-16
    80000976:	e422                	sd	s0,8(sp)
    80000978:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000097a:	100007b7          	lui	a5,0x10000
    8000097e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000982:	8b85                	andi	a5,a5,1
    80000984:	cb81                	beqz	a5,80000994 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000986:	100007b7          	lui	a5,0x10000
    8000098a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000098e:	6422                	ld	s0,8(sp)
    80000990:	0141                	addi	sp,sp,16
    80000992:	8082                	ret
    return -1;
    80000994:	557d                	li	a0,-1
    80000996:	bfe5                	j	8000098e <uartgetc+0x1a>

0000000080000998 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000998:	1101                	addi	sp,sp,-32
    8000099a:	ec06                	sd	ra,24(sp)
    8000099c:	e822                	sd	s0,16(sp)
    8000099e:	e426                	sd	s1,8(sp)
    800009a0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a2:	54fd                	li	s1,-1
    800009a4:	a029                	j	800009ae <uartintr+0x16>
      break;
    consoleintr(c);
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	918080e7          	jalr	-1768(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	fc6080e7          	jalr	-58(ra) # 80000974 <uartgetc>
    if(c == -1)
    800009b6:	fe9518e3          	bne	a0,s1,800009a6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009ba:	00010497          	auipc	s1,0x10
    800009be:	17e48493          	addi	s1,s1,382 # 80010b38 <uart_tx_lock>
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	386080e7          	jalr	902(ra) # 80000d4a <acquire>
  uartstart();
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	e6c080e7          	jalr	-404(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	428080e7          	jalr	1064(ra) # 80000dfe <release>
}
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret

00000000800009e8 <decrease_pgreference>:
  }return (void*)r;
}
/////////////////////added for cow

int decrease_pgreference(void *pa)
{
    800009e8:	1101                	addi	sp,sp,-32
    800009ea:	ec06                	sd	ra,24(sp)
    800009ec:	e822                	sd	s0,16(sp)
    800009ee:	e426                	sd	s1,8(sp)
    800009f0:	1000                	addi	s0,sp,32
    800009f2:	84aa                	mv	s1,a0
  acquire(&page_ref.lock);
    800009f4:	00010517          	auipc	a0,0x10
    800009f8:	19c50513          	addi	a0,a0,412 # 80010b90 <page_ref>
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	34e080e7          	jalr	846(ra) # 80000d4a <acquire>
  if (page_ref.count[(uint64)pa >> 12] <= 0)
    80000a04:	00c4d513          	srli	a0,s1,0xc
    80000a08:	00450713          	addi	a4,a0,4
    80000a0c:	070a                	slli	a4,a4,0x2
    80000a0e:	00010797          	auipc	a5,0x10
    80000a12:	18278793          	addi	a5,a5,386 # 80010b90 <page_ref>
    80000a16:	97ba                	add	a5,a5,a4
    80000a18:	479c                	lw	a5,8(a5)
    80000a1a:	02f05d63          	blez	a5,80000a54 <decrease_pgreference+0x6c>
  {
    panic("decrease_pgreference");
  }
  page_ref.count[(uint64)pa >> 12]--;
    80000a1e:	37fd                	addiw	a5,a5,-1
    80000a20:	0007869b          	sext.w	a3,a5
    80000a24:	0511                	addi	a0,a0,4
    80000a26:	050a                	slli	a0,a0,0x2
    80000a28:	00010717          	auipc	a4,0x10
    80000a2c:	16870713          	addi	a4,a4,360 # 80010b90 <page_ref>
    80000a30:	972a                	add	a4,a4,a0
    80000a32:	c71c                	sw	a5,8(a4)
  if (page_ref.count[(uint64)pa >> 12] > 0)
    80000a34:	02d04863          	bgtz	a3,80000a64 <decrease_pgreference+0x7c>
  {
    release(&page_ref.lock);
    return 0;
  }
  release(&page_ref.lock);
    80000a38:	00010517          	auipc	a0,0x10
    80000a3c:	15850513          	addi	a0,a0,344 # 80010b90 <page_ref>
    80000a40:	00000097          	auipc	ra,0x0
    80000a44:	3be080e7          	jalr	958(ra) # 80000dfe <release>
  return 1;
    80000a48:	4505                	li	a0,1
}
    80000a4a:	60e2                	ld	ra,24(sp)
    80000a4c:	6442                	ld	s0,16(sp)
    80000a4e:	64a2                	ld	s1,8(sp)
    80000a50:	6105                	addi	sp,sp,32
    80000a52:	8082                	ret
    panic("decrease_pgreference");
    80000a54:	00007517          	auipc	a0,0x7
    80000a58:	60c50513          	addi	a0,a0,1548 # 80008060 <digits+0x20>
    80000a5c:	00000097          	auipc	ra,0x0
    80000a60:	ae4080e7          	jalr	-1308(ra) # 80000540 <panic>
    release(&page_ref.lock);
    80000a64:	00010517          	auipc	a0,0x10
    80000a68:	12c50513          	addi	a0,a0,300 # 80010b90 <page_ref>
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	392080e7          	jalr	914(ra) # 80000dfe <release>
    return 0;
    80000a74:	4501                	li	a0,0
    80000a76:	bfd1                	j	80000a4a <decrease_pgreference+0x62>

0000000080000a78 <kfree>:
{
    80000a78:	1101                	addi	sp,sp,-32
    80000a7a:	ec06                	sd	ra,24(sp)
    80000a7c:	e822                	sd	s0,16(sp)
    80000a7e:	e426                	sd	s1,8(sp)
    80000a80:	e04a                	sd	s2,0(sp)
    80000a82:	1000                	addi	s0,sp,32
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a84:	03451793          	slli	a5,a0,0x34
    80000a88:	e79d                	bnez	a5,80000ab6 <kfree+0x3e>
    80000a8a:	84aa                	mv	s1,a0
    80000a8c:	00242797          	auipc	a5,0x242
    80000a90:	d2c78793          	addi	a5,a5,-724 # 802427b8 <end>
    80000a94:	02f56163          	bltu	a0,a5,80000ab6 <kfree+0x3e>
    80000a98:	47c5                	li	a5,17
    80000a9a:	07ee                	slli	a5,a5,0x1b
    80000a9c:	00f57d63          	bgeu	a0,a5,80000ab6 <kfree+0x3e>
  if (!decrease_pgreference(pa))  //added for cow
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	f48080e7          	jalr	-184(ra) # 800009e8 <decrease_pgreference>
    80000aa8:	ed19                	bnez	a0,80000ac6 <kfree+0x4e>
}
    80000aaa:	60e2                	ld	ra,24(sp)
    80000aac:	6442                	ld	s0,16(sp)
    80000aae:	64a2                	ld	s1,8(sp)
    80000ab0:	6902                	ld	s2,0(sp)
    80000ab2:	6105                	addi	sp,sp,32
    80000ab4:	8082                	ret
    panic("kfree");
    80000ab6:	00007517          	auipc	a0,0x7
    80000aba:	5c250513          	addi	a0,a0,1474 # 80008078 <digits+0x38>
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	a82080e7          	jalr	-1406(ra) # 80000540 <panic>
  memset(pa, 1, PGSIZE);
    80000ac6:	6605                	lui	a2,0x1
    80000ac8:	4585                	li	a1,1
    80000aca:	8526                	mv	a0,s1
    80000acc:	00000097          	auipc	ra,0x0
    80000ad0:	37a080e7          	jalr	890(ra) # 80000e46 <memset>
  acquire(&kmem.lock);
    80000ad4:	00010917          	auipc	s2,0x10
    80000ad8:	09c90913          	addi	s2,s2,156 # 80010b70 <kmem>
    80000adc:	854a                	mv	a0,s2
    80000ade:	00000097          	auipc	ra,0x0
    80000ae2:	26c080e7          	jalr	620(ra) # 80000d4a <acquire>
  r->next = kmem.freelist;
    80000ae6:	01893783          	ld	a5,24(s2)
    80000aea:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aec:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000af0:	854a                	mv	a0,s2
    80000af2:	00000097          	auipc	ra,0x0
    80000af6:	30c080e7          	jalr	780(ra) # 80000dfe <release>
    80000afa:	bf45                	j	80000aaa <kfree+0x32>

0000000080000afc <increase_pgreference>:

void increase_pgreference(void *pa)
{
    80000afc:	1101                	addi	sp,sp,-32
    80000afe:	ec06                	sd	ra,24(sp)
    80000b00:	e822                	sd	s0,16(sp)
    80000b02:	e426                	sd	s1,8(sp)
    80000b04:	1000                	addi	s0,sp,32
    80000b06:	84aa                	mv	s1,a0
  acquire(&page_ref.lock);
    80000b08:	00010517          	auipc	a0,0x10
    80000b0c:	08850513          	addi	a0,a0,136 # 80010b90 <page_ref>
    80000b10:	00000097          	auipc	ra,0x0
    80000b14:	23a080e7          	jalr	570(ra) # 80000d4a <acquire>
  if (page_ref.count[(uint64)pa >> 12] < 0)
    80000b18:	00c4d793          	srli	a5,s1,0xc
    80000b1c:	00478693          	addi	a3,a5,4
    80000b20:	068a                	slli	a3,a3,0x2
    80000b22:	00010717          	auipc	a4,0x10
    80000b26:	06e70713          	addi	a4,a4,110 # 80010b90 <page_ref>
    80000b2a:	9736                	add	a4,a4,a3
    80000b2c:	4718                	lw	a4,8(a4)
    80000b2e:	02074463          	bltz	a4,80000b56 <increase_pgreference+0x5a>
  {
    panic("increase_pgreference");
  }
  page_ref.count[(uint64)pa >> 12]++;
    80000b32:	00010517          	auipc	a0,0x10
    80000b36:	05e50513          	addi	a0,a0,94 # 80010b90 <page_ref>
    80000b3a:	0791                	addi	a5,a5,4
    80000b3c:	078a                	slli	a5,a5,0x2
    80000b3e:	97aa                	add	a5,a5,a0
    80000b40:	2705                	addiw	a4,a4,1
    80000b42:	c798                	sw	a4,8(a5)
  release(&page_ref.lock);
    80000b44:	00000097          	auipc	ra,0x0
    80000b48:	2ba080e7          	jalr	698(ra) # 80000dfe <release>
}
    80000b4c:	60e2                	ld	ra,24(sp)
    80000b4e:	6442                	ld	s0,16(sp)
    80000b50:	64a2                	ld	s1,8(sp)
    80000b52:	6105                	addi	sp,sp,32
    80000b54:	8082                	ret
    panic("increase_pgreference");
    80000b56:	00007517          	auipc	a0,0x7
    80000b5a:	52a50513          	addi	a0,a0,1322 # 80008080 <digits+0x40>
    80000b5e:	00000097          	auipc	ra,0x0
    80000b62:	9e2080e7          	jalr	-1566(ra) # 80000540 <panic>

0000000080000b66 <freerange>:
{
    80000b66:	7139                	addi	sp,sp,-64
    80000b68:	fc06                	sd	ra,56(sp)
    80000b6a:	f822                	sd	s0,48(sp)
    80000b6c:	f426                	sd	s1,40(sp)
    80000b6e:	f04a                	sd	s2,32(sp)
    80000b70:	ec4e                	sd	s3,24(sp)
    80000b72:	e852                	sd	s4,16(sp)
    80000b74:	e456                	sd	s5,8(sp)
    80000b76:	0080                	addi	s0,sp,64
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b78:	6785                	lui	a5,0x1
    80000b7a:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b7e:	00e504b3          	add	s1,a0,a4
    80000b82:	777d                	lui	a4,0xfffff
    80000b84:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000b86:	94be                	add	s1,s1,a5
    80000b88:	0295e463          	bltu	a1,s1,80000bb0 <freerange+0x4a>
    80000b8c:	89ae                	mv	s3,a1
    80000b8e:	7afd                	lui	s5,0xfffff
    80000b90:	6a05                	lui	s4,0x1
    80000b92:	01548933          	add	s2,s1,s5
    increase_pgreference(p);
    80000b96:	854a                	mv	a0,s2
    80000b98:	00000097          	auipc	ra,0x0
    80000b9c:	f64080e7          	jalr	-156(ra) # 80000afc <increase_pgreference>
    kfree(p);
    80000ba0:	854a                	mv	a0,s2
    80000ba2:	00000097          	auipc	ra,0x0
    80000ba6:	ed6080e7          	jalr	-298(ra) # 80000a78 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000baa:	94d2                	add	s1,s1,s4
    80000bac:	fe99f3e3          	bgeu	s3,s1,80000b92 <freerange+0x2c>
}
    80000bb0:	70e2                	ld	ra,56(sp)
    80000bb2:	7442                	ld	s0,48(sp)
    80000bb4:	74a2                	ld	s1,40(sp)
    80000bb6:	7902                	ld	s2,32(sp)
    80000bb8:	69e2                	ld	s3,24(sp)
    80000bba:	6a42                	ld	s4,16(sp)
    80000bbc:	6aa2                	ld	s5,8(sp)
    80000bbe:	6121                	addi	sp,sp,64
    80000bc0:	8082                	ret

0000000080000bc2 <kinit>:
{
    80000bc2:	1141                	addi	sp,sp,-16
    80000bc4:	e406                	sd	ra,8(sp)
    80000bc6:	e022                	sd	s0,0(sp)
    80000bc8:	0800                	addi	s0,sp,16
  initlock(&page_ref.lock, "page_ref");
    80000bca:	00007597          	auipc	a1,0x7
    80000bce:	4ce58593          	addi	a1,a1,1230 # 80008098 <digits+0x58>
    80000bd2:	00010517          	auipc	a0,0x10
    80000bd6:	fbe50513          	addi	a0,a0,-66 # 80010b90 <page_ref>
    80000bda:	00000097          	auipc	ra,0x0
    80000bde:	0e0080e7          	jalr	224(ra) # 80000cba <initlock>
  acquire(&page_ref.lock);
    80000be2:	00010517          	auipc	a0,0x10
    80000be6:	fae50513          	addi	a0,a0,-82 # 80010b90 <page_ref>
    80000bea:	00000097          	auipc	ra,0x0
    80000bee:	160080e7          	jalr	352(ra) # 80000d4a <acquire>
  for (int i = 0; i < (PGROUNDUP(PHYSTOP) >> 12); ++i)
    80000bf2:	00010797          	auipc	a5,0x10
    80000bf6:	fb678793          	addi	a5,a5,-74 # 80010ba8 <page_ref+0x18>
    80000bfa:	00230717          	auipc	a4,0x230
    80000bfe:	fae70713          	addi	a4,a4,-82 # 80230ba8 <pid_lock>
    page_ref.count[i] = 0;
    80000c02:	0007a023          	sw	zero,0(a5)
  for (int i = 0; i < (PGROUNDUP(PHYSTOP) >> 12); ++i)
    80000c06:	0791                	addi	a5,a5,4
    80000c08:	fee79de3          	bne	a5,a4,80000c02 <kinit+0x40>
  release(&page_ref.lock);
    80000c0c:	00010517          	auipc	a0,0x10
    80000c10:	f8450513          	addi	a0,a0,-124 # 80010b90 <page_ref>
    80000c14:	00000097          	auipc	ra,0x0
    80000c18:	1ea080e7          	jalr	490(ra) # 80000dfe <release>
  initlock(&kmem.lock, "kmem");
    80000c1c:	00007597          	auipc	a1,0x7
    80000c20:	48c58593          	addi	a1,a1,1164 # 800080a8 <digits+0x68>
    80000c24:	00010517          	auipc	a0,0x10
    80000c28:	f4c50513          	addi	a0,a0,-180 # 80010b70 <kmem>
    80000c2c:	00000097          	auipc	ra,0x0
    80000c30:	08e080e7          	jalr	142(ra) # 80000cba <initlock>
  freerange(end, (void*)PHYSTOP);
    80000c34:	45c5                	li	a1,17
    80000c36:	05ee                	slli	a1,a1,0x1b
    80000c38:	00242517          	auipc	a0,0x242
    80000c3c:	b8050513          	addi	a0,a0,-1152 # 802427b8 <end>
    80000c40:	00000097          	auipc	ra,0x0
    80000c44:	f26080e7          	jalr	-218(ra) # 80000b66 <freerange>
}
    80000c48:	60a2                	ld	ra,8(sp)
    80000c4a:	6402                	ld	s0,0(sp)
    80000c4c:	0141                	addi	sp,sp,16
    80000c4e:	8082                	ret

0000000080000c50 <kalloc>:
{
    80000c50:	1101                	addi	sp,sp,-32
    80000c52:	ec06                	sd	ra,24(sp)
    80000c54:	e822                	sd	s0,16(sp)
    80000c56:	e426                	sd	s1,8(sp)
    80000c58:	1000                	addi	s0,sp,32
  acquire(&kmem.lock);
    80000c5a:	00010497          	auipc	s1,0x10
    80000c5e:	f1648493          	addi	s1,s1,-234 # 80010b70 <kmem>
    80000c62:	8526                	mv	a0,s1
    80000c64:	00000097          	auipc	ra,0x0
    80000c68:	0e6080e7          	jalr	230(ra) # 80000d4a <acquire>
  r = kmem.freelist;
    80000c6c:	6c84                	ld	s1,24(s1)
  if(r)
    80000c6e:	cc8d                	beqz	s1,80000ca8 <kalloc+0x58>
    kmem.freelist = r->next;
    80000c70:	609c                	ld	a5,0(s1)
    80000c72:	00010517          	auipc	a0,0x10
    80000c76:	efe50513          	addi	a0,a0,-258 # 80010b70 <kmem>
    80000c7a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	182080e7          	jalr	386(ra) # 80000dfe <release>
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000c84:	6605                	lui	a2,0x1
    80000c86:	4595                	li	a1,5
    80000c88:	8526                	mv	a0,s1
    80000c8a:	00000097          	auipc	ra,0x0
    80000c8e:	1bc080e7          	jalr	444(ra) # 80000e46 <memset>
    increase_pgreference((void *)r);
    80000c92:	8526                	mv	a0,s1
    80000c94:	00000097          	auipc	ra,0x0
    80000c98:	e68080e7          	jalr	-408(ra) # 80000afc <increase_pgreference>
}
    80000c9c:	8526                	mv	a0,s1
    80000c9e:	60e2                	ld	ra,24(sp)
    80000ca0:	6442                	ld	s0,16(sp)
    80000ca2:	64a2                	ld	s1,8(sp)
    80000ca4:	6105                	addi	sp,sp,32
    80000ca6:	8082                	ret
  release(&kmem.lock);
    80000ca8:	00010517          	auipc	a0,0x10
    80000cac:	ec850513          	addi	a0,a0,-312 # 80010b70 <kmem>
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	14e080e7          	jalr	334(ra) # 80000dfe <release>
  if(r){
    80000cb8:	b7d5                	j	80000c9c <kalloc+0x4c>

0000000080000cba <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000cba:	1141                	addi	sp,sp,-16
    80000cbc:	e422                	sd	s0,8(sp)
    80000cbe:	0800                	addi	s0,sp,16
  lk->name = name;
    80000cc0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000cc2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000cc6:	00053823          	sd	zero,16(a0)
}
    80000cca:	6422                	ld	s0,8(sp)
    80000ccc:	0141                	addi	sp,sp,16
    80000cce:	8082                	ret

0000000080000cd0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000cd0:	411c                	lw	a5,0(a0)
    80000cd2:	e399                	bnez	a5,80000cd8 <holding+0x8>
    80000cd4:	4501                	li	a0,0
  return r;
}
    80000cd6:	8082                	ret
{
    80000cd8:	1101                	addi	sp,sp,-32
    80000cda:	ec06                	sd	ra,24(sp)
    80000cdc:	e822                	sd	s0,16(sp)
    80000cde:	e426                	sd	s1,8(sp)
    80000ce0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ce2:	6904                	ld	s1,16(a0)
    80000ce4:	00001097          	auipc	ra,0x1
    80000ce8:	f02080e7          	jalr	-254(ra) # 80001be6 <mycpu>
    80000cec:	40a48533          	sub	a0,s1,a0
    80000cf0:	00153513          	seqz	a0,a0
}
    80000cf4:	60e2                	ld	ra,24(sp)
    80000cf6:	6442                	ld	s0,16(sp)
    80000cf8:	64a2                	ld	s1,8(sp)
    80000cfa:	6105                	addi	sp,sp,32
    80000cfc:	8082                	ret

0000000080000cfe <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000cfe:	1101                	addi	sp,sp,-32
    80000d00:	ec06                	sd	ra,24(sp)
    80000d02:	e822                	sd	s0,16(sp)
    80000d04:	e426                	sd	s1,8(sp)
    80000d06:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d08:	100024f3          	csrr	s1,sstatus
    80000d0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000d10:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d12:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000d16:	00001097          	auipc	ra,0x1
    80000d1a:	ed0080e7          	jalr	-304(ra) # 80001be6 <mycpu>
    80000d1e:	5d3c                	lw	a5,120(a0)
    80000d20:	cf89                	beqz	a5,80000d3a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d22:	00001097          	auipc	ra,0x1
    80000d26:	ec4080e7          	jalr	-316(ra) # 80001be6 <mycpu>
    80000d2a:	5d3c                	lw	a5,120(a0)
    80000d2c:	2785                	addiw	a5,a5,1
    80000d2e:	dd3c                	sw	a5,120(a0)
}
    80000d30:	60e2                	ld	ra,24(sp)
    80000d32:	6442                	ld	s0,16(sp)
    80000d34:	64a2                	ld	s1,8(sp)
    80000d36:	6105                	addi	sp,sp,32
    80000d38:	8082                	ret
    mycpu()->intena = old;
    80000d3a:	00001097          	auipc	ra,0x1
    80000d3e:	eac080e7          	jalr	-340(ra) # 80001be6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000d42:	8085                	srli	s1,s1,0x1
    80000d44:	8885                	andi	s1,s1,1
    80000d46:	dd64                	sw	s1,124(a0)
    80000d48:	bfe9                	j	80000d22 <push_off+0x24>

0000000080000d4a <acquire>:
{
    80000d4a:	1101                	addi	sp,sp,-32
    80000d4c:	ec06                	sd	ra,24(sp)
    80000d4e:	e822                	sd	s0,16(sp)
    80000d50:	e426                	sd	s1,8(sp)
    80000d52:	1000                	addi	s0,sp,32
    80000d54:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d56:	00000097          	auipc	ra,0x0
    80000d5a:	fa8080e7          	jalr	-88(ra) # 80000cfe <push_off>
  if(holding(lk))
    80000d5e:	8526                	mv	a0,s1
    80000d60:	00000097          	auipc	ra,0x0
    80000d64:	f70080e7          	jalr	-144(ra) # 80000cd0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d68:	4705                	li	a4,1
  if(holding(lk))
    80000d6a:	e115                	bnez	a0,80000d8e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d6c:	87ba                	mv	a5,a4
    80000d6e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d72:	2781                	sext.w	a5,a5
    80000d74:	ffe5                	bnez	a5,80000d6c <acquire+0x22>
  __sync_synchronize();
    80000d76:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000d7a:	00001097          	auipc	ra,0x1
    80000d7e:	e6c080e7          	jalr	-404(ra) # 80001be6 <mycpu>
    80000d82:	e888                	sd	a0,16(s1)
}
    80000d84:	60e2                	ld	ra,24(sp)
    80000d86:	6442                	ld	s0,16(sp)
    80000d88:	64a2                	ld	s1,8(sp)
    80000d8a:	6105                	addi	sp,sp,32
    80000d8c:	8082                	ret
    panic("acquire");
    80000d8e:	00007517          	auipc	a0,0x7
    80000d92:	32250513          	addi	a0,a0,802 # 800080b0 <digits+0x70>
    80000d96:	fffff097          	auipc	ra,0xfffff
    80000d9a:	7aa080e7          	jalr	1962(ra) # 80000540 <panic>

0000000080000d9e <pop_off>:

void
pop_off(void)
{
    80000d9e:	1141                	addi	sp,sp,-16
    80000da0:	e406                	sd	ra,8(sp)
    80000da2:	e022                	sd	s0,0(sp)
    80000da4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000da6:	00001097          	auipc	ra,0x1
    80000daa:	e40080e7          	jalr	-448(ra) # 80001be6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000dae:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000db2:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000db4:	e78d                	bnez	a5,80000dde <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000db6:	5d3c                	lw	a5,120(a0)
    80000db8:	02f05b63          	blez	a5,80000dee <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000dbc:	37fd                	addiw	a5,a5,-1
    80000dbe:	0007871b          	sext.w	a4,a5
    80000dc2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000dc4:	eb09                	bnez	a4,80000dd6 <pop_off+0x38>
    80000dc6:	5d7c                	lw	a5,124(a0)
    80000dc8:	c799                	beqz	a5,80000dd6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000dca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000dce:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000dd2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000dd6:	60a2                	ld	ra,8(sp)
    80000dd8:	6402                	ld	s0,0(sp)
    80000dda:	0141                	addi	sp,sp,16
    80000ddc:	8082                	ret
    panic("pop_off - interruptible");
    80000dde:	00007517          	auipc	a0,0x7
    80000de2:	2da50513          	addi	a0,a0,730 # 800080b8 <digits+0x78>
    80000de6:	fffff097          	auipc	ra,0xfffff
    80000dea:	75a080e7          	jalr	1882(ra) # 80000540 <panic>
    panic("pop_off");
    80000dee:	00007517          	auipc	a0,0x7
    80000df2:	2e250513          	addi	a0,a0,738 # 800080d0 <digits+0x90>
    80000df6:	fffff097          	auipc	ra,0xfffff
    80000dfa:	74a080e7          	jalr	1866(ra) # 80000540 <panic>

0000000080000dfe <release>:
{
    80000dfe:	1101                	addi	sp,sp,-32
    80000e00:	ec06                	sd	ra,24(sp)
    80000e02:	e822                	sd	s0,16(sp)
    80000e04:	e426                	sd	s1,8(sp)
    80000e06:	1000                	addi	s0,sp,32
    80000e08:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000e0a:	00000097          	auipc	ra,0x0
    80000e0e:	ec6080e7          	jalr	-314(ra) # 80000cd0 <holding>
    80000e12:	c115                	beqz	a0,80000e36 <release+0x38>
  lk->cpu = 0;
    80000e14:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000e18:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000e1c:	0f50000f          	fence	iorw,ow
    80000e20:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000e24:	00000097          	auipc	ra,0x0
    80000e28:	f7a080e7          	jalr	-134(ra) # 80000d9e <pop_off>
}
    80000e2c:	60e2                	ld	ra,24(sp)
    80000e2e:	6442                	ld	s0,16(sp)
    80000e30:	64a2                	ld	s1,8(sp)
    80000e32:	6105                	addi	sp,sp,32
    80000e34:	8082                	ret
    panic("release");
    80000e36:	00007517          	auipc	a0,0x7
    80000e3a:	2a250513          	addi	a0,a0,674 # 800080d8 <digits+0x98>
    80000e3e:	fffff097          	auipc	ra,0xfffff
    80000e42:	702080e7          	jalr	1794(ra) # 80000540 <panic>

0000000080000e46 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000e46:	1141                	addi	sp,sp,-16
    80000e48:	e422                	sd	s0,8(sp)
    80000e4a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e4c:	ca19                	beqz	a2,80000e62 <memset+0x1c>
    80000e4e:	87aa                	mv	a5,a0
    80000e50:	1602                	slli	a2,a2,0x20
    80000e52:	9201                	srli	a2,a2,0x20
    80000e54:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e58:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e5c:	0785                	addi	a5,a5,1
    80000e5e:	fee79de3          	bne	a5,a4,80000e58 <memset+0x12>
  }
  return dst;
}
    80000e62:	6422                	ld	s0,8(sp)
    80000e64:	0141                	addi	sp,sp,16
    80000e66:	8082                	ret

0000000080000e68 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e68:	1141                	addi	sp,sp,-16
    80000e6a:	e422                	sd	s0,8(sp)
    80000e6c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000e6e:	ca05                	beqz	a2,80000e9e <memcmp+0x36>
    80000e70:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000e74:	1682                	slli	a3,a3,0x20
    80000e76:	9281                	srli	a3,a3,0x20
    80000e78:	0685                	addi	a3,a3,1
    80000e7a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e7c:	00054783          	lbu	a5,0(a0)
    80000e80:	0005c703          	lbu	a4,0(a1)
    80000e84:	00e79863          	bne	a5,a4,80000e94 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e88:	0505                	addi	a0,a0,1
    80000e8a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e8c:	fed518e3          	bne	a0,a3,80000e7c <memcmp+0x14>
  }

  return 0;
    80000e90:	4501                	li	a0,0
    80000e92:	a019                	j	80000e98 <memcmp+0x30>
      return *s1 - *s2;
    80000e94:	40e7853b          	subw	a0,a5,a4
}
    80000e98:	6422                	ld	s0,8(sp)
    80000e9a:	0141                	addi	sp,sp,16
    80000e9c:	8082                	ret
  return 0;
    80000e9e:	4501                	li	a0,0
    80000ea0:	bfe5                	j	80000e98 <memcmp+0x30>

0000000080000ea2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000ea2:	1141                	addi	sp,sp,-16
    80000ea4:	e422                	sd	s0,8(sp)
    80000ea6:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000ea8:	c205                	beqz	a2,80000ec8 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000eaa:	02a5e263          	bltu	a1,a0,80000ece <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000eae:	1602                	slli	a2,a2,0x20
    80000eb0:	9201                	srli	a2,a2,0x20
    80000eb2:	00c587b3          	add	a5,a1,a2
{
    80000eb6:	872a                	mv	a4,a0
      *d++ = *s++;
    80000eb8:	0585                	addi	a1,a1,1
    80000eba:	0705                	addi	a4,a4,1
    80000ebc:	fff5c683          	lbu	a3,-1(a1)
    80000ec0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000ec4:	fef59ae3          	bne	a1,a5,80000eb8 <memmove+0x16>

  return dst;
}
    80000ec8:	6422                	ld	s0,8(sp)
    80000eca:	0141                	addi	sp,sp,16
    80000ecc:	8082                	ret
  if(s < d && s + n > d){
    80000ece:	02061693          	slli	a3,a2,0x20
    80000ed2:	9281                	srli	a3,a3,0x20
    80000ed4:	00d58733          	add	a4,a1,a3
    80000ed8:	fce57be3          	bgeu	a0,a4,80000eae <memmove+0xc>
    d += n;
    80000edc:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000ede:	fff6079b          	addiw	a5,a2,-1
    80000ee2:	1782                	slli	a5,a5,0x20
    80000ee4:	9381                	srli	a5,a5,0x20
    80000ee6:	fff7c793          	not	a5,a5
    80000eea:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000eec:	177d                	addi	a4,a4,-1
    80000eee:	16fd                	addi	a3,a3,-1
    80000ef0:	00074603          	lbu	a2,0(a4)
    80000ef4:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000ef8:	fee79ae3          	bne	a5,a4,80000eec <memmove+0x4a>
    80000efc:	b7f1                	j	80000ec8 <memmove+0x26>

0000000080000efe <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000efe:	1141                	addi	sp,sp,-16
    80000f00:	e406                	sd	ra,8(sp)
    80000f02:	e022                	sd	s0,0(sp)
    80000f04:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000f06:	00000097          	auipc	ra,0x0
    80000f0a:	f9c080e7          	jalr	-100(ra) # 80000ea2 <memmove>
}
    80000f0e:	60a2                	ld	ra,8(sp)
    80000f10:	6402                	ld	s0,0(sp)
    80000f12:	0141                	addi	sp,sp,16
    80000f14:	8082                	ret

0000000080000f16 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000f16:	1141                	addi	sp,sp,-16
    80000f18:	e422                	sd	s0,8(sp)
    80000f1a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000f1c:	ce11                	beqz	a2,80000f38 <strncmp+0x22>
    80000f1e:	00054783          	lbu	a5,0(a0)
    80000f22:	cf89                	beqz	a5,80000f3c <strncmp+0x26>
    80000f24:	0005c703          	lbu	a4,0(a1)
    80000f28:	00f71a63          	bne	a4,a5,80000f3c <strncmp+0x26>
    n--, p++, q++;
    80000f2c:	367d                	addiw	a2,a2,-1
    80000f2e:	0505                	addi	a0,a0,1
    80000f30:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000f32:	f675                	bnez	a2,80000f1e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000f34:	4501                	li	a0,0
    80000f36:	a809                	j	80000f48 <strncmp+0x32>
    80000f38:	4501                	li	a0,0
    80000f3a:	a039                	j	80000f48 <strncmp+0x32>
  if(n == 0)
    80000f3c:	ca09                	beqz	a2,80000f4e <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000f3e:	00054503          	lbu	a0,0(a0)
    80000f42:	0005c783          	lbu	a5,0(a1)
    80000f46:	9d1d                	subw	a0,a0,a5
}
    80000f48:	6422                	ld	s0,8(sp)
    80000f4a:	0141                	addi	sp,sp,16
    80000f4c:	8082                	ret
    return 0;
    80000f4e:	4501                	li	a0,0
    80000f50:	bfe5                	j	80000f48 <strncmp+0x32>

0000000080000f52 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000f52:	1141                	addi	sp,sp,-16
    80000f54:	e422                	sd	s0,8(sp)
    80000f56:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f58:	872a                	mv	a4,a0
    80000f5a:	8832                	mv	a6,a2
    80000f5c:	367d                	addiw	a2,a2,-1
    80000f5e:	01005963          	blez	a6,80000f70 <strncpy+0x1e>
    80000f62:	0705                	addi	a4,a4,1
    80000f64:	0005c783          	lbu	a5,0(a1)
    80000f68:	fef70fa3          	sb	a5,-1(a4)
    80000f6c:	0585                	addi	a1,a1,1
    80000f6e:	f7f5                	bnez	a5,80000f5a <strncpy+0x8>
    ;
  while(n-- > 0)
    80000f70:	86ba                	mv	a3,a4
    80000f72:	00c05c63          	blez	a2,80000f8a <strncpy+0x38>
    *s++ = 0;
    80000f76:	0685                	addi	a3,a3,1
    80000f78:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000f7c:	40d707bb          	subw	a5,a4,a3
    80000f80:	37fd                	addiw	a5,a5,-1
    80000f82:	010787bb          	addw	a5,a5,a6
    80000f86:	fef048e3          	bgtz	a5,80000f76 <strncpy+0x24>
  return os;
}
    80000f8a:	6422                	ld	s0,8(sp)
    80000f8c:	0141                	addi	sp,sp,16
    80000f8e:	8082                	ret

0000000080000f90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f90:	1141                	addi	sp,sp,-16
    80000f92:	e422                	sd	s0,8(sp)
    80000f94:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f96:	02c05363          	blez	a2,80000fbc <safestrcpy+0x2c>
    80000f9a:	fff6069b          	addiw	a3,a2,-1
    80000f9e:	1682                	slli	a3,a3,0x20
    80000fa0:	9281                	srli	a3,a3,0x20
    80000fa2:	96ae                	add	a3,a3,a1
    80000fa4:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000fa6:	00d58963          	beq	a1,a3,80000fb8 <safestrcpy+0x28>
    80000faa:	0585                	addi	a1,a1,1
    80000fac:	0785                	addi	a5,a5,1
    80000fae:	fff5c703          	lbu	a4,-1(a1)
    80000fb2:	fee78fa3          	sb	a4,-1(a5)
    80000fb6:	fb65                	bnez	a4,80000fa6 <safestrcpy+0x16>
    ;
  *s = 0;
    80000fb8:	00078023          	sb	zero,0(a5)
  return os;
}
    80000fbc:	6422                	ld	s0,8(sp)
    80000fbe:	0141                	addi	sp,sp,16
    80000fc0:	8082                	ret

0000000080000fc2 <strlen>:

int
strlen(const char *s)
{
    80000fc2:	1141                	addi	sp,sp,-16
    80000fc4:	e422                	sd	s0,8(sp)
    80000fc6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000fc8:	00054783          	lbu	a5,0(a0)
    80000fcc:	cf91                	beqz	a5,80000fe8 <strlen+0x26>
    80000fce:	0505                	addi	a0,a0,1
    80000fd0:	87aa                	mv	a5,a0
    80000fd2:	4685                	li	a3,1
    80000fd4:	9e89                	subw	a3,a3,a0
    80000fd6:	00f6853b          	addw	a0,a3,a5
    80000fda:	0785                	addi	a5,a5,1
    80000fdc:	fff7c703          	lbu	a4,-1(a5)
    80000fe0:	fb7d                	bnez	a4,80000fd6 <strlen+0x14>
    ;
  return n;
}
    80000fe2:	6422                	ld	s0,8(sp)
    80000fe4:	0141                	addi	sp,sp,16
    80000fe6:	8082                	ret
  for(n = 0; s[n]; n++)
    80000fe8:	4501                	li	a0,0
    80000fea:	bfe5                	j	80000fe2 <strlen+0x20>

0000000080000fec <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000fec:	1141                	addi	sp,sp,-16
    80000fee:	e406                	sd	ra,8(sp)
    80000ff0:	e022                	sd	s0,0(sp)
    80000ff2:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000ff4:	00001097          	auipc	ra,0x1
    80000ff8:	be2080e7          	jalr	-1054(ra) # 80001bd6 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ffc:	00008717          	auipc	a4,0x8
    80001000:	90c70713          	addi	a4,a4,-1780 # 80008908 <started>
  if(cpuid() == 0){
    80001004:	c139                	beqz	a0,8000104a <main+0x5e>
    while(started == 0)
    80001006:	431c                	lw	a5,0(a4)
    80001008:	2781                	sext.w	a5,a5
    8000100a:	dff5                	beqz	a5,80001006 <main+0x1a>
      ;
    __sync_synchronize();
    8000100c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80001010:	00001097          	auipc	ra,0x1
    80001014:	bc6080e7          	jalr	-1082(ra) # 80001bd6 <cpuid>
    80001018:	85aa                	mv	a1,a0
    8000101a:	00007517          	auipc	a0,0x7
    8000101e:	11e50513          	addi	a0,a0,286 # 80008138 <digits+0xf8>
    80001022:	fffff097          	auipc	ra,0xfffff
    80001026:	568080e7          	jalr	1384(ra) # 8000058a <printf>
    kvminithart();    // turn on paging
    8000102a:	00000097          	auipc	ra,0x0
    8000102e:	0e8080e7          	jalr	232(ra) # 80001112 <kvminithart>
    trapinithart();   // install kernel trap vector
    80001032:	00002097          	auipc	ra,0x2
    80001036:	b42080e7          	jalr	-1214(ra) # 80002b74 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000103a:	00005097          	auipc	ra,0x5
    8000103e:	316080e7          	jalr	790(ra) # 80006350 <plicinithart>
  }

  scheduler();        
    80001042:	00001097          	auipc	ra,0x1
    80001046:	128080e7          	jalr	296(ra) # 8000216a <scheduler>
    consoleinit();
    8000104a:	fffff097          	auipc	ra,0xfffff
    8000104e:	406080e7          	jalr	1030(ra) # 80000450 <consoleinit>
    printfinit();
    80001052:	fffff097          	auipc	ra,0xfffff
    80001056:	718080e7          	jalr	1816(ra) # 8000076a <printfinit>
    printf("\n");
    8000105a:	00007517          	auipc	a0,0x7
    8000105e:	24650513          	addi	a0,a0,582 # 800082a0 <digits+0x260>
    80001062:	fffff097          	auipc	ra,0xfffff
    80001066:	528080e7          	jalr	1320(ra) # 8000058a <printf>
    printf("xv6 kernel is booting\n");
    8000106a:	00007517          	auipc	a0,0x7
    8000106e:	07650513          	addi	a0,a0,118 # 800080e0 <digits+0xa0>
    80001072:	fffff097          	auipc	ra,0xfffff
    80001076:	518080e7          	jalr	1304(ra) # 8000058a <printf>
    printf("First run schedulertest then usertest ->PBS:all test passed\n");
    8000107a:	00007517          	auipc	a0,0x7
    8000107e:	07e50513          	addi	a0,a0,126 # 800080f8 <digits+0xb8>
    80001082:	fffff097          	auipc	ra,0xfffff
    80001086:	508080e7          	jalr	1288(ra) # 8000058a <printf>
    printf("\n");
    8000108a:	00007517          	auipc	a0,0x7
    8000108e:	21650513          	addi	a0,a0,534 # 800082a0 <digits+0x260>
    80001092:	fffff097          	auipc	ra,0xfffff
    80001096:	4f8080e7          	jalr	1272(ra) # 8000058a <printf>
    kinit();         // physical page allocator
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	b28080e7          	jalr	-1240(ra) # 80000bc2 <kinit>
    kvminit();       // create kernel page table
    800010a2:	00000097          	auipc	ra,0x0
    800010a6:	326080e7          	jalr	806(ra) # 800013c8 <kvminit>
    kvminithart();   // turn on paging
    800010aa:	00000097          	auipc	ra,0x0
    800010ae:	068080e7          	jalr	104(ra) # 80001112 <kvminithart>
    procinit();      // process table
    800010b2:	00001097          	auipc	ra,0x1
    800010b6:	a70080e7          	jalr	-1424(ra) # 80001b22 <procinit>
    trapinit();      // trap vectors
    800010ba:	00002097          	auipc	ra,0x2
    800010be:	a92080e7          	jalr	-1390(ra) # 80002b4c <trapinit>
    trapinithart();  // install kernel trap vector
    800010c2:	00002097          	auipc	ra,0x2
    800010c6:	ab2080e7          	jalr	-1358(ra) # 80002b74 <trapinithart>
    plicinit();      // set up interrupt controller
    800010ca:	00005097          	auipc	ra,0x5
    800010ce:	270080e7          	jalr	624(ra) # 8000633a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800010d2:	00005097          	auipc	ra,0x5
    800010d6:	27e080e7          	jalr	638(ra) # 80006350 <plicinithart>
    binit();         // buffer cache
    800010da:	00002097          	auipc	ra,0x2
    800010de:	3f8080e7          	jalr	1016(ra) # 800034d2 <binit>
    iinit();         // inode table
    800010e2:	00003097          	auipc	ra,0x3
    800010e6:	a98080e7          	jalr	-1384(ra) # 80003b7a <iinit>
    fileinit();      // file table
    800010ea:	00004097          	auipc	ra,0x4
    800010ee:	a3e080e7          	jalr	-1474(ra) # 80004b28 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010f2:	00005097          	auipc	ra,0x5
    800010f6:	366080e7          	jalr	870(ra) # 80006458 <virtio_disk_init>
    userinit();      // first user process
    800010fa:	00001097          	auipc	ra,0x1
    800010fe:	e16080e7          	jalr	-490(ra) # 80001f10 <userinit>
    __sync_synchronize();
    80001102:	0ff0000f          	fence
    started = 1;
    80001106:	4785                	li	a5,1
    80001108:	00008717          	auipc	a4,0x8
    8000110c:	80f72023          	sw	a5,-2048(a4) # 80008908 <started>
    80001110:	bf0d                	j	80001042 <main+0x56>

0000000080001112 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001112:	1141                	addi	sp,sp,-16
    80001114:	e422                	sd	s0,8(sp)
    80001116:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001118:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000111c:	00007797          	auipc	a5,0x7
    80001120:	7f47b783          	ld	a5,2036(a5) # 80008910 <kernel_pagetable>
    80001124:	83b1                	srli	a5,a5,0xc
    80001126:	577d                	li	a4,-1
    80001128:	177e                	slli	a4,a4,0x3f
    8000112a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000112c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001130:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001134:	6422                	ld	s0,8(sp)
    80001136:	0141                	addi	sp,sp,16
    80001138:	8082                	ret

000000008000113a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000113a:	7139                	addi	sp,sp,-64
    8000113c:	fc06                	sd	ra,56(sp)
    8000113e:	f822                	sd	s0,48(sp)
    80001140:	f426                	sd	s1,40(sp)
    80001142:	f04a                	sd	s2,32(sp)
    80001144:	ec4e                	sd	s3,24(sp)
    80001146:	e852                	sd	s4,16(sp)
    80001148:	e456                	sd	s5,8(sp)
    8000114a:	e05a                	sd	s6,0(sp)
    8000114c:	0080                	addi	s0,sp,64
    8000114e:	84aa                	mv	s1,a0
    80001150:	89ae                	mv	s3,a1
    80001152:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001154:	57fd                	li	a5,-1
    80001156:	83e9                	srli	a5,a5,0x1a
    80001158:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000115a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000115c:	04b7f263          	bgeu	a5,a1,800011a0 <walk+0x66>
    panic("walk");
    80001160:	00007517          	auipc	a0,0x7
    80001164:	ff050513          	addi	a0,a0,-16 # 80008150 <digits+0x110>
    80001168:	fffff097          	auipc	ra,0xfffff
    8000116c:	3d8080e7          	jalr	984(ra) # 80000540 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001170:	060a8663          	beqz	s5,800011dc <walk+0xa2>
    80001174:	00000097          	auipc	ra,0x0
    80001178:	adc080e7          	jalr	-1316(ra) # 80000c50 <kalloc>
    8000117c:	84aa                	mv	s1,a0
    8000117e:	c529                	beqz	a0,800011c8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001180:	6605                	lui	a2,0x1
    80001182:	4581                	li	a1,0
    80001184:	00000097          	auipc	ra,0x0
    80001188:	cc2080e7          	jalr	-830(ra) # 80000e46 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000118c:	00c4d793          	srli	a5,s1,0xc
    80001190:	07aa                	slli	a5,a5,0xa
    80001192:	0017e793          	ori	a5,a5,1
    80001196:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000119a:	3a5d                	addiw	s4,s4,-9 # ff7 <_entry-0x7ffff009>
    8000119c:	036a0063          	beq	s4,s6,800011bc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800011a0:	0149d933          	srl	s2,s3,s4
    800011a4:	1ff97913          	andi	s2,s2,511
    800011a8:	090e                	slli	s2,s2,0x3
    800011aa:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800011ac:	00093483          	ld	s1,0(s2)
    800011b0:	0014f793          	andi	a5,s1,1
    800011b4:	dfd5                	beqz	a5,80001170 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800011b6:	80a9                	srli	s1,s1,0xa
    800011b8:	04b2                	slli	s1,s1,0xc
    800011ba:	b7c5                	j	8000119a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800011bc:	00c9d513          	srli	a0,s3,0xc
    800011c0:	1ff57513          	andi	a0,a0,511
    800011c4:	050e                	slli	a0,a0,0x3
    800011c6:	9526                	add	a0,a0,s1
}
    800011c8:	70e2                	ld	ra,56(sp)
    800011ca:	7442                	ld	s0,48(sp)
    800011cc:	74a2                	ld	s1,40(sp)
    800011ce:	7902                	ld	s2,32(sp)
    800011d0:	69e2                	ld	s3,24(sp)
    800011d2:	6a42                	ld	s4,16(sp)
    800011d4:	6aa2                	ld	s5,8(sp)
    800011d6:	6b02                	ld	s6,0(sp)
    800011d8:	6121                	addi	sp,sp,64
    800011da:	8082                	ret
        return 0;
    800011dc:	4501                	li	a0,0
    800011de:	b7ed                	j	800011c8 <walk+0x8e>

00000000800011e0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800011e0:	57fd                	li	a5,-1
    800011e2:	83e9                	srli	a5,a5,0x1a
    800011e4:	00b7f463          	bgeu	a5,a1,800011ec <walkaddr+0xc>
    return 0;
    800011e8:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800011ea:	8082                	ret
{
    800011ec:	1141                	addi	sp,sp,-16
    800011ee:	e406                	sd	ra,8(sp)
    800011f0:	e022                	sd	s0,0(sp)
    800011f2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800011f4:	4601                	li	a2,0
    800011f6:	00000097          	auipc	ra,0x0
    800011fa:	f44080e7          	jalr	-188(ra) # 8000113a <walk>
  if(pte == 0)
    800011fe:	c105                	beqz	a0,8000121e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001200:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001202:	0117f693          	andi	a3,a5,17
    80001206:	4745                	li	a4,17
    return 0;
    80001208:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000120a:	00e68663          	beq	a3,a4,80001216 <walkaddr+0x36>
}
    8000120e:	60a2                	ld	ra,8(sp)
    80001210:	6402                	ld	s0,0(sp)
    80001212:	0141                	addi	sp,sp,16
    80001214:	8082                	ret
  pa = PTE2PA(*pte);
    80001216:	83a9                	srli	a5,a5,0xa
    80001218:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000121c:	bfcd                	j	8000120e <walkaddr+0x2e>
    return 0;
    8000121e:	4501                	li	a0,0
    80001220:	b7fd                	j	8000120e <walkaddr+0x2e>

0000000080001222 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001222:	715d                	addi	sp,sp,-80
    80001224:	e486                	sd	ra,72(sp)
    80001226:	e0a2                	sd	s0,64(sp)
    80001228:	fc26                	sd	s1,56(sp)
    8000122a:	f84a                	sd	s2,48(sp)
    8000122c:	f44e                	sd	s3,40(sp)
    8000122e:	f052                	sd	s4,32(sp)
    80001230:	ec56                	sd	s5,24(sp)
    80001232:	e85a                	sd	s6,16(sp)
    80001234:	e45e                	sd	s7,8(sp)
    80001236:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001238:	c639                	beqz	a2,80001286 <mappages+0x64>
    8000123a:	8aaa                	mv	s5,a0
    8000123c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000123e:	777d                	lui	a4,0xfffff
    80001240:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001244:	fff58993          	addi	s3,a1,-1
    80001248:	99b2                	add	s3,s3,a2
    8000124a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000124e:	893e                	mv	s2,a5
    80001250:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001254:	6b85                	lui	s7,0x1
    80001256:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000125a:	4605                	li	a2,1
    8000125c:	85ca                	mv	a1,s2
    8000125e:	8556                	mv	a0,s5
    80001260:	00000097          	auipc	ra,0x0
    80001264:	eda080e7          	jalr	-294(ra) # 8000113a <walk>
    80001268:	cd1d                	beqz	a0,800012a6 <mappages+0x84>
    if(*pte & PTE_V)
    8000126a:	611c                	ld	a5,0(a0)
    8000126c:	8b85                	andi	a5,a5,1
    8000126e:	e785                	bnez	a5,80001296 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001270:	80b1                	srli	s1,s1,0xc
    80001272:	04aa                	slli	s1,s1,0xa
    80001274:	0164e4b3          	or	s1,s1,s6
    80001278:	0014e493          	ori	s1,s1,1
    8000127c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000127e:	05390063          	beq	s2,s3,800012be <mappages+0x9c>
    a += PGSIZE;
    80001282:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001284:	bfc9                	j	80001256 <mappages+0x34>
    panic("mappages: size");
    80001286:	00007517          	auipc	a0,0x7
    8000128a:	ed250513          	addi	a0,a0,-302 # 80008158 <digits+0x118>
    8000128e:	fffff097          	auipc	ra,0xfffff
    80001292:	2b2080e7          	jalr	690(ra) # 80000540 <panic>
      panic("mappages: remap");
    80001296:	00007517          	auipc	a0,0x7
    8000129a:	ed250513          	addi	a0,a0,-302 # 80008168 <digits+0x128>
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	2a2080e7          	jalr	674(ra) # 80000540 <panic>
      return -1;
    800012a6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800012a8:	60a6                	ld	ra,72(sp)
    800012aa:	6406                	ld	s0,64(sp)
    800012ac:	74e2                	ld	s1,56(sp)
    800012ae:	7942                	ld	s2,48(sp)
    800012b0:	79a2                	ld	s3,40(sp)
    800012b2:	7a02                	ld	s4,32(sp)
    800012b4:	6ae2                	ld	s5,24(sp)
    800012b6:	6b42                	ld	s6,16(sp)
    800012b8:	6ba2                	ld	s7,8(sp)
    800012ba:	6161                	addi	sp,sp,80
    800012bc:	8082                	ret
  return 0;
    800012be:	4501                	li	a0,0
    800012c0:	b7e5                	j	800012a8 <mappages+0x86>

00000000800012c2 <kvmmap>:
{
    800012c2:	1141                	addi	sp,sp,-16
    800012c4:	e406                	sd	ra,8(sp)
    800012c6:	e022                	sd	s0,0(sp)
    800012c8:	0800                	addi	s0,sp,16
    800012ca:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800012cc:	86b2                	mv	a3,a2
    800012ce:	863e                	mv	a2,a5
    800012d0:	00000097          	auipc	ra,0x0
    800012d4:	f52080e7          	jalr	-174(ra) # 80001222 <mappages>
    800012d8:	e509                	bnez	a0,800012e2 <kvmmap+0x20>
}
    800012da:	60a2                	ld	ra,8(sp)
    800012dc:	6402                	ld	s0,0(sp)
    800012de:	0141                	addi	sp,sp,16
    800012e0:	8082                	ret
    panic("kvmmap");
    800012e2:	00007517          	auipc	a0,0x7
    800012e6:	e9650513          	addi	a0,a0,-362 # 80008178 <digits+0x138>
    800012ea:	fffff097          	auipc	ra,0xfffff
    800012ee:	256080e7          	jalr	598(ra) # 80000540 <panic>

00000000800012f2 <kvmmake>:
{
    800012f2:	1101                	addi	sp,sp,-32
    800012f4:	ec06                	sd	ra,24(sp)
    800012f6:	e822                	sd	s0,16(sp)
    800012f8:	e426                	sd	s1,8(sp)
    800012fa:	e04a                	sd	s2,0(sp)
    800012fc:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800012fe:	00000097          	auipc	ra,0x0
    80001302:	952080e7          	jalr	-1710(ra) # 80000c50 <kalloc>
    80001306:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001308:	6605                	lui	a2,0x1
    8000130a:	4581                	li	a1,0
    8000130c:	00000097          	auipc	ra,0x0
    80001310:	b3a080e7          	jalr	-1222(ra) # 80000e46 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001314:	4719                	li	a4,6
    80001316:	6685                	lui	a3,0x1
    80001318:	10000637          	lui	a2,0x10000
    8000131c:	100005b7          	lui	a1,0x10000
    80001320:	8526                	mv	a0,s1
    80001322:	00000097          	auipc	ra,0x0
    80001326:	fa0080e7          	jalr	-96(ra) # 800012c2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000132a:	4719                	li	a4,6
    8000132c:	6685                	lui	a3,0x1
    8000132e:	10001637          	lui	a2,0x10001
    80001332:	100015b7          	lui	a1,0x10001
    80001336:	8526                	mv	a0,s1
    80001338:	00000097          	auipc	ra,0x0
    8000133c:	f8a080e7          	jalr	-118(ra) # 800012c2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001340:	4719                	li	a4,6
    80001342:	004006b7          	lui	a3,0x400
    80001346:	0c000637          	lui	a2,0xc000
    8000134a:	0c0005b7          	lui	a1,0xc000
    8000134e:	8526                	mv	a0,s1
    80001350:	00000097          	auipc	ra,0x0
    80001354:	f72080e7          	jalr	-142(ra) # 800012c2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001358:	00007917          	auipc	s2,0x7
    8000135c:	ca890913          	addi	s2,s2,-856 # 80008000 <etext>
    80001360:	4729                	li	a4,10
    80001362:	80007697          	auipc	a3,0x80007
    80001366:	c9e68693          	addi	a3,a3,-866 # 8000 <_entry-0x7fff8000>
    8000136a:	4605                	li	a2,1
    8000136c:	067e                	slli	a2,a2,0x1f
    8000136e:	85b2                	mv	a1,a2
    80001370:	8526                	mv	a0,s1
    80001372:	00000097          	auipc	ra,0x0
    80001376:	f50080e7          	jalr	-176(ra) # 800012c2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000137a:	4719                	li	a4,6
    8000137c:	46c5                	li	a3,17
    8000137e:	06ee                	slli	a3,a3,0x1b
    80001380:	412686b3          	sub	a3,a3,s2
    80001384:	864a                	mv	a2,s2
    80001386:	85ca                	mv	a1,s2
    80001388:	8526                	mv	a0,s1
    8000138a:	00000097          	auipc	ra,0x0
    8000138e:	f38080e7          	jalr	-200(ra) # 800012c2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001392:	4729                	li	a4,10
    80001394:	6685                	lui	a3,0x1
    80001396:	00006617          	auipc	a2,0x6
    8000139a:	c6a60613          	addi	a2,a2,-918 # 80007000 <_trampoline>
    8000139e:	040005b7          	lui	a1,0x4000
    800013a2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800013a4:	05b2                	slli	a1,a1,0xc
    800013a6:	8526                	mv	a0,s1
    800013a8:	00000097          	auipc	ra,0x0
    800013ac:	f1a080e7          	jalr	-230(ra) # 800012c2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800013b0:	8526                	mv	a0,s1
    800013b2:	00000097          	auipc	ra,0x0
    800013b6:	6da080e7          	jalr	1754(ra) # 80001a8c <proc_mapstacks>
}
    800013ba:	8526                	mv	a0,s1
    800013bc:	60e2                	ld	ra,24(sp)
    800013be:	6442                	ld	s0,16(sp)
    800013c0:	64a2                	ld	s1,8(sp)
    800013c2:	6902                	ld	s2,0(sp)
    800013c4:	6105                	addi	sp,sp,32
    800013c6:	8082                	ret

00000000800013c8 <kvminit>:
{
    800013c8:	1141                	addi	sp,sp,-16
    800013ca:	e406                	sd	ra,8(sp)
    800013cc:	e022                	sd	s0,0(sp)
    800013ce:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	f22080e7          	jalr	-222(ra) # 800012f2 <kvmmake>
    800013d8:	00007797          	auipc	a5,0x7
    800013dc:	52a7bc23          	sd	a0,1336(a5) # 80008910 <kernel_pagetable>
}
    800013e0:	60a2                	ld	ra,8(sp)
    800013e2:	6402                	ld	s0,0(sp)
    800013e4:	0141                	addi	sp,sp,16
    800013e6:	8082                	ret

00000000800013e8 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800013e8:	715d                	addi	sp,sp,-80
    800013ea:	e486                	sd	ra,72(sp)
    800013ec:	e0a2                	sd	s0,64(sp)
    800013ee:	fc26                	sd	s1,56(sp)
    800013f0:	f84a                	sd	s2,48(sp)
    800013f2:	f44e                	sd	s3,40(sp)
    800013f4:	f052                	sd	s4,32(sp)
    800013f6:	ec56                	sd	s5,24(sp)
    800013f8:	e85a                	sd	s6,16(sp)
    800013fa:	e45e                	sd	s7,8(sp)
    800013fc:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800013fe:	03459793          	slli	a5,a1,0x34
    80001402:	e795                	bnez	a5,8000142e <uvmunmap+0x46>
    80001404:	8a2a                	mv	s4,a0
    80001406:	892e                	mv	s2,a1
    80001408:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000140a:	0632                	slli	a2,a2,0xc
    8000140c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001410:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001412:	6b05                	lui	s6,0x1
    80001414:	0735e263          	bltu	a1,s3,80001478 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001418:	60a6                	ld	ra,72(sp)
    8000141a:	6406                	ld	s0,64(sp)
    8000141c:	74e2                	ld	s1,56(sp)
    8000141e:	7942                	ld	s2,48(sp)
    80001420:	79a2                	ld	s3,40(sp)
    80001422:	7a02                	ld	s4,32(sp)
    80001424:	6ae2                	ld	s5,24(sp)
    80001426:	6b42                	ld	s6,16(sp)
    80001428:	6ba2                	ld	s7,8(sp)
    8000142a:	6161                	addi	sp,sp,80
    8000142c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000142e:	00007517          	auipc	a0,0x7
    80001432:	d5250513          	addi	a0,a0,-686 # 80008180 <digits+0x140>
    80001436:	fffff097          	auipc	ra,0xfffff
    8000143a:	10a080e7          	jalr	266(ra) # 80000540 <panic>
      panic("uvmunmap: walk");
    8000143e:	00007517          	auipc	a0,0x7
    80001442:	d5a50513          	addi	a0,a0,-678 # 80008198 <digits+0x158>
    80001446:	fffff097          	auipc	ra,0xfffff
    8000144a:	0fa080e7          	jalr	250(ra) # 80000540 <panic>
      panic("uvmunmap: not mapped");
    8000144e:	00007517          	auipc	a0,0x7
    80001452:	d5a50513          	addi	a0,a0,-678 # 800081a8 <digits+0x168>
    80001456:	fffff097          	auipc	ra,0xfffff
    8000145a:	0ea080e7          	jalr	234(ra) # 80000540 <panic>
      panic("uvmunmap: not a leaf");
    8000145e:	00007517          	auipc	a0,0x7
    80001462:	d6250513          	addi	a0,a0,-670 # 800081c0 <digits+0x180>
    80001466:	fffff097          	auipc	ra,0xfffff
    8000146a:	0da080e7          	jalr	218(ra) # 80000540 <panic>
    *pte = 0;
    8000146e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001472:	995a                	add	s2,s2,s6
    80001474:	fb3972e3          	bgeu	s2,s3,80001418 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001478:	4601                	li	a2,0
    8000147a:	85ca                	mv	a1,s2
    8000147c:	8552                	mv	a0,s4
    8000147e:	00000097          	auipc	ra,0x0
    80001482:	cbc080e7          	jalr	-836(ra) # 8000113a <walk>
    80001486:	84aa                	mv	s1,a0
    80001488:	d95d                	beqz	a0,8000143e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000148a:	6108                	ld	a0,0(a0)
    8000148c:	00157793          	andi	a5,a0,1
    80001490:	dfdd                	beqz	a5,8000144e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001492:	3ff57793          	andi	a5,a0,1023
    80001496:	fd7784e3          	beq	a5,s7,8000145e <uvmunmap+0x76>
    if(do_free){
    8000149a:	fc0a8ae3          	beqz	s5,8000146e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000149e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800014a0:	0532                	slli	a0,a0,0xc
    800014a2:	fffff097          	auipc	ra,0xfffff
    800014a6:	5d6080e7          	jalr	1494(ra) # 80000a78 <kfree>
    800014aa:	b7d1                	j	8000146e <uvmunmap+0x86>

00000000800014ac <cowalloc>:
  if ((va % PGSIZE) != 0) return -1;
    800014ac:	03459793          	slli	a5,a1,0x34
    800014b0:	e3c5                	bnez	a5,80001550 <cowalloc+0xa4>
{
    800014b2:	7139                	addi	sp,sp,-64
    800014b4:	fc06                	sd	ra,56(sp)
    800014b6:	f822                	sd	s0,48(sp)
    800014b8:	f426                	sd	s1,40(sp)
    800014ba:	f04a                	sd	s2,32(sp)
    800014bc:	ec4e                	sd	s3,24(sp)
    800014be:	e852                	sd	s4,16(sp)
    800014c0:	e456                	sd	s5,8(sp)
    800014c2:	0080                	addi	s0,sp,64
    800014c4:	892a                	mv	s2,a0
    800014c6:	84ae                	mv	s1,a1
  if (va >= MAXVA) return -1;
    800014c8:	57fd                	li	a5,-1
    800014ca:	83e9                	srli	a5,a5,0x1a
    800014cc:	08b7e463          	bltu	a5,a1,80001554 <cowalloc+0xa8>
  pte_t *pte = walk(pagetable, va, 0);
    800014d0:	4601                	li	a2,0
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	c68080e7          	jalr	-920(ra) # 8000113a <walk>
  if (pte == 0) return -1;
    800014da:	cd3d                	beqz	a0,80001558 <cowalloc+0xac>
  uint64 pa = PTE2PA(*pte);
    800014dc:	6118                	ld	a4,0(a0)
    800014de:	00a75a13          	srli	s4,a4,0xa
    800014e2:	0a32                	slli	s4,s4,0xc
  if (pa == 0) return -1;
    800014e4:	060a0c63          	beqz	s4,8000155c <cowalloc+0xb0>
  if (*pte & PTE_COW)
    800014e8:	10077793          	andi	a5,a4,256
  return 0;
    800014ec:	4501                	li	a0,0
  if (*pte & PTE_COW)
    800014ee:	eb91                	bnez	a5,80001502 <cowalloc+0x56>
}
    800014f0:	70e2                	ld	ra,56(sp)
    800014f2:	7442                	ld	s0,48(sp)
    800014f4:	74a2                	ld	s1,40(sp)
    800014f6:	7902                	ld	s2,32(sp)
    800014f8:	69e2                	ld	s3,24(sp)
    800014fa:	6a42                	ld	s4,16(sp)
    800014fc:	6aa2                	ld	s5,8(sp)
    800014fe:	6121                	addi	sp,sp,64
    80001500:	8082                	ret
    flags = (flags & ~PTE_COW) | PTE_W;
    80001502:	2fb77713          	andi	a4,a4,763
    80001506:	00476993          	ori	s3,a4,4
    char *ka = kalloc();
    8000150a:	fffff097          	auipc	ra,0xfffff
    8000150e:	746080e7          	jalr	1862(ra) # 80000c50 <kalloc>
    80001512:	8aaa                	mv	s5,a0
    if (ka == 0) return -1;
    80001514:	c531                	beqz	a0,80001560 <cowalloc+0xb4>
    memmove(ka, (char*)pa, PGSIZE);
    80001516:	6605                	lui	a2,0x1
    80001518:	85d2                	mv	a1,s4
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	988080e7          	jalr	-1656(ra) # 80000ea2 <memmove>
    uvmunmap(pagetable, PGROUNDUP(va), 1, 1);
    80001522:	6785                	lui	a5,0x1
    80001524:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001526:	97a6                	add	a5,a5,s1
    80001528:	4685                	li	a3,1
    8000152a:	4605                	li	a2,1
    8000152c:	75fd                	lui	a1,0xfffff
    8000152e:	8dfd                	and	a1,a1,a5
    80001530:	854a                	mv	a0,s2
    80001532:	00000097          	auipc	ra,0x0
    80001536:	eb6080e7          	jalr	-330(ra) # 800013e8 <uvmunmap>
    mappages(pagetable, va, PGSIZE, (uint64)ka, flags);
    8000153a:	874e                	mv	a4,s3
    8000153c:	86d6                	mv	a3,s5
    8000153e:	6605                	lui	a2,0x1
    80001540:	85a6                	mv	a1,s1
    80001542:	854a                	mv	a0,s2
    80001544:	00000097          	auipc	ra,0x0
    80001548:	cde080e7          	jalr	-802(ra) # 80001222 <mappages>
  return 0;
    8000154c:	4501                	li	a0,0
    8000154e:	b74d                	j	800014f0 <cowalloc+0x44>
  if ((va % PGSIZE) != 0) return -1;
    80001550:	557d                	li	a0,-1
}
    80001552:	8082                	ret
  if (va >= MAXVA) return -1;
    80001554:	557d                	li	a0,-1
    80001556:	bf69                	j	800014f0 <cowalloc+0x44>
  if (pte == 0) return -1;
    80001558:	557d                	li	a0,-1
    8000155a:	bf59                	j	800014f0 <cowalloc+0x44>
  if (pa == 0) return -1;
    8000155c:	557d                	li	a0,-1
    8000155e:	bf49                	j	800014f0 <cowalloc+0x44>
    if (ka == 0) return -1;
    80001560:	557d                	li	a0,-1
    80001562:	b779                	j	800014f0 <cowalloc+0x44>

0000000080001564 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001564:	1101                	addi	sp,sp,-32
    80001566:	ec06                	sd	ra,24(sp)
    80001568:	e822                	sd	s0,16(sp)
    8000156a:	e426                	sd	s1,8(sp)
    8000156c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000156e:	fffff097          	auipc	ra,0xfffff
    80001572:	6e2080e7          	jalr	1762(ra) # 80000c50 <kalloc>
    80001576:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001578:	c519                	beqz	a0,80001586 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000157a:	6605                	lui	a2,0x1
    8000157c:	4581                	li	a1,0
    8000157e:	00000097          	auipc	ra,0x0
    80001582:	8c8080e7          	jalr	-1848(ra) # 80000e46 <memset>
  return pagetable;
}
    80001586:	8526                	mv	a0,s1
    80001588:	60e2                	ld	ra,24(sp)
    8000158a:	6442                	ld	s0,16(sp)
    8000158c:	64a2                	ld	s1,8(sp)
    8000158e:	6105                	addi	sp,sp,32
    80001590:	8082                	ret

0000000080001592 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001592:	7179                	addi	sp,sp,-48
    80001594:	f406                	sd	ra,40(sp)
    80001596:	f022                	sd	s0,32(sp)
    80001598:	ec26                	sd	s1,24(sp)
    8000159a:	e84a                	sd	s2,16(sp)
    8000159c:	e44e                	sd	s3,8(sp)
    8000159e:	e052                	sd	s4,0(sp)
    800015a0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800015a2:	6785                	lui	a5,0x1
    800015a4:	04f67863          	bgeu	a2,a5,800015f4 <uvmfirst+0x62>
    800015a8:	8a2a                	mv	s4,a0
    800015aa:	89ae                	mv	s3,a1
    800015ac:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800015ae:	fffff097          	auipc	ra,0xfffff
    800015b2:	6a2080e7          	jalr	1698(ra) # 80000c50 <kalloc>
    800015b6:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800015b8:	6605                	lui	a2,0x1
    800015ba:	4581                	li	a1,0
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	88a080e7          	jalr	-1910(ra) # 80000e46 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800015c4:	4779                	li	a4,30
    800015c6:	86ca                	mv	a3,s2
    800015c8:	6605                	lui	a2,0x1
    800015ca:	4581                	li	a1,0
    800015cc:	8552                	mv	a0,s4
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	c54080e7          	jalr	-940(ra) # 80001222 <mappages>
  memmove(mem, src, sz);
    800015d6:	8626                	mv	a2,s1
    800015d8:	85ce                	mv	a1,s3
    800015da:	854a                	mv	a0,s2
    800015dc:	00000097          	auipc	ra,0x0
    800015e0:	8c6080e7          	jalr	-1850(ra) # 80000ea2 <memmove>
}
    800015e4:	70a2                	ld	ra,40(sp)
    800015e6:	7402                	ld	s0,32(sp)
    800015e8:	64e2                	ld	s1,24(sp)
    800015ea:	6942                	ld	s2,16(sp)
    800015ec:	69a2                	ld	s3,8(sp)
    800015ee:	6a02                	ld	s4,0(sp)
    800015f0:	6145                	addi	sp,sp,48
    800015f2:	8082                	ret
    panic("uvmfirst: more than a page");
    800015f4:	00007517          	auipc	a0,0x7
    800015f8:	be450513          	addi	a0,a0,-1052 # 800081d8 <digits+0x198>
    800015fc:	fffff097          	auipc	ra,0xfffff
    80001600:	f44080e7          	jalr	-188(ra) # 80000540 <panic>

0000000080001604 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001604:	1101                	addi	sp,sp,-32
    80001606:	ec06                	sd	ra,24(sp)
    80001608:	e822                	sd	s0,16(sp)
    8000160a:	e426                	sd	s1,8(sp)
    8000160c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000160e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001610:	00b67d63          	bgeu	a2,a1,8000162a <uvmdealloc+0x26>
    80001614:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001616:	6785                	lui	a5,0x1
    80001618:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000161a:	00f60733          	add	a4,a2,a5
    8000161e:	76fd                	lui	a3,0xfffff
    80001620:	8f75                	and	a4,a4,a3
    80001622:	97ae                	add	a5,a5,a1
    80001624:	8ff5                	and	a5,a5,a3
    80001626:	00f76863          	bltu	a4,a5,80001636 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000162a:	8526                	mv	a0,s1
    8000162c:	60e2                	ld	ra,24(sp)
    8000162e:	6442                	ld	s0,16(sp)
    80001630:	64a2                	ld	s1,8(sp)
    80001632:	6105                	addi	sp,sp,32
    80001634:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001636:	8f99                	sub	a5,a5,a4
    80001638:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000163a:	4685                	li	a3,1
    8000163c:	0007861b          	sext.w	a2,a5
    80001640:	85ba                	mv	a1,a4
    80001642:	00000097          	auipc	ra,0x0
    80001646:	da6080e7          	jalr	-602(ra) # 800013e8 <uvmunmap>
    8000164a:	b7c5                	j	8000162a <uvmdealloc+0x26>

000000008000164c <uvmalloc>:
  if(newsz < oldsz)
    8000164c:	0ab66563          	bltu	a2,a1,800016f6 <uvmalloc+0xaa>
{
    80001650:	7139                	addi	sp,sp,-64
    80001652:	fc06                	sd	ra,56(sp)
    80001654:	f822                	sd	s0,48(sp)
    80001656:	f426                	sd	s1,40(sp)
    80001658:	f04a                	sd	s2,32(sp)
    8000165a:	ec4e                	sd	s3,24(sp)
    8000165c:	e852                	sd	s4,16(sp)
    8000165e:	e456                	sd	s5,8(sp)
    80001660:	e05a                	sd	s6,0(sp)
    80001662:	0080                	addi	s0,sp,64
    80001664:	8aaa                	mv	s5,a0
    80001666:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001668:	6785                	lui	a5,0x1
    8000166a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000166c:	95be                	add	a1,a1,a5
    8000166e:	77fd                	lui	a5,0xfffff
    80001670:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001674:	08c9f363          	bgeu	s3,a2,800016fa <uvmalloc+0xae>
    80001678:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000167a:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000167e:	fffff097          	auipc	ra,0xfffff
    80001682:	5d2080e7          	jalr	1490(ra) # 80000c50 <kalloc>
    80001686:	84aa                	mv	s1,a0
    if(mem == 0){
    80001688:	c51d                	beqz	a0,800016b6 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000168a:	6605                	lui	a2,0x1
    8000168c:	4581                	li	a1,0
    8000168e:	fffff097          	auipc	ra,0xfffff
    80001692:	7b8080e7          	jalr	1976(ra) # 80000e46 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001696:	875a                	mv	a4,s6
    80001698:	86a6                	mv	a3,s1
    8000169a:	6605                	lui	a2,0x1
    8000169c:	85ca                	mv	a1,s2
    8000169e:	8556                	mv	a0,s5
    800016a0:	00000097          	auipc	ra,0x0
    800016a4:	b82080e7          	jalr	-1150(ra) # 80001222 <mappages>
    800016a8:	e90d                	bnez	a0,800016da <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800016aa:	6785                	lui	a5,0x1
    800016ac:	993e                	add	s2,s2,a5
    800016ae:	fd4968e3          	bltu	s2,s4,8000167e <uvmalloc+0x32>
  return newsz;
    800016b2:	8552                	mv	a0,s4
    800016b4:	a809                	j	800016c6 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    800016b6:	864e                	mv	a2,s3
    800016b8:	85ca                	mv	a1,s2
    800016ba:	8556                	mv	a0,s5
    800016bc:	00000097          	auipc	ra,0x0
    800016c0:	f48080e7          	jalr	-184(ra) # 80001604 <uvmdealloc>
      return 0;
    800016c4:	4501                	li	a0,0
}
    800016c6:	70e2                	ld	ra,56(sp)
    800016c8:	7442                	ld	s0,48(sp)
    800016ca:	74a2                	ld	s1,40(sp)
    800016cc:	7902                	ld	s2,32(sp)
    800016ce:	69e2                	ld	s3,24(sp)
    800016d0:	6a42                	ld	s4,16(sp)
    800016d2:	6aa2                	ld	s5,8(sp)
    800016d4:	6b02                	ld	s6,0(sp)
    800016d6:	6121                	addi	sp,sp,64
    800016d8:	8082                	ret
      kfree(mem);
    800016da:	8526                	mv	a0,s1
    800016dc:	fffff097          	auipc	ra,0xfffff
    800016e0:	39c080e7          	jalr	924(ra) # 80000a78 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800016e4:	864e                	mv	a2,s3
    800016e6:	85ca                	mv	a1,s2
    800016e8:	8556                	mv	a0,s5
    800016ea:	00000097          	auipc	ra,0x0
    800016ee:	f1a080e7          	jalr	-230(ra) # 80001604 <uvmdealloc>
      return 0;
    800016f2:	4501                	li	a0,0
    800016f4:	bfc9                	j	800016c6 <uvmalloc+0x7a>
    return oldsz;
    800016f6:	852e                	mv	a0,a1
}
    800016f8:	8082                	ret
  return newsz;
    800016fa:	8532                	mv	a0,a2
    800016fc:	b7e9                	j	800016c6 <uvmalloc+0x7a>

00000000800016fe <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800016fe:	7179                	addi	sp,sp,-48
    80001700:	f406                	sd	ra,40(sp)
    80001702:	f022                	sd	s0,32(sp)
    80001704:	ec26                	sd	s1,24(sp)
    80001706:	e84a                	sd	s2,16(sp)
    80001708:	e44e                	sd	s3,8(sp)
    8000170a:	e052                	sd	s4,0(sp)
    8000170c:	1800                	addi	s0,sp,48
    8000170e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001710:	84aa                	mv	s1,a0
    80001712:	6905                	lui	s2,0x1
    80001714:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001716:	4985                	li	s3,1
    80001718:	a829                	j	80001732 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000171a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000171c:	00c79513          	slli	a0,a5,0xc
    80001720:	00000097          	auipc	ra,0x0
    80001724:	fde080e7          	jalr	-34(ra) # 800016fe <freewalk>
      pagetable[i] = 0;
    80001728:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000172c:	04a1                	addi	s1,s1,8
    8000172e:	03248163          	beq	s1,s2,80001750 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001732:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001734:	00f7f713          	andi	a4,a5,15
    80001738:	ff3701e3          	beq	a4,s3,8000171a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000173c:	8b85                	andi	a5,a5,1
    8000173e:	d7fd                	beqz	a5,8000172c <freewalk+0x2e>
      panic("freewalk: leaf");
    80001740:	00007517          	auipc	a0,0x7
    80001744:	ab850513          	addi	a0,a0,-1352 # 800081f8 <digits+0x1b8>
    80001748:	fffff097          	auipc	ra,0xfffff
    8000174c:	df8080e7          	jalr	-520(ra) # 80000540 <panic>
    }
  }
  kfree((void*)pagetable);
    80001750:	8552                	mv	a0,s4
    80001752:	fffff097          	auipc	ra,0xfffff
    80001756:	326080e7          	jalr	806(ra) # 80000a78 <kfree>
}
    8000175a:	70a2                	ld	ra,40(sp)
    8000175c:	7402                	ld	s0,32(sp)
    8000175e:	64e2                	ld	s1,24(sp)
    80001760:	6942                	ld	s2,16(sp)
    80001762:	69a2                	ld	s3,8(sp)
    80001764:	6a02                	ld	s4,0(sp)
    80001766:	6145                	addi	sp,sp,48
    80001768:	8082                	ret

000000008000176a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000176a:	1101                	addi	sp,sp,-32
    8000176c:	ec06                	sd	ra,24(sp)
    8000176e:	e822                	sd	s0,16(sp)
    80001770:	e426                	sd	s1,8(sp)
    80001772:	1000                	addi	s0,sp,32
    80001774:	84aa                	mv	s1,a0
  if(sz > 0)
    80001776:	e999                	bnez	a1,8000178c <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001778:	8526                	mv	a0,s1
    8000177a:	00000097          	auipc	ra,0x0
    8000177e:	f84080e7          	jalr	-124(ra) # 800016fe <freewalk>
}
    80001782:	60e2                	ld	ra,24(sp)
    80001784:	6442                	ld	s0,16(sp)
    80001786:	64a2                	ld	s1,8(sp)
    80001788:	6105                	addi	sp,sp,32
    8000178a:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000178c:	6785                	lui	a5,0x1
    8000178e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001790:	95be                	add	a1,a1,a5
    80001792:	4685                	li	a3,1
    80001794:	00c5d613          	srli	a2,a1,0xc
    80001798:	4581                	li	a1,0
    8000179a:	00000097          	auipc	ra,0x0
    8000179e:	c4e080e7          	jalr	-946(ra) # 800013e8 <uvmunmap>
    800017a2:	bfd9                	j	80001778 <uvmfree+0xe>

00000000800017a4 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    800017a4:	715d                	addi	sp,sp,-80
    800017a6:	e486                	sd	ra,72(sp)
    800017a8:	e0a2                	sd	s0,64(sp)
    800017aa:	fc26                	sd	s1,56(sp)
    800017ac:	f84a                	sd	s2,48(sp)
    800017ae:	f44e                	sd	s3,40(sp)
    800017b0:	f052                	sd	s4,32(sp)
    800017b2:	ec56                	sd	s5,24(sp)
    800017b4:	e85a                	sd	s6,16(sp)
    800017b6:	e45e                	sd	s7,8(sp)
    800017b8:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800017ba:	ce5d                	beqz	a2,80001878 <uvmcopy+0xd4>
    800017bc:	8aaa                	mv	s5,a0
    800017be:	8a2e                	mv	s4,a1
    800017c0:	89b2                	mv	s3,a2
    800017c2:	4481                	li	s1,0
    //   goto err;
    // memmove(mem, (char*)pa, PGSIZE);
    if (flags & PTE_W)
    {
      flags = (flags & (~PTE_W)) | PTE_COW;
      *pte = PA2PTE(pa) | flags;
    800017c4:	7b7d                	lui	s6,0xfffff
    800017c6:	002b5b13          	srli	s6,s6,0x2
    800017ca:	a0a1                	j	80001812 <uvmcopy+0x6e>
      panic("uvmcopy: pte should exist");
    800017cc:	00007517          	auipc	a0,0x7
    800017d0:	a3c50513          	addi	a0,a0,-1476 # 80008208 <digits+0x1c8>
    800017d4:	fffff097          	auipc	ra,0xfffff
    800017d8:	d6c080e7          	jalr	-660(ra) # 80000540 <panic>
      panic("uvmcopy: page not present");
    800017dc:	00007517          	auipc	a0,0x7
    800017e0:	a4c50513          	addi	a0,a0,-1460 # 80008228 <digits+0x1e8>
    800017e4:	fffff097          	auipc	ra,0xfffff
    800017e8:	d5c080e7          	jalr	-676(ra) # 80000540 <panic>
    }


    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    800017ec:	86ca                	mv	a3,s2
    800017ee:	6605                	lui	a2,0x1
    800017f0:	85a6                	mv	a1,s1
    800017f2:	8552                	mv	a0,s4
    800017f4:	00000097          	auipc	ra,0x0
    800017f8:	a2e080e7          	jalr	-1490(ra) # 80001222 <mappages>
    800017fc:	8baa                	mv	s7,a0
    800017fe:	e539                	bnez	a0,8000184c <uvmcopy+0xa8>
      // kfree(mem);
      goto err;
    }

    increase_pgreference((void *)pa);
    80001800:	854a                	mv	a0,s2
    80001802:	fffff097          	auipc	ra,0xfffff
    80001806:	2fa080e7          	jalr	762(ra) # 80000afc <increase_pgreference>
  for(i = 0; i < sz; i += PGSIZE){
    8000180a:	6785                	lui	a5,0x1
    8000180c:	94be                	add	s1,s1,a5
    8000180e:	0534f963          	bgeu	s1,s3,80001860 <uvmcopy+0xbc>
    if((pte = walk(old, i, 0)) == 0)
    80001812:	4601                	li	a2,0
    80001814:	85a6                	mv	a1,s1
    80001816:	8556                	mv	a0,s5
    80001818:	00000097          	auipc	ra,0x0
    8000181c:	922080e7          	jalr	-1758(ra) # 8000113a <walk>
    80001820:	d555                	beqz	a0,800017cc <uvmcopy+0x28>
    if((*pte & PTE_V) == 0)
    80001822:	611c                	ld	a5,0(a0)
    80001824:	0017f713          	andi	a4,a5,1
    80001828:	db55                	beqz	a4,800017dc <uvmcopy+0x38>
    pa = PTE2PA(*pte);
    8000182a:	00a7d913          	srli	s2,a5,0xa
    8000182e:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);
    80001830:	3ff7f713          	andi	a4,a5,1023
    if (flags & PTE_W)
    80001834:	0047f693          	andi	a3,a5,4
    80001838:	dad5                	beqz	a3,800017ec <uvmcopy+0x48>
      flags = (flags & (~PTE_W)) | PTE_COW;
    8000183a:	efb77693          	andi	a3,a4,-261
    8000183e:	1006e713          	ori	a4,a3,256
      *pte = PA2PTE(pa) | flags;
    80001842:	0167f7b3          	and	a5,a5,s6
    80001846:	8fd9                	or	a5,a5,a4
    80001848:	e11c                	sd	a5,0(a0)
    8000184a:	b74d                	j	800017ec <uvmcopy+0x48>

  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000184c:	4685                	li	a3,1
    8000184e:	00c4d613          	srli	a2,s1,0xc
    80001852:	4581                	li	a1,0
    80001854:	8552                	mv	a0,s4
    80001856:	00000097          	auipc	ra,0x0
    8000185a:	b92080e7          	jalr	-1134(ra) # 800013e8 <uvmunmap>
  return -1;
    8000185e:	5bfd                	li	s7,-1
}
    80001860:	855e                	mv	a0,s7
    80001862:	60a6                	ld	ra,72(sp)
    80001864:	6406                	ld	s0,64(sp)
    80001866:	74e2                	ld	s1,56(sp)
    80001868:	7942                	ld	s2,48(sp)
    8000186a:	79a2                	ld	s3,40(sp)
    8000186c:	7a02                	ld	s4,32(sp)
    8000186e:	6ae2                	ld	s5,24(sp)
    80001870:	6b42                	ld	s6,16(sp)
    80001872:	6ba2                	ld	s7,8(sp)
    80001874:	6161                	addi	sp,sp,80
    80001876:	8082                	ret
  return 0;
    80001878:	4b81                	li	s7,0
    8000187a:	b7dd                	j	80001860 <uvmcopy+0xbc>

000000008000187c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000187c:	1141                	addi	sp,sp,-16
    8000187e:	e406                	sd	ra,8(sp)
    80001880:	e022                	sd	s0,0(sp)
    80001882:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001884:	4601                	li	a2,0
    80001886:	00000097          	auipc	ra,0x0
    8000188a:	8b4080e7          	jalr	-1868(ra) # 8000113a <walk>
  if(pte == 0)
    8000188e:	c901                	beqz	a0,8000189e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001890:	611c                	ld	a5,0(a0)
    80001892:	9bbd                	andi	a5,a5,-17
    80001894:	e11c                	sd	a5,0(a0)
}
    80001896:	60a2                	ld	ra,8(sp)
    80001898:	6402                	ld	s0,0(sp)
    8000189a:	0141                	addi	sp,sp,16
    8000189c:	8082                	ret
    panic("uvmclear");
    8000189e:	00007517          	auipc	a0,0x7
    800018a2:	9aa50513          	addi	a0,a0,-1622 # 80008248 <digits+0x208>
    800018a6:	fffff097          	auipc	ra,0xfffff
    800018aa:	c9a080e7          	jalr	-870(ra) # 80000540 <panic>

00000000800018ae <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800018ae:	cebd                	beqz	a3,8000192c <copyout+0x7e>
{
    800018b0:	715d                	addi	sp,sp,-80
    800018b2:	e486                	sd	ra,72(sp)
    800018b4:	e0a2                	sd	s0,64(sp)
    800018b6:	fc26                	sd	s1,56(sp)
    800018b8:	f84a                	sd	s2,48(sp)
    800018ba:	f44e                	sd	s3,40(sp)
    800018bc:	f052                	sd	s4,32(sp)
    800018be:	ec56                	sd	s5,24(sp)
    800018c0:	e85a                	sd	s6,16(sp)
    800018c2:	e45e                	sd	s7,8(sp)
    800018c4:	e062                	sd	s8,0(sp)
    800018c6:	0880                	addi	s0,sp,80
    800018c8:	8b2a                	mv	s6,a0
    800018ca:	892e                	mv	s2,a1
    800018cc:	8ab2                	mv	s5,a2
    800018ce:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    800018d0:	7c7d                	lui	s8,0xfffff
    }

    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800018d2:	6b85                	lui	s7,0x1
    800018d4:	a015                	j	800018f8 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800018d6:	41390933          	sub	s2,s2,s3
    800018da:	0004861b          	sext.w	a2,s1
    800018de:	85d6                	mv	a1,s5
    800018e0:	954a                	add	a0,a0,s2
    800018e2:	fffff097          	auipc	ra,0xfffff
    800018e6:	5c0080e7          	jalr	1472(ra) # 80000ea2 <memmove>

    len -= n;
    800018ea:	409a0a33          	sub	s4,s4,s1
    src += n;
    800018ee:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    800018f0:	01798933          	add	s2,s3,s7
  while(len > 0){
    800018f4:	020a0a63          	beqz	s4,80001928 <copyout+0x7a>
    va0 = PGROUNDDOWN(dstva);
    800018f8:	018979b3          	and	s3,s2,s8
    if(cowalloc(pagetable,va0) < 0){  //added for cow
    800018fc:	85ce                	mv	a1,s3
    800018fe:	855a                	mv	a0,s6
    80001900:	00000097          	auipc	ra,0x0
    80001904:	bac080e7          	jalr	-1108(ra) # 800014ac <cowalloc>
    80001908:	02054463          	bltz	a0,80001930 <copyout+0x82>
    pa0 = walkaddr(pagetable, va0);
    8000190c:	85ce                	mv	a1,s3
    8000190e:	855a                	mv	a0,s6
    80001910:	00000097          	auipc	ra,0x0
    80001914:	8d0080e7          	jalr	-1840(ra) # 800011e0 <walkaddr>
    if(pa0 == 0)
    80001918:	c90d                	beqz	a0,8000194a <copyout+0x9c>
    n = PGSIZE - (dstva - va0);
    8000191a:	412984b3          	sub	s1,s3,s2
    8000191e:	94de                	add	s1,s1,s7
    80001920:	fa9a7be3          	bgeu	s4,s1,800018d6 <copyout+0x28>
    80001924:	84d2                	mv	s1,s4
    80001926:	bf45                	j	800018d6 <copyout+0x28>
  }
  return 0;
    80001928:	4501                	li	a0,0
    8000192a:	a021                	j	80001932 <copyout+0x84>
    8000192c:	4501                	li	a0,0
}
    8000192e:	8082                	ret
      return -1;
    80001930:	557d                	li	a0,-1
}
    80001932:	60a6                	ld	ra,72(sp)
    80001934:	6406                	ld	s0,64(sp)
    80001936:	74e2                	ld	s1,56(sp)
    80001938:	7942                	ld	s2,48(sp)
    8000193a:	79a2                	ld	s3,40(sp)
    8000193c:	7a02                	ld	s4,32(sp)
    8000193e:	6ae2                	ld	s5,24(sp)
    80001940:	6b42                	ld	s6,16(sp)
    80001942:	6ba2                	ld	s7,8(sp)
    80001944:	6c02                	ld	s8,0(sp)
    80001946:	6161                	addi	sp,sp,80
    80001948:	8082                	ret
      return -1;
    8000194a:	557d                	li	a0,-1
    8000194c:	b7dd                	j	80001932 <copyout+0x84>

000000008000194e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000194e:	caa5                	beqz	a3,800019be <copyin+0x70>
{
    80001950:	715d                	addi	sp,sp,-80
    80001952:	e486                	sd	ra,72(sp)
    80001954:	e0a2                	sd	s0,64(sp)
    80001956:	fc26                	sd	s1,56(sp)
    80001958:	f84a                	sd	s2,48(sp)
    8000195a:	f44e                	sd	s3,40(sp)
    8000195c:	f052                	sd	s4,32(sp)
    8000195e:	ec56                	sd	s5,24(sp)
    80001960:	e85a                	sd	s6,16(sp)
    80001962:	e45e                	sd	s7,8(sp)
    80001964:	e062                	sd	s8,0(sp)
    80001966:	0880                	addi	s0,sp,80
    80001968:	8b2a                	mv	s6,a0
    8000196a:	8a2e                	mv	s4,a1
    8000196c:	8c32                	mv	s8,a2
    8000196e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001970:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001972:	6a85                	lui	s5,0x1
    80001974:	a01d                	j	8000199a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001976:	018505b3          	add	a1,a0,s8
    8000197a:	0004861b          	sext.w	a2,s1
    8000197e:	412585b3          	sub	a1,a1,s2
    80001982:	8552                	mv	a0,s4
    80001984:	fffff097          	auipc	ra,0xfffff
    80001988:	51e080e7          	jalr	1310(ra) # 80000ea2 <memmove>

    len -= n;
    8000198c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001990:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001992:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001996:	02098263          	beqz	s3,800019ba <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000199a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000199e:	85ca                	mv	a1,s2
    800019a0:	855a                	mv	a0,s6
    800019a2:	00000097          	auipc	ra,0x0
    800019a6:	83e080e7          	jalr	-1986(ra) # 800011e0 <walkaddr>
    if(pa0 == 0)
    800019aa:	cd01                	beqz	a0,800019c2 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800019ac:	418904b3          	sub	s1,s2,s8
    800019b0:	94d6                	add	s1,s1,s5
    800019b2:	fc99f2e3          	bgeu	s3,s1,80001976 <copyin+0x28>
    800019b6:	84ce                	mv	s1,s3
    800019b8:	bf7d                	j	80001976 <copyin+0x28>
  }
  return 0;
    800019ba:	4501                	li	a0,0
    800019bc:	a021                	j	800019c4 <copyin+0x76>
    800019be:	4501                	li	a0,0
}
    800019c0:	8082                	ret
      return -1;
    800019c2:	557d                	li	a0,-1
}
    800019c4:	60a6                	ld	ra,72(sp)
    800019c6:	6406                	ld	s0,64(sp)
    800019c8:	74e2                	ld	s1,56(sp)
    800019ca:	7942                	ld	s2,48(sp)
    800019cc:	79a2                	ld	s3,40(sp)
    800019ce:	7a02                	ld	s4,32(sp)
    800019d0:	6ae2                	ld	s5,24(sp)
    800019d2:	6b42                	ld	s6,16(sp)
    800019d4:	6ba2                	ld	s7,8(sp)
    800019d6:	6c02                	ld	s8,0(sp)
    800019d8:	6161                	addi	sp,sp,80
    800019da:	8082                	ret

00000000800019dc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800019dc:	c2dd                	beqz	a3,80001a82 <copyinstr+0xa6>
{
    800019de:	715d                	addi	sp,sp,-80
    800019e0:	e486                	sd	ra,72(sp)
    800019e2:	e0a2                	sd	s0,64(sp)
    800019e4:	fc26                	sd	s1,56(sp)
    800019e6:	f84a                	sd	s2,48(sp)
    800019e8:	f44e                	sd	s3,40(sp)
    800019ea:	f052                	sd	s4,32(sp)
    800019ec:	ec56                	sd	s5,24(sp)
    800019ee:	e85a                	sd	s6,16(sp)
    800019f0:	e45e                	sd	s7,8(sp)
    800019f2:	0880                	addi	s0,sp,80
    800019f4:	8a2a                	mv	s4,a0
    800019f6:	8b2e                	mv	s6,a1
    800019f8:	8bb2                	mv	s7,a2
    800019fa:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800019fc:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800019fe:	6985                	lui	s3,0x1
    80001a00:	a02d                	j	80001a2a <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001a02:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001a06:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001a08:	37fd                	addiw	a5,a5,-1
    80001a0a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001a0e:	60a6                	ld	ra,72(sp)
    80001a10:	6406                	ld	s0,64(sp)
    80001a12:	74e2                	ld	s1,56(sp)
    80001a14:	7942                	ld	s2,48(sp)
    80001a16:	79a2                	ld	s3,40(sp)
    80001a18:	7a02                	ld	s4,32(sp)
    80001a1a:	6ae2                	ld	s5,24(sp)
    80001a1c:	6b42                	ld	s6,16(sp)
    80001a1e:	6ba2                	ld	s7,8(sp)
    80001a20:	6161                	addi	sp,sp,80
    80001a22:	8082                	ret
    srcva = va0 + PGSIZE;
    80001a24:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001a28:	c8a9                	beqz	s1,80001a7a <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80001a2a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001a2e:	85ca                	mv	a1,s2
    80001a30:	8552                	mv	a0,s4
    80001a32:	fffff097          	auipc	ra,0xfffff
    80001a36:	7ae080e7          	jalr	1966(ra) # 800011e0 <walkaddr>
    if(pa0 == 0)
    80001a3a:	c131                	beqz	a0,80001a7e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001a3c:	417906b3          	sub	a3,s2,s7
    80001a40:	96ce                	add	a3,a3,s3
    80001a42:	00d4f363          	bgeu	s1,a3,80001a48 <copyinstr+0x6c>
    80001a46:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001a48:	955e                	add	a0,a0,s7
    80001a4a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001a4e:	daf9                	beqz	a3,80001a24 <copyinstr+0x48>
    80001a50:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001a52:	41650633          	sub	a2,a0,s6
    80001a56:	fff48593          	addi	a1,s1,-1
    80001a5a:	95da                	add	a1,a1,s6
    while(n > 0){
    80001a5c:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80001a5e:	00f60733          	add	a4,a2,a5
    80001a62:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fdbc848>
    80001a66:	df51                	beqz	a4,80001a02 <copyinstr+0x26>
        *dst = *p;
    80001a68:	00e78023          	sb	a4,0(a5)
      --max;
    80001a6c:	40f584b3          	sub	s1,a1,a5
      dst++;
    80001a70:	0785                	addi	a5,a5,1
    while(n > 0){
    80001a72:	fed796e3          	bne	a5,a3,80001a5e <copyinstr+0x82>
      dst++;
    80001a76:	8b3e                	mv	s6,a5
    80001a78:	b775                	j	80001a24 <copyinstr+0x48>
    80001a7a:	4781                	li	a5,0
    80001a7c:	b771                	j	80001a08 <copyinstr+0x2c>
      return -1;
    80001a7e:	557d                	li	a0,-1
    80001a80:	b779                	j	80001a0e <copyinstr+0x32>
  int got_null = 0;
    80001a82:	4781                	li	a5,0
  if(got_null){
    80001a84:	37fd                	addiw	a5,a5,-1
    80001a86:	0007851b          	sext.w	a0,a5
}
    80001a8a:	8082                	ret

0000000080001a8c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80001a8c:	7139                	addi	sp,sp,-64
    80001a8e:	fc06                	sd	ra,56(sp)
    80001a90:	f822                	sd	s0,48(sp)
    80001a92:	f426                	sd	s1,40(sp)
    80001a94:	f04a                	sd	s2,32(sp)
    80001a96:	ec4e                	sd	s3,24(sp)
    80001a98:	e852                	sd	s4,16(sp)
    80001a9a:	e456                	sd	s5,8(sp)
    80001a9c:	e05a                	sd	s6,0(sp)
    80001a9e:	0080                	addi	s0,sp,64
    80001aa0:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001aa2:	0022f497          	auipc	s1,0x22f
    80001aa6:	53648493          	addi	s1,s1,1334 # 80230fd8 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001aaa:	8b26                	mv	s6,s1
    80001aac:	00006a97          	auipc	s5,0x6
    80001ab0:	554a8a93          	addi	s5,s5,1364 # 80008000 <etext>
    80001ab4:	04000937          	lui	s2,0x4000
    80001ab8:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001aba:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001abc:	00236a17          	auipc	s4,0x236
    80001ac0:	91ca0a13          	addi	s4,s4,-1764 # 802373d8 <tickslock>
    char *pa = kalloc();
    80001ac4:	fffff097          	auipc	ra,0xfffff
    80001ac8:	18c080e7          	jalr	396(ra) # 80000c50 <kalloc>
    80001acc:	862a                	mv	a2,a0
    if (pa == 0)
    80001ace:	c131                	beqz	a0,80001b12 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80001ad0:	416485b3          	sub	a1,s1,s6
    80001ad4:	8591                	srai	a1,a1,0x4
    80001ad6:	000ab783          	ld	a5,0(s5)
    80001ada:	02f585b3          	mul	a1,a1,a5
    80001ade:	2585                	addiw	a1,a1,1 # fffffffffffff001 <end+0xffffffff7fdbc849>
    80001ae0:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001ae4:	4719                	li	a4,6
    80001ae6:	6685                	lui	a3,0x1
    80001ae8:	40b905b3          	sub	a1,s2,a1
    80001aec:	854e                	mv	a0,s3
    80001aee:	fffff097          	auipc	ra,0xfffff
    80001af2:	7d4080e7          	jalr	2004(ra) # 800012c2 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001af6:	19048493          	addi	s1,s1,400
    80001afa:	fd4495e3          	bne	s1,s4,80001ac4 <proc_mapstacks+0x38>
  }
}
    80001afe:	70e2                	ld	ra,56(sp)
    80001b00:	7442                	ld	s0,48(sp)
    80001b02:	74a2                	ld	s1,40(sp)
    80001b04:	7902                	ld	s2,32(sp)
    80001b06:	69e2                	ld	s3,24(sp)
    80001b08:	6a42                	ld	s4,16(sp)
    80001b0a:	6aa2                	ld	s5,8(sp)
    80001b0c:	6b02                	ld	s6,0(sp)
    80001b0e:	6121                	addi	sp,sp,64
    80001b10:	8082                	ret
      panic("kalloc");
    80001b12:	00006517          	auipc	a0,0x6
    80001b16:	74650513          	addi	a0,a0,1862 # 80008258 <digits+0x218>
    80001b1a:	fffff097          	auipc	ra,0xfffff
    80001b1e:	a26080e7          	jalr	-1498(ra) # 80000540 <panic>

0000000080001b22 <procinit>:

// initialize the proc table.
void procinit(void)
{
    80001b22:	7139                	addi	sp,sp,-64
    80001b24:	fc06                	sd	ra,56(sp)
    80001b26:	f822                	sd	s0,48(sp)
    80001b28:	f426                	sd	s1,40(sp)
    80001b2a:	f04a                	sd	s2,32(sp)
    80001b2c:	ec4e                	sd	s3,24(sp)
    80001b2e:	e852                	sd	s4,16(sp)
    80001b30:	e456                	sd	s5,8(sp)
    80001b32:	e05a                	sd	s6,0(sp)
    80001b34:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001b36:	00006597          	auipc	a1,0x6
    80001b3a:	72a58593          	addi	a1,a1,1834 # 80008260 <digits+0x220>
    80001b3e:	0022f517          	auipc	a0,0x22f
    80001b42:	06a50513          	addi	a0,a0,106 # 80230ba8 <pid_lock>
    80001b46:	fffff097          	auipc	ra,0xfffff
    80001b4a:	174080e7          	jalr	372(ra) # 80000cba <initlock>
  initlock(&wait_lock, "wait_lock");
    80001b4e:	00006597          	auipc	a1,0x6
    80001b52:	71a58593          	addi	a1,a1,1818 # 80008268 <digits+0x228>
    80001b56:	0022f517          	auipc	a0,0x22f
    80001b5a:	06a50513          	addi	a0,a0,106 # 80230bc0 <wait_lock>
    80001b5e:	fffff097          	auipc	ra,0xfffff
    80001b62:	15c080e7          	jalr	348(ra) # 80000cba <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001b66:	0022f497          	auipc	s1,0x22f
    80001b6a:	47248493          	addi	s1,s1,1138 # 80230fd8 <proc>
  {
    initlock(&p->lock, "proc");
    80001b6e:	00006b17          	auipc	s6,0x6
    80001b72:	70ab0b13          	addi	s6,s6,1802 # 80008278 <digits+0x238>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001b76:	8aa6                	mv	s5,s1
    80001b78:	00006a17          	auipc	s4,0x6
    80001b7c:	488a0a13          	addi	s4,s4,1160 # 80008000 <etext>
    80001b80:	04000937          	lui	s2,0x4000
    80001b84:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001b86:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001b88:	00236997          	auipc	s3,0x236
    80001b8c:	85098993          	addi	s3,s3,-1968 # 802373d8 <tickslock>
    initlock(&p->lock, "proc");
    80001b90:	85da                	mv	a1,s6
    80001b92:	8526                	mv	a0,s1
    80001b94:	fffff097          	auipc	ra,0xfffff
    80001b98:	126080e7          	jalr	294(ra) # 80000cba <initlock>
    p->state = UNUSED;
    80001b9c:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001ba0:	415487b3          	sub	a5,s1,s5
    80001ba4:	8791                	srai	a5,a5,0x4
    80001ba6:	000a3703          	ld	a4,0(s4)
    80001baa:	02e787b3          	mul	a5,a5,a4
    80001bae:	2785                	addiw	a5,a5,1
    80001bb0:	00d7979b          	slliw	a5,a5,0xd
    80001bb4:	40f907b3          	sub	a5,s2,a5
    80001bb8:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001bba:	19048493          	addi	s1,s1,400
    80001bbe:	fd3499e3          	bne	s1,s3,80001b90 <procinit+0x6e>
  }
}
    80001bc2:	70e2                	ld	ra,56(sp)
    80001bc4:	7442                	ld	s0,48(sp)
    80001bc6:	74a2                	ld	s1,40(sp)
    80001bc8:	7902                	ld	s2,32(sp)
    80001bca:	69e2                	ld	s3,24(sp)
    80001bcc:	6a42                	ld	s4,16(sp)
    80001bce:	6aa2                	ld	s5,8(sp)
    80001bd0:	6b02                	ld	s6,0(sp)
    80001bd2:	6121                	addi	sp,sp,64
    80001bd4:	8082                	ret

0000000080001bd6 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001bd6:	1141                	addi	sp,sp,-16
    80001bd8:	e422                	sd	s0,8(sp)
    80001bda:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bdc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001bde:	2501                	sext.w	a0,a0
    80001be0:	6422                	ld	s0,8(sp)
    80001be2:	0141                	addi	sp,sp,16
    80001be4:	8082                	ret

0000000080001be6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001be6:	1141                	addi	sp,sp,-16
    80001be8:	e422                	sd	s0,8(sp)
    80001bea:	0800                	addi	s0,sp,16
    80001bec:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001bee:	2781                	sext.w	a5,a5
    80001bf0:	079e                	slli	a5,a5,0x7
  return c;
}
    80001bf2:	0022f517          	auipc	a0,0x22f
    80001bf6:	fe650513          	addi	a0,a0,-26 # 80230bd8 <cpus>
    80001bfa:	953e                	add	a0,a0,a5
    80001bfc:	6422                	ld	s0,8(sp)
    80001bfe:	0141                	addi	sp,sp,16
    80001c00:	8082                	ret

0000000080001c02 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001c02:	1101                	addi	sp,sp,-32
    80001c04:	ec06                	sd	ra,24(sp)
    80001c06:	e822                	sd	s0,16(sp)
    80001c08:	e426                	sd	s1,8(sp)
    80001c0a:	1000                	addi	s0,sp,32
  push_off();
    80001c0c:	fffff097          	auipc	ra,0xfffff
    80001c10:	0f2080e7          	jalr	242(ra) # 80000cfe <push_off>
    80001c14:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001c16:	2781                	sext.w	a5,a5
    80001c18:	079e                	slli	a5,a5,0x7
    80001c1a:	0022f717          	auipc	a4,0x22f
    80001c1e:	f8e70713          	addi	a4,a4,-114 # 80230ba8 <pid_lock>
    80001c22:	97ba                	add	a5,a5,a4
    80001c24:	7b84                	ld	s1,48(a5)
  pop_off();
    80001c26:	fffff097          	auipc	ra,0xfffff
    80001c2a:	178080e7          	jalr	376(ra) # 80000d9e <pop_off>
  return p;
}
    80001c2e:	8526                	mv	a0,s1
    80001c30:	60e2                	ld	ra,24(sp)
    80001c32:	6442                	ld	s0,16(sp)
    80001c34:	64a2                	ld	s1,8(sp)
    80001c36:	6105                	addi	sp,sp,32
    80001c38:	8082                	ret

0000000080001c3a <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001c3a:	1141                	addi	sp,sp,-16
    80001c3c:	e406                	sd	ra,8(sp)
    80001c3e:	e022                	sd	s0,0(sp)
    80001c40:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001c42:	00000097          	auipc	ra,0x0
    80001c46:	fc0080e7          	jalr	-64(ra) # 80001c02 <myproc>
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	1b4080e7          	jalr	436(ra) # 80000dfe <release>

  if (first)
    80001c52:	00007797          	auipc	a5,0x7
    80001c56:	c2e7a783          	lw	a5,-978(a5) # 80008880 <first.1>
    80001c5a:	eb89                	bnez	a5,80001c6c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001c5c:	00001097          	auipc	ra,0x1
    80001c60:	f30080e7          	jalr	-208(ra) # 80002b8c <usertrapret>
}
    80001c64:	60a2                	ld	ra,8(sp)
    80001c66:	6402                	ld	s0,0(sp)
    80001c68:	0141                	addi	sp,sp,16
    80001c6a:	8082                	ret
    first = 0;
    80001c6c:	00007797          	auipc	a5,0x7
    80001c70:	c007aa23          	sw	zero,-1004(a5) # 80008880 <first.1>
    fsinit(ROOTDEV);
    80001c74:	4505                	li	a0,1
    80001c76:	00002097          	auipc	ra,0x2
    80001c7a:	e84080e7          	jalr	-380(ra) # 80003afa <fsinit>
    80001c7e:	bff9                	j	80001c5c <forkret+0x22>

0000000080001c80 <allocpid>:
{
    80001c80:	1101                	addi	sp,sp,-32
    80001c82:	ec06                	sd	ra,24(sp)
    80001c84:	e822                	sd	s0,16(sp)
    80001c86:	e426                	sd	s1,8(sp)
    80001c88:	e04a                	sd	s2,0(sp)
    80001c8a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001c8c:	0022f917          	auipc	s2,0x22f
    80001c90:	f1c90913          	addi	s2,s2,-228 # 80230ba8 <pid_lock>
    80001c94:	854a                	mv	a0,s2
    80001c96:	fffff097          	auipc	ra,0xfffff
    80001c9a:	0b4080e7          	jalr	180(ra) # 80000d4a <acquire>
  pid = nextpid;
    80001c9e:	00007797          	auipc	a5,0x7
    80001ca2:	be678793          	addi	a5,a5,-1050 # 80008884 <nextpid>
    80001ca6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ca8:	0014871b          	addiw	a4,s1,1
    80001cac:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001cae:	854a                	mv	a0,s2
    80001cb0:	fffff097          	auipc	ra,0xfffff
    80001cb4:	14e080e7          	jalr	334(ra) # 80000dfe <release>
}
    80001cb8:	8526                	mv	a0,s1
    80001cba:	60e2                	ld	ra,24(sp)
    80001cbc:	6442                	ld	s0,16(sp)
    80001cbe:	64a2                	ld	s1,8(sp)
    80001cc0:	6902                	ld	s2,0(sp)
    80001cc2:	6105                	addi	sp,sp,32
    80001cc4:	8082                	ret

0000000080001cc6 <proc_pagetable>:
{
    80001cc6:	1101                	addi	sp,sp,-32
    80001cc8:	ec06                	sd	ra,24(sp)
    80001cca:	e822                	sd	s0,16(sp)
    80001ccc:	e426                	sd	s1,8(sp)
    80001cce:	e04a                	sd	s2,0(sp)
    80001cd0:	1000                	addi	s0,sp,32
    80001cd2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001cd4:	00000097          	auipc	ra,0x0
    80001cd8:	890080e7          	jalr	-1904(ra) # 80001564 <uvmcreate>
    80001cdc:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001cde:	c121                	beqz	a0,80001d1e <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ce0:	4729                	li	a4,10
    80001ce2:	00005697          	auipc	a3,0x5
    80001ce6:	31e68693          	addi	a3,a3,798 # 80007000 <_trampoline>
    80001cea:	6605                	lui	a2,0x1
    80001cec:	040005b7          	lui	a1,0x4000
    80001cf0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001cf2:	05b2                	slli	a1,a1,0xc
    80001cf4:	fffff097          	auipc	ra,0xfffff
    80001cf8:	52e080e7          	jalr	1326(ra) # 80001222 <mappages>
    80001cfc:	02054863          	bltz	a0,80001d2c <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d00:	4719                	li	a4,6
    80001d02:	05893683          	ld	a3,88(s2)
    80001d06:	6605                	lui	a2,0x1
    80001d08:	020005b7          	lui	a1,0x2000
    80001d0c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d0e:	05b6                	slli	a1,a1,0xd
    80001d10:	8526                	mv	a0,s1
    80001d12:	fffff097          	auipc	ra,0xfffff
    80001d16:	510080e7          	jalr	1296(ra) # 80001222 <mappages>
    80001d1a:	02054163          	bltz	a0,80001d3c <proc_pagetable+0x76>
}
    80001d1e:	8526                	mv	a0,s1
    80001d20:	60e2                	ld	ra,24(sp)
    80001d22:	6442                	ld	s0,16(sp)
    80001d24:	64a2                	ld	s1,8(sp)
    80001d26:	6902                	ld	s2,0(sp)
    80001d28:	6105                	addi	sp,sp,32
    80001d2a:	8082                	ret
    uvmfree(pagetable, 0);
    80001d2c:	4581                	li	a1,0
    80001d2e:	8526                	mv	a0,s1
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	a3a080e7          	jalr	-1478(ra) # 8000176a <uvmfree>
    return 0;
    80001d38:	4481                	li	s1,0
    80001d3a:	b7d5                	j	80001d1e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d3c:	4681                	li	a3,0
    80001d3e:	4605                	li	a2,1
    80001d40:	040005b7          	lui	a1,0x4000
    80001d44:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d46:	05b2                	slli	a1,a1,0xc
    80001d48:	8526                	mv	a0,s1
    80001d4a:	fffff097          	auipc	ra,0xfffff
    80001d4e:	69e080e7          	jalr	1694(ra) # 800013e8 <uvmunmap>
    uvmfree(pagetable, 0);
    80001d52:	4581                	li	a1,0
    80001d54:	8526                	mv	a0,s1
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	a14080e7          	jalr	-1516(ra) # 8000176a <uvmfree>
    return 0;
    80001d5e:	4481                	li	s1,0
    80001d60:	bf7d                	j	80001d1e <proc_pagetable+0x58>

0000000080001d62 <proc_freepagetable>:
{
    80001d62:	1101                	addi	sp,sp,-32
    80001d64:	ec06                	sd	ra,24(sp)
    80001d66:	e822                	sd	s0,16(sp)
    80001d68:	e426                	sd	s1,8(sp)
    80001d6a:	e04a                	sd	s2,0(sp)
    80001d6c:	1000                	addi	s0,sp,32
    80001d6e:	84aa                	mv	s1,a0
    80001d70:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d72:	4681                	li	a3,0
    80001d74:	4605                	li	a2,1
    80001d76:	040005b7          	lui	a1,0x4000
    80001d7a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d7c:	05b2                	slli	a1,a1,0xc
    80001d7e:	fffff097          	auipc	ra,0xfffff
    80001d82:	66a080e7          	jalr	1642(ra) # 800013e8 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001d86:	4681                	li	a3,0
    80001d88:	4605                	li	a2,1
    80001d8a:	020005b7          	lui	a1,0x2000
    80001d8e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d90:	05b6                	slli	a1,a1,0xd
    80001d92:	8526                	mv	a0,s1
    80001d94:	fffff097          	auipc	ra,0xfffff
    80001d98:	654080e7          	jalr	1620(ra) # 800013e8 <uvmunmap>
  uvmfree(pagetable, sz);
    80001d9c:	85ca                	mv	a1,s2
    80001d9e:	8526                	mv	a0,s1
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	9ca080e7          	jalr	-1590(ra) # 8000176a <uvmfree>
}
    80001da8:	60e2                	ld	ra,24(sp)
    80001daa:	6442                	ld	s0,16(sp)
    80001dac:	64a2                	ld	s1,8(sp)
    80001dae:	6902                	ld	s2,0(sp)
    80001db0:	6105                	addi	sp,sp,32
    80001db2:	8082                	ret

0000000080001db4 <freeproc>:
{
    80001db4:	1101                	addi	sp,sp,-32
    80001db6:	ec06                	sd	ra,24(sp)
    80001db8:	e822                	sd	s0,16(sp)
    80001dba:	e426                	sd	s1,8(sp)
    80001dbc:	1000                	addi	s0,sp,32
    80001dbe:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001dc0:	6d28                	ld	a0,88(a0)
    80001dc2:	c509                	beqz	a0,80001dcc <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001dc4:	fffff097          	auipc	ra,0xfffff
    80001dc8:	cb4080e7          	jalr	-844(ra) # 80000a78 <kfree>
  p->trapframe = 0;
    80001dcc:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001dd0:	68a8                	ld	a0,80(s1)
    80001dd2:	c511                	beqz	a0,80001dde <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001dd4:	64ac                	ld	a1,72(s1)
    80001dd6:	00000097          	auipc	ra,0x0
    80001dda:	f8c080e7          	jalr	-116(ra) # 80001d62 <proc_freepagetable>
  p->pagetable = 0;
    80001dde:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001de2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001de6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001dea:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001dee:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001df2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001df6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001dfa:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001dfe:	0004ac23          	sw	zero,24(s1)
}
    80001e02:	60e2                	ld	ra,24(sp)
    80001e04:	6442                	ld	s0,16(sp)
    80001e06:	64a2                	ld	s1,8(sp)
    80001e08:	6105                	addi	sp,sp,32
    80001e0a:	8082                	ret

0000000080001e0c <allocproc>:
{
    80001e0c:	1101                	addi	sp,sp,-32
    80001e0e:	ec06                	sd	ra,24(sp)
    80001e10:	e822                	sd	s0,16(sp)
    80001e12:	e426                	sd	s1,8(sp)
    80001e14:	e04a                	sd	s2,0(sp)
    80001e16:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001e18:	0022f497          	auipc	s1,0x22f
    80001e1c:	1c048493          	addi	s1,s1,448 # 80230fd8 <proc>
    80001e20:	00235917          	auipc	s2,0x235
    80001e24:	5b890913          	addi	s2,s2,1464 # 802373d8 <tickslock>
    acquire(&p->lock);
    80001e28:	8526                	mv	a0,s1
    80001e2a:	fffff097          	auipc	ra,0xfffff
    80001e2e:	f20080e7          	jalr	-224(ra) # 80000d4a <acquire>
    if (p->state == UNUSED)
    80001e32:	4c9c                	lw	a5,24(s1)
    80001e34:	cf81                	beqz	a5,80001e4c <allocproc+0x40>
      release(&p->lock);
    80001e36:	8526                	mv	a0,s1
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	fc6080e7          	jalr	-58(ra) # 80000dfe <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001e40:	19048493          	addi	s1,s1,400
    80001e44:	ff2492e3          	bne	s1,s2,80001e28 <allocproc+0x1c>
  return 0;
    80001e48:	4481                	li	s1,0
    80001e4a:	a061                	j	80001ed2 <allocproc+0xc6>
  p->pid = allocpid();
    80001e4c:	00000097          	auipc	ra,0x0
    80001e50:	e34080e7          	jalr	-460(ra) # 80001c80 <allocpid>
    80001e54:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001e56:	4785                	li	a5,1
    80001e58:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001e5a:	fffff097          	auipc	ra,0xfffff
    80001e5e:	df6080e7          	jalr	-522(ra) # 80000c50 <kalloc>
    80001e62:	892a                	mv	s2,a0
    80001e64:	eca8                	sd	a0,88(s1)
    80001e66:	cd2d                	beqz	a0,80001ee0 <allocproc+0xd4>
  p->pagetable = proc_pagetable(p);
    80001e68:	8526                	mv	a0,s1
    80001e6a:	00000097          	auipc	ra,0x0
    80001e6e:	e5c080e7          	jalr	-420(ra) # 80001cc6 <proc_pagetable>
    80001e72:	892a                	mv	s2,a0
    80001e74:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001e76:	c149                	beqz	a0,80001ef8 <allocproc+0xec>
  memset(&p->context, 0, sizeof(p->context));
    80001e78:	07000613          	li	a2,112
    80001e7c:	4581                	li	a1,0
    80001e7e:	06048513          	addi	a0,s1,96
    80001e82:	fffff097          	auipc	ra,0xfffff
    80001e86:	fc4080e7          	jalr	-60(ra) # 80000e46 <memset>
  p->context.ra = (uint64)forkret;
    80001e8a:	00000797          	auipc	a5,0x0
    80001e8e:	db078793          	addi	a5,a5,-592 # 80001c3a <forkret>
    80001e92:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001e94:	60bc                	ld	a5,64(s1)
    80001e96:	6705                	lui	a4,0x1
    80001e98:	97ba                	add	a5,a5,a4
    80001e9a:	f4bc                	sd	a5,104(s1)
  p->rtime = 0;
    80001e9c:	1604a423          	sw	zero,360(s1)
  p->etime = 0;
    80001ea0:	1604a823          	sw	zero,368(s1)
  p->ctime = ticks;
    80001ea4:	00007797          	auipc	a5,0x7
    80001ea8:	a7c7a783          	lw	a5,-1412(a5) # 80008920 <ticks>
    80001eac:	16f4a623          	sw	a5,364(s1)
  p->my_wtime=0; //PBS
    80001eb0:	1604aa23          	sw	zero,372(s1)
  p->my_rtime=0;
    80001eb4:	1604ac23          	sw	zero,376(s1)
  p->my_stime=0;
    80001eb8:	1604ae23          	sw	zero,380(s1)
  p->static_pri=50;
    80001ebc:	03200793          	li	a5,50
    80001ec0:	18f4a023          	sw	a5,384(s1)
  p->rbi=25;
    80001ec4:	47e5                	li	a5,25
    80001ec6:	18f4a223          	sw	a5,388(s1)
  p->tot_sche=0;
    80001eca:	1804a423          	sw	zero,392(s1)
  p->curr_rbi=0;
    80001ece:	1804a623          	sw	zero,396(s1)
}
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	60e2                	ld	ra,24(sp)
    80001ed6:	6442                	ld	s0,16(sp)
    80001ed8:	64a2                	ld	s1,8(sp)
    80001eda:	6902                	ld	s2,0(sp)
    80001edc:	6105                	addi	sp,sp,32
    80001ede:	8082                	ret
    freeproc(p);
    80001ee0:	8526                	mv	a0,s1
    80001ee2:	00000097          	auipc	ra,0x0
    80001ee6:	ed2080e7          	jalr	-302(ra) # 80001db4 <freeproc>
    release(&p->lock);
    80001eea:	8526                	mv	a0,s1
    80001eec:	fffff097          	auipc	ra,0xfffff
    80001ef0:	f12080e7          	jalr	-238(ra) # 80000dfe <release>
    return 0;
    80001ef4:	84ca                	mv	s1,s2
    80001ef6:	bff1                	j	80001ed2 <allocproc+0xc6>
    freeproc(p);
    80001ef8:	8526                	mv	a0,s1
    80001efa:	00000097          	auipc	ra,0x0
    80001efe:	eba080e7          	jalr	-326(ra) # 80001db4 <freeproc>
    release(&p->lock);
    80001f02:	8526                	mv	a0,s1
    80001f04:	fffff097          	auipc	ra,0xfffff
    80001f08:	efa080e7          	jalr	-262(ra) # 80000dfe <release>
    return 0;
    80001f0c:	84ca                	mv	s1,s2
    80001f0e:	b7d1                	j	80001ed2 <allocproc+0xc6>

0000000080001f10 <userinit>:
{
    80001f10:	1101                	addi	sp,sp,-32
    80001f12:	ec06                	sd	ra,24(sp)
    80001f14:	e822                	sd	s0,16(sp)
    80001f16:	e426                	sd	s1,8(sp)
    80001f18:	1000                	addi	s0,sp,32
  p = allocproc();
    80001f1a:	00000097          	auipc	ra,0x0
    80001f1e:	ef2080e7          	jalr	-270(ra) # 80001e0c <allocproc>
    80001f22:	84aa                	mv	s1,a0
  initproc = p;
    80001f24:	00007797          	auipc	a5,0x7
    80001f28:	9ea7ba23          	sd	a0,-1548(a5) # 80008918 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001f2c:	03400613          	li	a2,52
    80001f30:	00007597          	auipc	a1,0x7
    80001f34:	96058593          	addi	a1,a1,-1696 # 80008890 <initcode>
    80001f38:	6928                	ld	a0,80(a0)
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	658080e7          	jalr	1624(ra) # 80001592 <uvmfirst>
  p->sz = PGSIZE;
    80001f42:	6785                	lui	a5,0x1
    80001f44:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001f46:	6cb8                	ld	a4,88(s1)
    80001f48:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001f4c:	6cb8                	ld	a4,88(s1)
    80001f4e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f50:	4641                	li	a2,16
    80001f52:	00006597          	auipc	a1,0x6
    80001f56:	32e58593          	addi	a1,a1,814 # 80008280 <digits+0x240>
    80001f5a:	15848513          	addi	a0,s1,344
    80001f5e:	fffff097          	auipc	ra,0xfffff
    80001f62:	032080e7          	jalr	50(ra) # 80000f90 <safestrcpy>
  p->cwd = namei("/");
    80001f66:	00006517          	auipc	a0,0x6
    80001f6a:	32a50513          	addi	a0,a0,810 # 80008290 <digits+0x250>
    80001f6e:	00002097          	auipc	ra,0x2
    80001f72:	5b6080e7          	jalr	1462(ra) # 80004524 <namei>
    80001f76:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001f7a:	478d                	li	a5,3
    80001f7c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001f7e:	8526                	mv	a0,s1
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	e7e080e7          	jalr	-386(ra) # 80000dfe <release>
}
    80001f88:	60e2                	ld	ra,24(sp)
    80001f8a:	6442                	ld	s0,16(sp)
    80001f8c:	64a2                	ld	s1,8(sp)
    80001f8e:	6105                	addi	sp,sp,32
    80001f90:	8082                	ret

0000000080001f92 <growproc>:
{
    80001f92:	1101                	addi	sp,sp,-32
    80001f94:	ec06                	sd	ra,24(sp)
    80001f96:	e822                	sd	s0,16(sp)
    80001f98:	e426                	sd	s1,8(sp)
    80001f9a:	e04a                	sd	s2,0(sp)
    80001f9c:	1000                	addi	s0,sp,32
    80001f9e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001fa0:	00000097          	auipc	ra,0x0
    80001fa4:	c62080e7          	jalr	-926(ra) # 80001c02 <myproc>
    80001fa8:	84aa                	mv	s1,a0
  sz = p->sz;
    80001faa:	652c                	ld	a1,72(a0)
  if (n > 0)
    80001fac:	01204c63          	bgtz	s2,80001fc4 <growproc+0x32>
  else if (n < 0)
    80001fb0:	02094663          	bltz	s2,80001fdc <growproc+0x4a>
  p->sz = sz;
    80001fb4:	e4ac                	sd	a1,72(s1)
  return 0;
    80001fb6:	4501                	li	a0,0
}
    80001fb8:	60e2                	ld	ra,24(sp)
    80001fba:	6442                	ld	s0,16(sp)
    80001fbc:	64a2                	ld	s1,8(sp)
    80001fbe:	6902                	ld	s2,0(sp)
    80001fc0:	6105                	addi	sp,sp,32
    80001fc2:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001fc4:	4691                	li	a3,4
    80001fc6:	00b90633          	add	a2,s2,a1
    80001fca:	6928                	ld	a0,80(a0)
    80001fcc:	fffff097          	auipc	ra,0xfffff
    80001fd0:	680080e7          	jalr	1664(ra) # 8000164c <uvmalloc>
    80001fd4:	85aa                	mv	a1,a0
    80001fd6:	fd79                	bnez	a0,80001fb4 <growproc+0x22>
      return -1;
    80001fd8:	557d                	li	a0,-1
    80001fda:	bff9                	j	80001fb8 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001fdc:	00b90633          	add	a2,s2,a1
    80001fe0:	6928                	ld	a0,80(a0)
    80001fe2:	fffff097          	auipc	ra,0xfffff
    80001fe6:	622080e7          	jalr	1570(ra) # 80001604 <uvmdealloc>
    80001fea:	85aa                	mv	a1,a0
    80001fec:	b7e1                	j	80001fb4 <growproc+0x22>

0000000080001fee <fork>:
{
    80001fee:	7139                	addi	sp,sp,-64
    80001ff0:	fc06                	sd	ra,56(sp)
    80001ff2:	f822                	sd	s0,48(sp)
    80001ff4:	f426                	sd	s1,40(sp)
    80001ff6:	f04a                	sd	s2,32(sp)
    80001ff8:	ec4e                	sd	s3,24(sp)
    80001ffa:	e852                	sd	s4,16(sp)
    80001ffc:	e456                	sd	s5,8(sp)
    80001ffe:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002000:	00000097          	auipc	ra,0x0
    80002004:	c02080e7          	jalr	-1022(ra) # 80001c02 <myproc>
    80002008:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    8000200a:	00000097          	auipc	ra,0x0
    8000200e:	e02080e7          	jalr	-510(ra) # 80001e0c <allocproc>
    80002012:	c17d                	beqz	a0,800020f8 <fork+0x10a>
    80002014:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002016:	048ab603          	ld	a2,72(s5)
    8000201a:	692c                	ld	a1,80(a0)
    8000201c:	050ab503          	ld	a0,80(s5)
    80002020:	fffff097          	auipc	ra,0xfffff
    80002024:	784080e7          	jalr	1924(ra) # 800017a4 <uvmcopy>
    80002028:	04054a63          	bltz	a0,8000207c <fork+0x8e>
  np->sz = p->sz;
    8000202c:	048ab783          	ld	a5,72(s5)
    80002030:	04fa3423          	sd	a5,72(s4)
  np->parent=p; //added for cow
    80002034:	035a3c23          	sd	s5,56(s4)
  *(np->trapframe) = *(p->trapframe);
    80002038:	058ab683          	ld	a3,88(s5)
    8000203c:	87b6                	mv	a5,a3
    8000203e:	058a3703          	ld	a4,88(s4)
    80002042:	12068693          	addi	a3,a3,288
    80002046:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000204a:	6788                	ld	a0,8(a5)
    8000204c:	6b8c                	ld	a1,16(a5)
    8000204e:	6f90                	ld	a2,24(a5)
    80002050:	01073023          	sd	a6,0(a4)
    80002054:	e708                	sd	a0,8(a4)
    80002056:	eb0c                	sd	a1,16(a4)
    80002058:	ef10                	sd	a2,24(a4)
    8000205a:	02078793          	addi	a5,a5,32
    8000205e:	02070713          	addi	a4,a4,32
    80002062:	fed792e3          	bne	a5,a3,80002046 <fork+0x58>
  np->trapframe->a0 = 0;
    80002066:	058a3783          	ld	a5,88(s4)
    8000206a:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000206e:	0d0a8493          	addi	s1,s5,208
    80002072:	0d0a0913          	addi	s2,s4,208
    80002076:	150a8993          	addi	s3,s5,336
    8000207a:	a00d                	j	8000209c <fork+0xae>
    freeproc(np);
    8000207c:	8552                	mv	a0,s4
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	d36080e7          	jalr	-714(ra) # 80001db4 <freeproc>
    release(&np->lock);
    80002086:	8552                	mv	a0,s4
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	d76080e7          	jalr	-650(ra) # 80000dfe <release>
    return -1;
    80002090:	54fd                	li	s1,-1
    80002092:	a889                	j	800020e4 <fork+0xf6>
  for (i = 0; i < NOFILE; i++)
    80002094:	04a1                	addi	s1,s1,8
    80002096:	0921                	addi	s2,s2,8
    80002098:	01348b63          	beq	s1,s3,800020ae <fork+0xc0>
    if (p->ofile[i])
    8000209c:	6088                	ld	a0,0(s1)
    8000209e:	d97d                	beqz	a0,80002094 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800020a0:	00003097          	auipc	ra,0x3
    800020a4:	b1a080e7          	jalr	-1254(ra) # 80004bba <filedup>
    800020a8:	00a93023          	sd	a0,0(s2)
    800020ac:	b7e5                	j	80002094 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800020ae:	150ab503          	ld	a0,336(s5)
    800020b2:	00002097          	auipc	ra,0x2
    800020b6:	c88080e7          	jalr	-888(ra) # 80003d3a <idup>
    800020ba:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800020be:	4641                	li	a2,16
    800020c0:	158a8593          	addi	a1,s5,344
    800020c4:	158a0513          	addi	a0,s4,344
    800020c8:	fffff097          	auipc	ra,0xfffff
    800020cc:	ec8080e7          	jalr	-312(ra) # 80000f90 <safestrcpy>
  pid = np->pid;
    800020d0:	030a2483          	lw	s1,48(s4)
  np->state = RUNNABLE;
    800020d4:	478d                	li	a5,3
    800020d6:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800020da:	8552                	mv	a0,s4
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	d22080e7          	jalr	-734(ra) # 80000dfe <release>
}
    800020e4:	8526                	mv	a0,s1
    800020e6:	70e2                	ld	ra,56(sp)
    800020e8:	7442                	ld	s0,48(sp)
    800020ea:	74a2                	ld	s1,40(sp)
    800020ec:	7902                	ld	s2,32(sp)
    800020ee:	69e2                	ld	s3,24(sp)
    800020f0:	6a42                	ld	s4,16(sp)
    800020f2:	6aa2                	ld	s5,8(sp)
    800020f4:	6121                	addi	sp,sp,64
    800020f6:	8082                	ret
    return -1;
    800020f8:	54fd                	li	s1,-1
    800020fa:	b7ed                	j	800020e4 <fork+0xf6>

00000000800020fc <_rbi>:
int _rbi(struct proc *p){
    800020fc:	1141                	addi	sp,sp,-16
    800020fe:	e422                	sd	s0,8(sp)
    80002100:	0800                	addi	s0,sp,16
    80002102:	872a                	mv	a4,a0
   if(p->rbi==25){ //rbi like FLAG
    80002104:	18452503          	lw	a0,388(a0)
    80002108:	47e5                	li	a5,25
    8000210a:	04f50063          	beq	a0,a5,8000214a <_rbi+0x4e>
   int a= 50*((3*p->my_rtime - p->my_stime - p->my_wtime)/(p->my_rtime+p->my_wtime+p->my_stime+1));
    8000210e:	17872783          	lw	a5,376(a4)
    80002112:	17c72683          	lw	a3,380(a4)
    80002116:	17472703          	lw	a4,372(a4)
    8000211a:	0017951b          	slliw	a0,a5,0x1
    8000211e:	9d3d                	addw	a0,a0,a5
    80002120:	9d15                	subw	a0,a0,a3
    80002122:	9d19                	subw	a0,a0,a4
    80002124:	9fb5                	addw	a5,a5,a3
    80002126:	2785                	addiw	a5,a5,1
    80002128:	9fb9                	addw	a5,a5,a4
    8000212a:	02f5553b          	divuw	a0,a0,a5
    8000212e:	03200793          	li	a5,50
    80002132:	02f5053b          	mulw	a0,a0,a5
    80002136:	0005079b          	sext.w	a5,a0
    8000213a:	fff7c793          	not	a5,a5
    8000213e:	97fd                	srai	a5,a5,0x3f
    80002140:	8d7d                	and	a0,a0,a5
    80002142:	2501                	sext.w	a0,a0
}
    80002144:	6422                	ld	s0,8(sp)
    80002146:	0141                	addi	sp,sp,16
    80002148:	8082                	ret
      p->rbi=-1;
    8000214a:	57fd                	li	a5,-1
    8000214c:	18f72223          	sw	a5,388(a4)
      return 25; //so next iteration it returns below calculated
    80002150:	bfd5                	j	80002144 <_rbi+0x48>

0000000080002152 <min>:
int min(int a,int b){
    80002152:	1141                	addi	sp,sp,-16
    80002154:	e422                	sd	s0,8(sp)
    80002156:	0800                	addi	s0,sp,16
}
    80002158:	87aa                	mv	a5,a0
    8000215a:	00a5d363          	bge	a1,a0,80002160 <min+0xe>
    8000215e:	87ae                	mv	a5,a1
    80002160:	0007851b          	sext.w	a0,a5
    80002164:	6422                	ld	s0,8(sp)
    80002166:	0141                	addi	sp,sp,16
    80002168:	8082                	ret

000000008000216a <scheduler>:
{
    8000216a:	711d                	addi	sp,sp,-96
    8000216c:	ec86                	sd	ra,88(sp)
    8000216e:	e8a2                	sd	s0,80(sp)
    80002170:	e4a6                	sd	s1,72(sp)
    80002172:	e0ca                	sd	s2,64(sp)
    80002174:	fc4e                	sd	s3,56(sp)
    80002176:	f852                	sd	s4,48(sp)
    80002178:	f456                	sd	s5,40(sp)
    8000217a:	f05a                	sd	s6,32(sp)
    8000217c:	ec5e                	sd	s7,24(sp)
    8000217e:	e862                	sd	s8,16(sp)
    80002180:	e466                	sd	s9,8(sp)
    80002182:	1080                	addi	s0,sp,96
    80002184:	8492                	mv	s1,tp
  int id = r_tp();
    80002186:	2481                	sext.w	s1,s1
  c->proc = 0;
    80002188:	00749c13          	slli	s8,s1,0x7
    8000218c:	0022f797          	auipc	a5,0x22f
    80002190:	a1c78793          	addi	a5,a5,-1508 # 80230ba8 <pid_lock>
    80002194:	97e2                	add	a5,a5,s8
    80002196:	0207b823          	sd	zero,48(a5)
  printf("open PBS\n");
    8000219a:	00006517          	auipc	a0,0x6
    8000219e:	0fe50513          	addi	a0,a0,254 # 80008298 <digits+0x258>
    800021a2:	ffffe097          	auipc	ra,0xffffe
    800021a6:	3e8080e7          	jalr	1000(ra) # 8000058a <printf>
          swtch(&c->context , &high_pri->context); //allocate the cpu's resources 
    800021aa:	0022f797          	auipc	a5,0x22f
    800021ae:	a3678793          	addi	a5,a5,-1482 # 80230be0 <cpus+0x8>
    800021b2:	9c3e                	add	s8,s8,a5
  if(a<b){return a;}
    800021b4:	06300a93          	li	s5,99
    return b;
    800021b8:	06400b13          	li	s6,100
      for (p = proc; p < &proc[NPROC]; p++)
    800021bc:	00235a17          	auipc	s4,0x235
    800021c0:	21ca0a13          	addi	s4,s4,540 # 802373d8 <tickslock>
          c->proc =high_pri;   // change the cpu's process to the one found 
    800021c4:	049e                	slli	s1,s1,0x7
    800021c6:	0022fb97          	auipc	s7,0x22f
    800021ca:	9e2b8b93          	addi	s7,s7,-1566 # 80230ba8 <pid_lock>
    800021ce:	9ba6                	add	s7,s7,s1
          p->tot_sche++ ; //total time process is scheduled***
    800021d0:	00235c97          	auipc	s9,0x235
    800021d4:	e08c8c93          	addi	s9,s9,-504 # 80236fd8 <proc+0x6000>
    800021d8:	a069                	j	80002262 <scheduler+0xf8>
    return b;
    800021da:	87da                	mv	a5,s6
            else if( min(p->static_pri+ p->curr_rbi,100) < min(high_pri->static_pri + high_pri->curr_rbi,100) ){
    800021dc:	04e7cc63          	blt	a5,a4,80002234 <scheduler+0xca>
            else if( min(p->static_pri+ p->curr_rbi,100) == min(high_pri->static_pri + high_pri->curr_rbi,100) &&  (p->tot_sche > high_pri->tot_sche) ){
    800021e0:	0cf70e63          	beq	a4,a5,800022bc <scheduler+0x152>
          release(&p->lock);
    800021e4:	8526                	mv	a0,s1
    800021e6:	fffff097          	auipc	ra,0xfffff
    800021ea:	c18080e7          	jalr	-1000(ra) # 80000dfe <release>
      for (p = proc; p < &proc[NPROC]; p++)
    800021ee:	19048493          	addi	s1,s1,400
    800021f2:	07448163          	beq	s1,s4,80002254 <scheduler+0xea>
          p->curr_rbi=_rbi(p); //find curr_rbi before comparing
    800021f6:	8526                	mv	a0,s1
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	f04080e7          	jalr	-252(ra) # 800020fc <_rbi>
    80002200:	18a4a623          	sw	a0,396(s1)
          acquire(&p->lock); /// * without locking p ,we cant see if it's runnable or not* /         
    80002204:	8526                	mv	a0,s1
    80002206:	fffff097          	auipc	ra,0xfffff
    8000220a:	b44080e7          	jalr	-1212(ra) # 80000d4a <acquire>
          if (p->state == RUNNABLE)
    8000220e:	4c9c                	lw	a5,24(s1)
    80002210:	fd379ae3          	bne	a5,s3,800021e4 <scheduler+0x7a>
            if(high_pri==0){
    80002214:	02090e63          	beqz	s2,80002250 <scheduler+0xe6>
            else if( min(p->static_pri+ p->curr_rbi,100) < min(high_pri->static_pri + high_pri->curr_rbi,100) ){
    80002218:	1804a703          	lw	a4,384(s1)
    8000221c:	18c4a783          	lw	a5,396(s1)
    80002220:	9fb9                	addw	a5,a5,a4
  if(a<b){return a;}
    80002222:	08fac663          	blt	s5,a5,800022ae <scheduler+0x144>
            else if( min(p->static_pri+ p->curr_rbi,100) < min(high_pri->static_pri + high_pri->curr_rbi,100) ){
    80002226:	18092683          	lw	a3,384(s2)
    8000222a:	18c92703          	lw	a4,396(s2)
    8000222e:	9f35                	addw	a4,a4,a3
  if(a<b){return a;}
    80002230:	faead6e3          	bge	s5,a4,800021dc <scheduler+0x72>
                release(&high_pri->lock);
    80002234:	854a                	mv	a0,s2
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	bc8080e7          	jalr	-1080(ra) # 80000dfe <release>
                continue;
    8000223e:	8926                	mv	s2,s1
    80002240:	b77d                	j	800021ee <scheduler+0x84>
                 release(&high_pri->lock);
    80002242:	854a                	mv	a0,s2
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	bba080e7          	jalr	-1094(ra) # 80000dfe <release>
                continue;
    8000224c:	8926                	mv	s2,s1
    8000224e:	b745                	j	800021ee <scheduler+0x84>
    80002250:	8926                	mv	s2,s1
    80002252:	bf71                	j	800021ee <scheduler+0x84>
      if(high_pri!=0 && high_pri->state==RUNNABLE){
    80002254:	00090763          	beqz	s2,80002262 <scheduler+0xf8>
    80002258:	01892703          	lw	a4,24(s2)
    8000225c:	478d                	li	a5,3
    8000225e:	00f70f63          	beq	a4,a5,8000227c <scheduler+0x112>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002262:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002266:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000226a:	10079073          	csrw	sstatus,a5
      struct proc* high_pri=0;//high_pri=0;      
    8000226e:	4901                	li	s2,0
      for (p = proc; p < &proc[NPROC]; p++)
    80002270:	0022f497          	auipc	s1,0x22f
    80002274:	d6848493          	addi	s1,s1,-664 # 80230fd8 <proc>
          if (p->state == RUNNABLE)
    80002278:	498d                	li	s3,3
    8000227a:	bfb5                	j	800021f6 <scheduler+0x8c>
          high_pri ->state= RUNNING; //change state of high_pri
    8000227c:	4791                	li	a5,4
    8000227e:	00f92c23          	sw	a5,24(s2)
          c->proc =high_pri;   // change the cpu's process to the one found 
    80002282:	032bb823          	sd	s2,48(s7)
          swtch(&c->context , &high_pri->context); //allocate the cpu's resources 
    80002286:	06090593          	addi	a1,s2,96
    8000228a:	8562                	mv	a0,s8
    8000228c:	00001097          	auipc	ra,0x1
    80002290:	856080e7          	jalr	-1962(ra) # 80002ae2 <swtch>
          p->tot_sche++ ; //total time process is scheduled***
    80002294:	588ca783          	lw	a5,1416(s9)
    80002298:	2785                	addiw	a5,a5,1
    8000229a:	58fca423          	sw	a5,1416(s9)
          c->proc=0;
    8000229e:	020bb823          	sd	zero,48(s7)
          release(&high_pri->lock);
    800022a2:	854a                	mv	a0,s2
    800022a4:	fffff097          	auipc	ra,0xfffff
    800022a8:	b5a080e7          	jalr	-1190(ra) # 80000dfe <release>
    800022ac:	bf5d                	j	80002262 <scheduler+0xf8>
            else if( min(p->static_pri+ p->curr_rbi,100) < min(high_pri->static_pri + high_pri->curr_rbi,100) ){
    800022ae:	18092783          	lw	a5,384(s2)
    800022b2:	18c92703          	lw	a4,396(s2)
    800022b6:	9f3d                	addw	a4,a4,a5
  if(a<b){return a;}
    800022b8:	f2ead1e3          	bge	s5,a4,800021da <scheduler+0x70>
            else if( min(p->static_pri+ p->curr_rbi,100) == min(high_pri->static_pri + high_pri->curr_rbi,100) &&  (p->tot_sche > high_pri->tot_sche) ){
    800022bc:	1884a703          	lw	a4,392(s1)
    800022c0:	18892783          	lw	a5,392(s2)
    800022c4:	f6e7cfe3          	blt	a5,a4,80002242 <scheduler+0xd8>
            else if(  min(p->static_pri+ p->curr_rbi,100) == min(high_pri->static_pri + high_pri->curr_rbi,100) &&  (p->tot_sche == high_pri->tot_sche) && (p->ctime < high_pri->ctime) ){
    800022c8:	f0f71ee3          	bne	a4,a5,800021e4 <scheduler+0x7a>
    800022cc:	16c4a703          	lw	a4,364(s1)
    800022d0:	16c92783          	lw	a5,364(s2)
    800022d4:	f0f778e3          	bgeu	a4,a5,800021e4 <scheduler+0x7a>
                  release(&high_pri->lock);
    800022d8:	854a                	mv	a0,s2
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	b24080e7          	jalr	-1244(ra) # 80000dfe <release>
                continue;
    800022e2:	8926                	mv	s2,s1
    800022e4:	b729                	j	800021ee <scheduler+0x84>

00000000800022e6 <sched>:
{
    800022e6:	7179                	addi	sp,sp,-48
    800022e8:	f406                	sd	ra,40(sp)
    800022ea:	f022                	sd	s0,32(sp)
    800022ec:	ec26                	sd	s1,24(sp)
    800022ee:	e84a                	sd	s2,16(sp)
    800022f0:	e44e                	sd	s3,8(sp)
    800022f2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800022f4:	00000097          	auipc	ra,0x0
    800022f8:	90e080e7          	jalr	-1778(ra) # 80001c02 <myproc>
    800022fc:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    800022fe:	fffff097          	auipc	ra,0xfffff
    80002302:	9d2080e7          	jalr	-1582(ra) # 80000cd0 <holding>
    80002306:	c93d                	beqz	a0,8000237c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002308:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    8000230a:	2781                	sext.w	a5,a5
    8000230c:	079e                	slli	a5,a5,0x7
    8000230e:	0022f717          	auipc	a4,0x22f
    80002312:	89a70713          	addi	a4,a4,-1894 # 80230ba8 <pid_lock>
    80002316:	97ba                	add	a5,a5,a4
    80002318:	0a87a703          	lw	a4,168(a5)
    8000231c:	4785                	li	a5,1
    8000231e:	06f71763          	bne	a4,a5,8000238c <sched+0xa6>
  if (p->state == RUNNING)
    80002322:	4c98                	lw	a4,24(s1)
    80002324:	4791                	li	a5,4
    80002326:	06f70b63          	beq	a4,a5,8000239c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000232a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000232e:	8b89                	andi	a5,a5,2
  if (intr_get())
    80002330:	efb5                	bnez	a5,800023ac <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002332:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002334:	0022f917          	auipc	s2,0x22f
    80002338:	87490913          	addi	s2,s2,-1932 # 80230ba8 <pid_lock>
    8000233c:	2781                	sext.w	a5,a5
    8000233e:	079e                	slli	a5,a5,0x7
    80002340:	97ca                	add	a5,a5,s2
    80002342:	0ac7a983          	lw	s3,172(a5)
    80002346:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002348:	2781                	sext.w	a5,a5
    8000234a:	079e                	slli	a5,a5,0x7
    8000234c:	0022f597          	auipc	a1,0x22f
    80002350:	89458593          	addi	a1,a1,-1900 # 80230be0 <cpus+0x8>
    80002354:	95be                	add	a1,a1,a5
    80002356:	06048513          	addi	a0,s1,96
    8000235a:	00000097          	auipc	ra,0x0
    8000235e:	788080e7          	jalr	1928(ra) # 80002ae2 <swtch>
    80002362:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002364:	2781                	sext.w	a5,a5
    80002366:	079e                	slli	a5,a5,0x7
    80002368:	993e                	add	s2,s2,a5
    8000236a:	0b392623          	sw	s3,172(s2)
}
    8000236e:	70a2                	ld	ra,40(sp)
    80002370:	7402                	ld	s0,32(sp)
    80002372:	64e2                	ld	s1,24(sp)
    80002374:	6942                	ld	s2,16(sp)
    80002376:	69a2                	ld	s3,8(sp)
    80002378:	6145                	addi	sp,sp,48
    8000237a:	8082                	ret
    panic("sched p->lock");
    8000237c:	00006517          	auipc	a0,0x6
    80002380:	f2c50513          	addi	a0,a0,-212 # 800082a8 <digits+0x268>
    80002384:	ffffe097          	auipc	ra,0xffffe
    80002388:	1bc080e7          	jalr	444(ra) # 80000540 <panic>
    panic("sched locks");
    8000238c:	00006517          	auipc	a0,0x6
    80002390:	f2c50513          	addi	a0,a0,-212 # 800082b8 <digits+0x278>
    80002394:	ffffe097          	auipc	ra,0xffffe
    80002398:	1ac080e7          	jalr	428(ra) # 80000540 <panic>
    panic("sched running");
    8000239c:	00006517          	auipc	a0,0x6
    800023a0:	f2c50513          	addi	a0,a0,-212 # 800082c8 <digits+0x288>
    800023a4:	ffffe097          	auipc	ra,0xffffe
    800023a8:	19c080e7          	jalr	412(ra) # 80000540 <panic>
    panic("sched interruptible");
    800023ac:	00006517          	auipc	a0,0x6
    800023b0:	f2c50513          	addi	a0,a0,-212 # 800082d8 <digits+0x298>
    800023b4:	ffffe097          	auipc	ra,0xffffe
    800023b8:	18c080e7          	jalr	396(ra) # 80000540 <panic>

00000000800023bc <yield>:
{
    800023bc:	1101                	addi	sp,sp,-32
    800023be:	ec06                	sd	ra,24(sp)
    800023c0:	e822                	sd	s0,16(sp)
    800023c2:	e426                	sd	s1,8(sp)
    800023c4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800023c6:	00000097          	auipc	ra,0x0
    800023ca:	83c080e7          	jalr	-1988(ra) # 80001c02 <myproc>
    800023ce:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	97a080e7          	jalr	-1670(ra) # 80000d4a <acquire>
  p->state = RUNNABLE;
    800023d8:	478d                	li	a5,3
    800023da:	cc9c                	sw	a5,24(s1)
  sched();
    800023dc:	00000097          	auipc	ra,0x0
    800023e0:	f0a080e7          	jalr	-246(ra) # 800022e6 <sched>
  release(&p->lock);
    800023e4:	8526                	mv	a0,s1
    800023e6:	fffff097          	auipc	ra,0xfffff
    800023ea:	a18080e7          	jalr	-1512(ra) # 80000dfe <release>
}
    800023ee:	60e2                	ld	ra,24(sp)
    800023f0:	6442                	ld	s0,16(sp)
    800023f2:	64a2                	ld	s1,8(sp)
    800023f4:	6105                	addi	sp,sp,32
    800023f6:	8082                	ret

00000000800023f8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800023f8:	7179                	addi	sp,sp,-48
    800023fa:	f406                	sd	ra,40(sp)
    800023fc:	f022                	sd	s0,32(sp)
    800023fe:	ec26                	sd	s1,24(sp)
    80002400:	e84a                	sd	s2,16(sp)
    80002402:	e44e                	sd	s3,8(sp)
    80002404:	1800                	addi	s0,sp,48
    80002406:	89aa                	mv	s3,a0
    80002408:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000240a:	fffff097          	auipc	ra,0xfffff
    8000240e:	7f8080e7          	jalr	2040(ra) # 80001c02 <myproc>
    80002412:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    80002414:	fffff097          	auipc	ra,0xfffff
    80002418:	936080e7          	jalr	-1738(ra) # 80000d4a <acquire>
  release(lk);
    8000241c:	854a                	mv	a0,s2
    8000241e:	fffff097          	auipc	ra,0xfffff
    80002422:	9e0080e7          	jalr	-1568(ra) # 80000dfe <release>

  // Go to sleep.
  p->chan = chan;
    80002426:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000242a:	4789                	li	a5,2
    8000242c:	cc9c                	sw	a5,24(s1)

  sched();
    8000242e:	00000097          	auipc	ra,0x0
    80002432:	eb8080e7          	jalr	-328(ra) # 800022e6 <sched>

  // Tidy up.
  p->chan = 0;
    80002436:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000243a:	8526                	mv	a0,s1
    8000243c:	fffff097          	auipc	ra,0xfffff
    80002440:	9c2080e7          	jalr	-1598(ra) # 80000dfe <release>
  acquire(lk);
    80002444:	854a                	mv	a0,s2
    80002446:	fffff097          	auipc	ra,0xfffff
    8000244a:	904080e7          	jalr	-1788(ra) # 80000d4a <acquire>
}
    8000244e:	70a2                	ld	ra,40(sp)
    80002450:	7402                	ld	s0,32(sp)
    80002452:	64e2                	ld	s1,24(sp)
    80002454:	6942                	ld	s2,16(sp)
    80002456:	69a2                	ld	s3,8(sp)
    80002458:	6145                	addi	sp,sp,48
    8000245a:	8082                	ret

000000008000245c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000245c:	7139                	addi	sp,sp,-64
    8000245e:	fc06                	sd	ra,56(sp)
    80002460:	f822                	sd	s0,48(sp)
    80002462:	f426                	sd	s1,40(sp)
    80002464:	f04a                	sd	s2,32(sp)
    80002466:	ec4e                	sd	s3,24(sp)
    80002468:	e852                	sd	s4,16(sp)
    8000246a:	e456                	sd	s5,8(sp)
    8000246c:	0080                	addi	s0,sp,64
    8000246e:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002470:	0022f497          	auipc	s1,0x22f
    80002474:	b6848493          	addi	s1,s1,-1176 # 80230fd8 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    80002478:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    8000247a:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    8000247c:	00235917          	auipc	s2,0x235
    80002480:	f5c90913          	addi	s2,s2,-164 # 802373d8 <tickslock>
    80002484:	a811                	j	80002498 <wakeup+0x3c>
      }
      release(&p->lock);
    80002486:	8526                	mv	a0,s1
    80002488:	fffff097          	auipc	ra,0xfffff
    8000248c:	976080e7          	jalr	-1674(ra) # 80000dfe <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002490:	19048493          	addi	s1,s1,400
    80002494:	03248663          	beq	s1,s2,800024c0 <wakeup+0x64>
    if (p != myproc())
    80002498:	fffff097          	auipc	ra,0xfffff
    8000249c:	76a080e7          	jalr	1898(ra) # 80001c02 <myproc>
    800024a0:	fea488e3          	beq	s1,a0,80002490 <wakeup+0x34>
      acquire(&p->lock);
    800024a4:	8526                	mv	a0,s1
    800024a6:	fffff097          	auipc	ra,0xfffff
    800024aa:	8a4080e7          	jalr	-1884(ra) # 80000d4a <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    800024ae:	4c9c                	lw	a5,24(s1)
    800024b0:	fd379be3          	bne	a5,s3,80002486 <wakeup+0x2a>
    800024b4:	709c                	ld	a5,32(s1)
    800024b6:	fd4798e3          	bne	a5,s4,80002486 <wakeup+0x2a>
        p->state = RUNNABLE;
    800024ba:	0154ac23          	sw	s5,24(s1)
    800024be:	b7e1                	j	80002486 <wakeup+0x2a>
    }
  }
}
    800024c0:	70e2                	ld	ra,56(sp)
    800024c2:	7442                	ld	s0,48(sp)
    800024c4:	74a2                	ld	s1,40(sp)
    800024c6:	7902                	ld	s2,32(sp)
    800024c8:	69e2                	ld	s3,24(sp)
    800024ca:	6a42                	ld	s4,16(sp)
    800024cc:	6aa2                	ld	s5,8(sp)
    800024ce:	6121                	addi	sp,sp,64
    800024d0:	8082                	ret

00000000800024d2 <reparent>:
{
    800024d2:	7179                	addi	sp,sp,-48
    800024d4:	f406                	sd	ra,40(sp)
    800024d6:	f022                	sd	s0,32(sp)
    800024d8:	ec26                	sd	s1,24(sp)
    800024da:	e84a                	sd	s2,16(sp)
    800024dc:	e44e                	sd	s3,8(sp)
    800024de:	e052                	sd	s4,0(sp)
    800024e0:	1800                	addi	s0,sp,48
    800024e2:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800024e4:	0022f497          	auipc	s1,0x22f
    800024e8:	af448493          	addi	s1,s1,-1292 # 80230fd8 <proc>
      pp->parent = initproc;
    800024ec:	00006a17          	auipc	s4,0x6
    800024f0:	42ca0a13          	addi	s4,s4,1068 # 80008918 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800024f4:	00235997          	auipc	s3,0x235
    800024f8:	ee498993          	addi	s3,s3,-284 # 802373d8 <tickslock>
    800024fc:	a029                	j	80002506 <reparent+0x34>
    800024fe:	19048493          	addi	s1,s1,400
    80002502:	01348d63          	beq	s1,s3,8000251c <reparent+0x4a>
    if (pp->parent == p)
    80002506:	7c9c                	ld	a5,56(s1)
    80002508:	ff279be3          	bne	a5,s2,800024fe <reparent+0x2c>
      pp->parent = initproc;
    8000250c:	000a3503          	ld	a0,0(s4)
    80002510:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002512:	00000097          	auipc	ra,0x0
    80002516:	f4a080e7          	jalr	-182(ra) # 8000245c <wakeup>
    8000251a:	b7d5                	j	800024fe <reparent+0x2c>
}
    8000251c:	70a2                	ld	ra,40(sp)
    8000251e:	7402                	ld	s0,32(sp)
    80002520:	64e2                	ld	s1,24(sp)
    80002522:	6942                	ld	s2,16(sp)
    80002524:	69a2                	ld	s3,8(sp)
    80002526:	6a02                	ld	s4,0(sp)
    80002528:	6145                	addi	sp,sp,48
    8000252a:	8082                	ret

000000008000252c <exit>:
{
    8000252c:	7179                	addi	sp,sp,-48
    8000252e:	f406                	sd	ra,40(sp)
    80002530:	f022                	sd	s0,32(sp)
    80002532:	ec26                	sd	s1,24(sp)
    80002534:	e84a                	sd	s2,16(sp)
    80002536:	e44e                	sd	s3,8(sp)
    80002538:	e052                	sd	s4,0(sp)
    8000253a:	1800                	addi	s0,sp,48
    8000253c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000253e:	fffff097          	auipc	ra,0xfffff
    80002542:	6c4080e7          	jalr	1732(ra) # 80001c02 <myproc>
    80002546:	89aa                	mv	s3,a0
  if (p == initproc)
    80002548:	00006797          	auipc	a5,0x6
    8000254c:	3d07b783          	ld	a5,976(a5) # 80008918 <initproc>
    80002550:	0d050493          	addi	s1,a0,208
    80002554:	15050913          	addi	s2,a0,336
    80002558:	02a79363          	bne	a5,a0,8000257e <exit+0x52>
    panic("init exiting");
    8000255c:	00006517          	auipc	a0,0x6
    80002560:	d9450513          	addi	a0,a0,-620 # 800082f0 <digits+0x2b0>
    80002564:	ffffe097          	auipc	ra,0xffffe
    80002568:	fdc080e7          	jalr	-36(ra) # 80000540 <panic>
      fileclose(f);
    8000256c:	00002097          	auipc	ra,0x2
    80002570:	6a0080e7          	jalr	1696(ra) # 80004c0c <fileclose>
      p->ofile[fd] = 0;
    80002574:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    80002578:	04a1                	addi	s1,s1,8
    8000257a:	01248563          	beq	s1,s2,80002584 <exit+0x58>
    if (p->ofile[fd])
    8000257e:	6088                	ld	a0,0(s1)
    80002580:	f575                	bnez	a0,8000256c <exit+0x40>
    80002582:	bfdd                	j	80002578 <exit+0x4c>
  begin_op();
    80002584:	00002097          	auipc	ra,0x2
    80002588:	1c0080e7          	jalr	448(ra) # 80004744 <begin_op>
  iput(p->cwd);
    8000258c:	1509b503          	ld	a0,336(s3)
    80002590:	00002097          	auipc	ra,0x2
    80002594:	9a2080e7          	jalr	-1630(ra) # 80003f32 <iput>
  end_op();
    80002598:	00002097          	auipc	ra,0x2
    8000259c:	22a080e7          	jalr	554(ra) # 800047c2 <end_op>
  p->cwd = 0;
    800025a0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800025a4:	0022e497          	auipc	s1,0x22e
    800025a8:	61c48493          	addi	s1,s1,1564 # 80230bc0 <wait_lock>
    800025ac:	8526                	mv	a0,s1
    800025ae:	ffffe097          	auipc	ra,0xffffe
    800025b2:	79c080e7          	jalr	1948(ra) # 80000d4a <acquire>
  reparent(p);
    800025b6:	854e                	mv	a0,s3
    800025b8:	00000097          	auipc	ra,0x0
    800025bc:	f1a080e7          	jalr	-230(ra) # 800024d2 <reparent>
  wakeup(p->parent);
    800025c0:	0389b503          	ld	a0,56(s3)
    800025c4:	00000097          	auipc	ra,0x0
    800025c8:	e98080e7          	jalr	-360(ra) # 8000245c <wakeup>
  acquire(&p->lock);
    800025cc:	854e                	mv	a0,s3
    800025ce:	ffffe097          	auipc	ra,0xffffe
    800025d2:	77c080e7          	jalr	1916(ra) # 80000d4a <acquire>
  p->xstate = status;
    800025d6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800025da:	4795                	li	a5,5
    800025dc:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    800025e0:	00006797          	auipc	a5,0x6
    800025e4:	3407a783          	lw	a5,832(a5) # 80008920 <ticks>
    800025e8:	16f9a823          	sw	a5,368(s3)
  release(&wait_lock);
    800025ec:	8526                	mv	a0,s1
    800025ee:	fffff097          	auipc	ra,0xfffff
    800025f2:	810080e7          	jalr	-2032(ra) # 80000dfe <release>
  sched();
    800025f6:	00000097          	auipc	ra,0x0
    800025fa:	cf0080e7          	jalr	-784(ra) # 800022e6 <sched>
  panic("zombie exit");
    800025fe:	00006517          	auipc	a0,0x6
    80002602:	d0250513          	addi	a0,a0,-766 # 80008300 <digits+0x2c0>
    80002606:	ffffe097          	auipc	ra,0xffffe
    8000260a:	f3a080e7          	jalr	-198(ra) # 80000540 <panic>

000000008000260e <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    8000260e:	7179                	addi	sp,sp,-48
    80002610:	f406                	sd	ra,40(sp)
    80002612:	f022                	sd	s0,32(sp)
    80002614:	ec26                	sd	s1,24(sp)
    80002616:	e84a                	sd	s2,16(sp)
    80002618:	e44e                	sd	s3,8(sp)
    8000261a:	1800                	addi	s0,sp,48
    8000261c:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    8000261e:	0022f497          	auipc	s1,0x22f
    80002622:	9ba48493          	addi	s1,s1,-1606 # 80230fd8 <proc>
    80002626:	00235997          	auipc	s3,0x235
    8000262a:	db298993          	addi	s3,s3,-590 # 802373d8 <tickslock>
  {
    acquire(&p->lock);
    8000262e:	8526                	mv	a0,s1
    80002630:	ffffe097          	auipc	ra,0xffffe
    80002634:	71a080e7          	jalr	1818(ra) # 80000d4a <acquire>
    if (p->pid == pid)
    80002638:	589c                	lw	a5,48(s1)
    8000263a:	01278d63          	beq	a5,s2,80002654 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000263e:	8526                	mv	a0,s1
    80002640:	ffffe097          	auipc	ra,0xffffe
    80002644:	7be080e7          	jalr	1982(ra) # 80000dfe <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002648:	19048493          	addi	s1,s1,400
    8000264c:	ff3491e3          	bne	s1,s3,8000262e <kill+0x20>
  }
  return -1;
    80002650:	557d                	li	a0,-1
    80002652:	a829                	j	8000266c <kill+0x5e>
      p->killed = 1;
    80002654:	4785                	li	a5,1
    80002656:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80002658:	4c98                	lw	a4,24(s1)
    8000265a:	4789                	li	a5,2
    8000265c:	00f70f63          	beq	a4,a5,8000267a <kill+0x6c>
      release(&p->lock);
    80002660:	8526                	mv	a0,s1
    80002662:	ffffe097          	auipc	ra,0xffffe
    80002666:	79c080e7          	jalr	1948(ra) # 80000dfe <release>
      return 0;
    8000266a:	4501                	li	a0,0
}
    8000266c:	70a2                	ld	ra,40(sp)
    8000266e:	7402                	ld	s0,32(sp)
    80002670:	64e2                	ld	s1,24(sp)
    80002672:	6942                	ld	s2,16(sp)
    80002674:	69a2                	ld	s3,8(sp)
    80002676:	6145                	addi	sp,sp,48
    80002678:	8082                	ret
        p->state = RUNNABLE;
    8000267a:	478d                	li	a5,3
    8000267c:	cc9c                	sw	a5,24(s1)
    8000267e:	b7cd                	j	80002660 <kill+0x52>

0000000080002680 <setkilled>:

void setkilled(struct proc *p)
{
    80002680:	1101                	addi	sp,sp,-32
    80002682:	ec06                	sd	ra,24(sp)
    80002684:	e822                	sd	s0,16(sp)
    80002686:	e426                	sd	s1,8(sp)
    80002688:	1000                	addi	s0,sp,32
    8000268a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000268c:	ffffe097          	auipc	ra,0xffffe
    80002690:	6be080e7          	jalr	1726(ra) # 80000d4a <acquire>
  p->killed = 1;
    80002694:	4785                	li	a5,1
    80002696:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002698:	8526                	mv	a0,s1
    8000269a:	ffffe097          	auipc	ra,0xffffe
    8000269e:	764080e7          	jalr	1892(ra) # 80000dfe <release>
}
    800026a2:	60e2                	ld	ra,24(sp)
    800026a4:	6442                	ld	s0,16(sp)
    800026a6:	64a2                	ld	s1,8(sp)
    800026a8:	6105                	addi	sp,sp,32
    800026aa:	8082                	ret

00000000800026ac <killed>:

int killed(struct proc *p)
{
    800026ac:	1101                	addi	sp,sp,-32
    800026ae:	ec06                	sd	ra,24(sp)
    800026b0:	e822                	sd	s0,16(sp)
    800026b2:	e426                	sd	s1,8(sp)
    800026b4:	e04a                	sd	s2,0(sp)
    800026b6:	1000                	addi	s0,sp,32
    800026b8:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800026ba:	ffffe097          	auipc	ra,0xffffe
    800026be:	690080e7          	jalr	1680(ra) # 80000d4a <acquire>
  k = p->killed;
    800026c2:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800026c6:	8526                	mv	a0,s1
    800026c8:	ffffe097          	auipc	ra,0xffffe
    800026cc:	736080e7          	jalr	1846(ra) # 80000dfe <release>
  return k;
}
    800026d0:	854a                	mv	a0,s2
    800026d2:	60e2                	ld	ra,24(sp)
    800026d4:	6442                	ld	s0,16(sp)
    800026d6:	64a2                	ld	s1,8(sp)
    800026d8:	6902                	ld	s2,0(sp)
    800026da:	6105                	addi	sp,sp,32
    800026dc:	8082                	ret

00000000800026de <wait>:
{
    800026de:	715d                	addi	sp,sp,-80
    800026e0:	e486                	sd	ra,72(sp)
    800026e2:	e0a2                	sd	s0,64(sp)
    800026e4:	fc26                	sd	s1,56(sp)
    800026e6:	f84a                	sd	s2,48(sp)
    800026e8:	f44e                	sd	s3,40(sp)
    800026ea:	f052                	sd	s4,32(sp)
    800026ec:	ec56                	sd	s5,24(sp)
    800026ee:	e85a                	sd	s6,16(sp)
    800026f0:	e45e                	sd	s7,8(sp)
    800026f2:	e062                	sd	s8,0(sp)
    800026f4:	0880                	addi	s0,sp,80
    800026f6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800026f8:	fffff097          	auipc	ra,0xfffff
    800026fc:	50a080e7          	jalr	1290(ra) # 80001c02 <myproc>
    80002700:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002702:	0022e517          	auipc	a0,0x22e
    80002706:	4be50513          	addi	a0,a0,1214 # 80230bc0 <wait_lock>
    8000270a:	ffffe097          	auipc	ra,0xffffe
    8000270e:	640080e7          	jalr	1600(ra) # 80000d4a <acquire>
    havekids = 0;
    80002712:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    80002714:	4a15                	li	s4,5
        havekids = 1;
    80002716:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002718:	00235997          	auipc	s3,0x235
    8000271c:	cc098993          	addi	s3,s3,-832 # 802373d8 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002720:	0022ec17          	auipc	s8,0x22e
    80002724:	4a0c0c13          	addi	s8,s8,1184 # 80230bc0 <wait_lock>
    havekids = 0;
    80002728:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000272a:	0022f497          	auipc	s1,0x22f
    8000272e:	8ae48493          	addi	s1,s1,-1874 # 80230fd8 <proc>
    80002732:	a0bd                	j	800027a0 <wait+0xc2>
          pid = pp->pid;
    80002734:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002738:	000b0e63          	beqz	s6,80002754 <wait+0x76>
    8000273c:	4691                	li	a3,4
    8000273e:	02c48613          	addi	a2,s1,44
    80002742:	85da                	mv	a1,s6
    80002744:	05093503          	ld	a0,80(s2)
    80002748:	fffff097          	auipc	ra,0xfffff
    8000274c:	166080e7          	jalr	358(ra) # 800018ae <copyout>
    80002750:	02054563          	bltz	a0,8000277a <wait+0x9c>
          freeproc(pp);
    80002754:	8526                	mv	a0,s1
    80002756:	fffff097          	auipc	ra,0xfffff
    8000275a:	65e080e7          	jalr	1630(ra) # 80001db4 <freeproc>
          release(&pp->lock);
    8000275e:	8526                	mv	a0,s1
    80002760:	ffffe097          	auipc	ra,0xffffe
    80002764:	69e080e7          	jalr	1694(ra) # 80000dfe <release>
          release(&wait_lock);
    80002768:	0022e517          	auipc	a0,0x22e
    8000276c:	45850513          	addi	a0,a0,1112 # 80230bc0 <wait_lock>
    80002770:	ffffe097          	auipc	ra,0xffffe
    80002774:	68e080e7          	jalr	1678(ra) # 80000dfe <release>
          return pid;
    80002778:	a0b5                	j	800027e4 <wait+0x106>
            release(&pp->lock);
    8000277a:	8526                	mv	a0,s1
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	682080e7          	jalr	1666(ra) # 80000dfe <release>
            release(&wait_lock);
    80002784:	0022e517          	auipc	a0,0x22e
    80002788:	43c50513          	addi	a0,a0,1084 # 80230bc0 <wait_lock>
    8000278c:	ffffe097          	auipc	ra,0xffffe
    80002790:	672080e7          	jalr	1650(ra) # 80000dfe <release>
            return -1;
    80002794:	59fd                	li	s3,-1
    80002796:	a0b9                	j	800027e4 <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002798:	19048493          	addi	s1,s1,400
    8000279c:	03348463          	beq	s1,s3,800027c4 <wait+0xe6>
      if (pp->parent == p)
    800027a0:	7c9c                	ld	a5,56(s1)
    800027a2:	ff279be3          	bne	a5,s2,80002798 <wait+0xba>
        acquire(&pp->lock);
    800027a6:	8526                	mv	a0,s1
    800027a8:	ffffe097          	auipc	ra,0xffffe
    800027ac:	5a2080e7          	jalr	1442(ra) # 80000d4a <acquire>
        if (pp->state == ZOMBIE)
    800027b0:	4c9c                	lw	a5,24(s1)
    800027b2:	f94781e3          	beq	a5,s4,80002734 <wait+0x56>
        release(&pp->lock);
    800027b6:	8526                	mv	a0,s1
    800027b8:	ffffe097          	auipc	ra,0xffffe
    800027bc:	646080e7          	jalr	1606(ra) # 80000dfe <release>
        havekids = 1;
    800027c0:	8756                	mv	a4,s5
    800027c2:	bfd9                	j	80002798 <wait+0xba>
    if (!havekids || killed(p))
    800027c4:	c719                	beqz	a4,800027d2 <wait+0xf4>
    800027c6:	854a                	mv	a0,s2
    800027c8:	00000097          	auipc	ra,0x0
    800027cc:	ee4080e7          	jalr	-284(ra) # 800026ac <killed>
    800027d0:	c51d                	beqz	a0,800027fe <wait+0x120>
      release(&wait_lock);
    800027d2:	0022e517          	auipc	a0,0x22e
    800027d6:	3ee50513          	addi	a0,a0,1006 # 80230bc0 <wait_lock>
    800027da:	ffffe097          	auipc	ra,0xffffe
    800027de:	624080e7          	jalr	1572(ra) # 80000dfe <release>
      return -1;
    800027e2:	59fd                	li	s3,-1
}
    800027e4:	854e                	mv	a0,s3
    800027e6:	60a6                	ld	ra,72(sp)
    800027e8:	6406                	ld	s0,64(sp)
    800027ea:	74e2                	ld	s1,56(sp)
    800027ec:	7942                	ld	s2,48(sp)
    800027ee:	79a2                	ld	s3,40(sp)
    800027f0:	7a02                	ld	s4,32(sp)
    800027f2:	6ae2                	ld	s5,24(sp)
    800027f4:	6b42                	ld	s6,16(sp)
    800027f6:	6ba2                	ld	s7,8(sp)
    800027f8:	6c02                	ld	s8,0(sp)
    800027fa:	6161                	addi	sp,sp,80
    800027fc:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    800027fe:	85e2                	mv	a1,s8
    80002800:	854a                	mv	a0,s2
    80002802:	00000097          	auipc	ra,0x0
    80002806:	bf6080e7          	jalr	-1034(ra) # 800023f8 <sleep>
    havekids = 0;
    8000280a:	bf39                	j	80002728 <wait+0x4a>

000000008000280c <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000280c:	7179                	addi	sp,sp,-48
    8000280e:	f406                	sd	ra,40(sp)
    80002810:	f022                	sd	s0,32(sp)
    80002812:	ec26                	sd	s1,24(sp)
    80002814:	e84a                	sd	s2,16(sp)
    80002816:	e44e                	sd	s3,8(sp)
    80002818:	e052                	sd	s4,0(sp)
    8000281a:	1800                	addi	s0,sp,48
    8000281c:	84aa                	mv	s1,a0
    8000281e:	892e                	mv	s2,a1
    80002820:	89b2                	mv	s3,a2
    80002822:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002824:	fffff097          	auipc	ra,0xfffff
    80002828:	3de080e7          	jalr	990(ra) # 80001c02 <myproc>
  if (user_dst)
    8000282c:	c08d                	beqz	s1,8000284e <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    8000282e:	86d2                	mv	a3,s4
    80002830:	864e                	mv	a2,s3
    80002832:	85ca                	mv	a1,s2
    80002834:	6928                	ld	a0,80(a0)
    80002836:	fffff097          	auipc	ra,0xfffff
    8000283a:	078080e7          	jalr	120(ra) # 800018ae <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000283e:	70a2                	ld	ra,40(sp)
    80002840:	7402                	ld	s0,32(sp)
    80002842:	64e2                	ld	s1,24(sp)
    80002844:	6942                	ld	s2,16(sp)
    80002846:	69a2                	ld	s3,8(sp)
    80002848:	6a02                	ld	s4,0(sp)
    8000284a:	6145                	addi	sp,sp,48
    8000284c:	8082                	ret
    memmove((char *)dst, src, len);
    8000284e:	000a061b          	sext.w	a2,s4
    80002852:	85ce                	mv	a1,s3
    80002854:	854a                	mv	a0,s2
    80002856:	ffffe097          	auipc	ra,0xffffe
    8000285a:	64c080e7          	jalr	1612(ra) # 80000ea2 <memmove>
    return 0;
    8000285e:	8526                	mv	a0,s1
    80002860:	bff9                	j	8000283e <either_copyout+0x32>

0000000080002862 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002862:	7179                	addi	sp,sp,-48
    80002864:	f406                	sd	ra,40(sp)
    80002866:	f022                	sd	s0,32(sp)
    80002868:	ec26                	sd	s1,24(sp)
    8000286a:	e84a                	sd	s2,16(sp)
    8000286c:	e44e                	sd	s3,8(sp)
    8000286e:	e052                	sd	s4,0(sp)
    80002870:	1800                	addi	s0,sp,48
    80002872:	892a                	mv	s2,a0
    80002874:	84ae                	mv	s1,a1
    80002876:	89b2                	mv	s3,a2
    80002878:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000287a:	fffff097          	auipc	ra,0xfffff
    8000287e:	388080e7          	jalr	904(ra) # 80001c02 <myproc>
  if (user_src)
    80002882:	c08d                	beqz	s1,800028a4 <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80002884:	86d2                	mv	a3,s4
    80002886:	864e                	mv	a2,s3
    80002888:	85ca                	mv	a1,s2
    8000288a:	6928                	ld	a0,80(a0)
    8000288c:	fffff097          	auipc	ra,0xfffff
    80002890:	0c2080e7          	jalr	194(ra) # 8000194e <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002894:	70a2                	ld	ra,40(sp)
    80002896:	7402                	ld	s0,32(sp)
    80002898:	64e2                	ld	s1,24(sp)
    8000289a:	6942                	ld	s2,16(sp)
    8000289c:	69a2                	ld	s3,8(sp)
    8000289e:	6a02                	ld	s4,0(sp)
    800028a0:	6145                	addi	sp,sp,48
    800028a2:	8082                	ret
    memmove(dst, (char *)src, len);
    800028a4:	000a061b          	sext.w	a2,s4
    800028a8:	85ce                	mv	a1,s3
    800028aa:	854a                	mv	a0,s2
    800028ac:	ffffe097          	auipc	ra,0xffffe
    800028b0:	5f6080e7          	jalr	1526(ra) # 80000ea2 <memmove>
    return 0;
    800028b4:	8526                	mv	a0,s1
    800028b6:	bff9                	j	80002894 <either_copyin+0x32>

00000000800028b8 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800028b8:	7139                	addi	sp,sp,-64
    800028ba:	fc06                	sd	ra,56(sp)
    800028bc:	f822                	sd	s0,48(sp)
    800028be:	f426                	sd	s1,40(sp)
    800028c0:	f04a                	sd	s2,32(sp)
    800028c2:	ec4e                	sd	s3,24(sp)
    800028c4:	e852                	sd	s4,16(sp)
    800028c6:	e456                	sd	s5,8(sp)
    800028c8:	e05a                	sd	s6,0(sp)
    800028ca:	0080                	addi	s0,sp,64
      [ZOMBIE] "zombie"};
  struct proc *p;
  // char *state; uncomment it

  // printf("ticks %d\n",ticks);
  for (p = proc; p < &proc[NPROC]; p++)
    800028cc:	0022e497          	auipc	s1,0x22e
    800028d0:	70c48493          	addi	s1,s1,1804 # 80230fd8 <proc>
  if(a<b){return a;}
    800028d4:	06300a93          	li	s5,99
    // }
    // printf("%d %s %s %d %d %d    %d %d\n", p->pid, state, p->name,p->my_rtime,p->my_wtime,p->my_stime,min(p->static_pri+ p->curr_rbi,100), p->curr_rbi); //for PBS
     
    //printf("%d %s %s %d %d %d    \n", p->pid, state, p->name,p->my_rtime,p->my_wtime,p->my_stime); 
     
     printf("(\"P%d\",%d,%d),\n", p->pid, min(p->static_pri + p->curr_rbi, 100), ticks);
    800028d8:	00006a17          	auipc	s4,0x6
    800028dc:	048a0a13          	addi	s4,s4,72 # 80008920 <ticks>
    800028e0:	00006997          	auipc	s3,0x6
    800028e4:	a3098993          	addi	s3,s3,-1488 # 80008310 <digits+0x2d0>
    return b;
    800028e8:	06400b13          	li	s6,100
  for (p = proc; p < &proc[NPROC]; p++)
    800028ec:	00235917          	auipc	s2,0x235
    800028f0:	aec90913          	addi	s2,s2,-1300 # 802373d8 <tickslock>
    800028f4:	a821                	j	8000290c <procdump+0x54>
     printf("(\"P%d\",%d,%d),\n", p->pid, min(p->static_pri + p->curr_rbi, 100), ticks);
    800028f6:	000a2683          	lw	a3,0(s4)
    800028fa:	854e                	mv	a0,s3
    800028fc:	ffffe097          	auipc	ra,0xffffe
    80002900:	c8e080e7          	jalr	-882(ra) # 8000058a <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002904:	19048493          	addi	s1,s1,400
    80002908:	01248e63          	beq	s1,s2,80002924 <procdump+0x6c>
    if (p->state == UNUSED)
    8000290c:	4c9c                	lw	a5,24(s1)
    8000290e:	dbfd                	beqz	a5,80002904 <procdump+0x4c>
     printf("(\"P%d\",%d,%d),\n", p->pid, min(p->static_pri + p->curr_rbi, 100), ticks);
    80002910:	588c                	lw	a1,48(s1)
    80002912:	1804a783          	lw	a5,384(s1)
    80002916:	18c4a603          	lw	a2,396(s1)
    8000291a:	9e3d                	addw	a2,a2,a5
  if(a<b){return a;}
    8000291c:	fccadde3          	bge	s5,a2,800028f6 <procdump+0x3e>
    return b;
    80002920:	865a                	mv	a2,s6
    80002922:	bfd1                	j	800028f6 <procdump+0x3e>


  }
}
    80002924:	70e2                	ld	ra,56(sp)
    80002926:	7442                	ld	s0,48(sp)
    80002928:	74a2                	ld	s1,40(sp)
    8000292a:	7902                	ld	s2,32(sp)
    8000292c:	69e2                	ld	s3,24(sp)
    8000292e:	6a42                	ld	s4,16(sp)
    80002930:	6aa2                	ld	s5,8(sp)
    80002932:	6b02                	ld	s6,0(sp)
    80002934:	6121                	addi	sp,sp,64
    80002936:	8082                	ret

0000000080002938 <waitx>:

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
    80002938:	711d                	addi	sp,sp,-96
    8000293a:	ec86                	sd	ra,88(sp)
    8000293c:	e8a2                	sd	s0,80(sp)
    8000293e:	e4a6                	sd	s1,72(sp)
    80002940:	e0ca                	sd	s2,64(sp)
    80002942:	fc4e                	sd	s3,56(sp)
    80002944:	f852                	sd	s4,48(sp)
    80002946:	f456                	sd	s5,40(sp)
    80002948:	f05a                	sd	s6,32(sp)
    8000294a:	ec5e                	sd	s7,24(sp)
    8000294c:	e862                	sd	s8,16(sp)
    8000294e:	e466                	sd	s9,8(sp)
    80002950:	e06a                	sd	s10,0(sp)
    80002952:	1080                	addi	s0,sp,96
    80002954:	8b2a                	mv	s6,a0
    80002956:	8bae                	mv	s7,a1
    80002958:	8c32                	mv	s8,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    8000295a:	fffff097          	auipc	ra,0xfffff
    8000295e:	2a8080e7          	jalr	680(ra) # 80001c02 <myproc>
    80002962:	892a                	mv	s2,a0

  acquire(&wait_lock);
    80002964:	0022e517          	auipc	a0,0x22e
    80002968:	25c50513          	addi	a0,a0,604 # 80230bc0 <wait_lock>
    8000296c:	ffffe097          	auipc	ra,0xffffe
    80002970:	3de080e7          	jalr	990(ra) # 80000d4a <acquire>

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    80002974:	4c81                	li	s9,0
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    80002976:	4a15                	li	s4,5
        havekids = 1;
    80002978:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    8000297a:	00235997          	auipc	s3,0x235
    8000297e:	a5e98993          	addi	s3,s3,-1442 # 802373d8 <tickslock>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002982:	0022ed17          	auipc	s10,0x22e
    80002986:	23ed0d13          	addi	s10,s10,574 # 80230bc0 <wait_lock>
    havekids = 0;
    8000298a:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    8000298c:	0022e497          	auipc	s1,0x22e
    80002990:	64c48493          	addi	s1,s1,1612 # 80230fd8 <proc>
    80002994:	a059                	j	80002a1a <waitx+0xe2>
          pid = np->pid;
    80002996:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    8000299a:	1684a783          	lw	a5,360(s1)
    8000299e:	00fc2023          	sw	a5,0(s8)
          *wtime = np->etime - np->ctime - np->rtime;
    800029a2:	16c4a703          	lw	a4,364(s1)
    800029a6:	9f3d                	addw	a4,a4,a5
    800029a8:	1704a783          	lw	a5,368(s1)
    800029ac:	9f99                	subw	a5,a5,a4
    800029ae:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800029b2:	000b0e63          	beqz	s6,800029ce <waitx+0x96>
    800029b6:	4691                	li	a3,4
    800029b8:	02c48613          	addi	a2,s1,44
    800029bc:	85da                	mv	a1,s6
    800029be:	05093503          	ld	a0,80(s2)
    800029c2:	fffff097          	auipc	ra,0xfffff
    800029c6:	eec080e7          	jalr	-276(ra) # 800018ae <copyout>
    800029ca:	02054563          	bltz	a0,800029f4 <waitx+0xbc>
          freeproc(np);
    800029ce:	8526                	mv	a0,s1
    800029d0:	fffff097          	auipc	ra,0xfffff
    800029d4:	3e4080e7          	jalr	996(ra) # 80001db4 <freeproc>
          release(&np->lock);
    800029d8:	8526                	mv	a0,s1
    800029da:	ffffe097          	auipc	ra,0xffffe
    800029de:	424080e7          	jalr	1060(ra) # 80000dfe <release>
          release(&wait_lock);
    800029e2:	0022e517          	auipc	a0,0x22e
    800029e6:	1de50513          	addi	a0,a0,478 # 80230bc0 <wait_lock>
    800029ea:	ffffe097          	auipc	ra,0xffffe
    800029ee:	414080e7          	jalr	1044(ra) # 80000dfe <release>
          return pid;
    800029f2:	a09d                	j	80002a58 <waitx+0x120>
            release(&np->lock);
    800029f4:	8526                	mv	a0,s1
    800029f6:	ffffe097          	auipc	ra,0xffffe
    800029fa:	408080e7          	jalr	1032(ra) # 80000dfe <release>
            release(&wait_lock);
    800029fe:	0022e517          	auipc	a0,0x22e
    80002a02:	1c250513          	addi	a0,a0,450 # 80230bc0 <wait_lock>
    80002a06:	ffffe097          	auipc	ra,0xffffe
    80002a0a:	3f8080e7          	jalr	1016(ra) # 80000dfe <release>
            return -1;
    80002a0e:	59fd                	li	s3,-1
    80002a10:	a0a1                	j	80002a58 <waitx+0x120>
    for (np = proc; np < &proc[NPROC]; np++)
    80002a12:	19048493          	addi	s1,s1,400
    80002a16:	03348463          	beq	s1,s3,80002a3e <waitx+0x106>
      if (np->parent == p)
    80002a1a:	7c9c                	ld	a5,56(s1)
    80002a1c:	ff279be3          	bne	a5,s2,80002a12 <waitx+0xda>
        acquire(&np->lock);
    80002a20:	8526                	mv	a0,s1
    80002a22:	ffffe097          	auipc	ra,0xffffe
    80002a26:	328080e7          	jalr	808(ra) # 80000d4a <acquire>
        if (np->state == ZOMBIE)
    80002a2a:	4c9c                	lw	a5,24(s1)
    80002a2c:	f74785e3          	beq	a5,s4,80002996 <waitx+0x5e>
        release(&np->lock);
    80002a30:	8526                	mv	a0,s1
    80002a32:	ffffe097          	auipc	ra,0xffffe
    80002a36:	3cc080e7          	jalr	972(ra) # 80000dfe <release>
        havekids = 1;
    80002a3a:	8756                	mv	a4,s5
    80002a3c:	bfd9                	j	80002a12 <waitx+0xda>
    if (!havekids || p->killed)
    80002a3e:	c701                	beqz	a4,80002a46 <waitx+0x10e>
    80002a40:	02892783          	lw	a5,40(s2)
    80002a44:	cb8d                	beqz	a5,80002a76 <waitx+0x13e>
      release(&wait_lock);
    80002a46:	0022e517          	auipc	a0,0x22e
    80002a4a:	17a50513          	addi	a0,a0,378 # 80230bc0 <wait_lock>
    80002a4e:	ffffe097          	auipc	ra,0xffffe
    80002a52:	3b0080e7          	jalr	944(ra) # 80000dfe <release>
      return -1;
    80002a56:	59fd                	li	s3,-1
  }
}
    80002a58:	854e                	mv	a0,s3
    80002a5a:	60e6                	ld	ra,88(sp)
    80002a5c:	6446                	ld	s0,80(sp)
    80002a5e:	64a6                	ld	s1,72(sp)
    80002a60:	6906                	ld	s2,64(sp)
    80002a62:	79e2                	ld	s3,56(sp)
    80002a64:	7a42                	ld	s4,48(sp)
    80002a66:	7aa2                	ld	s5,40(sp)
    80002a68:	7b02                	ld	s6,32(sp)
    80002a6a:	6be2                	ld	s7,24(sp)
    80002a6c:	6c42                	ld	s8,16(sp)
    80002a6e:	6ca2                	ld	s9,8(sp)
    80002a70:	6d02                	ld	s10,0(sp)
    80002a72:	6125                	addi	sp,sp,96
    80002a74:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002a76:	85ea                	mv	a1,s10
    80002a78:	854a                	mv	a0,s2
    80002a7a:	00000097          	auipc	ra,0x0
    80002a7e:	97e080e7          	jalr	-1666(ra) # 800023f8 <sleep>
    havekids = 0;
    80002a82:	b721                	j	8000298a <waitx+0x52>

0000000080002a84 <update_time>:

void update_time()
{
    80002a84:	7179                	addi	sp,sp,-48
    80002a86:	f406                	sd	ra,40(sp)
    80002a88:	f022                	sd	s0,32(sp)
    80002a8a:	ec26                	sd	s1,24(sp)
    80002a8c:	e84a                	sd	s2,16(sp)
    80002a8e:	e44e                	sd	s3,8(sp)
    80002a90:	1800                	addi	s0,sp,48
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002a92:	0022e497          	auipc	s1,0x22e
    80002a96:	54648493          	addi	s1,s1,1350 # 80230fd8 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002a9a:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++)
    80002a9c:	00235917          	auipc	s2,0x235
    80002aa0:	93c90913          	addi	s2,s2,-1732 # 802373d8 <tickslock>
    80002aa4:	a811                	j	80002ab8 <update_time+0x34>
    {
      p->rtime++;
    }
    release(&p->lock);
    80002aa6:	8526                	mv	a0,s1
    80002aa8:	ffffe097          	auipc	ra,0xffffe
    80002aac:	356080e7          	jalr	854(ra) # 80000dfe <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002ab0:	19048493          	addi	s1,s1,400
    80002ab4:	03248063          	beq	s1,s2,80002ad4 <update_time+0x50>
    acquire(&p->lock);
    80002ab8:	8526                	mv	a0,s1
    80002aba:	ffffe097          	auipc	ra,0xffffe
    80002abe:	290080e7          	jalr	656(ra) # 80000d4a <acquire>
    if (p->state == RUNNING)
    80002ac2:	4c9c                	lw	a5,24(s1)
    80002ac4:	ff3791e3          	bne	a5,s3,80002aa6 <update_time+0x22>
      p->rtime++;
    80002ac8:	1684a783          	lw	a5,360(s1)
    80002acc:	2785                	addiw	a5,a5,1
    80002ace:	16f4a423          	sw	a5,360(s1)
    80002ad2:	bfd1                	j	80002aa6 <update_time+0x22>
  }
}
    80002ad4:	70a2                	ld	ra,40(sp)
    80002ad6:	7402                	ld	s0,32(sp)
    80002ad8:	64e2                	ld	s1,24(sp)
    80002ada:	6942                	ld	s2,16(sp)
    80002adc:	69a2                	ld	s3,8(sp)
    80002ade:	6145                	addi	sp,sp,48
    80002ae0:	8082                	ret

0000000080002ae2 <swtch>:
    80002ae2:	00153023          	sd	ra,0(a0)
    80002ae6:	00253423          	sd	sp,8(a0)
    80002aea:	e900                	sd	s0,16(a0)
    80002aec:	ed04                	sd	s1,24(a0)
    80002aee:	03253023          	sd	s2,32(a0)
    80002af2:	03353423          	sd	s3,40(a0)
    80002af6:	03453823          	sd	s4,48(a0)
    80002afa:	03553c23          	sd	s5,56(a0)
    80002afe:	05653023          	sd	s6,64(a0)
    80002b02:	05753423          	sd	s7,72(a0)
    80002b06:	05853823          	sd	s8,80(a0)
    80002b0a:	05953c23          	sd	s9,88(a0)
    80002b0e:	07a53023          	sd	s10,96(a0)
    80002b12:	07b53423          	sd	s11,104(a0)
    80002b16:	0005b083          	ld	ra,0(a1)
    80002b1a:	0085b103          	ld	sp,8(a1)
    80002b1e:	6980                	ld	s0,16(a1)
    80002b20:	6d84                	ld	s1,24(a1)
    80002b22:	0205b903          	ld	s2,32(a1)
    80002b26:	0285b983          	ld	s3,40(a1)
    80002b2a:	0305ba03          	ld	s4,48(a1)
    80002b2e:	0385ba83          	ld	s5,56(a1)
    80002b32:	0405bb03          	ld	s6,64(a1)
    80002b36:	0485bb83          	ld	s7,72(a1)
    80002b3a:	0505bc03          	ld	s8,80(a1)
    80002b3e:	0585bc83          	ld	s9,88(a1)
    80002b42:	0605bd03          	ld	s10,96(a1)
    80002b46:	0685bd83          	ld	s11,104(a1)
    80002b4a:	8082                	ret

0000000080002b4c <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002b4c:	1141                	addi	sp,sp,-16
    80002b4e:	e406                	sd	ra,8(sp)
    80002b50:	e022                	sd	s0,0(sp)
    80002b52:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002b54:	00005597          	auipc	a1,0x5
    80002b58:	7cc58593          	addi	a1,a1,1996 # 80008320 <digits+0x2e0>
    80002b5c:	00235517          	auipc	a0,0x235
    80002b60:	87c50513          	addi	a0,a0,-1924 # 802373d8 <tickslock>
    80002b64:	ffffe097          	auipc	ra,0xffffe
    80002b68:	156080e7          	jalr	342(ra) # 80000cba <initlock>
}
    80002b6c:	60a2                	ld	ra,8(sp)
    80002b6e:	6402                	ld	s0,0(sp)
    80002b70:	0141                	addi	sp,sp,16
    80002b72:	8082                	ret

0000000080002b74 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002b74:	1141                	addi	sp,sp,-16
    80002b76:	e422                	sd	s0,8(sp)
    80002b78:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b7a:	00003797          	auipc	a5,0x3
    80002b7e:	70678793          	addi	a5,a5,1798 # 80006280 <kernelvec>
    80002b82:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002b86:	6422                	ld	s0,8(sp)
    80002b88:	0141                	addi	sp,sp,16
    80002b8a:	8082                	ret

0000000080002b8c <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002b8c:	1141                	addi	sp,sp,-16
    80002b8e:	e406                	sd	ra,8(sp)
    80002b90:	e022                	sd	s0,0(sp)
    80002b92:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b94:	fffff097          	auipc	ra,0xfffff
    80002b98:	06e080e7          	jalr	110(ra) # 80001c02 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b9c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002ba0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ba2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002ba6:	00004697          	auipc	a3,0x4
    80002baa:	45a68693          	addi	a3,a3,1114 # 80007000 <_trampoline>
    80002bae:	00004717          	auipc	a4,0x4
    80002bb2:	45270713          	addi	a4,a4,1106 # 80007000 <_trampoline>
    80002bb6:	8f15                	sub	a4,a4,a3
    80002bb8:	040007b7          	lui	a5,0x4000
    80002bbc:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002bbe:	07b2                	slli	a5,a5,0xc
    80002bc0:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bc2:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002bc6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002bc8:	18002673          	csrr	a2,satp
    80002bcc:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002bce:	6d30                	ld	a2,88(a0)
    80002bd0:	6138                	ld	a4,64(a0)
    80002bd2:	6585                	lui	a1,0x1
    80002bd4:	972e                	add	a4,a4,a1
    80002bd6:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002bd8:	6d38                	ld	a4,88(a0)
    80002bda:	00000617          	auipc	a2,0x0
    80002bde:	1b860613          	addi	a2,a2,440 # 80002d92 <usertrap>
    80002be2:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002be4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002be6:	8612                	mv	a2,tp
    80002be8:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bea:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002bee:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002bf2:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bf6:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002bfa:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bfc:	6f18                	ld	a4,24(a4)
    80002bfe:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002c02:	6928                	ld	a0,80(a0)
    80002c04:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002c06:	00004717          	auipc	a4,0x4
    80002c0a:	49670713          	addi	a4,a4,1174 # 8000709c <userret>
    80002c0e:	8f15                	sub	a4,a4,a3
    80002c10:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002c12:	577d                	li	a4,-1
    80002c14:	177e                	slli	a4,a4,0x3f
    80002c16:	8d59                	or	a0,a0,a4
    80002c18:	9782                	jalr	a5
}
    80002c1a:	60a2                	ld	ra,8(sp)
    80002c1c:	6402                	ld	s0,0(sp)
    80002c1e:	0141                	addi	sp,sp,16
    80002c20:	8082                	ret

0000000080002c22 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002c22:	7139                	addi	sp,sp,-64
    80002c24:	fc06                	sd	ra,56(sp)
    80002c26:	f822                	sd	s0,48(sp)
    80002c28:	f426                	sd	s1,40(sp)
    80002c2a:	f04a                	sd	s2,32(sp)
    80002c2c:	ec4e                	sd	s3,24(sp)
    80002c2e:	e852                	sd	s4,16(sp)
    80002c30:	e456                	sd	s5,8(sp)
    80002c32:	0080                	addi	s0,sp,64
  acquire(&tickslock);
    80002c34:	00234517          	auipc	a0,0x234
    80002c38:	7a450513          	addi	a0,a0,1956 # 802373d8 <tickslock>
    80002c3c:	ffffe097          	auipc	ra,0xffffe
    80002c40:	10e080e7          	jalr	270(ra) # 80000d4a <acquire>
  ticks++;
    80002c44:	00006717          	auipc	a4,0x6
    80002c48:	cdc70713          	addi	a4,a4,-804 # 80008920 <ticks>
    80002c4c:	431c                	lw	a5,0(a4)
    80002c4e:	2785                	addiw	a5,a5,1
    80002c50:	c31c                	sw	a5,0(a4)
  update_time();
    80002c52:	00000097          	auipc	ra,0x0
    80002c56:	e32080e7          	jalr	-462(ra) # 80002a84 <update_time>

  // wtime = np->etime - np->ctime - np->rtime; ,etime is current end time
  // or wtime=   runnable
  // stime=  sleeping
  //rtime  = running
  for (struct proc *p = proc; p < &proc[NPROC]; p++)
    80002c5a:	0022e497          	auipc	s1,0x22e
    80002c5e:	37e48493          	addi	s1,s1,894 # 80230fd8 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002c62:	4991                	li	s3,4
    {
      // printf("here");
      p->my_rtime++;
    }
    if (p->state == SLEEPING)
    80002c64:	4a09                	li	s4,2
    {
      p->my_stime++;  //wtime;
    }
    if(p->state == RUNNABLE){
    80002c66:	4a8d                	li	s5,3
  for (struct proc *p = proc; p < &proc[NPROC]; p++)
    80002c68:	00234917          	auipc	s2,0x234
    80002c6c:	77090913          	addi	s2,s2,1904 # 802373d8 <tickslock>
    80002c70:	a839                	j	80002c8e <clockintr+0x6c>
      p->my_rtime++;
    80002c72:	1784a783          	lw	a5,376(s1)
    80002c76:	2785                	addiw	a5,a5,1
    80002c78:	16f4ac23          	sw	a5,376(s1)
      p->my_wtime++;
    }
    release(&p->lock);
    80002c7c:	8526                	mv	a0,s1
    80002c7e:	ffffe097          	auipc	ra,0xffffe
    80002c82:	180080e7          	jalr	384(ra) # 80000dfe <release>
  for (struct proc *p = proc; p < &proc[NPROC]; p++)
    80002c86:	19048493          	addi	s1,s1,400
    80002c8a:	03248a63          	beq	s1,s2,80002cbe <clockintr+0x9c>
    acquire(&p->lock);
    80002c8e:	8526                	mv	a0,s1
    80002c90:	ffffe097          	auipc	ra,0xffffe
    80002c94:	0ba080e7          	jalr	186(ra) # 80000d4a <acquire>
    if (p->state == RUNNING)
    80002c98:	4c9c                	lw	a5,24(s1)
    80002c9a:	fd378ce3          	beq	a5,s3,80002c72 <clockintr+0x50>
    if (p->state == SLEEPING)
    80002c9e:	01479863          	bne	a5,s4,80002cae <clockintr+0x8c>
      p->my_stime++;  //wtime;
    80002ca2:	17c4a783          	lw	a5,380(s1)
    80002ca6:	2785                	addiw	a5,a5,1
    80002ca8:	16f4ae23          	sw	a5,380(s1)
    if(p->state == RUNNABLE){
    80002cac:	bfc1                	j	80002c7c <clockintr+0x5a>
    80002cae:	fd5797e3          	bne	a5,s5,80002c7c <clockintr+0x5a>
      p->my_wtime++;
    80002cb2:	1744a783          	lw	a5,372(s1)
    80002cb6:	2785                	addiw	a5,a5,1
    80002cb8:	16f4aa23          	sw	a5,372(s1)
    80002cbc:	b7c1                	j	80002c7c <clockintr+0x5a>
  }
  wakeup(&ticks);
    80002cbe:	00006517          	auipc	a0,0x6
    80002cc2:	c6250513          	addi	a0,a0,-926 # 80008920 <ticks>
    80002cc6:	fffff097          	auipc	ra,0xfffff
    80002cca:	796080e7          	jalr	1942(ra) # 8000245c <wakeup>
  release(&tickslock);
    80002cce:	00234517          	auipc	a0,0x234
    80002cd2:	70a50513          	addi	a0,a0,1802 # 802373d8 <tickslock>
    80002cd6:	ffffe097          	auipc	ra,0xffffe
    80002cda:	128080e7          	jalr	296(ra) # 80000dfe <release>
}
    80002cde:	70e2                	ld	ra,56(sp)
    80002ce0:	7442                	ld	s0,48(sp)
    80002ce2:	74a2                	ld	s1,40(sp)
    80002ce4:	7902                	ld	s2,32(sp)
    80002ce6:	69e2                	ld	s3,24(sp)
    80002ce8:	6a42                	ld	s4,16(sp)
    80002cea:	6aa2                	ld	s5,8(sp)
    80002cec:	6121                	addi	sp,sp,64
    80002cee:	8082                	ret

0000000080002cf0 <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80002cf0:	1101                	addi	sp,sp,-32
    80002cf2:	ec06                	sd	ra,24(sp)
    80002cf4:	e822                	sd	s0,16(sp)
    80002cf6:	e426                	sd	s1,8(sp)
    80002cf8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002cfa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80002cfe:	00074d63          	bltz	a4,80002d18 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80002d02:	57fd                	li	a5,-1
    80002d04:	17fe                	slli	a5,a5,0x3f
    80002d06:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80002d08:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002d0a:	06f70363          	beq	a4,a5,80002d70 <devintr+0x80>
  }
}
    80002d0e:	60e2                	ld	ra,24(sp)
    80002d10:	6442                	ld	s0,16(sp)
    80002d12:	64a2                	ld	s1,8(sp)
    80002d14:	6105                	addi	sp,sp,32
    80002d16:	8082                	ret
      (scause & 0xff) == 9)
    80002d18:	0ff77793          	zext.b	a5,a4
  if ((scause & 0x8000000000000000L) &&
    80002d1c:	46a5                	li	a3,9
    80002d1e:	fed792e3          	bne	a5,a3,80002d02 <devintr+0x12>
    int irq = plic_claim();
    80002d22:	00003097          	auipc	ra,0x3
    80002d26:	666080e7          	jalr	1638(ra) # 80006388 <plic_claim>
    80002d2a:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002d2c:	47a9                	li	a5,10
    80002d2e:	02f50763          	beq	a0,a5,80002d5c <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80002d32:	4785                	li	a5,1
    80002d34:	02f50963          	beq	a0,a5,80002d66 <devintr+0x76>
    return 1;
    80002d38:	4505                	li	a0,1
    else if (irq)
    80002d3a:	d8f1                	beqz	s1,80002d0e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002d3c:	85a6                	mv	a1,s1
    80002d3e:	00005517          	auipc	a0,0x5
    80002d42:	5ea50513          	addi	a0,a0,1514 # 80008328 <digits+0x2e8>
    80002d46:	ffffe097          	auipc	ra,0xffffe
    80002d4a:	844080e7          	jalr	-1980(ra) # 8000058a <printf>
      plic_complete(irq);
    80002d4e:	8526                	mv	a0,s1
    80002d50:	00003097          	auipc	ra,0x3
    80002d54:	65c080e7          	jalr	1628(ra) # 800063ac <plic_complete>
    return 1;
    80002d58:	4505                	li	a0,1
    80002d5a:	bf55                	j	80002d0e <devintr+0x1e>
      uartintr();
    80002d5c:	ffffe097          	auipc	ra,0xffffe
    80002d60:	c3c080e7          	jalr	-964(ra) # 80000998 <uartintr>
    80002d64:	b7ed                	j	80002d4e <devintr+0x5e>
      virtio_disk_intr();
    80002d66:	00004097          	auipc	ra,0x4
    80002d6a:	b0e080e7          	jalr	-1266(ra) # 80006874 <virtio_disk_intr>
    80002d6e:	b7c5                	j	80002d4e <devintr+0x5e>
    if (cpuid() == 0)
    80002d70:	fffff097          	auipc	ra,0xfffff
    80002d74:	e66080e7          	jalr	-410(ra) # 80001bd6 <cpuid>
    80002d78:	c901                	beqz	a0,80002d88 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002d7a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002d7e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002d80:	14479073          	csrw	sip,a5
    return 2;
    80002d84:	4509                	li	a0,2
    80002d86:	b761                	j	80002d0e <devintr+0x1e>
      clockintr();
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	e9a080e7          	jalr	-358(ra) # 80002c22 <clockintr>
    80002d90:	b7ed                	j	80002d7a <devintr+0x8a>

0000000080002d92 <usertrap>:
{
    80002d92:	1101                	addi	sp,sp,-32
    80002d94:	ec06                	sd	ra,24(sp)
    80002d96:	e822                	sd	s0,16(sp)
    80002d98:	e426                	sd	s1,8(sp)
    80002d9a:	e04a                	sd	s2,0(sp)
    80002d9c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d9e:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002da2:	1007f793          	andi	a5,a5,256
    80002da6:	e3d9                	bnez	a5,80002e2c <usertrap+0x9a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002da8:	00003797          	auipc	a5,0x3
    80002dac:	4d878793          	addi	a5,a5,1240 # 80006280 <kernelvec>
    80002db0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002db4:	fffff097          	auipc	ra,0xfffff
    80002db8:	e4e080e7          	jalr	-434(ra) # 80001c02 <myproc>
    80002dbc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002dbe:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dc0:	14102773          	csrr	a4,sepc
    80002dc4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002dc6:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80002dca:	47a1                	li	a5,8
    80002dcc:	06f70863          	beq	a4,a5,80002e3c <usertrap+0xaa>
    80002dd0:	14202773          	csrr	a4,scause
  else if(r_scause()==15){ //added for cow
    80002dd4:	47bd                	li	a5,15
    80002dd6:	0af71063          	bne	a4,a5,80002e76 <usertrap+0xe4>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002dda:	14302773          	csrr	a4,stval
    if (addr >= MAXVA || (addr < p->trapframe->sp && addr >= (p->trapframe->sp - PGSIZE)))
    80002dde:	57fd                	li	a5,-1
    80002de0:	83e9                	srli	a5,a5,0x1a
    80002de2:	00e7ea63          	bltu	a5,a4,80002df6 <usertrap+0x64>
    80002de6:	6d3c                	ld	a5,88(a0)
    80002de8:	7b9c                	ld	a5,48(a5)
    80002dea:	00f77863          	bgeu	a4,a5,80002dfa <usertrap+0x68>
    80002dee:	76fd                	lui	a3,0xfffff
    80002df0:	97b6                	add	a5,a5,a3
    80002df2:	00f76463          	bltu	a4,a5,80002dfa <usertrap+0x68>
      p->killed = 1;
    80002df6:	4785                	li	a5,1
    80002df8:	d49c                	sw	a5,40(s1)
    if (cowalloc(p->pagetable, PGROUNDDOWN(addr)) < 0)
    80002dfa:	75fd                	lui	a1,0xfffff
    80002dfc:	8df9                	and	a1,a1,a4
    80002dfe:	68a8                	ld	a0,80(s1)
    80002e00:	ffffe097          	auipc	ra,0xffffe
    80002e04:	6ac080e7          	jalr	1708(ra) # 800014ac <cowalloc>
    80002e08:	06054463          	bltz	a0,80002e70 <usertrap+0xde>
  if (killed(p))
    80002e0c:	8526                	mv	a0,s1
    80002e0e:	00000097          	auipc	ra,0x0
    80002e12:	89e080e7          	jalr	-1890(ra) # 800026ac <killed>
    80002e16:	e955                	bnez	a0,80002eca <usertrap+0x138>
  usertrapret();
    80002e18:	00000097          	auipc	ra,0x0
    80002e1c:	d74080e7          	jalr	-652(ra) # 80002b8c <usertrapret>
}
    80002e20:	60e2                	ld	ra,24(sp)
    80002e22:	6442                	ld	s0,16(sp)
    80002e24:	64a2                	ld	s1,8(sp)
    80002e26:	6902                	ld	s2,0(sp)
    80002e28:	6105                	addi	sp,sp,32
    80002e2a:	8082                	ret
    panic("usertrap: not from user mode");
    80002e2c:	00005517          	auipc	a0,0x5
    80002e30:	51c50513          	addi	a0,a0,1308 # 80008348 <digits+0x308>
    80002e34:	ffffd097          	auipc	ra,0xffffd
    80002e38:	70c080e7          	jalr	1804(ra) # 80000540 <panic>
    if (killed(p))
    80002e3c:	00000097          	auipc	ra,0x0
    80002e40:	870080e7          	jalr	-1936(ra) # 800026ac <killed>
    80002e44:	e105                	bnez	a0,80002e64 <usertrap+0xd2>
    p->trapframe->epc += 4;
    80002e46:	6cb8                	ld	a4,88(s1)
    80002e48:	6f1c                	ld	a5,24(a4)
    80002e4a:	0791                	addi	a5,a5,4
    80002e4c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e4e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e52:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e56:	10079073          	csrw	sstatus,a5
    syscall();
    80002e5a:	00000097          	auipc	ra,0x0
    80002e5e:	2d6080e7          	jalr	726(ra) # 80003130 <syscall>
    80002e62:	b76d                	j	80002e0c <usertrap+0x7a>
      exit(-1);
    80002e64:	557d                	li	a0,-1
    80002e66:	fffff097          	auipc	ra,0xfffff
    80002e6a:	6c6080e7          	jalr	1734(ra) # 8000252c <exit>
    80002e6e:	bfe1                	j	80002e46 <usertrap+0xb4>
      p->killed = 1;
    80002e70:	4785                	li	a5,1
    80002e72:	d49c                	sw	a5,40(s1)
    80002e74:	bf61                	j	80002e0c <usertrap+0x7a>
  else if ((which_dev = devintr()) != 0)
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	e7a080e7          	jalr	-390(ra) # 80002cf0 <devintr>
    80002e7e:	892a                	mv	s2,a0
    80002e80:	c901                	beqz	a0,80002e90 <usertrap+0xfe>
  if (killed(p))
    80002e82:	8526                	mv	a0,s1
    80002e84:	00000097          	auipc	ra,0x0
    80002e88:	828080e7          	jalr	-2008(ra) # 800026ac <killed>
    80002e8c:	c529                	beqz	a0,80002ed6 <usertrap+0x144>
    80002e8e:	a83d                	j	80002ecc <usertrap+0x13a>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e90:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002e94:	5890                	lw	a2,48(s1)
    80002e96:	00005517          	auipc	a0,0x5
    80002e9a:	4d250513          	addi	a0,a0,1234 # 80008368 <digits+0x328>
    80002e9e:	ffffd097          	auipc	ra,0xffffd
    80002ea2:	6ec080e7          	jalr	1772(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ea6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002eaa:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002eae:	00005517          	auipc	a0,0x5
    80002eb2:	4ea50513          	addi	a0,a0,1258 # 80008398 <digits+0x358>
    80002eb6:	ffffd097          	auipc	ra,0xffffd
    80002eba:	6d4080e7          	jalr	1748(ra) # 8000058a <printf>
    setkilled(p);
    80002ebe:	8526                	mv	a0,s1
    80002ec0:	fffff097          	auipc	ra,0xfffff
    80002ec4:	7c0080e7          	jalr	1984(ra) # 80002680 <setkilled>
    80002ec8:	b791                	j	80002e0c <usertrap+0x7a>
  if (killed(p))
    80002eca:	4901                	li	s2,0
    exit(-1);
    80002ecc:	557d                	li	a0,-1
    80002ece:	fffff097          	auipc	ra,0xfffff
    80002ed2:	65e080e7          	jalr	1630(ra) # 8000252c <exit>
  if (which_dev == 2)
    80002ed6:	4789                	li	a5,2
    80002ed8:	f4f910e3          	bne	s2,a5,80002e18 <usertrap+0x86>
    yield();
    80002edc:	fffff097          	auipc	ra,0xfffff
    80002ee0:	4e0080e7          	jalr	1248(ra) # 800023bc <yield>
    80002ee4:	bf15                	j	80002e18 <usertrap+0x86>

0000000080002ee6 <kerneltrap>:
{
    80002ee6:	7179                	addi	sp,sp,-48
    80002ee8:	f406                	sd	ra,40(sp)
    80002eea:	f022                	sd	s0,32(sp)
    80002eec:	ec26                	sd	s1,24(sp)
    80002eee:	e84a                	sd	s2,16(sp)
    80002ef0:	e44e                	sd	s3,8(sp)
    80002ef2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ef4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ef8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002efc:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002f00:	1004f793          	andi	a5,s1,256
    80002f04:	cb85                	beqz	a5,80002f34 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f06:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002f0a:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002f0c:	ef85                	bnez	a5,80002f44 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80002f0e:	00000097          	auipc	ra,0x0
    80002f12:	de2080e7          	jalr	-542(ra) # 80002cf0 <devintr>
    80002f16:	cd1d                	beqz	a0,80002f54 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f18:	4789                	li	a5,2
    80002f1a:	06f50a63          	beq	a0,a5,80002f8e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f1e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f22:	10049073          	csrw	sstatus,s1
}
    80002f26:	70a2                	ld	ra,40(sp)
    80002f28:	7402                	ld	s0,32(sp)
    80002f2a:	64e2                	ld	s1,24(sp)
    80002f2c:	6942                	ld	s2,16(sp)
    80002f2e:	69a2                	ld	s3,8(sp)
    80002f30:	6145                	addi	sp,sp,48
    80002f32:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002f34:	00005517          	auipc	a0,0x5
    80002f38:	48450513          	addi	a0,a0,1156 # 800083b8 <digits+0x378>
    80002f3c:	ffffd097          	auipc	ra,0xffffd
    80002f40:	604080e7          	jalr	1540(ra) # 80000540 <panic>
    panic("kerneltrap: interrupts enabled");
    80002f44:	00005517          	auipc	a0,0x5
    80002f48:	49c50513          	addi	a0,a0,1180 # 800083e0 <digits+0x3a0>
    80002f4c:	ffffd097          	auipc	ra,0xffffd
    80002f50:	5f4080e7          	jalr	1524(ra) # 80000540 <panic>
    printf("scause %p\n", scause);
    80002f54:	85ce                	mv	a1,s3
    80002f56:	00005517          	auipc	a0,0x5
    80002f5a:	4aa50513          	addi	a0,a0,1194 # 80008400 <digits+0x3c0>
    80002f5e:	ffffd097          	auipc	ra,0xffffd
    80002f62:	62c080e7          	jalr	1580(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f66:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f6a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f6e:	00005517          	auipc	a0,0x5
    80002f72:	4a250513          	addi	a0,a0,1186 # 80008410 <digits+0x3d0>
    80002f76:	ffffd097          	auipc	ra,0xffffd
    80002f7a:	614080e7          	jalr	1556(ra) # 8000058a <printf>
    panic("kerneltrap");
    80002f7e:	00005517          	auipc	a0,0x5
    80002f82:	4aa50513          	addi	a0,a0,1194 # 80008428 <digits+0x3e8>
    80002f86:	ffffd097          	auipc	ra,0xffffd
    80002f8a:	5ba080e7          	jalr	1466(ra) # 80000540 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f8e:	fffff097          	auipc	ra,0xfffff
    80002f92:	c74080e7          	jalr	-908(ra) # 80001c02 <myproc>
    80002f96:	d541                	beqz	a0,80002f1e <kerneltrap+0x38>
    80002f98:	fffff097          	auipc	ra,0xfffff
    80002f9c:	c6a080e7          	jalr	-918(ra) # 80001c02 <myproc>
    80002fa0:	4d18                	lw	a4,24(a0)
    80002fa2:	4791                	li	a5,4
    80002fa4:	f6f71de3          	bne	a4,a5,80002f1e <kerneltrap+0x38>
    yield();  //it yields
    80002fa8:	fffff097          	auipc	ra,0xfffff
    80002fac:	414080e7          	jalr	1044(ra) # 800023bc <yield>
    80002fb0:	b7bd                	j	80002f1e <kerneltrap+0x38>

0000000080002fb2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002fb2:	1101                	addi	sp,sp,-32
    80002fb4:	ec06                	sd	ra,24(sp)
    80002fb6:	e822                	sd	s0,16(sp)
    80002fb8:	e426                	sd	s1,8(sp)
    80002fba:	1000                	addi	s0,sp,32
    80002fbc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002fbe:	fffff097          	auipc	ra,0xfffff
    80002fc2:	c44080e7          	jalr	-956(ra) # 80001c02 <myproc>
  switch (n) {
    80002fc6:	4795                	li	a5,5
    80002fc8:	0497e163          	bltu	a5,s1,8000300a <argraw+0x58>
    80002fcc:	048a                	slli	s1,s1,0x2
    80002fce:	00005717          	auipc	a4,0x5
    80002fd2:	49270713          	addi	a4,a4,1170 # 80008460 <digits+0x420>
    80002fd6:	94ba                	add	s1,s1,a4
    80002fd8:	409c                	lw	a5,0(s1)
    80002fda:	97ba                	add	a5,a5,a4
    80002fdc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002fde:	6d3c                	ld	a5,88(a0)
    80002fe0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002fe2:	60e2                	ld	ra,24(sp)
    80002fe4:	6442                	ld	s0,16(sp)
    80002fe6:	64a2                	ld	s1,8(sp)
    80002fe8:	6105                	addi	sp,sp,32
    80002fea:	8082                	ret
    return p->trapframe->a1;
    80002fec:	6d3c                	ld	a5,88(a0)
    80002fee:	7fa8                	ld	a0,120(a5)
    80002ff0:	bfcd                	j	80002fe2 <argraw+0x30>
    return p->trapframe->a2;
    80002ff2:	6d3c                	ld	a5,88(a0)
    80002ff4:	63c8                	ld	a0,128(a5)
    80002ff6:	b7f5                	j	80002fe2 <argraw+0x30>
    return p->trapframe->a3;
    80002ff8:	6d3c                	ld	a5,88(a0)
    80002ffa:	67c8                	ld	a0,136(a5)
    80002ffc:	b7dd                	j	80002fe2 <argraw+0x30>
    return p->trapframe->a4;
    80002ffe:	6d3c                	ld	a5,88(a0)
    80003000:	6bc8                	ld	a0,144(a5)
    80003002:	b7c5                	j	80002fe2 <argraw+0x30>
    return p->trapframe->a5;
    80003004:	6d3c                	ld	a5,88(a0)
    80003006:	6fc8                	ld	a0,152(a5)
    80003008:	bfe9                	j	80002fe2 <argraw+0x30>
  panic("argraw");
    8000300a:	00005517          	auipc	a0,0x5
    8000300e:	42e50513          	addi	a0,a0,1070 # 80008438 <digits+0x3f8>
    80003012:	ffffd097          	auipc	ra,0xffffd
    80003016:	52e080e7          	jalr	1326(ra) # 80000540 <panic>

000000008000301a <fetchaddr>:
{
    8000301a:	1101                	addi	sp,sp,-32
    8000301c:	ec06                	sd	ra,24(sp)
    8000301e:	e822                	sd	s0,16(sp)
    80003020:	e426                	sd	s1,8(sp)
    80003022:	e04a                	sd	s2,0(sp)
    80003024:	1000                	addi	s0,sp,32
    80003026:	84aa                	mv	s1,a0
    80003028:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000302a:	fffff097          	auipc	ra,0xfffff
    8000302e:	bd8080e7          	jalr	-1064(ra) # 80001c02 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003032:	653c                	ld	a5,72(a0)
    80003034:	02f4f863          	bgeu	s1,a5,80003064 <fetchaddr+0x4a>
    80003038:	00848713          	addi	a4,s1,8
    8000303c:	02e7e663          	bltu	a5,a4,80003068 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003040:	46a1                	li	a3,8
    80003042:	8626                	mv	a2,s1
    80003044:	85ca                	mv	a1,s2
    80003046:	6928                	ld	a0,80(a0)
    80003048:	fffff097          	auipc	ra,0xfffff
    8000304c:	906080e7          	jalr	-1786(ra) # 8000194e <copyin>
    80003050:	00a03533          	snez	a0,a0
    80003054:	40a00533          	neg	a0,a0
}
    80003058:	60e2                	ld	ra,24(sp)
    8000305a:	6442                	ld	s0,16(sp)
    8000305c:	64a2                	ld	s1,8(sp)
    8000305e:	6902                	ld	s2,0(sp)
    80003060:	6105                	addi	sp,sp,32
    80003062:	8082                	ret
    return -1;
    80003064:	557d                	li	a0,-1
    80003066:	bfcd                	j	80003058 <fetchaddr+0x3e>
    80003068:	557d                	li	a0,-1
    8000306a:	b7fd                	j	80003058 <fetchaddr+0x3e>

000000008000306c <fetchstr>:
{
    8000306c:	7179                	addi	sp,sp,-48
    8000306e:	f406                	sd	ra,40(sp)
    80003070:	f022                	sd	s0,32(sp)
    80003072:	ec26                	sd	s1,24(sp)
    80003074:	e84a                	sd	s2,16(sp)
    80003076:	e44e                	sd	s3,8(sp)
    80003078:	1800                	addi	s0,sp,48
    8000307a:	892a                	mv	s2,a0
    8000307c:	84ae                	mv	s1,a1
    8000307e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003080:	fffff097          	auipc	ra,0xfffff
    80003084:	b82080e7          	jalr	-1150(ra) # 80001c02 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003088:	86ce                	mv	a3,s3
    8000308a:	864a                	mv	a2,s2
    8000308c:	85a6                	mv	a1,s1
    8000308e:	6928                	ld	a0,80(a0)
    80003090:	fffff097          	auipc	ra,0xfffff
    80003094:	94c080e7          	jalr	-1716(ra) # 800019dc <copyinstr>
    80003098:	00054e63          	bltz	a0,800030b4 <fetchstr+0x48>
  return strlen(buf);
    8000309c:	8526                	mv	a0,s1
    8000309e:	ffffe097          	auipc	ra,0xffffe
    800030a2:	f24080e7          	jalr	-220(ra) # 80000fc2 <strlen>
}
    800030a6:	70a2                	ld	ra,40(sp)
    800030a8:	7402                	ld	s0,32(sp)
    800030aa:	64e2                	ld	s1,24(sp)
    800030ac:	6942                	ld	s2,16(sp)
    800030ae:	69a2                	ld	s3,8(sp)
    800030b0:	6145                	addi	sp,sp,48
    800030b2:	8082                	ret
    return -1;
    800030b4:	557d                	li	a0,-1
    800030b6:	bfc5                	j	800030a6 <fetchstr+0x3a>

00000000800030b8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800030b8:	1101                	addi	sp,sp,-32
    800030ba:	ec06                	sd	ra,24(sp)
    800030bc:	e822                	sd	s0,16(sp)
    800030be:	e426                	sd	s1,8(sp)
    800030c0:	1000                	addi	s0,sp,32
    800030c2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800030c4:	00000097          	auipc	ra,0x0
    800030c8:	eee080e7          	jalr	-274(ra) # 80002fb2 <argraw>
    800030cc:	c088                	sw	a0,0(s1)
}
    800030ce:	60e2                	ld	ra,24(sp)
    800030d0:	6442                	ld	s0,16(sp)
    800030d2:	64a2                	ld	s1,8(sp)
    800030d4:	6105                	addi	sp,sp,32
    800030d6:	8082                	ret

00000000800030d8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800030d8:	1101                	addi	sp,sp,-32
    800030da:	ec06                	sd	ra,24(sp)
    800030dc:	e822                	sd	s0,16(sp)
    800030de:	e426                	sd	s1,8(sp)
    800030e0:	1000                	addi	s0,sp,32
    800030e2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800030e4:	00000097          	auipc	ra,0x0
    800030e8:	ece080e7          	jalr	-306(ra) # 80002fb2 <argraw>
    800030ec:	e088                	sd	a0,0(s1)
}
    800030ee:	60e2                	ld	ra,24(sp)
    800030f0:	6442                	ld	s0,16(sp)
    800030f2:	64a2                	ld	s1,8(sp)
    800030f4:	6105                	addi	sp,sp,32
    800030f6:	8082                	ret

00000000800030f8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800030f8:	7179                	addi	sp,sp,-48
    800030fa:	f406                	sd	ra,40(sp)
    800030fc:	f022                	sd	s0,32(sp)
    800030fe:	ec26                	sd	s1,24(sp)
    80003100:	e84a                	sd	s2,16(sp)
    80003102:	1800                	addi	s0,sp,48
    80003104:	84ae                	mv	s1,a1
    80003106:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003108:	fd840593          	addi	a1,s0,-40
    8000310c:	00000097          	auipc	ra,0x0
    80003110:	fcc080e7          	jalr	-52(ra) # 800030d8 <argaddr>
  return fetchstr(addr, buf, max);
    80003114:	864a                	mv	a2,s2
    80003116:	85a6                	mv	a1,s1
    80003118:	fd843503          	ld	a0,-40(s0)
    8000311c:	00000097          	auipc	ra,0x0
    80003120:	f50080e7          	jalr	-176(ra) # 8000306c <fetchstr>
}
    80003124:	70a2                	ld	ra,40(sp)
    80003126:	7402                	ld	s0,32(sp)
    80003128:	64e2                	ld	s1,24(sp)
    8000312a:	6942                	ld	s2,16(sp)
    8000312c:	6145                	addi	sp,sp,48
    8000312e:	8082                	ret

0000000080003130 <syscall>:
[SYS_getreadcount] sys_getreadcount,
};

void
syscall(void)
{
    80003130:	1101                	addi	sp,sp,-32
    80003132:	ec06                	sd	ra,24(sp)
    80003134:	e822                	sd	s0,16(sp)
    80003136:	e426                	sd	s1,8(sp)
    80003138:	e04a                	sd	s2,0(sp)
    8000313a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000313c:	fffff097          	auipc	ra,0xfffff
    80003140:	ac6080e7          	jalr	-1338(ra) # 80001c02 <myproc>
    80003144:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003146:	05853903          	ld	s2,88(a0)
    8000314a:	0a893783          	ld	a5,168(s2)
    8000314e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003152:	37fd                	addiw	a5,a5,-1
    80003154:	475d                	li	a4,23
    80003156:	00f76f63          	bltu	a4,a5,80003174 <syscall+0x44>
    8000315a:	00369713          	slli	a4,a3,0x3
    8000315e:	00005797          	auipc	a5,0x5
    80003162:	31a78793          	addi	a5,a5,794 # 80008478 <syscalls>
    80003166:	97ba                	add	a5,a5,a4
    80003168:	639c                	ld	a5,0(a5)
    8000316a:	c789                	beqz	a5,80003174 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000316c:	9782                	jalr	a5
    8000316e:	06a93823          	sd	a0,112(s2)
    80003172:	a839                	j	80003190 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003174:	15848613          	addi	a2,s1,344
    80003178:	588c                	lw	a1,48(s1)
    8000317a:	00005517          	auipc	a0,0x5
    8000317e:	2c650513          	addi	a0,a0,710 # 80008440 <digits+0x400>
    80003182:	ffffd097          	auipc	ra,0xffffd
    80003186:	408080e7          	jalr	1032(ra) # 8000058a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000318a:	6cbc                	ld	a5,88(s1)
    8000318c:	577d                	li	a4,-1
    8000318e:	fbb8                	sd	a4,112(a5)
  }
}
    80003190:	60e2                	ld	ra,24(sp)
    80003192:	6442                	ld	s0,16(sp)
    80003194:	64a2                	ld	s1,8(sp)
    80003196:	6902                	ld	s2,0(sp)
    80003198:	6105                	addi	sp,sp,32
    8000319a:	8082                	ret

000000008000319c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000319c:	1101                	addi	sp,sp,-32
    8000319e:	ec06                	sd	ra,24(sp)
    800031a0:	e822                	sd	s0,16(sp)
    800031a2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800031a4:	fec40593          	addi	a1,s0,-20
    800031a8:	4501                	li	a0,0
    800031aa:	00000097          	auipc	ra,0x0
    800031ae:	f0e080e7          	jalr	-242(ra) # 800030b8 <argint>
  exit(n);
    800031b2:	fec42503          	lw	a0,-20(s0)
    800031b6:	fffff097          	auipc	ra,0xfffff
    800031ba:	376080e7          	jalr	886(ra) # 8000252c <exit>
  return 0; // not reached
}
    800031be:	4501                	li	a0,0
    800031c0:	60e2                	ld	ra,24(sp)
    800031c2:	6442                	ld	s0,16(sp)
    800031c4:	6105                	addi	sp,sp,32
    800031c6:	8082                	ret

00000000800031c8 <sys_set_priority>:

uint64
sys_set_priority(void)  //THIS WORKS GOOD ,SET_PRIORITY WORKS GODD->func in scheduler, SETPRIORITY  WORKS GOOD->in user prog
{ 
    800031c8:	715d                	addi	sp,sp,-80
    800031ca:	e486                	sd	ra,72(sp)
    800031cc:	e0a2                	sd	s0,64(sp)
    800031ce:	fc26                	sd	s1,56(sp)
    800031d0:	f84a                	sd	s2,48(sp)
    800031d2:	f44e                	sd	s3,40(sp)
    800031d4:	f052                	sd	s4,32(sp)
    800031d6:	ec56                	sd	s5,24(sp)
    800031d8:	e85a                	sd	s6,16(sp)
    800031da:	0880                	addi	s0,sp,80
  int pid; int new_priority;
  argint(0,&pid);
    800031dc:	fbc40593          	addi	a1,s0,-68
    800031e0:	4501                	li	a0,0
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	ed6080e7          	jalr	-298(ra) # 800030b8 <argint>
  argint(1,&new_priority);
    800031ea:	fb840593          	addi	a1,s0,-72
    800031ee:	4505                	li	a0,1
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	ec8080e7          	jalr	-312(ra) # 800030b8 <argint>

  if(new_priority<0 || new_priority >100){return -1;}
    800031f8:	fb842703          	lw	a4,-72(s0)
    800031fc:	06400793          	li	a5,100
    80003200:	557d                	li	a0,-1
    80003202:	06e7e163          	bltu	a5,a4,80003264 <sys_set_priority+0x9c>

  // rbi=25; //reset rbi
  int do_yield=0; //flag
  struct proc *p;
  int oldstatic_return=-1;
    80003206:	59fd                	li	s3,-1
  
  // printf("FUNC %d %d\n",pid,new_priority);

  for (p = proc; p < &proc[NPROC]; p++){ 
    80003208:	0022e497          	auipc	s1,0x22e
    8000320c:	dd048493          	addi	s1,s1,-560 # 80230fd8 <proc>
  int do_yield=0; //flag
    80003210:	4a81                	li	s5,0
      acquire(&p->lock);
      if(p->pid==pid){
          // printf("GOT IT HAA%d\n",p->pid);
          
          oldstatic_return=p->static_pri;
          p->rbi=25; //always to default: Recent Behaviour Index (RBI) of the process to 25 as well. FLAG internal var
    80003212:	4a65                	li	s4,25
          //printf("set rbi of %d to %d where static=%d\n",p->pid,p->rbi,new_priority);
          p->static_pri=new_priority;
          if(oldstatic_return>new_priority){ ////in this case yield
              do_yield=1;   ////may be that process has a chance at this CPU so yield...
    80003214:	4b05                	li	s6,1
  for (p = proc; p < &proc[NPROC]; p++){ 
    80003216:	00234917          	auipc	s2,0x234
    8000321a:	1c290913          	addi	s2,s2,450 # 802373d8 <tickslock>
    8000321e:	a811                	j	80003232 <sys_set_priority+0x6a>
          }
      }
      release(&p->lock);
    80003220:	8526                	mv	a0,s1
    80003222:	ffffe097          	auipc	ra,0xffffe
    80003226:	bdc080e7          	jalr	-1060(ra) # 80000dfe <release>
  for (p = proc; p < &proc[NPROC]; p++){ 
    8000322a:	19048493          	addi	s1,s1,400
    8000322e:	03248863          	beq	s1,s2,8000325e <sys_set_priority+0x96>
      acquire(&p->lock);
    80003232:	8526                	mv	a0,s1
    80003234:	ffffe097          	auipc	ra,0xffffe
    80003238:	b16080e7          	jalr	-1258(ra) # 80000d4a <acquire>
      if(p->pid==pid){
    8000323c:	5898                	lw	a4,48(s1)
    8000323e:	fbc42783          	lw	a5,-68(s0)
    80003242:	fcf71fe3          	bne	a4,a5,80003220 <sys_set_priority+0x58>
          oldstatic_return=p->static_pri;
    80003246:	1804a983          	lw	s3,384(s1)
          p->rbi=25; //always to default: Recent Behaviour Index (RBI) of the process to 25 as well. FLAG internal var
    8000324a:	1944a223          	sw	s4,388(s1)
          p->static_pri=new_priority;
    8000324e:	fb842783          	lw	a5,-72(s0)
    80003252:	18f4a023          	sw	a5,384(s1)
          if(oldstatic_return>new_priority){ ////in this case yield
    80003256:	fd37d5e3          	bge	a5,s3,80003220 <sys_set_priority+0x58>
              do_yield=1;   ////may be that process has a chance at this CPU so yield...
    8000325a:	8ada                	mv	s5,s6
    8000325c:	b7d1                	j	80003220 <sys_set_priority+0x58>
  }
  if(do_yield==1){//stop whichever process is running right now, -> (was in runnable->running block) -> now cursor moved to for(;;)
    8000325e:	000a9d63          	bnez	s5,80003278 <sys_set_priority+0xb0>
    yield();         //chcks all priority again ,and selects job to perform
  }
  return oldstatic_return; //old staic prio
    80003262:	854e                	mv	a0,s3
  //-1 if pid not exist
}
    80003264:	60a6                	ld	ra,72(sp)
    80003266:	6406                	ld	s0,64(sp)
    80003268:	74e2                	ld	s1,56(sp)
    8000326a:	7942                	ld	s2,48(sp)
    8000326c:	79a2                	ld	s3,40(sp)
    8000326e:	7a02                	ld	s4,32(sp)
    80003270:	6ae2                	ld	s5,24(sp)
    80003272:	6b42                	ld	s6,16(sp)
    80003274:	6161                	addi	sp,sp,80
    80003276:	8082                	ret
    yield();         //chcks all priority again ,and selects job to perform
    80003278:	fffff097          	auipc	ra,0xfffff
    8000327c:	144080e7          	jalr	324(ra) # 800023bc <yield>
    80003280:	b7cd                	j	80003262 <sys_set_priority+0x9a>

0000000080003282 <sys_getpid>:


uint64
sys_getpid(void)
{
    80003282:	1141                	addi	sp,sp,-16
    80003284:	e406                	sd	ra,8(sp)
    80003286:	e022                	sd	s0,0(sp)
    80003288:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000328a:	fffff097          	auipc	ra,0xfffff
    8000328e:	978080e7          	jalr	-1672(ra) # 80001c02 <myproc>
}
    80003292:	5908                	lw	a0,48(a0)
    80003294:	60a2                	ld	ra,8(sp)
    80003296:	6402                	ld	s0,0(sp)
    80003298:	0141                	addi	sp,sp,16
    8000329a:	8082                	ret

000000008000329c <sys_fork>:

uint64
sys_fork(void)
{
    8000329c:	1141                	addi	sp,sp,-16
    8000329e:	e406                	sd	ra,8(sp)
    800032a0:	e022                	sd	s0,0(sp)
    800032a2:	0800                	addi	s0,sp,16
  return fork();
    800032a4:	fffff097          	auipc	ra,0xfffff
    800032a8:	d4a080e7          	jalr	-694(ra) # 80001fee <fork>
}
    800032ac:	60a2                	ld	ra,8(sp)
    800032ae:	6402                	ld	s0,0(sp)
    800032b0:	0141                	addi	sp,sp,16
    800032b2:	8082                	ret

00000000800032b4 <sys_wait>:

uint64
sys_wait(void)
{
    800032b4:	1101                	addi	sp,sp,-32
    800032b6:	ec06                	sd	ra,24(sp)
    800032b8:	e822                	sd	s0,16(sp)
    800032ba:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800032bc:	fe840593          	addi	a1,s0,-24
    800032c0:	4501                	li	a0,0
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	e16080e7          	jalr	-490(ra) # 800030d8 <argaddr>
  return wait(p);
    800032ca:	fe843503          	ld	a0,-24(s0)
    800032ce:	fffff097          	auipc	ra,0xfffff
    800032d2:	410080e7          	jalr	1040(ra) # 800026de <wait>
}
    800032d6:	60e2                	ld	ra,24(sp)
    800032d8:	6442                	ld	s0,16(sp)
    800032da:	6105                	addi	sp,sp,32
    800032dc:	8082                	ret

00000000800032de <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800032de:	7179                	addi	sp,sp,-48
    800032e0:	f406                	sd	ra,40(sp)
    800032e2:	f022                	sd	s0,32(sp)
    800032e4:	ec26                	sd	s1,24(sp)
    800032e6:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800032e8:	fdc40593          	addi	a1,s0,-36
    800032ec:	4501                	li	a0,0
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	dca080e7          	jalr	-566(ra) # 800030b8 <argint>
  addr = myproc()->sz;
    800032f6:	fffff097          	auipc	ra,0xfffff
    800032fa:	90c080e7          	jalr	-1780(ra) # 80001c02 <myproc>
    800032fe:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    80003300:	fdc42503          	lw	a0,-36(s0)
    80003304:	fffff097          	auipc	ra,0xfffff
    80003308:	c8e080e7          	jalr	-882(ra) # 80001f92 <growproc>
    8000330c:	00054863          	bltz	a0,8000331c <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80003310:	8526                	mv	a0,s1
    80003312:	70a2                	ld	ra,40(sp)
    80003314:	7402                	ld	s0,32(sp)
    80003316:	64e2                	ld	s1,24(sp)
    80003318:	6145                	addi	sp,sp,48
    8000331a:	8082                	ret
    return -1;
    8000331c:	54fd                	li	s1,-1
    8000331e:	bfcd                	j	80003310 <sys_sbrk+0x32>

0000000080003320 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003320:	7139                	addi	sp,sp,-64
    80003322:	fc06                	sd	ra,56(sp)
    80003324:	f822                	sd	s0,48(sp)
    80003326:	f426                	sd	s1,40(sp)
    80003328:	f04a                	sd	s2,32(sp)
    8000332a:	ec4e                	sd	s3,24(sp)
    8000332c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000332e:	fcc40593          	addi	a1,s0,-52
    80003332:	4501                	li	a0,0
    80003334:	00000097          	auipc	ra,0x0
    80003338:	d84080e7          	jalr	-636(ra) # 800030b8 <argint>
  acquire(&tickslock);
    8000333c:	00234517          	auipc	a0,0x234
    80003340:	09c50513          	addi	a0,a0,156 # 802373d8 <tickslock>
    80003344:	ffffe097          	auipc	ra,0xffffe
    80003348:	a06080e7          	jalr	-1530(ra) # 80000d4a <acquire>
  ticks0 = ticks;
    8000334c:	00005917          	auipc	s2,0x5
    80003350:	5d492903          	lw	s2,1492(s2) # 80008920 <ticks>
  while (ticks - ticks0 < n)
    80003354:	fcc42783          	lw	a5,-52(s0)
    80003358:	cf9d                	beqz	a5,80003396 <sys_sleep+0x76>
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000335a:	00234997          	auipc	s3,0x234
    8000335e:	07e98993          	addi	s3,s3,126 # 802373d8 <tickslock>
    80003362:	00005497          	auipc	s1,0x5
    80003366:	5be48493          	addi	s1,s1,1470 # 80008920 <ticks>
    if (killed(myproc()))
    8000336a:	fffff097          	auipc	ra,0xfffff
    8000336e:	898080e7          	jalr	-1896(ra) # 80001c02 <myproc>
    80003372:	fffff097          	auipc	ra,0xfffff
    80003376:	33a080e7          	jalr	826(ra) # 800026ac <killed>
    8000337a:	ed15                	bnez	a0,800033b6 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000337c:	85ce                	mv	a1,s3
    8000337e:	8526                	mv	a0,s1
    80003380:	fffff097          	auipc	ra,0xfffff
    80003384:	078080e7          	jalr	120(ra) # 800023f8 <sleep>
  while (ticks - ticks0 < n)
    80003388:	409c                	lw	a5,0(s1)
    8000338a:	412787bb          	subw	a5,a5,s2
    8000338e:	fcc42703          	lw	a4,-52(s0)
    80003392:	fce7ece3          	bltu	a5,a4,8000336a <sys_sleep+0x4a>
  }
  release(&tickslock);
    80003396:	00234517          	auipc	a0,0x234
    8000339a:	04250513          	addi	a0,a0,66 # 802373d8 <tickslock>
    8000339e:	ffffe097          	auipc	ra,0xffffe
    800033a2:	a60080e7          	jalr	-1440(ra) # 80000dfe <release>
  return 0;
    800033a6:	4501                	li	a0,0
}
    800033a8:	70e2                	ld	ra,56(sp)
    800033aa:	7442                	ld	s0,48(sp)
    800033ac:	74a2                	ld	s1,40(sp)
    800033ae:	7902                	ld	s2,32(sp)
    800033b0:	69e2                	ld	s3,24(sp)
    800033b2:	6121                	addi	sp,sp,64
    800033b4:	8082                	ret
      release(&tickslock);
    800033b6:	00234517          	auipc	a0,0x234
    800033ba:	02250513          	addi	a0,a0,34 # 802373d8 <tickslock>
    800033be:	ffffe097          	auipc	ra,0xffffe
    800033c2:	a40080e7          	jalr	-1472(ra) # 80000dfe <release>
      return -1;
    800033c6:	557d                	li	a0,-1
    800033c8:	b7c5                	j	800033a8 <sys_sleep+0x88>

00000000800033ca <sys_kill>:

uint64
sys_kill(void)
{
    800033ca:	1101                	addi	sp,sp,-32
    800033cc:	ec06                	sd	ra,24(sp)
    800033ce:	e822                	sd	s0,16(sp)
    800033d0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800033d2:	fec40593          	addi	a1,s0,-20
    800033d6:	4501                	li	a0,0
    800033d8:	00000097          	auipc	ra,0x0
    800033dc:	ce0080e7          	jalr	-800(ra) # 800030b8 <argint>
  return kill(pid);
    800033e0:	fec42503          	lw	a0,-20(s0)
    800033e4:	fffff097          	auipc	ra,0xfffff
    800033e8:	22a080e7          	jalr	554(ra) # 8000260e <kill>
}
    800033ec:	60e2                	ld	ra,24(sp)
    800033ee:	6442                	ld	s0,16(sp)
    800033f0:	6105                	addi	sp,sp,32
    800033f2:	8082                	ret

00000000800033f4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800033f4:	1101                	addi	sp,sp,-32
    800033f6:	ec06                	sd	ra,24(sp)
    800033f8:	e822                	sd	s0,16(sp)
    800033fa:	e426                	sd	s1,8(sp)
    800033fc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800033fe:	00234517          	auipc	a0,0x234
    80003402:	fda50513          	addi	a0,a0,-38 # 802373d8 <tickslock>
    80003406:	ffffe097          	auipc	ra,0xffffe
    8000340a:	944080e7          	jalr	-1724(ra) # 80000d4a <acquire>
  xticks = ticks;
    8000340e:	00005497          	auipc	s1,0x5
    80003412:	5124a483          	lw	s1,1298(s1) # 80008920 <ticks>
  release(&tickslock);
    80003416:	00234517          	auipc	a0,0x234
    8000341a:	fc250513          	addi	a0,a0,-62 # 802373d8 <tickslock>
    8000341e:	ffffe097          	auipc	ra,0xffffe
    80003422:	9e0080e7          	jalr	-1568(ra) # 80000dfe <release>
  return xticks;
}
    80003426:	02049513          	slli	a0,s1,0x20
    8000342a:	9101                	srli	a0,a0,0x20
    8000342c:	60e2                	ld	ra,24(sp)
    8000342e:	6442                	ld	s0,16(sp)
    80003430:	64a2                	ld	s1,8(sp)
    80003432:	6105                	addi	sp,sp,32
    80003434:	8082                	ret

0000000080003436 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003436:	7139                	addi	sp,sp,-64
    80003438:	fc06                	sd	ra,56(sp)
    8000343a:	f822                	sd	s0,48(sp)
    8000343c:	f426                	sd	s1,40(sp)
    8000343e:	f04a                	sd	s2,32(sp)
    80003440:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    80003442:	fd840593          	addi	a1,s0,-40
    80003446:	4501                	li	a0,0
    80003448:	00000097          	auipc	ra,0x0
    8000344c:	c90080e7          	jalr	-880(ra) # 800030d8 <argaddr>
  argaddr(1, &addr1); // user virtual memory
    80003450:	fd040593          	addi	a1,s0,-48
    80003454:	4505                	li	a0,1
    80003456:	00000097          	auipc	ra,0x0
    8000345a:	c82080e7          	jalr	-894(ra) # 800030d8 <argaddr>
  argaddr(2, &addr2);
    8000345e:	fc840593          	addi	a1,s0,-56
    80003462:	4509                	li	a0,2
    80003464:	00000097          	auipc	ra,0x0
    80003468:	c74080e7          	jalr	-908(ra) # 800030d8 <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    8000346c:	fc040613          	addi	a2,s0,-64
    80003470:	fc440593          	addi	a1,s0,-60
    80003474:	fd843503          	ld	a0,-40(s0)
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	4c0080e7          	jalr	1216(ra) # 80002938 <waitx>
    80003480:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80003482:	ffffe097          	auipc	ra,0xffffe
    80003486:	780080e7          	jalr	1920(ra) # 80001c02 <myproc>
    8000348a:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    8000348c:	4691                	li	a3,4
    8000348e:	fc440613          	addi	a2,s0,-60
    80003492:	fd043583          	ld	a1,-48(s0)
    80003496:	6928                	ld	a0,80(a0)
    80003498:	ffffe097          	auipc	ra,0xffffe
    8000349c:	416080e7          	jalr	1046(ra) # 800018ae <copyout>
    return -1;
    800034a0:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    800034a2:	00054f63          	bltz	a0,800034c0 <sys_waitx+0x8a>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    800034a6:	4691                	li	a3,4
    800034a8:	fc040613          	addi	a2,s0,-64
    800034ac:	fc843583          	ld	a1,-56(s0)
    800034b0:	68a8                	ld	a0,80(s1)
    800034b2:	ffffe097          	auipc	ra,0xffffe
    800034b6:	3fc080e7          	jalr	1020(ra) # 800018ae <copyout>
    800034ba:	00054a63          	bltz	a0,800034ce <sys_waitx+0x98>
    return -1;
  return ret;
    800034be:	87ca                	mv	a5,s2
    800034c0:	853e                	mv	a0,a5
    800034c2:	70e2                	ld	ra,56(sp)
    800034c4:	7442                	ld	s0,48(sp)
    800034c6:	74a2                	ld	s1,40(sp)
    800034c8:	7902                	ld	s2,32(sp)
    800034ca:	6121                	addi	sp,sp,64
    800034cc:	8082                	ret
    return -1;
    800034ce:	57fd                	li	a5,-1
    800034d0:	bfc5                	j	800034c0 <sys_waitx+0x8a>

00000000800034d2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800034d2:	7179                	addi	sp,sp,-48
    800034d4:	f406                	sd	ra,40(sp)
    800034d6:	f022                	sd	s0,32(sp)
    800034d8:	ec26                	sd	s1,24(sp)
    800034da:	e84a                	sd	s2,16(sp)
    800034dc:	e44e                	sd	s3,8(sp)
    800034de:	e052                	sd	s4,0(sp)
    800034e0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800034e2:	00005597          	auipc	a1,0x5
    800034e6:	05e58593          	addi	a1,a1,94 # 80008540 <syscalls+0xc8>
    800034ea:	00234517          	auipc	a0,0x234
    800034ee:	f0650513          	addi	a0,a0,-250 # 802373f0 <bcache>
    800034f2:	ffffd097          	auipc	ra,0xffffd
    800034f6:	7c8080e7          	jalr	1992(ra) # 80000cba <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800034fa:	0023c797          	auipc	a5,0x23c
    800034fe:	ef678793          	addi	a5,a5,-266 # 8023f3f0 <bcache+0x8000>
    80003502:	0023c717          	auipc	a4,0x23c
    80003506:	15670713          	addi	a4,a4,342 # 8023f658 <bcache+0x8268>
    8000350a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000350e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003512:	00234497          	auipc	s1,0x234
    80003516:	ef648493          	addi	s1,s1,-266 # 80237408 <bcache+0x18>
    b->next = bcache.head.next;
    8000351a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000351c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000351e:	00005a17          	auipc	s4,0x5
    80003522:	02aa0a13          	addi	s4,s4,42 # 80008548 <syscalls+0xd0>
    b->next = bcache.head.next;
    80003526:	2b893783          	ld	a5,696(s2)
    8000352a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000352c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003530:	85d2                	mv	a1,s4
    80003532:	01048513          	addi	a0,s1,16
    80003536:	00001097          	auipc	ra,0x1
    8000353a:	4c8080e7          	jalr	1224(ra) # 800049fe <initsleeplock>
    bcache.head.next->prev = b;
    8000353e:	2b893783          	ld	a5,696(s2)
    80003542:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003544:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003548:	45848493          	addi	s1,s1,1112
    8000354c:	fd349de3          	bne	s1,s3,80003526 <binit+0x54>
  }
}
    80003550:	70a2                	ld	ra,40(sp)
    80003552:	7402                	ld	s0,32(sp)
    80003554:	64e2                	ld	s1,24(sp)
    80003556:	6942                	ld	s2,16(sp)
    80003558:	69a2                	ld	s3,8(sp)
    8000355a:	6a02                	ld	s4,0(sp)
    8000355c:	6145                	addi	sp,sp,48
    8000355e:	8082                	ret

0000000080003560 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003560:	7179                	addi	sp,sp,-48
    80003562:	f406                	sd	ra,40(sp)
    80003564:	f022                	sd	s0,32(sp)
    80003566:	ec26                	sd	s1,24(sp)
    80003568:	e84a                	sd	s2,16(sp)
    8000356a:	e44e                	sd	s3,8(sp)
    8000356c:	1800                	addi	s0,sp,48
    8000356e:	892a                	mv	s2,a0
    80003570:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003572:	00234517          	auipc	a0,0x234
    80003576:	e7e50513          	addi	a0,a0,-386 # 802373f0 <bcache>
    8000357a:	ffffd097          	auipc	ra,0xffffd
    8000357e:	7d0080e7          	jalr	2000(ra) # 80000d4a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003582:	0023c497          	auipc	s1,0x23c
    80003586:	1264b483          	ld	s1,294(s1) # 8023f6a8 <bcache+0x82b8>
    8000358a:	0023c797          	auipc	a5,0x23c
    8000358e:	0ce78793          	addi	a5,a5,206 # 8023f658 <bcache+0x8268>
    80003592:	02f48f63          	beq	s1,a5,800035d0 <bread+0x70>
    80003596:	873e                	mv	a4,a5
    80003598:	a021                	j	800035a0 <bread+0x40>
    8000359a:	68a4                	ld	s1,80(s1)
    8000359c:	02e48a63          	beq	s1,a4,800035d0 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800035a0:	449c                	lw	a5,8(s1)
    800035a2:	ff279ce3          	bne	a5,s2,8000359a <bread+0x3a>
    800035a6:	44dc                	lw	a5,12(s1)
    800035a8:	ff3799e3          	bne	a5,s3,8000359a <bread+0x3a>
      b->refcnt++;
    800035ac:	40bc                	lw	a5,64(s1)
    800035ae:	2785                	addiw	a5,a5,1
    800035b0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800035b2:	00234517          	auipc	a0,0x234
    800035b6:	e3e50513          	addi	a0,a0,-450 # 802373f0 <bcache>
    800035ba:	ffffe097          	auipc	ra,0xffffe
    800035be:	844080e7          	jalr	-1980(ra) # 80000dfe <release>
      acquiresleep(&b->lock);
    800035c2:	01048513          	addi	a0,s1,16
    800035c6:	00001097          	auipc	ra,0x1
    800035ca:	472080e7          	jalr	1138(ra) # 80004a38 <acquiresleep>
      return b;
    800035ce:	a8b9                	j	8000362c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800035d0:	0023c497          	auipc	s1,0x23c
    800035d4:	0d04b483          	ld	s1,208(s1) # 8023f6a0 <bcache+0x82b0>
    800035d8:	0023c797          	auipc	a5,0x23c
    800035dc:	08078793          	addi	a5,a5,128 # 8023f658 <bcache+0x8268>
    800035e0:	00f48863          	beq	s1,a5,800035f0 <bread+0x90>
    800035e4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800035e6:	40bc                	lw	a5,64(s1)
    800035e8:	cf81                	beqz	a5,80003600 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800035ea:	64a4                	ld	s1,72(s1)
    800035ec:	fee49de3          	bne	s1,a4,800035e6 <bread+0x86>
  panic("bget: no buffers");
    800035f0:	00005517          	auipc	a0,0x5
    800035f4:	f6050513          	addi	a0,a0,-160 # 80008550 <syscalls+0xd8>
    800035f8:	ffffd097          	auipc	ra,0xffffd
    800035fc:	f48080e7          	jalr	-184(ra) # 80000540 <panic>
      b->dev = dev;
    80003600:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003604:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003608:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000360c:	4785                	li	a5,1
    8000360e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003610:	00234517          	auipc	a0,0x234
    80003614:	de050513          	addi	a0,a0,-544 # 802373f0 <bcache>
    80003618:	ffffd097          	auipc	ra,0xffffd
    8000361c:	7e6080e7          	jalr	2022(ra) # 80000dfe <release>
      acquiresleep(&b->lock);
    80003620:	01048513          	addi	a0,s1,16
    80003624:	00001097          	auipc	ra,0x1
    80003628:	414080e7          	jalr	1044(ra) # 80004a38 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000362c:	409c                	lw	a5,0(s1)
    8000362e:	cb89                	beqz	a5,80003640 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003630:	8526                	mv	a0,s1
    80003632:	70a2                	ld	ra,40(sp)
    80003634:	7402                	ld	s0,32(sp)
    80003636:	64e2                	ld	s1,24(sp)
    80003638:	6942                	ld	s2,16(sp)
    8000363a:	69a2                	ld	s3,8(sp)
    8000363c:	6145                	addi	sp,sp,48
    8000363e:	8082                	ret
    virtio_disk_rw(b, 0);
    80003640:	4581                	li	a1,0
    80003642:	8526                	mv	a0,s1
    80003644:	00003097          	auipc	ra,0x3
    80003648:	ffe080e7          	jalr	-2(ra) # 80006642 <virtio_disk_rw>
    b->valid = 1;
    8000364c:	4785                	li	a5,1
    8000364e:	c09c                	sw	a5,0(s1)
  return b;
    80003650:	b7c5                	j	80003630 <bread+0xd0>

0000000080003652 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003652:	1101                	addi	sp,sp,-32
    80003654:	ec06                	sd	ra,24(sp)
    80003656:	e822                	sd	s0,16(sp)
    80003658:	e426                	sd	s1,8(sp)
    8000365a:	1000                	addi	s0,sp,32
    8000365c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000365e:	0541                	addi	a0,a0,16
    80003660:	00001097          	auipc	ra,0x1
    80003664:	472080e7          	jalr	1138(ra) # 80004ad2 <holdingsleep>
    80003668:	cd01                	beqz	a0,80003680 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000366a:	4585                	li	a1,1
    8000366c:	8526                	mv	a0,s1
    8000366e:	00003097          	auipc	ra,0x3
    80003672:	fd4080e7          	jalr	-44(ra) # 80006642 <virtio_disk_rw>
}
    80003676:	60e2                	ld	ra,24(sp)
    80003678:	6442                	ld	s0,16(sp)
    8000367a:	64a2                	ld	s1,8(sp)
    8000367c:	6105                	addi	sp,sp,32
    8000367e:	8082                	ret
    panic("bwrite");
    80003680:	00005517          	auipc	a0,0x5
    80003684:	ee850513          	addi	a0,a0,-280 # 80008568 <syscalls+0xf0>
    80003688:	ffffd097          	auipc	ra,0xffffd
    8000368c:	eb8080e7          	jalr	-328(ra) # 80000540 <panic>

0000000080003690 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003690:	1101                	addi	sp,sp,-32
    80003692:	ec06                	sd	ra,24(sp)
    80003694:	e822                	sd	s0,16(sp)
    80003696:	e426                	sd	s1,8(sp)
    80003698:	e04a                	sd	s2,0(sp)
    8000369a:	1000                	addi	s0,sp,32
    8000369c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000369e:	01050913          	addi	s2,a0,16
    800036a2:	854a                	mv	a0,s2
    800036a4:	00001097          	auipc	ra,0x1
    800036a8:	42e080e7          	jalr	1070(ra) # 80004ad2 <holdingsleep>
    800036ac:	c92d                	beqz	a0,8000371e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800036ae:	854a                	mv	a0,s2
    800036b0:	00001097          	auipc	ra,0x1
    800036b4:	3de080e7          	jalr	990(ra) # 80004a8e <releasesleep>

  acquire(&bcache.lock);
    800036b8:	00234517          	auipc	a0,0x234
    800036bc:	d3850513          	addi	a0,a0,-712 # 802373f0 <bcache>
    800036c0:	ffffd097          	auipc	ra,0xffffd
    800036c4:	68a080e7          	jalr	1674(ra) # 80000d4a <acquire>
  b->refcnt--;
    800036c8:	40bc                	lw	a5,64(s1)
    800036ca:	37fd                	addiw	a5,a5,-1
    800036cc:	0007871b          	sext.w	a4,a5
    800036d0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800036d2:	eb05                	bnez	a4,80003702 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800036d4:	68bc                	ld	a5,80(s1)
    800036d6:	64b8                	ld	a4,72(s1)
    800036d8:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800036da:	64bc                	ld	a5,72(s1)
    800036dc:	68b8                	ld	a4,80(s1)
    800036de:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800036e0:	0023c797          	auipc	a5,0x23c
    800036e4:	d1078793          	addi	a5,a5,-752 # 8023f3f0 <bcache+0x8000>
    800036e8:	2b87b703          	ld	a4,696(a5)
    800036ec:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800036ee:	0023c717          	auipc	a4,0x23c
    800036f2:	f6a70713          	addi	a4,a4,-150 # 8023f658 <bcache+0x8268>
    800036f6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800036f8:	2b87b703          	ld	a4,696(a5)
    800036fc:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800036fe:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003702:	00234517          	auipc	a0,0x234
    80003706:	cee50513          	addi	a0,a0,-786 # 802373f0 <bcache>
    8000370a:	ffffd097          	auipc	ra,0xffffd
    8000370e:	6f4080e7          	jalr	1780(ra) # 80000dfe <release>
}
    80003712:	60e2                	ld	ra,24(sp)
    80003714:	6442                	ld	s0,16(sp)
    80003716:	64a2                	ld	s1,8(sp)
    80003718:	6902                	ld	s2,0(sp)
    8000371a:	6105                	addi	sp,sp,32
    8000371c:	8082                	ret
    panic("brelse");
    8000371e:	00005517          	auipc	a0,0x5
    80003722:	e5250513          	addi	a0,a0,-430 # 80008570 <syscalls+0xf8>
    80003726:	ffffd097          	auipc	ra,0xffffd
    8000372a:	e1a080e7          	jalr	-486(ra) # 80000540 <panic>

000000008000372e <bpin>:

void
bpin(struct buf *b) {
    8000372e:	1101                	addi	sp,sp,-32
    80003730:	ec06                	sd	ra,24(sp)
    80003732:	e822                	sd	s0,16(sp)
    80003734:	e426                	sd	s1,8(sp)
    80003736:	1000                	addi	s0,sp,32
    80003738:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000373a:	00234517          	auipc	a0,0x234
    8000373e:	cb650513          	addi	a0,a0,-842 # 802373f0 <bcache>
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	608080e7          	jalr	1544(ra) # 80000d4a <acquire>
  b->refcnt++;
    8000374a:	40bc                	lw	a5,64(s1)
    8000374c:	2785                	addiw	a5,a5,1
    8000374e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003750:	00234517          	auipc	a0,0x234
    80003754:	ca050513          	addi	a0,a0,-864 # 802373f0 <bcache>
    80003758:	ffffd097          	auipc	ra,0xffffd
    8000375c:	6a6080e7          	jalr	1702(ra) # 80000dfe <release>
}
    80003760:	60e2                	ld	ra,24(sp)
    80003762:	6442                	ld	s0,16(sp)
    80003764:	64a2                	ld	s1,8(sp)
    80003766:	6105                	addi	sp,sp,32
    80003768:	8082                	ret

000000008000376a <bunpin>:

void
bunpin(struct buf *b) {
    8000376a:	1101                	addi	sp,sp,-32
    8000376c:	ec06                	sd	ra,24(sp)
    8000376e:	e822                	sd	s0,16(sp)
    80003770:	e426                	sd	s1,8(sp)
    80003772:	1000                	addi	s0,sp,32
    80003774:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003776:	00234517          	auipc	a0,0x234
    8000377a:	c7a50513          	addi	a0,a0,-902 # 802373f0 <bcache>
    8000377e:	ffffd097          	auipc	ra,0xffffd
    80003782:	5cc080e7          	jalr	1484(ra) # 80000d4a <acquire>
  b->refcnt--;
    80003786:	40bc                	lw	a5,64(s1)
    80003788:	37fd                	addiw	a5,a5,-1
    8000378a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000378c:	00234517          	auipc	a0,0x234
    80003790:	c6450513          	addi	a0,a0,-924 # 802373f0 <bcache>
    80003794:	ffffd097          	auipc	ra,0xffffd
    80003798:	66a080e7          	jalr	1642(ra) # 80000dfe <release>
}
    8000379c:	60e2                	ld	ra,24(sp)
    8000379e:	6442                	ld	s0,16(sp)
    800037a0:	64a2                	ld	s1,8(sp)
    800037a2:	6105                	addi	sp,sp,32
    800037a4:	8082                	ret

00000000800037a6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800037a6:	1101                	addi	sp,sp,-32
    800037a8:	ec06                	sd	ra,24(sp)
    800037aa:	e822                	sd	s0,16(sp)
    800037ac:	e426                	sd	s1,8(sp)
    800037ae:	e04a                	sd	s2,0(sp)
    800037b0:	1000                	addi	s0,sp,32
    800037b2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800037b4:	00d5d59b          	srliw	a1,a1,0xd
    800037b8:	0023c797          	auipc	a5,0x23c
    800037bc:	3147a783          	lw	a5,788(a5) # 8023facc <sb+0x1c>
    800037c0:	9dbd                	addw	a1,a1,a5
    800037c2:	00000097          	auipc	ra,0x0
    800037c6:	d9e080e7          	jalr	-610(ra) # 80003560 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800037ca:	0074f713          	andi	a4,s1,7
    800037ce:	4785                	li	a5,1
    800037d0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800037d4:	14ce                	slli	s1,s1,0x33
    800037d6:	90d9                	srli	s1,s1,0x36
    800037d8:	00950733          	add	a4,a0,s1
    800037dc:	05874703          	lbu	a4,88(a4)
    800037e0:	00e7f6b3          	and	a3,a5,a4
    800037e4:	c69d                	beqz	a3,80003812 <bfree+0x6c>
    800037e6:	892a                	mv	s2,a0
     panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800037e8:	94aa                	add	s1,s1,a0
    800037ea:	fff7c793          	not	a5,a5
    800037ee:	8f7d                	and	a4,a4,a5
    800037f0:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800037f4:	00001097          	auipc	ra,0x1
    800037f8:	126080e7          	jalr	294(ra) # 8000491a <log_write>
  brelse(bp);
    800037fc:	854a                	mv	a0,s2
    800037fe:	00000097          	auipc	ra,0x0
    80003802:	e92080e7          	jalr	-366(ra) # 80003690 <brelse>
}
    80003806:	60e2                	ld	ra,24(sp)
    80003808:	6442                	ld	s0,16(sp)
    8000380a:	64a2                	ld	s1,8(sp)
    8000380c:	6902                	ld	s2,0(sp)
    8000380e:	6105                	addi	sp,sp,32
    80003810:	8082                	ret
     panic("freeing free block");
    80003812:	00005517          	auipc	a0,0x5
    80003816:	d6650513          	addi	a0,a0,-666 # 80008578 <syscalls+0x100>
    8000381a:	ffffd097          	auipc	ra,0xffffd
    8000381e:	d26080e7          	jalr	-730(ra) # 80000540 <panic>

0000000080003822 <balloc>:
{
    80003822:	711d                	addi	sp,sp,-96
    80003824:	ec86                	sd	ra,88(sp)
    80003826:	e8a2                	sd	s0,80(sp)
    80003828:	e4a6                	sd	s1,72(sp)
    8000382a:	e0ca                	sd	s2,64(sp)
    8000382c:	fc4e                	sd	s3,56(sp)
    8000382e:	f852                	sd	s4,48(sp)
    80003830:	f456                	sd	s5,40(sp)
    80003832:	f05a                	sd	s6,32(sp)
    80003834:	ec5e                	sd	s7,24(sp)
    80003836:	e862                	sd	s8,16(sp)
    80003838:	e466                	sd	s9,8(sp)
    8000383a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000383c:	0023c797          	auipc	a5,0x23c
    80003840:	2787a783          	lw	a5,632(a5) # 8023fab4 <sb+0x4>
    80003844:	cff5                	beqz	a5,80003940 <balloc+0x11e>
    80003846:	8baa                	mv	s7,a0
    80003848:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000384a:	0023cb17          	auipc	s6,0x23c
    8000384e:	266b0b13          	addi	s6,s6,614 # 8023fab0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003852:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003854:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003856:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003858:	6c89                	lui	s9,0x2
    8000385a:	a061                	j	800038e2 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000385c:	97ca                	add	a5,a5,s2
    8000385e:	8e55                	or	a2,a2,a3
    80003860:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003864:	854a                	mv	a0,s2
    80003866:	00001097          	auipc	ra,0x1
    8000386a:	0b4080e7          	jalr	180(ra) # 8000491a <log_write>
        brelse(bp);
    8000386e:	854a                	mv	a0,s2
    80003870:	00000097          	auipc	ra,0x0
    80003874:	e20080e7          	jalr	-480(ra) # 80003690 <brelse>
  bp = bread(dev, bno);
    80003878:	85a6                	mv	a1,s1
    8000387a:	855e                	mv	a0,s7
    8000387c:	00000097          	auipc	ra,0x0
    80003880:	ce4080e7          	jalr	-796(ra) # 80003560 <bread>
    80003884:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003886:	40000613          	li	a2,1024
    8000388a:	4581                	li	a1,0
    8000388c:	05850513          	addi	a0,a0,88
    80003890:	ffffd097          	auipc	ra,0xffffd
    80003894:	5b6080e7          	jalr	1462(ra) # 80000e46 <memset>
  log_write(bp);
    80003898:	854a                	mv	a0,s2
    8000389a:	00001097          	auipc	ra,0x1
    8000389e:	080080e7          	jalr	128(ra) # 8000491a <log_write>
  brelse(bp);
    800038a2:	854a                	mv	a0,s2
    800038a4:	00000097          	auipc	ra,0x0
    800038a8:	dec080e7          	jalr	-532(ra) # 80003690 <brelse>
}
    800038ac:	8526                	mv	a0,s1
    800038ae:	60e6                	ld	ra,88(sp)
    800038b0:	6446                	ld	s0,80(sp)
    800038b2:	64a6                	ld	s1,72(sp)
    800038b4:	6906                	ld	s2,64(sp)
    800038b6:	79e2                	ld	s3,56(sp)
    800038b8:	7a42                	ld	s4,48(sp)
    800038ba:	7aa2                	ld	s5,40(sp)
    800038bc:	7b02                	ld	s6,32(sp)
    800038be:	6be2                	ld	s7,24(sp)
    800038c0:	6c42                	ld	s8,16(sp)
    800038c2:	6ca2                	ld	s9,8(sp)
    800038c4:	6125                	addi	sp,sp,96
    800038c6:	8082                	ret
    brelse(bp);
    800038c8:	854a                	mv	a0,s2
    800038ca:	00000097          	auipc	ra,0x0
    800038ce:	dc6080e7          	jalr	-570(ra) # 80003690 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800038d2:	015c87bb          	addw	a5,s9,s5
    800038d6:	00078a9b          	sext.w	s5,a5
    800038da:	004b2703          	lw	a4,4(s6)
    800038de:	06eaf163          	bgeu	s5,a4,80003940 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800038e2:	41fad79b          	sraiw	a5,s5,0x1f
    800038e6:	0137d79b          	srliw	a5,a5,0x13
    800038ea:	015787bb          	addw	a5,a5,s5
    800038ee:	40d7d79b          	sraiw	a5,a5,0xd
    800038f2:	01cb2583          	lw	a1,28(s6)
    800038f6:	9dbd                	addw	a1,a1,a5
    800038f8:	855e                	mv	a0,s7
    800038fa:	00000097          	auipc	ra,0x0
    800038fe:	c66080e7          	jalr	-922(ra) # 80003560 <bread>
    80003902:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003904:	004b2503          	lw	a0,4(s6)
    80003908:	000a849b          	sext.w	s1,s5
    8000390c:	8762                	mv	a4,s8
    8000390e:	faa4fde3          	bgeu	s1,a0,800038c8 <balloc+0xa6>
      m = 1 << (bi % 8);
    80003912:	00777693          	andi	a3,a4,7
    80003916:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000391a:	41f7579b          	sraiw	a5,a4,0x1f
    8000391e:	01d7d79b          	srliw	a5,a5,0x1d
    80003922:	9fb9                	addw	a5,a5,a4
    80003924:	4037d79b          	sraiw	a5,a5,0x3
    80003928:	00f90633          	add	a2,s2,a5
    8000392c:	05864603          	lbu	a2,88(a2)
    80003930:	00c6f5b3          	and	a1,a3,a2
    80003934:	d585                	beqz	a1,8000385c <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003936:	2705                	addiw	a4,a4,1
    80003938:	2485                	addiw	s1,s1,1
    8000393a:	fd471ae3          	bne	a4,s4,8000390e <balloc+0xec>
    8000393e:	b769                	j	800038c8 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003940:	00005517          	auipc	a0,0x5
    80003944:	c5050513          	addi	a0,a0,-944 # 80008590 <syscalls+0x118>
    80003948:	ffffd097          	auipc	ra,0xffffd
    8000394c:	c42080e7          	jalr	-958(ra) # 8000058a <printf>
  return 0;
    80003950:	4481                	li	s1,0
    80003952:	bfa9                	j	800038ac <balloc+0x8a>

0000000080003954 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003954:	7179                	addi	sp,sp,-48
    80003956:	f406                	sd	ra,40(sp)
    80003958:	f022                	sd	s0,32(sp)
    8000395a:	ec26                	sd	s1,24(sp)
    8000395c:	e84a                	sd	s2,16(sp)
    8000395e:	e44e                	sd	s3,8(sp)
    80003960:	e052                	sd	s4,0(sp)
    80003962:	1800                	addi	s0,sp,48
    80003964:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003966:	47ad                	li	a5,11
    80003968:	02b7e863          	bltu	a5,a1,80003998 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    8000396c:	02059793          	slli	a5,a1,0x20
    80003970:	01e7d593          	srli	a1,a5,0x1e
    80003974:	00b504b3          	add	s1,a0,a1
    80003978:	0504a903          	lw	s2,80(s1)
    8000397c:	06091e63          	bnez	s2,800039f8 <bmap+0xa4>
      addr = balloc(ip->dev);
    80003980:	4108                	lw	a0,0(a0)
    80003982:	00000097          	auipc	ra,0x0
    80003986:	ea0080e7          	jalr	-352(ra) # 80003822 <balloc>
    8000398a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000398e:	06090563          	beqz	s2,800039f8 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80003992:	0524a823          	sw	s2,80(s1)
    80003996:	a08d                	j	800039f8 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003998:	ff45849b          	addiw	s1,a1,-12
    8000399c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800039a0:	0ff00793          	li	a5,255
    800039a4:	08e7e563          	bltu	a5,a4,80003a2e <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800039a8:	08052903          	lw	s2,128(a0)
    800039ac:	00091d63          	bnez	s2,800039c6 <bmap+0x72>
      addr = balloc(ip->dev);
    800039b0:	4108                	lw	a0,0(a0)
    800039b2:	00000097          	auipc	ra,0x0
    800039b6:	e70080e7          	jalr	-400(ra) # 80003822 <balloc>
    800039ba:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800039be:	02090d63          	beqz	s2,800039f8 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800039c2:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800039c6:	85ca                	mv	a1,s2
    800039c8:	0009a503          	lw	a0,0(s3)
    800039cc:	00000097          	auipc	ra,0x0
    800039d0:	b94080e7          	jalr	-1132(ra) # 80003560 <bread>
    800039d4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800039d6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800039da:	02049713          	slli	a4,s1,0x20
    800039de:	01e75593          	srli	a1,a4,0x1e
    800039e2:	00b784b3          	add	s1,a5,a1
    800039e6:	0004a903          	lw	s2,0(s1)
    800039ea:	02090063          	beqz	s2,80003a0a <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800039ee:	8552                	mv	a0,s4
    800039f0:	00000097          	auipc	ra,0x0
    800039f4:	ca0080e7          	jalr	-864(ra) # 80003690 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800039f8:	854a                	mv	a0,s2
    800039fa:	70a2                	ld	ra,40(sp)
    800039fc:	7402                	ld	s0,32(sp)
    800039fe:	64e2                	ld	s1,24(sp)
    80003a00:	6942                	ld	s2,16(sp)
    80003a02:	69a2                	ld	s3,8(sp)
    80003a04:	6a02                	ld	s4,0(sp)
    80003a06:	6145                	addi	sp,sp,48
    80003a08:	8082                	ret
      addr = balloc(ip->dev);
    80003a0a:	0009a503          	lw	a0,0(s3)
    80003a0e:	00000097          	auipc	ra,0x0
    80003a12:	e14080e7          	jalr	-492(ra) # 80003822 <balloc>
    80003a16:	0005091b          	sext.w	s2,a0
      if(addr){
    80003a1a:	fc090ae3          	beqz	s2,800039ee <bmap+0x9a>
        a[bn] = addr;
    80003a1e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003a22:	8552                	mv	a0,s4
    80003a24:	00001097          	auipc	ra,0x1
    80003a28:	ef6080e7          	jalr	-266(ra) # 8000491a <log_write>
    80003a2c:	b7c9                	j	800039ee <bmap+0x9a>
  panic("bmap: out of range");
    80003a2e:	00005517          	auipc	a0,0x5
    80003a32:	b7a50513          	addi	a0,a0,-1158 # 800085a8 <syscalls+0x130>
    80003a36:	ffffd097          	auipc	ra,0xffffd
    80003a3a:	b0a080e7          	jalr	-1270(ra) # 80000540 <panic>

0000000080003a3e <iget>:
{
    80003a3e:	7179                	addi	sp,sp,-48
    80003a40:	f406                	sd	ra,40(sp)
    80003a42:	f022                	sd	s0,32(sp)
    80003a44:	ec26                	sd	s1,24(sp)
    80003a46:	e84a                	sd	s2,16(sp)
    80003a48:	e44e                	sd	s3,8(sp)
    80003a4a:	e052                	sd	s4,0(sp)
    80003a4c:	1800                	addi	s0,sp,48
    80003a4e:	89aa                	mv	s3,a0
    80003a50:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003a52:	0023c517          	auipc	a0,0x23c
    80003a56:	07e50513          	addi	a0,a0,126 # 8023fad0 <itable>
    80003a5a:	ffffd097          	auipc	ra,0xffffd
    80003a5e:	2f0080e7          	jalr	752(ra) # 80000d4a <acquire>
  empty = 0;
    80003a62:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003a64:	0023c497          	auipc	s1,0x23c
    80003a68:	08448493          	addi	s1,s1,132 # 8023fae8 <itable+0x18>
    80003a6c:	0023e697          	auipc	a3,0x23e
    80003a70:	b0c68693          	addi	a3,a3,-1268 # 80241578 <log>
    80003a74:	a039                	j	80003a82 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a76:	02090b63          	beqz	s2,80003aac <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003a7a:	08848493          	addi	s1,s1,136
    80003a7e:	02d48a63          	beq	s1,a3,80003ab2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003a82:	449c                	lw	a5,8(s1)
    80003a84:	fef059e3          	blez	a5,80003a76 <iget+0x38>
    80003a88:	4098                	lw	a4,0(s1)
    80003a8a:	ff3716e3          	bne	a4,s3,80003a76 <iget+0x38>
    80003a8e:	40d8                	lw	a4,4(s1)
    80003a90:	ff4713e3          	bne	a4,s4,80003a76 <iget+0x38>
      ip->ref++;
    80003a94:	2785                	addiw	a5,a5,1
    80003a96:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003a98:	0023c517          	auipc	a0,0x23c
    80003a9c:	03850513          	addi	a0,a0,56 # 8023fad0 <itable>
    80003aa0:	ffffd097          	auipc	ra,0xffffd
    80003aa4:	35e080e7          	jalr	862(ra) # 80000dfe <release>
      return ip;
    80003aa8:	8926                	mv	s2,s1
    80003aaa:	a03d                	j	80003ad8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003aac:	f7f9                	bnez	a5,80003a7a <iget+0x3c>
    80003aae:	8926                	mv	s2,s1
    80003ab0:	b7e9                	j	80003a7a <iget+0x3c>
  if(empty == 0)
    80003ab2:	02090c63          	beqz	s2,80003aea <iget+0xac>
  ip->dev = dev;
    80003ab6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003aba:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003abe:	4785                	li	a5,1
    80003ac0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003ac4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003ac8:	0023c517          	auipc	a0,0x23c
    80003acc:	00850513          	addi	a0,a0,8 # 8023fad0 <itable>
    80003ad0:	ffffd097          	auipc	ra,0xffffd
    80003ad4:	32e080e7          	jalr	814(ra) # 80000dfe <release>
}
    80003ad8:	854a                	mv	a0,s2
    80003ada:	70a2                	ld	ra,40(sp)
    80003adc:	7402                	ld	s0,32(sp)
    80003ade:	64e2                	ld	s1,24(sp)
    80003ae0:	6942                	ld	s2,16(sp)
    80003ae2:	69a2                	ld	s3,8(sp)
    80003ae4:	6a02                	ld	s4,0(sp)
    80003ae6:	6145                	addi	sp,sp,48
    80003ae8:	8082                	ret
    panic("iget: no inodes");
    80003aea:	00005517          	auipc	a0,0x5
    80003aee:	ad650513          	addi	a0,a0,-1322 # 800085c0 <syscalls+0x148>
    80003af2:	ffffd097          	auipc	ra,0xffffd
    80003af6:	a4e080e7          	jalr	-1458(ra) # 80000540 <panic>

0000000080003afa <fsinit>:
fsinit(int dev) {
    80003afa:	7179                	addi	sp,sp,-48
    80003afc:	f406                	sd	ra,40(sp)
    80003afe:	f022                	sd	s0,32(sp)
    80003b00:	ec26                	sd	s1,24(sp)
    80003b02:	e84a                	sd	s2,16(sp)
    80003b04:	e44e                	sd	s3,8(sp)
    80003b06:	1800                	addi	s0,sp,48
    80003b08:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003b0a:	4585                	li	a1,1
    80003b0c:	00000097          	auipc	ra,0x0
    80003b10:	a54080e7          	jalr	-1452(ra) # 80003560 <bread>
    80003b14:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003b16:	0023c997          	auipc	s3,0x23c
    80003b1a:	f9a98993          	addi	s3,s3,-102 # 8023fab0 <sb>
    80003b1e:	02000613          	li	a2,32
    80003b22:	05850593          	addi	a1,a0,88
    80003b26:	854e                	mv	a0,s3
    80003b28:	ffffd097          	auipc	ra,0xffffd
    80003b2c:	37a080e7          	jalr	890(ra) # 80000ea2 <memmove>
  brelse(bp);
    80003b30:	8526                	mv	a0,s1
    80003b32:	00000097          	auipc	ra,0x0
    80003b36:	b5e080e7          	jalr	-1186(ra) # 80003690 <brelse>
  if(sb.magic != FSMAGIC)
    80003b3a:	0009a703          	lw	a4,0(s3)
    80003b3e:	102037b7          	lui	a5,0x10203
    80003b42:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003b46:	02f71263          	bne	a4,a5,80003b6a <fsinit+0x70>
  initlog(dev, &sb);
    80003b4a:	0023c597          	auipc	a1,0x23c
    80003b4e:	f6658593          	addi	a1,a1,-154 # 8023fab0 <sb>
    80003b52:	854a                	mv	a0,s2
    80003b54:	00001097          	auipc	ra,0x1
    80003b58:	b4a080e7          	jalr	-1206(ra) # 8000469e <initlog>
}
    80003b5c:	70a2                	ld	ra,40(sp)
    80003b5e:	7402                	ld	s0,32(sp)
    80003b60:	64e2                	ld	s1,24(sp)
    80003b62:	6942                	ld	s2,16(sp)
    80003b64:	69a2                	ld	s3,8(sp)
    80003b66:	6145                	addi	sp,sp,48
    80003b68:	8082                	ret
    panic("invalid file system");
    80003b6a:	00005517          	auipc	a0,0x5
    80003b6e:	a6650513          	addi	a0,a0,-1434 # 800085d0 <syscalls+0x158>
    80003b72:	ffffd097          	auipc	ra,0xffffd
    80003b76:	9ce080e7          	jalr	-1586(ra) # 80000540 <panic>

0000000080003b7a <iinit>:
{
    80003b7a:	7179                	addi	sp,sp,-48
    80003b7c:	f406                	sd	ra,40(sp)
    80003b7e:	f022                	sd	s0,32(sp)
    80003b80:	ec26                	sd	s1,24(sp)
    80003b82:	e84a                	sd	s2,16(sp)
    80003b84:	e44e                	sd	s3,8(sp)
    80003b86:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003b88:	00005597          	auipc	a1,0x5
    80003b8c:	a6058593          	addi	a1,a1,-1440 # 800085e8 <syscalls+0x170>
    80003b90:	0023c517          	auipc	a0,0x23c
    80003b94:	f4050513          	addi	a0,a0,-192 # 8023fad0 <itable>
    80003b98:	ffffd097          	auipc	ra,0xffffd
    80003b9c:	122080e7          	jalr	290(ra) # 80000cba <initlock>
  for(i = 0; i < NINODE; i++) {
    80003ba0:	0023c497          	auipc	s1,0x23c
    80003ba4:	f5848493          	addi	s1,s1,-168 # 8023faf8 <itable+0x28>
    80003ba8:	0023e997          	auipc	s3,0x23e
    80003bac:	9e098993          	addi	s3,s3,-1568 # 80241588 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003bb0:	00005917          	auipc	s2,0x5
    80003bb4:	a4090913          	addi	s2,s2,-1472 # 800085f0 <syscalls+0x178>
    80003bb8:	85ca                	mv	a1,s2
    80003bba:	8526                	mv	a0,s1
    80003bbc:	00001097          	auipc	ra,0x1
    80003bc0:	e42080e7          	jalr	-446(ra) # 800049fe <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003bc4:	08848493          	addi	s1,s1,136
    80003bc8:	ff3498e3          	bne	s1,s3,80003bb8 <iinit+0x3e>
}
    80003bcc:	70a2                	ld	ra,40(sp)
    80003bce:	7402                	ld	s0,32(sp)
    80003bd0:	64e2                	ld	s1,24(sp)
    80003bd2:	6942                	ld	s2,16(sp)
    80003bd4:	69a2                	ld	s3,8(sp)
    80003bd6:	6145                	addi	sp,sp,48
    80003bd8:	8082                	ret

0000000080003bda <ialloc>:
{
    80003bda:	715d                	addi	sp,sp,-80
    80003bdc:	e486                	sd	ra,72(sp)
    80003bde:	e0a2                	sd	s0,64(sp)
    80003be0:	fc26                	sd	s1,56(sp)
    80003be2:	f84a                	sd	s2,48(sp)
    80003be4:	f44e                	sd	s3,40(sp)
    80003be6:	f052                	sd	s4,32(sp)
    80003be8:	ec56                	sd	s5,24(sp)
    80003bea:	e85a                	sd	s6,16(sp)
    80003bec:	e45e                	sd	s7,8(sp)
    80003bee:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003bf0:	0023c717          	auipc	a4,0x23c
    80003bf4:	ecc72703          	lw	a4,-308(a4) # 8023fabc <sb+0xc>
    80003bf8:	4785                	li	a5,1
    80003bfa:	04e7fa63          	bgeu	a5,a4,80003c4e <ialloc+0x74>
    80003bfe:	8aaa                	mv	s5,a0
    80003c00:	8bae                	mv	s7,a1
    80003c02:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003c04:	0023ca17          	auipc	s4,0x23c
    80003c08:	eaca0a13          	addi	s4,s4,-340 # 8023fab0 <sb>
    80003c0c:	00048b1b          	sext.w	s6,s1
    80003c10:	0044d593          	srli	a1,s1,0x4
    80003c14:	018a2783          	lw	a5,24(s4)
    80003c18:	9dbd                	addw	a1,a1,a5
    80003c1a:	8556                	mv	a0,s5
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	944080e7          	jalr	-1724(ra) # 80003560 <bread>
    80003c24:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003c26:	05850993          	addi	s3,a0,88
    80003c2a:	00f4f793          	andi	a5,s1,15
    80003c2e:	079a                	slli	a5,a5,0x6
    80003c30:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003c32:	00099783          	lh	a5,0(s3)
    80003c36:	c3a1                	beqz	a5,80003c76 <ialloc+0x9c>
    brelse(bp);
    80003c38:	00000097          	auipc	ra,0x0
    80003c3c:	a58080e7          	jalr	-1448(ra) # 80003690 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003c40:	0485                	addi	s1,s1,1
    80003c42:	00ca2703          	lw	a4,12(s4)
    80003c46:	0004879b          	sext.w	a5,s1
    80003c4a:	fce7e1e3          	bltu	a5,a4,80003c0c <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003c4e:	00005517          	auipc	a0,0x5
    80003c52:	9aa50513          	addi	a0,a0,-1622 # 800085f8 <syscalls+0x180>
    80003c56:	ffffd097          	auipc	ra,0xffffd
    80003c5a:	934080e7          	jalr	-1740(ra) # 8000058a <printf>
  return 0;
    80003c5e:	4501                	li	a0,0
}
    80003c60:	60a6                	ld	ra,72(sp)
    80003c62:	6406                	ld	s0,64(sp)
    80003c64:	74e2                	ld	s1,56(sp)
    80003c66:	7942                	ld	s2,48(sp)
    80003c68:	79a2                	ld	s3,40(sp)
    80003c6a:	7a02                	ld	s4,32(sp)
    80003c6c:	6ae2                	ld	s5,24(sp)
    80003c6e:	6b42                	ld	s6,16(sp)
    80003c70:	6ba2                	ld	s7,8(sp)
    80003c72:	6161                	addi	sp,sp,80
    80003c74:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003c76:	04000613          	li	a2,64
    80003c7a:	4581                	li	a1,0
    80003c7c:	854e                	mv	a0,s3
    80003c7e:	ffffd097          	auipc	ra,0xffffd
    80003c82:	1c8080e7          	jalr	456(ra) # 80000e46 <memset>
      dip->type = type;
    80003c86:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003c8a:	854a                	mv	a0,s2
    80003c8c:	00001097          	auipc	ra,0x1
    80003c90:	c8e080e7          	jalr	-882(ra) # 8000491a <log_write>
      brelse(bp);
    80003c94:	854a                	mv	a0,s2
    80003c96:	00000097          	auipc	ra,0x0
    80003c9a:	9fa080e7          	jalr	-1542(ra) # 80003690 <brelse>
      return iget(dev, inum);
    80003c9e:	85da                	mv	a1,s6
    80003ca0:	8556                	mv	a0,s5
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	d9c080e7          	jalr	-612(ra) # 80003a3e <iget>
    80003caa:	bf5d                	j	80003c60 <ialloc+0x86>

0000000080003cac <iupdate>:
{
    80003cac:	1101                	addi	sp,sp,-32
    80003cae:	ec06                	sd	ra,24(sp)
    80003cb0:	e822                	sd	s0,16(sp)
    80003cb2:	e426                	sd	s1,8(sp)
    80003cb4:	e04a                	sd	s2,0(sp)
    80003cb6:	1000                	addi	s0,sp,32
    80003cb8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003cba:	415c                	lw	a5,4(a0)
    80003cbc:	0047d79b          	srliw	a5,a5,0x4
    80003cc0:	0023c597          	auipc	a1,0x23c
    80003cc4:	e085a583          	lw	a1,-504(a1) # 8023fac8 <sb+0x18>
    80003cc8:	9dbd                	addw	a1,a1,a5
    80003cca:	4108                	lw	a0,0(a0)
    80003ccc:	00000097          	auipc	ra,0x0
    80003cd0:	894080e7          	jalr	-1900(ra) # 80003560 <bread>
    80003cd4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003cd6:	05850793          	addi	a5,a0,88
    80003cda:	40d8                	lw	a4,4(s1)
    80003cdc:	8b3d                	andi	a4,a4,15
    80003cde:	071a                	slli	a4,a4,0x6
    80003ce0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003ce2:	04449703          	lh	a4,68(s1)
    80003ce6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003cea:	04649703          	lh	a4,70(s1)
    80003cee:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003cf2:	04849703          	lh	a4,72(s1)
    80003cf6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003cfa:	04a49703          	lh	a4,74(s1)
    80003cfe:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003d02:	44f8                	lw	a4,76(s1)
    80003d04:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003d06:	03400613          	li	a2,52
    80003d0a:	05048593          	addi	a1,s1,80
    80003d0e:	00c78513          	addi	a0,a5,12
    80003d12:	ffffd097          	auipc	ra,0xffffd
    80003d16:	190080e7          	jalr	400(ra) # 80000ea2 <memmove>
  log_write(bp);
    80003d1a:	854a                	mv	a0,s2
    80003d1c:	00001097          	auipc	ra,0x1
    80003d20:	bfe080e7          	jalr	-1026(ra) # 8000491a <log_write>
  brelse(bp);
    80003d24:	854a                	mv	a0,s2
    80003d26:	00000097          	auipc	ra,0x0
    80003d2a:	96a080e7          	jalr	-1686(ra) # 80003690 <brelse>
}
    80003d2e:	60e2                	ld	ra,24(sp)
    80003d30:	6442                	ld	s0,16(sp)
    80003d32:	64a2                	ld	s1,8(sp)
    80003d34:	6902                	ld	s2,0(sp)
    80003d36:	6105                	addi	sp,sp,32
    80003d38:	8082                	ret

0000000080003d3a <idup>:
{
    80003d3a:	1101                	addi	sp,sp,-32
    80003d3c:	ec06                	sd	ra,24(sp)
    80003d3e:	e822                	sd	s0,16(sp)
    80003d40:	e426                	sd	s1,8(sp)
    80003d42:	1000                	addi	s0,sp,32
    80003d44:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d46:	0023c517          	auipc	a0,0x23c
    80003d4a:	d8a50513          	addi	a0,a0,-630 # 8023fad0 <itable>
    80003d4e:	ffffd097          	auipc	ra,0xffffd
    80003d52:	ffc080e7          	jalr	-4(ra) # 80000d4a <acquire>
  ip->ref++;
    80003d56:	449c                	lw	a5,8(s1)
    80003d58:	2785                	addiw	a5,a5,1
    80003d5a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003d5c:	0023c517          	auipc	a0,0x23c
    80003d60:	d7450513          	addi	a0,a0,-652 # 8023fad0 <itable>
    80003d64:	ffffd097          	auipc	ra,0xffffd
    80003d68:	09a080e7          	jalr	154(ra) # 80000dfe <release>
}
    80003d6c:	8526                	mv	a0,s1
    80003d6e:	60e2                	ld	ra,24(sp)
    80003d70:	6442                	ld	s0,16(sp)
    80003d72:	64a2                	ld	s1,8(sp)
    80003d74:	6105                	addi	sp,sp,32
    80003d76:	8082                	ret

0000000080003d78 <ilock>:
{
    80003d78:	1101                	addi	sp,sp,-32
    80003d7a:	ec06                	sd	ra,24(sp)
    80003d7c:	e822                	sd	s0,16(sp)
    80003d7e:	e426                	sd	s1,8(sp)
    80003d80:	e04a                	sd	s2,0(sp)
    80003d82:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003d84:	c115                	beqz	a0,80003da8 <ilock+0x30>
    80003d86:	84aa                	mv	s1,a0
    80003d88:	451c                	lw	a5,8(a0)
    80003d8a:	00f05f63          	blez	a5,80003da8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003d8e:	0541                	addi	a0,a0,16
    80003d90:	00001097          	auipc	ra,0x1
    80003d94:	ca8080e7          	jalr	-856(ra) # 80004a38 <acquiresleep>
  if(ip->valid == 0){
    80003d98:	40bc                	lw	a5,64(s1)
    80003d9a:	cf99                	beqz	a5,80003db8 <ilock+0x40>
}
    80003d9c:	60e2                	ld	ra,24(sp)
    80003d9e:	6442                	ld	s0,16(sp)
    80003da0:	64a2                	ld	s1,8(sp)
    80003da2:	6902                	ld	s2,0(sp)
    80003da4:	6105                	addi	sp,sp,32
    80003da6:	8082                	ret
    panic("ilock");
    80003da8:	00005517          	auipc	a0,0x5
    80003dac:	86850513          	addi	a0,a0,-1944 # 80008610 <syscalls+0x198>
    80003db0:	ffffc097          	auipc	ra,0xffffc
    80003db4:	790080e7          	jalr	1936(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003db8:	40dc                	lw	a5,4(s1)
    80003dba:	0047d79b          	srliw	a5,a5,0x4
    80003dbe:	0023c597          	auipc	a1,0x23c
    80003dc2:	d0a5a583          	lw	a1,-758(a1) # 8023fac8 <sb+0x18>
    80003dc6:	9dbd                	addw	a1,a1,a5
    80003dc8:	4088                	lw	a0,0(s1)
    80003dca:	fffff097          	auipc	ra,0xfffff
    80003dce:	796080e7          	jalr	1942(ra) # 80003560 <bread>
    80003dd2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003dd4:	05850593          	addi	a1,a0,88
    80003dd8:	40dc                	lw	a5,4(s1)
    80003dda:	8bbd                	andi	a5,a5,15
    80003ddc:	079a                	slli	a5,a5,0x6
    80003dde:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003de0:	00059783          	lh	a5,0(a1)
    80003de4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003de8:	00259783          	lh	a5,2(a1)
    80003dec:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003df0:	00459783          	lh	a5,4(a1)
    80003df4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003df8:	00659783          	lh	a5,6(a1)
    80003dfc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003e00:	459c                	lw	a5,8(a1)
    80003e02:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003e04:	03400613          	li	a2,52
    80003e08:	05b1                	addi	a1,a1,12
    80003e0a:	05048513          	addi	a0,s1,80
    80003e0e:	ffffd097          	auipc	ra,0xffffd
    80003e12:	094080e7          	jalr	148(ra) # 80000ea2 <memmove>
    brelse(bp);
    80003e16:	854a                	mv	a0,s2
    80003e18:	00000097          	auipc	ra,0x0
    80003e1c:	878080e7          	jalr	-1928(ra) # 80003690 <brelse>
    ip->valid = 1;
    80003e20:	4785                	li	a5,1
    80003e22:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003e24:	04449783          	lh	a5,68(s1)
    80003e28:	fbb5                	bnez	a5,80003d9c <ilock+0x24>
      panic("ilock: no type");
    80003e2a:	00004517          	auipc	a0,0x4
    80003e2e:	7ee50513          	addi	a0,a0,2030 # 80008618 <syscalls+0x1a0>
    80003e32:	ffffc097          	auipc	ra,0xffffc
    80003e36:	70e080e7          	jalr	1806(ra) # 80000540 <panic>

0000000080003e3a <iunlock>:
{
    80003e3a:	1101                	addi	sp,sp,-32
    80003e3c:	ec06                	sd	ra,24(sp)
    80003e3e:	e822                	sd	s0,16(sp)
    80003e40:	e426                	sd	s1,8(sp)
    80003e42:	e04a                	sd	s2,0(sp)
    80003e44:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003e46:	c905                	beqz	a0,80003e76 <iunlock+0x3c>
    80003e48:	84aa                	mv	s1,a0
    80003e4a:	01050913          	addi	s2,a0,16
    80003e4e:	854a                	mv	a0,s2
    80003e50:	00001097          	auipc	ra,0x1
    80003e54:	c82080e7          	jalr	-894(ra) # 80004ad2 <holdingsleep>
    80003e58:	cd19                	beqz	a0,80003e76 <iunlock+0x3c>
    80003e5a:	449c                	lw	a5,8(s1)
    80003e5c:	00f05d63          	blez	a5,80003e76 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003e60:	854a                	mv	a0,s2
    80003e62:	00001097          	auipc	ra,0x1
    80003e66:	c2c080e7          	jalr	-980(ra) # 80004a8e <releasesleep>
}
    80003e6a:	60e2                	ld	ra,24(sp)
    80003e6c:	6442                	ld	s0,16(sp)
    80003e6e:	64a2                	ld	s1,8(sp)
    80003e70:	6902                	ld	s2,0(sp)
    80003e72:	6105                	addi	sp,sp,32
    80003e74:	8082                	ret
    panic("iunlock");
    80003e76:	00004517          	auipc	a0,0x4
    80003e7a:	7b250513          	addi	a0,a0,1970 # 80008628 <syscalls+0x1b0>
    80003e7e:	ffffc097          	auipc	ra,0xffffc
    80003e82:	6c2080e7          	jalr	1730(ra) # 80000540 <panic>

0000000080003e86 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003e86:	7179                	addi	sp,sp,-48
    80003e88:	f406                	sd	ra,40(sp)
    80003e8a:	f022                	sd	s0,32(sp)
    80003e8c:	ec26                	sd	s1,24(sp)
    80003e8e:	e84a                	sd	s2,16(sp)
    80003e90:	e44e                	sd	s3,8(sp)
    80003e92:	e052                	sd	s4,0(sp)
    80003e94:	1800                	addi	s0,sp,48
    80003e96:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003e98:	05050493          	addi	s1,a0,80
    80003e9c:	08050913          	addi	s2,a0,128
    80003ea0:	a021                	j	80003ea8 <itrunc+0x22>
    80003ea2:	0491                	addi	s1,s1,4
    80003ea4:	01248d63          	beq	s1,s2,80003ebe <itrunc+0x38>
    if(ip->addrs[i]){
    80003ea8:	408c                	lw	a1,0(s1)
    80003eaa:	dde5                	beqz	a1,80003ea2 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003eac:	0009a503          	lw	a0,0(s3)
    80003eb0:	00000097          	auipc	ra,0x0
    80003eb4:	8f6080e7          	jalr	-1802(ra) # 800037a6 <bfree>
      ip->addrs[i] = 0;
    80003eb8:	0004a023          	sw	zero,0(s1)
    80003ebc:	b7dd                	j	80003ea2 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003ebe:	0809a583          	lw	a1,128(s3)
    80003ec2:	e185                	bnez	a1,80003ee2 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003ec4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003ec8:	854e                	mv	a0,s3
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	de2080e7          	jalr	-542(ra) # 80003cac <iupdate>
}
    80003ed2:	70a2                	ld	ra,40(sp)
    80003ed4:	7402                	ld	s0,32(sp)
    80003ed6:	64e2                	ld	s1,24(sp)
    80003ed8:	6942                	ld	s2,16(sp)
    80003eda:	69a2                	ld	s3,8(sp)
    80003edc:	6a02                	ld	s4,0(sp)
    80003ede:	6145                	addi	sp,sp,48
    80003ee0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003ee2:	0009a503          	lw	a0,0(s3)
    80003ee6:	fffff097          	auipc	ra,0xfffff
    80003eea:	67a080e7          	jalr	1658(ra) # 80003560 <bread>
    80003eee:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003ef0:	05850493          	addi	s1,a0,88
    80003ef4:	45850913          	addi	s2,a0,1112
    80003ef8:	a021                	j	80003f00 <itrunc+0x7a>
    80003efa:	0491                	addi	s1,s1,4
    80003efc:	01248b63          	beq	s1,s2,80003f12 <itrunc+0x8c>
      if(a[j])
    80003f00:	408c                	lw	a1,0(s1)
    80003f02:	dde5                	beqz	a1,80003efa <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003f04:	0009a503          	lw	a0,0(s3)
    80003f08:	00000097          	auipc	ra,0x0
    80003f0c:	89e080e7          	jalr	-1890(ra) # 800037a6 <bfree>
    80003f10:	b7ed                	j	80003efa <itrunc+0x74>
    brelse(bp);
    80003f12:	8552                	mv	a0,s4
    80003f14:	fffff097          	auipc	ra,0xfffff
    80003f18:	77c080e7          	jalr	1916(ra) # 80003690 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003f1c:	0809a583          	lw	a1,128(s3)
    80003f20:	0009a503          	lw	a0,0(s3)
    80003f24:	00000097          	auipc	ra,0x0
    80003f28:	882080e7          	jalr	-1918(ra) # 800037a6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003f2c:	0809a023          	sw	zero,128(s3)
    80003f30:	bf51                	j	80003ec4 <itrunc+0x3e>

0000000080003f32 <iput>:
{
    80003f32:	1101                	addi	sp,sp,-32
    80003f34:	ec06                	sd	ra,24(sp)
    80003f36:	e822                	sd	s0,16(sp)
    80003f38:	e426                	sd	s1,8(sp)
    80003f3a:	e04a                	sd	s2,0(sp)
    80003f3c:	1000                	addi	s0,sp,32
    80003f3e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003f40:	0023c517          	auipc	a0,0x23c
    80003f44:	b9050513          	addi	a0,a0,-1136 # 8023fad0 <itable>
    80003f48:	ffffd097          	auipc	ra,0xffffd
    80003f4c:	e02080e7          	jalr	-510(ra) # 80000d4a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f50:	4498                	lw	a4,8(s1)
    80003f52:	4785                	li	a5,1
    80003f54:	02f70363          	beq	a4,a5,80003f7a <iput+0x48>
  ip->ref--;
    80003f58:	449c                	lw	a5,8(s1)
    80003f5a:	37fd                	addiw	a5,a5,-1
    80003f5c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003f5e:	0023c517          	auipc	a0,0x23c
    80003f62:	b7250513          	addi	a0,a0,-1166 # 8023fad0 <itable>
    80003f66:	ffffd097          	auipc	ra,0xffffd
    80003f6a:	e98080e7          	jalr	-360(ra) # 80000dfe <release>
}
    80003f6e:	60e2                	ld	ra,24(sp)
    80003f70:	6442                	ld	s0,16(sp)
    80003f72:	64a2                	ld	s1,8(sp)
    80003f74:	6902                	ld	s2,0(sp)
    80003f76:	6105                	addi	sp,sp,32
    80003f78:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f7a:	40bc                	lw	a5,64(s1)
    80003f7c:	dff1                	beqz	a5,80003f58 <iput+0x26>
    80003f7e:	04a49783          	lh	a5,74(s1)
    80003f82:	fbf9                	bnez	a5,80003f58 <iput+0x26>
    acquiresleep(&ip->lock);
    80003f84:	01048913          	addi	s2,s1,16
    80003f88:	854a                	mv	a0,s2
    80003f8a:	00001097          	auipc	ra,0x1
    80003f8e:	aae080e7          	jalr	-1362(ra) # 80004a38 <acquiresleep>
    release(&itable.lock);
    80003f92:	0023c517          	auipc	a0,0x23c
    80003f96:	b3e50513          	addi	a0,a0,-1218 # 8023fad0 <itable>
    80003f9a:	ffffd097          	auipc	ra,0xffffd
    80003f9e:	e64080e7          	jalr	-412(ra) # 80000dfe <release>
    itrunc(ip);
    80003fa2:	8526                	mv	a0,s1
    80003fa4:	00000097          	auipc	ra,0x0
    80003fa8:	ee2080e7          	jalr	-286(ra) # 80003e86 <itrunc>
    ip->type = 0;
    80003fac:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003fb0:	8526                	mv	a0,s1
    80003fb2:	00000097          	auipc	ra,0x0
    80003fb6:	cfa080e7          	jalr	-774(ra) # 80003cac <iupdate>
    ip->valid = 0;
    80003fba:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003fbe:	854a                	mv	a0,s2
    80003fc0:	00001097          	auipc	ra,0x1
    80003fc4:	ace080e7          	jalr	-1330(ra) # 80004a8e <releasesleep>
    acquire(&itable.lock);
    80003fc8:	0023c517          	auipc	a0,0x23c
    80003fcc:	b0850513          	addi	a0,a0,-1272 # 8023fad0 <itable>
    80003fd0:	ffffd097          	auipc	ra,0xffffd
    80003fd4:	d7a080e7          	jalr	-646(ra) # 80000d4a <acquire>
    80003fd8:	b741                	j	80003f58 <iput+0x26>

0000000080003fda <iunlockput>:
{
    80003fda:	1101                	addi	sp,sp,-32
    80003fdc:	ec06                	sd	ra,24(sp)
    80003fde:	e822                	sd	s0,16(sp)
    80003fe0:	e426                	sd	s1,8(sp)
    80003fe2:	1000                	addi	s0,sp,32
    80003fe4:	84aa                	mv	s1,a0
  iunlock(ip);
    80003fe6:	00000097          	auipc	ra,0x0
    80003fea:	e54080e7          	jalr	-428(ra) # 80003e3a <iunlock>
  iput(ip);
    80003fee:	8526                	mv	a0,s1
    80003ff0:	00000097          	auipc	ra,0x0
    80003ff4:	f42080e7          	jalr	-190(ra) # 80003f32 <iput>
}
    80003ff8:	60e2                	ld	ra,24(sp)
    80003ffa:	6442                	ld	s0,16(sp)
    80003ffc:	64a2                	ld	s1,8(sp)
    80003ffe:	6105                	addi	sp,sp,32
    80004000:	8082                	ret

0000000080004002 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004002:	1141                	addi	sp,sp,-16
    80004004:	e422                	sd	s0,8(sp)
    80004006:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004008:	411c                	lw	a5,0(a0)
    8000400a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000400c:	415c                	lw	a5,4(a0)
    8000400e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004010:	04451783          	lh	a5,68(a0)
    80004014:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004018:	04a51783          	lh	a5,74(a0)
    8000401c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004020:	04c56783          	lwu	a5,76(a0)
    80004024:	e99c                	sd	a5,16(a1)
}
    80004026:	6422                	ld	s0,8(sp)
    80004028:	0141                	addi	sp,sp,16
    8000402a:	8082                	ret

000000008000402c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000402c:	457c                	lw	a5,76(a0)
    8000402e:	0ed7e963          	bltu	a5,a3,80004120 <readi+0xf4>
{
    80004032:	7159                	addi	sp,sp,-112
    80004034:	f486                	sd	ra,104(sp)
    80004036:	f0a2                	sd	s0,96(sp)
    80004038:	eca6                	sd	s1,88(sp)
    8000403a:	e8ca                	sd	s2,80(sp)
    8000403c:	e4ce                	sd	s3,72(sp)
    8000403e:	e0d2                	sd	s4,64(sp)
    80004040:	fc56                	sd	s5,56(sp)
    80004042:	f85a                	sd	s6,48(sp)
    80004044:	f45e                	sd	s7,40(sp)
    80004046:	f062                	sd	s8,32(sp)
    80004048:	ec66                	sd	s9,24(sp)
    8000404a:	e86a                	sd	s10,16(sp)
    8000404c:	e46e                	sd	s11,8(sp)
    8000404e:	1880                	addi	s0,sp,112
    80004050:	8b2a                	mv	s6,a0
    80004052:	8bae                	mv	s7,a1
    80004054:	8a32                	mv	s4,a2
    80004056:	84b6                	mv	s1,a3
    80004058:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000405a:	9f35                	addw	a4,a4,a3
    return 0;
    8000405c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000405e:	0ad76063          	bltu	a4,a3,800040fe <readi+0xd2>
  if(off + n > ip->size)
    80004062:	00e7f463          	bgeu	a5,a4,8000406a <readi+0x3e>
    n = ip->size - off;
    80004066:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000406a:	0a0a8963          	beqz	s5,8000411c <readi+0xf0>
    8000406e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004070:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004074:	5c7d                	li	s8,-1
    80004076:	a82d                	j	800040b0 <readi+0x84>
    80004078:	020d1d93          	slli	s11,s10,0x20
    8000407c:	020ddd93          	srli	s11,s11,0x20
    80004080:	05890613          	addi	a2,s2,88
    80004084:	86ee                	mv	a3,s11
    80004086:	963a                	add	a2,a2,a4
    80004088:	85d2                	mv	a1,s4
    8000408a:	855e                	mv	a0,s7
    8000408c:	ffffe097          	auipc	ra,0xffffe
    80004090:	780080e7          	jalr	1920(ra) # 8000280c <either_copyout>
    80004094:	05850d63          	beq	a0,s8,800040ee <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004098:	854a                	mv	a0,s2
    8000409a:	fffff097          	auipc	ra,0xfffff
    8000409e:	5f6080e7          	jalr	1526(ra) # 80003690 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800040a2:	013d09bb          	addw	s3,s10,s3
    800040a6:	009d04bb          	addw	s1,s10,s1
    800040aa:	9a6e                	add	s4,s4,s11
    800040ac:	0559f763          	bgeu	s3,s5,800040fa <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800040b0:	00a4d59b          	srliw	a1,s1,0xa
    800040b4:	855a                	mv	a0,s6
    800040b6:	00000097          	auipc	ra,0x0
    800040ba:	89e080e7          	jalr	-1890(ra) # 80003954 <bmap>
    800040be:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800040c2:	cd85                	beqz	a1,800040fa <readi+0xce>
    bp = bread(ip->dev, addr);
    800040c4:	000b2503          	lw	a0,0(s6)
    800040c8:	fffff097          	auipc	ra,0xfffff
    800040cc:	498080e7          	jalr	1176(ra) # 80003560 <bread>
    800040d0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800040d2:	3ff4f713          	andi	a4,s1,1023
    800040d6:	40ec87bb          	subw	a5,s9,a4
    800040da:	413a86bb          	subw	a3,s5,s3
    800040de:	8d3e                	mv	s10,a5
    800040e0:	2781                	sext.w	a5,a5
    800040e2:	0006861b          	sext.w	a2,a3
    800040e6:	f8f679e3          	bgeu	a2,a5,80004078 <readi+0x4c>
    800040ea:	8d36                	mv	s10,a3
    800040ec:	b771                	j	80004078 <readi+0x4c>
      brelse(bp);
    800040ee:	854a                	mv	a0,s2
    800040f0:	fffff097          	auipc	ra,0xfffff
    800040f4:	5a0080e7          	jalr	1440(ra) # 80003690 <brelse>
      tot = -1;
    800040f8:	59fd                	li	s3,-1
  }
  return tot;
    800040fa:	0009851b          	sext.w	a0,s3
}
    800040fe:	70a6                	ld	ra,104(sp)
    80004100:	7406                	ld	s0,96(sp)
    80004102:	64e6                	ld	s1,88(sp)
    80004104:	6946                	ld	s2,80(sp)
    80004106:	69a6                	ld	s3,72(sp)
    80004108:	6a06                	ld	s4,64(sp)
    8000410a:	7ae2                	ld	s5,56(sp)
    8000410c:	7b42                	ld	s6,48(sp)
    8000410e:	7ba2                	ld	s7,40(sp)
    80004110:	7c02                	ld	s8,32(sp)
    80004112:	6ce2                	ld	s9,24(sp)
    80004114:	6d42                	ld	s10,16(sp)
    80004116:	6da2                	ld	s11,8(sp)
    80004118:	6165                	addi	sp,sp,112
    8000411a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000411c:	89d6                	mv	s3,s5
    8000411e:	bff1                	j	800040fa <readi+0xce>
    return 0;
    80004120:	4501                	li	a0,0
}
    80004122:	8082                	ret

0000000080004124 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004124:	457c                	lw	a5,76(a0)
    80004126:	10d7e863          	bltu	a5,a3,80004236 <writei+0x112>
{
    8000412a:	7159                	addi	sp,sp,-112
    8000412c:	f486                	sd	ra,104(sp)
    8000412e:	f0a2                	sd	s0,96(sp)
    80004130:	eca6                	sd	s1,88(sp)
    80004132:	e8ca                	sd	s2,80(sp)
    80004134:	e4ce                	sd	s3,72(sp)
    80004136:	e0d2                	sd	s4,64(sp)
    80004138:	fc56                	sd	s5,56(sp)
    8000413a:	f85a                	sd	s6,48(sp)
    8000413c:	f45e                	sd	s7,40(sp)
    8000413e:	f062                	sd	s8,32(sp)
    80004140:	ec66                	sd	s9,24(sp)
    80004142:	e86a                	sd	s10,16(sp)
    80004144:	e46e                	sd	s11,8(sp)
    80004146:	1880                	addi	s0,sp,112
    80004148:	8aaa                	mv	s5,a0
    8000414a:	8bae                	mv	s7,a1
    8000414c:	8a32                	mv	s4,a2
    8000414e:	8936                	mv	s2,a3
    80004150:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004152:	00e687bb          	addw	a5,a3,a4
    80004156:	0ed7e263          	bltu	a5,a3,8000423a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000415a:	00043737          	lui	a4,0x43
    8000415e:	0ef76063          	bltu	a4,a5,8000423e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004162:	0c0b0863          	beqz	s6,80004232 <writei+0x10e>
    80004166:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004168:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000416c:	5c7d                	li	s8,-1
    8000416e:	a091                	j	800041b2 <writei+0x8e>
    80004170:	020d1d93          	slli	s11,s10,0x20
    80004174:	020ddd93          	srli	s11,s11,0x20
    80004178:	05848513          	addi	a0,s1,88
    8000417c:	86ee                	mv	a3,s11
    8000417e:	8652                	mv	a2,s4
    80004180:	85de                	mv	a1,s7
    80004182:	953a                	add	a0,a0,a4
    80004184:	ffffe097          	auipc	ra,0xffffe
    80004188:	6de080e7          	jalr	1758(ra) # 80002862 <either_copyin>
    8000418c:	07850263          	beq	a0,s8,800041f0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004190:	8526                	mv	a0,s1
    80004192:	00000097          	auipc	ra,0x0
    80004196:	788080e7          	jalr	1928(ra) # 8000491a <log_write>
    brelse(bp);
    8000419a:	8526                	mv	a0,s1
    8000419c:	fffff097          	auipc	ra,0xfffff
    800041a0:	4f4080e7          	jalr	1268(ra) # 80003690 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800041a4:	013d09bb          	addw	s3,s10,s3
    800041a8:	012d093b          	addw	s2,s10,s2
    800041ac:	9a6e                	add	s4,s4,s11
    800041ae:	0569f663          	bgeu	s3,s6,800041fa <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800041b2:	00a9559b          	srliw	a1,s2,0xa
    800041b6:	8556                	mv	a0,s5
    800041b8:	fffff097          	auipc	ra,0xfffff
    800041bc:	79c080e7          	jalr	1948(ra) # 80003954 <bmap>
    800041c0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800041c4:	c99d                	beqz	a1,800041fa <writei+0xd6>
    bp = bread(ip->dev, addr);
    800041c6:	000aa503          	lw	a0,0(s5)
    800041ca:	fffff097          	auipc	ra,0xfffff
    800041ce:	396080e7          	jalr	918(ra) # 80003560 <bread>
    800041d2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800041d4:	3ff97713          	andi	a4,s2,1023
    800041d8:	40ec87bb          	subw	a5,s9,a4
    800041dc:	413b06bb          	subw	a3,s6,s3
    800041e0:	8d3e                	mv	s10,a5
    800041e2:	2781                	sext.w	a5,a5
    800041e4:	0006861b          	sext.w	a2,a3
    800041e8:	f8f674e3          	bgeu	a2,a5,80004170 <writei+0x4c>
    800041ec:	8d36                	mv	s10,a3
    800041ee:	b749                	j	80004170 <writei+0x4c>
      brelse(bp);
    800041f0:	8526                	mv	a0,s1
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	49e080e7          	jalr	1182(ra) # 80003690 <brelse>
  }

  if(off > ip->size)
    800041fa:	04caa783          	lw	a5,76(s5)
    800041fe:	0127f463          	bgeu	a5,s2,80004206 <writei+0xe2>
    ip->size = off;
    80004202:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004206:	8556                	mv	a0,s5
    80004208:	00000097          	auipc	ra,0x0
    8000420c:	aa4080e7          	jalr	-1372(ra) # 80003cac <iupdate>

  return tot;
    80004210:	0009851b          	sext.w	a0,s3
}
    80004214:	70a6                	ld	ra,104(sp)
    80004216:	7406                	ld	s0,96(sp)
    80004218:	64e6                	ld	s1,88(sp)
    8000421a:	6946                	ld	s2,80(sp)
    8000421c:	69a6                	ld	s3,72(sp)
    8000421e:	6a06                	ld	s4,64(sp)
    80004220:	7ae2                	ld	s5,56(sp)
    80004222:	7b42                	ld	s6,48(sp)
    80004224:	7ba2                	ld	s7,40(sp)
    80004226:	7c02                	ld	s8,32(sp)
    80004228:	6ce2                	ld	s9,24(sp)
    8000422a:	6d42                	ld	s10,16(sp)
    8000422c:	6da2                	ld	s11,8(sp)
    8000422e:	6165                	addi	sp,sp,112
    80004230:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004232:	89da                	mv	s3,s6
    80004234:	bfc9                	j	80004206 <writei+0xe2>
    return -1;
    80004236:	557d                	li	a0,-1
}
    80004238:	8082                	ret
    return -1;
    8000423a:	557d                	li	a0,-1
    8000423c:	bfe1                	j	80004214 <writei+0xf0>
    return -1;
    8000423e:	557d                	li	a0,-1
    80004240:	bfd1                	j	80004214 <writei+0xf0>

0000000080004242 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004242:	1141                	addi	sp,sp,-16
    80004244:	e406                	sd	ra,8(sp)
    80004246:	e022                	sd	s0,0(sp)
    80004248:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000424a:	4639                	li	a2,14
    8000424c:	ffffd097          	auipc	ra,0xffffd
    80004250:	cca080e7          	jalr	-822(ra) # 80000f16 <strncmp>
}
    80004254:	60a2                	ld	ra,8(sp)
    80004256:	6402                	ld	s0,0(sp)
    80004258:	0141                	addi	sp,sp,16
    8000425a:	8082                	ret

000000008000425c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000425c:	7139                	addi	sp,sp,-64
    8000425e:	fc06                	sd	ra,56(sp)
    80004260:	f822                	sd	s0,48(sp)
    80004262:	f426                	sd	s1,40(sp)
    80004264:	f04a                	sd	s2,32(sp)
    80004266:	ec4e                	sd	s3,24(sp)
    80004268:	e852                	sd	s4,16(sp)
    8000426a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000426c:	04451703          	lh	a4,68(a0)
    80004270:	4785                	li	a5,1
    80004272:	00f71a63          	bne	a4,a5,80004286 <dirlookup+0x2a>
    80004276:	892a                	mv	s2,a0
    80004278:	89ae                	mv	s3,a1
    8000427a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000427c:	457c                	lw	a5,76(a0)
    8000427e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004280:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004282:	e79d                	bnez	a5,800042b0 <dirlookup+0x54>
    80004284:	a8a5                	j	800042fc <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004286:	00004517          	auipc	a0,0x4
    8000428a:	3aa50513          	addi	a0,a0,938 # 80008630 <syscalls+0x1b8>
    8000428e:	ffffc097          	auipc	ra,0xffffc
    80004292:	2b2080e7          	jalr	690(ra) # 80000540 <panic>
      panic("dirlookup read");
    80004296:	00004517          	auipc	a0,0x4
    8000429a:	3b250513          	addi	a0,a0,946 # 80008648 <syscalls+0x1d0>
    8000429e:	ffffc097          	auipc	ra,0xffffc
    800042a2:	2a2080e7          	jalr	674(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800042a6:	24c1                	addiw	s1,s1,16
    800042a8:	04c92783          	lw	a5,76(s2)
    800042ac:	04f4f763          	bgeu	s1,a5,800042fa <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042b0:	4741                	li	a4,16
    800042b2:	86a6                	mv	a3,s1
    800042b4:	fc040613          	addi	a2,s0,-64
    800042b8:	4581                	li	a1,0
    800042ba:	854a                	mv	a0,s2
    800042bc:	00000097          	auipc	ra,0x0
    800042c0:	d70080e7          	jalr	-656(ra) # 8000402c <readi>
    800042c4:	47c1                	li	a5,16
    800042c6:	fcf518e3          	bne	a0,a5,80004296 <dirlookup+0x3a>
    if(de.inum == 0)
    800042ca:	fc045783          	lhu	a5,-64(s0)
    800042ce:	dfe1                	beqz	a5,800042a6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800042d0:	fc240593          	addi	a1,s0,-62
    800042d4:	854e                	mv	a0,s3
    800042d6:	00000097          	auipc	ra,0x0
    800042da:	f6c080e7          	jalr	-148(ra) # 80004242 <namecmp>
    800042de:	f561                	bnez	a0,800042a6 <dirlookup+0x4a>
      if(poff)
    800042e0:	000a0463          	beqz	s4,800042e8 <dirlookup+0x8c>
        *poff = off;
    800042e4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800042e8:	fc045583          	lhu	a1,-64(s0)
    800042ec:	00092503          	lw	a0,0(s2)
    800042f0:	fffff097          	auipc	ra,0xfffff
    800042f4:	74e080e7          	jalr	1870(ra) # 80003a3e <iget>
    800042f8:	a011                	j	800042fc <dirlookup+0xa0>
  return 0;
    800042fa:	4501                	li	a0,0
}
    800042fc:	70e2                	ld	ra,56(sp)
    800042fe:	7442                	ld	s0,48(sp)
    80004300:	74a2                	ld	s1,40(sp)
    80004302:	7902                	ld	s2,32(sp)
    80004304:	69e2                	ld	s3,24(sp)
    80004306:	6a42                	ld	s4,16(sp)
    80004308:	6121                	addi	sp,sp,64
    8000430a:	8082                	ret

000000008000430c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000430c:	711d                	addi	sp,sp,-96
    8000430e:	ec86                	sd	ra,88(sp)
    80004310:	e8a2                	sd	s0,80(sp)
    80004312:	e4a6                	sd	s1,72(sp)
    80004314:	e0ca                	sd	s2,64(sp)
    80004316:	fc4e                	sd	s3,56(sp)
    80004318:	f852                	sd	s4,48(sp)
    8000431a:	f456                	sd	s5,40(sp)
    8000431c:	f05a                	sd	s6,32(sp)
    8000431e:	ec5e                	sd	s7,24(sp)
    80004320:	e862                	sd	s8,16(sp)
    80004322:	e466                	sd	s9,8(sp)
    80004324:	e06a                	sd	s10,0(sp)
    80004326:	1080                	addi	s0,sp,96
    80004328:	84aa                	mv	s1,a0
    8000432a:	8b2e                	mv	s6,a1
    8000432c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000432e:	00054703          	lbu	a4,0(a0)
    80004332:	02f00793          	li	a5,47
    80004336:	02f70363          	beq	a4,a5,8000435c <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000433a:	ffffe097          	auipc	ra,0xffffe
    8000433e:	8c8080e7          	jalr	-1848(ra) # 80001c02 <myproc>
    80004342:	15053503          	ld	a0,336(a0)
    80004346:	00000097          	auipc	ra,0x0
    8000434a:	9f4080e7          	jalr	-1548(ra) # 80003d3a <idup>
    8000434e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004350:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004354:	4cb5                	li	s9,13
  len = path - s;
    80004356:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004358:	4c05                	li	s8,1
    8000435a:	a87d                	j	80004418 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000435c:	4585                	li	a1,1
    8000435e:	4505                	li	a0,1
    80004360:	fffff097          	auipc	ra,0xfffff
    80004364:	6de080e7          	jalr	1758(ra) # 80003a3e <iget>
    80004368:	8a2a                	mv	s4,a0
    8000436a:	b7dd                	j	80004350 <namex+0x44>
      iunlockput(ip);
    8000436c:	8552                	mv	a0,s4
    8000436e:	00000097          	auipc	ra,0x0
    80004372:	c6c080e7          	jalr	-916(ra) # 80003fda <iunlockput>
      return 0;
    80004376:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004378:	8552                	mv	a0,s4
    8000437a:	60e6                	ld	ra,88(sp)
    8000437c:	6446                	ld	s0,80(sp)
    8000437e:	64a6                	ld	s1,72(sp)
    80004380:	6906                	ld	s2,64(sp)
    80004382:	79e2                	ld	s3,56(sp)
    80004384:	7a42                	ld	s4,48(sp)
    80004386:	7aa2                	ld	s5,40(sp)
    80004388:	7b02                	ld	s6,32(sp)
    8000438a:	6be2                	ld	s7,24(sp)
    8000438c:	6c42                	ld	s8,16(sp)
    8000438e:	6ca2                	ld	s9,8(sp)
    80004390:	6d02                	ld	s10,0(sp)
    80004392:	6125                	addi	sp,sp,96
    80004394:	8082                	ret
      iunlock(ip);
    80004396:	8552                	mv	a0,s4
    80004398:	00000097          	auipc	ra,0x0
    8000439c:	aa2080e7          	jalr	-1374(ra) # 80003e3a <iunlock>
      return ip;
    800043a0:	bfe1                	j	80004378 <namex+0x6c>
      iunlockput(ip);
    800043a2:	8552                	mv	a0,s4
    800043a4:	00000097          	auipc	ra,0x0
    800043a8:	c36080e7          	jalr	-970(ra) # 80003fda <iunlockput>
      return 0;
    800043ac:	8a4e                	mv	s4,s3
    800043ae:	b7e9                	j	80004378 <namex+0x6c>
  len = path - s;
    800043b0:	40998633          	sub	a2,s3,s1
    800043b4:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800043b8:	09acd863          	bge	s9,s10,80004448 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800043bc:	4639                	li	a2,14
    800043be:	85a6                	mv	a1,s1
    800043c0:	8556                	mv	a0,s5
    800043c2:	ffffd097          	auipc	ra,0xffffd
    800043c6:	ae0080e7          	jalr	-1312(ra) # 80000ea2 <memmove>
    800043ca:	84ce                	mv	s1,s3
  while(*path == '/')
    800043cc:	0004c783          	lbu	a5,0(s1)
    800043d0:	01279763          	bne	a5,s2,800043de <namex+0xd2>
    path++;
    800043d4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800043d6:	0004c783          	lbu	a5,0(s1)
    800043da:	ff278de3          	beq	a5,s2,800043d4 <namex+0xc8>
    ilock(ip);
    800043de:	8552                	mv	a0,s4
    800043e0:	00000097          	auipc	ra,0x0
    800043e4:	998080e7          	jalr	-1640(ra) # 80003d78 <ilock>
    if(ip->type != T_DIR){
    800043e8:	044a1783          	lh	a5,68(s4)
    800043ec:	f98790e3          	bne	a5,s8,8000436c <namex+0x60>
    if(nameiparent && *path == '\0'){
    800043f0:	000b0563          	beqz	s6,800043fa <namex+0xee>
    800043f4:	0004c783          	lbu	a5,0(s1)
    800043f8:	dfd9                	beqz	a5,80004396 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800043fa:	865e                	mv	a2,s7
    800043fc:	85d6                	mv	a1,s5
    800043fe:	8552                	mv	a0,s4
    80004400:	00000097          	auipc	ra,0x0
    80004404:	e5c080e7          	jalr	-420(ra) # 8000425c <dirlookup>
    80004408:	89aa                	mv	s3,a0
    8000440a:	dd41                	beqz	a0,800043a2 <namex+0x96>
    iunlockput(ip);
    8000440c:	8552                	mv	a0,s4
    8000440e:	00000097          	auipc	ra,0x0
    80004412:	bcc080e7          	jalr	-1076(ra) # 80003fda <iunlockput>
    ip = next;
    80004416:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004418:	0004c783          	lbu	a5,0(s1)
    8000441c:	01279763          	bne	a5,s2,8000442a <namex+0x11e>
    path++;
    80004420:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004422:	0004c783          	lbu	a5,0(s1)
    80004426:	ff278de3          	beq	a5,s2,80004420 <namex+0x114>
  if(*path == 0)
    8000442a:	cb9d                	beqz	a5,80004460 <namex+0x154>
  while(*path != '/' && *path != 0)
    8000442c:	0004c783          	lbu	a5,0(s1)
    80004430:	89a6                	mv	s3,s1
  len = path - s;
    80004432:	8d5e                	mv	s10,s7
    80004434:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80004436:	01278963          	beq	a5,s2,80004448 <namex+0x13c>
    8000443a:	dbbd                	beqz	a5,800043b0 <namex+0xa4>
    path++;
    8000443c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000443e:	0009c783          	lbu	a5,0(s3)
    80004442:	ff279ce3          	bne	a5,s2,8000443a <namex+0x12e>
    80004446:	b7ad                	j	800043b0 <namex+0xa4>
    memmove(name, s, len);
    80004448:	2601                	sext.w	a2,a2
    8000444a:	85a6                	mv	a1,s1
    8000444c:	8556                	mv	a0,s5
    8000444e:	ffffd097          	auipc	ra,0xffffd
    80004452:	a54080e7          	jalr	-1452(ra) # 80000ea2 <memmove>
    name[len] = 0;
    80004456:	9d56                	add	s10,s10,s5
    80004458:	000d0023          	sb	zero,0(s10)
    8000445c:	84ce                	mv	s1,s3
    8000445e:	b7bd                	j	800043cc <namex+0xc0>
  if(nameiparent){
    80004460:	f00b0ce3          	beqz	s6,80004378 <namex+0x6c>
    iput(ip);
    80004464:	8552                	mv	a0,s4
    80004466:	00000097          	auipc	ra,0x0
    8000446a:	acc080e7          	jalr	-1332(ra) # 80003f32 <iput>
    return 0;
    8000446e:	4a01                	li	s4,0
    80004470:	b721                	j	80004378 <namex+0x6c>

0000000080004472 <dirlink>:
{
    80004472:	7139                	addi	sp,sp,-64
    80004474:	fc06                	sd	ra,56(sp)
    80004476:	f822                	sd	s0,48(sp)
    80004478:	f426                	sd	s1,40(sp)
    8000447a:	f04a                	sd	s2,32(sp)
    8000447c:	ec4e                	sd	s3,24(sp)
    8000447e:	e852                	sd	s4,16(sp)
    80004480:	0080                	addi	s0,sp,64
    80004482:	892a                	mv	s2,a0
    80004484:	8a2e                	mv	s4,a1
    80004486:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004488:	4601                	li	a2,0
    8000448a:	00000097          	auipc	ra,0x0
    8000448e:	dd2080e7          	jalr	-558(ra) # 8000425c <dirlookup>
    80004492:	e93d                	bnez	a0,80004508 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004494:	04c92483          	lw	s1,76(s2)
    80004498:	c49d                	beqz	s1,800044c6 <dirlink+0x54>
    8000449a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000449c:	4741                	li	a4,16
    8000449e:	86a6                	mv	a3,s1
    800044a0:	fc040613          	addi	a2,s0,-64
    800044a4:	4581                	li	a1,0
    800044a6:	854a                	mv	a0,s2
    800044a8:	00000097          	auipc	ra,0x0
    800044ac:	b84080e7          	jalr	-1148(ra) # 8000402c <readi>
    800044b0:	47c1                	li	a5,16
    800044b2:	06f51163          	bne	a0,a5,80004514 <dirlink+0xa2>
    if(de.inum == 0)
    800044b6:	fc045783          	lhu	a5,-64(s0)
    800044ba:	c791                	beqz	a5,800044c6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044bc:	24c1                	addiw	s1,s1,16
    800044be:	04c92783          	lw	a5,76(s2)
    800044c2:	fcf4ede3          	bltu	s1,a5,8000449c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800044c6:	4639                	li	a2,14
    800044c8:	85d2                	mv	a1,s4
    800044ca:	fc240513          	addi	a0,s0,-62
    800044ce:	ffffd097          	auipc	ra,0xffffd
    800044d2:	a84080e7          	jalr	-1404(ra) # 80000f52 <strncpy>
  de.inum = inum;
    800044d6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044da:	4741                	li	a4,16
    800044dc:	86a6                	mv	a3,s1
    800044de:	fc040613          	addi	a2,s0,-64
    800044e2:	4581                	li	a1,0
    800044e4:	854a                	mv	a0,s2
    800044e6:	00000097          	auipc	ra,0x0
    800044ea:	c3e080e7          	jalr	-962(ra) # 80004124 <writei>
    800044ee:	1541                	addi	a0,a0,-16
    800044f0:	00a03533          	snez	a0,a0
    800044f4:	40a00533          	neg	a0,a0
}
    800044f8:	70e2                	ld	ra,56(sp)
    800044fa:	7442                	ld	s0,48(sp)
    800044fc:	74a2                	ld	s1,40(sp)
    800044fe:	7902                	ld	s2,32(sp)
    80004500:	69e2                	ld	s3,24(sp)
    80004502:	6a42                	ld	s4,16(sp)
    80004504:	6121                	addi	sp,sp,64
    80004506:	8082                	ret
    iput(ip);
    80004508:	00000097          	auipc	ra,0x0
    8000450c:	a2a080e7          	jalr	-1494(ra) # 80003f32 <iput>
    return -1;
    80004510:	557d                	li	a0,-1
    80004512:	b7dd                	j	800044f8 <dirlink+0x86>
      panic("dirlink read");
    80004514:	00004517          	auipc	a0,0x4
    80004518:	14450513          	addi	a0,a0,324 # 80008658 <syscalls+0x1e0>
    8000451c:	ffffc097          	auipc	ra,0xffffc
    80004520:	024080e7          	jalr	36(ra) # 80000540 <panic>

0000000080004524 <namei>:

struct inode*
namei(char *path)
{
    80004524:	1101                	addi	sp,sp,-32
    80004526:	ec06                	sd	ra,24(sp)
    80004528:	e822                	sd	s0,16(sp)
    8000452a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000452c:	fe040613          	addi	a2,s0,-32
    80004530:	4581                	li	a1,0
    80004532:	00000097          	auipc	ra,0x0
    80004536:	dda080e7          	jalr	-550(ra) # 8000430c <namex>
}
    8000453a:	60e2                	ld	ra,24(sp)
    8000453c:	6442                	ld	s0,16(sp)
    8000453e:	6105                	addi	sp,sp,32
    80004540:	8082                	ret

0000000080004542 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004542:	1141                	addi	sp,sp,-16
    80004544:	e406                	sd	ra,8(sp)
    80004546:	e022                	sd	s0,0(sp)
    80004548:	0800                	addi	s0,sp,16
    8000454a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000454c:	4585                	li	a1,1
    8000454e:	00000097          	auipc	ra,0x0
    80004552:	dbe080e7          	jalr	-578(ra) # 8000430c <namex>
}
    80004556:	60a2                	ld	ra,8(sp)
    80004558:	6402                	ld	s0,0(sp)
    8000455a:	0141                	addi	sp,sp,16
    8000455c:	8082                	ret

000000008000455e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000455e:	1101                	addi	sp,sp,-32
    80004560:	ec06                	sd	ra,24(sp)
    80004562:	e822                	sd	s0,16(sp)
    80004564:	e426                	sd	s1,8(sp)
    80004566:	e04a                	sd	s2,0(sp)
    80004568:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000456a:	0023d917          	auipc	s2,0x23d
    8000456e:	00e90913          	addi	s2,s2,14 # 80241578 <log>
    80004572:	01892583          	lw	a1,24(s2)
    80004576:	02892503          	lw	a0,40(s2)
    8000457a:	fffff097          	auipc	ra,0xfffff
    8000457e:	fe6080e7          	jalr	-26(ra) # 80003560 <bread>
    80004582:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004584:	02c92683          	lw	a3,44(s2)
    80004588:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000458a:	02d05863          	blez	a3,800045ba <write_head+0x5c>
    8000458e:	0023d797          	auipc	a5,0x23d
    80004592:	01a78793          	addi	a5,a5,26 # 802415a8 <log+0x30>
    80004596:	05c50713          	addi	a4,a0,92
    8000459a:	36fd                	addiw	a3,a3,-1
    8000459c:	02069613          	slli	a2,a3,0x20
    800045a0:	01e65693          	srli	a3,a2,0x1e
    800045a4:	0023d617          	auipc	a2,0x23d
    800045a8:	00860613          	addi	a2,a2,8 # 802415ac <log+0x34>
    800045ac:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800045ae:	4390                	lw	a2,0(a5)
    800045b0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800045b2:	0791                	addi	a5,a5,4
    800045b4:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800045b6:	fed79ce3          	bne	a5,a3,800045ae <write_head+0x50>
  }
  bwrite(buf);
    800045ba:	8526                	mv	a0,s1
    800045bc:	fffff097          	auipc	ra,0xfffff
    800045c0:	096080e7          	jalr	150(ra) # 80003652 <bwrite>
  brelse(buf);
    800045c4:	8526                	mv	a0,s1
    800045c6:	fffff097          	auipc	ra,0xfffff
    800045ca:	0ca080e7          	jalr	202(ra) # 80003690 <brelse>
}
    800045ce:	60e2                	ld	ra,24(sp)
    800045d0:	6442                	ld	s0,16(sp)
    800045d2:	64a2                	ld	s1,8(sp)
    800045d4:	6902                	ld	s2,0(sp)
    800045d6:	6105                	addi	sp,sp,32
    800045d8:	8082                	ret

00000000800045da <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800045da:	0023d797          	auipc	a5,0x23d
    800045de:	fca7a783          	lw	a5,-54(a5) # 802415a4 <log+0x2c>
    800045e2:	0af05d63          	blez	a5,8000469c <install_trans+0xc2>
{
    800045e6:	7139                	addi	sp,sp,-64
    800045e8:	fc06                	sd	ra,56(sp)
    800045ea:	f822                	sd	s0,48(sp)
    800045ec:	f426                	sd	s1,40(sp)
    800045ee:	f04a                	sd	s2,32(sp)
    800045f0:	ec4e                	sd	s3,24(sp)
    800045f2:	e852                	sd	s4,16(sp)
    800045f4:	e456                	sd	s5,8(sp)
    800045f6:	e05a                	sd	s6,0(sp)
    800045f8:	0080                	addi	s0,sp,64
    800045fa:	8b2a                	mv	s6,a0
    800045fc:	0023da97          	auipc	s5,0x23d
    80004600:	faca8a93          	addi	s5,s5,-84 # 802415a8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004604:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004606:	0023d997          	auipc	s3,0x23d
    8000460a:	f7298993          	addi	s3,s3,-142 # 80241578 <log>
    8000460e:	a00d                	j	80004630 <install_trans+0x56>
    brelse(lbuf);
    80004610:	854a                	mv	a0,s2
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	07e080e7          	jalr	126(ra) # 80003690 <brelse>
    brelse(dbuf);
    8000461a:	8526                	mv	a0,s1
    8000461c:	fffff097          	auipc	ra,0xfffff
    80004620:	074080e7          	jalr	116(ra) # 80003690 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004624:	2a05                	addiw	s4,s4,1
    80004626:	0a91                	addi	s5,s5,4
    80004628:	02c9a783          	lw	a5,44(s3)
    8000462c:	04fa5e63          	bge	s4,a5,80004688 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004630:	0189a583          	lw	a1,24(s3)
    80004634:	014585bb          	addw	a1,a1,s4
    80004638:	2585                	addiw	a1,a1,1
    8000463a:	0289a503          	lw	a0,40(s3)
    8000463e:	fffff097          	auipc	ra,0xfffff
    80004642:	f22080e7          	jalr	-222(ra) # 80003560 <bread>
    80004646:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004648:	000aa583          	lw	a1,0(s5)
    8000464c:	0289a503          	lw	a0,40(s3)
    80004650:	fffff097          	auipc	ra,0xfffff
    80004654:	f10080e7          	jalr	-240(ra) # 80003560 <bread>
    80004658:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000465a:	40000613          	li	a2,1024
    8000465e:	05890593          	addi	a1,s2,88
    80004662:	05850513          	addi	a0,a0,88
    80004666:	ffffd097          	auipc	ra,0xffffd
    8000466a:	83c080e7          	jalr	-1988(ra) # 80000ea2 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000466e:	8526                	mv	a0,s1
    80004670:	fffff097          	auipc	ra,0xfffff
    80004674:	fe2080e7          	jalr	-30(ra) # 80003652 <bwrite>
    if(recovering == 0)
    80004678:	f80b1ce3          	bnez	s6,80004610 <install_trans+0x36>
      bunpin(dbuf);
    8000467c:	8526                	mv	a0,s1
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	0ec080e7          	jalr	236(ra) # 8000376a <bunpin>
    80004686:	b769                	j	80004610 <install_trans+0x36>
}
    80004688:	70e2                	ld	ra,56(sp)
    8000468a:	7442                	ld	s0,48(sp)
    8000468c:	74a2                	ld	s1,40(sp)
    8000468e:	7902                	ld	s2,32(sp)
    80004690:	69e2                	ld	s3,24(sp)
    80004692:	6a42                	ld	s4,16(sp)
    80004694:	6aa2                	ld	s5,8(sp)
    80004696:	6b02                	ld	s6,0(sp)
    80004698:	6121                	addi	sp,sp,64
    8000469a:	8082                	ret
    8000469c:	8082                	ret

000000008000469e <initlog>:
{
    8000469e:	7179                	addi	sp,sp,-48
    800046a0:	f406                	sd	ra,40(sp)
    800046a2:	f022                	sd	s0,32(sp)
    800046a4:	ec26                	sd	s1,24(sp)
    800046a6:	e84a                	sd	s2,16(sp)
    800046a8:	e44e                	sd	s3,8(sp)
    800046aa:	1800                	addi	s0,sp,48
    800046ac:	892a                	mv	s2,a0
    800046ae:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800046b0:	0023d497          	auipc	s1,0x23d
    800046b4:	ec848493          	addi	s1,s1,-312 # 80241578 <log>
    800046b8:	00004597          	auipc	a1,0x4
    800046bc:	fb058593          	addi	a1,a1,-80 # 80008668 <syscalls+0x1f0>
    800046c0:	8526                	mv	a0,s1
    800046c2:	ffffc097          	auipc	ra,0xffffc
    800046c6:	5f8080e7          	jalr	1528(ra) # 80000cba <initlock>
  log.start = sb->logstart;
    800046ca:	0149a583          	lw	a1,20(s3)
    800046ce:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800046d0:	0109a783          	lw	a5,16(s3)
    800046d4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800046d6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800046da:	854a                	mv	a0,s2
    800046dc:	fffff097          	auipc	ra,0xfffff
    800046e0:	e84080e7          	jalr	-380(ra) # 80003560 <bread>
  log.lh.n = lh->n;
    800046e4:	4d34                	lw	a3,88(a0)
    800046e6:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800046e8:	02d05663          	blez	a3,80004714 <initlog+0x76>
    800046ec:	05c50793          	addi	a5,a0,92
    800046f0:	0023d717          	auipc	a4,0x23d
    800046f4:	eb870713          	addi	a4,a4,-328 # 802415a8 <log+0x30>
    800046f8:	36fd                	addiw	a3,a3,-1
    800046fa:	02069613          	slli	a2,a3,0x20
    800046fe:	01e65693          	srli	a3,a2,0x1e
    80004702:	06050613          	addi	a2,a0,96
    80004706:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004708:	4390                	lw	a2,0(a5)
    8000470a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000470c:	0791                	addi	a5,a5,4
    8000470e:	0711                	addi	a4,a4,4
    80004710:	fed79ce3          	bne	a5,a3,80004708 <initlog+0x6a>
  brelse(buf);
    80004714:	fffff097          	auipc	ra,0xfffff
    80004718:	f7c080e7          	jalr	-132(ra) # 80003690 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000471c:	4505                	li	a0,1
    8000471e:	00000097          	auipc	ra,0x0
    80004722:	ebc080e7          	jalr	-324(ra) # 800045da <install_trans>
  log.lh.n = 0;
    80004726:	0023d797          	auipc	a5,0x23d
    8000472a:	e607af23          	sw	zero,-386(a5) # 802415a4 <log+0x2c>
  write_head(); // clear the log
    8000472e:	00000097          	auipc	ra,0x0
    80004732:	e30080e7          	jalr	-464(ra) # 8000455e <write_head>
}
    80004736:	70a2                	ld	ra,40(sp)
    80004738:	7402                	ld	s0,32(sp)
    8000473a:	64e2                	ld	s1,24(sp)
    8000473c:	6942                	ld	s2,16(sp)
    8000473e:	69a2                	ld	s3,8(sp)
    80004740:	6145                	addi	sp,sp,48
    80004742:	8082                	ret

0000000080004744 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004744:	1101                	addi	sp,sp,-32
    80004746:	ec06                	sd	ra,24(sp)
    80004748:	e822                	sd	s0,16(sp)
    8000474a:	e426                	sd	s1,8(sp)
    8000474c:	e04a                	sd	s2,0(sp)
    8000474e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004750:	0023d517          	auipc	a0,0x23d
    80004754:	e2850513          	addi	a0,a0,-472 # 80241578 <log>
    80004758:	ffffc097          	auipc	ra,0xffffc
    8000475c:	5f2080e7          	jalr	1522(ra) # 80000d4a <acquire>
  while(1){
    if(log.committing){
    80004760:	0023d497          	auipc	s1,0x23d
    80004764:	e1848493          	addi	s1,s1,-488 # 80241578 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004768:	4979                	li	s2,30
    8000476a:	a039                	j	80004778 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000476c:	85a6                	mv	a1,s1
    8000476e:	8526                	mv	a0,s1
    80004770:	ffffe097          	auipc	ra,0xffffe
    80004774:	c88080e7          	jalr	-888(ra) # 800023f8 <sleep>
    if(log.committing){
    80004778:	50dc                	lw	a5,36(s1)
    8000477a:	fbed                	bnez	a5,8000476c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000477c:	5098                	lw	a4,32(s1)
    8000477e:	2705                	addiw	a4,a4,1
    80004780:	0007069b          	sext.w	a3,a4
    80004784:	0027179b          	slliw	a5,a4,0x2
    80004788:	9fb9                	addw	a5,a5,a4
    8000478a:	0017979b          	slliw	a5,a5,0x1
    8000478e:	54d8                	lw	a4,44(s1)
    80004790:	9fb9                	addw	a5,a5,a4
    80004792:	00f95963          	bge	s2,a5,800047a4 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004796:	85a6                	mv	a1,s1
    80004798:	8526                	mv	a0,s1
    8000479a:	ffffe097          	auipc	ra,0xffffe
    8000479e:	c5e080e7          	jalr	-930(ra) # 800023f8 <sleep>
    800047a2:	bfd9                	j	80004778 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800047a4:	0023d517          	auipc	a0,0x23d
    800047a8:	dd450513          	addi	a0,a0,-556 # 80241578 <log>
    800047ac:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800047ae:	ffffc097          	auipc	ra,0xffffc
    800047b2:	650080e7          	jalr	1616(ra) # 80000dfe <release>
      break;
    }
  }
}
    800047b6:	60e2                	ld	ra,24(sp)
    800047b8:	6442                	ld	s0,16(sp)
    800047ba:	64a2                	ld	s1,8(sp)
    800047bc:	6902                	ld	s2,0(sp)
    800047be:	6105                	addi	sp,sp,32
    800047c0:	8082                	ret

00000000800047c2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800047c2:	7139                	addi	sp,sp,-64
    800047c4:	fc06                	sd	ra,56(sp)
    800047c6:	f822                	sd	s0,48(sp)
    800047c8:	f426                	sd	s1,40(sp)
    800047ca:	f04a                	sd	s2,32(sp)
    800047cc:	ec4e                	sd	s3,24(sp)
    800047ce:	e852                	sd	s4,16(sp)
    800047d0:	e456                	sd	s5,8(sp)
    800047d2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800047d4:	0023d497          	auipc	s1,0x23d
    800047d8:	da448493          	addi	s1,s1,-604 # 80241578 <log>
    800047dc:	8526                	mv	a0,s1
    800047de:	ffffc097          	auipc	ra,0xffffc
    800047e2:	56c080e7          	jalr	1388(ra) # 80000d4a <acquire>
  log.outstanding -= 1;
    800047e6:	509c                	lw	a5,32(s1)
    800047e8:	37fd                	addiw	a5,a5,-1
    800047ea:	0007891b          	sext.w	s2,a5
    800047ee:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800047f0:	50dc                	lw	a5,36(s1)
    800047f2:	e7b9                	bnez	a5,80004840 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800047f4:	04091e63          	bnez	s2,80004850 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800047f8:	0023d497          	auipc	s1,0x23d
    800047fc:	d8048493          	addi	s1,s1,-640 # 80241578 <log>
    80004800:	4785                	li	a5,1
    80004802:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004804:	8526                	mv	a0,s1
    80004806:	ffffc097          	auipc	ra,0xffffc
    8000480a:	5f8080e7          	jalr	1528(ra) # 80000dfe <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000480e:	54dc                	lw	a5,44(s1)
    80004810:	06f04763          	bgtz	a5,8000487e <end_op+0xbc>
    acquire(&log.lock);
    80004814:	0023d497          	auipc	s1,0x23d
    80004818:	d6448493          	addi	s1,s1,-668 # 80241578 <log>
    8000481c:	8526                	mv	a0,s1
    8000481e:	ffffc097          	auipc	ra,0xffffc
    80004822:	52c080e7          	jalr	1324(ra) # 80000d4a <acquire>
    log.committing = 0;
    80004826:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000482a:	8526                	mv	a0,s1
    8000482c:	ffffe097          	auipc	ra,0xffffe
    80004830:	c30080e7          	jalr	-976(ra) # 8000245c <wakeup>
    release(&log.lock);
    80004834:	8526                	mv	a0,s1
    80004836:	ffffc097          	auipc	ra,0xffffc
    8000483a:	5c8080e7          	jalr	1480(ra) # 80000dfe <release>
}
    8000483e:	a03d                	j	8000486c <end_op+0xaa>
    panic("log.committing");
    80004840:	00004517          	auipc	a0,0x4
    80004844:	e3050513          	addi	a0,a0,-464 # 80008670 <syscalls+0x1f8>
    80004848:	ffffc097          	auipc	ra,0xffffc
    8000484c:	cf8080e7          	jalr	-776(ra) # 80000540 <panic>
    wakeup(&log);
    80004850:	0023d497          	auipc	s1,0x23d
    80004854:	d2848493          	addi	s1,s1,-728 # 80241578 <log>
    80004858:	8526                	mv	a0,s1
    8000485a:	ffffe097          	auipc	ra,0xffffe
    8000485e:	c02080e7          	jalr	-1022(ra) # 8000245c <wakeup>
  release(&log.lock);
    80004862:	8526                	mv	a0,s1
    80004864:	ffffc097          	auipc	ra,0xffffc
    80004868:	59a080e7          	jalr	1434(ra) # 80000dfe <release>
}
    8000486c:	70e2                	ld	ra,56(sp)
    8000486e:	7442                	ld	s0,48(sp)
    80004870:	74a2                	ld	s1,40(sp)
    80004872:	7902                	ld	s2,32(sp)
    80004874:	69e2                	ld	s3,24(sp)
    80004876:	6a42                	ld	s4,16(sp)
    80004878:	6aa2                	ld	s5,8(sp)
    8000487a:	6121                	addi	sp,sp,64
    8000487c:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000487e:	0023da97          	auipc	s5,0x23d
    80004882:	d2aa8a93          	addi	s5,s5,-726 # 802415a8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004886:	0023da17          	auipc	s4,0x23d
    8000488a:	cf2a0a13          	addi	s4,s4,-782 # 80241578 <log>
    8000488e:	018a2583          	lw	a1,24(s4)
    80004892:	012585bb          	addw	a1,a1,s2
    80004896:	2585                	addiw	a1,a1,1
    80004898:	028a2503          	lw	a0,40(s4)
    8000489c:	fffff097          	auipc	ra,0xfffff
    800048a0:	cc4080e7          	jalr	-828(ra) # 80003560 <bread>
    800048a4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800048a6:	000aa583          	lw	a1,0(s5)
    800048aa:	028a2503          	lw	a0,40(s4)
    800048ae:	fffff097          	auipc	ra,0xfffff
    800048b2:	cb2080e7          	jalr	-846(ra) # 80003560 <bread>
    800048b6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800048b8:	40000613          	li	a2,1024
    800048bc:	05850593          	addi	a1,a0,88
    800048c0:	05848513          	addi	a0,s1,88
    800048c4:	ffffc097          	auipc	ra,0xffffc
    800048c8:	5de080e7          	jalr	1502(ra) # 80000ea2 <memmove>
    bwrite(to);  // write the log
    800048cc:	8526                	mv	a0,s1
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	d84080e7          	jalr	-636(ra) # 80003652 <bwrite>
    brelse(from);
    800048d6:	854e                	mv	a0,s3
    800048d8:	fffff097          	auipc	ra,0xfffff
    800048dc:	db8080e7          	jalr	-584(ra) # 80003690 <brelse>
    brelse(to);
    800048e0:	8526                	mv	a0,s1
    800048e2:	fffff097          	auipc	ra,0xfffff
    800048e6:	dae080e7          	jalr	-594(ra) # 80003690 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800048ea:	2905                	addiw	s2,s2,1
    800048ec:	0a91                	addi	s5,s5,4
    800048ee:	02ca2783          	lw	a5,44(s4)
    800048f2:	f8f94ee3          	blt	s2,a5,8000488e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800048f6:	00000097          	auipc	ra,0x0
    800048fa:	c68080e7          	jalr	-920(ra) # 8000455e <write_head>
    install_trans(0); // Now install writes to home locations
    800048fe:	4501                	li	a0,0
    80004900:	00000097          	auipc	ra,0x0
    80004904:	cda080e7          	jalr	-806(ra) # 800045da <install_trans>
    log.lh.n = 0;
    80004908:	0023d797          	auipc	a5,0x23d
    8000490c:	c807ae23          	sw	zero,-868(a5) # 802415a4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004910:	00000097          	auipc	ra,0x0
    80004914:	c4e080e7          	jalr	-946(ra) # 8000455e <write_head>
    80004918:	bdf5                	j	80004814 <end_op+0x52>

000000008000491a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000491a:	1101                	addi	sp,sp,-32
    8000491c:	ec06                	sd	ra,24(sp)
    8000491e:	e822                	sd	s0,16(sp)
    80004920:	e426                	sd	s1,8(sp)
    80004922:	e04a                	sd	s2,0(sp)
    80004924:	1000                	addi	s0,sp,32
    80004926:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004928:	0023d917          	auipc	s2,0x23d
    8000492c:	c5090913          	addi	s2,s2,-944 # 80241578 <log>
    80004930:	854a                	mv	a0,s2
    80004932:	ffffc097          	auipc	ra,0xffffc
    80004936:	418080e7          	jalr	1048(ra) # 80000d4a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000493a:	02c92603          	lw	a2,44(s2)
    8000493e:	47f5                	li	a5,29
    80004940:	06c7c563          	blt	a5,a2,800049aa <log_write+0x90>
    80004944:	0023d797          	auipc	a5,0x23d
    80004948:	c507a783          	lw	a5,-944(a5) # 80241594 <log+0x1c>
    8000494c:	37fd                	addiw	a5,a5,-1
    8000494e:	04f65e63          	bge	a2,a5,800049aa <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004952:	0023d797          	auipc	a5,0x23d
    80004956:	c467a783          	lw	a5,-954(a5) # 80241598 <log+0x20>
    8000495a:	06f05063          	blez	a5,800049ba <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000495e:	4781                	li	a5,0
    80004960:	06c05563          	blez	a2,800049ca <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004964:	44cc                	lw	a1,12(s1)
    80004966:	0023d717          	auipc	a4,0x23d
    8000496a:	c4270713          	addi	a4,a4,-958 # 802415a8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000496e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004970:	4314                	lw	a3,0(a4)
    80004972:	04b68c63          	beq	a3,a1,800049ca <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004976:	2785                	addiw	a5,a5,1
    80004978:	0711                	addi	a4,a4,4
    8000497a:	fef61be3          	bne	a2,a5,80004970 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000497e:	0621                	addi	a2,a2,8
    80004980:	060a                	slli	a2,a2,0x2
    80004982:	0023d797          	auipc	a5,0x23d
    80004986:	bf678793          	addi	a5,a5,-1034 # 80241578 <log>
    8000498a:	97b2                	add	a5,a5,a2
    8000498c:	44d8                	lw	a4,12(s1)
    8000498e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004990:	8526                	mv	a0,s1
    80004992:	fffff097          	auipc	ra,0xfffff
    80004996:	d9c080e7          	jalr	-612(ra) # 8000372e <bpin>
    log.lh.n++;
    8000499a:	0023d717          	auipc	a4,0x23d
    8000499e:	bde70713          	addi	a4,a4,-1058 # 80241578 <log>
    800049a2:	575c                	lw	a5,44(a4)
    800049a4:	2785                	addiw	a5,a5,1
    800049a6:	d75c                	sw	a5,44(a4)
    800049a8:	a82d                	j	800049e2 <log_write+0xc8>
    panic("too big a transaction");
    800049aa:	00004517          	auipc	a0,0x4
    800049ae:	cd650513          	addi	a0,a0,-810 # 80008680 <syscalls+0x208>
    800049b2:	ffffc097          	auipc	ra,0xffffc
    800049b6:	b8e080e7          	jalr	-1138(ra) # 80000540 <panic>
    panic("log_write outside of trans");
    800049ba:	00004517          	auipc	a0,0x4
    800049be:	cde50513          	addi	a0,a0,-802 # 80008698 <syscalls+0x220>
    800049c2:	ffffc097          	auipc	ra,0xffffc
    800049c6:	b7e080e7          	jalr	-1154(ra) # 80000540 <panic>
  log.lh.block[i] = b->blockno;
    800049ca:	00878693          	addi	a3,a5,8
    800049ce:	068a                	slli	a3,a3,0x2
    800049d0:	0023d717          	auipc	a4,0x23d
    800049d4:	ba870713          	addi	a4,a4,-1112 # 80241578 <log>
    800049d8:	9736                	add	a4,a4,a3
    800049da:	44d4                	lw	a3,12(s1)
    800049dc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800049de:	faf609e3          	beq	a2,a5,80004990 <log_write+0x76>
  }
  release(&log.lock);
    800049e2:	0023d517          	auipc	a0,0x23d
    800049e6:	b9650513          	addi	a0,a0,-1130 # 80241578 <log>
    800049ea:	ffffc097          	auipc	ra,0xffffc
    800049ee:	414080e7          	jalr	1044(ra) # 80000dfe <release>
}
    800049f2:	60e2                	ld	ra,24(sp)
    800049f4:	6442                	ld	s0,16(sp)
    800049f6:	64a2                	ld	s1,8(sp)
    800049f8:	6902                	ld	s2,0(sp)
    800049fa:	6105                	addi	sp,sp,32
    800049fc:	8082                	ret

00000000800049fe <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800049fe:	1101                	addi	sp,sp,-32
    80004a00:	ec06                	sd	ra,24(sp)
    80004a02:	e822                	sd	s0,16(sp)
    80004a04:	e426                	sd	s1,8(sp)
    80004a06:	e04a                	sd	s2,0(sp)
    80004a08:	1000                	addi	s0,sp,32
    80004a0a:	84aa                	mv	s1,a0
    80004a0c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004a0e:	00004597          	auipc	a1,0x4
    80004a12:	caa58593          	addi	a1,a1,-854 # 800086b8 <syscalls+0x240>
    80004a16:	0521                	addi	a0,a0,8
    80004a18:	ffffc097          	auipc	ra,0xffffc
    80004a1c:	2a2080e7          	jalr	674(ra) # 80000cba <initlock>
  lk->name = name;
    80004a20:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004a24:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a28:	0204a423          	sw	zero,40(s1)
}
    80004a2c:	60e2                	ld	ra,24(sp)
    80004a2e:	6442                	ld	s0,16(sp)
    80004a30:	64a2                	ld	s1,8(sp)
    80004a32:	6902                	ld	s2,0(sp)
    80004a34:	6105                	addi	sp,sp,32
    80004a36:	8082                	ret

0000000080004a38 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004a38:	1101                	addi	sp,sp,-32
    80004a3a:	ec06                	sd	ra,24(sp)
    80004a3c:	e822                	sd	s0,16(sp)
    80004a3e:	e426                	sd	s1,8(sp)
    80004a40:	e04a                	sd	s2,0(sp)
    80004a42:	1000                	addi	s0,sp,32
    80004a44:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a46:	00850913          	addi	s2,a0,8
    80004a4a:	854a                	mv	a0,s2
    80004a4c:	ffffc097          	auipc	ra,0xffffc
    80004a50:	2fe080e7          	jalr	766(ra) # 80000d4a <acquire>
  while (lk->locked) {
    80004a54:	409c                	lw	a5,0(s1)
    80004a56:	cb89                	beqz	a5,80004a68 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004a58:	85ca                	mv	a1,s2
    80004a5a:	8526                	mv	a0,s1
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	99c080e7          	jalr	-1636(ra) # 800023f8 <sleep>
  while (lk->locked) {
    80004a64:	409c                	lw	a5,0(s1)
    80004a66:	fbed                	bnez	a5,80004a58 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004a68:	4785                	li	a5,1
    80004a6a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004a6c:	ffffd097          	auipc	ra,0xffffd
    80004a70:	196080e7          	jalr	406(ra) # 80001c02 <myproc>
    80004a74:	591c                	lw	a5,48(a0)
    80004a76:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004a78:	854a                	mv	a0,s2
    80004a7a:	ffffc097          	auipc	ra,0xffffc
    80004a7e:	384080e7          	jalr	900(ra) # 80000dfe <release>
}
    80004a82:	60e2                	ld	ra,24(sp)
    80004a84:	6442                	ld	s0,16(sp)
    80004a86:	64a2                	ld	s1,8(sp)
    80004a88:	6902                	ld	s2,0(sp)
    80004a8a:	6105                	addi	sp,sp,32
    80004a8c:	8082                	ret

0000000080004a8e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004a8e:	1101                	addi	sp,sp,-32
    80004a90:	ec06                	sd	ra,24(sp)
    80004a92:	e822                	sd	s0,16(sp)
    80004a94:	e426                	sd	s1,8(sp)
    80004a96:	e04a                	sd	s2,0(sp)
    80004a98:	1000                	addi	s0,sp,32
    80004a9a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a9c:	00850913          	addi	s2,a0,8
    80004aa0:	854a                	mv	a0,s2
    80004aa2:	ffffc097          	auipc	ra,0xffffc
    80004aa6:	2a8080e7          	jalr	680(ra) # 80000d4a <acquire>
  lk->locked = 0;
    80004aaa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004aae:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004ab2:	8526                	mv	a0,s1
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	9a8080e7          	jalr	-1624(ra) # 8000245c <wakeup>
  release(&lk->lk);
    80004abc:	854a                	mv	a0,s2
    80004abe:	ffffc097          	auipc	ra,0xffffc
    80004ac2:	340080e7          	jalr	832(ra) # 80000dfe <release>
}
    80004ac6:	60e2                	ld	ra,24(sp)
    80004ac8:	6442                	ld	s0,16(sp)
    80004aca:	64a2                	ld	s1,8(sp)
    80004acc:	6902                	ld	s2,0(sp)
    80004ace:	6105                	addi	sp,sp,32
    80004ad0:	8082                	ret

0000000080004ad2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004ad2:	7179                	addi	sp,sp,-48
    80004ad4:	f406                	sd	ra,40(sp)
    80004ad6:	f022                	sd	s0,32(sp)
    80004ad8:	ec26                	sd	s1,24(sp)
    80004ada:	e84a                	sd	s2,16(sp)
    80004adc:	e44e                	sd	s3,8(sp)
    80004ade:	1800                	addi	s0,sp,48
    80004ae0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004ae2:	00850913          	addi	s2,a0,8
    80004ae6:	854a                	mv	a0,s2
    80004ae8:	ffffc097          	auipc	ra,0xffffc
    80004aec:	262080e7          	jalr	610(ra) # 80000d4a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004af0:	409c                	lw	a5,0(s1)
    80004af2:	ef99                	bnez	a5,80004b10 <holdingsleep+0x3e>
    80004af4:	4481                	li	s1,0
  release(&lk->lk);
    80004af6:	854a                	mv	a0,s2
    80004af8:	ffffc097          	auipc	ra,0xffffc
    80004afc:	306080e7          	jalr	774(ra) # 80000dfe <release>
  return r;
}
    80004b00:	8526                	mv	a0,s1
    80004b02:	70a2                	ld	ra,40(sp)
    80004b04:	7402                	ld	s0,32(sp)
    80004b06:	64e2                	ld	s1,24(sp)
    80004b08:	6942                	ld	s2,16(sp)
    80004b0a:	69a2                	ld	s3,8(sp)
    80004b0c:	6145                	addi	sp,sp,48
    80004b0e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004b10:	0284a983          	lw	s3,40(s1)
    80004b14:	ffffd097          	auipc	ra,0xffffd
    80004b18:	0ee080e7          	jalr	238(ra) # 80001c02 <myproc>
    80004b1c:	5904                	lw	s1,48(a0)
    80004b1e:	413484b3          	sub	s1,s1,s3
    80004b22:	0014b493          	seqz	s1,s1
    80004b26:	bfc1                	j	80004af6 <holdingsleep+0x24>

0000000080004b28 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004b28:	1141                	addi	sp,sp,-16
    80004b2a:	e406                	sd	ra,8(sp)
    80004b2c:	e022                	sd	s0,0(sp)
    80004b2e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004b30:	00004597          	auipc	a1,0x4
    80004b34:	b9858593          	addi	a1,a1,-1128 # 800086c8 <syscalls+0x250>
    80004b38:	0023d517          	auipc	a0,0x23d
    80004b3c:	b8850513          	addi	a0,a0,-1144 # 802416c0 <ftable>
    80004b40:	ffffc097          	auipc	ra,0xffffc
    80004b44:	17a080e7          	jalr	378(ra) # 80000cba <initlock>
}
    80004b48:	60a2                	ld	ra,8(sp)
    80004b4a:	6402                	ld	s0,0(sp)
    80004b4c:	0141                	addi	sp,sp,16
    80004b4e:	8082                	ret

0000000080004b50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004b50:	1101                	addi	sp,sp,-32
    80004b52:	ec06                	sd	ra,24(sp)
    80004b54:	e822                	sd	s0,16(sp)
    80004b56:	e426                	sd	s1,8(sp)
    80004b58:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004b5a:	0023d517          	auipc	a0,0x23d
    80004b5e:	b6650513          	addi	a0,a0,-1178 # 802416c0 <ftable>
    80004b62:	ffffc097          	auipc	ra,0xffffc
    80004b66:	1e8080e7          	jalr	488(ra) # 80000d4a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b6a:	0023d497          	auipc	s1,0x23d
    80004b6e:	b6e48493          	addi	s1,s1,-1170 # 802416d8 <ftable+0x18>
    80004b72:	0023e717          	auipc	a4,0x23e
    80004b76:	b0670713          	addi	a4,a4,-1274 # 80242678 <disk>
    if(f->ref == 0){
    80004b7a:	40dc                	lw	a5,4(s1)
    80004b7c:	cf99                	beqz	a5,80004b9a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b7e:	02848493          	addi	s1,s1,40
    80004b82:	fee49ce3          	bne	s1,a4,80004b7a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004b86:	0023d517          	auipc	a0,0x23d
    80004b8a:	b3a50513          	addi	a0,a0,-1222 # 802416c0 <ftable>
    80004b8e:	ffffc097          	auipc	ra,0xffffc
    80004b92:	270080e7          	jalr	624(ra) # 80000dfe <release>
  return 0;
    80004b96:	4481                	li	s1,0
    80004b98:	a819                	j	80004bae <filealloc+0x5e>
      f->ref = 1;
    80004b9a:	4785                	li	a5,1
    80004b9c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004b9e:	0023d517          	auipc	a0,0x23d
    80004ba2:	b2250513          	addi	a0,a0,-1246 # 802416c0 <ftable>
    80004ba6:	ffffc097          	auipc	ra,0xffffc
    80004baa:	258080e7          	jalr	600(ra) # 80000dfe <release>
}
    80004bae:	8526                	mv	a0,s1
    80004bb0:	60e2                	ld	ra,24(sp)
    80004bb2:	6442                	ld	s0,16(sp)
    80004bb4:	64a2                	ld	s1,8(sp)
    80004bb6:	6105                	addi	sp,sp,32
    80004bb8:	8082                	ret

0000000080004bba <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004bba:	1101                	addi	sp,sp,-32
    80004bbc:	ec06                	sd	ra,24(sp)
    80004bbe:	e822                	sd	s0,16(sp)
    80004bc0:	e426                	sd	s1,8(sp)
    80004bc2:	1000                	addi	s0,sp,32
    80004bc4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004bc6:	0023d517          	auipc	a0,0x23d
    80004bca:	afa50513          	addi	a0,a0,-1286 # 802416c0 <ftable>
    80004bce:	ffffc097          	auipc	ra,0xffffc
    80004bd2:	17c080e7          	jalr	380(ra) # 80000d4a <acquire>
  if(f->ref < 1)
    80004bd6:	40dc                	lw	a5,4(s1)
    80004bd8:	02f05263          	blez	a5,80004bfc <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004bdc:	2785                	addiw	a5,a5,1
    80004bde:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004be0:	0023d517          	auipc	a0,0x23d
    80004be4:	ae050513          	addi	a0,a0,-1312 # 802416c0 <ftable>
    80004be8:	ffffc097          	auipc	ra,0xffffc
    80004bec:	216080e7          	jalr	534(ra) # 80000dfe <release>
  return f;
}
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	60e2                	ld	ra,24(sp)
    80004bf4:	6442                	ld	s0,16(sp)
    80004bf6:	64a2                	ld	s1,8(sp)
    80004bf8:	6105                	addi	sp,sp,32
    80004bfa:	8082                	ret
    panic("filedup");
    80004bfc:	00004517          	auipc	a0,0x4
    80004c00:	ad450513          	addi	a0,a0,-1324 # 800086d0 <syscalls+0x258>
    80004c04:	ffffc097          	auipc	ra,0xffffc
    80004c08:	93c080e7          	jalr	-1732(ra) # 80000540 <panic>

0000000080004c0c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004c0c:	7139                	addi	sp,sp,-64
    80004c0e:	fc06                	sd	ra,56(sp)
    80004c10:	f822                	sd	s0,48(sp)
    80004c12:	f426                	sd	s1,40(sp)
    80004c14:	f04a                	sd	s2,32(sp)
    80004c16:	ec4e                	sd	s3,24(sp)
    80004c18:	e852                	sd	s4,16(sp)
    80004c1a:	e456                	sd	s5,8(sp)
    80004c1c:	0080                	addi	s0,sp,64
    80004c1e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004c20:	0023d517          	auipc	a0,0x23d
    80004c24:	aa050513          	addi	a0,a0,-1376 # 802416c0 <ftable>
    80004c28:	ffffc097          	auipc	ra,0xffffc
    80004c2c:	122080e7          	jalr	290(ra) # 80000d4a <acquire>
  if(f->ref < 1)
    80004c30:	40dc                	lw	a5,4(s1)
    80004c32:	06f05163          	blez	a5,80004c94 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004c36:	37fd                	addiw	a5,a5,-1
    80004c38:	0007871b          	sext.w	a4,a5
    80004c3c:	c0dc                	sw	a5,4(s1)
    80004c3e:	06e04363          	bgtz	a4,80004ca4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004c42:	0004a903          	lw	s2,0(s1)
    80004c46:	0094ca83          	lbu	s5,9(s1)
    80004c4a:	0104ba03          	ld	s4,16(s1)
    80004c4e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004c52:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004c56:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004c5a:	0023d517          	auipc	a0,0x23d
    80004c5e:	a6650513          	addi	a0,a0,-1434 # 802416c0 <ftable>
    80004c62:	ffffc097          	auipc	ra,0xffffc
    80004c66:	19c080e7          	jalr	412(ra) # 80000dfe <release>

  if(ff.type == FD_PIPE){
    80004c6a:	4785                	li	a5,1
    80004c6c:	04f90d63          	beq	s2,a5,80004cc6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004c70:	3979                	addiw	s2,s2,-2
    80004c72:	4785                	li	a5,1
    80004c74:	0527e063          	bltu	a5,s2,80004cb4 <fileclose+0xa8>
    begin_op();
    80004c78:	00000097          	auipc	ra,0x0
    80004c7c:	acc080e7          	jalr	-1332(ra) # 80004744 <begin_op>
    iput(ff.ip);
    80004c80:	854e                	mv	a0,s3
    80004c82:	fffff097          	auipc	ra,0xfffff
    80004c86:	2b0080e7          	jalr	688(ra) # 80003f32 <iput>
    end_op();
    80004c8a:	00000097          	auipc	ra,0x0
    80004c8e:	b38080e7          	jalr	-1224(ra) # 800047c2 <end_op>
    80004c92:	a00d                	j	80004cb4 <fileclose+0xa8>
    panic("fileclose");
    80004c94:	00004517          	auipc	a0,0x4
    80004c98:	a4450513          	addi	a0,a0,-1468 # 800086d8 <syscalls+0x260>
    80004c9c:	ffffc097          	auipc	ra,0xffffc
    80004ca0:	8a4080e7          	jalr	-1884(ra) # 80000540 <panic>
    release(&ftable.lock);
    80004ca4:	0023d517          	auipc	a0,0x23d
    80004ca8:	a1c50513          	addi	a0,a0,-1508 # 802416c0 <ftable>
    80004cac:	ffffc097          	auipc	ra,0xffffc
    80004cb0:	152080e7          	jalr	338(ra) # 80000dfe <release>
  }
}
    80004cb4:	70e2                	ld	ra,56(sp)
    80004cb6:	7442                	ld	s0,48(sp)
    80004cb8:	74a2                	ld	s1,40(sp)
    80004cba:	7902                	ld	s2,32(sp)
    80004cbc:	69e2                	ld	s3,24(sp)
    80004cbe:	6a42                	ld	s4,16(sp)
    80004cc0:	6aa2                	ld	s5,8(sp)
    80004cc2:	6121                	addi	sp,sp,64
    80004cc4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004cc6:	85d6                	mv	a1,s5
    80004cc8:	8552                	mv	a0,s4
    80004cca:	00000097          	auipc	ra,0x0
    80004cce:	34c080e7          	jalr	844(ra) # 80005016 <pipeclose>
    80004cd2:	b7cd                	j	80004cb4 <fileclose+0xa8>

0000000080004cd4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004cd4:	715d                	addi	sp,sp,-80
    80004cd6:	e486                	sd	ra,72(sp)
    80004cd8:	e0a2                	sd	s0,64(sp)
    80004cda:	fc26                	sd	s1,56(sp)
    80004cdc:	f84a                	sd	s2,48(sp)
    80004cde:	f44e                	sd	s3,40(sp)
    80004ce0:	0880                	addi	s0,sp,80
    80004ce2:	84aa                	mv	s1,a0
    80004ce4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004ce6:	ffffd097          	auipc	ra,0xffffd
    80004cea:	f1c080e7          	jalr	-228(ra) # 80001c02 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004cee:	409c                	lw	a5,0(s1)
    80004cf0:	37f9                	addiw	a5,a5,-2
    80004cf2:	4705                	li	a4,1
    80004cf4:	04f76763          	bltu	a4,a5,80004d42 <filestat+0x6e>
    80004cf8:	892a                	mv	s2,a0
    ilock(f->ip);
    80004cfa:	6c88                	ld	a0,24(s1)
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	07c080e7          	jalr	124(ra) # 80003d78 <ilock>
    stati(f->ip, &st);
    80004d04:	fb840593          	addi	a1,s0,-72
    80004d08:	6c88                	ld	a0,24(s1)
    80004d0a:	fffff097          	auipc	ra,0xfffff
    80004d0e:	2f8080e7          	jalr	760(ra) # 80004002 <stati>
    iunlock(f->ip);
    80004d12:	6c88                	ld	a0,24(s1)
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	126080e7          	jalr	294(ra) # 80003e3a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004d1c:	46e1                	li	a3,24
    80004d1e:	fb840613          	addi	a2,s0,-72
    80004d22:	85ce                	mv	a1,s3
    80004d24:	05093503          	ld	a0,80(s2)
    80004d28:	ffffd097          	auipc	ra,0xffffd
    80004d2c:	b86080e7          	jalr	-1146(ra) # 800018ae <copyout>
    80004d30:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004d34:	60a6                	ld	ra,72(sp)
    80004d36:	6406                	ld	s0,64(sp)
    80004d38:	74e2                	ld	s1,56(sp)
    80004d3a:	7942                	ld	s2,48(sp)
    80004d3c:	79a2                	ld	s3,40(sp)
    80004d3e:	6161                	addi	sp,sp,80
    80004d40:	8082                	ret
  return -1;
    80004d42:	557d                	li	a0,-1
    80004d44:	bfc5                	j	80004d34 <filestat+0x60>

0000000080004d46 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004d46:	7179                	addi	sp,sp,-48
    80004d48:	f406                	sd	ra,40(sp)
    80004d4a:	f022                	sd	s0,32(sp)
    80004d4c:	ec26                	sd	s1,24(sp)
    80004d4e:	e84a                	sd	s2,16(sp)
    80004d50:	e44e                	sd	s3,8(sp)
    80004d52:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004d54:	00854783          	lbu	a5,8(a0)
    80004d58:	c3d5                	beqz	a5,80004dfc <fileread+0xb6>
    80004d5a:	84aa                	mv	s1,a0
    80004d5c:	89ae                	mv	s3,a1
    80004d5e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d60:	411c                	lw	a5,0(a0)
    80004d62:	4705                	li	a4,1
    80004d64:	04e78963          	beq	a5,a4,80004db6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d68:	470d                	li	a4,3
    80004d6a:	04e78d63          	beq	a5,a4,80004dc4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d6e:	4709                	li	a4,2
    80004d70:	06e79e63          	bne	a5,a4,80004dec <fileread+0xa6>
    ilock(f->ip);
    80004d74:	6d08                	ld	a0,24(a0)
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	002080e7          	jalr	2(ra) # 80003d78 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004d7e:	874a                	mv	a4,s2
    80004d80:	5094                	lw	a3,32(s1)
    80004d82:	864e                	mv	a2,s3
    80004d84:	4585                	li	a1,1
    80004d86:	6c88                	ld	a0,24(s1)
    80004d88:	fffff097          	auipc	ra,0xfffff
    80004d8c:	2a4080e7          	jalr	676(ra) # 8000402c <readi>
    80004d90:	892a                	mv	s2,a0
    80004d92:	00a05563          	blez	a0,80004d9c <fileread+0x56>
      f->off += r;
    80004d96:	509c                	lw	a5,32(s1)
    80004d98:	9fa9                	addw	a5,a5,a0
    80004d9a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004d9c:	6c88                	ld	a0,24(s1)
    80004d9e:	fffff097          	auipc	ra,0xfffff
    80004da2:	09c080e7          	jalr	156(ra) # 80003e3a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004da6:	854a                	mv	a0,s2
    80004da8:	70a2                	ld	ra,40(sp)
    80004daa:	7402                	ld	s0,32(sp)
    80004dac:	64e2                	ld	s1,24(sp)
    80004dae:	6942                	ld	s2,16(sp)
    80004db0:	69a2                	ld	s3,8(sp)
    80004db2:	6145                	addi	sp,sp,48
    80004db4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004db6:	6908                	ld	a0,16(a0)
    80004db8:	00000097          	auipc	ra,0x0
    80004dbc:	3c6080e7          	jalr	966(ra) # 8000517e <piperead>
    80004dc0:	892a                	mv	s2,a0
    80004dc2:	b7d5                	j	80004da6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004dc4:	02451783          	lh	a5,36(a0)
    80004dc8:	03079693          	slli	a3,a5,0x30
    80004dcc:	92c1                	srli	a3,a3,0x30
    80004dce:	4725                	li	a4,9
    80004dd0:	02d76863          	bltu	a4,a3,80004e00 <fileread+0xba>
    80004dd4:	0792                	slli	a5,a5,0x4
    80004dd6:	0023d717          	auipc	a4,0x23d
    80004dda:	84a70713          	addi	a4,a4,-1974 # 80241620 <devsw>
    80004dde:	97ba                	add	a5,a5,a4
    80004de0:	639c                	ld	a5,0(a5)
    80004de2:	c38d                	beqz	a5,80004e04 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004de4:	4505                	li	a0,1
    80004de6:	9782                	jalr	a5
    80004de8:	892a                	mv	s2,a0
    80004dea:	bf75                	j	80004da6 <fileread+0x60>
    panic("fileread");
    80004dec:	00004517          	auipc	a0,0x4
    80004df0:	8fc50513          	addi	a0,a0,-1796 # 800086e8 <syscalls+0x270>
    80004df4:	ffffb097          	auipc	ra,0xffffb
    80004df8:	74c080e7          	jalr	1868(ra) # 80000540 <panic>
    return -1;
    80004dfc:	597d                	li	s2,-1
    80004dfe:	b765                	j	80004da6 <fileread+0x60>
      return -1;
    80004e00:	597d                	li	s2,-1
    80004e02:	b755                	j	80004da6 <fileread+0x60>
    80004e04:	597d                	li	s2,-1
    80004e06:	b745                	j	80004da6 <fileread+0x60>

0000000080004e08 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004e08:	715d                	addi	sp,sp,-80
    80004e0a:	e486                	sd	ra,72(sp)
    80004e0c:	e0a2                	sd	s0,64(sp)
    80004e0e:	fc26                	sd	s1,56(sp)
    80004e10:	f84a                	sd	s2,48(sp)
    80004e12:	f44e                	sd	s3,40(sp)
    80004e14:	f052                	sd	s4,32(sp)
    80004e16:	ec56                	sd	s5,24(sp)
    80004e18:	e85a                	sd	s6,16(sp)
    80004e1a:	e45e                	sd	s7,8(sp)
    80004e1c:	e062                	sd	s8,0(sp)
    80004e1e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004e20:	00954783          	lbu	a5,9(a0)
    80004e24:	10078663          	beqz	a5,80004f30 <filewrite+0x128>
    80004e28:	892a                	mv	s2,a0
    80004e2a:	8b2e                	mv	s6,a1
    80004e2c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004e2e:	411c                	lw	a5,0(a0)
    80004e30:	4705                	li	a4,1
    80004e32:	02e78263          	beq	a5,a4,80004e56 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004e36:	470d                	li	a4,3
    80004e38:	02e78663          	beq	a5,a4,80004e64 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004e3c:	4709                	li	a4,2
    80004e3e:	0ee79163          	bne	a5,a4,80004f20 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004e42:	0ac05d63          	blez	a2,80004efc <filewrite+0xf4>
    int i = 0;
    80004e46:	4981                	li	s3,0
    80004e48:	6b85                	lui	s7,0x1
    80004e4a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004e4e:	6c05                	lui	s8,0x1
    80004e50:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004e54:	a861                	j	80004eec <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004e56:	6908                	ld	a0,16(a0)
    80004e58:	00000097          	auipc	ra,0x0
    80004e5c:	22e080e7          	jalr	558(ra) # 80005086 <pipewrite>
    80004e60:	8a2a                	mv	s4,a0
    80004e62:	a045                	j	80004f02 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004e64:	02451783          	lh	a5,36(a0)
    80004e68:	03079693          	slli	a3,a5,0x30
    80004e6c:	92c1                	srli	a3,a3,0x30
    80004e6e:	4725                	li	a4,9
    80004e70:	0cd76263          	bltu	a4,a3,80004f34 <filewrite+0x12c>
    80004e74:	0792                	slli	a5,a5,0x4
    80004e76:	0023c717          	auipc	a4,0x23c
    80004e7a:	7aa70713          	addi	a4,a4,1962 # 80241620 <devsw>
    80004e7e:	97ba                	add	a5,a5,a4
    80004e80:	679c                	ld	a5,8(a5)
    80004e82:	cbdd                	beqz	a5,80004f38 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004e84:	4505                	li	a0,1
    80004e86:	9782                	jalr	a5
    80004e88:	8a2a                	mv	s4,a0
    80004e8a:	a8a5                	j	80004f02 <filewrite+0xfa>
    80004e8c:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004e90:	00000097          	auipc	ra,0x0
    80004e94:	8b4080e7          	jalr	-1868(ra) # 80004744 <begin_op>
      ilock(f->ip);
    80004e98:	01893503          	ld	a0,24(s2)
    80004e9c:	fffff097          	auipc	ra,0xfffff
    80004ea0:	edc080e7          	jalr	-292(ra) # 80003d78 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004ea4:	8756                	mv	a4,s5
    80004ea6:	02092683          	lw	a3,32(s2)
    80004eaa:	01698633          	add	a2,s3,s6
    80004eae:	4585                	li	a1,1
    80004eb0:	01893503          	ld	a0,24(s2)
    80004eb4:	fffff097          	auipc	ra,0xfffff
    80004eb8:	270080e7          	jalr	624(ra) # 80004124 <writei>
    80004ebc:	84aa                	mv	s1,a0
    80004ebe:	00a05763          	blez	a0,80004ecc <filewrite+0xc4>
        f->off += r;
    80004ec2:	02092783          	lw	a5,32(s2)
    80004ec6:	9fa9                	addw	a5,a5,a0
    80004ec8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004ecc:	01893503          	ld	a0,24(s2)
    80004ed0:	fffff097          	auipc	ra,0xfffff
    80004ed4:	f6a080e7          	jalr	-150(ra) # 80003e3a <iunlock>
      end_op();
    80004ed8:	00000097          	auipc	ra,0x0
    80004edc:	8ea080e7          	jalr	-1814(ra) # 800047c2 <end_op>

      if(r != n1){
    80004ee0:	009a9f63          	bne	s5,s1,80004efe <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004ee4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004ee8:	0149db63          	bge	s3,s4,80004efe <filewrite+0xf6>
      int n1 = n - i;
    80004eec:	413a04bb          	subw	s1,s4,s3
    80004ef0:	0004879b          	sext.w	a5,s1
    80004ef4:	f8fbdce3          	bge	s7,a5,80004e8c <filewrite+0x84>
    80004ef8:	84e2                	mv	s1,s8
    80004efa:	bf49                	j	80004e8c <filewrite+0x84>
    int i = 0;
    80004efc:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004efe:	013a1f63          	bne	s4,s3,80004f1c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004f02:	8552                	mv	a0,s4
    80004f04:	60a6                	ld	ra,72(sp)
    80004f06:	6406                	ld	s0,64(sp)
    80004f08:	74e2                	ld	s1,56(sp)
    80004f0a:	7942                	ld	s2,48(sp)
    80004f0c:	79a2                	ld	s3,40(sp)
    80004f0e:	7a02                	ld	s4,32(sp)
    80004f10:	6ae2                	ld	s5,24(sp)
    80004f12:	6b42                	ld	s6,16(sp)
    80004f14:	6ba2                	ld	s7,8(sp)
    80004f16:	6c02                	ld	s8,0(sp)
    80004f18:	6161                	addi	sp,sp,80
    80004f1a:	8082                	ret
    ret = (i == n ? n : -1);
    80004f1c:	5a7d                	li	s4,-1
    80004f1e:	b7d5                	j	80004f02 <filewrite+0xfa>
    panic("filewrite");
    80004f20:	00003517          	auipc	a0,0x3
    80004f24:	7d850513          	addi	a0,a0,2008 # 800086f8 <syscalls+0x280>
    80004f28:	ffffb097          	auipc	ra,0xffffb
    80004f2c:	618080e7          	jalr	1560(ra) # 80000540 <panic>
    return -1;
    80004f30:	5a7d                	li	s4,-1
    80004f32:	bfc1                	j	80004f02 <filewrite+0xfa>
      return -1;
    80004f34:	5a7d                	li	s4,-1
    80004f36:	b7f1                	j	80004f02 <filewrite+0xfa>
    80004f38:	5a7d                	li	s4,-1
    80004f3a:	b7e1                	j	80004f02 <filewrite+0xfa>

0000000080004f3c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004f3c:	7179                	addi	sp,sp,-48
    80004f3e:	f406                	sd	ra,40(sp)
    80004f40:	f022                	sd	s0,32(sp)
    80004f42:	ec26                	sd	s1,24(sp)
    80004f44:	e84a                	sd	s2,16(sp)
    80004f46:	e44e                	sd	s3,8(sp)
    80004f48:	e052                	sd	s4,0(sp)
    80004f4a:	1800                	addi	s0,sp,48
    80004f4c:	84aa                	mv	s1,a0
    80004f4e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004f50:	0005b023          	sd	zero,0(a1)
    80004f54:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004f58:	00000097          	auipc	ra,0x0
    80004f5c:	bf8080e7          	jalr	-1032(ra) # 80004b50 <filealloc>
    80004f60:	e088                	sd	a0,0(s1)
    80004f62:	c551                	beqz	a0,80004fee <pipealloc+0xb2>
    80004f64:	00000097          	auipc	ra,0x0
    80004f68:	bec080e7          	jalr	-1044(ra) # 80004b50 <filealloc>
    80004f6c:	00aa3023          	sd	a0,0(s4)
    80004f70:	c92d                	beqz	a0,80004fe2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004f72:	ffffc097          	auipc	ra,0xffffc
    80004f76:	cde080e7          	jalr	-802(ra) # 80000c50 <kalloc>
    80004f7a:	892a                	mv	s2,a0
    80004f7c:	c125                	beqz	a0,80004fdc <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004f7e:	4985                	li	s3,1
    80004f80:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004f84:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004f88:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004f8c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f90:	00003597          	auipc	a1,0x3
    80004f94:	77858593          	addi	a1,a1,1912 # 80008708 <syscalls+0x290>
    80004f98:	ffffc097          	auipc	ra,0xffffc
    80004f9c:	d22080e7          	jalr	-734(ra) # 80000cba <initlock>
  (*f0)->type = FD_PIPE;
    80004fa0:	609c                	ld	a5,0(s1)
    80004fa2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004fa6:	609c                	ld	a5,0(s1)
    80004fa8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004fac:	609c                	ld	a5,0(s1)
    80004fae:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004fb2:	609c                	ld	a5,0(s1)
    80004fb4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004fb8:	000a3783          	ld	a5,0(s4)
    80004fbc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004fc0:	000a3783          	ld	a5,0(s4)
    80004fc4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004fc8:	000a3783          	ld	a5,0(s4)
    80004fcc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004fd0:	000a3783          	ld	a5,0(s4)
    80004fd4:	0127b823          	sd	s2,16(a5)
  return 0;
    80004fd8:	4501                	li	a0,0
    80004fda:	a025                	j	80005002 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004fdc:	6088                	ld	a0,0(s1)
    80004fde:	e501                	bnez	a0,80004fe6 <pipealloc+0xaa>
    80004fe0:	a039                	j	80004fee <pipealloc+0xb2>
    80004fe2:	6088                	ld	a0,0(s1)
    80004fe4:	c51d                	beqz	a0,80005012 <pipealloc+0xd6>
    fileclose(*f0);
    80004fe6:	00000097          	auipc	ra,0x0
    80004fea:	c26080e7          	jalr	-986(ra) # 80004c0c <fileclose>
  if(*f1)
    80004fee:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004ff2:	557d                	li	a0,-1
  if(*f1)
    80004ff4:	c799                	beqz	a5,80005002 <pipealloc+0xc6>
    fileclose(*f1);
    80004ff6:	853e                	mv	a0,a5
    80004ff8:	00000097          	auipc	ra,0x0
    80004ffc:	c14080e7          	jalr	-1004(ra) # 80004c0c <fileclose>
  return -1;
    80005000:	557d                	li	a0,-1
}
    80005002:	70a2                	ld	ra,40(sp)
    80005004:	7402                	ld	s0,32(sp)
    80005006:	64e2                	ld	s1,24(sp)
    80005008:	6942                	ld	s2,16(sp)
    8000500a:	69a2                	ld	s3,8(sp)
    8000500c:	6a02                	ld	s4,0(sp)
    8000500e:	6145                	addi	sp,sp,48
    80005010:	8082                	ret
  return -1;
    80005012:	557d                	li	a0,-1
    80005014:	b7fd                	j	80005002 <pipealloc+0xc6>

0000000080005016 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005016:	1101                	addi	sp,sp,-32
    80005018:	ec06                	sd	ra,24(sp)
    8000501a:	e822                	sd	s0,16(sp)
    8000501c:	e426                	sd	s1,8(sp)
    8000501e:	e04a                	sd	s2,0(sp)
    80005020:	1000                	addi	s0,sp,32
    80005022:	84aa                	mv	s1,a0
    80005024:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005026:	ffffc097          	auipc	ra,0xffffc
    8000502a:	d24080e7          	jalr	-732(ra) # 80000d4a <acquire>
  if(writable){
    8000502e:	02090d63          	beqz	s2,80005068 <pipeclose+0x52>
    pi->writeopen = 0;
    80005032:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005036:	21848513          	addi	a0,s1,536
    8000503a:	ffffd097          	auipc	ra,0xffffd
    8000503e:	422080e7          	jalr	1058(ra) # 8000245c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005042:	2204b783          	ld	a5,544(s1)
    80005046:	eb95                	bnez	a5,8000507a <pipeclose+0x64>
    release(&pi->lock);
    80005048:	8526                	mv	a0,s1
    8000504a:	ffffc097          	auipc	ra,0xffffc
    8000504e:	db4080e7          	jalr	-588(ra) # 80000dfe <release>
    kfree((char*)pi);
    80005052:	8526                	mv	a0,s1
    80005054:	ffffc097          	auipc	ra,0xffffc
    80005058:	a24080e7          	jalr	-1500(ra) # 80000a78 <kfree>
  } else
    release(&pi->lock);
}
    8000505c:	60e2                	ld	ra,24(sp)
    8000505e:	6442                	ld	s0,16(sp)
    80005060:	64a2                	ld	s1,8(sp)
    80005062:	6902                	ld	s2,0(sp)
    80005064:	6105                	addi	sp,sp,32
    80005066:	8082                	ret
    pi->readopen = 0;
    80005068:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000506c:	21c48513          	addi	a0,s1,540
    80005070:	ffffd097          	auipc	ra,0xffffd
    80005074:	3ec080e7          	jalr	1004(ra) # 8000245c <wakeup>
    80005078:	b7e9                	j	80005042 <pipeclose+0x2c>
    release(&pi->lock);
    8000507a:	8526                	mv	a0,s1
    8000507c:	ffffc097          	auipc	ra,0xffffc
    80005080:	d82080e7          	jalr	-638(ra) # 80000dfe <release>
}
    80005084:	bfe1                	j	8000505c <pipeclose+0x46>

0000000080005086 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005086:	711d                	addi	sp,sp,-96
    80005088:	ec86                	sd	ra,88(sp)
    8000508a:	e8a2                	sd	s0,80(sp)
    8000508c:	e4a6                	sd	s1,72(sp)
    8000508e:	e0ca                	sd	s2,64(sp)
    80005090:	fc4e                	sd	s3,56(sp)
    80005092:	f852                	sd	s4,48(sp)
    80005094:	f456                	sd	s5,40(sp)
    80005096:	f05a                	sd	s6,32(sp)
    80005098:	ec5e                	sd	s7,24(sp)
    8000509a:	e862                	sd	s8,16(sp)
    8000509c:	1080                	addi	s0,sp,96
    8000509e:	84aa                	mv	s1,a0
    800050a0:	8aae                	mv	s5,a1
    800050a2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800050a4:	ffffd097          	auipc	ra,0xffffd
    800050a8:	b5e080e7          	jalr	-1186(ra) # 80001c02 <myproc>
    800050ac:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800050ae:	8526                	mv	a0,s1
    800050b0:	ffffc097          	auipc	ra,0xffffc
    800050b4:	c9a080e7          	jalr	-870(ra) # 80000d4a <acquire>
  while(i < n){
    800050b8:	0b405663          	blez	s4,80005164 <pipewrite+0xde>
  int i = 0;
    800050bc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050be:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800050c0:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800050c4:	21c48b93          	addi	s7,s1,540
    800050c8:	a089                	j	8000510a <pipewrite+0x84>
      release(&pi->lock);
    800050ca:	8526                	mv	a0,s1
    800050cc:	ffffc097          	auipc	ra,0xffffc
    800050d0:	d32080e7          	jalr	-718(ra) # 80000dfe <release>
      return -1;
    800050d4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800050d6:	854a                	mv	a0,s2
    800050d8:	60e6                	ld	ra,88(sp)
    800050da:	6446                	ld	s0,80(sp)
    800050dc:	64a6                	ld	s1,72(sp)
    800050de:	6906                	ld	s2,64(sp)
    800050e0:	79e2                	ld	s3,56(sp)
    800050e2:	7a42                	ld	s4,48(sp)
    800050e4:	7aa2                	ld	s5,40(sp)
    800050e6:	7b02                	ld	s6,32(sp)
    800050e8:	6be2                	ld	s7,24(sp)
    800050ea:	6c42                	ld	s8,16(sp)
    800050ec:	6125                	addi	sp,sp,96
    800050ee:	8082                	ret
      wakeup(&pi->nread);
    800050f0:	8562                	mv	a0,s8
    800050f2:	ffffd097          	auipc	ra,0xffffd
    800050f6:	36a080e7          	jalr	874(ra) # 8000245c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800050fa:	85a6                	mv	a1,s1
    800050fc:	855e                	mv	a0,s7
    800050fe:	ffffd097          	auipc	ra,0xffffd
    80005102:	2fa080e7          	jalr	762(ra) # 800023f8 <sleep>
  while(i < n){
    80005106:	07495063          	bge	s2,s4,80005166 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    8000510a:	2204a783          	lw	a5,544(s1)
    8000510e:	dfd5                	beqz	a5,800050ca <pipewrite+0x44>
    80005110:	854e                	mv	a0,s3
    80005112:	ffffd097          	auipc	ra,0xffffd
    80005116:	59a080e7          	jalr	1434(ra) # 800026ac <killed>
    8000511a:	f945                	bnez	a0,800050ca <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000511c:	2184a783          	lw	a5,536(s1)
    80005120:	21c4a703          	lw	a4,540(s1)
    80005124:	2007879b          	addiw	a5,a5,512
    80005128:	fcf704e3          	beq	a4,a5,800050f0 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000512c:	4685                	li	a3,1
    8000512e:	01590633          	add	a2,s2,s5
    80005132:	faf40593          	addi	a1,s0,-81
    80005136:	0509b503          	ld	a0,80(s3)
    8000513a:	ffffd097          	auipc	ra,0xffffd
    8000513e:	814080e7          	jalr	-2028(ra) # 8000194e <copyin>
    80005142:	03650263          	beq	a0,s6,80005166 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005146:	21c4a783          	lw	a5,540(s1)
    8000514a:	0017871b          	addiw	a4,a5,1
    8000514e:	20e4ae23          	sw	a4,540(s1)
    80005152:	1ff7f793          	andi	a5,a5,511
    80005156:	97a6                	add	a5,a5,s1
    80005158:	faf44703          	lbu	a4,-81(s0)
    8000515c:	00e78c23          	sb	a4,24(a5)
      i++;
    80005160:	2905                	addiw	s2,s2,1
    80005162:	b755                	j	80005106 <pipewrite+0x80>
  int i = 0;
    80005164:	4901                	li	s2,0
  wakeup(&pi->nread);
    80005166:	21848513          	addi	a0,s1,536
    8000516a:	ffffd097          	auipc	ra,0xffffd
    8000516e:	2f2080e7          	jalr	754(ra) # 8000245c <wakeup>
  release(&pi->lock);
    80005172:	8526                	mv	a0,s1
    80005174:	ffffc097          	auipc	ra,0xffffc
    80005178:	c8a080e7          	jalr	-886(ra) # 80000dfe <release>
  return i;
    8000517c:	bfa9                	j	800050d6 <pipewrite+0x50>

000000008000517e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000517e:	715d                	addi	sp,sp,-80
    80005180:	e486                	sd	ra,72(sp)
    80005182:	e0a2                	sd	s0,64(sp)
    80005184:	fc26                	sd	s1,56(sp)
    80005186:	f84a                	sd	s2,48(sp)
    80005188:	f44e                	sd	s3,40(sp)
    8000518a:	f052                	sd	s4,32(sp)
    8000518c:	ec56                	sd	s5,24(sp)
    8000518e:	e85a                	sd	s6,16(sp)
    80005190:	0880                	addi	s0,sp,80
    80005192:	84aa                	mv	s1,a0
    80005194:	892e                	mv	s2,a1
    80005196:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005198:	ffffd097          	auipc	ra,0xffffd
    8000519c:	a6a080e7          	jalr	-1430(ra) # 80001c02 <myproc>
    800051a0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800051a2:	8526                	mv	a0,s1
    800051a4:	ffffc097          	auipc	ra,0xffffc
    800051a8:	ba6080e7          	jalr	-1114(ra) # 80000d4a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051ac:	2184a703          	lw	a4,536(s1)
    800051b0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800051b4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051b8:	02f71763          	bne	a4,a5,800051e6 <piperead+0x68>
    800051bc:	2244a783          	lw	a5,548(s1)
    800051c0:	c39d                	beqz	a5,800051e6 <piperead+0x68>
    if(killed(pr)){
    800051c2:	8552                	mv	a0,s4
    800051c4:	ffffd097          	auipc	ra,0xffffd
    800051c8:	4e8080e7          	jalr	1256(ra) # 800026ac <killed>
    800051cc:	e949                	bnez	a0,8000525e <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800051ce:	85a6                	mv	a1,s1
    800051d0:	854e                	mv	a0,s3
    800051d2:	ffffd097          	auipc	ra,0xffffd
    800051d6:	226080e7          	jalr	550(ra) # 800023f8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051da:	2184a703          	lw	a4,536(s1)
    800051de:	21c4a783          	lw	a5,540(s1)
    800051e2:	fcf70de3          	beq	a4,a5,800051bc <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051e6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051e8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051ea:	05505463          	blez	s5,80005232 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800051ee:	2184a783          	lw	a5,536(s1)
    800051f2:	21c4a703          	lw	a4,540(s1)
    800051f6:	02f70e63          	beq	a4,a5,80005232 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800051fa:	0017871b          	addiw	a4,a5,1
    800051fe:	20e4ac23          	sw	a4,536(s1)
    80005202:	1ff7f793          	andi	a5,a5,511
    80005206:	97a6                	add	a5,a5,s1
    80005208:	0187c783          	lbu	a5,24(a5)
    8000520c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005210:	4685                	li	a3,1
    80005212:	fbf40613          	addi	a2,s0,-65
    80005216:	85ca                	mv	a1,s2
    80005218:	050a3503          	ld	a0,80(s4)
    8000521c:	ffffc097          	auipc	ra,0xffffc
    80005220:	692080e7          	jalr	1682(ra) # 800018ae <copyout>
    80005224:	01650763          	beq	a0,s6,80005232 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005228:	2985                	addiw	s3,s3,1
    8000522a:	0905                	addi	s2,s2,1
    8000522c:	fd3a91e3          	bne	s5,s3,800051ee <piperead+0x70>
    80005230:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005232:	21c48513          	addi	a0,s1,540
    80005236:	ffffd097          	auipc	ra,0xffffd
    8000523a:	226080e7          	jalr	550(ra) # 8000245c <wakeup>
  release(&pi->lock);
    8000523e:	8526                	mv	a0,s1
    80005240:	ffffc097          	auipc	ra,0xffffc
    80005244:	bbe080e7          	jalr	-1090(ra) # 80000dfe <release>
  return i;
}
    80005248:	854e                	mv	a0,s3
    8000524a:	60a6                	ld	ra,72(sp)
    8000524c:	6406                	ld	s0,64(sp)
    8000524e:	74e2                	ld	s1,56(sp)
    80005250:	7942                	ld	s2,48(sp)
    80005252:	79a2                	ld	s3,40(sp)
    80005254:	7a02                	ld	s4,32(sp)
    80005256:	6ae2                	ld	s5,24(sp)
    80005258:	6b42                	ld	s6,16(sp)
    8000525a:	6161                	addi	sp,sp,80
    8000525c:	8082                	ret
      release(&pi->lock);
    8000525e:	8526                	mv	a0,s1
    80005260:	ffffc097          	auipc	ra,0xffffc
    80005264:	b9e080e7          	jalr	-1122(ra) # 80000dfe <release>
      return -1;
    80005268:	59fd                	li	s3,-1
    8000526a:	bff9                	j	80005248 <piperead+0xca>

000000008000526c <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000526c:	1141                	addi	sp,sp,-16
    8000526e:	e422                	sd	s0,8(sp)
    80005270:	0800                	addi	s0,sp,16
    80005272:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005274:	8905                	andi	a0,a0,1
    80005276:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80005278:	8b89                	andi	a5,a5,2
    8000527a:	c399                	beqz	a5,80005280 <flags2perm+0x14>
      perm |= PTE_W;
    8000527c:	00456513          	ori	a0,a0,4
    return perm;
}
    80005280:	6422                	ld	s0,8(sp)
    80005282:	0141                	addi	sp,sp,16
    80005284:	8082                	ret

0000000080005286 <exec>:

int
exec(char *path, char **argv)
{
    80005286:	de010113          	addi	sp,sp,-544
    8000528a:	20113c23          	sd	ra,536(sp)
    8000528e:	20813823          	sd	s0,528(sp)
    80005292:	20913423          	sd	s1,520(sp)
    80005296:	21213023          	sd	s2,512(sp)
    8000529a:	ffce                	sd	s3,504(sp)
    8000529c:	fbd2                	sd	s4,496(sp)
    8000529e:	f7d6                	sd	s5,488(sp)
    800052a0:	f3da                	sd	s6,480(sp)
    800052a2:	efde                	sd	s7,472(sp)
    800052a4:	ebe2                	sd	s8,464(sp)
    800052a6:	e7e6                	sd	s9,456(sp)
    800052a8:	e3ea                	sd	s10,448(sp)
    800052aa:	ff6e                	sd	s11,440(sp)
    800052ac:	1400                	addi	s0,sp,544
    800052ae:	892a                	mv	s2,a0
    800052b0:	dea43423          	sd	a0,-536(s0)
    800052b4:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800052b8:	ffffd097          	auipc	ra,0xffffd
    800052bc:	94a080e7          	jalr	-1718(ra) # 80001c02 <myproc>
    800052c0:	84aa                	mv	s1,a0

  begin_op();
    800052c2:	fffff097          	auipc	ra,0xfffff
    800052c6:	482080e7          	jalr	1154(ra) # 80004744 <begin_op>

  if((ip = namei(path)) == 0){
    800052ca:	854a                	mv	a0,s2
    800052cc:	fffff097          	auipc	ra,0xfffff
    800052d0:	258080e7          	jalr	600(ra) # 80004524 <namei>
    800052d4:	c93d                	beqz	a0,8000534a <exec+0xc4>
    800052d6:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800052d8:	fffff097          	auipc	ra,0xfffff
    800052dc:	aa0080e7          	jalr	-1376(ra) # 80003d78 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800052e0:	04000713          	li	a4,64
    800052e4:	4681                	li	a3,0
    800052e6:	e4840613          	addi	a2,s0,-440
    800052ea:	4581                	li	a1,0
    800052ec:	8556                	mv	a0,s5
    800052ee:	fffff097          	auipc	ra,0xfffff
    800052f2:	d3e080e7          	jalr	-706(ra) # 8000402c <readi>
    800052f6:	04000793          	li	a5,64
    800052fa:	00f51a63          	bne	a0,a5,8000530e <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800052fe:	e4842703          	lw	a4,-440(s0)
    80005302:	464c47b7          	lui	a5,0x464c4
    80005306:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000530a:	04f70663          	beq	a4,a5,80005356 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000530e:	8556                	mv	a0,s5
    80005310:	fffff097          	auipc	ra,0xfffff
    80005314:	cca080e7          	jalr	-822(ra) # 80003fda <iunlockput>
    end_op();
    80005318:	fffff097          	auipc	ra,0xfffff
    8000531c:	4aa080e7          	jalr	1194(ra) # 800047c2 <end_op>
  }
  return -1;
    80005320:	557d                	li	a0,-1
}
    80005322:	21813083          	ld	ra,536(sp)
    80005326:	21013403          	ld	s0,528(sp)
    8000532a:	20813483          	ld	s1,520(sp)
    8000532e:	20013903          	ld	s2,512(sp)
    80005332:	79fe                	ld	s3,504(sp)
    80005334:	7a5e                	ld	s4,496(sp)
    80005336:	7abe                	ld	s5,488(sp)
    80005338:	7b1e                	ld	s6,480(sp)
    8000533a:	6bfe                	ld	s7,472(sp)
    8000533c:	6c5e                	ld	s8,464(sp)
    8000533e:	6cbe                	ld	s9,456(sp)
    80005340:	6d1e                	ld	s10,448(sp)
    80005342:	7dfa                	ld	s11,440(sp)
    80005344:	22010113          	addi	sp,sp,544
    80005348:	8082                	ret
    end_op();
    8000534a:	fffff097          	auipc	ra,0xfffff
    8000534e:	478080e7          	jalr	1144(ra) # 800047c2 <end_op>
    return -1;
    80005352:	557d                	li	a0,-1
    80005354:	b7f9                	j	80005322 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80005356:	8526                	mv	a0,s1
    80005358:	ffffd097          	auipc	ra,0xffffd
    8000535c:	96e080e7          	jalr	-1682(ra) # 80001cc6 <proc_pagetable>
    80005360:	8b2a                	mv	s6,a0
    80005362:	d555                	beqz	a0,8000530e <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005364:	e6842783          	lw	a5,-408(s0)
    80005368:	e8045703          	lhu	a4,-384(s0)
    8000536c:	c735                	beqz	a4,800053d8 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    8000536e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005370:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005374:	6a05                	lui	s4,0x1
    80005376:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000537a:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000537e:	6d85                	lui	s11,0x1
    80005380:	7d7d                	lui	s10,0xfffff
    80005382:	ac25                	j	800055ba <exec+0x334>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005384:	00003517          	auipc	a0,0x3
    80005388:	38c50513          	addi	a0,a0,908 # 80008710 <syscalls+0x298>
    8000538c:	ffffb097          	auipc	ra,0xffffb
    80005390:	1b4080e7          	jalr	436(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005394:	874a                	mv	a4,s2
    80005396:	009c86bb          	addw	a3,s9,s1
    8000539a:	4581                	li	a1,0
    8000539c:	8556                	mv	a0,s5
    8000539e:	fffff097          	auipc	ra,0xfffff
    800053a2:	c8e080e7          	jalr	-882(ra) # 8000402c <readi>
    800053a6:	2501                	sext.w	a0,a0
    800053a8:	1aa91963          	bne	s2,a0,8000555a <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800053ac:	009d84bb          	addw	s1,s11,s1
    800053b0:	013d09bb          	addw	s3,s10,s3
    800053b4:	1f74f363          	bgeu	s1,s7,8000559a <exec+0x314>
    pa = walkaddr(pagetable, va + i);
    800053b8:	02049593          	slli	a1,s1,0x20
    800053bc:	9181                	srli	a1,a1,0x20
    800053be:	95e2                	add	a1,a1,s8
    800053c0:	855a                	mv	a0,s6
    800053c2:	ffffc097          	auipc	ra,0xffffc
    800053c6:	e1e080e7          	jalr	-482(ra) # 800011e0 <walkaddr>
    800053ca:	862a                	mv	a2,a0
    if(pa == 0)
    800053cc:	dd45                	beqz	a0,80005384 <exec+0xfe>
      n = PGSIZE;
    800053ce:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800053d0:	fd49f2e3          	bgeu	s3,s4,80005394 <exec+0x10e>
      n = sz - i;
    800053d4:	894e                	mv	s2,s3
    800053d6:	bf7d                	j	80005394 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    800053d8:	4901                	li	s2,0
  iunlockput(ip);
    800053da:	8556                	mv	a0,s5
    800053dc:	fffff097          	auipc	ra,0xfffff
    800053e0:	bfe080e7          	jalr	-1026(ra) # 80003fda <iunlockput>
  end_op();
    800053e4:	fffff097          	auipc	ra,0xfffff
    800053e8:	3de080e7          	jalr	990(ra) # 800047c2 <end_op>
  p = myproc();
    800053ec:	ffffd097          	auipc	ra,0xffffd
    800053f0:	816080e7          	jalr	-2026(ra) # 80001c02 <myproc>
    800053f4:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800053f6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800053fa:	6785                	lui	a5,0x1
    800053fc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800053fe:	97ca                	add	a5,a5,s2
    80005400:	777d                	lui	a4,0xfffff
    80005402:	8ff9                	and	a5,a5,a4
    80005404:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005408:	4691                	li	a3,4
    8000540a:	6609                	lui	a2,0x2
    8000540c:	963e                	add	a2,a2,a5
    8000540e:	85be                	mv	a1,a5
    80005410:	855a                	mv	a0,s6
    80005412:	ffffc097          	auipc	ra,0xffffc
    80005416:	23a080e7          	jalr	570(ra) # 8000164c <uvmalloc>
    8000541a:	8c2a                	mv	s8,a0
  ip = 0;
    8000541c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000541e:	12050e63          	beqz	a0,8000555a <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005422:	75f9                	lui	a1,0xffffe
    80005424:	95aa                	add	a1,a1,a0
    80005426:	855a                	mv	a0,s6
    80005428:	ffffc097          	auipc	ra,0xffffc
    8000542c:	454080e7          	jalr	1108(ra) # 8000187c <uvmclear>
  stackbase = sp - PGSIZE;
    80005430:	7afd                	lui	s5,0xfffff
    80005432:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80005434:	df043783          	ld	a5,-528(s0)
    80005438:	6388                	ld	a0,0(a5)
    8000543a:	c925                	beqz	a0,800054aa <exec+0x224>
    8000543c:	e8840993          	addi	s3,s0,-376
    80005440:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80005444:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005446:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005448:	ffffc097          	auipc	ra,0xffffc
    8000544c:	b7a080e7          	jalr	-1158(ra) # 80000fc2 <strlen>
    80005450:	0015079b          	addiw	a5,a0,1
    80005454:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005458:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000545c:	13596363          	bltu	s2,s5,80005582 <exec+0x2fc>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005460:	df043d83          	ld	s11,-528(s0)
    80005464:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005468:	8552                	mv	a0,s4
    8000546a:	ffffc097          	auipc	ra,0xffffc
    8000546e:	b58080e7          	jalr	-1192(ra) # 80000fc2 <strlen>
    80005472:	0015069b          	addiw	a3,a0,1
    80005476:	8652                	mv	a2,s4
    80005478:	85ca                	mv	a1,s2
    8000547a:	855a                	mv	a0,s6
    8000547c:	ffffc097          	auipc	ra,0xffffc
    80005480:	432080e7          	jalr	1074(ra) # 800018ae <copyout>
    80005484:	10054363          	bltz	a0,8000558a <exec+0x304>
    ustack[argc] = sp;
    80005488:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000548c:	0485                	addi	s1,s1,1
    8000548e:	008d8793          	addi	a5,s11,8
    80005492:	def43823          	sd	a5,-528(s0)
    80005496:	008db503          	ld	a0,8(s11)
    8000549a:	c911                	beqz	a0,800054ae <exec+0x228>
    if(argc >= MAXARG)
    8000549c:	09a1                	addi	s3,s3,8
    8000549e:	fb3c95e3          	bne	s9,s3,80005448 <exec+0x1c2>
  sz = sz1;
    800054a2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800054a6:	4a81                	li	s5,0
    800054a8:	a84d                	j	8000555a <exec+0x2d4>
  sp = sz;
    800054aa:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800054ac:	4481                	li	s1,0
  ustack[argc] = 0;
    800054ae:	00349793          	slli	a5,s1,0x3
    800054b2:	f9078793          	addi	a5,a5,-112
    800054b6:	97a2                	add	a5,a5,s0
    800054b8:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    800054bc:	00148693          	addi	a3,s1,1
    800054c0:	068e                	slli	a3,a3,0x3
    800054c2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800054c6:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800054ca:	01597663          	bgeu	s2,s5,800054d6 <exec+0x250>
  sz = sz1;
    800054ce:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800054d2:	4a81                	li	s5,0
    800054d4:	a059                	j	8000555a <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800054d6:	e8840613          	addi	a2,s0,-376
    800054da:	85ca                	mv	a1,s2
    800054dc:	855a                	mv	a0,s6
    800054de:	ffffc097          	auipc	ra,0xffffc
    800054e2:	3d0080e7          	jalr	976(ra) # 800018ae <copyout>
    800054e6:	0a054663          	bltz	a0,80005592 <exec+0x30c>
  p->trapframe->a1 = sp;
    800054ea:	058bb783          	ld	a5,88(s7)
    800054ee:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800054f2:	de843783          	ld	a5,-536(s0)
    800054f6:	0007c703          	lbu	a4,0(a5)
    800054fa:	cf11                	beqz	a4,80005516 <exec+0x290>
    800054fc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800054fe:	02f00693          	li	a3,47
    80005502:	a039                	j	80005510 <exec+0x28a>
      last = s+1;
    80005504:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005508:	0785                	addi	a5,a5,1
    8000550a:	fff7c703          	lbu	a4,-1(a5)
    8000550e:	c701                	beqz	a4,80005516 <exec+0x290>
    if(*s == '/')
    80005510:	fed71ce3          	bne	a4,a3,80005508 <exec+0x282>
    80005514:	bfc5                	j	80005504 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80005516:	4641                	li	a2,16
    80005518:	de843583          	ld	a1,-536(s0)
    8000551c:	158b8513          	addi	a0,s7,344
    80005520:	ffffc097          	auipc	ra,0xffffc
    80005524:	a70080e7          	jalr	-1424(ra) # 80000f90 <safestrcpy>
  oldpagetable = p->pagetable;
    80005528:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000552c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005530:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005534:	058bb783          	ld	a5,88(s7)
    80005538:	e6043703          	ld	a4,-416(s0)
    8000553c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000553e:	058bb783          	ld	a5,88(s7)
    80005542:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005546:	85ea                	mv	a1,s10
    80005548:	ffffd097          	auipc	ra,0xffffd
    8000554c:	81a080e7          	jalr	-2022(ra) # 80001d62 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005550:	0004851b          	sext.w	a0,s1
    80005554:	b3f9                	j	80005322 <exec+0x9c>
    80005556:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000555a:	df843583          	ld	a1,-520(s0)
    8000555e:	855a                	mv	a0,s6
    80005560:	ffffd097          	auipc	ra,0xffffd
    80005564:	802080e7          	jalr	-2046(ra) # 80001d62 <proc_freepagetable>
  if(ip){
    80005568:	da0a93e3          	bnez	s5,8000530e <exec+0x88>
  return -1;
    8000556c:	557d                	li	a0,-1
    8000556e:	bb55                	j	80005322 <exec+0x9c>
    80005570:	df243c23          	sd	s2,-520(s0)
    80005574:	b7dd                	j	8000555a <exec+0x2d4>
    80005576:	df243c23          	sd	s2,-520(s0)
    8000557a:	b7c5                	j	8000555a <exec+0x2d4>
    8000557c:	df243c23          	sd	s2,-520(s0)
    80005580:	bfe9                	j	8000555a <exec+0x2d4>
  sz = sz1;
    80005582:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005586:	4a81                	li	s5,0
    80005588:	bfc9                	j	8000555a <exec+0x2d4>
  sz = sz1;
    8000558a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000558e:	4a81                	li	s5,0
    80005590:	b7e9                	j	8000555a <exec+0x2d4>
  sz = sz1;
    80005592:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005596:	4a81                	li	s5,0
    80005598:	b7c9                	j	8000555a <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000559a:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000559e:	e0843783          	ld	a5,-504(s0)
    800055a2:	0017869b          	addiw	a3,a5,1
    800055a6:	e0d43423          	sd	a3,-504(s0)
    800055aa:	e0043783          	ld	a5,-512(s0)
    800055ae:	0387879b          	addiw	a5,a5,56
    800055b2:	e8045703          	lhu	a4,-384(s0)
    800055b6:	e2e6d2e3          	bge	a3,a4,800053da <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800055ba:	2781                	sext.w	a5,a5
    800055bc:	e0f43023          	sd	a5,-512(s0)
    800055c0:	03800713          	li	a4,56
    800055c4:	86be                	mv	a3,a5
    800055c6:	e1040613          	addi	a2,s0,-496
    800055ca:	4581                	li	a1,0
    800055cc:	8556                	mv	a0,s5
    800055ce:	fffff097          	auipc	ra,0xfffff
    800055d2:	a5e080e7          	jalr	-1442(ra) # 8000402c <readi>
    800055d6:	03800793          	li	a5,56
    800055da:	f6f51ee3          	bne	a0,a5,80005556 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    800055de:	e1042783          	lw	a5,-496(s0)
    800055e2:	4705                	li	a4,1
    800055e4:	fae79de3          	bne	a5,a4,8000559e <exec+0x318>
    if(ph.memsz < ph.filesz)
    800055e8:	e3843483          	ld	s1,-456(s0)
    800055ec:	e3043783          	ld	a5,-464(s0)
    800055f0:	f8f4e0e3          	bltu	s1,a5,80005570 <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800055f4:	e2043783          	ld	a5,-480(s0)
    800055f8:	94be                	add	s1,s1,a5
    800055fa:	f6f4eee3          	bltu	s1,a5,80005576 <exec+0x2f0>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800055fe:	e1442503          	lw	a0,-492(s0)
    80005602:	00000097          	auipc	ra,0x0
    80005606:	c6a080e7          	jalr	-918(ra) # 8000526c <flags2perm>
    8000560a:	86aa                	mv	a3,a0
    8000560c:	8626                	mv	a2,s1
    8000560e:	85ca                	mv	a1,s2
    80005610:	855a                	mv	a0,s6
    80005612:	ffffc097          	auipc	ra,0xffffc
    80005616:	03a080e7          	jalr	58(ra) # 8000164c <uvmalloc>
    8000561a:	dea43c23          	sd	a0,-520(s0)
    8000561e:	dd39                	beqz	a0,8000557c <exec+0x2f6>
    if(ph.vaddr % PGSIZE != 0)
    80005620:	e2043c03          	ld	s8,-480(s0)
    80005624:	de043783          	ld	a5,-544(s0)
    80005628:	00fc77b3          	and	a5,s8,a5
    8000562c:	f79d                	bnez	a5,8000555a <exec+0x2d4>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000562e:	e1842c83          	lw	s9,-488(s0)
    80005632:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005636:	f60b82e3          	beqz	s7,8000559a <exec+0x314>
    8000563a:	89de                	mv	s3,s7
    8000563c:	4481                	li	s1,0
    8000563e:	bbad                	j	800053b8 <exec+0x132>

0000000080005640 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005640:	7179                	addi	sp,sp,-48
    80005642:	f406                	sd	ra,40(sp)
    80005644:	f022                	sd	s0,32(sp)
    80005646:	ec26                	sd	s1,24(sp)
    80005648:	e84a                	sd	s2,16(sp)
    8000564a:	1800                	addi	s0,sp,48
    8000564c:	892e                	mv	s2,a1
    8000564e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005650:	fdc40593          	addi	a1,s0,-36
    80005654:	ffffe097          	auipc	ra,0xffffe
    80005658:	a64080e7          	jalr	-1436(ra) # 800030b8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000565c:	fdc42703          	lw	a4,-36(s0)
    80005660:	47bd                	li	a5,15
    80005662:	02e7eb63          	bltu	a5,a4,80005698 <argfd+0x58>
    80005666:	ffffc097          	auipc	ra,0xffffc
    8000566a:	59c080e7          	jalr	1436(ra) # 80001c02 <myproc>
    8000566e:	fdc42703          	lw	a4,-36(s0)
    80005672:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7fdbc862>
    80005676:	078e                	slli	a5,a5,0x3
    80005678:	953e                	add	a0,a0,a5
    8000567a:	611c                	ld	a5,0(a0)
    8000567c:	c385                	beqz	a5,8000569c <argfd+0x5c>
    return -1;
  if(pfd)
    8000567e:	00090463          	beqz	s2,80005686 <argfd+0x46>
    *pfd = fd;
    80005682:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005686:	4501                	li	a0,0
  if(pf)
    80005688:	c091                	beqz	s1,8000568c <argfd+0x4c>
    *pf = f;
    8000568a:	e09c                	sd	a5,0(s1)
}
    8000568c:	70a2                	ld	ra,40(sp)
    8000568e:	7402                	ld	s0,32(sp)
    80005690:	64e2                	ld	s1,24(sp)
    80005692:	6942                	ld	s2,16(sp)
    80005694:	6145                	addi	sp,sp,48
    80005696:	8082                	ret
    return -1;
    80005698:	557d                	li	a0,-1
    8000569a:	bfcd                	j	8000568c <argfd+0x4c>
    8000569c:	557d                	li	a0,-1
    8000569e:	b7fd                	j	8000568c <argfd+0x4c>

00000000800056a0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800056a0:	1101                	addi	sp,sp,-32
    800056a2:	ec06                	sd	ra,24(sp)
    800056a4:	e822                	sd	s0,16(sp)
    800056a6:	e426                	sd	s1,8(sp)
    800056a8:	1000                	addi	s0,sp,32
    800056aa:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800056ac:	ffffc097          	auipc	ra,0xffffc
    800056b0:	556080e7          	jalr	1366(ra) # 80001c02 <myproc>
    800056b4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800056b6:	0d050793          	addi	a5,a0,208
    800056ba:	4501                	li	a0,0
    800056bc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800056be:	6398                	ld	a4,0(a5)
    800056c0:	cb19                	beqz	a4,800056d6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800056c2:	2505                	addiw	a0,a0,1
    800056c4:	07a1                	addi	a5,a5,8
    800056c6:	fed51ce3          	bne	a0,a3,800056be <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800056ca:	557d                	li	a0,-1
}
    800056cc:	60e2                	ld	ra,24(sp)
    800056ce:	6442                	ld	s0,16(sp)
    800056d0:	64a2                	ld	s1,8(sp)
    800056d2:	6105                	addi	sp,sp,32
    800056d4:	8082                	ret
      p->ofile[fd] = f;
    800056d6:	01a50793          	addi	a5,a0,26
    800056da:	078e                	slli	a5,a5,0x3
    800056dc:	963e                	add	a2,a2,a5
    800056de:	e204                	sd	s1,0(a2)
      return fd;
    800056e0:	b7f5                	j	800056cc <fdalloc+0x2c>

00000000800056e2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800056e2:	715d                	addi	sp,sp,-80
    800056e4:	e486                	sd	ra,72(sp)
    800056e6:	e0a2                	sd	s0,64(sp)
    800056e8:	fc26                	sd	s1,56(sp)
    800056ea:	f84a                	sd	s2,48(sp)
    800056ec:	f44e                	sd	s3,40(sp)
    800056ee:	f052                	sd	s4,32(sp)
    800056f0:	ec56                	sd	s5,24(sp)
    800056f2:	e85a                	sd	s6,16(sp)
    800056f4:	0880                	addi	s0,sp,80
    800056f6:	8b2e                	mv	s6,a1
    800056f8:	89b2                	mv	s3,a2
    800056fa:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800056fc:	fb040593          	addi	a1,s0,-80
    80005700:	fffff097          	auipc	ra,0xfffff
    80005704:	e42080e7          	jalr	-446(ra) # 80004542 <nameiparent>
    80005708:	84aa                	mv	s1,a0
    8000570a:	14050f63          	beqz	a0,80005868 <create+0x186>
    return 0;

  ilock(dp);
    8000570e:	ffffe097          	auipc	ra,0xffffe
    80005712:	66a080e7          	jalr	1642(ra) # 80003d78 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005716:	4601                	li	a2,0
    80005718:	fb040593          	addi	a1,s0,-80
    8000571c:	8526                	mv	a0,s1
    8000571e:	fffff097          	auipc	ra,0xfffff
    80005722:	b3e080e7          	jalr	-1218(ra) # 8000425c <dirlookup>
    80005726:	8aaa                	mv	s5,a0
    80005728:	c931                	beqz	a0,8000577c <create+0x9a>
    iunlockput(dp);
    8000572a:	8526                	mv	a0,s1
    8000572c:	fffff097          	auipc	ra,0xfffff
    80005730:	8ae080e7          	jalr	-1874(ra) # 80003fda <iunlockput>
    ilock(ip);
    80005734:	8556                	mv	a0,s5
    80005736:	ffffe097          	auipc	ra,0xffffe
    8000573a:	642080e7          	jalr	1602(ra) # 80003d78 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000573e:	000b059b          	sext.w	a1,s6
    80005742:	4789                	li	a5,2
    80005744:	02f59563          	bne	a1,a5,8000576e <create+0x8c>
    80005748:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7fdbc88c>
    8000574c:	37f9                	addiw	a5,a5,-2
    8000574e:	17c2                	slli	a5,a5,0x30
    80005750:	93c1                	srli	a5,a5,0x30
    80005752:	4705                	li	a4,1
    80005754:	00f76d63          	bltu	a4,a5,8000576e <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005758:	8556                	mv	a0,s5
    8000575a:	60a6                	ld	ra,72(sp)
    8000575c:	6406                	ld	s0,64(sp)
    8000575e:	74e2                	ld	s1,56(sp)
    80005760:	7942                	ld	s2,48(sp)
    80005762:	79a2                	ld	s3,40(sp)
    80005764:	7a02                	ld	s4,32(sp)
    80005766:	6ae2                	ld	s5,24(sp)
    80005768:	6b42                	ld	s6,16(sp)
    8000576a:	6161                	addi	sp,sp,80
    8000576c:	8082                	ret
    iunlockput(ip);
    8000576e:	8556                	mv	a0,s5
    80005770:	fffff097          	auipc	ra,0xfffff
    80005774:	86a080e7          	jalr	-1942(ra) # 80003fda <iunlockput>
    return 0;
    80005778:	4a81                	li	s5,0
    8000577a:	bff9                	j	80005758 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000577c:	85da                	mv	a1,s6
    8000577e:	4088                	lw	a0,0(s1)
    80005780:	ffffe097          	auipc	ra,0xffffe
    80005784:	45a080e7          	jalr	1114(ra) # 80003bda <ialloc>
    80005788:	8a2a                	mv	s4,a0
    8000578a:	c539                	beqz	a0,800057d8 <create+0xf6>
  ilock(ip);
    8000578c:	ffffe097          	auipc	ra,0xffffe
    80005790:	5ec080e7          	jalr	1516(ra) # 80003d78 <ilock>
  ip->major = major;
    80005794:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005798:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000579c:	4905                	li	s2,1
    8000579e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800057a2:	8552                	mv	a0,s4
    800057a4:	ffffe097          	auipc	ra,0xffffe
    800057a8:	508080e7          	jalr	1288(ra) # 80003cac <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800057ac:	000b059b          	sext.w	a1,s6
    800057b0:	03258b63          	beq	a1,s2,800057e6 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800057b4:	004a2603          	lw	a2,4(s4)
    800057b8:	fb040593          	addi	a1,s0,-80
    800057bc:	8526                	mv	a0,s1
    800057be:	fffff097          	auipc	ra,0xfffff
    800057c2:	cb4080e7          	jalr	-844(ra) # 80004472 <dirlink>
    800057c6:	06054f63          	bltz	a0,80005844 <create+0x162>
  iunlockput(dp);
    800057ca:	8526                	mv	a0,s1
    800057cc:	fffff097          	auipc	ra,0xfffff
    800057d0:	80e080e7          	jalr	-2034(ra) # 80003fda <iunlockput>
  return ip;
    800057d4:	8ad2                	mv	s5,s4
    800057d6:	b749                	j	80005758 <create+0x76>
    iunlockput(dp);
    800057d8:	8526                	mv	a0,s1
    800057da:	fffff097          	auipc	ra,0xfffff
    800057de:	800080e7          	jalr	-2048(ra) # 80003fda <iunlockput>
    return 0;
    800057e2:	8ad2                	mv	s5,s4
    800057e4:	bf95                	j	80005758 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800057e6:	004a2603          	lw	a2,4(s4)
    800057ea:	00003597          	auipc	a1,0x3
    800057ee:	f4658593          	addi	a1,a1,-186 # 80008730 <syscalls+0x2b8>
    800057f2:	8552                	mv	a0,s4
    800057f4:	fffff097          	auipc	ra,0xfffff
    800057f8:	c7e080e7          	jalr	-898(ra) # 80004472 <dirlink>
    800057fc:	04054463          	bltz	a0,80005844 <create+0x162>
    80005800:	40d0                	lw	a2,4(s1)
    80005802:	00003597          	auipc	a1,0x3
    80005806:	f3658593          	addi	a1,a1,-202 # 80008738 <syscalls+0x2c0>
    8000580a:	8552                	mv	a0,s4
    8000580c:	fffff097          	auipc	ra,0xfffff
    80005810:	c66080e7          	jalr	-922(ra) # 80004472 <dirlink>
    80005814:	02054863          	bltz	a0,80005844 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80005818:	004a2603          	lw	a2,4(s4)
    8000581c:	fb040593          	addi	a1,s0,-80
    80005820:	8526                	mv	a0,s1
    80005822:	fffff097          	auipc	ra,0xfffff
    80005826:	c50080e7          	jalr	-944(ra) # 80004472 <dirlink>
    8000582a:	00054d63          	bltz	a0,80005844 <create+0x162>
    dp->nlink++;  // for ".."
    8000582e:	04a4d783          	lhu	a5,74(s1)
    80005832:	2785                	addiw	a5,a5,1
    80005834:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005838:	8526                	mv	a0,s1
    8000583a:	ffffe097          	auipc	ra,0xffffe
    8000583e:	472080e7          	jalr	1138(ra) # 80003cac <iupdate>
    80005842:	b761                	j	800057ca <create+0xe8>
  ip->nlink = 0;
    80005844:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005848:	8552                	mv	a0,s4
    8000584a:	ffffe097          	auipc	ra,0xffffe
    8000584e:	462080e7          	jalr	1122(ra) # 80003cac <iupdate>
  iunlockput(ip);
    80005852:	8552                	mv	a0,s4
    80005854:	ffffe097          	auipc	ra,0xffffe
    80005858:	786080e7          	jalr	1926(ra) # 80003fda <iunlockput>
  iunlockput(dp);
    8000585c:	8526                	mv	a0,s1
    8000585e:	ffffe097          	auipc	ra,0xffffe
    80005862:	77c080e7          	jalr	1916(ra) # 80003fda <iunlockput>
  return 0;
    80005866:	bdcd                	j	80005758 <create+0x76>
    return 0;
    80005868:	8aaa                	mv	s5,a0
    8000586a:	b5fd                	j	80005758 <create+0x76>

000000008000586c <sys_dup>:
{
    8000586c:	7179                	addi	sp,sp,-48
    8000586e:	f406                	sd	ra,40(sp)
    80005870:	f022                	sd	s0,32(sp)
    80005872:	ec26                	sd	s1,24(sp)
    80005874:	e84a                	sd	s2,16(sp)
    80005876:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005878:	fd840613          	addi	a2,s0,-40
    8000587c:	4581                	li	a1,0
    8000587e:	4501                	li	a0,0
    80005880:	00000097          	auipc	ra,0x0
    80005884:	dc0080e7          	jalr	-576(ra) # 80005640 <argfd>
    return -1;
    80005888:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000588a:	02054363          	bltz	a0,800058b0 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000588e:	fd843903          	ld	s2,-40(s0)
    80005892:	854a                	mv	a0,s2
    80005894:	00000097          	auipc	ra,0x0
    80005898:	e0c080e7          	jalr	-500(ra) # 800056a0 <fdalloc>
    8000589c:	84aa                	mv	s1,a0
    return -1;
    8000589e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800058a0:	00054863          	bltz	a0,800058b0 <sys_dup+0x44>
  filedup(f);
    800058a4:	854a                	mv	a0,s2
    800058a6:	fffff097          	auipc	ra,0xfffff
    800058aa:	314080e7          	jalr	788(ra) # 80004bba <filedup>
  return fd;
    800058ae:	87a6                	mv	a5,s1
}
    800058b0:	853e                	mv	a0,a5
    800058b2:	70a2                	ld	ra,40(sp)
    800058b4:	7402                	ld	s0,32(sp)
    800058b6:	64e2                	ld	s1,24(sp)
    800058b8:	6942                	ld	s2,16(sp)
    800058ba:	6145                	addi	sp,sp,48
    800058bc:	8082                	ret

00000000800058be <sys_getreadcount>:
{
    800058be:	1141                	addi	sp,sp,-16
    800058c0:	e422                	sd	s0,8(sp)
    800058c2:	0800                	addi	s0,sp,16
}
    800058c4:	00003517          	auipc	a0,0x3
    800058c8:	06052503          	lw	a0,96(a0) # 80008924 <readCount>
    800058cc:	6422                	ld	s0,8(sp)
    800058ce:	0141                	addi	sp,sp,16
    800058d0:	8082                	ret

00000000800058d2 <sys_read>:
{
    800058d2:	7179                	addi	sp,sp,-48
    800058d4:	f406                	sd	ra,40(sp)
    800058d6:	f022                	sd	s0,32(sp)
    800058d8:	1800                	addi	s0,sp,48
  readCount++;
    800058da:	00003717          	auipc	a4,0x3
    800058de:	04a70713          	addi	a4,a4,74 # 80008924 <readCount>
    800058e2:	431c                	lw	a5,0(a4)
    800058e4:	2785                	addiw	a5,a5,1
    800058e6:	c31c                	sw	a5,0(a4)
  argaddr(1, &p);
    800058e8:	fd840593          	addi	a1,s0,-40
    800058ec:	4505                	li	a0,1
    800058ee:	ffffd097          	auipc	ra,0xffffd
    800058f2:	7ea080e7          	jalr	2026(ra) # 800030d8 <argaddr>
  argint(2, &n);
    800058f6:	fe440593          	addi	a1,s0,-28
    800058fa:	4509                	li	a0,2
    800058fc:	ffffd097          	auipc	ra,0xffffd
    80005900:	7bc080e7          	jalr	1980(ra) # 800030b8 <argint>
  if(argfd(0, 0, &f) < 0)
    80005904:	fe840613          	addi	a2,s0,-24
    80005908:	4581                	li	a1,0
    8000590a:	4501                	li	a0,0
    8000590c:	00000097          	auipc	ra,0x0
    80005910:	d34080e7          	jalr	-716(ra) # 80005640 <argfd>
    80005914:	87aa                	mv	a5,a0
    return -1;
    80005916:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005918:	0007cc63          	bltz	a5,80005930 <sys_read+0x5e>
  return fileread(f, p, n);
    8000591c:	fe442603          	lw	a2,-28(s0)
    80005920:	fd843583          	ld	a1,-40(s0)
    80005924:	fe843503          	ld	a0,-24(s0)
    80005928:	fffff097          	auipc	ra,0xfffff
    8000592c:	41e080e7          	jalr	1054(ra) # 80004d46 <fileread>
}
    80005930:	70a2                	ld	ra,40(sp)
    80005932:	7402                	ld	s0,32(sp)
    80005934:	6145                	addi	sp,sp,48
    80005936:	8082                	ret

0000000080005938 <sys_write>:
{
    80005938:	7179                	addi	sp,sp,-48
    8000593a:	f406                	sd	ra,40(sp)
    8000593c:	f022                	sd	s0,32(sp)
    8000593e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005940:	fd840593          	addi	a1,s0,-40
    80005944:	4505                	li	a0,1
    80005946:	ffffd097          	auipc	ra,0xffffd
    8000594a:	792080e7          	jalr	1938(ra) # 800030d8 <argaddr>
  argint(2, &n);
    8000594e:	fe440593          	addi	a1,s0,-28
    80005952:	4509                	li	a0,2
    80005954:	ffffd097          	auipc	ra,0xffffd
    80005958:	764080e7          	jalr	1892(ra) # 800030b8 <argint>
  if(argfd(0, 0, &f) < 0)
    8000595c:	fe840613          	addi	a2,s0,-24
    80005960:	4581                	li	a1,0
    80005962:	4501                	li	a0,0
    80005964:	00000097          	auipc	ra,0x0
    80005968:	cdc080e7          	jalr	-804(ra) # 80005640 <argfd>
    8000596c:	87aa                	mv	a5,a0
    return -1;
    8000596e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005970:	0007cc63          	bltz	a5,80005988 <sys_write+0x50>
  return filewrite(f, p, n);
    80005974:	fe442603          	lw	a2,-28(s0)
    80005978:	fd843583          	ld	a1,-40(s0)
    8000597c:	fe843503          	ld	a0,-24(s0)
    80005980:	fffff097          	auipc	ra,0xfffff
    80005984:	488080e7          	jalr	1160(ra) # 80004e08 <filewrite>
}
    80005988:	70a2                	ld	ra,40(sp)
    8000598a:	7402                	ld	s0,32(sp)
    8000598c:	6145                	addi	sp,sp,48
    8000598e:	8082                	ret

0000000080005990 <sys_close>:
{
    80005990:	1101                	addi	sp,sp,-32
    80005992:	ec06                	sd	ra,24(sp)
    80005994:	e822                	sd	s0,16(sp)
    80005996:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005998:	fe040613          	addi	a2,s0,-32
    8000599c:	fec40593          	addi	a1,s0,-20
    800059a0:	4501                	li	a0,0
    800059a2:	00000097          	auipc	ra,0x0
    800059a6:	c9e080e7          	jalr	-866(ra) # 80005640 <argfd>
    return -1;
    800059aa:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800059ac:	02054463          	bltz	a0,800059d4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800059b0:	ffffc097          	auipc	ra,0xffffc
    800059b4:	252080e7          	jalr	594(ra) # 80001c02 <myproc>
    800059b8:	fec42783          	lw	a5,-20(s0)
    800059bc:	07e9                	addi	a5,a5,26
    800059be:	078e                	slli	a5,a5,0x3
    800059c0:	953e                	add	a0,a0,a5
    800059c2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800059c6:	fe043503          	ld	a0,-32(s0)
    800059ca:	fffff097          	auipc	ra,0xfffff
    800059ce:	242080e7          	jalr	578(ra) # 80004c0c <fileclose>
  return 0;
    800059d2:	4781                	li	a5,0
}
    800059d4:	853e                	mv	a0,a5
    800059d6:	60e2                	ld	ra,24(sp)
    800059d8:	6442                	ld	s0,16(sp)
    800059da:	6105                	addi	sp,sp,32
    800059dc:	8082                	ret

00000000800059de <sys_fstat>:
{
    800059de:	1101                	addi	sp,sp,-32
    800059e0:	ec06                	sd	ra,24(sp)
    800059e2:	e822                	sd	s0,16(sp)
    800059e4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800059e6:	fe040593          	addi	a1,s0,-32
    800059ea:	4505                	li	a0,1
    800059ec:	ffffd097          	auipc	ra,0xffffd
    800059f0:	6ec080e7          	jalr	1772(ra) # 800030d8 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800059f4:	fe840613          	addi	a2,s0,-24
    800059f8:	4581                	li	a1,0
    800059fa:	4501                	li	a0,0
    800059fc:	00000097          	auipc	ra,0x0
    80005a00:	c44080e7          	jalr	-956(ra) # 80005640 <argfd>
    80005a04:	87aa                	mv	a5,a0
    return -1;
    80005a06:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005a08:	0007ca63          	bltz	a5,80005a1c <sys_fstat+0x3e>
  return filestat(f, st);
    80005a0c:	fe043583          	ld	a1,-32(s0)
    80005a10:	fe843503          	ld	a0,-24(s0)
    80005a14:	fffff097          	auipc	ra,0xfffff
    80005a18:	2c0080e7          	jalr	704(ra) # 80004cd4 <filestat>
}
    80005a1c:	60e2                	ld	ra,24(sp)
    80005a1e:	6442                	ld	s0,16(sp)
    80005a20:	6105                	addi	sp,sp,32
    80005a22:	8082                	ret

0000000080005a24 <sys_link>:
{
    80005a24:	7169                	addi	sp,sp,-304
    80005a26:	f606                	sd	ra,296(sp)
    80005a28:	f222                	sd	s0,288(sp)
    80005a2a:	ee26                	sd	s1,280(sp)
    80005a2c:	ea4a                	sd	s2,272(sp)
    80005a2e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a30:	08000613          	li	a2,128
    80005a34:	ed040593          	addi	a1,s0,-304
    80005a38:	4501                	li	a0,0
    80005a3a:	ffffd097          	auipc	ra,0xffffd
    80005a3e:	6be080e7          	jalr	1726(ra) # 800030f8 <argstr>
    return -1;
    80005a42:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a44:	10054e63          	bltz	a0,80005b60 <sys_link+0x13c>
    80005a48:	08000613          	li	a2,128
    80005a4c:	f5040593          	addi	a1,s0,-176
    80005a50:	4505                	li	a0,1
    80005a52:	ffffd097          	auipc	ra,0xffffd
    80005a56:	6a6080e7          	jalr	1702(ra) # 800030f8 <argstr>
    return -1;
    80005a5a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a5c:	10054263          	bltz	a0,80005b60 <sys_link+0x13c>
  begin_op();
    80005a60:	fffff097          	auipc	ra,0xfffff
    80005a64:	ce4080e7          	jalr	-796(ra) # 80004744 <begin_op>
  if((ip = namei(old)) == 0){
    80005a68:	ed040513          	addi	a0,s0,-304
    80005a6c:	fffff097          	auipc	ra,0xfffff
    80005a70:	ab8080e7          	jalr	-1352(ra) # 80004524 <namei>
    80005a74:	84aa                	mv	s1,a0
    80005a76:	c551                	beqz	a0,80005b02 <sys_link+0xde>
  ilock(ip);
    80005a78:	ffffe097          	auipc	ra,0xffffe
    80005a7c:	300080e7          	jalr	768(ra) # 80003d78 <ilock>
  if(ip->type == T_DIR){
    80005a80:	04449703          	lh	a4,68(s1)
    80005a84:	4785                	li	a5,1
    80005a86:	08f70463          	beq	a4,a5,80005b0e <sys_link+0xea>
  ip->nlink++;
    80005a8a:	04a4d783          	lhu	a5,74(s1)
    80005a8e:	2785                	addiw	a5,a5,1
    80005a90:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a94:	8526                	mv	a0,s1
    80005a96:	ffffe097          	auipc	ra,0xffffe
    80005a9a:	216080e7          	jalr	534(ra) # 80003cac <iupdate>
  iunlock(ip);
    80005a9e:	8526                	mv	a0,s1
    80005aa0:	ffffe097          	auipc	ra,0xffffe
    80005aa4:	39a080e7          	jalr	922(ra) # 80003e3a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005aa8:	fd040593          	addi	a1,s0,-48
    80005aac:	f5040513          	addi	a0,s0,-176
    80005ab0:	fffff097          	auipc	ra,0xfffff
    80005ab4:	a92080e7          	jalr	-1390(ra) # 80004542 <nameiparent>
    80005ab8:	892a                	mv	s2,a0
    80005aba:	c935                	beqz	a0,80005b2e <sys_link+0x10a>
  ilock(dp);
    80005abc:	ffffe097          	auipc	ra,0xffffe
    80005ac0:	2bc080e7          	jalr	700(ra) # 80003d78 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005ac4:	00092703          	lw	a4,0(s2)
    80005ac8:	409c                	lw	a5,0(s1)
    80005aca:	04f71d63          	bne	a4,a5,80005b24 <sys_link+0x100>
    80005ace:	40d0                	lw	a2,4(s1)
    80005ad0:	fd040593          	addi	a1,s0,-48
    80005ad4:	854a                	mv	a0,s2
    80005ad6:	fffff097          	auipc	ra,0xfffff
    80005ada:	99c080e7          	jalr	-1636(ra) # 80004472 <dirlink>
    80005ade:	04054363          	bltz	a0,80005b24 <sys_link+0x100>
  iunlockput(dp);
    80005ae2:	854a                	mv	a0,s2
    80005ae4:	ffffe097          	auipc	ra,0xffffe
    80005ae8:	4f6080e7          	jalr	1270(ra) # 80003fda <iunlockput>
  iput(ip);
    80005aec:	8526                	mv	a0,s1
    80005aee:	ffffe097          	auipc	ra,0xffffe
    80005af2:	444080e7          	jalr	1092(ra) # 80003f32 <iput>
  end_op();
    80005af6:	fffff097          	auipc	ra,0xfffff
    80005afa:	ccc080e7          	jalr	-820(ra) # 800047c2 <end_op>
  return 0;
    80005afe:	4781                	li	a5,0
    80005b00:	a085                	j	80005b60 <sys_link+0x13c>
    end_op();
    80005b02:	fffff097          	auipc	ra,0xfffff
    80005b06:	cc0080e7          	jalr	-832(ra) # 800047c2 <end_op>
    return -1;
    80005b0a:	57fd                	li	a5,-1
    80005b0c:	a891                	j	80005b60 <sys_link+0x13c>
    iunlockput(ip);
    80005b0e:	8526                	mv	a0,s1
    80005b10:	ffffe097          	auipc	ra,0xffffe
    80005b14:	4ca080e7          	jalr	1226(ra) # 80003fda <iunlockput>
    end_op();
    80005b18:	fffff097          	auipc	ra,0xfffff
    80005b1c:	caa080e7          	jalr	-854(ra) # 800047c2 <end_op>
    return -1;
    80005b20:	57fd                	li	a5,-1
    80005b22:	a83d                	j	80005b60 <sys_link+0x13c>
    iunlockput(dp);
    80005b24:	854a                	mv	a0,s2
    80005b26:	ffffe097          	auipc	ra,0xffffe
    80005b2a:	4b4080e7          	jalr	1204(ra) # 80003fda <iunlockput>
  ilock(ip);
    80005b2e:	8526                	mv	a0,s1
    80005b30:	ffffe097          	auipc	ra,0xffffe
    80005b34:	248080e7          	jalr	584(ra) # 80003d78 <ilock>
  ip->nlink--;
    80005b38:	04a4d783          	lhu	a5,74(s1)
    80005b3c:	37fd                	addiw	a5,a5,-1
    80005b3e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005b42:	8526                	mv	a0,s1
    80005b44:	ffffe097          	auipc	ra,0xffffe
    80005b48:	168080e7          	jalr	360(ra) # 80003cac <iupdate>
  iunlockput(ip);
    80005b4c:	8526                	mv	a0,s1
    80005b4e:	ffffe097          	auipc	ra,0xffffe
    80005b52:	48c080e7          	jalr	1164(ra) # 80003fda <iunlockput>
  end_op();
    80005b56:	fffff097          	auipc	ra,0xfffff
    80005b5a:	c6c080e7          	jalr	-916(ra) # 800047c2 <end_op>
  return -1;
    80005b5e:	57fd                	li	a5,-1
}
    80005b60:	853e                	mv	a0,a5
    80005b62:	70b2                	ld	ra,296(sp)
    80005b64:	7412                	ld	s0,288(sp)
    80005b66:	64f2                	ld	s1,280(sp)
    80005b68:	6952                	ld	s2,272(sp)
    80005b6a:	6155                	addi	sp,sp,304
    80005b6c:	8082                	ret

0000000080005b6e <sys_unlink>:
{
    80005b6e:	7151                	addi	sp,sp,-240
    80005b70:	f586                	sd	ra,232(sp)
    80005b72:	f1a2                	sd	s0,224(sp)
    80005b74:	eda6                	sd	s1,216(sp)
    80005b76:	e9ca                	sd	s2,208(sp)
    80005b78:	e5ce                	sd	s3,200(sp)
    80005b7a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005b7c:	08000613          	li	a2,128
    80005b80:	f3040593          	addi	a1,s0,-208
    80005b84:	4501                	li	a0,0
    80005b86:	ffffd097          	auipc	ra,0xffffd
    80005b8a:	572080e7          	jalr	1394(ra) # 800030f8 <argstr>
    80005b8e:	18054163          	bltz	a0,80005d10 <sys_unlink+0x1a2>
  begin_op();
    80005b92:	fffff097          	auipc	ra,0xfffff
    80005b96:	bb2080e7          	jalr	-1102(ra) # 80004744 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005b9a:	fb040593          	addi	a1,s0,-80
    80005b9e:	f3040513          	addi	a0,s0,-208
    80005ba2:	fffff097          	auipc	ra,0xfffff
    80005ba6:	9a0080e7          	jalr	-1632(ra) # 80004542 <nameiparent>
    80005baa:	84aa                	mv	s1,a0
    80005bac:	c979                	beqz	a0,80005c82 <sys_unlink+0x114>
  ilock(dp);
    80005bae:	ffffe097          	auipc	ra,0xffffe
    80005bb2:	1ca080e7          	jalr	458(ra) # 80003d78 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005bb6:	00003597          	auipc	a1,0x3
    80005bba:	b7a58593          	addi	a1,a1,-1158 # 80008730 <syscalls+0x2b8>
    80005bbe:	fb040513          	addi	a0,s0,-80
    80005bc2:	ffffe097          	auipc	ra,0xffffe
    80005bc6:	680080e7          	jalr	1664(ra) # 80004242 <namecmp>
    80005bca:	14050a63          	beqz	a0,80005d1e <sys_unlink+0x1b0>
    80005bce:	00003597          	auipc	a1,0x3
    80005bd2:	b6a58593          	addi	a1,a1,-1174 # 80008738 <syscalls+0x2c0>
    80005bd6:	fb040513          	addi	a0,s0,-80
    80005bda:	ffffe097          	auipc	ra,0xffffe
    80005bde:	668080e7          	jalr	1640(ra) # 80004242 <namecmp>
    80005be2:	12050e63          	beqz	a0,80005d1e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005be6:	f2c40613          	addi	a2,s0,-212
    80005bea:	fb040593          	addi	a1,s0,-80
    80005bee:	8526                	mv	a0,s1
    80005bf0:	ffffe097          	auipc	ra,0xffffe
    80005bf4:	66c080e7          	jalr	1644(ra) # 8000425c <dirlookup>
    80005bf8:	892a                	mv	s2,a0
    80005bfa:	12050263          	beqz	a0,80005d1e <sys_unlink+0x1b0>
  ilock(ip);
    80005bfe:	ffffe097          	auipc	ra,0xffffe
    80005c02:	17a080e7          	jalr	378(ra) # 80003d78 <ilock>
  if(ip->nlink < 1)
    80005c06:	04a91783          	lh	a5,74(s2)
    80005c0a:	08f05263          	blez	a5,80005c8e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005c0e:	04491703          	lh	a4,68(s2)
    80005c12:	4785                	li	a5,1
    80005c14:	08f70563          	beq	a4,a5,80005c9e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005c18:	4641                	li	a2,16
    80005c1a:	4581                	li	a1,0
    80005c1c:	fc040513          	addi	a0,s0,-64
    80005c20:	ffffb097          	auipc	ra,0xffffb
    80005c24:	226080e7          	jalr	550(ra) # 80000e46 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c28:	4741                	li	a4,16
    80005c2a:	f2c42683          	lw	a3,-212(s0)
    80005c2e:	fc040613          	addi	a2,s0,-64
    80005c32:	4581                	li	a1,0
    80005c34:	8526                	mv	a0,s1
    80005c36:	ffffe097          	auipc	ra,0xffffe
    80005c3a:	4ee080e7          	jalr	1262(ra) # 80004124 <writei>
    80005c3e:	47c1                	li	a5,16
    80005c40:	0af51563          	bne	a0,a5,80005cea <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005c44:	04491703          	lh	a4,68(s2)
    80005c48:	4785                	li	a5,1
    80005c4a:	0af70863          	beq	a4,a5,80005cfa <sys_unlink+0x18c>
  iunlockput(dp);
    80005c4e:	8526                	mv	a0,s1
    80005c50:	ffffe097          	auipc	ra,0xffffe
    80005c54:	38a080e7          	jalr	906(ra) # 80003fda <iunlockput>
  ip->nlink--;
    80005c58:	04a95783          	lhu	a5,74(s2)
    80005c5c:	37fd                	addiw	a5,a5,-1
    80005c5e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005c62:	854a                	mv	a0,s2
    80005c64:	ffffe097          	auipc	ra,0xffffe
    80005c68:	048080e7          	jalr	72(ra) # 80003cac <iupdate>
  iunlockput(ip);
    80005c6c:	854a                	mv	a0,s2
    80005c6e:	ffffe097          	auipc	ra,0xffffe
    80005c72:	36c080e7          	jalr	876(ra) # 80003fda <iunlockput>
  end_op();
    80005c76:	fffff097          	auipc	ra,0xfffff
    80005c7a:	b4c080e7          	jalr	-1204(ra) # 800047c2 <end_op>
  return 0;
    80005c7e:	4501                	li	a0,0
    80005c80:	a84d                	j	80005d32 <sys_unlink+0x1c4>
    end_op();
    80005c82:	fffff097          	auipc	ra,0xfffff
    80005c86:	b40080e7          	jalr	-1216(ra) # 800047c2 <end_op>
    return -1;
    80005c8a:	557d                	li	a0,-1
    80005c8c:	a05d                	j	80005d32 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005c8e:	00003517          	auipc	a0,0x3
    80005c92:	ab250513          	addi	a0,a0,-1358 # 80008740 <syscalls+0x2c8>
    80005c96:	ffffb097          	auipc	ra,0xffffb
    80005c9a:	8aa080e7          	jalr	-1878(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c9e:	04c92703          	lw	a4,76(s2)
    80005ca2:	02000793          	li	a5,32
    80005ca6:	f6e7f9e3          	bgeu	a5,a4,80005c18 <sys_unlink+0xaa>
    80005caa:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005cae:	4741                	li	a4,16
    80005cb0:	86ce                	mv	a3,s3
    80005cb2:	f1840613          	addi	a2,s0,-232
    80005cb6:	4581                	li	a1,0
    80005cb8:	854a                	mv	a0,s2
    80005cba:	ffffe097          	auipc	ra,0xffffe
    80005cbe:	372080e7          	jalr	882(ra) # 8000402c <readi>
    80005cc2:	47c1                	li	a5,16
    80005cc4:	00f51b63          	bne	a0,a5,80005cda <sys_unlink+0x16c>
    if(de.inum != 0)
    80005cc8:	f1845783          	lhu	a5,-232(s0)
    80005ccc:	e7a1                	bnez	a5,80005d14 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005cce:	29c1                	addiw	s3,s3,16
    80005cd0:	04c92783          	lw	a5,76(s2)
    80005cd4:	fcf9ede3          	bltu	s3,a5,80005cae <sys_unlink+0x140>
    80005cd8:	b781                	j	80005c18 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005cda:	00003517          	auipc	a0,0x3
    80005cde:	a7e50513          	addi	a0,a0,-1410 # 80008758 <syscalls+0x2e0>
    80005ce2:	ffffb097          	auipc	ra,0xffffb
    80005ce6:	85e080e7          	jalr	-1954(ra) # 80000540 <panic>
    panic("unlink: writei");
    80005cea:	00003517          	auipc	a0,0x3
    80005cee:	a8650513          	addi	a0,a0,-1402 # 80008770 <syscalls+0x2f8>
    80005cf2:	ffffb097          	auipc	ra,0xffffb
    80005cf6:	84e080e7          	jalr	-1970(ra) # 80000540 <panic>
    dp->nlink--;
    80005cfa:	04a4d783          	lhu	a5,74(s1)
    80005cfe:	37fd                	addiw	a5,a5,-1
    80005d00:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005d04:	8526                	mv	a0,s1
    80005d06:	ffffe097          	auipc	ra,0xffffe
    80005d0a:	fa6080e7          	jalr	-90(ra) # 80003cac <iupdate>
    80005d0e:	b781                	j	80005c4e <sys_unlink+0xe0>
    return -1;
    80005d10:	557d                	li	a0,-1
    80005d12:	a005                	j	80005d32 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005d14:	854a                	mv	a0,s2
    80005d16:	ffffe097          	auipc	ra,0xffffe
    80005d1a:	2c4080e7          	jalr	708(ra) # 80003fda <iunlockput>
  iunlockput(dp);
    80005d1e:	8526                	mv	a0,s1
    80005d20:	ffffe097          	auipc	ra,0xffffe
    80005d24:	2ba080e7          	jalr	698(ra) # 80003fda <iunlockput>
  end_op();
    80005d28:	fffff097          	auipc	ra,0xfffff
    80005d2c:	a9a080e7          	jalr	-1382(ra) # 800047c2 <end_op>
  return -1;
    80005d30:	557d                	li	a0,-1
}
    80005d32:	70ae                	ld	ra,232(sp)
    80005d34:	740e                	ld	s0,224(sp)
    80005d36:	64ee                	ld	s1,216(sp)
    80005d38:	694e                	ld	s2,208(sp)
    80005d3a:	69ae                	ld	s3,200(sp)
    80005d3c:	616d                	addi	sp,sp,240
    80005d3e:	8082                	ret

0000000080005d40 <sys_open>:

uint64
sys_open(void)
{
    80005d40:	7131                	addi	sp,sp,-192
    80005d42:	fd06                	sd	ra,184(sp)
    80005d44:	f922                	sd	s0,176(sp)
    80005d46:	f526                	sd	s1,168(sp)
    80005d48:	f14a                	sd	s2,160(sp)
    80005d4a:	ed4e                	sd	s3,152(sp)
    80005d4c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005d4e:	f4c40593          	addi	a1,s0,-180
    80005d52:	4505                	li	a0,1
    80005d54:	ffffd097          	auipc	ra,0xffffd
    80005d58:	364080e7          	jalr	868(ra) # 800030b8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d5c:	08000613          	li	a2,128
    80005d60:	f5040593          	addi	a1,s0,-176
    80005d64:	4501                	li	a0,0
    80005d66:	ffffd097          	auipc	ra,0xffffd
    80005d6a:	392080e7          	jalr	914(ra) # 800030f8 <argstr>
    80005d6e:	87aa                	mv	a5,a0
    return -1;
    80005d70:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d72:	0a07c963          	bltz	a5,80005e24 <sys_open+0xe4>

  begin_op();
    80005d76:	fffff097          	auipc	ra,0xfffff
    80005d7a:	9ce080e7          	jalr	-1586(ra) # 80004744 <begin_op>

  if(omode & O_CREATE){
    80005d7e:	f4c42783          	lw	a5,-180(s0)
    80005d82:	2007f793          	andi	a5,a5,512
    80005d86:	cfc5                	beqz	a5,80005e3e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005d88:	4681                	li	a3,0
    80005d8a:	4601                	li	a2,0
    80005d8c:	4589                	li	a1,2
    80005d8e:	f5040513          	addi	a0,s0,-176
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	950080e7          	jalr	-1712(ra) # 800056e2 <create>
    80005d9a:	84aa                	mv	s1,a0
    if(ip == 0){
    80005d9c:	c959                	beqz	a0,80005e32 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005d9e:	04449703          	lh	a4,68(s1)
    80005da2:	478d                	li	a5,3
    80005da4:	00f71763          	bne	a4,a5,80005db2 <sys_open+0x72>
    80005da8:	0464d703          	lhu	a4,70(s1)
    80005dac:	47a5                	li	a5,9
    80005dae:	0ce7ed63          	bltu	a5,a4,80005e88 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005db2:	fffff097          	auipc	ra,0xfffff
    80005db6:	d9e080e7          	jalr	-610(ra) # 80004b50 <filealloc>
    80005dba:	89aa                	mv	s3,a0
    80005dbc:	10050363          	beqz	a0,80005ec2 <sys_open+0x182>
    80005dc0:	00000097          	auipc	ra,0x0
    80005dc4:	8e0080e7          	jalr	-1824(ra) # 800056a0 <fdalloc>
    80005dc8:	892a                	mv	s2,a0
    80005dca:	0e054763          	bltz	a0,80005eb8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005dce:	04449703          	lh	a4,68(s1)
    80005dd2:	478d                	li	a5,3
    80005dd4:	0cf70563          	beq	a4,a5,80005e9e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005dd8:	4789                	li	a5,2
    80005dda:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005dde:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005de2:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005de6:	f4c42783          	lw	a5,-180(s0)
    80005dea:	0017c713          	xori	a4,a5,1
    80005dee:	8b05                	andi	a4,a4,1
    80005df0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005df4:	0037f713          	andi	a4,a5,3
    80005df8:	00e03733          	snez	a4,a4
    80005dfc:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005e00:	4007f793          	andi	a5,a5,1024
    80005e04:	c791                	beqz	a5,80005e10 <sys_open+0xd0>
    80005e06:	04449703          	lh	a4,68(s1)
    80005e0a:	4789                	li	a5,2
    80005e0c:	0af70063          	beq	a4,a5,80005eac <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005e10:	8526                	mv	a0,s1
    80005e12:	ffffe097          	auipc	ra,0xffffe
    80005e16:	028080e7          	jalr	40(ra) # 80003e3a <iunlock>
  end_op();
    80005e1a:	fffff097          	auipc	ra,0xfffff
    80005e1e:	9a8080e7          	jalr	-1624(ra) # 800047c2 <end_op>

  return fd;
    80005e22:	854a                	mv	a0,s2
}
    80005e24:	70ea                	ld	ra,184(sp)
    80005e26:	744a                	ld	s0,176(sp)
    80005e28:	74aa                	ld	s1,168(sp)
    80005e2a:	790a                	ld	s2,160(sp)
    80005e2c:	69ea                	ld	s3,152(sp)
    80005e2e:	6129                	addi	sp,sp,192
    80005e30:	8082                	ret
      end_op();
    80005e32:	fffff097          	auipc	ra,0xfffff
    80005e36:	990080e7          	jalr	-1648(ra) # 800047c2 <end_op>
      return -1;
    80005e3a:	557d                	li	a0,-1
    80005e3c:	b7e5                	j	80005e24 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005e3e:	f5040513          	addi	a0,s0,-176
    80005e42:	ffffe097          	auipc	ra,0xffffe
    80005e46:	6e2080e7          	jalr	1762(ra) # 80004524 <namei>
    80005e4a:	84aa                	mv	s1,a0
    80005e4c:	c905                	beqz	a0,80005e7c <sys_open+0x13c>
    ilock(ip);
    80005e4e:	ffffe097          	auipc	ra,0xffffe
    80005e52:	f2a080e7          	jalr	-214(ra) # 80003d78 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005e56:	04449703          	lh	a4,68(s1)
    80005e5a:	4785                	li	a5,1
    80005e5c:	f4f711e3          	bne	a4,a5,80005d9e <sys_open+0x5e>
    80005e60:	f4c42783          	lw	a5,-180(s0)
    80005e64:	d7b9                	beqz	a5,80005db2 <sys_open+0x72>
      iunlockput(ip);
    80005e66:	8526                	mv	a0,s1
    80005e68:	ffffe097          	auipc	ra,0xffffe
    80005e6c:	172080e7          	jalr	370(ra) # 80003fda <iunlockput>
      end_op();
    80005e70:	fffff097          	auipc	ra,0xfffff
    80005e74:	952080e7          	jalr	-1710(ra) # 800047c2 <end_op>
      return -1;
    80005e78:	557d                	li	a0,-1
    80005e7a:	b76d                	j	80005e24 <sys_open+0xe4>
      end_op();
    80005e7c:	fffff097          	auipc	ra,0xfffff
    80005e80:	946080e7          	jalr	-1722(ra) # 800047c2 <end_op>
      return -1;
    80005e84:	557d                	li	a0,-1
    80005e86:	bf79                	j	80005e24 <sys_open+0xe4>
    iunlockput(ip);
    80005e88:	8526                	mv	a0,s1
    80005e8a:	ffffe097          	auipc	ra,0xffffe
    80005e8e:	150080e7          	jalr	336(ra) # 80003fda <iunlockput>
    end_op();
    80005e92:	fffff097          	auipc	ra,0xfffff
    80005e96:	930080e7          	jalr	-1744(ra) # 800047c2 <end_op>
    return -1;
    80005e9a:	557d                	li	a0,-1
    80005e9c:	b761                	j	80005e24 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005e9e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005ea2:	04649783          	lh	a5,70(s1)
    80005ea6:	02f99223          	sh	a5,36(s3)
    80005eaa:	bf25                	j	80005de2 <sys_open+0xa2>
    itrunc(ip);
    80005eac:	8526                	mv	a0,s1
    80005eae:	ffffe097          	auipc	ra,0xffffe
    80005eb2:	fd8080e7          	jalr	-40(ra) # 80003e86 <itrunc>
    80005eb6:	bfa9                	j	80005e10 <sys_open+0xd0>
      fileclose(f);
    80005eb8:	854e                	mv	a0,s3
    80005eba:	fffff097          	auipc	ra,0xfffff
    80005ebe:	d52080e7          	jalr	-686(ra) # 80004c0c <fileclose>
    iunlockput(ip);
    80005ec2:	8526                	mv	a0,s1
    80005ec4:	ffffe097          	auipc	ra,0xffffe
    80005ec8:	116080e7          	jalr	278(ra) # 80003fda <iunlockput>
    end_op();
    80005ecc:	fffff097          	auipc	ra,0xfffff
    80005ed0:	8f6080e7          	jalr	-1802(ra) # 800047c2 <end_op>
    return -1;
    80005ed4:	557d                	li	a0,-1
    80005ed6:	b7b9                	j	80005e24 <sys_open+0xe4>

0000000080005ed8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005ed8:	7175                	addi	sp,sp,-144
    80005eda:	e506                	sd	ra,136(sp)
    80005edc:	e122                	sd	s0,128(sp)
    80005ede:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005ee0:	fffff097          	auipc	ra,0xfffff
    80005ee4:	864080e7          	jalr	-1948(ra) # 80004744 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005ee8:	08000613          	li	a2,128
    80005eec:	f7040593          	addi	a1,s0,-144
    80005ef0:	4501                	li	a0,0
    80005ef2:	ffffd097          	auipc	ra,0xffffd
    80005ef6:	206080e7          	jalr	518(ra) # 800030f8 <argstr>
    80005efa:	02054963          	bltz	a0,80005f2c <sys_mkdir+0x54>
    80005efe:	4681                	li	a3,0
    80005f00:	4601                	li	a2,0
    80005f02:	4585                	li	a1,1
    80005f04:	f7040513          	addi	a0,s0,-144
    80005f08:	fffff097          	auipc	ra,0xfffff
    80005f0c:	7da080e7          	jalr	2010(ra) # 800056e2 <create>
    80005f10:	cd11                	beqz	a0,80005f2c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f12:	ffffe097          	auipc	ra,0xffffe
    80005f16:	0c8080e7          	jalr	200(ra) # 80003fda <iunlockput>
  end_op();
    80005f1a:	fffff097          	auipc	ra,0xfffff
    80005f1e:	8a8080e7          	jalr	-1880(ra) # 800047c2 <end_op>
  return 0;
    80005f22:	4501                	li	a0,0
}
    80005f24:	60aa                	ld	ra,136(sp)
    80005f26:	640a                	ld	s0,128(sp)
    80005f28:	6149                	addi	sp,sp,144
    80005f2a:	8082                	ret
    end_op();
    80005f2c:	fffff097          	auipc	ra,0xfffff
    80005f30:	896080e7          	jalr	-1898(ra) # 800047c2 <end_op>
    return -1;
    80005f34:	557d                	li	a0,-1
    80005f36:	b7fd                	j	80005f24 <sys_mkdir+0x4c>

0000000080005f38 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005f38:	7135                	addi	sp,sp,-160
    80005f3a:	ed06                	sd	ra,152(sp)
    80005f3c:	e922                	sd	s0,144(sp)
    80005f3e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005f40:	fffff097          	auipc	ra,0xfffff
    80005f44:	804080e7          	jalr	-2044(ra) # 80004744 <begin_op>
  argint(1, &major);
    80005f48:	f6c40593          	addi	a1,s0,-148
    80005f4c:	4505                	li	a0,1
    80005f4e:	ffffd097          	auipc	ra,0xffffd
    80005f52:	16a080e7          	jalr	362(ra) # 800030b8 <argint>
  argint(2, &minor);
    80005f56:	f6840593          	addi	a1,s0,-152
    80005f5a:	4509                	li	a0,2
    80005f5c:	ffffd097          	auipc	ra,0xffffd
    80005f60:	15c080e7          	jalr	348(ra) # 800030b8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f64:	08000613          	li	a2,128
    80005f68:	f7040593          	addi	a1,s0,-144
    80005f6c:	4501                	li	a0,0
    80005f6e:	ffffd097          	auipc	ra,0xffffd
    80005f72:	18a080e7          	jalr	394(ra) # 800030f8 <argstr>
    80005f76:	02054b63          	bltz	a0,80005fac <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005f7a:	f6841683          	lh	a3,-152(s0)
    80005f7e:	f6c41603          	lh	a2,-148(s0)
    80005f82:	458d                	li	a1,3
    80005f84:	f7040513          	addi	a0,s0,-144
    80005f88:	fffff097          	auipc	ra,0xfffff
    80005f8c:	75a080e7          	jalr	1882(ra) # 800056e2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f90:	cd11                	beqz	a0,80005fac <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f92:	ffffe097          	auipc	ra,0xffffe
    80005f96:	048080e7          	jalr	72(ra) # 80003fda <iunlockput>
  end_op();
    80005f9a:	fffff097          	auipc	ra,0xfffff
    80005f9e:	828080e7          	jalr	-2008(ra) # 800047c2 <end_op>
  return 0;
    80005fa2:	4501                	li	a0,0
}
    80005fa4:	60ea                	ld	ra,152(sp)
    80005fa6:	644a                	ld	s0,144(sp)
    80005fa8:	610d                	addi	sp,sp,160
    80005faa:	8082                	ret
    end_op();
    80005fac:	fffff097          	auipc	ra,0xfffff
    80005fb0:	816080e7          	jalr	-2026(ra) # 800047c2 <end_op>
    return -1;
    80005fb4:	557d                	li	a0,-1
    80005fb6:	b7fd                	j	80005fa4 <sys_mknod+0x6c>

0000000080005fb8 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005fb8:	7135                	addi	sp,sp,-160
    80005fba:	ed06                	sd	ra,152(sp)
    80005fbc:	e922                	sd	s0,144(sp)
    80005fbe:	e526                	sd	s1,136(sp)
    80005fc0:	e14a                	sd	s2,128(sp)
    80005fc2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005fc4:	ffffc097          	auipc	ra,0xffffc
    80005fc8:	c3e080e7          	jalr	-962(ra) # 80001c02 <myproc>
    80005fcc:	892a                	mv	s2,a0
  
  begin_op();
    80005fce:	ffffe097          	auipc	ra,0xffffe
    80005fd2:	776080e7          	jalr	1910(ra) # 80004744 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005fd6:	08000613          	li	a2,128
    80005fda:	f6040593          	addi	a1,s0,-160
    80005fde:	4501                	li	a0,0
    80005fe0:	ffffd097          	auipc	ra,0xffffd
    80005fe4:	118080e7          	jalr	280(ra) # 800030f8 <argstr>
    80005fe8:	04054b63          	bltz	a0,8000603e <sys_chdir+0x86>
    80005fec:	f6040513          	addi	a0,s0,-160
    80005ff0:	ffffe097          	auipc	ra,0xffffe
    80005ff4:	534080e7          	jalr	1332(ra) # 80004524 <namei>
    80005ff8:	84aa                	mv	s1,a0
    80005ffa:	c131                	beqz	a0,8000603e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005ffc:	ffffe097          	auipc	ra,0xffffe
    80006000:	d7c080e7          	jalr	-644(ra) # 80003d78 <ilock>
  if(ip->type != T_DIR){
    80006004:	04449703          	lh	a4,68(s1)
    80006008:	4785                	li	a5,1
    8000600a:	04f71063          	bne	a4,a5,8000604a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000600e:	8526                	mv	a0,s1
    80006010:	ffffe097          	auipc	ra,0xffffe
    80006014:	e2a080e7          	jalr	-470(ra) # 80003e3a <iunlock>
  iput(p->cwd);
    80006018:	15093503          	ld	a0,336(s2)
    8000601c:	ffffe097          	auipc	ra,0xffffe
    80006020:	f16080e7          	jalr	-234(ra) # 80003f32 <iput>
  end_op();
    80006024:	ffffe097          	auipc	ra,0xffffe
    80006028:	79e080e7          	jalr	1950(ra) # 800047c2 <end_op>
  p->cwd = ip;
    8000602c:	14993823          	sd	s1,336(s2)
  return 0;
    80006030:	4501                	li	a0,0
}
    80006032:	60ea                	ld	ra,152(sp)
    80006034:	644a                	ld	s0,144(sp)
    80006036:	64aa                	ld	s1,136(sp)
    80006038:	690a                	ld	s2,128(sp)
    8000603a:	610d                	addi	sp,sp,160
    8000603c:	8082                	ret
    end_op();
    8000603e:	ffffe097          	auipc	ra,0xffffe
    80006042:	784080e7          	jalr	1924(ra) # 800047c2 <end_op>
    return -1;
    80006046:	557d                	li	a0,-1
    80006048:	b7ed                	j	80006032 <sys_chdir+0x7a>
    iunlockput(ip);
    8000604a:	8526                	mv	a0,s1
    8000604c:	ffffe097          	auipc	ra,0xffffe
    80006050:	f8e080e7          	jalr	-114(ra) # 80003fda <iunlockput>
    end_op();
    80006054:	ffffe097          	auipc	ra,0xffffe
    80006058:	76e080e7          	jalr	1902(ra) # 800047c2 <end_op>
    return -1;
    8000605c:	557d                	li	a0,-1
    8000605e:	bfd1                	j	80006032 <sys_chdir+0x7a>

0000000080006060 <sys_exec>:

uint64
sys_exec(void)
{
    80006060:	7145                	addi	sp,sp,-464
    80006062:	e786                	sd	ra,456(sp)
    80006064:	e3a2                	sd	s0,448(sp)
    80006066:	ff26                	sd	s1,440(sp)
    80006068:	fb4a                	sd	s2,432(sp)
    8000606a:	f74e                	sd	s3,424(sp)
    8000606c:	f352                	sd	s4,416(sp)
    8000606e:	ef56                	sd	s5,408(sp)
    80006070:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006072:	e3840593          	addi	a1,s0,-456
    80006076:	4505                	li	a0,1
    80006078:	ffffd097          	auipc	ra,0xffffd
    8000607c:	060080e7          	jalr	96(ra) # 800030d8 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006080:	08000613          	li	a2,128
    80006084:	f4040593          	addi	a1,s0,-192
    80006088:	4501                	li	a0,0
    8000608a:	ffffd097          	auipc	ra,0xffffd
    8000608e:	06e080e7          	jalr	110(ra) # 800030f8 <argstr>
    80006092:	87aa                	mv	a5,a0
    return -1;
    80006094:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006096:	0c07c363          	bltz	a5,8000615c <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000609a:	10000613          	li	a2,256
    8000609e:	4581                	li	a1,0
    800060a0:	e4040513          	addi	a0,s0,-448
    800060a4:	ffffb097          	auipc	ra,0xffffb
    800060a8:	da2080e7          	jalr	-606(ra) # 80000e46 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800060ac:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800060b0:	89a6                	mv	s3,s1
    800060b2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800060b4:	02000a13          	li	s4,32
    800060b8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800060bc:	00391513          	slli	a0,s2,0x3
    800060c0:	e3040593          	addi	a1,s0,-464
    800060c4:	e3843783          	ld	a5,-456(s0)
    800060c8:	953e                	add	a0,a0,a5
    800060ca:	ffffd097          	auipc	ra,0xffffd
    800060ce:	f50080e7          	jalr	-176(ra) # 8000301a <fetchaddr>
    800060d2:	02054a63          	bltz	a0,80006106 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800060d6:	e3043783          	ld	a5,-464(s0)
    800060da:	c3b9                	beqz	a5,80006120 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800060dc:	ffffb097          	auipc	ra,0xffffb
    800060e0:	b74080e7          	jalr	-1164(ra) # 80000c50 <kalloc>
    800060e4:	85aa                	mv	a1,a0
    800060e6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800060ea:	cd11                	beqz	a0,80006106 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800060ec:	6605                	lui	a2,0x1
    800060ee:	e3043503          	ld	a0,-464(s0)
    800060f2:	ffffd097          	auipc	ra,0xffffd
    800060f6:	f7a080e7          	jalr	-134(ra) # 8000306c <fetchstr>
    800060fa:	00054663          	bltz	a0,80006106 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800060fe:	0905                	addi	s2,s2,1
    80006100:	09a1                	addi	s3,s3,8
    80006102:	fb491be3          	bne	s2,s4,800060b8 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006106:	f4040913          	addi	s2,s0,-192
    8000610a:	6088                	ld	a0,0(s1)
    8000610c:	c539                	beqz	a0,8000615a <sys_exec+0xfa>
    kfree(argv[i]);
    8000610e:	ffffb097          	auipc	ra,0xffffb
    80006112:	96a080e7          	jalr	-1686(ra) # 80000a78 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006116:	04a1                	addi	s1,s1,8
    80006118:	ff2499e3          	bne	s1,s2,8000610a <sys_exec+0xaa>
  return -1;
    8000611c:	557d                	li	a0,-1
    8000611e:	a83d                	j	8000615c <sys_exec+0xfc>
      argv[i] = 0;
    80006120:	0a8e                	slli	s5,s5,0x3
    80006122:	fc0a8793          	addi	a5,s5,-64
    80006126:	00878ab3          	add	s5,a5,s0
    8000612a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000612e:	e4040593          	addi	a1,s0,-448
    80006132:	f4040513          	addi	a0,s0,-192
    80006136:	fffff097          	auipc	ra,0xfffff
    8000613a:	150080e7          	jalr	336(ra) # 80005286 <exec>
    8000613e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006140:	f4040993          	addi	s3,s0,-192
    80006144:	6088                	ld	a0,0(s1)
    80006146:	c901                	beqz	a0,80006156 <sys_exec+0xf6>
    kfree(argv[i]);
    80006148:	ffffb097          	auipc	ra,0xffffb
    8000614c:	930080e7          	jalr	-1744(ra) # 80000a78 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006150:	04a1                	addi	s1,s1,8
    80006152:	ff3499e3          	bne	s1,s3,80006144 <sys_exec+0xe4>
  return ret;
    80006156:	854a                	mv	a0,s2
    80006158:	a011                	j	8000615c <sys_exec+0xfc>
  return -1;
    8000615a:	557d                	li	a0,-1
}
    8000615c:	60be                	ld	ra,456(sp)
    8000615e:	641e                	ld	s0,448(sp)
    80006160:	74fa                	ld	s1,440(sp)
    80006162:	795a                	ld	s2,432(sp)
    80006164:	79ba                	ld	s3,424(sp)
    80006166:	7a1a                	ld	s4,416(sp)
    80006168:	6afa                	ld	s5,408(sp)
    8000616a:	6179                	addi	sp,sp,464
    8000616c:	8082                	ret

000000008000616e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000616e:	7139                	addi	sp,sp,-64
    80006170:	fc06                	sd	ra,56(sp)
    80006172:	f822                	sd	s0,48(sp)
    80006174:	f426                	sd	s1,40(sp)
    80006176:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006178:	ffffc097          	auipc	ra,0xffffc
    8000617c:	a8a080e7          	jalr	-1398(ra) # 80001c02 <myproc>
    80006180:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006182:	fd840593          	addi	a1,s0,-40
    80006186:	4501                	li	a0,0
    80006188:	ffffd097          	auipc	ra,0xffffd
    8000618c:	f50080e7          	jalr	-176(ra) # 800030d8 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006190:	fc840593          	addi	a1,s0,-56
    80006194:	fd040513          	addi	a0,s0,-48
    80006198:	fffff097          	auipc	ra,0xfffff
    8000619c:	da4080e7          	jalr	-604(ra) # 80004f3c <pipealloc>
    return -1;
    800061a0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800061a2:	0c054463          	bltz	a0,8000626a <sys_pipe+0xfc>
  fd0 = -1;
    800061a6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800061aa:	fd043503          	ld	a0,-48(s0)
    800061ae:	fffff097          	auipc	ra,0xfffff
    800061b2:	4f2080e7          	jalr	1266(ra) # 800056a0 <fdalloc>
    800061b6:	fca42223          	sw	a0,-60(s0)
    800061ba:	08054b63          	bltz	a0,80006250 <sys_pipe+0xe2>
    800061be:	fc843503          	ld	a0,-56(s0)
    800061c2:	fffff097          	auipc	ra,0xfffff
    800061c6:	4de080e7          	jalr	1246(ra) # 800056a0 <fdalloc>
    800061ca:	fca42023          	sw	a0,-64(s0)
    800061ce:	06054863          	bltz	a0,8000623e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800061d2:	4691                	li	a3,4
    800061d4:	fc440613          	addi	a2,s0,-60
    800061d8:	fd843583          	ld	a1,-40(s0)
    800061dc:	68a8                	ld	a0,80(s1)
    800061de:	ffffb097          	auipc	ra,0xffffb
    800061e2:	6d0080e7          	jalr	1744(ra) # 800018ae <copyout>
    800061e6:	02054063          	bltz	a0,80006206 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800061ea:	4691                	li	a3,4
    800061ec:	fc040613          	addi	a2,s0,-64
    800061f0:	fd843583          	ld	a1,-40(s0)
    800061f4:	0591                	addi	a1,a1,4
    800061f6:	68a8                	ld	a0,80(s1)
    800061f8:	ffffb097          	auipc	ra,0xffffb
    800061fc:	6b6080e7          	jalr	1718(ra) # 800018ae <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006200:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006202:	06055463          	bgez	a0,8000626a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006206:	fc442783          	lw	a5,-60(s0)
    8000620a:	07e9                	addi	a5,a5,26
    8000620c:	078e                	slli	a5,a5,0x3
    8000620e:	97a6                	add	a5,a5,s1
    80006210:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006214:	fc042783          	lw	a5,-64(s0)
    80006218:	07e9                	addi	a5,a5,26
    8000621a:	078e                	slli	a5,a5,0x3
    8000621c:	94be                	add	s1,s1,a5
    8000621e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006222:	fd043503          	ld	a0,-48(s0)
    80006226:	fffff097          	auipc	ra,0xfffff
    8000622a:	9e6080e7          	jalr	-1562(ra) # 80004c0c <fileclose>
    fileclose(wf);
    8000622e:	fc843503          	ld	a0,-56(s0)
    80006232:	fffff097          	auipc	ra,0xfffff
    80006236:	9da080e7          	jalr	-1574(ra) # 80004c0c <fileclose>
    return -1;
    8000623a:	57fd                	li	a5,-1
    8000623c:	a03d                	j	8000626a <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000623e:	fc442783          	lw	a5,-60(s0)
    80006242:	0007c763          	bltz	a5,80006250 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006246:	07e9                	addi	a5,a5,26
    80006248:	078e                	slli	a5,a5,0x3
    8000624a:	97a6                	add	a5,a5,s1
    8000624c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006250:	fd043503          	ld	a0,-48(s0)
    80006254:	fffff097          	auipc	ra,0xfffff
    80006258:	9b8080e7          	jalr	-1608(ra) # 80004c0c <fileclose>
    fileclose(wf);
    8000625c:	fc843503          	ld	a0,-56(s0)
    80006260:	fffff097          	auipc	ra,0xfffff
    80006264:	9ac080e7          	jalr	-1620(ra) # 80004c0c <fileclose>
    return -1;
    80006268:	57fd                	li	a5,-1
}
    8000626a:	853e                	mv	a0,a5
    8000626c:	70e2                	ld	ra,56(sp)
    8000626e:	7442                	ld	s0,48(sp)
    80006270:	74a2                	ld	s1,40(sp)
    80006272:	6121                	addi	sp,sp,64
    80006274:	8082                	ret
	...

0000000080006280 <kernelvec>:
    80006280:	7111                	addi	sp,sp,-256
    80006282:	e006                	sd	ra,0(sp)
    80006284:	e40a                	sd	sp,8(sp)
    80006286:	e80e                	sd	gp,16(sp)
    80006288:	ec12                	sd	tp,24(sp)
    8000628a:	f016                	sd	t0,32(sp)
    8000628c:	f41a                	sd	t1,40(sp)
    8000628e:	f81e                	sd	t2,48(sp)
    80006290:	fc22                	sd	s0,56(sp)
    80006292:	e0a6                	sd	s1,64(sp)
    80006294:	e4aa                	sd	a0,72(sp)
    80006296:	e8ae                	sd	a1,80(sp)
    80006298:	ecb2                	sd	a2,88(sp)
    8000629a:	f0b6                	sd	a3,96(sp)
    8000629c:	f4ba                	sd	a4,104(sp)
    8000629e:	f8be                	sd	a5,112(sp)
    800062a0:	fcc2                	sd	a6,120(sp)
    800062a2:	e146                	sd	a7,128(sp)
    800062a4:	e54a                	sd	s2,136(sp)
    800062a6:	e94e                	sd	s3,144(sp)
    800062a8:	ed52                	sd	s4,152(sp)
    800062aa:	f156                	sd	s5,160(sp)
    800062ac:	f55a                	sd	s6,168(sp)
    800062ae:	f95e                	sd	s7,176(sp)
    800062b0:	fd62                	sd	s8,184(sp)
    800062b2:	e1e6                	sd	s9,192(sp)
    800062b4:	e5ea                	sd	s10,200(sp)
    800062b6:	e9ee                	sd	s11,208(sp)
    800062b8:	edf2                	sd	t3,216(sp)
    800062ba:	f1f6                	sd	t4,224(sp)
    800062bc:	f5fa                	sd	t5,232(sp)
    800062be:	f9fe                	sd	t6,240(sp)
    800062c0:	c27fc0ef          	jal	ra,80002ee6 <kerneltrap>
    800062c4:	6082                	ld	ra,0(sp)
    800062c6:	6122                	ld	sp,8(sp)
    800062c8:	61c2                	ld	gp,16(sp)
    800062ca:	7282                	ld	t0,32(sp)
    800062cc:	7322                	ld	t1,40(sp)
    800062ce:	73c2                	ld	t2,48(sp)
    800062d0:	7462                	ld	s0,56(sp)
    800062d2:	6486                	ld	s1,64(sp)
    800062d4:	6526                	ld	a0,72(sp)
    800062d6:	65c6                	ld	a1,80(sp)
    800062d8:	6666                	ld	a2,88(sp)
    800062da:	7686                	ld	a3,96(sp)
    800062dc:	7726                	ld	a4,104(sp)
    800062de:	77c6                	ld	a5,112(sp)
    800062e0:	7866                	ld	a6,120(sp)
    800062e2:	688a                	ld	a7,128(sp)
    800062e4:	692a                	ld	s2,136(sp)
    800062e6:	69ca                	ld	s3,144(sp)
    800062e8:	6a6a                	ld	s4,152(sp)
    800062ea:	7a8a                	ld	s5,160(sp)
    800062ec:	7b2a                	ld	s6,168(sp)
    800062ee:	7bca                	ld	s7,176(sp)
    800062f0:	7c6a                	ld	s8,184(sp)
    800062f2:	6c8e                	ld	s9,192(sp)
    800062f4:	6d2e                	ld	s10,200(sp)
    800062f6:	6dce                	ld	s11,208(sp)
    800062f8:	6e6e                	ld	t3,216(sp)
    800062fa:	7e8e                	ld	t4,224(sp)
    800062fc:	7f2e                	ld	t5,232(sp)
    800062fe:	7fce                	ld	t6,240(sp)
    80006300:	6111                	addi	sp,sp,256
    80006302:	10200073          	sret
    80006306:	00000013          	nop
    8000630a:	00000013          	nop
    8000630e:	0001                	nop

0000000080006310 <timervec>:
    80006310:	34051573          	csrrw	a0,mscratch,a0
    80006314:	e10c                	sd	a1,0(a0)
    80006316:	e510                	sd	a2,8(a0)
    80006318:	e914                	sd	a3,16(a0)
    8000631a:	6d0c                	ld	a1,24(a0)
    8000631c:	7110                	ld	a2,32(a0)
    8000631e:	6194                	ld	a3,0(a1)
    80006320:	96b2                	add	a3,a3,a2
    80006322:	e194                	sd	a3,0(a1)
    80006324:	4589                	li	a1,2
    80006326:	14459073          	csrw	sip,a1
    8000632a:	6914                	ld	a3,16(a0)
    8000632c:	6510                	ld	a2,8(a0)
    8000632e:	610c                	ld	a1,0(a0)
    80006330:	34051573          	csrrw	a0,mscratch,a0
    80006334:	30200073          	mret
	...

000000008000633a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000633a:	1141                	addi	sp,sp,-16
    8000633c:	e422                	sd	s0,8(sp)
    8000633e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006340:	0c0007b7          	lui	a5,0xc000
    80006344:	4705                	li	a4,1
    80006346:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006348:	c3d8                	sw	a4,4(a5)
}
    8000634a:	6422                	ld	s0,8(sp)
    8000634c:	0141                	addi	sp,sp,16
    8000634e:	8082                	ret

0000000080006350 <plicinithart>:

void
plicinithart(void)
{
    80006350:	1141                	addi	sp,sp,-16
    80006352:	e406                	sd	ra,8(sp)
    80006354:	e022                	sd	s0,0(sp)
    80006356:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006358:	ffffc097          	auipc	ra,0xffffc
    8000635c:	87e080e7          	jalr	-1922(ra) # 80001bd6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006360:	0085171b          	slliw	a4,a0,0x8
    80006364:	0c0027b7          	lui	a5,0xc002
    80006368:	97ba                	add	a5,a5,a4
    8000636a:	40200713          	li	a4,1026
    8000636e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006372:	00d5151b          	slliw	a0,a0,0xd
    80006376:	0c2017b7          	lui	a5,0xc201
    8000637a:	97aa                	add	a5,a5,a0
    8000637c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006380:	60a2                	ld	ra,8(sp)
    80006382:	6402                	ld	s0,0(sp)
    80006384:	0141                	addi	sp,sp,16
    80006386:	8082                	ret

0000000080006388 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006388:	1141                	addi	sp,sp,-16
    8000638a:	e406                	sd	ra,8(sp)
    8000638c:	e022                	sd	s0,0(sp)
    8000638e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006390:	ffffc097          	auipc	ra,0xffffc
    80006394:	846080e7          	jalr	-1978(ra) # 80001bd6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006398:	00d5151b          	slliw	a0,a0,0xd
    8000639c:	0c2017b7          	lui	a5,0xc201
    800063a0:	97aa                	add	a5,a5,a0
  return irq;
}
    800063a2:	43c8                	lw	a0,4(a5)
    800063a4:	60a2                	ld	ra,8(sp)
    800063a6:	6402                	ld	s0,0(sp)
    800063a8:	0141                	addi	sp,sp,16
    800063aa:	8082                	ret

00000000800063ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800063ac:	1101                	addi	sp,sp,-32
    800063ae:	ec06                	sd	ra,24(sp)
    800063b0:	e822                	sd	s0,16(sp)
    800063b2:	e426                	sd	s1,8(sp)
    800063b4:	1000                	addi	s0,sp,32
    800063b6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800063b8:	ffffc097          	auipc	ra,0xffffc
    800063bc:	81e080e7          	jalr	-2018(ra) # 80001bd6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800063c0:	00d5151b          	slliw	a0,a0,0xd
    800063c4:	0c2017b7          	lui	a5,0xc201
    800063c8:	97aa                	add	a5,a5,a0
    800063ca:	c3c4                	sw	s1,4(a5)
}
    800063cc:	60e2                	ld	ra,24(sp)
    800063ce:	6442                	ld	s0,16(sp)
    800063d0:	64a2                	ld	s1,8(sp)
    800063d2:	6105                	addi	sp,sp,32
    800063d4:	8082                	ret

00000000800063d6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800063d6:	1141                	addi	sp,sp,-16
    800063d8:	e406                	sd	ra,8(sp)
    800063da:	e022                	sd	s0,0(sp)
    800063dc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800063de:	479d                	li	a5,7
    800063e0:	04a7cc63          	blt	a5,a0,80006438 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800063e4:	0023c797          	auipc	a5,0x23c
    800063e8:	29478793          	addi	a5,a5,660 # 80242678 <disk>
    800063ec:	97aa                	add	a5,a5,a0
    800063ee:	0187c783          	lbu	a5,24(a5)
    800063f2:	ebb9                	bnez	a5,80006448 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800063f4:	00451693          	slli	a3,a0,0x4
    800063f8:	0023c797          	auipc	a5,0x23c
    800063fc:	28078793          	addi	a5,a5,640 # 80242678 <disk>
    80006400:	6398                	ld	a4,0(a5)
    80006402:	9736                	add	a4,a4,a3
    80006404:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80006408:	6398                	ld	a4,0(a5)
    8000640a:	9736                	add	a4,a4,a3
    8000640c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006410:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006414:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006418:	97aa                	add	a5,a5,a0
    8000641a:	4705                	li	a4,1
    8000641c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006420:	0023c517          	auipc	a0,0x23c
    80006424:	27050513          	addi	a0,a0,624 # 80242690 <disk+0x18>
    80006428:	ffffc097          	auipc	ra,0xffffc
    8000642c:	034080e7          	jalr	52(ra) # 8000245c <wakeup>
}
    80006430:	60a2                	ld	ra,8(sp)
    80006432:	6402                	ld	s0,0(sp)
    80006434:	0141                	addi	sp,sp,16
    80006436:	8082                	ret
    panic("free_desc 1");
    80006438:	00002517          	auipc	a0,0x2
    8000643c:	34850513          	addi	a0,a0,840 # 80008780 <syscalls+0x308>
    80006440:	ffffa097          	auipc	ra,0xffffa
    80006444:	100080e7          	jalr	256(ra) # 80000540 <panic>
    panic("free_desc 2");
    80006448:	00002517          	auipc	a0,0x2
    8000644c:	34850513          	addi	a0,a0,840 # 80008790 <syscalls+0x318>
    80006450:	ffffa097          	auipc	ra,0xffffa
    80006454:	0f0080e7          	jalr	240(ra) # 80000540 <panic>

0000000080006458 <virtio_disk_init>:
{
    80006458:	1101                	addi	sp,sp,-32
    8000645a:	ec06                	sd	ra,24(sp)
    8000645c:	e822                	sd	s0,16(sp)
    8000645e:	e426                	sd	s1,8(sp)
    80006460:	e04a                	sd	s2,0(sp)
    80006462:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006464:	00002597          	auipc	a1,0x2
    80006468:	33c58593          	addi	a1,a1,828 # 800087a0 <syscalls+0x328>
    8000646c:	0023c517          	auipc	a0,0x23c
    80006470:	33450513          	addi	a0,a0,820 # 802427a0 <disk+0x128>
    80006474:	ffffb097          	auipc	ra,0xffffb
    80006478:	846080e7          	jalr	-1978(ra) # 80000cba <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000647c:	100017b7          	lui	a5,0x10001
    80006480:	4398                	lw	a4,0(a5)
    80006482:	2701                	sext.w	a4,a4
    80006484:	747277b7          	lui	a5,0x74727
    80006488:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000648c:	14f71b63          	bne	a4,a5,800065e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006490:	100017b7          	lui	a5,0x10001
    80006494:	43dc                	lw	a5,4(a5)
    80006496:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006498:	4709                	li	a4,2
    8000649a:	14e79463          	bne	a5,a4,800065e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000649e:	100017b7          	lui	a5,0x10001
    800064a2:	479c                	lw	a5,8(a5)
    800064a4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800064a6:	12e79e63          	bne	a5,a4,800065e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800064aa:	100017b7          	lui	a5,0x10001
    800064ae:	47d8                	lw	a4,12(a5)
    800064b0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064b2:	554d47b7          	lui	a5,0x554d4
    800064b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800064ba:	12f71463          	bne	a4,a5,800065e2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800064be:	100017b7          	lui	a5,0x10001
    800064c2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800064c6:	4705                	li	a4,1
    800064c8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064ca:	470d                	li	a4,3
    800064cc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800064ce:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800064d0:	c7ffe6b7          	lui	a3,0xc7ffe
    800064d4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47dbbfa7>
    800064d8:	8f75                	and	a4,a4,a3
    800064da:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064dc:	472d                	li	a4,11
    800064de:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800064e0:	5bbc                	lw	a5,112(a5)
    800064e2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800064e6:	8ba1                	andi	a5,a5,8
    800064e8:	10078563          	beqz	a5,800065f2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800064ec:	100017b7          	lui	a5,0x10001
    800064f0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800064f4:	43fc                	lw	a5,68(a5)
    800064f6:	2781                	sext.w	a5,a5
    800064f8:	10079563          	bnez	a5,80006602 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800064fc:	100017b7          	lui	a5,0x10001
    80006500:	5bdc                	lw	a5,52(a5)
    80006502:	2781                	sext.w	a5,a5
  if(max == 0)
    80006504:	10078763          	beqz	a5,80006612 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80006508:	471d                	li	a4,7
    8000650a:	10f77c63          	bgeu	a4,a5,80006622 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000650e:	ffffa097          	auipc	ra,0xffffa
    80006512:	742080e7          	jalr	1858(ra) # 80000c50 <kalloc>
    80006516:	0023c497          	auipc	s1,0x23c
    8000651a:	16248493          	addi	s1,s1,354 # 80242678 <disk>
    8000651e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006520:	ffffa097          	auipc	ra,0xffffa
    80006524:	730080e7          	jalr	1840(ra) # 80000c50 <kalloc>
    80006528:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000652a:	ffffa097          	auipc	ra,0xffffa
    8000652e:	726080e7          	jalr	1830(ra) # 80000c50 <kalloc>
    80006532:	87aa                	mv	a5,a0
    80006534:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006536:	6088                	ld	a0,0(s1)
    80006538:	cd6d                	beqz	a0,80006632 <virtio_disk_init+0x1da>
    8000653a:	0023c717          	auipc	a4,0x23c
    8000653e:	14673703          	ld	a4,326(a4) # 80242680 <disk+0x8>
    80006542:	cb65                	beqz	a4,80006632 <virtio_disk_init+0x1da>
    80006544:	c7fd                	beqz	a5,80006632 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80006546:	6605                	lui	a2,0x1
    80006548:	4581                	li	a1,0
    8000654a:	ffffb097          	auipc	ra,0xffffb
    8000654e:	8fc080e7          	jalr	-1796(ra) # 80000e46 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006552:	0023c497          	auipc	s1,0x23c
    80006556:	12648493          	addi	s1,s1,294 # 80242678 <disk>
    8000655a:	6605                	lui	a2,0x1
    8000655c:	4581                	li	a1,0
    8000655e:	6488                	ld	a0,8(s1)
    80006560:	ffffb097          	auipc	ra,0xffffb
    80006564:	8e6080e7          	jalr	-1818(ra) # 80000e46 <memset>
  memset(disk.used, 0, PGSIZE);
    80006568:	6605                	lui	a2,0x1
    8000656a:	4581                	li	a1,0
    8000656c:	6888                	ld	a0,16(s1)
    8000656e:	ffffb097          	auipc	ra,0xffffb
    80006572:	8d8080e7          	jalr	-1832(ra) # 80000e46 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006576:	100017b7          	lui	a5,0x10001
    8000657a:	4721                	li	a4,8
    8000657c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000657e:	4098                	lw	a4,0(s1)
    80006580:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006584:	40d8                	lw	a4,4(s1)
    80006586:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000658a:	6498                	ld	a4,8(s1)
    8000658c:	0007069b          	sext.w	a3,a4
    80006590:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006594:	9701                	srai	a4,a4,0x20
    80006596:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000659a:	6898                	ld	a4,16(s1)
    8000659c:	0007069b          	sext.w	a3,a4
    800065a0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800065a4:	9701                	srai	a4,a4,0x20
    800065a6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800065aa:	4705                	li	a4,1
    800065ac:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800065ae:	00e48c23          	sb	a4,24(s1)
    800065b2:	00e48ca3          	sb	a4,25(s1)
    800065b6:	00e48d23          	sb	a4,26(s1)
    800065ba:	00e48da3          	sb	a4,27(s1)
    800065be:	00e48e23          	sb	a4,28(s1)
    800065c2:	00e48ea3          	sb	a4,29(s1)
    800065c6:	00e48f23          	sb	a4,30(s1)
    800065ca:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800065ce:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800065d2:	0727a823          	sw	s2,112(a5)
}
    800065d6:	60e2                	ld	ra,24(sp)
    800065d8:	6442                	ld	s0,16(sp)
    800065da:	64a2                	ld	s1,8(sp)
    800065dc:	6902                	ld	s2,0(sp)
    800065de:	6105                	addi	sp,sp,32
    800065e0:	8082                	ret
    panic("could not find virtio disk");
    800065e2:	00002517          	auipc	a0,0x2
    800065e6:	1ce50513          	addi	a0,a0,462 # 800087b0 <syscalls+0x338>
    800065ea:	ffffa097          	auipc	ra,0xffffa
    800065ee:	f56080e7          	jalr	-170(ra) # 80000540 <panic>
    panic("virtio disk FEATURES_OK unset");
    800065f2:	00002517          	auipc	a0,0x2
    800065f6:	1de50513          	addi	a0,a0,478 # 800087d0 <syscalls+0x358>
    800065fa:	ffffa097          	auipc	ra,0xffffa
    800065fe:	f46080e7          	jalr	-186(ra) # 80000540 <panic>
    panic("virtio disk should not be ready");
    80006602:	00002517          	auipc	a0,0x2
    80006606:	1ee50513          	addi	a0,a0,494 # 800087f0 <syscalls+0x378>
    8000660a:	ffffa097          	auipc	ra,0xffffa
    8000660e:	f36080e7          	jalr	-202(ra) # 80000540 <panic>
    panic("virtio disk has no queue 0");
    80006612:	00002517          	auipc	a0,0x2
    80006616:	1fe50513          	addi	a0,a0,510 # 80008810 <syscalls+0x398>
    8000661a:	ffffa097          	auipc	ra,0xffffa
    8000661e:	f26080e7          	jalr	-218(ra) # 80000540 <panic>
    panic("virtio disk max queue too short");
    80006622:	00002517          	auipc	a0,0x2
    80006626:	20e50513          	addi	a0,a0,526 # 80008830 <syscalls+0x3b8>
    8000662a:	ffffa097          	auipc	ra,0xffffa
    8000662e:	f16080e7          	jalr	-234(ra) # 80000540 <panic>
    panic("virtio disk kalloc");
    80006632:	00002517          	auipc	a0,0x2
    80006636:	21e50513          	addi	a0,a0,542 # 80008850 <syscalls+0x3d8>
    8000663a:	ffffa097          	auipc	ra,0xffffa
    8000663e:	f06080e7          	jalr	-250(ra) # 80000540 <panic>

0000000080006642 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006642:	7119                	addi	sp,sp,-128
    80006644:	fc86                	sd	ra,120(sp)
    80006646:	f8a2                	sd	s0,112(sp)
    80006648:	f4a6                	sd	s1,104(sp)
    8000664a:	f0ca                	sd	s2,96(sp)
    8000664c:	ecce                	sd	s3,88(sp)
    8000664e:	e8d2                	sd	s4,80(sp)
    80006650:	e4d6                	sd	s5,72(sp)
    80006652:	e0da                	sd	s6,64(sp)
    80006654:	fc5e                	sd	s7,56(sp)
    80006656:	f862                	sd	s8,48(sp)
    80006658:	f466                	sd	s9,40(sp)
    8000665a:	f06a                	sd	s10,32(sp)
    8000665c:	ec6e                	sd	s11,24(sp)
    8000665e:	0100                	addi	s0,sp,128
    80006660:	8aaa                	mv	s5,a0
    80006662:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006664:	00c52d03          	lw	s10,12(a0)
    80006668:	001d1d1b          	slliw	s10,s10,0x1
    8000666c:	1d02                	slli	s10,s10,0x20
    8000666e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006672:	0023c517          	auipc	a0,0x23c
    80006676:	12e50513          	addi	a0,a0,302 # 802427a0 <disk+0x128>
    8000667a:	ffffa097          	auipc	ra,0xffffa
    8000667e:	6d0080e7          	jalr	1744(ra) # 80000d4a <acquire>
  for(int i = 0; i < 3; i++){
    80006682:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006684:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006686:	0023cb97          	auipc	s7,0x23c
    8000668a:	ff2b8b93          	addi	s7,s7,-14 # 80242678 <disk>
  for(int i = 0; i < 3; i++){
    8000668e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006690:	0023cc97          	auipc	s9,0x23c
    80006694:	110c8c93          	addi	s9,s9,272 # 802427a0 <disk+0x128>
    80006698:	a08d                	j	800066fa <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000669a:	00fb8733          	add	a4,s7,a5
    8000669e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800066a2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800066a4:	0207c563          	bltz	a5,800066ce <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800066a8:	2905                	addiw	s2,s2,1
    800066aa:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800066ac:	05690c63          	beq	s2,s6,80006704 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800066b0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800066b2:	0023c717          	auipc	a4,0x23c
    800066b6:	fc670713          	addi	a4,a4,-58 # 80242678 <disk>
    800066ba:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800066bc:	01874683          	lbu	a3,24(a4)
    800066c0:	fee9                	bnez	a3,8000669a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800066c2:	2785                	addiw	a5,a5,1
    800066c4:	0705                	addi	a4,a4,1
    800066c6:	fe979be3          	bne	a5,s1,800066bc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800066ca:	57fd                	li	a5,-1
    800066cc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800066ce:	01205d63          	blez	s2,800066e8 <virtio_disk_rw+0xa6>
    800066d2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800066d4:	000a2503          	lw	a0,0(s4)
    800066d8:	00000097          	auipc	ra,0x0
    800066dc:	cfe080e7          	jalr	-770(ra) # 800063d6 <free_desc>
      for(int j = 0; j < i; j++)
    800066e0:	2d85                	addiw	s11,s11,1
    800066e2:	0a11                	addi	s4,s4,4
    800066e4:	ff2d98e3          	bne	s11,s2,800066d4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800066e8:	85e6                	mv	a1,s9
    800066ea:	0023c517          	auipc	a0,0x23c
    800066ee:	fa650513          	addi	a0,a0,-90 # 80242690 <disk+0x18>
    800066f2:	ffffc097          	auipc	ra,0xffffc
    800066f6:	d06080e7          	jalr	-762(ra) # 800023f8 <sleep>
  for(int i = 0; i < 3; i++){
    800066fa:	f8040a13          	addi	s4,s0,-128
{
    800066fe:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006700:	894e                	mv	s2,s3
    80006702:	b77d                	j	800066b0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006704:	f8042503          	lw	a0,-128(s0)
    80006708:	00a50713          	addi	a4,a0,10
    8000670c:	0712                	slli	a4,a4,0x4

  if(write)
    8000670e:	0023c797          	auipc	a5,0x23c
    80006712:	f6a78793          	addi	a5,a5,-150 # 80242678 <disk>
    80006716:	00e786b3          	add	a3,a5,a4
    8000671a:	01803633          	snez	a2,s8
    8000671e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006720:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006724:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006728:	f6070613          	addi	a2,a4,-160
    8000672c:	6394                	ld	a3,0(a5)
    8000672e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006730:	00870593          	addi	a1,a4,8
    80006734:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006736:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006738:	0007b803          	ld	a6,0(a5)
    8000673c:	9642                	add	a2,a2,a6
    8000673e:	46c1                	li	a3,16
    80006740:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006742:	4585                	li	a1,1
    80006744:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80006748:	f8442683          	lw	a3,-124(s0)
    8000674c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006750:	0692                	slli	a3,a3,0x4
    80006752:	9836                	add	a6,a6,a3
    80006754:	058a8613          	addi	a2,s5,88
    80006758:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000675c:	0007b803          	ld	a6,0(a5)
    80006760:	96c2                	add	a3,a3,a6
    80006762:	40000613          	li	a2,1024
    80006766:	c690                	sw	a2,8(a3)
  if(write)
    80006768:	001c3613          	seqz	a2,s8
    8000676c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006770:	00166613          	ori	a2,a2,1
    80006774:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006778:	f8842603          	lw	a2,-120(s0)
    8000677c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006780:	00250693          	addi	a3,a0,2
    80006784:	0692                	slli	a3,a3,0x4
    80006786:	96be                	add	a3,a3,a5
    80006788:	58fd                	li	a7,-1
    8000678a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000678e:	0612                	slli	a2,a2,0x4
    80006790:	9832                	add	a6,a6,a2
    80006792:	f9070713          	addi	a4,a4,-112
    80006796:	973e                	add	a4,a4,a5
    80006798:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000679c:	6398                	ld	a4,0(a5)
    8000679e:	9732                	add	a4,a4,a2
    800067a0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800067a2:	4609                	li	a2,2
    800067a4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800067a8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800067ac:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800067b0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800067b4:	6794                	ld	a3,8(a5)
    800067b6:	0026d703          	lhu	a4,2(a3)
    800067ba:	8b1d                	andi	a4,a4,7
    800067bc:	0706                	slli	a4,a4,0x1
    800067be:	96ba                	add	a3,a3,a4
    800067c0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800067c4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800067c8:	6798                	ld	a4,8(a5)
    800067ca:	00275783          	lhu	a5,2(a4)
    800067ce:	2785                	addiw	a5,a5,1
    800067d0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800067d4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800067d8:	100017b7          	lui	a5,0x10001
    800067dc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800067e0:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800067e4:	0023c917          	auipc	s2,0x23c
    800067e8:	fbc90913          	addi	s2,s2,-68 # 802427a0 <disk+0x128>
  while(b->disk == 1) {
    800067ec:	4485                	li	s1,1
    800067ee:	00b79c63          	bne	a5,a1,80006806 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800067f2:	85ca                	mv	a1,s2
    800067f4:	8556                	mv	a0,s5
    800067f6:	ffffc097          	auipc	ra,0xffffc
    800067fa:	c02080e7          	jalr	-1022(ra) # 800023f8 <sleep>
  while(b->disk == 1) {
    800067fe:	004aa783          	lw	a5,4(s5)
    80006802:	fe9788e3          	beq	a5,s1,800067f2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006806:	f8042903          	lw	s2,-128(s0)
    8000680a:	00290713          	addi	a4,s2,2
    8000680e:	0712                	slli	a4,a4,0x4
    80006810:	0023c797          	auipc	a5,0x23c
    80006814:	e6878793          	addi	a5,a5,-408 # 80242678 <disk>
    80006818:	97ba                	add	a5,a5,a4
    8000681a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000681e:	0023c997          	auipc	s3,0x23c
    80006822:	e5a98993          	addi	s3,s3,-422 # 80242678 <disk>
    80006826:	00491713          	slli	a4,s2,0x4
    8000682a:	0009b783          	ld	a5,0(s3)
    8000682e:	97ba                	add	a5,a5,a4
    80006830:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006834:	854a                	mv	a0,s2
    80006836:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000683a:	00000097          	auipc	ra,0x0
    8000683e:	b9c080e7          	jalr	-1124(ra) # 800063d6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006842:	8885                	andi	s1,s1,1
    80006844:	f0ed                	bnez	s1,80006826 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006846:	0023c517          	auipc	a0,0x23c
    8000684a:	f5a50513          	addi	a0,a0,-166 # 802427a0 <disk+0x128>
    8000684e:	ffffa097          	auipc	ra,0xffffa
    80006852:	5b0080e7          	jalr	1456(ra) # 80000dfe <release>
}
    80006856:	70e6                	ld	ra,120(sp)
    80006858:	7446                	ld	s0,112(sp)
    8000685a:	74a6                	ld	s1,104(sp)
    8000685c:	7906                	ld	s2,96(sp)
    8000685e:	69e6                	ld	s3,88(sp)
    80006860:	6a46                	ld	s4,80(sp)
    80006862:	6aa6                	ld	s5,72(sp)
    80006864:	6b06                	ld	s6,64(sp)
    80006866:	7be2                	ld	s7,56(sp)
    80006868:	7c42                	ld	s8,48(sp)
    8000686a:	7ca2                	ld	s9,40(sp)
    8000686c:	7d02                	ld	s10,32(sp)
    8000686e:	6de2                	ld	s11,24(sp)
    80006870:	6109                	addi	sp,sp,128
    80006872:	8082                	ret

0000000080006874 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006874:	1101                	addi	sp,sp,-32
    80006876:	ec06                	sd	ra,24(sp)
    80006878:	e822                	sd	s0,16(sp)
    8000687a:	e426                	sd	s1,8(sp)
    8000687c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000687e:	0023c497          	auipc	s1,0x23c
    80006882:	dfa48493          	addi	s1,s1,-518 # 80242678 <disk>
    80006886:	0023c517          	auipc	a0,0x23c
    8000688a:	f1a50513          	addi	a0,a0,-230 # 802427a0 <disk+0x128>
    8000688e:	ffffa097          	auipc	ra,0xffffa
    80006892:	4bc080e7          	jalr	1212(ra) # 80000d4a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006896:	10001737          	lui	a4,0x10001
    8000689a:	533c                	lw	a5,96(a4)
    8000689c:	8b8d                	andi	a5,a5,3
    8000689e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800068a0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800068a4:	689c                	ld	a5,16(s1)
    800068a6:	0204d703          	lhu	a4,32(s1)
    800068aa:	0027d783          	lhu	a5,2(a5)
    800068ae:	04f70863          	beq	a4,a5,800068fe <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800068b2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800068b6:	6898                	ld	a4,16(s1)
    800068b8:	0204d783          	lhu	a5,32(s1)
    800068bc:	8b9d                	andi	a5,a5,7
    800068be:	078e                	slli	a5,a5,0x3
    800068c0:	97ba                	add	a5,a5,a4
    800068c2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800068c4:	00278713          	addi	a4,a5,2
    800068c8:	0712                	slli	a4,a4,0x4
    800068ca:	9726                	add	a4,a4,s1
    800068cc:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800068d0:	e721                	bnez	a4,80006918 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800068d2:	0789                	addi	a5,a5,2
    800068d4:	0792                	slli	a5,a5,0x4
    800068d6:	97a6                	add	a5,a5,s1
    800068d8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800068da:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800068de:	ffffc097          	auipc	ra,0xffffc
    800068e2:	b7e080e7          	jalr	-1154(ra) # 8000245c <wakeup>

    disk.used_idx += 1;
    800068e6:	0204d783          	lhu	a5,32(s1)
    800068ea:	2785                	addiw	a5,a5,1
    800068ec:	17c2                	slli	a5,a5,0x30
    800068ee:	93c1                	srli	a5,a5,0x30
    800068f0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800068f4:	6898                	ld	a4,16(s1)
    800068f6:	00275703          	lhu	a4,2(a4)
    800068fa:	faf71ce3          	bne	a4,a5,800068b2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800068fe:	0023c517          	auipc	a0,0x23c
    80006902:	ea250513          	addi	a0,a0,-350 # 802427a0 <disk+0x128>
    80006906:	ffffa097          	auipc	ra,0xffffa
    8000690a:	4f8080e7          	jalr	1272(ra) # 80000dfe <release>
}
    8000690e:	60e2                	ld	ra,24(sp)
    80006910:	6442                	ld	s0,16(sp)
    80006912:	64a2                	ld	s1,8(sp)
    80006914:	6105                	addi	sp,sp,32
    80006916:	8082                	ret
      panic("virtio_disk_intr status");
    80006918:	00002517          	auipc	a0,0x2
    8000691c:	f5050513          	addi	a0,a0,-176 # 80008868 <syscalls+0x3f0>
    80006920:	ffffa097          	auipc	ra,0xffffa
    80006924:	c20080e7          	jalr	-992(ra) # 80000540 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
