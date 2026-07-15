// Code your design here
module vending_machine_controller (
    input wire clk,
    input wire rst_n,          // Active-low asynchronous reset
    input wire [1:0] coin,     // 2'b00: No coin, 2'b01: 5c, 2'b10: 10c
    output reg dispense,
    output reg change
);

    // State Encoding (One-Hot)
    parameter IDLE = 5'b00001;
    parameter S5   = 5'b00010;
    parameter S10  = 5'b00100;
    parameter S15  = 5'b01000;
    parameter S20  = 5'b10000;

    reg [4:0] current_state, next_state;

    // 1. State Register (Sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // 2. Next State Logic (Combinational)
    always @(*) begin
        next_state = current_state; // Default hold
        case (current_state)
            IDLE: begin
                if (coin == 2'b01)      next_state = S5;
                else if (coin == 2'b10) next_state = S10;
                else                    next_state = IDLE;
            end
            S5: begin
                if (coin == 2'b01)      next_state = S10;
                else if (coin == 2'b10) next_state = S15;
                else                    next_state = S5;
            end
            S10: begin
                if (coin == 2'b01)      next_state = S15;
                else if (coin == 2'b10) next_state = S20;
                else                    next_state = S10;
            end
            S15: begin
                next_state = IDLE;
            end
            S20: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // 3. Output Logic
    always @(*) begin
        case (current_state)
            S15: begin
                dispense = 1'b1;
                change   = 1'b0;
            end
            S20: begin
                dispense = 1'b1;
                change   = 1'b1;
            end
            default: begin
                dispense = 1'b0;
                change   = 1'b0;
            end
        endcase
    end

endmodule
