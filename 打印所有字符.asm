CODE SEGMENT
	      ASSUME CS:CODE
	START:
	      MOV    DX,0
	      MOV    DL,10H
	      MOV    CX,0FH
	      MOV    AX,0
	R:    
	      MOV    AH,02
	      PUSH   CX
	      MOV    CX,10H
	Z:    
	      INT    21H
	      PUSH   DX
	      MOV    DL,0
	      INT    21H
	      POP    DX
	      INC    DX
	      LOOP   Z
	      POP    CX
	      PUSH   DX
	      MOV    DL,0DH
	      INT    21H
	      MOV    DL,0AH
	      INT    21H
	      POP    DX
	      LOOP   R
	      MOV    AH,4CH
	      INT    21H
CODE ENDS  
END START 