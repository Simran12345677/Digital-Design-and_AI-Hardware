// Project Name: UART PROTOCOL
// Target Devices: 
// Tool Versions: 
// Description: 
//
// Dependencies: 
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module uart_top (
    input rst,
    input [7:0] data_in,
    input wr_en,
    input clk,
    input rdy_clr,
    output rdy,
    output busy,
    output [7:0] data_out
);

wire rx_clk_en; //collecting output of baud rate generator rx_enb signal
wire tx_clk_en; //connecting output of baud rate generator tx_enb signal
wire tx_temp;   //connecting the output of tx module

baud_rate_generator bg (clk, rst, tx_clk_en, rx_clk_en);

uart_sender us (clk, wr_en, tx_clk_en, rst, data_in, tx_temp, busy);

uart_reciever ur (clk, rst, tx_temp, rdy_clr, rx_clk_en, rdy, data_out);

endmodule
