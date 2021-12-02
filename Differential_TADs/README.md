# Differential TADS

The script `diff_TADs.sh` uses [HiC Explorer](https://hicexplorer.readthedocs.io/en/latest/index.html) functions on hic matrices to find statistically different TADs between two samples.

## Input
- Hic Matrices

## Output
- Cool matrices
- Differential/non-differential TAD files
- Differential TADs in specified region as a .png file

ISSUE: Currently the parameters produce not so great TAD calls. See the `diff_tads.png` file in this folder -- 
There are many "smaller" TADs in the 35-45Mb range of the X chromosome which are called as one large TAD; parameters still need to be tweaked until the smaller TADs are called.
