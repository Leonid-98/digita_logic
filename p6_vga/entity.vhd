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
        RED_IN, GRN_IN, BLU_IN in std_logic_vector(3 downto 0);
		
        RED, GRN, BLU out std_logic_vector(3 downto 0);
        HSYNC: out std_logic;
		VSYNC: out std_logic
    );
end vga;

architecture Behavioral of vga is

    constant width: integer := 640;         --pixels
    constant height: integer := 480;        --pixels
	
	-- 25MHz pixel clock and 60Hz vertical refresh
    constant v_pulse_width: integer := 1600; --clocks
	constant v_front_porch: integer := 8000; --clocks
	constant v_back_porch: integer := 23200; --clocks
	
	constant h_pulse_width: integer := 96; --clocks
	constant h_front_porch: integer := 16; --clocks
	constant h_back_porch: integer := 48; --clocks



    signal clk_div: std_logic_vector(2 downto 0) := "000";
    signal clk_25: std_logic;  -- slow clock 25 MHz
    
    signal pixel_x: integer := 0;
    signal pixel_y: integer := 0;

begin

    clk_25MHz: process (clk)
    begin
        if clk = '1' and clk'Event then
            clk_div <= clk_div + 1;
        end if;
    clk_25 <= clk_div(2);   
    end process clk_25MHz;
    
    v_sync: process (clk_25)
    begin
		if rising_edge(clk_25) then;
		end if;
        
    end process v_sync;
	
	h_sync: process (clk_25)
    begin
		if rising_edge(clk_25) then;
		end if;
        
    end process v_sync;
    

end Behavioral;
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
        red, green, blue : in std_logic
        
--        row, column : out std_logic_vector(9 downto 0);
--        Rout, Gout, Bout, H, V : out std_logic
    );
end vga;

architecture Behavioral of vga is

    constant width: integer := 640;         --pixels
    constant height: integer := 480;        --pixels

    constant sync_pulse: integer := 521;    --lines
    constant display_time: integer := 480;  --lines
    constant pulse_width: integer := 2;     --lines
    constant front_porch: integer := 10;    --signal
    constant back_portch: integer := 29;    --lines

    signal clk_div: std_logic_vector(2 downto 0) := "000";
    signal clk_25: std_logic;
    
    signal pixel_x: integer := 0;
    signal pixel_y: integer := 0;

begin

    clk_25MHz: process (clk)
    begin
        if clk = '1' and clk'Event then
            clk_div <= clk_div + 1;
        end if;
    clk_25 <= clk_div(2);   
    end process clk_25MHz;
    

end Behavioral;
