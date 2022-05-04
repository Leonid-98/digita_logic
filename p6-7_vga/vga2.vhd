library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- https://forum.digikey.com/t/vga-controller-vhdl/12794
-- http://www.ece.ualberta.ca/~elliott/ee552/studentAppNotes/1998_w/Altera_UP1_Board_Map/vga.html
-- https://digilent.com/reference/_media/basys3:basys3_rm.pdf

entity vga is
    Port (
        clk: in std_logic;
        RED_IN, GRN_IN, BLU_IN : in std_logic_vector(3 downto 0);
        RED, GRN, BLU : out std_logic_vector(3 downto 0);
        HSYNC: out std_logic;
        VSYNC: out std_logic
    );
end vga;

architecture Behavioral of vga is
    signal clk_div: std_logic_vector(1 downto 0) := "00";
    signal clk_25: std_logic;  -- slow clock 25 signal

    constant width: integer := 640;
    constant height: integer := 480;
    constant v_pulse_width: integer := 2;
    constant v_front_porch: integer := 10;
    constant v_back_porch: integer := 29;
    constant h_pulse_width: integer := 96;
    constant h_front_porch: integer := 16;
    constant h_back_porch: integer := 48;
    constant display_x: integer := width + h_front_porch + h_pulse_width + h_back_porch;
    constant display_y: integer := height + v_front_porch + v_pulse_width + v_back_porch;

    signal pixel_x: integer := 0;
    signal pixel_y: integer := 0;

    -- BRAM constants
    constant img_width: integer := 256;
    constant img_height: integer := 256;
    constant img_size: integer := img_height * img_width;

    signal clka : STD_LOGIC;
    signal wea : STD_LOGIC_VECTOR(0 DOWNTO 0):= "0";
    signal addra : STD_LOGIC_VECTOR(15 DOWNTO 0):=(others=>'0');
    signal dina : STD_LOGIC_VECTOR(11 DOWNTO 0):=(others=>'0');
    signal douta : STD_LOGIC_VECTOR(11 DOWNTO 0):=(others=>'0');

    component vga_memory PORT(
            clka : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
        );
    end component;

begin
    port_map_vga : vga_memory PORT MAP(
            clka => clka,
            wea => wea,
            addra => addra,
            dina => dina,
            douta => douta
        );

    clk_25MHz: process (clk)
    begin
        if clk = '1' and clk'Event then
            clk_div <= clk_div + 1;
        end if;
        clk_25 <= clk_div(1);
        clka <= clk_25;
    end process clk_25MHz;

    pixel_move: process (clk_25)
    begin
        if rising_edge(clk_25) then
            if pixel_x = (display_x - 1) then
                pixel_x <= 0;
                if pixel_y = (display_y - 1) then
                    pixel_y <= 0;
                else
                    pixel_y <= pixel_y + 1;
                end if;
            else
                pixel_x <= pixel_x + 1;
            end if;
        end if;
    end process pixel_move;   

    h_sync: process (clk_25)
    begin
        if rising_edge(clk_25) then
            if (pixel_x >= (width + h_front_porch - 1) and (pixel_x < (display_x - h_back_porch - 1))) then
                HSYNC <= '0';
            else
                HSYNC <= '1';

            end if;
        end if;
    end process h_sync;

    v_sync: process (clk_25)
    begin
        if rising_edge(clk_25) then
            if (pixel_y >= (height + v_front_porch - 1) and (pixel_y < (display_y - v_back_porch - 1))) then
                VSYNC <= '0';
            else
                VSYNC <= '1';
            end if;
        end if;
    end process v_sync;

    show_color: process (clk_25)
    begin
        if rising_edge(clk_25) then
            if pixel_x < img_width and pixel_y < img_height then
                BLU <= douta(11 downto 8);
                GRN <= douta(7 downto 4);
                RED <= douta(3 downto 0);
                addra <= addra + "1";
            elsif pixel_x < width and pixel_y < height then
                RED <= RED_IN;
                GRN <= GRN_IN;
                BLU <= BLU_IN;
            else
                RED <= "0000";
                GRN <= "0000";
                BLU <= "0000";
            end if;

        end if;
    end process show_color;

end Behavioral;
