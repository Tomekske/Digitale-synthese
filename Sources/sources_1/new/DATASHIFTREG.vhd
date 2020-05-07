---------------------------------------------------------------------
-- DEV		: JORDY DE HOON
-- ACADEMIC : KULEUVEN 2019-2020 CAMPUS DE NAYER
-- MODULE	: DATASHIFTREG
-- INFO		: SERIAL TO PARRALEL SHIFT REGISTER
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity DATASHIFTREG is
    generic(SHIFT_WIDTH : integer);
    port(
        reset       : IN STD_LOGIC;     -- ASYNC RESET
        clk         : IN STD_LOGIC;     -- CLK
        sdi         : IN STD_LOGIC;     -- Serial data in
        sh          : IN STD_LOGIC;     -- shift signal
        pdo         : OUT STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 DOWNTO 0)    -- Parrallel data out
    );
end DATASHIFTREG;

architecture Behavioral OF DATASHIFTREG IS
    SIGNAL data_pres        : STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 DOWNTO 0);   -- Pressent state of register
    SIGNAL data_next        : STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 DOWNTO 0);   -- Next state of register
begin
-- SYNC COMPONENT HERE
process(clk,reset)begin
    if(reset = '1')then
        data_pres <= (OTHERS => '0');   -- Set all bits to zero
    else
        if(rising_edge(clk))then        -- When rising edge on clk signal
            if(sh = '1')then            -- And shift signal is high
                data_pres <= data_next;     -- load new pressent state in register
            end if;
        end if;
    end if;
end process;
-- COMB COMPONENT HERE
process(data_pres)begin
    -- Left shift next state decoder
    data_next(SHIFT_WIDTH - 1 DOWNTO 1) <= data_pres (SHIFT_WIDTH - 2 DOWNTO 0);
    -- LSB bit is sdi (serial data input)
    data_next(0) <= sdi;
end 
-- LINKING SIGNALS HERE
pdo <= data_pres;   -- Bind data_pres buffer to output
end Behavioral;
