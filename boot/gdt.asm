gdt_start:

gdt_null:           ; the mandatory null descriptor
    dd 0x0          ; 'dd' - double word / 4 bytes 
    dd 0x0          ; two 'dd' give us 8 bytes/64 bits which makes 
                    ; up a segment descriptor structure

gdt_code:           ; the code segment descriptor
    ; base=0x0, limit=0xfffff,
    ; 1st flags: (present)1 (privillage)00 (descriptor type)1 -> 1001b
    ; type flags: (code)1 (comforming)0 (readable)1 (accessed)0 -> 1010b
    ; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b
    dw 0xffff       ; limit (bits 0 - 15)
    dw 0x0          ; base (bits 0 - 15)
    db 0x0          ; base (bits 16 - 23)
    db 10011010b    ; 1st flags, type flags
    db 11001111b    ; 2nd flags, limit (bits 16 - 19)
    db 0x0          ; base (bits 24 - 32)


gdt_data:
    ; Same as code segments except for the type flags:
    ; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
    dw 0xffff       ; Limit (bits 0 -15)
    dw 0x0          ; Base (bits 0 -15)
    db 0x0          ; Base (bits 16 - 23)
    db 10010010b    ; 1st flags, type flags
    db 11001111b    ; 2nd flags, Limit (bits 16 - 19)
    db 0x0          ; Base (bits 24 - 31) 



gdt_end:            ; The reason for putting a label at the end of the 
                    ; GDT is so we can have the assembler calculate    
                    ; the size of the GDT for the GDT (below).



; GDT descriptor: points to our descriptor table and is passed to the
; CPU on the switch to protected mode, so it can find our GDT
; -------------------------------------------------------------------


gdt_descriptor: 
    dw gdt_end - gdt_start - 1      ; Size of our GDT always less than 1 of true size
    dd gdt_start                    ; start address of our gdt



; Define some handy constants for the GDT 'segment descriptor' offsets, which 
; are what segment registers must constain when in protected mode. For example,
; when we set DS=0x10 in PM, the CPU knows that we mean it to use the 
; the segment described at offset 0x10 (i.e 16 bytes) in our GDT, which in our 
; case is the DATA segment. (0x0 -> null; 0x8 -> CODE; 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
















