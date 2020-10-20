# The nasal, throat and stool 16S microta analysis script for the 56 asthmatic children

#ChengHan-Lin, Tsunglin Liu

######################################## analysis tools 
# FastQC
# FLASH v1.2.11 
# USEARCH v11.0667
# QIIME v1.9
# RDP classifier v2.12
# BLAST
# perl 
# python (module: scipy v1.4.1, seaborn v0.9)
# R v3.6.2 (package: ANCOM v2.1, vegan v2.5)
# Then add the directory bin to your $PATH

######################################## Data preprocess 
# merge fastq
mkdir flash
cd flash
for i in ../raw_data/*_1.fq;do flash -M 300 -t 8 -o `basename $i _1.fq` ../raw_data/$i ../raw_data/`basename $i _1.fq`_2.fq &>> total.stat;done
cd ..

# filter by length
mkdir ml400_flash
cd ml400_flash
for i in ../flash/*.extendedFrags.fastq;do Filterfastqbylength.pl -m 400 $i>`basename $i .extendedFrags.fastq`.fq;done
ls *.fq > sample.id
cd ..

# uparse (unoise3)
mkdir uparse
cd uparse
CatMergedRead4Uparse.pl ../ml400_flash/sample.id > merge.fq
usearch -fastq_filter merge.fq -fastq_maxee 1.0 -relabek Filt -fastaout filtered.fa
usearch -fastx_uniques filtered.fa -relabel Uniq -sizeout -fastaout unique.fa -threads 6
usearch -sortbysize unique.fa -fastaout uniques_min2.fa -minsize 2
usearch -unoise3 uniques_min2.fa -zotus zotus.fa -tabbedout unoise3.txt
usearch -otutab merge.fq -threads 8 -zotus zotus.fa -otutabout zotutab.txt
# remove low coverage sample: S52(TR6),S2(TA19),S94(SA4),S18(TA6),S36(TR19),S126(SR4)
RemoveSample.pl -rs TA6,TR6,SA4,SR4,TA19,TR19 zotutab.txt > tmp
FilterZeroOtutable.pl tmp > zotutab.txt
rm tmp
# filter contamination(non-16S sequences)
java -Xmx1g -jar ~/biosoft/rdp_classifier/rdp_classifier_2.12/dist/classifier.jar classify -c 0.8 -f fixrank -o zotus.rdp zotus.fa
perl -F"\t" -ape 'if($F[7]>=0.8){$_="";}else{$_="$F[0]\n";}' zotus.rdp > lcotus.id
Extrafast.pl lcotus.id zotus.fa > lcotus.fa 
my_web_blast.pl megablast nt lcotus.fa > lcotus.megablast 2> lcotus.err
Non16SOtu.pl lcotus.megablast lcotus.id > non16s_nohit.id
FilterFasta.pl non16s_nohit.id zotus.fa > zotus_n16s.fa
FilterOtuTable.pl non16s_nohit.id zotutab.txt > zotutab_n16s.txt
cd ..

########################################  analysis nose throat stool data of asthma
mkdir taxonomy
cd taxonomy
ln -s ../uparse/zotutab_n16s.txt . 
ln -s ../uparse/zotus_n16s.fa .
ln -s ../uparse/zotus.rdp .
# classify nose,throat,stool sample
NoThSt.pl zotutab_n16s.txt 
for i in nose throat stool;do classify.pl -t attack ../raw_data/sample_mapping.txt zotutab_$i.txt > zotutab_$i\_attack.txt;done
for i in nose throat stool;do classify.pl -t recovery ../raw_data/sample_mapping.txt zotutab_$i.txt > zotutab_$i\_recovery.txt;done
# beta diversity(all)
align_seqs.py -i zotus_n16s.fa -o matrix
filter_alignment.py -i matrix/zotus_n16s_aligned.fasta
make_phylogeny.py -i zotus_n16s_aligned_pfiltered.fasta -o zotus_n16s.tree
biom convert -i zotutab_n16s.txt -o zotutab_n16s.biom --table-type="OTU table" --to-json
single_rarefaction.py -i zotutab_n16s.biom -o zotutab_n16s_rare.biom -d 57948
biom convert -i zotutab_n16s_rare.biom -o zotutab_n16s_rare.txt --to-tsv
beta_diversity_through_plots.py -i zotutab_n16s_rare.biom -m ../information/sample_mapping.txt -o All_rare -t zotus_n16s.tree
# beta diversity(nose, throat, stool)
for i in nose throat stool;do biom convert -i zotutab_$i.txt -o zotutab_$i.biom --table-type="OTU table" --to-json;done;
single_rarefaction.py -i zotutab_throat.biom -o zotutab_throat_rare.biom -d 62943
single_rarefaction.py -i zotutab_stool.biom -o zotutab_stool_rare.biom -d 66224
single_rarefaction.py -i zotutab_nose.biom -o zotutab_nose_rare.biom -d 57948
for i in nose throat stool;do biom convert -i zotutab_$i\_rare.biom -o zotutab_$i\_rare.txt --to-tsv;done
for i in nose throat stool;do perl ../bin/ExtrafastFormZotu.pl zotutab_$i\_rare.txt zotus_n16s.fa > zotus_$i\_rare.fa;done
for i in nose throat stool;do align_seqs.py -i zotus_$i\_rare.fa -o matrix_$i;done
for i in nose throat stool;do filter_alignment.py -i matrix_$i/zotus_$i\_rare_aligned.fasta;done
for i in nose throat stool;do make_phylogeny.py -i zotus_$i\_rare_aligned_pfiltered.fasta -o zotus_$i\_rare.tree;done
for i in nose throat stool;do beta_diversity_through_plots.py -i zotutab_$i\_rare.biom -m ../information/$i\_Info -o $i\_rare -t zotus_$i\_rare.tree;done
# beta diversity(attack, recovery)
for i in nose throat stool;do perl -pe 'if($_=~/recovery/){$_=""}' ../information/$i\_Info > ../information/$i\_attack_Info;done
for i in nose throat stool;do perl -pe 'if($_=~/attack/){$_=""}' ../information/$i\_Info > ../information/$i\_recovery_Info;done
for i in nose throat stool;do for j in attack recovery;do biom convert -i zotutab_$i\_$j.txt -o zotutab_$i\_$j.biom --table-type="OTU table" --to-json;done;done
for i in attack recovery;do single_rarefaction.py -i zotutab_nose_$i.biom -o zotutab_nose_$i\_rare.biom -d 57948;done
for i in attack recovery;do single_rarefaction.py -i zotutab_throat_$i.biom -o zotutab_throat_$i\_rare.biom -d 62943;done
for i in attack recovery;do single_rarefaction.py -i zotutab_stool_$i.biom -o zotutab_stool_$i\_rare.biom -d 66224;done
for i in nose throat stool;do for j in attack recovery;do beta_diversity_through_plots.py -i zotutab_$i\_$j\_rare.biom -m ../information/$i\_$j\_Info -o $i\_$j\_rare -t zotus_$i\_rare.tree;done;done
# alpha diversity(nose)
for i in attack recovery;do biom convert -i zotutab_nose_$i\_rare.biom -o zotutab_nose_$i\_rare.txt --to-tsv;done
for i in attack recovery;do perl -pe 'if ($.==1){$_=""}' -i zotutab_nose_$i\_rare.txt;done
for i in zotutab_nose_attack_rare.txt zotutab_nose_recovery_rare.txt;do Zotu2Genus.pl zotus.rdp $i > `basename $i .txt`\_genus.txt;done
for i in zotutab_nose_attack_rare_genus.txt zotutab_nose_recovery_rare_genus.txt;do perl -pe 'if($_=~/unclassified/){$_=""}' -i $i;done
for i in zotutab_nose_attack_rare_genus.txt zotutab_nose_recovery_rare_genus.txt;do biom convert -i $i -o `basename $i .txt`.biom --table-type="OTU table" --to-json;done
alpha_diversity.py -i zotutab_nose_attack_rare_genus.biom -m shannon -o nose_attack.shannon
alpha_diversity.py -i zotutab_nose_recovery_rare_genus.biom -m shannon -o nose_recovery.shannon
shannon.pl ../information/nose_attack_Info nose_recovery.shannon nose_attack.shannon ../information/nose_recovery_Info > shannon_nose_comp
# make 2D PCoA plot
Make2dPCA.pl -g igeclass ../information/nose_attack_Info nose_attack_rare/weighted_unifrac_pc.txt
# Taxonomy
for i in zotutab_nose*.txt;do Zotu2Genus.pl zotus.rdp $i > `basename $i .txt`\_genus.txt;done
for i in zotutab_throat*.txt;do Zotu2Genus.pl zotus.rdp $i > `basename $i .txt`\_genus.txt;done
for i in zotutab_stool*.txt;do Zotu2Genus.pl zotus.rdp $i > `basename $i .txt`\_genus.txt;done
for i in *genus.txt;do OtuFrequency.pl $i > `basename $i .txt`.freq;done
for i in *genus.txt;do perl -pe 'if($_=~/unclassified/){$_=""}' -i $i;done
for i in nose throat stool;do for j in attack recovery; do creatHeatmap.pl -top 40 -out $i\_$j.heatmap zotutab_$i\_$j\_genus.freq;done;done
for i in nose throat stool;do TaxBarPlot.pl -out bar_$i\_attack -top 10 ../information/order_$i zotutab_$i\_attack_genus.freq zotutab_$i\_recovery_genus.freq;done
for i in nose throat stool;do TaxBarPlot_R.pl -out bar_$i\_recovery ../information/$i\_Info zotutab_$i\_recovery_genus.freq bar_$i\_attack;done
cd ..

######################################## Statistics nose throat stool data between attack and recovery
# permanova
mkdir statistics
cd statistics
for i in nose throat stool;do for j in attack recovery;do ChangefileOrder.pl ../taxonomy/$i\_$j\_rare/weighted_unifrac_dm.txt ../information/$i\_$j\_Info > $i\_$j.log;done;done
for i in nose throat stool;do for j in attack recovery;do mv $i\_$j.log $i\_$j\_Info;done;done
for i in nose throat stool;do for j in attack recovery;do for g in gender igeclass abo set lewist Allergy pet agelevel;do RmNAsample.pl -group $g $i\_$j\_Info ../taxonomy/$i\_$j\_rare/weighted_unifrac_dm.txt > $i\_$j\_$g.log;done;done;done
for i in nose throat stool;do for j in attack recovery;do for g in gender igeclass abo set lewist Allergy pet agelevel;do Permanova.r -i $i\_$j\_$g.log -g $i\_$j\_Info -f dis~batch+$g -o $i\_$j\_$g.permanova;done;done;done
rm *.log
# ancom
for i in nose throat stool;do for j in attack recovery;do for g in gender igeclass abo set lewist Allergy pet agelevel;do RmNAsample.pl -group $g $i\_$j\_Info ../taxonomy/zotutab_$i\_$j\_genus.txt > $i\_$j\_$g.log;done;done;done
for i in nose throat stool;do for j in attack recovery;do for g in gender igeclass abo set lewist Allergy pet agelevel;do ancom.r -i $i\_$j\_$g.log -m $i\_$j\_Info -v $g -a batch -o ancom_$i\_$j\_$g;done;done;done
for i in nose throat stool;do ancom.r -i zotutab_$i\_genus.txt -m $i\_Info -v state -a batch -r "~1|pid" -o ancom_$i;done
cd ..

####  analysis species level
mkdir species
cd species
ln -s ../taxonomy/zotus_n16s.fa
ln -s ../taxonomy/zotutab_n16s_rare.txt 
ln -s ../taxonomy/zotus.rdp 
AddFastaSize.pl zotutab_n16s_rare.txt zotus_n16s.fa > del
usearch -sortbysize del -fastaout zotus_n16s_size.fa -minsize 1
rm del
usearch -cluster_smallmem zotus_n16s_size.fa -id 0.99 -sortedby size -uc clusters.uc





