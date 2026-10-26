module uart_tb_new;
    reg clk, rst, wr_en, rdy_clr;
    reg [7:0] data_in;
    wire rdy, busy;
    wire [7:0] dout;

    integer pass_cnt = 0;
    integer fail_cnt = 0;

    uart_top dut(.rst(rst), .data_in(data_in), .wr_en(wr_en), .clk(clk),
                 .rdy_clr(rdy_clr), .rdy(rdy), .busy(busy), .data_out(dout));

    initial {clk, rst, wr_en, data_in, rdy_clr} = 0;
    always #5 clk = ~clk;

    // byte bhejo, receive hone ka wait karo, aur compare karo
    task send_and_check(input [7:0] din);
    begin
        @(negedge clk);
        data_in = din;
        wr_en = 1;
        @(negedge clk);
        wr_en = 0;

        wait(!busy);
        wait(rdy);

        if (dout === din) begin
            pass_cnt = pass_cnt + 1;
            $display("PASS: sent %h, got %h", din, dout);
        end else begin
            fail_cnt = fail_cnt + 1;
            $display("FAIL: sent %h, got %h", din, dout);
        end

        @(negedge clk) rdy_clr = 1;
        @(negedge clk) rdy_clr = 0;
    end
    endtask

    initial begin
        @(negedge clk) rst = 1;
        @(negedge clk) rst = 0;

        // directed + edge cases
        send_and_check(8'h41);
        send_and_check(8'h55);
        send_and_check(8'h00);
        send_and_check(8'hFF);

        // random stimulus
        repeat (20) send_and_check($urandom % 256);

        $display("==== %0d PASS, %0d FAIL ====", pass_cnt, fail_cnt);
        if (fail_cnt == 0) $display("TEST PASSED");
        else               $display("TEST FAILED");
        $finish;
    end
endmodule
