#!/usr/bin/bash

source '../Bash/logging.sh'

while getopts "a:p:f:b:m:" opt
do
	case $opt in 
		a) account=$OPTARG ;;
		p) partition=$OPTARG ;;
		f) files=$OPTARG ;;
		b) block=$OPTARG ;;
		m) metadata=$OPTARG ;;
		*) exit 1 ;;

	esac
done

[[ -z $files && -z $metadata ]] 	&&	{ log	"ERROR" 	"No input supplied.";				exit 1; }

for file in $files; do
	test -f $file 		||	{ log	"ERROR" 	"$file does not exist.";		exit 1; }
done

job_ids=()

if [[ -v $files ]]
then
	log "INFO" "Reading $files"
	for file in $files
	do
		jid=`sbatch <<- EOF | egrep -o -e "\b[0-9]+$"
			#!/usr/bin/bash -l
			#SBATCH --account=$account
			#SBATCH --partition=$partition
			#SBATCH --output="rand_sort_split_%j.out"
			#SBATCH --error="rand_sort_split_%j.err"
			#SBATCH --cpus-per-task=8
			#SBATCH --nodes=1

			/usr/bin/time -v gzip $file

			EOF`

		log "INFO" "Started SLURM Job: $jid"
		job_ids+=($jid)

	done
else
	log "INFO" "Reading from $metadata"
	while read file
	do
		jid=`sbatch <<- EOF | egrep -o -e "\b[0-9]+$"
			#!/usr/bin/bash -l
			#SBATCH --account=$account
			#SBATCH --partition=$partition
			#SBATCH --output="rand_sort_split_%j.out"
			#SBATCH --error="rand_sort_split_%j.err"
			#SBATCH --cpus-per-task=8
			#SBATCH --nodes=1

			/usr/bin/time -v gzip $file

			EOF`

		log "INFO" "Started SLURM Job: $jid"
		job_ids+=($jid)
	done < $metadata
fi


test -z $block || {
	log "INFO" "Waiting for jobs $job_ids to finish..."
	for job in $job_ids
	do
		wait $job
		log "INFO" "$job finished with exit code $?."
	done
}

