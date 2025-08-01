.include "macros.S"

MAKEPATCH 0x00001880 # init hook
0:
	bla 0xadec
9:

MAKEPATCH 0x00001E78 # vfuse
0:
	bla 0xAE3C
9:

MAKEPATCH 0x00001E8C # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x000090A8 # vfuse
0: 
	bla 0xAE3C
9:

MAKEPATCH 0x000090D8 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00009248 # vfuse
0:
	bla 0xAE3C
9:

MAKEPATCH 0x00009278 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00009398 # vfuse
0:
	bla 0xAE3C
9:

MAKEPATCH 0x000093C8 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00009638 # vfuse
0:
	bla 0xAE3C
9:

MAKEPATCH 0x00009668 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x000099A8 # vfuse
0:
	bla 0xAE3C
9:

MAKEPATCH 0x000099D8 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00009A68 # vfuse
0:
	bla 0xAE3C
9:

MAKEPATCH 0x00009A98 # vfuse
0:
	addi r11, r11, 1
	sldi r9, r9, 3
	cmpwi cr6, r11, 0xc
9:

MAKEPATCH 0x00009D68 # vfuse
0:
	bla 0xAE3C
9:

MAKEPATCH 0x00009D94 # vfuse
0:
	addi r11, r11, 1
	sldi r9, r9, 3
	cmpwi cr6, r11, 0xc
9:

MAKEPATCH 0x000000F0 # devkit xex key
0:
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
	.long 0x00000000
9:

MAKEPATCH 0x000011BC
0:
	ba 0x154c
9:

MAKEPATCH 0x0000154C
0:
	li r4, 7
	andc r1, r1, r4
	mtspr 0x3b5, r1
	ba 0x11c0
9:

MAKEPATCH 0x00002BE4
0:
	nop
9:

MAKEPATCH 0x00009E58 # HvxLockL2
0:
	li r3, 1
	blr 
9:

MAKEPATCH 0x0002A26C # HvxLoadImageData
0:
	nop 
	nop 
9:

MAKEPATCH 0x0002A9E0 # HvxResolveImports
0:
	nop 
9:

MAKEPATCH 0x0002A9EC # HvxResolveImports
0:
	nop 
9:

MAKEPATCH 0x0000ADEC
0:
	mflr    r8											# 0xADEC
	lhz     r3, 6(0)									# 0xADF0
	li      r4, 0x21									# 0xADF4
	andc    r3, r3, r4									# 0xADF8
	sth     r3, 6(0)									# 0xADFC
	bla     0x68c    # HvpGetFlashBase					# 0xAE00
	lwz     r4, 0x64(r3)								# 0xAE04
	lwz     r5, 0x70(r3)								# 0xAE08
	add     r3, r3, r4									# 0xAE0C
	add     r4, r3, r5									# 0xAE10
	lis     r3, 1										# 0xAE14
	addi    r3, r3, -0x60								# 0xAE18
	li      r5, 0xc										# 0xAE1C
	bla     0x484    # CopyBy64							# 0xAE20
	li      r3, 0x21									# 0xAE24
	bla     0xAE48										# 0xAE28
	li      r3, 0xA										# 0xAE2C
	bla     0xAE48										# 0xAE30
	mtlr    r8											# 0xAE34
	ba      0x2d8    # resume init sequence				# 0xAE38

	lis     r3, 1										# 0xAE3C
	addi    r3, r3, -0x60								# 0xAE40
	blr													# 0xAE44

	lis     r4, -0x8000									# 0xAE48
	ori     r4, r4, 0x200								# 0xAE4C
	sldi    r4, r4, 0x20								# 0xAE50
	oris    r4, r4, 0xEA00								# 0xAE54
	slwi    r3, r3, 0x18								# 0xAE58
	stw     r3, 0x1014(r4)								# 0xAE5C
						
	lwz     r3, 0x1018(r4)								# 0xAE60
	rlwinm. r3, r3, 0, 6, 6								# 0xAE64
	MAKEBEQNOCR 0xAE60									# 0xAE68
	blr													# 0xAE6C

	lis     r11, 0x7262									# 0xAE70
	ori     r11, r11, 0x7472							# 0xAE74
	cmplw   cr6, r3, r11								# 0xAE78
	MAKEBEQ 0xAE84										# 0xAE7C
	ba      0x1E30    # HvxGetVersions					# 0xAE80

#checkOpType:
	cmplwi  cr6, r4, 4									# 0xAE84
	MAKEBGT 0xAF1C    # doMemCpy						# 0xAE88
	MAKEBEQ 0xAED0    # hvxExecuteCode					# 0xAE8C
	li      r5, 0x154c  # Hv_setmemprot					# 0xAE90
	lis     r6, 0x3880									# 0xAE94
	cmplwi  cr6, r4, 2									# 0xAE98
	MAKEBNE 0xAEA8    # checkforMemProtectOn			# 0xAE9C
	ori     r6, r6, 7									# 0xAEA0
	MAKEBRANCH 0xAEB0  # setMemProtections				# 0xAEA4

#checkforMemProtectOn:
	cmplwi  cr6, r4, 3									# 0xAEA8
	MAKEBNE 0xAEC8    # returnOne						# 0xAEAC

#setMemProtections:
	li      r0, 0										# 0xAEB0
	stw     r6, 0(r5)									# 0xAEB4
	dcbst   0, r5										# 0xAEB8
	icbi    0, r5										# 0xAEBC
	sync												# 0xAEC0
	isync												# 0xAEC4

#returnOne:
	li      r3, 1										# 0xAEC8
	blr													# 0xAECC

#hvxExecuteCode:
	mflr    r12											# 0xAED0
	std     r12, -8(r1)									# 0xAED4
	stdu    r1, -0x10(r1)								# 0xAED8
	mtlr    r5											# 0xAEDC
	mtctr   r7											# 0xAEE0

#cpyLoop:
	lwz     r4, 0(r6)									# 0xAEE4
	stw     r4, 0(r5)									# 0xAEE8
	dcbst   0, r5										# 0xAEEC
	icbi    0, r5										# 0xAEF0
	sync												# 0xAEF4
	isync												# 0xAEF8
	addi    r5, r5, 4									# 0xAEFC
	addi    r6, r6, 4									# 0xAF00
	MAKEBDNZ 0xAEE4										# 0xAF04
	blr													# 0xAF08
	addi    r1, r1, 0x10								# 0xAF0C
	ld      r12, -8(r1)									# 0xAF10
	mtlr    r12											# 0xAF14
	blr													# 0xAF18

#doMemCpy:
	cmplwi  cr6, r4, 5									# 0xAF1C
	MAKEBNE 0xAF34    # returnTwo						# 0xAF20
	mr      r3, r6										# 0xAF24
	mr      r4, r5										# 0xAF28
	mr      r5, r7										# 0xAF2C
	ba      0xA180    # HV_memcpy						# 0xAF30
					
#returnTwo:					
	li      r3, 2										# 0xAF34
	blr													# 0xAF38

9:

MAKEPATCH 0x00015B70 # syscall 0
0:
	.long 0x0000AE70
9:

MAKEPATCH 0x00006578 # HvxSecuritySetDetected
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00006608 # HvxSecurityGetDetected
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00006650 # HvxSecuritySetActivated
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x000066B8 # HvxSecurityGetActivated
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00006700 # HvxSetStat
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00007A6C #  HvxKeysRsaPrvCrypt
0:
	MAKEBRANCH 0x7a9c
9:

MAKEPATCH 0x00006A64
0:
	li r3, 1 # Bypass CB sig check
9: 

MAKEPATCH 0x00006B94
0:
	nop
9:

MAKEPATCH 0x00006C10
0:
	li r3, 0
9:

MAKEPATCH 0x00006C5C
0:
	nop
9:

MAKEPATCH 0x00006C6C
0:
	nop
9:

MAKEPATCH 0x00006C94
0:
	nop 
	li r11, 1
9:

MAKEPATCH 0x00024CB8 # HvpCompareXGD2MediaID
0:
	li r3, 1
	blr 
9:

MAKEPATCH 0x00026450 # HvpDvdDecryptFcrt
0:
	li r3, 1
9:

MAKEPATCH 0x00029A68
0:
	cmpldi cr6, r28, 0
	MAKEBEQ 0x29a9c
	cmpwi cr6, r3, 0
	MAKEBNE 0x29a84
	li r4, 0xf0
	MAKEBRANCH 0x29a94
	nop 
	cmplwi cr6, r29, 0
	addi r4, r31, 0x440
	MAKEBNE 0x29a94
	li r4, 0x54
	mr r3, r28
	MAKEBRANCHL 0x200f8
	li r31, 0
9:

MAKEPATCH 0x0002B6D0 # HvxImageTransformImageKey
0:
	nop 
9:

MAKEPATCH 0x0002BFE8 # HvxCreateImageMapping
0:
	li r3, 0
9:

MAKEPATCH 0x0002C280 # HvxCreateImageMapping
0:
	nop 
9:

MAKEPATCH 0x0003089C # HvxInstallExpansion
0:
	MAKEBNE 0x308a4
	li r29, 0
	nop 
	nop 
9:

MAKEPATCH 0x000304E8 # HvpInstallExpansion
0:
	nop 
9:

MAKEPATCH 0x000304FC # HvpInstallExpansion
0:
	nop 
9:

KMAKEPATCH 0x8007AC80
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x8007B818
0:
	li r3, 1
9:

KMAKEPATCH 0x8007B928
0:
	li r3, 0
9:

KMAKEPATCH 0x8007B990
0:
	li r11, 0
9:

KMAKEPATCH 0x8007B9E0
0:
	li r11, 0
9:

KMAKEPATCH 0x8007C850
0:
	li r3, 0
9:

KMAKEPATCH 0x80093FD8
0:
	li r23, 0x10
9:

KMAKEPATCH 0x800988F8
0:
	cmplwi cr6, r11, 0xff
9:

KMAKEPATCH 0x800982DC # SataDiskReadLogoBitmap
0:
	li r3, 0
	nop 
	nop 
	nop 
	nop 
9:

KMAKEPATCH 0x80109A80
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x8010A578
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x8010A858
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x8010AD20
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x8010AED8
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x8010AF28
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x8010B068
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x8010B1E8
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x8010BD10
0:
	cmplwi cr6, r5, 0
	li r3, 1
	KMAKEBEQ 0x8010BD20
	stw r3, 0(r5)
	blr 
9:

KMAKEPATCH 0x801106B0
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x80156D70
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x8010BD30 # in body of XeKeysConsoleSignatureVerification
0:
    KMAKEBGE 0x8010BD38      					# 0x10BD30
    blr                        					# 0x10BD34
    lis     r3, -0x7FF0        					# 0x10BD38
    lis     r5, 0               				# 0x10BD3C
    li      r4, 0               				# 0x10BD40
    ori     r4, r4, 8           				# 0x10BD44
    ori     r3, r3, 0xBDC0      				# 0x10BD48
    li      r6, 0               				# 0x10BD4C
    KMAKEBRANCHL      0x8007CA60            	# 0x10BD50
    li      r3, 0               				# 0x10BD54
    lis     r4, -0x7FF0         				# 0x10BD58
    ori     r4, r4, 0xBDDC      				# 0x10BD5C
    isync                      					# 0x10BD60
    stw     r3, 0(r4)           				# 0x10BD64
    KMAKEBRANCH       0x8006139c          		# 0x10BD68
    addi    r5, r1, 0x54        				# 0x10BD6C
    lis     r7, -0x7FF0         				# 0x10BD70
    ori     r7, r7, 0xBDDC      				# 0x10BD74
    lwz     r8, 0(r7)           				# 0x10BD78
    isync                      					# 0x10BD7C
    cmplwi  cr6, r8, 0          				# 0x10BD80
    KMAKEBEQ 0x8010BD90       					# 0x10BD84
    mr      r31, r31            				# 0x10BD88
    KMAKEBRANCH       0x8010BD78            	# 0x10BD8C
    blr                        					# 0x10BD90
    cmplwi  cr6, r3, 0x14       				# 0x10BD94
    KMAKEBNE 0x8010BDBC     					# 0x10BD98
    lis     r7, -0x7FF0         				# 0x10BD9C
    ori     r7, r7, 0xBDDC      				# 0x10BDA0
    lwz     r8, 0(r7)           				# 0x10BDA4
    isync                      					# 0x10BDA8
    cmplwi  cr6, r8, 0          				# 0x10BDAC
    KMAKEBEQ 0x8010BDBC       					# 0x10BDB0
    mr      r31, r31            				# 0x10BDB4
    KMAKEBRANCH       0x8010BDA4          		# 0x10BDB8
    KMAKEBRANCH       0x80108230          		# 0x10BDBC
    .long   0x5C446576          				# 0x10BDC0
    .long   0x6963655C          				# 0x10BDC4
    .long   0x466C6173          				# 0x10BDC8
    .long   0x685C6C61          				# 0x10BDCC
    .long   0x756E6368          				# 0x10BDD0
    .long   0x2E786578          				# 0x10BDD4
    .long   0x00000000          				# 0x10BDD8
    .long   0x12345678          				# 0x10BDDC
9:

KMAKEPATCH 0x8006138C
0:
	KMAKEBRANCHL 0x8010BD30
9:

MAKEPATCH 0x0007CA98 # XexLoadExecutable # pointing into dead body of XeKeysConsoleSignatureVerification
0:
	KMAKEBRANCHL 0x8010BD6C
9:

KMAKEPATCH 0x80108CC8
0:
	KMAKEBRANCH 0x8010BD94
9:

.long 0xffffffff
