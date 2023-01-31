// double CRA Mux

module precomp_CRA (
	input [3:0] x, y,
	input cin,
	output [3:0] s,
	output cout
	);
	
	logic cout0, cout1;
	logic [3:0] s0, s1;
	
	full_adder_4 FAF0( .cin (0), .x (x[3:0]), .y (y[3:0]), .s (s0[3:0]), .cout (cout0) );
	full_adder_4 FAF1( .cin (1), .x (x[3:0]), .y (y[3:0]), .s (s1[3:0]), .cout (cout1) );
	
	assign cout = cout0 | cout1 & cin;
	
	
	assign s = cin ? s1 : s0;
	
endmodule