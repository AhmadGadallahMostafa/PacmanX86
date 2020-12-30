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

DrawBigHorizontalLine macro color, count, width
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

DrawLoadingScreen macro backgroundColor,foregroundColor1,foregroundColor2
mov cx,0
mov dx,0
;Area Above P
DrawBigHorizontalLine backgroundColor,320,25
;Row 1 P
add dx,25
mov cx,0
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,10*5,5
DrawBigHorizontalLine backgroundColor,21*5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5*5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,3*5,5
DrawBigHorizontalLine backgroundColor,9*5,5
;Row 2 P
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,10*5,5
DrawBigHorizontalLine backgroundColor,21*5,5
DrawBigHorizontalLine foregroundColor2,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor ,11*5,5
;Row 3 P
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,5*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,23*5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor ,11*5,5
;Row 4 P
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,5*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,24*5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,4*5,5
DrawBigHorizontalLine foregroundColor2,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,3*5,5
DrawBigHorizontalLine backgroundColor,9*5,5
;Row 5 P
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,5*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,23*5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,9*5,5
;Row  6 P
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,5*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,21*5,5
DrawBigHorizontalLine foregroundColor2,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,9*5,5
;Row 7 P
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,5*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,21*5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5*5,5
DrawBigHorizontalLine foregroundColor2,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor2,3*5,5
DrawBigHorizontalLine backgroundColor,9*5,5
;Row 8 P
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,10*5,5
DrawBigHorizontalLine backgroundColor,45*5,5
;Row 9 P
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,52*5,5
;Row 10 P
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,6*5,5
DrawBigHorizontalLine backgroundColor,4*5,5
DrawBigHorizontalLine foregroundColor1,4*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,10*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,6*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,7*5,5
DrawBigHorizontalLine backgroundColor,9*5,5
;Row 11 P
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,6*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,10*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,6*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,7*5,5
DrawBigHorizontalLine backgroundColor,9*5,5
;Row 12 p aka awel sater fady fe a 
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,9*5,5
;Row 13 P AKA tany sater fady fe a
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,4*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,9*5,5
;Row 14 aka talt satr fady fe a
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,9*5,5
;Row 15 P aka a5r satr gadallah ha yktbo fe el 2araf dah 
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,9*5,5
DrawBigHorizontalLine foregroundColor1,3*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,8*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,4*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,2*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,8*5,5
DrawBigHorizontalLine backgroundColor,5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,3*5,5
DrawBigHorizontalLine foregroundColor1,2*5,5
DrawBigHorizontalLine backgroundColor,9*5,5
;Rest Of Main Menu
mov cx,0
add dx,5
DrawBigHorizontalLine backgroundColor,320,100
endm DrawLoadingScreen


.model small
.stack 64
.data
	lightCyan equ 11
	salmon    equ 12
	yellow    equ 14
	black     equ 0

.code
main proc far
	     SetVideoMode
	     DrawLoadingScreen black,yellow,lightCyan
	lbl: jmp               lbl
main endp
end main