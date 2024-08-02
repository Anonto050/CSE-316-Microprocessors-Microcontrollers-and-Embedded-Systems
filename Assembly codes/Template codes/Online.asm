.MODEL SMALL 
.STACK 100H 
.DATA

X DW ?
Y DW ?
Z DW 10000

 
CR EQU 0DH
LF EQU 0AH

.CODE 
MAIN PROC 
   MOV AX, @DATA
    MOV DS, AX
    
    ; fast BX = 0
    XOR BX, BX
    
    INPUT_LOOP:
    ; char input 
    MOV AH, 1
    INT 21H
    
    ; if \n\r, stop taking input
    CMP AL, CR    
    JE END_INPUT_LOOP
    CMP AL, LF
    JE END_INPUT_LOOP
    
    ; fast char to digit
    ; also clears AH  
    
    AND AX, 000FH
    
    ; save AX 
    MOV CX, AX
    
    ; BX = BX * 10 + AX
    MOV AX, 10
    MUL BX
    ADD AX, CX
    MOV BX, AX
    JMP INPUT_LOOP
    
    END_INPUT_LOOP:      
    
   
    MOV X, BX  
    
    
     ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H 
       
       
       ;INPUT Y
    
     ; fast BX = 0
    XOR BX, BX
                 INPUT_LOOP2:

    ; char input 
    MOV AH, 1
    INT 21H
    
    ; if \n\r, stop taking input
    CMP AL, CR    
    JE END_INPUT_LOOP2
    CMP AL, LF
    JE END_INPUT_LOOP2
    
    ; fast char to digit
    ; also clears AH  
    
    AND AX, 000FH
    
    ; save AX 
    MOV CX, AX
    
    ; BX = BX * 10 + AX
    MOV AX, 10
    MUL BX
    ADD AX, CX
    MOV BX, AX
    JMP INPUT_LOOP2
    
    END_INPUT_LOOP2: 
    
    
     ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H 
       
       
       ;INPUT Y
    
     ; fast BX = 0
    MOV Y, BX
    
    MOV AX,X
    MOV BX, Y  
    
    
    LOOP_:
    
    CMP AX,BX
    JE EQUAL
    
    
       
       CMP AX,BX
       JG  GREATER 
       CMP AX,BX
       JL LOWER
       
       GREATER:
       
       SUB AX,BX
       JMP LOOP_  
       
       
       LOWER:
       
       SUB BX,AX
       JMP LOOP_             
       
    
    
    
    EQUAL:
    
    MOV CX,AX     
    MOV DX, Z
    MOV AX, CX
    
    OUTPUT:  
    
    MOV AX,CX
    DIV DX    
    
    CMP AX, 0
    JE EXIT
    
    MOV DX,AX
    
    MOV AH,2
    INT 21H 
    
    MOV AX,Z
    MOV DX,10
    DIV DX
    MOV DX,AX
    
     
    JMP OUTPUT
      
  
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H  
    
   
   
   
    
    EXIT:
	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP 
END MAIN 


