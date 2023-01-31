/*
 * sgtl5000_test.h
 *
 *  Created on: 10.12.2021 ?.
 *      Author: steven
 */

#ifndef SGTL5000_TEST_H_
#define SGTL5000_TEST_H_


#include <stdio.h>
#include "system.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_i2c.h"
#include "altera_avalon_i2c_regs.h"
#include "sys/alt_irq.h"
#include "sgtl5000/GenericTypeDefs.h"
#include "sgtl5000/sgtl5000.h"

void setLED(int LED);
void clearLED(int LED);
void printSignedHex0(signed char value);
void printSignedHex1(signed char value);
void sgtl5000test();

#endif /* SGTL5000_TEST_H_ */
