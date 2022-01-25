#!/bin/bash
#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output="%x_%j.out"
#SBATCH --error="%x_%j.err"
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --mem=128G


# want to try subsampling here (samtools -s)
module purge
module load samtools/1.5

bam_dir=/projects/bgmp/shared/2021_projects/VCU/data/bam_files


# primary bam file is 350G and livermet is 272G. The ratio primary:livermet is ~0.77
# here 42.77 is seed 42 and 77% chance of keeping each read. 
samtools view -b -s 42.77 $bam_dir/W30_Primary.fastq.gz.bam > $bam_dir/primary_half.bam

samtools view -c $bam_dir/primary_half.bam
samtools view -c $bam_dir/W30_LiverMet.fastq.gz.bam




