module note_controller#(
	parameter count = 3,
	parameter width = 2
)(
	input Reset,
	input clk,
	input [9:0] screenX, screenY,
	input write,
	input read,
	input [3:0] be,
	
	input [width-1:0] addr,
	input [31:0] data_in,
	output [31:0] data_out,
	
	output logic active,
	output logic [3:0] red, green, blue
);

int i;
int num_active;

genvar g;

logic [13:0] rom_addresses[count];
logic [2:0] rom_datas[count];
logic hopo_datas[count];

logic [13:0] rom_address;
logic [2:0] rom_data;
logic hopo_data;

logic [31:0] note_data_out[count];
logic [3:0] note_red[count], note_green[count], note_blue[count];
logic [count-1:0]note_active;
logic [count-1:0]inblock;
logic note_write[count];
logic note_read[count];
logic [$clog2(count)-1:0]active_index;
logic active_zero;

generate
	for (g = 0; g < count; g++) begin : generate_notes
		assign note_write[g] = (addr == g) & write;
		assign note_read[g] = (addr == g) & read;
	
		note u0(
			.Reset(Reset),
			.clk(clk),
			.screenX(screenX),
			.screenY(screenY),
			.write(note_write[g]),
			.read(note_read[g]),
			.be(be),
			.data_in(data_in),
			.data_out(note_data_out[g]),
			.inblock(inblock[g]),
			.active(note_active[g]),
			.red(note_red[g]),
			.green(note_green[g]),
			.blue(note_blue[g]),
			.rom_addr(rom_addresses[g]),
			.note_rom_data(rom_datas[g]),
			.hopo_rom_data(hopo_datas[g])
		);
	end
endgenerate

activemux #(.COUNT(count)) m_activemux (
	.bitmap(inblock),
	.index(active_index),
	.zero(active_zero)
);

new_note_rom m_rom(rom_address, clk, rom_data);
new_hopo_rom m_hopo_rom(rom_address, clk, hopo_data);

always_comb begin	
	data_out = note_data_out[addr];

	rom_address = '0;
	rom_datas = '{default: '0};
	hopo_datas = '{default: '0};

	if (!active_zero) begin
		rom_address = rom_addresses[active_index];
		rom_datas[active_index] = rom_data;
		hopo_datas[active_index] = hopo_data;
	
		red = note_red[active_index];
		green = note_green[active_index];
		blue = note_blue[active_index];
		active = 1;
	end else begin
		red = 4'h0;
		green = 4'h0;
		blue = 4'h0;
		active = 0;
	end
end

endmodule

module activemux #(parameter int COUNT = 31)(
	input [COUNT-1:0]bitmap,
	output logic [$clog2(COUNT)-1:0]index,
	output logic zero
);

	logic [30:0]extended_bitmap;	//might have to make both packed
	assign extended_bitmap = bitmap;
	
	logic [4:0]extended_index;

	always_comb begin
		zero = 1'b0;
		extended_index = 5'h0;
		
		unique casex (extended_bitmap)
			31'b0000000000000000000000000000000:	zero = 1'b1;
			31'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1:	extended_index = 5'h0;
			31'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10:	extended_index = 5'h1;
			31'bxxxxxxxxxxxxxxxxxxxxxxxxxxxx100:	extended_index = 5'h2;
			31'bxxxxxxxxxxxxxxxxxxxxxxxxxxx1000:	extended_index = 5'h3;
			31'bxxxxxxxxxxxxxxxxxxxxxxxxxx10000:	extended_index = 5'h4;
			31'bxxxxxxxxxxxxxxxxxxxxxxxxx100000:	extended_index = 5'h5;
			31'bxxxxxxxxxxxxxxxxxxxxxxxx1000000:	extended_index = 5'h6;
			31'bxxxxxxxxxxxxxxxxxxxxxxx10000000:	extended_index = 5'h7;
			31'bxxxxxxxxxxxxxxxxxxxxxx100000000:	extended_index = 5'h8;
			31'bxxxxxxxxxxxxxxxxxxxxx1000000000:	extended_index = 5'h9;
			31'bxxxxxxxxxxxxxxxxxxxx10000000000:	extended_index = 5'ha;
			31'bxxxxxxxxxxxxxxxxxxx100000000000:	extended_index = 5'hb;
			31'bxxxxxxxxxxxxxxxxxx1000000000000:	extended_index = 5'hc;
			31'bxxxxxxxxxxxxxxxxx10000000000000:	extended_index = 5'hd;
			31'bxxxxxxxxxxxxxxxx100000000000000:	extended_index = 5'he;
			31'bxxxxxxxxxxxxxxx1000000000000000:	extended_index = 5'hf;
			31'bxxxxxxxxxxxxxx10000000000000000:	extended_index = 5'h10;
			31'bxxxxxxxxxxxxx100000000000000000:	extended_index = 5'h11;
			31'bxxxxxxxxxxxx1000000000000000000:	extended_index = 5'h12;
			31'bxxxxxxxxxxx10000000000000000000:	extended_index = 5'h13;
			31'bxxxxxxxxxx100000000000000000000:	extended_index = 5'h14;
			31'bxxxxxxxxx1000000000000000000000:	extended_index = 5'h15;
			31'bxxxxxxxx10000000000000000000000:	extended_index = 5'h16;
			31'bxxxxxxx100000000000000000000000:	extended_index = 5'h17;
			31'bxxxxxx1000000000000000000000000:	extended_index = 5'h18;
			31'bxxxxx10000000000000000000000000:	extended_index = 5'h19;
			31'bxxxx100000000000000000000000000:	extended_index = 5'h1a;
			31'bxxx1000000000000000000000000000:	extended_index = 5'h1b;
			31'bxx10000000000000000000000000000:	extended_index = 5'h1c;
			31'bx100000000000000000000000000000:	extended_index = 5'h1d;
			31'b1000000000000000000000000000000:	extended_index = 5'h1e;
		endcase
		
		index = extended_index[$clog2(COUNT)-1:0];
	end

endmodule
