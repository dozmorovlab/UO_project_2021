#!/usr/bin/bash
#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output="%x_%j.out"
#SBATCH --error="%x_%j.err"
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1
#SBATCH --mem=128G
source '../../Utilities/Src/bash/logging.sh'

function usage {
	echo "usage: blender.sh [-m metafile] [-i input-directory] [-f form]";
}

while getopts "m:i:h:t:" opt
do
	case $opt in 
		i) INPUT=$OPTARG	;;
		h) usage; exit 0 	;;
		m) METADATA=$OPTARG ;;
		f) FORMAT=$OTPARG 	;;
		[?]) usage; exit 1	;;
	esac
done

test -z $INPUT		&&	{ log	"ERROR" 	"Input Directory not supplied.";	exit 1; }
test -d $INPUT 		||	{ log	"ERROR" 	"Input Directory does not exist.";	exit 1; }

# test -z $METADATA	&&	{ log	"ERROR" 	"Metadata not supplied.";			exit 1; }
# test -f $METADATA 	||	{ log	"ERROR" 	"Metadata does not exist.";			exit 1; }

primary1="${INPUT}/105259/merged_nodups.txt.gz"
primary2="${INPUT}/102770/merged_nodups.txt.gz"
primary3="${INPUT}/102933/merged_nodups.txt.gz"

CR1="${INPUT}/105242/merged_nodups.txt.gz"
CR2="${INPUT}/105246/merged_nodups.txt.gz"

LiverMet1="${INPUT}/100887/merged_nodups.txt.gz"
LiverMet2="${INPUT}/100889/merged_nodups.txt.gz"

#echo "SORTING"

# test -d "${INPUT}/primary_merged" && rm -rf "${INPUT}/primary_merged"
# mkdir "${INPUT}/primary_merged" 
# sort --parallel=8 -S 64G -m -k1,1d -k5,5d <(gunzip -c $primary1) <(gunzip -c $primary2) <(gunzip -c $primary3) > "${INPUT}/primary_merged/merged_nodups.txt"

# java -Xmx2g -jar juicer_tools.jar pre -q 1 -r 25 50 "${INPUT}/primary_merged/merged_nodups.txt" "${INPUT}/primary_merged/inter.hic" hg38

test -d "${INPUT}/CR_merged" && rm -rf "${INPUT}/CR_merged"
mkdir "${INPUT}/CR_merged" 
sort --parallel=8 -S 64G -m -k1,1d -k5,5d <(gunzip -c $CR1) <(gunzip -c $CR2) > "${INPUT}/CR_merged/merged_nodups.txt"

# srun -A bgmp -p bgmp --nodes=1 --ntasks-per-node=1 --cpus-per-task=8 --time=4:00:00 \ 
# 	java -Xmx2g -jar juicer_tools.jar pre -q 1 -r 25 50 "${INPUT}/CR_merged/merged_nodups.txt.gz" "${INPUT}/CR_merged/inter.hic" hg38

test -d "${INPUT}/livermet_merged" && rm -rf "${INPUT}/livermet_merged"
mkdir "${INPUT}/livermet_merged" 
sort --parallel=8 -S 64G -m -k1,1d -k5,5d <(gunzip -c $LiverMet1) <(gunzip -c $LiverMet2) > "${INPUT}/livermet_merged/merged_nodups.txt"

# srun -A bgmp -p bgmp --nodes=1 --ntasks-per-node=1 --cpus-per-task=8 --time=4:00:00 \ 
# 	java -Xmx2g -jar juicer_tools.jar pre -q 1 -r 25 50 "${INPUT}/livermet_merged/merged_nodups.txt.gz" "${INPUT}/livermet_merged/inter.hic" hg38

echo "WAITING FOR SORTS TO FINISH"



exit 0
