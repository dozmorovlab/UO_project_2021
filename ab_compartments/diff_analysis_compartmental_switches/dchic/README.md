# Differential Analysis for A/B Compartmental Switches
Determine compartmental swtiches between primary and livermet using dcHic (v2).

## Setup
HOMER can be downloaded using the following website:
https://github.com/ay-lab/dcHiC

```
git clone https://github.com/ay-lab/dcHiC
conda env create -f ./packages/dchic.yml
conda activate dchic

cd ./packages
R CMD INSTALL functionsdchic_1.0.tar.gz
```

## Scripts

- 01_dchic.sh
  - Description: There are different types of options to use to run dcHic. This script contains different options, however, the option *analyze* is the analysis of compartmental switches. The option *viz* creates an interactive IGV.html.
  Although the *analyze* ran without errors, the option *subcomp* returned an error.
  - **Input**
    dcHic requires an input file (input.txt) that contains .matrix and .bed files (as described in their GitHub). To create .matrix and .bed files, we used .cool file and converted using their provided script: preprocessing.py 
  - **Output**
    This creates many directories (as described in their GitHub). The following directory contains the files we're interested (output of *analyze*):
    ```
    ./DifferentialResult/PR_vs_LM_50kb/fdr_result/
    ```
    This directory contains differential.intra_sample_combined.Filtered.pcQnm.bedGraph which contains statistically significantly switched compartments (p<0.05) and differential.intra_sample_combined.pcQnm.bedGraph contains all the regions with the corresponding PC values.
    \n
    \n
    The option *viz* creates an IGV HTML file to visualize PC values and the significant regions.
    - intra_igv.html

- 02_abswitch.sh
  - Description: This file takes in the analysis result from dcHic and outputs a pie chart and bar graph of compartmental switches.
  - **Input**
    - The input of this script are the following:
      - differential.intra_sample_combined.Filtered.pcQnm.bedGraph
      - differential.intra_sample_combined.pcQnm.bedGraph
  - **Output**
    - The output of this script are the following:
      - bychromosome_withlegend.png
      - compartment_withlegened.png

## Issues
dcHic is still resulting in an error downstream of the *analyze*. The error occurs at the option *subcomp*, therefore, need to fix this error.
All files are currently hardcoded.
