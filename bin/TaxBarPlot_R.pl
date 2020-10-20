#!/usr/bin/perl -w
#usage: perl TaxBatPlot_R.pl Throat_Info throat_recovery.freq bar_throat_attack.txt #(attack first)
use strict;
use Getopt::Long;
my %att;
my %ha;
my %order;
my @genus=();
# set options
my $out="bar_recovery";
GetOptions(
	"out=s"=>\$out
	);

# load cluster 
open(IN,"<$ARGV[0]");
<IN>;
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	if($a[3] eq "recovery"){
		$att{$a[5]}=$a[0];
	}
}
seek(IN,0,0);
<IN>;
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	if($a[3] eq "attack"){
		$ha{$a[0]}=$att{$a[5]};
	}
}
close IN;

# load recovery genus
open(IN,"<$ARGV[2]");
my @r=split("\t",<IN>);chomp $r[-1];
for(my $i=1;$i<@r-2;$i++){
	push(@genus,$r[$i]);
}
close IN;

# get sample
open(IN,"<$ARGV[1]");
open(OUT,">barplot.tmp");
my $head=<IN>;chomp $head;
my %unclass;
print OUT "$head\n";
foreach my $i(@genus){
	while(<IN>){
		chomp $_;
		my @b=split("\t",$_);
		if($b[0] ne "unclassified"){
			if($b[0] eq $i){
				print OUT "$_\n";
			}
		}else{
			$unclass{$b[0]}=$_;
		}
	}
	seek(IN,0,0);
}
print OUT "$unclass{unclassified}\n";
close OUT;
close IN;
`Transpose.pl barplot.tmp > del.log`;
open(IN,"<del.log");
open(OUT,">forpython.tmp");
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
	$order{$c[0]}=join("\t",@c);
	print OUT join("\t",@c);
}
close IN;
close OUT;
open(IN,"<$ARGV[2]");
open(OUT,">forpython");
my $first=<IN>;
print OUT $first;
while(<IN>){
	my @d=split("\t",$_);
	if($ha{$d[0]}){
		print OUT "$order{$ha{$d[0]}}";
	}
}
close IN;
close OUT;
my $top=0+@genus;
`mv forpython $out`;
`rm forpython.tmp`;
`rm barplot.tmp`;
`rm del.log`;
`TaxBarPlot.py $out $top`;










		


