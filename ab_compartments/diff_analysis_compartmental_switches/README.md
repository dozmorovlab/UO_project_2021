# Differential Analysis for A/B Compartmental Switches
Determine compartmental swtiches between primary and livermet using HOMER.

## Setup
HOMER can be downloaded using the following website:
http://homer.ucsd.edu/homer/introduction/install.html

In general, followed http://homer.ucsd.edu/homer/interactions2/quickndirty.html to use HOMER. \n
For finding A/B compartments, followed a more detailed outline: http://homer.ucsd.edu/homer/interactions2/HiCpca.html

## Scripts

- 01_homer.sh
  Description: This script starts with .bam files of primary (PR) and livermet (LM) and runs HOMER to find correlation difference between the A and B compartments of PR and LM.
  - The script is hardcoded!!
  1. .bam files are subsampled 25%
  2. subsampled .bam files are extracted for forward and reverse reads
  3. forward and reverse reads .bam files are converted to .sam files
  4. forward and reverse reads .sam files are used to create TagDirectory (required for HOMER)
  5. Using the TagDirectory, analyzed the files (analyzeHiC), performed PC analysis (runHiCpca.pl), merged all bedGraphs (annotatePeaks.pl), and found compartments (findHiCCompartments.pl)
  6. Found correlation difference (getHiCcorrDiff.pl)
      - Problem: there is no correlation difference between PR and LM eigenvector files.
- 02_bam_split_paired_end.sh
  Description: This file is called in 01_homer.sh. This script takes .bam file and splits into forward and reverse reads for paired-end sequencing.
  - **Output**
    - The output of this script will be the following:
      - _fwd1.bam
      - _fwd2.bam
      - _fwd.bam
      - _fwd1_sorted.bam
      - _fwd2_sorted.bam
      - _fwd_sorted.bam
      - _rev1.bam
      - _rev2.bam
      - _rev.bam
      - _rev1_sorted.bam
      - _rev2_sorted.bam
      - _fwd_sorted.bam
    - WANT TO USE _fwd_sorted.bam and _fwd_sorted.bam

## Usage Example (Command Line)
Running annotatePeaks.pl results in PC1 bedGraph (can be found in output directory: UO_project_2021/ab_compartments/diff_analysis_compartmental_switches/output).
Running getHiCcorrDiff.pl results in correlation difference values (bedGraph) (can be found in output directory: UO_project_2021/ab_compartments/diff_analysis_compartmental_switches/output).
Use UCSC Genome Browser to load the bedGraphs and visualize the bedGraph. (website:https://genome.ucsc.edu/goldenPath/help/customTrack.html)

## Issues
The script is currently hardcoded. getHiCcorrDiff.pl is resulting a .bedGraph with correlation difference, however, it is not finding any correlation difference between PR and LM. Need to update.
Possible solution: re-subsample PR.bam and LM.bam files to be equal in size.
