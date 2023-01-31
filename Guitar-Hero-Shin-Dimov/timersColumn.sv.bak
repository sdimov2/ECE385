
/*
Code for a single column of guitar hero notes

Contains 6 note timers in a column, tracks whether the pixel drawn is should draw a note

*/

module timersColumn#
(
		parameter int
		NUM_TIMERS = 6,
		TIMER_BITS = 10,
		parameter [9:0]
		X_LEFT = 10'h0F3, // left bound of the note, inclusive
		HIT_CENTER = 10'h1F4; // Place for timer at ideal hit
		HIT_TOL = 10'h018 // tolerance for a hit to be counted
)
(
	input reset, frameClk, gameClk, 		// Start signal to change to counting state, clock signal
	input noteStart, strum,
	input [TIMER_BITS-1:0] M,
	input [9:0] drawY, drawX,
	//output [NUM_TIMERS-1:0] countActive, 		// Is equal to the state for whether it's counting
	output [NUM_TIMERS-1:0] countEnd, 			// Goes high when T == T'
	//output [NUM_TIMERS-1:0] [9:0] countT, 		// Values in counter
	output [9:0] yAddrROM, xAddrROM,
	output drawNote
	);


assign countEnd = timerEnds;


logic [2:0] timerSelect;
always_ff@(posedge gameClk)
begin 
if (timerSelect == 3'b101)
	timerSelect <= 3'b000;
else
	timerSelect <= timerSelect + 3'b001;
end


logic anyNoteStart;
assign anyNoteStart = noteStart & gameClk;
always_comb
begin
	timerStarts[NUM_TIMERS-1:0] = 6'b0; // By default all timerStart signals are low
	case (timerSelect) // Make a timerStarts signal equal to the noteStart signal from game ROM AND the gameClk if selected
	3'b000:
		timerStarts[5] = anyNoteStart;
	3'b001:
		timerStarts[0] = anyNoteStart;
	3'b010:
		timerStarts[1] = anyNoteStart;
	3'b011:
		timerStarts[2] = anyNoteStart;
	3'b100:
		timerStarts[3] = anyNoteStart;
	3'b101:
		timerStarts[4] = anyNoteStart;
	endcase
end


logic [NUM_TIMERS-1:0] timerStarts, timerEnds, countActive;
logic [NUM_TIMERS-1:0] [TIMER_BITS-1:0] countT;


singleTimer1 #(
.N(TIMER_BITS), .Z(10'h243) // 579 + 3 = 582
)
myTimers0 [NUM_TIMERS-1:0]
(
	.start(timerStarts), .Clk(frameClk), 		// Start signal to change to counting state, clock signal
	.M(M),
	.countActive(countActive), 		// Is equal to the state for whether it's counting
	.countEnd(timerEnds), 			// Goes high when T == T'
	.countT(countT) 		// Values in counter
);

logic [NUM_TIMERS-1:0] inNote;
logic [NUM_TIMERS-1:0] [9:0] yAddr; // Used 9:0 instead of timer bits since VGA uses 10-bit coordinates

assign yAddr[0] = drawY + HIT_TOL + 10'h001 - countT[0]; // pixel location (from perspective of timer) - uppermost edge of note
assign yAddr[1] = drawY + HIT_TOL + 10'h001 - countT[1]; 
assign yAddr[2] = drawY + HIT_TOL + 10'h001 - countT[2]; 
assign yAddr[3] = drawY + HIT_TOL + 10'h001 - countT[3]; 
assign yAddr[4] = drawY + HIT_TOL + 10'h001 - countT[4]; 
assign yAddr[5] = drawY + HIT_TOL + 10'h001 - countT[5]; 

assign inNote[0] = (yAddr[0] >= 10'h000 && yAddr[0] <= 10'h030 && countActive[0]) ? 1'b1 : 1'b0; // Checking for whether in bounds
assign inNote[1] = (yAddr[1] >= 10'h000 && yAddr[1] <= 10'h030 && countActive[1]) ? 1'b1 : 1'b0; 
assign inNote[2] = (yAddr[2] >= 10'h000 && yAddr[2] <= 10'h030 && countActive[2]) ? 1'b1 : 1'b0; 
assign inNote[3] = (yAddr[3] >= 10'h000 && yAddr[3] <= 10'h030 && countActive[3]) ? 1'b1 : 1'b0; 
assign inNote[4] = (yAddr[4] >= 10'h000 && yAddr[4] <= 10'h030 && countActive[4]) ? 1'b1 : 1'b0; 
assign inNote[5] = (yAddr[5] >= 10'h000 && yAddr[5] <= 10'h030 && countActive[5]) ? 1'b1 : 1'b0; 
// greater than or equal to 0, or less than or equal to 48 (range of ROM)
// and the timer in question is active

always_comb 
begin
	case (inNote) // one-hot selection of which address to output
	6'b000001:
	yAddrROM = yAddr[0];
	6'b000010:
	yAddrROM = yAddr[1];
	6'b000100:
	yAddrROM = yAddr[2];
	6'b001000:
	yAddrROM = yAddr[3];
	6'b010000:
	yAddrROM = yAddr[4];
	6'b100000:
	yAddrROM = yAddr[5];
	default:
	yAddrROM = 10'h000;
	endcase
end



assign xAddrROM = drawX - X_LEFT;
logic inNoteX;
assign inNoteX = (xAddrROM >= 10'h000 && xAddrROM <= 10'h030) ? 1'b1 : 1'b0;

assign drawNote = ((inNote != 6'b000000) && inNoteX == 1'b1) ? 1'b1 : 1'b0;


logic [NUM_TIMERS-1:0] detectedHit, detectedMiss;
strumWithinRange strumDetection [NUM_TIMERS-1:0]
(
	.timerActive(countActive), .frameClk(frameClk), .strum(strum),
	.Y(countT),
	.score(timerScore),
	.addHit(detectedHit), .addMiss(detectedMiss)
	);

logic [9:0] columnScore;	
logic [9:0] [NUM_TIMERS-1:0] timerScore;
logic [3:0] hitCount, missCount;

logic [9:0] netTimerScore;
assign netTimerScore = timerScore [0] + timerScore [1] + timerScore [2] + timerScore [3] + timerScore [4] + timerScore [5];

logic anyHit;
assign anyHit = (detectedHit != 6'h00) ? 1'b1 : 1'b0; // all detected hits OR together
always_ff @ (posedge frameClk)
begin
	if (reset == 1'b1)
	begin
		columnScore <= 10'h000;
		hitCount <= 4'b0000;
	end
	else if (anyHit == 1'b1)
	begin
		columnScore <= columnScore + timerScore;
		hitCount <= hitCount + 4'b0001;
	end
end


logic allMiss;
assign allMiss = (detectedMiss == 6'hFF) ? 1'b1 : 1'b0; // all detected misses AND together
always_ff @ (posedge frameClk)
begin
	if (reset == 1'b1)
		missCount <= 4'b0000;
	else if (allMiss)
		missCount <= missCount + 4'b0001;
end
	
	
endmodule
