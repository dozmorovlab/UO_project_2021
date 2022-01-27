# Replicate Quality Analysis

## Table of Contents
1. [Introduction](#introduction)
2. [Directory Structure](#directory-structure)
3. [Files](#files)
4. [Setup](#setup)

## Introduction

Here we perform exploratory analysis of sequenced tumor cells. The samples were collected from patient-derived xenograft (PDX) models and are characterized as either Carboplatin resistant, livermetastic or primary tumors. Technical replicates were already removed and stored in Juicer 'long format' files, and were compiled into primary contact matrices also using Juicer. These contact matrices (known has hi-c files(.hic)), can be used as input for a variety of analytical tools that have been created in the last decade. 

Ideally, replicates in each group will be similar to each other. Previous research shows that drug resistant and metastatic tumors will have modified three-dimensional changes in their chromatin, so we expect groups to be separate from each other. We can measure differences in replicates using Principle Component Analysis, which the package FAN-C has an implementation for hic-matrices. This statistical analysis is ideal to maintain data integrity while also reducing the dimensions in our data to see similarity of replicates in each group and differences between groups. Additionally, we use multidimensional scaling to measure distances between our replicates to measure similarities.

## Directory Structure

├── StratumAdjustedCorrelationCoefficients 	# Script to create SCC heatmap</br>
├── PCA                     				# Scripts for PCA plotting</br>
├── MDS                     				# Scripts for MDS plotting></br>
├── Distance Decay          				# Distance decay scripts</br>
└── README.md</br>

## PCA

We used fanc (0.9.21) to create the PCA plots and an example plot can be found in the README in subdirectory ```PCA```. Preference was given to contacts with the largest variability across the genome (default option). There is clear separation between liver metastasis and primary tumor replicates, but the carboplatin resistant tumors do not group together as well. 

## Setup

1. Create the environment.

```bash
conda env create -f environment.yml
```

```bash
conda activate qc
```

2. Run

```bash
./pca.sh --help
```

```
usage: pca.sh [-m, --metafile] [-i, --input-directory] [-o, --output-directory] [-s, --sample-size]
```

The metafile contains the filenames, their group, and the folder they are located in:
```bash
touch metafile.csv

echo 105259,Primary,original_primary_files >> metafile.csv
echo 102770,Primary,original_primary_files >> metafile.csv
echo 102933,Primary,original_primary_files >> metafile.csv
echo 100887,LiverMet,original_LM_files >> metafile.csv
echo 100888,LiverMet,original_LM_files >> metafile.csv
echo 100889,LiverMet,original_LM_files >> metafile.csv
```

The rest of the parameters are explained below:
```
--input-directory	The input directory is the parent directory where the folders above live.
--output-directory	Directory where pca plot will be saved.
--sample-size		Sample size to use for PCA. 
```
