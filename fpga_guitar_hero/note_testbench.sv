module note_testbench();

timeunit 10ns;
timeprecision 1ns;

logic Reset;
logic clk;
logic [9:0] screenX, screenY;
logic write;
logic [31:0] data_in;
	
logic active;
logic [3:0] red, green, blue;

vga_controller m_controller(
		.Clk(clk),
		.Reset(Reset),
		.DrawX(screenX),
		.DrawY(screenY)
	);

//This testbench is broken as a result of the changes.
//You need a note controller with a rom now.
//note m(.*);

always begin : CLOCK_GENERATION
#1 clk = ~clk;
end

initial begin: CLOCK_INITIALIZATION
    clk = 0;
end 


initial begin : test_vectors
	Reset = 1;
	write = 0;
	#2 Reset = 0;
	
	data_in = 32'h0000323f;
	#2 write = 1;
	#2 write = 0;
end


endmodule
