;Authors : Ahmad Mostafa El Sayed
;          Muhab Hossam El Din
;          Mazen Amr
;          Youssef Shams

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

RemoveValueBuffer macro
local noValue
        MOV AX,100H
        INT 16h
        CMP AX,100H
        JZ novalue
        MOV AH,0
        INT 16H
noValue:
        nop      
endm RemoveValueBuffer

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
    DrawHorizontalLine backgroundColor, 3
	DrawHorizontalLine borderColor, 7
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine borderColor, 2
	DrawHorizontalLine fillColor, 6
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
	DrawHorizontalLine borderColor, 4
	DrawHorizontalLine fillColor, 2
    inc dx
    mov cx, xPosition   
    DrawHorizontalLine backgroundColor, 2
	DrawHorizontalLine borderColor, 2
	DrawHorizontalLine fillColor, 6
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 3
	DrawHorizontalLine borderColor, 7
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
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 2
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
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine borderColor, 2
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
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 4
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 2
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
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine borderColor, 2
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
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 3
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
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine backgroundColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 1
    DrawHorizontalLine borderColor, 2
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
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 1
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 2
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
    DrawHorizontalLine fillColor, 3
    DrawHorizontalLine borderColor, 2
    inc dx
    mov cx, xPosition
    DrawHorizontalLine backgroundColor, 2
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 1
    DrawHorizontalLine borderColor, 1
    DrawHorizontalLine fillColor, 2
    DrawHorizontalLine borderColor, 2
    DrawHorizontalLine backgroundColor, 1
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
; Life & UnLife
;----------------------------------------------------------------------------------------
DrawPacManLife macro xPosition, yPosition, borderColor, fillColor, backGroundColor
mov cx,xPosition
mov dx,yPosition
DrawHorizontalLine backGroundColor, 10
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 10
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 3
DrawHorizontalLine borderColor, 4
DrawHorizontalLine backGroundColor, 3
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 2
DrawHorizontalLine borderColor, 2
DrawHorizontalLine fillColor, 2
DrawHorizontalLine borderColor, 2
DrawHorizontalLine backGroundColor, 2
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 2
DrawHorizontalLine borderColor, 1
DrawHorizontalLine fillColor, 4
DrawHorizontalLine borderColor, 1
DrawHorizontalLine backGroundColor, 2
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 2
DrawHorizontalLine borderColor, 1
DrawHorizontalLine fillColor, 4
DrawHorizontalLine borderColor, 1
DrawHorizontalLine backGroundColor, 2
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 2
DrawHorizontalLine borderColor, 2
DrawHorizontalLine fillColor, 2
DrawHorizontalLine borderColor, 2
DrawHorizontalLine backGroundColor, 2
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 3
DrawHorizontalLine borderColor, 4
DrawHorizontalLine backGroundColor, 3
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 10
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 10
endm DrawPacManLife

DrawPacManUnlife macro xPosition, yPosition, borderColor, fillColor, backGroundColor
mov cx,xPosition
mov dx,yPosition
DrawHorizontalLine backGroundColor, 10
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 10
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 10
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 2
DrawHorizontalLine borderColor, 6
DrawHorizontalLine backGroundColor, 2
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 2
DrawHorizontalLine borderColor, 1
DrawHorizontalLine fillColor, 4
DrawHorizontalLine borderColor, 1
DrawHorizontalLine backGroundColor, 2
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 2
DrawHorizontalLine borderColor, 1
DrawHorizontalLine fillColor, 4
DrawHorizontalLine borderColor, 1
DrawHorizontalLine backGroundColor, 2
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 2
DrawHorizontalLine borderColor, 6
DrawHorizontalLine backGroundColor, 2
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 10
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 10
mov cx,xPosition
inc dx
DrawHorizontalLine backGroundColor, 10
endm DrawPacManUnlife

;----------------------------------------------------------------------------------------
; Level 1
;----------------------------------------------------------------------------------------
DrawLevel1 macro initial1, initial2
							 mov 					 bx, initial1
 							 mov                     grid[bx], player1Code
							 mov 					 bx, initial2
	                         mov                     grid[bx], player2Code
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
	                         mov                     grid[15], horizontalWallCode
	                         mov                     grid[16], triWallUpCode
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
	                         mov                     grid[33], dotCode
	                         mov                     grid[34], dotCode
	                         mov                     grid[46], endWallDownCode
	                         mov                     grid[30], verticalWallCode
	                         mov                     grid[60], verticalWallCode
	                         mov                     grid[90], verticalWallCode
	                         mov                     grid[120], verticalWallCode
	                         mov                     grid[150], verticalWallCode
	                         mov                     grid[180], cornerLeftDownCode
							 mov                     grid[210], vacantCode
							 mov                     grid[240], vacantCode
							 mov grid[239], vacantCode
							 mov grid[269], vacantCode
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
	                         mov                     grid[165], horizontalWallCode
	                         mov                     grid[314], horizontalWallCode
	                         mov                     grid[164], cornerLeftUpCode
	                         mov                     grid[166], cornerRightUpCode
	                         mov                     grid[313], cornerLeftDownCode
	                         mov                     grid[315], cornerRightDownCode
	                         mov                     grid[194], endWallDownCode
	                         mov                     grid[196], endWallDownCode
	                         mov                     grid[283], endWallUpCode
	                         mov                     grid[285], endWallUpCode
							 mov					 grid[282], bigDotCode                   ;for testing empowered pacman
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
	                         mov                     grid[465], horizontalWallCode
	                         mov                     grid[466], triWallDownCode
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
	                         mov                     grid[436], endWallUpCode
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
	                         mov                     grid[62], cornerLeftUpCode
	                         mov                     grid[63], horizontalWallCode
	                         mov                     grid[64], cornerRightUpCode
	                         mov                     grid[92], verticalWallCode
	                         mov                     grid[93], vacantCode
	                         mov                     grid[94], verticalWallCode
	                         mov                     grid[122], cornerLeftDownCode
	                         mov                     grid[123], horizontalWallCode
	                         mov                     grid[124], cornerRightDownCode
	                         mov                     grid[66], cornerLeftUpCode
	                         mov                     grid[67], horizontalWallCode
	                         mov                     grid[68], horizontalWallCode
	                         mov                     grid[69], cornerRightUpCode
	                         mov                     grid[96], verticalWallCode
	                         mov                     grid[97], vacantCode
	                         mov                     grid[98], vacantCode
	                         mov                     grid[99], verticalWallCode
	                         mov                     grid[126], cornerLeftDownCode
	                         mov                     grid[127], horizontalWallCode
	                         mov                     grid[128], horizontalWallCode
	                         mov                     grid[129], cornerRightDownCode
	                         mov                     grid[71], endWallUpCode
	                         mov                     grid[101], triWallLeftCode
	                         mov                     grid[131], endWallDownCode
	                         mov                     grid[102], horizontalWallCode
	                         mov                     grid[103], horizontalWallCode
	                         mov                     grid[104], horizontalWallCode
	                         mov                     grid[105], horizontalWallCode
	                         mov                     grid[106], horizontalWallCode
	                         mov                     grid[107], horizontalWallCode
	                         mov                     grid[108], triWallRightCode
	                         mov                     grid[78], endWallUpCode
	                         mov                     grid[138], endWallDownCode
	                         mov                     grid[80], cornerLeftUpCode
	                         mov                     grid[81], horizontalWallCode
	                         mov                     grid[82], horizontalWallCode
	                         mov                     grid[83], cornerRightUpCode
	                         mov                     grid[110], verticalWallCode
	                         mov                     grid[111], vacantCode
	                         mov                     grid[112], vacantCode
	                         mov                     grid[113], verticalWallCode
	                         mov                     grid[140], cornerLeftDownCode
	                         mov                     grid[141], horizontalWallCode
	                         mov                     grid[142], horizontalWallCode
	                         mov                     grid[143], cornerRightDownCode
	                         mov                     grid[85], cornerLeftUpCode
	                         mov                     grid[86], horizontalWallCode
	                         mov                     grid[87], cornerRightUpCode
	                         mov                     grid[115], verticalWallCode
	                         mov                     grid[116], vacantCode
	                         mov                     grid[117], verticalWallCode
	                         mov                     grid[145], cornerLeftDownCode
	                         mov                     grid[146], horizontalWallCode
	                         mov                     grid[147], cornerRightDownCode
	                         mov                     grid[332], cornerLeftUpCode
	                         mov                     grid[333], horizontalWallCode
	                         mov                     grid[334], cornerRightUpCode
	                         mov                     grid[362], verticalWallCode
	                         mov                     grid[363], vacantCode
	                         mov                     grid[364], verticalWallCode
	                         mov                     grid[392], cornerLeftDownCode
	                         mov                     grid[393], horizontalWallCode
	                         mov                     grid[394], cornerRightDownCode
	                         mov                     grid[336], cornerLeftUpCode
	                         mov                     grid[337], horizontalWallCode
	                         mov                     grid[338], horizontalWallCode
	                         mov                     grid[339], cornerRightUpCode
	                         mov                     grid[366], verticalWallCode
	                         mov                     grid[367], vacantCode
	                         mov                     grid[368], vacantCode
	                         mov                     grid[369], verticalWallCode
	                         mov                     grid[396], cornerLeftDownCode
	                         mov                     grid[397], horizontalWallCode
	                         mov                     grid[398], horizontalWallCode
	                         mov                     grid[399], cornerRightDownCode
	                         mov                     grid[341], endWallUpCode
	                         mov                     grid[371], triWallLeftCode
	                         mov                     grid[401], endWallDownCode
	                         mov                     grid[372], horizontalWallCode
	                         mov                     grid[373], horizontalWallCode
	                         mov                     grid[374], horizontalWallCode
	                         mov                     grid[375], horizontalWallCode
	                         mov                     grid[376], horizontalWallCode
	                         mov                     grid[377], horizontalWallCode
	                         mov                     grid[378], triWallRightCode
	                         mov                     grid[348], endWallUpCode
	                         mov                     grid[408], endWallDownCode
	                         mov                     grid[350], cornerLeftUpCode
	                         mov                     grid[351], horizontalWallCode
	                         mov                     grid[352], horizontalWallCode
	                         mov                     grid[353], cornerRightUpCode
	                         mov                     grid[380], verticalWallCode
	                         mov                     grid[381], vacantCode
	                         mov                     grid[382], vacantCode
	                         mov                     grid[383], verticalWallCode
	                         mov                     grid[410], cornerLeftDownCode
	                         mov                     grid[411], horizontalWallCode
	                         mov                     grid[412], horizontalWallCode
	                         mov                     grid[413], cornerRightDownCode
	                         mov                     grid[355], cornerLeftUpCode
	                         mov                     grid[356], horizontalWallCode
	                         mov                     grid[357], cornerRightUpCode
	                         mov                     grid[385], verticalWallCode
	                         mov                     grid[386], vacantCode
	                         mov                     grid[387], verticalWallCode
	                         mov                     grid[415], cornerLeftDownCode
	                         mov                     grid[416], horizontalWallCode
	                         mov                     grid[417], cornerRightDownCode
							 mov                     grid[183], cornerLeftUpCode
							 mov                     grid[184], endWallRightCode
							 mov                     grid[213], verticalWallCode
							 mov                     grid[243], verticalWallCode
							 mov                     grid[273], cornerLeftDownCode
							 mov 					 grid[274], endWallRightCode
							 mov 					 grid[216], cornerLeftUpCode
							 mov 					 grid[246], cornerLeftDownCode
							 mov 					 grid[217], cornerRightDownCode
							 mov 					 grid[247], cornerRightUpCode
							 mov 					 grid[187], cornerLeftUpCode
							 mov 		  			 grid[277], cornerLeftDownCode
							 mov 		 			 grid[188], cornerRightUpCode
							 mov 		 			 grid[278], cornerRightDownCode
							 mov 		 			 grid[218], cornerLeftDownCode
							 mov 		 			 grid[248], cornerLeftUpCode
							 mov 					 grid[219], cornerRightUpCode
							 mov                     grid[249], cornerRightDownCode
							 mov                     grid[281], endWallDownCode
							 mov                     grid[251], verticalWallCode
							 mov                     grid[221], cornerLeftUpCode
							 mov                     grid[222], cornerRightDownCode
							 mov                     grid[192], endWallUpCode
							 mov                     grid[198], endWallUpCode
							 mov                     grid[228], verticalWallCode
							 mov                     grid[258], cornerRightDownCode
							 mov                     grid[257], cornerLeftUpCode
							 mov                     grid[287], endWallDownCode
							 mov                     grid[230], cornerLeftUpCode
							 mov                     grid[260], cornerLeftDownCode
							 mov                     grid[231], cornerRightDownCode
							 mov                     grid[261], cornerRightUpCode
							 mov                     grid[201], cornerLeftUpCode
							 mov                     grid[291], cornerLeftDownCode
							 mov                     grid[202], cornerRightUpCode
							 mov                     grid[292], cornerRightDownCode
							 mov                     grid[232], cornerLeftDownCode
							 mov                     grid[262], cornerLeftUpCode
							 mov                     grid[233], cornerRightUpCode
							 mov                     grid[263], cornerRightDownCode
							 mov                     grid[266], verticalWallCode
							 mov                     grid[236], verticalWallCode
							 mov                     grid[206], cornerRightUpCode
							 mov                     grid[296], cornerRightDownCode
							 mov                     grid[205], endWallLeftCode
							 mov                     grid[295], endWallLeftCode	

	; Testing item drawing functions:
	                         mov                     grid[288], 127
	                         mov                     grid[400], 127
	                         mov                     grid[118], 127
	                         mov                     grid[197], 127
	                         mov                     grid[76], 127
	                         mov                     grid[214], 127
	                         mov                     grid[310], 127
						   
endm DrawLevel1

;----------------------------------------------------------------------------------------

GridToCell macro gridX, gridY ; takes xPosition, yPosition, puts the cell number in bx
	mov bx, word ptr gridY
	shl bx, 5
	shl gridY, 1
	sub bx, word ptr gridY
	shr gridY, 1
	add bx, word ptr gridX
endm CheckWall

; puts a random number in ax
GetRandomNumber macro value
    push bx
    push dx
    xor ax, seed
    xor dx, dx
    mov bx, value
    div bx
    inc dx
    mov ax, dx
	mov dx, seed
	add dx, ax
	mov seed, dx
    pop dx
    pop bx
endm RandomNumber

Chat macro
local CheckKey
local BeginWriting
local Again1
local SendNextLetter
local Again
local CheckRecieved
local ReceiveNextLetter
local Check1
local EndChat
         mov           ax, @data
	     mov           ds, ax
         call          InitializeSerialPort
	     SetTextMode
         mov dl, 0
         mov dh, 12
         MoveCursor
         DisplayString notificationBar
         mov dl, 0
         mov dh, 0
	     MoveCursor
	     DisplayString player1Name+2
         mov dl, 0
         mov dh, 13
	     MoveCursor 
	     DisplayString player2Name+2
CheckKey:         
        mov ah, 1
        int 16h
        cmp ah, 1ch
        jz BeginWriting
        cmp ah, 3dh
        jz EndChat
        RemoveValueBuffer
        jmp CheckRecieved
BeginWriting:
           RemoveValueBuffer
           mov dl, 7
           mov dh, 15
           MoveCursor
	       mov  ah, 0Ah
	       mov  dx, offset msgToSend
	       int  21h
           mov  si, offset msgToSend+1
	       mov  cl, byte ptr [si]         ;Send size of string
           mov  ah, cl
           mov dx , 3fdh		; Line Status Register
Again1:  	
            in al , dx 			;Read Line Status
  	     	and al , 00100000b
            jz Again1
            call SendValueThroughSerial
            lea  si, msgToSend+2
SendNextLetter:  
        	mov dx , 3fdh		; Line Status Register
Again:  	in al , dx 			;Read Line Status
  	     	and al , 00100000b
      		jz Again
            mov  ah,[si]
            call SendValueThroughSerial
            inc  si
            dec  cl   
            jnz  SendNextLetter
            jmp  CheckKey
CheckRecieved:
			call ReceiveValueFromSerial
			cmp al, 1
			jz CheckKey
			lea SI, MsgToReceive+1
			mov cl, ah
			inc SI
			mov dl, 7
			mov dh, 1
			MoveCursor
ReceiveNextLetter:
			mov dx, 3fdh		; Line Status Register
Check1:
			in al, dx 
			and al, 1
			jz Check1
			call ReceiveValueFromSerial
			mov dl, ah
			MOV ah, 2
			int 21h
			dec cl
			jnz ReceiveNextLetter
			mov dl, 7
			mov dh, 1
			MoveCursor
			DisplayString MsgToReceive+2
			JMP CheckKey
EndChat:
            SetTextMode
            mov dl, 0
            mov dh, 0
            MoveCursor
            mov ah,4ch
            int 21h
endm Chat
;---------------------------------------------------------------------------------------

.model huge
.386 
.stack 0ffffh
.data
	player1Name         db  15 , ? , 30 dup("$")
	player2Name         db  15 , ? , 30 dup("$")
	nameMessage         db  'Please Enter Your Name: $'
	enterMessage        db  'Press Enter to Continue$'
	welcomeMessage1     db  'Welcome To Our Game, Player 1!$'
	welcomeMessage2     db  'Welcome To Our Game, Player 2!$'
	warningMessage      db  '$$Please Enter a Valid Name!$'
	chattingInfo        db  '*To start chatting press F1$'
	gameStartInfo       db  '*To Start the Game press F2$'
	endgameInfo         db  '*To end the game press ESC$'
	level1Msg           db  '*To start level 1 press F1$'
	level2Msg           db  '*To start level 2 press F2$'
	notificationBar     db  '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$'
	chooseLevelMsg      db  'Please Choose a level: $'
	player1WinsMsg      db  '!!!! PLAYER1 WINS !!!!$'
	player2WinsMsg      db  '!!!! PLAYER2 WINS !!!!$'
	welcomePosition     dw  0h
	scoreMessage1       db  'Score #1: $'
	scoreMessage2       db  'Score #2: $'
	player1Score        dw  0h
	player2Score        dw  0h
	livesMessage1       db  'Lives #1: $'
	livesMessage2       db  'Lives #2: $'
	player1Lives        dw  3h
	player2Lives        dw  3h
	scanF1              equ 3Bh
	;Scan code for F2 - change to 00h if using emu8086 else keep 3Ch
	scanF2              equ 3Ch
	scanF4              equ 3Eh
	scanESC             equ 1Bh
	grid                db  480 dup(dotCode)
	grid2               db  cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,    horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,vacantCode,vacantCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,              horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,vacantCode
	                    db  verticalWallCode,dotCode,dotCode,dotCode,dotCode,dotCode,127,dotCode,dotCode,dotCode,                                                                                                                                           dotCode,dotCode,dotCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,dotCode,dotCode,dotCode,                                                                                    127,dotCode,dotCode,dotCode,127,dotCode,dotCode,dotCode,cornerLeftDownCode,cornerRightUpCode
	                    db  verticalWallCode,dotCode,dotCode,cornerLeftUpCode,cornerRightUpCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                                      horizontalWallCode,cornerRightUpCode,dotCode,dotCode,127,dotCode,dotCode,dotCode,cornerLeftUpCode,horizontalWallCode,                                                                                        horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,dotCode,cornerLeftUpCode,cornerRightUpCode,dotCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,cornerLeftUpCode,cornerRightDownCode,verticalWallCode,dotCode,verticalWallCode,vacantCode,vacantCode,vacantCode,                                                               vacantCode,verticalWallCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,dotCode,cornerLeftDownCode,horizontalWallCode,                                      horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,dotCode,verticalWallCode,cornerLeftDownCode,cornerRightUpCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,dotCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                              horizontalWallCode,cornerRightDownCode,dotCode,verticalWallCode,dotCode,dotCode,verticalWallCode,dotCode,dotCode,dotCode,                                                                                        dotCode,dotCode,127,dotCode,127,verticalWallCode,vacantCode,verticalWallCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,127,dotCode,dotCode,dotCode,dotCode,                                                                                                          dotCode,dotCode,127,endWallDownCode,dotCode,dotCode,endWallDownCode,dotCode,cornerLeftUpCode,horizontalWallCode,                                                                                             horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,127,verticalWallCode,vacantCode,verticalWallCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                                horizontalWallCode,cornerRightUpCode,dotCode,dotCode,dotCode,dotCode,dotCode,127,cornerLeftDownCode,horizontalWallCode,                                                                                      horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,dotCode,cornerLeftDownCode,horizontalWallCode,cornerRightDownCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,cornerLeftDownCode,horizontalWallCode,cornerRightDownCode,dotCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                 horizontalWallCode,cornerRightDownCode,dotCode,endWallLeftCode,triWallUpCode,cornerRightUpCode,dotCode,dotCode,dotCode,dotCode,                                                                              127,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,                                                                                                                                           dotCode,dotCode,dotCode,dotCode,cornerLeftDownCode,triWallDownCode,endWallRightCode,dotCode,cornerLeftUpCode,horizontalWallCode,                                                                             horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,dotCode,cornerLeftUpCode,horizontalWallCode,cornerRightUpCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,cornerLeftUpCode,horizontalWallCode,cornerRightUpCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                       horizontalWallCode,cornerRightUpCode,dotCode,dotCode,dotCode,127,dotCode,dotCode,cornerLeftDownCode,horizontalWallCode,                                                                                      horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,127,verticalWallCode,vacantCode,verticalWallCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,127,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                              horizontalWallCode,cornerRightDownCode,dotCode,endWallUpCode,dotCode,dotCode,endWallUpCode,dotCode,dotCode,dotCode,                                                                                              dotCode,dotCode,127,dotCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,dotCode,dotCode,dotCode,dotCode,dotCode,                                                                                                          dotCode,dotCode,dotCode,verticalWallCode,dotCode,dotCode,verticalWallCode,dotCode,cornerLeftUpCode,horizontalWallCode,                                                                                           horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,cornerLeftDownCode,cornerRightUpCode,verticalWallCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                       horizontalWallCode,cornerRightUpCode,dotCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,127,verticalWallCode,vacantCode,                                   vacantCode,vacantCode,vacantCode,verticalWallCode,127,verticalWallCode,cornerLeftUpCode,cornerRightDownCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,dotCode,cornerLeftDownCode,cornerRightDownCode,dotCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                                horizontalWallCode,cornerRightDownCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,cornerLeftDownCode,horizontalWallCode,                                                                                    horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,dotCode,cornerLeftDownCode,cornerRightDownCode,127,dotCode,verticalWallCode
	                    db  cornerLeftDownCode,cornerRightUpCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,                                                                                                                           dotCode,dotCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,dotCode,dotCode,dotCode,                                                                                        dotCode,127,dotCode,dotCode,dotCode,127,dotCode,dotCode,127,verticalWallCode
	                    db  vacantCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,          horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,vacantCode,vacantCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,          horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode
	
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
	filllvl1            equ 68h
	filllvl2            equ 0dbh
	borderlvl1          equ white
	player1InitialColor equ yellow
	player1Color        db  player1InitialColor
	player2InitialColor equ lightGreen
	player2Color        db  player2InitialColor
	borderColor         db  0
	backgroundColor     equ black
	fillColor           db  0
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
	decLifeCode         equ 24
	vacantCode          equ 25
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
	player1IsBigDot     dw  0
	player2IsBigDot     dw  0
	player1IsGreenDot   db  0
	player2IsGreenDot   db  0
	freezeDuration      equ 25
	player1FreezeDur    db  freezeDuration
	player2FreezeDur    db  freezeDuration
	ghostFreezeDur      db  freezeDuration
	bigDotDuartion      equ 15
	player1BigDotDur    db  bigDotDuartion
	player2BigDotDur    db  bigDotDuartion
	greenDotDuration    equ 15
	player1GreenDotDur  db  greenDotDuration
	player2GreenDotDur  db  greenDotDuration
	ghostX              db  0
	ghostY              db  0
	searchX             db  0
	searchY             db  0
	nodeX               db  0
	nodeY               db  0
	searchCount         dw  0
	rightValue          dw  0ffh
	leftValue           dw  0ffh
	upValue             dw  0ffh
	downValue           dw  0ffh
	maxValue            dw  0ffh
	nextMove            db  0
	isPlayer1Dead       db  0
	isPlayer2Dead       db  0
	isGameFinished      db  0
	player1Respawn      db  0
	player2Respawn      db  0
	player1Initial      dw  0
	player2Initial      dw  0
	player1Lvl1Initial  equ 31
	player2lvl1Initial  equ 448
	player1Lvl2Initial  equ 31
	player2Lvl2Initial  equ 448
	IsF4Pressed         db  0
	zerogrid            db  480 dup(dotcode)
	IsLevel2            db  0
	letterToSend        db  ?
	msgToSend           db  60,?,60 dup('$')
	MsgToReceive        db  60,?,60 dup('$')
	letterToReceive     db  ?
	confirmReceive      db  10
	ghostCount          dw  4
	ghostPositions      dw  16 dup(?)
	ghostPeriod         equ 20
	ghostTimer          db  1
	powerUpPosition     dw  ?
	powerUpPeriod       equ 30
	powerUpTimer        db  1
	seed                dw  ?
	dotcount            db  0

.code
AddPowerUp proc
	                         dec                     powerUpTimer
	                         jnz                     EndAddPowerUp
	                         mov                     powerUpTimer, powerUpPeriod
	                         GetRandomNumber         480
	                         mov                     bx, ax
	FindEmptyCellPowerup:    
	                         cmp                     grid[bx], 127d
	                         je                      EmptyCellFoundPowerup
	                         inc                     bx
	                         cmp                     bx, 480
	                         jb                      FindEmptyCellPowerup
	                         jmp                     EndAddPowerUp
	EmptyCellFoundPowerup:   
	                         cmp                     grid[bx], 127
	                         jne                     EndAddPowerUp

	                         GetRandomNumber         50
	                         cmp                     ax, 10
	                         jb                      AddCherry
	                         cmp                     ax, 20
	                         jb                      AddSnowFlake
	                         cmp                     ax, 30
	                         jb                      AddTrap
	                         cmp                     ax, 40
	                         jb                      AddExtraLife
	                         cmp                     ax, 50
	                         jb                      AddDecLife
	AddCherry:               
	                         mov                     grid[bx], cherryCode
	                         jmp                     EndAddPowerUp
	AddSnowFlake:            
	                         mov                     grid[bx], snowflakeCode
	                         jmp                     EndAddPowerUp
	AddTrap:                 
	                         mov                     grid[bx], trapCode
	                         jmp                     EndAddPowerUp
	AddExtraLife:            
	                         mov                     grid[bx], extraLifeCode
	                         jmp                     EndAddPowerUp
	AddDecLife:              
	                         mov                     grid[bx], decLifeCode
	                         jmp                     EndAddPowerUp
	EndAddPowerUp:           
	                         ret
AddPowerUp endp

MoveGhosts proc
	                         dec                     ghostTimer
	                         jnz                     EndMoveGhost
	                         cmp                     ghostsIsFrozen, 1
	                         je                      EndMoveGhost
	                         mov                     ghostTimer, ghostPeriod
	                         mov                     cx, ghostCount
	                         mov                     si, 0
	LoopOverGhosts:          
	                         mov                     di, ghostPositions[si]
	                         cmp                     grid[di], 128
	                         jb                      DontClearGhost
	                         mov                     grid[di], 127
	DontClearGhost:          
	                         GetRandomNumber         480
	                         mov                     bx, ax
	FindEmptyCellGhost:      
	                         cmp                     grid[bx], 127d
	                         je                      EmptyCellFoundGhost
	                         inc                     bx
	                         cmp                     bx, 480
	                         jb                      FindEmptyCellGhost
	ContinueLoopOverGhosts:  
	                         add                     si, 2
	                         dec                     cx
	                         jnz                     LoopOverGhosts
	                         jmp                     EndMoveGhost
	EmptyCellFoundGhost:     
	                         mov                     grid[bx], 128d
	                         mov                     ghostPositions[si], bx
	                         jmp                     ContinueLoopOverGhosts
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
	                         cmp                     ah, scanF4
	                         je                      ApplyF4InMove
							 cmp ah, scanF1
							 je InGameChat
	AfterF4Check:            
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
	ApplyF4InMove:           
	                         mov                     IsF4Pressed, 1
	                         jmp                     AfterF4Check
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
	                         jae                     GhostRightPlayer1
	;end check ghost
	;check player2
	                         inc                     currentXPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         dec                     currentXPlayer1
	                         cmp                     grid[bx],player2Code
	                         je                      player2right
	;end check player2
	ContMoveRight1:          
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
	                         jae                     GhostLeftPlayer1
	;check player2
	ContMoveLeft1:           
	                         dec                     currentXPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         inc                     currentXPlayer1
	                         cmp                     grid[bx],player2Code
	                         je                      player2left
	;end check player2
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
	                         jae                     GhostUpPlayer1
	;end check Ghosts
	;check player2
	ContMoveUp1:             
	                         dec                     currentYPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         inc                     currentYPlayer1
	                         cmp                     grid[bx],player2Code
	                         je                      player2up
	;end check player2
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
	                         jae                     GhostDownPlayer1
	;end check Ghosts
	;check player2
	ContMoveDown1:           
	                         inc                     currentYPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         dec                     currentYPlayer1
	                         cmp                     grid[bx],player2Code
	                         je                      player2down
	;end check player2
	                         GridToCell              currentXPlayer1, currentYPlayer1
	                         mov                     grid[bx],127
	                         add                     currentYPlayer1,1
	                         jmp                     ChangePlayer1Pacman
	ChangePlayer1Pacman:     
	                         GridToCell              currentXPlayer1, currentYPlayer1
	                         jmp                     CheckPowerUpsPlayer1
	AfterPowerUp1:           
	                         cmp                     player1Lives, 0
	                         je                      Player1Deadd
	                         mov                     grid[bx],player1Code
	                         mov                     player1Moved,1
	                         jmp                     MoveLoop
	Player1Deadd:            
	                         mov                     isPlayer1Dead, 1
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
	                         je                      ApplyBigDot1
	                         cmp                     grid[bx], trapCode
	                         je                      ApplyGreenDot1
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
	ApplyBigDot1:            
	                         mov                     player1BigDotDur, bigDotDuartion
	                         mov                     player1IsBigDot, 1
	                         mov                     player1IsGreenDot, 0
	                         jmp                     ReturningToMovePlayer1
	ApplyGreenDot1:          
	                         mov                     player1GreenDotDur, bigDotDuartion
	                         mov                     player1IsGreenDot, 1
	                         mov                     player1IsBigDot, 0
	                         jmp                     ReturningToMovePlayer1

	ApplyPacmanLife1:        
	                         add                     player1Lives, 1
	                         jmp                     ReturningToMovePlayer1
	ApplyPacmanUnLife1:      
	                         cmp                     player2Lives,0
	                         je                      SetPlayer2Dead
	                         sub                     player2Lives, 1
	                         je                      SetPlayer2Dead
	                         jmp                     ReturningToMovePlayer1
	SetPlayer2Dead:          
	                         mov                     isPlayer2Dead, 1
	                         jmp                     ReturningToMovePlayer1

	
	SetDead1:                
	                         mov                     isPlayer1Dead, 1
	                         jmp                     moveLoop
	GhostRightPlayer1:       
	                         mov                     ax,player1IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostrightplayer1
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         dec                     player1Lives
	                         cmp                     player1Lives, 0
	                         je                      SetDead1
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         mov                     player1Respawn, 1
	                         jmp                     MoveLoop
	eatghostRightplayer1:    
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         add                     player1Score,10
	                         add                     currentXPlayer1,1
	                         jmp                     ChangePlayer1Pacman
	GhostUpPlayer1:          
	                         mov                     ax,player1IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostUpplayer1
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         dec                     player1Lives
	                         cmp                     player1Lives, 0
	                         je                      SetDead1
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         mov                     player1Respawn, 1
	                         jmp                     MoveLoop
	eatghostUpplayer1:       
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         add                     player1Score,10
	                         sub                     currentYPlayer1,1
	                         jmp                     ChangePlayer1Pacman

	GhostDownPlayer1:        
	                         mov                     ax,player1IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostDownplayer1
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         dec                     player1Lives
	                         cmp                     player1Lives, 0
	                         je                      SetDead1
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         mov                     player1Respawn, 1
	                         jmp                     MoveLoop
	eatghostDownplayer1:     
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         add                     player1Score,10
	                         add                     currentYPlayer1,1
	                         jmp                     ChangePlayer1Pacman

	GhostLeftPlayer1:        
	                         mov                     ax,player1IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostLeftplayer1
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         dec                     player1Lives
	                         cmp                     player1Lives, 0
	                         je                      SetDead1
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         mov                     player1Respawn, 1
	                         jmp                     MoveLoop
	eatghostLeftplayer1:     
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         add                     player1Score,10
	                         sub                     currentXPlayer1,1
	                         jmp                     ChangePlayer1Pacman

	player2right:            
	                         cmp                     player1IsGreenDot,1
	                         je                      eatplayer2Right
	                         jmp                     moveLoop
	eatplayer2Right:         mov                     grid[bx], 127
	                         dec                     player2Lives
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         add                     player1Score,20
	                         inc                     currentXPlayer1
	                         mov                     player2Respawn, 1
	                         jmp                     ContMoveRight1

	player2left:             
	                         cmp                     player1IsGreenDot,1
	                         je                      eatplayer2left
	                         jmp                     moveLoop
	eatplayer2left:          mov                     grid[bx], 127
	                         dec                     player2Lives
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         add                     player1Score,20
	                         dec                     currentXPlayer1
	                         mov                     player2Respawn, 1
	                         jmp                     ContMoveLeft1

	player2up:               
	                         cmp                     player1IsGreenDot,1
	                         je                      eatplayer2up
	                         jmp                     moveLoop
	eatplayer2up:            mov                     grid[bx], 127
	                         dec                     player2Lives
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         add                     player1Score,20
	                         inc                     currentYPlayer1
	                         mov                     player2Respawn, 1
	                         jmp                     ContMoveUp1

	player2down:             
	                         cmp                     player1IsGreenDot,1
	                         je                      eatplayer2down
	                         jmp                     moveLoop
	eatplayer2down:          mov                     grid[bx], 127
	                         dec                     player2Lives
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         add                     player1Score,20
	                         dec                     currentYPlayer1
	                         mov                     player2Respawn, 1
	                         jmp                     ContMoveDown1
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
	                         jae                     GhostRightPlayer2
	;end check ghosts
	;check player1
	                         inc                     currentXPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         dec                     currentXPlayer2
	                         cmp                     grid[bx],player1Code
	                         je                      player1right
	;end check player1
	ContMoveRight2:          

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
	                         jae                     GhostLeftPlayer2
	;end check ghosts
	;check player1
	                         dec                     currentXPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         inc                     currentXPlayer2
	                         cmp                     grid[bx],player1Code
	                         je                      player1left
	;end check player1
	ContMoveLeft2:           
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         sub                     currentXPlayer2,1
	                         jmp                     ChangePlayer2Pacman
	MovePlayer2Up:           
	                         cmp                     player2Moved,0
	                         jne                     MoveLoop
	                         mov                     player2Orientation, 'U'
	;check walls
	                         dec                     currentYPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         inc                     currentYPlayer2
	                         cmp                     grid[bx],16
	                         jb                      MoveLoop
	;end check walls
	;check ghost
	                         dec                     currentYPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         inc                     currentYPlayer2
	                         cmp                     grid[bx],128
	                         jae                     GhostUpPlayer2
	;end check ghost
	;check player1
	                         dec                     currentYPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         inc                     currentYPlayer2
	                         cmp                     grid[bx],player1Code
	                         je                      player1up
	;end check player1
	ContMoveUp2:             
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
	                         jae                     GhostDownPlayer2
	;end check Ghosts
	;check player1
	                         inc                     currentYPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         dec                     currentYPlayer2
	                         cmp                     grid[bx],player1Code
	                         je                      player1down
	;end check player1
	ContMoveDown2:           
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx], 127
	                         add                     currentYPlayer2, 1
	                         jmp                     ChangePlayer2Pacman
	ChangePlayer2Pacman:     
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         jmp                     CheckPowerUpsPlayer2
	AfterPowerUp2:           
	                         cmp                     player2Lives, 0
	                         je                      Player2Deadd
	                         mov                     grid[bx], player2Code
	                         mov                     player2Moved, 1
	                         jmp                     MoveLoop
	Player2Deadd:            
	                         mov                     isPlayer2Dead, 1
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
	                         je                      ApplyBigDot2
	                         cmp                     grid[bx], trapCode
	                         je                      ApplyGreenDot2
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
	ApplyBigDot2:            
	                         mov                     player2BigDotDur, bigDotDuartion
	                         mov                     player2IsBigDot, 1
	                         mov                     player2IsGreenDot, 0
	                         jmp                     ReturningToMovePlayer2
	ApplyGreenDot2:          
	                         mov                     player2GreenDotDur, greenDotDuration
	                         mov                     player2IsGreenDot, 1
	                         mov                     player2IsBigDot, 0
	                         jmp                     ReturningToMovePlayer2
	ApplyPacmanLife2:        
	                         add                     player2Lives, 1
	                         jmp                     ReturningToMovePlayer2
	ApplyPacmanUnLife2:      
	                         cmp                     player1Lives,0
	                         je                      SetPlayer1Dead
	                         sub                     player1Lives, 1
	                         je                      SetPlayer1Dead
	                         jmp                     ReturningToMovePlayer2
	SetPlayer1Dead:          
	                         mov                     isPlayer1Dead, 1
	                         jmp                     ReturningToMovePlayer2

	DecrementPlayer2Live:    
	                         GridToCell              currentXPlayer2,currentYPlayer2
	                         mov                     grid[bx],127
	                         dec                     player2Lives
	                         cmp                     player2Lives, 0
	                         je                      SetDead2
	                         mov                     currentXPlayer2, 28
	                         mov                     currentYPlayer2, 14                                                          	;we can add a delay later maybe integrate the freeze functionality
	                         mov                     player2Respawn, 1
	                         jmp                     MoveLoop
	SetDead2:                mov                     isPlayer2Dead,1
	                         jmp                     MoveLoop
	GhostRightPlayer2:       
	                         mov                     ax,player2IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostrightplayer2
	                         GridToCell              currentXPlayer2,currentYPlayer2
	                         mov                     grid[bx],127
	                         dec                     player2Lives
	                         cmp                     player2Lives, 0
	                         je                      SetDead2
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         mov                     player2Respawn, 1
	                         jmp                     MoveLoop
	eatghostRightplayer2:    
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         add                     player2Score,10
	                         add                     currentXPlayer2,1
	                         jmp                     ChangePlayer2Pacman
	GhostUpPlayer2:          
	                         mov                     ax,player2IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostUpplayer2
	                         GridToCell              currentXPlayer2,currentYPlayer2
	                         mov                     grid[bx],127
	                         dec                     player2Lives
	                         cmp                     player2Lives, 0
	                         je                      SetDead2
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         mov                     player2Respawn, 1
	                         jmp                     MoveLoop
	eatghostUpplayer2:       
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         add                     player2Score,10
	                         sub                     currentYPlayer2,1
	                         jmp                     ChangePlayer2Pacman

	GhostDownPlayer2:        
	                         mov                     ax,player2IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostDownplayer2
	                         GridToCell              currentXPlayer2,currentYPlayer2
	                         mov                     grid[bx],127
	                         dec                     player2Lives
	                         cmp                     player2Lives, 0
	                         je                      SetDead2
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         mov                     player2Respawn, 1
	                         jmp                     MoveLoop
	eatghostDownplayer2:     
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         add                     player2Score,10
	                         add                     currentYPlayer2,1
	                         jmp                     ChangePlayer2Pacman

	GhostLeftPlayer2:        
	                         mov                     ax,player2IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostLeftplayer2
	                         GridToCell              currentXPlayer2,currentYPlayer2
	                         mov                     grid[bx],127
	                         dec                     player2Lives
	                         cmp                     player2Lives, 0
	                         je                      SetDead2
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         mov                     player2Respawn, 1
	                         jmp                     MoveLoop
	eatghostLeftplayer2:     
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         add                     player2Score,10
	                         sub                     currentXPlayer2,1
	                         jmp                     ChangePlayer2Pacman

	player1right:            
	                         cmp                     player2IsGreenDot,1
	                         je                      eatplayer1Right
	                         jmp                     moveLoop
	eatplayer1Right:         mov                     grid[bx], 127
	                         dec                     player1Lives
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         add                     player2Score,20
	                         inc                     currentXPlayer2
	                         mov                     player1Respawn, 1
	                         jmp                     ContMoveRight2

	player1left:             
	                         cmp                     player2IsGreenDot,1
	                         je                      eatplayer1left
	                         jmp                     moveLoop
	eatplayer1left:          mov                     grid[bx], 127
	                         dec                     player1Lives
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         add                     player2Score,20
	                         dec                     currentXPlayer2
	                         mov                     player1Respawn, 1
	                         jmp                     ContMoveLeft2

	player1up:               
	                         cmp                     player2IsGreenDot,1
	                         je                      eatplayer1up
	                         jmp                     moveLoop
	eatplayer1up:            mov                     grid[bx], 127
	                         dec                     player1Lives
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         add                     player2Score,20
	                         inc                     currentYPlayer2
	                         mov                     player1Respawn, 1
	                         jmp                     ContMoveUp2

	player1down:             
	                         cmp                     player2IsGreenDot,1
	                         je                      eatplayer1down
	                         jmp                     moveLoop
	eatplayer1down:          mov                     grid[bx], 127
	                         dec                     player1Lives
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         add                     player2Score,20
	                         dec                     currentYPlayer2
	                         mov                     player1Respawn, 1
	                         jmp                     ContMoveDown2
		InGameChat:
			Chat
			SetVideoMode
			jmp MoveLoop
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

IsBigDot proc
	CheckPlayer1BigDot:      
	                         cmp                     player1IsBigDot,1
	                         je                      DecPlayer1BigDotEffect
	CheckPlayer2BigDot:      
	                         cmp                     player2IsBigDot, 1
	                         je                      DecPlayer2BigDotEffect
	ReturnBigDot:            
	                         ret
	DecPlayer1BigDotEffect:  
	                         sub                     player1BigDotDur,1
	                         jz                      SetBigDot1
	                         jmp                     CheckPlayer2BigDot
	SetBigDot1:              
	                         mov                     player1IsBigDot,0
	                         jmp                     CheckPlayer2BigDot
	DecPlayer2BigDotEffect:  
	                         sub                     player2BigDotDur,1
	                         jz                      SetBigDot2
	                         jmp                     ReturnBigDot
	SetBigDot2:              
	                         mov                     player2IsBigDot,0
	                         jmp                     ReturnBigDot
	EndMovePacMann:          
	                         ret
IsBigDot endp


IsGreenDot proc
	CheckPlayer1GreenDot:    
	                         cmp                     player1IsGreenDot,1
	                         je                      DecPlayer1GreenDotEffect
	CheckPlayer2GreenDot:    
	                         cmp                     player2IsGreenDot, 1
	                         je                      DecPlayer2GreenDotEffect
	ReturnGreenDot:          
	                         ret
	DecPlayer1GreenDotEffect:
	                         sub                     player1GreenDotDur,1
	                         jz                      SetGreenDot1
	                         jmp                     CheckPlayer2GreenDot
	SetGreenDot1:            
	                         mov                     player1IsGreenDot,0
	                         jmp                     CheckPlayer2GreenDot
	DecPlayer2GreenDotEffect:
	                         sub                     player2GreenDotDur,1
	                         jz                      SetGreenDot2
	                         jmp                     ReturnGreenDot
	SetGreenDot2:            
	                         mov                     player2IsGreenDot,0
	                         jmp                     ReturnGreenDot
	EndMovePacMannn:         
	                         ret
IsGreenDot endp

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
	AfterRespawnCheck:       
	                         cmp                     player1Respawn, 1
	                         je                      Player1NeedRespawn
	                         cmp                     player2Respawn, 1
	                         je                      Player2NeedRespawn
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
	                         cmp                     grid[si], extraLifeCode
	                         je                      Life
	                         cmp                     grid[si], decLifeCode
	                         je                      UnLife
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
	                         cmp                     grid[si], vacantCode
	                         je                      Vacant
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
	                         DrawSquare              currentX, currentY, gridStep, backGroundColor , backgroundColor              	;borderColor, backgroundColor
	                         jmp                     ContinueDraw
	Vacant:                  
	                         DrawSquare              currentX, currentY, gridStep, backgroundColor , backgroundColor
	                         jmp                     ContinueDraw
	Player1NeedRespawn:      
	                         mov                     player1Respawn, 0
	                         cmp                     player1Lives, 0
	                         je                      Player1DeadDrawGrid
	; Change the initial location according to the level here:
	                         mov                     bx, player1Initial
	                         mov                     grid[bx], player1Code
	                         mov                     player1Orientation, 'R'
	                         jmp                     AfterRespawnCheck
	Player1DeadDrawGrid:     
	                         mov                     grid[31], 127
	                         jmp                     AfterRespawnCheck
	Player1:                 
	                         cmp                     isPlayer1Dead, 1
	                         je                      Player1Dead
	                         cmp                     player1IsFrozen, 1
	                         je                      Player1Frozen
	                         cmp                     player1IsBigDot, 1
	                         je                      Player1BigDot
	                         cmp                     player1IsGreenDot, 1
	                         je                      Player1GreenDot
	                         mov                     player1Color,player1InitialColor
	DrawPlayer1:             
	                         DrawPlayer              currentX, currentY, player1Color, backgroundColor, isOpen, player1Orientation
	                         jmp                     ContinueDraw
	Player1Dead:             
	                         mov                     grid[si], 127
	                         jmp                     ContinueDraw
	Player1Frozen:           
	                         mov                     player1Color, lightBlue
	                         jmp                     DrawPlayer1
	Player1BigDot:           
	                         mov                     player1Color, white
	                         jmp                     DrawPlayer1
	Player1GreenDot:         
	                         mov                     player1Color, green
	                         jmp                     DrawPlayer1
	Player2NeedRespawn:      
	                         mov                     player2Respawn, 0
	                         cmp                     player2Lives, 0
	                         je                      Player2DeadDrawGrid
	                         mov                     bx, player2Initial
	                         mov                     grid[bx], player2Code
	                         mov                     player2Orientation, 'L'
	                         jmp                     AfterRespawnCheck
	Player2DeadDrawGrid:     
	                         mov                     grid[448], 127
	                         jmp                     AfterRespawnCheck
	Player2:                 
	                         cmp                     isPlayer2Dead, 1
	                         je                      Player2Dead
	                         cmp                     player2IsFrozen, 1
	                         je                      Player2Frozen
	                         cmp                     player2IsBigDot, 1
	                         je                      Player2BigDot
	                         cmp                     player2IsGreenDot, 1
	                         je                      Player2GreenDot
	                         mov                     player2Color, player2InitialColor
	DrawPlayer2:             
	                         DrawPlayer              currentX, currentY, player2Color, backgroundColor, isOpen, player2Orientation
	                         jmp                     ContinueDraw
	Player2Dead:             
	                         mov                     grid[si], 127
	                         jmp                     ContinueDraw
	Player2Frozen:           
	                         mov                     player2Color,lightBlue
	                         jmp                     DrawPlayer2
	Player2BigDot:           
	                         mov                     player2Color, white
	                         jmp                     DrawPlayer2
	Player2GreenDot:         
	                         mov                     player2Color, green
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
	                         add                     dotcount, 1
	                         jmp                     ContinueDraw
	BigDot:                  
	                         DrawBigDot              currentX, currentY, white, backgroundColor
	                         jmp                     ContinueDraw
	Trap:                    
	                         DrawTrap                currentX, currentY, backgroundColor, lightGreen, green
	                         jmp                     ContinueDraw
	Life:                    
	                         DrawPacManLife          currentX, currentY, green, white, backgroundColor
	                         jmp                     ContinueDraw
	UnLife:                  
	                         DrawPacManUnlife        currentX, currentY, red, white, backgroundColor
	                         jmp                     ContinueDraw
	CornerLeftUp:            
	                         DrawCornerWallLeftUp    currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	CornerLeftDown:          
	                         DrawCornerWallLeftDown  currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	CornerRightUp:           
	                         DrawCornerWallRightUp   currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	CornerRightDown:         
	                         DrawCornerWallRightDown currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	QuadWall:                
	                         DrawQuadWall            currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	TriWallLeft:             
	                         DrawTriWallLeft         currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	TriWallRight:            
	                         DrawTriWallRight        currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	TriWallUp:               
	                         DrawTriWallUp           currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	TriWallDown:             
	                         DrawTriWallDown         currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	HorizontalWall:          
	                         DrawWallHorizontal      currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	VerticalWall:            
	                         DrawWallVertical        currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	EndWallLeft:             
	                         DrawEndWallLeft         currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	EndWallRight:            
	                         DrawEndWallRight        currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	EndWallUp:               
	                         DrawEndWallUp           currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	EndWallDown:             
	                         DrawEndWallDown         currentX, currentY, borderColor, fillColor, backgroundColor
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

InitializeSerialPort proc	near
	                         mov                     dx,3fbh                                                                      	; Line Control Register
	                         mov                     al,10000000b                                                                 	;Set Divisor Latch Access Bit
	                         out                     dx,al                                                                        	;Out it
	                         mov                     dx,3f8h                                                                      	;Set LSB byte of the Baud Rate Divisor Latch register.
	                         mov                     al,0ch
	                         out                     dx,al
	                         mov                     dx,3f9h                                                                      	;Set MSB byte of the Baud Rate Divisor Latch register.
	                         mov                     al,00h
	                         out                     dx,al
	                         mov                     dx,3fbh                                                                      	;Set port configuration
	                         mov                     al,00011011b
	                         out                     dx, al
	                         ret
InitializeSerialPort endp
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	;sends value in AH
SendValueThroughSerial proc	near
	                         push                    dx
	                         push                    ax
	;Check that Transmitter Holding Register is Empty
	                         mov                     dx , 3FDH                                                                    	; Line Status Register
	                         in                      al , dx                                                                      	;Read Line Status
	                         test                    al , 00100000b
	                         jnz                     EmptyLineRegister                                                            	;Not empty
	                         pop                     ax
	                         pop                     dx
	                         ret
	EmptyLineRegister:       
	;If empty put the VALUE in Transmit data register
	                         mov                     dx , 3F8H                                                                    	; Transmit data register
	                         mov                     al, ah
	                         out                     dx, al
	                         pop                     ax
	                         pop                     dx
	                         ret
SendValueThroughSerial endp

	; receives a byte from serial stored in AH, and the AL is used a flag (0 means there is a value, 1 means no value was sent)
ReceiveValueFromSerial proc	near
	;Check that Data is Ready
	                         push                    dx
	                         mov                     dx , 3FDH                                                                    	; Line Status Register
	                         in                      al , dx
	                         test                    al , 1
	                         JNZ                     SerialInput                                                                  	;Not Ready
	                         mov                     al, 1
	                         pop                     dx
	                         ret                                                                                                  	;if 1 return
	SerialInput:             
	;If Ready read the VALUE in Receive data register
	                         mov                     dx , 03F8H
	                         in                      al , dx
	                         mov                     ah, al
	                         mov                     al, 0
	                         pop                     dx
	                         ret
ReceiveValueFromSerial endp

main proc far

	                         mov                     ax, @data
	                         mov                     ds, ax
	                         mov                     es, ax
	                         mov                     di, offset grid
	                         

	;jmp                     SetLevel2
	;jmp                     setlevel1
	GetPlayer1Name:                                                                                                               	;Reading first player name and saving it to player1name
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
	GetPlayer2Name:                                                                                                               	;Reading second player name and saving it to player2name
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

	MainMenu:                                                                                                                     	;displaying main menu and provided functions and how to use them
	                         mov                     ax, @data
	                         mov                     ds, ax
	                         mov                     es, ax
	                         mov                     di, offset grid
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
	                         Displaystring           notificationBar
	AgainTillKeyPressed:                                                                                                          	;checking if a key is pressed on the main menu
	                         mov                     ah, 08h                                                                      	;these two line are used to flush the keyboard buffer
	                         int                     21h
	                         mov                     ah, 1
	                         int                     16h
	                         cmp                     al, scanESC                                                                  	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                         je                      Terminate1
	                         cmp                     al, scanF1
	                         je                      ChatModule
	                         cmp                     al, scanF2                                                                   	;comparing ah with the f2 scan code if equal go to game loading menu
	                         je                      LoadingMenu
	                         jmp                     AgainTillKeyPressed

	Terminate1:              jmp                     Terminate2
	ChatModule:              Chat

	LoadingMenu:             
	                         SetVideoMode

	;DrawLoadingScreen       black,yellow,cyan                                                            	;The next code snippet is ofr the delay
	                         MOV                     CX, 3fH
	                         MOV                     DX, 4240H
	                         MOV                     AH, 86H
	                         INT                     15H
	                         mov                     ah, 02h
	                         int                     1ah
	                         mov                     seed, dx
	ChooseLevel:             
	                         SetTextMode
	                         mov                     dx, 0000
	                         MoveCursor
	                         Displaystring           chooseLevelMsg
	                         mov                     dx, 0a0dh
	                         mov                     dl, 25d
	                         MoveCursor
	                         displaystring           level1Msg
	                         mov                     dx, 0c0dh
	                         mov                     dl, 25d
	                         MoveCursor
	                         DisplayString           level2Msg
	                         mov                     dl, 0
	                         mov                     dh, 22d
	                         MoveCursor
	                         Displaystring           notificationBar
	AgainTillKeyPressed2:                                                                                                         	;checking if a key is pressed on the main menu
	                         mov                     ah, 08h                                                                      	;these two line are used to flush the keyboard buffer
	                         int                     21h
	                         mov                     ah, 1
	                         int                     16h
	                         cmp                     al, scanF1                                                                   	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                         je                      SetLevel1
	                         cmp                     al, scanF2                                                                   	;comparing ah with the f2 scan code if equal go to game loading menu
	                         je                      SetLevel2
	                         jmp                     AgainTillKeyPressed2

	SetLevel1:               
	; Setting the initial location for each player.
	                         mov                     player1Initial, player1Lvl1Initial
	                         mov                     player2Initial, player2lvl1Initial
	                         mov                     borderColor, borderlvl1
	                         mov                     fillColor, filllvl1
	StartLevel1:             
	                         SetVideoMode
	                         DrawLevel1              player1Initial, player2Initial
	                         jmp                     AfterLevelSelect
	SetLevel2:               
	                         mov                     player1Initial, player1Lvl1Initial
	                         mov                     player2Initial, player2Lvl1Initial
	                         mov                     borderColor, white
	                         mov                     fillColor, filllvl2
	StartLevel2:             
	                         SetVideoMode
	                         mov                     cx, 480
	                         mov                     si, offset grid2
	                         rep                     movsb
	                         mov                     bx, player1Initial
	                         mov                     grid[bx], player1Code
	                         mov                     bx, player2Initial
	                         mov                     grid[bx], player2Code

	AfterLevelSelect:        
	                         mov                     si, @data
	                         DisplayTextVideoMode    10, 2, 1, scoreMessage1, 14                                                  	;Draw "Score#1"
	                         DisplayTextVideoMode    10, 24, 1, scoreMessage2, 14                                                 	;Draw "Score#2"
	                         DisplayTextVideoMode    10, 2, 23, livesMessage1, 14                                                 	;Draw "Lives#1"
	                         DisplayTextVideoMode    10, 24, 23, livesMessage2, 14                                                	;Draw "Lives#2"
	gameLoop:                
	                         mov                     dotcount, 0
	                         call                    AddPowerUp
	                         call                    MoveGhosts
	                         call                    MovePacman
	                         call                    DrawGrid
	                         call                    DrawScoreAndLives
	                         call                    IsFrozen
	                         call                    IsBigDot
	                         call                    IsGreenDot
	                         MOV                     CX, 1H                                                                       	; delay
	                         MOV                     DX, 4240H
	                         MOV                     AH, 86H
	                         INT                     15H
	                         xor                     isOpen, 1
	                         cmp                     isPlayer1Dead, 1
	                         je                      CheckPlayer2Lives
	                         cmp                     dotcount,0
	                         je                      EndGame
	                         cmp                     IsF4Pressed, 1
	                         je                      ApplyF4
	                         jmp                     gameLoop
	EndLoop:                 
	                         jmp                     EndLoop
	Terminate2:              
	                         mov                     ah, 4ch
	                         int                     21h
	CheckPlayer2Lives:       
	                         cmp                     isPlayer2Dead, 1
	                         je                      EndGame
	                         jmp                     gameLoop
	EndGame:                 
	                         SetTextMode
	                         mov                     dx, 0c0dh
	                         MoveCursor
	                         push                    bx
	                         mov                     bx, player2Score
	                         cmp                     player1Score, bx
	                         pop                     bx
	                         jg                      Player1Wins
	                         jmp                     Player2Wins
	Player1Wins:             
	                         DisplayString           player1WinsMsg
							 mov                     dx, 0d0dh
	                         MoveCursor
	                         DisplayString           player1Name+2
	AgainTillKeyPressed3:                                                                                                         	;checking if a key is pressed on the main menu
	                         mov                     ah, 08h                                                                      	;these two line are used to flush the keyboard buffer
	                         int                     21h
	                         mov                     ah, 1
	                         int                     16h
	                         cmp                     al, scanESC                                                                  	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                         je                      Terminate2
	                         jmp                     AgainTillKeyPressed3
	Player2Wins:             
	                         DisplayString           player2WinsMsg
							 mov                     dx, 0d0dh
	                         MoveCursor
	                         DisplayString           player2Name+2
	AgainTillKeyPressed4:                                                                                                         	;checking if a key is pressed on the main menu
	                         mov                     ah, 08h                                                                      	;these two line are used to flush the keyboard buffer
	                         int                     21h
	                         mov                     ah, 1
	                         int                     16h
	                         cmp                     al, scanESC                                                                  	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                         je                      Terminate2
	                         jmp                     AgainTillKeyPressed4
	ApplyF4:                 
	                         mov                     IsF4Pressed, 0
	                         SetTextMode
	                         mov                     dx, 0a0dh
	; mov                     dl, 25d
	                         MoveCursor
	                         Displaystring           player1Name+2
	                         mov                     dx, 0b0dh
	;mov                     dl, 23d
	                         MoveCursor
	                         Displaystring           scoreMessage1
	                         DisplayNumber           player1Score
	                         mov                     dx, 0e0dh
	;mov                     dl, 25d
	                         MoveCursor
	                         Displaystring           player2Name+2
	                         mov                     dx, 0f0dh
	;mov                     dl, 23d
	                         MoveCursor
	                         Displaystring           scoreMessage2
	                         DisplayNumber           player2Score

	                         MOV                     CX, 55H                                                                      	; delay
	                         MOV                     DX, 4240H
	                         MOV                     AH, 86H
	                         INT                     15H

	                         mov                     player1Lives, 3
	                         mov                     player2Lives, 3
	                         mov                     player1Score, 0
	                         mov                     player2score, 0
	                         mov                     player1IsBigDot, 0
	                         mov                     player1IsFrozen, 0
	                         mov                     player1IsGreenDot, 0
	                         mov                     player2IsBigDot, 0
	                         mov                     player2IsFrozen, 0
	                         mov                     player2IsGreenDot, 0
	                         mov                     ghostsIsFrozen, 0
	                         mov                     isPlayer1Dead,0
	                         mov                     isPlayer2Dead,0
	                         mov                     player1Respawn,0
	                         mov                     player2Respawn,0
	                         mov                     currentXPlayer1, 1
	                         mov                     currentYPlayer1, 1
	                         mov                     currentXPlayer2, 28
	                         mov                     currentYPlayer2, 14
	; mov                     cx, 480
	                         
	;mov                     si, offset zerogrid
	; rep                     movsb
	
	                         mov                     si,0
	emptyGrid:               
	                         mov                     grid[si],dotCode
	                         inc                     si
	                         cmp                     si , 481
	                         jl                      emptyGrid
	                         SetTextMode
	                         jmp                     MainMenu

main endp
end main