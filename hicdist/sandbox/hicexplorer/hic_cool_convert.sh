#!/usr/bin/env bash

#source activate hicexplorer
echo "$(date "+%Y%m%d-%H%M%S"),$$,$0,$@" >> pid.csv

test -d output || mkdir output
OUT="output/$$"
test -d $OUT || mkdir $OUT

# https://hicexplorer.readthedocs.io/en/latest/
# https://hicexplorer.readthedocs.io/en/latest/content/tools/hicConvertFormat.html#hicconvertformat

# /projects/bgmp/shared/2021_projects/VCU/hic_week1
# they use 10000 in their example

# hicConvertFormat -m $1 --inputFormat hic --outputFormat cool -o "$OUT/$2" --resolutions 10000 > "$OUT/std.out"

# multi-resolution (message below is in output from above)
# ... This file is single resolution and NOT higlass compatible. Run with `-r 0` for multi-resolution. 

# with -r 0, the file is higlass compatible. This does take more time to run though.
hicConvertFormat -m $1 --inputFormat hic --outputFormat cool -o "$OUT/$2" --resolutions 10000 -r 0 > "$OUT/std.out"
### Finished! Output written to: 100887_0.mcool
# ... This file is higlass compatible.

exit 0