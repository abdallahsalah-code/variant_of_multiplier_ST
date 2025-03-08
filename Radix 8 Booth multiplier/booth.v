module booth #(parameter m = 4)(
    input  wire [3:0] in,
    input signed [m+1:0]tx,
    input signed [m-1:0]x,
    output reg signed [m+1:0] out       
);

always@(*)begin

case(in)
4'b0000:out=0;
4'b0001:out=x;
4'b0010:out=x;
4'b0011:out=x*2;
4'b0100:out=x*2; 
4'b0101:out=tx;
4'b0110:out=tx;
4'b0111:out=x*4; 
4'b1000:out=x*-4;
4'b1001:out=tx*-1; 
4'b1010:out=tx*-1;
4'b1011:out=x*-2;
4'b1100:out=x*-2;
4'b1101:out=x*-1;
4'b1110:out=x*-1;
4'b1111:out=0;
default:out=0;
endcase
end
endmodule
