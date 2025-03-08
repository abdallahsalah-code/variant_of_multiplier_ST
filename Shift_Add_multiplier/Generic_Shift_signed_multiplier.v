`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 04:45:58 PM
// Design Name: ST_multiplier
// Module Name: Shift_Add_multiplier
// Project Name: Shift_Add_multiplier
// Target Devices: XC7S100
// Tool Versions: 
// Description: multiplier using shift and add architecture
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Shift_signed_multiplier #(parameter n=32) (
    input clk, rst,            // Clock and Active-Low Reset
    input signed [n-1:0] x,     // n-bit Signed Multiplicand
    input signed [n-1:0] y,     // n-bit Signed Multiplier
    output reg signed [2*n:0] product  // 2n+1-bit Signed Result for sign preservation 
);
    reg [$clog2(n):0] cycle;           // Cycle Counter (0-(n-1))
    reg signed [n:0] mult;    // Sign-Extended x (Multiplicand)
    wire [n:0] add_sub;       // Adder/Subtractor Result
    
    // Add/Subtract Control: Subtract on final cycle for signed correction
    assign add_sub = (cycle < n-1) ? product[2*n:n] + mult : product[2*n:n] - mult;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin        // Reset Initialization
            mult <= {x[n-1], x};      // Sign-extend x 
            product <= {{n+1{1'b0}}, y};   // Upper product=0, lower product=y (multiplier)
            cycle <= 0;
        end else begin
            if (product[0] == 1'b0) begin  // LSB=0: Just shift right
                product <= product >>> 1;    // Arithmetic right shift
                cycle <= cycle + 1;
            end else begin     // LSB=1: Add/Subtract and shift
                product <= {add_sub[n], add_sub, product[n-1:1]};
                cycle <= cycle + 1;
            end
        end
    end
endmodule
