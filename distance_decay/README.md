# Distance-Decay Plots
\
This script checks the quality of the biological replicates by using `HiCExplorer 3.0` [hicPlotDistVsCounts]() to create distance-decay plots; the plots should look near-identical for biological replicates.
\
\

## Setup
First, create the appropriate environment by saving the file [environment.yml](./environment.yml), then run the command:
\
```conda env create -f environment.yml```
\
Check to see that the environment works by running: \
```conda activate hicexplorer```
\
\

## Input
The script `distance_decay.sh` takes hic matrix files as input, along with the following required four options:

- -d     Input the directory containing the hic files to be plotted. THIS SCRIPT WILL PLOT ALL MATRICES IN THIS DIRECTORY!"
- -r     Input resolution; conversion of HiC to cool file format requires a resolution argument."
- -o     Specify an output directory name (DIRECTORY MUST BE EMPTY). If the directory does not exist it will be created."
- -p     Input plot name, used for output distance decay plot"

Likewise, you may run `./distance_decay.sh -h` to see the above input options. 

## Output
The script `distance_decay.sh` outputs three `.cool` files and a distance decay plot called `<plot_name>.png` in the directory `<out_dir>`.



\
\
\
\
*note: to improve this directory, specifically the scripts, the file structure arguments still need to be generalized (e.g. replace <input filename> with some commands).*
