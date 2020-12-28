.model medium
.stack 64
.data
.code
main proc far
    mov ax, @data
    mov ds, ax
    call testest
    hlt
main endp

testest proc
        mov ah, 0h
        mov al, 13h
        int 10h
        ret
testest endp
end main