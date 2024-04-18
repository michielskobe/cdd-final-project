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
    
    generate
        for(i = 0; i<ADDER_WIDTH; i=i+1)
        begin
            pf_adder pf_adder_inst(.iA(iA[i]), .iB(iB[i]), .iCarry());
        end
    endgenerate 
    
endmodule
