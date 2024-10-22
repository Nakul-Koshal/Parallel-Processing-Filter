`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2024 16:14:47
// Design Name: 
// Module Name: Compare_and_Swap
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
module Compare_and_Swap
(
input [7:0] Pixel_1,Pixel_2,Pixel_3, // Input Pixels
output [7:0] H,M,L // H -> Highest , L -> Lowest , M -> Median
    );
 
wire [7:0] temp[2:0]; // temporary wires for storing the results
  
// Stage-1 (1 CAS unit)
assign temp[0] = (Pixel_1 > Pixel_2) ? Pixel_1 : Pixel_2;
assign temp[1] = (Pixel_1 > Pixel_2) ? Pixel_2 : Pixel_1;

// Stage-2 (1 CAS unit)
assign temp[2] = (temp[1] > Pixel_3) ? temp[1] : Pixel_3;
assign L = (temp[1] > Pixel_3) ? Pixel_3 : temp[1];

// Stage-3 (1 CAS unit)
assign H = (temp[0] > temp[2]) ? temp[0] : temp[2];
assign M = (temp[0] > temp[2]) ? temp[2] : temp[0];
  
endmodule
