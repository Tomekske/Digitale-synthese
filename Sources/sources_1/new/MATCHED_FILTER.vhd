-- TOMEK JOOSTENS
-- MODULE : MATCHED_FILTER

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MATCHED_FILTER is
    Port ( 
        clk             : IN STD_LOGIC;
        reset           : IN STD_LOGIC;     -- Reset signal
        chip_sample     : IN STD_LOGIC;     -- Synchronisatie bit reset counter naar default waarde
        sdi_spread      : IN STD_LOGIC;
        dipswitches     : IN STD_LOGIC_VECTOR(1 downto 0); -- De dipswitches
        seq_det         : OUT STD_LOGIC -- Dit is de databit die naar buiten wordt gestuurd
    );
end MATCHED_FILTER;

architecture Behavioral of MATCHED_FILTER is
CONSTANT no_ptrn            : STD_LOGIC_VECTOR(30 DOWNTO 0) := (OTHERS => '0');
CONSTANT ml_1_ptrn          : STD_LOGIC_VECTOR(30 DOWNTO 0) := "0100001010111011000111110011010";
CONSTANT ml_2_ptrn          : STD_LOGIC_VECTOR(30 DOWNTO 0) := "1110000110101001000101111101100";
CONSTANT gold_code_ptrn     : STD_LOGIC_VECTOR(30 DOWNTO 0) := ml_1_ptrn xor ml_2_ptrn;

SIGNAL pn_ptrn     : STD_LOGIC_VECTOR(30 DOWNTO 0);

SIGNAL shift_pres   : STD_LOGIC_VECTOR(30 DOWNTO 0);
SIGNAL shift_next   : STD_LOGIC_VECTOR(30 DOWNTO 0);

SIGNAL seq_det_raw : STD_LOGIC;
SIGNAL seq_det_delayed : STD_LOGIC;

begin
-- SEQUENTIEEL
process(reset, clk) begin
    if(reset = '1') then
        -- Een niet standaard patroon maken
        shift_pres <= (OTHERS => '0');
        shift_pres(0) <= '1';
    else
        if( rising_edge(clk)) then
            if(chip_sample = '1') then
                shift_pres <= shift_next;
            end if;
        end if;
    end if;
end process;

-- COMBINATORISCH
-- Inlezen van de codes
process(dipswitches) begin
    case(dipswitches) is
        when "00" => pn_ptrn <= no_ptrn;
        when "01" => pn_ptrn <= ml_1_ptrn;
        when "10" => pn_ptrn <= ml_2_ptrn;
        when "11" => pn_ptrn <= gold_code_ptrn;
        when OTHERS => pn_ptrn <= no_ptrn;      
    end case;
end process;

-- Naar links shiften
shift_next(30 DOWNTO 1) <= shift_pres(29 DOWNTO 0); 
shift_next(0) <= sdi_spread; -- Concatenate de sdi_spread bit

-- vergelijken van de patronen en de seq_det output bepalen 
process(shift_pres, pn_ptrn) begin
    if((pn_ptrn = shift_pres) or (not(pn_ptrn) = shift_pres)) then
        seq_det_raw <= '1';
    else
        seq_det_raw <= '0';
    end if;
end process;

-- DECODER
process(clk, reset, seq_det_raw, seq_det_delayed) begin
    if(reset = '1') then
        seq_det_delayed <= '0';
        seq_det <= '0';
    else
        if(rising_edge(clk)) then
            seq_det_delayed <= seq_det_raw;

            if (seq_det_raw = '1' and seq_det_delayed = '0') then
                seq_det <= '1';
            else 
                seq_det <= '0';
            end if;
        end if;
    end if;
end process;
end Behavioral;
