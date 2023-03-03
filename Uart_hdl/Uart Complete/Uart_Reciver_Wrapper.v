`timescale 1ns / 1ps
`include "Stages.vh"


module Uart_Reciver_Wrapper
#(  parameter CLK_FREQ      = 50_000_000,
    parameter BAUD_RATE     = 9600,
    parameter Word_Len      = 8)
(
input clk,reset,                                    //CLK AND Switch-Reset
input rx_i,                                         // GPIO
output rx_data_in_ready,                            // Ready Led
output [Word_Len-1:0] rx_data_out               //  Leds
);


Uart_Reciver
#(  .CLK_FREQ (CLK_FREQ ) ,
    .BAUD_RATE(BAUD_RATE) ,
    .Word_Len (Word_Len ) )
Uart_Reciver (
.clk(clk),.reset(reset), 
.rx_i(rx_i),
.rx_data_in_ready(rx_data_in_ready),
.rx_data_out(rx_data_out)
    );
    
    
  
endmodule