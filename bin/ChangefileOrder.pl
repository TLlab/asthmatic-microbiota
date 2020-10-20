#!/usr/bin/perl -w
#usage: ChangefileOrder.pl weighted_unifrac_dm.txt nose_attack_Info > del
use strict;
my %ha;
my @sam=();
open(IN,"<$ARGV[0]");
my $head=<IN>;chomp $head;
my @a=split("\t",$head);
for(my $i=1;$i<@a;$i++){
	push(@sam,$a[$i]);
}
close IN;

open(IN,"<$ARGV[1]");
my $oo=<IN>;
print $oo;
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	$ha{$a[0]}=$_;
}
foreach my $i(@sam){
	print "$ha{$i}\n";
}
