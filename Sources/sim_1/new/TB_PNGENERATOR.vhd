-- JORDY DE HOON
-- MODULE : TB_PNGENERATOR
library ieee;
use ieee.std_logic_1164.all;

entity PNGENERATOR_tb is
    end PNGENERATOR_tb;

architecture structural of PNGENERATOR_tb is

component PNGENERATOR
    port ( 
        clk         :   IN  STD_LOGIC;   -- Clock signal
        reset       :   IN  STD_LOGIC;   -- Active high reset
        pn_start    :   OUT STD_LOGIC;   -- Edge detection signal
        pn_sig0     :   OUT STD_LOGIC;
        pn_sig1     :   OUT STD_LOGIC;
        pn_sig2     :   OUT STD_LOGIC
    );
    end component;


for uut : PNGENERATOR use entity work.PNGENERATOR(Behavioral);

constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk          : std_logic;
signal reset        : std_logic;
signal pn_start    : STD_LOGIC;
signal pn_sig0     : STD_LOGIC;
signal pn_sig1     : STD_LOGIC;
signal pn_sig2     : STD_LOGIC;


BEGIN

    uut: PNGENERATOR 
    PORT MAP(clk,reset,pn_start,pn_sig0,pn_sig1,pn_sig2);

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
    procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
        begin
        reset       <= stimvect(0);
       -- wait for period;
    end tbvector;
    BEGIN
        
        tbvector("00");       -- Do nothing
        wait for 4*period;
        tbvector("01");       -- Reset module
        wait for 4*period;
        tbvector("00");       -- Do nothing, code generated
        wait for 100*period;
        end_of_sim <= true;
        wait;
    END PROCESS;

    END;


