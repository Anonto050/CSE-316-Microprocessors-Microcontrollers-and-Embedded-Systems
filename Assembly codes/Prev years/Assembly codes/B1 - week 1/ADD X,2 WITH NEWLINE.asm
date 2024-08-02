.MODEL SMALL

.STACK 100H

.DATA
CR EQU 0DH
LF EQU 0AH

HW DB 'Hello, World!!!$'         

X DB ?

.CODE

MAIN PROC
    ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
                 
    ;GREET
    LEA DX, HW
    MOV AH, 9H
    INT 21H    
          
    ;NEWLINE 
    MOV DL, CR
    MOV AH, 2
    INT 21H   
    MOV DL, LF
    MOV AH, 2
    INT 21H
    
    ;INPUT X
    MOV AH, 1
    INT 21H
    MOV X, AL
    
    ;X = X+2
    ADD X, 2
                  
            
    ;NEWLINE 
    MOV DL, CR
    MOV AH, 2
    INT 21H   
    MOV DL, LF
    MOV AH, 2
    INT 21H
    
    
    ;OUPUT UPDATED VALUE OF X
    MOV DL, X
    MOV AH, 2
    INT 21H
                 
    ;DOS EXIT
    MOV AH, 4CH   
    INT 21H

MAIN ENDP
END MAIN