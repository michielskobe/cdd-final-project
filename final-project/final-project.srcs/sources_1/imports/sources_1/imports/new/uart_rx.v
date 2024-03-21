`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: KU Leuven Campus Groep T
// Engineer: Kobe Michiels
// 
// Create Date: 22.02.2024 23:12:22
// Design Name: UART RX
// Module Name: uart_rx
// Project Name: Complex Digital Design Lab 2
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

module uart_rx #(
  parameter   CLK_FREQ      = 125_000_000,
  parameter   BAUD_RATE     = 115_200,
  // Example: 125 MHz Clock / 115200 baud UART -> CLKS_PER_BIT = 1085 
  parameter   CLKS_PER_BIT  = CLK_FREQ / BAUD_RATE
)
(
  input wire        iClk, iRst,
  input wire        iRxSerial,
  output wire [7:0] oRxByte, 
  output wire       oRxDone
);

// State definition  
  localparam sIDLE         = 3'b000;
  localparam sRX_START     = 3'b001;
  localparam sRX_DATA      = 3'b010;
  localparam sRX_SAMPLE    = 3'b011;
  localparam sRX_STOP      = 3'b100;
  localparam sDONE         = 3'b101;
  
  // Register variables required to drive the FSM
  //---------------------------------------------
  // Remember:  -> 'current' is the register output
  //            -> 'next' is the register input
  
  // -> FSM state
  reg [2:0] rFSM_Current, wFSM_Next; 
  
  // -> counter to keep track of the clock cycles
  reg [$clog2(CLKS_PER_BIT):0]   rCnt_Current, wCnt_Next;
    
  // -> counter to keep track of sent bits
  // (between 0 and 7)
  reg [2:0] rBit_Current, wBit_Next;
  
  // -> the byte we want to send (we store an internal copy)
  reg [7:0] rRxData_Current, wRxData_Next;

// Double-register the input wire to prevent metastability issues
reg rRx1, rRx2;

// Describe all previous registers
  //------------------------------------------ 
  // Needs to be done with a clocked always block 
  // Don't forget the synchronous reset (default state)
  
  always @(posedge iClk)
  begin
    if (iRst==1)
      begin
        rFSM_Current <= sIDLE;
        rCnt_Current <= 0;
        rBit_Current <= 0;
        rRxData_Current <= 0;
        rRx1 <= 1;
        rRx2 <= 1;
      end
    else
      begin
        rFSM_Current <= wFSM_Next;
        rCnt_Current <= wCnt_Next;
        rBit_Current <= wBit_Next;
        rRxData_Current <= wRxData_Next;
        rRx1 <= iRxSerial;
        rRx2 <= rRx1;
      end
  end
  
  // Next state logic
  //------------------------------------------ 
  // -> this is a COMBINATIONAL module, which specifies the next state 
  //    of the FSM and also the next value of the previous registers
  // -> to AVOID LATCHES, you need to make sure all the next register values
  //    ( rFSM_Next, rCnt_Next, rBit_Next, rRxData_Next)
  //    are defined for every possible condition
     
  always @(*)
    begin
      
      case (rFSM_Current)
        
        sIDLE :
          begin
            wCnt_Next = 0;
            wBit_Next = 0;
            wRxData_Next = rRxData_Current;
            if (rRx2 == 0)
                begin
                    wFSM_Next = sRX_START;
                end
            else
                begin
                    wFSM_Next = sIDLE;
                end                                              
          end 
          
          sRX_START:
            begin
              wRxData_Next = rRxData_Current;
              wBit_Next = 0;
              if (rCnt_Current < (CLKS_PER_BIT - 1) )
                begin
                  wFSM_Next = sRX_START;
                  wCnt_Next = rCnt_Current + 1;
                end
              else
                begin
                  wFSM_Next = sRX_DATA;
                  wCnt_Next = 0;
                end
            end
            
         sRX_DATA:
            begin
              if (rCnt_Current < (CLKS_PER_BIT - 1) )
                begin
                  if (rCnt_Current == (CLKS_PER_BIT - 1)/2 )
                    begin
                        wFSM_Next = sRX_SAMPLE;
                        wCnt_Next = rCnt_Current + 1;
                        wRxData_Next = rRxData_Current;
                        wBit_Next = rBit_Current;
                    end
                  else
                    begin
                        wFSM_Next = sRX_DATA;
                        wCnt_Next = rCnt_Current + 1;
                        wRxData_Next = rRxData_Current;
                        wBit_Next = rBit_Current;
                    end
                end
              else
                begin
                  wCnt_Next = 0;
                  if (rBit_Current != 7)
                    begin
                      wFSM_Next = sRX_DATA;
                      wRxData_Next = rRxData_Current;
                      wBit_Next = rBit_Current + 1; 
                    end
                  else
                    begin
                      wFSM_Next = sRX_STOP;
                      wBit_Next = 0;
                      wRxData_Next = rRxData_Current;
                    end
                end
            end  
            
        sRX_SAMPLE:
            begin
                wFSM_Next = sRX_DATA;
                wCnt_Next = rCnt_Current + 1;
                wBit_Next = rBit_Current;
                wRxData_Next = { rRx2, rRxData_Current[7:1] };
            end
            
        sRX_STOP:
            begin
              wRxData_Next = rRxData_Current;
              wBit_Next = 0;
              if (rCnt_Current < (CLKS_PER_BIT - 1))
                begin
                  wFSM_Next = sRX_STOP;
                  wCnt_Next = rCnt_Current + 1;
                end
              else
                begin
                  wFSM_Next = sDONE;
                  wCnt_Next = 0;
                end
            end
            
        sDONE:
            begin
              wRxData_Next = rRxData_Current;
              wBit_Next = 0;
              wCnt_Next = 0;
              wFSM_Next = sIDLE;
            end 
            
        default :
            begin
              wFSM_Next = sIDLE;
              wCnt_Next = 0;
              wBit_Next = 0;
              wRxData_Next = 0;
            end 
        endcase
    end
    
// 3. Output logic
  //------------------------------------------ 
  // -> these are COMBINATIONAL circuits, which specify the value of
  //    the outputs, based on the current state of the registers used
  //    in the FSM
  
  // Output oRxBusy : easiest is to define it with a simple
  // continuous assignment
  //  -> it is '0' when FSM in sIDLE or sDONE
  //  -> it is '1' otherwise
  assign oRxBusy = ( (rFSM_Current == sIDLE) || (rFSM_Current == sDONE) ) ? 0 : 1;
  
  // Output oRxDone : easiest is to define it with a simple
  // continuous assignment
  //  -> it is '0' by default
  //  -> it is '1' during sDONE
  assign oRxDone = (rFSM_Current == sDONE) ? 1 : 0;
  
  assign oRxByte = rRxData_Current;

endmodule

