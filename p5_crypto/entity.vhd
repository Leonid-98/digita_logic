library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity crypto is
    port (clk : in std_logic;

         data_in : in std_logic_vector(6 downto 0); 
         key : in std_logic_vector(7 downto 0);
         
         data_out_crypt: out std_logic_vector(7 downto 0); --7th - paarsus bitt
         data_out_decryp: out std_logic_vector(7 downto 0)
        );
end crypto;
    
     
architecture Behavioral of crypto is
    signal clkdiv  : std_logic_vector(24 downto 0);
    signal cclk    : std_logic;
    
    signal data_and_parity: std_logic_vector(7 downto 0);
    
begin
    
    slow_clk: process (clk)
    begin
        if clk = '1' and clk'Event then
            clkdiv <= clkdiv + 1;
        end if;
    end process slow_clk;
    cclk <= clkdiv(24);
    
    parity_calculator: process(cclk)
    begin
        data_and_parity(7) <= data_in(0);
        data_and_parity(6 downto 0) <= data_in;
    end process parity_calculator;
    
    
    




end Behavioral;
