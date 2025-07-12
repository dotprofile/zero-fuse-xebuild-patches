.include "macros.S"


#HvFixKeys

MAKEPATCH 0x00002A04 #   disable copying transform key from SoC
0:
	nop
9:

MAKEPATCH 0x00000018 # pbkey xex2key make transform key 81300D49C232F145
0:
    .long 0x81300D49
    .long 0xC232F145
9:
