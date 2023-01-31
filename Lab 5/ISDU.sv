//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------


module ISDU (   input logic         Clk, 
									Reset,
									Run,
									Continue,
									
				input logic[3:0]    Opcode, 
				input logic         IR_5, // Do we need IR5 and IR11?
			//	Doesn't sign extension take place elsewhere?
				input logic         IR_11, // Up to here was set up for us
				input logic         BEN,
				  
				output logic        LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction
									
				output logic        GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									
				output logic [1:0]  PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									ALUK,
				  
				output logic        Mem_OE,
									Mem_WE
				);
// All states need to be written here and in both case statements.

// >16 states so we'll need this to be [4:0], might even need [5:0]
	enum logic [4:0] {  Halted, 
						PauseIR1, 
						PauseIR2, 
						S_18, S_33_1, S_33_2, S_33_3, S_33_4, S_35, // Fetch
						S_32, // Set BEN, decode
						S_1, // ADD
						S_5, // AND
						S_9, // NOT
						S_6, S_25_1, S_25_2, S_25_3, S_25_4, S_27, // LDR
						S_7, S_23, S_16_1, S_16_2, S_16_3, S_16_4, // STR
						S_4, S_21, // JSR
						S_12, // JMP
						S_22_1, S_22_2 // BR at S_22_2 if BEN = 1 at S_22_1
						}   State, Next_state;   // Internal state logic
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0; // Put load signals at 0 by default
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0; // Put gate signals at 0 by default
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00; // Put mux select signals at 0 by default
		 
		Mem_OE = 1'b0;
		Mem_WE = 1'b0;
	
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = S_18;                      
			S_18 : 
				Next_state = S_33_1;
			// Any states involving SRAM require more than one clock cycles.
			// The exact number will be discussed in lecture.
			S_33_1 : 
				Next_state = S_33_2; // 4 Sub-states in 33 for adequate time to access memory
			S_33_2 :
				Next_state = S_33_3; 
			S_33_3 : 
				Next_state = S_33_4;
			S_33_4 :
				Next_state = S_35;
			S_35 : 
				Next_state = S_32; 
			PauseIR1 : 
				if (~Continue) 
					Next_state = PauseIR1;
				else 
					Next_state = PauseIR2;
			PauseIR2 : 
				if (Continue) 
					Next_state = PauseIR2;
				else 
					Next_state = S_18;
			S_32 : 
				case (Opcode)
					4'b0000 : 
						Next_state = S_22_1;
					4'b0001 : 
						Next_state = S_1;
					4'b0100 : 
						Next_state = S_4;
					4'b0101 : 
						Next_state = S_5;
					4'b0110 : 
						Next_state = S_6;
					4'b0111 : 
						Next_state = S_7;
					4'b1001 : 
						Next_state = S_9;
					4'b1100 : 
						Next_state = S_12;
					4'b1101 : 
						Next_state = PauseIR1;
					default : // Invalid opcode restarts fetch
						Next_state = S_18;
				endcase
			S_1 : 
				Next_state = S_18; // ADD
			S_5 : 
				Next_state = S_18; // AND
			S_9 : 
				Next_state = S_18; // NOT
			S_6 : 
				Next_state = S_25_1; // LDR
			S_25_1 : 
				Next_state =  S_25_2;
			S_25_2 : 
				Next_state = S_25_3; 
			S_25_3 : 
				Next_state = S_25_4; 
			S_25_4 : 
				Next_state = S_27; 
			S_27 : 
				Next_state = S_18; // LDR
			S_7 : 
				Next_state = S_23; // STR
			S_23 : 
				Next_state = S_16_1; 
			S_16_1 : 
				Next_state = S_16_2; 
			S_16_2 : 
				Next_state = S_16_3; 
			S_16_3 : 
				Next_state = S_16_4; 
			S_16_4 : 
				Next_state = S_18; // STR
			S_4 : 
				Next_state = S_21; // JSR 
			S_21 : 
				Next_state = S_18; // JSR
			S_12 : 
				Next_state = S_18; // JMP
			S_22_1 : 
				begin
					case (BEN) 
						1'b0 : // Check BEN after it's been loaded during decode
							Next_state = S_18;
						1'b1 : 
							Next_state = S_22_2;
					endcase
				end
			S_22_2:
				Next_state = S_18;

			default : Next_state = State; // By default stay, this will help with pauses
			// and waiting for ready signals

		endcase
		
		// Assign control signals based on current state
		// All relevant loads happen when the machine transitions into the next state
		case (State)
			Halted:
			begin
 				PCMUX = 2'b11; 	// Set the mux to set PC to null
				LD_PC = 1'b1; 	// Load PC with null
				GatePC = 1'b1; // Set bus to PC, reg module will load all registers with null
			end
			S_18 : 
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
				end
			S_33_1 : 
					Mem_OE = 1'b1; // 4 states in 33 to ensure proper load from memory
			S_33_2 : 
					Mem_OE = 1'b1;
			S_33_3 :
					Mem_OE = 1'b1;
			S_33_4 :
				begin 
					Mem_OE = 1'b1;
					LD_MDR = 1'b1; // 3 full cycles with OE, only pulse LD_MDR at the end once
				end
			S_35 : 
				begin 
					GateMDR = 1'b1; // IR <- MDR
					LD_IR = 1'b1;
					
					PCMUX = 2'b00; // Increment PC
					LD_PC = 1'b1;
				end
			PauseIR1: ;
			PauseIR2: ;
			S_32 : 
				LD_BEN = 1'b1;
			S_1 : 
				begin // ADD
					SR2MUX = IR_5; 
					SR1MUX = 1'b0;
					DRMUX = 1'b0;
					ALUK = 2'b00; // ADD code
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1; // Load cc
				end
			S_5 : 
				begin // AND
					SR2MUX = IR_5; 
					SR1MUX = 1'b0;
					DRMUX = 1'b0;
					ALUK = 2'b01; // AND code
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1; // Load cc
				end
			S_9 : 
				begin // NOT
					SR1MUX = 1'b0;
					DRMUX = 1'b0;
					ALUK = 2'b10; // NOT A code
					GateALU = 1'b1; // ALU to DR
					LD_REG = 1'b1;
					LD_CC = 1'b1; // Load cc
				end
			S_6 : 
				begin // LDR
					SR1MUX = 1'b0; // BaseR [8:6]
					ADDR1MUX = 1'b1; // SR1
					ADDR2MUX = 2'b01; // sext(offset6)
					GateMARMUX = 1'b1; // MARMUX to MAR
					LD_MAR = 1'b1;
				end
			S_25_1 : 
				Mem_OE = 1'b1; // 4 states in 25 to ensure proper load from memory
			S_25_2 : 
				Mem_OE = 1'b1;
			S_25_3 : 
				Mem_OE = 1'b1;
			S_25_4 : 
				begin
					Mem_OE = 1'b1;
					LD_MDR = 1'b1; // 3 full cycles with OE, only pulse LD_MDR at the end once
				end
			S_27 : 
				begin // LDR
					GateMDR = 1'b1; // MDR to DR
					DRMUX = 1'b0; // IR [11:9]
					LD_REG = 1'b1;
					LD_CC = 1'b1; // Load cc
				end
			S_7 : 
				begin // STR
					SR1MUX = 1'b0; // BaseR [8:6]
					ADDR1MUX = 1'b1; // SR1
					ADDR2MUX = 2'b01; // sext(offset6)
					GateMARMUX = 1'b1; // MARMUX to MAR
					LD_MAR = 1'b1;
				end
			S_23 : 
				begin 
					SR1MUX = 1'b1; // SR [11:9]
					ADDR1MUX = 1'b1; // SR1
					ADDR2MUX = 2'b00; // 0
					GateMARMUX = 1'b1; // MARMUX to MDR
					LD_MDR = 1'b1;
				end
			S_16_1 : 
				begin // Hold write signal for four clocks to make sure it goes through
					Mem_OE = 1'b1; // Enable memory and memory write
					Mem_WE = 1'b1;
				end
			S_16_2 : 
				begin
					Mem_OE = 1'b1; 
					Mem_WE = 1'b1;
				end
			S_16_3 : 
				begin
					Mem_OE = 1'b1; 
					Mem_WE = 1'b1;
				end
			S_16_4 : 
				begin
					Mem_OE = 1'b1;
					Mem_WE = 1'b1;
				end
			S_4 : 
				begin // JSR
					DRMUX = 1'b1; // Write to R7
					GatePC = 1'b1; // PC to reg
					LD_REG = 1'b1; 
				end 
			S_21 : 
				begin // JSR
					ADDR1MUX = 1'b0; // PC +
					ADDR2MUX = 2'b11; // sext(offset11)
					PCMUX = 2'b01; // MARMUX to PC
					LD_PC = 1'b1;
				end
			S_12 : 
				begin // JMP
					ADDR1MUX = 1'b1; // PC +
					ADDR2MUX = 2'b00; // 0
					SR1MUX = 1'b0;
					PCMUX = 2'b01; // MARMUX to PC
					LD_PC = 1'b1;
				end
			S_22_2 : 
				begin // For branch enabled, S_22_1 has all signals low
					ADDR1MUX = 1'b0; // PC +
					ADDR2MUX = 2'b10; //sext(offset9)
					PCMUX = 2'b01; // MARMUX to PC
					LD_PC = 1'b1;
				end

			default : ;
		endcase
	end 

	
endmodule
