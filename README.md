# Shared repo for the UO project

### 3D genome changes in cancer

### Project background/overview 

The project involves computational analysis and interpretation of processed chromatin conformation capture data (Hi-C). The data has been generated from tumor samples obtained from patient-derived xenograft (PDX) models. The experimental conditions include two triple-negative breast cancer PDX cells grown as primary tumors and drug-resistant clones. 

### Project goals 

Main goal is to identify changes in the 3D genome organization between drug-resistant (CR) and primary (Primary) tumors. Analyses include comparison of 1) Distance-dependent decay of interaction frequencies; 2) A/B compartments; 3) Topologically Associating Domains; 4) Chromatin loops. The outcome includes visualization and genomic coordinates of altered regions (changes in chromatin interactions).

Supplementary data include differential gene expression, CNVs, SNPs, InDels, SVs.

### ToDo

- Organize all folders
    - Remove unnecessary files
    - Group files into question-specific (not tool-specific) folders
    - Describe each file in the README. For scripts, specify what they do, their Input, Output, settings/prerequisites.

- Create a summary presentation (RMarkdown) describing figures/tables from different questions. Some figures may be main, some - supplementary.
    - Reproducibility among all replicates - justify ignoring CR, merging three Liver Mets replicates, merging three PR replicates and splitting them into two (PCA, MDS)
    - Reproducibility between two PR samples and one LiverMets sample - demonstrate similarity between two PR and their difference from one LiverMets
    - How distance-dependent decay look for replicates and merged samples?
    - What is the minimum resolution each sample can be analyzed?
    - AB compartment comparison - proportions of regions switching from A to B, B to A, staying A to A, B to B. Genomewide and per chromosome (which chromosome has the most changes?)
        - Which genes are located in A->B, B->A switching regions? In which pathways, functions they are enriched?
    - TADs/chromatin loops (domaint)
        - The total number/width of domains, genomewise and per chromosome. Which chromosomes show the largest change in domains?
        - Domain boundary changes, visualization of the most dramatic examples
        - Genes in proximity of (+/- resolution) boundaries specific for PR or LiverMets conditions - in which pathways, functions they are enriched?
        - Transcription factors enriched in PR/LiverMets-specific boundaries? (TBD)
    - Integrate changes with differentially expressed genes. Take WHIM30 Liver Mets vs. Primary from supplementary table from Alzubi, Mohammad A., Tia H. Turner, Amy L. Olex, Sahib S. Sohal, Nicholas P. Tobin, Susana G. Recio, Jonas Bergh, et al. “Separation of Breast Cancer and Organ Microenvironment Transcriptomes in Metastases.” Breast Cancer Research: BCR 21, no. 1 (March 6, 2019): 36. https://doi.org/10.1186/s13058-019-1123-2

### Relevant background papers 

- Genome wide detection of enhancer hijacking in cancer, https://youtu.be/J61hFn5lB14

- Barutcu, A. Rasim, Bryan R. Lajoie, Rachel P. McCord, Coralee E. Tye, Deli Hong, Terri L. Messier, Gillian Browne, et al. “Chromatin Interaction Analysis Reveals Changes in Small Chromosome and Telomere Clustering between Epithelial and Breast Cancer Cells.” Genome Biology 16, no. 1 (December 2015). https://doi.org/10.1186/s13059-015-0768-0.

- Wu, Pengze, Tingting Li, Ruifeng Li, Lumeng Jia, Ping Zhu, Yifang Liu, Qing Chen, Daiwei Tang, Yuezhou Yu, and Cheng Li. “3D Genome of Multiple Myeloma Reveals Spatial Genome Disorganization Associated with Copy Number Variations.” Nature Communications 8, no. 1 (December 2017): 1937. https://doi.org/10.1038/s41467-017-01793-w.

- Rhie, Suhn Kyong, Andrew A. Perez, Fides D. Lay, Shannon Schreiner, Jiani Shi, Jenevieve Polin, and Peggy J. Farnham. “A High-Resolution 3D Epigenomic Map Reveals Insights into the Creation of the Prostate Cancer Transcriptome.” Nature Communications 10, no. 1 (December 2019): 4154. https://doi.org/10.1038/s41467-019-12079-8.

- Achinger-Kawecka, Joanna, Clare Stirzaker, Kee-Ming Chia, Neil Portman, Elyssa Campbell, Qian Du, Geraldine Laven-Law, et al. “Epigenetic Therapy Suppresses Endocrine-Resistant Breast Tumour Growth by Re-Wiring ER-Mediated 3D Chromatin Interactions.” Preprint. Molecular Biology, June 22, 2021. https://doi.org/10.1101/2021.06.21.449340.

- Achinger-Kawecka, Joanna, Fatima Valdes-Mora, Phuc-Loi Luu, Katherine A. Giles, C. Elizabeth Caldon, Wenjia Qu, Shalima Nair, et al. “Epigenetic Reprogramming at Estrogen-Receptor Binding Sites Alters 3D Chromatin Landscape in Endocrine-Resistant Breast Cancer.” Nature Communications 11, no. 1 (December 2020): 320. https://doi.org/10.1038/s41467-019-14098-x.

#### Software

- [HiCExplorer](https://github.com/deeptools/HiCExplorer/) - set of programs to process, normalize, analyze and visualize Hi-C data, Python, .cool format, conversion utilities. https://hicexplorer.readthedocs.io/en/latest/, https://github.com/deeptools/HiCExplorer/
    - Ramírez, Fidel, Vivek Bhardwaj, Laura Arrigoni, Kin Chung Lam, Björn A. Grüning, José Villaveces, Bianca Habermann, Asifa Akhtar, and Thomas Manke. “[High-Resolution TADs Reveal DNA Sequences Underlying Genome Organization in Flies](https://doi.org/10.1038/s41467-017-02525-w).” Nature Communications 9, no. 1 (December 2018) 

- [FAN-C](https://github.com/vaquerizaslab/fanc) - Python pipeline for Hi-C processing. Input - raw FASTQ (aligned using BWA or Bowtie2, artifact filtering) or pre-aligned BAMs. KR or ICE normalization. Analysis and Visualization (contact distance decay, A/B compartment detection, TAD/loop detection, Average TAD/loop profiles, saddle plots, triangular heatmaps, comparison of two heatmaps).  Automatic or modular. Compatible with .cool and .hic formats. [Tweet1](https://twitter.com/vaquerizas_lab/status/1225011187668209664?s=20), [Tweet2](https://twitter.com/vaquerizasjm/status/1339937903473025027?s=20). [Table 1](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-02215-9/tables/1) - detailed comparison of 13 Hi-C processing tools
    - Kruse, Kai, Clemens B. Hug, and Juan M. Vaquerizas. “[FAN-C: A Feature-Rich Framework for the Analysis and Visualisation of Chromosome Conformation Capture Data](https://doi.org/10.1186/s13059-020-02215-9).” Genome Biology 21, no. 1 (December 2020)
    
- [GENOVA](https://github.com/dewitlab/GENOVA) - an R package for the most common Hi-C analyses and visualization. Quality control - cis/trans ratio, checking for translocations; A/B compartments - single and differential compartment signal (H3K4me1 for compartment assignment); TADs - insulation score and directionality index; Genomic annotations - ChIP-seq signal, gene information; Distance decay, and differential analysis; Saddle plot; Aggregate region/peak/TAD/loop analysis, and differential analysis; Aggregated signal (tornado) plots; Intra-inter-TAD interaction differences; PE-SCAn (paired-end Spatial Chromatin Analysis) and C-SCAn enhancer-promoter aggregation. Data for statistical tests can be extracted from the discovery objects. Applied to Hi-C data from Hap1 cells, WT and deltaWAPL (published) and knockdown cohesin-SA1/SA2 conditions (HiC-pro, hg19, HiCCUPS). Input - HiC-pro, Juicer, .cool files. Storage - compressed sparse triangle format and the user-added metadata. All tools return the "discovery object". [GitHub](https://github.com/dewitlab/GENOVA), [Vignette](https://github.com/robinweide/GENOVA/blob/master/vignettes/GENOVA_vignette.pdf)
    - Weide, Robin H. van der, Teun van den Brand, Judith H.I. Haarhuis, Hans Teunissen, Benjamin D. Rowland, and Elzo de Wit. “[Hi-C Analyses with GENOVA: A Case Study with Cohesin Variants](https://doi.org/10.1101/2021.01.22.427620).” Preprint. Genomics, January 24, 2021.
    
- [cooltools](https://github.com/mirnylab/cooltools) - tools to work with .cool files, [Documentation](https://cooltools.readthedocs.io/en/latest/)

- [HiGlass](http://higlass.io/) - visualization server for Google maps-style navigation of Hi-C maps. Overlay genes, epigenomic tracks. "Composable linked views" synchronizing exploration of multiple Hi-C datasets linked by location/zoom. [GitHub](https://github.com/higlass/higlass), [documentation](https://docs.higlass.io/), [links and resources](https://higlass.io/about)
    - Kerpedjiev, Peter, Nezar Abdennur, Fritz Lekschas, Chuck McCallum, Kasper Dinkla, Hendrik Strobelt, Jacob M. Luber, et al. “[HiGlass: Web-Based Visual Exploration and Analysis of Genome Interaction Maps](https://doi.org/10.1186/s13059-018-1486-1).” Genome Biology, (December 2018).

- [Juicebox](https://aidenlab.org/juicebox/)

### How students can access the data (if data are stored on Talapas on UO's campus, BGMP staff can advise on changing file permissions so students can access data) 

Shared folder on VCU Google Drive

<!--
https://docs.google.com/forms/d/e/1FAIpQLSfPzrasa7hkQx45EDUe5fx1sqzLQPQNJw6Az9J6gwWS_u-wrg/viewform

# E-mail

From: Stacey Wagner <sdwagner@uoregon.edu>
Subject: [EXTERNAL] data for UO bioinformatics group projects
Date: August 23, 2021 at 3:43:44 PM EDT
To: Mikhail Dozmorov <mikhail.dozmorov@vcuhealth.org>

Hi Mikhail,

I hope all is well with you. Below if information about our student group projects if you are interested this round.

Best,
Stacey

Greetings from the University of Oregon Bioinformatics and Genomics Master’s Track, in the Knight Campus Graduate Internship Program!

Our newest cohort of 25 master’s students have been working hard this summer, balancing a mix of in-person and remote work.
 
We are seeking data for the students' group projects. Have a project sitting on the back-burner? Swamped with COVID data? Need initial data exploration on a new project? Our students can help!
 
If you would like to contribute data, please see https://bioinformatics.uoregon.edu/partners/student-projects/ for complete details. 
To submit a project for consideration, please fill out this form  The project description for will ask you to provide contact information for a project mentor, define the goals of the project, provide instructions for students about how to access the data, and list relevant papers from the field’s literature. 
See attached examples from previous years.
Please submit project descriptions no later than September 3rd.
 
Feel free to forward this email to colleagues who may also be interested.


---------------------------------
Stacey Wagner, PhD 
Director | Quantitative Life Science Tracks
Graduate Internship Program
Phil and Penny Knight Campus for Accelerating Scientific Impact
sdwagner@uoregon.edu 
internship.uoregon.edu
she/her/hers
-->





