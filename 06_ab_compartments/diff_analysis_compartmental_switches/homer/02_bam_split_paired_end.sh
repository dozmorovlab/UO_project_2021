#!/bin/bash
# adapted from original author: Istvan Albert
# website: https://www.biostars.org/p/92935/

HOMER=/projects/bgmp/jlee26/bioinformatics/VCU/AB_compartments/diff_analysis/homer

set -ue

# Get the bam file from the command line
# how to use: sh bam_split_paired_end.sh /path/to/bam/file /path/to/output
BAM=$1
TARGET_D=$2

FILE=$(basename $BAM)
NAME=${FILE%.*}
BAMF1=${TARGET_D}/${NAME}_fwd1.bam
BAMF2=${TARGET_D}/${NAME}_fwd2.bam
BAMF=${TARGET_D}/${NAME}_fwd.bam
SORTF1=${TARGET_D}/${NAME}_fwd1_sorted.bam
SORTF2=${TARGET_D}/${NAME}_fwd2_sorted.bam
SORTF=${TARGET_D}/${NAME}_fwd_sorted.bam
BAMR1=${TARGET_D}/${NAME}_rev1.bam
BAMR2=${TARGET_D}/${NAME}_rev2.bam
BAMR=${TARGET_D}/${NAME}_rev.bam
SORTR1=${TARGET_D}/${NAME}_rev1_sorted.bam
SORTR2=${TARGET_D}/${NAME}_rev2_sorted.bam
SORTR=${TARGET_D}/${NAME}_rev_sorted.bam

# Forward strand.
#
# 1. alignments of the second in pair if they map to the forward strand
# 2. alignments of the first in pair if they map to the reverse  strand
#
samtools view -bh -f 128 -F 16 $BAM > ${BAMF1}
samtools sort ${BAMF1} > ${SORTF1}
samtools index ${SORTF1}

samtools view -bh -f 80 $BAM > ${BAMF2}
samtools sort ${BAMF2} > ${SORTF2}
samtools index ${SORTF2}

#
# Combine alignments that originate on the forward strand.
#
samtools merge -f ${BAMF} ${BAMF1} ${BAMF2}
samtools sort ${BAMF} > ${SORTF}
samtools index ${SORTF}

# Reverse strand
#
# 1. alignments of the second in pair if they map to the reverse strand
# 2. alignments of the first in pair if they map to the forward strand
#
samtools view -bh -f 144 $BAM > ${BAMR1}
samtools sort ${BAMR1} > ${SORTR1}
samtools index ${SORTR1}

samtools view -bh -f 64 -F 16 $BAM > ${BAMR2}
samtools sort ${BAMR2} > ${SORTR2}
samtools index ${SORTR2}

#
# Combine alignments that originate on the reverse strand.
#
samtools merge -f ${BAMR} ${BAMF1} ${BAMR2}
samtools sort ${BAMR} > ${SORTR}
samtools index ${SORTR}