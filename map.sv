module  mapRAM
(
		input [23:0] data_In,
		input [18:0] write_address, read_address,
		input we, Clk,
		output logic [23:0] data_Out_map1
);

	logic [23:0] mem [0:1*1-1];
	int	index;
	int	relative_address;
	logic [9:0] rel_X, rel_Y;
	logic [18:0] rel_addr;

	initial
	begin
		 $readmemh("ECE385-HelperTools-master/PNGToHex/On-Chip_Memory/sprite_bytes/map1.txt", mem);
	end
	
	always_comb begin
		rel_X = (read_address%640)/5;
		rel_Y = (read_address/640)/5;
		relative_address = rel_Y*128+rel_X;
	end
	
	always_ff @ (posedge Clk) begin
		if (we)
			mem[write_address] <= data_In;
		if (read_address < 128*96)
			data_Out_map1 <= mem[relative_address];
		else
			data_Out_map1 <= 24'b0;
	end

endmodule