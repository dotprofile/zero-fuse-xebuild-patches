.include "macros.S"


MAKEPATCH 0x00003434
0:
	nop
9:

MAKEPATCH 0x00000018
0:
    .long 0x81300D49
    .long 0xC232F145
9:
