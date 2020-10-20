#!/usr/bin/env Rscript
library(vegan)
library(getopt)
library(readr)
#arg=commandArgs(trailingOnly=TRUE)
# set option
spec <- matrix(
	c("group","g",2,"character","the covariance for adonis",
	"input","i",2,"character","input",
	"formula","f",2,"character","formula",
	"output","o",1,"character","output"
	),
	byrow=TRUE,ncol=5)
opt <- getopt(spec=spec)

# adonis
dis <- read.delim(opt$input, row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE,header=TRUE)
dis<-as.dist(dis)
data <- read.delim(opt$group, sep = '\t', stringsAsFactors = FALSE)
f<-formula(opt$formula)
adonis_result <- adonis2(f, data, permutations = 9999)
write_tsv(adonis_result, opt$output)

