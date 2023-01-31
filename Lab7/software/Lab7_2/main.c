


#include <stdio.h>
#include "system.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"

#include "text_mode_vga_color.h"

int main(){

	textVGAColorClr();


	textVGAColorScreenSaver();

	while(1);
}
