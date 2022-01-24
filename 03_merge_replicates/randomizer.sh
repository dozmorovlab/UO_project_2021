#!/bin/bash
#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output="%x_%j.out"
#SBATCH --error="%x_%j.err"
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --mem=128G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jogata@uoregon.edu

dir=/projects/bgmp/shared/2021_projects/VCU/data/merged_files/primary_merged/text_files
target=merged_nodups.txt

chunk_dir=/projects/bgmp/shared/2021_projects/VCU/data/merged_files/primary_merged/text_files/chunks
mkdir -p $chunk_dir

out_dir=/projects/bgmp/shared/2021_projects/VCU/data/merged_files/primary_merged/text_files/down_sampled
mkdir -p $out_dir

downsize=0.37

length=$(wc -l $dir/$target | cut -f1 -d' ')
# 915459419 is divisible by 7, 31, and 217

a=1
let x=$length/217


# this loop divides the big file into 217 chunks.
# each chunk is written into its own file. 
for n in {1..217}
do
    let b=$x*$n
    sed -n "$a, $b p; $b q" $dir/$target > $chunk_dir/$target.chunk$n
    let a=$x*$n+1
done


# # the livermet file is 37% size of primary file according to hicexplorer:
# # INFO:hicexplorer.hicCorrectMatrix:matrix contains 144647730 data points. Sparsity 0.009. #livermet file
# # INFO:hicexplorer.hicCorrectMatrix:matrix contains 390585343 data points. Sparsity 0.026. #primary file


ls -1 $chunk_dir | while read file
do
    shuf $chunk_dir/$file -o $chunk_dir/shuffled_$file && rm $chunk_dir/$file
    length=$(wc -l $chunk_dir/shuffled_$file | cut -f1 -d' ')
    uh=$(echo "scale=0; $downsize*$length" | bc)
    half=$(echo $uh | awk '{print int($1)}')
    sed -n "1, $half p; $half q" $chunk_dir/shuffled_$file >> $out_dir/splitted_shuffled_primary_downsample_1.txt
    # sed -n "$half, $length p; $length q" $chunk_dir/shuffled_$file >> $out_dir/splitted_shuffled_primary_downsampled_2.txt
    rm $chunk_dir/shuffled_$file
done

# get Error: the chromosome combination 20_20 appears in multiple blocks juicer
# found solution from Juicer google group:
# https://groups.google.com/g/3d-genomics/c/bPAm69WEXVg/m/9_o_RcdrBAAJ
# The input file should have all chromosome sub matrices  (1-1, 2-2, ... as well as interchromosomal 1-2, 1-3, ...) together in the same place in the file. 
# We only store the currently processing sub matrix; otherwise the memory requirements would be prohibitive. 
# This also means that for interchromosomal reads, you might need to reorder and sort, so that the read end with the lower chromosome is always the first read. 

# inter format from:
# https://github.com/aidenlab/juicer/wiki/Pre#file-format
# 1<str1> 2<chr1> 3<pos1> 4<frag1> 5<str2> 6<chr2> 7<pos2> 8<frag2> 9<mapq1> 10<cigar1> 11<sequence1> 12<mapq2> 13<cigar2> 14<sequence2> 15<readname1> 16<readname2>
# 5<str2> 6<chr2> 7<pos2> 8<frag2> 1<str1> 2<chr1> 3<pos1> 4<frag1> 12<mapq2> 13<cigar2> 14<sequence2> 9<mapq1> 10<cigar1> 11<sequence1> 16<readname2> 15<readname1> 

awk '{if ($2 > $6){print $5, $6, $7, $8, $1, $2, $3, $4, $12, $13, $14, $9, $10, $11, $16, $15} else {print}}' $out_dir/splitted_shuffled_primary_downsample_1.txt > $out_dir/shuffled_primary_downsample_1.txt
rm $out_dir/splitted_shuffled_primary_downsample_1.txt
sort -k2,2d -k6,6d $out_dir/shuffled_primary_downsample_1.txt > $out_dir/splitted_shuffled_primary_downsample_1.txt
rm $out_dir/shuffled_primary_downsample_1.txt


