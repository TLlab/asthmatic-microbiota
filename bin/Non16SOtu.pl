#!/usr/bin/perl -w
# usage : Non16SOtu.pl blast otus

use strict;
use Getopt::Long;


# set parameters

my $maxe="1e-5";

GetOptions("maxe=s" => \$maxe);


# load blast results, select and output non-16S OTUs

my %otuq=();
my @non16sotu=();

open(IN,"<$ARGV[0]") || die "open $ARGV[0]: $!\n";

while(<IN>) {
    if($_=~/^Query= (.+)/) {
	my $otu=$1;
	$otuq{$otu}=1;
	while(<IN>) {
	    if($_=~/^Sequences producing significant alignments/) {
		<IN>;
		last;
	    }
	}
	my %tq=();
	while(<IN>) {
	    if($_ eq "\n") {
		last;
	    }
	    my ($t)=$_=~/^(\S+)/;
	    my ($e)=$_=~/^.{75}(\S+)/;
	    if($e<$maxe) {
		$tq{$t}=1;
	    }
	}
	<IN>;
	my $td="";
	while(<IN>) {
	    if($_=~/^Query=/) {
		seek(IN,-length($_),1);
		last;
	    }
	    if($_=~/^>(\S+) (.+)/) {
		if($tq{$1}) {
		    $td.=$2."\n";
		}
	    }
	}
	if($td!~/16S/) {
	    push(@non16sotu,$otu);
	    #print "$otu\n$td\n";
	}
	
    }
}

foreach my $o (@non16sotu) {
    print "$o\tnon-16S\n";
}


# output the OTUs without hit

open(IN,"<$ARGV[1]") || die "open $ARGV[1]: $!\n";

while(<IN>) {
	chomp $_;
    my @a=split("\t",$_);
    if(!$otuq{$a[0]}) {
	print "$a[0]\tno_hit\n";
    }
}
close IN;
