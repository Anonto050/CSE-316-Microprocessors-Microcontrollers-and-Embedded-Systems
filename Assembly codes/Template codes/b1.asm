.MODEL SMALL 
.STACK 100H 
.DATA

X DB 7BH
 
CR EQU 0DH
LF EQU 0AH

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    ; fast BX = 0
    XOR BX, BX   
    
    MOV BL,X
    
    INPUT_LOOP:
    ; char input 
    MOV AH, 1
    INT 21H 
    
    
    CMP AL, 'a'
    JNGE EXIT
    
    CMP AL, 'z'
    JNLE EXIT 
    
    CMP AL, BL
    JNGE TOP  
    JMP INPUT_LOOP
    
    TOP:
    MOV BL,AL
    JMP INPUT_LOOP
     
      
    EXIT:  
   
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H   
   
    SUB BL,32D 
    MOV DL,BL
    INT 21H
    
    
	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP 
END MAIN 


