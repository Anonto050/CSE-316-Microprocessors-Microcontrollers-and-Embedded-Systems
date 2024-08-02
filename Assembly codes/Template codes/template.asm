.MODEL SMALL 
.STACK 100H 
.DATA
 
 
ARR DB 100 DUP(?) 
CR EQU 0DH
LF EQU 0AH     

I DB 1
J DB 0


.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    ; fast BX = 0
    XOR BX, BX  
    
    LEA SI, ARR   
    
    MOV AH, 1
    INT 21H
    MOV BL,AL   
    SUB BL,'0' 
    
     MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    
    
    
    INPUT_LOOP:
    ; char input
    
    CMP BL,0
    JLE OUTPUT
     
    MOV AH, 1
    INT 21H
    MOV [SI], AL
     
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    DEC BL
    INC SI
    JMP INPUT_LOOP
    
    CALL INSERTION
    
    
    CALL OUTPUT
       
   
    EXIT:
	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP   


INSERTION PROC
    
    MOV SI,0
    MOV CL, 1
    MOV DL, 0
    
    
    
    RET
INSERTION ENDP

OUTPUT PROC  
    
    MOV SI,0
    
    OUTPUT_LOOP:
    
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    JMP OUTPUT_LOOP
    
    RET
OUTPUT ENDP



END MAIN 


