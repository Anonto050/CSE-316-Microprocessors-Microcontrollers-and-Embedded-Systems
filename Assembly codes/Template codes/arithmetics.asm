.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF, '$'
    PROMPT1 DB 'Enter First Number: $'
    PROMPT2 DB 'Enter Second Number: $'
    PROMPT_OP DB 'Enter Operator (+, -, *, /): $'
    WRONG DB 'Wrong operator$'
    X DW ?
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

.CODE

MAIN PROC
    ; Data Segment Initialization
    MOV AX, @DATA
    MOV DS, AX
    
    ; Prompt for first number
    LEA DX, PROMPT1
    MOV AH, 9
    INT 21H
    
    ; Input X
    CALL INPUT
    MOV BX, TEMP
    MOV X, BX 

    ; New line
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H

    ; Prompt for operator
    LEA DX, PROMPT_OP
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV OP, AL
         
    CMP AL, '+'
    JE INPUT_Y  
    CMP AL, '-'
    JE INPUT_Y
    CMP AL, '*'
    JE INPUT_Y
    CMP AL, '/'
    JE INPUT_Y
    
    ; Invalid operator handling
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    LEA DX, WRONG
    MOV AH, 9
    INT 21H
    JMP DOS_EXIT

INPUT_Y:
    ; New line
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H

    ; Prompt for second number
    LEA DX, PROMPT2
    MOV AH, 9
    INT 21H
    
    ; Input Y
    CALL INPUT
    MOV BX, TEMP
    MOV Y, BX
    
    ; New line
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    MOV AL, OP
    CMP AL, '+'
    JE ADD_BLOCK  
    CMP AL, '-'
    JE SUB_BLOCK
    CMP AL, '*'
    JE MUL_BLOCK
    CMP AL, '/'
    JE DIV_BLOCK
    
ADD_BLOCK:
    CALL ADD_INT
    JMP DISPLAY_RESULT

SUB_BLOCK:
    CALL SUB_INT
    JMP DISPLAY_RESULT

MUL_BLOCK:
    CALL MUL_INT
    JMP DISPLAY_RESULT

DIV_BLOCK:
    CALL DIV_INT
    JMP DISPLAY_RESULT

DISPLAY_RESULT:
    MOV AH, 2
    MOV DL, '['
    INT 21H

    ; Output X
    MOV BX, X
    MOV FOR_PRINT, BX
    CALL OUTPUT
    
    MOV AH, 2
    MOV DL, ']'
    INT 21H

    MOV AH, 2
    MOV DL, OP
    INT 21H
    
    MOV AH, 2
    MOV DL, '['
    INT 21H

    ; Output Y
    MOV BX, Y
    MOV FOR_PRINT, BX
    CALL OUTPUT
    
    MOV AH, 2
    MOV DL, ']'
    INT 21H
    
    MOV AH, 2
    MOV DL, '='
    INT 21H

    ; Output Result
    MOV BX, RES
    MOV FOR_PRINT, BX
    CALL OUTPUT

DOS_EXIT:
    ; DOS Exit
    MOV AH, 4CH
    INT 21H

MAIN ENDP

INPUT PROC
    MOV TEMP, 0
    MOV IS_NEG, 0
    
    ; Read first character
    MOV AH, 1
    INT 21H
    CMP AL, '-'
    JNE CHK_INPUT
    MOV IS_NEG, 1
    JMP INPUT_LOOP

CHK_INPUT:
    CMP AL, '0'
    JL INPUT_LOOP
    CMP AL, '9'
    JG INPUT_LOOP

    ; Convert ASCII to integer
    SUB AL, '0'
    MOV BX, AX
    MOV AX, 10
    MUL DX
    ADD DX, BX

INPUT_LOOP:
    MOV AH, 1
    INT 21H
    CMP AL, CR
    JE MINUS_CHECK
    CMP AL, LF
    JE MINUS_CHECK
    JMP CHK_INPUT

MINUS_CHECK:
    CMP IS_NEG, 1
    JNE EXIT_INPUT
    NEG DX
    MOV IS_NEG, 0

EXIT_INPUT:
    MOV TEMP, DX
    RET
INPUT ENDP

OUTPUT PROC
    MOV CX, MARKER
    PUSH CX ; marker
    
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
    PUSH DX
    
    MOV FOR_PRINT, AX
    CMP AX, 0
    JNE OUTPUT_LOOP

    MOV AL, IS_NEG
    CMP AL, 1
    JNE PRINT_DIGITS
    MOV AH, 2
    MOV DL, '-'
    INT 21H

PRINT_DIGITS:
    POP DX
    CMP DX, MARKER
    JE EXIT_OUTPUT
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    JMP PRINT_DIGITS

EXIT_OUTPUT:
    RET
OUTPUT ENDP

ADD_INT PROC
    MOV AX, X
    ADD AX, Y
    MOV RES, AX
    RET
ADD_INT ENDP

SUB_INT PROC
    MOV AX, X
    SUB AX, Y
    MOV RES, AX
    RET
SUB_INT ENDP

MUL_INT PROC
    MOV AX, X
    MOV BX, Y
    IMUL BX
    MOV RES, AX
    RET
MUL_INT ENDP

DIV_INT PROC
    MOV AX, X
    CWD
    MOV BX, Y
    IDIV BX
    MOV RES, AX
    RET
DIV_INT ENDP

END MAIN
