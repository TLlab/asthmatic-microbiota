#!/usr/bin/perl -w
open(IN,"<$ARGV[0]");
while(<IN>){
	chomp $_;
	$id=$_;
	$seq=<IN>;
	$l=length($seq);
	if ($l<$ARGV[1]){
		print "$id\n$seq";
	}
}
