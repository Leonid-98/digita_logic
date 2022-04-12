library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram_example is
    port (clk : in std_logic;
         clk_led : out std_logic;  --led15

         address_bin : in std_logic_vector(1 downto 0); --sw10, 11
         we_bin : in std_logic_vector(1 downto 0);  --sw14, 15

         data_i : in std_logic_vector(7 downto 0); --sw0-7
         data_o : out std_logic_vector(7 downto 0) --led0-7
        );
end ram_example;

architecture Behavioral of ram_example is
    type ram_t is array (0 to 3) of std_logic_vector(7 downto 0);
    signal ram : ram_t := (others => (others => '0'));

    attribute ram_style: string;
    attribute ram_style of ram : signal is "distributed";

    signal clkdiv  : std_logic_vector(24 downto 0);
    signal cclk    : std_logic;
    signal address   : integer;


begin
    -- Divide the master clock (100Mhz) down to a lower frequency.
    process (clk)
    begin
        if clk = '1' and clk'Event then
            clkdiv <= clkdiv + 1;
        end if;
    end process;
    cclk <= clkdiv(24);
    clk_led <= cclk;


    read_write: process(cclk)
    begin
        address <= to_integer(unsigned(address_bin)); --var?

        if(rising_edge(cclk)) then
            if(we_bin="01") then
                ram(address) <= data_i;
                data_o <= "00000000";

            elsif (we_bin="10") then
                data_o <= ram(address);

            else
                data_o <= "00000000";
            end if;
        end if;
    end process read_write;

end Behavioral;