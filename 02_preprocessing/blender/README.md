# Blender
## Author: Juyoung Lee, John Ogata, Brian Palmer
## 10/17/21

### Introduction



### Dependencies
 1. Juicer
 	* Gnu Core Utils
 	* Burrows Wheeler Aligner (BGMP Internal: `module load bwa/0.7.17` on Talapas). [Documentation]('https://hcc.unl.edu/docs/applications/app_specific/bioinformatics_tools/alignment_tools/bwa/running_bwa_commands/').

### Setup

0. Create Environment
```bash
conda env create --file environment.yaml
conda activate blender
````

1. Create a references folder and move into it
```bash
mkdir references
cd references
```

2. Download the human genome primary assembly fasta file (using ensembl in this example (release-84))
```bash
# version: samtools/1.5
ftp://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
```

3. Rename the primary assembly
```bash
mv Homo_sapiens.GRCh38.dna.primary_assembly.fa Homo_sapiens_assembly38.fasta
```

4. Index the primary assembly with bwa (BGMP Internal: `module load bwa/0.7.17` on Talapas). bwtsw is used for long assembly.
```bash
bwa index -a bwtsw Homo_sapiens_assembly38.fasta index_
```
```
[main] Version: 0.7.17-r1188
[main] CMD: bwa index -a bwtsw Homo_sapiens_assembly38.fasta index_
[main] Real time: 2624.582 sec; CPU: 2617.287 sec
```

5. Load samtools and create the index, then create the chromosome sizes file. 
```bash
samtools faidx Homo_sapiens_assembly38.fasta
cut -f1,2 Homo_sapiens_assembly38.fasta.fai > chrom.sizes
```

6. Download juicer jar back in main directory
```bash
cd ..
wget https://s3.amazonaws.com/hicfiles.tc4ga.com/public/juicer/juicer_tools_1.19.02.jar
```

### Usage
```
usage: blender.sh [-f merged_nodups_files] [-o output] [-a account] [-p partition]
 
[-f merged_nodups_files]      Juicer text files
[-o output]                   Output file
[-a account]                  (optional) Slurm account
[-p partition]                (optional) Slurm partition

```


