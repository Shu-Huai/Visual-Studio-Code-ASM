DATA SEGMENT
	INPUTSENTENCE DB       'Enter sentence:$'
	INPUTKEYWORD  DB       'Enter keyword:$''
	MATCHOUTPUT   DB       'Match at location:',?,?,' H of the sentence',13,10,'$'
	FAILOUTPUT    DB       'No match.',13,10,'$''
	TEMP          DB       13,10,'$'10,'$'
	              SENTENCE label   byte label   byte
	MAXS          DB       99H   99H
	ACTS          DB       ?     ?
	SENTE         DB       999h DUP(?)DUP(?)
	              KEYWORD  label   byte label   byte
	MAXK          DB       99H   99H
	ACTK          DB       ?     ?
	KEYD          DB       999H DUP(?)DUP(?)
DATA  ENDS
CODE SEGMENT
	      ASSUME CS:CODE,DS:DATA,ES:DATA
MAIN PROC    FAR
	      PUSH   DS
	      XOR    AX,AX
	      PUSH   AX
	      MOV    AX,DATA
	      MOV    DS,AX
	      MOV    ES,AX
	START:LEA    DX,INPUTSENTENCE
	      MOV    AH,09
	      INT    21H
	      LEA    DX,SENTENCE
	      MOV    AH,0AH
	      INT    21H
	      CMP    ACTS,0
	      JE     C
	      LEA    DX,TEMP
	      MOV    AH,09
	      INT    21H
	      LEA    DX,INPUTKEYWORD
	      MOV    AH,09
	      INT    21H
	      LEA    DX,KEYWORD
	      MOV    AH,0AH
	      INT    21H
	      CMP    ACTK,0
	      JE     BREAK
	      LEA    DX,TEMP
	      MOV    AH,09
	      INT    21H
	      LEA    SI,KEYD
	      LEA    BX,SENTE
	      MOV    DI,BX
	      CLD
	      MOV    CH,0
	      MOV    CL,ACTS
	      SUB    CL,ACTK
	      INC    CX
	COMP: PUSH   CX
	      PUSH   DI
	      MOV    CL,ACTK
	      REPZ   CMPSB
	      JZ     FIND
	      POP    DI
	      POP    CX
	      INC    DI
	      LEA    SI,KEYD
	      LOOP   COMP
	      LEA    DX,FAILOUTPUT
	      MOV    AH,09
	      INT    21H
	      JMP    BREAK
	C:    JMP    BREAK
	FIND: POP    DI
	      POP    CX
	      SUB    DI,BX
	      MOV    BX,DI
	      INC    BX
	      MOV    AX,BX
	      MOV    BH,16
	      DIV    BH
	      ADD    AL,48
	      ADD    AH,48
	      CMP    AH,58
	      JAE    A
	NEXT: MOV    [MATCHOUTPUT+18],AL
	      MOV    [MATCHOUTPUT+19],AH
	      LEA    DX,MATCHOUTPUT
	      MOV    AH,09
	      INT    21H
	      JMP    START
	A:    ADD    AH,7
	      JMP    NEXT
	BREAK:RET
MAIN ENDP
CODE  ENDS 
END   MAIN