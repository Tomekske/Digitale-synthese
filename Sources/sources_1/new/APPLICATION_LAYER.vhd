-- JORDY DE HOON
-- MODULE : EDGEDETECT_STATE
-- INFO : Using a state machine to track the state of sig and generate a puls on the rising edge
library ieee;
use ieee.std_logic_1164.all;
entity APPLICATION_LAYER is
    generic(COUNT_WIDTH : integer);
    port ( 
        clk         :   IN STD_LOGIC;   -- Clock signal
        reset       :   IN STD_LOGIC;   -- Active high reset
        btn_up      :   IN STD_LOGIC;   -- Edge detection signal
        btn_down    :   IN STD_LOGIC;   -- Edge detection signal
        data_out    :   OUT STD_LOGIC_VECTOR(COUNT_WIDTH-1 downto 0);
        seg7_out    :   OUT STD_LOGIC_VECTOR(6 downto 0)
    );
    end APPLICATION_LAYER;

architecture Behavioral OF APPLICATION_LAYER IS

component EDGEDETECT_STATE is
    port ( 
        sig     :   IN STD_LOGIC;   -- Input signal
        clk     :   IN STD_LOGIC;   -- Clock signal
        reset   :   IN STD_LOGIC;   -- Active high reset
        edge    :   OUT STD_LOGIC   -- Edge detection signal
    );
end EDGEDETECT_STATE;

component UPDOWNCOUNTER is
    generic(COUNT_WIDTH : integer);
    port ( 
        up      :   IN STD_LOGIC;   -- count up signal
        down    :   IN STD_LOGIC;   -- count down signal
        clk     :   IN STD_LOGIC;   -- Clock signal
        reset   :   IN STD_LOGIC;   -- Active high reset
        count   :   OUT STD_LOGIC_VECTOR(COUNT_WIDTH-1 DOWNTO 0)   -- Edge detection signal
    );
end UPDOWNCOUNTER;

component SEG7DEC is
    Port( 
        data_in  : in STD_LOGIC_VECTOR (3 downto 0); -- input data
        g_to_a   : out STD_LOGIC_VECTOR (6 downto 0) -- 7 segment output: [0-9][A-F]
    ); 
end SEG7DEC;

SIGNAL EDGEDETECT_up_out    : STD_LOGIC; -- Output EDGEDETECT_up module
SIGNAL EDGEDETECT_down_out  : STD_LOGIC; -- Output EDGEDETECT_up module
SIGNAL COUNTER_out          : STD_LOGIC_VECTOR(COUNT_WIDTH-1 downto 0);
begin
-- Port mapping

-- Edge detect for input buttons
EDGEDETECT_up:   EDGEDETECT_STATE port map (btn_up, clk, reset, EDGEDETECT_up_out);
EDGEDETECT_down: EDGEDETECT_STATE port map (btn_down, clk, reset, EDGEDETECT_down_out);

-- Counter
COUNTER: UPDOWNCOUNTER 
    generic map(COUNT_WIDTH)
    port map(EDGEDETECT_up_out, EDGEDETECT_down_out, clk, reset, COUNTER_out);

-- 7SEGMENT
SEG7: SEG7DEC port map(COUNTER_out, seg7_out);

-- Signal linking
data_out <= COUNTER_out;

end Behavioral;
