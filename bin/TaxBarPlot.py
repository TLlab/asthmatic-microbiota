#!/home/chenghan/miniconda3/bin/python

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import sys
import plotly.graph_objs as go
import plotly.offline as py
large=22;med=16;small=10
params = {'axes.labelsize': small,
	'xtick.labelsize': small,
	'ytick.labelsize': small}

plt.rcParams.update(params)
plt.figure(figsize=(18,10))
# import data
df=pd.read_csv(sys.argv[1],delimiter="\t")
fin=open(sys.argv[1])
line=fin.readline()
l=line.rstrip()
a=l.split("\t")
del a[0]
x=df[a[0]]
top=int(sys.argv[2])+1
#
plt.bar(df.ID,df[a[0]],label=a[0],color="#A0CDE2")
plt.bar(df.ID,df[a[1]],bottom=x,label=a[1],color="#179C77")
color=["green","#D85F00","violet","blueviolet","#8A817C","b","deepskyblue","mediumturquoise","lime","#B9ACD0","lightgray","yellow","yellowgreen","#B33951","peru","k","limegreen","y","#FF206E","#A4349C","r","#54494B","#91C7B1","#BFA89E","#7B1E7A","#5D576B","lightgray"]
for i in range(2,top):
	x=x+df[a[i-1]]
	rco=int((i-1)%26)
	plt.bar(df.ID,df[a[i]],bottom=x,label=a[i],color=[color[rco]])
#plt.bar(df.cluster,df.IV,width = 0.5,edgecolor = 'black',bottom=df.I+df.II+df.III,label="IV")
plt.xticks(rotation=90,size=13)
plt.legend(loc='center left', bbox_to_anchor=(1, 0.5),ncol=1)
plt.savefig(sys.argv[1]+".png")
plt.show()









