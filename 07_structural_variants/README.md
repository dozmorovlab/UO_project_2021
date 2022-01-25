# Detecting Structural Variants in Contact Maps

## Background

Structural variants can be detected in contact maps using [NeoLoopFinder](https://github.com/XiaoTaoWang/NeoLoopFinder). Structural variants leads to modification in chromatin organization which can lead to structural changes. Here we effectively use the structural changes identified in the generated contact maps to determine what structural variants occured the NeoLoopFinder package.

## Package Citation

Wang, X., Xu, J., Zhang, B., Hou, Y., Song, F., Lyu, H., Yue, F. Genome-wide detection of enhancer-hijacking events from chromatin interaction data in re-arranged genomes. Nat Methods. 2021.

## 1. Create Cool Files

The first step is to create cooler files. This is done using `HiCExplorer` version 3.7.2.

```bash
conda install hicexplorer
```

```bash
hicConvertFormat --matrices ~/vcu_data/week2/livermet_merged/all_reps.hic --inputFormat hic --outFileName ~/projects/vcu/05_structural_variants/cool_files/all_reps.hic.cool --outputFormat cool --resolutions 50000
```

```bash
hicConvertFormat --matrices ~/vcu_data/week2/primary_merged/3rep.hic --inputFormat hic --outFileName ~/projects/vcu/05_structural_variants/cool_files/3rep.hic.cool --outputFormat cool --resolutions 50000
```

Note: we started by using 50000 bp resolution for both.


We now need to convert the cool formats again to calculate the corrections factors to balance the matrix. The [documentation](https://hicexplorer.readthedocs.io/en/latest/content/tools/hicConvertFormat.html#hicconvertformat) for HiCExplorer indicates the options is only available when cool formats are used as input. This command was giving errors though about not being h5 format:

```bash
hicConvertFormat -m ~/projects/vcu/05_structural_variants/cool_files/all_reps.hic.cool --inputFormat cool -o ~/projects/vcu/05_structural_variants/cool_files/all_reps.hic.cool --outputFormat cool --correction_name KR
```

Cooler has a CLI, which was downloaded with conda.

```bash
conda install -c conda-forge -c bioconda cooler
```

The force command was needed to add the weight column. Threads can be added but the default is 8 already, which allowed for each run to be approx. 1 minute. 

Liver Metastatic:
```bash
cooler balance --force ~/projects/vcu/05_structural_variants/cool_files/all_reps.hic_50000.cool 
```

Primary:
```bash
cooler balance --force ~/projects/vcu/05_structural_variants/cool_files/3rep.hic_50000.cool 
```


## 2. Calculate Copy Number Variation

The documentation in Neo-loop finder suggests that tumor cells should use the `calculate-cnv` script in order to determine the copy number variation. In other words, this will determine how many DNA sequences that differ from the reference genome (in our case, Hg38). 

We used the following command for liverment. Of note is that the enzyme was not set, so the default MboI is used. This needs to be updated if a different restriction enzyme was used in the Hi-C experiment.

```bash
./calculate-cnv -g hg38 --output ~/vcu_data/week2/neoloopfinder/cnv/livermet/cnv_bedgraph --hic ~/projects/vcu/05_structural_variants/cool_files/all_reps.hic_50000.cool --cachefolder ~/vcu_data/week2/neoloopfinder/cnv/cache
```

Note: The script seems to fail silently. You should see a message about outputing residuals to the bedgraph (specified by the `output` parameter) and a 'Done' message afterwards. The log file is also a good tool for debugging.

A similar command was used for the primary tumor:

```bash
./calculate-cnv -g hg38 --output ~/vcu_data/week2/neoloopfinder/cnv/primary/cnv_bedgraph --hic ~/projects/vcu/05_structural_variants/cool_files/3rep.hic_50000.cool --cachefolder ~/vcu_data/week2/neoloopfinder/cnv/cache
```


## 3. Hidden Markov Model (HMM) Segmentation

This script makes use of the Circular Binary Segmentation (CBS) algorithm to identify genomic regions and identify the variant copy number in that region. The segment mean values are also calculated using $\log_2(\frac{copy number}{2})$, which gives information about the amplification of copy numbers in the region (positive = overamplification, negative = under amplification, zero = diploid regions). More information about this pipeline can be found [here](
https://docs.gdc.cancer.gov/Data/Bioinformatics_Pipelines/CNV_Pipeline/#copy-number-variation-analysis-pipeline).

Liver Metastatic:
```bash
./segment-cnv --output ~/vcu_data/week2/neoloopfinder/cnv/livermet/segment_cnv --cnv-file ~/vcu_data/week2/neoloopfinder/cnv/livermet/cnv_bedgraph --nproc 8 --binsize 50000
```

Primary:
```bash
./segment-cnv --output ~/vcu_data/week2/neoloopfinder/cnv/primary/segment_cnv --cnv-file ~/vcu_data/week2/neoloopfinder/cnv/primary/cnv_bedgraph --nproc 8 --binsize 50000
```

## 4. Remove Number Variation effects 

Finally, we remove the copy variation effect in-place.

Liver Metastatic:
```bash
./correct-cnv --cnv-file ~/vcu_data/week2/neoloopfinder/cnv/livermet/segment_cnv --hic ~/projects/vcu/05_structural_variants/cool_files/all_reps.hic_50000.cool --nproc 8 
```

Primary:
```bash
./correct-cnv --cnv-file ~/vcu_data/week2/neoloopfinder/cnv/primary/segment_cnv --hic ~/projects/vcu/05_structural_variants/cool_files/3rep.hic_50000.cool --nproc 8 
```

## 5. Simulate CNV Effects on a Normal Cell for Comparison

This portion cannot be completed at this time because we do not have data of normal cells. The purpose of this section seems to be finding the impacts of the found CNVs on contacts maps from a healthy cell. 

## 6. Assemble Complex Structural Variants

As mentioned before, stuctural variants could be deletions, inversions or translocations. In this section, we assemble a text file with possible SVs given breakpoints along the chromosmome arms. To find these breaks and create the requisite breakpoint text file, we used [hic_breakfinder](https://github.com/dixonlab/hic_breakfinder). 

### 6.1. Breakfinder

#### 6.1.1. Setup

IMPORTANT: Follow the update header for the complete working setup.

#### 6.1.2. HiC Break Finder (working solution)

The issue is resolved thanks to a post [here](https://github.com/dixonlab/hic_breakfinder/issues/10) by our instructor Jason Sydes. 

Start by removing interfering modules (this mostly applies from loading bamtools below earlier, which interferes with the build process).
```bash
module purge 
```

You will quickly find that there is too much output. I ended up removing some of the `std::cerr` statements, such as below in ```src/hic_breakfinder.cpp```:
```c++
  91       if (refs.at(bam.RefID).RefName != last_chr) { 
  92         // cerr << "Going through " << refs.at(bam.RefID).RefName << now\n";
  93         last_chr = refs.at(bam.RefID).RefName;
  94       } 
```

Then run the following code:
```bash
conda create -n hic_breakfinder bamtools=2.3.0 eigen=3.3.9
conda activate 20211130_hic_breakfinder

make clean
./configure CPPFLAGS="-I /home/bpalmer3/projects/miniconda3/envs/20211130_hic_breakfinder/include/bamtools -I /home/bpalmer3/projects/miniconda3/envs/20211130_hic_breakfinder/include/eigen3" LDFLAGS="-L/home/bpalmer3/projects/miniconda3/envs/20211130_hic_breakfinder/lib"
make
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/bpalmer3/projects/miniconda3/envs/20211130_hic_breakfinder/lib

# Testing it, and it works (well, shows the help prompt at least):
./src/hic_breakfinder
./hic_breakfinder
```

Note: See `Previous Issue` below for previous failed attempt.


Breakfinder requires three input parameters:

1. The bam file
2. Inter-chromosomal expectation file
3. Intra-chromosomal expectation file

The expectation files are described in this [issue](https://github.com/dixonlab/hic_breakfinder/issues/7). They seem to be contacts for Hg38, and are generated using a combination of Hi-C matrices from multiple cell types.

The files are accessible online [here](https://salkinstitute.app.box.com/s/m8oyv2ypf8o3kcdsybzcmrpg032xnrgx). Note that we only need Hg38 so it may save you time to just download those files.

The readme recommends removing low quality alignments. This can be done with `hic_align_pipeline.sh` in the dixon lab's repo `https://github.com/dixonlab/HiC_alignment_basic_scripts.git`.

Command to align (note: this was done with the test file first):
```bash
./hic_align_pipeline.sh ~/vcu_data/data/bam_files/test_sample.bam
```


Command for livermet:
```bash
./hic_breakfinder --bam-file ~/vcu_data/week2/downloads/W30_LiverMet.fastq.gz.bam --exp-file-inter ../expect/inter_expect_1Mb.hg38.txt --exp-file-intra ../expect/intra_expect_100kb.hg38.txt --name livermet
```

Command for primary:
```bash
./hic_breakfinder --bam-file ~/vcu_data/week2/downloads/W30_Primary.fastq.gz.bam --exp-file-inter ../expect/inter_expect_1Mb.hg38.txt --exp-file-intra ../expect/intra_expect_100kb.hg38.txt --name primary
```

The jobs were submitted as slurm scripts. The original runs resulted in `oom-kill` errors, so the memory for the job was updated to 128G. With these updates, the jobs completed successfully in about a day. 

The SV breakpoints are reformatted with `prepare-SV-breakpoints.py`:
```bash
./prepare-SV-breakpoints.py ~/projects/hic_breakfinder/src/livermet.breaks.txt livermet.breaks.mod.txt
```

```bash
./prepare-SV-breakpoints.py ~/projects/hic_breakfinder/src/primary.breaks.txt primary.breaks.mod.txt
```

```bash
head livermet.breaks.mod.txt
```

```bash
head primary.breaks.mod.txt
```

Note: The script needed `#!/usr/bin/env python` to be added at the top.

#### 6.1.3. Assemble complex structural variants

Assemble complex structural variants for livermet tumor:
```bash
./assemble-complexSVs \
	-O livermet \
	-H ~/projects/vcu/05_structural_variants/cool_files/all_reps.hic_50000.cool \
	-B ~/projects/NeoLoopFinder/scripts/livermet.breaks.mod.txt \
	--nproc 8
```

and for the primary tumor:
```bash
./assemble-complexSVs \
	--output primary \
	--hic ~/projects/vcu/05_structural_variants/cool_files/3rep.hic_50000.cool \
	--break-points ~/projects/NeoLoopFinder/scripts/primary.breaks.mod.txt \
	--nproc 8
```

```bash
head livermet.assemblies.txt
head primary.assemblies.txt
```

#### 6.1.4 HiC Break Finder (Previous Issue - resolved in 6.1.2)

Dependencies for hic_breakfinder include Eigen and bamtools. The following were loaded using lmod:
```bash
module load racs-eb 	# internal, dependency for Eigen to load on talapas HPC
module load bamtools/2.5.1
```

Eigen is also a dependency, but is only needed for the source. The repository was cloned:
```bash
git clone https://gitlab.com/libeigen/eigen.git
```

And the final configuration command was performed per the [readme](https://github.com/dixonlab/hic_breakfinder/blob/master/README):

```bash
./configure CPPFLAGS="-I /packages/bamtools/2.5.1/include -I ~/projects/eigen" LDFLAGS="-L/packages/bamtools/2.5.1/lib64/libbamtools.a"
```

`make` was finally called to compile hic_breakfinder using gcc version 7.3.0 (GCC).
```bash
make # using gcc version 7.3.0 (GCC)
```

This resulted in a missing references error, similar to the one reporte [here](https://github.com/dixonlab/hic_breakfinder/issues/10). Per the final comment, an older compiler version is advisable. The exact compiler could not be found on talapas, so a close version is used (`gcc/4.8.2`).

The environment was reset and the following were loaded using lmod:

```bash
module load prl
module load gcc/4.8.2 	# Reported by github issue
```

Compiler `gcc/4.8.2` was used to build `bamtools` to prevent compatability issues.

```bash
git clone https://github.com/pezmaster31/bamtools.git
```

After compiling `libbamtools.a`, the hic breakfinder compile steps were followed again with this updated command:

```bash
./configure CPPFLAGS="-I ~/projects/bamtools/src -I ~/projects/eigen" LDFLAGS="-L~/projects/bamtools/src/libbamtools.a"
```

```bash
make # gcc/4.8.2 
```

This unfortunately is causing the same errors that were seen previously. We are currently working with our instructors on this issue. 



## 7. Neo Loop Caller

Questions: Insitu or dilution protocol? ![link](https://github.com/XiaoTaoWang/NeoLoopFinder/blob/master/scripts/neoloop-caller)

```bash
python neoloop-caller \
--output livermet.neoloopcaller.txt \
--hic ~/projects/vcu/05_structural_variants/cool_files/all_reps.hic_50000.cool \
--assembly livermet.assemblies.txt \
--region-size 50000 \
--nproc 8
```

```bash
python neoloop-caller \
--output primary.neoloopcaller.txt \
--hic ~/projects/vcu/05_structural_variants/cool_files/3rep.hic_50000.cool \
--assembly primary.assemblies.txt \
--region-size 50000 \
--nproc 8
```

```bash
head livermet.neoloopcaller.txt
head primary.neoloopcaller.txt
```

## 8. 