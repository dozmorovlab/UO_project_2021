#!/bin/bash
#SBATCH --partition=bgmp        ### Partition
#SBATCH --job-name=hicrep_%j      ### Job Name
#SBATCH --output=hicrep_%j.out         ### File in which to store job output
#SBATCH --error=hicrep_%j.err          ### File in which to store job error messages
#SBATCH --time=1-00:00:00       ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1               ### Number of nodes needed for the job
#SBATCH --ntasks-per-node=8     ### Number of tasks to be launched per Node
#SBATCH --account=bgmp      ### Account used for job submission
#SBATCH --mail-user='jlee26@uoregon.edu'
#SBATCH --mail-type=END,FAIL
export OMP_NUM_THREADS=8
conda activate VCU

dir=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/cool_files_100000/
outdir=/projects/bgmp/shared/2021_projects/VCU/hicrep/

for i in ${dir}*.cool; do
    for n in ${dir}*.cool ; do
        if [ "$i" \< "$n" ] || [ "$i" == "$n" ]; then # to pair each file once and to itself
            F1=${i##*/} # doesn't print full path. Only file name
            F2=${n##*/} 
            /usr/bin/time -v hicrep ${i} ${n} ${outdir}${F1:0:6}_${F2:0:6}.txt --h 1 --dBPMax 500000
            #echo "pair ${F1:0:6} and ${F2:0:6}"
        fi
    done
done