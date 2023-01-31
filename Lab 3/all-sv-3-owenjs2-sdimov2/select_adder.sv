module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    /* TODO
     *
     * Insert code here to implement a CSA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. 
	  
	  
	input [3:0] x, y,
	input cin,
	output [3:0] s,
	output cout
	*/
		assign c[0] = cin;
		logic [4:0] c;
		
		full_adder_4 FAF0( .cin (c[0]), .x (A[3:0]), .y (B[3:0]), .s (S[3:0]), .cout (c[1]) );
		
		precomp_CRA pc_CRA0 (.cin (c[1]), .x (A[7:4]), .y (B[7:4]), .s (S[7:4]), .cout (c[2]) );
		precomp_CRA pc_CRA1 (.cin (c[2]), .x (A[11:8]), .y (B[11:8]), .s (S[11:8]), .cout (c[3]) );
		precomp_CRA pc_CRA2 (.cin (c[3]), .x (A[15:12]), .y (B[15:12]), .s (S[15:12]), .cout (cout) );

endmodule
