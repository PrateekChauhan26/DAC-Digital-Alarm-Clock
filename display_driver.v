`timescale 1ns / 1ps
module display_driver(
    input [15:0] alarm_data,
	 input [15:0] time_data,
	 input [15:0] set_data,
	 input show_alarm , show_time ,alarm_on_button_debounced,
	 output reg sound_alarm,
	 output reg [27:0] segment_data
	 );
	 
	 reg [15:0] display_data;

//DATA TO BE DISPLAYED IS DECIDED	 
always@(alarm_data , show_alarm , time_data , show_time , set_data)
	begin
		if(show_time)
			display_data = time_data;
		else if(show_alarm)
			display_data = alarm_data;
		else
			display_data = set_data;
	end

//SETTING THE SOUND ON/OFF DEPENDING ON ALARM BUTTON	
always@(alarm_on_button_debounced , alarm_data , time_data)
	begin
		if(alarm_on_button_debounced)
			sound_alarm = (alarm_data == time_data) ? 1'b1 : 1'b0;
		else
			sound_alarm = 1'b0;
	end

//CONVERTING THE 16 BIT DATA (HR:MN 4X4 BITS) TO 28 BITS DATA (7*4 BITS(HR:MN 7 BITS EACH)) FOR THE SEVEN SEGMENT DISPLAY
//FUNCTION TO CONVERT IT
function [6:0] convert_to_7segement;
input [3:0] display_data_in;
	case(display_data_in)
				4'd0 : convert_to_7segement = 7'b0000001;
				4'd1 : convert_to_7segement = 7'b1001111;
				4'd2 : convert_to_7segement = 7'b0010010;
				4'd3 : convert_to_7segement = 7'b0000110;
				4'd4 : convert_to_7segement = 7'b1001100;
				4'd5 : convert_to_7segement = 7'b0100100;
				4'd6 : convert_to_7segement = 7'b1100000;
				4'd7 : convert_to_7segement = 7'b0001111;
				4'd8 : convert_to_7segement = 7'b0000000;
				4'd9 : convert_to_7segement = 7'b0001100;
				default : convert_to_7segement = 7'b1111111;
	endcase
endfunction

//CONVERTING DATA IN 28 BITS FOR 7SEGEMNT
always@(display_data)
	begin
		segment_data[6:0] = convert_to_7segement(display_data[3:0]);
		segment_data[13:7] = convert_to_7segement(display_data[7:4]);
		segment_data[20:14] = convert_to_7segement(display_data[11:8]);
		segment_data[27:21] = convert_to_7segement(display_data[15:12]);
	end

endmodule