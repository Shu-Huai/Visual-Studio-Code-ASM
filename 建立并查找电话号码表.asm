DATA SEGMENT
	NAMEMESSAGE   DB      'Please input name: ','$'
	PHONEMESSAGE  DB      'Please input telephone number: ','$'
	SEARCHMESSAGE DB      'Do you want to search a telephone number?(y/n)','$'
	NMESSAGE      DB      0DH,0AH,'Please input name: ','$'
	FAILMESSAGE   DB      'Not found.',0DH,0AH,'$'
	NUMBERMESSAGE DB      'Please input the amount you want to store:','$'
	CRLF          DB      0DH,0AH,'$'
	              STOKIN1 LABEL  BYTE
	MAX1          DB      21
	ACT1          DB      ?
	STOKN1        DB      21 DUP(?)
	              STOKIN2 LABEL  WORD
	MAX2          DB      10
	ACT2          DB      ?
	STOKN2        DB      10 DUP(?)
	NUMBERTABLE   DB      50 DUP(28 DUP(?))
	NAMECOUNT     DW      0
	ENDADDR       DW      ?
	ISSWAPPED     DW      ?
	TOTALNUMBER   DW      ?
	SAVENP        DB      28 DUP(?),0DH,0AH,'$'
	SEARCHADDR    DW      ?
	FLAG          DB      ?
	FLAGR         DB      ?
	SHOWTITLE     DB      'Name                Phone',0DH,0AH,'$'
DATA  ENDS
CODE SEGMENT
	           ASSUME DS:DATA,CS:CODE,ES:DATA
MAIN PROC    FAR
	           MOV    AX,DATA
	           MOV    DS,AX
	           MOV    ES,AX
	           LEA    DI,NUMBERTABLE
	           LEA    DX,NUMBERMESSAGE
	           MOV    AH,09
	           INT    21H
	           MOV    BX,0
	INPUTCHAR: 
	           MOV    AH,1
	           INT    21H
	           SUB    AL,30h
	           JL     NOINPUT
	           CMP    AL,9
	           JG     NOINPUT
	           CBW
	           XCHG   AX,BX
	           MOV    CX,10
	           MUL    CX
	           XCHG   AX,BX
	           ADD    BX,AX
	           JMP    INPUTCHAR
	NOINPUT:   
	           MOV    TOTALNUMBER,BX
	           LEA    DX,CRLF
	           MOV    AH,09
	           INT    21H
	A10:       
	           LEA    DX,NAMEMESSAGE
	           MOV    AH,09
	           INT    21H
	           CALL   INPUTNAME
	           INC    NAMECOUNT
	           CALL   INNAME
	           LEA    DX,PHONEMESSAGE
	           MOV    AH,09
	           INT    21H
	           CALL   INPUTPHONE
	           CALL   INPHONE
	           CMP    NAMECOUNT,0
	           JE     EXIT
	           MOV    BX,TOTALNUMBER
	           CMP    NAMECOUNT,BX
	           JNZ    A10
	           CALL   NAMESORT
	A20:       
	           LEA    DX,SEARCHMESSAGE
	           MOV    AH,09
	           INT    21H
	           MOV    AH,08
	           INT    21H
	           CMP    AL,'y'
	           JZ     A30
	           CMP    AL,'n'
	           JZ     EXIT
	           JMP    A20
	A30:       
	           MOV    AH,09
	           LEA    DX,NMESSAGE
	           INT    21H
	           CALL   INPUTNAME
	A40:       
	           CALL   NAMESEARCH
	           JMP    A20
	EXIT:      
	           MOV    AX,4C00H
	           INT    21H
MAIN ENDP
INPUTNAME PROC  NEAR
	           MOV    AH,0AH
	           LEA    DX,STOKIN1
	           INT    21H
	           MOV    AH,09
	           LEA    DX,CRLF
	           INT    21H
	           SUB    BH,BH
	           MOV    BL,ACT1
	           MOV    CX,21
	           SUB    CX,BX
	B10:       
	           MOV    STOKN1[BX],' '
	           INC    BX
	           LOOP   B10
	           RET
INPUTNAME ENDP
INNAME PROC   NEAR
	           LEA    SI,STOKN1
	           MOV    CX,20
	           REP    MOVSB
	           RET
INNAME ENDP
INPUTPHONE PROC   NEAR
	           MOV    AH,0AH
	           LEA    DX,STOKIN2
	           INT    21H
	           MOV    AH,09
	           LEA    DX,CRLF
	           INT    21H
	           SUB    BH,BH
	           MOV    BL,ACT2
	           MOV    CX,9
	           SUB    CX,BX
	C10:       
	           MOV    STOKN2[BX],' '
	           INC    BX
	           LOOP   C10
	           RET
INPUTPHONE ENDP
INPHONE PROC NEAR
	           LEA    SI,STOKN2
	           MOV    CX,8
	           REP    MOVSB
	           RET
INPHONE ENDP
NAMESORT PROC NEAR
	           SUB    DI,28
	           MOV    ENDADDR,DI
	C1:        
	           MOV    ISSWAPPED,0
	           LEA    SI,NUMBERTABLE
	C2:        
	           MOV    CX,20
	           MOV    DI,SI
	           ADD    DI,28
	           MOV    AX,DI
	           MOV    BX,SI
	           REPZ   CMPSB
	           JBE    C3
	           MOV    SI,BX
	           LEA    DI,SAVENP
	           MOV    CX,28
	           REP    MOVSB
	           MOV    CX,28
	           MOV    DI,BX
	           REP    MOVSB
	           MOV    CX,28
	           LEA    SI,SAVENP
	           REP    MOVSB
	           MOV    ISSWAPPED,1
	C3:        
	           MOV    SI,AX
	           CMP    SI,ENDADDR
	           JB     C2
	           CMP    ISSWAPPED,0
	           JNZ    C1
	           RET
NAMESORT ENDP
NAMESEARCH PROC NEAR
	           LEA    BX,NUMBERTABLE
	           MOV    FLAG,0
	D:         
	           MOV    CX,20
	           LEA    SI,STOKN1
	           MOV    DI,BX
	           REPZ   CMPSB
	           JZ     D2
	           ADD    BX,28
	           CMP    BX,ENDADDR
	           JBE    D
	           SUB    FLAG,0
	           JZ     NOTFOUND
	           JMP    DEXIT
	NOTFOUND:  
	           LEA    DX,FAILMESSAGE
	           MOV    AH,09
	           INT    21H
	D2:        
	           MOV    SEARCHADDR,BX
	           INC    FLAG
	           CALL   PRINT
	           ADD    BX,28
	           CMP    BX,ENDADDR
	           JBE    D
	           JMP    DEXIT
	           JNZ    D
	DEXIT:     RET
NAMESEARCH ENDP
PRINT PROC  NEAR
	           SUB    FLAG,0
	           JZ     NO
	P10:       
	           MOV    AH,09
	           LEA    DX,SHOWTITLE
	           INT    21H
	           MOV    CX,28
	           MOV    SI,SEARCHADDR
	           LEA    DI,SAVENP
	           REP    MOVSB
	           LEA    DX,SAVENP
	           MOV    AH,09
	           INT    21H
	           JMP    FEXIT
	NO:        
	           LEA    DX,FAILMESSAGE
	           MOV    AH,09
	           INT    21H
	FEXIT:     
	           RET
PRINT ENDP
CODE ENDS
END MAIN