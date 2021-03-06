--*****************************************************************************
-- DISCLAIMER OF LIABILITY
--
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you a
-- license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as-is" solely for use in developing programs and
-- solutions for Xilinx devices, with no obligation on the
-- part of Xilinx to provide support. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications is
-- expressly prohibited.
--
-- Any modifications that are made to the Source Code are
-- done at the user's sole risk and will be unsupported.
--
-- Copyright (c) 2006-2007 Xilinx, Inc. All rights reserved.
--
-- This copyright and support notice must be retained as part
-- of this text at all times.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor             : Xilinx
-- \   \   \/     Version            : 2.2
--  \   \         Application        : MIG
--  /   /         Filename           : qdrii_test_addr_gen.vhd
-- /___/   /\     Timestamp          : 15 May 2006
-- \   \  /  \    Date Last Modified : $Date$
--  \___\/\___\
--
--Device: Virtex-5
--Design: QDRII
--
--Purpose:
--    This module
--       1. generates the write and read test memory addresses.
--
--Revision History:
--
--------------------------------------------------------------------------------

library ieee;
library unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;


entity qdrii_test_addr_gen is
  generic(
    -- Following parameters are for 72-bit design (for ML561 Reference board
    -- design). Actual values may be different. Actual parameters values are
    -- passed from design top module qdrii_sram module. Please refer to the
    -- qdrii_sram module for actual values.
    ADDR_WIDTH   : integer := 19;
    BURST_LENGTH : integer := 4
    );
  port(
    clk        : in  std_logic;
    reset      : in  std_logic;
    user_w_n   : in  std_logic;
    test_w_n   : in  std_logic;
    user_r_n   : in  std_logic;
    user_ad_wr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    user_ad_rd : out std_logic_vector(ADDR_WIDTH-1 downto 0)
    );
end entity qdrii_test_addr_gen;

architecture arch_qdrii_test_addr_gen of qdrii_test_addr_gen is

  signal test_ad_wr : unsigned(ADDR_WIDTH downto 0);
  signal user_ad_rd_i : unsigned(ADDR_WIDTH-1 downto 0);

begin

  user_ad_rd <= std_logic_vector(user_ad_rd_i);

  -- Write Address is generated for every alternate clock for BL4 and on every
  -- clock for BL2.
  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(reset = '1') then
        user_ad_wr <= (others => '0');
      elsif(BURST_LENGTH = 4) then
        user_ad_wr(ADDR_WIDTH-1 downto 0) <= std_logic_vector(test_ad_wr(ADDR_WIDTH downto 1));
      else
        user_ad_wr(ADDR_WIDTH-1 downto 0) <= std_logic_vector(test_ad_wr(ADDR_WIDTH-1 downto 0));
      end if;
    end if;
  end process;

  process (clk)
  begin
    if(clk'event and clk = '1') then
      if(reset = '1') then
        test_ad_wr <= (others => '0');
      elsif((test_w_n = '0') or (user_w_n = '0')) then
        test_ad_wr <= test_ad_wr + 1;
      else
        test_ad_wr <= test_ad_wr;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if(clk'event and clk = '1') then
      if(reset = '1') then
        user_ad_rd_i <= (others => '0');
      elsif(user_r_n = '0') then
        user_ad_rd_i <= user_ad_rd_i + 1;
      else
        user_ad_rd_i <= user_ad_rd_i;
      end if;
    end if;
  end process;

end architecture arch_qdrii_test_addr_gen;


