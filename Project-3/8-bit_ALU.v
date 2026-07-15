// Code your design here
module alu_8bit (
    input  [7:0] A, B,          // 8-bit Inputs
    input  [3:0] ALU_Sel,       // 4-bit Operation Select (Opcode)
    output reg [8:0] ALU_Out    // 9-bit Output (Carry bit handle karne ke liye 9-bit kiya gaya hai) [00:09:53]
);

    always @(*) begin
        case(ALU_Sel)
            4'b0000: ALU_Out = A + B;                  // Addition [00:04:14]
            4'b0001: ALU_Out = A - B;                  // Subtraction [00:04:20]
            4'b0010: ALU_Out = A * B;                  // Multiplication (Note: iske liye 16-bit output chahiye hoga, isliye video me isse normal rakha hai)
            4'b0011: ALU_Out = A / B;                  // Division
            4'b0100: ALU_Out = A << 1;                 // Logical Shift Left
            4'b0101: ALU_Out = A >> 1;                 // Logical Shift Right
            4'b0110: ALU_Out = {A[6:0], A[7]};         // Rotate Left [00:05:07]
            4'b0111: ALU_Out = {A[0], A[7:1]};         // Rotate Right [00:05:23]
            4'b1000: ALU_Out = A & B;                  // Bitwise AND
            4'b1001: ALU_Out = A | B;                  // Bitwise OR
            4'b1010: ALU_Out = A ^ B;                  // Bitwise XOR
            4'b1011: ALU_Out = ~(A | B);               // Bitwise NOR
            4'b1100: ALU_Out = ~(A & B);               // Bitwise NAND
            4'b1101: ALU_Out = ~(A ^ B);               // Bitwise XNOR
            4'b1110: ALU_Out = (A > B) ? 8'd1 : 8'd0;  // Comparison (Greater than)
            4'b1111: ALU_Out = (A == B) ? 8'd1 : 8'd0; // Equal to
            default: ALU_Out = 9'b0;
        endcase
    end
endmodule
