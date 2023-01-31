module register_generic ( // Generic 16-bit rising edge register
	input logic Clk, en,
	input logic [15:0] data_in,
	output logic [15:0] data_reg
);

always_ff @ (posedge Clk)
begin
	if(en)
		data_reg <= data_in;
end

endmodule 



/*
module register_file ( // Generic 16-bit rising edge register
	input logic Clk, en, LD_REG, DR, SR, 	//added LD_REG, DR, SR for 2:1 mux selects and load enabling
	input logic [15:0] data_in, IR,			// IR added
	output logic [15:0] SR1, SR2			// SR 1&2 are outputs of this module
);

always_ff @ (posedge Clk && LD_REG)			// added && LD_REG to only be enabled when high, not sure if this is its correct function/purpose or syntax tbh


//from above example
begin
	if(en)
		data_reg <= data_in;
end


always_comb
begin
	SR2[2:0] = IR[11:9];					// this segment controls the SR2 register output with the DR mux
	if(DR)
		SR2[2:0] = 3'b1;

	SR1[2:0] = IR[8:6];						// this controls the SR1 register output with the SR1mux
	if (SR)
		SR1[2:0] = IR[11:9];
	
end

endmodule 
*/