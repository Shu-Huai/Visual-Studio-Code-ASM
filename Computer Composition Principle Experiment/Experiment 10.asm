START:
MOV A, #11H
MOV R1, A
OUT
MOV A, #15H
LOOP1:
SUB A, #01H
MOV R2, A
JZ LOOP2
JMP LOOP1
LOOP2:
MOV A, #55H
MOV R1, A
OUT
MOV A, #15H
LOOP3:
SUB A, #01H
MOV R2, A
JZ START
JMP LOOP3
ORG 50H
MOV R0, #04H
LOOP4:
MOV A, R0
SUB A, #01H
JZ LOOP8
MOV R0, A
MOV A, #AAH
OUT
MOV A, #05H
LOOP5:
SUB A, #01H
JZ LOOP6
JMP LOOP5
LOOP6:
MOV A, #BBH
OUT
MOV A, #05H
LOOP7:
SUB A, #01H
JZ LOOP4
JMP LOOP7
LOOP8:
MOV R0, #00H
MOV A, R1
OUT
RETI
END