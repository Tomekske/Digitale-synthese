-- JORDY DE HOON
-- MODULE : TB_EDGEDETECT
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity EDGEDETECT_tb is
end EDGEDETECT_tb;

architecture structural of EDGEDETECT_tb is 

-- Component Declaration
component EDGEDETECT
port ( 
    sig     :   IN STD_LOGIC;   -- Input signal
    clk     :   IN STD_LOGIC;   -- Clock signal
    reset   :   IN STD_LOGIC;   -- Active high reset
    edge    :   OUT STD_LOGIC   -- Edge detection signal
);
end component;

for uut : EDGEDETECT use entity work.EDGEDETECT(Behavioral);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk		: std_logic;
signal reset	: std_logic;
signal sig		: std_logic;
signal edge 	: std_logic;

BEGIN

	uut: EDGEDETECT PORT MAP(
      clk => clk,
      sig => sig,
      reset => reset,
      edge => edge);

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
      reset <= stimvect(1);
      sig <= stimvect(0);

       wait for period;
   end tbvector;
   BEGIN
       
      tbvector("00");       -- Do nothing
      wait for 4*period;

      tbvector("10");       -- Reset module
      wait for 4*period;

      tbvector("00");       -- Do nothing
      wait for 4*period;
    
      wait for period/2;    -- Offset of half a period
      tbvector("01");       -- SIG signal active
      wait for 4*period;

      tbvector("00");       -- Do nothing
      wait for 4*period;

      tbvector("11");       -- Reset and Sig High
      wait for 4*period;

      tbvector("00");       -- Do nothing
      wait for 4*period;
                        
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;


