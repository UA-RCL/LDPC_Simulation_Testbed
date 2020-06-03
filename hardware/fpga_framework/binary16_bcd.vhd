-- Engineer: Burak UNAL 
-- 
-- Create Date:    
-- Design Name:  Created by Burak UNAL 
-- Project Name: Gallager-B Hard decision Bit-Flipping algorithm
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity binary64_bcd is
    generic(N: positive := 64);
    port(
        clk, reset,start: in std_logic;
        binary_in: in std_logic_vector(N-1 downto 0);
		  doneout: out std_logic;
		  bcd_out: out  STD_LOGIC_VECTOR (79 downto 0)
        --bcd0, bcd1, bcd2, bcd3, bcd4, bcd5, bcd6, bcd7, bcd8, bcd9, bcd10, bcd11, bcd12, bcd13, bcd14, bcd15, bcd16, bcd17, bcd18, bcd19: out std_logic_vector(3 downto 0)
    );
end binary64_bcd ;
 
architecture behaviour of binary64_bcd is
    type states is (idle, starts, shift, done, doneI);
    signal state, state_next: states;
 
    signal binary, binary_next: std_logic_vector(N-1 downto 0);
    signal bcds, bcds_reg, bcds_next: std_logic_vector(79 downto 0);
    -- output register keep output constant during conversion
    signal bcds_out_reg, bcds_out_reg_next: std_logic_vector(79 downto 0);
    -- need to keep track of shifts
    signal shift_counter, shift_counter_next: natural range 0 to N;
	 signal done_sig : std_logic:='0';
begin
 
    process(clk, reset)
    begin
        if reset = '1' then
            binary <= (others => '0');
            bcds <= (others => '0');
            state <= idle;
            bcds_out_reg <= (others => '0');
            shift_counter <= 0;
				--done_sig <='0';
        elsif falling_edge(clk) then
            binary <= binary_next;
            bcds <= bcds_next;
            state <= state_next;
            bcds_out_reg <= bcds_out_reg_next;
            shift_counter <= shift_counter_next;
        end if;
    end process;
 
    convert:
    process(state, binary, binary_in, bcds, bcds_reg, shift_counter,start)
    begin
        
		  state_next <= state;
        bcds_next <= bcds;
        binary_next <= binary;
        shift_counter_next <= shift_counter;
		  done_sig <='0';
 
        case state is
				when idle =>
					done_sig <='0';
					if start='1' then
						state_next <= starts;
					end if;
            when starts =>
                state_next <= shift;
                binary_next <= binary_in;
                bcds_next <= (others => '0');
                shift_counter_next <= 0;
					 done_sig <='0';
            when shift =>
                if shift_counter = N then
                    state_next <= done;
						  --done_sig <='1';
                else
                    binary_next <= binary(N-2 downto 0) & 'L';
                    bcds_next <= bcds_reg(78 downto 0) & binary(N-1);
                    shift_counter_next <= shift_counter + 1;
						  done_sig <='0';
                end if;
            when done =>
                --state_next <= idle;
					 state_next <= doneI;
					 done_sig <='1';
				when doneI =>
                --state_next <= idle;
					 state_next <= doneI;
					 done_sig <='0';
        end case;
    end process;



	 bcds_reg(79 downto 76) <= bcds( 79 downto 76 ) + 3 when bcds( 79 downto 76 ) > 4 else
                            bcds( 79 downto 76 );
	 bcds_reg(75 downto 72) <= bcds( 75 downto 72 ) + 3 when bcds( 75 downto 72 ) > 4 else
                            bcds( 75 downto 72 );
	 bcds_reg(71 downto 68) <= bcds( 71 downto 68 ) + 3 when bcds( 71 downto 68 ) > 4 else
                            bcds( 71 downto 68 );
	 bcds_reg(67 downto 64) <= bcds( 67 downto 64 ) + 3 when bcds( 67 downto 64 ) > 4 else
                            bcds( 67 downto 64 );
	 bcds_reg(63 downto 60) <= bcds(63 downto 60) + 3 when bcds( 63 downto 60 ) > 4 else
                            bcds( 63 downto 60 );
	 bcds_reg(59 downto 56) <= bcds( 59 downto 56 ) + 3 when bcds( 59 downto 56 ) > 4 else
                            bcds( 59 downto 56 );
	 bcds_reg(55 downto 52) <= bcds( 55 downto 52 ) + 3 when bcds( 55 downto 52 ) > 4 else
                            bcds( 55 downto 52 );
	 bcds_reg(51 downto 48) <= bcds( 51 downto 48 ) + 3 when bcds( 51 downto 48 ) > 4 else
                            bcds( 51 downto 48 );
	 bcds_reg(47 downto 44) <= bcds( 47 downto 44 ) + 3 when bcds( 47 downto 44 ) > 4 else
                            bcds( 47 downto 44 );
	 bcds_reg(43 downto 40) <= bcds( 43 downto 40 ) + 3 when bcds( 43 downto 40 ) > 4 else
                            bcds( 43 downto 40 );		
									 
    bcds_reg(39 downto 36) <= bcds(39 downto 36) + 3 when bcds(39 downto 36) > 4 else
                            bcds(39 downto 36);
    bcds_reg(35 downto 32) <= bcds(35 downto 32) + 3 when bcds(35 downto 32) > 4 else
                            bcds(35 downto 32);
	 bcds_reg(31 downto 28) <= bcds(31 downto 28) + 3 when bcds(31 downto 28) > 4 else
                            bcds(31 downto 28);
	 bcds_reg(27 downto 24) <= bcds(27 downto 24) + 3 when bcds(27 downto 24) > 4 else
                            bcds(27 downto 24);
	 bcds_reg(23 downto 20) <= bcds(23 downto 20) + 3 when bcds(23 downto 20) > 4 else
                            bcds(23 downto 20);
									 
    bcds_reg(19 downto 16) <= bcds(19 downto 16) + 3 when bcds(19 downto 16) > 4 else
                              bcds(19 downto 16);
    bcds_reg(15 downto 12) <= bcds(15 downto 12) + 3 when bcds(15 downto 12) > 4 else
                              bcds(15 downto 12);
    bcds_reg(11 downto 8) <= bcds(11 downto 8) + 3 when bcds(11 downto 8) > 4 else
                             bcds(11 downto 8);
    bcds_reg(7 downto 4) <= bcds(7 downto 4) + 3 when bcds(7 downto 4) > 4 else
                            bcds(7 downto 4);
    bcds_reg(3 downto 0) <= bcds(3 downto 0) + 3 when bcds(3 downto 0) > 4 else
                            bcds(3 downto 0);
 
    bcds_out_reg_next <= bcds when state = done else
                         bcds_out_reg;
	 
	 
	 bcd_out <= bcds_out_reg; --: out  STD_LOGIC_VECTOR (39 downto 0)
	 doneout <=done_sig;
 
end behaviour;


