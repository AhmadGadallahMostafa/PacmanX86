;Authors : Ahmad Mostafa El Sayed
;         Muhab Hossam El Din
;         Mazen Amr
;         Youssef Shams

;	Start Date : 25/12/2020
;	Project Description : Simple PacMan game including two players competeing for the highest score

;Naming convention guidelines (PLEASE FOLLOW):
;	1-	Variables use camelCase
;	2-	Jumps and Macros use PascalCase

;---------------------------------------------------------------------------------------

;---------------------------------------------------------------------------------------
; MACROS
;---------------------------------------------------------------------------------------
;I/O MACROS
DisplayString macro str    ;this macro displays a string when given its memory variable name
		mov dx, offset str
		mov ah, 9h
		int 21h
endm DisplayString

;---------------------------------------------------------------------------------------

ReadString macro message , buffer    ;this macro displays a string promptmessage and reads a string and saves it in a buffer , when displaying usage : displasystring buffer +2
		DisplayString message
		mov ah, 0ah
		mov dx, offset buffer
		int 21h
endm ReadString

;---------------------------------------------------------------------------------------

DisplayChar macro    ;displays the character stored in dl
		mov ah, 2
		int 21h
endm DisplayChar

;---------------------------------------------------------------------------------------

DisplayNumber macro number    ;displays the number saved in memory variable x max size : 65535
local Division
local Display
		mov si, offset number
		mov ax, [si]
		mov bx, 10d
		mov cx, 0
	Division:
		mov bx, 10d
		cwd
		mov dx, 0
		div bx
		push dx
		inc cx
		cmp ax, 0
		jnz Division
	Display:
		pop dx
		add dx, 48d
		DisplayChar
		loop Display
endm DisplayNumber

;---------------------------------------------------------------------------------------

ReadNumber macro promptMes, buffer    ; reads two digit numbers from user :number moved to ax
		ReadString promptMes, buffer
		mov al, buffer+2
		mov bl, buffer+3
		sub al, 48d
		sub bl, 48d
		mov ah, 0
		mov bh, 0
		mov dx, 10d
		mul dx
		add ax, bx
endm ReadNumber

;---------------------------------------------------------------------------------------

;Generic macros:

MoveCursor macro    ;This macro moves the cursor to position set in dx
		mov ah,2
		int 10h
endm MoveCursor

;---------------------------------------------------------------------------------------

SetTextMode macro   ;80x25 16 color , 8 pages 
		mov ah,0
		mov al,03h
		int 10h
endm SetTextMode

;---------------------------------------------------------------------------------------

SetVideoMode macro   ;320x200 pixel supporting 256 colors , 40x25 , (40 -> col - > x - > dl) , (25 -> row -> y -> dh)
		mov ah,0
		mov al,13h
		int 10h
endm SetVideoMode

;---------------------------------------------------------------------------------------

;Before using this macro use the following command: mov si,@data
DisplayTextVideoMode macro lengthString,xPosition,yPosition,string,color
		mov ah,13h
		mov al,0
		mov bh,0
		mov bl,color
		mov ch,0
		mov cl,lengthString
		mov dh,yPosition
		mov dl,xPosition
		mov es,si
		mov bp,offset string
		int 10h
endm DisplayTextVideoMode

;---------------------------------------------------------------------------------------

DisplayNumberVideoMode macro xPosition,yPosition,number
		local Division
		local Display
		mov si, offset number
		mov ax, [si]
		mov bx, 10d
		mov cx, 0
	Division:
		mov bx, 10d
		cwd
		mov dx, 0
		div bx
		push dx
		inc cx
		cmp ax, 0
		jnz Division
	Display:
		pop dx
		add dx, 48d
		push dx
		mov dl, xPosition
		sub dl, cl
		mov dh, yPosition
		MoveCursor
		pop dx
		mov bl,13
		DisplayChar
		loop Display
endm DisplayNumberVideoMode

;---------------------------------------------------------------------------------------

ValidateName macro name    ;valdiating that the first char of the letter is a alphabatical charchter
		local ConfrimInvalid
		local Invalid
		local Valid 
		local Terminate
		lea si, name+2
		mov bl, [si]
		cmp bl, 'A'
		jb Invalid
		cmp bl, 'z'
		ja Invalid
		cmp bl, 'Z'
		ja ConfrimInvalid
		jmp Valid
	ConfrimInvalid:
		cmp bl, 'a'
		jb Invalid
		jmp Valid
	Invalid:
		mov bl, 0
		jmp Terminate
	Valid:
		mov bl, 1
	Terminate:
endm ValidateName

;---------------------------------------------------------------------------------------

;---------------------------------------------------------------------------------------
; DRAWING
;---------------------------------------------------------------------------------------
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

;---------------------------------------------------------------------------------------
; SQUARE
;---------------------------------------------------------------------------------------
DrawSquare macro xPosition, yPosition, sideLength, edgeColor, fillColor
local drawFill
	mov dx, yPosition
	mov cx, xPosition
	DrawHorizontalLine edgeColor, sideLength
	mov si, 8
	drawFill:
		inc dx
		mov cx, xPosition
		DrawHorizontalLine edgeColor, 1
		DrawHorizontalLine fillColor, sideLength-2
		; add cx, gridStep-2
		DrawHorizontalLine edgeColor, 1
		dec si
		jnz drawFill
	inc dx
	mov cx, xPosition
	DrawHorizontalLine edgeColor, sideLength
endm DrawSquare

;---------------------------------------------------------------------------------------
; Draw Dot
;---------------------------------------------------------------------------------------
DrawDot macro xPosition, yPosition,dotColor, backgroundColor
local drawFill
	mov dx, yPosition
	mov cx, xPosition
	DrawBigHorizontalLine backgroundColor,10,4
	add dx,4
	mov cx,xPosition
	DrawBigHorizontalLine backgroundColor,4,2
	DrawBigHorizontalLine dotColor,2,2
	DrawBigHorizontalLine backgroundColor,4,2
	add dx,2
	mov cx,xPosition
	DrawBigHorizontalLine backgroundColor,10,4
endm DrawDot

;---------------------------------------------------------------------------------------
;LOADING SCREEN
;---------------------------------------------------------------------------------------
DrawLoadingScreen macro backgroundColor,foregroundColor1,foregroundColor2
	mov cx, 0
	mov dx, 0
	;Area Above P
	DrawBigHorizontalLine backgroundColor, 320, 25
	;Row 1 P
	add dx, 25
	mov cx, 0
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 10*5, 5
	DrawBigHorizontalLine backgroundColor, 21*5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5*5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	;Row 2 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 10*5, 5
	DrawBigHorizontalLine backgroundColor, 21*5, 5
	DrawBigHorizontalLine foregroundColor2, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor , 11*5, 5
	;Row 3 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 5*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 23*5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 11*5, 5
	;Row 4 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 5*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 24*5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 4*5, 5
	DrawBigHorizontalLine foregroundColor2, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	;Row 5 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 23*5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	;Row 6 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 21*5, 5
	DrawBigHorizontalLine foregroundColor2, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	;Row 7 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 21*5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5*5, 5
	DrawBigHorizontalLine foregroundColor2, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor2, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	;Row 8 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 10*5, 5
	DrawBigHorizontalLine backgroundColor, 45*5, 5
	;Row 9 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 52*5, 5
	;Row 10 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 6*5, 5
	DrawBigHorizontalLine backgroundColor, 4*5, 5
	DrawBigHorizontalLine foregroundColor1, 4*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 10*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 6*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 7*5, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	;Row 11 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 6*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 10*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 6*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 7*5, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	;Row 12 P (first empty row inside a)
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	;Row 13 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 4*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	;Row 14
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	;Row 15 P
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	DrawBigHorizontalLine foregroundColor1, 3*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 8*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 4*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 2*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 8*5, 5
	DrawBigHorizontalLine backgroundColor, 5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 3*5, 5
	DrawBigHorizontalLine foregroundColor1, 2*5, 5
	DrawBigHorizontalLine backgroundColor, 9*5, 5
	;Rest Of Main Menu
	mov cx, 0
	add dx, 5
	DrawBigHorizontalLine backgroundColor, 320, 100
endm DrawLoadingScreen
;---------------------------------------------------------------------------------------
; PACMAN
;---------------------------------------------------------------------------------------
DrawPacmanRightOpened macro xPosition, yPosition, playerColor, backgroundColor
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
endm DrawPacmanRightOpened

DrawPacmanLeftOpened macro xPosition, yPosition, playerColor, backgroundColor
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
endm DrawPacmanLeftOpened

DrawPacmanUpOpened macro xPosition, yPosition, playerColor, backgroundColor
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
endm DrawPacmanUpOpened

DrawPacmanDownOpened macro xPosition, yPosition, playerColor, backgroundColor
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
endm DrawPacmanDownOpened

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

DrawPlayer macro xPosition, yPosition, playerColor, backgroundColor, isOpen, orientation
local ExitMacro
local IsClosed
local RightOpened
local LeftOpened
local UpOpened
local DownOpened
local RightClosed
local LeftClosed
local UpClosed
local DowntClosed
	cmp isOpen, 0
	je IsClosed
		cmp orientation, 'R'
		je RightOpened
		cmp orientation, 'L'
		je LeftOpened
		cmp orientation, 'U'
		je UpOpened
		cmp orientation, 'D'
		je DownOpened
		jmp ExitMacro
	IsClosed:
		cmp orientation, 'R'
		je RightClosed
		cmp orientation, 'L'
		je LeftClosed
		cmp orientation, 'U'
		je UpClosed
		cmp orientation, 'D'
		je DowntClosed
		jmp ExitMacro
	RightOpened:
		DrawPacmanRightOpened xPosition, yPosition, playerColor, backgroundColor
		jmp ExitMacro
	LeftOpened:
		DrawPacmanLeftOpened xPosition, yPosition, playerColor, backgroundColor
		jmp ExitMacro
	UpOpened:
		DrawPacmanUpOpened xPosition, yPosition, playerColor, backgroundColor
		jmp ExitMacro
	DownOpened:
		DrawPacmanDownOpened xPosition, yPosition, playerColor, backgroundColor
		jmp ExitMacro
	RightClosed:
		DrawPacmanRightClosed xPosition, yPosition, playerColor, backgroundColor
		jmp ExitMacro
	LeftClosed:
		DrawPacmanLeftClosed xPosition, yPosition, playerColor, backgroundColor
		jmp ExitMacro
	UpClosed:
		DrawPacmanUpClosed xPosition, yPosition, playerColor, backgroundColor
		jmp ExitMacro
	DowntClosed:
		DrawPacmanDownClosed xPosition, yPosition, playerColor, backgroundColor
		jmp ExitMacro
	ExitMacro:
endm DrawPlayer

;---------------------------------------------------------------------------------------
; GHOST
;---------------------------------------------------------------------------------------
DrawGhost macro xPosition, yPosition, ghostColor, backgroundColor
	;row 1
	mov cx, xPosition
	mov dx, yPosition
	DrawHorizontalLine backgroundColor, 4
	DrawHorizontalLine ghostColor, 2
	DrawHorizontalLine backgroundColor, 4
	;row 2
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 3
	DrawHorizontalLine ghostColor, 4
	DrawHorizontalLine backgroundColor, 3
	;row 3
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine ghostColor, 6
	DrawHorizontalLine backgroundColor, 2
	;row 4
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine ghostColor, 8
	DrawHorizontalLine backgroundColor, 1
	;row 5
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine ghostColor, 1
	DrawHorizontalLine black, 1
	DrawHorizontalLine White, 1
	DrawHorizontalLine ghostColor, 2
	DrawHorizontalLine black, 1
	DrawHorizontalLine White, 1
	DrawHorizontalLine ghostColor, 1
	DrawHorizontalLine backgroundColor, 1
	;row 6
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine ghostColor, 1
	DrawHorizontalLine black, 2
	DrawHorizontalLine ghostColor, 2
	DrawHorizontalLine black, 2
	DrawHorizontalLine ghostColor, 1
	DrawHorizontalLine backgroundColor, 1
	;row 7
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine ghostColor, 8
	DrawHorizontalLine backgroundColor, 1
	;row 8
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine ghostColor, 8
	DrawHorizontalLine backgroundColor, 1
	;row 9
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine ghostColor, 2
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine ghostColor, 2
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine ghostColor, 2
	DrawHorizontalLine backgroundColor, 1
	;row 10
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine ghostColor, 1
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine ghostColor, 2
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine ghostColor, 1
	DrawHorizontalLine backgroundColor, 1
endm DrawGhost

;---------------------------------------------------------------------------------------
; SNOWFLAKE
;---------------------------------------------------------------------------------------
DrawSnowflake macro xPosition, yPosition, snowflakeColor, backgroundColor
	;row 1
	mov dx, yPosition
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor,6
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	;row 2
	inc dx
	mov cx, xPosition
	DrawHorizontalLine snowflakeColor, 2
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 2
	;row 3
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 2
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 2
	;row 4
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	;row 5
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 2
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 2
	;row 6
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 2
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 2
	;row 7
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	;row 8
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 2
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 2
	;row 9
	inc dx
	mov cx, xPosition
	DrawHorizontalLine snowflakeColor, 2
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 2
	;row 10
	inc dx
	mov cx, xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor,6
	DrawHorizontalLine snowflakeColor, 1
	DrawHorizontalLine backgroundColor, 1
endm DrawSnowflake

;---------------------------------------------------------------------------------------
; CHERRY
;---------------------------------------------------------------------------------------
DrawCherry macro xPosition, yPosition, cherryColor, rootColor, backgroundColor
	;row 1
	mov cx,xPosition
	mov dx,yPosition
	DrawHorizontalLine backgroundColor, 10
	;row 2
	inc dx
	mov cx,xPosition
	DrawHorizontalLine backgroundColor, 5
	DrawHorizontalLine rootColor, 1
	DrawHorizontalLine backgroundColor, 4
	;row 3
	inc dx
	mov cx,xPosition
	DrawHorizontalLine backgroundColor, 4
	DrawHorizontalLine rootColor, 2
	DrawHorizontalLine backgroundColor, 4
	;row 4
	inc dx
	mov cx,xPosition
	DrawHorizontalLine backgroundColor, 3
	DrawHorizontalLine rootColor, 1
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine rootColor, 1
	DrawHorizontalLine backgroundColor, 3
	;row 5
	inc dx
	mov cx,xPosition
	DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine rootColor, 1
	DrawHorizontalLine backgroundColor, 4
	DrawHorizontalLine rootColor, 1
	DrawHorizontalLine backgroundColor, 2
	;row 6
	inc dx
	mov cx,xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine cherryColor, 2
	DrawHorizontalLine backgroundColor, 3
	DrawHorizontalLine cherryColor, 3
	DrawHorizontalLine backgroundColor, 1
	;row 7
	inc dx
	mov cx,xPosition
	DrawHorizontalLine cherryColor, 2
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine cherryColor, 1
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine cherryColor, 2
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine cherryColor, 2
	;row 8
	inc dx
	mov cx,xPosition
	DrawHorizontalLine cherryColor, 4
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine cherryColor, 3
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine cherryColor, 1
	;row 9
	inc dx
	mov cx,xPosition
	DrawHorizontalLine backgroundColor, 1
	DrawHorizontalLine cherryColor, 2
	DrawHorizontalLine backgroundColor, 3
	DrawHorizontalLine cherryColor, 3
	DrawHorizontalLine backgroundColor, 1
	;row 10
	inc dx
	mov cx,xPosition
	DrawHorizontalLine backgroundColor, 10
endm DrawCherry

;---------------------------------------------------------------------------------------
; Walls
;---------------------------------------------------------------------------------------
DrawCornerWallLeftUp macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
endm DrawCornerWallLeftUp

DrawCornerWallRightUp macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
endm DrawCornerWallRightUp

DrawCornerWallLeftDown macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
endm DrawCornerWallLeftDown

DrawCornerWallRightDown macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
endm DrawCornerWallRightDown

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

DrawEndWallRight macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
endm DrawEndWallRight

DrawEndWallDown macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
endm DrawEndWallDown

DrawEndWallLeft macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
endm DrawEndWallLeft

DrawEndWallUp macro xPosition, yPosition, borderColor, fillColor, backgroundColor
    mov cx, xPosition
    mov dx, yPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 3
    DrawHorizontalLine borderColor, 4
    DrawHorizontalLine backgroundColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
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
endm DrawEndWallUp 

DrawQuadWall macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 5
    DrawHorizontalLine fillColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 5
    DrawHorizontalLine fillColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 3
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
endm DrawQuadWall

DrawTriWallDown macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 4
    DrawHorizontalLine fillColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 8
    DrawHorizontalLine fillColor, 1
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
endm DrawTriWallDown

DrawTriWallUp macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 8
    DrawHorizontalLine fillColor, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 4
    DrawHorizontalLine fillColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 3
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
endm DrawTriWallUp

DrawTriWallRight macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 2
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
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 3
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
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
endm DrawTriWallRight

DrawTriWallLeft macro xPosition, yPosition, borderColor, fillColor, backgroundColor
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
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 4
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
    DrawHorizontalLine fillColor, 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
endm DrawTriWallLeft

;---------------------------------------------------------------------------------------
; BigDot
;---------------------------------------------------------------------------------------
DrawBigDot macro xPosition, yPosition, fillColor, backgroundColor
    mov cx, xPosition
    mov dx, yPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 4
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine backgroundColor, 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 3
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine backgroundColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine fillColor, 6
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine fillColor, 6
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 3
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine backgroundColor, 3
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 4
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine backgroundColor, 4
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 10
endm DrawBigDot

;----------------------------------------------------------------------------------------
; Trap
;----------------------------------------------------------------------------------------
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
;----------------------------------------------------------------------------------------

GridToCell macro gridX, gridY ; takes xPosition, yPosition, puts the cell number in bx
	mov bx, word ptr gridY
	shl bx, 5
	shl gridY, 1
	sub bx, word ptr gridY
	shr gridY, 1
	add bx, word ptr gridX
endm CheckWall

FindPath macro gridX, gridY ; BFS Algorithm
	mov ax, @data
	mov es, ax
	mov cx, 480
	mov si, offset zeros
	mov di, offset gridChecked
	rep movsb
	mov cx, 480
	mov si, offset zeros
	mov di, offset nodesToSearch
	rep movsw
	mov di, 0
	mov nodesToSearch[di], byte ptr gridX
	inc di
	mov nodesToSearch[di], byte ptr gridY
	mov si, 0
	SearchLoop:
		cmp si, di
		jle EndSearch
		mov bh, nodesToSearch[si]
		inc si
		mov bl, nodesToSearch[si]
		inc si
		mov nodeX, bh
		mov nodeY, bl
		GridToCell nodeX, nodeY
		cmp gridChecked[bx], 0
		jne SearchLoop
		mov gridChecked[bx], 1
		cmp grid[bx], player1Code
		je Found
		cmp grid[bx], player2Code
		je Found
		jmp ContinueSearch
	ContinueSearch:
		jmp SearchLoop
	Found:
		mov ax, 
	EndSearch:
endm FindPath

;---------------------------------------------------------------------------------------

.model huge
.386 
.stack 0ffffh
.data
	player1Name         db  15 , ? , 30 dup("$")                                                              	;variable holding player 1 name
	player2Name         db  15 , ? , 30 dup("$")                                                              	;variable holding player 2 name
	nameMessage         db  'Please Enter Your Name: $'                                                       	;Message displayed to prompt the user to enter his name
	enterMessage        db  'Press Enter to Continue$'
	welcomeMessage1     db  'Welcome To Our Game, Player 1!$'
	welcomeMessage2     db  'Welcome To Our Game, Player 2!$'
	warningMessage      db  '$$Please Enter a Valid Name!$'
	chattingInfo        db  '*To start chatting press F1$'
	gameStartInfo       db  '*To Start the Game press F2$'
	endgameInfo         db  '*To end the game press ESC$'
	notifactionBar      db  '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$'
	welcomePosition     dw  0h
	scoreMessage1       db  'Score #1: $'
	scoreMessage2       db  'Score #2: $'
	player1Score        dw  0h
	player2Score        dw  0h
	livesMessage1       db  'Lives #1: $'
	livesMessage2       db  'Lives #2: $'
	player1Lives        dw  3h
	player2Lives        dw  3h
	scanF2              equ 3Ch                                                                               	;Scan code for F2 - change to 00h if using emu8086 else keep 3Ch
	scanESC             equ 1Bh
	grid                db  480 dup(127)
	black               equ 00h
	blue                equ 01h
	green               equ 02h
	cyan                equ 03h
	red                 equ 04h
	magenta             equ 05h
	brown               equ 06h
	lightGray           equ 07h
	darkGray            equ 08h
	lightBlue           equ 09h
	lightGreen          equ 0ah
	lightCyan           equ 0bh
	lightRed            equ 0ch
	lightMagenta        equ 0dh
	yellow              equ 0eh
	white               equ 0fh
	player1InitialColor equ yellow
	player1Color        db  player1InitialColor
	player2InitialColor equ lightGreen
	player2Color        db  player2InitialColor
	borderColor         equ blue
	;backgroundColor     equ 151d
	backgroundColor     equ black
	ghostInitialColor   equ lightMagenta
	ghostColor          db  ghostInitialColor
	dotColor            equ white
	gridStartX          equ 10
	gridStartY          equ 20
	gridStep            equ 10
	gridXCount          equ 30
	gridYCount          equ 16
	;-------------------------- ITEMS CODES
	player1Code         equ 16
	player2Code         equ 17
	snowflakeCode       equ 18
	cherryCode          equ 19
	dotCode             equ 20
	bigDotCode          equ 21
	trapCode            equ 22
	extraLifeCode       equ 23
	decLifeCode         equ 1                                                                                 	;MUST BE CHANGED
	cornerLeftUpCode    equ 1
	cornerLeftDownCode  equ 2
	cornerRightUpCode   equ 3
	cornerRightDownCode equ 4
	horizontalWallCode  equ 5
	verticalWallCode    equ 6
	quadWallCode        equ 7
	triWallDownCode     equ 8
	triWallUpCode       equ 9
	triWallLeftCode     equ 10
	triWallRightCode    equ 11
	endWallDownCode     equ 12
	endWallUpCode       equ 13
	endWallLeftCode     equ 14
	endWallRightCode    equ 15
	ghostCode           equ 128
	;------------------------- END
	currentXPlayer1     dw  1
	currentYPlayer1     dw  1
	currentXPlayer2     dw  28
	currentYPlayer2     dw  14
	player1Orientation  db  'R'
	player2Orientation  db  'L'
	isOpen              db  1
	rightArrowScan      equ 4dh
	leftArrowScan       equ 4bh
	upArrowScan         equ 48h
	downArrowScan       equ 50h
	currentX            dw  gridStartX
	currentY            dw  gridStartY
	player1Moved        db  0
	player2Moved        db  0
	wScanCode           equ 11h
	aSCanCode           equ 1eh
	sSCanCode           equ 1fh
	dScanCode           equ 20h
	gridColor           db  0
	ghostsIsFrozen      db  0
	player2IsFrozen     db  0
	player1IsFrozen     db  0
	freezeDuration      equ 25
	player1FreezeDur    db  freezeDuration
	player2FreezeDur    db  freezeDuration
	ghostFreezeDur      db  freezeDuration
	ghostX              db  0
	ghostY              db  0
	searchX             db  0
	searchY             db  0
	nodeX               db  0
	nodeY               db  0
	searchCount         dw  0
	gridChecked         db  480 dup(0)
	nodesToSearch       dw  480 dup(0)
	zeros               dw  480 dup(0)
	rightValue          dw  0ffh
	leftValue           dw  0ffh
	upValue             dw  0ffh
	downValue           dw  0ffh
	maxValue            dw  0ffh
	nextMove            db  0
	isPlayer1Dead       db  0
	isPlayer2Dead       db  0
	isGameFinished      db  0

.code
MoveGhosts proc
	                       mov                     ghostX, 0
	                       mov                     ghostY, 0
	                       mov                     si, 0
	                       mov                     ch, gridYCount
	LoopRow:               
	                       mov                     ghostX, 0
	                       mov                     cl, gridXCount
	LoopCell:              
	                       push                    cx
	                       push                    si
	                       mov                     cl, grid[si]
	                       and                     cl, 128d
	                       push                    si
	                       jnz                     IsGhost
	                       jmp                     EndMoveGhost
	FindNextMove:          
	                       pop                     si
	                       and                     grid[si], 255d
	                       mov                     cx, maxValue
	                       cmp                     cx, rightValue
	                       jl                      NextMoveIsRight
	                       cmp                     cx, leftValue
	                       jl                      NextMoveIsLeft
	                       cmp                     cx, upValue
	                       jl                      NextMoveIsUp
	                       cmp                     cx, downValue
	                       jl                      NextMoveIsDown
	ContinueMoveGhost:     
	                       pop                     si
	                       pop                     cx
	                       add                     ghostX, gridStep
	                       inc                     si
	                       dec                     cl
	                       jnz                     LoopCell
	                       add                     ghostY, gridStep
	                       dec                     ch
	                       jnz                     LoopRow
	                       jmp                     EndMoveGhost
	IsGhost:               
	                       mov                     rightValue, 0ffh
	                       mov                     leftValue, 0ffh
	                       mov                     upValue, 0ffh
	                       mov                     downValue, 0ffh
	                       mov                     maxValue, 0ffh
	                       mov                     nextMove, 0
	                       mov                     bh, searchX
	                       mov                     bl, searchY
	                       mov                     searchX, bh
	                       mov                     searchY, bl
	SearchRight:           
	                       inc                     searchX
	                       cmp                     searchX, gridXCount
	                       jge                     SearchLeft
	                       GridToCell              searchX, searchY
	                       cmp                     grid[bx], 16
	                       jb                      SearchLeft
	;FindPath               searchX, searchY
	                       mov                     rightValue, ax
	SearchLeft:            
	                       dec                     searchX
	                       cmp                     searchX, 0
	                       jle                     SearchUp
	                       GridToCell              searchX, searchY
	                       cmp                     grid[bx], 16
	                       jb                      SearchUp
	;FindPath               searchX, searchY
	                       mov                     leftValue, ax
	SearchUp:              
	                       inc                     searchY
	                       cmp                     searchX, gridYCount
	                       jge                     SearchDown
	                       GridToCell              searchX, searchY
	                       cmp                     grid[bx], 16
	                       jb                      SearchDown
	;FindPath               searchX, searchY
	                       mov                     upValue, ax
	SearchDown:            
	                       dec                     searchY
	                       cmp                     searchY, gridYCount
	                       jle                     FindNextMove
	                       GridToCell              searchX, searchY
	                       cmp                     grid[bx], 16
	                       jb                      FindNextMove
	;FindPath               searchX, searchY
	                       mov                     downValue, ax
	                       jmp                     FindNextMove
	NextMoveIsRight:       
	                       inc                     ghostX
	                       GridToCell              ghostX, ghostY
	                       or                      grid[si], 128d
	                       jmp                     ContinueMoveGhost
	NextMoveIsLeft:        
	                       dec                     ghostX
	                       GridToCell              ghostX, ghostY
	                       or                      grid[si], 128d
	                       jmp                     ContinueMoveGhost
	NextMoveIsUp:          
	                       dec                     ghostY
	                       GridToCell              ghostX, ghostY
	                       or                      grid[si], 128d
	                       jmp                     ContinueMoveGhost
	NextMoveIsDown:        
	                       inc                     ghostY
	                       GridToCell              ghostX, ghostY
	                       or                      grid[si], 128d
	                       jmp                     ContinueMoveGhost
	EndMoveGhost:          
	                       ret
MoveGhosts endp

MovePacman proc
	                       mov                     player1Moved,0
	                       mov                     player2Moved,0
	MoveLoop:              
	                       mov                     ah,1
	                       int                     16h
	                       jz                      endMovePacMan
	                       mov                     ah,0
	                       int                     16h
	; Added part for Freeze effect:
	; The dec of FreezeDuration and setting it to zero when the Duration = 0 is in the IsFrozen proc.
	; If Player 1 is frozen we will jmp straight to the part of the code that reads the scancodes responsible for the movement of player2
	                       cmp                     player1IsFrozen,1
	                       je                      Player2MovmentCodes
	                       cmp                     isPlayer1Dead, 1
	                       je                      Player2MovmentCodes
	                       cmp                     ah,rightArrowScan
	                       je                      MovePlayer1Right
	                       cmp                     ah,leftArrowScan
	                       je                      MovePlayer1Left
	                       cmp                     ah,upArrowScan
	                       je                      MovePlayer1Up
	                       cmp                     ah,downArrowScan
	                       je                      MovePlayer1Down
	; If Player2 is frozen we will skip the part where it moves him and we will continue the rest of the movement procedure.
	                       cmp                     player2IsFrozen,1
	                       je                      MoveLoop
	Player2MovmentCodes:   
	                       cmp                     isPlayer2Dead,1
	                       je                      moveLoop
	                       cmp                     ah,dScanCode
	                       je                      MovePlayer2Right
	                       cmp                     ah,aSCanCode
	                       je                      MovePlayer2Left
	                       cmp                     ah,wScanCode
	                       je                      MovePlayer2Up
	                       cmp                     ah,sSCanCode
	                       je                      MovePlayer2Down
	                       jmp                     MoveLoop
	MovePlayer1Right:      
	                       cmp                     player1Moved,0
	                       jne                     MoveLoop
	                       mov                     player1Orientation, 'R'
	;check walls
	                       inc                     currentXPlayer1
	                       GridToCell              currentXPlayer1 ,currentYPlayer1
	                       dec                     currentXPlayer1
	                       cmp                     grid[bx],16
	                       jb                      MoveLoop
	;end check walls
	;check ghost
	                       inc                     currentXPlayer1
	                       GridToCell              currentXPlayer1, currentYPlayer1
	                       dec                     currentXPlayer1
	                       cmp                     grid[bx], 128
	                       jae                     DecrementPlayer1Live
	;end check ghost
	                       GridToCell              currentXPlayer1, currentYPlayer1
	                       mov                     grid[bx],127
	                       add                     currentXPlayer1,1
	                       jmp                     ChangePlayer1Pacman
	MovePlayer1Left:       
	                       cmp                     player1Moved,0
	                       jne                     MoveLoop
	                       mov                     player1Orientation, 'L'
	;check walls
	                       dec                     currentXPlayer1
	                       GridToCell              currentXPlayer1 ,currentYPlayer1
	                       inc                     currentXPlayer1
	                       cmp                     grid[bx],16
	                       jb                      MoveLoop
	;end check walls
	;check ghost
	                       dec                     currentXPlayer1
	                       GridToCell              currentXPlayer1, currentYPlayer1
	                       inc                     currentXPlayer1
	                       cmp                     grid[bx], 128
	                       jae                     DecrementPlayer1Live
	;end check ghost
	                       GridToCell              currentXPlayer1, currentYPlayer1
	                       mov                     grid[bx],127
	                       sub                     currentXPlayer1,1
	                       jmp                     ChangePlayer1Pacman
	MovePlayer1Up:         
	                       cmp                     player1Moved,0
	                       jne                     MoveLoop
	                       mov                     player1Orientation, 'U'
	;check walls
	                       dec                     currentYPlayer1
	                       GridToCell              currentXPlayer1 ,currentYPlayer1
	                       inc                     currentYPlayer1
	                       cmp                     grid[bx],16
	                       jb                      MoveLoop
	;end check walls
	;check Ghost
	                       dec                     currentYPlayer1
	                       GridToCell              currentXPlayer1 ,currentYPlayer1
	                       inc                     currentYPlayer1
	                       cmp                     grid[bx],128
	                       jae                     DecrementPlayer1Live
	;end check Ghosts
	                       GridToCell              currentXPlayer1, currentYPlayer1
	                       mov                     grid[bx],127
	                       sub                     currentYPlayer1,1
	                       jmp                     ChangePlayer1Pacman
	MovePlayer1Down:       
	                       cmp                     player1Moved,0
	                       jne                     MoveLoop
	                       mov                     player1Orientation, 'D'
	;check walls
	                       inc                     currentYPlayer1
	                       GridToCell              currentXPlayer1 ,currentYPlayer1
	                       dec                     currentYPlayer1
	                       cmp                     grid[bx],16
	                       jb                      MoveLoop
	;end check walls
	;check Ghosts
	                       inc                     currentYPlayer1
	                       GridToCell              currentXPlayer1 ,currentYPlayer1
	                       dec                     currentYPlayer1
	                       cmp                     grid[bx],128
	                       jae                     DecrementPlayer1Live
	;end check Ghosts
	                       GridToCell              currentXPlayer1, currentYPlayer1
	                       mov                     grid[bx],127
	                       add                     currentYPlayer1,1
	                       jmp                     ChangePlayer1Pacman
	ChangePlayer1Pacman:   
	                       GridToCell              currentXPlayer1, currentYPlayer1
	                       jmp                     CheckPowerUpsPlayer1
	AfterPowerUp1:         
	                       mov                     grid[bx],player1Code
	                       mov                     player1Moved,1
	                       jmp                     MoveLoop
	CheckPowerUpsPlayer1:  
	                       push                    bx
	                       cmp                     grid[bx], dotCode
	                       je                      ApplyDot1
	                       cmp                     grid[bx], snowflakeCode
	                       je                      ApplyFreeze1
	                       cmp                     grid[bx], cherryCode
	                       je                      ApplyCherry1
	                       cmp                     grid[bx], bigDotCode
	; je                     ApplyBigDot1
	                       cmp                     grid[bx], trapCode
	; je                     ApplyGreenDot1
	                       cmp                     grid[bx], extraLifeCode
	                       je                      ApplyPacmanLife1
	                       cmp                     grid[bx], decLifeCode
	                       je                      ApplyPacmanUnLife1
	ReturningToMovePlayer1:
	                       pop                     bx
	                       jmp                     AfterPowerUp1
	ApplyDot1:             
	                       add                     player1Score, 1
	                       jmp                     ReturningToMovePlayer1
	ApplyFreeze1:          
	                       mov                     player2FreezeDur, freezeDuration
	                       mov                     ghostFreezeDur, freezeDuration
	                       mov                     player2IsFrozen, 1
	                       mov                     ghostsIsFrozen, 1
	                       jmp                     ReturningToMovePlayer1
	ApplyCherry1:          
	                       add                     player1Score,10
	                       jmp                     ReturningToMovePlayer1
	;ApplyBigDot1:

	;ApplyGreenDot1:

	ApplyPacmanLife1:      
	                       add                     player1Lives, 1
	                       jmp                     ReturningToMovePlayer1
	ApplyPacmanUnLife1:    
	                       sub                     player1Lives, 1
	                       jmp                     ReturningToMovePlayer1

	DecrementPlayer1Live:  
	                       GridToCell              currentXPlayer1,currentYPlayer1
	                       mov                     grid[bx],127
	                       dec                     player1Lives
	                       cmp                     player1Lives, 0
	                       je                      SetDead1
	                       mov                     currentXPlayer1,1
	                       mov                     currentYPlayer1,1                                                            	;we can add a delay later maybe integrate the freeze functionality
	                       jmp                     MoveLoop
	SetDead1:              
	                       mov                     isPlayer1Dead, 1
	                       jmp                     moveLoop
	;--------------------------------------------------------------------------------------

	MovePlayer2Right:      
	                       cmp                     player2Moved,0
	                       jne                     MoveLoop
	                       mov                     player2Orientation, 'R'
	;check walls
	                       inc                     currentXPlayer2
	                       GridToCell              currentXPlayer2 ,currentYPlayer2
	                       dec                     currentXPlayer2
	                       cmp                     grid[bx],16
	                       jb                      MoveLoop
	;end check walls
	;check Ghosts
	                       inc                     currentXPlayer2
	                       GridToCell              currentXPlayer2 ,currentYPlayer2
	                       dec                     currentXPlayer2
	                       cmp                     grid[bx],128
	                       jae                     DecrementPlayer2Live
	;end check ghosts
	                       GridToCell              currentXPlayer2, currentYPlayer2
	                       mov                     grid[bx],127
	                       add                     currentXPlayer2,1
	                       jmp                     ChangePlayer2Pacman
	MovePlayer2Left:       
	                       cmp                     player2Moved,0
	                       jne                     MoveLoop
	                       mov                     player2Orientation, 'L'
	;check walls
	                       dec                     currentXPlayer2
	                       GridToCell              currentXPlayer2 ,currentYPlayer2
	                       inc                     currentXPlayer2
	                       cmp                     grid[bx],16
	                       jb                      MoveLoop
	;end check walls
	;check ghost
	                       dec                     currentXPlayer2
	                       GridToCell              currentXPlayer2 ,currentYPlayer2
	                       inc                     currentXPlayer2
	                       cmp                     grid[bx],128
	                       jae                     DecrementPlayer2Live
	;end check ghosts
	                       GridToCell              currentXPlayer2, currentYPlayer2
	                       mov                     grid[bx],127
	                       sub                     currentXPlayer2,1
	                       jmp                     ChangePlayer2Pacman
	MovePlayer2Up:         
	                       cmp                     player2Moved,0
	                       jne                     MoveLoop
	                       mov                     player2Orientation, 'U'
	;check walls
	                       dec                     currentXPlayer2
	                       GridToCell              currentXPlayer2 ,currentYPlayer2
	                       inc                     currentXPlayer2
	                       cmp                     grid[bx],16
	                       jb                      MoveLoop
	;end check walls
	;check ghost
	                       dec                     currentXPlayer2
	                       GridToCell              currentXPlayer2 ,currentYPlayer2
	                       inc                     currentXPlayer2
	                       cmp                     grid[bx],128
	                       jae                     DecrementPlayer2Live
	;end check ghost
	                       GridToCell              currentXPlayer2, currentYPlayer2
	                       mov                     grid[bx],127
	                       sub                     currentYPlayer2,1
	                       jmp                     ChangePlayer2Pacman
	MovePlayer2Down:       
	                       cmp                     player2Moved,0
	                       jne                     MoveLoop
	                       mov                     player2Orientation, 'D'
	;check walls
	                       inc                     currentYPlayer2
	                       GridToCell              currentXPlayer2 ,currentYPlayer2
	                       dec                     currentYPlayer2
	                       cmp                     grid[bx],16
	                       jb                      MoveLoop
	;end check walls
	;check Ghosts
	                       inc                     currentYPlayer2
	                       GridToCell              currentXPlayer2 ,currentYPlayer2
	                       dec                     currentYPlayer2
	                       cmp                     grid[bx],128
	                       jae                     DecrementPlayer2Live
	;end check Ghosts
	                       GridToCell              currentXPlayer2, currentYPlayer2
	                       mov                     grid[bx], 127
	                       add                     currentYPlayer2, 1
	                       jmp                     ChangePlayer2Pacman
	ChangePlayer2Pacman:   
	                       GridToCell              currentXPlayer2, currentYPlayer2
	                       jmp                     CheckPowerUpsPlayer2
	AfterPowerUp2:         
	                       mov                     grid[bx], player2Code
	                       mov                     player2Moved, 1
	                       jmp                     MoveLoop

	;--------------------------------------------------------------------------------------

	CheckPowerUpsPlayer2:  
	                       push                    bx
	                       cmp                     grid[bx], dotCode
	                       je                      ApplyDot2
	                       cmp                     grid[bx], snowflakeCode
	                       je                      ApplyFreeze2
	                       cmp                     grid[bx], cherryCode
	                       je                      ApplyCherry2
	                       cmp                     grid[bx], bigDotCode
	; je                     ApplyBigDot2
	                       cmp                     grid[bx], trapCode
	; je                     ApplyGreenDot2
	                       cmp                     grid[bx], extraLifeCode
	                       je                      ApplyPacmanLife2
	                       cmp                     grid[bx], decLifeCode
	                       je                      ApplyPacmanUnLife2
	ReturningToMovePlayer2:
	                       pop                     bx
	                       jmp                     AfterPowerUp2
	ApplyDot2:             
	                       add                     player2Score, 1
	                       jmp                     ReturningToMovePlayer2
	ApplyFreeze2:          
	                       mov                     player1FreezeDur, freezeDuration
	                       mov                     ghostFreezeDur, freezeDuration
	                       mov                     player1IsFrozen, 1
	                       mov                     ghostsIsFrozen, 1
	                       jmp                     ReturningToMovePlayer2
	ApplyCherry2:          
	                       add                     player2Score,10
	                       jmp                     ReturningToMovePlayer2
	;ApplyBigDot2:

	;ApplyGreenDot2:

	ApplyPacmanLife2:      
	                       add                     player2Lives, 1
	                       jmp                     ReturningToMovePlayer2
	ApplyPacmanUnLife2:    
	                       sub                     player2Lives, 1
	                       jmp                     ReturningToMovePlayer2
	DecrementPlayer2Live:  
	                       GridToCell              currentXPlayer2,currentYPlayer2
	                       mov                     grid[bx],127
	                       dec                     player2Lives
	                       cmp                     player2Lives, 0
	                       je                      SetDead
	                       mov                     currentXPlayer2, 28
	                       mov                     currentYPlayer2, 14                                                          	;we can add a delay later maybe integrate the freeze functionality
	                       jmp                     MoveLoop
	SetDead:               mov                     isPlayer2Dead,1
	                       jmp                     MoveLoop
	terminate:             
MovePacman endp

IsFrozen proc
	CheckPlayer1Freeze:    
	                       cmp                     player1IsFrozen,1
	                       je                      DecPlayer1FreezeEffect
	CheckPlayer2Freeze:    
	                       cmp                     player2IsFrozen, 1
	                       je                      DecPlayer2FreezeEffect
	CheckGhostFreeze:      
	                       cmp                     ghostsIsFrozen,1
	                       je                      DecGhoshtFreezeEffect
	ReturnFreeze:          
	                       ret
	DecPlayer1FreezeEffect:
	                       sub                     player1FreezeDur,1
	                       jz                      SetFreeze1
	                       jmp                     CheckPlayer2Freeze
	SetFreeze1:            
	                       mov                     player1IsFrozen,0
	                       jmp                     CheckPlayer2Freeze
	DecPlayer2FreezeEffect:
	                       sub                     player2FreezeDur,1
	                       jz                      SetFreeze2
	                       jmp                     CheckGhostFreeze
	SetFreeze2:            
	                       mov                     player2IsFrozen,0
	                       jmp                     CheckGhostFreeze
	DecGhoshtFreezeEffect: 
	                       sub                     ghostFreezeDur,1
	                       jz                      SetFreezeGhost
	                       jmp                     ReturnFreeze
	SetFreezeGhost:        
	                       mov                     ghostsIsFrozen,0
	                       jmp                     ReturnFreeze
	EndMovePacMan:         
	                       ret
IsFrozen endp

DrawGrid proc
	                       mov                     currentX, gridStartX
	                       mov                     currentY, gridStartY
	                       mov                     gridColor, 0
	                       mov                     si, 0
	                       mov                     ch, gridYCount
	DrawRow:               
	                       mov                     currentX, gridStartX
	                       mov                     cl, gridXCount
	DrawCell:              
	                       push                    cx
	                       push                    si
	; DrawSquare             currentX, currentY, gridStep, gridColor, gridColor ; rainbow
	; inc                    gridColor
	; jmp                    ContinueDraw
	                       mov                     cl, grid[si]
	                       and                     cl, 128d
	                       jnz                     Ghost
	                       cmp                     grid[si], 127
	                       je                      Square
	                       cmp                     grid[si], player1Code
	                       je                      Player1
	                       cmp                     grid[si], player2Code
	                       je                      Player2
	                       cmp                     grid[si], snowflakeCode
	                       je                      Snowflake
	                       cmp                     grid[si], cherryCode
	                       je                      Cherry
	                       cmp                     grid[si], dotCode
	                       je                      Dot
	                       cmp                     grid[si], bigDotCode
	                       je                      BigDot
	                       cmp                     grid[si], trapCode
	                       je                      Trap
	                       cmp                     grid[si], cornerLeftDownCode
	                       je                      CornerLeftDown
	                       cmp                     grid[si], cornerLeftUpCode
	                       je                      CornerLeftUp
	                       cmp                     grid[si], cornerRightDownCode
	                       je                      CornerRightDown
	                       cmp                     grid[si], cornerRightUpCode
	                       je                      CornerRightUp
	                       cmp                     grid[si], quadWallCode
	                       je                      QuadWall
	                       cmp                     grid[si], triWallLeftCode
	                       je                      TriWallLeft
	                       cmp                     grid[si], triWallRightCode
	                       je                      TriWallRight
	                       cmp                     grid[si], triWallUpCode
	                       je                      TriWallUp
	                       cmp                     grid[si], triWallDownCode
	                       je                      TriWallDown
	                       cmp                     grid[si], horizontalWallCode
	                       je                      HorizontalWall
	                       cmp                     grid[si], verticalWallCode
	                       je                      VerticalWall
	                       cmp                     grid[si], endWallLeftCode
	                       je                      EndWallLeft
	                       cmp                     grid[si], endWallRightCode
	                       je                      EndWallRight
	                       cmp                     grid[si], endWallUpCode
	                       je                      EndWallUp
	                       cmp                     grid[si], endWallDownCode
	                       je                      EndWallDown
	ContinueDraw:          
	                       pop                     si
	                       pop                     cx
	                       add                     currentX, gridStep
	                       inc                     si
	                       dec                     cl
	                       jnz                     DrawCell
	                       add                     currentY, gridStep
	                       dec                     ch
	                       jnz                     DrawRow
	                       jmp                     EndDraw
	Square:                
	                       DrawSquare              currentX, currentY, gridStep, black , backgroundColor                        	;borderColor, backgroundColor
	                       jmp                     ContinueDraw
	Player1:               
	                       cmp                     player1IsFrozen, 1
	                       je                      Player1Frozen
	                       mov                     player1Color,player1InitialColor
	DrawPlayer1:           
	                       DrawPlayer              currentX, currentY, player1Color, backgroundColor, isOpen, player1Orientation
	                       jmp                     ContinueDraw
	Player1Frozen:         
	                       mov                     player1Color, lightBlue
	                       jmp                     DrawPlayer1
	Player2:               
	                       cmp                     player2IsFrozen, 1
	                       je                      Player2Frozen
	                       mov                     player2Color, player2InitialColor
	DrawPlayer2:           
	                       DrawPlayer              currentX, currentY, player2Color, backgroundColor, isOpen, player2Orientation
	                       jmp                     ContinueDraw
	Player2Frozen:         
	                       mov                     player2Color,lightBlue
	                       jmp                     DrawPlayer2
	Ghost:                 
	                       cmp                     ghostsIsFrozen, 1
	                       je                      GhostFrozen
	                       mov                     ghostColor,ghostInitialColor
	DrawGhostt:            
	                       DrawGhost               currentX, currentY, ghostColor, backgroundColor
	                       jmp                     ContinueDraw
	GhostFrozen:           
	                       mov                     ghostColor, lightblue
	                       jmp                     DrawGhostt
	Snowflake:             
	                       DrawSnowflake           currentX, currentY, lightCyan, backgroundColor
	                       jmp                     ContinueDraw
	Cherry:                
	                       DrawCherry              currentX, currentY, red, green, backgroundColor
	                       jmp                     ContinueDraw
	Dot:                   
	                       DrawDot                 currentX, currentY, white, backgroundColor
	                       jmp                     ContinueDraw
	BigDot:                
	                       DrawBigDot              currentX, currentY, white, backgroundColor
	                       jmp                     ContinueDraw
	Trap:                  
	                       DrawTrap                currentX, currentY, backGroundColor, lightGreen, green
	                       jmp                     ContinueDraw
	CornerLeftUp:          
	                       DrawCornerWallLeftUp    currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	CornerLeftDown:        
	                       DrawCornerWallLeftDown  currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	CornerRightUp:         
	                       DrawCornerWallRightUp   currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	CornerRightDown:       
	                       DrawCornerWallRightDown currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	QuadWall:              
	                       DrawQuadWall            currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	TriWallLeft:           
	                       DrawTriWallLeft         currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	TriWallRight:          
	                       DrawTriWallRight        currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	TriWallUp:             
	                       DrawTriWallUp           currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	TriWallDown:           
	                       DrawTriWallDown         currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	HorizontalWall:        
	                       DrawWallHorizontal      currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	VerticalWall:          
	                       DrawWallVertical        currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	EndWallLeft:           
	                       DrawEndWallLeft         currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	EndWallRight:          
	                       DrawEndWallRight        currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	EndWallUp:             
	                       DrawEndWallUp           currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	EndWallDown:           
	                       DrawEndWallDown         currentX, currentY, black, white, backgroundColor
	                       jmp                     ContinueDraw
	EndDraw:               
	                       ret
DrawGrid endp

DrawScoreAndLives proc
	DrawScores:            
	                       mov                     si,@data
	                       DisplayNumberVideoMode  15, 1, player1Score
	                       DisplayNumberVideoMode  37, 1, player2Score
	                       DisplayNumberVideoMode  12, 23, player1Lives
	                       DisplayNumberVideoMode  34, 23, player2Lives
	                       ret
DrawScoreAndLives endp

main proc far

	                       mov                     ax, @data
	                       mov                     ds, ax
	                       jmp                     StartGame
	GetPlayer1Name:                                                                                                             	;Reading first player name and saving it to player1name
	                       SetTextMode
	                       mov                     dx, 0000
	                       MoveCursor
	                       Displaystring           welcomeMessage1
	                       mov                     dx, 0d0dh
	                       mov                     dl, 25d
	                       MoveCursor
	                       Displaystring           enterMessage
	                       mov                     dx, 0f0dh
	                       mov                     dl, 23d
	                       MoveCursor
	                       Displaystring           warningMessage
	                       mov                     dx, 0a0dh
	                       mov                     dl, 25d
	                       MoveCursor
	                       ReadString              nameMessage, player1Name
	                       ValidateName            player1Name
	                       cmp                     bl, 0
	                       je                      showWarning1
	                       mov                     word ptr warningMessage, byte ptr '$$'
	                       jmp                     GetPlayer2Name
	ShowWarning1:          
	                       mov                     word ptr warningMessage, word ptr 0
	                       jmp                     GetPlayer1Name
	GetPlayer2Name:                                                                                                             	;Reading second player name and saving it to player2name
	                       SetTextMode
	                       mov                     dx, 0000
	                       MoveCursor
	                       Displaystring           welcomeMessage2
	                       mov                     dx, 0d0dh
	                       mov                     dl, 25d
	                       MoveCursor
	                       displaystring           enterMessage
	                       mov                     dx, 0f0dh
	                       mov                     dl, 23d
	                       MoveCursor
	                       displaystring           warningMessage
	                       mov                     dx, 0A0dh
	                       mov                     dl, 25d
	                       MoveCursor
	                       ReadString              nameMessage, player2Name
	                       ValidateName            player2name
	                       cmp                     bl, 0
	                       je                      ShowWarning2
	                       jmp                     MainMenu
	ShowWarning2:          
	                       mov                     word ptr warningMessage, word ptr 0
	                       jmp                     GetPlayer2Name

	MainMenu:                                                                                                                   	;displaying main menu and provided functions and how to use them
	                       SetTextMode
	                       mov                     dx, 080dh
	                       mov                     dl, 25d
	                       MoveCursor
	                       DisplayString           chattingInfo
	                       mov                     dx, 0a0dh
	                       mov                     dl, 25d
	                       MoveCursor
	                       DisplayString           gameStartInfo
	                       mov                     dx, 0c0dh
	                       mov                     dl, 25d
	                       MoveCursor
	                       DisplayString           endgameInfo
	                       mov                     dl, 0
	                       mov                     dh, 22d
	                       MoveCursor
	                       Displaystring           notifactionBar
	AgainTillKeyPressed:                                                                                                        	;checking if a key is pressed on the main menu
	                       mov                     ah, 08h                                                                      	;these two line are used to flush the keyboard buffer
	                       int                     21h
	                       mov                     ah, 1
	                       int                     16h
	                       cmp                     al, scanESC                                                                  	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                       je                      Terminate1
	                       cmp                     al, scanF2                                                                   	;comparing ah with the f2 scan code if equal go to game loading menu
	                       je                      LoadingMenu
	                       jmp                     AgainTillKeyPressed

	Terminate1:            jmp                     Terminate2
	LoadingMenu:           
	                       SetVideoMode

	                       DrawLoadingScreen       black,yellow,cyan                                                            	;The next code snippet is ofr the delay
	                       MOV                     CX, 3fH
	                       MOV                     DX, 4240H
	                       MOV                     AH, 86H
	                       INT                     15H
	StartGame:             
	                       SetVideoMode
	Level1:                
	                       mov                     grid[31], player1Code
	                       mov                     grid[448], player2Code
	                       mov                     grid[0], cornerLeftUpCode
	                       mov                     grid[479], cornerRightDownCode
	                       mov                     grid[29], cornerRightUpCode
	                       mov                     grid[450], cornerLeftDownCode
	                       mov                     grid[1], horizontalWallCode
	                       mov                     grid[2], horizontalWallCode
	                       mov                     grid[3], horizontalWallCode
	                       mov                     grid[4], horizontalWallCode
	                       mov                     grid[5], horizontalWallCode
	                       mov                     grid[6], horizontalWallCode
	                       mov                     grid[7], horizontalWallCode
	                       mov                     grid[8], horizontalWallCode
	                       mov                     grid[9], horizontalWallCode
	                       mov                     grid[10], horizontalWallCode
	                       mov                     grid[11], horizontalWallCode
	                       mov                     grid[12], horizontalWallCode
	                       mov                     grid[13], triWallUpCode
	                       mov                     grid[14], horizontalWallCode
	                       mov                     grid[15], triWallUpCode
	                       mov                     grid[16], horizontalWallCode
	                       mov                     grid[17], horizontalWallCode
	                       mov                     grid[18], horizontalWallCode
	                       mov                     grid[19], horizontalWallCode
	                       mov                     grid[20], horizontalWallCode
	                       mov                     grid[21], horizontalWallCode
	                       mov                     grid[22], horizontalWallCode
	                       mov                     grid[23], horizontalWallCode
	                       mov                     grid[24], horizontalWallCode
	                       mov                     grid[25], horizontalWallCode
	                       mov                     grid[26], horizontalWallCode
	                       mov                     grid[27], horizontalWallCode
	                       mov                     grid[28], horizontalWallCode
	                       mov                     grid[43], endWallDownCode
	                       mov                     grid[44], bigDotCode
	                       mov                     grid[32], dotCode
	                       mov                     grid[45], endWallDownCode
	                       mov                     grid[30], verticalWallCode
	                       mov                     grid[60], verticalWallCode
	                       mov                     grid[90], verticalWallCode
	                       mov                     grid[120], verticalWallCode
	                       mov                     grid[150], verticalWallCode
	                       mov                     grid[180], cornerLeftDownCode
	                       mov                     grid[181], cornerRightUpCode
	                       mov                     grid[211], verticalWallCode
	                       mov                     grid[241], verticalWallCode
	                       mov                     grid[271], cornerRightDownCode
	                       mov                     grid[270], cornerLeftUpCode
	                       mov                     grid[300], verticalWallCode
	                       mov                     grid[330], verticalWallCode
	                       mov                     grid[360], verticalWallCode
	                       mov                     grid[390], verticalWallCode
	                       mov                     grid[420], verticalWallCode
	                       mov                     grid[193], horizontalWallCode
	                       mov                     grid[194], horizontalWallCode
	                       mov                     grid[195], horizontalWallCode
	                       mov                     grid[283], horizontalWallCode
	                       mov                     grid[284], horizontalWallCode
	                       mov                     grid[285], horizontalWallCode
	                       mov                     grid[192], cornerLeftUpCode
	                       mov                     grid[196], cornerRightUpCode
	                       mov                     grid[282], cornerLeftDownCode
	                       mov                     grid[286], cornerRightDownCode
	                       mov                     grid[223], ghostCode
	                       mov                     grid[225], ghostCode
	                       mov                     grid[253], ghostCode
	                       mov                     grid[255], ghostCode
	                       mov                     grid[224], dotCode
	                       mov                     grid[254], dotCode
	                       mov                     grid[451], horizontalWallCode
	                       mov                     grid[452], horizontalWallCode
	                       mov                     grid[453], horizontalWallCode
	                       mov                     grid[454], horizontalWallCode
	                       mov                     grid[455], horizontalWallCode
	                       mov                     grid[456], horizontalWallCode
	                       mov                     grid[457], horizontalWallCode
	                       mov                     grid[458], horizontalWallCode
	                       mov                     grid[459], horizontalWallCode
	                       mov                     grid[460], horizontalWallCode
	                       mov                     grid[461], horizontalWallCode
	                       mov                     grid[462], horizontalWallCode
	                       mov                     grid[463], triWallDownCode
	                       mov                     grid[464], horizontalWallCode
	                       mov                     grid[465], triWallDownCode
	                       mov                     grid[466], horizontalWallCode
	                       mov                     grid[467], horizontalWallCode
	                       mov                     grid[468], horizontalWallCode
	                       mov                     grid[469], horizontalWallCode
	                       mov                     grid[470], horizontalWallCode
	                       mov                     grid[471], horizontalWallCode
	                       mov                     grid[472], horizontalWallCode
	                       mov                     grid[473], horizontalWallCode
	                       mov                     grid[474], horizontalWallCode
	                       mov                     grid[475], horizontalWallCode
	                       mov                     grid[476], horizontalWallCode
	                       mov                     grid[477], horizontalWallCode
	                       mov                     grid[478], horizontalWallCode
	                       mov                     grid[433], endWallUpCode
	                       mov                     grid[434], bigDotCode
	                       mov                     grid[447], dotCode
	                       mov                     grid[435], endWallUpCode
	                       mov                     grid[59], verticalWallCode
	                       mov                     grid[89], verticalWallCode
	                       mov                     grid[119], verticalWallCode
	                       mov                     grid[149], verticalWallCode
	                       mov                     grid[179], verticalWallCode
	                       mov                     grid[209], cornerRightDownCode
	                       mov                     grid[208], cornerLeftUpCode
	                       mov                     grid[238], verticalWallCode
	                       mov                     grid[268], verticalWallCode
	                       mov                     grid[298], cornerLeftDownCode
	                       mov                     grid[299], cornerRightUpCode
	                       mov                     grid[329], verticalWallCode
	                       mov                     grid[359], verticalWallCode
	                       mov                     grid[389], verticalWallCode
	                       mov                     grid[419], verticalWallCode
	                       mov                     grid[449], verticalWallCode
	; Testing item drawing functions.
	                       mov                     grid[142], trapCode
	                       mov                     grid[87], cherryCode
	                       mov                     grid[288], snowflakeCode
	                       mov                     grid[266], snowflakeCode
	                       mov                     grid[400], cherryCode
						   

	                       mov                     si, @data
	                       DisplayTextVideoMode    10, 2, 1, scoreMessage1, 14                                                  	;Draw "Score#1"
	                       DisplayTextVideoMode    10, 24, 1, scoreMessage2, 14                                                 	;Draw "Score#2"
	                       DisplayTextVideoMode    10, 2, 23, livesMessage1, 14                                                 	;Draw "Lives#1"
	                       DisplayTextVideoMode    10, 24, 23, livesMessage2, 14                                                	;Draw "Lives#2"
	gameLoop:              
	                       call                    MovePacman
	                       call                    DrawGrid
	                       call                    DrawScoreAndLives
	                       call                    IsFrozen
	                       MOV                     CX, 1H                                                                       	; delay
	                       MOV                     DX, 4240H
	                       MOV                     AH, 86H
	                       INT                     15H
	                       xor                     isOpen, 1
	                       jmp                     gameLoop
	EndLoop:               
	                       jmp                     EndLoop
	Terminate2:            
	                       mov                     ah, 4ch
	                       int                     21h
main endp
end main