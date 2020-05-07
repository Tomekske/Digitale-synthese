---------------------------------------------------------------------
-- DEV		: 
-- ACADEMIC : KULEUVEN 2019-2020 CAMPUS DE NAYER
-- MODULE	: 
-- INFO		:  
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity DATASHIFTREG is
    generic(SHIFT_WIDTH : integer);
    port(
        reset       : IN STD_LOGIC;
        clk         : IN STD_LOGIC;
        sdi         : IN STD_LOGIC;
        sh          : IN STD_LOGIC;
        pdo         : OUT STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 DOWNTO 0)
            
    );
end DATASHIFTREG;

architecture Behavioral OF DATASHIFTREG IS
    SIGNAL data_pres        : STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 DOWNTO 0);
    SIGNAL data_next        : STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 DOWNTO 0);
begin
-- SYNC COMPONENT HERE
process(clk,reset)begin
    if(reset = '1')then
        data_pres <= (OTHERS => '0');
    else
        if(rising_edge(clk))then
            if(sh = '1')then
                data_pres <= data_next;
            end if;
        end if;
    end if;
end process;
-- COMB COMPONENT HERE
process(data_pres)begin
    data_next(SHIFT_WIDTH - 1 DOWNTO 1) <= data_pres (SHIFT_WIDTH - 2 DOWNTO 0);
    data_next(0) <= sdi;
end 
-- LINKING SIGNALS HERE
pdo <= data_pres; 
end Behavioral;
