WaitDX macro dStep
local bigmeh
local smallmeh
        mov dx, dStep
    bigmeh:
        mov cx, 0ffffh
        smallmeh: loop smallmeh
        dec dx
        jnz bigmeh
    ret
endm WaitDX

DrawHorizontalLine macro color, count
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

DrawSquare macro xPosition, yPosition, sideLength, edgeColor, fillColor
local drawFill
    mov dx, yPosition
    mov cx, xPosition
    DrawHorizontalLine edgeColor, sideLength
    mov si, 8
    drawFill:
        inc dx
        mov cx, xPosition
        DrawHorizontalLine edgeColor, 1
        DrawHorizontalLine fillColor, sideLength-2
        ; add cx, gridStep-2
        DrawHorizontalLine edgeColor, 1
        dec si
        jnz drawFill
    inc dx
    mov cx, xPosition
    DrawHorizontalLine edgeColor, sideLength
endm DrawSquare

.model huge
.stack 256
.data
    black   equ 00h
    blue    equ 01h
    green   equ 02h
    red     equ 04h
    yellow  equ 0eh
    white   equ 0fh
    playerColor equ 0eh
    grid db 560 dup(?)
    gridStartX equ 10
    gridStartY equ 20
    gridStep equ 10
    gridXCount equ 30
    gridYCount equ 16
.code
main proc far
    mov ax, @data
    mov ds, ax
    mov ah, 0h
    mov al, 13h
    int 10h
    mov ch, gridYCount
    currentX dw gridStartX
    currentY dw gridStartY
    drawrow:
        mov currentX, gridStartX
        mov cl, gridXCount
        drawcell:
            push cx
            DrawSquare currentX, currentY, gridStep, blue, black
            pop cx
            add currentX, gridStep
            dec cl
            jnz drawcell
        add currentY, gridStep
        dec ch
        jnz drawrow
    endmeh: jmp endmeh
main endp
end main