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


module Systolic_Array
(
input [7:0] X1,X2,X3,X4,X5,X6,X7,X8,X9, // Input Pixels
output [7:0] Median // Median Pixel
    );
 
wire [7:0] temp[10:0]; // temporary wires for storing the results

// Stage-1 (3 CAS units)
assign temp[0] = (X1 > X4) ? X4 : X1;
assign temp[1] = (X2 > X5) ? X2 : X5;
assign temp[2] = (X2 > X5) ? X5 : X2;
assign temp[3] = (X9 > X6) ? X9 : X6;

// Stage-2 (3 CAS units)
assign temp[4] = (temp[0] > X7) ? X7 : temp[0];
assign temp[5] = (temp[2] < X8) ? X8 : temp[2];
assign temp[6] = (temp[3] < X3) ? X3 : temp[3];

// Stage-3 (1 CAS unit)
assign temp[7] = (temp[1] > temp[5]) ? temp[5] : temp[1];

// Stage-4 (1 CAS unit)
assign temp[8] = (temp[4] < temp[7]) ? temp[7] : temp[4];
assign temp[9] = (temp[4] < temp[7]) ? temp[4] : temp[7];

// Stage-5 (1 CAS unit)
assign temp[10] = (temp[9] < temp[6]) ? temp[6] : temp[9];

// Stage-6 (1 CAS unit)
assign Median = (temp[8] < temp[10]) ? temp[8] : temp[10];

endmodule
