`timescale 1ns / 1ps


module Transmitter_Intrface
 #(parameter Word_Len      = 8)
 (
input   empty_led,filled_led,clk,reset,
output  reg [Word_Len-1:0] To_Transmitter,
output  reg  tx_valid
    );
    
always @(posedge clk) begin
    if(empty_led == 1) begin
        To_Transmitter <= 8'h45;
         tx_valid <= 1;
    end else if(filled_led == 1) begin
        To_Transmitter <= 8'h46;
        tx_valid <= 1;
    end  else
         tx_valid <= 0;
end


endmodule
