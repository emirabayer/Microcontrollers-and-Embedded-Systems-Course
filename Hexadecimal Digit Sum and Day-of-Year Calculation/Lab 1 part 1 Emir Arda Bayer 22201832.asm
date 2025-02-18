;Lab 1 part 1 Emir Arda Bayer 22201832

ORG 0H

MOV R0,#88H ;XYh=KLMd -> R0
MOV A,R0
MOV B,#100
DIV AB ;A=KLM/100=K, B(remainder)=LM
MOV R2,A ;input<100 -> R3=0 works fine, input>99 -> A=R3=K necessary to keep the leftmost digit
MOV A,B
MOV R3, #10
MOV B,R3
DIV AB ;A=L and B=M
ADD A,B ;A=L+M
MOV B,R2 ;B=K
ADD A,B ;A=K+L+M
MOV R1,A

STOP: SJMP STOP

END
 