#!/usr/bin/bash
#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output="%x_%j.out"
#SBATCH --error="%x_%j.err"
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1

test -d $$ || mkdir $$
s=100000
/usr/bin/time -v fanc pca -n $(ls /projects/bgmp/shared/2021_projects/VCU/hic_week1/* | grep ".*.hic$" | tr '\n' ' ') -Z -s $s -p "$$/$$.png" $(ls -d /projects/bgmp/shared/2021_projects/VCU/hic_week1/* | grep ".*.hic$") "$$/$$_output.tsv"