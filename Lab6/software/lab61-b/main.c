// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int sum = 0;
	int button0, button1;
	int button0state = 0;
	int button1state = 0; // States for both buttons

	volatile unsigned int *LED_PIO = (unsigned int*)0x40; //make a pointer to access the LED PIO block
	volatile unsigned int *SWITCHES_PIO = (unsigned int*)0x30; //make a pointer to access the SWITCHES PIO block
	volatile unsigned int *BUTTONS_PIO = (unsigned int*)0x20; //make a pointer to access the BUTTONS PIO block
	// This information on base addresses is probably somewhere in the qip file but for now the easiest
	// 	way is to open the platform designer


	*LED_PIO = 0; //clear all LEDs
	while (1) //infinite loop
	{
		// BUTTONS ARE ACTIVE LOW
		// That's why they're notted
		button0 = 0x01 & (~*BUTTONS_PIO); // button0 is lsb
		button1 = (0x02 & (~*BUTTONS_PIO)) >> 1; // button1 is second bit


		switch (button0state){ // "reset"
		case 0:
			if (button0){
				button0state = 1;
				sum = 0x00; // Reset to 0 on rising edge
			}
			break;
		case 1:
			if (!button0) button0state = 0; // Nothing on falling edge
			break;
		}

		switch (button1state){ // "accumulate"
		case 0:
			if (button1){
				button1state = 1;
				sum += (*SWITCHES_PIO & 0xFF); // Add to accumulator on rising edge
			}
			break;
		case 1:
			if (!button1) button1state = 0; // Noting on falling edge
			break;
		}

		// Unconditionally make sure sum overflows
		sum = sum % 256; // use modulo to limit
		// Unconditionally set LEDs to sum
		*LED_PIO = sum;
	}
	return 1; //never gets here
}
