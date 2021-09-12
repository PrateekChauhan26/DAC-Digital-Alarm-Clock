`timescale 1ns / 1ps
module time_counter(
	input clk , reset , load_time , one_minute , 
	input [15:0] set_data,
	output reg [15:0] time_data
);

always@(posedge clk , negedge reset)
begin
	if(!reset)
		begin
			time_data <= 16'd0;
		end
	else if(load_time)
		time_data <= set_data;
	else if(one_minute)
		begin
			if(time_data[15:12] == 4'b0010 && time_data[11:8] == 4'b0011 && time_data[7:4] == 4'b0101 && time_data[3:0] == 4'b1001) // 2 3 : 5 9 then 0 0 : 0 0
				begin 
					time_data[15:0] <= 16'h0000;
				end
			else if(time_data[11:8] == 4'b0011 && time_data[7:4] == 4'b0101 && time_data[3:0] == 4'b1001) // ? 3 : 5 9 ----- ?+1 0 : 0 0
				begin 
					time_data[15:12] <= time_data[15:12] + 1'b1;
					time_data[11:0] <= 1'b0;
				end
			else if(time_data[7:4] == 4'b0101 && time_data[3:0] == 4'b1001) // ? ? : 5 9 ------ ?  ?+1 : 0 0
				begin
					time_data[11:8] <= time_data[11:8] + 1'b1;
					time_data[7:0] <= 1'b0;
				end
			else if(time_data[3:0] == 4'b1001) // ? ? : ? 9 ------ ? ? : ?+1 0
				begin
					time_data[3:0] <= 1'b0;
					time_data[7:4] <= time_data[7:4] + 1'b1;
				end
				else
					time_data[3:0] <= time_data + 1'b1;   //HR:MN just increament N = N + 1
			end
		else
			time_data <= time_data;
end


endmodule