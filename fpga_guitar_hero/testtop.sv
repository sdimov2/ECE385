module testtop(

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

logic sda_oe, scl_oe;
logic scl_in, sda_in;

logic i2s_sclk, i2s_lrclk, i2s_dout;
logic i2s_mclk;

assign ARDUINO_IO[1] = i2s_dout;
assign ARDUINO_IO[3] = i2s_mclk;
assign i2s_lrclk = ARDUINO_IO[4];
assign i2s_sclk = ARDUINO_IO[5];

assign scl_in = ARDUINO_IO[15];
assign sda_in = ARDUINO_IO[14];

assign ARDUINO_IO[14] = sda_oe ? 1'bz : 1'b0;
assign ARDUINO_IO[15] = scl_oe ? 1'bz : 1'b0;

logic Reset;
logic clk;
logic [9:0] screenX, screenY;
logic fret_write;
logic [31:0] fret_data;
logic note_write;
logic [31:0] note_data;
	
logic fret_active;
logic [3:0] fret_red, fret_green, fret_blue;
logic note_active;
logic [3:0] note_red, note_green, note_blue;

logic [3:0] red, green, blue;

assign VGA_R = red;
assign VGA_G = green;
assign VGA_B = blue;

logic [1:0] note_addr;

assign fret_write = 1;
assign note_write = 1;
assign fret_data = 32'h0000d201;


assign clk = MAX10_CLK1_50;


always @(posedge clk) begin
	if (note_addr == 0)
		note_data <= 32'h00001621;
	else if (note_addr == 1)
		note_data <= 32'h00004802;
	else if (note_addr == 2)
		note_data <= 32'h00008023;
	else if (note_addr == 3)
		note_data <= 32'h0000b204;
	
	note_addr <= note_addr + 1;
end


vga_controller m_controller(
		.Clk(clk),
		.Reset(Reset),
		.DrawX(screenX),
		.DrawY(screenY),
		.hs(VGA_HS),
		.vs(VGA_VS)
	);
	
fret m_fret(
	.Reset(Reset),
	.clk(clk),
	.screenX(screenX),
	.screenY(screenY),
	.write(fret_write),
	.data_in(fret_data),
	.active(fret_active),
	.red(fret_red),
	.green(fret_green),
	.blue(fret_blue)
);

note_controller #(.count(4)) m_notes(
	.Reset(Reset),
	.clk(clk),
	.screenX(screenX),
	.screenY(screenY),
	.write(note_write),
	.addr(note_addr),
	.data_in(note_data),
	.active(note_active),
	.red(note_red),
	.green(note_green),
	.blue(note_blue)
);

always_comb begin
	if (fret_active) begin
		red = fret_red;
		green = fret_green;
		blue = fret_blue;
	end else if (note_active) begin
		red = note_red;
		green = note_green;
		blue = note_blue;
	end else begin
		red = 0;
		green = 0;
		blue = 0;
	end
end

endmodule
