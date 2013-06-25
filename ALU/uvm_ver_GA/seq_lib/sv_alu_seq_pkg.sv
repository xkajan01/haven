/* *****************************************************************************
 * Project Name: HAVEN - Genetic Algorithm
 * File Name:    sv_alu_seq_pkg.sv
 * Description:  UVM ALU Sequence Package
 * Authors:      Marcela Simkova <isimkova@fit.vutbr.cz> 
 * Date:         19.4.2013
 * ************************************************************************** */

 package sv_alu_seq_pkg;

   // Standard UVM import & include
   import uvm_pkg::*;
   `include "uvm_macros.svh"
  
   // Package imports
   import sv_alu_param_pkg::*;
   import sv_basic_ga_pkg::*;
  
   // Includes
   `include "chromosome_sequence_config.svh" 
   `include "chromosome_sequence_config.sv" 
   `include "alu_chromosome.svh"
   `include "alu_chromosome.sv"
   `include "chromosome_sequence.svh"
   `include "chromosome_sequence.sv"
   
 endpackage