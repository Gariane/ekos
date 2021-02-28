section .text
bits 32

global setup_identity_paging
setup_identity_paging:
    ; map first entry of p4_table to p3_table and mark as present and executable
    mov eax, p3_table
    or eax, 0b11
    mov [p4_table], eax

    ; map first entry of p3_table to p2_table and mark as present and executable
    mov eax, p2_table
    or eax, 0b11
    mov [p3_table], eax

    ; map every entry of p2_table to 2MB frames
    mov ecx, 0
.p2_loop:
    mov eax, 0x200000
    mul ecx
    or eax, 0b10000011  ; mark present, executable and huge
    mov [p2_table + (ecx * 8)], eax

    inc ecx
    cmp ecx, 512
    jne .p2_loop

    ret

global enable_paging
enable_paging:
    mov eax, p4_table 
    mov cr3, eax

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret

; page tables
section .bss
align 4096
p4_table:
    resb 4096
p3_table:
    resb 4096
p2_table:
    resb 4096
