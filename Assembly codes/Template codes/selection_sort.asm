.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH
    I DW ?
    FLAG DB 0  
    N DW ?
    J DW ?
    MAX DW ?
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
        
        ; Print input message for number of elements
        MOV AH, 9
        LEA DX, INPUT_MSG
        INT 21H
        
        ; Input N (number of elements)
        CALL INPUT_INTEGER
        ; If N < 0, end the program
        CMP DX, 0
        JLE END_PROGRAM
        ; Else continue
        MOV N, DX
        ; Print newline
        CALL PRINT_NEWLINE
        ; Print message for array elements input
        MOV AH, 9
        LEA DX, ARRAY_INPUT_MSG
        INT 21H
        
        ; Input N integers
        MOV CX, N
        MOV SI, 0                   ; Point SI to the start of ARR
TOP:
        CALL INPUT_INTEGER          ; Saves the input in DX
        MOV WORD PTR ARR[SI], DX    ; Store the input in the array
        ADD SI, 2                   ; Move to the next element
        CALL PRINT_NEWLINE
        LOOP TOP
        
        ; Sort the array using selection sort
        CALL SELECTION_SORT
        
        ; Print sorted array message
        MOV AH, 9
        LEA DX, SORTED_ARRAY_MSG
        INT 21H
        ; Print the sorted array
        CALL PRINT_ARRAY
        
END_PROGRAM:
        ; Exit the program
        MOV AH, 4CH
        INT 21H
    MAIN ENDP 

    PRINT_NEWLINE PROC
        LEA DX, NEWLINE             ; Print newline
        MOV AH, 9
        INT 21H
        RET
    PRINT_NEWLINE ENDP 

    SELECTION_SORT PROC
        MOV I, 0                    ; Initialize I to 0
        LOOP_FOR:
            CMP I, N
            JGE END_LOOP_FOR
        
            MOV CX, I
            MOV MAX, CX             ; Initialize MAX to I
            
            INC CX
            MOV J, CX               ; Initialize J to I + 1
            
            LOOP_J:
                CMP J, N
                JGE END_LOOP_J
            
                MOV BX, J
                SHL BX, 1
                MOV AX, ARR[BX]     ; Get ARR[J]
                
                MOV SI, MAX
                SHL SI, 1
                MOV DX, ARR[SI]     ; Get ARR[MAX]
                
                CMP AX, DX
                JNG NOT_GREATER     ; If ARR[J] <= ARR[MAX], skip
                MOV MAX, J          ; Else, update MAX
                
NOT_GREATER:
                INC J
                JMP LOOP_J
            END_LOOP_J:
            
            ; Swap ARR[I] and ARR[MAX]
            MOV BX, MAX
            SHL BX, 1
            MOV AX, ARR[BX]         ; AX = ARR[MAX]
            MOV DX, ARR[SI]         ; DX = ARR[I]

            MOV ARR[BX], DX         ; ARR[MAX] = ARR[I]
            MOV ARR[SI], AX         ; ARR[I] = ARR[MAX]
            
            ; Print the array after each swap (optional for debugging)
            CALL PRINT_ARRAY
            CALL PRINT_NEWLINE

            INC I
            JMP LOOP_FOR
        END_LOOP_FOR:
        RET
    SELECTION_SORT ENDP 

    INPUT_INTEGER PROC
        XOR DX, DX                  ; Initialize DX to 0
        MOV I, 0                    ; Initialize digit count
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
        NEG DX                      ; Make DX negative if FLAG is set
        MOV FLAG, 0                 ; Reset FLAG
END_INPUT:
        RET
    INPUT_INTEGER ENDP

    PRINT_INTEGER PROC
        CMP BX, 0
        JGE POSITIVE
        MOV AH, 2
        MOV DL, '-'
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

    PRINT_ARRAY PROC
        LEA SI, ARR
        MOV CX, N

PRINT_ARRAY_LOOP:
        MOV AX, [SI]
        MOV BX, AX
        CALL PRINT_INTEGER
        MOV DL, ','
        MOV AH, 2
        INT 21H

        ADD SI, 2
        LOOP PRINT_ARRAY_LOOP
        RET
    PRINT_ARRAY ENDP
END MAIN
