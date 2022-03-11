# Create HiC Files

## Introduction

The spatial organization of chromosomes can be stored in HiC matrices. These are binary, sparse matrices that contain contact counts between chromatin regions. These We create these files using Juicer, a toolset that is created by the [Aiden Lab] (http://aidenlab.org/), which requires unaligned fastq files from Hi-C Experiments. 

We generate Hi-C files from valid read pairs that had technical duplicates removed (ie. PCR duplicates). Prior to creating the HiC files, the minimum resolution can be calculated using a script included in Juicer (```${JUICER}/misc/calculate_map_resolution.sh```), which will identify the bin size need for 80% of bins to contain > 1000 contact counts. This resolution calculation is important because:
	
1. We learn the minimum resolution the data can be visualized at (http://aidenlab.org/juicebox/)
2. Merging replicates creates a new file that did not have a previously set resolution. We can calculate the resolution after the merge to determine if the resolution increases (or at least changes).

## Setup 

```bash
conda env create -f environment.yml
```

```bash
conda activate hic
```

## Creating Hic Files

The following command takes nodup files created by `dups.awk` in the `Juicer` repository and create Hic files.
```bash
resolution=50000
input_file='no_dup.txt'
output_file='hic_file.hic'

java -Xmx32g -jar juicer_tools.jar pre -q 1 -r $resolution -j 8 $input_file $output_file hg38 
```
