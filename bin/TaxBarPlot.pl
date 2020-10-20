#!/usr/bin/perl -w
#usage: perl TaxBarPlot.pl -top 11 order_throat throat_attack.freq throat_recovery.freq #(attack first)
use strict;
use Getopt::Long;
my %genus;
my $n=0;
my @sample=();
my %ha;
# set options
my $top=10;
my $out="bar.tmp";
GetOptions(
	"top=f"=>\$top,
	"out=s"=>\$out
	);

# load cluster 
open(IN,"<$ARGV[0]");
while(<IN>){
	chomp $_;
	push(@sample,$_);
}
close IN;

# get genus
my $abundant=$top+2;
`head -$abundant $ARGV[1] > recovery_genus`;
`head -$abundant $ARGV[2] > attack_genus`;
foreach my $i ("recovery_genus","attack_genus"){
	open(IN,"<$i");
	<IN>;
	while(<IN>){
		my @a=split("\t",$_);
		$genus{$a[0]}=1;
	}
	close IN;
}
`rm recovery_genus attack_genus`;

# get sample
open(IN,"<$ARGV[1]");
open(OUT,">barplot.tmp");
my $head=<IN>;chomp $head;
my %unclass;
my @a=split("\t",$head);
for(my $i=1;$i<@a;$i++){
	$ha{$a[$i]}=$i;
}
my @head=map($a[$ha{$_}],@sample);
print OUT "$a[0]\t".join("\t",@head)."\n";
while(<IN>){
	chomp $_;
	my @b=split("\t",$_);
	if($genus{$b[0]}){
		if($b[0] ne "unclassified"){
			my @genus=map($b[$ha{$_}],@sample);
			print OUT "$b[0]\t".join("\t",@genus)."\n";
		}else{
			my @unclass=map($b[$ha{$_}],@sample);
			$unclass{$b[0]}=join("\t",@unclass);
		}
	}
}
print OUT "unclassified\t$unclass{unclassified}\n";
close OUT;
close IN;
`Transpose.pl barplot.tmp > del.log`;
open(IN,"<del.log");
open(OUT,">forpython");
my @b=split("\t",<IN>);
$b[0]="ID";
$b[-1]="others\tunclassified\n";
print OUT join("\t",@b);
while(<IN>){
	my $sum=0;
	chomp $_;
	my @c=split("\t",$_);
	for(my $i=1;$i<@c-1;$i++){
		$sum+=$c[$i];
	}
	my $other=100-$sum-$c[-1];
	my $an=sprintf("%.3f",$other);
	$c[-1]="$an\t$c[-1]\n";
	print OUT join("\t",@c);
}
close IN;
close OUT;
$top=0+keys(%genus)-1;
`mv forpython $out`;
`rm barplot.tmp`;
`rm del.log`;
`TaxBarPlot.py $out $top`;










		


