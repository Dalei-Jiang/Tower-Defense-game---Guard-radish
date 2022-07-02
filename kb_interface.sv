module kb_interface (
		input logic [7:0] keycode,
		input			 	Clk,
		output		 	command_tw,
		output			build, sell,
		output [2:0]	build_type,
		output [2:0] 	build_location
);
		logic [7:0] time_command;
		logic [2:0] timely_type, timely_location;
		assign build_type = timely_type;
		assign build_location = timely_location;
		initial begin
			time_command = 8'h00;
			build_location = 3'b000;
			build_type = 3'b000;
			build = 1'b0;
			sell = 1'b0;
		end
		
		always_ff @ (posedge Clk) begin
			if (keycode != time_command)
				time_command = keycode;
				
			if (time_command == 8'h28)
				command_tw = 1'b1;
			else 
				command_tw = 1'b0;
			if (time_command == 8'h2e) begin
				build = 1'b1;
				sell = 1'b0;
			end
			else if (time_command == 8'h2d) begin
				build = 1'b0;
				sell = 1'b1;				
			end
			else begin
				build = build;
				sell = sell;
			end
			
			case (time_command)
				8'h1e: begin
					timely_location = 3'b000;
				end
				8'h1f: begin
					timely_location = 3'b001;
				end
				8'h20: begin
					timely_location = 3'b010;
				end
				8'h21: begin
					timely_location = 3'b011;
				end
				8'h22: begin
					timely_location = 3'b100;
				end
				8'h23: begin
					timely_location = 3'b101;
				end
				8'h24: begin
					timely_location = 3'b110;
				end
				8'h25: begin
					timely_location = 3'b111;
				end
				default: begin
					timely_location = timely_location;	
				end
			endcase
			
			case (time_command)
				8'h04: begin
					timely_type = 3'b001;
				end
				8'h05: begin
					timely_type = 3'b010;
				end
				8'h06: begin
					timely_type = 3'b011;
				end
				default: begin
					timely_type = timely_type;
				end
			endcase
		end

endmodule
