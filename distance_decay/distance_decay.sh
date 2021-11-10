#!/bin/bash
#SBATCH --partition=bgmp
#SBATCH --account=bgmp
#SBATCH --job-name=distance_decay
#SBATCH --output=distance_decay_%j.out
#SBATCH --error=distance_decay_%j.out
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=120G

#this script will take hic files from the specified 'data_dir', create a new directory, and then transform the hic files into cool files with resolution specified by res.

conda activate hicexplorer

# help functions, displays user options
help()
{
    echo "This program takes hic files and creates a distance decay plot showing all biological replicates."
    echo " "
    echo "The following options are required:"
    echo "     -d     Input the directory containing the hic files to be plotted. THIS SCRIPT WILL PLOT ALL MATRICES IN THIS DIRECTORY!"
    echo "     -r     Input resolution; conversion of HiC to cool file format requires a resolution argument."
    echo "     -o     Specify an output directory name (DIRECTORY MUST BE EMPTY). If the directory does not exist it will be created."
    echo "     -p     Input plot name, used for output distance decay plot"
    echo " "
}

# process input options
while getopts ":hd:r:o:p:" option
do
    case $option in 
        
        h) #displays help
            help
            exit;;

        d) #enter the directory containing the hic files to be plotted
            data_dir=$OPTARG;;

        r) #input a resolution
            res=$OPTARG;;

        o) #output directory
            out_dir=$OPTARG;;

        p) #plot name
            plot_name=$OPTARG;;

        
        \?) #displays invalid option
            echo "Error: Invalid option(s)"
            exit;;

    esac
done


mkdir -p $out_dir #should change to relative to paths

#converts hic matrices to .cool files and corrects via ICE method
ls -1 $data_dir |grep '.hic' |while read file;
do \
hicConvertFormat \
--matrices $data_dir/$file \
--inputFormat hic \
--outFileName $out_dir/$(echo $file | cut -f1 -d.)_res.cool \
--outputFormat cool \
--resolutions $res;
hicCorrectMatrix \
correct -m $out_dir/$(echo $file | cut -f1 -d.)_res_$res.cool \
-o $out_dir/$(echo $file | cut -f1 -d.)_res_$res.cool \
--filterThreshold -1 5 --correctionMethod ICE;
done

# this makes the distance decay plots with corrected cool files
hicPlotDistVsCounts \
--matrices $out_dir/* \
-o $out_dir/$plot_name.png \
--labels $(ls -1 $out_dir| grep "$res" | tr "\n" " " | sed 's/.cool//g')
