module tower_array(
				input command_tw, Reset,
				input build, sell,
				input [2:0] build_location,
				input [2:0] build_type,
				input [7:0] fi_used_array,
				input [7:0] print_array,
				input [2:0] fi_occur_type[0:7],
				input int offsetx_array[0:7],
				input int offsety_array[0:7],
				
				input Clk,
				output [7:0] toi_enable_array,
				output [2:0] toi_type_array[0:7],
				output [7:0] toi_sell_array,
				output [2:0] print_type,
				output int	 offset_towerx, offset_towery
);
//	logic [9:0] x_pos[0:7];
//	logic [9:0] y_pos[0:7];
	int i;
	always_ff @ (posedge Clk) begin
		if (command_tw) begin
			if (build) begin
				toi_enable_array[build_location] = 1'b1;
				toi_type_array[build_location] = build_type;
			end
			else if (sell) begin
				toi_sell_array[build_location] = 1'b1;
			end
		end
		else begin
			toi_enable_array = 8'b0;
			toi_sell_array = 8'b0;
		end
	end
	
	always_ff @ (posedge Clk) begin
				print_type = 3'b000;
				offset_towerx = 0;
				offset_towery = 0;
		for (i=0; i<8; i=i+1) begin
			if (print_array[i] != 1'b0) begin
				print_type = 3'b001;
				offset_towerx = offsetx_array[i];
				offset_towery = offsety_array[i];
			end
		end
	end	
	
	
endmodule
