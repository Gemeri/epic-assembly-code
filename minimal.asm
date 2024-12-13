; minimal.asm
; A minimal 64-bit Windows Assembly program that exits immediately.

EXTERN ExitProcess : PROC
INCLUDELIB kernel32.lib

.CODE
PUBLIC main
main PROC
    MOV     RCX, 0           ; UINT uExitCode
    CALL    ExitProcess
main ENDP

END
