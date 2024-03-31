`timescale 1ns / 1ps

module ucsa_TB();
    localparam ADDER_WIDTH = 16;
    localparam ADDER_WIDTH_LARGE = 32;

    reg[ADDER_WIDTH-1:0] operandA;
    reg[ADDER_WIDTH-1:0] operandB;
    wire[ADDER_WIDTH-1:0] result;
    reg carry_in;
    wire carry_out;

    reg[ADDER_WIDTH_LARGE-1:0] operandA_L;
    reg[ADDER_WIDTH_LARGE-1:0] operandB_L;
    wire[ADDER_WIDTH_LARGE-1:0] result_L;
    reg carry_in_L;
    wire carry_out_L;

    uniform_carry_select_adder #( .ADDER_WIDTH(ADDER_WIDTH) ) 
    ucsa_inst   (
        .iA( operandA ), 
        .iB( operandB ),
        .iCarry( carry_in ),
        .oSum(result),
        .oCarry(carry_out)
      );

    uniform_carry_select_adder #( .ADDER_WIDTH(ADDER_WIDTH_LARGE) ) 
    ucsa_inst_L   (
        .iA( operandA_L ), 
        .iB( operandB_L ),
        .iCarry( carry_in_L ),
        .oSum(result_L),
        .oCarry(carry_out_L)
      );
    // definition of clock period
    localparam  T = 10;  

    initial
    begin
        operandA = 0;
        operandB = 0;
        carry_in = 0;
        operandA_L = 0;
        operandB_L = 0;
        carry_in_L = 0;

        #(5*T);
        carry_in = 1;
        carry_in_L = 1;

        #(10*T);

        operandA = 15;
        operandB = 15;
        carry_in = 0;
        operandA_L = 15;
        operandB_L = 15;
        carry_in_L = 0;

        #(5*T);
        carry_in = 1;
        carry_in_L = 1;

        #(10*T);

        operandA = 65_535;
        operandB = 65_535;
        carry_in = 0;
        operandA_L = 65_535;
        operandB_L = 65_535;
        carry_in_L = 0;

        #(5*T);
        carry_in = 1;
        carry_in_L = 1;

        #(10*T);
    end
endmodule
