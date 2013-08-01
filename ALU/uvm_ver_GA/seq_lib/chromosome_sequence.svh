/* *****************************************************************************
 * Project Name: HAVEN - Genetic Algorithm
 * File Name:    chromosome_sequence.svh
 * Description:  Chromosome Sequence Class
 * Author:       Marcela Simkova <isimkova@fit.vutbr.cz> 
 * Date:         24.6.2013 
 * ************************************************************************** */

/*!
 * \brief ChromosomeSequence
 * 
 * This class represents UVM sequence of chromosomes for ALU.
 */
 
 class ChromosomeSequence extends uvm_sequence #(AluChromosome);

   //! UVM Factory Registration Macro
   `uvm_object_utils(ChromosomeSequence)
  
  /*! 
   * Data Members
   */
   
   local int          populationSize;  // Size of a population
   local Chromosome   population[];    // An array of chromosomes
   local int unsigned fitness;         // Fitness function
   local selection_t  selection;       // Selection type 
   local int unsigned maxMutations;    // Maximum number of mutations
   local real         allsums[];
   
   ChromosomeSequenceConfig   chrom_seq_cfg;  // configuration object
   
  /*! 
   * Component Members   
   */                
   
   Population pop_sequencer;
     
  /*!
   * Methods
   */

   // Standard UVM methods
   extern function new(string name = "ChromosomeSequence");
   extern task body();  
      
   // Own UVM methods
   extern task configurePopulation(ChromosomeSequenceConfig chrom_seq_cfg);
   extern task configureAluChromosome(AluChromosome alu_chromosome, ChromosomeSequenceConfig chrom_seq_cfg);
   
 endclass: ChromosomeSequence
 
 
 
/*! 
 * Constructor - creates ChromosomeSequence object  
 */
 function ChromosomeSequence::new(string name = "ChromosomeSequence");
   super.new(name);
 endfunction: new              



/*! 
 * Body - implements behavior of the transaction
 */ 
 task ChromosomeSequence::body;
   AluChromosome       alu_chromosome;     // ALU Chromosome
   AluChromosome       alu_chromosome_c;   // ALU Chromosome clone
   TransactionSequence trans_sequence;     // Transaction Sequence
   int chr_count = 0;
   
   // check configuration for Chromosome Sequence
   if (!uvm_config_db #(ChromosomeSequenceConfig)::get(null, get_full_name(), "ChromosomeSequenceConfig", chrom_seq_cfg)) 
     `uvm_error("BODY", "ChromosomeSequenceConfig doesn't exist!"); 
   
   // configure Population of Chromosomes (Chromosome Sequence)
   configurePopulation(chrom_seq_cfg);  
   
   // create ALU Chromosome
   alu_chromosome = AluChromosome::type_id::create("alu_chromosome");
   
   // configure ALU Chromosome
   configureAluChromosome(alu_chromosome, chrom_seq_cfg);
     
   // generate Chromosomes in Population
   while (chr_count < populationSize) begin
     
     // >>>>> CLONE ALU CHROMOSOME >>>>>    
     assert($cast(alu_chromosome_c, alu_chromosome.clone));
     //uvm_report_info("BODY PHASE", alu_chromosome_c.convert2string());
     
     start_item(alu_chromosome_c);
     
     // >>>>> RANDOM GENERATION OF CHROMOSOME >>>>>
     assert(alu_chromosome_c.randomize());     
     
     // >>>>> PRINT CHROMOSOME >>>>>
     alu_chromosome_c.print(chr_count, 0);  
     
     // >>>>> SEND CHROMOSOME TO THE TRANSACTION SEQUENCE >>>>>
     finish_item(alu_chromosome_c);
       
     // TU POTREBUJEM VYCITAT NEJAK COVERAGE (database????)
     
     
     // TU BY SOM ICH MALA ULOZIT DO POLA ABY SA S NIMI DALO PRACOVAT
     
     chr_count++; 
   end
 endtask: body
 
 
 
/*! 
 * configurePopulation - configure Population with data from the configuration object
 */ 
 task ChromosomeSequence::configurePopulation(ChromosomeSequenceConfig chrom_seq_cfg);
   populationSize = chrom_seq_cfg.populationSize;  // Size of a population
   selection      = chrom_seq_cfg.selection;       // Selection type 
   maxMutations   = chrom_seq_cfg.maxMutations;    // Maximum number of mutations
 endtask: configurePopulation
 
 
 
/*! 
 * configureAluChromosome - configure ALU Chromosome with data from the configuration object
 */ 
 task ChromosomeSequence::configureAluChromosome(AluChromosome alu_chromosome, ChromosomeSequenceConfig chrom_seq_cfg);
   alu_chromosome.movi_values           = chrom_seq_cfg.movi_values;
   alu_chromosome.operation_values      = chrom_seq_cfg.operation_values;
   alu_chromosome.delay_rangesMin       = chrom_seq_cfg.delay_rangesMin;         
   alu_chromosome.delay_rangesMax       = chrom_seq_cfg.delay_rangesMax;
   alu_chromosome.operandA_rangesMin    = chrom_seq_cfg.operandA_rangesMin;
   alu_chromosome.operandA_rangesMax    = chrom_seq_cfg.operandA_rangesMax;
   alu_chromosome.operandB_rangesMin    = chrom_seq_cfg.operandB_rangesMin;
   alu_chromosome.operandB_rangesMax    = chrom_seq_cfg.operandB_rangesMax;  
   alu_chromosome.operandMEM_rangesMin  = chrom_seq_cfg.operandMEM_rangesMin;
   alu_chromosome.operandMEM_rangesMax  = chrom_seq_cfg.operandMEM_rangesMax;  
   alu_chromosome.operandIMM_rangesMin  = chrom_seq_cfg.operandIMM_rangesMin;
   alu_chromosome.operandIMM_rangesMax  = chrom_seq_cfg.operandIMM_rangesMax;
   
   alu_chromosome.length = alu_chromosome.operandA_rangesMax + alu_chromosome.operandB_rangesMax + 
                           alu_chromosome.operandMEM_rangesMax + alu_chromosome.operandIMM_rangesMax + 
                           alu_chromosome.delay_rangesMax + alu_chromosome.movi_values + 
                           alu_chromosome.operation_values;
 endtask: configureAluChromosome 