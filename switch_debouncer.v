`timescale 1ns / 1ps
module switch_debouncer(
	input half_second , switch,   //using fast clock
	output reg switch_debounced
);
	parameter Idle = 3'd0, detect_1 = 3'd1, detect_2 = 3'd2, detect_3 = 3'd3, detect_4 = 3'd4, detect_5 = 3'd5, detect_6 = 3'd6, detect_7 = 3'd7;
	reg [2:0] state;

	always@(posedge half_second)
		begin
			
			case(state)
				Idle : if (switch==1'b1) //CHECKING FOR PRESSING OF SWITCH FOR 4 STATES
							begin
								state = detect_1;
								switch_debounced= 0;
							end
						else
							begin
								state = Idle;
								switch_debounced= 0;
							end
				
				detect_1 : if (switch==1'b1)
								begin
									state = detect_2;
									switch_debounced= 0;
								end
							  else
								begin
									state = Idle;
									switch_debounced= 0;
								end
				
				detect_2 : if (switch==1'b1)
								begin
									state = detect_3;
									switch_debounced= 0;
								end
							  else
								begin
									state = Idle;
									switch_debounced= 0;
								end
				
				detect_3 : if (switch==1'b1)
								begin
									state = detect_4;
									switch_debounced= 0;
								end
							  else
								begin
									state = Idle;
									switch_debounced= 0;
								end
								
				detect_4 : if (switch==1'b0) //CHECKING FOR RELEASE OF SWITCH FOR 4 STATES
								begin
									state = detect_5;
									switch_debounced= 0;
								end
							  else
								begin
									state = Idle;
									switch_debounced= 0;
								end
								
				detect_5 : if (switch==1'b0)
								begin
								state = detect_6;
								switch_debounced= 0;
								end
								else
								begin
								state = Idle;
								switch_debounced= 0;
								end
								
				detect_6 : if (switch==1'b0)
								begin
								state = detect_7;
								switch_debounced= 0;
								end
								else
								begin
								state = Idle;
								switch_debounced= 0;
								end
								
				detect_7 : if (switch==1'b0)  
								begin
								state = detect_7;
								switch_debounced = 1; //SWITCH WAS PRESSED AND THEN RELEASED HENCE CONDITION IS TRUE(DETECTED)
								end
								else
								begin
								state = Idle;
								switch_debounced= 0;
								end
				default:
						begin
						state=Idle;
						switch_debounced= 0;
						end
			endcase
		end

endmodule