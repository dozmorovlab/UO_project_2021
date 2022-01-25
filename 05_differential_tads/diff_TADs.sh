#!/bin/bash
#SBATCH --partition=bgmp
#SBATCH --account=bgmp
#SBATCH --job-name=TAD
#SBATCH --output=TAD_%j.out
#SBATCH --error=TAD_%j.out
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=120G


###### This script will take two hic files, one treatment and one control, 
# then uses hicexplorer to convert to cool files, normalize, ICE correct, 
# find PCAs, find TADs, and find differential TADs, then plots matrix along region
# specified by tracks.ini file along with TAD boundaries, and plots the matrices
# along with PCA 1 & 2 by chromosome.


conda activate hicexplorer

#####################################################################
##### Options #####
#####################################################################
# resolution
res=50000

# min depth: Minimum window length (in bp) to be considered to the left and to the right of each Hi-C bin. This number should be at least 3 times as large as the bin size of the Hi-C matrix
# max depth: Maximum window length to be considered to the left and to the right of the cut point in bp. This number should around 6-10 times as large as the bin size of the Hi-C matrix.
let min_depth=6*$res
let max_depth=12*$res
let min_bound=$res
threshold=0.007
delta=0.1

# out directory
out_dir=./diff_TADs_$res
mkdir -p $out_dir

# control sample name
control_name=primary 

# treatment sample name
treatment_name=livermet 

# path to treatment hic matrix
treatment_hic_matrix=/projects/bgmp/shared/2021_projects/VCU/data/merged_files/livermet_merged/inter_25_50.hic

# path to control hic matrix
control_hic_matrix=/projects/bgmp/shared/2021_projects/VCU/data/merged_files/primary_merged/text_files/down_sampled/splitted_shuffled_primary_downsample_1.hic

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


echo 'dont with normalize'
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
--matrix $out_dir/ICE_corrected_$treatment_name.cool \
-o $out_dir/treatment_diagnostic_after

hicCorrectMatrix diagnostic_plot \
--matrix $out_dir/ICE_corrected_$control_name.cool \
-o $out_dir/control_diagnostic_after


echo 'done with ICE correcting'
#####################################################################
#####################################################################





# #####################################################################
# # KR correction for matrices
# #####################################################################
# hicCorrectMatrix correct \
# -m $treatment_cool_matrix \
# -o $out_dir/corrected_$treatment_name.cool \
# --correctionMethod KR

# hicCorrectMatrix correct \
# -m $control_cool_matrix \
# -o $out_dir/corrected_$control_name.cool \
# --correctionMethod KR


# echo 'done with KR correction'
# #####################################################################
# #####################################################################



treatment_corrected_matrix=$out_dir/corrected_$treatment_name.cool
control_corrected_matrix=$out_dir/corrected_$control_name.cool



#####################################################################
# find TADs on each matrix and compute differential TADs
#####################################################################
removes previous tad scores
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
--pValue 0.02 \
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
--region chr20:40000000-45000000

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
