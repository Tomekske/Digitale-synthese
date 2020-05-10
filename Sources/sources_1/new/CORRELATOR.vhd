-- Tomek Joostens
-- MODULE : CORRELATOR

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity CORRELATOR is
    Port ( 
        clk             : IN STD_LOGIC;
        reset           : IN STD_LOGIC;     -- Reset signal
        chip_sample     : IN STD_LOGIC;     -- Synchronisatie bit reset counter naar default waarde
        sdi_despread    : IN STD_LOGIC;
        bit_sample      : IN STD_LOGIC; 
        databit         : OUT STD_LOGIC     -- Dit is de databit die naar buiten wordt gestuurd
    );
end CORRELATOR;

architecture Behavioral of CORRELATOR is
    -- De count_next en count_pres bevatten de default waarde 32 waar er getallen 
    -- worden bij opgeteld of afgetrokken naargelang de waarde van sdi_despread
	SIGNAL count_next   : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100000";
	SIGNAL count_pres   : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100000";
	
	-- Dit is de treshold waarde voor de majority bepaling  
	CONSTANT treshold : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100000";
begin

-- SYNC COMPONENT
process(reset, clk) begin
    -- Async reset:
    if(reset = '1') then
        databit <= '0';
        count_pres <= treshold;
    else
        if (rising_edge(clk)) then
            -- Het reseten van de count_pres naar de treshold waarde '32'
            if(bit_sample = '1') then
                count_pres <= treshold;
                -- Het naar buiten brengen van de databit
                databit <= count_pres(5);
            end if;
            -- Bij elke chip_sample wordt de count_pres geupdate met de huidige counter waarde
            if(chip_sample = '1') then
                count_pres <= count_next;
            end if;
        end if;
    end if;
end process;

-- COMBINATORISCH COMPONENT
process(count_pres, chip_sample, sdi_despread, clk) begin
    -- Als er een logische '1' binnen komt van de sdi_despread dan wordt deze met 1 optgeteld
    if(sdi_despread = '1') then
        -- Overflow check
        if(count_pres = "111111") then
            count_next <= count_pres;
        else
            count_next <= count_pres + 1;
        end if;
    -- Als er een logische '0' binnen komt van de sdi_despread dan wordt deze met 1 afgetrokken
    else
        -- Overflow check
        if(count_pres = "000000") then
            count_next <= count_pres;
        else
            count_next <= count_pres - 1;
        end if;
    end if;
end process;
end Behavioral;
