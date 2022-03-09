#!/bin/bash


###### This script will take two hic files, one treatment and one control, 
# then uses hicexplorer to convert to cool files, normalize, ICE correct, 
# find PCAs, find TADs, and find differential TADs, then plots matrix along region
# specified by tracks.ini file along with TAD boundaries, and plots the matrices
# along with PCA 1 & 2 by chromosome.


conda activate hicexplorer


# help functions, displays user options
help()
{
    echo " "
    echo "This script uses HiCExplorer to convert HiC files into .cool files and"
    echo "then normalizes matrices and corrects via iterative matrix correction. "
    echo "Lastly, boundaries are called using the passed parameters. A statistical"
    echo "analysis of differential boundaries is performed and a custom Python script"
    echo "uses the output to plot the results (see output_dir/plots)."
    echo " "
    echo "The following options are required:"
    echo "     --resolution : desired resolution of resulting cool files."
    echo "     --minimum : Minimum window length (in bp) to be considered to the left and to the right of each Hi-C bin."
    echo "                 This number should be at least 3 times as large as the bin size of the Hi-C matrix."
    echo "     --maximum : Maximum window length to be considered to the left and to the right of the cut point in bp."
    echo "                 This number should around 6-10 times as large as the bin size of the Hi-C matrix."
    echo "     --boundary_distance : min distance between boundaries in UNITS OF RESOLUTION."
    echo "     --threshold : q-value cutoff for FDR correction"
    echo "     --delta : amount below avg a local minimum TAD score needs to be for consideration of TAD boundary"
    echo "     --control_name : enter name for control sample, e.g. primary."
    echo "     --treatment_name : enter name for treament sample, e.g. metastatic."
    echo "     --control_hic : path to control hic file."
    echo "     --treatment_hic : path to treatment hic file."
    echo " "
    echo " "
    echo "For more information regarding parameters please visit https://hicexplorer.readthedocs.io/en/latest/content/list-of-tools.html"
}

# if no arguments are provided, return usage function
if [ $# -eq 0 ]; then
    echo " "
    echo "Thou shalt pass options to this script. Here is the help menu:"
    echo " "
    help
    exit 1
fi


while [ "$1" != "" ]; do
    case $1 in
    -r | --resolution) # desired resolution of resulting cool files
        shift # remove `-t` or `--tag` from `$1`
        res=$1
        ;;
    -m | --minimum) # Minimum window length (in bp) to be considered to the left and to the right of each Hi-C bin. This number should be at least 3 times as large as the bin size of the Hi-C matrix
        shift
        min=$1
        ;;
    -M | --maximum) # Maximum window length to be considered to the left and to the right of the cut point in bp. This number should around 6-10 times as large as the bin size of the Hi-C matrix.
        shift
        max=$1
        ;;
    -b | --boundary_distance) # min distance between boundaries in units of resolution
        shift
        minb=$1
        ;;
    -T | --threshold) #P-value threshold for the Bonferroni correction / q-value for FDR.
        shift
        threshold=$1
        ;;
    -d | --delta) # amount below avg a local minimum TAD score needs to be for consideration of TAD boundary
        shift
        delta=$1
        ;;
    -c | --control_name)
        shift
        control_name=$1
        ;;
    -t | --treatment_name)
        shift
        treatment_name=$1
        ;;
    -C | --control_hic)
        shift
        control_hic_matrix=$1
        ;;
    -Y | --treament_hic)
        shift
        treatment_hic_matrix=$1
        ;;
    -h | --help)
        help # run usage function
        exit 0
        ;;
    *)
        echo " "
        echo "Wrong. Here is the help menu:"
        echo " "
        help
        exit 1
        ;;
    esac
    shift # remove the current value for `$1` and use the next
done




#####################################################################
##### Options #####
#####################################################################

min_depth=$(($res * $min))
max_depth=$(($res * $max))
min_bound=$(($minb * $res))

# out directory
out_dir=./diff_TADs_$res
mkdir -p $out_dir
mkdir -p $out_dir/plots
a=_$res
#####################################################################
#####################################################################



#####################################################################
# converts hic matrices to cool matrices
#####################################################################
hicConvertFormat \
--matrices $treatment_hic_matrix \
--inputFormat hic \
--outFileName $out_dir/$treatment_name.cool \
--outputFormat cool \
--resolutions $res

hicConvertFormat \
--matrices $control_hic_matrix \
--inputFormat hic \
--outFileName $out_dir/$control_name.cool \
--outputFormat cool \
--resolutions $res


echo 'done with converting'
#####################################################################
#####################################################################

treatment_cool_matrix=$out_dir/$treatment_name$a.cool
control_cool_matrix=$out_dir/$control_name$a.cool




#####################################################################
# Normalize matrices to lowest read count of the given matrices
#####################################################################
hicNormalize \
--matrices $treatment_cool_matrix $control_cool_matrix \
--normalize smallest \
-o $out_dir/norm_$treatment_name.cool $out_dir/norm_$control_name.cool


echo 'done with normalize'
#####################################################################
#####################################################################


treatment_cool_matrix=$out_dir/norm_$treatment_name.cool
control_cool_matrix=$out_dir/norm_$control_name.cool





#####################################################################
# ICE correction and review of count frequencies
#####################################################################
hicCorrectMatrix diagnostic_plot \
--matrix $treatment_cool_matrix \
-o $out_dir/treatment_diagnostic_before

hicCorrectMatrix diagnostic_plot \
--matrix $control_cool_matrix \
-o $out_dir/control_diagnostic_before

hicCorrectMatrix correct \
-m $treatment_cool_matrix \
-o $out_dir/corrected_$treatment_name.cool \
--filterThreshold -0.5 5 \
--correctionMethod ICE 

hicCorrectMatrix correct \
-m $control_cool_matrix \
-o $out_dir/corrected_$control_name.cool \
--filterThreshold -0.5 5 \
--correctionMethod ICE

hicCorrectMatrix diagnostic_plot \
--matrix $out_dir/corrected_$treatment_name.cool \
-o $out_dir/treatment_diagnostic_after

hicCorrectMatrix diagnostic_plot \
--matrix $out_dir/corrected_$control_name.cool \
-o $out_dir/control_diagnostic_after


echo 'done with ICE correcting'
#####################################################################
#####################################################################


treatment_corrected_matrix=$out_dir/corrected_$treatment_name.cool
control_corrected_matrix=$out_dir/corrected_$control_name.cool



#####################################################################
# find TADs on each matrix and compute differential TADs
#####################################################################
## removes previous tad scores
rm $out_dir/treatment_tad_score.bm
rm $out_dir/control_tad_score.bm

hicFindTADs \
-m $treatment_corrected_matrix \
--outPrefix $out_dir/treatment \
--correctForMultipleTesting fdr \
--thresholdComparisons $threshold \
--delta $delta \
--step $res \
--minDepth $min_depth \
--maxDepth $max_depth

hicFindTADs \
-m $control_corrected_matrix \
--outPrefix $out_dir/control \
--correctForMultipleTesting fdr \
--thresholdComparisons $threshold \
--delta $delta \
--step $res \
--minDepth $min_depth \
--maxDepth $max_depth

# Computes differential TADs by comparing the precomputed TAD regions of the target matrix with the same regions of the control matrix.
hicDifferentialTAD \
--targetMatrix $treatment_corrected_matrix \
--controlMatrix $control_corrected_matrix \
--tadDomains $out_dir/treatment_domains.bed \
--mode all \
--modeReject all \
--pValue 0.01 \
-o $out_dir/differential_TAD

# rename diff tad files to .bed
mv $out_dir/differential_TAD_accepted.diff_tad $out_dir/differential_TAD_accepted.bed
mv $out_dir/differential_TAD_rejected.diff_tad $out_dir/differential_TAD_rejected.bed

echo 'done with finding TADs and differential TADs'
#####################################################################
#####################################################################





#####################################################################
# plot TAD results
#####################################################################
cp tracks.ini ./$out_dir
# uses tracks.ini file to plot hic matrices and TADs (tracks.ini file needs to be manually created)
pyGenomeTracks \
--tracks $out_dir/tracks.ini \
--out $out_dir/diff_tads_mindepth$min_depth.maxdepth$max_depth.minbound$min_distance.delta$delta.threshold$threshold.png \
--region chr20:35000000-45000000

echo 'done with plotting'
#####################################################################
#####################################################################





#####################################################################
# plot all cool matrices
#####################################################################

hicPlotMatrix \
-m $treatment_corrected_matrix \
-o $out_dir/chr20_$treatment_name.png \
--log1p \
--chromosomeOrder 20

hicPlotMatrix \
-m $control_corrected_matrix \
-o $out_dir/chr20_$control_name.png \
--log1p \
--chromosomeOrder 20

echo 'done with heatmaps'
#####################################################################
#####################################################################





#####################################################################
# custom python script to find avg TAD size, differential TAD sizes, and number of TADs
#####################################################################

python tad_stats.py -o $out_dir

#####################################################################
#####################################################################
