`timescale 1ns / 1ps
(* keep_hierarchy = "yes" *)
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Abdallah mohamed salah
// 
// Create Date: 03/09/2025 03:09:43 AM
// Design Name: Array_multiplier
// Module Name: Array_multiplier
// Project Name: Array_multiplier
// Target Devices: xc7s100
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Array_multiplier #(parameter WIDTH = 32) (
    input signed [WIDTH-1:0] A,      // Signed multiplicand
    input signed [WIDTH-1:0] B,      // Signed multiplier
    output reg signed [2*WIDTH-1:0] RESULT // Signed product
);
    // Absolute value conversion (unsigned vectors)
    wire [WIDTH-1:0] abs_A, abs_B;
    assign abs_A = A[WIDTH-1] ? -A : A; // Convert A to unsigned magnitude
    assign abs_B = B[WIDTH-1] ? -B : B; // Convert B to unsigned magnitude

    // Adder array signals
    wire [2*WIDTH-1:0] prod;         // Unsigned product (abs_A * abs_B)
    wire [WIDTH-2:0] sum [0:WIDTH-2]; // Sum connections between adder stages
    wire [WIDTH-2:0] carry [0:WIDTH-1]; // Carry connections between stages

    // Control signals
    wire sign_bit,zero;
    assign sign_bit = A[WIDTH-1] ^ B[WIDTH-1]; // Result sign (1 = negative)
    assign zero = (A == 0) | (B == 0);         // Detect zero inputs
    

	assign prod[0] = abs_A[0] & abs_B[0];    // LSB of product (direct AND)
	assign prod[2*WIDTH-1] = carry[WIDTH-1][WIDTH-2]; // Final carry to the MSB of the product

    // Adder array structure
    genvar i, j;
    generate
        // First stage
        for (i = 0; i < WIDTH-1; i = i + 1) begin : stage_first
            full_adder FA0 (
                .cin(1'b0),
                .a(abs_A[i+1] & abs_B[0]),   // A[i+1] * B[0]
                .b(abs_A[i] & abs_B[1]),     // A[i] * B[1]
                .sum(sum[0][i]),             // Sum to next stage
                .cout(carry[0][i])           // Carry to next stage
            );
        end

        // Middle stages: 
        for (i = 0; i < WIDTH-2; i = i + 1) begin : horizontal
            for (j = 0; j < WIDTH-2; j = j + 1) begin : vertical
                full_adder FA1 (
                    .cin(carry[i][j]),		// Propagated carry
                    .a(sum[i][j+1]),         // Propagated sum
                    .b(abs_A[j] & abs_B[i+2]), // A[j] * B[i+2]
                    .sum(sum[i+1][j]),
                    .cout(carry[i+1][j])
                );
            end
        end

        // Leftmost column: Handle MSB partial products
        for (i = 0; i < WIDTH-2; i = i + 1) begin : stage_left
            full_adder FA2 (
                .cin(carry[i][WIDTH-2]),
                .a(abs_A[WIDTH-1] & abs_B[i+1]), 
                .b(abs_A[WIDTH-2] & abs_B[i+2]),
                .sum(sum[i+1][WIDTH-2]),
                .cout(carry[i+1][WIDTH-2])
            );
        end

        // Final stage: Resolve remaining carries to generate upper product bits
        for (i = 0; i < WIDTH-1; i = i + 1) begin : stage_final
            if (i == 0) begin
                full_adder FA3 (
                    .cin(1'b0),
                    .a(carry[WIDTH-2][0]),
                    .b(sum[WIDTH-2][1]),
                    .sum(prod[WIDTH]),       // First upper product bit
                    .cout(carry[WIDTH-1][0])
                );
            end else if (i < WIDTH-2) begin
                full_adder FA4 (
                    .cin(carry[WIDTH-1][i-1]),
                    .a(carry[WIDTH-2][i]),
                    .b(sum[WIDTH-2][i+1]),
                    .sum(prod[WIDTH+i]),     // Middle upper product bits
                    .cout(carry[WIDTH-1][i])
                );
            end else begin
                full_adder FA5 (
                    .cin(carry[WIDTH-1][i-1]),
                    .a(carry[WIDTH-2][i]),
                    .b(abs_A[WIDTH-1] & abs_B[WIDTH-1]), // MSB * MSB
                    .sum(prod[WIDTH+i]),     // Final upper product bit
                    .cout(carry[WIDTH-1][i])
                );
            end
        end

        // Assign lower product bits from sum array before final stage
        for (i = 0; i <= WIDTH-2; i = i + 1) begin : prod_assign
            assign prod[i+1] = sum[i][0];    
        end
    endgenerate

    // Final result: Apply sign correction or output zero
    always @(*) begin
        if (zero) RESULT = 0;                // Handle zero case
        else RESULT = sign_bit ? -prod : prod; // Negate product if sign_bit=1
    end
endmodule

