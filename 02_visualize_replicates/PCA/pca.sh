#!/usr/bin/bash

source "../../Utilities/Logging/logging.sh"

function usage {
	echo "usage: pca.sh [-m, --metafile] [-i, --input-directory] [-o, --output-directory] [-s, --sample-size] [-f, --force]";
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

		-s | --sample-size)
			shift
			declare -r SAMPLE_SIZE=$1
			log "DEBUG" "Sample Size: $SAMPLE_SIZE"
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
test -f $METADATA 	||	{ log	"ERROR" 	"Metadata File $METADATA does not exist.";			exit 1; }

test -z $OUTPUT		&&	{ log	"ERROR" 	"Output Directory not supplied.";	exit 1; }

# may need to update this if using more than 4 groups
color_idx=0
color_options=("NA" "BLUE" "RED" "GREEN" "YELLOW")
# /usr/bin/time -v fanc pca -n ${friendly_names[*]} -Z -s $s -c ${colors[*]} -p "$OUTPUT/$$.png"  ${files[*]} "$OUTPUT/$$.pca"
friendly_names=()
files=()

while IFS=',' read -r id tumor folder
do
	log "DEBUG" "$id $tumor $folder"

	file="$DIRECTORY/$folder/$id.hic"
	test -f $file || { log "FATAL" "$file does not exist"; exit 1; } 
	files+=($file)
	test -z "${!tumor}" && { 
		eval "declare $tumor=1"
		color_idx=$((color_idx + 1)); 
		log "DEBUG" "Declared $tumor and incremented color_idx --> $color_idx";
	}
	colors+=(${color_options[$color_idx]})
	friendly_names+=("$tumor")

done < $METADATA

log "DEBUG" "Files: ${files[*]}"
log "DEBUG" "Colors: ${colors[*]}"
log "DEBUG" "Friendly Names: ${friendly_names[*]}"


# safe to remove and create output directory here
test -d $OUTPUT	&& rm -rf $OUTPUT
mkdir $OUTPUT

/usr/bin/time -v fanc pca -n ${friendly_names[*]} -Z -s $SAMPLE_SIZE -c ${colors[*]} -p "$OUTPUT/$$.png"  ${files[*]} "$OUTPUT/$$.pca"