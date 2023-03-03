`include "Stages.vh"
`timescale 1ns / 1ps

module Uart_Transmitter
#(  parameter CLK_FREQ      = 50_000_000,
    parameter BAUD_RATE     = 9600,
    parameter Word_Len      = 8)
(
 input clk,reset,
 input[Word_Len-1:0]tx_data_in,
 input tx_data_valid,
 output reg Uart_Tx,
 output tx_data_ready,
 
 
 output [2:0]current_state_out,
 output [5:0]bit_counter_out
 );
 
localparam Baud_Rate_Max = CLK_FREQ/BAUD_RATE;
localparam Bit_Count_Max = Word_Len;
integer Baud_Counter = 0;
reg  [5:0] Bit_Counter = 0;
reg  [2:0] Current_State= `Idle, Next_State = `Idle;
assign bit_counter_out = Bit_Counter;
assign current_state_out = Current_State;

wire Baud_Done,Data_Done; 
assign Baud_Done  = (Baud_Counter == Baud_Rate_Max -1) ? 1'b1: 1'b0;     
assign Data_Done  = (Bit_Counter == Word_Len-1)? 1'b1: 1'b0;            

reg [Word_Len-1:0]tx_data_in_store = 0 , tx_data_in_process = 0;

wire tx_data_in_ready;
assign tx_data_in_ready = (Current_State == `Idle)? 1'b1: 1'b0;        
assign tx_data_ready = tx_data_in_ready;     

always @(posedge clk) begin
//Store the correct data
    if(reset == 1) begin
        tx_data_in_store <= 0; 
    end else if(tx_data_in_ready & tx_data_valid == 1) begin
        tx_data_in_store <= tx_data_in;
    end
end

always @(posedge clk) begin
    if(reset == 1)
        Baud_Counter <= 0 ;
    else begin
        if(Baud_Counter < Baud_Rate_Max)
            Baud_Counter <= Baud_Counter +1;
        else 
            Baud_Counter <= 0 ;
    end
end



always@(posedge clk) begin
//Shif data stored for every baud_done and +1 datacounter
    if(reset == 1) begin
        tx_data_in_process <= 0;
        Bit_Counter <= 0;
    end else if (Baud_Done == 1) begin
           if(Current_State != Next_State) begin
                tx_data_in_process  <= tx_data_in_store ;
                Bit_Counter         <= 0;
           end else begin
                tx_data_in_process      <= tx_data_in_process  >> 1;
                Bit_Counter             <= Bit_Counter + 1;
           end
    end
end

always @(posedge clk) begin 
// Change Stages
    if(reset == 1) begin
        Current_State <= `Idle;
    end else begin
        Current_State <= Next_State;
    end
end



always @(*) begin
// Next_State Logic
    case(Current_State)
    `Idle   : begin 
                    if(tx_data_valid == 1)
                         Next_State = `Start;
                    else 
                        Next_State  = Current_State;
              end 
    `Start  : begin 
                    if (Baud_Done == 1) 
                         Next_State = `Data;
                    else 
                        Next_State  = Current_State;
                end
    `Data   : begin
                    if (Baud_Done & Data_Done == 1)
                        Next_State = `Stop ;
                    else 
                        Next_State  = Current_State;
             end
    `Stop   : begin 
                   if (Baud_Done == 1) 
                         Next_State = `Idle;
                    else 
                        Next_State  = Current_State;
               end
    endcase
end

localparam Idle_tx  = 1'b1,
           Start_tx = 1'b0,
           Stop_tx  = 1'b1;

always @(*) begin
    case(Current_State)
    `Idle   : begin 
                        Uart_Tx <=  Idle_tx;
              end 
    `Start  : begin 
                        Uart_Tx <=  Start_tx;
                end
    `Data   : begin
                        Uart_Tx <=  tx_data_in_process[0];
             end
    `Stop   : begin 
                        Uart_Tx <=  Stop_tx;
               end
    endcase
end


endmodule
