#!/usr/bin/perl -w
use strict;
open(IN,"<$ARGV[0]");
<IN>;
while(<IN>){
	chomp $_;
	my $sum=0;
	my @a=split("\t",$_);
	for (my $i=1;$i<@a;$i++){
		$sum+=$a[$i];
	}
	print "$a[0]\t$sum\n";
}
