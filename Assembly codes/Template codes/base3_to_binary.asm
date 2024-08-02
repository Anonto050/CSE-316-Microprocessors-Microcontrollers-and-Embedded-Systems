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
    
    ; Initialize BX and CX to 0
    XOR BX, BX
    XOR CX, CX
    
    ; Store the value of X in BL
    MOV BL, X

    ; Input handling loop
INPUT:
    MOV AH, 1
    INT 21H  
    
    ; Check for newline or carriage return
    CMP AL, CR
    JE CALC
    CMP AL, LF
    JE CALC
    
    ; Check if input is '0', '1', or '2'
    CMP AL, '0'
    JL INPUT          ; Ignore inputs less than '0'
    CMP AL, '2'
    JG INPUT          ; Ignore inputs greater than '2'
    
    ; Convert character to integer and store in BL
    SUB AL, '0'
    MOV BL, AL
    
    ; Calculate (CX * X) + BL and store in CX
    MOV DL, X         ; DL = X (3)
    MOV AL, CL        ; AL = CL (current value in CX)
    MUL DL            ; AX = AL * DL (CX * X)
    MOV CL, AL        ; Store lower byte of the result in CL
    ADD CL, BL        ; CL = CL + BL
    
    JMP INPUT         ; Loop back to read next input
    
CALC:
    ; Printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H  
    
    ; Prepare for output
    XOR AX, AX 
    MOV AL, CL
    MOV BL, 2
   
OUTPUT:
    DIV BL            ; Divide AL by BL, result in AL, remainder in AH
    MOV DL, AH        ; Move remainder to DL (binary digit)
    MOV CL, AL        ; Update CL with the quotient

    ADD DL, '0'       ; Convert remainder to ASCII
    MOV AH, 2
    INT 21H           ; Print the digit
    
    XOR AX, AX   
    MOV AL, CL        ; Prepare AL for the next iteration
    
    CMP AL, 0         ; Check if quotient is zero
    JE EXIT
    
    JMP OUTPUT        ; Continue outputting the result

EXIT:
    ; Exit the program
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP 
END MAIN 
