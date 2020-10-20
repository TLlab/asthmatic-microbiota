#!/usr/bin/perl -w
my %ha;
open(IN,"<$ARGV[0]");
while(<IN>){
	my @a=split("\t",$_);
	$ha{$a[1]}=$a[2];
}
close IN;

open(IN,"<$ARGV[1]");
#my $head=<IN>;
#print $head;
while(<IN>){
	chomp $_;
	my @a=split("\t",$_);
	for(my $i=1;$i<@a;$i++){
		$a[$i]=$ha{$a[$i]};
	}
	print join("\t",@a)."\n";
}
