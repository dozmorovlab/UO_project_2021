#!/usr/bin/bash -l
#SBATCH --job-name="Sort-Split-Files"
#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output="sort_%A_%a.out"
#SBATCH --error="sort_%A_%a.err"
#SBATCH --time=24:00:00
#SBATCH --mem=128G
#SBATCH --array=0-3
#SBATCH --wait

/usr/bin/time -v sort --random-sort --random-source=$seed_file --parallel=8 -S 128G "${splitfile_prefix}_0${SLURM_ARRAY_TASK_ID}" > "${randfile}_0${SLURM_ARRAY_TASK_ID}"
