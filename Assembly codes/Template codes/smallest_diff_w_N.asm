.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH  
    I DW 0
    FLAG DB 0  
    N DW ? 
    LEN DW 1  
    POS DW ?
    J DW ?
    DIFF DW ?
    ARR DW 100 DUP(?)   ; The array that we will sort
    NEWLINE DB CR, LF, '$'
    INPUT_MSG DB 'Number of elements in the array: $'
    ARRAY_INPUT_MSG DB 'Array elements:', CR, LF, '$'
    SORTED_ARRAY_MSG DB 'Sorted array: $'

.CODE
    MAIN PROC
        ; Initialize Data Segment
        MOV AX, @DATA
        MOV DS, AX
        
        ; Input number of elements
        CALL INPUT_INTEGER
        MOV N, DX
        
        ; Print new line
        CALL PRINT_NEWLINE
        
        ; Input N integers
        MOV CX, N
        MOV SI, 0                   ; Point SI to the address of ARR 
TOP:
        CALL INPUT_INTEGER
        MOV WORD ARR[SI], DX        ; Store the input in the array
        ADD SI, 2                   ; Increment SI by 2 to point to the next element
        CALL PRINT_NEWLINE
        LOOP TOP
        
        ; Calculate minimum difference
        CALL MIN_DIFF
        
        ; Output the element with the smallest difference
        MOV BX, POS
        SHL BX, 1
        MOV BX, ARR[BX]
        CALL PRINT_INTEGER
        
        ; Exit program
        MOV AH, 4CH
        INT 21H
    MAIN ENDP

    PRINT_NEWLINE PROC
        LEA DX, NEWLINE         ; Print New line
        MOV AH, 9
        INT 21H
        RET
    PRINT_NEWLINE ENDP

    MIN_DIFF PROC
        MOV I, 0
        MOV DIFF, 7FFFH         ; Initialize DIFF to the largest possible value
        MOV POS, 0

LOOP_FOR:
        CMP I, N                ; If I >= N, end loop
        JGE END_LOOP_FOR

        MOV BX, I
        SHL BX, 1
        MOV AX, ARR[BX]         ; Load array element
        MOV CX, N
        CMP AX, CX
        JG GREATER

        SUB AX, CX              ; Calculate difference if AX < CX
        JMP COMPARE_DIFF

GREATER:
        SUB CX, AX              ; Calculate difference if AX >= CX
        MOV AX, CX

COMPARE_DIFF:
        CMP AX, DIFF            ; Compare with current smallest difference
        JGE NEXT

        MOV DIFF, AX            ; Update smallest difference
        MOV POS, I

NEXT:
        INC I
        JMP LOOP_FOR

END_LOOP_FOR:
        RET
    MIN_DIFF ENDP

    INPUT_INTEGER PROC
        XOR DX, DX  ; Initialize DX to 0
        MOV I, 0    ; Initialize digit count

INPUT_LOOP:
        MOV AH, 1
        INT 21H
        CMP AL, CR
        JE END_INPUT_LOOP
        CMP AL, LF
        JE END_INPUT_LOOP
        CMP AL, '-'
        JNE DIGIT_INPUT

        CMP I, 0
        JNE END_INPUT_LOOP
        MOV FLAG, 1
        JMP INPUT_LOOP

DIGIT_INPUT:
        SUB AL, '0'
        MOV BX, AX
        MOV AX, 10
        MUL DX
        ADD DX, BX
        INC I
        JMP INPUT_LOOP

END_INPUT_LOOP:
        CMP FLAG, 1
        JNE END_INPUT
        NEG DX                  ; Make DX negative if FLAG is set
        MOV FLAG, 0             ; Reset FLAG

END_INPUT:
        RET
    INPUT_INTEGER ENDP

    PRINT_INTEGER PROC
        CMP BX, 0
        JGE POSITIVE
        MOV AH, 2
        MOV DL, '-'         ; Print '-' for negative numbers
        INT 21H
        NEG BX

POSITIVE:
        MOV AX, BX
        MOV I, 0

PUSH_WHILE:
        XOR DX, DX
        MOV BX, 10
        DIV BX
        PUSH DX
        INC I
        CMP AX, 0
        JNE PUSH_WHILE

        MOV AH, 2
POP_WHILE:
        POP DX
        ADD DL, '0'
        INT 21H
        DEC I
        CMP I, 0
        JG POP_WHILE

        RET
    PRINT_INTEGER ENDP

END MAIN
