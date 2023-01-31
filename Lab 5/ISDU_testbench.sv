module testbench_ISDU();

ISDU myISDU(.*);

timeunit 10ns;

timeprecision 1ns;


logic Clk, Reset, Run, Continue;
logic[3:0]    Opcode;
logic         IR_5;
logic         IR_11; // Up to here was set up for us
logic         BEN;
logic        LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;			
logic        GatePC, GateMDR, GateALU, GateMARMUX;			
logic [1:0]  PCMUX;
logic        DRMUX, SR1MUX, SR2MUX, ADDR1MUX;
logic [1:0]  ADDR2MUX, ALUK;
logic        Mem_OE, Mem_WE;


initial begin: INIT
   Clk 	= 0;
   Opcode = 4'b1001; // First opcode
   IR_5 = 1'b0;
   IR_11 = 1'b0;
   BEN = 1'b0;
end 

always begin : CLOCKGEN
#1 Clk 	= ~ Clk;
end

initial begin: START

   Reset 			= 1; // At this level these three signals are active low
   Run 				= 1;
	Continue 		= 1;
	
   	#2    Reset 	= 0; // Reset machine then start run
	#4 	Reset		= 1;
   	#2 Run 			= 0;
	#4 Run			= 1;

    	// Run previous instruction
	#10 Opcode = 4'b1101; // Set next to pause
	#60 Opcode = 4'b1111; // When it's probably paused, set next opcode
   	#4 Continue 	= 0; // Delay for continue signal pulses
   	#20 Continue 	= 1;
    
end

endmodule