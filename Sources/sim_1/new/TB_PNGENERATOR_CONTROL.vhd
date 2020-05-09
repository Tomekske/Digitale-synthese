-- JORDY DE HOON
-- MODULE : TB_PNGENERATOR
library ieee;
use ieee.std_logic_1164.all;

entity PNGENERATOR_CONTROL_tb is
    end PNGENERATOR_CONTROL_tb;

architecture structural of PNGENERATOR_CONTROL_tb is

component PNGENERATOR_CONTROL
    port ( 
        clk         :   IN  STD_LOGIC;      -- Clock signal
        reset       :   IN  STD_LOGIC;      -- Active high reset
        shift       :   IN  STD_LOGIC;      -- Shift signal
        clear       :   IN  STD_LOGIC;      -- Clear or sync reset the component
        pn_start    :   OUT STD_LOGIC;      -- Edge detection signal
        full_seq    :   OUT STD_LOGIC;
        pn_sig0     :   OUT STD_LOGIC;      -- first pn code signal
        pn_sig1     :   OUT STD_LOGIC;      -- second pn code signal
        pn_sig2     :   OUT STD_LOGIC       -- third pn code signal
    );
    end component;


for uut : PNGENERATOR_CONTROL use entity work.PNGENERATOR_CONTROL(Behavioral);

constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk         : std_logic;
signal reset       : std_logic;
SIGNAL shift       : STD_LOGIC;      -- Shift signal
SIGNAL clear       : STD_LOGIC;      -- Clear or sync reset the component
SIGNAL pn_start    : STD_LOGIC;      -- Edge detection signal
SIGNAL full_seq    : STD_LOGIC;
signal pn_sig0     : STD_LOGIC;
signal pn_sig1     : STD_LOGIC;
signal pn_sig2     : STD_LOGIC;


BEGIN

    uut: PNGENERATOR_CONTROL 
    PORT MAP(clk,reset,shift,clear,pn_start,full_seq,pn_sig0,pn_sig1,pn_sig2);

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
    procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0))is
        begin
        reset       <= stimvect(2);
        clear       <= stimvect(1);
        shift       <= stimvect(0);
        wait for period;
    end tbvector;
    BEGIN
        
        tbvector("000");       -- Do nothing
        wait for 4*period;
        tbvector("100");       -- Reset module
        wait for 4*period;

        for i in 0 to 30 loop
            tbvector("001");
            tbvector("000");
        end loop;
        
        tbvector("010");       -- Do nothing, code generated
        wait for 2*period;

        for i in 0 to 30 loop
            tbvector("001");
            tbvector("000");
        end loop;

        tbvector("000");
        wait for 100*period;
    
        end_of_sim <= true;
        wait;
    END PROCESS;

    END;


