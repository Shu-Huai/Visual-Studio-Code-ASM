<<<<<<< HEAD
MOV A, #00H
MOV R0, #01H
LOOP1:
ADD A, R0
OUT
MOV 30H, A
SUB A, #33H
JC LOOP2
JMP STOP
LOOP2:
CALL DELAY
MOV A, R0
MOV 31H, A
MOV A, 30H
MOV R0, A
MOV A,31H
JMP LOOP1
DELAY:
MOV A,#11H
LOOP: SUB A,#01H
JZ EXIT
JMP LOOP
EXIT:
RET
STOP:
MOV A,#FFH
JMP STOP
END
=======
ORG 00H
MOV R0,#55H
LOOP:MOV A,R0
OUT
JMP LOOP

ORG 60H
MOV A,#04H
MOV R3,A
Z0:MOV A,R3
SUB A,#01H
JZ EXIT
MOV R3,A

IN
MOV R1,A
MOV A,R1
SUB A,R0
JC LOOP2
IN
MOV A,R1
OUT
MOV A,#0AH
T2:SUB A,#01H
JZ RETURN1
JMP T2
RETURN1:
MOV A,#00H
OUT
MOV A,#0AH
T3:SUB A,#01H
JZ RETURN2
JMP T3
RETURN2:
JMP Z0

LOOP2:MOV A,R0
OUT
MOV A,#0AH
T4:SUB A,#01H
JZ RETURN3
JMP T4
RETURN3:
MOV A,#00H
OUT
MOV A,#0AH
T5:SUB A,#01H
JZ RETURN4
JMP T5
RETURN4:

JMP Z0
EXIT:RETI

DELAY:MOV A,#0AH
T1:SUB A,#01H
JZ RETURN
JMP T1
RETURN:RET

END
>>>>>>> fc155957546a4cb792dee2ddd504b973c81e8b9e
