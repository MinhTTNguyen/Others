# November 29th 2012
# This script is to print out transcript sequences not begun by "ATG"
# Input fasta file containing coding sequences
# Output fasta file containing sequences not begun by "ATG" 

#! C:\Perl\bin -w
use strict;

print "\nInput path to the files:";
my $path=<STDIN>;
chomp($path);

print "\nInput fasta file containing coding sequences:";
my $filein=<STDIN>;
chomp($filein);

my $fileout=substr($filein,0,-6);
my $fileout1=$fileout."_begun_by_ATG.fasta";
my $fileout2=$fileout."_ID_ATG_status.txt";
$fileout=$fileout."_not_begun_by_ATG.fasta";

open(In,"<$path\\$filein") || die "Cannot open file $filein";
open(Out,">$path\\$fileout") || die "Cannot open file $fileout";
open(Out1,">$path\\$fileout1") || die "Cannot open file $fileout1";
open(Out2,">$path\\$fileout2") || die "Cannot open file $fileout2";
my $id;
my $seq;
while (<In>)
{
	chomp($_);
	if ($_=~/^\>/)
	{
		if ($seq)
		{
			my $first_codon=substr($seq,0,3);
			$first_codon=uc($first_codon);
			if ($first_codon ne "ATG"){print Out ">$id\n$seq\n";print Out2 "$id\tno ATG\n";}
			else {print Out1 ">$id\n$seq\n"; print Out2 "$id\tATG\n";}
		}
		$id=$_;
		$id=~s/^\>//;
		$seq="";
	}else {$_=~s/\s*//g;$seq=$seq.$_;}
}
my $first_codon=substr($seq,0,3);
$first_codon=uc($first_codon);
if ($first_codon ne "ATG"){print Out ">$id\n$seq\n"; print Out2 "$id\tno ATG\n";}
else {print Out1 ">$id\n$seq\n"; print Out2 "$id\tATG\n";}

close(In);
close(Out);
close(Out1);