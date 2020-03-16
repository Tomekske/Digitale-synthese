-- JORDY DE HOON & TOMEK JOOSTENS
-- MODULE : TB_APPLICATION_LAYER
library ieee;
use ieee.std_logic_1164.all;

entity DATALINK_LAYER_tb is
    end DATALINK_LAYER_tb;

architecture structural of DATALINK_LAYER_tb is
constant DATA_WIDTH : integer := 4;

component DATALINK_LAYER
    generic(DATA_WIDTH : integer);
    port ( 
        clk         :   IN STD_LOGIC;   -- Clock signal
        reset       :   IN STD_LOGIC;   -- Active high reset
        pn_start    :   IN STD_LOGIC;   -- Acces layer: PN generator
        data        :   IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); -- Application layer: up-down counter output data
        sdo_out     :   OUT STD_LOGIC   -- SDO output
    );
    end component;
    
for uut : DATALINK_LAYER use entity work.DATALINK_LAYER(Behavioral);

constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk      : std_logic;
signal reset    : std_logic;
signal pn_start : std_logic;
signal data     : std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
signal sdo_out  : std_logic;

BEGIN

    uut: DATALINK_LAYER_tb 
    generic map(DATA_WIDTH => DATA_WIDTH)
    PORT MAP(clk, reset, pn_start, data, sdo_out);

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
    procedure tbvector(constant stimvect : in std_logic_vector(5 downto 0))is
    begin
        reset <= stimvect(5);
        pn_start <= stimvect(4);
        data <= stimvect(3 downto 0);
        -- wait for period;
    end tbvector;
    BEGIN
        -- Test async reset
        tbvector("100000");
        wait for 4*period;
        
        tbvector("000000");
        wait for 4*period;

        for i in 0 to 10 loop   -- 10x btn_down
            tbvector("010101");
            wait for period;
            tbvector("000101");
            wait for 4*period;
        end loop;

        tbvector("000000");
        wait for 4*period;

        end_of_sim <= true;
        wait;
    END PROCESS;

    END;


