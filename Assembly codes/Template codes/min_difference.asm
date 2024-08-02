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

        ; Prompt for number of elements
        LEA DX, INPUT_MSG
        MOV AH, 9
        INT 21H

        CALL INPUT_INTEGER
        MOV N, DX

        CALL PRINT_NEWLINE

        ; Input N integers
        MOV CX, N
        MOV SI, 0                   ; Point SI to the start of ARR
        TOP:
            CALL INPUT_INTEGER
            MOV WORD PTR ARR[SI], DX    ; Store the input in the array
            CALL PRINT_NEWLINE
            ADD SI, 2                   ; Move to the next element in ARR
        LOOP TOP

        CALL MIN_DIFF

        ; Output the minimum difference
        MOV DX, DIFF
        CALL PRINT_INTEGER

        ; Exit program
        MOV AH, 4CH
        INT 21H
    MAIN ENDP

    PRINT_NEWLINE PROC
        LEA DX, NEWLINE
        MOV AH, 9
        INT 21H
        RET
    PRINT_NEWLINE ENDP

    MIN_DIFF PROC
        MOV CX, N               ; CX = Number of elements in the array
        MOV SI, 0               ; SI = Index in the array
        MOV DIFF, 7FFFH         ; DIFF = Set to maximum possible value (initialized)

        MIN_DIFF_LOOP:
            CMP CX, 0           ; Check if there are any elements left
            JE END_MIN_DIFF     ; If no elements, end loop

            MOV AX, [ARR + SI]  ; Load current element from the array
            MOV BX, N           ; Load the specified number N
            SUB AX, BX          ; Calculate the difference
            JNS POSITIVE_DIFF   ; If result is positive, skip the next step
            NEG AX              ; Otherwise, make the difference positive

        POSITIVE_DIFF:
            CMP AX, DIFF        ; Compare with current minimum difference
            JGE CONTINUE        ; If greater or equal, continue
            MOV DIFF, AX        ; Otherwise, update the minimum difference

        CONTINUE:
            ADD SI, 2           ; Move to the next element (2 bytes per element)
            DEC CX              ; Decrement the loop counter
            JMP MIN_DIFF_LOOP   ; Repeat until all elements are processed

        END_MIN_DIFF:
        RET
    MIN_DIFF ENDP

    INPUT_INTEGER PROC
        XOR DX, DX          ; Initialize DX to 0
        MOV I, 0            ; Reset digit counter
        MOV FLAG, 0         ; Reset negative number flag

    INPUT_LOOP:
        MOV AH, 1
        INT 21H
        CMP AL, CR
        JE END_INPUT_LOOP
        CMP AL, LF
        JE END_INPUT_LOOP

        CMP AL, '-'         ; Check for negative sign
        JNE DIGIT_INPUT
        CMP I, 0
        JNE END_INPUT_LOOP  ; If negative sign not at start, end input
        MOV FLAG, 1
        JMP INPUT_LOOP

    DIGIT_INPUT:
        SUB AL, '0'         ; Convert ASCII to digit
        MOV AH, 0           ; Clear AH
        ADD DX, AX
        MOV AX, 10
        MUL DX
        ADD DX, AX
        INC I
        JMP INPUT_LOOP

    END_INPUT_LOOP:
        CMP FLAG, 1
        JNE END_INPUT
        NEG DX              ; Make DX negative if FLAG is set

    END_INPUT:
        RET
    INPUT_INTEGER ENDP

    PRINT_INTEGER PROC
        PUSH DX             ; Save DX
        MOV AX, DX          ; Move DX to AX for processing
        MOV CX, 10

        CMP AX, 0
        JGE POSITIVE
        NEG AX              ; Make AX positive
        MOV AH, 2
        MOV DL, '-'         ; Print negative sign
        INT 21H

    POSITIVE:
        MOV BX, AX
        XOR CX, CX
        PUSH_LOOP:
            XOR DX, DX
            DIV CX          ; Divide by 10 to separate digits
            PUSH DX         ; Push remainder (digit) onto stack
            INC CX
            CMP AX, 0
            JNE PUSH_LOOP

        POP_LOOP:
            POP DX
            ADD DL, '0'
            MOV AH, 2
            INT 21H         ; Print the digit
            DEC CX
            JNZ POP_LOOP

        POP DX              ; Restore DX
        RET
    PRINT_INTEGER ENDP
END MAIN
