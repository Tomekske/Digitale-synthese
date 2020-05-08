-- JORDY DE HOON
-- MODULE : DPLL 2.0
-- INFO : Less hw needed for DPLL integration

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity DPLL2 is
    port ( 
            clk         : IN STD_LOGIC;     -- Clk signal
            reset       : IN STD_LOGIC;     -- Reset signal
            sdi_spread  : IN STD_LOGIC;
            chip_0      : OUT STD_LOGIC;
            chip_1      : OUT STD_LOGIC;
            chip_2      : OUT STD_LOGIC
    );
end DPLL2;

architecture Behavioral OF DPLL2 IS
-- SIGNALS
SIGNAL td_extb          : STD_LOGIC;
SIGNAL td_sdi_delay     : STD_LOGIC;
SIGNAL tsd_counter      : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL tsd_counter_next : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL tsd_segmode      : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL ss_semacode      : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL ss_semacode_prev : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL ss_semamode      : STD_LOGIC;
SIGNAL nco_counter      : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL nco_counter_next : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL nco_counter_rl   : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL nco_zero         : STD_LOGIC;
SIGNAL od_chip0         : STD_LOGIC;
SIGNAL od_chip1         : STD_LOGIC;
SIGNAL od_chip2         : STD_LOGIC;

begin
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- TRANSITION DETECTION [TD]
-- D-FLIPFLOP for rising and falling edge detection (transistion detection)
process(reset, clk)begin    -- SYNC D-FLIPFLOP
    if(reset = '1')then     -- ASYNC RESET
        td_extb <= '0';
    else
        if(rising_edge(clk))then    -- When clk 
            if((sdi_spread XOR td_sdi_delay) = '1')then -- If input is diff from delayed signal
                td_extb <= '1'; -- Transistion detected
            else
                td_extb <= '0'; -- No transistion
            end if;
            td_sdi_delay <= sdi_spread; -- D-FLIPFLOP for input signal
        end if;
    end if;
end process;
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- TRANSITION SEGMENT DECODER [TSD]
-- COUNTER from 0 to 15 decimal + position decoder
process(reset,clk)begin
    if(reset = '1')then     -- RESET COUNTER
        tsd_counter <= (OTHERS => '0');
    else
        if(rising_edge(clk))then
            if((sdi_spread XOR td_sdi_delay) = '1')then
                -- SYNC EDGE DETECT : REACTS FASTER
                tsd_counter <= (OTHERS => '0');
            else
                -- ELSE load next state
                tsd_counter <= tsd_counter_next;
            end if;
        end if;
    end if;
end process;

process(td_extb, tsd_counter, tsd_counter_next,sdi_spread,td_sdi_delay)begin
    -- NEXT STATE DECODER
    tsd_counter_next <= tsd_counter + 1;
    -- DECODER component
    if(tsd_counter >= 11) then
        tsd_segmode <= "10000";
    elsif(tsd_counter >= 9)then
        tsd_segmode <= "01000";
    elsif(tsd_counter >= 7)then
        tsd_segmode <= "00100";
    elsif(tsd_counter >= 5)then
        tsd_segmode <= "00010";
    else
        tsd_segmode <= "00001";
    end if;
end process;

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- SEGMENT SEMAPHORE [SS]
-- sema_mode is a SRFF to SET or RESET the "mode" of the MUX
-- This mode indicates if we need to still tweak the signal or just use the older state
process(reset, clk)begin
    if(reset = '1')then             -- ASYNC RESET
        ss_semamode <= '0';
        ss_semacode_prev <= (OTHERS => '0');
    else
        if(rising_edge(clk))then
            if(td_extb = '1')then    -- SRFF
                ss_semamode <= '1';  -- SET SIGNAL
            elsif(nco_zero = '1')then
                ss_semamode <= '0';  -- RESET SIGNAL
            end if;
            ss_semacode_prev <= ss_semacode;    -- DFF OF THE SEMACODE
        end if;
    end if;
end process;

process(ss_semamode, tsd_segmode)begin
    if(ss_semamode = '1')then       -- 2MUX1
        ss_semacode <= tsd_segmode; 
    else
        ss_semacode <= ss_semacode_prev; -- DELAYED OUTPUT TO INPUT (DFF)
    end if;
end process;

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- NCO [NCO]
-- DOWN COUNTER WITH EXTERNAL RELOAD CONTROL
process(reset, clk)begin
    if(reset = '1')then
        nco_counter <= STD_LOGIC_VECTOR(TO_UNSIGNED(8,6));  -- Reset the counter to value 8.
        nco_zero <= '0';    -- Force output to zero
    else
        if(rising_edge(clk))then
            nco_counter <= nco_counter_next;        -- Load next state of counter
            if(nco_counter_next = 0)then  -- if next state of the counter is zero activate output signal to indicate zero
                nco_zero <= '1';
            else 
                nco_zero <= '0';    -- else not zero disable output (output to zero)
            end if;
        end if;
    end if;
end process;

process(ss_semacode,ss_semacode_prev, nco_counter, nco_counter_rl)begin

    if(nco_counter = 0)then
        nco_counter_next <= nco_counter_rl;     -- When counter is zero reload the counter
    else
        nco_counter_next <= nco_counter - 1;    -- Else next state is one less
    end if;
    -- sema decoder for reload values.
    case(ss_semacode) is    -- TWEAK ONE EXTRA BIT FOR REACTION DELAY COMPENSATION
        when "00001" =>     -- A
            nco_counter_rl <=  STD_LOGIC_VECTOR(TO_UNSIGNED(15 + 4 ,6));
        when "00010" =>     -- B
            nco_counter_rl <= STD_LOGIC_VECTOR(TO_UNSIGNED(15 + 2 ,6));
        when "00100" =>     -- C
            nco_counter_rl <= STD_LOGIC_VECTOR(TO_UNSIGNED(15 ,6));
        when "01000" =>     -- D
            nco_counter_rl <= STD_LOGIC_VECTOR(TO_UNSIGNED(15 - 2 ,6));
        when "10000" =>     -- E
            nco_counter_rl <= STD_LOGIC_VECTOR(TO_UNSIGNED(15 - 4 ,6));
        when others =>      -- OTHERS
            nco_counter_rl <= STD_LOGIC_VECTOR(TO_UNSIGNED(15 ,6));
    end case;
end process;
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- OUTPUT DECODER [OD]
-- GENERATE CHIP SIGNALS WITH 2 DFF FOR DELAYED SIGNALS
process(reset, clk)begin
    if(reset = '1')then
        od_chip1 <= '0';    -- DFF1 RESET
        od_chip2 <= '0';    -- DFF2 RESET
    else
        if(rising_edge(clk))then
            od_chip1 <= od_chip0;   --Load new value in DFF1
            od_chip2 <= od_chip1;   --Load new value in DFF2
        end if;
    end if;
end process;

od_chip0 <= nco_zero;   -- Link nco_zero to od_chip0
chip_0 <= od_chip0;     -- link od_chip0 to chip0
chip_1 <= od_chip1;     -- ""
chip_2 <= od_chip2;     -- ""

end Behavioral;