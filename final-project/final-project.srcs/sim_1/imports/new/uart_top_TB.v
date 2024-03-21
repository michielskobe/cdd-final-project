`timescale 1ns / 1ps

module uart_top_TB ();
 
  // Define signals for module under test
  reg  rClk = 0;
  reg  rRst = 0;
  wire wRx, wTx;
  
  // Uart TX module parameters
  reg rTxStart;
  reg[7:0] rTxByte;
  wire wTxDone;

  // We downscale the values in the simulation
  // this will give CLKS_PER_BIT = 100 / 10 = 10
  localparam CLK_FREQ_inst  = 100;
  localparam BAUD_RATE_inst = 10;
  localparam OPERAND_WIDTH = 16;
  localparam ADDER_WIDTH = 4;
  localparam NBYTES = OPERAND_WIDTH/8;

  
  // Instantiate DUT  
  uart_top 
  #(  .CLK_FREQ(CLK_FREQ_inst), .BAUD_RATE(BAUD_RATE_inst), .OPERAND_WIDTH(OPERAND_WIDTH), .ADDER_WIDTH(ADDER_WIDTH), .NBYTES(NBYTES) )
  uart_top_inst
  ( .iClk(rClk), .iRst(rRst), .iRx(wRx), .oTx(wTx) );

  // Instantiate a uart TX module to send the start signals to the uart top module
  uart_tx #( .CLK_FREQ(CLK_FREQ_inst), .BAUD_RATE(BAUD_RATE_inst) ) 
  UART_TX_INST
    (.iClk(rClk),
     .iRst(rRst),
     .iTxStart(rTxStart),
     .iTxByte(rTxByte),
     .oTxSerial(wRx),
     .oTxDone(wTxDone)
     );

  
  // Define clock signal
  localparam CLOCK_PERIOD = 5;
  
  always
    #(CLOCK_PERIOD/2) rClk <= !rClk;
 
  // Input stimulus
  initial
    begin
      rRst = 1;
      #(5*CLOCK_PERIOD);
      
      rRst =0;
      
      // #################################
      // sending a uart command to the uart top module
      // #################################
      // circuit is reset
      rTxStart = 0;
      rTxByte = 8'h55;
      rRst = 1;
      #(5*CLOCK_PERIOD);
      
      // disable rRst
      rRst = 0;
      #(5*CLOCK_PERIOD);
      
      // assert rTxStart to send a frame (only 1 clock cycle!)
      rTxStart = 1;
      #(CLOCK_PERIOD);
      rTxStart = 0;

      rTxByte = 8'h55;

      #(6*NBYTES*8*CLOCK_PERIOD+20);
      
      // assert rTxStart to send a frame (only 1 clock cycle!)
      rTxStart = 1;
      #(CLOCK_PERIOD);
      rTxStart = 0;
      rTxByte = 8'h55;

      #(6*NBYTES*8*CLOCK_PERIOD+20);
      // assert rTxStart to send a frame (only 1 clock cycle!)
      rTxStart = 1;
      #(CLOCK_PERIOD);
      rTxStart = 0;

      rTxByte = 8'h55;

      #(6*NBYTES*8*CLOCK_PERIOD+20);
      
      // assert rTxStart to send a frame (only 1 clock cycle!)
      rTxStart = 1;
      #(CLOCK_PERIOD);
      rTxStart = 0;
      rTxByte = 8'h00;

      #(6*NBYTES*8*CLOCK_PERIOD+20);
      // #################################
      // finished sending a uart command to the uart top module
      // #################################

      // Let it run for a while
      #(1000*CLOCK_PERIOD);
            
      $stop;
           
    end
   
endmodule