module adder2 ( input Clk, Reset_Load_Clear, Run_Accumulate, // Clk, reset, execute
					input [9:0] SW,	// Switches
					
				output logic [9:0] LED,  // LED wires
				output logic [16:0] Dval,
				output logic [6:0] HEX0, // Hex wires
										 HEX1, 
										 HEX2, 
										 HEX3, 
										 HEX4,
										 HEX5
										 );

		// Declare temporary values used by other modules
		logic Reset_h, Run_h; // Variables we actually use for reset and execute
		logic Load, Set, RightShift, Add, Subtract, rightBit, Xin;
		logic [16:0] In, Out;
		logic [7:0] S;
		//logic [16:0] extended_SW;
		logic [7:0] A, B; // 
		
		//assign extended_SW = {6'b000000, SW};

		
		// Misc logic that inverts button presses and ORs the Load and Run signal
		always_comb	
		begin
				Reset_h = ~Reset_Load_Clear;
				Load = Reset_h;
				Run_h = ~Run_Accumulate;
				S = SW[7:0];
		end
		

		
		// Control unit allows the register to load once, and not during full duration of button press
		//control run_once ( .*, .Reset(Reset_h), .Run(Run_h), .Run_O(Load));
		
		control multiply_once (	.*, .Reset(Reset_h), .Run(Run_h), 
						.shift(RightShift), .loadA(Add), .subtract(Subtract), .setA(Set)
						);
		
		
		// Router is mux that puts either sum of A and B or B into register
		//router route ( .R(Load), .A_In(extended_SW[15:0]), .B_In(S[16:0]), .Q_Out(In[16:0]) );
		
		// Regist unit that holds value of one operator
		//reg_17 reg_unit	( .*, .Reset(Reset_h), .Load(Load), .D(In[16:0]), .Data_Out(Out[16:0]));

		reg_17 shiftRegisters (
		.*, 
		.Load(Load), .Set(Set), .LoadA(Add), .Shift_En(RightShift), .Xin(Xin),
              .Ain(A), .Bin(S),
              .Data_Out(Out),
				  .Add_Out(rightBit));
		/*module reg_17 (input  Clk,
					input logic Load, Set, LoadA, Shift_En, Xin,
              input  logic [7:0]  Ain, Bin,   // For parallel loads
              output logic Add_Out,
              output logic [16:0]  Data_Out);    // 7:0*/
		
		// Addition unit
		
		assign Dval = Out;

		//select_adder adders	(.A(extended_SW[15:0]), .B(Out[15:0]), .cin(1'b0), .cout(S[16]), .S(S[15:0]) );
		select_adder adder9(
		.add(rightBit),
		.A(Out[15:8]), .B(S), // A and S inputs
		.cin(Subtract), // subtract bit from control
		.S({Xin, A}) // 9 bit output rewrite with logic wires??
		);

		// Hex units that display contents of SW and register R in hex
		HexDriver		AHex0 (
								.In0(SW[3:0]),
								.Out0(HEX0) );
								
		HexDriver		AHex1 (
								.In0(SW[7:4]),
								.Out0(HEX1) ); // right side two hex
								
		HexDriver		BHex0 (
								.In0(Out[3:0]),
								.Out0(HEX2) );
								
		HexDriver		BHex1 (
								.In0(Out[7:4]),
								.Out0(HEX3) );
		
		HexDriver		BHex2 (
								.In0(Out[11:8]),
								.Out0(HEX4) );
								
		HexDriver		BHex3 (
								.In0(Out[15:12]),
								.Out0(HEX5) );
								
		
		assign LED[9:8] = {Out[16], Out[16]};
		assign LED[7:0] = S[7:0];
		
		
endmodule