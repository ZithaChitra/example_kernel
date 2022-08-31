; firstly, don't be too hard on yourself while learnig this stuff.
; what you'll find in asm is that what 
; things look like when you write asm code is 
; not always how the computer works underneath - Nick Blundell 

[org 0x7c00]

; Setup the stack away from our code.
mov bp, 0xffff
mov sp, bp


; set vga to be normal mode
mov ax, 0x3
int 0x10

mov si, MSG_REAL_MODE
call print_string


mov si, MSG_LOADING_KERNEL
call print_string

mov al, 9               ; 9 'seems' to be the most we can read from a cylinder
mov bx, kernel_entry    ; [0x7c00 + 512]
call read_from_disk

; Switch into 32 bit protected mode.
call switch_to_pm

jmp $ ; endless jump

%include "boot/functions/my_functions.asm"
%include "boot/functions/switch_to_pm.asm"
%include "boot/functions/my_pm_functions.asm"

[bits 32]

BEGIN_PM:

    ; 0xb8000 - video memory buffer
    mov esi, MSG_PROT_MODE
    call print_string_pm


    
    
    ; jump to loaded kernel code.
    jmp kernel_entry

    jmp $


[bits 16]
; Messages to display
MSG_REAL_MODE: db "Started in 16 bit real mode. ", 0
MSG_LOADING_KERNEL: db "Protected mode. Loading kernel from disk to address 0x7c00 + [512] = 0x7e00", 0
MSG_PROT_MODE: db "Successfully switched into 32-bit Protected mode. ", 0



times 510 - ($ - $$) db 0
dw 0xaa55



kernel_entry:
    ; Kernel code will be loaded in here




















  