ORG 0                      ; Setting starting address to 0

; generate two square waveforms of specified frequencies and duty cycles, simultaneously


BEGINNING:
JNB P2.5, FIRST      ; Jump to FIRST if P2.5 is low

THIRD:
    CLR P2.7              ; Clear P2.7 (start first wave low)
    MOV TMOD, #11H        ; Configure timer 0 as 16-bit mode
    MOV TH0, #0FAH        ; Load high byte for timer 0 count
    MOV TL0, #4BH         ; Load low byte for timer 0 count
    CLR TF0               ; Clear timer 0 overflow flag
    SETB TR0              ; Start timer 0

SECOND:
    JNB TF0, SECOND       ; Wait for timer 0 overflow
    SETB P2.7              ; Set P2.7 high (first wave high)
    CLR P2.6              ; Clear P2.6 (start second wave low)


    MOV TMOD, #11H        ; Configure timer 0 as 16-bit mode
    MOV TH0, #0FAH        ; Load high byte for timer 0 count
    MOV TL0, #4BH         ; Load low byte for timer 0 count
    CLR TF0               ; Clear timer 0 overflow flag
    SETB TR0              ; Start timer 0
    
LOOPP: 
    JNB TF0, LOOPP

    CLR P2.7

    MOV TMOD, #11H        ; Configure timer 0 as 16-bit mode
    MOV TH0, #0FAH        ; Load high byte for timer 0 count
    MOV TL0, #4BH         ; Load low byte for timer 0 count
    CLR TF0               ; Clear timer 0 overflow flag
    SETB TR0              ; Start timer 0

    
LOOPP2: 
    JNB TF0, LOOPP2
    SETB P2.7
    SETB P2.6

    MOV TMOD, #11H        ; Configure timer 0 as 16-bit mode
    MOV TH0, #0FAH        ; Load high byte for timer 0 count
    MOV TL0, #4BH         ; Load low byte for timer 0 count
    CLR TF0               ; Clear timer 0 overflow flag
    SETB TR0              ; Start timer 0
    
LOOPP3: 
    JNB TF0, LOOPP3



LJMP BEGINNING        ; Endless loop to repeat

FIRST:
    JB P2.5, THIRD        ; Jump to THIRD if P2.5 is high

    SETB P2.6              ; Set P2.6 high
    SETB P2.7              ; Set P2.7 high

    MOV TMOD, #11H        ; Configure timer 1 as 16-bit mode
    MOV TH1, #0FDH        ; Load high byte for timer 1 count
    MOV TL1, #029H         ; Load low byte for timer 1 count
    CLR TF1               ; Clear timer 1 overflow flag
    SETB TR1              ; Start timer 1LOOPP4: JNB TF1, LOOPP4
    
CLR P2.6


    MOV TMOD, #11H        ; Configure timer 1 as 16-bit mode
    MOV TH1, #0FDH        ; Load high byte for timer 1 count
    MOV TL1, #029H         ; Load low byte for timer 1 count
    CLR TF1               ; Clear timer 1 overflow flag
    SETB TR1              ; Start timer 1LOOPP4: JNB TF1, LOOPP4
    
LOOPP5: 
    JNB TF1, LOOPP5
    CLR P2.7


    MOV TMOD, #11H        ; Configure timer 1 as 16-bit mode
    MOV TH1, #0FDH        ; Load high byte for timer 1 count
    MOV TL1, #029H         ; Load low byte for timer 1 count
    CLR TF1               ; Clear timer 1 overflow flag
    SETB TR1              ; Start timer 1LOOPP4: JNB TF1, LOOPP4

    
LOOPP6: 
    JNB TF1, LOOPP6

    MOV TMOD, #11H        ; Configure timer 1 as 16-bit mode
    MOV TH1, #0FDH        ; Load high byte for timer 1 count
    MOV TL1, #029H         ; Load low byte for timer 1 count
    CLR TF1               ; Clear timer 1 overflow flag
    SETB TR1              ; Start timer 1LOOPP4: JNB TF1, LOOPP4

    
LOOPP7: 
    JNB TF1, LOOPP7

    SETB P2.6

    MOV TMOD, #11H        ; Configure timer 1 as 16-bit mode
    MOV TH1, #0FDH        ; Load high byte for timer 1 count
    MOV TL1, #029H         ; Load low byte for timer 1 count
    CLR TF1               ; Clear timer 1 overflow flag
    SETB TR1              ; Start timer 1LOOPP4: JNB TF1, LOOPP4

    
LOOPP8: 
    JNB TF1, LOOPP8
    CLR P2.6

    MOV TMOD, #11H        ; Configure timer 1 as 16-bit mode
    MOV TH1, #0FDH        ; Load high byte for timer 1 count
    MOV TL1, #029H         ; Load low byte for timer 1 count
    CLR TF1               ; Clear timer 1 overflow flag
    SETB TR1              ; Start timer 1LOOPP4: JNB TF1, LOOPP4

    
LOOPP9: 
    JNB TF1, LOOPP9

    MOV TMOD, #11H        ; Configure timer 1 as 16-bit mode
    MOV TH1, #0FDH        ; Load high byte for timer 1 count
    MOV TL1, #029H         ; Load low byte for timer 1 count
    CLR TF1               ; Clear timer 1 overflow flag
    SETB TR1              ; Start timer 1LOOPP4: JNB TF1, LOOPP4

    
LOOPP10: 
    JNB TF1, LOOPP10

    MOV TMOD, #11H        ; Configure timer 1 as 16-bit mode
    MOV TH1, #0FDH        ; Load high byte for timer 1 count
    MOV TL1, #029H         ; Load low byte for timer 1 count
    CLR TF1               ; Clear timer 1 overflow flag
    SETB TR1              ; Start timer 1LOOPP4: JNB TF1, LOOPP4
    
LOOPP11: 
    JNB TF1, LOOPP11

    
SETB P2.7


LJMP FIRST



END
