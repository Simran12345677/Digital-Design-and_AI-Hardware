// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_vending_machine();

    // Inputs to DUT
    reg clk;
    reg rst_n;
    reg [1:0] coin;

    // Outputs from DUT
    wire dispense;
    wire change;

    // DUT Instantiation
    vending_machine_controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .coin(coin),
        .dispense(dispense),
        .change(change)
    );

    // Clock Generation (Period = 10ns -> 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Waveform dumps for ModelSim / EDA Playground / GTKWave
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_vending_machine);

        // System Initialization
        clk = 0;
        rst_n = 0;
        coin = 2'b00;

        // Reset Asserted
        #15;
        rst_n = 1; // Release Reset
        #10;

        // ==========================================
        // TEST CASE 1: 5c + 5c + 5c = 15c (Dispense, No Change)
        // ==========================================
        $display("[TC1] Starting: 5c -> 5c -> 5c");
        
        @(posedge clk);
        coin = 2'b01; // Insert 5c (Goes to S5)
        
        @(posedge clk);
        coin = 2'b01; // Insert 5c (Goes to S10)
        
        @(posedge clk);
        coin = 2'b01; // Insert 5c (Goes to S15)
        
        @(posedge clk);
        coin = 2'b00; // Stop inserting (FSM will transition back to IDLE)
        
        #20; // Hold to observe outputs

        // ==========================================
        // TEST CASE 2: 10c + 10c = 20c (Dispense + 5c Change)
        // ==========================================
        $display("[TC2] Starting: 10c -> 10c");
        
        @(posedge clk);
        coin = 2'b10; // Insert 10c (Goes to S10)
        
        @(posedge clk);
        coin = 2'b10; // Insert 10c (Goes to S20)
        
        @(posedge clk);
        coin = 2'b00; // Stop inserting (FSM transitions back to IDLE)
        
        #30;

        $display("Simulation Finished Successfully.");
        $finish;
    end

endmodule
