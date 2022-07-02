module  victoryRAM
(
		input [23:0] data_In,
		input [18:0] write_address, read_address,
		input we, Clk,
		output logic [23:0] data_Out_vict
);

	// mem has width of 3 bits and a total of 400 addresses
	logic [23:0] mem [0:100*54-1];//100

	initial
	begin
		 $readmemh("ECE385-HelperTools-master/PNGToHex/On-Chip_Memory/sprite_bytes/failure.txt", mem);
	end
	always_ff @ (posedge Clk) begin
		if (we)
			mem[write_address] <= data_In;
		if (read_address < 100*54)
			data_Out_vict <= mem[read_address];
		else
			data_Out_vict <= 24'b0;
	end

endmodule