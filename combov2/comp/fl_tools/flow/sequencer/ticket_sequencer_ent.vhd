-- sequencer_ent.vhd: FrameLink Sequencer entity
-- Copyright (C) 2007 CESNET
-- Author(s): Libor Polcak <polcak_l@liberouter.org>
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
-- TODO:
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.math_pack.all;
use work.fifo_pkg.all;

-- ----------------------------------------------------------------------------
--                            Entity declaration
-- ----------------------------------------------------------------------------
entity FL_TICKET_SEQUENCER is
   generic(
      -- Data width of one input interface (16, 32, 64, 128 bits)
      INPUT_WIDTH          : integer := 32;
      -- Number of input interfaces
      INPUT_COUNT          : integer := 3;
      -- Output width (bits)
      OUTPUT_WIDTH         : integer := 128;
      -- Header / Footer data present
      PARTS                : integer := 3;
      -- Size of the ticket (in bits)
      TICKET_WIDTH         : integer := 12;
      -- Number of items in input ticket FIFOs
      -- TICKET_WIDTH wide
      TICKET_FIFO_ITEMS    : integer := 16;
      -- Type of memory used for ticket FIFOs
      TICKET_FIFO_TYPE     : mem_type := LUT;
      -- Generic from Binder fifo 2 nfifo with no description
      LUT_MEMORY           : boolean := false;
      -- Generic from Binder fifo 2 nfifo with no description
      LUT_BLOCK_SIZE       : integer := 512
   );
   port(
      -- Common signals
      -- clock sigal
      CLK               : in std_logic;
      -- asynchronous reset, active in '1'
      RESET             : in std_logic;

      -- input FrameLink interface
      RX_SOF_N       : in  std_logic_vector(INPUT_COUNT-1 downto 0);
      RX_SOP_N       : in  std_logic_vector(INPUT_COUNT-1 downto 0);
      RX_EOP_N       : in  std_logic_vector(INPUT_COUNT-1 downto 0);
      RX_EOF_N       : in  std_logic_vector(INPUT_COUNT-1 downto 0);
      RX_SRC_RDY_N   : in  std_logic_vector(INPUT_COUNT-1 downto 0);
      RX_DST_RDY_N   : out std_logic_vector(INPUT_COUNT-1 downto 0);
      RX_DATA        : in  std_logic_vector(INPUT_COUNT*INPUT_WIDTH-1 
                                                                     downto 0);
      RX_REM         : in  std_logic_vector(INPUT_COUNT*log2(INPUT_WIDTH/8)-1 
                                                                     downto 0);

      TICKET         : in  std_logic_vector(INPUT_COUNT*TICKET_WIDTH-1 downto 0);
      TICKET_WR      : in  std_logic_vector(INPUT_COUNT-1 downto 0);
      TICKET_FULL    : out std_logic_vector(INPUT_COUNT-1 downto 0);

      -- output FrameLink interface
      TX_SOF_N       : out std_logic;
      TX_SOP_N       : out std_logic;
      TX_EOP_N       : out std_logic;
      TX_EOF_N       : out std_logic;
      TX_SRC_RDY_N   : out std_logic;
      TX_DST_RDY_N   : in  std_logic;
      TX_DATA        : out std_logic_vector(OUTPUT_WIDTH-1 downto 0);
      TX_REM         : out std_logic_vector(log2(OUTPUT_WIDTH/8)-1 downto 0)
   ); 
end entity FL_TICKET_SEQUENCER;
