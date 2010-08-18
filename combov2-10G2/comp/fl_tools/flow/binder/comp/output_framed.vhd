-- output_framed.vhd: Output block for FrameLink Binder
-- Copyright (C) 2007 CESNET
-- Author(s):  Martin Kosek   <kosek@liberouter.org>
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions
-- are met:
-- 1. Redistributions of source code must retain the above copyright
--    notice, this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright
--    notice, this list of conditions and the following disclaimer in
--    the documentation and/or other materials provided with the
--    distribution.
-- 3. Neither the name of the Company nor the names of its contributors
--    may be used to endorse or promote products derived from this
--    software without specific prior written permission.
--
-- This software is provided ``as is'', and any express or implied
-- warranties, including, but not limited to, the implied warranties of
-- merchantability and fitness for a particular purpose are disclaimed.
-- In no event shall the company or contributors be liable for any
-- direct, indirect, incidental, special, exemplary, or consequential
-- damages (including, but not limited to, procurement of substitute
-- goods or services; loss of use, data, or profits; or business
-- interruption) however caused and on any theory of liability, whether
-- in contract, strict liability, or tort (including negligence or
-- otherwise) arising in any way out of the use of this software, even
-- if advised of the possibility of such damage.
--
-- $Id$
--
--
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

-- library containing log2 function
use work.math_pack.all;

-- Binder declarations
use work.fl_binder_decl.all;

-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture framed of FLB_OUTPUT is

   -- ------------------ Constants declaration --------------------------------
   constant CNT_NEXT_MAX      : std_logic_vector(log2(COUNT)-1 downto 0)
                              := conv_std_logic_vector(COUNT-1, log2(COUNT));

   -- ------------------ Signals declaration ----------------------------------
   -- FSM signals
   signal fsm_eof             : std_logic;
   signal fsm_queue_rdy       : std_logic;
   signal fsm_empty           : std_logic;
   signal fsm_set_valid       : std_logic;
   signal fsm_clr_valid       : std_logic;
   signal fsm_clr_ready       : std_logic;
   signal fsm_next_queue      : std_logic;

   -- counters
   signal cnt_next           : std_logic_vector(log2(COUNT)-1 downto 0);
   signal cnt_next_ce        : std_logic;
   signal cmp_cnt_next_max   : std_logic;

   -- registers
   signal reg_addr           : std_logic_vector(log2(COUNT)-1 downto 0);
   signal reg_addr_we        : std_logic;
   signal reg_next           : std_logic_vector(log2(COUNT)-1 downto 0);
   signal reg_next_we        : std_logic;
   signal reg_valid          : std_logic;
   signal reg_valid_we       : std_logic;
   signal reg_valid_clr      : std_logic;
   signal reg_ready          : std_logic;
   signal reg_ready_we       : std_logic;
   signal reg_ready_clr      : std_logic;

   -- other
   signal queue_chosen       : std_logic;
   signal mx_queue_choosing  : std_logic;
   signal mx_frame_rdy       : std_logic;
   signal fifo_empty         : std_logic_vector(log2(1) downto 0);
   signal dv                 : std_logic;
   signal rx_dst_rdy_n_i     : std_logic;
   signal chosen_queue_empty : std_logic;
  
begin
   -- ------------------ Directly mapped signals ------------------------------
   cnt_next_ce       <= not reg_ready or fsm_next_queue;
   rx_dst_rdy_n_i    <= not (reg_valid and (not TX_DST_RDY_N));
   dv                <= not (RX_SRC_RDY_N or rx_dst_rdy_n_i);

   mx_queue_choosing <= mx_frame_rdy;
   queue_chosen      <= mx_queue_choosing and (not fifo_empty(0));

   -- FSM input signals
   fsm_eof           <= (not RX_EOF_N) and dv;
   fsm_queue_rdy     <= reg_ready;
   fsm_empty         <= chosen_queue_empty;

   -- Output interface mapping
   IFC               <= reg_addr;
   TX_SRC_RDY_N      <= not (reg_valid and (not RX_SRC_RDY_N));
   RX_DST_RDY_N      <= rx_dst_rdy_n_i;

   TX_SOF_N          <= RX_SOF_N;
   TX_SOP_N          <= RX_SOP_N;
   TX_EOP_N          <= RX_EOP_N;
   TX_EOF_N          <= RX_EOF_N;
   TX_DATA           <= RX_DATA;
   TX_REM            <= RX_REM;

   -- register control signals
   reg_addr_we       <= fsm_next_queue;
   reg_next_we       <= queue_chosen and ((not reg_ready) or fsm_next_queue);
   reg_valid_we      <= fsm_set_valid;
   reg_valid_clr     <= fsm_clr_valid;
   reg_ready_clr     <= fsm_clr_ready;
   reg_ready_we      <= reg_next_we;

   -- FSM mapping
   FLB_OUTPUT_FSM_I : entity work.FLB_OUTPUT_FSM
      generic map(
         QUEUE_CHOOSING => QUEUE_CHOOSING
      )
      port map(
         CLK            => CLK,
         RESET          => RESET,
   
         -- input signals
         EOF            => fsm_eof,
         QUEUE_RDY      => fsm_queue_rdy,
         EMPTY          => fsm_empty,
   
         -- output signals
         SET_VALID      => fsm_set_valid,
         CLR_VALID      => fsm_clr_valid,
         CLR_READY      => fsm_clr_ready,
         NEXT_QUEUE     => fsm_next_queue
      );

   -- generic multiplexer mapping
   EMPTY_MUX : entity work.GEN_MUX
      generic map(
         DATA_WIDTH  => 1,
         MUX_WIDTH   => COUNT
      )
      port map(
         DATA_IN     => EMPTY,
         SEL         => cnt_next,
         DATA_OUT    => fifo_empty
      );

   -- generic multiplexer mapping
   NEXT_QUEUE_EMPTY_MUX : entity work.GEN_MUX
      generic map(
         DATA_WIDTH  => 1,
         MUX_WIDTH   => COUNT
      )
      port map(
         DATA_IN     => EMPTY,
         SEL         => reg_addr,
         DATA_OUT(0) => chosen_queue_empty
      );

   -- generic multiplexer mapping
   MX_FRAME_RDY_MUX : entity work.GEN_MUX
      generic map(
         DATA_WIDTH  => 1,
         MUX_WIDTH   => COUNT
      )
      port map(
         DATA_IN     => FRAME_RDY,
         SEL         => cnt_next,
         DATA_OUT(0) => mx_frame_rdy
      );

   -- ------------------ Counter cnt_next -------------------------------------
   cnt_nextp: process (CLK)
   begin
      if CLK='1' and CLK'event then
         if (RESET = '1') then 
            cnt_next <= (others => '0');
         elsif cnt_next_ce = '1' then
            if (cmp_cnt_next_max = '1') then
               cnt_next <= (others => '0');
            else
               cnt_next <= cnt_next + 1;
            end if;
         end if;
      end if;
   end process;

   -- detect maximal value of address counter so that we can clear it
   cmp_cnt_next_maxp: process(cnt_next)
   begin
      if(cnt_next = CNT_NEXT_MAX) then
         cmp_cnt_next_max <= '1';
      else
         cmp_cnt_next_max <= '0';
      end if;
   end process;

   -- register reg_addr -------------------------------------------------------
   reg_addrp: process(CLK)
   begin
      if (CLK'event AND CLK = '1') then
         if (reg_addr_we = '1') then
            reg_addr <= reg_next;
         end if;
      end if;
   end process;

   -- register reg_next -------------------------------------------------------
   reg_nextp: process(CLK)
   begin
      if (CLK'event AND CLK = '1') then
         if (reg_next_we = '1') then
            reg_next <= cnt_next;
         end if;
      end if;
   end process;

   -- register reg_valid ------------------------------------------------------
   reg_validp: process(CLK)
   begin
      if (CLK'event AND CLK = '1') then
         if (RESET = '1' or reg_valid_clr = '1') then
            reg_valid <= '0';
         elsif (reg_valid_we = '1') then
            reg_valid <= fsm_set_valid;
         end if;
      end if;
   end process;

   -- register reg_ready ------------------------------------------------------
   reg_readyp: process(CLK)
   begin
      if (CLK'event AND CLK = '1') then
         if (RESET = '1' or reg_ready_clr = '1') then
            reg_ready <= '0';
         elsif (reg_ready_we = '1') then
            reg_ready <= '1';
         end if;
      end if;
   end process;
   
end architecture framed;
