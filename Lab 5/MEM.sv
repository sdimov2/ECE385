module MDR_M (

input logic Clk, LD_MDR, MIO_EN,
input logic [15:0] BUS, Data_to_CPU,
output logic [15:0] DataMDR, Data_from_CPU,

//MAR I/O
input logic LD_MAR,
output logic [15:0] ADDR, MAR

);

logic [15:0] MDR;

//MDR component
always_ff @(posedge Clk & LD_MDR)
begin
	if (MIO_EN)
		MDR <= Data_to_CPU;
	else
		MDR <= BUS;
end

always_comb
begin
	Data_from_CPU = MDR;
	DataMDR = MDR;
end

//MAR component
always_ff @(posedge Clk & LD_MAR)
begin
	MAR <= BUS;
end

always_comb
begin
	ADDR = MAR;
	//ADDR = {4'b0,MAR} //zero extend
end

endmodule

