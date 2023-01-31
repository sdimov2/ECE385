
module strumWithinRange#(
	parameter int numBits = 10,
	parameter
	center = 10'h1F4,
	tolerance = 10'h018 
)
(
	input timerActive, frameClk, strum,
	input [numBits-1:0] Y,
	output [numBits-1:0] score,
	output addHit, addMiss
	);

logic [numBits-1:0] leftDiff, rightDiff, pointsDiff;
logic withinLeft, withinRight, withinBounds;
always_comb
begin
	leftDiff = center - Y; // Difference between center and current location
	rightDiff = Y - center; // Difference between current location and center
	
	withinLeft = (leftDiff > 10'h000 && leftDiff <= tolerance) ? 1'b1 : 1'b0;
	withinRight = (rightDiff >= 10'h000 && rightDiff <= tolerance) ? 1'b1 : 1'b0;	
	
	case ({withinLeft, withinRight})
	2'b00:
	begin
		withinBounds = 1'b0;
		score = 10'h000;
	end
	2'b01:
		begin
		withinBounds = timerActive; // If within bounds it should be 1
		score = tolerance - rightDiff;
		end
	2'b10:
		begin
		withinBounds = timerActive;
		score = tolerance - leftDiff;
		end
	2'b11:
	begin
		withinBounds = 1'b0;
		score = 10'h000;
	end
	endcase
end




logic hitPositive;
always_ff@(posedge frameClk)
begin
	hitPositive <= withinBounds & (strum | hitPositive); // Set high when strum within bounds, set low when leave bounds
end
assign addHit = ~hitPositive & strum & withinBounds; // Only pulse if within bounds and haven't already hit

logic missPositive; 
always_ff@(posedge frameClk) 
begin
	missPositive <= strum & (~withinBounds | hitPositive); // If out of bounds or already hit on a strum, is a miss. Resets when strum stops
end

logic phasedBounds;
logic withinBoundsEnd;
always_ff @ (posedge frameClk)
begin
	phasedBounds <= withinBounds;  // Make this the previous value of withinBounds
end
// withinBounds just ended and when ended hitpositive was low
assign withinBoundsEnd = (phasedBounds & ~withinBounds) & ~hitPositive;


assign addMiss = (strum & ~missPositive) | withinBoundsEnd; // Pulse at beginning of missing strum




logic strumReg, strumPulse; // Use of register makes pulse on rising edge of strum
always_ff@(posedge frameClk) 
begin
	strumReg <= strum;
end
assign strumPulse = ~strumReg & strum;


endmodule
