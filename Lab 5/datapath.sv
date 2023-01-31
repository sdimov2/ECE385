

module datapath(
	input logic Clk,
	input logic [15:0] DataPC, DataMDR, DataALU, DataMARMUX, // Different data
	input logic SelPC, SelMDR, SelALU, SelMARMUX, // Data selected by DataBus one-hot signals
	output logic [15:0] DataBus
);

always_comb
begin
	if (SelPC) // One-hot selection of what is routed to DataBus based on select signals
		begin
			DataBus = DataPC;
		end
	else if (SelMDR)
		begin
			DataBus = DataMDR;
		end
	else if (SelALU)
		begin
			DataBus = DataALU;
		end
	else if (SelMARMUX)
		begin
			DataBus = DataMARMUX;
		end
	else
		begin
			DataBus = 16'bxxxxxxxxxxxxxxxx; // Edge case for all 0
		end
end


endmodule
