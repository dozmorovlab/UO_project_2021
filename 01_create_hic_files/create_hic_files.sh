#!/usr/bin/bash

source "../Utilities/Logging/logging.sh"

SBATCH_SRC="../Utilities/Slurm"

CONDA_ENV=hic
DEFAULT_SLURM_ACCOUNT=bgmp
DEFAULT_SLRUM_PARTITION=bgmp

function usage {
	echo "usage: create_hic_files.sh [-d data-directory] [-o output] [-a account] [-p partition]";
	echo 
	echo "[-d data-directory]			Root directory where data exists. All data should be located under this parent."
	echo "[-f input-files] 				Files to be converted to Hi-C (comma deliminated)"
	echo "[-r resolutions]				Resolutions for Hi-C files (comma deliminated)"
	echo "[-a account]					(optional) Slurm account"
	echo "[-p partition]				(optional) Slurm partition"
}

if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]
then
	log "FATAL" "Current environment is incorrect. Please run 'conda activate $CONDA_ENV'"
	exit 1
fi 

declare -xi resolutions=50000
declare -x account=$DEFAULT_SLURM_ACCOUNT
declare -x partition=$DEFAULT_SLRUM_PARTITION

while getopts "a:p:f:d:r:h:" opt
do
	case $opt in 
		a) account=$OPTARG; 		log "DEBUG" "Slurm account updated to: $slurm_account"		;;
		p) partition=$OPTARG;		log "DEBUG" "Slurm partition updated to: $slurm_partition" 	;;
		d) files=$OPTARG; 			log "DEBUG" "Files: $files" 								;;
		r) resolutions=$OPTARG;		log "DEBUG"	"Resolutions: $resolutions"						;;
		h) usage; exit 0 	;;
		\?) usage; exit 1	;;
	esac
done

test -z $files		&&	{ log	"ERROR" 	"Files not supplied.";	exit 1; }

declare -xa input_files=$(echo $files | tr '\n' ' ')
declare -xa output_files=()

declare -xi file_count=0
for file in $input_files
do
	test -f $file 		||	{ log	"ERROR" 	"$file does not exist.";	exit 1; }
	let "file_count++"	
	output_files+=("$(dirname $file)/$(basename $file -s).hic")
done

# uses input_files, output_files, file_count
sbatch "$SBATCH_SRC/array_create_hic.sb"

