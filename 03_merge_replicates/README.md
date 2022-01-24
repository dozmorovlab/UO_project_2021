# Merge Replicates

Replicates of the primary and liver metastasis samples were merged together to increase resolution of our data. This work is the result of our previous visualization of the data in `02_visualize_replicates`. 

## Blender

Blender has a script that makes use of the slurm workload manager. This script will initiate a slurm batch script from the shell. 

## Min Resolution

This script uses the Juicer `calculate_map_resolution.sh` script referenced in `01_create_hic_files` while utilizing the slurm workload manager. 

## Randomizer.sh

The merged primary file was around 500 GB, nearly twice the size of the liver metastasis sample with all merged replicates (~ 250 GB).  