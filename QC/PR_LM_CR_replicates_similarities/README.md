# Determine Similarities of the Replicates for PR, LM, and CR Pipeline
This directory will determine the similarities of the replicates for the PR, LM, and CR by finding stratum-adjusted correlation coefficient (SCC) scores (1_hicrep.sh) and using these scores to create an MDS plot (2_20211010_sccheatmap_mds.R)

## Setup
- Download HiCRep using the following website:
  - https://github.com/dejunlin/hicrep

## Scripts

1. 1_hicrep.sh  
  Description: This script will perform pairwise comparisons to determine a stratum-adjusted correlation coefficient (SCC) scores. The script will take .cool file(s) only and return multiple text files with the SCC scores for each chromosome. The command ```hicrep``` will run with the following options: --h 1 and --dBPMax 500000.

2. 2_20211010_sccheatmap_mds.R  
  ###HARDCODED###  
  Description: This script will create a pairwise comparison heatmap using the outputs from 1_hicrep.sh (output files need to be located in the same directory). The heatmap will show how well each samples are correlated with another sample. The script will also output an MDS plot to show the similarities between samples.
  input: .txt file(s) from 1_hicrep.sh  
  output: a heatmap (.jpg) and mds plot (.jpg)

  ## Input 
  - The `1_hicrep.sh` uses .cool file(s) as the input.
  - The following options are required:
    - -d/--directory     Absolute path to the directory containing all the .cool Hi-C files
    - -o/--outdir     Absolute path to the output directory that will contain SCC score .txt files for each chromosomes.
  
  ## Output
  - The output of the `1_hicrep.sh` will result in .txt file(s) that contain SCC scores for each chromosome.
  
## Issues
*`2_20211010_sccheatmap_mds.R` is hardcoded.
