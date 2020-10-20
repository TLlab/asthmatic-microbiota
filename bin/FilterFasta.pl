#!/usr/bin/perl -w
# usage : FilterFasta.pl otus fa

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


# load fasta and filter

open(IN,"<$ARGV[1]") || die "open $ARGV[1]: $!\n";

my $q=1;
while(<IN>) {
    if($_=~/^>(.+)/) {
	$q = $otufq{$1} ? 0 : 1;
    }
    if($q==1) {
	print $_;
    }
}
close IN;
