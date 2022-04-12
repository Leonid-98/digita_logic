library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Nexysdemo is
    Port (
        mclk    : in std_logic;
        btn     : in std_logic_vector(3 downto 0);
        swt     : in std_logic_vector(7 downto 0);
        led     : out std_logic_vector(7 downto 0);
        an      : out std_logic_vector(3 downto 0);
        ssg     : out std_logic_vector(7 downto 0));
end Nexysdemo;

architecture Behavioral of Nexysdemo is
    signal clkdiv  : std_logic_vector(24 downto 0);
    signal cntr    : std_logic_vector(3 downto 0);
    signal cclk    : std_logic;
    signal dig     : std_logic_vector(6 downto 0);

begin

    led <= swt;

    dig <=
 "0111111" when cntr = "0000" else
 "0000110" when cntr = "0001" else
 "1011011" when cntr = "0010" else
 "1001111" when cntr = "0011" else
 "1100110" when cntr = "0100" else
 "1101101" when cntr = "0101" else
 "1111101" when cntr = "0110" else
 "0000111" when cntr = "0111" else
 "1111111" when cntr = "1000" else
 "1101111" when cntr = "1001" else
 "0000000";

    ssg(6 downto 0) <= not dig;

    an <= btn;

    -- Divide the master clock (100Mhz) down to a lower frequency.
    process (mclk)
    begin
        if mclk = '1' and mclk'Event then
            clkdiv <= clkdiv + 1;
        end if;
    end process;

    cclk <= clkdiv(24);

    process (cclk)
    variable inc : std_logic := '0';
    variable dot : std_logic := '0';
    begin
        if cclk = '1' and cclk'Event then
            if dot = '0' then
                dot := '1';
            else
                dot := '0';
            end if;
            ssg(7) <= dot;
            
            if inc = '0' then
                cntr <= cntr + 1;
                if cntr = "1000" then
                    inc := '1';
                end if;
                
            else
                cntr <= cntr - 1;
                if cntr = "0001" then
                    inc := '0';
                end if;
                
            end if;
        end if;
    end process;
    


end Behavioral;
