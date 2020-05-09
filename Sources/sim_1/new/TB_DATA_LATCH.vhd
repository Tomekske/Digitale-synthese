---------------------------------------------------------------------
-- DEV		: Tomek Joostens
-- ACADEMIC : KULEUVEN 2019-2020 CAMPUS DE NAYER
-- MODULE	: DATA_LATCH_tb
-- INFO		: Test of data_out correct is
---------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DATA_LATCH_tb is
end DATA_LATCH_tb;

architecture structural of DATA_LATCH_tb is 

component DATA_LATCH is
    Port ( 
        clk         : IN STD_LOGIC;
        reset       : IN STD_LOGIC;     -- Reset signal
        bit_sample  : IN STD_LOGIC;
        preamble    : IN STD_LOGIC_VECTOR(6 downto 0);
        data_in     : IN STD_LOGIC_VECTOR(3 downto 0);
        data_out    : OUT STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

for uut : DATA_LATCH use entity work.DATA_LATCH(Behavioral);

constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk : STD_LOGIC;
signal reset : STD_LOGIC;
signal bit_sample : STD_LOGIC;
signal preamble : STD_LOGIC_VECTOR(6 downto 0);
signal data_in : STD_LOGIC_VECTOR(3 downto 0);
signal data_out : STD_LOGIC_VECTOR(3 downto 0);

begin
uut: DATA_LATCH PORT MAP(
      clk => clk,
      reset => reset,
      bit_sample => bit_sample,
      preamble => preamble,
      data_in => data_in,
      data_out => data_out
    );
    
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
    variable   preamble_ptrn	: std_logic_vector(6 downto 0) := "0111110";
    variable   preamble_fail_ptrn	: std_logic_vector(6 downto 0) := "0101010";
    
    procedure tbvector(constant stimvect : in std_logic_vector(5 downto 0))is
    begin
        reset <= stimvect(5);
        bit_sample <= stimvect(4);
        data_in <= stimvect(3 DOWNTO 0);      
        wait for period;
    end tbvector;
    BEGIN
         -- Niets doen
        preamble <= (others => '0');
        tbvector("100000");   
        wait for 3*period;
        
        -- data_in = 1001, bit_sample = 0 => output = 0
        preamble <= preamble_fail_ptrn;
        tbvector("001001");  
        wait for 3*period;
        
        -- data_in = 1001, bit_sample = 0 => output = 0
        preamble <= preamble_fail_ptrn;
        tbvector("011001");  
        wait for 3*period;
        
        -- Controleert of de latch werkt en zijn waarde '0000' behouden wordt
        preamble <= preamble_ptrn;
        tbvector("001001");  
        wait for 3*period;
        
        -- Stuurt de waarde '1001' naar buiten
        preamble <= preamble_ptrn;
        tbvector("011001");  
        wait for 3*period;
        
        -- Controleert of de latch werkt en zijn waarde '1001' behouden wordt
        preamble <= preamble_ptrn;
        tbvector("001010");  
        wait for 3*period;
        
        -- Stuurt de waarde '1010' naar buiten
        preamble <= preamble_ptrn;
        tbvector("011010");  
        wait for 3*period;        
        end_of_sim <= true;
        wait;
    END PROCESS;
END;