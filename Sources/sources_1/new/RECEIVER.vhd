---------------------------------------------------------------------
-- DEV		: JORDY DE HOON
-- ACADEMIC : KULEUVEN 2019-2020 CAMPUS DE NAYER
-- MODULE	: RECEIVER
-- INFO		:  
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity RECEIVER is
    port(
        clk         : IN STD_LOGIC;
        reset       : IN STD_LOGIC;
        sdi_spread  : IN STD_LOGIC;
        pn_mode     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        seg7        : OUT STD_LOGIC_VECTOR (6 downto 0)    
    );
end RECEIVER;

architecture Behavioral OF RECEIVER IS
CONSTANT DATA_WIDTH : integer := 11; 
-- SIGNALS HERE
SIGNAL data_bit     : STD_LOGIC;
SIGNAL bitsample    : STD_LOGIC;
SIGNAL preamble     : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL data         : STD_LOGIC_VECTOR(3 DOWNTO 0);
-- COMPONENTS
component ACCES_LAYER_RX is
    port(
        clk         : IN  STD_LOGIC;
        reset       : IN  STD_LOGIC;
        sdi_spread  : IN  STD_LOGIC;
        pn_mode     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        databit     : OUT STD_LOGIC;
        bitsample   : OUT STD_LOGIC
    );
end component;

component DATASHIFTREG is
    generic(SHIFT_WIDTH : integer);
    port(
        reset       : IN  STD_LOGIC;     -- ASYNC RESET
        clk         : IN  STD_LOGIC;     -- CLK
        sdi         : IN  STD_LOGIC;     -- Serial data in
        sh          : IN  STD_LOGIC;     -- shift signal
        pdo         : OUT STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 DOWNTO 0)    -- Parrallel data out
    );
end component;

component APPLICATION_LAYER_RX is
    port(
        clk         : IN  STD_LOGIC;
        reset       : IN  STD_LOGIC;
        bit_sample  : IN  STD_LOGIC;
        preamble    : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
        data        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        seg7        : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
end component;
begin

ACL: ACCES_LAYER_RX
    port map(clk, reset, sdi_spread, pn_mode, data_bit, bitsample);

DLL: DATASHIFTREG
    generic map(DATA_WIDTH)
    port map(   reset => reset,
                clk => clk, 
                data_bit => sdi,
                bitsample => sh,
                preamble => pdo(DATA_WIDTH - 1 DOWNTO 4),
                data => pdo(3 DOWNTO 0) 
                );
APL: APPLICATION_LAYER_RX
    port map(clk, reset, bitsample, preamble, data, seg7);

end Behavioral;
