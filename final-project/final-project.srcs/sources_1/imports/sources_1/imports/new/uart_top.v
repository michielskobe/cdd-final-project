`timescale 1ns / 1ps

module uart_top #(
    parameter   OPERAND_WIDTH = 512,
    parameter   ADDER_WIDTH   = 128,
    parameter   NBYTES        = OPERAND_WIDTH / 8,    
    // values for the UART (in case we want to change them)
    parameter   CLK_FREQ      = 125_000_000,
    parameter   BAUD_RATE     = 115_200
  )  
  (
    input   wire   iClk, iRst,
    input   wire   iRx,
    output  wire   oTx,
    output  wire   ind_op1,
    output  wire   ind_op2,
    output  wire   ind_sol,
    output  wire   ind_idle
  );
  
  // Buffer to exchange data between Pynq-Z2 and laptop
  reg [NBYTES*8-1:0] rA;
  reg [NBYTES*8-1:0] rB;

  reg r_op1, r_op2, r_sol, r_idle;

  
  // State definition  
  localparam s_IDLE         = 3'b000;
  localparam s_WAIT_RX      = 3'b001;
  localparam s_TX           = 3'b010;
  localparam s_WAIT_TX      = 3'b011;
  localparam s_DONE         = 3'b100;
   
  // Declare all variables needed for the finite state machine 
  // -> the FSM state
  reg [2:0]   rFSM;  
  
  // Connection to UART TX (inputs = registers, outputs = wires)
  reg         rTxStart;
  reg [7:0]   rTxByte;
  
  wire        wTxBusy;
  wire        wTxDone;
  
  // Connection to UART RX
  wire[7:0] wRxByte;
  wire wRxDone;
  
  // Connection to adder
  reg rAddrStart;
  wire [(NBYTES+1)*8-1: 0] wRes;
  reg [(NBYTES+1)*8-1: 0] rRes;
  wire wDone;
      
  uart_tx #(  .CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE) )
  UART_TX_INST
    (.iClk(iClk),
     .iRst(iRst),
     .iTxStart(rTxStart),
     .iTxByte(rTxByte),
     .oTxSerial(oTx),
     .oTxBusy(wTxBusy),
     .oTxDone(wTxDone)
     );
     
  uart_rx #(  .CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE) )
  UART_RX_INST
    (.iClk(iClk),
     .iRst(iRst),
     .iRxSerial(iRx),
     .oRxByte(wRxByte),
     .oRxDone(wRxDone)
     );
     
mp_adder #(.OPERAND_WIDTH(OPERAND_WIDTH),.ADDER_WIDTH(ADDER_WIDTH),.N_ITERATIONS(OPERAND_WIDTH / ADDER_WIDTH))
MP_ADDR_INST
    (
    .iClk(iClk),
    .iRst(iRst),
    .iStart(rAddrStart),
    .iOpA(rA),
    .iOpB(rB),
    .oRes(wRes),  
    .oDone(wDone));

  reg [$clog2(NBYTES)+1:0] rCnt;
  
  always @(posedge iClk)
  begin
  
  // reset all registers upon reset
  if (iRst == 1 ) 
    begin
      rFSM <= s_IDLE;
      rTxStart <= 0;
      rCnt <= 0;
      rTxByte <= 0;
      rA <= 0;
      rB <= 0;
      rAddrStart <= 0;
      rRes <= 0;
      r_idle <= 1;
      r_op1 <= 1;
      r_op2 <= 1;
      r_sol <= 1;
    end 
  else 
    begin
      case (rFSM)
   
        s_IDLE :
          begin
            r_idle <= 1;
            r_op1 <= 0;
            r_op2 <= 0;
            r_sol <= 0;
            
            rFSM <= s_WAIT_RX;
          end
          
        s_WAIT_RX :
          begin
            r_idle <= 1;
            r_op1 <= 0;
            r_op2 <= 0;
            r_sol <= 0;
            if (rCnt < 2*NBYTES) 
                begin
                rRes <= rRes;
                if (rCnt < NBYTES)
                    begin
                    rB <= rB;
                        if (wRxDone)
                            begin
                                rA <= {rA[NBYTES*8-9:0], wRxByte};
                                rCnt <= rCnt +1;
                                r_idle <= 0;
                                r_op1 <= 1;
                                r_op2 <= 0;
                                r_sol <= 0;
                            end
                        else
                            begin
                                rA <= rA;
                                rCnt <= rCnt;
                            end
                        rFSM <= s_WAIT_RX;                 
                    end
                else
                    begin
                        rA <= rA;
                        if (wRxDone)
                            begin
                                rB <= {rB[NBYTES*8-9:0], wRxByte};
                                rCnt <= rCnt +1;
                                r_idle <= 0;
                                r_op1 <= 1;
                                r_op2 <= 1;
                                r_sol <= 0;
                            end
                        else
                            begin
                                rB <= rB;
                                rCnt <= rCnt;
                            end
                        rFSM <= s_WAIT_RX; 
                    end
                end
            else
                begin
                    if(rCnt == 2*NBYTES)
                        begin
                            rCnt <= rCnt +1;
                            rAddrStart <= 1;
                        end
                    else
                        begin
                            rAddrStart <= 0;
                            
                            if(wDone)
                                begin
                                    rRes <= {7'b000_0000, wRes[OPERAND_WIDTH+1-1:0]};
                                    rFSM <= s_TX;
                                    rCnt <= 0;
                                    r_idle <= 0;
                                    r_op1 <= 1;
                                    r_op2 <= 1;
                                    r_sol <= 1;
                                end
                            else
                                begin
                                    rRes <= rRes;
                                    rCnt <= rCnt;
                                    rFSM <= s_WAIT_RX;
                                end
                        end
                      
                end
          end
             
        s_TX :
          begin
            if ( (rCnt <= NBYTES) && (wTxBusy ==0) ) 
              begin
                rFSM <= s_WAIT_TX;
                rTxStart <= 1; 
                rTxByte <= rRes[(NBYTES+1)*8-1:(NBYTES+1)*8-8];            // we send the uppermost byte
                rRes <= {rRes[(NBYTES+1)*8-9:0] , 8'b0000_0000};    // we shift from right to left
                rCnt <= rCnt + 1;
              end 
            else 
              begin
                rFSM <= s_DONE;
                rTxStart <= 0;
                rTxByte <= 0;
                rCnt <= 0;
              end
            end 
            
            s_WAIT_TX :
              begin
                if (wTxDone) begin
                  rFSM <= s_TX;
                end else begin
                  rFSM <= s_WAIT_TX;
                  rTxStart <= 0;                   
                end
              end 
              
            s_DONE :
              begin
                rFSM <= s_IDLE;
              end 

            default :
              rFSM <= s_IDLE;
             
          endcase
      end
    end       
    
  assign ind_idle = r_idle;
  assign ind_op1  = r_op1;
  assign ind_op2  = r_op2;
  assign ind_sol  = r_sol;
endmodule