DrawHorizontalLine macro color, count                                     		; put xPosition in cx, and yPosition in dx before calling
	                   local              DrawLoop
	                   mov                ah, 0ch
	                   mov                al, color
	                   mov                bx, count
	DrawLoop:          
	                   int                10h
	                   inc                cx
	                   dec                bx
	                   jnz                DrawLoop
	                   endm               DrawHorizontalLine


DrawSnowFlake  macro    xPosition,yPosition,backGcolor,color
    mov cx,xPosition
    mov dx,yPosition
    mov si,8
	;row1 and row 10
    DrawHorizontalLine backGcolor,9
    mov cx,xPosition
    add cx,4
    DrawHorizontalLine color,1
    mov cx,xPosition
    add dx,si
    DrawHorizontalLine backGcolor,9
    mov cx,xPosition
    add cx,4
    DrawHorizontalLine color,1
    sub si,2
    sub dx,si
    dec dx

    ;row 2 and row 9 
    mov cx,xPosition
    DrawHorizontalLine backGcolor,9
    mov cx,xPosition
    add cx,2
    DrawHorizontalLine color,1
    mov cx,xPosition 
    add cx,4
    DrawHorizontalLine color,1
    mov cx,xPosition
    add cx,6
    DrawHorizontalLine color,1
    mov cx,xPosition
    add dx,si
    DrawHorizontalLine backGcolor,9
     mov cx,xPosition
    add cx,2
    DrawHorizontalLine color,1
    mov cx,xPosition 
    add cx,4
    DrawHorizontalLine color,1
    mov cx,xPosition
    add cx,6
    DrawHorizontalLine color,1
    mov cx,xPosition
    sub si,2
    sub dx,si
    dec dx

    ;row 3 and row 8 
    mov cx,xPosition
    DrawHorizontalLine backGcolor,9
    mov cx,xPosition
    add cx,1
    DrawHorizontalLine color,2
    mov cx,xPosition
    add cx,4
    DrawHorizontalLine color,1
    mov cx,xPosition
    add cx,6
    DrawHorizontalLine color,2
    mov cx,xPosition
    add dx,si
    DrawHorizontalLine backGcolor,9
    mov cx,xPosition
    add cx,1
    DrawHorizontalLine color,2
    mov cx,xPosition
    add cx,4
    DrawHorizontalLine color,1
    mov cx,xPosition
    add cx,6
    DrawHorizontalLine color,2
     sub si,2
    sub dx,si
    dec dx

    ;row 4 and row 7
    mov cx,xPosition
    DrawHorizontalLine backGcolor,9
    mov cx,xPosition
    add cx,3
    DrawHorizontalLine color,3
    mov cx,xPosition
    add dx,si
     DrawHorizontalLine backGcolor,9
    mov cx,xPosition
    add cx,3
    DrawHorizontalLine color,3
    sub si,2
    sub dx,si
    dec dx
;row5
    mov cx,xPosition
    DrawHorizontalLine color,9
    mov cx,xPosition
    add cx,4

    
DrawHorizontalLine backGcolor,1
 endm DrawSnowFlake 
 SetVideoMode macro   ;320x200 pixel supporting 256 colors , 40x25 , (40 -> col - > x - > dl) , (25 -> row -> y -> dh)
		mov ah,0
		mov al,13h
		int 10h
endm SetVideoMode


.model small
.286
.stack 64
.data
	snowFlakeStartX dw  50
	snowFlakeStartY dw  50
	snowFlakeColor  dw  ?
	backGroundColor dw  ?
	lightCyan       equ 0bh
    black           equ 00
.code
main proc far
	     mov           ax,@data
	     mov           ds,ax
	     SetVideoMode
	     DrawSnowFlake snowFlakeStartX,snowFlakeStartY,black,lightCyan

	lbl: jmp           lbl

main endp
end main
