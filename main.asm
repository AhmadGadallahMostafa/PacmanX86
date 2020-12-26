;Owners : Ahmad Mostafa El Sayed 
;         Muhab Hossam El Din
;         Mazen Amr 
;         Youssef Shams 

;start Date : 25/12/2020
;Project Description : Simple pac man game including two players competeing for the highest score
;-------------------------------------------------------------------------------------------------------------------------------------

;I/O MACROS 
DisplayString MACRO STR   ;this macro displays a string when given its memory variable name
	    mov dx , offset STR
	    mov ah, 9h
	    int 21h      
ENDM displaystring
;--------------------------------------------------------------------------------------------------------------------------------------------------

READSTRING MACRO PROMPTMESSAGE , buffer    ;This macro displays a string promptmessage and reads a string and saves it in a buffer , when displaying usage : displasystring buffer +2
		DisplayString PROMPTMESSAGE
		mov ah,0ah
		mov dx, offset buffer 
		int 21h
endm READSTRING
;--------------------------------------------------------------------------------------------------------------------------------------------------

displayChar MACRO    ;displays the charchter stored in Al
		mov ah ,2
		int 21h
endm displayChar
;--------------------------------------------------------------------------------------------------------------------------------------------------

displaynumber macro x				;displayes the number saved in memoory variable x max size : 65535
	    mov si,offset x
	    mov ax,[si]
	    mov bx,10d
	    mov cx,0
	divison1:      
	    mov bx,0Ah
        cwd
        mov dx,0
	    div bx
	    push dx
	    inc cx
	    cmp ax,0
	    jnz divison1
	display:      
	    pop dx
	    add dx,48d
	    displaychar
	    loop display
endm displaynumber
;--------------------------------------------------------------------------------------------------------------------------------------------------

readnumber macro promptmes,buffer    ; reads two digit numbers from user :number moved to ax
    
READSTRING mes,buffer 
	    mov al,buffer+2
	    mov bl,buffer+3 
	    sub al,48d
	    sub bl,48d   
	    mov ah,0
	    mov bh,0 
	    mov dx,10d 
	    mul dx
	    add ax,bx 
endm readnumber
;--------------------------------------------------------------------------------------------------------------------------------------------------
;Generic macros:
moveCursor macro  ;This macro moves the cursor to position set in dx
mov ah,2
int 10h
ENDM moveCursor

setTextMode macro
mov            ah,0                          	
mov            al,03h
int            10h
endm setTextMode
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------
validateName macro name                                    		;valdiating that the first char of the letter is a alphabatical charchter
				    local confrimInvalid
					local invalid
					local valid 
					local terminate
	                lea           si,name+2
					mov bl,[si]
	                cmp           bl , 'A'
					jb invalid
	                cmp           bl,'z'
	                ja           invalid
	                cmp           bl , 'Z'
	                ja            confrimInvalid
	                jmp           valid
	 confrimInvalid: 
	                cmp           bl , 'a'
	                jb            invalid
	                jmp           valid
	 invalid:       mov           bl,0  
	 jmp terminate	                
	 valid:          
	 mov           bl,1    
	 terminate : 
endm validateName
;-------------------------------------------------------------------------------------------------------------------------------------------------------

 .model medium 
 .stack 64
.data
	player1Name db 15 , ? , 30 dup("$")            	;variable holding player 1 name
	player2Name db 15 , ? , 30 dup("$")            	;variable holding player 2 name
	nameMsg     db 'Please Enter Your Name : ', "$"	;Message displayed to prompt the user to enter his name
	enterMsg    db 'Press Enter to Continue $'
	welcomeMsg1 db 'Welcome To our Game Player 1$'
	welcomeMsg2 db 'Welcome To our Game Player 2$'
	wariningMSg db '$$Please Enter a valid name $'
	welcomePosition dw 0h                                  
.code
main proc far
	                mov           ax,@data
	                mov           ds,ax
	                setTextMode
	;Reading first player name and saving it to player1name
	player1:        
	                setTextMode
	                mov           dx,0000
	                moveCursor
	                displaystring welcomeMsg1
	                mov           dx,0d0dh
	                moveCursor
	                displaystring enterMsg
	                mov           dx,0e0dh
	                moveCursor
	                displaystring wariningMSg
	                mov           dx,0A0dh
	                moveCursor
	                READSTRING    nameMsg,player1Name
	                validateName  player1Name
	                cmp           bl ,0
	                je            wariningmsglbl1
	                jmp           player2
	wariningmsglbl1:
	                lea           si , wariningMSg
	                mov           [si],0
	                jmp           player1

	;Reading second player name and saving it to player2name
	player2:        setTextMode                      	;resetting the screen
	                mov           dx,0000
	                moveCursor
	                displaystring welcomeMsg2
	                mov           dx,0d0dh
	                moveCursor
	                displaystring enterMsg
	                mov           dx,0e0dh
	                moveCursor
	                displaystring wariningMSg
	                mov           dx,0A0dh
	                moveCursor
	                READSTRING    nameMsg,player2Name
	                validateName  player2name
	                cmp           bl,0
	                je            wariningmsglbl2
	                jmp           nextScreen
	wariningmsglbl2:
	                lea           si , wariningMSg
	                mov           [si],0
	                jmp           player2

	nextScreen:     setTextMode
	terminate:      
	                mov           ah, 4ch
	                int           21h
main endp
end main
