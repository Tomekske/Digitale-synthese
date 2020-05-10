---------------------------------------------------------------------
-- DEV		: JORDY DE HOON & TOMEK JOOSTENS
-- ACADEMIC : KULEUVEN 2019-2020 CAMPUS DE NAYER
-- MODULE	: TB_RECEIVER
-- INFO		:  
---------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RECEIEVER_tb is
end RECEIEVER_tb;

architecture structural of RECEIEVER_tb is 

component RECEIVER is
    port(
        clk         : IN STD_LOGIC;
        reset       : IN STD_LOGIC;
        sdi_spread  : IN STD_LOGIC;
        pn_mode     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        seg7        : OUT STD_LOGIC_VECTOR(6 downto 0)    
    );
end component;

for uut : RECEIVER use entity work.RECEIVER(Behavioral);
constant tb_data_0  : STD_LOGIC_VECTOR(10 DOWNTO 0) := "01111101000";
constant tb_data_1  : STD_LOGIC_VECTOR(10 DOWNTO 0) := "01111101001";

constant period     : time := 100 ns;
constant delay      : time :=  10 ns;
signal end_of_sim   : boolean := false;

SIGNAL clk         : STD_LOGIC;
SIGNAL reset       : STD_LOGIC;
SIGNAL sdi_spread  : STD_LOGIC;
SIGNAL pn_mode     : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL seg7        : STD_LOGIC_VECTOR(6 downto 0);

BEGIN
    uut: RECEIVER
        port map(clk, reset, sdi_spread, pn_mode, seg7);
    
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
    variable  ml_1_ptrn: std_logic_vector(30 DOWNTO 0):="0100001010111011000111110011010";
    variable  ml_2_ptrn: std_logic_vector(30 DOWNTO 0):="1110000110101001000101111101100";
    variable  gold_code_ptrn: std_logic_vector(30 DOWNTO 0):= ml_1_ptrn xor ml_2_ptrn;
    BEGIN
            -- Initial State
            reset <= '0';
            sdi_spread <= '0';
            pn_mode <= "00";
            wait for period;
            -- Reset sequence
            reset <= '1';
            wait for 10*period;
            reset <= '0';
            wait for 5*period;

            pn_mode <= "00";
            for i in 10 DOWNTO 0 loop
                for j in 30 DOWNTO 0 loop
                    sdi_spread <= '0';
                    wait for 16*period;
                end loop;
            end loop;

            for k in 0 to 10 loop
            -- NO PN CODE
                pn_mode <= "00";
                for i in 10 DOWNTO 0 loop
                    for j in 30 DOWNTO 0 loop
                        sdi_spread <= tb_data_0(i);
                        wait for 16*period;
                    end loop;
                end loop;
            end loop;

            for k in 0 to 10 loop
                -- NO PN CODE
                pn_mode <= "00";
                for i in 10 DOWNTO 0 loop
                    for j in 30 DOWNTO 0 loop
                        sdi_spread <= tb_data_1(i);
                        wait for 16*period;
                    end loop;
                end loop;
            end loop;

            for k in 0 to 5 loop
                -- PN CODE 1
                pn_mode <= "01";
                for i in 10 DOWNTO 0 loop
                    for j in 30 DOWNTO 0 loop
                        sdi_spread <= tb_data_0(i) XOR ml_1_ptrn(j);
                        wait for 16*period;
                    end loop;
                end loop;
                for i in 10 DOWNTO 0 loop
                    for j in 30 DOWNTO 0 loop
                        sdi_spread <= tb_data_1(i) XOR ml_1_ptrn(j);
                        wait for 16*period;
                    end loop;
                end loop;
            end loop;

            for k in 0 to 5 loop
                -- PN CODE 2
                pn_mode <= "10";
                for i in 10 DOWNTO 0 loop
                    for j in 30 DOWNTO 0 loop
                        sdi_spread <= tb_data_0(i) XOR ml_2_ptrn(j);
                        wait for 16*period;
                    end loop;
                end loop;
                for i in 10 DOWNTO 0 loop
                    for j in 30 DOWNTO 0 loop
                        sdi_spread <= tb_data_1(i) XOR ml_2_ptrn(j);
                        wait for 16*period;
                    end loop;
                end loop;
            end loop;

            for k in 0 to 5 loop
                -- PN CODE 3
                pn_mode <= "11";
                for i in 10 DOWNTO 0 loop
                    for j in 30 DOWNTO 0 loop
                        sdi_spread <= tb_data_0(i) XOR gold_code_ptrn(j);
                        wait for 16*period;
                    end loop;
                end loop;
                for i in 10 DOWNTO 0 loop
                    for j in 30 DOWNTO 0 loop
                        sdi_spread <= tb_data_1(i) XOR gold_code_ptrn(j);
                        wait for 16*period;
                    end loop;
                end loop;
            end loop;

            -- DATA IN PNCODE 2 BUT SYSTEM IN PNCODE 1
            for k in 0 to 5 loop
                pn_mode <= "01";
                for i in 10 DOWNTO 0 loop
                    for j in 30 DOWNTO 0 loop
                        sdi_spread <= tb_data_0(i) XOR ml_2_ptrn(j);
                        wait for 16*period;
                    end loop;
                end loop;
            end loop;


            wait for 10*period;
    end_of_sim <= true;
    wait;
    END PROCESS;
END;