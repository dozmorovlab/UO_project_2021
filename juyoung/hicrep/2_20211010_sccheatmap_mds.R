
setwd("~/School/Graduate School/University of Oregon/VCU/hicrep")
library(tidyverse)
library(plyr)
library(stringi)
library(ggrepel)

# read in data
mydir = "~/School/Graduate School/University of Oregon/VCU/hicrep"
myfiles = list.files(path=mydir, pattern = "*.txt", full.names=TRUE)
dat_csv = lapply(myfiles, read_csv) #read all txt files

df <- data.frame(dat_csv) #change to dataframe
df <- df[-1,] #remove first row bc it's '#'
rownames(df) <- c(1:24) #rename rownames
#summary(df)


# Mean of all scc for each pair-wise comparison

df_num <- lapply(df, as.numeric)
df_num <- data.frame(df_num) # change to dataframe
df_mean <- data.frame(colMeans(df_num)) #find means of each column

rn <- c() #will contains all the pairwise comparison name
n_row <- rownames(df_mean) #names of rows
for (i in 1:length(n_row)){ 
  name <- n_row[i]
  rn <- append(rn, str_sub(name, -39, -27))
}

rownames(df_mean) <- rn # change rowname to have pairwise comparison name


col_1 <- c() #contains the first sample (pair-wise)
col_2 <- c() #contains the 2nd sample (pair-wise)
scc <- c() #contains scc value for the pair-wise comparison
for (i in 1:nrow(df_mean)){
  str <- rownames(df_mean)[i]
  two_col <- str_split_fixed(str, "_", 2)
  col_1 <- append(col_1, two_col[1])
  col_2 <- append(col_2, two_col[2])
  scc <- append(scc, df_mean[i,1])
}

col_1 <- data.frame(col_1) #change to data.frame
col_2 <- data.frame(col_2) #change to data.frame
scc <- data.frame(scc) #change to data.frame

df_mean_hm <- data.frame()
df_mean_hm <- cbind(col_1, col_2, scc) #dataframe with all the values

# create _rev to fit into heatmap
df_mean_rev <- data.frame()
df_mean_rev <- cbind(col_2, col_1, scc) #dataframe with all the values, in reverse
colnames(df_mean_rev) <- c("col_1", "col_2", "scc") #to add columns into correct columns in rbind

df_mean_hm <- rbind(df_mean_hm, df_mean_rev) # contains all pairwise comparison (including duplicates) with scc scores

# rename replicate names
df_mean_hm$col_1 <- str_replace_all(df_mean_hm$col_1, c("105259" = "PR1_105259", "102770" = "PR2_102770", "102933" = "PR3_102933", "105242" = "CR1_105242", "105244" = "CR2_105244", "105246" = "CR3_105246", "100887" = "LM1_100887", "100888" =  "LM2_100888", "100889" = "LM3_100889"))
df_mean_hm$col_2 <- str_replace_all(df_mean_hm$col_2, c("105259" = "PR1_105259", "102770" = "PR2_102770", "102933" = "PR3_102933", "105242" = "CR1_105242", "105244" = "CR2_105244", "105246" = "CR3_105246", "100887" = "LM1_100887", "100888" =  "LM2_100888", "100889" = "LM3_100889"))

df_mean_hm$scc <- as.numeric(as.character(df_chr1_hm$scc)) #to make scc continuous (not discrete); helps with making heatmap


# heatmap_mean

plt <- ggplot(df_mean_hm, aes(x=col_1, y=col_2, fill=scc)) + geom_tile() + coord_fixed() + scale_fill_gradient(low = "white", high = "red") + geom_text(aes(label = round(scc, 2))) + theme(axis.text.x = element_text(angle = 90), axis.title.x=element_blank(), axis.title.y=element_blank()) + ggtitle("Pairwise Comparison using SCC Scores")

ggsave("scc_heatmap.jpg", plot=plt)






# mds

df_mean_mds <- df_mean_hm #transfer data to new variable

df_mean_mds$col_1 <- str_replace_all(df_mean_mds$col_1, c("PR1_105259" = "1", "PR2_102770"="2", "PR3_102933"="3", "CR1_105242"="4", "CR2_105244"="5", "CR3_105246"="6", "LM1_100887"="7", "LM2_100888"="8", "LM3_100889"="9")) #replace the values to numbers; helps with for loop
df_mean_mds$col_2 <- str_replace_all(df_mean_mds$col_2, c("PR1_105259" = "1", "PR2_102770"="2", "PR3_102933"="3", "CR1_105242"="4", "CR2_105244"="5", "CR3_105246"="6", "LM1_100887"="7", "LM2_100888"="8", "LM3_100889"="9"))

#help(cmdscale)
df_mds <- data.frame()
for (i in 1:nrow(df_mean_mds)){ #transfer data from df_mean_mds to data.frame that will be used for cmdscale()
  df_mds[df_mean_mds[i,1],df_mean_mds[i,2]]=df_mean_mds[i,3]
}

colnames(df_mds) <- str_replace_all(colnames(df_mds), c("^1$"="PR1_105259", "^2$"="PR2_102770", "^3$"="PR3_102933", "^4$"="CR1_105242", "^5$"="CR2_105244", "^6$"="CR3_105246", "^7$"="LM1_100887", "^8$"="LM2_100888", "^9$"="LM3_100889")) #rename the columns and rows, ^ means start of, $ means the end
rownames(df_mds) <- str_replace_all(colnames(df_mds), c("^1$"="PR1_105259", "^2$"="PR2_102770", "^3$"="PR3_102933", "^4$"="CR1_105242", "^5$"="CR2_105244", "^6$"="CR3_105246", "^7$"="LM1_100887", "^8$"="LM2_100888", "^9$"="LM3_100889"))

df_mds <- df_mds %>% select(sort(names(.)))
df_mds <- df_mds[ order(row.names(df_mds)), ]


df_matrix <- data.matrix(df_mds)
heatmap(df_matrix, Rowv=NA, Colv=NA, symm=TRUE)
#help(heatmap)


d <- dist(df_mds)
re <- cmdscale(d, k=2, eig=TRUE)
re

x <- re$points[,1]
y <- re$points[,2]

dfdf <- data.frame(x,y)
dfdf$group <- c("CR", "CR", "CR", "LM", "LM", "LM", "PR", "PR", "PR")

pt_mds <- ggplot(dfdf, aes(x=x, y=y), color=group) + geom_point(aes(color=group), size=3) + geom_text_repel(label=row.names(dfdf), box.padding = 0.35, point.padding = 0.5) + theme_classic() + labs(title="MDS Plot for Replicates", color="Conditions")
ggsave("qc_mds.jpg", plot=pt_mds, width = 10, height = 10, dpi = 300)
