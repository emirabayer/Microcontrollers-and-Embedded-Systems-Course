ORG 0
; Emir Arda Bayer 22201832 EEE212 Lab2Part1

	acall	CONFIGURE_LCD
	MOV R2, #0 ;binary value to check if num entered
	MOV R5, #0 ;latest value of input
;	MOV R6, #1 ;to multiply by 10^x (x: current number of digits in input number)

	NUMTEXT:
	MOV DPTR, #NUMBER_TEXT
	MOV R1, #9
	NUMTEXTLOOP:
	MOV A, #0
	MOVC A, @A+DPTR
	acall SEND_DATA
	INC DPTR
	DJNZ R1, NUMTEXTLOOP



KEYBOARD_LOOP:
	acall KEYBOARD ;now, A has the key pressed
	MOV R3, A

	CJNE R2,#0, INPUT_BASE2 ; jump if num entered
	CJNE A, #'A', INPUT_NUM
	SJMP INPUT_BASE1

	INPUT_NUM:
        CLR C
        SUBB A, #30h ; to convert ascii to actual one digit hexa/decimal value
        PUSH ACC

        MOV A, #10
	MOV B, R5
	MUL AB
	MOV R5, A

	POP ACC
	ADD A, R5
	MOV R5, A ; latest value of input num
	MOV A, R3
	acall SEND_DATA
	sjmp KEYBOARD_LOOP

	INPUT_BASE1:
	INC R2 ;save the info that num is entered
		MOV A, #0C0h       ; LCD move cursor to second line
	    	acall SEND_COMMAND
	    	CLR A
	    	BASETEXT:
		MOV DPTR, #BASE_TEXT
		MOV R1, #7
		BASETEXTLOOP:
		MOV A, #0
		MOVC A, @A+DPTR
		acall SEND_DATA
		INC DPTR
		DJNZ R1, BASETEXTLOOP
	SJMP KEYBOARD_LOOP

	INPUT_BASE2:
	acall SEND_DATA
		PUSH ACC
		acall	CONFIGURE_LCD
	    	RESULTTEXT:
		MOV DPTR, #RESULT_TEXT
		MOV R1, #8
		RESULTTEXTLOOP:
		MOV A, #0
		MOVC A, @A+DPTR
		acall SEND_DATA
		INC DPTR
		DJNZ R1, RESULTTEXTLOOP
		POP ACC
	CLR C
	SUBB A, #30h ; to convert ascii to actual hexa value
	MOV R7, A ; store base in R7 (2, 4 or 8)

	CALCULATE:
	; at this point, R5 has the num, R7 has the base
	MOV R4, #0 ;to count the number of divisions (num of digits in result)
	MOV A, R5
		CONVERT:
		MOV B, R7
		DIV AB
		PUSH B
		INC R4
		JNZ CONVERT

		PRINT_FUNC:
		POP B
		MOV A,B
		ADD A, #30h
		acall SEND_DATA
		DJNZ R4, PRINT_FUNC






	sjmp KEYBOARD_LOOP



CONFIGURE_LCD:	;THIS SUBROUTINE SENDS THE INITIALIZATION COMMANDS TO THE LCD
	mov a,#38H	;TWO LINES, 5X7 MATRIX
	acall SEND_COMMAND
	mov a,#0FH	;DISPLAY ON, CURSOR BLINKING
	acall SEND_COMMAND
	mov a,#06H	;INCREMENT CURSOR (SHIFT CURSOR TO RIGHT)
	acall SEND_COMMAND
	mov a,#01H	;CLEAR DISPLAY SCREEN
	acall SEND_COMMAND
	mov a,#80H	;FORCE CURSOR TO BEGINNING OF THE FIRST LINE
	acall SEND_COMMAND
	ret



SEND_COMMAND:
	mov p1,a		;THE COMMAND IS STORED IN A, SEND IT TO LCD
	clr p3.5		;RS=0 BEFORE SENDING COMMAND
	clr p3.6		;R/W=0 TO WRITE
	setb p3.7	;SEND A HIGH TO LOW SIGNAL TO ENABLE PIN
	acall DELAY
	clr p3.7
	ret


SEND_DATA:
	mov p1,a		;SEND THE DATA STORED IN A TO LCD
	setb p3.5	;RS=1 BEFORE SENDING DATA
	clr p3.6		;R/W=0 TO WRITE
	setb p3.7	;SEND A HIGH TO LOW SIGNAL TO ENABLE PIN
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


KEYBOARD: ;takes the key pressed from the keyboard and puts it to A
	mov	P0, #0ffh	;makes P0 input
K1:
	mov	P2, #0	;ground all rows
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, K1
K2:
	acall	DELAY
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, KB_OVER
	sjmp	K2
KB_OVER:
	acall DELAY
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, KB_OVER1
	sjmp	K2
KB_OVER1:
	mov	P2, #11111110B
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, ROW_0
	mov	P2, #11111101B
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, ROW_1
	mov	P2, #11111011B
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, ROW_2
	mov	P2, #11110111B
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, ROW_3
	ljmp	K2
	
ROW_0:
	mov	DPTR, #KCODE0
	sjmp	KB_FIND
ROW_1:
	mov	DPTR, #KCODE1
	sjmp	KB_FIND
ROW_2:
	mov	DPTR, #KCODE2
	sjmp	KB_FIND
ROW_3:
	mov	DPTR, #KCODE3
KB_FIND:
	rrc	A
	jnc	KB_MATCH
	inc	DPTR
	sjmp	KB_FIND
KB_MATCH:
	clr	A
	movc	A, @A+DPTR; get ASCII code from the table 
	ret

;ASCII look-up table 
KCODE0:	DB	'1', '2', '3', 'A'
KCODE1:	DB	'4', '5', '6', 'B'
KCODE2:	DB	'7', '8', '9', 'C'
KCODE3:	DB	'*', '0', '#', 'D'

NUMBER_TEXT: DB 'NUMBER = '
BASE_TEXT: DB 'BASE = '
RESULT_TEXT: DB 'RESULT= '

END


