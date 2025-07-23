.include "macros.S"


MAKEPATCH 0x0000189C # init
0:
	bla 0xA474
9:

MAKEPATCH 0x00001E68 # vfuse
0:
	bla 0xA4C4
9:

MAKEPATCH 0x00001E7C # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00008A80 # vfuse
0:
	bla 0xA4C4
9:

MAKEPATCH 0x00008AB0 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00008BF0 # vfuse
0:
	bla 0xA4C4
9:

MAKEPATCH 0x00008C20 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00008D10 # vfuse
0:
	bla 0xA4C4
9:

MAKEPATCH 0x00008D40 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00008F80 # vfuse
0:
	bla 0xA4C4
9:

MAKEPATCH 0x00008FB0 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x000090D0 # vfuse
0:
	bla 0xA4C4
9:

MAKEPATCH 0x00009100 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00009190 # vfuse
0:
	bla 0xA4C4
9:

MAKEPATCH 0x000091BC # vfuse
0:
	addi r11, r11, 1
	sldi r9, r9, 3
	cmpwi cr6, r11, 0xc
9:

MAKEPATCH 0x00009430 # vfuse
0:
	bla 0xA4C4
9:

MAKEPATCH 0x0000945C # vfuse
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

MAKEPATCH 0x00002B04 # machine check
0:
	nop
9:

MAKEPATCH 0x00009520 # HvxLockL2 
0:
	li r3, 1
	blr
9:

MAKEPATCH 0x0002A14C # HvxLoadImageData
0:
	nop 
	nop 
9:

MAKEPATCH 0x0002A8C0 # HvxResolveImports
0:
	nop 
9:

MAKEPATCH 0x0002A8CC # HvxResolveImports
0:
	nop 
9:




.set HvpGetFlashBase,0x68C	
.set CopyBy64,0x484
.set resumeInit,0x2D8
.set HvxGetVersions,0x1E20
.set Hv_setmemprot,0x154C
.set HV_memcpy,0x9820

.set checkOpType,0xA50C
.set hvxExecuteCode,0xA558
.set checkforMemProtectOn,0xA530
.set setMemProtections,0xA538
.set returnOne,0xA550
.set doMemCpy,0xA5A4
.set returnTwo,0xA5BC
.set cpyLoop,0xA56C



MAKEPATCH 0x0000A474 							
0:
#Copy Fuses
	mflr r8 									
	lhz r3, 6(r0) 								
	li r4, 0x21									
	andc r3, r3, r4 							
	sth r3, 6(r0) 								
	bla HvpGetFlashBase					
	lwz r4, 0x64(r3) 							
	lwz r5, 0x70(r3) 							
	add r3, r3, r4 								
	add r4, r3, r5 								
	lis r3, 1 									
	addi r3, r3, -0x60					
	li r5, 0xc 									
	bla CopyBy64					
	li r3, 0x21									
	bla 0xA4D0 		 							
	li r3, 0xa									
	bla 0xA4D0 									
	mtlr r8  									
	ba resumeInit 					

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
	MAKEBEQNOCR 0xA4E8 							
	blr 										
		
	lis r11, 0x7262 							
	ori r11, r11, 0x7472 						
	cmplw cr6, r3, r11 							
	MAKEBEQ checkOpType			
	ba HvxGetVersions			
			
#checkOpType: 									
	cmplwi cr6, r4, 4 							
	MAKEBGT doMemCpy				
	MAKEBEQ hvxExecuteCode 			
	li r5, Hv_setmemprot 			
	lis r6, 0x3880 								
	cmplwi cr6, r4, 2 							
	MAKEBNE checkforMemProtectOn		
	ori r6, r6, 7 								
	MAKEBRANCH setMemProtections		
			
#checkforMemProtectOn: 							
	cmplwi cr6, r4, 3 							
	MAKEBNE returnOne 			
			
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
	MAKEBDNZ cpyLoop					
	blr 										
	addi r1, r1, 0x10 							
	ld r12, -8(r1) 								
	mtlr r12 									
	blr 										
			
#doMemCpy:	 									
	cmplwi cr6, r4, 5 							
	MAKEBNE returnTwo 					
	mr r3, r6 									
	mr r4, r5 									
	mr r5, r7 									
	ba HV_memcpy					
			
#returnTwo: 									
	li r3, 2 									
	blr 										
9:


MAKEPATCH 0x00015980 # replace syscall0
0:
	.long 0x0000A4F8
9:


MAKEPATCH 0x00006250  # HvxSecuritySetDetected
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x000062E0 # HvxSecurityGetDetected
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00006328 # HvxSecuritySetActivated
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00006390 # HvxSecurityGetActivated
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x000063D8 
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00007650 #  HvxKeysRsaPrvCrypt
0:
	MAKEBRANCH 0x7680
9:


MAKEPATCH 0x000066C8 # CB check
0:
	li r3, 1
9:

MAKEPATCH 0x000066D0 # machinecheck
0:
	nop 
9:

MAKEPATCH 0x00006884 # CD check
0:
	li r3, 0
9:

MAKEPATCH 0x000068D0 # machinecheck
0:
	nop
9:

MAKEPATCH 0x000068E0 # machinecheck
0:
	nop
9:

MAKEPATCH 0x00006904 # machinecheck
0:
	nop 
	li r11, 1
9:	

MAKEPATCH 0x00024B98 # HvpCompareXGD2MediaID
0:
	li r3, 1
	blr 
9:



MAKEPATCH 0x00029948
0:
	cmpldi cr6, r28, 0
	MAKEBEQ 0x2997c
	cmpwi cr6, r3, 0
	MAKEBNE 0x29964
	li r4, 0xf0
	MAKEBRANCH 0x29974
	nop 
	cmplwi cr6, r29, 0
	addi r4, r31, 0x440
	MAKEBNE 0x29974
	li r4, 0x54
	mr r3, r28
	MAKEBRANCHL 0x200f8
	li r31, 0
9:

MAKEPATCH 0x0002BE20 # HvxCreateImageMapping
0:
	li r3, 0
9:

MAKEPATCH 0x0002C0B8  # HvxCreateImageMapping
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



# kernel patches

KMAKEPATCH 0x8007AC80 # _XeKeysSecurityConvertError
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x8007B818 # XexpLoadXexHeaders
0:
	li r3, 1
9:

KMAKEPATCH 0x8007B928 # XexpLoadXexHeaders
0:
	li r3, 0
9:

KMAKEPATCH 0x8007B990 # XexpLoadFile
0:
	li r11, 0
9:

KMAKEPATCH 0x8007B9E0 # XexpLoadFile
0:
	li r11, 0
9:

KMAKEPATCH 0x8007C850
0:
	li r3, 0
9:

KMAKEPATCH 0x80093F28 # SfcxInspectLargeDataBlock
0:
	li r23, 0x10
9:

KMAKEPATCH 0x800987E0 # SataCdRomAP25Initialize
0:
	cmplwi cr6, r11, 0xff
9:

KMAKEPATCH 0x800981C4 # SataDiskReadLogoBitmap
0:
	li r3, 0
	nop 
	nop 
	nop 
	nop 
9:

KMAKEPATCH 0x80106DF0
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x801078E8
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x80107BC8
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x80108090
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x80108248
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x80108298
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x801083D8
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x80108558
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x8010D980
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x80109040
0:
	li r3, 1
	KMAKEBRANCH 0x80109068
9:

KMAKEPATCH 0x8014B160 # # SataDiskAuthenticateDevice
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x8014EE00 # empty spot
0:
	mr r30, r3
	cmpwi cr6, r30, 0
	KMAKEBLT 0x8014ee10
	KMAKEBEQ 0x8014ee14
	blr 
	lis r3, -0x7fec
	lis r5, 0
	li r4, 0
	ori r4, r4, 8
	ori r3, r3, 0xee38
	li r6, 0
	KMAKEBRANCHL 0x8007ca60
	li r30, 0
	KMAKEBRANCH 0x8006138c
	.long 0x5C446576    	
	.long 0x6963655C    	
	.long 0x466C6173    	
	.long 0x685C6C61    	
	.long 0x756E6368    	
	.long 0x2E786578		
	.long 0x00000000
9:

KMAKEPATCH 0x80061388 #phase1 init branch and link to dashlaunch
0:
	KMAKEBRANCHL 0x8014ee00
9:

.long 0xffffffff

