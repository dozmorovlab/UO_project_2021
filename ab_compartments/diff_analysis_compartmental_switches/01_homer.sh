#!/bin/bash
#SBATCH --partition=bgmp        ### Partition
#SBATCH --job-name=split      ### Job Name
#SBATCH --output=split_%j.out         ### File in which to store job output
#SBATCH --error=split_%j.err          ### File in which to store job error messages
#SBATCH --time=1-00:00:00       ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1               ### Number of nodes needed for the job
#SBATCH --cpus-per-task=1
#SBATCH --account=bgmp      ### Account used for job submission
#SBATCH --mail-user='jlee26@uoregon.edu'
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=100G
# conda activate homer

BAMDIR=/projects/bgmp/shared/2021_projects/VCU/week2/downloads
HOMER=/projects/bgmp/jlee26/bioinformatics/VCU/AB_compartments/diff_analysis/homer
PR=${HOMER}/PR
LM=${HOMER}/LM

# subsample 25% of the original .bam files to new .bam file 
samtools view -bs 0.25 ${BAMDIR}/W30_Primary.fastq.gz.bam > ${HOMER}/PR_subsample.bam
samtools view -bs 0.25 ${BAMDIR}/W30_LiverMet.fastq.gz.bam > ${HOMER}/LM_subsample.bam

# create read1 and read2 files for subsampled PR and LM files
sh ${HOMER}/bam_split_paired_end.sh ${HOMER}/PR_subsample.bam ${HOMER}/split1
sh ${HOMER}/bam_split_paired_end.sh ${HOMER}/LM_subsample.bam ${HOMER}/split1

# convert .bam to .sam (to use for HOMER)
samtools view -h ${HOMER}/split1/PR_subsample_fwd.bam > ${HOMER}/split1/PR_subsample_fwd.sam
samtools view -h ${HOMER}/split1/PR_subsample_rev.bam > ${HOMER}/split1/PR_subsample_rev.sam
samtools view -h ${HOMER}/split1/LM_subsample_fwd.bam > ${HOMER}/split1/LM_subsample_fwd.sam
samtools view -h ${HOMER}/split1/LM_subsample_rev.bam > ${HOMER}/split1/LM_subsample_rev.sam

# Using HOMER, create makeTagDirectory
makeTagDirectory ${HOMER}/split1/PRHicTagDir/ ${HOMER}/split1/PR_subsample_fwd.sam,${HOMER}/split1/PR_subsample_rev.sam -tbp 1
makeTagDirectory ${HOMER}/split1/LMHicTagDir/ ${HOMER}/split1/LM_subsample_fwd.sam,${HOMER}/split1/LM_subsample_rev.sam -tbp 1

# Analyze makeTagDirectory for PR and LM
analyzeHiC ${HOMER}/split1/PRHicTagDir/ -pos chr20:35,000,000-60,000,000 -res 50000 -window 100000 -balance > ${HOMER}/split1/PRoutput_chr20_analyzeHiC.txt
analyzeHiC ${HOMER}/split1/LMHicTagDir/ -pos chr20:35,000,000-60,000,000 -res 50000 -window 100000 -balance > ${HOMER}/split1/LMoutput_chr20_analyzeHiC.txt

# Perform PC analysis for PR and LM
runHiCpca.pl auto ${HOMER}/split1/PRHicTagDir/ -res 50000 -window 100000 -cpu 10 -pc 2 -genome hg38
runHiCpca.pl auto ${HOMER}/split1/LMHicTagDir/ -res 50000 -window 100000 -cpu 10 -pc 2 -genome hg38

# merge all bedGraph into one text files
annotatePeaks.pl ${HOMER}/split1/PRHicTagDir/PRHicTagDir.50x100kb.PC1.txt hg38 -noblanks -bedGraph ${HOMER}/split1/PRHicTagDir/PRHicTagDir.50x100kb.PC1.bedGraph ${HOMER}/split1/LMHicTagDir/LMHicTagDir.50x100kb.PC1.bedGraph > ${HOMER}/split1/output_annotatePeaks.txt

# getDiffExpression.pl ${HOMER}/split1/output_annotatePeaks.txt PR CL -pc1 -export regions > ${HOMER}/split1/output2_getDiffExpression.txt
### didn't work b/c there's no replicates. This script combines different replicates. (only 1 PR and 1 CL)

# Find compartments (only negative eigenvectors)
findHiCCompartments.pl ${HOMER}/split1/PRHicTagDir/PRHicTagDir.50x100kb.PC1.txt -opp > ${HOMER}/split1/PR_compartments.txt
# findHiCCompartments.pl ${HOMER}/split1/PRHicTagDir/PRHicTagDir.50x100kb.PC1.txt -bg ${HOMER}/split1/LMHicTagDir/LMHicTagDir.50x100kb.PC1.txt -opp > ${HOMER}/split1/compartment_switches.txt #results negative AND positive eigenvectors
findHiCCompartments.pl ${HOMER}/split1/LMHicTagDir/LMHicTagDir.50x100kb.PC1.txt -opp > ${HOMER}/split1/LM_compartments.txt

# Correlation difference to determine A and B compartmental differences between PR and LM
# getHiCcorrDiff.pl ${HOMER}/split1/output_corrDiff ${HOMER}/split1/PRHicTagDir/ ${HOMER}/split1/LMHicTagDir/ -cpu 8 -res 50000
getHiCcorrDiff.pl ${HOMER}/split1/output_corrDepth1 ${HOMER}/split1/PRHicTagDir/ ${HOMER}/split1/LMHicTagDir/ -cpu 8 -res 50000 -corrDepth 1
####problem: still cannot find difference in compartments.
