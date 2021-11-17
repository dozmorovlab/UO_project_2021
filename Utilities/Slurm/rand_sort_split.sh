#!/usr/bin/bash

source '../Bash/logging.sh'

#default seed file (can overrite with dev/urandom for example)
declare -x seed_file="/dev/zero"

while getopts "a:p:f:s:o:" opt
do
	case $opt in 
		a) account=$OPTARG ;;
		p) partition=$OPTARG ;;
		f) file=$OPTARG ;;
		s) seed_file=$OPTARG ;;
		o) outdir=$OPTARG ;;
		*) exit 1 ;;

	esac
done

test -z $account	&&	{ log	"ERROR" 	"SLURM account not supplied.";		exit 1; }
test -z $partition	&&	{ log	"ERROR" 	"SLURM partition not supplied.";	exit 1; }

test -z $file		&&	{ log	"ERROR" 	"File not supplied.";				exit 1; }
test -f $file 		||	{ log	"ERROR" 	"File does not exist.";				exit 1; }

log "DEBUG" "Input file: $file"

test -z $seed_file	&&	{ log	"ERROR" 	"Seed File not supplied.";			exit 1; }

log "DEBUG" "Seed file: $seed_file"

test -d $outdir || { log "INFO" "Creating $outdir"; mkdir -p $outdir; }
log "DEBUG" "Outdir: $outdir"

declare -x randfile="$outdir/rand.$(basename $file)"
log "DEBUG" "Writing random sort file to: $randfile"
declare -x splitfile_prefix="$outdir/$(basename $file)"
# log "DEBUG" "Random sort file will be split into 2 files with $splitfile_prefix prefix."

# first split to create ~100 gb files


jid=`sbatch <<- SPLIT | egrep -o -e "\b[0-9]+$"
	#!/usr/bin/bash -l
	#SBATCH --account=$account
	#SBATCH --partition=$partition
	#SBATCH --output="split_origin_%j.out"
	#SBATCH --error="split_origin_%j.err"
	#SBATCH --mem=128G

	/usr/bin/time -v split $file -nr/4 -d --verbose "${splitfile_prefix}_"

SPLIT`

# log "INFO" "Waiting for SLURM Job: $jid"

# sort the small files

# sbatch sort_files.sh

# jid=`sbatch <<- SORT | egrep -o -e "\b[0-9]+$"
# 	#!/usr/bin/bash -l
# 	#SBATCH --job-name="Sort-Split-Files"
# 	#SBATCH --account=$account
# 	#SBATCH --partition=$partition
# 	#SBATCH --output="sort_%A_%a.out"
# 	#SBATCH --error="sort_%A_%a.err"
# 	#SBATCH --mem=128G
# 	#SBATCH --array=0-3
# 	#SBATCH --wait

# 	/usr/bin/time -v sort --random-sort --random-source=$seed_file --parallel=8 -S 128G "${splitfile_prefix}_0${SLURM_ARRAY_TASK_ID}" > "${randfile}_0${SLURM_ARRAY_TASK_ID}"

# SORT`

# log "INFO" "Waiting for SLURM Job: $jid"


# split the files in half 
# jid=`sbatch <<- EOF | egrep -o -e "\b[0-9]+$"
# 	#!/usr/bin/bash -l
# 	#SBATCH --account=$account
# 	#SBATCH --partition=$partition
# 	#SBATCH --output="rand_sort_split_%j.out"
# 	#SBATCH --error="rand_sort_split_%j.err"
# 	#SBATCH --mem=128G
# 	#SBATCH --array=0-1
# 	#SBATCH --wait

# 	/usr/bin/time -v sort --parallel=8 -m  > "splitfile_prefix="$outdir/$(basename $file)"

# EOF`



