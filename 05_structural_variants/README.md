# Detecting Structural Variants in Contact Maps

## Background

Structural variants can be detected in contact maps using ![NeoLoopFinder](https://github.com/XiaoTaoWang/NeoLoopFinder). Structural variants leads to modification in chromatin organization which can lead to structural changes. Here we effectively use the structural changes identified in the generated contact maps to determine what structural variants occured the NeoLoopFinder package.

## Package Citation

Wang, X., Xu, J., Zhang, B., Hou, Y., Song, F., Lyu, H., Yue, F. Genome-wide detection of enhancer-hijacking events from chromatin interaction data in re-arranged genomes. Nat Methods. 2021.

## Create Cool Files

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


## Calculate Copy Number Variation

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


## Hidden Markov Model (HMM) Segmentation

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

## Remove Number Variation effects 

Finally, we remove the copy variation effect in-place.

Liver Metastatic:
```bash
./correct-cnv --cnv-file ~/vcu_data/week2/neoloopfinder/cnv/livermet/segment_cnv --hic ~/projects/vcu/05_structural_variants/cool_files/all_reps.hic_50000.cool --nproc 8 
```

Primary:
```bash
./correct-cnv --cnv-file ~/vcu_data/week2/neoloopfinder/cnv/primary/segment_cnv --hic ~/projects/vcu/05_structural_variants/cool_files/3rep.hic_50000.cool --nproc 8 
```

## Simulate CNV Effects on a Normal Cell for Comparison

This portion cannot be completed at this time because we do not have data of normal cells. The purpose of this section seems to be finding the impacts of the found CNVs on contacts maps from a healthy cell. 

## Assemble Complex Structural Varinants

As mentioned before, stuctural variants could be deletions, inversions or translocations. In this section, we assemble a text file with possible SVs given breakpoints along the chromosmome arms. To find these breaks and create the requisite breakpoint text file, we used [hic_breakfinder](https://github.com/dixonlab/hic_breakfinder). 

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
