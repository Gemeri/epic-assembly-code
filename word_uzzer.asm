extern ExitProcess : proc
extern WriteConsoleA : proc
extern ReadConsoleA : proc
extern GetStdHandle : proc

includelib kernel32.lib

.DATA
STD_INPUT_HANDLE  equ -10
STD_OUTPUT_HANDLE equ -11

prompt          db "Word: ", 0
promptLen       dd ($ - prompt)

uzzSuffix       db "uzz", 0
uzzLen          dd ($ - uzzSuffix)

huzzWord        db "huzz", 0
huzzLen         dd ($ - huzzWord)

newline         db 13, 10, 0
newlineLen      dd ($ - newline)

buffer          db 100 dup(0)
bytesRead       dd 0

specialWords    db "girl", 0, "girls", 0, "lady", 0, "ladies", 0, "woman", 0, "women", 0, 0

.DATA?
hStdOut         dq ?
hStdIn          dq ?

.CODE
PUBLIC main
main PROC
    mov     rcx, STD_OUTPUT_HANDLE
    call    GetStdHandle
    mov     hStdOut, rax

    mov     rcx, STD_INPUT_HANDLE
    call    GetStdHandle
    mov     hStdIn, rax

    mov     rcx, hStdOut
    lea     rdx, prompt
    mov     r8d, promptLen
    lea     r9, bytesRead
    xor     rax, rax
    push    rax
    call    WriteConsoleA
    add     rsp, 8

    mov     rcx, hStdIn
    lea     rdx, buffer
    mov     r8d, 100
    lea     r9, bytesRead
    xor     rax, rax
    push    rax
    call    ReadConsoleA
    add     rsp, 8

    lea     rax, buffer
    call    RemoveNewline

    lea     rbx, buffer
    lea     rsi, buffer
    call    ContainsSpace
    cmp     rax, 1
    je      ExitProgram

    call    IsSpecialWord
    cmp     rax, 1
    jne     NotSpecialWord

    lea     rdi, buffer
    lea     rsi, huzzWord
    call    StringCopy
    jmp     WriteOutput

NotSpecialWord:
    lea     rsi, buffer
    call    StringLength
    mov     rcx, rax
    cmp     rcx, 1
    jl      ExitProgram
    sub     rcx, 1
    lea     rdi, buffer
    add     rdi, rcx
    mov     byte ptr [rdi], 0

    lea     rdi, buffer
    call    StringLength
    add     rdi, rax
    lea     rsi, uzzSuffix
    xor     rax, rax
    push    rax
    call    StringCopy
    add     rsp, 8

WriteOutput:
    mov     rcx, hStdOut
    lea     rdx, buffer
    lea     rsi, buffer
    call    StringLength
    mov     r8d, eax
    lea     r9, bytesRead
    xor     rax, rax
    push    rax
    call    WriteConsoleA
    add     rsp, 8

    mov     rcx, hStdOut
    lea     rdx, newline
    mov     r8d, newlineLen
    lea     r9, bytesRead
    xor     rax, rax
    push    rax
    call    WriteConsoleA
    add     rsp, 8

ExitProgram:
    mov     rcx, 0
    call    ExitProcess

main ENDP

RemoveNewline PROC
    push    rbx
    mov     rbx, rax
RemoveLoop:
    mov     al, byte ptr [rbx]
    cmp     al, 0
    je      RemoveEnd
    cmp     al, 0Dh
    je      ReplaceNull
    cmp     al, 0Ah
    je      ReplaceNull
    inc     rbx
    jmp     RemoveLoop
ReplaceNull:
    mov     byte ptr [rbx], 0
    jmp     RemoveEnd
RemoveEnd:
    pop     rbx
    ret
RemoveNewline ENDP

ContainsSpace PROC
    push    rbx
    mov     rbx, rsi
CheckLoop:
    mov     al, byte ptr [rbx]
    cmp     al, 0
    je      NoSpace
    cmp     al, ' '
    je      SpaceFound
    inc     rbx
    jmp     CheckLoop
SpaceFound:
    mov     rax, 1
    pop     rbx
    ret
NoSpace:
    mov     rax, 0
    pop     rbx
    ret
ContainsSpace ENDP

StringLength PROC
    push    rbx
    mov     rbx, rsi
    xor     eax, eax
LengthLoop:
    cmp     byte ptr [rbx + rax], 0
    je      LengthEnd
    inc     eax
    jmp     LengthLoop
LengthEnd:
    pop     rbx
    ret
StringLength ENDP

StringCopy PROC
    push    rbx
    mov     rbx, rsi
CopyLoop:
    mov     al, byte ptr [rbx]
    mov     byte ptr [rdi], al
    inc     rbx
    inc     rdi
    cmp     al, 0
    jne     CopyLoop
    pop     rbx
    ret
StringCopy ENDP

IsSpecialWord PROC
    push    rbx
    lea     rbx, specialWords
CheckWordLoop:
    cmp     byte ptr [rbx], 0
    je      NoMatch
    lea     rsi, buffer
    lea     rdi, [rbx]
    call    StringCompare
    cmp     rax, 1
    je      MatchFound
FindNextWord:
    cmp     byte ptr [rbx], 0
    je      AfterNull
    inc     rbx
    jmp     FindNextWord
AfterNull:
    inc     rbx
    jmp     CheckWordLoop
MatchFound:
    mov     rax, 1
    pop     rbx
    ret
NoMatch:
    mov     rax, 0
    pop     rbx
    ret
IsSpecialWord ENDP

StringCompare PROC
    push    rbx
    push    rcx
CompareLoop:
    mov     al, byte ptr [rsi]
    mov     bl, byte ptr [rdi]
    cmp     al, bl
    jne     NotEqual
    cmp     al, 0
    je      Equal
    inc     rsi
    inc     rdi
    jmp     CompareLoop
NotEqual:
    mov     rax, 0
    jmp     CompareEnd
Equal:
    mov     rax, 1
CompareEnd:
    pop     rcx
    pop     rbx
    ret
StringCompare ENDP

END
