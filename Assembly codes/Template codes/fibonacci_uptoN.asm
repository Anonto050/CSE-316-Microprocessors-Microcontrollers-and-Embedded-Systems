.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF, '$'  
    PROMPT1 DB 'Enter N: $'        
    
    N DW ?
    Y DW ?
    RES DW ? 
    IS_NEG DB ?
    TEMP DW ?
    FOR_PRINT DW ?
    DG DW ? 
    DIV_RES DW ?
    DIV_REM DW ?
    MARKER DW 0DH 
    OP DB ?
    VAR DW 0H

.CODE

MAIN PROC   
    ; DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX  

    ; Print user prompt
    LEA DX, PROMPT1
    MOV AH, 9
    INT 21H

    ; INPUT N
    CALL INPUT 
    MOV BX, TEMP
    MOV N, BX 

    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H

    ; Compute Fibonacci numbers
COMPUTE_FIB:
    MOV BX, N
    CMP BX, VAR
    JE DOS_EXIT

    MOV AX, VAR
    PUSH AX  ; Push current VAR to stack
    
    CALL FIBONACCI ; Calculate Fibonacci number

    ; Output Fibonacci number
    MOV FOR_PRINT, AX
    CALL OUTPUT 

    MOV AH, 2
    MOV DL, ',' ; Print a comma
    INT 21H

    INC VAR 
    JMP COMPUTE_FIB
    
DOS_EXIT:
    MOV AH, 4CH
    INT 21H 
    
MAIN ENDP

FIBONACCI PROC NEAR
    PUSH BP
    MOV BP, SP

    CMP WORD PTR [BP+4], 1 ; Check if N <= 1
    JG CALC_FIB

    MOV AX, [BP+4] ; Base case: return N
    JMP END_FIB

CALC_FIB:
    MOV CX, [BP+4]
    DEC CX
    PUSH CX         ; Compute F(N-1)
    CALL FIBONACCI
    MOV DX, AX      ; Store F(N-1) in DX
    
    MOV CX, [BP+4]
    SUB CX, 2
    PUSH CX         ; Compute F(N-2)
    CALL FIBONACCI
    ADD AX, DX      ; F(N) = F(N-1) + F(N-2)

END_FIB:
    POP BP
    RET 2

FIBONACCI ENDP   

INPUT PROC
    MOV TEMP, 0D
    XOR BX, BX
    MOV BX, TEMP
    MOV IS_NEG, 0H
    
    ; Check if input is negative
    MOV AH, 1
    INT 21H
    CMP AL, '-'
    JNE CHK_INPUT
    MOV IS_NEG, 1
    JMP INPUT_LOOP

CHK_INPUT:
    CMP AL, 30H
    JL INPUT_LOOP ; If input is not a number, continue
    CMP AL, 39H
    JG INPUT_LOOP ; If input is not a number, continue

    SUB AL, 30H
    MOV DG, AL
    MOV AX, 10D
    MOV BX, TEMP
    MUL BX
    ADD AX, DG
    MOV TEMP, AX

INPUT_LOOP:
    MOV AH, 1
    INT 21H
    CMP AL, CR ; If enter is pressed, finalize input
    JE MINUS
    JMP CHK_INPUT

MINUS:
    CMP IS_NEG, 1
    JNE EXIT_INPUT

    NEG TEMP ; If negative, adjust TEMP
    MOV AX, TEMP

EXIT_INPUT:
    RET

INPUT ENDP

OUTPUT PROC
    MOV CX, MARKER
    PUSH CX ; Marker

    MOV IS_NEG, 0
    MOV AX, FOR_PRINT
    TEST AX, 8000H
    JZ OUTPUT_LOOP

    MOV IS_NEG, 1
    NEG FOR_PRINT

OUTPUT_LOOP:
    MOV AX, FOR_PRINT
    XOR DX, DX
    MOV BX, 10
    DIV BX

    MOV FOR_PRINT, AX
    PUSH DX

    CMP AX, 0
    JNE OUTPUT_LOOP

    ; Print minus sign if number is negative
    CMP IS_NEG, 1
    JNE PRINT_DIGITS
    MOV AH, 2
    MOV DL, '-'
    INT 21H

PRINT_DIGITS:
    POP BX
    CMP BX, MARKER
    JE EXIT_OUTPUT
    
    ADD BX, '0'
    MOV DL, BX
    MOV AH, 2
    INT 21H

    JMP PRINT_DIGITS

EXIT_OUTPUT:
    RET
OUTPUT ENDP

END MAIN
