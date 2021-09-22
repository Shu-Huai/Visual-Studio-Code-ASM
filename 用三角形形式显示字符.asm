CODE SEGMENT
	       ASSUME CS:CODE
	START: 
	       MOV    DL,0FH
	       MOV    AH,2H
	       MOV    CL,10H
	       MOV    CH,0FH
	PRINT: 
	       INC    DL
	       INT    21H
	       MOV    BL,DL
	       MOV    DL,0H
	       INT    21H
	       MOV    DL,BL
	       MOV    AL,0H
	       DEC    CL
		   PUSH   CX
		   SUB    CL,CH
		   POP    CX
	       JZ     RETURN
	       JMP    PRINT
	RETURN:
	       MOV    CL,10H
	       MOV    DH,DL
	       MOV    DL,0DH
	       INT    21H
	       MOV    DL,0AH
	       INT    21H
	       MOV    DL,DH
	       DEC    CH
	       JZ     EXIT
	       JMP    PRINT
	EXIT:    
	       MOV    AH,4CH
	       INT    21H
CODE ENDS  
END START 