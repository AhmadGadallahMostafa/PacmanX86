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

.model medium
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
    gridstartX equ 0
    gridstartY equ 36
    gridStep equ 10
.code
main proc far
    mov ax, @data
    mov ds, ax
    lea si, isOpen
    start:
        mov ah, 0h
        mov al, 13h
        int 10h
        DrawSquare gridstartX, gridstartY
main endp

DrawSquare macro xPosition, yPosition
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
endm DrawSquare

;DrawPacmanOpen proc xPosition, yPosition, playerColor
DrawPacmanOpen proc xPosition, yPosition
    ;row 1
    mov dx, yPosition
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine red, 2
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor 2
    ;row 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine red, 2
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 4
    ;row 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine red, 1
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 1
    DrawHorizontalLine black, 2
    DrawHorizontalLine playerColor, 3
    ;row 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 2
    DrawHorizontalLine black, 1
    DrawHorizontalLine playerColor, 3
    ;row 5
    inc dx
    mov cx, xPosition
    DrawHorizontalLine green, 1
    DrawHorizontalLine playerColor, 5
    ;row 6
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 4
    ;row 7
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 6
    ;row 8
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 8
    ;row 9
    inc dx
    mov cx, xPosition+1
    DrawHorizontalLine playerColor, 8
    ;row 10
    inc dx
    mov cx, xPosition+2
    DrawHorizontalLine playerColor, 6
    ret
endp DrawPacmanOpen

;DrawPacmanClose proc xPosition, yPosition, playerColor
DrawPacmanClose proc xPosition, yPosition
    ;row 1
    mov dx, yPosition
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine red, 2
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor 2
    ;row 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine red, 2
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 4
    ;row 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine red, 1
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 1
    DrawHorizontalLine black, 2
    DrawHorizontalLine playerColor, 3
    ;row 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 2
    DrawHorizontalLine black, 1
    DrawHorizontalLine playerColor, 4
    ;row 5
    inc dx
    mov cx, xPosition
    DrawHorizontalLine green, 1
    DrawHorizontalLine playerColor, 8
    ;row 6
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 9
    ;row 7
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 9
    ;row 8
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 9
    ;row 9
    inc dx
    mov cx, xPosition+1
    DrawHorizontalLine playerColor, 7
    ;row 10
    inc dx
    mov cx, xPosition+2
    DrawHorizontalLine playerColor, 5
    ret
endp DrawPacmanClose
end main