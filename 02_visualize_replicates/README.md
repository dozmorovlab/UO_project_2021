# Replicate Quality Analysis

## Table of Contents
1. [Introduction](#introduction)
2. [Directory Structure](#directory-structure)
3. [Setup](#setup)

## Introduction

Here we perform exploratory analysis of sequenced tumor cells. The samples were collected from patient-derived xenograft (PDX) models and are characterized as either Carboplatin resistant, livermetastic or primary tumors. Technical replicates were already removed and stored in Juicer 'long format' files, and were compiled into primary contact matrices also using Juicer. These contact matrices (known has hi-c files(.hic)), can be used as input for a variety of analytical tools that have been created in the last decade. 

Ideally, replicates in each group will be similar to each other. Previous research shows that drug resistant and metastatic tumors will have modified three-dimensional changes in their chromatin, so we expect groups to be separate from each other. We can measure differences in replicates using Principle Component Analysis, which the package FAN-C has an implementation for hic-matrices. This statistical analysis is ideal to maintain data integrity while also reducing the dimensions in our data to see similarity of replicates in each group and differences between groups. Additionally, we use multidimensional scaling to measure distances between our replicates to measure similarities.

## Directory Structure
```
¦   directory.txt
¦   environment.yml
¦   README.md
¦   
+---distance_decay
¦   ¦   distance_decay.sh
¦   ¦   environment.yml
¦   ¦   README.md
¦   ¦   
¦   +---plots
¦   ¦       distance_decay_CR.png
¦   ¦       distance_decay_LiverMet.png
¦   ¦       distance_decay_primary.png
¦   ¦       
¦   +---scripts
¦           cool_converter.sh
¦           hicPlotDistVsCounts.sh
¦           
+---MDS
¦       calc_scc.sh
¦       environment.yaml
¦       README.md
¦       
+---PCA
¦   ¦   pca.sh
¦   ¦   README.md
¦   ¦   requirements.txt
¦   ¦   samples.csv
¦   ¦   
¦   +---my_out
¦   ¦       136346.pca
¦   ¦       136346.png
¦   ¦       
¦   +---my_out2
¦   ¦       140289.pca
¦   ¦       140289.png
¦   ¦       
¦   +---output
¦           week1.pca
¦           week1.png
¦           
+---PR_LM_CR_replicates_similarities
¦   ¦   1_hicrep.sh
¦   ¦   2_20211010_sccheatmap_mds.R
¦   ¦   README.md
¦   ¦   
¦   +---output
¦           qc_mds_pr_lm_cr.jpg
¦           scc_heatmap_pr_lm_cr.jpg
¦           
+---StratumAdjustedCorrelationCoefficients
        1_hicrep.sh
        2_hicrep_heatmap.R
        README.md
        scc_heatmap.jpg
```

## Hicrep

This folder contains a script using `hicrep` to calculate stratum correlation coefficients. Additionally, these are plotted in a heatmap. Ideally, replicates will be similar with each other, and different from replicates of different samples. 

## Distance Decay

This directory contains scripts to calculate distance decay plots. These plots show that as genomic distance increases between two points, the interactions between those points decreases. This visualization is informative about the effect of distance of our samples in coordinate space. 

## MDS & PR_LM_CR_replicates_similarities

The MDS is used to detect similarities between the replicates in each sample. Both MDS and PR_LM_CR_replicates_similarities folders contain code for the calculation of stratum correlated coefficients using `hicrep`.  PR_LM_CR_replicates_similarities additionally contains an MDS plot with the visualization of the calculated replicate distances. 

## PCA

We used fanc (0.9.21) to create the PCA plots and an example plot can be found in the README in subdirectory ```PCA```. Preference was given to contacts with the largest variability across the genome (default option). There is clear separation between liver metastasis and primary tumor replicates, but the carboplatin resistant tumors do not group together as well. 

## Setup

```bash
conda env create -f environment.yml
```

```bash
conda activate qc
```
