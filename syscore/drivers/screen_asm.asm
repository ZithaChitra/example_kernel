; routine for displaying characters on the screen in protected mode
; this will we be re-writen in C. But by showing how it's done in asm
; we can compare asm language relationship with C.

[bits 32]

VIDMEM          equ 0xb8000 ; video memory
COLS            equ 80      ; width and height of screen
LINES           equ 25
CHAR_ATTRIB     equ 14      ; character attribute (white text on black background)

_CurX db 0                  ; current x/y location
_CurY db 0
 

;***********************************************;
;       Putch32()                               ;
;           - prints a char to screen           ;
;       bl => char print                        ;
;***********************************************;

Putch32:
    pusha
    mov edi, VIDEO_MEMORY   ; pointer to vid mem

    ; Before displaying a character we need to know where
    ; to display it. So we first get the current position
    xor eax, eax    ; clear eax 

        ;***********************************************
        ; Remember: currentPos = x + (y * COLS), x and y are in _CurX and _CurY
        ; Because there are 2 bytes per char, COLS=num of chars per line,
        ;  we have to multiply this by 2 to get the number of bytes per line. 
        ; And this is the screen width.
        ;***********************************************

        mov     ecx, COLS*2         ; mode 7 has 2 bytes per char, so it's COLS*2 bytes per line
        mov     al, byte [_CurY]    ; get y pos
        mul     ecx                 ; multiply y*COLS ; the destination operand is hard coded as ax
        push    eax                 ; save eax -- the multiplication  result

        ;***********************************************
        ; Now y * screen width is in eax. Then we add _CurX. But again remember that _CurX 
        ; is relative to the char count, not byte count. Because there are two bytes per
        ; char we multiply _CurX by 2 first, then add it to our (screen width * y).
        ;***********************************************
        
        mov     al, byte [_CurX]    
        mov     cl, 2
        mul     cl
        pop     ecx                 ; pop y*COLS result
        add     eax, ecx
        
        ;***********************************************
        ; Now eax contains the offset address to draw the char at, so we add it to
        ; the base address of video memory ( stored in edi )
        ;***********************************************

        xor     ecx, ecx
        add     edi, eax

    
    ; Now, edi contains the exact byte to write to. bl contains the
    ; char to write. If the char is a newline char, we will move to
    ; the next row, else we just print the char

    cmp     bl, 0x0A            ; is it a newline character
    je      .Row                ; yep -- go to next row

    ; print a char
    mov     dl, bl
    mov     dh, CHAR_ATTRIB
    mov word [edi], dx          ; write to video display

    ; update next position
    inc     byte [_CurX]
    cmp     [_CurX], COLS
    je      .Rows
    jmp     .done


; Go to next row
.Row:
    mov     byte [_CurX], 0     ; go back to col 0
    inc     byte [_CurY]        ; go to next row


; restore registers and return 
.done:
    popa
    ret
        

           













































