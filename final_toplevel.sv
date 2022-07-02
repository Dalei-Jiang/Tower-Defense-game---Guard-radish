//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module final_toplevel( input     CLOCK_50,         
				 output logic [11:0] LED,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
				 output logic [7:0]  LEDG,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
											VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );

		
	logic				new_game, death, blood_minus;
	logic [2:0]		monster_occur;
	int				offset_x, offset_y;
	logic [2:0] 	Summon;
	logic				slow_clk, more_slow_clk;
	logic				is_open, is_game, is_vict, is_fail;
	logic [23:0]	data_In;
	logic [18:0]	write_address;
	logic [18:0]	read_address;
	logic 			we;
	logic [23:0]	data_Out_monster1, data_Out_monster2, 
						data_Out_boss, data_Out_background, data_Out_start, 
						data_Out_map1, data_Out_fail, data_Out_tower1, data_Out_cab, data_Out_vict;
	logic [15:0]	used_array;
	logic [15:0]	achieve_array;
	
	logic [3:0]		status;
	logic [3:0]		count_1, count_2;
	
	int		offsetx, offsety;
	logic				achieve;
	assign status = {is_fail,is_vict,is_game,is_open};
	logic [7:0]		command;
	
	int score;
	int		offx_array[0:15]; 
	int		offy_array[0:15];
	logic [2:0]		occur_array[0:15];
	logic [2:0]		type_array[0:15];
	logic [2:0]		Summon_array[0:15];
	
	logic [15:0]	enable_array;
	logic [7:0]		display_type;
	logic [28:0]	timestamp;
	
	logic Continue, Reset, Run, Clk;
	logic [2:0]		level_index, round;
	logic [7:0] led;
	logic [23:0] data_Out;
	assign led = status;
	int	 achieve_monsters, counter;
	logic [2:0] max_occur;
	initial 
		max_occur = 3'b0;
	
	
	assign we = 1'b0;
	assign data_In = 10'b0;
	assign write_address = 19'b0;
	assign Clk = CLOCK_50;

	logic command_tw;
	logic build, sell;
	logic [2:0] build_location;
	logic [2:0] build_type;
	logic [7:0] fi_used_array;
	logic [7:0] print_array;
	logic [2:0] fi_occur_type[0:7];
	logic [7:0] toi_enable_array;
	logic [2:0] toi_type_array[0:7];
	logic [7:0] toi_sell_array;
	logic [2:0] print_type;
	int  offset_towerx, offset_towery;
	int  offsetx_array[0:7];
	int  offsety_array[0:7];
//===============================================================================================	

// display shows the type of items occupying current pixel.
//		00:	Background
//		01:	Start button
//		02:	Victory character
//		03:	Fail character
//		04:	Monster 1
//		05:	Monster 2
//		0f:	Little boss
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 logic [7:0] keycode;
//===============================================================================================
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );

//=====================================================================================

	logic [9:0] DrawX, DrawY;
	
	always_ff @ (posedge Clk) begin
		Reset <= KEY[0];        // The push buttons are active low
		Run <= KEY[1];
		Continue <= KEY[2];
		LEDG <= led;
		
		if (Summon != 3'b000)
			count_1 = count_1 + 1;
		if (monster_occur > max_occur)
			max_occur = monster_occur;
	end

	assign Reset_ah = ~Reset;
	assign Continue_ah = ~Continue;
	assign Run_ah = ~Run;
	
	slow_beat beat(.*, .Reset(Reset_ah));
	GPU gpu(.*);
	logic[7:0] x_pos1,x_pos2,x_pos3,x_pos4,x_pos5,x_pos6,x_pos7,x_pos8,x_pos9,x_pos10,x_pos11,x_pos12,x_pos13,x_pos14,x_pos15,x_pos16;
	
	monster_individual mon000(.*, .Reset(Reset_ah), .x_pos(x_pos1), .frame_clk(VGA_VS), .Summon(Summon_array[0]), .enable(enable_array[0]), .offx(offx_array[0]), .offy(offy_array[0]), .is_used(used_array[0]), .occured_type(occur_array[0]), .achieve(achieve_array[0]), .used_type(type_array[0]));
	monster_individual mon001(.*, .Reset(Reset_ah), .x_pos(x_pos2), .frame_clk(VGA_VS), .Summon(Summon_array[1]), .enable(enable_array[1]), .offx(offx_array[1]), .offy(offy_array[1]), .is_used(used_array[1]), .occured_type(occur_array[1]), .achieve(achieve_array[1]), .used_type(type_array[1]));
	monster_individual mon002(.*, .Reset(Reset_ah), .x_pos(x_pos3), .frame_clk(VGA_VS), .Summon(Summon_array[2]), .enable(enable_array[2]), .offx(offx_array[2]), .offy(offy_array[2]), .is_used(used_array[2]), .occured_type(occur_array[2]), .achieve(achieve_array[2]), .used_type(type_array[2]));
	monster_individual mon003(.*, .Reset(Reset_ah), .x_pos(x_pos4), .frame_clk(VGA_VS), .Summon(Summon_array[3]), .enable(enable_array[3]), .offx(offx_array[3]), .offy(offy_array[3]), .is_used(used_array[3]), .occured_type(occur_array[3]), .achieve(achieve_array[3]), .used_type(type_array[3]));
	monster_individual mon004(.*, .Reset(Reset_ah), .x_pos(x_pos5), .frame_clk(VGA_VS), .Summon(Summon_array[4]), .enable(enable_array[4]), .offx(offx_array[4]), .offy(offy_array[4]), .is_used(used_array[4]), .occured_type(occur_array[4]), .achieve(achieve_array[4]), .used_type(type_array[4]));
	monster_individual mon005(.*, .Reset(Reset_ah), .x_pos(x_pos6), .frame_clk(VGA_VS), .Summon(Summon_array[5]), .enable(enable_array[5]), .offx(offx_array[5]), .offy(offy_array[5]), .is_used(used_array[5]), .occured_type(occur_array[5]), .achieve(achieve_array[5]), .used_type(type_array[5]));
	monster_individual mon006(.*, .Reset(Reset_ah), .x_pos(x_pos7), .frame_clk(VGA_VS), .Summon(Summon_array[6]), .enable(enable_array[6]), .offx(offx_array[6]), .offy(offy_array[6]), .is_used(used_array[6]), .occured_type(occur_array[6]), .achieve(achieve_array[6]), .used_type(type_array[6]));
	monster_individual mon007(.*, .Reset(Reset_ah), .x_pos(x_pos8), .frame_clk(VGA_VS), .Summon(Summon_array[7]), .enable(enable_array[7]), .offx(offx_array[7]), .offy(offy_array[7]), .is_used(used_array[7]), .occured_type(occur_array[7]), .achieve(achieve_array[7]), .used_type(type_array[7]));
	monster_individual mon008(.*, .Reset(Reset_ah), .x_pos(x_pos9), .frame_clk(VGA_VS), .Summon(Summon_array[8]), .enable(enable_array[8]), .offx(offx_array[8]), .offy(offy_array[8]), .is_used(used_array[8]), .occured_type(occur_array[8]), .achieve(achieve_array[8]), .used_type(type_array[8]));
	monster_individual mon009(.*, .Reset(Reset_ah), .x_pos(x_pos10), .frame_clk(VGA_VS), .Summon(Summon_array[9]), .enable(enable_array[9]), .offx(offx_array[9]), .offy(offy_array[9]), .is_used(used_array[9]), .occured_type(occur_array[9]), .achieve(achieve_array[9]), .used_type(type_array[9]));
	monster_individual mon010(.*, .Reset(Reset_ah), .x_pos(x_pos11), .frame_clk(VGA_VS), .Summon(Summon_array[10]), .enable(enable_array[10]), .offx(offx_array[10]), .offy(offy_array[10]), .is_used(used_array[10]), .occured_type(occur_array[10]), .achieve(achieve_array[10]), .used_type(type_array[10]));
	monster_individual mon011(.*, .Reset(Reset_ah), .x_pos(x_pos12), .frame_clk(VGA_VS), .Summon(Summon_array[11]), .enable(enable_array[11]), .offx(offx_array[11]), .offy(offy_array[11]), .is_used(used_array[11]), .occured_type(occur_array[11]), .achieve(achieve_array[11]), .used_type(type_array[11]));
	monster_individual mon012(.*, .Reset(Reset_ah), .x_pos(x_pos13), .frame_clk(VGA_VS), .Summon(Summon_array[12]), .enable(enable_array[12]), .offx(offx_array[12]), .offy(offy_array[12]), .is_used(used_array[12]), .occured_type(occur_array[12]), .achieve(achieve_array[12]), .used_type(type_array[12]));	
	monster_individual mon013(.*, .Reset(Reset_ah), .x_pos(x_pos14), .frame_clk(VGA_VS), .Summon(Summon_array[13]), .enable(enable_array[13]), .offx(offx_array[13]), .offy(offy_array[13]), .is_used(used_array[13]), .occured_type(occur_array[13]), .achieve(achieve_array[13]), .used_type(type_array[13]));
	monster_individual mon014(.*, .Reset(Reset_ah), .x_pos(x_pos15), .frame_clk(VGA_VS), .Summon(Summon_array[14]), .enable(enable_array[14]), .offx(offx_array[14]), .offy(offy_array[14]), .is_used(used_array[14]), .occured_type(occur_array[14]), .achieve(achieve_array[14]), .used_type(type_array[14]));
	monster_individual mon015(.*, .Reset(Reset_ah), .x_pos(x_pos16), .frame_clk(VGA_VS), .Summon(Summon_array[15]), .enable(enable_array[15]), .offx(offx_array[15]), .offy(offy_array[15]), .is_used(used_array[15]), .occured_type(occur_array[15]), .achieve(achieve_array[15]), .used_type(type_array[15]));	
//=========================================================================

	monster_array monsterarray(.*, .Reset(Reset_ah));
	score sc(.*);
	Cabbage cabbage(.*);
					
	SCU scu(.*, .Run(Run_ah), .Reset(Reset_ah));
//==========================================
	monster1RAM monster1ram(.*);
	monster2RAM	monster2ram(.*);
	little_bossRAM	little_bossram(.*);
	startRAM startram(.*);
	mapRAM mapram(.*);
	failRAM failram(.*);
	tower1RAM tower1ram(.*);
	cabbabyRAM cabbabyram(.*);
	victoryRAM victoryram(.*);
	
	background bg(.*);
//=============================================
	tower_individual tower1(.*, .Reset(Reset_ah), .enable(toi_enable_array[0]), .sell(toi_sell_array[0]), .x_lu(130), .y_ru(377), .type_com(toi_type_array[0]), .occur_type(fi_occur_type[0]), .is_used(fi_used_array[0]), .is_print(print_array[0]), .off_x(offsetx_array[0]), .off_y(offsety_array[0]));
	tower_individual tower2(.*, .Reset(Reset_ah), .enable(toi_enable_array[1]), .sell(toi_sell_array[1]), .x_lu(180), .y_ru(377), .type_com(toi_type_array[1]), .occur_type(fi_occur_type[1]), .is_used(fi_used_array[1]), .is_print(print_array[1]), .off_x(offsetx_array[1]), .off_y(offsety_array[1]));
	tower_individual tower3(.*, .Reset(Reset_ah), .enable(toi_enable_array[2]), .sell(toi_sell_array[2]), .x_lu(230), .y_ru(377), .type_com(toi_type_array[2]), .occur_type(fi_occur_type[2]), .is_used(fi_used_array[2]), .is_print(print_array[2]), .off_x(offsetx_array[2]), .off_y(offsety_array[2]));
	tower_individual tower4(.*, .Reset(Reset_ah), .enable(toi_enable_array[3]), .sell(toi_sell_array[3]), .x_lu(330), .y_ru(377), .type_com(toi_type_array[3]), .occur_type(fi_occur_type[3]), .is_used(fi_used_array[3]), .is_print(print_array[3]), .off_x(offsetx_array[3]), .off_y(offsety_array[3]));
	tower_individual tower5(.*, .Reset(Reset_ah), .enable(toi_enable_array[4]), .sell(toi_sell_array[4]), .x_lu(380), .y_ru(377), .type_com(toi_type_array[4]), .occur_type(fi_occur_type[4]), .is_used(fi_used_array[4]), .is_print(print_array[4]), .off_x(offsetx_array[4]), .off_y(offsety_array[4]));
	tower_individual tower6(.*, .Reset(Reset_ah), .enable(toi_enable_array[5]), .sell(toi_sell_array[5]), .x_lu(430), .y_ru(377), .type_com(toi_type_array[5]), .occur_type(fi_occur_type[5]), .is_used(fi_used_array[5]), .is_print(print_array[5]), .off_x(offsetx_array[5]), .off_y(offsety_array[5]));
	tower_individual tower7(.*, .Reset(Reset_ah), .enable(toi_enable_array[6]), .sell(toi_sell_array[6]), .x_lu(140), .y_ru(165), .type_com(toi_type_array[6]), .occur_type(fi_occur_type[6]), .is_used(fi_used_array[6]), .is_print(print_array[6]), .off_x(offsetx_array[6]), .off_y(offsety_array[6]));
	tower_individual tower8(.*, .Reset(Reset_ah), .enable(toi_enable_array[7]), .sell(toi_sell_array[7]), .x_lu(435), .y_ru(165), .type_com(toi_type_array[7]), .occur_type(fi_occur_type[7]), .is_used(fi_used_array[7]), .is_print(print_array[7]), .off_x(offsetx_array[7]), .off_y(offsety_array[7]));

	tower_array towerarray(.*, .Reset(Reset_ah));
	kb_interface kb_inter(.*);
//==========================================
	
	HexDriver hex_inst_0 (score%10, HEX0);
	HexDriver hex_inst_1 ((score/10)%10, HEX1);
	HexDriver hex_inst_2 (score/100, HEX2);
	HexDriver hex_inst_3 (4'b0000, HEX3);
	HexDriver hex_inst_4 (used_array[3:0], HEX4);
	HexDriver hex_inst_5 (used_array[3:0], HEX5);
	HexDriver hex_inst_6 (used_array[7:4], HEX6);
//	HexDriver hex_inst_7 ([3:0], HEX7);



	// Use PLL to generate the 25MHZ VGA_CLK.
	// You will have to generate it on your own in simulation.
	vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

	VGA_controller vga_controller_instance(.*, 
													 .Reset(Reset_ah),);
	color_mapper color_instance(.*); // ".*" means that all the ports' names and the variable names they connects are the same

//	always_comb
//    begin
//	   // default case
//	   led = 8'b0000;
//		case(keycode)
//					// key A, use h04 to represent
//					8'h04: 
//					begin
//						led = 8'b0010;
//					end
//							
//					// key D, use h07 to represent
//					8'h07: 
//					begin
//						led = 8'b0001;
//					end
//					
//					// key W, use h1a to represent
//					8'h1a: 
//					begin
//						led = 8'b1000;
//					end
//					
//					// key S, use h16 to represent
//					8'h16: 
//					begin
//						led = 8'b0100;
//					end
//					default:;
//					// The sequence of the LED will be WSAD.
//		endcase
//    end

endmodule 
