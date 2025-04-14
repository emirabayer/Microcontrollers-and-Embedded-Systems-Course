#include <MKL25Z4.H>
#include <stdio.h>
#include <math.h>
#include "utils.h"


int currentLED = 0;      // index of the current LED (0-4)
int direction = 1;       // 1 = forward, -1 = backward
uint32_t delayTime = 2000000;
int twoballMode = -1;     // -1 = single ball, 1 = two ball


int main(void){
	
	SIM->SCGC5 |= SIM_SCGC5_PORTD_MASK;  // PTD clock for LEDs
  SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK;  // PTB clock for buttons

  PORTD->PCR[1] = 0x100;  // configuring PTD 1,2,3,4,5 ports as GPIO 
	PORTD->PCR[2] = 0x100;
	PORTD->PCR[3] = 0x100;
	PORTD->PCR[4] = 0x100;
	PORTD->PCR[5] = 0x100;
	PTD->PDDR |= (1UL << 1)| (1UL << 2)| (1UL << 3)| (1UL << 4)| (1UL << 5) ;  // configuring as outputs
	
	PORTB->PCR[1] = 0x103; // configuring PTB 1,2,3 as GPIO and pullup
	PORTB->PCR[2] = 0x103;
	PORTB->PCR[3] = 0x103;
	
	PTB->PDDR &= ~(1UL << 1); // configuring as inputs
	PTB->PDDR &= ~(1UL << 2);
	PTB->PDDR &= ~(1UL << 3);
	
	while(1) {
		
			PTD->PCOR = (1UL << 1)| (1UL << 2)| (1UL << 3)| (1UL << 4)| (1UL << 5);

		
      if (twoballMode == -1) {
          // Single ball mode
          PTD->PSOR = (1 << currentLED + 1);
      } else {
          // Two ball mode
          PTD->PSOR = (1 << currentLED + 1) | (1 << (currentLED + 2));
      }

			
			
			if (!(PTB->PDIR & (1UL << 1))) {
				if (delayTime == 500000) {
            delayTime = 2000000;
        } 
				else {
            delayTime = 500000;
				}
			}
			
				
				
			if (!(PTB->PDIR & (1UL << 2))) {
				direction = -direction;
			}
			

			
      if (!(PTB->PDIR & (1UL << 3))) {
        twoballMode = -twoballMode;
            
        // reset position when entering two-ball mode
        if (twoballMode == 1) {
          currentLED = -1;
          direction = 1;
        } 
				else {
          // when returning to single-ball mode, reset to LED 1
          currentLED = -1;
          direction = 1;
        }
      }
	
	
			
			// Delay based on current speed
      Delay(delayTime);
			
			
			
			if (twoballMode == -1) {
				currentLED += direction;
				
				if (currentLED == 4) {
					currentLED = 4;
					direction = -1;
				}
				else if (currentLED == 0) {
					currentLED = 0;
					direction = 1;
				}
			}
			else {
				currentLED += direction;
				
				if (currentLED == 3) {
					currentLED = 3;
					direction = -1;
				}
				else if (currentLED == 0) {
					currentLED = 0;
					direction = 1;
				}
			
			}
			
			
			
			
	}
return 0;	
}