-- JORDY DE HOON & TOMEK JOOSTENS
-- MODULE : TRANSMITTER

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity TRANSMITTER is
    port ( 
        clk         :   IN STD_LOGIC;   -- Clock signal
        reset       :   IN STD_LOGIC;   -- Active high reset
        btn_up      :   IN STD_LOGIC;
        btn_down    :   IN STD_LOGIC;
        mode        :   IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        seg7_out    :   OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        sdo_spread  :   OUT STD_LOGIC
    );
    end TRANSMITTER;

architecture Behavioral OF TRANSMITTER IS
CONSTANT DATA_WIDTH : integer := 4; 
SIGNAL data     : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
SIGNAL pn_start : STD_LOGIC;
SIGNAL sdo      : STD_LOGIC;

-- APPLICATION LAYER
component APPLICATION_LAYER is
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

-- DATALINK LAYER
component DATALINK_LAYER is
    generic(DATA_WIDTH : integer);
    port ( 
        clk         :   IN STD_LOGIC;   -- Clock signal
        reset       :   IN STD_LOGIC;   -- Active high reset
        pn_start    :   IN STD_LOGIC;
        data        :   IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
        sdo_out     :   OUT STD_LOGIC
    );
end component;

-- ACCES_LAYER
component ACCES_LAYER is
    port ( 
        clk         :   IN STD_LOGIC;   -- Clock signal
        reset       :   IN STD_LOGIC;   -- Active high reset
        sdo         :   IN STD_LOGIC;
        mode        :   IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        pn_start    :   OUT STD_LOGIC;
        sdo_spread  :   OUT STD_LOGIC
    );
end component;

begin
APL: APPLICATION_LAYER
    generic map(DATA_WIDTH)
    port map(clk,reset,btn_up,btn_down,data,seg7_out);
DLL: DATALINK_LAYER
    generic map(DATA_WIDTH)
    port map(clk,reset,pn_start,data,sdo);
ACL: ACCES_LAYER
    port map(clk,reset,sdo,mode,pn_start,sdo_spread);

end Behavioral;
