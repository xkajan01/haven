-- clkgen_54.vhd 
-- Copyright (C) 2006 CESNET, Liberouter project
-- Author(s): Jan Pazdera <pazdera@liberouter.org>
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
-- TODO: - 

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
-- synopsys translate_off
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- synopsys translate_on

entity clkgen_54 is
   port ( CLKIN           : in    std_logic;
          RESET           : in    std_logic;
          USRCLK          : out   std_logic;       -- usrclk
          USRCLK2_NS      : out   std_logic;       -- usrclk2 non-shifted
          LOCKED          : out   std_logic);      -- clkgen locked
end clkgen_54;

architecture BEHAVIORAL of clkgen_54 is
   attribute CLK_FEEDBACK          : string ;
   attribute CLKDV_DIVIDE          : string ;
   attribute CLKFX_DIVIDE          : string ;
   attribute CLKFX_MULTIPLY        : string ;
   attribute CLKIN_DIVIDE_BY_2     : string ;
   attribute CLKIN_PERIOD          : string ;
   attribute CLKOUT_PHASE_SHIFT    : string ;
   attribute DESKEW_ADJUST         : string ;
   attribute DFS_FREQUENCY_MODE    : string ;
   attribute DLL_FREQUENCY_MODE    : string ;
   attribute DUTY_CYCLE_CORRECTION : string ;
   attribute FACTORY_JF            : string ;
   attribute PHASE_SHIFT           : string ;
   attribute STARTUP_WAIT          : string ;
   signal clkfb_in        : std_logic;
   signal clk0_buf        : std_logic;
   signal usrclk_buf      : std_logic;
   signal usrclk2_ns_buf  : std_logic;
   signal gnd             : std_logic;

   component BUFG
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;

   -- Period Jitter (Peak-to-Peak) for block DCM_INST = 0.79 ns
   -- Period Jitter (unit interval) for block DCM_INST = 0.02 UI
   component DCM
      -- synopsys translate_off
      generic( CLK_FEEDBACK : string :=  "1X";
               CLKDV_DIVIDE : real :=  2.000000;
               CLKFX_DIVIDE : integer :=  1;
               CLKFX_MULTIPLY : integer :=  4;
               CLKIN_DIVIDE_BY_2 : boolean :=  FALSE;
               CLKIN_PERIOD : real :=  0.000000;
               CLKOUT_PHASE_SHIFT : string :=  "NONE";
               DESKEW_ADJUST : string :=  "SYSTEM_SYNCHRONOUS";
               DFS_FREQUENCY_MODE : string :=  "LOW";
               DLL_FREQUENCY_MODE : string :=  "LOW";
               DUTY_CYCLE_CORRECTION : boolean :=  TRUE;
               FACTORY_JF : bit_vector :=  x"C080";
               PHASE_SHIFT : integer :=  0;
               STARTUP_WAIT : boolean :=  FALSE;
               DSS_MODE : string :=  "NONE");
      -- synopsys translate_on
      port ( CLKIN    : in    std_logic; 
             CLKFB    : in    std_logic; 
             RST      : in    std_logic; 
             PSEN     : in    std_logic; 
             PSINCDEC : in    std_logic; 
             PSCLK    : in    std_logic; 
             DSSEN    : in    std_logic; 
             CLK0     : out   std_logic; 
             CLK90    : out   std_logic; 
             CLK180   : out   std_logic; 
             CLK270   : out   std_logic; 
             CLKDV    : out   std_logic; 
             CLK2X    : out   std_logic; 
             CLK2X180 : out   std_logic; 
             CLKFX    : out   std_logic; 
             CLKFX180 : out   std_logic; 
             STATUS   : out   std_logic_vector (7 downto 0); 
             LOCKED   : out   std_logic; 
             PSDONE   : out   std_logic);
   end component;
   
   attribute CLK_FEEDBACK of DCM_INST : label is "1X";
   attribute CLKDV_DIVIDE of DCM_INST : label is "2.000000";
   attribute CLKFX_DIVIDE of DCM_INST : label is "8";
   attribute CLKFX_MULTIPLY of DCM_INST : label is "2";
   attribute CLKIN_DIVIDE_BY_2 of DCM_INST : label is "FALSE";
   attribute CLKIN_PERIOD of DCM_INST : label is "8.000000";
   attribute CLKOUT_PHASE_SHIFT of DCM_INST : label is "NONE";
   attribute DESKEW_ADJUST of DCM_INST : label is "SYSTEM_SYNCHRONOUS";
   attribute DFS_FREQUENCY_MODE of DCM_INST : label is "LOW";
   attribute DLL_FREQUENCY_MODE of DCM_INST : label is "LOW";
   attribute DUTY_CYCLE_CORRECTION of DCM_INST : label is "TRUE";
   attribute FACTORY_JF of DCM_INST : label is "C080";
   attribute PHASE_SHIFT of DCM_INST : label is "0";
   attribute STARTUP_WAIT of DCM_INST : label is "FALSE";
begin
   gnd <= '0';

   USRCLK2_NS_BUFG_INST : BUFG
      port map (I=>usrclk2_ns_buf,
                O=>USRCLK2_NS);
   
   CLK0_BUFG_INST : BUFG
      port map (I=>clk0_buf,
                O=>clkfb_in);

   USRCLK <= clkfb_in;
   
   DCM_INST : DCM
   -- synopsys translate_off
   generic map( CLK_FEEDBACK => "1X",
            CLKDV_DIVIDE => 2.000000,
            CLKFX_DIVIDE => 8,
            CLKFX_MULTIPLY => 2,
            CLKIN_DIVIDE_BY_2 => FALSE,
            CLKIN_PERIOD => 8.000000,
            CLKOUT_PHASE_SHIFT => "NONE",
            DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
            DFS_FREQUENCY_MODE => "LOW",
            DLL_FREQUENCY_MODE => "LOW",
            DUTY_CYCLE_CORRECTION => TRUE,
            FACTORY_JF => x"C080",
            PHASE_SHIFT => 0,
            STARTUP_WAIT => FALSE)
   -- synopsys translate_on
      port map (CLKFB=>clkfb_in,
                CLKIN=>CLKIN,
                DSSEN=>gnd,
                PSCLK=>gnd,
                PSEN=>gnd,
                PSINCDEC=>gnd,
                RST=>RESET,
                CLKDV=>usrclk2_ns_buf,
                CLKFX=>open,
                CLKFX180=>open,
                CLK0=>clk0_buf,
                CLK2X=>open,
                CLK2X180=>open,
                CLK90=>open,
                CLK180=>open,
                CLK270=>open,
                LOCKED=>LOCKED,
                PSDONE=>open,
                STATUS=>open);
   
end BEHAVIORAL;


