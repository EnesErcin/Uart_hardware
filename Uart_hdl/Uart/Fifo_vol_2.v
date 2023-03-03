

module Fifo_vol_2
#(parameter fifo_size = 6, parameter fifo_bit_len = 8)
(
input       [fifo_bit_len-1:0] Value_in,
output reg  [fifo_bit_len-1:0] Value_out,
input slow_clk,nreset,fast_clk,
output reg  empty_led,filled_led,
output reg [6:0] Counter_Display,

input [1:0]fifo_stage
);

reg [fifo_bit_len-1:0] Value_Bank[fifo_size-1:0];                       // Holds {fifo_size} amount of register which contains {fifo_bit_len} bits
localparam Idle                  =2'b00,
           Reading               =2'b01,
           Writing               =2'b10,
           Reading_Writing       =2'b11;

integer ii = 0;                                                             //For Counting number of inputs 
reg [3:0] counter = 0;

always @(posedge slow_clk) begin
	if(nreset == 0) begin
		 case(fifo_stage) 
			  Idle              :begin  
											empty_filled_check();
											Value_out <= 0;
										end
			  Reading           :begin
											 empty_filled_check();
											 if(counter != 0) begin
											 Value_Bank[fifo_size -1] <= 0;
											 shift_components_to_left();
											 Value_out <= Value_Bank[0];
											 counter <= counter - 1; end 
											 else 
											 Value_out  <= 0;
								 end
			  Writing           :begin 
											 empty_filled_check();
											 if(counter < fifo_size) begin
											 Value_Bank[counter] <= Value_in;
											 counter <= counter + 1; end 
										end
			  Reading_Writing   :begin    
												  filled_led  <= 0;           
												  empty_led   <= 0;                           
								 end
		 endcase
	end  else  begin
            counter     <= 0;
            filled_led  <= 0;           
			empty_led   <= 1;  
             for(ii = 0 ; ii <= fifo_size-1 ; ii = ii +1) begin
                  Value_Bank[ii] <= 0;            //Reseting all the register banks
             end 
	end
end

always  @(posedge fast_clk) begin
    counter_display();	
end


task empty_filled_check();
begin
        if(counter == 0) begin                filled_led  <= 0;           empty_led   <= 1;       end
        else if(counter == fifo_size) begin   filled_led  <= 1;           empty_led   <= 0;       end
        else  begin                      filled_led  <= 0;           empty_led   <= 0;       end
end endtask


task shift_components_to_left();
begin
    for(ii = 0 ; ii <= fifo_size-2 ; ii = ii +1) begin
        Value_Bank[ii] <= Value_Bank[ii +1] ;
    end
    //    Value_Bank[fifo_size -1] <= 0;
end endtask

task shift_components_to_right();
begin
    for(ii = 0 ; ii <= fifo_size-2 ; ii = ii +1) begin
        Value_Bank[ii+1] <= Value_Bank[ii] ;
    end
    //    Value_Bank[0] <= 0;
end endtask


task counter_display(); begin
case(counter)
4'd1:  begin   Counter_Display <= 7'h79;     end
4'd2:  begin   Counter_Display <= 7'h24;     end
4'd3:  begin   Counter_Display <= 7'h30;     end
4'd4:  begin   Counter_Display <= 7'h19;     end
4'd5:  begin   Counter_Display <= 7'h12;     end 
4'd6:  begin   Counter_Display <= 7'h2;      end 
4'd7:  begin   Counter_Display <= 7'h78;     end 
4'd0:  begin   Counter_Display <= 7'h40;     end 
default:begin  Counter_Display <= 7'h4f;     end 
endcase
end endtask


endmodule