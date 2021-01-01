.model small
.stack 64
.code
main proc far
	lbl:  
	     mov ah,0
	     int 16h
	     jmp lbl
main endp 
end main