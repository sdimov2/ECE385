module fret(
	input Reset,
	input clk,
	input [9:0] screenX, screenY,
	input write,
	input [31:0] data_in,
	
	output logic active,
	output logic [3:0] red, green, blue
);

parameter Gem_size = 20;

localparam logic [3:0] gem_red[5] = '{4'h0, 4'hf, 4'hf, 4'h0, 4'hf};
localparam logic [3:0] gem_green[5] = '{4'hf, 4'h0, 4'hf, 4'h0, 4'ha};
localparam logic [3:0] gem_blue[5] = '{4'h0, 4'h0, 4'h0, 4'hf, 4'h0};

logic[9:0] GemXVals[5] = '{10'd220, 10'd270, 10'd320, 10'd370, 10'd420};

int i;



//[15:7][ 6 ][ 5  ][ 4 ][ 3 ][ 2 ][ 1 ][ 0 ]
//[ypos][TAP][HOPO][ORG][BLU][YEL][RED][GRN]
logic [31:0] note_data;

logic [9:0] GemX[5], GemY[5];
int DistX[5], DistY[5], Size;
int gemactive[5];

logic [4:0] targeted;

logic [2:0] active_index;
logic zero;

logic [39:0] closed_data;
logic [39:0] open_data;
logic pixel;

always @(posedge clk) begin
	if (write)
		note_data <= data_in;
end

logic [5:0] sprite_rom_addr;

note_rom closed_rom(.addr(sprite_rom_addr), .data(closed_data));
fret_rom open_rom(.addr(sprite_rom_addr), .data(open_data));

always_comb begin
	for (i = 0; i < 5; i++) begin
		GemX[i] = GemXVals[i];
		GemY[i] = {1'b0, note_data[15:7]};
		gemactive[i] = note_data[i];
		

		DistX[i] = screenX - GemX[i];
		DistY[i] = screenY - GemY[i];
		Size = Gem_size;
		
		targeted[i] =  (screenX > GemX[i] - Gem_size && screenX < GemX[i] + Gem_size
			&& screenY > GemY[i] - Gem_size && screenY < GemY[i] + Gem_size);
	end
	
	
	
	zero = 1'b0;
	active_index = 3'b0;

	unique casex (targeted)
		5'b00000:	zero = 1'b1;
		5'bxxxx1:	active_index = 3'h0;
		5'bxxx10:	active_index = 3'h1;
		5'bxx100:	active_index = 3'h2;
		5'bx1000:	active_index = 3'h3;
		5'b10000:	active_index = 3'h4;
	endcase
	
	red = 0;
	green = 0;
	blue = 0;
	active = 0;
	sprite_rom_addr = DistY[active_index]+Gem_size;
	pixel = gemactive[active_index] ? closed_data[DistX[active_index]+Gem_size] : open_data[DistX[active_index]+Gem_size];

	if (~zero) begin
		active = pixel;
		red = gem_red[active_index] & {4{pixel}};
		green = gem_green[active_index] & {4{pixel}};
		blue = gem_blue[active_index] & {4{pixel}};
	end
	
	
	if (note_data[15:7] > 480 + Size)
		active = 1'b0;

end


endmodule
