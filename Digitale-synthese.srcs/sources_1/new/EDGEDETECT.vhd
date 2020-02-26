-- JORDY DE HOON
-- MODULE : EDGEDETECT
-- INFO : Using sig and a delay of sig to generate a puls if a rising edge is detected
library ieee;
use ieee.std_logic_1164.all;
entity EDGEDETECT is
    port ( 
        sig     :   IN STD_LOGIC;   -- Input signal
        clk     :   IN STD_LOGIC;   -- Clock signal
        reset   :   IN STD_LOGIC;   -- Active high reset
        edge    :   OUT STD_LOGIC   -- Edge detection signal
    );
end EDGEDETECT;

architecture Behavioral OF EDGEDETECT IS
    SIGNAL edge_sig     : STD_LOGIC;
    SIGNAL delay_sig    : STD_LOGIC;
begin
-- SYNC COMPONENT
process(clk,reset) begin
    if (reset = '1') then           -- Async Reset
        delay_sig <= '0';
    else
        if(rising_edge(clk)) then   -- D flipflop | Delay function
            delay_sig <= sig;
        end if;
    end if ;
end process;
-- COMBINATORIAL COMPONENT
process(clk,delay_sig,sig,reset) begin
    if(reset = '1') then
        edge_sig <= '0';
    else
        edge_sig <= sig AND (NOT delay_sig);    -- If SIG is HIGH and the delay low generate PULS
    end if;
end process;
-- SIGNAL CONNECTIONS
edge <= edge_sig;          -- Link to external connection
end Behavioral;