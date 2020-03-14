-- JORDY DE HOON
-- MODULE : TB_SEQUENCECONTROLLER
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity SEQUENCECONTROLLER_tb is
end SEQUENCECONTROLLER_tb;

architecture structural of SEQUENCECONTROLLER_tb is 
constant COUNT_WIDTH : integer := 11;
-- Component Declaration
component SEQUENCECONTROLLER
generic(COUNT_WIDTH : integer);
    port ( 
            clk         : IN STD_LOGIC;     -- Clk signal
            reset       : IN STD_LOGIC;     -- Reset signal
            nextstate   : IN STD_LOGIC;     -- Input signal to next state
            sh_reg      : OUT STD_LOGIC;    -- Shift signal for registers (output)
            ld_reg      : OUT STD_LOGIC     -- Load signal for registers (output)
    );
end component;

for uut : SEQUENCECONTROLLER use entity work.SEQUENCECONTROLLER(Behavioral);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk		    : std_logic;
signal reset        : std_logic;
signal nextstate    : std_logic;
signal sh_reg    	: std_logic;
signal ld_reg    	: std_logic;

BEGIN

    uut: SEQUENCECONTROLLER
    generic map(COUNT_WIDTH => COUNT_WIDTH)
    PORT MAP(
      clk => clk,
      reset => reset,
      nextstate => nextstate,
      sh_reg => sh_reg,
      ld_reg => ld_reg
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
   procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
     begin
      reset     <= stimvect(1);
      nextstate <= stimvect(0);
   end tbvector;
   BEGIN
       
      tbvector("00");       -- Do nothing
      wait for 4*period;

      tbvector("10");       -- Reset module
      wait for 4*period;

      tbvector("00");       -- Do nothing
      wait for 4*period;

      for i in 0 to 20 loop
        tbvector("01");       -- Do nothing
        wait for period;
        tbvector("00");       -- Do nothing
        wait for 4*period;
      end loop ; -- identifier

      tbvector("00");       -- Do nothing
      wait for 4*period;
                        
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;


