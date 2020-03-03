-- JORDY DE HOON
-- MODULE : PNGENERATOR
-- INFO : Using a state machine to track the state of sig and generate a puls on the rising edge
library ieee;
use ieee.std_logic_1164.all;
entity PNGENERATOR is
    port ( 
        clk         :   IN  STD_LOGIC;   -- Clock signal
        reset       :   IN  STD_LOGIC;   -- Active high reset
        pn_start    :   OUT STD_LOGIC;   -- Edge detection signal
        pn_sig0     :   OUT STD_LOGIC;
        pn_sig1     :   OUT STD_LOGIC;
        pn_sig2     :   OUT STD_LOGIC
    );
    end PNGENERATOR;

architecture Behavioral OF PNGENERATOR IS
    CONSTANT SIGNAL PNCODE1  :  STD_LOGIC_VECTOR(4 DOWNTO 0) := "00010";
    CONSTANT SIGNAL PNCODE2  :  STD_LOGIC_VECTOR(4 DOWNTO 0) := "00111";
    SIGNAL PNCODE1_pres      :  STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL PNCODE2_pres      :  STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL PNCODE1_next      :  STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL PNCODE2_next      :  STD_LOGIC_VECTOR(4 DOWNTO 0);
begin

-- SYNC COMP
process(clk,reset)begin
    if(reset = '1')then
        PNCODE1_pres <= PNCODE1;
        PNCODE2_pres <= PNCODE2;
    else
        if (rising_edge(clk)) then
            PNCODE1_pres <= PNCODE1_next;
            PNCODE2_pres <= PNCODE2_next;
        end if ;
    end if;
end process;

-- COMB COMP
process(PNCODE1_pres) begin
    PNCODE1_next(3 DOWNTO 0) <= PNCODE1_pres (4 DOWNTO 1);
    PNCODE1_next(4) <= PNCODE1_pres(3) XOR PNCODE1_pres(0);

    PNCODE2_next(3 DOWNTO 0) <= PNCODE2_pres (4 DOWNTO 1);
    PNCODE2_NEXT(4) <= ((PNCODE2_pres(0) XOR PNCODE2_pres(1)) XOR PNCODE2_pres(3) ) XOR PNCODE2_pres(4);

    if(PNCODE1_pres = PNCODE1)then
        pn_start <= '1';
    else
        pn_start <= '0';
    end if;

end process;
-- SIGNAL LINKING
pn_sig0 <= PNCODE1_pres(0);
pn_sig1 <= PNCODE2_pres(0);
pn_sig2 <= PNCODE1_pres(0) XOR PNCODE2_pres(0);

end Behavioral;
