#!/bin/bash

#parse command line arguments
for i in "$@"; do
    case $i in
        -d=*|--directory=*) #absolute path to the directory containing .cool files
        DIRECTORY="${i#*=}"
        shift
        ;;
        -o=*|--outdir=*) #absolute path to the output directory to store .txt files
        OUTDIR="${i#*=}"
        shift
        ;;
        *)
        # unknown option
        ;;
    esac
done

echo "Directory = ${DIRECTORY}"
echo "Output directory = ${OUTDIR}"

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument: $1"
    tail -1 $1
fi

# dir=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/cool_files_100000/
# outdir=/projects/bgmp/shared/2021_projects/VCU/hicrep/

for i in ${DIRECTORY}/*.cool; do
    for n in ${DIRECTORY}/*.cool ; do
        if [ "$i" \< "$n" ] || [ "$i" == "$n" ]; then # to pair each file once and to itself
            F1=${i##*/} # doesn't print full path. Only file name
            F2=${n##*/} 
            /usr/bin/time -v hicrep ${i} ${n} ${OUTDIR}${F1:0:6}_${F2:0:6}.txt --h 1 --dBPMax 500000
            #echo "pair ${F1:0:6} and ${F2:0:6}"
        fi
    done
done

echo "Finished!"
