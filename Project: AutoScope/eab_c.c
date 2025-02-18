#include <MKL25Z4.H>

#define MASK(x) (1UL << (x))

#define TPM_Hz 21000000
#define PWM_Hz 50
#define TOUCH_SENSOR_PIN (1UL << 1) // Touch sensor connected to PE1
#define RED_LED_PIN (1UL << 18)     // Red LED connected to PTB18
#define BUZZER_PIN (1UL << 0)

#define RS MASK(12) /* PTA12 mask */
#define RW MASK(13) /* PTA13 mask */
#define EN MASK(16) /* PTA16 mask */



void LCD_command(unsigned char command);
void LCD_data(unsigned char data);
void LCD_init(void);
void displayDetectedMessage();
void displayinteruptMessage(void);

void ADC_init(void);
void PWM_init(void);
void delayMs(int n);

void PORTA_IRQHandler(void);
void configureButtonInterrupt(void);

int convert_to_binary(int value);
int result_0_bin;
int result_1_bin;
int a=1;

int pulseWidth_1;



int pulseWidth_2;




int main (void) {
	 LCD_init();
	 configureButtonInterrupt();
	PORTA_IRQHandler();
    PWM_init(); // Initialize the PWM for servo control
	
	
	 LCD_init();
	




		int pulseWidth_1 = ((TPM_Hz/(16*PWM_Hz))-1)*1.5/20;
		int pulseWidth_2 = ((TPM_Hz/(16*PWM_Hz))-1)*1.5/20;
	
	   SIM->SCGC5 |= (1UL << 10) | (1UL << 13);

    // Configure red LED pin (PTB18) as output
    PORTB->PCR[18] = (1UL << 8); // Set PTB18 to GPIO
    PTB->PDDR |= RED_LED_PIN;    // Set PTB18 as output
	
		// Configure GREEN LED pin (PTB18) as output
		PORTB->PCR[19] = (1UL << 8); // Set PTB18 to GPIO
    PTB->PDDR |= MASK(19);    // Set PTB18 as output

	// Configure buzz pin (PTB18) as output
		PORTB->PCR[2] = 0x102; // Set PTB18 to GPIO
    PTB->PDDR |= MASK(2);    // Set PTB18 as output
		
    // Configure touch sensor pin (PE1) as input
    PORTE->PCR[1] = (1UL << 8); // Set PE1 to GPIO
    PTE->PDDR &= ~TOUCH_SENSOR_PIN; // Set PE1 as input
		


    
		////////////////

	////////////////////////
    while (1) {
displayDetectedMessage();

			  // Check the status of the touch sensor
        if (PTE->PDIR & TOUCH_SENSOR_PIN) {
            // If touch sensor input is 1, turn on the red LED
            PTB->PCOR = MASK(19); // Turn on the red LED
					ADC_init(); // Initialize the ADC to read joystick inputs
			
      if (result_0_bin == 1 && pulseWidth_1 <= ((TPM_Hz/(16*PWM_Hz))-1)*2.5/20) {
					pulseWidth_1 += 15;//hiz
			} else if (result_0_bin == 0 && pulseWidth_1 >= ((TPM_Hz/(16*PWM_Hz))-1)*0.5/20) {
					pulseWidth_1 -= 15;
				
			}
		if (result_1_bin == 1 && pulseWidth_2 <= ((TPM_Hz/(16*PWM_Hz))-1)*2.5/20) {
					pulseWidth_2 += 15;
			
		} else if (result_1_bin == 0 && pulseWidth_2 >= ((TPM_Hz/(16*PWM_Hz))-1)*0.5/20) {
				pulseWidth_2 -= 15;
				
			}
			
			TPM0->CONTROLS[1].CnV = pulseWidth_1;
			TPM0->CONTROLS[2].CnV = pulseWidth_2;
			
			delayMs(5);
    }

         else {
            // If touch sensor input is 0, turn off the red LED
            PTB->PSOR = MASK(19); // Turn off the red LED
        }



}

}
	

void ADC_init(void){

		SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK; /* clock to PORTB */
		PORTB->PCR[0] = 0; /* PTB0 analog input */
		PORTB->PCR[1] = 0; /* PTB1 analog input */
	
	SIM->SCGC6 |= 0x8000000; /* clock to ADC0 */
		ADC0->SC2 &= ~0x40; /* software trigger */
		/* clock div by 4, long sample time, single ended 10 bit, bus clock */
		ADC0->CFG1 = 0x40 | 0x10 | 0x08 | 0x00;
	
	
	ADC0->SC1[0] = 8; /* start conversion on channel PTB0 CH8 */
		while(!(ADC0->SC1[0] & 0x80)) { } /* wait for conversion complete */
		int result_0 = ADC0->R[0]; /* read conversion result and clear COCO flag */

		ADC0->SC1[0] = 9; /* start conversion on channel PTB1 CH9 */
		while(!(ADC0->SC1[0] & 0x80)) { } /* wait for conversion complete */
		int result_1 = ADC0->R[0]; /* read conversion result and clear COCO flag */
		
		result_0_bin = convert_to_binary(result_0);
		result_1_bin = convert_to_binary(result_1);
	
	
}

int convert_to_binary(int value) {
    if (value > 700) {
        return 1;
    } else if (value >= 300 && value <= 700) {
        return 2;
    } else {
        return 0;
    }
}


		

void PWM_init(void){
		//This section is for enabling the PTD1 as out and defines the clock and selects clock.

		SIM->SCGC5 |= SIM_SCGC5_PORTA_MASK; /* enable clock to Port A */
		SIM->SCGC5 |= SIM_SCGC5_PORTC_MASK; /* enable clock to Port C */
	PORTA->PCR[4] = PORT_PCR_MUX(3); /* PTA4 used by TPM0 */
		PORTA->PCR[5] = PORT_PCR_MUX(3); /* PTA5 used by TPM0 */
	
	
	SIM->SCGC6 |= SIM_SCGC6_TPM0_MASK; /* enable clock to TPM0 */
		SIM->SOPT2 |= SIM_SOPT2_TPMSRC(1); /* use MCGFLLCLK as timer counter clock */
		TPM0->SC = 0; /* disable timer */
	
	TPM0->CONTROLS[1].CnSC = TPM_CnSC_MSB_MASK|TPM_CnSC_ELSB_MASK;/* PTA4 CH1 edge-aligned, pulse high */
	
		TPM0->CONTROLS[2].CnSC = TPM_CnSC_MSB_MASK|TPM_CnSC_ELSB_MASK;/* PTA5 CH2 edge-aligned, pulse high */
	
	
	TPM0->MOD = (TPM_Hz/(16*PWM_Hz))-1; /* Set up modulo register for 50Hz */
	
		TPM0->CONTROLS[1].CnV = ((TPM_Hz/(16*PWM_Hz))-1)1.5/20; / Set up PTA4 CH1 value for 7.5% dutycycle */
		TPM0->CONTROLS[2].CnV = ((TPM_Hz/(16*PWM_Hz))-1)*1.5/20; /*Set up PTA5 CH2 value for 7.5% dutycycle */
	
TPM0->SC = TPM_SC_CMOD(1)|TPM_SC_PS(4); /* enable TPM0 with prescaler /16 */
}
	




void delayMs(int n) {
		int i;
		int j;
		for(i = 0 ; i < n; i++)
		for (j = 0; j < 2500; j++) {}

}

void LCD_init(void)
{
SIM->SCGC5 |= 0x1000; /* enable clock to Port D */
PORTD->PCR[0] = 0x100; /* make PTD0 pin as GPIO */
PORTD->PCR[1] = 0x100; /* make PTD1 pin as GPIO */
PORTD->PCR[2] = 0x100; /* make PTD2 pin as GPIO */
PORTD->PCR[3] = 0x100; /* make PTD3 pin as GPIO */
PORTD->PCR[4] = 0x100; /* make PTD4 pin as GPIO */
PORTD->PCR[5] = 0x100; /* make PTD5 pin as GPIO */
PORTD->PCR[6] = 0x100; /* make PTD6 pin as GPIO */
PORTD->PCR[7] = 0x100; /* make PTD7 pin as GPIO */
PTD->PDDR = 0xFF; /* make PTD7-0 as output pins */
SIM->SCGC5 |= SIM_SCGC5_PORTC_MASK; /* enable clock to Port A */
PORTC->PCR[12] = 0x100; /* make PTA2 pin as GPIO */
PORTC->PCR[13] = 0x100; /* make PTA4 pin as GPIO */
PORTC->PCR[16] = 0x100; /* make PTA5 pin as GPIO */
PTC->PDDR |= MASK(12) | MASK(13) | MASK(16); /* make PTA5, 4, 2 as output pins */
delayMs(30); /* initialization sequence */
LCD_command(0x30);
delayMs(10);
LCD_command(0x30);
delayMs(1);
LCD_command(0x30);
LCD_command(0x38); /* set 8-bit data, 2-line, 5x7 font */
LCD_command(0x06); /* move cursor right */
LCD_command(0x01); /* clear screen, move cursor to home */
LCD_command(0x0F); /* turn on display, cursor blinking */
}

void LCD_command(unsigned char command)
{
PTC->PCOR = RS | RW; /* RS = 0, R/W = 0 */
PTD->PDOR = command;
PTC->PSOR = EN; /* pulse E */
delayMs(0);
PTC->PCOR = EN;
if (command < 4)
delayMs(4); /* command 1 and 2 needs up to 1.64ms */
else
delayMs(1); /* all others 40 us */
}

void LCD_data(unsigned char data)
{
PTC->PSOR = RS; /* RS = 1, R/W = 0 */
PTC->PCOR = RW;
PTD->PDOR = data;
PTC->PSOR = EN; /* pulse E */
delayMs(0);
PTC->PCOR = EN;
delayMs(1);
}

void configureButtonInterrupt(void) {
	__disable_irq();
	
    // Enable clock for Port D to configure PTD6
    SIM->SCGC5 |= SIM_SCGC5_PORTA_MASK;  
    // Configure PTD6 as GPIO with pull-up resistor enabled
    PORTA->PCR[17] = PORT_PCR_MUX(1) |    // Pin MUX as GPIO
                    PORT_PCR_PE_MASK |   // Pull-up Enable
                    PORT_PCR_PS_MASK |    // Pull Select: Pull-up (level-sensitive)
										PORT_PCR_IRQC(0x08);  // Interrupt Configuration for level
    // Enable the PORTD interrupt in NVIC
    NVIC_EnableIRQ(PORTA_IRQn);      
__enable_irq();
	
}

void PORTA_IRQHandler(void) {
    // Check if the interrupt was triggered by PTD6
		
	PTB->PCOR = MASK(18);
	PTB->PSOR = MASK(2);
	delayMs(1);
	PTB->PSOR = MASK(18);
	PTB->PCOR = MASK(2);

	PORTA->ISFR |= (1UL << 17);  // Clear interrupt for PTD6
					
					displayinteruptMessage(); 
}
        
void displayDetectedMessage() {
    LCD_command(1);      // Clear display
    

    LCD_command(0x80);   // Set cursor at first line

    char message[] = "SEARCHING...";

    for (int i = 0; i < sizeof(message) - 1; i++) {
        LCD_data(message[i]);
       
			// Optional delay between characters
    }
	
}
void displayinteruptMessage() {
    LCD_command(1);      // Clear display
    

    LCD_command(0x80);   // Set cursor at first line

    char message[] = "TARGET DETECTED!";

    for (int i = 0; i < sizeof(message) - 1; i++) {
        LCD_data(message[i]);}
       
			// Optional delay between characters

		}