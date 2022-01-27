# AB Compartment Analysis

A and B comparments are sometimes refered to as open and closed compartments, respectively. An open compartment generally has less tightly bound chromatin allowing for greater gene expression, where the opposite is true for closed compartments. When looking at a HIC matrix, the checker board pattern can implicitly be mapped to open and closed compartments. 

## Find Compartments

In this work, we attempt to identify open and closed comparments. There are a few ways to do this, but we decided to use Principle Component Analysis and rely on gene density to determine if the positive eigenvalues correlated with open or closed compartments. 

![ab_eigen](find_compartments/output/chr20_lm_pca1_pca2_1.png)

The figure above shows two components for liver metastasis on chromosome 20 and with gene density. The second component seems to follow the gene density curve more closely, so positive and negative values should be more indicative open and closed compartments. 

## Differential Analysis of Comparmental Switches

A hallmark of cancer progression is the structural modifications of chromosomes. There is a possibility that a previously closed compartment could open up in later stages of cancer development, and vice versa. Below shows the results of our samples:

![diff_analysis](diff_analysis_compartmental_switches/dchic/output/bychromosome_withlegend.png)

![diff_analysis](diff_analysis_compartmental_switches/dchic/output/compartment_withlegend.png)

We see a shift in AB compartments in later stages (see B -> A, A -> B)

