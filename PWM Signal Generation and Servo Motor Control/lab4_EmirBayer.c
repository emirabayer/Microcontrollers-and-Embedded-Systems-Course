#include <stdio.h>

#include <MKL25Z4.H>

#define HOLD(x) (1UL << (x))
#define HZ_VALUE_TPM 21600000  // Clock frequency in Hz for TPM
#define HZ_VALUE_PWM 50        // Desired PWM frequency for servo control
#define SETTING_PS 16            // TPM setting_ps setting

void launch_p_w_m(void);
void select_pos_for_motor(int time_length_of_one_pulse);

void PORTD_IRQHandler(void);
void intrr_but(void);

void Wait_func(volatile unsigned int value_for_time_waiting);

volatile int placement = 0;


int main(void) {
    launch_p_w_m();
    intrr_but();								  //interrupt for button of setup

		
    while (1) {
        if (placement == 0) {
            select_pos_for_motor(750);  
						Wait_func(950413);
						if (placement == 1) {
								continue;
						}
						
						
						
            select_pos_for_motor(1078); 
						Wait_func(950413);
						if (placement == 1) {
								continue;
						}
						
						
            select_pos_for_motor(1460); 
						Wait_func(950413);
						if (placement == 1) {
								continue;
						}
						
						
            select_pos_for_motor(2080); 
						Wait_func(950413);
						if (placement == 1) {
								continue;
						}

						
            select_pos_for_motor(1460); 
						Wait_func(950413);
						if (placement == 1) {
								continue;
						}
						
						
            select_pos_for_motor(1078); 
						Wait_func(950413);
            if (placement == 1) {
								continue;
						}
						
						
						
        } else {
            select_pos_for_motor(3300);  
						Wait_func(950413);
					if (placement == 0) {
								continue;
						}
					
						
            select_pos_for_motor(2900);  
						Wait_func(950413);
						if (placement == 0) {
								continue;
						}
						
						
						
            select_pos_for_motor(2534);  
						Wait_func(950413);
						if (placement == 0) {
								continue;
						}
						
						
						
            select_pos_for_motor(2080);  
						Wait_func(950413);
						if (placement == 0) {
								continue;
						}
						
						
            select_pos_for_motor(2534);  
						Wait_func(950413);
						if (placement == 0) {
								continue;
						}
						
            select_pos_for_motor(2900);  
						Wait_func(950413);
						if (placement == 0) {
								continue;
						}
        }
    }

    return 0;
}


void launch_p_w_m(void) {
  // enable clock PORT E
  SIM->SCGC5 |= SIM_SCGC5_PORTE_MASK;

  // set the pin pte20 tpm1 channel-0 (output of pwm)
  PORTE->PCR[20] = PORT_PCR_MUX(3);

  // en clock tpm1 module
  SIM->SCGC6 |= SIM_SCGC6_TPM1_MASK;

  // config tpm1 clock source (oscillator clock)
  SIM->SOPT2 |= SIM_SOPT2_TPMSRC(1);

  // initialize tpm1 counter, status register (SC)
  TPM1->SC = 0;

  // set both MSB and ELSB bits (do this in channel 0 CnSC register to obtain the output mode)
  TPM1->CONTROLS[0].CnSC = TPM_CnSC_MSB_MASK | TPM_CnSC_ELSB_MASK;

  // calculate and set modulus value to obtain the desired frequency of pwm
  TPM1->MOD = (HZ_VALUE_TPM / (SETTING_PS * HZ_VALUE_PWM)) - 1;

  // set the first duty cycle (750 for 50 percent duty cycle)
  TPM1->CONTROLS[0].CnV = 750;

  // config tpm1's clock prescaler, en tpm1's counter
  TPM1->SC = TPM_SC_CMOD(1) | TPM_SC_PS(4);
}

void select_pos_for_motor(int time_length_of_one_pulse) {
  // update duty cycle and do this by setting the CnV register
  TPM1->CONTROLS[0].CnV = time_length_of_one_pulse;
}

void Wait_func(volatile unsigned int value_for_time_waiting) {
  // time consuming loop for wait or delay
  while (value_for_time_waiting--) {
    // loop is empty
  }
}

void intrr_but(void) {
  // en port D clock
  SIM->SCGC5 |= SIM_SCGC5_PORTD_MASK;

  // cnfig ptd6 (PORTD[6]) as GPIO, that has a pull-up resistor and one interrupt for falling edge
  PORTD->PCR[6] = PORT_PCR_MUX(1) |     // MUX is GPIO
                  PORT_PCR_PE_MASK |     // en pull up
                  PORT_PCR_PS_MASK |     // select pull, and make it pull up
                  PORT_PCR_IRQC(0xA);     // cnfig the interrupt for falling edge by taking value 1010

  // en interrupt of port D in NVIC
  NVIC_EnableIRQ(PORTD_IRQn);
}

void PORTD_IRQHandler(void) {
    // clr intrr flag, do this by making ISFR register 1
    PORTD->ISFR = 0xffffffff;  // clr PTA1 intrr

    // switcher
    placement = !placement;
}
