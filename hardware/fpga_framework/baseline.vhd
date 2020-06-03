----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:30:39 01/18/2017 
-- Design Name: 
-- Module Name:    bram_baseline - Behavioral 

-- Engineer: Burak UNAL 
-- 
-- Create Date:    
-- Design Name:  Created by Burak UNAL 
-- Project Name: Probabilistic Gallager-B Hard decision Bit-Flipping algorithm
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--COPYRIGHT            : burak@email.arizona.edu
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity baseline is
    Port ( 	clk : in std_logic;
				start : in std_logic;
				reset : in std_logic;
				alpha  : in std_logic_vector (14 downto 0);
				max_iter  : in std_logic_vector (15 downto 0);
				done : out std_logic;	
				cwFailed : out std_logic_vector (63 downto 0);
				cwTested : out std_logic_vector (63 downto 0)
			   );
end baseline;

architecture Behavioral of baseline is

type state_type is (starts, aa, ab, ac, ad, idle,init, writem, decode, statistic, stop);--,inject);



COMPONENT encoder is
    Port ( 	clk			: in	STD_LOGIC;
			rst			: in	STD_LOGIC;
			init		: in	STD_LOGIC;
			start		: in	STD_LOGIC;
			threshold	:in std_logic_vector(14 downto 0);

		
            codeword_out	: out std_logic_vector(99 downto 0);
			codeword_avail	: out	STD_LOGIC);
end COMPONENT;


COMPONENT PGaB is
    Port (clk, rst      : in  std_logic;
	   start : in std_logic; -- brk trigger to start to load inputs values in the decode
		decoder_in    : in  STD_LOGIC_VECTOR(1295 downto 0); -- brkunl bram
		max_iter      : in  std_logic_vector(15 downto 0); --max iteration value
	   
		done : out std_logic;
		load_data_out_ok : out std_logic; -- brkunl bram
		give_up   : out std_logic;
      iteration     : out std_logic_vector(15 downto 0) ;
		dec_out : out std_logic_VECTOR(1295 downto 0)
		);
end COMPONENT;

--signal clk : std_logic;
signal state 		: state_type;
signal resetm : std_logic;--brk := '0';
signal write_ena : std_logic := '0';
signal write_enaP : std_logic := '0';
signal write_done : std_logic := '0';


signal ena_rand : std_logic;--brk := '1';
signal ran_out_sig			: STD_LOGIC_VECTOR(99 downto 0);
signal ran_out_av			: STD_LOGIC;


signal do_decoder			: STD_LOGIC_VECTOR(1295 downto 0):=(others => '0');
signal start_decoder : std_logic := '0';
signal reset_decoder : std_logic := '1';
signal decode_done : std_logic := '0';
signal decode_data_done : std_logic := '0';
signal give_up : std_logic := '0';
signal iteration: STD_LOGIC_VECTOR(15 downto 0):=(others => '0');


signal	  cwFailed_sig : std_logic_vector (63 downto 0) := (others => '0');
signal     Iter_sum_sig : std_logic_vector (63 downto 0) := (others => '0');
signal     cwTested_sig : std_logic_vector (63 downto 0) := (others => '0');
signal     Alpha_sig : std_logic_vector (63 downto 0);
signal     Itermax_sig  : std_logic_vector (63 downto 0);
signal     LED_sig  : std_logic;

signal     rst_r  : std_logic:= '0';
signal     init_r  : std_logic:= '0';
signal     start_r  : std_logic:= '0';

signal     rcw  : std_logic_vector (1295 downto 0):= (others => '0');
signal     dec_in  : std_logic_vector (1295 downto 0):= (others => '0');

begin
--clk <= clk_ena and clk_f;

				
RError: encoder
Port map (clk		=>	clk,		--: in	STD_LOGIC;
			rst		=>	rst_r,	--: in	STD_LOGIC;
			init		=>	init_r,	--: in	STD_LOGIC;
			start		=>	start_r,	--: in	STD_LOGIC;
			threshold => alpha, --"000001100100000",--800 "000000101000111",	--%0.01		--:in std_logic_vector(14 downto 0);
         codeword_out	=>	ran_out_sig,	--: out std_logic_vector(154 downto 0);
			codeword_avail	=>	ran_out_av );	--: out	STD_LOGIC);


d_PGaB: PGaB 
    Port map(clk 	=> clk, 
		rst      	=> reset_decoder, -- 			: in  std_logic;
	   start 		=> start_decoder, --			: in std_logic; -- brk trigger to start to load inputs values in the decode
		decoder_in  => dec_in, --do_noise155xor, --do_join, --	  	: in  STD_LOGIC_VECTOR(154 downto 0); -- brkunl bram
		max_iter    => max_iter, --"0000000001100100", --	  	: in  std_logic_vector(7 downto 0); --max iteration value
	   
		done 			=> decode_done, --		: out std_logic;
		load_data_out_ok => decode_data_done, --	: out std_logic; -- brkunl bram
		give_up   	=> give_up, --		: out std_logic;
      iteration   => iteration, --		  : out std_logic_vector(7 downto 0) ;
		dec_out 		=> do_decoder --		: out std_logic_VECTOR(154 downto 0)
		);


process(clk)
begin
	if clk'event and clk='1' then
		if start_r='1' then
			--rcw <= rcw(1295  downto 130) & ran_out_sig ;
			rcw <= rcw(1195  downto 0) & ran_out_sig ;
		end if;
	end if;
end process;

process(clk)
begin
	if clk'event and clk='1' then
		if write_enaP='1' then
			dec_in <= rcw(1295 downto 0);
		end if;
	end if;
end process;


process (clk,reset) 
variable cnt_clk: std_logic_vector(3 downto 0):="0000";
begin
	if(clk'event and clk ='1') then	
		if (reset = '1') then
		state 	<= aa;
		done 	<='0';
--		read_ena <='0';
		ena_rand <='0'; 
		start_decoder <= '0';
		reset_decoder <= '1';
		cwFailed_sig <= (others => '0');
		Iter_sum_sig <= (others => '0');
		cwTested_sig <= (others => '0');
		rst_r <= '1';
		else 
			case state is
				
				when 	starts => if start='1' then
									done 	<='0';
									state 	<= aa;
									end if;	
				
				when 	aa  =>	rst_r <= '1'; 	state 	<= ab;
				when 	ab	 =>	rst_r <= '0'; 	state 	<= ac;
				when 	ac	 =>	init_r <='1'; 	state 	<= ad;
				when 	ad	 =>	init_r <='1'; 	state 	<= idle;
			
			
			
				when idle =>	if start='1' then
									state 	<= init;
									start_decoder <= '0';
									reset_decoder <= '1';
									write_enaP <='1';		--brk
									write_ena <= '0';
									rst_r <= '0';
									init_r <='0';
									start_r <='1';
									end if;	
									
				when init =>	state 	<= writem;
									write_enaP <='0';		--brk
									write_ena <= '1';
									--start_r <='0';  --brkunl
														
				when writem =>	--read_enaP <='0';
									--read_ena <='1';
									write_enaP <='0'; --brk
									write_ena <= '0';
									ena_rand <='1';
									state 	<= decode;
									init_r <='0';

																				
				when decode =>	write_enaP <='0';
									write_ena <= '0';
									start_decoder <= '1';
									reset_decoder <= '0';
									cnt_clk := cnt_clk+1;
									if decode_done='1' then
									state 	<= statistic;
									start_decoder <= '0';
									reset_decoder <= '1';
									write_enaP <='0';		--brk
									write_ena <= '0';
									cnt_clk:="0000";
									end if;
									if (cnt_clk > 6 ) then
									start_r <='0';
									cnt_clk:="0000";
									end if; 
									
		when statistic => 	cnt_clk:="0000";
									Iter_sum_sig <= Iter_sum_sig + iteration;
									cwTested_sig <= cwTested_sig + '1';
									if(give_up= '1') then
										 cwFailed_sig <= cwFailed_sig + '1';
									end if;
									if(cwFailed_sig = max_iter) then
											  state       <= stop;
									else
											  state       <= idle;
									end if;
									
			when     stop =>  state       <= stop;
									LED_sig     <= '0';
									done 	<='1';
							
									
  			end case;	
		end if;    
   end if;
end process;  




cwFailed <= cwFailed_sig; 
cwTested <= cwTested_sig;


end Behavioral;

