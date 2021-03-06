-- dma_2x128b_rx.vhd: DMA Module for 2x128 RX interface
-- Copyright (C) 2008 CESNET
-- Author(s):  Pavol Korcek <korcek@liberouter.org>
--             Martin Kosek <kosek@liberouter.org>
--             Jan Vozenilek <xvozen00@stud.fit.vutbr.cz>
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.math_pack.all;

use work.fl_pkg.all;

use work.dma_mod_2x128b_rx_const.all;

-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of DMA_MOD_2x128b_RX is

signal fl_pipe_transformer_input_rx0_data     : std_logic_vector(127 downto 0);
signal fl_pipe_transformer_input_rx0_drem     : std_logic_vector(3 downto 0);
signal fl_pipe_transformer_input_rx0_sop_n    : std_logic;
signal fl_pipe_transformer_input_rx0_eop_n    : std_logic;
signal fl_pipe_transformer_input_rx0_sof_n    : std_logic;
signal fl_pipe_transformer_input_rx0_eof_n    : std_logic;
signal fl_pipe_transformer_input_rx0_src_rdy_n: std_logic;
signal fl_pipe_transformer_input_rx0_dst_rdy_n: std_logic;

signal fl_pipe_transformer_input_tx0_data     : std_logic_vector(127 downto 0);
signal fl_pipe_transformer_input_tx0_drem     : std_logic_vector(3 downto 0);
signal fl_pipe_transformer_input_tx0_sop_n    : std_logic;
signal fl_pipe_transformer_input_tx0_eop_n    : std_logic;
signal fl_pipe_transformer_input_tx0_sof_n    : std_logic;
signal fl_pipe_transformer_input_tx0_eof_n    : std_logic;
signal fl_pipe_transformer_input_tx0_src_rdy_n: std_logic;
signal fl_pipe_transformer_input_tx0_dst_rdy_n: std_logic;

signal fl_pipe_transformer_input_rx1_data     : std_logic_vector(127 downto 0);
signal fl_pipe_transformer_input_rx1_drem     : std_logic_vector(3 downto 0);
signal fl_pipe_transformer_input_rx1_sop_n    : std_logic;
signal fl_pipe_transformer_input_rx1_eop_n    : std_logic;
signal fl_pipe_transformer_input_rx1_sof_n    : std_logic;
signal fl_pipe_transformer_input_rx1_eof_n    : std_logic;
signal fl_pipe_transformer_input_rx1_src_rdy_n: std_logic;
signal fl_pipe_transformer_input_rx1_dst_rdy_n: std_logic;

signal fl_pipe_transformer_input_tx1_data     : std_logic_vector(127 downto 0);
signal fl_pipe_transformer_input_tx1_drem     : std_logic_vector(3 downto 0);
signal fl_pipe_transformer_input_tx1_sop_n    : std_logic;
signal fl_pipe_transformer_input_tx1_eop_n    : std_logic;
signal fl_pipe_transformer_input_tx1_sof_n    : std_logic;
signal fl_pipe_transformer_input_tx1_eof_n    : std_logic;
signal fl_pipe_transformer_input_tx1_src_rdy_n: std_logic;
signal fl_pipe_transformer_input_tx1_dst_rdy_n: std_logic;

signal fl_pipe_transformer_output_rx0_data     : std_logic_vector(63 downto 0);
signal fl_pipe_transformer_output_rx0_drem     : std_logic_vector(2 downto 0);
signal fl_pipe_transformer_output_rx0_sop_n    : std_logic;
signal fl_pipe_transformer_output_rx0_eop_n    : std_logic;
signal fl_pipe_transformer_output_rx0_sof_n    : std_logic;
signal fl_pipe_transformer_output_rx0_eof_n    : std_logic;
signal fl_pipe_transformer_output_rx0_src_rdy_n: std_logic;
signal fl_pipe_transformer_output_rx0_dst_rdy_n: std_logic;

signal fl_pipe_transformer_output_tx0_data     : std_logic_vector(63 downto 0);
signal fl_pipe_transformer_output_tx0_drem     : std_logic_vector(2 downto 0);
signal fl_pipe_transformer_output_tx0_sop_n    : std_logic;
signal fl_pipe_transformer_output_tx0_eop_n    : std_logic;
signal fl_pipe_transformer_output_tx0_sof_n    : std_logic;
signal fl_pipe_transformer_output_tx0_eof_n    : std_logic;
signal fl_pipe_transformer_output_tx0_src_rdy_n: std_logic;
signal fl_pipe_transformer_output_tx0_dst_rdy_n: std_logic;

signal fl_pipe_transformer_output_rx1_data     : std_logic_vector(63 downto 0);
signal fl_pipe_transformer_output_rx1_drem     : std_logic_vector(2 downto 0);
signal fl_pipe_transformer_output_rx1_sop_n    : std_logic;
signal fl_pipe_transformer_output_rx1_eop_n    : std_logic;
signal fl_pipe_transformer_output_rx1_sof_n    : std_logic;
signal fl_pipe_transformer_output_rx1_eof_n    : std_logic;
signal fl_pipe_transformer_output_rx1_src_rdy_n: std_logic;
signal fl_pipe_transformer_output_rx1_dst_rdy_n: std_logic;

signal fl_pipe_transformer_output_tx1_data     : std_logic_vector(63 downto 0);
signal fl_pipe_transformer_output_tx1_drem     : std_logic_vector(2 downto 0);
signal fl_pipe_transformer_output_tx1_sop_n    : std_logic;
signal fl_pipe_transformer_output_tx1_eop_n    : std_logic;
signal fl_pipe_transformer_output_tx1_sof_n    : std_logic;
signal fl_pipe_transformer_output_tx1_eof_n    : std_logic;
signal fl_pipe_transformer_output_tx1_src_rdy_n: std_logic;
signal fl_pipe_transformer_output_tx1_dst_rdy_n: std_logic;

begin
   RX_BUFFERS_I : entity work.RX_BUFFERS_2x64b
      generic map(
         -- number of network interfaces
         NET_IFC_COUNT              => 2,
         -- RX/TX Buffer generics
         BLOCK_SIZE                 => RXTX_BLOCK_SIZE,
         RXTXBUF_IFC_TOTAL_SIZE     => RXTX_IFC_TOTAL_SIZE,
         -- DMA Controller generics
         BUFFER_ADDR                => RXTX_BUFFER_ADDR,
         BUFFER_SIZE                => RXTX_BUFFER_SIZE,
         DESC_BLOCK_SIZE            => RXTX_OPT_DESC_BLOCK_SIZE,
         DESC_BASE_ADDR             => RXTX_DESC_BASE_ADDR,
         -- Internal Bus Endpoint generics
         IB_EP_CONNECTED_TO         => IB_EP_CONNECTED_TO,
         IB_EP_ENDPOINT_BASE        => IB_EP_ENDPOINT_BASE,
         IB_EP_ENDPOINT_LIMIT       => IB_EP_ENDPOINT_LIMIT,
         IB_EP_STRICT_ORDER         => IB_EP_STRICT_ORDER,
         IB_EP_DATA_REORDER         => IB_EP_DATA_REORDER,
         IB_EP_READ_IN_PROCESS      => IB_EP_READ_IN_PROCESS,
         IB_EP_INPUT_BUFFER_SIZE    => IB_EP_INPUT_BUFFER_SIZE,
         IB_EP_OUTPUT_BUFFER_SIZE   => IB_EP_OUTPUT_BUFFER_SIZE
      )
      port map(
         -- Common interface
         CLK            => CLK,
         RESET          => RESET,
         RX_INTERRUPT   => RX_INTERRUPT,
         -- network interfaces interface
         -- input FrameLink interface
         RX_SOF_N(0)             => fl_pipe_transformer_output_tx0_sof_n,
         RX_SOF_N(1)             => fl_pipe_transformer_output_tx1_sof_n,

         RX_SOP_N(0)             => fl_pipe_transformer_output_tx0_sop_n,
         RX_SOP_N(1)             => fl_pipe_transformer_output_tx1_sop_n,

         RX_EOP_N(0)             => fl_pipe_transformer_output_tx0_eop_n,
         RX_EOP_N(1)             => fl_pipe_transformer_output_tx1_eop_n,

         RX_EOF_N(0)             => fl_pipe_transformer_output_tx0_eof_n,
         RX_EOF_N(1)             => fl_pipe_transformer_output_tx1_eof_n,

         RX_SRC_RDY_N(0)         => fl_pipe_transformer_output_tx0_src_rdy_n,
         RX_SRC_RDY_N(1)         => fl_pipe_transformer_output_tx1_src_rdy_n,

         RX_DST_RDY_N(0)         => fl_pipe_transformer_output_tx0_dst_rdy_n,
         RX_DST_RDY_N(1)         => fl_pipe_transformer_output_tx1_dst_rdy_n,

         RX_DATA( 63 downto  0)  => fl_pipe_transformer_output_tx0_data,
         RX_DATA(127 downto 64)  => fl_pipe_transformer_output_tx1_data,

         RX_REM(2 downto 0)      => fl_pipe_transformer_output_tx0_drem,
         RX_REM(5 downto 3)      => fl_pipe_transformer_output_tx1_drem,

         -- Internal Bus interface
         IB_DOWN_DATA       => IB_DOWN_DATA,
         IB_DOWN_SOF_N      => IB_DOWN_SOF_N,
         IB_DOWN_EOF_N      => IB_DOWN_EOF_N,
         IB_DOWN_SRC_RDY_N  => IB_DOWN_SRC_RDY_N,
         IB_DOWN_DST_RDY_N  => IB_DOWN_DST_RDY_N,
         IB_UP_DATA         => IB_UP_DATA,
         IB_UP_SOF_N        => IB_UP_SOF_N,
         IB_UP_EOF_N        => IB_UP_EOF_N,
         IB_UP_SRC_RDY_N    => IB_UP_SRC_RDY_N,
         IB_UP_DST_RDY_N    => IB_UP_DST_RDY_N,
          
         -- MI32 interface
         MI32_DWR           => MI32_DWR,
         MI32_ADDR          => MI32_ADDR,
         MI32_RD            => MI32_RD,
         MI32_WR            => MI32_WR,
         MI32_BE            => MI32_BE,
         MI32_DRD           => MI32_DRD,
         MI32_ARDY          => MI32_ARDY,
         MI32_DRDY          => MI32_DRDY
      );

      -- Clock domain transfer: USER -> ICS (RX)
      FL_ASYNC_RX0 : entity work.fl_asfifo_cv2_128b
      port map(
         RX_CLK      => USER_CLK,
         RX_RESET    => USER_RESET,
         TX_CLK      => CLK,
         TX_RESET    => RESET,

         RX_DATA     => RX0_DATA,
         RX_REM      => RX0_DREM,
         RX_EOP_N    => RX0_EOP_N,
         RX_SOP_N    => RX0_SOP_N,
         RX_EOF_N    => RX0_EOF_N,
         RX_SOF_N    => RX0_SOF_N,
         RX_SRC_RDY_N=> RX0_SRC_RDY_N,
         RX_DST_RDY_N=> RX0_DST_RDY_N,

         TX_DATA     => fl_pipe_transformer_input_rx0_data,
         TX_REM      => fl_pipe_transformer_input_rx0_drem,
         TX_EOP_N    => fl_pipe_transformer_input_rx0_eop_n,
         TX_SOP_N    => fl_pipe_transformer_input_rx0_sop_n,
         TX_EOF_N    => fl_pipe_transformer_input_rx0_eof_n,
         TX_SOF_N    => fl_pipe_transformer_input_rx0_sof_n,
         TX_SRC_RDY_N=> fl_pipe_transformer_input_rx0_src_rdy_n,
         TX_DST_RDY_N=> fl_pipe_transformer_input_rx0_dst_rdy_n
      );

      FL_ASYNC_RX1 : entity work.fl_asfifo_cv2_128b
      port map(
         RX_CLK      => USER_CLK,
         RX_RESET    => USER_RESET,
         TX_CLK      => CLK,
         TX_RESET    => RESET,

         RX_DATA     => RX1_DATA,
         RX_REM      => RX1_DREM,
         RX_EOP_N    => RX1_EOP_N,
         RX_SOP_N    => RX1_SOP_N,
         RX_EOF_N    => RX1_EOF_N,
         RX_SOF_N    => RX1_SOF_N,
         RX_SRC_RDY_N=> RX1_SRC_RDY_N,
         RX_DST_RDY_N=> RX1_DST_RDY_N,

         TX_DATA     => fl_pipe_transformer_input_rx1_data,
         TX_REM      => fl_pipe_transformer_input_rx1_drem,
         TX_EOP_N    => fl_pipe_transformer_input_rx1_eop_n,
         TX_SOP_N    => fl_pipe_transformer_input_rx1_sop_n,
         TX_EOF_N    => fl_pipe_transformer_input_rx1_eof_n,
         TX_SOF_N    => fl_pipe_transformer_input_rx1_sof_n,
         TX_SRC_RDY_N=> fl_pipe_transformer_input_rx1_src_rdy_n,
         TX_DST_RDY_N=> fl_pipe_transformer_input_rx1_dst_rdy_n
      );

   FL_PIPE_INPUT0_I: entity work.FL_PIPE
      generic map(
         DATA_WIDTH     => 128,
         USE_OUTREG     => true
      )
      port map(
         -- Common interface 
         CLK            => CLK,
         RESET          => RESET,

         -- Input interface
         RX_SOF_N       => fl_pipe_transformer_input_rx0_sof_n,
         RX_SOP_N       => fl_pipe_transformer_input_rx0_sop_n,
         RX_EOP_N       => fl_pipe_transformer_input_rx0_eop_n,
         RX_EOF_N       => fl_pipe_transformer_input_rx0_eof_n,
         RX_SRC_RDY_N   => fl_pipe_transformer_input_rx0_src_rdy_n,
         RX_DST_RDY_N   => fl_pipe_transformer_input_rx0_dst_rdy_n,
         RX_DATA        => fl_pipe_transformer_input_rx0_data,
         RX_REM         => fl_pipe_transformer_input_rx0_drem,

         -- Output interface
         TX_SOF_N       => fl_pipe_transformer_input_tx0_sof_n,
         TX_EOP_N       => fl_pipe_transformer_input_tx0_eop_n,
         TX_SOP_N       => fl_pipe_transformer_input_tx0_sop_n,
         TX_EOF_N       => fl_pipe_transformer_input_tx0_eof_n,
         TX_SRC_RDY_N   => fl_pipe_transformer_input_tx0_src_rdy_n,
         TX_DST_RDY_N   => fl_pipe_transformer_input_tx0_dst_rdy_n,
         TX_DATA        => fl_pipe_transformer_input_tx0_data,
         TX_REM         => fl_pipe_transformer_input_tx0_drem
      );

   FL_PIPE_INPUT1_I: entity work.FL_PIPE
      generic map(
         DATA_WIDTH     => 128,
         USE_OUTREG     => true
      )
      port map(
         -- Common interface 
         CLK            => CLK,
         RESET          => RESET,

         -- Input interface
         RX_SOF_N       => fl_pipe_transformer_input_rx1_sof_n,
         RX_SOP_N       => fl_pipe_transformer_input_rx1_sop_n,
         RX_EOP_N       => fl_pipe_transformer_input_rx1_eop_n,
         RX_EOF_N       => fl_pipe_transformer_input_rx1_eof_n,
         RX_SRC_RDY_N   => fl_pipe_transformer_input_rx1_src_rdy_n,
         RX_DST_RDY_N   => fl_pipe_transformer_input_rx1_dst_rdy_n,
         RX_DATA        => fl_pipe_transformer_input_rx1_data,
         RX_REM         => fl_pipe_transformer_input_rx1_drem,

         -- Output interface
         TX_SOF_N       => fl_pipe_transformer_input_tx1_sof_n,
         TX_EOP_N       => fl_pipe_transformer_input_tx1_eop_n,
         TX_SOP_N       => fl_pipe_transformer_input_tx1_sop_n,
         TX_EOF_N       => fl_pipe_transformer_input_tx1_eof_n,
         TX_SRC_RDY_N   => fl_pipe_transformer_input_tx1_src_rdy_n,
         TX_DST_RDY_N   => fl_pipe_transformer_input_tx1_dst_rdy_n,
         TX_DATA        => fl_pipe_transformer_input_tx1_data,
         TX_REM         => fl_pipe_transformer_input_tx1_drem
      );

   FL_TRANSFORMER0_I: entity work.FL_TRANSFORMER
      generic map (
         RX_DATA_WIDTH  => 128,
         TX_DATA_WIDTH  => 64
      )
      port map (
         CLK            => CLK,
         RESET          => RESET,

         -- RX interface
         RX_DATA        => fl_pipe_transformer_input_tx0_data,
         RX_REM         => fl_pipe_transformer_input_tx0_drem,
         RX_SOF_N       => fl_pipe_transformer_input_tx0_sof_n,
         RX_SOP_N       => fl_pipe_transformer_input_tx0_sop_n,
         RX_EOP_N       => fl_pipe_transformer_input_tx0_eop_n,
         RX_EOF_N       => fl_pipe_transformer_input_tx0_eof_n,
         RX_SRC_RDY_N   => fl_pipe_transformer_input_tx0_src_rdy_n,
         RX_DST_RDY_N   => fl_pipe_transformer_input_tx0_dst_rdy_n,

         -- TX interface
         TX_DATA        => fl_pipe_transformer_output_rx0_data,
         TX_REM         => fl_pipe_transformer_output_rx0_drem,
         TX_SOF_N       => fl_pipe_transformer_output_rx0_sof_n,
         TX_SOP_N       => fl_pipe_transformer_output_rx0_sop_n,
         TX_EOP_N       => fl_pipe_transformer_output_rx0_eop_n,
         TX_EOF_N       => fl_pipe_transformer_output_rx0_eof_n,
         TX_SRC_RDY_N   => fl_pipe_transformer_output_rx0_src_rdy_n,
         TX_DST_RDY_N   => fl_pipe_transformer_output_rx0_dst_rdy_n
      );

   FL_TRANSFORMER1_I: entity work.FL_TRANSFORMER
      generic map (
         RX_DATA_WIDTH  => 128,
         TX_DATA_WIDTH  => 64
      )
      port map (
         CLK            => CLK,
         RESET          => RESET,

         -- RX interface
         RX_DATA        => fl_pipe_transformer_input_tx1_data,
         RX_REM         => fl_pipe_transformer_input_tx1_drem,
         RX_SOF_N       => fl_pipe_transformer_input_tx1_sof_n,
         RX_SOP_N       => fl_pipe_transformer_input_tx1_sop_n,
         RX_EOP_N       => fl_pipe_transformer_input_tx1_eop_n,
         RX_EOF_N       => fl_pipe_transformer_input_tx1_eof_n,
         RX_SRC_RDY_N   => fl_pipe_transformer_input_tx1_src_rdy_n,
         RX_DST_RDY_N   => fl_pipe_transformer_input_tx1_dst_rdy_n,

         -- TX interface
         TX_DATA        => fl_pipe_transformer_output_rx1_data,
         TX_REM         => fl_pipe_transformer_output_rx1_drem,
         TX_SOF_N       => fl_pipe_transformer_output_rx1_sof_n,
         TX_SOP_N       => fl_pipe_transformer_output_rx1_sop_n,
         TX_EOP_N       => fl_pipe_transformer_output_rx1_eop_n,
         TX_EOF_N       => fl_pipe_transformer_output_rx1_eof_n,
         TX_SRC_RDY_N   => fl_pipe_transformer_output_rx1_src_rdy_n,
         TX_DST_RDY_N   => fl_pipe_transformer_output_rx1_dst_rdy_n
      );

   FL_PIPE_OUTPUT0_I: entity work.FL_PIPE
      generic map(
         DATA_WIDTH     => 64,
         USE_OUTREG     => true
      )
      port map(
         -- Common interface 
         CLK            => CLK,
         RESET          => RESET,

         -- Input interface
         RX_SOF_N       => fl_pipe_transformer_output_rx0_sof_n,
         RX_SOP_N       => fl_pipe_transformer_output_rx0_sop_n,
         RX_EOP_N       => fl_pipe_transformer_output_rx0_eop_n,
         RX_EOF_N       => fl_pipe_transformer_output_rx0_eof_n,
         RX_SRC_RDY_N   => fl_pipe_transformer_output_rx0_src_rdy_n,
         RX_DST_RDY_N   => fl_pipe_transformer_output_rx0_dst_rdy_n,
         RX_DATA        => fl_pipe_transformer_output_rx0_data,
         RX_REM         => fl_pipe_transformer_output_rx0_drem,

         -- Output interface
         TX_SOF_N       => fl_pipe_transformer_output_tx0_sof_n,
         TX_EOP_N       => fl_pipe_transformer_output_tx0_eop_n,
         TX_SOP_N       => fl_pipe_transformer_output_tx0_sop_n,
         TX_EOF_N       => fl_pipe_transformer_output_tx0_eof_n,
         TX_SRC_RDY_N   => fl_pipe_transformer_output_tx0_src_rdy_n,
         TX_DST_RDY_N   => fl_pipe_transformer_output_tx0_dst_rdy_n,
         TX_DATA        => fl_pipe_transformer_output_tx0_data,
         TX_REM         => fl_pipe_transformer_output_tx0_drem
      );

   FL_PIPE_OUTPUT1_I: entity work.FL_PIPE
      generic map(
         DATA_WIDTH     => 64,
         USE_OUTREG     => true
      )
      port map(
         -- Common interface 
         CLK            => CLK,
         RESET          => RESET,

         -- Input interface
         RX_SOF_N       => fl_pipe_transformer_output_rx1_sof_n,
         RX_SOP_N       => fl_pipe_transformer_output_rx1_sop_n,
         RX_EOP_N       => fl_pipe_transformer_output_rx1_eop_n,
         RX_EOF_N       => fl_pipe_transformer_output_rx1_eof_n,
         RX_SRC_RDY_N   => fl_pipe_transformer_output_rx1_src_rdy_n,
         RX_DST_RDY_N   => fl_pipe_transformer_output_rx1_dst_rdy_n,
         RX_DATA        => fl_pipe_transformer_output_rx1_data,
         RX_REM         => fl_pipe_transformer_output_rx1_drem,

         -- Output interface
         TX_SOF_N       => fl_pipe_transformer_output_tx1_sof_n,
         TX_EOP_N       => fl_pipe_transformer_output_tx1_eop_n,
         TX_SOP_N       => fl_pipe_transformer_output_tx1_sop_n,
         TX_EOF_N       => fl_pipe_transformer_output_tx1_eof_n,
         TX_SRC_RDY_N   => fl_pipe_transformer_output_tx1_src_rdy_n,
         TX_DST_RDY_N   => fl_pipe_transformer_output_tx1_dst_rdy_n,
         TX_DATA        => fl_pipe_transformer_output_tx1_data,
         TX_REM         => fl_pipe_transformer_output_tx1_drem
      );

end architecture;
-- ----------------------------------------------------------------------------
