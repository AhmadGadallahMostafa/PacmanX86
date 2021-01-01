SetVideoMode macro   ;320x200 pixel supporting 256 colors , 40x25 , (40 -> col - > x - > dl) , (25 -> row -> y -> dh)
		mov ah,0
		mov al,13h
		int 10h
endm SetVideoMode

DrawHorizontalLine macro color, count ; put xPosition in cx, and yPosition in dx before calling
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

DrawVerticalLine macro color, count ; put xPosition in cx, and yPosition in dx before calling
local DrawLoop
		mov ah, 0ch
		mov al, color
		mov bx, count
	DrawLoop:
		int 10h
		inc dx
		dec bx
		jnz DrawLoop
endm DrawVerticalLine

DrawPacmanUpOpen macro xPosition, yPosition, playerColor, backgroundColor
    ;col 1
    mov dx, yPosition
    mov cx, xPosition
	DrawVerticalLine backgroundColor, 3
	DrawVerticalLine playerColor, 2
	DrawVerticalLine green, 2
	DrawVerticalLine red, 2
	DrawVerticalLine white, 1
    ;col 2
	inc cx
	mov dx, yPosition
	DrawVerticalLine backgroundColor, 2
	DrawVerticalLine playerColor, 4
	DrawVerticalLine green, 2
	DrawVerticalLine red, 2
	;col 3
	inc cx
	mov dx, yPosition
	DrawVerticalLine backgroundColor, 1
	DrawVerticalLine playerColor, 3
	DrawVerticalLine black, 2
	DrawVerticalLine playercolor, 1
	DrawVerticalLine green, 2
	DrawVerticalLine red, 1
    ;row 4
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 2
    DrawVerticalLine playerColor, 3
    DrawVerticalLine black, 1
    DrawVerticalLine playerColor, 2
    DrawVerticalLine green, 2
    ;col 5
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 4
    DrawVerticalLine playerColor, 5
    DrawVerticalLine green, 1
    ;col 6
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 6
    DrawVerticalLine playerColor, 4
    ;col 7
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 4
    DrawVerticalLine playerColor, 6
    ;col 8
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 2
    DrawVerticalLine playerColor, 8
    ;col 9
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 1
    DrawVerticalLine playerColor, 8
    DrawVerticalLine backgroundColor, 1
    ;col 10
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 2
    DrawVerticalLine playerColor, 6
    DrawVerticalLine backgroundColor, 2
endm DrawPacmanUpOpen

DrawPacmanDownOpen macro xPosition, yPosition, playerColor, backgroundColor
	;col 1
	mov dx, yPosition
	mov cx, xPosition
	DrawVerticalLine white, 1
	DrawVerticalLine red, 2
	DrawVerticalLine green, 2
	DrawVerticalLine playerColor, 2
	DrawVerticalLine backgroundColor, 3
	;col 2
	inc cx
	mov dx, yPosition
	DrawVerticalLine red, 2
	DrawVerticalLine green, 2
	DrawVerticalLine playerColor, 4
	DrawVerticalLine backgroundColor, 2
	;col 3
	inc cx
	mov dx, yPosition
	DrawVerticalLine red, 1
	DrawVerticalLine green, 2
	DrawVerticalLine playerColor, 1
	DrawVerticalLine black, 2
	DrawVerticalLine playerColor, 3
	DrawVerticalLine backgroundColor, 1
	;col 4
	inc cx
	mov dx, yPosition
	DrawVerticalLine green, 2
	DrawVerticalLine playerColor, 2
	DrawVerticalLine black, 1
	DrawVerticalLine playerColor, 3
	DrawVerticalLine backgroundColor, 2
	;col 5
	inc cx
	mov dx, yPosition
	DrawVerticalLine green, 1
	DrawVerticalLine playerColor, 5
	DrawVerticalLine backgroundColor, 4
	;col 6
	inc cx
	mov dx, yPosition
	DrawVerticalLine playerColor, 4
	DrawVerticalLine backgroundColor, 6
	;col 7
	inc cx
	mov dx, yPosition
	DrawVerticalLine playerColor, 6
	DrawVerticalLine backgroundColor, 4
	;col 8
	inc cx
	mov dx, yPosition
	DrawVerticalLine playerColor, 8
	DrawVerticalLine backgroundColor, 2
	;col 9
	inc cx
	mov dx, yPosition
	DrawVerticalLine backgroundColor, 1
	DrawVerticalLine playerColor, 8
	DrawVerticalLine backgroundColor, 1
	;col 10
	inc cx
	mov dx, yPosition
	DrawVerticalLine backgroundColor, 2
	DrawVerticalLine playerColor, 6
	DrawVerticalLine backgroundColor, 2
endm DrawPacmanDownOpen

DrawPacmanLeftOpen macro xPosition, yPosition, playerColor, backgroundColor
    ;row 1
    mov dx, yPosition
    mov cx, xPosition
	DrawHorizontalLine backgroundColor, 3
	DrawHorizontalLine playerColor, 2
	DrawHorizontalLine green, 2
	DrawHorizontalLine red, 2
	DrawHorizontalLine white, 1
    ;row 2
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine playerColor, 4
	DrawHorizontalLine green, 2
	DrawHorizontalLine red, 2
	;row 3
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine playerColor, 3
	DrawHorizontalLine black, 2
	drawhorizontalline playercolor, 1
	drawhorizontalline green, 2
	drawhorizontalline red, 1
    ;row 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine playerColor, 3
    DrawHorizontalLine black, 1
    DrawHorizontalLine playerColor, 2
    DrawHorizontalLine green, 2
    ;row 5
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 4
    DrawHorizontalLine playerColor, 5
    DrawHorizontalLine green, 1
    ;row 6
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 6
    DrawHorizontalLine playerColor, 4
    ;row 7
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 4
    DrawHorizontalLine playerColor, 6
    ;row 8
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine playerColor, 8
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
endm DrawPacmanLeftOpen

DrawPacmanRightOpen macro xPosition, yPosition, playerColor, backgroundColor
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
endm DrawPacmanRightOpen

DrawPacmanLeftClosed macro xPosition, yPosition, playerColor, backgroundColor
    ;row 1
    mov dx, yPosition
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 3
    DrawHorizontalLine playerColor, 2
    DrawHorizontalLine green, 2
    DrawHorizontalLine red, 2
    DrawHorizontalLine white, 1
    ;row 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine playerColor, 4
    DrawHorizontalLine green, 2
    DrawHorizontalLine red, 2
    ;row 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine playerColor, 3
    DrawHorizontalLine black, 2
    DrawHorizontalLine playerColor, 1
    DrawHorizontalLine green, 2
    DrawHorizontalLine red, 1
    ;row 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine playerColor, 4
    DrawHorizontalLine black, 1
    DrawHorizontalLine playerColor, 2
    DrawHorizontalLine green, 2
    ;row 5
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine playerColor, 8
    DrawHorizontalLine green, 1
    ;row 6
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine playerColor, 9
    ;row 7
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine playerColor, 9
    ;row 8
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine playerColor, 9
    ;row 9
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine playerColor, 7
    DrawHorizontalLine backgroundColor, 1
    ;row 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 3
    DrawHorizontalLine playerColor, 5
    DrawHorizontalLine backgroundColor, 2
endm DrawPacmanLeftClosed

DrawPacmanRightClosed macro xPosition, yPosition, playerColor, backgroundColor
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
endm DrawPacmanRightClosed

DrawPacmanDownClosed macro xPosition, yPosition, playerColor, backgroundColor
    ;col 1
    mov dx, yPosition
    mov cx, xPosition
    DrawVerticalLine white, 1
    DrawVerticalLine red, 2
    DrawVerticalLine green, 2
    DrawVerticalLine playerColor, 2
    DrawVerticalLine backgroundColor, 3
    ;col 2
    inc cx
    mov dx, yPosition
    DrawVerticalLine red, 2
    DrawVerticalLine green, 2
    DrawVerticalLine playerColor, 4
    DrawVerticalLine backgroundColor, 2
    ;col 3
    inc cx
    mov dx, yPosition
    DrawVerticalLine red, 1
    DrawVerticalLine green, 2
    DrawVerticalLine playerColor, 1
    DrawVerticalLine black, 2
    DrawVerticalLine playerColor, 3
    DrawVerticalLine backgroundColor, 1
    ;col 4
    inc cx
    mov dx, yPosition
    DrawVerticalLine green, 2
    DrawVerticalLine playerColor, 2
    DrawVerticalLine black, 1
    DrawVerticalLine playerColor, 4
    DrawVerticalLine backgroundColor, 1
    ;col 5
    inc cx
    mov dx, yPosition
    DrawVerticalLine green, 1
    DrawVerticalLine playerColor, 8
    DrawVerticalLine backgroundColor, 1
    ;col 6
    inc cx
    mov dx, yPosition
    DrawVerticalLine playerColor, 9
    DrawVerticalLine backgroundColor, 1
    ;col 7
    inc cx
    mov dx, yPosition
    DrawVerticalLine playerColor, 9
    DrawVerticalLine backgroundColor, 1
    ;col 8
    inc cx
    mov dx, yPosition
    DrawVerticalLine playerColor, 9
    DrawVerticalLine backgroundColor, 1
    ;col 9
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 1
    DrawVerticalLine playerColor, 7
    DrawVerticalLine backgroundColor, 2
    ;col 10
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 2
    DrawVerticalLine playerColor, 5
    DrawVerticalLine backgroundColor, 3
endm DrawPacmanDownClosed

DrawPacmanUpClosed macro xPosition, yPosition, playerColor, backgroundColor

    ;col 1
    mov dx, yPosition
    mov cx, xPosition
    DrawVerticalLine backgroundColor, 3
    DrawVerticalLine playerColor, 2
    DrawVerticalLine green, 2
    DrawVerticalLine red, 2
    DrawVerticalLine white, 1
    ;col 2
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 2
    DrawVerticalLine playerColor, 4
    DrawVerticalLine green, 2
    DrawVerticalLine red, 2
    ;col 3
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 1
    DrawVerticalLine playerColor, 3
    DrawVerticalLine black, 2
    DrawVerticalLine playerColor, 1
    DrawVerticalLine green, 2
    DrawVerticalLine red, 1
    ;col 4
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 1
    DrawVerticalLine playerColor, 4
    DrawVerticalLine black, 1
    DrawVerticalLine playerColor, 2
    DrawVerticalLine green, 2
    ;col 5
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 1
    DrawVerticalLine playerColor, 8
    DrawVerticalLine green, 1
    ;col 6
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 1
    DrawVerticalLine playerColor, 9
    ;col 7
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 1
    DrawVerticalLine playerColor, 9
    ;col 8
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 1
    DrawVerticalLine playerColor, 9
    ;col 9
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 2
    DrawVerticalLine playerColor, 7
    DrawVerticalLine backgroundColor, 1
    ;col 10
    inc cx
    mov dx, yPosition
    DrawVerticalLine backgroundColor, 3
    DrawVerticalLine playerColor, 5
    DrawVerticalLine backgroundColor, 2
endm DrawPacmanUpClosed
.model huge
.386 
.stack 0ffffh
.data
    black   equ 00h
    blue    equ 01h
    lightMagenta equ 0dh
    green   equ 02h
    red     equ 04h
    yellow  equ 0eh
    white   equ 0fh
.code
main proc far
            mov                    ax, @data
            mov                    ds, ax
            SetVideoMode
            DrawPacmanRightClosed    150, 150, yellow, lightMagenta
            DrawPacmanLeftClosed     100, 50, yellow, lightMagenta
            DrawPacmanDownClosed    50, 50, yellow, lightMagenta
            DrawPacmanUpClosed      70,70, yellow, lightMagenta

    dummy:  jmp dummy
main endp
end main

