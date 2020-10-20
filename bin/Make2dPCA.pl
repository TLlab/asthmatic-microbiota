#!/usr/bin/perl -w
# usage: perl JoinGroupforPCA.pl ../nose_attack_Info nose_attack_rare/weighted_unifrac_pc.txt > del
use strict;
use Getopt::Long;
my %ha;
my $g="igeclass";
my $n=0;
GetOptions(
	"g=s"=>\$g
	);
	
open(IN,"<$ARGV[0]");
my $head=<IN>;chomp $head;
my @h=split("\t",$head);
for(my $i=0;$i<@h;$i++){
	if($h[$i] eq $g){
		$n=$i;
	}
}
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	$ha{$a[0]}=$a[$n];
}
close IN;

open(IN,"<$ARGV[1]");
open(OUT,">2d_pca.log");
print OUT"Site\tPC1\tPC2\tgroup\n";
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	if($ha{$a[0]}){
		print OUT"$a[0]\t$a[1]\t$a[2]\t$ha{$a[0]}\n";
	}
}
close IN;
`ellipse.r 2d_pca.log`;
`rm 2d_pca.log`;
