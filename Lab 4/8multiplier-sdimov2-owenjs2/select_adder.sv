module select_adder (
	input add,
	input  [7:0] A, B, // A and S inputs
	input         cin, // subtract bit from control
	output [8:0] S // 9 bit output
);

		logic[7:0] S1, CC, ADD;
		
		always_comb
		begin
			/*case(cin)
				1'b0: A1 <= A;
				1'b1: A1 <= ~A;
				*/
			CC = {8{cin}};
			ADD = {8{add}};
				
			S1 = (B ^ CC) & 8'(ADD);
			
			
		end

		logic [2:0] c;
		
		full_adder_4 FAF0( .cin (cin & add), .x (A[3:0]), .y (S1[3:0]), .s (S[3:0]), .cout (c[1]) );
		
		precomp_CRA pc_CRA0 (.cin (c[1]), .x (A[7:4]), .y (S1[7:4]), .s (S[7:4]), .cout (c[2]) );
		full_adder Xadder (.z(c[2]), .x(A[7]), .y(S1[7]), .s(S[8]), .c(c[0])); //put a blank var if it freaks out
		
endmodule
