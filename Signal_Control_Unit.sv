module SCU (   	input logic				Clk, 
													Reset,
													Run,
													//Continue,
						input logic	[28:0]	timestamp,
						input logic				death,
						input logic [7:0]		keycode,
						
						output [2:0]			Summon,
						output logic			is_open,
													is_game,
													is_vict,
													is_fail,
						output [2:0]			level_index, round,
						output [3:0]			count_2,
						output [7:0]			command
						);
	
	enum logic [5:0] { 	Opening_scene, 
								Round1_1,
								Round1_2,
								Fail,
								Victory
						}   State, Next_state;   // Internal state logic
	int		count;
	logic		vict_sig;
//======================================================
	int timely_command;
	assign command  = timely_command;
	logic [7:0] time_seq1 [0:63];
	logic [7:0] time_seq2 [0:63];
	assign time_seq1 = '{8'h09,8'h00,8'h00,8'h00,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
								8'h09,8'h00,8'h00,8'h00,8'h01,8'h02,8'h02,8'h02,8'h02,8'h02,8'h02,8'h00,8'h00,8'h00,8'h00,8'h00,
								8'h09,8'h00,8'h00,8'h00,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
								8'h09,8'h00,8'h00,8'h00,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h00,8'h00,8'h00,8'h00,8'h00,8'h0a};
								
	assign time_seq2 = '{8'h09,8'h00,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
								8'h09,8'h00,8'h01,8'h01,8'h01,8'h02,8'h02,8'h02,8'h02,8'h02,8'h02,8'h00,8'h00,8'h00,8'h00,8'h00,
								8'h09,8'h00,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
								8'h09,8'h00,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h02,8'h02,8'h02,8'h02,8'h00,8'h0a};
	initial begin
		count = 0;
		Summon = 3'b000;
		level_index = 3'b000;
	end	
	

	always_comb begin
		if (level_index == 3'b001)
			timely_command = time_seq1[count];
		else if (level_index == 3'b010)
			timely_command = time_seq2[count];
		else
			timely_command = time_seq1[count];
	end
	assign count_2 = count % 8;
	
	always_ff @ (posedge Clk)
	begin
		if (Reset) begin
			State <= Opening_scene;
			count = -1;
			round = 3'b000;
			vict_sig = 1'b0;
		end
		else
			State <= Next_state;
			
		if (is_game == 1'b1 && timestamp % 50000000 == 0)
			count = count + 1;
		if (keycode==8'h2c)
			count = -1;
		
		if (timestamp % 50000000 == 1) begin
			case(timely_command)
				2'h00: begin
					Summon = 3'b000;
				end
				2'h01: begin
					Summon = 3'b001;
				end	
				2'h02: begin
					Summon = 3'b010;
				end
				2'h06: begin
					Summon = 3'b110;
				end
				2'h09: begin
					Summon = 3'b000;
					round = round+1;
				end
				2'h0a: begin
					Summon = 3'b000;
					vict_sig = 1'b1;
				end
				default: begin 
					Summon = 3'b000;
					vict_sig = 1'b0;
				end
					
			endcase
		end
		else begin
			Summon = 3'b000;
			vict_sig = 1'b0;
		end

	end
	
	always_comb begin
		is_open = 1'b0;
		is_game = 1'b0;
		is_vict = 1'b0;
		is_fail = 1'b0;
		
		Next_state = State;
		unique case (State)
			Opening_scene :
				begin
					if (Run) 
						Next_state = Round1_1;
				end
			Round1_1 :
				begin
					if (vict_sig || count == 200 || timely_command == 8'h0a)
						Next_state = Victory;
					if (death==1'b1)
						Next_state = Fail;
				end
			Round1_2 :
				begin
					if (vict_sig || count == 200 || timely_command == 8'h0a)
						Next_state = Victory;
					if (death==1'b1)
						Next_state = Fail;
				end
			Victory :
				begin
					if (Reset)
						Next_state = Opening_scene;
					else if (keycode == 8'h2c)
						Next_state = Round1_2;
					else if (keycode == 8'h50)
						Next_state = Round1_1;
					else
						Next_state = Victory;
				end
			
			Fail :
				begin
					if (Reset || keycode == 8'h2c)
						Next_state = Opening_scene;					
				end
			default : ;
		endcase		
		
		// Assign control signals based on current state
		case (State)
			Opening_scene:
				begin
					is_open = 1'b1;
					is_game = 1'b0;
					is_vict = 1'b0;
					is_fail = 1'b0;
					level_index = 3'b000;
				end
				
			Round1_1 :
				begin
					is_open = 1'b0;
					is_game = 1'b1;
					is_vict = 1'b0;
					is_fail = 1'b0;
					level_index = 3'b001;
				end
			Round1_2 :
				begin
					is_open = 1'b0;
					is_game = 1'b1;
					is_vict = 1'b0;
					is_fail = 1'b0;
					level_index = 3'b010;
				end
				
			Victory :
				begin
					is_open = 1'b0;
					is_game = 1'b0;
					is_vict = 1'b1;
					is_fail = 1'b0;
					level_index = 3'b111;
				end
			Fail :
				begin
					is_open = 1'b0;
					is_game = 1'b0;
					is_vict = 1'b0;
					is_fail = 1'b1;
					level_index = 3'b110;
				end
			default:;
		endcase
	end 
	
endmodule
