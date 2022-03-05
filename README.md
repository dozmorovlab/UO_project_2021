# Shared repo for the UO project

### 3D genome changes in cancer

### Project background/overview 

The project involves computational analysis and interpretation of processed chromatin conformation capture data (Hi-C). The data has been generated from tumor samples obtained from patient-derived xenograft (PDX) models. The experimental conditions include two triple-negative breast cancer PDX cells grown as primary tumors and drug-resistant clones. 

### Project goals 

Main goal is to identify changes in the 3D genome organization between drug-resistant (CR) and primary (Primary) tumors. Analyses include comparison of 1) Distance-dependent decay of interaction frequencies; 2) A/B compartments; 3) Topologically Associating Domains; 4) Chromatin loops. The outcome includes visualization and genomic coordinates of altered regions (changes in chromatin interactions).

Supplementary data include differential gene expression, CNVs, SNPs, InDels, SVs.


### Work flow
1. Create HiC files using [Juicer](https://github.com/aidenlab/juicer), see [01_create_hic_files](https://github.com/dozmorovlab/UO_project_2021/tree/main/01_create_hic_files) for more details.
2. Exploratory analysis of biological replicates, specifically MDS, PCA, and distance decay (contact probability) plots. See [02_visualize_replicates](https://github.com/dozmorovlab/UO_project_2021/tree/main/02_visualize_replicates) for more details.
3. If appropriate (based on #2), merge biological replicates to increase resolution. See [03_merge_replicates](https://github.com/dozmorovlab/UO_project_2021/tree/main/03_merge_replicates) for more details.
4. Same as #2, but using output from #3. See [04_post_merge_analysis](https://github.com/dozmorovlab/UO_project_2021/tree/main/04_post_merge_analysis) for more details.
5. Use [HiC Explorer](https://hicexplorer.readthedocs.io/en/latest/index.html) and custom python script to visualize and quantify differences in TAD attributes between samples. See [05_differential_tads](https://github.com/dozmorovlab/UO_project_2021/tree/main/05_differential_tads) for more details.
6. Use [Homer](http://homer.ucsd.edu/homer/) to quantify AB compartment switches between samples. See [06_ab_compartments](https://github.com/dozmorovlab/UO_project_2021/tree/main/06_ab_compartments)
7. Use [NeoLoopFinder](https://github.com/XiaoTaoWang/NeoLoopFinder) to discover structural variants between samples. See [07_structural_variants](https://github.com/dozmorovlab/UO_project_2021/tree/main/07_structural_variants) for more details.
