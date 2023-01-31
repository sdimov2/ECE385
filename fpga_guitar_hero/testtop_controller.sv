module testtop_controller(

      ///////// Clocks /////////
      input    MAX10_CLK1_50,

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,





      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 
);


logic Reset;
logic clk;
logic [9:0] screenX, screenY;
logic write;
logic [31:0] data_in;
	
logic active;
logic [3:0] red, green, blue;

logic [1:0] addr;


assign VGA_R = red;
assign VGA_G = green;
assign VGA_B = blue;

assign data_in = 32'h00003205;
assign write = 1;

assign clk = MAX10_CLK1_50;

vga_controller m_controller(
		.Clk(clk),
		.Reset(Reset),
		.DrawX(screenX),
		.DrawY(screenY),
		.hs(VGA_HS),
		.vs(VGA_VS)
	);

note_controller m(.*);

endmodule
