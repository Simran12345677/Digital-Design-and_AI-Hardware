module tb_alu_8bit;
    reg [7:0] A, B;
    reg [3:0] ALU_Sel;
    wire [8:0] ALU_Out;
    integer pass_count = 0;
    integer fail_count = 0;

    alu_8bit uut (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .ALU_Out(ALU_Out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_alu_8bit);

        A = 8'd170; B = 8'd15; // susing same A and B for all

        // Test 0: Addition
        ALU_Sel = 4'b0000; #10;
        check(A + B, "Addition");

        // Test 1: Subtraction
        ALU_Sel = 4'b0001; #10;
        check(A - B, "Subtraction");

        // Test 2: Multiplication
        ALU_Sel = 4'b0010; #10;
        check(A * B, "Multiplication");

        // Test 3: Division
        ALU_Sel = 4'b0011; #10;
        check(A / B, "Division");

        // Test 4: Logical Shift Left
        ALU_Sel = 4'b0100; #10;
        check(A << 1, "Shift Left");

        // Test 5: Logical Shift Right
        ALU_Sel = 4'b0101; #10;
        check(A >> 1, "Shift Right");

        // Test 6: Rotate Left
        ALU_Sel = 4'b0110; #10;
        check({A[6:0], A[7]}, "Rotate Left");

        // Test 7: Rotate Right
        ALU_Sel = 4'b0111; #10;
        check({A[0], A[7:1]}, "Rotate Right");

        // Test 8: AND
        ALU_Sel = 4'b1000; #10;
        check(A & B, "AND");

        // Test 9: OR
        ALU_Sel = 4'b1001; #10;
        check(A | B, "OR");

        // Test 10: XOR
        ALU_Sel = 4'b1010; #10;
        check(A ^ B, "XOR");

        // Test 11: NOR
        ALU_Sel = 4'b1011; #10;
        check(~(A | B), "NOR");

        // Test 12: NAND
        ALU_Sel = 4'b1100; #10;
        check(~(A & B), "NAND");

        // Test 13: XNOR
        ALU_Sel = 4'b1101; #10;
        check(~(A ^ B), "XNOR");

        // Test 14: Greater Than
        ALU_Sel = 4'b1110; #10;
        check((A > B) ? 8'd1 : 8'd0, "Greater Than");

        // Test 15: Equal To
        ALU_Sel = 4'b1111; #10;
        check((A == B) ? 8'd1 : 8'd0, "Equal To");

        $display("----------------------------------------");
        $display("TOTAL: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $finish;
    end

    // Making a reusable function for everytask
    task check(input [8:0] expected, input [127:0] op_name);
        begin
            if (ALU_Out !== expected) begin
                $display("FAIL: %0s | A=%d B=%d Expected=%d Got=%d", op_name, A, B, expected, ALU_Out);
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: %0s | Got=%d", op_name, ALU_Out);
                pass_count = pass_count + 1;
            end
        end
    endtask

endmodule
