section .multiboot_header
multiboot_header_start:
    dd 0xe85250d6
    dd 0
    dd multiboot_header_end - multiboot_header_start ; header length
    dd -( 0xe85250d6 + 0 + ( multiboot_header_end - multiboot_header_start ) )

    dw 0
    dw 0
    dd 8
multiboot_header_end:

section .text
bits 32

global _start
_start:
    mov dword [0xb8000], 0x2f4b2f4f
    hlt
