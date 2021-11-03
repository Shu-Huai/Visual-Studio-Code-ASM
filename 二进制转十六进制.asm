DATA SEGMENT
	MESSAGE DB 'The number is: $'
	NUMBER  DB 00110100B, 00010010B
DATA ENDS
CODE SEGMENT
	       ASSUME CS: CODE, DS:DATA
	START: 
	       MOV    AX, DATA
	       MOV    DS,AX
	       LEA    DX, MESSAGE
	       MOV    AH,9
	       INT    21H
	       MOV    BX, WORD PTR NUMBER
	       MOV    CH,4
	ROTATE:
	       MOV    CL,4
	       ROL    BX, CL
	       MOV    AL, BL
	       AND    AL, 0FH
	       ADD    AL,30H
	       CMP    AL,3AH
	       JL     PRINT
	       ADD    AL,7H
	PRINT: 
	       MOV    DL, AL
	       MOV    AH, 2
	       INT    21H
	       DEC    CH
	       JNZ    ROTATE
	       MOV    AH,4CH
	       INT    21H
CODE ENDS    
END   START                