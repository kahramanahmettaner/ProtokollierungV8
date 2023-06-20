----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.06.2023 15:30:08
-- Design Name: 
-- Module Name: tuerschloss - Behavioral
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

entity Tuerschloss is
    Port ( Clock : in STD_LOGIC;
           ButtonsIn : in STD_LOGIC_VECTOR(3 downto 0); -- Button0 als Reset implementiert
           Switches : in STD_LOGIC_VECTOR(3 downto 0);
           LEDsOut : out STD_LOGIC_VECTOR(3 downto 0));
end Tuerschloss;

architecture Behavioral of Tuerschloss is

-- Debounced Buttons
signal Buttons : std_logic_vector(3 downto 0);

-- Reset Signal
signal Reset : std_logic;

-- State Signals
type state_type is (
    Init, Init2NewCode, Init2EnterCode, 
    NewCode, NewCode2, EnterCode, EnterCode2Success, EnterCode2Fail,
    Success, Fail
);
signal current_s, next_s : state_type;

-- code and led
signal code: std_logic_vector(3 downto 0) := "0000";
signal next_code: std_logic_vector(3 downto 0) := "0000";
signal led: std_logic_vector(3 downto 0) := "0000";
signal next_led: std_logic_vector(3 downto 0) := "0000";


--	Entprellung
component Debounce is
    Port ( 
		clk		:	in   std_logic; 					--! Taktsignal
		keyin    :	in   std_logic_vector(3 downto 0);	--! bouncing input
		keyout	:	out  std_logic_vector(3 downto 0)	--! debounced output
	 );
end component;


begin

Debouncing	:	Debounce
port map	(
	clk=>Clock,		--! Taktsignal
	keyin=>ButtonsIn,	--! bouncing buttons
	keyout=>Buttons	--! debounced buttons
);

-- nebenläufige Anweisungen
Reset <= Buttons(0);

seq: process(Clock)
begin
    if rising_edge(Clock) then
    
        if(Reset = '1') then
            current_s <= Init; -- or Init2 ????
        else
            current_s <= next_s;
            code <= next_code;
            led <= next_led;
        end if;
    end if;
end process;

comb: process(current_s, Buttons, Switches, led, code) is
begin
    --  Latches vermeiden
    next_s <= current_s;
    next_code <= code;
    next_led <= led;
    
    case current_s is
        when Init =>
            next_led <= b"0001";
            if (Buttons(2) = '1') then next_s <= Init2EnterCode;
            elsif (Buttons(3) = '1') then next_s <= Init2NewCode;
            end if;
                   
        when Init2EnterCode =>
            next_led <= b"0001";
            if (Buttons(2) = '0') then next_s <= EnterCode;
            end if;
        
        when Init2NewCode => 
            next_led <= b"0001";
            if (Buttons(3) = '0') then next_s <= NewCode;
            end if;
            
        when NewCode =>
            next_led <= b"0010";
            if (Buttons(3) = '1') then -- Code übernehmen
                next_code <= Switches(3 downto 0);
                next_s <= NewCode2;
            end if;           
        when NewCode2 =>
            next_led <= b"0010";
            if (Buttons(3) = '0') then 
                next_s <= Init;
            end if;
        
        -- Zustand, Code wird eingegeben und überprüft
        when EnterCode =>
            next_led <= b"0100";
            -- Solange Button2 = 0, kann man den Code eingeben.
            
            -- Wenn Button2 = 1, wirde der Code überprüft
            -- und es wird in den nächsten Zustand gewechselt
            if (Buttons(2) = '1') then -- Code eingegeben                      
                if ( next_code = Switches(3 downto 0)) then -- Code ist korrekt
                    next_s <= EnterCode2Success;
                else -- Code ist falsch 
                    next_s <= EnterCode2Fail;
                end if;                    
            end if; 
            
        -- Übergangszustand zu Success         
        when EnterCode2Success =>            
            next_led <= b"0100";
            if (Buttons(2) = '0') then
                next_s <= Success;
            end if;
        
        -- Übergangszustand zu Fail
        when EnterCode2Fail =>
            next_led <= b"0100"; 
            if (Buttons(2) = '0') then
                next_s <= Fail;
            end if;
            
         -- LEDs ausgeschaltet
         when Fail => next_led <= b"0000";
         -- LEDs eingeschaltet
         when Success => next_led <= b"1111";
    end case;
    LEDsOut <= next_led;
end process;

end Behavioral;
