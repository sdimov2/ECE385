//Fill in your low-level SPI functions here, as per your host platform

#define _MAX3421E_C_

#include "system.h"
#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "../usb_kb/project_config.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_pio_regs.h"
#include <sys/alt_stdio.h>
#include <unistd.h>



//variables and data structures
//External variables
extern BYTE usb_task_state;

/* Functions    */
void SPI_init(BYTE sync_mode, BYTE bus_mode, BYTE smp_phase) {
	//Don't need to initialize SPI port, already ready to go with BSP
}

//writes single byte to MAX3421E via SPI, simultanously reads status register and returns it
BYTE SPI_wr(BYTE data) {
	//This function is never used by the code, so you do not need to fill it in
}
//writes register to MAX3421E via SPI
void MAXreg_wr(BYTE reg, BYTE val) { // It seems we're using host mode for the MAX (MAX3421E.h)
	//psuedocode:
	//		select MAX3421E (may not be necessary if you are using SPI peripheral)
	//ALIF		write reg + 2 via SPI (DIR = WRITE, ACKSTAT = 0) MAX datasheet P7 Figure 5
	//				write val via SPI		writelength is 1 (command) + 1 (val) bytes
	//BA		read return code from SPI peripheral (see Intel documentation) 	(put the function call in an if statement)
	//				if return code < 0 print an error 			It should probably be 0 since we set read length to 0
	//TA		deselect MAX3421E (may not be necessary if you are using SPI peripheral)

	const BYTE myBYTE[2] = {(reg + 0x02), val};
	//ALIF
	if (alt_avalon_spi_command( // If returned number of bytes
			SPI_0_BASE, // system.h (bsp) macros
			0x0, // int 0 for slave0
			0x2, // Write length 2 bytes
			myBYTE, // pointer to array of register select and input byte
			0x0, // Read length 0
			NULL, // Null pointer for read_data, we aren't reading anything
			0x0 // Null for flags is correct
			) < 0)
	//BA
		printf("\nError, error! Read length < 0 for SPI. MAX3421E.c MAXreg_wr\n"); // Big error message
	//TA
	// Hopefully the function deselects after finished (embedded peripherals user guide 5.4.3.5)
	// But if not we can just call another spi_command with the slave word as 0x0
	return;
}
//multiple-byte write
//returns a pointer to a memory position after last written
BYTE* MAXbytes_wr(BYTE reg, BYTE nbytes, BYTE* data) {
	//psuedocode:
	//	select MAX3421E (may not be necessary if you are using SPI peripheral)
	//ALIF		write reg + 2 via SPI
	//				write data[n] via SPI, where n goes from 0 to nbytes-1
	//BA		read return code from SPI peripheral (see Intel documentation)
	//				if return code < 0  print an error
	//TA		deselect MAX3421E (may not be necessary if you are using SPI peripheral)
	//THA		return (data + nbytes);

	BYTE myBYTE[(nbytes + 1)]; // Simple loop to copy data to the less significant bits of our temp array
	myBYTE[0] = (reg + 2); // DIR = WRITE

	for (int i = 1; i <= nbytes; i++){
		myBYTE[i] = data[(i - 1)];
	}
	//ALIF
	if (alt_avalon_spi_command( // If returned number of bytes
			SPI_0_BASE, // system.h (bsp) macros
			0x0, // int 0 for slave0
			(nbytes + 1), // Write length is the nbytes argument plus one for the command
			myBYTE, // pointer to array of register select and input bytes
			0x0, // Read length 0
			NULL, // Null pointer for read_data, we aren't reading anything
			0x0 // Null for flags
			) < 0)
	//BA
		printf("\nError, error! Read length < 0 for SPI. MAX3421E.c MAXbytes_wr\n"); // Big error message

	//TA
	// Hopefully the function deselects after finished (embedded peripherals user guide 5.4.3.5)
	// But if not we can just call another spi_command with the slave word as 0x0
	//THA
	return (data + nbytes); // Literally just add the nbytes to the pointer to give the end pointer
}

//reads register from MAX3421E via SPI
BYTE MAXreg_rd(BYTE reg) {
	//psuedocode:
	//	select MAX3421E (may not be necessary if you are using SPI peripheral)
	//ALIF 		write reg via SPI
	//				read val via SPI
	//BA		read return code from SPI peripheral (see Intel documentation)
	//				if return code < 0 print an error
	//TA		deselect MAX3421E (may not be necessary if you are using SPI peripheral)
	//THA		return val


	BYTE val;
	const BYTE myBYTE[1] = {reg}; // Write register as command, DIR = WRITE
	//ALIF
	if (alt_avalon_spi_command( // If returned number of bytes
			SPI_0_BASE, // system.h (bsp) macros
			0x0, // int 0 for slave0
			0x1, // Write length 1 byte
			myBYTE, // pointer to array of register select and input byte
			0x1, // Read length 1 byte
			&val, // Pointer for read_data is val address
			0x0 // Null for flags
			) < 0)
	//BA
		printf("\nError, error! Read length < 0 for SPI. MAX3421E.c MAXreg_rd\n"); // Big error message
	//TA
	// Hopefully the function deselects after finished (embedded peripherals user guide 5.4.3.5)
	// But if not we can just call another spi_command with the slave word as 0x0
	return val;
}
//multiple-byte write
//returns a pointer to a memory position after last written
BYTE* MAXbytes_rd(BYTE reg, BYTE nbytes, BYTE* data) {
	//psuedocode:
	//		select MAX3421E (may not be necessary if you are using SPI peripheral)
	//ALIF		write reg via SPI
	//				read data[n] from SPI, where n goes from 0 to nbytes-1
	//BA		read return code from SPI peripheral (see Intel documentation)
	//				if return code < 0 print an error
	//TA		deselect MAX3421E (may not be necessary if you are using SPI peripheral)
	//THA		return (data + nbytes);

	const BYTE myBYTE[1] = {reg}; // Simple loop to copy data to the less significant bits of our temp array
	// DIR = READ

	//ALIF
	if (alt_avalon_spi_command( // If returned number of bytes
			SPI_0_BASE, // system.h (bsp) macros
			0x0, // int 0 for slave0
			0x1, // Write length is only the command
			myBYTE, // pointer to array of register select and input bytes
			nbytes, // Read length nbytes
			data, // Pointer for read data is the one given.
			0x0 // Null for flags
			) < 0)
	//BA
		printf("\nError, error! Read length < 0 for SPI. MAX3421E.c MAXbytes_wr\n"); // Big error message
	//TA
	// Hopefully the function deselects after finished (embedded peripherals user guide 5.4.3.5)
	// But if not we can just call another spi_command with the slave word as 0x0
	//THA
	return (data + nbytes); // Literally just add the nbytes to the pointer to give the end pointer
}
/* reset MAX3421E using chip reset bit. SPI configuration is not affected   */
void MAX3421E_reset(void) {
	//hardware reset, then software reset
	IOWR_ALTERA_AVALON_PIO_DATA(USB_RST_BASE, 0);
	usleep(1000000);
	IOWR_ALTERA_AVALON_PIO_DATA(USB_RST_BASE, 1);
	BYTE tmp = 0;
	MAXreg_wr( rUSBCTL, bmCHIPRES);      //Chip reset. This stops the oscillator
	MAXreg_wr( rUSBCTL, 0x00);                          //Remove the reset
	while (!(MAXreg_rd( rUSBIRQ) & bmOSCOKIRQ)) { //wait until the PLL stabilizes
		tmp++;                                      //timeout after 256 attempts
		if (tmp == 0) {
			printf("reset timeout!");
		}
	}
}
/* turn USB power on/off                                                */
/* ON pin of VBUS switch (MAX4793 or similar) is connected to GPOUT7    */
/* OVERLOAD pin of Vbus switch is connected to GPIN7                    */
/* OVERLOAD state low. NO OVERLOAD or VBUS OFF state high.              */
BOOL Vbus_power(BOOL action) {
	// power on/off successful
	return (1);
}

/* probe bus to determine device presense and speed */
void MAX_busprobe(void) {
	BYTE bus_sample;

//  MAXreg_wr(rHCTL,bmSAMPLEBUS);
	bus_sample = MAXreg_rd( rHRSL);            //Get J,K status
	bus_sample &= ( bmJSTATUS | bmKSTATUS);      //zero the rest of the byte

	switch (bus_sample) {                   //start full-speed or low-speed host
	case ( bmJSTATUS):
		/*kludgy*/
		if (usb_task_state != USB_ATTACHED_SUBSTATE_WAIT_RESET_COMPLETE) { //bus reset causes connection detect interrupt
			if (!(MAXreg_rd( rMODE) & bmLOWSPEED)) {
				MAXreg_wr( rMODE, MODE_FS_HOST);         //start full-speed host
				printf("Starting in full speed\n");
			} else {
				MAXreg_wr( rMODE, MODE_LS_HOST);    //start low-speed host
				printf("Starting in low speed\n");
			}
			usb_task_state = ( USB_STATE_ATTACHED); //signal usb state machine to start attachment sequence
		}
		break;
	case ( bmKSTATUS):
		if (usb_task_state != USB_ATTACHED_SUBSTATE_WAIT_RESET_COMPLETE) { //bus reset causes connection detect interrupt
			if (!(MAXreg_rd( rMODE) & bmLOWSPEED)) {
				MAXreg_wr( rMODE, MODE_LS_HOST);   //start low-speed host
				printf("Starting in low speed\n");
			} else {
				MAXreg_wr( rMODE, MODE_FS_HOST);         //start full-speed host
				printf("Starting in full speed\n");
			}
			usb_task_state = ( USB_STATE_ATTACHED); //signal usb state machine to start attachment sequence
		}
		break;
	case ( bmSE1):              //illegal state
		usb_task_state = ( USB_DETACHED_SUBSTATE_ILLEGAL);
		break;
	case ( bmSE0):              //disconnected state
		if (!((usb_task_state & USB_STATE_MASK) == USB_STATE_DETACHED)) //if we came here from other than detached state
			usb_task_state = ( USB_DETACHED_SUBSTATE_INITIALIZE); //clear device data structures
		else {
			MAXreg_wr( rMODE, MODE_FS_HOST); //start full-speed host
			usb_task_state = ( USB_DETACHED_SUBSTATE_WAIT_FOR_DEVICE);
		}
		break;
	} //end switch( bus_sample )
}
/* MAX3421E initialization after power-on   */
void MAX3421E_init(void) {
	/* Configure full-duplex SPI, interrupt pulse   */
	MAXreg_wr( rPINCTL, (bmFDUPSPI + bmINTLEVEL + bmGPXB)); //Full-duplex SPI, level interrupt, GPX
	MAX3421E_reset();                                //stop/start the oscillator
	/* configure power switch   */
	Vbus_power( OFF);                                      //turn Vbus power off
	MAXreg_wr( rGPINIEN, bmGPINIEN7); //enable interrupt on GPIN7 (power switch overload flag)
	Vbus_power( ON);
	/* configure host operation */
	MAXreg_wr( rMODE, bmDPPULLDN | bmDMPULLDN | bmHOST | bmSEPIRQ); // set pull-downs, SOF, Host, Separate GPIN IRQ on GPX
	//MAXreg_wr( rHIEN, bmFRAMEIE|bmCONDETIE|bmBUSEVENTIE );                      // enable SOF, connection detection, bus event IRQs
	MAXreg_wr( rHIEN, bmCONDETIE);                        //connection detection
	/* HXFRDNIRQ is checked in Dispatch packet function */
	MAXreg_wr(rHCTL, bmSAMPLEBUS);        // update the JSTATUS and KSTATUS bits
	MAX_busprobe();                             //check if anything is connected
	MAXreg_wr( rHIRQ, bmCONDETIRQ); //clear connection detect interrupt                 
	MAXreg_wr( rCPUCTL, 0x01);                            //enable interrupt pin
}

/* MAX3421 state change task and interrupt handler */
void MAX3421E_Task(void) {
	if ( IORD_ALTERA_AVALON_PIO_DATA(USB_IRQ_BASE) == 0) {
		printf("MAX interrupt\n\r");
		MaxIntHandler();
	}
	if ( IORD_ALTERA_AVALON_PIO_DATA(USB_GPX_BASE) == 1) {
		printf("GPX interrupt\n\r");
		MaxGpxHandler();
	}
}

void MaxIntHandler(void) {
	BYTE HIRQ;
	BYTE HIRQ_sendback = 0x00;
	HIRQ = MAXreg_rd( rHIRQ);                  //determine interrupt source
	printf("IRQ: %x\n", HIRQ);
	if (HIRQ & bmFRAMEIRQ) {                   //->1ms SOF interrupt handler
		HIRQ_sendback |= bmFRAMEIRQ;
	}                   //end FRAMEIRQ handling

	if (HIRQ & bmCONDETIRQ) {
		MAX_busprobe();
		HIRQ_sendback |= bmCONDETIRQ;      //set sendback to 1 to clear register
	}
	if (HIRQ & bmSNDBAVIRQ) //if the send buffer is clear (previous transfer completed without issue)
	{
		MAXreg_wr(rSNDBC, 0x00);//clear the send buffer (not really necessary, but clears interrupt)
	}
	if (HIRQ & bmBUSEVENTIRQ) {           //bus event is either reset or suspend
		usb_task_state++;                       //advance USB task state machine
		HIRQ_sendback |= bmBUSEVENTIRQ;
	}
	/* End HIRQ interrupts handling, clear serviced IRQs    */
	MAXreg_wr( rHIRQ, HIRQ_sendback); //write '1' to CONDETIRQ to ack bus state change
}

void MaxGpxHandler(void) {
	BYTE GPINIRQ;
	GPINIRQ = MAXreg_rd( rGPINIRQ);            //read both IRQ registers
}
