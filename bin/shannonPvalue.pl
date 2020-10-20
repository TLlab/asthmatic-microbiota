#!/usr/bin/perl -w
use strict;
open(IN,"<$ARGV[0]");
my @att=();
my @rec=();
<IN>;
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	push(@rec,$a[1]);
	push(@att,$a[2]);
}
my $a1=join(",",@rec);
my $a2=join(",",@att);
print "$a1\n";
print "$a2\n";

my $an=`PairedWilcoxonTest.py $a1 $a2`;
print "$an\n";
