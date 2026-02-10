
/home/lacie/project/retdec1/retdec/Lacie/test/BPA/memoryIns/builds/test_memory_access_stripped:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <.init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    rsp,0x8
    1008:	48 8b 05 d9 2f 00 00 	mov    rax,QWORD PTR [rip+0x2fd9]        # 3fe8 <malloc@plt+0x2ef8>
    100f:	48 85 c0             	test   rax,rax
    1012:	74 02                	je     1016 <__cxa_finalize@plt-0x7a>
    1014:	ff d0                	call   rax
    1016:	48 83 c4 08          	add    rsp,0x8
    101a:	c3                   	ret    

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 72 2f 00 00    	push   QWORD PTR [rip+0x2f72]        # 3f98 <malloc@plt+0x2ea8>
    1026:	f2 ff 25 73 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f73]        # 3fa0 <malloc@plt+0x2eb0>
    102d:	0f 1f 00             	nop    DWORD PTR [rax]
    1030:	f3 0f 1e fa          	endbr64 
    1034:	68 00 00 00 00       	push   0x0
    1039:	f2 e9 e1 ff ff ff    	bnd jmp 1020 <__cxa_finalize@plt-0x70>
    103f:	90                   	nop
    1040:	f3 0f 1e fa          	endbr64 
    1044:	68 01 00 00 00       	push   0x1
    1049:	f2 e9 d1 ff ff ff    	bnd jmp 1020 <__cxa_finalize@plt-0x70>
    104f:	90                   	nop
    1050:	f3 0f 1e fa          	endbr64 
    1054:	68 02 00 00 00       	push   0x2
    1059:	f2 e9 c1 ff ff ff    	bnd jmp 1020 <__cxa_finalize@plt-0x70>
    105f:	90                   	nop
    1060:	f3 0f 1e fa          	endbr64 
    1064:	68 03 00 00 00       	push   0x3
    1069:	f2 e9 b1 ff ff ff    	bnd jmp 1020 <__cxa_finalize@plt-0x70>
    106f:	90                   	nop
    1070:	f3 0f 1e fa          	endbr64 
    1074:	68 04 00 00 00       	push   0x4
    1079:	f2 e9 a1 ff ff ff    	bnd jmp 1020 <__cxa_finalize@plt-0x70>
    107f:	90                   	nop
    1080:	f3 0f 1e fa          	endbr64 
    1084:	68 05 00 00 00       	push   0x5
    1089:	f2 e9 91 ff ff ff    	bnd jmp 1020 <__cxa_finalize@plt-0x70>
    108f:	90                   	nop

Disassembly of section .plt.got:

0000000000001090 <__cxa_finalize@plt>:
    1090:	f3 0f 1e fa          	endbr64 
    1094:	f2 ff 25 5d 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f5d]        # 3ff8 <malloc@plt+0x2f08>
    109b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

Disassembly of section .plt.sec:

00000000000010a0 <free@plt>:
    10a0:	f3 0f 1e fa          	endbr64 
    10a4:	f2 ff 25 fd 2e 00 00 	bnd jmp QWORD PTR [rip+0x2efd]        # 3fa8 <malloc@plt+0x2eb8>
    10ab:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000010b0 <puts@plt>:
    10b0:	f3 0f 1e fa          	endbr64 
    10b4:	f2 ff 25 f5 2e 00 00 	bnd jmp QWORD PTR [rip+0x2ef5]        # 3fb0 <malloc@plt+0x2ec0>
    10bb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000010c0 <__stack_chk_fail@plt>:
    10c0:	f3 0f 1e fa          	endbr64 
    10c4:	f2 ff 25 ed 2e 00 00 	bnd jmp QWORD PTR [rip+0x2eed]        # 3fb8 <malloc@plt+0x2ec8>
    10cb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000010d0 <printf@plt>:
    10d0:	f3 0f 1e fa          	endbr64 
    10d4:	f2 ff 25 e5 2e 00 00 	bnd jmp QWORD PTR [rip+0x2ee5]        # 3fc0 <malloc@plt+0x2ed0>
    10db:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000010e0 <memcpy@plt>:
    10e0:	f3 0f 1e fa          	endbr64 
    10e4:	f2 ff 25 dd 2e 00 00 	bnd jmp QWORD PTR [rip+0x2edd]        # 3fc8 <malloc@plt+0x2ed8>
    10eb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000010f0 <malloc@plt>:
    10f0:	f3 0f 1e fa          	endbr64 
    10f4:	f2 ff 25 d5 2e 00 00 	bnd jmp QWORD PTR [rip+0x2ed5]        # 3fd0 <malloc@plt+0x2ee0>
    10fb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

Disassembly of section .text:

0000000000001100 <.text>:
    1100:	f3 0f 1e fa          	endbr64 
    1104:	31 ed                	xor    ebp,ebp
    1106:	49 89 d1             	mov    r9,rdx
    1109:	5e                   	pop    rsi
    110a:	48 89 e2             	mov    rdx,rsp
    110d:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    1111:	50                   	push   rax
    1112:	54                   	push   rsp
    1113:	45 31 c0             	xor    r8d,r8d
    1116:	31 c9                	xor    ecx,ecx
    1118:	48 8d 3d 57 09 00 00 	lea    rdi,[rip+0x957]        # 1a76 <malloc@plt+0x986>
    111f:	ff 15 b3 2e 00 00    	call   QWORD PTR [rip+0x2eb3]        # 3fd8 <malloc@plt+0x2ee8>
    1125:	f4                   	hlt    
    1126:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    112d:	00 00 00 
    1130:	48 8d 3d 01 2f 00 00 	lea    rdi,[rip+0x2f01]        # 4038 <malloc@plt+0x2f48>
    1137:	48 8d 05 fa 2e 00 00 	lea    rax,[rip+0x2efa]        # 4038 <malloc@plt+0x2f48>
    113e:	48 39 f8             	cmp    rax,rdi
    1141:	74 15                	je     1158 <malloc@plt+0x68>
    1143:	48 8b 05 96 2e 00 00 	mov    rax,QWORD PTR [rip+0x2e96]        # 3fe0 <malloc@plt+0x2ef0>
    114a:	48 85 c0             	test   rax,rax
    114d:	74 09                	je     1158 <malloc@plt+0x68>
    114f:	ff e0                	jmp    rax
    1151:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    1158:	c3                   	ret    
    1159:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    1160:	48 8d 3d d1 2e 00 00 	lea    rdi,[rip+0x2ed1]        # 4038 <malloc@plt+0x2f48>
    1167:	48 8d 35 ca 2e 00 00 	lea    rsi,[rip+0x2eca]        # 4038 <malloc@plt+0x2f48>
    116e:	48 29 fe             	sub    rsi,rdi
    1171:	48 89 f0             	mov    rax,rsi
    1174:	48 c1 ee 3f          	shr    rsi,0x3f
    1178:	48 c1 f8 03          	sar    rax,0x3
    117c:	48 01 c6             	add    rsi,rax
    117f:	48 d1 fe             	sar    rsi,1
    1182:	74 14                	je     1198 <malloc@plt+0xa8>
    1184:	48 8b 05 65 2e 00 00 	mov    rax,QWORD PTR [rip+0x2e65]        # 3ff0 <malloc@plt+0x2f00>
    118b:	48 85 c0             	test   rax,rax
    118e:	74 08                	je     1198 <malloc@plt+0xa8>
    1190:	ff e0                	jmp    rax
    1192:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    1198:	c3                   	ret    
    1199:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    11a0:	f3 0f 1e fa          	endbr64 
    11a4:	80 3d 95 2e 00 00 00 	cmp    BYTE PTR [rip+0x2e95],0x0        # 4040 <malloc@plt+0x2f50>
    11ab:	75 2b                	jne    11d8 <malloc@plt+0xe8>
    11ad:	55                   	push   rbp
    11ae:	48 83 3d 42 2e 00 00 	cmp    QWORD PTR [rip+0x2e42],0x0        # 3ff8 <malloc@plt+0x2f08>
    11b5:	00 
    11b6:	48 89 e5             	mov    rbp,rsp
    11b9:	74 0c                	je     11c7 <malloc@plt+0xd7>
    11bb:	48 8b 3d 46 2e 00 00 	mov    rdi,QWORD PTR [rip+0x2e46]        # 4008 <malloc@plt+0x2f18>
    11c2:	e8 c9 fe ff ff       	call   1090 <__cxa_finalize@plt>
    11c7:	e8 64 ff ff ff       	call   1130 <malloc@plt+0x40>
    11cc:	c6 05 6d 2e 00 00 01 	mov    BYTE PTR [rip+0x2e6d],0x1        # 4040 <malloc@plt+0x2f50>
    11d3:	5d                   	pop    rbp
    11d4:	c3                   	ret    
    11d5:	0f 1f 00             	nop    DWORD PTR [rax]
    11d8:	c3                   	ret    
    11d9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    11e0:	f3 0f 1e fa          	endbr64 
    11e4:	e9 77 ff ff ff       	jmp    1160 <malloc@plt+0x70>
    11e9:	f3 0f 1e fa          	endbr64 
    11ed:	55                   	push   rbp
    11ee:	48 89 e5             	mov    rbp,rsp
    11f1:	48 83 ec 10          	sub    rsp,0x10
    11f5:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
    11f8:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
    11fb:	89 c6                	mov    esi,eax
    11fd:	48 8d 05 00 0e 00 00 	lea    rax,[rip+0xe00]        # 2004 <malloc@plt+0xf14>
    1204:	48 89 c7             	mov    rdi,rax
    1207:	b8 00 00 00 00       	mov    eax,0x0
    120c:	e8 bf fe ff ff       	call   10d0 <printf@plt>
    1211:	90                   	nop
    1212:	c9                   	leave  
    1213:	c3                   	ret    
    1214:	f3 0f 1e fa          	endbr64 
    1218:	55                   	push   rbp
    1219:	48 89 e5             	mov    rbp,rsp
    121c:	48 83 ec 10          	sub    rsp,0x10
    1220:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
    1223:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
    1226:	89 c6                	mov    esi,eax
    1228:	48 8d 05 e3 0d 00 00 	lea    rax,[rip+0xde3]        # 2012 <malloc@plt+0xf22>
    122f:	48 89 c7             	mov    rdi,rax
    1232:	b8 00 00 00 00       	mov    eax,0x0
    1237:	e8 94 fe ff ff       	call   10d0 <printf@plt>
    123c:	90                   	nop
    123d:	c9                   	leave  
    123e:	c3                   	ret    
    123f:	f3 0f 1e fa          	endbr64 
    1243:	55                   	push   rbp
    1244:	48 89 e5             	mov    rbp,rsp
    1247:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
    124a:	89 75 f8             	mov    DWORD PTR [rbp-0x8],esi
    124d:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
    1250:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
    1253:	01 d0                	add    eax,edx
    1255:	5d                   	pop    rbp
    1256:	c3                   	ret    
    1257:	f3 0f 1e fa          	endbr64 
    125b:	55                   	push   rbp
    125c:	48 89 e5             	mov    rbp,rsp
    125f:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
    1262:	89 75 f8             	mov    DWORD PTR [rbp-0x8],esi
    1265:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
    1268:	2b 45 f8             	sub    eax,DWORD PTR [rbp-0x8]
    126b:	5d                   	pop    rbp
    126c:	c3                   	ret    
    126d:	f3 0f 1e fa          	endbr64 
    1271:	55                   	push   rbp
    1272:	48 89 e5             	mov    rbp,rsp
    1275:	48 83 ec 10          	sub    rsp,0x10
    1279:	c7 45 f4 0a 00 00 00 	mov    DWORD PTR [rbp-0xc],0xa
    1280:	c7 45 f8 14 00 00 00 	mov    DWORD PTR [rbp-0x8],0x14
    1287:	8b 55 f4             	mov    edx,DWORD PTR [rbp-0xc]
    128a:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
    128d:	01 d0                	add    eax,edx
    128f:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
    1292:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
    1295:	89 45 f4             	mov    DWORD PTR [rbp-0xc],eax
    1298:	c7 45 f0 64 00 00 00 	mov    DWORD PTR [rbp-0x10],0x64
    129f:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
    12a2:	83 c0 01             	add    eax,0x1
    12a5:	89 45 f0             	mov    DWORD PTR [rbp-0x10],eax
    12a8:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
    12ab:	89 c6                	mov    esi,eax
    12ad:	48 8d 05 6b 0d 00 00 	lea    rax,[rip+0xd6b]        # 201f <malloc@plt+0xf2f>
    12b4:	48 89 c7             	mov    rdi,rax
    12b7:	b8 00 00 00 00       	mov    eax,0x0
    12bc:	e8 0f fe ff ff       	call   10d0 <printf@plt>
    12c1:	90                   	nop
    12c2:	c9                   	leave  
    12c3:	c3                   	ret    
    12c4:	f3 0f 1e fa          	endbr64 
    12c8:	55                   	push   rbp
    12c9:	48 89 e5             	mov    rbp,rsp
    12cc:	48 83 ec 10          	sub    rsp,0x10
    12d0:	8b 05 3a 2d 00 00    	mov    eax,DWORD PTR [rip+0x2d3a]        # 4010 <malloc@plt+0x2f20>
    12d6:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
    12d9:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
    12dc:	83 c0 01             	add    eax,0x1
    12df:	89 05 2b 2d 00 00    	mov    DWORD PTR [rip+0x2d2b],eax        # 4010 <malloc@plt+0x2f20>
    12e5:	c6 05 74 2d 00 00 41 	mov    BYTE PTR [rip+0x2d74],0x41        # 4060 <malloc@plt+0x2f70>
    12ec:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
    12ef:	99                   	cdq    
    12f0:	c1 ea 1c             	shr    edx,0x1c
    12f3:	01 d0                	add    eax,edx
    12f5:	83 e0 0f             	and    eax,0xf
    12f8:	29 d0                	sub    eax,edx
    12fa:	48 98                	cdqe   
    12fc:	48 8d 15 5d 2d 00 00 	lea    rdx,[rip+0x2d5d]        # 4060 <malloc@plt+0x2f70>
    1303:	c6 04 10 42          	mov    BYTE PTR [rax+rdx*1],0x42
    1307:	0f b6 05 52 2d 00 00 	movzx  eax,BYTE PTR [rip+0x2d52]        # 4060 <malloc@plt+0x2f70>
    130e:	88 45 fb             	mov    BYTE PTR [rbp-0x5],al
    1311:	0f be 55 fb          	movsx  edx,BYTE PTR [rbp-0x5]
    1315:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
    1318:	89 c6                	mov    esi,eax
    131a:	48 8d 05 09 0d 00 00 	lea    rax,[rip+0xd09]        # 202a <malloc@plt+0xf3a>
    1321:	48 89 c7             	mov    rdi,rax
    1324:	b8 00 00 00 00       	mov    eax,0x0
    1329:	e8 a2 fd ff ff       	call   10d0 <printf@plt>
    132e:	90                   	nop
    132f:	c9                   	leave  
    1330:	c3                   	ret    
    1331:	f3 0f 1e fa          	endbr64 
    1335:	55                   	push   rbp
    1336:	48 89 e5             	mov    rbp,rsp
    1339:	48 83 ec 20          	sub    rsp,0x20
    133d:	bf 04 00 00 00       	mov    edi,0x4
    1342:	e8 a9 fd ff ff       	call   10f0 <malloc@plt>
    1347:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
    134b:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
    134f:	c7 00 2a 00 00 00    	mov    DWORD PTR [rax],0x2a
    1355:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
    1359:	8b 00                	mov    eax,DWORD PTR [rax]
    135b:	89 45 e0             	mov    DWORD PTR [rbp-0x20],eax
    135e:	bf 28 00 00 00       	mov    edi,0x28
    1363:	e8 88 fd ff ff       	call   10f0 <malloc@plt>
    1368:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
    136c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
    1370:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
    1376:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
    137a:	48 83 c0 14          	add    rax,0x14
    137e:	c7 00 32 00 00 00    	mov    DWORD PTR [rax],0x32
    1384:	8b 4d e0             	mov    ecx,DWORD PTR [rbp-0x20]
    1387:	48 63 c1             	movsxd rax,ecx
    138a:	48 69 c0 67 66 66 66 	imul   rax,rax,0x66666667
    1391:	48 c1 e8 20          	shr    rax,0x20
    1395:	c1 f8 02             	sar    eax,0x2
    1398:	89 ce                	mov    esi,ecx
    139a:	c1 fe 1f             	sar    esi,0x1f
    139d:	29 f0                	sub    eax,esi
    139f:	89 c2                	mov    edx,eax
    13a1:	89 d0                	mov    eax,edx
    13a3:	c1 e0 02             	shl    eax,0x2
    13a6:	01 d0                	add    eax,edx
    13a8:	01 c0                	add    eax,eax
    13aa:	29 c1                	sub    ecx,eax
    13ac:	89 ca                	mov    edx,ecx
    13ae:	48 63 c2             	movsxd rax,edx
    13b1:	48 8d 14 85 00 00 00 	lea    rdx,[rax*4+0x0]
    13b8:	00 
    13b9:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
    13bd:	48 01 d0             	add    rax,rdx
    13c0:	c7 00 63 00 00 00    	mov    DWORD PTR [rax],0x63
    13c6:	bf 18 00 00 00       	mov    edi,0x18
    13cb:	e8 20 fd ff ff       	call   10f0 <malloc@plt>
    13d0:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    13d4:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    13d8:	c7 00 01 00 00 00    	mov    DWORD PTR [rax],0x1
    13de:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    13e2:	8b 55 e0             	mov    edx,DWORD PTR [rbp-0x20]
    13e5:	89 50 04             	mov    DWORD PTR [rax+0x4],edx
    13e8:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    13ec:	48 83 c0 08          	add    rax,0x8
    13f0:	c7 00 68 65 61 70    	mov    DWORD PTR [rax],0x70616568
    13f6:	c6 40 04 00          	mov    BYTE PTR [rax+0x4],0x0
    13fa:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    13fe:	8b 00                	mov    eax,DWORD PTR [rax]
    1400:	89 45 e4             	mov    DWORD PTR [rbp-0x1c],eax
    1403:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
    1406:	8b 45 e0             	mov    eax,DWORD PTR [rbp-0x20]
    1409:	89 c6                	mov    esi,eax
    140b:	48 8d 05 28 0c 00 00 	lea    rax,[rip+0xc28]        # 203a <malloc@plt+0xf4a>
    1412:	48 89 c7             	mov    rdi,rax
    1415:	b8 00 00 00 00       	mov    eax,0x0
    141a:	e8 b1 fc ff ff       	call   10d0 <printf@plt>
    141f:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
    1423:	48 89 c7             	mov    rdi,rax
    1426:	e8 75 fc ff ff       	call   10a0 <free@plt>
    142b:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
    142f:	48 89 c7             	mov    rdi,rax
    1432:	e8 69 fc ff ff       	call   10a0 <free@plt>
    1437:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    143b:	48 89 c7             	mov    rdi,rax
    143e:	e8 5d fc ff ff       	call   10a0 <free@plt>
    1443:	90                   	nop
    1444:	c9                   	leave  
    1445:	c3                   	ret    
    1446:	f3 0f 1e fa          	endbr64 
    144a:	55                   	push   rbp
    144b:	48 89 e5             	mov    rbp,rsp
    144e:	48 81 ec a0 00 00 00 	sub    rsp,0xa0
    1455:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    145c:	00 00 
    145e:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    1462:	31 c0                	xor    eax,eax
    1464:	c7 85 60 ff ff ff 05 	mov    DWORD PTR [rbp-0xa0],0x5
    146b:	00 00 00 
    146e:	c7 85 70 ff ff ff 64 	mov    DWORD PTR [rbp-0x90],0x64
    1475:	00 00 00 
    1478:	c7 45 ac c8 00 00 00 	mov    DWORD PTR [rbp-0x54],0xc8
    147f:	8b 85 60 ff ff ff    	mov    eax,DWORD PTR [rbp-0xa0]
    1485:	48 98                	cdqe   
    1487:	c7 84 85 70 ff ff ff 	mov    DWORD PTR [rbp+rax*4-0x90],0x12c
    148e:	2c 01 00 00 
    1492:	8b 85 60 ff ff ff    	mov    eax,DWORD PTR [rbp-0xa0]
    1498:	83 c0 02             	add    eax,0x2
    149b:	48 98                	cdqe   
    149d:	c7 84 85 70 ff ff ff 	mov    DWORD PTR [rbp+rax*4-0x90],0x190
    14a4:	90 01 00 00 
    14a8:	8b 85 70 ff ff ff    	mov    eax,DWORD PTR [rbp-0x90]
    14ae:	89 85 64 ff ff ff    	mov    DWORD PTR [rbp-0x9c],eax
    14b4:	8b 85 60 ff ff ff    	mov    eax,DWORD PTR [rbp-0xa0]
    14ba:	48 98                	cdqe   
    14bc:	8b 84 85 70 ff ff ff 	mov    eax,DWORD PTR [rbp+rax*4-0x90]
    14c3:	89 85 68 ff ff ff    	mov    DWORD PTR [rbp-0x98],eax
    14c9:	c7 45 b0 01 00 00 00 	mov    DWORD PTR [rbp-0x50],0x1
    14d0:	8b 85 60 ff ff ff    	mov    eax,DWORD PTR [rbp-0xa0]
    14d6:	48 63 d0             	movsxd rdx,eax
    14d9:	48 89 d0             	mov    rax,rdx
    14dc:	48 c1 e0 02          	shl    rax,0x2
    14e0:	48 01 d0             	add    rax,rdx
    14e3:	48 c1 e0 02          	shl    rax,0x2
    14e7:	48 01 e8             	add    rax,rbp
    14ea:	48 83 e8 50          	sub    rax,0x50
    14ee:	c7 00 02 00 00 00    	mov    DWORD PTR [rax],0x2
    14f4:	8b 45 c8             	mov    eax,DWORD PTR [rbp-0x38]
    14f7:	89 85 6c ff ff ff    	mov    DWORD PTR [rbp-0x94],eax
    14fd:	8b 8d 6c ff ff ff    	mov    ecx,DWORD PTR [rbp-0x94]
    1503:	8b 95 68 ff ff ff    	mov    edx,DWORD PTR [rbp-0x98]
    1509:	8b 85 64 ff ff ff    	mov    eax,DWORD PTR [rbp-0x9c]
    150f:	89 c6                	mov    esi,eax
    1511:	48 8d 05 30 0b 00 00 	lea    rax,[rip+0xb30]        # 2048 <malloc@plt+0xf58>
    1518:	48 89 c7             	mov    rdi,rax
    151b:	b8 00 00 00 00       	mov    eax,0x0
    1520:	e8 ab fb ff ff       	call   10d0 <printf@plt>
    1525:	90                   	nop
    1526:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    152a:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    1531:	00 00 
    1533:	74 05                	je     153a <malloc@plt+0x44a>
    1535:	e8 86 fb ff ff       	call   10c0 <__stack_chk_fail@plt>
    153a:	c9                   	leave  
    153b:	c3                   	ret    
    153c:	f3 0f 1e fa          	endbr64 
    1540:	55                   	push   rbp
    1541:	48 89 e5             	mov    rbp,rsp
    1544:	48 83 ec 40          	sub    rsp,0x40
    1548:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    154f:	00 00 
    1551:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    1555:	31 c0                	xor    eax,eax
    1557:	c7 45 e0 0a 00 00 00 	mov    DWORD PTR [rbp-0x20],0xa
    155e:	c7 45 e4 14 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x14
    1565:	48 8d 45 e0          	lea    rax,[rbp-0x20]
    1569:	48 83 c0 08          	add    rax,0x8
    156d:	c7 00 6c 6f 63 61    	mov    DWORD PTR [rax],0x61636f6c
    1573:	66 c7 40 04 6c 00    	mov    WORD PTR [rax+0x4],0x6c
    1579:	8b 45 e0             	mov    eax,DWORD PTR [rbp-0x20]
    157c:	89 45 c8             	mov    DWORD PTR [rbp-0x38],eax
    157f:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
    1582:	89 45 cc             	mov    DWORD PTR [rbp-0x34],eax
    1585:	0f b6 45 e8          	movzx  eax,BYTE PTR [rbp-0x18]
    1589:	88 45 c7             	mov    BYTE PTR [rbp-0x39],al
    158c:	48 8d 45 e0          	lea    rax,[rbp-0x20]
    1590:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
    1594:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
    1598:	c7 00 1e 00 00 00    	mov    DWORD PTR [rax],0x1e
    159e:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
    15a2:	8b 00                	mov    eax,DWORD PTR [rax]
    15a4:	89 45 d0             	mov    DWORD PTR [rbp-0x30],eax
    15a7:	8b 45 cc             	mov    eax,DWORD PTR [rbp-0x34]
    15aa:	89 05 74 2a 00 00    	mov    DWORD PTR [rip+0x2a74],eax        # 4024 <malloc@plt+0x2f34>
    15b0:	8b 05 6e 2a 00 00    	mov    eax,DWORD PTR [rip+0x2a6e]        # 4024 <malloc@plt+0x2f34>
    15b6:	89 45 d4             	mov    DWORD PTR [rbp-0x2c],eax
    15b9:	0f be 4d c7          	movsx  ecx,BYTE PTR [rbp-0x39]
    15bd:	8b 75 d4             	mov    esi,DWORD PTR [rbp-0x2c]
    15c0:	8b 55 cc             	mov    edx,DWORD PTR [rbp-0x34]
    15c3:	8b 45 c8             	mov    eax,DWORD PTR [rbp-0x38]
    15c6:	41 89 f0             	mov    r8d,esi
    15c9:	89 c6                	mov    esi,eax
    15cb:	48 8d 05 89 0a 00 00 	lea    rax,[rip+0xa89]        # 205b <malloc@plt+0xf6b>
    15d2:	48 89 c7             	mov    rdi,rax
    15d5:	b8 00 00 00 00       	mov    eax,0x0
    15da:	e8 f1 fa ff ff       	call   10d0 <printf@plt>
    15df:	90                   	nop
    15e0:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    15e4:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    15eb:	00 00 
    15ed:	74 05                	je     15f4 <malloc@plt+0x504>
    15ef:	e8 cc fa ff ff       	call   10c0 <__stack_chk_fail@plt>
    15f4:	c9                   	leave  
    15f5:	c3                   	ret    
    15f6:	f3 0f 1e fa          	endbr64 
    15fa:	55                   	push   rbp
    15fb:	48 89 e5             	mov    rbp,rsp
    15fe:	48 83 ec 70          	sub    rsp,0x70
    1602:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1609:	00 00 
    160b:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    160f:	31 c0                	xor    eax,eax
    1611:	c7 45 98 0a 00 00 00 	mov    DWORD PTR [rbp-0x68],0xa
    1618:	48 8d 45 98          	lea    rax,[rbp-0x68]
    161c:	48 89 45 b0          	mov    QWORD PTR [rbp-0x50],rax
    1620:	48 8d 45 b0          	lea    rax,[rbp-0x50]
    1624:	48 89 45 b8          	mov    QWORD PTR [rbp-0x48],rax
    1628:	48 8d 45 b8          	lea    rax,[rbp-0x48]
    162c:	48 89 45 c0          	mov    QWORD PTR [rbp-0x40],rax
    1630:	48 8b 45 b0          	mov    rax,QWORD PTR [rbp-0x50]
    1634:	c7 00 14 00 00 00    	mov    DWORD PTR [rax],0x14
    163a:	48 8b 45 b8          	mov    rax,QWORD PTR [rbp-0x48]
    163e:	48 8b 00             	mov    rax,QWORD PTR [rax]
    1641:	c7 00 1e 00 00 00    	mov    DWORD PTR [rax],0x1e
    1647:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
    164b:	48 8b 00             	mov    rax,QWORD PTR [rax]
    164e:	48 8b 00             	mov    rax,QWORD PTR [rax]
    1651:	c7 00 28 00 00 00    	mov    DWORD PTR [rax],0x28
    1657:	48 8b 45 b0          	mov    rax,QWORD PTR [rbp-0x50]
    165b:	8b 00                	mov    eax,DWORD PTR [rax]
    165d:	89 45 9c             	mov    DWORD PTR [rbp-0x64],eax
    1660:	48 8b 45 b8          	mov    rax,QWORD PTR [rbp-0x48]
    1664:	48 8b 00             	mov    rax,QWORD PTR [rax]
    1667:	8b 00                	mov    eax,DWORD PTR [rax]
    1669:	89 45 a0             	mov    DWORD PTR [rbp-0x60],eax
    166c:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
    1670:	48 8b 00             	mov    rax,QWORD PTR [rax]
    1673:	48 8b 00             	mov    rax,QWORD PTR [rax]
    1676:	8b 00                	mov    eax,DWORD PTR [rax]
    1678:	89 45 a4             	mov    DWORD PTR [rbp-0x5c],eax
    167b:	c7 45 d0 00 00 00 00 	mov    DWORD PTR [rbp-0x30],0x0
    1682:	c7 45 d4 01 00 00 00 	mov    DWORD PTR [rbp-0x2c],0x1
    1689:	c7 45 d8 02 00 00 00 	mov    DWORD PTR [rbp-0x28],0x2
    1690:	c7 45 dc 03 00 00 00 	mov    DWORD PTR [rbp-0x24],0x3
    1697:	c7 45 e0 04 00 00 00 	mov    DWORD PTR [rbp-0x20],0x4
    169e:	c7 45 e4 05 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x5
    16a5:	c7 45 e8 06 00 00 00 	mov    DWORD PTR [rbp-0x18],0x6
    16ac:	c7 45 ec 07 00 00 00 	mov    DWORD PTR [rbp-0x14],0x7
    16b3:	c7 45 f0 08 00 00 00 	mov    DWORD PTR [rbp-0x10],0x8
    16ba:	c7 45 f4 09 00 00 00 	mov    DWORD PTR [rbp-0xc],0x9
    16c1:	48 8d 45 d0          	lea    rax,[rbp-0x30]
    16c5:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
    16c9:	48 83 45 c8 0c       	add    QWORD PTR [rbp-0x38],0xc
    16ce:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
    16d2:	8b 00                	mov    eax,DWORD PTR [rax]
    16d4:	89 45 a8             	mov    DWORD PTR [rbp-0x58],eax
    16d7:	48 83 6d c8 04       	sub    QWORD PTR [rbp-0x38],0x4
    16dc:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
    16e0:	8b 00                	mov    eax,DWORD PTR [rax]
    16e2:	89 45 ac             	mov    DWORD PTR [rbp-0x54],eax
    16e5:	8b 7d ac             	mov    edi,DWORD PTR [rbp-0x54]
    16e8:	8b 75 a8             	mov    esi,DWORD PTR [rbp-0x58]
    16eb:	8b 4d a4             	mov    ecx,DWORD PTR [rbp-0x5c]
    16ee:	8b 55 a0             	mov    edx,DWORD PTR [rbp-0x60]
    16f1:	8b 45 9c             	mov    eax,DWORD PTR [rbp-0x64]
    16f4:	41 89 f9             	mov    r9d,edi
    16f7:	41 89 f0             	mov    r8d,esi
    16fa:	89 c6                	mov    esi,eax
    16fc:	48 8d 05 70 09 00 00 	lea    rax,[rip+0x970]        # 2073 <malloc@plt+0xf83>
    1703:	48 89 c7             	mov    rdi,rax
    1706:	b8 00 00 00 00       	mov    eax,0x0
    170b:	e8 c0 f9 ff ff       	call   10d0 <printf@plt>
    1710:	90                   	nop
    1711:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    1715:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    171c:	00 00 
    171e:	74 05                	je     1725 <malloc@plt+0x635>
    1720:	e8 9b f9 ff ff       	call   10c0 <__stack_chk_fail@plt>
    1725:	c9                   	leave  
    1726:	c3                   	ret    
    1727:	f3 0f 1e fa          	endbr64 
    172b:	55                   	push   rbp
    172c:	48 89 e5             	mov    rbp,rsp
    172f:	48 83 ec 40          	sub    rsp,0x40
    1733:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    173a:	00 00 
    173c:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    1740:	31 c0                	xor    eax,eax
    1742:	48 8d 05 a0 fa ff ff 	lea    rax,[rip+0xfffffffffffffaa0]        # 11e9 <malloc@plt+0xf9>
    1749:	48 89 45 d0          	mov    QWORD PTR [rbp-0x30],rax
    174d:	48 8d 05 eb fa ff ff 	lea    rax,[rip+0xfffffffffffffaeb]        # 123f <malloc@plt+0x14f>
    1754:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
    1758:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
    175c:	bf 64 00 00 00       	mov    edi,0x64
    1761:	ff d0                	call   rax
    1763:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
    1767:	be 14 00 00 00       	mov    esi,0x14
    176c:	bf 0a 00 00 00       	mov    edi,0xa
    1771:	ff d0                	call   rax
    1773:	89 45 cc             	mov    DWORD PTR [rbp-0x34],eax
    1776:	48 8d 05 6c fa ff ff 	lea    rax,[rip+0xfffffffffffffa6c]        # 11e9 <malloc@plt+0xf9>
    177d:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
    1781:	48 8d 05 8c fa ff ff 	lea    rax,[rip+0xfffffffffffffa8c]        # 1214 <malloc@plt+0x124>
    1788:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
    178c:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
    1790:	bf 01 00 00 00       	mov    edi,0x1
    1795:	ff d0                	call   rax
    1797:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
    179b:	bf 02 00 00 00       	mov    edi,0x2
    17a0:	ff d0                	call   rax
    17a2:	48 8d 05 40 fa ff ff 	lea    rax,[rip+0xfffffffffffffa40]        # 11e9 <malloc@plt+0xf9>
    17a9:	48 89 05 f8 28 00 00 	mov    QWORD PTR [rip+0x28f8],rax        # 40a8 <malloc@plt+0x2fb8>
    17b0:	48 8b 05 f1 28 00 00 	mov    rax,QWORD PTR [rip+0x28f1]        # 40a8 <malloc@plt+0x2fb8>
    17b7:	48 85 c0             	test   rax,rax
    17ba:	74 09                	je     17c5 <malloc@plt+0x6d5>
    17bc:	48 8b 05 e5 28 00 00 	mov    rax,QWORD PTR [rip+0x28e5]        # 40a8 <malloc@plt+0x2fb8>
    17c3:	ff d0                	call   rax
    17c5:	8b 45 cc             	mov    eax,DWORD PTR [rbp-0x34]
    17c8:	89 c6                	mov    esi,eax
    17ca:	48 8d 05 bf 08 00 00 	lea    rax,[rip+0x8bf]        # 2090 <malloc@plt+0xfa0>
    17d1:	48 89 c7             	mov    rdi,rax
    17d4:	b8 00 00 00 00       	mov    eax,0x0
    17d9:	e8 f2 f8 ff ff       	call   10d0 <printf@plt>
    17de:	90                   	nop
    17df:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    17e3:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    17ea:	00 00 
    17ec:	74 05                	je     17f3 <malloc@plt+0x703>
    17ee:	e8 cd f8 ff ff       	call   10c0 <__stack_chk_fail@plt>
    17f3:	c9                   	leave  
    17f4:	c3                   	ret    
    17f5:	f3 0f 1e fa          	endbr64 
    17f9:	55                   	push   rbp
    17fa:	48 89 e5             	mov    rbp,rsp
    17fd:	48 83 ec 70          	sub    rsp,0x70
    1801:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1808:	00 00 
    180a:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    180e:	31 c0                	xor    eax,eax
    1810:	c7 45 9c 00 00 00 00 	mov    DWORD PTR [rbp-0x64],0x0
    1817:	eb 4d                	jmp    1866 <malloc@plt+0x776>
    1819:	8b 45 9c             	mov    eax,DWORD PTR [rbp-0x64]
    181c:	48 63 d0             	movsxd rdx,eax
    181f:	48 89 d0             	mov    rax,rdx
    1822:	48 01 c0             	add    rax,rax
    1825:	48 01 d0             	add    rax,rdx
    1828:	48 c1 e0 03          	shl    rax,0x3
    182c:	48 01 e8             	add    rax,rbp
    182f:	48 8d 50 b0          	lea    rdx,[rax-0x50]
    1833:	8b 45 9c             	mov    eax,DWORD PTR [rbp-0x64]
    1836:	89 02                	mov    DWORD PTR [rdx],eax
    1838:	8b 55 9c             	mov    edx,DWORD PTR [rbp-0x64]
    183b:	89 d0                	mov    eax,edx
    183d:	c1 e0 02             	shl    eax,0x2
    1840:	01 d0                	add    eax,edx
    1842:	01 c0                	add    eax,eax
    1844:	89 c1                	mov    ecx,eax
    1846:	8b 45 9c             	mov    eax,DWORD PTR [rbp-0x64]
    1849:	48 63 d0             	movsxd rdx,eax
    184c:	48 89 d0             	mov    rax,rdx
    184f:	48 01 c0             	add    rax,rax
    1852:	48 01 d0             	add    rax,rdx
    1855:	48 c1 e0 03          	shl    rax,0x3
    1859:	48 01 e8             	add    rax,rbp
    185c:	48 83 e8 4c          	sub    rax,0x4c
    1860:	89 08                	mov    DWORD PTR [rax],ecx
    1862:	83 45 9c 01          	add    DWORD PTR [rbp-0x64],0x1
    1866:	83 7d 9c 02          	cmp    DWORD PTR [rbp-0x64],0x2
    186a:	7e ad                	jle    1819 <malloc@plt+0x729>
    186c:	bf 10 00 00 00       	mov    edi,0x10
    1871:	e8 7a f8 ff ff       	call   10f0 <malloc@plt>
    1876:	48 89 45 a8          	mov    QWORD PTR [rbp-0x58],rax
    187a:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
    187e:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
    1884:	bf 10 00 00 00       	mov    edi,0x10
    1889:	e8 62 f8 ff ff       	call   10f0 <malloc@plt>
    188e:	48 89 c2             	mov    rdx,rax
    1891:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
    1895:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
    1899:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
    189d:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    18a1:	c7 00 01 00 00 00    	mov    DWORD PTR [rax],0x1
    18a7:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
    18ab:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    18af:	48 c7 40 08 00 00 00 	mov    QWORD PTR [rax+0x8],0x0
    18b6:	00 
    18b7:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
    18bb:	48 89 45 a0          	mov    QWORD PTR [rbp-0x60],rax
    18bf:	eb 1b                	jmp    18dc <malloc@plt+0x7ec>
    18c1:	48 8b 45 a0          	mov    rax,QWORD PTR [rbp-0x60]
    18c5:	8b 00                	mov    eax,DWORD PTR [rax]
    18c7:	8d 50 01             	lea    edx,[rax+0x1]
    18ca:	48 8b 45 a0          	mov    rax,QWORD PTR [rbp-0x60]
    18ce:	89 10                	mov    DWORD PTR [rax],edx
    18d0:	48 8b 45 a0          	mov    rax,QWORD PTR [rbp-0x60]
    18d4:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    18d8:	48 89 45 a0          	mov    QWORD PTR [rbp-0x60],rax
    18dc:	48 83 7d a0 00       	cmp    QWORD PTR [rbp-0x60],0x0
    18e1:	75 de                	jne    18c1 <malloc@plt+0x7d1>
    18e3:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
    18e7:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    18eb:	48 89 c7             	mov    rdi,rax
    18ee:	e8 ad f7 ff ff       	call   10a0 <free@plt>
    18f3:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
    18f7:	48 89 c7             	mov    rdi,rax
    18fa:	e8 a1 f7 ff ff       	call   10a0 <free@plt>
    18ff:	48 8d 05 97 07 00 00 	lea    rax,[rip+0x797]        # 209d <malloc@plt+0xfad>
    1906:	48 89 c7             	mov    rdi,rax
    1909:	e8 a2 f7 ff ff       	call   10b0 <puts@plt>
    190e:	90                   	nop
    190f:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    1913:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    191a:	00 00 
    191c:	74 05                	je     1923 <malloc@plt+0x833>
    191e:	e8 9d f7 ff ff       	call   10c0 <__stack_chk_fail@plt>
    1923:	c9                   	leave  
    1924:	c3                   	ret    
    1925:	f3 0f 1e fa          	endbr64 
    1929:	55                   	push   rbp
    192a:	48 89 e5             	mov    rbp,rsp
    192d:	48 83 c4 80          	add    rsp,0xffffffffffffff80
    1931:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1938:	00 00 
    193a:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    193e:	31 c0                	xor    eax,eax
    1940:	48 b8 48 65 6c 6c 6f 	movabs rax,0x57202c6f6c6c6548
    1947:	2c 20 57 
    194a:	48 ba 6f 72 6c 64 21 	movabs rdx,0x21646c726f
    1951:	00 00 00 
    1954:	48 89 45 90          	mov    QWORD PTR [rbp-0x70],rax
    1958:	48 89 55 98          	mov    QWORD PTR [rbp-0x68],rdx
    195c:	48 c7 45 a0 00 00 00 	mov    QWORD PTR [rbp-0x60],0x0
    1963:	00 
    1964:	48 c7 45 a8 00 00 00 	mov    QWORD PTR [rbp-0x58],0x0
    196b:	00 
    196c:	c7 45 8c 00 00 00 00 	mov    DWORD PTR [rbp-0x74],0x0
    1973:	eb 17                	jmp    198c <malloc@plt+0x89c>
    1975:	8b 45 8c             	mov    eax,DWORD PTR [rbp-0x74]
    1978:	48 98                	cdqe   
    197a:	0f b6 54 05 90       	movzx  edx,BYTE PTR [rbp+rax*1-0x70]
    197f:	8b 45 8c             	mov    eax,DWORD PTR [rbp-0x74]
    1982:	48 98                	cdqe   
    1984:	88 54 05 b0          	mov    BYTE PTR [rbp+rax*1-0x50],dl
    1988:	83 45 8c 01          	add    DWORD PTR [rbp-0x74],0x1
    198c:	83 7d 8c 0d          	cmp    DWORD PTR [rbp-0x74],0xd
    1990:	7e e3                	jle    1975 <malloc@plt+0x885>
    1992:	48 8d 4d 90          	lea    rcx,[rbp-0x70]
    1996:	48 8d 45 d0          	lea    rax,[rbp-0x30]
    199a:	ba 0e 00 00 00       	mov    edx,0xe
    199f:	48 89 ce             	mov    rsi,rcx
    19a2:	48 89 c7             	mov    rdi,rax
    19a5:	e8 36 f7 ff ff       	call   10e0 <memcpy@plt>
    19aa:	48 8d 45 b0          	lea    rax,[rbp-0x50]
    19ae:	48 89 c6             	mov    rsi,rax
    19b1:	48 8d 05 f3 06 00 00 	lea    rax,[rip+0x6f3]        # 20ab <malloc@plt+0xfbb>
    19b8:	48 89 c7             	mov    rdi,rax
    19bb:	b8 00 00 00 00       	mov    eax,0x0
    19c0:	e8 0b f7 ff ff       	call   10d0 <printf@plt>
    19c5:	90                   	nop
    19c6:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    19ca:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    19d1:	00 00 
    19d3:	74 05                	je     19da <malloc@plt+0x8ea>
    19d5:	e8 e6 f6 ff ff       	call   10c0 <__stack_chk_fail@plt>
    19da:	c9                   	leave  
    19db:	c3                   	ret    
    19dc:	f3 0f 1e fa          	endbr64 
    19e0:	55                   	push   rbp
    19e1:	48 89 e5             	mov    rbp,rsp
    19e4:	48 83 ec 30          	sub    rsp,0x30
    19e8:	89 7d dc             	mov    DWORD PTR [rbp-0x24],edi
    19eb:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    19f2:	00 00 
    19f4:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    19f8:	31 c0                	xor    eax,eax
    19fa:	c7 45 e4 0a 00 00 00 	mov    DWORD PTR [rbp-0x1c],0xa
    1a01:	c7 45 e8 14 00 00 00 	mov    DWORD PTR [rbp-0x18],0x14
    1a08:	83 7d dc 00          	cmp    DWORD PTR [rbp-0x24],0x0
    1a0c:	7e 08                	jle    1a16 <malloc@plt+0x926>
    1a0e:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
    1a11:	89 45 ec             	mov    DWORD PTR [rbp-0x14],eax
    1a14:	eb 06                	jmp    1a1c <malloc@plt+0x92c>
    1a16:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
    1a19:	89 45 ec             	mov    DWORD PTR [rbp-0x14],eax
    1a1c:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
    1a23:	00 
    1a24:	83 7d dc 00          	cmp    DWORD PTR [rbp-0x24],0x0
    1a28:	74 0a                	je     1a34 <malloc@plt+0x944>
    1a2a:	48 8d 45 e4          	lea    rax,[rbp-0x1c]
    1a2e:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
    1a32:	eb 08                	jmp    1a3c <malloc@plt+0x94c>
    1a34:	48 8d 45 e8          	lea    rax,[rbp-0x18]
    1a38:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
    1a3c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
    1a40:	c7 00 64 00 00 00    	mov    DWORD PTR [rax],0x64
    1a46:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
    1a49:	89 c6                	mov    esi,eax
    1a4b:	48 8d 05 63 06 00 00 	lea    rax,[rip+0x663]        # 20b5 <malloc@plt+0xfc5>
    1a52:	48 89 c7             	mov    rdi,rax
    1a55:	b8 00 00 00 00       	mov    eax,0x0
    1a5a:	e8 71 f6 ff ff       	call   10d0 <printf@plt>
    1a5f:	90                   	nop
    1a60:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    1a64:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    1a6b:	00 00 
    1a6d:	74 05                	je     1a74 <malloc@plt+0x984>
    1a6f:	e8 4c f6 ff ff       	call   10c0 <__stack_chk_fail@plt>
    1a74:	c9                   	leave  
    1a75:	c3                   	ret    
    1a76:	f3 0f 1e fa          	endbr64 
    1a7a:	55                   	push   rbp
    1a7b:	48 89 e5             	mov    rbp,rsp
    1a7e:	48 83 ec 10          	sub    rsp,0x10
    1a82:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
    1a85:	48 89 75 f0          	mov    QWORD PTR [rbp-0x10],rsi
    1a89:	48 8d 05 36 06 00 00 	lea    rax,[rip+0x636]        # 20c6 <malloc@plt+0xfd6>
    1a90:	48 89 c7             	mov    rdi,rax
    1a93:	e8 18 f6 ff ff       	call   10b0 <puts@plt>
    1a98:	e8 d0 f7 ff ff       	call   126d <malloc@plt+0x17d>
    1a9d:	e8 22 f8 ff ff       	call   12c4 <malloc@plt+0x1d4>
    1aa2:	e8 8a f8 ff ff       	call   1331 <malloc@plt+0x241>
    1aa7:	e8 9a f9 ff ff       	call   1446 <malloc@plt+0x356>
    1aac:	e8 8b fa ff ff       	call   153c <malloc@plt+0x44c>
    1ab1:	e8 40 fb ff ff       	call   15f6 <malloc@plt+0x506>
    1ab6:	e8 6c fc ff ff       	call   1727 <malloc@plt+0x637>
    1abb:	e8 35 fd ff ff       	call   17f5 <malloc@plt+0x705>
    1ac0:	e8 60 fe ff ff       	call   1925 <malloc@plt+0x835>
    1ac5:	83 7d fc 01          	cmp    DWORD PTR [rbp-0x4],0x1
    1ac9:	0f 9f c0             	setg   al
    1acc:	0f b6 c0             	movzx  eax,al
    1acf:	89 c7                	mov    edi,eax
    1ad1:	e8 06 ff ff ff       	call   19dc <malloc@plt+0x8ec>
    1ad6:	48 8d 05 04 06 00 00 	lea    rax,[rip+0x604]        # 20e1 <malloc@plt+0xff1>
    1add:	48 89 c7             	mov    rdi,rax
    1ae0:	e8 cb f5 ff ff       	call   10b0 <puts@plt>
    1ae5:	b8 00 00 00 00       	mov    eax,0x0
    1aea:	c9                   	leave  
    1aeb:	c3                   	ret    

Disassembly of section .fini:

0000000000001aec <.fini>:
    1aec:	f3 0f 1e fa          	endbr64 
    1af0:	48 83 ec 08          	sub    rsp,0x8
    1af4:	48 83 c4 08          	add    rsp,0x8
    1af8:	c3                   	ret    
