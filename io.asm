DisplayString MACRO STR
	              mov dx , offset STR
	              mov ah, 9h
	              int 21h
	              
ENDM displaystring

READSTRING MACRO PROMPTMESSAGE , buffer
			DisplayString PROMPTMESSAGE
			mov ah,0ah
			mov dx, offset buffer 
			int 21h
 endm READSTRING

displayChar MACRO
		mov ah ,2
		int 21h
endm displayChar

displaynumber macro x
	              mov         si , offset x
	              mov         ax , [si]
	              mov         bx , 10d
	              mov         cx ,0
	diison1:      
	              mov         bx,0Ah
	              cwd
				  mov dx,0
	              div         bx
	              push        dx
	              inc         cx
	              cmp         ax,0
	              jnz         diison1
    
	display:      
	              pop         dx
	              add         dx,48d
	              displaychar
	              loop        display
    endm displaynumber
    
readnumber macro promptmes,buffer    ;number moved to ax
    
READSTRING mes,buffer 
	    mov al ,  buffer+2
	    mov bl , buffer+3 
	    sub al, 48d
	    sub bl,48d   
	    mov ah,0
	    mov bh,0 
	    mov dx,10d 
	    mul dx
	    add ax,bx 

endm readnumber


