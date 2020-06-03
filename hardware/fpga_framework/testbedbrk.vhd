----------------------------------------------------------------------------------
-- Company: 
-- Create Date:    18:26:44 03/04/2017 
-- Design Name: 
-- Module Name:    testbedbrk - Behavioral 

-- Engineer: Burak UNAL 
-- 
-- Create Date:    
-- Design Name:  Created by Burak UNAL 
-- Project Name: FPGA based Framework for Probabilistic Gallager-B Hard decision Bit-Flipping algorithm
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

entity testbedbrk is
    Port ( 	clk : in std_logic;
				start : in std_logic;
				reset : in std_logic;
				reset_led : in std_logic;
				P1 : in std_logic;
				P2 : in std_logic;
				P3 : in std_logic;
				alpha_sw  : in std_logic_vector (6 downto 0);
				--max_iter_sw  : in std_logic_vector (6 downto 0);
				done : out std_logic;
				SDIN	: out STD_LOGIC;
				SCLK	: out STD_LOGIC;
				DC		: out STD_LOGIC;
				RES	: out STD_LOGIC;
				VBAT	: out STD_LOGIC;
				VDD	: out STD_LOGIC	
			   );
end testbedbrk;

architecture Behavioral of testbedbrk is

COMPONENT baseline is
    Port ( 	clk : in std_logic;
				start : in std_logic;
				reset : in std_logic;
				alpha  : in std_logic_vector (14 downto 0);
				max_iter  : in std_logic_vector (15 downto 0); 
				done : out std_logic;	
				cwFailed : out std_logic_vector (63 downto 0);
				cwTested : out std_logic_vector (63 downto 0)	
			   );
end COMPONENT;

COMPONENT binary64_bcd is
    generic(N: positive := 64);
    port(
        clk, reset,start: in std_logic;
        binary_in: in std_logic_vector(N-1 downto 0);
		  doneout: out std_logic;
        bcd_out: out  STD_LOGIC_VECTOR (79 downto 0)
	 );
end COMPONENT;

COMPONENT OLEDCtrl is
	Port ( 
		CLK 	: in  STD_LOGIC;
		RST 	: in	STD_LOGIC;
		cwFailed : in std_logic_vector (63 downto 0);
		cwTested : in std_logic_vector (63 downto 0);
		SDIN	: out STD_LOGIC;
		SCLK	: out STD_LOGIC;
		DC		: out STD_LOGIC;
		RES	: out STD_LOGIC;
		VBAT	: out STD_LOGIC;
		VDD	: out STD_LOGIC);
end COMPONENT;

signal d_done	: STD_LOGIC;
signal cw_tested	: STD_LOGIC_VECTOR(63 downto 0);
signal cw_failed	: STD_LOGIC_VECTOR(63 downto 0);

signal bcd_done	: STD_LOGIC;
signal bcd_done_f	: STD_LOGIC;
signal bcd_out_test	: STD_LOGIC_vector(79 downto 0);
signal bcd_out_fail	: STD_LOGIC_vector(79 downto 0);
signal bcd_reset	: STD_LOGIC;

signal led_in_test	: STD_LOGIC_vector(63 downto 0);
signal led_in_fail	: STD_LOGIC_vector(63 downto 0);

signal alpha_reg	: STD_LOGIC_vector(14 downto 0):=(others => '0');
signal max_iter_reg	: STD_LOGIC_vector(15 downto 0):="0000000001100100";

begin

bcd_reset <= not d_done;
led_in_test <= bcd_out_test(63 downto 0);
led_in_fail <= bcd_out_fail(63 downto 0);

done <= d_done;

process(clk, P1, P2, P3)
begin
if(rising_edge(clk)) then
if(P3 = '0') then
	if(P1 = '1') then
		alpha_reg(6 downto 0) <=alpha_sw;
		alpha_reg(14) <='0';
	end if;
		if(P2 = '1') then
		alpha_reg(13 downto 7) <=alpha_sw;
		alpha_reg(14) <='0';
	end if;
end if;
end if;	
end process;  


process(clk, P1, P2, P3)
begin
if(rising_edge(clk)) then
if(P3 = '1') then
	if(P1 = '1') then
		max_iter_reg(6 downto 0) <=alpha_sw;
		max_iter_reg(15 downto 14) <="00";
	end if;
		if(P2 = '1') then
		max_iter_reg(13 downto 7) <=alpha_sw;
		max_iter_reg(15 downto 14) <="00";
	end if;
end if;	
end if;	
end process; 


ldpc: baseline 
    Port map( 	clk => clk , -- : in std_logic;
				start => start , -- : in std_logic;
				reset =>  reset, -- : in std_logic;
				alpha  => alpha_reg, --: in std_logic_vector (14 downto 0);
				max_iter => max_iter_reg, 
				done =>  d_done, -- : out std_logic;	
				cwFailed => cw_failed , -- : out std_logic_vector (63 downto 0);
				cwTested => cw_tested  -- : out std_logic_vector (63 downto 0);	
			   );

bcd64_t: binary64_bcd 
    generic map(N => 64)
    port map (
        clk =>  clk, -- , 
		  reset =>  bcd_reset, -- ,
		  start =>  d_done, --  : in std_logic;
        binary_in=>  cw_tested, --  : in std_logic_vector(N-1 downto 0);
		  doneout =>  bcd_done, --  : out std_logic;
        bcd_out=>   bcd_out_test-- 
		  --bcd1, bcd2, bcd3, bcd4,bcd5,bcd6, bcd7, bcd8, bcd9, bcd10, bcd11, bcd12, bcd13, bcd14, bcd15, bcd16, bcd17, bcd18, bcd19: out std_logic_vector(3 downto 0)
    );
bcd64_f: binary64_bcd 
    generic map(N => 64)
    port map (
        clk =>  clk, -- , 
		  reset =>  bcd_reset, -- ,
		  start =>  d_done, --  : in std_logic;
        binary_in=>  cw_failed, --  : in std_logic_vector(N-1 downto 0);
		  doneout =>  bcd_done_f, --  : out std_logic;
        bcd_out=>   bcd_out_fail-- 
		  --bcd1, bcd2, bcd3, bcd4,bcd5,bcd6, bcd7, bcd8, bcd9, bcd10, bcd11, bcd12, bcd13, bcd14, bcd15, bcd16, bcd17, bcd18, bcd19: out std_logic_vector(3 downto 0)
    );

Led:  OLEDCtrl
	Port map ( 
		CLK 	=>  clk, -- : in  STD_LOGIC;
		RST 	=>  reset_led, --bcd_done, -- : in	STD_LOGIC;
		cwFailed =>  led_in_fail, -- : in std_logic_vector (63 downto 0);
		cwTested =>  led_in_test, -- : in std_logic_vector (63 downto 0);
		SDIN	=>  SDIN, -- : out STD_LOGIC;
		SCLK	=>  SCLK, -- : out STD_LOGIC;
		DC		=>  DC, -- : out STD_LOGIC;
		RES	=>  RES, -- : out STD_LOGIC;
		VBAT	=>  VBAT, -- : out STD_LOGIC;
		VDD	=>  VDD -- : out STD_LOGIC);
    );		
		
end Behavioral;

