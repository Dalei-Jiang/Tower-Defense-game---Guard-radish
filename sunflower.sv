module  tower1RAM
(
		input [23:0] data_In,
		input [18:0] write_address, read_address,
		input we, Clk,
		output logic [23:0] data_Out_tower1
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem [0:50*50-1];

initial
begin
	 $readmemh("ECE385-HelperTools-master/PNGToHex/On-Chip_Memory/sprite_bytes/sunflower.txt", mem);
end
always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	if (read_address < 2499)
		data_Out_tower1 <= mem[read_address];
	else
		data_Out_tower1 <= 24'b0;
end

endmodule
