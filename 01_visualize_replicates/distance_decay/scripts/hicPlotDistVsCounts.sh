#!/usr/bin/bash
data_in=<path to cool files>
data_out=<path for output plots>
mkdir $data_out

hicPlotDistVsCounts \
--matrices <replicate.cool 1> <replicate.cool 2>... <replicate.cool n> \
--plotFile $data_out/<plot name> \
--labels <replicate labels>
