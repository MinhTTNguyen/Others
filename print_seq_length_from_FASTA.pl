=pod
August 28th 2014
This script is to print lengths of sequences from a FASTA input file
=cut

#! /usr/perl/bin -w
use strict;

=pod
print "\nInput current working directory: ";
my $path=<STDIN>;
chomp($path);

print "\nInput FASTA file: ";
my $file_fasta=<STDIN>;
chomp($file_fasta);
=cut

my $path="/home/mnguyen/Research/AOX";
my $file_fasta="Fasta_Imput_AOX.fasta";
my $fileout=substr($file_fasta,0,-6);
$fileout=$fileout."_len_seq.txt";

##################################################################################################
open(In,"<$path/$file_fasta") || die "Cannot open file $file_fasta";
open(Out,">$path/$fileout") || die "Cannot open file $fileout";
print Out "#ID\tLength\tSequence\n";
my $id="";
my $seq="";
while (<In>)
{
	$_=~s/\s*$//;
	if ($_=~/^\>/)
	{
		if ($seq)
		{
			$seq=uc($seq);
			my $len=length($seq);
			$id=~s/\s*$//;
			print Out "$id\t$len\t$seq\n";
			#print Out "$id\t$len\n";
			$seq="";
			$id="";
		}
		
		$id=$_;
		$id=~s/^\>//;
	}else
	{
		$_=~s/\s*//g;
		$seq=$seq.$_;
	}
}
$seq=uc($seq);
my $len=length($seq);
$id=~s/\s*$//;
#print Out "$id\t$len\n";
print Out "$id\t$len\t$seq\n";
close(In);
close(Out);
##################################################################################################