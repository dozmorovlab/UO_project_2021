
library(tidyverse)
library(dplyr)
####HARDCODED####

# AB Compartment
# load the data
data <- read_tsv("./merged/differential.intra_sample_combined.pcQnm.bedGraph", col_names = TRUE)
data_filtered <- read_tsv("./merged/differential.intra_sample_combined.Filtered.pcQnm.bedGraph", col_names = TRUE)

#nrow(data)


# Find A/B compartments and Switches throughout the genome
n_atob <- data %>% filter(exp1>0 & exp2<0 & padj<0.05)
n_btoa <- data %>% filter(exp1<0 & exp2>0 & padj<0.05)
n_atoa <- data %>% filter(exp1>0 & exp2>0)
n_btob <- data %>% filter(exp1<0 & exp2<0)

# ignore these for now
#n <- data %>% filter(exp1>0 & exp2<0 & padj>0.05)
#o <- data %>% filter(exp1<0 & exp2>0 & padj>0.05)



# create a piechart of compartment switches in the genome
# create data frame with all the compartments
switch <- c("A->A", "A->B", "B->A", "B->B")
compartments <- data.frame(switch=switch, genome=c(nrow(n_atoa),nrow(n_atob),nrow(n_btoa),nrow(n_btob)))

# add percentages
df_compartments <- compartments %>% mutate(pct=`genome`/sum(`genome`)) %>% mutate(percentage=scales::percent(pct))

# pieplot
#ggplot(compartments, aes(x="", y=value,fill=switch)) + geom_col() + geom_text(aes(label=percentage),position=position_stack(vjust=0.5))+coord_polar(theta="y")
png("compartment.png")

pie(df_compartments$genome,main="Compartment Switch from \n Primary to Liver Metastasis", labels=df_compartments$percentage,col=c("#798994","#ADD8E5","#FFFFC2","#a5b1b8"),cex=2)
legend("topright",legend=switch,fill=c("#798994","#ADD8E5","#FFFFC2","#a5b1b8"))

dev.off() 


# bargraph with compartment switches in each chromosomes
chromosomes=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")

# create dataframe (compartments) with the number of compartment switches
for (i in chromosomes){
  chrom <- data %>% filter(chr==i)
  
  n_atob <- chrom %>% filter(exp1>0 & exp2<0 & padj<0.05)
  n_btoa <- chrom %>% filter(exp1<0 & exp2>0 & padj<0.05)
  n_atoa <- chrom %>% filter(exp1>0 & exp2>0)
  n_btob <- chrom %>% filter(exp1<0 & exp2<0)
  
  df_chrom <- data.frame(i=c(nrow(n_atoa),nrow(n_atob),nrow(n_btoa),nrow(n_btob)))
  compartments <- cbind(compartments, df_chrom)
  
}

colnames(compartments) <- c("Switch","Genome",chromosomes)
rownames(compartments) <- compartments$Switch
compartments <- as.matrix(compartments[,c(-1:-2)])
compartments <- compartments[c("A->A","B->B","A->B","B->A"),]

colnames(compartments) <- str_replace(colnames(compartments), "chr","")


########
# selecting certain chromosomes for the bargraph
#compartments <- data.frame(compartments)
#colnames(compartments) <- c(chromosomes)
#colnames(compartments) <- str_replace(colnames(compartments), "chr","")

#compartments_with_good_pc <- compartments %>% select(1,3,6,8,10,11,12,17,19,20,23)

##########


png("chromosome_largefont.png",width = 900)

compartments_with_good_pc <- as.matrix(compartments_with_good_pc)

barplot(compartments_with_good_pc, main="Compartment Switches", space=0.4, ylim=c(0,4000), ylab="Frequency of the Switches",xlab="Chromosomes", col=c("#798994","#a5b1b8","#ADD8E5","#FFFFC2"),width=5,cex.lab=2,cex.axis=2,cex.sub=2)
#legend("topright",legend=c("A->A","B->B","A->B","B->A"),fill=c("#798994","#a5b1b8","#ADD8E5","#FFFFC2"))

dev.off()
