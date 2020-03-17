-- JORDY DE HOON & TOMEK JOOSTENS
-- MODULE : TB_ACCES_LAYER
library ieee;
use ieee.STD_LOGIC_1164.all;

entity ACCES_LAYER_tb is
    end ACCES_LAYER_tb;

architecture structural of ACCES_LAYER_tb is

component ACCES_LAYER
    port ( 
        clk         :   IN STD_LOGIC;   -- Clock SIGNAL
        reset       :   IN STD_LOGIC;   -- Active high reset
        sdo         :   IN STD_LOGIC;
        mode        :   IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        pn_start    :   OUT STD_LOGIC;
        sdo_spread  :   OUT STD_LOGIC
    );
    end component;
    
for uut : ACCES_LAYER use entity work.ACCES_LAYER(Behavioral);

CONSTANT period : time := 100 ns;
CONSTANT delay  : time :=  10 ns;
SIGNAL end_of_sim : boolean := false;

SIGNAL clk          : STD_LOGIC;
SIGNAL reset        : STD_LOGIC;
SIGNAL mode         : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL sdo          : STD_LOGIC;
SIGNAL pn_start     : STD_LOGIC;
SIGNAL sdo_spread   : STD_LOGIC;

BEGIN

    uut: ACCES_LAYER
    PORT MAP(clk, reset, sdo, mode, pn_start, sdo_spread);

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
    procedure tbvector(CONSTANT stimvect : IN STD_LOGIC_vector(3 DOWNTO 0))is
    begin
        reset <= stimvect(3);
        sdo <= stimvect(2);
        mode <= stimvect(1 DOWNTO 0);
    end tbvector;
    BEGIN
        -- Test async reset
        tbvector("1000");   -- Reset active
        wait for period * 4;
        tbvector("0000"); -- Reset disable : start process
        
        wait until pn_start='1'; -- Next sequence PN generator
        tbvector("0000"); -- mux_out = sdo

        wait until pn_start='1';
        tbvector("0100"); -- mux_out = sdo

        wait until pn_start='1';
        tbvector("0000");

        wait until pn_start='1';
        tbvector("0101");

        wait until pn_start='1';
        tbvector("0001");

        wait until pn_start='1';
        tbvector("0110");

        wait until pn_start='1';
        tbvector("0010");

        wait until pn_start='1';
        tbvector("0111");

        wait until pn_start='1';
        tbvector("0011");

        wait until pn_start='1';
        tbvector("0000");

        --end of sim
        end_of_sim <= true;
        wait;
    END PROCESS;

    END;


