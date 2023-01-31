module note(
	input Reset,
	input clk,
	input [9:0] screenX, screenY,
	input write,
	input read,
	input [3:0] be,
	input [31:0] data_in,
	
	
	input logic [2:0] note_rom_data,
	input logic hopo_rom_data,
	output logic [13:0] rom_addr,
	
	output logic inblock,
	output logic active,
	output logic [3:0] red, green, blue,
	output logic [31:0] data_out
);

localparam logic [3:0] gem_red[5] = '{4'h0, 4'hf, 4'hf, 4'h0, 4'hf};
localparam logic [3:0] gem_green[5] = '{4'hf, 4'h0, 4'hf, 4'h0, 4'ha};
localparam logic [3:0] gem_blue[5] = '{4'h0, 4'h0, 4'h0, 4'hf, 4'h0};


//[15:7][ 6 ][ 5  ][ 4 ][ 3 ][ 2 ][ 1 ][ 0 ]
//[ypos][TAP][HOPO][ORG][BLU][YEL][RED][GRN]
logic [31:0] note_data;

logic [5:0] yoffset;

assign yoffset = screenY - note_data[15:7];
assign inblock = (screenY >= note_data[15:7] && screenY < note_data[15:7] + 6'd40
							&& screenX >= 10'd200 && screenX < 10'd440);


logic [4:0] rom_exp;	

// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge clk) begin
	if (read)
		data_out <= note_data;	
	else if (write) begin
		if (be[3])
			note_data[31:24] <= data_in[31:24];
		if (be[2])
			note_data[23:16] <= data_in[23:16];
		if (be[1])
			note_data[15:8]  <= data_in[15:8];
		if (be[0])
			note_data[7:0]   <= data_in[7:0];
	end
end




always_comb begin
	rom_addr = inblock ? yoffset * 14'd240 + (screenX - 10'd200) : '0;
	unique case (note_rom_data)
		3'h0: rom_exp = 5'h0;
		3'h1:	rom_exp = 5'h1;
		3'h2: rom_exp = 5'h2;
		3'h3: rom_exp = 5'h4;
		3'h4: rom_exp = 5'h8;
		3'h5: rom_exp = 5'h10;
		default: rom_exp = 5'h0;
	endcase
	
	
	active = (inblock && rom_exp & note_data[4:0]);
	
	if (active) begin
		if (note_data[5] & hopo_rom_data) begin
			red   = 4'hf;
			blue  = 5'hf;
			green = 5'hf;
		end else begin
			unique case (note_rom_data)
				3'h1: begin
						red   = gem_red[0];
						blue  = gem_blue[0];
						green = gem_green[0];
					end
				3'h2: begin
						red   = gem_red[1];
						blue  = gem_blue[1];
						green = gem_green[1];
					end
				3'h3: begin
						red   = gem_red[2];
						blue  = gem_blue[2];
						green = gem_green[2];
					end
				3'h4: begin
						red   = gem_red[3];
						blue  = gem_blue[3];
						green = gem_green[3];
					end
				3'h5: begin
						red   = gem_red[4];
						blue  = gem_blue[4];
						green = gem_green[4];
					end
			endcase
		end
	end else begin
		red   = '0;
		blue  = '0;
		green = '0;
	end
end


endmodule
