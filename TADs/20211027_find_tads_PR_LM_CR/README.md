# Find TADs for PR, LM, and CR at Chromosome 1:20000000-80000000
This directory will find the TADs of the merged PR, LM, and CR replicates (1_findtads.sh) and create a visualization (2_pygenometracks.sh).

## Setup
- Download HiCExplorer
  - https://hicexplorer.readthedocs.io/en/latest/content/installation.html
- Download Pygenometracks
  - https://pygenometracks.readthedocs.io/en/latest/content/installation.html

## Scripts

- 1_findtads.sh  
  Description: This script will find TADs using a minimum depth of 150,000 and a maximum depth of 500,000. This will take in the merged PR, LM, and CR .cool files and output a merged_tracks.ini file that contains the information to build a visualization.
  - **Input**
    - This script takes in the PR, LM, and CR .cool files as the input.
    - The following options are required:
      - -p/--prfile  Absolute path to the merged primary.cool file.
      - -l/--lmfile Absolute path to the merged liver metastasis.cool file.
      - -c/--crfile Absolute path to the merged carboplatin resistant.cool file.
      - -o/--outdir Absolute path to the output directory to store output files.
  - **Output**
    - The output of the `1_findtads.sh` will be the following:
      - _boundaries.bed
      - _boundaries.gff
      - _domains.bed
      - _score.bedgraph
      - _tad_score.bm
      - _tracks.ini
      - _zscore_matrix.cool
      - merged_tracks.ini This is a file that will contain all the information on creating a visualization.

- 2_pygenometracks.sh  
  Description: This script create a matrix with TAD domains and TAD scores.
  - **Input**
    - This script takes in the merged_tracks.ini (from 1_findtads.sh).
    - The following options are required:
      - -r/--region Specify the region of the chromosome to observe the TAD domains.
      - -o/--outdir Absolute path to the output directory that stores the merged_tracks.ini
      - -p/--picname  Specify the name of the output plot name
  - **Output**
    - The output is a visualization specified in the option `-p`.

## Usage Example (Command Line)
1_findtads.sh
<br />
```./1_findtads.sh -p=/absolute/path/to/PR/file -l=/absolute/path/to/LM/file -c=/absolute/path/to/CR/file -o=/absolute/output/dir ```
<br />
<br />
2_pygenometracks.sh
<br />
```./2_pygenometracks.sh -r=1:20000000-80000000 -o=/absolute/output/dir -p=hic_tad_chr1:20000000-80000000.png```

## Issues
