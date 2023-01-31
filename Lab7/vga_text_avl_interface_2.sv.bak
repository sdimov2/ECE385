/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [9:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [31:0] LOCAL_REG       [`NUM_REGS]; // Registers

logic [10:0] charAddr, charAddrBase;
logic [7:0] charByte;

//put other local variables here


//Declare submodules..e.g. VGA controller, ROMS, etc

font_rom myRom(
	.addr(charAddr), .data(charByte)
);
/*
module font_rom ( input [10:0]	addr,
		output [7:0]	data
		);
*/
   
logic pixelClk;
logic [9:0] DrawX, DrawY;
vga_controller controller0(
	.Clk (CLK), .Reset (RESET),
	.hs (hs), .vs (vs), .pixel_clk(pixelClk),
	.blank(), .sync(), .DrawX(DrawX), .DrawY(DrawY)
);
/*
module  vga_controller ( input        Clk,       // 50 MHz clock
		Reset,     // reset signal
		output logic hs,        // Horizontal sync pulse.  Active low
		vs,        // Vertical sync pulse.  Active low
		pixel_clk, // 25 MHz pixel clock output
		blank,     // Blanking interval indicator.  Active low.
		sync,      // Composite Sync signal.  Active low.  We don't use it in this lab,
					//   but the video DAC on the DE2 board requires an input for it.
		output [9:0] DrawX,     // horizontal coordinate
		DrawY );   // vertical coordinate
*/


// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge CLK) begin
	if (RESET) 
	begin
		LOCAL_REG <= '{default:16'h0000};
	end
	else if (AVL_CS && AVL_WRITE) 
	begin
		if (AVL_BYTE_EN[3] == 1)
			LOCAL_REG[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
		if (AVL_BYTE_EN[2] == 1)
			LOCAL_REG[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
		if (AVL_BYTE_EN[1] == 1)
			LOCAL_REG[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
		if (AVL_BYTE_EN[0] == 1)
			LOCAL_REG[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
	end
	else if (AVL_READ && AVL_CS)
		AVL_READDATA[31:0] <= LOCAL_REG[AVL_ADDR][31:0];
end
/*
always_comb begin
	 Line below should not use divide according to cheng
	4 bytes at one 32-bit address, little endian order
	
	
	int j;
	BYTE_ADDRESS = AVL_ADDR*4+j;
	ROW = BYTE_ADDRESS/80;
	COLUMN = BYTE_ADDRESS%80;
end
*/
/*
r = byte[byteindex];
g = byte[byteindex];
b = byte[byteindex];
byteindex = DrawX % 8;
byte = [DrawY % 16];


*/

logic [9:0] regAddr, regAddrBase;


always_ff @ (negedge hs) // At the end of every horizontal scan, increment row # and set addr accordingly
begin
	regAddrBase = DrawY[9:4] * 20; // DrawY [9:4] is the row number (pixels) divided by 16, which is the row number in chars 
	// Multiply by 20 because 80 chars per row, 4 chars per register
end

/*
always_ff @ (negedge vs) // At the end of every vertical scan, reset row # and addr
begin
	regAddrBase = 0; // reset address base
end
*/ // shouldn't be necessary


//always_ff @ (posedge CLK) // Line, pixel to addr
always_comb
begin
	regAddr <= regAddrBase + {5'b0, DrawX[9:5]}; // take the base for the address and add 
	// 1/32 of the horizontal coordinate, as there are 32 pixels per register
end

logic inv;
always_comb begin // x coordinate to byte #
	case (DrawX[4:3]) // these bits represent every 8 bits
		2'b00 : 
		begin
			charAddr[10:4] = LOCAL_REG[regAddr][6:0]; // Only use 7 LSB as BIT7 is inversion, we will use that later
			inv = LOCAL_REG[regAddr][7];
		end
		2'b01 : 
		begin
			charAddr[10:4] = LOCAL_REG[regAddr][14:8]; // Put these 7LSB into 7 MSB of address for rom, as the 4 LSB represent the 16 columns per char
			inv = LOCAL_REG[regAddr][15];
		end
		2'b10 : 
		begin
			charAddr[10:4] = LOCAL_REG[regAddr][22:16];
			inv = LOCAL_REG[regAddr][23];
		end
		2'b11 : 
		begin
			charAddr[10:4] = LOCAL_REG[regAddr][30:24];
			inv = LOCAL_REG[regAddr][31];
		end
	endcase
	charAddr[3:0] = DrawY[3:0]; // LSB of both should match
end


logic bitRelevant, bitWithInv;
always_comb begin
	case (DrawX[2:0]) // font_rom slices [7:0] but DrawX slices [0:799], counting up.
		3'b000 : bitRelevant = charByte[7];
		3'b001 : bitRelevant = charByte[6];
		3'b010 : bitRelevant = charByte[5];
		3'b011 : bitRelevant = charByte[4];
		3'b100 : bitRelevant = charByte[3];
		3'b101 : bitRelevant = charByte[2];
		3'b110 : bitRelevant = charByte[1];
		3'b111 : bitRelevant = charByte[0];
	endcase
	bitWithInv = bitRelevant ^ inv;
end

always_ff @ (posedge pixelClk) begin
	if ((DrawX < 640) && (DrawY < 480))
	begin
		case(bitWithInv)
		1'b0 : // if 0 go background
		begin
			red <= LOCAL_REG[600][12:9];
			green <= LOCAL_REG[600][8:5];
			blue <= LOCAL_REG[600][4:1];
		end
		1'b1 : // if 1 go foreground
		begin
			red <= LOCAL_REG[600][24:21];
			green <= LOCAL_REG[600][20:17];
			blue <= LOCAL_REG[600][16:13];
		end
		endcase
	end
	else
	begin // If out of bounds, make colors background
			red <= LOCAL_REG[600][24:21];
			green <= LOCAL_REG[600][20:17];
			blue <= LOCAL_REG[600][16:13];
	end
end	
//handle drawing (may either be combinational or sequential - or both).
		



endmodule
