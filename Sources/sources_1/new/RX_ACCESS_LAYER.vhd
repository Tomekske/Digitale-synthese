---------------------------------------------------------------------
-- DEV		: JORDY DE HOON
-- ACADEMIC : KULEUVEN 2019-2020 CAMPUS DE NAYER
-- MODULE	: ACCESS_LAYER_RX
-- INFO		: ACCESS LAYER FILE OF RECEIVER
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ACCES_LAYER_RX is
    port(
        clk         : IN STD_LOGIC;
        reset       : IN STD_LOGIC;
        sdi_spread  : IN STD_LOGIC;
        pn_mode     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        databit     : OUT STD_LOGIC;
        bitsample   : OUT STD_LOGIC
    );
end ACCES_LAYER_RX;

architecture Behavioral OF ACCES_LAYER_RX IS
-- SIGNALS HERE
SIGNAL DPLL_chip0       : STD_LOGIC;
SIGNAL DPLL_chip1       : STD_LOGIC;
SIGNAL DPLL_chip2       : STD_LOGIC;
SIGNAL DPLL_extb        : STD_LOGIC;
SIGNAL MATCH_seqdet     : STD_LOGIC;
SIGNAL PNGEN_clear      : STD_LOGIC;
SIGNAL PNGEN_pnstart    : STD_LOGIC;
SIGNAL PNGEN_fullseq    : STD_LOGIC;
SIGNAL PNGEN_sig0       : STD_LOGIC;
SIGNAL PNGEN_sig1       : STD_LOGIC;
SIGNAL PNGEN_sig2       : STD_LOGIC;
SIGNAL PN_seq           : STD_LOGIC;
SIGNAL sdi_despread     : STD_LOGIC;
-- COMPONENTS HERE
-- DPLL VERSION 2
component DPLL2 is
    port ( 
            clk         : IN STD_LOGIC;     -- Clk signal
            reset       : IN STD_LOGIC;     -- Reset signal
            sdi_spread  : IN STD_LOGIC;
            extb        : OUT STD_LOGIC;
            chip_0      : OUT STD_LOGIC;
            chip_1      : OUT STD_LOGIC;
            chip_2      : OUT STD_LOGIC
    );
end component;
-- MATHCED FILTER
component MATCHED_FILTER is
    Port ( 
        clk             : IN STD_LOGIC;
        reset           : IN STD_LOGIC;     -- Reset signal
        chip_sample     : IN STD_LOGIC;     -- Synchronisatie bit reset counter naar default waarde
        sdi_spread      : IN STD_LOGIC;
        dipswitches     : IN STD_LOGIC_VECTOR(1 downto 0); -- De dipswitches
        seq_det         : OUT STD_LOGIC -- Dit is de databit die naar buiten wordt gestuurd
    );
end component;
-- PNGENERATOR WITH FLOWCONTROL
component PNGENERATOR_CONTROL is
    port ( 
        clk         :   IN  STD_LOGIC;      -- Clock signal
        reset       :   IN  STD_LOGIC;      -- Active high reset
        shift       :   IN  STD_LOGIC;      -- Shift signal
        clear       :   IN  STD_LOGIC;      -- Clear or sync reset the component
        pn_start    :   OUT STD_LOGIC;      -- Edge detection signal
        full_seq    :   OUT STD_LOGIC;
        pn_sig0     :   OUT STD_LOGIC;      -- first pn code signal
        pn_sig1     :   OUT STD_LOGIC;      -- second pn code signal
        pn_sig2     :   OUT STD_LOGIC       -- third pn code signal
    );
end component;
-- CORRELATOR
component CORRELATOR is
    Port ( 
        clk             : IN STD_LOGIC;
        reset           : IN STD_LOGIC;     -- Reset signal
        chip_sample     : IN STD_LOGIC;     -- Synchronisatie bit reset counter naar default waarde
        sdi_despread    : IN STD_LOGIC;
        bit_sample      : IN STD_LOGIC; 
        databit         : OUT STD_LOGIC     -- Dit is de databit die naar buiten wordt gestuurd
    );
end component;
-- DESPREADING
component DESPREADING is
    port( 
            signal_0    : IN STD_LOGIC;
            signal_1    : IN STD_LOGIC;
            signal_out  : OUT STD_LOGIC
    );
end component;

begin
-- PORT MAPPING
-- DPLL
DPLL: DPLL2
    port map(clk,reset,sdi_spread,DPLL_extb,DPLL_chip0,DPLL_chip1,DPLL_chip2);

MATCHF: MATCHED_FILTER
    port map(clk,reset,DPLL_chip0,sdi_spread,pn_mode,MATCH_seqdet);

PNGENC: PNGENERATOR_CONTROL
    port map(clk,reset,DPLL_chip1,PNGEN_clear,PNGEN_pnstart,PNGEN_fullseq,PNGEN_sig0,PNGEN_sig1,PNGEN_sig2);

DESP: DESPREADING
    port map(sdi_spread,PN_seq,sdi_despread);

CORR: CORRELATOR
    port map(clk,reset,sdi_despread,PNGEN_fullseq,bitsample);

-- 2MUX1 WITH OR PORT ON pn_mode SIGNAL
process(pn_mode,MATCH_seqdet,DPLL_extb)begin
    if((pn_mode(0) = '1') OR (pn_mode(1) = '1')then
        PNGEN_clear <= MATCH_seqdet; -- PN CODE SELECTED
    else
        PNGEN_clear <= DPLL_extb;    -- NO PN CODE
    end if;
end process;

-- 4MUX1
process(pn_mode,PNGEN_sig0,PNGEN_sig1,PNGEN_sig2)begin
    case(pn_mode) is
        when "01"   => PN_seq <= PNGEN_sig0; -- PN CODE 0
        when "10"   => PN_seq <= PNGEN_sig1; -- PN CODE 1
        when "11"   => PN_seq <= PNGEN_sig2; -- PN CODE 2 (GOLD)
        when others => PN_seq <= '0';   -- NO PN CODE
    end case ;
end process;

    end Behavioral;
