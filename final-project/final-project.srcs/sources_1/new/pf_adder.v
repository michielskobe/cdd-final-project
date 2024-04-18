`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2024 08:49:51
// Design Name: 
// Module Name: pf_adder
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


module pf_adder(
    input wire iA, iB, iCarry,
    output wire oSum, oP, oG
    );
    
    assign oG = iA & iB;
    assign oP = iA | iB;
    assign oSum = (iA ^ iB) ^ iCarry;
     
endmodule
