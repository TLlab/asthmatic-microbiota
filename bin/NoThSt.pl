#!/usr/bin/perl -w
#usage:perl NoThSt.pl zotutab_n16s_comb.txt
use strict;
my %ha;
open(IN,"<$ARGV[0]");
open(OUT1,">nose.tmp");
open(OUT2,">throat.tmp");
open(OUT3,">stool.tmp");
my @throat=();
my @nose=();
my @stool=();
my $head=<IN>;chomp $head;
my @a=split("\t",$head);
for(my $i=1;$i<@a;$i++){
	if($a[$i]=~/T/){
		push(@throat,$i);
	}elsif($a[$i]=~/N/){
		push(@nose,$i);
	}else{
		push(@stool,$i);
	}
}
seek(IN,0,0);
while(<IN>){
	chomp $_;
	my @b=split("\t",$_);
	my @N=map($b[$_],@nose);
	my @T=map($b[$_],@throat);
	my @S=map($b[$_],@stool);
	print OUT1 "$b[0]\t".join("\t",@N)."\n";
	print OUT2 "$b[0]\t".join("\t",@T)."\n";
	print OUT3 "$b[0]\t".join("\t",@S)."\n";
}
close IN;
close OUT1;
close OUT2;
close OUT3;
`FilterZeroOtutable.pl nose.tmp > zotutab_nose.txt`;
`FilterZeroOtutable.pl throat.tmp > zotutab_throat.txt`;
`FilterZeroOtutable.pl stool.tmp > zotutab_stool.txt`;
`rm nose.tmp`;
`rm throat.tmp`;
`rm stool.tmp`;


