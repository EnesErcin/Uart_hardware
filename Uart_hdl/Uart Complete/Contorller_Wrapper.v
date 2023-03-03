`timescale 1ns / 1ps


module Contorller_Wrapper(
input nwrite_en,nread_en,internal_clk_fgpa,nreset_button,
output [1:0]fifo_stage,
output [7:0]fifo_state_segs
    );

// Buttons are when left unpressed gives 1
wire write_en,read_en,reset_button;
assign write_en     = ~(nwrite_en);
assign read_en      = ~(nread_en);
assign reset_button = ~(nreset_button);
   
Debouncer_Module  Debouncer_Reset (
    .test_button(reset_button),.dvd_clk(internal_clk_fgpa),
    .wire_button(reset_fifo)
); 


Debouncer_Module  Debouncer_Read_en (
    .test_button(read_en),.dvd_clk(internal_clk_fgpa),
    .wire_button(read_en_wire)
); 


Debouncer_Module  Debouncer_Write_en (
    .test_button(write_en),.dvd_clk(internal_clk_fgpa),
    .wire_button(write_en_wire)
); 

fifo_stage_cntrl fifo_stage_cntrl(
.fifo_stage(fifo_stage),
.fifo_state_segs(fifo_state_segs),
.clk(internal_clk_fgpa),.read_en(read_en_wire),.write_en(write_en_wire),.reset(reset_fifo)
    );
    
    

endmodule
