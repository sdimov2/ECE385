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


module vga_text_avl_interface_3 (
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
	input  logic [10:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	input logic [9:0] DrawX, DrawY,
	output logic [3:0] reg_idx
);


logic [3:0] FGD_IDX, BKG_IDX;
always_comb
begin
	if (charAddr == 11'h000)
		reg_idx = 4'b0000; // Use null (transparent) if the character is null
	else
	begin
		case (bitWithInv) // Inverted bit
		1'b1: 
			reg_idx = FGD_IDX;
		1'b0:
			reg_idx = BKG_IDX;
		endcase
	end
end

logic writeRAM; // Signals to make NIOS II choose which thing to write to
always_comb 
begin : WriteEnable
	writeRAM = AVL_CS && AVL_WRITE; // Write to RAM when MSB is low, Table 8 in IAMM.18
end



logic [31:0] q;
assign AVL_READDATA = q;
RAMtrue2port myRAM(
	.byteena_a(AVL_BYTE_EN),
	.clock(CLK),
	.data(AVL_WRITEDATA),
	.rdaddress(RAMaddr),					//different from write address, we calculate RAMaddr
	.wraddress(AVL_ADDR[10:0]), 	// Write address for IP RAM is 11 bits because we need less than 2048 * 2
	.wren(writeRAM),
	.q(q)
);



logic [10:0] charAddr, charAddrBase;
logic [7:0] charByte;

//Declare submodules..e.g. VGA controller, ROMS, etc

font_rom myRom(
	.addr(charAddr), .data(charByte)
);


// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
logic [10:0] RAMaddr, RAMaddrBase;


//always_ff @ (negedge hs) // At the end of every horizontal scan, increment row # and set addr accordingly
always_comb
begin
	RAMaddrBase <= DrawY[9:4] * 40; // DrawY [9:4] is the row number (pixels) divided by 16, which is the row number in chars 
	// Multiply by 40 because 80 chars per row, 2 chars per register
end

always_comb
begin
	RAMaddr <= RAMaddrBase + {5'b0, DrawX[9:4]}; // take the base for the address and add 
	// 1/16 of the horizontal coordinate, as there are 16 pixels per register
end


logic inv;
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





endmodule
