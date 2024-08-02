.MODEL SMALL 
.STACK 100H 
.DATA

X DB 3H 
C DB 1H
 
CR EQU 0DH
LF EQU 0AH

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    ; fast BX = 0
    XOR BX, BX
    XOR CX, CX   
    
    MOV BL,X
    
    INPUT:
      MOV AH,1
      INT 21H  
      
      CMP AL, CR
      JE CALC
      
      CMP AL, LF
      JE CALC
      CMP AL, '0'
      JNGE INPUT
      CMP AL, '2'
      JNLE INPUT  
      
      
      
      
      MOV BL,C 
      MUL BL 
      SUB AL,'0'  
      
      MOV BL, AL
      
      MOV DL, X
      MOV AL, CL
      MUL DL
      
      
      ADD BL,AL
      MOV CL,BL 
      
      JMP INPUT
      
   CALC:
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H  
    
    XOR AX,AX 
    
    MOV AL,CL  
    MOV BL,2
   
    OUTPUT:
    
    DIV BL
    MOV DL,AH
 
    MOV CL,AL 
    
    ADD DL,'0'
    
    MOV AH,2
    INT 21H 
       
    XOR AX,AX   
    MOV AL,CL
    
    CMP AL,0
    JE EXIT 
    
    JMP OUTPUT 
    
    EXIT:
	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP 
END MAIN 


