
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_unit is
    Port ( 	clk			: in	STD_LOGIC;
			rst			: in	STD_LOGIC;
			init			: in	STD_LOGIC;
			start		: in	STD_LOGIC;
			data_init	:in std_logic_vector(149 downto 0);
			threshold	:in std_logic_vector(14 downto 0);           
           ran_bit			: out	STD_LOGIC);
end reg_unit;

architecture rtl of reg_unit is


signal reg3 : std_logic_vector (2 downto 0);
signal reg4 : std_logic_vector (3 downto 0);
signal reg5 : std_logic_vector (4 downto 0);
signal reg6 : std_logic_vector (5 downto 0);
signal reg7 : std_logic_vector (6 downto 0);
signal reg8 : std_logic_vector (7 downto 0);
signal reg9 : std_logic_vector (8 downto 0);
signal reg10 : std_logic_vector (9 downto 0);
signal reg11 : std_logic_vector (10 downto 0);
signal reg12 : std_logic_vector (11 downto 0);
signal reg13 : std_logic_vector (12 downto 0);
signal reg14 : std_logic_vector (13 downto 0);
signal reg15 : std_logic_vector (14 downto 0);
signal reg16 : std_logic_vector (15 downto 0);
signal reg17 : std_logic_vector (16 downto 0);

signal temp_reg3: std_logic;
signal temp_reg4: std_logic;
signal temp_reg5: std_logic;
signal temp_reg6: std_logic;
signal temp_reg7: std_logic;
signal temp_reg8: std_logic;
signal temp_reg9: std_logic;
signal temp_reg10: std_logic;
signal temp_reg11: std_logic;
signal temp_reg12: std_logic;
signal temp_reg13: std_logic;
signal temp_reg14: std_logic;
signal temp_reg15: std_logic;
signal temp_reg16: std_logic;
signal temp_reg17: std_logic;


signal random_word : std_logic_vector(14 downto 0);
signal ran_bit_sig: std_logic;



begin


random_word <= reg17(16)&reg16(15)&reg15(14)&reg14(13)&reg13(12)&reg12(11)&reg11(10)&reg10(9)&reg9(8)&reg8(7)&reg7(6)&reg6(5)&reg5(4)&reg4(3)&reg3(2);
ran_bit_sig <= '1' when random_word <= threshold else '0';

temp_reg3 <= reg3(2) xor reg3(1);
temp_reg4 <= reg4(3) xor reg4(2);
temp_reg5 <= reg5(4) xor reg5(3);
temp_reg6 <= reg6(5) xor reg6(4);
temp_reg7 <= reg7(6) xor reg7(5);
temp_reg8 <= reg8(7) xor reg8(6);
temp_reg9 <= reg9(8) xor reg9(7);
temp_reg10 <= reg10(9) xor reg10(8);
temp_reg11 <= reg11(10) xor reg11(9);
temp_reg12 <= reg12(11) xor reg12(10);
temp_reg13 <= reg13(12) xor reg13(11);
temp_reg14 <= reg14(13) xor reg14(12);
temp_reg15 <= reg15(14) xor reg15(13);
temp_reg16 <= reg16(15) xor reg16(14);
temp_reg17 <= reg17(16) xor reg17(15);

process(clk)
begin
	if clk'event and clk = '1' then
		if rst = '1' then			
			reg3  <="000";
			reg4  <="0000"; 
			reg5  <="00000";
			reg6  <="000000";
			reg7  <="0000000";
			reg8  <="00000000"; 
			reg9  <="000000000";
			reg10 <="0000000000";
			reg11 <="00000000000";
			reg12 <="000000000000";
			reg13 <="0000000000000";
			reg14 <="00000000000000";
			reg15 <="000000000000000";
			reg16 <="0000000000000000";
			reg17 <="00000000000000000";
		elsif init='1' then
			reg3  <= data_init(2 downto 0);
			reg4  <= data_init(6 downto 3);
			reg5  <= data_init(11 downto 7);
			reg6  <= data_init(17 downto 12);
			reg7  <= data_init(24 downto 18);
			reg8  <= data_init(32 downto 25);
			reg9  <= data_init(41 downto 33);
			reg10 <= data_init(51 downto 42);
			reg11 <= data_init(62 downto 52);
			reg12 <= data_init(74 downto 63);
			reg13 <= data_init(87 downto 75);
			reg14 <= data_init(101 downto 88);
			reg15 <= data_init(116 downto 102);
			reg16 <= data_init(132 downto 117);
			reg17 <= data_init(149 downto 133);
		elsif start= '1' then	
			reg3  <= reg3(1 downto 0)& temp_reg3;
			reg4  <= reg4(2 downto 0)& temp_reg4;
			reg5  <= reg5(3 downto 0)& temp_reg5;
			reg6  <= reg6(4 downto 0)& temp_reg6;
			reg7  <= reg7(5 downto 0)& temp_reg7;
			reg8  <= reg8(6 downto 0)& temp_reg8;
			reg9  <= reg9(7 downto 0)& temp_reg9;
			reg10  <= reg10(8 downto 0)& temp_reg10;
			reg11  <= reg11(9 downto 0)& temp_reg11;
			reg12  <= reg12(10 downto 0)& temp_reg12;
			reg13  <= reg13(11 downto 0)& temp_reg13;
			reg14  <= reg14(12 downto 0)& temp_reg14;
			reg15  <= reg15(13 downto 0)& temp_reg15;
			reg16  <= reg16(14 downto 0)& temp_reg16;
			reg17  <= reg17(15 downto 0)& temp_reg17;
			

		end if;
	end if;
end process;
ran_bit <= ran_bit_sig;

end rtl;
