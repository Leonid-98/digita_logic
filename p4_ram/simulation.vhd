----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2022 11:21:02 AM
-- Design Name: 
-- Module Name: ram_example - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--  --------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram_sim is
end ram_sim;

architecture Behavioral of ram_sim is
    component ram_example
        port (clk : in std_logic;
             clk_led : out std_logic;  --led15

             address_bin : in std_logic_vector(1 downto 0); --sw10, 11
             we_bin : in std_logic_vector(1 downto 0);  --sw14, 15

             data_i : in std_logic_vector(7 downto 0); --sw0-7
             data_o : out std_logic_vector(7 downto 0) --led0-7
            );
    end component;

    signal clk: std_logic := '0';
    constant clk_period : time := 10ns;
    signal r_data: std_logic := '0';
    signal w_data: std_logic := '0';
    signal address : std_logic_vector(1 downto 0) := "00";
    signal data_in : std_logic_vector(7 downto 0) := "00000000";
    signal data_out : std_logic_vector(7 downto 0) := "00000000";
    signal StopClock : boolean := false;
begin

    UUT: ram_example port map (we_bin(0) => r_data, we_bin(1) => w_data, address_bin => address, clk => clk, data_i => data_in, data_o => data_out);

    clock: process
    begin
        if not StopClock then
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end if;
    end process clock;

    rw_data: process
    begin
        if not StopClock then
            wait for 21ns;
            w_data <= '1';
            wait for 40ns;
            w_data <= '0';
            r_data <= '1';
            wait for 80 ns;
        end if; 
    end process rw_data;
    
    adress_change: process
    begin
        if not StopClock then
           wait for 31ns;
           
           address <= "01";
           wait for 10ns;
           
           address <= "10";
           wait for 10ns;
           
           address <= "11";
           wait for 20ns;
           
           address <= "00";
           wait for 10ns;
           
           address <= "01";
           wait for 10ns;
           
           address <= "10";
           wait for 10ns;
           
           address <= "11";
           wait for 30ns;
           
        end if; 
    end process adress_change;
    
    data_in_proc: process
    begin
        if not StopClock then
            wait for 11ns;
            
            data_in <= x"11";  
            wait for 10ns;
            
            data_in <= x"55";  
            wait for 10ns;
            
            data_in <= x"aa";  
            wait for 10ns;
            
            data_in <= x"0f";  
            wait for 10ns;
            
            data_in <= x"f0";  
            wait for 30ns;
            
            data_in <= x"aa";  
            wait for 50ns;
            
            
        end if;
    
    end process data_in_proc;
    
    stop_count: process
    begin
        wait for 140ns;
        StopClock <= true;
    end process stop_count;

end Behavioral;
