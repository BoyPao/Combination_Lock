----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       HAO PENG
-- Create Date:    01/12/2017
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
  Port ( clk      : in  STD_LOGIC_vector(1 downto 0);
         button  : in  STD_LOGIC_VECTOR (4 downto 0);  -- centre, left, up, right, down
         switches : in  STD_LOGIC_VECTOR (7 downto 0);  
         leds     : out  STD_LOGIC_VECTOR (7 downto 0);
         digit    : out  STD_LOGIC_VECTOR (3 downto 0);
         segments : out  STD_LOGIC_VECTOR (7 downto 0);
			clkhalf: in std_logic_vector(1 downto 0);					--half of 1s clk 	
			clkone: in std_logic_vector(1 downto 0);
			count: out std_logic_vector(31 downto 0);
			Code_out: out std_logic_vector(39 downto 0)			
			);

      -- Assign inputs and outputs to appropriate pins on FPGA
         attribute LOC : string ;
         attribute LOC of clk : signal is "V10";
         attribute LOC of switches : signal is "T5,V8,U8,N8,M8,V9,T9,T10";
         attribute LOC of button : signal is "B8,C4,A8,D9,C9";
         attribute LOC of leds : signal is "T11,R11,N11,M11,V15,U15,V16,U16";
         attribute LOC of digit : signal is "P17,P18,N15,N16";
         attribute LOC of segments : signal is "M13,L14,N14,M14,U18,U17,T18,T17";
end combination_lock;  

architecture Behavioral of combination_lock is
	component display 
		port(
    segs:out std_logic_vector(7 downto 0);
    number:in std_logic_vector(4 downto 0)
    );
	 end component;
	signal Birthday:std_logic_vector(15 downto 0);				--to recorde my Birthday
	signal Code:std_logic_vector(39 downto 0);					--to recorde my code
	signal pass:std_logic;												--to identify whether input equals to code
	signal situation:std_logic_vector(1 downto 0);				--to distinguish inputing and rewriting founction
	signal timescount:std_logic_vector(3 downto 0);				--to record how many digits have been inputed
	signal times:std_logic_vector(3 downto 0);					--to record how many digits of code is;
	signal sw_reg:std_logic_vector(39 downto 0);					--to record 10 digits inputing
	signal sw_reg_write:std_logic_vector(39 downto 0);			--to record 10 digits rewriting
	signal show:std_logic_vector(4 downto 0);						--to sent data to component
		signal sw_ninth:std_logic_vector(4 downto 0);			--to record the tenth input 
		signal sw_eighth:std_logic_vector(4 downto 0);			--to record the ninth input 
		signal sw_seventh:std_logic_vector(4 downto 0);			--to record the eighth input 
		signal sw_sixth:std_logic_vector(4 downto 0);			--to record the seventh input 
		signal sw_fifth:std_logic_vector(4 downto 0);			--to record the sixth input 
		signal sw_forth:std_logic_vector(4 downto 0);			--to record the fifth input 
	signal sw_third:std_logic_vector(4 downto 0);				--to record the fourth input 
	signal sw_second:std_logic_vector(4 downto 0);				--to record the third input 
	signal sw_first:std_logic_vector(4 downto 0);				--to record the second input 
	signal sw_zero:std_logic_vector(4 downto 0);					--to record the first input 

	signal sw_ninth_write:std_logic_vector(4 downto 0);		--to record the tenth rewriting 
		signal sw_eighth_write:std_logic_vector(4 downto 0);	--to record the ninth rewriting 
		signal sw_seventh_write:std_logic_vector(4 downto 0);	--to record the tenth rewriting 
		signal sw_sixth_write:std_logic_vector(4 downto 0);	--to record the tenth rewriting 
		signal sw_fifth_write:std_logic_vector(4 downto 0);	--to record the tenth rewriting 
		signal sw_fourth_write:std_logic_vector(4 downto 0);	--to record the tenth rewriting 
	signal sw_third_write:std_logic_vector(4 downto 0);		--to record the tenth rewriting 
	signal sw_second_write:std_logic_vector(4 downto 0);		--to record the tenth rewriting 
	signal sw_first_write:std_logic_vector(4 downto 0);		--to record the tenth rewriting 
	signal sw_zero_write:std_logic_vector(4 downto 0);			--to record the tenth rewriting 
	signal show_third:std_logic_vector(4 downto 0);				--to sent data to fourth segment		
	signal show_second:std_logic_vector(4 downto 0);			--to sent data to third segment		
	signal show_first:std_logic_vector(4 downto 0);				--to sent data to second segment		
	signal show_zero:std_logic_vector(4 downto 0);				--to sent data to first segment		
	signal clkhalf_reg:std_logic_vector(1 downto 0);					--half of 1s clk 	
	signal clkone_reg:std_logic_vector(1 downto 0);					-- 1s clk
	signal count_reg:std_logic_vector(31 downto 0);					-- a 32 bits counter to porduce clkhalf and clkone 
	signal digit_reg:std_logic_vector(3 downto 0);				--segment number 
	type statetype is ( 
		initial,initial1,digitnum,waiting,waiting1,input0,input00,input1,input11,input2,input22,input3,input33,input4,input44,input5,input55,input6,input66,input7,input77,input8,input88,input9,input99,final,final1,
		input0w,input00w,input1w,input11w,input2w,input22w,input3w,input33w,input4w,input44w,input5w,input55w,input6w,input66w,input7w,input77w,input8w,input88w,input9w,input99w,finalw,final1w);
	signal	state_reg, state_next: statetype;
	
	

begin
	
	sw_reg<=sw_ninth(3 downto 0) & sw_eighth(3 downto 0) & sw_seventh(3 downto 0) & sw_sixth(3 downto 0) & sw_fifth(3 downto 0) & sw_forth(3 downto 0) & sw_third(3 downto 0) & sw_second(3 downto 0) & sw_first(3 downto 0) & sw_zero(3 downto 0);
	sw_reg_write<=sw_ninth_write(3 downto 0) & sw_eighth_write(3 downto 0) & sw_seventh_write(3 downto 0) & sw_sixth_write(3 downto 0) & sw_fifth_write(3 downto 0) & sw_fourth_write(3 downto 0) & sw_third_write(3 downto 0) & sw_second_write(3 downto 0) & sw_first_write(3 downto 0) & sw_zero_write(3 downto 0);
	digit<=digit_reg;
	dd: display port map( number => show, segs => segments);	
	count<=count_reg;
	Code_out<=Code;
	--produce clk with 1Hz frequence named as "clkhalf"
	--process(clk)
	--begin
		--if(rising_edge(clk))then
		--	count_reg<=count_reg+1;
			--if count=X"017d783f" then   
		--	if count_reg=X"00000001" then   					--X"00BEBC20" mutiply 20ns equals to 0.5s
			--	count_reg<=X"00000000";
			--	if clkhalf_reg="11" then					
			--		if clkone_reg="11" then
			--			clkone_reg<="00";
			--		else
			--			clkone_reg<=clkone_reg+1;
			--		end if;
			--		clkhalf_reg<="00";
			--	else
			--		clkhalf_reg<=clkhalf_reg+1;
			--	end if;
			--end if;	
		--end if;
	--end process;

		--achieve the function of button
	process(clk)
	begin
		if(rising_edge(clk(0)))then
		if button="10000" then														--button(4) can initialize the functiion whenever you need
			state_reg<=initial;
		end if;
		
		case state_reg is																--FSM
		when initial=>
			timescount<="0000";
			times<="0100";
			Code<=X"0000000718";
			Birthday<=X"2405";
			sw_ninth(3 downto 0)<="0000";
			sw_eighth(3 downto 0)<="0000";
			sw_seventh(3 downto 0)<="0000";
			sw_sixth(3 downto 0)<="0000";
			sw_fifth(3 downto 0)<="0000";
			sw_forth(3 downto 0)<="0000";
			sw_third(3 downto 0)<="0000";
			sw_second(3 downto 0)<="0000";
			sw_first(3 downto 0)<="0000";
			sw_zero(3 downto 0)<="0000";
			pass <='0';
			situation<="01";
			show_third<="10000";
			show_second<="10000";
			show_first<="10000";
			show_zero<="10000";
			leds(7 downto 0)<="11111111";
			if button="00000" then
				state_reg<=waiting;
			end if;
		when waiting=>
			leds(7 downto 0)<="11110000";
			if button="00001" then
				state_reg<=waiting1;
			end if;
		when digitnum=>
			leds(7 downto 0)<="00001111";
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0' & sw_reg(3 downto 0);
			pass <='0';
			if button="00000" then
				state_reg<=final;
			end if;
		when waiting1=>
			if button="00000" then
				if pass ='1' then
					state_reg<=input0w;
				elsif pass ='0' then
					state_reg<=input0;
				end if;
			end if;
		when input0=>
			leds(7 downto 0)<="00000001";
			timescount<="0001";
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'&switches(3 downto 0);
			sw_zero<='0'& switches(3 downto 0);
			if button="00010" then
				
				situation<="01";
				if timescount<times then
					state_reg<=input00;
				else 
					if Code(3 downto 0)= sw_reg(3 downto 0)then
						pass <='1';
					else
						pass <='0';
					end if;
					state_reg<=final;
				end if;
			elsif button="00100" then
				situation<="11";
				state_reg<=digitnum;
				times<=switches(3 downto 0);
			end if;
		when input00=>
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'& sw_reg(3 downto 0);
			if button="00000" then
				state_reg<=input1;
			end if;
		when input1=>
			leds(7 downto 0)<="00000010";
			timescount<="0010";
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& switches(3 downto 0);
			show_zero<='0'& sw_reg(3 downto 0);
			sw_first<='0'& switches(3 downto 0);
			if button="00010" then
			
				if timescount<times then
					state_reg<=input11;
				else 
					if Code(7 downto 0)= sw_reg(7 downto 0) then
						pass <='1';
					else
						pass <='0';
					end if;
					state_reg<=final;
				end if;
			end if;
		when input11=>
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& sw_reg(7 downto 4);
			show_zero<='0'& sw_reg(3 downto 0);
			if button="00000" then
				state_reg<=input2;
			end if;
		when input2=>
		leds(7 downto 0)<="00000011";
			timescount<="0011";
			show_third<="00000";
			show_second<='0'& switches(3 downto 0);
			show_first<='0'& sw_reg(7 downto 4);
			show_zero<='0'& sw_reg(3 downto 0);
			sw_second<='0'& switches(3 downto 0);
			if button="00010" then
				--sw_second<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input22;	
				else 
					if Code(11 downto 0)= sw_reg(11 downto 0)then
						pass <='1';
					else
						pass <='0';
					end if;
					state_reg<=final;
				end if;
			end if;
		when input22=>
			show_third<="00000";
			show_second<='0'& sw_reg(11 downto 8);
			show_first<='0'& sw_reg(7 downto 4);
			show_zero<='0'& sw_reg(3 downto 0);
			if button="00000" then
				state_reg<=input3;
			end if;
		when input3=>
		leds(7 downto 0)<="00000100";
			timescount<="0100";
			show_third<='0'& switches(3 downto 0);
			show_second<='0'& sw_reg(11 downto 8);
			show_first<='0'& sw_reg(7 downto 4);
			show_zero<='0'& sw_reg(3 downto 0);
			sw_third<='0'& switches(3 downto 0);
			if button="00010" then
				--sw_third<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input33;
				else 
					if Code(15 downto 0)= sw_reg(15 downto 0) then
						pass <='1';
					elsif Birthday= sw_reg(15 downto 0) then
						pass <='1';
						else
						pass <='0';
					end if;
					state_reg<=final;
				end if;
			end if;
		when input33=>
			show_third<='0'& sw_reg(15 downto 12);
			show_second<='0'& sw_reg(11 downto 8);
			show_first<='0'& sw_reg(7 downto 4);
			show_zero<='0'& sw_reg(3 downto 0);
			if button="00000" then
				state_reg<=input4;
			end if;
		when input4=>
		leds(7 downto 0)<="00000101";
			timescount<="0101";
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'& switches(3 downto 0);
			sw_forth<='0'& switches(3 downto 0);
			if button="00010" then
				--sw_forth<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input44;	
				else 
					if Code(19 downto 0)= sw_reg(19 downto 0)then
						pass <='1';
					else
						pass <='0';
					end if;
					state_reg<=final;
				end if;
			end if;
		when input44=>
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'& sw_reg(19 downto 16);
			if button="00000" then
				state_reg<=input5;
			end if;
		when input5=>
		leds(7 downto 0)<="00000110";
			timescount<="0110";
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& switches(3 downto 0);
			show_zero<='0'& sw_reg(19 downto 16);
			sw_fifth<='0'& switches(3 downto 0);
			if button="00010" then
				--sw_fifth<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input55;	
				else 
					if Code(23 downto 0)= sw_reg(23 downto 0)then
						pass <='1';
					else
						pass <='0';
					end if;
					state_reg<=final;
				end if;
			end if;
		when input55=>
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& sw_reg(23 downto 20);
			show_zero<='0'& sw_reg(19 downto 16);
			if button="00000" then
				state_reg<=input6;
			end if;
		when input6=>
		leds(7 downto 0)<="00000111";
			timescount<="0111";
			show_third<="00000";
			show_second<='0'& switches(3 downto 0);
			show_first<='0'& sw_reg(23 downto 20);
			show_zero<='0'& sw_reg(19 downto 16);
			sw_sixth<='0'& switches(3 downto 0);
			if button="00010" then
			--sw_sixth<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input66;	
				else 
					if Code(27 downto 0)= sw_reg(27 downto 0)then
						pass <='1';
					else
						pass <='0';
					end if;
					state_reg<=final;
				end if;
			end if;
		when input66=>
			show_third<="00000";
			show_second<='0'& sw_reg(27 downto 24);
			show_first<='0'& sw_reg(23 downto 20);
			show_zero<='0'& sw_reg(19 downto 16);
			if button="00000" then
				state_reg<=input7;
			end if;
		when input7=>
		leds(7 downto 0)<="00001000";
			timescount<="1000";
			show_third<='0'& switches(3 downto 0);
			show_second<='0'& sw_reg(27 downto 24);
			show_first<='0'& sw_reg(23 downto 20);
			show_zero<='0'& sw_reg(19 downto 16);
			sw_seventh<='0'& switches(3 downto 0);
			if button="00010" then
			--sw_seventh<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input77;	
				else 
					if Code(31 downto 0)= sw_reg(31 downto 0)then
						pass <='1';
					else
						pass <='0';
					end if;
					state_reg<=final;
				end if;
			end if;
		when input77=>
			show_third<='0'& sw_reg(31 downto 28);
			show_second<='0'& sw_reg(27 downto 24);
			show_first<='0'& sw_reg(23 downto 20);
			show_zero<='0'& sw_reg(19 downto 16);
			if button="00000" then
				state_reg<=input8;
			end if;
		when input8=>
		leds(7 downto 0)<="00001001";
			timescount<="1001";
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'& switches(3 downto 0);
			sw_eighth<='0'& switches(3 downto 0);
			if button="00010" then
			--sw_eighth<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input88;	
				else 
					if Code(35 downto 0)= sw_reg(35 downto 0)then
						pass <='1';
					else
						pass <='0';
					end if;
					state_reg<=final;
				end if;
			end if;
		when input88=>
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'& sw_reg(35 downto 32);
			if button="00000" then
				state_reg<=input9;
			end if;
		when input9=>
		leds(7 downto 0)<="00001010";
			timescount<="1010";
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& switches(3 downto 0);
			show_zero<='0'& sw_reg(35 downto 32);
			sw_ninth<='0'& switches(3 downto 0);
			if button="00010" then
			--sw_ninth<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input99;	
				else 
					if Code(39 downto 0)= sw_reg(39 downto 0)then
						pass <='1';
					else
						pass <='0';
					end if;
					state_reg<=final;
				end if;
			end if;
		when input99=>
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& sw_reg(39 downto 36);
			show_zero<='0'& sw_reg(35 downto 32);
			if button="00000" then
				state_reg<=final;
			end if;
		when final=>
		leds(7 downto 0)<="00001011";
			if clkone(1)='0' then
				if situation="11"then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& times;
				else
				if times="0001"then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg(3 downto 0);
				elsif times="0010" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg(7 downto 4);
					show_zero<='0'& sw_reg(3 downto 0);
				elsif times="0011" then
					show_third<="00000";
					show_second<='0'& sw_reg(11 downto 8);
					show_first<='0'& sw_reg(7 downto 4);
					show_zero<='0'& sw_reg(3 downto 0);
				elsif times="0100" then
					show_third<='0'& sw_reg(15 downto 12);
					show_second<='0'& sw_reg(11 downto 8);
					show_first<='0'& sw_reg(7 downto 4);
					show_zero<='0'& sw_reg(3 downto 0);
				elsif times="0101" then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg(19 downto 16);
				elsif times="0110" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg(23 downto 20);
					show_zero<='0'& sw_reg(19 downto 16);
				elsif times="0111" then
					show_third<="00000";
					show_second<='0'& sw_reg(27 downto 24);
					show_first<='0'& sw_reg(23 downto 20);
					show_zero<='0'& sw_reg(19 downto 16);
				elsif times="1000" then
					show_third<='0'& sw_reg(31 downto 28);
					show_second<='0'& sw_reg(27 downto 24);
					show_first<='0'& sw_reg(23 downto 20);
					show_zero<='0'& sw_reg(19 downto 16);
				elsif times="1001" then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg(35 downto 32);
				elsif times="1010" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg(39 downto 36);
					show_zero<='0'& sw_reg(35 downto 32);
				end if;
				end if;
			elsif clkone(1)='1' then
				if pass ='1' or situation="11" then
					show_third<="10000";
					show_second<="10000";
					show_first<="00000";
					show_zero<="10011";
				else
					show_third<="10000";
					show_second<="10001";
					show_first<="10010";
					show_zero<="10010";
				end if;
			end if;
			if button="00010" or button="00100" then
				state_reg<=final1;
			end if;
		when final1=>
			if clkone(1)='0' then
				if situation="11"then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& times;
				else			
				if times="0001"then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg(3 downto 0);
				elsif times="0010" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg(7 downto 4);
					show_zero<='0'& sw_reg(3 downto 0);
				elsif times="0011" then
					show_third<="00000";
					show_second<='0'& sw_reg(11 downto 8);
					show_first<='0'& sw_reg(7 downto 4);
					show_zero<='0'& sw_reg(3 downto 0);
				elsif times="0100" then
					show_third<='0'& sw_reg(15 downto 12);
					show_second<='0'& sw_reg(11 downto 8);
					show_first<='0'& sw_reg(7 downto 4);
					show_zero<='0'& sw_reg(3 downto 0);
				elsif times="0101" then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg(19 downto 16);
				elsif times="0110" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg(23 downto 20);
					show_zero<='0'& sw_reg(19 downto 16);
				elsif times="0111" then
					show_third<="00000";
					show_second<='0'& sw_reg(27 downto 24);
					show_first<='0'& sw_reg(23 downto 20);
					show_zero<='0'& sw_reg(19 downto 16);
				elsif times="1000" then
					show_third<='0'& sw_reg(31 downto 28);
					show_second<='0'& sw_reg(27 downto 24);
					show_first<='0'& sw_reg(23 downto 20);
					show_zero<='0'& sw_reg(19 downto 16);
				elsif times="1001" then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg(35 downto 32);
				elsif times="1010" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg(39 downto 36);
					show_zero<='0'& sw_reg(35 downto 32);
				end if;
				end if;
			elsif clkone(1)='1' then	
				if pass ='1' or situation="11" then
					show_third<="10000";
					show_second<="10000";
					show_first<="00000";
					show_zero<="10011";
				else
					show_third<="10000";
					show_second<="10001";
					show_first<="10010";
					show_zero<="10010";
				end if;
			end if;
			if button="00000" then
				state_reg<=waiting;
			end if;
			
			
			
			
			
			
		when input0w=>
			leds(7 downto 0)<="00000001";
			timescount<="0001";
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'&switches(3 downto 0);
			sw_zero_write<='0'& switches(3 downto 0);
			if button="01000" then
				situation<="10";
				if timescount<times then
					state_reg<=input00w;
				else 
					pass<='0';
					Code<=X"000000000" & sw_reg_write(3 downto 0);
					state_reg<=finalw;
				end if;
			elsif button="00100" then
				situation<="11";
				state_reg<=digitnum;
				times<=switches(3 downto 0);
			end if;
		when input00w=>
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'& sw_reg_write(3 downto 0);
			if button="00000" then
				state_reg<=input1w;
			end if;
		when input1w=>
			leds(7 downto 0)<="00000010";
			timescount<="0010";
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& switches(3 downto 0);
			show_zero<='0'& sw_reg_write(3 downto 0);
			sw_first_write<='0'& switches(3 downto 0);
			if button="01000" then
			
				if timescount<times then
					state_reg<=input11w;
				else 
					pass<='0';
					Code<=X"00000000" & sw_reg_write(7 downto 0);
					state_reg<=finalw;
				end if;
			end if;
		when input11w=>
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& sw_reg_write(7 downto 4);
			show_zero<='0'& sw_reg_write(3 downto 0);
			if button="00000" then
				state_reg<=input2w;
			end if;
		when input2w=>
		leds(7 downto 0)<="00000011";
			timescount<="0011";
			show_third<="00000";
			show_second<='0'& switches(3 downto 0);
			show_first<='0'& sw_reg_write(7 downto 4);
			show_zero<='0'& sw_reg_write(3 downto 0);
			sw_second_write<='0'& switches(3 downto 0);
			if button="01000" then
				--sw_second<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input22w;	
				else 
					Code<=X"0000000" & sw_reg_write(11 downto 0);
					pass<='0';
					state_reg<=finalw;
				end if;
			end if;
		when input22w=>
			show_third<="00000";
			show_second<='0'& sw_reg_write(11 downto 8);
			show_first<='0'& sw_reg_write(7 downto 4);
			show_zero<='0'& sw_reg_write(3 downto 0);
			if button="00000" then
				state_reg<=input3w;
			end if;
		when input3w=>
		leds(7 downto 0)<="00000100";
			timescount<="0100";
			show_third<='0'& switches(3 downto 0);
			show_second<='0'& sw_reg_write(11 downto 8);
			show_first<='0'& sw_reg_write(7 downto 4);
			show_zero<='0'& sw_reg_write(3 downto 0);
			sw_third_write<='0'& switches(3 downto 0);
			if button="01000" then
				--sw_third<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input33w;
				else 
					Code<=X"000000" & sw_reg_write(15 downto 0);
					pass<='0';
					state_reg<=finalw;
				end if;
			end if;
		when input33w=>
			show_third<='0'& sw_reg_write(15 downto 12);
			show_second<='0'& sw_reg_write(11 downto 8);
			show_first<='0'& sw_reg_write(7 downto 4);
			show_zero<='0'& sw_reg_write(3 downto 0);
			if button="00000" then
				state_reg<=input4w;
			end if;
		when input4w=>
		leds(7 downto 0)<="00000101";
			timescount<="0101";
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'& switches(3 downto 0);
			sw_fourth_write<='0'& switches(3 downto 0);
			if button="01000" then
				--sw_forth<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input44w;	
				else 
					Code<=X"00000" & sw_reg_write(19 downto 0);
					pass<='0';
					state_reg<=finalw;
				end if;
			end if;
		when input44w=>
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'& sw_reg_write(19 downto 16);
			if button="00000" then
				state_reg<=input5w;
			end if;
		when input5w=>
		leds(7 downto 0)<="00000110";
			timescount<="0110";
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& switches(3 downto 0);
			show_zero<='0'& sw_reg_write(19 downto 16);
			sw_fifth_write<='0'& switches(3 downto 0);
			if button="01000" then
				--sw_fifth<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input55w;	
				else 
					Code<=X"0000" & sw_reg_write(23 downto 0);
					pass<='0';
					state_reg<=finalw;
				end if;
			end if;
		when input55w=>
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& sw_reg_write(23 downto 20);
			show_zero<='0'& sw_reg_write(19 downto 16);
			if button="00000" then
				state_reg<=input6w;
			end if;
		when input6w=>
		leds(7 downto 0)<="00000111";
			timescount<="0111";
			show_third<="00000";
			show_second<='0'& switches(3 downto 0);
			show_first<='0'& sw_reg_write(23 downto 20);
			show_zero<='0'& sw_reg_write(19 downto 16);
			sw_sixth_write<='0'& switches(3 downto 0);
			if button="01000" then
			--sw_sixth<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input66w;	
				else 
					Code<=X"000" & sw_reg_write(27 downto 0);
					pass<='0';
					state_reg<=finalw;
				end if;
			end if;
		when input66w=>
			show_third<="00000";
			show_second<='0'& sw_reg_write(27 downto 24);
			show_first<='0'& sw_reg_write(23 downto 20);
			show_zero<='0'& sw_reg_write(19 downto 16);
			if button="00000" then
				state_reg<=input7w;
			end if;
		when input7w=>
		leds(7 downto 0)<="00001000";
			timescount<="1000";
			show_third<='0'& switches(3 downto 0);
			show_second<='0'& sw_reg_write(27 downto 24);
			show_first<='0'& sw_reg_write(23 downto 20);
			show_zero<='0'& sw_reg_write(19 downto 16);
			sw_seventh_write<='0'& switches(3 downto 0);
			if button="01000" then
				if timescount<times then
					state_reg<=input77w;	
				else 
					Code<=X"00" & sw_reg_write(31 downto 0);
					pass<='0';
					state_reg<=finalw;
				end if;
			end if;
		when input77w=>
			show_third<='0'& sw_reg_write(31 downto 28);
			show_second<='0'& sw_reg_write(27 downto 24);
			show_first<='0'& sw_reg_write(23 downto 20);
			show_zero<='0'& sw_reg_write(19 downto 16);
			if button="00000" then
				state_reg<=input8w;
			end if;
		when input8w=>
		leds(7 downto 0)<="00001001";
			timescount<="1001";
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'& switches(3 downto 0);
			sw_eighth_write<='0'& switches(3 downto 0);
			if button="01000" then
			--sw_eighth<='0'& switches(3 downto 0);
				if timescount<times then
					state_reg<=input88w;	
				else 
					Code<=X"0" & sw_reg_write(35 downto 0);
					pass<='0';
					state_reg<=finalw;
				end if;
			end if;
		when input88w=>
			show_third<="00000";
			show_second<="00000";
			show_first<="00000";
			show_zero<='0'& sw_reg_write(35 downto 32);
			if button="00000" then
				state_reg<=input9w;
			end if;
		when input9w=>
		leds(7 downto 0)<="00001010";
			timescount<="1010";
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& switches(3 downto 0);
			show_zero<='0'& sw_reg_write(35 downto 32);
			sw_ninth_write<='0'& switches(3 downto 0);
			if button="01000" then
				if timescount<times then
					state_reg<=input99w;	
				else 
					Code<= sw_reg_write(39 downto 0);
					pass<='0';
					state_reg<=finalw;
				end if;
			end if;
		when input99w=>
			show_third<="00000";
			show_second<="00000";
			show_first<='0'& sw_reg_write(39 downto 36);
			show_zero<='0'& sw_reg_write(35 downto 32);
			if button="00000" then
				state_reg<=finalw;
			end if;
		when finalw=>
		leds(7 downto 0)<="00001011";
			if clkone(1)='0' then	
				if times="0001"then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg_write(3 downto 0);
				elsif times="0010" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg_write(7 downto 4);
					show_zero<='0'& sw_reg_write(3 downto 0);
				elsif times="0011" then
					show_third<="00000";
					show_second<='0'& sw_reg_write(11 downto 8);
					show_first<='0'& sw_reg_write(7 downto 4);
					show_zero<='0'& sw_reg_write(3 downto 0);
				elsif times="0100" then
					show_third<='0'& sw_reg_write(15 downto 12);
					show_second<='0'& sw_reg_write(11 downto 8);
					show_first<='0'& sw_reg_write(7 downto 4);
					show_zero<='0'& sw_reg_write(3 downto 0);
				elsif times="0101" then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg_write(19 downto 16);
				elsif times="0110" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg_write(23 downto 20);
					show_zero<='0'& sw_reg_write(19 downto 16);
				elsif times="0111" then
					show_third<="00000";
					show_second<='0'& sw_reg_write(27 downto 24);
					show_first<='0'& sw_reg_write(23 downto 20);
					show_zero<='0'& sw_reg_write(19 downto 16);
				elsif times="1000" then
					show_third<='0'& sw_reg_write(31 downto 28);
					show_second<='0'& sw_reg_write(27 downto 24);
					show_first<='0'& sw_reg_write(23 downto 20);
					show_zero<='0'& sw_reg_write(19 downto 16);
				elsif times="1001" then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg_write(35 downto 32);
				elsif times="1010" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg_write(39 downto 36);
					show_zero<='0'& sw_reg_write(35 downto 32);
				end if;
			elsif clkone(1)='1' then	
				if pass='0' then
					show_third<="10000";
					show_second<="10000";
					show_first<="00000";
					show_zero<="10011";
				else
					show_third<="10000";
					show_second<="10001";
					show_first<="10010";
					show_zero<="10010";
				end if;
			end if;
			if button="01000" then
				state_reg<=final1w;
			end if;
		when final1w=>
			if clkone(1)='0' then	
				if times="0001"then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg_write(3 downto 0);
				elsif times="0010" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg_write(7 downto 4);
					show_zero<='0'& sw_reg_write(3 downto 0);
				elsif times="0011" then
					show_third<="00000";
					show_second<='0'& sw_reg_write(11 downto 8);
					show_first<='0'& sw_reg_write(7 downto 4);
					show_zero<='0'& sw_reg_write(3 downto 0);
				elsif times="0100" then
					show_third<='0'& sw_reg_write(15 downto 12);
					show_second<='0'& sw_reg_write(11 downto 8);
					show_first<='0'& sw_reg_write(7 downto 4);
					show_zero<='0'& sw_reg_write(3 downto 0);
				elsif times="0101" then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg_write(19 downto 16);
				elsif times="0110" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg_write(23 downto 20);
					show_zero<='0'& sw_reg_write(19 downto 16);
				elsif times="0111" then
					show_third<="00000";
					show_second<='0'& sw_reg_write(27 downto 24);
					show_first<='0'& sw_reg_write(23 downto 20);
					show_zero<='0'& sw_reg_write(19 downto 16);
				elsif times="1000" then
					show_third<='0'& sw_reg_write(31 downto 28);
					show_second<='0'& sw_reg_write(27 downto 24);
					show_first<='0'& sw_reg_write(23 downto 20);
					show_zero<='0'& sw_reg_write(19 downto 16);
				elsif times="1001" then
					show_third<="00000";
					show_second<="00000";
					show_first<="00000";
					show_zero<='0'& sw_reg_write(35 downto 32);
				elsif times="1010" then
					show_third<="00000";
					show_second<="00000";
					show_first<='0'& sw_reg_write(39 downto 36);
					show_zero<='0'& sw_reg_write(35 downto 32);
				end if;
			elsif clkone(1)='1' then	
				if pass='0' then
					show_third<="10000";
					show_second<="10000";
					show_first<="00000";
					show_zero<="10011";
				else
					show_third<="10000";
					show_second<="10001";
					show_first<="10010";
					show_zero<="10010";
				end if;
			end if;
			if button="00000" then
				state_reg<=waiting;
			end if;
		when others=>
	end case;
	end if;
end process;
		
		
		
		
		
		
		--achieve the function of 4 segments
		process(clk)
		begin
		if (clk(0)'event and clk(0)='1') then
			case clkhalf(1 downto 0) is
				when "00"=>
					digit_reg <= "1110";
					show <= show_zero;
				when "01"=>
					digit_reg <= "1101";
					show <= show_first;
				when  "10"=>
					digit_reg <= "1011";
					show <= show_second;
				when "11"=>
					digit_reg<="0111";
					show <= show_third;
				when others=>
			end case;
	
		end if;
		end process;
		
		
		

		
		

	end Behavioral;  
