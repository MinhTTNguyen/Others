# February 19th 2016
# remove duplicates in a fasta file (those having the same IDs)

#! /usr/perl/bin -w
use strict;

=pod
print "\nInput fasta file (including path): ";
my $filein=<STDIN>;
chomp($filein);

print "\nInput name of output file (including path): ";
my $fileout=<STDIN>;
chomp($fileout);
=cut

my $filein="/home/mnguyen/Research/For_Marie/AllPMSM.fasta";
my $fileout="/home/mnguyen/Research/For_Marie/AllPMSM_nr.fasta";
my %hash_fasta;

open(In,"<$filein") || die "Cannot open file $filein";
my $id="";
my $seq="";
while (<In>)
{
	$_=~s/\s*$//;
	$_=~s/^\s*//;
	if ($_=~/^\>/)
	{
		if ($seq)
		{
			$seq=uc($seq);
			unless ($hash_fasta{$id}){$hash_fasta{$id}=$seq;}
			$seq="";
			$id="";
		}
		$id=$_;
		$id=~s/^\>//;
	}else{$_=~s/\s*//g;$seq=$seq.$_;}
}
$seq=uc($seq);
unless ($hash_fasta{$id}){$hash_fasta{$id}=$seq;}
close(In);

open(Out,">$fileout") || die "Cannot open file $fileout";
while (my ($k, $v)=each (%hash_fasta))
{
	print Out ">$k\n$v\n";
}
close(Out);