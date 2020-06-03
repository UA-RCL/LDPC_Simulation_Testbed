----------------------------------------------------------------------------------
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library IEEE;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CNU is
    Port (
		--Alpha messages from VNU to CNU
		--ena_cnu : std_logic;
		v2c_1    	: in STD_LOGIC; 
		v2c_2 	   : in STD_LOGIC;
		v2c_3    	: in STD_LOGIC;
		v2c_4 	   : in STD_LOGIC;
		v2c_5 	   : in STD_LOGIC;
		v2c_6 	   : in STD_LOGIC;
		v2c_7 	   : in STD_LOGIC;
		v2c_8 	   : in STD_LOGIC;
		v2c_d 	   : in STD_LOGIC_VECTOR(7 downto 0);
		c2v1 		: out STD_LOGIC;
		c2v2 		: out STD_LOGIC;
		c2v3 		: out STD_LOGIC;
		c2v4 		: out STD_LOGIC;
		c2v5 		: out STD_LOGIC;
		c2v6 		: out STD_LOGIC;
		c2v7 		: out STD_LOGIC;
		c2v8 		: out STD_LOGIC;
		c2v 		: out STD_LOGIC
		--c2v 		: out std_logic_vector(4 downto 0)
		);
end CNU;

architecture Behavioral of CNU is

signal temp1 		: STD_LOGIC; --:='0';
signal temp2 		: STD_LOGIC; --:='0';
signal temp3 		: STD_LOGIC; --:='0';
signal temp4 		: STD_LOGIC; --:='0';
signal temp5 		: STD_LOGIC; --:='0';
signal temp6 		: STD_LOGIC; --:='0';
signal temp7 		: STD_LOGIC; --:='0';
signal temp8 		: STD_LOGIC; --:='0';
signal temp 		: STD_LOGIC; --:='0';
signal tempx 		: STD_LOGIC; --:='0';

begin
 -- Calculating the Sign

 tempx<=v2c_1 XOR v2c_2 XOR v2c_3 XOR v2c_4 XOR v2c_5 XOR v2c_6 XOR v2c_7 XOR v2c_8;


 temp1 <= tempx xor v2c_1;
 temp2 <= tempx xor v2c_2;
 temp3 <= tempx xor v2c_3;
 temp4 <= tempx xor v2c_4;
 temp5 <= tempx xor v2c_5;
 temp6 <= tempx xor v2c_6;
 temp7 <= tempx xor v2c_7;
 temp8 <= tempx xor v2c_8;
 temp <=  v2c_d(0) XOR v2c_d(1) XOR v2c_d(2) XOR v2c_d(3) XOR v2c_d(4) XOR v2c_d(5) XOR v2c_d(6) XOR v2c_d(7);
 

 c2v1 <=temp1;
 c2v2 <=temp2;
 c2v3 <=temp3;
 c2v4 <=temp4;
 c2v5 <=temp5;
 c2v6 <=temp6;
 c2v7 <=temp7;
 c2v8 <=temp8;
 c2v <=temp;
	  
end Behavioral;
