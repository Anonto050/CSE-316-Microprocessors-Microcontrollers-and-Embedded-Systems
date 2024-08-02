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
    ;Z = 2X-3Y
    ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    ;PROMPT 1
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


    ;PROMPT 2
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


    ;!2X-3Y
    SUB X, '0'
    SUB Y, '0'
     
    MOV AL, X
    MOV BL, 2
    MUL BL
    MOV CL, AL
    
    MOV BH, 3
    MOV AL, Y
    MUL BH
    
    SUB CL, AL 
    
    ;MOV AL, X
    ;ADD AL, X
    ;MOV BL, Y
    ;ADD BL, Y
    ;ADD BL, Y
    ;SUB AL, BL
    ;ADD AL, '0'

    ;OUTPUT 2X-3Y
    
    MOV AH, 2
    MOV DL, CL
    ADD DL, '0'
    INT 21H

    ;DOS EXIT
    MOV AH, 4CH   
    INT 21H

MAIN ENDP
END MAIN
    
    
    
    
    
