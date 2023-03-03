`timescale 1ns / 1ps

module Transmitter_Test#(  
    parameter CLK_FREQ      = 50_000_000,
    parameter BAUD_RATE     = 9600,
    parameter Word_Len      = 8,
    parameter Clk_Per       = 2)
();

reg clk = 0, reset = 0 , tx_data_valid = 0;
reg [Word_Len-1:0]tx_data_in = 0;
wire Uart_Tx,tx_data_ready;
always #(Clk_Per/2)  clk <= ~ clk;
always #(9*(CLK_FREQ/BAUD_RATE)/10)  tx_data_in <= $urandom() %75;

Transmitter_Wrapper_Test
#(  .CLK_FREQ (CLK_FREQ ) ,
    .BAUD_RATE(BAUD_RATE) ,
    .Word_Len (Word_Len )   ) UUT
(
.clk(clk),.reset(reset),
.tx_data_in(tx_data_in),
.tx_data_valid(tx_data_valid),
.Uart_Tx(Uart_Tx),
.tx_data_ready(tx_data_ready)
 );
 
 initial begin
 #50 reset <= 1;
 #50 reset <= 0;
 #50 tx_data_valid <= 1;
 #50 tx_data_valid <= 0;
 #(9*(CLK_FREQ/BAUD_RATE)/10) reset <= 1;
 #50 tx_data_valid <= 1;
 #50 reset <= 0;
 #50 tx_data_valid <= 0;
 end
 
 
 task mytest_1();
 begin 
 end endtask
 
 
 endmodule