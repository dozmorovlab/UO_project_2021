#!/usr/bin/env bash

fmcool1="/home/bpalmer3/projects/vcu/hicexplorer/sandbox/output/188342/105242_0.mcool"
fmcool2="/home/bpalmer3/projects/vcu/hicexplorer/sandbox/output/102390/100887_0.mcool"

# (stratum adjusted correlation coefficient (scc))
hicrep $fmcool1 $fmcool2 outputSCC.txt --binSize 100000 --h 1 --dBPMax 500000  

exit 0