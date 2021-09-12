`timescale 1ns / 1ps
module led_driver(
	input  half_second , reset , sound_alarm ,
	output reg led_output
    );
	 
	 always@(posedge half_second , negedge reset)
		begin
			if(!reset)
				led_output <= 1'b0;
			else if(sound_alarm == 0)
				led_output <= 1'b0;
			else
				led_output <= ~led_output; 
		end

endmodule