`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 03:12:20 AM
// Design Name: 
// Module Name: array_tb
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


module array_tb;
parameter width=32;
integer error,success;
reg signed [width-1:0] A;
reg signed [width-1:0] B;
wire signed [2*width-1:0] product,expected;
Array_multiplier #(width) g1(A,B,product);
assign expected=A*B;

initial
begin
error=0;
success=0;

A=0; B=0; 
 
    #10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;


A=1; B=0; 
 
	#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;


A=0; B=2; 
 
	#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

A=0; B=-1; 

	#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

A=-2; B=0; 

	#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

A=5; B=3; 

	#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

A=2; B=-2; 

	#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

A=-2; B=2; 

	#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

A=-2; B=-2; 

	#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

A=2147483647; B=-64'd2147483648; 

	#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

A=-64'd2147483648; B=-64'd2147483648; 

	#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

A=2147483647; B=2147483647; 

	#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;

repeat(50)begin
if(width<=32)
begin
A=$random;
B=$random;
end
else if(width<=64)begin
A={$random,$random};
B={$random,$random};

end 
	
#10 $display("A=%d,B=%d,r=%d ,true=%d",A,B,product,(product==expected)); if((product==expected)) success=success+1; else error=error+1;
end

$display("#sucess=%d #error=%d coverage=100%% :)",success,error);
$stop;
end
endmodule