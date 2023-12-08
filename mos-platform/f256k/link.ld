/* f256k uses first 16 bytes of ZP for mmu control? */
__rc0 = 0x10;
INCLUDE imag-regs.ld
ASSERT(__rc0 == 0x10, "Inconsistent zero page map.")
ASSERT(__rc31 == 0x2f, "Inconsistent zero page map.")


MEMORY {
    /* kernel uses 0xf0-0xff for parameter passing */
    zp : ORIGIN = __rc31 + 1, LENGTH = 0xF0 - (__rc31 + 1)
    ram (rw) : ORIGIN = 0x200, LENGTH = 0x800-0x200
    rom (rw) : ORIGIN = 0x800, LENGTH = 0xC000-0x800
}


REGION_ALIAS("c_readonly", rom)
REGION_ALIAS("c_writeable", ram)

SECTIONS { INCLUDE c.ld }

/* Set initial soft stack address to just above last ram address. (It grows down.) */
__stack = ORIGIN(ram) + LENGTH(ram);


/* bare binary, _start at 0x2000 */
OUTPUT_FORMAT {
    TRIM(rom)
}

/* PGX */
/*
OUTPUT_FORMAT {
    BYTE(0x50)
    BYTE(0x47)
    BYTE(0x58)
    BYTE(0x03)
    LONG(_start)
    TRIM(rom)
}
*/
