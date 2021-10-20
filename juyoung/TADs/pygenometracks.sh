#!/bin/bash
#SBATCH --partition=bgmp        ### Partition
#SBATCH --job-name=pygen      ### Job Name
#SBATCH --output=pygen_%j.out         ### File in which to store job output
#SBATCH --error=pygen_%j.err          ### File in which to store job error messages
#SBATCH --time=1-00:00:00       ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1               ### Number of nodes needed for the job
#SBATCH --cpus-per-task=1
#SBATCH --account=bgmp      ### Account used for job submission
#SBATCH --mail-user='jlee26@uoregon.edu'
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=20G

conda activate pygenometracks

DIR_CR=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/CR/50000
DIR_PR=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/primary/50000
DIR_LM=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/LM/50000

MYDIR_CR=/projects/bgmp/jlee26/bioinformatics/VCU/TADs/CR
MYDIR_PR=/projects/bgmp/jlee26/bioinformatics/VCU/TADs/PR
MYDIR_LM=/projects/bgmp/jlee26/bioinformatics/VCU/TADs/LM

MYDIR=/projects/bgmp/jlee26/bioinformatics/VCU/TADs

FILE=matrix_50000.cool

REGION=1:20000000-80000000

## made edits to tracks.ini

### graph
pyGenomeTracks --tracks ${MYDIR}/tracks.ini -o ${MYDIR}/hic_track.png --region ${REGION}


### PR
#pyGenomeTracks --tracks ${MYDIR_PR}/PR_tracks.ini -o ${MYDIR_PR}/PR_track.png --region ${REGION}

### LM
#pyGenomeTracks --tracks ${MYDIR_LM}/LM_tracks.ini -o ${MYDIR_LM}/LM_track.png --region ${REGION}

### CR
#pyGenomeTracks --tracks ${MYDIR_CR}/CR_tracks.ini -o ${MYDIR_CR}/CR_track.png --region ${REGION}
