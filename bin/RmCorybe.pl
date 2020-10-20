#!/usr/bin/perl -w
#usage:perl RmCorybe.pl ../zotu/nose_cluster ../zotu/Nose_Info ../contamination/zotutab_nose_genus_rare.txt > zotutab_coryne.txt
use strict;
my %ha;
my %pid;
my %rm;
my @sample=();
open(IN,"<$ARGV[0]");
my @a=split("\t",<IN>);chomp $a[-1];
for(my $i=1;$i<@a;$i++){
	$ha{$a[$i]}=1;
}
close IN;

open(IN,"<$ARGV[1]");
<IN>;
while(<IN>){
	chomp $_;
	my @b=split("\t",$_);
	if($ha{$b[0]}){
		$pid{$b[5]}=1;
	}
}
seek(IN,0,0);
<IN>;
while(<IN>){
	chomp $_;
	my @b=split("\t",$_);
	if($pid{$b[5]}){
		$rm{$b[0]}=1;
	}
}
close IN;

open(IN,"<$ARGV[2]");
my $head=<IN>;chomp $head;
my @c=split("\t",$head);
for(my $i=1;$i<@c;$i++){
	if($rm{$c[$i]}){
		push(@sample,$i);
	}
}
my @h=map($c[$_],@sample);
print "$c[0]\t".join("\t",@h)."\n";
while(<IN>){
	chomp $_;
	my @d=split("\t",$_);
	my @e=map($d[$_],@sample);
	print "$d[0]\t".join("\t",@e)."\n";
}




























