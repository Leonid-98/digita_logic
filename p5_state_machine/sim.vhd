library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim is
--  Port ( );
end sim;

architecture Behavioral of sim is
    component Moore
        Port (Takt, Sisend, Resett, Sisend2: in STD_LOGIC;
         V2ljund, V2ljund2 : out STD_LOGIC); --mealy v2ljund2, moore v2ljund
    end component;
    
    signal Takt, Sisend, Resett, Sisend2, V2ljund, V2ljund2: STD_LOGIC;
    constant clk_period : time := 10ns;
begin

UUT: Moore port map (Takt => Takt, Sisend => Sisend, Sisend2 => Sisend2, Resett => Resett, V2ljund => V2ljund, V2ljund2 => V2ljund2);


clock: process
    begin
        Takt <= '0';
        wait for clk_period/2;
        Takt <= '1';
        wait for clk_period/2;
    end process clock;
    
main: process
    begin
       Resett <= '0';
       Sisend <= '1';
       Sisend2 <= '1'; 
       wait for 10ns;
       Resett <= '1';
       wait for 10ns;
       
       Sisend <= '1';
       Sisend2 <= '1'; 
       wait for 10ns;
       wait for 10ns;
       
       Sisend <= '0';
       Sisend2 <= '0'; 
       wait for 10ns;
       wait for 10ns;
       
       Sisend <= '0';
       Sisend2 <= '0'; 
       wait for 10ns;
       wait for 10ns;
               
    end process main;

end Behavioral;