`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2024 18:50:22
// Design Name: 
// Module Name: testbench_DUT
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


module Parallel_tb();
reg clk,rst; // clock  and reset
reg [7:0] I_00,I_01,I_02,I_03,I_10,I_11,I_12,I_13;
wire [7:0] P1,P2,P3,P4;
reg [16:0] vectornum; // bookkeeping variables           //2^16 = 65536
reg [7:0] testvectors[1:65536]; //array of testvectors   //256*256

integer outfile; // File descriptor
   
//instantiate device under test
Parallel_filter dut(.I_00(I_00),.I_01(I_01),.I_02(I_02),.I_03(I_03),.I_10(I_10),.I_11(I_11),.I_12(I_12),.I_13(I_13),.clk(clk),.rst(rst),.P1(P1),.P2(P2),.P3(P3),.P4(P4));

// generate clock
always #5 clk=~clk;

// at start of test, load vectors
initial 
begin
$readmemb("D:/Median_Filter/Input.mem",testvectors); // Read vectors 
outfile = $fopen("D:/Median_Filter/Outputs/Output_parallel.txt","w"); // Open the file to which results are to be written

//  Initialize
vectornum = 0;
clk=0;rst=0; 
end

// apply test vectors on rising edge of clk
always @(posedge clk)
begin
I_00 = testvectors[vectornum];
I_01 = testvectors[vectornum+256];
I_02 = testvectors[vectornum+512];
I_03 = testvectors[vectornum+768];
I_10 = testvectors[vectornum+1];
I_11 = testvectors[vectornum+257];
I_12 = testvectors[vectornum+513];
I_13 = testvectors[vectornum+769];
end


//!!!for some reason the output file is updated after we close the simulation 

// check results on falling edge of clk
always @(negedge clk)begin
if(~rst)begin
$fdisplay (outfile, "%b",P1); // Writing the results to the File
$fdisplay (outfile, "%b",P2);
$fdisplay (outfile, "%b",P3);
$fdisplay (outfile, "%b",P4);
vectornum = vectornum + 2; // read next vector
if (testvectors[vectornum] === 8'bx)
begin
$fclose(outfile); // close the file
$finish;// End simulation
end
end
end

endmodule
