module little_bossRAM
(
		input [23:0] data_In,
		input [18:0] write_address, read_address,
		input we, Clk,
		output logic [23:0] data_Out_boss
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem [0:1680];

initial
begin
	 $readmemh("ECE385-HelperTools-master/PNGToHex/On-Chip_Memory/sprite_bytes/little_boss.txt", mem);
end
always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	if (read_address < 1681)
		data_Out_boss<= mem[read_address];
	else
		data_Out_boss<= 24'b0;
end

endmodule
