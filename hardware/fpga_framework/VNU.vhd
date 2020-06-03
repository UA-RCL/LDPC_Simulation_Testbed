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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity VNU is
    Port (
		ena         	: in std_logic;
		clk         	: in std_logic;
		data_load       : in std_logic;				-- Data from channel will be loaded to internal register when
		
		recei_data 		: in STD_LOGIC; 
		c2v 	   		: in std_logic_vector (3 downto 0);
		RN					: in std_logic;
		count_iter		: in std_logic;
		sum_out			: out STD_LOGIC; -- _VECTOR (2 downto 0);
		VNU_out1  	 	: out STD_LOGIC;
		VNU_out2  	 	: out STD_LOGIC;
		VNU_out3  	 	: out STD_LOGIC;
		VNU_out4  	 	: out STD_LOGIC
		
		);
end VNU;

architecture Behavioral of VNU is


signal Sum1	: std_logic;
signal recei_d_xor	: std_logic;
signal vnu_out_sig : std_logic_vector(3 downto 0); --:="000";
signal vnu_out_reg : std_logic_vector(3 downto 0); --:="000";  
signal vnu_out_reg2 : std_logic_vector(3 downto 0); --:="000";  
signal decide	: std_logic;
signal deter	: std_logic;

begin 
 
recei_d_xor <= recei_data; 
deter <= RN and count_iter;


vnu_out_reg(0) <= (recei_d_xor and c2v(3)) or (recei_d_xor and c2v(2)) or (recei_d_xor and c2v(1)) or (c2v(1) and c2v(2) and c2v(3));

vnu_out_reg(1) <= (recei_d_xor and c2v(3)) or (recei_d_xor and c2v(2)) or (recei_d_xor and c2v(0)) or (c2v(0) and c2v(2) and c2v(3));

vnu_out_reg(2) <= (recei_d_xor and c2v(3)) or (recei_d_xor and c2v(1)) or (recei_d_xor and c2v(0)) or (c2v(0) and c2v(1) and c2v(3));
vnu_out_reg(3) <= (recei_d_xor and c2v(2)) or (recei_d_xor and c2v(1)) or (recei_d_xor and c2v(0)) or (c2v(0) and c2v(1) and c2v(2));


vnu_out_reg2(0) <= (c2v(2) and c2v(3)) or (c2v(1) and c2v(3)) or (c2v(1) and c2v(2)) ;
vnu_out_reg2(1) <= (c2v(2) and c2v(3)) or (c2v(0) and c2v(3)) or (c2v(0) and c2v(2)) ;
vnu_out_reg2(2) <= (c2v(1) and c2v(3)) or (c2v(0) and c2v(3)) or (c2v(0) and c2v(1)) ;
vnu_out_reg2(3) <= (c2v(1) and c2v(2)) or (c2v(0) and c2v(2)) or (c2v(0) and c2v(1)) ;
 
	
VNU_out1<=vnu_out_sig(0);
VNU_out2<=vnu_out_sig(1);
VNU_out3<=vnu_out_sig(2);
VNU_out4<=vnu_out_sig(3);

sum_out <= decide;
Sum1<= (c2v(1) and c2v(2) and c2v(3)) or (c2v(0) and c2v(2) and c2v(3)) or (c2v(0) and c2v(1) and c2v(3)) or (c2v(0) and c2v(1) and c2v(2)) or (recei_d_xor and c2v(2) and c2v(3)) or (recei_d_xor and c2v(1) and c2v(3)) or (recei_d_xor and c2v(1) and c2v(2)) or (recei_d_xor and c2v(0) and c2v(3)) or (recei_d_xor and c2v(0) and c2v(2)) or (recei_d_xor and c2v(0) and c2v(1));  

process (ena,clk,deter) 
 begin  

  if (clk'event and clk='1') then
		if(ena='0') then 	
		vnu_out_sig <= vnu_out_sig;
		else 
			if data_load = '0' then 
			decide	<= recei_d_xor;
			vnu_out_sig <= recei_d_xor & recei_d_xor & recei_d_xor & recei_d_xor;
			
			else
				if ('1' = deter)then
				decide	<= Sum1;
				vnu_out_sig <= vnu_out_reg2;
				else
				decide	<= Sum1;
				vnu_out_sig <= vnu_out_reg;
				end if;
		   end if; 
		end if;
	end if;

end process;
end Behavioral;