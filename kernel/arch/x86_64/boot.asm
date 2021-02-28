; compatibility_check.asm
extern check_multiboot2
extern check_cpuid
extern check_longmode

; paging.asm
extern setup_identity_paging
extern enable_paging


; set up stack
section .bss
align 16
stack_top:
    resb 0x4000 
stack_bottom:


section .text

; entry function
bits 32
global _start
_start:
    mov esp, stack_bottom

    ; perform compatibility checks and print eventual error
    call check_multiboot2
    call check_cpuid
    call check_longmode

    ; set up identity paging
    call setup_identity_paging
    call enable_paging

    ; load gdt and far jump to reload CS register
    lgdt [gdt.ptr]
    jmp gdt.code:long_mode_entry

; 64 bit code
bits 64
long_mode_entry:
    ; load NULL to DS registers
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; print OKAY
    mov rax, 0x2f592f412f4b2f4f
    mov qword [0xb8000], rax

    ; loop indefinetly
    cli 
loop:
    hlt
    jmp loop


; gdt
section .ro_data
gdt:
    dq 0
.code: equ $ - gdt
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)
.ptr:
    dw $ - gdt - 1
    dq gdt
