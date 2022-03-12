# Merge Replicates

Replicates of the primary and liver metastasis samples were merged together to increase resolution of our data. This work is the result of our previous visualization of the data in `02_visualize_replicates`. 

## Blender

Blender has a script that makes use of the slurm workload manager. This script will initiate a slurm batch script from the shell. 

## Min Resolution

This script uses the Juicer `calculate_map_resolution.sh` script referenced in `01_create_hic_files` while utilizing the slurm workload manager. 

## Randomizer.sh

This script downsamples a given file. It is a custom written script for a specific file, and is not generalized.

The script breaks the input file into 217 smaller files, then shuffles the lines within each of the smaller files.
Then 37% of each of the small shuffled files is written into one single file, which is 37% the size of the original input file.

This downsampled file is then ordered by chromosome number then position, and the columns are rearranged to [Juicer pre-format](https://github.com/aidenlab/juicer/wiki/Pre#file-format).

This final output file is now ready to be [Juiced](https://github.com/dozmorovlab/UO_project_2021/tree/main/01_create_hic_files).

