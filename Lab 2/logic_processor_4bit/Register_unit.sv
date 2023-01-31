module register_unit (input  logic Clk, Reset, A_In, B_In, Ld_A, Ld_B, 
                            Shift_En,
                      input  logic [7:0]  D, // 7:0 
                      output logic A_out, B_out, 
                      output logic [7:0]  A,  // 7:0
                      output logic [7:0]  B);   //   7:0


    reg_4  reg_A (.*, .Shift_In(A_In), .Load(Ld_A),
	               .Shift_Out(A_out), .Data_Out(A));
    reg_4  reg_B (.*, .Shift_In(B_In), .Load(Ld_B),
	               .Shift_Out(B_out), .Data_Out(B));

endmodule
