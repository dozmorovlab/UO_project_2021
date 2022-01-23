#!/usr/bin/env python

last_chrom = 1
seen = set()

with open('gene_file.txt', 'w') as o:
	# with open('Homo_sapiens.GRCh38.105.gtf') as f:
	with open('Homo_sapiens.GRCh38.105.gtf') as f:
		for line in f:
			if not line.startswith('#'):
				lines = line.rstrip('\n').split('\t')
				col_9_ns = lines[-1].translate({ord(i): None for i in ' '}).split(';')

				if len(lines[0]) <= 2: # ignore scaffolds
					for e in col_9_ns:
						if 'gene_name' in e:
							start = e.find('\"') + 1
							end = e.find('\"', start) - 1
							gene_name = e[start:end]

							if (lines[0] in ('X','Y','MT') and last_chrom != lines[0]):
								last_chrom = lines[0]
								seen.clear()

							elif (lines[0] not in ('X','Y','MT')) and int(lines[0]) != last_chrom:
								last_chrom = int(lines[0])
								seen.clear()

							# t = (lines[0], lines[3], lines[4], gene_name)
							t = (lines[0], gene_name)

							if t not in seen:
								seen.add(t)
								o.write(f"{gene_name}\tchr{lines[0]}\t{lines[3]}\t{lines[4]}\n")







