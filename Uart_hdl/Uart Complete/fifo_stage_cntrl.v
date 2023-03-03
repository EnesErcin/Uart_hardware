`timescale 1ns / 1ps

module fifo_stage_cntrl(
output reg [1:0]fifo_stage,
output reg  [7:0]fifo_state_segs,
input clk,read_en,write_en,reset
    );
  
localparam Idle                  =2'b00,
           Reading               =2'b01,
           Writing               =2'b10,
           Reading_Writing       =2'b11;

  
always @(posedge clk) begin
	if(reset == 0)
    state_check();
	else begin
	fifo_stage <=  Idle ;      
	fifo_state_segs <=   7'h40;  
	end
end
    
task state_check();
begin
    if(write_en == 1 & read_en == 1)         begin           fifo_stage <=  Reading_Writing ;       fifo_state_segs <=   7'h30;     end
    else if(read_en  == 1 & write_en == 0)   begin           fifo_stage <=  Reading         ;       fifo_state_segs <=   7'h79;     end
    else if(write_en == 1 & read_en == 0)    begin           fifo_stage <=  Writing         ;       fifo_state_segs <=   7'h24;     end
    else                                     begin           fifo_stage <=  Idle            ;       fifo_state_segs <=   7'h40;     end
end endtask



endmodule
