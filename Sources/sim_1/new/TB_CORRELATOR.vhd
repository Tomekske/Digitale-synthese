-- JORDY DE HOON
-- MODULE : TB_UPDOWNCOUNTER
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity CORRELATOR_tb is
end CORRELATOR_tb;

architecture structural of CORRELATOR_tb is 


-- Component Declaration
component CORRELATOR
port ( 
        clk             : IN STD_LOGIC;
        reset           : IN STD_LOGIC;     -- Reset signal
        chip_sample     : IN STD_LOGIC;     -- Synchronisatie bit reset counter naar default waarde
        sdi_despread    : IN STD_LOGIC;
        bit_sample      : IN STD_LOGIC; 
        databit         : OUT STD_LOGIC     -- Dit is de databit die naar buiten wordt gestuurd
);
end component;

for uut : CORRELATOR use entity work.CORRELATOR(Behavioral);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk          : std_logic;
signal reset        : std_logic;
signal chip_sample  : std_logic;
signal sdi_despread : std_logic;
signal bit_sample   : std_logic;
signal databit      : std_logic;

BEGIN

    uut: CORRELATOR 
    PORT MAP
    (
      clk => clk,
      reset => reset,
      chip_sample => chip_sample,
      sdi_despread => sdi_despread,
      bit_sample => bit_sample,
      databit => databit
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
procedure tbvector(constant stimvect : in std_logic_vector(3 downto 0))is
    begin
        reset <= stimvect(3);
        chip_sample <= stimvect(2);
        sdi_despread <= stimvect(1);
        bit_sample <= stimvect(0);
    
        wait for period;
    end tbvector;
    BEGIN
        tbvector("1010");       -- Do nothing
        wait for 5*period;
        
        -- Test: 1
        -- databit moet '1' zijn

        for i in 0 to 64 loop
            tbvector("0110"); 
            tbvector("0010"); 
        
        end loop;
         tbvector("0011");
         tbvector("0010");  
        wait for 4*period;
        
        for i in 0 to 64 loop
            tbvector("0100"); 
            tbvector("0000");   
        end loop;
         tbvector("0001");
         tbvector("0000");
         wait for 10*period;        
        -- Test: 2
        -- databit moet '1' zijn
--        for i in 0 to 7 loop
--            tbvector("0110"); 
--            wait for 4*period;  
--        end loop;
--        for i in 0 to 6 loop
--            tbvector("0100"); 
--            wait for 4*period;  
--        end loop;
--         tbvector("0111"); 
--        wait for 4*period;  
    end_of_sim <= true;
    wait;
    END PROCESS;
END;
    
    
