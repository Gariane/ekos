section .multiboot_header
multiboot_header_start:
    ; see multiboot2 specification for meaning
    dd 0xe85250d6
    dd 0
    dd multiboot_header_end - multiboot_header_start
    dd -( 0xe85250d6 + 0 + ( multiboot_header_end - multiboot_header_start ) )

    ; end tag
    dw 0
    dw 0
    dd 8
multiboot_header_end: