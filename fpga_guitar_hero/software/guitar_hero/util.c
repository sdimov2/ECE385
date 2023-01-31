// board util functions
// Copied from sgtl5000_test.c

#include <stdio.h>
#include <system.h>
#include <alt_types.h>
#include <altera_avalon_pio_regs.h>

#include "util.h"

void setLED(int LED)
{
	IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE, (IORD_ALTERA_AVALON_PIO_DATA(LEDS_BASE) | (0x001 << LED)));
}

void clearLED(int LED)
{
	IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE, (IORD_ALTERA_AVALON_PIO_DATA(LEDS_BASE) & ~(0x001 << LED)));

}

void printSignedHex0(signed char value)
{
	alt_u8 tens = 0;
	alt_u8 ones = 0;
	alt_u16 pio_val = IORD_ALTERA_AVALON_PIO_DATA(HEX_DIGITS_BASE);
	if (value < 0)
	{
		setLED(11);
		value = -value;
	}
	else
	{
		clearLED(11);
	}
	//handled hundreds
	if (value / 100)
		setLED(13);
	else
		clearLED(13);

	value = value % 100;
	tens = value / 10;
	ones = value % 10;

	pio_val &= 0x00FF;
	pio_val |= (tens << 12);
	pio_val |= (ones << 8);

	IOWR_ALTERA_AVALON_PIO_DATA(HEX_DIGITS_BASE, pio_val);
}

void printSignedHex1(signed char value)
{
	alt_u8 tens = 0;
	alt_u8 ones = 0;
	alt_u32 pio_val = IORD_ALTERA_AVALON_PIO_DATA(HEX_DIGITS_BASE);
	if (value < 0)
	{
		setLED(10);
		value = -value;
	}
	else
	{
		clearLED(10);
	}
	//handled hundreds
	if (value / 100)
		setLED(12);
	else
		clearLED(12);

	value = value % 100;
	tens = value / 10;
	ones = value % 10;
	tens = value / 10;
	ones = value % 10;

	pio_val &= 0xFF00;
	pio_val |= (tens << 4);
	pio_val |= (ones << 0);

	IOWR_ALTERA_AVALON_PIO_DATA(HEX_DIGITS_BASE, pio_val);
}
