.include "macros.S"

#HvFixKeys

MAKEPATCH 0x0000283C
0:
	nop
9:

MAKEPATCH 0x00000018
0:
    .long 0x81300D49
    .long 0xC232F145
9:

