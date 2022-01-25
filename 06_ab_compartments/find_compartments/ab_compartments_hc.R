#setwd("~/School/Graduate School/University of Oregon/VCU/ab_compartments")
#libPaths("C:/Users/juyou/Documents/R/win-library/4.1")
# download hg38 genes
# aif (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")

# BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene")

# download karyoploteR to plot the genes
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")

# BiocManager::install("karyoploteR")

# load library
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(karyoploteR)
library(tidyverse)
library(optparse)

#optparse
#option_list <- list(
#  make_option(c("-o", "--pcaone"), action="store", default=NA, type='character', help="Absolute pathway to the PCA1.bedgraph file."),
#  make_option(c("-t", "--pcatwo"), action="store", default=NA, type='character', help="Absolute pathway to the PCA2.bedgraph file."),
#  make_option(c("-c", "--chromosome"), action="store", default=NA, type='character', help="Specify the chromosome of interest. Ex: 1, 2, 3 .. X, Y"),
#  make_option(c("-p", "--picname"), action="store", default=NA, type='character', help="Name of the A/B compartment output file. Ex: compartment.png")
#)
#opt <- parse_args(OptionParser(option_list=option_list))

# store data
txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene

# extract genes
all_genes <- genes(txdb)

#head(all_genes)

# load PCA eigenvectors
df_pca1 <- read_tsv("LM_pca1_ICE_corrected.bedGraph", col_names = FALSE)
df_pca2 <- read_tsv("LM_pca2_ICE_corrected.bedGraph", col_names = FALSE)
colnames(df_pca1) <- c("Chromosome", "Start", "End", "Vector")
colnames(df_pca2) <- c("Chromosome", "Start", "End", "Vector")

df_pca1_PR1 <- read_tsv("PR1_pca1_ICE_corrected.bedGraph", col_names = FALSE)
df_pca2_PR1 <- read_tsv("PR1_pca2_ICE_corrected.bedGraph", col_names = FALSE)
colnames(df_pca1_PR1) <- c("Chromosome", "Start", "End", "Vector")
colnames(df_pca2_PR1) <- c("Chromosome", "Start", "End", "Vector")

df_pca1_PR2 <- read_tsv("PR2_pca1_ICE_corrected.bedGraph", col_names = FALSE)
df_pca2_PR2 <- read_tsv("PR2_pca2_ICE_corrected.bedGraph", col_names = FALSE)
colnames(df_pca1_PR2) <- c("Chromosome", "Start", "End", "Vector")
colnames(df_pca2_PR2) <- c("Chromosome", "Start", "End", "Vector")

# look at specific chromosome
df_pca1_x <- df_pca1 %>% filter(Chromosome=="20")
df_pca2_x <- df_pca2 %>% filter(Chromosome=="20")

df_pca1_PR1_x <- df_pca1_PR1 %>% filter(Chromosome=="20")
df_pca2_PR1_x <- df_pca2_PR1 %>% filter(Chromosome=="20")

df_pca1_PR2_x <- df_pca1_PR1 %>% filter(Chromosome=="20")
df_pca2_PR2_x <- df_pca2_PR1 %>% filter(Chromosome=="20")

# plot
#kp <- plotKaryotype(genome = "hg38") # plot all chromosomes
#kp <- kpPlotDensity(kp, all_genes) # plot all the genes

# save plot to file
png("chr20_lm_pca1_pca2_1.png", width = 1500, height = 800) # store graph into file

# look at specific region of the chromosome
#zoom.region <- toGRanges(data.frame("chr20", 35e6, 60e6))

# plot specific chromosome
#kp <- plotKaryotype(genome="hg38", chromosomes = c(paste0("chr", 20)), zoom= zoom.region) #need to work on this. doesnt work
kp <- plotKaryotype(genome="hg38", chromosomes = c(paste0("chr", 20))) #add chromosome with cytoband
kp <- kpPlotDensity(kp, all_genes, ymax=100) #add gene density
kpAddBaseNumbers(kp, tick.dist = 10000000, tick.len = 10, minor.tick.dist = 1000000, minor.tick.len = 5, cex=1, add.units = TRUE) # add tick marks

# add pc eigenvectors
kpBars(kp, chr = paste0("chr", 20), x0=df_pca1_x$Start, x1=df_pca1_x$End, y1=df_pca1_x$Vector, r0=0.8, r1=1.0, data.panel=2, ymin=-0.05, ymax=0.05, cex=1.2) # LM pc1
kpBars(kp, chr = paste0("chr", 20), x0=df_pca2_x$Start, x1=df_pca2_x$End, y1=df_pca2_x$Vector, r0=0.6, r1=0.8, data.panel=2, ymin=-0.05, ymax=0.05, cex=1.2) # LM pc2
#kpBars(kp, chr = paste0("chr", 20), x0=df_pca1_PR1_x$Start, x1=df_pca1_PR1_x$End, y1=df_pca1_PR1_x$Vector, r0=0.9, r1=1.2, data.panel=2, ymin=-0.05, ymax=0.05, cex=1.2) # PR1 pc1
#kpBars(kp, chr = paste0("chr", 20), x0=df_pca2_PR1_x$Start, x1=df_pca2_PR1_x$End, y1=df_pca2_PR1_x$Vector, r0=1.1, r1=1.4, data.panel=2, ymin=-0.05, ymax=0.05, cex=1.2) # PR1 pc2
#kpBars(kp, chr = paste0("chr", 20), x0=df_pca1_PR2_x$Start, x1=df_pca1_PR2_x$End, y1=df_pca1_PR2_x$Vector, r0=0.8, r1=1.1, data.panel=2, ymin=-0.05, ymax=0.05, cex=1.2) # PR2 pc1
#kpBars(kp, chr = paste0("chr", 20), x0=df_pca2_PR2_x$Start, x1=df_pca2_PR2_x$End, y1=df_pca2_PR2_x$Vector, r0=1.1, r1=1.4, data.panel=2, ymin=-0.05, ymax=0.05, cex=1.2) # PR2 pc2

# add labels
kpAddLabels(kp, "Gene Density", cex=1.2, r0=0.1, r1=0.2) # label gene density
kpAddLabels(kp,"Metastasis PCA1", r0=0.8, r1=1.0, data.panel = 2, cex=1.2) # label LM pca1
kpAddLabels(kp, "Metastasis PCA2", r0=0.6, r1=0.8, data.panel = 2, cex=1.2) # label LM pca2


# kpAddCytobandLabels(kp, cex=1) # add cytoband labels
dev.off()