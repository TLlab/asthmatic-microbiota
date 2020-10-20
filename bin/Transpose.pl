#!/usr/bin/perl -w
use strict;
my @mat=();
open(IN,"<$ARGV[0]");
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	push(@mat,\@a);
}
close IN;
my @tm=();
for(my $i=0;$i<@mat;$i++){
	for(my $j=0;$j<@{$mat[$i]};$j++){
		$tm[$j][$i]=$mat[$i][$j];
	}
}

for(my $x=0;$x<@tm;$x++){
	print join("\t",@{$tm[$x]})."\n";
}
