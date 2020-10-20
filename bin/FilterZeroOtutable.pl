#!/usr/bin/perl -w
#usage: FilterZeroOtutable.pl otutab.txt

use strict;

# load zotutable and filer otu which contained zero in all sample
open(IN,"<$ARGV[0]");
my $head=<IN>;
print $head;
while(<IN>){
	my $max=0;
	chomp $_;
	my @a=split("\t",$_);
	for(my $i=1;$i<@a;$i++){
		if($a[$i]>$max){
			$max=$a[$i];
		}
	}
	if($max!=0){
		print "$_\n";
	}
}
