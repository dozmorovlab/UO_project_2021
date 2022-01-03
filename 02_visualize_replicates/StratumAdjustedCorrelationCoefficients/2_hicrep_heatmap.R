
setwd("~/School/Graduate School/University of Oregon/VCU/hicrep")
library(tidyverse)
library(plyr)
library(stringi)


mydir = "~/School/Graduate School/University of Oregon/VCU/hicrep"
myfiles = list.files(path=mydir, pattern = "*.txt", full.names=TRUE)
dat_csv = lapply(myfiles, read_csv) #read all txt files

df <- data.frame(dat_csv) #dataframe
df <- df[-1,] #remove first row: #
rownames(df) <- c(1:24) #rename rownames
#summary(df)

cn <- c() #contains all the pairwise comparison name
n_col <- colnames(df) #names of column
for (i in 1:length(n_col)){ 
  name <- n_col[i]
  cn <- append(cn, str_sub(name, -39, -27))
}

colnames(df) <- cn


df_chr1 <- df[1,] #contains the first row of df (chromosome 1)

col_1 <- c() #contains the first sample (pair-wise)
col_2 <- c() #contains the 2nd sample (pair-wise)
scc <- c() #contains scc value for the pair-wise comparison
for (i in 1:length(df_chr1)){
  str <- colnames(df_chr1)[i]
  two_col <- str_split_fixed(str, "_", 2)
  col_1 <- append(col_1, two_col[1])
  col_2 <- append(col_2, two_col[2])
  scc <- append(scc, df_chr1[i])
}

col_1 <- data.frame(col_1)
col_2 <- data.frame(col_2)
scc <- data.frame(scc)
scc <- data.frame(t(scc))
colnames(scc) <- c("scc")

df_chr1_hm <- data.frame()
df_chr1_hm <- cbind(col_1, col_2, scc) #dataframe with all the values

df_chr1_rev <- data.frame()
df_chr1_rev <- cbind(col_2, col_1, scc) #dataframe with all the values, in reverse
colnames(df_chr1_rev) <- c("col_1", "col_2", "scc") #to add columns into correct columns in rbind

df_chr1_hm <- rbind(df_chr1_hm, df_chr1_rev) #all values

df_chr1_hm$col_1 <- str_replace_all(df_chr1_hm$col_1, c("105259" = "PR1_105259", "102770" = "PR2_102770", "102933" = "PR3_102933", "105242" = "CR1_105242", "105244" = "CR2_105244", "105246" = "CR3_105246", "100887" = "LM1_100887", "100888" =  "LM2_100888", "100889" = "LM3_100889"))

df_chr1_hm$col_2 <- str_replace_all(df_chr1_hm$col_2, c("105259" = "PR1_105259", "102770" = "PR2_102770", "102933" = "PR3_102933", "105242" = "CR1_105242", "105244" = "CR2_105244", "105246" = "CR3_105246", "100887" = "LM1_100887", "100888" =  "LM2_100888", "100889" = "LM3_100889"))

#df_chr1_hm$col_1 <- rbind(df_chr1_hm$col_1, df_chr1_hm$col_2)

df_chr1_hm$scc <- as.numeric(as.character(df_chr1_hm$scc)) #to make scc continuous (not discrete); helps with making heatmap




# make heatmap for chr1

plt_chr1 <- ggplot(df_chr1_hm, aes(x=col_1, y=col_2, fill=scc)) + geom_tile() + geom_text(aes(label = round(scc, 1))) + coord_fixed() + scale_fill_gradient(low = "white", high = "red") + theme(axis.text.x = element_text(angle = 90), axis.title.x=element_blank(), axis.title.y=element_blank()) + ggtitle("Chromosome 1")
ggsave("scc_heatmap_chr1.jpg", plot=plt_chr1)




# average

df_num <- lapply(df, as.numeric)
df_num <- data.frame(df_num)
df_mean <- data.frame(colMeans(df_num))

rn <- c() #contains all the pairwise comparison name
n_row <- rownames(df_mean) #names of column
for (i in 1:length(n_row)){ 
  name <- n_row[i]
  rn <- append(rn, str_sub(name, 2, -1))
}

rownames(df_mean) <- rn


col_1 <- c() #contains the first sample (pair-wise)
col_2 <- c() #contains the 2nd sample (pair-wise)
scc <- c() #contains scc value for the pair-wise comparison
for (i in 1:nrow(df_mean)){
  str <- rownames(df_mean)[i]
  two_col <- str_split_fixed(str, "_", 2)
  col_1 <- append(col_1, two_col[1])
  col_2 <- append(col_2, two_col[2])
  scc <- append(scc, df_chr1[i])
}

col_1 <- data.frame(col_1)
col_2 <- data.frame(col_2)
scc <- data.frame(scc)
scc <- data.frame(t(scc))
colnames(scc) <- c("scc")

df_mean_hm <- data.frame()
df_mean_hm <- cbind(col_1, col_2, scc) #dataframe with all the values

df_mean_rev <- data.frame()
df_mean_rev <- cbind(col_2, col_1, scc) #dataframe with all the values, in reverse
colnames(df_mean_rev) <- c("col_1", "col_2", "scc") #to add columns into correct columns in rbind

df_mean_hm <- rbind(df_mean_hm, df_mean_rev) #all values

df_mean_hm$col_1 <- str_replace_all(df_mean_hm$col_1, c("105259" = "PR1_105259", "102770" = "PR2_102770", "102933" = "PR3_102933", "105242" = "CR1_105242", "105244" = "CR2_105244", "105246" = "CR3_105246", "100887" = "LM1_100887", "100888" =  "LM2_100888", "100889" = "LM3_100889"))

df_mean_hm$col_2 <- str_replace_all(df_mean_hm$col_2, c("105259" = "PR1_105259", "102770" = "PR2_102770", "102933" = "PR3_102933", "105242" = "CR1_105242", "105244" = "CR2_105244", "105246" = "CR3_105246", "100887" = "LM1_100887", "100888" =  "LM2_100888", "100889" = "LM3_100889"))

#df_chr1_hm$col_1 <- rbind(df_chr1_hm$col_1, df_chr1_hm$col_2)

df_mean_hm$scc <- as.numeric(as.character(df_chr1_hm$scc)) #to make scc continuous (not discrete); helps with making heatmap


# heatmap_mean

plt <- ggplot(df_mean_hm, aes(x=col_1, y=col_2, fill=scc)) + geom_tile() + coord_fixed() + scale_fill_gradient(low = "white", high = "red") + geom_text(aes(label = round(scc, 1))) + theme(axis.text.x = element_text(angle = 90), axis.title.x=element_blank(), axis.title.y=element_blank()) + ggtitle("Pairwise Comparison using SCC Scores")

ggsave("scc_heatmap.jpg", plot=plt)
