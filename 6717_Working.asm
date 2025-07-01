.include "macros.S"

MAKEPATCH 0x000019A0
0:
	bla 0xcf80
9:

MAKEPATCH 0x00002A90 
0:
	bla 0xCFD0
9:

MAKEPATCH 0x00002AA4
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00007198  
0:
	bla 0xCFD0
9:

MAKEPATCH 0x000071C8
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:


MAKEPATCH 0x00007308  
0:
	bla 0xCFD0
9:

MAKEPATCH 0x00007338
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:


MAKEPATCH 0x00007428  
0:
	bla 0xCFD0
9:

MAKEPATCH 0x00007458
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc	
9:


MAKEPATCH 0x00007698 
0:
	bla 0xCFD0
9:

MAKEPATCH 0x000076C8
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:


MAKEPATCH 0x000077EC 
0:
	bla 0xCFD0
9:

MAKEPATCH 0x00007818
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

MAKEPATCH 0x00001420
0:
	cmplwi r0, 0x7c
9:


MAKEPATCH 0x0000114C 
0:
	ba 0x1570
9:

MAKEPATCH 0x00001570 # empty spot
0:
	li r4, 7
	andc r1, r1, r4
	mtspr 0x3b5, r1
	ba 0x1150
9:


MAKEPATCH 0x000079F0 # HvxLockL2
0:
	li r3, 1
	blr 
9:

MAKEPATCH 0x00004C5C # HvxLoadImageData
0:
	nop 
	nop 
9:

MAKEPATCH 0x00005340 # HvxResolveImports
0:
	nop
9:	

MAKEPATCH 0x0000534C # HvxResolveImports
0:
	nop
9:	


.set HvpGetFlashBase,0x998	
.set CopyBy64,0x78C
.set resumeInit,0x19A4
.set HvxGetVersions,0x2A48
.set Hv_setmemprot,0x1570
.set HV_memcpy,0xC740

.set checkOpType,0xD018
.set hvxExecuteCode,0xD064
.set checkforMemProtectOn,0xd03c
.set setMemProtections,0xd044
.set returnOne,0xD05C
.set doMemCpy,0xD0B0
.set returnTwo,0xD0C8
.set cpyLoop,0xD078



MAKEPATCH 0x0000CF80 							# Line Addr
0:
#Copy Fuses
	mflr r8 									# 0xCF80
	lhz r3, 6(r0) 								# 0xCF84 
	li r4, 0x21									# 0xCF88
	andc r3, r3, r4 							# 0xCF8C
	sth r3, 6(r0) 								# 0xCF90
	bla HvpGetFlashBase # 0x998					# 0xCF94
	lwz r4, 0x64(r3) 							# 0xCF98
	lwz r5, 0x70(r3) 							# 0xCF9C
	add r3, r3, r4 								# 0xCFA0 
	add r4, r3, r5 								# 0xCFA4
	lis r3, 1 									# 0xCFA8
	addi r3, r3, -0x60							# 0xCFAC		
	li r5, 0xc 									# 0xCFB0
	bla CopyBy64 	# 0x78C						# 0xCFB4
	li r3, 0x21									# 0xCFB8 
	bla 0xCFDC 		 							# 0xCFBC
	li r3, 0xa									# 0xCFC0
	bla 0xCFDC 									# 0xCFC4
	mtlr r8  									# 0xCFC8		
	ba resumeInit 	# 0x19A4 					# 0xCFCC

#Fix Fuses
	lis r3, 1 									# 0xCFD0
	addi r3, r3, -0x60							# 0xCFD4 	
	blr 										# 0xCFD8
			
#Post Output		
	lis r4, -0x8000 							# 0xCFDC 
	ori r4, r4, 0x200 							# 0xCFE0
	sldi r4, r4, 0x20 							# 0xCFE4
	oris r4, r4, 0xea00 						# 0xCFE8
	slwi r3, r3, 0x18 							# 0xCFEC
	stw r3, 0x1014(r4) 							# 0xCFF0
			
	lwz r3, 0x1018(r4) 							# 0xCFF4
	rlwinm. r3, r3, 0, 6, 6 					# 0xCFF8
	MAKEBEQNOCR 0xcff4 							# 0xCFFC
	blr 										# 0xD000
		
	lis r11, 0x7262 							# 0xD004 
	ori r11, r11, 0x7472 						# 0xD008
	cmplw cr6, r3, r11 							# 0xD00C
	MAKEBEQ checkOpType		# 0xD018			# 0xD010
	ba HvxGetVersions 		# 0x2A48			# 0xD014
			
#checkOpType: 									# 0xD018
	cmplwi cr6, r4, 4 							# 0xD018
	MAKEBGT doMemCpy 	# 0xD0B0				# 0xD01C
	MAKEBEQ hvxExecuteCode 	# 0xD064			# 0xD020
	li r5, Hv_setmemprot 	# 0x1570			# 0xD024
	lis r6, 0x3880 								# 0xD028
	cmplwi cr6, r4, 2 							# 0xD02C
	MAKEBNE checkforMemProtectOn # 0xd03c		# 0xD030
	ori r6, r6, 7 								# 0xD034
	MAKEBRANCH setMemProtections   # 0xd044		# 0xD038
			
#checkforMemProtectOn: 							# 0xD03C
	cmplwi cr6, r4, 3 							# 0xD03C
	MAKEBNE returnOne 		# 0xD05C			# 0xD040
			
#setMemProtections: 							# 0xD044
	li r0, 0 									# 0xD044
	stw r6, 0(r5) 								# 0xD048
	dcbst 0, r5 								# 0xD04C
	icbi 0, r5 									# 0xD050
	sync  										# 0xD054
	isync  										# 0xD058
			
#returnOne: 									# 0xD05C 
	li r3, 1 									# 0xD05C
	blr 										# 0xD060
			
#hvxExecuteCode: 								# 0xD064
	mflr r12 									# 0xD064
	std r12, -8(r1) 							# 0xD068
	stdu r1, -0x10(r1) 							# 0xD06C
	mtlr r5 									# 0xD070
	mtctr r7 									# 0xD074
		
#cpyLoop: 										# 0xD078
	lwz r4, 0(r6) 								# 0xD078
	stw r4, 0(r5) 								# 0xD07C
	dcbst 0, r5 								# 0xD080
	icbi 0, r5 									# 0xD084
	sync 										# 0xD088
	isync 										# 0xD08C
	addi r5, r5, 4 								# 0xD090
	addi r6, r6, 4 								# 0xD094
	MAKEBDNZ cpyLoop	# 0xD078				# 0xD098
	blr 										# 0xD09C
	addi r1, r1, 0x10 							# 0xD0A0
	ld r12, -8(r1) 								# 0xD0A4
	mtlr r12 									# 0xD0A8
	blr 										# 0xD0AC
			
#doMemCpy:	 									# 0xD0B0
	cmplwi cr6, r4, 5 							# 0xD0B0
	MAKEBNE returnTwo 	#0xD0C8					# 0xD0B4
	mr r3, r6 									# 0xD0B8
	mr r4, r5 									# 0xD0BC
	mr r5, r7 									# 0xD0C0
	ba HV_memcpy 	# 0xC740					# 0xD0C4
			
#returnTwo: 									# 0xD0C8
	li r3, 2 									# 0xD0C8
	blr 										# 0xD0CC
9:


MAKEPATCH 0x00001CD4 # syscall table 
0:
	.long 0x0000D004
9:


MAKEPATCH 0x000090B0 # HvxSecuritySetDetected
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00009178 # HvxSecurityGetDetected
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x000091C0 # HvxSecuritySetActivated
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00009268 # HvxSecurityGetActivated
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00009540 # machinecheck
0:	
	nop 
9:

MAKEPATCH 0x00009534 # CB sig check
0:
	li r3, 1

MAKEPATCH 0x0000957C # machinecheck
0:
	nop
9:	

MAKEPATCH 0x0000958C # machinecheck
0:
	nop
9:

MAKEPATCH 0x000095B4 # machinecheck 
0:
	nop 
	li r11, 1
9:	



MAKEPATCH 0x00009FF0 # HvxKeysRsaPrvCrypt
0:	
	MAKEBRANCH (0xA020)
9:

MAKEPATCH 0x0000A1D8 # HvpCompareXGD2MediaID
0:
	li r3, 1
	blr 
9:

.set j_XeCryptAesKey,0xCDE8

MAKEPATCH 0x00003DC8
0:
	cmpldi cr6, r28, 0
	MAKEBEQ(0x3dfc) # beq cr6,
	cmpwi cr6, r3, 0
	MAKEBNE(0x3de4) # bne cr6, 
	li r4, 0xf0
	MAKEBRANCH (0x3df4)
	nop 
	cmplwi cr6, r29, 0
	addi r4, r31, 0x440
	MAKEBNE(0x3df4) # bne cr6,
	li r4, 0x54
	mr r3, r28
	MAKEBRANCHL j_XeCryptAesKey
	li r31, 0
9:

MAKEPATCH 0x00005E90 # HvxImageTransformImageKey
0:
	nop
9:	

MAKEPATCH 0x000040A8 # HvxCreateImageMapping
0:
	li r3, 0
9:

MAKEPATCH 0x000042F0 # HvxCreateImageMapping
0:
	nop 
9:

# kernel patches

KMAKEPATCH 0x8007718C # XexpLoadXexHeaders 
0:
	KMAKEBRANCH(0x8007719c) 
9:

KMAKEPATCH 0x80077190 # XexpLoadXexHeaders
0:
	nop 
	nop 
	nop 
9:

KMAKEPATCH 0x800EB230 # XeKeysVerifyRSASignature 
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800EC158 # _XeKeysRevokeIsValid 	
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800EC1F8 # _XeKeysRevokeIsRevoked 	

0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800EC2C8 # XeKeysRevokeIsRevoked 	
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800EC340 # XeKeysRevokeConvertError 
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800F1300 # XeCryptBnQwBeSigVerify_0 
0:
	li r3, 1
	blr 
9:


KMAKEPATCH 0x800ECBA0 # XeKeysConsoleSignatureVerification 

0:
	cmplwi cr6, r5, 0
	li r3, 1
	KMAKEBEQ(0x800ecbb0)
	stw r3, 0(r5)
	blr 
9:

KMAKEPATCH 0x80117E88 # SataDiskAuthenticateDevice
0:
	li r3, 1
	blr 
9:


#KMAKEPATCH 0x8011C9E0 # empty space for loading dashlaunch / guess no dashlaunch on 6717 so why is this here???
#0:											
#	mr r31, r3				# 0x8011C9E0	
#	cmpwi cr6, r31, 0		# 0x8011C9E4
#	KMAKEBLT(0x8011c9f0)	# 0x8011C9E8
#	KMAKEBEQ(0x8011c9f4)	# 0x8011C9EC
#	blr 					# 0x8011C9F0
#	lis r3, -0x7fee			# 0x8011C9F4
#	ori r3, r3, 0xd038		# 0x8011C9F8
#	lis r5, 0				# 0x8011C9FC
#	li r4, 0				# 0x8011CA00
#	ori r4, r4, 8			# 0x8011CA04
#	li r6, 0				# 0x8011CA08
#	KMAKEBRANCHL 0x80068db8 # 0x8011CA0C
#	li r31, 0				# 0x8011CA10
#	KMAKEBRANCH 0x80050b38	# 0x8011CA14
#	.long 0x5C446576    	# 0x8011CA18
#   .long 0x6963655C    	# 0x8011CA1C
#   .long 0x466C6173    	# 0x8011CA20
#   .long 0x685C6C61    	# 0x8011CA24
#   .long 0x756E6368    	# 0x8011CA28
#   .long 0x2E786578		# 0x8011CA2C
#   .long 0x00000000		# 0x8011CA30
#9:

KMAKEPATCH 0x80078008 # XexGetModuleImportVersions 
0:
	li r3, 0
9:

KMAKEPATCH 0x8008CD80 # SfcxInspectLargeMobileBlock
0:
	li r23, 0x10
9:

KMAKEPATCH 0x80077298 # XexpLoadFile
0:
	li r3, 0
9:

KMAKEPATCH 0x800772EC # XexpLoadFile 
0:
	li r11, 0
9:

KMAKEPATCH 0x8008FF10 # SataCdRomAP25Initialize
0:
	li r3, 0
	nop 
	nop 
9:

KMAKEPATCH 0x800ECBF0 # XeKeysConsoleSignatureVerification 
0:
	li r3, 1
	KMAKEBRANCH(0x800ecc18)
9:

.long 0xffffffff

