## Distance-Decay Plots
\
To check the quality of the biological replicates, use `HiCExplorer 3.0` to create distance-decay plots. The plots should look near-identical for biological replicates.
\
\
First, create the appropriate environment by saving the file [environment.yml](./environment.yml), then run commands:
\
```conda env create -f environment.yml```
\
```conda activate hicexplorer```
\
\
If you have `.hic` files, you will need to convert them to `.cool` files through HiCExplorer's [hicConvertFormat](./scripts/cool_converter.sh) function. 
- Input: files with format `<name>.hic`.
- Output: files will be `<name>.cool` with specified resolution in specified directory.
\
\
Then, use the resulting `.cool` files with HiCExplorer's [hicPlotDistVsCounts](./scripts/hicPlotDistVsCounts.sh) function.
- Input: files with format `<name>.cool`.
- Output: distance decay plots.
\
\
\
\
*note: to improve this directory, specifically the scripts, the file structure arguments still need to be generalized (e.g. replace <input filename> with some commands).*
