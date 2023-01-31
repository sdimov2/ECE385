module testbench ();

timeunit 10ns;
timeprecision 1ns;

parameter int N = 5;

//inputs
logic start, Clk; 		// Start signal to change to counting state, clock signal

//outputs
logic countActive; 		// Is equal to the state for whether it's counting
logic countEnd; 			// Goes high when T == T'
logic [N-1:0] countT; 		// Values in counter



timerTest0 my_timerTest(.*); // Instantiate with all same-name variables

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
	start = 1'b0;
end

initial begin : TEST
	#2 start = 1'b1;
	#2 start = 1'b0;
	
	
end



endmodule 