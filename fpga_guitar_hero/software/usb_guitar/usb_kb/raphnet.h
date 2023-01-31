// C:\Users\byron\Documents\ece385\fpga_guitar_hero\software\usb_guitar\raphnet.h


/*char ReportDescriptor[76] = {
    0x05, 0x01,                    // USAGE_PAGE (Generic Desktop)
    0x09, 0x05,                    // USAGE (Game Pad)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x85, 0x01,                    //   REPORT_ID (1)
    0x95, 0x01,                    //   REPORT_COUNT (1)
    0xa1, 0x00,                    //   COLLECTION (Physical)
    0x09, 0x30,                    //     USAGE (X)
    0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
    0x26, 0x00, 0x7d,              //     LOGICAL_MAXIMUM (32000)
    0x35, 0x00,                    //     PHYSICAL_MINIMUM (0)
    0x45, 0x00,                    //     PHYSICAL_MAXIMUM (0)
    0x65, 0x00,                    //     UNIT (None)
    0x55, 0x00,                    //     UNIT_EXPONENT (0)
    0x75, 0x10,                    //     REPORT_SIZE (16)
    0x95, 0x01,                    //     REPORT_COUNT (1)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0x09, 0x31,                    //     USAGE (Y)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0x09, 0x33,                    //     USAGE (Rx)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0x09, 0x34,                    //     USAGE (Ry)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0x09, 0x35,                    //     USAGE (Rz)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0x09, 0x32,                    //     USAGE (Z)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0xc0,                          //     END_COLLECTION
    0x09, 0x00,                    //   USAGE (Undefined)
    0xa1, 0x00,                    //   COLLECTION (Physical)
    0x05, 0x09,                    //     USAGE_PAGE (Button)
    0x19, 0x01,                    //     USAGE_MINIMUM (Button 1)
    0x29, 0x0a,                    //     USAGE_MAXIMUM (Button 10)
    0x25, 0x01,                    //     LOGICAL_MAXIMUM (1)
    0x45, 0x01,                    //     PHYSICAL_MAXIMUM (1)
    0x75, 0x01,                    //     REPORT_SIZE (1)
    0x95, 0x10,                    //     REPORT_COUNT (16)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0xc0,                          //     END_COLLECTION
    0xc0                           // END_COLLECTION
};
*/

typedef union {
	struct {
		BYTE byte1;
		WORD joy1;
		WORD joy2;
		WORD idk[3];
		WORD whammy;
		WORD buttons;
	}  __attribute__ ((packed));
} RAPHNET_REPORT;

BYTE raphnetPoll(RAPHNET_REPORT* buf);

