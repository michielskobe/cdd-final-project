//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
//Date        : Thu Apr 18 08:38:30 2024
//Host        : LAPTOP-OOSNLU21 running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (iClk,
    iRst,
    iRx,
    ind_idle,
    ind_op1,
    ind_op2,
    ind_sol,
    oTx);
  input iClk;
  input iRst;
  input iRx;
  output ind_idle;
  output ind_op1;
  output ind_op2;
  output ind_sol;
  output oTx;

  wire iClk;
  wire iRst;
  wire iRx;
  wire ind_idle;
  wire ind_op1;
  wire ind_op2;
  wire ind_sol;
  wire oTx;

  design_1 design_1_i
       (.iClk(iClk),
        .iRst(iRst),
        .iRx(iRx),
        .ind_idle(ind_idle),
        .ind_op1(ind_op1),
        .ind_op2(ind_op2),
        .ind_sol(ind_sol),
        .oTx(oTx));
endmodule