module palette_ROM ( input [3:0]	addr,
						output [13:0]	data
					 );

	parameter ADDR_WIDTH = 4;
   parameter DATA_WIDTH =  12;
	logic [ADDR_WIDTH-1:0] addr_reg;
				
	// ROM definition				
	parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {

	12'h000,
	12'hFFF,
	12'h888,
	12'hF88,
	12'h8F8,
	12'h88F,
	12'hF00,
	12'h0F0,
	12'h00F,
	12'h8FF,
	12'hF8F,
	12'hFF8,
	12'h0FF,
	12'hF0F,
	12'hFF0,
	12'h000
   };

	assign data = ROM[addr];

endmodule  