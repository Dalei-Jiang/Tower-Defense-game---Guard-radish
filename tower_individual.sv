module tower_individual (
						input enable, sell, Reset, Clk,
						input int 		x_lu, y_ru,
						input [2:0] 	type_com,
						input [9:0]   	DrawX, DrawY,
						
						output [2:0] occur_type,
						output is_used,
						output is_print,
						output int off_x, off_y
);
	logic use_status;
	assign is_used = use_status;
	logic [2:0] current_type;
	assign occur_type = current_type;
	int position_x, position_y;
	assign position_x = x_lu;
	assign position_y = y_ru;
	initial begin
		use_status = 1'b0;
		current_type = 3'b000;
	end
	
	always_ff @ (posedge Clk) begin
		if (Reset) begin
			use_status = 1'b0;
			current_type = 3'b000;			
		end
		if (enable) begin
			use_status = 1'b1;
			current_type = type_com;
		end
		else if (sell) begin
			use_status = 1'b0;
			current_type = 3'b000;
		end
		else begin
			use_status = use_status;
			current_type = current_type;			
		end
	end
	
	always_comb begin
		if (DrawX-position_x<50 && DrawX-position_x>=0 && DrawY-position_y<50 && DrawY-position_y>=0 && use_status) begin
			is_print = 1'b1;
			off_x = DrawX-position_x;
			off_y = DrawY-position_y;
		end
		else begin
			is_print = 1'b0;
			off_x = 0;
			off_y = 0;
		end
	end
	
endmodule
