`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: <Your Institute or Company Name>
// Engineer: <Your Name>
//
// Create Date: 2025-10-31
// Design Name: Barrel Shifter Based Multiplier (Signed/Unsigned)
// Module Name: barrel_multiplier
// Target Devices: ZedBoard (XC7Z020-1CLG484C)
// Tool Versions: Vivado 2023.x+
// Description: 8-bit barrel shifter-based combinational multiplier
//              Supports both signed and unsigned multiplication.
//
// Inputs:
//   A, B        - 8-bit operands
//   signed_mode - 1 = signed multiply, 0 = unsigned multiply
// Output:
//   P           - 16-bit product
//////////////////////////////////////////////////////////////////////////////////

module barrel_multiplier (
    input  [7:0] A,          // Multiplicand
    input  [7:0] B,          // Multiplier
    input        signed_mode, // 1 = signed, 0 = unsigned
    output [15:0] P           // Product
);

    wire signed [7:0] A_signed = A;
    wire signed [7:0] B_signed = B;

    wire [15:0] partial [7:0];
    wire signed [15:0] partial_signed [7:0];

    // Unsigned partial products
    assign partial[0] = (B[0]) ? {8'b0, A} : 16'b0;
    assign partial[1] = (B[1]) ? ({8'b0, A} << 1) : 16'b0;
    assign partial[2] = (B[2]) ? ({8'b0, A} << 2) : 16'b0;
    assign partial[3] = (B[3]) ? ({8'b0, A} << 3) : 16'b0;
    assign partial[4] = (B[4]) ? ({8'b0, A} << 4) : 16'b0;
    assign partial[5] = (B[5]) ? ({8'b0, A} << 5) : 16'b0;
    assign partial[6] = (B[6]) ? ({8'b0, A} << 6) : 16'b0;
    assign partial[7] = (B[7]) ? ({8'b0, A} << 7) : 16'b0;

    // Signed partial products (with sign extension)
    assign partial_signed[0] = (B_signed[0]) ? {{8{A_signed[7]}}, A_signed} : 16'sb0;
    assign partial_signed[1] = (B_signed[1]) ? ({{8{A_signed[7]}}, A_signed} <<< 1) : 16'sb0;
    assign partial_signed[2] = (B_signed[2]) ? ({{8{A_signed[7]}}, A_signed} <<< 2) : 16'sb0;
    assign partial_signed[3] = (B_signed[3]) ? ({{8{A_signed[7]}}, A_signed} <<< 3) : 16'sb0;
    assign partial_signed[4] = (B_signed[4]) ? ({{8{A_signed[7]}}, A_signed} <<< 4) : 16'sb0;
    assign partial_signed[5] = (B_signed[5]) ? ({{8{A_signed[7]}}, A_signed} <<< 5) : 16'sb0;
    assign partial_signed[6] = (B_signed[6]) ? ({{8{A_signed[7]}}, A_signed} <<< 6) : 16'sb0;
    assign partial_signed[7] = (B_signed[7]) ? ({{8{A_signed[7]}}, A_signed} <<< 7) : 16'sb0;

    // Select signed or unsigned operation
    assign P = signed_mode
               ? (partial_signed[0] + partial_signed[1] + partial_signed[2] + partial_signed[3] +
                  partial_signed[4] + partial_signed[5] + partial_signed[6] + partial_signed[7])
               : (partial[0] + partial[1] + partial[2] + partial[3] +
                  partial[4] + partial[5] + partial[6] + partial[7]);

endmodule
