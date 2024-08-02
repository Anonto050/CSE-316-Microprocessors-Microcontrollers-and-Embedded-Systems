.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH  
    I DW ?
    FLAG DB 0
    NEWLINE DB CR, LF, '$' 

.CODE
    MAIN PROC  
        ; Initialize Data Segment
        MOV AX, @DATA
        MOV DS, AX  

        CALL INPUT_INTEGER
        
        MOV BX, DX          ; Move the input integer (stored in DX) to BX
        CALL PRINT_NEWLINE  ; Print a newline
        
        CALL PRINT_INTEGER  ; Print the integer
        
        ; Return 0 and exit program
        MOV AH, 4CH
        INT 21H
    MAIN ENDP 

    PRINT_NEWLINE PROC
        LEA DX, NEWLINE    ; Load address of newline string
        MOV AH, 9          ; Print string function
        INT 21H
        RET
    PRINT_NEWLINE ENDP
    
    INPUT_INTEGER PROC   
        XOR DX, DX         ; Initialize DX to 0
        MOV I, 0           ; Initialize digit count to 0

    INPUT_LOOP:
        MOV AH, 1
        INT 21H            ; Get a character from input

        CMP AL, CR
        JE END_INPUT_LOOP
        CMP AL, LF
        JE END_INPUT_LOOP

        CMP AL, '-'
        JNE DIGIT_INPUT
        CMP I, 0
        JNE END_INPUT_LOOP
        MOV FLAG, 1        ; Set flag for negative number
        INC I
        JMP INPUT_LOOP

    DIGIT_INPUT:
        SUB AL, '0'        ; Convert ASCII to digit
        MOV BX, AX
        MOV AX, 10
        MUL DX             ; DX = DX * 10
        ADD DX, BX         ; DX = DX + BX
        INC I
        JMP INPUT_LOOP
            
    END_INPUT_LOOP:
        CMP FLAG, 1
        JNE END_INPUT
        NEG DX             ; Negate DX if the number is negative
        MOV FLAG, 0        ; Reset FLAG

    END_INPUT:
        RET
    INPUT_INTEGER ENDP

    PRINT_INTEGER PROC
        CMP BX, 0
        JGE POSITIVE
        MOV AH, 2
        MOV DL, '-'        ; Print '-' for negative numbers
        INT 21H
        NEG BX             ; Make BX positive

    POSITIVE:
        MOV AX, BX
        MOV I, 0           ; Initialize character count

    PUSH_WHILE:
        XOR DX, DX         ; Clear DX
        MOV BX, 10
        DIV BX             ; AX = AX / 10, DX = remainder
        PUSH DX            ; Store remainder (digit) on stack
        INC I              ; Increment digit count
        CMP AX, 0
        JNE PUSH_WHILE

        MOV AH, 2
    POP_WHILE:
        POP DX             ; Get digit from stack
        ADD DL, '0'        ; Convert to ASCII
        INT 21H            ; Print the digit
        DEC I
        CMP I, 0
        JG POP_WHILE

    END_POP_WHILE:
        RET
    PRINT_INTEGER ENDP

END MAIN
