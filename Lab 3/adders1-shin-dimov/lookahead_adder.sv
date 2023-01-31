module lookahead_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  
	  /*
	  reference i/o of CLA_adder:
	  
	input cin,
	input [3:0] x, y,
	output [3:0] s, PG, GG,
	output cout*/
	  
	  logic [3:0] Pg, Gg, ins;
	  
	  assign ins[0] = cin;
	  
	  CLA_adder CLA_0( .cin (ins[0]), .x (A[3:0]), .y (B[3:0]), .s (S[3:0]), .PG (Pg[0]), .GG (Gg[0]), .cout () );
	  CLA_adder CLA_1( .cin (ins[1]), .x (A[7:4]), .y (B[7:4]), .s (S[7:4]), .PG (Pg[1]), .GG (Gg[1]), .cout () );
	  CLA_adder CLA_2( .cin (ins[2]), .x (A[11:8]), .y (B[11:8]), .s (S[11:8]), .PG (Pg[2]), .GG (Gg[2]), .cout () );
	  CLA_adder CLA_3( .cin (ins[3]), .x (A[15:12]), .y (B[15:12]), .s (S[15:12]), .PG (Pg[3]), .GG (Gg[3]), .cout () );

	  
	  CLA_gen CLA_4( .cin(cin), .p(Pg[3:0]), .g(Gg[3:0]), .c(ins[3:0]), .cout(cout), .PG(), .GG());

endmodule
