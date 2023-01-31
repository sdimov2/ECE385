#include <stdio.h>

#include "../usb_kb/project_config.h"

BYTE bigbuf[256];   //256 bytes
extern DEV_RECORD devtable[];

extern HID_DEVICE hid_device;
extern EP_RECORD hid_ep[2];

BOOL RaphnetProbe(BYTE addr, DWORD flags) {
	BYTE tmpbyte;
	BYTE rcode;
	BYTE confvalue;
	WORD total_length;
	USB_DESCR* data_ptr = (USB_DESCR *) &bigbuf;
	int skip = 0;
	BYTE* byte_ptr = bigbuf;

	printf("\nBeginning Raphnet Probe.\n");

	rcode = XferGetConfDescr(addr, 0, CONF_DESCR_LEN, 0, bigbuf); //get configuration descriptor
	if (rcode) {   //error handling
		printf("unable to get configuration descriptor");
		return (FALSE);
	}
	if (data_ptr->descr.config.wTotalLength > 256) {
		total_length = 256;
	} else {
		total_length = data_ptr->descr.config.wTotalLength;
	}
	rcode = XferGetConfDescr(addr, 0, total_length, 0, bigbuf); //get the whole configuration
	if (rcode) {   //error handling
		printf("unable to get configuration");
		return (FALSE);
	}

	for (int i = 0; i < total_length; i++){
		printf("%x ", bigbuf[i]);
	}

	confvalue = data_ptr->descr.config.bConfigurationValue;
	while (byte_ptr < bigbuf + total_length) {             //parse configuration
		if (data_ptr->descr.config.bDescriptorType != USB_DESCRIPTOR_INTERFACE) { //skip to the next descriptor
			byte_ptr = byte_ptr + data_ptr->descr.config.bLength;
			data_ptr = (USB_DESCR*) byte_ptr;
			printf("|");
		} // if( data_ptr->descr.config.bDescriptorType != USB_DESCRIPTOR_INTERFACE
		else {
			//Need to skip the first interface.
			if (skip == 0) {
				printf("Skipped first interface\n");
				byte_ptr = byte_ptr + data_ptr->descr.config.bLength;
				data_ptr = (USB_DESCR*) byte_ptr;
				skip = 1;
				continue;
			}
			printf("Data offset: %d\n", byte_ptr - bigbuf);
			if (bigbuf[44] != HID_DESCRIPTOR_HID){
				return FALSE;
			}

			devtable[addr].devclass = RAPHNET;
			tmpbyte = devtable[addr].epinfo->MaxPktSize;
			HID_init();                         //initialize data structures
			devtable[addr].epinfo = hid_ep; //switch endpoint information structure
			devtable[addr].epinfo[0].MaxPktSize = tmpbyte;
			hid_device.interface =
					data_ptr->descr.interface.bInterfaceNumber;
			printf("Interface number: %d\n", hid_device.interface);
			hid_device.addr = addr;
			byte_ptr = byte_ptr + data_ptr->descr.config.bLength;
			data_ptr = (USB_DESCR*) byte_ptr;
			while (byte_ptr < bigbuf + total_length) {
				if (data_ptr->descr.config.bDescriptorType
						!= USB_DESCRIPTOR_ENDPOINT) { //skip to endpoint descriptor
					byte_ptr = byte_ptr + data_ptr->descr.config.bLength;
					data_ptr = (USB_DESCR*) byte_ptr;
				} else {
					printf("byte_ptr offset: %d\n", byte_ptr - bigbuf);
					/* fill endpoint information structure */
					devtable[addr].epinfo[1].epAddr =
							data_ptr->descr.endpoint.bEndpointAddress;
					devtable[addr].epinfo[1].Attr =
							data_ptr->descr.endpoint.bmAttributes;
					devtable[addr].epinfo[1].MaxPktSize =
							data_ptr->descr.endpoint.wMaxPacketSize;
					devtable[addr].epinfo[1].Interval =
							data_ptr->descr.endpoint.bInterval;
					// devtable[ addr ].epinfo[ 1 ].rcvToggle = bmRCVTOG0;
					/* configure device */

					printf("endpoint address: %x\n", devtable[addr].epinfo[1].epAddr);

					rcode = XferSetConf(addr, 0, confvalue); //set configuration
					if (rcode) {   //error handling
						printf("Failed to set conf: %x\n", rcode);
						return (FALSE);
					}

					printf("Max packet size: %d\n", devtable[hid_device.addr].epinfo[1].MaxPktSize);

					//rcode = XferSetProto(addr, 2, hid_device.interface,
						//RPT_PROTOCOL);
					if (rcode) {   //error handling
						printf("Failed to set proto: %x\n", rcode);
						return (FALSE);
					} else {
						return (TRUE);
					}
				}
			}
		}
	}
	return FALSE;
}

BYTE raphnetPoll(RAPHNET_REPORT* buf) {
	BYTE rcode;
	MAXreg_wr( rPERADDR, hid_device.addr);    //set peripheral address
	rcode = XferInTransfer(hid_device.addr, 1, 14, (BYTE*) buf,
			devtable[hid_device.addr].epinfo[1].MaxPktSize);
	return (rcode);
}

BOOL RaphnetEventHandler(BYTE address, BYTE event, void *data, DWORD size) {
	return (FALSE);
}
