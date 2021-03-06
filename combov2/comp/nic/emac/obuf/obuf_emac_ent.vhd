-- obuf_emac_ent.vhd: Output buffer for EMAC - entity
--
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
-- TODO: 8-bit version not tested in functional simulations!
--
--

library IEEE;
use IEEE.std_logic_1164.all;
use work.math_pack.all;
use work.emac_pkg.all;

-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity obuf_emac is

   generic (
      DATA_PATHS : integer := 2;
      DFIFO_SIZE : integer := 4095;
      SFIFO_SIZE : integer := 127;

      CTRL_CMD   : boolean := false;

      -- EMAC#_USECLKEN generic
      USECLKEN       : boolean
   );
   port (
      RESET      : in  std_logic;

      -- FrameLink input interface
      WRCLK      : in  std_logic;
      DATA       : in std_logic_vector((DATA_PATHS*8)-1 downto 0);
      DREM       : in std_logic_vector(log2(DATA_PATHS)-1 downto 0);
      SRC_RDY_N  : in std_logic;
      SOF_N      : in std_logic;
      SOP_N      : in std_logic;
      EOF_N      : in std_logic;
      EOP_N      : in std_logic;
      DST_RDY_N  : out std_logic;

      -- Transmit interface
      EMAC_CLK       : in std_logic;
      EMAC_CE        : in std_logic;
      TX_EMAC_D            : out std_logic_vector(7 downto 0);
      TX_EMAC_DVLD         : out std_logic;
      TX_EMAC_ACK          : in  std_logic;
      TX_EMAC_FIRSTBYTE    : out std_logic;
      TX_EMAC_UNDERRUN     : out std_logic;
      TX_EMAC_COLLISION    : in  std_logic;
      TX_EMAC_RETRANSMIT   : in  std_logic;
      TX_EMAC_IFGDELAY     : out std_logic_vector(7 downto 0);
      TX_EMAC_STATS        : in  std_logic;
      TX_EMAC_STATSVLD     : in  std_logic;
      TX_EMAC_STATSBYTEVLD : in  std_logic;
      TX_EMAC_SPEEDIS10100 : in  std_logic;

      -- address decoder interface
      ADC_CLK    : out std_logic;
      ADC_RD     : in  std_logic;
      ADC_WR     : in  std_logic;
      ADC_ADDR   : in  std_logic_vector(5 downto 0); -- 32bit addressable words
      ADC_DI     : in  std_logic_vector(31 downto 0);
      ADC_DO     : out std_logic_vector(31 downto 0);
      ADC_DRDY   : out std_logic
   );

end entity obuf_emac;

