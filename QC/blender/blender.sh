#!/usr/bin/bash

# this should be defined in the environment
source '../../Utilities/Src/Bash/logging.sh'

function usage {
	echo "usage: blender.sh [-f merged_nodups_files] [-o output]";
	echo 
	echo "[-f merged_nodups_files] 		Juicer text files"
	echo "[-o output] 					Output file"
	echo "[-a account]					(optional) Slurm account"
	echo "[-p partition]				(optional) Slurm partition"
}

acct=bgmp
part=bgmp

while getopts "a:p:f:h:o:" opt
do
	case $opt in 
		a) acct=$OPTARG		;;
		p) part=$OPTARG		;;
		f) files=$OPTARG	;;
		o) output=$OPTARG	;;
		h) usage; exit 0 	;;
		[?]) usage; exit 1	;;
	esac
done

test -z $files		&&	{ log	"ERROR" 	"Files not supplied.";	exit 1; }

for file in $files
do
	test -f $file 		||	{ log	"ERROR" 	"$file does not exist.";	exit 1; }	
done


jid=`sbatch <<- BLENDER | grep -oE "\b[0-9]+"
	#!/usr/bin/bash
	#SBATCH --account=$acct
	#SBATCH --partition=$part
	#SBATCH --output="blender_%j.out"
	#SBATCH --error="blender_%j.err"
	#SBATCH --cpus-per-task=8
	#SBATCH --nodes=1
	#SBATCH --mem=128G

	# long format juicer file, sorting by chromosomes
	sort --parallel=8 -S 64G -m -k2,2d -k6,6d $files > merged_nodups.txt
	java -Xmx32g -jar juicer_tools.jar pre -q 1 -r 25000,50000 -j 8 "$files" "$output" hg38 

BLENDER`

log "INFO" "Submitted Slurm Job: $jid."

exit 0

