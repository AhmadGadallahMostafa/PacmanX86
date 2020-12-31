;usage 
;mov si,@data
;call macro
displayTextVideoMode macro lengthString,xPosition,yPosition,string,color			
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
endm displayTextVideoMode

.model small
.stack 64
.data
	msg     db "Hello World$"
	msg2    db "Kosom el Assembly$ "
	length1 db 17
	x       db 10
	y       db 5
    color db 14
.code
main proc far
	      mov                  ax,@data
	      mov                  ds,ax

	      mov                  al,13h
	      mov                  ah,0
	      int                  10h

	      mov                  si,@data         	;moves to si the location in memory of the data segment


	      displayTextVideoMode 17,26,20 ,msg2,13


	loop1:jmp                  loop1
         
main endp
end main


