module monster_individual ( 	
								input   			Clk,                // 50 MHz clock
													Reset,              // Active-high reset signal
													frame_clk,          // The clock indicating a new frame (~60Hz)
								input [28:0]	timestamp,
								input [9:0]   	DrawX, DrawY,       // Current pixel coordinates
								input [2:0]		Summon,
								input				enable,
								input	[2:0]		level_index,
								input [7:0] 	fi_used_array,
								input [2:0] 	fi_occur_type[0:7],
								
								output int		offx,
								output int		offy,
								output			is_used,
								output[2:0]		occured_type,
								output[2:0]		used_type,
								output			achieve,
								output[7:0]		x_pos			
							);
	
//	 int			monster_num;
//	 int			minus;
	 parameter radius = 70;
	 int 			i, j, k;
    logic [9:0] monster_x_step;      // Step size on the X axis
    logic [9:0] monster_y_step;      // Step size on the Y axis
    logic [9:0] monster_x_center;  // Center position on the X axis
    logic [9:0] monster_y_center;  // Center position on the Y axis
	 logic		death;
	 int offset_xl, offset_xr;
	 int offset_yl, offset_yr;
	 
	 int blood_value;
	 int damage;
		logic [9:0] x_loc[0:7];
		logic [9:0] y_loc[0:7];
		assign x_loc = '{130, 180, 230, 330, 380, 430, 140, 435};
		assign y_loc = '{377, 377, 377, 377, 377, 377, 165, 165};
	 

	 always_comb begin
		case (level_index)
			3'b000: begin
				monster_x_center = 10'd214;
				monster_y_center = 10'd120;
			end
			3'b001: begin
				monster_x_center = 10'd214;
				monster_y_center = 10'd120;
			end
			3'b010: begin
				monster_x_center = 10'd214;
				monster_y_center = 10'd120;
			end
			default: begin
				monster_x_center = 10'd214;
				monster_y_center = 10'd120;
			end
		endcase
		
		case (indi_type)
			3'b000: begin
				monster_x_step = 10'd1;
				monster_y_step = 10'd1;
				offset_xl = -10;
				offset_xr = 10;
				offset_yl = -10;
				offset_yr = 10;
			end
			3'b001: begin
				monster_x_step = 10'd1;
				monster_y_step = 10'd1;
				offset_xl = -10;
				offset_xr = 10;
				offset_yl = -10;
				offset_yr = 10;
			end
			3'b010: begin
				monster_x_step = 10'd2;
				monster_y_step = 10'd2;
				offset_xl = -10;
				offset_xr = 10;
				offset_yl = -10;
				offset_yr = 10;			
			end
			3'b110: begin
				monster_x_step = 10'd1;
				monster_y_step = 10'd1;
				offset_xl = -15;
				offset_xr = 15;
				offset_yl = -15;
				offset_yr = 15;					
			end
			default: begin
				monster_x_step = 10'd1;
				monster_y_step = 10'd1;
				offset_xl = -10;
				offset_xr = 10;
				offset_yl = -10;
				offset_yr = 10;	
			end
		endcase
	 end

	 logic [9:0]  	monster_x_position;
	 logic [9:0]  	monster_y_position;	 
	 logic [9:0] 	monster_x_position_in;
	 logic [9:0] 	monster_y_position_in;
	 
	 logic [9:0] 	monster_x_motion;
	 logic [9:0] 	monster_y_motion;
	 logic [9:0] 	monster_x_motion_in;
	 logic [9:0] 	monster_y_motion_in;
	 
	 logic [2:0]	indi_type;
	 assign x_pos = monster_x_position[7:0];
	 
	 initial begin
			is_used = 1'b0;
			achieve = 1'b0;
			monster_x_position <= monster_x_center;
         monster_y_position <= monster_y_center;
         monster_x_motion <= 10'd0;
         monster_y_motion <= 10'd0;
			indi_type = 3'b000;
			blood_value = 0;
	 end
	 
		logic frame_clk_delayed, frame_clk_rising_edge;

		always_ff @ (posedge Clk) begin
			frame_clk_delayed <= frame_clk;
			frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
		end
 
		always_ff @ (posedge Clk) begin
			damage = 0;
			for (i=0; i<8; i=i+1) begin
				if (fi_used_array[i]==1'b1 && ((monster_x_position-x_loc[i])**2 + (monster_y_position-y_loc[i])**2 <= radius**2))
					damage = damage + 15;
			end
		end
		
    always_ff @ (posedge Clk)
    begin
        if (Reset) begin
            monster_x_position <= monster_x_center;
            monster_y_position <= monster_y_center;
            monster_x_motion <= 10'd0;
            monster_y_motion <= monster_y_step;
				is_used = 0;
				indi_type = 3'b000;
        end

		  else if (enable) begin
				is_used = 1;
				indi_type = Summon;
            monster_x_position <= monster_x_center;
            monster_y_position <= monster_y_center;
            monster_x_motion <= 10'd0;
            monster_y_motion <= monster_y_step;
				blood_value = 45;
		  end
		  
		  if (is_used) begin
            monster_x_position <= monster_x_position_in;
            monster_y_position <= monster_y_position_in;
            monster_x_motion <= monster_x_motion_in;
            monster_y_motion <= monster_y_motion_in;
		  end
		  if (damage!=8'h00 && timestamp % 50000000==0)
				blood_value = blood_value - damage;				
		  if (death) begin
				is_used = 1'b0;
				monster_x_position <= monster_x_center;
            monster_y_position <= monster_y_center;
            monster_x_motion <= 10'd0;
            monster_y_motion <= monster_y_step;
				indi_type = 3'b000;
		  end
    end
	 
    always_comb 
	 begin
		  if (blood_value<=0)
				death = 1'b1;
		  else
				death = 1'b0;
        monster_x_position_in = monster_x_position;
        monster_y_position_in = monster_y_position;
        monster_x_motion_in = monster_x_motion;
        monster_y_motion_in = monster_y_motion;
		  achieve = 1'b0;
        if (frame_clk_rising_edge) 
		  begin
				if (monster_x_position == 214 && monster_y_position ==240) begin
					monster_x_motion_in = (~(monster_x_step)+1'b1);
					monster_y_motion_in = 1'b0;
				end
				
				else if (monster_x_position == 114 && monster_y_position == 240) begin
					monster_x_motion_in = 1'b0;
					monster_y_motion_in = monster_y_step;
				end
				else if (monster_x_position == 114 && monster_y_position == 350) begin
					monster_x_motion_in = monster_x_step;
					monster_y_motion_in = 1'b0;
				end
				else if (monster_x_position == 500 && monster_y_position == 350) begin
					monster_x_motion_in = 1'b0;
					monster_y_motion_in = (~(monster_y_step)+1'b1);					
				end
				else if (monster_x_position == 500 && monster_y_position == 240) begin
					monster_x_motion_in = (~(monster_x_step)+1'b1);
					monster_y_motion_in = 1'b0;					
				end			
				else if (monster_x_position == 410 && monster_y_position == 240) begin
					monster_x_motion_in = 1'b0;
					monster_y_motion_in = (~(monster_y_step)+1'b1);		
				end
				else if (monster_x_position == 410 && monster_y_position == 120) begin
					achieve = 1'b1;
					monster_x_motion_in = 1'b0;
					monster_y_motion_in = 1'b0;
				end
				
				else begin
					monster_x_motion_in = monster_x_motion_in;
					monster_y_motion_in = monster_y_motion_in;
				end
			  monster_x_position_in = monster_x_position + monster_x_motion_in;
			  monster_y_position_in = monster_y_position + monster_y_motion_in;
		  end
    end
    
    int DistX, DistY, Size;
    assign DistX = DrawX - monster_x_position;
    assign DistY = DrawY - monster_y_position;
	 assign used_type = indi_type;
    always_comb begin
			if (DistX<=22 && DistX>=-22 && DistY<=22 && DistY>=-22 && is_used) begin
				offx = DistX;
				offy = DistY;
				occured_type = indi_type;
			end
			else if (DistX<=22 && DistX>=-22 && DistY<=-23 && DistY>=-33 && is_used && blood_value>=DistX+23) begin
				offx = DistX;
				offy = DistY;
				occured_type = 3'b111;
			end 
			else begin
				offx = 0;
				offy = 0;
				occured_type = 3'b000;
			end
    end

endmodule
