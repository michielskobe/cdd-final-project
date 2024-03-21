`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2024 11:48:47
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input   wire    iA, iB, iCarry,
    output  wire    oSum, oCarry
    );
    
    assign oSum = (iA ^ iB) ^ iCarry;
    
    assign oCarry = (iA & iB) ^ (iCarry & (iA ^ iB));
    
endmodule
