// CLA adder dimov shin

module CLA_gen(
	input cin,
	input [3:0] p, g,
	output [3:0] c, 
	output cout, PG, GG
	);
	
	assign c[0] = cin;
	assign c[1] = cin&p[0] | g[0];
	assign c[2] = (cin&p[0] | g[0])&p[1] | g[1];
	assign c[3] = ((cin&p[0] | g[0])&p[1] | g[1])&p[2] | g[2];
	
	assign cout = (((cin&p[0] | g[0])&p[1] | g[1])&p[2] | g[2])&p[3] | g[3];
	assign PG = p[0]&p[1]&p[2]&p[3];
	assign GG = g[3] | g[2]&p[3] | g[1]&p[2]&p[3] | g[0]&p[1]&p[2]&p[3];
	
	
	
endmodule