// CLA adder file dimov shin
module CLA_adder(
	input cin,
	input [3:0] x, y,
	output [3:0] s,
	output cout, PG, GG
	);
	
	logic [3:0] p, g, c;
	
	full_adder2 FA2_0(.x (x[0]), .y (y[0]), .z (c[0]), .s (s[0]), .p (p[0]), .g (g[0]) );
	full_adder2 FA2_1(.x (x[1]), .y (y[1]), .z (c[1]), .s (s[1]), .p (p[1]), .g (g[1]) );
	full_adder2 FA2_2(.x (x[2]), .y (y[2]), .z (c[2]), .s (s[2]), .p (p[2]), .g (g[2]) );
	full_adder2 FA2_3(.x (x[3]), .y (y[3]), .z (c[3]), .s (s[3]), .p (p[3]), .g (g[3]) );
	
	CLA_gen CLA0(.cin (cin), .p (p[3:0]), .g (g[3:0]), .c (c[3:0]), .cout (cout), .PG (PG), .GG (GG) );
	
	
	
endmodule