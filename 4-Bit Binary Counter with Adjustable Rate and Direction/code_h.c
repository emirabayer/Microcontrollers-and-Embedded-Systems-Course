#include <stdio.h>
#include <MKL25Z4.H>


//Emir Arda Bayer 22201832 Lab3h

uint32_t Countinc(uint32_t);

uint32_t Countdec(uint32_t);
int Directiontrue(void);
int Delaytrue(void);

void Delay(int);
void DisplayCounter(uint32_t,FGPIO_Type);

uint32_t Countinc(uint32_t counter){
	counter++;
return counter;
}

uint32_t Countdec(uint32_t counter){


	counter--;
return counter;
}

int Directiontrue(void){
	
		if (PTB->PDIR==0x0){ 		
		return 1;
}
		else{
		return 0;
}
}

int Delaytrue(void){
	return 1000;
}


void Delay(int delay){
	while(delay--){
}

		return;
}
