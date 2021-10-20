#!/bin/bash
#SBATCH --partition=bgmp
#SBATCH --account=bgmp
#SBATCH --job-name=TAD
#SBATCH --output=TAD_%j.out
#SBATCH --error=TAD_%j.out
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=70G

conda activate hicexplorer

res=50000 #resolution
let depth=4*res
let Mdepth=10*res
name=primary

dir=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/$name/$res
file=$dir/matrix_$res.cool

hicFindTADs \
-m $file \
--outPrefix $dir/primary \
--correctForMultipleTesting None

conda activate pygenometracks

# make_tracks_file \
# --trackFiles \
# $file \
# $dir/primary_tad_score.bm \
# $dir/primary_domains.bed \
# --out $dir/tracks.ini

pyGenomeTracks \
--tracks $dir/tracks.ini \
--region chr22:25000000-28000000 \
-o $dir/pygenome_out.png

# conda activate hicexplorer

# hicPlotTADs \
# --tracks $dir/tracks.ini \
# --region chr22:35000000-37000000 \
# -o $dir/hicplottads.png