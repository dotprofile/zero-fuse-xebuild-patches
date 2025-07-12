.include "macros.S"


MAKEPATCH 0x000019A0 # init hook
0:
	bla 0xf568
9:


MAKEPATCH 0x00002078 # vfuse
0:
	bla 0xF5B8
9:

MAKEPATCH 0x00006BE0 # vfuse
0:
	bla 0xF5B8
9:

MAKEPATCH 0x00006D50 # vfuse
0:
	bla 0xF5B8
9:

MAKEPATCH 0x00006E70 # vfuse
0:
	bla 0xF5B8
9:

MAKEPATCH 0x000070E0 # vfuse
0:
	bla 0xF5B8
9:

MAKEPATCH 0x00007230 # vfuse
0:
	bla 0xF5B8
9:

MAKEPATCH 0x000072F0 # vfuse
0:
	bla 0xF5B8
9:


MAKEPATCH 0x0007590 # vfuse
0:
	bla 0xF5B8
9:

MAKEPATCH 0x0000208C # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00006C10 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00006D80 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00006EA0 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00007110 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00007260 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x0000731C # vfuse
0:							
	addi r11, r11, 1		
	sldi r9, r9, 3			
	cmpwi cr6, r11, 0xc		
9:							

MAKEPATCH 0x000075BC # vfuse
0:
	addi r11, r11, 1	
	sldi r9, r9, 3		
	cmpwi cr6, r11, 0xc	
9:


MAKEPATCH 0x000000F0 # devkit Xex Key
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

MAKEPATCH 0x00001570
0:
	li r4, 7
	andc r1, r1, r4
	mtspr 0x3b5, r1
	ba 0x1150
9:

MAKEPATCH 0x00002AD8 # for sure need this, MACHINECHECK otherwise / 17559 0x3120 equiv
0:
	nop
9:

MAKEPATCH 0x00007680 # HvxLockL2(?) / (Disable fuse burning?!?)
0:
	li r3, 1
	blr 
9:


MAKEPATCH 0x000043B4 # HvxLoadImageData
0:
	nop 
	nop 
9:

MAKEPATCH 0x00004A98 # HvxResolveImports
0:
	nop
9:

MAKEPATCH 0x00004AA4 # HvxResolveImports
0:
	nop
9:

.set HvpGetFlashBase,0x998	
.set CopyBy64,0x78C
.set resumeInit,0x19A4

.set HvxGetVersions,0x2030
.set Hv_setmemprot,0x1570
.set HV_memcpy,0xED20

.set checkOpType,0xF600
.set hvxExecuteCode,0xF64C
.set checkforMemProtectOn,0xF624
.set setMemProtections,0xF62C
.set returnOne,0xF644
.set doMemCpy,0xF698
.set returnTwo,0xF6B0
.set cpyLoop,0xF660


MAKEPATCH 0x0000F568 							# Line Addr
0:
	mflr r8 							# 0xF568
	lhz r3, 6(r0) 							# 0xF56C 
	li r4, 0x1							# 0xF570 	# Other patches clear bit 5, with the mask 0x20. 17559 did 0x21 to clear 5 and 0. JTAG patches just hard-set word_6. After tinkering, found we just need to clear bit 0. Not sure of the explanation, yet. 
	andc r3, r3, r4 						# 0xF574
	sth r3, 6(r0) 	 						# 0xF578
	bla HvpGetFlashBase # 0x998					# 0xF57C
	lwz r4, 0x64(r3) 						# 0xF580	# reading/building vfuse addr from flash
	lwz r5, 0x70(r3) 						# 0xF584	# reading/building vfuse addr from flash; flash base + e0000
	add r3, r3, r4 							# 0xF588 
	add r4, r3, r5 							# 0xF58C
	lis r3, 1 							# 0xF590
	addi r3, r3, -0x60	 					# 0xF594	
	li r5, 0xc 							# 0xF598
	bla CopyBy64 	# 0x78C						# 0xF59C
	li r3, 0x21 							# 0xF5A0 
	bla 0xF5C4 		 					# 0xF5A4
	li r3, 0xa							# 0xF5A8
	bla 0xF5C4 							# 0xF5AC
	mtlr r8  							# 0xF5B0	
	ba resumeInit 	# 0x19A4 					# 0xF5B4
	
	lis r3, 1 							# 0xF5B8
	addi r3, r3, -0x60 						# 0xF5BC
	blr 								# 0xF5C0
	

	lis r4, -0x8000 						# 0xF5C4 #post output
	ori r4, r4, 0x200 						# 0xF5C8
	sldi r4, r4, 0x20 						# 0xF5CC
	oris r4, r4, 0xea00 						# 0xF5D0
	slwi r3, r3, 0x18 						# 0xF5D4
	stw r3, 0x1014(r4) 						# 0xF5D8
	
	lwz r3, 0x1018(r4) 						# 0xF5DC
	rlwinm. r3, r3, 0, 6, 6 					# 0xF5E0
	MAKEBEQNOCR 0xF5DC 						# 0xF5E4
	blr 								# 0xF5E8
	
	lis r11, 0x7262 						# 0xF5EC # magic key
	ori r11, r11, 0x7472 						# 0xF5F0
	cmplw cr6, r3, r11 						# 0xF5F4
	MAKEBEQ checkOpType		# 0xF600			# 0xF5F8
	ba HvxGetVersions 		# 0x2030			# 0xF5FC
	
#checkOpType: 								
	cmplwi cr6, r4, 4 						# 0xF600
	MAKEBGT doMemCpy 	# 0xF698				# 0xF604
	MAKEBEQ hvxExecuteCode 	# 0xF64C				# 0xF608
	li r5, Hv_setmemprot 	# 0x1570				# 0xF60C
	lis r6, 0x3880 							# 0xF610
	cmplwi cr6, r4, 2 						# 0xF614
	MAKEBNE checkforMemProtectOn # 0xF624				# 0xF618
	ori r6, r6, 7 							# 0xF61C
	MAKEBRANCH setMemProtections   # 0xF62C				# 0xF620
	
#checkforMemProtectOn: 							
	cmplwi cr6, r4, 3 						# 0xF624
	MAKEBNE returnOne 	# 0xF644				# 0xF628
	
#setMemProtections: 							
	li r0, 0 							# 0xF62C
	stw r6, 0(r5) 							# 0xF630
	dcbst 0, r5 							# 0xF634
	icbi 0, r5 							# 0xF638
	sync  								# 0xF63C
	isync  								# 0xF640

#returnOne: 								
	li r3, 1 							# 0xF644
	blr 								# 0xF648

#hvxExecuteCode: 							
	mflr r12 							# 0xF64C
	std r12, -8(r1) 						# 0xF650
	stdu r1, -0x10(r1) 						# 0xF654
	mtlr r5 							# 0xF658
	mtctr r7 							# 0xF65C

#cpyLoop: 								
	lwz r4, 0(r6) 							# 0xF660
	stw r4, 0(r5) 							# 0xF664
	dcbst 0, r5 							# 0xF668
	icbi 0, r5 							# 0xF66C
	sync 								# 0xF670
	isync 								# 0xF674
	addi r5, r5, 4 							# 0xF678
	addi r6, r6, 4 							# 0xF67C
	MAKEBDNZ cpyLoop	# 0xF660				# 0xF680
	blr 								# 0xF684
	addi r1, r1, 0x10 						# 0xF688
	ld r12, -8(r1) 							# 0xF68C
	mtlr r12 							# 0xF690
	blr 								# 0xF694

#doMemCpy:	 							
	cmplwi cr6, r4, 5 						# 0xF698
	MAKEBNE returnTwo 	#0xF6C0					# 0xF69C
	mr r3, r6 							# 0xF6A0
	mr r4, r5 							# 0xF6A4
	mr r5, r7 							# 0xF6A8
	ba HV_memcpy 	# 0xED20					# 0xF6AC

#returnTwo: 								
	li r3, 2 							# 0xF6B0
	blr 								# 0xF6B4
9:

MAKEPATCH 0x00001C98 # Replace Syscall0 with our own 
0:
	.long 0x0000F5EC
9:


MAKEPATCH 0x00008DB8 # HvxSecuritySetDetected
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00008E80 # HvxSecurityGetDetected
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00008EC8 # HvxSecuritySetActivated
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00008F70 # HvxSecurityGetActivated
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00008FB8 # HvxSecuritySetStat  might not be needed, in patches_jasper
0:
	blr 
9:


MAKEPATCH 0x00009300 # CB check?
0:
	li r3, 1
9:

MAKEPATCH 0x0000940C # might be unneccesary 
0:
    nop               
9:

MAKEPATCH 0x000094CC
0:
    nop
9:


MAKEPATCH 0x000094C0 # CD check?
0:
	li r3, 0
9:

MAKEPATCH 0x0000950C # MACHINECHECK
0:
	nop 
9:

MAKEPATCH 0x0000951C # MACHINECHECK
0:
	nop 
9:

MAKEPATCH 0x00009544
0:
	nop 
	li r11, 1
9:

MAKEPATCH 0x0000A078 # HvxKeysRsaPrvCrypt
0:
	MAKEBRANCH 0xa0a8
9:


MAKEPATCH 0x0000A260 # HvpCompareXGD2MediaID
0:
	li r3, 1
	blr 
9:

MAKEPATCH 0x0000EAA8 # HvxInstallExpansion
0:
	li r3, 1
9:

MAKEPATCH 0x000055E8 # HvxImageTransformImageKey
0:
	nop
9:	


MAKEPATCH 0x000034D0
0:
	cmpldi cr6, r28, 0
	MAKEBEQ 0x3504
	cmpwi cr6, r3, 0
	MAKEBNE 0x34ec
	li r4, 0xf0
	MAKEBRANCH 0x34fc
	nop 
	cmplwi cr6, r29, 0
	addi r4, r31, 0x440
	MAKEBNE 0x34fc
	li r4, 0x54
	mr r3, r28
	MAKEBRANCHL 0xf3d0
	li r31, 0
9:

MAKEPATCH 0x000037B0 # HvxCreateImageMapping
0:
	li r3, 0
9:

MAKEPATCH 0x00003A48 # HvxCreateImageMapping
0:
	nop 
9:


# Kernel Patches

KMAKEPATCH 0x800785E4 # XexpLoadXexHeaders 
0:
	KMAKEBRANCH 0x800785f4
9:

KMAKEPATCH 0x800785E8 # XexpLoadXexHeaders
0:
	nop 
	nop 
	nop 
9:

KMAKEPATCH 0x800F6118 # XeKeysVerifyRSASignature 
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800F70C0 # _XeKeysRevokeIsValid 
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800F7160 # _XeKeysRevokeIsRevoked
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800F7230 # XeKeysRevokeIsRevoked
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x800F72A8 # XeKeysRevokeConvertError
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x800FC470 # XeCryptBnQwBeSigVerify_0
0:
	li r3, 1
	blr 
9:
	
KMAKEPATCH 0x80128378 # SataDiskAuthenticateDevice
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800F7D00 # XeKeysConsoleSignatureVerification 

0:
	cmplwi cr6, r5, 0
	li r3, 1
	KMAKEBEQ(0x800F7D10)
	stw r3, 0(r5)
	blr 
9:

KMAKEPATCH 0x8012D000 # Dashlaunch in empty spot
0:
	mr r31, r3
	cmpwi cr6, r31, 0
	KMAKEBLT 0x8012d010
	KMAKEBEQ 0x8012d014
	blr 
	lis r3, -0x7fee
	ori r3, r3, 0xd038
	lis r5, 0
	li r4, 0
	ori r4, r4, 8
	li r6, 0
	KMAKEBRANCHL 0x800793d8
	li r31, 0
	KMAKEBRANCH 0x80061158
	.long 0x5C446576
	.long 0x6963655C
	.long 0x466C6173
	.long 0x685C6C61
	.long 0x756E6368
	.long 0x2E786578
	.long 0x00000000
9:

KMAKEPATCH 0x80061154 # Phase1init, branch to dashlaunch
0:
	KMAKEBRANCHL 0x8012d000
9:

KMAKEPATCH 0x800791C8 # XexGetModuleImportVersions
0:
	li r3, 0
9:

KMAKEPATCH 0x8008E060 # SfcxInspectLargeDataBlock
0:
	li r23, 0x10
9:

KMAKEPATCH 0x800786F0 # XexpLoadFile
0:
	li r3, 0
9:

KMAKEPATCH 0x80078744 # XexpLoadFile
0:
	li r11, 0
9:

KMAKEPATCH 0x80078794 # # XexpLoadFile
0:
	li r11, 0
9:

KMAKEPATCH 0x800F7D50 #  XeKeysConsoleSignatureVerification
0:
	li r3, 1
	KMAKEBRANCH 0x800f7d78
9:

.long 0xffffffff


