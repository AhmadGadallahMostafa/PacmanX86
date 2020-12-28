;Authors : Ahmad Mostafa El Sayed
;         Muhab Hossam El Din
;         Mazen Amr
;         Youssef Shams

;	Start Date : 25/12/2020
;	Project Description : Simple PacMan game including two players competeing for the highest score

;Naming convention guidelines (PLEASE FOLLOW):
;	1-	Variables use camelCase
;	2-	Jumps and Macros use PascalCase

;------------------------------------------------------------------------------------------------------------------------------------------

;I/O MACROS

DisplayString macro str    ;this macro displays a string when given its memory variable name
		mov dx, offset str
		mov ah, 9h
		int 21h
endm DisplayString

;------------------------------------------------------------------------------------------------------------------------------------------

ReadString macro message , buffer    ;this macro displays a string promptmessage and reads a string and saves it in a buffer , when displaying usage : displasystring buffer +2
		DisplayString message
		mov ah, 0ah
		mov dx, offset buffer
		int 21h
endm ReadString

;------------------------------------------------------------------------------------------------------------------------------------------

DisplayChar macro    ;displays the character stored in dl
		mov ah, 2
		int 21h
endm DisplayChar

;------------------------------------------------------------------------------------------------------------------------------------------

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

;------------------------------------------------------------------------------------------------------------------------------------------

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

;------------------------------------------------------------------------------------------------------------------------------------------

;Generic macros:

MoveCursor macro    ;This macro moves the cursor to position set in dx
		mov ah,2
		int 10h
endm MoveCursor

;------------------------------------------------------------------------------------------------------------------------------------------

SetTextMode macro   ;80x25 16 color , 8 pages 
		mov ah,0
		mov al,03h
		int 10h
endm SetTextMode

;-------------------------------------------------------------------------------------------------------------------------------------------

SetVideoMode macro   ;320x200 pixel supporting 256 colors , 40x25 , (40 -> col - > x - > dl) , (25 -> row -> y -> dh)
		mov ah,0
		mov al,13h
		int 10h
endm SetVideoMode

;------------------------------------------------------------------------------------------------------------------------------------------

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
;------------------------------------------------------------------------------------------------------------------------------------------

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

;------------------------------------------------------------------------------------------------------------------------------------------

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

DrawPacman macro xPosition, yPosition, color
	
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
endm DrawPacman

;------------------------------------------------------------------------------------------------------------------------------------------

.model medium 
.stack 64
.data
	player1Name     db  15 , ? , 30 dup("$")                                                                	;variable holding player 1 name
	player2Name     db  15 , ? , 30 dup("$")                                                                	;variable holding player 2 name
	player1Color    equ 0eh                                                                                 	;yellow
	player2Color    equ 06h                                                                                 	;brown
	nameMessage     db  'Please Enter Your Name: $'                                                         	;Message displayed to prompt the user to enter his name
	enterMessage    db  'Press Enter to Continue$'
	welcomeMessage1 db  'Welcome To Our Game, Player 1!$'
	welcomeMessage2 db  'Welcome To Our Game, Player 2!$'
	warningMessage  db  '$$Please Enter a Valid Name!$'
	chattingInfo    db  '*To start chatting press F1$'
	gameStartInfo   db  '*To Start the Game press F2$'
	endgameInfo     db  '*To end the game press ESC$'
	notifactionBar  db  '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  $'
	welcomePosition dw  0h
	scoreMessage1   db  'Score #1: $'
	scoreMessage2   db  'Score #2: $'
	player1Score    dw  0h
	player2Score    dw  0h
	livesMessage1   db  'Lives #1: $'
	livesMessage2   db  'Lives #2: $'
	player1Lives    dw  3h
	player2lives    dw  3h
	scanF2          equ 3Ch                                                                                 	;Scan code for F2 - change to 00h if using emu8086 else keep 3Ch
	scanESC	        equ 1Bh	  ;Scan code for ESC - the same for emu8086 as vscode no need to change
.code
main proc far
	                    mov                    ax, @data
	                    mov                    ds, ax
	Player1:                                                                	;Reading first player name and saving it to player1name
	                    SetTextMode
	                    mov                    dx, 0000
	                    MoveCursor
	                    Displaystring          welcomeMessage1
	                    mov                    dx, 0d0dh
	                    mov                    dl,25d
	                    MoveCursor
	                    Displaystring          enterMessage
	                    mov                    dx, 0f0dh
	                    mov                    dl,23d
	                    MoveCursor
	                    Displaystring          warningMessage
	                    mov                    dx, 0a0dh
	                    mov                    dl,25d
	                    MoveCursor
	                    ReadString             nameMessage, player1Name
	                    ValidateName           player1Name
	                    cmp                    bl, 0
	                    je                     showWarning1
	                    jmp                    player2
	ShowWarning1:       
	                    lea                    si, warningMessage
	                    mov                    [si], 0
	                    jmp                    player1
	Player2:                                                                	;Reading second player name and saving it to player2name
	                    SetTextMode
	                    mov                    dx, 0000
	                    MoveCursor
	                    Displaystring          welcomeMessage2
	                    mov                    dx, 0d0dh
	                    mov                    dl,25d
	                    MoveCursor
	                    displaystring          enterMessage
	                    mov                    dx, 0f0dh
	                    mov                    dl,23d
	                    MoveCursor
	                    displaystring          warningMessage
	                    mov                    dx, 0A0dh
	                    mov                    dl,25d
	                    MoveCursor
	                    ReadString             nameMessage, player2Name
	                    ValidateName           player2name
	                    cmp                    bl, 0
	                    je                     showWarning2
	                    jmp                    mainMenu
	showWarning2:       
	                    lea                    si, warningMessage
	                    mov                    [si], 0
	                    jmp                    player2

	mainMenu:                                                               	;displaying main menu and provided functions and how to use them
	                    SetTextMode
	                    mov                    dx,080dh
	                    mov                    dl ,25d
	                    MoveCursor
	                    DisplayString          chattingInfo
	                    mov                    dx,0a0dh
	                    mov                    dl , 25d
	                    MoveCursor
	                    DisplayString          gameStartInfo
	                    mov                    dx,0c0dh
	                    mov                    dl,25d
	                    MoveCursor
	                    DisplayString          endgameInfo
	                    mov                    dl,0
	                    mov                    dh,22d
	                    MoveCursor
	                    Displaystring          notifactionBar
	againTillKeyPressed:                                                    	;checking if a key is pressed on the main menu
	                    mov                    ah,08h                       	;these two line are used to flush the keyboard buffer
	                    int                    21h
	                    mov                    ah,1
	                    int                    16h
	                    cmp                    al, scanESC                  	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                    je                     Terminate1
	                    cmp                    al, scanF2                   	;comparing ah with the f2 scan code if equal go to game loading menu
	                    je                     LoadingMenu
	                    jmp                    AgainTillKeyPressed

	Terminate1:         jmp                    Terminate2
	LoadingMenu:        SetTextMode                                         	;Just to ensure that the F2 check key is working is to later changed to the loading screen
	                    displaystring          welcomeMessage1
	                    SetVideoMode
	Temp:               
	                    mov                    si,@data
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
	                    DrawPacman             50,50,player1Color

	dummy:              jmp                    dummy
	Terminate2:         
	                    mov                    ah, 4ch
	                    int                    21h
main endp
end main
