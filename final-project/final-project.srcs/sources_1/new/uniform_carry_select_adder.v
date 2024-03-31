`timescale 1ns / 1ps

module uniform_carry_select_adder #(
    parameter   ADDER_WIDTH = 32,
    parameter   integer BLOCK_SIZE = $ceil($sqrt(ADDER_WIDTH)),
    parameter   integer BLOCK_COUNT = $ceil((ADDER_WIDTH -1)/BLOCK_SIZE) +1
    )
    (
    input   wire [ADDER_WIDTH-1:0]  iA, iB, 
    input   wire                    iCarry,
    output  wire [ADDER_WIDTH-1:0]  oSum, 
    output  wire                    oCarry

    );
    genvar i;

    wire wSel[BLOCK_COUNT-1:0];
    wire test;

    wire[(BLOCK_COUNT*BLOCK_SIZE)-1:0] wResult;
    reg[(BLOCK_COUNT*BLOCK_SIZE):0] rResultLong;
    reg[ADDER_WIDTH:0] rResult;
    reg rCarry;

    reg[(BLOCK_COUNT*BLOCK_SIZE):0] riA;
    reg[(BLOCK_COUNT*BLOCK_SIZE):0] riB;
    reg[(BLOCK_COUNT*BLOCK_SIZE)-ADDER_WIDTH:0] rZeroPad = 0;

    always @(*)
    begin
        riA <= {rZeroPad, iA};
        riB <= {rZeroPad, iB};
    end

    ripple_carry_adder_Nb #(.ADDER_WIDTH(BLOCK_SIZE)) rca_1(.iA(riA[BLOCK_SIZE-1:0]), .iB(riB[BLOCK_SIZE-1:0]), .iCarry(iCarry), .oSum(wResult[BLOCK_SIZE-1:0]), .oCarry(wSel[0]));

    generate
        for(i = 2; i<=BLOCK_COUNT; i=i+1)
        begin
            csa_block #(.BLOCK_WIDTH(BLOCK_SIZE)) csa_inst(.iA(riA[(BLOCK_SIZE)*(i)-1:(BLOCK_SIZE)*(i-1)]), .iB(riB[(BLOCK_SIZE)*(i)-1:(BLOCK_SIZE)*(i-1)]), .iSel(wSel[i-2]), .oSum(wResult[(BLOCK_SIZE)*(i)-1:(BLOCK_SIZE)*(i-1)]), .oCarry(wSel[i-1]));
        end
    endgenerate

    always @(*)
    begin
        rResultLong <= {wSel[BLOCK_COUNT-1], wResult};
    end

    always @(*)
    begin
        rResult <= rResultLong[ADDER_WIDTH-1:0];
        rCarry <= rResultLong[ADDER_WIDTH];
    end
    assign oSum = rResult;
    assign oCarry = rCarry;

endmodule
