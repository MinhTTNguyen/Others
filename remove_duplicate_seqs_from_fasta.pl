#! /usr/perl/bin -w
use strict;

my $filein="/home/mnguyen/Research/Aspergillus_exoproteomes/Clustering/FASTA_with_added_prots_corrected_models/GH13.fasta";
my $fileout="/home/mnguyen/Research/Aspergillus_exoproteomes/Clustering/FASTA_with_added_prots_corrected_models/GH13_nr.fasta";
my %hash_seq;
open(In,"<$filein") || die "Cannot open file $filein";
open(Out,">$fileout") || die "Cannot open file $fileout";
my $id="";
my $seq="";
while (<In>)
{
	$_=~s/^\s*//;
	$_=~s/\s*$//;
	if ($_=~/^\>/)
	{
		if ($seq)
		{
			$seq=uc($seq);
			if ($hash_seq{$seq}){$hash_seq{$seq}=$hash_seq{$seq}.";".$id;}
			else{$hash_seq{$seq}=$id;}
			$id="";
			$seq="";
		}
		$id=$_;
		$id=~s/^\>//;
	}else{$_=~s/\s*//g;$seq=$seq.$_;}
}

$seq=uc($seq);
if ($hash_seq{$seq}){$hash_seq{$seq}=$hash_seq{$seq}.";".$id;}
else{$hash_seq{$seq}=$id;}
$id="";$seq="";

while (my ($k, $v)=each(%hash_seq))
{
	print Out ">$v\n$k\n";
}
close(In);
close(Out);
