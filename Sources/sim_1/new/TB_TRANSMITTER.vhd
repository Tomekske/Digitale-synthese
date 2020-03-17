-- JORDY DE HOON & TOMEK JOOSTENS
-- MODULE : TB_TRANSMITTER
library ieee;
use ieee.STD_LOGIC_1164.all;

entity TRANSMITTER_tb is
    end TRANSMITTER_tb;

architecture structural of TRANSMITTER_tb is

component TRANSMITTER
    port ( 
        clk         :   IN STD_LOGIC;   -- Clock signal
        reset       :   IN STD_LOGIC;   -- Active high reset
        btn_up      :   IN STD_LOGIC;
        btn_down    :   IN STD_LOGIC;
        mode        :   IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        seg7_out    :   OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        sdo_spread  :   OUT STD_LOGIC
    );
    end component;
    
for uut : TRANSMITTER use entity work.TRANSMITTER(Behavioral);

CONSTANT period : time := 100 ns;
CONSTANT delay  : time :=  10 ns;
SIGNAL end_of_sim : boolean := false;

SIGNAL clk         :    STD_LOGIC;   -- Clock signal
SIGNAL reset       :    STD_LOGIC;   -- Active high reset
SIGNAL btn_up      :    STD_LOGIC;
SIGNAL btn_down    :    STD_LOGIC;
SIGNAL mode        :    STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL seg7_out    :    STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL sdo_spread  :    STD_LOGIC;

BEGIN

    uut: TRANSMITTER
    PORT MAP(clk, reset, btn_up, btn_down, mode, seg7_out, sdo_spread);

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
    procedure tbvector(CONSTANT stimvect : IN STD_LOGIC_vector(4 DOWNTO 0))is
    begin
        reset <= stimvect(4);
        btn_up <= stimvect(3);
        btn_down <= stimvect(2);
        mode <= stimvect(1 DOWNTO 0);
    end tbvector;
    BEGIN
        -- Test async reset
        tbvector("10000");   -- Reset active
        wait for period * 4;

        tbvector("00000");   -- Reset low
        wait for period * 4;

        for i in 0 to 8 loop
            tbvector("01000");   -- btn_up active
            wait for period*10;  
            tbvector("00000");
            wait for period*100;
        end loop ; 

        for i in 0 to 8 loop
            tbvector("00100");   -- btn_down active
            wait for period*10;  
            tbvector("00000");
            wait for period*100;
        end loop ; 

        for i in 0 to 8 loop
            tbvector("01001");   -- btn_up active
            wait for period*10;  
            tbvector("00001");
            wait for period*100;
        end loop ; -- identifier 

        for i in 0 to 8 loop
            tbvector("00101");   -- btn_down active
            wait for period*10;  
            tbvector("00001");
            wait for period*100;
        end loop ; -- identifier 

        --end of sim
        end_of_sim <= true;
        wait;
    END PROCESS;

    END;


