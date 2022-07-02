//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( 	input        [9:0] 	DrawX, DrawY,       // Current pixel coordinates
								input			[23:0] 	data_Out_monster1, data_Out_monster2, data_Out_boss, 
															data_Out_background, data_Out_start, data_Out_map1, data_Out_fail, data_Out_tower1,
															data_Out_cab, data_Out_vict,
								input logic				is_open, is_game, is_vict, new_game,
								input logic	 [7:0]	display_type,
								input logic  [28:0]  timestamp,
								output logic [7:0] 	VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] 	Red, Green, Blue;
    logic [23:0]	DATA;
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    logic [28:0] remain;
	 
	 always_comb begin
	 	remain = timestamp % 50000000;
		case(display_type)
					8'h00: DATA = data_Out_background;
					8'h01: DATA = data_Out_start;
					8'h04: DATA = data_Out_monster1;
					8'h05: DATA = data_Out_monster2;
					8'h0f: DATA = data_Out_boss;
					8'h10: DATA = data_Out_tower1;
					8'h20: DATA = data_Out_fail;
					8'h21: DATA = 24'h555555;
					8'h30: DATA = 24'hff0000;
					8'h31: DATA = 24'hfff200;
					8'h32: DATA = 24'h50ff39;
					8'h33: DATA = data_Out_cab;
					8'h34: DATA = 24'hc3c3c3;
					8'h35: DATA = data_Out_vict;
					8'h36: DATA = 24'hb83dba;
					default: DATA = data_Out_background;
		endcase
		
		if (DATA == 24'hffffff)
			DATA = data_Out_background;
		Red = DATA[23:16]; 
		Green = DATA[15:8];
		Blue = DATA[7:0];			
	 end
	 
endmodule
