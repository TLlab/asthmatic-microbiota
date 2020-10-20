#!/usr/bin/env Rscript
library(ggplot2)
library(ade4)
library(RColorBrewer)
arg=commandArgs(trailingOnly=TRUE)

mat<-read.table(arg[1],sep="\t",row.names = 1,header=TRUE)
mat_sub <- mat[,1:2]
group <- as.factor(mat$group)

color <- c(brewer.pal(3,"Set1"))
ggplot(mat_sub, aes(x = PC1, y = PC2, color = group)) +
	geom_point(aes(color = group), size = 3, alpha = 0.6) +
	stat_ellipse(aes(x = PC1, y = PC2, fill = group), geom = "polygon", alpha = 0.1, level = 0.9) +
	scale_fill_manual(values= color) +
	scale_color_manual(values = color)
