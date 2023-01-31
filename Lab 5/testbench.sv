module testbench();

timeunit 10ns;

timeprecision 1ns;

logic [15:0]    Data,  ADDR;
logic [9:0] 	 SW;
logic           Clk, Reset, Run, Continue;
logic           OE, CE, UB, LB, WE;
logic [9:0]    LED;
logic [6:0]     HEX0, HEX1, HEX2, HEX3;
logic [15:0]    PC_out, MAR_out, MDR_out, IR_out;

slc3_testtop test(.*);

always_comb begin : INTERNAL_MONITORING
    PC_out = test.slc.PC; // monitor gated signals, including IR
    IR_out = test.slc.IR;
    MAR_out = test.slc.MAR;
    MDR_out = test.slc.DataMDR;

end


initial begin: CLOCKINIT
   Clk 	= 0;
end 

always begin : CLOCKGEN
#1 Clk 	= ~ Clk;
end

initial begin: START

   SW 				= 16'h0003; // start all at 0
   Reset 			= 1; // At this level these three signals are active low
   Run 				= 1;
	Continue 		= 1;
	
   #2    Reset 	= 0; // Reset machine then start run
	#8 	Reset		= 1;
	
   #2 Run 			= 0;
	#4 Run			= 1; // t = 170
    
	 
	#66 SW 				= 16'h0000; // start all at 0   t = 830


   #4 Continue 	= 1; // Delay for continue signal pulses
   #20 Continue 	= 0;

   #4 Continue 	= 1;
   #20 Continue 	= 0;
	 
	#4 Continue 	= 1;
	#20 Continue 	= 0;

	#4 Continue 	= 1;
	#20 Continue 	= 0;
	 
	#4 Continue 	= 1;
	#20 Continue 	= 0;

	#4 Continue 	= 1;
	#20 Continue 	= 0;
	
	for (int t = 0; t < 11; t++)
	begin
		#4 Continue = 1;
		#20 Continue = 0;
	end
    
end

endmodule