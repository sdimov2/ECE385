//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 5 Given Code - SLC-3 top-level (Physical RAM)
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//------------------------------------------------------------------------------


module slc3(
	input logic [9:0] SW,
	input logic	Clk, Reset, Run, Continue,
	output logic [9:0] LED,
	input logic [15:0] Data_from_SRAM,
	output logic OE, WE,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3,
	output logic [15:0] ADDR,
	output logic [15:0] Data_to_SRAM
);


// An array of 4-bit wires to connect the hex_drivers efficiently to wherever we want
// For Lab 1, they will direclty be connected to the IR register through an always_comb circuit
// For Lab 2, they will be patched into the MEM2IO module so that Memory-mapped IO can take place
logic [3:0] hex_4[3:0]; // Hex nibbles
// Output of Mem2IO
// Input of hex drivers
HexDriver hex_drivers[3:0] (hex_4, {HEX3, HEX2, HEX1, HEX0});
// Outputs 7-bit words to output of top-level module

// For week 1, put IR to hex drivers:
// This works thanks to http://stackoverflow.com/questions/1378159/verilog-can-we-have-an-array-of-custom-modules




// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;

// temp variables, keep or not, just for compilation
logic [15:0] DataALU, PC, DataMARMUX;

logic SR2MUX, ADDR1MUX;
logic BEN, MIO_EN, DRMUX, SR1MUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [15:0] MAR, IR;
logic [15:0] datapath;
logic [15:0] Data_to_CPU, Data_from_CPU, DataMDR;



// Connect MAR to ADDR, which is also connected as an input into MEM2IO
//	MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
//	input into MDR)
//assign ADDR = MAR; // this is already done in MEM.sv
assign MIO_EN = OE;
// Connect everything to the data path (you have to figure out this part)
datapath d0 (
	.Clk(Clk),
	.DataPC(PC), .DataMDR(DataMDR), .DataALU(DataALU), .DataMARMUX(DataMARMUX), // Different data
	.SelPC(GatePC), .SelMDR(GateMDR), .SelALU(GateALU), .SelMARMUX(GateMARMUX), // Data selected by DataBus one-hot signals
	.DataBus(datapath) // Output
);

// Our SRAM and I/O controller (note, this plugs into MDR/MAR)



Mem2IO memory_subsystem(
    .*, .Reset(Reset), .ADDR(ADDR), .Switches(SW),
	 .OE(MIO_EN), .WE(WE), // Just assign OE and WE to wires in slc3
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0])
	 //this line was commented out for week1, replaced by following line:
	 //.HEX0(IR[15:12]), .HEX1(IR[11:8]), .HEX2(IR[7:4]), .HEX3(IR[3:0]),
    // .* takes care of data to/from CPU and SRAM. This module routes the data
	 // going to either
);



// State machine, you need to fill in the code here as well
ISDU state_controller(
	.*, .Reset(Reset), .Run(Run), .Continue(Continue),
	.BEN(BEN), // Branch enable, make logic in slc3? Make module?
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]), // Takes in IR for instruction code and other parameters
	
	// The * takes care of all outputs that have same names as variables
	// so instantiation here should be good
	.Mem_OE(OE), .Mem_WE(WE)
);


// TEMP- DELETE
logic [15:0] SR1, SR2;
ALU Arithmetic(
    .SR2MUX(SR2MUX),
    .ALUK(ALUK),
    .SR1(SR1), .SR2(SR2), .IR(IR),
    .DataALU(DataALU)
);


/*
IR Instruction_Register(.*, .IR_in(datapath)); // Datapath in, load signal comes
// from ISDU, current IR value can be found in logic IR

ProgramCounter PCmodule(
	.*, // for Clk, Reset, LD_PC, PCMUX, and PC
	.MARMUX(DataMARMUX), .datapath(datapath)
);


This module is in MEM.sv
MDR_M MDRinstance (
	.*, .Data_to_CPU(Data_to_CPU),
	.BUS(datapath)
	);

//MAR I/O
should be taken care of by .*
LD_MAR;
ADDR;
Data_to_CPU,
GateMDR,
Data_from_CPU;
*/

				// IR
register_generic IR1(
	.Clk(Clk), .en(LD_IR), // Only loads from bus
	.data_in(datapath), .data_reg(IR)
);

				// MDR
logic [15:0] MDR_in;
always_comb 
begin
	if (MIO_EN) // MIO_EN = 1, MDR<-Read data
		MDR_in = Data_to_CPU;
	else 		// MIO_EN = 0, MDR<-bus
		MDR_in = datapath;
end
register_generic MDR1(
	.Clk(Clk), .en(LD_MDR),
	.data_in(MDR_in), .data_reg(DataMDR)
);
always_comb
begin
	Data_from_CPU = DataMDR; // Data_from_CPU is the same as MDR contents
end

				// MAR
register_generic MAR1( // MAR only gets loaded with bus
	.Clk(Clk), .en(LD_MAR),
	.data_in(datapath), .data_reg(MAR)
);
always_comb
begin
	ADDR = MAR; // ADDR output is the same as MAR contents
end


				// PC
logic [15:0] PC_in;
register_generic PC1(
	.Clk(Clk), .en(LD_PC),
	.data_in(PC_in), .data_reg(PC)
);
always_comb
begin
	unique case (PCMUX)
		2'b00		:	PC_in = PC + 16'h0001; // increment by 1
		2'b01		:	PC_in = DataMARMUX; // Put marmux sum in PC
		2'b10		:	PC_in = datapath; // Put contents of datapath in PC
		2'b11		:	PC_in = 16'h0000; // Third state (not in literature) jumps to start
		// for use on reset
		default	:	PC_in = 16'h0000; // Default is don't move
	endcase
end

				// BEN
logic [2:0] nzp;
always_ff @ (posedge Clk)
begin
	if (LD_CC)
		if (datapath[15])
			nzp <= 3'b100; // Most significant bit means negative
		else if (datapath[14:0])
			nzp <= 3'b001; // Not most significant bit but another bit means positive
		else
			nzp <= 3'b010; // No bits means zero
	if (LD_BEN)
		if (nzp & IR[11:9])
			BEN <= 1'b1;
		else
			BEN <= 1'b0; 
end

				// REG File
logic [15:0] file_reg[7:0]; // R7-R0
logic file_en[7:0];
register_generic regfile[7:0] (.Clk(Clk), .en(file_en[7:0]), .data_in(datapath), .data_reg(file_reg[7:0]));
logic [2:0] DR_choose, SR2_choose, SR1_choose;
always_comb 
begin
	case (DRMUX) // Choose destination register. Latter case only used for JSR
		1'b0 : 
			DR_choose = IR[11:9];
		1'b1 :
			DR_choose = 3'b111;
	endcase
	SR2_choose = IR[2:0];
	case (SR1MUX) // Choose SR1 from IR based on opcode (See ISDU)
		1'b0 :
			SR1_choose = IR[8:6];
		1'b1 :
			SR1_choose = IR[11:9];
	endcase

	case (SR1_choose)
		3'b000 :
			SR1 = file_reg[0];		
		3'b001 :
			SR1 = file_reg[1];
		3'b010 :
			SR1 = file_reg[2];
		3'b011 :
			SR1 = file_reg[3];
		3'b100 :
			SR1 = file_reg[4];
		3'b101 :
			SR1 = file_reg[5];
		3'b110 :
			SR1 = file_reg[6];
		3'b111 :
			SR1 = file_reg[7];
	endcase
	case (SR2_choose)
		3'b000 :
			SR2 = file_reg[0];		
		3'b001 :
			SR2 = file_reg[1];
		3'b010 :
			SR2 = file_reg[2];
		3'b011 :
			SR2 = file_reg[3];
		3'b100 :
			SR2 = file_reg[4];
		3'b101 :
			SR2 = file_reg[5];
		3'b110 :
			SR2 = file_reg[6];
		3'b111 :
			SR2 = file_reg[7];
	endcase
end
always_comb // Not synchronized, the registers do the synchronizing
begin
	file_en[0] = 1'b0;		// Have write bits low by default
	file_en[1] = 1'b0;		
	file_en[2] = 1'b0;		
	file_en[3] = 1'b0;		
	file_en[4] = 1'b0;		
	file_en[5] = 1'b0;		
	file_en[6] = 1'b0;		
	file_en[7] = 1'b0;		

	if (Reset)
	begin
		file_en[0] = 1'b1; // Load all registers with datapath, which should be null
		file_en[1] = 1'b1;
		file_en[2] = 1'b1;
		file_en[3] = 1'b1;
		file_en[4] = 1'b1;
		file_en[5] = 1'b1;
		file_en[6] = 1'b1;
		file_en[7] = 1'b1;
	end
	case (DR_choose) // If (LD_REG && DR_choose=X) then load X
		3'b000 :
			file_en[0] = LD_REG;		
		3'b001 :
			file_en[1] = LD_REG;		
		3'b010 :
			file_en[2] = LD_REG;		
		3'b011 :
			file_en[3] = LD_REG;		
		3'b100 :
			file_en[4] = LD_REG;		
		3'b101 :
			file_en[5] = LD_REG;	
		3'b110 :
			file_en[6] = LD_REG;	
		3'b111 :
			file_en[7] = LD_REG;	
	endcase
end

			// MARMUX
logic [15:0] offsetMARMUX, address1;
always_comb
begin
	case (ADDR2MUX)
		2'b00 :
			offsetMARMUX = 16'h0000;
		2'b01 :
			offsetMARMUX = {{10{IR[5]}}, IR[5:0]};
		2'b10 :
			offsetMARMUX = {{7{IR[8]}}, IR[8:0]};
		2'b11 :
			offsetMARMUX = {{5{IR[10]}}, IR[10:0]};
	endcase
	case(ADDR1MUX)
		1'b0 :
			address1 = PC;
		1'b1 : 
			address1 = SR1;
	endcase
	DataMARMUX = offsetMARMUX + address1;
end


// SRAM WE register
//logic SRAM_WE_In, SRAM_WE;
//// SRAM WE synchronizer
//always_ff @(posedge Clk or posedge Reset_ah)
//begin
//	if (Reset_ah) SRAM_WE <= 1'b1; //resets to 1
//	else 
//		SRAM_WE <= SRAM_WE_In;
//end

	
endmodule
