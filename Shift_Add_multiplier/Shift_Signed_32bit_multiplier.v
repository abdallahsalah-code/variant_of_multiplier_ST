// Signed Sequential Multiplier using Shift-and-Add Algorithm
// Supports 32-bit signed inputs, 65-bit signed output
module Shift_signed_multiplier #(parameter n=32) (
    input clk, rst,            // Clock and Active-Low Reset
    input signed [31:0] x,     // 32-bit Signed Multiplicand
    input signed [31:0] y,     // 32-bit Signed Multiplier
    output reg signed [64:0] product  // 65-bit Signed Result for sign preservation 
);
    reg [5:0] cycle;           // Cycle Counter (0-31)
    reg signed [32:0] mult;    // Sign-Extended x (Multiplicand)
    wire [32:0] add_sub;       // Adder/Subtractor Result
    
    // Add/Subtract Control: Subtract on final cycle for signed correction
    assign add_sub = (cycle < 31) ? product[64:32] + mult : product[64:32] - mult;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin        // Reset Initialization
            mult <= {x[31], x};      // Sign-extend x to 33 bits
            product <= {33'b0, y};   // Upper product=0, lower product=y (multiplier)
            cycle <= 0;
        end else begin
            if (product[0] == 1'b0) begin  // LSB=0: Just shift right
                product <= product >>> 1;    // Arithmetic right shift
                cycle <= cycle + 1;
            end else begin     // LSB=1: Add/Subtract and shift
                product <= {add_sub[32], add_sub, product[31:1]};
                cycle <= cycle + 1;
            end
        end
    end
endmodule

