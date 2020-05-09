library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MATCHED_FILTER_tb is
end MATCHED_FILTER_tb;

architecture structural of MATCHED_FILTER_tb is 

component MATCHED_FILTER
    Port ( 
        clk             : IN STD_LOGIC;
        reset           : IN STD_LOGIC;     -- Reset signal
        chip_sample     : IN STD_LOGIC;     -- Synchronisatie bit reset counter naar default waarde
        sdi_spread      : IN STD_LOGIC;
        dipswitches     : IN STD_LOGIC_VECTOR(1 downto 0); -- De dipswitches
        seq_det         : OUT STD_LOGIC -- Dit is de databit die naar buiten wordt gestuurd
    );
end component;

for uut : MATCHED_FILTER use entity work.MATCHED_FILTER(Behavioral);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk          : std_logic;
signal reset        : std_logic;
signal chip_sample  : std_logic;
signal sdi_spread   : std_logic;
signal dipswitches  : STD_LOGIC_VECTOR(1 downto 0);
signal seq_det      : std_logic;

BEGIN

    uut: MATCHED_FILTER 
    PORT MAP
    (
      clk => clk,
      reset => reset,
      chip_sample => chip_sample,
      sdi_spread => sdi_spread,
      dipswitches => dipswitches,
      seq_det => seq_det
    );
    
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
    
    procedure tbvector(constant stimvect : in std_logic_vector(3 downto 0))is
    begin
        reset <= stimvect(3);
        chip_sample <= stimvect(2);
        dipswitches <= stimvect(1 DOWNTO 0);
    
        wait for period;
    end tbvector;
    BEGIN
        -- Niets doen
        sdi_spread <= '0';
        tbvector("1000");   
        wait for 3*period;
        
        tbvector("0000");   
        wait for 3*period;

        -- No ptrn
        for i in 0 to 30 loop
            sdi_spread <= '1';
            tbvector("0100");
            tbvector("0000");
        end loop;
        
        -- No_ptrn inverse
        for i in 0 to 31 loop
            sdi_spread <= '0';
            tbvector("0100");
            tbvector("0000");
        end loop;

        -- ml_1_ptrn
        for i in 30 downto 0 loop            
            sdi_spread <= ml_1_ptrn(i);
            wait for period;
            tbvector("0101");
            tbvector("0001");
        end loop;
                        
        -- inverse ml_1_ptrn
        for i in 30 downto 0 loop
            sdi_spread <= not(ml_1_ptrn(i));
            wait for period;
            tbvector("0101");
            tbvector("0001");                
        end loop;              
            
        -- ml_2_ptrn
        for i in 30 downto 0 loop            
            sdi_spread <= ml_2_ptrn(i);
            wait for period;
            tbvector("0110");
            tbvector("0010");
        end loop;
                
        -- inverse ml_2_ptrn
        for i in 30 downto 0 loop
            sdi_spread <= not(ml_2_ptrn(i));
            wait for period;
            tbvector("0110");
            tbvector("0010");                
        end loop;              
               
        -- gold_code_ptrn
        for i in 30 downto 0 loop            
            sdi_spread <= gold_code_ptrn(i);
            wait for period;
            tbvector("0111");
            tbvector("0011");
        end loop;
                        
        -- inverse gold_code_ptrn
        for i in 30 downto 0 loop
            sdi_spread <= not(gold_code_ptrn(i));
            wait for period;
            tbvector("0111");
            tbvector("0011");                
        end loop;              
        
        tbvector("1000");   
        wait for 3*period;
        
        end_of_sim <= true;
        wait;
        END PROCESS;
        END;
