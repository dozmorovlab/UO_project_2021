# Deeptools BAM Comparison

This script uses Deeptools' [bamCompare](https://deeptools.readthedocs.io/en/develop/content/tools/bamCompare.html) to create a bigwig file containing ratio of normalized reads per bin between to bam files.
`bamCompare` partitions the input files into bins of equal size and then counts the number of reads per bin, and normalized via the `--exactScaling` option, which Deeptools states is useful "when region-based sampling is expected to produce incorrect results."


It also uses Deeptools' [plotCoverage](https://deeptools.readthedocs.io/en/develop/content/tools/bamCompare.html) to create two plots: 1) frequency of read coverages and 2) percent genome with read depth X.
These plots are made by sampling one million base pairs and finding their overlapping regions.  

Input: 
- Two BAM files aligned to same reference genome

Output:
- Bedgraph file with columns:
  - `chromosome`  `start position`  `stop position` `ratio bam1_reads:bam2_reads`
- Plot showing percent reads with coverage X
- Plot showing percent reads with at least coverage X 
