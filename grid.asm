DrawHorizontalLine macro color, count
local DrawLoop
		mov ah, 0ch
		mov al, color
		mov bx, count
	DrawLoop:
		int 10h
		inc cx
		dec bx
		jnz DrawLoop
endm DrawHorizontalLine

.286
.model huge
.stack 64
.data
    black   equ 00h
    green   equ 02h
    red     equ 04h
    yellow  equ 0eh
    white   equ 0fh
    isOpen  db  1
    playerColor equ 0eh
    grid db 560 dup(?)
    gridStartX equ 0
    gridStartY equ 28d
    gridStep equ 10d
    gridXCount equ 28d
    gridYCount equ 20d
.code
main proc far
    mov ax, @data
    mov ds, ax
    lea si, isOpen
    start:
        mov ah, 0h
        mov al, 13h
        int 10h
        mov ch, gridXCount
        mov dx, gridStartY
        mov ax, gridStartX
        ; startdraw:
        ;     pusha
        ;     call DrawSquare
        ;     mov dx, 20h
        ;     call WaitDX
        ;     popa
        ;     add ax, 10
        ;     dec ch
        ;     jnz startdraw
        mov dx, gridStartY
        mov ax, gridStartX
        add ax, 10
        push ax
        push dx
        call DrawSquare
        pop dx
        pop ax
        add ax, 10
        push ax
        push dx
        call DrawSquare
        pop dx
        pop ax
        add ax, 10
        push ax
        push dx
        call DrawSquare
        pop dx
        pop ax
    endmeh: jmp endmeh
main endp

; before calling, put xPosition in ax, and yPosition in dx
DrawSquare proc far
    xPosition dw ?
    yPosition dw ?
    mov xPosition, ax
    mov yPosition, dx
    mov dx, yPosition
    mov cx, xPosition
    DrawHorizontalLine white, gridStep
    inc dx
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine black, gridStep-2
    DrawHorizontalLine white, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine black, gridStep-2
    DrawHorizontalLine white, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine black, gridStep-2
    DrawHorizontalLine white, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine black, gridStep-2
    DrawHorizontalLine white, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine black, gridStep-2
    DrawHorizontalLine white, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine black, gridStep-2
    DrawHorizontalLine white, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine black, gridStep-2
    DrawHorizontalLine white, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine black, gridStep-2
    DrawHorizontalLine white, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine black, gridStep-2
    DrawHorizontalLine white, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine white, gridStep
    ret
DrawSquare endp

WaitDX proc
    bigmeh:
        mov cx, 0ffffh
        smallmeh: loop smallmeh
        dec dx
        jnz bigmeh
    ret
WaitDX endp

end main