-- JORDY DE HOON / TOMEK JOOSTENS
-- FILE: DEBOUNCER

-- FF nodig
library ieee;
use ieee.std_logic_1164.all;
entity DATAREGISTER is
generic(SHIFT_WIDTH : integer);
	port (
        clk     : IN STD_LOGIC;
        reset   : IN STD_LOGIC;                                     -- Reset signal
        ld      : IN STD_LOGIC;                                     -- load from the sequence controller
        sh      : IN STD_LOGIC;                                     -- shift data from the sequence controller
        data    : IN STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 downto 0);    -- variavle input data
        sdo     : OUT STD_LOGIC                                     -- serial data out
    );
end DATAREGISTER;

architecture Behavioral OF DATAREGISTER IS
	SIGNAL data_next   : STD_LOGIC_VECTOR(SHIFT_WIDTH-1 DOWNTO 0);
	SIGNAL data_pres   : STD_LOGIC_VECTOR(SHIFT_WIDTH-1 DOWNTO 0);
begin
-- SYNC COMPONENT
process(reset,clk) begin
    -- Async reset:
    -- data_pres signal is initialised with logic zeros on an active reset
    if (reset  = '1') then
        data_pres <= (others => '0');
    -- On every other values data_pres signal is initlialised with the calculated value
    else
        -- Only initialise data_pres values on a rising clock edge
        if (rising_edge(clk)) then
            -- On an active shift assign data_next signal to data_pres signal
            if ((sh = '1') AND (ld = '0')) then
                data_pres <= data_next;
            -- On an active load, assign the entity's input data to the data_pres signal
            elsif((sh = '0') AND (ld = '1')) then
                data_pres <= data;
            end if;
        end if;
    end if;
end process;

-- COMB COMPONENT
process(data_pres,clk) begin
    -- data_next is calculted by bitshifting the array
    -- data_next(SHIFT_WIDTH - 1 DOWNTO 1): only values between (MSB and LSB + 1) are assigned
    -- data_pres(SHIFT_WIDTH - 2 DOWNTO 0): only value between(MSB - 1 and LSB) are shifted 
    data_next(SHIFT_WIDTH - 1 DOWNTO 1) <= data_pres(SHIFT_WIDTH - 2 DOWNTO 0);
    -- The LSB bit is assigned with a logic zero bit
    data_next(0) <= '0';
end process;
--SIGNAL LINK
-- serial data out contains only one bit -> MSB
sdo <= data_pres(SHIFT_WIDTH - 1);
end Behavioral;
