library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MATCHED_FILTER is
    Port ( 
        clk             : IN STD_LOGIC;
        reset           : IN STD_LOGIC;     -- Reset signal
        chip_sample     : IN STD_LOGIC;     -- Synchronisatie bit reset counter naar default waarde
        sdi_spread      : IN STD_LOGIC;
        dipswitches     : IN STD_LOGIC_VECTOR(1 downto 0); -- De dipswitches
        seq_det  : OUT STD_LOGIC -- Dit is de databit die naar buiten wordt gestuurd
    );
end MATCHED_FILTER;

architecture Behavioral of MATCHED_FILTER is
CONSTANT no_ptrn            : STD_LOGIC_VECTOR(30 DOWNTO 0) := (OTHERS => '0');
CONSTANT no_ptrn_inv        : STD_LOGIC_VECTOR(30 DOWNTO 0) := not(no_ptrn); -- inverteren van de no_ptrn

CONSTANT ml_1_ptrn          : STD_LOGIC_VECTOR(30 DOWNTO 0) := "0100001010111011000111110011010";
CONSTANT ml_1_ptrn_inv      : STD_LOGIC_VECTOR(30 DOWNTO 0) := not(no_ptrn);

CONSTANT ml_2_ptrn          : STD_LOGIC_VECTOR(30 DOWNTO 0) := "1110000110101001000101111101100";
CONSTANT ml_2_ptrn_inv      : STD_LOGIC_VECTOR(30 DOWNTO 0) := not(no_ptrn);

CONSTANT gold_code_ptrn     : STD_LOGIC_VECTOR(30 DOWNTO 0) := ml_1_ptrn xor ml_2_ptrn;
CONSTANT gold_code_ptrn_inv : STD_LOGIC_VECTOR(30 DOWNTO 0) := not(gold_code_ptrn);

SIGNAL pn_ptrn     : STD_LOGIC_VECTOR(30 DOWNTO 0);
SIGNAL pn_ptrn_inv : STD_LOGIC_VECTOR(30 DOWNTO 0);

SIGNAL shift_pres   : STD_LOGIC_VECTOR(30 DOWNTO 0);
SIGNAL shift_next   : STD_LOGIC_VECTOR(30 DOWNTO 0);

begin
-- SEQUENTIEEL
process(reset, clk) begin
    if(reset = '1') then
        shift_pres <= (OTHERS => '0');
    else
        if(chip_sample = '1') then
             shift_pres <= shift_next;
        end if;
    end if;
end process;

-- COMBINATORISCH
-- Inlezen van de codes
process(dipswitches) begin
    case dipswitches is
        when "00" => pn_ptrn <= no_ptrn; pn_ptrn_inv <= no_ptrn_inv;
        when "01" => pn_ptrn <= ml_1_ptrn; pn_ptrn_inv <= ml_1_ptrn_inv;
        when "10" => pn_ptrn <= ml_2_ptrn; pn_ptrn_inv <= ml_2_ptrn_inv;
        when "11" => pn_ptrn <= gold_code_ptrn; pn_ptrn_inv <= gold_code_ptrn_inv;        
    end case;
end process;

-- Naar links shiften
process(chip_sample, sdi_spread, shift_pres) begin
    shift_next(30 DOWNTO 1) <= shift_pres(30 DOWNTO 1); 
    shift_next(0) <= sdi_spread; -- Concatenate de sdi_spread bit
end process;

-- vergelijken van de patronen en de seq_det output bepalen 
process(shift_pres, pn_ptrn, pn_ptrn_inv) begin
    if((shift_pres = pn_ptrn) or (shift_pres = pn_ptrn_inv)) then
        seq_det <= '1';
    else
        seq_det <= '0';
    end if;
end process;
end Behavioral;
