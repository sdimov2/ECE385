module timerTest2#
(
		parameter int
		N = 5
)
(
	input button, Clk, 		// Start signal to change to counting state, clock signal
	output [N:0] countActive, 		// Is equal to the state for whether it's counting
	output [N:0] countEnd, 			// Goes high when T == T'
	output [N:0] [N-1:0] countT, 		// Values in counter
	
	output start0 // it won't show up in signaltap and I need to see it
);

logic start, startIn, input0;
logic [2:0] startCount;

assign input0 = ~button;

assign start = ~startIn & input0;


always_ff@(posedge Clk)
begin
	startIn <= input0;
end

logic [N:0] timerStarts, timerEnds;

assign timerStarts [N] = start;
assign timerStarts [N-1:0] = timerEnds [N:1];


singleTimer1 myTimers0 [N:0]
(
	.start(timerStarts), .Clk(Clk), 		// Start signal to change to counting state, clock signal
	.countActive(countActive), 		// Is equal to the state for whether it's counting
	.countEnd(timerEnds), 			// Goes high when T == T'
	.countT(countT) 		// Values in counter
);

endmodule
