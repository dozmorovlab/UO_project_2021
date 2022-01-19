#!/bin/bash
#SBATCH --partition=bgmp        ### Partition
#SBATCH --job-name=dc      ### Job Name
#SBATCH --output=dc_%j.out         ### File in which to store job output
#SBATCH --error=dc_%j.err          ### File in which to store job error messages
#SBATCH --time=1-00:00:00       ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1               ### Number of nodes needed for the job
#SBATCH --cpus-per-task=1
#SBATCH --account=bgmp      ### Account used for job submission
#SBATCH --mail-user='jlee26@uoregon.edu'
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=130G

# conda activate dchic

echo "###############cis"
Rscript dchicf.r --file ./input.txt --pcatype cis --dirovwt T --cthread 2 --pthread 4

echo "###############select"
Rscript dchicf.r --file ./input.txt --pcatype select --dirovwt T --genome hg38

echo "###############analyze"
Rscript dchicf.r --file ./input.txt --pcatype analyze --dirovwt T --diffdir PR_vs_LM_50Kb

# echo "###############fithic"
# Rscript dchicf.r --file ./input.txt --pcatype fithic --dirovwt T --diffdir PR_vs_LM_50Kb --fithicpath "/path/to/fithic.py" --pythonpath "/path/to/python"

echo "###############dloop"
Rscript dchicf.r --file ./input.txt --pcatype dloop --dirovwt T --diffdir PR_vs_LM_50Kb

echo "###############subcomp"
Rscript dchicf.r --file ./input.txt --pcatype subcomp --dirovwt T --diffdir PR_vs_LM_50Kb

echo "###############viz"
Rscript dchicf.r --file ./input.txt --pcatype viz --diffdir PR_vs_LM_50Kb --genome hg38 

echo "###############enrich"
Rscript dchicf.r --file ./input.txt --pcatype enrich --genome hg38 --diffdir PR_vs_LM_50Kb --exclA F --region both --pcgroup pcQnm --interaction intra --pcscore F --compare F

