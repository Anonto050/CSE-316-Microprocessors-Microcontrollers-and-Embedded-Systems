.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH
    CRLF DB CR, LF, '$'          ; Newline characters
    INPUT_MSG DB 'Number of elements in the array: $'
    ARRAY_INPUT_MSG DB 'Array elements:', CR, LF, '$'
    SORTED_ARRAY_MSG DB 'Sorted array: $'
    FOUND_MSG DB 'Found at index $'
    NOTFOUND_MSG DB 'Not found$'
    SEARCH_INPUT_MSG DB 'Enter a number to search from the array: $'

    FLAG DB 0
    I DW ?                       ; Used for indexing in insertion sort and binary search
    J DW ?                       ; Used for indexing in insertion sort and binary search
    KEY DW ?                     ; To store key in insertion sort
    N DW ?                       ; Stores the number of inputs
    X DW ?                       ; Stores search input
    ARR DW 100 DUP(?)            ; The array that we will sort
.CODE
    MAIN PROC
        ; Initialize Data Segment
        MOV AX, @DATA
        MOV DS, AX
        
        ; Start of the main program loop
        START:
        ; Print input message for the number of elements
        MOV AH, 9
        LEA DX, INPUT_MSG
        INT 21H

        ; Input N (number of elements)
        CALL INPUT_INTEGER
        ; If N <= 0, end the program
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
            CALL INPUT_INTEGER      ; Save the input in DX
            MOV WORD PTR ARR[SI], DX ; Store the input in the array
            CALL PRINT_NEWLINE
            ADD SI, 2               ; Move to the next element
        LOOP TOP

        ; Sort the array and print it
        CALL INSERTION_SORT
        CALL PRINT_NEWLINE
        MOV AH, 9
        LEA DX, SORTED_ARRAY_MSG
        INT 21H
        CALL PRINT_ARRAY
        CALL PRINT_NEWLINE

        ; Start search loop
        SEARCH_LOOP:
            MOV AH, 9
            LEA DX, SEARCH_INPUT_MSG
            INT 21H
            ; Input the number to search in the array
            CALL INPUT_INTEGER
            MOV X, DX
            CALL PRINT_NEWLINE
            CALL BINARY_SEARCH
            
            MOV AH, 9               ; Prepare to print message
            ; if (BX = -1) then the element is not found in the array
            CMP BX, -1
            JE NOT_FOUND            ; Else, the element was found in the array

            LEA DX, FOUND_MSG
            INT 21H
            CALL PRINT_INTEGER
            CALL PRINT_NEWLINE
            JMP SEARCH_LOOP

            NOT_FOUND:
            LEA DX, NOTFOUND_MSG
            INT 21H
            CALL PRINT_NEWLINE
            JMP SEARCH_LOOP

        END_SEARCH_LOOP:
        CALL PRINT_NEWLINE
        JMP START
        END_PROGRAM:
        ; Return 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP

    ; Function to print newline
    PRINT_NEWLINE PROC
        MOV AH, 9
        LEA DX, CRLF
        INT 21H
        RET
    PRINT_NEWLINE ENDP

    ; Function that takes an integer as input and saves it in DX
    INPUT_INTEGER PROC   
        XOR DX, DX                  ; Initialize DX to 0
        MOV I, 0                    ; Initialize digit count
INPUT_LOOP:
        MOV AH, 1
        INT 21H
        ; If AL == CR || AL == LF then jump to end of loop
        CMP AL, CR
        JE END_INPUT_LOOP
        CMP AL, LF
        JE END_INPUT_LOOP
        ; If AL == '-', set FLAG to 1
        CMP AL, '-'
        JNE DIGIT_INPUT
        CMP I, 0
        JNE END_INPUT_LOOP
        MOV FLAG, 1
        INC I
        JMP INPUT_LOOP

        ; Fast convert character to digit, also clears AH
DIGIT_INPUT:
        SUB AL, '0'
        MOV BX, AX                  ; Save AX in BX
        MOV AX, 10                  ; AX = 10
        MUL DX                      ; DX = DX * 10
        ADD DX, BX                  ; DX = DX + BX
        INC I
        JMP INPUT_LOOP

END_INPUT_LOOP:
        CMP FLAG, 1
        JNE END_INPUT
        NEG DX                      ; Make DX negative
        MOV FLAG, 0                 ; Reset FLAG
END_INPUT:
        RET
    INPUT_INTEGER ENDP

    ; Function that sorts the array ARR using insertion sort
    INSERTION_SORT PROC
        MOV I, 1
FOR_LOOP:
        CMP I, N
        JGE END_FOR
        ; KEY = ARR[I]
        MOV BX, I
        SHL BX, 1                   ; Offset ARR index by multiplying 2 with I
        MOV CX, ARR[BX]             ; CX is used as a temporary variable
        MOV KEY, CX
        ; J = I - 1
        MOV CX, I
        DEC CX
        MOV J, CX

WHILE_LOOP:
        CMP J, 0
        JL END_WHILE
        ; ARR[J] <= KEY then break the loop
        MOV BX, J
        SHL BX, 1
        MOV CX, ARR[BX]
        CMP CX, KEY
        JLE END_WHILE
        ; ARR[J + 1] = ARR[J]
        MOV BX, J
        SHL BX, 1
        MOV CX, ARR[BX]
        ADD BX, 2
        MOV ARR[BX], CX
        ; J = J - 1
        DEC J
        JMP WHILE_LOOP

END_WHILE:
        ; ARR[J + 1] = KEY
        MOV BX, J
        INC BX
        SHL BX, 1
        MOV CX, KEY
        MOV ARR[BX], CX

        INC I
        JMP FOR_LOOP
END_FOR:
        RET
    INSERTION_SORT ENDP

    ; Function to print the integer stored in BX
    PRINT_INTEGER PROC
        ; If BX >= 0 then the number is positive
        CMP BX, 0
        JGE POSITIVE
        ; Else, the number is negative
        MOV AH, 2
        MOV DL, '-'                 ; Print a '-' sign
        INT 21H
        NEG BX                      ; Make BX positive

POSITIVE:
        MOV AX, BX
        MOV I, 0                    ; Initialize character count

PUSH_WHILE:
        XOR DX, DX                  ; Clear DX
        MOV BX, 10
        DIV BX                      ; AX = AX / 10, DX = AX % 10
        PUSH DX                     ; Store remainder
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

    ; Function to print the array ARR
    PRINT_ARRAY PROC
        LEA SI, ARR
        MOV CX, N

TOP_PRINT_ARRAY:
        MOV BX, [SI]
        CALL PRINT_INTEGER
        MOV DL, ','                 ; Print a comma
        MOV AH, 2
        INT 21H

        ADD SI, 2                   ; Point to the next element of the array
        LOOP TOP_PRINT_ARRAY
        RET
    PRINT_ARRAY ENDP

    ; Function to search for X in ARR using binary search
    ; If found, save the index in BX; else save -1 in BX
    BINARY_SEARCH PROC
        MOV BX, -1                  ; Initialize BX to -1 (not found)
        MOV I, 0
        MOV CX, N
        DEC CX
        MOV J, CX                   ; J = N - 1

SEARCH_WHILE:
        CMP I, J
        JG END_SEARCH_WHILE         ; If I > J, break the loop
        ; CX = (I + J) / 2
        MOV CX, I
        ADD CX, J
        SHR CX, 1
        ; Compare ARR[MID] with X
        MOV SI, CX
        SHL SI, 1
        MOV SI, ARR[SI]
        CMP X, SI
        JE FOUND                    ; If X == ARR[MID], found
        JG GREATER                  ; If X > ARR[MID], it is greater

        ; If X < ARR[MID]
        MOV J, CX
        DEC J
        JMP SEARCH_WHILE

GREATER:
        MOV I, CX
        INC I
        JMP SEARCH_WHILE

FOUND:
        MOV BX, CX
        INC BX                      ; Assuming array indexing starts from 1
END_SEARCH_WHILE:
        RET
    BINARY_SEARCH ENDP
END MAIN
