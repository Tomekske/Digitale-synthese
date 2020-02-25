-- JORDY DE HOON
-- MODULE : EDGEDETECT
-- INFO : USING A STATE MACHINE TO TRACK THE 
library ieee;
use ieee.std_logic_1164.all;
entity EDGEDETECT is
    port ( 
        sig     :   IN STD_LOGIC;   -- Input signal
        reset   :   IN STD_LOGIC;   -- Active high reset
        edge    :   OUT STD_LOGIC   -- Edge detection signal
    );
end EDGEDETECT;

-- SYNC COMPONENT
process(clk,reset) begin


end process;
-- COMBINATORIAL COMPONENT

-- SIGNAL CONNECTIONS