.MODEL SMALL
.STACK 100H
.DATA


.CODE


MAIN PROC
    
    MOV AH,1
    INT 21H
    
    MOV BL, 'H'
    MOV CL, AL
    
    SUB BL, CL 
    ADD BL, 10
    
    
    MOV AH,2 
    MOV DL, BL
    INT 21H
    
    MOV AH, 4CH
    INT 21
    
    
    
MAIN ENDP

END MAIN