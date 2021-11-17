# Replicate Quality Analysis

## Table of Contents
1. [Introduction](#introduction)
2. [Directory Structure](#directory-structure)
3. [Files](#files)
4. [Setup](#setup)

## Introduction

Here we perform exploratory analysis of sequenced tumor cells. The samples were collected from patient-derived xenograft (PDX) models and are characterized as either Carboplatin resistance or primary tumors. Liver metastatic tumors were also included in the analysis. Technical replicates were already removed and stored in Juicer 'long format' files, and were compiled into primary contact matrices also using Juicer. These contact matrices (known has hi-c files(.hic)), can be used as input for a variety of analytical tools that have been created in the last decade. 

Ideally, replicates in each group will be similar to each other. Previous research shows that drug resistant and metastatic tumors will have modified three-dimensional changes in their chromatin, so we expect groups to be separate from each other. We can measure differences in replicates using Principle Component Analysis, which the package FAN-C has an implementation for hic-matrices. This statistical analysis is ideal to maintain data integrity while also reducing the dimensions in our data to see similarity of replicates in each group and differences between groups. Additionally, we use multidimensional scaling to measure distances between our replicates to measure similarities.


## Directory Structure
├── StratumAdjustedCorrelationCoefficients # Scripts and plots 
├── PCA                     # Scripts for PCA plotting
├── Distance Decay          # Distance decay scripts
└── README.md

## Files

1. replicate_quality_analysis.sh
	* **Introduction.** This file takes a text file containing replicate groups and file paths. This script will calculate stratum adjusted correlation coefficients, PCA and distance decay plots for these replicates by their group.
	* **Input.** Text file containing rows of replicates. The format should be: 
		a. Group Name
		b. Path to file
		c. Specifically, <GroupName>,<PathToFile>

	* **Output.** The output will default to the current working directory and will have 3 folders - StratumCoefficient, PCA, and MDS.

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
./replicate_quality_analysis.sh -f <input-file>
```
