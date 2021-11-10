# Find TADs for PR, LM, and CR at Chromosome 1:20000000-80000000
This directory will find the TADs of the merged PR, LM, and CR replicates (1_findtads.sh) and create a visualization (2_pygenometracks.sh).

## Setup
- Download HiCExplorer
  - https://hicexplorer.readthedocs.io/en/latest/content/installation.html
- Download Pygenometracks
  - https://pygenometracks.readthedocs.io/en/latest/content/installation.html

## Scripts

- 1_findtads.sh  
  Description: This script will find TADs.
  - **Input**
    - This script takes in the directory that contains .cool file(s) as the input.
    - The following options are required:
      - -d/--directory  Absolute path to the directory containing all the .cool Hi-C files
      - -o/--outdir Absolute path to the output directory that will contain SCC score .txt files for each chromosomes.
  - **Output**
    - The output of the `1_hicrep.sh` will result in .txt file(s) that contain SCC scores for each chromosome.

- 2_20211010_sccheatmap_mds.R  
  ###HARDCODED###  
  Description: This script will create a pairwise comparison heatmap and an MDS plot using the outputs from 1_hicrep.sh (these files need to be located in the same directory). The plots can be used to determine how similar the replicates are. 
  - **Input**
    - This script takes in the .txt file(s) from 1_hicrep.sh
  - **Output**
    - The output is a heatmap (.jpg) and an MDS plot (.jpg).

## Usage Example (Command Line)
1_hicrep.sh
<br />
```./1_hicrep.sh -d=/absolute/dir/path -o=/absolute/output/dir ```
<br />
<br />
2_20211010_sccheatmap_mds.R
<br />
```./2_20211010_sccheatmap_mds.R```

## Issues
2_20211010_sccheatmap_mds.R is hardcoded.
