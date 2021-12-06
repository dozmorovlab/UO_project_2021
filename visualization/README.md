# HiC Explorer visualization pipeline
The script `hicexplorer_pipe.sh` follows the [example page](https://hicexplorer.readthedocs.io/en/latest/content/example_usage.html) from HiC Explorer manual. 
It is used to visualize hic contact matrices, A/B compartments, and TADs.

## Setup
- First, download the `hicexplorer_environment.yml` to your working directory.
- Then run the command:
```conda env create -f hicexplorer_environment.yml```
- Lastly check to make sure the environment works with 
```conda activate hicexplorer```

## Input
- The `hicexplorer_pipe.sh` uses a hic matrix file as input. 
- Along with the input file are four other required arguments; you can run `hicexplorer_pipe.sh -h` to see them. The options are:
  - -m     Input hic matrix file, including directory
  - -n     Input name of sample, e.g. 'primary' or 'liver_met'. Do not use spaces.
  - -o     Specify an output directory name. If the directory does not exist it will be created.
  - -r     Input resolution; conversion of HiC to cool file format requires a resolution argument.
  - -s     Input span of genome to view with HiCPlotTADs. Use format chr<num>:<start_pos>-<stop_position>

Optionally, you may pass the argument `-t` in order to view PC1, PC2, TAD score, and domains over a given region `-s`**\***. The script will only run the function [hicPlotTADs](https://hicexplorer.readthedocs.io/en/latest/content/tools/hicPlotTADs.html) and then exit. Note that you must still put in the above required arguments and that the `tracks.ini` file (generated by [pygenometracks' make_tracks_file](https://pygenometracks.readthedocs.io/en/latest/content/usage.html#make-tracks-file) in the `hicexplorer_pipe.sh` script) must already exist in `$out_dir/TADs`. 

## Output
- `hicexplorer_pipe.sh` outputs the following: 

├───OutDir/ \
&nbsp;&nbsp;&nbsp;&nbsp;├───**diagnostic_plot_before_ICE_$name.png** (this is a counts distribution of interactions before ICE correction) \
&nbsp;&nbsp;&nbsp;&nbsp;├───**diagnostic_plot_ICE_$name.png** (this is a counts distribution of interactions after ICE correction)\
&nbsp;&nbsp;&nbsp;&nbsp;├───**hic_plot_pca_ICE_$name.png** (this is a heat map of the input matrix along with PC1 (top) and PC2 (bottom))\
&nbsp;&nbsp;&nbsp;&nbsp;├───**tads_at_$span.png** (this is the output described in the `-t` option above)\
&nbsp;&nbsp;&nbsp;&nbsp;├───**pca1.bw** (principle component 1 bigwig file)\
&nbsp;&nbsp;&nbsp;&nbsp;├───**pca2.bw** (principle component 2 bigwig file)\
&nbsp;&nbsp;&nbsp;&nbsp;├───**name_$res.cool** (original hic matrix converted to .cool format)\
&nbsp;&nbsp;&nbsp;&nbsp;├───**ICE_corrected_$name.cool** (original hic matrix converted to .cool format and corrected)\
&nbsp;&nbsp;&nbsp;&nbsp;├───**TADS/** \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├───**boundaries.bed** (TAD boundaries) \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├───**boundaries.gff** (TAD boundaries) \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├───**domains.bed** (TAD locations) \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├───**score.bedgraph** (TAD separation score) \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├───**tad_score.bm** (TAD separation as bedgraph matrix) \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├───**zscore_matrix.h5** (z score matrix) \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├───**tracks.ini** (a track for all bedlike files)

## Issues
*Currently, the plot `tads_at_$span.png` looks wonky. Need to play with the `tracks.ini` file in order to figure out better plot display settings.