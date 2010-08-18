/*
 * test.sv: IB_SWITCH automatic test
 * Copyright (C) 2007 CESNET
 * Author(s): Petr Kobiersky <kobiersky@liberouter.org>
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
 * $Id: test.sv 4815 2008-08-14 13:42:32Z xkosar02 $
 *
 * TODO:
 *
 */

import sv_common_pkg::*;
import sv_fl_pkg::*;
import test_pkg::*;

// ----------------------------------------------------------------------------
//                            Testing Program
// ----------------------------------------------------------------------------
// V PRIPADE POTREBY DOPLNIT FRAMELINKOVE ROZHRANIA
program TEST (
  input  logic     CLK,
  output logic     RESET,
  iFrameLinkRx.tb  RX,
  iFrameLinkTx.tb  TX,
  iFrameLinkTx.monitor MONITOR
  );
  
  // --------------------------------------------------------------------------
  //                       Variables declaration
  // --------------------------------------------------------------------------
 
  // AK MA KOMPONENTA VIAC DRIVEROV ALEBO MONITOROV TREBA ICH NA TOMTO MIESTE DEKLAROVAT A V TASKU
  // CREATEENVIRONMENT INSTANCIOVAT
  
  FrameLinkTransaction                 flBlueprint;                             // Transaction
  Generator                            generator;                               // Generator
  FrameLinkDriver #(DRIVER0_DATA_WIDTH, DRIVER0_DREM_WIDTH)     flDriver;       // Driver
  FrameLinkMonitor #(MONITOR0_DATA_WIDTH, MONITOR0_DREM_WIDTH)  flMonitor;      // Monitor
  FrameLinkResponder #(MONITOR0_DATA_WIDTH, MONITOR0_DREM_WIDTH)  flResponder;  // Responder
  Scoreboard                           scoreboard;                              // Scoreboard
  Coverage #(RX_DATA_WIDTH,RX_DREM_WIDTH,TX_DATA_WIDTH,TX_DREM_WIDTH) coverage; // Coverage
  
  // --------------------------------------------------------------------------
  //                       Creating Environment tasks
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // Create Test Environment
  task createGeneratorEnvironment(int packet_count = GENERATOR0_FL_PACKET_COUNT,
                                  int packet_size_max[] = GENERATOR0_FL_PACKET_SIZE_MAX,
                                  int packet_size_min[] = GENERATOR0_FL_PACKET_SIZE_MIN
                                  );
  // Create generator
    generator = new("Generator0", 0);
      flBlueprint = new;
      flBlueprint.packetCount   = packet_count;
      flBlueprint.packetSizeMax = packet_size_max;
      flBlueprint.packetSizeMin = packet_size_min;
      generator.blueprint       = flBlueprint;
  endtask: createGeneratorEnvironment    

  task createEnvironment();    
    // Create driver    
    flDriver  = new ("Driver0", generator.transMbx, RX);
      flDriver.txDelayEn_wt             = DRIVER0_DELAYEN_WT; 
      flDriver.txDelayDisable_wt        = DRIVER0_DELAYDIS_WT;
      flDriver.txDelayLow               = DRIVER0_DELAYLOW;
      flDriver.txDelayHigh              = DRIVER0_DELAYHIGH;
      flDriver.insideTxDelayEn_wt       = DRIVER0_INSIDE_DELAYEN_WT; 
      flDriver.insideTxDelayDisable_wt  = DRIVER0_INSIDE_DELAYDIS_WT;
      flDriver.insideTxDelayLow         = DRIVER0_INSIDE_DELAYLOW;
      flDriver.insideTxDelayHigh        = DRIVER0_INSIDE_DELAYHIGH;
    // Create monitor
    flMonitor = new ("Monitor0", MONITOR);
    // Create responder
    flResponder = new ("Responder0", TX);
      flResponder.rxDelayEn_wt            = MONITOR0_DELAYEN_WT; 
      flResponder.rxDelayDisable_wt       = MONITOR0_DELAYDIS_WT;
      flResponder.rxDelayLow              = MONITOR0_DELAYLOW;
      flResponder.rxDelayHigh             = MONITOR0_DELAYHIGH;
      flResponder.insideRxDelayEn_wt      = MONITOR0_INSIDE_DELAYEN_WT; 
      flResponder.insideRxDelayDisable_wt = MONITOR0_INSIDE_DELAYDIS_WT;
      flResponder.insideRxDelayLow        = MONITOR0_INSIDE_DELAYLOW;
      flResponder.insideRxDelayHigh       = MONITOR0_INSIDE_DELAYHIGH;    
    // Create scoreboard
    scoreboard = new;
    // Coverage class
    // V PRIPADE VIAC INTERFACOV TREBA VOLAT PRISLUSNY COVERAGE PODLA TYPU INTERFACE
    coverage = new();
      coverage.addFrameLinkInterfaceRx(RX,"RXcoverage");
      coverage.addFrameLinkInterfaceTx(MONITOR,"TXcoverage");
    // Set Callbacks
    // V PRIPADE VIAC DRIVEROV ALEBO MONITOROV TREBA VOLAT PRISLUSNE CALLBACKS
      flDriver.setCallbacks(scoreboard.driverCbs);
      flMonitor.setCallbacks(scoreboard.monitorCbs);
  endtask : createEnvironment

  // --------------------------------------------------------------------------
  //                       Test auxilarity procedures
  // --------------------------------------------------------------------------
  
  // --------------------------------------------------------------------------
  // Resets design
  task resetDesign();
    RESET=1;                       // Init Reset variable
    #RESET_TIME     RESET = 0;     // Deactivate reset after reset_time
  endtask : resetDesign

  // --------------------------------------------------------------------------
  // Enable test Environment
  task enableTestEnvironment();
    // Enable Driver, Monitor, Coverage for each port
    // V PRIPADE POTREBY ZAPNUT VSETKY POUZITE DRIVERY A MONITORY A RESPONDERY
    flDriver.setEnabled();
    flMonitor.setEnabled();
    flResponder.setEnabled();
    coverage.setEnabled();
  endtask : enableTestEnvironment

  // --------------------------------------------------------------------------
  // Disable test Environment
  task disableTestEnvironment();
     // V PRIPADE POTREBY VYPNUT VSETKY POUZITE DRIVERY A MONITORY A RESPONDERY
     // Disable drivers
     #(1000*CLK_PERIOD); 
     flDriver.setDisabled();
     // Disable monitors
     flMonitor.setDisabled();
     flResponder.setDisabled();
     coverage.setDisabled();
  endtask : disableTestEnvironment

  // --------------------------------------------------------------------------
  //                            Test cases
  // --------------------------------------------------------------------------

  
  // --------------------------------------------------------------------------
  // Test Case 2
  task test2();
     $write("\n\n############ TEST CASE  ############\n\n");
     // Create Generator Environment
     createGeneratorEnvironment();

     // Create Test environment
     createEnvironment();
     // Enable Test environment
     enableTestEnvironment();
     // Run generators
     generator.setEnabled(TRANSACTION_COUT);

     // Pokud je generator aktivni nic nedelej
    while (generator.enabled)
      #(CLK_PERIOD);
    // Generator vygeneroval posledni transakci (cekej az
    // se dokonci posilani a prijmani)
    #(1000*CLK_PERIOD); // TODO: pidat do driveru a monitoru busy bit
                        // a pouzit zde
  
    // Disable everything show results
     generator.setDisabled();
     // Disable Test Environment
     disableTestEnvironment();

     // Display Scoreboard
     scoreboard.display();
     coverage.display();
  endtask: test2

  // --------------------------------------------------------------------------
  //                           Main test part
  // --------------------------------------------------------------------------
  initial begin
    // -------------------------------------
    // DESIGN ENVIROMENT
    // -------------------------------------
    resetDesign(); // Reset design
    #(1000*CLK_PERIOD);
    createGeneratorEnvironment();
    createEnvironment(); // Create Test Enviroment
    // -------------------------------------
    // TESTING
    // -------------------------------------
    
    test2();
    
    // -------------------------------------
    // STOP TESTING
    // -------------------------------------
    $stop();       // Stop testing
  end

endprogram

