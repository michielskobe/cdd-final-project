`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2024 10:33:09
// Design Name: 
// Module Name: cll_block_array
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


module cll_block_array#(
    parameter ADDER_WIDTH = 4
    )
    (
    input wire[ADDER_WIDTH-1:0] iP, iG,
    input wire iCarry,
    output wire[ADDER_WIDTH-1:0] oCarry
    );
    
    genvar i;
    
    wire[ADDER_WIDTH-1:0] wCarry;
    
    generate
        for(i = 0; i<ADDER_WIDTH; i=i+1)
        begin
            cll_block #(.BLOCK_SIZE(i+1)) cll_block_inst(.iP(iP[i:0]),.iG(iG[i:0]), .iCarry(iCarry), .oCarry(wCarry[i]));
        end
    endgenerate 
    
    assign oCarry = wCarry;
    
endmodule
