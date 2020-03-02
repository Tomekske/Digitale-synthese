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
            clk         : IN STD_LOGIC;     -- Clk signal
            reset       : IN STD_LOGIC;     -- Reset signal
            nextstate   : IN STD_LOGIC;     -- Input signal to next state
            sh_reg      : OUT STD_LOGIC;    -- Shift signal for registers (output)
            ld_reg      : OUT STD_LOGIC     -- Load signal for registers (output)
    );
end SEQUENCECONTROLLER;

architecture Behavioral OF SEQUENCECONTROLLER IS
    SIGNAL BITCOUNT_curr     : STD_LOGIC_VECTOR(COUNT_WIDTH DOWNTO 0);
    SIGNAL BITCOUNT_next     : STD_LOGIC_VECTOR(COUNT_WIDTH DOWNTO 0);
    SIGNAL shiftreg_pres     : STD_LOGIC;
    SIGNAL shiftreg_next     : STD_LOGIC;
    SIGNAL sh_pres           : STD_LOGIC;
    SIGNAL ld_pres           : STD_LOGIC;
    SIGNAL sh_next           : STD_LOGIC;
    SIGNAL ld_next           : STD_LOGIC;
    begin

-- SYNC COMPONENT
process(reset,clk) begin
    if (reset ='1') then
        BITCOUNT_curr(COUNT_WIDTH DOWNTO 0) <= (OTHERS => '0'); -- sh flags all 0
        BITCOUNT_curr(COUNT_WIDTH) <= '1';   -- ld flag set to 1
        sh_pres <= '0';     -- Set output sh to 0
        ld_pres <= '0';     -- Set output ld to 0
        shiftreg_pres <= '0';
    else
        if (rising_edge(clk)) then
            shiftreg_pres <= shiftreg_next;
            if((nextstate = '1')AND(shiftreg_pres = '0'))then   -- Rising edge detect with nexstate input (faster)
                BITCOUNT_curr <= BITCOUNT_next;     -- new state of state machine
                sh_pres <= sh_next;     -- load the next output state
                ld_pres <= ld_next;     -- load the next output state
            else
                BITCOUNT_curr <= BITCOUNT_curr;     -- stay at current state
                sh_pres <= sh_pres;     -- keep output the same
                ld_pres <= ld_pres;     -- keep output the same
            end if;
            -- Dominant if (nextstate low force output to zero)
            if(nextstate = '0')then
                sh_pres <= '0';         -- force output to zero
                ld_pres <= '0';         -- force output to zero
            end if;
        end if;
    end if;
end process;

-- COMBINATORIAL COMPONENT 
process(BITCOUNT_curr,nextstate,shiftreg_pres) begin
    shiftreg_next <= nextstate;     -- DFF shift register of 1 bit for edge detection

    -- BITCOUNT_next <= BITCOUNT_curr rol 1;        -- Ring shifter
    BITCOUNT_next(COUNT_WIDTH DOWNTO 1) <= BITCOUNT_curr(COUNT_WIDTH-1 DOWNTO 0);   -- Ring counter
    BITCOUNT_next(0) <= BITCOUNT_curr(COUNT_WIDTH);
    --sh_next <= NOT ld_next;
    if (BITCOUNT_curr(COUNT_WIDTH) = '1') then   -- ld flag
        sh_next <= '0';
        ld_next <= '1';
    else                    -- Sh flags
        sh_next <= '1';
        ld_next <= '0';
    end if ;
end process;
-- SIGNAL CONNECTIONS
sh_reg <= sh_pres;
ld_reg <= ld_pres;
end Behavioral;