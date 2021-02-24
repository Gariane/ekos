section .text
bits 32

; check if kernel was booted using multiboot2 compliant bootloader
check_multiboot2:
    cmp eax, 0x36d76289
    jne no_multiboot2
    ret
no_multiboot2:
    mov al, "0"
    jmp error

; check if processor supports cpuid instruction
; source + explanation: https://wiki.osdev.org/Setting_Up_Long_Mode
check_cpuid:
    pushfd
    pop eax
    mov ecx, eax
    xor eax, 1 << 21
    push eax
    popfd
    pushfd
    pop eax
    push ecx
    popfd
    xor eax, ecx
    jz no_cpuid
    ret
no_cpuid:
    mov al, "1"
    jmp error

; check if processor supports long mode
; source + explanation: https://wiki.osdev.org/Setting_Up_Long_Mode
check_longmode:
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb no_longmode

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz no_longmode
    ret
no_longmode:
    mov al, "2"
    jmp error

; entry function
global _start
_start:
    mov esp, stack_bottom

    ; perform compatibility checks and print eventual error
    call check_multiboot2
    call check_cpuid
    call check_longmode

    ; print OK to screen, indicating we booted successfully
    mov dword [0xb8000], 0x2f4b2f4f
    hlt

; print ASCII value from al register as "ERR: "
error:
    mov dword [0xb8000], 0x4f524f45
    mov dword [0xb8004], 0x4f3a4f52
    mov dword [0xb8008], 0x4f204f20
    mov byte  [0xb800a], al
    hlt


; set up stack
section .bss

stack_top:
    resb 0x4000 
stack_bottom:
