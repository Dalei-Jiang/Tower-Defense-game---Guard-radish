module score (
		input [15:0] used_array,
		input [7:0]  fi_used_array,
		input Reset, Clk,
		output int score
);
	logic [15:0] timely_mons;
	logic [7:0] timely_tower;
	int score_time;
	assign score = score_time;
	initial begin
		timely_mons = 16'h0;
		timely_tower = 8'b0;
		score = 100;
	end
	always_ff @ (posedge Clk) begin
		if (Reset) begin
			timely_mons = 16'h0;
			timely_tower = 8'b0;
			score_time = 100;
		end
		else if (used_array > timely_mons) begin
			timely_mons = used_array;
		end
		else if (used_array < timely_mons) begin
			timely_mons = used_array;
			score_time = score_time + 10;
		end
		else if (fi_used_array < timely_tower) begin
			timely_tower = fi_used_array;
			score_time = score_time + 20;
		end
		else if (fi_used_array > timely_tower) begin
			timely_tower = fi_used_array;
			score_time = score_time - 30;
		end		
	end
endmodule
