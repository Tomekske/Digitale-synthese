-- JORDY DE HOON
-- MODULE : PNGENERATOR

library ieee;
use ieee.std_logic_1164.all;
entity PNGENERATOR is
    port ( 
        clk         :   IN  STD_LOGIC;      -- Clock signal
        reset       :   IN  STD_LOGIC;      -- Active high reset
        pn_start    :   OUT STD_LOGIC;      -- Edge detection signal
        pn_sig0     :   OUT STD_LOGIC;      -- first pn code signal
        pn_sig1     :   OUT STD_LOGIC;      -- second pn code signal
        pn_sig2     :   OUT STD_LOGIC       -- third pn code signal
    );
    end PNGENERATOR;

architecture Behavioral OF PNGENERATOR IS
    CONSTANT PNCODE1  :  STD_LOGIC_VECTOR(4 DOWNTO 0) := "00010";   -- Internal constant code for the first pn code
    CONSTANT PNCODE2  :  STD_LOGIC_VECTOR(4 DOWNTO 0) := "00111";   -- Internal constant code for the second pn code
    SIGNAL PNCODE1_pres      :  STD_LOGIC_VECTOR(4 DOWNTO 0);       -- Pressent state tracking (mem) for PNCODE1
    SIGNAL PNCODE2_pres      :  STD_LOGIC_VECTOR(4 DOWNTO 0);       -- ""                            for PNCODE2
    SIGNAL PNCODE1_next      :  STD_LOGIC_VECTOR(4 DOWNTO 0);       -- Next state decoder for PNCODE1
    SIGNAL PNCODE2_next      :  STD_LOGIC_VECTOR(4 DOWNTO 0);       -- ""                 for PNCODE2
begin

-- SYNC COMP
process(clk,reset)begin
    if(reset = '1')then         -- When reset is active
        PNCODE1_pres <= PNCODE1;    -- Load the start code for PNCODE1
        PNCODE2_pres <= PNCODE2;    -- Load the start code for PNCODE2
    else
        if (rising_edge(clk)) then      -- Reset low and rising edge on the clock
            PNCODE1_pres <= PNCODE1_next;   -- Load the next state in the memory
            PNCODE2_pres <= PNCODE2_next;   -- ""
        end if ;
    end if;
end process;

-- COMB COMP
process(PNCODE1_pres) begin
    PNCODE1_next(3 DOWNTO 0) <= PNCODE1_pres (4 DOWNTO 1);  -- Shift register
    PNCODE1_next(4) <= PNCODE1_pres(3) XOR PNCODE1_pres(0); -- Load bit calculation

    PNCODE2_next(3 DOWNTO 0) <= PNCODE2_pres (4 DOWNTO 1);  -- Shift Register
    PNCODE2_NEXT(4) <= ((PNCODE2_pres(0) XOR PNCODE2_pres(1)) XOR PNCODE2_pres(3) ) XOR PNCODE2_pres(4); -- Load bit calculation

    if((PNCODE1_pres = PNCODE1) AND (reset = '0'))then  -- When a sequence is detected and the reset is low
        pn_start <= '1';    -- Enable the start signal (sequence detected)
    else
        pn_start <= '0';    -- when reset active, force output to low
    end if;

end process;
-- SIGNAL LINKING
pn_sig0 <= PNCODE1_pres(0);     -- Link to pn_sig0
pn_sig1 <= PNCODE2_pres(0);     -- Link to pn_sig1
pn_sig2 <= PNCODE1_pres(0) XOR PNCODE2_pres(0);     -- pn_sig2 is formed with pn_code0 and pn_code2 (XOR combination)

end Behavioral;
