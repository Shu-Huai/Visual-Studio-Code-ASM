DATA SEGMENT
	LX        DB 15
	LY        DB 10
	RX        DB 15
	RY        DB 50
	DWX       DB 22
	DWY       DB 15
	WINNUMBER DB 1
	DATA	ENDS
CLEAR MACRO
	      MOV AH,6
	      MOV AL,0
	      MOV BH,7
	      MOV CH,0
	      MOV CL,0
	      MOV DH,24
	      MOV DL,78
	      INT 10H
	ENDM
SCROLL MACRO CONT,WINULR,WINULC,WINLRR,WINLRC
	       MOV AH,6
	       MOV AL,CONT
	       MOV CH,WINULR
	       MOV CL,WINULC
	       MOV DH,WINLRR
	       MOV DL,WINLRC
	       MOV BH,14H
	       INT 10H
	ENDM
SETCURSE MACRO X,Y
	         MOV BH,0
	         MOV AH,2
	         MOV DH,X
	         MOV DL,Y
	         INT 10H
	ENDM
SHOW MACRO
	         SETCURSE DWX,DWY
	         MOV      AH,0AH
	         MOV      BH,0
	         MOV      CX,1
	         INT      10H
	         INC      DWY
	         CMP      DWY,65
	         JLE      ISWIN1
	         SCROLL   1,18,15,22,65
	         MOV      DWY,15
	ISWIN1:  
	         CMP      WINNUMBER,0
	         JNZ      SHOWWIN2
	DISPWIN1:
	         INC      LY
	         CMP      LY,30
	         JLE      WINOPT1
	         SCROLL   1,5,10,15,30
	         MOV      LY,10
	WINOPT1: 
	         SETCURSE LX,LY
	         JMP      INPUT
	SHOWWIN2:
	         INC      RY
	         CMP      RY,70
	         JLE      WINOPT2
	         SCROLL   1,5,50,15,70
	         MOV      RY,50
	WINOPT2: 
	         SETCURSE RX,RY
	         JMP      INPUT
	ENDM
INPUTCHAR MACRO
	INPUT:    
	          MOV      AH,0
	          INT      16H
	          CMP      AH,4BH
	          JNZ      NOWIN1
	          SETCURSE LX,LY
	          MOV      WINNUMBER,0
	          JMP      INPUT
	NOWIN1:   
	          CMP      AH,4DH
	          JNZ      NOWIN2
	          SETCURSE RX,RY
	          MOV      WINNUMBER,1
	          JMP      INPUT
	NOWIN2:   
	          CMP      AH,01
	          JNZ      C1
	          MOV      AH,4CH
	          INT      21h
	ENDM
CODE SEGMENT
	      ASSUME    CS:CODE,DS:DATA
	START:
MAIN PROC	FAR
	      PUSH      DS
	      SUB       AX,AX
	      PUSH      AX
	      MOV       AX,DATA
	      MOV       DS,AX
	      CLEAR
	      SCROLL    11,5,10,15,30
	      SCROLL    11,5,50,15,70
	      SCROLL    5,18,15,22,65
	      SETCURSE  15,50
	      INPUTCHAR
	C1:   
	      MOV       AH,0AH
	      MOV       BH,0
	      MOV       CX,1
	      INT       10H
	      SHOW
MAIN ENDP
CODE ENDS 
END START