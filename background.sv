module  background
(
		input [9:0]		DrawX, DrawY,
		input 			Clk,
		input	[2:0]		level_index,
		output logic [23:0] data_Out_background
);

	always_ff @ (posedge Clk) 
	begin
		data_Out_background = 24'hffffff;
		if ((DrawX>=90&&DrawX<=140&&DrawY>=245&&DrawY<=375)||(DrawX>=120&&DrawX<=525&&DrawY>=325&&DrawY<=375)||(DrawX>=90&&DrawX<=210&&DrawY>=215&&DrawY<=265)||
			(DrawX>=190&&DrawX<=240&&DrawY>=110&&DrawY<=265)||(DrawX>=385&&DrawX<=495&&DrawY>=225&&DrawY<=265)||(DrawX>=475&&DrawX<=525&&DrawY>=225&&DrawY<=345)
			||(DrawX>=385&&DrawX<=435&&DrawY>=110&&DrawY<=245))
			data_Out_background = 24'h808080;
		else if (((DrawX-100)**2+DrawY**2<=2500) || ((DrawX-540)**2+DrawY**2<=2500) || (DrawX>=100 && DrawX<=540 && DrawY<=50))
			data_Out_background = 24'he9bf2f;
		else if (((DrawX-70)**2+DrawY**2<=6400) || ((DrawX-570)**2+DrawY**2<=6400) || (DrawX>=70 && DrawX<=570 && DrawY<=80))
			data_Out_background = 24'hfdeca6;
		else
			if (level_index==3'b001)
				data_Out_background = 24'hc0c0c0;
			else if (level_index==3'b010)
				data_Out_background = 24'h0ed145;
			else if (level_index==3'b000)
				data_Out_background = 24'ha6e0fd;
			else
				data_Out_background = data_Out_background;
	end
endmodule
