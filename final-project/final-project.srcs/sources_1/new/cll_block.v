`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2024 09:16:04
// Design Name: 
// Module Name: cll_block
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


module cll_block #(
    parameter BLOCK_SIZE = 3
    )
    (
    input wire [BLOCK_SIZE-1:0] iP, iG,
    input wire iCarry,
    output wire oCarry   
    );
    
    genvar i;
    
    reg rCarry;
    reg[BLOCK_SIZE:0] rOrInput;
    reg[BLOCK_SIZE:0] rAndBit;
    
   
   always@(*)
   begin
        rOrInput[0] <= iG[BLOCK_SIZE-1];
    end 
    generate     
        for(i = 1; i<=BLOCK_SIZE; i=i+1)
        begin
            always@(*)
            begin
                if (i == 1)
                    rAndBit[i] <= iCarry;
                else
                    rAndBit[i] <= iG[i-2];
                rOrInput[i] = &iP[BLOCK_SIZE-1:(i-1)]&rAndBit[i];
            end
        end
    endgenerate
    always@(*)
    begin
        rCarry <= |rOrInput;
    end 
    
    assign oCarry = rCarry;
    
endmodule
