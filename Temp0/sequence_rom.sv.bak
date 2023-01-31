module sequence_rom ( input [3:0]	addr,
						output [14:0]	data
					 );

	parameter ADDR_WIDTH = 4;
   parameter DATA_WIDTH =  15; // 3 bits per note (8 possible note states), x 5 columns
	logic [ADDR_WIDTH-1:0] addr_reg;
				
	// ROM definition				
	parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = { //not sure what to do here left as is
        15'b001000000000000, // 0
        15'b000000000000000, // 1
        15'b001001000000000, // 2
        15'b001000000000000, // 3
        15'b000000000000000, // 4
        15'b001000000000000, // 5
        15'b001000000000000, // 6
        15'b001000000000000, // 7
        15'b001000000000000, // 8
        15'b000001001000000, // 9
        15'b000000000001000, // a
        15'b000000000000001, // b
        15'b000000000001000, // c
        15'b000000001000000, // d
        15'b000001000000000, // e
        15'b001000000000000, // f
         // code x01
        };

	assign data = ROM[addr];

endmodule  