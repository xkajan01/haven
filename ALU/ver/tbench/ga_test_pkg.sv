/* *****************************************************************************
 * Project Name: ALU Functional Verification
 * File Name:    ALU Genetic Algorithm Test Package
 * Author:       Marcela Simkova <isimkova@fit.vutbr.cz> 
 * Date:         23.6.2012 
 * ************************************************************************** */

 package ga_test_pkg;
 
   // GENETIC ALGORITHM PARAMETERS
   // Number of generations
   parameter GENERATIONS      = 20;
   // Size of population
   parameter POPULATION_SIZE  = 10;
   // Number of maximal mutations per individuum
   parameter MAX_MUTATIONS    = 20;
   // File for save/load population
   parameter string POPULATION_FILENAME = "pop";
   // Load or create new population on evolution start
   parameter LOAD_POPULATION  = 0; 
   parameter ESTIMATED_TIME   = 800;

   // CHROMOSOME PARAMETERS
   // Ranges parameters
   parameter DELAY_RANGES_MIN       = 1;
   parameter DELAY_RANGES_MAX       = 4;
   parameter OPERAND_A_RANGES_MIN   = 1;
   parameter OPERAND_A_RANGES_MAX   = 8;
   parameter OPERAND_B_RANGES_MIN   = 1;
   parameter OPERAND_B_RANGES_MAX   = 8;
   parameter OPERAND_MEM_RANGES_MIN = 1;
   parameter OPERAND_MEM_RANGES_MAX = 8;
   parameter OPERAND_IMM_RANGES_MIN = 1;
   parameter OPERAND_IMM_RANGES_MAX = 8;
   
   // TRANSACTION COUNT PER EACH CHROMOSOME
   parameter TRANS_COUNT_PER_CHROM  = 200;

 endpackage