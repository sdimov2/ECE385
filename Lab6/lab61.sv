/*---------------------------------------------------------------------------
  --      lab61.sv                                                          --
  --      Christine Chen                                                   --
  --      10/23/2013                                                       --
  --      modified by Zuofu Cheng                                          --
  --      For use with ECE 385                                             --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/
// Top-level module that integrates the Nios II system with the rest of the hardware

module lab61(  	 	  input	        MAX10_CLK1_50, 
					  input  [1:0]  KEY,
					  output [9:0]  LEDR,
					  output [12:0] DRAM_ADDR,
					  output [1:0]  DRAM_BA,
					  output        DRAM_CAS_N,
					  output	    DRAM_CKE,
					  output	    DRAM_CS_N,
					  inout  [15:0] DRAM_DQ,
					  output		DRAM_LDQM,
					  output 		DRAM_UDQM,
					  output	    DRAM_RAS_N,
					  output	    DRAM_WE_N,
					  output	    DRAM_CLK,
					  input [9:0] SWITCHES
				  
				  );
				  
				  logic SW_RST;
				  always_comb 
				  begin
				  SW_RST = ~(SWITCHES[9] & SWITCHES[8]); // RESET SIGNAL IS ACTIVE LOW
				  // NAND BOTH SWITCHES (UP = HIGH) FOR BOTH SWITCHES UP (HIGH) FOR RESET LOW
				  LEDR[9] = ~SW_RST; // 2 msb LEDs are NOT(SW NAND SW) = SW AND SW
				  LEDR[8] = ~SW_RST; // Both switches in up (high) position to light up
				  // This indicates reset active
				  end
				  
				  // You need to make sure that the port names here are identical to the port names at 
				  // the interface in lab61_soc.v
				  lab61soc m_lab61_soc (.clk_clk(MAX10_CLK1_50),
											 .reset_reset_n(SW_RST), 				// Our reset signal (SWITCHES9 & SWITCHES8) is plugged here to free up Key0 and Key1
											 .led_wire_export(LEDR),
											//SDRAM
											.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
											.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
											.sdram_wire_ba(DRAM_BA),                             //.ba
											.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
											.sdram_wire_cke(DRAM_CKE),                           //.cke
											.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
											.sdram_wire_dq(DRAM_DQ),                             //.dq
											.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
											.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
											.sdram_wire_we_n(DRAM_WE_N),                         //.we_n
											.switches_wire_export(SWITCHES[7:0]),								// 8 least sig switches
											.buttons_wire_export(KEY) 												// KEY[1:0] goes to buttons wire
											 );
											 
/*module lab61soc (
		input  wire [1:0]  buttons_wire_export,  //  buttons_wire.export
		input  wire        clk_clk,              //           clk.clk
		output wire [7:0]  led_wire_export,      //      led_wire.export
		input  wire        reset_reset_n,        //         reset.reset_n
		output wire        sdram_clk_clk,        //     sdram_clk.clk
		output wire [12:0] sdram_wire_addr,      //    sdram_wire.addr
		output wire [1:0]  sdram_wire_ba,        //              .ba
		output wire        sdram_wire_cas_n,     //              .cas_n
		output wire        sdram_wire_cke,       //              .cke
		output wire        sdram_wire_cs_n,      //              .cs_n
		inout  wire [15:0] sdram_wire_dq,        //              .dq
		output wire [1:0]  sdram_wire_dqm,       //              .dqm
		output wire        sdram_wire_ras_n,     //              .ras_n
		output wire        sdram_wire_we_n,      //              .we_n
		input  wire [7:0]  switches_wire_export  // switches_wire.export
	);
*/
											 
				//Instantiate additional FPGA fabric modules as needed		  
endmodule