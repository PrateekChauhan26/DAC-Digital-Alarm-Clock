`timescale 1ns / 1ps
module pulse_generator(
	input clk , reset,
	output reg half_second =0,
	output reg one_minute = 0
   );
	
	reg [23:0] count_clock = 0;
	reg [18:0] count_clock_min =0;
	
	always@(posedge clk , negedge reset)
		begin
			if(!reset)
				begin
					half_second = 0;
					count_clock = 0;
				end
			else if(count_clock == 12500000)  // for 50Mhz FPGA Clock (50*10^6*(1/2)(for posedge)*(1/2)(for half second)) = 125*10^5;
				begin
					half_second = ~half_second;
					count_clock = 0;
				end
			else
				begin
					count_clock = count_clock + 1;
					half_second = half_second;
				end
		
		end
		always@(posedge clk , negedge reset)
		begin
			if(!reset)
				begin
					one_minute = 0;
					count_clock_min = 0;
				end
			else if(count_clock_min == 416667)  // for 50Mhz FPGA Clock (50*10^6*(1/2)(for posedge)*(60)(for half second)) = 4166666.6666;
				begin
					one_minute = ~one_minute;
					count_clock_min = 0;
				end
			else
				begin
					count_clock_min = count_clock_min + 1; 
					one_minute = one_minute;
				end
		
		end


endmodule