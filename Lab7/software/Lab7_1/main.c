/*
 * main.c
 *
 *  Created on: Oct 29, 2021
 *      Author: owent
 */


#include <stdio.h>
#include "system.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"

#include "text_mode_vga.h"

int main(){

	textVGASetColor(BLACK, WHITE);
	textVGAClr();

	vga_ctrl->VRAM[0] = 0x39;
	vga_ctrl->VRAM[1] = 0x39;
	vga_ctrl->VRAM[2] = 0x39;

	vga_ctrl->VRAM[60] = 0x39;
	vga_ctrl->VRAM[79] = 0x39;

	vga_ctrl->VRAM[80] = 0x39;
	vga_ctrl->VRAM[81] = 0x39;



	textVGATest();


	while(1);
}
