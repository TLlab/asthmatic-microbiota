#!/usr/bin/perl -w
#usage:RemoveSample.pl -rs TA6,TR6,SA4,SR4,TA19,TR19 zotutab.txt > tmp
use strict;
use Getopt::Long;
my %ha;
my @sample=();
my $rs="TA6,TR6,TA19,TR19,SA4,SR4";
GetOptions(
	"rs=s"=>\$rs
	);
my @a=split(",",$rs);
foreach my $i(@a){
	$ha{$i}=1;
}
open(IN,"<$ARGV[0]");
my $head=<IN>;chomp $head;
my @b=split("\t",$head);
for(my $i=0;$i<@b;$i++){
	if(!$ha{$b[$i]}){
		push(@sample,$i);
	}
}
seek(IN,0,0);
while(<IN>){
	chomp $_;
	my @c=split("\t",$_);
	my @d=map($c[$_],@sample);
	print join("\t",@d)."\n";
}


