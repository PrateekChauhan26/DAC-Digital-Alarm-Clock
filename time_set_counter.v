`timescale 1ns / 1ps
module time_set_counter(
	input clk,reset,inc_min,inc_hr,show_alarm,show_time,
	input [15:0] time_data,alarm_data,
	output reg [15:0] set_data
    );
	 
	 always @(posedge clk , negedge reset)
		 begin
			if(!reset)
				set_data <= 0;
			else if(show_alarm)
				set_data <= alarm_data;
			else if(show_time)
				set_data <= time_data;
			else if(inc_min)
				begin
					if(set_data[15:12] == 4'b0010 && set_data[11:8] == 4'b0011 && set_data[7:4] == 4'b0101 && set_data[3:0] == 4'b1001) // 2 3 : 5 9 then 0 0 : 0 0
						begin 
							set_data[15:0] <= 16'h0000;
						end
					else if(set_data[11:8] == 4'b0011 && set_data[7:4] == 4'b0101 && set_data[3:0] == 4'b1001) // ? 3 : 5 9 ----- ?+1 0 : 0 0
						begin 
							set_data[15:12] <= set_data[15:12] + 1'b1;
							set_data[11:0] <= 1'b0;
						end
					else if(set_data[7:4] == 4'b0101 && set_data[3:0] == 4'b1001) // ? ? : 5 9 ------ ?  ?+1 : 0 0
						begin
							set_data[11:8] <= set_data[11:8] + 1'b1;
							set_data[7:0] <= 1'b0;
						end
					else if(set_data[3:0] == 4'b1001) // ? ? : ? 9 ------ ? ? : ?+1 0
						begin
							set_data[3:0] <= 1'b0;
							set_data[7:4] <= set_data[7:4] + 1'b1;
						end
						else
							set_data[3:0] <= set_data + 1'b1;   //HR:MN just increament N = N + 1
				end
			else if(inc_hr)
				begin
					if(set_data[15:12] == 4'b0010 && set_data[11:8] == 4'b0011)   // HR -- 2 3 --- make it 0 0 
						set_data[15:8] <= 8'h00;
					else if(set_data[11:8] == 4'b1001) // HR ---- ? 9 --- (?+1) 0
						begin
							set_data[11:8] <= 0;
							set_data[15:12] <= set_data[15:12] + 1'b1;	
						end
					else
						set_data[15:8] <= set_data[15:8] + 1'b1;
				end
			else
				set_data <= time_data;
				
		 end


endmodule