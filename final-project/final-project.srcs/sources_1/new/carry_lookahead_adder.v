`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2024 09:06:12
// Design Name: 
// Module Name: carry_lookahead_adder
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


module carry_lookahead_adder#(
    parameter   ADDER_WIDTH = 4
    )
    (
    input   wire [ADDER_WIDTH-1:0]  iA, iB, 
    input   wire                    iCarry,
    output  wire [ADDER_WIDTH-1:0]  oSum, 
    output  wire                    oCarry
    );
    genvar i;
    
    wire[ADDER_WIDTH-1:0] wP, wG, wCarry;
    wire [ADDER_WIDTH-1:0] wSum;
    
    pf_adder pf_adder_inst(.iA(iA[0]), .iB(iB[0]), .iCarry(iCarry), .oSum(wSum[0]), .oP(wP[0]), .oG(wG[0]));
    cll_block_array #(.ADDER_WIDTH(ADDER_WIDTH)) cll_block_array_inst(.iP(wP), .iG(wG), .iCarry(iCarry), .oCarry(wCarry));
    
    generate
        for(i = 1; i<ADDER_WIDTH; i=i+1)
        begin
            pf_adder pf_adder_inst(.iA(iA[i]), .iB(iB[i]), .iCarry(wCarry[i-1]), .oSum(wSum[i]), .oP(wP[i]), .oG(wG[i]));
        end
    endgenerate 
    
    assign oSum = wSum;
    assign oCarry = wCarry[ADDER_WIDTH-1];
    
endmodule
