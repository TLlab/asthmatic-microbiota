#!/usr/bin/perl -w
use strict;
my %ha;
my %idseq;
open(IN,"<$ARGV[0]");
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	$ha{$a[0]}=1;
}
close IN;

open(IN,"<$ARGV[1]");
my $id=<IN>;
my $seq="";
while(<IN>){
	if($_=~/^>/){
		my $key=substr($id,1);chomp $key;
		if($ha{$key}){
			$idseq{$key}=$seq;
		}
		$seq="";
		$id=$_;
	}else{
		chomp $_;
		$seq.=$_;
	}
}
my $a=substr($id,1);chomp $a;
if($ha{$a}){
	$idseq{$a}=$seq;
}
foreach my $k(keys(%idseq)){
	print ">$k\n$idseq{$k}\n";
}
