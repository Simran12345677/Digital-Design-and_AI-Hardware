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

    integer i;

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

    // Task for Read Operation
    task read_data();
    begin
        @(posedge clk);
        cs = 1; we = 0; re = 1;
        @(posedge clk);
        $display("[READ]  Time=%0t | Data Out=%0d", $time, data_out);
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
        
        read_data();
        read_data();
        read_data();

        // --- Scenario 2: Back-to-Back Continuous Write/Read ---
        $display("\n--- SCENARIO 2: Back-to-Back Write/Read ---");
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
            write_data(1 << i); // Fixed syntax line
            read_data();
        end

        // --- Scenario 3: Full and Empty Flag Verification ---
        $display("\n--- SCENARIO 3: Testing Full Flag ---");
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
            write_data(i + 5);
        end
        
        // Extra write to check if it rejects data when Full
        write_data(500); 
        
        $display("\n--- Testing Empty Flag ---");
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
            read_data();
        end
        
        // Extra read to check empty condition
        read_data();

        #50;
        $finish;
    end

endmodule
