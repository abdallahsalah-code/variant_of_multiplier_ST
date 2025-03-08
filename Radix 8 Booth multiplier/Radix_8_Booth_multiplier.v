`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Abdallah mohamed salah
// 
// Create Date: 03/08/2025 04:45:14 PM
// Design Name: Radix_8_Booth_multiplier
// Module Name: Radix_8_Booth_multiplier
// Project Name: Radix_8_Booth_multiplier
// Target Devices: xc7s100
// Tool Versions: 
// Description: multiplier by booth recoding in radix 8
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Radix-8 Booth Multiplier (3-bit encoding per iteration)
// Supports signed 32-bit inputs (x, y) → 64-bit product (x*y)
module Radix_8_Booth_multiplier #(parameter n = 32)(
    input clk, rst,                 
    input signed [n-1:0] x, y,       
    output reg signed [2*n-1:0] product
);
    // --- Local Parameters ---
    localparam i = (n%3 == 2) ? n : ((n%3 == 0) ? n-1 : n+1);
    localparam k = (n%3 == 0) ? 1 : 0;

    // --- Internal Signals ---
    wire [n+1:0] part, tx, sout, cout;
    wire [n-2:0] fsum;
    reg [n+1:0] sum, carry;
    reg [n-1:0] mcand;
    reg signed [n:0] mplier;
    reg ff;
    wire [3:0] add_3b;
    assign tx = (x << 1) + x;  // Precompute 3x
    assign add_3b = sum[2:0] + {carry[1:0], ff};

    // --- Submodules ---
    booth #(n) u2(
    .in(mplier[3:0]), 
    .tx(tx), 
    .x(mcand), 
    .out(part)
    );
    csa #(n+2) u1(
    .a(part), 
    .b({{3{sum[n+1]}}, sum[n+1:3]}),
    .c({{2{carry[n+1]}}, carry[n+1:2]}), 
    .sum(sout), .carry(cout)
    );
    
    // --- Final Sum Logic ---
    assign fsum = {{1{sum[n+1]}}, sum[n+1:3]} + carry[n+1:2] + add_3b[3];

    // --- Control Logic ---
    //reg [$clog2(n/3):0] count; //control logic exist if needed
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            mplier <= {y, 1'b0};
            mcand <= x;
            sum <= 0;
            carry <= 0;
            ff <= 0;
            product <= 0;
           // count <= (n + 5)/3;
        end else begin
            //count <= count - 1;
            mplier <= mplier >>> 3;
            sum <= sout;
            carry <= cout;
            ff <= add_3b[3];
            product <= {{k{fsum[n-2]}}, fsum, add_3b[2:0], product[i:3]};
        end
    end
endmodule

