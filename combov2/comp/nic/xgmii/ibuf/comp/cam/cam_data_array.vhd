--
-- cam_data_array.vhd: Array of memory elements + filling part
-- Copyright (C) 2005-2007 CESNET
-- Author(s): Martin Kosek <xkosek00@stud.fit.vutbr.cz>
--            Libor Polcak <polcak_l@liberouter.org>
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.math_pack.all;

-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity ibuf_cam_data_array is
   generic (
      -- Data row width (bits, should be a multiple of 4)
      CAM_ROW_WIDTH     : integer;
      -- Number of data rows (depth of the CAM)
      CAM_ROW_COUNT     : integer
   );
   port (
      ADDR              : in std_logic_vector((log2(CAM_ROW_COUNT) - 1) downto 0);
      DATA_IN           : in std_logic_vector((CAM_ROW_WIDTH - 1) downto 0);
      WRITE_ENABLE      : in std_logic;
      MATCH_ENABLE      : in std_logic;
      MATCH_RST         : in std_logic;
      READ_ENABLE       : in std_logic;
      RESET             : in std_logic;
      CLK               : in std_logic;
      MATCH_BUS         : out std_logic_vector((CAM_ROW_COUNT - 1) downto 0);
      DATA_OUT          : out std_logic_vector((CAM_ROW_WIDTH - 1) downto 0);
      DATA_OUT_VLD      : out std_logic;
      CAM_BUSY          : out std_logic
   );
end entity ibuf_cam_data_array;


-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture ibuf_cam_data_array_arch of ibuf_cam_data_array is

-- ------------------ Signals declaration -------------------------------------
   signal write_enable_bus : std_logic_vector((CAM_ROW_COUNT - 1) downto 0);
   signal data_fill_bus : std_logic_vector(((CAM_ROW_WIDTH / 4) - 1) downto 0);
   signal match_out : std_logic_vector((CAM_ROW_COUNT - 1) downto 0);
   signal row_data_ok_bus : std_logic_vector(CAM_ROW_COUNT*CAM_ROW_WIDTH / 4 - 1
                                                                      downto 0);
   signal ctrl_data_out : std_logic_vector(CAM_ROW_WIDTH - 1 downto 0);

begin
MATCH_BUS <= match_out;

-- -------- Generating and maping cam_filling_part ----------------------------
   CONTROL_PART: entity work.ibuf_cam_control
      generic map(
         CAM_ROW_WIDTH     => CAM_ROW_WIDTH,
         CAM_ROW_COUNT     => CAM_ROW_COUNT
      )
      port map(
         CLK               => CLK,
         RESET             => RESET,
         DATA_IN           => DATA_IN,
         ROW_DATA_OK_BUS   => row_data_ok_bus,
         ADDR              => ADDR,
         WRITE_EN          => WRITE_ENABLE,
         READ_EN           => READ_ENABLE,
         
         WRITE_ENABLE_BUS  => write_enable_bus,
         DATA_FILL_BUS     => data_fill_bus,
         DATA_SRL          => ctrl_data_out,
         DATA_OUT          => DATA_OUT,
         DATA_OUT_VLD      => DATA_OUT_VLD,
         CAM_BUSY          => CAM_BUSY
      );

-- -------- Generating and maping cam_rows ------------------------------------
   ROW_GEN: for i in 0 to (CAM_ROW_COUNT - 1) generate
   -- generate all memory rows
      ROW_INST: entity work.ibuf_cam_row
         generic map (
            CAM_ROW_WIDTH  => CAM_ROW_WIDTH
         )
         port map (
            DATA_FILL      => data_fill_bus,
            DATA_IN        => ctrl_data_out,
            WRITE_ENABLE   => write_enable_bus(i),
            MATCH_ENABLE   => MATCH_ENABLE,
            MATCH_RST      => MATCH_RST,
            RESET          => RESET,
            CLK            => CLK,
            MATCH          => match_out(i),
            DATA_OK        => row_data_ok_bus((i+1)*CAM_ROW_WIDTH/4-1 downto
                                                            i*CAM_ROW_WIDTH/4)
         );
   end generate;

end architecture ibuf_cam_data_array_arch;
