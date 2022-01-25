#!/bin/bash
#SBATCH --partition=bgmp
#SBATCH --account=bgmp
#SBATCH --job-name=bam_compare
#SBATCH --output=bam_compare_%j.out
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=120G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jogata@uoregon.edu

conda activate deeptools

name1=livermet
name2=primary

# file paths for bam files
bam1=/projects/bgmp/shared/2021_projects/VCU/data/bam_files/sorted_W30_LiverMet.fastq.gz.bam
bam2=/projects/bgmp/shared/2021_projects/VCU/data/bam_files/sorted_primary_third.bam



###################################
# creates bedgraph compare file
###################################

bamCompare \
--bamfile1 $bam1 \
--bamfile2 $bam2 \
--outFileName compared_primary_third_livermet.bedgraph \
--outFileFormat bedgraph \
--scaleFactorsMethod None \
--skipZeroOverZero \
--exactScaling

###################################
###################################





####################################
# plots bam files
####################################

plotCoverage \
--bamfiles $bam1 $bam2 \
--labels $name1 $name2 \
-o compared_plot.png

####################################
####################################
