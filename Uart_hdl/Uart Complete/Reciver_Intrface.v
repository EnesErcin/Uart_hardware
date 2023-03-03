`timescale 1ns / 1ps

module Reciver_Intrface #(parameter Word_Len      = 8)
(
input Reciver_data_in_valid,
input [Word_Len-1:0] Reciver_Output,
output reg [Word_Len-1:0] Reciver_to_Fifo
    );

always @(posedge Reciver_data_in_valid) begin
    Reciver_to_Fifo <= Reciver_Output;
end



endmodule
