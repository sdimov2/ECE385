// TOP LEVEL ENTITY

module topLevel(
     ///////// Clocks /////////
      input     MAX10_CLK1_50, 
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
logic Clk;
assign Clk = MAX10_CLK1_50;



logic[9:0] DrawX, DrawY;
logic reset;
assign reset = 1'b0;

always_comb
begin
	VGA_HS = hs;
	VGA_VS = vs;
end

logic hs, vs, pixel_clk, blank, sync;
vga_controller vga_controller_0(         .Clk(Clk),       // 50 MHz clock
    .Reset(reset),     // reset signal
   .hs(hs),        // Horizontal sync pulse.  Active low
    .vs(vs),        // Vertical sync pulse.  Active low
    .pixel_clk(pixel_clk), // 25 MHz pixel clock output
    .blank(blank),     // Blanking interval indicator.  Active low.
    .sync(sync),      // Composite Sync signal.  Active low.  We don't use it in this lab,
    //   but the video DAC on the DE2 board requires an input for it.
    .DrawX(DrawX),     // horizontal coordinate
    .DrawY(DrawY) );   // vertical coordinate

	 
/*
logic [5:0] drawNote;
timersColumnTest column0(
 .Clk(Clk),
 .button0(KEY[0]),
 .button1(KEY[1]),
 .drawX(DrawX), .drawY(DrawY),
 .drawNote(drawNote)
);
*/
logic gameTimerLoop;
singleTimer1 
#(.N(7), .Z(7'h5E)) // 7 bits, stop at x5E + x03 = 97
gameTimer (
	.Clk(vs), .start(gameTimerLoop),
	.M(7'b0000001),
	.countActive(),
	.countEnd(gameTimerLoop),
	.countT()
);



logic [4:0] [3:0] colRegAddr;
timersColumn #
(
		.X_LEFT(10'd506), // left bound of the note, inclusive
		.HIT_CENTER(10'h1F4) // Place for timer at ideal hit
)
TimersColumn0
(
	 .reset(~KEY[1]), .frameClk(vs), .gameClk(gameTimerLoop), 		// Start signal to change to counting state, clock signal
	 .noteStart(1'b1), .strum(~KEY[0]),
	 .M(10'h001),
	 .drawY(DrawY), .drawX(DrawX),
	.hcount (LEDR[9:6]), .mcount(LEDR[3:0]),
	 .regAddr(colRegAddr[0])
);
timersColumn #
(
		.X_LEFT(10'd400), // left bound of the note, inclusive
		.HIT_CENTER(10'h1F4) // Place for timer at ideal hit
)
TimersColumn1
(
	 .reset(~KEY[1]), .frameClk(vs), .gameClk(gameTimerLoop), 		// Start signal to change to counting state, clock signal
	 .noteStart(1'b1), .strum(~KEY[0]),
	 .M(10'h001),
	 .drawY(DrawY), .drawX(DrawX),

	 .regAddr(colRegAddr[1])
);
timersColumn #
(
		.X_LEFT(10'd294), // left bound of the note, inclusive
		.HIT_CENTER(10'h1F4) // Place for timer at ideal hit
)
TimersColumn2
(
	 .reset(~KEY[1]), .frameClk(vs), .gameClk(gameTimerLoop), 		// Start signal to change to counting state, clock signal
	 .noteStart(1'b1), .strum(~KEY[0]),
	 .M(10'h001),
	 .drawY(DrawY), .drawX(DrawX),

	 .regAddr(colRegAddr[2])
);
timersColumn #
(
		.X_LEFT(10'd188), // left bound of the note, inclusive
		.HIT_CENTER(10'h1F4) // Place for timer at ideal hit
)
TimersColumn3
(
	 .reset(~KEY[1]), .frameClk(vs), .gameClk(gameTimerLoop), 		// Start signal to change to counting state, clock signal
	 .noteStart(1'b1), .strum(~KEY[0]),
	 .M(10'h001),
	 .drawY(DrawY), .drawX(DrawX),

	 .regAddr(colRegAddr[3])
);
timersColumn #
(
		.X_LEFT(10'd82), // left bound of the note, inclusive
		.HIT_CENTER(10'h1F4) // Place for timer at ideal hit
)
TimersColumn4
(
	 .reset(~KEY[1]), .frameClk(vs), .gameClk(gameTimerLoop), 		// Start signal to change to counting state, clock signal
	 .noteStart(1'b1), .strum(~KEY[0]),
	 .M(10'h001),
	 .drawY(DrawY), .drawX(DrawX),

	 .regAddr(colRegAddr[4])
);



always_ff@(posedge pixel_clk) // You'll need to change things if there are too many synchronous delays-watch out
begin
	if(blank) // make sure within bounds of screer
	begin
    //if ((drawNote != 6'h00) && (blank == 1'b1))
	 if (socRegIdx != 4'h0)
	 //if (DrawX[9] == 1)
		begin
		  VGA_R = 4'b1111;
		  VGA_B = 4'b0000;
		  VGA_G = 4'b0000;
		end
		
		
		
		else if (colRegAddr[0] != 4'b0000)
		begin
			VGA_R = 4'b0000;
			VGA_B = 4'b0000;	
			VGA_G = 4'b1111;
		end
		else if (colRegAddr[1] != 4'b0000)
		begin
			VGA_R = 4'b0000;
			VGA_B = 4'b0000;	
			VGA_G = 4'b1111;
		end
		else if (colRegAddr[2] != 4'b0000)
		begin
			VGA_R = 4'b0000;
			VGA_B = 4'b0000;	
			VGA_G = 4'b1111;
		end
		else if (colRegAddr[3] != 4'b0000)
		begin
			VGA_R = 4'b0000;
			VGA_B = 4'b0000;	
			VGA_G = 4'b1111;
		end
		else if (colRegAddr[4] != 4'b0000)
		begin
			VGA_R = 4'b0000;
			VGA_B = 4'b0000;	
			VGA_G = 4'b1111;
		end
		
		
		else // Default is mathematical background
		begin
		  VGA_R = {1'b0, DrawX[8:6]};
		  VGA_B = {1'b0, DrawY[8:6]};
		  VGA_G = 4'b0010;
		end
	end
	else // For blank == 0
	begin
	  VGA_R = 4'b0000;
	  VGA_B = 4'b0000;
	  VGA_G = 4'b0000;
	end
end


/*

always_comb begin 
	if (FGD_IDX[0] == 1'b1)
	begin // LSB of index is 1
		FGD_COLOR = Palette[(FGD_IDX[3:1])][24:13]; // Color 1 is in 24:13
	end  
	else  
	begin // LSB of index is 0
		FGD_COLOR = Palette[(FGD_IDX[3:1])][12:1]; // Color 0 is in 12:1
	end
end

always_comb 
begin
	if (BKG_IDX[0] == 1'b1)
	begin // LSB of index is 1
		BKG_COLOR = Palette[(BKG_IDX[3:1])][24:13]; // Color 1 is in 24:13
	end
	else  
	begin // LSB of index is 0
		BKG_COLOR = Palette[(BKG_IDX[3:1])][12:1]; // Color 0 is in 12:1
	end

	if (FGD_IDX[0] == 1'b1)
	begin // LSB of index is 1
		FGD_COLOR = Palette[(FGD_IDX[3:1])][24:13]; // Color 1 is in 24:13
	end  
	else  
	begin // LSB of index is 0
		FGD_COLOR = Palette[(FGD_IDX[3:1])][12:1]; // Color 0 is in 12:1
	end
end


logic [31:0] Palette [7:0]; // 8 32-bit words for color palette
*/

//palette_ROM


// try 7:0// arranged 0:7 since addresses are going to be done that way from NIOS II


/*

always_ff @ (posedge CLK)
begin
	if(writeREG)
	begin // Addressing is really weird
		if (AVL_BYTE_EN[3] == 1)
			Palette[(AVL_ADDR[2:0])][24:21] <= AVL_WRITEDATA[27:24];
		if (AVL_BYTE_EN[2] == 1)
			Palette[(AVL_ADDR[2:0])][20:13] <= AVL_WRITEDATA[23:16];
		if (AVL_BYTE_EN[1] == 1)
			Palette[(AVL_ADDR[2:0])][12:9] <= AVL_WRITEDATA[11:8];
		if (AVL_BYTE_EN[0] == 1)
			Palette[(AVL_ADDR[2:0])][8:1] <= AVL_WRITEDATA[7:0];
	end
end

// REMAKE SO IS NULL IF REG OUTPUT IS NULL
always_ff @ (posedge pixelClk) 
begin
	if (blank)
	begin
		case(bitWithInv)
		
		1'b0 : // if 0 go background
		begin
			red <= BKG_COLOR[11:8]; 
			green <= BKG_COLOR[7:4];
			blue <= BKG_COLOR[3:0];
		end
		1'b1 : // if 1 go foreground
		begin
			red <= FGD_COLOR[11:8];
			green <= FGD_COLOR[7:4];
			blue <= FGD_COLOR[3:0];
		end
		endcase
	end
	else
	begin // If out of bounds, make colors black/null
			red <= 4'b0000;
			green <= 4'b0000;
			blue <= 4'b0000;
	end
end
*/

logic [3:0] socRegIdx;
GuitarHero guitarHero_soc(
	.clk_clk(MAX10_CLK1_50),                        //                     clk.clk 
	.hex_digits_export(),              //              hex_digits.export
	.key_external_connection_export(), // key_external_connection.export
	.keycode_export(),                 //                 keycode.export
	.leds_export(),                    //                    leds.export
	.reset_reset_n(1'b1),                  //                   reset.reset_n
	.sdram_clk_clk(DRAM_CLK),                  //               sdram_clk.clk
	.sdram_wire_addr(DRAM_ADDR),                //              sdram_wire.addr
	.sdram_wire_ba(DRAM_BA),                  //                        .ba
	.sdram_wire_cas_n(DRAM_CAS_N),               //                        .cas_n
	.sdram_wire_cke(DRAM_CKE),                 //                        .cke
	.sdram_wire_cs_n(DRAM_CS_N),                //                        .cs_n
	.sdram_wire_dq(DRAM_DQ),                  //                        .dq
	.sdram_wire_dqm({DRAM_UDQM, DRAM_LDQM}),                 //                        .dqm
	.sdram_wire_ras_n(DRAM_RAS_N),               //                        .ras_n
	.sdram_wire_we_n(DRAM_WE_N),                //                        .we_n
	.spi0_MISO(),                      //                    spi0.MISO
	.spi0_MOSI(),                      //                        .MOSI
	.spi0_SCLK(),                      //                        .SCLK
	.spi0_SS_n(),                      //                        .SS_n
	.vga_conduit_drawx(DrawX),           //          text_interface.drawx
	.vga_conduit_drawy(DrawY),           //                        .drawy
	.vga_conduit_reg_idx(socRegIdx),         //                        .reg_idx
	.usb_gpx_export(),                 //                 usb_gpx.export
	.usb_irq_export(),                 //                 usb_irq.export
	.usb_rst_export()                  //                 usb_rst.export
);



endmodule
