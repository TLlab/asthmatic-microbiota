#!/usr/bin/perl -w
# usage : FilterOtuTable.pl otus otutab.txt

use strict;


# load OTUs to be filtred

my %otufq=();

open(IN,"<$ARGV[0]") || die "open $ARGV[0]: $!\n";
while(<IN>) {
	chomp $_;
    my @a=split("\t",$_);
    $otufq{$a[0]}=1;
}
close IN;


# load OTU table and output non-filtered OTUs

open(IN,"<$ARGV[1]") || die "open $ARGV[1]: $!\n";

$_=<IN>; print $_;

while(<IN>) {
    my @a=split("\t",$_);
    if(!$otufq{$a[0]}) {
	print $_;
    }
}
close IN;
