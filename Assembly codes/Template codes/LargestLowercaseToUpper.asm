.MODEL SMALL
.STACK 100H
.DATA

X DB 7BH             ; Initial value { (7B in hex)
CR EQU 0DH
LF EQU 0AH

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    XOR BX, BX         ; Initialize BX to 0
    MOV BL, X          ; Load initial value (ASCII '{') into BL

INPUT_LOOP:
    ; Wait for character input
    MOV AH, 1
    INT 21H

    ; Check if input character is between 'a' and 'z'
    CMP AL, 'a'
    JL EXIT            ; Exit if input is less than 'a'
    CMP AL, 'z'
    JG EXIT            ; Exit if input is greater than 'z'

    ; If the input character is greater than BL, update BL
    CMP AL, BL
    JLE INPUT_LOOP     ; Continue loop if AL <= BL

    ; Update BL with the new greater character
    MOV BL, AL
    JMP INPUT_LOOP

EXIT:
    ; Print a new line
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H

    ; Convert the character in BL from lowercase to uppercase
    ; Only perform conversion if BL is still a lowercase letter
    CMP BL, 'a'
    JL SKIP_UPPERCASE
    CMP BL, 'z'
    JG SKIP_UPPERCASE
    SUB BL, 32          ; Convert to uppercase

SKIP_UPPERCASE:
    ; Output the resulting character
    MOV DL, BL
    INT 21H

    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
