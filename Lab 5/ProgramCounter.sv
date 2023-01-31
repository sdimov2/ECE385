module ProgramCounter(
	input logic Clk, Reset, LD_PC,
	input logic [15:0] MARMUX, datapath, // Selectable options are marmux, datapath, and increment
	input logic [1:0] PCMUX, // PC mux select signal
	output logic [15:0] PC
);

logic [15:0] PC_next;


always_ff @ (posedge Clk) // Change to posedge LD_PC & Clk if necessary
// or if necessary a synchronous load as an if statement
begin
	if (Reset)
		PC <= 16'h0000; // On reset go to 0
	else if (LD_PC)
		PC <= PC_next; // Load on load signal
end

always_comb
begin
	unique case (PCMUX)
		2'b00		:	PC_next = PC + 16'h0001; // increment by 1
		2'b01		:	PC_next = MARMUX; // Put marmux sum in PC
		2'b10		:	PC_next = datapath; // Put contents of datapath in PC
		default	:	PC_next = 16'h0000; // Default is don't move
	endcase

end


endmodule 