.MODEL SMALL

.STACK 100H

.DATA
CR EQU 0DH
LF EQU 0AH

PR DB 'INPUT A CAPITAL LETTER :$'
OT DB 'OUTPUT :$'        

X DB ?

.CODE

MAIN PROC
    ;INPUT IS AN UPPERCASE LETTER. 
    ;OUTPUT SHOULD BE THE PREVIOUS CHARACTER OF INPUT, BUT IN LOWERCASE
    
    ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
                 
    ;PROMT FOR CAPITAL LETTER
    LEA DX, PR
    MOV AH, 9H
    INT 21H    
          
    
    ;INPUT X
    MOV AH, 1
    INT 21H
    MOV X, AL
    
    ;X = X+31
    ADD X, 31
                  
            
    ;NEWLINE 
    MOV DL, CR
    MOV AH, 2
    INT 21H   
    MOV DL, LF
    MOV AH, 2
    INT 21H
             
    ;OUTPUT TEXT
    LEA DX, OT
    MOV AH, 9H
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