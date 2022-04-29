library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga is
    Port (
        -- VGA
        clk: in std_logic;
        RED, GRN, BLU : out std_logic_vector(3 downto 0);
        HSYNC: out std_logic;
        VSYNC: out std_logic
    );
end vga;

architecture Behavioral of vga is
    constant img_width: integer := 256;
    constant img_height: integer := 256;
    constant img_size: integer := img_height * img_width;

    -- VGA signals (eelmine praks) --------------------------------------------------------
    constant width: integer := 640;
    constant height: integer := 480;

    -- 25MHz pixel clock and 60Hz vertical refresh
    constant v_pulse_width: integer := 2;
    constant v_front_porch: integer := 10;
    constant v_back_porch: integer := 29;

    constant h_pulse_width: integer := 96;
    constant h_front_porch: integer := 16;
    constant h_back_porch: integer := 48;

    signal pixel_x: integer := 0;
    signal pixel_y: integer := 0;

    constant display_x: integer := width + h_front_porch + h_pulse_width + h_back_porch;
    constant display_y: integer := height + v_front_porch + v_pulse_width + v_back_porch;

    signal clk_div: std_logic_vector(1 downto 0) := "00";
    signal clk_25: std_logic;  -- slow clock 25 MHz


    component BRAM PORT(
            clka : IN STD_LOGIC;
            wea : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)

        ); end component;
    -- BRAM signals
    signal sig_clka : STD_LOGIC := '0';
    signal sig_wea : STD_LOGIC := '0';
    signal sig_addra : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    signal sig_dina : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
    signal sig_douta : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";


begin
    VGA: BRAM PORT MAP (
            clka => sig_clka,
            wea => sig_wea,
            addra => sig_addra,
            dina => sig_dina,
            douta => sig_douta
        );

    clk_25MHz: process (clk)
    begin
        if clk = '1' and clk'Event then
            clk_div <= clk_div + 1;
        end if;
        clk_25 <= clk_div(1);
    end process clk_25MHz;

    pixel_move: process (clk_25)
    begin
        if rising_edge(clk_25) then
            if pixel_x = (display_x - 1) then
                pixel_x <= 0;
                ----
                if pixel_y = (display_y - 1) then
                    pixel_y <= 0;
                else
                    pixel_y <= pixel_y + 1;
                end if;
            ----
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
            if (unsigned(sig_addra) < img_size) then
                RED <= sig_douta(11 downto 8);
                GRN <= sig_douta(7 downto 4);
                BLU <= sig_douta(3 downto 0);
                sig_addra <= STD_LOGIC_VECTOR(unsigned(sig_addra)+1);
            else
                RED<=(others=>'0');
                GRN<=(others=>'0');
                BLU<=(others=>'0');
            end if;
        end if;
    end process show_color;

end Behavioral;
          
          
          
------constr
## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# Switches
#set_property PACKAGE_PIN V17 [get_ports {RED_IN[0]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {RED_IN[0]}]
#set_property PACKAGE_PIN V16 [get_ports {RED_IN[1]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {RED_IN[1]}]
#set_property PACKAGE_PIN W16 [get_ports {RED_IN[2]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {RED_IN[2]}]
#set_property PACKAGE_PIN W17 [get_ports {RED_IN[3]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {RED_IN[3]}]
#set_property PACKAGE_PIN W15 [get_ports {GRN_IN[0]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {GRN_IN[0]}]
#set_property PACKAGE_PIN V15 [get_ports {GRN_IN[1]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {GRN_IN[1]}]
#set_property PACKAGE_PIN W14 [get_ports {GRN_IN[2]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {GRN_IN[2]}]
#set_property PACKAGE_PIN W13 [get_ports {GRN_IN[3]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {GRN_IN[3]}]
#set_property PACKAGE_PIN V2 [get_ports {BLU_IN[0]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {BLU_IN[0]}]
#set_property PACKAGE_PIN T3 [get_ports {BLU_IN[1]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {BLU_IN[1]}]
#set_property PACKAGE_PIN T2 [get_ports {BLU_IN[2]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {BLU_IN[2]}]
#set_property PACKAGE_PIN R3 [get_ports {BLU_IN[3]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {BLU_IN[3]}]
#set_property PACKAGE_PIN W2 [get_ports {sw[12]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
#set_property PACKAGE_PIN U1 [get_ports {sw[13]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
#set_property PACKAGE_PIN T1 [get_ports {sw[14]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]
#set_property PACKAGE_PIN R2 [get_ports {sw[15]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]


## LEDs
#set_property PACKAGE_PIN U16 [get_ports {led[0]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
#set_property PACKAGE_PIN E19 [get_ports {led[1]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
#set_property PACKAGE_PIN U19 [get_ports {led[2]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
#set_property PACKAGE_PIN V19 [get_ports {led[3]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
#set_property PACKAGE_PIN W18 [get_ports {led[4]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
#set_property PACKAGE_PIN U15 [get_ports {led[5]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
#set_property PACKAGE_PIN U14 [get_ports {led[6]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
#set_property PACKAGE_PIN V14 [get_ports {led[7]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
#set_property PACKAGE_PIN V13 [get_ports {led[8]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]
#set_property PACKAGE_PIN V3 [get_ports {led[9]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[9]}]
#set_property PACKAGE_PIN W3 [get_ports {led[10]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[10]}]
#set_property PACKAGE_PIN U3 [get_ports {led[11]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[11]}]
#set_property PACKAGE_PIN P3 [get_ports {led[12]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[12]}]
#set_property PACKAGE_PIN N3 [get_ports {led[13]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[13]}]
#set_property PACKAGE_PIN P1 [get_ports {led[14]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]
#set_property PACKAGE_PIN L1 [get_ports {led[15]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]


##7 segment display
#set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
#set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
#set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
#set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
#set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
#set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
#set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

#set_property PACKAGE_PIN V7 [get_ports dp]
	#set_property IOSTANDARD LVCMOS33 [get_ports dp]

#set_property PACKAGE_PIN U2 [get_ports {an[0]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
#set_property PACKAGE_PIN U4 [get_ports {an[1]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
#set_property PACKAGE_PIN V4 [get_ports {an[2]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
#set_property PACKAGE_PIN W4 [get_ports {an[3]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


##Buttons
#set_property PACKAGE_PIN U18 [get_ports btnC]
	#set_property IOSTANDARD LVCMOS33 [get_ports btnC]
#set_property PACKAGE_PIN T18 [get_ports btnU]
	#set_property IOSTANDARD LVCMOS33 [get_ports btnU]
#set_property PACKAGE_PIN W19 [get_ports btnL]
	#set_property IOSTANDARD LVCMOS33 [get_ports btnL]
#set_property PACKAGE_PIN T17 [get_ports btnR]
	#set_property IOSTANDARD LVCMOS33 [get_ports btnR]
#set_property PACKAGE_PIN U17 [get_ports btnD]
	#set_property IOSTANDARD LVCMOS33 [get_ports btnD]



##Pmod Header JA
##Sch name = JA1
#set_property PACKAGE_PIN J1 [get_ports {JA[0]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[0]}]
##Sch name = JA2
#set_property PACKAGE_PIN L2 [get_ports {JA[1]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[1]}]
##Sch name = JA3
#set_property PACKAGE_PIN J2 [get_ports {JA[2]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[2]}]
##Sch name = JA4
#set_property PACKAGE_PIN G2 [get_ports {JA[3]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[3]}]
##Sch name = JA7
#set_property PACKAGE_PIN H1 [get_ports {JA[4]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[4]}]
##Sch name = JA8
#set_property PACKAGE_PIN K2 [get_ports {JA[5]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[5]}]
##Sch name = JA9
#set_property PACKAGE_PIN H2 [get_ports {JA[6]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[6]}]
##Sch name = JA10
#set_property PACKAGE_PIN G3 [get_ports {JA[7]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[7]}]



##Pmod Header JB
##Sch name = JB1
#set_property PACKAGE_PIN A14 [get_ports {JB[0]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[0]}]
##Sch name = JB2
#set_property PACKAGE_PIN A16 [get_ports {JB[1]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[1]}]
##Sch name = JB3
#set_property PACKAGE_PIN B15 [get_ports {JB[2]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[2]}]
##Sch name = JB4
#set_property PACKAGE_PIN B16 [get_ports {JB[3]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[3]}]
##Sch name = JB7
#set_property PACKAGE_PIN A15 [get_ports {JB[4]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[4]}]
##Sch name = JB8
#set_property PACKAGE_PIN A17 [get_ports {JB[5]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[5]}]
##Sch name = JB9
#set_property PACKAGE_PIN C15 [get_ports {JB[6]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[6]}]
##Sch name = JB10
#set_property PACKAGE_PIN C16 [get_ports {JB[7]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[7]}]



##Pmod Header JC
##Sch name = JC1
#set_property PACKAGE_PIN K17 [get_ports {JC[0]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[0]}]
##Sch name = JC2
#set_property PACKAGE_PIN M18 [get_ports {JC[1]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[1]}]
##Sch name = JC3
#set_property PACKAGE_PIN N17 [get_ports {JC[2]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[2]}]
##Sch name = JC4
#set_property PACKAGE_PIN P18 [get_ports {JC[3]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[3]}]
##Sch name = JC7
#set_property PACKAGE_PIN L17 [get_ports {JC[4]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[4]}]
##Sch name = JC8
#set_property PACKAGE_PIN M19 [get_ports {JC[5]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[5]}]
##Sch name = JC9
#set_property PACKAGE_PIN P17 [get_ports {JC[6]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[6]}]
##Sch name = JC10
#set_property PACKAGE_PIN R18 [get_ports {JC[7]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[7]}]


##Pmod Header JXADC
##Sch name = XA1_P
#set_property PACKAGE_PIN J3 [get_ports {JXADC[0]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[0]}]
##Sch name = XA2_P
#set_property PACKAGE_PIN L3 [get_ports {JXADC[1]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[1]}]
##Sch name = XA3_P
#set_property PACKAGE_PIN M2 [get_ports {JXADC[2]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[2]}]
##Sch name = XA4_P
#set_property PACKAGE_PIN N2 [get_ports {JXADC[3]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[3]}]
##Sch name = XA1_N
#set_property PACKAGE_PIN K3 [get_ports {JXADC[4]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[4]}]
##Sch name = XA2_N
#set_property PACKAGE_PIN M3 [get_ports {JXADC[5]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[5]}]
##Sch name = XA3_N
#set_property PACKAGE_PIN M1 [get_ports {JXADC[6]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[6]}]
##Sch name = XA4_N
#set_property PACKAGE_PIN N1 [get_ports {JXADC[7]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[7]}]



##VGA Connector
set_property PACKAGE_PIN G19 [get_ports {RED[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {RED[0]}]
set_property PACKAGE_PIN H19 [get_ports {RED[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {RED[1]}]
set_property PACKAGE_PIN J19 [get_ports {RED[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {RED[2]}]
set_property PACKAGE_PIN N19 [get_ports {RED[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {RED[3]}]
set_property PACKAGE_PIN N18 [get_ports {BLU[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {BLU[0]}]
set_property PACKAGE_PIN L18 [get_ports {BLU[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {BLU[1]}]
set_property PACKAGE_PIN K18 [get_ports {BLU[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {BLU[2]}]
set_property PACKAGE_PIN J18 [get_ports {BLU[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {BLU[3]}]
set_property PACKAGE_PIN J17 [get_ports {GRN[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {GRN[0]}]
set_property PACKAGE_PIN H17 [get_ports {GRN[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {GRN[1]}]
set_property PACKAGE_PIN G17 [get_ports {GRN[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {GRN[2]}]
set_property PACKAGE_PIN D17 [get_ports {GRN[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {GRN[3]}]
set_property PACKAGE_PIN P19 [get_ports HSYNC]
	set_property IOSTANDARD LVCMOS33 [get_ports HSYNC]
set_property PACKAGE_PIN R19 [get_ports VSYNC]
	set_property IOSTANDARD LVCMOS33 [get_ports VSYNC]


##USB-RS232 Interface
#set_property PACKAGE_PIN B18 [get_ports RsRx]
	#set_property IOSTANDARD LVCMOS33 [get_ports RsRx]
#set_property PACKAGE_PIN A18 [get_ports RsTx]
	#set_property IOSTANDARD LVCMOS33 [get_ports RsTx]


##USB HID (PS/2)
#set_property PACKAGE_PIN C17 [get_ports PS2Clk]
	#set_property IOSTANDARD LVCMOS33 [get_ports PS2Clk]
	#set_property PULLUP true [get_ports PS2Clk]
#set_property PACKAGE_PIN B17 [get_ports PS2Data]
	#set_property IOSTANDARD LVCMOS33 [get_ports PS2Data]
	#set_property PULLUP true [get_ports PS2Data]


##Quad SPI Flash
##Note that CCLK_0 cannot be placed in 7 series devices. You can access it using the
##STARTUPE2 primitive.
#set_property PACKAGE_PIN D18 [get_ports {QspiDB[0]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[0]}]
#set_property PACKAGE_PIN D19 [get_ports {QspiDB[1]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[1]}]
#set_property PACKAGE_PIN G18 [get_ports {QspiDB[2]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[2]}]
#set_property PACKAGE_PIN F18 [get_ports {QspiDB[3]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[3]}]
#set_property PACKAGE_PIN K19 [get_ports QspiCSn]
	#set_property IOSTANDARD LVCMOS33 [get_ports QspiCSn]


## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]         
