#!/bin/bash
#SBATCH --partition=bgmp
#SBATCH --account=bgmp
#SBATCH --job-name=hic_visual_pri
#SBATCH --output=hic_visual_pri_%j.out
#SBATCH --error=hic_visual_pri_%j.out
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=70G

conda activate hicexplorer
matrix=/projects/bgmp/shared/2021_projects/VCU/week2/primary_merged/sorted/primary_sorted_half1.hic
mkdir -p /projects/bgmp/shared/2021_projects/VCU/week2/primary_merged/hic_pipe_out 
out_dir=/projects/bgmp/shared/2021_projects/VCU/week2/primary_merged/hic_pipe_out
name=primary_half1

# this pipe follows the HiCexplorer example page at https://hicexplorer.readthedocs.io/en/latest/content/example_usage.html

# first we correct the matrix
hicCorrectMatrix diagnostic_plot -m $matrix -o $out_dir/diagnostic_plot_$name.png
