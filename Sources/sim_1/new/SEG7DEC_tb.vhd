-- Tomek Joostens
-- MODULE : 7 segment decoder tb

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity SEG7DEC_tb is
end SEG7DEC_tb;

architecture structural of SEG7DEC_tb is 

-- Component Declaration
component SEG7DEC
    Port( 
        data_in  : in STD_LOGIC_VECTOR (3 downto 0);    -- input data
        g_to_a   : out STD_LOGIC_VECTOR (6 downto 0);   -- 7 segment output: [0-9][A-F]
        dp       : out STD_LOGIC                        -- dot pointer
    ); 
end component;

for uut : SEG7DEC use entity work.SEG7DEC(Behavioral);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal data_in  : STD_LOGIC_VECTOR (3 downto 0);
signal g_to_a   : STD_LOGIC_VECTOR (6 downto 0);
signal dp       : STD_LOGIC;

BEGIN

    uut: SEG7DEC PORT MAP(
        data_in => data_in,
        g_to_a => g_to_a,
        dp => dp);

    
    tb : PROCESS
        procedure stimvect(constant stimvect : in std_logic_vector(3 downto 0))is
        begin

            data_in <= stimvect;
        end stimvect;

        BEGIN
            stimvect("0000");   -- 0
            wait for period * 4;
            
            stimvect("0001");   -- 1
            wait for period * 4;
            
            stimvect("0010");   -- 2
            wait for period * 4;
            
            stimvect("0011");   -- 3
            wait for period * 4;
            
            stimvect("0100");   -- 4
            wait for period * 4;
            
            stimvect("0101");   -- 5
            wait for period * 4;
            
            stimvect("0110");   -- 6
            wait for period * 4;
            
            stimvect("0110");   -- 6
            wait for period * 4;
            
            stimvect("0111");   -- 7
            wait for period * 4;
            
            stimvect("1000");   -- 8
            wait for period * 4;
            
            stimvect("1001");   -- 9
            wait for period * 4;
            
            stimvect("1010");   -- A
            wait for period * 4;
            
            stimvect("1011");   -- b
            wait for period * 4;
            
            stimvect("1100");   -- C
            wait for period * 4;
    
            stimvect("1101");   -- d
            wait for period * 4;
            
            stimvect("1110");   -- E
            wait for period * 4;
            
            stimvect("1111");   -- F
            wait for period * 4;
            

            end_of_sim <= true;
            wait;
        END PROCESS;
END;
        
        
