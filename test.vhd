--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:45:03 12/08/2017
-- Design Name:   
-- Module Name:   U:/VHDL/final/lab3_simuoation/test.vhd
-- Project Name:  lab3_simuoation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: combination_lock
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT combination_lock
    PORT(
         clk : IN  std_logic_vector(1 downto 0);
         button : IN  std_logic_vector(4 downto 0);
         switches : IN  std_logic_vector(7 downto 0);
         leds : OUT  std_logic_vector(7 downto 0);
         digit : OUT  std_logic_vector(3 downto 0);
         segments : OUT  std_logic_vector(7 downto 0);
			clkhalf: in std_logic_vector(1 downto 0);					--half of 1s clk 	
			clkone: in std_logic_vector(1 downto 0);
			Code_out: out std_logic_vector(39 downto 0)
			--count: out std_logic_vector(31 downto 0)	
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic_vector(1 downto 0) := (others=>'0');
   signal button : std_logic_vector(4 downto 0) := (others => '0');
   signal switches : std_logic_vector(7 downto 0) := (others => '0');
	signal clkhalf: std_logic_vector(1 downto 0);	
	signal clkone: std_logic_vector(1 downto 0);
 	--Outputs
   signal leds : std_logic_vector(7 downto 0);
   signal digit : std_logic_vector(3 downto 0);
   signal segments : std_logic_vector(7 downto 0);
	signal count: std_logic_vector(31 downto 0);	
	signal Code_out: std_logic_vector(39 downto 0);
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: combination_lock PORT MAP (
          clk => clk,
          button => button,
          switches => switches,
          leds => leds,
          digit => digit,
          segments => segments,
			 clkhalf=>clkhalf,
			 clkone=>clkone,
			 Code_out=>Code_out
			 --count=>count
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= "00";
		wait for clk_period;
		clk <= "01";
		wait for clk_period;
		clk <= "10";
		wait for clk_period;
		clk <= "11";
		wait for clk_period;
   end process;
	
	process
   begin
		clkhalf <= "00";
		wait for clk_period*2;
		clkhalf <= "01";
		wait for clk_period*2;
		clkhalf <= "10";
		wait for clk_period*2;
		clkhalf <= "11";
		wait for clk_period*2;
   end process;
 
 process
   begin
		clkone <= "00";
		wait for clk_period*4;
		clkone <= "01";
		wait for clk_period*4;
		clkone <= "10";
		wait for clk_period*4;
		clkone <= "11";
		wait for clk_period*4;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      
		button<="10000";
		wait for 40ns;
		button<="00000";
		wait for 80ns;
		button<="00001";
		wait for 40ns;									--input0 360ns;
		button<="00000";
		wait for 80ns;		
		button<="00010";
		wait for 40ns;									--inout1 480ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--inout2 600ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--inout3 720ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--final  840ns;
		button<="00000";
		wait for 260ns;								--			1100ns
		button<="00010";
		wait for 40ns;									--waiting 1140ns;
		button<="00000";
		wait for 80ns;
		button<="00001";
		wait for 40ns;									--input0 1260ns;
		button<="00000";
		wait for 80ns;	
		button<="00010";
		wait for 40ns;									--inout1 1380ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--inout2 1500ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--inout3 1620ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--final  1740ns;
		button<="00000";
		wait for 260ns;								--  2000ns
		button<="10000";
		wait for 40ns;									--initial 2040ns;
		button<="00000";
		wait for 80ns;									--waiting 2120ns
		button<="00001";
		wait for 40ns;									--input0 2160ns;
		button<="00000";
		wait for 80ns;	
		button<="00100";
		wait for 40ns;									--final 2280ns;
		button<="00000";
		wait for 260ns;								--  2540ns
		button<="00010";
		wait for 40ns;									--waiting 2580ns;
		button<="00000";
		wait for 80ns;
		button<="00001";
		wait for 40ns;									--input0 2700ns;
		button<="00000";
		wait for 80ns;	
		button<="00010";
		wait for 40ns;									--inout1 2820ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--inout2 2940ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--inout3 3060ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--inout4 3180ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--final  3300ns;
		button<="00000";
		wait for 260ns;								--  3560ns
		
		button<="00010";
		wait for 40ns;									--waiting 3600ns;
		button<="00000";
		wait for 80ns;
		button<="00001";
		wait for 40ns;									--input0 3720ns;
		button<="00000";
		wait for 80ns;	
		button<="01000";
		wait for 40ns;									--inout1 3840ns;
		button<="00000";
		wait for 80ns;
		button<="01000";
		wait for 40ns;									--inout2 3960ns;
		button<="00000";
		wait for 80ns;
		button<="01000";
		wait for 40ns;									--inout3 4080ns;
		button<="00000";
		wait for 80ns;
		button<="01000";
		wait for 40ns;									--inout4 4200ns;
		button<="00000";
		wait for 80ns;
		button<="01000";
		wait for 40ns;									--final  4320ns;
		button<="00000";
		wait for 260ns;								--  4580ns
		
		button<="01000";
		wait for 40ns;									--waiting 4620ns;
		button<="00000";
		wait for 80ns;
		button<="00001";
		wait for 40ns;									--input0 4740ns;
		button<="00000";
		wait for 80ns;	
		button<="00010";
		wait for 40ns;									--inout1 4860ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--inout2 4980ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--inout3 5100ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--inout4 5220ns;
		button<="00000";
		wait for 80ns;
		button<="00010";
		wait for 40ns;									--final  5340ns;
		button<="00000";
		wait for 260ns;								--  5600ns

      wait;
   end process;

	process
	begin
		wait for 100 ns;	

      wait for clk_period*10;
		
		wait for 180 ns;								
		switches<="00000001";						-- 1 380ns;
		wait for 120 ns;								
		switches<="00000010";						-- 2 500ns;
		wait for 120 ns;								
		switches<="00000011";						-- 3 620ns
		wait for 120 ns;								
		switches<="00000100";						-- 4 740ns
		wait for 120 ns;								-- 860 ns
		switches<="00000000";						
		wait for 420 ns;								-- 1280ns
		switches<="00000101";						--	5 1280ns
		wait for 120 ns;
		switches<="00000000";						--	0 1400ns
		wait for 120 ns;
		switches<="00000100";						--	4 1520ns
		wait for 120 ns;
		switches<="00000010";						--	2 1640ns
		wait for 120 ns;								-- 1760ns
		switches<="00000000";						
		wait for 420 ns;								-- 2180ns
		switches<="00000101";						
		wait for 120 ns;								-- digit5 2300ns
		switches<="00000000";						
		wait for 420 ns;								-- 2720ns
		switches<="00001000";						--	8 2720ns
		wait for 120 ns;
		switches<="00000001";						--	1 2840ns
		wait for 120 ns;
		switches<="00000111";						--	7 2960ns
		wait for 120 ns;
		switches<="00000000";						--	0 3080ns
		wait for 120 ns;
		switches<="00000000";						--	0 3200ns
		wait for 120 ns;								--  3320ns
		switches<="00000000";						
		wait for 420 ns;								-- 3740ns
		switches<="00000001";						-- 1 3740ns
		wait for 120 ns;	
		switches<="00000010";						-- 2 3860ns
		wait for 120 ns;
		switches<="00000011";						-- 3 3980ns
		wait for 120 ns;
		switches<="00000100";						-- 4 4100ns
		wait for 120 ns;
		switches<="00000101";						-- 5 4220ns
		wait for 120 ns;								--  4340
		switches<="00000000";						
		wait for 420 ns;								-- 4760ns
		switches<="00000001";						-- 1 4760ns
		wait for 120 ns;	
		switches<="00000010";						-- 2 4880ns
		wait for 120 ns;
		switches<="00000011";						-- 3 5000ns
		wait for 120 ns;
		switches<="00000100";						-- 4 5120ns
		wait for 120 ns;
		switches<="00000101";						-- 5 5240ns
		wait for 120 ns;								--  5360
		switches<="00000000";						
		wait for 240 ns;								-- 5600ns
	end process;
END;
