---------------------------------------------------------------------
-- DEV		: JORDY DE HOON
-- ACADEMIC : KULEUVEN 2019-2020 CAMPUS DE NAYER
-- MODULE	: TB_DATASHIFTREG
-- INFO		: SERIAL TO PARRALEL SHIFT REGISTER TESTBENCH
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity TB_DATASHIFTREG is
end TB_DATASHIFTREG;

architecture structural of TB_DATASHIFTREG is 
constant SHIFT_WIDTH : integer := 8;
-- Component Declaration
component DATASHIFTREG
generic(SHIFT_WIDTH : integer);
    port(
        reset       : IN STD_LOGIC;     -- ASYNC RESET
        clk         : IN STD_LOGIC;     -- CLK
        sdi         : IN STD_LOGIC;     -- Serial data in
        sh          : IN STD_LOGIC;     -- shift signal
        pdo         : OUT STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 DOWNTO 0)    -- Parrallel data out
    );
end component;

FOR uut : DATASHIFTREG USE ENTITY work.DATASHIFTREG(Behavioral);

CONSTANT period     :   time := 100 ns;
CONSTANT delay      :   time :=  10 ns;
SIGNAL end_of_sim   :   boolean := false;

SIGNAL reset       : IN STD_LOGIC;     -- ASYNC RESET
SIGNAL clk         : IN STD_LOGIC;     -- CLK
SIGNAL sdi         : IN STD_LOGIC;     -- Serial data in
SIGNAL sh          : IN STD_LOGIC;     -- shift signal
SIGNAL pdo         : OUT STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 DOWNTO 0);    -- Parrallel data out
BEGIN

uut: DATASHIFTREG
    generic map(SHIFT_WIDTH => SHIFT_WIDTH)
    PORT MAP(clk, reset, sdi, sh, pdo);

clock : process
    begin 
        clk <= '0';
        wait for period/2;
        
        loop
            clk <= '0';
            wait for period/2;
            clk <= '1';
            wait for period/2;
            exit when end_of_sim;
        end loop;
        
        wait;
end process clock;
    
tb : PROCESS
    procedure tbvector(constant stimvect : in STD_LOGIC_VECTOR(2 DOWNTO 0)) is
    begin
        reset   <= stimvect(2);
        sdi     <= stimvect(1);
        sh      <= stimvect(0);
        wait for period;
    end tbvector;
    BEGIN
    
        -- Reset state (reset, ld, sh, data); expected -> data_pres = '0'
        tbvector("100");
        wait for 3 * period;
        tbvector("100");
        wait for 3 * period;

        for i in 0 to 10 loop
            tbvector("011");
            tbvector("010");
        end loop;
        
        end_of_sim <= true;
        wait;
    END PROCESS;
END;


