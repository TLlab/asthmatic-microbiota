#!/usr/bin/perl -w
#usage: zotuTOspecies.pl zotus.rdp zotutab_comb.txt > zotutab_genus.txt
use strict;
my %ha;
my %rdp;
open(IN,"<$ARGV[0]");
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	if($a[-1]>=0.8){
		$ha{$a[0]}=$a[-3];
	}else{
		$ha{$a[0]}="unclassified";
	}
}
close IN;
open(IN,"<$ARGV[1]");
my $head=<IN>;
print $head;
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	if($ha{$a[0]}){
		if(!$rdp{$ha{$a[0]}}){
			$a[0]=$ha{$a[0]};
			my $an=join("\t",@a);
			$rdp{$a[0]}=$an;
		}else{
			my @b=split("\t",$rdp{$ha{$a[0]}});
			for(my $i=1;$i<@b;$i++){
				$b[$i]=$b[$i]+$a[$i];
			}
			$b[0]=$ha{$a[0]};
			my $an=join("\t",@b);
			$rdp{$ha{$a[0]}}=$an;
		}
	}
}
foreach my $k(keys(%rdp)){
	print "$rdp{$k}\n";
}
