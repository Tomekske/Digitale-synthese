---------------------------------------------------------------------
-- DEV		: JORDY DE HOON & TOMEK JOOSTENS
-- ACADEMIC : KULEUVEN 2019-2020 CAMPUS DE NAYER
-- MODULE	: RX_APPLICATION_LAYER
-- INFO		:  
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity APPLICATION_LAYER_RX is
    port(
        clk         : IN  STD_LOGIC;
        reset       : IN  STD_LOGIC;
        bit_sample  : IN  STD_LOGIC;
        preamble    : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
        data        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        7seg        : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
end APPLICATION_LAYER_RX;

architecture Behavioral OF APPLICATION_LAYER_RX IS
-- SIGNALS HERE
SIGNAL DL_data_out  : STD_LOGIC_VECTOR(3 DOWNTO 0);
-- COMPONENTS
-- DATA LATCH
component DATA_LATCH is
    Port ( 
        clk         : IN STD_LOGIC;
        reset       : IN STD_LOGIC;     -- Reset signal
        bit_sample  : IN STD_LOGIC;
        preamble    : IN STD_LOGIC_VECTOR(6 downto 0);
        data_in     : IN STD_LOGIC_VECTOR(3 downto 0);
        data_out    : OUT STD_LOGIC_VECTOR(3 downto 0)
    );
end component;
-- 7SEGMENNT DECODER
component SEG7DEC is
    Port( 
        data_in  : in STD_LOGIC_VECTOR (3 downto 0); -- input data
        g_to_a   : out STD_LOGIC_VECTOR (6 downto 0) -- 7 segment output: [0-9][A-F]
    ); 
end component;
begin

DL: DATALATCH
    port map(clk, reset, bit_sample, preamble, data, DL_data_out);

SEG7: SEG7DEC
    port map(DL_data_out,7seg);

end Behavioral;
