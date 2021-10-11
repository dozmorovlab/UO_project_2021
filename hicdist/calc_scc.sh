#!/usr/bin/bash

# TODO
# /projects/bgmp/shared/2021_projects/VCU/hic_week1
# 

function usage {
	echo "usage: calc_scc.sh [-d, --input-directory] [-o, --output-directory] [-f, --force]";
}

# inspried by https://stackoverflow.com/questions/48086633/simple-logging-levels-in-bash
declare -A error_levels=([DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3 [FATAL]=4)
script_logging_level="INFO"

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
		-d | --input-directory)
			shift
			DIRECTORY=$1
			log "DEBUG" "Directory: $DIRECTORY"
			;;

		-o | --output-directory)
			shift
			OUTPUT=$1
			log "DEBUG" "Output: $OUTPUT"
			;;

		-f | --force)
			FORCE=true
			log "DEBUG" "Force parameter turned on."
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

test -z $OUTPUT		&&	{ log	"ERROR" 	"Output Directory not supplied.";	exit 1; }

test -d	$OUTPUT		&& 	{ 
	if [[ $FORCE -eq false ]]; then 
		local repeat=true
		while [[ $repeat ]]; do
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
tmp="$DIRECTORY/../cool_files/cool-$$"
test -d $tmp && rm -rf $tmp
mkdir $tmp

log "INFO" "Converting .hic files to .cool files."

for file in $(ls $DIRECTORY)
do
	# check last 4 characters for extension (alternatively, *.hic)
	if [[ ${file: -4} == ".hic" ]]
	then
		log "DEBUG" "Converting $file."
		target="$DIRECTORY/$file"
		dest="$tmp/$file"
		hicConvertFormat -m $target --inputFormat hic --outputFormat cool -o $dest --resolutions 10000

		# if [[ $? != 0 ]]; then 
		# 	# Exit for now
		# 	rm -rf $tmp
		# 	abort "hicConvertFormat failed on $file" $?
		# fi
	fi
done

exit 0

# at this point it is safe to remove output directory if exists
# test -d $OUTPUT && rm -rf $OUTPUT
# mkdir $OUTPUT

# log "INFO" "Converting .cool files to .scc files."
# for file in $(ls $DIRECTORY)
# do
# 	# check last 6 characters for extension (alternatively, *.mcool)
# 	if [[ ${file: -5} == ".cool"]]; then
# 		log "DEBUG" "Converting $file."
# 		hicrep $fmcool1 $fmcool2 outputSCC.txt --binSize 10000 --h 1 --dBPMax 500000  
# 	fi
# done

