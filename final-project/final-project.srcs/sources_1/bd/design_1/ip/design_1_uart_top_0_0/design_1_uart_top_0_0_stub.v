// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Fri Apr 19 11:57:49 2024
// Host        : fedora running 64-bit Fedora release 38 (Thirty Eight)
// Command     : write_verilog -force -mode synth_stub
//               /home/debber/Documents/__KuLeuven/GroepT/Fase3/Semester2/CDD/CDD-Final-Project/final-project/final-project.srcs/sources_1/bd/design_1/ip/design_1_uart_top_0_0/design_1_uart_top_0_0_stub.v
// Design      : design_1_uart_top_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "uart_top,Vivado 2020.1" *)
module design_1_uart_top_0_0(iClk, iRst, iRx, oTx, ind_op1, ind_op2, ind_sol, 
  ind_idle)
/* synthesis syn_black_box black_box_pad_pin="iClk,iRst,iRx,oTx,ind_op1,ind_op2,ind_sol,ind_idle" */;
  input iClk;
  input iRst;
  input iRx;
  output oTx;
  output ind_op1;
  output ind_op2;
  output ind_sol;
  output ind_idle;
endmodule
