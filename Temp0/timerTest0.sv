/*
Testing the basic counter-- count up
N registers per counter, counts for 2^N - 1 cycles


This module houses multiple single-timer units. Use it as a top-level.


*/

module timerTest0#
(
		parameter int
		N = 5
)
(
	input start, Clk, 		// Start signal to change to counting state, clock signal
	output countActive, 		// Is equal to the state for whether it's counting
	output countEnd, 			// Goes high when T == T'
	output [N-1:0] countT, 		// Values in counter
	output [9:0] LEDs
	/*
	//some stuff we'll need later
   ///////// LEDR /////////
   output   [ 9: 0]   LEDR,
	
   ///////// VGA /////////
   output             VGA_HS,
	output             VGA_VS,
   output   [ 3: 0]   VGA_R,
   output   [ 3: 0]   VGA_G,
   output   [ 3: 0]   VGA_B,


	///////// ARDUINO /////////
	inout    [15: 0]   ARDUINO_IO,
	inout              ARDUINO_RESET_N
	*/	
);

sequence_rom myRom(
	.addr(addr_idx), .data(ROMline)
);


logic myStart0;
assign myStart0 = start | countEnd;
// we can use this timer below as the clock signal for the ROM reading below
singleTimer0 myTimer0
(
	.start(myStart0), .Clk(Clk), 		// Start signal to change to counting state, clock signal
	.countActive(countActive), 		// Is equal to the state for whether it's counting
	.countEnd(countEnd), 			// Goes high when T == T'
	.countT(countT) 		// Values in counter
);
/*
singleTimer0 Timergrid [4:0][6:0]						// check if this is the correct syntax for a 2d array
(
	.start(start), .Clk(Clk), 		// Start signal to change to counting state, clock signal
	.countActive(countActive), 		// Is equal to the state for whether it's counting
	.countEnd(countEnd), 			// Goes high when T == T'
	.countT(countT) 		// Values in counter
);
*/

/*
parameter Col = 5;
parameter Row = 7;
logic [Col-1:0][Row-1:0] startgrid, countActive0;
logic [4:0][Col-1:0][Row-1:0] countT0;


generate
genvar i,j;
	for (i=0; i<Col; i=i+1) begin: gen1
		for (j=0; j<Row; j=j+1) begin: gen2
			singleTimer0 grid( 
				.start(start[i][j]), 
				.Clk(Clk), 		// Start signal to change to counting state, clock signal
				.countActive(countActive0[i][j]), 		// Is equal to the state for whether it's counting
				.countEnd(countEnd[i][j]), 			// Goes high when T == T'
				.countT(countT0[i][j]) 
			);
		end
end
endgenerate
*/
/*
always_comb begin										// this is where the columns of timers need to be hooked up to their topside neighbors in series
	Timergrid [0][1] .start = Timergrid[0][0].countEnd;	// example pseudocode below for one column
	Timergrid [0][2] .start = Timergrid[0][1].countEnd;
	Timergrid [0][3] .start = Timergrid[0][2].countEnd;
	Timergrid [0][4] .start = Timergrid[0][3].countEnd;
	Timergrid [0][5] .start = Timergrid[0][4].countEnd;
	Timergrid [0][6] .start = Timergrid[0][5].countEnd;
	
	Timergrid [1][1] .start = Timergrid[1][0].countEnd;	
	Timergrid [1][2] .start = Timergrid[1][1].countEnd;
	Timergrid [1][3] .start = Timergrid[1][2].countEnd;
	Timergrid [1][4] .start = Timergrid[1][3].countEnd;
	Timergrid [1][5] .start = Timergrid[1][4].countEnd;
	Timergrid [1][6] .start = Timergrid[1][5].countEnd;
	
	Timergrid [2][1] .start = Timergrid[2][0].countEnd;	
	Timergrid [2][2] .start = Timergrid[2][1].countEnd;
	Timergrid [2][3] .start = Timergrid[2][2].countEnd;
	Timergrid [2][4] .start = Timergrid[2][3].countEnd;
	Timergrid [2][5] .start = Timergrid[2][4].countEnd;
	Timergrid [2][6] .start = Timergrid[2][5].countEnd;
	
	Timergrid [3][1] .start = Timergrid[3][0].countEnd;	
	Timergrid [3][2] .start = Timergrid[3][1].countEnd;
	Timergrid [3][3] .start = Timergrid[3][2].countEnd;
	Timergrid [3][4] .start = Timergrid[3][3].countEnd;
	Timergrid [3][5] .start = Timergrid[3][4].countEnd;
	Timergrid [3][6] .start = Timergrid[3][5].countEnd;
	
	Timergrid [4][1] .start = Timergrid[4][0].countEnd;	
	Timergrid [4][2] .start = Timergrid[4][1].countEnd;
	Timergrid [4][3] .start = Timergrid[4][2].countEnd;
	Timergrid [4][4] .start = Timergrid[4][3].countEnd;
	Timergrid [4][5] .start = Timergrid[4][4].countEnd;
	Timergrid [4][6] .start = Timergrid[4][5].countEnd;
end
*/


logic [4:0] countT0 [9:0];
logic [9:0] timerOut, timerIn, countActive0;
assign timerIn[9:1] = timerOut[8:0];

assign LEDs = timerOut[9:0];

assign timerIn[0] = startrowzero[0];

logic [20:0] bigNumber;
always_ff@(posedge Clk)
begin
	bigNumber <= bigNumber + 21'b000000000000000000001;
end



singleTimer0 alphaTimer[9:0] (
	.start(timerIn), .Clk(bigNumber[20]), 		// Start signal to change to counting state, clock signal
	.countActive(countActive0), 		// Is equal to the state for whether it's counting
	.countEnd(timerOut), 			// Goes high when T == T'
	.countT(countT0) 		// Values in counter
);


logic [4:0] startrowzero;
logic [3:0] addr_idx; 	
logic [14:0] ROMline;
logic endreached;
							// address index is basically the row #
initial begin 
addr_idx = 4'b0;
endreached = 0;
end

always_ff @(posedge countEnd) begin						// countEnd of mytimer0 is being used as the clock for the rest of the timer grid
	if (start && endreached == 0) 
	begin				// start of the mytimer0 is being used as the thing that begins the game
		if (ROMline[14:12] == 3'b001) 			// if column x on row addr_idx contains a basic note 001, then that column's first (top most) timer is started
			startrowzero[0] <= 1'b1;
		else
			startrowzero[0] <= 1'b0;
		
		if (ROMline[11:9] == 3'b001)  					// 
			startrowzero[1] <= 1'b1;
		else
			startrowzero[1] <= 1'b0;
		
		if (ROMline[8:6] == 3'b001) 						// 
			startrowzero[2] <= 1'b1;
		else
			startrowzero[2] <= 1'b0;
		
		if (ROMline[5:3] == 3'b001) 					// 
			startrowzero[3] <= 1'b1;
		else
			startrowzero[3] <= 1'b0;
		
		if (ROMline[2:0] == 3'b001) 				// 
			startrowzero[4] <= 1'b1;
		else
			startrowzero[4] <= 1'b0;
		// primary timers have been updated
		addr_idx <= addr_idx + 1;						// address row needs to be incremented here
	end
end


// let's try to get some keystrokes working
















endmodule
