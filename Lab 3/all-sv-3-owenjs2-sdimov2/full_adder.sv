// Using code from intro to Quartus tutorial
// Dimov and Shin

module full_adder(
	input x, y, z,
	output s, c
	);

	assign s = x^y^z; // x XOR y XOR z determines parity of sum (s)
	assign c = (x&y)|(y&z)|(x&z); // any two bits as one or all three makes a carry
	// because sum >= 2
	
endmodule