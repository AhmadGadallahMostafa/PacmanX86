;Authors : Ahmad Mostafa El Sayed
;          Muhab Hossam El Din
;          Mazen Amr
;          Youssef Shams

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
        cmp ah, scanF1
        jz EndChat
        RemoveValueBuffer
        jmp CheckRecieved
BeginWriting:
           RemoveValueBuffer
           mov dl, 7
           mov dh, 15
           MoveCursor
		   DisplayString clearMessage
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
			; mov dl, 7
			; mov dh, 1
			; MoveCursor
			; displaystring clearMessage
			mov dl, 7
			mov dh, 1
			MoveCursor
			DisplayString MsgToReceive+2
			JMP CheckKey
EndChat:
	mov ah, 0
	int 16h
endm Chat