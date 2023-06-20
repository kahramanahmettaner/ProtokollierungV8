----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.06.2023 14:57:09
-- Design Name: 
-- Module Name: LED - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LED is
    Port ( Clock : in STD_LOGIC;
           Switches : in STD_LOGIC_VECTOR(3 downto 0);
           Buttons : in STD_LOGIC_VECTOR(3 downto 0);
           LEDsOut : out STD_LOGIC_VECTOR(3 downto 0));
end LED;

architecture Behavioral of LED is

signal counter: unsigned(8 downto 0 ) := (others => '0');
signal PWMSignalLow: std_logic :='0';
signal PWMSignalHigh: std_logic :='1';
signal PWMClock: std_logic :='0';

begin

-- Es wird ein CLock-Signal von 50KHz f�r PWMSignal erzeugt
clockdivider: process(Clock)
begin
    if rising_edge(Clock) then
        counter <= counter + 1;
        if (counter = 500) then 
            PWMClock <= '1';
            counter <= (others => '0');
        else
            PWMClock <= '0';
        end if; 
    end if;    
end process;

-- Es werden in diesem Prozess LEDs gesteuert
-- Es wird auch PWM Signal mit Hilfe von PWMClock aktualisiert
LED : process(Clock, PWMClock)
begin
    if rising_edge(PWMClock) then
        PWMSignalLow <= not PWMSignalLow;
        PWMSignalHigh <= not PWMSignalHigh; 
    end if;
    
    if rising_edge(Clock) then
        -- Impelementierung:
        -- Wenn der erste von zu dem betroffenen LED geh�rigen Schaltern (Switches) auf 1 
        --      -> Wenn Schalter 2 (Buttons) auf 0: LED an 
        --      -> Wenn Schalter 2 (Buttons) auf 1: PWM - Energiesparmodus
        -- Ansonsten betrachte Schalter 2 (Buttons):
        --      -> Wenn der auf 1:      PWM
        --      -> Wenn auch der auf 0: LED aus
        
        -- LEDsOut(0): Switches(0), Buttons(0)
        if (Switches(0) = '0' and Buttons(0) = '0') then -- aus
            LEDsOut(0) <= '0'; 
        elsif (Switches(0) = '1' and Buttons(0) = '0') then -- an
            LEDsOut(0) <= '1'; 
        elsif (Switches(0) = '0' and Buttons(0) = '1') then -- PWM
            LEDsOut(0) <= PWMSignalHigh; 
        else -- PWM Energiesparmodus -- Beide Schalter auf 1
            LEDsOut(0) <= PWMSignalLow; 
        end if;
        
        -- LEDsOut(1): Switches(1), Buttons(1)
        if (Switches(1) = '0' and Buttons(1) = '0') then -- aus
            LEDsOut(1) <= '0'; 
        elsif (Switches(0) = '1' and Buttons(1) = '0') then -- an
            LEDsOut(1) <= '1'; 
        elsif (Switches(1) = '0' and Buttons(1) = '1') then -- PWM
            LEDsOut(1) <= PWMSignalHigh; 
        else -- PWM Energiesparmodus -- Beide Schalter auf 1
            LEDsOut(1) <= PWMSignalLow; 
        end if;
        
        -- LEDsOut(2): Switches(2), Buttons(2)
        if (Switches(2) = '0' and Buttons(2) = '0') then -- aus
            LEDsOut(2) <= '0'; 
        elsif (Switches(2) = '1' and Buttons(2) = '0') then -- an
            LEDsOut(2) <= '1'; 
        elsif (Switches(2) = '0' and Buttons(2) = '1') then -- PWM
            LEDsOut(2) <= PWMSignalHigh; 
        else -- PWM Energiesparmodus -- Beide Schalter auf 1
            LEDsOut(2) <= PWMSignalHigh; 
        end if;
        
        -- LEDsOut(3): Switches(3), Buttons(3)
        if (Switches(3) = '0' and Buttons(3) = '0') then -- aus
            LEDsOut(3) <= '0'; 
        elsif (Switches(3) = '1' and Buttons(3) = '0') then -- an
            LEDsOut(3) <= '1'; 
        elsif (Switches(3) = '0' and Buttons(3) = '1') then -- PWM
            LEDsOut(3) <= PWMSignalHigh; 
        else -- PWM Energiesparmodus -- Beide Schalter auf 1
            LEDsOut(3) <= PWMSignalHigh; 
        end if;
    end if;
        
end process;

end Behavioral;
