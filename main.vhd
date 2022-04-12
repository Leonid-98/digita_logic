library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity praks2_2_entity is
    Port ( f : in STD_LOGIC_VECTOR (7 downto 0);
         clk : in STD_LOGIC;
         z : out STD_LOGIC_VECTOR (15 downto 0));
end praks2_2_entity;

architecture Behavioral of praks2_2_entity is

begin
    process(clk)
    begin
        if rising_edge(clk) then
            case f is
                when "00000001" => --SW0
                    z <= std_logic_vector(to_unsigned(2018, z'length));
                when "00000010" => --SW1
                    z <= std_logic_vector(to_unsigned(65535, z'length));
                when "00000100" => --SW2
                    z <= std_logic_vector(to_unsigned(43690, z'length));
                when "00001000" => --SW3
                    z <= std_logic_vector(to_unsigned(21845, z'length));
                when "00010000" => --SW4
                    z <= std_logic_vector(to_unsigned(1632, z'length));
                when "01100000" => --SW5 and SW6
                    z <= std_logic_vector(to_unsigned(61680, z'length));
                when "00100000" | "10000000" | "10100000"=> --SW5 or SW7
                    z <= std_logic_vector(to_unsigned(3855, z'length));
                when others =>
                    z <= std_logic_vector(to_unsigned(65535, z'length));
            end case;
        end if;
    end process;



end Behavioral;
