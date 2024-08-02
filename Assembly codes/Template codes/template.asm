.MODEL SMALL
.STACK 100H
.DATA

ARR DB 100 DUP(?)   ; Array to store input characters
CR EQU 0DH          ; Carriage Return
LF EQU 0AH          ; Line Feed
COUNT DB 0          ; Counter for number of characters input

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    XOR BX, BX            ; Initialize BX to 0
    LEA SI, ARR           ; Load address of ARR into SI

    ; Prompt user for number of characters
    MOV AH, 1
    INT 21H
    MOV BL, AL            ; Store input character in BL
    SUB BL, '0'           ; Convert ASCII to integer
    MOV COUNT, BL         ; Store the count of characters

    ; Print new line
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H

INPUT_LOOP:
    CMP COUNT, 0
    JLE PROCESS_INPUT     ; Jump to processing if no more input is expected

    ; Read character from user
    MOV AH, 1
    INT 21H
    MOV [SI], AL          ; Store input character in array

    ; Print new line
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H

    DEC COUNT             ; Decrement count of characters to input
    INC SI                ; Move to next array position
    JMP INPUT_LOOP        ; Repeat input loop

PROCESS_INPUT:
    CALL INSERTION        ; Placeholder for sorting or processing routine
    CALL OUTPUT           ; Output the sorted array

EXIT:
    MOV AH, 4CH
    INT 21H

MAIN ENDP

INSERTION PROC
    ; Placeholder for sorting or any other processing
    ; Add sorting code here if needed
    RET
INSERTION ENDP

OUTPUT PROC
    MOV SI, 0             ; Start at beginning of the array

OUTPUT_LOOP:
    MOV AL, [SI]          ; Load character from array
    CMP AL, 0             ; Check if end of input
    JE OUTPUT_END         ; Exit loop if end is reached

    MOV DL, AL
    MOV AH, 2
    INT 21H               ; Print character

    INC SI                ; Move to next character in array
    JMP OUTPUT_LOOP

OUTPUT_END:
    RET
OUTPUT ENDP

END MAIN
