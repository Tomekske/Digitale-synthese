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
begin
-- SYNC COMPONENT HERE

-- COMB COMPONENT HERE

-- LINKING SIGNALS HERE

end Behavioral;
