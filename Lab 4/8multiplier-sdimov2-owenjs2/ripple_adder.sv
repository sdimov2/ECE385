module ripple_adder
(
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    /*
     * Your code should be completly combinational (don't use always_ff or always_latch).
	  
	  Ripple adder using 4-bit ripple adders
	  Dimov and Shin code
     */
	  
	  	logic cc4, cc8, cc12; // number is which full adder it's going into
		// since adders are 0:3, 4:7, 8:11, and 12:15
		
		
		//			x[k:k+3]							carry in k						carry out k+3
		//								y[k:k+3]							s[k:k+3]
		full_adder_4 FFA0(.x (A[3:0]), .y (B[3:0]), .cin (cin), .s (S[3:0]), .cout (cc4));
		full_adder_4 FFA1(.x (A[7:4]), .y (B[7:4]), .cin (cc4), .s (S[7:4]), .cout (cc8));
		full_adder_4 FFA2(.x (A[11:8]), .y (B[11:8]), .cin (cc8), .s (S[11:8]), .cout (cc12));
		full_adder_4 FFA3(.x (A[15:12]), .y (B[15:12]), .cin (cc12), .s (S[15:12]), .cout (cout));
		
     
endmodule
