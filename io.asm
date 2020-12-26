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

