-- JORDY DE HOON
-- MODULE : DESPREADING
-- INFO : DESPREADING module fully combinatorisch. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity DESPREADING is
    port(
            clk         : IN STD_LOGIC;
            reset       : IN STD_LOGIC; 
            signal_0    : IN STD_LOGIC;
            signal_1    : IN STD_LOGIC;
            enable      : IN STD_LOGIC;
            signal_out  : OUT STD_LOGIC
    );
end DESPREADING;

architecture Behavioral OF DESPREADING IS
SIGNAL signal_xor   : STD_LOGIC;
begin

process(reset,clk)begin
    if(reset = '1')then     -- RESET DFF
        signal_xor <= '0';
    else
        if(rising_edge(clk) AND (enable = '1'))then -- DFF on output
            signal_xor <= signal_0 XOR signal_1;
        end if;
    end if;
end process;
-- SIGNAL LINKING
signal_out <= signal_xor;

end Behavioral;