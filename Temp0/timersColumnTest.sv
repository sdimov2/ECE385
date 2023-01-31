


module timersColumnTest(
input Clk,
input button0,
input button1,
output LED[9:0]
);

logic divClk;
logic [9:0] divNum;

logic reset;
assign reset = ~button0; // Press button0 for reset


always_ff@(posedge Clk)
begin
	divNum <= divNum + 10'b0000000001;
	if (divNum == 10'b0000010000)
		divClk <= ~divClk;
end

logic [9:0] M;
assign M = 10'b0000000001;

logic gameTimerLoop;
singleTimer1 
#(.N(7), .Z(7'h5E)) // 7 bits, stop at x5E + x03 = 97
gameTimer (
	.Clk(divClk), .start(gameTimerLoop),
	.M(7'b0000001),
	.countActive(),
	.countEnd(gameTimerLoop),
	.countT()
);

timersColumn #
(
		.X_LEFT(10'h0F3) // left bound of the note, inclusive
)
myTimersCol
(
	.reset(reset), .frameClk(divClk), .gameClk(gameTimerLoop), 		// Start signal to change to counting state, clock signal
	.drawY(10'h100), .drawX(10'h0F3),
	.noteStart(1'b1), .strum(1'b0),
	.M(M),
	.xAddrROM(), .yAddrROM(), .drawNote()
	);

endmodule
