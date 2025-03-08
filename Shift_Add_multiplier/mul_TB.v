`timescale 1ns/1ps
module mul_TB();
parameter WIDTH=32;
integer error,success;
wire signed [2*WIDTH-1:0]expected;
wire signed [2*WIDTH:0]product;
reg clk,reset;
reg signed[WIDTH-1:0]multiplicand,multiplier;
Shift_signed_multiplier #(WIDTH) U1(clk,reset,multiplicand,multiplier,product);
assign expected=multiplicand*multiplier;
initial
begin
clk=0;
forever#5 clk=~clk;
end

initial
begin
error=0;
success=0;

multiplicand=0; multiplier=0; 
reset=0; #1 reset=1; 
    #(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;


multiplicand=1; multiplier=0; 
reset=0; #1 reset=1; 
	#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;


multiplicand=0; multiplier=2; 
reset=0; #1 reset=1; 
	#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=0; multiplier=-1; 
reset=0; #1 reset=1;
	#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=-2; multiplier=0; 
reset=0; #1 reset=1;
	#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=5; multiplier=3; 
reset=0; #1 reset=1;
	#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=2; multiplier=-2; 
reset=0; #1 reset=1;
	#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=-2; multiplier=2; 
reset=0; #1 reset=1;
	#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=-2; multiplier=-2; 
reset=0; #1 reset=1;
	#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=2147483647; multiplier=-2147483648; 
reset=0; #1 reset=1;
	#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=-2147483648; multiplier=-2147483648; 
reset=0; #1 reset=1;
	#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=2147483647; multiplier=2147483647; 
reset=0; #1 reset=1;
	#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

repeat(50)begin
if(WIDTH<=32)
begin
multiplicand=$random;
multiplier=$random;
end
else if(WIDTH<=64)begin
multiplicand={$random,$random};
multiplier={$random,$random};

end 
reset=0; #1 reset=1;	
#(WIDTH*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;
end

$display("#sucess=%d #error=%d coverage=100%% :)",success,error);
$stop;
end
endmodule
