library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Moore is
    Port (Takt, Sisend, Resett, Sisend2: in STD_LOGIC;
         V2ljund, V2ljund2 : out STD_LOGIC);
end Moore;
architecture Moore_arhit of Moore is
    TYPE Staatus IS (A, B, C);
    SIGNAL s : Staatus;
    
    TYPE Staatus2 IS (X, Y);
    SIGNAL z : Staatus2;
    
begin

    Moore:process(Resett, Takt)
    begin
        if Resett = '0' Then s <= A;
        ElsIf (rising_edge(Takt)) Then
            Case s IS
                When A =>
                    If Sisend = '0'
 THEN s <= A;
                    Else s <= B;
                    End If;
                When B =>
                    If Sisend = '0'
 THEN s <= A;
                    Else s <= C;
                    End If;
                When C =>
                    If Sisend = '0'
 THEN s <= A;
                    Else s <= C;
                    End If;
            End Case;
        End If;
    End process Moore;

    V2ljund <= '1' When s = C Else '0';

    Mealy:process(Resett, Takt)
    begin
        If Resett = '0' Then
            z <= X;
        ElsIf (rising_edge(Takt)) Then
            Case z IS
                When X =>
                    If Sisend2 = '0'
                        Then z <= X;
                    Else z <= Y;
                    End If;
                When Y =>
                    If Sisend2 = '0'
                        Then z <= X;
                    Else z <= Y;
                    End If;
            End Case;
        End If;
    End Process Mealy;
    
    Mealy2:process(z, Sisend2)
    Begin
        Case z IS
            When X =>
                V2ljund2 <= '0';
            When Y =>
                V2ljund2 <= Sisend2;
        End Case;
    End Process Mealy2;

end Moore_arhit;

          
          
          
          
----------------------------------- sim
          ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2022 11:25:45 AM
-- Design Name: 
-- Module Name: sim - Behavioral
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
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2022 11:25:45 AM
-- Design Name: 
-- Module Name: sim - Behavioral
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
----------------------------------------------------------------------------------


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

