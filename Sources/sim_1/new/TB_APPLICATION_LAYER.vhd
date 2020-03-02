-- JORDY DE HOON & TOMEK JOOSTENS
-- MODULE : TB_APPLICATION_LAYER
library ieee;
use ieee.std_logic_1164.all;

entity APPLICATION_LAYER_tb is
    end APPLICATION_LAYER_tb;

architecture structural of APPLICATION_LAYER_tb is
constant COUNT_WIDTH : integer := 4;

component APPLICATION_LAYER
    generic(COUNT_WIDTH : integer);
    port ( 
        clk         :   IN STD_LOGIC;   -- Clock signal
        reset       :   IN STD_LOGIC;   -- Active high reset
        btn_up      :   IN STD_LOGIC;   -- Edge detection signal
        btn_down    :   IN STD_LOGIC;   -- Edge detection signal
        data_out    :   OUT STD_LOGIC_VECTOR(COUNT_WIDTH-1 downto 0);
        seg7_out    :   OUT STD_LOGIC_VECTOR(6 downto 0)
    );
    end component;


for uut : APPLICATION_LAYER use entity work.APPLICATION_LAYER(Behavioral);

constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk          : std_logic;
signal reset        : std_logic;
signal btn_up       : std_logic;
signal btn_down     : std_logic;
signal data_out     : STD_LOGIC_VECTOR(COUNT_WIDTH-1 downto 0);
signal seg7_out     : STD_LOGIC_VECTOR(6 downto 0);

BEGIN

    uut: APPLICATION_LAYER 
    generic map(COUNT_WIDTH => COUNT_WIDTH)
    PORT MAP(clk,reset,btn_up,btn_down,data_out,seg7_out);

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
        reset       <= stimvect(2);
        btn_up      <= stimvect(1);
        btn_down    <= stimvect(0);
       -- wait for period;
    end tbvector;
    BEGIN
        
        tbvector("000");       -- Do nothing
        wait for 4*period;

        tbvector("100");       -- Reset module
        wait for 4*period;

        tbvector("000");       -- Do nothing
        wait for 4*period;

        for i in 0 to 10 loop   -- 10x btn_up
            tbvector("010");       -- btn_up active
            wait for 20*period;    -- sim human press lengt
            tbvector("000");       -- Do nothing
            wait for 20*period;
          end loop ; -- identifier

        for i in 0 to 10 loop   -- 10x btn_down
            tbvector("001");       -- btn_down active
            wait for 20*period;
            tbvector("000");       -- Do nothing
            wait for 20*period;
          end loop ; -- identifier
          
          for i in 0 to 10 loop   -- 10x btn_down
            tbvector("001");       -- btn_down active
            wait for 3*period;     -- Noise sim
            tbvector("000");       -- Do nothing
            wait for 5*period;
          end loop ; -- identifier

        tbvector("000");       -- Do nothing
        wait for 4*period;
                        
        end_of_sim <= true;
        wait;
    END PROCESS;

    END;


