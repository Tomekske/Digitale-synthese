-- JORDY DE HOON
-- MODULE : DPLL
-- INFO : 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity DPLL is
    generic(COUNT_WIDTH : integer);
    port ( 
            clk         : IN STD_LOGIC;     -- Clk signal
            reset       : IN STD_LOGIC;     -- Reset signal
            sdi_spread  : IN STD_LOGIC;
            chip_0      : OUT STD_LOGIC;
            chip_1      : OUT STD_LOGIC;
            chip_2      : OUT STD_LOGIC
    );
end DPLL;

architecture Behavioral OF DPLL IS
-- INTERNAL LINKING SIGNALS
    SIGNAL extb         : STD_LOGIC;
    SIGNAL seg_mode     : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL sema         : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL chip_0_signal  : STD_LOGIC;
    SIGNAL chip_1_signal  : STD_LOGIC;
    SIGNAL chip_2_signal  : STD_LOGIC;
-- INTERNAL SIGNALS MODULES
    -- TRANSITION DETECT SIGNALS
    SIGNAL sdi_sampled  : STD_LOGIC;
    SIGNAL td_dff       : STD_LOGIC;
    -- TRANSITION SEGMENT DECODER SIGNALS
    SIGNAL tsd_counter          : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL tsd_counter_next     : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL seg_mode_next        : STD_LOGIC_VECTOR(4 DOWNTO 0);
    -- SEGMENT SEMAPHORE SIGNALS
    SIGNAL sema_next    : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL sema_mode    : STD_LOGIC;
    -- NCO SIGNALS
    SIGNAL nco_counter      : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL nco_counter_next : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL nco_counter_rl   : STD_LOGIC_VECTOR(4 DOWNTO 0);
    
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- TRANSITION DETECTION [TD]
process(reset,clk) begin
    if(reset = '1')then
        td_dff <= '0';
        sdi_sampled <= '0';
    else
        if(rising_edge(clk)) then
            sdi_sampled <= sdi_spread;
            td_dff <= sdi_sampled;
        end if;
    end if;
end process;
process(td_dff,sdi_sampled) begin
    extb <= td_dff XOR sdi_sampled;
end process;
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- TRANSITION SEGMENT DECODER [TSD]
process(reset,clk,extb) begin
    if(reset = '1') then
        tsd_counter <= (OTHERS => '0');
        seg_mode <= (OTHERS => '0');
    else
        if(rising_edge(clk))then
            tsd_counter <= tsd_counter_next;
            seg_mode <= seg_mode_next;
        end if;
    end if;

end process;

process(tsd_counter,tsd_counter_next) begin
    -- COUNTER with overflow to zero and external reset
    if(extb = '1') then
        tsd_counter_next <= (OTHERS => '0');
    else
        tsd_counter_next <= tsd_counter + 1;
    end if;

    -- OUTPUT DECODER
    if(tsd_counter_next >= 11) then
        seg_mode_next <= "10000"
    elsif(tsd_counter_next >= 9)then
        seg_mode_next <= "01000"
    elsif(tsd_counter_next >= 7)then
        seg_mode_next <= "00100"
    elsif(tsd_counter_next >= 5)then
        seg_mode_next <= "00010"
    else
        seg_mode_next <= "00001"
    end if;
end process;

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- SEGMENT SEMAPHORE [SS]
process(clk,reset) begin
    if(reset = '1') then
        sema <= "00100";
    else
        if(rising_edge(clk))then
            if(chip_0_signal = '1')then
                sema <= sema_next;
                sema_mode <= '0';
            end if;
            if(extb = '1') then
                sema_mode <= '1';
            end if;
        end if;
    end if;
end process;

process(sema_mode) begin
    if(sema_mode = '1')then
        sema_next <= seg_mode;
    else
        sema_next <= "00100";
    end if;
end process;

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- NCO [NCO]
process(reset,clk) begin
    if(reset = '1') then
        nco_counter <= (OTHERS => '0');
    else
        if(rising_edge(clk)) then
            nco_counter <= nco_counter_next;
        end if;
    end if;
end process;

process(reset,nco_counter) begin
    --Reload counter controller
    if(reset = '1')then
        chip_0_signal <= '0';
        nco_counter_next <= nco_counter_rl;
    elsif(nco_counter = 0) then
        nco_counter_next <= nco_counter_rl;
        chip_0_signal <= '1';
    else
        nco_counter_next <= nco_counter - 1;
        chip_0_signal <= '0';
    end if;
    --Sema Reload value decoder
    case(sema) is
        when "00001" =>     -- A
            nco_counter_rl <= 8 + 3;
        when "00010" =>     -- B
            nco_counter_rl <= 8 + 1;
        when "00100" =>     -- C
            nco_counter_rl <= 8;
        when "01000" =>     -- D
            nco_counter_rl <= 8 - 1;
        when "10000" =>     -- E
            nco_counter_rl <= 8 - 3;
        when others =>      -- OTHERS
            nco_counter_rl <= 8;
    end case ;
end process;

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- SIGNAL LINKING + DELAY
chip_0 <= chip_0_signal;
chip_1 <= chip_1_signal;
chip_2 <= chip_2_signal;

process(reset,clk)begin
    if(reset = '1')then
        chip_1_signal <= '0';
        chip_2_signal <= '0';
    else
        if(rising_edge(clk))then
            chip_1_signal <= chip_0_signal;
            chip_2_signal <= chip_1_signal;
        end if;
    end if;
end process;

end Behavioral;