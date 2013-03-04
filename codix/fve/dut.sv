/******************************************************************************
 *     "Copyright (C) 2013, ApS s.r.o Brno, All Rights Reserved"             *
 ******************************************************************************/
/**
 *  \file
 *  \date   Mon Mar  4 13:49:04 2013, generated by Codasip HW generator v2.0.0.
 *  \brief  Contains interconnection between design under test in HDL and SystemVerilog environment.
 */

// Module declaration
module DUT( input logic CLK, input logic RST );

	// Black box signals mapping (from top module ENTITY)
	CODIX_CA_SOC_T HDL_DUT_U(
		.RST (RST),
		.CLK (CLK) );

	// instantiate DUTs interfaces
	icodix_ca_core_regs icodix_ca_core_regs_if( CLK, RST );
	icodix_ca_core_main_instr_hw_instr_hw icodix_ca_core_main_instr_hw_instr_hw_if( CLK, RST );
	icodix_ca_mem icodix_ca_mem_if( CLK, RST );
	ihalt ihalt_if( CLK, RST );
	icodix_ca_out icodix_ca_out_if( CLK, RST );
	icodix_ca_inout icodix_ca_inout_if( CLK, RST );
	// instance of the input interface
	icodix_ca_in icodix_ca_in_if (
		.CLK(CLK),
		.RST(RST),
		.codix_ca_irq(HDL_DUT_U.codix_ca.irq) );

	// White box signals mapping (from the internal architecture of the design)
	initial begin
		assign icodix_ca_core_regs_if.codix_ca_core_regs_RA0 = HDL_DUT_U.codix_ca.core.regs.RA0;
		assign icodix_ca_core_regs_if.codix_ca_core_regs_RE0 = HDL_DUT_U.codix_ca.core.regs.RE0;
		assign icodix_ca_core_regs_if.codix_ca_core_regs_RA1 = HDL_DUT_U.codix_ca.core.regs.RA1;
		assign icodix_ca_core_regs_if.codix_ca_core_regs_RE1 = HDL_DUT_U.codix_ca.core.regs.RE1;
		assign icodix_ca_core_regs_if.codix_ca_core_regs_RA2 = HDL_DUT_U.codix_ca.core.regs.RA2;
		assign icodix_ca_core_regs_if.codix_ca_core_regs_RE2 = HDL_DUT_U.codix_ca.core.regs.RE2;
		assign icodix_ca_core_regs_if.codix_ca_core_regs_D0 = HDL_DUT_U.codix_ca.core.regs.D0;
		assign icodix_ca_core_regs_if.codix_ca_core_regs_WE0 = HDL_DUT_U.codix_ca.core.regs.WE0;
		assign icodix_ca_core_regs_if.codix_ca_core_regs_WA0 = HDL_DUT_U.codix_ca.core.regs.WA0;
		assign icodix_ca_core_regs_if.codix_ca_core_regs_Q0 = HDL_DUT_U.codix_ca.core.regs.Q0;
		assign icodix_ca_core_regs_if.codix_ca_core_regs_Q1 = HDL_DUT_U.codix_ca.core.regs.Q1;
		assign icodix_ca_core_regs_if.codix_ca_core_regs_Q2 = HDL_DUT_U.codix_ca.core.regs.Q2;
		assign icodix_ca_core_main_instr_hw_instr_hw_if.codix_ca_core_main_instr_hw_instr_hw_ACT = HDL_DUT_U.codix_ca.core.main_instr_hw_instr_hw.ACT;
		assign icodix_ca_core_main_instr_hw_instr_hw_if.codix_ca_core_main_instr_hw_instr_hw_id_instr_Q0 = HDL_DUT_U.codix_ca.core.main_instr_hw_instr_hw.id_instr_Q0;
		assign icodix_ca_mem_if.codix_ca_mem_RA0 = HDL_DUT_U.codix_ca.mem.RA0;
		assign icodix_ca_mem_if.codix_ca_mem_RE0 = HDL_DUT_U.codix_ca.mem.RE0;
		assign icodix_ca_mem_if.codix_ca_mem_RSC0 = HDL_DUT_U.codix_ca.mem.RSC0;
		assign icodix_ca_mem_if.codix_ca_mem_RSI0 = HDL_DUT_U.codix_ca.mem.RSI0;
		assign icodix_ca_mem_if.codix_ca_mem_RA1 = HDL_DUT_U.codix_ca.mem.RA1;
		assign icodix_ca_mem_if.codix_ca_mem_RE1 = HDL_DUT_U.codix_ca.mem.RE1;
		assign icodix_ca_mem_if.codix_ca_mem_RSC1 = HDL_DUT_U.codix_ca.mem.RSC1;
		assign icodix_ca_mem_if.codix_ca_mem_RSI1 = HDL_DUT_U.codix_ca.mem.RSI1;
		assign icodix_ca_mem_if.codix_ca_mem_D0 = HDL_DUT_U.codix_ca.mem.D0;
		assign icodix_ca_mem_if.codix_ca_mem_WE0 = HDL_DUT_U.codix_ca.mem.WE0;
		assign icodix_ca_mem_if.codix_ca_mem_WA0 = HDL_DUT_U.codix_ca.mem.WA0;
		assign icodix_ca_mem_if.codix_ca_mem_WSC0 = HDL_DUT_U.codix_ca.mem.WSC0;
		assign icodix_ca_mem_if.codix_ca_mem_WSI0 = HDL_DUT_U.codix_ca.mem.WSI0;
		assign icodix_ca_mem_if.codix_ca_mem_Q0 = HDL_DUT_U.codix_ca.mem.Q0;
		assign icodix_ca_mem_if.codix_ca_mem_RR0 = HDL_DUT_U.codix_ca.mem.RR0;
		assign icodix_ca_mem_if.codix_ca_mem_FR0 = HDL_DUT_U.codix_ca.mem.FR0;
		assign icodix_ca_mem_if.codix_ca_mem_Q1 = HDL_DUT_U.codix_ca.mem.Q1;
		assign icodix_ca_mem_if.codix_ca_mem_RR1 = HDL_DUT_U.codix_ca.mem.RR1;
		assign icodix_ca_mem_if.codix_ca_mem_FR1 = HDL_DUT_U.codix_ca.mem.FR1;
		assign icodix_ca_mem_if.codix_ca_mem_RW0 = HDL_DUT_U.codix_ca.mem.RW0;
		assign icodix_ca_mem_if.codix_ca_mem_FW0 = HDL_DUT_U.codix_ca.mem.FW0;
		assign ihalt_if.codix_ca_core_main_controller_main_halt_halt_fu_semantics_ACT = HDL_DUT_U.codix_ca.core.main_controller.main_halt_halt_fu_semantics_ACT;
		assign icodix_ca_out_if.codix_ca_port_halt = HDL_DUT_U.codix_ca.port_halt;
		assign icodix_ca_out_if.codix_ca_port_output = HDL_DUT_U.codix_ca.port_output;
		assign icodix_ca_out_if.codix_ca_port_output_en = HDL_DUT_U.codix_ca.port_output_en;
		assign icodix_ca_out_if.codix_ca_port_error = HDL_DUT_U.codix_ca.port_error;
		// assign content of register file 'regs'
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[0] = HDL_DUT_U.codix_ca.core.regs.memory_0[0];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[1] = HDL_DUT_U.codix_ca.core.regs.memory_0[1];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[2] = HDL_DUT_U.codix_ca.core.regs.memory_0[2];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[3] = HDL_DUT_U.codix_ca.core.regs.memory_0[3];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[4] = HDL_DUT_U.codix_ca.core.regs.memory_0[4];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[5] = HDL_DUT_U.codix_ca.core.regs.memory_0[5];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[6] = HDL_DUT_U.codix_ca.core.regs.memory_0[6];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[7] = HDL_DUT_U.codix_ca.core.regs.memory_0[7];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[8] = HDL_DUT_U.codix_ca.core.regs.memory_0[8];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[9] = HDL_DUT_U.codix_ca.core.regs.memory_0[9];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[10] = HDL_DUT_U.codix_ca.core.regs.memory_0[10];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[11] = HDL_DUT_U.codix_ca.core.regs.memory_0[11];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[12] = HDL_DUT_U.codix_ca.core.regs.memory_0[12];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[13] = HDL_DUT_U.codix_ca.core.regs.memory_0[13];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[14] = HDL_DUT_U.codix_ca.core.regs.memory_0[14];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[15] = HDL_DUT_U.codix_ca.core.regs.memory_0[15];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[16] = HDL_DUT_U.codix_ca.core.regs.memory_0[16];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[17] = HDL_DUT_U.codix_ca.core.regs.memory_0[17];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[18] = HDL_DUT_U.codix_ca.core.regs.memory_0[18];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[19] = HDL_DUT_U.codix_ca.core.regs.memory_0[19];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[20] = HDL_DUT_U.codix_ca.core.regs.memory_0[20];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[21] = HDL_DUT_U.codix_ca.core.regs.memory_0[21];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[22] = HDL_DUT_U.codix_ca.core.regs.memory_0[22];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[23] = HDL_DUT_U.codix_ca.core.regs.memory_0[23];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[24] = HDL_DUT_U.codix_ca.core.regs.memory_0[24];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[25] = HDL_DUT_U.codix_ca.core.regs.memory_0[25];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[26] = HDL_DUT_U.codix_ca.core.regs.memory_0[26];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[27] = HDL_DUT_U.codix_ca.core.regs.memory_0[27];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[28] = HDL_DUT_U.codix_ca.core.regs.memory_0[28];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[29] = HDL_DUT_U.codix_ca.core.regs.memory_0[29];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[30] = HDL_DUT_U.codix_ca.core.regs.memory_0[30];
		assign icodix_ca_core_regs_if.codix_ca_core_regs_init[31] = HDL_DUT_U.codix_ca.core.regs.memory_0[31];
	end
endmodule : DUT