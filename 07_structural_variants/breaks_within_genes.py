#!/usr/bin/env python

import sys

gene_file = sys.argv[1]		# 3, 4
breaks_file = sys.argv[2] 	# 3, 4
outfile = sys.argv[3]

last_chrom = 'MT'
seen = set()
breaks = dict()

def add_to_dict(mapping, key, value):
	if key not in mapping:
		mapping[key] = set()
	mapping[key].add(value)


with open(breaks_file, 'r') as bf:
	for line in bf:
		line = line.rstrip().split('\t')
		add_to_dict(breaks, line[0], (int(line[3]), line[5]))
		add_to_dict(breaks, line[1], (int(line[4]), line[5]))

with open(gene_file, 'r') as gf, open(outfile, 'w') as of:
	for gene in gf:
		gene = gene.rstrip().split('\t')

		if gene[1] in breaks:
			for b in breaks[gene[1]]:
				if int(b[0]) >= int(gene[2]) and int(b[0]) <= int(gene[3]):
					gene[1] = 'chr' + str(gene[1])
					of.write('\t'.join(e for e in gene) + '\n')


	
