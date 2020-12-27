.model small
.stack 64
.code
main proc far
	lbl:  
	  mov           ah,08h                 	;these two line are used to flush the keyboard buffer
	                    int           21h
	     mov ah,0
	     int 16h
	     jmp lbl
main endp 
end main