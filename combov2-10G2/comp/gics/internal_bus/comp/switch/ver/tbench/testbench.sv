/*
 * testbench.sv: Top Entity for GICS Switch automatic test
 * Copyright (C) 2009 CESNET
 * Author(s): Vaclav Bartos <xbarto11@stud.fit.vutbr.cz>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 * 3. Neither the name of the Company nor the names of its contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * This software is provided ``as is'', and any express or implied
 * warranties, including, but not limited to, the implied warranties of
 * merchantability and fitness for a particular purpose are disclaimed.
 * In no event shall the company or contributors be liable for any
 * direct, indirect, incidental, special, exemplary, or consequential
 * damages (including, but not limited to, procurement of substitute
 * goods or services; loss of use, data, or profits; or business
 * interruption) however caused and on any theory of liability, whether
 * in contract, strict liability, or tort (including negligence or
 * otherwise) arising in any way out of the use of this software, even
 * if advised of the possibility of such damage.
 *
 * $Id: testbench.sv 8619 2009-06-02 16:17:47Z washek $
 *
 * TODO:
 *
 */
 

// ----------------------------------------------------------------------------
//                                 TESTBENCH
// ----------------------------------------------------------------------------
import ib_params_pkg::*;
import params::*; // Test constants

module testbench;

  // -- Testbench wires and interfaces ----------------------------------------
  logic CLK;
  logic RESET;
  iInternalBusRx   #(G.DATA_WIDTH)   UP_RX  (CLK, RESET);
  iInternalBusTx   #(G.DATA_WIDTH)   UP_TX  (CLK, RESET);
  iInternalBusRx   #(G.DATA_WIDTH)   D1_RX  (CLK, RESET);
  iInternalBusTx   #(G.DATA_WIDTH)   D1_TX  (CLK, RESET);
  iInternalBusRx   #(G.DATA_WIDTH)   D2_RX  (CLK, RESET);
  iInternalBusTx   #(G.DATA_WIDTH)   D2_TX  (CLK, RESET);
  
  //-- Clock generation -------------------------------------------------------
  always begin
    CLK = 0;
    #(CLK_PERIOD/2);
    CLK = 1;
    #(CLK_PERIOD-CLK_PERIOD/2);
  end

  
  //-- Test -------------------------------------------------------------------
  TEST TEST_U (.CLK     (CLK),
               .RESET   (RESET),
               .UP_RX   (UP_RX),
               .UP_TX   (UP_TX),
               .D1_RX   (D1_RX),
               .D1_TX   (D1_TX),
               .D2_RX   (D2_RX),
               .D2_TX   (D2_TX)
              );
  
  //-- Design Under Test ------------------------------------------------------
  IB_SWITCH_SV #(G) DUT (.CLK     (CLK),
                         .RESET   (RESET),
                         .UP_RX   (UP_RX),
                         .UP_TX   (UP_TX),
                         .D1_RX   (D1_RX),
                         .D1_TX   (D1_TX),
                         .D2_RX   (D2_RX),
                         .D2_TX   (D2_TX)
                        );

endmodule : testbench
