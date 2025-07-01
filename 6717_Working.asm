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


MAKEPATCH 0x0000114C #
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



MAKEPATCH 0x0000CF80 							
0:
#Copy Fuses
	mflr r8 									
	lhz r3, 6(r0) 								
	li r4, 0x21									
	andc r3, r3, r4 							
	sth r3, 6(r0) 								
	bla HvpGetFlashBase # 0x998					
	lwz r4, 0x64(r3) 							
	lwz r5, 0x70(r3) 							
	add r3, r3, r4 								
	add r4, r3, r5 								
	lis r3, 1 									
	addi r3, r3, -0x60					
	li r5, 0xc 									
	bla CopyBy64 	# 0x78C						
	li r3, 0x21									
	bla 0xCFDC 		 							
	li r3, 0xa									
	bla 0xCFDC 									
	mtlr r8  									
	ba resumeInit 	# 0x19A4 					

#Fix Fuses
	lis r3, 1 									
	addi r3, r3, -0x60					
	blr 										
			
#Post Output		
	lis r4, -0x8000 							
	ori r4, r4, 0x200 							
	sldi r4, r4, 0x20 							
	oris r4, r4, 0xea00 						
	slwi r3, r3, 0x18 							
	stw r3, 0x1014(r4) 							
			
	lwz r3, 0x1018(r4) 							
	rlwinm. r3, r3, 0, 6, 6 					
	MAKEBEQNOCR 0xcff4 							
	blr 										
		
	lis r11, 0x7262 							
	ori r11, r11, 0x7472 						
	cmplw cr6, r3, r11 							
	MAKEBEQ checkOpType		# 0xD018			
	ba HvxGetVersions 		# 0x2A48			
			
#checkOpType: 									
	cmplwi cr6, r4, 4 							
	MAKEBGT doMemCpy 	# 0xD0B0				
	MAKEBEQ hvxExecuteCode 	# 0xD064			
	li r5, Hv_setmemprot 	# 0x1570			
	lis r6, 0x3880 								
	cmplwi cr6, r4, 2 							
	MAKEBNE checkforMemProtectOn # 0xd03c		
	ori r6, r6, 7 								
	MAKEBRANCH setMemProtections   # 0xd044		
			
#checkforMemProtectOn: 							
	cmplwi cr6, r4, 3 							
	MAKEBNE returnOne 		# 0xD05C			
			
#setMemProtections: 							
	li r0, 0 									
	stw r6, 0(r5) 								
	dcbst 0, r5 								
	icbi 0, r5 									
	sync  										
	isync  										
			
#returnOne: 									 
	li r3, 1 									
	blr 										
			
#hvxExecuteCode: 								
	mflr r12 									
	std r12, -8(r1) 							
	stdu r1, -0x10(r1) 							
	mtlr r5 									
	mtctr r7 									
		
#cpyLoop: 										
	lwz r4, 0(r6) 								
	stw r4, 0(r5) 								
	dcbst 0, r5 								
	icbi 0, r5 									
	sync 										
	isync 										
	addi r5, r5, 4 								
	addi r6, r6, 4 								
	MAKEBDNZ cpyLoop			# 0xD078		
	blr 										
	addi r1, r1, 0x10 							
	ld r12, -8(r1) 								
	mtlr r12 									
	blr 										
			
#doMemCpy:	 									
	cmplwi cr6, r4, 5 							
	MAKEBNE returnTwo 	#0xD0C8					
	mr r3, r6 									
	mr r4, r5 									
	mr r5, r7 									
	ba HV_memcpy 	# 0xC740					
			
#returnTwo: 									
	li r3, 2 									
	blr 										
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
	li r3, 1 # trying 0
9:

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
	MAKEBRANCH (0xA020) #b
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
	KMAKEBRANCH(0x8007719c) #  skip over BNE
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
#	mr r31, r3					
#	cmpwi cr6, r31, 0		
#	KMAKEBLT(0x8011c9f0)	
#	KMAKEBEQ(0x8011c9f4)	
#	blr 					
#	lis r3, -0x7fee			
#	ori r3, r3, 0xd038		
#	lis r5, 0				
#	li r4, 0				
#	ori r4, r4, 8			
#	li r6, 0				
#	KMAKEBRANCHL 0x80068db8 
#	li r31, 0				
#	KMAKEBRANCH 0x80050b38	
#	.long 0x5C446576    	
#   .long 0x6963655C    	
#   .long 0x466C6173    	
#   .long 0x685C6C61    	
#   .long 0x756E6368    	
#   .long 0x2E786578		
#   .long 0x00000000		
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

