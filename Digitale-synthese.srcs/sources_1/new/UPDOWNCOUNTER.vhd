-- JORDY DE HOON
-- MODULE : UPDOWNCOUNTER
-- INFO : SYNCH UP DOWN COUNTER

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

CONSTANT COUNT_WIDTH    : integer := 4;     -- Bit size of the counter
entity UPDOWNCOUNTER is
    port ( 
        up      :   IN STD_LOGIC;   -- count up signal
        down    :   IN STD_LOGIC;   -- count down signal
        clk     :   IN STD_LOGIC;   -- Clock signal
        reset   :   IN STD_LOGIC;   -- Active high reset
        count   :   OUT STD_LOGIC_VECTOR(COUNT_WIDTH-1 DOWNTO 0)   -- Edge detection signal
    );
end UPDOWNCOUNTER;

architecture Behavioral OF UPDOWNCOUNTER IS
    SIGNAL count_pres   : STD_LOGIC_VECTOR(COUNT_WIDTH-1 DOWNTO 0);     -- Internal mem for present state
    SIGNAL count_next   : STD_LOGIC_VECTOR(COUNT_WIDTH-1 DOWNTO 0);     -- Internal signal for next state
-- SYNC COMPONENT
process(clk,reset) begin
    if (reset = '1') then               -- Reset enable
        count_pres <= (OTHERS => '0');  -- Load mem with 0 (zeros)
    else                                -- Reset low
        if(rising_edge(clk))then        -- clk edge
            count_pres <= count_next;   -- load next state to present state
        end if;
    end if ;
end process;
-- COMBINATORIAL COMPONENT 
process(up,down,count_pres) begin
    if(up = '1') then                   -- Count up 
        count_next <= count_pres + 1;   -- next state 1 bit value higer (+1)
    elsif(down = '1') then              -- Count Down
        count_next <= count_pres - 1;   -- next state 1 bit value lower (-1)
    else                                -- When not down or up (both low) next state is present state
        count_next <= count_pres;
    end if;
end process;
-- SIGNAL CONNECTIONS
count <= count_pres;                    -- Link present state to ouput (count) of module
end Behavioral;