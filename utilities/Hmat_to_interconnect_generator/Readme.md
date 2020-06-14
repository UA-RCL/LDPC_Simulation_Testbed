# H-matrix to VHDL interconnect conversion

This folder contains a C program that converts any H-matrix for Regular Low Density Parity Check (LDPC) code into VHDL signal interconnect, in order to use with our high-throughput simulation testbed.

## Instruction for execution
1. Compile the HmatToInterconnect.c using the following command  
  ```gcc -o hmattointerconnect HmatToInterconnect.c```
2. Execute the generated binary file using the following command and arguments:  
  ```./hmattointerconnect <File-size and degree of decoder> <File- H matrix from CNU perspective> <File- H matrix from VNU perspective> <File name- to write output in vhd>```

  In this case, the execution command looks as-  
  ```./hmattointerconnect IRISC_dv4_R050_L54_N1296_Dform_size IRISC_dv4_R050_L54_N1296_Dform IRISC_dv4_R050_L54_N1296_DVform OUTPUT.vhd```

This should generate an output vhd file containing all signal connections according to the provided Regular H-Matrix in vhdl file format.
This generated vhdl file can be used to replace the connections in 'PGaB.vhd' module.
