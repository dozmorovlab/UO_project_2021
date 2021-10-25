# Blender
## Author: John Ogata, Brian Palmer
## 10/17/21


### Dependencies
 1. Juicer
 	* Gnu Core Utils
 	* Burrows Wheeler Aligner (BGMP Internal: `module load bwa/0.7.17` on Talapas). [Documentation]('https://hcc.unl.edu/docs/applications/app_specific/bioinformatics_tools/alignment_tools/bwa/running_bwa_commands/').

### Setup
```bash
conda env create --file environment.yaml
conda activate blender
````

Create a references folder and move into it
```bash
mkdir references
cd references
```

Download the human genome primary assembly fasta file (using ensembl in this example (release-84))
```bash
# version: samtools/1.5
ftp://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
```

Rename the primary assembly
```bash
mv Homo_sapiens.GRCh38.dna.primary_assembly.fa Homo_sapiens_assembly38.fasta
```

Index the primary assembly. bwtsw is used for long assembly.
```bash
bwa index -a bwtsw Homo_sapiens_assembly38.fasta index_
```
```
[main] Version: 0.7.17-r1188
[main] CMD: bwa index -a bwtsw Homo_sapiens_assembly38.fasta index_
[main] Real time: 2624.582 sec; CPU: 2617.287 sec
```

Load samtools and create the index, then create the chromosome sizes file. 
```bash
samtools faidx Homo_sapiens.GRCh38.dna.primary_assembly.fa
cut -f1,2 Homo_sapiens.GRCh38.dna.primary_assembly.fa.fai > chrom.sizes
```

### Usage
```bash
./blender.sh [-i, --input-directory]
```


