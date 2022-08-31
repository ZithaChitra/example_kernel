;
; Functions
;

print_string:
    _loop:
        ;mov al, [si]
        lodsb ; mov al, [si] + inc si
        cmp al, 0
        je _end

        mov ah, 0x0e
        int 0x10
        ;inc si
        jmp _loop

    _end:

    ret

print_char:
    mov ah, 0x0e ; BIOS scrolling teletype function 
    int 0x10
    ret

print_hex:
    push bx
    push si
    mov si, HEX_TEMPLATE

    mov bx, dx      ; bx -> 0xe234
    shr bx, 12      ; bx -> 0x00 0e
    mov bx, [bx + HEXABET]
    mov [HEX_TEMPLATE + 2], bl 

    mov bx, dx      ; bx -> 0xe234
    shr bx, 8       ; bx -> 0x00 e2
    and bx, 0x000f  ; bx -> 0x00 02
    mov bx, [bx + HEXABET]
    mov [HEX_TEMPLATE + 3], bl 

    mov bx, dx      ; bx -> 0xe234
    shr bx, 4       ; bx -> 0x0e 34
    and bx, 0x000f  ; bx -> 0x00 02
    mov bx, [bx + HEXABET]
    mov [HEX_TEMPLATE + 4], bl 

    mov bx, dx      ; bx -> 0xe234
    and bx, 0x000f  ; bx -> 0x00 02
    mov bx, [bx + HEXABET]
    mov [HEX_TEMPLATE + 5], bl 

    call print_string
    pop si
    pop bx
    ret


HEX_TEMPLATE:
    db '0x???? ', 0

HEXABET:
    db '0123456789abcdef'



read_from_disk:
    pusha

    mov ah, 0x02                ; read sector from disk

    ; mov al, 1                 ; sectors to read. Comment out 
                                ; so caller can set as an argument
    mov ch, 0                   ; select first cylinder/track to read from 
    mov dh, 0                   ; select first read/write head
    mov cl, 2                   ; select second sector, sector after bios

    push bx
    mov bx, 0
    mov es, bx                  ; es -> 0
    pop bx
    ; mov bx, 0x7c00 + 512      ; where to load the sector in memory. Comment out 
                                ; so caller can set as an argument 
    
    int 0x13

    jc read_error               ; jump to err message if carry flag is set

    popa
    ret


read_error:
    mov si, DISK_ERROR
    call print_string
    jmp $

DISK_ERROR:
    db "Error reading disk", 0
