module reg_17 (input  Clk,
					input logic Load, Set, LoadA, Shift_En, Xin,
              input  logic [7:0]  Ain, Bin,   // For parallel loads
              output logic Add_Out,
              output logic [16:0]  Data_Out);    // 7:0

		// 17 shift register
		// X			A				B
		// 16 15			8	7			0
	 //logic X;
	 
    always_ff @ (posedge Clk)
    begin
		 if (LoadA)
			  Data_Out[16:8] <= {Xin, Ain}; // Fill A with inputted 9 bits
	 	 else if (Set) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out[16:8] <= 9'b000000000;  // Fill XA with 0
		 else if (Load)
		 begin
			  Data_Out[7:0] <= Bin; // Fill B with parallel input for B
			  Data_Out[16:8] <= 9'b000000000; // Fill XA with 0
		 end
		 else if (Shift_En)
		 begin
			  // switch Data_Out[15] and X, shift else to the right
			  // note this works because we are in always_ff procedure block
			  Data_Out <= { Data_Out[15], Data_Out[16], Data_Out[15:1] }; //  BIT15 to X, X to BIT15, [15:1] to [14:0]
	    end
    end
	
   // assign Data_Out[16] = X;
	 assign Add_Out = Data_Out[0]; // High to add S
endmodule