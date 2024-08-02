.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH
LF EQU 0AH

PRX DB "ENTER X : $"

X DB ?

.CODE

MAIN PROC
    ;Z = Y-X+1
    ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    ;PROMPT X
    LEA DX, PRX
    MOV AH, 9H
    INT 21H

    ;INPUT X
    MOV AH, 1
    INT 21H
    MOV X, AL

    ;NEWLINE 
    MOV DL, CR
    MOV AH, 2
    INT 21H   
    MOV DL, LF
    MOV AH, 2
    INT 21H

    ;!1's complement for 8 bits
    ;MOV BL, 255
    ;SUB BL, X
    NOT X 

    ;OUTPUT
    MOV DL,X
    MOV AH, 2
    INT 21H

    ;DOS EXIT
    MOV AH, 4CH   
    INT 21H

MAIN ENDP
END MAIN