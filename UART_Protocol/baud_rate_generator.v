// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

//CLOCK GENERATION LOGIC FOR ACHIEVING A BAUD RATE OF 9600
module baud_rate_generator(input clock, reset, output reg enb_tx, enb_rx);
    parameter clk_freq = 100000000;
    parameter baud_rate = 9600;
    parameter divisor_tx = clk_freq/baud_rate;        // 10416
    parameter divisor_rx = clk_freq/(16*baud_rate);   // 651

    reg [15:0] counter_tx;
    reg [15:0] counter_rx;

    // TX tick
    always @(posedge clock) begin
        if (reset) begin
            counter_tx <= 0;
            enb_tx <= 0;
        end
        else if (counter_tx == divisor_tx - 1) begin
            counter_tx <= 0;
            enb_tx <= 1;
        end
        else begin
            counter_tx <= counter_tx + 1'b1;
            enb_tx <= 0;
        end
    end

    // RX tick (16x)
    always @(posedge clock) begin
        if (reset) begin
            counter_rx <= 0;
            enb_rx <= 0;
        end
        else if (counter_rx == divisor_rx - 1) begin
            counter_rx <= 0;
            enb_rx <= 1;
        end
        else begin
            counter_rx <= counter_rx + 1'b1;
            enb_rx <= 0;
        end
    end
endmodule
