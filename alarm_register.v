`timescale 1ns / 1ps
module alarm_register(
	input [15:0] set_data,
	input load_alarm,clk,reset,
	output reg [15:0] alarm_data
  );
	 
	 always@(posedge clk , negedge reset)
	 begin
		if (!reset)
			alarm_data <= 0;
		else if (load_alarm)
			alarm_data <= set_data;
		else
			alarm_data <= 0;
	 end
endmodule