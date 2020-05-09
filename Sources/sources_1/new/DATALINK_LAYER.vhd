-- JORDY DE HOON & TOMEK JOOSTENS
-- MODULE : DATALINK LAYER

library ieee;
use ieee.std_logic_1164.all;
entity DATALINK_LAYER is
    generic(DATA_WIDTH : integer);
    port ( 
        clk         :   IN STD_LOGIC;   -- Clock signal
        reset       :   IN STD_LOGIC;   -- Active high reset
        pn_start    :   IN STD_LOGIC;
        data        :   IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
        sdo_out     :   OUT STD_LOGIC
    );
    end DATALINK_LAYER;

architecture Behavioral OF DATALINK_LAYER IS

component DATAREGISTER is
    generic(SHIFT_WIDTH : integer);
	port (
        clk     : IN STD_LOGIC;
        reset   : IN STD_LOGIC;                                     -- Reset signal
        ld      : IN STD_LOGIC;                                     -- load from the sequence controller
        sh      : IN STD_LOGIC;                                     -- shift data from the sequence controller
        data    : IN STD_LOGIC_VECTOR(SHIFT_WIDTH - 1 downto 0);    -- variavle input data
        sdo     : OUT STD_LOGIC                                     -- serial data out
    );
end component;

component SEQUENCECONTROLLER is
    generic(COUNT_WIDTH : integer);
    port ( 
        clk         : IN STD_LOGIC;     -- Clk signal
        reset       : IN STD_LOGIC;     -- Reset signal
        nextstate   : IN STD_LOGIC;     -- Input signal to next state
        sh_reg      : OUT STD_LOGIC;    -- Shift signal for registers (output)
        ld_reg      : OUT STD_LOGIC     -- Load signal for registers (output)
    );
end component;

SIGNAL SHIFTREG_LD  : STD_LOGIC;
SIGNAL SHIFTREG_SH  : STD_LOGIC;

begin
-- Port mapping
-- DATAREGISTER
DATAREG: DATAREGISTER 
    generic map(DATA_WIDTH + 7) -- Data_width size + 7 bit preamble
    port map(
        clk => clk, 
        reset => reset, 
        ld => SHIFTREG_LD, 
        sh => SHIFTREG_SH, 
        data(DATA_WIDTH + 6 DOWNTO DATA_WIDTH) => "0111110",    -- Hard coded preamble pattern
        data(DATA_WIDTH - 1 DOWNTO 0) => data,
        sdo => sdo_out
    );

-- SEQUENCECONTROLLER
SEQUENCE: SEQUENCECONTROLLER 
    generic map(DATA_WIDTH + 7)
    port map(
        clk => clk,
        reset => reset,
        nextstate => pn_start,
        sh_reg => SHIFTREG_SH,
        ld_reg => SHIFTREG_LD  
    );

-- Signal linking

end Behavioral;
