`timescale 1ns / 1ps

module tb_fifo_sync;

    parameter FIFO_DEPTH = 8;
    parameter DATA_WIDTH = 32;

    // Testbench signals
    reg                   clk;
    reg                   rst_n;
    reg                   cs;
    reg                   we;
    reg                   re;
    reg  [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire                  empty;
    wire                  full;

    // DUT Instantiation
    fifo_sync #(
        .FIFO_DEPTH(FIFO_DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .cs(cs),
        .we(we),
        .re(re),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock Generation (10ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // Task for Write Operation
    task write_data(input [DATA_WIDTH-1:0] d_in);
    begin
        @(posedge clk);
        cs = 1; we = 1; re = 0;
        data_in = d_in;
        $display("[WRITE] Time=%0t | Data In=%0d", $time, d_in);
        @(posedge clk);
        we = 0; cs = 0;
    end
    endtask

    // Task for Read Operation (self-checking: compares data_out to expected value)
    task read_data(input [DATA_WIDTH-1:0] expected);
    begin
        @(posedge clk);
        cs = 1; we = 0; re = 1;
        @(posedge clk);
        if (data_out == expected)
            $display("[READ]  Time=%0t | Data Out=%0d | PASSED", $time, data_out);
        else
            $display("[READ]  Time=%0t | Data Out=%0d | FAILED (expected %0d)", $time, data_out, expected);
        re = 0; cs = 0;
    end
    endtask

    // Main Stimulus
    initial begin
        // Waveform file generation setup
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_fifo_sync);

        // Initialize Signals
        rst_n = 0;
        cs = 0; we = 0; re = 0; data_in = 0;
        #15;
        rst_n = 1; // Release Reset
        
        // --- Scenario 1: Simple Write & Read ---
        $display("\n--- SCENARIO 1: Simple Write & Read ---");
        write_data(1);
        write_data(10);
        write_data(100);
        
        read_data(1);
        read_data(10);
        read_data(100);

        // --- Scenario 2: Back-to-Back Write/Read ---
        $display("\n--- SCENARIO 2: Back-to-Back Write/Read ---");
        write_data(1);
        read_data(1);

        write_data(2);
        read_data(2);

        write_data(4);
        read_data(4);

        write_data(8);
        read_data(8);

        write_data(16);
        read_data(16);

        write_data(32);
        read_data(32);

        write_data(64);
        read_data(64);

        write_data(128);
        read_data(128);

        // --- Scenario 3: Full Flag Verification ---
        $display("\n--- SCENARIO 3: Testing Full Flag (filling all 8 slots) ---");
        write_data(5);
        write_data(6);
        write_data(7);
        write_data(8);
        write_data(9);
        write_data(10);
        write_data(11);
        write_data(12); // FIFO is now full (8 out of 8 slots used)

        // Extra write to check if it rejects data when Full
        write_data(500); 
        
        $display("\n--- Testing Empty Flag (reading all 8 slots back) ---");
        read_data(5);
        read_data(6);
        read_data(7);
        read_data(8);
        read_data(9);
        read_data(10);
        read_data(11);
        read_data(12); // FIFO is now empty

        // Extra read to check empty condition (no new data written, data_out should hold last value)
        read_data(12);

        #50;
        $finish;
    end

endmodule
