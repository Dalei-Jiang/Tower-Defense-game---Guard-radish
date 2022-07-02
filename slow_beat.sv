module slow_beat(	input 	Clk, 
									Reset,
									is_game, is_open,
						output 	[28:0] timestamp		// 1s period
					);
	 
		 initial timestamp=29'b0;
		 
		 always@(posedge Clk or posedge Reset)
		 begin
				if(Reset)
					timestamp<=0;
				else if(timestamp==500000001)
					timestamp<=0;
				else if (is_game)
					timestamp<=(timestamp+1);
				else
					timestamp<=timestamp;
		 end
endmodule
