--
--      Project:  Aurora Module Generator version 2.5
--
--         Date:  $Date$
--          Tag:  $Name:  $
--         File:  $RCSfile: tx_ll_datapath.vhd,v $
--          Rev:  $Revision$
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  TX_LL_DATAPATH
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description: This module pipelines the data path while handling the PAD
--               character placement and valid data flags.
--
--               This module supports 2 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library aurora_4byte1lane;

entity TX_LL_DATAPATH is

    port (

    -- LocalLink PDU Interface

            TX_D         : in std_logic_vector(0 to 31);
            TX_REM       : in std_logic_vector(0 to 1);
            TX_SRC_RDY_N : in std_logic;
            TX_SOF_N     : in std_logic;
            TX_EOF_N     : in std_logic;

    -- Aurora Lane Interface

            TX_PE_DATA_V : out std_logic_vector(0 to 1);
            GEN_PAD      : out std_logic_vector(0 to 1);
            TX_PE_DATA   : out std_logic_vector(0 to 31);

    -- TX_LL Control Module Interface

            HALT_C       : in std_logic;
            TX_DST_RDY_N : in std_logic;
            UFC_MESSAGE  : in std_logic_vector(0 to 1);

    -- System Interface

            CHANNEL_UP   : in std_logic;
            USER_CLK     : in std_logic

         );

end TX_LL_DATAPATH;

architecture RTL of TX_LL_DATAPATH is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal TX_PE_DATA_V_Buffer : std_logic_vector(0 to 1);
    signal GEN_PAD_Buffer      : std_logic_vector(0 to 1);
    signal TX_PE_DATA_Buffer   : std_logic_vector(0 to 31);

-- Internal Register Declarations --

    signal in_frame_r              : std_logic;
    signal storage_r               : std_logic_vector(0 to 15);
    signal storage_v_r             : std_logic;
    signal storage_ufc_v_r         : std_logic;
    signal storage_pad_r           : std_logic;
    signal tx_pe_data_r            : std_logic_vector(0 to 31);
    signal valid_c                 : std_logic_vector(0 to 1);
    signal tx_pe_data_v_r          : std_logic_vector(0 to 1);
    signal tx_pe_ufc_v_r           : std_logic_vector(0 to 1);
    signal gen_pad_c               : std_logic_vector(0 to 1);
    signal gen_pad_r               : std_logic_vector(0 to 1);

-- Internal Wire Declarations --
    
    signal ll_valid_c              : std_logic;
    signal in_frame_c              : std_logic;

begin

    TX_PE_DATA_V <= TX_PE_DATA_V_Buffer;
    GEN_PAD      <= GEN_PAD_Buffer;
    TX_PE_DATA   <= TX_PE_DATA_Buffer;

-- Main Body of Code --



    -- LocalLink input is only valid when TX_SRC_RDY_N and TX_DST_RDY_N are both asserted
    ll_valid_c    <=   not TX_SRC_RDY_N and not TX_DST_RDY_N;


    -- Data must only be read if it is within a frame. If a frame will last multiple cycles
    -- we assert in_frame_r as long as the frame is open.
    process(USER_CLK)
    begin
        if(USER_CLK'event and USER_CLK = '1') then
            if(CHANNEL_UP = '0') then
                in_frame_r  <=  '0' after DLY;
            elsif(ll_valid_c = '1') then
                if( (TX_SOF_N = '0') and (TX_EOF_N = '1') ) then
                    in_frame_r  <=  '1' after DLY;
                elsif( TX_EOF_N = '0') then
                    in_frame_r  <=  '0' after DLY;
                end if;
            end if;
        end if;
    end process;
    
        
    in_frame_c   <=   ll_valid_c and (in_frame_r  or not TX_SOF_N);




    -- The last 2 bytes of data from the LocalLink interface must be stored
    -- for the next cycle to make room for the SCP character that must be
    -- placed at the beginning of the lane.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (HALT_C = '0') then

                storage_r <= TX_D(16 to 31) after DLY;

            end if;

        end if;

    end process;



    -- All of the remaining bytes (except the last two) must be shifted
    -- and registered to be sent to the Channel.  The stored bytes go
    -- into the first position.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (HALT_C = '0') then

                tx_pe_data_r <= storage_r & TX_D(0 to 15) after DLY;

            end if;

        end if;

    end process;


    -- We generate the valid_c signal based on the REM signal and the EOF signal.

    process (TX_EOF_N, TX_REM)

    begin

        if (TX_EOF_N = '1') then

            valid_c <= "11";

        else

            case TX_REM(0 to 1) is

                when "00" => valid_c <= "10";
                when "01" => valid_c <= "10";
                when "10" => valid_c <= "11";
                when "11" => valid_c <= "11";
                when others => valid_c <= "11";

            end case;

        end if;

    end process;


    -- If the last 2 bytes in the word are valid, they are placed in the storage register and
    -- storage_v_r is asserted to indicate the data is valid.  Note that data is only moved to
    -- storage if the PDU datapath is not halted, the data is valid and both TX_SRC_RDY_N
    -- and TX_DST_RDY_N are asserted.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (HALT_C ='0') then

                storage_v_r <= valid_c(1) and in_frame_c after DLY;

            end if;

        end if;

    end process;


    -- The storage_ufc_v_r register is asserted when valid UFC data is placed in the storage register.
    -- Note that UFC data cannot be halted.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            storage_ufc_v_r <= UFC_MESSAGE(1) after DLY;

        end if;

    end process;


    -- The tx_pe_data_v_r registers track valid data in the TX_PE_DATA register.  The data is valid
    -- if it was valid in the previous stage.  Since the first 2 bytes come from storage, validity is
    -- determined from the storage_v_r signal. The remaining bytes are valid if their valid signal
    -- is asserted, and both TX_SRC_RDY_N and TX_DST_RDY_N are asserted.
    -- Note that pdu data movement can be frozen by the halt signal.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (HALT_C = '0') then

                tx_pe_data_v_r(0) <= storage_v_r after DLY;
                tx_pe_data_v_r(1) <= valid_c(0) and in_frame_c after DLY;

            end if;

        end if;

    end process;


    -- The tx_pe_ufc_v_r register tracks valid ufc data in the tx_pe_data_register.  The first 2 bytes
    -- come from storage: they are valid if storage_ufc_v_r was asserted.  The remaining bytes come from
    -- the TX_D input.  They are valid if UFC_MESSAGE was high when they were sampled.  Note that UFC data
    -- cannot be halted.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            tx_pe_ufc_v_r(0) <= storage_ufc_v_r after DLY;
            tx_pe_ufc_v_r(1) <= UFC_MESSAGE(0) after DLY;

        end if;

    end process;


    -- We generate the gen_pad_c signal based on the REM signal and the EOF signal.

    process (TX_EOF_N, TX_REM)

    begin

        if (TX_EOF_N = '1') then

            gen_pad_c <= "00";

        else

            case TX_REM(0 to 1) is

                when "00" => gen_pad_c <= "10";
                when "01" => gen_pad_c <= "00";
                when "10" => gen_pad_c <= "01";
                when "11" => gen_pad_c <= "00";
                when others => gen_pad_c <= "00";

            end case;

        end if;

    end process;


    -- Store a byte with a pad if TX_DST_RDY_N and TX_SRC_RDY_N is asserted.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (HALT_C = '0') then

                storage_pad_r <= gen_pad_c(1) and in_frame_c after DLY;

            end if;

        end if;

    end process;


    -- Register the gen_pad_r signals.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (HALT_C = '0') then

                gen_pad_r(0) <= storage_pad_r after DLY;
                gen_pad_r(1) <= gen_pad_c(0) and in_frame_c after DLY;

            end if;

        end if;

    end process;


    -- Implement the data out register.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            TX_PE_DATA_Buffer      <= tx_pe_data_r after DLY;
            TX_PE_DATA_V_Buffer(0) <= (tx_pe_data_v_r(0) and not HALT_C) or tx_pe_ufc_v_r(0) after DLY;
            TX_PE_DATA_V_Buffer(1) <= (tx_pe_data_v_r(1) and not HALT_C) or tx_pe_ufc_v_r(1) after DLY;
            GEN_PAD_Buffer(0)      <= (gen_pad_r(0) and not HALT_C) and not tx_pe_ufc_v_r(0) after DLY;
            GEN_PAD_Buffer(1)      <= (gen_pad_r(1) and not HALT_C) and not tx_pe_ufc_v_r(1) after DLY;

        end if;

    end process;


end RTL;
