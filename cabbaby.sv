module cabbabyRAM( 		
		input [23:0] data_In,
		input [18:0] write_address, read_address,
		input we, Clk,
		output logic [23:0] data_Out_cab

);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem [0:60*84-1];//60*84-1

initial
begin
	 $readmemh("ECE385-HelperTools-master/PNGToHex/On-Chip_Memory/sprite_bytes/baicai.txt", mem);
end
always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	if (read_address < 60*84)
		data_Out_cab <= mem[read_address];
	else
		data_Out_cab <= 24'b0;
end

endmodule