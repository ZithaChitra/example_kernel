; Functions for running in 32 bit protected mode

[bits 32]

; Define some constants in nasm
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null terminated string pointed to by esi
print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY ; start of video memory


print_string_pm_loop:
    mov al, [esi]           ; store char at al
    mov ah, WHITE_ON_BLACK  ; store attributes in ah

    cmp al, 0
    je print_string_pm_done

    mov [edx], ax

    add esi, 1
    add edx, 2    

    jmp print_string_pm_loop


print_string_pm_done:
    popa
    ret

[bits 16]