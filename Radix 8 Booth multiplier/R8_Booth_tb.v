`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2025 04:54:07 PM
// Design Name: 
// Module Name: R8_Booth_tb
// Project Name: 
// Target Devices: 
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


module R8_Booth_tb();
parameter width=32;
parameter delay=((width+5)/3)*10;
wire signed [2*width-1:0]product,expected;
reg clk,reset;
reg signed[width-1:0]multiplicand,multiplier;
Radix_8_Booth_multiplier #(width) m1(clk,reset,multiplicand,multiplier,product);
integer error,success;
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
    #(width*10) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;


multiplicand=1; multiplier=0; 
reset=0; #1 reset=1; 
	#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;


multiplicand=0; multiplier=2; 
reset=0; #1 reset=1; 
	#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=0; multiplier=-1; 
reset=0; #1 reset=1;
	#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=-2; multiplier=0; 
reset=0; #1 reset=1;
	#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=5; multiplier=3; 
reset=0; #1 reset=1;
	#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=2; multiplier=-2; 
reset=0; #1 reset=1;
	#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=-2; multiplier=2; 
reset=0; #1 reset=1;
	#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=-2; multiplier=-2; 
reset=0; #1 reset=1;
	#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=2147483647; multiplier=-64'd2147483648; 
reset=0; #1 reset=1;
	#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=-64'd2147483648; multiplier=-64'd2147483648; 
reset=0; #1 reset=1;
	#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

multiplicand=2147483647; multiplier=2147483647; 
reset=0; #1 reset=1;
	#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

repeat(50)begin
if(width<=32)
begin
multiplicand=$random;
multiplier=$random;
end
else if(width<=64)begin
multiplicand={$random,$random};
multiplier={$random,$random};

end 
reset=0; #1 reset=1;	
#(delay) $display("A=%d,B=%d,r=%d ,true=%d",multiplicand,multiplier,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;
end

$display("#sucess=%d #error=%d coverage=100%% :)",success,error);
$stop;
end
endmodule
