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

# -m for hic matrix
# -n for name
# -o for output directory
# -r for resolution


############# start editing ###################
# help functions, displays user options
help()
{
    echo "This program takes a hic matrix and outputs counts vs frequency plots and heatmaps with PC1 and PC2"
    echo " "
    echo "The following options are required:"
    echo "     -m     Input hic matrix file, including directory"
    echo "     -n     Input name of sample, e.g. 'primary' or 'liver_met'. Do not use spaces."
    echo "     -o     Specify an output directory name. If the directory does not exist it will be created."
    echo "     -r     Input resolution; conversion of HiC to cool file format requires a resolution argument."
    echo " "
}

# process input options
while getopts ":hm:n:o:r:" option
do
    case $option in 
        
        h) #displays help
            help
            exit;;

        m) #enter a hic matrix file name
            hic_matrix=$OPTARG;;

        n) #enter an output name to be appendended to output files
            name=$OPTARG;;

        o) #enter an output directory name
            out_dir=$OPTARG;;

        r) #paired end? too bad
            res=$OPTARG;;

        \?) #displays invalid option
            echo "Error: Invalid option(s)"
            exit;;

    esac
done



#change this, depending on the sample
# matrix_dir=/projects/bgmp/shared/2021_projects/VCU/week2/livermet_merged
# hic_matrix=$matrix_dir/inter_25_50.hic

# change this, depending on the sample
# name=liver_met

mkdir -p $out_dir 
# out_dir=$matrix_dir/hic_pipe_out$name

# change this if wanted. Prefer ICE_corrected.. or KR_corrected.. or comment out to use original cool matrix
# matrix=$out_dir/ICE_corrected_$name.cool


# res=50000

# this pipe follows the HiCexplorer example page at https://hicexplorer.readthedocs.io/en/latest/content/example_usage.html

# first we convert from hic to cool, if need be.
hicConvertFormat \
--matrices $hic_matrix \
--inputFormat hic \
--outFileName $out_dir/$name.cool \
--outputFormat cool \
--resolutions $res

a=_$res
cool_matrix=$out_dir/$name$a.cool

# # normalize matrix
# hicNormalize -m $cool_matrix -o $cool_matrix -n norm_range

# # then we correct the matrix
hicCorrectMatrix diagnostic_plot -m $cool_matrix -o $out_dir/diagnostic_plot_before_ICE_$name.png


# ICE correction
hicCorrectMatrix correct -m $cool_matrix -o $out_dir/ICE_corrected_$name.cool --filterThreshold -1 5 --correctionMethod ICE 
corrected_matrix=$out_dir/ICE_corrected_$name.cool
hicCorrectMatrix diagnostic_plot -m $corrected_matrix -o $out_dir/diagnostic_plot_ICE_$name.png

# #### KR correction; doesn't work? #####
# # hicCorrectMatrix correct -m $cool_matrix -o $out_dir/KR_corrected_$name.cool --correctionMethod KR 
# # hicCorrectMatrix diagnostic_plot -m $out_dir/KR_corrected_$name.cool -o $out_dir/diagnostic_plot_KR_$name.png


let min_depth=4*res
let max_depth=10*res

mkdir -p $out_dir/TADS

hicPCA \
-m $corrected_matrix \
--format bigwig \
-o $out_dir/pca1.bw $out_dir/pca2.bw

chmod 755 $out_dir/*
chmod 755 $out_dir/TADS/*

#### this only takes h5 files?? ####
# hicFindTADs \
# -m $corrected_matrix \
# --outPrefix $out_dir/TADS/ \
# --correctForMultipleTesting fdr \
# --thresholdComparisons 0.05 \
# --minDepth $min_depth \
# --maxDepth $max_depth

conda activate pygenometracks


# make_tracks_file \
# --trackFiles \
# $corrected_matrix \
# $out_dir/pca1.bw \
# $out_dir/pca2.bw \
# $out_dir/TADS/_tad_score.bm \
# $out_dir/TADS/_domains.bed \
# $out_dir/TADS/_boundaries.bed \
# --out $out_dir/TADS/tracks.ini

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
-m $corrected_matrix \
--bigwig $out_dir/pca1.bw $out_dir/pca2.bw \
-o $out_dir/hic_plot_pca_ICE_$name.png \
--log1p \
--perChromosome
