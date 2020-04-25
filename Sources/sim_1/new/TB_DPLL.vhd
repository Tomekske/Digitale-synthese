library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity TB_DPLL is
end TB_DPLL;

architecture structural of TB_DPLL is 
-- Component Declaration
component DPLL
    port ( 
        clk         : IN STD_LOGIC;     -- Clk signal
        reset       : IN STD_LOGIC;     -- Reset signal
        sdi_spread  : IN STD_LOGIC;
        chip_0      : OUT STD_LOGIC;
        chip_1      : OUT STD_LOGIC;
        chip_2      : OUT STD_LOGIC
    );
end component;

for uut : DPLL use entity work.DPLL(Behavioral);

constant period     : time := 100 ns;
constant delay      : time :=  10 ns;
signal end_of_sim   : boolean := false;

SIGNAL clk         : STD_LOGIC;     -- Clk signal
SIGNAL reset       : STD_LOGIC;     -- Reset signal
SIGNAL sdi_spread  : STD_LOGIC;
SIGNAL chip_0      : STD_LOGIC;
SIGNAL chip_1      : STD_LOGIC;
SIGNAL chip_2      : STD_LOGIC;   

BEGIN

uut: DPLL
    PORT MAP(clk, reset, sdi_spread, chip_0, chip_1, chip_2);

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
    procedure tbvector(constant stimvect : in std_logic_vector(1 DOWNTO 0)) is
    begin
        reset <= stimvect(1);
        sdi_spread <= stimvect(0);
        wait for period;
    end tbvector;
    BEGIN
    
        -- Reset state (reset, ld, sh, data); expected -> data_pres = '0'
        tbvector("10");
        wait for period * 16;

        for i in 0 to 10 loop   
            tbvector("00");       
            wait for 16 * period;    
            tbvector("01");       
            wait for 16 * period;
      end loop ; 

      for i in 0 to 10 loop   
            tbvector("00");       
            wait for 13 * period;    
            tbvector("01");       
            wait for 13 * period;
      end loop ; 

      for i in 0 to 10 loop   
            tbvector("00");       
            wait for 18 * period;    
            tbvector("01");       
            wait for 18 * period;
      end loop ; 


        end_of_sim <= true;
        wait;
    END PROCESS;
END;


