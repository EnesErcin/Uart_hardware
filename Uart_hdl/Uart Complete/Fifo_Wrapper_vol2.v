`timescale 1ns / 1ps

module Fifo_Wrapper_vol2
#(parameter fifo_size = 5, parameter fifo_bit_len = 3)
(
input nwrite_en,nread_en,nreset_button,
input clk_fpga,

input  [fifo_bit_len-1:0]  Value_in,
output [fifo_bit_len-1:0]  Value_out,
output [6:0]fifo_state_segs,
output [6:0]Counter_Display,
output empty_led,filled_led
    );
    
wire [1:0] fifo_stage_wire;
wire slow_clk;
wire clk;
assign clk = clk_fpga;

wire nrst ; assign nrst = nreset_button ;

Contorller_Wrapper  Stage_CNRTL(
.nwrite_en(nwrite_en) ,
.nread_en(nread_en) ,
.internal_clk_fgpa(clk_fpga),
.nreset_button(nrst) ,
.fifo_stage(fifo_stage_wire) ,
.fifo_state_segs(fifo_state_segs)
    );
   
wire reset_button;
assign reset_button = ~(nreset_button);

Debouncer_Module  Debouncer_Reset (
    .test_button(reset_button),.dvd_clk(clk),
    .wire_button(reset_fifo)
); 

clk_divider clk_divider(
    .internal_clk_fgpa(clk),
    .clk_mode(1'b0),                // 100Mhz to 0: 1Hz 1: 100Hz
    .clk_out(slow_clk)
);  
    
Fifo_vol_2 #(.fifo_size(fifo_size), .fifo_bit_len(fifo_bit_len)) Fifo_vol_2 (
.Value_in(Value_in),
.Value_out(Value_out),
.fast_clk(clk),.nreset(reset_fifo),.slow_clk(slow_clk),
.empty_led(empty_led),.filled_led(filled_led),
.Counter_Display(Counter_Display),.fifo_stage(fifo_stage_wire)
);


    
endmodule
