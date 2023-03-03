
module Uart_Wrapper#(
    parameter fifo_size = 5, 
    parameter CLK_FREQ      = 50_000_000,
    parameter BAUD_RATE     = 9600,
    parameter Word_Len      = 8
)
(
input clk,
input nwrite_fifo_btn,nread_fifo_btn,nreset_button,
input rx_i,

output tx_o,
output [6:0]fifo_state_segs,Counter_Display,
output [Word_Len-1:0]Value_out_led
);

wire reset_button;
assign reset_button = nreset_button;
//assign reset_button = ~(nreset_button);
wire nreset_dbnc;
wire reset_dbnced; assign reset_dbnced = ~nreset_dbnc;

wire [Word_Len-1:0] Reciver_Output;
wire [Word_Len-1:0] Reciver_to_Fifo;
wire [Word_Len-1:0] To_Transmitter;
wire empty_led,filled_led,tx_valid;
wire [Word_Len-1:0] rx_data_out;

wire rx_input; assign rx_input = rx_i;
wire rx_data_in_ready;

Debouncer_Module  Debouncer_Reset (
    .test_button(reset_button),.dvd_clk(clk),
    .wire_button(nreset_dbnc)
); 


Transmitter_Wrapper_Test
#(  .CLK_FREQ (CLK_FREQ ) , 
    .BAUD_RATE(BAUD_RATE) ,
    .Word_Len (Word_Len )  ) Transmitter_Wrapper
(
.clk(clk),.reset(reset_dbnced),
.tx_data_in(To_Transmitter),
.tx_data_valid(tx_valid),
.Uart_Tx(tx_o),
.tx_data_ready(tx_data_ready)
);

Fifo_Wrapper_vol2
#(.fifo_size(fifo_size), .fifo_bit_len(Word_Len)) Fifo
(
.nwrite_en(nwrite_fifo_btn),
.nread_en(nread_fifo_btn),
.nreset_button(nreset_dbnc),
.clk_fpga(clk),
.Value_in(Reciver_to_Fifo),
.Value_out(Value_out_led),
.fifo_state_segs(fifo_state_segs),
.Counter_Display(Counter_Display),
.empty_led(empty_led),
.filled_led(filled_led)
    );
    
Uart_Reciver_Wrapper
#(  .CLK_FREQ (CLK_FREQ ) , 
    .BAUD_RATE(BAUD_RATE) ,
    .Word_Len (Word_Len )   ) Uart_Reciver_Wrapper
(
.clk(clk),.reset(reset_dbnced),                                    //CLK AND Switch-Reset
.rx_i(rx_input),                                                    // GPIO
.rx_data_in_ready(rx_data_in_ready),                            // Ready Led
.rx_data_out(rx_data_out)                                          //  Leds
);
   
Reciver_Intrface #(.Word_Len (Word_Len ))
Reciver_Intrface
(
.Reciver_data_in_valid(rx_data_in_ready),
.Reciver_Output (rx_data_out),
.Reciver_to_Fifo(Reciver_to_Fifo)
    );
    
Transmitter_Intrface #(.Word_Len (Word_Len ) )
Transmitter_Intrface(
.empty_led(empty_led),
.filled_led(filled_led),
.clk(clk),
.reset(reset_dbnced),
.To_Transmitter(To_Transmitter),
.tx_valid(tx_valid)
    );

endmodule