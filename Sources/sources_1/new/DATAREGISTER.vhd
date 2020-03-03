-- JORDY DE HOON / TOMEK JOOSTENS
-- FILE: DEBOUNCER

-- FF nodig
library ieee;
use ieee.std_logic_1164.all;
entity DATAREGISTER is
generic(COUNT_WIDTH : integer);
	port (
        clk     : IN STD_LOGIC;
        ld      : IN STD_LOGIC; -- load from the sequence controller
        sh      : IN STD_LOGIC; -- shift data from the sequence controller
        data    : IN STD_LOGIC_VECTOR(COUNT_WIDTH - 1 downto 0); -- variavle input data
        sdo     : OUT STD_LOGIC -- serial data out
    );
    end DATAREGISTER;

architecture Behavioral OF DATAREGISTER IS
	SIGNAL sdo_old     : STD_LOGIC_VECTOR(COUNT_WIDTH-1 DOWNTO 0);
	SIGNAL ld_old      : STD_LOGIC;
	SIGNAL sh_old      : STD_LOGIC;
	

-- SYNC COMPONENT
process(clk) begin
    if(rising_edge(clk)) then
    if((ld = '1') AND (ld_old = '0')) then   -- Rising edge detect with nexstate input (faster)
        
    end if;
end process;

-- COMBINATORICAL COMPONENT
	--SHIFT REGISTER
--process(cha, shiftreg_pres(4), sh, clk) begin
--	sh <= cha xor shiftreg_pres(4);
--	if(sh = '1') then -- shift register
--		shiftreg_next(0) <= cha;
--		shiftreg_next(1) <= shiftreg_pres(0);
--		shiftreg_next(2) <= shiftreg_pres(1);
--		shiftreg_next(3) <= shiftreg_pres(2);
--		shiftreg_next(4) <= shiftreg_pres(3); -- delay bit
--	else -- load register
--		shiftreg_next <= (others => shiftreg_pres(3));
--	end if;
--end process;	
---- SIGNAL CONNECTIONS
--syncha <= shiftreg_pres(4);
--end Behavioral;