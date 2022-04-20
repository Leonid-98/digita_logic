library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity crypto is
    generic (
        ror_val: integer := 2;
        rol_val: integer := 1;
        key_len: integer := 8
    );
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
    
--    signal signal_crypt: std_logic_vector(7 downto 0);
--    signal signal_decrypt: std_logic_vector(7 downto 0);
begin
    
    slow_clk: process (clk)
    begin
        if clk = '1' and clk'Event then
            clkdiv <= clkdiv + 1;
        end if;
    end process slow_clk;
    cclk <= clkdiv(24);
    
    main: process(cclk)
    variable count : unsigned(6 downto 0) := "0000000";
    variable parity_val : std_logic_vector(6 downto 0);
    
    variable data_and_parity: std_logic_vector(7 downto 0);
    begin
        -- parity count
        count := "0000000";  
        for i in 0 to 6 loop   
            if(data_in(i) = '1') then
                count := count + 1;
            end if;
        end loop;
        
        parity_val := std_logic_vector(count);
        data_and_parity(7) := parity_val(0);
        data_and_parity(6 downto 0) := data_in;
        
        --xnor key
        data_and_parity := data_and_parity xnor key;
        
        -- shift right
        for  i in 1 to ror_val loop
            data_and_parity := data_and_parity(0) & data_and_parity(7 downto 1);
        end loop ;
        
        -- shift left
        for  i in 1 to rol_val loop
            data_and_parity := data_and_parity(6 downto 0) & data_and_parity(7);
        end loop ;
        
        ----------------------------------------------------------
        data_out_crypt <= data_and_parity;
        ----------------------------------------------------------
        
        
        -- DECRYPT
        -- shift right back
        for  i in 1 to rol_val loop
            data_and_parity := data_and_parity(0) & data_and_parity(7 downto 1);
        end loop ;
        
        -- shift left back
        for  i in 1 to ror_val loop
            data_and_parity := data_and_parity(6 downto 0) & data_and_parity(7);
        end loop;
        
        --xnor key
        data_and_parity := data_and_parity xnor key;
        

        ----------------------------------------------------------
        data_out_decryp <= data_and_parity;
        ----------------------------------------------------------
        
    end process main;
    
--    data_out_decryp <= signal_decrypt;
--    data_out_crypt <= signal_crypt;
    
end Behavioral;
