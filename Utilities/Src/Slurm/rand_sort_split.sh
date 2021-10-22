#!/usr/bin/bash

source '../Bash/logging.sh'

#default seed file (can overrite with dev/urandom for example)
seed_file="/dev/zero"

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

randfile="$outdir/rand.$(basename $file)"
log "DEBUG" "Writing random sort file to: $randfile"
splitfile_prefix="$outdir/$(basename $file)_"
log "DEBUG" "Random sort file will be split into 2 files with $splitfile_prefix prefix."

jid=`sbatch <<- EOF | egrep -o -e "\b[0-9]+$"
	#!/usr/bin/bash -l
	#SBATCH --account=$account
	#SBATCH --partition=$partition
	#SBATCH --output="rand_sort_split_%j.out"
	#SBATCH --error="rand_sort_split_%j.err"
	#SBATCH --cpus-per-task=8
	#SBATCH --nodes=1
	#SBATCH --mem=16G

	randfile="$outdir/rand.$(basename $file)"
	splitfile_prefix="$outdir/$(basename $file)_"

	/usr/bin/time -v sort --random-sort --random-source=$seed_file $file > $randfile
	/usr/bin/time -v split $randfile -n2 -d --verbose $splitfile_prefix

	EOF`


log "INFO" "Started SLURM Job: $jid"