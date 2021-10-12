#!/usr/bin/bash
#this script assumes input hic files have format <name>.hic

data_dir=<path to .hic files> #should change to relative to paths
out_dir=<path to output cool files>
res=50000 #desired resolution of resulting cool files

mkdir $out_dir #should change to relative to paths

ls -1 $data_dir |grep '.hic' |while read file;
do \
hicConvertFormat \
--matrices $data_dir/$file \
--inputFormat hic \
--outFileName $out_dir/$(echo $file | cut -f1 -d.)_resolution.cool \
--outputFormat cool \
--resolutions $res;
done