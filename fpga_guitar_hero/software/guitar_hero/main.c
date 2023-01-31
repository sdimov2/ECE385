/**
 * main.c
 */

#include <system.h>
#include <stdio.h>
#include <alt_types.h>
#include <sys/alt_timestamp.h>
#include <altera_avalon_pio_regs.h>
#include <stdlib.h>

#include "sgtl5000/sgtl5000.h"

#include "sys/alt_irq.h"
#include "usb_kb/GenericMacros.h"
#include "usb_kb/GenericTypeDefs.h"
#include "usb_kb/HID.h"
#include "usb_kb/MAX3421E.h"
#include "usb_kb/transfer.h"
#include "usb_kb/usb_ch9.h"
#include "usb_kb/USB.h"
#include "usb_kb/raphnet.h"

#include "note.h"
#include "util.h"

extern HID_DEVICE hid_device;

static BYTE addr = 1; 				//hard-wired USB address
const char* const devclasses[] = { " Uninitialized", " HID Keyboard", " HID Mouse", " Mass storage" , "Raphnet"};

BYTE GetDriverandReport() {
	BYTE i;
	BYTE rcode;
	BYTE device = 0xFF;
	BYTE tmpbyte;

	DEV_RECORD* tpl_ptr;
	printf("Reached USB_STATE_RUNNING (0x40)\n");
	for (i = 1; i < USB_NUMDEVICES; i++) {
		tpl_ptr = GetDevtable(i);
		if (tpl_ptr->epinfo != NULL) {
			printf("Device: %d", i);
			printf("%s \n", devclasses[tpl_ptr->devclass]);
			device = tpl_ptr->devclass;
		}
	}

	if (device == RAPHNET) {
		printf("Device is the raphnet, don't bother with this.\n");
		return device;
	}
	//Query rate and protocol
	rcode = XferGetIdle(addr, 0, hid_device.interface, 0, &tmpbyte);
	if (rcode) {   //error handling
		printf("GetIdle Error. Error code: ");
		printf("%x \n", rcode);
	} else {
		printf("Update rate: ");
		printf("%x \n", tmpbyte);
	}
	printf("Protocol: ");
	rcode = XferGetProto(addr, 0, hid_device.interface, &tmpbyte);
	if (rcode) {   //error handling
		printf("GetProto Error. Error code ");
		printf("%x \n", rcode);
	} else {
		printf("%d \n", tmpbyte);
	}
	return device;
}

int main()
{
	test_sgtl();

	struct note_struct* base = (struct note_struct*) VGA_TEXT_MODE_CONTROLLER_0_BASE;
	struct note_struct tmp;

	int first_note_index = 0;
	int last_note_index = 0;

	alt_u64 curr_time = 0;
	alt_u64 curr_time_ms = 0;
	alt_u64 delta_time_ms = 0;
	alt_u32 timer_rate = alt_timestamp_freq()*SPEEDHAX;
	alt_u32 timer_rate_ms = timer_rate/1000;

	int combo = 0;
	int score = 0;

	int prev_buttons = 0;
	int frets_changed = 1;

	int isHOPO = 0;

	BYTE rcode;
	RAPHNET_REPORT raphnet_buf;

	BYTE runningdebugflag = 0;//flag to dump out a bunch of information when we first get to USB_STATE_RUNNING
	BYTE device;
	WORD buttons = 0;

	printf("initializing MAX3421E...\n");
	MAX3421E_init();
	printf("initializing USB...\n");
	USB_init();
	printf("Entering loop...\n");

	alt_timestamp_start();

	printSignedHex0(0);
	printSignedHex1(0);


	while(1){
		//USB stuff
		MAX3421E_Task();
		USB_Task();
		if (GetUsbTaskState() == USB_STATE_RUNNING) {
			if (!runningdebugflag) {
				runningdebugflag = 1;
				setLED(9);
				device = GetDriverandReport();
			} if (device == RAPHNET) {
				rcode = raphnetPoll(&raphnet_buf);
				//if (rcode == hrNAK)
					//continue;

				if (rcode != hrNAK && buttons != raphnet_buf.buttons){
					buttons = raphnet_buf.buttons;
					//printf("Buttons: %4x\n", buttons);
				}
			}
		}


		int frets = buttons & FRET_MASK; //IORD_ALTERA_AVALON_PIO_DATA(FRETS_PIO_BASE);
		tmp.note = frets;
		tmp.ypos = FRETS_Y;
		base[0].data = tmp.data;

		if (buttons != prev_buttons)
			frets_changed = 1;

		if ((buttons & STRUM_MASK) != (prev_buttons & STRUM_MASK)){
			prev_buttons = buttons;
			if ((buttons & (B_STRUMDOWN | B_STRUMUP))) {
				if (get_notetime_ms(beats[first_note_index]) - (signed)curr_time_ms < HIT_WINDOW_FORWARD
						&& (signed)curr_time_ms - get_notetime_ms(beats[first_note_index]) < HIT_WINDOW_REVERSE) {
					if (frets >= (notes[first_note_index] & FRET_MASK) && frets < (notes[first_note_index] << 1)){
						//printf("Hit at Note index: %d, time %llu\n", note_index, curr_time_ms);
						first_note_index++;
						if (beats[first_note_index]-beats[first_note_index-1] <= resolution/3)
							isHOPO = 1;
						else
							isHOPO = 0;
						score++;
						combo++;
						printSignedHex0(combo);
						printSignedHex1(score);
						//printf("Score: %d\n", score);
					} else {
						printf("Miss at %d: incorrect frets. %x %x\n", first_note_index, frets, (notes[first_note_index] & FRET_MASK));
						combo = 0;
						printSignedHex0(combo);
					}
				} else {
					printf("Miss at %d: outside of hit window. %llu %llu\n", first_note_index, get_notetime_ms(beats[first_note_index]) - curr_time_ms);
					combo = 0;
					printSignedHex0(combo);
				}
			}
			//printf("User pushed a fret.\n");
		}

		if (isHOPO) {
			prev_buttons = buttons;
			if (get_notetime_ms(beats[first_note_index]) - (signed)curr_time_ms < HIT_WINDOW_FORWARD
					&& (signed)curr_time_ms - get_notetime_ms(beats[first_note_index]) < HIT_WINDOW_REVERSE
					&& frets_changed && combo) {
				printf("In hopo window\n");
				if (frets >= (notes[first_note_index] & FRET_MASK) && frets < (notes[first_note_index] << 1)){
					frets_changed = 0;
					//printf("hopo %d %d %d\n", frets, notes[note_index]&FRET_MASK, (notes[note_index] << 1));
					//printf("Hit at Note index: %d, time %llu\n", note_index, curr_time_ms);
					first_note_index++;
					if (beats[first_note_index]-beats[first_note_index-1] <= resolution/3)
						isHOPO = 1;
					else
						isHOPO = 0;
					score++;
					combo++;
					printSignedHex0(combo);
					printSignedHex1(score);
					//printf("Score: %d\n", score);
				} else {
					printf("Missed hopo. %x %x\n", frets & FRET_MASK, notes[first_note_index]);
				}
				printf("In hopo hit window\n");
			}
		}


		long long note_time;
		while ((note_time = get_notetime_ms(beats[first_note_index])) + HIT_WINDOW_REVERSE < curr_time_ms) {
			//printf("Note time: %llu, Current time: %llu\n", note_time, curr_time_ms);
			//printf("skipping Note index: %d\n", note_index);
			first_note_index++;
			if (beats[first_note_index]-beats[first_note_index-1] <= resolution/3 && beats[first_note_index] != beats[first_note_index-1])
				isHOPO = 1;
			else
				isHOPO = 0;
			combo = 0;
		}

		//Calculate the amount that all notes should move
		//Move all note objects that amount
		int delta_pos = NOTE_POS(delta_time_ms);

		for (int i = 0; i < VGA_TEXT_MODE_CONTROLLER_0_NOTE_COUNT; i++) {
			base[i+1].ypos += delta_pos;
		}

		//this does not give us the new note though, we need to keep track of the last note on the screen
		//as well as the first note.

		int temp = last_note_index;

		while (get_notetime_ms(beats[temp+1]) - (signed)curr_time_ms <= NOTE_TIME(420)) {
			//printf("Advance to next note: %d\n", temp+1);
			//printf("redrawing\n");
			for (int i = 0; i < VGA_TEXT_MODE_CONTROLLER_0_NOTE_COUNT; i++) {
				unsigned long long notetime = get_notetime_ms(beats[first_note_index+i]);
				if (notetime - NOTE_TIME(420) <= curr_time_ms && notetime + NOTE_TIME(60) >= curr_time_ms) {
					tmp.note = notes[first_note_index + i];
					if (first_note_index && beats[first_note_index+i]-beats[first_note_index+i-1] <= resolution/3 &&
							beats[first_note_index+i] != beats[first_note_index+i-1])
						tmp.note += BIT(5);
					tmp.ypos = NOTE_POS(curr_time_ms - (notetime-NOTE_TIME(420)));
					base[i+1].data = tmp.data;
				} else {
					tmp.note = 0;
					base[i+1].data = tmp.data;
				}
			}
			//printf("lastnoteindex: %d\n", last_note_index);
			last_note_index++;
			temp++;
		}

		/*
		while (get_notetime_ms(beats[last_note_index]) - (signed)curr_time_ms <= NOTE_TIME(420)) {
			printf("redrawing\n");
			for (int i = 0; i < VGA_TEXT_MODE_CONTROLLER_0_NOTE_COUNT; i++) {
				unsigned long long notetime = get_notetime_ms(beats[first_note_index+i]);
				if (notetime - NOTE_TIME(420) <= curr_time_ms && notetime + NOTE_TIME(60) >= curr_time_ms) {
					tmp.note = notes[first_note_index + i];
					if (first_note_index && beats[first_note_index+i]-beats[first_note_index+i-1] <= resolution/3)
						tmp.note += BIT(5);
					tmp.ypos = NOTE_POS(curr_time_ms - (notetime-NOTE_TIME(420)));
					base[i+1].data = tmp.data;
				} else {
					tmp.note = 0;
					base[i+1].data = tmp.data;
				}
			}
			//printf("lastnoteindex: %d\n", last_note_index);
			last_note_index++;
		}
		*/
		if (last_note_index)
			last_note_index--;


		/*
		for (int i = 0; i < VGA_TEXT_MODE_CONTROLLER_0_NOTE_COUNT-5; i++) {
			unsigned long long notetime = get_notetime_ms(beats[note_index+i]);
			if (notetime - NOTE_TIME(420) <= curr_time_ms && notetime + NOTE_TIME(60) >= curr_time_ms) {
				tmp.note = notes[note_index + i];
				if (note_index && beats[note_index+i]-beats[note_index+i-1] <= resolution/3)
					tmp.note += BIT(5);
				tmp.ypos = NOTE_POS(curr_time_ms - (notetime-NOTE_TIME(420)));
				base[i+1].data = tmp.data;
			} else {
				tmp.note = 0;
				base[i+1].data = tmp.data;
			}
		}
		*/

		if (alt_timestamp() - curr_time >= timer_rate_ms) {
			curr_time = alt_timestamp();
			int prev = curr_time_ms;
			curr_time_ms = curr_time/timer_rate_ms;
			delta_time_ms = curr_time_ms - prev;
			//printf("Current Time: %lld\n", curr_time/timer_rate_ms);
		}

	}
}
