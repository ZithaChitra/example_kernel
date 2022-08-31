[bits 16] ;instruct nasm to output 16 bit opcodes

; include prepared global descriptor table structure
%include "boot/gdt.asm"

; switch to protected mode.
switch_to_pm:

    cli                         ; we must switch off inturrupts until we have
                                ; set up the protected mode inturrupt vector
                                ; otherwise interrupts will run amuck


    lgdt [gdt_descriptor]       ; Load our global descriptor table which defines    
                                ; the protected mode segments (e.g for code and data)

    mov eax, cr0                ; To make the switch to protected mode, we set 
    or eax, 0x1                 ; the first bit of CR0, a special CPU control rgister 
    mov cr0, eax


    jmp CODE_SEG:init_pm


[bits 32] ; instruct nasm to output 32 bit opcodes.

; Initialize registers and the stack once in PM.
init_pm:

    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call BEGIN_PM

[bits 16]


























