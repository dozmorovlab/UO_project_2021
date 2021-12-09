# Differential TADS

The script `diff_TADs.sh` uses [HiC Explorer](https://hicexplorer.readthedocs.io/en/latest/index.html) functions on hic matrices to find statistically different TADs between two samples.

## Input
- Hic Matrices (file paths must be specified in `diff_TADs.sh`)
- `tracks.ini` file (provided in this repo, but must be configured with input files)

## Output
- Out_directory
  - control_boundaries.bed 
  - control_boundaries.gff
  - control_domains.bed -- **input into tracks.ini file**
  - control_pca1.bw
  - control_pca2.bw
  - control_score.bedgraph
  - control_tad_score.bm
  - control_zscore_matrix.cool
  - diff_tads.png -- **png file showing tad boundaries**
  - differential_TAD_accepted.bed -- **.bed file listing TADs that are statistically *same* between samples**
  - differential_TAD_rejeceted.bed -- **.bed file listing TADs that are statistically *different* between samples**
  - ICE_corrected_<treatment name>.cool -- **.cool matrix of treatment, input for** `tracks.ini` **file**.
  - ICE_corrected_<control name>.cool -- **.cool matrix of control, input for** `tracks.ini` **file**.
  - <treatment name>.png -- **visualization of cool matrix**
  - <control name>.png -- **visualization of cool matrix**
  - treatment_boundaries.bed 
  - treatment_boundaries.gff
  - treatment_domains.bed -- **input into tracks.ini file**
  - treatment_pca1.bw
  - treatment_pca2.bw
  - treatment_score.bedgraph
  - treatment_tad_score.bm
  - treatment_zscore_matrix.cool
  
