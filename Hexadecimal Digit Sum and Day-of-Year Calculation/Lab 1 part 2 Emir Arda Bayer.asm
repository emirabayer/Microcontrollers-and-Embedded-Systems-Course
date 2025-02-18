;Lab 1 part 2 Emir Arda Bayer 22201832

ORG 0H

KY0: DB '1', '2', '3', 'A'
KY1: DB '4', '5', '6', 'B'
KY2: DB '7', '8', '9', 'C'
KY3: DB '*', '0', '#', 'D'

COEFFICIENT: DB	1,10,100
DAY_NUM: DB 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31

INPUT_S: DB 'INPUT = '

DAY_NAMES: DB 'SAT', 'SUN','MON', 'TUE', 'WED', 'THU', 'FRI','SAT', 'SUN'
NAME_OF_MONTHS:	DB 'JAN','FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP','OCT','NOV','DEC'

NUM_OF_DAYS: DB 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31


	acall	CONFIGURE_LCD
	acall   OUT_I_S
	MOV R4, #0
	MOV R5, #4

	
KB:
	acall KEYBOARD
	CJNE A, #'A', $+5
	SJMP CALC_NUM
	PUSH ACC
	SUBB A, #65
	JNC KB
	POP ACC
	
	acall SEND_DATA
	SUBB A, #2FH  ;to ascii
	PUSH ACC
	INC R4
	DJNZ R5, KB
	LJMP Lplus_INP

CALC_NUM:
	MOV R0, #0
	MOV R1, #0
	MOV R2, #0
	MOV DPTR, #COEFFICIENT

CALC_S:
	POP B
	MOV A, R2
	MOVC A, @A+DPTR
	MUL AB
	ADD A, R0
	
	JNC $+4
	INC B
	MOV R0, A
	MOV A, R1
	ADD A, B
	MOV R1, A
	INC R2
	
	DJNZ R4, CALC_S

CALCULATE_THE_DAY:
	MOV B, R1
	MOV A, R0
	DEC B
	
CALCULATE_THE_DAY_S:
	CLR C
	SUBB A, #7
	JNC CALCULATE_THE_DAY_S
	DJNZ B, CALCULATE_THE_DAY_S
	
	ADD A, #7
	MOV B, #3
	MUL AB
	MOV R2, A
	MOV R3, #3
	MOV DPTR, #DAY_NAMES
	
DAY_OUT:
	MOV A, R2
	MOVC A, @A+DPTR
	ACALL SEND_DATA
	
	INC R2
	DJNZ R3, DAY_OUT
	MOV A,R5
	SUBB A, #2FH
	sjmp endloop
	
CALC_MON:
	mov DPTR, #NUM_OF_DAYS
	MOV B, R1
	MOV A, R0
	INC B
	MOV R2, #0
	PUSH B
	PUSH ACC
	
MON_S:
	MOV A, R2
	MOVC A, @A+DPTR 
	MOV R3, A
	POP ACC
	POP B
	SUBB A, R3
	JC $+5
	CJNE A, #0, NEG_NOT
	DJNZ B, NEG
	MOV R5, A
	MOV A, R2
	MOV DPTR, #NAME_OF_MONTHS
	MOV R3, #3
	MOV B, #3
	MUL AB
	MOV B, A
MOV A, #0C0H
ACALL SEND_COMMAND ;func LCD

MON_OUT:
	MOV A, B
	MOVC A, @A+DPTR
	ACALL SEND_DATA
	INC B
	DJNZ R3, MON_OUT
	MOV A, #20H


	
ACALL SEND_DATA ;func LCD

MOV DPTR, #NUM_OF_DAYS
MOV R2, #0 ;reset
MOV A, R0
MOV R4, A
MOV A, R1 ;sum
MOV R5, A

CLR A
MOV R6, A ;res

MON_INC:
    CLR A
    MOVC A, @A+DPTR
    MOV B, A
    MOV A, R4
    SUBB A, B
    MOV B, R4
    MOV R6,B
    JNC CONTINUE

    SJMP CALC_FINISH

STEP:
    MOV R4, A
    MOV A, R5
    SUBB A, #0
    MOV R5, A
    INC DPTR
    SJMP MON_INC

CALC_FINISH:

DAY_OUT:
MOV A, R6
MOV B, #10
DIV AB            ;A 10k B1 k


MOV A, A
ADD A, #30H       ;to ascii (1k)
ACALL SEND_DATA


MOV A, B
ADD A, #30H       ;to ascii (10k)
ACALL SEND_DATA


MOV A, #20H ;spacebar
ACALL SEND_DATA


NEG:
	ADD A, #0FFH
	
NEG_NOT:
	PUSH B
	PUSH ACC
	INC R2
	ljmp MON_S
	
Lplus_INP:
	MOV A, #01H
	acall SEND_COMMAND
	MOV A, #80H
	acall SEND_COMMAND
	ENDLOOP: sjmp ENDLOOP
	
OUT_I_S:
	mov	DPTR, #INPUT_S
	MOV R1, #6
	
OUT_S:
	MOV A, #0
	MOVC A, @A+DPTR
	acall SEND_DATA
	INC DPTR
	DJNZ R1, OUT_S
	RET



CONFIGURE_LCD:
	mov a,#38H
	acall SEND_COMMAND
	mov a,#0FH
	acall SEND_COMMAND
	mov a,#06H
	acall SEND_COMMAND
	mov a,#01H
	acall SEND_COMMAND
	mov a,#80H
	acall SEND_COMMAND
	ret


SEND_COMMAND:
	mov p1,a ;A -> LCD
	clr p3.5 ;RS=0
	clr p3.6 ;R/W=0
	setb p3.7 ;enabler
	acall DELAY
	clr p3.7
	ret


SEND_DATA:
	mov p1,a ;A -> LCD
	setb p3.5 ;RS=1
	clr p3.6 ;R/W=0
	setb p3.7 ;enabler
	acall DELAY
	clr p3.7
	ret

DELAY:
	push 0
	push 1
	mov r0,#50


DELAY_OUTER_LOOP:
	mov r1,#255
	djnz r1,$
	djnz r0,DELAY_OUTER_LOOP
	pop 1
	pop 0
	ret


KEYBOARD: ;key input to A
	mov P0, #0ffh

	
KEYBOARD1:
	mov P2, #0	;make all ground
	mov A, P0
	anl A, #00001111B
	cjne A, #00001111B, KEYBOARD1

	
KEYBOARD2:

	acall DELAY
	mov A, P0
	anl A, #00001111B
	cjne A, #00001111B, KEYBOARD_OVER
	sjmp KEYBOARD2

	
KEYBOARD_OVER:
	acall DELAY
	mov A, P0
	anl A, #00001111B
	cjne A, #00001111B, KEYBOARD_OVER0
	sjmp KEYBOARD2

	
KEYBOARD_OVER0:
	mov P2, #11111110B
	mov A, P0
	anl A, #00001111B
	cjne A, #00001111B, RW0
	
	mov P2, #11111101B
	mov A, P0
	anl A, #00001111B
	cjne A, #00001111B, RW1
	
	mov P2, #11111011B
	mov A, P0
	anl A, #00001111B
	cjne A, #00001111B, RW2
	
	mov P2, #11110111B
	mov A, P0
	anl A, #00001111B
	cjne A, #00001111B, RW3
	
	ljmp KEYBOARD2


RW0:
	mov DPTR, #KY0
	sjmp KEYBOARD_FINDER
	
	
RW1:
	mov DPTR, #KY1
	sjmp KEYBOARD_FINDER
	
	
RW2:
	mov DPTR, #KY2
	sjmp KEYBOARD_FINDER
	
	
RW3:
	mov DPTR, #KY3
	
	
KEYBOARD_FINDER:
	rrc A
	jnc KEYBOARD_MATCHER
	inc DPTR
	sjmp KEYBOARD_FINDER
	
KEYBOARD_MATCHER:
	clr A
	movc A, @A+DPTR;take the ascii
	ret

END
