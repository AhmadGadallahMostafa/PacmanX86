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

DrawPacmanOpen macro xPosition, yPosition, playerColor, backgroundColor
    ;row 1
    mov dx, yPosition
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine red, 2
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 2
    DrawHorizontalLine backgroundColor, 3
    ;row 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine red, 2
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 4
    DrawHorizontalLine backgroundColor, 2
    ;row 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine red, 1
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 1
    DrawHorizontalLine black, 2
    DrawHorizontalLine playerColor, 3
    DrawHorizontalLine backgroundColor, 1
    ;row 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 2
    DrawHorizontalLine black, 1
    DrawHorizontalLine playerColor, 3
    DrawHorizontalLine backgroundColor, 2
    ;row 5
    inc dx
    mov cx, xPosition
    DrawHorizontalLine green, 1
    DrawHorizontalLine playerColor, 5
    DrawHorizontalLine backgroundColor, 4
    ;row 6
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 4
    DrawHorizontalLine backgroundColor, 6
    ;row 7
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 6
    DrawHorizontalLine backgroundColor, 4
    ;row 8
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 8
    DrawHorizontalLine backgroundColor, 2
    ;row 9
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine playerColor, 8
    DrawHorizontalLine backgroundColor, 1
    ;row 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine playerColor, 6
    DrawHorizontalLine backgroundColor, 2
endm DrawPacmanOpen

DrawPacmanClose macro xPosition, yPosition, playerColor, backgroundColor
    ;row 1
    mov dx, yPosition
    mov cx, xPosition
    DrawHorizontalLine white, 1
    DrawHorizontalLine red, 2
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 2
    DrawHorizontalLine backgroundColor, 3
    ;row 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine red, 2
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 4
    DrawHorizontalLine backgroundColor, 2
    ;row 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine red, 1
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 1
    DrawHorizontalLine black, 2
    DrawHorizontalLine playerColor, 3
    DrawHorizontalLine backgroundColor, 1
    ;row 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine green, 2
    DrawHorizontalLine playerColor, 2
    DrawHorizontalLine black, 1
    DrawHorizontalLine playerColor, 4
    DrawHorizontalLine backgroundColor, 1
    ;row 5
    inc dx
    mov cx, xPosition
    DrawHorizontalLine green, 1
    DrawHorizontalLine playerColor, 8
    DrawHorizontalLine backgroundColor, 1
    ;row 6
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 9
    DrawHorizontalLine backgroundColor, 1
    ;row 7
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 9
    DrawHorizontalLine backgroundColor, 1
    ;row 8
    inc dx
    mov cx, xPosition
    DrawHorizontalLine playerColor, 9
    DrawHorizontalLine backgroundColor, 1
    ;row 9
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine playerColor, 7
    DrawHorizontalLine backgroundColor, 2
    ;row 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine playerColor, 5
    DrawHorizontalLine backgroundColor, 3
endm DrawPacmanClose

.model small
.data
    black   equ 00h
    blue    equ 01h
    lightMagenta equ 0dh
    green   equ 02h
    red     equ 04h
    yellow  equ 0eh
    white   equ 0fh
    isOpen  db  1
.code
main proc far
    mov ax, @data
    mov ds, ax
    lea si, isOpen
    start:
        jmp dontjmp
        closeplz: jmp closed
        dontjmp:
        mov ah, 0h
        mov al, 13h
        int 10h
        mov di, [si]
        cmp di, 0
        je closeplz
        DrawPacmanOpen 50, 50, yellow, lightMagenta 
        mov [si], 0
        jmp end
        closed:
        DrawPacmanClose 50, 50, yellow, blue
        mov [si], 1
        end:
        mov dx, 20
        supermeh:
        mov cx, 0ffffh
        meh: loop meh
        dec dx
        jnz supermeh
        jmp start
main endp
end main