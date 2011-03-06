/* *****************************************************************************
 * Project Name: NetCOPE Adder Functional Verification
 * File Name:    dut.sv - Design Under Test
 * Description:  DUT interfaces
 * Author:       Marcela Simkova <xsimko03@stud.fit.vutbr.cz> 
 * Date:         27.2.2011 
 * ************************************************************************** */
  
import test_pkg::*; // Test constants

/*
 *  Module declaration
 */
 
 module DUT (
   input logic CLK,
   input logic RESET,
   iFrameLinkRx.dut RX,
   iFrameLinkTx.dut TX,
   iFrameLinkTx.dut MONITOR
 );

/*
 *  Module body
 */
 FL_NETCOPE_ADDER #(
   .DATA_WIDTH(DATA_WIDTH)
   )

   VHDL_DUT_U (
     .CLK               (CLK),
     .RESET             (RESET),
     
     .RX_DATA       (RX.DATA),
     .RX_REM        (RX.DREM),
     .RX_SOF_N      (RX.SOF_N),
     .RX_EOF_N      (RX.EOF_N),
     .RX_SOP_N      (RX.SOP_N),
     .RX_EOP_N      (RX.EOP_N),
     .RX_SRC_RDY_N  (RX.SRC_RDY_N),
     .RX_DST_RDY_N  (RX.DST_RDY_N),

     .TX_DATA       (TX.DATA),
     .TX_REM        (TX.DREM),
     .TX_SOF_N      (TX.SOF_N),
     .TX_EOF_N      (TX.EOF_N),
     .TX_SOP_N      (TX.SOP_N),
     .TX_EOP_N      (TX.EOP_N),
     .TX_SRC_RDY_N  (TX.SRC_RDY_N),
     .TX_DST_RDY_N  (TX.DST_RDY_N)  
   );

 endmodule : DUT
