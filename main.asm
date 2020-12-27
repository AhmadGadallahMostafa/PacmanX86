;Authors : Ahmad Mostafa El Sayed
;         Muhab Hossam El Din
;         Mazen Amr
;         Youssef Shams

;Start Date : 25/12/2020
;Project Description : Simple PacMan game including two players competeing for the highest score

;------------------------------------------------------------------------------------------------------------------------------------------

;I/O MACROS

DisplayString macro str    ;this macro displays a string when given its memory variable name
		mov dx, offset str
		mov ah, 9h
		int 21h
endm displaystring

;------------------------------------------------------------------------------------------------------------------------------------------

ReadString macro message , buffer    ;this macro displays a string promptmessage and reads a string and saves it in a buffer , when displaying usage : displasystring buffer +2
		DisplayString message
		mov ah, 0ah
		mov dx, offset buffer
		int 21h
endm ReadString

;------------------------------------------------------------------------------------------------------------------------------------------

DisplayChar macro    ;displays the charchter stored in Al
		mov ah, 2
		int 21h
endm DisplayChar

;------------------------------------------------------------------------------------------------------------------------------------------

DisplayNumber macro number    ;displayes the number saved in memoory variable x max size : 65535
		mov si, offset number
		mov ax, [si]
		mov bx, 10d
		mov cx, 0
	divison:
		mov bx, 10d
		cwd
		mov dx, 0
		div bx
		push dx
		inc cx
		cmp ax, 0
		jnz divison
	display:
		pop dx
		add dx, 48d
		DisplayChar
		loop display
endm DisplayNumber

;------------------------------------------------------------------------------------------------------------------------------------------

ReadNumber macro promptmes, buffer    ; reads two digit numbers from user :number moved to ax
		ReadString mes, buffer
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

SetvideoMode macro   
		mov ah,0
		mov al,13h
		int 10h
endm SetvideoMode

;------------------------------------------------------------------------------------------------------------------------------------------

ValidateName macro name    ;valdiating that the first char of the letter is a alphabatical charchter
		local confrimInvalid
		local invalid
		local valid 
		local terminate
		lea si, name+2
		mov bl, [si]
		cmp bl, 'A'
		jb invalid
		cmp bl, 'z'
		ja invalid
		cmp bl, 'Z'
		ja confrimInvalid
		jmp valid
	confrimInvalid:
		cmp bl, 'a'
		jb invalid
		jmp valid
	invalid:
		mov bl, 0
		jmp terminate
	valid:
		mov bl, 1
	terminate:
endm ValidateName

;------------------------------------------------------------------------------------------------------------------------------------------

.model medium 
.stack 64

.data
	player1Name     db 15 , ? , 30 dup("$")                                                                	;variable holding player 1 name
	player2Name     db 15 , ? , 30 dup("$")                                                                	;variable holding player 2 name
	nameMessage     db 'Please Enter Your Name: $'                                                         	;Message displayed to prompt the user to enter his name
	enterMessage    db 'Press Enter to Continue$'
	welcomeMessage1 db 'Welcome To Our Game, Player 1!$'
	welcomeMessage2 db 'Welcome To Our Game, Player 2!$'
	warningMessage  db '$$Please Enter a Valid Name!$'
	chattingInfo    db '*To start chatting press F1$'
	gameStartInfo   db '*To Start the Game press F2$'
	endgameInfo     db '*to end the game press ESC$'
	notifactionBar  db '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  $'
	welcomePosition dw 0h
	scoreMessage1	db 'Score #1: $'
	scoreMessage2	db 'Score #2: $'
	player1Score	db 0h
	player2Score	db 0h
	livesMessage1	db 'Lives #1: $'
	livesMessage2	db 'Lives #2: $'
	player1Lives	db 3h
	player2lives	db 3h
.code
main proc far
	                    mov           ax, @data
	                    mov           ds, ax
	player1:                                                 	;Reading first player name and saving it to player1name
	                    SetTextMode
	                    mov           dx, 0000
	                    MoveCursor
	                    displaystring welcomeMessage1
	                    mov           dx, 0d0dh
	                    mov           dl,25d
	                    MoveCursor
	                    displaystring enterMessage
	                    mov           dx, 0f0dh
	                    mov           dl,23d
	                    MoveCursor
	                    displaystring warningMessage
	                    mov           dx, 0a0dh
	                    mov           dl,25d
	                    MoveCursor
	                    ReadString    nameMessage,player1Name
	                    ValidateName  player1Name
	                    cmp           bl, 0
	                    je            showWarning1
	                    jmp           player2
	showWarning1:       
	                    lea           si, warningMessage
	                    mov           [si], 0
	                    jmp           player1
	player2:                                                 	;Reading second player name and saving it to player2name
	                    SetTextMode
	                    mov           dx, 0000
	                    MoveCursor
	                    displaystring welcomeMessage2
	                    mov           dx, 0d0dh
	                    mov           dl,25d
	                    MoveCursor
	                    displaystring enterMessage
	                    mov           dx, 0f0dh
	                    mov           dl,23d
	                    MoveCursor
	                    displaystring warningMessage
	                    mov           dx, 0A0dh
	                    mov           dl,25d
	                    MoveCursor
	                    ReadString    nameMessage,player2Name
	                    ValidateName  player2name
	                    cmp           bl, 0
	                    je            showWarning2
	                    jmp           mainMenu
	showWarning2:       
	                    lea           si, warningMessage
	                    mov           [si], 0
	                    jmp           player2
	
	mainMenu:                                                	;displaying main menu and provided functions and how to use them
	                    SetTextMode
	                    mov           dx,080dh
	                    mov           dl ,25d
	                    MoveCursor
	                    displaystring chattingInfo
	                    mov           dx,0a0dh
	                    mov           dl , 25d
	                    MoveCursor
	                    DisplayString gameStartInfo
	                    mov           dx,0c0dh
	                    mov           dl,25d
	                    MoveCursor
	                    DisplayString endgameInfo
	                    mov           dl,0
	                    mov           dh,22d
	                    MoveCursor
	                    displaystring notifactionBar
	againTillKeyPressed:                                     	;checking if a key is pressed on the main menu
	                    mov           ah,08h                 	;these two line are used to flush the keyboard buffer
	                    int           21h
	                    mov           ah,1
	                    int           16h
	                    cmp           al,1bh                 	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                    je            terminate
	                    cmp           al,00h                 	;comparing ah with the f2 scan code if equal go to game loading menu
	                    je            loadingMenu
	                    jmp           againTillKeyPressed
	
	loadingMenu:        SetTextMode                          	;Just to ensure that the F2 check key is working is to later changed to the loading screen
	                    displaystring welcomeMessage1
						SetVideoMode
	temp:				
						mov dx,2
						movecursor 
						displaystring	ScoreMessage1
						mov dx,20
						movecursor
						displaystring	ScoreMessage2
						mov dl,2
						mov dh,70
						movecursor
						displaystring   LivesMessage1
						mov dl,15
						mov dh,50
						movecursor
						displaystring	LivesMessage2
	dummy:				jmp           dummy

	terminate:          
	                    mov           ah, 4ch
	                    int           21h
main endp
end main
