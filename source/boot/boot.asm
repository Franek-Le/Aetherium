section .multiboot
align 4
    dd 0x1BADB002              ; magic number
    dd 0x00                    ; flags
    dd -(0x1BADB002 + 0x00)    ; checksum

section .text

extern KernelMain

global _start
_start:
    ; Multiboot loader will load us here in 32-bit mode
    ; Set up stack
    mov esp, stack_top

    call KernelMain

.halt:
    cli
    hlt
    jmp .halt

section .bss
align 16
stack_bottom:
    resb 4096  ; 4KB stack
stack_top:
