module testbench ();

timeunit 10ns;
timeprecision 1ns;

// Inputs
logic Clk = 0; // init as 0
logic Reset_Load_Clear, Run_Accumulate; // Clk, reset, execute
	// All active low
logic [9:0] SW;	// Switches

// Outputs
logic [9:0] LED;  // LED wires
logic [16:0] Dval;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

adder2 multiplier1(.*); // Instantiate with all same-name variables

always begin : Clock
	#1 Clk = ~Clk; // Every time unit, invert clock
end

/*
initial begin: Clock_init
	Clk = 0;
end
// Use if setting clock to 0 at declaration doesn't work
*/


initial begin : ZEROS
	SW = 10'b0000000000;
	Reset_Load_Clear = 1'b1;
	Run_Accumulate = 1'b1; 
end

initial begin : TEST
	SW = 10'b1111111101;
	#4 Reset_Load_Clear = 1'b0;
	#4 Reset_Load_Clear = 1'b1; // Reset and load
	
	SW = 10'b1111111010;
	#4 Run_Accumulate = 1'b0;
	#4 Run_Accumulate = 1'b1; // Run
end



endmodule 