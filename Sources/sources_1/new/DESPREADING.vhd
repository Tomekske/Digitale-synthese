-- JORDY DE HOON
-- MODULE : DESPREADING
-- INFO : DESPREADING module fully combinatorisch. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity DESPREADING is
    port( 
            signal_0    : IN STD_LOGIC;
            signal_1    : IN STD_LOGIC;
            signal_out  : OUT STD_LOGIC
    );
end DESPREADING;

architecture Behavioral OF DESPREADING IS
begin

signal_out <= signal_0 XOR signal_1;

end Behavioral;