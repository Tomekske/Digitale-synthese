library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity TB_DATAREGISTER is
end TB_DATAREGISTER;

architecture structural of TB_DATAREGISTER is 
constant SHIFT_WIDTH : integer := 8;
-- Component Declaration
component DATAREGISTER
generic(SHIFT_WIDTH : integer);
	port (
        clk     : IN STD_LOGIC;
        reset   : IN STD_LOGIC;                                     -- Reset signal
        ld      : IN STD_LOGIC;                                     -- load from the sequence controller
        sh      : IN STD_LOGIC;                                     -- shift data from the sequence controller
        data    : IN STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 downto 0);    -- variable input data
        sdo     : OUT STD_LOGIC                                     -- serial data out
    );
end component;

for uut : DATAREGISTER use entity work.DATAREGISTER(Behavioral);

constant period     :   time := 100 ns;
constant delay      :   time :=  10 ns;
signal end_of_sim   :   boolean := false;

signal clk     : STD_LOGIC;
signal reset   : STD_LOGIC;                                     -- Reset signal
signal ld      : STD_LOGIC;                                     -- load from the sequence controller
signal sh      : STD_LOGIC;                                     -- shift data from the sequence controller
signal data    : STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 downto 0);    -- variable input data
signal sdo     : STD_LOGIC;     

BEGIN

uut: DATAREGISTER
    generic map(SHIFT_WIDTH => SHIFT_WIDTH)
    PORT MAP(clk, reset, ld, sh, data, sdo);

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
    procedure tbvector(constant stimvect : in std_logic_vector((10) downto 0)) is
    begin
        reset <= stimvect(10);
        ld <= stimvect(9);
        sh <= stimvect(8);
        data <= stimvect(7 downto 0);
        wait for period;
    end tbvector;
    BEGIN
    
        -- Reset state (reset, ld, sh, data); expected -> data_pres = '0'
        tbvector("10011001101");
        wait for period * 2;
        
        -- ld = 1; expected sdo = '1'
        tbvector("01011001101");
        wait for period * 2;
        
        -- sh = 1;expected sdo = '1'
        tbvector("00111001101");
        wait for period * 2;
        
        -- sh = 1;expected sdo = '0'
        tbvector("00110110010");
        wait for period * 2;
        
        end_of_sim <= true;
        wait;
    END PROCESS;
END;


