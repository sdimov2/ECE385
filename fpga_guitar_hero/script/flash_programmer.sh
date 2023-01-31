#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting ELF File: C:\Users\byron\Documents\ece385\fpga_guitar_hero\software\guitar_hero\guitar_hero.elf to: "..\flash/guitar_hero_chip_flash_data.flash"
#
elf2flash --input="guitar_hero.elf" --output="../flash/guitar_hero_chip_flash_data.flash" --boot="$SOPC_KIT_NIOS2/components/altera_nios2/boot_loader_cfi.srec" --base=0x8200000 --end=0x8360000 --reset=0x8200000 --verbose 

#
# Programming File: "..\flash/guitar_hero_chip_flash_data.flash" To Device: chip_flash_data
#
nios2-flash-programmer "../flash/guitar_hero_chip_flash_data.flash" --base=0x8200000 --sidp=0x8441178 --id=0x0 --timestamp=1638666721 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program --verbose 

