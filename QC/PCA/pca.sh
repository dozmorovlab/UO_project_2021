function usage {
	echo "usage: pca.sh [-m, --metafile] [-i, --input-directory] [-o, --output-directory] [-f, --force]";
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

FORCE=false
while [ "" != "$1" ]; do
	case $1 in 
		-m | --metafile)
			shift
			declare -r METADATA=$1 # File name, friendly name
			log "DEBUG" "Metadata: $METADATA"
			;;

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

declare -i n=$(tail -n +2 $METADATA | wc -l)
declare -a ids=()
for i in $(tail -n +2 $METADATA | cut -d, -f 2,2 | tr '\n' ' ')
do
	ids+=($i)
done

# TODO: this shouldnt be here, this should be defined in the metadata?
files=()
for ((i = 0; i < $n; i++))
do
	files+=("$DIRECTORY/${ids[$i]}.hic")
done
log "DEBUG" "Files: ${files[*]}.hic"

# oddly the cut command did not work on this column
declare -a tumors=("Primary" "Primary" "Primary" "CR" "CR" "CR" "LiverMet" "LiverMet" "LiverMet")
log "DEBUG" "Tumors: ${tumors[*]}"

friendly_names=()
for ((i = 0; i < $n; i++))
do
	friendly_names+=("${tumors[$i]}-${ids[$i]}")
done
log "DEBUG" "Friendly Names: ${friendly_names[*]}"

declare -a colors=("BLUE" "BLUE" "BLUE" "RED" "RED" "RED" "GREEN" "GREEN" "GREEN")



# safe to remove and create output directory here
test -d $OUTPUT	&& rm -rf $OUTPUT
mkdir $OUTPUT

s=100000
/usr/bin/time -v fanc pca -n ${friendly_names[*]} -Z -s $s -c ${colors[*]} -p "$OUTPUT/$$.png"  ${files[*]} "$OUTPUT/$$.pca"