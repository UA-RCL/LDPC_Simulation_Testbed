This folder includes VHDL source code for FPGA based framework to simulate LDPC decoders on the Zedboard. 
The source code consists of seven files (units): testbedbrk.vhd, bram_baseline.vhd, encoder.vhd, PGaB.vhd, 
binary16_bcd.vhd, PmodOLEDCtrl.vhd, and constrains.ucf. 

The testbedbrk.vhd is the top module and it consists of encoder to generate codeword (encoder.vhd), 
Probilistic Gallager B LDPC decoder (PGaB.vhd), binary to decimal convertor (binary_16_bcd.vhd), 
and OLED screen driver (PmodOLEDCtrl.vhd). 

The input parameters are the following; start, reset, reset_led, P1, P2, P3, alpha_sw. 

The end-user sets the channel crossover probability (alpha) to start simulation. 
14 bits input value should be entered for desired alpha. 14 bits binary number is 
compared to 16 bits data (‘11111111 1111111’, 32767 in decimal) stored on the FPGA. 
For example, if we want to run simulation for alpha value of 0.01, 14 bits input value is set to ‘0000010 1000111’ 
(1% of 32767, 327 = 0.01 *  32767). Here is the summary of the calculation;

Alpha = x/y. 
‘x’ is user input. 
‘y’ is 15 bits data (‘11111111 1111111’) stored on the FPGA.
Let’s set alpha to 0.01;
0.01 = x/32767 x = 327 (which is ‘0000010 1000111’ in binary)   

By using 7 switches on the Zedboard, the 14 bits input value (alpha) can be entered. 
Once we set the switches to 7 (SW7 – SW1 on the zedboard) LSB of the 14 bits (‘0000010’ for our example), 
we need to push BTNL (P1). 7 MSB bits of 14 data (‘1000111’) is stored by pushing BTNR (P2) button. 
After setting alpha value, we use switch SW0 (start) to star the simulation. LD0 (done) turns on once the simulation is completed. 
OLED screen display the number of tested frames and the number of frame in error when the button BTNU (reset_led) is pressed.     






-------------------------testbedbrk file structure------------------

testbedbrk.vhd
	baseline.vhd
		encoder
			reg_unit
		PGaB.vhd
			VNU.vhd
			CNU.vhd
			random_numb.vhd
	binary16_bcd.vhd 
	binary16_bcd.vhd
	OLEDCtrl.vhd
		OledInit.vhd
		OledExample.vhd
		charLib
	constrains.ucf 


			


