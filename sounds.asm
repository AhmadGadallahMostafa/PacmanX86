HitNote Macro Frequency,Length 
    local pause1
    local pause2
		push ax
		push bx
		push cx
		push dx
			mov al,182          ;Prepare the speaker for the note
			out 43h,al          
			mov ax,Frequency    ; Frequency number (in decimal)
			
			out 42h,al          ; Output low byte.
			mov al,ah
			out 42h,al          ; Output high byte.
			in al,61h           ;Turn on note (get value from port 61h).
			
			or al,00000011b     ; Set bits 1 and 0.
            out     61h, al     ; Send new value.
            mov     bx, Length      ; Pause for duration of note.
		pause1:
			mov cx,2935
		pause2:
			dec cx
			jne pause2
			dec bx
			jne pause1
			in al,61h
			
			and al,11111100b
			out 61h,al 
			
		pop dx
		pop cx
		pop bx
		pop ax
		
Endm	HitNote



.286
.model small
.stack 64
.data
	startx dw 10
	starty dw 10
	step   dw 10
	Frequencies dw 7239,7239,7239,7239,7239,7239, 7239 , 6087,9121,8126,7239 ,6833,6833,6833,6833,6833,7239 ,7239 ,7239 ,7239,8126,8126,7239,8126,6087,7239,7239,7239 ,7239,7239,7239,7239,6087,9121,8126,7239,6833,6833,6833,6833,6833,7239,7239,7239,6087,6087,6833,8126,9121
.code
main proc far
	
	        mov     ax,@data
	        mov     ds,ax
	        mov     si,0
	dummy:  HitNote Frequencies[si],80
	        add     si,2
	        cmp     si,102
	        jz      resetsi
	        jmp     dummy

	resetsi:mov     si,0
	        jmp     dummy


main endp
end main