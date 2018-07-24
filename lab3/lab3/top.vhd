----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       
-- Create Date:    
-- Design Name:    Lab 3 
-- Module Name:    combination_lock - Behavioral 
-- Project Name:   lab3
-- Target Devices: xc6slx16
-- Description:    
-- Additional Comments: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity combination_lock is
  Port ( clk      : in  STD_LOGIC;
         buttons  : in  STD_LOGIC_VECTOR (4 downto 0);  -- centre, left, up, right, down
         switches : in  STD_LOGIC_VECTOR (7 downto 0);  
         leds     : out  STD_LOGIC_VECTOR (7 downto 0);
         digit    : out  STD_LOGIC_VECTOR (3 downto 0);
         segments : out  STD_LOGIC_VECTOR (7 downto 0));

      -- Assign inputs and outputs to appropriate pins on FPGA
         attribute LOC : string ;
         attribute LOC of clk : signal is "V10";
         attribute LOC of switches : signal is "T5,V8,U8,N8,M8,V9,T9,T10";
         attribute LOC of buttons : signal is "B8,C4,A8,D9,C9";
         attribute LOC of leds : signal is "T11,R11,N11,M11,V15,U15,V16,U16";
         attribute LOC of digit : signal is "P17,P18,N15,N16";
         attribute LOC of segments : signal is "M13,L14,N14,M14,U18,U17,T18,T17";
end combination_lock;  

architecture Behavioral of combination_lock is
	component display 
		port(
    segs:out std_logic_vector(7 downto 0);
    number:in std_logic_vector(3 downto 0)
    );
	 end component;
	signal reset:std_logic;
	signal ID:std_logic_vector(15 downto 0);
	signal IDreg:std_logic_vector(15 downto 0);
	signal third:std_logic_vector(3 downto 0);
	signal second:std_logic_vector(3 downto 0);
	signal first:std_logic_vector(3 downto 0);
	signal zero:std_logic_vector(3 downto 0);
	--signal digit:std_logic_vector(3 downto 0);
	type statetype is ( 
		waiting,input0,input1,input2,input3,finish);
	signal	state_reg, state_next: statetype;
	


	
	--signal show:std_logic_vector(3 downto 0);
	--signal count:std_logic_vector(31 downto 0);
	--signal control:std_logic_vector(1 downto 0);
	

begin
	ID<=X"0718";
	IDreg<=third & second & first & zero;
	reset<=buttons(4);
	process(clk,reset)
	begin
		if reset='1' then
			state_reg<=waiting;
			zero<="0000";
			first<="0000";
			second<="0000";
			third<="0000";
			leds<="00000000";
			digit<="1111";
		elsif(rising_edge(clk))then
			case buttons is
				when "00001" =>
					state_reg<=input0;
				when "00010" =>
					if state_reg=input0 then
						zero<=switches(3 downto 0);
					elsif	state_reg=input1 then
						first<=switches(3 downto 0);
					elsif state_reg=input2 then
						second<=switches(3 downto 0);
					elsif state_reg=input3 then
						third<=switches(3 downto 0);
					end if;
					state_reg<=state_next;
				--others=>
			end case;
		end if;
	end process;
	
	process(state_reg)
	begin
		case state_reg is
			when waiting =>
				state_next<=waiting;
			when input0=>
				state_next<=input1;
			when input1=>
				digit<="1110";
				d0:display port map(number=>zero, segs=>segments);
				if zero=ID(3 downto 0)then
					leds(0)<='1';
				end if;
				state_next<=input2;
			when input2=>
				digit<="1100";
				d1:display port map(number=>first, segs=>segments);
				if first=ID(7 downto 4)then
					leds(1)<='1';
				end if;
				state_next<=input3;
			when input3=>
				digit<="1000";
				d2:display port map(number=>second, segs=>segments);
				if first=ID(11 downto 8)then
					leds(2)<='1';
				end if;
				state_next<=finish;
			when finish=>
				digit<="0000";
				d3:display port map(number=>third, segs=>segments);
				if first=ID(11 downto 8)then
					leds(3)<='1';
				end if;
				state_next<=waiting;
				leds(7 downto 4)<="1111";
			--others=>
		end case;
	end process;
	end Behavioral;  

			--if buttons="00001"then
				
			
	--if id
	--number <=X"1234";
	--third<=number(15 downto 12);
	--second<=number(11 downto 8);
	--first<=number(7 downto 4);
	--zore<=number(3 downto 0);
	--control<=count(26 downto 25);
	 
--	dd:display port map(number=>show, segs=>segments);
	--process(clk,buttons)
	--begin
		--if(rising_edge(clk))then
		--	case buttons is
		--		when "01000"=> digit<= "0111" ;show <= third;
			--	when "00100"=> digit<= "1011" ;show <= second;
			--	when "00010"=> digit<= "1101" ;show <= first;
			--	when "00001"=> digit<= "1110" ;show <= zore;
			--	when others=>
			--end case;
			--count<=count+1;
		--	leds(7 downto 0)<='0'&count(31 downto 25);
		--	case control is
			--	when"00"=> show<= zore; digit <= "1110";
			---	when"01"=> show<= first; digit <= "1101";
			--	when"10"=> show<= second; digit <= "1011";
			--	when"11"=> show<= third; digit <= "0111";
			--	when others=>
		--	end case;
		--	if count=X"ffffffff" then
		--		count<=X"00000000";
		--	end if;
	--	end if;
--	end process;
 