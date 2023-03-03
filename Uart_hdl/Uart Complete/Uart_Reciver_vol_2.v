`timescale 1ns / 1ps
`include "Stages.vh"

module Uart_Reciver
#(  parameter CLK_FREQ      = 50_000_000,
    parameter BAUD_RATE     = 9600,
    parameter Word_Len      = 8)
(
input clk,reset, 
input rx_i,
output reg rx_data_in_ready,
output reg [Word_Len-1:0] rx_data_out
    );

localparam Baud_Rate_Max = CLK_FREQ/BAUD_RATE;
localparam Bit_Count_Max = Word_Len;
integer Baud_Counter        = 0;
reg [5:0] Bit_Counter       = 0;
reg [2:0] Current_State= `Idle, Next_State = `Idle;   

wire Baud_Done,Data_Done; 
assign Baud_Done  = (Baud_Counter == Baud_Rate_Max -1) ? 1'b1: 1'b0;     
assign Data_Done  = (Bit_Counter == Word_Len-1)? 1'b1: 1'b0;          

reg [Word_Len-1:0]rx_data_bank = 0, rx_data_bank_store= 0 ;
//assign rx_data_in_ready = (Current_State == `Idle)? 1'b1: 1'b0;   

always @(*) begin
    case(Current_State)
        `Idle   : begin 
                        if(rx_i  == 0)
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

always @(posedge clk) begin 
// Change Stages
    if(reset == 1) begin
        Current_State <= `Idle;
    end else begin
        Current_State <= Next_State;
    end
end

always @(posedge clk) begin
// Baud Counter
    if(reset == 1)
        Baud_Counter <= 0 ;
    else begin
        if(Baud_Counter < Baud_Rate_Max)
            Baud_Counter <= Baud_Counter +1;
        else 
            Baud_Counter <= 0 ;
    end
end



localparam Idle_tx  = 1'b1,
           Start_tx = 1'b0,
           Stop_tx  = 1'b1;


always @(*) begin
end

always@(posedge clk) begin
//Shif data stored for every baud_done and +1 datacounter
    if(reset == 1) begin
        rx_data_bank <= 0;
        Bit_Counter <= 0;
    end else if (Baud_Done == 1) begin
           if(Current_State != Next_State) begin
                Bit_Counter         <= 0;
           end else begin
                rx_data_bank                <= rx_data_bank << 1;
                Bit_Counter                   <= Bit_Counter + 1;
           end
    end    
    
    case(Current_State)
        `Idle   : begin 
                            rx_data_out <=  Idle_tx;
                            rx_data_in_ready <= 0;
                  end 
        `Start  : begin 
                            rx_data_out <=  Start_tx;
                    end
        `Data   : begin     if(reset == 0)
                            rx_data_bank[0] <= rx_i;
                  end
        `Stop   : begin 
                            rx_data_in_ready <= 1;
                            rx_data_out      <=  rx_data_bank;
                   end
    endcase
    
end


endmodule
