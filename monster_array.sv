module monster_array(	input					Clk, Reset,
								input	[2:0]			Summon,
								input [15:0]		used_array,
								input int			offx_array[0:15], 
								input int			offy_array[0:15],
								input [2:0]			occur_array[0:15],
								input [15:0]		achieve_array,
								input [2:0]			type_array[0:15],
									
								output [15:0]		enable_array,
								output [2:0]		monster_occur,
								output int			offset_x, offset_y,
								output [2:0]		Summon_array[0:15],
								output int			achieve_monsters
							);
	int i, j;
	always_ff @ (posedge Clk)
	begin
		if (Reset)
			enable_array = 16'b0;
		if (Summon != 3'b000) begin
			for (i=0; i<16; i=i+1) begin
				if (used_array[i] == 0) begin
					enable_array[i] = 1;
					Summon_array[i] = Summon;
					break;
				end
			end
		end
		else begin
			enable_array = 16'b0;
			for (i=0; i<16; i=i+1) begin
				Summon_array[i] = 3'b0;
			end
		end
		
		for (j=0; j<16; j=j+1) begin
			if (occur_array[j] != 3'b000) begin
				monster_occur = occur_array[j];
				offset_x = offx_array[j];
				offset_y = offy_array[j];
				break;
			end
			else if (j==15)
				monster_occur = 3'b000;
		end
		
		achieve_monsters = 0;
		for (i=0; i<16; i=i+1) begin
			if (achieve_array[i] == 1'b1) begin
				achieve_monsters += 1;
			end
		end
	end

endmodule 