module tb_alu_8bit;
    reg [7:0] A, B;
    reg [3:0] ALU_Sel;
    wire [8:0] ALU_Out;

    alu_8bit uut (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .ALU_Out(ALU_Out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_alu_8bit);
        $monitor("Time=%0t | A=%d, B=%d, Sel=%b | Out=%d", $time, A, B, ALU_Sel, ALU_Out);

        // Test Case 1: Addition (255 + 255 = 510)
        A = 8'd255; B = 8'd255; ALU_Sel = 4'b0000; #10;
        if (ALU_Out !== (A + B))
            $display("FAIL: Addition | A=%d B=%d Expected=%d Got=%d", A, B, (A+B), ALU_Out);
        else
            $display("PASS: Addition");

        // Test Case 2: Subtraction (240 - 15 = 225)
        A = 8'd240; B = 8'd15; ALU_Sel = 4'b0001; #10;
        if (ALU_Out !== (A - B))
            $display("FAIL: Subtraction | A=%d B=%d Expected=%d Got=%d", A, B, (A-B), ALU_Out);
        else
            $display("PASS: Subtraction");

        // Test Case 3: Bitwise AND (170 & 204 = 136)
        A = 8'd170; B = 8'd204; ALU_Sel = 4'b1000; #10;
        if (ALU_Out !== (A & B))
            $display("FAIL: AND | A=%d B=%d Expected=%d Got=%d", A, B, (A&B), ALU_Out);
        else
            $display("PASS: AND");

        $finish;
    end
endmodule
