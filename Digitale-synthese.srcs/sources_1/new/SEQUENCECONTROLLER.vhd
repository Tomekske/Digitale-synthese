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
    SIGNAL shiftreg_pres     : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL shiftreg_next     : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL risingedge        : STD_LOGIC;
    SIGNAL fallingedge       : STD_LOGIC;
    SIGNAL sh_pres           : STD_LOGIC;
    SIGNAL ld_pres           : STD_LOGIC;
    SIGNAL sh_next           : STD_LOGIC;
    SIGNAL ld_next           : STD_LOGIC;
    begin

-- SYNC COMPONENT
process(reset,clk,risingedge,fallingedge) begin
    if (reset ='1') then
        BITCOUNT_curr(COUNT_WIDTH DOWNTO 0) <= (OTHERS => '0'); -- sh flags all 0
        BITCOUNT_curr(COUNT_WIDTH) <= '1';   -- ld flag set to 1
        sh_pres <= '0';     -- Set output sh to 0
        ld_pres <= '0';     -- Set output ld to 0
        shiftreg_pres <= (OTHERS => '0');
    else
        if (rising_edge(clk)) then
            shiftreg_pres <= shiftreg_next;
            if((nextstate = '1')AND(shiftreg_pres(0) = '0'))then
                BITCOUNT_curr <= BITCOUNT_curr;
                sh_pres <= sh_next;
                ld_pres <= ld_next;
            elsif(fallingedge = '1')then
                BITCOUNT_curr <= BITCOUNT_next;
                --sh_pres <= '0';
                --ld_pres <= '0';
            else
                BITCOUNT_curr <= BITCOUNT_curr;
                sh_pres <= sh_pres;
                ld_pres <= ld_pres;
            end if;
            -- Dominant if (nextstate low force output to zero, MEALLY)
            if(nextstate = '0')then
                sh_pres <= '0';
                ld_pres <= '0';
            end if;
        end if;
    end if;
end process;

-- COMBINATORIAL COMPONENT 
process(BITCOUNT_curr,nextstate,shiftreg_pres) begin
    shiftreg_next(0) <= nextstate;
    shiftreg_next(1) <= shiftreg_pres(0); 

    risingedge <= nextstate AND (NOT shiftreg_pres(0));
    fallingedge <= (NOT nextstate) AND shiftreg_pres(0);

    -- BITCOUNT_next <= BITCOUNT_curr rol 1;        -- Ring shifter
    BITCOUNT_next(COUNT_WIDTH DOWNTO 1) <= BITCOUNT_curr(COUNT_WIDTH-1 DOWNTO 0);
    BITCOUNT_next(0) <= BITCOUNT_curr(COUNT_WIDTH);
    --sh_next <= NOT ld_next;
    if (BITCOUNT_curr(COUNT_WIDTH) = '1') then   -- ld flag
        sh_next <= '0';
        ld_next <= '1';
    else
        sh_next <= '1';
        ld_next <= '0';
    end if ;
end process;
-- SIGNAL CONNECTIONS
sh_reg <= sh_pres;
ld_reg <= ld_pres;
end Behavioral;