
user/_setpriority:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main(int argc, char *argv[]) { //DONE works GOOD
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32

    if (argc != 3) {
   c:	478d                	li	a5,3
   e:	02f50163          	beq	a0,a5,30 <main+0x30>
        printf("Usage: setpriority pid priority\n");
  12:	00001517          	auipc	a0,0x1
  16:	84e50513          	addi	a0,a0,-1970 # 860 <malloc+0xec>
  1a:	00000097          	auipc	ra,0x0
  1e:	6a2080e7          	jalr	1698(ra) # 6bc <printf>
        printf("Process with PID %d: Old Priority = %d, New Priority = %d\n", pid, old_priority, priority);
    }

    return 0;
    
}
  22:	4501                	li	a0,0
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6902                	ld	s2,0(sp)
  2c:	6105                	addi	sp,sp,32
  2e:	8082                	ret
  30:	84ae                	mv	s1,a1
    int pid = atoi(argv[1]);       // Process ID
  32:	6588                	ld	a0,8(a1)
  34:	00000097          	auipc	ra,0x0
  38:	1fc080e7          	jalr	508(ra) # 230 <atoi>
  3c:	892a                	mv	s2,a0
    int priority = atoi(argv[2]);  // New priority
  3e:	6888                	ld	a0,16(s1)
  40:	00000097          	auipc	ra,0x0
  44:	1f0080e7          	jalr	496(ra) # 230 <atoi>
  48:	84aa                	mv	s1,a0
    if (priority < 0 || priority > 100) {
  4a:	0005071b          	sext.w	a4,a0
  4e:	06400793          	li	a5,100
  52:	02e7e663          	bltu	a5,a4,7e <main+0x7e>
    int old_priority = set_priority(pid, priority);
  56:	85aa                	mv	a1,a0
  58:	854a                	mv	a0,s2
  5a:	00000097          	auipc	ra,0x0
  5e:	380080e7          	jalr	896(ra) # 3da <set_priority>
  62:	862a                	mv	a2,a0
    if (old_priority < 0) { //-1
  64:	02054663          	bltz	a0,90 <main+0x90>
        printf("Process with PID %d: Old Priority = %d, New Priority = %d\n", pid, old_priority, priority);
  68:	86a6                	mv	a3,s1
  6a:	85ca                	mv	a1,s2
  6c:	00001517          	auipc	a0,0x1
  70:	89450513          	addi	a0,a0,-1900 # 900 <malloc+0x18c>
  74:	00000097          	auipc	ra,0x0
  78:	648080e7          	jalr	1608(ra) # 6bc <printf>
  7c:	b75d                	j	22 <main+0x22>
        printf("Error: Priority should be in the range [0, 100]\n");
  7e:	00001517          	auipc	a0,0x1
  82:	80a50513          	addi	a0,a0,-2038 # 888 <malloc+0x114>
  86:	00000097          	auipc	ra,0x0
  8a:	636080e7          	jalr	1590(ra) # 6bc <printf>
        return 0;
  8e:	bf51                	j	22 <main+0x22>
        printf("Error: Process with PID %d does not exist or invalid priority.\n", pid);
  90:	85ca                	mv	a1,s2
  92:	00001517          	auipc	a0,0x1
  96:	82e50513          	addi	a0,a0,-2002 # 8c0 <malloc+0x14c>
  9a:	00000097          	auipc	ra,0x0
  9e:	622080e7          	jalr	1570(ra) # 6bc <printf>
  a2:	b741                	j	22 <main+0x22>

00000000000000a4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e406                	sd	ra,8(sp)
  a8:	e022                	sd	s0,0(sp)
  aa:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ac:	00000097          	auipc	ra,0x0
  b0:	f54080e7          	jalr	-172(ra) # 0 <main>
  exit(0);
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	274080e7          	jalr	628(ra) # 32a <exit>

00000000000000be <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c4:	87aa                	mv	a5,a0
  c6:	0585                	addi	a1,a1,1
  c8:	0785                	addi	a5,a5,1
  ca:	fff5c703          	lbu	a4,-1(a1)
  ce:	fee78fa3          	sb	a4,-1(a5)
  d2:	fb75                	bnez	a4,c6 <strcpy+0x8>
    ;
  return os;
}
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strcmp>:

int
strcmp(const char *p, const char *q)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cb91                	beqz	a5,f8 <strcmp+0x1e>
  e6:	0005c703          	lbu	a4,0(a1)
  ea:	00f71763          	bne	a4,a5,f8 <strcmp+0x1e>
    p++, q++;
  ee:	0505                	addi	a0,a0,1
  f0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  f2:	00054783          	lbu	a5,0(a0)
  f6:	fbe5                	bnez	a5,e6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  f8:	0005c503          	lbu	a0,0(a1)
}
  fc:	40a7853b          	subw	a0,a5,a0
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strlen>:

uint
strlen(const char *s)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cf91                	beqz	a5,12c <strlen+0x26>
 112:	0505                	addi	a0,a0,1
 114:	87aa                	mv	a5,a0
 116:	4685                	li	a3,1
 118:	9e89                	subw	a3,a3,a0
 11a:	00f6853b          	addw	a0,a3,a5
 11e:	0785                	addi	a5,a5,1
 120:	fff7c703          	lbu	a4,-1(a5)
 124:	fb7d                	bnez	a4,11a <strlen+0x14>
    ;
  return n;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  for(n = 0; s[n]; n++)
 12c:	4501                	li	a0,0
 12e:	bfe5                	j	126 <strlen+0x20>

0000000000000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 136:	ca19                	beqz	a2,14c <memset+0x1c>
 138:	87aa                	mv	a5,a0
 13a:	1602                	slli	a2,a2,0x20
 13c:	9201                	srli	a2,a2,0x20
 13e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 142:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 146:	0785                	addi	a5,a5,1
 148:	fee79de3          	bne	a5,a4,142 <memset+0x12>
  }
  return dst;
}
 14c:	6422                	ld	s0,8(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret

0000000000000152 <strchr>:

char*
strchr(const char *s, char c)
{
 152:	1141                	addi	sp,sp,-16
 154:	e422                	sd	s0,8(sp)
 156:	0800                	addi	s0,sp,16
  for(; *s; s++)
 158:	00054783          	lbu	a5,0(a0)
 15c:	cb99                	beqz	a5,172 <strchr+0x20>
    if(*s == c)
 15e:	00f58763          	beq	a1,a5,16c <strchr+0x1a>
  for(; *s; s++)
 162:	0505                	addi	a0,a0,1
 164:	00054783          	lbu	a5,0(a0)
 168:	fbfd                	bnez	a5,15e <strchr+0xc>
      return (char*)s;
  return 0;
 16a:	4501                	li	a0,0
}
 16c:	6422                	ld	s0,8(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  return 0;
 172:	4501                	li	a0,0
 174:	bfe5                	j	16c <strchr+0x1a>

0000000000000176 <gets>:

char*
gets(char *buf, int max)
{
 176:	711d                	addi	sp,sp,-96
 178:	ec86                	sd	ra,88(sp)
 17a:	e8a2                	sd	s0,80(sp)
 17c:	e4a6                	sd	s1,72(sp)
 17e:	e0ca                	sd	s2,64(sp)
 180:	fc4e                	sd	s3,56(sp)
 182:	f852                	sd	s4,48(sp)
 184:	f456                	sd	s5,40(sp)
 186:	f05a                	sd	s6,32(sp)
 188:	ec5e                	sd	s7,24(sp)
 18a:	1080                	addi	s0,sp,96
 18c:	8baa                	mv	s7,a0
 18e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 190:	892a                	mv	s2,a0
 192:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 194:	4aa9                	li	s5,10
 196:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 198:	89a6                	mv	s3,s1
 19a:	2485                	addiw	s1,s1,1
 19c:	0344d863          	bge	s1,s4,1cc <gets+0x56>
    cc = read(0, &c, 1);
 1a0:	4605                	li	a2,1
 1a2:	faf40593          	addi	a1,s0,-81
 1a6:	4501                	li	a0,0
 1a8:	00000097          	auipc	ra,0x0
 1ac:	19a080e7          	jalr	410(ra) # 342 <read>
    if(cc < 1)
 1b0:	00a05e63          	blez	a0,1cc <gets+0x56>
    buf[i++] = c;
 1b4:	faf44783          	lbu	a5,-81(s0)
 1b8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1bc:	01578763          	beq	a5,s5,1ca <gets+0x54>
 1c0:	0905                	addi	s2,s2,1
 1c2:	fd679be3          	bne	a5,s6,198 <gets+0x22>
  for(i=0; i+1 < max; ){
 1c6:	89a6                	mv	s3,s1
 1c8:	a011                	j	1cc <gets+0x56>
 1ca:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1cc:	99de                	add	s3,s3,s7
 1ce:	00098023          	sb	zero,0(s3)
  return buf;
}
 1d2:	855e                	mv	a0,s7
 1d4:	60e6                	ld	ra,88(sp)
 1d6:	6446                	ld	s0,80(sp)
 1d8:	64a6                	ld	s1,72(sp)
 1da:	6906                	ld	s2,64(sp)
 1dc:	79e2                	ld	s3,56(sp)
 1de:	7a42                	ld	s4,48(sp)
 1e0:	7aa2                	ld	s5,40(sp)
 1e2:	7b02                	ld	s6,32(sp)
 1e4:	6be2                	ld	s7,24(sp)
 1e6:	6125                	addi	sp,sp,96
 1e8:	8082                	ret

00000000000001ea <stat>:

int
stat(const char *n, struct stat *st)
{
 1ea:	1101                	addi	sp,sp,-32
 1ec:	ec06                	sd	ra,24(sp)
 1ee:	e822                	sd	s0,16(sp)
 1f0:	e426                	sd	s1,8(sp)
 1f2:	e04a                	sd	s2,0(sp)
 1f4:	1000                	addi	s0,sp,32
 1f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f8:	4581                	li	a1,0
 1fa:	00000097          	auipc	ra,0x0
 1fe:	170080e7          	jalr	368(ra) # 36a <open>
  if(fd < 0)
 202:	02054563          	bltz	a0,22c <stat+0x42>
 206:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 208:	85ca                	mv	a1,s2
 20a:	00000097          	auipc	ra,0x0
 20e:	178080e7          	jalr	376(ra) # 382 <fstat>
 212:	892a                	mv	s2,a0
  close(fd);
 214:	8526                	mv	a0,s1
 216:	00000097          	auipc	ra,0x0
 21a:	13c080e7          	jalr	316(ra) # 352 <close>
  return r;
}
 21e:	854a                	mv	a0,s2
 220:	60e2                	ld	ra,24(sp)
 222:	6442                	ld	s0,16(sp)
 224:	64a2                	ld	s1,8(sp)
 226:	6902                	ld	s2,0(sp)
 228:	6105                	addi	sp,sp,32
 22a:	8082                	ret
    return -1;
 22c:	597d                	li	s2,-1
 22e:	bfc5                	j	21e <stat+0x34>

0000000000000230 <atoi>:

int
atoi(const char *s)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 236:	00054683          	lbu	a3,0(a0)
 23a:	fd06879b          	addiw	a5,a3,-48
 23e:	0ff7f793          	zext.b	a5,a5
 242:	4625                	li	a2,9
 244:	02f66863          	bltu	a2,a5,274 <atoi+0x44>
 248:	872a                	mv	a4,a0
  n = 0;
 24a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 24c:	0705                	addi	a4,a4,1
 24e:	0025179b          	slliw	a5,a0,0x2
 252:	9fa9                	addw	a5,a5,a0
 254:	0017979b          	slliw	a5,a5,0x1
 258:	9fb5                	addw	a5,a5,a3
 25a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 25e:	00074683          	lbu	a3,0(a4)
 262:	fd06879b          	addiw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	fef671e3          	bgeu	a2,a5,24c <atoi+0x1c>
  return n;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
  n = 0;
 274:	4501                	li	a0,0
 276:	bfe5                	j	26e <atoi+0x3e>

0000000000000278 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27e:	02b57463          	bgeu	a0,a1,2a6 <memmove+0x2e>
    while(n-- > 0)
 282:	00c05f63          	blez	a2,2a0 <memmove+0x28>
 286:	1602                	slli	a2,a2,0x20
 288:	9201                	srli	a2,a2,0x20
 28a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28e:	872a                	mv	a4,a0
      *dst++ = *src++;
 290:	0585                	addi	a1,a1,1
 292:	0705                	addi	a4,a4,1
 294:	fff5c683          	lbu	a3,-1(a1)
 298:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 29c:	fee79ae3          	bne	a5,a4,290 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
    dst += n;
 2a6:	00c50733          	add	a4,a0,a2
    src += n;
 2aa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ac:	fec05ae3          	blez	a2,2a0 <memmove+0x28>
 2b0:	fff6079b          	addiw	a5,a2,-1
 2b4:	1782                	slli	a5,a5,0x20
 2b6:	9381                	srli	a5,a5,0x20
 2b8:	fff7c793          	not	a5,a5
 2bc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2be:	15fd                	addi	a1,a1,-1
 2c0:	177d                	addi	a4,a4,-1
 2c2:	0005c683          	lbu	a3,0(a1)
 2c6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ca:	fee79ae3          	bne	a5,a4,2be <memmove+0x46>
 2ce:	bfc9                	j	2a0 <memmove+0x28>

00000000000002d0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d6:	ca05                	beqz	a2,306 <memcmp+0x36>
 2d8:	fff6069b          	addiw	a3,a2,-1
 2dc:	1682                	slli	a3,a3,0x20
 2de:	9281                	srli	a3,a3,0x20
 2e0:	0685                	addi	a3,a3,1
 2e2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	0005c703          	lbu	a4,0(a1)
 2ec:	00e79863          	bne	a5,a4,2fc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f0:	0505                	addi	a0,a0,1
    p2++;
 2f2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f4:	fed518e3          	bne	a0,a3,2e4 <memcmp+0x14>
  }
  return 0;
 2f8:	4501                	li	a0,0
 2fa:	a019                	j	300 <memcmp+0x30>
      return *p1 - *p2;
 2fc:	40e7853b          	subw	a0,a5,a4
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
  return 0;
 306:	4501                	li	a0,0
 308:	bfe5                	j	300 <memcmp+0x30>

000000000000030a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e406                	sd	ra,8(sp)
 30e:	e022                	sd	s0,0(sp)
 310:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 312:	00000097          	auipc	ra,0x0
 316:	f66080e7          	jalr	-154(ra) # 278 <memmove>
}
 31a:	60a2                	ld	ra,8(sp)
 31c:	6402                	ld	s0,0(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret

0000000000000322 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 322:	4885                	li	a7,1
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <exit>:
.global exit
exit:
 li a7, SYS_exit
 32a:	4889                	li	a7,2
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <wait>:
.global wait
wait:
 li a7, SYS_wait
 332:	488d                	li	a7,3
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33a:	4891                	li	a7,4
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <read>:
.global read
read:
 li a7, SYS_read
 342:	4895                	li	a7,5
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <write>:
.global write
write:
 li a7, SYS_write
 34a:	48c1                	li	a7,16
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <close>:
.global close
close:
 li a7, SYS_close
 352:	48d5                	li	a7,21
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <kill>:
.global kill
kill:
 li a7, SYS_kill
 35a:	4899                	li	a7,6
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <exec>:
.global exec
exec:
 li a7, SYS_exec
 362:	489d                	li	a7,7
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <open>:
.global open
open:
 li a7, SYS_open
 36a:	48bd                	li	a7,15
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 372:	48c5                	li	a7,17
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37a:	48c9                	li	a7,18
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 382:	48a1                	li	a7,8
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <link>:
.global link
link:
 li a7, SYS_link
 38a:	48cd                	li	a7,19
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 392:	48d1                	li	a7,20
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39a:	48a5                	li	a7,9
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a2:	48a9                	li	a7,10
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3aa:	48ad                	li	a7,11
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3b2:	48b1                	li	a7,12
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ba:	48b5                	li	a7,13
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c2:	48b9                	li	a7,14
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3ca:	48d9                	li	a7,22
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 3d2:	48dd                	li	a7,23
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 3da:	48e1                	li	a7,24
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e2:	1101                	addi	sp,sp,-32
 3e4:	ec06                	sd	ra,24(sp)
 3e6:	e822                	sd	s0,16(sp)
 3e8:	1000                	addi	s0,sp,32
 3ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ee:	4605                	li	a2,1
 3f0:	fef40593          	addi	a1,s0,-17
 3f4:	00000097          	auipc	ra,0x0
 3f8:	f56080e7          	jalr	-170(ra) # 34a <write>
}
 3fc:	60e2                	ld	ra,24(sp)
 3fe:	6442                	ld	s0,16(sp)
 400:	6105                	addi	sp,sp,32
 402:	8082                	ret

0000000000000404 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 404:	7139                	addi	sp,sp,-64
 406:	fc06                	sd	ra,56(sp)
 408:	f822                	sd	s0,48(sp)
 40a:	f426                	sd	s1,40(sp)
 40c:	f04a                	sd	s2,32(sp)
 40e:	ec4e                	sd	s3,24(sp)
 410:	0080                	addi	s0,sp,64
 412:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 414:	c299                	beqz	a3,41a <printint+0x16>
 416:	0805c963          	bltz	a1,4a8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 41a:	2581                	sext.w	a1,a1
  neg = 0;
 41c:	4881                	li	a7,0
 41e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 422:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 424:	2601                	sext.w	a2,a2
 426:	00000517          	auipc	a0,0x0
 42a:	57a50513          	addi	a0,a0,1402 # 9a0 <digits>
 42e:	883a                	mv	a6,a4
 430:	2705                	addiw	a4,a4,1
 432:	02c5f7bb          	remuw	a5,a1,a2
 436:	1782                	slli	a5,a5,0x20
 438:	9381                	srli	a5,a5,0x20
 43a:	97aa                	add	a5,a5,a0
 43c:	0007c783          	lbu	a5,0(a5)
 440:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 444:	0005879b          	sext.w	a5,a1
 448:	02c5d5bb          	divuw	a1,a1,a2
 44c:	0685                	addi	a3,a3,1
 44e:	fec7f0e3          	bgeu	a5,a2,42e <printint+0x2a>
  if(neg)
 452:	00088c63          	beqz	a7,46a <printint+0x66>
    buf[i++] = '-';
 456:	fd070793          	addi	a5,a4,-48
 45a:	00878733          	add	a4,a5,s0
 45e:	02d00793          	li	a5,45
 462:	fef70823          	sb	a5,-16(a4)
 466:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 46a:	02e05863          	blez	a4,49a <printint+0x96>
 46e:	fc040793          	addi	a5,s0,-64
 472:	00e78933          	add	s2,a5,a4
 476:	fff78993          	addi	s3,a5,-1
 47a:	99ba                	add	s3,s3,a4
 47c:	377d                	addiw	a4,a4,-1
 47e:	1702                	slli	a4,a4,0x20
 480:	9301                	srli	a4,a4,0x20
 482:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 486:	fff94583          	lbu	a1,-1(s2)
 48a:	8526                	mv	a0,s1
 48c:	00000097          	auipc	ra,0x0
 490:	f56080e7          	jalr	-170(ra) # 3e2 <putc>
  while(--i >= 0)
 494:	197d                	addi	s2,s2,-1
 496:	ff3918e3          	bne	s2,s3,486 <printint+0x82>
}
 49a:	70e2                	ld	ra,56(sp)
 49c:	7442                	ld	s0,48(sp)
 49e:	74a2                	ld	s1,40(sp)
 4a0:	7902                	ld	s2,32(sp)
 4a2:	69e2                	ld	s3,24(sp)
 4a4:	6121                	addi	sp,sp,64
 4a6:	8082                	ret
    x = -xx;
 4a8:	40b005bb          	negw	a1,a1
    neg = 1;
 4ac:	4885                	li	a7,1
    x = -xx;
 4ae:	bf85                	j	41e <printint+0x1a>

00000000000004b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b0:	7119                	addi	sp,sp,-128
 4b2:	fc86                	sd	ra,120(sp)
 4b4:	f8a2                	sd	s0,112(sp)
 4b6:	f4a6                	sd	s1,104(sp)
 4b8:	f0ca                	sd	s2,96(sp)
 4ba:	ecce                	sd	s3,88(sp)
 4bc:	e8d2                	sd	s4,80(sp)
 4be:	e4d6                	sd	s5,72(sp)
 4c0:	e0da                	sd	s6,64(sp)
 4c2:	fc5e                	sd	s7,56(sp)
 4c4:	f862                	sd	s8,48(sp)
 4c6:	f466                	sd	s9,40(sp)
 4c8:	f06a                	sd	s10,32(sp)
 4ca:	ec6e                	sd	s11,24(sp)
 4cc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ce:	0005c903          	lbu	s2,0(a1)
 4d2:	18090f63          	beqz	s2,670 <vprintf+0x1c0>
 4d6:	8aaa                	mv	s5,a0
 4d8:	8b32                	mv	s6,a2
 4da:	00158493          	addi	s1,a1,1
  state = 0;
 4de:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e0:	02500a13          	li	s4,37
 4e4:	4c55                	li	s8,21
 4e6:	00000c97          	auipc	s9,0x0
 4ea:	462c8c93          	addi	s9,s9,1122 # 948 <malloc+0x1d4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4ee:	02800d93          	li	s11,40
  putc(fd, 'x');
 4f2:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f4:	00000b97          	auipc	s7,0x0
 4f8:	4acb8b93          	addi	s7,s7,1196 # 9a0 <digits>
 4fc:	a839                	j	51a <vprintf+0x6a>
        putc(fd, c);
 4fe:	85ca                	mv	a1,s2
 500:	8556                	mv	a0,s5
 502:	00000097          	auipc	ra,0x0
 506:	ee0080e7          	jalr	-288(ra) # 3e2 <putc>
 50a:	a019                	j	510 <vprintf+0x60>
    } else if(state == '%'){
 50c:	01498d63          	beq	s3,s4,526 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 510:	0485                	addi	s1,s1,1
 512:	fff4c903          	lbu	s2,-1(s1)
 516:	14090d63          	beqz	s2,670 <vprintf+0x1c0>
    if(state == 0){
 51a:	fe0999e3          	bnez	s3,50c <vprintf+0x5c>
      if(c == '%'){
 51e:	ff4910e3          	bne	s2,s4,4fe <vprintf+0x4e>
        state = '%';
 522:	89d2                	mv	s3,s4
 524:	b7f5                	j	510 <vprintf+0x60>
      if(c == 'd'){
 526:	11490c63          	beq	s2,s4,63e <vprintf+0x18e>
 52a:	f9d9079b          	addiw	a5,s2,-99
 52e:	0ff7f793          	zext.b	a5,a5
 532:	10fc6e63          	bltu	s8,a5,64e <vprintf+0x19e>
 536:	f9d9079b          	addiw	a5,s2,-99
 53a:	0ff7f713          	zext.b	a4,a5
 53e:	10ec6863          	bltu	s8,a4,64e <vprintf+0x19e>
 542:	00271793          	slli	a5,a4,0x2
 546:	97e6                	add	a5,a5,s9
 548:	439c                	lw	a5,0(a5)
 54a:	97e6                	add	a5,a5,s9
 54c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 54e:	008b0913          	addi	s2,s6,8
 552:	4685                	li	a3,1
 554:	4629                	li	a2,10
 556:	000b2583          	lw	a1,0(s6)
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	ea8080e7          	jalr	-344(ra) # 404 <printint>
 564:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 566:	4981                	li	s3,0
 568:	b765                	j	510 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56a:	008b0913          	addi	s2,s6,8
 56e:	4681                	li	a3,0
 570:	4629                	li	a2,10
 572:	000b2583          	lw	a1,0(s6)
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	e8c080e7          	jalr	-372(ra) # 404 <printint>
 580:	8b4a                	mv	s6,s2
      state = 0;
 582:	4981                	li	s3,0
 584:	b771                	j	510 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 586:	008b0913          	addi	s2,s6,8
 58a:	4681                	li	a3,0
 58c:	866a                	mv	a2,s10
 58e:	000b2583          	lw	a1,0(s6)
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	e70080e7          	jalr	-400(ra) # 404 <printint>
 59c:	8b4a                	mv	s6,s2
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	bf85                	j	510 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5a2:	008b0793          	addi	a5,s6,8
 5a6:	f8f43423          	sd	a5,-120(s0)
 5aa:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5ae:	03000593          	li	a1,48
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	e2e080e7          	jalr	-466(ra) # 3e2 <putc>
  putc(fd, 'x');
 5bc:	07800593          	li	a1,120
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e20080e7          	jalr	-480(ra) # 3e2 <putc>
 5ca:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5cc:	03c9d793          	srli	a5,s3,0x3c
 5d0:	97de                	add	a5,a5,s7
 5d2:	0007c583          	lbu	a1,0(a5)
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e0a080e7          	jalr	-502(ra) # 3e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e0:	0992                	slli	s3,s3,0x4
 5e2:	397d                	addiw	s2,s2,-1
 5e4:	fe0914e3          	bnez	s2,5cc <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5e8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b70d                	j	510 <vprintf+0x60>
        s = va_arg(ap, char*);
 5f0:	008b0913          	addi	s2,s6,8
 5f4:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5f8:	02098163          	beqz	s3,61a <vprintf+0x16a>
        while(*s != 0){
 5fc:	0009c583          	lbu	a1,0(s3)
 600:	c5ad                	beqz	a1,66a <vprintf+0x1ba>
          putc(fd, *s);
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	dde080e7          	jalr	-546(ra) # 3e2 <putc>
          s++;
 60c:	0985                	addi	s3,s3,1
        while(*s != 0){
 60e:	0009c583          	lbu	a1,0(s3)
 612:	f9e5                	bnez	a1,602 <vprintf+0x152>
        s = va_arg(ap, char*);
 614:	8b4a                	mv	s6,s2
      state = 0;
 616:	4981                	li	s3,0
 618:	bde5                	j	510 <vprintf+0x60>
          s = "(null)";
 61a:	00000997          	auipc	s3,0x0
 61e:	32698993          	addi	s3,s3,806 # 940 <malloc+0x1cc>
        while(*s != 0){
 622:	85ee                	mv	a1,s11
 624:	bff9                	j	602 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 626:	008b0913          	addi	s2,s6,8
 62a:	000b4583          	lbu	a1,0(s6)
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	db2080e7          	jalr	-590(ra) # 3e2 <putc>
 638:	8b4a                	mv	s6,s2
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bdd1                	j	510 <vprintf+0x60>
        putc(fd, c);
 63e:	85d2                	mv	a1,s4
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	da0080e7          	jalr	-608(ra) # 3e2 <putc>
      state = 0;
 64a:	4981                	li	s3,0
 64c:	b5d1                	j	510 <vprintf+0x60>
        putc(fd, '%');
 64e:	85d2                	mv	a1,s4
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	d90080e7          	jalr	-624(ra) # 3e2 <putc>
        putc(fd, c);
 65a:	85ca                	mv	a1,s2
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	d84080e7          	jalr	-636(ra) # 3e2 <putc>
      state = 0;
 666:	4981                	li	s3,0
 668:	b565                	j	510 <vprintf+0x60>
        s = va_arg(ap, char*);
 66a:	8b4a                	mv	s6,s2
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b54d                	j	510 <vprintf+0x60>
    }
  }
}
 670:	70e6                	ld	ra,120(sp)
 672:	7446                	ld	s0,112(sp)
 674:	74a6                	ld	s1,104(sp)
 676:	7906                	ld	s2,96(sp)
 678:	69e6                	ld	s3,88(sp)
 67a:	6a46                	ld	s4,80(sp)
 67c:	6aa6                	ld	s5,72(sp)
 67e:	6b06                	ld	s6,64(sp)
 680:	7be2                	ld	s7,56(sp)
 682:	7c42                	ld	s8,48(sp)
 684:	7ca2                	ld	s9,40(sp)
 686:	7d02                	ld	s10,32(sp)
 688:	6de2                	ld	s11,24(sp)
 68a:	6109                	addi	sp,sp,128
 68c:	8082                	ret

000000000000068e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68e:	715d                	addi	sp,sp,-80
 690:	ec06                	sd	ra,24(sp)
 692:	e822                	sd	s0,16(sp)
 694:	1000                	addi	s0,sp,32
 696:	e010                	sd	a2,0(s0)
 698:	e414                	sd	a3,8(s0)
 69a:	e818                	sd	a4,16(s0)
 69c:	ec1c                	sd	a5,24(s0)
 69e:	03043023          	sd	a6,32(s0)
 6a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6aa:	8622                	mv	a2,s0
 6ac:	00000097          	auipc	ra,0x0
 6b0:	e04080e7          	jalr	-508(ra) # 4b0 <vprintf>
}
 6b4:	60e2                	ld	ra,24(sp)
 6b6:	6442                	ld	s0,16(sp)
 6b8:	6161                	addi	sp,sp,80
 6ba:	8082                	ret

00000000000006bc <printf>:

void
printf(const char *fmt, ...)
{
 6bc:	711d                	addi	sp,sp,-96
 6be:	ec06                	sd	ra,24(sp)
 6c0:	e822                	sd	s0,16(sp)
 6c2:	1000                	addi	s0,sp,32
 6c4:	e40c                	sd	a1,8(s0)
 6c6:	e810                	sd	a2,16(s0)
 6c8:	ec14                	sd	a3,24(s0)
 6ca:	f018                	sd	a4,32(s0)
 6cc:	f41c                	sd	a5,40(s0)
 6ce:	03043823          	sd	a6,48(s0)
 6d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d6:	00840613          	addi	a2,s0,8
 6da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6de:	85aa                	mv	a1,a0
 6e0:	4505                	li	a0,1
 6e2:	00000097          	auipc	ra,0x0
 6e6:	dce080e7          	jalr	-562(ra) # 4b0 <vprintf>
}
 6ea:	60e2                	ld	ra,24(sp)
 6ec:	6442                	ld	s0,16(sp)
 6ee:	6125                	addi	sp,sp,96
 6f0:	8082                	ret

00000000000006f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f2:	1141                	addi	sp,sp,-16
 6f4:	e422                	sd	s0,8(sp)
 6f6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fc:	00001797          	auipc	a5,0x1
 700:	9047b783          	ld	a5,-1788(a5) # 1000 <freep>
 704:	a02d                	j	72e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 706:	4618                	lw	a4,8(a2)
 708:	9f2d                	addw	a4,a4,a1
 70a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 70e:	6398                	ld	a4,0(a5)
 710:	6310                	ld	a2,0(a4)
 712:	a83d                	j	750 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 714:	ff852703          	lw	a4,-8(a0)
 718:	9f31                	addw	a4,a4,a2
 71a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 71c:	ff053683          	ld	a3,-16(a0)
 720:	a091                	j	764 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 722:	6398                	ld	a4,0(a5)
 724:	00e7e463          	bltu	a5,a4,72c <free+0x3a>
 728:	00e6ea63          	bltu	a3,a4,73c <free+0x4a>
{
 72c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72e:	fed7fae3          	bgeu	a5,a3,722 <free+0x30>
 732:	6398                	ld	a4,0(a5)
 734:	00e6e463          	bltu	a3,a4,73c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 738:	fee7eae3          	bltu	a5,a4,72c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 73c:	ff852583          	lw	a1,-8(a0)
 740:	6390                	ld	a2,0(a5)
 742:	02059813          	slli	a6,a1,0x20
 746:	01c85713          	srli	a4,a6,0x1c
 74a:	9736                	add	a4,a4,a3
 74c:	fae60de3          	beq	a2,a4,706 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 750:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 754:	4790                	lw	a2,8(a5)
 756:	02061593          	slli	a1,a2,0x20
 75a:	01c5d713          	srli	a4,a1,0x1c
 75e:	973e                	add	a4,a4,a5
 760:	fae68ae3          	beq	a3,a4,714 <free+0x22>
    p->s.ptr = bp->s.ptr;
 764:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 766:	00001717          	auipc	a4,0x1
 76a:	88f73d23          	sd	a5,-1894(a4) # 1000 <freep>
}
 76e:	6422                	ld	s0,8(sp)
 770:	0141                	addi	sp,sp,16
 772:	8082                	ret

0000000000000774 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 774:	7139                	addi	sp,sp,-64
 776:	fc06                	sd	ra,56(sp)
 778:	f822                	sd	s0,48(sp)
 77a:	f426                	sd	s1,40(sp)
 77c:	f04a                	sd	s2,32(sp)
 77e:	ec4e                	sd	s3,24(sp)
 780:	e852                	sd	s4,16(sp)
 782:	e456                	sd	s5,8(sp)
 784:	e05a                	sd	s6,0(sp)
 786:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 788:	02051493          	slli	s1,a0,0x20
 78c:	9081                	srli	s1,s1,0x20
 78e:	04bd                	addi	s1,s1,15
 790:	8091                	srli	s1,s1,0x4
 792:	0014899b          	addiw	s3,s1,1
 796:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 798:	00001517          	auipc	a0,0x1
 79c:	86853503          	ld	a0,-1944(a0) # 1000 <freep>
 7a0:	c515                	beqz	a0,7cc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a4:	4798                	lw	a4,8(a5)
 7a6:	02977f63          	bgeu	a4,s1,7e4 <malloc+0x70>
 7aa:	8a4e                	mv	s4,s3
 7ac:	0009871b          	sext.w	a4,s3
 7b0:	6685                	lui	a3,0x1
 7b2:	00d77363          	bgeu	a4,a3,7b8 <malloc+0x44>
 7b6:	6a05                	lui	s4,0x1
 7b8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7bc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c0:	00001917          	auipc	s2,0x1
 7c4:	84090913          	addi	s2,s2,-1984 # 1000 <freep>
  if(p == (char*)-1)
 7c8:	5afd                	li	s5,-1
 7ca:	a895                	j	83e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7cc:	00001797          	auipc	a5,0x1
 7d0:	84478793          	addi	a5,a5,-1980 # 1010 <base>
 7d4:	00001717          	auipc	a4,0x1
 7d8:	82f73623          	sd	a5,-2004(a4) # 1000 <freep>
 7dc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7de:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e2:	b7e1                	j	7aa <malloc+0x36>
      if(p->s.size == nunits)
 7e4:	02e48c63          	beq	s1,a4,81c <malloc+0xa8>
        p->s.size -= nunits;
 7e8:	4137073b          	subw	a4,a4,s3
 7ec:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ee:	02071693          	slli	a3,a4,0x20
 7f2:	01c6d713          	srli	a4,a3,0x1c
 7f6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7f8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7fc:	00001717          	auipc	a4,0x1
 800:	80a73223          	sd	a0,-2044(a4) # 1000 <freep>
      return (void*)(p + 1);
 804:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 808:	70e2                	ld	ra,56(sp)
 80a:	7442                	ld	s0,48(sp)
 80c:	74a2                	ld	s1,40(sp)
 80e:	7902                	ld	s2,32(sp)
 810:	69e2                	ld	s3,24(sp)
 812:	6a42                	ld	s4,16(sp)
 814:	6aa2                	ld	s5,8(sp)
 816:	6b02                	ld	s6,0(sp)
 818:	6121                	addi	sp,sp,64
 81a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 81c:	6398                	ld	a4,0(a5)
 81e:	e118                	sd	a4,0(a0)
 820:	bff1                	j	7fc <malloc+0x88>
  hp->s.size = nu;
 822:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 826:	0541                	addi	a0,a0,16
 828:	00000097          	auipc	ra,0x0
 82c:	eca080e7          	jalr	-310(ra) # 6f2 <free>
  return freep;
 830:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 834:	d971                	beqz	a0,808 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 836:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 838:	4798                	lw	a4,8(a5)
 83a:	fa9775e3          	bgeu	a4,s1,7e4 <malloc+0x70>
    if(p == freep)
 83e:	00093703          	ld	a4,0(s2)
 842:	853e                	mv	a0,a5
 844:	fef719e3          	bne	a4,a5,836 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 848:	8552                	mv	a0,s4
 84a:	00000097          	auipc	ra,0x0
 84e:	b68080e7          	jalr	-1176(ra) # 3b2 <sbrk>
  if(p == (char*)-1)
 852:	fd5518e3          	bne	a0,s5,822 <malloc+0xae>
        return 0;
 856:	4501                	li	a0,0
 858:	bf45                	j	808 <malloc+0x94>
