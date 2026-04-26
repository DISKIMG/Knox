ENTRY(_start)

SECTIONS
{
    . = 1M;

    .text : AT(ADDR(.text))
    {
        *(.multiboot)   
        *(.text)
    }

    .rodata : { *(.rodata*) }
    .data   : { *(.data) }
    .bss    : { *(.bss) }
}