# The input parameters are the following
# Command to use for running the  decoder with any code (matrix).
# Input matrix file name.  
# SimulationResults.txt contains some results (base line) of 
# simulation for Tanner code, IRISC dv3 or IRISC dv4 etc...

./GaB MatrixFileName ResultFileName

# How to compile:
gcc -o PGaB PGaB.c -lm

# And here is an example:
./GaB Mat_dv3dc5_155_93_Right GaB_Res_Tanner
./GaB IRISC_dv4_R050_L54_N1296_Dform IRISC_dv4_R050_L54_N1296_Dform_Res


# For the beginning, we need to run simulation for alpha
# from 0.06 to 0.02 with the step of 0.01 for IRISC_dv4_R050_L54_N1296.
# For CodeDolecek_dv4_dc28_N2212_R0857_L79_QC, from 0.006 to 0.002
# with the step of 0.001.
