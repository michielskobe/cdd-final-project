`timescale 1ns / 1ps

module csa_block_TB();
    localparam BLOCK_SIZE     = 4; 


    reg[BLOCK_SIZE-1:0] riA;
    reg[BLOCK_SIZE-1:0] riB;
    wire[BLOCK_SIZE-1:0] wResult;
    reg iSel;
    wire wCarry;

    csa_block #(.BLOCK_WIDTH(BLOCK_SIZE)) csa_inst(.iA(riA), .iB(riB), .iSel(iSel), .oSum(wResult), .oCarry(wCarry));

    // definition of clock period
    localparam  T = 20;  

    initial
    begin
        riA = 0;
        riB = 0;
        iSel = 0;
      
        #(5*T);

        iSel = 1;
        
        #(50*T);

        riA = 2;
        riB = 2;
        iSel = 0;
      
        #(5*T);

        iSel = 1;
        
        #(50*T);

        riA = 15;
        riB = 15;
        iSel = 0;
      
        #(5*T);

        iSel = 1;
        
        #(50*T);

        $stop;
    end

endmodule
