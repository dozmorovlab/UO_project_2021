#!/bin/bash
#SBATCH --partition=bgmp        ### Partition
#SBATCH --job-name=tads      ### Job Name
#SBATCH --output=tads_%j.out         ### File in which to store job output
#SBATCH --error=tads_%j.err          ### File in which to store job error messages
#SBATCH --time=1-00:00:00       ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1               ### Number of nodes needed for the job
#SBATCH --cpus-per-task=1
#SBATCH --account=bgmp      ### Account used for job submission
#SBATCH --mail-user='jlee26@uoregon.edu'
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=50G

conda activate hicexplorer

DIR_CR=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/CR/50000
DIR_PR=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/primary/50000
DIR_LM=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/LM/50000

MYDIR_CR=/projects/bgmp/jlee26/bioinformatics/VCU/TADs/CR
MYDIR_PR=/projects/bgmp/jlee26/bioinformatics/VCU/TADs/PR
MYDIR_LM=/projects/bgmp/jlee26/bioinformatics/VCU/TADs/LM

REGION=1:20000000-80000000

FILE=matrix_50000.cool

# normalize data
# hicNormalize --matrices ${DIR}/hicexplorer/cool_files_50000/${FILE}.cool --normalize norm_range --outFileName ${MYDIR}/${FILE}_0_1_range.cool

# correct data
# hicCorrectMatrix diagnostic_plot --matrix ${MYDIR}/${FILE}_0_1_range.cool --plotName ${MYDIR}/${FILE}_diagnostic_plot.png --verbose

# hicCorrectMatrix correct --matrix ${MYDIR}/${FILE}_0_1_range.cool --filterThreshold -2 5 --outFileName ${MYDIR}/${FILE}_corrected.cool --correctionMethod ICE --verbose

#hicPlotMatrix --matrix ${DIR}/hicexplorer/cool_files_50000/${FILE}.cool --outFileName ${MYDIR}/${FILE}_hicplot.png --log1p --region 1:20000000-80000000

#hicFindTADs --matrix ${DIR}/hicexplorer/cool_files_50000/${FILE}.cool --outPrefix ${FILE} --correctForMultipleTesting fdr --minDepth 150000 --maxDepth 500000 --step 50000 --thresholdComparisons 0.05 --delta 0.01

###PR
hicFindTADs --matrix ${DIR_PR}/${FILE} --outPrefix ${MYDIR_PR}/PR --correctForMultipleTesting fdr --minDepth 150000 --maxDepth 500000 --step 50000 --thresholdComparisons 0.05 --delta 0.01

###CR
hicFindTADs --matrix ${DIR_CR}/${FILE} --outPrefix ${MYDIR_CR}/CR --correctForMultipleTesting fdr --minDepth 150000 --maxDepth 500000 --step 50000 --thresholdComparisons 0.05 --delta 0.01

###LM
hicFindTADs --matrix ${DIR_LM}/${FILE} --outPrefix ${MYDIR_LM}/LM --correctForMultipleTesting fdr --minDepth 150000 --maxDepth 500000 --step 50000 --thresholdComparisons 0.05 --delta 0.01


conda deactivate
conda activate pygenometracks

#make_tracks_file --trackFiles ${MYDIR}/${FILE}_corrected.cool ${MYDIR}/${FILE}_domains.bed -o ${MYDIR}/${FILE}_tracks.ini
### PR
make_tracks_file --trackFiles ${DIR_PR}/${FILE} ${MYDIR_PR}/PR_tad_score.bm ${MYDIR_PR}/PR_domains.bed -o ${MYDIR_PR}/PR_tracks.ini

### CR
make_tracks_file --trackFiles ${DIR_CR}/${FILE} ${MYDIR_CR}/CR_tad_score.bm ${MYDIR_CR}/CR_domains.bed -o ${MYDIR_CR}/CR_tracks.ini

### LM
make_tracks_file --trackFiles ${DIR_LM}/${FILE} ${MYDIR_LM}/LM_tad_score.bm ${MYDIR_LM}/LM_domains.bed -o ${MYDIR_LM}/LM_tracks.ini

# success!

#pyGenomeTracks --tracks ${MYDIR}/${FILE}_tracks1.ini -o ${MYDIR}/${FILE}_track1.png --region chr1:20000000-80000000

#hicPlotTADs --tracks ${MYDIR}/${FILE}_tracks.ini --region chr1:20000000-80000000 -o ${MYDIR}/${FILE}_track.png

### create merged track
make_tracks_file --trackFiles ${DIR_PR}/${FILE} ${MYDIR_PR}/PR_tad_score.bm ${MYDIR_PR}/PR_domains.bed ${DIR_LM}/${FILE} ${MYDIR_LM}/LM_tad_score.bm ${MYDIR_LM}/LM_domains.bed ${DIR_CR}/${FILE} ${MYDIR_CR}/CR_tad_score.bm ${MYDIR_CR}/CR_domains.bed -o ${MYDIR}/tracks.ini
