library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity DEBOUNCER_tb is
end DEBOUNCER_tb;

architecture structural of DEBOUNCER_tb is 

-- Component Declaration
component DEBOUNCER
port (
    cha     :   IN STD_LOGIC;
    clk     :   IN STD_LOGIC;
    reset   :   IN STD_LOGIC;	-- Active high signal
    syncha  :   OUT STD_LOGIC
);
end component;

for uut : DEBOUNCER use entity work.DEBOUNCER(Behavioral);

constant period     :   time := 100 ns;
constant delay      :   time :=  10 ns;
signal end_of_sim   :   boolean := false;

signal clk      : std_logic;
signal reset    : std_logic;
signal cha      : std_logic;
signal syncha   : std_logic;

BEGIN

uut: DEBOUNCER PORT MAP(
    clk => clk,
    cha => cha,
    reset => reset,
    syncha => syncha
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
    procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0)) is
    begin
        reset <= stimvect(1);
        cha <= stimvect(0);
        wait for period;
    end tbvector;
    BEGIN
    
        -- doet niets
        tbvector("00");
        wait for period * 4;
        
        tbvector("01");
        wait for period * 6;   
        
        tbvector("10");
        wait for period * 6;
        
        -- reset
        tbvector("10");
        wait for period * 4;
        
        tbvector("11");
        wait for period * 4;
        
        -- doe niets
        tbvector("00");
        wait for period * 4;
        
        tbvector("01");
        wait for period * 10;
        
        end_of_sim <= true;
        wait;
    END PROCESS;
END;


