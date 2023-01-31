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

module vga_text_avl_interface#(
	parameter count = 3,
	parameter width = 2
)(
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
	input  logic [width-1:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);
//put other local variables here
logic blanksig, pixel_clk;

logic [9:0] drawxsig, drawysig;

logic note_active, fret_active;

logic [3:0] fret_red, fret_green, fret_blue;
logic [3:0] note_red, note_green, note_blue;

//Declare submodules..e.g. VGA controller, ROMS, etc
vga_controller m_vga_controller(
		.Clk(CLK),
		.Reset(RESET),
		.hs(hs),
		.vs(vs),
		.blank(blanksig),
		.DrawX(drawxsig),
		.DrawY(drawysig),
		.pixel_clk(pixel_clk)
	);
	
// each word represents a note
// [15:7][ 6 ][ 5  ][ 4 ][ 3 ][ 2 ][ 1 ][ 0 ]
// [ypos][TAP][HOPO][ORG][BLU][YEL][RED][GRN]
// what if we just do squares?
// if we store the memory as 480x32, then thats a lot less memory. (8 cause thats a power of 2)
// so instead of writing ypos, it just gets written to that memory location.

note_controller #(
	.count(count),
	.width(width)
) m_note_controller (
	.Reset(RESET),
	.clk(CLK),
	.screenX(drawxsig),
	.screenY(drawysig),
	.addr(AVL_ADDR-1),	//subtract one since we skipped 0
	.data_in(AVL_WRITEDATA),
	.data_out(AVL_READDATA),
	.write(AVL_WRITE && (AVL_ADDR != 0)),
	.read(AVL_READ && (AVL_ADDR != 0)),
	.be(AVL_BYTE_EN),
	.active(note_active),
	.red(note_red), .green(note_green), .blue(note_blue)
);

fret m_fret(
	.Reset(RESET),
	.clk(CLK),
	.screenX(drawxsig),
	.screenY(drawysig),
	.write(AVL_WRITE && (AVL_ADDR == 0)),
	.data_in(AVL_WRITEDATA),
	.active(fret_active),
	.red(fret_red),
	.green(fret_green),
	.blue(fret_blue)
);

always_comb begin
	if (fret_active) begin
		red = fret_red;
		green = fret_green;
		blue = fret_blue;
	end else if (note_active) begin
		red = note_red;
		green = note_green;
		blue = note_blue;
	end else begin
		red = 0;
		green = 0;
		blue = 0;
	end
end


endmodule
