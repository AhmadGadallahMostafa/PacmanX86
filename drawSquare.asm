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

DrawVerticalLine macro color, count
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

DrawSquare macro  color , xPosition , yPosition
          mov                cx,xPosition
	      mov                dx,yPosition
	      DrawHorizontalLine 14,10
	      dec                cx
	      DrawVerticalLine   14,10
	      mov                cx,xPosition
	      mov                dx,yPosition
	      DrawVerticalLine   14,10
	      dec                dx
	      DrawHorizontalLine 14,10
endm DrawSquare

.model small
.stack 64
.data
	gridXStart equ 0
	gridYStart equ 20
	rowCount   db  16
colCount db 32
.code
main proc far
	      mov          ax,@data
	      mov          ds,ax
	      SetVideoMode
	      DrawSquare   14,gridXStart,gridYStart
	      DrawSquare   14,gridXStart+10,gridYStart
	      DrawSquare   14,gridXStart+20,gridYStart
	      DrawSquare   14,gridXStart+30,gridYStart

	dummy:jmp          dummy

main endp
end main