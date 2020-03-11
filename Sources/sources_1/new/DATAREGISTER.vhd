-- JORDY DE HOON / TOMEK JOOSTENS
-- FILE: DEBOUNCER

-- FF nodig
library ieee;
use ieee.std_logic_1164.all;
entity DATAREGISTER is
generic(SHIFT_WIDTH : integer);
	port (
        clk     : IN STD_LOGIC;
        ld      : IN STD_LOGIC;                                     -- load from the sequence controller
        reset   : IN STD_LOGIC;                                     -- Reset signal
        sh      : IN STD_LOGIC;                                     -- shift data from the sequence controller
        data    : IN STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 downto 0);    -- variavle input data
        sdo     : OUT STD_LOGIC                                     -- serial data out
    );
end DATAREGISTER;

architecture Behavioral OF DATAREGISTER IS
	SIGNAL data_curr   : STD_LOGIC_VECTOR(SHIFT_WIDTH-1 DOWNTO 0);
	SIGNAL data_pres   : STD_LOGIC_VECTOR(SHIFT_WIDTH-1 DOWNTO 0);
	SIGNAL ld_old      : STD_LOGIC;
	SIGNAL sh_old      : STD_LOGIC;
	

begin
-- SYNC COMPONENT
process(reset,clk) begin
    if (reset ='1') then
    data_pres <= (others => '0');
    
    else
        if (rising_edge(clk)) then
            if ((sh = '1') AND (ld = '0')) then
                --
            elsif((sh = '0') AND (ld = '1')) then
                --
            end if;
        end if;
    end if;
end process;
