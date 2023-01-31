// Using code from intro to Quartus tutorial
// Dimov and Shin

module full_adder2(
	input x, y, z,
	output s, c, p, g
	);

	assign s = x^y^z; // x XOR y XOR z determines parity of sum (s)
	assign c = (x&y)|(y&z)|(x&z); // any two bits as one or all three makes a carry
	// because sum >= 2
	
	// additional outputs for convenient abstraction for the Carry Look-ahead Adder
	assign p = x^y; // propogate output, x XOR y, 
	assign g = x&y; // generate output, x AND y, 
	
endmodule