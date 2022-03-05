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