.model medium
.stack 64
.data
.code
main proc far
        mov ax, @data
        mov ds, ax
		mov ah,0
		mov al,13h
		int 10h
        mov al, 0
        mov ah, 0ch
        mov cx, 0
        mov dx, 0
        mov bh, 200
    DrawLine:
        mov bl, 255
    DrawPixel:
        int 10h
        inc dx
        inc al
        dec bl
        jnz DrawPixel
        mov dx, 0
        inc cx
        dec bh
        jnz DrawLine
    meh: jmp meh
        hlt
main endp
end main