------------------------------------------------------------------------
-- This module tests basic device function and connectivity on the Nexys
-- board. It was developed using the Xilinx WebPack tools.
--
--  Inputs:
--		mclk		- system clock (100Mhz Oscillator on Pegasus board)
--		bn			- buttons on the Pegasus board
--		swt		- switches on the Pegasus board (8 switches)
--
--  Outputs:
--		led		- discrete LEDs on the Pegasus board (8 leds)
--		an			- anode lines for the 7-seg displays on Pegasus
--		ssg		- cathodes (segment lines) for the displays on Pegasus
--
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Nexysdemo is
    Port (
        mclk    : in std_logic;
        X, Y: in std_logic; -- sw15, sw11
        A, B, C: in std_logic; --sw1, sw2, sw3
        P, Q, R, T : inout std_logic; -- ld1, ld2, ld3, ld4
        led_blink : out std_logic;
        led_signal     : out std_logic_vector(1 to 4);
        led_variable :  out std_logic_vector(1 to 4)
    );
end Nexysdemo;

architecture Behavioral of Nexysdemo is
    signal clkdiv  : std_logic_vector(25 downto 0);
    signal cclk    : std_logic;
    signal reg0 : std_logic_vector(1 to 4) := "0000"; -- outside the process

begin
    -- Divide the master clock (100Mhz) down to a lower frequency.
    process (mclk)
    begin
        if mclk = '1' and mclk'Event then
            clkdiv <= clkdiv + 1;
        end if;
    end process;
    cclk <= clkdiv(25);

    proc1: process (cclk)
        variable dot : std_logic := '0';
    begin
        if cclk = '1' and cclk'Event then
            if dot = '0' then
                dot := '1';
            else
                dot := '0';
            end if;
            led_blink <= dot;
        end if;
    end process proc1;


    -- kasutan variable reg1
    proc2: process (cclk)
        variable reg1 : std_logic_vector(1 to 4) := "0000";
    begin
        if cclk = '1' and cclk'Event then
            reg1(4) := X;
            reg1(3) := reg1(4);
            reg1(2) := reg1(3);
            reg1(1) := reg1(2);
        end if;
        led_variable <= reg1;
    end process proc2;


    -- kasutan signaal reg0
    proc3: process (cclk)
    begin
        if cclk = '1' and cclk'Event then
            reg0(4) <= Y;
            reg0(3) <= reg0(4);
            reg0(2) <= reg0(3);
            reg0(1) <= reg0(2);
        end if;
        led_signal <= reg0;
    end process proc3;

    process (cclk) is
    begin
        if Rising_edge(cclk) then
            P <= A nand B;
            Q <= P or C;
            R <= not Q;
            T <= A and R;
        end if;
    end process;


end Behavioral;

