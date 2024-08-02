.MODEL SMALL
.STACK 100H
.DATA

X DW ?             ; Variable for the first input number
Y DW ?             ; Variable for the second input number
Z DW 10            ; Constant for base 10 conversion
CR EQU 0DH         ; Carriage Return
LF EQU 0AH         ; Line Feed

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Input the first number into BX
    XOR BX, BX
    CALL INPUT_NUMBER
    MOV X, BX          ; Store the first number in X

    ; Print new line
    CALL PRINT_NEWLINE

    ; Input the second number into BX
    XOR BX, BX
    CALL INPUT_NUMBER
    MOV Y, BX          ; Store the second number in Y

    ; Print new line
    CALL PRINT_NEWLINE

    ; Calculate GCD
    MOV AX, X
    MOV BX, Y
    CALL GCD

    ; Output the GCD
    MOV CX, AX         ; GCD is now in AX, move it to CX for printing
    CALL OUTPUT_NUMBER

    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP

INPUT_NUMBER PROC
    ; Read a number from the keyboard and store it in BX
    LOCAL INPUT_LOOP, END_INPUT_LOOP
    INPUT_LOOP:
        MOV AH, 1
        INT 21H
        CMP AL, CR      ; Check for Carriage Return
        JE END_INPUT_LOOP
        CMP AL, LF      ; Check for Line Feed
        JE END_INPUT_LOOP
        SUB AL, '0'     ; Convert ASCII to digit
        MOV AH, 0
        MOV CX, AX
        MOV AX, 10
        MUL BX          ; BX = BX * 10
        ADD BX, CX      ; BX = BX + digit
        JMP INPUT_LOOP
    END_INPUT_LOOP:
    RET
INPUT_NUMBER ENDP

PRINT_NEWLINE PROC
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    RET
PRINT_NEWLINE ENDP

GCD PROC
    ; Calculate GCD of AX and BX, result in AX
    LOCAL LOOP_START, END_GCD
    LOOP_START:
        CMP AX, BX
        JE END_GCD
        JG  GREATER
        JL  LOWER
    GREATER:
        SUB AX, BX
        JMP LOOP_START
    LOWER:
        SUB BX, AX
        JMP LOOP_START
    END_GCD:
    RET
GCD ENDP

OUTPUT_NUMBER PROC
    ; Output the number in CX
    LOCAL OUTPUT_LOOP, END_OUTPUT, DIVIDE_STEP
    MOV DX, 0          ; Clear DX
    MOV BX, Z          ; Set divisor (10)
    OUTPUT_LOOP:
        CMP CX, 0
        JE END_OUTPUT
        DIVIDE_STEP:
        MOV AX, CX
        XOR DX, DX     ; Clear DX for division
        DIV BX         ; AX / 10, quotient in AX, remainder in DX
        PUSH DX        ; Save the remainder (digit)
        MOV CX, AX
        JMP OUTPUT_LOOP
    END_OUTPUT:
        MOV AH, 2
    PRINT_DIGIT_LOOP:
        POP DX
        ADD DL, '0'    ; Convert to ASCII
        INT 21H        ; Print digit
        CMP SP, BP     ; Check if all digits are printed
        JNE PRINT_DIGIT_LOOP
    RET
OUTPUT_NUMBER ENDP

END MAIN
