#include "utils.h"
#include <MKL25Z4.H>
#include <stdio.h>


//Emir Arda Bayer 22201832 Lab3c

int main(void){
	int direction = 0;

	uint32_t counter = 0;

	int delay = 100;
               int del = 0;
	
	// following are the port selections
	
	SIM->SCGC5 |= 0x1000;      // en clock Port D
	SIM->SCGC5 |= 0x400;       // en clock Port B

	PORTD->PCR[0] = 0x100;      // PTD0 GPIO

	PORTD->PCR[1] = 0x100;      // PTD1 GPIO
	PORTD->PCR[2] = 0x100;      // PTD2 GPIO
	PORTD->PCR[4] = 0x100;      // PTD3 GPIO

	PORTB->PCR[0] = 0x103;     
	PORTB->PCR[1] = 0x103;     
	PORTB->PCR[2] = 0x103;
		// -----------------------------------	
	PTD->PDDR |= 0x1 | 0x2 | 0x4 | 0x10;
		// -----------------------------------


	while(1){
		if (PTB -> PDIR & 0x01)
			direction = 1;
		else
			direction = 0;
		if (direction){
			counter = Countinc(counter);
		}

		else{
			counter = Countdec(counter);
		}


		if (PTB->PDIR==0x04){
			del = 2000000;}


		else if (PTB->PDIR==0x02){
			del = 1000000;}


		else if (PTB->PDIR==0x06){
			del = 500000;}


		else if (PTB->PDIR==0x00){
			del = 0;}


		else if (PTB->PDIR==0x05){
			del = 2000000;}


		else if (PTB->PDIR==0x03){
			del = 1000000;}


		else if (PTB->PDIR==0x07){
			del = 500000;}


		else if (PTB->PDIR==0x01){
			del = 0;}



		int pzero = counter & 0x1;
		int pone = counter & 0x2;
		int ptwo = counter & 0x4;
		int pthree = counter & 0x8;
		


		if (pzero)
			PTD->PDOR |= 0x1;
		else
			PTD->PCOR |= 0x1;



		
			if (pone)
				PTD->PDOR |= 0x2;
			else
				PTD->PCOR |= 0x2;


		
				if (ptwo)
					PTD->PDOR |= 0x4;

				else
					PTD->PCOR |= 0x4;
		
					if (pthree)
						PTD->PDOR |= 0x10;
					else
						PTD->PCOR |= 0x10;

		
		delay = Delaytrue();
		Delay(del);
		
		if (counter == 15)
			counter = 0;
	
}

//return 0
return 0;
}
