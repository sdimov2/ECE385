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


module vga_text_avl_interface_2 (
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
	input  logic [11:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [31:0] Palette [0:7]; // 8 32-bit words for color palette
// arranged 0:7 since addresses are going to be done that way from NIOS II

logic writeRAM, writeREG; // Signals to make NIOS II choose which thing to write to
always_comb 
begin : WriteEnables
	writeRAM = AVL_CS && AVL_WRITE && (~AVL_ADDR[11]); // Write to RAM when MSB is low, Table 8 in IAMM.18
	writeREG = AVL_CS && AVL_WRITE && (AVL_ADDR[11]); // Write to REG when MSB is high, ^
end

always_ff @ (posedge CLK)
begin
	if(writeREG)
	begin // Addressing is really weird
		if (AVL_BYTE_EN[3] == 1)
			Palette[(AVL_ADDR[2:0])][24:21] <= AVL_WRITEDATA[27:24];
		if (AVL_BYTE_EN[2] == 1)
			Palette[(AVL_ADDR[2:0])][20:13] <= AVL_WRITEDATA[23:16];
		if (AVL_BYTE_EN[1] == 1)
			Palette[(AVL_ADDR[2:0])][12:9] <= AVL_WRITEDATA[11:8];
		if (AVL_BYTE_EN[0] == 1)
			Palette[(AVL_ADDR[2:0])][8:1] <= AVL_WRITEDATA[7:0];
	end
end




logic [31:0] q;
assign AVL_READDATA = q;
RAMtrue2port myRAM(
	.byteena_a(AVL_BYTE_EN),
	.clock(CLK),
	.data(AVL_WRITEDATA),
	.rdaddress(regAddr),					//different from write address, we calculate regAddr
	.wraddress(AVL_ADDR[10:0]), 	// Write address for IP is 12 bit, but RAM takes 11 bits
	.wren(writeRAM),
	.q(q)
);

/*
input	[3:0]  byteena_a;
input	  clock;
input	[31:0]  data;
input	[10:0]  rdaddress;
input	[10:0]  wraddress;
input	  wren;
output	[31:0]  q;
*/

logic [10:0] charAddr, charAddrBase;
logic [7:0] charByte;

//Declare submodules..e.g. VGA controller, ROMS, etc

font_rom myRom(
	.addr(charAddr), .data(charByte)
);
/*
module font_rom ( input [10:0]	addr,
		output [7:0]	data
		);
*/
   
logic pixelClk, blank;
logic [9:0] DrawX, DrawY;
vga_controller controller0(
	.Clk (CLK), .Reset (RESET),
	.hs (hs), .vs (vs), .pixel_clk(pixelClk),
	.blank(blank), .sync(), .DrawX(DrawX), .DrawY(DrawY)
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


logic [10:0] regAddr, regAddrBase;


always_ff @ (negedge hs) // At the end of every horizontal scan, increment row # and set addr accordingly
begin
	regAddrBase = DrawY[9:4] * 40; // DrawY [9:4] is the row number (pixels) divided by 16, which is the row number in chars 
	// Multiply by 40 because 80 chars per row, 2 chars per register
end

//always_ff @ (posedge CLK) // Line, pixel to addr
always_comb
begin
	regAddr <= regAddrBase + {5'b0, DrawX[9:4]}; // take the base for the address and add 
	// 1/16 of the horizontal coordinate, as there are 16 pixels per register
end


logic inv;
logic [3:0] BKG_IDX, FGD_IDX;
always_comb begin // x coordinate to byte #
	case (DrawX[3]) // this bit represents every 8 bits
		1'b0 : 
		begin
			BKG_IDX = q[3:0];
			FGD_IDX = q[7:4];
			charAddr[10:4] = q[14:8]; // Only use 7 LSB as BIT7 is inversion, we will use that later
			inv = q[15];
		end
		1'b1 : 
		begin
			BKG_IDX = q[19:16];
			FGD_IDX = q[23:20];
			charAddr[10:4] = q[30:24];
			inv = q[31];
		end
	endcase
	charAddr[3:0] = DrawY[3:0]; // LSB of both should match
end
//

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

logic [11:0] FGD_COLOR, BKG_COLOR;



always_comb 
begin
	if (BKG_IDX[0] == 1'b1)
	begin // LSB of index is 1
		BKG_COLOR = Palette[(BKG_IDX[3:1])][24:13]; // Color 1 is in 24:13
	end
	else  
	begin // LSB of index is 0
		BKG_COLOR = Palette[(BKG_IDX[3:1])][12:1]; // Color 0 is in 12:1
	end

	if (FGD_IDX[0] == 1'b1)
	begin // LSB of index is 1
		FGD_COLOR = Palette[(FGD_IDX[3:1])][24:13]; // Color 1 is in 24:13
	end  
	else  
	begin // LSB of index is 0
		FGD_COLOR = Palette[(FGD_IDX[3:1])][12:1]; // Color 0 is in 12:1
	end
end


always_ff @ (posedge pixelClk) 
begin
	if (blank)
	begin
		case(bitWithInv)
		
		1'b0 : // if 0 go background
		begin
			red <= BKG_COLOR[11:8]; 
			green <= BKG_COLOR[7:4];
			blue <= BKG_COLOR[3:0];
		end
		1'b1 : // if 1 go foreground
		begin
			red <= FGD_COLOR[11:8];
			green <= FGD_COLOR[7:4];
			blue <= FGD_COLOR[3:0];
		end
		endcase
	end
	else
	begin // If out of bounds, make colors black/null
			red <= 4'b0000;
			green <= 4'b0000;
			blue <= 4'b0000;
	end
end	

endmodule
