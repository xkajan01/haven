--
-- fl_fork_1to4.vhd: Four port wrapper for fork component for Frame link
-- Copyright (C) 2007 CESNET
-- Author(s): Vlastimil Kosar <xkosar02@stud.fit.vutbr.cz>
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
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- library containing log2 function
use work.math_pack.all;


-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity FL_FORK_1TO4 is
   generic(
       DATA_WIDTH:   integer:=32
   );
   port(
       -- Common interface
      RESET          : in  std_logic;
      CLK            : in  std_logic;

      -- Frame link input interface
      RX_DATA        : in std_logic_vector(DATA_WIDTH-1 downto 0);
      RX_REM         : in std_logic_vector(log2(DATA_WIDTH/8)-1 downto 0);
      RX_SOF_N       : in std_logic;
      RX_EOF_N       : in std_logic;
      RX_SOP_N       : in std_logic;
      RX_EOP_N       : in std_logic;
      RX_SRC_RDY_N   : in std_logic;
      RX_DST_RDY_N   : out  std_logic;

      -- Frame link output interfaces
      -- Interface 0
      TX0_DATA        : out std_logic_vector(DATA_WIDTH-1 downto 0);
      TX0_REM         : out std_logic_vector(log2(DATA_WIDTH/8)-1 downto 0);
      TX0_SOF_N       : out std_logic;
      TX0_EOF_N       : out std_logic;
      TX0_SOP_N       : out std_logic;
      TX0_EOP_N       : out std_logic;
      TX0_SRC_RDY_N   : out std_logic;
      TX0_DST_RDY_N   : in  std_logic;

      -- Interface 1
      TX1_DATA        : out std_logic_vector(DATA_WIDTH-1 downto 0);
      TX1_REM         : out std_logic_vector(log2(DATA_WIDTH/8)-1 downto 0);
      TX1_SOF_N       : out std_logic;
      TX1_EOF_N       : out std_logic;
      TX1_SOP_N       : out std_logic;
      TX1_EOP_N       : out std_logic;
      TX1_SRC_RDY_N   : out std_logic;
      TX1_DST_RDY_N   : in  std_logic;

      -- Interface 2
      TX2_DATA        : out std_logic_vector(DATA_WIDTH-1 downto 0);
      TX2_REM         : out std_logic_vector(log2(DATA_WIDTH/8)-1 downto 0);
      TX2_SOF_N       : out std_logic;
      TX2_EOF_N       : out std_logic;
      TX2_SOP_N       : out std_logic;
      TX2_EOP_N       : out std_logic;
      TX2_SRC_RDY_N   : out std_logic;
      TX2_DST_RDY_N   : in  std_logic;
      
      -- Interface 3
      TX3_DATA        : out std_logic_vector(DATA_WIDTH-1 downto 0);
      TX3_REM         : out std_logic_vector(log2(DATA_WIDTH/8)-1 downto 0);
      TX3_SOF_N       : out std_logic;
      TX3_EOF_N       : out std_logic;
      TX3_SOP_N       : out std_logic;
      TX3_EOP_N       : out std_logic;
      TX3_SRC_RDY_N   : out std_logic;
      TX3_DST_RDY_N   : in  std_logic
     );
end entity FL_FORK_1TO4;

-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture FL_FORK_1TO4_ARCH of FL_FORK_1TO4 is

-- constants and singnals
constant OUTPUT_PORTS: integer:=4;
signal TX_DATA        : std_logic_vector(OUTPUT_PORTS*DATA_WIDTH-1 downto 0);
signal TX_REM         : std_logic_vector(OUTPUT_PORTS*log2(DATA_WIDTH/8)-1 downto 0);
signal TX_SOF_N       : std_logic_vector(OUTPUT_PORTS-1 downto 0);
signal TX_EOF_N       : std_logic_vector(OUTPUT_PORTS-1 downto 0);
signal TX_SOP_N       : std_logic_vector(OUTPUT_PORTS-1 downto 0);
signal TX_EOP_N       : std_logic_vector(OUTPUT_PORTS-1 downto 0);
signal TX_SRC_RDY_N   : std_logic_vector(OUTPUT_PORTS-1 downto 0);
signal TX_DST_RDY_N   : std_logic_vector(OUTPUT_PORTS-1 downto 0);

begin

-- FL_FORK entity instance
  fl_fork: entity work.FL_FORK
  generic map(
       DATA_WIDTH=>DATA_WIDTH,
       OUTPUT_PORTS=>OUTPUT_PORTS
   )
   port map(
       -- Common interface
      RESET=>RESET,
      CLK=>CLK,

      -- Frame link input interface
      RX_DATA=>RX_DATA,
      RX_REM=>RX_REM,
      RX_SOF_N=>RX_SOF_N,
      RX_EOF_N=>RX_EOF_N,
      RX_SOP_N=>RX_SOP_N,
      RX_EOP_N=>RX_EOP_N,
      RX_SRC_RDY_N=>RX_SRC_RDY_N,
      RX_DST_RDY_N=>RX_DST_RDY_N,

      -- Frame link concentrated interface
      TX_DATA=>TX_DATA,
      TX_REM=>TX_REM,      
      TX_SOF_N=>TX_SOF_N,       
      TX_EOF_N=>TX_EOF_N,       
      TX_SOP_N=>TX_SOP_N,       
      TX_EOP_N=>TX_EOP_N,       
      TX_SRC_RDY_N=>TX_SRC_RDY_N,
      TX_DST_RDY_N=>TX_DST_RDY_N   
     );

-- signal mapping for output port 0
  TX0_DATA<=TX_DATA(DATA_WIDTH-1 downto 0);
  TX0_REM<=TX_REM(log2(DATA_WIDTH/8)-1 downto 0);
  TX0_SOF_N<=TX_SOF_N(0);
  TX0_EOF_N<=TX_EOF_N(0);
  TX0_SOP_N<=TX_SOP_N(0);
  TX0_EOP_N<=TX_EOP_N(0);
  TX0_SRC_RDY_N<=TX_SRC_RDY_N(0);
  TX_DST_RDY_N(0)<=TX0_DST_RDY_N;

-- signal mapping for output port 1
  TX1_DATA<=TX_DATA(2*DATA_WIDTH-1 downto DATA_WIDTH);
  TX1_REM<=TX_REM(2*log2(DATA_WIDTH/8)-1 downto log2(DATA_WIDTH/8));
  TX1_SOF_N<=TX_SOF_N(1);
  TX1_EOF_N<=TX_EOF_N(1);
  TX1_SOP_N<=TX_SOP_N(1);
  TX1_EOP_N<=TX_EOP_N(1);
  TX1_SRC_RDY_N<=TX_SRC_RDY_N(1);
  TX_DST_RDY_N(1)<=TX1_DST_RDY_N;

-- signal mapping for output port 2
  TX2_DATA<=TX_DATA(3*DATA_WIDTH-1 downto 2*DATA_WIDTH);
  TX2_REM<=TX_REM(3*log2(DATA_WIDTH/8)-1 downto 2*log2(DATA_WIDTH/8));
  TX2_SOF_N<=TX_SOF_N(2);
  TX2_EOF_N<=TX_EOF_N(2);
  TX2_SOP_N<=TX_SOP_N(2);
  TX2_EOP_N<=TX_EOP_N(2);
  TX2_SRC_RDY_N<=TX_SRC_RDY_N(2);
  TX_DST_RDY_N(2)<=TX2_DST_RDY_N;

-- signal mapping for output port 3
  TX3_DATA<=TX_DATA(4*DATA_WIDTH-1 downto 3*DATA_WIDTH);
  TX3_REM<=TX_REM(4*log2(DATA_WIDTH/8)-1 downto 3*log2(DATA_WIDTH/8));
  TX3_SOF_N<=TX_SOF_N(3);
  TX3_EOF_N<=TX_EOF_N(3);
  TX3_SOP_N<=TX_SOP_N(3);
  TX3_EOP_N<=TX_EOP_N(3);
  TX3_SRC_RDY_N<=TX_SRC_RDY_N(3);
  TX_DST_RDY_N(3)<=TX3_DST_RDY_N;

end architecture FL_FORK_1TO4_ARCH;
