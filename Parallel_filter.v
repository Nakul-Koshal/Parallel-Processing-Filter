`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2024 16:08:14
// Design Name: 
// Module Name: CPMA
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


module Parallel_filter
(
input [7:0] I_00,I_01,I_02,I_03,I_10,I_11,I_12,I_13, // Input Pixels (2 columns and corresponding 4 rows -> 8 Pixels Total)
input clk,rst,// clks for making sure the data is sent to N-Stage systematically
output [7:0] P1,P2,P3,P4 // Output Median Pixels from the four 3x3 windows
    );
  
reg [7:0] H_0,M_0,L_0,H_1,M_1,L_1,H_2,M_2,L_2,H_3,M_3,L_3; // Outputs from the E-Stage is stored in these registers
wire [7:0] Hw_0,Mw_0,Lw_0,Hw_1,Mw_1,Lw_1,Hw_2,Mw_2,Lw_2,Hw_3,Mw_3,Lw_3;  // Outputs from the E-Stage

// E-Stage  (ELEMENTARY SORTING STAGE)
Compare_and_Swap E0(I_00,I_01,I_02,Hw_0,Mw_0,Lw_0);
Compare_and_Swap E1(I_10,I_11,I_12,Hw_1,Mw_1,Lw_1);
Compare_and_Swap E2(I_01,I_02,I_03,Hw_2,Mw_2,Lw_2);
Compare_and_Swap E3(I_11,I_12,I_13,Hw_3,Mw_3,Lw_3);

// Intermediate Stage -> between E-Stage and N-Stage
// Results of First 8 Pixels stored, so that it can then be compared with next new 8 Pixels
always @(posedge clk)
begin
// Top to bottom (reference -> paper)
// E0 CAS unit O/P's
H_0 <= Hw_0;
M_0 <= Mw_0;
L_0 <= Lw_0;

// E1 CAS unit O/P's
H_1 <= Hw_1;
M_1 <= Mw_1;
L_1 <= Lw_1;

// E2 CAS unit O/P's
H_2 <= Hw_2;
M_2 <= Mw_2;
L_2 <= Lw_2;

// E3 CAS unit O/P's
H_3 <= Hw_3;
M_3 <= Mw_3;
L_3 <= Lw_3;
end

// N-Stage (NETWORK NODE SORTING STAGE)
Systolic_Array N4(L_3,M_3,H_3, L_2, M_2, H_2,Lw_2,Mw_2,Hw_2,P3); // N4
Systolic_Array N3(L_1,M_1,H_1, L_0, M_0, H_0,Lw_0,Mw_0,Hw_0,P1); //N3
Systolic_Array N2(L_3,M_3,H_3,Lw_3,Mw_3,Hw_3,Lw_2,Mw_2,Hw_2,P4); //N2
Systolic_Array N1(L_1,M_1,H_1,Lw_1,Mw_1,Hw_1,Lw_0,Mw_0,Hw_0,P2); //N1
/*  Median Pixel's O/P WINDOW ->
  X  X  X  X
  X  P1 P2 X
  X  P3 P4 X
  X  X  X  X
*/

endmodule
