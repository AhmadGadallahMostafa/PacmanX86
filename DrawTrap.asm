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

SetVideoMode macro   ;320x200 pixel supporting 256 colors , 40x25 , (40 -> col - > x - > dl) , (25 -> row -> y -> dh)
		mov ah,0
		mov al,13h
		int 10h
endm SetVideoMode

DrawTrap macro xPosition,yPosition,backGroundColor,bodyColor1,bodyColor2
mov cx,xPosition
mov dx,yPosition
;row1
DrawHorizontalLine backGroundColor,3
DrawHorizontalLine bodyColor1,4
DrawHorizontalLine backGroundColor,3
;row2
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor,2
DrawHorizontalLine bodyColor2,1
DrawHorizontalLine bodyColor2,1
DrawHorizontalLine bodyColor1,2
DrawHorizontalLine bodyColor2,1
DrawHorizontalLine bodyColor2,1
DrawHorizontalLine backGroundColor,2
;row3
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor,1
DrawHorizontalLine bodyColor1,1
DrawHorizontalLine bodyColor2,1
DrawHorizontalLine 14,1
DrawHorizontalLine bodyColor2,2
DrawHorizontalLine 14,1
DrawHorizontalLine bodyColor2,1
DrawHorizontalLine bodyColor1,1
DrawHorizontalLine backGroundColor,1

;row4
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor,1
DrawHorizontalLine bodyColor1,8
DrawHorizontalLine backGroundColor,1

;row5
mov cx,xPosition
inc dx
DrawHorizontalLine bodyColor1,2
DrawHorizontalLine 0fh,6
DrawHorizontalLine bodyColor1,2

;row6
mov cx,xPosition
inc dx
DrawHorizontalLine bodyColor1,2
DrawHorizontalLine 4,6
DrawHorizontalLine bodyColor1,2

;row7
mov cx,xPosition
inc dx
DrawHorizontalLine bodyColor1,3
DrawHorizontalLine 0ch,4
DrawHorizontalLine bodyColor1,3

;row8
mov cx,xPosition
inc dx
DrawHorizontalLine bodyColor1,2
DrawHorizontalLine bodyColor2,1
DrawHorizontalLine bodyColor1,4
DrawHorizontalLine bodyColor2,1
DrawHorizontalLine bodyColor1,2

;row9
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor,1
DrawHorizontalLine bodyColor1,2
DrawHorizontalLine bodyColor2,4
DrawHorizontalLine bodyColor1,2
DrawHorizontalLine backGroundColor,1

;row10
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor,2
DrawHorizontalLine bodyColor1,6
DrawHorizontalLine backGroundColor,2

endm DrawTrap

.model small
.stack 64
.data
.code
main proc far
mov ax,@data
mov ds,ax
SetVideoMode
DrawTrap 50,50,1,0ah,2
lbl:jmp lbl
main endp
end main