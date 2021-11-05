#!/usr/bin/bash

# this should be defined in the environment
source '../../Utilities/Src/Bash/logging.sh'

function usage {
	echo "Usage: blender.sh [-h help] [-j Juicer_directory] [-m Merged File] [-c Coverage Filename] [-a account] [-p partition]";
	echo
	echo "[-j] - Root directory of juicer repository"
	echo "[-m] - Path to merged file"
	echo "[-c] - Coverage file (to create)"
	echo "[-a] - Slurm account (optional)"
	echo "[-p] - Slurm partition (optional)"
	echo
	echo "This file requries juicer/misc/calculate_map_resolution.sh from the juicer repo."
	echo "Make sure to visit: https://github.com/aidenlab/juicer and download repository."
	echo 
	echo "NOTE: Make sure juicer/misc/calculate_map_resolution.sh contains the correct genome size count!!!"
}

# These are defaults so that account / partition do not need to be passed in each time.
# Should update these with user specific info.
ACCT="bgmp"
PART="bgmp"

while getopts "a:p:j:m:c:h:" opt
do
	case $opt in 
		a) ACCT=$OPTARG		;;
		p) PART=$OPTARG		;;
		j) JUICER=$OPTARG	;;
		m) MERGED=$OPTARG	;;
		c) COVERAGE=$OPTARG	;;
		h) usage; exit 0 	;;
		[?]) usage; exit 1	;;
	esac
done

test -z $JUICER		&&	{ log	"ERROR" 	"Juicer Directory not supplied.";					exit 1; }
test -d $JUICER 	||	{ log	"ERROR" 	"Juicer Directory ${JUICER} does not exist.";		exit 1; }

test -z $MERGED		&&	{ log	"ERROR" 	"Merged Filename not supplied.";					exit 1; }
test -f $MERGED 	||	{ log	"ERROR" 	"Merged file $MERGED not found.";					exit 1; }

test -z $COVERAGE	&&	{ log	"ERROR" 	"Coverage Filename not supplied.";					exit 1; }

log "INFO" "Last reminder to make ${JUICER}/misc/calculate_map_resolution.sh contains the correct genome size count!!!"

sleep 3

# calculate_map_resolution.sh by default is Hg19 http://genomewiki.ucsc.edu/index.php/Hg19_Genome_size_statistics,
# this can be set to Hg38 manually (see http://genomewiki.ucsc.edu/index.php/Hg38_17-way_Genome_size_statistics)
CMD="bash ${JUICER}/misc/calculate_map_resolution.sh $MERGED $COVERAGE"

log "DEBUG" "account=$ACCT"
log "DEBUG" "partition=$PART"

# if no slurm info, just run locally
test ! -z "$ACCT" &&  test ! -z "$PART" && {
	jid=`sbatch <<- COVERAGE | grep -oE "\b[0-9]+$"
		#!/usr/bin/bash -l
		#SBATCH --account=$ACCT
		#SBATCH --partition=$PART
		#SBATCH --output="calc_map_resolution_%j.out"
		#SBATCH --error="calc_map_resolution_%j.err"
		#SBATCH --cpus-per-task=8

		/usr/bin/time -v $CMD

	COVERAGE`

	log "INFO" "Slurm job $jid submitted."

} || {
	log "INFO" "Running locally."
	eval "$CMD"
}

exit 0
