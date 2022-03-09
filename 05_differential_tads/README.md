
# Differential TADS

The script `diff_TADs.sh` uses [HiC Explorer](https://hicexplorer.readthedocs.io/en/latest/index.html) functions on hic matrices to find statistically different TADs between two samples.

Download `diff_TADs.sh`, `tad_stats.py`, `tracks.ini`, and `hicexplorer_environment.yml` to your working directory. \
Then run `conda env create -f hicexplorer_environment.yml && conda activate hicexplorer_environment.yml` to ensure the dependencies are working.


## Script Editing

Some script editing is needed. \
Specifically, the Iterative Matrix Correction needs user adjusted parameters for ideal results. \
These parameters can be adjusted on lines `200` and `206` in `diff_TADS.sh`. \
A before correction plot is generated under `{SAMPLE}_diagnostic_before.png` and after as `{SAMPLE}_diagnostic_after.png`. \
See [HiCExplorer's hicCorrectMatrix](https://hicexplorer.readthedocs.io/en/latest/content/tools/hicCorrectMatrix.html) for more details. 

Secondly, the `tracks.ini` may need to be manually edited. \
To change the region displayed in `diff_tads_*.png`, the user must change line `286` in `diff_TADs.sh`.\


## Input
<pre>
The following options are required: 
`--resolution` : desired resolution of resulting cool files. 
`--minimum` : Minimum window length (in bp) to be considered to the left and to the right of each Hi-C bin. This number should be at least 3 times as large as the bin size of the Hi-C matrix. 
`--maximum` : Maximum window length to be considered to the left and to the right of the cut point in bp. This number should around 6-10 times as large as the bin size of the Hi-C matrix. 
`--boundary_distance` : min distance between boundaries in UNITS OF RESOLUTION. 
`--threshold` : q-value cutoff for FDR correction 
`--delta` : amount below avg a local minimum TAD score needs to be for consideration of TAD boundary 
`--chromosome` : which chromosome to display heatmap of 
`--control_name` : enter name for control sample, e.g. primary. 
`--treatment_name` : enter name for treament sample, e.g. metastatic. 
`--control_hic` : path to control hic file. 
`--treatment_hic` : path to treatment hic file.
`--help` : displays this message.
</pre>


  
## Output  
<pre>
diff_TADs_{RESOLUTION} 
├── plots 
|   ├── control_diagnostic_after.png    *ICE diagnostic plot before correction* 
|   ├── control_diagnostic_before.png   *ICE diagnostic plot after correction* 
|   ├── diff_tads_mindepth200000.maxdepth500000.minbound.delta0.5.threshold0.05.png   *visualization of TAD differences in specified region* 
|   ├── differential_boundaries.png   *shows the ratio of different_boundaries:same_boundaries between the two HiC files at each chromosome.* 
|   ├── differential_numbers.png    *shows the ratio of different_domains:same_domains between the two HiC files at each chromosome.* 
|   ├── tad_numbers.png   *shows the number of TADs in each chromosome for each HiC file.*  
|   ├── tad_sizes.png   *shows the average size TAD in each chromosome for each HiC file.* 
|   ├── treatment_diagnostic_after.png 
|   └── treatment_diagnostic_before.png 
├── {CHROMOSOME}_{TREATMENT_NAME}.png   *correct/normalized treatment matrix (.cool)* 
├── {CHROMOSOME}_{CONTROL_NAME}.png 
├── control_boundaries.bed    *bed file with control sample TAD boundaries* 
├── control_boundaries.gff    *gff file with control sample TAD boundaries* 
├── control_domains.bed   *bed file contain control domain spans* 
├── control_score.bedgraph    *bedgraph file containing TAD scores* 
├── control_tad_score.bm 
├── control_zscore_matrix.cool 
├── corrected_{TREATMENT_NAME}.cool   *.cool matrix of treatment sample* 
├── corrected_{CONTROL_NAME}.cool    *.cool matrix of control sample* 
├── differential_TAD_accepted.bed   *locations of TADs that are statistically same between samples* 
├── differential_TAD_rejected.bed   *locations of TADs that are statistically different between samples* 
├── tracks.ini 
├── treatment_boundaries.bed 
├── treatment_boundaries.gff 
├── treatment_domains.bed 
├── treatment_score.bedgraph 
├── treatment_tad_score.bm 
└── treatment_zscore_matrix.cool 
</pre>

## Example Usage

```
./diff_TADs.sh \
--resolution 50000 \
--minimum 4 \
--maximum 10 \
--boundary_distance 2 \
--threshold 0.05 \
--delta 0.5 \
--chrom 20 \
--control_name primary \
--treatment_name livermet \
--control_hic <path-to-control-HIC> \
--treament_hic <path-to-treatment-HIC>
```
