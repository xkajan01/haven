-- reg_array.vhd: array of registers
-- Copyright (C) 2007 CESNET
-- Author(s): Petr Kastovsky <kastosvky@liberouter.org>
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
--
-- TODO:
--
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.math_pack.all;
-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity reg_array is
   generic (
      DATA_WIDTH : integer := 64;
      ITEMS : integer := 8;
      INIT_DATA : std_logic_vector
   );
   port(
      CLK : in std_logic;

      SCLR  : in std_logic; -- synchronous clear
      -- read/write PORT
      WEA   : in std_logic;
      ADDRA : in std_logic_vector(log2(ITEMS)-1 downto 0);
      DIA   : in std_logic_vector(DATA_WIDTH-1 downto 0);
      DOA   : out std_logic_vector(DATA_WIDTH-1 downto 0);

      -- readonly PORT
      ADDRB : in std_logic_vector(log2(ITEMS)-1 downto 0);
      DOB   : out std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end entity reg_array;

-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture reg_array_arch of reg_array is

   type TREG_ARRAY  is array (0 to ITEMS-1) of 
                    std_logic_vector(DATA_WIDTH-1 downto 0);

   function array_init(INIT_DATA : in std_logic_vector) return TREG_ARRAY is
   variable ra : TREG_ARRAY;
   begin
      for i in 0 to ITEMS - 1 loop
         ra(i) := INIT_DATA;
      end loop;
      return ra;
   end;

   signal memory_array : TREG_ARRAY := array_init(INIT_DATA);

begin

      regs_p : process(CLK) is
      begin
         if (CLK'event and CLK = '1') then
            if (SCLR = '1') then
               memory_array(conv_integer(ADDRA)) <= (others => '0');
            elsif (WEA = '1') then
               memory_array(conv_integer(ADDRA)) <= DIA;
            end if;
         end if;
      end process;

      DOA <= memory_array(conv_integer(ADDRA));
      DOB <= memory_array(conv_integer(ADDRB));

end architecture reg_array_arch;

