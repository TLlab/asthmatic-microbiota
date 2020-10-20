#!/usr/bin/perl -w
#usgae: perl AddFastaSize.pl zotutab_n16s_rare.txt zotus_n16s.fa > del
use strict;
my %ha;
open(IN,"<$ARGV[0]");
<IN>;
<IN>;
while(<IN>){
	chomp $_;
	my $sum=0;
	my @a=split("\t",$_);
	for(my $i=1;$i<@a;$i++){
		$sum+=$a[$i];
	}
	$ha{">$a[0]"}=$sum;
}
close IN;

open(IN,"<$ARGV[1]");
while(<IN>){
	chomp $_;
	if($_=~/^>/ && $ha{$_}){
		print "$_;size=$ha{$_}\n";
	}elsif($_=~/^>/){
		print "$_;size=0\n";
	}else{
		print "$_\n";
	}
}
		
