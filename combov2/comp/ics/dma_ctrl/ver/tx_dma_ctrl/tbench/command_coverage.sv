/*
 * command_coverage: TX DMA Controller Coverage class
 * Copyright (C) 2008 CESNET
 * Author(s): Marek Santa <xsanta06@stud.fit.vutbr.cz>
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
 * $Id: command_coverage.sv 12979 2010-02-26 16:13:08Z kastovsky $
 *
 * TODO:
 *
 */
  
  // --------------------------------------------------------------------------
  // -- Tx DMA Controller Command Coverage for FrameLink Interface 
  // --------------------------------------------------------------------------
  // This class measures exercised combinations of interface signals
  class CommandsCoverageFL #(int pDataWidth = 64, int pDremWidth=3);
  
    // Interface on witch is covering measured
    virtual iFrameLinkTx.tb #(pDataWidth,pDremWidth) fl;
    
    string  instanceName;

    // Sampling is enabled
    bit enabled;

    // Sampled values from interface
    logic sof_n;
    logic eof_n;
    logic sop_n;
    logic eop_n;
    logic [pDremWidth-1:0] drem; 
    logic src_rdy_n;
    logic dst_rdy_n;
     
    //-- Covering transactions ------------------------------------------------
    covergroup CommandsCovergroup;
      // Start of frame coverpoint
      sof: coverpoint sof_n {
        bins sof0 = {0};        
        bins sof1 = {1};
        }
      // End of frame coverpoint
      eof: coverpoint eof_n {
        bins eof0 = {0};
        bins eof1 = {1};
        }
      // Start of packet coverpoint
      sop: coverpoint sop_n {
        bins sop0 = {0};
        bins sop1 = {1};
        }
      // End of packet coverpoint
      eop: coverpoint eop_n {
        bins eop0 = {0};
        bins eop1 = {1};
        }
      // Drem coverpoint
      drem: coverpoint drem;

      // Source ready coverpoint
      src_rdy: coverpoint src_rdy_n {
        bins src_rdy0 = {0};
        bins src_rdy1 = {1};
      }
      // Destination ready coverpoint
      dst_rdy: coverpoint dst_rdy_n {
        bins dst_rdy0 = {0};
        bins dst_rdy1 = {1};
      }

      // End of packet crosspoint
      cross sof, sop, eof, eop, src_rdy, dst_rdy {
        // Ilegal values
        illegal_bins ilegal_vals0 = binsof(sop.sop1) && binsof(sof.sof0) && binsof(src_rdy.src_rdy0);
        illegal_bins ilegal_vals1 = binsof(eop.eop1) && binsof(eof.eof0);
        }   
          
      // Drem crospoint
      cross drem, eop {
        // Ilegal values
        ignore_bins drem_ignore_vals0 = binsof(eop.eop1);
        } 

        option.per_instance=1; // Also per instance statistics
     endgroup

    // ------------------------------------------------------------------------
    // Constructor
    function new (virtual iFrameLinkTx.tb #(pDataWidth,pDremWidth) fl,
                  string instanceName
                  );
      this.fl = fl;                   // Store interface
      CommandsCovergroup = new;       // Create covergroup
      enabled=0;                      // Disable interface sampling
      this.instanceName = instanceName;
    endfunction

    // -- Enable command coverage measures ------------------------------------
    // Enable commands coverage measures
    task setEnabled();
      enabled = 1; // Coverage Enabling
      fork         
        run();     // Creating coverage subprocess
      join_none;   // Don't wait for ending
    endtask : setEnabled
         
    // -- Disable command coverage measures -----------------------------------
    // Disable generator
    task setDisabled();
      enabled = 0; // Disable measures
    endtask : setDisabled
   
    // -- Run command coverage measures ---------------------------------------
    // Take transactions from mailbox and generate them to interface
    task run();
       while (enabled) begin            // Repeat while enabled
         @(fl.cb);             // Wait for clock
         // Sample signals values
         drem  = fl.cb.DREM;
         sof_n = fl.cb.SOF_N;
         eof_n = fl.cb.EOF_N;
         sop_n = fl.cb.SOP_N;
         eop_n = fl.cb.EOP_N;
         src_rdy_n = fl.cb.SRC_RDY_N;
         dst_rdy_n = fl.cb.DST_RDY_N;
         CommandsCovergroup.sample();
      end
    endtask : run
  
    // ------------------------------------------------------------------------
    // Display coverage statistic
    task display();
       $write("Commands coverage for %s: %d percent\n",
               instanceName, CommandsCovergroup.get_inst_coverage());
    endtask : display

  endclass: CommandsCoverageFL

  // --------------------------------------------------------------------------
  // -- SW TX DMA Controller Command Coverage for DMA Interface 
  // --------------------------------------------------------------------------
  // This class measures exercised combinations of interface signals
  class CommandsCoverageDMA #(int pCtrlDmaDataWidth = 16);
  
  // Interface on witch is covering measured
    virtual iDmaCtrl.dma_tb #(pCtrlDmaDataWidth) dma;
    
    string  instanceName;

    // Sampling is enabled
    bit enabled;

    // Sampled values from interface
    logic dma_req;
    logic dma_ack;
    logic dma_done;
        
    //-- Covering transactions ------------------------------------------------
    covergroup CommandsCovergroup;
      
      // dma request coverpoint
      dma_req: coverpoint dma_req {
        bins dma_req0 = {0};        
        bins dma_req1 = {1};
        }
      // dma acknowledge coverpoint
      dma_ack: coverpoint dma_ack {
        bins dma_ack0 = {0};        
        bins dma_ack1 = {1};
        }  
      // dma done coverpoint
      dma_done: coverpoint dma_done {
        bins dma_done0 = {0};        
        bins dma_done1 = {1};
        }
     
    option.per_instance=1; // Also per instance statistics
    endgroup
    
    // ------------------------------------------------------------------------
    // Constructor
     
    function new (virtual iDmaCtrl.dma_tb #(pCtrlDmaDataWidth) dma,
                  string instanceName
                  );
      this.dma = dma;                   // Store interface
      CommandsCovergroup = new;       // Create covergroup
      enabled=0;                      // Disable interface sampling
      this.instanceName = instanceName;
    endfunction

    // -- Enable command coverage measures ------------------------------------
    // Enable commands coverage measures
    task setEnabled();
      enabled = 1; // Coverage Enabling
      fork         
        run();     // Creating coverage subprocess
      join_none;   // Don't wait for ending
    endtask : setEnabled
         
    // -- Disable command coverage measures -----------------------------------
    // Disable generator
    task setDisabled();
      enabled = 0; // Disable measures
    endtask : setDisabled
   
    // -- Run command coverage measures ---------------------------------------
    // Take transactions from mailbox and generate them to interface
    task run();
       while (enabled) begin            // Repeat while enabled
         @(dma.dma_cb);                 // Wait for clock
         // Sample signals values
         dma_req = dma.dma_cb.DMA_REQ;
         dma_ack = dma.dma_cb.DMA_ACK;
         dma_done = dma.dma_cb.DMA_DONE;
         CommandsCovergroup.sample();
      end
    endtask : run
  
    // ------------------------------------------------------------------------
    // Display coverage statistic
    task display();
       $write("Commands coverage for %s: %d percent\n",
               instanceName, CommandsCovergroup.get_inst_coverage());
    endtask : display    
    
  endclass: CommandsCoverageDMA
  
  // --------------------------------------------------------------------------
  // -- SW TX DMA Controller Command Coverage for Descriptor Manager's Interface 
  // --------------------------------------------------------------------------
  // This class measures exercised combinations of interface signals
  class CommandsCoverageDESC #(int pCtrlDmaDataWidth = 16);
  
  // Interface on witch is covering measured
    virtual iDmaCtrl.desc_tb #(pCtrlDmaDataWidth) desc;
    
    string  instanceName;

    // Sampling is enabled
    bit enabled;

    // Sampled values from interface
    logic desc_read;
    logic desc_empty;
    logic desc_enable;
    
    //-- Covering transactions ------------------------------------------------
    covergroup CommandsCovergroup;
      // descriptor read coverpoint
      desc_read: coverpoint desc_read {
        bins desc_read0 = {0};        
        bins desc_read1 = {1};
        }
      // descriptor empty coverpoint
      desc_empty: coverpoint desc_empty {
        bins desc_empty0 = {0};        
        bins desc_empty1 = {1};
        }  
      // descriptor empty coverpoint
      desc_enable: coverpoint desc_enable {
        bins desc_enable0 = {0};        
        bins desc_enable1 = {1};
        }   
    option.per_instance=1; // Also per instance statistics
    endgroup
    
     // -----------------------------------------------------------------------
    // Constructor
    function new (virtual iDmaCtrl.desc_tb #(pCtrlDmaDataWidth) desc,
                  string instanceName
                  );
      this.desc = desc;                   // Store interface
      CommandsCovergroup = new;       // Create covergroup
      enabled=0;                      // Disable interface sampling
      this.instanceName = instanceName;
    endfunction

    // -- Enable command coverage measures ------------------------------------
    // Enable commands coverage measures
    task setEnabled();
      enabled = 1; // Coverage Enabling
      fork         
        run();     // Creating coverage subprocess
      join_none;   // Don't wait for ending
    endtask : setEnabled
         
    // -- Disable command coverage measures -----------------------------------
    // Disable generator
    task setDisabled();
      enabled = 0; // Disable measures
    endtask : setDisabled
   
    // -- Run command coverage measures ---------------------------------------
    // Take transactions from mailbox and generate them to interface
    task run();
       while (enabled) begin            // Repeat while enabled
         @(desc.desc_cb);                // Wait for clock
         // Sample signals values
         desc_read   = desc.desc_cb.DESC_READ;
         desc_empty  = desc.desc_cb.DESC_EMPTY;
         desc_enable = desc.desc_cb.DESC_ENABLE;         
         CommandsCovergroup.sample();
      end
    endtask : run
  
    // ------------------------------------------------------------------------
    // Display coverage statistic
    task display();
       $write("Commands coverage for %s: %d percent\n",
               instanceName, CommandsCovergroup.get_inst_coverage());
    endtask : display    
  endclass: CommandsCoverageDESC
  
  // --------------------------------------------------------------------------
  // -- SW TX DMA Controller Command Coverage for Internal Bus Interface 
  // --------------------------------------------------------------------------
  // This class measures exercised combinations of interface signals
  class CommandsCoverageIB #(int pDataWidth = 64);
  
  // Interface on witch is covering measured
    virtual iInternalBus.ib_write_tb ib;
    
    string  instanceName;

    // Sampling is enabled
    bit enabled;

    // Sampled values from interface
    logic wr_req;
        
    //-- Covering transactions ------------------------------------------------
    covergroup CommandsCovergroup;      
      // wr request coverpoint
      wr_req: coverpoint wr_req {
        bins wr_req0 = {0};        
        bins wr_req1 = {1};
        }
    option.per_instance=1; // Also per instance statistics
    endgroup
    
    // ------------------------------------------------------------------------
    // Constructor
    function new (virtual iInternalBus.ib_write_tb ib,
                  string instanceName
                  );
      this.ib = ib;                   // Store interface
      CommandsCovergroup = new;       // Create covergroup
      enabled=0;                      // Disable interface sampling
      this.instanceName = instanceName;
    endfunction

    // -- Enable command coverage measures ------------------------------------
    // Enable commands coverage measures
    task setEnabled();
      enabled = 1; // Coverage Enabling
      fork         
        run();     // Creating coverage subprocess
      join_none;   // Don't wait for ending
    endtask : setEnabled
         
    // -- Disable command coverage measures -----------------------------------
    // Disable generator
    task setDisabled();
      enabled = 0; // Disable measures
    endtask : setDisabled
   
    // -- Run command coverage measures ---------------------------------------
    // Take transactions from mailbox and generate them to interface
    task run();
       while (enabled) begin              // Repeat while enabled
         @(ib.ib_write_cb);                // Wait for clock
         // Sample signals values
         wr_req = ib.ib_write_cb.WR_REQ;
         CommandsCovergroup.sample();
      end
    endtask : run
  
    // ------------------------------------------------------------------------
    // Display coverage statistic
    task display();
       $write("Commands coverage for %s: %d percent\n",
               instanceName, CommandsCovergroup.get_inst_coverage());
    endtask : display    
    
  endclass: CommandsCoverageIB  
  
  // --------------------------------------------------------------------------
  // -- SW TX DMA Controller Command Coverage for MI32 Interface 
  // --------------------------------------------------------------------------
  // This class measures exercised combinations of interface signals
  class CommandsCoverageSW;
  
    // Interface on witch is covering measured
    virtual iMi32.tb sw;
    string  instanceName;

    // Sampling is enabled
    bit enabled;

    // Sampled values from interface
    logic sw_rd;
    logic sw_wr;
    logic sw_drdy; 
    
    //-- Covering transactions ------------------------------------------------
    covergroup CommandsCovergroup;
      // sw read coverpoint
      sw_rd: coverpoint sw_rd {
        bins sw_rd0 = {0};        
        bins sw_rd1 = {1};
        }
      // sw write coverpoint
      sw_wr: coverpoint sw_wr {
        bins sw_wr0 = {0};        
        bins sw_wr1 = {1};
        }  
      // sw write coverpoint
      sw_drdy: coverpoint sw_drdy {
        bins sw_drdy0 = {0};        
        bins sw_drdy1 = {1};
        }
             
    option.per_instance=1; // Also per instance statistics
    endgroup
    
    // ------------------------------------------------------------------------
    // Constructor
    function new (virtual iMi32.tb sw,
                  string instanceName
                  );
      this.sw = sw;                   // Store interface
      CommandsCovergroup = new;       // Create covergroup
      enabled=0;                      // Disable interface sampling
      this.instanceName = instanceName;
    endfunction

    // -- Enable command coverage measures ------------------------------------
    // Enable commands coverage measures
    task setEnabled();
      enabled = 1; // Coverage Enabling
      fork         
        run();     // Creating coverage subprocess
      join_none;   // Don't wait for ending
    endtask : setEnabled
         
    // -- Disable command coverage measures -----------------------------------
    // Disable generator
    task setDisabled();
      enabled = 0; // Disable measures
    endtask : setDisabled
   
    // -- Run command coverage measures ---------------------------------------
    // Take transactions from mailbox and generate them to interface
    task run();
       while (enabled) begin            // Repeat while enabled
         @(sw.cb);                // Wait for clock
         // Sample signals values
         sw_rd = sw.cb.RD;
         sw_wr = sw.cb.WR;
         sw_drdy = sw.cb.DRDY;
         CommandsCovergroup.sample();
      end
    endtask : run
  
    // ------------------------------------------------------------------------
    // Display coverage statistic
    task display();
       $write("Commands coverage for %s: %d percent\n",
               instanceName, CommandsCovergroup.get_inst_coverage());
    endtask : display    
    
  endclass: CommandsCoverageSW
       
  // --------------------------------------------------------------------------
  // -- TX Controller Coverage
  // --------------------------------------------------------------------------
  // This class measure coverage of commands
  class Coverage #(int pDataWidth = 64, pCtrlDmaDataWidth = 16, int pTxDataWidth = 32, int pTxDremWidth = 2);
    CommandsCoverageFL #(pTxDataWidth, pTxDremWidth)   cmdListFL[$];  // Commands coverage list
    CommandsCoverageDMA #(pCtrlDmaDataWidth)           cmdListDMA[$];  // Commands coverage list
    CommandsCoverageDESC #(pCtrlDmaDataWidth)          cmdListDESC[$];  // Commands coverage list
    CommandsCoverageIB #(pDataWidth)                   cmdListIB[$];  // Commands coverage list
    CommandsCoverageSW                                 cmdListSW[$];  // Commands coverage list
        
    // -- Add interface FrameLink for command coverage ------------------------
    task addFrameLinkInterface (virtual iFrameLinkTx.tb #(pTxDataWidth, pTxDremWidth)port,
                                string name
                                );
      // Create commands coverage class
      CommandsCoverageFL #(pTxDataWidth, pTxDremWidth) cmdCoverageFL = new(port, name);  
      // Insert class into list
      cmdListFL.push_back(cmdCoverageFL);
    endtask : addFrameLinkInterface
    
    // -- Add dma's interface for command coverage ----------------------------
    task addDmaInterface (virtual iDmaCtrl.dma_tb #(pCtrlDmaDataWidth) port,
                          string name
                          );
      // Create commands coverage class
      CommandsCoverageDMA #(pCtrlDmaDataWidth) cmdCoverageDMA = new(port, name);  
      // Insert class into list
      cmdListDMA.push_back(cmdCoverageDMA);
    endtask : addDmaInterface
    
    // -- Add descriptor manager's interface for command coverage -------------
    task addDescriptorInterface (virtual iDmaCtrl.desc_tb #(pCtrlDmaDataWidth) port,
                                 string name
                                 );
      // Create commands coverage class
      CommandsCoverageDESC #(pCtrlDmaDataWidth) cmdCoverageDESC = new(port, name);  
      // Insert class into list
      cmdListDESC.push_back(cmdCoverageDESC);
    endtask : addDescriptorInterface
    
    // -- Add Internal Bus interface for command coverage ---------------------
    task addInternalBusInterface (virtual iInternalBus.ib_write_tb port,
                                  string name
                                  );
      // Create commands coverage class
      CommandsCoverageIB #(pDataWidth) cmdCoverageIB = new(port, name);  
      // Insert class into list
      cmdListIB.push_back(cmdCoverageIB);
    endtask : addInternalBusInterface
    
    // -- Add MI32 interface for command coverage -----------------------------
    task addMI32Interface (virtual iMi32.tb port,
                           string name
                           );
      // Create commands coverage class
      CommandsCoverageSW  cmdCoverageSW = new(port, name);  
      // Insert class into list
      cmdListSW.push_back(cmdCoverageSW);
    endtask : addMI32Interface
    
    // -- Enable coverage measures --------------------------------------------
    // Enable coverage measres
    task setEnabled();
      foreach (cmdListFL[i])   cmdListFL[i].setEnabled();   // Enable for commands
      foreach (cmdListDMA[i])  cmdListDMA[i].setEnabled();  // Enable for commands
      foreach (cmdListDESC[i]) cmdListDESC[i].setEnabled(); // Enable for commands
      foreach (cmdListIB[i])   cmdListIB[i].setEnabled();   // Enable for commands 
      foreach (cmdListSW[i])   cmdListSW[i].setEnabled();   // Enable for commands
    endtask : setEnabled
         
    // -- Disable coverage measures -------------------------------------------
    // Disable coverage measures
    task setDisabled();
      foreach (cmdListFL[i]) cmdListFL[i].setDisabled();     // Disable for commands
      foreach (cmdListDMA[i]) cmdListDMA[i].setDisabled();   // Disable for commands
      foreach (cmdListDESC[i]) cmdListDESC[i].setDisabled(); // Disable for commands
      foreach (cmdListIB[i]) cmdListIB[i].setDisabled();     // Disable for commands
      foreach (cmdListSW[i]) cmdListSW[i].setDisabled();     // Disable for commands
    endtask : setDisabled

    // ------------------------------------------------------------------------
    // Display coverage statistic
    virtual task display();
      $write("----------------------------------------------------------------\n");
      $write("-- COVERAGE STATISTICS:\n");
      $write("----------------------------------------------------------------\n");
      foreach (cmdListDMA[i]) cmdListDMA[i].display();
      foreach (cmdListDESC[i]) cmdListDESC[i].display();
      foreach (cmdListIB[i]) cmdListIB[i].display();
      foreach (cmdListSW[i]) cmdListSW[i].display();
      foreach (cmdListFL[i]) cmdListFL[i].display();
      $write("----------------------------------------------------------------\n");
    endtask
  endclass : Coverage


