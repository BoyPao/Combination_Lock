----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:50:53 11/06/2017 
-- Design Name: 
-- Module Name:    display - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display is
    Port ( segs : out  STD_LOGIC_VECTOR (7 downto 0);
           number : in  STD_LOGIC_VECTOR (4 downto 0));
end display;

architecture Behavioral of display is

begin
		
	segs(7)<='1';
  with number SELect
   segs(6 downto 0)<= "1111001" when "00001",   --1
         "0100100" when "00010",   --2
         "0110000" when "00011",   --3
         "0011001" when "00100",   --4
         "0010010" when "00101",   --5
         "0000010" when "00110",   --6
         "1111000" when "00111",   --7
         "0000000" when "01000",   --8
         "0010000" when "01001",   --9
         "0001000" when "01010",   --A
         "0000011" when "01011",   --b
         "1000110" when "01100",   --C
         "0100001" when "01101",   --d
         "0000110" when "01110",   --E
         "0001110" when "01111",   --F
			"0000110" when "10001",--E
			"0101111" when "10010",--r
			"0001001" when "10011",--K
			"1111111" when "10000",--nothing
			
         "1000000" when others;   --0


end Behavioral;

