`timescale 1ns / 1ps

module variable_carry_select_adder
    (
    input   wire [128-1:0]  iA, iB, 
    input   wire                    iCarry,
    output  wire [128-1:0]  oSum, 
    output  wire                    oCarry
    );

    genvar i;
    wire wSel[20-1:0];
    wire[128-1:0] wResult;
    reg [128-1:0]  riA, riB; 
    reg[128:0] rResult;
    reg rCarry;

    always@(*)
    begin
        riA <= iA;
        riB <= iB;
    end
    assign wSel[0] = iCarry;
    
    ripple_carry_adder_Nb #(.ADDER_WIDTH(3)) adder_inst0(.iA(riA[2:0]), .iB(riB[2:0]), .iCarry(wSel[0]), .oSum(wResult[2:0]), .oCarry(wSel[1]));
    csa_block #(.BLOCK_WIDTH(3)) adder_inst1(.iA(riA[5:3]), .iB(riB[5:3]), .iSel(wSel[1]), .oSum(wResult[5:3]), .oCarry(wSel[2]));
    csa_block #(.BLOCK_WIDTH(3)) adder_inst2(.iA(riA[8:6]), .iB(riB[8:6]), .iSel(wSel[2]), .oSum(wResult[8:6]), .oCarry(wSel[3]));
    csa_block #(.BLOCK_WIDTH(3)) adder_inst3(.iA(riA[11:9]), .iB(riB[11:9]), .iSel(wSel[3]), .oSum(wResult[11:9]), .oCarry(wSel[4]));
    csa_block #(.BLOCK_WIDTH(5)) adder_inst4(.iA(riA[16:12]), .iB(riB[16:12]), .iSel(wSel[4]), .oSum(wResult[16:12]), .oCarry(wSel[5]));
    csa_block #(.BLOCK_WIDTH(7)) adder_inst5(.iA(riA[23:17]), .iB(riB[23:17]), .iSel(wSel[5]), .oSum(wResult[23:17]), .oCarry(wSel[6]));
    csa_block #(.BLOCK_WIDTH(9)) adder_inst6(.iA(riA[32:24]), .iB(riB[32:24]), .iSel(wSel[6]), .oSum(wResult[32:24]), .oCarry(wSel[7]));
    csa_block #(.BLOCK_WIDTH(11)) adder_inst7(.iA(riA[43:33]), .iB(riB[43:33]), .iSel(wSel[7]), .oSum(wResult[43:33]), .oCarry(wSel[8]));
    csa_block #(.BLOCK_WIDTH(13)) adder_inst8(.iA(riA[56:44]), .iB(riB[56:44]), .iSel(wSel[8]), .oSum(wResult[56:44]), .oCarry(wSel[9]));
    csa_block #(.BLOCK_WIDTH(15)) adder_inst9(.iA(riA[71:57]), .iB(riB[71:57]), .iSel(wSel[9]), .oSum(wResult[71:57]), .oCarry(wSel[10]));
    csa_block #(.BLOCK_WIDTH(16)) adder_inst10(.iA(riA[87:72]), .iB(riB[87:72]), .iSel(wSel[10]), .oSum(wResult[87:72]), .oCarry(wSel[11]));
    csa_block #(.BLOCK_WIDTH(16)) adder_inst11(.iA(riA[103:88]), .iB(riB[103:88]), .iSel(wSel[11]), .oSum(wResult[103:88]), .oCarry(wSel[12]));
    csa_block #(.BLOCK_WIDTH(16)) adder_inst12(.iA(riA[119:104]), .iB(riB[119:104]), .iSel(wSel[12]), .oSum(wResult[119:104]), .oCarry(wSel[13]));
    csa_block #(.BLOCK_WIDTH(8)) adder_inst13(.iA(riA[127:120]), .iB(riB[127:120]), .iSel(wSel[13]), .oSum(wResult[127:120]), .oCarry(wSel[14]));

    assign oSum = wResult;
    assign oCarry = wSel[14];

endmodule
