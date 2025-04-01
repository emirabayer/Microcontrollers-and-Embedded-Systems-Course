ORG 0
; Emir Arda Bayer 22201832 EEE212 Lab2Part2

	acall	CONFIGURE_LCD
	MOV R5, #0 ;latest value of input

	NUMTEXT:
	MOV DPTR, #NUMBER_TEXT
	MOV R1, #4
	NUMTEXTLOOP:
	MOV A, #0
	MOVC A, @A+DPTR
	acall SEND_DATA
	INC DPTR
	DJNZ R1, NUMTEXTLOOP

KEYBOARD_LOOP:
	acall KEYBOARD ;now, A has the key pressed
	MOV R4, A ;to save ascii value for later printing

	CJNE A, #'A', INPUT_NUM
	MOV A, #0C0h       ; LCD move cursor to second line
	acall SEND_COMMAND
	CLR A
	OUTTEXT:
	MOV DPTR, #OUT_TEXT
	MOV R1, #9
	OUTTEXTLOOP:
	MOV A, #0
	MOVC A, @A+DPTR
	acall SEND_DATA
	INC DPTR
	DJNZ R1, OUTTEXTLOOP
	SJMP CALCULATE

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
	MOV A, R4
	acall SEND_DATA
	SJMP KEYBOARD_LOOP


	CALCULATE:
	; at this point, R5 = n ,decimal [0-24]
	MOV R0, #0h ; first 16 bit num R0-R1
	MOV R1, #0h ; initially 0 as F(0)=0
	MOV R6, #0h ; second 16 bit num R6-R7
	MOV R7, #1h ; initially 1 as F(1)=1

	CHECK0:
	CJNE R5, #0h, CHECK1
	MOV A, R1
	ADD A, #30h
	acall SEND_DATA
	SJMP KEYBOARD_LOOP

	CHECK1:
	CJNE R5, #1h, FIBO_LOOP
	MOV A, R7
	ADD A, #30h
	acall SEND_DATA
	SJMP KEYBOARD_LOOP

	FIBO_LOOP:
	DEC R5 ; we need the loop to turn n-1 times to find each F(n), n>1
	BACK5:
	MOV A, R6 ; these four lines are to begin decrementing the position of the larger num
	MOV B, R7
	PUSH ACC
	PUSH B

	CLR C
	MOV A, R1
	ADD A, R7
	MOV R7, A ; next Fibonacci number's low byte is saved
	MOV A, R0
	ADDC A, R6
	MOV R6,A ; next Fibonacci number's high byte is saved

	POP B ; these four lines are to finish decrementing the position of the larger num
	POP ACC
	MOV R0, A
	MOV R1, B ; now, prev R6-R7 holder num is in R0-R1

	DJNZ R5, BACK5
	; at this point, R6-R7 has the Fibonacci value we want to print


	DECIMAL_CONVERSION_FUNC: ;saves all digits into stack
	MOV A, R6 ;saving hexa digits into R0-R1-R2-R3 ex:1A65h
	ANL A, #0F0h
	RRC A
	RRC A
	RRC A
	RRC A
	CLR C
	MOV R0, A

	MOV A, R6
	ANL A, #0Fh
	MOV R1, A

	MOV A, R7
	ANL A, #0F0h
	RRC A
	RRC A
	RRC A
	RRC A
	CLR C
	MOV R2, A

	MOV A, R7
	ANL A, #0Fh
	MOV R3, A

	FIRSTDIG: ;finding the first digit of decimal output
	MOV R5, #0
	MOV A, R0
	MOV B, #6
	MUL AB
	ADD A, R5
	MOV R5, A

	MOV A, R1
	MOV B, #6
	MUL AB
	ADD A, R5
	MOV R5, A

	MOV A, R2
	MOV B, #6
	MUL AB
	ADD A, R5
	MOV R5, A

	MOV A, R3
	MOV B, #1
	MUL AB
	ADD A, R5
	MOV R5, A

	MOV B, #10
	DIV AB ; remainder (B) = this digit, quotient (A) = carry to use while finding the next digit
	MOV R4, A ; save quotient to use in next dig calc
	MOV A, B
	ADD A, #30h
	PUSH ACC

	SECONDDIG:
	MOV A, R4
	MOV R5, A
	MOV A, R0
	MOV B, #9
	MUL AB
	ADD A, R5
	MOV R5, A

	MOV A, R1
	MOV B, #5
	MUL AB
	ADD A, R5
	MOV R5, A

	MOV A, R2
	MOV B, #1
	MUL AB
	ADD A, R5
	MOV R5, A

	MOV B, #10
	DIV AB ; remainder = this digit, quotient = carry to use while finding the next digit
	MOV R4, A ; save quotient to use in next dig calc
	MOV A, B
	ADD A, #30h
	PUSH ACC

	THIRDDIG:
	MOV A, R4
	MOV R5, A

	MOV A, R1
	MOV B, #2
	MUL AB
	ADD A, R5
	MOV R5, A

	MOV B, #10
	DIV AB ; remainder = this digit, quotient = carry to use while finding the next digit
	MOV R4, A ; save quotient to use in next dig calc
	MOV A, B
	ADD A, #30h
	PUSH ACC

	FOURTHDIG:
	MOV A, R4
	MOV R5, A

	MOV A, R0
	MOV B, #4
	MUL AB
	ADD A, R5
	MOV R5, A

	MOV B, #10
	DIV AB ; remainder = this digit, quotient = carry to use while finding the next digit
	MOV R4, A ; save quotient to use in next dig calc
	MOV A, B
	ADD A, #30h
	PUSH ACC

	FIFTHDIG:
	MOV A, R4 ;max 6
	ADD A, #30h
	PUSH ACC



	PRINT_FUNC:
	MOV R0, #5
	CHECK_ZERO:
	POP ACC
	DEC R0
	CJNE A, #30h, CAN_PRINT
	SJMP CHECK_ZERO
	CAN_PRINT:
	acall SEND_DATA
	FINAL_PRINT_LOOP:
	POP ACC
	acall SEND_DATA
	DJNZ R0, FINAL_PRINT_LOOP




	ljmp KEYBOARD_LOOP




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

NUMBER_TEXT: DB 'n = '
OUT_TEXT: DB 'Fib(n) = '

END
