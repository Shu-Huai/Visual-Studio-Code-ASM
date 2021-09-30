DATA SEGMENT
	MAXLENGTH    DB 0FFH
	INPUT        DB 0, 100H  DUP(?)
	LETTERNUMBER DW 0
	DIGITNUMBER  DW 0
	OTHERNUMBER  DW 0
DATA ENDS
STACKS SEGMENT STACK
	       DB 100H DUP(?)
STACKS ENDS
CODE SEGMENT
MAIN PROC  FAR
	         ASSUME CS:CODE,DS:DATA,ss:STACKS
	START:   
	         MOV    AX,DATA
	         MOV    DS,AX
	         LEA    DX,MAXLENGTH
	         MOV    AH,0AH
	         INT    21H
	         MOV    CL,INPUT
	         MOV    SI,1H
	         CMP    CX,0H
	         JZ     BREAK
	IFNUMBER:
	         MOV    AL,INPUT[SI]
	         CMP    AL,'0'
	         JB     OTHER
	         CMP    AL,'9'
	         JA     IFLETTER
	         INC    DIGITNUMBER
	         JMP    NEXT
	IFLETTER:
	         AND    AL,11011111B
	         CMP    AL,'A'
	         JB     OTHER
	         CMP    AL,'Z'
	         JA     OTHER
	         INC    LETTERNUMBER
	         JMP    NEXT
	OTHER:   
	         INC    OTHERNUMBER
	NEXT:    
	         INC    SI
	         LOOP   IFNUMBER
	BREAK:   
	         MOV    AH,2
	         MOV    DL,0AH
	         INT    21H
	         MOV    AX,LETTERNUMBER
	         CALL   TODEC
	         MOV    AH,2
	         MOV    DL,0AH
	         INT    21H
	         MOV    AX,DIGITNUMBER
	         CALL   TODEC
	         MOV    AH,2
	         MOV    DL,0AH
	         INT    21H
	         MOV    AX,OTHERNUMBER
	         CALL   TODEC
	         MOV    AH,4CH
	         INT    21H
	         RET
MAIN ENDP
TODEC PROC NEAR
	         MOV    CX,0
	         MOV    BX,0AH
	DEVIDE:  
			 MOV    DX,0
	         DIV    BX
	         PUSH   DX
	         INC    CX
	         CMP    AX,0
	         JNZ    DEVIDE
	PRINT:   
	         POP    DX
	         ADD    DL,30H
	         MOV    AH,2
	         INT    21H
	         LOOP   PRINT
	         RET
TODEC ENDP
CODE ENDS
END START