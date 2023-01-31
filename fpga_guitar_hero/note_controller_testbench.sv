module note_controller_testbench();

timeunit 10ns;
timeprecision 1ns;

logic Reset;
logic clk;
logic [9:0] screenX, screenY;
logic [1:0] addr;
logic write;
logic read;
logic [3:0] be;
logic [31:0] data_in;
logic [31:0] data_out;
	
logic active;
logic [3:0] red, green, blue;

vga_controller m_controller(
		.Clk(clk),
		.Reset(Reset),
		.DrawX(screenX),
		.DrawY(screenY)
	);

note_controller m(.*);

always begin : CLOCK_GENERATION
#1 clk = ~clk;
end

initial begin: CLOCK_INITIALIZATION
    clk = 0;
end 


initial begin : test_vectors
	Reset = 1;
	addr = 0;
	be = 4'b1111;
	write = 0;
	#2 Reset = 0;
	
	data_in = 32'h0000321f;
	#2 write = 1;
	#2 write = 0;
	
	addr = 1;
	data_in = 32'h0000641f;
	#2 write = 1;
	#2 write = 0;
	
	addr = 2;
	data_in = 32'h0000961f;
	#2 write = 1;
	#2 write = 0;
	
	addr = 3;
	data_in = 32'h0000c81f;
	#2 write = 1;
	#2 write = 0;
end

endmodule
