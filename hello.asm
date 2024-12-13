extrn printf : proc
extrn exit   : proc

.data
msg db "Hello world",0

.code
public main
main proc
    sub     rsp, 40

    lea     rcx, msg
    call    printf

    xor     ecx, ecx
    call    exit

    add     rsp, 40
    ret
main endp
end