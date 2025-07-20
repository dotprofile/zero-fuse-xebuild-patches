.include "macros.S"

MAKEPATCH 0x000019A0 # init hook
0:
	bla 0xD328
9:

MAKEPATCH 0x00002AA0 # vfuse
0:
	bla 0xD378
9:

MAKEPATCH 0x00002AB4 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x000073E8   # vfuse
0:
	bla 0xD378
9:

MAKEPATCH 0x00007418 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:


MAKEPATCH 0x00007558  # vfuse
0:
	bla 0xD378
9:

MAKEPATCH 0x00007588 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:


MAKEPATCH 0x00007678   # vfuse
0:
	bla 0xD378
9:

MAKEPATCH 0x000076A8 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc	
9:


MAKEPATCH 0x000078E8  # vfuse
0:
	bla 0xD378
9:

MAKEPATCH 0x00007918 # vfuse
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:


MAKEPATCH 0x00007A3C # vfuse
0:
	bla 0xD378
9:

MAKEPATCH 0x00007A68 # vfuse
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

MAKEPATCH 0x00001570
0:
	li r4, 7
	andc r1, r1, r4
	mtspr 0x3b5, r1
	ba 0x1150
9:

MAKEPATCH 0x00007C40 # HvxLockL2
0:
	li r3, 1
	blr 
9:

MAKEPATCH 0x00004DC4 # HvxLoadImageData
0:
	nop 
	nop 
9:

MAKEPATCH 0x000054A8 # HvxResolveImports
0:
	nop
9:

MAKEPATCH 0x000054B4 # HvxResolveImports
0:
	nop
9:	

# FlagFixer, vfuse load and syscall0 

.set HvpGetFlashBase,0x998	
.set CopyBy64,0x78C
.set resumeInit,0x19A4
.set HvxGetVersions,0x2A58
.set Hv_setmemprot,0x1570
.set HV_memcpy,0xCAE0

.set checkOpType,0xD3C0
.set hvxExecuteCode,0xD40C
.set checkforMemProtectOn,0xD3E4
.set setMemProtections,0xD3EC
.set returnOne,0xD404
.set doMemCpy,0xD458
.set returnTwo,0xD470
.set cpyLoop,0xD420


MAKEPATCH 0x0000D328
0:	
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
	bla 0xD384                         
	li r3, 0xa                         
	bla 0xD384                         
	mtlr r8                            
	ba resumeInit                      
	lis r3, 1                          
	addi r3, r3, -0x60                 
	blr                                
	lis r4, -0x8000                    
	ori r4, r4, 0x200                  
	sldi r4, r4, 0x20                  
	oris r4, r4, 0xea00                
	slwi r3, r3, 0x18                  
	stw r3, 0x1014(r4)                 
	lwz r3, 0x1018(r4)                 
	rlwinm. r3, r3, 0, 6, 6            
	MAKEBEQNOCR 0xD39C                 
	blr                                
	lis r11, 0x7262                    
	ori r11, r11, 0x7472               
	cmplw cr6, r3, r11                 
	MAKEBEQ checkOpType                
	ba HvxGetVersions                  
	cmplwi cr6, r4, 4                  
	MAKEBGT doMemCpy                   
	MAKEBEQ hvxExecuteCode             
	li r5, Hv_setmemprot               
	lis r6, 0x3880                     
	cmplwi cr6, r4, 2                  
	MAKEBNE checkforMemProtectOn       
	ori r6, r6, 7                      
	MAKEBRANCH setMemProtections       
	cmplwi cr6, r4, 3                  
	MAKEBNE returnOne                  
	li r0, 0						
	stw r6, 0(r5)                      
	dcbst 0, r5                        
	icbi 0, r5                         
	sync                               
	isync                              
	li r3, 1                           
	blr                                
	mflr r12                           
	std r12, -8(r1)                    
	stdu r1, -0x10(r1)                 
	mtlr r5                            
	mtctr r7                           
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
	cmplwi cr6, r4, 5                  
	MAKEBNE returnTwo                  
	mr r3, r6                          
	mr r4, r5                          
	mr r5, r7                          
	ba HV_memcpy                       
	li r3, 2                           
	blr                                
9:

MAKEPATCH 0x00001CD4 # syscall table 
0:
	.long 0x0000D3AC
9:


MAKEPATCH 0x00009300 # HvxSecuritySetDetected
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x000093C8 # HvxSecurityGetDetected
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x00009410 # HvxSecuritySetActivated
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x000094B8 # HvxSecurityGetActivated
0:
	li r3, 0
	blr 
9:

MAKEPATCH 0x0000982C # CB sig check
0:
	li r3, 1
9:

MAKEPATCH 0x00009838 # machinecheck
0:
	nop
9:

MAKEPATCH 0x00009874 # machinecheck
0:
	nop 
9:

MAKEPATCH 0x00009884 # machinecheck
0:
	nop 
9:

MAKEPATCH 0x000098AC
0:
	nop 
	li r11, 1
9:

MAKEPATCH 0x0000A2E8 # HvxKeysRsaPrvCrypt
0:
	MAKEBRANCH 0xA318
9:

MAKEPATCH 0x0000A4D0 # HvpCompareXGD2MediaID
0:
	li r3, 1
	blr 
9:

MAKEPATCH 0x00003EE0
0:
	cmpldi cr6, r28, 0
	MAKEBEQ 0x3f14
	cmpwi cr6, r3, 0
	MAKEBNE 0x3efc
	li r4, 0xf0
	MAKEBRANCH 0x3f0c
	nop 
	cmplwi cr6, r29, 0
	addi r4, r31, 0x440
	MAKEBNE 0x3f0c
	li r4, 0x54
	mr r3, r28
	MAKEBRANCHL 0xd190
	li r31, 0
9:

MAKEPATCH 0x000041C0 # HvxCreateImageMapping
0:
	li r3, 0
9:

MAKEPATCH 0x00004458 # HvxCreateImageMapping
0:
	nop 
9:

# Kernel Patches


KMAKEPATCH 0x800776A4 # XexpLoadXexHeaders 
0:
	KMAKEBRANCH 0x800776b4
9:

KMAKEPATCH 0x800776A8 # XexpLoadXexHeaders
0:
	nop 
	nop 
	nop 
9:

KMAKEPATCH 0x800ECB40 # XeKeysVerifyRSASignature 	
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800EDAD8 # _XeKeysRevokeIsValid 
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800EDB78 # _XeKeysRevokeIsRevoked 		
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800EDC48 # XeKeysRevokeIsRevoked
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x800EDCC0 # XeKeysRevokeConvertError
0:
	li r3, 0
	blr 
9:

KMAKEPATCH 0x800F2CA0 # XeCryptBnQwBeSigVerify_0 
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x800EE528 # XeKeysConsoleSignatureVerification 
0:
	cmplwi cr6, r5, 0
	li r3, 1
	KMAKEBEQ(0x800EE538)
	stw r3, 0(r5)
	blr 
9:

KMAKEPATCH 0x8011A6B8 # SataDiskAuthenticateDevice 
0:
	li r3, 1
	blr 
9:

KMAKEPATCH 0x80078190 # XexGetModuleImportVersions 
0:
	li r3, 0
9:

KMAKEPATCH 0x8008CEB8 # SfcxInspectLargeDataBlock
0:
	li r23, 0x10
9:

KMAKEPATCH 0x800777B0 # XexpLoadFile 
0:
	li r3, 0
9:	

KMAKEPATCH 0x80077804 # XexpLoadFile
0:
	li r11, 0
9:

KMAKEPATCH 0x800EE578 # XeKeysConsoleSignatureVerification 
0:
	li r3, 1
	KMAKEBRANCH(0x800EE5A0) 
9:

KMAKEPATCH 0x800902D4 #  SataCdRomAP25Initialize
0:
	KMAKEBRANCH 0x800902ec
9:


.long 0xFFFFFFFF
