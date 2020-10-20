#!/usr/bin/perl -w
#usage: perl classify.pl -t attack Nose_Info zotuFilter0.1.freq > nose_attack.freq
use strict;
use Getopt::Long;
my %ha;
my %sort;
my @sample=();
#set option
my $t="recovery";
GetOptions(
	"t=s"=>\$t
	);

# load sample ID into hash
open(IN,"<$ARGV[0]");
<IN>;
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	if($a[5] eq $t){
		$ha{$a[0]}=1;
	}
}
close IN;

open(IN,"<$ARGV[1]");
my $head=<IN>; chomp $head;
my @a=split("\t",$head);
for (my $i=1;$i<@a;$i++){
	if($ha{$a[$i]}){
		push (@sample,$i);
	}
}
my @ax=map($a[$_],@sample);
print "$a[0]\t".join("\t",@ax)."\n";
while(<IN>){
	my $sum=0;
	chomp $_;
	my @b=split("\t",$_);
	my @an=map($b[$_],@sample);
	foreach my $j(@an){
		$sum+=$j;
	}
	my $line="$b[0]\t".join("\t",@an)."\n";
	$sort{$line}=$sum;
}
foreach my $k (sort {$sort{$b}<=>$sort{$a}}keys(%sort)){
	print $k;
}






