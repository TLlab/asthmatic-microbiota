#!/usr/bin/perl -w
#usage: perl ExtrafastFormZotu.pl zotutab_throat_rare.txt zotus_n16s.fa > Throat.fa
use strict;
my %ha;
my %idseq;
open(IN,"<$ARGV[0]");
<IN>;
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	if($a[0]=~/Zotu\d/){
		my $sum=0;
		for(my $i=1;$i<@a;$i++){
			$sum+=$a[$i];
		}
		if($sum != 0){
			$ha{$a[0]}=1;
		}
	}
}
close IN;
my $q=0;
open(IN,"<$ARGV[1]");
while(<IN>){
	if($_=~/^>(.+)/){
		$q=$ha{$1} ? 1 : 0;
	}
	if($q==1){
		print $_;
	}
}
	
