#!/bin/bash
#SBATCH --partition=bgmp
#SBATCH --account=bgmp
#SBATCH --job-name=hic_visual_CR
#SBATCH --output=hic_visual_CR_%j.out
#SBATCH --error=hic_visual_CR_%j.out
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=70G

conda activate hicexplorer

#this part will take hic files from the specified 'data_dir', create a new directory, and then transform the hic files into h5 files with resolution specified by res.
hic_file=/projects/bgmp/shared/2021_projects/VCU/week2/CR_merged/inter_25_50.hic #should change to relative to paths

res=50000 #desired resolution
name=CR

mkdir -p /projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/$name/$res #should change to relative to paths
dir=/projects/bgmp/shared/2021_projects/VCU/hicexplorer/visualization/$name/$res #where to the converted h5 files

#converts hic file to cool file
hicConvertFormat \
--matrices $hic_file \
--inputFormat hic \
--outFileName $dir/matrix.cool \
--outputFormat cool \
--resolutions $res

file=$dir/matrix_$res.cool

# hicCorrectMatrix correct -m $file --correctionMethod ICE --filterThreshold -1.5 5 -o $dir/corrected_matrix.cool
# hicCorrectMatrix diagnostic_plot -m $dir/corrected_matrix.cool -o $dir/cool_corrected.png 
# file=$dir/corrected_matrix.cool

hicPCA -m $dir/matrix_$res.cool -o $dir/pca1.bw $dir/pca2.bw -f bigwig #works but mem needs to be at least 10G

hicPlotMatrix -m $file -o $dir/hic_plot.png --log1p --bigwig $dir/pca1.bw --perChromosome #works


# hicTransform -m $dir/matrix_$res.cool -o $dir/pearson --method pearson --perChromosome #works
# hicPlotMatrix -m $dir/pearson.h5 -o $dir/AB.png --perChromosome --bigwig $dir/pca1.bw
