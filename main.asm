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

SetTextMode macro
		mov ah,0
		mov al,03h
		int 10h
endm SetTextMode

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
	player1Name		db 15 , ? , 30 dup("$")			;variable holding player 1 name
	player2Name		db 15 , ? , 30 dup("$")			;variable holding player 2 name
	nameMessage		db 'Please Enter Your Name: $'	;Message displayed to prompt the user to enter his name
	enterMessage	db 'Press Enter to Continue$'
	welcomeMessage1	db 'Welcome To Our Game, Player 1!$'
	welcomeMessage2	db 'Welcome To Our Game, Player 2!$'
	warningMessage	db '$$Please Enter a Valid Name!$'
	welcomePosition	dw 0h

.code
main proc far
		mov ax, @data
		mov ds, ax
	player1:    ;Reading first player name and saving it to player1name
		SetTextMode
		mov dx, 0000
		MoveCursor
		displaystring welcomeMessage1
		mov dx, 0d0dh
		MoveCursor
		displaystring enterMessage
		mov dx, 0e0dh
		MoveCursor
		displaystring warningMessage
		mov dx, 0A0dh
		MoveCursor
		ReadString nameMessage,player1Name
		ValidateName player1Name
		cmp bl, 0
		je showWarning1
		jmp player2
	showWarning1:
		lea si, warningMessage
		mov [si], 0
		jmp player1
	player2:    ;Reading second player name and saving it to player2name
		SetTextMode
		mov dx, 0000
		MoveCursor
		displaystring welcomeMessage2
		mov dx, 0d0dh
		MoveCursor
		displaystring enterMessage
		mov dx, 0e0dh
		MoveCursor
		displaystring warningMessage
		mov dx, 0A0dh
		MoveCursor
		ReadString nameMessage,player2Name
		ValidateName player2name
		cmp bl, 0
		je showWarning2
		jmp nextScreen
	showWarning2:
		lea si, warningMessage
		mov [si], 0
		jmp player2
	nextScreen:
		SetTextMode

	terminate:
		mov ah, 4ch
		int 21h
main endp
end main
