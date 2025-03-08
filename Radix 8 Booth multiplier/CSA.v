
module csa #(parameter j = 4) (
    input [j-1:0] a,b,c,
    output [j-1:0] sum,
    output [j-1:0] carry
);

assign sum = a ^ b ^ c;
assign carry = (a & b) | (a & c) | (b & c);


endmodule