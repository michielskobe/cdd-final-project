`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2024 16:39:15
// Design Name: 
// Module Name: ripple_carry_adder_Nb
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


module ripple_carry_adder_Nb #(
    parameter   ADDER_WIDTH = 16
    )
    (
    input   wire [ADDER_WIDTH-1:0]  iA, iB, 
    input   wire                    iCarry,
    output  wire [ADDER_WIDTH-1:0]  oSum, 
    output  wire                    oCarry
);

wire[ADDER_WIDTH-1:0]wTmp;

genvar i;

full_adder full_adder_inst0(.iA(iA[0]), .iB(iB[0]), .iCarry(iCarry), .oSum(oSum[0]), .oCarry(wTmp[1]));


generate
    for(i=1; i<ADDER_WIDTH-1; i=i+1)
    begin
        full_adder full_adder_inst(.iA(iA[i]), .iB(iB[i]), .iCarry(wTmp[i]), .oSum(oSum[i]), .oCarry(wTmp[i+1]));
    end
endgenerate
full_adder full_adder_inst(.iA(iA[ADDER_WIDTH-1]), .iB(iB[ADDER_WIDTH-1]), .iCarry(wTmp[ADDER_WIDTH-1]), .oSum(oSum[ADDER_WIDTH -1]), .oCarry(oCarry));

endmodule
