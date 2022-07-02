module GPU(	input logic [9:0] DrawX, DrawY,
				input logic			is_open, is_game, is_vict, is_fail,
				input logic [2:0]	monster_occur, 
				input int	offset_x, offset_y,
				input logic Clk,
				input [2:0] level_index,
				input [2:0] print_type,
				input int offset_towerx, offset_towery,
				input [28:0] timestamp,
				input [7:0] fi_used_array,
				output logic [7:0]	display_type,
				output logic [18:0]	read_address,
				output int	counter
			);
		int i;
		logic [9:0] x_loc[0:7];
		logic [9:0] y_loc[0:7];
		assign x_loc = '{155, 205, 255, 355, 405, 455, 165, 460};
		assign y_loc = '{402, 402, 402, 402, 402, 402, 190, 190};
	
	always_comb begin 
	begin
		counter = 0;
		if (is_open==1) begin
			if (DrawX>=280 && DrawX<361 && DrawY>=200 && DrawY<281) begin
				counter = 6;
				display_type = 8'h01;//test
				read_address = (DrawX-280)+(DrawY-200)*81;
			end
			else begin
				display_type = 8'h00;
				read_address = DrawY*640+DrawX;
			end
		end
		
		else if (is_game==1) begin
			if (DrawX >= 390 && DrawX < 450 && DrawY >= 60 && DrawY < 144) begin
				display_type = 8'h33;
				read_address = (DrawX-390)+(DrawY-60)*60;
			end
			else if ((DrawX-x_loc[0])**2+(DrawY-y_loc[0])**2 <= 70*70 && (DrawX-x_loc[0])**2+(DrawY-y_loc[0])**2 >= 60*60 && fi_used_array[0] && timestamp%50000000<25000000) begin
				display_type = 8'h30;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[1])**2+(DrawY-y_loc[1])**2 <= 70*70 && (DrawX-x_loc[1])**2+(DrawY-y_loc[1])**2 >= 60*60 && fi_used_array[1] && timestamp%50000000<25000000) begin
				display_type = 8'h30;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[2])**2+(DrawY-y_loc[2])**2 <= 70*70 && (DrawX-x_loc[2])**2+(DrawY-y_loc[2])**2 >= 60*60 && fi_used_array[2] && timestamp%50000000<25000000) begin
				display_type = 8'h30;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[3])**2+(DrawY-y_loc[3])**2 <= 70*70 && (DrawX-x_loc[3])**2+(DrawY-y_loc[3])**2 >= 60*60 && fi_used_array[3] && timestamp%50000000<25000000) begin
				display_type = 8'h30;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[4])**2+(DrawY-y_loc[4])**2 <= 70*70 && (DrawX-x_loc[4])**2+(DrawY-y_loc[4])**2 >= 60*60 && fi_used_array[4] && timestamp%50000000<25000000) begin
				display_type = 8'h30;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[5])**2+(DrawY-y_loc[5])**2 <= 70*70 && (DrawX-x_loc[5])**2+(DrawY-y_loc[5])**2 >= 60*60 && fi_used_array[5] && timestamp%50000000<25000000) begin
				display_type = 8'h30;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[6])**2+(DrawY-y_loc[6])**2 <= 70*70 && (DrawX-x_loc[6])**2+(DrawY-y_loc[6])**2 >= 60*60 && fi_used_array[6] && timestamp%50000000<25000000) begin
				display_type = 8'h30;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[7])**2+(DrawY-y_loc[7])**2 <= 70*70 && (DrawX-x_loc[7])**2+(DrawY-y_loc[7])**2 >= 60*60 && fi_used_array[7] && timestamp%50000000<25000000) begin
				display_type = 8'h30;
				read_address = (22+offset_y)*45+(22+offset_x);
			end	
			else if ((DrawX-x_loc[0])**2+(DrawY-y_loc[0])**2 <= 59*59 && (DrawX-x_loc[0])**2+(DrawY-y_loc[0])**2 >= 40*40 && fi_used_array[0] && timestamp%50000000>25000000) begin
				display_type = 8'h31;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[1])**2+(DrawY-y_loc[1])**2 <= 59*59 && (DrawX-x_loc[1])**2+(DrawY-y_loc[1])**2 >= 40*40 && fi_used_array[1] && timestamp%50000000>25000000) begin
				display_type = 8'h31;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[2])**2+(DrawY-y_loc[2])**2 <= 59*59 && (DrawX-x_loc[2])**2+(DrawY-y_loc[2])**2 >= 40*40 && fi_used_array[2] && timestamp%50000000>25000000) begin
				display_type = 8'h31;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[3])**2+(DrawY-y_loc[3])**2 <= 59*59 && (DrawX-x_loc[3])**2+(DrawY-y_loc[3])**2 >= 40*40 && fi_used_array[3] && timestamp%50000000>25000000) begin
				display_type = 8'h31;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[4])**2+(DrawY-y_loc[4])**2 <= 59*59 && (DrawX-x_loc[4])**2+(DrawY-y_loc[4])**2 >= 40*40 && fi_used_array[4] && timestamp%50000000>25000000) begin
				display_type = 8'h31;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[5])**2+(DrawY-y_loc[5])**2 <= 59*59 && (DrawX-x_loc[5])**2+(DrawY-y_loc[5])**2 >= 40*40 && fi_used_array[5] && timestamp%50000000>25000000) begin
				display_type = 8'h31;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[6])**2+(DrawY-y_loc[6])**2 <= 59*59 && (DrawX-x_loc[6])**2+(DrawY-y_loc[6])**2 >= 40*40 && fi_used_array[6] && timestamp%50000000>25000000) begin
				display_type = 8'h31;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if ((DrawX-x_loc[7])**2+(DrawY-y_loc[7])**2 <= 59*59 && (DrawX-x_loc[7])**2+(DrawY-y_loc[7])**2 >= 40*40 && fi_used_array[7] && timestamp%50000000>25000000) begin
				display_type = 8'h31;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			else if (monster_occur == 3'b111) begin
				display_type = 8'h32;
				read_address = 0;
			end
			else if (monster_occur == 3'b001) begin
				display_type = 8'h04;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			
			else if (monster_occur == 3'b010) begin
				display_type = 8'h05;
				read_address = (22+offset_y)*45+(22+offset_x);
			end
			
			else if (monster_occur == 3'b110) begin
				display_type = 8'h0f;
				read_address = (15+offset_y)*31+(15+offset_x);
			end
			else if (print_type == 3'b001) begin
				display_type = 8'h10;
				read_address = offset_towerx + offset_towery*50;
			end
			else begin
				display_type = 8'h00;
				read_address = DrawY*640+DrawX;
			end
		end
		
		else if (is_fail==1) begin
			if (DrawX>=270 && DrawX<370 && DrawY>=134 && DrawY<176) begin
				display_type = 8'h20;
				read_address = (DrawX-270)+(DrawY-134)*100;			
			end
			else if (DrawX>=200 && DrawX<440 && DrawY>=100 && DrawY<210) begin
				display_type = 8'h34;
				read_address = 0;	
			end
			else begin
				if (monster_occur == 3'b000) begin
					display_type = 8'h00;
					read_address = DrawY*640+DrawX;
				end
				else if (monster_occur == 3'b001) begin
					display_type = 8'h04;
					read_address = (22+offset_y)*45+(22+offset_x);
				end
				else if (monster_occur == 3'b010) begin
					display_type = 8'h05;
					read_address = (22+offset_y)*45+(22+offset_x);
				end
				else if (monster_occur == 3'b110) begin
					display_type = 8'h0f;
					read_address = (15+offset_y)*31+(15+offset_x);
				end
				else begin
					display_type = 8'h00;
					read_address = DrawY*640+DrawX;
				end
			end
		end
		else if (is_vict==1) begin
			if (DrawX>=270 && DrawX<370 && DrawY>=134 && DrawY<189) begin
				display_type = 8'h35;
				read_address = (DrawX-270)+(DrawY-134)*100;
			end
			else begin
					display_type = 8'h00;
					read_address = DrawY*640+DrawX;
			end
		end
		else begin
				display_type = 8'h00;
				read_address = DrawY*640+DrawX;
		end
	end
	end
	
endmodule 