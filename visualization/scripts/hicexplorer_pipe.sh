#!/bin/bash
#SBATCH --partition=bgmp
#SBATCH --account=bgmp
#SBATCH --job-name=hic_visual_pri
#SBATCH --output=hic_visual_pri_%j.out
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=120G

conda activate hicexplorer
hic_matrix=/projects/bgmp/shared/2021_projects/VCU/week2/primary_merged/sorted/primary_sorted_half2.hic
name=primary_half2

mkdir -p /projects/bgmp/shared/2021_projects/VCU/week2/primary_merged/hic_pipe_out$name 
out_dir=/projects/bgmp/shared/2021_projects/VCU/week2/primary_merged/hic_pipe_out$name
res=50000

# this pipe follows the HiCexplorer example page at https://hicexplorer.readthedocs.io/en/latest/content/example_usage.html

# first we convert from hic to cool, if need be.
hicConvertFormat \
--matrices $hic_matrix \
--inputFormat hic \
--outFileName $out_dir/$name.cool \
--outputFormat cool \
--resolutions $res

a=_50000
cool_matrix=$out_dir/$name$a.cool
matrix=$out_dir/ICE_corrected_$name.cool

# then we correct the matrix
hicCorrectMatrix diagnostic_plot -m $cool_matrix -o $out_dir/diagnostic_plot_$name.png


# ICE correction
hicCorrectMatrix correct -m $cool_matrix -o $out_dir/ICE_corrected_$name.cool --filterThreshold -2.1 5 --correctionMethod ICE 
hicCorrectMatrix diagnostic_plot -m $corrected_matrix -o $out_dir/diagnostic_plot_ICE_$name.png

## KR correction; doesn't work?
# hicCorrectMatrix correct -m $cool_matrix -o $out_dir/KR_corrected_$name.cool --correctionMethod KR 
# hicCorrectMatrix diagnostic_plot -m $out_dir/KR_corrected_$name.cool -o $out_dir/diagnostic_plot_KR_$name.png


let min_depth=4*res
let max_depth=10*res

mkdir -p $out_dir/TADS

hicPCA \
-m $matrix \
--format bigwig \
-o $out_dir/pca1 $out_dir/pca2

hicFindTADs \
-m $matrix \
--outPrefix $out_dir/TADS/ \
--correctForMultipleTesting fdr \
--thresholdComparisons 0.05 \
--minDepth $min_depth \
--maxDepth $max_depth

conda activate pygenometracks

make_tracks_file \
--trackFiles \
$out_dir/$matrix \
$out_dir/pca1.bigwig \
$out_dir/pca2.bigwig \
$out_dir/TADS/_tad_score.bm \
$out_dir/TADS/_domains.bed \
$out_dir/TADS/_boundaries.bed \
--out $out_dir/TADS/tracks.ini

#### has wonky output, need to adjust ###
# pyGenomeTracks \
# --tracks $out_dir/TADS/tracks.ini \
# --region chr22:10000000-28000000 \
# -o $out_dir/pygenome_out.png

conda activate hicexplorer

#### this looks terrible #######
# hicPlotTADs \
# --tracks $out_dir/TADS/tracks.ini \
# --region chr22:10000000-28000000 \
# -o $out_dir/tads.png

hicPlotMatrix \
-m $matrix \
--bigwig $out_dir/pca1.bigwig $out_dir/pca2.bigwig \
-o $out_dir/hic_plot_pca_ICE_$name.png \
--log1p \
--perChromosome
