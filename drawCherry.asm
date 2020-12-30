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

DrawCherry macro xPosition,yPosition,rootColor,cherryColor,backGroundColor
;row1
mov cx,xPosition
mov dx,yPosition
DrawHorizontalLine backgroundColor,10
;row2
inc dx
mov cx,xPosition
DrawHorizontalLine backgroundColor,5
DrawHorizontalLine rootColor,1
DrawHorizontalLine backgroundColor,4
;row3
inc dx
mov cx,xPosition
DrawHorizontalLine backgroundColor,4
DrawHorizontalLine rootColor,2
DrawHorizontalLine backgroundColor,4
;row4
inc dx
mov cx,xPosition
DrawHorizontalLine backgroundColor,3
DrawHorizontalLine rootColor,1
DrawHorizontalLine backgroundColor,2
DrawHorizontalLine rootColor,1
DrawHorizontalLine backgroundColor,3
;row5
inc dx
mov cx,xPosition
DrawHorizontalLine backgroundColor,2
DrawHorizontalLine rootColor,1
DrawHorizontalLine backgroundColor,4
DrawHorizontalLine rootColor,1
DrawHorizontalLine backgroundColor,2
;row6
inc dx
mov cx,xPosition
DrawHorizontalLine backgroundColor,1
DrawHorizontalLine cherryColor,2
DrawHorizontalLine backgroundColor,3
DrawHorizontalLine cherryColor,3
DrawHorizontalLine backgroundColor,1
;row7
inc dx
mov cx,xPosition
DrawHorizontalLine cherryColor,2
DrawHorizontalLine backgroundColor,1
DrawHorizontalLine cherryColor,1
DrawHorizontalLine backgroundColor,1
DrawHorizontalLine cherryColor,2
DrawHorizontalLine backgroundColor,1
DrawHorizontalLine cherryColor,2
;row8
inc dx
mov cx,xPosition
DrawHorizontalLine cherryColor,4
DrawHorizontalLine backgroundColor,1
DrawHorizontalLine cherryColor,3
DrawHorizontalLine backgroundColor,1
DrawHorizontalLine cherryColor,1
;row9
inc dx
mov cx,xPosition
DrawHorizontalLine backgroundColor,1
DrawHorizontalLine cherryColor,2
DrawHorizontalLine backgroundColor,3
DrawHorizontalLine cherryColor,3
DrawHorizontalLine backgroundColor,1
;row10
inc dx
mov cx,xPosition
DrawHorizontalLine backgroundColor,10
endm DrawCherry


.model small
.stack 64
.code
main proc far
	     SetVideoMode
	     DrawCherry   20,20,48,41,0fh
main endp
end main