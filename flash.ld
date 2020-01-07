/*
 * ATSAME54P20A linker script
 */

MEMORY
{
        flash (rx)  : ORIGIN = 0x00000000, LENGTH = 1024K
        ram   (rwx) : ORIGIN = 0x20000000, LENGTH = 256K
}        


SECTIONS
{
        .text :
        {
                *(vectors)
                *(.text)
        } >flash

        .rodata :
        {
                *(.rodata)
        } >flash
        
        _DATA_ROM_START = .;
        .data :
        {
                _DATA_RAM_START = .;
                *(.data)
                _DATA_RAM_END = .;
        } >ram AT>flash

        .bss :
        {
                _BSS_START = .;
                *(.bss)
                _BSS_END = .;
        } >ram
}
        
