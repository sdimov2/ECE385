module IR (
input logic Clk, LD_IR, // Clock and load signal
input logic [15:0] IR_in, // Datapath
output logic [15:0] IR // Current value
);

logic IR_Current; // Register here

always_ff @ (posedge Clk)
begin
	if (LD_IR)
		IR_Current <= IR_in; // Load from datapath if load signal
end

assign IR = IR_Current; // Assign to output

endmodule 