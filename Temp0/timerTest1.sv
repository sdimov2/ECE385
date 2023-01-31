/*
Testing the basic counter-- count up
N registers per counter, counts for 2^N - 1 cycles


This module houses multiple single-timer units. Use it as a top-level.


*/

module timerTest1#
(
		parameter int
		N = 5
)
(
	input button, Clk, 		// Start signal to change to counting state, clock signal
	output countActive, 		// Is equal to the state for whether it's counting
	output countEnd, 			// Goes high when T == T'
	output [N-1:0] countT, 		// Values in counter
	
	output start0 // it won't show up in signaltap and I need to see it
);

logic start, input0;
logic [2:0] startCount;

assign input0 = ~button;

assign start0 = start; // please

initial
begin
	startCount <= 2'b00;
end

always_comb
begin
	unique case (startCount)
	2'b00:
		start = 1'b0;
	2'b01:
		start = 1'b1;
	2'b10:
		start = 1'b1;
	2'b11:
		start = 1'b0;
	endcase
end


always_ff@(posedge (Clk & input0))
begin
	unique case (startCount)
	2'b00 :
		startCount <= 2'b01;
	2'b01 :
		startCount <= 2'b10;
	2'b10 : 
		startCount <= 2'b11;
	2'b11 : 
	begin
	end
	endcase
end

logic start1;
assign start1 = start || countT; // Let's see if this can loop infinitely after one start signal.

singleTimer0 myTimer0
(
	.start(start1), .Clk(Clk), 		// Start signal to change to counting state, clock signal
	.countActive(countActive), 		// Is equal to the state for whether it's counting
	.countEnd(countEnd), 			// Goes high when T == T'
	.countT(countT) 		// Values in counter
);

endmodule
