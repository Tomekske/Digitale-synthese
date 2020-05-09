-- JORDY DE HOON & TOMEK JOOSTENS
-- MODULE : ACCES_LAYER

library ieee;
use ieee.std_logic_1164.all;
entity ACCES_LAYER is
    port ( 
        clk         :   IN STD_LOGIC;   -- Clock signal
        reset       :   IN STD_LOGIC;   -- Active high reset
        sdo         :   IN STD_LOGIC;
        mode        :   IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        pn_start    :   OUT STD_LOGIC;
        sdo_spread  :   OUT STD_LOGIC
    );
    end ACCES_LAYER;

architecture Behavioral OF ACCES_LAYER IS
SIGNAL sdo_pn_0     : STD_LOGIC; -- code 0 (PN XOR SDO)
SIGNAL sdo_pn_1     : STD_LOGIC; -- code 1 (PN XOR SDO)
SIGNAL sdo_pn_2     : STD_LOGIC; -- code 2 (PN XOR SDO)

SIGNAL pn_0         : STD_LOGIC; -- code 0 (PN CODE)
SIGNAL pn_1         : STD_LOGIC; -- code 1 (PN CODE) 
SIGNAL pn_2         : STD_LOGIC; -- code 2 (PN CODE)
SIGNAL mux_out      : STD_LOGIC; -- output 4 MUX 1

-- PN Generator
component PNGENERATOR is
    port ( 
        clk         :   IN  STD_LOGIC;      -- Clock signal
        reset       :   IN  STD_LOGIC;      -- Active high reset
        pn_start    :   OUT STD_LOGIC;      -- Edge detection signal
        pn_sig0     :   OUT STD_LOGIC;      -- first pn code signal
        pn_sig1     :   OUT STD_LOGIC;      -- second pn code signal
        pn_sig2     :   OUT STD_LOGIC       -- third pn code signal
    );
end component;

begin
    -- Port mapping
-- SEQUENCECONTROLLER
PNGEN: PNGENERATOR 
    port map(clk, reset, pn_start, pn_0, pn_1, pn_2);
-- 4 MUX 1 and XOR ports
process(reset, sdo, mode, pn_0, pn_1, pn_2) begin
    if(reset='1')then
        mux_out <= '0';
    else
        case(mode) is
            when "00" => mux_out <= sdo;
            when "01" => mux_out <= sdo XOR pn_0;
            when "10" => mux_out <= sdo XOR pn_1;
            when "11" => mux_out <= sdo XOR pn_2;
            when others => mux_out <= sdo;
        end case ;
    end if;
end process;
-- Signal linking
sdo_spread <= mux_out;
end Behavioral;
