#!/home/chenghan/miniconda3/bin/python

import sys
from scipy import stats


# set two lists of numbers

a=list(map(float,sys.argv[1].split(',')))
b=list(map(float,sys.argv[2].split(',')))


# do paired T-test and output the p-value

wp=stats.wilcoxon(a,b)
print(wp.pvalue,end="")


