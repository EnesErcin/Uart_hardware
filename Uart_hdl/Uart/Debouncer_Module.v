`timescale 1ns / 1ps
                                                                    //Upgraded Debouncer
                                                                    // Butos should sart with 0 initially val_hold
module Debouncer_Module

    (
    input test_button,dvd_clk,
    output reg wire_button= 0
);

integer count_down = 0;

localparam test_bench_howmanyclk = 5,
			  synthesis_howmanyclk  = 5*10**6;
			  
			  
localparam howmanyclk =  synthesis_howmanyclk;


reg state_reg = 0;

always @(posedge dvd_clk) begin
	
	case(state_reg)
		1'b0: begin
		if(test_button == 1'b1) begin
		count_down <= 0;
		state_reg <= 1; end
		end
		
		1'b1: begin
			if(test_button == 1'b1) begin
				if(count_down != howmanyclk)
				count_down <= count_down + 1;
				else
				wire_button <= 1;
			end else begin 
			state_reg <= 0;
			wire_button <= 0;
			end
		end
	endcase
end
endmodule
