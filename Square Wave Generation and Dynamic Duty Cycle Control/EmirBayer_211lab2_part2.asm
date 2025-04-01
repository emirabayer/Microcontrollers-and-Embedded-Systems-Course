ORG 0
; Emir Arda Bayer 22201832 EEE212 Lab3Part2

	acall	CONFIGURE_LCD
	MOV R5, #0 ;latest value of input period
	MOV R4, #0 ;latest value of input duty
	MOV R2, #0 ;binary value to dictate whether if period is inputted or not

	PERIODTEXT1:
	MOV DPTR, #PERIOD_TEXT1
	MOV R1, #4
	PERIODTEXTLOOP1:
	MOV A, #0
	MOVC A, @A+DPTR
	acall SEND_DATA
	INC DPTR
	DJNZ R1, PERIODTEXTLOOP1

KEYBOARD_LOOP:
	acall KEYBOARD ;now, A has the key pressed
	MOV R3, A

	CJNE R2, #0, INPUT_DUTY
	CJNE A, #'A', INPUT_PERIOD
	INC R2
	PERIODTEXT2:
	MOV DPTR, #PERIOD_TEXT2
	MOV R1, #3
	PERIODTEXTLOOP2:
	MOV A, #0
	MOVC A, @A+DPTR
	acall SEND_DATA
	INC DPTR
	DJNZ R1, PERIODTEXTLOOP2
	DUTYTEXT:
	MOV A, #0C0h       ; LCD move cursor to second line
	acall SEND_COMMAND
	CLR A
	MOV DPTR, #DUTY_TEXT
	MOV R1, #13
	DUTYTEXTLOOP:
	MOV A, #0
	MOVC A, @A+DPTR
	acall SEND_DATA
	INC DPTR
	DJNZ R1, DUTYTEXTLOOP
	SJMP KEYBOARD_LOOP

	INPUT_PERIOD:
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

	INPUT_DUTY:
	CJNE A, #'A', INPUT_DUTY_FUNC
	SJMP PWM_FUNC
	INPUT_DUTY_FUNC:
	CLR C
        SUBB A, #30h ; to convert ascii to actual one digit hexa/decimal value
        PUSH ACC

        MOV A, #10
	MOV B, R4
	MUL AB
	MOV R4, A

	POP ACC
	ADD A, R4
	MOV R4, A ; latest value of input num
	MOV A, R3
	acall SEND_DATA
	sjmp KEYBOARD_LOOP



	PWM_FUNC:
	; at this point R5 has the period (ms) and R4 has the duty cycle (%)
	MOV A, R5
	MOV 38h, A ; store the period without changing it again through the code
	PUSH 5
	MOV A, R5
	MOV B, #10
	DIV AB ; quotient(A) = period/10, remainder(B) = 0
	MOV R5, A ; R5 has period/10
	MOV A, R4
	MOV B, #10
	DIV AB ; quotient(A) = duty/10, remainder(B) = 0
	MOV B, A ; B has duty/10
	MOV A, R5 ; A has period /10
	MUL AB
	MOV R7, A ; R7 has amount of time high part takes in ms, B = 0
	POP ACC
	CLR C
	SUBB A, R7
	MOV R6, A ; R6 has amount of time low part takes in ms
	SECONDWAVEVALS:
	MOV B, #2
	MOV A, R7
	DIV AB
	MOV 30h, A ; high part
	MOV A, 38h
	SUBB A, 30h
	MOV 31h, A ; low part


	FINDTIMERVAL:
	MOV A, 30h
	LCALL COMPARE_ACC_WITH_65
	; here R2 has high byte and R3 has low byte of SECOND PWM's high part, R1 dictates if +65536 MC is needed
	MOV A, R2
	MOV 40h, A
	MOV A, R3
	MOV 41h, A
	MOV A, R1
	MOV 42h, A ; in fact will never be 1 in this manual's case
	; 40h-41h carries SECOND PWM high part info, 42h dictates additional cycle

	MOV A, 31h
	LCALL COMPARE_ACC_WITH_65
	; here R2 has high byte and R3 has low byte of SECOND PWM's low part, R1 dictates if +65536 MC is needed
	MOV A, R2
	MOV 50h, A
	MOV A, R3
	MOV 51h, A
	MOV A, R1
	MOV 52h, A
	; 50h-51h carries SECOND PWM low part info, 52h dictates additional cycle


	MOV A, R7
	LCALL COMPARE_ACC_WITH_65
	; here R2 has high byte and R3 has low byte of PWM's high part, R1 dictates if additional 65536 MC is needed
	PUSH 2
	PUSH 3
	PUSH 1
	; PWM's high part's information in stack

	MOV A, R6
	MOV R1, #0
	LCALL COMPARE_ACC_WITH_65
	; here R2 has high byte and R3 has low byte of PWM's low part, R1 dictates if additional 65536 MC is needed
	POP 0
	POP 7
	POP 6
	; now R6-R7 carries PWM high part, R0 dictates additional cycle

	CALC_AMOUNT_OF_CYCLES:
	; for 2 sec cycles
	MOV A, 38h ; A has the period (ms), can only be one of 20 ms, 40 ms, 100 ms (as given in the manual)
	try20: CJNE A, #20, try40
	MOV R4, #100
	SJMP SAVECYCLENUM
	try40: CJNE A, #40, itis100
	MOV R4, #50
	SJMP SAVECYCLENUM
	itis100: MOV R4, #20
	SAVECYCLENUM:
	MOV A, R4
	MOV 39h, A ; 39h carries the total amount of cycles for 2 sec without changing through code
	MOV B, #2
	DIV AB
	MOV 49h, A; for 1 sec cycles, amount of cycles is multiplied by 1/2 into 49h
	INC 39h
	INC 49h

;	PUSH ACC
;	MOV A, 49h
;	MOV B, #10
;	DIV AB
;	ADD A, #30h
;	acall send_data
;	POP ACC





	TIMER_FUNC:
	MOV TMOD, #00010001b
	MOV A, 39h
	MOV R4, A
	two:
	DJNZ R4, BACK2SEC
	MOV A, 49h
	MOV R4, A
	one:
	DJNZ R4, BACK1SEC
	MOV A, 39h
	MOV R4, A
	SJMP two

		BACK2SEC:
		CLR TR0
		SETB P0.4
		MOV TH0, R6
		MOV TL0, R7
		CLR TF0
		SETB TR0
		JNB TF0, $
		CJNE R0, #1, LOW2
		CLR TF0
		JNB TF0, $ ; two lines for additional 65536 MC
		LOW2:
		CLR TR0
		CLR P0.4
		CLR TF0
		MOV TH0, R2
		MOV TL0, R3
		SETB TR0
		JNB TF0, $
		CJNE R1, #1, two
		CLR TF0
		JNB TF0, $ ; two lines for additional 65536 MC
		SJMP two

		BACK1SEC:
		CLR TR0
		SETB P0.4
		MOV TH0, 40h
		MOV TL0, 41h
		CLR TF0
		SETB TR0
		JNB TF0, $
		MOV A, 42h
		CJNE A, #1, LOW1
		CLR TF0
		JNB TF0, $ ; two lines for additional 65536 MC
		LOW1:
		CLR TR0
		CLR P0.4
		CLR TF0
		MOV TH0, 50h
		MOV TL0, 51h
		SETB TR0
		JNB TF0, $
		MOV A, 52h
		CJNE A, #1, one
		CLR TF0
		JNB TF0, $ ; two lines for additional 65536 MC
		SJMP one









COMPARE_ACC_WITH_65: ; a subroutine that compares the value of A for the timer, is pwm's high/low > 65536 ?
CLR C
MOV R1, #0
MOV B, #65
CJNE A, B, NOT_EQUAL
SJMP A_LESS

	NOT_EQUAL:
		JC A_LESS
	    	; A > B here
	    	MOV R1, #1 ; a bit that indicates whether if an additional 65536 MC needs to be waited
		SUBB A, #65
		SUBB A, #1
		MOV R2 ,A
		MOV A, #65
		SUBB A, R2
		ADD A, #1
		MOV R0, A
		; here total time to pass is R0464 + 65536
		; we need to convert R0464 to hexa to place into TH, TL (mode 1)
		MOV R3, #48h
		MOV R2, #0h
		BACK_HIGHER:
		DJNZ R0, ADD1000TO072
		SJMP DONE

		ADD1000TO072:
		CLR C
		MOV A, #0E8h
		ADD A, R3
		MOV R3, A
		MOV A, #3h
		ADDC A, R2
		MOV R2, A
		SJMP BACK_HIGHER

		A_LESS:
		; A =< B here
		CLR C
		MOV B, A
		MOV A, #65
		SUBB A, B
		ADD A, #1
		MOV R0, A
		; here total time to pass is R0536 (like 29536 for period 60ms duty 60%)
		; we need to convert R0536 to hexa to place into TH, TL (mode 1)
		MOV R3, #18h
		MOV R2, #2h
		BACK_LESS:
		DJNZ R0, ADD1000TO536
		SJMP DONE

		ADD1000TO536:
		CLR C
		MOV A, #0E8h
		ADD A, R3
		MOV R3, A
		MOV A, #3h
		ADDC A, R2
		MOV R2, A
	    	SJMP BACK_LESS

	DONE:
	; here R2 has the high byte of timer, R3 has the low byte
	RET






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

PERIODS: DB	'20', '40', '60', '80', '100'
DUTYCYCLES: DB	'10', '20', '30', '40', '50', '60', '70', '80', '90'

PERIOD_TEXT1: DB 'T = '
PERIOD_TEXT2: DB ' ms'
DUTY_TEXT: DB 'Duty Cycle = '


END



