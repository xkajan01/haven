/* *****************************************************************************
 * Project Name: HAVEN - Genetic Algorithm
 * File Name:    alu_env.svh
 * Description:  ALU environment.
 * Authors:      Marcela Simkova <isimkova@fit.vutbr.cz> 
 * Date:         19.4.2013
 * ************************************************************************** */

/*!
 * \brief AluEnv
 * 
 * This class represents the ALU environment.
 */
 
 class AluEnv extends uvm_env;
    
   //! UVM Factory Registration Macro
   `uvm_component_utils(AluEnv)
   
  /*! 
   * Data Members
   */ 
   
   AluEnvConfig   alu_env_cfg;
   
  /*! 
   * Component Members
   */  
   
   AluAgent               alu_agent;
   AluScoreboard          alu_scoreboard;
   AluInCoverageMonitor   alu_in_cov_monitor;
   AluOutCoverageMonitor  alu_out_cov_monitor;
   
   
  /*!
   * Methods
   */
   
   // Standard UVM methods
   extern function new(string name = "AluEnv", uvm_component parent = null);
   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);
   
 endclass: AluEnv
 
 

/*! 
 * Constructor - creates the AluEnv object  
 */
 function AluEnv::new(string name = "AluEnv", uvm_component parent = null);
   super.new(name, parent);
 endfunction: new
 

 
 /*! 
 * Build - environment configuration
 */ 
 function void AluEnv::build_phase(uvm_phase phase);
   // check configuration for the Env
   if (!uvm_config_db #(AluEnvConfig)::get(this, "", "AluEnvConfig", alu_env_cfg)) 
     `uvm_error("MYERR", "AluEnvConfig doesn't exist!"); 
   
   alu_agent = AluAgent::type_id::create("alu_agent", this);
   
   if (alu_env_cfg.has_alu_scoreboard)
     alu_scoreboard = AluScoreboard::type_id::create("alu_scoreboard", this);
     
   if (alu_env_cfg.has_functional_coverage) begin 
     alu_in_cov_monitor = AluInCoverageMonitor::type_id::create("alu_in_cov_monitor", this); 
     alu_out_cov_monitor = AluOutCoverageMonitor::type_id::create("alu_out_cov_monitor", this); 
   end  
 endfunction: build_phase
 
 
 
 /*! 
 * Connect - interconnection of environment components
 */ 
 function void AluEnv::connect_phase(uvm_phase phase);
    if (alu_env_cfg.has_alu_scoreboard) begin
      // transactions broadcasts to scoreboard and coverage monitors 
      alu_agent.ap_in.connect(alu_scoreboard.export_alu_in_if);
      alu_agent.ap_out.connect(alu_scoreboard.export_alu_out_if);
      alu_agent.ap_in.connect(alu_in_cov_monitor.analysis_export);
      alu_agent.ap_out.connect(alu_out_cov_monitor.analysis_export);
    end
 endfunction: connect_phase 