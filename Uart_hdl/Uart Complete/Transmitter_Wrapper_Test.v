`timescale 1ns / 1ps
`include "Stages.vh"

module Transmitter_Wrapper_Test
#(  
    parameter CLK_FREQ      = 50_000_000,
    parameter BAUD_RATE     = 9600,
    parameter Word_Len      = 8)
(
input clk,reset,                                       		 //CLK,Switch-Reset
input [Word_Len-1:0]tx_data_in,                        		 //8 Swtiches -tx_data_in
input tx_data_valid,                                    		//Swtich-Val,d
output Uart_Tx,                                        		 // Uart-Connection
output tx_data_ready ,                                 		 // Led
output reg [6:0] Stage_Displayer,Bit_Displayer,      	 // Seven-Segs [0] Stage [2] Bit_Counter
output [2:0] State_counter_out_led,
output [5:0] Bit_counter_out_led
);
    
wire clk_transmitter = clk;
wire [2:0] Current_State;  wire [5:0] Bit_Counter ;   
//wire [2:0] State_counter_out_led;
//wire [5:0]Bit_counter_out_led;

assign State_counter_out_led = Current_State;
assign Bit_counter_out_led   =  Bit_Counter;

Uart_Transmitter
#(  .CLK_FREQ (CLK_FREQ ) ,
    .BAUD_RATE(BAUD_RATE) ,
    .Word_Len (Word_Len )   ) UUT
(
.clk(clk_transmitter),.reset(reset),
.tx_data_in(tx_data_in),
.tx_data_valid(tx_data_valid),
.Uart_Tx(Uart_Tx),
.tx_data_ready(tx_data_ready),


.current_state_out(Current_State),
.bit_counter_out(Bit_Counter)
 );
 

                    
always @(posedge clk) begin

    case(Current_State)
        `Idle  : begin
                        Stage_Displayer <= `Display_zero;
                 end
        `Start : begin 
                        Stage_Displayer <= `Display_one;
                 end
        `Data  : begin 
                        Stage_Displayer <= `Display_two;
                 end
        `Stop  : begin 
                        Stage_Displayer <= `Display_three;
                 end
    endcase
    
    case(Bit_Counter) 
        6'd0:        begin Bit_Displayer <= `Display_zero ; end
        6'd1:        begin Bit_Displayer <= `Display_one  ; end
        6'd2:        begin Bit_Displayer <= `Display_two  ; end
        6'd3:        begin Bit_Displayer <= `Display_three; end
        6'd4:        begin Bit_Displayer <= `Display_four ; end
        6'd5:        begin Bit_Displayer <= `Display_five ; end
        6'd6:        begin Bit_Displayer <= `Display_six  ; end
        6'd7:        begin Bit_Displayer <= `Display_seven; end
        6'd8:        begin Bit_Displayer <= `Display_eight; end
        default:     begin Bit_Displayer <= `Display_a   ; end
    endcase                             
                                      
end                                      




                       
endmodule
