-- JORDY DE HOON
-- MODULE : EDGEDETECT_STATE
-- INFO : Using a state machine to track the state of sig and generate a puls on the rising edge
library ieee;
use ieee.std_logic_1164.all;
entity EDGEDETECT_STATE is
    port ( 
        sig     :   IN STD_LOGIC;   -- Input signal
        clk     :   IN STD_LOGIC;   -- Clock signal
        reset   :   IN STD_LOGIC;   -- Active high reset
        edge    :   OUT STD_LOGIC   -- Edge detection signal
    );
end EDGEDETECT_STATE;

architecture Behavioral OF EDGEDETECT_STATE IS
    SIGNAL edge_sig     : STD_LOGIC;
    SIGNAL state_cur    : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL state_next   : STD_LOGIC_VECTOR(1 DOWNTO 0);
begin
-- SYNC COMPONENT
process(clk,reset) begin
    if (reset = '1') then           -- Async Reset
        state_cur <= "00";
    else
        if(rising_edge(clk)) then   -- Memmory function
            state_cur <= state_next; 
        end if;
    end if ;
end process;
-- COMBINATORIAL COMPONENT
process(clk,state_cur,reset,sig) begin
    if (reset='1') then     -- Force output to 0
        edge_sig <= '0';
    else
        case( state_cur ) is        -- State machine to track sig
            when "00" =>            -- IDLE mode
                if(sig = '1')then       -- Rising edge on sig
                    state_next <= "01"; -- Prepare next state
                else                    -- Sig still low
                    state_next <= state_cur;   -- Stay in current state
                end if;
                edge_sig <= '0';        -- Output is low
            when "01" =>                -- Intermediate state
                if(sig = '1')then       -- Sig still high prepare next state
                    state_next <= "10";
                else                    -- Sig low, prepare IDLE state
                    state_next <= "00";
                end if;
                edge_sig <= '1';        -- Output high (1 clk time)
            when "10" =>                -- State for waiting until sig go low
                if(sig = '1')then       -- Stay in current state
                    state_next <= state_cur;
                else                    -- when sig is low go to IDLE state
                    state_next <= "00";
                end if;
                edge_sig <= '0';        -- Output low
            when others =>
                edge_sig <= '0';        -- If state is fault force output to 0 (safety)
        end case ;
    end if ;
end process;
-- SIGNAL CONNECTIONS
edge <= edge_sig;          -- Link to external connection
end Behavioral;