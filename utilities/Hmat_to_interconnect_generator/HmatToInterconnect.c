/* ###########################################################################################################################
## organization         : Reconfigurable Computing Lab, University of Arizona
## file name            : HmatToInterconnect.c
## language             : c (ansi)
## short description    : Converter for H-matrix to VHDL interconnect of decoder
## history              : Created by Md Sahil Hassan
## copyright            : sahilhassan@email.arizona.edu
## ######################################################################################################################## */

#include<stdio.h>
#include<stdlib.h>
#include<math.h>


int main(int argc, char *argv[]){

int N;  // = 1296;
int M;  // = 648;
int dv; // = 4;
int dc; // = 8;
int m,n,k;


// Reading size of Hmat through provided file
FILE *hmatsize;
hmatsize = fopen(argv[1],"r");

fscanf(hmatsize,"%d", &N);
fscanf(hmatsize,"%d", &M);
fscanf(hmatsize,"%d", &dv);
fscanf(hmatsize,"%d", &dc);

// Initializing Matrix data structures
int **Dform, **DVform;
Dform = (int **)calloc(M, sizeof(int *)); 
for (m=0; m<M; m++) Dform[m] = (int *)calloc(dc, sizeof(int));
DVform = (int **) calloc(N, sizeof(int *));
for (n=0; n<N; n++) DVform[n] = (int *) calloc(dc, sizeof(int));

// Initializing Matrix files
FILE *DformFile, *DVformFile;
DformFile = fopen(argv[2],"r"); 
DVformFile = fopen(argv[3],"r");

// Reading Matrix files into Matrix data structure
for (m=0; m<M; m++){
  for (k=0; k<dc; k++)
    fscanf(DformFile, "%d", &Dform[m][k]);
}

for (n=0; n<N; n++){
  for (k=0; k<dv; k++)
    fscanf(DVformFile, "%d", &DVform[n][k]);
}


// Creating output file
FILE *outputfile;
outputfile = fopen(argv[4],"w");


// Generating VN_out_sig to CN_in_sig -- VNU connections serialized
// Need to go over DVform matrix

  // Initialize CNU connection counter array
  int *CN_conn_count;
  CN_conn_count = (int *)calloc(M, sizeof(int));

  for (n=0; n<N; n++){
    for (k=0; k<dv; k++){
      fprintf(outputfile, "CN_in_sig(%d)\t<=\tVN_out_sig(%d);\n", (DVform[n][k]*dc)+CN_conn_count[DVform[n][k]], (n*dv)+k);
      CN_conn_count[DVform[n][k]] ++;
    }
  }

  fprintf(outputfile, "\n\n");

// Generating VN_out_sigd to CN_in_sigd -- VNU connections serialized and replicated between [0,1295]
// Need to go over DVform matrix
  // Initialize CNU connection counter array
  for (m=0; m<M; m++) CN_conn_count[m] = 0; // Resetting CN_conn_count values to 0

  for (n=0; n<N; n++){
    for (k=0; k<dv; k++){
      fprintf(outputfile, "CN_in_sigd(%d)\t<=\tVN_out_sigd(%d);\n", (DVform[n][k]*dc)+CN_conn_count[DVform[n][k]], n);
      CN_conn_count[DVform[n][k]] ++;
    }
  }
  free(CN_conn_count);
  fprintf(outputfile, "\n\n\n");


// Generating VN_in_sig to CN_out_sig -- CNU signals are serialized, VNU matrix are decided based on connection
// Need to go over Dform matrix

  // Initialize VNU connection counter array
  int *VN_conn_count;
  VN_conn_count = (int *)calloc(N, sizeof(int));

  for (m=0; m<M; m++){
    for (k=0; k<dc; k++){
      fprintf(outputfile, "VN_in_sig(%d)\t<=\tCN_out_sig(%d);\n", (Dform[m][k]*dv)+VN_conn_count[Dform[m][k]], (m*dc)+k);
      VN_conn_count[Dform[m][k]]++;
    }
  }
  fprintf(outputfile, "\n\n");
  free(VN_conn_count);

  free(Dform);
  free(DVform);
  fclose(DformFile);
  fclose(DVformFile);
  fclose(outputfile);
  fclose(hmatsize);
  return 0;
}
