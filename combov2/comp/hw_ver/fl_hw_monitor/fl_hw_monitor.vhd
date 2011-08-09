--------------------------------------------------------------------------
-- Project Name: Hardware - Software Framework for Functional Verification
-- File Name:    FrameLink Monitor
-- Description: 
-- Author:       Marcela Simkova <xsimko03@stud.fit.vutbr.cz> 
-- Date:         15.4.2011 
-- --------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.math_pack.all;

-- ==========================================================================
--                              ENTITY DECLARATION
-- ==========================================================================
entity FL_HW_MONITOR is

   generic
   (
      -- data width
      IN_DATA_WIDTH  : integer := 64;
      OUT_DATA_WIDTH : integer := 64
   );

   port
   (
      RX_CLK         : in  std_logic;
      RX_RESET       : in  std_logic;
      TX_CLK         : in  std_logic;
      TX_RESET       : in  std_logic;

      -- ----------------- INPUT INTERFACE ----------------------------------
      -- input FrameLink interface
      RX_DATA        : in  std_logic_vector(IN_DATA_WIDTH-1 downto 0);
      RX_REM         : in  std_logic_vector(log2(IN_DATA_WIDTH/8)-1 downto 0);
      RX_SRC_RDY_N   : in  std_logic;
      RX_DST_RDY_N   : out std_logic;
      RX_SOP_N       : in  std_logic;
      RX_EOP_N       : in  std_logic;
      RX_SOF_N       : in  std_logic;
      RX_EOF_N       : in  std_logic;
      
      -- ----------------- OUTPUT INTERFACE ---------------------------------      
      -- output FrameLink interface
      TX_DATA        : out std_logic_vector(OUT_DATA_WIDTH-1 downto 0);
      TX_REM         : out std_logic_vector(log2(OUT_DATA_WIDTH/8)-1 downto 0);
      TX_SRC_RDY_N   : out std_logic;
      TX_DST_RDY_N   : in  std_logic;
      TX_SOP_N       : out std_logic;
      TX_EOP_N       : out std_logic;
      TX_SOF_N       : out std_logic;
      TX_EOF_N       : out std_logic;

      -- ------------------ ready signal ------------------------------------
      OUTPUT_READY   : out std_logic
   );
   
end entity FL_HW_MONITOR;

-- ==========================================================================
--                           ARCHITECTURE DESCRIPTION
-- ==========================================================================
architecture arch of FL_HW_MONITOR is

-- ==========================================================================
--                                    CONSTANTS
-- ==========================================================================
constant FIFO_DATA_WIDTH : integer := IN_DATA_WIDTH + log2(IN_DATA_WIDTH/8) + 4;

constant IN_REM_INDEX  : integer := 4+log2(IN_DATA_WIDTH/8);

constant LFSR_GENERATOR_SEED : std_logic_vector(7 downto 0) := "10011011";

-- ==========================================================================
--                                     SIGNALS
-- ==========================================================================
-- data fifo signals write ifc
signal sig_data_fifo_wr_data         : std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
signal sig_data_fifo_wr_write        : std_logic;
signal sig_data_fifo_wr_almost_full  : std_logic;
signal sig_data_fifo_wr_full         : std_logic;

-- data fifo signals read ifc
signal sig_data_fifo_rd_data   : std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
signal sig_data_fifo_rd_read   : std_logic;
signal sig_data_fifo_rd_empty  : std_logic;
signal sig_data_fifo_rd_almost_empty : std_logic;

-- FL_TRANSFORMER input
signal rx_fl_transformer_data      : std_logic_vector(IN_DATA_WIDTH-1 downto 0);
signal rx_fl_transformer_rem       : std_logic_vector(log2(IN_DATA_WIDTH/8)-1 downto 0);
signal rx_fl_transformer_sof_n     : std_logic;
signal rx_fl_transformer_sop_n     : std_logic;
signal rx_fl_transformer_eof_n     : std_logic;
signal rx_fl_transformer_eop_n     : std_logic;
signal rx_fl_transformer_src_rdy_n : std_logic;
signal rx_fl_transformer_dst_rdy_n : std_logic;

-- FL_TRANSFORMER output
signal tx_fl_transformer_data      : std_logic_vector(OUT_DATA_WIDTH-1 downto 0);
signal tx_fl_transformer_rem       : std_logic_vector(log2(OUT_DATA_WIDTH/8)-1 downto 0);
signal tx_fl_transformer_sof_n     : std_logic;
signal tx_fl_transformer_sop_n     : std_logic;
signal tx_fl_transformer_eof_n     : std_logic;
signal tx_fl_transformer_eop_n     : std_logic;
signal tx_fl_transformer_src_rdy_n : std_logic;
signal tx_fl_transformer_dst_rdy_n : std_logic;

-- LFSR signals
signal lfsr_output       : std_logic;
signal lfsr_en           : std_logic;

signal lfsr_en_reg       : std_logic;
signal lfsr_enable       : std_logic;

begin

   -- Mapping of input ports
   sig_data_fifo_wr_data(FIFO_DATA_WIDTH-1 downto IN_REM_INDEX)  <= RX_DATA;
   sig_data_fifo_wr_data(IN_REM_INDEX-1 downto 4)                <= RX_REM;
   sig_data_fifo_wr_data(0)  <= RX_SOF_N;
   sig_data_fifo_wr_data(1)  <= RX_SOP_N;
   sig_data_fifo_wr_data(2)  <= RX_EOF_N;
   sig_data_fifo_wr_data(3)  <= RX_EOP_N;
   sig_data_fifo_wr_write    <= not (RX_SRC_RDY_N or lfsr_output);
   RX_DST_RDY_N              <= lfsr_output OR sig_data_fifo_wr_full;

   -- --------------- DATA FIFO INSTANCE ------------------------------------
   data_async_fifo : entity work.cdc_fifo
   generic map(
      DATA_WIDTH      => FIFO_DATA_WIDTH
   )
   port map(
      RESET           => TX_RESET,
      
      -- Write interface
      WR_CLK          => RX_CLK,
      WR_DATA         => sig_data_fifo_wr_data,
      WR_WRITE        => sig_data_fifo_wr_write,
      WR_FULL         => sig_data_fifo_wr_full,
      WR_ALMOST_FULL  => sig_data_fifo_wr_almost_full,
      
      RD_CLK          => TX_CLK,
      RD_DATA         => sig_data_fifo_rd_data,
      RD_READ         => sig_data_fifo_rd_read,
      RD_EMPTY        => sig_data_fifo_rd_empty,
      RD_ALMOST_EMPTY => sig_data_fifo_rd_almost_empty
   );


   rx_fl_transformer_data                <= sig_data_fifo_rd_data(FIFO_DATA_WIDTH-1 downto IN_REM_INDEX);
   rx_fl_transformer_rem                 <= sig_data_fifo_rd_data(IN_REM_INDEX-1 downto 4);
   rx_fl_transformer_sop_n               <= sig_data_fifo_rd_data(1); 
   rx_fl_transformer_eop_n               <= sig_data_fifo_rd_data(3);
   rx_fl_transformer_src_rdy_n           <= sig_data_fifo_rd_empty;
   sig_data_fifo_rd_read  <= not rx_fl_transformer_dst_rdy_n;

   -- same as SOP (resp. EOP) - splits data packet to several part by part
   rx_fl_transformer_sof_n               <= sig_data_fifo_rd_data(1);
   rx_fl_transformer_eof_n               <= sig_data_fifo_rd_data(3);

   -- --------------- FL_TRANSFORMER instance -------------------------------
   fl_tran_i : entity work.FL_TRANSFORMER
   generic map(
      RX_DATA_WIDTH      => IN_DATA_WIDTH,
      TX_DATA_WIDTH      => OUT_DATA_WIDTH
   )
   port map(
      CLK             => TX_CLK,
      RESET           => TX_RESET,
      
      -- RX interface
      RX_DATA         => rx_fl_transformer_data,
      RX_REM          => rx_fl_transformer_rem,
      RX_SOF_N        => rx_fl_transformer_sof_n,
      RX_EOF_N        => rx_fl_transformer_eof_n,
      RX_SOP_N        => rx_fl_transformer_sop_n,
      RX_EOP_N        => rx_fl_transformer_eop_n,
      RX_SRC_RDY_N    => rx_fl_transformer_src_rdy_n,
      RX_DST_RDY_N    => rx_fl_transformer_dst_rdy_n,

      -- TX interface
      TX_DATA         => tx_fl_transformer_data,
      TX_REM          => tx_fl_transformer_rem,
      TX_SOF_N        => tx_fl_transformer_sof_n,
      TX_EOF_N        => tx_fl_transformer_eof_n,
      TX_SOP_N        => tx_fl_transformer_sop_n,
      TX_EOP_N        => tx_fl_transformer_eop_n,
      TX_SRC_RDY_N    => tx_fl_transformer_src_rdy_n,
      TX_DST_RDY_N    => tx_fl_transformer_dst_rdy_n
   );
 
   -- mapping of outputs
   TX_DATA         <= tx_fl_transformer_data;
   TX_REM          <= tx_fl_transformer_rem;
   TX_SOF_N        <= tx_fl_transformer_sof_n;
   TX_EOF_N        <= tx_fl_transformer_eof_n;
   TX_SOP_N        <= tx_fl_transformer_sop_n;
   TX_EOP_N        <= tx_fl_transformer_eop_n;
   TX_SRC_RDY_N    <= tx_fl_transformer_src_rdy_n;
   tx_fl_transformer_dst_rdy_n    <= TX_DST_RDY_N;

   lfsr_enable <= NOT RX_SRC_RDY_N;

   -- --------------- LFSR enable bit register -----------------------------
   lfrs_en_reg_p: process(RX_RESET, RX_CLK)
   begin
      if (rising_edge(RX_CLK)) then
         if (RX_RESET = '1') then
            lfsr_en_reg <= '0';
         else
            lfsr_en_reg <= lfsr_en_reg OR lfsr_enable;
         end if;
      end if;
   end process;

   lfsr_en <= lfsr_en_reg OR lfsr_enable;

   -- --------------- LFSR RANDOM BITSTREAM GENERATOR INSTANCE --------------
   lfsr : entity work.prng_8
   port map(
      CLK     => RX_CLK,
      RESET   => RX_RESET,
      SEED    => LFSR_GENERATOR_SEED,
      EN      => lfsr_en,
      OUTPUT  => lfsr_output
   );

   OUTPUT_READY        <= sig_data_fifo_rd_almost_empty;
   --OUTPUT_READY        <= not sig_data_fifo_wr_almost_full;

end architecture;
