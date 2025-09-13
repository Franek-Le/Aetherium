%define IRQ_BASE 0x20

section .text

extern _ZN16InterruptManager15HandleInterruptEhm

global _ZN16InterruptManager22IgnoreInterruptRequestEv

%macro HandleException 1
global _ZN16InterruptManager16HandleException%1Ev
_ZN16InterruptManager16HandleException%1Ev:
    mov byte [interruptnumber], %1
    jmp int_bottom
%endmacro

%macro HandleInterruptRequest 1
global _ZN16InterruptManager26HandleInterruptRequest%1Ev
_ZN16InterruptManager26HandleInterruptRequest%1Ev:
    mov byte [interruptnumber], IRQ_BASE + %1
    jmp int_bottom
%endmacro

HandleInterruptRequest 0x00
HandleInterruptRequest 0x01

int_bottom:
    pusha
    push ds
    push es
    push fs
    push gs

    push esp
    movzx eax, byte [interruptnumber]
    push eax

    call _ZN16InterruptManager15HandleInterruptEhm
    add esp, 8

    pop gs
    pop fs
    pop es
    pop ds
    popa

    iretd

_ZN16InterruptManager22IgnoreInterruptRequestEv:
    iretd

section .data
interruptnumber: db 0
