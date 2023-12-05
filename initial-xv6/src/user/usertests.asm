
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <textwrite>:
}

// check that writes to text segment fault
void
textwrite(char *s)
{ 
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
  wait(&xstatus);
  if(xstatus == -1)  // kernel killed child?
    exit(0);
  else
    exit(xstatus);
}
       6:	6422                	ld	s0,8(sp)
       8:	0141                	addi	sp,sp,16
       a:	8082                	ret

000000000000000c <copyinstr1>:
{
       c:	1141                	addi	sp,sp,-16
       e:	e406                	sd	ra,8(sp)
      10:	e022                	sd	s0,0(sp)
      12:	0800                	addi	s0,sp,16
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      14:	20100593          	li	a1,513
      18:	4505                	li	a0,1
      1a:	057e                	slli	a0,a0,0x1f
      1c:	00006097          	auipc	ra,0x6
      20:	a00080e7          	jalr	-1536(ra) # 5a1c <open>
    if(fd >= 0){
      24:	02055063          	bgez	a0,44 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      28:	20100593          	li	a1,513
      2c:	557d                	li	a0,-1
      2e:	00006097          	auipc	ra,0x6
      32:	9ee080e7          	jalr	-1554(ra) # 5a1c <open>
    uint64 addr = addrs[ai];
      36:	55fd                	li	a1,-1
    if(fd >= 0){
      38:	00055863          	bgez	a0,48 <copyinstr1+0x3c>
}
      3c:	60a2                	ld	ra,8(sp)
      3e:	6402                	ld	s0,0(sp)
      40:	0141                	addi	sp,sp,16
      42:	8082                	ret
    uint64 addr = addrs[ai];
      44:	4585                	li	a1,1
      46:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      48:	862a                	mv	a2,a0
      4a:	00006517          	auipc	a0,0x6
      4e:	ec650513          	addi	a0,a0,-314 # 5f10 <malloc+0xea>
      52:	00006097          	auipc	ra,0x6
      56:	d1c080e7          	jalr	-740(ra) # 5d6e <printf>
      exit(1);
      5a:	4505                	li	a0,1
      5c:	00006097          	auipc	ra,0x6
      60:	980080e7          	jalr	-1664(ra) # 59dc <exit>

0000000000000064 <writebig>:
{
      64:	1141                	addi	sp,sp,-16
      66:	e406                	sd	ra,8(sp)
      68:	e022                	sd	s0,0(sp)
      6a:	0800                	addi	s0,sp,16
  exit(0);
      6c:	4501                	li	a0,0
      6e:	00006097          	auipc	ra,0x6
      72:	96e080e7          	jalr	-1682(ra) # 59dc <exit>

0000000000000076 <bsstest>:
  for(i = 0; i < sizeof(uninit); i++){
      76:	0000a797          	auipc	a5,0xa
      7a:	4e278793          	addi	a5,a5,1250 # a558 <uninit>
      7e:	0000d697          	auipc	a3,0xd
      82:	bea68693          	addi	a3,a3,-1046 # cc68 <buf>
    if(uninit[i] != '\0'){
      86:	0007c703          	lbu	a4,0(a5)
      8a:	e709                	bnez	a4,94 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8c:	0785                	addi	a5,a5,1
      8e:	fed79ce3          	bne	a5,a3,86 <bsstest+0x10>
      92:	8082                	ret
{
      94:	1141                	addi	sp,sp,-16
      96:	e406                	sd	ra,8(sp)
      98:	e022                	sd	s0,0(sp)
      9a:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9c:	85aa                	mv	a1,a0
      9e:	00006517          	auipc	a0,0x6
      a2:	e9250513          	addi	a0,a0,-366 # 5f30 <malloc+0x10a>
      a6:	00006097          	auipc	ra,0x6
      aa:	cc8080e7          	jalr	-824(ra) # 5d6e <printf>
      exit(1);
      ae:	4505                	li	a0,1
      b0:	00006097          	auipc	ra,0x6
      b4:	92c080e7          	jalr	-1748(ra) # 59dc <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	e8250513          	addi	a0,a0,-382 # 5f48 <malloc+0x122>
      ce:	00006097          	auipc	ra,0x6
      d2:	94e080e7          	jalr	-1714(ra) # 5a1c <open>
  if(fd < 0){
      d6:	02054663          	bltz	a0,102 <opentest+0x4a>
  close(fd);
      da:	00006097          	auipc	ra,0x6
      de:	92a080e7          	jalr	-1750(ra) # 5a04 <close>
  fd = open("doesnotexist", 0);
      e2:	4581                	li	a1,0
      e4:	00006517          	auipc	a0,0x6
      e8:	e8450513          	addi	a0,a0,-380 # 5f68 <malloc+0x142>
      ec:	00006097          	auipc	ra,0x6
      f0:	930080e7          	jalr	-1744(ra) # 5a1c <open>
  if(fd >= 0){
      f4:	02055563          	bgez	a0,11e <opentest+0x66>
}
      f8:	60e2                	ld	ra,24(sp)
      fa:	6442                	ld	s0,16(sp)
      fc:	64a2                	ld	s1,8(sp)
      fe:	6105                	addi	sp,sp,32
     100:	8082                	ret
    printf("%s: open echo failed!\n", s);
     102:	85a6                	mv	a1,s1
     104:	00006517          	auipc	a0,0x6
     108:	e4c50513          	addi	a0,a0,-436 # 5f50 <malloc+0x12a>
     10c:	00006097          	auipc	ra,0x6
     110:	c62080e7          	jalr	-926(ra) # 5d6e <printf>
    exit(1);
     114:	4505                	li	a0,1
     116:	00006097          	auipc	ra,0x6
     11a:	8c6080e7          	jalr	-1850(ra) # 59dc <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     11e:	85a6                	mv	a1,s1
     120:	00006517          	auipc	a0,0x6
     124:	e5850513          	addi	a0,a0,-424 # 5f78 <malloc+0x152>
     128:	00006097          	auipc	ra,0x6
     12c:	c46080e7          	jalr	-954(ra) # 5d6e <printf>
    exit(1);
     130:	4505                	li	a0,1
     132:	00006097          	auipc	ra,0x6
     136:	8aa080e7          	jalr	-1878(ra) # 59dc <exit>

000000000000013a <truncate2>:
{
     13a:	7179                	addi	sp,sp,-48
     13c:	f406                	sd	ra,40(sp)
     13e:	f022                	sd	s0,32(sp)
     140:	ec26                	sd	s1,24(sp)
     142:	e84a                	sd	s2,16(sp)
     144:	e44e                	sd	s3,8(sp)
     146:	1800                	addi	s0,sp,48
     148:	89aa                	mv	s3,a0
  unlink("truncfile");
     14a:	00006517          	auipc	a0,0x6
     14e:	e5650513          	addi	a0,a0,-426 # 5fa0 <malloc+0x17a>
     152:	00006097          	auipc	ra,0x6
     156:	8da080e7          	jalr	-1830(ra) # 5a2c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     15a:	60100593          	li	a1,1537
     15e:	00006517          	auipc	a0,0x6
     162:	e4250513          	addi	a0,a0,-446 # 5fa0 <malloc+0x17a>
     166:	00006097          	auipc	ra,0x6
     16a:	8b6080e7          	jalr	-1866(ra) # 5a1c <open>
     16e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     170:	4611                	li	a2,4
     172:	00006597          	auipc	a1,0x6
     176:	e3e58593          	addi	a1,a1,-450 # 5fb0 <malloc+0x18a>
     17a:	00006097          	auipc	ra,0x6
     17e:	882080e7          	jalr	-1918(ra) # 59fc <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     182:	40100593          	li	a1,1025
     186:	00006517          	auipc	a0,0x6
     18a:	e1a50513          	addi	a0,a0,-486 # 5fa0 <malloc+0x17a>
     18e:	00006097          	auipc	ra,0x6
     192:	88e080e7          	jalr	-1906(ra) # 5a1c <open>
     196:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     198:	4605                	li	a2,1
     19a:	00006597          	auipc	a1,0x6
     19e:	e1e58593          	addi	a1,a1,-482 # 5fb8 <malloc+0x192>
     1a2:	8526                	mv	a0,s1
     1a4:	00006097          	auipc	ra,0x6
     1a8:	858080e7          	jalr	-1960(ra) # 59fc <write>
  if(n != -1){
     1ac:	57fd                	li	a5,-1
     1ae:	02f51b63          	bne	a0,a5,1e4 <truncate2+0xaa>
  unlink("truncfile");
     1b2:	00006517          	auipc	a0,0x6
     1b6:	dee50513          	addi	a0,a0,-530 # 5fa0 <malloc+0x17a>
     1ba:	00006097          	auipc	ra,0x6
     1be:	872080e7          	jalr	-1934(ra) # 5a2c <unlink>
  close(fd1);
     1c2:	8526                	mv	a0,s1
     1c4:	00006097          	auipc	ra,0x6
     1c8:	840080e7          	jalr	-1984(ra) # 5a04 <close>
  close(fd2);
     1cc:	854a                	mv	a0,s2
     1ce:	00006097          	auipc	ra,0x6
     1d2:	836080e7          	jalr	-1994(ra) # 5a04 <close>
}
     1d6:	70a2                	ld	ra,40(sp)
     1d8:	7402                	ld	s0,32(sp)
     1da:	64e2                	ld	s1,24(sp)
     1dc:	6942                	ld	s2,16(sp)
     1de:	69a2                	ld	s3,8(sp)
     1e0:	6145                	addi	sp,sp,48
     1e2:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1e4:	862a                	mv	a2,a0
     1e6:	85ce                	mv	a1,s3
     1e8:	00006517          	auipc	a0,0x6
     1ec:	dd850513          	addi	a0,a0,-552 # 5fc0 <malloc+0x19a>
     1f0:	00006097          	auipc	ra,0x6
     1f4:	b7e080e7          	jalr	-1154(ra) # 5d6e <printf>
    exit(1);
     1f8:	4505                	li	a0,1
     1fa:	00005097          	auipc	ra,0x5
     1fe:	7e2080e7          	jalr	2018(ra) # 59dc <exit>

0000000000000202 <createtest>:
{
     202:	7179                	addi	sp,sp,-48
     204:	f406                	sd	ra,40(sp)
     206:	f022                	sd	s0,32(sp)
     208:	ec26                	sd	s1,24(sp)
     20a:	e84a                	sd	s2,16(sp)
     20c:	1800                	addi	s0,sp,48
  name[0] = 'a';
     20e:	06100793          	li	a5,97
     212:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     216:	fc040d23          	sb	zero,-38(s0)
     21a:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     21e:	06400913          	li	s2,100
    name[1] = '0' + i;
     222:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     226:	20200593          	li	a1,514
     22a:	fd840513          	addi	a0,s0,-40
     22e:	00005097          	auipc	ra,0x5
     232:	7ee080e7          	jalr	2030(ra) # 5a1c <open>
    close(fd);
     236:	00005097          	auipc	ra,0x5
     23a:	7ce080e7          	jalr	1998(ra) # 5a04 <close>
  for(i = 0; i < N; i++){
     23e:	2485                	addiw	s1,s1,1
     240:	0ff4f493          	zext.b	s1,s1
     244:	fd249fe3          	bne	s1,s2,222 <createtest+0x20>
  name[0] = 'a';
     248:	06100793          	li	a5,97
     24c:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     250:	fc040d23          	sb	zero,-38(s0)
     254:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     258:	06400913          	li	s2,100
    name[1] = '0' + i;
     25c:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     260:	fd840513          	addi	a0,s0,-40
     264:	00005097          	auipc	ra,0x5
     268:	7c8080e7          	jalr	1992(ra) # 5a2c <unlink>
  for(i = 0; i < N; i++){
     26c:	2485                	addiw	s1,s1,1
     26e:	0ff4f493          	zext.b	s1,s1
     272:	ff2495e3          	bne	s1,s2,25c <createtest+0x5a>
}
     276:	70a2                	ld	ra,40(sp)
     278:	7402                	ld	s0,32(sp)
     27a:	64e2                	ld	s1,24(sp)
     27c:	6942                	ld	s2,16(sp)
     27e:	6145                	addi	sp,sp,48
     280:	8082                	ret

0000000000000282 <bigwrite>:
{
     282:	715d                	addi	sp,sp,-80
     284:	e486                	sd	ra,72(sp)
     286:	e0a2                	sd	s0,64(sp)
     288:	fc26                	sd	s1,56(sp)
     28a:	f84a                	sd	s2,48(sp)
     28c:	f44e                	sd	s3,40(sp)
     28e:	f052                	sd	s4,32(sp)
     290:	ec56                	sd	s5,24(sp)
     292:	e85a                	sd	s6,16(sp)
     294:	e45e                	sd	s7,8(sp)
     296:	0880                	addi	s0,sp,80
     298:	8baa                	mv	s7,a0
  unlink("bigwrite");
     29a:	00006517          	auipc	a0,0x6
     29e:	d4e50513          	addi	a0,a0,-690 # 5fe8 <malloc+0x1c2>
     2a2:	00005097          	auipc	ra,0x5
     2a6:	78a080e7          	jalr	1930(ra) # 5a2c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2aa:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ae:	00006a97          	auipc	s5,0x6
     2b2:	d3aa8a93          	addi	s5,s5,-710 # 5fe8 <malloc+0x1c2>
      int cc = write(fd, buf, sz);
     2b6:	0000da17          	auipc	s4,0xd
     2ba:	9b2a0a13          	addi	s4,s4,-1614 # cc68 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2be:	6b0d                	lui	s6,0x3
     2c0:	1c9b0b13          	addi	s6,s6,457 # 31c9 <exitiputtest+0x5b>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2c4:	20200593          	li	a1,514
     2c8:	8556                	mv	a0,s5
     2ca:	00005097          	auipc	ra,0x5
     2ce:	752080e7          	jalr	1874(ra) # 5a1c <open>
     2d2:	892a                	mv	s2,a0
    if(fd < 0){
     2d4:	04054d63          	bltz	a0,32e <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2d8:	8626                	mv	a2,s1
     2da:	85d2                	mv	a1,s4
     2dc:	00005097          	auipc	ra,0x5
     2e0:	720080e7          	jalr	1824(ra) # 59fc <write>
     2e4:	89aa                	mv	s3,a0
      if(cc != sz){
     2e6:	06a49263          	bne	s1,a0,34a <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2ea:	8626                	mv	a2,s1
     2ec:	85d2                	mv	a1,s4
     2ee:	854a                	mv	a0,s2
     2f0:	00005097          	auipc	ra,0x5
     2f4:	70c080e7          	jalr	1804(ra) # 59fc <write>
      if(cc != sz){
     2f8:	04951a63          	bne	a0,s1,34c <bigwrite+0xca>
    close(fd);
     2fc:	854a                	mv	a0,s2
     2fe:	00005097          	auipc	ra,0x5
     302:	706080e7          	jalr	1798(ra) # 5a04 <close>
    unlink("bigwrite");
     306:	8556                	mv	a0,s5
     308:	00005097          	auipc	ra,0x5
     30c:	724080e7          	jalr	1828(ra) # 5a2c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     310:	1d74849b          	addiw	s1,s1,471
     314:	fb6498e3          	bne	s1,s6,2c4 <bigwrite+0x42>
}
     318:	60a6                	ld	ra,72(sp)
     31a:	6406                	ld	s0,64(sp)
     31c:	74e2                	ld	s1,56(sp)
     31e:	7942                	ld	s2,48(sp)
     320:	79a2                	ld	s3,40(sp)
     322:	7a02                	ld	s4,32(sp)
     324:	6ae2                	ld	s5,24(sp)
     326:	6b42                	ld	s6,16(sp)
     328:	6ba2                	ld	s7,8(sp)
     32a:	6161                	addi	sp,sp,80
     32c:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     32e:	85de                	mv	a1,s7
     330:	00006517          	auipc	a0,0x6
     334:	cc850513          	addi	a0,a0,-824 # 5ff8 <malloc+0x1d2>
     338:	00006097          	auipc	ra,0x6
     33c:	a36080e7          	jalr	-1482(ra) # 5d6e <printf>
      exit(1);
     340:	4505                	li	a0,1
     342:	00005097          	auipc	ra,0x5
     346:	69a080e7          	jalr	1690(ra) # 59dc <exit>
      if(cc != sz){
     34a:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     34c:	86aa                	mv	a3,a0
     34e:	864e                	mv	a2,s3
     350:	85de                	mv	a1,s7
     352:	00006517          	auipc	a0,0x6
     356:	cc650513          	addi	a0,a0,-826 # 6018 <malloc+0x1f2>
     35a:	00006097          	auipc	ra,0x6
     35e:	a14080e7          	jalr	-1516(ra) # 5d6e <printf>
        exit(1);
     362:	4505                	li	a0,1
     364:	00005097          	auipc	ra,0x5
     368:	678080e7          	jalr	1656(ra) # 59dc <exit>

000000000000036c <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     36c:	7179                	addi	sp,sp,-48
     36e:	f406                	sd	ra,40(sp)
     370:	f022                	sd	s0,32(sp)
     372:	ec26                	sd	s1,24(sp)
     374:	e84a                	sd	s2,16(sp)
     376:	e44e                	sd	s3,8(sp)
     378:	e052                	sd	s4,0(sp)
     37a:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     37c:	00006517          	auipc	a0,0x6
     380:	cb450513          	addi	a0,a0,-844 # 6030 <malloc+0x20a>
     384:	00005097          	auipc	ra,0x5
     388:	6a8080e7          	jalr	1704(ra) # 5a2c <unlink>
     38c:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     390:	00006997          	auipc	s3,0x6
     394:	ca098993          	addi	s3,s3,-864 # 6030 <malloc+0x20a>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffL, 1);
     398:	5a7d                	li	s4,-1
     39a:	020a5a13          	srli	s4,s4,0x20
    int fd = open("junk", O_CREATE|O_WRONLY);
     39e:	20100593          	li	a1,513
     3a2:	854e                	mv	a0,s3
     3a4:	00005097          	auipc	ra,0x5
     3a8:	678080e7          	jalr	1656(ra) # 5a1c <open>
     3ac:	84aa                	mv	s1,a0
    if(fd < 0){
     3ae:	06054b63          	bltz	a0,424 <badwrite+0xb8>
    write(fd, (char*)0xffffffffL, 1);
     3b2:	4605                	li	a2,1
     3b4:	85d2                	mv	a1,s4
     3b6:	00005097          	auipc	ra,0x5
     3ba:	646080e7          	jalr	1606(ra) # 59fc <write>
    close(fd);
     3be:	8526                	mv	a0,s1
     3c0:	00005097          	auipc	ra,0x5
     3c4:	644080e7          	jalr	1604(ra) # 5a04 <close>
    unlink("junk");
     3c8:	854e                	mv	a0,s3
     3ca:	00005097          	auipc	ra,0x5
     3ce:	662080e7          	jalr	1634(ra) # 5a2c <unlink>
  for(int i = 0; i < assumed_free; i++){
     3d2:	397d                	addiw	s2,s2,-1
     3d4:	fc0915e3          	bnez	s2,39e <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3d8:	20100593          	li	a1,513
     3dc:	00006517          	auipc	a0,0x6
     3e0:	c5450513          	addi	a0,a0,-940 # 6030 <malloc+0x20a>
     3e4:	00005097          	auipc	ra,0x5
     3e8:	638080e7          	jalr	1592(ra) # 5a1c <open>
     3ec:	84aa                	mv	s1,a0
  if(fd < 0){
     3ee:	04054863          	bltz	a0,43e <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3f2:	4605                	li	a2,1
     3f4:	00006597          	auipc	a1,0x6
     3f8:	bc458593          	addi	a1,a1,-1084 # 5fb8 <malloc+0x192>
     3fc:	00005097          	auipc	ra,0x5
     400:	600080e7          	jalr	1536(ra) # 59fc <write>
     404:	4785                	li	a5,1
     406:	04f50963          	beq	a0,a5,458 <badwrite+0xec>
    printf("write failed\n");
     40a:	00006517          	auipc	a0,0x6
     40e:	c4650513          	addi	a0,a0,-954 # 6050 <malloc+0x22a>
     412:	00006097          	auipc	ra,0x6
     416:	95c080e7          	jalr	-1700(ra) # 5d6e <printf>
    exit(1);
     41a:	4505                	li	a0,1
     41c:	00005097          	auipc	ra,0x5
     420:	5c0080e7          	jalr	1472(ra) # 59dc <exit>
      printf("open junk failed\n");
     424:	00006517          	auipc	a0,0x6
     428:	c1450513          	addi	a0,a0,-1004 # 6038 <malloc+0x212>
     42c:	00006097          	auipc	ra,0x6
     430:	942080e7          	jalr	-1726(ra) # 5d6e <printf>
      exit(1);
     434:	4505                	li	a0,1
     436:	00005097          	auipc	ra,0x5
     43a:	5a6080e7          	jalr	1446(ra) # 59dc <exit>
    printf("open junk failed\n");
     43e:	00006517          	auipc	a0,0x6
     442:	bfa50513          	addi	a0,a0,-1030 # 6038 <malloc+0x212>
     446:	00006097          	auipc	ra,0x6
     44a:	928080e7          	jalr	-1752(ra) # 5d6e <printf>
    exit(1);
     44e:	4505                	li	a0,1
     450:	00005097          	auipc	ra,0x5
     454:	58c080e7          	jalr	1420(ra) # 59dc <exit>
  }
  close(fd);
     458:	8526                	mv	a0,s1
     45a:	00005097          	auipc	ra,0x5
     45e:	5aa080e7          	jalr	1450(ra) # 5a04 <close>
  unlink("junk");
     462:	00006517          	auipc	a0,0x6
     466:	bce50513          	addi	a0,a0,-1074 # 6030 <malloc+0x20a>
     46a:	00005097          	auipc	ra,0x5
     46e:	5c2080e7          	jalr	1474(ra) # 5a2c <unlink>

  exit(0);
     472:	4501                	li	a0,0
     474:	00005097          	auipc	ra,0x5
     478:	568080e7          	jalr	1384(ra) # 59dc <exit>

000000000000047c <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     47c:	715d                	addi	sp,sp,-80
     47e:	e486                	sd	ra,72(sp)
     480:	e0a2                	sd	s0,64(sp)
     482:	fc26                	sd	s1,56(sp)
     484:	f84a                	sd	s2,48(sp)
     486:	f44e                	sd	s3,40(sp)
     488:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     48a:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     48c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     490:	40000993          	li	s3,1024
    name[0] = 'z';
     494:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     498:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     49c:	41f4d71b          	sraiw	a4,s1,0x1f
     4a0:	01b7571b          	srliw	a4,a4,0x1b
     4a4:	009707bb          	addw	a5,a4,s1
     4a8:	4057d69b          	sraiw	a3,a5,0x5
     4ac:	0306869b          	addiw	a3,a3,48
     4b0:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4b4:	8bfd                	andi	a5,a5,31
     4b6:	9f99                	subw	a5,a5,a4
     4b8:	0307879b          	addiw	a5,a5,48
     4bc:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4c0:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4c4:	fb040513          	addi	a0,s0,-80
     4c8:	00005097          	auipc	ra,0x5
     4cc:	564080e7          	jalr	1380(ra) # 5a2c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4d0:	60200593          	li	a1,1538
     4d4:	fb040513          	addi	a0,s0,-80
     4d8:	00005097          	auipc	ra,0x5
     4dc:	544080e7          	jalr	1348(ra) # 5a1c <open>
    if(fd < 0){
     4e0:	00054963          	bltz	a0,4f2 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4e4:	00005097          	auipc	ra,0x5
     4e8:	520080e7          	jalr	1312(ra) # 5a04 <close>
  for(int i = 0; i < nzz; i++){
     4ec:	2485                	addiw	s1,s1,1
     4ee:	fb3493e3          	bne	s1,s3,494 <outofinodes+0x18>
     4f2:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4f4:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4f8:	40000993          	li	s3,1024
    name[0] = 'z';
     4fc:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     500:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     504:	41f4d71b          	sraiw	a4,s1,0x1f
     508:	01b7571b          	srliw	a4,a4,0x1b
     50c:	009707bb          	addw	a5,a4,s1
     510:	4057d69b          	sraiw	a3,a5,0x5
     514:	0306869b          	addiw	a3,a3,48
     518:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     51c:	8bfd                	andi	a5,a5,31
     51e:	9f99                	subw	a5,a5,a4
     520:	0307879b          	addiw	a5,a5,48
     524:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     528:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     52c:	fb040513          	addi	a0,s0,-80
     530:	00005097          	auipc	ra,0x5
     534:	4fc080e7          	jalr	1276(ra) # 5a2c <unlink>
  for(int i = 0; i < nzz; i++){
     538:	2485                	addiw	s1,s1,1
     53a:	fd3491e3          	bne	s1,s3,4fc <outofinodes+0x80>
  }
}
     53e:	60a6                	ld	ra,72(sp)
     540:	6406                	ld	s0,64(sp)
     542:	74e2                	ld	s1,56(sp)
     544:	7942                	ld	s2,48(sp)
     546:	79a2                	ld	s3,40(sp)
     548:	6161                	addi	sp,sp,80
     54a:	8082                	ret

000000000000054c <copyin>:
{
     54c:	715d                	addi	sp,sp,-80
     54e:	e486                	sd	ra,72(sp)
     550:	e0a2                	sd	s0,64(sp)
     552:	fc26                	sd	s1,56(sp)
     554:	f84a                	sd	s2,48(sp)
     556:	f44e                	sd	s3,40(sp)
     558:	f052                	sd	s4,32(sp)
     55a:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     55c:	4785                	li	a5,1
     55e:	07fe                	slli	a5,a5,0x1f
     560:	fcf43023          	sd	a5,-64(s0)
     564:	57fd                	li	a5,-1
     566:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     56a:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     56e:	00006a17          	auipc	s4,0x6
     572:	af2a0a13          	addi	s4,s4,-1294 # 6060 <malloc+0x23a>
    uint64 addr = addrs[ai];
     576:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     57a:	20100593          	li	a1,513
     57e:	8552                	mv	a0,s4
     580:	00005097          	auipc	ra,0x5
     584:	49c080e7          	jalr	1180(ra) # 5a1c <open>
     588:	84aa                	mv	s1,a0
    if(fd < 0){
     58a:	08054863          	bltz	a0,61a <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     58e:	6609                	lui	a2,0x2
     590:	85ce                	mv	a1,s3
     592:	00005097          	auipc	ra,0x5
     596:	46a080e7          	jalr	1130(ra) # 59fc <write>
    if(n >= 0){
     59a:	08055d63          	bgez	a0,634 <copyin+0xe8>
    close(fd);
     59e:	8526                	mv	a0,s1
     5a0:	00005097          	auipc	ra,0x5
     5a4:	464080e7          	jalr	1124(ra) # 5a04 <close>
    unlink("copyin1");
     5a8:	8552                	mv	a0,s4
     5aa:	00005097          	auipc	ra,0x5
     5ae:	482080e7          	jalr	1154(ra) # 5a2c <unlink>
    n = write(1, (char*)addr, 8192);
     5b2:	6609                	lui	a2,0x2
     5b4:	85ce                	mv	a1,s3
     5b6:	4505                	li	a0,1
     5b8:	00005097          	auipc	ra,0x5
     5bc:	444080e7          	jalr	1092(ra) # 59fc <write>
    if(n > 0){
     5c0:	08a04963          	bgtz	a0,652 <copyin+0x106>
    if(pipe(fds) < 0){
     5c4:	fb840513          	addi	a0,s0,-72
     5c8:	00005097          	auipc	ra,0x5
     5cc:	424080e7          	jalr	1060(ra) # 59ec <pipe>
     5d0:	0a054063          	bltz	a0,670 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5d4:	6609                	lui	a2,0x2
     5d6:	85ce                	mv	a1,s3
     5d8:	fbc42503          	lw	a0,-68(s0)
     5dc:	00005097          	auipc	ra,0x5
     5e0:	420080e7          	jalr	1056(ra) # 59fc <write>
    if(n > 0){
     5e4:	0aa04363          	bgtz	a0,68a <copyin+0x13e>
    close(fds[0]);
     5e8:	fb842503          	lw	a0,-72(s0)
     5ec:	00005097          	auipc	ra,0x5
     5f0:	418080e7          	jalr	1048(ra) # 5a04 <close>
    close(fds[1]);
     5f4:	fbc42503          	lw	a0,-68(s0)
     5f8:	00005097          	auipc	ra,0x5
     5fc:	40c080e7          	jalr	1036(ra) # 5a04 <close>
  for(int ai = 0; ai < 2; ai++){
     600:	0921                	addi	s2,s2,8
     602:	fd040793          	addi	a5,s0,-48
     606:	f6f918e3          	bne	s2,a5,576 <copyin+0x2a>
}
     60a:	60a6                	ld	ra,72(sp)
     60c:	6406                	ld	s0,64(sp)
     60e:	74e2                	ld	s1,56(sp)
     610:	7942                	ld	s2,48(sp)
     612:	79a2                	ld	s3,40(sp)
     614:	7a02                	ld	s4,32(sp)
     616:	6161                	addi	sp,sp,80
     618:	8082                	ret
      printf("open(copyin1) failed\n");
     61a:	00006517          	auipc	a0,0x6
     61e:	a4e50513          	addi	a0,a0,-1458 # 6068 <malloc+0x242>
     622:	00005097          	auipc	ra,0x5
     626:	74c080e7          	jalr	1868(ra) # 5d6e <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	3b0080e7          	jalr	944(ra) # 59dc <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	a4850513          	addi	a0,a0,-1464 # 6080 <malloc+0x25a>
     640:	00005097          	auipc	ra,0x5
     644:	72e080e7          	jalr	1838(ra) # 5d6e <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	392080e7          	jalr	914(ra) # 59dc <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     652:	862a                	mv	a2,a0
     654:	85ce                	mv	a1,s3
     656:	00006517          	auipc	a0,0x6
     65a:	a5a50513          	addi	a0,a0,-1446 # 60b0 <malloc+0x28a>
     65e:	00005097          	auipc	ra,0x5
     662:	710080e7          	jalr	1808(ra) # 5d6e <printf>
      exit(1);
     666:	4505                	li	a0,1
     668:	00005097          	auipc	ra,0x5
     66c:	374080e7          	jalr	884(ra) # 59dc <exit>
      printf("pipe() failed\n");
     670:	00006517          	auipc	a0,0x6
     674:	a7050513          	addi	a0,a0,-1424 # 60e0 <malloc+0x2ba>
     678:	00005097          	auipc	ra,0x5
     67c:	6f6080e7          	jalr	1782(ra) # 5d6e <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	35a080e7          	jalr	858(ra) # 59dc <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     68a:	862a                	mv	a2,a0
     68c:	85ce                	mv	a1,s3
     68e:	00006517          	auipc	a0,0x6
     692:	a6250513          	addi	a0,a0,-1438 # 60f0 <malloc+0x2ca>
     696:	00005097          	auipc	ra,0x5
     69a:	6d8080e7          	jalr	1752(ra) # 5d6e <printf>
      exit(1);
     69e:	4505                	li	a0,1
     6a0:	00005097          	auipc	ra,0x5
     6a4:	33c080e7          	jalr	828(ra) # 59dc <exit>

00000000000006a8 <copyout>:
{
     6a8:	711d                	addi	sp,sp,-96
     6aa:	ec86                	sd	ra,88(sp)
     6ac:	e8a2                	sd	s0,80(sp)
     6ae:	e4a6                	sd	s1,72(sp)
     6b0:	e0ca                	sd	s2,64(sp)
     6b2:	fc4e                	sd	s3,56(sp)
     6b4:	f852                	sd	s4,48(sp)
     6b6:	f456                	sd	s5,40(sp)
     6b8:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     6ba:	4785                	li	a5,1
     6bc:	07fe                	slli	a5,a5,0x1f
     6be:	faf43823          	sd	a5,-80(s0)
     6c2:	57fd                	li	a5,-1
     6c4:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6c8:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6cc:	00006a17          	auipc	s4,0x6
     6d0:	a54a0a13          	addi	s4,s4,-1452 # 6120 <malloc+0x2fa>
    n = write(fds[1], "x", 1);
     6d4:	00006a97          	auipc	s5,0x6
     6d8:	8e4a8a93          	addi	s5,s5,-1820 # 5fb8 <malloc+0x192>
    uint64 addr = addrs[ai];
     6dc:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6e0:	4581                	li	a1,0
     6e2:	8552                	mv	a0,s4
     6e4:	00005097          	auipc	ra,0x5
     6e8:	338080e7          	jalr	824(ra) # 5a1c <open>
     6ec:	84aa                	mv	s1,a0
    if(fd < 0){
     6ee:	08054663          	bltz	a0,77a <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6f2:	6609                	lui	a2,0x2
     6f4:	85ce                	mv	a1,s3
     6f6:	00005097          	auipc	ra,0x5
     6fa:	2fe080e7          	jalr	766(ra) # 59f4 <read>
    if(n > 0){
     6fe:	08a04b63          	bgtz	a0,794 <copyout+0xec>
    close(fd);
     702:	8526                	mv	a0,s1
     704:	00005097          	auipc	ra,0x5
     708:	300080e7          	jalr	768(ra) # 5a04 <close>
    if(pipe(fds) < 0){
     70c:	fa840513          	addi	a0,s0,-88
     710:	00005097          	auipc	ra,0x5
     714:	2dc080e7          	jalr	732(ra) # 59ec <pipe>
     718:	08054d63          	bltz	a0,7b2 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     71c:	4605                	li	a2,1
     71e:	85d6                	mv	a1,s5
     720:	fac42503          	lw	a0,-84(s0)
     724:	00005097          	auipc	ra,0x5
     728:	2d8080e7          	jalr	728(ra) # 59fc <write>
    if(n != 1){
     72c:	4785                	li	a5,1
     72e:	08f51f63          	bne	a0,a5,7cc <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     732:	6609                	lui	a2,0x2
     734:	85ce                	mv	a1,s3
     736:	fa842503          	lw	a0,-88(s0)
     73a:	00005097          	auipc	ra,0x5
     73e:	2ba080e7          	jalr	698(ra) # 59f4 <read>
    if(n > 0){
     742:	0aa04263          	bgtz	a0,7e6 <copyout+0x13e>
    close(fds[0]);
     746:	fa842503          	lw	a0,-88(s0)
     74a:	00005097          	auipc	ra,0x5
     74e:	2ba080e7          	jalr	698(ra) # 5a04 <close>
    close(fds[1]);
     752:	fac42503          	lw	a0,-84(s0)
     756:	00005097          	auipc	ra,0x5
     75a:	2ae080e7          	jalr	686(ra) # 5a04 <close>
  for(int ai = 0; ai < 2; ai++){
     75e:	0921                	addi	s2,s2,8
     760:	fc040793          	addi	a5,s0,-64
     764:	f6f91ce3          	bne	s2,a5,6dc <copyout+0x34>
}
     768:	60e6                	ld	ra,88(sp)
     76a:	6446                	ld	s0,80(sp)
     76c:	64a6                	ld	s1,72(sp)
     76e:	6906                	ld	s2,64(sp)
     770:	79e2                	ld	s3,56(sp)
     772:	7a42                	ld	s4,48(sp)
     774:	7aa2                	ld	s5,40(sp)
     776:	6125                	addi	sp,sp,96
     778:	8082                	ret
      printf("open(README) failed\n");
     77a:	00006517          	auipc	a0,0x6
     77e:	9ae50513          	addi	a0,a0,-1618 # 6128 <malloc+0x302>
     782:	00005097          	auipc	ra,0x5
     786:	5ec080e7          	jalr	1516(ra) # 5d6e <printf>
      exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	250080e7          	jalr	592(ra) # 59dc <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     794:	862a                	mv	a2,a0
     796:	85ce                	mv	a1,s3
     798:	00006517          	auipc	a0,0x6
     79c:	9a850513          	addi	a0,a0,-1624 # 6140 <malloc+0x31a>
     7a0:	00005097          	auipc	ra,0x5
     7a4:	5ce080e7          	jalr	1486(ra) # 5d6e <printf>
      exit(1);
     7a8:	4505                	li	a0,1
     7aa:	00005097          	auipc	ra,0x5
     7ae:	232080e7          	jalr	562(ra) # 59dc <exit>
      printf("pipe() failed\n");
     7b2:	00006517          	auipc	a0,0x6
     7b6:	92e50513          	addi	a0,a0,-1746 # 60e0 <malloc+0x2ba>
     7ba:	00005097          	auipc	ra,0x5
     7be:	5b4080e7          	jalr	1460(ra) # 5d6e <printf>
      exit(1);
     7c2:	4505                	li	a0,1
     7c4:	00005097          	auipc	ra,0x5
     7c8:	218080e7          	jalr	536(ra) # 59dc <exit>
      printf("pipe write failed\n");
     7cc:	00006517          	auipc	a0,0x6
     7d0:	9a450513          	addi	a0,a0,-1628 # 6170 <malloc+0x34a>
     7d4:	00005097          	auipc	ra,0x5
     7d8:	59a080e7          	jalr	1434(ra) # 5d6e <printf>
      exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	1fe080e7          	jalr	510(ra) # 59dc <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7e6:	862a                	mv	a2,a0
     7e8:	85ce                	mv	a1,s3
     7ea:	00006517          	auipc	a0,0x6
     7ee:	99e50513          	addi	a0,a0,-1634 # 6188 <malloc+0x362>
     7f2:	00005097          	auipc	ra,0x5
     7f6:	57c080e7          	jalr	1404(ra) # 5d6e <printf>
      exit(1);
     7fa:	4505                	li	a0,1
     7fc:	00005097          	auipc	ra,0x5
     800:	1e0080e7          	jalr	480(ra) # 59dc <exit>

0000000000000804 <truncate1>:
{
     804:	711d                	addi	sp,sp,-96
     806:	ec86                	sd	ra,88(sp)
     808:	e8a2                	sd	s0,80(sp)
     80a:	e4a6                	sd	s1,72(sp)
     80c:	e0ca                	sd	s2,64(sp)
     80e:	fc4e                	sd	s3,56(sp)
     810:	f852                	sd	s4,48(sp)
     812:	f456                	sd	s5,40(sp)
     814:	1080                	addi	s0,sp,96
     816:	8aaa                	mv	s5,a0
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	78850513          	addi	a0,a0,1928 # 5fa0 <malloc+0x17a>
     820:	00005097          	auipc	ra,0x5
     824:	20c080e7          	jalr	524(ra) # 5a2c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     828:	60100593          	li	a1,1537
     82c:	00005517          	auipc	a0,0x5
     830:	77450513          	addi	a0,a0,1908 # 5fa0 <malloc+0x17a>
     834:	00005097          	auipc	ra,0x5
     838:	1e8080e7          	jalr	488(ra) # 5a1c <open>
     83c:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     83e:	4611                	li	a2,4
     840:	00005597          	auipc	a1,0x5
     844:	77058593          	addi	a1,a1,1904 # 5fb0 <malloc+0x18a>
     848:	00005097          	auipc	ra,0x5
     84c:	1b4080e7          	jalr	436(ra) # 59fc <write>
  close(fd1);
     850:	8526                	mv	a0,s1
     852:	00005097          	auipc	ra,0x5
     856:	1b2080e7          	jalr	434(ra) # 5a04 <close>
  int fd2 = open("truncfile", O_RDONLY);
     85a:	4581                	li	a1,0
     85c:	00005517          	auipc	a0,0x5
     860:	74450513          	addi	a0,a0,1860 # 5fa0 <malloc+0x17a>
     864:	00005097          	auipc	ra,0x5
     868:	1b8080e7          	jalr	440(ra) # 5a1c <open>
     86c:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     86e:	02000613          	li	a2,32
     872:	fa040593          	addi	a1,s0,-96
     876:	00005097          	auipc	ra,0x5
     87a:	17e080e7          	jalr	382(ra) # 59f4 <read>
  if(n != 4){
     87e:	4791                	li	a5,4
     880:	0cf51e63          	bne	a0,a5,95c <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     884:	40100593          	li	a1,1025
     888:	00005517          	auipc	a0,0x5
     88c:	71850513          	addi	a0,a0,1816 # 5fa0 <malloc+0x17a>
     890:	00005097          	auipc	ra,0x5
     894:	18c080e7          	jalr	396(ra) # 5a1c <open>
     898:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     89a:	4581                	li	a1,0
     89c:	00005517          	auipc	a0,0x5
     8a0:	70450513          	addi	a0,a0,1796 # 5fa0 <malloc+0x17a>
     8a4:	00005097          	auipc	ra,0x5
     8a8:	178080e7          	jalr	376(ra) # 5a1c <open>
     8ac:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     8ae:	02000613          	li	a2,32
     8b2:	fa040593          	addi	a1,s0,-96
     8b6:	00005097          	auipc	ra,0x5
     8ba:	13e080e7          	jalr	318(ra) # 59f4 <read>
     8be:	8a2a                	mv	s4,a0
  if(n != 0){
     8c0:	ed4d                	bnez	a0,97a <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8c2:	02000613          	li	a2,32
     8c6:	fa040593          	addi	a1,s0,-96
     8ca:	8526                	mv	a0,s1
     8cc:	00005097          	auipc	ra,0x5
     8d0:	128080e7          	jalr	296(ra) # 59f4 <read>
     8d4:	8a2a                	mv	s4,a0
  if(n != 0){
     8d6:	e971                	bnez	a0,9aa <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8d8:	4619                	li	a2,6
     8da:	00006597          	auipc	a1,0x6
     8de:	93e58593          	addi	a1,a1,-1730 # 6218 <malloc+0x3f2>
     8e2:	854e                	mv	a0,s3
     8e4:	00005097          	auipc	ra,0x5
     8e8:	118080e7          	jalr	280(ra) # 59fc <write>
  n = read(fd3, buf, sizeof(buf));
     8ec:	02000613          	li	a2,32
     8f0:	fa040593          	addi	a1,s0,-96
     8f4:	854a                	mv	a0,s2
     8f6:	00005097          	auipc	ra,0x5
     8fa:	0fe080e7          	jalr	254(ra) # 59f4 <read>
  if(n != 6){
     8fe:	4799                	li	a5,6
     900:	0cf51d63          	bne	a0,a5,9da <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     904:	02000613          	li	a2,32
     908:	fa040593          	addi	a1,s0,-96
     90c:	8526                	mv	a0,s1
     90e:	00005097          	auipc	ra,0x5
     912:	0e6080e7          	jalr	230(ra) # 59f4 <read>
  if(n != 2){
     916:	4789                	li	a5,2
     918:	0ef51063          	bne	a0,a5,9f8 <truncate1+0x1f4>
  unlink("truncfile");
     91c:	00005517          	auipc	a0,0x5
     920:	68450513          	addi	a0,a0,1668 # 5fa0 <malloc+0x17a>
     924:	00005097          	auipc	ra,0x5
     928:	108080e7          	jalr	264(ra) # 5a2c <unlink>
  close(fd1);
     92c:	854e                	mv	a0,s3
     92e:	00005097          	auipc	ra,0x5
     932:	0d6080e7          	jalr	214(ra) # 5a04 <close>
  close(fd2);
     936:	8526                	mv	a0,s1
     938:	00005097          	auipc	ra,0x5
     93c:	0cc080e7          	jalr	204(ra) # 5a04 <close>
  close(fd3);
     940:	854a                	mv	a0,s2
     942:	00005097          	auipc	ra,0x5
     946:	0c2080e7          	jalr	194(ra) # 5a04 <close>
}
     94a:	60e6                	ld	ra,88(sp)
     94c:	6446                	ld	s0,80(sp)
     94e:	64a6                	ld	s1,72(sp)
     950:	6906                	ld	s2,64(sp)
     952:	79e2                	ld	s3,56(sp)
     954:	7a42                	ld	s4,48(sp)
     956:	7aa2                	ld	s5,40(sp)
     958:	6125                	addi	sp,sp,96
     95a:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     95c:	862a                	mv	a2,a0
     95e:	85d6                	mv	a1,s5
     960:	00006517          	auipc	a0,0x6
     964:	85850513          	addi	a0,a0,-1960 # 61b8 <malloc+0x392>
     968:	00005097          	auipc	ra,0x5
     96c:	406080e7          	jalr	1030(ra) # 5d6e <printf>
    exit(1);
     970:	4505                	li	a0,1
     972:	00005097          	auipc	ra,0x5
     976:	06a080e7          	jalr	106(ra) # 59dc <exit>
    printf("aaa fd3=%d\n", fd3);
     97a:	85ca                	mv	a1,s2
     97c:	00006517          	auipc	a0,0x6
     980:	85c50513          	addi	a0,a0,-1956 # 61d8 <malloc+0x3b2>
     984:	00005097          	auipc	ra,0x5
     988:	3ea080e7          	jalr	1002(ra) # 5d6e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     98c:	8652                	mv	a2,s4
     98e:	85d6                	mv	a1,s5
     990:	00006517          	auipc	a0,0x6
     994:	85850513          	addi	a0,a0,-1960 # 61e8 <malloc+0x3c2>
     998:	00005097          	auipc	ra,0x5
     99c:	3d6080e7          	jalr	982(ra) # 5d6e <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	03a080e7          	jalr	58(ra) # 59dc <exit>
    printf("bbb fd2=%d\n", fd2);
     9aa:	85a6                	mv	a1,s1
     9ac:	00006517          	auipc	a0,0x6
     9b0:	85c50513          	addi	a0,a0,-1956 # 6208 <malloc+0x3e2>
     9b4:	00005097          	auipc	ra,0x5
     9b8:	3ba080e7          	jalr	954(ra) # 5d6e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9bc:	8652                	mv	a2,s4
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	82850513          	addi	a0,a0,-2008 # 61e8 <malloc+0x3c2>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	3a6080e7          	jalr	934(ra) # 5d6e <printf>
    exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	00a080e7          	jalr	10(ra) # 59dc <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	84250513          	addi	a0,a0,-1982 # 6220 <malloc+0x3fa>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	388080e7          	jalr	904(ra) # 5d6e <printf>
    exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	fec080e7          	jalr	-20(ra) # 59dc <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9f8:	862a                	mv	a2,a0
     9fa:	85d6                	mv	a1,s5
     9fc:	00006517          	auipc	a0,0x6
     a00:	84450513          	addi	a0,a0,-1980 # 6240 <malloc+0x41a>
     a04:	00005097          	auipc	ra,0x5
     a08:	36a080e7          	jalr	874(ra) # 5d6e <printf>
    exit(1);
     a0c:	4505                	li	a0,1
     a0e:	00005097          	auipc	ra,0x5
     a12:	fce080e7          	jalr	-50(ra) # 59dc <exit>

0000000000000a16 <writetest>:
{
     a16:	7139                	addi	sp,sp,-64
     a18:	fc06                	sd	ra,56(sp)
     a1a:	f822                	sd	s0,48(sp)
     a1c:	f426                	sd	s1,40(sp)
     a1e:	f04a                	sd	s2,32(sp)
     a20:	ec4e                	sd	s3,24(sp)
     a22:	e852                	sd	s4,16(sp)
     a24:	e456                	sd	s5,8(sp)
     a26:	e05a                	sd	s6,0(sp)
     a28:	0080                	addi	s0,sp,64
     a2a:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a2c:	20200593          	li	a1,514
     a30:	00006517          	auipc	a0,0x6
     a34:	83050513          	addi	a0,a0,-2000 # 6260 <malloc+0x43a>
     a38:	00005097          	auipc	ra,0x5
     a3c:	fe4080e7          	jalr	-28(ra) # 5a1c <open>
  if(fd < 0){
     a40:	0a054d63          	bltz	a0,afa <writetest+0xe4>
     a44:	892a                	mv	s2,a0
     a46:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a48:	00006997          	auipc	s3,0x6
     a4c:	84098993          	addi	s3,s3,-1984 # 6288 <malloc+0x462>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a50:	00006a97          	auipc	s5,0x6
     a54:	870a8a93          	addi	s5,s5,-1936 # 62c0 <malloc+0x49a>
  for(i = 0; i < N; i++){
     a58:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a5c:	4629                	li	a2,10
     a5e:	85ce                	mv	a1,s3
     a60:	854a                	mv	a0,s2
     a62:	00005097          	auipc	ra,0x5
     a66:	f9a080e7          	jalr	-102(ra) # 59fc <write>
     a6a:	47a9                	li	a5,10
     a6c:	0af51563          	bne	a0,a5,b16 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a70:	4629                	li	a2,10
     a72:	85d6                	mv	a1,s5
     a74:	854a                	mv	a0,s2
     a76:	00005097          	auipc	ra,0x5
     a7a:	f86080e7          	jalr	-122(ra) # 59fc <write>
     a7e:	47a9                	li	a5,10
     a80:	0af51a63          	bne	a0,a5,b34 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a84:	2485                	addiw	s1,s1,1
     a86:	fd449be3          	bne	s1,s4,a5c <writetest+0x46>
  close(fd);
     a8a:	854a                	mv	a0,s2
     a8c:	00005097          	auipc	ra,0x5
     a90:	f78080e7          	jalr	-136(ra) # 5a04 <close>
  fd = open("small", O_RDONLY);
     a94:	4581                	li	a1,0
     a96:	00005517          	auipc	a0,0x5
     a9a:	7ca50513          	addi	a0,a0,1994 # 6260 <malloc+0x43a>
     a9e:	00005097          	auipc	ra,0x5
     aa2:	f7e080e7          	jalr	-130(ra) # 5a1c <open>
     aa6:	84aa                	mv	s1,a0
  if(fd < 0){
     aa8:	0a054563          	bltz	a0,b52 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     aac:	7d000613          	li	a2,2000
     ab0:	0000c597          	auipc	a1,0xc
     ab4:	1b858593          	addi	a1,a1,440 # cc68 <buf>
     ab8:	00005097          	auipc	ra,0x5
     abc:	f3c080e7          	jalr	-196(ra) # 59f4 <read>
  if(i != N*SZ*2){
     ac0:	7d000793          	li	a5,2000
     ac4:	0af51563          	bne	a0,a5,b6e <writetest+0x158>
  close(fd);
     ac8:	8526                	mv	a0,s1
     aca:	00005097          	auipc	ra,0x5
     ace:	f3a080e7          	jalr	-198(ra) # 5a04 <close>
  if(unlink("small") < 0){
     ad2:	00005517          	auipc	a0,0x5
     ad6:	78e50513          	addi	a0,a0,1934 # 6260 <malloc+0x43a>
     ada:	00005097          	auipc	ra,0x5
     ade:	f52080e7          	jalr	-174(ra) # 5a2c <unlink>
     ae2:	0a054463          	bltz	a0,b8a <writetest+0x174>
}
     ae6:	70e2                	ld	ra,56(sp)
     ae8:	7442                	ld	s0,48(sp)
     aea:	74a2                	ld	s1,40(sp)
     aec:	7902                	ld	s2,32(sp)
     aee:	69e2                	ld	s3,24(sp)
     af0:	6a42                	ld	s4,16(sp)
     af2:	6aa2                	ld	s5,8(sp)
     af4:	6b02                	ld	s6,0(sp)
     af6:	6121                	addi	sp,sp,64
     af8:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     afa:	85da                	mv	a1,s6
     afc:	00005517          	auipc	a0,0x5
     b00:	76c50513          	addi	a0,a0,1900 # 6268 <malloc+0x442>
     b04:	00005097          	auipc	ra,0x5
     b08:	26a080e7          	jalr	618(ra) # 5d6e <printf>
    exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	ece080e7          	jalr	-306(ra) # 59dc <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00005517          	auipc	a0,0x5
     b1e:	77e50513          	addi	a0,a0,1918 # 6298 <malloc+0x472>
     b22:	00005097          	auipc	ra,0x5
     b26:	24c080e7          	jalr	588(ra) # 5d6e <printf>
      exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	eb0080e7          	jalr	-336(ra) # 59dc <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b34:	8626                	mv	a2,s1
     b36:	85da                	mv	a1,s6
     b38:	00005517          	auipc	a0,0x5
     b3c:	79850513          	addi	a0,a0,1944 # 62d0 <malloc+0x4aa>
     b40:	00005097          	auipc	ra,0x5
     b44:	22e080e7          	jalr	558(ra) # 5d6e <printf>
      exit(1);
     b48:	4505                	li	a0,1
     b4a:	00005097          	auipc	ra,0x5
     b4e:	e92080e7          	jalr	-366(ra) # 59dc <exit>
    printf("%s: error: open small failed!\n", s);
     b52:	85da                	mv	a1,s6
     b54:	00005517          	auipc	a0,0x5
     b58:	7a450513          	addi	a0,a0,1956 # 62f8 <malloc+0x4d2>
     b5c:	00005097          	auipc	ra,0x5
     b60:	212080e7          	jalr	530(ra) # 5d6e <printf>
    exit(1);
     b64:	4505                	li	a0,1
     b66:	00005097          	auipc	ra,0x5
     b6a:	e76080e7          	jalr	-394(ra) # 59dc <exit>
    printf("%s: read failed\n", s);
     b6e:	85da                	mv	a1,s6
     b70:	00005517          	auipc	a0,0x5
     b74:	7a850513          	addi	a0,a0,1960 # 6318 <malloc+0x4f2>
     b78:	00005097          	auipc	ra,0x5
     b7c:	1f6080e7          	jalr	502(ra) # 5d6e <printf>
    exit(1);
     b80:	4505                	li	a0,1
     b82:	00005097          	auipc	ra,0x5
     b86:	e5a080e7          	jalr	-422(ra) # 59dc <exit>
    printf("%s: unlink small failed\n", s);
     b8a:	85da                	mv	a1,s6
     b8c:	00005517          	auipc	a0,0x5
     b90:	7a450513          	addi	a0,a0,1956 # 6330 <malloc+0x50a>
     b94:	00005097          	auipc	ra,0x5
     b98:	1da080e7          	jalr	474(ra) # 5d6e <printf>
    exit(1);
     b9c:	4505                	li	a0,1
     b9e:	00005097          	auipc	ra,0x5
     ba2:	e3e080e7          	jalr	-450(ra) # 59dc <exit>

0000000000000ba6 <unlinkread>:
{
     ba6:	7179                	addi	sp,sp,-48
     ba8:	f406                	sd	ra,40(sp)
     baa:	f022                	sd	s0,32(sp)
     bac:	ec26                	sd	s1,24(sp)
     bae:	e84a                	sd	s2,16(sp)
     bb0:	e44e                	sd	s3,8(sp)
     bb2:	1800                	addi	s0,sp,48
     bb4:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     bb6:	20200593          	li	a1,514
     bba:	00005517          	auipc	a0,0x5
     bbe:	79650513          	addi	a0,a0,1942 # 6350 <malloc+0x52a>
     bc2:	00005097          	auipc	ra,0x5
     bc6:	e5a080e7          	jalr	-422(ra) # 5a1c <open>
  if(fd < 0){
     bca:	0e054563          	bltz	a0,cb4 <unlinkread+0x10e>
     bce:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     bd0:	4615                	li	a2,5
     bd2:	00005597          	auipc	a1,0x5
     bd6:	7ae58593          	addi	a1,a1,1966 # 6380 <malloc+0x55a>
     bda:	00005097          	auipc	ra,0x5
     bde:	e22080e7          	jalr	-478(ra) # 59fc <write>
  close(fd);
     be2:	8526                	mv	a0,s1
     be4:	00005097          	auipc	ra,0x5
     be8:	e20080e7          	jalr	-480(ra) # 5a04 <close>
  fd = open("unlinkread", O_RDWR);
     bec:	4589                	li	a1,2
     bee:	00005517          	auipc	a0,0x5
     bf2:	76250513          	addi	a0,a0,1890 # 6350 <malloc+0x52a>
     bf6:	00005097          	auipc	ra,0x5
     bfa:	e26080e7          	jalr	-474(ra) # 5a1c <open>
     bfe:	84aa                	mv	s1,a0
  if(fd < 0){
     c00:	0c054863          	bltz	a0,cd0 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     c04:	00005517          	auipc	a0,0x5
     c08:	74c50513          	addi	a0,a0,1868 # 6350 <malloc+0x52a>
     c0c:	00005097          	auipc	ra,0x5
     c10:	e20080e7          	jalr	-480(ra) # 5a2c <unlink>
     c14:	ed61                	bnez	a0,cec <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     c16:	20200593          	li	a1,514
     c1a:	00005517          	auipc	a0,0x5
     c1e:	73650513          	addi	a0,a0,1846 # 6350 <malloc+0x52a>
     c22:	00005097          	auipc	ra,0x5
     c26:	dfa080e7          	jalr	-518(ra) # 5a1c <open>
     c2a:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     c2c:	460d                	li	a2,3
     c2e:	00005597          	auipc	a1,0x5
     c32:	79a58593          	addi	a1,a1,1946 # 63c8 <malloc+0x5a2>
     c36:	00005097          	auipc	ra,0x5
     c3a:	dc6080e7          	jalr	-570(ra) # 59fc <write>
  close(fd1);
     c3e:	854a                	mv	a0,s2
     c40:	00005097          	auipc	ra,0x5
     c44:	dc4080e7          	jalr	-572(ra) # 5a04 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c48:	660d                	lui	a2,0x3
     c4a:	0000c597          	auipc	a1,0xc
     c4e:	01e58593          	addi	a1,a1,30 # cc68 <buf>
     c52:	8526                	mv	a0,s1
     c54:	00005097          	auipc	ra,0x5
     c58:	da0080e7          	jalr	-608(ra) # 59f4 <read>
     c5c:	4795                	li	a5,5
     c5e:	0af51563          	bne	a0,a5,d08 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c62:	0000c717          	auipc	a4,0xc
     c66:	00674703          	lbu	a4,6(a4) # cc68 <buf>
     c6a:	06800793          	li	a5,104
     c6e:	0af71b63          	bne	a4,a5,d24 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c72:	4629                	li	a2,10
     c74:	0000c597          	auipc	a1,0xc
     c78:	ff458593          	addi	a1,a1,-12 # cc68 <buf>
     c7c:	8526                	mv	a0,s1
     c7e:	00005097          	auipc	ra,0x5
     c82:	d7e080e7          	jalr	-642(ra) # 59fc <write>
     c86:	47a9                	li	a5,10
     c88:	0af51c63          	bne	a0,a5,d40 <unlinkread+0x19a>
  close(fd);
     c8c:	8526                	mv	a0,s1
     c8e:	00005097          	auipc	ra,0x5
     c92:	d76080e7          	jalr	-650(ra) # 5a04 <close>
  unlink("unlinkread");
     c96:	00005517          	auipc	a0,0x5
     c9a:	6ba50513          	addi	a0,a0,1722 # 6350 <malloc+0x52a>
     c9e:	00005097          	auipc	ra,0x5
     ca2:	d8e080e7          	jalr	-626(ra) # 5a2c <unlink>
}
     ca6:	70a2                	ld	ra,40(sp)
     ca8:	7402                	ld	s0,32(sp)
     caa:	64e2                	ld	s1,24(sp)
     cac:	6942                	ld	s2,16(sp)
     cae:	69a2                	ld	s3,8(sp)
     cb0:	6145                	addi	sp,sp,48
     cb2:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     cb4:	85ce                	mv	a1,s3
     cb6:	00005517          	auipc	a0,0x5
     cba:	6aa50513          	addi	a0,a0,1706 # 6360 <malloc+0x53a>
     cbe:	00005097          	auipc	ra,0x5
     cc2:	0b0080e7          	jalr	176(ra) # 5d6e <printf>
    exit(1);
     cc6:	4505                	li	a0,1
     cc8:	00005097          	auipc	ra,0x5
     ccc:	d14080e7          	jalr	-748(ra) # 59dc <exit>
    printf("%s: open unlinkread failed\n", s);
     cd0:	85ce                	mv	a1,s3
     cd2:	00005517          	auipc	a0,0x5
     cd6:	6b650513          	addi	a0,a0,1718 # 6388 <malloc+0x562>
     cda:	00005097          	auipc	ra,0x5
     cde:	094080e7          	jalr	148(ra) # 5d6e <printf>
    exit(1);
     ce2:	4505                	li	a0,1
     ce4:	00005097          	auipc	ra,0x5
     ce8:	cf8080e7          	jalr	-776(ra) # 59dc <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cec:	85ce                	mv	a1,s3
     cee:	00005517          	auipc	a0,0x5
     cf2:	6ba50513          	addi	a0,a0,1722 # 63a8 <malloc+0x582>
     cf6:	00005097          	auipc	ra,0x5
     cfa:	078080e7          	jalr	120(ra) # 5d6e <printf>
    exit(1);
     cfe:	4505                	li	a0,1
     d00:	00005097          	auipc	ra,0x5
     d04:	cdc080e7          	jalr	-804(ra) # 59dc <exit>
    printf("%s: unlinkread read failed", s);
     d08:	85ce                	mv	a1,s3
     d0a:	00005517          	auipc	a0,0x5
     d0e:	6c650513          	addi	a0,a0,1734 # 63d0 <malloc+0x5aa>
     d12:	00005097          	auipc	ra,0x5
     d16:	05c080e7          	jalr	92(ra) # 5d6e <printf>
    exit(1);
     d1a:	4505                	li	a0,1
     d1c:	00005097          	auipc	ra,0x5
     d20:	cc0080e7          	jalr	-832(ra) # 59dc <exit>
    printf("%s: unlinkread wrong data\n", s);
     d24:	85ce                	mv	a1,s3
     d26:	00005517          	auipc	a0,0x5
     d2a:	6ca50513          	addi	a0,a0,1738 # 63f0 <malloc+0x5ca>
     d2e:	00005097          	auipc	ra,0x5
     d32:	040080e7          	jalr	64(ra) # 5d6e <printf>
    exit(1);
     d36:	4505                	li	a0,1
     d38:	00005097          	auipc	ra,0x5
     d3c:	ca4080e7          	jalr	-860(ra) # 59dc <exit>
    printf("%s: unlinkread write failed\n", s);
     d40:	85ce                	mv	a1,s3
     d42:	00005517          	auipc	a0,0x5
     d46:	6ce50513          	addi	a0,a0,1742 # 6410 <malloc+0x5ea>
     d4a:	00005097          	auipc	ra,0x5
     d4e:	024080e7          	jalr	36(ra) # 5d6e <printf>
    exit(1);
     d52:	4505                	li	a0,1
     d54:	00005097          	auipc	ra,0x5
     d58:	c88080e7          	jalr	-888(ra) # 59dc <exit>

0000000000000d5c <linktest>:
{
     d5c:	1101                	addi	sp,sp,-32
     d5e:	ec06                	sd	ra,24(sp)
     d60:	e822                	sd	s0,16(sp)
     d62:	e426                	sd	s1,8(sp)
     d64:	e04a                	sd	s2,0(sp)
     d66:	1000                	addi	s0,sp,32
     d68:	892a                	mv	s2,a0
  unlink("lf1");
     d6a:	00005517          	auipc	a0,0x5
     d6e:	6c650513          	addi	a0,a0,1734 # 6430 <malloc+0x60a>
     d72:	00005097          	auipc	ra,0x5
     d76:	cba080e7          	jalr	-838(ra) # 5a2c <unlink>
  unlink("lf2");
     d7a:	00005517          	auipc	a0,0x5
     d7e:	6be50513          	addi	a0,a0,1726 # 6438 <malloc+0x612>
     d82:	00005097          	auipc	ra,0x5
     d86:	caa080e7          	jalr	-854(ra) # 5a2c <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d8a:	20200593          	li	a1,514
     d8e:	00005517          	auipc	a0,0x5
     d92:	6a250513          	addi	a0,a0,1698 # 6430 <malloc+0x60a>
     d96:	00005097          	auipc	ra,0x5
     d9a:	c86080e7          	jalr	-890(ra) # 5a1c <open>
  if(fd < 0){
     d9e:	10054763          	bltz	a0,eac <linktest+0x150>
     da2:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     da4:	4615                	li	a2,5
     da6:	00005597          	auipc	a1,0x5
     daa:	5da58593          	addi	a1,a1,1498 # 6380 <malloc+0x55a>
     dae:	00005097          	auipc	ra,0x5
     db2:	c4e080e7          	jalr	-946(ra) # 59fc <write>
     db6:	4795                	li	a5,5
     db8:	10f51863          	bne	a0,a5,ec8 <linktest+0x16c>
  close(fd);
     dbc:	8526                	mv	a0,s1
     dbe:	00005097          	auipc	ra,0x5
     dc2:	c46080e7          	jalr	-954(ra) # 5a04 <close>
  if(link("lf1", "lf2") < 0){
     dc6:	00005597          	auipc	a1,0x5
     dca:	67258593          	addi	a1,a1,1650 # 6438 <malloc+0x612>
     dce:	00005517          	auipc	a0,0x5
     dd2:	66250513          	addi	a0,a0,1634 # 6430 <malloc+0x60a>
     dd6:	00005097          	auipc	ra,0x5
     dda:	c66080e7          	jalr	-922(ra) # 5a3c <link>
     dde:	10054363          	bltz	a0,ee4 <linktest+0x188>
  unlink("lf1");
     de2:	00005517          	auipc	a0,0x5
     de6:	64e50513          	addi	a0,a0,1614 # 6430 <malloc+0x60a>
     dea:	00005097          	auipc	ra,0x5
     dee:	c42080e7          	jalr	-958(ra) # 5a2c <unlink>
  if(open("lf1", 0) >= 0){
     df2:	4581                	li	a1,0
     df4:	00005517          	auipc	a0,0x5
     df8:	63c50513          	addi	a0,a0,1596 # 6430 <malloc+0x60a>
     dfc:	00005097          	auipc	ra,0x5
     e00:	c20080e7          	jalr	-992(ra) # 5a1c <open>
     e04:	0e055e63          	bgez	a0,f00 <linktest+0x1a4>
  fd = open("lf2", 0);
     e08:	4581                	li	a1,0
     e0a:	00005517          	auipc	a0,0x5
     e0e:	62e50513          	addi	a0,a0,1582 # 6438 <malloc+0x612>
     e12:	00005097          	auipc	ra,0x5
     e16:	c0a080e7          	jalr	-1014(ra) # 5a1c <open>
     e1a:	84aa                	mv	s1,a0
  if(fd < 0){
     e1c:	10054063          	bltz	a0,f1c <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     e20:	660d                	lui	a2,0x3
     e22:	0000c597          	auipc	a1,0xc
     e26:	e4658593          	addi	a1,a1,-442 # cc68 <buf>
     e2a:	00005097          	auipc	ra,0x5
     e2e:	bca080e7          	jalr	-1078(ra) # 59f4 <read>
     e32:	4795                	li	a5,5
     e34:	10f51263          	bne	a0,a5,f38 <linktest+0x1dc>
  close(fd);
     e38:	8526                	mv	a0,s1
     e3a:	00005097          	auipc	ra,0x5
     e3e:	bca080e7          	jalr	-1078(ra) # 5a04 <close>
  if(link("lf2", "lf2") >= 0){
     e42:	00005597          	auipc	a1,0x5
     e46:	5f658593          	addi	a1,a1,1526 # 6438 <malloc+0x612>
     e4a:	852e                	mv	a0,a1
     e4c:	00005097          	auipc	ra,0x5
     e50:	bf0080e7          	jalr	-1040(ra) # 5a3c <link>
     e54:	10055063          	bgez	a0,f54 <linktest+0x1f8>
  unlink("lf2");
     e58:	00005517          	auipc	a0,0x5
     e5c:	5e050513          	addi	a0,a0,1504 # 6438 <malloc+0x612>
     e60:	00005097          	auipc	ra,0x5
     e64:	bcc080e7          	jalr	-1076(ra) # 5a2c <unlink>
  if(link("lf2", "lf1") >= 0){
     e68:	00005597          	auipc	a1,0x5
     e6c:	5c858593          	addi	a1,a1,1480 # 6430 <malloc+0x60a>
     e70:	00005517          	auipc	a0,0x5
     e74:	5c850513          	addi	a0,a0,1480 # 6438 <malloc+0x612>
     e78:	00005097          	auipc	ra,0x5
     e7c:	bc4080e7          	jalr	-1084(ra) # 5a3c <link>
     e80:	0e055863          	bgez	a0,f70 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e84:	00005597          	auipc	a1,0x5
     e88:	5ac58593          	addi	a1,a1,1452 # 6430 <malloc+0x60a>
     e8c:	00005517          	auipc	a0,0x5
     e90:	6b450513          	addi	a0,a0,1716 # 6540 <malloc+0x71a>
     e94:	00005097          	auipc	ra,0x5
     e98:	ba8080e7          	jalr	-1112(ra) # 5a3c <link>
     e9c:	0e055863          	bgez	a0,f8c <linktest+0x230>
}
     ea0:	60e2                	ld	ra,24(sp)
     ea2:	6442                	ld	s0,16(sp)
     ea4:	64a2                	ld	s1,8(sp)
     ea6:	6902                	ld	s2,0(sp)
     ea8:	6105                	addi	sp,sp,32
     eaa:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     eac:	85ca                	mv	a1,s2
     eae:	00005517          	auipc	a0,0x5
     eb2:	59250513          	addi	a0,a0,1426 # 6440 <malloc+0x61a>
     eb6:	00005097          	auipc	ra,0x5
     eba:	eb8080e7          	jalr	-328(ra) # 5d6e <printf>
    exit(1);
     ebe:	4505                	li	a0,1
     ec0:	00005097          	auipc	ra,0x5
     ec4:	b1c080e7          	jalr	-1252(ra) # 59dc <exit>
    printf("%s: write lf1 failed\n", s);
     ec8:	85ca                	mv	a1,s2
     eca:	00005517          	auipc	a0,0x5
     ece:	58e50513          	addi	a0,a0,1422 # 6458 <malloc+0x632>
     ed2:	00005097          	auipc	ra,0x5
     ed6:	e9c080e7          	jalr	-356(ra) # 5d6e <printf>
    exit(1);
     eda:	4505                	li	a0,1
     edc:	00005097          	auipc	ra,0x5
     ee0:	b00080e7          	jalr	-1280(ra) # 59dc <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ee4:	85ca                	mv	a1,s2
     ee6:	00005517          	auipc	a0,0x5
     eea:	58a50513          	addi	a0,a0,1418 # 6470 <malloc+0x64a>
     eee:	00005097          	auipc	ra,0x5
     ef2:	e80080e7          	jalr	-384(ra) # 5d6e <printf>
    exit(1);
     ef6:	4505                	li	a0,1
     ef8:	00005097          	auipc	ra,0x5
     efc:	ae4080e7          	jalr	-1308(ra) # 59dc <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     f00:	85ca                	mv	a1,s2
     f02:	00005517          	auipc	a0,0x5
     f06:	58e50513          	addi	a0,a0,1422 # 6490 <malloc+0x66a>
     f0a:	00005097          	auipc	ra,0x5
     f0e:	e64080e7          	jalr	-412(ra) # 5d6e <printf>
    exit(1);
     f12:	4505                	li	a0,1
     f14:	00005097          	auipc	ra,0x5
     f18:	ac8080e7          	jalr	-1336(ra) # 59dc <exit>
    printf("%s: open lf2 failed\n", s);
     f1c:	85ca                	mv	a1,s2
     f1e:	00005517          	auipc	a0,0x5
     f22:	5a250513          	addi	a0,a0,1442 # 64c0 <malloc+0x69a>
     f26:	00005097          	auipc	ra,0x5
     f2a:	e48080e7          	jalr	-440(ra) # 5d6e <printf>
    exit(1);
     f2e:	4505                	li	a0,1
     f30:	00005097          	auipc	ra,0x5
     f34:	aac080e7          	jalr	-1364(ra) # 59dc <exit>
    printf("%s: read lf2 failed\n", s);
     f38:	85ca                	mv	a1,s2
     f3a:	00005517          	auipc	a0,0x5
     f3e:	59e50513          	addi	a0,a0,1438 # 64d8 <malloc+0x6b2>
     f42:	00005097          	auipc	ra,0x5
     f46:	e2c080e7          	jalr	-468(ra) # 5d6e <printf>
    exit(1);
     f4a:	4505                	li	a0,1
     f4c:	00005097          	auipc	ra,0x5
     f50:	a90080e7          	jalr	-1392(ra) # 59dc <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f54:	85ca                	mv	a1,s2
     f56:	00005517          	auipc	a0,0x5
     f5a:	59a50513          	addi	a0,a0,1434 # 64f0 <malloc+0x6ca>
     f5e:	00005097          	auipc	ra,0x5
     f62:	e10080e7          	jalr	-496(ra) # 5d6e <printf>
    exit(1);
     f66:	4505                	li	a0,1
     f68:	00005097          	auipc	ra,0x5
     f6c:	a74080e7          	jalr	-1420(ra) # 59dc <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f70:	85ca                	mv	a1,s2
     f72:	00005517          	auipc	a0,0x5
     f76:	5a650513          	addi	a0,a0,1446 # 6518 <malloc+0x6f2>
     f7a:	00005097          	auipc	ra,0x5
     f7e:	df4080e7          	jalr	-524(ra) # 5d6e <printf>
    exit(1);
     f82:	4505                	li	a0,1
     f84:	00005097          	auipc	ra,0x5
     f88:	a58080e7          	jalr	-1448(ra) # 59dc <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f8c:	85ca                	mv	a1,s2
     f8e:	00005517          	auipc	a0,0x5
     f92:	5ba50513          	addi	a0,a0,1466 # 6548 <malloc+0x722>
     f96:	00005097          	auipc	ra,0x5
     f9a:	dd8080e7          	jalr	-552(ra) # 5d6e <printf>
    exit(1);
     f9e:	4505                	li	a0,1
     fa0:	00005097          	auipc	ra,0x5
     fa4:	a3c080e7          	jalr	-1476(ra) # 59dc <exit>

0000000000000fa8 <validatetest>:
{
     fa8:	7139                	addi	sp,sp,-64
     faa:	fc06                	sd	ra,56(sp)
     fac:	f822                	sd	s0,48(sp)
     fae:	f426                	sd	s1,40(sp)
     fb0:	f04a                	sd	s2,32(sp)
     fb2:	ec4e                	sd	s3,24(sp)
     fb4:	e852                	sd	s4,16(sp)
     fb6:	e456                	sd	s5,8(sp)
     fb8:	e05a                	sd	s6,0(sp)
     fba:	0080                	addi	s0,sp,64
     fbc:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     fbe:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     fc0:	00005997          	auipc	s3,0x5
     fc4:	5a898993          	addi	s3,s3,1448 # 6568 <malloc+0x742>
     fc8:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     fca:	6a85                	lui	s5,0x1
     fcc:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     fd0:	85a6                	mv	a1,s1
     fd2:	854e                	mv	a0,s3
     fd4:	00005097          	auipc	ra,0x5
     fd8:	a68080e7          	jalr	-1432(ra) # 5a3c <link>
     fdc:	01251f63          	bne	a0,s2,ffa <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     fe0:	94d6                	add	s1,s1,s5
     fe2:	ff4497e3          	bne	s1,s4,fd0 <validatetest+0x28>
}
     fe6:	70e2                	ld	ra,56(sp)
     fe8:	7442                	ld	s0,48(sp)
     fea:	74a2                	ld	s1,40(sp)
     fec:	7902                	ld	s2,32(sp)
     fee:	69e2                	ld	s3,24(sp)
     ff0:	6a42                	ld	s4,16(sp)
     ff2:	6aa2                	ld	s5,8(sp)
     ff4:	6b02                	ld	s6,0(sp)
     ff6:	6121                	addi	sp,sp,64
     ff8:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ffa:	85da                	mv	a1,s6
     ffc:	00005517          	auipc	a0,0x5
    1000:	57c50513          	addi	a0,a0,1404 # 6578 <malloc+0x752>
    1004:	00005097          	auipc	ra,0x5
    1008:	d6a080e7          	jalr	-662(ra) # 5d6e <printf>
      exit(1);
    100c:	4505                	li	a0,1
    100e:	00005097          	auipc	ra,0x5
    1012:	9ce080e7          	jalr	-1586(ra) # 59dc <exit>

0000000000001016 <pgbug>:
{
    1016:	7179                	addi	sp,sp,-48
    1018:	f406                	sd	ra,40(sp)
    101a:	f022                	sd	s0,32(sp)
    101c:	ec26                	sd	s1,24(sp)
    101e:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1020:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1024:	00008497          	auipc	s1,0x8
    1028:	fdc48493          	addi	s1,s1,-36 # 9000 <big>
    102c:	fd840593          	addi	a1,s0,-40
    1030:	6088                	ld	a0,0(s1)
    1032:	00005097          	auipc	ra,0x5
    1036:	9e2080e7          	jalr	-1566(ra) # 5a14 <exec>
  pipe(big);
    103a:	6088                	ld	a0,0(s1)
    103c:	00005097          	auipc	ra,0x5
    1040:	9b0080e7          	jalr	-1616(ra) # 59ec <pipe>
  exit(0);
    1044:	4501                	li	a0,0
    1046:	00005097          	auipc	ra,0x5
    104a:	996080e7          	jalr	-1642(ra) # 59dc <exit>

000000000000104e <badarg>:
{
    104e:	7139                	addi	sp,sp,-64
    1050:	fc06                	sd	ra,56(sp)
    1052:	f822                	sd	s0,48(sp)
    1054:	f426                	sd	s1,40(sp)
    1056:	f04a                	sd	s2,32(sp)
    1058:	ec4e                	sd	s3,24(sp)
    105a:	0080                	addi	s0,sp,64
    105c:	64b1                	lui	s1,0xc
    105e:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1df8>
    argv[0] = (char*)0xffffffff;
    1062:	597d                	li	s2,-1
    1064:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1068:	00005997          	auipc	s3,0x5
    106c:	ee098993          	addi	s3,s3,-288 # 5f48 <malloc+0x122>
    argv[0] = (char*)0xffffffff;
    1070:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1074:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1078:	fc040593          	addi	a1,s0,-64
    107c:	854e                	mv	a0,s3
    107e:	00005097          	auipc	ra,0x5
    1082:	996080e7          	jalr	-1642(ra) # 5a14 <exec>
  for(int i = 0; i < 50000; i++){
    1086:	34fd                	addiw	s1,s1,-1
    1088:	f4e5                	bnez	s1,1070 <badarg+0x22>
  exit(0);
    108a:	4501                	li	a0,0
    108c:	00005097          	auipc	ra,0x5
    1090:	950080e7          	jalr	-1712(ra) # 59dc <exit>

0000000000001094 <copyinstr2>:
{
    1094:	7155                	addi	sp,sp,-208
    1096:	e586                	sd	ra,200(sp)
    1098:	e1a2                	sd	s0,192(sp)
    109a:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    109c:	f6840793          	addi	a5,s0,-152
    10a0:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10a4:	07800713          	li	a4,120
    10a8:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    10ac:	0785                	addi	a5,a5,1
    10ae:	fed79de3          	bne	a5,a3,10a8 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10b2:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10b6:	f6840513          	addi	a0,s0,-152
    10ba:	00005097          	auipc	ra,0x5
    10be:	972080e7          	jalr	-1678(ra) # 5a2c <unlink>
  if(ret != -1){
    10c2:	57fd                	li	a5,-1
    10c4:	0ef51063          	bne	a0,a5,11a4 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    10c8:	20100593          	li	a1,513
    10cc:	f6840513          	addi	a0,s0,-152
    10d0:	00005097          	auipc	ra,0x5
    10d4:	94c080e7          	jalr	-1716(ra) # 5a1c <open>
  if(fd != -1){
    10d8:	57fd                	li	a5,-1
    10da:	0ef51563          	bne	a0,a5,11c4 <copyinstr2+0x130>
  ret = link(b, b);
    10de:	f6840593          	addi	a1,s0,-152
    10e2:	852e                	mv	a0,a1
    10e4:	00005097          	auipc	ra,0x5
    10e8:	958080e7          	jalr	-1704(ra) # 5a3c <link>
  if(ret != -1){
    10ec:	57fd                	li	a5,-1
    10ee:	0ef51b63          	bne	a0,a5,11e4 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    10f2:	00006797          	auipc	a5,0x6
    10f6:	6de78793          	addi	a5,a5,1758 # 77d0 <malloc+0x19aa>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	00005097          	auipc	ra,0x5
    110e:	90a080e7          	jalr	-1782(ra) # 5a14 <exec>
  if(ret != -1){
    1112:	57fd                	li	a5,-1
    1114:	0ef51963          	bne	a0,a5,1206 <copyinstr2+0x172>
  int pid = fork();
    1118:	00005097          	auipc	ra,0x5
    111c:	8bc080e7          	jalr	-1860(ra) # 59d4 <fork>
  if(pid < 0){
    1120:	10054363          	bltz	a0,1226 <copyinstr2+0x192>
  if(pid == 0){
    1124:	12051463          	bnez	a0,124c <copyinstr2+0x1b8>
    1128:	00008797          	auipc	a5,0x8
    112c:	42878793          	addi	a5,a5,1064 # 9550 <big.0>
    1130:	00009697          	auipc	a3,0x9
    1134:	42068693          	addi	a3,a3,1056 # a550 <big.0+0x1000>
      big[i] = 'x';
    1138:	07800713          	li	a4,120
    113c:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1140:	0785                	addi	a5,a5,1
    1142:	fed79de3          	bne	a5,a3,113c <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1146:	00009797          	auipc	a5,0x9
    114a:	40078523          	sb	zero,1034(a5) # a550 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    114e:	00007797          	auipc	a5,0x7
    1152:	12278793          	addi	a5,a5,290 # 8270 <malloc+0x244a>
    1156:	6390                	ld	a2,0(a5)
    1158:	6794                	ld	a3,8(a5)
    115a:	6b98                	ld	a4,16(a5)
    115c:	6f9c                	ld	a5,24(a5)
    115e:	f2c43823          	sd	a2,-208(s0)
    1162:	f2d43c23          	sd	a3,-200(s0)
    1166:	f4e43023          	sd	a4,-192(s0)
    116a:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    116e:	f3040593          	addi	a1,s0,-208
    1172:	00005517          	auipc	a0,0x5
    1176:	dd650513          	addi	a0,a0,-554 # 5f48 <malloc+0x122>
    117a:	00005097          	auipc	ra,0x5
    117e:	89a080e7          	jalr	-1894(ra) # 5a14 <exec>
    if(ret != -1){
    1182:	57fd                	li	a5,-1
    1184:	0af50e63          	beq	a0,a5,1240 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1188:	55fd                	li	a1,-1
    118a:	00005517          	auipc	a0,0x5
    118e:	49650513          	addi	a0,a0,1174 # 6620 <malloc+0x7fa>
    1192:	00005097          	auipc	ra,0x5
    1196:	bdc080e7          	jalr	-1060(ra) # 5d6e <printf>
      exit(1);
    119a:	4505                	li	a0,1
    119c:	00005097          	auipc	ra,0x5
    11a0:	840080e7          	jalr	-1984(ra) # 59dc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    11a4:	862a                	mv	a2,a0
    11a6:	f6840593          	addi	a1,s0,-152
    11aa:	00005517          	auipc	a0,0x5
    11ae:	3ee50513          	addi	a0,a0,1006 # 6598 <malloc+0x772>
    11b2:	00005097          	auipc	ra,0x5
    11b6:	bbc080e7          	jalr	-1092(ra) # 5d6e <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	00005097          	auipc	ra,0x5
    11c0:	820080e7          	jalr	-2016(ra) # 59dc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11c4:	862a                	mv	a2,a0
    11c6:	f6840593          	addi	a1,s0,-152
    11ca:	00005517          	auipc	a0,0x5
    11ce:	3ee50513          	addi	a0,a0,1006 # 65b8 <malloc+0x792>
    11d2:	00005097          	auipc	ra,0x5
    11d6:	b9c080e7          	jalr	-1124(ra) # 5d6e <printf>
    exit(1);
    11da:	4505                	li	a0,1
    11dc:	00005097          	auipc	ra,0x5
    11e0:	800080e7          	jalr	-2048(ra) # 59dc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11e4:	86aa                	mv	a3,a0
    11e6:	f6840613          	addi	a2,s0,-152
    11ea:	85b2                	mv	a1,a2
    11ec:	00005517          	auipc	a0,0x5
    11f0:	3ec50513          	addi	a0,a0,1004 # 65d8 <malloc+0x7b2>
    11f4:	00005097          	auipc	ra,0x5
    11f8:	b7a080e7          	jalr	-1158(ra) # 5d6e <printf>
    exit(1);
    11fc:	4505                	li	a0,1
    11fe:	00004097          	auipc	ra,0x4
    1202:	7de080e7          	jalr	2014(ra) # 59dc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1206:	567d                	li	a2,-1
    1208:	f6840593          	addi	a1,s0,-152
    120c:	00005517          	auipc	a0,0x5
    1210:	3f450513          	addi	a0,a0,1012 # 6600 <malloc+0x7da>
    1214:	00005097          	auipc	ra,0x5
    1218:	b5a080e7          	jalr	-1190(ra) # 5d6e <printf>
    exit(1);
    121c:	4505                	li	a0,1
    121e:	00004097          	auipc	ra,0x4
    1222:	7be080e7          	jalr	1982(ra) # 59dc <exit>
    printf("fork failed\n");
    1226:	00006517          	auipc	a0,0x6
    122a:	85a50513          	addi	a0,a0,-1958 # 6a80 <malloc+0xc5a>
    122e:	00005097          	auipc	ra,0x5
    1232:	b40080e7          	jalr	-1216(ra) # 5d6e <printf>
    exit(1);
    1236:	4505                	li	a0,1
    1238:	00004097          	auipc	ra,0x4
    123c:	7a4080e7          	jalr	1956(ra) # 59dc <exit>
    exit(747); // OK
    1240:	2eb00513          	li	a0,747
    1244:	00004097          	auipc	ra,0x4
    1248:	798080e7          	jalr	1944(ra) # 59dc <exit>
  int st = 0;
    124c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1250:	f5440513          	addi	a0,s0,-172
    1254:	00004097          	auipc	ra,0x4
    1258:	790080e7          	jalr	1936(ra) # 59e4 <wait>
  if(st != 747){
    125c:	f5442703          	lw	a4,-172(s0)
    1260:	2eb00793          	li	a5,747
    1264:	00f71663          	bne	a4,a5,1270 <copyinstr2+0x1dc>
}
    1268:	60ae                	ld	ra,200(sp)
    126a:	640e                	ld	s0,192(sp)
    126c:	6169                	addi	sp,sp,208
    126e:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1270:	00005517          	auipc	a0,0x5
    1274:	3d850513          	addi	a0,a0,984 # 6648 <malloc+0x822>
    1278:	00005097          	auipc	ra,0x5
    127c:	af6080e7          	jalr	-1290(ra) # 5d6e <printf>
    exit(1);
    1280:	4505                	li	a0,1
    1282:	00004097          	auipc	ra,0x4
    1286:	75a080e7          	jalr	1882(ra) # 59dc <exit>

000000000000128a <truncate3>:
{
    128a:	7159                	addi	sp,sp,-112
    128c:	f486                	sd	ra,104(sp)
    128e:	f0a2                	sd	s0,96(sp)
    1290:	eca6                	sd	s1,88(sp)
    1292:	e8ca                	sd	s2,80(sp)
    1294:	e4ce                	sd	s3,72(sp)
    1296:	e0d2                	sd	s4,64(sp)
    1298:	fc56                	sd	s5,56(sp)
    129a:	1880                	addi	s0,sp,112
    129c:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    129e:	60100593          	li	a1,1537
    12a2:	00005517          	auipc	a0,0x5
    12a6:	cfe50513          	addi	a0,a0,-770 # 5fa0 <malloc+0x17a>
    12aa:	00004097          	auipc	ra,0x4
    12ae:	772080e7          	jalr	1906(ra) # 5a1c <open>
    12b2:	00004097          	auipc	ra,0x4
    12b6:	752080e7          	jalr	1874(ra) # 5a04 <close>
  pid = fork();
    12ba:	00004097          	auipc	ra,0x4
    12be:	71a080e7          	jalr	1818(ra) # 59d4 <fork>
  if(pid < 0){
    12c2:	08054063          	bltz	a0,1342 <truncate3+0xb8>
  if(pid == 0){
    12c6:	e969                	bnez	a0,1398 <truncate3+0x10e>
    12c8:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    12cc:	00005a17          	auipc	s4,0x5
    12d0:	cd4a0a13          	addi	s4,s4,-812 # 5fa0 <malloc+0x17a>
      int n = write(fd, "1234567890", 10);
    12d4:	00005a97          	auipc	s5,0x5
    12d8:	3d4a8a93          	addi	s5,s5,980 # 66a8 <malloc+0x882>
      int fd = open("truncfile", O_WRONLY);
    12dc:	4585                	li	a1,1
    12de:	8552                	mv	a0,s4
    12e0:	00004097          	auipc	ra,0x4
    12e4:	73c080e7          	jalr	1852(ra) # 5a1c <open>
    12e8:	84aa                	mv	s1,a0
      if(fd < 0){
    12ea:	06054a63          	bltz	a0,135e <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    12ee:	4629                	li	a2,10
    12f0:	85d6                	mv	a1,s5
    12f2:	00004097          	auipc	ra,0x4
    12f6:	70a080e7          	jalr	1802(ra) # 59fc <write>
      if(n != 10){
    12fa:	47a9                	li	a5,10
    12fc:	06f51f63          	bne	a0,a5,137a <truncate3+0xf0>
      close(fd);
    1300:	8526                	mv	a0,s1
    1302:	00004097          	auipc	ra,0x4
    1306:	702080e7          	jalr	1794(ra) # 5a04 <close>
      fd = open("truncfile", O_RDONLY);
    130a:	4581                	li	a1,0
    130c:	8552                	mv	a0,s4
    130e:	00004097          	auipc	ra,0x4
    1312:	70e080e7          	jalr	1806(ra) # 5a1c <open>
    1316:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1318:	02000613          	li	a2,32
    131c:	f9840593          	addi	a1,s0,-104
    1320:	00004097          	auipc	ra,0x4
    1324:	6d4080e7          	jalr	1748(ra) # 59f4 <read>
      close(fd);
    1328:	8526                	mv	a0,s1
    132a:	00004097          	auipc	ra,0x4
    132e:	6da080e7          	jalr	1754(ra) # 5a04 <close>
    for(int i = 0; i < 100; i++){
    1332:	39fd                	addiw	s3,s3,-1
    1334:	fa0994e3          	bnez	s3,12dc <truncate3+0x52>
    exit(0);
    1338:	4501                	li	a0,0
    133a:	00004097          	auipc	ra,0x4
    133e:	6a2080e7          	jalr	1698(ra) # 59dc <exit>
    printf("%s: fork failed\n", s);
    1342:	85ca                	mv	a1,s2
    1344:	00005517          	auipc	a0,0x5
    1348:	33450513          	addi	a0,a0,820 # 6678 <malloc+0x852>
    134c:	00005097          	auipc	ra,0x5
    1350:	a22080e7          	jalr	-1502(ra) # 5d6e <printf>
    exit(1);
    1354:	4505                	li	a0,1
    1356:	00004097          	auipc	ra,0x4
    135a:	686080e7          	jalr	1670(ra) # 59dc <exit>
        printf("%s: open failed\n", s);
    135e:	85ca                	mv	a1,s2
    1360:	00005517          	auipc	a0,0x5
    1364:	33050513          	addi	a0,a0,816 # 6690 <malloc+0x86a>
    1368:	00005097          	auipc	ra,0x5
    136c:	a06080e7          	jalr	-1530(ra) # 5d6e <printf>
        exit(1);
    1370:	4505                	li	a0,1
    1372:	00004097          	auipc	ra,0x4
    1376:	66a080e7          	jalr	1642(ra) # 59dc <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    137a:	862a                	mv	a2,a0
    137c:	85ca                	mv	a1,s2
    137e:	00005517          	auipc	a0,0x5
    1382:	33a50513          	addi	a0,a0,826 # 66b8 <malloc+0x892>
    1386:	00005097          	auipc	ra,0x5
    138a:	9e8080e7          	jalr	-1560(ra) # 5d6e <printf>
        exit(1);
    138e:	4505                	li	a0,1
    1390:	00004097          	auipc	ra,0x4
    1394:	64c080e7          	jalr	1612(ra) # 59dc <exit>
    1398:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    139c:	00005a17          	auipc	s4,0x5
    13a0:	c04a0a13          	addi	s4,s4,-1020 # 5fa0 <malloc+0x17a>
    int n = write(fd, "xxx", 3);
    13a4:	00005a97          	auipc	s5,0x5
    13a8:	334a8a93          	addi	s5,s5,820 # 66d8 <malloc+0x8b2>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    13ac:	60100593          	li	a1,1537
    13b0:	8552                	mv	a0,s4
    13b2:	00004097          	auipc	ra,0x4
    13b6:	66a080e7          	jalr	1642(ra) # 5a1c <open>
    13ba:	84aa                	mv	s1,a0
    if(fd < 0){
    13bc:	04054763          	bltz	a0,140a <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    13c0:	460d                	li	a2,3
    13c2:	85d6                	mv	a1,s5
    13c4:	00004097          	auipc	ra,0x4
    13c8:	638080e7          	jalr	1592(ra) # 59fc <write>
    if(n != 3){
    13cc:	478d                	li	a5,3
    13ce:	04f51c63          	bne	a0,a5,1426 <truncate3+0x19c>
    close(fd);
    13d2:	8526                	mv	a0,s1
    13d4:	00004097          	auipc	ra,0x4
    13d8:	630080e7          	jalr	1584(ra) # 5a04 <close>
  for(int i = 0; i < 150; i++){
    13dc:	39fd                	addiw	s3,s3,-1
    13de:	fc0997e3          	bnez	s3,13ac <truncate3+0x122>
  wait(&xstatus);
    13e2:	fbc40513          	addi	a0,s0,-68
    13e6:	00004097          	auipc	ra,0x4
    13ea:	5fe080e7          	jalr	1534(ra) # 59e4 <wait>
  unlink("truncfile");
    13ee:	00005517          	auipc	a0,0x5
    13f2:	bb250513          	addi	a0,a0,-1102 # 5fa0 <malloc+0x17a>
    13f6:	00004097          	auipc	ra,0x4
    13fa:	636080e7          	jalr	1590(ra) # 5a2c <unlink>
  exit(xstatus);
    13fe:	fbc42503          	lw	a0,-68(s0)
    1402:	00004097          	auipc	ra,0x4
    1406:	5da080e7          	jalr	1498(ra) # 59dc <exit>
      printf("%s: open failed\n", s);
    140a:	85ca                	mv	a1,s2
    140c:	00005517          	auipc	a0,0x5
    1410:	28450513          	addi	a0,a0,644 # 6690 <malloc+0x86a>
    1414:	00005097          	auipc	ra,0x5
    1418:	95a080e7          	jalr	-1702(ra) # 5d6e <printf>
      exit(1);
    141c:	4505                	li	a0,1
    141e:	00004097          	auipc	ra,0x4
    1422:	5be080e7          	jalr	1470(ra) # 59dc <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1426:	862a                	mv	a2,a0
    1428:	85ca                	mv	a1,s2
    142a:	00005517          	auipc	a0,0x5
    142e:	2b650513          	addi	a0,a0,694 # 66e0 <malloc+0x8ba>
    1432:	00005097          	auipc	ra,0x5
    1436:	93c080e7          	jalr	-1732(ra) # 5d6e <printf>
      exit(1);
    143a:	4505                	li	a0,1
    143c:	00004097          	auipc	ra,0x4
    1440:	5a0080e7          	jalr	1440(ra) # 59dc <exit>

0000000000001444 <exectest>:
{
    1444:	715d                	addi	sp,sp,-80
    1446:	e486                	sd	ra,72(sp)
    1448:	e0a2                	sd	s0,64(sp)
    144a:	fc26                	sd	s1,56(sp)
    144c:	f84a                	sd	s2,48(sp)
    144e:	0880                	addi	s0,sp,80
    1450:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1452:	00005797          	auipc	a5,0x5
    1456:	af678793          	addi	a5,a5,-1290 # 5f48 <malloc+0x122>
    145a:	fcf43023          	sd	a5,-64(s0)
    145e:	00005797          	auipc	a5,0x5
    1462:	2a278793          	addi	a5,a5,674 # 6700 <malloc+0x8da>
    1466:	fcf43423          	sd	a5,-56(s0)
    146a:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    146e:	00005517          	auipc	a0,0x5
    1472:	29a50513          	addi	a0,a0,666 # 6708 <malloc+0x8e2>
    1476:	00004097          	auipc	ra,0x4
    147a:	5b6080e7          	jalr	1462(ra) # 5a2c <unlink>
  pid = fork();
    147e:	00004097          	auipc	ra,0x4
    1482:	556080e7          	jalr	1366(ra) # 59d4 <fork>
  if(pid < 0) {
    1486:	04054663          	bltz	a0,14d2 <exectest+0x8e>
    148a:	84aa                	mv	s1,a0
  if(pid == 0) {
    148c:	e959                	bnez	a0,1522 <exectest+0xde>
    close(1);
    148e:	4505                	li	a0,1
    1490:	00004097          	auipc	ra,0x4
    1494:	574080e7          	jalr	1396(ra) # 5a04 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1498:	20100593          	li	a1,513
    149c:	00005517          	auipc	a0,0x5
    14a0:	26c50513          	addi	a0,a0,620 # 6708 <malloc+0x8e2>
    14a4:	00004097          	auipc	ra,0x4
    14a8:	578080e7          	jalr	1400(ra) # 5a1c <open>
    if(fd < 0) {
    14ac:	04054163          	bltz	a0,14ee <exectest+0xaa>
    if(fd != 1) {
    14b0:	4785                	li	a5,1
    14b2:	04f50c63          	beq	a0,a5,150a <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    14b6:	85ca                	mv	a1,s2
    14b8:	00005517          	auipc	a0,0x5
    14bc:	27050513          	addi	a0,a0,624 # 6728 <malloc+0x902>
    14c0:	00005097          	auipc	ra,0x5
    14c4:	8ae080e7          	jalr	-1874(ra) # 5d6e <printf>
      exit(1);
    14c8:	4505                	li	a0,1
    14ca:	00004097          	auipc	ra,0x4
    14ce:	512080e7          	jalr	1298(ra) # 59dc <exit>
     printf("%s: fork failed\n", s);
    14d2:	85ca                	mv	a1,s2
    14d4:	00005517          	auipc	a0,0x5
    14d8:	1a450513          	addi	a0,a0,420 # 6678 <malloc+0x852>
    14dc:	00005097          	auipc	ra,0x5
    14e0:	892080e7          	jalr	-1902(ra) # 5d6e <printf>
     exit(1);
    14e4:	4505                	li	a0,1
    14e6:	00004097          	auipc	ra,0x4
    14ea:	4f6080e7          	jalr	1270(ra) # 59dc <exit>
      printf("%s: create failed\n", s);
    14ee:	85ca                	mv	a1,s2
    14f0:	00005517          	auipc	a0,0x5
    14f4:	22050513          	addi	a0,a0,544 # 6710 <malloc+0x8ea>
    14f8:	00005097          	auipc	ra,0x5
    14fc:	876080e7          	jalr	-1930(ra) # 5d6e <printf>
      exit(1);
    1500:	4505                	li	a0,1
    1502:	00004097          	auipc	ra,0x4
    1506:	4da080e7          	jalr	1242(ra) # 59dc <exit>
    if(exec("echo", echoargv) < 0){
    150a:	fc040593          	addi	a1,s0,-64
    150e:	00005517          	auipc	a0,0x5
    1512:	a3a50513          	addi	a0,a0,-1478 # 5f48 <malloc+0x122>
    1516:	00004097          	auipc	ra,0x4
    151a:	4fe080e7          	jalr	1278(ra) # 5a14 <exec>
    151e:	02054163          	bltz	a0,1540 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1522:	fdc40513          	addi	a0,s0,-36
    1526:	00004097          	auipc	ra,0x4
    152a:	4be080e7          	jalr	1214(ra) # 59e4 <wait>
    152e:	02951763          	bne	a0,s1,155c <exectest+0x118>
  if(xstatus != 0)
    1532:	fdc42503          	lw	a0,-36(s0)
    1536:	cd0d                	beqz	a0,1570 <exectest+0x12c>
    exit(xstatus);
    1538:	00004097          	auipc	ra,0x4
    153c:	4a4080e7          	jalr	1188(ra) # 59dc <exit>
      printf("%s: exec echo failed\n", s);
    1540:	85ca                	mv	a1,s2
    1542:	00005517          	auipc	a0,0x5
    1546:	1f650513          	addi	a0,a0,502 # 6738 <malloc+0x912>
    154a:	00005097          	auipc	ra,0x5
    154e:	824080e7          	jalr	-2012(ra) # 5d6e <printf>
      exit(1);
    1552:	4505                	li	a0,1
    1554:	00004097          	auipc	ra,0x4
    1558:	488080e7          	jalr	1160(ra) # 59dc <exit>
    printf("%s: wait failed!\n", s);
    155c:	85ca                	mv	a1,s2
    155e:	00005517          	auipc	a0,0x5
    1562:	1f250513          	addi	a0,a0,498 # 6750 <malloc+0x92a>
    1566:	00005097          	auipc	ra,0x5
    156a:	808080e7          	jalr	-2040(ra) # 5d6e <printf>
    156e:	b7d1                	j	1532 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1570:	4581                	li	a1,0
    1572:	00005517          	auipc	a0,0x5
    1576:	19650513          	addi	a0,a0,406 # 6708 <malloc+0x8e2>
    157a:	00004097          	auipc	ra,0x4
    157e:	4a2080e7          	jalr	1186(ra) # 5a1c <open>
  if(fd < 0) {
    1582:	02054a63          	bltz	a0,15b6 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1586:	4609                	li	a2,2
    1588:	fb840593          	addi	a1,s0,-72
    158c:	00004097          	auipc	ra,0x4
    1590:	468080e7          	jalr	1128(ra) # 59f4 <read>
    1594:	4789                	li	a5,2
    1596:	02f50e63          	beq	a0,a5,15d2 <exectest+0x18e>
    printf("%s: read failed\n", s);
    159a:	85ca                	mv	a1,s2
    159c:	00005517          	auipc	a0,0x5
    15a0:	d7c50513          	addi	a0,a0,-644 # 6318 <malloc+0x4f2>
    15a4:	00004097          	auipc	ra,0x4
    15a8:	7ca080e7          	jalr	1994(ra) # 5d6e <printf>
    exit(1);
    15ac:	4505                	li	a0,1
    15ae:	00004097          	auipc	ra,0x4
    15b2:	42e080e7          	jalr	1070(ra) # 59dc <exit>
    printf("%s: open failed\n", s);
    15b6:	85ca                	mv	a1,s2
    15b8:	00005517          	auipc	a0,0x5
    15bc:	0d850513          	addi	a0,a0,216 # 6690 <malloc+0x86a>
    15c0:	00004097          	auipc	ra,0x4
    15c4:	7ae080e7          	jalr	1966(ra) # 5d6e <printf>
    exit(1);
    15c8:	4505                	li	a0,1
    15ca:	00004097          	auipc	ra,0x4
    15ce:	412080e7          	jalr	1042(ra) # 59dc <exit>
  unlink("echo-ok");
    15d2:	00005517          	auipc	a0,0x5
    15d6:	13650513          	addi	a0,a0,310 # 6708 <malloc+0x8e2>
    15da:	00004097          	auipc	ra,0x4
    15de:	452080e7          	jalr	1106(ra) # 5a2c <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    15e2:	fb844703          	lbu	a4,-72(s0)
    15e6:	04f00793          	li	a5,79
    15ea:	00f71863          	bne	a4,a5,15fa <exectest+0x1b6>
    15ee:	fb944703          	lbu	a4,-71(s0)
    15f2:	04b00793          	li	a5,75
    15f6:	02f70063          	beq	a4,a5,1616 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    15fa:	85ca                	mv	a1,s2
    15fc:	00005517          	auipc	a0,0x5
    1600:	16c50513          	addi	a0,a0,364 # 6768 <malloc+0x942>
    1604:	00004097          	auipc	ra,0x4
    1608:	76a080e7          	jalr	1898(ra) # 5d6e <printf>
    exit(1);
    160c:	4505                	li	a0,1
    160e:	00004097          	auipc	ra,0x4
    1612:	3ce080e7          	jalr	974(ra) # 59dc <exit>
    exit(0);
    1616:	4501                	li	a0,0
    1618:	00004097          	auipc	ra,0x4
    161c:	3c4080e7          	jalr	964(ra) # 59dc <exit>

0000000000001620 <pipe1>:
{
    1620:	711d                	addi	sp,sp,-96
    1622:	ec86                	sd	ra,88(sp)
    1624:	e8a2                	sd	s0,80(sp)
    1626:	e4a6                	sd	s1,72(sp)
    1628:	e0ca                	sd	s2,64(sp)
    162a:	fc4e                	sd	s3,56(sp)
    162c:	f852                	sd	s4,48(sp)
    162e:	f456                	sd	s5,40(sp)
    1630:	f05a                	sd	s6,32(sp)
    1632:	ec5e                	sd	s7,24(sp)
    1634:	1080                	addi	s0,sp,96
    1636:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1638:	fa840513          	addi	a0,s0,-88
    163c:	00004097          	auipc	ra,0x4
    1640:	3b0080e7          	jalr	944(ra) # 59ec <pipe>
    1644:	e93d                	bnez	a0,16ba <pipe1+0x9a>
    1646:	84aa                	mv	s1,a0
  pid = fork();
    1648:	00004097          	auipc	ra,0x4
    164c:	38c080e7          	jalr	908(ra) # 59d4 <fork>
    1650:	8a2a                	mv	s4,a0
  if(pid == 0){
    1652:	c151                	beqz	a0,16d6 <pipe1+0xb6>
  } else if(pid > 0){
    1654:	16a05d63          	blez	a0,17ce <pipe1+0x1ae>
    close(fds[1]);
    1658:	fac42503          	lw	a0,-84(s0)
    165c:	00004097          	auipc	ra,0x4
    1660:	3a8080e7          	jalr	936(ra) # 5a04 <close>
    total = 0;
    1664:	8a26                	mv	s4,s1
    cc = 1;
    1666:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1668:	0000ba97          	auipc	s5,0xb
    166c:	600a8a93          	addi	s5,s5,1536 # cc68 <buf>
      if(cc > sizeof(buf))
    1670:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1672:	864e                	mv	a2,s3
    1674:	85d6                	mv	a1,s5
    1676:	fa842503          	lw	a0,-88(s0)
    167a:	00004097          	auipc	ra,0x4
    167e:	37a080e7          	jalr	890(ra) # 59f4 <read>
    1682:	10a05163          	blez	a0,1784 <pipe1+0x164>
      for(i = 0; i < n; i++){
    1686:	0000b717          	auipc	a4,0xb
    168a:	5e270713          	addi	a4,a4,1506 # cc68 <buf>
    168e:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1692:	00074683          	lbu	a3,0(a4)
    1696:	0ff4f793          	zext.b	a5,s1
    169a:	2485                	addiw	s1,s1,1
    169c:	0cf69063          	bne	a3,a5,175c <pipe1+0x13c>
      for(i = 0; i < n; i++){
    16a0:	0705                	addi	a4,a4,1
    16a2:	fec498e3          	bne	s1,a2,1692 <pipe1+0x72>
      total += n;
    16a6:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    16aa:	0019979b          	slliw	a5,s3,0x1
    16ae:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    16b2:	fd3b70e3          	bgeu	s6,s3,1672 <pipe1+0x52>
        cc = sizeof(buf);
    16b6:	89da                	mv	s3,s6
    16b8:	bf6d                	j	1672 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    16ba:	85ca                	mv	a1,s2
    16bc:	00005517          	auipc	a0,0x5
    16c0:	0c450513          	addi	a0,a0,196 # 6780 <malloc+0x95a>
    16c4:	00004097          	auipc	ra,0x4
    16c8:	6aa080e7          	jalr	1706(ra) # 5d6e <printf>
    exit(1);
    16cc:	4505                	li	a0,1
    16ce:	00004097          	auipc	ra,0x4
    16d2:	30e080e7          	jalr	782(ra) # 59dc <exit>
    close(fds[0]);
    16d6:	fa842503          	lw	a0,-88(s0)
    16da:	00004097          	auipc	ra,0x4
    16de:	32a080e7          	jalr	810(ra) # 5a04 <close>
    for(n = 0; n < N; n++){
    16e2:	0000bb17          	auipc	s6,0xb
    16e6:	586b0b13          	addi	s6,s6,1414 # cc68 <buf>
    16ea:	416004bb          	negw	s1,s6
    16ee:	0ff4f493          	zext.b	s1,s1
    16f2:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    16f6:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    16f8:	6a85                	lui	s5,0x1
    16fa:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x1a3>
{
    16fe:	87da                	mv	a5,s6
        buf[i] = seq++;
    1700:	0097873b          	addw	a4,a5,s1
    1704:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1708:	0785                	addi	a5,a5,1
    170a:	fef99be3          	bne	s3,a5,1700 <pipe1+0xe0>
        buf[i] = seq++;
    170e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1712:	40900613          	li	a2,1033
    1716:	85de                	mv	a1,s7
    1718:	fac42503          	lw	a0,-84(s0)
    171c:	00004097          	auipc	ra,0x4
    1720:	2e0080e7          	jalr	736(ra) # 59fc <write>
    1724:	40900793          	li	a5,1033
    1728:	00f51c63          	bne	a0,a5,1740 <pipe1+0x120>
    for(n = 0; n < N; n++){
    172c:	24a5                	addiw	s1,s1,9
    172e:	0ff4f493          	zext.b	s1,s1
    1732:	fd5a16e3          	bne	s4,s5,16fe <pipe1+0xde>
    exit(0);
    1736:	4501                	li	a0,0
    1738:	00004097          	auipc	ra,0x4
    173c:	2a4080e7          	jalr	676(ra) # 59dc <exit>
        printf("%s: pipe1 oops 1\n", s);
    1740:	85ca                	mv	a1,s2
    1742:	00005517          	auipc	a0,0x5
    1746:	05650513          	addi	a0,a0,86 # 6798 <malloc+0x972>
    174a:	00004097          	auipc	ra,0x4
    174e:	624080e7          	jalr	1572(ra) # 5d6e <printf>
        exit(1);
    1752:	4505                	li	a0,1
    1754:	00004097          	auipc	ra,0x4
    1758:	288080e7          	jalr	648(ra) # 59dc <exit>
          printf("%s: pipe1 oops 2\n", s);
    175c:	85ca                	mv	a1,s2
    175e:	00005517          	auipc	a0,0x5
    1762:	05250513          	addi	a0,a0,82 # 67b0 <malloc+0x98a>
    1766:	00004097          	auipc	ra,0x4
    176a:	608080e7          	jalr	1544(ra) # 5d6e <printf>
}
    176e:	60e6                	ld	ra,88(sp)
    1770:	6446                	ld	s0,80(sp)
    1772:	64a6                	ld	s1,72(sp)
    1774:	6906                	ld	s2,64(sp)
    1776:	79e2                	ld	s3,56(sp)
    1778:	7a42                	ld	s4,48(sp)
    177a:	7aa2                	ld	s5,40(sp)
    177c:	7b02                	ld	s6,32(sp)
    177e:	6be2                	ld	s7,24(sp)
    1780:	6125                	addi	sp,sp,96
    1782:	8082                	ret
    if(total != N * SZ){
    1784:	6785                	lui	a5,0x1
    1786:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x1a3>
    178a:	02fa0063          	beq	s4,a5,17aa <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    178e:	85d2                	mv	a1,s4
    1790:	00005517          	auipc	a0,0x5
    1794:	03850513          	addi	a0,a0,56 # 67c8 <malloc+0x9a2>
    1798:	00004097          	auipc	ra,0x4
    179c:	5d6080e7          	jalr	1494(ra) # 5d6e <printf>
      exit(1);
    17a0:	4505                	li	a0,1
    17a2:	00004097          	auipc	ra,0x4
    17a6:	23a080e7          	jalr	570(ra) # 59dc <exit>
    close(fds[0]);
    17aa:	fa842503          	lw	a0,-88(s0)
    17ae:	00004097          	auipc	ra,0x4
    17b2:	256080e7          	jalr	598(ra) # 5a04 <close>
    wait(&xstatus);
    17b6:	fa440513          	addi	a0,s0,-92
    17ba:	00004097          	auipc	ra,0x4
    17be:	22a080e7          	jalr	554(ra) # 59e4 <wait>
    exit(xstatus);
    17c2:	fa442503          	lw	a0,-92(s0)
    17c6:	00004097          	auipc	ra,0x4
    17ca:	216080e7          	jalr	534(ra) # 59dc <exit>
    printf("%s: fork() failed\n", s);
    17ce:	85ca                	mv	a1,s2
    17d0:	00005517          	auipc	a0,0x5
    17d4:	01850513          	addi	a0,a0,24 # 67e8 <malloc+0x9c2>
    17d8:	00004097          	auipc	ra,0x4
    17dc:	596080e7          	jalr	1430(ra) # 5d6e <printf>
    exit(1);
    17e0:	4505                	li	a0,1
    17e2:	00004097          	auipc	ra,0x4
    17e6:	1fa080e7          	jalr	506(ra) # 59dc <exit>

00000000000017ea <exitwait>:
{
    17ea:	7139                	addi	sp,sp,-64
    17ec:	fc06                	sd	ra,56(sp)
    17ee:	f822                	sd	s0,48(sp)
    17f0:	f426                	sd	s1,40(sp)
    17f2:	f04a                	sd	s2,32(sp)
    17f4:	ec4e                	sd	s3,24(sp)
    17f6:	e852                	sd	s4,16(sp)
    17f8:	0080                	addi	s0,sp,64
    17fa:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    17fc:	4901                	li	s2,0
    17fe:	06400993          	li	s3,100
    pid = fork();
    1802:	00004097          	auipc	ra,0x4
    1806:	1d2080e7          	jalr	466(ra) # 59d4 <fork>
    180a:	84aa                	mv	s1,a0
    if(pid < 0){
    180c:	02054a63          	bltz	a0,1840 <exitwait+0x56>
    if(pid){
    1810:	c151                	beqz	a0,1894 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1812:	fcc40513          	addi	a0,s0,-52
    1816:	00004097          	auipc	ra,0x4
    181a:	1ce080e7          	jalr	462(ra) # 59e4 <wait>
    181e:	02951f63          	bne	a0,s1,185c <exitwait+0x72>
      if(i != xstate) {
    1822:	fcc42783          	lw	a5,-52(s0)
    1826:	05279963          	bne	a5,s2,1878 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    182a:	2905                	addiw	s2,s2,1
    182c:	fd391be3          	bne	s2,s3,1802 <exitwait+0x18>
}
    1830:	70e2                	ld	ra,56(sp)
    1832:	7442                	ld	s0,48(sp)
    1834:	74a2                	ld	s1,40(sp)
    1836:	7902                	ld	s2,32(sp)
    1838:	69e2                	ld	s3,24(sp)
    183a:	6a42                	ld	s4,16(sp)
    183c:	6121                	addi	sp,sp,64
    183e:	8082                	ret
      printf("%s: fork failed\n", s);
    1840:	85d2                	mv	a1,s4
    1842:	00005517          	auipc	a0,0x5
    1846:	e3650513          	addi	a0,a0,-458 # 6678 <malloc+0x852>
    184a:	00004097          	auipc	ra,0x4
    184e:	524080e7          	jalr	1316(ra) # 5d6e <printf>
      exit(1);
    1852:	4505                	li	a0,1
    1854:	00004097          	auipc	ra,0x4
    1858:	188080e7          	jalr	392(ra) # 59dc <exit>
        printf("%s: wait wrong pid\n", s);
    185c:	85d2                	mv	a1,s4
    185e:	00005517          	auipc	a0,0x5
    1862:	fa250513          	addi	a0,a0,-94 # 6800 <malloc+0x9da>
    1866:	00004097          	auipc	ra,0x4
    186a:	508080e7          	jalr	1288(ra) # 5d6e <printf>
        exit(1);
    186e:	4505                	li	a0,1
    1870:	00004097          	auipc	ra,0x4
    1874:	16c080e7          	jalr	364(ra) # 59dc <exit>
        printf("%s: wait wrong exit status\n", s);
    1878:	85d2                	mv	a1,s4
    187a:	00005517          	auipc	a0,0x5
    187e:	f9e50513          	addi	a0,a0,-98 # 6818 <malloc+0x9f2>
    1882:	00004097          	auipc	ra,0x4
    1886:	4ec080e7          	jalr	1260(ra) # 5d6e <printf>
        exit(1);
    188a:	4505                	li	a0,1
    188c:	00004097          	auipc	ra,0x4
    1890:	150080e7          	jalr	336(ra) # 59dc <exit>
      exit(i);
    1894:	854a                	mv	a0,s2
    1896:	00004097          	auipc	ra,0x4
    189a:	146080e7          	jalr	326(ra) # 59dc <exit>

000000000000189e <twochildren>:
{
    189e:	1101                	addi	sp,sp,-32
    18a0:	ec06                	sd	ra,24(sp)
    18a2:	e822                	sd	s0,16(sp)
    18a4:	e426                	sd	s1,8(sp)
    18a6:	e04a                	sd	s2,0(sp)
    18a8:	1000                	addi	s0,sp,32
    18aa:	892a                	mv	s2,a0
    18ac:	3e800493          	li	s1,1000
    int pid1 = fork();
    18b0:	00004097          	auipc	ra,0x4
    18b4:	124080e7          	jalr	292(ra) # 59d4 <fork>
    if(pid1 < 0){
    18b8:	02054c63          	bltz	a0,18f0 <twochildren+0x52>
    if(pid1 == 0){
    18bc:	c921                	beqz	a0,190c <twochildren+0x6e>
      int pid2 = fork();
    18be:	00004097          	auipc	ra,0x4
    18c2:	116080e7          	jalr	278(ra) # 59d4 <fork>
      if(pid2 < 0){
    18c6:	04054763          	bltz	a0,1914 <twochildren+0x76>
      if(pid2 == 0){
    18ca:	c13d                	beqz	a0,1930 <twochildren+0x92>
        wait(0);
    18cc:	4501                	li	a0,0
    18ce:	00004097          	auipc	ra,0x4
    18d2:	116080e7          	jalr	278(ra) # 59e4 <wait>
        wait(0);
    18d6:	4501                	li	a0,0
    18d8:	00004097          	auipc	ra,0x4
    18dc:	10c080e7          	jalr	268(ra) # 59e4 <wait>
  for(int i = 0; i < 1000; i++){
    18e0:	34fd                	addiw	s1,s1,-1
    18e2:	f4f9                	bnez	s1,18b0 <twochildren+0x12>
}
    18e4:	60e2                	ld	ra,24(sp)
    18e6:	6442                	ld	s0,16(sp)
    18e8:	64a2                	ld	s1,8(sp)
    18ea:	6902                	ld	s2,0(sp)
    18ec:	6105                	addi	sp,sp,32
    18ee:	8082                	ret
      printf("%s: fork failed\n", s);
    18f0:	85ca                	mv	a1,s2
    18f2:	00005517          	auipc	a0,0x5
    18f6:	d8650513          	addi	a0,a0,-634 # 6678 <malloc+0x852>
    18fa:	00004097          	auipc	ra,0x4
    18fe:	474080e7          	jalr	1140(ra) # 5d6e <printf>
      exit(1);
    1902:	4505                	li	a0,1
    1904:	00004097          	auipc	ra,0x4
    1908:	0d8080e7          	jalr	216(ra) # 59dc <exit>
      exit(0);
    190c:	00004097          	auipc	ra,0x4
    1910:	0d0080e7          	jalr	208(ra) # 59dc <exit>
        printf("%s: fork failed\n", s);
    1914:	85ca                	mv	a1,s2
    1916:	00005517          	auipc	a0,0x5
    191a:	d6250513          	addi	a0,a0,-670 # 6678 <malloc+0x852>
    191e:	00004097          	auipc	ra,0x4
    1922:	450080e7          	jalr	1104(ra) # 5d6e <printf>
        exit(1);
    1926:	4505                	li	a0,1
    1928:	00004097          	auipc	ra,0x4
    192c:	0b4080e7          	jalr	180(ra) # 59dc <exit>
        exit(0);
    1930:	00004097          	auipc	ra,0x4
    1934:	0ac080e7          	jalr	172(ra) # 59dc <exit>

0000000000001938 <forkfork>:
{
    1938:	7179                	addi	sp,sp,-48
    193a:	f406                	sd	ra,40(sp)
    193c:	f022                	sd	s0,32(sp)
    193e:	ec26                	sd	s1,24(sp)
    1940:	1800                	addi	s0,sp,48
    1942:	84aa                	mv	s1,a0
    int pid = fork();
    1944:	00004097          	auipc	ra,0x4
    1948:	090080e7          	jalr	144(ra) # 59d4 <fork>
    if(pid < 0){
    194c:	04054163          	bltz	a0,198e <forkfork+0x56>
    if(pid == 0){
    1950:	cd29                	beqz	a0,19aa <forkfork+0x72>
    int pid = fork();
    1952:	00004097          	auipc	ra,0x4
    1956:	082080e7          	jalr	130(ra) # 59d4 <fork>
    if(pid < 0){
    195a:	02054a63          	bltz	a0,198e <forkfork+0x56>
    if(pid == 0){
    195e:	c531                	beqz	a0,19aa <forkfork+0x72>
    wait(&xstatus);
    1960:	fdc40513          	addi	a0,s0,-36
    1964:	00004097          	auipc	ra,0x4
    1968:	080080e7          	jalr	128(ra) # 59e4 <wait>
    if(xstatus != 0) {
    196c:	fdc42783          	lw	a5,-36(s0)
    1970:	ebbd                	bnez	a5,19e6 <forkfork+0xae>
    wait(&xstatus);
    1972:	fdc40513          	addi	a0,s0,-36
    1976:	00004097          	auipc	ra,0x4
    197a:	06e080e7          	jalr	110(ra) # 59e4 <wait>
    if(xstatus != 0) {
    197e:	fdc42783          	lw	a5,-36(s0)
    1982:	e3b5                	bnez	a5,19e6 <forkfork+0xae>
}
    1984:	70a2                	ld	ra,40(sp)
    1986:	7402                	ld	s0,32(sp)
    1988:	64e2                	ld	s1,24(sp)
    198a:	6145                	addi	sp,sp,48
    198c:	8082                	ret
      printf("%s: fork failed", s);
    198e:	85a6                	mv	a1,s1
    1990:	00005517          	auipc	a0,0x5
    1994:	ea850513          	addi	a0,a0,-344 # 6838 <malloc+0xa12>
    1998:	00004097          	auipc	ra,0x4
    199c:	3d6080e7          	jalr	982(ra) # 5d6e <printf>
      exit(1);
    19a0:	4505                	li	a0,1
    19a2:	00004097          	auipc	ra,0x4
    19a6:	03a080e7          	jalr	58(ra) # 59dc <exit>
{
    19aa:	0c800493          	li	s1,200
        int pid1 = fork();
    19ae:	00004097          	auipc	ra,0x4
    19b2:	026080e7          	jalr	38(ra) # 59d4 <fork>
        if(pid1 < 0){
    19b6:	00054f63          	bltz	a0,19d4 <forkfork+0x9c>
        if(pid1 == 0){
    19ba:	c115                	beqz	a0,19de <forkfork+0xa6>
        wait(0);
    19bc:	4501                	li	a0,0
    19be:	00004097          	auipc	ra,0x4
    19c2:	026080e7          	jalr	38(ra) # 59e4 <wait>
      for(int j = 0; j < 200; j++){
    19c6:	34fd                	addiw	s1,s1,-1
    19c8:	f0fd                	bnez	s1,19ae <forkfork+0x76>
      exit(0);
    19ca:	4501                	li	a0,0
    19cc:	00004097          	auipc	ra,0x4
    19d0:	010080e7          	jalr	16(ra) # 59dc <exit>
          exit(1);
    19d4:	4505                	li	a0,1
    19d6:	00004097          	auipc	ra,0x4
    19da:	006080e7          	jalr	6(ra) # 59dc <exit>
          exit(0);
    19de:	00004097          	auipc	ra,0x4
    19e2:	ffe080e7          	jalr	-2(ra) # 59dc <exit>
      printf("%s: fork in child failed", s);
    19e6:	85a6                	mv	a1,s1
    19e8:	00005517          	auipc	a0,0x5
    19ec:	e6050513          	addi	a0,a0,-416 # 6848 <malloc+0xa22>
    19f0:	00004097          	auipc	ra,0x4
    19f4:	37e080e7          	jalr	894(ra) # 5d6e <printf>
      exit(1);
    19f8:	4505                	li	a0,1
    19fa:	00004097          	auipc	ra,0x4
    19fe:	fe2080e7          	jalr	-30(ra) # 59dc <exit>

0000000000001a02 <reparent2>:
{
    1a02:	1101                	addi	sp,sp,-32
    1a04:	ec06                	sd	ra,24(sp)
    1a06:	e822                	sd	s0,16(sp)
    1a08:	e426                	sd	s1,8(sp)
    1a0a:	1000                	addi	s0,sp,32
    1a0c:	32000493          	li	s1,800
    int pid1 = fork();
    1a10:	00004097          	auipc	ra,0x4
    1a14:	fc4080e7          	jalr	-60(ra) # 59d4 <fork>
    if(pid1 < 0){
    1a18:	00054f63          	bltz	a0,1a36 <reparent2+0x34>
    if(pid1 == 0){
    1a1c:	c915                	beqz	a0,1a50 <reparent2+0x4e>
    wait(0);
    1a1e:	4501                	li	a0,0
    1a20:	00004097          	auipc	ra,0x4
    1a24:	fc4080e7          	jalr	-60(ra) # 59e4 <wait>
  for(int i = 0; i < 800; i++){
    1a28:	34fd                	addiw	s1,s1,-1
    1a2a:	f0fd                	bnez	s1,1a10 <reparent2+0xe>
  exit(0);
    1a2c:	4501                	li	a0,0
    1a2e:	00004097          	auipc	ra,0x4
    1a32:	fae080e7          	jalr	-82(ra) # 59dc <exit>
      printf("fork failed\n");
    1a36:	00005517          	auipc	a0,0x5
    1a3a:	04a50513          	addi	a0,a0,74 # 6a80 <malloc+0xc5a>
    1a3e:	00004097          	auipc	ra,0x4
    1a42:	330080e7          	jalr	816(ra) # 5d6e <printf>
      exit(1);
    1a46:	4505                	li	a0,1
    1a48:	00004097          	auipc	ra,0x4
    1a4c:	f94080e7          	jalr	-108(ra) # 59dc <exit>
      fork();
    1a50:	00004097          	auipc	ra,0x4
    1a54:	f84080e7          	jalr	-124(ra) # 59d4 <fork>
      fork();
    1a58:	00004097          	auipc	ra,0x4
    1a5c:	f7c080e7          	jalr	-132(ra) # 59d4 <fork>
      exit(0);
    1a60:	4501                	li	a0,0
    1a62:	00004097          	auipc	ra,0x4
    1a66:	f7a080e7          	jalr	-134(ra) # 59dc <exit>

0000000000001a6a <createdelete>:
{
    1a6a:	7175                	addi	sp,sp,-144
    1a6c:	e506                	sd	ra,136(sp)
    1a6e:	e122                	sd	s0,128(sp)
    1a70:	fca6                	sd	s1,120(sp)
    1a72:	f8ca                	sd	s2,112(sp)
    1a74:	f4ce                	sd	s3,104(sp)
    1a76:	f0d2                	sd	s4,96(sp)
    1a78:	ecd6                	sd	s5,88(sp)
    1a7a:	e8da                	sd	s6,80(sp)
    1a7c:	e4de                	sd	s7,72(sp)
    1a7e:	e0e2                	sd	s8,64(sp)
    1a80:	fc66                	sd	s9,56(sp)
    1a82:	0900                	addi	s0,sp,144
    1a84:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1a86:	4901                	li	s2,0
    1a88:	4991                	li	s3,4
    pid = fork();
    1a8a:	00004097          	auipc	ra,0x4
    1a8e:	f4a080e7          	jalr	-182(ra) # 59d4 <fork>
    1a92:	84aa                	mv	s1,a0
    if(pid < 0){
    1a94:	02054f63          	bltz	a0,1ad2 <createdelete+0x68>
    if(pid == 0){
    1a98:	c939                	beqz	a0,1aee <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1a9a:	2905                	addiw	s2,s2,1
    1a9c:	ff3917e3          	bne	s2,s3,1a8a <createdelete+0x20>
    1aa0:	4491                	li	s1,4
    wait(&xstatus);
    1aa2:	f7c40513          	addi	a0,s0,-132
    1aa6:	00004097          	auipc	ra,0x4
    1aaa:	f3e080e7          	jalr	-194(ra) # 59e4 <wait>
    if(xstatus != 0)
    1aae:	f7c42903          	lw	s2,-132(s0)
    1ab2:	0e091263          	bnez	s2,1b96 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1ab6:	34fd                	addiw	s1,s1,-1
    1ab8:	f4ed                	bnez	s1,1aa2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1aba:	f8040123          	sb	zero,-126(s0)
    1abe:	03000993          	li	s3,48
    1ac2:	5a7d                	li	s4,-1
    1ac4:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ac8:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1aca:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1acc:	07400a93          	li	s5,116
    1ad0:	a29d                	j	1c36 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1ad2:	85e6                	mv	a1,s9
    1ad4:	00005517          	auipc	a0,0x5
    1ad8:	fac50513          	addi	a0,a0,-84 # 6a80 <malloc+0xc5a>
    1adc:	00004097          	auipc	ra,0x4
    1ae0:	292080e7          	jalr	658(ra) # 5d6e <printf>
      exit(1);
    1ae4:	4505                	li	a0,1
    1ae6:	00004097          	auipc	ra,0x4
    1aea:	ef6080e7          	jalr	-266(ra) # 59dc <exit>
      name[0] = 'p' + pi;
    1aee:	0709091b          	addiw	s2,s2,112
    1af2:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1af6:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1afa:	4951                	li	s2,20
    1afc:	a015                	j	1b20 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1afe:	85e6                	mv	a1,s9
    1b00:	00005517          	auipc	a0,0x5
    1b04:	c1050513          	addi	a0,a0,-1008 # 6710 <malloc+0x8ea>
    1b08:	00004097          	auipc	ra,0x4
    1b0c:	266080e7          	jalr	614(ra) # 5d6e <printf>
          exit(1);
    1b10:	4505                	li	a0,1
    1b12:	00004097          	auipc	ra,0x4
    1b16:	eca080e7          	jalr	-310(ra) # 59dc <exit>
      for(i = 0; i < N; i++){
    1b1a:	2485                	addiw	s1,s1,1
    1b1c:	07248863          	beq	s1,s2,1b8c <createdelete+0x122>
        name[1] = '0' + i;
    1b20:	0304879b          	addiw	a5,s1,48
    1b24:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1b28:	20200593          	li	a1,514
    1b2c:	f8040513          	addi	a0,s0,-128
    1b30:	00004097          	auipc	ra,0x4
    1b34:	eec080e7          	jalr	-276(ra) # 5a1c <open>
        if(fd < 0){
    1b38:	fc0543e3          	bltz	a0,1afe <createdelete+0x94>
        close(fd);
    1b3c:	00004097          	auipc	ra,0x4
    1b40:	ec8080e7          	jalr	-312(ra) # 5a04 <close>
        if(i > 0 && (i % 2 ) == 0){
    1b44:	fc905be3          	blez	s1,1b1a <createdelete+0xb0>
    1b48:	0014f793          	andi	a5,s1,1
    1b4c:	f7f9                	bnez	a5,1b1a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1b4e:	01f4d79b          	srliw	a5,s1,0x1f
    1b52:	9fa5                	addw	a5,a5,s1
    1b54:	4017d79b          	sraiw	a5,a5,0x1
    1b58:	0307879b          	addiw	a5,a5,48
    1b5c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1b60:	f8040513          	addi	a0,s0,-128
    1b64:	00004097          	auipc	ra,0x4
    1b68:	ec8080e7          	jalr	-312(ra) # 5a2c <unlink>
    1b6c:	fa0557e3          	bgez	a0,1b1a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1b70:	85e6                	mv	a1,s9
    1b72:	00005517          	auipc	a0,0x5
    1b76:	cf650513          	addi	a0,a0,-778 # 6868 <malloc+0xa42>
    1b7a:	00004097          	auipc	ra,0x4
    1b7e:	1f4080e7          	jalr	500(ra) # 5d6e <printf>
            exit(1);
    1b82:	4505                	li	a0,1
    1b84:	00004097          	auipc	ra,0x4
    1b88:	e58080e7          	jalr	-424(ra) # 59dc <exit>
      exit(0);
    1b8c:	4501                	li	a0,0
    1b8e:	00004097          	auipc	ra,0x4
    1b92:	e4e080e7          	jalr	-434(ra) # 59dc <exit>
      exit(1);
    1b96:	4505                	li	a0,1
    1b98:	00004097          	auipc	ra,0x4
    1b9c:	e44080e7          	jalr	-444(ra) # 59dc <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ba0:	f8040613          	addi	a2,s0,-128
    1ba4:	85e6                	mv	a1,s9
    1ba6:	00005517          	auipc	a0,0x5
    1baa:	cda50513          	addi	a0,a0,-806 # 6880 <malloc+0xa5a>
    1bae:	00004097          	auipc	ra,0x4
    1bb2:	1c0080e7          	jalr	448(ra) # 5d6e <printf>
        exit(1);
    1bb6:	4505                	li	a0,1
    1bb8:	00004097          	auipc	ra,0x4
    1bbc:	e24080e7          	jalr	-476(ra) # 59dc <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bc0:	054b7163          	bgeu	s6,s4,1c02 <createdelete+0x198>
      if(fd >= 0)
    1bc4:	02055a63          	bgez	a0,1bf8 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1bc8:	2485                	addiw	s1,s1,1
    1bca:	0ff4f493          	zext.b	s1,s1
    1bce:	05548c63          	beq	s1,s5,1c26 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1bd2:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1bd6:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1bda:	4581                	li	a1,0
    1bdc:	f8040513          	addi	a0,s0,-128
    1be0:	00004097          	auipc	ra,0x4
    1be4:	e3c080e7          	jalr	-452(ra) # 5a1c <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1be8:	00090463          	beqz	s2,1bf0 <createdelete+0x186>
    1bec:	fd2bdae3          	bge	s7,s2,1bc0 <createdelete+0x156>
    1bf0:	fa0548e3          	bltz	a0,1ba0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bf4:	014b7963          	bgeu	s6,s4,1c06 <createdelete+0x19c>
        close(fd);
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	e0c080e7          	jalr	-500(ra) # 5a04 <close>
    1c00:	b7e1                	j	1bc8 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c02:	fc0543e3          	bltz	a0,1bc8 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1c06:	f8040613          	addi	a2,s0,-128
    1c0a:	85e6                	mv	a1,s9
    1c0c:	00005517          	auipc	a0,0x5
    1c10:	c9c50513          	addi	a0,a0,-868 # 68a8 <malloc+0xa82>
    1c14:	00004097          	auipc	ra,0x4
    1c18:	15a080e7          	jalr	346(ra) # 5d6e <printf>
        exit(1);
    1c1c:	4505                	li	a0,1
    1c1e:	00004097          	auipc	ra,0x4
    1c22:	dbe080e7          	jalr	-578(ra) # 59dc <exit>
  for(i = 0; i < N; i++){
    1c26:	2905                	addiw	s2,s2,1
    1c28:	2a05                	addiw	s4,s4,1
    1c2a:	2985                	addiw	s3,s3,1
    1c2c:	0ff9f993          	zext.b	s3,s3
    1c30:	47d1                	li	a5,20
    1c32:	02f90a63          	beq	s2,a5,1c66 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1c36:	84e2                	mv	s1,s8
    1c38:	bf69                	j	1bd2 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1c3a:	2905                	addiw	s2,s2,1
    1c3c:	0ff97913          	zext.b	s2,s2
    1c40:	2985                	addiw	s3,s3,1
    1c42:	0ff9f993          	zext.b	s3,s3
    1c46:	03490863          	beq	s2,s4,1c76 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1c4a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1c4c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1c50:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1c54:	f8040513          	addi	a0,s0,-128
    1c58:	00004097          	auipc	ra,0x4
    1c5c:	dd4080e7          	jalr	-556(ra) # 5a2c <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1c60:	34fd                	addiw	s1,s1,-1
    1c62:	f4ed                	bnez	s1,1c4c <createdelete+0x1e2>
    1c64:	bfd9                	j	1c3a <createdelete+0x1d0>
    1c66:	03000993          	li	s3,48
    1c6a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1c6e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1c70:	08400a13          	li	s4,132
    1c74:	bfd9                	j	1c4a <createdelete+0x1e0>
}
    1c76:	60aa                	ld	ra,136(sp)
    1c78:	640a                	ld	s0,128(sp)
    1c7a:	74e6                	ld	s1,120(sp)
    1c7c:	7946                	ld	s2,112(sp)
    1c7e:	79a6                	ld	s3,104(sp)
    1c80:	7a06                	ld	s4,96(sp)
    1c82:	6ae6                	ld	s5,88(sp)
    1c84:	6b46                	ld	s6,80(sp)
    1c86:	6ba6                	ld	s7,72(sp)
    1c88:	6c06                	ld	s8,64(sp)
    1c8a:	7ce2                	ld	s9,56(sp)
    1c8c:	6149                	addi	sp,sp,144
    1c8e:	8082                	ret

0000000000001c90 <linkunlink>:
{
    1c90:	711d                	addi	sp,sp,-96
    1c92:	ec86                	sd	ra,88(sp)
    1c94:	e8a2                	sd	s0,80(sp)
    1c96:	e4a6                	sd	s1,72(sp)
    1c98:	e0ca                	sd	s2,64(sp)
    1c9a:	fc4e                	sd	s3,56(sp)
    1c9c:	f852                	sd	s4,48(sp)
    1c9e:	f456                	sd	s5,40(sp)
    1ca0:	f05a                	sd	s6,32(sp)
    1ca2:	ec5e                	sd	s7,24(sp)
    1ca4:	e862                	sd	s8,16(sp)
    1ca6:	e466                	sd	s9,8(sp)
    1ca8:	1080                	addi	s0,sp,96
    1caa:	84aa                	mv	s1,a0
  unlink("x");
    1cac:	00004517          	auipc	a0,0x4
    1cb0:	30c50513          	addi	a0,a0,780 # 5fb8 <malloc+0x192>
    1cb4:	00004097          	auipc	ra,0x4
    1cb8:	d78080e7          	jalr	-648(ra) # 5a2c <unlink>
  pid = fork();
    1cbc:	00004097          	auipc	ra,0x4
    1cc0:	d18080e7          	jalr	-744(ra) # 59d4 <fork>
  if(pid < 0){
    1cc4:	02054b63          	bltz	a0,1cfa <linkunlink+0x6a>
    1cc8:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1cca:	4c85                	li	s9,1
    1ccc:	e119                	bnez	a0,1cd2 <linkunlink+0x42>
    1cce:	06100c93          	li	s9,97
    1cd2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1cd6:	41c659b7          	lui	s3,0x41c65
    1cda:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <base+0x41c55205>
    1cde:	690d                	lui	s2,0x3
    1ce0:	0399091b          	addiw	s2,s2,57 # 3039 <diskfull+0x1e1>
    if((x % 3) == 0){
    1ce4:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1ce6:	4b05                	li	s6,1
      unlink("x");
    1ce8:	00004a97          	auipc	s5,0x4
    1cec:	2d0a8a93          	addi	s5,s5,720 # 5fb8 <malloc+0x192>
      link("cat", "x");
    1cf0:	00005b97          	auipc	s7,0x5
    1cf4:	be0b8b93          	addi	s7,s7,-1056 # 68d0 <malloc+0xaaa>
    1cf8:	a825                	j	1d30 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1cfa:	85a6                	mv	a1,s1
    1cfc:	00005517          	auipc	a0,0x5
    1d00:	97c50513          	addi	a0,a0,-1668 # 6678 <malloc+0x852>
    1d04:	00004097          	auipc	ra,0x4
    1d08:	06a080e7          	jalr	106(ra) # 5d6e <printf>
    exit(1);
    1d0c:	4505                	li	a0,1
    1d0e:	00004097          	auipc	ra,0x4
    1d12:	cce080e7          	jalr	-818(ra) # 59dc <exit>
      close(open("x", O_RDWR | O_CREATE));
    1d16:	20200593          	li	a1,514
    1d1a:	8556                	mv	a0,s5
    1d1c:	00004097          	auipc	ra,0x4
    1d20:	d00080e7          	jalr	-768(ra) # 5a1c <open>
    1d24:	00004097          	auipc	ra,0x4
    1d28:	ce0080e7          	jalr	-800(ra) # 5a04 <close>
  for(i = 0; i < 100; i++){
    1d2c:	34fd                	addiw	s1,s1,-1
    1d2e:	c88d                	beqz	s1,1d60 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1d30:	033c87bb          	mulw	a5,s9,s3
    1d34:	012787bb          	addw	a5,a5,s2
    1d38:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1d3c:	0347f7bb          	remuw	a5,a5,s4
    1d40:	dbf9                	beqz	a5,1d16 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1d42:	01678863          	beq	a5,s6,1d52 <linkunlink+0xc2>
      unlink("x");
    1d46:	8556                	mv	a0,s5
    1d48:	00004097          	auipc	ra,0x4
    1d4c:	ce4080e7          	jalr	-796(ra) # 5a2c <unlink>
    1d50:	bff1                	j	1d2c <linkunlink+0x9c>
      link("cat", "x");
    1d52:	85d6                	mv	a1,s5
    1d54:	855e                	mv	a0,s7
    1d56:	00004097          	auipc	ra,0x4
    1d5a:	ce6080e7          	jalr	-794(ra) # 5a3c <link>
    1d5e:	b7f9                	j	1d2c <linkunlink+0x9c>
  if(pid)
    1d60:	020c0463          	beqz	s8,1d88 <linkunlink+0xf8>
    wait(0);
    1d64:	4501                	li	a0,0
    1d66:	00004097          	auipc	ra,0x4
    1d6a:	c7e080e7          	jalr	-898(ra) # 59e4 <wait>
}
    1d6e:	60e6                	ld	ra,88(sp)
    1d70:	6446                	ld	s0,80(sp)
    1d72:	64a6                	ld	s1,72(sp)
    1d74:	6906                	ld	s2,64(sp)
    1d76:	79e2                	ld	s3,56(sp)
    1d78:	7a42                	ld	s4,48(sp)
    1d7a:	7aa2                	ld	s5,40(sp)
    1d7c:	7b02                	ld	s6,32(sp)
    1d7e:	6be2                	ld	s7,24(sp)
    1d80:	6c42                	ld	s8,16(sp)
    1d82:	6ca2                	ld	s9,8(sp)
    1d84:	6125                	addi	sp,sp,96
    1d86:	8082                	ret
    exit(0);
    1d88:	4501                	li	a0,0
    1d8a:	00004097          	auipc	ra,0x4
    1d8e:	c52080e7          	jalr	-942(ra) # 59dc <exit>

0000000000001d92 <forktest>:
{
    1d92:	7179                	addi	sp,sp,-48
    1d94:	f406                	sd	ra,40(sp)
    1d96:	f022                	sd	s0,32(sp)
    1d98:	ec26                	sd	s1,24(sp)
    1d9a:	e84a                	sd	s2,16(sp)
    1d9c:	e44e                	sd	s3,8(sp)
    1d9e:	1800                	addi	s0,sp,48
    1da0:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1da2:	4481                	li	s1,0
    1da4:	3e800913          	li	s2,1000
    pid = fork();
    1da8:	00004097          	auipc	ra,0x4
    1dac:	c2c080e7          	jalr	-980(ra) # 59d4 <fork>
    if(pid < 0)
    1db0:	02054863          	bltz	a0,1de0 <forktest+0x4e>
    if(pid == 0)
    1db4:	c115                	beqz	a0,1dd8 <forktest+0x46>
  for(n=0; n<N; n++){
    1db6:	2485                	addiw	s1,s1,1
    1db8:	ff2498e3          	bne	s1,s2,1da8 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1dbc:	85ce                	mv	a1,s3
    1dbe:	00005517          	auipc	a0,0x5
    1dc2:	b3250513          	addi	a0,a0,-1230 # 68f0 <malloc+0xaca>
    1dc6:	00004097          	auipc	ra,0x4
    1dca:	fa8080e7          	jalr	-88(ra) # 5d6e <printf>
    exit(1);
    1dce:	4505                	li	a0,1
    1dd0:	00004097          	auipc	ra,0x4
    1dd4:	c0c080e7          	jalr	-1012(ra) # 59dc <exit>
      exit(0);
    1dd8:	00004097          	auipc	ra,0x4
    1ddc:	c04080e7          	jalr	-1020(ra) # 59dc <exit>
  if (n == 0) {
    1de0:	cc9d                	beqz	s1,1e1e <forktest+0x8c>
  if(n == N){
    1de2:	3e800793          	li	a5,1000
    1de6:	fcf48be3          	beq	s1,a5,1dbc <forktest+0x2a>
  for(; n > 0; n--){
    1dea:	00905b63          	blez	s1,1e00 <forktest+0x6e>
    if(wait(0) < 0){
    1dee:	4501                	li	a0,0
    1df0:	00004097          	auipc	ra,0x4
    1df4:	bf4080e7          	jalr	-1036(ra) # 59e4 <wait>
    1df8:	04054163          	bltz	a0,1e3a <forktest+0xa8>
  for(; n > 0; n--){
    1dfc:	34fd                	addiw	s1,s1,-1
    1dfe:	f8e5                	bnez	s1,1dee <forktest+0x5c>
  if(wait(0) != -1){
    1e00:	4501                	li	a0,0
    1e02:	00004097          	auipc	ra,0x4
    1e06:	be2080e7          	jalr	-1054(ra) # 59e4 <wait>
    1e0a:	57fd                	li	a5,-1
    1e0c:	04f51563          	bne	a0,a5,1e56 <forktest+0xc4>
}
    1e10:	70a2                	ld	ra,40(sp)
    1e12:	7402                	ld	s0,32(sp)
    1e14:	64e2                	ld	s1,24(sp)
    1e16:	6942                	ld	s2,16(sp)
    1e18:	69a2                	ld	s3,8(sp)
    1e1a:	6145                	addi	sp,sp,48
    1e1c:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1e1e:	85ce                	mv	a1,s3
    1e20:	00005517          	auipc	a0,0x5
    1e24:	ab850513          	addi	a0,a0,-1352 # 68d8 <malloc+0xab2>
    1e28:	00004097          	auipc	ra,0x4
    1e2c:	f46080e7          	jalr	-186(ra) # 5d6e <printf>
    exit(1);
    1e30:	4505                	li	a0,1
    1e32:	00004097          	auipc	ra,0x4
    1e36:	baa080e7          	jalr	-1110(ra) # 59dc <exit>
      printf("%s: wait stopped early\n", s);
    1e3a:	85ce                	mv	a1,s3
    1e3c:	00005517          	auipc	a0,0x5
    1e40:	adc50513          	addi	a0,a0,-1316 # 6918 <malloc+0xaf2>
    1e44:	00004097          	auipc	ra,0x4
    1e48:	f2a080e7          	jalr	-214(ra) # 5d6e <printf>
      exit(1);
    1e4c:	4505                	li	a0,1
    1e4e:	00004097          	auipc	ra,0x4
    1e52:	b8e080e7          	jalr	-1138(ra) # 59dc <exit>
    printf("%s: wait got too many\n", s);
    1e56:	85ce                	mv	a1,s3
    1e58:	00005517          	auipc	a0,0x5
    1e5c:	ad850513          	addi	a0,a0,-1320 # 6930 <malloc+0xb0a>
    1e60:	00004097          	auipc	ra,0x4
    1e64:	f0e080e7          	jalr	-242(ra) # 5d6e <printf>
    exit(1);
    1e68:	4505                	li	a0,1
    1e6a:	00004097          	auipc	ra,0x4
    1e6e:	b72080e7          	jalr	-1166(ra) # 59dc <exit>

0000000000001e72 <kernmem>:
{
    1e72:	715d                	addi	sp,sp,-80
    1e74:	e486                	sd	ra,72(sp)
    1e76:	e0a2                	sd	s0,64(sp)
    1e78:	fc26                	sd	s1,56(sp)
    1e7a:	f84a                	sd	s2,48(sp)
    1e7c:	f44e                	sd	s3,40(sp)
    1e7e:	f052                	sd	s4,32(sp)
    1e80:	ec56                	sd	s5,24(sp)
    1e82:	0880                	addi	s0,sp,80
    1e84:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1e86:	4485                	li	s1,1
    1e88:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1e8a:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1e8c:	69b1                	lui	s3,0xc
    1e8e:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1df8>
    1e92:	1003d937          	lui	s2,0x1003d
    1e96:	090e                	slli	s2,s2,0x3
    1e98:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d818>
    pid = fork();
    1e9c:	00004097          	auipc	ra,0x4
    1ea0:	b38080e7          	jalr	-1224(ra) # 59d4 <fork>
    if(pid < 0){
    1ea4:	02054963          	bltz	a0,1ed6 <kernmem+0x64>
    if(pid == 0){
    1ea8:	c529                	beqz	a0,1ef2 <kernmem+0x80>
    wait(&xstatus);
    1eaa:	fbc40513          	addi	a0,s0,-68
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	b36080e7          	jalr	-1226(ra) # 59e4 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1eb6:	fbc42783          	lw	a5,-68(s0)
    1eba:	05579d63          	bne	a5,s5,1f14 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ebe:	94ce                	add	s1,s1,s3
    1ec0:	fd249ee3          	bne	s1,s2,1e9c <kernmem+0x2a>
}
    1ec4:	60a6                	ld	ra,72(sp)
    1ec6:	6406                	ld	s0,64(sp)
    1ec8:	74e2                	ld	s1,56(sp)
    1eca:	7942                	ld	s2,48(sp)
    1ecc:	79a2                	ld	s3,40(sp)
    1ece:	7a02                	ld	s4,32(sp)
    1ed0:	6ae2                	ld	s5,24(sp)
    1ed2:	6161                	addi	sp,sp,80
    1ed4:	8082                	ret
      printf("%s: fork failed\n", s);
    1ed6:	85d2                	mv	a1,s4
    1ed8:	00004517          	auipc	a0,0x4
    1edc:	7a050513          	addi	a0,a0,1952 # 6678 <malloc+0x852>
    1ee0:	00004097          	auipc	ra,0x4
    1ee4:	e8e080e7          	jalr	-370(ra) # 5d6e <printf>
      exit(1);
    1ee8:	4505                	li	a0,1
    1eea:	00004097          	auipc	ra,0x4
    1eee:	af2080e7          	jalr	-1294(ra) # 59dc <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    1ef2:	0004c683          	lbu	a3,0(s1)
    1ef6:	8626                	mv	a2,s1
    1ef8:	85d2                	mv	a1,s4
    1efa:	00005517          	auipc	a0,0x5
    1efe:	a4e50513          	addi	a0,a0,-1458 # 6948 <malloc+0xb22>
    1f02:	00004097          	auipc	ra,0x4
    1f06:	e6c080e7          	jalr	-404(ra) # 5d6e <printf>
      exit(1);
    1f0a:	4505                	li	a0,1
    1f0c:	00004097          	auipc	ra,0x4
    1f10:	ad0080e7          	jalr	-1328(ra) # 59dc <exit>
      exit(1);
    1f14:	4505                	li	a0,1
    1f16:	00004097          	auipc	ra,0x4
    1f1a:	ac6080e7          	jalr	-1338(ra) # 59dc <exit>

0000000000001f1e <MAXVAplus>:
{
    1f1e:	7179                	addi	sp,sp,-48
    1f20:	f406                	sd	ra,40(sp)
    1f22:	f022                	sd	s0,32(sp)
    1f24:	ec26                	sd	s1,24(sp)
    1f26:	e84a                	sd	s2,16(sp)
    1f28:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1f2a:	4785                	li	a5,1
    1f2c:	179a                	slli	a5,a5,0x26
    1f2e:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1f32:	fd843783          	ld	a5,-40(s0)
    1f36:	cf85                	beqz	a5,1f6e <MAXVAplus+0x50>
    1f38:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1f3a:	54fd                	li	s1,-1
    pid = fork();
    1f3c:	00004097          	auipc	ra,0x4
    1f40:	a98080e7          	jalr	-1384(ra) # 59d4 <fork>
    if(pid < 0){
    1f44:	02054b63          	bltz	a0,1f7a <MAXVAplus+0x5c>
    if(pid == 0){
    1f48:	c539                	beqz	a0,1f96 <MAXVAplus+0x78>
    wait(&xstatus);
    1f4a:	fd440513          	addi	a0,s0,-44
    1f4e:	00004097          	auipc	ra,0x4
    1f52:	a96080e7          	jalr	-1386(ra) # 59e4 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1f56:	fd442783          	lw	a5,-44(s0)
    1f5a:	06979463          	bne	a5,s1,1fc2 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    1f5e:	fd843783          	ld	a5,-40(s0)
    1f62:	0786                	slli	a5,a5,0x1
    1f64:	fcf43c23          	sd	a5,-40(s0)
    1f68:	fd843783          	ld	a5,-40(s0)
    1f6c:	fbe1                	bnez	a5,1f3c <MAXVAplus+0x1e>
}
    1f6e:	70a2                	ld	ra,40(sp)
    1f70:	7402                	ld	s0,32(sp)
    1f72:	64e2                	ld	s1,24(sp)
    1f74:	6942                	ld	s2,16(sp)
    1f76:	6145                	addi	sp,sp,48
    1f78:	8082                	ret
      printf("%s: fork failed\n", s);
    1f7a:	85ca                	mv	a1,s2
    1f7c:	00004517          	auipc	a0,0x4
    1f80:	6fc50513          	addi	a0,a0,1788 # 6678 <malloc+0x852>
    1f84:	00004097          	auipc	ra,0x4
    1f88:	dea080e7          	jalr	-534(ra) # 5d6e <printf>
      exit(1);
    1f8c:	4505                	li	a0,1
    1f8e:	00004097          	auipc	ra,0x4
    1f92:	a4e080e7          	jalr	-1458(ra) # 59dc <exit>
      *(char*)a = 99;
    1f96:	fd843783          	ld	a5,-40(s0)
    1f9a:	06300713          	li	a4,99
    1f9e:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    1fa2:	fd843603          	ld	a2,-40(s0)
    1fa6:	85ca                	mv	a1,s2
    1fa8:	00005517          	auipc	a0,0x5
    1fac:	9c050513          	addi	a0,a0,-1600 # 6968 <malloc+0xb42>
    1fb0:	00004097          	auipc	ra,0x4
    1fb4:	dbe080e7          	jalr	-578(ra) # 5d6e <printf>
      exit(1);
    1fb8:	4505                	li	a0,1
    1fba:	00004097          	auipc	ra,0x4
    1fbe:	a22080e7          	jalr	-1502(ra) # 59dc <exit>
      exit(1);
    1fc2:	4505                	li	a0,1
    1fc4:	00004097          	auipc	ra,0x4
    1fc8:	a18080e7          	jalr	-1512(ra) # 59dc <exit>

0000000000001fcc <bigargtest>:
{
    1fcc:	7179                	addi	sp,sp,-48
    1fce:	f406                	sd	ra,40(sp)
    1fd0:	f022                	sd	s0,32(sp)
    1fd2:	ec26                	sd	s1,24(sp)
    1fd4:	1800                	addi	s0,sp,48
    1fd6:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    1fd8:	00005517          	auipc	a0,0x5
    1fdc:	9a850513          	addi	a0,a0,-1624 # 6980 <malloc+0xb5a>
    1fe0:	00004097          	auipc	ra,0x4
    1fe4:	a4c080e7          	jalr	-1460(ra) # 5a2c <unlink>
  pid = fork();
    1fe8:	00004097          	auipc	ra,0x4
    1fec:	9ec080e7          	jalr	-1556(ra) # 59d4 <fork>
  if(pid == 0){
    1ff0:	c121                	beqz	a0,2030 <bigargtest+0x64>
  } else if(pid < 0){
    1ff2:	0a054063          	bltz	a0,2092 <bigargtest+0xc6>
  wait(&xstatus);
    1ff6:	fdc40513          	addi	a0,s0,-36
    1ffa:	00004097          	auipc	ra,0x4
    1ffe:	9ea080e7          	jalr	-1558(ra) # 59e4 <wait>
  if(xstatus != 0)
    2002:	fdc42503          	lw	a0,-36(s0)
    2006:	e545                	bnez	a0,20ae <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2008:	4581                	li	a1,0
    200a:	00005517          	auipc	a0,0x5
    200e:	97650513          	addi	a0,a0,-1674 # 6980 <malloc+0xb5a>
    2012:	00004097          	auipc	ra,0x4
    2016:	a0a080e7          	jalr	-1526(ra) # 5a1c <open>
  if(fd < 0){
    201a:	08054e63          	bltz	a0,20b6 <bigargtest+0xea>
  close(fd);
    201e:	00004097          	auipc	ra,0x4
    2022:	9e6080e7          	jalr	-1562(ra) # 5a04 <close>
}
    2026:	70a2                	ld	ra,40(sp)
    2028:	7402                	ld	s0,32(sp)
    202a:	64e2                	ld	s1,24(sp)
    202c:	6145                	addi	sp,sp,48
    202e:	8082                	ret
    2030:	00007797          	auipc	a5,0x7
    2034:	42078793          	addi	a5,a5,1056 # 9450 <args.1>
    2038:	00007697          	auipc	a3,0x7
    203c:	51068693          	addi	a3,a3,1296 # 9548 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2040:	00005717          	auipc	a4,0x5
    2044:	95070713          	addi	a4,a4,-1712 # 6990 <malloc+0xb6a>
    2048:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    204a:	07a1                	addi	a5,a5,8
    204c:	fed79ee3          	bne	a5,a3,2048 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2050:	00007597          	auipc	a1,0x7
    2054:	40058593          	addi	a1,a1,1024 # 9450 <args.1>
    2058:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    205c:	00004517          	auipc	a0,0x4
    2060:	eec50513          	addi	a0,a0,-276 # 5f48 <malloc+0x122>
    2064:	00004097          	auipc	ra,0x4
    2068:	9b0080e7          	jalr	-1616(ra) # 5a14 <exec>
    fd = open("bigarg-ok", O_CREATE);
    206c:	20000593          	li	a1,512
    2070:	00005517          	auipc	a0,0x5
    2074:	91050513          	addi	a0,a0,-1776 # 6980 <malloc+0xb5a>
    2078:	00004097          	auipc	ra,0x4
    207c:	9a4080e7          	jalr	-1628(ra) # 5a1c <open>
    close(fd);
    2080:	00004097          	auipc	ra,0x4
    2084:	984080e7          	jalr	-1660(ra) # 5a04 <close>
    exit(0);
    2088:	4501                	li	a0,0
    208a:	00004097          	auipc	ra,0x4
    208e:	952080e7          	jalr	-1710(ra) # 59dc <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2092:	85a6                	mv	a1,s1
    2094:	00005517          	auipc	a0,0x5
    2098:	9dc50513          	addi	a0,a0,-1572 # 6a70 <malloc+0xc4a>
    209c:	00004097          	auipc	ra,0x4
    20a0:	cd2080e7          	jalr	-814(ra) # 5d6e <printf>
    exit(1);
    20a4:	4505                	li	a0,1
    20a6:	00004097          	auipc	ra,0x4
    20aa:	936080e7          	jalr	-1738(ra) # 59dc <exit>
    exit(xstatus);
    20ae:	00004097          	auipc	ra,0x4
    20b2:	92e080e7          	jalr	-1746(ra) # 59dc <exit>
    printf("%s: bigarg test failed!\n", s);
    20b6:	85a6                	mv	a1,s1
    20b8:	00005517          	auipc	a0,0x5
    20bc:	9d850513          	addi	a0,a0,-1576 # 6a90 <malloc+0xc6a>
    20c0:	00004097          	auipc	ra,0x4
    20c4:	cae080e7          	jalr	-850(ra) # 5d6e <printf>
    exit(1);
    20c8:	4505                	li	a0,1
    20ca:	00004097          	auipc	ra,0x4
    20ce:	912080e7          	jalr	-1774(ra) # 59dc <exit>

00000000000020d2 <stacktest>:
{
    20d2:	7179                	addi	sp,sp,-48
    20d4:	f406                	sd	ra,40(sp)
    20d6:	f022                	sd	s0,32(sp)
    20d8:	ec26                	sd	s1,24(sp)
    20da:	1800                	addi	s0,sp,48
    20dc:	84aa                	mv	s1,a0
  pid = fork();
    20de:	00004097          	auipc	ra,0x4
    20e2:	8f6080e7          	jalr	-1802(ra) # 59d4 <fork>
  if(pid == 0) {
    20e6:	c115                	beqz	a0,210a <stacktest+0x38>
  } else if(pid < 0){
    20e8:	04054463          	bltz	a0,2130 <stacktest+0x5e>
  wait(&xstatus);
    20ec:	fdc40513          	addi	a0,s0,-36
    20f0:	00004097          	auipc	ra,0x4
    20f4:	8f4080e7          	jalr	-1804(ra) # 59e4 <wait>
  if(xstatus == -1)  // kernel killed child?
    20f8:	fdc42503          	lw	a0,-36(s0)
    20fc:	57fd                	li	a5,-1
    20fe:	04f50763          	beq	a0,a5,214c <stacktest+0x7a>
    exit(xstatus);
    2102:	00004097          	auipc	ra,0x4
    2106:	8da080e7          	jalr	-1830(ra) # 59dc <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    210a:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    210c:	77fd                	lui	a5,0xfffff
    210e:	97ba                	add	a5,a5,a4
    2110:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef398>
    2114:	85a6                	mv	a1,s1
    2116:	00005517          	auipc	a0,0x5
    211a:	99a50513          	addi	a0,a0,-1638 # 6ab0 <malloc+0xc8a>
    211e:	00004097          	auipc	ra,0x4
    2122:	c50080e7          	jalr	-944(ra) # 5d6e <printf>
    exit(1);
    2126:	4505                	li	a0,1
    2128:	00004097          	auipc	ra,0x4
    212c:	8b4080e7          	jalr	-1868(ra) # 59dc <exit>
    printf("%s: fork failed\n", s);
    2130:	85a6                	mv	a1,s1
    2132:	00004517          	auipc	a0,0x4
    2136:	54650513          	addi	a0,a0,1350 # 6678 <malloc+0x852>
    213a:	00004097          	auipc	ra,0x4
    213e:	c34080e7          	jalr	-972(ra) # 5d6e <printf>
    exit(1);
    2142:	4505                	li	a0,1
    2144:	00004097          	auipc	ra,0x4
    2148:	898080e7          	jalr	-1896(ra) # 59dc <exit>
    exit(0);
    214c:	4501                	li	a0,0
    214e:	00004097          	auipc	ra,0x4
    2152:	88e080e7          	jalr	-1906(ra) # 59dc <exit>

0000000000002156 <manywrites>:
{
    2156:	711d                	addi	sp,sp,-96
    2158:	ec86                	sd	ra,88(sp)
    215a:	e8a2                	sd	s0,80(sp)
    215c:	e4a6                	sd	s1,72(sp)
    215e:	e0ca                	sd	s2,64(sp)
    2160:	fc4e                	sd	s3,56(sp)
    2162:	f852                	sd	s4,48(sp)
    2164:	f456                	sd	s5,40(sp)
    2166:	f05a                	sd	s6,32(sp)
    2168:	ec5e                	sd	s7,24(sp)
    216a:	1080                	addi	s0,sp,96
    216c:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    216e:	4981                	li	s3,0
    2170:	4911                	li	s2,4
    int pid = fork();
    2172:	00004097          	auipc	ra,0x4
    2176:	862080e7          	jalr	-1950(ra) # 59d4 <fork>
    217a:	84aa                	mv	s1,a0
    if(pid < 0){
    217c:	02054963          	bltz	a0,21ae <manywrites+0x58>
    if(pid == 0){
    2180:	c521                	beqz	a0,21c8 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    2182:	2985                	addiw	s3,s3,1
    2184:	ff2997e3          	bne	s3,s2,2172 <manywrites+0x1c>
    2188:	4491                	li	s1,4
    int st = 0;
    218a:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    218e:	fa840513          	addi	a0,s0,-88
    2192:	00004097          	auipc	ra,0x4
    2196:	852080e7          	jalr	-1966(ra) # 59e4 <wait>
    if(st != 0)
    219a:	fa842503          	lw	a0,-88(s0)
    219e:	ed6d                	bnez	a0,2298 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    21a0:	34fd                	addiw	s1,s1,-1
    21a2:	f4e5                	bnez	s1,218a <manywrites+0x34>
  exit(0);
    21a4:	4501                	li	a0,0
    21a6:	00004097          	auipc	ra,0x4
    21aa:	836080e7          	jalr	-1994(ra) # 59dc <exit>
      printf("fork failed\n");
    21ae:	00005517          	auipc	a0,0x5
    21b2:	8d250513          	addi	a0,a0,-1838 # 6a80 <malloc+0xc5a>
    21b6:	00004097          	auipc	ra,0x4
    21ba:	bb8080e7          	jalr	-1096(ra) # 5d6e <printf>
      exit(1);
    21be:	4505                	li	a0,1
    21c0:	00004097          	auipc	ra,0x4
    21c4:	81c080e7          	jalr	-2020(ra) # 59dc <exit>
      name[0] = 'b';
    21c8:	06200793          	li	a5,98
    21cc:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    21d0:	0619879b          	addiw	a5,s3,97
    21d4:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    21d8:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    21dc:	fa840513          	addi	a0,s0,-88
    21e0:	00004097          	auipc	ra,0x4
    21e4:	84c080e7          	jalr	-1972(ra) # 5a2c <unlink>
    21e8:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    21ea:	0000bb17          	auipc	s6,0xb
    21ee:	a7eb0b13          	addi	s6,s6,-1410 # cc68 <buf>
        for(int i = 0; i < ci+1; i++){
    21f2:	8a26                	mv	s4,s1
    21f4:	0209ce63          	bltz	s3,2230 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    21f8:	20200593          	li	a1,514
    21fc:	fa840513          	addi	a0,s0,-88
    2200:	00004097          	auipc	ra,0x4
    2204:	81c080e7          	jalr	-2020(ra) # 5a1c <open>
    2208:	892a                	mv	s2,a0
          if(fd < 0){
    220a:	04054763          	bltz	a0,2258 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    220e:	660d                	lui	a2,0x3
    2210:	85da                	mv	a1,s6
    2212:	00003097          	auipc	ra,0x3
    2216:	7ea080e7          	jalr	2026(ra) # 59fc <write>
          if(cc != sz){
    221a:	678d                	lui	a5,0x3
    221c:	04f51e63          	bne	a0,a5,2278 <manywrites+0x122>
          close(fd);
    2220:	854a                	mv	a0,s2
    2222:	00003097          	auipc	ra,0x3
    2226:	7e2080e7          	jalr	2018(ra) # 5a04 <close>
        for(int i = 0; i < ci+1; i++){
    222a:	2a05                	addiw	s4,s4,1
    222c:	fd49d6e3          	bge	s3,s4,21f8 <manywrites+0xa2>
        unlink(name);
    2230:	fa840513          	addi	a0,s0,-88
    2234:	00003097          	auipc	ra,0x3
    2238:	7f8080e7          	jalr	2040(ra) # 5a2c <unlink>
      for(int iters = 0; iters < howmany; iters++){
    223c:	3bfd                	addiw	s7,s7,-1
    223e:	fa0b9ae3          	bnez	s7,21f2 <manywrites+0x9c>
      unlink(name);
    2242:	fa840513          	addi	a0,s0,-88
    2246:	00003097          	auipc	ra,0x3
    224a:	7e6080e7          	jalr	2022(ra) # 5a2c <unlink>
      exit(0);
    224e:	4501                	li	a0,0
    2250:	00003097          	auipc	ra,0x3
    2254:	78c080e7          	jalr	1932(ra) # 59dc <exit>
            printf("%s: cannot create %s\n", s, name);
    2258:	fa840613          	addi	a2,s0,-88
    225c:	85d6                	mv	a1,s5
    225e:	00005517          	auipc	a0,0x5
    2262:	87a50513          	addi	a0,a0,-1926 # 6ad8 <malloc+0xcb2>
    2266:	00004097          	auipc	ra,0x4
    226a:	b08080e7          	jalr	-1272(ra) # 5d6e <printf>
            exit(1);
    226e:	4505                	li	a0,1
    2270:	00003097          	auipc	ra,0x3
    2274:	76c080e7          	jalr	1900(ra) # 59dc <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2278:	86aa                	mv	a3,a0
    227a:	660d                	lui	a2,0x3
    227c:	85d6                	mv	a1,s5
    227e:	00004517          	auipc	a0,0x4
    2282:	d9a50513          	addi	a0,a0,-614 # 6018 <malloc+0x1f2>
    2286:	00004097          	auipc	ra,0x4
    228a:	ae8080e7          	jalr	-1304(ra) # 5d6e <printf>
            exit(1);
    228e:	4505                	li	a0,1
    2290:	00003097          	auipc	ra,0x3
    2294:	74c080e7          	jalr	1868(ra) # 59dc <exit>
      exit(st);
    2298:	00003097          	auipc	ra,0x3
    229c:	744080e7          	jalr	1860(ra) # 59dc <exit>

00000000000022a0 <copyinstr3>:
{
    22a0:	7179                	addi	sp,sp,-48
    22a2:	f406                	sd	ra,40(sp)
    22a4:	f022                	sd	s0,32(sp)
    22a6:	ec26                	sd	s1,24(sp)
    22a8:	1800                	addi	s0,sp,48
  sbrk(8192);
    22aa:	6509                	lui	a0,0x2
    22ac:	00003097          	auipc	ra,0x3
    22b0:	7b8080e7          	jalr	1976(ra) # 5a64 <sbrk>
  uint64 top = (uint64) sbrk(0);
    22b4:	4501                	li	a0,0
    22b6:	00003097          	auipc	ra,0x3
    22ba:	7ae080e7          	jalr	1966(ra) # 5a64 <sbrk>
  if((top % PGSIZE) != 0){
    22be:	03451793          	slli	a5,a0,0x34
    22c2:	e3c9                	bnez	a5,2344 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    22c4:	4501                	li	a0,0
    22c6:	00003097          	auipc	ra,0x3
    22ca:	79e080e7          	jalr	1950(ra) # 5a64 <sbrk>
  if(top % PGSIZE){
    22ce:	03451793          	slli	a5,a0,0x34
    22d2:	e3d9                	bnez	a5,2358 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    22d4:	fff50493          	addi	s1,a0,-1 # 1fff <bigargtest+0x33>
  *b = 'x';
    22d8:	07800793          	li	a5,120
    22dc:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    22e0:	8526                	mv	a0,s1
    22e2:	00003097          	auipc	ra,0x3
    22e6:	74a080e7          	jalr	1866(ra) # 5a2c <unlink>
  if(ret != -1){
    22ea:	57fd                	li	a5,-1
    22ec:	08f51363          	bne	a0,a5,2372 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    22f0:	20100593          	li	a1,513
    22f4:	8526                	mv	a0,s1
    22f6:	00003097          	auipc	ra,0x3
    22fa:	726080e7          	jalr	1830(ra) # 5a1c <open>
  if(fd != -1){
    22fe:	57fd                	li	a5,-1
    2300:	08f51863          	bne	a0,a5,2390 <copyinstr3+0xf0>
  ret = link(b, b);
    2304:	85a6                	mv	a1,s1
    2306:	8526                	mv	a0,s1
    2308:	00003097          	auipc	ra,0x3
    230c:	734080e7          	jalr	1844(ra) # 5a3c <link>
  if(ret != -1){
    2310:	57fd                	li	a5,-1
    2312:	08f51e63          	bne	a0,a5,23ae <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2316:	00005797          	auipc	a5,0x5
    231a:	4ba78793          	addi	a5,a5,1210 # 77d0 <malloc+0x19aa>
    231e:	fcf43823          	sd	a5,-48(s0)
    2322:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2326:	fd040593          	addi	a1,s0,-48
    232a:	8526                	mv	a0,s1
    232c:	00003097          	auipc	ra,0x3
    2330:	6e8080e7          	jalr	1768(ra) # 5a14 <exec>
  if(ret != -1){
    2334:	57fd                	li	a5,-1
    2336:	08f51c63          	bne	a0,a5,23ce <copyinstr3+0x12e>
}
    233a:	70a2                	ld	ra,40(sp)
    233c:	7402                	ld	s0,32(sp)
    233e:	64e2                	ld	s1,24(sp)
    2340:	6145                	addi	sp,sp,48
    2342:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2344:	0347d513          	srli	a0,a5,0x34
    2348:	6785                	lui	a5,0x1
    234a:	40a7853b          	subw	a0,a5,a0
    234e:	00003097          	auipc	ra,0x3
    2352:	716080e7          	jalr	1814(ra) # 5a64 <sbrk>
    2356:	b7bd                	j	22c4 <copyinstr3+0x24>
    printf("oops\n");
    2358:	00004517          	auipc	a0,0x4
    235c:	79850513          	addi	a0,a0,1944 # 6af0 <malloc+0xcca>
    2360:	00004097          	auipc	ra,0x4
    2364:	a0e080e7          	jalr	-1522(ra) # 5d6e <printf>
    exit(1);
    2368:	4505                	li	a0,1
    236a:	00003097          	auipc	ra,0x3
    236e:	672080e7          	jalr	1650(ra) # 59dc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2372:	862a                	mv	a2,a0
    2374:	85a6                	mv	a1,s1
    2376:	00004517          	auipc	a0,0x4
    237a:	22250513          	addi	a0,a0,546 # 6598 <malloc+0x772>
    237e:	00004097          	auipc	ra,0x4
    2382:	9f0080e7          	jalr	-1552(ra) # 5d6e <printf>
    exit(1);
    2386:	4505                	li	a0,1
    2388:	00003097          	auipc	ra,0x3
    238c:	654080e7          	jalr	1620(ra) # 59dc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2390:	862a                	mv	a2,a0
    2392:	85a6                	mv	a1,s1
    2394:	00004517          	auipc	a0,0x4
    2398:	22450513          	addi	a0,a0,548 # 65b8 <malloc+0x792>
    239c:	00004097          	auipc	ra,0x4
    23a0:	9d2080e7          	jalr	-1582(ra) # 5d6e <printf>
    exit(1);
    23a4:	4505                	li	a0,1
    23a6:	00003097          	auipc	ra,0x3
    23aa:	636080e7          	jalr	1590(ra) # 59dc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    23ae:	86aa                	mv	a3,a0
    23b0:	8626                	mv	a2,s1
    23b2:	85a6                	mv	a1,s1
    23b4:	00004517          	auipc	a0,0x4
    23b8:	22450513          	addi	a0,a0,548 # 65d8 <malloc+0x7b2>
    23bc:	00004097          	auipc	ra,0x4
    23c0:	9b2080e7          	jalr	-1614(ra) # 5d6e <printf>
    exit(1);
    23c4:	4505                	li	a0,1
    23c6:	00003097          	auipc	ra,0x3
    23ca:	616080e7          	jalr	1558(ra) # 59dc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    23ce:	567d                	li	a2,-1
    23d0:	85a6                	mv	a1,s1
    23d2:	00004517          	auipc	a0,0x4
    23d6:	22e50513          	addi	a0,a0,558 # 6600 <malloc+0x7da>
    23da:	00004097          	auipc	ra,0x4
    23de:	994080e7          	jalr	-1644(ra) # 5d6e <printf>
    exit(1);
    23e2:	4505                	li	a0,1
    23e4:	00003097          	auipc	ra,0x3
    23e8:	5f8080e7          	jalr	1528(ra) # 59dc <exit>

00000000000023ec <rwsbrk>:
{
    23ec:	1101                	addi	sp,sp,-32
    23ee:	ec06                	sd	ra,24(sp)
    23f0:	e822                	sd	s0,16(sp)
    23f2:	e426                	sd	s1,8(sp)
    23f4:	e04a                	sd	s2,0(sp)
    23f6:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    23f8:	6509                	lui	a0,0x2
    23fa:	00003097          	auipc	ra,0x3
    23fe:	66a080e7          	jalr	1642(ra) # 5a64 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2402:	57fd                	li	a5,-1
    2404:	06f50263          	beq	a0,a5,2468 <rwsbrk+0x7c>
    2408:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    240a:	7579                	lui	a0,0xffffe
    240c:	00003097          	auipc	ra,0x3
    2410:	658080e7          	jalr	1624(ra) # 5a64 <sbrk>
    2414:	57fd                	li	a5,-1
    2416:	06f50663          	beq	a0,a5,2482 <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    241a:	20100593          	li	a1,513
    241e:	00004517          	auipc	a0,0x4
    2422:	71250513          	addi	a0,a0,1810 # 6b30 <malloc+0xd0a>
    2426:	00003097          	auipc	ra,0x3
    242a:	5f6080e7          	jalr	1526(ra) # 5a1c <open>
    242e:	892a                	mv	s2,a0
  if(fd < 0){
    2430:	06054663          	bltz	a0,249c <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    2434:	6785                	lui	a5,0x1
    2436:	94be                	add	s1,s1,a5
    2438:	40000613          	li	a2,1024
    243c:	85a6                	mv	a1,s1
    243e:	00003097          	auipc	ra,0x3
    2442:	5be080e7          	jalr	1470(ra) # 59fc <write>
    2446:	862a                	mv	a2,a0
  if(n >= 0){
    2448:	06054763          	bltz	a0,24b6 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    244c:	85a6                	mv	a1,s1
    244e:	00004517          	auipc	a0,0x4
    2452:	70250513          	addi	a0,a0,1794 # 6b50 <malloc+0xd2a>
    2456:	00004097          	auipc	ra,0x4
    245a:	918080e7          	jalr	-1768(ra) # 5d6e <printf>
    exit(1);
    245e:	4505                	li	a0,1
    2460:	00003097          	auipc	ra,0x3
    2464:	57c080e7          	jalr	1404(ra) # 59dc <exit>
    printf("sbrk(rwsbrk) failed\n");
    2468:	00004517          	auipc	a0,0x4
    246c:	69050513          	addi	a0,a0,1680 # 6af8 <malloc+0xcd2>
    2470:	00004097          	auipc	ra,0x4
    2474:	8fe080e7          	jalr	-1794(ra) # 5d6e <printf>
    exit(1);
    2478:	4505                	li	a0,1
    247a:	00003097          	auipc	ra,0x3
    247e:	562080e7          	jalr	1378(ra) # 59dc <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2482:	00004517          	auipc	a0,0x4
    2486:	68e50513          	addi	a0,a0,1678 # 6b10 <malloc+0xcea>
    248a:	00004097          	auipc	ra,0x4
    248e:	8e4080e7          	jalr	-1820(ra) # 5d6e <printf>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	00003097          	auipc	ra,0x3
    2498:	548080e7          	jalr	1352(ra) # 59dc <exit>
    printf("open(rwsbrk) failed\n");
    249c:	00004517          	auipc	a0,0x4
    24a0:	69c50513          	addi	a0,a0,1692 # 6b38 <malloc+0xd12>
    24a4:	00004097          	auipc	ra,0x4
    24a8:	8ca080e7          	jalr	-1846(ra) # 5d6e <printf>
    exit(1);
    24ac:	4505                	li	a0,1
    24ae:	00003097          	auipc	ra,0x3
    24b2:	52e080e7          	jalr	1326(ra) # 59dc <exit>
  close(fd);
    24b6:	854a                	mv	a0,s2
    24b8:	00003097          	auipc	ra,0x3
    24bc:	54c080e7          	jalr	1356(ra) # 5a04 <close>
  unlink("rwsbrk");
    24c0:	00004517          	auipc	a0,0x4
    24c4:	67050513          	addi	a0,a0,1648 # 6b30 <malloc+0xd0a>
    24c8:	00003097          	auipc	ra,0x3
    24cc:	564080e7          	jalr	1380(ra) # 5a2c <unlink>
  fd = open("README", O_RDONLY);
    24d0:	4581                	li	a1,0
    24d2:	00004517          	auipc	a0,0x4
    24d6:	c4e50513          	addi	a0,a0,-946 # 6120 <malloc+0x2fa>
    24da:	00003097          	auipc	ra,0x3
    24de:	542080e7          	jalr	1346(ra) # 5a1c <open>
    24e2:	892a                	mv	s2,a0
  if(fd < 0){
    24e4:	02054963          	bltz	a0,2516 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    24e8:	4629                	li	a2,10
    24ea:	85a6                	mv	a1,s1
    24ec:	00003097          	auipc	ra,0x3
    24f0:	508080e7          	jalr	1288(ra) # 59f4 <read>
    24f4:	862a                	mv	a2,a0
  if(n >= 0){
    24f6:	02054d63          	bltz	a0,2530 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    24fa:	85a6                	mv	a1,s1
    24fc:	00004517          	auipc	a0,0x4
    2500:	68450513          	addi	a0,a0,1668 # 6b80 <malloc+0xd5a>
    2504:	00004097          	auipc	ra,0x4
    2508:	86a080e7          	jalr	-1942(ra) # 5d6e <printf>
    exit(1);
    250c:	4505                	li	a0,1
    250e:	00003097          	auipc	ra,0x3
    2512:	4ce080e7          	jalr	1230(ra) # 59dc <exit>
    printf("open(rwsbrk) failed\n");
    2516:	00004517          	auipc	a0,0x4
    251a:	62250513          	addi	a0,a0,1570 # 6b38 <malloc+0xd12>
    251e:	00004097          	auipc	ra,0x4
    2522:	850080e7          	jalr	-1968(ra) # 5d6e <printf>
    exit(1);
    2526:	4505                	li	a0,1
    2528:	00003097          	auipc	ra,0x3
    252c:	4b4080e7          	jalr	1204(ra) # 59dc <exit>
  close(fd);
    2530:	854a                	mv	a0,s2
    2532:	00003097          	auipc	ra,0x3
    2536:	4d2080e7          	jalr	1234(ra) # 5a04 <close>
  exit(0);
    253a:	4501                	li	a0,0
    253c:	00003097          	auipc	ra,0x3
    2540:	4a0080e7          	jalr	1184(ra) # 59dc <exit>

0000000000002544 <sbrkbasic>:
{
    2544:	7139                	addi	sp,sp,-64
    2546:	fc06                	sd	ra,56(sp)
    2548:	f822                	sd	s0,48(sp)
    254a:	f426                	sd	s1,40(sp)
    254c:	f04a                	sd	s2,32(sp)
    254e:	ec4e                	sd	s3,24(sp)
    2550:	e852                	sd	s4,16(sp)
    2552:	0080                	addi	s0,sp,64
    2554:	8a2a                	mv	s4,a0
  pid = fork();
    2556:	00003097          	auipc	ra,0x3
    255a:	47e080e7          	jalr	1150(ra) # 59d4 <fork>
  if(pid < 0){
    255e:	02054c63          	bltz	a0,2596 <sbrkbasic+0x52>
  if(pid == 0){
    2562:	ed21                	bnez	a0,25ba <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2564:	40000537          	lui	a0,0x40000
    2568:	00003097          	auipc	ra,0x3
    256c:	4fc080e7          	jalr	1276(ra) # 5a64 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2570:	57fd                	li	a5,-1
    2572:	02f50f63          	beq	a0,a5,25b0 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2576:	400007b7          	lui	a5,0x40000
    257a:	97aa                	add	a5,a5,a0
      *b = 99;
    257c:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2580:	6705                	lui	a4,0x1
      *b = 99;
    2582:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0398>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2586:	953a                	add	a0,a0,a4
    2588:	fef51de3          	bne	a0,a5,2582 <sbrkbasic+0x3e>
    exit(1);
    258c:	4505                	li	a0,1
    258e:	00003097          	auipc	ra,0x3
    2592:	44e080e7          	jalr	1102(ra) # 59dc <exit>
    printf("fork failed in sbrkbasic\n");
    2596:	00004517          	auipc	a0,0x4
    259a:	61250513          	addi	a0,a0,1554 # 6ba8 <malloc+0xd82>
    259e:	00003097          	auipc	ra,0x3
    25a2:	7d0080e7          	jalr	2000(ra) # 5d6e <printf>
    exit(1);
    25a6:	4505                	li	a0,1
    25a8:	00003097          	auipc	ra,0x3
    25ac:	434080e7          	jalr	1076(ra) # 59dc <exit>
      exit(0);
    25b0:	4501                	li	a0,0
    25b2:	00003097          	auipc	ra,0x3
    25b6:	42a080e7          	jalr	1066(ra) # 59dc <exit>
  wait(&xstatus);
    25ba:	fcc40513          	addi	a0,s0,-52
    25be:	00003097          	auipc	ra,0x3
    25c2:	426080e7          	jalr	1062(ra) # 59e4 <wait>
  if(xstatus == 1){
    25c6:	fcc42703          	lw	a4,-52(s0)
    25ca:	4785                	li	a5,1
    25cc:	00f70d63          	beq	a4,a5,25e6 <sbrkbasic+0xa2>
  a = sbrk(0);
    25d0:	4501                	li	a0,0
    25d2:	00003097          	auipc	ra,0x3
    25d6:	492080e7          	jalr	1170(ra) # 5a64 <sbrk>
    25da:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    25dc:	4901                	li	s2,0
    25de:	6985                	lui	s3,0x1
    25e0:	38898993          	addi	s3,s3,904 # 1388 <truncate3+0xfe>
    25e4:	a005                	j	2604 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    25e6:	85d2                	mv	a1,s4
    25e8:	00004517          	auipc	a0,0x4
    25ec:	5e050513          	addi	a0,a0,1504 # 6bc8 <malloc+0xda2>
    25f0:	00003097          	auipc	ra,0x3
    25f4:	77e080e7          	jalr	1918(ra) # 5d6e <printf>
    exit(1);
    25f8:	4505                	li	a0,1
    25fa:	00003097          	auipc	ra,0x3
    25fe:	3e2080e7          	jalr	994(ra) # 59dc <exit>
    a = b + 1;
    2602:	84be                	mv	s1,a5
    b = sbrk(1);
    2604:	4505                	li	a0,1
    2606:	00003097          	auipc	ra,0x3
    260a:	45e080e7          	jalr	1118(ra) # 5a64 <sbrk>
    if(b != a){
    260e:	04951c63          	bne	a0,s1,2666 <sbrkbasic+0x122>
    *b = 1;
    2612:	4785                	li	a5,1
    2614:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2618:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    261c:	2905                	addiw	s2,s2,1
    261e:	ff3912e3          	bne	s2,s3,2602 <sbrkbasic+0xbe>
  pid = fork();
    2622:	00003097          	auipc	ra,0x3
    2626:	3b2080e7          	jalr	946(ra) # 59d4 <fork>
    262a:	892a                	mv	s2,a0
  if(pid < 0){
    262c:	04054e63          	bltz	a0,2688 <sbrkbasic+0x144>
  c = sbrk(1);
    2630:	4505                	li	a0,1
    2632:	00003097          	auipc	ra,0x3
    2636:	432080e7          	jalr	1074(ra) # 5a64 <sbrk>
  c = sbrk(1);
    263a:	4505                	li	a0,1
    263c:	00003097          	auipc	ra,0x3
    2640:	428080e7          	jalr	1064(ra) # 5a64 <sbrk>
  if(c != a + 1){
    2644:	0489                	addi	s1,s1,2
    2646:	04a48f63          	beq	s1,a0,26a4 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    264a:	85d2                	mv	a1,s4
    264c:	00004517          	auipc	a0,0x4
    2650:	5dc50513          	addi	a0,a0,1500 # 6c28 <malloc+0xe02>
    2654:	00003097          	auipc	ra,0x3
    2658:	71a080e7          	jalr	1818(ra) # 5d6e <printf>
    exit(1);
    265c:	4505                	li	a0,1
    265e:	00003097          	auipc	ra,0x3
    2662:	37e080e7          	jalr	894(ra) # 59dc <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2666:	872a                	mv	a4,a0
    2668:	86a6                	mv	a3,s1
    266a:	864a                	mv	a2,s2
    266c:	85d2                	mv	a1,s4
    266e:	00004517          	auipc	a0,0x4
    2672:	57a50513          	addi	a0,a0,1402 # 6be8 <malloc+0xdc2>
    2676:	00003097          	auipc	ra,0x3
    267a:	6f8080e7          	jalr	1784(ra) # 5d6e <printf>
      exit(1);
    267e:	4505                	li	a0,1
    2680:	00003097          	auipc	ra,0x3
    2684:	35c080e7          	jalr	860(ra) # 59dc <exit>
    printf("%s: sbrk test fork failed\n", s);
    2688:	85d2                	mv	a1,s4
    268a:	00004517          	auipc	a0,0x4
    268e:	57e50513          	addi	a0,a0,1406 # 6c08 <malloc+0xde2>
    2692:	00003097          	auipc	ra,0x3
    2696:	6dc080e7          	jalr	1756(ra) # 5d6e <printf>
    exit(1);
    269a:	4505                	li	a0,1
    269c:	00003097          	auipc	ra,0x3
    26a0:	340080e7          	jalr	832(ra) # 59dc <exit>
  if(pid == 0)
    26a4:	00091763          	bnez	s2,26b2 <sbrkbasic+0x16e>
    exit(0);
    26a8:	4501                	li	a0,0
    26aa:	00003097          	auipc	ra,0x3
    26ae:	332080e7          	jalr	818(ra) # 59dc <exit>
  wait(&xstatus);
    26b2:	fcc40513          	addi	a0,s0,-52
    26b6:	00003097          	auipc	ra,0x3
    26ba:	32e080e7          	jalr	814(ra) # 59e4 <wait>
  exit(xstatus);
    26be:	fcc42503          	lw	a0,-52(s0)
    26c2:	00003097          	auipc	ra,0x3
    26c6:	31a080e7          	jalr	794(ra) # 59dc <exit>

00000000000026ca <sbrkmuch>:
{
    26ca:	7179                	addi	sp,sp,-48
    26cc:	f406                	sd	ra,40(sp)
    26ce:	f022                	sd	s0,32(sp)
    26d0:	ec26                	sd	s1,24(sp)
    26d2:	e84a                	sd	s2,16(sp)
    26d4:	e44e                	sd	s3,8(sp)
    26d6:	e052                	sd	s4,0(sp)
    26d8:	1800                	addi	s0,sp,48
    26da:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    26dc:	4501                	li	a0,0
    26de:	00003097          	auipc	ra,0x3
    26e2:	386080e7          	jalr	902(ra) # 5a64 <sbrk>
    26e6:	892a                	mv	s2,a0
  a = sbrk(0);
    26e8:	4501                	li	a0,0
    26ea:	00003097          	auipc	ra,0x3
    26ee:	37a080e7          	jalr	890(ra) # 5a64 <sbrk>
    26f2:	84aa                	mv	s1,a0
  p = sbrk(amt);
    26f4:	06400537          	lui	a0,0x6400
    26f8:	9d05                	subw	a0,a0,s1
    26fa:	00003097          	auipc	ra,0x3
    26fe:	36a080e7          	jalr	874(ra) # 5a64 <sbrk>
  if (p != a) {
    2702:	0ca49863          	bne	s1,a0,27d2 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2706:	4501                	li	a0,0
    2708:	00003097          	auipc	ra,0x3
    270c:	35c080e7          	jalr	860(ra) # 5a64 <sbrk>
    2710:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2712:	00a4f963          	bgeu	s1,a0,2724 <sbrkmuch+0x5a>
    *pp = 1;
    2716:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2718:	6705                	lui	a4,0x1
    *pp = 1;
    271a:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    271e:	94ba                	add	s1,s1,a4
    2720:	fef4ede3          	bltu	s1,a5,271a <sbrkmuch+0x50>
  *lastaddr = 99;
    2724:	064007b7          	lui	a5,0x6400
    2728:	06300713          	li	a4,99
    272c:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0397>
  a = sbrk(0);
    2730:	4501                	li	a0,0
    2732:	00003097          	auipc	ra,0x3
    2736:	332080e7          	jalr	818(ra) # 5a64 <sbrk>
    273a:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    273c:	757d                	lui	a0,0xfffff
    273e:	00003097          	auipc	ra,0x3
    2742:	326080e7          	jalr	806(ra) # 5a64 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2746:	57fd                	li	a5,-1
    2748:	0af50363          	beq	a0,a5,27ee <sbrkmuch+0x124>
  c = sbrk(0);
    274c:	4501                	li	a0,0
    274e:	00003097          	auipc	ra,0x3
    2752:	316080e7          	jalr	790(ra) # 5a64 <sbrk>
  if(c != a - PGSIZE){
    2756:	77fd                	lui	a5,0xfffff
    2758:	97a6                	add	a5,a5,s1
    275a:	0af51863          	bne	a0,a5,280a <sbrkmuch+0x140>
  a = sbrk(0);
    275e:	4501                	li	a0,0
    2760:	00003097          	auipc	ra,0x3
    2764:	304080e7          	jalr	772(ra) # 5a64 <sbrk>
    2768:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    276a:	6505                	lui	a0,0x1
    276c:	00003097          	auipc	ra,0x3
    2770:	2f8080e7          	jalr	760(ra) # 5a64 <sbrk>
    2774:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2776:	0aa49a63          	bne	s1,a0,282a <sbrkmuch+0x160>
    277a:	4501                	li	a0,0
    277c:	00003097          	auipc	ra,0x3
    2780:	2e8080e7          	jalr	744(ra) # 5a64 <sbrk>
    2784:	6785                	lui	a5,0x1
    2786:	97a6                	add	a5,a5,s1
    2788:	0af51163          	bne	a0,a5,282a <sbrkmuch+0x160>
  if(*lastaddr == 99){
    278c:	064007b7          	lui	a5,0x6400
    2790:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0397>
    2794:	06300793          	li	a5,99
    2798:	0af70963          	beq	a4,a5,284a <sbrkmuch+0x180>
  a = sbrk(0);
    279c:	4501                	li	a0,0
    279e:	00003097          	auipc	ra,0x3
    27a2:	2c6080e7          	jalr	710(ra) # 5a64 <sbrk>
    27a6:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    27a8:	4501                	li	a0,0
    27aa:	00003097          	auipc	ra,0x3
    27ae:	2ba080e7          	jalr	698(ra) # 5a64 <sbrk>
    27b2:	40a9053b          	subw	a0,s2,a0
    27b6:	00003097          	auipc	ra,0x3
    27ba:	2ae080e7          	jalr	686(ra) # 5a64 <sbrk>
  if(c != a){
    27be:	0aa49463          	bne	s1,a0,2866 <sbrkmuch+0x19c>
}
    27c2:	70a2                	ld	ra,40(sp)
    27c4:	7402                	ld	s0,32(sp)
    27c6:	64e2                	ld	s1,24(sp)
    27c8:	6942                	ld	s2,16(sp)
    27ca:	69a2                	ld	s3,8(sp)
    27cc:	6a02                	ld	s4,0(sp)
    27ce:	6145                	addi	sp,sp,48
    27d0:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    27d2:	85ce                	mv	a1,s3
    27d4:	00004517          	auipc	a0,0x4
    27d8:	47450513          	addi	a0,a0,1140 # 6c48 <malloc+0xe22>
    27dc:	00003097          	auipc	ra,0x3
    27e0:	592080e7          	jalr	1426(ra) # 5d6e <printf>
    exit(1);
    27e4:	4505                	li	a0,1
    27e6:	00003097          	auipc	ra,0x3
    27ea:	1f6080e7          	jalr	502(ra) # 59dc <exit>
    printf("%s: sbrk could not deallocate\n", s);
    27ee:	85ce                	mv	a1,s3
    27f0:	00004517          	auipc	a0,0x4
    27f4:	4a050513          	addi	a0,a0,1184 # 6c90 <malloc+0xe6a>
    27f8:	00003097          	auipc	ra,0x3
    27fc:	576080e7          	jalr	1398(ra) # 5d6e <printf>
    exit(1);
    2800:	4505                	li	a0,1
    2802:	00003097          	auipc	ra,0x3
    2806:	1da080e7          	jalr	474(ra) # 59dc <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    280a:	86aa                	mv	a3,a0
    280c:	8626                	mv	a2,s1
    280e:	85ce                	mv	a1,s3
    2810:	00004517          	auipc	a0,0x4
    2814:	4a050513          	addi	a0,a0,1184 # 6cb0 <malloc+0xe8a>
    2818:	00003097          	auipc	ra,0x3
    281c:	556080e7          	jalr	1366(ra) # 5d6e <printf>
    exit(1);
    2820:	4505                	li	a0,1
    2822:	00003097          	auipc	ra,0x3
    2826:	1ba080e7          	jalr	442(ra) # 59dc <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    282a:	86d2                	mv	a3,s4
    282c:	8626                	mv	a2,s1
    282e:	85ce                	mv	a1,s3
    2830:	00004517          	auipc	a0,0x4
    2834:	4c050513          	addi	a0,a0,1216 # 6cf0 <malloc+0xeca>
    2838:	00003097          	auipc	ra,0x3
    283c:	536080e7          	jalr	1334(ra) # 5d6e <printf>
    exit(1);
    2840:	4505                	li	a0,1
    2842:	00003097          	auipc	ra,0x3
    2846:	19a080e7          	jalr	410(ra) # 59dc <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    284a:	85ce                	mv	a1,s3
    284c:	00004517          	auipc	a0,0x4
    2850:	4d450513          	addi	a0,a0,1236 # 6d20 <malloc+0xefa>
    2854:	00003097          	auipc	ra,0x3
    2858:	51a080e7          	jalr	1306(ra) # 5d6e <printf>
    exit(1);
    285c:	4505                	li	a0,1
    285e:	00003097          	auipc	ra,0x3
    2862:	17e080e7          	jalr	382(ra) # 59dc <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2866:	86aa                	mv	a3,a0
    2868:	8626                	mv	a2,s1
    286a:	85ce                	mv	a1,s3
    286c:	00004517          	auipc	a0,0x4
    2870:	4ec50513          	addi	a0,a0,1260 # 6d58 <malloc+0xf32>
    2874:	00003097          	auipc	ra,0x3
    2878:	4fa080e7          	jalr	1274(ra) # 5d6e <printf>
    exit(1);
    287c:	4505                	li	a0,1
    287e:	00003097          	auipc	ra,0x3
    2882:	15e080e7          	jalr	350(ra) # 59dc <exit>

0000000000002886 <sbrkarg>:
{
    2886:	7179                	addi	sp,sp,-48
    2888:	f406                	sd	ra,40(sp)
    288a:	f022                	sd	s0,32(sp)
    288c:	ec26                	sd	s1,24(sp)
    288e:	e84a                	sd	s2,16(sp)
    2890:	e44e                	sd	s3,8(sp)
    2892:	1800                	addi	s0,sp,48
    2894:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2896:	6505                	lui	a0,0x1
    2898:	00003097          	auipc	ra,0x3
    289c:	1cc080e7          	jalr	460(ra) # 5a64 <sbrk>
    28a0:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    28a2:	20100593          	li	a1,513
    28a6:	00004517          	auipc	a0,0x4
    28aa:	4da50513          	addi	a0,a0,1242 # 6d80 <malloc+0xf5a>
    28ae:	00003097          	auipc	ra,0x3
    28b2:	16e080e7          	jalr	366(ra) # 5a1c <open>
    28b6:	84aa                	mv	s1,a0
  unlink("sbrk");
    28b8:	00004517          	auipc	a0,0x4
    28bc:	4c850513          	addi	a0,a0,1224 # 6d80 <malloc+0xf5a>
    28c0:	00003097          	auipc	ra,0x3
    28c4:	16c080e7          	jalr	364(ra) # 5a2c <unlink>
  if(fd < 0)  {
    28c8:	0404c163          	bltz	s1,290a <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    28cc:	6605                	lui	a2,0x1
    28ce:	85ca                	mv	a1,s2
    28d0:	8526                	mv	a0,s1
    28d2:	00003097          	auipc	ra,0x3
    28d6:	12a080e7          	jalr	298(ra) # 59fc <write>
    28da:	04054663          	bltz	a0,2926 <sbrkarg+0xa0>
  close(fd);
    28de:	8526                	mv	a0,s1
    28e0:	00003097          	auipc	ra,0x3
    28e4:	124080e7          	jalr	292(ra) # 5a04 <close>
  a = sbrk(PGSIZE);
    28e8:	6505                	lui	a0,0x1
    28ea:	00003097          	auipc	ra,0x3
    28ee:	17a080e7          	jalr	378(ra) # 5a64 <sbrk>
  if(pipe((int *) a) != 0){
    28f2:	00003097          	auipc	ra,0x3
    28f6:	0fa080e7          	jalr	250(ra) # 59ec <pipe>
    28fa:	e521                	bnez	a0,2942 <sbrkarg+0xbc>
}
    28fc:	70a2                	ld	ra,40(sp)
    28fe:	7402                	ld	s0,32(sp)
    2900:	64e2                	ld	s1,24(sp)
    2902:	6942                	ld	s2,16(sp)
    2904:	69a2                	ld	s3,8(sp)
    2906:	6145                	addi	sp,sp,48
    2908:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    290a:	85ce                	mv	a1,s3
    290c:	00004517          	auipc	a0,0x4
    2910:	47c50513          	addi	a0,a0,1148 # 6d88 <malloc+0xf62>
    2914:	00003097          	auipc	ra,0x3
    2918:	45a080e7          	jalr	1114(ra) # 5d6e <printf>
    exit(1);
    291c:	4505                	li	a0,1
    291e:	00003097          	auipc	ra,0x3
    2922:	0be080e7          	jalr	190(ra) # 59dc <exit>
    printf("%s: write sbrk failed\n", s);
    2926:	85ce                	mv	a1,s3
    2928:	00004517          	auipc	a0,0x4
    292c:	47850513          	addi	a0,a0,1144 # 6da0 <malloc+0xf7a>
    2930:	00003097          	auipc	ra,0x3
    2934:	43e080e7          	jalr	1086(ra) # 5d6e <printf>
    exit(1);
    2938:	4505                	li	a0,1
    293a:	00003097          	auipc	ra,0x3
    293e:	0a2080e7          	jalr	162(ra) # 59dc <exit>
    printf("%s: pipe() failed\n", s);
    2942:	85ce                	mv	a1,s3
    2944:	00004517          	auipc	a0,0x4
    2948:	e3c50513          	addi	a0,a0,-452 # 6780 <malloc+0x95a>
    294c:	00003097          	auipc	ra,0x3
    2950:	422080e7          	jalr	1058(ra) # 5d6e <printf>
    exit(1);
    2954:	4505                	li	a0,1
    2956:	00003097          	auipc	ra,0x3
    295a:	086080e7          	jalr	134(ra) # 59dc <exit>

000000000000295e <argptest>:
{
    295e:	1101                	addi	sp,sp,-32
    2960:	ec06                	sd	ra,24(sp)
    2962:	e822                	sd	s0,16(sp)
    2964:	e426                	sd	s1,8(sp)
    2966:	e04a                	sd	s2,0(sp)
    2968:	1000                	addi	s0,sp,32
    296a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    296c:	4581                	li	a1,0
    296e:	00004517          	auipc	a0,0x4
    2972:	44a50513          	addi	a0,a0,1098 # 6db8 <malloc+0xf92>
    2976:	00003097          	auipc	ra,0x3
    297a:	0a6080e7          	jalr	166(ra) # 5a1c <open>
  if (fd < 0) {
    297e:	02054b63          	bltz	a0,29b4 <argptest+0x56>
    2982:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2984:	4501                	li	a0,0
    2986:	00003097          	auipc	ra,0x3
    298a:	0de080e7          	jalr	222(ra) # 5a64 <sbrk>
    298e:	567d                	li	a2,-1
    2990:	fff50593          	addi	a1,a0,-1
    2994:	8526                	mv	a0,s1
    2996:	00003097          	auipc	ra,0x3
    299a:	05e080e7          	jalr	94(ra) # 59f4 <read>
  close(fd);
    299e:	8526                	mv	a0,s1
    29a0:	00003097          	auipc	ra,0x3
    29a4:	064080e7          	jalr	100(ra) # 5a04 <close>
}
    29a8:	60e2                	ld	ra,24(sp)
    29aa:	6442                	ld	s0,16(sp)
    29ac:	64a2                	ld	s1,8(sp)
    29ae:	6902                	ld	s2,0(sp)
    29b0:	6105                	addi	sp,sp,32
    29b2:	8082                	ret
    printf("%s: open failed\n", s);
    29b4:	85ca                	mv	a1,s2
    29b6:	00004517          	auipc	a0,0x4
    29ba:	cda50513          	addi	a0,a0,-806 # 6690 <malloc+0x86a>
    29be:	00003097          	auipc	ra,0x3
    29c2:	3b0080e7          	jalr	944(ra) # 5d6e <printf>
    exit(1);
    29c6:	4505                	li	a0,1
    29c8:	00003097          	auipc	ra,0x3
    29cc:	014080e7          	jalr	20(ra) # 59dc <exit>

00000000000029d0 <sbrkbugs>:
{
    29d0:	1141                	addi	sp,sp,-16
    29d2:	e406                	sd	ra,8(sp)
    29d4:	e022                	sd	s0,0(sp)
    29d6:	0800                	addi	s0,sp,16
  int pid = fork();
    29d8:	00003097          	auipc	ra,0x3
    29dc:	ffc080e7          	jalr	-4(ra) # 59d4 <fork>
  if(pid < 0){
    29e0:	02054263          	bltz	a0,2a04 <sbrkbugs+0x34>
  if(pid == 0){
    29e4:	ed0d                	bnez	a0,2a1e <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    29e6:	00003097          	auipc	ra,0x3
    29ea:	07e080e7          	jalr	126(ra) # 5a64 <sbrk>
    sbrk(-sz);
    29ee:	40a0053b          	negw	a0,a0
    29f2:	00003097          	auipc	ra,0x3
    29f6:	072080e7          	jalr	114(ra) # 5a64 <sbrk>
    exit(0);
    29fa:	4501                	li	a0,0
    29fc:	00003097          	auipc	ra,0x3
    2a00:	fe0080e7          	jalr	-32(ra) # 59dc <exit>
    printf("fork failed\n");
    2a04:	00004517          	auipc	a0,0x4
    2a08:	07c50513          	addi	a0,a0,124 # 6a80 <malloc+0xc5a>
    2a0c:	00003097          	auipc	ra,0x3
    2a10:	362080e7          	jalr	866(ra) # 5d6e <printf>
    exit(1);
    2a14:	4505                	li	a0,1
    2a16:	00003097          	auipc	ra,0x3
    2a1a:	fc6080e7          	jalr	-58(ra) # 59dc <exit>
  wait(0);
    2a1e:	4501                	li	a0,0
    2a20:	00003097          	auipc	ra,0x3
    2a24:	fc4080e7          	jalr	-60(ra) # 59e4 <wait>
  pid = fork();
    2a28:	00003097          	auipc	ra,0x3
    2a2c:	fac080e7          	jalr	-84(ra) # 59d4 <fork>
  if(pid < 0){
    2a30:	02054563          	bltz	a0,2a5a <sbrkbugs+0x8a>
  if(pid == 0){
    2a34:	e121                	bnez	a0,2a74 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	02e080e7          	jalr	46(ra) # 5a64 <sbrk>
    sbrk(-(sz - 3500));
    2a3e:	6785                	lui	a5,0x1
    2a40:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x50>
    2a44:	40a7853b          	subw	a0,a5,a0
    2a48:	00003097          	auipc	ra,0x3
    2a4c:	01c080e7          	jalr	28(ra) # 5a64 <sbrk>
    exit(0);
    2a50:	4501                	li	a0,0
    2a52:	00003097          	auipc	ra,0x3
    2a56:	f8a080e7          	jalr	-118(ra) # 59dc <exit>
    printf("fork failed\n");
    2a5a:	00004517          	auipc	a0,0x4
    2a5e:	02650513          	addi	a0,a0,38 # 6a80 <malloc+0xc5a>
    2a62:	00003097          	auipc	ra,0x3
    2a66:	30c080e7          	jalr	780(ra) # 5d6e <printf>
    exit(1);
    2a6a:	4505                	li	a0,1
    2a6c:	00003097          	auipc	ra,0x3
    2a70:	f70080e7          	jalr	-144(ra) # 59dc <exit>
  wait(0);
    2a74:	4501                	li	a0,0
    2a76:	00003097          	auipc	ra,0x3
    2a7a:	f6e080e7          	jalr	-146(ra) # 59e4 <wait>
  pid = fork();
    2a7e:	00003097          	auipc	ra,0x3
    2a82:	f56080e7          	jalr	-170(ra) # 59d4 <fork>
  if(pid < 0){
    2a86:	02054a63          	bltz	a0,2aba <sbrkbugs+0xea>
  if(pid == 0){
    2a8a:	e529                	bnez	a0,2ad4 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2a8c:	00003097          	auipc	ra,0x3
    2a90:	fd8080e7          	jalr	-40(ra) # 5a64 <sbrk>
    2a94:	67ad                	lui	a5,0xb
    2a96:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x2a8>
    2a9a:	40a7853b          	subw	a0,a5,a0
    2a9e:	00003097          	auipc	ra,0x3
    2aa2:	fc6080e7          	jalr	-58(ra) # 5a64 <sbrk>
    sbrk(-10);
    2aa6:	5559                	li	a0,-10
    2aa8:	00003097          	auipc	ra,0x3
    2aac:	fbc080e7          	jalr	-68(ra) # 5a64 <sbrk>
    exit(0);
    2ab0:	4501                	li	a0,0
    2ab2:	00003097          	auipc	ra,0x3
    2ab6:	f2a080e7          	jalr	-214(ra) # 59dc <exit>
    printf("fork failed\n");
    2aba:	00004517          	auipc	a0,0x4
    2abe:	fc650513          	addi	a0,a0,-58 # 6a80 <malloc+0xc5a>
    2ac2:	00003097          	auipc	ra,0x3
    2ac6:	2ac080e7          	jalr	684(ra) # 5d6e <printf>
    exit(1);
    2aca:	4505                	li	a0,1
    2acc:	00003097          	auipc	ra,0x3
    2ad0:	f10080e7          	jalr	-240(ra) # 59dc <exit>
  wait(0);
    2ad4:	4501                	li	a0,0
    2ad6:	00003097          	auipc	ra,0x3
    2ada:	f0e080e7          	jalr	-242(ra) # 59e4 <wait>
  exit(0);
    2ade:	4501                	li	a0,0
    2ae0:	00003097          	auipc	ra,0x3
    2ae4:	efc080e7          	jalr	-260(ra) # 59dc <exit>

0000000000002ae8 <sbrklast>:
{
    2ae8:	7179                	addi	sp,sp,-48
    2aea:	f406                	sd	ra,40(sp)
    2aec:	f022                	sd	s0,32(sp)
    2aee:	ec26                	sd	s1,24(sp)
    2af0:	e84a                	sd	s2,16(sp)
    2af2:	e44e                	sd	s3,8(sp)
    2af4:	e052                	sd	s4,0(sp)
    2af6:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2af8:	4501                	li	a0,0
    2afa:	00003097          	auipc	ra,0x3
    2afe:	f6a080e7          	jalr	-150(ra) # 5a64 <sbrk>
  if((top % 4096) != 0)
    2b02:	03451793          	slli	a5,a0,0x34
    2b06:	ebd9                	bnez	a5,2b9c <sbrklast+0xb4>
  sbrk(4096);
    2b08:	6505                	lui	a0,0x1
    2b0a:	00003097          	auipc	ra,0x3
    2b0e:	f5a080e7          	jalr	-166(ra) # 5a64 <sbrk>
  sbrk(10);
    2b12:	4529                	li	a0,10
    2b14:	00003097          	auipc	ra,0x3
    2b18:	f50080e7          	jalr	-176(ra) # 5a64 <sbrk>
  sbrk(-20);
    2b1c:	5531                	li	a0,-20
    2b1e:	00003097          	auipc	ra,0x3
    2b22:	f46080e7          	jalr	-186(ra) # 5a64 <sbrk>
  top = (uint64) sbrk(0);
    2b26:	4501                	li	a0,0
    2b28:	00003097          	auipc	ra,0x3
    2b2c:	f3c080e7          	jalr	-196(ra) # 5a64 <sbrk>
    2b30:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2b32:	fc050913          	addi	s2,a0,-64 # fc0 <validatetest+0x18>
  p[0] = 'x';
    2b36:	07800a13          	li	s4,120
    2b3a:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2b3e:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2b42:	20200593          	li	a1,514
    2b46:	854a                	mv	a0,s2
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	ed4080e7          	jalr	-300(ra) # 5a1c <open>
    2b50:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2b52:	4605                	li	a2,1
    2b54:	85ca                	mv	a1,s2
    2b56:	00003097          	auipc	ra,0x3
    2b5a:	ea6080e7          	jalr	-346(ra) # 59fc <write>
  close(fd);
    2b5e:	854e                	mv	a0,s3
    2b60:	00003097          	auipc	ra,0x3
    2b64:	ea4080e7          	jalr	-348(ra) # 5a04 <close>
  fd = open(p, O_RDWR);
    2b68:	4589                	li	a1,2
    2b6a:	854a                	mv	a0,s2
    2b6c:	00003097          	auipc	ra,0x3
    2b70:	eb0080e7          	jalr	-336(ra) # 5a1c <open>
  p[0] = '\0';
    2b74:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2b78:	4605                	li	a2,1
    2b7a:	85ca                	mv	a1,s2
    2b7c:	00003097          	auipc	ra,0x3
    2b80:	e78080e7          	jalr	-392(ra) # 59f4 <read>
  if(p[0] != 'x')
    2b84:	fc04c783          	lbu	a5,-64(s1)
    2b88:	03479463          	bne	a5,s4,2bb0 <sbrklast+0xc8>
}
    2b8c:	70a2                	ld	ra,40(sp)
    2b8e:	7402                	ld	s0,32(sp)
    2b90:	64e2                	ld	s1,24(sp)
    2b92:	6942                	ld	s2,16(sp)
    2b94:	69a2                	ld	s3,8(sp)
    2b96:	6a02                	ld	s4,0(sp)
    2b98:	6145                	addi	sp,sp,48
    2b9a:	8082                	ret
    sbrk(4096 - (top % 4096));
    2b9c:	0347d513          	srli	a0,a5,0x34
    2ba0:	6785                	lui	a5,0x1
    2ba2:	40a7853b          	subw	a0,a5,a0
    2ba6:	00003097          	auipc	ra,0x3
    2baa:	ebe080e7          	jalr	-322(ra) # 5a64 <sbrk>
    2bae:	bfa9                	j	2b08 <sbrklast+0x20>
    exit(1);
    2bb0:	4505                	li	a0,1
    2bb2:	00003097          	auipc	ra,0x3
    2bb6:	e2a080e7          	jalr	-470(ra) # 59dc <exit>

0000000000002bba <sbrk8000>:
{
    2bba:	1141                	addi	sp,sp,-16
    2bbc:	e406                	sd	ra,8(sp)
    2bbe:	e022                	sd	s0,0(sp)
    2bc0:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2bc2:	80000537          	lui	a0,0x80000
    2bc6:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff039c>
    2bc8:	00003097          	auipc	ra,0x3
    2bcc:	e9c080e7          	jalr	-356(ra) # 5a64 <sbrk>
  volatile char *top = sbrk(0);
    2bd0:	4501                	li	a0,0
    2bd2:	00003097          	auipc	ra,0x3
    2bd6:	e92080e7          	jalr	-366(ra) # 5a64 <sbrk>
  *(top-1) = *(top-1) + 1;
    2bda:	fff54783          	lbu	a5,-1(a0)
    2bde:	2785                	addiw	a5,a5,1 # 1001 <validatetest+0x59>
    2be0:	0ff7f793          	zext.b	a5,a5
    2be4:	fef50fa3          	sb	a5,-1(a0)
}
    2be8:	60a2                	ld	ra,8(sp)
    2bea:	6402                	ld	s0,0(sp)
    2bec:	0141                	addi	sp,sp,16
    2bee:	8082                	ret

0000000000002bf0 <execout>:
{
    2bf0:	715d                	addi	sp,sp,-80
    2bf2:	e486                	sd	ra,72(sp)
    2bf4:	e0a2                	sd	s0,64(sp)
    2bf6:	fc26                	sd	s1,56(sp)
    2bf8:	f84a                	sd	s2,48(sp)
    2bfa:	f44e                	sd	s3,40(sp)
    2bfc:	f052                	sd	s4,32(sp)
    2bfe:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2c00:	4901                	li	s2,0
    2c02:	49bd                	li	s3,15
    int pid = fork();
    2c04:	00003097          	auipc	ra,0x3
    2c08:	dd0080e7          	jalr	-560(ra) # 59d4 <fork>
    2c0c:	84aa                	mv	s1,a0
    if(pid < 0){
    2c0e:	02054063          	bltz	a0,2c2e <execout+0x3e>
    } else if(pid == 0){
    2c12:	c91d                	beqz	a0,2c48 <execout+0x58>
      wait((int*)0);
    2c14:	4501                	li	a0,0
    2c16:	00003097          	auipc	ra,0x3
    2c1a:	dce080e7          	jalr	-562(ra) # 59e4 <wait>
  for(int avail = 0; avail < 15; avail++){
    2c1e:	2905                	addiw	s2,s2,1
    2c20:	ff3912e3          	bne	s2,s3,2c04 <execout+0x14>
  exit(0);
    2c24:	4501                	li	a0,0
    2c26:	00003097          	auipc	ra,0x3
    2c2a:	db6080e7          	jalr	-586(ra) # 59dc <exit>
      printf("fork failed\n");
    2c2e:	00004517          	auipc	a0,0x4
    2c32:	e5250513          	addi	a0,a0,-430 # 6a80 <malloc+0xc5a>
    2c36:	00003097          	auipc	ra,0x3
    2c3a:	138080e7          	jalr	312(ra) # 5d6e <printf>
      exit(1);
    2c3e:	4505                	li	a0,1
    2c40:	00003097          	auipc	ra,0x3
    2c44:	d9c080e7          	jalr	-612(ra) # 59dc <exit>
        if(a == 0xffffffffffffffffLL)
    2c48:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2c4a:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2c4c:	6505                	lui	a0,0x1
    2c4e:	00003097          	auipc	ra,0x3
    2c52:	e16080e7          	jalr	-490(ra) # 5a64 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2c56:	01350763          	beq	a0,s3,2c64 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2c5a:	6785                	lui	a5,0x1
    2c5c:	97aa                	add	a5,a5,a0
    2c5e:	ff478fa3          	sb	s4,-1(a5) # fff <validatetest+0x57>
      while(1){
    2c62:	b7ed                	j	2c4c <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2c64:	01205a63          	blez	s2,2c78 <execout+0x88>
        sbrk(-4096);
    2c68:	757d                	lui	a0,0xfffff
    2c6a:	00003097          	auipc	ra,0x3
    2c6e:	dfa080e7          	jalr	-518(ra) # 5a64 <sbrk>
      for(int i = 0; i < avail; i++)
    2c72:	2485                	addiw	s1,s1,1
    2c74:	ff249ae3          	bne	s1,s2,2c68 <execout+0x78>
      close(1);
    2c78:	4505                	li	a0,1
    2c7a:	00003097          	auipc	ra,0x3
    2c7e:	d8a080e7          	jalr	-630(ra) # 5a04 <close>
      char *args[] = { "echo", "x", 0 };
    2c82:	00003517          	auipc	a0,0x3
    2c86:	2c650513          	addi	a0,a0,710 # 5f48 <malloc+0x122>
    2c8a:	faa43c23          	sd	a0,-72(s0)
    2c8e:	00003797          	auipc	a5,0x3
    2c92:	32a78793          	addi	a5,a5,810 # 5fb8 <malloc+0x192>
    2c96:	fcf43023          	sd	a5,-64(s0)
    2c9a:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c9e:	fb840593          	addi	a1,s0,-72
    2ca2:	00003097          	auipc	ra,0x3
    2ca6:	d72080e7          	jalr	-654(ra) # 5a14 <exec>
      exit(0);
    2caa:	4501                	li	a0,0
    2cac:	00003097          	auipc	ra,0x3
    2cb0:	d30080e7          	jalr	-720(ra) # 59dc <exit>

0000000000002cb4 <fourteen>:
{
    2cb4:	1101                	addi	sp,sp,-32
    2cb6:	ec06                	sd	ra,24(sp)
    2cb8:	e822                	sd	s0,16(sp)
    2cba:	e426                	sd	s1,8(sp)
    2cbc:	1000                	addi	s0,sp,32
    2cbe:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2cc0:	00004517          	auipc	a0,0x4
    2cc4:	2d050513          	addi	a0,a0,720 # 6f90 <malloc+0x116a>
    2cc8:	00003097          	auipc	ra,0x3
    2ccc:	d7c080e7          	jalr	-644(ra) # 5a44 <mkdir>
    2cd0:	e165                	bnez	a0,2db0 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2cd2:	00004517          	auipc	a0,0x4
    2cd6:	11650513          	addi	a0,a0,278 # 6de8 <malloc+0xfc2>
    2cda:	00003097          	auipc	ra,0x3
    2cde:	d6a080e7          	jalr	-662(ra) # 5a44 <mkdir>
    2ce2:	e56d                	bnez	a0,2dcc <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2ce4:	20000593          	li	a1,512
    2ce8:	00004517          	auipc	a0,0x4
    2cec:	15850513          	addi	a0,a0,344 # 6e40 <malloc+0x101a>
    2cf0:	00003097          	auipc	ra,0x3
    2cf4:	d2c080e7          	jalr	-724(ra) # 5a1c <open>
  if(fd < 0){
    2cf8:	0e054863          	bltz	a0,2de8 <fourteen+0x134>
  close(fd);
    2cfc:	00003097          	auipc	ra,0x3
    2d00:	d08080e7          	jalr	-760(ra) # 5a04 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2d04:	4581                	li	a1,0
    2d06:	00004517          	auipc	a0,0x4
    2d0a:	1b250513          	addi	a0,a0,434 # 6eb8 <malloc+0x1092>
    2d0e:	00003097          	auipc	ra,0x3
    2d12:	d0e080e7          	jalr	-754(ra) # 5a1c <open>
  if(fd < 0){
    2d16:	0e054763          	bltz	a0,2e04 <fourteen+0x150>
  close(fd);
    2d1a:	00003097          	auipc	ra,0x3
    2d1e:	cea080e7          	jalr	-790(ra) # 5a04 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2d22:	00004517          	auipc	a0,0x4
    2d26:	20650513          	addi	a0,a0,518 # 6f28 <malloc+0x1102>
    2d2a:	00003097          	auipc	ra,0x3
    2d2e:	d1a080e7          	jalr	-742(ra) # 5a44 <mkdir>
    2d32:	c57d                	beqz	a0,2e20 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2d34:	00004517          	auipc	a0,0x4
    2d38:	24c50513          	addi	a0,a0,588 # 6f80 <malloc+0x115a>
    2d3c:	00003097          	auipc	ra,0x3
    2d40:	d08080e7          	jalr	-760(ra) # 5a44 <mkdir>
    2d44:	cd65                	beqz	a0,2e3c <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2d46:	00004517          	auipc	a0,0x4
    2d4a:	23a50513          	addi	a0,a0,570 # 6f80 <malloc+0x115a>
    2d4e:	00003097          	auipc	ra,0x3
    2d52:	cde080e7          	jalr	-802(ra) # 5a2c <unlink>
  unlink("12345678901234/12345678901234");
    2d56:	00004517          	auipc	a0,0x4
    2d5a:	1d250513          	addi	a0,a0,466 # 6f28 <malloc+0x1102>
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	cce080e7          	jalr	-818(ra) # 5a2c <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2d66:	00004517          	auipc	a0,0x4
    2d6a:	15250513          	addi	a0,a0,338 # 6eb8 <malloc+0x1092>
    2d6e:	00003097          	auipc	ra,0x3
    2d72:	cbe080e7          	jalr	-834(ra) # 5a2c <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	0ca50513          	addi	a0,a0,202 # 6e40 <malloc+0x101a>
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	cae080e7          	jalr	-850(ra) # 5a2c <unlink>
  unlink("12345678901234/123456789012345");
    2d86:	00004517          	auipc	a0,0x4
    2d8a:	06250513          	addi	a0,a0,98 # 6de8 <malloc+0xfc2>
    2d8e:	00003097          	auipc	ra,0x3
    2d92:	c9e080e7          	jalr	-866(ra) # 5a2c <unlink>
  unlink("12345678901234");
    2d96:	00004517          	auipc	a0,0x4
    2d9a:	1fa50513          	addi	a0,a0,506 # 6f90 <malloc+0x116a>
    2d9e:	00003097          	auipc	ra,0x3
    2da2:	c8e080e7          	jalr	-882(ra) # 5a2c <unlink>
}
    2da6:	60e2                	ld	ra,24(sp)
    2da8:	6442                	ld	s0,16(sp)
    2daa:	64a2                	ld	s1,8(sp)
    2dac:	6105                	addi	sp,sp,32
    2dae:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2db0:	85a6                	mv	a1,s1
    2db2:	00004517          	auipc	a0,0x4
    2db6:	00e50513          	addi	a0,a0,14 # 6dc0 <malloc+0xf9a>
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	fb4080e7          	jalr	-76(ra) # 5d6e <printf>
    exit(1);
    2dc2:	4505                	li	a0,1
    2dc4:	00003097          	auipc	ra,0x3
    2dc8:	c18080e7          	jalr	-1000(ra) # 59dc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2dcc:	85a6                	mv	a1,s1
    2dce:	00004517          	auipc	a0,0x4
    2dd2:	03a50513          	addi	a0,a0,58 # 6e08 <malloc+0xfe2>
    2dd6:	00003097          	auipc	ra,0x3
    2dda:	f98080e7          	jalr	-104(ra) # 5d6e <printf>
    exit(1);
    2dde:	4505                	li	a0,1
    2de0:	00003097          	auipc	ra,0x3
    2de4:	bfc080e7          	jalr	-1028(ra) # 59dc <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2de8:	85a6                	mv	a1,s1
    2dea:	00004517          	auipc	a0,0x4
    2dee:	08650513          	addi	a0,a0,134 # 6e70 <malloc+0x104a>
    2df2:	00003097          	auipc	ra,0x3
    2df6:	f7c080e7          	jalr	-132(ra) # 5d6e <printf>
    exit(1);
    2dfa:	4505                	li	a0,1
    2dfc:	00003097          	auipc	ra,0x3
    2e00:	be0080e7          	jalr	-1056(ra) # 59dc <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2e04:	85a6                	mv	a1,s1
    2e06:	00004517          	auipc	a0,0x4
    2e0a:	0e250513          	addi	a0,a0,226 # 6ee8 <malloc+0x10c2>
    2e0e:	00003097          	auipc	ra,0x3
    2e12:	f60080e7          	jalr	-160(ra) # 5d6e <printf>
    exit(1);
    2e16:	4505                	li	a0,1
    2e18:	00003097          	auipc	ra,0x3
    2e1c:	bc4080e7          	jalr	-1084(ra) # 59dc <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2e20:	85a6                	mv	a1,s1
    2e22:	00004517          	auipc	a0,0x4
    2e26:	12650513          	addi	a0,a0,294 # 6f48 <malloc+0x1122>
    2e2a:	00003097          	auipc	ra,0x3
    2e2e:	f44080e7          	jalr	-188(ra) # 5d6e <printf>
    exit(1);
    2e32:	4505                	li	a0,1
    2e34:	00003097          	auipc	ra,0x3
    2e38:	ba8080e7          	jalr	-1112(ra) # 59dc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2e3c:	85a6                	mv	a1,s1
    2e3e:	00004517          	auipc	a0,0x4
    2e42:	16250513          	addi	a0,a0,354 # 6fa0 <malloc+0x117a>
    2e46:	00003097          	auipc	ra,0x3
    2e4a:	f28080e7          	jalr	-216(ra) # 5d6e <printf>
    exit(1);
    2e4e:	4505                	li	a0,1
    2e50:	00003097          	auipc	ra,0x3
    2e54:	b8c080e7          	jalr	-1140(ra) # 59dc <exit>

0000000000002e58 <diskfull>:
{
    2e58:	b9010113          	addi	sp,sp,-1136
    2e5c:	46113423          	sd	ra,1128(sp)
    2e60:	46813023          	sd	s0,1120(sp)
    2e64:	44913c23          	sd	s1,1112(sp)
    2e68:	45213823          	sd	s2,1104(sp)
    2e6c:	45313423          	sd	s3,1096(sp)
    2e70:	45413023          	sd	s4,1088(sp)
    2e74:	43513c23          	sd	s5,1080(sp)
    2e78:	43613823          	sd	s6,1072(sp)
    2e7c:	43713423          	sd	s7,1064(sp)
    2e80:	43813023          	sd	s8,1056(sp)
    2e84:	47010413          	addi	s0,sp,1136
    2e88:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    2e8a:	00004517          	auipc	a0,0x4
    2e8e:	14e50513          	addi	a0,a0,334 # 6fd8 <malloc+0x11b2>
    2e92:	00003097          	auipc	ra,0x3
    2e96:	b9a080e7          	jalr	-1126(ra) # 5a2c <unlink>
  for(fi = 0; done == 0; fi++){
    2e9a:	4a01                	li	s4,0
    name[0] = 'b';
    2e9c:	06200b13          	li	s6,98
    name[1] = 'i';
    2ea0:	06900a93          	li	s5,105
    name[2] = 'g';
    2ea4:	06700993          	li	s3,103
    2ea8:	10c00b93          	li	s7,268
    2eac:	aabd                	j	302a <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    2eae:	b9040613          	addi	a2,s0,-1136
    2eb2:	85e2                	mv	a1,s8
    2eb4:	00004517          	auipc	a0,0x4
    2eb8:	13450513          	addi	a0,a0,308 # 6fe8 <malloc+0x11c2>
    2ebc:	00003097          	auipc	ra,0x3
    2ec0:	eb2080e7          	jalr	-334(ra) # 5d6e <printf>
      break;
    2ec4:	a821                	j	2edc <diskfull+0x84>
        close(fd);
    2ec6:	854a                	mv	a0,s2
    2ec8:	00003097          	auipc	ra,0x3
    2ecc:	b3c080e7          	jalr	-1220(ra) # 5a04 <close>
    close(fd);
    2ed0:	854a                	mv	a0,s2
    2ed2:	00003097          	auipc	ra,0x3
    2ed6:	b32080e7          	jalr	-1230(ra) # 5a04 <close>
  for(fi = 0; done == 0; fi++){
    2eda:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    2edc:	4481                	li	s1,0
    name[0] = 'z';
    2ede:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2ee2:	08000993          	li	s3,128
    name[0] = 'z';
    2ee6:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    2eea:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    2eee:	41f4d71b          	sraiw	a4,s1,0x1f
    2ef2:	01b7571b          	srliw	a4,a4,0x1b
    2ef6:	009707bb          	addw	a5,a4,s1
    2efa:	4057d69b          	sraiw	a3,a5,0x5
    2efe:	0306869b          	addiw	a3,a3,48
    2f02:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    2f06:	8bfd                	andi	a5,a5,31
    2f08:	9f99                	subw	a5,a5,a4
    2f0a:	0307879b          	addiw	a5,a5,48
    2f0e:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    2f12:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    2f16:	bb040513          	addi	a0,s0,-1104
    2f1a:	00003097          	auipc	ra,0x3
    2f1e:	b12080e7          	jalr	-1262(ra) # 5a2c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2f22:	60200593          	li	a1,1538
    2f26:	bb040513          	addi	a0,s0,-1104
    2f2a:	00003097          	auipc	ra,0x3
    2f2e:	af2080e7          	jalr	-1294(ra) # 5a1c <open>
    if(fd < 0)
    2f32:	00054963          	bltz	a0,2f44 <diskfull+0xec>
    close(fd);
    2f36:	00003097          	auipc	ra,0x3
    2f3a:	ace080e7          	jalr	-1330(ra) # 5a04 <close>
  for(int i = 0; i < nzz; i++){
    2f3e:	2485                	addiw	s1,s1,1
    2f40:	fb3493e3          	bne	s1,s3,2ee6 <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    2f44:	00004517          	auipc	a0,0x4
    2f48:	09450513          	addi	a0,a0,148 # 6fd8 <malloc+0x11b2>
    2f4c:	00003097          	auipc	ra,0x3
    2f50:	af8080e7          	jalr	-1288(ra) # 5a44 <mkdir>
    2f54:	12050963          	beqz	a0,3086 <diskfull+0x22e>
  unlink("diskfulldir");
    2f58:	00004517          	auipc	a0,0x4
    2f5c:	08050513          	addi	a0,a0,128 # 6fd8 <malloc+0x11b2>
    2f60:	00003097          	auipc	ra,0x3
    2f64:	acc080e7          	jalr	-1332(ra) # 5a2c <unlink>
  for(int i = 0; i < nzz; i++){
    2f68:	4481                	li	s1,0
    name[0] = 'z';
    2f6a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2f6e:	08000993          	li	s3,128
    name[0] = 'z';
    2f72:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    2f76:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    2f7a:	41f4d71b          	sraiw	a4,s1,0x1f
    2f7e:	01b7571b          	srliw	a4,a4,0x1b
    2f82:	009707bb          	addw	a5,a4,s1
    2f86:	4057d69b          	sraiw	a3,a5,0x5
    2f8a:	0306869b          	addiw	a3,a3,48
    2f8e:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    2f92:	8bfd                	andi	a5,a5,31
    2f94:	9f99                	subw	a5,a5,a4
    2f96:	0307879b          	addiw	a5,a5,48
    2f9a:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    2f9e:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    2fa2:	bb040513          	addi	a0,s0,-1104
    2fa6:	00003097          	auipc	ra,0x3
    2faa:	a86080e7          	jalr	-1402(ra) # 5a2c <unlink>
  for(int i = 0; i < nzz; i++){
    2fae:	2485                	addiw	s1,s1,1
    2fb0:	fd3491e3          	bne	s1,s3,2f72 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    2fb4:	03405e63          	blez	s4,2ff0 <diskfull+0x198>
    2fb8:	4481                	li	s1,0
    name[0] = 'b';
    2fba:	06200a93          	li	s5,98
    name[1] = 'i';
    2fbe:	06900993          	li	s3,105
    name[2] = 'g';
    2fc2:	06700913          	li	s2,103
    name[0] = 'b';
    2fc6:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    2fca:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    2fce:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    2fd2:	0304879b          	addiw	a5,s1,48
    2fd6:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    2fda:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    2fde:	bb040513          	addi	a0,s0,-1104
    2fe2:	00003097          	auipc	ra,0x3
    2fe6:	a4a080e7          	jalr	-1462(ra) # 5a2c <unlink>
  for(int i = 0; i < fi; i++){
    2fea:	2485                	addiw	s1,s1,1
    2fec:	fd449de3          	bne	s1,s4,2fc6 <diskfull+0x16e>
}
    2ff0:	46813083          	ld	ra,1128(sp)
    2ff4:	46013403          	ld	s0,1120(sp)
    2ff8:	45813483          	ld	s1,1112(sp)
    2ffc:	45013903          	ld	s2,1104(sp)
    3000:	44813983          	ld	s3,1096(sp)
    3004:	44013a03          	ld	s4,1088(sp)
    3008:	43813a83          	ld	s5,1080(sp)
    300c:	43013b03          	ld	s6,1072(sp)
    3010:	42813b83          	ld	s7,1064(sp)
    3014:	42013c03          	ld	s8,1056(sp)
    3018:	47010113          	addi	sp,sp,1136
    301c:	8082                	ret
    close(fd);
    301e:	854a                	mv	a0,s2
    3020:	00003097          	auipc	ra,0x3
    3024:	9e4080e7          	jalr	-1564(ra) # 5a04 <close>
  for(fi = 0; done == 0; fi++){
    3028:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    302a:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    302e:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    3032:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    3036:	030a079b          	addiw	a5,s4,48
    303a:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    303e:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3042:	b9040513          	addi	a0,s0,-1136
    3046:	00003097          	auipc	ra,0x3
    304a:	9e6080e7          	jalr	-1562(ra) # 5a2c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    304e:	60200593          	li	a1,1538
    3052:	b9040513          	addi	a0,s0,-1136
    3056:	00003097          	auipc	ra,0x3
    305a:	9c6080e7          	jalr	-1594(ra) # 5a1c <open>
    305e:	892a                	mv	s2,a0
    if(fd < 0){
    3060:	e40547e3          	bltz	a0,2eae <diskfull+0x56>
    3064:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3066:	40000613          	li	a2,1024
    306a:	bb040593          	addi	a1,s0,-1104
    306e:	854a                	mv	a0,s2
    3070:	00003097          	auipc	ra,0x3
    3074:	98c080e7          	jalr	-1652(ra) # 59fc <write>
    3078:	40000793          	li	a5,1024
    307c:	e4f515e3          	bne	a0,a5,2ec6 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    3080:	34fd                	addiw	s1,s1,-1
    3082:	f0f5                	bnez	s1,3066 <diskfull+0x20e>
    3084:	bf69                	j	301e <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3086:	00004517          	auipc	a0,0x4
    308a:	f8250513          	addi	a0,a0,-126 # 7008 <malloc+0x11e2>
    308e:	00003097          	auipc	ra,0x3
    3092:	ce0080e7          	jalr	-800(ra) # 5d6e <printf>
    3096:	b5c9                	j	2f58 <diskfull+0x100>

0000000000003098 <iputtest>:
{
    3098:	1101                	addi	sp,sp,-32
    309a:	ec06                	sd	ra,24(sp)
    309c:	e822                	sd	s0,16(sp)
    309e:	e426                	sd	s1,8(sp)
    30a0:	1000                	addi	s0,sp,32
    30a2:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    30a4:	00004517          	auipc	a0,0x4
    30a8:	f9450513          	addi	a0,a0,-108 # 7038 <malloc+0x1212>
    30ac:	00003097          	auipc	ra,0x3
    30b0:	998080e7          	jalr	-1640(ra) # 5a44 <mkdir>
    30b4:	04054563          	bltz	a0,30fe <iputtest+0x66>
  if(chdir("iputdir") < 0){
    30b8:	00004517          	auipc	a0,0x4
    30bc:	f8050513          	addi	a0,a0,-128 # 7038 <malloc+0x1212>
    30c0:	00003097          	auipc	ra,0x3
    30c4:	98c080e7          	jalr	-1652(ra) # 5a4c <chdir>
    30c8:	04054963          	bltz	a0,311a <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    30cc:	00004517          	auipc	a0,0x4
    30d0:	fac50513          	addi	a0,a0,-84 # 7078 <malloc+0x1252>
    30d4:	00003097          	auipc	ra,0x3
    30d8:	958080e7          	jalr	-1704(ra) # 5a2c <unlink>
    30dc:	04054d63          	bltz	a0,3136 <iputtest+0x9e>
  if(chdir("/") < 0){
    30e0:	00004517          	auipc	a0,0x4
    30e4:	fc850513          	addi	a0,a0,-56 # 70a8 <malloc+0x1282>
    30e8:	00003097          	auipc	ra,0x3
    30ec:	964080e7          	jalr	-1692(ra) # 5a4c <chdir>
    30f0:	06054163          	bltz	a0,3152 <iputtest+0xba>
}
    30f4:	60e2                	ld	ra,24(sp)
    30f6:	6442                	ld	s0,16(sp)
    30f8:	64a2                	ld	s1,8(sp)
    30fa:	6105                	addi	sp,sp,32
    30fc:	8082                	ret
    printf("%s: mkdir failed\n", s);
    30fe:	85a6                	mv	a1,s1
    3100:	00004517          	auipc	a0,0x4
    3104:	f4050513          	addi	a0,a0,-192 # 7040 <malloc+0x121a>
    3108:	00003097          	auipc	ra,0x3
    310c:	c66080e7          	jalr	-922(ra) # 5d6e <printf>
    exit(1);
    3110:	4505                	li	a0,1
    3112:	00003097          	auipc	ra,0x3
    3116:	8ca080e7          	jalr	-1846(ra) # 59dc <exit>
    printf("%s: chdir iputdir failed\n", s);
    311a:	85a6                	mv	a1,s1
    311c:	00004517          	auipc	a0,0x4
    3120:	f3c50513          	addi	a0,a0,-196 # 7058 <malloc+0x1232>
    3124:	00003097          	auipc	ra,0x3
    3128:	c4a080e7          	jalr	-950(ra) # 5d6e <printf>
    exit(1);
    312c:	4505                	li	a0,1
    312e:	00003097          	auipc	ra,0x3
    3132:	8ae080e7          	jalr	-1874(ra) # 59dc <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3136:	85a6                	mv	a1,s1
    3138:	00004517          	auipc	a0,0x4
    313c:	f5050513          	addi	a0,a0,-176 # 7088 <malloc+0x1262>
    3140:	00003097          	auipc	ra,0x3
    3144:	c2e080e7          	jalr	-978(ra) # 5d6e <printf>
    exit(1);
    3148:	4505                	li	a0,1
    314a:	00003097          	auipc	ra,0x3
    314e:	892080e7          	jalr	-1902(ra) # 59dc <exit>
    printf("%s: chdir / failed\n", s);
    3152:	85a6                	mv	a1,s1
    3154:	00004517          	auipc	a0,0x4
    3158:	f5c50513          	addi	a0,a0,-164 # 70b0 <malloc+0x128a>
    315c:	00003097          	auipc	ra,0x3
    3160:	c12080e7          	jalr	-1006(ra) # 5d6e <printf>
    exit(1);
    3164:	4505                	li	a0,1
    3166:	00003097          	auipc	ra,0x3
    316a:	876080e7          	jalr	-1930(ra) # 59dc <exit>

000000000000316e <exitiputtest>:
{
    316e:	7179                	addi	sp,sp,-48
    3170:	f406                	sd	ra,40(sp)
    3172:	f022                	sd	s0,32(sp)
    3174:	ec26                	sd	s1,24(sp)
    3176:	1800                	addi	s0,sp,48
    3178:	84aa                	mv	s1,a0
  pid = fork();
    317a:	00003097          	auipc	ra,0x3
    317e:	85a080e7          	jalr	-1958(ra) # 59d4 <fork>
  if(pid < 0){
    3182:	04054663          	bltz	a0,31ce <exitiputtest+0x60>
  if(pid == 0){
    3186:	ed45                	bnez	a0,323e <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3188:	00004517          	auipc	a0,0x4
    318c:	eb050513          	addi	a0,a0,-336 # 7038 <malloc+0x1212>
    3190:	00003097          	auipc	ra,0x3
    3194:	8b4080e7          	jalr	-1868(ra) # 5a44 <mkdir>
    3198:	04054963          	bltz	a0,31ea <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    319c:	00004517          	auipc	a0,0x4
    31a0:	e9c50513          	addi	a0,a0,-356 # 7038 <malloc+0x1212>
    31a4:	00003097          	auipc	ra,0x3
    31a8:	8a8080e7          	jalr	-1880(ra) # 5a4c <chdir>
    31ac:	04054d63          	bltz	a0,3206 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    31b0:	00004517          	auipc	a0,0x4
    31b4:	ec850513          	addi	a0,a0,-312 # 7078 <malloc+0x1252>
    31b8:	00003097          	auipc	ra,0x3
    31bc:	874080e7          	jalr	-1932(ra) # 5a2c <unlink>
    31c0:	06054163          	bltz	a0,3222 <exitiputtest+0xb4>
    exit(0);
    31c4:	4501                	li	a0,0
    31c6:	00003097          	auipc	ra,0x3
    31ca:	816080e7          	jalr	-2026(ra) # 59dc <exit>
    printf("%s: fork failed\n", s);
    31ce:	85a6                	mv	a1,s1
    31d0:	00003517          	auipc	a0,0x3
    31d4:	4a850513          	addi	a0,a0,1192 # 6678 <malloc+0x852>
    31d8:	00003097          	auipc	ra,0x3
    31dc:	b96080e7          	jalr	-1130(ra) # 5d6e <printf>
    exit(1);
    31e0:	4505                	li	a0,1
    31e2:	00002097          	auipc	ra,0x2
    31e6:	7fa080e7          	jalr	2042(ra) # 59dc <exit>
      printf("%s: mkdir failed\n", s);
    31ea:	85a6                	mv	a1,s1
    31ec:	00004517          	auipc	a0,0x4
    31f0:	e5450513          	addi	a0,a0,-428 # 7040 <malloc+0x121a>
    31f4:	00003097          	auipc	ra,0x3
    31f8:	b7a080e7          	jalr	-1158(ra) # 5d6e <printf>
      exit(1);
    31fc:	4505                	li	a0,1
    31fe:	00002097          	auipc	ra,0x2
    3202:	7de080e7          	jalr	2014(ra) # 59dc <exit>
      printf("%s: child chdir failed\n", s);
    3206:	85a6                	mv	a1,s1
    3208:	00004517          	auipc	a0,0x4
    320c:	ec050513          	addi	a0,a0,-320 # 70c8 <malloc+0x12a2>
    3210:	00003097          	auipc	ra,0x3
    3214:	b5e080e7          	jalr	-1186(ra) # 5d6e <printf>
      exit(1);
    3218:	4505                	li	a0,1
    321a:	00002097          	auipc	ra,0x2
    321e:	7c2080e7          	jalr	1986(ra) # 59dc <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3222:	85a6                	mv	a1,s1
    3224:	00004517          	auipc	a0,0x4
    3228:	e6450513          	addi	a0,a0,-412 # 7088 <malloc+0x1262>
    322c:	00003097          	auipc	ra,0x3
    3230:	b42080e7          	jalr	-1214(ra) # 5d6e <printf>
      exit(1);
    3234:	4505                	li	a0,1
    3236:	00002097          	auipc	ra,0x2
    323a:	7a6080e7          	jalr	1958(ra) # 59dc <exit>
  wait(&xstatus);
    323e:	fdc40513          	addi	a0,s0,-36
    3242:	00002097          	auipc	ra,0x2
    3246:	7a2080e7          	jalr	1954(ra) # 59e4 <wait>
  exit(xstatus);
    324a:	fdc42503          	lw	a0,-36(s0)
    324e:	00002097          	auipc	ra,0x2
    3252:	78e080e7          	jalr	1934(ra) # 59dc <exit>

0000000000003256 <dirtest>:
{
    3256:	1101                	addi	sp,sp,-32
    3258:	ec06                	sd	ra,24(sp)
    325a:	e822                	sd	s0,16(sp)
    325c:	e426                	sd	s1,8(sp)
    325e:	1000                	addi	s0,sp,32
    3260:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3262:	00004517          	auipc	a0,0x4
    3266:	e7e50513          	addi	a0,a0,-386 # 70e0 <malloc+0x12ba>
    326a:	00002097          	auipc	ra,0x2
    326e:	7da080e7          	jalr	2010(ra) # 5a44 <mkdir>
    3272:	04054563          	bltz	a0,32bc <dirtest+0x66>
  if(chdir("dir0") < 0){
    3276:	00004517          	auipc	a0,0x4
    327a:	e6a50513          	addi	a0,a0,-406 # 70e0 <malloc+0x12ba>
    327e:	00002097          	auipc	ra,0x2
    3282:	7ce080e7          	jalr	1998(ra) # 5a4c <chdir>
    3286:	04054963          	bltz	a0,32d8 <dirtest+0x82>
  if(chdir("..") < 0){
    328a:	00004517          	auipc	a0,0x4
    328e:	e7650513          	addi	a0,a0,-394 # 7100 <malloc+0x12da>
    3292:	00002097          	auipc	ra,0x2
    3296:	7ba080e7          	jalr	1978(ra) # 5a4c <chdir>
    329a:	04054d63          	bltz	a0,32f4 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    329e:	00004517          	auipc	a0,0x4
    32a2:	e4250513          	addi	a0,a0,-446 # 70e0 <malloc+0x12ba>
    32a6:	00002097          	auipc	ra,0x2
    32aa:	786080e7          	jalr	1926(ra) # 5a2c <unlink>
    32ae:	06054163          	bltz	a0,3310 <dirtest+0xba>
}
    32b2:	60e2                	ld	ra,24(sp)
    32b4:	6442                	ld	s0,16(sp)
    32b6:	64a2                	ld	s1,8(sp)
    32b8:	6105                	addi	sp,sp,32
    32ba:	8082                	ret
    printf("%s: mkdir failed\n", s);
    32bc:	85a6                	mv	a1,s1
    32be:	00004517          	auipc	a0,0x4
    32c2:	d8250513          	addi	a0,a0,-638 # 7040 <malloc+0x121a>
    32c6:	00003097          	auipc	ra,0x3
    32ca:	aa8080e7          	jalr	-1368(ra) # 5d6e <printf>
    exit(1);
    32ce:	4505                	li	a0,1
    32d0:	00002097          	auipc	ra,0x2
    32d4:	70c080e7          	jalr	1804(ra) # 59dc <exit>
    printf("%s: chdir dir0 failed\n", s);
    32d8:	85a6                	mv	a1,s1
    32da:	00004517          	auipc	a0,0x4
    32de:	e0e50513          	addi	a0,a0,-498 # 70e8 <malloc+0x12c2>
    32e2:	00003097          	auipc	ra,0x3
    32e6:	a8c080e7          	jalr	-1396(ra) # 5d6e <printf>
    exit(1);
    32ea:	4505                	li	a0,1
    32ec:	00002097          	auipc	ra,0x2
    32f0:	6f0080e7          	jalr	1776(ra) # 59dc <exit>
    printf("%s: chdir .. failed\n", s);
    32f4:	85a6                	mv	a1,s1
    32f6:	00004517          	auipc	a0,0x4
    32fa:	e1250513          	addi	a0,a0,-494 # 7108 <malloc+0x12e2>
    32fe:	00003097          	auipc	ra,0x3
    3302:	a70080e7          	jalr	-1424(ra) # 5d6e <printf>
    exit(1);
    3306:	4505                	li	a0,1
    3308:	00002097          	auipc	ra,0x2
    330c:	6d4080e7          	jalr	1748(ra) # 59dc <exit>
    printf("%s: unlink dir0 failed\n", s);
    3310:	85a6                	mv	a1,s1
    3312:	00004517          	auipc	a0,0x4
    3316:	e0e50513          	addi	a0,a0,-498 # 7120 <malloc+0x12fa>
    331a:	00003097          	auipc	ra,0x3
    331e:	a54080e7          	jalr	-1452(ra) # 5d6e <printf>
    exit(1);
    3322:	4505                	li	a0,1
    3324:	00002097          	auipc	ra,0x2
    3328:	6b8080e7          	jalr	1720(ra) # 59dc <exit>

000000000000332c <subdir>:
{
    332c:	1101                	addi	sp,sp,-32
    332e:	ec06                	sd	ra,24(sp)
    3330:	e822                	sd	s0,16(sp)
    3332:	e426                	sd	s1,8(sp)
    3334:	e04a                	sd	s2,0(sp)
    3336:	1000                	addi	s0,sp,32
    3338:	892a                	mv	s2,a0
  unlink("ff");
    333a:	00004517          	auipc	a0,0x4
    333e:	f2e50513          	addi	a0,a0,-210 # 7268 <malloc+0x1442>
    3342:	00002097          	auipc	ra,0x2
    3346:	6ea080e7          	jalr	1770(ra) # 5a2c <unlink>
  if(mkdir("dd") != 0){
    334a:	00004517          	auipc	a0,0x4
    334e:	dee50513          	addi	a0,a0,-530 # 7138 <malloc+0x1312>
    3352:	00002097          	auipc	ra,0x2
    3356:	6f2080e7          	jalr	1778(ra) # 5a44 <mkdir>
    335a:	38051663          	bnez	a0,36e6 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    335e:	20200593          	li	a1,514
    3362:	00004517          	auipc	a0,0x4
    3366:	df650513          	addi	a0,a0,-522 # 7158 <malloc+0x1332>
    336a:	00002097          	auipc	ra,0x2
    336e:	6b2080e7          	jalr	1714(ra) # 5a1c <open>
    3372:	84aa                	mv	s1,a0
  if(fd < 0){
    3374:	38054763          	bltz	a0,3702 <subdir+0x3d6>
  write(fd, "ff", 2);
    3378:	4609                	li	a2,2
    337a:	00004597          	auipc	a1,0x4
    337e:	eee58593          	addi	a1,a1,-274 # 7268 <malloc+0x1442>
    3382:	00002097          	auipc	ra,0x2
    3386:	67a080e7          	jalr	1658(ra) # 59fc <write>
  close(fd);
    338a:	8526                	mv	a0,s1
    338c:	00002097          	auipc	ra,0x2
    3390:	678080e7          	jalr	1656(ra) # 5a04 <close>
  if(unlink("dd") >= 0){
    3394:	00004517          	auipc	a0,0x4
    3398:	da450513          	addi	a0,a0,-604 # 7138 <malloc+0x1312>
    339c:	00002097          	auipc	ra,0x2
    33a0:	690080e7          	jalr	1680(ra) # 5a2c <unlink>
    33a4:	36055d63          	bgez	a0,371e <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    33a8:	00004517          	auipc	a0,0x4
    33ac:	e0850513          	addi	a0,a0,-504 # 71b0 <malloc+0x138a>
    33b0:	00002097          	auipc	ra,0x2
    33b4:	694080e7          	jalr	1684(ra) # 5a44 <mkdir>
    33b8:	38051163          	bnez	a0,373a <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    33bc:	20200593          	li	a1,514
    33c0:	00004517          	auipc	a0,0x4
    33c4:	e1850513          	addi	a0,a0,-488 # 71d8 <malloc+0x13b2>
    33c8:	00002097          	auipc	ra,0x2
    33cc:	654080e7          	jalr	1620(ra) # 5a1c <open>
    33d0:	84aa                	mv	s1,a0
  if(fd < 0){
    33d2:	38054263          	bltz	a0,3756 <subdir+0x42a>
  write(fd, "FF", 2);
    33d6:	4609                	li	a2,2
    33d8:	00004597          	auipc	a1,0x4
    33dc:	e3058593          	addi	a1,a1,-464 # 7208 <malloc+0x13e2>
    33e0:	00002097          	auipc	ra,0x2
    33e4:	61c080e7          	jalr	1564(ra) # 59fc <write>
  close(fd);
    33e8:	8526                	mv	a0,s1
    33ea:	00002097          	auipc	ra,0x2
    33ee:	61a080e7          	jalr	1562(ra) # 5a04 <close>
  fd = open("dd/dd/../ff", 0);
    33f2:	4581                	li	a1,0
    33f4:	00004517          	auipc	a0,0x4
    33f8:	e1c50513          	addi	a0,a0,-484 # 7210 <malloc+0x13ea>
    33fc:	00002097          	auipc	ra,0x2
    3400:	620080e7          	jalr	1568(ra) # 5a1c <open>
    3404:	84aa                	mv	s1,a0
  if(fd < 0){
    3406:	36054663          	bltz	a0,3772 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    340a:	660d                	lui	a2,0x3
    340c:	0000a597          	auipc	a1,0xa
    3410:	85c58593          	addi	a1,a1,-1956 # cc68 <buf>
    3414:	00002097          	auipc	ra,0x2
    3418:	5e0080e7          	jalr	1504(ra) # 59f4 <read>
  if(cc != 2 || buf[0] != 'f'){
    341c:	4789                	li	a5,2
    341e:	36f51863          	bne	a0,a5,378e <subdir+0x462>
    3422:	0000a717          	auipc	a4,0xa
    3426:	84674703          	lbu	a4,-1978(a4) # cc68 <buf>
    342a:	06600793          	li	a5,102
    342e:	36f71063          	bne	a4,a5,378e <subdir+0x462>
  close(fd);
    3432:	8526                	mv	a0,s1
    3434:	00002097          	auipc	ra,0x2
    3438:	5d0080e7          	jalr	1488(ra) # 5a04 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    343c:	00004597          	auipc	a1,0x4
    3440:	e2458593          	addi	a1,a1,-476 # 7260 <malloc+0x143a>
    3444:	00004517          	auipc	a0,0x4
    3448:	d9450513          	addi	a0,a0,-620 # 71d8 <malloc+0x13b2>
    344c:	00002097          	auipc	ra,0x2
    3450:	5f0080e7          	jalr	1520(ra) # 5a3c <link>
    3454:	34051b63          	bnez	a0,37aa <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3458:	00004517          	auipc	a0,0x4
    345c:	d8050513          	addi	a0,a0,-640 # 71d8 <malloc+0x13b2>
    3460:	00002097          	auipc	ra,0x2
    3464:	5cc080e7          	jalr	1484(ra) # 5a2c <unlink>
    3468:	34051f63          	bnez	a0,37c6 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    346c:	4581                	li	a1,0
    346e:	00004517          	auipc	a0,0x4
    3472:	d6a50513          	addi	a0,a0,-662 # 71d8 <malloc+0x13b2>
    3476:	00002097          	auipc	ra,0x2
    347a:	5a6080e7          	jalr	1446(ra) # 5a1c <open>
    347e:	36055263          	bgez	a0,37e2 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3482:	00004517          	auipc	a0,0x4
    3486:	cb650513          	addi	a0,a0,-842 # 7138 <malloc+0x1312>
    348a:	00002097          	auipc	ra,0x2
    348e:	5c2080e7          	jalr	1474(ra) # 5a4c <chdir>
    3492:	36051663          	bnez	a0,37fe <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3496:	00004517          	auipc	a0,0x4
    349a:	e6250513          	addi	a0,a0,-414 # 72f8 <malloc+0x14d2>
    349e:	00002097          	auipc	ra,0x2
    34a2:	5ae080e7          	jalr	1454(ra) # 5a4c <chdir>
    34a6:	36051a63          	bnez	a0,381a <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    34aa:	00004517          	auipc	a0,0x4
    34ae:	e7e50513          	addi	a0,a0,-386 # 7328 <malloc+0x1502>
    34b2:	00002097          	auipc	ra,0x2
    34b6:	59a080e7          	jalr	1434(ra) # 5a4c <chdir>
    34ba:	36051e63          	bnez	a0,3836 <subdir+0x50a>
  if(chdir("./..") != 0){
    34be:	00004517          	auipc	a0,0x4
    34c2:	e9a50513          	addi	a0,a0,-358 # 7358 <malloc+0x1532>
    34c6:	00002097          	auipc	ra,0x2
    34ca:	586080e7          	jalr	1414(ra) # 5a4c <chdir>
    34ce:	38051263          	bnez	a0,3852 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    34d2:	4581                	li	a1,0
    34d4:	00004517          	auipc	a0,0x4
    34d8:	d8c50513          	addi	a0,a0,-628 # 7260 <malloc+0x143a>
    34dc:	00002097          	auipc	ra,0x2
    34e0:	540080e7          	jalr	1344(ra) # 5a1c <open>
    34e4:	84aa                	mv	s1,a0
  if(fd < 0){
    34e6:	38054463          	bltz	a0,386e <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    34ea:	660d                	lui	a2,0x3
    34ec:	00009597          	auipc	a1,0x9
    34f0:	77c58593          	addi	a1,a1,1916 # cc68 <buf>
    34f4:	00002097          	auipc	ra,0x2
    34f8:	500080e7          	jalr	1280(ra) # 59f4 <read>
    34fc:	4789                	li	a5,2
    34fe:	38f51663          	bne	a0,a5,388a <subdir+0x55e>
  close(fd);
    3502:	8526                	mv	a0,s1
    3504:	00002097          	auipc	ra,0x2
    3508:	500080e7          	jalr	1280(ra) # 5a04 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    350c:	4581                	li	a1,0
    350e:	00004517          	auipc	a0,0x4
    3512:	cca50513          	addi	a0,a0,-822 # 71d8 <malloc+0x13b2>
    3516:	00002097          	auipc	ra,0x2
    351a:	506080e7          	jalr	1286(ra) # 5a1c <open>
    351e:	38055463          	bgez	a0,38a6 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3522:	20200593          	li	a1,514
    3526:	00004517          	auipc	a0,0x4
    352a:	ec250513          	addi	a0,a0,-318 # 73e8 <malloc+0x15c2>
    352e:	00002097          	auipc	ra,0x2
    3532:	4ee080e7          	jalr	1262(ra) # 5a1c <open>
    3536:	38055663          	bgez	a0,38c2 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    353a:	20200593          	li	a1,514
    353e:	00004517          	auipc	a0,0x4
    3542:	eda50513          	addi	a0,a0,-294 # 7418 <malloc+0x15f2>
    3546:	00002097          	auipc	ra,0x2
    354a:	4d6080e7          	jalr	1238(ra) # 5a1c <open>
    354e:	38055863          	bgez	a0,38de <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3552:	20000593          	li	a1,512
    3556:	00004517          	auipc	a0,0x4
    355a:	be250513          	addi	a0,a0,-1054 # 7138 <malloc+0x1312>
    355e:	00002097          	auipc	ra,0x2
    3562:	4be080e7          	jalr	1214(ra) # 5a1c <open>
    3566:	38055a63          	bgez	a0,38fa <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    356a:	4589                	li	a1,2
    356c:	00004517          	auipc	a0,0x4
    3570:	bcc50513          	addi	a0,a0,-1076 # 7138 <malloc+0x1312>
    3574:	00002097          	auipc	ra,0x2
    3578:	4a8080e7          	jalr	1192(ra) # 5a1c <open>
    357c:	38055d63          	bgez	a0,3916 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3580:	4585                	li	a1,1
    3582:	00004517          	auipc	a0,0x4
    3586:	bb650513          	addi	a0,a0,-1098 # 7138 <malloc+0x1312>
    358a:	00002097          	auipc	ra,0x2
    358e:	492080e7          	jalr	1170(ra) # 5a1c <open>
    3592:	3a055063          	bgez	a0,3932 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3596:	00004597          	auipc	a1,0x4
    359a:	f1258593          	addi	a1,a1,-238 # 74a8 <malloc+0x1682>
    359e:	00004517          	auipc	a0,0x4
    35a2:	e4a50513          	addi	a0,a0,-438 # 73e8 <malloc+0x15c2>
    35a6:	00002097          	auipc	ra,0x2
    35aa:	496080e7          	jalr	1174(ra) # 5a3c <link>
    35ae:	3a050063          	beqz	a0,394e <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    35b2:	00004597          	auipc	a1,0x4
    35b6:	ef658593          	addi	a1,a1,-266 # 74a8 <malloc+0x1682>
    35ba:	00004517          	auipc	a0,0x4
    35be:	e5e50513          	addi	a0,a0,-418 # 7418 <malloc+0x15f2>
    35c2:	00002097          	auipc	ra,0x2
    35c6:	47a080e7          	jalr	1146(ra) # 5a3c <link>
    35ca:	3a050063          	beqz	a0,396a <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    35ce:	00004597          	auipc	a1,0x4
    35d2:	c9258593          	addi	a1,a1,-878 # 7260 <malloc+0x143a>
    35d6:	00004517          	auipc	a0,0x4
    35da:	b8250513          	addi	a0,a0,-1150 # 7158 <malloc+0x1332>
    35de:	00002097          	auipc	ra,0x2
    35e2:	45e080e7          	jalr	1118(ra) # 5a3c <link>
    35e6:	3a050063          	beqz	a0,3986 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    35ea:	00004517          	auipc	a0,0x4
    35ee:	dfe50513          	addi	a0,a0,-514 # 73e8 <malloc+0x15c2>
    35f2:	00002097          	auipc	ra,0x2
    35f6:	452080e7          	jalr	1106(ra) # 5a44 <mkdir>
    35fa:	3a050463          	beqz	a0,39a2 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    35fe:	00004517          	auipc	a0,0x4
    3602:	e1a50513          	addi	a0,a0,-486 # 7418 <malloc+0x15f2>
    3606:	00002097          	auipc	ra,0x2
    360a:	43e080e7          	jalr	1086(ra) # 5a44 <mkdir>
    360e:	3a050863          	beqz	a0,39be <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3612:	00004517          	auipc	a0,0x4
    3616:	c4e50513          	addi	a0,a0,-946 # 7260 <malloc+0x143a>
    361a:	00002097          	auipc	ra,0x2
    361e:	42a080e7          	jalr	1066(ra) # 5a44 <mkdir>
    3622:	3a050c63          	beqz	a0,39da <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3626:	00004517          	auipc	a0,0x4
    362a:	df250513          	addi	a0,a0,-526 # 7418 <malloc+0x15f2>
    362e:	00002097          	auipc	ra,0x2
    3632:	3fe080e7          	jalr	1022(ra) # 5a2c <unlink>
    3636:	3c050063          	beqz	a0,39f6 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    363a:	00004517          	auipc	a0,0x4
    363e:	dae50513          	addi	a0,a0,-594 # 73e8 <malloc+0x15c2>
    3642:	00002097          	auipc	ra,0x2
    3646:	3ea080e7          	jalr	1002(ra) # 5a2c <unlink>
    364a:	3c050463          	beqz	a0,3a12 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    364e:	00004517          	auipc	a0,0x4
    3652:	b0a50513          	addi	a0,a0,-1270 # 7158 <malloc+0x1332>
    3656:	00002097          	auipc	ra,0x2
    365a:	3f6080e7          	jalr	1014(ra) # 5a4c <chdir>
    365e:	3c050863          	beqz	a0,3a2e <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3662:	00004517          	auipc	a0,0x4
    3666:	f9650513          	addi	a0,a0,-106 # 75f8 <malloc+0x17d2>
    366a:	00002097          	auipc	ra,0x2
    366e:	3e2080e7          	jalr	994(ra) # 5a4c <chdir>
    3672:	3c050c63          	beqz	a0,3a4a <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3676:	00004517          	auipc	a0,0x4
    367a:	bea50513          	addi	a0,a0,-1046 # 7260 <malloc+0x143a>
    367e:	00002097          	auipc	ra,0x2
    3682:	3ae080e7          	jalr	942(ra) # 5a2c <unlink>
    3686:	3e051063          	bnez	a0,3a66 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    368a:	00004517          	auipc	a0,0x4
    368e:	ace50513          	addi	a0,a0,-1330 # 7158 <malloc+0x1332>
    3692:	00002097          	auipc	ra,0x2
    3696:	39a080e7          	jalr	922(ra) # 5a2c <unlink>
    369a:	3e051463          	bnez	a0,3a82 <subdir+0x756>
  if(unlink("dd") == 0){
    369e:	00004517          	auipc	a0,0x4
    36a2:	a9a50513          	addi	a0,a0,-1382 # 7138 <malloc+0x1312>
    36a6:	00002097          	auipc	ra,0x2
    36aa:	386080e7          	jalr	902(ra) # 5a2c <unlink>
    36ae:	3e050863          	beqz	a0,3a9e <subdir+0x772>
  if(unlink("dd/dd") < 0){
    36b2:	00004517          	auipc	a0,0x4
    36b6:	fb650513          	addi	a0,a0,-74 # 7668 <malloc+0x1842>
    36ba:	00002097          	auipc	ra,0x2
    36be:	372080e7          	jalr	882(ra) # 5a2c <unlink>
    36c2:	3e054c63          	bltz	a0,3aba <subdir+0x78e>
  if(unlink("dd") < 0){
    36c6:	00004517          	auipc	a0,0x4
    36ca:	a7250513          	addi	a0,a0,-1422 # 7138 <malloc+0x1312>
    36ce:	00002097          	auipc	ra,0x2
    36d2:	35e080e7          	jalr	862(ra) # 5a2c <unlink>
    36d6:	40054063          	bltz	a0,3ad6 <subdir+0x7aa>
}
    36da:	60e2                	ld	ra,24(sp)
    36dc:	6442                	ld	s0,16(sp)
    36de:	64a2                	ld	s1,8(sp)
    36e0:	6902                	ld	s2,0(sp)
    36e2:	6105                	addi	sp,sp,32
    36e4:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    36e6:	85ca                	mv	a1,s2
    36e8:	00004517          	auipc	a0,0x4
    36ec:	a5850513          	addi	a0,a0,-1448 # 7140 <malloc+0x131a>
    36f0:	00002097          	auipc	ra,0x2
    36f4:	67e080e7          	jalr	1662(ra) # 5d6e <printf>
    exit(1);
    36f8:	4505                	li	a0,1
    36fa:	00002097          	auipc	ra,0x2
    36fe:	2e2080e7          	jalr	738(ra) # 59dc <exit>
    printf("%s: create dd/ff failed\n", s);
    3702:	85ca                	mv	a1,s2
    3704:	00004517          	auipc	a0,0x4
    3708:	a5c50513          	addi	a0,a0,-1444 # 7160 <malloc+0x133a>
    370c:	00002097          	auipc	ra,0x2
    3710:	662080e7          	jalr	1634(ra) # 5d6e <printf>
    exit(1);
    3714:	4505                	li	a0,1
    3716:	00002097          	auipc	ra,0x2
    371a:	2c6080e7          	jalr	710(ra) # 59dc <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    371e:	85ca                	mv	a1,s2
    3720:	00004517          	auipc	a0,0x4
    3724:	a6050513          	addi	a0,a0,-1440 # 7180 <malloc+0x135a>
    3728:	00002097          	auipc	ra,0x2
    372c:	646080e7          	jalr	1606(ra) # 5d6e <printf>
    exit(1);
    3730:	4505                	li	a0,1
    3732:	00002097          	auipc	ra,0x2
    3736:	2aa080e7          	jalr	682(ra) # 59dc <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    373a:	85ca                	mv	a1,s2
    373c:	00004517          	auipc	a0,0x4
    3740:	a7c50513          	addi	a0,a0,-1412 # 71b8 <malloc+0x1392>
    3744:	00002097          	auipc	ra,0x2
    3748:	62a080e7          	jalr	1578(ra) # 5d6e <printf>
    exit(1);
    374c:	4505                	li	a0,1
    374e:	00002097          	auipc	ra,0x2
    3752:	28e080e7          	jalr	654(ra) # 59dc <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3756:	85ca                	mv	a1,s2
    3758:	00004517          	auipc	a0,0x4
    375c:	a9050513          	addi	a0,a0,-1392 # 71e8 <malloc+0x13c2>
    3760:	00002097          	auipc	ra,0x2
    3764:	60e080e7          	jalr	1550(ra) # 5d6e <printf>
    exit(1);
    3768:	4505                	li	a0,1
    376a:	00002097          	auipc	ra,0x2
    376e:	272080e7          	jalr	626(ra) # 59dc <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3772:	85ca                	mv	a1,s2
    3774:	00004517          	auipc	a0,0x4
    3778:	aac50513          	addi	a0,a0,-1364 # 7220 <malloc+0x13fa>
    377c:	00002097          	auipc	ra,0x2
    3780:	5f2080e7          	jalr	1522(ra) # 5d6e <printf>
    exit(1);
    3784:	4505                	li	a0,1
    3786:	00002097          	auipc	ra,0x2
    378a:	256080e7          	jalr	598(ra) # 59dc <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    378e:	85ca                	mv	a1,s2
    3790:	00004517          	auipc	a0,0x4
    3794:	ab050513          	addi	a0,a0,-1360 # 7240 <malloc+0x141a>
    3798:	00002097          	auipc	ra,0x2
    379c:	5d6080e7          	jalr	1494(ra) # 5d6e <printf>
    exit(1);
    37a0:	4505                	li	a0,1
    37a2:	00002097          	auipc	ra,0x2
    37a6:	23a080e7          	jalr	570(ra) # 59dc <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    37aa:	85ca                	mv	a1,s2
    37ac:	00004517          	auipc	a0,0x4
    37b0:	ac450513          	addi	a0,a0,-1340 # 7270 <malloc+0x144a>
    37b4:	00002097          	auipc	ra,0x2
    37b8:	5ba080e7          	jalr	1466(ra) # 5d6e <printf>
    exit(1);
    37bc:	4505                	li	a0,1
    37be:	00002097          	auipc	ra,0x2
    37c2:	21e080e7          	jalr	542(ra) # 59dc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    37c6:	85ca                	mv	a1,s2
    37c8:	00004517          	auipc	a0,0x4
    37cc:	ad050513          	addi	a0,a0,-1328 # 7298 <malloc+0x1472>
    37d0:	00002097          	auipc	ra,0x2
    37d4:	59e080e7          	jalr	1438(ra) # 5d6e <printf>
    exit(1);
    37d8:	4505                	li	a0,1
    37da:	00002097          	auipc	ra,0x2
    37de:	202080e7          	jalr	514(ra) # 59dc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    37e2:	85ca                	mv	a1,s2
    37e4:	00004517          	auipc	a0,0x4
    37e8:	ad450513          	addi	a0,a0,-1324 # 72b8 <malloc+0x1492>
    37ec:	00002097          	auipc	ra,0x2
    37f0:	582080e7          	jalr	1410(ra) # 5d6e <printf>
    exit(1);
    37f4:	4505                	li	a0,1
    37f6:	00002097          	auipc	ra,0x2
    37fa:	1e6080e7          	jalr	486(ra) # 59dc <exit>
    printf("%s: chdir dd failed\n", s);
    37fe:	85ca                	mv	a1,s2
    3800:	00004517          	auipc	a0,0x4
    3804:	ae050513          	addi	a0,a0,-1312 # 72e0 <malloc+0x14ba>
    3808:	00002097          	auipc	ra,0x2
    380c:	566080e7          	jalr	1382(ra) # 5d6e <printf>
    exit(1);
    3810:	4505                	li	a0,1
    3812:	00002097          	auipc	ra,0x2
    3816:	1ca080e7          	jalr	458(ra) # 59dc <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    381a:	85ca                	mv	a1,s2
    381c:	00004517          	auipc	a0,0x4
    3820:	aec50513          	addi	a0,a0,-1300 # 7308 <malloc+0x14e2>
    3824:	00002097          	auipc	ra,0x2
    3828:	54a080e7          	jalr	1354(ra) # 5d6e <printf>
    exit(1);
    382c:	4505                	li	a0,1
    382e:	00002097          	auipc	ra,0x2
    3832:	1ae080e7          	jalr	430(ra) # 59dc <exit>
    printf("chdir dd/../../dd failed\n", s);
    3836:	85ca                	mv	a1,s2
    3838:	00004517          	auipc	a0,0x4
    383c:	b0050513          	addi	a0,a0,-1280 # 7338 <malloc+0x1512>
    3840:	00002097          	auipc	ra,0x2
    3844:	52e080e7          	jalr	1326(ra) # 5d6e <printf>
    exit(1);
    3848:	4505                	li	a0,1
    384a:	00002097          	auipc	ra,0x2
    384e:	192080e7          	jalr	402(ra) # 59dc <exit>
    printf("%s: chdir ./.. failed\n", s);
    3852:	85ca                	mv	a1,s2
    3854:	00004517          	auipc	a0,0x4
    3858:	b0c50513          	addi	a0,a0,-1268 # 7360 <malloc+0x153a>
    385c:	00002097          	auipc	ra,0x2
    3860:	512080e7          	jalr	1298(ra) # 5d6e <printf>
    exit(1);
    3864:	4505                	li	a0,1
    3866:	00002097          	auipc	ra,0x2
    386a:	176080e7          	jalr	374(ra) # 59dc <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    386e:	85ca                	mv	a1,s2
    3870:	00004517          	auipc	a0,0x4
    3874:	b0850513          	addi	a0,a0,-1272 # 7378 <malloc+0x1552>
    3878:	00002097          	auipc	ra,0x2
    387c:	4f6080e7          	jalr	1270(ra) # 5d6e <printf>
    exit(1);
    3880:	4505                	li	a0,1
    3882:	00002097          	auipc	ra,0x2
    3886:	15a080e7          	jalr	346(ra) # 59dc <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    388a:	85ca                	mv	a1,s2
    388c:	00004517          	auipc	a0,0x4
    3890:	b0c50513          	addi	a0,a0,-1268 # 7398 <malloc+0x1572>
    3894:	00002097          	auipc	ra,0x2
    3898:	4da080e7          	jalr	1242(ra) # 5d6e <printf>
    exit(1);
    389c:	4505                	li	a0,1
    389e:	00002097          	auipc	ra,0x2
    38a2:	13e080e7          	jalr	318(ra) # 59dc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    38a6:	85ca                	mv	a1,s2
    38a8:	00004517          	auipc	a0,0x4
    38ac:	b1050513          	addi	a0,a0,-1264 # 73b8 <malloc+0x1592>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	4be080e7          	jalr	1214(ra) # 5d6e <printf>
    exit(1);
    38b8:	4505                	li	a0,1
    38ba:	00002097          	auipc	ra,0x2
    38be:	122080e7          	jalr	290(ra) # 59dc <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    38c2:	85ca                	mv	a1,s2
    38c4:	00004517          	auipc	a0,0x4
    38c8:	b3450513          	addi	a0,a0,-1228 # 73f8 <malloc+0x15d2>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	4a2080e7          	jalr	1186(ra) # 5d6e <printf>
    exit(1);
    38d4:	4505                	li	a0,1
    38d6:	00002097          	auipc	ra,0x2
    38da:	106080e7          	jalr	262(ra) # 59dc <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    38de:	85ca                	mv	a1,s2
    38e0:	00004517          	auipc	a0,0x4
    38e4:	b4850513          	addi	a0,a0,-1208 # 7428 <malloc+0x1602>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	486080e7          	jalr	1158(ra) # 5d6e <printf>
    exit(1);
    38f0:	4505                	li	a0,1
    38f2:	00002097          	auipc	ra,0x2
    38f6:	0ea080e7          	jalr	234(ra) # 59dc <exit>
    printf("%s: create dd succeeded!\n", s);
    38fa:	85ca                	mv	a1,s2
    38fc:	00004517          	auipc	a0,0x4
    3900:	b4c50513          	addi	a0,a0,-1204 # 7448 <malloc+0x1622>
    3904:	00002097          	auipc	ra,0x2
    3908:	46a080e7          	jalr	1130(ra) # 5d6e <printf>
    exit(1);
    390c:	4505                	li	a0,1
    390e:	00002097          	auipc	ra,0x2
    3912:	0ce080e7          	jalr	206(ra) # 59dc <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3916:	85ca                	mv	a1,s2
    3918:	00004517          	auipc	a0,0x4
    391c:	b5050513          	addi	a0,a0,-1200 # 7468 <malloc+0x1642>
    3920:	00002097          	auipc	ra,0x2
    3924:	44e080e7          	jalr	1102(ra) # 5d6e <printf>
    exit(1);
    3928:	4505                	li	a0,1
    392a:	00002097          	auipc	ra,0x2
    392e:	0b2080e7          	jalr	178(ra) # 59dc <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3932:	85ca                	mv	a1,s2
    3934:	00004517          	auipc	a0,0x4
    3938:	b5450513          	addi	a0,a0,-1196 # 7488 <malloc+0x1662>
    393c:	00002097          	auipc	ra,0x2
    3940:	432080e7          	jalr	1074(ra) # 5d6e <printf>
    exit(1);
    3944:	4505                	li	a0,1
    3946:	00002097          	auipc	ra,0x2
    394a:	096080e7          	jalr	150(ra) # 59dc <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    394e:	85ca                	mv	a1,s2
    3950:	00004517          	auipc	a0,0x4
    3954:	b6850513          	addi	a0,a0,-1176 # 74b8 <malloc+0x1692>
    3958:	00002097          	auipc	ra,0x2
    395c:	416080e7          	jalr	1046(ra) # 5d6e <printf>
    exit(1);
    3960:	4505                	li	a0,1
    3962:	00002097          	auipc	ra,0x2
    3966:	07a080e7          	jalr	122(ra) # 59dc <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    396a:	85ca                	mv	a1,s2
    396c:	00004517          	auipc	a0,0x4
    3970:	b7450513          	addi	a0,a0,-1164 # 74e0 <malloc+0x16ba>
    3974:	00002097          	auipc	ra,0x2
    3978:	3fa080e7          	jalr	1018(ra) # 5d6e <printf>
    exit(1);
    397c:	4505                	li	a0,1
    397e:	00002097          	auipc	ra,0x2
    3982:	05e080e7          	jalr	94(ra) # 59dc <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3986:	85ca                	mv	a1,s2
    3988:	00004517          	auipc	a0,0x4
    398c:	b8050513          	addi	a0,a0,-1152 # 7508 <malloc+0x16e2>
    3990:	00002097          	auipc	ra,0x2
    3994:	3de080e7          	jalr	990(ra) # 5d6e <printf>
    exit(1);
    3998:	4505                	li	a0,1
    399a:	00002097          	auipc	ra,0x2
    399e:	042080e7          	jalr	66(ra) # 59dc <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    39a2:	85ca                	mv	a1,s2
    39a4:	00004517          	auipc	a0,0x4
    39a8:	b8c50513          	addi	a0,a0,-1140 # 7530 <malloc+0x170a>
    39ac:	00002097          	auipc	ra,0x2
    39b0:	3c2080e7          	jalr	962(ra) # 5d6e <printf>
    exit(1);
    39b4:	4505                	li	a0,1
    39b6:	00002097          	auipc	ra,0x2
    39ba:	026080e7          	jalr	38(ra) # 59dc <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    39be:	85ca                	mv	a1,s2
    39c0:	00004517          	auipc	a0,0x4
    39c4:	b9050513          	addi	a0,a0,-1136 # 7550 <malloc+0x172a>
    39c8:	00002097          	auipc	ra,0x2
    39cc:	3a6080e7          	jalr	934(ra) # 5d6e <printf>
    exit(1);
    39d0:	4505                	li	a0,1
    39d2:	00002097          	auipc	ra,0x2
    39d6:	00a080e7          	jalr	10(ra) # 59dc <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    39da:	85ca                	mv	a1,s2
    39dc:	00004517          	auipc	a0,0x4
    39e0:	b9450513          	addi	a0,a0,-1132 # 7570 <malloc+0x174a>
    39e4:	00002097          	auipc	ra,0x2
    39e8:	38a080e7          	jalr	906(ra) # 5d6e <printf>
    exit(1);
    39ec:	4505                	li	a0,1
    39ee:	00002097          	auipc	ra,0x2
    39f2:	fee080e7          	jalr	-18(ra) # 59dc <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    39f6:	85ca                	mv	a1,s2
    39f8:	00004517          	auipc	a0,0x4
    39fc:	ba050513          	addi	a0,a0,-1120 # 7598 <malloc+0x1772>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	36e080e7          	jalr	878(ra) # 5d6e <printf>
    exit(1);
    3a08:	4505                	li	a0,1
    3a0a:	00002097          	auipc	ra,0x2
    3a0e:	fd2080e7          	jalr	-46(ra) # 59dc <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3a12:	85ca                	mv	a1,s2
    3a14:	00004517          	auipc	a0,0x4
    3a18:	ba450513          	addi	a0,a0,-1116 # 75b8 <malloc+0x1792>
    3a1c:	00002097          	auipc	ra,0x2
    3a20:	352080e7          	jalr	850(ra) # 5d6e <printf>
    exit(1);
    3a24:	4505                	li	a0,1
    3a26:	00002097          	auipc	ra,0x2
    3a2a:	fb6080e7          	jalr	-74(ra) # 59dc <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3a2e:	85ca                	mv	a1,s2
    3a30:	00004517          	auipc	a0,0x4
    3a34:	ba850513          	addi	a0,a0,-1112 # 75d8 <malloc+0x17b2>
    3a38:	00002097          	auipc	ra,0x2
    3a3c:	336080e7          	jalr	822(ra) # 5d6e <printf>
    exit(1);
    3a40:	4505                	li	a0,1
    3a42:	00002097          	auipc	ra,0x2
    3a46:	f9a080e7          	jalr	-102(ra) # 59dc <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3a4a:	85ca                	mv	a1,s2
    3a4c:	00004517          	auipc	a0,0x4
    3a50:	bb450513          	addi	a0,a0,-1100 # 7600 <malloc+0x17da>
    3a54:	00002097          	auipc	ra,0x2
    3a58:	31a080e7          	jalr	794(ra) # 5d6e <printf>
    exit(1);
    3a5c:	4505                	li	a0,1
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	f7e080e7          	jalr	-130(ra) # 59dc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3a66:	85ca                	mv	a1,s2
    3a68:	00004517          	auipc	a0,0x4
    3a6c:	83050513          	addi	a0,a0,-2000 # 7298 <malloc+0x1472>
    3a70:	00002097          	auipc	ra,0x2
    3a74:	2fe080e7          	jalr	766(ra) # 5d6e <printf>
    exit(1);
    3a78:	4505                	li	a0,1
    3a7a:	00002097          	auipc	ra,0x2
    3a7e:	f62080e7          	jalr	-158(ra) # 59dc <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3a82:	85ca                	mv	a1,s2
    3a84:	00004517          	auipc	a0,0x4
    3a88:	b9c50513          	addi	a0,a0,-1124 # 7620 <malloc+0x17fa>
    3a8c:	00002097          	auipc	ra,0x2
    3a90:	2e2080e7          	jalr	738(ra) # 5d6e <printf>
    exit(1);
    3a94:	4505                	li	a0,1
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	f46080e7          	jalr	-186(ra) # 59dc <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3a9e:	85ca                	mv	a1,s2
    3aa0:	00004517          	auipc	a0,0x4
    3aa4:	ba050513          	addi	a0,a0,-1120 # 7640 <malloc+0x181a>
    3aa8:	00002097          	auipc	ra,0x2
    3aac:	2c6080e7          	jalr	710(ra) # 5d6e <printf>
    exit(1);
    3ab0:	4505                	li	a0,1
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	f2a080e7          	jalr	-214(ra) # 59dc <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3aba:	85ca                	mv	a1,s2
    3abc:	00004517          	auipc	a0,0x4
    3ac0:	bb450513          	addi	a0,a0,-1100 # 7670 <malloc+0x184a>
    3ac4:	00002097          	auipc	ra,0x2
    3ac8:	2aa080e7          	jalr	682(ra) # 5d6e <printf>
    exit(1);
    3acc:	4505                	li	a0,1
    3ace:	00002097          	auipc	ra,0x2
    3ad2:	f0e080e7          	jalr	-242(ra) # 59dc <exit>
    printf("%s: unlink dd failed\n", s);
    3ad6:	85ca                	mv	a1,s2
    3ad8:	00004517          	auipc	a0,0x4
    3adc:	bb850513          	addi	a0,a0,-1096 # 7690 <malloc+0x186a>
    3ae0:	00002097          	auipc	ra,0x2
    3ae4:	28e080e7          	jalr	654(ra) # 5d6e <printf>
    exit(1);
    3ae8:	4505                	li	a0,1
    3aea:	00002097          	auipc	ra,0x2
    3aee:	ef2080e7          	jalr	-270(ra) # 59dc <exit>

0000000000003af2 <rmdot>:
{
    3af2:	1101                	addi	sp,sp,-32
    3af4:	ec06                	sd	ra,24(sp)
    3af6:	e822                	sd	s0,16(sp)
    3af8:	e426                	sd	s1,8(sp)
    3afa:	1000                	addi	s0,sp,32
    3afc:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3afe:	00004517          	auipc	a0,0x4
    3b02:	baa50513          	addi	a0,a0,-1110 # 76a8 <malloc+0x1882>
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	f3e080e7          	jalr	-194(ra) # 5a44 <mkdir>
    3b0e:	e549                	bnez	a0,3b98 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3b10:	00004517          	auipc	a0,0x4
    3b14:	b9850513          	addi	a0,a0,-1128 # 76a8 <malloc+0x1882>
    3b18:	00002097          	auipc	ra,0x2
    3b1c:	f34080e7          	jalr	-204(ra) # 5a4c <chdir>
    3b20:	e951                	bnez	a0,3bb4 <rmdot+0xc2>
  if(unlink(".") == 0){
    3b22:	00003517          	auipc	a0,0x3
    3b26:	a1e50513          	addi	a0,a0,-1506 # 6540 <malloc+0x71a>
    3b2a:	00002097          	auipc	ra,0x2
    3b2e:	f02080e7          	jalr	-254(ra) # 5a2c <unlink>
    3b32:	cd59                	beqz	a0,3bd0 <rmdot+0xde>
  if(unlink("..") == 0){
    3b34:	00003517          	auipc	a0,0x3
    3b38:	5cc50513          	addi	a0,a0,1484 # 7100 <malloc+0x12da>
    3b3c:	00002097          	auipc	ra,0x2
    3b40:	ef0080e7          	jalr	-272(ra) # 5a2c <unlink>
    3b44:	c545                	beqz	a0,3bec <rmdot+0xfa>
  if(chdir("/") != 0){
    3b46:	00003517          	auipc	a0,0x3
    3b4a:	56250513          	addi	a0,a0,1378 # 70a8 <malloc+0x1282>
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	efe080e7          	jalr	-258(ra) # 5a4c <chdir>
    3b56:	e94d                	bnez	a0,3c08 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3b58:	00004517          	auipc	a0,0x4
    3b5c:	bb850513          	addi	a0,a0,-1096 # 7710 <malloc+0x18ea>
    3b60:	00002097          	auipc	ra,0x2
    3b64:	ecc080e7          	jalr	-308(ra) # 5a2c <unlink>
    3b68:	cd55                	beqz	a0,3c24 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3b6a:	00004517          	auipc	a0,0x4
    3b6e:	bce50513          	addi	a0,a0,-1074 # 7738 <malloc+0x1912>
    3b72:	00002097          	auipc	ra,0x2
    3b76:	eba080e7          	jalr	-326(ra) # 5a2c <unlink>
    3b7a:	c179                	beqz	a0,3c40 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3b7c:	00004517          	auipc	a0,0x4
    3b80:	b2c50513          	addi	a0,a0,-1236 # 76a8 <malloc+0x1882>
    3b84:	00002097          	auipc	ra,0x2
    3b88:	ea8080e7          	jalr	-344(ra) # 5a2c <unlink>
    3b8c:	e961                	bnez	a0,3c5c <rmdot+0x16a>
}
    3b8e:	60e2                	ld	ra,24(sp)
    3b90:	6442                	ld	s0,16(sp)
    3b92:	64a2                	ld	s1,8(sp)
    3b94:	6105                	addi	sp,sp,32
    3b96:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3b98:	85a6                	mv	a1,s1
    3b9a:	00004517          	auipc	a0,0x4
    3b9e:	b1650513          	addi	a0,a0,-1258 # 76b0 <malloc+0x188a>
    3ba2:	00002097          	auipc	ra,0x2
    3ba6:	1cc080e7          	jalr	460(ra) # 5d6e <printf>
    exit(1);
    3baa:	4505                	li	a0,1
    3bac:	00002097          	auipc	ra,0x2
    3bb0:	e30080e7          	jalr	-464(ra) # 59dc <exit>
    printf("%s: chdir dots failed\n", s);
    3bb4:	85a6                	mv	a1,s1
    3bb6:	00004517          	auipc	a0,0x4
    3bba:	b1250513          	addi	a0,a0,-1262 # 76c8 <malloc+0x18a2>
    3bbe:	00002097          	auipc	ra,0x2
    3bc2:	1b0080e7          	jalr	432(ra) # 5d6e <printf>
    exit(1);
    3bc6:	4505                	li	a0,1
    3bc8:	00002097          	auipc	ra,0x2
    3bcc:	e14080e7          	jalr	-492(ra) # 59dc <exit>
    printf("%s: rm . worked!\n", s);
    3bd0:	85a6                	mv	a1,s1
    3bd2:	00004517          	auipc	a0,0x4
    3bd6:	b0e50513          	addi	a0,a0,-1266 # 76e0 <malloc+0x18ba>
    3bda:	00002097          	auipc	ra,0x2
    3bde:	194080e7          	jalr	404(ra) # 5d6e <printf>
    exit(1);
    3be2:	4505                	li	a0,1
    3be4:	00002097          	auipc	ra,0x2
    3be8:	df8080e7          	jalr	-520(ra) # 59dc <exit>
    printf("%s: rm .. worked!\n", s);
    3bec:	85a6                	mv	a1,s1
    3bee:	00004517          	auipc	a0,0x4
    3bf2:	b0a50513          	addi	a0,a0,-1270 # 76f8 <malloc+0x18d2>
    3bf6:	00002097          	auipc	ra,0x2
    3bfa:	178080e7          	jalr	376(ra) # 5d6e <printf>
    exit(1);
    3bfe:	4505                	li	a0,1
    3c00:	00002097          	auipc	ra,0x2
    3c04:	ddc080e7          	jalr	-548(ra) # 59dc <exit>
    printf("%s: chdir / failed\n", s);
    3c08:	85a6                	mv	a1,s1
    3c0a:	00003517          	auipc	a0,0x3
    3c0e:	4a650513          	addi	a0,a0,1190 # 70b0 <malloc+0x128a>
    3c12:	00002097          	auipc	ra,0x2
    3c16:	15c080e7          	jalr	348(ra) # 5d6e <printf>
    exit(1);
    3c1a:	4505                	li	a0,1
    3c1c:	00002097          	auipc	ra,0x2
    3c20:	dc0080e7          	jalr	-576(ra) # 59dc <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3c24:	85a6                	mv	a1,s1
    3c26:	00004517          	auipc	a0,0x4
    3c2a:	af250513          	addi	a0,a0,-1294 # 7718 <malloc+0x18f2>
    3c2e:	00002097          	auipc	ra,0x2
    3c32:	140080e7          	jalr	320(ra) # 5d6e <printf>
    exit(1);
    3c36:	4505                	li	a0,1
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	da4080e7          	jalr	-604(ra) # 59dc <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3c40:	85a6                	mv	a1,s1
    3c42:	00004517          	auipc	a0,0x4
    3c46:	afe50513          	addi	a0,a0,-1282 # 7740 <malloc+0x191a>
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	124080e7          	jalr	292(ra) # 5d6e <printf>
    exit(1);
    3c52:	4505                	li	a0,1
    3c54:	00002097          	auipc	ra,0x2
    3c58:	d88080e7          	jalr	-632(ra) # 59dc <exit>
    printf("%s: unlink dots failed!\n", s);
    3c5c:	85a6                	mv	a1,s1
    3c5e:	00004517          	auipc	a0,0x4
    3c62:	b0250513          	addi	a0,a0,-1278 # 7760 <malloc+0x193a>
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	108080e7          	jalr	264(ra) # 5d6e <printf>
    exit(1);
    3c6e:	4505                	li	a0,1
    3c70:	00002097          	auipc	ra,0x2
    3c74:	d6c080e7          	jalr	-660(ra) # 59dc <exit>

0000000000003c78 <dirfile>:
{
    3c78:	1101                	addi	sp,sp,-32
    3c7a:	ec06                	sd	ra,24(sp)
    3c7c:	e822                	sd	s0,16(sp)
    3c7e:	e426                	sd	s1,8(sp)
    3c80:	e04a                	sd	s2,0(sp)
    3c82:	1000                	addi	s0,sp,32
    3c84:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3c86:	20000593          	li	a1,512
    3c8a:	00004517          	auipc	a0,0x4
    3c8e:	af650513          	addi	a0,a0,-1290 # 7780 <malloc+0x195a>
    3c92:	00002097          	auipc	ra,0x2
    3c96:	d8a080e7          	jalr	-630(ra) # 5a1c <open>
  if(fd < 0){
    3c9a:	0e054d63          	bltz	a0,3d94 <dirfile+0x11c>
  close(fd);
    3c9e:	00002097          	auipc	ra,0x2
    3ca2:	d66080e7          	jalr	-666(ra) # 5a04 <close>
  if(chdir("dirfile") == 0){
    3ca6:	00004517          	auipc	a0,0x4
    3caa:	ada50513          	addi	a0,a0,-1318 # 7780 <malloc+0x195a>
    3cae:	00002097          	auipc	ra,0x2
    3cb2:	d9e080e7          	jalr	-610(ra) # 5a4c <chdir>
    3cb6:	cd6d                	beqz	a0,3db0 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3cb8:	4581                	li	a1,0
    3cba:	00004517          	auipc	a0,0x4
    3cbe:	b0e50513          	addi	a0,a0,-1266 # 77c8 <malloc+0x19a2>
    3cc2:	00002097          	auipc	ra,0x2
    3cc6:	d5a080e7          	jalr	-678(ra) # 5a1c <open>
  if(fd >= 0){
    3cca:	10055163          	bgez	a0,3dcc <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3cce:	20000593          	li	a1,512
    3cd2:	00004517          	auipc	a0,0x4
    3cd6:	af650513          	addi	a0,a0,-1290 # 77c8 <malloc+0x19a2>
    3cda:	00002097          	auipc	ra,0x2
    3cde:	d42080e7          	jalr	-702(ra) # 5a1c <open>
  if(fd >= 0){
    3ce2:	10055363          	bgez	a0,3de8 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3ce6:	00004517          	auipc	a0,0x4
    3cea:	ae250513          	addi	a0,a0,-1310 # 77c8 <malloc+0x19a2>
    3cee:	00002097          	auipc	ra,0x2
    3cf2:	d56080e7          	jalr	-682(ra) # 5a44 <mkdir>
    3cf6:	10050763          	beqz	a0,3e04 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3cfa:	00004517          	auipc	a0,0x4
    3cfe:	ace50513          	addi	a0,a0,-1330 # 77c8 <malloc+0x19a2>
    3d02:	00002097          	auipc	ra,0x2
    3d06:	d2a080e7          	jalr	-726(ra) # 5a2c <unlink>
    3d0a:	10050b63          	beqz	a0,3e20 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3d0e:	00004597          	auipc	a1,0x4
    3d12:	aba58593          	addi	a1,a1,-1350 # 77c8 <malloc+0x19a2>
    3d16:	00002517          	auipc	a0,0x2
    3d1a:	40a50513          	addi	a0,a0,1034 # 6120 <malloc+0x2fa>
    3d1e:	00002097          	auipc	ra,0x2
    3d22:	d1e080e7          	jalr	-738(ra) # 5a3c <link>
    3d26:	10050b63          	beqz	a0,3e3c <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3d2a:	00004517          	auipc	a0,0x4
    3d2e:	a5650513          	addi	a0,a0,-1450 # 7780 <malloc+0x195a>
    3d32:	00002097          	auipc	ra,0x2
    3d36:	cfa080e7          	jalr	-774(ra) # 5a2c <unlink>
    3d3a:	10051f63          	bnez	a0,3e58 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3d3e:	4589                	li	a1,2
    3d40:	00003517          	auipc	a0,0x3
    3d44:	80050513          	addi	a0,a0,-2048 # 6540 <malloc+0x71a>
    3d48:	00002097          	auipc	ra,0x2
    3d4c:	cd4080e7          	jalr	-812(ra) # 5a1c <open>
  if(fd >= 0){
    3d50:	12055263          	bgez	a0,3e74 <dirfile+0x1fc>
  fd = open(".", 0);
    3d54:	4581                	li	a1,0
    3d56:	00002517          	auipc	a0,0x2
    3d5a:	7ea50513          	addi	a0,a0,2026 # 6540 <malloc+0x71a>
    3d5e:	00002097          	auipc	ra,0x2
    3d62:	cbe080e7          	jalr	-834(ra) # 5a1c <open>
    3d66:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3d68:	4605                	li	a2,1
    3d6a:	00002597          	auipc	a1,0x2
    3d6e:	24e58593          	addi	a1,a1,590 # 5fb8 <malloc+0x192>
    3d72:	00002097          	auipc	ra,0x2
    3d76:	c8a080e7          	jalr	-886(ra) # 59fc <write>
    3d7a:	10a04b63          	bgtz	a0,3e90 <dirfile+0x218>
  close(fd);
    3d7e:	8526                	mv	a0,s1
    3d80:	00002097          	auipc	ra,0x2
    3d84:	c84080e7          	jalr	-892(ra) # 5a04 <close>
}
    3d88:	60e2                	ld	ra,24(sp)
    3d8a:	6442                	ld	s0,16(sp)
    3d8c:	64a2                	ld	s1,8(sp)
    3d8e:	6902                	ld	s2,0(sp)
    3d90:	6105                	addi	sp,sp,32
    3d92:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3d94:	85ca                	mv	a1,s2
    3d96:	00004517          	auipc	a0,0x4
    3d9a:	9f250513          	addi	a0,a0,-1550 # 7788 <malloc+0x1962>
    3d9e:	00002097          	auipc	ra,0x2
    3da2:	fd0080e7          	jalr	-48(ra) # 5d6e <printf>
    exit(1);
    3da6:	4505                	li	a0,1
    3da8:	00002097          	auipc	ra,0x2
    3dac:	c34080e7          	jalr	-972(ra) # 59dc <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3db0:	85ca                	mv	a1,s2
    3db2:	00004517          	auipc	a0,0x4
    3db6:	9f650513          	addi	a0,a0,-1546 # 77a8 <malloc+0x1982>
    3dba:	00002097          	auipc	ra,0x2
    3dbe:	fb4080e7          	jalr	-76(ra) # 5d6e <printf>
    exit(1);
    3dc2:	4505                	li	a0,1
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	c18080e7          	jalr	-1000(ra) # 59dc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3dcc:	85ca                	mv	a1,s2
    3dce:	00004517          	auipc	a0,0x4
    3dd2:	a0a50513          	addi	a0,a0,-1526 # 77d8 <malloc+0x19b2>
    3dd6:	00002097          	auipc	ra,0x2
    3dda:	f98080e7          	jalr	-104(ra) # 5d6e <printf>
    exit(1);
    3dde:	4505                	li	a0,1
    3de0:	00002097          	auipc	ra,0x2
    3de4:	bfc080e7          	jalr	-1028(ra) # 59dc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3de8:	85ca                	mv	a1,s2
    3dea:	00004517          	auipc	a0,0x4
    3dee:	9ee50513          	addi	a0,a0,-1554 # 77d8 <malloc+0x19b2>
    3df2:	00002097          	auipc	ra,0x2
    3df6:	f7c080e7          	jalr	-132(ra) # 5d6e <printf>
    exit(1);
    3dfa:	4505                	li	a0,1
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	be0080e7          	jalr	-1056(ra) # 59dc <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3e04:	85ca                	mv	a1,s2
    3e06:	00004517          	auipc	a0,0x4
    3e0a:	9fa50513          	addi	a0,a0,-1542 # 7800 <malloc+0x19da>
    3e0e:	00002097          	auipc	ra,0x2
    3e12:	f60080e7          	jalr	-160(ra) # 5d6e <printf>
    exit(1);
    3e16:	4505                	li	a0,1
    3e18:	00002097          	auipc	ra,0x2
    3e1c:	bc4080e7          	jalr	-1084(ra) # 59dc <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3e20:	85ca                	mv	a1,s2
    3e22:	00004517          	auipc	a0,0x4
    3e26:	a0650513          	addi	a0,a0,-1530 # 7828 <malloc+0x1a02>
    3e2a:	00002097          	auipc	ra,0x2
    3e2e:	f44080e7          	jalr	-188(ra) # 5d6e <printf>
    exit(1);
    3e32:	4505                	li	a0,1
    3e34:	00002097          	auipc	ra,0x2
    3e38:	ba8080e7          	jalr	-1112(ra) # 59dc <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3e3c:	85ca                	mv	a1,s2
    3e3e:	00004517          	auipc	a0,0x4
    3e42:	a1250513          	addi	a0,a0,-1518 # 7850 <malloc+0x1a2a>
    3e46:	00002097          	auipc	ra,0x2
    3e4a:	f28080e7          	jalr	-216(ra) # 5d6e <printf>
    exit(1);
    3e4e:	4505                	li	a0,1
    3e50:	00002097          	auipc	ra,0x2
    3e54:	b8c080e7          	jalr	-1140(ra) # 59dc <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3e58:	85ca                	mv	a1,s2
    3e5a:	00004517          	auipc	a0,0x4
    3e5e:	a1e50513          	addi	a0,a0,-1506 # 7878 <malloc+0x1a52>
    3e62:	00002097          	auipc	ra,0x2
    3e66:	f0c080e7          	jalr	-244(ra) # 5d6e <printf>
    exit(1);
    3e6a:	4505                	li	a0,1
    3e6c:	00002097          	auipc	ra,0x2
    3e70:	b70080e7          	jalr	-1168(ra) # 59dc <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3e74:	85ca                	mv	a1,s2
    3e76:	00004517          	auipc	a0,0x4
    3e7a:	a2250513          	addi	a0,a0,-1502 # 7898 <malloc+0x1a72>
    3e7e:	00002097          	auipc	ra,0x2
    3e82:	ef0080e7          	jalr	-272(ra) # 5d6e <printf>
    exit(1);
    3e86:	4505                	li	a0,1
    3e88:	00002097          	auipc	ra,0x2
    3e8c:	b54080e7          	jalr	-1196(ra) # 59dc <exit>
    printf("%s: write . succeeded!\n", s);
    3e90:	85ca                	mv	a1,s2
    3e92:	00004517          	auipc	a0,0x4
    3e96:	a2e50513          	addi	a0,a0,-1490 # 78c0 <malloc+0x1a9a>
    3e9a:	00002097          	auipc	ra,0x2
    3e9e:	ed4080e7          	jalr	-300(ra) # 5d6e <printf>
    exit(1);
    3ea2:	4505                	li	a0,1
    3ea4:	00002097          	auipc	ra,0x2
    3ea8:	b38080e7          	jalr	-1224(ra) # 59dc <exit>

0000000000003eac <iref>:
{
    3eac:	7139                	addi	sp,sp,-64
    3eae:	fc06                	sd	ra,56(sp)
    3eb0:	f822                	sd	s0,48(sp)
    3eb2:	f426                	sd	s1,40(sp)
    3eb4:	f04a                	sd	s2,32(sp)
    3eb6:	ec4e                	sd	s3,24(sp)
    3eb8:	e852                	sd	s4,16(sp)
    3eba:	e456                	sd	s5,8(sp)
    3ebc:	e05a                	sd	s6,0(sp)
    3ebe:	0080                	addi	s0,sp,64
    3ec0:	8b2a                	mv	s6,a0
    3ec2:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3ec6:	00004a17          	auipc	s4,0x4
    3eca:	a12a0a13          	addi	s4,s4,-1518 # 78d8 <malloc+0x1ab2>
    mkdir("");
    3ece:	00003497          	auipc	s1,0x3
    3ed2:	51248493          	addi	s1,s1,1298 # 73e0 <malloc+0x15ba>
    link("README", "");
    3ed6:	00002a97          	auipc	s5,0x2
    3eda:	24aa8a93          	addi	s5,s5,586 # 6120 <malloc+0x2fa>
    fd = open("xx", O_CREATE);
    3ede:	00004997          	auipc	s3,0x4
    3ee2:	8f298993          	addi	s3,s3,-1806 # 77d0 <malloc+0x19aa>
    3ee6:	a891                	j	3f3a <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3ee8:	85da                	mv	a1,s6
    3eea:	00004517          	auipc	a0,0x4
    3eee:	9f650513          	addi	a0,a0,-1546 # 78e0 <malloc+0x1aba>
    3ef2:	00002097          	auipc	ra,0x2
    3ef6:	e7c080e7          	jalr	-388(ra) # 5d6e <printf>
      exit(1);
    3efa:	4505                	li	a0,1
    3efc:	00002097          	auipc	ra,0x2
    3f00:	ae0080e7          	jalr	-1312(ra) # 59dc <exit>
      printf("%s: chdir irefd failed\n", s);
    3f04:	85da                	mv	a1,s6
    3f06:	00004517          	auipc	a0,0x4
    3f0a:	9f250513          	addi	a0,a0,-1550 # 78f8 <malloc+0x1ad2>
    3f0e:	00002097          	auipc	ra,0x2
    3f12:	e60080e7          	jalr	-416(ra) # 5d6e <printf>
      exit(1);
    3f16:	4505                	li	a0,1
    3f18:	00002097          	auipc	ra,0x2
    3f1c:	ac4080e7          	jalr	-1340(ra) # 59dc <exit>
      close(fd);
    3f20:	00002097          	auipc	ra,0x2
    3f24:	ae4080e7          	jalr	-1308(ra) # 5a04 <close>
    3f28:	a889                	j	3f7a <iref+0xce>
    unlink("xx");
    3f2a:	854e                	mv	a0,s3
    3f2c:	00002097          	auipc	ra,0x2
    3f30:	b00080e7          	jalr	-1280(ra) # 5a2c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3f34:	397d                	addiw	s2,s2,-1
    3f36:	06090063          	beqz	s2,3f96 <iref+0xea>
    if(mkdir("irefd") != 0){
    3f3a:	8552                	mv	a0,s4
    3f3c:	00002097          	auipc	ra,0x2
    3f40:	b08080e7          	jalr	-1272(ra) # 5a44 <mkdir>
    3f44:	f155                	bnez	a0,3ee8 <iref+0x3c>
    if(chdir("irefd") != 0){
    3f46:	8552                	mv	a0,s4
    3f48:	00002097          	auipc	ra,0x2
    3f4c:	b04080e7          	jalr	-1276(ra) # 5a4c <chdir>
    3f50:	f955                	bnez	a0,3f04 <iref+0x58>
    mkdir("");
    3f52:	8526                	mv	a0,s1
    3f54:	00002097          	auipc	ra,0x2
    3f58:	af0080e7          	jalr	-1296(ra) # 5a44 <mkdir>
    link("README", "");
    3f5c:	85a6                	mv	a1,s1
    3f5e:	8556                	mv	a0,s5
    3f60:	00002097          	auipc	ra,0x2
    3f64:	adc080e7          	jalr	-1316(ra) # 5a3c <link>
    fd = open("", O_CREATE);
    3f68:	20000593          	li	a1,512
    3f6c:	8526                	mv	a0,s1
    3f6e:	00002097          	auipc	ra,0x2
    3f72:	aae080e7          	jalr	-1362(ra) # 5a1c <open>
    if(fd >= 0)
    3f76:	fa0555e3          	bgez	a0,3f20 <iref+0x74>
    fd = open("xx", O_CREATE);
    3f7a:	20000593          	li	a1,512
    3f7e:	854e                	mv	a0,s3
    3f80:	00002097          	auipc	ra,0x2
    3f84:	a9c080e7          	jalr	-1380(ra) # 5a1c <open>
    if(fd >= 0)
    3f88:	fa0541e3          	bltz	a0,3f2a <iref+0x7e>
      close(fd);
    3f8c:	00002097          	auipc	ra,0x2
    3f90:	a78080e7          	jalr	-1416(ra) # 5a04 <close>
    3f94:	bf59                	j	3f2a <iref+0x7e>
    3f96:	03300493          	li	s1,51
    chdir("..");
    3f9a:	00003997          	auipc	s3,0x3
    3f9e:	16698993          	addi	s3,s3,358 # 7100 <malloc+0x12da>
    unlink("irefd");
    3fa2:	00004917          	auipc	s2,0x4
    3fa6:	93690913          	addi	s2,s2,-1738 # 78d8 <malloc+0x1ab2>
    chdir("..");
    3faa:	854e                	mv	a0,s3
    3fac:	00002097          	auipc	ra,0x2
    3fb0:	aa0080e7          	jalr	-1376(ra) # 5a4c <chdir>
    unlink("irefd");
    3fb4:	854a                	mv	a0,s2
    3fb6:	00002097          	auipc	ra,0x2
    3fba:	a76080e7          	jalr	-1418(ra) # 5a2c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3fbe:	34fd                	addiw	s1,s1,-1
    3fc0:	f4ed                	bnez	s1,3faa <iref+0xfe>
  chdir("/");
    3fc2:	00003517          	auipc	a0,0x3
    3fc6:	0e650513          	addi	a0,a0,230 # 70a8 <malloc+0x1282>
    3fca:	00002097          	auipc	ra,0x2
    3fce:	a82080e7          	jalr	-1406(ra) # 5a4c <chdir>
}
    3fd2:	70e2                	ld	ra,56(sp)
    3fd4:	7442                	ld	s0,48(sp)
    3fd6:	74a2                	ld	s1,40(sp)
    3fd8:	7902                	ld	s2,32(sp)
    3fda:	69e2                	ld	s3,24(sp)
    3fdc:	6a42                	ld	s4,16(sp)
    3fde:	6aa2                	ld	s5,8(sp)
    3fe0:	6b02                	ld	s6,0(sp)
    3fe2:	6121                	addi	sp,sp,64
    3fe4:	8082                	ret

0000000000003fe6 <openiputtest>:
{
    3fe6:	7179                	addi	sp,sp,-48
    3fe8:	f406                	sd	ra,40(sp)
    3fea:	f022                	sd	s0,32(sp)
    3fec:	ec26                	sd	s1,24(sp)
    3fee:	1800                	addi	s0,sp,48
    3ff0:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3ff2:	00004517          	auipc	a0,0x4
    3ff6:	91e50513          	addi	a0,a0,-1762 # 7910 <malloc+0x1aea>
    3ffa:	00002097          	auipc	ra,0x2
    3ffe:	a4a080e7          	jalr	-1462(ra) # 5a44 <mkdir>
    4002:	04054263          	bltz	a0,4046 <openiputtest+0x60>
  pid = fork();
    4006:	00002097          	auipc	ra,0x2
    400a:	9ce080e7          	jalr	-1586(ra) # 59d4 <fork>
  if(pid < 0){
    400e:	04054a63          	bltz	a0,4062 <openiputtest+0x7c>
  if(pid == 0){
    4012:	e93d                	bnez	a0,4088 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4014:	4589                	li	a1,2
    4016:	00004517          	auipc	a0,0x4
    401a:	8fa50513          	addi	a0,a0,-1798 # 7910 <malloc+0x1aea>
    401e:	00002097          	auipc	ra,0x2
    4022:	9fe080e7          	jalr	-1538(ra) # 5a1c <open>
    if(fd >= 0){
    4026:	04054c63          	bltz	a0,407e <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    402a:	85a6                	mv	a1,s1
    402c:	00004517          	auipc	a0,0x4
    4030:	90450513          	addi	a0,a0,-1788 # 7930 <malloc+0x1b0a>
    4034:	00002097          	auipc	ra,0x2
    4038:	d3a080e7          	jalr	-710(ra) # 5d6e <printf>
      exit(1);
    403c:	4505                	li	a0,1
    403e:	00002097          	auipc	ra,0x2
    4042:	99e080e7          	jalr	-1634(ra) # 59dc <exit>
    printf("%s: mkdir oidir failed\n", s);
    4046:	85a6                	mv	a1,s1
    4048:	00004517          	auipc	a0,0x4
    404c:	8d050513          	addi	a0,a0,-1840 # 7918 <malloc+0x1af2>
    4050:	00002097          	auipc	ra,0x2
    4054:	d1e080e7          	jalr	-738(ra) # 5d6e <printf>
    exit(1);
    4058:	4505                	li	a0,1
    405a:	00002097          	auipc	ra,0x2
    405e:	982080e7          	jalr	-1662(ra) # 59dc <exit>
    printf("%s: fork failed\n", s);
    4062:	85a6                	mv	a1,s1
    4064:	00002517          	auipc	a0,0x2
    4068:	61450513          	addi	a0,a0,1556 # 6678 <malloc+0x852>
    406c:	00002097          	auipc	ra,0x2
    4070:	d02080e7          	jalr	-766(ra) # 5d6e <printf>
    exit(1);
    4074:	4505                	li	a0,1
    4076:	00002097          	auipc	ra,0x2
    407a:	966080e7          	jalr	-1690(ra) # 59dc <exit>
    exit(0);
    407e:	4501                	li	a0,0
    4080:	00002097          	auipc	ra,0x2
    4084:	95c080e7          	jalr	-1700(ra) # 59dc <exit>
  sleep(1);
    4088:	4505                	li	a0,1
    408a:	00002097          	auipc	ra,0x2
    408e:	9e2080e7          	jalr	-1566(ra) # 5a6c <sleep>
  if(unlink("oidir") != 0){
    4092:	00004517          	auipc	a0,0x4
    4096:	87e50513          	addi	a0,a0,-1922 # 7910 <malloc+0x1aea>
    409a:	00002097          	auipc	ra,0x2
    409e:	992080e7          	jalr	-1646(ra) # 5a2c <unlink>
    40a2:	cd19                	beqz	a0,40c0 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    40a4:	85a6                	mv	a1,s1
    40a6:	00002517          	auipc	a0,0x2
    40aa:	7c250513          	addi	a0,a0,1986 # 6868 <malloc+0xa42>
    40ae:	00002097          	auipc	ra,0x2
    40b2:	cc0080e7          	jalr	-832(ra) # 5d6e <printf>
    exit(1);
    40b6:	4505                	li	a0,1
    40b8:	00002097          	auipc	ra,0x2
    40bc:	924080e7          	jalr	-1756(ra) # 59dc <exit>
  wait(&xstatus);
    40c0:	fdc40513          	addi	a0,s0,-36
    40c4:	00002097          	auipc	ra,0x2
    40c8:	920080e7          	jalr	-1760(ra) # 59e4 <wait>
  exit(xstatus);
    40cc:	fdc42503          	lw	a0,-36(s0)
    40d0:	00002097          	auipc	ra,0x2
    40d4:	90c080e7          	jalr	-1780(ra) # 59dc <exit>

00000000000040d8 <forkforkfork>:
{
    40d8:	1101                	addi	sp,sp,-32
    40da:	ec06                	sd	ra,24(sp)
    40dc:	e822                	sd	s0,16(sp)
    40de:	e426                	sd	s1,8(sp)
    40e0:	1000                	addi	s0,sp,32
    40e2:	84aa                	mv	s1,a0
  unlink("stopforking");
    40e4:	00004517          	auipc	a0,0x4
    40e8:	87450513          	addi	a0,a0,-1932 # 7958 <malloc+0x1b32>
    40ec:	00002097          	auipc	ra,0x2
    40f0:	940080e7          	jalr	-1728(ra) # 5a2c <unlink>
  int pid = fork();
    40f4:	00002097          	auipc	ra,0x2
    40f8:	8e0080e7          	jalr	-1824(ra) # 59d4 <fork>
  if(pid < 0){
    40fc:	04054563          	bltz	a0,4146 <forkforkfork+0x6e>
  if(pid == 0){
    4100:	c12d                	beqz	a0,4162 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4102:	4551                	li	a0,20
    4104:	00002097          	auipc	ra,0x2
    4108:	968080e7          	jalr	-1688(ra) # 5a6c <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    410c:	20200593          	li	a1,514
    4110:	00004517          	auipc	a0,0x4
    4114:	84850513          	addi	a0,a0,-1976 # 7958 <malloc+0x1b32>
    4118:	00002097          	auipc	ra,0x2
    411c:	904080e7          	jalr	-1788(ra) # 5a1c <open>
    4120:	00002097          	auipc	ra,0x2
    4124:	8e4080e7          	jalr	-1820(ra) # 5a04 <close>
  wait(0);
    4128:	4501                	li	a0,0
    412a:	00002097          	auipc	ra,0x2
    412e:	8ba080e7          	jalr	-1862(ra) # 59e4 <wait>
  sleep(10); // one second
    4132:	4529                	li	a0,10
    4134:	00002097          	auipc	ra,0x2
    4138:	938080e7          	jalr	-1736(ra) # 5a6c <sleep>
}
    413c:	60e2                	ld	ra,24(sp)
    413e:	6442                	ld	s0,16(sp)
    4140:	64a2                	ld	s1,8(sp)
    4142:	6105                	addi	sp,sp,32
    4144:	8082                	ret
    printf("%s: fork failed", s);
    4146:	85a6                	mv	a1,s1
    4148:	00002517          	auipc	a0,0x2
    414c:	6f050513          	addi	a0,a0,1776 # 6838 <malloc+0xa12>
    4150:	00002097          	auipc	ra,0x2
    4154:	c1e080e7          	jalr	-994(ra) # 5d6e <printf>
    exit(1);
    4158:	4505                	li	a0,1
    415a:	00002097          	auipc	ra,0x2
    415e:	882080e7          	jalr	-1918(ra) # 59dc <exit>
      int fd = open("stopforking", 0);
    4162:	00003497          	auipc	s1,0x3
    4166:	7f648493          	addi	s1,s1,2038 # 7958 <malloc+0x1b32>
    416a:	4581                	li	a1,0
    416c:	8526                	mv	a0,s1
    416e:	00002097          	auipc	ra,0x2
    4172:	8ae080e7          	jalr	-1874(ra) # 5a1c <open>
      if(fd >= 0){
    4176:	02055463          	bgez	a0,419e <forkforkfork+0xc6>
      if(fork() < 0){
    417a:	00002097          	auipc	ra,0x2
    417e:	85a080e7          	jalr	-1958(ra) # 59d4 <fork>
    4182:	fe0554e3          	bgez	a0,416a <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4186:	20200593          	li	a1,514
    418a:	8526                	mv	a0,s1
    418c:	00002097          	auipc	ra,0x2
    4190:	890080e7          	jalr	-1904(ra) # 5a1c <open>
    4194:	00002097          	auipc	ra,0x2
    4198:	870080e7          	jalr	-1936(ra) # 5a04 <close>
    419c:	b7f9                	j	416a <forkforkfork+0x92>
        exit(0);
    419e:	4501                	li	a0,0
    41a0:	00002097          	auipc	ra,0x2
    41a4:	83c080e7          	jalr	-1988(ra) # 59dc <exit>

00000000000041a8 <killstatus>:
{
    41a8:	7139                	addi	sp,sp,-64
    41aa:	fc06                	sd	ra,56(sp)
    41ac:	f822                	sd	s0,48(sp)
    41ae:	f426                	sd	s1,40(sp)
    41b0:	f04a                	sd	s2,32(sp)
    41b2:	ec4e                	sd	s3,24(sp)
    41b4:	e852                	sd	s4,16(sp)
    41b6:	0080                	addi	s0,sp,64
    41b8:	8a2a                	mv	s4,a0
    41ba:	06400913          	li	s2,100
    if(xst != -1) {
    41be:	59fd                	li	s3,-1
    int pid1 = fork();
    41c0:	00002097          	auipc	ra,0x2
    41c4:	814080e7          	jalr	-2028(ra) # 59d4 <fork>
    41c8:	84aa                	mv	s1,a0
    if(pid1 < 0){
    41ca:	02054f63          	bltz	a0,4208 <killstatus+0x60>
    if(pid1 == 0){
    41ce:	c939                	beqz	a0,4224 <killstatus+0x7c>
    sleep(1);
    41d0:	4505                	li	a0,1
    41d2:	00002097          	auipc	ra,0x2
    41d6:	89a080e7          	jalr	-1894(ra) # 5a6c <sleep>
    kill(pid1);
    41da:	8526                	mv	a0,s1
    41dc:	00002097          	auipc	ra,0x2
    41e0:	830080e7          	jalr	-2000(ra) # 5a0c <kill>
    wait(&xst);
    41e4:	fcc40513          	addi	a0,s0,-52
    41e8:	00001097          	auipc	ra,0x1
    41ec:	7fc080e7          	jalr	2044(ra) # 59e4 <wait>
    if(xst != -1) {
    41f0:	fcc42783          	lw	a5,-52(s0)
    41f4:	03379d63          	bne	a5,s3,422e <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    41f8:	397d                	addiw	s2,s2,-1
    41fa:	fc0913e3          	bnez	s2,41c0 <killstatus+0x18>
  exit(0);
    41fe:	4501                	li	a0,0
    4200:	00001097          	auipc	ra,0x1
    4204:	7dc080e7          	jalr	2012(ra) # 59dc <exit>
      printf("%s: fork failed\n", s);
    4208:	85d2                	mv	a1,s4
    420a:	00002517          	auipc	a0,0x2
    420e:	46e50513          	addi	a0,a0,1134 # 6678 <malloc+0x852>
    4212:	00002097          	auipc	ra,0x2
    4216:	b5c080e7          	jalr	-1188(ra) # 5d6e <printf>
      exit(1);
    421a:	4505                	li	a0,1
    421c:	00001097          	auipc	ra,0x1
    4220:	7c0080e7          	jalr	1984(ra) # 59dc <exit>
        getpid();
    4224:	00002097          	auipc	ra,0x2
    4228:	838080e7          	jalr	-1992(ra) # 5a5c <getpid>
      while(1) {
    422c:	bfe5                	j	4224 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    422e:	85d2                	mv	a1,s4
    4230:	00003517          	auipc	a0,0x3
    4234:	73850513          	addi	a0,a0,1848 # 7968 <malloc+0x1b42>
    4238:	00002097          	auipc	ra,0x2
    423c:	b36080e7          	jalr	-1226(ra) # 5d6e <printf>
       exit(1);
    4240:	4505                	li	a0,1
    4242:	00001097          	auipc	ra,0x1
    4246:	79a080e7          	jalr	1946(ra) # 59dc <exit>

000000000000424a <preempt>:
{
    424a:	7139                	addi	sp,sp,-64
    424c:	fc06                	sd	ra,56(sp)
    424e:	f822                	sd	s0,48(sp)
    4250:	f426                	sd	s1,40(sp)
    4252:	f04a                	sd	s2,32(sp)
    4254:	ec4e                	sd	s3,24(sp)
    4256:	e852                	sd	s4,16(sp)
    4258:	0080                	addi	s0,sp,64
    425a:	892a                	mv	s2,a0
  pid1 = fork();
    425c:	00001097          	auipc	ra,0x1
    4260:	778080e7          	jalr	1912(ra) # 59d4 <fork>
  if(pid1 < 0) {
    4264:	00054563          	bltz	a0,426e <preempt+0x24>
    4268:	84aa                	mv	s1,a0
  if(pid1 == 0)
    426a:	e105                	bnez	a0,428a <preempt+0x40>
    for(;;)
    426c:	a001                	j	426c <preempt+0x22>
    printf("%s: fork failed", s);
    426e:	85ca                	mv	a1,s2
    4270:	00002517          	auipc	a0,0x2
    4274:	5c850513          	addi	a0,a0,1480 # 6838 <malloc+0xa12>
    4278:	00002097          	auipc	ra,0x2
    427c:	af6080e7          	jalr	-1290(ra) # 5d6e <printf>
    exit(1);
    4280:	4505                	li	a0,1
    4282:	00001097          	auipc	ra,0x1
    4286:	75a080e7          	jalr	1882(ra) # 59dc <exit>
  pid2 = fork();
    428a:	00001097          	auipc	ra,0x1
    428e:	74a080e7          	jalr	1866(ra) # 59d4 <fork>
    4292:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4294:	00054463          	bltz	a0,429c <preempt+0x52>
  if(pid2 == 0)
    4298:	e105                	bnez	a0,42b8 <preempt+0x6e>
    for(;;)
    429a:	a001                	j	429a <preempt+0x50>
    printf("%s: fork failed\n", s);
    429c:	85ca                	mv	a1,s2
    429e:	00002517          	auipc	a0,0x2
    42a2:	3da50513          	addi	a0,a0,986 # 6678 <malloc+0x852>
    42a6:	00002097          	auipc	ra,0x2
    42aa:	ac8080e7          	jalr	-1336(ra) # 5d6e <printf>
    exit(1);
    42ae:	4505                	li	a0,1
    42b0:	00001097          	auipc	ra,0x1
    42b4:	72c080e7          	jalr	1836(ra) # 59dc <exit>
  pipe(pfds);
    42b8:	fc840513          	addi	a0,s0,-56
    42bc:	00001097          	auipc	ra,0x1
    42c0:	730080e7          	jalr	1840(ra) # 59ec <pipe>
  pid3 = fork();
    42c4:	00001097          	auipc	ra,0x1
    42c8:	710080e7          	jalr	1808(ra) # 59d4 <fork>
    42cc:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    42ce:	02054e63          	bltz	a0,430a <preempt+0xc0>
  if(pid3 == 0){
    42d2:	e525                	bnez	a0,433a <preempt+0xf0>
    close(pfds[0]);
    42d4:	fc842503          	lw	a0,-56(s0)
    42d8:	00001097          	auipc	ra,0x1
    42dc:	72c080e7          	jalr	1836(ra) # 5a04 <close>
    if(write(pfds[1], "x", 1) != 1)
    42e0:	4605                	li	a2,1
    42e2:	00002597          	auipc	a1,0x2
    42e6:	cd658593          	addi	a1,a1,-810 # 5fb8 <malloc+0x192>
    42ea:	fcc42503          	lw	a0,-52(s0)
    42ee:	00001097          	auipc	ra,0x1
    42f2:	70e080e7          	jalr	1806(ra) # 59fc <write>
    42f6:	4785                	li	a5,1
    42f8:	02f51763          	bne	a0,a5,4326 <preempt+0xdc>
    close(pfds[1]);
    42fc:	fcc42503          	lw	a0,-52(s0)
    4300:	00001097          	auipc	ra,0x1
    4304:	704080e7          	jalr	1796(ra) # 5a04 <close>
    for(;;)
    4308:	a001                	j	4308 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    430a:	85ca                	mv	a1,s2
    430c:	00002517          	auipc	a0,0x2
    4310:	36c50513          	addi	a0,a0,876 # 6678 <malloc+0x852>
    4314:	00002097          	auipc	ra,0x2
    4318:	a5a080e7          	jalr	-1446(ra) # 5d6e <printf>
     exit(1);
    431c:	4505                	li	a0,1
    431e:	00001097          	auipc	ra,0x1
    4322:	6be080e7          	jalr	1726(ra) # 59dc <exit>
      printf("%s: preempt write error", s);
    4326:	85ca                	mv	a1,s2
    4328:	00003517          	auipc	a0,0x3
    432c:	66050513          	addi	a0,a0,1632 # 7988 <malloc+0x1b62>
    4330:	00002097          	auipc	ra,0x2
    4334:	a3e080e7          	jalr	-1474(ra) # 5d6e <printf>
    4338:	b7d1                	j	42fc <preempt+0xb2>
  close(pfds[1]);
    433a:	fcc42503          	lw	a0,-52(s0)
    433e:	00001097          	auipc	ra,0x1
    4342:	6c6080e7          	jalr	1734(ra) # 5a04 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4346:	660d                	lui	a2,0x3
    4348:	00009597          	auipc	a1,0x9
    434c:	92058593          	addi	a1,a1,-1760 # cc68 <buf>
    4350:	fc842503          	lw	a0,-56(s0)
    4354:	00001097          	auipc	ra,0x1
    4358:	6a0080e7          	jalr	1696(ra) # 59f4 <read>
    435c:	4785                	li	a5,1
    435e:	02f50363          	beq	a0,a5,4384 <preempt+0x13a>
    printf("%s: preempt read error", s);
    4362:	85ca                	mv	a1,s2
    4364:	00003517          	auipc	a0,0x3
    4368:	63c50513          	addi	a0,a0,1596 # 79a0 <malloc+0x1b7a>
    436c:	00002097          	auipc	ra,0x2
    4370:	a02080e7          	jalr	-1534(ra) # 5d6e <printf>
}
    4374:	70e2                	ld	ra,56(sp)
    4376:	7442                	ld	s0,48(sp)
    4378:	74a2                	ld	s1,40(sp)
    437a:	7902                	ld	s2,32(sp)
    437c:	69e2                	ld	s3,24(sp)
    437e:	6a42                	ld	s4,16(sp)
    4380:	6121                	addi	sp,sp,64
    4382:	8082                	ret
  close(pfds[0]);
    4384:	fc842503          	lw	a0,-56(s0)
    4388:	00001097          	auipc	ra,0x1
    438c:	67c080e7          	jalr	1660(ra) # 5a04 <close>
  printf("kill... ");
    4390:	00003517          	auipc	a0,0x3
    4394:	62850513          	addi	a0,a0,1576 # 79b8 <malloc+0x1b92>
    4398:	00002097          	auipc	ra,0x2
    439c:	9d6080e7          	jalr	-1578(ra) # 5d6e <printf>
  kill(pid1);
    43a0:	8526                	mv	a0,s1
    43a2:	00001097          	auipc	ra,0x1
    43a6:	66a080e7          	jalr	1642(ra) # 5a0c <kill>
  kill(pid2);
    43aa:	854e                	mv	a0,s3
    43ac:	00001097          	auipc	ra,0x1
    43b0:	660080e7          	jalr	1632(ra) # 5a0c <kill>
  kill(pid3);
    43b4:	8552                	mv	a0,s4
    43b6:	00001097          	auipc	ra,0x1
    43ba:	656080e7          	jalr	1622(ra) # 5a0c <kill>
  printf("wait... ");
    43be:	00003517          	auipc	a0,0x3
    43c2:	60a50513          	addi	a0,a0,1546 # 79c8 <malloc+0x1ba2>
    43c6:	00002097          	auipc	ra,0x2
    43ca:	9a8080e7          	jalr	-1624(ra) # 5d6e <printf>
  wait(0);
    43ce:	4501                	li	a0,0
    43d0:	00001097          	auipc	ra,0x1
    43d4:	614080e7          	jalr	1556(ra) # 59e4 <wait>
  wait(0);
    43d8:	4501                	li	a0,0
    43da:	00001097          	auipc	ra,0x1
    43de:	60a080e7          	jalr	1546(ra) # 59e4 <wait>
  wait(0);
    43e2:	4501                	li	a0,0
    43e4:	00001097          	auipc	ra,0x1
    43e8:	600080e7          	jalr	1536(ra) # 59e4 <wait>
    43ec:	b761                	j	4374 <preempt+0x12a>

00000000000043ee <reparent>:
{
    43ee:	7179                	addi	sp,sp,-48
    43f0:	f406                	sd	ra,40(sp)
    43f2:	f022                	sd	s0,32(sp)
    43f4:	ec26                	sd	s1,24(sp)
    43f6:	e84a                	sd	s2,16(sp)
    43f8:	e44e                	sd	s3,8(sp)
    43fa:	e052                	sd	s4,0(sp)
    43fc:	1800                	addi	s0,sp,48
    43fe:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4400:	00001097          	auipc	ra,0x1
    4404:	65c080e7          	jalr	1628(ra) # 5a5c <getpid>
    4408:	8a2a                	mv	s4,a0
    440a:	0c800913          	li	s2,200
    int pid = fork();
    440e:	00001097          	auipc	ra,0x1
    4412:	5c6080e7          	jalr	1478(ra) # 59d4 <fork>
    4416:	84aa                	mv	s1,a0
    if(pid < 0){
    4418:	02054263          	bltz	a0,443c <reparent+0x4e>
    if(pid){
    441c:	cd21                	beqz	a0,4474 <reparent+0x86>
      if(wait(0) != pid){
    441e:	4501                	li	a0,0
    4420:	00001097          	auipc	ra,0x1
    4424:	5c4080e7          	jalr	1476(ra) # 59e4 <wait>
    4428:	02951863          	bne	a0,s1,4458 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    442c:	397d                	addiw	s2,s2,-1
    442e:	fe0910e3          	bnez	s2,440e <reparent+0x20>
  exit(0);
    4432:	4501                	li	a0,0
    4434:	00001097          	auipc	ra,0x1
    4438:	5a8080e7          	jalr	1448(ra) # 59dc <exit>
      printf("%s: fork failed\n", s);
    443c:	85ce                	mv	a1,s3
    443e:	00002517          	auipc	a0,0x2
    4442:	23a50513          	addi	a0,a0,570 # 6678 <malloc+0x852>
    4446:	00002097          	auipc	ra,0x2
    444a:	928080e7          	jalr	-1752(ra) # 5d6e <printf>
      exit(1);
    444e:	4505                	li	a0,1
    4450:	00001097          	auipc	ra,0x1
    4454:	58c080e7          	jalr	1420(ra) # 59dc <exit>
        printf("%s: wait wrong pid\n", s);
    4458:	85ce                	mv	a1,s3
    445a:	00002517          	auipc	a0,0x2
    445e:	3a650513          	addi	a0,a0,934 # 6800 <malloc+0x9da>
    4462:	00002097          	auipc	ra,0x2
    4466:	90c080e7          	jalr	-1780(ra) # 5d6e <printf>
        exit(1);
    446a:	4505                	li	a0,1
    446c:	00001097          	auipc	ra,0x1
    4470:	570080e7          	jalr	1392(ra) # 59dc <exit>
      int pid2 = fork();
    4474:	00001097          	auipc	ra,0x1
    4478:	560080e7          	jalr	1376(ra) # 59d4 <fork>
      if(pid2 < 0){
    447c:	00054763          	bltz	a0,448a <reparent+0x9c>
      exit(0);
    4480:	4501                	li	a0,0
    4482:	00001097          	auipc	ra,0x1
    4486:	55a080e7          	jalr	1370(ra) # 59dc <exit>
        kill(master_pid);
    448a:	8552                	mv	a0,s4
    448c:	00001097          	auipc	ra,0x1
    4490:	580080e7          	jalr	1408(ra) # 5a0c <kill>
        exit(1);
    4494:	4505                	li	a0,1
    4496:	00001097          	auipc	ra,0x1
    449a:	546080e7          	jalr	1350(ra) # 59dc <exit>

000000000000449e <sbrkfail>:
{
    449e:	7119                	addi	sp,sp,-128
    44a0:	fc86                	sd	ra,120(sp)
    44a2:	f8a2                	sd	s0,112(sp)
    44a4:	f4a6                	sd	s1,104(sp)
    44a6:	f0ca                	sd	s2,96(sp)
    44a8:	ecce                	sd	s3,88(sp)
    44aa:	e8d2                	sd	s4,80(sp)
    44ac:	e4d6                	sd	s5,72(sp)
    44ae:	0100                	addi	s0,sp,128
    44b0:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    44b2:	fb040513          	addi	a0,s0,-80
    44b6:	00001097          	auipc	ra,0x1
    44ba:	536080e7          	jalr	1334(ra) # 59ec <pipe>
    44be:	e901                	bnez	a0,44ce <sbrkfail+0x30>
    44c0:	f8040493          	addi	s1,s0,-128
    44c4:	fa840993          	addi	s3,s0,-88
    44c8:	8926                	mv	s2,s1
    if(pids[i] != -1)
    44ca:	5a7d                	li	s4,-1
    44cc:	a085                	j	452c <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    44ce:	85d6                	mv	a1,s5
    44d0:	00002517          	auipc	a0,0x2
    44d4:	2b050513          	addi	a0,a0,688 # 6780 <malloc+0x95a>
    44d8:	00002097          	auipc	ra,0x2
    44dc:	896080e7          	jalr	-1898(ra) # 5d6e <printf>
    exit(1);
    44e0:	4505                	li	a0,1
    44e2:	00001097          	auipc	ra,0x1
    44e6:	4fa080e7          	jalr	1274(ra) # 59dc <exit>
      sbrk(BIG - (uint64)sbrk(0));
    44ea:	00001097          	auipc	ra,0x1
    44ee:	57a080e7          	jalr	1402(ra) # 5a64 <sbrk>
    44f2:	064007b7          	lui	a5,0x6400
    44f6:	40a7853b          	subw	a0,a5,a0
    44fa:	00001097          	auipc	ra,0x1
    44fe:	56a080e7          	jalr	1386(ra) # 5a64 <sbrk>
      write(fds[1], "x", 1);
    4502:	4605                	li	a2,1
    4504:	00002597          	auipc	a1,0x2
    4508:	ab458593          	addi	a1,a1,-1356 # 5fb8 <malloc+0x192>
    450c:	fb442503          	lw	a0,-76(s0)
    4510:	00001097          	auipc	ra,0x1
    4514:	4ec080e7          	jalr	1260(ra) # 59fc <write>
      for(;;) sleep(1000);
    4518:	3e800513          	li	a0,1000
    451c:	00001097          	auipc	ra,0x1
    4520:	550080e7          	jalr	1360(ra) # 5a6c <sleep>
    4524:	bfd5                	j	4518 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4526:	0911                	addi	s2,s2,4
    4528:	03390563          	beq	s2,s3,4552 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    452c:	00001097          	auipc	ra,0x1
    4530:	4a8080e7          	jalr	1192(ra) # 59d4 <fork>
    4534:	00a92023          	sw	a0,0(s2)
    4538:	d94d                	beqz	a0,44ea <sbrkfail+0x4c>
    if(pids[i] != -1)
    453a:	ff4506e3          	beq	a0,s4,4526 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    453e:	4605                	li	a2,1
    4540:	faf40593          	addi	a1,s0,-81
    4544:	fb042503          	lw	a0,-80(s0)
    4548:	00001097          	auipc	ra,0x1
    454c:	4ac080e7          	jalr	1196(ra) # 59f4 <read>
    4550:	bfd9                	j	4526 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4552:	6505                	lui	a0,0x1
    4554:	00001097          	auipc	ra,0x1
    4558:	510080e7          	jalr	1296(ra) # 5a64 <sbrk>
    455c:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    455e:	597d                	li	s2,-1
    4560:	a021                	j	4568 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4562:	0491                	addi	s1,s1,4
    4564:	01348f63          	beq	s1,s3,4582 <sbrkfail+0xe4>
    if(pids[i] == -1)
    4568:	4088                	lw	a0,0(s1)
    456a:	ff250ce3          	beq	a0,s2,4562 <sbrkfail+0xc4>
    kill(pids[i]);
    456e:	00001097          	auipc	ra,0x1
    4572:	49e080e7          	jalr	1182(ra) # 5a0c <kill>
    wait(0);
    4576:	4501                	li	a0,0
    4578:	00001097          	auipc	ra,0x1
    457c:	46c080e7          	jalr	1132(ra) # 59e4 <wait>
    4580:	b7cd                	j	4562 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    4582:	57fd                	li	a5,-1
    4584:	04fa0163          	beq	s4,a5,45c6 <sbrkfail+0x128>
  pid = fork();
    4588:	00001097          	auipc	ra,0x1
    458c:	44c080e7          	jalr	1100(ra) # 59d4 <fork>
    4590:	84aa                	mv	s1,a0
  if(pid < 0){
    4592:	04054863          	bltz	a0,45e2 <sbrkfail+0x144>
  if(pid == 0){
    4596:	c525                	beqz	a0,45fe <sbrkfail+0x160>
  wait(&xstatus);
    4598:	fbc40513          	addi	a0,s0,-68
    459c:	00001097          	auipc	ra,0x1
    45a0:	448080e7          	jalr	1096(ra) # 59e4 <wait>
  if(xstatus != -1 && xstatus != 2)
    45a4:	fbc42783          	lw	a5,-68(s0)
    45a8:	577d                	li	a4,-1
    45aa:	00e78563          	beq	a5,a4,45b4 <sbrkfail+0x116>
    45ae:	4709                	li	a4,2
    45b0:	08e79d63          	bne	a5,a4,464a <sbrkfail+0x1ac>
}
    45b4:	70e6                	ld	ra,120(sp)
    45b6:	7446                	ld	s0,112(sp)
    45b8:	74a6                	ld	s1,104(sp)
    45ba:	7906                	ld	s2,96(sp)
    45bc:	69e6                	ld	s3,88(sp)
    45be:	6a46                	ld	s4,80(sp)
    45c0:	6aa6                	ld	s5,72(sp)
    45c2:	6109                	addi	sp,sp,128
    45c4:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    45c6:	85d6                	mv	a1,s5
    45c8:	00003517          	auipc	a0,0x3
    45cc:	41050513          	addi	a0,a0,1040 # 79d8 <malloc+0x1bb2>
    45d0:	00001097          	auipc	ra,0x1
    45d4:	79e080e7          	jalr	1950(ra) # 5d6e <printf>
    exit(1);
    45d8:	4505                	li	a0,1
    45da:	00001097          	auipc	ra,0x1
    45de:	402080e7          	jalr	1026(ra) # 59dc <exit>
    printf("%s: fork failed\n", s);
    45e2:	85d6                	mv	a1,s5
    45e4:	00002517          	auipc	a0,0x2
    45e8:	09450513          	addi	a0,a0,148 # 6678 <malloc+0x852>
    45ec:	00001097          	auipc	ra,0x1
    45f0:	782080e7          	jalr	1922(ra) # 5d6e <printf>
    exit(1);
    45f4:	4505                	li	a0,1
    45f6:	00001097          	auipc	ra,0x1
    45fa:	3e6080e7          	jalr	998(ra) # 59dc <exit>
    a = sbrk(0);
    45fe:	4501                	li	a0,0
    4600:	00001097          	auipc	ra,0x1
    4604:	464080e7          	jalr	1124(ra) # 5a64 <sbrk>
    4608:	892a                	mv	s2,a0
    sbrk(10*BIG);
    460a:	3e800537          	lui	a0,0x3e800
    460e:	00001097          	auipc	ra,0x1
    4612:	456080e7          	jalr	1110(ra) # 5a64 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4616:	87ca                	mv	a5,s2
    4618:	3e800737          	lui	a4,0x3e800
    461c:	993a                	add	s2,s2,a4
    461e:	6705                	lui	a4,0x1
      n += *(a+i);
    4620:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0398>
    4624:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4626:	97ba                	add	a5,a5,a4
    4628:	ff279ce3          	bne	a5,s2,4620 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    462c:	8626                	mv	a2,s1
    462e:	85d6                	mv	a1,s5
    4630:	00003517          	auipc	a0,0x3
    4634:	3c850513          	addi	a0,a0,968 # 79f8 <malloc+0x1bd2>
    4638:	00001097          	auipc	ra,0x1
    463c:	736080e7          	jalr	1846(ra) # 5d6e <printf>
    exit(1);
    4640:	4505                	li	a0,1
    4642:	00001097          	auipc	ra,0x1
    4646:	39a080e7          	jalr	922(ra) # 59dc <exit>
    exit(1);
    464a:	4505                	li	a0,1
    464c:	00001097          	auipc	ra,0x1
    4650:	390080e7          	jalr	912(ra) # 59dc <exit>

0000000000004654 <mem>:
{
    4654:	7139                	addi	sp,sp,-64
    4656:	fc06                	sd	ra,56(sp)
    4658:	f822                	sd	s0,48(sp)
    465a:	f426                	sd	s1,40(sp)
    465c:	f04a                	sd	s2,32(sp)
    465e:	ec4e                	sd	s3,24(sp)
    4660:	0080                	addi	s0,sp,64
    4662:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4664:	00001097          	auipc	ra,0x1
    4668:	370080e7          	jalr	880(ra) # 59d4 <fork>
    m1 = 0;
    466c:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    466e:	6909                	lui	s2,0x2
    4670:	71190913          	addi	s2,s2,1809 # 2711 <sbrkmuch+0x47>
  if((pid = fork()) == 0){
    4674:	c115                	beqz	a0,4698 <mem+0x44>
    wait(&xstatus);
    4676:	fcc40513          	addi	a0,s0,-52
    467a:	00001097          	auipc	ra,0x1
    467e:	36a080e7          	jalr	874(ra) # 59e4 <wait>
    if(xstatus == -1){
    4682:	fcc42503          	lw	a0,-52(s0)
    4686:	57fd                	li	a5,-1
    4688:	06f50363          	beq	a0,a5,46ee <mem+0x9a>
    exit(xstatus);
    468c:	00001097          	auipc	ra,0x1
    4690:	350080e7          	jalr	848(ra) # 59dc <exit>
      *(char**)m2 = m1;
    4694:	e104                	sd	s1,0(a0)
      m1 = m2;
    4696:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4698:	854a                	mv	a0,s2
    469a:	00001097          	auipc	ra,0x1
    469e:	78c080e7          	jalr	1932(ra) # 5e26 <malloc>
    46a2:	f96d                	bnez	a0,4694 <mem+0x40>
    while(m1){
    46a4:	c881                	beqz	s1,46b4 <mem+0x60>
      m2 = *(char**)m1;
    46a6:	8526                	mv	a0,s1
    46a8:	6084                	ld	s1,0(s1)
      free(m1);
    46aa:	00001097          	auipc	ra,0x1
    46ae:	6fa080e7          	jalr	1786(ra) # 5da4 <free>
    while(m1){
    46b2:	f8f5                	bnez	s1,46a6 <mem+0x52>
    m1 = malloc(1024*20);
    46b4:	6515                	lui	a0,0x5
    46b6:	00001097          	auipc	ra,0x1
    46ba:	770080e7          	jalr	1904(ra) # 5e26 <malloc>
    if(m1 == 0){
    46be:	c911                	beqz	a0,46d2 <mem+0x7e>
    free(m1);
    46c0:	00001097          	auipc	ra,0x1
    46c4:	6e4080e7          	jalr	1764(ra) # 5da4 <free>
    exit(0);
    46c8:	4501                	li	a0,0
    46ca:	00001097          	auipc	ra,0x1
    46ce:	312080e7          	jalr	786(ra) # 59dc <exit>
      printf("couldn't allocate mem?!!\n", s);
    46d2:	85ce                	mv	a1,s3
    46d4:	00003517          	auipc	a0,0x3
    46d8:	35450513          	addi	a0,a0,852 # 7a28 <malloc+0x1c02>
    46dc:	00001097          	auipc	ra,0x1
    46e0:	692080e7          	jalr	1682(ra) # 5d6e <printf>
      exit(1);
    46e4:	4505                	li	a0,1
    46e6:	00001097          	auipc	ra,0x1
    46ea:	2f6080e7          	jalr	758(ra) # 59dc <exit>
      exit(0);
    46ee:	4501                	li	a0,0
    46f0:	00001097          	auipc	ra,0x1
    46f4:	2ec080e7          	jalr	748(ra) # 59dc <exit>

00000000000046f8 <sharedfd>:
{
    46f8:	7159                	addi	sp,sp,-112
    46fa:	f486                	sd	ra,104(sp)
    46fc:	f0a2                	sd	s0,96(sp)
    46fe:	eca6                	sd	s1,88(sp)
    4700:	e8ca                	sd	s2,80(sp)
    4702:	e4ce                	sd	s3,72(sp)
    4704:	e0d2                	sd	s4,64(sp)
    4706:	fc56                	sd	s5,56(sp)
    4708:	f85a                	sd	s6,48(sp)
    470a:	f45e                	sd	s7,40(sp)
    470c:	1880                	addi	s0,sp,112
    470e:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4710:	00003517          	auipc	a0,0x3
    4714:	33850513          	addi	a0,a0,824 # 7a48 <malloc+0x1c22>
    4718:	00001097          	auipc	ra,0x1
    471c:	314080e7          	jalr	788(ra) # 5a2c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4720:	20200593          	li	a1,514
    4724:	00003517          	auipc	a0,0x3
    4728:	32450513          	addi	a0,a0,804 # 7a48 <malloc+0x1c22>
    472c:	00001097          	auipc	ra,0x1
    4730:	2f0080e7          	jalr	752(ra) # 5a1c <open>
  if(fd < 0){
    4734:	0a054463          	bltz	a0,47dc <sharedfd+0xe4>
    4738:	892a                	mv	s2,a0
  pid = fork();
    473a:	00001097          	auipc	ra,0x1
    473e:	29a080e7          	jalr	666(ra) # 59d4 <fork>
    4742:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4744:	06300593          	li	a1,99
    4748:	c119                	beqz	a0,474e <sharedfd+0x56>
    474a:	07000593          	li	a1,112
    474e:	4629                	li	a2,10
    4750:	fa040513          	addi	a0,s0,-96
    4754:	00001097          	auipc	ra,0x1
    4758:	08e080e7          	jalr	142(ra) # 57e2 <memset>
    475c:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4760:	4629                	li	a2,10
    4762:	fa040593          	addi	a1,s0,-96
    4766:	854a                	mv	a0,s2
    4768:	00001097          	auipc	ra,0x1
    476c:	294080e7          	jalr	660(ra) # 59fc <write>
    4770:	47a9                	li	a5,10
    4772:	08f51363          	bne	a0,a5,47f8 <sharedfd+0x100>
  for(i = 0; i < N; i++){
    4776:	34fd                	addiw	s1,s1,-1
    4778:	f4e5                	bnez	s1,4760 <sharedfd+0x68>
  if(pid == 0) {
    477a:	08098d63          	beqz	s3,4814 <sharedfd+0x11c>
    wait(&xstatus);
    477e:	f9c40513          	addi	a0,s0,-100
    4782:	00001097          	auipc	ra,0x1
    4786:	262080e7          	jalr	610(ra) # 59e4 <wait>
    if(xstatus != 0)
    478a:	f9c42983          	lw	s3,-100(s0)
    478e:	08099863          	bnez	s3,481e <sharedfd+0x126>
  close(fd);
    4792:	854a                	mv	a0,s2
    4794:	00001097          	auipc	ra,0x1
    4798:	270080e7          	jalr	624(ra) # 5a04 <close>
  fd = open("sharedfd", 0);
    479c:	4581                	li	a1,0
    479e:	00003517          	auipc	a0,0x3
    47a2:	2aa50513          	addi	a0,a0,682 # 7a48 <malloc+0x1c22>
    47a6:	00001097          	auipc	ra,0x1
    47aa:	276080e7          	jalr	630(ra) # 5a1c <open>
    47ae:	8baa                	mv	s7,a0
  nc = np = 0;
    47b0:	8ace                	mv	s5,s3
  if(fd < 0){
    47b2:	06054b63          	bltz	a0,4828 <sharedfd+0x130>
    47b6:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    47ba:	06300493          	li	s1,99
      if(buf[i] == 'p')
    47be:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    47c2:	4629                	li	a2,10
    47c4:	fa040593          	addi	a1,s0,-96
    47c8:	855e                	mv	a0,s7
    47ca:	00001097          	auipc	ra,0x1
    47ce:	22a080e7          	jalr	554(ra) # 59f4 <read>
    47d2:	08a05563          	blez	a0,485c <sharedfd+0x164>
    47d6:	fa040793          	addi	a5,s0,-96
    47da:	a88d                	j	484c <sharedfd+0x154>
    printf("%s: cannot open sharedfd for writing", s);
    47dc:	85d2                	mv	a1,s4
    47de:	00003517          	auipc	a0,0x3
    47e2:	27a50513          	addi	a0,a0,634 # 7a58 <malloc+0x1c32>
    47e6:	00001097          	auipc	ra,0x1
    47ea:	588080e7          	jalr	1416(ra) # 5d6e <printf>
    exit(1);
    47ee:	4505                	li	a0,1
    47f0:	00001097          	auipc	ra,0x1
    47f4:	1ec080e7          	jalr	492(ra) # 59dc <exit>
      printf("%s: write sharedfd failed\n", s);
    47f8:	85d2                	mv	a1,s4
    47fa:	00003517          	auipc	a0,0x3
    47fe:	28650513          	addi	a0,a0,646 # 7a80 <malloc+0x1c5a>
    4802:	00001097          	auipc	ra,0x1
    4806:	56c080e7          	jalr	1388(ra) # 5d6e <printf>
      exit(1);
    480a:	4505                	li	a0,1
    480c:	00001097          	auipc	ra,0x1
    4810:	1d0080e7          	jalr	464(ra) # 59dc <exit>
    exit(0);
    4814:	4501                	li	a0,0
    4816:	00001097          	auipc	ra,0x1
    481a:	1c6080e7          	jalr	454(ra) # 59dc <exit>
      exit(xstatus);
    481e:	854e                	mv	a0,s3
    4820:	00001097          	auipc	ra,0x1
    4824:	1bc080e7          	jalr	444(ra) # 59dc <exit>
    printf("%s: cannot open sharedfd for reading\n", s);
    4828:	85d2                	mv	a1,s4
    482a:	00003517          	auipc	a0,0x3
    482e:	27650513          	addi	a0,a0,630 # 7aa0 <malloc+0x1c7a>
    4832:	00001097          	auipc	ra,0x1
    4836:	53c080e7          	jalr	1340(ra) # 5d6e <printf>
    exit(1);
    483a:	4505                	li	a0,1
    483c:	00001097          	auipc	ra,0x1
    4840:	1a0080e7          	jalr	416(ra) # 59dc <exit>
        nc++;
    4844:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4846:	0785                	addi	a5,a5,1
    4848:	f7278de3          	beq	a5,s2,47c2 <sharedfd+0xca>
      if(buf[i] == 'c')
    484c:	0007c703          	lbu	a4,0(a5)
    4850:	fe970ae3          	beq	a4,s1,4844 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4854:	ff6719e3          	bne	a4,s6,4846 <sharedfd+0x14e>
        np++;
    4858:	2a85                	addiw	s5,s5,1
    485a:	b7f5                	j	4846 <sharedfd+0x14e>
  close(fd);
    485c:	855e                	mv	a0,s7
    485e:	00001097          	auipc	ra,0x1
    4862:	1a6080e7          	jalr	422(ra) # 5a04 <close>
  unlink("sharedfd");
    4866:	00003517          	auipc	a0,0x3
    486a:	1e250513          	addi	a0,a0,482 # 7a48 <malloc+0x1c22>
    486e:	00001097          	auipc	ra,0x1
    4872:	1be080e7          	jalr	446(ra) # 5a2c <unlink>
  if(nc == N*SZ && np == N*SZ){
    4876:	6789                	lui	a5,0x2
    4878:	71078793          	addi	a5,a5,1808 # 2710 <sbrkmuch+0x46>
    487c:	00f99763          	bne	s3,a5,488a <sharedfd+0x192>
    4880:	6789                	lui	a5,0x2
    4882:	71078793          	addi	a5,a5,1808 # 2710 <sbrkmuch+0x46>
    4886:	02fa8663          	beq	s5,a5,48b2 <sharedfd+0x1ba>
    printf("%s: nc/np test fails\n", s);
    488a:	85d2                	mv	a1,s4
    488c:	00003517          	auipc	a0,0x3
    4890:	23c50513          	addi	a0,a0,572 # 7ac8 <malloc+0x1ca2>
    4894:	00001097          	auipc	ra,0x1
    4898:	4da080e7          	jalr	1242(ra) # 5d6e <printf>
}
    489c:	70a6                	ld	ra,104(sp)
    489e:	7406                	ld	s0,96(sp)
    48a0:	64e6                	ld	s1,88(sp)
    48a2:	6946                	ld	s2,80(sp)
    48a4:	69a6                	ld	s3,72(sp)
    48a6:	6a06                	ld	s4,64(sp)
    48a8:	7ae2                	ld	s5,56(sp)
    48aa:	7b42                	ld	s6,48(sp)
    48ac:	7ba2                	ld	s7,40(sp)
    48ae:	6165                	addi	sp,sp,112
    48b0:	8082                	ret
    exit(0);
    48b2:	4501                	li	a0,0
    48b4:	00001097          	auipc	ra,0x1
    48b8:	128080e7          	jalr	296(ra) # 59dc <exit>

00000000000048bc <fourfiles>:
{
    48bc:	7131                	addi	sp,sp,-192
    48be:	fd06                	sd	ra,184(sp)
    48c0:	f922                	sd	s0,176(sp)
    48c2:	f526                	sd	s1,168(sp)
    48c4:	f14a                	sd	s2,160(sp)
    48c6:	ed4e                	sd	s3,152(sp)
    48c8:	e952                	sd	s4,144(sp)
    48ca:	e556                	sd	s5,136(sp)
    48cc:	e15a                	sd	s6,128(sp)
    48ce:	fcde                	sd	s7,120(sp)
    48d0:	f8e2                	sd	s8,112(sp)
    48d2:	f4e6                	sd	s9,104(sp)
    48d4:	f0ea                	sd	s10,96(sp)
    48d6:	ecee                	sd	s11,88(sp)
    48d8:	0180                	addi	s0,sp,192
    48da:	8aaa                	mv	s5,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    48dc:	00003797          	auipc	a5,0x3
    48e0:	20478793          	addi	a5,a5,516 # 7ae0 <malloc+0x1cba>
    48e4:	f6f43823          	sd	a5,-144(s0)
    48e8:	00003797          	auipc	a5,0x3
    48ec:	20078793          	addi	a5,a5,512 # 7ae8 <malloc+0x1cc2>
    48f0:	f6f43c23          	sd	a5,-136(s0)
    48f4:	00003797          	auipc	a5,0x3
    48f8:	1fc78793          	addi	a5,a5,508 # 7af0 <malloc+0x1cca>
    48fc:	f8f43023          	sd	a5,-128(s0)
    4900:	00003797          	auipc	a5,0x3
    4904:	1f878793          	addi	a5,a5,504 # 7af8 <malloc+0x1cd2>
    4908:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    490c:	f7040793          	addi	a5,s0,-144
    4910:	f4f43c23          	sd	a5,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    4914:	893e                	mv	s2,a5
  for(pi = 0; pi < NCHILD; pi++){
    4916:	4481                	li	s1,0
    4918:	4a11                	li	s4,4
    fname = names[pi];
    491a:	00093983          	ld	s3,0(s2)
    unlink(fname);
    491e:	854e                	mv	a0,s3
    4920:	00001097          	auipc	ra,0x1
    4924:	10c080e7          	jalr	268(ra) # 5a2c <unlink>
    pid = fork();
    4928:	00001097          	auipc	ra,0x1
    492c:	0ac080e7          	jalr	172(ra) # 59d4 <fork>
    if(pid < 0){
    4930:	04054963          	bltz	a0,4982 <fourfiles+0xc6>
    if(pid == 0){
    4934:	c52d                	beqz	a0,499e <fourfiles+0xe2>
  for(pi = 0; pi < NCHILD; pi++){
    4936:	2485                	addiw	s1,s1,1
    4938:	0921                	addi	s2,s2,8
    493a:	ff4490e3          	bne	s1,s4,491a <fourfiles+0x5e>
    493e:	4491                	li	s1,4
    wait(&xstatus);
    4940:	f6c40513          	addi	a0,s0,-148
    4944:	00001097          	auipc	ra,0x1
    4948:	0a0080e7          	jalr	160(ra) # 59e4 <wait>
    if(xstatus != 0)
    494c:	f6c42783          	lw	a5,-148(s0)
    4950:	f4f43823          	sd	a5,-176(s0)
    4954:	eff9                	bnez	a5,4a32 <fourfiles+0x176>
  for(pi = 0; pi < NCHILD; pi++){
    4956:	34fd                	addiw	s1,s1,-1
    4958:	f4e5                	bnez	s1,4940 <fourfiles+0x84>
    495a:	03000d93          	li	s11,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    495e:	00008c97          	auipc	s9,0x8
    4962:	30ac8c93          	addi	s9,s9,778 # cc68 <buf>
    4966:	00008d17          	auipc	s10,0x8
    496a:	303d0d13          	addi	s10,s10,771 # cc69 <buf+0x1>
          printf("wrong char\n", s);
    496e:	00003b17          	auipc	s6,0x3
    4972:	1bab0b13          	addi	s6,s6,442 # 7b28 <malloc+0x1d02>
    if(total != N*SZ){
    4976:	6785                	lui	a5,0x1
    4978:	77078793          	addi	a5,a5,1904 # 1770 <pipe1+0x150>
    497c:	f4f43023          	sd	a5,-192(s0)
    4980:	aa25                	j	4ab8 <fourfiles+0x1fc>
      printf("fork failed\n", s);
    4982:	85d6                	mv	a1,s5
    4984:	00002517          	auipc	a0,0x2
    4988:	0fc50513          	addi	a0,a0,252 # 6a80 <malloc+0xc5a>
    498c:	00001097          	auipc	ra,0x1
    4990:	3e2080e7          	jalr	994(ra) # 5d6e <printf>
      exit(1);
    4994:	4505                	li	a0,1
    4996:	00001097          	auipc	ra,0x1
    499a:	046080e7          	jalr	70(ra) # 59dc <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    499e:	20200593          	li	a1,514
    49a2:	854e                	mv	a0,s3
    49a4:	00001097          	auipc	ra,0x1
    49a8:	078080e7          	jalr	120(ra) # 5a1c <open>
    49ac:	892a                	mv	s2,a0
      if(fd < 0){
    49ae:	04054663          	bltz	a0,49fa <fourfiles+0x13e>
      memset(buf, '0'+pi, SZ);
    49b2:	1f400613          	li	a2,500
    49b6:	0304859b          	addiw	a1,s1,48
    49ba:	00008517          	auipc	a0,0x8
    49be:	2ae50513          	addi	a0,a0,686 # cc68 <buf>
    49c2:	00001097          	auipc	ra,0x1
    49c6:	e20080e7          	jalr	-480(ra) # 57e2 <memset>
    49ca:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    49cc:	00008997          	auipc	s3,0x8
    49d0:	29c98993          	addi	s3,s3,668 # cc68 <buf>
    49d4:	1f400613          	li	a2,500
    49d8:	85ce                	mv	a1,s3
    49da:	854a                	mv	a0,s2
    49dc:	00001097          	auipc	ra,0x1
    49e0:	020080e7          	jalr	32(ra) # 59fc <write>
    49e4:	1f400793          	li	a5,500
    49e8:	02f51763          	bne	a0,a5,4a16 <fourfiles+0x15a>
      for(i = 0; i < N; i++){
    49ec:	34fd                	addiw	s1,s1,-1
    49ee:	f0fd                	bnez	s1,49d4 <fourfiles+0x118>
      exit(0);
    49f0:	4501                	li	a0,0
    49f2:	00001097          	auipc	ra,0x1
    49f6:	fea080e7          	jalr	-22(ra) # 59dc <exit>
        printf("create failed\n", s);
    49fa:	85d6                	mv	a1,s5
    49fc:	00003517          	auipc	a0,0x3
    4a00:	10450513          	addi	a0,a0,260 # 7b00 <malloc+0x1cda>
    4a04:	00001097          	auipc	ra,0x1
    4a08:	36a080e7          	jalr	874(ra) # 5d6e <printf>
        exit(1);
    4a0c:	4505                	li	a0,1
    4a0e:	00001097          	auipc	ra,0x1
    4a12:	fce080e7          	jalr	-50(ra) # 59dc <exit>
          printf("write failed %d\n", n);
    4a16:	85aa                	mv	a1,a0
    4a18:	00003517          	auipc	a0,0x3
    4a1c:	0f850513          	addi	a0,a0,248 # 7b10 <malloc+0x1cea>
    4a20:	00001097          	auipc	ra,0x1
    4a24:	34e080e7          	jalr	846(ra) # 5d6e <printf>
          exit(1);
    4a28:	4505                	li	a0,1
    4a2a:	00001097          	auipc	ra,0x1
    4a2e:	fb2080e7          	jalr	-78(ra) # 59dc <exit>
      exit(xstatus);
    4a32:	853e                	mv	a0,a5
    4a34:	00001097          	auipc	ra,0x1
    4a38:	fa8080e7          	jalr	-88(ra) # 59dc <exit>
      for(j = 0; j < n; j++){
    4a3c:	0485                	addi	s1,s1,1
    4a3e:	01248d63          	beq	s1,s2,4a58 <fourfiles+0x19c>
        if(buf[j] != '0'+i){
    4a42:	0004c783          	lbu	a5,0(s1)
    4a46:	ff378be3          	beq	a5,s3,4a3c <fourfiles+0x180>
          printf("wrong char\n", s);
    4a4a:	85d6                	mv	a1,s5
    4a4c:	855a                	mv	a0,s6
    4a4e:	00001097          	auipc	ra,0x1
    4a52:	320080e7          	jalr	800(ra) # 5d6e <printf>
    4a56:	b7dd                	j	4a3c <fourfiles+0x180>
      total += n;
    4a58:	014b8bbb          	addw	s7,s7,s4
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4a5c:	660d                	lui	a2,0x3
    4a5e:	85e6                	mv	a1,s9
    4a60:	8562                	mv	a0,s8
    4a62:	00001097          	auipc	ra,0x1
    4a66:	f92080e7          	jalr	-110(ra) # 59f4 <read>
    4a6a:	8a2a                	mv	s4,a0
    4a6c:	00a05d63          	blez	a0,4a86 <fourfiles+0x1ca>
    4a70:	00008497          	auipc	s1,0x8
    4a74:	1f848493          	addi	s1,s1,504 # cc68 <buf>
    4a78:	fffa091b          	addiw	s2,s4,-1
    4a7c:	1902                	slli	s2,s2,0x20
    4a7e:	02095913          	srli	s2,s2,0x20
    4a82:	996a                	add	s2,s2,s10
    4a84:	bf7d                	j	4a42 <fourfiles+0x186>
    close(fd);
    4a86:	8562                	mv	a0,s8
    4a88:	00001097          	auipc	ra,0x1
    4a8c:	f7c080e7          	jalr	-132(ra) # 5a04 <close>
    if(total != N*SZ){
    4a90:	f4043783          	ld	a5,-192(s0)
    4a94:	04fb9363          	bne	s7,a5,4ada <fourfiles+0x21e>
    unlink(fname);
    4a98:	f4843503          	ld	a0,-184(s0)
    4a9c:	00001097          	auipc	ra,0x1
    4aa0:	f90080e7          	jalr	-112(ra) # 5a2c <unlink>
  for(i = 0; i < NCHILD; i++){
    4aa4:	f5843783          	ld	a5,-168(s0)
    4aa8:	07a1                	addi	a5,a5,8
    4aaa:	f4f43c23          	sd	a5,-168(s0)
    4aae:	2d85                	addiw	s11,s11,1
    4ab0:	03400793          	li	a5,52
    4ab4:	04fd8163          	beq	s11,a5,4af6 <fourfiles+0x23a>
    fname = names[i];
    4ab8:	f5843783          	ld	a5,-168(s0)
    4abc:	639c                	ld	a5,0(a5)
    4abe:	f4f43423          	sd	a5,-184(s0)
    fd = open(fname, 0);
    4ac2:	4581                	li	a1,0
    4ac4:	853e                	mv	a0,a5
    4ac6:	00001097          	auipc	ra,0x1
    4aca:	f56080e7          	jalr	-170(ra) # 5a1c <open>
    4ace:	8c2a                	mv	s8,a0
    total = 0;
    4ad0:	f5043b83          	ld	s7,-176(s0)
        if(buf[j] != '0'+i){
    4ad4:	000d899b          	sext.w	s3,s11
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4ad8:	b751                	j	4a5c <fourfiles+0x1a0>
      printf("wrong length %d\n", total);
    4ada:	85de                	mv	a1,s7
    4adc:	00003517          	auipc	a0,0x3
    4ae0:	05c50513          	addi	a0,a0,92 # 7b38 <malloc+0x1d12>
    4ae4:	00001097          	auipc	ra,0x1
    4ae8:	28a080e7          	jalr	650(ra) # 5d6e <printf>
      exit(1);
    4aec:	4505                	li	a0,1
    4aee:	00001097          	auipc	ra,0x1
    4af2:	eee080e7          	jalr	-274(ra) # 59dc <exit>
}
    4af6:	70ea                	ld	ra,184(sp)
    4af8:	744a                	ld	s0,176(sp)
    4afa:	74aa                	ld	s1,168(sp)
    4afc:	790a                	ld	s2,160(sp)
    4afe:	69ea                	ld	s3,152(sp)
    4b00:	6a4a                	ld	s4,144(sp)
    4b02:	6aaa                	ld	s5,136(sp)
    4b04:	6b0a                	ld	s6,128(sp)
    4b06:	7be6                	ld	s7,120(sp)
    4b08:	7c46                	ld	s8,112(sp)
    4b0a:	7ca6                	ld	s9,104(sp)
    4b0c:	7d06                	ld	s10,96(sp)
    4b0e:	6de6                	ld	s11,88(sp)
    4b10:	6129                	addi	sp,sp,192
    4b12:	8082                	ret

0000000000004b14 <concreate>:
{
    4b14:	7135                	addi	sp,sp,-160
    4b16:	ed06                	sd	ra,152(sp)
    4b18:	e922                	sd	s0,144(sp)
    4b1a:	e526                	sd	s1,136(sp)
    4b1c:	e14a                	sd	s2,128(sp)
    4b1e:	fcce                	sd	s3,120(sp)
    4b20:	f8d2                	sd	s4,112(sp)
    4b22:	f4d6                	sd	s5,104(sp)
    4b24:	f0da                	sd	s6,96(sp)
    4b26:	ecde                	sd	s7,88(sp)
    4b28:	1100                	addi	s0,sp,160
    4b2a:	89aa                	mv	s3,a0
  file[0] = 'C';
    4b2c:	04300793          	li	a5,67
    4b30:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4b34:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4b38:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4b3a:	4b0d                	li	s6,3
    4b3c:	4a85                	li	s5,1
      link("C0", file);
    4b3e:	00003b97          	auipc	s7,0x3
    4b42:	012b8b93          	addi	s7,s7,18 # 7b50 <malloc+0x1d2a>
  for(i = 0; i < N; i++){
    4b46:	02800a13          	li	s4,40
    4b4a:	acc9                	j	4e1c <concreate+0x308>
      link("C0", file);
    4b4c:	fa840593          	addi	a1,s0,-88
    4b50:	855e                	mv	a0,s7
    4b52:	00001097          	auipc	ra,0x1
    4b56:	eea080e7          	jalr	-278(ra) # 5a3c <link>
    if(pid == 0) {
    4b5a:	a465                	j	4e02 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4b5c:	4795                	li	a5,5
    4b5e:	02f9693b          	remw	s2,s2,a5
    4b62:	4785                	li	a5,1
    4b64:	02f90b63          	beq	s2,a5,4b9a <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4b68:	20200593          	li	a1,514
    4b6c:	fa840513          	addi	a0,s0,-88
    4b70:	00001097          	auipc	ra,0x1
    4b74:	eac080e7          	jalr	-340(ra) # 5a1c <open>
      if(fd < 0){
    4b78:	26055c63          	bgez	a0,4df0 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4b7c:	fa840593          	addi	a1,s0,-88
    4b80:	00003517          	auipc	a0,0x3
    4b84:	fd850513          	addi	a0,a0,-40 # 7b58 <malloc+0x1d32>
    4b88:	00001097          	auipc	ra,0x1
    4b8c:	1e6080e7          	jalr	486(ra) # 5d6e <printf>
        exit(1);
    4b90:	4505                	li	a0,1
    4b92:	00001097          	auipc	ra,0x1
    4b96:	e4a080e7          	jalr	-438(ra) # 59dc <exit>
      link("C0", file);
    4b9a:	fa840593          	addi	a1,s0,-88
    4b9e:	00003517          	auipc	a0,0x3
    4ba2:	fb250513          	addi	a0,a0,-78 # 7b50 <malloc+0x1d2a>
    4ba6:	00001097          	auipc	ra,0x1
    4baa:	e96080e7          	jalr	-362(ra) # 5a3c <link>
      exit(0);
    4bae:	4501                	li	a0,0
    4bb0:	00001097          	auipc	ra,0x1
    4bb4:	e2c080e7          	jalr	-468(ra) # 59dc <exit>
        exit(1);
    4bb8:	4505                	li	a0,1
    4bba:	00001097          	auipc	ra,0x1
    4bbe:	e22080e7          	jalr	-478(ra) # 59dc <exit>
  memset(fa, 0, sizeof(fa));
    4bc2:	02800613          	li	a2,40
    4bc6:	4581                	li	a1,0
    4bc8:	f8040513          	addi	a0,s0,-128
    4bcc:	00001097          	auipc	ra,0x1
    4bd0:	c16080e7          	jalr	-1002(ra) # 57e2 <memset>
  fd = open(".", 0);
    4bd4:	4581                	li	a1,0
    4bd6:	00002517          	auipc	a0,0x2
    4bda:	96a50513          	addi	a0,a0,-1686 # 6540 <malloc+0x71a>
    4bde:	00001097          	auipc	ra,0x1
    4be2:	e3e080e7          	jalr	-450(ra) # 5a1c <open>
    4be6:	892a                	mv	s2,a0
  n = 0;
    4be8:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4bea:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4bee:	02700b13          	li	s6,39
      fa[i] = 1;
    4bf2:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4bf4:	4641                	li	a2,16
    4bf6:	f7040593          	addi	a1,s0,-144
    4bfa:	854a                	mv	a0,s2
    4bfc:	00001097          	auipc	ra,0x1
    4c00:	df8080e7          	jalr	-520(ra) # 59f4 <read>
    4c04:	08a05263          	blez	a0,4c88 <concreate+0x174>
    if(de.inum == 0)
    4c08:	f7045783          	lhu	a5,-144(s0)
    4c0c:	d7e5                	beqz	a5,4bf4 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4c0e:	f7244783          	lbu	a5,-142(s0)
    4c12:	ff4791e3          	bne	a5,s4,4bf4 <concreate+0xe0>
    4c16:	f7444783          	lbu	a5,-140(s0)
    4c1a:	ffe9                	bnez	a5,4bf4 <concreate+0xe0>
      i = de.name[1] - '0';
    4c1c:	f7344783          	lbu	a5,-141(s0)
    4c20:	fd07879b          	addiw	a5,a5,-48
    4c24:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4c28:	02eb6063          	bltu	s6,a4,4c48 <concreate+0x134>
      if(fa[i]){
    4c2c:	fb070793          	addi	a5,a4,-80 # fb0 <validatetest+0x8>
    4c30:	97a2                	add	a5,a5,s0
    4c32:	fd07c783          	lbu	a5,-48(a5)
    4c36:	eb8d                	bnez	a5,4c68 <concreate+0x154>
      fa[i] = 1;
    4c38:	fb070793          	addi	a5,a4,-80
    4c3c:	00878733          	add	a4,a5,s0
    4c40:	fd770823          	sb	s7,-48(a4)
      n++;
    4c44:	2a85                	addiw	s5,s5,1
    4c46:	b77d                	j	4bf4 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4c48:	f7240613          	addi	a2,s0,-142
    4c4c:	85ce                	mv	a1,s3
    4c4e:	00003517          	auipc	a0,0x3
    4c52:	f2a50513          	addi	a0,a0,-214 # 7b78 <malloc+0x1d52>
    4c56:	00001097          	auipc	ra,0x1
    4c5a:	118080e7          	jalr	280(ra) # 5d6e <printf>
        exit(1);
    4c5e:	4505                	li	a0,1
    4c60:	00001097          	auipc	ra,0x1
    4c64:	d7c080e7          	jalr	-644(ra) # 59dc <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4c68:	f7240613          	addi	a2,s0,-142
    4c6c:	85ce                	mv	a1,s3
    4c6e:	00003517          	auipc	a0,0x3
    4c72:	f2a50513          	addi	a0,a0,-214 # 7b98 <malloc+0x1d72>
    4c76:	00001097          	auipc	ra,0x1
    4c7a:	0f8080e7          	jalr	248(ra) # 5d6e <printf>
        exit(1);
    4c7e:	4505                	li	a0,1
    4c80:	00001097          	auipc	ra,0x1
    4c84:	d5c080e7          	jalr	-676(ra) # 59dc <exit>
  close(fd);
    4c88:	854a                	mv	a0,s2
    4c8a:	00001097          	auipc	ra,0x1
    4c8e:	d7a080e7          	jalr	-646(ra) # 5a04 <close>
  if(n != N){
    4c92:	02800793          	li	a5,40
    4c96:	00fa9763          	bne	s5,a5,4ca4 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4c9a:	4a8d                	li	s5,3
    4c9c:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4c9e:	02800a13          	li	s4,40
    4ca2:	a8c9                	j	4d74 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4ca4:	85ce                	mv	a1,s3
    4ca6:	00003517          	auipc	a0,0x3
    4caa:	f1a50513          	addi	a0,a0,-230 # 7bc0 <malloc+0x1d9a>
    4cae:	00001097          	auipc	ra,0x1
    4cb2:	0c0080e7          	jalr	192(ra) # 5d6e <printf>
    exit(1);
    4cb6:	4505                	li	a0,1
    4cb8:	00001097          	auipc	ra,0x1
    4cbc:	d24080e7          	jalr	-732(ra) # 59dc <exit>
      printf("%s: fork failed\n", s);
    4cc0:	85ce                	mv	a1,s3
    4cc2:	00002517          	auipc	a0,0x2
    4cc6:	9b650513          	addi	a0,a0,-1610 # 6678 <malloc+0x852>
    4cca:	00001097          	auipc	ra,0x1
    4cce:	0a4080e7          	jalr	164(ra) # 5d6e <printf>
      exit(1);
    4cd2:	4505                	li	a0,1
    4cd4:	00001097          	auipc	ra,0x1
    4cd8:	d08080e7          	jalr	-760(ra) # 59dc <exit>
      close(open(file, 0));
    4cdc:	4581                	li	a1,0
    4cde:	fa840513          	addi	a0,s0,-88
    4ce2:	00001097          	auipc	ra,0x1
    4ce6:	d3a080e7          	jalr	-710(ra) # 5a1c <open>
    4cea:	00001097          	auipc	ra,0x1
    4cee:	d1a080e7          	jalr	-742(ra) # 5a04 <close>
      close(open(file, 0));
    4cf2:	4581                	li	a1,0
    4cf4:	fa840513          	addi	a0,s0,-88
    4cf8:	00001097          	auipc	ra,0x1
    4cfc:	d24080e7          	jalr	-732(ra) # 5a1c <open>
    4d00:	00001097          	auipc	ra,0x1
    4d04:	d04080e7          	jalr	-764(ra) # 5a04 <close>
      close(open(file, 0));
    4d08:	4581                	li	a1,0
    4d0a:	fa840513          	addi	a0,s0,-88
    4d0e:	00001097          	auipc	ra,0x1
    4d12:	d0e080e7          	jalr	-754(ra) # 5a1c <open>
    4d16:	00001097          	auipc	ra,0x1
    4d1a:	cee080e7          	jalr	-786(ra) # 5a04 <close>
      close(open(file, 0));
    4d1e:	4581                	li	a1,0
    4d20:	fa840513          	addi	a0,s0,-88
    4d24:	00001097          	auipc	ra,0x1
    4d28:	cf8080e7          	jalr	-776(ra) # 5a1c <open>
    4d2c:	00001097          	auipc	ra,0x1
    4d30:	cd8080e7          	jalr	-808(ra) # 5a04 <close>
      close(open(file, 0));
    4d34:	4581                	li	a1,0
    4d36:	fa840513          	addi	a0,s0,-88
    4d3a:	00001097          	auipc	ra,0x1
    4d3e:	ce2080e7          	jalr	-798(ra) # 5a1c <open>
    4d42:	00001097          	auipc	ra,0x1
    4d46:	cc2080e7          	jalr	-830(ra) # 5a04 <close>
      close(open(file, 0));
    4d4a:	4581                	li	a1,0
    4d4c:	fa840513          	addi	a0,s0,-88
    4d50:	00001097          	auipc	ra,0x1
    4d54:	ccc080e7          	jalr	-820(ra) # 5a1c <open>
    4d58:	00001097          	auipc	ra,0x1
    4d5c:	cac080e7          	jalr	-852(ra) # 5a04 <close>
    if(pid == 0)
    4d60:	08090363          	beqz	s2,4de6 <concreate+0x2d2>
      wait(0);
    4d64:	4501                	li	a0,0
    4d66:	00001097          	auipc	ra,0x1
    4d6a:	c7e080e7          	jalr	-898(ra) # 59e4 <wait>
  for(i = 0; i < N; i++){
    4d6e:	2485                	addiw	s1,s1,1
    4d70:	0f448563          	beq	s1,s4,4e5a <concreate+0x346>
    file[1] = '0' + i;
    4d74:	0304879b          	addiw	a5,s1,48
    4d78:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4d7c:	00001097          	auipc	ra,0x1
    4d80:	c58080e7          	jalr	-936(ra) # 59d4 <fork>
    4d84:	892a                	mv	s2,a0
    if(pid < 0){
    4d86:	f2054de3          	bltz	a0,4cc0 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    4d8a:	0354e73b          	remw	a4,s1,s5
    4d8e:	00a767b3          	or	a5,a4,a0
    4d92:	2781                	sext.w	a5,a5
    4d94:	d7a1                	beqz	a5,4cdc <concreate+0x1c8>
    4d96:	01671363          	bne	a4,s6,4d9c <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    4d9a:	f129                	bnez	a0,4cdc <concreate+0x1c8>
      unlink(file);
    4d9c:	fa840513          	addi	a0,s0,-88
    4da0:	00001097          	auipc	ra,0x1
    4da4:	c8c080e7          	jalr	-884(ra) # 5a2c <unlink>
      unlink(file);
    4da8:	fa840513          	addi	a0,s0,-88
    4dac:	00001097          	auipc	ra,0x1
    4db0:	c80080e7          	jalr	-896(ra) # 5a2c <unlink>
      unlink(file);
    4db4:	fa840513          	addi	a0,s0,-88
    4db8:	00001097          	auipc	ra,0x1
    4dbc:	c74080e7          	jalr	-908(ra) # 5a2c <unlink>
      unlink(file);
    4dc0:	fa840513          	addi	a0,s0,-88
    4dc4:	00001097          	auipc	ra,0x1
    4dc8:	c68080e7          	jalr	-920(ra) # 5a2c <unlink>
      unlink(file);
    4dcc:	fa840513          	addi	a0,s0,-88
    4dd0:	00001097          	auipc	ra,0x1
    4dd4:	c5c080e7          	jalr	-932(ra) # 5a2c <unlink>
      unlink(file);
    4dd8:	fa840513          	addi	a0,s0,-88
    4ddc:	00001097          	auipc	ra,0x1
    4de0:	c50080e7          	jalr	-944(ra) # 5a2c <unlink>
    4de4:	bfb5                	j	4d60 <concreate+0x24c>
      exit(0);
    4de6:	4501                	li	a0,0
    4de8:	00001097          	auipc	ra,0x1
    4dec:	bf4080e7          	jalr	-1036(ra) # 59dc <exit>
      close(fd);
    4df0:	00001097          	auipc	ra,0x1
    4df4:	c14080e7          	jalr	-1004(ra) # 5a04 <close>
    if(pid == 0) {
    4df8:	bb5d                	j	4bae <concreate+0x9a>
      close(fd);
    4dfa:	00001097          	auipc	ra,0x1
    4dfe:	c0a080e7          	jalr	-1014(ra) # 5a04 <close>
      wait(&xstatus);
    4e02:	f6c40513          	addi	a0,s0,-148
    4e06:	00001097          	auipc	ra,0x1
    4e0a:	bde080e7          	jalr	-1058(ra) # 59e4 <wait>
      if(xstatus != 0)
    4e0e:	f6c42483          	lw	s1,-148(s0)
    4e12:	da0493e3          	bnez	s1,4bb8 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4e16:	2905                	addiw	s2,s2,1
    4e18:	db4905e3          	beq	s2,s4,4bc2 <concreate+0xae>
    file[1] = '0' + i;
    4e1c:	0309079b          	addiw	a5,s2,48
    4e20:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4e24:	fa840513          	addi	a0,s0,-88
    4e28:	00001097          	auipc	ra,0x1
    4e2c:	c04080e7          	jalr	-1020(ra) # 5a2c <unlink>
    pid = fork();
    4e30:	00001097          	auipc	ra,0x1
    4e34:	ba4080e7          	jalr	-1116(ra) # 59d4 <fork>
    if(pid && (i % 3) == 1){
    4e38:	d20502e3          	beqz	a0,4b5c <concreate+0x48>
    4e3c:	036967bb          	remw	a5,s2,s6
    4e40:	d15786e3          	beq	a5,s5,4b4c <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4e44:	20200593          	li	a1,514
    4e48:	fa840513          	addi	a0,s0,-88
    4e4c:	00001097          	auipc	ra,0x1
    4e50:	bd0080e7          	jalr	-1072(ra) # 5a1c <open>
      if(fd < 0){
    4e54:	fa0553e3          	bgez	a0,4dfa <concreate+0x2e6>
    4e58:	b315                	j	4b7c <concreate+0x68>
}
    4e5a:	60ea                	ld	ra,152(sp)
    4e5c:	644a                	ld	s0,144(sp)
    4e5e:	64aa                	ld	s1,136(sp)
    4e60:	690a                	ld	s2,128(sp)
    4e62:	79e6                	ld	s3,120(sp)
    4e64:	7a46                	ld	s4,112(sp)
    4e66:	7aa6                	ld	s5,104(sp)
    4e68:	7b06                	ld	s6,96(sp)
    4e6a:	6be6                	ld	s7,88(sp)
    4e6c:	610d                	addi	sp,sp,160
    4e6e:	8082                	ret

0000000000004e70 <bigfile>:
{
    4e70:	7139                	addi	sp,sp,-64
    4e72:	fc06                	sd	ra,56(sp)
    4e74:	f822                	sd	s0,48(sp)
    4e76:	f426                	sd	s1,40(sp)
    4e78:	f04a                	sd	s2,32(sp)
    4e7a:	ec4e                	sd	s3,24(sp)
    4e7c:	e852                	sd	s4,16(sp)
    4e7e:	e456                	sd	s5,8(sp)
    4e80:	0080                	addi	s0,sp,64
    4e82:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4e84:	00003517          	auipc	a0,0x3
    4e88:	d7450513          	addi	a0,a0,-652 # 7bf8 <malloc+0x1dd2>
    4e8c:	00001097          	auipc	ra,0x1
    4e90:	ba0080e7          	jalr	-1120(ra) # 5a2c <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4e94:	20200593          	li	a1,514
    4e98:	00003517          	auipc	a0,0x3
    4e9c:	d6050513          	addi	a0,a0,-672 # 7bf8 <malloc+0x1dd2>
    4ea0:	00001097          	auipc	ra,0x1
    4ea4:	b7c080e7          	jalr	-1156(ra) # 5a1c <open>
    4ea8:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4eaa:	4481                	li	s1,0
    memset(buf, i, SZ);
    4eac:	00008917          	auipc	s2,0x8
    4eb0:	dbc90913          	addi	s2,s2,-580 # cc68 <buf>
  for(i = 0; i < N; i++){
    4eb4:	4a51                	li	s4,20
  if(fd < 0){
    4eb6:	0a054063          	bltz	a0,4f56 <bigfile+0xe6>
    memset(buf, i, SZ);
    4eba:	25800613          	li	a2,600
    4ebe:	85a6                	mv	a1,s1
    4ec0:	854a                	mv	a0,s2
    4ec2:	00001097          	auipc	ra,0x1
    4ec6:	920080e7          	jalr	-1760(ra) # 57e2 <memset>
    if(write(fd, buf, SZ) != SZ){
    4eca:	25800613          	li	a2,600
    4ece:	85ca                	mv	a1,s2
    4ed0:	854e                	mv	a0,s3
    4ed2:	00001097          	auipc	ra,0x1
    4ed6:	b2a080e7          	jalr	-1238(ra) # 59fc <write>
    4eda:	25800793          	li	a5,600
    4ede:	08f51a63          	bne	a0,a5,4f72 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4ee2:	2485                	addiw	s1,s1,1
    4ee4:	fd449be3          	bne	s1,s4,4eba <bigfile+0x4a>
  close(fd);
    4ee8:	854e                	mv	a0,s3
    4eea:	00001097          	auipc	ra,0x1
    4eee:	b1a080e7          	jalr	-1254(ra) # 5a04 <close>
  fd = open("bigfile.dat", 0);
    4ef2:	4581                	li	a1,0
    4ef4:	00003517          	auipc	a0,0x3
    4ef8:	d0450513          	addi	a0,a0,-764 # 7bf8 <malloc+0x1dd2>
    4efc:	00001097          	auipc	ra,0x1
    4f00:	b20080e7          	jalr	-1248(ra) # 5a1c <open>
    4f04:	8a2a                	mv	s4,a0
  total = 0;
    4f06:	4981                	li	s3,0
  for(i = 0; ; i++){
    4f08:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4f0a:	00008917          	auipc	s2,0x8
    4f0e:	d5e90913          	addi	s2,s2,-674 # cc68 <buf>
  if(fd < 0){
    4f12:	06054e63          	bltz	a0,4f8e <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4f16:	12c00613          	li	a2,300
    4f1a:	85ca                	mv	a1,s2
    4f1c:	8552                	mv	a0,s4
    4f1e:	00001097          	auipc	ra,0x1
    4f22:	ad6080e7          	jalr	-1322(ra) # 59f4 <read>
    if(cc < 0){
    4f26:	08054263          	bltz	a0,4faa <bigfile+0x13a>
    if(cc == 0)
    4f2a:	c971                	beqz	a0,4ffe <bigfile+0x18e>
    if(cc != SZ/2){
    4f2c:	12c00793          	li	a5,300
    4f30:	08f51b63          	bne	a0,a5,4fc6 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4f34:	01f4d79b          	srliw	a5,s1,0x1f
    4f38:	9fa5                	addw	a5,a5,s1
    4f3a:	4017d79b          	sraiw	a5,a5,0x1
    4f3e:	00094703          	lbu	a4,0(s2)
    4f42:	0af71063          	bne	a4,a5,4fe2 <bigfile+0x172>
    4f46:	12b94703          	lbu	a4,299(s2)
    4f4a:	08f71c63          	bne	a4,a5,4fe2 <bigfile+0x172>
    total += cc;
    4f4e:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4f52:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4f54:	b7c9                	j	4f16 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4f56:	85d6                	mv	a1,s5
    4f58:	00003517          	auipc	a0,0x3
    4f5c:	cb050513          	addi	a0,a0,-848 # 7c08 <malloc+0x1de2>
    4f60:	00001097          	auipc	ra,0x1
    4f64:	e0e080e7          	jalr	-498(ra) # 5d6e <printf>
    exit(1);
    4f68:	4505                	li	a0,1
    4f6a:	00001097          	auipc	ra,0x1
    4f6e:	a72080e7          	jalr	-1422(ra) # 59dc <exit>
      printf("%s: write bigfile failed\n", s);
    4f72:	85d6                	mv	a1,s5
    4f74:	00003517          	auipc	a0,0x3
    4f78:	cb450513          	addi	a0,a0,-844 # 7c28 <malloc+0x1e02>
    4f7c:	00001097          	auipc	ra,0x1
    4f80:	df2080e7          	jalr	-526(ra) # 5d6e <printf>
      exit(1);
    4f84:	4505                	li	a0,1
    4f86:	00001097          	auipc	ra,0x1
    4f8a:	a56080e7          	jalr	-1450(ra) # 59dc <exit>
    printf("%s: cannot open bigfile\n", s);
    4f8e:	85d6                	mv	a1,s5
    4f90:	00003517          	auipc	a0,0x3
    4f94:	cb850513          	addi	a0,a0,-840 # 7c48 <malloc+0x1e22>
    4f98:	00001097          	auipc	ra,0x1
    4f9c:	dd6080e7          	jalr	-554(ra) # 5d6e <printf>
    exit(1);
    4fa0:	4505                	li	a0,1
    4fa2:	00001097          	auipc	ra,0x1
    4fa6:	a3a080e7          	jalr	-1478(ra) # 59dc <exit>
      printf("%s: read bigfile failed\n", s);
    4faa:	85d6                	mv	a1,s5
    4fac:	00003517          	auipc	a0,0x3
    4fb0:	cbc50513          	addi	a0,a0,-836 # 7c68 <malloc+0x1e42>
    4fb4:	00001097          	auipc	ra,0x1
    4fb8:	dba080e7          	jalr	-582(ra) # 5d6e <printf>
      exit(1);
    4fbc:	4505                	li	a0,1
    4fbe:	00001097          	auipc	ra,0x1
    4fc2:	a1e080e7          	jalr	-1506(ra) # 59dc <exit>
      printf("%s: short read bigfile\n", s);
    4fc6:	85d6                	mv	a1,s5
    4fc8:	00003517          	auipc	a0,0x3
    4fcc:	cc050513          	addi	a0,a0,-832 # 7c88 <malloc+0x1e62>
    4fd0:	00001097          	auipc	ra,0x1
    4fd4:	d9e080e7          	jalr	-610(ra) # 5d6e <printf>
      exit(1);
    4fd8:	4505                	li	a0,1
    4fda:	00001097          	auipc	ra,0x1
    4fde:	a02080e7          	jalr	-1534(ra) # 59dc <exit>
      printf("%s: read bigfile wrong data\n", s);
    4fe2:	85d6                	mv	a1,s5
    4fe4:	00003517          	auipc	a0,0x3
    4fe8:	cbc50513          	addi	a0,a0,-836 # 7ca0 <malloc+0x1e7a>
    4fec:	00001097          	auipc	ra,0x1
    4ff0:	d82080e7          	jalr	-638(ra) # 5d6e <printf>
      exit(1);
    4ff4:	4505                	li	a0,1
    4ff6:	00001097          	auipc	ra,0x1
    4ffa:	9e6080e7          	jalr	-1562(ra) # 59dc <exit>
  close(fd);
    4ffe:	8552                	mv	a0,s4
    5000:	00001097          	auipc	ra,0x1
    5004:	a04080e7          	jalr	-1532(ra) # 5a04 <close>
  if(total != N*SZ){
    5008:	678d                	lui	a5,0x3
    500a:	ee078793          	addi	a5,a5,-288 # 2ee0 <diskfull+0x88>
    500e:	02f99363          	bne	s3,a5,5034 <bigfile+0x1c4>
  unlink("bigfile.dat");
    5012:	00003517          	auipc	a0,0x3
    5016:	be650513          	addi	a0,a0,-1050 # 7bf8 <malloc+0x1dd2>
    501a:	00001097          	auipc	ra,0x1
    501e:	a12080e7          	jalr	-1518(ra) # 5a2c <unlink>
}
    5022:	70e2                	ld	ra,56(sp)
    5024:	7442                	ld	s0,48(sp)
    5026:	74a2                	ld	s1,40(sp)
    5028:	7902                	ld	s2,32(sp)
    502a:	69e2                	ld	s3,24(sp)
    502c:	6a42                	ld	s4,16(sp)
    502e:	6aa2                	ld	s5,8(sp)
    5030:	6121                	addi	sp,sp,64
    5032:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5034:	85d6                	mv	a1,s5
    5036:	00003517          	auipc	a0,0x3
    503a:	c8a50513          	addi	a0,a0,-886 # 7cc0 <malloc+0x1e9a>
    503e:	00001097          	auipc	ra,0x1
    5042:	d30080e7          	jalr	-720(ra) # 5d6e <printf>
    exit(1);
    5046:	4505                	li	a0,1
    5048:	00001097          	auipc	ra,0x1
    504c:	994080e7          	jalr	-1644(ra) # 59dc <exit>

0000000000005050 <fsfull>:
{
    5050:	7171                	addi	sp,sp,-176
    5052:	f506                	sd	ra,168(sp)
    5054:	f122                	sd	s0,160(sp)
    5056:	ed26                	sd	s1,152(sp)
    5058:	e94a                	sd	s2,144(sp)
    505a:	e54e                	sd	s3,136(sp)
    505c:	e152                	sd	s4,128(sp)
    505e:	fcd6                	sd	s5,120(sp)
    5060:	f8da                	sd	s6,112(sp)
    5062:	f4de                	sd	s7,104(sp)
    5064:	f0e2                	sd	s8,96(sp)
    5066:	ece6                	sd	s9,88(sp)
    5068:	e8ea                	sd	s10,80(sp)
    506a:	e4ee                	sd	s11,72(sp)
    506c:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    506e:	00003517          	auipc	a0,0x3
    5072:	c7250513          	addi	a0,a0,-910 # 7ce0 <malloc+0x1eba>
    5076:	00001097          	auipc	ra,0x1
    507a:	cf8080e7          	jalr	-776(ra) # 5d6e <printf>
  for(nfiles = 0; ; nfiles++){
    507e:	4481                	li	s1,0
    name[0] = 'f';
    5080:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    5084:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5088:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    508c:	4b29                	li	s6,10
    printf("writing %s\n", name);
    508e:	00003c97          	auipc	s9,0x3
    5092:	c62c8c93          	addi	s9,s9,-926 # 7cf0 <malloc+0x1eca>
    int total = 0;
    5096:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    5098:	00008a17          	auipc	s4,0x8
    509c:	bd0a0a13          	addi	s4,s4,-1072 # cc68 <buf>
    name[0] = 'f';
    50a0:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    50a4:	0384c7bb          	divw	a5,s1,s8
    50a8:	0307879b          	addiw	a5,a5,48
    50ac:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    50b0:	0384e7bb          	remw	a5,s1,s8
    50b4:	0377c7bb          	divw	a5,a5,s7
    50b8:	0307879b          	addiw	a5,a5,48
    50bc:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    50c0:	0374e7bb          	remw	a5,s1,s7
    50c4:	0367c7bb          	divw	a5,a5,s6
    50c8:	0307879b          	addiw	a5,a5,48
    50cc:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    50d0:	0364e7bb          	remw	a5,s1,s6
    50d4:	0307879b          	addiw	a5,a5,48
    50d8:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    50dc:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    50e0:	f5040593          	addi	a1,s0,-176
    50e4:	8566                	mv	a0,s9
    50e6:	00001097          	auipc	ra,0x1
    50ea:	c88080e7          	jalr	-888(ra) # 5d6e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    50ee:	20200593          	li	a1,514
    50f2:	f5040513          	addi	a0,s0,-176
    50f6:	00001097          	auipc	ra,0x1
    50fa:	926080e7          	jalr	-1754(ra) # 5a1c <open>
    50fe:	892a                	mv	s2,a0
    if(fd < 0){
    5100:	0a055663          	bgez	a0,51ac <fsfull+0x15c>
      printf("open %s failed\n", name);
    5104:	f5040593          	addi	a1,s0,-176
    5108:	00003517          	auipc	a0,0x3
    510c:	bf850513          	addi	a0,a0,-1032 # 7d00 <malloc+0x1eda>
    5110:	00001097          	auipc	ra,0x1
    5114:	c5e080e7          	jalr	-930(ra) # 5d6e <printf>
  while(nfiles >= 0){
    5118:	0604c363          	bltz	s1,517e <fsfull+0x12e>
    name[0] = 'f';
    511c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5120:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5124:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5128:	4929                	li	s2,10
  while(nfiles >= 0){
    512a:	5afd                	li	s5,-1
    name[0] = 'f';
    512c:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5130:	0344c7bb          	divw	a5,s1,s4
    5134:	0307879b          	addiw	a5,a5,48
    5138:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    513c:	0344e7bb          	remw	a5,s1,s4
    5140:	0337c7bb          	divw	a5,a5,s3
    5144:	0307879b          	addiw	a5,a5,48
    5148:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    514c:	0334e7bb          	remw	a5,s1,s3
    5150:	0327c7bb          	divw	a5,a5,s2
    5154:	0307879b          	addiw	a5,a5,48
    5158:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    515c:	0324e7bb          	remw	a5,s1,s2
    5160:	0307879b          	addiw	a5,a5,48
    5164:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5168:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    516c:	f5040513          	addi	a0,s0,-176
    5170:	00001097          	auipc	ra,0x1
    5174:	8bc080e7          	jalr	-1860(ra) # 5a2c <unlink>
    nfiles--;
    5178:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    517a:	fb5499e3          	bne	s1,s5,512c <fsfull+0xdc>
  printf("fsfull test finished\n");
    517e:	00003517          	auipc	a0,0x3
    5182:	ba250513          	addi	a0,a0,-1118 # 7d20 <malloc+0x1efa>
    5186:	00001097          	auipc	ra,0x1
    518a:	be8080e7          	jalr	-1048(ra) # 5d6e <printf>
}
    518e:	70aa                	ld	ra,168(sp)
    5190:	740a                	ld	s0,160(sp)
    5192:	64ea                	ld	s1,152(sp)
    5194:	694a                	ld	s2,144(sp)
    5196:	69aa                	ld	s3,136(sp)
    5198:	6a0a                	ld	s4,128(sp)
    519a:	7ae6                	ld	s5,120(sp)
    519c:	7b46                	ld	s6,112(sp)
    519e:	7ba6                	ld	s7,104(sp)
    51a0:	7c06                	ld	s8,96(sp)
    51a2:	6ce6                	ld	s9,88(sp)
    51a4:	6d46                	ld	s10,80(sp)
    51a6:	6da6                	ld	s11,72(sp)
    51a8:	614d                	addi	sp,sp,176
    51aa:	8082                	ret
    int total = 0;
    51ac:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    51ae:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    51b2:	40000613          	li	a2,1024
    51b6:	85d2                	mv	a1,s4
    51b8:	854a                	mv	a0,s2
    51ba:	00001097          	auipc	ra,0x1
    51be:	842080e7          	jalr	-1982(ra) # 59fc <write>
      if(cc < BSIZE)
    51c2:	00aad563          	bge	s5,a0,51cc <fsfull+0x17c>
      total += cc;
    51c6:	00a989bb          	addw	s3,s3,a0
    while(1){
    51ca:	b7e5                	j	51b2 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    51cc:	85ce                	mv	a1,s3
    51ce:	00003517          	auipc	a0,0x3
    51d2:	b4250513          	addi	a0,a0,-1214 # 7d10 <malloc+0x1eea>
    51d6:	00001097          	auipc	ra,0x1
    51da:	b98080e7          	jalr	-1128(ra) # 5d6e <printf>
    close(fd);
    51de:	854a                	mv	a0,s2
    51e0:	00001097          	auipc	ra,0x1
    51e4:	824080e7          	jalr	-2012(ra) # 5a04 <close>
    if(total == 0)
    51e8:	f20988e3          	beqz	s3,5118 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    51ec:	2485                	addiw	s1,s1,1
    51ee:	bd4d                	j	50a0 <fsfull+0x50>

00000000000051f0 <bigdir>:
{
    51f0:	715d                	addi	sp,sp,-80
    51f2:	e486                	sd	ra,72(sp)
    51f4:	e0a2                	sd	s0,64(sp)
    51f6:	fc26                	sd	s1,56(sp)
    51f8:	f84a                	sd	s2,48(sp)
    51fa:	f44e                	sd	s3,40(sp)
    51fc:	f052                	sd	s4,32(sp)
    51fe:	ec56                	sd	s5,24(sp)
    5200:	e85a                	sd	s6,16(sp)
    5202:	0880                	addi	s0,sp,80
    5204:	89aa                	mv	s3,a0
  unlink("bd");
    5206:	00003517          	auipc	a0,0x3
    520a:	b3250513          	addi	a0,a0,-1230 # 7d38 <malloc+0x1f12>
    520e:	00001097          	auipc	ra,0x1
    5212:	81e080e7          	jalr	-2018(ra) # 5a2c <unlink>
  fd = open("bd", O_CREATE);
    5216:	20000593          	li	a1,512
    521a:	00003517          	auipc	a0,0x3
    521e:	b1e50513          	addi	a0,a0,-1250 # 7d38 <malloc+0x1f12>
    5222:	00000097          	auipc	ra,0x0
    5226:	7fa080e7          	jalr	2042(ra) # 5a1c <open>
  if(fd < 0){
    522a:	0c054963          	bltz	a0,52fc <bigdir+0x10c>
  close(fd);
    522e:	00000097          	auipc	ra,0x0
    5232:	7d6080e7          	jalr	2006(ra) # 5a04 <close>
  for(i = 0; i < N; i++){
    5236:	4901                	li	s2,0
    name[0] = 'x';
    5238:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    523c:	00003a17          	auipc	s4,0x3
    5240:	afca0a13          	addi	s4,s4,-1284 # 7d38 <malloc+0x1f12>
  for(i = 0; i < N; i++){
    5244:	1f400b13          	li	s6,500
    name[0] = 'x';
    5248:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    524c:	41f9571b          	sraiw	a4,s2,0x1f
    5250:	01a7571b          	srliw	a4,a4,0x1a
    5254:	012707bb          	addw	a5,a4,s2
    5258:	4067d69b          	sraiw	a3,a5,0x6
    525c:	0306869b          	addiw	a3,a3,48
    5260:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    5264:	03f7f793          	andi	a5,a5,63
    5268:	9f99                	subw	a5,a5,a4
    526a:	0307879b          	addiw	a5,a5,48
    526e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    5272:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    5276:	fb040593          	addi	a1,s0,-80
    527a:	8552                	mv	a0,s4
    527c:	00000097          	auipc	ra,0x0
    5280:	7c0080e7          	jalr	1984(ra) # 5a3c <link>
    5284:	84aa                	mv	s1,a0
    5286:	e949                	bnez	a0,5318 <bigdir+0x128>
  for(i = 0; i < N; i++){
    5288:	2905                	addiw	s2,s2,1
    528a:	fb691fe3          	bne	s2,s6,5248 <bigdir+0x58>
  unlink("bd");
    528e:	00003517          	auipc	a0,0x3
    5292:	aaa50513          	addi	a0,a0,-1366 # 7d38 <malloc+0x1f12>
    5296:	00000097          	auipc	ra,0x0
    529a:	796080e7          	jalr	1942(ra) # 5a2c <unlink>
    name[0] = 'x';
    529e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    52a2:	1f400a13          	li	s4,500
    name[0] = 'x';
    52a6:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    52aa:	41f4d71b          	sraiw	a4,s1,0x1f
    52ae:	01a7571b          	srliw	a4,a4,0x1a
    52b2:	009707bb          	addw	a5,a4,s1
    52b6:	4067d69b          	sraiw	a3,a5,0x6
    52ba:	0306869b          	addiw	a3,a3,48
    52be:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    52c2:	03f7f793          	andi	a5,a5,63
    52c6:	9f99                	subw	a5,a5,a4
    52c8:	0307879b          	addiw	a5,a5,48
    52cc:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    52d0:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    52d4:	fb040513          	addi	a0,s0,-80
    52d8:	00000097          	auipc	ra,0x0
    52dc:	754080e7          	jalr	1876(ra) # 5a2c <unlink>
    52e0:	ed21                	bnez	a0,5338 <bigdir+0x148>
  for(i = 0; i < N; i++){
    52e2:	2485                	addiw	s1,s1,1
    52e4:	fd4491e3          	bne	s1,s4,52a6 <bigdir+0xb6>
}
    52e8:	60a6                	ld	ra,72(sp)
    52ea:	6406                	ld	s0,64(sp)
    52ec:	74e2                	ld	s1,56(sp)
    52ee:	7942                	ld	s2,48(sp)
    52f0:	79a2                	ld	s3,40(sp)
    52f2:	7a02                	ld	s4,32(sp)
    52f4:	6ae2                	ld	s5,24(sp)
    52f6:	6b42                	ld	s6,16(sp)
    52f8:	6161                	addi	sp,sp,80
    52fa:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    52fc:	85ce                	mv	a1,s3
    52fe:	00003517          	auipc	a0,0x3
    5302:	a4250513          	addi	a0,a0,-1470 # 7d40 <malloc+0x1f1a>
    5306:	00001097          	auipc	ra,0x1
    530a:	a68080e7          	jalr	-1432(ra) # 5d6e <printf>
    exit(1);
    530e:	4505                	li	a0,1
    5310:	00000097          	auipc	ra,0x0
    5314:	6cc080e7          	jalr	1740(ra) # 59dc <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    5318:	fb040613          	addi	a2,s0,-80
    531c:	85ce                	mv	a1,s3
    531e:	00003517          	auipc	a0,0x3
    5322:	a4250513          	addi	a0,a0,-1470 # 7d60 <malloc+0x1f3a>
    5326:	00001097          	auipc	ra,0x1
    532a:	a48080e7          	jalr	-1464(ra) # 5d6e <printf>
      exit(1);
    532e:	4505                	li	a0,1
    5330:	00000097          	auipc	ra,0x0
    5334:	6ac080e7          	jalr	1708(ra) # 59dc <exit>
      printf("%s: bigdir unlink failed", s);
    5338:	85ce                	mv	a1,s3
    533a:	00003517          	auipc	a0,0x3
    533e:	a4650513          	addi	a0,a0,-1466 # 7d80 <malloc+0x1f5a>
    5342:	00001097          	auipc	ra,0x1
    5346:	a2c080e7          	jalr	-1492(ra) # 5d6e <printf>
      exit(1);
    534a:	4505                	li	a0,1
    534c:	00000097          	auipc	ra,0x0
    5350:	690080e7          	jalr	1680(ra) # 59dc <exit>

0000000000005354 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5354:	7179                	addi	sp,sp,-48
    5356:	f406                	sd	ra,40(sp)
    5358:	f022                	sd	s0,32(sp)
    535a:	ec26                	sd	s1,24(sp)
    535c:	e84a                	sd	s2,16(sp)
    535e:	1800                	addi	s0,sp,48
    5360:	84aa                	mv	s1,a0
    5362:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5364:	00003517          	auipc	a0,0x3
    5368:	a3c50513          	addi	a0,a0,-1476 # 7da0 <malloc+0x1f7a>
    536c:	00001097          	auipc	ra,0x1
    5370:	a02080e7          	jalr	-1534(ra) # 5d6e <printf>
  if((pid = fork()) < 0) {
    5374:	00000097          	auipc	ra,0x0
    5378:	660080e7          	jalr	1632(ra) # 59d4 <fork>
    537c:	02054e63          	bltz	a0,53b8 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5380:	c929                	beqz	a0,53d2 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5382:	fdc40513          	addi	a0,s0,-36
    5386:	00000097          	auipc	ra,0x0
    538a:	65e080e7          	jalr	1630(ra) # 59e4 <wait>
    if(xstatus != 0) 
    538e:	fdc42783          	lw	a5,-36(s0)
    5392:	c7b9                	beqz	a5,53e0 <run+0x8c>
      printf("FAILED\n");
    5394:	00003517          	auipc	a0,0x3
    5398:	a3450513          	addi	a0,a0,-1484 # 7dc8 <malloc+0x1fa2>
    539c:	00001097          	auipc	ra,0x1
    53a0:	9d2080e7          	jalr	-1582(ra) # 5d6e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    53a4:	fdc42503          	lw	a0,-36(s0)
  }
}
    53a8:	00153513          	seqz	a0,a0
    53ac:	70a2                	ld	ra,40(sp)
    53ae:	7402                	ld	s0,32(sp)
    53b0:	64e2                	ld	s1,24(sp)
    53b2:	6942                	ld	s2,16(sp)
    53b4:	6145                	addi	sp,sp,48
    53b6:	8082                	ret
    printf("runtest: fork error\n");
    53b8:	00003517          	auipc	a0,0x3
    53bc:	9f850513          	addi	a0,a0,-1544 # 7db0 <malloc+0x1f8a>
    53c0:	00001097          	auipc	ra,0x1
    53c4:	9ae080e7          	jalr	-1618(ra) # 5d6e <printf>
    exit(1);
    53c8:	4505                	li	a0,1
    53ca:	00000097          	auipc	ra,0x0
    53ce:	612080e7          	jalr	1554(ra) # 59dc <exit>
    f(s);
    53d2:	854a                	mv	a0,s2
    53d4:	9482                	jalr	s1
    exit(0);
    53d6:	4501                	li	a0,0
    53d8:	00000097          	auipc	ra,0x0
    53dc:	604080e7          	jalr	1540(ra) # 59dc <exit>
      printf("OK\n");
    53e0:	00003517          	auipc	a0,0x3
    53e4:	9f050513          	addi	a0,a0,-1552 # 7dd0 <malloc+0x1faa>
    53e8:	00001097          	auipc	ra,0x1
    53ec:	986080e7          	jalr	-1658(ra) # 5d6e <printf>
    53f0:	bf55                	j	53a4 <run+0x50>

00000000000053f2 <runtests>:

int
runtests(struct test *tests, char *justone) {
    53f2:	1101                	addi	sp,sp,-32
    53f4:	ec06                	sd	ra,24(sp)
    53f6:	e822                	sd	s0,16(sp)
    53f8:	e426                	sd	s1,8(sp)
    53fa:	e04a                	sd	s2,0(sp)
    53fc:	1000                	addi	s0,sp,32
    53fe:	84aa                	mv	s1,a0
    5400:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    5402:	6508                	ld	a0,8(a0)
    5404:	ed09                	bnez	a0,541e <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    5406:	4501                	li	a0,0
    5408:	a82d                	j	5442 <runtests+0x50>
      if(!run(t->f, t->s)){
    540a:	648c                	ld	a1,8(s1)
    540c:	6088                	ld	a0,0(s1)
    540e:	00000097          	auipc	ra,0x0
    5412:	f46080e7          	jalr	-186(ra) # 5354 <run>
    5416:	cd09                	beqz	a0,5430 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    5418:	04c1                	addi	s1,s1,16
    541a:	6488                	ld	a0,8(s1)
    541c:	c11d                	beqz	a0,5442 <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    541e:	fe0906e3          	beqz	s2,540a <runtests+0x18>
    5422:	85ca                	mv	a1,s2
    5424:	00000097          	auipc	ra,0x0
    5428:	368080e7          	jalr	872(ra) # 578c <strcmp>
    542c:	f575                	bnez	a0,5418 <runtests+0x26>
    542e:	bff1                	j	540a <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    5430:	00003517          	auipc	a0,0x3
    5434:	9a850513          	addi	a0,a0,-1624 # 7dd8 <malloc+0x1fb2>
    5438:	00001097          	auipc	ra,0x1
    543c:	936080e7          	jalr	-1738(ra) # 5d6e <printf>
        return 1;
    5440:	4505                	li	a0,1
}
    5442:	60e2                	ld	ra,24(sp)
    5444:	6442                	ld	s0,16(sp)
    5446:	64a2                	ld	s1,8(sp)
    5448:	6902                	ld	s2,0(sp)
    544a:	6105                	addi	sp,sp,32
    544c:	8082                	ret

000000000000544e <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    544e:	7139                	addi	sp,sp,-64
    5450:	fc06                	sd	ra,56(sp)
    5452:	f822                	sd	s0,48(sp)
    5454:	f426                	sd	s1,40(sp)
    5456:	f04a                	sd	s2,32(sp)
    5458:	ec4e                	sd	s3,24(sp)
    545a:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    545c:	fc840513          	addi	a0,s0,-56
    5460:	00000097          	auipc	ra,0x0
    5464:	58c080e7          	jalr	1420(ra) # 59ec <pipe>
    5468:	06054763          	bltz	a0,54d6 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    546c:	00000097          	auipc	ra,0x0
    5470:	568080e7          	jalr	1384(ra) # 59d4 <fork>

  if(pid < 0){
    5474:	06054e63          	bltz	a0,54f0 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5478:	ed51                	bnez	a0,5514 <countfree+0xc6>
    close(fds[0]);
    547a:	fc842503          	lw	a0,-56(s0)
    547e:	00000097          	auipc	ra,0x0
    5482:	586080e7          	jalr	1414(ra) # 5a04 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5486:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5488:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    548a:	00001997          	auipc	s3,0x1
    548e:	b2e98993          	addi	s3,s3,-1234 # 5fb8 <malloc+0x192>
      uint64 a = (uint64) sbrk(4096);
    5492:	6505                	lui	a0,0x1
    5494:	00000097          	auipc	ra,0x0
    5498:	5d0080e7          	jalr	1488(ra) # 5a64 <sbrk>
      if(a == 0xffffffffffffffff){
    549c:	07250763          	beq	a0,s2,550a <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    54a0:	6785                	lui	a5,0x1
    54a2:	97aa                	add	a5,a5,a0
    54a4:	fe978fa3          	sb	s1,-1(a5) # fff <validatetest+0x57>
      if(write(fds[1], "x", 1) != 1){
    54a8:	8626                	mv	a2,s1
    54aa:	85ce                	mv	a1,s3
    54ac:	fcc42503          	lw	a0,-52(s0)
    54b0:	00000097          	auipc	ra,0x0
    54b4:	54c080e7          	jalr	1356(ra) # 59fc <write>
    54b8:	fc950de3          	beq	a0,s1,5492 <countfree+0x44>
        printf("write() failed in countfree()\n");
    54bc:	00003517          	auipc	a0,0x3
    54c0:	97450513          	addi	a0,a0,-1676 # 7e30 <malloc+0x200a>
    54c4:	00001097          	auipc	ra,0x1
    54c8:	8aa080e7          	jalr	-1878(ra) # 5d6e <printf>
        exit(1);
    54cc:	4505                	li	a0,1
    54ce:	00000097          	auipc	ra,0x0
    54d2:	50e080e7          	jalr	1294(ra) # 59dc <exit>
    printf("pipe() failed in countfree()\n");
    54d6:	00003517          	auipc	a0,0x3
    54da:	91a50513          	addi	a0,a0,-1766 # 7df0 <malloc+0x1fca>
    54de:	00001097          	auipc	ra,0x1
    54e2:	890080e7          	jalr	-1904(ra) # 5d6e <printf>
    exit(1);
    54e6:	4505                	li	a0,1
    54e8:	00000097          	auipc	ra,0x0
    54ec:	4f4080e7          	jalr	1268(ra) # 59dc <exit>
    printf("fork failed in countfree()\n");
    54f0:	00003517          	auipc	a0,0x3
    54f4:	92050513          	addi	a0,a0,-1760 # 7e10 <malloc+0x1fea>
    54f8:	00001097          	auipc	ra,0x1
    54fc:	876080e7          	jalr	-1930(ra) # 5d6e <printf>
    exit(1);
    5500:	4505                	li	a0,1
    5502:	00000097          	auipc	ra,0x0
    5506:	4da080e7          	jalr	1242(ra) # 59dc <exit>
      }
    }

    exit(0);
    550a:	4501                	li	a0,0
    550c:	00000097          	auipc	ra,0x0
    5510:	4d0080e7          	jalr	1232(ra) # 59dc <exit>
  }

  close(fds[1]);
    5514:	fcc42503          	lw	a0,-52(s0)
    5518:	00000097          	auipc	ra,0x0
    551c:	4ec080e7          	jalr	1260(ra) # 5a04 <close>

  int n = 0;
    5520:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5522:	4605                	li	a2,1
    5524:	fc740593          	addi	a1,s0,-57
    5528:	fc842503          	lw	a0,-56(s0)
    552c:	00000097          	auipc	ra,0x0
    5530:	4c8080e7          	jalr	1224(ra) # 59f4 <read>
    if(cc < 0){
    5534:	00054563          	bltz	a0,553e <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5538:	c105                	beqz	a0,5558 <countfree+0x10a>
      break;
    n += 1;
    553a:	2485                	addiw	s1,s1,1
  while(1){
    553c:	b7dd                	j	5522 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    553e:	00003517          	auipc	a0,0x3
    5542:	91250513          	addi	a0,a0,-1774 # 7e50 <malloc+0x202a>
    5546:	00001097          	auipc	ra,0x1
    554a:	828080e7          	jalr	-2008(ra) # 5d6e <printf>
      exit(1);
    554e:	4505                	li	a0,1
    5550:	00000097          	auipc	ra,0x0
    5554:	48c080e7          	jalr	1164(ra) # 59dc <exit>
  }

  close(fds[0]);
    5558:	fc842503          	lw	a0,-56(s0)
    555c:	00000097          	auipc	ra,0x0
    5560:	4a8080e7          	jalr	1192(ra) # 5a04 <close>
  wait((int*)0);
    5564:	4501                	li	a0,0
    5566:	00000097          	auipc	ra,0x0
    556a:	47e080e7          	jalr	1150(ra) # 59e4 <wait>
  
  return n;
}
    556e:	8526                	mv	a0,s1
    5570:	70e2                	ld	ra,56(sp)
    5572:	7442                	ld	s0,48(sp)
    5574:	74a2                	ld	s1,40(sp)
    5576:	7902                	ld	s2,32(sp)
    5578:	69e2                	ld	s3,24(sp)
    557a:	6121                	addi	sp,sp,64
    557c:	8082                	ret

000000000000557e <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    557e:	711d                	addi	sp,sp,-96
    5580:	ec86                	sd	ra,88(sp)
    5582:	e8a2                	sd	s0,80(sp)
    5584:	e4a6                	sd	s1,72(sp)
    5586:	e0ca                	sd	s2,64(sp)
    5588:	fc4e                	sd	s3,56(sp)
    558a:	f852                	sd	s4,48(sp)
    558c:	f456                	sd	s5,40(sp)
    558e:	f05a                	sd	s6,32(sp)
    5590:	ec5e                	sd	s7,24(sp)
    5592:	e862                	sd	s8,16(sp)
    5594:	e466                	sd	s9,8(sp)
    5596:	e06a                	sd	s10,0(sp)
    5598:	1080                	addi	s0,sp,96
    559a:	8a2a                	mv	s4,a0
    559c:	89ae                	mv	s3,a1
    559e:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    55a0:	00003b97          	auipc	s7,0x3
    55a4:	8d0b8b93          	addi	s7,s7,-1840 # 7e70 <malloc+0x204a>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    55a8:	00004b17          	auipc	s6,0x4
    55ac:	a68b0b13          	addi	s6,s6,-1432 # 9010 <quicktests>
      if(continuous != 2) {
    55b0:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    55b2:	00003c97          	auipc	s9,0x3
    55b6:	8f6c8c93          	addi	s9,s9,-1802 # 7ea8 <malloc+0x2082>
      if (runtests(slowtests, justone)) {
    55ba:	00004c17          	auipc	s8,0x4
    55be:	e26c0c13          	addi	s8,s8,-474 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    55c2:	00003d17          	auipc	s10,0x3
    55c6:	8c6d0d13          	addi	s10,s10,-1850 # 7e88 <malloc+0x2062>
    55ca:	a839                	j	55e8 <drivetests+0x6a>
    55cc:	856a                	mv	a0,s10
    55ce:	00000097          	auipc	ra,0x0
    55d2:	7a0080e7          	jalr	1952(ra) # 5d6e <printf>
    55d6:	a081                	j	5616 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    55d8:	00000097          	auipc	ra,0x0
    55dc:	e76080e7          	jalr	-394(ra) # 544e <countfree>
    55e0:	06954263          	blt	a0,s1,5644 <drivetests+0xc6>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    55e4:	06098f63          	beqz	s3,5662 <drivetests+0xe4>
    printf("usertests starting\n");
    55e8:	855e                	mv	a0,s7
    55ea:	00000097          	auipc	ra,0x0
    55ee:	784080e7          	jalr	1924(ra) # 5d6e <printf>
    int free0 = countfree();
    55f2:	00000097          	auipc	ra,0x0
    55f6:	e5c080e7          	jalr	-420(ra) # 544e <countfree>
    55fa:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    55fc:	85ca                	mv	a1,s2
    55fe:	855a                	mv	a0,s6
    5600:	00000097          	auipc	ra,0x0
    5604:	df2080e7          	jalr	-526(ra) # 53f2 <runtests>
    5608:	c119                	beqz	a0,560e <drivetests+0x90>
      if(continuous != 2) {
    560a:	05599863          	bne	s3,s5,565a <drivetests+0xdc>
    if(!quick) {
    560e:	fc0a15e3          	bnez	s4,55d8 <drivetests+0x5a>
      if (justone == 0)
    5612:	fa090de3          	beqz	s2,55cc <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    5616:	85ca                	mv	a1,s2
    5618:	8562                	mv	a0,s8
    561a:	00000097          	auipc	ra,0x0
    561e:	dd8080e7          	jalr	-552(ra) # 53f2 <runtests>
    5622:	d95d                	beqz	a0,55d8 <drivetests+0x5a>
        if(continuous != 2) {
    5624:	03599d63          	bne	s3,s5,565e <drivetests+0xe0>
    if((free1 = countfree()) < free0) {
    5628:	00000097          	auipc	ra,0x0
    562c:	e26080e7          	jalr	-474(ra) # 544e <countfree>
    5630:	fa955ae3          	bge	a0,s1,55e4 <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5634:	8626                	mv	a2,s1
    5636:	85aa                	mv	a1,a0
    5638:	8566                	mv	a0,s9
    563a:	00000097          	auipc	ra,0x0
    563e:	734080e7          	jalr	1844(ra) # 5d6e <printf>
      if(continuous != 2) {
    5642:	b75d                	j	55e8 <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5644:	8626                	mv	a2,s1
    5646:	85aa                	mv	a1,a0
    5648:	8566                	mv	a0,s9
    564a:	00000097          	auipc	ra,0x0
    564e:	724080e7          	jalr	1828(ra) # 5d6e <printf>
      if(continuous != 2) {
    5652:	f9598be3          	beq	s3,s5,55e8 <drivetests+0x6a>
        return 1;
    5656:	4505                	li	a0,1
    5658:	a031                	j	5664 <drivetests+0xe6>
        return 1;
    565a:	4505                	li	a0,1
    565c:	a021                	j	5664 <drivetests+0xe6>
          return 1;
    565e:	4505                	li	a0,1
    5660:	a011                	j	5664 <drivetests+0xe6>
  return 0;
    5662:	854e                	mv	a0,s3
}
    5664:	60e6                	ld	ra,88(sp)
    5666:	6446                	ld	s0,80(sp)
    5668:	64a6                	ld	s1,72(sp)
    566a:	6906                	ld	s2,64(sp)
    566c:	79e2                	ld	s3,56(sp)
    566e:	7a42                	ld	s4,48(sp)
    5670:	7aa2                	ld	s5,40(sp)
    5672:	7b02                	ld	s6,32(sp)
    5674:	6be2                	ld	s7,24(sp)
    5676:	6c42                	ld	s8,16(sp)
    5678:	6ca2                	ld	s9,8(sp)
    567a:	6d02                	ld	s10,0(sp)
    567c:	6125                	addi	sp,sp,96
    567e:	8082                	ret

0000000000005680 <main>:

int
main(int argc, char *argv[])
{
    5680:	1101                	addi	sp,sp,-32
    5682:	ec06                	sd	ra,24(sp)
    5684:	e822                	sd	s0,16(sp)
    5686:	e426                	sd	s1,8(sp)
    5688:	e04a                	sd	s2,0(sp)
    568a:	1000                	addi	s0,sp,32
    568c:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    568e:	4789                	li	a5,2
    5690:	02f50263          	beq	a0,a5,56b4 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5694:	4785                	li	a5,1
    5696:	06a7cd63          	blt	a5,a0,5710 <main+0x90>
  char *justone = 0;
    569a:	4601                	li	a2,0
  int quick = 0;
    569c:	4501                	li	a0,0
  int continuous = 0;
    569e:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    56a0:	00000097          	auipc	ra,0x0
    56a4:	ede080e7          	jalr	-290(ra) # 557e <drivetests>
    56a8:	c951                	beqz	a0,573c <main+0xbc>
    exit(1);
    56aa:	4505                	li	a0,1
    56ac:	00000097          	auipc	ra,0x0
    56b0:	330080e7          	jalr	816(ra) # 59dc <exit>
    56b4:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    56b6:	00003597          	auipc	a1,0x3
    56ba:	82258593          	addi	a1,a1,-2014 # 7ed8 <malloc+0x20b2>
    56be:	00893503          	ld	a0,8(s2)
    56c2:	00000097          	auipc	ra,0x0
    56c6:	0ca080e7          	jalr	202(ra) # 578c <strcmp>
    56ca:	85aa                	mv	a1,a0
    56cc:	cd39                	beqz	a0,572a <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    56ce:	00003597          	auipc	a1,0x3
    56d2:	86258593          	addi	a1,a1,-1950 # 7f30 <malloc+0x210a>
    56d6:	00893503          	ld	a0,8(s2)
    56da:	00000097          	auipc	ra,0x0
    56de:	0b2080e7          	jalr	178(ra) # 578c <strcmp>
    56e2:	c931                	beqz	a0,5736 <main+0xb6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    56e4:	00003597          	auipc	a1,0x3
    56e8:	84458593          	addi	a1,a1,-1980 # 7f28 <malloc+0x2102>
    56ec:	00893503          	ld	a0,8(s2)
    56f0:	00000097          	auipc	ra,0x0
    56f4:	09c080e7          	jalr	156(ra) # 578c <strcmp>
    56f8:	cd05                	beqz	a0,5730 <main+0xb0>
  } else if(argc == 2 && argv[1][0] != '-'){
    56fa:	00893603          	ld	a2,8(s2)
    56fe:	00064703          	lbu	a4,0(a2) # 3000 <diskfull+0x1a8>
    5702:	02d00793          	li	a5,45
    5706:	00f70563          	beq	a4,a5,5710 <main+0x90>
  int quick = 0;
    570a:	4501                	li	a0,0
  int continuous = 0;
    570c:	4581                	li	a1,0
    570e:	bf49                	j	56a0 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5710:	00002517          	auipc	a0,0x2
    5714:	7d050513          	addi	a0,a0,2000 # 7ee0 <malloc+0x20ba>
    5718:	00000097          	auipc	ra,0x0
    571c:	656080e7          	jalr	1622(ra) # 5d6e <printf>
    exit(1);
    5720:	4505                	li	a0,1
    5722:	00000097          	auipc	ra,0x0
    5726:	2ba080e7          	jalr	698(ra) # 59dc <exit>
  char *justone = 0;
    572a:	4601                	li	a2,0
    quick = 1;
    572c:	4505                	li	a0,1
    572e:	bf8d                	j	56a0 <main+0x20>
    continuous = 2;
    5730:	85a6                	mv	a1,s1
  char *justone = 0;
    5732:	4601                	li	a2,0
    5734:	b7b5                	j	56a0 <main+0x20>
    5736:	4601                	li	a2,0
    continuous = 1;
    5738:	4585                	li	a1,1
    573a:	b79d                	j	56a0 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    573c:	00002517          	auipc	a0,0x2
    5740:	7d450513          	addi	a0,a0,2004 # 7f10 <malloc+0x20ea>
    5744:	00000097          	auipc	ra,0x0
    5748:	62a080e7          	jalr	1578(ra) # 5d6e <printf>
  exit(0);
    574c:	4501                	li	a0,0
    574e:	00000097          	auipc	ra,0x0
    5752:	28e080e7          	jalr	654(ra) # 59dc <exit>

0000000000005756 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5756:	1141                	addi	sp,sp,-16
    5758:	e406                	sd	ra,8(sp)
    575a:	e022                	sd	s0,0(sp)
    575c:	0800                	addi	s0,sp,16
  extern int main();
  main();
    575e:	00000097          	auipc	ra,0x0
    5762:	f22080e7          	jalr	-222(ra) # 5680 <main>
  exit(0);
    5766:	4501                	li	a0,0
    5768:	00000097          	auipc	ra,0x0
    576c:	274080e7          	jalr	628(ra) # 59dc <exit>

0000000000005770 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5770:	1141                	addi	sp,sp,-16
    5772:	e422                	sd	s0,8(sp)
    5774:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5776:	87aa                	mv	a5,a0
    5778:	0585                	addi	a1,a1,1
    577a:	0785                	addi	a5,a5,1
    577c:	fff5c703          	lbu	a4,-1(a1)
    5780:	fee78fa3          	sb	a4,-1(a5)
    5784:	fb75                	bnez	a4,5778 <strcpy+0x8>
    ;
  return os;
}
    5786:	6422                	ld	s0,8(sp)
    5788:	0141                	addi	sp,sp,16
    578a:	8082                	ret

000000000000578c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    578c:	1141                	addi	sp,sp,-16
    578e:	e422                	sd	s0,8(sp)
    5790:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5792:	00054783          	lbu	a5,0(a0)
    5796:	cb91                	beqz	a5,57aa <strcmp+0x1e>
    5798:	0005c703          	lbu	a4,0(a1)
    579c:	00f71763          	bne	a4,a5,57aa <strcmp+0x1e>
    p++, q++;
    57a0:	0505                	addi	a0,a0,1
    57a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    57a4:	00054783          	lbu	a5,0(a0)
    57a8:	fbe5                	bnez	a5,5798 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    57aa:	0005c503          	lbu	a0,0(a1)
}
    57ae:	40a7853b          	subw	a0,a5,a0
    57b2:	6422                	ld	s0,8(sp)
    57b4:	0141                	addi	sp,sp,16
    57b6:	8082                	ret

00000000000057b8 <strlen>:

uint
strlen(const char *s)
{
    57b8:	1141                	addi	sp,sp,-16
    57ba:	e422                	sd	s0,8(sp)
    57bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    57be:	00054783          	lbu	a5,0(a0)
    57c2:	cf91                	beqz	a5,57de <strlen+0x26>
    57c4:	0505                	addi	a0,a0,1
    57c6:	87aa                	mv	a5,a0
    57c8:	4685                	li	a3,1
    57ca:	9e89                	subw	a3,a3,a0
    57cc:	00f6853b          	addw	a0,a3,a5
    57d0:	0785                	addi	a5,a5,1
    57d2:	fff7c703          	lbu	a4,-1(a5)
    57d6:	fb7d                	bnez	a4,57cc <strlen+0x14>
    ;
  return n;
}
    57d8:	6422                	ld	s0,8(sp)
    57da:	0141                	addi	sp,sp,16
    57dc:	8082                	ret
  for(n = 0; s[n]; n++)
    57de:	4501                	li	a0,0
    57e0:	bfe5                	j	57d8 <strlen+0x20>

00000000000057e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
    57e2:	1141                	addi	sp,sp,-16
    57e4:	e422                	sd	s0,8(sp)
    57e6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    57e8:	ca19                	beqz	a2,57fe <memset+0x1c>
    57ea:	87aa                	mv	a5,a0
    57ec:	1602                	slli	a2,a2,0x20
    57ee:	9201                	srli	a2,a2,0x20
    57f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    57f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    57f8:	0785                	addi	a5,a5,1
    57fa:	fee79de3          	bne	a5,a4,57f4 <memset+0x12>
  }
  return dst;
}
    57fe:	6422                	ld	s0,8(sp)
    5800:	0141                	addi	sp,sp,16
    5802:	8082                	ret

0000000000005804 <strchr>:

char*
strchr(const char *s, char c)
{
    5804:	1141                	addi	sp,sp,-16
    5806:	e422                	sd	s0,8(sp)
    5808:	0800                	addi	s0,sp,16
  for(; *s; s++)
    580a:	00054783          	lbu	a5,0(a0)
    580e:	cb99                	beqz	a5,5824 <strchr+0x20>
    if(*s == c)
    5810:	00f58763          	beq	a1,a5,581e <strchr+0x1a>
  for(; *s; s++)
    5814:	0505                	addi	a0,a0,1
    5816:	00054783          	lbu	a5,0(a0)
    581a:	fbfd                	bnez	a5,5810 <strchr+0xc>
      return (char*)s;
  return 0;
    581c:	4501                	li	a0,0
}
    581e:	6422                	ld	s0,8(sp)
    5820:	0141                	addi	sp,sp,16
    5822:	8082                	ret
  return 0;
    5824:	4501                	li	a0,0
    5826:	bfe5                	j	581e <strchr+0x1a>

0000000000005828 <gets>:

char*
gets(char *buf, int max)
{
    5828:	711d                	addi	sp,sp,-96
    582a:	ec86                	sd	ra,88(sp)
    582c:	e8a2                	sd	s0,80(sp)
    582e:	e4a6                	sd	s1,72(sp)
    5830:	e0ca                	sd	s2,64(sp)
    5832:	fc4e                	sd	s3,56(sp)
    5834:	f852                	sd	s4,48(sp)
    5836:	f456                	sd	s5,40(sp)
    5838:	f05a                	sd	s6,32(sp)
    583a:	ec5e                	sd	s7,24(sp)
    583c:	1080                	addi	s0,sp,96
    583e:	8baa                	mv	s7,a0
    5840:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5842:	892a                	mv	s2,a0
    5844:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5846:	4aa9                	li	s5,10
    5848:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    584a:	89a6                	mv	s3,s1
    584c:	2485                	addiw	s1,s1,1
    584e:	0344d863          	bge	s1,s4,587e <gets+0x56>
    cc = read(0, &c, 1);
    5852:	4605                	li	a2,1
    5854:	faf40593          	addi	a1,s0,-81
    5858:	4501                	li	a0,0
    585a:	00000097          	auipc	ra,0x0
    585e:	19a080e7          	jalr	410(ra) # 59f4 <read>
    if(cc < 1)
    5862:	00a05e63          	blez	a0,587e <gets+0x56>
    buf[i++] = c;
    5866:	faf44783          	lbu	a5,-81(s0)
    586a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    586e:	01578763          	beq	a5,s5,587c <gets+0x54>
    5872:	0905                	addi	s2,s2,1
    5874:	fd679be3          	bne	a5,s6,584a <gets+0x22>
  for(i=0; i+1 < max; ){
    5878:	89a6                	mv	s3,s1
    587a:	a011                	j	587e <gets+0x56>
    587c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    587e:	99de                	add	s3,s3,s7
    5880:	00098023          	sb	zero,0(s3)
  return buf;
}
    5884:	855e                	mv	a0,s7
    5886:	60e6                	ld	ra,88(sp)
    5888:	6446                	ld	s0,80(sp)
    588a:	64a6                	ld	s1,72(sp)
    588c:	6906                	ld	s2,64(sp)
    588e:	79e2                	ld	s3,56(sp)
    5890:	7a42                	ld	s4,48(sp)
    5892:	7aa2                	ld	s5,40(sp)
    5894:	7b02                	ld	s6,32(sp)
    5896:	6be2                	ld	s7,24(sp)
    5898:	6125                	addi	sp,sp,96
    589a:	8082                	ret

000000000000589c <stat>:

int
stat(const char *n, struct stat *st)
{
    589c:	1101                	addi	sp,sp,-32
    589e:	ec06                	sd	ra,24(sp)
    58a0:	e822                	sd	s0,16(sp)
    58a2:	e426                	sd	s1,8(sp)
    58a4:	e04a                	sd	s2,0(sp)
    58a6:	1000                	addi	s0,sp,32
    58a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    58aa:	4581                	li	a1,0
    58ac:	00000097          	auipc	ra,0x0
    58b0:	170080e7          	jalr	368(ra) # 5a1c <open>
  if(fd < 0)
    58b4:	02054563          	bltz	a0,58de <stat+0x42>
    58b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    58ba:	85ca                	mv	a1,s2
    58bc:	00000097          	auipc	ra,0x0
    58c0:	178080e7          	jalr	376(ra) # 5a34 <fstat>
    58c4:	892a                	mv	s2,a0
  close(fd);
    58c6:	8526                	mv	a0,s1
    58c8:	00000097          	auipc	ra,0x0
    58cc:	13c080e7          	jalr	316(ra) # 5a04 <close>
  return r;
}
    58d0:	854a                	mv	a0,s2
    58d2:	60e2                	ld	ra,24(sp)
    58d4:	6442                	ld	s0,16(sp)
    58d6:	64a2                	ld	s1,8(sp)
    58d8:	6902                	ld	s2,0(sp)
    58da:	6105                	addi	sp,sp,32
    58dc:	8082                	ret
    return -1;
    58de:	597d                	li	s2,-1
    58e0:	bfc5                	j	58d0 <stat+0x34>

00000000000058e2 <atoi>:

int
atoi(const char *s)
{
    58e2:	1141                	addi	sp,sp,-16
    58e4:	e422                	sd	s0,8(sp)
    58e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    58e8:	00054683          	lbu	a3,0(a0)
    58ec:	fd06879b          	addiw	a5,a3,-48
    58f0:	0ff7f793          	zext.b	a5,a5
    58f4:	4625                	li	a2,9
    58f6:	02f66863          	bltu	a2,a5,5926 <atoi+0x44>
    58fa:	872a                	mv	a4,a0
  n = 0;
    58fc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    58fe:	0705                	addi	a4,a4,1
    5900:	0025179b          	slliw	a5,a0,0x2
    5904:	9fa9                	addw	a5,a5,a0
    5906:	0017979b          	slliw	a5,a5,0x1
    590a:	9fb5                	addw	a5,a5,a3
    590c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5910:	00074683          	lbu	a3,0(a4)
    5914:	fd06879b          	addiw	a5,a3,-48
    5918:	0ff7f793          	zext.b	a5,a5
    591c:	fef671e3          	bgeu	a2,a5,58fe <atoi+0x1c>
  return n;
}
    5920:	6422                	ld	s0,8(sp)
    5922:	0141                	addi	sp,sp,16
    5924:	8082                	ret
  n = 0;
    5926:	4501                	li	a0,0
    5928:	bfe5                	j	5920 <atoi+0x3e>

000000000000592a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    592a:	1141                	addi	sp,sp,-16
    592c:	e422                	sd	s0,8(sp)
    592e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5930:	02b57463          	bgeu	a0,a1,5958 <memmove+0x2e>
    while(n-- > 0)
    5934:	00c05f63          	blez	a2,5952 <memmove+0x28>
    5938:	1602                	slli	a2,a2,0x20
    593a:	9201                	srli	a2,a2,0x20
    593c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5940:	872a                	mv	a4,a0
      *dst++ = *src++;
    5942:	0585                	addi	a1,a1,1
    5944:	0705                	addi	a4,a4,1
    5946:	fff5c683          	lbu	a3,-1(a1)
    594a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    594e:	fee79ae3          	bne	a5,a4,5942 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5952:	6422                	ld	s0,8(sp)
    5954:	0141                	addi	sp,sp,16
    5956:	8082                	ret
    dst += n;
    5958:	00c50733          	add	a4,a0,a2
    src += n;
    595c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    595e:	fec05ae3          	blez	a2,5952 <memmove+0x28>
    5962:	fff6079b          	addiw	a5,a2,-1
    5966:	1782                	slli	a5,a5,0x20
    5968:	9381                	srli	a5,a5,0x20
    596a:	fff7c793          	not	a5,a5
    596e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5970:	15fd                	addi	a1,a1,-1
    5972:	177d                	addi	a4,a4,-1
    5974:	0005c683          	lbu	a3,0(a1)
    5978:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    597c:	fee79ae3          	bne	a5,a4,5970 <memmove+0x46>
    5980:	bfc9                	j	5952 <memmove+0x28>

0000000000005982 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5982:	1141                	addi	sp,sp,-16
    5984:	e422                	sd	s0,8(sp)
    5986:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5988:	ca05                	beqz	a2,59b8 <memcmp+0x36>
    598a:	fff6069b          	addiw	a3,a2,-1
    598e:	1682                	slli	a3,a3,0x20
    5990:	9281                	srli	a3,a3,0x20
    5992:	0685                	addi	a3,a3,1
    5994:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5996:	00054783          	lbu	a5,0(a0)
    599a:	0005c703          	lbu	a4,0(a1)
    599e:	00e79863          	bne	a5,a4,59ae <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    59a2:	0505                	addi	a0,a0,1
    p2++;
    59a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    59a6:	fed518e3          	bne	a0,a3,5996 <memcmp+0x14>
  }
  return 0;
    59aa:	4501                	li	a0,0
    59ac:	a019                	j	59b2 <memcmp+0x30>
      return *p1 - *p2;
    59ae:	40e7853b          	subw	a0,a5,a4
}
    59b2:	6422                	ld	s0,8(sp)
    59b4:	0141                	addi	sp,sp,16
    59b6:	8082                	ret
  return 0;
    59b8:	4501                	li	a0,0
    59ba:	bfe5                	j	59b2 <memcmp+0x30>

00000000000059bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    59bc:	1141                	addi	sp,sp,-16
    59be:	e406                	sd	ra,8(sp)
    59c0:	e022                	sd	s0,0(sp)
    59c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    59c4:	00000097          	auipc	ra,0x0
    59c8:	f66080e7          	jalr	-154(ra) # 592a <memmove>
}
    59cc:	60a2                	ld	ra,8(sp)
    59ce:	6402                	ld	s0,0(sp)
    59d0:	0141                	addi	sp,sp,16
    59d2:	8082                	ret

00000000000059d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    59d4:	4885                	li	a7,1
 ecall
    59d6:	00000073          	ecall
 ret
    59da:	8082                	ret

00000000000059dc <exit>:
.global exit
exit:
 li a7, SYS_exit
    59dc:	4889                	li	a7,2
 ecall
    59de:	00000073          	ecall
 ret
    59e2:	8082                	ret

00000000000059e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
    59e4:	488d                	li	a7,3
 ecall
    59e6:	00000073          	ecall
 ret
    59ea:	8082                	ret

00000000000059ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    59ec:	4891                	li	a7,4
 ecall
    59ee:	00000073          	ecall
 ret
    59f2:	8082                	ret

00000000000059f4 <read>:
.global read
read:
 li a7, SYS_read
    59f4:	4895                	li	a7,5
 ecall
    59f6:	00000073          	ecall
 ret
    59fa:	8082                	ret

00000000000059fc <write>:
.global write
write:
 li a7, SYS_write
    59fc:	48c1                	li	a7,16
 ecall
    59fe:	00000073          	ecall
 ret
    5a02:	8082                	ret

0000000000005a04 <close>:
.global close
close:
 li a7, SYS_close
    5a04:	48d5                	li	a7,21
 ecall
    5a06:	00000073          	ecall
 ret
    5a0a:	8082                	ret

0000000000005a0c <kill>:
.global kill
kill:
 li a7, SYS_kill
    5a0c:	4899                	li	a7,6
 ecall
    5a0e:	00000073          	ecall
 ret
    5a12:	8082                	ret

0000000000005a14 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5a14:	489d                	li	a7,7
 ecall
    5a16:	00000073          	ecall
 ret
    5a1a:	8082                	ret

0000000000005a1c <open>:
.global open
open:
 li a7, SYS_open
    5a1c:	48bd                	li	a7,15
 ecall
    5a1e:	00000073          	ecall
 ret
    5a22:	8082                	ret

0000000000005a24 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5a24:	48c5                	li	a7,17
 ecall
    5a26:	00000073          	ecall
 ret
    5a2a:	8082                	ret

0000000000005a2c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5a2c:	48c9                	li	a7,18
 ecall
    5a2e:	00000073          	ecall
 ret
    5a32:	8082                	ret

0000000000005a34 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5a34:	48a1                	li	a7,8
 ecall
    5a36:	00000073          	ecall
 ret
    5a3a:	8082                	ret

0000000000005a3c <link>:
.global link
link:
 li a7, SYS_link
    5a3c:	48cd                	li	a7,19
 ecall
    5a3e:	00000073          	ecall
 ret
    5a42:	8082                	ret

0000000000005a44 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5a44:	48d1                	li	a7,20
 ecall
    5a46:	00000073          	ecall
 ret
    5a4a:	8082                	ret

0000000000005a4c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5a4c:	48a5                	li	a7,9
 ecall
    5a4e:	00000073          	ecall
 ret
    5a52:	8082                	ret

0000000000005a54 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5a54:	48a9                	li	a7,10
 ecall
    5a56:	00000073          	ecall
 ret
    5a5a:	8082                	ret

0000000000005a5c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5a5c:	48ad                	li	a7,11
 ecall
    5a5e:	00000073          	ecall
 ret
    5a62:	8082                	ret

0000000000005a64 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5a64:	48b1                	li	a7,12
 ecall
    5a66:	00000073          	ecall
 ret
    5a6a:	8082                	ret

0000000000005a6c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5a6c:	48b5                	li	a7,13
 ecall
    5a6e:	00000073          	ecall
 ret
    5a72:	8082                	ret

0000000000005a74 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5a74:	48b9                	li	a7,14
 ecall
    5a76:	00000073          	ecall
 ret
    5a7a:	8082                	ret

0000000000005a7c <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5a7c:	48d9                	li	a7,22
 ecall
    5a7e:	00000073          	ecall
 ret
    5a82:	8082                	ret

0000000000005a84 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
    5a84:	48dd                	li	a7,23
 ecall
    5a86:	00000073          	ecall
 ret
    5a8a:	8082                	ret

0000000000005a8c <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
    5a8c:	48e1                	li	a7,24
 ecall
    5a8e:	00000073          	ecall
 ret
    5a92:	8082                	ret

0000000000005a94 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5a94:	1101                	addi	sp,sp,-32
    5a96:	ec06                	sd	ra,24(sp)
    5a98:	e822                	sd	s0,16(sp)
    5a9a:	1000                	addi	s0,sp,32
    5a9c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5aa0:	4605                	li	a2,1
    5aa2:	fef40593          	addi	a1,s0,-17
    5aa6:	00000097          	auipc	ra,0x0
    5aaa:	f56080e7          	jalr	-170(ra) # 59fc <write>
}
    5aae:	60e2                	ld	ra,24(sp)
    5ab0:	6442                	ld	s0,16(sp)
    5ab2:	6105                	addi	sp,sp,32
    5ab4:	8082                	ret

0000000000005ab6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5ab6:	7139                	addi	sp,sp,-64
    5ab8:	fc06                	sd	ra,56(sp)
    5aba:	f822                	sd	s0,48(sp)
    5abc:	f426                	sd	s1,40(sp)
    5abe:	f04a                	sd	s2,32(sp)
    5ac0:	ec4e                	sd	s3,24(sp)
    5ac2:	0080                	addi	s0,sp,64
    5ac4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5ac6:	c299                	beqz	a3,5acc <printint+0x16>
    5ac8:	0805c963          	bltz	a1,5b5a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5acc:	2581                	sext.w	a1,a1
  neg = 0;
    5ace:	4881                	li	a7,0
    5ad0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5ad4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5ad6:	2601                	sext.w	a2,a2
    5ad8:	00003517          	auipc	a0,0x3
    5adc:	81850513          	addi	a0,a0,-2024 # 82f0 <digits>
    5ae0:	883a                	mv	a6,a4
    5ae2:	2705                	addiw	a4,a4,1
    5ae4:	02c5f7bb          	remuw	a5,a1,a2
    5ae8:	1782                	slli	a5,a5,0x20
    5aea:	9381                	srli	a5,a5,0x20
    5aec:	97aa                	add	a5,a5,a0
    5aee:	0007c783          	lbu	a5,0(a5)
    5af2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5af6:	0005879b          	sext.w	a5,a1
    5afa:	02c5d5bb          	divuw	a1,a1,a2
    5afe:	0685                	addi	a3,a3,1
    5b00:	fec7f0e3          	bgeu	a5,a2,5ae0 <printint+0x2a>
  if(neg)
    5b04:	00088c63          	beqz	a7,5b1c <printint+0x66>
    buf[i++] = '-';
    5b08:	fd070793          	addi	a5,a4,-48
    5b0c:	00878733          	add	a4,a5,s0
    5b10:	02d00793          	li	a5,45
    5b14:	fef70823          	sb	a5,-16(a4)
    5b18:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5b1c:	02e05863          	blez	a4,5b4c <printint+0x96>
    5b20:	fc040793          	addi	a5,s0,-64
    5b24:	00e78933          	add	s2,a5,a4
    5b28:	fff78993          	addi	s3,a5,-1
    5b2c:	99ba                	add	s3,s3,a4
    5b2e:	377d                	addiw	a4,a4,-1
    5b30:	1702                	slli	a4,a4,0x20
    5b32:	9301                	srli	a4,a4,0x20
    5b34:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5b38:	fff94583          	lbu	a1,-1(s2)
    5b3c:	8526                	mv	a0,s1
    5b3e:	00000097          	auipc	ra,0x0
    5b42:	f56080e7          	jalr	-170(ra) # 5a94 <putc>
  while(--i >= 0)
    5b46:	197d                	addi	s2,s2,-1
    5b48:	ff3918e3          	bne	s2,s3,5b38 <printint+0x82>
}
    5b4c:	70e2                	ld	ra,56(sp)
    5b4e:	7442                	ld	s0,48(sp)
    5b50:	74a2                	ld	s1,40(sp)
    5b52:	7902                	ld	s2,32(sp)
    5b54:	69e2                	ld	s3,24(sp)
    5b56:	6121                	addi	sp,sp,64
    5b58:	8082                	ret
    x = -xx;
    5b5a:	40b005bb          	negw	a1,a1
    neg = 1;
    5b5e:	4885                	li	a7,1
    x = -xx;
    5b60:	bf85                	j	5ad0 <printint+0x1a>

0000000000005b62 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5b62:	7119                	addi	sp,sp,-128
    5b64:	fc86                	sd	ra,120(sp)
    5b66:	f8a2                	sd	s0,112(sp)
    5b68:	f4a6                	sd	s1,104(sp)
    5b6a:	f0ca                	sd	s2,96(sp)
    5b6c:	ecce                	sd	s3,88(sp)
    5b6e:	e8d2                	sd	s4,80(sp)
    5b70:	e4d6                	sd	s5,72(sp)
    5b72:	e0da                	sd	s6,64(sp)
    5b74:	fc5e                	sd	s7,56(sp)
    5b76:	f862                	sd	s8,48(sp)
    5b78:	f466                	sd	s9,40(sp)
    5b7a:	f06a                	sd	s10,32(sp)
    5b7c:	ec6e                	sd	s11,24(sp)
    5b7e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5b80:	0005c903          	lbu	s2,0(a1)
    5b84:	18090f63          	beqz	s2,5d22 <vprintf+0x1c0>
    5b88:	8aaa                	mv	s5,a0
    5b8a:	8b32                	mv	s6,a2
    5b8c:	00158493          	addi	s1,a1,1
  state = 0;
    5b90:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5b92:	02500a13          	li	s4,37
    5b96:	4c55                	li	s8,21
    5b98:	00002c97          	auipc	s9,0x2
    5b9c:	700c8c93          	addi	s9,s9,1792 # 8298 <malloc+0x2472>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    5ba0:	02800d93          	li	s11,40
  putc(fd, 'x');
    5ba4:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5ba6:	00002b97          	auipc	s7,0x2
    5baa:	74ab8b93          	addi	s7,s7,1866 # 82f0 <digits>
    5bae:	a839                	j	5bcc <vprintf+0x6a>
        putc(fd, c);
    5bb0:	85ca                	mv	a1,s2
    5bb2:	8556                	mv	a0,s5
    5bb4:	00000097          	auipc	ra,0x0
    5bb8:	ee0080e7          	jalr	-288(ra) # 5a94 <putc>
    5bbc:	a019                	j	5bc2 <vprintf+0x60>
    } else if(state == '%'){
    5bbe:	01498d63          	beq	s3,s4,5bd8 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    5bc2:	0485                	addi	s1,s1,1
    5bc4:	fff4c903          	lbu	s2,-1(s1)
    5bc8:	14090d63          	beqz	s2,5d22 <vprintf+0x1c0>
    if(state == 0){
    5bcc:	fe0999e3          	bnez	s3,5bbe <vprintf+0x5c>
      if(c == '%'){
    5bd0:	ff4910e3          	bne	s2,s4,5bb0 <vprintf+0x4e>
        state = '%';
    5bd4:	89d2                	mv	s3,s4
    5bd6:	b7f5                	j	5bc2 <vprintf+0x60>
      if(c == 'd'){
    5bd8:	11490c63          	beq	s2,s4,5cf0 <vprintf+0x18e>
    5bdc:	f9d9079b          	addiw	a5,s2,-99
    5be0:	0ff7f793          	zext.b	a5,a5
    5be4:	10fc6e63          	bltu	s8,a5,5d00 <vprintf+0x19e>
    5be8:	f9d9079b          	addiw	a5,s2,-99
    5bec:	0ff7f713          	zext.b	a4,a5
    5bf0:	10ec6863          	bltu	s8,a4,5d00 <vprintf+0x19e>
    5bf4:	00271793          	slli	a5,a4,0x2
    5bf8:	97e6                	add	a5,a5,s9
    5bfa:	439c                	lw	a5,0(a5)
    5bfc:	97e6                	add	a5,a5,s9
    5bfe:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5c00:	008b0913          	addi	s2,s6,8
    5c04:	4685                	li	a3,1
    5c06:	4629                	li	a2,10
    5c08:	000b2583          	lw	a1,0(s6)
    5c0c:	8556                	mv	a0,s5
    5c0e:	00000097          	auipc	ra,0x0
    5c12:	ea8080e7          	jalr	-344(ra) # 5ab6 <printint>
    5c16:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5c18:	4981                	li	s3,0
    5c1a:	b765                	j	5bc2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5c1c:	008b0913          	addi	s2,s6,8
    5c20:	4681                	li	a3,0
    5c22:	4629                	li	a2,10
    5c24:	000b2583          	lw	a1,0(s6)
    5c28:	8556                	mv	a0,s5
    5c2a:	00000097          	auipc	ra,0x0
    5c2e:	e8c080e7          	jalr	-372(ra) # 5ab6 <printint>
    5c32:	8b4a                	mv	s6,s2
      state = 0;
    5c34:	4981                	li	s3,0
    5c36:	b771                	j	5bc2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5c38:	008b0913          	addi	s2,s6,8
    5c3c:	4681                	li	a3,0
    5c3e:	866a                	mv	a2,s10
    5c40:	000b2583          	lw	a1,0(s6)
    5c44:	8556                	mv	a0,s5
    5c46:	00000097          	auipc	ra,0x0
    5c4a:	e70080e7          	jalr	-400(ra) # 5ab6 <printint>
    5c4e:	8b4a                	mv	s6,s2
      state = 0;
    5c50:	4981                	li	s3,0
    5c52:	bf85                	j	5bc2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5c54:	008b0793          	addi	a5,s6,8
    5c58:	f8f43423          	sd	a5,-120(s0)
    5c5c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5c60:	03000593          	li	a1,48
    5c64:	8556                	mv	a0,s5
    5c66:	00000097          	auipc	ra,0x0
    5c6a:	e2e080e7          	jalr	-466(ra) # 5a94 <putc>
  putc(fd, 'x');
    5c6e:	07800593          	li	a1,120
    5c72:	8556                	mv	a0,s5
    5c74:	00000097          	auipc	ra,0x0
    5c78:	e20080e7          	jalr	-480(ra) # 5a94 <putc>
    5c7c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5c7e:	03c9d793          	srli	a5,s3,0x3c
    5c82:	97de                	add	a5,a5,s7
    5c84:	0007c583          	lbu	a1,0(a5)
    5c88:	8556                	mv	a0,s5
    5c8a:	00000097          	auipc	ra,0x0
    5c8e:	e0a080e7          	jalr	-502(ra) # 5a94 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5c92:	0992                	slli	s3,s3,0x4
    5c94:	397d                	addiw	s2,s2,-1
    5c96:	fe0914e3          	bnez	s2,5c7e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    5c9a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5c9e:	4981                	li	s3,0
    5ca0:	b70d                	j	5bc2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5ca2:	008b0913          	addi	s2,s6,8
    5ca6:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    5caa:	02098163          	beqz	s3,5ccc <vprintf+0x16a>
        while(*s != 0){
    5cae:	0009c583          	lbu	a1,0(s3)
    5cb2:	c5ad                	beqz	a1,5d1c <vprintf+0x1ba>
          putc(fd, *s);
    5cb4:	8556                	mv	a0,s5
    5cb6:	00000097          	auipc	ra,0x0
    5cba:	dde080e7          	jalr	-546(ra) # 5a94 <putc>
          s++;
    5cbe:	0985                	addi	s3,s3,1
        while(*s != 0){
    5cc0:	0009c583          	lbu	a1,0(s3)
    5cc4:	f9e5                	bnez	a1,5cb4 <vprintf+0x152>
        s = va_arg(ap, char*);
    5cc6:	8b4a                	mv	s6,s2
      state = 0;
    5cc8:	4981                	li	s3,0
    5cca:	bde5                	j	5bc2 <vprintf+0x60>
          s = "(null)";
    5ccc:	00002997          	auipc	s3,0x2
    5cd0:	5c498993          	addi	s3,s3,1476 # 8290 <malloc+0x246a>
        while(*s != 0){
    5cd4:	85ee                	mv	a1,s11
    5cd6:	bff9                	j	5cb4 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    5cd8:	008b0913          	addi	s2,s6,8
    5cdc:	000b4583          	lbu	a1,0(s6)
    5ce0:	8556                	mv	a0,s5
    5ce2:	00000097          	auipc	ra,0x0
    5ce6:	db2080e7          	jalr	-590(ra) # 5a94 <putc>
    5cea:	8b4a                	mv	s6,s2
      state = 0;
    5cec:	4981                	li	s3,0
    5cee:	bdd1                	j	5bc2 <vprintf+0x60>
        putc(fd, c);
    5cf0:	85d2                	mv	a1,s4
    5cf2:	8556                	mv	a0,s5
    5cf4:	00000097          	auipc	ra,0x0
    5cf8:	da0080e7          	jalr	-608(ra) # 5a94 <putc>
      state = 0;
    5cfc:	4981                	li	s3,0
    5cfe:	b5d1                	j	5bc2 <vprintf+0x60>
        putc(fd, '%');
    5d00:	85d2                	mv	a1,s4
    5d02:	8556                	mv	a0,s5
    5d04:	00000097          	auipc	ra,0x0
    5d08:	d90080e7          	jalr	-624(ra) # 5a94 <putc>
        putc(fd, c);
    5d0c:	85ca                	mv	a1,s2
    5d0e:	8556                	mv	a0,s5
    5d10:	00000097          	auipc	ra,0x0
    5d14:	d84080e7          	jalr	-636(ra) # 5a94 <putc>
      state = 0;
    5d18:	4981                	li	s3,0
    5d1a:	b565                	j	5bc2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5d1c:	8b4a                	mv	s6,s2
      state = 0;
    5d1e:	4981                	li	s3,0
    5d20:	b54d                	j	5bc2 <vprintf+0x60>
    }
  }
}
    5d22:	70e6                	ld	ra,120(sp)
    5d24:	7446                	ld	s0,112(sp)
    5d26:	74a6                	ld	s1,104(sp)
    5d28:	7906                	ld	s2,96(sp)
    5d2a:	69e6                	ld	s3,88(sp)
    5d2c:	6a46                	ld	s4,80(sp)
    5d2e:	6aa6                	ld	s5,72(sp)
    5d30:	6b06                	ld	s6,64(sp)
    5d32:	7be2                	ld	s7,56(sp)
    5d34:	7c42                	ld	s8,48(sp)
    5d36:	7ca2                	ld	s9,40(sp)
    5d38:	7d02                	ld	s10,32(sp)
    5d3a:	6de2                	ld	s11,24(sp)
    5d3c:	6109                	addi	sp,sp,128
    5d3e:	8082                	ret

0000000000005d40 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5d40:	715d                	addi	sp,sp,-80
    5d42:	ec06                	sd	ra,24(sp)
    5d44:	e822                	sd	s0,16(sp)
    5d46:	1000                	addi	s0,sp,32
    5d48:	e010                	sd	a2,0(s0)
    5d4a:	e414                	sd	a3,8(s0)
    5d4c:	e818                	sd	a4,16(s0)
    5d4e:	ec1c                	sd	a5,24(s0)
    5d50:	03043023          	sd	a6,32(s0)
    5d54:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5d58:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5d5c:	8622                	mv	a2,s0
    5d5e:	00000097          	auipc	ra,0x0
    5d62:	e04080e7          	jalr	-508(ra) # 5b62 <vprintf>
}
    5d66:	60e2                	ld	ra,24(sp)
    5d68:	6442                	ld	s0,16(sp)
    5d6a:	6161                	addi	sp,sp,80
    5d6c:	8082                	ret

0000000000005d6e <printf>:

void
printf(const char *fmt, ...)
{
    5d6e:	711d                	addi	sp,sp,-96
    5d70:	ec06                	sd	ra,24(sp)
    5d72:	e822                	sd	s0,16(sp)
    5d74:	1000                	addi	s0,sp,32
    5d76:	e40c                	sd	a1,8(s0)
    5d78:	e810                	sd	a2,16(s0)
    5d7a:	ec14                	sd	a3,24(s0)
    5d7c:	f018                	sd	a4,32(s0)
    5d7e:	f41c                	sd	a5,40(s0)
    5d80:	03043823          	sd	a6,48(s0)
    5d84:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5d88:	00840613          	addi	a2,s0,8
    5d8c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5d90:	85aa                	mv	a1,a0
    5d92:	4505                	li	a0,1
    5d94:	00000097          	auipc	ra,0x0
    5d98:	dce080e7          	jalr	-562(ra) # 5b62 <vprintf>
}
    5d9c:	60e2                	ld	ra,24(sp)
    5d9e:	6442                	ld	s0,16(sp)
    5da0:	6125                	addi	sp,sp,96
    5da2:	8082                	ret

0000000000005da4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5da4:	1141                	addi	sp,sp,-16
    5da6:	e422                	sd	s0,8(sp)
    5da8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5daa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5dae:	00003797          	auipc	a5,0x3
    5db2:	6927b783          	ld	a5,1682(a5) # 9440 <freep>
    5db6:	a02d                	j	5de0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5db8:	4618                	lw	a4,8(a2)
    5dba:	9f2d                	addw	a4,a4,a1
    5dbc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5dc0:	6398                	ld	a4,0(a5)
    5dc2:	6310                	ld	a2,0(a4)
    5dc4:	a83d                	j	5e02 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5dc6:	ff852703          	lw	a4,-8(a0)
    5dca:	9f31                	addw	a4,a4,a2
    5dcc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5dce:	ff053683          	ld	a3,-16(a0)
    5dd2:	a091                	j	5e16 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5dd4:	6398                	ld	a4,0(a5)
    5dd6:	00e7e463          	bltu	a5,a4,5dde <free+0x3a>
    5dda:	00e6ea63          	bltu	a3,a4,5dee <free+0x4a>
{
    5dde:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5de0:	fed7fae3          	bgeu	a5,a3,5dd4 <free+0x30>
    5de4:	6398                	ld	a4,0(a5)
    5de6:	00e6e463          	bltu	a3,a4,5dee <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5dea:	fee7eae3          	bltu	a5,a4,5dde <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5dee:	ff852583          	lw	a1,-8(a0)
    5df2:	6390                	ld	a2,0(a5)
    5df4:	02059813          	slli	a6,a1,0x20
    5df8:	01c85713          	srli	a4,a6,0x1c
    5dfc:	9736                	add	a4,a4,a3
    5dfe:	fae60de3          	beq	a2,a4,5db8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5e02:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5e06:	4790                	lw	a2,8(a5)
    5e08:	02061593          	slli	a1,a2,0x20
    5e0c:	01c5d713          	srli	a4,a1,0x1c
    5e10:	973e                	add	a4,a4,a5
    5e12:	fae68ae3          	beq	a3,a4,5dc6 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5e16:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5e18:	00003717          	auipc	a4,0x3
    5e1c:	62f73423          	sd	a5,1576(a4) # 9440 <freep>
}
    5e20:	6422                	ld	s0,8(sp)
    5e22:	0141                	addi	sp,sp,16
    5e24:	8082                	ret

0000000000005e26 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5e26:	7139                	addi	sp,sp,-64
    5e28:	fc06                	sd	ra,56(sp)
    5e2a:	f822                	sd	s0,48(sp)
    5e2c:	f426                	sd	s1,40(sp)
    5e2e:	f04a                	sd	s2,32(sp)
    5e30:	ec4e                	sd	s3,24(sp)
    5e32:	e852                	sd	s4,16(sp)
    5e34:	e456                	sd	s5,8(sp)
    5e36:	e05a                	sd	s6,0(sp)
    5e38:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5e3a:	02051493          	slli	s1,a0,0x20
    5e3e:	9081                	srli	s1,s1,0x20
    5e40:	04bd                	addi	s1,s1,15
    5e42:	8091                	srli	s1,s1,0x4
    5e44:	0014899b          	addiw	s3,s1,1
    5e48:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5e4a:	00003517          	auipc	a0,0x3
    5e4e:	5f653503          	ld	a0,1526(a0) # 9440 <freep>
    5e52:	c515                	beqz	a0,5e7e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5e54:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5e56:	4798                	lw	a4,8(a5)
    5e58:	02977f63          	bgeu	a4,s1,5e96 <malloc+0x70>
    5e5c:	8a4e                	mv	s4,s3
    5e5e:	0009871b          	sext.w	a4,s3
    5e62:	6685                	lui	a3,0x1
    5e64:	00d77363          	bgeu	a4,a3,5e6a <malloc+0x44>
    5e68:	6a05                	lui	s4,0x1
    5e6a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5e6e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5e72:	00003917          	auipc	s2,0x3
    5e76:	5ce90913          	addi	s2,s2,1486 # 9440 <freep>
  if(p == (char*)-1)
    5e7a:	5afd                	li	s5,-1
    5e7c:	a895                	j	5ef0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5e7e:	0000a797          	auipc	a5,0xa
    5e82:	dea78793          	addi	a5,a5,-534 # fc68 <base>
    5e86:	00003717          	auipc	a4,0x3
    5e8a:	5af73d23          	sd	a5,1466(a4) # 9440 <freep>
    5e8e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5e90:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5e94:	b7e1                	j	5e5c <malloc+0x36>
      if(p->s.size == nunits)
    5e96:	02e48c63          	beq	s1,a4,5ece <malloc+0xa8>
        p->s.size -= nunits;
    5e9a:	4137073b          	subw	a4,a4,s3
    5e9e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5ea0:	02071693          	slli	a3,a4,0x20
    5ea4:	01c6d713          	srli	a4,a3,0x1c
    5ea8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5eaa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5eae:	00003717          	auipc	a4,0x3
    5eb2:	58a73923          	sd	a0,1426(a4) # 9440 <freep>
      return (void*)(p + 1);
    5eb6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5eba:	70e2                	ld	ra,56(sp)
    5ebc:	7442                	ld	s0,48(sp)
    5ebe:	74a2                	ld	s1,40(sp)
    5ec0:	7902                	ld	s2,32(sp)
    5ec2:	69e2                	ld	s3,24(sp)
    5ec4:	6a42                	ld	s4,16(sp)
    5ec6:	6aa2                	ld	s5,8(sp)
    5ec8:	6b02                	ld	s6,0(sp)
    5eca:	6121                	addi	sp,sp,64
    5ecc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5ece:	6398                	ld	a4,0(a5)
    5ed0:	e118                	sd	a4,0(a0)
    5ed2:	bff1                	j	5eae <malloc+0x88>
  hp->s.size = nu;
    5ed4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5ed8:	0541                	addi	a0,a0,16
    5eda:	00000097          	auipc	ra,0x0
    5ede:	eca080e7          	jalr	-310(ra) # 5da4 <free>
  return freep;
    5ee2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5ee6:	d971                	beqz	a0,5eba <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5ee8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5eea:	4798                	lw	a4,8(a5)
    5eec:	fa9775e3          	bgeu	a4,s1,5e96 <malloc+0x70>
    if(p == freep)
    5ef0:	00093703          	ld	a4,0(s2)
    5ef4:	853e                	mv	a0,a5
    5ef6:	fef719e3          	bne	a4,a5,5ee8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5efa:	8552                	mv	a0,s4
    5efc:	00000097          	auipc	ra,0x0
    5f00:	b68080e7          	jalr	-1176(ra) # 5a64 <sbrk>
  if(p == (char*)-1)
    5f04:	fd5518e3          	bne	a0,s5,5ed4 <malloc+0xae>
        return 0;
    5f08:	4501                	li	a0,0
    5f0a:	bf45                	j	5eba <malloc+0x94>
