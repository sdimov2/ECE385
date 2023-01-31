//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

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




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	
	
	
	
	
	
	// deal with the "tri state buffers"
	// SCL = Arduino[15] sda = arduino[14]

	logic i2c_serial_scl_oe, i2c_serial_sda_oe, i2c_serial_scl_in, i2c_serial_sda_in;

	assign i2c_serial_scl_in = ARDUINO_IO[15];
	assign ARDUINO_IO[15] = i2c_serial_scl_oe ? 1'b0 : 1'bz;

	assign i2c_serial_sda_in = ARDUINO_IO[14];
	assign ARDUINO_IO[14] = i2c_serial_sda_oe ? 1'b0 : 1'bz;


	// setting the clock from the default 50MHz to 12.5Mhz by dividing by 4
	// arduino io[3] is the master clock that needs to be set to 12.5MHz

	logic [1:0] aud_mclk_ctr;
	assign ARDUINO_IO[3] = aud_mclk_ctr[1];


	//generate the 12.5MHz codec clk

	always_ff @(posedge MAX10_CLK1_50) 
	begin
		aud_mclk_ctr <= aud_mclk_ctr +1;
	end
	
	// test audio by connecting I2S_DIN with I2S_DOUT
	
	assign ARDUINO_IO[1] = 1'bz;
	assign ARDUINO_IO[2] = ARDUINO_IO[1];
	
	/*
	//logic SCLK, LRCLK, I2S_DIN, I2S_DOUT;
	I2S_interface i2s (
		.I2S_DIN(ARDUINO_IO[2]),
		.I2S_DOUT(ARDUINO_IO[1]),
		.LRCLK(ARDUINO_IO[4]),
		.SCLK(ARDUINO_IO[5])
	);
	*/
	
	
	lab62soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

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

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode),
		
		//I2C
		.i2c_serial_sda_in(i2c_serial_sda_in),              //              i2c_serial.sda_in
		.i2c_serial_scl_in(i2c_serial_scl_in),              //                        .scl_in
      .i2c_serial_sda_oe(i2c_serial_sda_oe),              //                        .sda_oe
      .i2c_serial_scl_oe(i2c_serial_scl_oe)
		
	 );
/*
module lab62soc (
		input  wire        clk_clk,                        //                     clk.clk
		output wire [15:0] hex_digits_export,              //              hex_digits.export
		input  wire        i2c_serial_sda_in,              //              i2c_serial.sda_in
		input  wire        i2c_serial_scl_in,              //                        .scl_in
		output wire        i2c_serial_sda_oe,              //                        .sda_oe
		output wire        i2c_serial_scl_oe,              //                        .scl_oe
		input  wire [1:0]  key_external_connection_export, // key_external_connection.export
		output wire [7:0]  keycode_export,                 //                 keycode.export
		output wire [13:0] leds_export,                    //                    leds.export
		input  wire        reset_reset_n,                  //                   reset.reset_n
		output wire        sdram_clk_clk,                  //               sdram_clk.clk
		output wire [12:0] sdram_wire_addr,                //              sdram_wire.addr
		output wire [1:0]  sdram_wire_ba,                  //                        .ba
		output wire        sdram_wire_cas_n,               //                        .cas_n
		output wire        sdram_wire_cke,                 //                        .cke
		output wire        sdram_wire_cs_n,                //                        .cs_n
		inout  wire [15:0] sdram_wire_dq,                  //                        .dq
		output wire [1:0]  sdram_wire_dqm,                 //                        .dqm
		output wire        sdram_wire_ras_n,               //                        .ras_n
		output wire        sdram_wire_we_n,                //                        .we_n
		input  wire        spi0_MISO,                      //                    spi0.MISO
		output wire        spi0_MOSI,                      //                        .MOSI
		output wire        spi0_SCLK,                      //                        .SCLK
		output wire        spi0_SS_n,                      //                        .SS_n
		input  wire        usb_gpx_export,                 //                 usb_gpx.export
		input  wire        usb_irq_export,                 //                 usb_irq.export
		output wire        usb_rst_export                  //                 usb_rst.export
	);
	*/
	
	
//instantiate a vga_controller, ball, and color_mapper here with the ports.

vga_controller myController(
		.Clk(MAX10_CLK1_50),
		.Reset(Reset_h),
		.hs(VGA_HS),
		.vs(VGA_VS),
		.pixel_clk(VGA_Clk),
		.blank(blank),
		.sync(sync),
		.DrawX(drawxsig),
		.DrawY(drawysig)
);

/*module  vga_controller ( input        Clk,       // 50 MHz clock
                                      Reset,     // reset signal
                         output logic hs,        // Horizontal sync pulse.  Active low
								              vs,        // Vertical sync pulse.  Active low
												  pixel_clk, // 25 MHz pixel clock output
												  blank,     // Blanking interval indicator.  Active low.
												  sync,      // Composite Sync signal.  Active low.  We don't use it in this lab,
												             //   but the video DAC on the DE2 board requires an input for it.
								 output [9:0] DrawX,     // horizontal coordinate
								              DrawY );   // vertical coordinate
*/


color_mapper my_Colormapper(
	.BallX(ballxsig),
	.BallY(ballysig),
	.DrawX(drawxsig),
	.DrawY(drawysig),
	.Ball_size(ballsizesig),
	.Red(Red),
	.Green(Green),
	.Blue(Blue)
);
/*module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       output logic [7:0]  Red, Green, Blue );
*/

ball myBall(
	.Reset(Reset_h),
	.frame_clk(VGA_VS),
	.keycode(keycode),
	.BallX(ballxsig),
	.BallY(ballysig),
	.BallS(ballsizesig)
);
/*module  ball ( input Reset, frame_clk,
					input [7:0] keycode,
               output [9:0]  BallX, BallY, BallS );
					*/
			


endmodule
