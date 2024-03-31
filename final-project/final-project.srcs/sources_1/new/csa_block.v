`timescale 1ns / 1ps

module csa_block#(
    parameter BLOCK_WIDTH = 4
    )(
    input   wire [BLOCK_WIDTH-1:0]  iA, iB, 
    input   wire                    iSel,
    output  wire [BLOCK_WIDTH-1:0]  oSum, 
    output  wire                    oCarry
    );

    wire[BLOCK_WIDTH-1:0] sum_1;
    wire[BLOCK_WIDTH-1:0] sum_0;

    wire carry_1;
    wire carry_0;

    reg[BLOCK_WIDTH-1:0] r_sum;
    reg r_carry;

    ripple_carry_adder_Nb #(.ADDER_WIDTH(BLOCK_WIDTH)) rca_1(.iA(iA), .iB(iB), .iCarry(1), .oSum(sum_1), .oCarry(carry_1));
    ripple_carry_adder_Nb #(.ADDER_WIDTH(BLOCK_WIDTH)) rca_0(.iA(iA), .iB(iB), .iCarry(0), .oSum(sum_0), .oCarry(carry_0));

    always @(*)
    begin
        if(iSel == 1) begin
            r_sum <= sum_1;
            r_carry <= carry_1;
        end else begin
            r_sum <= sum_0;
            r_carry <= carry_0;
        end
    end
    assign oSum = r_sum;
    assign oCarry = r_carry;
endmodule