-- JORDY DE HOON & TOMEK JOOSTENS
-- MODULE : EDGEDETECT_STATE
-- INFO : Using a state machine to track the state of sig and generate a puls on the rising edge
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
end comoponent;

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

SIGNAL SHIFTREF_LD          : STD_LOGIC;
SIGNAL SHIFTREF_SH          : STD_LOGIC;

begin
-- Port mapping

-- DATAREGISTER
DATAREGISTER: DATAREGISTER 
    generic map(DATA_WIDTH + 7)
    port map(
        clk => clk, 
        reset => reset, 
        SHIFTREG_LD => ld, 
        SHIFTREG_SH => sh, 
        "0111110" => data(DATA_WIDTH + 6 DOWNTO DATA_WIDTH),
        data => data(DATA_WIDTH - 1 DOWNTO 0),
        sdo_out => sdo
        );

-- SEQUENCECONTROLLER
SEQUENCECONTROLLER: SEQUENCECONTROLLER 
    generic map(DATA_WIDTH + 7)
    port map(
        clk => clk,
        reset => reset,
        pn_start => nextstate,
        SHIFTREG_SH => sh_reg,
        SHIFTREG_LD => ld_reg 
    );

-- 7SEGMENT
SEG7: SEG7DEC port map(COUNTER_out, seg7_out);

-- Signal linking

end Behavioral;
