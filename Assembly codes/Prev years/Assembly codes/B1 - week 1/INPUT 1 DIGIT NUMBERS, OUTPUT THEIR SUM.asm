.MODEL SMALL

.STACK 100H

.DATA
CR EQU 0DH
LF EQU 0AH

PR1 DB 'INPUT FIRST DIGIT : $'    
PR2 DB 'INPUT SECOND DIGIT : $'
OT DB 'OUTPUT : $'        

X DB ?  
Y DB ?
   
   
   
.CODE

MAIN PROC
    ;SUM OF 2 ONE DIGIT NUMBER, Z = X+Y
    ;X, Y, Z ARE ALL ONE DIGIT
    ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
                 
    ;PROMT FOR FIRST NUMBER
    LEA DX, PR1
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
      
    ;PROMT FOR SECOND NUMBER
    LEA DX, PR2
    MOV AH, 9H
    INT 21H
           
    ;INPUT Y
    MOV AH, 1
    INT 21H
    MOV Y, AL
                  
         
    ; X+Y-'0' 
    SUB Y, '0'
    MOV BH, X
    ADD BH, Y
    MOV X, BH
       
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