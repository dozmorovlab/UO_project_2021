#!/bin/bash
#SBATCH --partition=bgmp
#SBATCH --account=bgmp
#SBATCH --job-name=hic_visual_pri
#SBATCH --output=hic_visual_pri_%j.out
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=120G


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
    echo "     -s     Input span of genome to view with HiCPlotTADs. Use format chr<num>:<start_pos>-<stop_position>"
    echo " "
    echo "The following option is optional:"
    echo "     -t     Pass this option to only plot the TADs statistics (i.e. hicPlotTADs function). If so, the tracks.ini file must already exist in out_dir/TADs and you must still pass the above options."
}

# process input options
while getopts ":hm:n:o:r:s::t" option
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

        r) #specify resolution
            res=$OPTARG;;
		
	s) #enter the span of genome to be plotted with HiCPlotTADs
			span=$OPTARG;;
		
	t) #only output tad stats?
			tad_only=$OPTARG;;

        \?) #displays invalid option
            echo "Error: Invalid option(s)"
            exit;;

    esac
done

# this pipe follows the HiCexplorer example page at https://hicexplorer.readthedocs.io/en/latest/content/example_usage.html

conda activate hicexplorer

if [ $tad_only ]; then
    hicPlotTADs \
	--tracks $out_dir/TADS/tracks.ini \
	--region $span \
	-o $out_dir/tads_at_$span.png
    exit 0
fi

mkdir -p $out_dir 

# first we convert from hic to cool, if need be.
hicConvertFormat \
--matrices $hic_matrix \
--inputFormat hic \
--outFileName $out_dir/$name.cool \
--outputFormat cool \
--resolutions $res

a=_$res
cool_matrix=$out_dir/$name$a.cool

# then view count frequencies
hicCorrectMatrix diagnostic_plot -m $cool_matrix -o $out_dir/diagnostic_plot_before_ICE_$name.png


# ICE correction and review of count frequencies
hicCorrectMatrix correct -m $cool_matrix -o $out_dir/ICE_corrected_$name.cool --filterThreshold -1 5 --correctionMethod ICE 
corrected_matrix=$out_dir/ICE_corrected_$name.cool
hicCorrectMatrix diagnostic_plot -m $corrected_matrix -o $out_dir/diagnostic_plot_ICE_$name.png


let min_depth=4*res
let max_depth=10*res

mkdir -p $out_dir/TADS

# this does a PCA and outputs the first and seconds eigenvectors as bigwig files
hicPCA \
-m $corrected_matrix \
--format bigwig \
-o $out_dir/pca1.bw $out_dir/pca2.bw

chmod 755 $out_dir/*
chmod 755 $out_dir/TADS/*

### this only takes h5 files?? ####
hicFindTADs \
-m $corrected_matrix \
--outPrefix $out_dir/TADS/ \
--correctForMultipleTesting fdr \
--thresholdComparisons 0.05 \
--minDepth $min_depth \
--maxDepth $max_depth

# this makes a track.ini file
make_tracks_file \
--trackFiles \
$corrected_matrix \
$out_dir/pca1.bw \
$out_dir/pca2.bw \
$out_dir/TADS/_tad_score.bm \
$out_dir/TADS/_domains.bed \
--out $out_dir/TADS/tracks.ini

### this looks terrible; need to find a way to adjust #######
# this plots whatever is specified in the tracks.ini file
hicPlotTADs \
--tracks $out_dir/TADS/tracks.ini \
--region $span \
-o $out_dir/tads_at_$span.png

# this plots the interaction matrix along with 1st and 2nd eigenvectors
hicPlotMatrix \
-m $corrected_matrix \
--bigwig $out_dir/pca1.bw $out_dir/pca2.bw \
-o $out_dir/hic_plot_pca_ICE_$name.png \
--log1p \
--perChromosome
