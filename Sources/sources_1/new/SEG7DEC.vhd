-- Tomek Joostens
-- MODULE : 7 segment decoder
-- INFO : 7 segment decodor outputting numbers between 0-9 and chars between A-F

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SEG7DEC is
    Port( 
        data_in  : in STD_LOGIC_VECTOR (3 downto 0); -- input data
        g_to_a   : out STD_LOGIC_VECTOR (6 downto 0); -- 7 segment output: [0-9][A-F]
        dp       : out STD_LOGIC -- dot pointer
    ); 
end SEG7DEC;

architecture Behavioral of SEG7DEC is

begin
    process(data_in)
    begin
        case data_in is
            when "0000" => g_to_a <= "1000000"; --0
            when "0001" => g_to_a <= "1111001"; --1
            when "0010" => g_to_a <= "0100100"; --2
            when "0011" => g_to_a <= "0110000"; --3
            when "0100" => g_to_a <= "0011001"; --4
            when "0101" => g_to_a <= "0010010"; --5
            when "0110" => g_to_a <= "0000010"; --6
            when "0111" => g_to_a <= "1011000"; --7
            when "1000" => g_to_a <= "0000000"; --8
            when "1001" => g_to_a <= "0010000"; --9
            when "1010" => g_to_a <= "0001000"; --A
            when "1011" => g_to_a <= "0000011"; --b
            when "1100" => g_to_a <= "1000110"; --C
            when "1101" => g_to_a <= "0100001"; --d
            when "1110" => g_to_a <= "0000110"; --E
            when others => g_to_a <= "0001110"; --F
        end case;
    end process;    
end Behavioral;
