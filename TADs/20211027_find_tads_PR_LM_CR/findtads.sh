#!/bin/bash

#parse command line arguments
for i in "$@"; do
    case $i in
        -p=*|--prfile=*) #absolute path to the primary.cool file
        PRFILE="${i#*=}"
        shift
        ;;
        -l=*|--lmfile=*) #absolute path to the livermet.cool file
        LMFILE="${i#*=}"
        shift
        ;;
		-c=*|--crfile=*) #absolute path to the carboplatin_resistant.cool file
        CRFILE="${i#*=}"
        shift
		;;
		-o=*|--outdir=*) #absolute path to the directory to store output files
        OUTDIR="${i#*=}"
        shift
		;;
        *)
        # unknown option
        ;;
    esac
done
echo "Primary file = ${PRFILE}"
echo "LM file = ${LMFILE}"
echo "CR file = ${CRFILE}"
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

#REGION=1:20000000-80000000

#FILE=matrix_50000.cool

###PR
hicFindTADs --matrix ${PRFILE} --outPrefix ${OUTDIR}/PR --correctForMultipleTesting fdr --minDepth 150000 --maxDepth 500000 --step 50000 --thresholdComparisons 0.05 --delta 0.01

###CR
hicFindTADs --matrix ${CRFILE} --outPrefix ${OUTDIR}/CR --correctForMultipleTesting fdr --minDepth 150000 --maxDepth 500000 --step 50000 --thresholdComparisons 0.05 --delta 0.01

###LM
hicFindTADs --matrix ${LMFILE} --outPrefix ${OUTDIR}/LM --correctForMultipleTesting fdr --minDepth 150000 --maxDepth 500000 --step 50000 --thresholdComparisons 0.05 --delta 0.01


# pygenometracks

### PR
make_tracks_file --trackFiles ${PRFILE} ${OUTDIR}/PR_tad_score.bm ${OUTDIR}/PR_domains.bed -o ${OUTDIR}/PR_tracks.ini

### CR
make_tracks_file --trackFiles ${CRFILE} ${OUTDIR}/CR_tad_score.bm ${OUTDIR}/CR_domains.bed -o ${OUTDIR}/CR_tracks.ini

### LM
make_tracks_file --trackFiles ${LMFILE} ${OUTDIR}/LM_tad_score.bm ${OUTDIR}/LM_domains.bed -o ${OUTDIR}/LM_tracks.ini

# success!

#hicPlotTADs --tracks ${MYDIR}/${FILE}_tracks.ini --region chr1:20000000-80000000 -o ${MYDIR}/${FILE}_track.png

### create merged track
make_tracks_file --trackFiles ${PRFILE} ${OUTDIR}/PR_tad_score.bm ${OUTDIR}/PR_domains.bed ${LMFILE} ${OUTDIR}/LM_tad_score.bm ${OUTDIR}/LM_domains.bed ${CRFILE} ${OUTDIR}/CR_tad_score.bm ${OUTDIR}/CR_domains.bed -o ${OUTDIR}/merged_tracks.ini

echo "Finished!"