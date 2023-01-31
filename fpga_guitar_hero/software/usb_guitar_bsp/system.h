/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2_gen2_0' in SOPC Builder design 'fpga_guitar_hero_soc'
 * SOPC Builder design path: ../../fpga_guitar_hero_soc.sopcinfo
 *
 * Generated: Wed Dec 01 21:19:25 CST 2021
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x08000820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1c
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x04000020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x1c
#define ALT_CPU_NAME "nios2_gen2_0"
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x04000000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x08000820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x1c
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x04000020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x1c
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x04000000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_I2C
#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SPI
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_TIMER
#define __ALTERA_NIOS2_GEN2
#define __ALTPLL
#define __VGA_TEXT_MODE_CONTROLLER


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "MAX 10"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart_0"
#define ALT_STDERR_BASE 0x8001178
#define ALT_STDERR_DEV jtag_uart_0
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart_0"
#define ALT_STDIN_BASE 0x8001178
#define ALT_STDIN_DEV jtag_uart_0
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart_0"
#define ALT_STDOUT_BASE 0x8001178
#define ALT_STDOUT_DEV jtag_uart_0
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "fpga_guitar_hero_soc"


/*
 * VGA_text_mode_controller_0 configuration
 *
 */

#define ALT_MODULE_CLASS_VGA_text_mode_controller_0 VGA_text_mode_controller
#define VGA_TEXT_MODE_CONTROLLER_0_ADDR_WIDTH 4
#define VGA_TEXT_MODE_CONTROLLER_0_BASE 0x8001080
#define VGA_TEXT_MODE_CONTROLLER_0_IRQ -1
#define VGA_TEXT_MODE_CONTROLLER_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define VGA_TEXT_MODE_CONTROLLER_0_NAME "/dev/VGA_text_mode_controller_0"
#define VGA_TEXT_MODE_CONTROLLER_0_NOTE_COUNT 15
#define VGA_TEXT_MODE_CONTROLLER_0_SPAN 64
#define VGA_TEXT_MODE_CONTROLLER_0_TYPE "VGA_text_mode_controller"


/*
 * frets_pio configuration
 *
 */

#define ALT_MODULE_CLASS_frets_pio altera_avalon_pio
#define FRETS_PIO_BASE 0x8001130
#define FRETS_PIO_BIT_CLEARING_EDGE_REGISTER 0
#define FRETS_PIO_BIT_MODIFYING_OUTPUT_REGISTER 0
#define FRETS_PIO_CAPTURE 0
#define FRETS_PIO_DATA_WIDTH 5
#define FRETS_PIO_DO_TEST_BENCH_WIRING 0
#define FRETS_PIO_DRIVEN_SIM_VALUE 0
#define FRETS_PIO_EDGE_TYPE "NONE"
#define FRETS_PIO_FREQ 50000000
#define FRETS_PIO_HAS_IN 1
#define FRETS_PIO_HAS_OUT 0
#define FRETS_PIO_HAS_TRI 0
#define FRETS_PIO_IRQ -1
#define FRETS_PIO_IRQ_INTERRUPT_CONTROLLER_ID -1
#define FRETS_PIO_IRQ_TYPE "NONE"
#define FRETS_PIO_NAME "/dev/frets_pio"
#define FRETS_PIO_RESET_VALUE 0
#define FRETS_PIO_SPAN 16
#define FRETS_PIO_TYPE "altera_avalon_pio"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK USB_TIMER
#define ALT_TIMESTAMP_CLK USB_TIMER


/*
 * hex_digits configuration
 *
 */

#define ALT_MODULE_CLASS_hex_digits altera_avalon_pio
#define HEX_DIGITS_BASE 0x8001150
#define HEX_DIGITS_BIT_CLEARING_EDGE_REGISTER 0
#define HEX_DIGITS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define HEX_DIGITS_CAPTURE 0
#define HEX_DIGITS_DATA_WIDTH 16
#define HEX_DIGITS_DO_TEST_BENCH_WIRING 0
#define HEX_DIGITS_DRIVEN_SIM_VALUE 0
#define HEX_DIGITS_EDGE_TYPE "NONE"
#define HEX_DIGITS_FREQ 50000000
#define HEX_DIGITS_HAS_IN 0
#define HEX_DIGITS_HAS_OUT 1
#define HEX_DIGITS_HAS_TRI 0
#define HEX_DIGITS_IRQ -1
#define HEX_DIGITS_IRQ_INTERRUPT_CONTROLLER_ID -1
#define HEX_DIGITS_IRQ_TYPE "NONE"
#define HEX_DIGITS_NAME "/dev/hex_digits"
#define HEX_DIGITS_RESET_VALUE 0
#define HEX_DIGITS_SPAN 16
#define HEX_DIGITS_TYPE "altera_avalon_pio"


/*
 * i2c_0 configuration
 *
 */

#define ALT_MODULE_CLASS_i2c_0 altera_avalon_i2c
#define I2C_0_BASE 0x8001040
#define I2C_0_FIFO_DEPTH 4
#define I2C_0_FREQ 50000000
#define I2C_0_IRQ 1
#define I2C_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define I2C_0_NAME "/dev/i2c_0"
#define I2C_0_SPAN 64
#define I2C_0_TYPE "altera_avalon_i2c"
#define I2C_0_USE_AV_ST 0


/*
 * jtag_uart_0 configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart_0 altera_avalon_jtag_uart
#define JTAG_UART_0_BASE 0x8001178
#define JTAG_UART_0_IRQ 0
#define JTAG_UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_0_NAME "/dev/jtag_uart_0"
#define JTAG_UART_0_READ_DEPTH 64
#define JTAG_UART_0_READ_THRESHOLD 8
#define JTAG_UART_0_SPAN 8
#define JTAG_UART_0_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_0_WRITE_DEPTH 64
#define JTAG_UART_0_WRITE_THRESHOLD 8


/*
 * leds configuration
 *
 */

#define ALT_MODULE_CLASS_leds altera_avalon_pio
#define LEDS_BASE 0x8001140
#define LEDS_BIT_CLEARING_EDGE_REGISTER 0
#define LEDS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LEDS_CAPTURE 0
#define LEDS_DATA_WIDTH 14
#define LEDS_DO_TEST_BENCH_WIRING 0
#define LEDS_DRIVEN_SIM_VALUE 0
#define LEDS_EDGE_TYPE "NONE"
#define LEDS_FREQ 50000000
#define LEDS_HAS_IN 0
#define LEDS_HAS_OUT 1
#define LEDS_HAS_TRI 0
#define LEDS_IRQ -1
#define LEDS_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LEDS_IRQ_TYPE "NONE"
#define LEDS_NAME "/dev/leds"
#define LEDS_RESET_VALUE 0
#define LEDS_SPAN 16
#define LEDS_TYPE "altera_avalon_pio"


/*
 * sdram configuration
 *
 */

#define ALT_MODULE_CLASS_sdram altera_avalon_new_sdram_controller
#define SDRAM_BASE 0x4000000
#define SDRAM_CAS_LATENCY 3
#define SDRAM_CONTENTS_INFO
#define SDRAM_INIT_NOP_DELAY 0.0
#define SDRAM_INIT_REFRESH_COMMANDS 2
#define SDRAM_IRQ -1
#define SDRAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_IS_INITIALIZED 1
#define SDRAM_NAME "/dev/sdram"
#define SDRAM_POWERUP_DELAY 200.0
#define SDRAM_REFRESH_PERIOD 15.625
#define SDRAM_REGISTER_DATA_IN 1
#define SDRAM_SDRAM_ADDR_WIDTH 0x19
#define SDRAM_SDRAM_BANK_WIDTH 2
#define SDRAM_SDRAM_COL_WIDTH 10
#define SDRAM_SDRAM_DATA_WIDTH 16
#define SDRAM_SDRAM_NUM_BANKS 4
#define SDRAM_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_SDRAM_ROW_WIDTH 13
#define SDRAM_SHARED_DATA 0
#define SDRAM_SIM_MODEL_BASE 0
#define SDRAM_SPAN 67108864
#define SDRAM_STARVATION_INDICATOR 0
#define SDRAM_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_T_AC 5.5
#define SDRAM_T_MRD 3
#define SDRAM_T_RCD 20.0
#define SDRAM_T_RFC 70.0
#define SDRAM_T_RP 20.0
#define SDRAM_T_WR 14.0


/*
 * sdram_pll configuration
 *
 */

#define ALT_MODULE_CLASS_sdram_pll altpll
#define SDRAM_PLL_BASE 0x8001160
#define SDRAM_PLL_IRQ -1
#define SDRAM_PLL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_PLL_NAME "/dev/sdram_pll"
#define SDRAM_PLL_SPAN 16
#define SDRAM_PLL_TYPE "altpll"


/*
 * spi_0 configuration
 *
 */

#define ALT_MODULE_CLASS_spi_0 altera_avalon_spi
#define SPI_0_BASE 0x80010e0
#define SPI_0_CLOCKMULT 1
#define SPI_0_CLOCKPHASE 0
#define SPI_0_CLOCKPOLARITY 0
#define SPI_0_CLOCKUNITS "Hz"
#define SPI_0_DATABITS 8
#define SPI_0_DATAWIDTH 16
#define SPI_0_DELAYMULT "1.0E-9"
#define SPI_0_DELAYUNITS "ns"
#define SPI_0_EXTRADELAY 0
#define SPI_0_INSERT_SYNC 0
#define SPI_0_IRQ 3
#define SPI_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SPI_0_ISMASTER 1
#define SPI_0_LSBFIRST 0
#define SPI_0_NAME "/dev/spi_0"
#define SPI_0_NUMSLAVES 1
#define SPI_0_PREFIX "spi_"
#define SPI_0_SPAN 32
#define SPI_0_SYNC_REG_DEPTH 2
#define SPI_0_TARGETCLOCK 2500000u
#define SPI_0_TARGETSSDELAY "0.0"
#define SPI_0_TYPE "altera_avalon_spi"


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid_qsys
#define SYSID_BASE 0x8001170
#define SYSID_ID 0
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1638415060
#define SYSID_TYPE "altera_avalon_sysid_qsys"


/*
 * timer_0 configuration
 *
 */

#define ALT_MODULE_CLASS_timer_0 altera_avalon_timer
#define TIMER_0_ALWAYS_RUN 0
#define TIMER_0_BASE 0x8001000
#define TIMER_0_COUNTER_SIZE 64
#define TIMER_0_FIXED_PERIOD 0
#define TIMER_0_FREQ 50000000
#define TIMER_0_IRQ 4
#define TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TIMER_0_LOAD_VALUE 49
#define TIMER_0_MULT 1.0E-6
#define TIMER_0_NAME "/dev/timer_0"
#define TIMER_0_PERIOD 1
#define TIMER_0_PERIOD_UNITS "us"
#define TIMER_0_RESET_OUTPUT 0
#define TIMER_0_SNAPSHOT 1
#define TIMER_0_SPAN 64
#define TIMER_0_TICKS_PER_SEC 1000000
#define TIMER_0_TIMEOUT_PULSE_OUTPUT 0
#define TIMER_0_TYPE "altera_avalon_timer"


/*
 * usb_gpx configuration
 *
 */

#define ALT_MODULE_CLASS_usb_gpx altera_avalon_pio
#define USB_GPX_BASE 0x8001110
#define USB_GPX_BIT_CLEARING_EDGE_REGISTER 0
#define USB_GPX_BIT_MODIFYING_OUTPUT_REGISTER 0
#define USB_GPX_CAPTURE 0
#define USB_GPX_DATA_WIDTH 1
#define USB_GPX_DO_TEST_BENCH_WIRING 0
#define USB_GPX_DRIVEN_SIM_VALUE 0
#define USB_GPX_EDGE_TYPE "NONE"
#define USB_GPX_FREQ 50000000
#define USB_GPX_HAS_IN 1
#define USB_GPX_HAS_OUT 0
#define USB_GPX_HAS_TRI 0
#define USB_GPX_IRQ -1
#define USB_GPX_IRQ_INTERRUPT_CONTROLLER_ID -1
#define USB_GPX_IRQ_TYPE "NONE"
#define USB_GPX_NAME "/dev/usb_gpx"
#define USB_GPX_RESET_VALUE 0
#define USB_GPX_SPAN 16
#define USB_GPX_TYPE "altera_avalon_pio"


/*
 * usb_irq configuration
 *
 */

#define ALT_MODULE_CLASS_usb_irq altera_avalon_pio
#define USB_IRQ_BASE 0x8001100
#define USB_IRQ_BIT_CLEARING_EDGE_REGISTER 0
#define USB_IRQ_BIT_MODIFYING_OUTPUT_REGISTER 0
#define USB_IRQ_CAPTURE 0
#define USB_IRQ_DATA_WIDTH 1
#define USB_IRQ_DO_TEST_BENCH_WIRING 0
#define USB_IRQ_DRIVEN_SIM_VALUE 0
#define USB_IRQ_EDGE_TYPE "NONE"
#define USB_IRQ_FREQ 50000000
#define USB_IRQ_HAS_IN 1
#define USB_IRQ_HAS_OUT 0
#define USB_IRQ_HAS_TRI 0
#define USB_IRQ_IRQ -1
#define USB_IRQ_IRQ_INTERRUPT_CONTROLLER_ID -1
#define USB_IRQ_IRQ_TYPE "NONE"
#define USB_IRQ_NAME "/dev/usb_irq"
#define USB_IRQ_RESET_VALUE 0
#define USB_IRQ_SPAN 16
#define USB_IRQ_TYPE "altera_avalon_pio"


/*
 * usb_rst configuration
 *
 */

#define ALT_MODULE_CLASS_usb_rst altera_avalon_pio
#define USB_RST_BASE 0x8001120
#define USB_RST_BIT_CLEARING_EDGE_REGISTER 0
#define USB_RST_BIT_MODIFYING_OUTPUT_REGISTER 0
#define USB_RST_CAPTURE 0
#define USB_RST_DATA_WIDTH 1
#define USB_RST_DO_TEST_BENCH_WIRING 0
#define USB_RST_DRIVEN_SIM_VALUE 0
#define USB_RST_EDGE_TYPE "NONE"
#define USB_RST_FREQ 50000000
#define USB_RST_HAS_IN 0
#define USB_RST_HAS_OUT 1
#define USB_RST_HAS_TRI 0
#define USB_RST_IRQ -1
#define USB_RST_IRQ_INTERRUPT_CONTROLLER_ID -1
#define USB_RST_IRQ_TYPE "NONE"
#define USB_RST_NAME "/dev/usb_rst"
#define USB_RST_RESET_VALUE 0
#define USB_RST_SPAN 16
#define USB_RST_TYPE "altera_avalon_pio"


/*
 * usb_timer configuration
 *
 */

#define ALT_MODULE_CLASS_usb_timer altera_avalon_timer
#define USB_TIMER_ALWAYS_RUN 0
#define USB_TIMER_BASE 0x80010c0
#define USB_TIMER_COUNTER_SIZE 32
#define USB_TIMER_FIXED_PERIOD 0
#define USB_TIMER_FREQ 50000000
#define USB_TIMER_IRQ 2
#define USB_TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define USB_TIMER_LOAD_VALUE 49999
#define USB_TIMER_MULT 0.001
#define USB_TIMER_NAME "/dev/usb_timer"
#define USB_TIMER_PERIOD 1
#define USB_TIMER_PERIOD_UNITS "ms"
#define USB_TIMER_RESET_OUTPUT 0
#define USB_TIMER_SNAPSHOT 1
#define USB_TIMER_SPAN 32
#define USB_TIMER_TICKS_PER_SEC 1000
#define USB_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define USB_TIMER_TYPE "altera_avalon_timer"

#endif /* __SYSTEM_H_ */
