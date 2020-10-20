#!/usr/bin/perl -w
#usage: perl shannon.pl sample_mapping_NA.txt Rmcoryne_nose_recovery.shannon Rmcoryne_nose_attack.shannon sample_mapping_NR.txt > test
use strict;
my %id;
my %ha;
open(IN,"<$ARGV[0]");
<IN>;
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	$id{$a[5]}=$a[0];
}
close IN;

open(IN,"<$ARGV[1]");
<IN>;
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	$ha{$a[0]}=$a[1];
}
close IN;

open(IN,"<$ARGV[2]");
<IN>;
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	$ha{$a[0]}=$a[1];
}
close IN;

open(IN,"<$ARGV[3]");
<IN>;
print "ID\tRecovery\tAttack\n";
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	if($ha{$a[0]}){
		print "$a[0]-$id{$a[5]}\t$ha{$a[0]}\t$ha{$id{$a[5]}}\n";
	}
}


