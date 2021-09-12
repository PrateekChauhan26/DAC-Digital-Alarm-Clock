`timescale 1ns / 1ps
module controller_fsm(
	input clk, reset, AL, HR, MN,	//AL = alarm_button_debounced, HR = hour_button_debounced, MN = minute_button_debunced
	output reg show_time, load_time, show_alarm, load_alarm, increment_hour, increment_min
	);
	
	reg [2:0] state;
	reg [2:0] next_state;
	
	parameter SHOW_TIME = 3'd0, INC_TI_HR = 3'd1, INC_TI_MN = 3'd2, SET_TIME = 3'd3,
				 SHOW_ALARM = 3'd4, INC_AL_HR = 3'd5, INC_AL_MN = 3'd6, SET_ALARM = 3'd7;
				
	always@(state, AL, HR, MN)
		case (state)
				SHOW_TIME : begin 
										case({AL,HR,MN})
											3'b100 : next_state = SHOW_ALARM;
											3'b010 : next_state = INC_TI_HR;
											3'b001 : next_state = INC_TI_MN;
											default :next_state = SHOW_TIME;
										endcase
										show_time = 1; load_time = 0; show_alarm = 0; load_alarm = 0; increment_hour = 0; increment_min = 0;
								end
				
				INC_TI_HR : begin 
										next_state = HR ? INC_TI_HR : SET_TIME;
										show_time = 0; load_time = 0; show_alarm = 0; load_alarm = 0; increment_hour = 1; increment_min = 0;
								end
								
				INC_TI_MN :	begin 
										next_state = MN ? INC_TI_MN : SET_TIME;
										show_time = 0; load_time = 0; show_alarm = 0; load_alarm = 0; increment_hour = 0; increment_min = 1;
								end
								
				SET_TIME : begin 
										next_state = SHOW_TIME;
										show_time = 0; load_time = 1; show_alarm = 0; load_alarm = 0; increment_hour = 0; increment_min = 0;
							  end
				
				SHOW_ALARM : begin 
										case({~AL,HR,MN})
											3'B100 : next_state = SHOW_TIME;
											3'B010 : next_state = INC_AL_HR;
											3'B001 : next_state = INC_AL_MN;
											default : next_state = SHOW_ALARM;
										endcase
									
										show_time = 0; load_time = 0; show_alarm = 1; load_alarm = 0; increment_hour = 0; increment_min = 0;
								end
								
				INC_AL_HR : begin 
										next_state = HR ? INC_AL_HR : SET_ALARM;
										show_time = 0; load_time = 0; show_alarm = 0; load_alarm = 0; increment_hour = 1; increment_min = 0;
								end
								
				INC_AL_MN : begin 
										next_state = MN ? INC_AL_MN : SET_ALARM;
										show_time = 0; load_time = 0; show_alarm = 0; load_alarm = 0; increment_hour = 0; increment_min = 1;
								end
								
				SET_ALARM : begin 
										next_state = SHOW_ALARM;
										show_time = 0; load_time = 0; show_alarm = 0; load_alarm = 1; increment_hour = 0; increment_min = 0;
								end
								
				default : begin 
										next_state = SHOW_TIME;
										show_time = 0; load_time = 0; show_alarm = 0; load_alarm = 0; increment_hour = 0; increment_min = 0;
							 end
		endcase
		
	always@(posedge clk, negedge reset)
		if(!reset)
			state <= SHOW_TIME;
		else
			state <= next_state;

endmodule