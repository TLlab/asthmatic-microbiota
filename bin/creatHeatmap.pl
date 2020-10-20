#!/usr/bin/perl -w
#usage: perl creatHeatmap.pl throat_recovery.freq > throat_recovery.heatmap
use strict;
use Getopt::Long;
my %ha;

# set options
my $top=40;
my $out="demo";
GetOptions(
	"top=i"=>\$top,
	"out=s"=>\$out
	);
$top=$top+2;
`head -n $top $ARGV[0] > del.he`;
open(IN,"<del.he");
open(OUT,">$out");
print OUT"species\tsample\trdp_ard\n";
my $head=<IN>;chomp $head;
my @a=split("\t",$head);
while(<IN>){
	chomp $_;
	my @b=split("\t",$_);
	if($b[0] ne "unclassified"){
		for(my $i=1;$i<@b;$i++){
			my $root=$b[$i];
			print OUT"$b[0]\t$a[$i]\t$root\n";
		}
	}
}
close IN;
close OUT;
`rm del.he`;
`Heatmap.py $out`;
`rm $out`;

