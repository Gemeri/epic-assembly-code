; greet_user.asm
; A 64-bit Windows Assembly program that asks for the user's name and greets them.

EXTERN ExitProcess : PROC
EXTERN WriteConsoleA : PROC
EXTERN ReadConsoleA : PROC
EXTERN GetStdHandle : PROC

INCLUDELIB kernel32.lib

.DATA
    ; Standard Handles
    STD_INPUT_HANDLE  EQU -10
    STD_OUTPUT_HANDLE EQU -11

    ; Prompt and greeting strings
    prompt     BYTE "What's your name? ", 0
    promptLen  DWORD ($ - prompt)

    helloStr   BYTE "Hello, ", 0
    helloLen   DWORD ($ - helloStr)

    newline    BYTE 13, 10, 0          ; CRLF
    newlineLen DWORD ($ - newline)

    ; Buffer for user input
    buffer     BYTE 100 DUP(0)         ; 100-byte buffer for the name
    bytesRead  DWORD 0                 ; To store number of bytes read

.DATA?
    hStdOut    QWORD ?                 ; Handle for standard output
    hStdIn     QWORD ?                 ; Handle for standard input

.CODE
PUBLIC main
main PROC
    ; Get handle for standard output
    MOV     RCX, STD_OUTPUT_HANDLE
    CALL    GetStdHandle
    MOV     hStdOut, RAX

    ; Get handle for standard input
    MOV     RCX, STD_INPUT_HANDLE
    CALL    GetStdHandle
    MOV     hStdIn, RAX

    ; Write the prompt to the console
    MOV     RCX, hStdOut             ; HANDLE hConsoleOutput
    LEA     RDX, prompt              ; LPCVOID lpBuffer
    MOV     R8D, promptLen           ; DWORD nNumberOfCharsToWrite
    LEA     R9, bytesRead            ; LPDWORD lpNumberOfCharsWritten
    CALL    WriteConsoleA

    ; Read user input
    MOV     RCX, hStdIn              ; HANDLE hConsoleInput
    LEA     RDX, buffer              ; LPVOID lpBuffer
    MOV     R8D, 100                 ; DWORD nNumberOfCharsToRead
    LEA     R9, bytesRead            ; LPDWORD lpNumberOfCharsRead
    CALL    ReadConsoleA

    ; Remove the newline characters from input
    LEA     RAX, buffer
    CALL    RemoveNewline

    MOV     RCX, hStdOut             ; HANDLE hConsoleOutput
    LEA     RDX, helloStr            ; LPCVOID lpBuffer
    MOV     R8D, helloLen            ; DWORD nNumberOfCharsToWrite
    LEA     R9, bytesRead            ; LPDWORD lpNumberOfCharsWritten
    CALL    WriteConsoleA

    MOV     RCX, hStdOut             ; HANDLE hConsoleOutput
    LEA     RDX, buffer              ; LPCVOID lpBuffer
    MOV     R8D, 100                 ; DWORD nNumberOfCharsToWrite
    LEA     R9, bytesRead            ; LPDWORD lpNumberOfCharsWritten
    CALL    WriteConsoleA

    MOV     RCX, hStdOut             ; HANDLE hConsoleOutput
    LEA     RDX, newline             ; LPCVOID lpBuffer
    MOV     R8D, newlineLen          ; DWORD nNumberOfCharsToWrite
    LEA     R9, bytesRead            ; LPDWORD lpNumberOfCharsWritten
    CALL    WriteConsoleA

    ; Exit the process
    MOV     RCX, 0                   ; UINT uExitCode
    CALL    ExitProcess
main ENDP

RemoveNewline PROC
    PUSH    RBX
    MOV     RBX, RAX                ; Pointer to buffer

RemoveLoop:
    MOV     AL, BYTE PTR [RBX]
    CMP     AL, 0
    JE      RemoveEnd
    CMP     AL, 0Dh                ; '\r'
    JE      ReplaceNull
    CMP     AL, 0Ah                ; '\n'
    JE      ReplaceNull
    INC     RBX
    JMP     RemoveLoop

ReplaceNull:
    MOV     BYTE PTR [RBX], 0
    JMP     RemoveEnd

RemoveEnd:
    POP     RBX
    RET
RemoveNewline ENDP

END
