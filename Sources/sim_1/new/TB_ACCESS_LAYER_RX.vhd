---------------------------------------------------------------------
-- DEV		: JORDY DE HOON
-- ACADEMIC : KULEUVEN 2019-2020 CAMPUS DE NAYER
-- MODULE	: TB_ACCESS_LAYER_RX
-- INFO		:  
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity TB_ACCESS_LAYER_RX is
end TB_ACCESS_LAYER_RX;

architecture structural of TB_ACCESS_LAYER_RX is 
-- Component Declaration
component ACCES_LAYER_RX
    port(
        clk         : IN STD_LOGIC;
        reset       : IN STD_LOGIC;
        sdi_spread  : IN STD_LOGIC;
        pn_mode     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        databit     : OUT STD_LOGIC;
        bitsample   : OUT STD_LOGIC
    );
end component;

for uut : ACCES_LAYER_RX use entity work.ACCES_LAYER_RX(Behavioral);

constant period     : time := 100 ns;
constant delay      : time :=  10 ns;
signal end_of_sim   : boolean := false;

SIGNAL clk         : STD_LOGIC;
SIGNAL reset       : STD_LOGIC;
SIGNAL sdi_spread  : STD_LOGIC;
SIGNAL pn_mode     : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL databit     : STD_LOGIC;
SIGNAL bitsample   : STD_LOGIC;  

BEGIN

uut: ACCES_LAYER_RX
    PORT MAP(clk, reset, sdi_spread, pn_mode, databit, bitsample);

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
    procedure tbvector(constant stimvect : in std_logic_vector(3 DOWNTO 0)) is
    begin
        reset <= stimvect(3);
        sdi_spread <= stimvect(2);
        pn_mode <= stimvect(1 DOWNTO 0);
        -- wait for period;
    end tbvector;
    BEGIN
    
        -- Reset state (reset, ld, sh, data); expected -> data_pres = '0'
        tbvector("1000");
        wait for period * 10;

        tbvector("0100");
        for i in 0 to 10 loop         
            wait for 31 * period;    
        end loop ;
        
        tbvector("0000");
        for i in 0 to 10 loop         
            wait for 31 * period;    
        end loop ;
        
        tbvector("0100");
        for i in 0 to 10 loop         
            wait for 31 * period;    
        end loop ;

        end_of_sim <= true;
        wait;
    END PROCESS;
END;


