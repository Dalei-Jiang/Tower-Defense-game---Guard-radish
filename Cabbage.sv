module Cabbage(input logic		Clk, 
										Run,
										Reset,
					input  int		achieve_monsters,
					output logic	death
					);
					
	int blood_value = 10;
	always_ff @ (posedge Clk)
	begin
		if (Reset) begin
			blood_value = 10;
			death = 1'b0;
		end
		if (blood_value <= achieve_monsters)
			death = 1'b1;
		else
			death = 1'b0;
	end

endmodule
					