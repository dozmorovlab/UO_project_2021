#!/usr/bin/bash

source "../Utilities/Logging/logging.sh"

CONDA_ENV=qc
DEFAULT_SLURM_ACCOUNT=bgmp
DEFAULT_SLRUM_PARTITION=bgmp

declare -x slurm_account=$DEFAULT_SLURM_ACCOUNT
declare -x slurm_partition=$DEFAULT_SLRUM_PARTITION
declare -x cool_directory=cool_files
declare -x current_directory=$(pwd)

function usage {
	echo "usage: replicate_quality_analysis.sh [-d data-directory] [-o output] [-a account] [-p partition]";
	echo 
	echo "[-d data-directory]			Root directory where data exists. All data should be located under this parent."
	echo "[-f input-file] 				CSV file containing hic files to visualize. See Readme for more information."
	echo "[-r resolutions]				Resolutions for Hi-C files (comma deliminated)"
	echo "[-a account]					(optional) Slurm account"
	echo "[-p partition]				(optional) Slurm partition"
}

if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]
then
	log "FATAL" "Current environment is incorrect. Please run 'conda activate $CONDA_ENV'"
	exit 1
fi 

while getopts "a:p:f:d:r:h:" opt
do
	case $opt in 
		a) slurm_account=$OPTARG; 	log "DEBUG" "Slurm account updated to: $slurm_account"		;;
		p) slurm_partition=$OPTARG;	log "DEBUG" "Slurm partition updated to: $slurm_partition" 	;;
		d) datadir=$OPTARG; 		log "DEBUG" "Data directory: $datadir" 	;;
		f) metadata=$OPTARG; 		log "DEBUG" "Metadata: $metadata"		;;
		r) resolutions=$OPTARG;		log "DEBUG"	"Resolutions: $resolutions"	;;
		h) usage; exit 0 	;;
		\?) usage; exit 1	;;
	esac
done

test -v metadata 	||	{ log	"ERROR" 	"Metadata file not supplied.";	usage; 	exit 1; }
test -f $metadata 	&& metadata="$current_directory/$metadata" || { 
	log	"INFO"		"Metadata file $metadata not found in $current_directory, searching for $metadata in $datadir";
	test -f "$datadir/$metadata" && {
		log "INFO" "Found metadata file in $datadir/$metadata, using this file.";		
		metadata="$datadir/$metadata";
	} || { 
		log "ERROR" "Metadata file $metadata could not be found."; 
		exit 1; 
	}
}

# 1) Convert to cool files

test -d $cool_directory || { log "DEBUG" "Creating directory for cool files: $cool_directory"; mkdir $cool_directory; }



ls -1 $data_dir | grep '.hic' | while read file;
do
hicConvertFormat \
--matrices $data_dir/$file \
--inputFormat hic \
--outFileName $out_dir/$(echo $file | cut -f1 -d.)_resolution.cool \
--outputFormat cool \
--resolutions $res;
done

log "INFO" "Creating PCA plots."

PCA_CMD="cd PCA; bash ./pca.sh -m $metadata -o $current_directory/pca_plots -i $datadir; cd $output_directory"
eval $PCA_CMD

