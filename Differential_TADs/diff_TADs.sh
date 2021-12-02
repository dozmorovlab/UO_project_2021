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

conda activate hicexplorer

##### Options #####
treatment_name=livermet #sample name
control_name=primary
res=25000               #resolution
out_dir=./diff_TADs     #out directory
treatment_hic_matrix=/projects/bgmp/shared/2021_projects/VCU/week2/livermet_merged/inter_25_50.hic
control_hic_matrix=/projects/bgmp/shared/2021_projects/VCU/week2/primary_merged/inter_25_50.hic

##### Names #####
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



# Documentation for ICE correction -- https://hicexplorer.readthedocs.io/en/latest/content/tools/hicCorrectMatrix.html
# ICE correction for treatment matrix
hicCorrectMatrix correct -m $treatment_cool_matrix -o $out_dir/ICE_corrected_$treatment_name.cool --filterThreshold -1 5 --correctionMethod ICE 

# ICE correction for control matrix
hicCorrectMatrix correct -m $control_cool_matrix -o $out_dir/ICE_corrected_$control_name.cool --filterThreshold -1 5 --correctionMethod ICE 



# Have tried many different combinations here, like 5 and 5, 3 and 7, 1 and 1, etc. 
let min_depth=4*res
let max_depth=10*res

# finds TAD domains on treatment file, only needed for treatment matrix according to documentation --
# https://hicexplorer.readthedocs.io/en/latest/content/tools/hicDifferentialTAD.html
# Have tried many different combinations of thresholdcompartisons, delta, and correctForMultipleTesting
hicFindTADs \
-m $treatment_corrected_matrix \
--outPrefix $out_dir/treatment \
--correctForMultipleTesting None \
--thresholdComparisons 0.01 \
--delta 0.01 \
--minDepth $min_depth \
--maxDepth $max_depth


# Differential TAD documentation -- https://hicexplorer.readthedocs.io/en/latest/content/tools/hicDifferentialTAD.html
# have tried p-values of 0.01 and 0.05
hicDifferentialTAD \
--targetMatrix $treatment_corrected_matrix \
--controlMatrix $control_corrected_matrix \
--tadDomains $out_dir/treatment_domains.bed \
--pValue 0.01 \
-o $out_dir/differential_TAD



# convert the output of differential TAD to a .bed file
mv $out_dir/differential_TAD_accepted.diff_tad $out_dir/differential_TAD_accepted.bed
mv $out_dir/differential_TAD_rejected.diff_tad $out_dir/differential_TAD_rejected.bed


# pygemonetracks documentation -- https://pygenometracks.readthedocs.io/en/latest/content/examples.html#examples-with-hi-c-data
pyGenomeTracks \
--tracks $out_dir/tracks.ini \
--out $out_dir/diff_tads.png \
--region chrX:34175000-63800000
