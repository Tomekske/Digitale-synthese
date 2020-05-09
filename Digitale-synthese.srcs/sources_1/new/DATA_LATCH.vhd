---------------------------------------------------------------------
-- DEV		: Tomek Joostens
-- ACADEMIC : KULEUVEN 2019-2020 CAMPUS DE NAYER
-- MODULE	: DATA_LATCH
-- INFO		: Deze stuurt een binaire output uit waarmee 7 segmenten kunnnen aangestuurd worden
---------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DATA_LATCH is
    Port ( 
        clk         : IN STD_LOGIC;
        reset       : IN STD_LOGIC;     -- Reset signal
        bit_sample  : IN STD_LOGIC;
        preamble    : IN STD_LOGIC_VECTOR(6 downto 0);
        data_in     : IN STD_LOGIC_VECTOR(3 downto 0);
        data_out    : OUT STD_LOGIC_VECTOR(3 downto 0)
    );
end DATA_LATCH;

architecture Behavioral of DATA_LATCH is
CONSTANT preamble_ptrn	: std_logic_vector(6 downto 0) := "0111110";

SIGNAL data_dff   : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin

-- SYNCHROON
process(reset, clk) begin
    if(reset = '1') then
        data_dff <= (others => '0');
    else
        -- Een latch die zijn waarde bewaard als bit_sample OF preamble niet gelijk is aan het patroon
        if(rising_edge(clk)) then
            if((bit_sample = '1') and (preamble = preamble_ptrn)) then
                data_dff <= data_in;
            end if;
         end if;
    end if;
end process;

-- Signaal aan uitgang koppelen
data_out <= data_dff;
end Behavioral;