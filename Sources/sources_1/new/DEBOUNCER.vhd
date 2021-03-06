---------------------------------------------------------------------
-- DEV		: TOMEK JOOSTENS
-- ACADEMIC : KULEUVEN 2019-2020 CAMPUS DE NAYER
-- MODULE	: DEBOUNCER
-- INFO		:  
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity DEBOUNCER is
	port (	cha		:	IN STD_LOGIC;
			clk		:	IN STD_LOGIC;
			reset	:	IN STD_LOGIC;	-- Active high signal
			syncha	:	OUT STD_LOGIC
	);
end DEBOUNCER;

architecture Behavioral OF DEBOUNCER IS
	SIGNAL shiftreg_pres	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL shiftreg_next	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL sh				: STD_LOGIC;
begin

-- SYNC COMPONENT
process(reset, clk) begin
	if(reset = '1') then -- Reset
		shiftreg_pres <= (OTHERS=>'0');
	else	-- Normal procedure
		if(rising_edge(clk)) then
			shiftreg_pres <= shiftreg_next;
		end if;
	end if;
end process;

-- COMBINATORICAL COMPONENT
	--SHIFT REGISTER
process(cha, shiftreg_pres(4), sh, clk) begin
	sh <= cha xor shiftreg_pres(4);
	if(sh = '1') then -- shift register
		shiftreg_next(0) <= cha;
		shiftreg_next(1) <= shiftreg_pres(0);
		shiftreg_next(2) <= shiftreg_pres(1);
		shiftreg_next(3) <= shiftreg_pres(2);
		shiftreg_next(4) <= shiftreg_pres(3); -- delay bit
	else -- load register
		shiftreg_next <= (others => shiftreg_pres(3));
	end if;
end process;	
-- SIGNAL CONNECTIONS
syncha <= shiftreg_pres(4);
end Behavioral;