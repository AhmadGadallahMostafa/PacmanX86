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

DrawBigHorizontalLine macro color, count, width ; put xPosition in cx, and yPosition in dx before calling
local DrawLoop
local DrawColumn
        mov ah, 0ch
        mov al, color
        mov bx, count
    DrawLoop:
        mov si, width
        DrawColumn:
            int 10h
            inc dx
            dec si
            jnz DrawColumn
        inc cx
        sub dx, width
        dec bx
        jnz DrawLoop
endm DrawHorizontalLine


SetVideoMode macro   ;320x200 pixel supporting 256 colors , 40x25 , (40 -> col - > x - > dl) , (25 -> row -> y -> dh)
		mov ah,0
		mov al,13h
		int 10h
endm SetVideoMode

DrawCornerLeftUp macro xPosition, yPosition, borderColor, fillColor, backgroundColor
    mov cx, xPosition
    mov dx, yPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 4
    DrawHorizontalLine borderColor, 6
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 3
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 5
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
endm DrawCornerLeftUp

DrawCornerRightUp macro xPosition, yPosition, borderColor, fillColor, backgroundColor
    mov cx, xPosition
    mov dx, yPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 6
    DrawHorizontalLine backgroundColor, 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 5
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
endm DrawCornerRightUp

DrawCornerLeftDown macro xPosition, yPosition, borderColor, fillColor, backgroundColor
    mov cx, xPosition
    mov dx, yPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 3
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 5
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 4
    DrawHorizontalLine borderColor, 6
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
endm DrawCornerLeftDown

DrawCornerRightDown macro xPosition, yPosition, borderColor, fillColor, backgroundColor
    mov cx, xPosition
    mov dx, yPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 5
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 6
    DrawHorizontalLine backgroundColor, 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
endm DrawCornerRightDown

DrawWallHorizontal macro xPosition, yPosition, borderColor, fillColor, backgroundColor
    mov cx, xPosition
    mov dx, yPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 6
    DrawHorizontalLine fillColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 6
    DrawHorizontalLine fillColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
endm DrawWallHorizontal

DrawWallVertical macro xPosition, yPosition, borderColor, fillColor, backgroundColor
    mov cx, xPosition
    mov dx, yPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
     DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
endm DrawWallVertical

DrawEndWallHorizontalLeft macro xPosition, yPosition, borderColor, fillColor, backgroundColor
    mov cx, xPosition
    mov dx, yPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 7
    DrawHorizontalLine backgroundColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 6
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 4
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 4
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 6
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 7
    DrawHorizontalLine backgroundColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10 
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
endm DrawEndWallHorizontalLeft

DrawEndWallVerticalUp macro xPosition, yPosition, borderColor, fillColor, backgroundColor
    mov cx, xPosition
    mov dx, yPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 3
    DrawHorizontalLine borderColor, 4
    DrawHorizontalLine backgroundColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
endm DrawEndWallVerticalUp


.model small
.stack 64
.data
.code
main proc far
mov ax,@data
mov ds,ax
SetVideoMode
DrawCornerLeftUp 20,20,0,0fh,14
DrawWallHorizontal 60,60,0,0fh,14
DrawWallVertical 40,40,0,0fh,14
DrawEndWallVerticalUp 80,80,0,0fh,14
DrawEndWallHorizontalLeft 100,100,0,0fh,14
DrawCornerRightUp 120,120,0,0fh,14
DrawCornerLeftDown 140,140,0,0fh,14
DrawCornerRightDown 160,160,0,0fh,14
lbl:jmp lbl
main endp
end main
