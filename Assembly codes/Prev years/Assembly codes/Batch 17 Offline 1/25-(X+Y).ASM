.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH
LF EQU 0AH

PRX DB "ENTER X : $"
PRY DB "ENTER Y : $"

X DB ?
Y DB ?

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

    ;PROMPT Y
    LEA DX, PRY
    MOV AH, 9H
    INT 21H

    ;INPUT Y
    MOV AH, 1
    INT 21H
    MOV Y, AL

    ;NEWLINE 
    MOV DL, CR
    MOV AH, 2
    INT 21H   
    MOV DL, LF
    MOV AH, 2
    INT 21H


    ;!Y-X+1
    SUB X, '0'
    MOV AL, X
    SUB Y, AL 
    ADD Y, 1

    ;OUTPUT
    MOV DL, Y
    MOV AH, 2
    INT 21H

    ;DOS EXIT
    MOV AH, 4CH   
    INT 21H

MAIN ENDP
END MAIN
    
    
    
    
    
