/*

Module for a single N-bit timer
Counts up to T' = 2^N - 1

*/

/*
Behavior:
Counts up to T' and then stops at T'
Starts counting again (if T == T', it overflows to 0) upon "start" signal
Outputs [N-1:0] T and countEnd (T == T') signal
*/

module singleTimer1#(
		parameter N = 5, // How many registers
		parameter Z = 5'b11110 // The value to stop the timer on minus one
)
(
	input start, Clk, 		// Start signal to change to counting state, clock signal
	input [N-1:0] M, // How much to increment by- change to an input
	output countActive, 		// Is equal to the state for whether it's counting
	output countEnd, 			// Goes high when T == T'
	output [N-1:0] countT 		// Values in counter
);

logic timerActive; // The state for whether it's counting
logic timerEnd; // Indicates end of counting
logic [N-1:0] timerCount; // Counting registers

always_comb
begin : link_inouts_to_logics
	countActive = timerActive;
	countEnd = timerEnd;
	countT = timerCount;
end



always_ff@(posedge Clk)
begin : set_timerEnd // Set timerEnd signal based on whether the timer has reached its end
	// When setting timerEnd high, you need to do it one clock early or it'll go high after T = T'
	// This works so don't mess with it- one clock cycle after timerEnd goes high, the next timer will start
	// And this one has stopped, making it a full cycle from T' to T'
	if (timerCount >= Z) // USING  N  DIRECTLY HERE DID NOT WORK, NEED TO EDIT MANUALLY IF  N  IS CHANGED
		timerEnd <= 1'b1;
	else
		timerEnd <= 1'b0;
end

always_ff@(posedge Clk)
begin : set_timerActive
	if (start == 1'b1)
		timerActive <= 1'b1;
	else if (timerEnd == 1'b1)
		timerActive <= 1'b0;
end

always_ff@(posedge Clk) // Works on conditional clock
begin : counting
	unique case (timerActive)
	1'b0:
	begin
	end
	1'b1:
	begin
		unique case (timerEnd)
		1'b0:
		timerCount <= timerCount + M; // Normally increment timer
		1'b1:
		timerCount <= Z ^ Z; // If timer was halted at end, reset to 0. This should consequently reset timerEnd
		endcase
	end
	endcase
end

endmodule
