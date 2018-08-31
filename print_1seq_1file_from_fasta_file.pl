# August 8th 2017
# Print each sequence in a fasta file into a file

#! /usr/perl/bin -w
use strict;

my $path="/home/mnguyen/Research/PathwayTools_v21";
my $filein_fasta="NRRL3_scaffolds_wf.fna";
my $folderout="Chromosomal_seqs";

mkdir "$path/$folderout";

my $id="";
my$seq="";
open(FASTA,"<$path/$filein_fasta") || die "Cannot open file $filein_fasta";
while (<FASTA>)
{
	$_=~s/\s*$//;
	if ($_=~/^\>/)
	{
		if ($seq)
		{
			$seq=uc($seq);
			my $fileout=$id.".fna";
			open(Out,">$path/$folderout/$fileout") || die "Cannot open file $fileout";
			print Out ">$id\n$seq\n";
			close(Out);
			$id="";$seq="";
		}
		$id=$_;
		$id=~s/^\>//;
	}else{$_=~s/\s*//g;$seq=$seq.$_;}
}
$seq=uc($seq);
my $fileout=$id.".fna";
open(Out,">$path/$folderout/$fileout") || die "Cannot open file $fileout";
print Out ">$id\n$seq\n";
close(Out);
close(FASTA);