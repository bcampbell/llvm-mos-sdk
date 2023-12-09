/* f256k uses first 16 bytes of ZP for mmu control? */
__rc0 = 0x10;
INCLUDE imag-regs.ld
ASSERT(__rc0 == 0x10, "Inconsistent zero page map.")
ASSERT(__rc31 == 0x2f, "Inconsistent zero page map.")

/* I'm reserving a teeny bit of RAM: 0x200-0x800,
 * and treating everything from there up to 0xC000 as rom.
 * (even though we're really just loading everything into ram,
 * I want to make it easier to compile for actual rom in future).
 *
 * It'd be nice to have a more dynamic scheme to manage the ram/rom balance
 * here. But for now, this works, even if it's specific to my project...
 * Maybe it'd be better to have rom first and everything left over can be
 * called ram?
 */

MEMORY {
    /* kernel uses 0xf0-0xff for parameter passing */
    zp : ORIGIN = __rc31 + 1, LENGTH = 0xF0 - (__rc31 + 1)
    ram (rw) : ORIGIN = 0x200, LENGTH = 0x800-0x200
    rom (rw) : ORIGIN = 0x800, LENGTH = 0xC000-0x800
}


REGION_ALIAS("c_readonly", rom)
REGION_ALIAS("c_writeable", ram)

/*
SECTIONS { INCLUDE c.ld }
*/
/* NOTE: c.ld has zp.ld before text.ld.
 * If the compiler decides to put data into the zeropage (.zp.data),
 * then it would appear in our output binary before the .text section.
 * And because the text section is our starting point, the zeropage
 * data pushes our _start address up by some indeterminate amount, which
 * is a pain.
 * So, here I've just done the same as c.ld, but reordered things so the
 * .zp data appears _after_ our .text section.
 * (the zeropage data copied into the zeropage at startup by the crt
 * copy-zp-data, I think) 
 */
SECTIONS {
    INCLUDE text.ld
    INCLUDE zp.ld
    INCLUDE rodata.ld
    INCLUDE data.ld
    INCLUDE bss.ld
    INCLUDE noinit.ld
}

/* Set initial soft stack address to just above last ram address. (It grows down.) */
__stack = ORIGIN(ram) + LENGTH(ram);


/* bare binary */
/*
OUTPUT_FORMAT {
    TRIM(rom)
}
*/
/* PGX */
OUTPUT_FORMAT {
    BYTE(0x50)
    BYTE(0x47)
    BYTE(0x58)
    BYTE(0x03)  /* not quite sure of the CPU codes to use... */
    LONG(_start)
    TRIM(rom)
}

