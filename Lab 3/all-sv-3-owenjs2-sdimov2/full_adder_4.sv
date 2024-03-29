// Ripple adder of 4 full adders
// Dimov and Shin

module full_adder_4(
	input [3:0] x, y,
	input cin,
	output [3:0] s,
	output cout
	);
	
	// internal bits for the adder
	// carries from adder 0 to adder 1, adder 1 to 2,
	// and adder 2 to 3
	logic c1, c2, c3; // number is which adder it's going into
	
	
		//			x				y			carry in			s			carry out
	full_adder FA0(.x (x[0]), .y (y[0]), .z (cin), .s (s[0]), .c (c1));
	full_adder FA1(.x (x[1]), .y (y[1]), .z (c1), .s (s[1]), .c (c2));
	full_adder FA2(.x (x[2]), .y (y[2]), .z (c2), .s (s[2]), .c (c3));
	full_adder FA3(.x (x[3]), .y (y[3]), .z (c3), .s (s[3]), .c (cout));

endmodule