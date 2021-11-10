#!/bin/bash

#parse command line arguments
for i in "$@"; do
    case $i in
		-r=*|--region=*) #region of interest on the chromosome
        REGION="${i#*=}"
        shift
		;;
		-o=*|--outdir=*) #absolute path to the directory to store output files
        OUTDIR="${i#*=}"
        shift
		;;
        -p=*|--picname=*) #absolute path to the directory to store output files
        PICNAME="${i#*=}"
        shift
		;;
		*)
        # unknown option
        ;;
    esac
done

echo "Region = ${REGION}"
echo "Output directory = ${OUTDIR}"

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument: $1"
    tail -1 $1
fi
# DIR_CR=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/CR/50000
# DIR_PR=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/primary/50000
# DIR_LM=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/LM/50000

# MYDIR_CR=/projects/bgmp/jlee26/bioinformatics/VCU/TADs/CR
# MYDIR_PR=/projects/bgmp/jlee26/bioinformatics/VCU/TADs/PR
# MYDIR_LM=/projects/bgmp/jlee26/bioinformatics/VCU/TADs/LM

# MYDIR=/projects/bgmp/jlee26/bioinformatics/VCU/TADs

# FILE=matrix_50000.cool

# REGION=1:20000000-80000000

## made edits to tracks.ini

### graph
pyGenomeTracks --tracks ${OUTDIR}/merged_tracks.ini -o ${OUTDIR}/${PICNAME} --region ${REGION}


### PR
#pyGenomeTracks --tracks ${MYDIR_PR}/PR_tracks.ini -o ${MYDIR_PR}/PR_track.png --region ${REGION}

### LM
#pyGenomeTracks --tracks ${MYDIR_LM}/LM_tracks.ini -o ${MYDIR_LM}/LM_track.png --region ${REGION}

### CR
#pyGenomeTracks --tracks ${MYDIR_CR}/CR_tracks.ini -o ${MYDIR_CR}/CR_track.png --region ${REGION}

echo "Finished!"