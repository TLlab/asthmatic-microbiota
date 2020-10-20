#!/usr/bin/perl -w
#usage: RmNAsample.pl
use strict;

use Getopt::Long;
my %ha;
my @sample=();
my $l=0;

# set options
my $group="igeclass";
GetOptions(
	"group=s"=>\$group
	);


open(IN,"<$ARGV[0]");
my $line=<IN>;
my @h=split("\t",$line);chomp $h[-1];
for(my $i=1;$i<@h;$i++){
	if($h[$i] eq  $group){
		$l=$i;
	}
}
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	if($a[$l]eq"NA"){
		$ha{$a[0]}=1;
	}
}
close IN;

open(IN,"<$ARGV[1]");
my $head=<IN>;chomp $head;
my @a=split("\t",$head);
for(my $i=1;$i<@a;$i++){
	if(!$ha{$a[$i]}){
		push (@sample,$i);
	}
}
my @he=map($a[$_],@sample);
print "$a[0]\t".join("\t",@he)."\n";
while(<IN>){
	chomp $_;
	my @b=split("\t",$_);
	if(!$ha{$b[0]}){
		my @file=map($b[$_],@sample);
		print "$b[0]\t".join("\t",@file)."\n";
	}
}
