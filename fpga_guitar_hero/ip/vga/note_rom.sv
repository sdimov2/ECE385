module note_rom(input [5:0] addr, output [39:0] data);

parameter ADDR_WIDTH = 6;
parameter DATA_WIDTH = 40;

logic [ADDR_WIDTH-1:0] addr_reg;

parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {
	40'b0000000000000000011111100000000000000000,
	40'b0000000000000111111111111110000000000000,
	40'b0000000000011111111111111111100000000000,
	40'b0000000001111111111111111111111000000000,
	40'b0000000011111111111111111111111100000000,
	40'b0000000111111111111111111111111110000000,
	40'b0000001111111111111111111111111111000000,
	40'b0000011111111111111111111111111111100000,
	40'b0000111111111111111111111111111111110000,
	40'b0001111111111111111111111111111111111000,
	40'b0001111111111111111111111111111111111000,
	40'b0011111111111111111111111111111111111100,
	40'b0011111111111111111111111111111111111100,
	40'b0111111111111111111111111111111111111110,
	40'b0111111111111111111111111111111111111110,
	40'b0111111111111111111111111111111111111110,
	40'b0111111111111111111111111111111111111110,
	40'b1111111111111111111111111111111111111111,
	40'b1111111111111111111111111111111111111111,
	40'b1111111111111111111111111111111111111111,
	40'b1111111111111111111111111111111111111111,
	40'b1111111111111111111111111111111111111111,
	40'b1111111111111111111111111111111111111111,
	40'b0111111111111111111111111111111111111110,
	40'b0111111111111111111111111111111111111110,
	40'b0111111111111111111111111111111111111110,
	40'b0111111111111111111111111111111111111110,
	40'b0011111111111111111111111111111111111100,
	40'b0011111111111111111111111111111111111100,
	40'b0001111111111111111111111111111111111000,
	40'b0001111111111111111111111111111111111000,
	40'b0000111111111111111111111111111111110000,
	40'b0000011111111111111111111111111111100000,
	40'b0000001111111111111111111111111111000000,
	40'b0000000111111111111111111111111110000000,
	40'b0000000011111111111111111111111100000000,
	40'b0000000001111111111111111111111000000000,
	40'b0000000000011111111111111111100000000000,
	40'b0000000000000111111111111110000000000000,
	40'b0000000000000000011111100000000000000000,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0,
	40'b0
	};
	
	assign data = ROM[addr];
	
endmodule
	