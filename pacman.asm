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

.model small
.data
    xPosition equ 50
    yPosition equ 50
    color equ 0eh
.code
main proc far
        mov ax, @data
        mov ds, ax
        mov ah, 0h
        mov al, 13h
        int 10h

		mov ah, 0ch

		mov dx, yPosition
		mov cx, xPosition
		DrawHorizontalLine 0fh, 1
		DrawHorizontalLine 04h, 2
		DrawHorizontalLine 02h, 1
		DrawHorizontalLine color, 3

		inc dx
		mov cx, xPosition
		DrawHorizontalLine 04h, 2
		DrawHorizontalLine 02h, 1
		DrawHorizontalLine color, 5

		inc dx
		mov cx, xPosition
		DrawHorizontalLine 04h, 1
		DrawHorizontalLine 02h, 1
		DrawHorizontalLine color, 2
		DrawHorizontalLine 00h, 1
		DrawHorizontalLine color, 4

		inc dx
		mov cx, xPosition
		DrawHorizontalLine 02h, 1
		DrawHorizontalLine color, 7

		inc dx
		mov cx, xPosition
		DrawHorizontalLine color, 7

		inc dx
		mov cx, xPosition
		DrawHorizontalLine color, 7

		inc dx
		mov cx, xPosition
		DrawHorizontalLine color, 8

		inc dx
		mov cx, xPosition
		add cx, 1
		DrawHorizontalLine color, 8

		inc dx
		mov cx, xPosition
		add cx, 2
		DrawHorizontalLine color, 6

		inc dx
		mov cx, xPosition
		add cx, 3
		DrawHorizontalLine color, 4
        kossomasm86:nop
        jmp kossomasm86
main endp
end main