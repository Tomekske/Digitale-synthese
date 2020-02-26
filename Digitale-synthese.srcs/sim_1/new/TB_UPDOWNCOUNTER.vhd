-- JORDY DE HOON
-- MODULE : TB_UPDOWNCOUNTER
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity UPDOWNCOUNTER_tb is
end UPDOWNCOUNTER_tb;

architecture structural of UPDOWNCOUNTER_tb is 

-- Component Declaration
component UPDOWNCOUNTER
port ( 
    up      :   IN STD_LOGIC;   -- count up signal
    down    :   IN STD_LOGIC;   -- count down signal
    clk     :   IN STD_LOGIC;   -- Clock signal
    reset   :   IN STD_LOGIC;   -- Active high reset
    count   :   OUT STD_LOGIC_VECTOR(3 DOWNTO 0)   -- Edge detection signal
);
end component;

for uut : UPDOWNCOUNTER use entity work.UPDOWNCOUNTER(Behavioral);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk		: std_logic;
signal reset	: std_logic;
signal up		: std_logic;
signal down		: std_logic;
signal count 	: std_logic_vector(3 downto 0);

BEGIN

	uut: UPDOWNCOUNTER PORT MAP(
      clk => clk,
      up => up,
      down => down,
      reset => reset,
      count => count);

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
      reset <= stimvect(2);
      up   <= stimvect(1);
      down <= stimvect(0);

       wait for period;
   end tbvector;
   BEGIN
       
      tbvector("000");       -- Do nothing
      wait for 4*period;

      tbvector("100");       -- Reset module
      wait for 4*period;

      tbvector("000");       -- Do nothing
      wait for 4*period;
    
      wait for period/2;    -- Offset of half a period
      tbvector("010");       -- up signal active
      wait for 4*period;

      tbvector("001");       -- down signal active
      wait for 4*period;

      tbvector("111");       -- All inputs high
      wait for 4*period;

      tbvector("000");       -- Do nothing
      wait for 4*period;
                        
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;


