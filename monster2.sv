module  monster2RAM
(
		input [23:0] data_In,
		input [18:0] write_address, read_address,
		input we, Clk,
		input [28:0] timestamp,
		output logic [23:0] data_Out_monster2
);

// mem has width of 3 bits and a total of 400 addresses
	logic [23:0] mem1 [0:45*45-1];
	logic [23:0] mem2 [0:45*45-1];

	initial
	begin
		 $readmemh("ECE385-HelperTools-master/PNGToHex/On-Chip_Memory/sprite_bytes/monster2_1.txt", mem1);
		 $readmemh("ECE385-HelperTools-master/PNGToHex/On-Chip_Memory/sprite_bytes/monster2_2.txt", mem2);
	end
	always_ff @ (posedge Clk) begin
		if (we)
			mem1[write_address] <= data_In;
		if (read_address < 45*45)
			if (timestamp%25000000 < 12500000)
				data_Out_monster2 <= mem1[read_address];
			else
				data_Out_monster2 <= mem2[read_address];
		else
			data_Out_monster2 <= 24'hffffff;
	end

endmodule