#!/usr/bin/env Rscript
library(readr)
library(tidyr)
library(getopt)
source("../bin/ancom_v2.1.R")
#arg=commandArgs(trailingOnly=TRUE)
# set option
spec <- matrix(
	c("zotutab","i",2,"character","zotutab",
	"metadata","m",2,"character","metadata",
	"var","v",2,"character","var",
	"adjv","a",1,"character","adjv",
	"rf","r",1,"character","rand formula",
	"out","o",2,"character","output"
	),
	byrow=TRUE,ncol=5)
opt <- getopt(spec=spec)

# ancom
mat<-read.delim(opt$zotutab,sep="\t",row.names = 1,header=TRUE)
meta_data = read_tsv(opt$metadata)
prepro = feature_table_pre_process(mat, meta_data, "#SampleID", NULL,0.05, 0.95, 1000, FALSE)
res=ANCOM(prepro$feature_table,prepro$meta_data,prepro$structure_zeros,opt$var,"BH",0.05,opt$adjv,opt$rf)
write_tsv(res$out, opt$out)
# plot
n_taxa = ifelse(is.null(prepro$structure_zeros), nrow(prepro$feature_table), sum(apply(prepro$structure_zeros, 1, sum) == 0))
cut_off = c(0.9 * (n_taxa -1), 0.8 * (n_taxa -1), 0.7 * (n_taxa -1), 0.6 * (n_taxa -1))
names(cut_off) = c("detected_0.9", "detected_0.8", "detected_0.7", "detected_0.6")
# 
dat_ann = data.frame(x = min(res$fig$data$x), y = cut_off["detected_0.7"], label = "W[0.7]")
fig = res$fig +
geom_hline(yintercept = cut_off["detected_0.7"], linetype = "dashed") +
geom_text(data = dat_ann, aes(x = x, y = y, label = label),
size = 4, vjust = -0.5, hjust = 0, color = "orange", parse = TRUE)
png(file=paste(opt$out,"png",sep="."))
fig 
dev.off()
