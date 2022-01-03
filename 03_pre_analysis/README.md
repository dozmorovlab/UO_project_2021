# Merging, Visualizing, and Separating Replicates

## Table of Contents
1. [Introduction](#introduction)
2. [Merge Replicates](#merge-replicates)
3. [Visualizing Contact Maps](#visualizing-contact-maps)
4. [Creating New Replicates](#creating-new-replicates)

## Introduction

Lower resolution HiC replicates can be merged together in order to increase the resolution of HiC data. Lower resolutions are expected to make analysis more difficult, so merging will be important (What is an ideal resolution??). The before and after delta can be calculated by first determining the minimum resolution of the starting data and then calculating the data minimum resolution afterwards. `Juicer` has a script that can do this called `calculate_min_resolution.sh`, which creates 50 bp bin vectors and increases the bins by 50 bp increments until 80% of bins in the vector have >1000 contacts. Our script `min_resolution.sh` uses this script with `slurm`; a ~200 MB file takes about 30-40 minutes to run. 

## Merge Replicates

One replicate from liver metastasis and one from carboplatin resistant were removed (ids??), and the remaining replicates were merged by group. This resulted in a final hic file for each group (Primary tumor, carboplatin resistant, and liver metastasis)

```bash
files='<merged_nodups_txt_files>'
output='<output.hic>'
```

This command will sort the files and merge them. They are sorted by chromosome using juicer long format. 
```bash
sort --parallel=8 -S 64G -m -k2,2d -k6,6d $files > merged_nodups.txt
```

This is the Juicer command to create the hic files.
```bash
java -Xmx32g -jar juicer_tools.jar pre -q 1 -r 25000,50000 -j 8 $files $output hg38 
```

## Visualizing Contact Maps

The final merged replicates were visualized using `juicebox` (http://aidenlab.org/juicebox/). Due to the low contacts on all chromosomes, the carboplatin resistant group was removed (need an image of the carboplatin resistant contact maps here!!). 

## Creating New Replicates
The merged primary files were about 512 MB, nearly twice the size of the merged liver metastasis files. To make replicates equal in size, we split the merged primary file into halves and shuffled the halves randomly. One half from each was then used to create a new replicate. The two new replicates were roughly 250 MB each. 






