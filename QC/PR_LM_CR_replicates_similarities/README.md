# Scripts

1. 1_hicrep.sh  
  ###HARDCODED###  
  Description: This script will run hicrep with options --h 1 and --dBPMax 500000 on multiple .cool files.  
  input: .cool file(s) for running hicrep  
  output: .txt file(s) with stratum-adjusted correlation coefficient (SCC scores) for each chromosomes.  
  
2. 2_20211010_sccheatmap_mds.R  
  ###HARDCODED###  
  Description: This script will create a pairwise comparison heatmap using the outputs from 1_hicrep.sh (output files need to be located in the same directory). The heatmap will show how well each samples are correlated with another sample. The script will also output an MDS plot to show the similarities between samples.
  input: .txt file(s) from 1_hicrep.sh  
  output: a heatmap (.jpg) and mds plot (.jpg)
