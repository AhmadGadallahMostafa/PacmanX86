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

.model small
.stack 64
.data
	ghostXStart dw 50
ghostYStart dw 20
.CODE

main proc FAR
	     mov                ax,@data
	     mov                ds,ax
	;row1
	     mov                ah,0
	     mov                al,13h
	     int                10h

	     mov                cx,50
	     mov                dx,20
	     DrawHorizontalLine 1,2

	     inc                dx
	     mov                cx,ghostXStart
	     dec                cx
	     DrawHorizontalLine 1 ,4

	     inc                dx
	     mov                cx,ghostXStart
	     sub                cx,2
	     DrawHorizontalLine 1 ,6

	     inc                dx
	     mov                cx,ghostXStart
	     sub                cx,3
	     DrawHorizontalLine 1 , 8

	     inc                dx
	     mov                cx,ghostXStart
	     sub                cx,3
	     DrawHorizontalLine 1 ,8

	     inc                dx
	     mov                cx,ghostXStart
	     sub                cx,3
	     DrawHorizontalLine 1 ,8

	     inc                dx
	     mov                cx,ghostXStart
	     sub                cx,3
	     DrawHorizontalLine 1 ,8

	     inc                dx
	     mov                cx,ghostXStart
	     sub                cx,3
	     DrawHorizontalLine 1 ,8

	     inc                dx
	     mov                cx,ghostXStart
	     sub                cx,3
	     DrawHorizontalLine 1,2

	     add                cx,4
	     DrawHorizontalLine 1,2

	     mov                cx,50
	     DrawHorizontalLine 1,2

	     inc                dx
	     mov                cx,50
	     DrawHorizontalLine 1,2

	     mov                cx ,ghostXStart
	     sub                cx,3
	     DrawHorizontalLine 1,1

	     mov                cx ,ghostXStart
	     add                cx,4
	     DrawHorizontalLine 1,1

	;eyes:
	     mov                dx,24
	     mov                cx





	lbl: jmp                lbl


	     
	     

main endp
end main