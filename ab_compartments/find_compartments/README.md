# Find A/B Compartments for Chromosome 20
We will visualize eigenvectors with gene desntiy to determine A/B compartments (ab_compartments_hc.R).

## Setup
The following packages will be used in R:
- TxDb.Hsapiens.UCSC.hg38.knownGene
- karyoploteR
- tidyverse
- optparse (will incorporate in the future)

## Scripts

- ab_compartments_hc.R
  Description: This script will visualize eigenvectors from PC1 and PC2 and will plot gene density (hg38).
  - The script is hardcoded!!
  - (will incorporate in the future: **Input** )
    - I would like the script to take in bedGraph of PC1 and PC2.
    - The following options would be required:
      - -o/--pcaone  Absolute path to PC1 bedGraph file.
      - -t/--pcatwo  Absolute path to PC2 bedGraph file.
      - -c/--chromosome Specify the chromosome of interest. Ex: 1, 2, 3, ... X, Y
      - -p/--picname  Name of the output file. Ex: chr20_lm_pca1_pca2_1.png
  - **Output**
    - The output of this script will be the following:
      - .png file for visualizing eigenvectors with gene density.

## Usage Example (Command Line)
Will update in the future

## Issues
The script is currently hardcoded. Need to update.
