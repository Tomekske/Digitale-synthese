-- JORDY DE HOON
-- MODULE : SEQUENCECONTROLLER
-- INFO : State machine controller (tracking state for shiftregister)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity SEQUENCECONTROLLER is
    generic(COUNT_WIDTH : integer);
    port ( 
            reset       : IN STD_LOGIC;     -- Reset signal
            nextstate   : IN STD_LOGIC;     -- Input signal to next state
            sh_reg      : OUT STD_LOGIC;    -- Shift signal for registers (output)
            ld_reg      : OUT STD_LOGIC     -- Load signal for registers (output)
    );
end SEQUENCECONTROLLER;

architecture Behavioral OF SEQUENCECONTROLLER IS
    SIGNAL BITCOUNT_curr     : STD_LOGIC_VECTOR(COUNT_WIDTH DOWNTO 0);
    SIGNAL BITCOUNT_next     : STD_LOGIC_VECTOR(COUNT_WIDTH DOWNTO 0);
    SIGNAL sh_next           : STD_LOGIC;
    SIGNAL ld_next           : STD_LOGIC;
begin
-- SYNC COMPONENT
process(reset,nextstate) begin
    if (reset ='1') then
        BITCOUNT_curr(COUNT_WIDTH-1 DOWNTO 0) <= (OTHERS => '0'); -- sh flags
        BITCOUNT_curr(COUNT_WIDTH) = '1';   -- ld flag
    else
        if (rising_edge(nextstate)) then
            BITCOUNT_curr <= BITCOUNT_next;
            sh_reg <= sh_next;
            ld_reg <= ld_next;
        elsif (falling_edge(nextstate))then
            BITCOUNT_curr <= BITCOUNT_curr;
            sh_reg <= '0';
            ld_reg <= '0';
        end if;
    end if;
end process;
-- COMBINATORIAL COMPONENT 
process(BITCOUNT_curr) begin
    BITCOUNT_next(COUNT_WIDTH DOWNTO 1) <= BITCOUNT_curr(COUNT_WIDTH-1 DOWNTO 0) -- Ring shifter
    if (BITCOUNT_next(COUNT_WIDTH) = '1') then --ld flag
        sh_next <= '0';
        ld_next <= '1';
    else
        sh_next <= '1';
        ld_next <= '0';
    end if ;
end process;

-- SIGNAL CONNECTIONS
end Behavioral;