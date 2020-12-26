moveCursor macro position ;This macro moves the cursor to mthe given posiition
mov ah,2
mov dx,position
int 10h
ENDM moveCursor