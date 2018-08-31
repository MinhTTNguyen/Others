# December 1st 2011
# The input is a list of gene IDs
# Output: FASTA file containing the corresponding sequences
# This cript does not report IDs that are not found in the fasta file

# modified on June 5th 2013, print out IDs that sequences are not available

#! /usr/perl/bin -w
use strict;

print "\nInput path to the files:";
my $path=<STDIN>;
chomp($path);

print "\nInput file containing list of gene IDs:";
my $filein=<STDIN>;
chomp($filein);

print "\nInput FASTA file containing gene sequences:";
my $fasta_file=<STDIN>;
chomp($fasta_file);

my $fileout=substr($filein,0,-4);
my $empty_IDs=$fileout."_empty_IDs.txt";
$fileout=$fileout.".fasta";

############################################################
open(Fasta_file,"<$path/$fasta_file") || die "Cannot open file $fasta_file";
my %fasta;
my $fasta_key="";
my $seq="";

while (<Fasta_file>)
{
	my $fasta_line=$_;
	$fasta_line=~s/\s*$//;
	if ($fasta_line=~/^\>/)
	{
		if ($seq)
		{
			$seq=~s/\s*//g;
			$seq=uc($seq);
			$fasta{$fasta_key}=$seq;
			$seq="";
			$fasta_key="";
		}
		$fasta_key=$fasta_line;
		$fasta_key=~s/\>//;
		$fasta_key=~s/\s*//g;
	}else{$seq=$seq.$fasta_line;}
}
$seq=~s/\s*//g;$seq=uc($seq);
$fasta{$fasta_key}=$seq;
close (Fasta_file);
################################################################
open(In,"<$path/$filein")|| die "Cannot open file $filein";
open(Out,">$path/$fileout")|| die "Cannot open file $fileout";
open(Empty,">$path/$empty_IDs")|| die "Cannot open file $empty_IDs";
while (<In>)
{
	# Spoth2p4_010268
	$_=~s/\s*//g;
	my $sequence=$fasta{$_};
	if ($sequence){print Out ">$_\n$sequence\n";}
	else {print Empty "$_\n";}
}

close(In);
close(Out);
close(Empty);