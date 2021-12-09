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

##### Options #####
# treatment sample name
treatment_name=livermet 

# control sample name
control_name=primary 

# resolution
res=25000

# out directory
out_dir=./diff_TADs

# path to treatment hic matrix
treatment_hic_matrix=/projects/bgmp/shared/2021_projects/VCU/week2/livermet_merged/inter_25_50.hic

# path to control hic matrix
control_hic_matrix=/projects/bgmp/shared/2021_projects/VCU/week2/primary_merged/inter_25_50.hic


# the following lines do not need changing
a=_$res
treatment_cool_matrix=$out_dir/$treatment_name$a.cool
control_cool_matrix=$out_dir/$control_name$a.cool
treatment_corrected_matrix=$out_dir/ICE_corrected_$treatment_name.cool
control_corrected_matrix=$out_dir/ICE_corrected_$control_name.cool


mkdir -p $out_dir


# converts treatment hic to treatment cool
hicConvertFormat \
--matrices $treatment_hic_matrix \
--inputFormat hic \
--outFileName $out_dir/$treatment_name.cool \
--outputFormat cool \
--resolutions $res


# converts control hic to control cool
hicConvertFormat \
--matrices $control_hic_matrix \
--inputFormat hic \
--outFileName $out_dir/$control_name.cool \
--outputFormat cool \
--resolutions $res


# Normalize matrices to lowest read count of the given matrices
hicNormalize \
--matrices $treatment_cool_matrix $control_cool_matrix \
--normalize smallest \
-o $treatment_cool_matrix $control_cool_matrix


# ICE correction and review of count frequencies for treatment matrix
hicCorrectMatrix correct \
-m $treatment_cool_matrix \
-o $out_dir/ICE_corrected_$treatment_name.cool \
--filterThreshold -1 5 \
--correctionMethod ICE 


# ICE correction and review of count frequencies for control matrix
hicCorrectMatrix correct \
-m $control_cool_matrix \
-o $out_dir/ICE_corrected_$control_name.cool \
--filterThreshold -1 5 \
--correctionMethod ICE


# finds PCA 1 and 2 for treatment matrix
hicPCA \
-m $treatment_corrected_matrix \
--format bigwig \
-o $out_dir/treatment_pca1.bw $out_dir/treatment_pca2.bw


# finds PCA 1 and 2 for control matrix
hicPCA \
-m $control_corrected_matrix \
--format bigwig \
-o $out_dir/control_pca1.bw $out_dir/control_pca2.bw


# min depth: Minimum window length (in bp) to be considered to the left and to the right of each Hi-C bin. This number should be at least 3 times as large as the bin size of the Hi-C matrix
# max depth: Maximum window length to be considered to the left and to the right of the cut point in bp. This number should around 6-10 times as large as the bin size of the Hi-C matrix.
let min_depth=4*$res
let max_depth=9*$res


# removes previous tad scores
rm $out_dir/treatment_tad_score.bm
rm $out_dir/control_tad_score.bm


# finds TAD domains on treatment file, only needed for treatment matrix according to:
# https://hicexplorer.readthedocs.io/en/latest/content/tools/hicDifferentialTAD.html
hicFindTADs \
-m $treatment_corrected_matrix \
--outPrefix $out_dir/treatment \
--correctForMultipleTesting fdr \
--thresholdComparisons 0.1 \
--delta 0.05 \
--step $res \
--minDepth $min_depth \
--maxDepth $max_depth


# finds TAD domains on control file
hicFindTADs \
-m $control_corrected_matrix \
--outPrefix $out_dir/control \
--correctForMultipleTesting fdr \
--thresholdComparisons 0.003 \
--delta 0.05 \
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


# rename to .bed
mv $out_dir/differential_TAD_accepted.diff_tad $out_dir/differential_TAD_accepted.bed
mv $out_dir/differential_TAD_rejected.diff_tad $out_dir/differential_TAD_rejected.bed


# cp tracks.ini ./$out_dir

# uses tracks.ini file to plot hic matrices and TADs (tracks.ini file needs to be manually created)
pyGenomeTracks \
--tracks $out_dir/tracks.ini \
--out $out_dir/diff_tads.png \
--region chr20:35000000-45000000

# # this plots the interaction matrix along with 1st and 2nd eigenvectors
# hicPlotMatrix \
# -m $treatment_corrected_matrix \
# --bigwig $out_dir/treatment_pca2.bw \
# -o $out_dir/$treatment_name.png \
# --log1p \
# --chromosomeOrder 20

# # this plots the interaction matrix along with 1st and 2nd eigenvectors
# hicPlotMatrix \
# -m $control_corrected_matrix \
# --bigwig $out_dir/control_pca2.bw \
# -o $out_dir/$control_name.png \
# --log1p \
# --chromosomeOrder 20

# custom python script that finds average size TAD and number TADs per chromosome
python tad_stats.py -o $out_dir
