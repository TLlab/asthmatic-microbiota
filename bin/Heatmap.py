#!/home/chenghan/miniconda3/bin/python
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns;sns.set()
import sys
# load data 
df=pd.read_csv(sys.argv[1],delimiter="\t")
#flig=sns.load_dataset("flights")
ax=df.pivot('species','sample','rdp_ard')
sns.clustermap(ax,cmap="RdYlGn_r",figsize=(20,20),center=0,metric="braycurtis")
plt.savefig(sys.argv[1]+".png")
plt.show()

