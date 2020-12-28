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

SetVideoMode macro   ;320x200 pixel supporting 256 colors , 40x25 , (40 -> col - > x - > dl) , (25 -> row -> y -> dh)
		mov ah,0
		mov al,13h
		int 10h
endm SetVideoMode

DrawGhost macro ghostXStart, ghostYStart
	    mov                cx, ghostXStart
	    mov                dx, ghostYStart
	    DrawHorizontalLine black, 4
		DrawHorizontalLine ghostColor, 2
	    DrawHorizontalLine black, 4

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 3
		DrawHorizontalLine ghostColor, 4
		DrawHorizontalLine black, 3

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 2
		DrawHorizontalLine ghostColor, 6
		DrawHorizontalLine black, 2

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 8
		DrawHorizontalLine black, 1

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 1
		DrawHorizontalLine black, 1
		DrawHorizontalLine White, 1
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 1
		DrawHorizontalLine White, 1
		DrawHorizontalLine ghostColor, 1

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 1
		DrawHorizontalLine black, 2
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 2
		DrawHorizontalLine ghostColor, 1

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 8
		DrawHorizontalLine black, 1

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 8
		DrawHorizontalLine black, 1

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 1

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 1
		DrawHorizontalLine black, 2
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 2
		DrawHorizontalLine ghostColor, 1
		DrawHorizontalLine black, 2
		DrawHorizontalLine black, 1

endm DrawGhost

.model small
.stack 64
.data
	ghostXStart dw  50
	ghostYStart dw  20
	ghostColor  equ 0Dh
	black       equ 00h
	blue        equ 01h
	green       equ 02h
	red         equ 04h
	lightMagenta equ 0Dh
	yellow      equ 0eh
    white   equ 0fh
.CODE

main proc FAR
	    mov                ax, @data
	    mov                ds, ax
	;row1
	    SetVideoMode

		DrawGhost 100,150

	    mov                cx, ghostXStart
	    mov                dx, ghostystart
	    DrawHorizontalLine black, 4
		DrawHorizontalLine ghostColor, 2
	    DrawHorizontalLine black, 4

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 3
		DrawHorizontalLine ghostColor, 4
		DrawHorizontalLine black, 3

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 2
		DrawHorizontalLine ghostColor, 6
		DrawHorizontalLine black, 2

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 8
		DrawHorizontalLine black, 1

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 1
		DrawHorizontalLine black, 1
		DrawHorizontalLine White, 1
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 1
		DrawHorizontalLine White, 1
		DrawHorizontalLine ghostColor, 1


		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 1
		DrawHorizontalLine black, 2
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 2
		DrawHorizontalLine ghostColor, 1

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 8
		DrawHorizontalLine black, 1

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 8
		DrawHorizontalLine black, 1

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 1

		inc dx
		mov cx, ghostXStart
		DrawHorizontalLine black, 1
		DrawHorizontalLine ghostColor, 1
		DrawHorizontalLine black, 2
		DrawHorizontalLine ghostColor, 2
		DrawHorizontalLine black, 2
		DrawHorizontalLine ghostColor, 1
		DrawHorizontalLine black, 2
		DrawHorizontalLine black, 1
	lbl: jmp                lbl
main endp
end main