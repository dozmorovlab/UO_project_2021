#!/usr/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output="%x_%j.out"
#SBATCH --error="%x_%j.err"
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1

# TODO
# /projects/bgmp/shared/2021_projects/VCU/hic_week1
# 

function usage {
	echo "usage: calc_scc.sh [-i, --input-directory] [-o, --output-directory] [-f, --force] [-m, --metafile]";
}

# inspried by https://stackoverflow.com/questions/48086633/simple-logging-levels-in-bash
declare -A error_levels=([DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3 [FATAL]=4)
script_logging_level="DEBUG"

function log {
    local log_priority=$1
	local log_message=$2

    #check if level exists
    [[ ${error_levels[$log_priority]} ]] || return 1;
    #check if level is enough
    (( ${error_levels[$log_priority]} < ${error_levels[$script_logging_level]} )) && return 2
    #log here. Could change this to write to file?
    echo "${log_priority}: ${log_message}"
}

function abort {
	local log_message=$1
	local error_code=$2
	log "FATAL" "$log_message $error_code"
	exit $error_code
}

if [ $# -eq 0 ]; then
	log "ERROR" "No arguments provided."
	usage
	exit 1
fi


declare -- FORCE=false
while [ "" != "$1" ]; do
	case $1 in 
		-i | --input-directory)
			shift
			declare -r DIRECTORY=$1
			log "DEBUG" "Directory: $DIRECTORY"
			;;

		-o | --output-directory)
			shift
			declare -r OUTPUT=$1
			log "DEBUG" "Output: $OUTPUT"
			;;

		-f | --force)
			FORCE=true
			log "DEBUG" "Force parameter turned on."
			;;

		-m | --metafile)
			shift
			declare -r METADATA=$1 # File name, friendly name
			log "DEBUG" "Metadata: $METADATA"
			;;

		-h | --help)
			usage
			exit 0
			;;

		*)
			usage
			exit 1
			;;
	esac
	shift
done

test -z $DIRECTORY	&&	{ log	"ERROR" 	"Hic Directory not supplied.";		exit 1; }
test -d $DIRECTORY 	||	{ log	"ERROR" 	"Hic Directory does not exist.";	exit 1; }

test -z $METADATA	&&	{ log	"ERROR" 	"Metadata not supplied.";			exit 1; }
test -f $METADATA 	||	{ log	"ERROR" 	"Metadata does not exist.";			exit 1; }

test -z $OUTPUT		&&	{ log	"ERROR" 	"Output Directory not supplied.";	exit 1; }

test -d	$OUTPUT		&& 	{ 
	if [[ $FORCE -eq false ]]; then 
		repeat=true
		while ! (test -z $repeat); do
			log "WARN" "Output directory exists. Overwrite? [Y/n/c]: "	
			read choice		
			case $choice in 
				n | c)
					# 'n' could mean create new named directory?
					log "INFO" "User terminated."
					exit 0
					;;

				Y)
					repeat=false
					;;

				*)
					log "ERROR" "Invalid input."
					;;
			esac
		done
	fi
}

# change this?
tmp="$DIRECTORY/../calc_scc_tmp-$$"
test -d $tmp && rm -rf $tmp
mkdir $tmp

log "INFO" "Converting .hic files to .cool files."

# just pull out the ids for now, this should really be done beforehand
tail -n +2 $METADATA | cut -d, -f 2,2 | while read id
do
	log "DEBUG" "id=$id"
	matrix="$DIRECTORY/$id.hic"
	log "DEBUG" "hicConvertFormat converting file: $matrix"

	dest="$tmp/$id.cool"
	hicConvertFormat -m $matrix --inputFormat hic --outputFormat cool -o $dest --resolutions 10000

	if [[ $? != 0 ]]; then 
		# Exit for now
		rm -rf $tmp
		abort "hicConvertFormat failed on $file" $?
	fi
done

# at this point it is safe to remove output directory if it exists
test -d $OUTPUT && rm -rf $OUTPUT
mkdir $OUTPUT

log "INFO" "Converting .cool files to .scc files."
for fcool1 in $(ls $tmp)
do
	for fcool2 in $(ls $tmp)
	do
		if [ "$fcool1" != "$fcool2" ]
		then

			log "DEBUG" "hicrep calculating scc for: $fcool1 $fcool2"
			hicrep "$tmp/$fcool1" "$tmp/$fcool2" "$OUTPUT/$fcool1_$fcool2.scc.txt" --binSize 10000 --h 1 --dBPMax 500000 
		fi 
	done
done

#clean up
rm -rf $tmp

echo "Program Complete!"
exit 0