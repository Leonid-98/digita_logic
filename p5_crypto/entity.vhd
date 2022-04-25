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
    
    signal data_and_parity: std_logic_vector(7 downto 0);
    signal signal_crypt: std_logic_vector(7 downto 0);
    signal signal_decrypt: std_logic_vector(7 downto 0);
    
begin
    
    slow_clk: process (cclk)
    begin
        if clk = '1' and clk'Event then
            clkdiv <= clkdiv + 1;
        end if;
    end process slow_clk;
    cclk <= clkdiv(24);
    
    main: process(clk)
    begin   
        -- add parity bit
        data_and_parity(7) <= data_in(0);
        data_and_parity(6 downto 0) <= data_in;
        
        --xnor
        data_and_parity <= data_and_parity xnor key;
        
        -- ROR and ROL
        ror_loop: for i in 1 to ror_val loop
            data_and_parity <= data_and_parity(0) & data_and_parity(7 downto 1);
        end loop ror_loop;
        
        rol_loop: for i in 1 to rol_val loop
            data_and_parity <= data_and_parity(7 downto 1) & data_and_parity(0);
        end loop rol_loop;
        
        -- V"ALJUND
        signal_crypt <= data_and_parity;
        
        -- TAGASI ROR AND ROL
        rol_loop_back: for i in 1 to rol_val loop
            data_and_parity <= data_and_parity(0) & data_and_parity(7 downto 1);
        end loop rol_loop_back;
        
        ror_loop_back: for i in 1 to ror_val loop
            data_and_parity <= data_and_parity(7 downto 1) & data_and_parity(0);
        end loop ror_loop_back;
        
        -- TAGASI XNOR
        data_and_parity <= data_and_parity xnor key;
        
        -- V"ALJUND
        signal_decrypt <= data_and_parity;
    end process main;
    
    data_out_crypt <= signal_crypt;
    data_out_decryp <= signal_decrypt;
    
end Behavioral;
