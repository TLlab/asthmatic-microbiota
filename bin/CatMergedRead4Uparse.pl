#!/usr/bin/perl -w
# usage : CatMergedRead4Uparse.pl file.txt

use strict;


# concatenate merged reads

open(IN,"<$ARGV[0]") || die "open $ARGV[0]: $!\n";

while(<IN>) {
    chomp $_;
    open(INf,"<$_") || die "open $_: $!\n";
    my ($s)=$_=~/(.+)/;
    my $i=0;
    while(<INf>) {
	$i++;
	print "\@$s.$i\n";
	$_=<INf>;
	print $_;
	<INf>;
	print "+\n";
	$_=<INf>;
	print $_;
    }
    close INf;
}
close IN;
