# Scripts

1. 1_hicrep.sh  
  ###HARDCODED###  
  Description: This script will run hicrep with options --h 1 and --dBPMax 500000 on multiple .cool files.  
  input: .cool file(s) for running hicrep  
  output: .txt file(s) with stratum-adjusted correlation coefficient (SCC scores) for each chromosomes.  
  
2. 2_hicrep_heatmap.R  
  ###HARDCODED###  
  Description: This script will create a pairwise comparison heatmap using the outputs from 1_hicrep.sh. The heatmap will show how well each samples are correlated with another sample.  
  input: .txt file(s) from 1_hicrep.sh  
  output: a heatmap (.jpg)
