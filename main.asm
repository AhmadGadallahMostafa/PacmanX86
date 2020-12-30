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
; PACMAN
;---------------------------------------------------------------------------------------
DrawPacmanOpen macro xPosition, yPosition, playerColor, backgroundColor
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
endm DrawPacmanOpen

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
;Cherry
;---------------------------------------------------------------------------------------

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

;---------------------------------------------------------------------------------------
;LOADING SCREEN
;---------------------------------------------------------------------------------------
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
;---------------------------------------------------------------------------------------

.model huge
.386 
.stack 0ffffh
.data
	player1Name     db  15 , ? , 30 dup("$")                                                              	;variable holding player 1 name
	player2Name     db  15 , ? , 30 dup("$")                                                              	;variable holding player 2 name
	nameMessage     db  'Please Enter Your Name: $'                                                       	;Message displayed to prompt the user to enter his name
	enterMessage    db  'Press Enter to Continue$'
	welcomeMessage1 db  'Welcome To Our Game, Player 1!$'
	welcomeMessage2 db  'Welcome To Our Game, Player 2!$'
	warningMessage  db  '$$Please Enter a Valid Name!$'
	chattingInfo    db  '*To start chatting press F1$'
	gameStartInfo   db  '*To Start the Game press F2$'
	endgameInfo     db  '*To end the game press ESC$'
	notifactionBar  db  '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$'
	welcomePosition dw  0h
	scoreMessage1   db  'Score #1: $'
	scoreMessage2   db  'Score #2: $'
	player1Score    db  0h
	player2Score    dw  0h
	livesMessage1   db  'Lives #1: $'
	livesMessage2   db  'Lives #2: $'
	player1Lives    dw  3h
	player2lives    dw  3h
	scanF2          equ 3Ch                                                                               	;Scan code for F2 - change to 00h if using emu8086 else keep 3Ch
	scanESC         equ 1Bh
	grid            db  480 dup(0)
	black           equ 00h
	blue            equ 01h
	green           equ 02h
	cyan            equ 03h
	red             equ 04h
	magenta         equ 05h
	brown           equ 06h
	lightGray       equ 07h
	darkGray        equ 08h
	lightBlue       equ 09h
	lightGreen      equ 0ah
	lightCyan       equ 0bh
	lightRed        equ 0ch
	lightMagenta    equ 0dh
	yellow          equ 0eh
	white           equ 0fh
	player1Color    equ yellow
	player2Color    equ green
	borderColor     equ blue
	backgroundColor equ black
	ghostColor      equ lightMagenta
	gridStartX      equ 10
	gridStartY      equ 20
	gridStep        equ 10
	gridXCount      equ 30
	gridYCount      equ 16
.code
DrawGrid proc
	currentX            dw                     gridStartX
	currentY            dw                     gridStartY
	                    mov                    si, 0
	                    mov                    ch, gridYCount
	DrawRow:            
	                    mov                    currentX, gridStartX
	                    mov                    cl, gridXCount
	DrawCell:           
	                    push                   cx
	                    push                   si
	                    cmp                    grid[si], 0
	                    je                     Square
	                    cmp                    grid[si], 1
	                    je                     Player1
	                    cmp                    grid[si], 2
	                    je                     Player2
	                    cmp                    grid[si], 3
	                    je                     Ghost
	                    cmp                    grid[si], 4
	                    je                     Snowflake
	                    cmp                    grid[si], 5
	                    je                     Cherry
	ContinueDraw:       
	                    pop                    si
	                    pop                    cx
	                    add                    currentX, gridStep
	                    inc                    si
	                    dec                    cl
	                    jnz                    DrawCell
	                    add                    currentY, gridStep
	                    dec                    ch
	                    jnz                    DrawRow
	                    jmp                    EndDraw
	Square:             
	                    DrawSquare             currentX, currentY, gridStep, borderColor, backgroundColor
	                    jmp                    ContinueDraw
	Player1:            
	                    DrawPacmanOpen         currentX, currentY, player1Color, backgroundColor
	                    jmp                    ContinueDraw
	Player2:            
	                    DrawPacmanOpen         currentX, currentY, player2Color, backgroundColor
	                    jmp                    ContinueDraw
	Ghost:              
	                    DrawGhost              currentX, currentY, ghostColor, backgroundColor
	                    jmp                    ContinueDraw
	Snowflake:          DrawSnowflake          currentX, currentY, lightCyan, backgroundColor
	                    jmp                    ContinueDraw
	Cherry:             DrawCherry             currentX, currentY, green, red, backGroundColor
	                    jmp                    ContinueDraw
	EndDraw:            
	                    ret
DrawGrid endp
main proc far

	                    mov                    ax, @data
	                    mov                    ds, ax
	GetPlayer1Name:                                                                                      	;Reading first player name and saving it to player1name
	                    SetTextMode
	                    mov                    dx, 0000
	                    MoveCursor
	                    Displaystring          welcomeMessage1
	                    mov                    dx, 0d0dh
	                    mov                    dl, 25d
	                    MoveCursor
	                    Displaystring          enterMessage
	                    mov                    dx, 0f0dh
	                    mov                    dl, 23d
	                    MoveCursor
	                    Displaystring          warningMessage
	                    mov                    dx, 0a0dh
	                    mov                    dl, 25d
	                    MoveCursor
	                    ReadString             nameMessage, player1Name
	                    ValidateName           player1Name
	                    cmp                    bl, 0
	                    je                     showWarning1
	                    mov                    word ptr warningMessage, byte ptr '$$'
	                    jmp                    GetPlayer2Name
	ShowWarning1:       
	                    mov                    word ptr warningMessage, word ptr 0
	                    jmp                    GetPlayer1Name
	GetPlayer2Name:                                                                                      	;Reading second player name and saving it to player2name
	                    SetTextMode
	                    mov                    dx, 0000
	                    MoveCursor
	                    Displaystring          welcomeMessage2
	                    mov                    dx, 0d0dh
	                    mov                    dl, 25d
	                    MoveCursor
	                    displaystring          enterMessage
	                    mov                    dx, 0f0dh
	                    mov                    dl, 23d
	                    MoveCursor
	                    displaystring          warningMessage
	                    mov                    dx, 0A0dh
	                    mov                    dl, 25d
	                    MoveCursor
	                    ReadString             nameMessage, player2Name
	                    ValidateName           player2name
	                    cmp                    bl, 0
	                    je                     ShowWarning2
	                    jmp                    MainMenu
	ShowWarning2:       
	                    mov                    word ptr warningMessage, word ptr 0
	                    jmp                    GetPlayer2Name

	MainMenu:                                                                                            	;displaying main menu and provided functions and how to use them
	                    SetTextMode
	                    mov                    dx, 080dh
	                    mov                    dl, 25d
	                    MoveCursor
	                    DisplayString          chattingInfo
	                    mov                    dx, 0a0dh
	                    mov                    dl, 25d
	                    MoveCursor
	                    DisplayString          gameStartInfo
	                    mov                    dx, 0c0dh
	                    mov                    dl, 25d
	                    MoveCursor
	                    DisplayString          endgameInfo
	                    mov                    dl, 0
	                    mov                    dh, 22d
	                    MoveCursor
	                    Displaystring          notifactionBar
	AgainTillKeyPressed:                                                                                 	;checking if a key is pressed on the main menu
	                    mov                    ah, 08h                                                   	;these two line are used to flush the keyboard buffer
	                    int                    21h
	                    mov                    ah, 1
	                    int                    16h
	                    cmp                    al, scanESC                                               	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                    je                     Terminate1
	                    cmp                    al, scanF2                                                	;comparing ah with the f2 scan code if equal go to game loading menu
	                    je                     LoadingMenu
	                    jmp                    AgainTillKeyPressed

	Terminate1:         jmp                    Terminate2
	LoadingMenu:        
	                    SetVideoMode

	                    DrawLoadingScreen      black,yellow,cyan                                         	;The next code snippet is ofr the delay
	                    MOV                    CX, 3fH
	                    MOV                    DX, 4240H
	                    MOV                    AH, 86H
	                    INT                    15H
						
	                  
	Temp:               
	                    SetVideoMode
	                    mov                    si, @data
	                    DisplayTextVideoMode   10, 2, 1, scoreMessage1, 14
	                    DisplayTextVideoMode   10, 24, 1, scoreMessage2, 14
	                    DisplayTextVideoMode   10, 2, 23, livesMessage1, 14
	                    DisplayTextVideoMode   10, 24, 23, livesMessage2, 14
	DrawScores:         
	                    mov                    si,@data
	                    DisplayNumberVideoMode 15, 1, player1Score
	                    DisplayNumberVideoMode 37, 1, player2Score
	                    DisplayNumberVideoMode 12, 23, player1Lives
	                    DisplayNumberVideoMode 34, 23, player2Lives
	                    mov                    grid[32], 1
	                    mov                    grid[128], 2
	                    mov                    grid[256], 3
	                    mov                    grid[200], 3
	                    mov                    grid[400], 3
	                    mov                    grid[50], 4
	                    mov                    grid[390], 4
	                    mov                    grid[280], 4
	                    mov                    grid[18], 4
	                    mov                    grid[200],5
	                    call                   DrawGrid
	EndLoop:            jmp                    EndLoop
	Terminate2:         
	                    mov                    ah, 4ch
	                    int                    21h
main endp
end main
